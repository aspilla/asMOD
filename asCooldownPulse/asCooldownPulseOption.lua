local _, ns = ...;
local Options_Default = {
    PlaySound = true,
    AlwaysShowButtons = false;
};

ns.options = {};


function ns.SetupOptionPanels()
    local function OnSettingChanged(_, setting, value)
        local variable = setting:GetVariable()
        ACDP_Options[variable] = value;
        ns.options[variable] = value;
        ReloadUI();
    end

    local category = Settings.RegisterVerticalLayoutCategory("asCooldownPulse")

    if ACDP_Options == nil then
        ACDP_Options = {};
        ACDP_Options = CopyTable(Options_Default);
    end

    ns.options = CopyTable(ACDP_Options);

    for variable, _ in pairs(Options_Default) do
        local name = variable;
        local tooltip = ""
        if ACDP_Options[variable] == nil then
            ACDP_Options[variable] = Options_Default[variable];
            ns.options[variable] = Options_Default[variable];
        end
        local defaultValue = ACDP_Options[variable];

        local setting = Settings.RegisterAddOnSetting(category, name, variable, type(defaultValue), defaultValue)
        Settings.CreateCheckBox(category, setting, tooltip)
        Settings.SetOnValueChangedCallback(variable, OnSettingChanged)
    end

    Settings.RegisterAddOnCategory(category)
end
