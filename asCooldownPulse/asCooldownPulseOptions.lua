local _, ns = ...;
local Options_Default = {
	version = 260201,
	CombatAlphaChange = true,
	ShowTrinkets = true,
	TrinketSize = 28,
	ShowItems = true,
	ItemSize = 28,
	ShowSpells = true,
	SpellSize = 28,
};

local Options_DefaultSpells = {
	[186289] = 2, -- 생냥 독수리 상
}

ns.options = CopyTable(Options_Default);
ns.show_list = {};

local tempoption = {};

ns.buffpanel = CreateFrame("Frame")

function ns.refresh_list()
	if ns.buffpanel.bufflisttext then
		local text = "";
		for id, value in pairs(ns.show_list) do
			local _, name, _, icon = ns.get_spellinfo(id)

			if name then
				text = text .. value .. " |T" .. icon .. ":0|t " .. name .. " " .. id .. "\n";
			end
		end

		ns.buffpanel.bufflisttext:SetText(text);
	end
end

local function SetupSubOption(panel, titlename, coption, soption)
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

	local localeTexts = { "Spell ID", "Priority" };

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
		ACDP_Spelllist = CopyTable(Options_DefaultSpells);
		ns.show_list = CopyTable(ACDP_Spelllist);
		ns.scan_spells();
		ns.refresh_list();
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
		{ text = "Priority 1", value = 1 },
		{ text = "Priority 2", value = 2 },
		{ text = "Priority 3", value = 3 },
		{ text = "Priority 4", value = 4 },
		{ text = "Priority 5", value = 5 },
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
		local newspell = editBox:GetNumber();
		local newtype = tonumber(UIDropDownMenu_GetSelectedValue(dropDown));	
		if newspell and newspell > 0 then
			coption[newspell] = newtype;
			if soption then
				soption[newspell] = newtype;
			end
			ns.scan_spells();
			ns.refresh_list();
		end
	end);

	x = x + 120;

	local btn2 = CreateFrame("Button", nil, panel.scrollchild, "UIPanelButtonTemplate")
	btn2:SetPoint("LEFT", panel.scrollchild, "TOPLEFT", x, curr_y)
	btn2:SetText("Delete")
	btn2:SetWidth(100)
	btn2:SetScript("OnClick", function()
		local newspell = editBox:GetNumber();
		if newspell and newspell > 0 then
			coption[newspell] = nil;
			if soption then
				soption[newspell] = nil;
			end
			ns.scan_spells();
			ns.refresh_list();
		end
	end);

	
	curr_y = curr_y + y_adder;

	panel.bufflisttext = panel.scrollchild:CreateFontString(nil, "ARTWORK", "GameFontNormal");
	panel.bufflisttext:SetFont(STANDARD_TEXT_FONT, 20, "THICKOUTLINE");
	panel.bufflisttext:SetPoint("TOPLEFT", 10, curr_y);
	panel.bufflisttext:SetTextColor(1, 1, 1);
	panel.bufflisttext:SetJustifyH("LEFT");
	panel.bufflisttext:Show();

	ns.scan_spells();
	ns.refresh_list();
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
		ACDP_Options[variable] = value;
		ns.options[variable] = value;
		if tonumber(value) == nil then
			ReloadUI();
		end
	end

	local category = Settings.RegisterVerticalLayoutCategory("asCooldownPulse");
	local subcategory, subcategoryLayout = Settings.RegisterCanvasLayoutSubcategory(category, ns.buffpanel, "Spell List");

	if ACDP_Options == nil or ACDP_Options.version ~= Options_Default.version then
		ACDP_Options = {};
		ACDP_Options = CopyTable(Options_Default);
		ACDP_Spelllist = {};
		ACDP_Spelllist = CopyTable(Options_DefaultSpells);
	end

	if ACDP_Spelllist == nil then
		ACDP_Spelllist = {};
		ACDP_Spelllist = CopyTable(Options_DefaultSpells);
	end

	if ACDP_Positions_1 == nil then
		ACDP_Positions_1 = {};
	end

	if ACDP_Positions_2 == nil then
		ACDP_Positions_2 = {};
	end

	if ACDP_Positions_3 == nil then
		ACDP_Positions_3 = {};
	end


	ns.options = CopyTable(ACDP_Options);
	ns.show_list = CopyTable(ACDP_Spelllist);

	for variable, _ in pairs(Options_Default) do
		if variable ~= "version" then
			local name = variable;
			local cvar_name = "asCooldownPulse_" .. variable;
			local tooltip = ""
			if ACDP_Options[variable] == nil then
				ACDP_Options[variable] = Options_Default[variable];
				ns.options[variable] = Options_Default[variable];
			end
			local defaultValue = Options_Default[variable];
			local currentValue = ACDP_Options[variable];

			if tonumber(defaultValue) ~= nil then
				local setting = Settings.RegisterAddOnSetting(category, cvar_name, variable, tempoption,
					type(defaultValue), name, defaultValue);
				local options = Settings.CreateSliderOptions(0, 400, 1);
				options:SetLabelFormatter(MinimalSliderWithSteppersMixin.Label.Right);
				Settings.CreateSlider(category, setting, options, tooltip);
				Settings.SetValue(cvar_name, currentValue);
				Settings.SetOnValueChangedCallback(cvar_name, OnSettingChanged);
			else
				local setting = Settings.RegisterAddOnSetting(category, cvar_name, variable, tempoption,
					type(defaultValue),
					name, defaultValue);
				Settings.CreateCheckboxWithOptions(category, setting, nil, tooltip);
				Settings.SetValue(cvar_name, currentValue);
				Settings.SetOnValueChangedCallback(cvar_name, OnSettingChanged);
			end
		end
	end

	Settings.RegisterAddOnCategory(category)

	SetupSubOption(ns.buffpanel, "Spell List", ns.show_list, ACDP_Spelllist);
end
