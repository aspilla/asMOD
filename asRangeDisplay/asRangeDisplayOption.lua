local _, ns = ...;
local Options_Default = {
	version = 250805,
	ShowTarget = true,
	ShowMouseOver = true,
	ShowFocus = true,
};

local L = {
	ShowTarget = "Show Target Range",
	ShowMouseOver = "Show Mouseover Range",
	ShowFocus = "Show Focus Range",
}

if GetLocale() == "koKR" then
	L = {
		ShowTarget = "대상 거리 표시",
		ShowMouseOver = "마우스 오버 거리 표시",
		ShowFocus = "주시 대상 거리 표시",
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
		ARD_Options[variable] = value;
		ns.options[variable] = value;
		ReloadUI();
	end

	local category = Settings.RegisterVerticalLayoutCategory("asRangeDisplay")

	if ARD_Options == nil or ARD_Options.version ~= Options_Default.version then
		ARD_Options = {};
		ARD_Options = CopyTable(Options_Default);
		ARD_Positions_1 = {};
		ARD_Positions_2 = {};
	end

	if ARD_Positions_1 == nil then
		ARD_Positions_1 = {};
	end

	if ARD_Positions_2 == nil then
		ARD_Positions_2 = {};
	end

	ns.options = CopyTable(ARD_Options);

	for variable, _ in pairs(Options_Default) do
		if variable ~= "version" then
			local name = variable;
			local cvar_name = "asRangeDisplay_" .. variable;
			local tooltip = ""
			if ARD_Options[variable] == nil then
				ARD_Options[variable] = Options_Default[variable];
				ns.options[variable] = Options_Default[variable];
			end
			local defaultValue = Options_Default[variable];
			local currentValue = ARD_Options[variable];

			local label = L[name] or name
			local setting = Settings.RegisterAddOnSetting(category, cvar_name, variable, tempoption, type(defaultValue),
				label, defaultValue);
			Settings.CreateCheckboxWithOptions(category, setting, nil, tooltip);
			Settings.SetValue(cvar_name, currentValue);
			Settings.SetOnValueChangedCallback(cvar_name, OnSettingChanged);
		end
	end

	Settings.RegisterAddOnCategory(category)
end
