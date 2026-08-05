local _, ns = ...;
local Options_Default = {
	Version = 260804,
	Size = 26,
	Alpha = 1,
	FontSize = 10,
	MillisecondsThreshold = 3,
};

local L = {
	Size = "Icon Size",
	Alpha = "Icon Alpha",
	FontSize = "Font Size",
	MillisecondsThreshold = "Remaining cooldown begins displaying in 0.1-second increments",
}


if GetLocale() == "koKR" then
	L = {
		Size = "아이콘 크기",
		Alpha = "아이콘 투명도",
		FontSize = "글꼴 크기",
		MillisecondsThreshold = "남은 쿨을 0.1초 단위로 보여줄 최소 시간",
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
		ASAA_Options[variable] = value;
		ns.options[variable] = value;

		if tonumber(value) == nil then
			ReloadUI();
		end
	end

	local category = Settings.RegisterVerticalLayoutCategory("asActiveAlert")

	if not category then
		return;
	end

	if ASAA_Options == nil or Options_Default.Version ~= ASAA_Options.Version then
		ASAA_Options = {};
		ASAA_Options = CopyTable(Options_Default);
		ASAA_Positions = {};
	end

	if ASAA_Positions == nil then
		ASAA_Positions = {};
	end

	ns.options = CopyTable(ASAA_Options);


	for variable, _ in pairs(Options_Default) do
		local name = variable;
		local cvar_name = "asActiveAlert_" .. variable;
		local tooltip = ""
		if ASAA_Options[variable] == nil then
			ASAA_Options[variable] = Options_Default[variable];
			ns.options[variable] = Options_Default[variable];
		end
		local defaultValue = Options_Default[variable];
		local currentValue = ASAA_Options[variable];

		if name ~= "Version" then
			if name == "MillisecondsThreshold" then
				local setting = Settings.RegisterAddOnSetting(category, cvar_name, variable, tempoption,
					type(defaultValue), L[name], defaultValue);
				local options = Settings.CreateSliderOptions(0, 10, 1);
				options:SetLabelFormatter(MinimalSliderWithSteppersMixin.Label.Right);
				Settings.CreateSlider(category, setting, options, tooltip);
				Settings.SetValue(cvar_name, currentValue);
				Settings.SetOnValueChangedCallback(cvar_name, OnSettingChanged);
			elseif name == "Size" then
				local setting = Settings.RegisterAddOnSetting(category, cvar_name, variable, tempoption,
					type(defaultValue), L[name], defaultValue);
				local options = Settings.CreateSliderOptions(10, 100, 1);
				options:SetLabelFormatter(MinimalSliderWithSteppersMixin.Label.Right);
				Settings.CreateSlider(category, setting, options, tooltip);
				Settings.SetValue(cvar_name, currentValue);
				Settings.SetOnValueChangedCallback(cvar_name, OnSettingChanged);
			elseif name == "FontSize" then
				local setting = Settings.RegisterAddOnSetting(category, cvar_name, variable, tempoption,
					type(defaultValue), L[name], defaultValue);
				local options = Settings.CreateSliderOptions(6, 30, 1);
				options:SetLabelFormatter(MinimalSliderWithSteppersMixin.Label.Right);
				Settings.CreateSlider(category, setting, options, tooltip);
				Settings.SetValue(cvar_name, currentValue);
				Settings.SetOnValueChangedCallback(cvar_name, OnSettingChanged);
			elseif name == "Alpha" then
				local setting = Settings.RegisterAddOnSetting(category, cvar_name, variable, tempoption,
					type(defaultValue), L[name], defaultValue);
				local options = Settings.CreateSliderOptions(0.1, 1.0, 0.1);
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
end
