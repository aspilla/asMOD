local _, ns      = ...;

--configurations
ns.configs        = {
    font        = STANDARD_TEXT_FONT,
    fontSize    = 12,
    fontOutline = "OUTLINE",
    width       = 238,
    xpoint      = 0,
    ypoint      = -180,
    height      = 8,
    comboheight = 5,
    combatalpha = 1,
    normalalpha = 0.5,
    framelevel  = 9000,
};

local _, Class   = UnitClass("player")
ns.classcolor    = RAID_CLASS_COLORS[Class];

local main_frame = CreateFrame("FRAME", nil, UIParent);

local function init_class()
    local localizedClass, englishClass = UnitClass("player")
    local spec = C_SpecializationInfo.GetSpecialization();

    if spec == nil or spec > 4 or (englishClass ~= "DRUID" and spec > 3) then
        spec = 1;
    end

    local bupdaterune = false;
    local powerlevel = nil;
    local bpartial = false;
    local brogue = false;
    local spellid = nil;
    local auraid = nil;
    local max_aura = nil;
    local bstagger = false;

    ns.combotext:SetText("");
    ns.combotext:Hide();
    ns.combocountbar:Hide();

    for i = 1, 20 do
        ns.combobars[i]:Hide();
    end

    for i = 1, 20 do
        ns.spellframes[i]:Hide();
    end

    if (englishClass == "EVOKER") then
        powerlevel = Enum.PowerType.Essence;
    end

    if (englishClass == "PALADIN") then
        powerlevel = Enum.PowerType.HolyPower;
    end

    if (englishClass == "MAGE") then
        if (spec and spec == 1) then
            powerlevel = Enum.PowerType.ArcaneCharges
        end

        if (spec and spec == 2) then
            spellid = 108853;
        end

        if (spec and spec == 3) then
            spellid = 44614;
        end
    end

    if (englishClass == "WARLOCK") then
        powerlevel = Enum.PowerType.SoulShards

        if (spec and spec == 3) then
            bpartial = true;
        end
    end

    if (englishClass == "DRUID") then
        if (spec and spec == 2) then
            powerlevel = Enum.PowerType.ComboPoints;
        end

        if (spec and spec == 4) then
            powerlevel = Enum.PowerType.ComboPoints;
        end
    end

    if (englishClass == "MONK") then
        if (spec and spec == 1) then
            bstagger = true;
        end

        if (spec and spec == 3) then
            powerlevel = Enum.PowerType.Chi
        end
    end

    if (englishClass == "ROGUE") then
        powerlevel = Enum.PowerType.ComboPoints
        brogue = true;
    end

    if (englishClass == "DEATHKNIGHT") then
        bupdaterune = true;
    end

    if (englishClass == "PRIEST") then
        if (spec and spec == 1) then
            spellid = 194509;
        end

        if (spec and spec == 2) then
            spellid = 2050;
        end

        if (spec and spec == 3) then
            spellid = 8092;
        end
    end

    if (englishClass == "WARRIOR") then
        if (spec and spec == 3) then
            spellid = 2565;
        end
    end

    if (englishClass == "DEMONHUNTER") then
        if spec and spec == 3 then
            --ns.combocountbar:SetMinMaxValues(0, 50);
            --ns.aura_func = ns.check_void;
            --main_frame:RegisterUnitEvent("UNIT_AURA", "player");
            --ns.aura_func();
        end
    end

    if (englishClass == "HUNTER") then
        if (spec and spec == 1) then
            spellid = 217200;
        end

        if (spec and spec == 2) then
            spellid = 19434;
        end
    end

    if (englishClass == "SHAMAN") then

        if (spec and spec == 1) then
            spellid = 51505;
        end
        if spec and spec == 2 then
            auraid = 344179;
            max_aura = 10;
        end
    end

    ns.setup_power();
    ns.setup_auracombo(auraid, max_aura);
    ns.setup_combo(powerlevel, bpartial, brogue);
    ns.setup_rune(bupdaterune);
    ns.setup_spell(spellid);
    ns.setup_stagger(bstagger);
