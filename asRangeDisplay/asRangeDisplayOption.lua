local _, ns = ...;
local Options_Default = {
    version = 250726,
    ShowTarget = true,
    ShowMouseOver = true,
    ShowFocus = true,
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
        ARD_Options[variable] = value;
        ns.options[variable] = value;
        ReloadUI();
    end

    local category = Settings.RegisterVerticalLayoutCategory("asRangeDisplay")



    if ARD_Options == nil or ARD_Options.version ~= Options_Default.version then
        ARD_Options = {};
        ARD_Options = CopyTable(Options_Default);
    end
    ns.options = CopyTable(ARD_Options);

    for variable, _ in pairs(Options_Default) do
        if variable ~= "version" then
            local name = variable;
            local cvar_name = "asRangeDisplay_" .. variable;
            local tooltip = ""
            if ARD_Options[variable] == nil then
                ARD_Options[variable] = Options_Default[variable];
                ns.options[variable] = Options_Default[variable];
            end
            local defaultValue = Options_Default[variable];
            local currentValue = ARD_Options[variable];

            local setting = Settings.RegisterAddOnSetting(category, cvar_name,  variable, tempoption, type(defaultValue), name, defaultValue);
            Settings.CreateCheckboxWithOptions(category, setting, nil, tooltip);
            Settings.SetValue(cvar_name, currentValue);
            Settings.SetOnValueChangedCallback(cvar_name, OnSettingChanged);
        end
    end

    Settings.RegisterAddOnCategory(category)
end


