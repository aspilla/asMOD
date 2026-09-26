local _, ns = ...;

local Options_Default = {
    Version = 260926,
	MillisecondsThreshold = 3,
};

ns.configs = {
	size = 40,
	sizerate = 0.9,
	player_xpoint = -145,
	player_ypoint = -50,
};

local L = {
	MillisecondsThreshold = "Remaining cooldown begins displaying in 0.1-second increments",
}


if GetLocale() == "koKR" then
	L = {
		MillisecondsThreshold = "0.1초 단위 표시 최소 시간",
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
		API_Options[variable] = value;
		ns.options[variable] = value;
	end

	local category = Settings.RegisterVerticalLayoutCategory("asPowerInfusion")

	if API_Options == nil or Options_Default.Version ~= API_Options.Version then
		API_Options = {};
		API_Options = CopyTable(Options_Default);
		API_Positions = {};
	end

	if API_Positions == nil then
		API_Positions = {};
	end

	ns.options = CopyTable(API_Options);

	for variable, _ in pairs(Options_Default) do
		local name = variable;

		if name ~= "Version" then
			local cvar_name = "asPowerInfusion_" .. variable;
			local tooltip = ""
			if API_Options[variable] == nil then
				API_Options[variable] = Options_Default[variable];
				ns.options[variable] = Options_Default[variable];
			end
			local defaultValue = Options_Default[variable];
			local currentValue = API_Options[variable];


			if name == "MillisecondsThreshold" then
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
				local options = Settings.CreateSliderOptions(1, 2, 0.1);
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
end
