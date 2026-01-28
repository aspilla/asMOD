local _, ns = ...;
local Options_Default = {
    Version = 251125,
    ShowPortrait = true,
    ShowTotemBar = true,
    ShowBossBuff = true,
    ShowTargetBorder = true,
    ShowDebuff = true,
    CheckRange = true,
    CombatAlphaChange = true,
    Width = 200,
    Height = 35,
    PowerWidth = 80,
    PowerHeight = 5,
    FontSize = 12,
    FocusWidth = 150,
    FocusHeight = 20,
    FocusPowerWidth = 60,
    FocusPowerHeight = 3,
    FocusFontSize = 11,
    PetWidth = 100,
    PetHeight = 15,
    PetPowerWidth = 40,
    PetPowerHeight = 2,
    PetFontSize = 9,
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
        AUF_Options[variable] = value;
        ns.options[variable] = value;
        
        if tonumber(value) == nil then
            ReloadUI();
        end
    end

    local category = Settings.RegisterVerticalLayoutCategory("asUnitFrame")

    if AUF_Options == nil or Options_Default.Version ~= AUF_Options.Version then
        AUF_Options = {};
        AUF_Options = CopyTable(Options_Default);        
    end

    if AUF_Positions == nil then
        AUF_Positions = {};
        AUF_Positions.PlayerFrame = {};
        AUF_Positions.TargetFrame = {};
        AUF_Positions.FocusFrame = {};
        AUF_Positions.PetFrame = {};
        AUF_Positions.TargetTargetFrame = {};

        AUF_Positions.BossFrames = {};
        if (MAX_BOSS_FRAMES) then
            for i = 1, MAX_BOSS_FRAMES do
                AUF_Positions.BossFrames[i] = {};
            end
        end
    end

    ns.options = CopyTable(AUF_Options);    

    for variable, _ in pairs(Options_Default) do
        local name = variable;

        if name ~= "Version" then
            local cvar_name = "asUnitFrame_" .. variable;
            local tooltip = ""
            if AUF_Options[variable] == nil  then
                AUF_Options[variable] = Options_Default[variable];
                ns.options[variable] = Options_Default[variable];                
            end
            local defaultValue = Options_Default[variable];
            local currentValue = AUF_Options[variable];

            if tonumber(defaultValue) ~= nil then
                local setting = Settings.RegisterAddOnSetting(category, cvar_name,  variable, tempoption, type(defaultValue), name, defaultValue);
                local options = Settings.CreateSliderOptions(0, 400, 1);
                options:SetLabelFormatter(MinimalSliderWithSteppersMixin.Label.Right);
                Settings.CreateSlider(category, setting, options, tooltip);
                Settings.SetValue(cvar_name, currentValue);
                Settings.SetOnValueChangedCallback(cvar_name, OnSettingChanged);
            else
                local setting = Settings.RegisterAddOnSetting(category, cvar_name,  variable, tempoption, type(defaultValue), name, defaultValue);

                Settings.CreateCheckboxWithOptions(category, setting, nil, tooltip);
                Settings.SetValue(cvar_name, currentValue);
                Settings.SetOnValueChangedCallback(cvar_name, OnSettingChanged);
            end
        end
    end

    Settings.RegisterAddOnCategory(category)
end
