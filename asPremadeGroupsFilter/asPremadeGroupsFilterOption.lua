local _, ns = ...;
local Options_Default = {
	ShowHealerSpec = false,
	ShowTankerSpec = false,
	ShowLeaderScore = true,
	--  KeepingApplicationText = true,
};

local L = {
	ShowHealerSpec = "Displays specialization icons/class color bars for healers.",
	ShowTankerSpec = "Displays specialization icons/class color bars for tanks.",
	ShowLeaderScore = "Displays the group leader's Mythic+ score.",
}


if GetLocale() == "koKR" then
	L = {
		ShowHealerSpec = "힐러의 전문화 아이콘/바 표시.",
		ShowTankerSpec = "탱커의 전문화 아이콘/바가 표시.",
		ShowLeaderScore = "그룹 리더의 신화 쐐기돌 점수 표시.",
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
		APMGF_Options[variable] = value;
		ns.options[variable] = value;
	end

	local category = Settings.RegisterVerticalLayoutCategory("asPremadeGroupsFilter")

	if APMGF_Options == nil then
		APMGF_Options = {};
		APMGF_Options = CopyTable(Options_Default);
	end

	ns.options = CopyTable(APMGF_Options);

	for variable, _ in pairs(Options_Default) do
		local name = variable;
		local cvar_name = "asPremadeGroupsFilter_" .. variable;
		local tooltip = ""
		if APMGF_Options[variable] == nil then
			APMGF_Options[variable] = Options_Default[variable];
			ns.options[variable] = Options_Default[variable];
		end
		local defaultValue = Options_Default[variable];
		local currentValue = APMGF_Options[variable];

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
end
