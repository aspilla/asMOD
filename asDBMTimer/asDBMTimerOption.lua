local _, ns = ...;
local Options_Default = {
    Version = 240807,
    MinTimetoShow = 10,
    HideNamePlatesCooldown = false,
    ShowInterruptOnlyforNormal = true,
    AOESound = 2.5,
    LockPosition = true, -- 위치 잠금 옵션 추가
};

local OtherOptions_Default = {
    point = "CENTER",
    point2 = "CENTER",
    x = 200, -- 기본 X 위치 (asDBMTimer.lua의 ADBMT_X와 동일하게 설정)
    y = 50,  -- 기본 Y 위치 (asDBMTimer.lua의 ADBMT_Y와 동일하게 설정)
    version = 240808, -- 버전 업데이트
}

ns.options = CopyTable(Options_Default);
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
        ADTI_Options[variable] = value;
        ns.options[variable] = value;        
    end

    local category = Settings.RegisterVerticalLayoutCategory("asDBMTimer")

    if ADTI_Options == nil or Options_Default.Version ~= ADTI_Options.Version then
        ADTI_Options = {};
        ADTI_Options = CopyTable(Options_Default);
    end

    if ADTI_OtherOptions == nil or OtherOptions_Default.version ~= ADTI_OtherOptions.version then
        ADTI_OtherOptions = {};
        ADTI_OtherOptions = CopyTable(OtherOptions_Default);
    end

    ns.options = CopyTable(ADTI_Options);

    for variable, _ in pairs(Options_Default) do
        local name = variable;

        if name ~= "Version" then
            local cvar_name = "asDBMTimer_" .. variable;
            local tooltip = ""
            if ADTI_Options[variable] == nil  then
                ADTI_Options[variable] = Options_Default[variable];
                ns.options[variable] = Options_Default[variable];
            end
            local defaultValue = Options_Default[variable]
            local currentValue = ADTI_Options[variable];

            if variable == "LockPosition" then -- LockPosition 옵션 처리
                local setting = Settings.RegisterAddOnSetting(category, cvar_name,  variable, tempoption, type(defaultValue), name, defaultValue);
                Settings.CreateCheckboxWithOptions(category, setting, nil, tooltip);
                Settings.SetValue(cvar_name, currentValue);
                Settings.SetOnValueChangedCallback(cvar_name, function(_, setting, value)
                    OnSettingChanged(_, setting, value)
                    if _G["asDBMTimer"] then
                        if value == true then
                            _G["asDBMTimer"]:EnableMouse(false);
                            _G["asDBMTimer"].text:Hide();
                            _G["asDBMTimer"]:GetChildren():SetAlpha(0); -- Hide texture
                        else
                            _G["asDBMTimer"]:EnableMouse(true);
                            _G["asDBMTimer"].text:Show();
                            _G["asDBMTimer"]:GetChildren():SetAlpha(0.5); -- Show texture
                        end
                    end
                end);
            elseif tonumber(defaultValue) ~= nil then
                local setting = Settings.RegisterAddOnSetting(category, cvar_name,  variable, tempoption, type(defaultValue), name, defaultValue);
                local options = Settings.CreateSliderOptions(0, 100, 1);
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
    ns.LoadPosition();

    C_AddOns.LoadAddOn("asMOD");
    if _G["asMOD_setupFrame"] and _G["asDBMTimer"] then
        _G["asMOD_setupFrame"](_G["asDBMTimer"], "asDBMTimer");
        ns.SavePosition(_G["asDBMTimer"]); -- Save position after asMOD_setupFrame
    end

    if ns.options.LockPosition and _G["asDBMTimer"] then
        _G["asDBMTimer"]:EnableMouse(false);
        _G["asDBMTimer"].text:Hide();
        _G["asDBMTimer"]:GetChildren():SetAlpha(0); -- Hide texture
    elseif _G["asDBMTimer"] then
        _G["asDBMTimer"]:EnableMouse(true);
        _G["asDBMTimer"].text:Show();
        _G["asDBMTimer"]:GetChildren():SetAlpha(0.5); -- Show texture
    end
end

function ns.LoadPosition()
    if _G["asDBMTimer"] then
        _G["asDBMTimer"]:ClearAllPoints()
        _G["asDBMTimer"]:SetPoint(ADTI_OtherOptions.point, UIParent, ADTI_OtherOptions.point2, ADTI_OtherOptions.x, ADTI_OtherOptions.y);
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
