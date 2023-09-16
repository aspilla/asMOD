local AFUF = CreateFrame("FRAME", nil, UIParent);
Options_Default = {
    HideDebuff = true,
    HideCombatText = true,
    HideCastBar = true,
    HideClassBar = true,
    ShowClassColor = true,
    ShowAggro = true,
    ShowDebuff = true,
};

local options = {};

local function HideCombatText()
    if options["HideCombatText"] then
        -- 데미지 숫자 숨기기
        PlayerFrame:UnregisterEvent("UNIT_COMBAT");
        TargetFrame:UnregisterEvent("UNIT_COMBAT");
        PetFrame:UnregisterEvent("UNIT_COMBAT");
    end
end

local function HideTargetBuffs()
    -- TargetFrame의 Buff Debuff를 숨긴다.
    if options["HideDebuff"] then
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
    if options["HideCastBar"] then
        --TargetCastBar 를 숨긴다.
        TargetFrame.spellbar.showCastbar = false;
    end
end

local function ShowAggro()
    if options["ShowAggro"] then
        --TargetCastBar 를 숨긴다.
        SetCVar("threatShowNumeric", "1");
    else
        SetCVar("threatShowNumeric", "0");
    end
end

local function HideClassBar()
    if not options["HideClassBar"] then
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
    ["player"] = PlayerFrame.PlayerFrameContent.PlayerFrameContentMain.HealthBarArea.HealthBar,
    ["target"] = TargetFrame.TargetFrameContent.TargetFrameContentMain.HealthBar,
    ["targettarget"] = TargetFrameToT.HealthBar,
}

local function UpdateHealthBar(unit)

    if not options["ShowClassColor"] then
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



local function UpdateTargetDebuff()
    if not options["ShowDebuff"] then
        return;
    end

    if not UnitExists("target") then
        return;
    end

    if not AFUF.debuffframe then
        if not (TargetFrame and TargetFrame.TargetFrameContainer and TargetFrame.TargetFrameContainer.Portrait and TargetFrame.TargetFrameContainer.FrameTexture) then
            return;
        end

        if TargetFrame:IsForbidden() then
            return;
        end

        local parent = TargetFrame.TargetFrameContainer;
        local portrait = parent.Portrait;

        AFUF.debuffframe = CreateFrame("Button", nil, parent, "asFUFDebuffFrameTemplate");
        local frame = AFUF.debuffframe;
        frame:EnableMouse(false);
        frame:ClearAllPoints();
        frame:SetAllPoints(portrait)
        frame:SetFrameLevel(parent:GetFrameLevel())
        frame.icon:SetDrawLayer("BACKGROUND", 2);
        frame.icon:SetMask("Interface\\CHARACTERFRAME\\TempPortraitAlphaMask");
        frame.cooldown:SetSwipeTexture("Interface\\CHARACTERFRAME\\TempPortraitAlphaMaskSmall")
        frame.cooldown:SetDrawEdge(false);
        frame.cooldown:SetSwipeColor(0, 0, 0, 0.5);
        frame.cooldown:SetUseCircularEdge(true);
        frame.cooldown:SetHideCountdownNumbers(false);
        parent.FrameTexture:SetDrawLayer("BACKGROUND", 3);

        if not frame:GetScript("OnEnter") then
            frame:SetScript("OnEnter", function(s)
                if s:GetID() > 0 then
                    GameTooltip_SetDefaultAnchor(GameTooltip, s);
                    GameTooltip:SetUnitDebuff(s.unit, s:GetID(), s.filter);
                end
            end)
            frame:SetScript("OnLeave", function()
                GameTooltip:Hide();
            end)
        end
    end

    local i = 1;
    local bshow = false;

    if not AFUF.debuffframe then
        return
    end

    repeat
        local name, icon, _, _, duration, expirationTime, _, _, _, _, _, _, _, nameplateShowAll = UnitDebuff("target", i,
            "");

        if (name == nil) then
            break;
        end

        if nameplateShowAll then
            local frame = AFUF.debuffframe;

            frame.icon:SetTexture(icon);

            if (duration > 0) then
                asCooldownFrame_Set(frame.cooldown, expirationTime - duration, duration, true);
                frame.cooldown:Show();
            else
                frame.cooldown:Hide();
            end

            frame.filter = "";
            frame:SetID(i);
            frame.unit = "target";
            frame:Show();
            bshow = true;
            break;
        end

        i = i + 1;
    until (false)

    if not bshow then
        AFUF.debuffframe:Hide();
    end
end

local total = 0;

local function OnUpdate(self, elapsed)
    total = total + elapsed

    if total > 0.1 then
        UpdateTargetDebuff();
        total = 0;
    end
end

local function SetupOptionPanels()
    local function OnSettingChanged(_, setting, value)
        local variable = setting:GetVariable()
        AFUF_Options[variable] = value;
        options[variable] = value;
        ReloadUI();
    end

    local category = Settings.RegisterVerticalLayoutCategory("asFixUnitFrame")

    if AFUF_Options == nil then
        AFUF_Options = {};
        AFUF_Options = CopyTable(Options_Default);
        options = CopyTable(AFUF_Options);
    end

    for variable, _ in pairs(Options_Default) do
        local name = variable;
        local tooltip = ""
        if AFUF_Options[variable] == nil then
            AFUF_Options[variable] = Options_Default[variable];
            options[variable] = Options_Default[variable];
        end
        local defaultValue = AFUF_Options[variable];

        local setting = Settings.RegisterAddOnSetting(category, name, variable, type(defaultValue), defaultValue)
        Settings.CreateCheckBox(category, setting, tooltip)
        Settings.SetOnValueChangedCallback(variable, OnSettingChanged)
    end

    Settings.RegisterAddOnCategory(category)
end

local bfirst = false;

local function OnEvent(self, event, ...)
    if not bfirst then
        SetupOptionPanels();
        options = CopyTable(AFUF_Options);
        bfirst = true;
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
        SetCVar("showTargetCastbar", "1");
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
    AFUF:SetScript("OnEvent", OnEvent);
    AFUF:SetScript("OnUpdate", OnUpdate);
    AFUF:RegisterEvent("PLAYER_TARGET_CHANGED");
    AFUF:RegisterEvent("PLAYER_ENTERING_WORLD");
    AFUF:RegisterEvent("ACTIVE_TALENT_GROUP_CHANGED");
    AFUF:RegisterUnitEvent("UNIT_TARGET", "target");
    AFUF:RegisterUnitEvent("UNIT_ENTERED_VEHICLE", "player");
    AFUF:RegisterUnitEvent("UNIT_EXITED_VEHICLE", "player");
end



OnInit();
