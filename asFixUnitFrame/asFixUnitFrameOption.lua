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
        local function get_variable_from_cvar_name(cvar_name)
            local variable_start_index = string.find(cvar_name, "_") + 1
            local variable = string.sub(cvar_name, variable_start_index)
            return variable
        end

        local cvar_name = setting:GetVariable()
        local variable = get_variable_from_cvar_name(cvar_name)
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
        local cvar_name = "asFixUnitFrame_" .. variable;
        local tooltip = ""
        if AFUF_Options[variable] == nil then
            AFUF_Options[variable] = Options_Default[variable];
            ns.options[variable] = Options_Default[variable];
        end
        local defaultValue = AFUF_Options[variable];

        local setting = Settings.RegisterAddOnSetting(category, name, cvar_name, type(defaultValue), defaultValue)
        Settings.CreateCheckBox(category, setting, tooltip)
        Settings.SetOnValueChangedCallback(cvar_name, OnSettingChanged)
    end

    Settings.RegisterAddOnCategory(category)
end