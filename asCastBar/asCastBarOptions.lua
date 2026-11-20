local _, ns = ...;
local Options_Default = {
	Version = 260805,
	SimpleDesign = true,
	BarWidth = 238 + 40,
	BarHeight = 20, --13.9
	FontSizeRate = 0.6,
	ShowTick = true,
};

local L = {
	SimpleDesign = "Simple Design Mode",
	BarWidth = "Bar Width",
	BarHeight = "Bar Height",
	FontSizeRate = "Font size rate",
	ShowTick = "Show channeling tick",
}

if GetLocale() == "koKR" then
	L = {
		SimpleDesign = "심플 디자인 모드 사용",
		BarWidth = "시전바 넓이",
		BarHeight = "시전바 높이",
		FontSizeRate = "폰트 크기 비율",
		ShowTick = "채널링 틱 표시",
	}
end

ns.options = CopyTable(Options_Default);
local tempoption = {};

local function hidecallback()
	ns.playercastbar:Hide()
end

local bupdated = false;

function ns.setup_option()
	local function OnSettingChanged(_, setting, value)
		local function get_variable_from_cvar_name(cvar_name)
			local variable_start_index = string.find(cvar_name, "_") + 1
			local variable = string.sub(cvar_name, variable_start_index)
			return variable
		end

		local cvar_name = setting:GetVariable()
		local variable = get_variable_from_cvar_name(cvar_name)
		ACB_Options[variable] = value;
		ns.options[variable] = value;

		if variable == "BarWidth" or variable == "BarHeight" or variable == "FontSizeRate" then
			if ns.playercastbar then
				ns.resize(ns.playercastbar);
				ns.playercastbar:Show();
				C_Timer.After(2, hidecallback);
			end
		else
			bupdated = true;
		end
	end

	local category = Settings.RegisterVerticalLayoutCategory("asCastBar")

	if not category then
		return;
	end

	if ACB_Options == nil or Options_Default.Version ~= ACB_Options.Version then
		ACB_Options = {};
		ACB_Options = CopyTable(Options_Default);
		ACB_Positions = {};
	end

	if ACB_Positions == nil then
		ACB_Positions = {};
	end

	ns.options = CopyTable(ACB_Options);

	for variable, _ in pairs(Options_Default) do
		local name = variable;
		local cvar_name = "asCastBar_" .. variable;
		local tooltip = ""
		if ACB_Options[variable] == nil then
			ACB_Options[variable] = Options_Default[variable];
			ns.options[variable] = Options_Default[variable];
		end
		local defaultValue = Options_Default[variable];
		local currentValue = ACB_Options[variable];

		if name ~= "Version" then
			local label = L[name] or name
			if tonumber(defaultValue) ~= nil and name == "FontSizeRate" then
				local setting = Settings.RegisterAddOnSetting(category, cvar_name, variable, tempoption,
					type(defaultValue), label, defaultValue);
				local options = Settings.CreateSliderOptions(0.5, 1.0, 0.1);
				options:SetLabelFormatter(MinimalSliderWithSteppersMixin.Label.Right);
				Settings.CreateSlider(category, setting, options, tooltip);
				Settings.SetValue(cvar_name, currentValue);
				Settings.SetOnValueChangedCallback(cvar_name, OnSettingChanged);
			elseif tonumber(defaultValue) ~= nil and name == "BarHeight" then
				local setting = Settings.RegisterAddOnSetting(category, cvar_name, variable, tempoption,
					type(defaultValue), label, defaultValue);
				local options = Settings.CreateSliderOptions(10, 200, 1);
				options:SetLabelFormatter(MinimalSliderWithSteppersMixin.Label.Right);
				Settings.CreateSlider(category, setting, options, tooltip);
				Settings.SetValue(cvar_name, currentValue);
				Settings.SetOnValueChangedCallback(cvar_name, OnSettingChanged);
			elseif tonumber(defaultValue) ~= nil and name == "BarWidth" then
				local setting = Settings.RegisterAddOnSetting(category, cvar_name, variable, tempoption,
					type(defaultValue), label, defaultValue);
				local options = Settings.CreateSliderOptions(100, 2000, 1);
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

	EventRegistry:RegisterCallback("SettingsPanel.OnHide", function()
		if bupdated then
			ReloadUI();
		end
	end);
end
