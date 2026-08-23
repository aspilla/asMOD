local _, ns = ...;

local Options_Default = {
    Version = 260823,
	MaxShow = 3,
	HideBloodDebuff = true,
	ShowType = 2,
	MillisecondsThreshold = 3,
};

local L = {
	MaxShow = "The maximum number of debuffs to display",
	MillisecondsThreshold = "Remaining cooldown begins displaying in 0.1-second increments",
	HideBloodDebuff = "Hide bloodlust debuffs",
	SpellList = "Debuff List",
	SpellID = "Debuff Id",
	LoadDefault = "Load Default",
	Add = "Add",
	Remove = "Remove",
	ShowType = "Type of debuffs showing",
    ShowType1 = "Debuff list only",
    ShowType2 = "Nameplate debuffs + Debuff list (Default)",
    ShowType3 = "Show my all debuffs",
}


if GetLocale() == "koKR" then
	L = {
		MaxShow = "최대 표시 디버프 개수",
		MillisecondsThreshold = "남은 쿨을 0.1초 단위로 보여줄 최소 시간",
		HideBloodDebuff = "블러드 디버프는 숨김",
		SpellList = "디버프 목록",
		SpellID = "디버프 ID",
		LoadDefault = "기본 설정",
		Add = "추가",
		Remove = "제거",
		ShowType = "디버프 표시 방식",
		ShowType1 = "디버프 목록만",
    	ShowType2 = "이름표 디버프 + 디버프 목록 (기본)",
     	ShowType3 = "내 디버프 모두",
	}
end

local Options_DefaultSpells = {
	--Hunter
    [257284] = true,

    --Mage
	[453268] = true,
	[12654] = true,
};

ns.options = CopyTable(Options_Default);
ns.show_list = {};
local tempoption = {};

ns.buffpanel = CreateFrame("Frame")

local function get_spellinfo(spellid)
	if not spellid then
		return nil;
	end

	local or_spellid = C_Spell.GetOverrideSpell(spellid)

	if or_spellid then
		spellid = or_spellid;
	end

	local spellInfo = C_Spell.GetSpellInfo(spellid);
	if spellInfo then
		return spellid, spellInfo.name, nil, spellInfo.iconID, spellInfo.castTime, spellInfo.minRange, spellInfo
			.maxRange,
			spellInfo.spellID, spellInfo.originalIconID;
	end
end

