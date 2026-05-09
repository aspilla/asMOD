local _, ns = ...;
local Options_Default = {
    Version = 260509,
    MinTimetoShow = 3,
    Size = 50,
    TextSize = 15,
    ShowName = true,
    ShowButton = true,
    ShowText = true,
};

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
        ADTI_Options[variable] = value;
        ns.options[variable] = value;
    end

    local category = Settings.RegisterVerticalLayoutCategory("asDBMTimer")


    if ADTI_Options == nil or Options_Default.Version ~= ADTI_Options.Version then
        ADTI_Options = {}
        ADTI_Options = CopyTable(Options_Default);        
    end

    if ADTI_Positions == nil then
        ADTI_Positions = {};
    end

    if ADTI_Positions2 == nil then
        ADTI_Positions2 = {};
    end

    ns.options = CopyTable(ADTI_Options);

    for variable, _ in pairs(Options_Default) do
        local name = variable;

        local cvar_name = "asDBMTimer_" .. variable;
        local tooltip = ""
        if ADTI_Options[variable] == nil then
            ADTI_Options[variable] = Options_Default[variable];
            ns.options[variable] = Options_Default[variable];
        end
        local defaultValue = Options_Default[variable]
        local currentValue = ADTI_Options[variable];

        if tonumber(defaultValue) ~= nil then
            local setting = Settings.RegisterAddOnSetting(category, cvar_name, variable, tempoption, type(defaultValue),
                name, defaultValue);
            local options = Settings.CreateSliderOptions(0, 100, 1);
            options:SetLabelFormatter(MinimalSliderWithSteppersMixin.Label.Right);
            Settings.CreateSlider(category, setting, options, tooltip);
            Settings.SetValue(cvar_name, currentValue);
            Settings.SetOnValueChangedCallback(cvar_name, OnSettingChanged);
        else
            local setting = Settings.RegisterAddOnSetting(category, cvar_name, variable, tempoption, type(defaultValue),
                name, defaultValue);
            Settings.CreateCheckboxWithOptions(category, setting, nil, tooltip);
            Settings.SetValue(cvar_name, currentValue);
            Settings.SetOnValueChangedCallback(cvar_name, OnSettingChanged);
        end
    end

    Settings.RegisterAddOnCategory(category)	
end