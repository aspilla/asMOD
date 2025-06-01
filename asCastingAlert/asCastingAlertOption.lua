
local _, ns = ...;
local Options_Default = {
    Version = 250601,
    PlaySound = true,    
    PlaySoundDBMOnly = false,
    PlaySoundTank = false,
    ShowTarget = true,
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
        ACTA_Options[variable] = value;
        ns.options[variable] = value;
    end

    local category = Settings.RegisterVerticalLayoutCategory("asCastingAlert")

    if not category then
        return;
    end

    if ACTA_Options == nil or Options_Default.Version ~= ACTA_Options.Version then
        ACTA_Options = {};
        ACTA_Options = CopyTable(Options_Default);
    end

    ns.options = CopyTable(ACTA_Options);

    for variable, _ in pairs(Options_Default) do
        local name = variable;
        local cvar_name = "asCastingAlert_" .. variable;
        local tooltip = ""
        if ACTA_Options[variable] == nil then
            ACTA_Options[variable] = Options_Default[variable];
            ns.options[variable] = Options_Default[variable];
        end
        local defaultValue = Options_Default[variable];
        local currentValue = ACTA_Options[variable];

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
