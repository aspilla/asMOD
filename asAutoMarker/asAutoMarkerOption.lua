local _, ns = ...;
local Options_Default = {
    TankHealerMark = true,
    MouseOverMark = true,
};

local OtherOptions_Default = {
    Version = 250628,
}

ns.options = CopyTable(Options_Default);
ns.CustomNPCTable = {};
local tempoption = {};


local npcpanel = CreateFrame("Frame")
local function refreshList()
	if npcpanel.npclisttext then
		local text = "";
		for id, value in pairs(ns.CustomNPCTable) do
            text = text .. id .. " " .. value .. "\n";
		end

		npcpanel.npclisttext:SetText(text);
	end
end


local function SetupSubOption(panel, titlename)
    local curr_y = 0;
    local y_adder = -40;

    if panel.scrollframe then
        panel.scrollframe:Hide()
        panel.scrollframe:UnregisterAllEvents()
        panel.scrollframe = nil;
    end

    panel.scrollframe = CreateFrame("ScrollFrame", nil, panel, "UIPanelScrollFrameTemplate")
    panel.scrollframe:SetPoint("TOPLEFT", 3, -4)
    panel.scrollframe:SetPoint("BOTTOMRIGHT", -27, 4)

    -- Create the scrolling child frame, set its width to fit, and give it an arbitrary minimum height (such as 1)
    panel.scrollchild = CreateFrame("Frame")
    panel.scrollframe:SetScrollChild(panel.scrollchild)
    panel.scrollchild:SetWidth(600)
    panel.scrollchild:SetHeight(1)

    -- add widgets to the panel as desired
    local title = panel:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
    title:SetPoint("TOP")
    title:SetText(titlename)

    curr_y = curr_y + y_adder;

    local localeTexts = { "NPC ID", "Type" };

    local x = 10;

    local title = panel.scrollchild:CreateFontString(nil, "ARTWORK", "GameFontNormal");
    title:SetPoint("TOPLEFT", x, curr_y);
    title:SetText(localeTexts[1]);

    x = 200;

    title = panel.scrollchild:CreateFontString(nil, "ARTWORK", "GameFontNormal");
    title:SetPoint("TOPLEFT", x, curr_y);
    title:SetText(localeTexts[2]);

    x = 350;

    local btn0 = CreateFrame("Button", nil, panel.scrollchild, "UIPanelButtonTemplate")
    btn0:SetPoint("LEFT", panel.scrollchild, "TOPLEFT", x, curr_y)
    btn0:SetText("Load Default")
    btn0:SetWidth(100)
    btn0:SetScript("OnClick", function()
        AMM_NPCTable = {};
    end);


    curr_y = curr_y + y_adder;



    local x = 10;

    local editBox = CreateFrame("EditBox", nil, panel.scrollchild)
    do
        local editBoxLeft = editBox:CreateTexture(nil, "BACKGROUND")
        editBoxLeft:SetTexture(130959) --"Interface\\ChatFrame\\UI-ChatInputBorder-Left"
        editBoxLeft:SetHeight(32)
        editBoxLeft:SetWidth(32)
        editBoxLeft:SetPoint("LEFT", -14, 0)
        editBoxLeft:SetTexCoord(0, 0.125, 0, 1)
        local editBoxRight = editBox:CreateTexture(nil, "BACKGROUND")
        editBoxRight:SetTexture(130960) --"Interface\\ChatFrame\\UI-ChatInputBorder-Right"
        editBoxRight:SetHeight(32)
        editBoxRight:SetWidth(32)
        editBoxRight:SetPoint("RIGHT", 6, 0)
        editBoxRight:SetTexCoord(0.875, 1, 0, 1)
        local editBoxMiddle = editBox:CreateTexture(nil, "BACKGROUND")
        editBoxMiddle:SetTexture(130960) --"Interface\\ChatFrame\\UI-ChatInputBorder-Right"
        editBoxMiddle:SetHeight(32)
        editBoxMiddle:SetWidth(1)
        editBoxMiddle:SetPoint("LEFT", editBoxLeft, "RIGHT")
        editBoxMiddle:SetPoint("RIGHT", editBoxRight, "LEFT")
        editBoxMiddle:SetTexCoord(0, 0.9375, 0, 1)
    end

    editBox:HookScript("OnTextChanged", function() end);
    editBox:SetHeight(32)
    editBox:SetWidth(150)
    editBox:SetPoint("LEFT", panel.scrollchild, "TOPLEFT", x, curr_y)
    editBox:SetFontObject("GameFontHighlight")
    editBox:SetMultiLine(false);
    editBox:SetMaxLetters(20);
    editBox:SetText("");
    editBox:SetAutoFocus(false);
    editBox:ClearFocus();
    editBox:SetTextInsets(0, 0, 0, 1);
    editBox:SetNumeric(true);
    editBox:Show();
    editBox:SetCursorPosition(0);
    x = x + 150;


    local dropDown = CreateFrame("Frame", nil, panel.scrollchild, "UIDropDownMenuTemplate")
    dropDown:SetPoint("LEFT", panel.scrollchild, "TOPLEFT", x, curr_y)
    UIDropDownMenu_SetWidth(dropDown, 100) -- Use in place of dropDown:SetWidth

    local dropdownOptions = {
        { text = "Disable Mark",           value = 0 },
        { text = "Nameplate Color Only",         value = 1 },
        { text = "Auto Mark",   value = 2 },
    };


    UIDropDownMenu_Initialize(dropDown, function(self, level)
        for _, option in ipairs(dropdownOptions) do
            local info = UIDropDownMenu_CreateInfo()
            info.text = option.text
            info.value = option.value
            info.disabled = option.disabled
            local function Dropdown_OnClick()
                UIDropDownMenu_SetSelectedValue(dropDown, option.value);
            end
            info.func = Dropdown_OnClick;
            UIDropDownMenu_AddButton(info, level)
        end
        UIDropDownMenu_SetSelectedValue(dropDown, 0);
    end);

    x = x + 150;

    local btn = CreateFrame("Button", nil, panel.scrollchild, "UIPanelButtonTemplate")
    btn:SetPoint("LEFT", panel.scrollchild, "TOPLEFT", x, curr_y)
    btn:SetText("Add")
    btn:SetWidth(100)
    btn:SetScript("OnClick", function()
        local npcid = editBox:GetNumber();
        local marktype = tonumber(UIDropDownMenu_GetSelectedValue(dropDown));
        if npcid and npcid > 0 and AMM_NPCTable then
            AMM_NPCTable[npcid] = marktype;
            ns.CustomNPCTable[npcid] = marktype;
        end
        refreshList();
    end);

    x = x + 120;

    local btn2 = CreateFrame("Button", nil, panel.scrollchild, "UIPanelButtonTemplate")
    btn2:SetPoint("LEFT", panel.scrollchild, "TOPLEFT", x, curr_y)
    btn2:SetText("Delete")
    btn2:SetWidth(100)
    btn2:SetScript("OnClick", function()
        local npcid = editBox:GetNumber();
        if npcid and npcid > 0 and AMM_NPCTable then
            AMM_NPCTable[npcid] = nil;
            ns.CustomNPCTable[npcid] = nil;
        end
        refreshList();
    end);

    curr_y = curr_y + y_adder;

    panel.explaintext = panel.scrollchild:CreateFontString(nil, "ARTWORK", "GameFontNormal");
    panel.explaintext:SetFont(STANDARD_TEXT_FONT, 12, "THICKOUTLINE");
    panel.explaintext:SetPoint("TOPLEFT", 10, curr_y);
    panel.explaintext:SetTextColor(1, 1, 1);
    panel.explaintext:SetJustifyH("LEFT");
    panel.explaintext:SetText("0-Disable Mark, 1-Nameplate Color Only, 2-Auto Mark")
    panel.explaintext:Show();


    curr_y = curr_y + y_adder;

    panel.npclisttext = panel.scrollchild:CreateFontString(nil, "ARTWORK", "GameFontNormal");
    panel.npclisttext:SetFont(STANDARD_TEXT_FONT, 20, "THICKOUTLINE");
    panel.npclisttext:SetPoint("TOPLEFT", 10, curr_y);
    panel.npclisttext:SetTextColor(1, 1, 1);
    panel.npclisttext:SetJustifyH("LEFT");
    panel.npclisttext:Show();

    refreshList();

