local _, ns = ...;
local Options_Default = {
    HideDebuff = true,
    HideCombatText = true,
    HideCastBar = true,
    HideClassBar = true,
    ShowClassColor = true,
    ShowAggro = true,
    ShowDebuff = true,
};

ns.options = {};


function ns.SetupOptionPanels()
    local function OnSettingChanged(_, setting, value)
        local variable = setting:GetVariable()
        AFUF_Options[variable] = value;
        ns.options[variable] = value;
        ReloadUI();
    end

    local category = Settings.RegisterVerticalLayoutCategory("asFixUnitFrame")

    if AFUF_Options == nil then
        AFUF_Options = {};
        AFUF_Options = CopyTable(Options_Default);        
    end
    ns.options = CopyTable(AFUF_Options);

    for variable, _ in pairs(Options_Default) do
        local name = variable;
        local tooltip = ""
        if AFUF_Options[variable] == nil then
            AFUF_Options[variable] = Options_Default[variable];
            ns.options[variable] = Options_Default[variable];
        end
        local defaultValue = AFUF_Options[variable];

        local setting = Settings.RegisterAddOnSetting(category, name, variable, type(defaultValue), defaultValue)
        Settings.CreateCheckBox(category, setting, tooltip)
        Settings.SetOnValueChangedCallback(variable, OnSettingChanged)
    end

    Settings.RegisterAddOnCategory(category)
end