function ns.refresh_list()
	if ns.buffpanel.bufflisttext then
		local text = "";
		for id, value in pairs(ns.show_list) do
			local _, name, _, icon = get_spellinfo(id);
			if name then
				text = text .. " |T" .. icon .. ":0|t " .. name .. " " .. id .. "\n";
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

	local localeTexts = { L.SpellID };

	local x = 10;

	local title = panel.scrollchild:CreateFontString(nil, "ARTWORK", "GameFontNormal");
	title:SetPoint("TOPLEFT", x, curr_y);
	title:SetText(localeTexts[1]);

	x = 350;

	local btn0 = CreateFrame("Button", nil, panel.scrollchild, "UIPanelButtonTemplate")
	btn0:SetPoint("LEFT", panel.scrollchild, "TOPLEFT", x, curr_y)
	btn0:SetText(L.LoadDefault)
	btn0:SetWidth(100)
	btn0:SetScript("OnClick", function()
		ADotF_DebuffLists = CopyTable(Options_DefaultSpells);
		ns.show_list = CopyTable(ADotF_DebuffLists);
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

	--editBox:HookScript("OnTextChanged", function() end);
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
	x = x + 300;

	local btn = CreateFrame("Button", nil, panel.scrollchild, "UIPanelButtonTemplate")
	btn:SetPoint("LEFT", panel.scrollchild, "TOPLEFT", x, curr_y)
	btn:SetText(L.Add)
	btn:SetWidth(100)
	btn:SetScript("OnClick", function()
		local newspell = editBox:GetNumber();
		if newspell and newspell > 0 then
			coption[newspell] = true;
			if soption then
				soption[newspell] = true;
			end
			ns.refresh_list();
		end
	end);

	x = x + 120;

	local btn2 = CreateFrame("Button", nil, panel.scrollchild, "UIPanelButtonTemplate")
	btn2:SetPoint("LEFT", panel.scrollchild, "TOPLEFT", x, curr_y)
	btn2:SetText(L.Remove)
	btn2:SetWidth(100)
	btn2:SetScript("OnClick", function()
		local newspell = editBox:GetNumber();
		if newspell and newspell > 0 then
			coption[newspell] = nil;
			if soption then
				soption[newspell] = nil;
			end
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
		ADotF_Options[variable] = value;
		ns.options[variable] = value;
	end

	local category = Settings.RegisterVerticalLayoutCategory("asDotFilter")
	local subcategory, subcategoryLayout = Settings.RegisterCanvasLayoutSubcategory(category, ns.buffpanel, L.SpellList);

	if ADotF_Options == nil or Options_Default.Version ~= ADotF_Options.Version then
		ADotF_Options = {};
		ADotF_Options = CopyTable(Options_Default);
		ADotF_DebuffLists = {};
		ADotF_DebuffLists = CopyTable(Options_DefaultSpells);
	end

	ns.options = CopyTable(ADotF_Options);
	ns.show_list = CopyTable(ADotF_DebuffLists);

	for variable, _ in pairs(Options_Default) do
		local name = variable;

		if name ~= "Version" then
			local cvar_name = "asDotFilter_" .. variable;
			local tooltip = ""
			if ADotF_Options[variable] == nil then
				ADotF_Options[variable] = Options_Default[variable];
				ns.options[variable] = Options_Default[variable];
			end
			local defaultValue = Options_Default[variable];
			local currentValue = ADotF_Options[variable];

			if name == "ShowType" then
                local function GetOptions()
                    local container = Settings.CreateControlTextContainer()
                    container:Add(1, L.ShowType1)
                    container:Add(2, L.ShowType2)
                    container:Add(3, L.ShowType3)
                    return container:GetData()
                end

                local setting = Settings.RegisterAddOnSetting(category, cvar_name, variable, tempoption, type(defaultValue), L[name], defaultValue)
                Settings.CreateDropdown(category, setting, GetOptions, tooltip)
                Settings.SetValue(cvar_name, currentValue);
                Settings.SetOnValueChangedCallback(cvar_name, OnSettingChanged)
			elseif name == "MillisecondsThreshold" then
				local setting = Settings.RegisterAddOnSetting(category, cvar_name, variable, tempoption,
					type(defaultValue), L[name], defaultValue);
				local options = Settings.CreateSliderOptions(0, 10, 1);
				options:SetLabelFormatter(MinimalSliderWithSteppersMixin.Label.Right);
				Settings.CreateSlider(category, setting, options, tooltip);
				Settings.SetValue(cvar_name, currentValue);
				Settings.SetOnValueChangedCallback(cvar_name, OnSettingChanged);
			elseif tonumber(defaultValue) ~= nil then
				local setting = Settings.RegisterAddOnSetting(category, cvar_name, variable, tempoption,
					type(defaultValue), L[name], defaultValue);
				local options = Settings.CreateSliderOptions(1, 7, 1);
				options:SetLabelFormatter(MinimalSliderWithSteppersMixin.Label.Right);
				Settings.CreateSlider(category, setting, options, tooltip);
				Settings.SetValue(cvar_name, currentValue);
				Settings.SetOnValueChangedCallback(cvar_name, OnSettingChanged);
			else
				local setting = Settings.RegisterAddOnSetting(category, cvar_name, variable, tempoption,
					type(defaultValue), L[name], defaultValue);

				Settings.CreateCheckboxWithOptions(category, setting, nil, tooltip);
				Settings.SetValue(cvar_name, currentValue);
				Settings.SetOnValueChangedCallback(cvar_name, OnSettingChanged);
			end
		end
	end

	Settings.RegisterAddOnCategory(category)
	SetupSubOption(ns.buffpanel, L.SpellList, ns.show_list, ADotF_DebuffLists);
end
