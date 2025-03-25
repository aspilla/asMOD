local _, ns = ...;

local Options_Default = {
    version = 250320,
    HideModifier = 1,
    Trigger_DBM_Interrupt_Only = true,
    Show_DBM_Interrupt_Only = false,
};

ns.options = CopyTable(Options_Default);


ns.MustShow_IDs = {
	[229537] = true,        --공허의 사절
    [223724] = true,        --보충용 통
}


local modifier_options = {
    [1] = "Key Binding",
    [2] = "ALT + CTRL",
    [3] = "ALT",
    [4] = "CTRL",
    [5] = "SHIFT",
    [6] = "Trigger from Casting",

}

local tempoption = {};

function ns.SetupOptionPanels()
    local function OnSettingChanged(_, setting, value)
        local function get_variable_from_cvar_name(cvar_name)
            local variable_start_index = string.find(cvar_name, "_") + 1
            local variable = string.sub(cvar_name, variable_start_index)
            return variable
        end

        local cvar_name = setting:GetVariable()
        local variable = get_variable_from_cvar_name(cvar_name)
        AHNP_Options[variable] = value;
        ns.options[variable] = value;
        ReloadUI();
    end

    local category = Settings.RegisterVerticalLayoutCategory("asHideNamePlates");



    if AHNP_Options == nil or AHNP_Options.version ~= Options_Default.version then
        AHNP_Options = {};
        AHNP_Options = CopyTable(Options_Default);
    end
    ns.options = CopyTable(AHNP_Options);

    for variable, _ in pairs(Options_Default) do
        if variable ~= "version" then
            local name = variable;
            local cvar_name = "asHideNamePlates_" .. variable;
            local tooltip = ""
            if AHNP_Options[variable] == nil then
                AHNP_Options[variable] = Options_Default[variable];
                ns.options[variable] = Options_Default[variable];
            end
            local defaultValue = Options_Default[variable];
            local currentValue = AHNP_Options[variable];

            if name == "HideModifier" then
                local function GetOptions()
                    local container = Settings.CreateControlTextContainer()

                    for id, v in pairs(modifier_options) do
                        container:Add(id, v);
                    end
                    return container:GetData();
                end

                local setting = Settings.RegisterAddOnSetting(category, cvar_name, variable, tempoption,
                    type(defaultValue), name, defaultValue);

                Settings.CreateDropdown(category, setting, GetOptions, tooltip);
                Settings.SetValue(cvar_name, currentValue);
                Settings.SetOnValueChangedCallback(cvar_name, OnSettingChanged);
            else
                local setting = Settings.RegisterAddOnSetting(category, cvar_name, variable, tempoption,
                    type(defaultValue), name, defaultValue);
                Settings.CreateCheckboxWithOptions(category, setting, nil, tooltip);
                Settings.SetValue(cvar_name, currentValue);
                Settings.SetOnValueChangedCallback(cvar_name, OnSettingChanged);
            end
        end
    end

    Settings.RegisterAddOnCategory(category)
end
