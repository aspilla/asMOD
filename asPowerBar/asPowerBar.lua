local _, ns              = ...;

--configurations
ns.config                = {
    font        = STANDARD_TEXT_FONT,
    fontSize    = 12,
    fontOutline = "OUTLINE",
    width       = 239,
    xpoint      = 0,
    ypoint      = -180,
    height      = 10,
    combatalpha = 1,
    normalalpha = 0.5,
};

ns.bupdate_rune          = false;
ns.bupdate_partial_power = false;
ns.brogue                = false;
ns.power_level           = nil;
ns.special_func          = nil;

ns.frame                 = CreateFrame("FRAME", nil, UIParent);

local function initclass()
    local localizedClass, englishClass = UnitClass("player")
    local spec = C_SpecializationInfo.GetSpecialization();

    if spec == nil or spec > 4 or (englishClass ~= "DRUID" and spec > 3) then
        spec = 1;
    end

    ns.frame:UnregisterEvent("UNIT_POWER_UPDATE")
    ns.frame:UnregisterEvent("UNIT_DISPLAYPOWER");
    ns.frame:UnregisterEvent("UPDATE_SHAPESHIFT_FORM");
    ns.frame:UnregisterEvent("RUNE_POWER_UPDATE");
    ns.frame:UnregisterEvent("SPELL_ACTIVATION_OVERLAY_SHOW");
    ns.frame:UnregisterEvent("SPELL_ACTIVATION_OVERLAY_HIDE");

    if ns.frame.timerPowerBar then
        ns.frame.timerPowerBar:Cancel()
    end

    if ns.frame.timerPower then
        ns.frame.timerPower:Cancel()
    end

    if ns.frame.timerStagger then
        ns.frame.timerStagger:Cancel()
    end

    ns.bupdate_rune = false;
    ns.power_level = nil;
    ns.brogue = false;
    ns.special_func = nil;
    
    ns.combotext:SetText("");
    ns.combotext:Hide();
    ns.combocountbar:Hide();

    for i = 1, 20 do
        ns.combobars[i]:Hide();
    end

    if (englishClass == "EVOKER") then
        ns.power_level = Enum.PowerType.Essence;
    end

    if (englishClass == "PALADIN") then
        ns.power_level = Enum.PowerType.HolyPower;
    end

    if (englishClass == "MAGE") then
        if (spec and spec == 1) then
            ns.power_level = Enum.PowerType.ArcaneCharges          
        end        
    end

    if (englishClass == "WARLOCK") then
        ns.power_level = Enum.PowerType.SoulShards        

        if (spec and spec == 3) then
            ns.bupdate_partial_power = true;
        end
    end

    if (englishClass == "DRUID") then
        ns.power_level = Enum.PowerType.ComboPoints
    end

    if (englishClass == "MONK") then
        if (spec and spec == 1) then
            ns.special_func = ns.update_stagger;
        end

        if (spec and spec == 3) then
            ns.power_level = Enum.PowerType.Chi
        end
    end

    if (englishClass == "ROGUE") then
        ns.power_level = Enum.PowerType.ComboPoints
        ns.brogue = true;
    end

    if (englishClass == "DEATHKNIGHT") then
        ns.setup_max_combo(6);
        ns.update_rune()
        ns.frame:RegisterEvent("RUNE_POWER_UPDATE");
        ns.bupdate_rune = true;
    end

    if (englishClass == "PRIEST") then
    end

    if (englishClass == "WARRIOR") then
    end

    if (englishClass == "DEMONHUNTER") then
        if spec and spec == 3 then
            ns.special_func = ns.update_dh_frag;
        end
    end

    if (englishClass == "HUNTER") then
    end

    if (englishClass == "SHAMAN") then
        if spec and spec == 2 then
            ns.setup_max_combo(10);
            ns.frame:RegisterEvent("SPELL_ACTIVATION_OVERLAY_SHOW");
            ns.frame:RegisterEvent("SPELL_ACTIVATION_OVERLAY_HIDE");            
        end
    end

    if ns.power_level then
        ns.combocountbar:Show();
        --ns.combotext:Show();
        local max = UnitPowerMax("player", ns.power_level);
        local maxpartial = nil;
        if ns.bupdate_partial_power then            
            maxpartial = UnitPowerDisplayMod(ns.power_level)
        end
        ns.setup_max_combo(max, maxpartial);
        ns.frame:RegisterUnitEvent("UNIT_POWER_UPDATE", "player");
        ns.frame:RegisterUnitEvent("UNIT_DISPLAYPOWER", "player");
    end

    ns.bar:Show();
    ns.bar.text:Show();

    ns.frame.timerPowerBar = C_Timer.NewTicker(0.1, ns.update_power);
    ns.frame.timerPower = C_Timer.NewTicker(0.2, ns.update_combo);
    ns.frame.timerStagger = C_Timer.NewTicker(0.2, ns.update_special);
