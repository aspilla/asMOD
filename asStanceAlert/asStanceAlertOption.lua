local _, ns = ...;

local Options_Default = {
    Version = 261018,
    FontSize = 30,
    ButtonSize = 40,
    ButtonAlert = false,
}

local L = {
    FontSize = "Alert font size",
    ButtonSize = "Alert button size",
    ButtonAlert = "Show button except text",
}


if GetLocale() == "koKR" then
    L = {
        FontSize = "알림 글씨 크기",
        ButtonSize = "알림 버튼 크기",
        ButtonAlert = "글씨 대신 버튼 표시",
    }
end



local tempoption = {};
ns.options = CopyTable(Options_Default);
local bupdated = false;

function ns.SetupOptionPanels()
    local function OnSettingChanged(_, setting, value)
        local function get_variable_from_cvar_name(cvar_name)
            local variable_start_index = string.find(cvar_name, "_") + 1
            local variable = string.sub(cvar_name, variable_start_index)
            return variable
        end

        local cvar_name = setting:GetVariable()
        local variable = get_variable_from_cvar_name(cvar_name)
        ASTA_Options[variable] = value;
        ns.options[variable] = value;
        ns.check_status();
        bupdated = true;
    end

    local category = Settings.RegisterVerticalLayoutCategory("asStanceAlert")

    if ASTA_Options == nil or Options_Default.Version ~= ASTA_Options.Version then
        ASTA_Options = {};
        ASTA_Options = CopyTable(Options_Default);
        ASTA_Positions = {};
        ASTA_Positions2 = {};
    end

    if ASTA_Positions == nil then
        ASTA_Positions = {};
    end

    if ASTA_Positions2 == nil then
        ASTA_Positions2 = {};
    end

    for variable, _ in pairs(Options_Default) do
        local name = variable;
        local cvar_name = "asStanceAlert_" .. variable;
        local tooltip = ""
        if ASTA_Options[variable] == nil then
            ASTA_Options[variable] = Options_Default[variable];
        end
        local defaultValue = Options_Default[variable];
        local currentValue = ASTA_Options[variable];

        if name ~= "Version" then
            if tonumber(defaultValue) ~= nil then
                local setting = Settings.RegisterAddOnSetting(category, cvar_name, variable, tempoption,
                    type(defaultValue), L[name], defaultValue);
                local options = Settings.CreateSliderOptions(5, 100, 1);
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

    Settings.RegisterAddOnCategory(category);

    EventRegistry:RegisterCallback("SettingsPanel.OnHide", function()
        if bupdated then
            ReloadUI();
        end
    end);

end
