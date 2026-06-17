local _, ns = ...;
local Options_Default = {
    Version = 260512,
    MinTimetoShow = 5,
    Size = 50,
    TextSize = 15,
    ShowName = true,
    ShowButton = true,
    ShowText = true,
    ShowRole = true,
};

local L = {
    MinTimetoShow = "Minimum time to trigger the alert",
    Size = "[Button] Icon size",
    TextSize = "[Center] Text size",
    ShowName = "[Button] Whether to display skill names",
    ShowButton = "[Button] Whether to display the icon",
    ShowText = "[Center] Whether to display text notifications in the center of the screen",
    ShowRole = "Whether to display role icons",
}


if GetLocale() == "koKR" then
    L = {
        MinTimetoShow = "최소 표시 시간",
        Size = "[버튼] 아이콘 크기",
        TextSize = "[중앙] 글자 크기",
        ShowName = "[버튼] 스킬명 표시 여부",
        ShowButton = "[버튼] 아이콘 표시 여부",
        ShowText = "[중앙] 화면가운데 글씨 알림 여부",
        ShowRole = "임무 아이콘 표시 여부",
    }
end


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
        ADTI_Options[variable] = value;
        ns.options[variable] = value;
    end

    local category = Settings.RegisterVerticalLayoutCategory("asDBMTimer")


    if ADTI_Options == nil or Options_Default.Version ~= ADTI_Options.Version then
        ADTI_Options = {}
        ADTI_Options = CopyTable(Options_Default);
    end

    if ADTI_Positions == nil then
        ADTI_Positions = {};
    end

    if ADTI_Positions2 == nil then
        ADTI_Positions2 = {};
    end

    ns.options = CopyTable(ADTI_Options);

    for variable, _ in pairs(Options_Default) do
        local name = variable;

        local cvar_name = "asDBMTimer_" .. variable;
        local tooltip = ""
        if ADTI_Options[variable] == nil then
            ADTI_Options[variable] = Options_Default[variable];
            ns.options[variable] = Options_Default[variable];
        end
        local defaultValue = Options_Default[variable]
        local currentValue = ADTI_Options[variable];

        if name ~= "Version" then
            if tonumber(defaultValue) ~= nil then
                local setting = Settings.RegisterAddOnSetting(category, cvar_name, variable, tempoption,
                    type(defaultValue),
                    L[name], defaultValue);
                local options = Settings.CreateSliderOptions(0, 100, 1);
                options:SetLabelFormatter(MinimalSliderWithSteppersMixin.Label.Right);
                Settings.CreateSlider(category, setting, options, tooltip);
                Settings.SetValue(cvar_name, currentValue);
                Settings.SetOnValueChangedCallback(cvar_name, OnSettingChanged);
            else
                local setting = Settings.RegisterAddOnSetting(category, cvar_name, variable, tempoption,
                    type(defaultValue),
                    L[name], defaultValue);
                Settings.CreateCheckboxWithOptions(category, setting, nil, tooltip);
                Settings.SetValue(cvar_name, currentValue);
                Settings.SetOnValueChangedCallback(cvar_name, OnSettingChanged);
            end
        end
    end

    Settings.RegisterAddOnCategory(category)
end
