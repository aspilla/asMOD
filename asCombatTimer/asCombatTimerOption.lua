local _, ns = ...;
local Options_Default = {
    Version = 260124,    
    FontSize = 20,
    Font = 1,
    ShowWhenCombat = true,
    ShowSubSeconds = true,
};

local L = {
    FontSize = "폰트 크기",
    Font = "폰트",
    ShowWhenCombat = "전투 중 표시",
    ShowSubSeconds = "0.1초 단위 표시",
}

if GetLocale() == "koKR" then
    L = {
        FontSize = "폰트 크기",
        Font = "폰트",
        ShowWhenCombat = "전투 중 표시",
        ShowSubSeconds = "0.1초 단위 표시",
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
        ASTM_Options[variable] = value;
        ns.options[variable] = value;
        ns.update_options();
    end

    local category = Settings.RegisterVerticalLayoutCategory("asCombatTimer")

    if not category then
        return;
    end


    if ASTM_Options == nil or Options_Default.Version ~= ASTM_Options.Version then
        ASTM_Options = {};
        ASTM_Options = CopyTable(Options_Default);
    end

    if ASTM_Position == nil then
        ASTM_Position = {};
    end

    ns.options = CopyTable(ASTM_Options);

    for variable, _ in pairs(Options_Default) do
        local name = variable;
        local cvar_name = "asCombatTimer_" .. variable;
        local tooltip = ""
        if ASTM_Options[variable] == nil then
            ASTM_Options[variable] = Options_Default[variable];
            ns.options[variable] = Options_Default[variable];
        end
        local defaultValue = Options_Default[variable];
        local currentValue = ASTM_Options[variable];

        if name ~= "Version" then
            local label = L[name] or name
            if name == "Font" then
                local function GetOptions()
                    local container = Settings.CreateControlTextContainer()
                    container:Add(1, "STANDARD_TEXT_FONT")
                    container:Add(2, "UNIT_NAME_FONT")
                    container:Add(3, "DAMAGE_TEXT_FONT")
                    return container:GetData()
                end

                local setting = Settings.RegisterAddOnSetting(category, cvar_name, variable, tempoption, type(defaultValue), label, defaultValue)
                Settings.CreateDropdown(category, setting, GetOptions, tooltip)
                Settings.SetValue(cvar_name, currentValue);
                Settings.SetOnValueChangedCallback(cvar_name, OnSettingChanged)
            elseif tonumber(defaultValue) ~= nil then
                local setting = Settings.RegisterAddOnSetting(category, cvar_name, variable, tempoption,
                    type(defaultValue), label, defaultValue);
                local options = Settings.CreateSliderOptions(5, 60, 1);
                options:SetLabelFormatter(MinimalSliderWithSteppersMixin.Label.Right);
                Settings.CreateSlider(category, setting, options, tooltip);
                Settings.SetValue(cvar_name, currentValue);
                Settings.SetOnValueChangedCallback(cvar_name, OnSettingChanged);
            else
                local setting = Settings.RegisterAddOnSetting(category, cvar_name, variable, tempoption,
                    type(defaultValue), label, defaultValue);
                Settings.CreateCheckboxWithOptions(category, setting, nil, tooltip)
                Settings.SetValue(cvar_name, currentValue);
                Settings.SetOnValueChangedCallback(cvar_name, OnSettingChanged);
            end
        end
    end

    Settings.RegisterAddOnCategory(category)
end
