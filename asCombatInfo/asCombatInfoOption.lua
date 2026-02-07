local _, ns = ...;
local Options_Default = {
    version = 260206,
    AlignedBuff = false,
    CombatAlphaChange = true,
    ChangeBuffBar = true,
    BuffBarClassColor = true,
    ShowHotKey = true,
    HideBarName = true,
    AlertAssitedSpell = false,
    SpellBorderWidth = 2,
    BuffBorderWidth = 2,
    SpellIconRate = 9,
    BuffIconRate = 8,

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
        ACI_Options[variable] = value;
        ns.options[variable] = value;
        if tonumber(value) == nil then
            ReloadUI();
        else
            ns.refreshall()
        end
    end

    local category = Settings.RegisterVerticalLayoutCategory("asCombatInfo")

    if ACI_Options == nil or ACI_Options.version ~= Options_Default.version then
        ACI_Options = {};
        ACI_Options = CopyTable(Options_Default);
    end
    ns.options = CopyTable(ACI_Options);

    for variable, _ in pairs(Options_Default) do
        if variable ~= "version" then
            local name = variable;
            local cvar_name = "asCombatInfo_" .. variable;
            local tooltip = ""
            if ACI_Options[variable] == nil then
                ACI_Options[variable] = Options_Default[variable];
                ns.options[variable] = Options_Default[variable];
            end
            local defaultValue = Options_Default[variable];
            local currentValue = ACI_Options[variable];

            if tonumber(defaultValue) ~= nil then
                local setting = Settings.RegisterAddOnSetting(category, cvar_name, variable, tempoption,
                    type(defaultValue), name, defaultValue);
                local options = Settings.CreateSliderOptions(1, 9, 1);
                options:SetLabelFormatter(MinimalSliderWithSteppersMixin.Label.Right);
                Settings.CreateSlider(category, setting, options, tooltip);
                Settings.SetValue(cvar_name, currentValue);
                Settings.SetOnValueChangedCallback(cvar_name, OnSettingChanged);
            else
                local setting = Settings.RegisterAddOnSetting(category, cvar_name, variable, tempoption,
                    type(defaultValue),
                    name, defaultValue);
                Settings.CreateCheckboxWithOptions(category, setting, nil, tooltip);
                Settings.SetValue(cvar_name, currentValue);
                Settings.SetOnValueChangedCallback(cvar_name, OnSettingChanged);
            end
        end
    end

    Settings.RegisterAddOnCategory(category)
end
