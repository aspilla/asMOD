local _, ns = ...;

local configs = {
    font = STANDARD_TEXT_FONT,
    fontoutline = "THICKOUTLINE",
    text_xpoint = 0,
    text_ypoint = -8,
    text_updaterate = 0.1,
}


local main_frame = CreateFrame("Frame", nil, UIParent);

local function setupUI()
    ns.setup_option();

    ns.textframe = CreateFrame("FRAME", nil, UIParent);
    local textframe = ns.textframe;

    textframe:SetFrameStrata("LOW");
    textframe:SetPoint("CENTER", UIParent, "CENTER", configs.text_xpoint, configs.text_ypoint)
    textframe:SetWidth(100)
    textframe:SetHeight(ns.options.TextSize);
    textframe:Show();

    textframe.text = textframe:CreateFontString(nil, "OVERLAY");
    textframe.text:SetFont(configs.font, ns.options.TextSize, configs.fontoutline)
    textframe.text:SetPoint("CENTER", textframe, "CENTER", 0, 0);
    textframe.text:Show();

    local libasConfig = LibStub:GetLibrary("LibasConfig", true);

    if libasConfig then
        libasConfig.load_position(textframe, "asSpellRemain", ASPR_Positions);
    end
end

local function update_text()
    local textframe = ns.textframe;
    if ns.spellinfo.id then
        local id = ns.spellinfo.id;
        local name = ns.spellinfo.name;
        local cd = C_Spell.GetSpellCooldown(id)
        if not cd.isActive or cd.isOnGCD then
            textframe:Hide();
        else
            local duration = C_Spell.GetSpellCooldownDuration(id, true)
            if duration then
                textframe.text:SetText(string.format("No %s (%.1f)", name, duration:GetRemainingDuration()));
                textframe:Show();
            else
                textframe:Hide();
            end
        end
    else
        textframe:Hide();
    end
end


local function on_event()
    ns.scan_spells();
end

local function initAddon()
    setupUI();
    main_frame:RegisterEvent("PLAYER_ENTERING_WORLD");
    main_frame:RegisterEvent("TRAIT_CONFIG_UPDATED");
    main_frame:RegisterEvent("TRAIT_CONFIG_LIST_UPDATED");
    main_frame:RegisterEvent("ACTIVE_TALENT_GROUP_CHANGED");
    ns.scan_spells();
    main_frame:SetScript("OnEvent", on_event);
    C_Timer.NewTicker(configs.text_updaterate, update_text);
end
C_Timer.After(0.5, initAddon);
