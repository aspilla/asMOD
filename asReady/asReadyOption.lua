local _, ns = ...;
local Options_Default = {
    version = 240211,
    MaxShow = 6,
    MaxTime = 15,
};

local L = {
    MaxShow = "Maximum number of bars to display",
    MaxTime = "Maximum time of bars to display",
}

if GetLocale() == "koKR" then
    L = {
        MaxShow = "최대 표시 개수",
        MaxTime = "최대 표시 시간",
    }
end

ns.options = CopyTable(Options_Default);


local tempoption = {};
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
        ARDY_Options[variable] = value;
        ns.options[variable] = value;
        bupdated = true;
    end

    local category = Settings.RegisterVerticalLayoutCategory("asReady")

    if ARDY_Options == nil or ARDY_Options.version ~= Options_Default.version then
        ARDY_Options = {};
        ARDY_Options = CopyTable(Options_Default);
    end

    if ARDY_Positions == nil then
        ARDY_Positions = {};
    end

    ns.options = CopyTable(ARDY_Options);

    for variable, _ in pairs(Options_Default) do
        if variable ~= "version" then
            local name = variable;
            local cvar_name = "asReady_" .. variable;
            local tooltip = ""
            if ARDY_Options[variable] == nil then
                ARDY_Options[variable] = Options_Default[variable];
                ns.options[variable] = Options_Default[variable];
            end
            local defaultValue = Options_Default[variable];
            local currentValue = ARDY_Options[variable];
            local label = L[name] or name

            if tonumber(defaultValue) ~= nil then
                local setting = Settings.RegisterAddOnSetting(category, cvar_name, variable, tempoption,
                    type(defaultValue), label, defaultValue);
                local minVal, maxVal, step = 1, 10, 1;
                if variable == "MaxTime" then
                    minVal, maxVal, step = 3, 30, 1;
                end

                local options = Settings.CreateSliderOptions(minVal, maxVal, step);
                options:SetLabelFormatter(MinimalSliderWithSteppersMixin.Label.Right);
                Settings.CreateSlider(category, setting, options, tooltip);
                Settings.SetValue(cvar_name, currentValue);
                Settings.SetOnValueChangedCallback(cvar_name, OnSettingChanged);
            else
                local setting = Settings.RegisterAddOnSetting(category, cvar_name, variable, tempoption,
                    type(defaultValue), label, defaultValue);
                Settings.CreateCheckboxWithOptions(category, setting, nil, tooltip);
                Settings.SetValue(cvar_name, currentValue);
                Settings.SetOnValueChangedCallback(cvar_name, OnSettingChanged);
            end
        end
    end

    Settings.RegisterAddOnCategory(category);
    EventRegistry:RegisterCallback("SettingsPanel.OnHide", function()
        if bupdated then
            ReloadUI();
        end
    end);
end
