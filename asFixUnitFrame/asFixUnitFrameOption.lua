local _, ns = ...;
local Options_Default = {
    version = 231218,
    HideDebuff = false,
    HideCombatText = true,
    HideCastBar = true,
    HideClassBar = true,
    ShowClassColor = true,
    ShowAggro = true,
    ShowPortraitDebuff = true,
};

ns.options = CopyTable(Options_Default);
local tempoption = {};

-- 안보이게 할 디법 (다른 케릭)
ns.ShowOnlyMine = {
    [447513] = 1,       --만신창이 (전사)
    [445584] = 1,       --사형선고 (전사)
    [434473] = 1,       --폭격 (기원사)
}


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



    if AFUF_Options == nil or AFUF_Options.version ~= Options_Default.version then
        AFUF_Options = {};
        AFUF_Options = CopyTable(Options_Default);
    end
    ns.options = CopyTable(AFUF_Options);

    for variable, _ in pairs(Options_Default) do
        if variable ~= "version" then
            local name = variable;
            local cvar_name = "asFixUnitFrame_" .. variable;
            local tooltip = ""
            if AFUF_Options[variable] == nil then
                AFUF_Options[variable] = Options_Default[variable];
                ns.options[variable] = Options_Default[variable];
            end
            local defaultValue = AFUF_Options[variable];

            local setting = Settings.RegisterAddOnSetting(category, cvar_name,  variable, tempoption, type(defaultValue), name, defaultValue);
            
            Settings.CreateCheckboxWithOptions(category, setting, nil, tooltip)
            Settings.SetOnValueChangedCallback(cvar_name, OnSettingChanged)
            
        end
    end

    Settings.RegisterAddOnCategory(category)
end
