local _, ns = ...;
local Options_Default = {
    MinTimetoShow = 3,
    Size = 50,
    ShowName = true, 
    LockPosition = true, -- 위치 잠금 옵션 추가
};

local OtherOptions_Default = {
    Version = 251219,
    point = "CENTER",
    point2 = "CENTER",
    x = 250, -- 기본 X 위치 (asDBMTimer.lua의 ADBMT_X와 동일하게 설정)
    y = 0,  -- 기본 Y 위치 (asDBMTimer.lua의 ADBMT_Y와 동일하게 설정)
}

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


    if ADTI_Options == nil or ADTI_OtherOptions == nil or OtherOptions_Default.Version ~= ADTI_OtherOptions.Version then
        ADTI_Options = {}
        ADTI_Options = CopyTable(Options_Default);
        ADTI_OtherOptions = {};
        ADTI_OtherOptions = CopyTable(OtherOptions_Default);
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

        if variable == "LockPosition" then     -- LockPosition 옵션 처리
            local setting = Settings.RegisterAddOnSetting(category, cvar_name, variable, tempoption, type(defaultValue),
                name, defaultValue);
            Settings.CreateCheckboxWithOptions(category, setting, nil, tooltip);
            Settings.SetValue(cvar_name, currentValue);
            Settings.SetOnValueChangedCallback(cvar_name, function(_, setting, value)
                OnSettingChanged(_, setting, value)
                if ns.asDBMTimer then
                    if value == true then
                        ns.asDBMTimer:EnableMouse(false);
                        ns.asDBMTimer.text:Hide();
                        ns.asDBMTimer.tex:Hide();     -- Hide texture
                    else
                        ns.asDBMTimer:EnableMouse(true);
                        ns.asDBMTimer.text:Show();
                        ns.asDBMTimer.tex:Show();     -- Show texture
                    end
                end
            end);
        elseif tonumber(defaultValue) ~= nil then
            local setting = Settings.RegisterAddOnSetting(category, cvar_name, variable, tempoption, type(defaultValue),
                name, defaultValue);
            local options = Settings.CreateSliderOptions(0, 100, 1);
            options:SetLabelFormatter(MinimalSliderWithSteppersMixin.Label.Right);
            Settings.CreateSlider(category, setting, options, tooltip);
            Settings.SetValue(cvar_name, currentValue);
            Settings.SetOnValueChangedCallback(cvar_name, OnSettingChanged);
        else
            local setting = Settings.RegisterAddOnSetting(category, cvar_name, variable, tempoption, type(defaultValue),
                name, defaultValue);
            Settings.CreateCheckboxWithOptions(category, setting, nil, tooltip);
            Settings.SetValue(cvar_name, currentValue);
            Settings.SetOnValueChangedCallback(cvar_name, OnSettingChanged);
        end
    end

    Settings.RegisterAddOnCategory(category)
	ns.LoadPosition();

    local bloaded = C_AddOns.LoadAddOn("asMOD");
    if bloaded and ASMODOBJ.load_position and ns.asDBMTimer then
        ASMODOBJ.load_position(ns.asDBMTimer, "asDBMTimer");
        ns.SavePosition(ns.asDBMTimer); -- Save position after ASMODOBJ.load_position
    end

    if ns.options.LockPosition and ns.asDBMTimer then
        ns.asDBMTimer:EnableMouse(false);
        ns.asDBMTimer.text:Hide();
        ns.asDBMTimer.tex:Hide(); -- Hide texture
    elseif ns.asDBMTimer then
        ns.asDBMTimer:EnableMouse(true);
        ns.asDBMTimer.text:Show();
        ns.asDBMTimer.tex:Show(); -- Show texture
    end
end

function ns.LoadPosition()
    if ns.asDBMTimer then
        ns.asDBMTimer:ClearAllPoints()
        ns.asDBMTimer:SetPoint(ADTI_OtherOptions.point, UIParent, ADTI_OtherOptions.point2, ADTI_OtherOptions.x,
            ADTI_OtherOptions.y);
    end
end

function ns.SavePosition(frame)
    if frame then
        ADTI_OtherOptions.point, _, ADTI_OtherOptions.point2, ADTI_OtherOptions.x, ADTI_OtherOptions.y = frame:GetPoint();
        if frame.StopMovingOrSizing then
            frame:StopMovingOrSizing();
        end
    end
end