end

local function on_event(self, event, ...)
    if event == "UNIT_POWER_UPDATE" then
        ns.update_combo();
    elseif event == "RUNE_POWER_UPDATE" then
        ns.update_rune();
    elseif event == "PLAYER_ENTERING_WORLD" then
        if UnitAffectingCombat("player") then
            ns.frame:SetAlpha(ns.config.combatalpha);
        else
            ns.frame:SetAlpha(ns.config.normalalpha);
        end
        C_Timer.After(0.5, initclass);
    elseif (event == "TRAIT_CONFIG_UPDATED") or (event == "TRAIT_CONFIG_LIST_UPDATED") or event ==
        "ACTIVE_TALENT_GROUP_CHANGED" then
        C_Timer.After(0.5, initclass);
    elseif event == "PLAYER_REGEN_DISABLED" then
        ns.frame:SetAlpha(ns.config.combatalpha);
    elseif event == "PLAYER_REGEN_ENABLED" then
        ns.frame:SetAlpha(ns.config.normalalpha);
    elseif (event == "SPELL_ACTIVATION_OVERLAY_SHOW") then
        local spellid = ...;
        ns.checkstorm(false, spellid);
    elseif (event == "SPELL_ACTIVATION_OVERLAY_HIDE") then
        local spellid = ...;
        ns.checkstorm(true, spellid);
    end

    return;
end

