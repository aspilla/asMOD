local _, ns = ...;

local Options_Default = {
	Version = 250920,
	PlayerDebuffRate = 1.3,
	CombatAlphaChange = true,
};

ns.configs = {
	size = 28,
	sizerate = 0.8,
	target_xpoint = 125,
	target_ypoint = -150,
	player_xpoint = -125,
	player_ypoint = -115,
	max_debuffs = 7,
	cool_fontsize = 12, -- Cooldown Font Size
	count_fontsize = 13, -- Count Font Size
	combat_alpha = 1,   -- 전투중 Alpha 값
	normal_alpha = 0.5, -- 비 전투중 Alpha 값
};

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
		ADF_Options[variable] = value;
		ns.options[variable] = value;
	end

	local category = Settings.RegisterVerticalLayoutCategory("asDebuffFilter")

	if ADF_Options == nil or Options_Default.Version ~= ADF_Options.Version then
		ADF_Options = {};
		ADF_Options = CopyTable(Options_Default);
	end

	if ADF_Positions_1 == nil then
		ADF_Positions_1 = {};
	end

	if ADF_Positions_2 == nil then
		ADF_Positions_2 = {};
	end

	ns.options = CopyTable(ADF_Options);

	for variable, _ in pairs(Options_Default) do
		local name = variable;

		if name ~= "Version" then
			local cvar_name = "asDebuffFilter_" .. variable;
			local tooltip = ""
			if ADF_Options[variable] == nil then
				ADF_Options[variable] = Options_Default[variable];
				ns.options[variable] = Options_Default[variable];
			end
			local defaultValue = Options_Default[variable];
			local currentValue = ADF_Options[variable];

			if tonumber(defaultValue) ~= nil then
				local setting = Settings.RegisterAddOnSetting(category, cvar_name, variable, tempoption,
					type(defaultValue), name, defaultValue);
				local options = Settings.CreateSliderOptions(1, 2, 0.1);
				options:SetLabelFormatter(MinimalSliderWithSteppersMixin.Label.Right);
				Settings.CreateSlider(category, setting, options, tooltip);
				Settings.SetValue(cvar_name, currentValue);
				Settings.SetOnValueChangedCallback(cvar_name, OnSettingChanged);
			else
				local setting = Settings.RegisterAddOnSetting(category, cvar_name, variable, tempoption,
					type(defaultValue), name, defaultValue);

				Settings.CreateCheckboxWithOptions(category, setting, nil, tooltip);
				Settings.SetValue(cvar_name, currentValue);
				Settings.SetOnValueChangedCallback(cvar_name, OnSettingChanged);
			end
		end
	end

	Settings.RegisterAddOnCategory(category)
end
