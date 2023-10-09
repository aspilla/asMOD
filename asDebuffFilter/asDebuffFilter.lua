local _, ns = ...;
local ADF;
local ADF_PLAYER_DEBUFF;
local ADF_TARGET_DEBUFF;


local ADF_BlackList = {

    ["도전자의 짐"] = 1,
    --	["상처 감염 독"] = 1,	
    --	["신경 마취 독"] = 1,
    --	["맹독"] = 1,
}

-- 반짝이 처리부

--AuraUtil

local PLAYER_UNITS = {
    player = true,
    vehicle = true,
    pet = true,
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
    "nameplateShowPersonal",
    "namePlateShowAll",
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

    return a.spellId < b.spellId
end

local function UnitFrameDebuffComparator(a, b)
    if a.debuffType ~= b.debuffType then
        return a.debuffType < b.debuffType;
    end

    return DefaultAuraCompare(a, b);
end


local function ForEachAuraHelper(unit, filter, func, usePackedAura, continuationToken, ...)
    -- continuationToken is the first return value of UnitAuraSlots()
    local n = select('#', ...);
    for i = 1, n do
        local slot = select(i, ...);
        local done;
        if usePackedAura then
            local auraInfo = C_UnitAuras.GetAuraDataBySlot(unit, slot);
            done = func(auraInfo);
        else
            done = func(UnitAuraBySlot(unit, slot));
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
            UnitAuraSlots(unit, filter, maxCount, continuationToken));
    until continuationToken == nil;
end



local filter = CreateFilterString(AuraFilters.Harmful);

local function asCooldownFrame_Clear(self)
    self:Clear();
end

local function asCooldownFrame_Set(self, start, duration, enable, forceShowDrawEdge, modRate)
    if enable and enable ~= 0 and start > 0 and duration > 0 then
        self:SetDrawEdge(forceShowDrawEdge);
        self:SetCooldown(start, duration, modRate);
    else
        asCooldownFrame_Clear(self);
    end
end

local cachedPriorityChecks = {};
local function CheckIsPriorityAura(spellId)
    if cachedPriorityChecks[spellId] == nil then
        cachedPriorityChecks[spellId] = SpellIsPriorityAura(spellId);
    end

    return cachedPriorityChecks[spellId];
end


local function IsPriorityDebuff(spellId)
    local _, classFilename = UnitClass("player");
    if (classFilename == "PALADIN") then
        local isForbearance = (spellId == 25771);
        return isForbearance or CheckIsPriorityAura(spellId);
    else
        return CheckIsPriorityAura(spellId);
    end
end

local function ShouldShowDebuffs(unit, caster, nameplateShowAll, casterIsAPlayer)
    if (GetCVarBool("noBuffDebuffFilterOnTarget")) then
        return true;
    end

    if (nameplateShowAll) then
        return true;
    end

    if (caster and (UnitIsUnit("player", caster) or UnitIsOwnerOrControllerOfUnit("player", caster))) then
        return true;
    end

    if (UnitIsUnit("player", unit)) then
        return true;
    end

    local targetIsFriendly = not UnitCanAttack("player", unit);
    local targetIsAPlayer = UnitIsPlayer(unit);
    local targetIsAPlayerPet = UnitIsOtherPlayersPet(unit);
    if (not targetIsAPlayer and not targetIsAPlayerPet and not targetIsFriendly and casterIsAPlayer) then
        return false;
    end

    return true;
end


local activeDebuffs = {};


