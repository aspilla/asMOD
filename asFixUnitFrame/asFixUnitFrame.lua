local AFUF = CreateFrame("FRAME", nil, UIParent);
AFUF.Options_Default = {
    HideDebuff = true,
    HideCombatText = true,
    HideCastBar = true,
    HideClassBar = true,
    ShowClassColor = true,
    ShowAggro = true,
    ShowDebuff = true,
}

function AFUF:HideCombatText()
    if AFUF_Options["HideCombatText"] then
        -- 데미지 숫자 숨기기
        PlayerFrame:UnregisterEvent("UNIT_COMBAT");
        TargetFrame:UnregisterEvent("UNIT_COMBAT");
        PetFrame:UnregisterEvent("UNIT_COMBAT");
    end
end

function AFUF:HideTargetBuffs()
    -- TargetFrame의 Buff Debuff를 숨긴다.
    if AFUF_Options["HideDebuff"] then
        TargetFrame:UnregisterEvent("UNIT_AURA");
        local function _UpdateBuffAnchor(self, buff)
            --For mirroring vertically
            buff:Hide();
        end

        hooksecurefunc("TargetFrame_UpdateBuffAnchor", _UpdateBuffAnchor);
        hooksecurefunc("TargetFrame_UpdateDebuffAnchor", _UpdateBuffAnchor);
    end
end

function AFUF:HideTargetCastBar()
    if AFUF_Options["HideCastBar"] then
        --TargetCastBar 를 숨긴다.
        TargetFrame.spellbar.showCastbar = false;
    end
end

function AFUF:ShowAggro()
    if AFUF_Options["ShowAggro"] then
        --TargetCastBar 를 숨긴다.
        SetCVar("threatShowNumeric", "1");
    else
        SetCVar("threatShowNumeric", "0");
    end
end

function AFUF:HideClassBar()
    if not AFUF_Options["HideClassBar"] then
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

function AFUF:UpdateHealthBar()
    if not AFUF_Options["ShowClassColor"] then
        return;
    end
    --Healthbar 직업 색상
    local function getFramesHealthBar()
        return {
            PlayerFrame_GetHealthBar(),
            TargetFrame.TargetFrameContent.TargetFrameContentMain.HealthBar,
            TargetFrameToT.HealthBar,
        }
    end

    local function updateHealthColor(unit, frame)

        if not (unit and frame) then
            return;
        end
        
        local r, g, b;
        local _, englishClass = UnitClass(unit);
        local classColor = RAID_CLASS_COLORS[englishClass];

        if ((UnitIsPlayer(unit)) and classColor) then
            r, g, b = classColor.r, classColor.g, classColor.b;
            frame:SetStatusBarDesaturated(true);
            frame:SetStatusBarColor(r, g, b);
        else
            frame:SetStatusBarColor(0, 1, 0);
        end
    end

    local healthBars = getFramesHealthBar()

    for _, statusbar in pairs(healthBars) do
        updateHealthColor(statusbar.unit, statusbar)
    end
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

function AFUF:UpdateTargetDebuff()
    if not AFUF_Options["ShowDebuff"] then
        return;
    end

    if not UnitExists("target") then
        return;
    end

    if not (TargetFrame and TargetFrame.TargetFrameContainer and TargetFrame.TargetFrameContainer.Portrait and TargetFrame.TargetFrameContainer) then
        return;
    end

    if not self.debuffframe and TargetFrame.TargetFrameContainer.Portrait then
        local parent = TargetFrame.TargetFrameContainer;
        local portrait = parent.Portrait;

        self.debuffframe = CreateFrame("Button", nil, parent, "asFUFDebuffFrameTemplate");
        local frame = self.debuffframe;
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

    repeat
        local name, icon, _, _, duration, expirationTime, _, _, _, _, _, _, _, nameplateShowAll = UnitDebuff("target", i,"");

        if (name == nil) then
            break;
        end

        if nameplateShowAll then
            local frame = self.debuffframe;

            frame.icon:SetTexture(icon);

            if (duration > 0) then
                asCooldownFrame_Set(frame.cooldown, expirationTime - duration, duration, duration > 0);
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
    until (true)

    if not bshow then
        self.debuffframe:Hide();
    end
end

function AFUF:OnUpdate()
    AFUF:UpdateTargetDebuff();
end

AFUF.bfirst = false;

function AFUF:OnEvent(event, ...)
    if not self.bfirst then
        self:SetupOptionPanels();
        self.bfirst = true;
    end

    if event == "PLAYER_ENTERING_WORLD" or event == "ACTIVE_TALENT_GROUP_CHANGED" then
        self:HideClassBar();
        self:HideCombatText();
        self:HideTargetBuffs();
        self:ShowAggro();
        self:HideTargetCastBar();
        SetCVar("showTargetCastbar", "1");
    end
    self:UpdateHealthBar();

    AFUF:RegisterUnitEvent("UNIT_TARGET", "target");
end

function AFUF:OnInit()
    self:SetScript("OnEvent", AFUF.OnEvent);
    self:RegisterEvent("PLAYER_TARGET_CHANGED");
    self:RegisterEvent("PLAYER_ENTERING_WORLD");
    self:RegisterEvent("ACTIVE_TALENT_GROUP_CHANGED");
    self:RegisterUnitEvent("UNIT_TARGET", "target");
    self:RegisterUnitEvent("UNIT_ENTERED_VEHICLE", "player")
    self:RegisterUnitEvent("UNIT_EXITED_VEHICLE", "player")

    C_Timer.NewTicker(0.1, AFUF.OnUpdate);
end

function AFUF:SetupOptionPanels()
    local function OnSettingChanged(_, setting, value)
        local variable = setting:GetVariable()
        AFUF_Options[variable] = value;
        ReloadUI();
    end

    local category = Settings.RegisterVerticalLayoutCategory("asFixUnitFrame")

    if AFUF_Options == nil then
        AFUF_Options = {};
        AFUF_Options = CopyTable(self.Options_Default);
    end

    for variable, _ in pairs(self.Options_Default) do
        local name = variable;
        local tooltip = ""
        if AFUF_Options[variable] == nil then
            AFUF_Options[variable] = self.Options_Default[variable];
        end
        local defaultValue = AFUF_Options[variable];

        local setting = Settings.RegisterAddOnSetting(category, name, variable, type(defaultValue), defaultValue)
        Settings.CreateCheckBox(category, setting, tooltip)
        Settings.SetOnValueChangedCallback(variable, OnSettingChanged)
    end

    Settings.RegisterAddOnCategory(category)
end

AFUF:OnInit();
