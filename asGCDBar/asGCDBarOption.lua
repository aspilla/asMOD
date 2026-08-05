local _, ns = ...;
local Options_Default = {
	Version = 260805,
	BarWidth = 238 + 40,
	BarHeight = 5,
	CombatAlphaChange = true,
	ShowAnimation = true,
};

local L = {
	BarWidth = "Width of Bar",
	BarHeight = "Height of the GCD bar",
	CombatAlphaChange = "Adjusts transparency when out of combat",
	ShowAnimation = "Toggle smooth bar change animation",
}


if GetLocale() == "koKR" then
	L = {
		BarWidth = "바 넓이",
		BarHeight = "GCD바 높이",
		CombatAlphaChange = "비전투시 투명도 변경",
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
		AGCDB_Options[variable] = value;
		ns.options[variable] = value;

		if tonumber(value) == nil then
			ReloadUI();
		end
	end

	local category = Settings.RegisterVerticalLayoutCategory("asGCDBar")

	if not category then
		return;
	end

	if AGCDB_Options == nil or Options_Default.Version ~= AGCDB_Options.Version then
		AGCDB_Options = {};
		AGCDB_Options = CopyTable(Options_Default);
		AGCDB_Positions = {};
	end

	if AGCDB_Positions == nil then
		AGCDB_Positions = {};
	end

	ns.options = CopyTable(AGCDB_Options);


	for variable, _ in pairs(Options_Default) do
		local name = variable;
		local cvar_name = "asGCDBar_" .. variable;
		local tooltip = ""
		if AGCDB_Options[variable] == nil then
			AGCDB_Options[variable] = Options_Default[variable];
			ns.options[variable] = Options_Default[variable];
		end
		local defaultValue = Options_Default[variable];
		local currentValue = AGCDB_Options[variable];

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
