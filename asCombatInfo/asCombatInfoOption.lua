local _, ns = ...;
local Options_Default = {
	version = 260212,
	AlignedBuff = false,
	TopAlignedBar = false,
	BottomAlignedBar = false,
	CombatAlphaChange = true,
	ChangeBuffBar = true,
	BuffBarClassColor = true,
	ShowHotKey = true,
	HideBarName = false,
	AlertAssitedSpell = false,
	SpellBorderWidth = 2,
	BuffBorderWidth = 2,
	SpellIconRate = 9,
	BuffIconRate = 8,
	SpellMillisecondsThreshold = 3,
	BuffMillisecondsThreshold = 3,
};

ns.options = CopyTable(Options_Default);

local tempoption = {};

local L = {
	CombatAlphaChange = "Transparency change out of combat",
	ShowHotKey = "Display hotkey",
	TopAlignedBar = "Top aligned bar",
	BottomAlignedBar = "Bottom aligned bar",
	HideBarName = "Hide bar name",
	AlignedBuff = "Aligned buff",
	ChangeBuffBar = "Change buff bar",
	BuffBarClassColor = "Buff bar class color",
	BuffBorderWidth = "Border width",
	BuffIconRate = "Icon size rate",
	BuffMillisecondsThreshold = "Milliseconds threshold (0.1s cooldown increments)",
	AlertAssitedSpell = "Alert assisted spell",
	SpellBorderWidth = "Border width",
	SpellIconRate = "Icon size rate",
	SpellMillisecondsThreshold = "Milliseconds threshold (0.1s cooldown increments)",
}

local L_Headings = {
	Common = "Common Settings",
	Bar = "Bar Settings",
	Buff = "Buff Settings",
	Spell = "Spell Settings",
}

if GetLocale() == "koKR" then
	L = {
		CombatAlphaChange = "비전투 시 투명도 변경",
		ShowHotKey = "단축키 표시 여부",
		TopAlignedBar = "위로 정렬 바",
		BottomAlignedBar = "아래로 정렬 바",
		HideBarName = "바 이름 숨기기",
		AlignedBuff = "버프 정렬",
		ChangeBuffBar = "버프 바 변경",
		BuffBarClassColor = "버프 바 직업 색상",
		BuffBorderWidth = "테두리 두께",
		BuffIconRate = "아이콘 크기 비율",
		BuffMillisecondsThreshold = "남은 쿨 소수점 최소 시간",
		AlertAssitedSpell = "지원 스킬 경고",
		SpellBorderWidth = "테두리 두께",
		SpellIconRate = "아이콘 크기 비율",
		SpellMillisecondsThreshold = "남은 쿨 소수점 최소 시간",
	}
	L_Headings = {
		Common = "공통 설정",
		Bar = "바 설정",
		Buff = "버프 설정",
		Spell = "스킬 설정",
	}
end

local Option_Sections = {
	{
		Header = "Common",
		Variables = {
			"CombatAlphaChange",
			"ShowHotKey",
			"AlertAssitedSpell",
		}
	},
	{
		Header = "Bar",
		Variables = {
			"ChangeBuffBar",
			"BuffBarClassColor",
			"TopAlignedBar",
			"BottomAlignedBar",
			"HideBarName",
		}
	},
	{
		Header = "Buff",
		Variables = {
			"AlignedBuff",
			"BuffBorderWidth",
			"BuffIconRate",
			"BuffMillisecondsThreshold",
		}
	},
	{
		Header = "Spell",
		Variables = {
			"SpellBorderWidth",
			"SpellIconRate",
			"SpellMillisecondsThreshold",
		}
	}
}

function ns.setup_option()
	local function OnSettingChanged(_, setting, value)
		local function get_variable_from_cvar_name(cvar_name)
			local variable_start_index = string.find(cvar_name, "_") + 1
			local variable = string.sub(cvar_name, variable_start_index)
			return variable
		end

		local cvar_name = setting:GetVariable()
		local variable = get_variable_from_cvar_name(cvar_name)
		ACI_Options[variable] = value;
		ns.options[variable] = value;
		if tonumber(value) == nil then
			ReloadUI();
		else
			ns.refreshall()
		end
	end

	local category, layout = Settings.RegisterVerticalLayoutCategory("asCombatInfo")

	if ACI_Options == nil or ACI_Options.version ~= Options_Default.version then
		ACI_Options = {};
		ACI_Options = CopyTable(Options_Default);
	end

	for variable, _ in pairs(Options_Default) do
		if variable ~= "version" then
			if ACI_Options[variable] == nil then
				ACI_Options[variable] = Options_Default[variable];
				ns.options[variable] = Options_Default[variable];
			end
		end
	end

	ns.options = CopyTable(ACI_Options);

	for _, section in ipairs(Option_Sections) do
		local headingText = L_Headings[section.Header];
		if layout and CreateSettingsListSectionHeaderInitializer then
			layout:AddInitializer(CreateSettingsListSectionHeaderInitializer(headingText));
		end

		for _, variable in ipairs(section.Variables) do
			local name = variable;
			local cvar_name = "asCombatInfo_" .. variable;
			local tooltip = ""
			local defaultValue = Options_Default[variable];
			local currentValue = ACI_Options[variable];

			if name == "SpellMillisecondsThreshold" or name == "BuffMillisecondsThreshold" then
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
				local options = Settings.CreateSliderOptions(1, 9, 1);
				options:SetLabelFormatter(MinimalSliderWithSteppersMixin.Label.Right);
				Settings.CreateSlider(category, setting, options, tooltip);
				Settings.SetValue(cvar_name, currentValue);
				Settings.SetOnValueChangedCallback(cvar_name, OnSettingChanged);
			else
				local setting = Settings.RegisterAddOnSetting(category, cvar_name, variable, tempoption,
					type(defaultValue),
					L[name], defaultValue);
				Settings.CreateCheckboxWithOptions(category, setting, nil, tooltip);
				Settings.SetValue(cvar_name, currentValue);
				Settings.SetOnValueChangedCallback(cvar_name, OnSettingChanged);
			end
		end
	end

	Settings.RegisterAddOnCategory(category)
end
