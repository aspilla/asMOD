local _, ns = ...;

local Options_Default = {
    AlertAnyway = false, -- 무조건 알리기
    AnnounceMana = 50,
}

local tempoption = {};

function ns.SetupOptionPanels()
    local bslide = false;

    local function OnSettingChanged(_, setting, value)
        local function get_variable_from_cvar_name(cvar_name)
            local variable_start_index = string.find(cvar_name, "_") + 1
            local variable = string.sub(cvar_name, variable_start_index)
            return variable
        end

        local cvar_name = setting:GetVariable()
        local variable = get_variable_from_cvar_name(cvar_name)
        AHCA_Options[variable] = value;
    end

    local category = Settings.RegisterVerticalLayoutCategory("asHealthChatAlert")

    if AHCA_Options == nil then
        AHCA_Options = {};
        AHCA_Options = CopyTable(Options_Default);
    end

    for variable, _ in pairs(Options_Default) do
        local name = variable;
        local cvar_name = "asHealthChatAlert_" .. variable;
        local tooltip = ""
        if AHCA_Options[variable] == nil then
            AHCA_Options[variable] = Options_Default[variable];
        end
        local defaultValue = Options_Default[variable];
        local currentValue = AHCA_Options[variable];

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

    Settings.RegisterAddOnCategory(category)
end
