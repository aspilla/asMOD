local _, ns = ...;
local Options_Default = {
	Version = 260103,
	showHaste = true,
	showCrit = true,
	showMastery = true,
	showVer = true,
	showPrimary = true, -- Add new option for primary stat
}

local L = {
	showHaste = "Show Haste",
	showCrit = "Show Crit",
	showMastery = "Show Mastery",
	showVer = "Show Ver",
	showPrimary = "Show Primary Stat", -- Add new option for primary stat
}


if GetLocale() == "koKR" then
	L = {
		showHaste = "가속 표시",
		showCrit = "치명 표시",
		showMastery = "특화 표시",
		showVer = "유연 표시",
		showPrimary = "주스텟 표시", -- Add new option for primary stat
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
		AINF_Options[variable] = value;
		ns.options[variable] = value;
		ns.needreposition = true;
	end

	local category = Settings.RegisterVerticalLayoutCategory("asInformation")

	if not category then
		return;
	end

	if AINF_Options and AINF_Options.Version == Options_Default.Version then
		-- do nothing
	else
		AINF_Options = CopyTable(Options_Default);
	end

	if AINF_Position == nil then
		AINF_Position = {};
	end

	ns.options = CopyTable(AINF_Options);

	for variable, _ in pairs(Options_Default) do
		local name = variable;
		local cvar_name = "asInformation_" .. variable;
		local tooltip = ""
		if AINF_Options[variable] == nil then
			AINF_Options[variable] = Options_Default[variable];
			ns.options[variable] = Options_Default[variable];
		end
		local defaultValue = Options_Default[variable];
		local currentValue = AINF_Options[variable];

		if name ~= "Version" then
			local setting = Settings.RegisterAddOnSetting(category, cvar_name, variable, tempoption,
				type(defaultValue), L[name], defaultValue);
			Settings.CreateCheckboxWithOptions(category, setting, nil, tooltip);
			Settings.SetValue(cvar_name, currentValue);
			Settings.SetOnValueChangedCallback(cvar_name, OnSettingChanged);
		end
	end

	Settings.RegisterAddOnCategory(category)
end
