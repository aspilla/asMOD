local _, ns = ...;
local Options_Default = {
    version = 240211,
    ShowPartyInterrupt = true, --파티 차단
    ShowPartyCool = true,      -- 파티 쿨다운
    ShowRaidCool = true,       -- 공격대 쿨다운
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

    local category = Settings.RegisterVerticalLayoutCategory("asReady")



    if AFUF_Options == nil or AFUF_Options.version ~= Options_Default.version then
        AFUF_Options = {};
        AFUF_Options = CopyTable(Options_Default);
    end
    ns.options = CopyTable(AFUF_Options);

    for variable, _ in pairs(Options_Default) do
        if variable ~= "version" then
            local name = variable;
            local cvar_name = "asReady_" .. variable;
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
    end

    Settings.RegisterAddOnCategory(category)
end