local function ProcessAura(aura, unit)
    if aura == nil or aura.icon == nil or unit == nil or not aura.isHarmful then
        return AuraUpdateChangedType.None;
    end

    if ADF_BlackList[aura.name] then
        return AuraUpdateChangedType.None;
    end

    local skip = true;
    if unit == "target" then
        skip = true;

        if ShouldShowDebuffs(unit, aura.sourceUnit, aura.nameplateShowAll, aura.isFromPlayerOrPlayerPet) then
            skip = false;
        end

        -- PowerBar에서 보이는 Debuff 는 숨기고
        if APB_DEBUFF and APB_DEBUFF == aura.name then
            skip = true;
        end

        -- ACI 에서 보이는 Debuff 는 숨기고
        if ACI_Debuff_list and ACI_Debuff_list[aura.name] then
            skip = true;
        end
    elseif unit == "player" then
        skip = false;

        if aura.duration > ns.ADF_MAX_Cool then
            skip = true;
        end

        if aura.isRaid or aura.isBossAura then
            skip = false;
        end
    end

    if skip == false then
        if C_SpellBook.GetDeadlyDebuffInfo(aura.spellId) then
            aura.debuffType = UnitFrameDebuffType.BossDebuff;
        elseif aura.isBossAura and not aura.isRaid then
            aura.debuffType = UnitFrameDebuffType.BossDebuff
        elseif aura.nameplateShowPersonal then
            aura.debuffType = UnitFrameDebuffType.nameplateShowPersonal;
        elseif aura.nameplateShowAll then
            aura.debuffType = UnitFrameDebuffType.namePlateShowAll;
        elseif not aura.isRaid then
            if IsPriorityDebuff(aura.spellId) then
                aura.debuffType = UnitFrameDebuffType.PriorityDebuff;
            else
                aura.debuffType = UnitFrameDebuffType.NonBossDebuff;
            end
        elseif aura.isRaid then
            if DispellableDebuffTypes[aura.dispelName] ~= nil then
                aura.debuffType = aura.isBossAura and UnitFrameDebuffType.BossDebuff or
                    UnitFrameDebuffType.NonBossRaidDebuff;
            else
                aura.debuffType = UnitFrameDebuffType.NonBossDebuff;
            end
        else
            aura.debuffType = UnitFrameDebuffType.NonBossDebuff;
        end

        activeDebuffs[unit][aura.auraInstanceID] = aura;
        return AuraUpdateChangedType.Debuff;
    end


    return AuraUpdateChangedType.None;
end

local function ParseAllAuras(unit)
    if activeDebuffs[unit] == nil then
        activeDebuffs[unit] = TableUtil.CreatePriorityTable(UnitFrameDebuffComparator,
            TableUtil.Constants.AssociativePriorityTable);
    else
        activeDebuffs[unit]:Clear();
    end

    local function HandleAura(aura)
        ProcessAura(aura, unit);
        return false;
    end

    local batchCount = nil;
    local usePackedAura = true;
    ForEachAura(unit, filter, batchCount, HandleAura, usePackedAura);
end

local function UpdateAuraFrames(unit, auraList, numAuras)
    local i = 0;
    local parent = ADF_TARGET_DEBUFF;

    if (unit == "player") then
        parent = ADF_PLAYER_DEBUFF;
    end


    auraList:Iterate(
        function(auraInstanceID, aura)
            i = i + 1;
            if i > numAuras then
                return true;
            end

            local frame = parent.frames[i];

            frame.unit = unit;
            frame.auraInstanceID = aura.auraInstanceID;

            -- set the icon
            local frameIcon = frame.icon
            frameIcon:SetTexture(aura.icon);
            frameIcon:SetAlpha(ns.ADF_ALPHA);
            -- set the count
            local frameCount = frame.count;

            -- Handle cooldowns
            local frameCooldown = frame.cooldown;

            if (aura.applications and aura.applications > 1) then
                frameCount:SetText(aura.applications);
                frameCount:Show();
                frameCooldown:SetDrawSwipe(false);
            else
                frameCount:Hide();
                frameCooldown:SetDrawSwipe(true);
            end

            if (aura.duration > 0) then
                frameCooldown:Show();
                asCooldownFrame_Set(frameCooldown, aura.expirationTime - aura.duration, aura.duration, aura.duration > 0,
                    true);
                frameCooldown:SetHideCountdownNumbers(false);
            else
                frameCooldown:Hide();
            end

            local color = nil;
            -- set debuff type color
            if (aura.dispelName) then
                color = DebuffTypeColor[aura.dispelName];
            else
                color = DebuffTypeColor["none"];
            end

            if (unit ~= "player" and aura.sourceUnit ~= nil and not PLAYER_UNITS[aura.sourceUnit]) then
                color = { r = 0.3, g = 0.3, b = 0.3 };
            end

            if aura.isRaid and (unit == "player" or UnitCanAssist(unit, "player")) then
                ns.lib.PixelGlow_Start(frame, { color.r, color.g, color.b, 1 });
            else
                ns.lib.PixelGlow_Stop(frame);
            end

            if aura.debuffType == UnitFrameDebuffType.NonBossDebuff then
                frame:SetWidth(ns.ADF_SIZE);
                frame:SetHeight((ns.ADF_SIZE) * 0.8);
            else
                -- Resize
                frame:SetWidth(ns.ADF_SIZE + 4);
                frame:SetHeight((ns.ADF_SIZE + 4) * 0.8);
            end

            local frameBorder = frame.border;
            if aura.nameplateShowAll then
                frameBorder:SetVertexColor(0.3, 0.3, 0.3);
            else
                frameBorder:SetVertexColor(color.r, color.g, color.b);
            end


            frame:Show();

            if (aura.isBossDebuff) then
                ns.lib.ButtonGlow_Start(frame);
            else
                ns.lib.ButtonGlow_Stop(frame);
            end
            return false;
        end);

    for j = i + 1, ns.ADF_MAX_DEBUFF_SHOW do
        local frame = parent.frames[j];

        if (frame) then
            frame:Hide();
            ns.lib.ButtonGlow_Stop(frame);
            ns.lib.PixelGlow_Stop(frame);
        end
    end
