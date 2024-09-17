local _, ns = ...;

local CONFIG_MAX_COOL = 10;

local AFUF = CreateFrame("FRAME", nil, UIParent);

local function HideCombatText()
    if ns.options.HideCombatText then
        -- 데미지 숫자 숨기기
        PlayerFrame:UnregisterEvent("UNIT_COMBAT");
        TargetFrame:UnregisterEvent("UNIT_COMBAT");
        PetFrame:UnregisterEvent("UNIT_COMBAT");
    end
end

local function HideTargetBuffs()
    -- TargetFrame의 Buff Debuff를 숨긴다.
    if ns.options.HideDebuff then
        TargetFrame:UnregisterEvent("UNIT_AURA");
        local function _UpdateBuffAnchor(self, buff)
            --For mirroring vertically
            buff:Hide();
        end

        hooksecurefunc("TargetFrame_UpdateBuffAnchor", _UpdateBuffAnchor);
        hooksecurefunc("TargetFrame_UpdateDebuffAnchor", _UpdateBuffAnchor);
    end
end

local function HideTargetCastBar()
    if ns.options.HideCastBar then
        --TargetCastBar 를 숨긴다.
        TargetFrame.spellbar.showCastbar = false;
    end
end

local function ShowAggro()
    if not InCombatLockdown() then
        if ns.options.ShowAggro then
            --TargetCastBar 를 숨긴다.
            SetCVar("threatShowNumeric", "1");
        else
            SetCVar("threatShowNumeric", "0");
        end
    end
end

local function HideClassBar()
    if not ns.options.HideClassBar then
        return;
    end
    --주요 자원바 숨기기
    local ClassBarOnShow = function(frame)
        frame:Hide()
    end

    local frame
    local _, class = UnitClass("player")

    if PlayerFrame.classPowerBar then
        frame = PlayerFrame.classPowerBar
    elseif class == "DEATHKNIGHT" then
        frame = RuneFrame
    elseif class == "EVOKER" then
        frame = EssencePlayerFrame
    end

    if (frame) then
        frame:Hide();
        frame:HookScript("OnShow", ClassBarOnShow);
    end

    frame = TotemFrame;

    if (frame) then
        frame:Hide();
        frame:HookScript("OnShow", ClassBarOnShow);
    end
end

local frames = {
    ["player"] = PlayerFrame.PlayerFrameContent.PlayerFrameContentMain.HealthBarsContainer.HealthBar,
    ["target"] = TargetFrame.TargetFrameContent.TargetFrameContentMain.HealthBarsContainer.HealthBar,
    ["targettarget"] = TargetFrameToT.HealthBar,
}

local function UpdateHealthBar(unit)
    if not ns.options.ShowClassColor then
        return;
    end

    if not unit then
        return;
    end

    if not UnitExists(unit) then
        return;
    end

    --Healthbar 직업 색상
    local function updateHealthColor(frame)
        if not (frame) then
            return;
        end

        if (frame:IsForbidden()) then
            return;
        end

        local unit = frame.unit;

        local r, g, b;

        if UnitIsPlayer(unit) then
            local _, englishClass = UnitClass(unit);
            local classColor = RAID_CLASS_COLORS[englishClass];

            if (classColor) then
                r, g, b = classColor.r, classColor.g, classColor.b;
                frame:SetStatusBarDesaturated(true);
                frame:SetStatusBarColor(r, g, b);
            else
                frame:SetStatusBarColor(0, 1, 0);
            end
        else
            frame:SetStatusBarColor(0, 1, 0);
        end
    end

    local statusbar = frames[unit];
    updateHealthColor(statusbar);
end

local function asCooldownFrame_Clear(self)
    self:Clear();
end

local function asCooldownFrame_Set(self, start, duration, enable, modRate)
    if enable and enable ~= 0 and start > 0 and duration > 0 then
        self:SetCooldown(start, duration, modRate);
    else
        asCooldownFrame_Clear(self);
    end
end

--AuraUtil
local PLAYER_UNITS = {
    player = true,
    vehicle = true,
    pet = true
};

local DispellableDebuffTypes =
{
    Magic = true,
    Curse = true,
    Disease = true,
    Poison = true
};


local AuraUpdateChangedType = EnumUtil.MakeEnum(
    "None",
    "Debuff",
    "Buff",
    "PVP",
    "Dispel"
);

local UnitFrameDebuffType = EnumUtil.MakeEnum(
    "BossDebuff",
    "BossBuff",
    "PriorityDebuff",
    "NonBossRaidDebuff",
    "NonBossDebuff"
);



local AuraFilters =
{
    Helpful = "HELPFUL",
    Harmful = "HARMFUL",
    Raid = "RAID",
    IncludeNameplateOnly = "INCLUDE_NAME_PLATE_ONLY",
    Player = "PLAYER",
    Cancelable = "CANCELABLE",
    NotCancelable = "NOT_CANCELABLE",
    Maw = "MAW",
};