end



function ns.setup_option()
    local function OnSettingChanged(_, setting, value)
        local function get_variable_from_cvar_name(cvar_name)
            local variable_start_index = string.find(cvar_name, "_") + 1
            local variable = string.sub(cvar_name, variable_start_index)
            return variable
        end

        local cvar_name = setting:GetVariable()
        local variable = get_variable_from_cvar_name(cvar_name)
        AAM_Options[variable] = value;
        ns.options[variable] = value;
    end

    local category = Settings.RegisterVerticalLayoutCategory("asAutoMarker")
	local subcategory, subcategoryLayout = Settings.RegisterCanvasLayoutSubcategory(category, npcpanel, "NPC Table");


    if AAM_Options == nil or AAM_OtherOptions == nil or OtherOptions_Default.Version ~= AAM_OtherOptions.Version then
        AAM_Options = {}
        AAM_Options = CopyTable(Options_Default);
        AAM_OtherOptions = {};
        AAM_OtherOptions = CopyTable(OtherOptions_Default);
    end
    if AMM_NPCTable == nil then
        AMM_NPCTable = {};
    end

    ns.options = CopyTable(AAM_Options);
    ns.CustomNPCTable = CopyTable(AMM_NPCTable);

    for variable, _ in pairs(Options_Default) do
        local name = variable;

        local cvar_name = "asAutoMarker_" .. variable;
        local tooltip = ""
        if AAM_Options[variable] == nil then
            AAM_Options[variable] = Options_Default[variable];
            ns.options[variable] = Options_Default[variable];
        end
        local defaultValue = Options_Default[variable]
        local currentValue = AAM_Options[variable];

        if tonumber(defaultValue) ~= nil then
            local setting = Settings.RegisterAddOnSetting(category, cvar_name, variable, tempoption, type(defaultValue),
                name, defaultValue);
            local options = Settings.CreateSliderOptions(0, 100, 1);
            options:SetLabelFormatter(MinimalSliderWithSteppersMixin.Label.Right);
            Settings.CreateSlider(category, setting, options, tooltip);
            Settings.SetValue(cvar_name, currentValue);
            Settings.SetOnValueChangedCallback(cvar_name, OnSettingChanged);
        else
            local setting = Settings.RegisterAddOnSetting(category, cvar_name, variable, tempoption, type(defaultValue),
                name, defaultValue);
            Settings.CreateCheckboxWithOptions(category, setting, nil, tooltip);
            Settings.SetValue(cvar_name, currentValue);
            Settings.SetOnValueChangedCallback(cvar_name, OnSettingChanged);
        end
    end

    Settings.RegisterAddOnCategory(category)
	SetupSubOption(npcpanel, "NPC Table");
end
