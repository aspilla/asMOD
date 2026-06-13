
local _, ns = ...;
local Options_Default = {
    Version = 260612,
    Size = 30,
    ShowHealth = true,
    FontSize = 10,
};

local L= {
    Size = "Button Size",
    FontSize = "Health Font Size",
    ShowHealth = "Displaying Health",
}


if GetLocale() == "koKR" then
L= {
    Size = "버튼 크기",
    FontSize = "체력 글씨 크기",
    ShowHealth = "체력 수치 표시",
}
end

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
        AFS_Options[variable] = value;
        ns.options[variable] = value;
    end

    local category = Settings.RegisterVerticalLayoutCategory("asFirestarter")

    if not category then
        return;
    end

    if AFS_Options == nil or Options_Default.Version ~= AFS_Options.Version then
        AFS_Options = {};
        AFS_Options = CopyTable(Options_Default);
    end

    if AFS_Positions == nil then
        AFS_Positions = {};
    end

    ns.options = CopyTable(AFS_Options);

    for variable, _ in pairs(Options_Default) do
        local name = variable;
        local cvar_name = "asFirestarter_" .. variable;
        local tooltip = ""
        if AFS_Options[variable] == nil then
            AFS_Options[variable] = Options_Default[variable];
            ns.options[variable] = Options_Default[variable];
        end
        local defaultValue = Options_Default[variable];
        local currentValue = AFS_Options[variable];

        if name ~= "Version" then
            if tonumber(defaultValue) ~= nil then
                local setting = Settings.RegisterAddOnSetting(category, cvar_name,  variable, tempoption, type(defaultValue), L[name], defaultValue);
                local options = Settings.CreateSliderOptions(0, 100, 1);
                options:SetLabelFormatter(MinimalSliderWithSteppersMixin.Label.Right);
                Settings.CreateSlider(category, setting, options, tooltip);
                Settings.SetValue(cvar_name, currentValue);
                Settings.SetOnValueChangedCallback(cvar_name, OnSettingChanged);
            else
                local setting = Settings.RegisterAddOnSetting(category, cvar_name,  variable, tempoption, type(defaultValue), L[name], defaultValue);
                Settings.CreateCheckboxWithOptions(category, setting, nil, tooltip);
                Settings.SetValue(cvar_name, currentValue);
                Settings.SetOnValueChangedCallback(cvar_name, OnSettingChanged);
            end
        end
    end

    Settings.RegisterAddOnCategory(category)
end
