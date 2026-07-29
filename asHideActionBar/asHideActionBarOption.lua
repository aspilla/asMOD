local _, ns = ...;
local Options_Default = {
	Version = 250706,
	HideActionBar1 = true,
	HidePetBar = true,
	HideStanceBar = true,
	HideActionBar2 = true,
	HideActionBar3 = true,
	HideActionBar4 = true,
	HideActionBar5 = true,
	HideActionBar6 = true,
	HideActionBar7 = true,
	HideActionBar8 = true,
};

local L = {
	HideActionBar1 = "Hide Action Bar 1",
	HidePetBar = "Hide Pet Bar",
	HideStanceBar = "Hide Stance Bar",
	HideActionBar2 = "Hide Action Bar 2",
	HideActionBar3 = "Hide Action Bar 3",
	HideActionBar4 = "Hide Action Bar 4",
	HideActionBar5 = "Hide Action Bar 5",
	HideActionBar6 = "Hide Action Bar 6",
	HideActionBar7 = "Hide Action Bar 7",
	HideActionBar8 = "Hide Action Bar 8",
}

if GetLocale() == "koKR" then
	L = {
		HideActionBar1 = "행동 단축바 1 숨김",
		HidePetBar = "소환수 바 숨김",
		HideStanceBar = "태세바 숨김",
		HideActionBar2 = "행동 단축바 2 숨김",
		HideActionBar3 = "행동 단축바 3 숨김",
		HideActionBar4 = "행동 단축바 4 숨김",
		HideActionBar5 = "행동 단축바 5 숨김",
		HideActionBar6 = "행동 단축바 6 숨김",
		HideActionBar7 = "행동 단축바 7 숨김",
		HideActionBar8 = "행동 단축바 8 숨김",
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
		AHAB_Options[variable] = value;
		ns.options[variable] = value;

		ReloadUI();
	end

	local category = Settings.RegisterVerticalLayoutCategory("asHideActionBar")

	if not category then
		return;
	end

	if AHAB_Options == nil or Options_Default.Version ~= AHAB_Options.Version then
		AHAB_Options = {};
		AHAB_Options = CopyTable(Options_Default);
	end

	ns.options = CopyTable(AHAB_Options);

	for variable, _ in pairs(Options_Default) do
		local name = variable;
		local cvar_name = "asHideActionBar_" .. variable;
		local tooltip = ""
		if AHAB_Options[variable] == nil then
			AHAB_Options[variable] = Options_Default[variable];
			ns.options[variable] = Options_Default[variable];
		end
		local defaultValue = Options_Default[variable];
		local currentValue = AHAB_Options[variable];

		if name ~= "Version" then
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