end

local function UpdateAuras(unitAuraUpdateInfo, unit)
    local debuffsChanged = false;

    if unitAuraUpdateInfo == nil or unitAuraUpdateInfo.isFullUpdate or activeDebuffs[unit] == nil then
        ParseAllAuras(unit);
        debuffsChanged = true;
    else
        if unitAuraUpdateInfo.addedAuras ~= nil then
            for _, aura in ipairs(unitAuraUpdateInfo.addedAuras) do
                local type = ProcessAura(aura, unit);
                if type == AuraUpdateChangedType.Debuff then
                    debuffsChanged = true;
                end
            end
        end

        if unitAuraUpdateInfo.updatedAuraInstanceIDs ~= nil then
            for _, auraInstanceID in ipairs(unitAuraUpdateInfo.updatedAuraInstanceIDs) do
                local newAura = C_UnitAuras.GetAuraDataByAuraInstanceID(unit, auraInstanceID);
                activeDebuffs[unit][auraInstanceID] = nil;
                local type = ProcessAura(newAura, unit);
                if type == AuraUpdateChangedType.Debuff then
                    debuffsChanged = true;
                end
            end
        end

        if unitAuraUpdateInfo.removedAuraInstanceIDs ~= nil then
            for _, auraInstanceID in ipairs(unitAuraUpdateInfo.removedAuraInstanceIDs) do
                if activeDebuffs[unit][auraInstanceID] ~= nil then
                    activeDebuffs[unit][auraInstanceID] = nil;
                    debuffsChanged = true;
                end
            end
        end
    end

    if not debuffsChanged then
        return;
    end

    local numDebuffs = math.min(ns.ADF_MAX_DEBUFF_SHOW, activeDebuffs[unit]:Size());

    UpdateAuraFrames(unit, activeDebuffs[unit], numDebuffs);
end

function ADF_ClearFrame()
    for i = 1, ns.ADF_MAX_DEBUFF_SHOW do
        local frame = ADF_TARGET_DEBUFF.frames[i];

        if (frame) then
            frame:Hide();
            ns.lib.ButtonGlow_Stop(frame);
            ns.lib.PixelGlow_Stop(frame);
        end
    end
end

function ADF_OnEvent(self, event, arg1, ...)
    if (event == "PLAYER_TARGET_CHANGED") then
        ADF_ClearFrame();
        ADF_TARGET_DEBUFF:RegisterUnitEvent("UNIT_AURA", "target");
        UpdateAuras(nil, "target");
    elseif (event == "UNIT_AURA") then
        local unitAuraUpdateInfo = ...;
        UpdateAuras(unitAuraUpdateInfo, arg1);
    elseif (event == "PLAYER_ENTERING_WORLD") then
        UpdateAuras(nil, "target");
        UpdateAuras(nil, "player");
    elseif event == "PLAYER_REGEN_DISABLED" then
        ADF:SetAlpha(ns.ADF_AlphaCombat);
        cachedPriorityChecks = {};
    elseif event == "PLAYER_REGEN_ENABLED" then
        ADF:SetAlpha(ns.ADF_AlphaNormal);
        cachedPriorityChecks = {};
    end
end

local function ADF_UpdateDebuffAnchor(frames, index, offsetX, right, parent)
    local buff = frames[index];
    local point1 = "BOTTOMLEFT";
    local point2 = "BOTTOMLEFT";
    local point3 = "BOTTOMRIGHT";

    if (right == false) then
        point1 = "BOTTOMRIGHT";
        point2 = "BOTTOMRIGHT";
        point3 = "BOTTOMLEFT";
        offsetX = -offsetX;
    end

    if (index == 1) then
        buff:SetPoint(point1, parent, point2, 0, 0);
    else
        buff:SetPoint(point1, frames[index - 1], point3, offsetX, 0);
    end

    -- Resize
    buff:SetWidth(ns.ADF_SIZE);
    buff:SetHeight(ns.ADF_SIZE * 0.8);
end


