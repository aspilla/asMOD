local _, ns = ...;

local Options_Default = {
    AlertAnyway = false, -- 무조건 알리기
    AnnounceMana = 50,
}

function ns.SetupOptionPanels()

    local bslide = false;

    local function OnSettingChanged(_, setting, value)
        local variable = setting:GetVariable()
        AHCA_Options[variable] = value;
    end

    local category = Settings.RegisterVerticalLayoutCategory("asHealthChatAlert")

    if AHCA_Options == nil then
        AHCA_Options = {};
        AHCA_Options = CopyTable(Options_Default);
    end

    for variable, _ in pairs(Options_Default) do
        local name = variable;
        local tooltip = ""
        if AHCA_Options[variable] == nil then
            AHCA_Options[variable] = Options_Default[variable];
        end
        local defaultValue = AHCA_Options[variable];

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
