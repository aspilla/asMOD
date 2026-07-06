local _, ns = ...;
local Options_Default = {
	Version = 250706,
	ShowFocus = true,
	ShowTarget = true,
	FocusCastScale = 1.2,
	TargetCastScale = 1,
};


local L = {
	ShowFocus = "Toggle display of the Focus target cast bar (Default: true).",
	ShowTarget = "Toggle display of the Target cast bar (Default: true).",
	FocusCastScale = "Adjust the size scale of the Focus target cast bar (Default: 1.2, Require '/reload').",
	TargetCastScale = "Adjust the size scale of the Target cast bar (Default: 1, Require '/reload').",
}


if GetLocale() == "koKR" then
	L = {
		ShowFocus = "주시 대상 시전 바 표시 여부 (기본 true).",
		ShowTarget = "대상 시전 바 표시 여부 (기본 true).",
		FocusCastScale = "주시 대상 시전 바 크기 배율 (기본 1.2, `/reload` 필요).",
		TargetCastScale = "대상 시전 바 크기 배율 (기본 1, '/reload' 필요).",
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
		ATCB_Options[variable] = value;
		ns.options[variable] = value;

		if variable == "FocusCastScale" then
		elseif variable == "TargetCastScale" then
		else
			ReloadUI();
		end
	end

	local category = Settings.RegisterVerticalLayoutCategory("asTargetCastBar")

	if not category then
		return;
	end

	if ATCB_Options == nil or Options_Default.Version ~= ATCB_Options.Version then
		ATCB_Options = {};
		ATCB_Options = CopyTable(Options_Default);
	end

	if ATCB_Positions_1 == nil then
		ATCB_Positions_1 = {};
	end

	if ATCB_Positions_2 == nil then
		ATCB_Positions_2 = {};
	end


	ns.options = CopyTable(ATCB_Options);

	for variable, _ in pairs(Options_Default) do
		local name = variable;
		local cvar_name = "asTargetCastBar_" .. variable;
		local tooltip = ""
		if ATCB_Options[variable] == nil then
			ATCB_Options[variable] = Options_Default[variable];
			ns.options[variable] = Options_Default[variable];
		end
		local defaultValue = Options_Default[variable];
		local currentValue = ATCB_Options[variable];

		if name ~= "Version" then
			if tonumber(defaultValue) ~= nil then
				local setting = Settings.RegisterAddOnSetting(category, cvar_name, variable, tempoption,
					type(defaultValue), L[name], defaultValue);
				local options = Settings.CreateSliderOptions(0.5, 3, 0.1);
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