end

local function on_event(self, event, ...)
    if event == "PLAYER_ENTERING_WORLD" then
        if ns.options.CombatAlphaChange then
            if UnitAffectingCombat("player") then
                main_frame:SetAlpha(ns.configs.combatalpha);
            else
                main_frame:SetAlpha(ns.configs.normalalpha);
            end
        end
        C_Timer.After(0.5, init_class);
    elseif (event == "TRAIT_CONFIG_UPDATED") or (event == "TRAIT_CONFIG_LIST_UPDATED") or event ==
        "ACTIVE_TALENT_GROUP_CHANGED" then
        C_Timer.After(0.5, init_class);
    elseif event == "PLAYER_REGEN_DISABLED" then
        if ns.options.CombatAlphaChange then
            main_frame:SetAlpha(ns.configs.combatalpha);
        end
    elseif event == "PLAYER_REGEN_ENABLED" then
        if ns.options.CombatAlphaChange then
            main_frame:SetAlpha(ns.configs.normalalpha);
        end
    end

    return;
end

local backdropConfig = {
    edgeFile = "Interface\\Buttons\\WHITE8X8",
    edgeSize = 1,
    bgFile = "Interface\\Buttons\\WHITE8X8",
    tile = false,
}

local function init_addon()
    main_frame:SetPoint("BOTTOM", UIParent, "CENTER", ns.configs.xpoint, ns.configs.ypoint)
    main_frame:SetWidth(ns.configs.width)
    main_frame:SetHeight(ns.configs.height)
    main_frame:SetFrameLevel(ns.configs.framelevel + 400);
    main_frame:Show();

    ns.bar = CreateFrame("StatusBar", nil, main_frame)
    ns.bar:SetFrameLevel(ns.configs.framelevel);
    ns.bar:SetStatusBarTexture("RaidFrame-Hp-Fill")
    ns.bar:GetStatusBarTexture():SetHorizTile(false)
    ns.bar:SetMinMaxValues(0, 100)
    ns.bar:SetValue(100)
    ns.bar:SetWidth(ns.configs.width)
    ns.bar:SetHeight(ns.configs.height)
    ns.bar:SetPoint("BOTTOM", main_frame, "BOTTOM", 0, 0)
    ns.bar:Hide();
    ns.bar:EnableMouse(false);

    ns.bar.bg = ns.bar:CreateTexture(nil, "BACKGROUND");
    ns.bar.bg:SetPoint("TOPLEFT", ns.bar, "TOPLEFT", -1, 1);
    ns.bar.bg:SetPoint("BOTTOMRIGHT", ns.bar, "BOTTOMRIGHT", 1, -1);

    ns.bar.bg:SetTexture("Interface\\Addons\\asPowerBar\\border.tga");    
    ns.bar.bg:SetTexCoord(0.1, 0.1, 0.1, 0.1, 0.1, 0.1, 0.1, 0.1);
    ns.bar.bg:SetVertexColor(0, 0, 0, 1);

    ns.bar.text = main_frame:CreateFontString(nil, "ARTWORK");
    ns.bar.text:SetFont(ns.configs.font, ns.configs.fontSize, ns.configs.fontOutline);
    ns.bar.text:SetPoint("CENTER", ns.bar, "CENTER", 0, 0);
    ns.bar.text:SetTextColor(1, 1, 1, 1);

    ns.bar.predictbar = ns.bar:CreateTexture(nil, "ARTWORK", "asPredictionBarTemplate");
    local parenttexture = ns.bar:GetStatusBarTexture();
    ns.bar.predictbar:ClearAllPoints();
    ns.bar.predictbar:SetPoint("TOPRIGHT", parenttexture, "TOPRIGHT", 0, 0);
    ns.bar.predictbar:SetPoint("BOTTOMRIGHT", parenttexture, "BOTTOMRIGHT", 0, 0);
    ns.bar.predictbar:SetVertexColor(0.5, 0.5, 0.5)
    ns.bar.predictbar:Hide();

    ns.combocountbar = CreateFrame("StatusBar", nil, main_frame);
    ns.combocountbar:SetStatusBarTexture("RaidFrame-Hp-Fill");
    ns.combocountbar:GetStatusBarTexture():SetHorizTile(false);
    ns.combocountbar:SetFrameLevel(ns.configs.framelevel);
    ns.combocountbar:SetMinMaxValues(0, 100);
    ns.combocountbar:SetValue(100);
    ns.combocountbar:SetHeight(ns.configs.comboheight);
    ns.combocountbar:SetWidth(20);

    ns.combocountbar.bg = ns.combocountbar:CreateTexture(nil, "BACKGROUND");
    ns.combocountbar.bg:SetPoint("TOPLEFT", ns.combocountbar, "TOPLEFT", -1, 1);
    ns.combocountbar.bg:SetPoint("BOTTOMRIGHT", ns.combocountbar, "BOTTOMRIGHT", 1, -1);

    ns.combocountbar.bg:SetTexture("Interface\\Addons\\asPowerBar\\border.tga");
    ns.combocountbar.bg:SetTexCoord(0.1, 0.1, 0.1, 0.1, 0.1, 0.1, 0.1, 0.1);
    ns.combocountbar.bg:SetVertexColor(0.3, 0.3, 0.3, 1);
    ns.combocountbar:SetPoint("BOTTOMLEFT", ns.bar, "TOPLEFT", 0, 1);
    ns.combocountbar:SetWidth(ns.configs.width);
    ns.combocountbar:SetStatusBarColor(1, 1, 1);
    ns.combocountbar:Hide();

    ns.combotext = main_frame:CreateFontString(nil, "OVERLAY");
    ns.combotext:SetFont(ns.configs.font, ns.configs.fontSize - 2, ns.configs.fontOutline);
    ns.combotext:SetPoint("CENTER", ns.combocountbar, "CENTER", 0, 0);
    ns.combotext:SetTextColor(1, 1, 1, 1)
    ns.combotext:Hide();

    ns.combobars = {};

    for i = 1, 20 do
        ns.combobars[i] = CreateFrame("StatusBar", nil, main_frame);
        ns.combobars[i]:SetStatusBarTexture("RaidFrame-Hp-Fill");
        ns.combobars[i]:GetStatusBarTexture():SetHorizTile(false);
        ns.combobars[i]:SetFrameLevel(ns.configs.framelevel + 100);
        ns.combobars[i]:SetMinMaxValues(0, 100);
        ns.combobars[i]:SetValue(100);
        ns.combobars[i]:SetHeight(ns.configs.comboheight);
        ns.combobars[i]:SetWidth(20);

        ns.combobars[i].bg = ns.combobars[i]:CreateTexture(nil, "BACKGROUND");
        ns.combobars[i].bg:SetPoint("TOPLEFT", ns.combobars[i], "TOPLEFT", -1, 1);
        ns.combobars[i].bg:SetPoint("BOTTOMRIGHT", ns.combobars[i], "BOTTOMRIGHT", 1, -1);

        ns.combobars[i].bg:SetTexture("Interface\\Addons\\asPowerBar\\border.tga");
        ns.combobars[i].bg:SetTexCoord(0.1, 0.1, 0.1, 0.1, 0.1, 0.1, 0.1, 0.1);
        ns.combobars[i].bg:SetVertexColor(0, 0, 0, 1);

        if i == 1 then
            ns.combobars[i]:SetPoint("BOTTOMLEFT", ns.bar, "TOPLEFT", 0, 1);
        else
            ns.combobars[i]:SetPoint("LEFT", ns.combobars[i - 1], "RIGHT", 1, 0);
        end

        ns.combobars[i]:Hide();
        ns.combobars[i]:EnableMouse(false);
    end

    ns.spellframes = {};

    for i = 1, 20 do
        ns.spellframes[i] = CreateFrame("Frame", nil, main_frame, "BackdropTemplate");
        ns.spellframes[i]:SetFrameLevel(ns.configs.framelevel + 200);
        ns.spellframes[i]:SetHeight(ns.configs.comboheight + 2);
        ns.spellframes[i]:SetWidth(20);

        ns.spellframes[i].range = ns.spellframes[i]:CreateTexture(nil, "ARTWORK");
        ns.spellframes[i].range:SetColorTexture(0.6, 0, 0);
        ns.spellframes[i].range:SetAlpha(0.5);
        ns.spellframes[i].range:SetAllPoints(ns.spellframes[i]);
        ns.spellframes[i].range:Hide();

        ns.spellframes[i].notenough = ns.spellframes[i]:CreateTexture(nil, "ARTWORK");
        ns.spellframes[i].notenough:SetColorTexture(0.3, 0.3, 0.3);
        ns.spellframes[i].notenough:SetAlpha(0.5);
        ns.spellframes[i].notenough:SetAllPoints(ns.spellframes[i]);
        ns.spellframes[i].notenough:Hide();

        if i == 1 then
            ns.spellframes[i]:SetPoint("BOTTOMLEFT", ns.bar, "TOPLEFT", -1, 0);
        else
            ns.spellframes[i]:SetPoint("LEFT", ns.spellframes[i - 1], "RIGHT", 0, 0);
        end

        ns.spellframes[i]:SetBackdrop(backdropConfig)
        ns.spellframes[i]:SetBackdropBorderColor(0, 0, 0, 1);
        ns.spellframes[i]:SetBackdropColor(0, 0, 0, 0);

        ns.spellframes[i]:Hide();
        ns.spellframes[i]:EnableMouse(false);
    end


    ns.chargebar = CreateFrame("StatusBar", nil, main_frame);
    ns.chargebar:SetStatusBarTexture("RaidFrame-Hp-Fill");
    ns.chargebar:GetStatusBarTexture():SetHorizTile(false);
    ns.chargebar:SetFrameLevel(ns.configs.framelevel + 100);
    ns.chargebar:SetMinMaxValues(0, 100);
    ns.chargebar:SetValue(0);
    ns.chargebar:SetHeight(ns.configs.comboheight);
    ns.chargebar:SetWidth(20);
    local texturepoint = ns.combocountbar:GetStatusBarTexture();
    ns.chargebar:SetPoint("LEFT", texturepoint, "RIGHT", 0, 0);
    ns.chargebar:SetStatusBarColor(0, 0, 0);
    ns.chargebar:Hide();
    ns.chargebar:EnableMouse(false);


    ns.setup_option();    
    local libasConfig = LibStub:GetLibrary("LibasConfig", true);

    if libasConfig then
        libasConfig.load_position(main_frame, "asPowerBar", ASPB_Positions);
    end

    main_frame:SetScript("OnEvent", on_event)

    main_frame:RegisterEvent("PLAYER_ENTERING_WORLD");
    main_frame:RegisterEvent("PLAYER_REGEN_DISABLED");
    main_frame:RegisterEvent("PLAYER_REGEN_ENABLED");
    main_frame:RegisterEvent("TRAIT_CONFIG_UPDATED");
    main_frame:RegisterEvent("TRAIT_CONFIG_LIST_UPDATED");
    main_frame:RegisterEvent("ACTIVE_TALENT_GROUP_CHANGED");

    if ns.options.CombatAlphaChange then
        if UnitAffectingCombat("player") then
            main_frame:SetAlpha(ns.configs.combatalpha);
        else
            main_frame:SetAlpha(ns.configs.normalalpha);
        end
    end
    init_class();
end

C_Timer.After(0.5, init_addon);