local function CreateFilterString(...)
    return table.concat({ ... }, '|');
end

local function DefaultAuraCompare(a, b)
    local aFromPlayer = (a.sourceUnit ~= nil) and UnitIsUnit("player", a.sourceUnit) or false;
    local bFromPlayer = (b.sourceUnit ~= nil) and UnitIsUnit("player", b.sourceUnit) or false;
    if aFromPlayer ~= bFromPlayer then
        return aFromPlayer;
    end

    if a.canApplyAura ~= b.canApplyAura then
        return a.canApplyAura;
    end

    return a.auraInstanceID < b.auraInstanceID;
end

local function ForEachAuraHelper(unit, filter, func, usePackedAura, continuationToken, ...)
    -- continuationToken is the first return value of C_UnitAuras.GetAuraSlots()
    local n = select('#', ...);
    for i = 1, n do
        local slot = select(i, ...);
        local done;
        local auraInfo = C_UnitAuras.GetAuraDataBySlot(unit, slot);
        if usePackedAura then
            done = func(auraInfo);
        else
            done = func(AuraUtil.UnpackAuraData(auraInfo));
        end
        if done then
            -- if func returns true then no further slots are needed, so don't return continuationToken
            return nil;
        end
    end
    return continuationToken;
end
local function ForEachAura(unit, filter, maxCount, func, usePackedAura)
    if maxCount and maxCount <= 0 then
        return;
    end
    local continuationToken;
    repeat
        -- continuationToken is the first return value of UnitAuraSltos
        continuationToken = ForEachAuraHelper(unit, filter, func, usePackedAura,
            C_UnitAuras.GetAuraSlots(unit, filter, maxCount, continuationToken));
    until continuationToken == nil;
end


local filter = CreateFilterString(AuraFilters.Harmful, AuraFilters.IncludeNameplateOnly);

local function CreateDebuffFrame()
    if not AFUF.debuffframe then
        if not (TargetFrame and TargetFrame.TargetFrameContainer and TargetFrame.TargetFrameContainer.Portrait and TargetFrame.TargetFrameContainer.FrameTexture) then
            return;
        end

        if TargetFrame:IsForbidden() then
            return;
        end

        local parent = TargetFrame.TargetFrameContainer;
        local portrait = parent.Portrait;

        AFUF.debuffframe = CreateFrame("Button", nil, AFUF, "asFUFDebuffFrameTemplate");
        local frame = AFUF.debuffframe;
        frame:EnableMouse(false);
        frame:SetParent(parent);
        frame:SetFrameStrata(parent:GetFrameStrata());
        frame:SetFrameLevel(parent:GetFrameLevel());
        frame:ClearAllPoints();
        frame:SetAllPoints(portrait);
        frame.icon:SetMask("Interface\\CHARACTERFRAME\\TempPortraitAlphaMask");
        frame.cooldown:SetSwipeTexture("Interface\\CHARACTERFRAME\\TempPortraitAlphaMaskSmall")
        frame.cooldown:SetDrawEdge(false);
        frame.cooldown:SetSwipeColor(0, 0, 0, 0.5);
        frame.cooldown:SetUseCircularEdge(true);
        frame.cooldown:SetHideCountdownNumbers(false);
        local l, s = parent.FrameTexture:GetDrawLayer();
        frame.icon:SetDrawLayer(l, s);
        parent.FrameTexture:SetDrawLayer(l, s + 1);

        if not frame:GetScript("OnEnter") then
            frame:SetScript("OnEnter", function(s)
                if s.auraInstanceID then
                    GameTooltip_SetDefaultAnchor(GameTooltip, s);
                    GameTooltip:SetUnitDebuffByAuraInstanceID("target", s.auraInstanceID, filter);
                end
            end)
            frame:SetScript("OnLeave", function()
                GameTooltip:Hide();
            end)
        end
    end
end

local activeDebuffs = nil;
local AuraUpdateChangedType = EnumUtil.MakeEnum(
    "None",
    "Debuff",
    "Buff"
);

local function ProcessAura(aura)
    if aura == nil or aura.icon == nil then
        return AuraUpdateChangedType.None;
    end

    if aura.isHarmful and aura.nameplateShowAll and aura.duration > 0 and aura.duration <= CONFIG_MAX_COOL then
        if not ns.ShowOnlyMine[aura.spellId] then
            activeDebuffs[aura.auraInstanceID] = aura;
            return AuraUpdateChangedType.Debuff;
        end
    end

    return AuraUpdateChangedType.None;
end

local function ParseAllAuras()
    if activeDebuffs == nil then
        activeDebuffs = TableUtil.CreatePriorityTable(DefaultAuraCompare,
            TableUtil.Constants.AssociativePriorityTable);
    else
        activeDebuffs:Clear();
    end

    local function HandleAura(aura)
        ProcessAura(aura);
        return false;
    end

    local batchCount = nil;
    local usePackedAura = true;
    ForEachAura("target", filter, batchCount, HandleAura, usePackedAura);
