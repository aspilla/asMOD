local _, ns = ...;

local Options_Default = {
	Version = 250920,
	PlayerDebuffRate = 1.3,
	CombatAlphaChange = true,
};

ns.configs = {
	SIZE = 28,
	TARGET_DEBUFF_X = 75 + 30 + 20,
	TARGET_DEBUFF_Y = -160,
	PLAYER_DEBUFF_X = -75 - 30 - 20,
	PLAYER_DEBUFF_Y = -130,
	MAX_DEBUFF_SHOW = 7,
	CooldownFontSize = 12, -- Cooldown Font Size
	CountFontSize = 13, -- Count Font Size
	AlphaCombat = 1,   -- 전투중 Alpha 값
	AlphaNormal = 0.5, -- 비 전투중 Alpha 값
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
