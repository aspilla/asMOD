local _, ns = ...;
local Options_Default = {
    PlaySound = true,
    SoundVolume = 100,
};

ns.options = {};


function ns.SetupOptionPanels()
    local function OnSettingChanged(_, setting, value)
        local variable = setting:GetVariable()
        ADCA_Options[variable] = value;
        ns.options[variable] = value;
    end

    local category = Settings.RegisterVerticalLayoutCategory("asDBMCastingAlert")

    if ADCA_Options == nil then
        ADCA_Options = {};
        ADCA_Options = CopyTable(Options_Default);
    end

    ns.options = CopyTable(ADCA_Options);

    for variable, _ in pairs(Options_Default) do
        local name = variable;
        local tooltip = ""
        if ADCA_Options[variable] == nil then
            ADCA_Options[variable] = Options_Default[variable];
            ns.options[variable] = Options_Default[variable];
        end
        local defaultValue = ADCA_Options[variable];

        if tonumber(defaultValue) ~= nil then
            local setting = Settings.RegisterAddOnSetting(category, name, variable, type(defaultValue), defaultValue);
            local options = Settings.CreateSliderOptions(0, 100, 1);
            options:SetLabelFormatter(MinimalSliderWithSteppersMixin.Label.Right);
            Settings.CreateSlider(category, setting, options, tooltip);
            Settings.SetOnValueChangedCallback(variable, OnSettingChanged);
        else
            local setting = Settings.RegisterAddOnSetting(category, name, variable, type(defaultValue), defaultValue);
            Settings.CreateCheckBox(category, setting, tooltip);
            Settings.SetOnValueChangedCallback(variable, OnSettingChanged);
        end
    end

    Settings.RegisterAddOnCategory(category)
end
