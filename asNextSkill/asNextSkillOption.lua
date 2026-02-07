local _, ns = ...;
local Options_Default = {
    version = 260125,
    ShowHotKey = true,
    AssistShowOnly = false,
    UIScale = 1.0,
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
        ASNS_Options[variable] = value;
        ns.options[variable] = value;
        if variable == "UIScale" then
            if ns.main_frame then
                ns.main_frame:SetScale(value);
            end
        else
            ReloadUI();
        end
    end

    local category = Settings.RegisterVerticalLayoutCategory("asNextSkill")

    if ASNS_Options == nil or ASNS_Options.version ~= Options_Default.version then
        ASNS_Options = {};
        ASNS_Options = CopyTable(Options_Default);
    end
    ns.options = CopyTable(ASNS_Options);

    for variable, _ in pairs(Options_Default) do
        if variable ~= "version" then
            local name = variable;
            local cvar_name = "asNextSkill_" .. variable;
            local tooltip = ""
            if ASNS_Options[variable] == nil then
                ASNS_Options[variable] = Options_Default[variable];
                ns.options[variable] = Options_Default[variable];
            end
            local defaultValue = Options_Default[variable];
            local currentValue = ASNS_Options[variable];

            if tonumber(defaultValue) ~= nil then
                local setting = Settings.RegisterAddOnSetting(category, cvar_name, variable, tempoption,
                    type(defaultValue), name, defaultValue);
                local options = Settings.CreateSliderOptions(0.5, 3, 0.1);
                options:SetLabelFormatter(MinimalSliderWithSteppersMixin.Label.Right);
                Settings.CreateSlider(category, setting, options, tooltip);
                Settings.SetValue(cvar_name, currentValue);
                Settings.SetOnValueChangedCallback(cvar_name, OnSettingChanged);
            else
                local setting = Settings.RegisterAddOnSetting(category, cvar_name, variable, tempoption,
                    type(defaultValue),
                    name, defaultValue);
                Settings.CreateCheckboxWithOptions(category, setting, nil, tooltip);
                Settings.SetValue(cvar_name, currentValue);
                Settings.SetOnValueChangedCallback(cvar_name, OnSettingChanged);
            end
        end
    end

    Settings.RegisterAddOnCategory(category)
end
