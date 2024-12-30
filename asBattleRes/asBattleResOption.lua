local _, ns = ...;
local Options_Default = {
    Version = 241231,
    LockWindow = false,        
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
        ASBR_Options[variable] = value;
        ns.options[variable] = value;
    end

    local category = Settings.RegisterVerticalLayoutCategory("asBattleRes")

    if not category then
        return;
    end

    if ASBR_Options == nil or Options_Default.Version ~= ASBR_Options.Version then
        ASBR_Options = {};
        ASBR_Options = CopyTable(Options_Default);
    end

    ns.options = CopyTable(ASBR_Options);

    for variable, _ in pairs(Options_Default) do
        local name = variable;
        local cvar_name = "asBattleRes_" .. variable;
        local tooltip = ""
        if ASBR_Options[variable] == nil then
            ASBR_Options[variable] = Options_Default[variable];
            ns.options[variable] = Options_Default[variable];
        end
        local defaultValue = ASBR_Options[variable];

        if name ~= "Version" then
            if tonumber(defaultValue) ~= nil then
                local setting = Settings.RegisterAddOnSetting(category, cvar_name,  variable, tempoption, type(defaultValue), name, defaultValue);
                local options = Settings.CreateSliderOptions(0, 100, 1);
                options:SetLabelFormatter(MinimalSliderWithSteppersMixin.Label.Right);
                Settings.CreateSlider(category, setting, options, tooltip);
                Settings.SetOnValueChangedCallback(cvar_name, OnSettingChanged);
            else
                local setting = Settings.RegisterAddOnSetting(category, cvar_name,  variable, tempoption, type(defaultValue), name, defaultValue);
                Settings.CreateCheckboxWithOptions(category, setting, nil, tooltip)
                Settings.SetOnValueChangedCallback(cvar_name, OnSettingChanged);
            end
        end
    end

    Settings.RegisterAddOnCategory(category)
end