local function initaddon()
    ns.frame:SetPoint("BOTTOM", UIParent, "CENTER", ns.config.xpoint, ns.config.ypoint)
    ns.frame:SetWidth(ns.config.width)
    ns.frame:SetHeight(ns.config.height)
    ns.frame:SetFrameLevel(9100);
    ns.frame:Show();

    ns.bar = CreateFrame("StatusBar", nil, ns.frame)
    ns.bar:SetStatusBarTexture("Interface\\Addons\\asPowerBar\\UI-StatusBar")
    ns.bar:GetStatusBarTexture():SetHorizTile(false)
    ns.bar:SetMinMaxValues(0, 100)
    ns.bar:SetValue(100)
    ns.bar:SetWidth(ns.config.width)
    ns.bar:SetHeight(ns.config.height)
    ns.bar:SetPoint("BOTTOM", ns.frame, "BOTTOM", 0, 0)
    ns.bar:Hide();
    ns.bar:EnableMouse(false);

    ns.bar.bg = ns.bar:CreateTexture(nil, "BACKGROUND");
    ns.bar.bg:SetPoint("TOPLEFT", ns.bar, "TOPLEFT", -1, 1);
    ns.bar.bg:SetPoint("BOTTOMRIGHT", ns.bar, "BOTTOMRIGHT", 1, -1);

    ns.bar.bg:SetTexture("Interface\\Addons\\asPowerBar\\border.tga");
    ns.bar.bg:SetTexCoord(0.1, 0.1, 0.1, 0.1, 0.1, 0.1, 0.1, 0.1);
    ns.bar.bg:SetVertexColor(0, 0, 0, 0.8);

    ns.bar.text = ns.bar:CreateFontString(nil, "ARTWORK");
    ns.bar.text:SetFont(ns.config.font, ns.config.fontSize, ns.config.fontOutline);
    ns.bar.text:SetPoint("CENTER", ns.bar, "CENTER", 0, 0);
    ns.bar.text:SetTextColor(1, 1, 1, 1);

    ns.bar.predictbar = ns.bar:CreateTexture(nil, "ARTWORK", "asPredictionBarTemplate");
    local parenttexture =  ns.bar:GetStatusBarTexture();
    ns.bar.predictbar:ClearAllPoints();
    ns.bar.predictbar:SetPoint("TOPRIGHT", parenttexture, "TOPRIGHT", 0, 0);
    ns.bar.predictbar:SetPoint("BOTTOMRIGHT", parenttexture, "BOTTOMRIGHT", 0, 0);
    ns.bar.predictbar:SetVertexColor(0.5, 0.5, 0.5)
    ns.bar.predictbar:Hide();

    ns.combocountbar = CreateFrame("StatusBar", nil, ns.frame);
    ns.combocountbar:SetStatusBarTexture("Interface\\Addons\\asPowerBar\\UI-StatusBar");
    ns.combocountbar:GetStatusBarTexture():SetHorizTile(false);
    ns.combocountbar:SetFrameLevel(9000);
    ns.combocountbar:SetMinMaxValues(0, 100);
    ns.combocountbar:SetValue(100);
    ns.combocountbar:SetHeight(ns.config.height);
    ns.combocountbar:SetWidth(20);

    ns.combocountbar.bg = ns.combocountbar:CreateTexture(nil, "BACKGROUND");
    ns.combocountbar.bg:SetPoint("TOPLEFT", ns.combocountbar, "TOPLEFT", -1, 1);
    ns.combocountbar.bg:SetPoint("BOTTOMRIGHT", ns.combocountbar, "BOTTOMRIGHT", 1, -1);

    ns.combocountbar.bg:SetTexture("Interface\\Addons\\asPowerBar\\border.tga");
    ns.combocountbar.bg:SetTexCoord(0.1, 0.1, 0.1, 0.1, 0.1, 0.1, 0.1, 0.1);
    ns.combocountbar.bg:SetVertexColor(0, 0, 0, 0.8);
    ns.combocountbar:SetPoint("BOTTOMLEFT", ns.bar, "TOPLEFT", 0, 1);
    ns.combocountbar:SetWidth(ns.config.width);
    ns.combocountbar:SetStatusBarColor(1, 1, 1);
    ns.combocountbar:Hide();

    ns.combotext = ns.frame:CreateFontString(nil, "OVERLAY");
    ns.combotext:SetFont(ns.config.font, ns.config.fontSize - 2, ns.config.fontOutline);
    ns.combotext:SetPoint("CENTER", ns.combocountbar, "CENTER", 0, 0);
    ns.combotext:SetTextColor(1, 1, 1, 1)
    ns.combotext:Hide();

    ns.combobars = {};

    for i = 1, 20 do
        ns.combobars[i] = CreateFrame("StatusBar", nil, ns.frame);
        ns.combobars[i]:SetStatusBarTexture("Interface\\Addons\\asPowerBar\\UI-StatusBar");
        ns.combobars[i]:GetStatusBarTexture():SetHorizTile(false);
        ns.combobars[i]:SetFrameLevel(9100);
        ns.combobars[i]:SetMinMaxValues(0, 100);
        ns.combobars[i]:SetValue(100);
        ns.combobars[i]:SetHeight(ns.config.height);
        ns.combobars[i]:SetWidth(20);

        ns.combobars[i].bg = ns.combobars[i]:CreateTexture(nil, "BACKGROUND");
        ns.combobars[i].bg:SetPoint("TOPLEFT", ns.combobars[i], "TOPLEFT", -1, 1);
        ns.combobars[i].bg:SetPoint("BOTTOMRIGHT", ns.combobars[i], "BOTTOMRIGHT", 1, -1);

        ns.combobars[i].bg:SetTexture("Interface\\Addons\\asPowerBar\\border.tga");
        ns.combobars[i].bg:SetTexCoord(0.1, 0.1, 0.1, 0.1, 0.1, 0.1, 0.1, 0.1);
        ns.combobars[i].bg:SetVertexColor(0, 0, 0, 0.8);

        if i == 1 then
            ns.combobars[i]:SetPoint("BOTTOMLEFT", ns.bar, "TOPLEFT", 0, 1);
        else
            ns.combobars[i]:SetPoint("LEFT", ns.combobars[i - 1], "RIGHT", 1, 0);
        end

        ns.combobars[i]:Hide();
        ns.combobars[i]:EnableMouse(false);
    end

    C_AddOns.LoadAddOn("asMOD");

    if asMOD_setupFrame then
        asMOD_setupFrame(ns.frame, "asPowerBar");
    end

    ns.frame:SetScript("OnEvent", on_event)

    ns.frame:RegisterEvent("PLAYER_ENTERING_WORLD");
    ns.frame:RegisterEvent("PLAYER_REGEN_DISABLED");
    ns.frame:RegisterEvent("PLAYER_REGEN_ENABLED");
    ns.frame:RegisterEvent("TRAIT_CONFIG_UPDATED");
    ns.frame:RegisterEvent("TRAIT_CONFIG_LIST_UPDATED");
    ns.frame:RegisterEvent("ACTIVE_TALENT_GROUP_CHANGED");

    if UnitAffectingCombat("player") then
        ns.frame:SetAlpha(ns.config.combatalpha);
    else
        ns.frame:SetAlpha(ns.config.normalalpha);
    end
end

initaddon();
