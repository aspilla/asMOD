local _, ns = ...;
local Options_Default = {
	version = 251212,
	HideDebuff = true,
	HideCombatText = true,
	HideCastBar = true,
	HideClassBar = true,
	HideTotemBar = false,
	ShowClassColor = true,
	ShowAggro = true,
};

local L = {
	HideDebuff = "Hide Target Debuffs",
	HideCombatText = "Hide Player Combat Text",
	HideCastBar = "Hide Target Cast Bar",
	HideClassBar = "Hide Player Class Bar",
	HideTotemBar = "Hide Player Totem Bar",
	ShowClassColor = "Show Class-Colored Health",
	ShowAggro = "Show Numeric Aggro",
}

if GetLocale() == "koKR" then
	L = {
		HideDebuff = "대상의 디버프 숨김",
		HideCombatText = "플레이어 전투 텍스트 숨김",
		HideCastBar = "대상의 시전바 숨김",
		HideClassBar = "플레이어 직업바 숨김",
		HideTotemBar = "플레이어 토템바 숨김",
		ShowClassColor = "직업 색상 생명력 바",
		ShowAggro = "숫자 위협 수준 표시",
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
		AFUF_Options[variable] = value;
		ns.options[variable] = value;
		ReloadUI();
	end

	local category = Settings.RegisterVerticalLayoutCategory("asFixUnitFrame")

	if AFUF_Options == nil or AFUF_Options.version ~= Options_Default.version then
		AFUF_Options = {};
		AFUF_Options = CopyTable(Options_Default);
	end
	ns.options = CopyTable(AFUF_Options);

	for variable, _ in pairs(Options_Default) do
		if variable ~= "version" then
			local name = variable;
			local cvar_name = "asFixUnitFrame_" .. variable;
			local tooltip = ""
			if AFUF_Options[variable] == nil then
				AFUF_Options[variable] = Options_Default[variable];
				ns.options[variable] = Options_Default[variable];
			end
			local defaultValue = Options_Default[variable];
			local currentValue = AFUF_Options[variable];

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
