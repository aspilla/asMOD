local _, ns = ...;
local Options_Default = {
    Version = 250527,
    PlaySound = true,    
    HideTarget = false,    
};

ns.options = CopyTable(Options_Default);
local tempoption = {};

function ns.SetupOptionPanels()
    local function OnSettingChanged(_, setting, value)
        local function get_variable_from_cvar_name(cvar_name)
            local variable_start_index = string.find(cvar_name, "_") + 1
            local variable = string.sub(cvar_name, variable_start_index)
            return variable
        end

        local cvar_name = setting:GetVariable()
        local variable = get_variable_from_cvar_name(cvar_name)
        ADCA_Options[variable] = value;
        ns.options[variable] = value;
    end

    local category = Settings.RegisterVerticalLayoutCategory("asDBMCastingAlert")

    if not category then
        return;
    end

    if ADCA_Options == nil or Options_Default.Version ~= ADCA_Options.Version then
        ADCA_Options = {};
        ADCA_Options = CopyTable(Options_Default);
    end

    ns.options = CopyTable(ADCA_Options);

    for variable, _ in pairs(Options_Default) do
        local name = variable;
        local cvar_name = "asDBMCastingAlert_" .. variable;
        local tooltip = ""
        if ADCA_Options[variable] == nil then
            ADCA_Options[variable] = Options_Default[variable];
            ns.options[variable] = Options_Default[variable];
        end
        local defaultValue = Options_Default[variable];
        local currentValue = ADCA_Options[variable];

        if name ~= "Version" then
            if tonumber(defaultValue) ~= nil then
                local setting = Settings.RegisterAddOnSetting(category, cvar_name,  variable, tempoption, type(defaultValue), name, defaultValue);
                local options = Settings.CreateSliderOptions(0, 100, 1);
                options:SetLabelFormatter(MinimalSliderWithSteppersMixin.Label.Right);
                Settings.CreateSlider(category, setting, options, tooltip);
                Settings.SetValue(cvar_name, currentValue);
                Settings.SetOnValueChangedCallback(cvar_name, OnSettingChanged);
            else
                local setting = Settings.RegisterAddOnSetting(category, cvar_name,  variable, tempoption, type(defaultValue), name, defaultValue);
                Settings.CreateCheckboxWithOptions(category, setting, nil, tooltip);
                Settings.SetValue(cvar_name, currentValue);
                Settings.SetOnValueChangedCallback(cvar_name, OnSettingChanged);
            end
        end
    end

    Settings.RegisterAddOnCategory(category)
end
