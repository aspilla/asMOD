local _, ns = ...;
local Options_Default = {
    Version = 261120,
    ShowFocus = true,
    ShowTarget = true,
    TargetHeight = 17,
    TargetWidth = 200,
    FocusHeight = 17 * 1.3,
    FocusWidth = 200 * 1.3,
    FontSizeRate = 0.6,
};


local L = {
    ShowFocus = "Toggle display of the Focus target cast bar",
    ShowTarget = "Toggle display of the Target cast bar",
    TargetHeight = "Target cast bar height",
    FocusHeight = "Focus cast bar height",
    TargetWidth = "Target cast bar width",
    FocusWidth = "Focus cast bar width",
    FontSizeRate = "Font size rate",
}


if GetLocale() == "koKR" then
    L = {
        ShowFocus = "주시 대상 시전 바 표시 여부",
        ShowTarget = "대상 시전 바 표시 여부",
        TargetHeight = "대상 시전 바 높이",
        FocusHeight = "주시 대상 시전 바 높이",
        TargetWidth = "대상 시전 바 넓이",
        FocusWidth = "주시 대상 시전 바 넓이",
        FontSizeRate = "폰트 크기 비율",
    }
end

ns.options = CopyTable(Options_Default);

local tempoption = {};

local bupdated = false;

local function resize(castbar, height, width)
    if castbar then
        ns.resize(castbar, height, width);
        castbar:Show();
        local function hidecallback()
            castbar:Hide();
        end
        C_Timer.After(2, hidecallback);
    end
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
        ATCB_Options[variable] = value;
        ns.options[variable] = value;

        if string.find(variable, "Width") or string.find(variable, "Height") or variable == "FontSizeRate" then
            resize(ns.targetcastbar, ns.options.TargetHeight, ns.options.TargetWidth);
            resize(ns.focuscastbar, ns.options.FocusHeight, ns.options.FocusWidth);
        else
            bupdated = true;
        end
    end

    local category = Settings.RegisterVerticalLayoutCategory("asTargetCastBar")

    if not category then
        return;
    end

    if ATCB_Options == nil or Options_Default.Version ~= ATCB_Options.Version then
        ATCB_Options = {};
        ATCB_Options = CopyTable(Options_Default);
    end

    if ATCB_Positions_1 == nil then
        ATCB_Positions_1 = {};
    end

    if ATCB_Positions_2 == nil then
        ATCB_Positions_2 = {};
    end


    ns.options = CopyTable(ATCB_Options);

    for variable, _ in pairs(Options_Default) do
        local name = variable;
        local cvar_name = "asTargetCastBar_" .. variable;
        local tooltip = ""
        if ATCB_Options[variable] == nil then
            ATCB_Options[variable] = Options_Default[variable];
            ns.options[variable] = Options_Default[variable];
        end
        local defaultValue = Options_Default[variable];
        local currentValue = ATCB_Options[variable];

        if name ~= "Version" then
            local label = L[name] or name
            if tonumber(defaultValue) ~= nil and name == "FontSizeRate" then
                local setting = Settings.RegisterAddOnSetting(category, cvar_name, variable, tempoption,
                    type(defaultValue), label, defaultValue);
                local options = Settings.CreateSliderOptions(0.5, 1.0, 0.1);
                options:SetLabelFormatter(MinimalSliderWithSteppersMixin.Label.Right);
                Settings.CreateSlider(category, setting, options, tooltip);
                Settings.SetValue(cvar_name, currentValue);
                Settings.SetOnValueChangedCallback(cvar_name, OnSettingChanged);
            elseif tonumber(defaultValue) ~= nil and string.find(name, "Height") then
                local setting = Settings.RegisterAddOnSetting(category, cvar_name, variable, tempoption,
                    type(defaultValue), label, defaultValue);
                local options = Settings.CreateSliderOptions(10, 200, 1);
                options:SetLabelFormatter(MinimalSliderWithSteppersMixin.Label.Right);
                Settings.CreateSlider(category, setting, options, tooltip);
                Settings.SetValue(cvar_name, currentValue);
                Settings.SetOnValueChangedCallback(cvar_name, OnSettingChanged);
            elseif tonumber(defaultValue) ~= nil and string.find(name, "Width") then
                local setting = Settings.RegisterAddOnSetting(category, cvar_name, variable, tempoption,
                    type(defaultValue), label, defaultValue);
                local options = Settings.CreateSliderOptions(100, 2000, 1);
                options:SetLabelFormatter(MinimalSliderWithSteppersMixin.Label.Right);
                Settings.CreateSlider(category, setting, options, tooltip);
                Settings.SetValue(cvar_name, currentValue);
                Settings.SetOnValueChangedCallback(cvar_name, OnSettingChanged);
            else
                local setting = Settings.RegisterAddOnSetting(category, cvar_name, variable, tempoption,
                    type(defaultValue), label, defaultValue);
                Settings.CreateCheckboxWithOptions(category, setting, nil, tooltip);
                Settings.SetValue(cvar_name, currentValue);
                Settings.SetOnValueChangedCallback(cvar_name, OnSettingChanged);
            end
        end
    end

    Settings.RegisterAddOnCategory(category)

    EventRegistry:RegisterCallback("SettingsPanel.OnHide", function()
        if bupdated then
            ReloadUI();
        end
    end);
end
