local _, ns = ...;
local Options_Default = {
    Version = 250706,
    HideActionBar1 = true,
    HidePetBar = true,
    HideStanceBar = true,
    HideActionBar2 = true,
    HideActionBar3 = true,
    HideActionBar4 = true,
    HideActionBar5 = true,
    HideActionBar6 = true,
    HideActionBar7 = true,
    HideActionBar8 = true,
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
        AHAB_Options[variable] = value;
        ns.options[variable] = value;
        
        if variable == "FocusCastScale" then
            if ns.focuscastbar then
                ns.focuscastbar:SetScale(value);
            end
        else
            ReloadUI();
        end
    end

    local category = Settings.RegisterVerticalLayoutCategory("asHideActionBar")

    if not category then
        return;
    end

    if AHAB_Options == nil or Options_Default.Version ~= AHAB_Options.Version then
        AHAB_Options = {};
        AHAB_Options = CopyTable(Options_Default);
    end

    ns.options = CopyTable(AHAB_Options);

    for variable, _ in pairs(Options_Default) do
        local name = variable;
        local cvar_name = "asHideActionBar_" .. variable;
        local tooltip = ""
        if AHAB_Options[variable] == nil then
            AHAB_Options[variable] = Options_Default[variable];
            ns.options[variable] = Options_Default[variable];
        end
        local defaultValue = Options_Default[variable];
        local currentValue = AHAB_Options[variable];

        if name ~= "Version" then
            if tonumber(defaultValue) ~= nil then
                local setting = Settings.RegisterAddOnSetting(category, cvar_name,  variable, tempoption, type(defaultValue), name, defaultValue);
                local options = Settings.CreateSliderOptions(0.5, 3, 0.1);
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
