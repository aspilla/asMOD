local _, ns      = ...;

local main_frame = CreateFrame("FRAME", nil, UIParent);

local configs    = {
    font = STANDARD_TEXT_FONT,
    fontsize = 30,
    fontoutline = "THICKOUTLINE",
    xpoint = 0,
    ypoint = 0,

    buttonsize = 40,
    button_xpoint = 0,
    button_ypoint = 200,
    refresh_rate = 0.2,
};

local gvalues    = {
    nopet_msg   = "No Pet",
    diepet_msg  = "Pet Died",
    passive_msg = "Pet Passive",
    timer       = nil,
}

if GetLocale() == "koKR" then
    gvalues.nopet_msg = "소환수 없음";
    gvalues.diepet_msg = "소환수 죽음";
    gvalues.passive_msg = "소환수 수동적"
end


local function alert_nopet()
    ns.msgtext:SetText(gvalues.nopet_msg);
    ns.msgtext:Show();
end

local function alert_diepet()
    ns.msgtext:SetText(gvalues.diepet_msg);
    ns.msgtext:Show();
end

local function alert_passive()
    ns.button:Show();
end

local function hide()
    ns.msgtext:Hide();
end
local function hidebutton()
    ns.button:Hide();
end

local cachedslot = nil;

local function ispetpassive()
    if not ns.options.ShowPassive then
        return false;
    end

    if cachedslot and UnitAffectingCombat("player") then
        return select(4, GetPetActionInfo(cachedslot));
    end

    for i = 1, NUM_PET_ACTION_SLOTS, 1 do
        local name, texture, isToken, isActive, autoCastAllowed, autoCastEnabled, spellID, checksRange, inRange =
            GetPetActionInfo(i);
        if name and name == "PET_MODE_PASSIVE" then
            cachedslot = i;
            return isActive
        end
    end
    return false;
end

local bred = false;

local function onupdate()
    if ns.msgtext:IsShown() then
        if bred then
            bred = false;
            ns.msgtext:SetTextColor(1, 1, 1);
        else
            bred = true;
            ns.msgtext:SetTextColor(1, 0, 0);
        end
    end

    local bhide = true;
    local bhidebutton = true;
    if UnitInVehicle("player") or (OverrideActionBar and OverrideActionBar:IsShown()) then
        --do nothing
    else
        if UnitExists("pet") then
            if UnitIsDead("pet") then
                alert_diepet();
                bhide = false;
                bhidebutton = true;
            elseif not UnitExists("pettarget") and UnitAffectingCombat("player") and ispetpassive() then
                alert_passive();
                bhide = true;
                bhidebutton = false;
            end
        elseif not IsMounted() then
            alert_nopet()
            bhide = false;
            bhidebutton = true;
        end
    end

    if bhide then
        hide();
    end

    if bhidebutton then
        hidebutton();
    end
end


local function init_class()
    local localizedClass, englishClass = UnitClass("player")
    local spec = C_SpecializationInfo.GetSpecialization();

    if spec == nil or spec > 4 or (englishClass ~= "DRUID" and spec > 3) then
        spec = 1;
    end

    local bwork = false;

    if (englishClass == "MAGE") then
        if (spec and spec == 3) then
            if (C_SpellBook.IsSpellKnown(31687)) then
                bwork = true;
            end
        end
    end

    if (englishClass == "WARLOCK") then
        if not (C_SpellBook.IsSpellKnown(108503)) then
            bwork = true;
        end
    end


    if (englishClass == "DEATHKNIGHT") then
        if (spec and spec == 3) then
            bwork = true;
        end
    end


    if (englishClass == "HUNTER") then
        if (spec and spec == 2) then
            if (C_SpellBook.IsSpellKnown(1223323)) then
                bwork = true;
            end
        else
            bwork = true;
        end
    end

    if gvalues.timer then
        gvalues.timer:Cancel();
    end

    if bwork then
        gvalues.timer = C_Timer.NewTicker(configs.refresh_rate, onupdate);
    else
        hide();
    end
end

local function on_event(self, event, ...)
    init_class();
end

function ns.check_status()
    ns.msgtext:SetFont(configs.font, ns.options.FontSize, configs.fontoutline);
end

local function init()
    ns.SetupOptionPanels();
    ns.msgtext = main_frame:CreateFontString(nil, "OVERLAY");
    ns.msgtext:SetFont(configs.font, configs.fontsize, configs.fontoutline)
    ns.msgtext:SetPoint("CENTER", main_frame, "CENTER", 0, 0);
    ns.msgtext:Hide();


    main_frame:SetPoint("CENTER", UIParent, "CENTER", configs.xpoint, configs.ypoint);
    main_frame:SetSize(100, 50);
    main_frame:Show();

    main_frame:SetScript("OnEvent", on_event);
    main_frame:RegisterEvent("PLAYER_ENTERING_WORLD");
    main_frame:RegisterEvent("TRAIT_CONFIG_UPDATED");
    main_frame:RegisterEvent("TRAIT_CONFIG_LIST_UPDATED");
    main_frame:RegisterEvent("ACTIVE_TALENT_GROUP_CHANGED");


    local libasConfig = LibStub:GetLibrary("LibasConfig", true);

    if libasConfig then
        libasConfig.load_position(main_frame, "asPetAlert (Text)", APA_Positions);
    end

    ns.msgtext:SetFont(configs.font, ns.options.FontSize, configs.fontoutline)

    ns.button = CreateFrame("Button", nil, UIParent, "asPETAButtonTemplate");

    ns.button:SetFrameStrata("LOW");
    ns.button:EnableMouse(false);


    ns.button.icon:SetTexCoord(.08, .92, .08, .92);
    ns.button.icon:SetTexture(PET_PASSIVE_TEXTURE);
    ns.button.border:SetTexCoord(0.08, 0.08, 0.08, 0.92, 0.92, 0.08, 0.92, 0.92);
    ns.button.border:SetVertexColor(0, 0, 0);

    ns.button:SetPoint("CENTER", configs.button_xpoint, configs.button_ypoint)
    ns.button:SetWidth(configs.buttonsize);
    ns.button:SetHeight(configs.buttonsize * 0.9);
    ns.button:Hide();

    if libasConfig then
        libasConfig.load_position(ns.button, "asPetAlert (Button)", APA_Positions2);
    end
    init_class();
end

C_Timer.After(1, init);
