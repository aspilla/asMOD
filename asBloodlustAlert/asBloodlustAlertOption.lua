local _, ns = ...;

local Options_Default = {
    ClassOnly = true,
    VoiceAlert = true,
    InRaid = false,
    FontSize = 30,
    ShowTime = 2,
}

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
        ns.checkStatus();
    end

    local category = Settings.RegisterVerticalLayoutCategory("asBloodlustAlert")

    if ABLA_Options == nil then
        ABLA_Options = {};
        ABLA_Options = CopyTable(Options_Default);
    end

    if ABLA_Positions == nil then
        ABLA_Positions = {};
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

        if tonumber(defaultValue) ~= nil then
            local setting = Settings.RegisterAddOnSetting(category, cvar_name, variable, tempoption,
                type(defaultValue), name, defaultValue);
            local options = Settings.CreateSliderOptions(1, 40, 1);
            options:SetLabelFormatter(MinimalSliderWithSteppersMixin.Label.Right);
            Settings.CreateSlider(category, setting, options, tooltip);
            Settings.SetValue(cvar_name, currentValue);
            Settings.SetOnValueChangedCallback(cvar_name, OnSettingChanged);
        else
            local setting = Settings.RegisterAddOnSetting(category, cvar_name, variable, tempoption,
                type(defaultValue), name, defaultValue);

            Settings.CreateCheckboxWithOptions(category, setting, nil, tooltip);
            Settings.SetValue(cvar_name, currentValue);
            Settings.SetOnValueChangedCallback(cvar_name, OnSettingChanged);
        end

        ns.options[variable] = currentValue;
    end

    Settings.RegisterAddOnCategory(category)
end
