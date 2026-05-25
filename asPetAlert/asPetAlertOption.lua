local _, ns = ...;

local Options_Default = {
    Version = 260505,
    FontSize = 30,
}

local L= {
    FontSize = "Alert Font Size",
}


if GetLocale() == "koKR" then
L= {
    FontSize = "알림 글씨 크기",
}
end



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
        APA_Options[variable] = value;
        ns.options[variable] = value;
        ns.check_status();
    end

    local category = Settings.RegisterVerticalLayoutCategory("asPetAlert")

    if APA_Options == nil or Options_Default.Version ~= APA_Options.Version then
        APA_Options = {};
        APA_Options = CopyTable(Options_Default);
    end

    if APA_Positions == nil then
        APA_Positions = {};
    end
    if APA_Positions2 == nil then
        APA_Positions2 = {};
    end

    for variable, _ in pairs(Options_Default) do
        local name = variable;
        local cvar_name = "asPetAlert_" .. variable;
        local tooltip = ""
        if APA_Options[variable] == nil then
            APA_Options[variable] = Options_Default[variable];
        end
        local defaultValue = Options_Default[variable];
        local currentValue = APA_Options[variable];

        if name ~= "Version" then
            if tonumber(defaultValue) ~= nil then
                local setting = Settings.RegisterAddOnSetting(category, cvar_name, variable, tempoption,
                    type(defaultValue), L[name], defaultValue);
                local options = Settings.CreateSliderOptions(5, 50, 1);
                options:SetLabelFormatter(MinimalSliderWithSteppersMixin.Label.Right);
                Settings.CreateSlider(category, setting, options, tooltip);
                Settings.SetValue(cvar_name, currentValue);
                Settings.SetOnValueChangedCallback(cvar_name, OnSettingChanged);
            else
                local setting = Settings.RegisterAddOnSetting(category, cvar_name, variable, tempoption,
                    type(defaultValue), L[name], defaultValue);

                Settings.CreateCheckboxWithOptions(category, setting, nil, tooltip);
                Settings.SetValue(cvar_name, currentValue);
                Settings.SetOnValueChangedCallback(cvar_name, OnSettingChanged);
            end
        end

        ns.options[variable] = currentValue;
    end

    Settings.RegisterAddOnCategory(category)
end
