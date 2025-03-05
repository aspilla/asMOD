local _, ns = ...;
local Options_Default = {
    Version = 241121,
    ShowPortrait = true,
    ShowTotemBar = true,
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
        AUF_Options[variable] = value;
        ns.options[variable] = value;
        
        ReloadUI();
    end

    local category = Settings.RegisterVerticalLayoutCategory("asUnitFrame")

    if AUF_Options == nil or Options_Default.Version ~= AUF_Options.Version then
        AUF_Options = {};
        AUF_Options = CopyTable(Options_Default);        
    end

    ns.options = CopyTable(AUF_Options);    

    for variable, _ in pairs(Options_Default) do
        local name = variable;

        if name ~= "Version" then
            local cvar_name = "asUnitFrame_" .. variable;
            local tooltip = ""
            if AUF_Options[variable] == nil  then
                AUF_Options[variable] = Options_Default[variable];
                ns.options[variable] = Options_Default[variable];                
            end
            local defaultValue = Options_Default[variable];
            local currentValue = AUF_Options[variable];

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
