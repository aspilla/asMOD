local _, ns = ...;
local Options_Default = {
    Version = 260522,
    SimpleDesign = true,
    BarWidth = 238,
    BarHeight = 20,
    ShowTick = true,
    Scale = 1,
};

ns.options = CopyTable(Options_Default);
local tempoption = {};

local function hidecallback()
    ns.playercastbar:Hide()
end

function ns.setup_option()
    local function OnSettingChanged(_, setting, value)
        local function get_variable_from_cvar_name(cvar_name)
            local variable_start_index = string.find(cvar_name, "_") + 1
            local variable = string.sub(cvar_name, variable_start_index)
            return variable
        end

        local cvar_name = setting:GetVariable()
        local variable = get_variable_from_cvar_name(cvar_name)
        ACB_Options[variable] = value;
        ns.options[variable] = value;

        if variable == "Scale" then
            if ns.playercastbar then
                ns.playercastbar:SetScale(value);
            end
        elseif variable == "BarWidth" or variable == "BarHeight" then
            if ns.playercastbar then
                ns.resize(ns.playercastbar);
                ns.playercastbar:Show();
                C_Timer.After(2, hidecallback);
            end
        else
            ReloadUI();
        end
    end

    local category = Settings.RegisterVerticalLayoutCategory("asCastBar")

    if not category then
        return;
    end

    if ACB_Options == nil or Options_Default.Version ~= ACB_Options.Version then
        ACB_Options = {};
        ACB_Options = CopyTable(Options_Default);
    end

    if ACB_Positions == nil then
        ACB_Positions = {};
    end

    ns.options = CopyTable(ACB_Options);

    for variable, _ in pairs(Options_Default) do
        local name = variable;
        local cvar_name = "asCastBar_" .. variable;
        local tooltip = ""
        if ACB_Options[variable] == nil then
            ACB_Options[variable] = Options_Default[variable];
            ns.options[variable] = Options_Default[variable];
        end
        local defaultValue = Options_Default[variable];
        local currentValue = ACB_Options[variable];

        if name ~= "Version" then
            if tonumber(defaultValue) ~= nil and name == "Scale" then
                local setting = Settings.RegisterAddOnSetting(category, cvar_name, variable, tempoption,
                    type(defaultValue), name, defaultValue);
                local options = Settings.CreateSliderOptions(0.5, 3, 0.1);
                options:SetLabelFormatter(MinimalSliderWithSteppersMixin.Label.Right);
                Settings.CreateSlider(category, setting, options, tooltip);
                Settings.SetValue(cvar_name, currentValue);
                Settings.SetOnValueChangedCallback(cvar_name, OnSettingChanged);
            elseif tonumber(defaultValue) ~= nil then
                local setting = Settings.RegisterAddOnSetting(category, cvar_name, variable, tempoption,
                    type(defaultValue), name, defaultValue);
                local options = Settings.CreateSliderOptions(10, 500, 1);
                options:SetLabelFormatter(MinimalSliderWithSteppersMixin.Label.Right);
                Settings.CreateSlider(category, setting, options, tooltip);
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
