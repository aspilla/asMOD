local _, ns      = ...;

local main_frame = CreateFrame("FRAME", nil, UIParent);

local configs    = {
    font = STANDARD_TEXT_FONT,
    fontsize = 30,
    fontoutline = "THICKOUTLINE",
    xpoint = 0,
    ypoint = 150,

    button_xpoint = 0,
    button_ypoint = 150,
    refresh_rate = 0.2,
};

local gvalues    = {
    alertstance = nil,
    timer       = nil,
    bdruid      = false,
    rogue_msg   = "Stealth",
    protect_msg = "Protect Stance",
    battle_msg  = "Battle Stance",
    shadow_msg  = "No Shadow",
    wolf_msg    = "Wolf Form",
    forms       = {
        [0] = "Human Form",
        [1] = "Bear Form",
        [2] = "Cat Form",
        [3] = "Travel Form",
        [4] = "Moonkin Form",
    },
    showframe = ns.msgtext;
}

if GetLocale() == "koKR" then
    gvalues.rogue_msg   = "은신 중";
    gvalues.protect_msg = "방어 태세";
    gvalues.battle_msg  = "전투 태세";
    gvalues.shadow_msg  = "암흑 아님";
    gvalues.wolf_msg    = "늑대폼";
    gvalues.forms       = {
        [0] = "인간폼",
        [1] = "곰폼",
        [2] = "캣폼",
        [3] = "이동폼",
        [4] = "달빛폼",
    }
end

local function setstanceicon(index)
    local spellid = select (4, GetShapeshiftFormInfo(index));
    if spellid then
        local spellinfo = C_Spell.GetSpellInfo(spellid);
        if spellinfo and spellinfo.iconID then
            ns.button.icon:SetTexture(spellinfo.iconID);
            return true;
        end
    end
    return false;
end

local function hide()
    gvalues.showframe:Hide();
end

local bred = false;

local function onupdate()
    if gvalues.alertstance == nil then
        return;
    end

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

    local index = GetShapeshiftForm()

    if gvalues.bdruid then
        if index ~= gvalues.alertstance then
            local text = gvalues.forms[index];
            if text then
                bhide = false;
                ns.msgtext:SetText(text);
            end
            local updated = setstanceicon(index);
            if updated then
                bhide = false;
            end

            if bhide == false then
                gvalues.showframe:Show();
            end
        end
    else
        if index == gvalues.alertstance then
            bhide = false;
            gvalues.showframe:Show();
        end
    end


    if bhide then
        hide();
    end
end


local function init_class()
    local localizedClass, englishClass = UnitClass("player")
    local spec = C_SpecializationInfo.GetSpecialization();

    if spec == nil or spec > 4 or (englishClass ~= "DRUID" and spec > 3) then
        spec = 1;
    end

    local bwork = false;
    gvalues.alertstance = nil;
    if (englishClass == "ROGUE") then
        bwork = true;
        gvalues.alertstance = 1;
        ns.msgtext:SetText(gvalues.rogue_msg);
        setstanceicon(gvalues.alertstance);
    end

    if (englishClass == "SHAMAN") then
        bwork = true;
        gvalues.alertstance = 1;
        ns.msgtext:SetText(gvalues.wolf_msg);
        setstanceicon(gvalues.alertstance);
    end

    if (englishClass == "WARRIOR") then
        bwork = true;
        if spec == 1 then
            gvalues.alertstance = 1;
            ns.msgtext:SetText(gvalues.protect_msg);
        end
        if spec == 2 then
            gvalues.alertstance = 1;
            ns.msgtext:SetText(gvalues.protect_msg);
        end
        if spec == 3 then
            gvalues.alertstance = 2;
            ns.msgtext:SetText(gvalues.battle_msg);
        end
        setstanceicon(gvalues.alertstance);
    end
    if (englishClass == "PRIEST") and spec == 3 then
        bwork = true;
        gvalues.alertstance = 0;
        ns.msgtext:SetText(gvalues.shadow_msg);
        setstanceicon(1);
    end

    if (englishClass == "DRUID") then
        bwork = true;
        gvalues.bdruid = true;
        if spec == 1 then
            gvalues.alertstance = 4;
        elseif spec == 2 then
            gvalues.alertstance = 2;
        elseif spec == 3 then
            gvalues.alertstance = 1;
        else
            gvalues.alertstance = 0;
        end
    end

    if ns.options.ButtonAlert then
        gvalues.showframe = ns.button;
    else
        gvalues.showframe = ns.msgtext;

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

    local libasConfig = LibStub:GetLibrary("LibasConfig", true);

    if libasConfig then
        libasConfig.load_position(main_frame, "asStanceAlert (Text)", ASTA_Positions);
    end

    ns.msgtext:SetFont(configs.font, ns.options.FontSize, configs.fontoutline);

    ns.button = CreateFrame("Button", nil, UIParent, "asSTAButtonTemplate");

    ns.button:SetFrameStrata("LOW");
    ns.button:EnableMouse(false);


    ns.button.icon:SetTexCoord(.08, .92, .08, .92);
    ns.button.border:SetTexCoord(0.08, 0.08, 0.08, 0.92, 0.92, 0.08, 0.92, 0.92);
    ns.button.border:SetVertexColor(0, 0, 0);

    ns.button:SetPoint("CENTER", configs.button_xpoint, configs.button_ypoint)
    ns.button:SetWidth(ns.options.ButtonSize);
    ns.button:SetHeight(ns.options.ButtonSize * 0.9);
    ns.button:Hide();

    if libasConfig then
        libasConfig.load_position(ns.button, "asStanceAlert (Button)", ASTA_Positions2);
    end

    init_class();
    main_frame:SetScript("OnEvent", on_event);
    main_frame:RegisterEvent("PLAYER_ENTERING_WORLD");
    main_frame:RegisterEvent("TRAIT_CONFIG_UPDATED");
    main_frame:RegisterEvent("TRAIT_CONFIG_LIST_UPDATED");
    main_frame:RegisterEvent("ACTIVE_TALENT_GROUP_CHANGED");

end

C_Timer.After(1, init);
