local _, ns = ...;

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
        TargetFrame.spellbar:UnregisterAllEvents();
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

    if class == "WARLOCK" then
        frame = WarlockPowerFrame;
    elseif class == "DRUID" then
        frame = DruidComboPointBarFrame;
    elseif class == "MAGE" then
        frame = MageArcaneChargesFrame;
    elseif class == "ROGUE" then
        frame = RogueComboPointBarFrame;
    elseif class == "DEATHKNIGHT" then
        frame = RuneFrame;
    elseif class == "EVOKER" then
        frame = EssencePlayerFrame;
    elseif class == "PALADIN" then
        frame = PaladinPowerBarFrame;
    elseif class == "MONK" then
        frame = MonkHarmonyBarFrame;
    end

    if (frame) then
        frame:Hide();
        frame:HookScript("OnShow", ClassBarOnShow);
    end
end

local function HideTotemBar()
    if not ns.options.HideTotemBar then
        return;
    end
    --주요 자원바 숨기기
    local ClassBarOnShow = function(frame)
        frame:Hide()
    end

    local frame

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


        local r, g, b;

        local _, englishClass = UnitClass(unit);
        if englishClass then
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

local bfirst = true;

local function OnEvent(self, event, ...)
    if bfirst then
        ns.SetupOptionPanels();
        bfirst = false;
    end

    if event == "PLAYER_ENTERING_WORLD" or event == "ACTIVE_TALENT_GROUP_CHANGED" then
        HideClassBar();
        HideTotemBar();
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
    elseif event == "UNIT_ENTERED_VEHICLE" or event == "UNIT_EXITED_VEHICLE" then
        UpdateHealthBar("player");
    elseif event == "UNIT_TARGET" then
        UpdateHealthBar("targettarget");
    end
end

local function OnInit()
    local bloaded = C_AddOns.LoadAddOn("asUnitFrame");

    if bloaded then
        return;
    end

    AFUF:SetScript("OnEvent", OnEvent);
    AFUF:RegisterEvent("PLAYER_TARGET_CHANGED");
    AFUF:RegisterEvent("PLAYER_ENTERING_WORLD");
    AFUF:RegisterEvent("ACTIVE_TALENT_GROUP_CHANGED");
    AFUF:RegisterUnitEvent("UNIT_TARGET", "target");
    AFUF:RegisterUnitEvent("UNIT_ENTERED_VEHICLE", "player");
    AFUF:RegisterUnitEvent("UNIT_EXITED_VEHICLE", "player");
end

OnInit();