local function CreatDebuffFrames(parent, bright)
    if parent.frames == nil then
        parent.frames = {};
    end

    for idx = 1, ns.ADF_MAX_DEBUFF_SHOW do
        parent.frames[idx] = CreateFrame("Button", nil, parent, "asTargetDebuffFrameTemplate");
        local frame = parent.frames[idx];
        frame:SetFrameStrata("MEDIUM");
        frame:SetFrameLevel(9000);
        frame:EnableMouse(false);
        frame.cooldown:SetFrameLevel(9100);
        for _, r in next, { frame.cooldown:GetRegions() } do
            if r:GetObjectType() == "FontString" then
                r:SetFont(STANDARD_TEXT_FONT, ns.ADF_CooldownFontSize, "OUTLINE");
                r:ClearAllPoints();
                r:SetPoint("TOP", 0, 5);
                break
            end
        end

        frame.count:SetFont(STANDARD_TEXT_FONT, ns.ADF_CountFontSize, "OUTLINE")
        frame.count:ClearAllPoints()
        frame.count:SetPoint("BOTTOMRIGHT", -2, 2);

        frame.icon:SetTexCoord(.08, .92, .08, .92);
        frame.border:SetTexture("Interface\\Addons\\asDebuffFilter\\border.tga");
        frame.border:SetTexCoord(0.08, 0.08, 0.08, 0.92, 0.92, 0.08, 0.92, 0.92);
        frame.border:SetAlpha(ns.ADF_ALPHA);

        frame:ClearAllPoints();
        ADF_UpdateDebuffAnchor(parent.frames, idx, 1, bright, parent);

        if not frame:GetScript("OnEnter") then
            frame:SetScript("OnEnter", function(s)
                if s.auraInstanceID then
                    GameTooltip_SetDefaultAnchor(GameTooltip, s);
                    GameTooltip:SetUnitDebuffByAuraInstanceID(s.unit, s.auraInstanceID, filter);
                end
            end)
            frame:SetScript("OnLeave", function()
                GameTooltip:Hide();
            end)
        end

        frame:Hide();
    end

    return;
end

local function ADF_Init()
    local bloaded = LoadAddOn("asMOD")

    ADF = CreateFrame("Frame", nil, UIParent)

    ADF:SetPoint("CENTER", 0, 0)
    ADF:SetWidth(1)
    ADF:SetHeight(1)
    ADF:SetScale(1)
    ADF:SetAlpha(ns.ADF_AlphaNormal);
    ADF:Show()

    ADF_TARGET_DEBUFF = CreateFrame("Frame", nil, ADF)

    ADF_TARGET_DEBUFF:SetPoint("CENTER", ns.ADF_TARGET_DEBUFF_X, ns.ADF_TARGET_DEBUFF_Y)
    ADF_TARGET_DEBUFF:SetWidth(1)
    ADF_TARGET_DEBUFF:SetHeight(1)
    ADF_TARGET_DEBUFF:SetScale(1)
    ADF_TARGET_DEBUFF:Show()

    CreatDebuffFrames(ADF_TARGET_DEBUFF, true);

    if bloaded and asMOD_setupFrame then
        asMOD_setupFrame(ADF_TARGET_DEBUFF, "asDebuffFilter(Target)");
    end

    ADF_PLAYER_DEBUFF = CreateFrame("Frame", nil, ADF)

    ADF_PLAYER_DEBUFF:SetPoint("CENTER", ns.ADF_PLAYER_DEBUFF_X, ns.ADF_PLAYER_DEBUFF_Y)
    ADF_PLAYER_DEBUFF:SetWidth(1)
    ADF_PLAYER_DEBUFF:SetHeight(1)
    ADF_PLAYER_DEBUFF:SetScale(1)
    ADF_PLAYER_DEBUFF:Show()

    CreatDebuffFrames(ADF_PLAYER_DEBUFF, false);

    if bloaded and asMOD_setupFrame then
        asMOD_setupFrame(ADF_PLAYER_DEBUFF, "asDebuffFilter(Player)");
    end

    ADF:RegisterEvent("PLAYER_TARGET_CHANGED")
    ADF_TARGET_DEBUFF:RegisterUnitEvent("UNIT_AURA", "target")
    ADF_PLAYER_DEBUFF:RegisterUnitEvent("UNIT_AURA", "player")
    ADF:RegisterEvent("PLAYER_ENTERING_WORLD");
    ADF:RegisterEvent("PLAYER_REGEN_DISABLED");
    ADF:RegisterEvent("PLAYER_REGEN_ENABLED");

    ADF:SetScript("OnEvent", ADF_OnEvent)
    ADF_TARGET_DEBUFF:SetScript("OnEvent", ADF_OnEvent)
    ADF_PLAYER_DEBUFF:SetScript("OnEvent", ADF_OnEvent)
end

ADF_Init();
