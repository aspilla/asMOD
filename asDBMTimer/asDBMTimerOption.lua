local _, ns = ...;
local Options_Default = {
    Version = 240807,
    MinTimetoShow = 10,
    HideNamePlatesCooldown = false,
    ShowInterruptOnlyforNormal = true,
    AOESound = 2.5,
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
        ADTI_Options[variable] = value;
        ns.options[variable] = value;
    end

    local category = Settings.RegisterVerticalLayoutCategory("asDBMTimer")

    if ADTI_Options == nil then
        ADTI_Options = {};
        ADTI_Options = CopyTable(Options_Default);
    end

    ns.options = CopyTable(ADTI_Options);

    for variable, _ in pairs(Options_Default) do
        local name = variable;

        if name ~= "Version" then
            local cvar_name = "asDBMTimer_" .. variable;
            local tooltip = ""
            if ADTI_Options[variable] == nil or Options_Default.Version ~= ADTI_Options.Version then
                ADTI_Options[variable] = Options_Default[variable];
                ns.options[variable] = Options_Default[variable];
            end
            local defaultValue = ADTI_Options[variable];

            if tonumber(defaultValue) ~= nil then
                local setting = Settings.RegisterAddOnSetting(category, cvar_name,  variable, tempoption, type(defaultValue), name, defaultValue);
                local options = Settings.CreateSliderOptions(0, 100, 1);
                options:SetLabelFormatter(MinimalSliderWithSteppersMixin.Label.Right);
                Settings.CreateSlider(category, setting, options, tooltip);
                Settings.SetOnValueChangedCallback(cvar_name, OnSettingChanged);
            else
                local setting = Settings.RegisterAddOnSetting(category, cvar_name,  variable, tempoption, type(defaultValue), name, defaultValue);

                Settings.CreateCheckboxWithOptions(category, setting, nil, tooltip);
                Settings.SetOnValueChangedCallback(cvar_name, OnSettingChanged);
            end
        end
    end

    Settings.RegisterAddOnCategory(category)
end
