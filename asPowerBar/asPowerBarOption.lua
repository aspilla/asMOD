local _, ns = ...;
local Options_Default = {
	Version = 260722,
	ShowClassResource = true,
	CombatAlphaChange = true,
	BarWidth = 238 + 75,
	PowerBarHeight = 6,
	ComboBarHeight = 4,
	FontSize = 12,
	ShowAnimation = true,
};

local L = {
	ShowClassResource = "Class-specific resource(Spell Charge..) display",
	CombatAlphaChange = "Adjusts transparency when out of combat",
	BarWidth = "Width of Bars",
	PowerBarHeight = "Height of the main resource bar",
	ComboBarHeight = "Height of the secondary resource bar",
	FontSize = "Font size for text",
	ShowAnimation = "Toggle smooth bar change animation",
}


if GetLocale() == "koKR" then
	L = {
		ShowClassResource = "직업 전문화 자원(스킬등) 표시",
		CombatAlphaChange = "비전투시 투명도 변경",
		BarWidth = "바 넓이",
		PowerBarHeight = "주 자원바 높이",
		ComboBarHeight = "보조 자원바 높이",
		FontSize = "글꼴 크기",
		ShowAnimation = "부드러운 바 애니메이션",
	}
end

ns.options = CopyTable(Options_Default);
local tempoption = {};


function ns.setup_option()
	local function OnSettingChanged(_, setting, value)
		local function get_variable_from_cvar_name(cvar_name)
			local variable_start_index = string.find(cvar_name, "_") + 1
			local variable = string.sub(cvar_name, variable_start_index)
			return variable
		end

		local cvar_name = setting:GetVariable()
		local variable = get_variable_from_cvar_name(cvar_name)
		ASPB_Options[variable] = value;
		ns.options[variable] = value;

		if tonumber(value) == nil then
			ReloadUI();
		end
	end

	local category = Settings.RegisterVerticalLayoutCategory("asPowerBar")

	if not category then
		return;
	end

	if ASPB_Options == nil or Options_Default.Version ~= ASPB_Options.Version then
		ASPB_Options = {};
		ASPB_Options = CopyTable(Options_Default);
	end

	if ASPB_Positions == nil then
		ASPB_Positions = {};
	end

	ns.options = CopyTable(ASPB_Options);


	for variable, _ in pairs(Options_Default) do
		local name = variable;
		local cvar_name = "asPowerBar_" .. variable;
		local tooltip = ""
		if ASPB_Options[variable] == nil then
			ASPB_Options[variable] = Options_Default[variable];
			ns.options[variable] = Options_Default[variable];
		end
		local defaultValue = Options_Default[variable];
		local currentValue = ASPB_Options[variable];

		if name ~= "Version" then
			if tonumber(defaultValue) ~= nil then
				local setting = Settings.RegisterAddOnSetting(category, cvar_name, variable, tempoption,
					type(defaultValue), L[name], defaultValue);
				local options = Settings.CreateSliderOptions(0, 400, 1);
				options:SetLabelFormatter(MinimalSliderWithSteppersMixin.Label.Right);
				Settings.CreateSlider(category, setting, options, tooltip);
				Settings.SetValue(cvar_name, currentValue);
				Settings.SetOnValueChangedCallback(cvar_name, OnSettingChanged);
			else
				local setting = Settings.RegisterAddOnSetting(category, cvar_name, variable, tempoption,
					type(defaultValue), L[name], defaultValue);
				Settings.CreateCheckboxWithOptions(category, setting, nil, tooltip)
				Settings.SetValue(cvar_name, currentValue);
				Settings.SetOnValueChangedCallback(cvar_name, OnSettingChanged);
			end
		end
	end

	Settings.RegisterAddOnCategory(category)

	if ns.options.ShowAnimation then
		ns.bartype = Enum.StatusBarInterpolation.ExponentialEaseOut;
	else
		ns.bartype = 0;
	end
end
