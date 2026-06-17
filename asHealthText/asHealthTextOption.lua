local _, ns = ...;
local Options_Default = {
    Version = 260617,
    ShowDecimal = true,

};

local L = {
    ShowDecimal = "Display Health Decimals",
}


if GetLocale() == "koKR" then
    L = {
        ShowDecimal = "생명력 소숫점 첫자리 표시",
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
        AHT_Options[variable] = value;
        ns.options[variable] = value;
        ReloadUI();
    end

    local category = Settings.RegisterVerticalLayoutCategory("asHealthText")


    if AHT_Options == nil or Options_Default.Version ~= AHT_Options.Version then
        AHT_Options = {}
        AHT_Options = CopyTable(Options_Default);
    end

    ns.options = CopyTable(AHT_Options);

    for variable, _ in pairs(Options_Default) do
        local name = variable;

        local cvar_name = "asHealthText_" .. variable;
        local tooltip = ""
        if AHT_Options[variable] == nil then
            AHT_Options[variable] = Options_Default[variable];
            ns.options[variable] = Options_Default[variable];
        end
        local defaultValue = Options_Default[variable]
        local currentValue = AHT_Options[variable];

        if name ~= "Version" then
            local setting = Settings.RegisterAddOnSetting(category, cvar_name, variable, tempoption,
                type(defaultValue),
                L[name], defaultValue);
            Settings.CreateCheckboxWithOptions(category, setting, nil, tooltip);
            Settings.SetValue(cvar_name, currentValue);
            Settings.SetOnValueChangedCallback(cvar_name, OnSettingChanged);
        end
    end

    Settings.RegisterAddOnCategory(category)
end
