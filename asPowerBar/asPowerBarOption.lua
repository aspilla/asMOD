local _, ns = ...;
local Options_Default = {
    Version = 251216,
    ShowClassResource = true,
    CombatAlphaChange = true,
    BarWidth = 238,
    PowerBarHeight = 8,
    ComboBarHeight = 5,
    FontSize = 12,
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
        ASPB_Options[variable] = value;
        ns.options[variable] = value;
        
        if tonumber(value) == nil then
            ReloadUI();
        end
    end

    local category = Settings.RegisterVerticalLayoutCategory("asPowerBar")

    if not category then
        return;
    end

    if ASPB_Options == nil or Options_Default.Version ~= ASPB_Options.Version then
        ASPB_Options = {};
        ASPB_Options = CopyTable(Options_Default);
    end

    if ASPB_Positions == nil then
        ASPB_Positions = {};
    end

    ns.options = CopyTable(ASPB_Options);

    for variable, _ in pairs(Options_Default) do
        local name = variable;
        local cvar_name = "asPowerBar_" .. variable;
        local tooltip = ""
        if ASPB_Options[variable] == nil then
            ASPB_Options[variable] = Options_Default[variable];
            ns.options[variable] = Options_Default[variable];
        end
        local defaultValue = Options_Default[variable];
        local currentValue = ASPB_Options[variable];

        if name ~= "Version" then
            if tonumber(defaultValue) ~= nil then
                local setting = Settings.RegisterAddOnSetting(category, cvar_name, variable, tempoption,
                    type(defaultValue), name, defaultValue);
                local options = Settings.CreateSliderOptions(0, 400, 1);
                options:SetLabelFormatter(MinimalSliderWithSteppersMixin.Label.Right);
                Settings.CreateSlider(category, setting, options, tooltip);
                Settings.SetValue(cvar_name, currentValue);
                Settings.SetOnValueChangedCallback(cvar_name, OnSettingChanged);
            else
                local setting = Settings.RegisterAddOnSetting(category, cvar_name, variable, tempoption,
                    type(defaultValue), name, defaultValue);
                Settings.CreateCheckboxWithOptions(category, setting, nil, tooltip)
                Settings.SetValue(cvar_name, currentValue);
                Settings.SetOnValueChangedCallback(cvar_name, OnSettingChanged);
            end
        end
    end

    Settings.RegisterAddOnCategory(category)
end