end

local function UpdateAuraFrames(auraList, numAuras)
    if not ns.options.ShowPotraitDebuff then
        return;
    end

    if not UnitExists("target") then
        if AFUF.debuffframe then
            AFUF.debuffframe:Hide();
        end
        return;
    end

    CreateDebuffFrame();

    if not AFUF.debuffframe then
        return;
    end

    local i = 0;
    local bshow = false;


    auraList:Iterate(function(auraInstanceID, aura)
        i = i + 1;
        if i > numAuras then
            return true;
        end

        -- update size and offset info based on large aura status
        local icon = aura.icon;
        local expirationTime = aura.expirationTime;
        local duration = aura.duration;

        local frame = AFUF.debuffframe;
        frame.icon:SetTexture(icon);

        if (duration > 0) then
            asCooldownFrame_Set(frame.cooldown, expirationTime - duration, duration, true);
            frame.cooldown:Show();
        else
            frame.cooldown:Hide();
        end

        frame.auraInstanceID = auraInstanceID;

        bshow = true;
        frame:Show();
        return false;
    end);

    if not bshow then
        AFUF.debuffframe:Hide();
    end
end



local function UpdateAuras(unitAuraUpdateInfo)
    local debuffsChanged = false;

    if unitAuraUpdateInfo == nil or unitAuraUpdateInfo.isFullUpdate or activeDebuffs == nil then
        ParseAllAuras();
        debuffsChanged = true;
    else
        if unitAuraUpdateInfo.addedAuras ~= nil then
            for _, aura in ipairs(unitAuraUpdateInfo.addedAuras) do
                local type = ProcessAura(aura);
                if type == AuraUpdateChangedType.Debuff then
                    debuffsChanged = true;
                end
            end
        end

        if unitAuraUpdateInfo.updatedAuraInstanceIDs ~= nil then
            for _, auraInstanceID in ipairs(unitAuraUpdateInfo.updatedAuraInstanceIDs) do
                local wasInDebuff = activeDebuffs[auraInstanceID] ~= nil;
                if wasInDebuff then
                    local newAura = C_UnitAuras.GetAuraDataByAuraInstanceID("target", auraInstanceID);
                    activeDebuffs[auraInstanceID] = nil;
                    local type = ProcessAura(newAura);
                    if type == AuraUpdateChangedType.Debuff or wasInDebuff then
                        debuffsChanged = true;
                    end
                end
            end
        end

        if unitAuraUpdateInfo.removedAuraInstanceIDs ~= nil then
            for _, auraInstanceID in ipairs(unitAuraUpdateInfo.removedAuraInstanceIDs) do
                if activeDebuffs[auraInstanceID] ~= nil then
                    activeDebuffs[auraInstanceID] = nil;
                    debuffsChanged = true;
                end
            end
        end
    end

    if not debuffsChanged then
        return;
    end

    local numDebuffs = math.min(1, activeDebuffs:Size());

    UpdateAuraFrames(activeDebuffs, numDebuffs);
end



local bfirst = true;

local function OnEvent(self, event, ...)
    if bfirst then
        ns.SetupOptionPanels();
        bfirst = false;
    end

    if event == "PLAYER_ENTERING_WORLD" or event == "ACTIVE_TALENT_GROUP_CHANGED" then
        HideClassBar();
        HideCombatText();
        HideTargetBuffs();
        ShowAggro();
        HideTargetCastBar();
        UpdateHealthBar("player");
        UpdateHealthBar("target");
        UpdateHealthBar("targettarget");
    elseif event == "PLAYER_TARGET_CHANGED" then
        AFUF:RegisterUnitEvent("UNIT_TARGET", "target");
        UpdateHealthBar("target");
        UpdateHealthBar("targettarget");
        UpdateAuras();
    elseif event == "UNIT_ENTERED_VEHICLE" or event == "UNIT_EXITED_VEHICLE" then
        UpdateHealthBar("player");
    elseif event == "UNIT_TARGET" then
        UpdateHealthBar("targettarget");
    end
end

local function OnUpdate()
    if (UnitExists("target")) then
        UpdateAuras();
    end
end

local function OnInit()
    AFUF:SetScript("OnEvent", OnEvent);
    AFUF:RegisterEvent("PLAYER_TARGET_CHANGED");
    AFUF:RegisterEvent("PLAYER_ENTERING_WORLD");
    AFUF:RegisterEvent("ACTIVE_TALENT_GROUP_CHANGED");
    AFUF:RegisterUnitEvent("UNIT_TARGET", "target");
    AFUF:RegisterUnitEvent("UNIT_ENTERED_VEHICLE", "player");
    AFUF:RegisterUnitEvent("UNIT_EXITED_VEHICLE", "player");

    --주기적으로 Callback
    C_Timer.NewTicker(0.2, OnUpdate);
end

OnInit();
