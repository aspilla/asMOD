local _, ns = ...;
local Options_Default = {
	version = 251209,
	HideModifier = 1,
	Alpha = 0,
	ShowBoss = true,
	ShowNoDebuff = false,
	HideMinusMob = true,
	ShowPlayers = true,
	WorkOnParty = true,
	WorkOnRaid = false,
	WorkOnSolo = false,
};

local L = {
	HideModifier = "Activation Condition",
	Alpha = "Hide Transparency",
	ShowBoss = "Show Bosses",
	ShowNoDebuff = "Show Mobs Without Debuffs",
	HideMinusMob = "Hide Minor Mobs",
	ShowPlayers = "Show Hostile Players",
	WorkOnParty = "Enable in Party",
	WorkOnRaid = "Enable in Raid",
	WorkOnSolo = "Enable Solo",
}

if GetLocale() == "koKR" then
	L = {
		HideModifier = "동작 조건",
		Alpha = "숨김 투명도",
		ShowBoss = "보스 항상 표시",
		ShowNoDebuff = "디버프 없는 몹 표시",
		HideMinusMob = "일반/하급 몹 숨김",
		ShowPlayers = "적대적 플레이어 표시",
		WorkOnParty = "파티 중 동작",
		WorkOnRaid = "레이드 중 동작",
		WorkOnSolo = "솔로 플레이 중 동작",
	}
end

local modifier_options = {
	[1] = "Key Binding",
	[2] = "ALT + CTRL",
	[3] = "ALT",
	[4] = "CTRL",
	[5] = "SHIFT",
	[6] = "Auto Trigger",
}

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
		AHNP_Options[variable] = value;
		ns.options[variable] = value;
		if type(value) ~= "number" then
			ReloadUI();
		end
	end

	local category = Settings.RegisterVerticalLayoutCategory("asHideNamePlates");

	if AHNP_Options == nil or AHNP_Options.version ~= Options_Default.version then
		AHNP_Options = {};
		AHNP_Options = CopyTable(Options_Default);
	end
	ns.options = CopyTable(AHNP_Options);

	for variable, _ in pairs(Options_Default) do
		if variable ~= "version" then
			local name = variable;
			local cvar_name = "asHideNamePlates_" .. variable;
			local tooltip = ""
			if AHNP_Options[variable] == nil then
				AHNP_Options[variable] = Options_Default[variable];
				ns.options[variable] = Options_Default[variable];
			end
			local defaultValue = Options_Default[variable];
			local currentValue = AHNP_Options[variable];

			local label = L[name] or name
			if name == "HideModifier" then
				local function GetOptions()
					local container = Settings.CreateControlTextContainer()
					for id, v in pairs(modifier_options) do
						container:Add(id, v);
					end
					return container:GetData();
				end

				local setting = Settings.RegisterAddOnSetting(category, cvar_name, variable, tempoption,
					type(defaultValue), label, defaultValue);

				Settings.CreateDropdown(category, setting, GetOptions, tooltip);
				Settings.SetValue(cvar_name, currentValue);
				Settings.SetOnValueChangedCallback(cvar_name, OnSettingChanged);
			elseif tonumber(defaultValue) ~= nil then
				local setting = Settings.RegisterAddOnSetting(category, cvar_name, variable, tempoption,
					type(defaultValue), label, defaultValue);
				local options = Settings.CreateSliderOptions(0, 1, 0.1);
				options:SetLabelFormatter(MinimalSliderWithSteppersMixin.Label.Right);
				Settings.CreateSlider(category, setting, options, tooltip);
				Settings.SetValue(cvar_name, currentValue);
				Settings.SetOnValueChangedCallback(cvar_name, OnSettingChanged);
			else
				local setting = Settings.RegisterAddOnSetting(category, cvar_name, variable, tempoption,
					type(defaultValue), label, defaultValue);
				Settings.CreateCheckboxWithOptions(category, setting, nil, tooltip);
				Settings.SetValue(cvar_name, currentValue);
				Settings.SetOnValueChangedCallback(cvar_name, OnSettingChanged);
			end
		end
	end

	Settings.RegisterAddOnCategory(category)
end
