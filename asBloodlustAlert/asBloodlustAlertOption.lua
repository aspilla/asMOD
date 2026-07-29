local _, ns = ...;

local Options_Default = {
	Version = 260505,
	ReadyAlert = true,
	StartAlert = true,
	ShowBuff = true,
	VoiceAlert = true,
	FontSize = 30,
	ShowTime = 2,
	MillisecondsThreshold = 3,
}

local L = {
	ReadyAlert = "Notifies when Bloodlust is ready",
	StartAlert = "Notifies when Bloodlust starts",
	ShowBuff = "Displays the Bloodlust duration as a button",
	VoiceAlert = "Provides voice alerts",
	FontSize = "Font size for the center alert text",
	ShowTime = "Display duration for the center alert text",
	MillisecondsThreshold = "Remaining cooldown begins displaying in 0.1-second increments",
}


if GetLocale() == "koKR" then
	L = {
		ReadyAlert = "블러드 준비됨을 알림",
		StartAlert = "블러드 시작됨을 알림",
		ShowBuff = "블러드 지속시간을 버튼으로 알림",
		VoiceAlert = "음성으로 알림",
		FontSize = "화면 중앙 알림 글씨 크기",
		ShowTime = "화면 중앙 알림 표시 시간",
		MillisecondsThreshold = "남은 쿨을 0.1초 단위로 보여줄 최소 시간",
	}
end

local tempoption = {};
ns.options = CopyTable(Options_Default);

function ns.SetupOptionPanels()
	local function OnSettingChanged(_, setting, value)
		local function get_variable_from_cvar_name(cvar_name)
			local variable_start_index = string.find(cvar_name, "_") + 1
			local variable = string.sub(cvar_name, variable_start_index)
			return variable
		end

		local cvar_name = setting:GetVariable()
		local variable = get_variable_from_cvar_name(cvar_name)
		ABLA_Options[variable] = value;
		ns.options[variable] = value;
		ns.check_status();
	end

	local category = Settings.RegisterVerticalLayoutCategory("asBloodlustAlert")

	if ABLA_Options == nil or Options_Default.Version ~= ABLA_Options.Version then
		ABLA_Options = {};
		ABLA_Options = CopyTable(Options_Default);
	end

	if ABLA_Positions == nil then
		ABLA_Positions = {};
	end
	if ABLA_Positions2 == nil then
		ABLA_Positions2 = {};
	end

	for variable, _ in pairs(Options_Default) do
		local name = variable;
		local cvar_name = "asBloodlustAlert_" .. variable;
		local tooltip = ""
		if ABLA_Options[variable] == nil then
			ABLA_Options[variable] = Options_Default[variable];
		end
		local defaultValue = Options_Default[variable];
		local currentValue = ABLA_Options[variable];

		if name ~= "Version" then
			if tonumber(defaultValue) ~= nil then
				local setting = Settings.RegisterAddOnSetting(category, cvar_name, variable, tempoption,
					type(defaultValue), L[name], defaultValue);
				local options = Settings.CreateSliderOptions(1, 40, 1);
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

		ns.options[variable] = currentValue;
	end

	Settings.RegisterAddOnCategory(category)
end
