local _, ns = ...;

ns.UpdateRate = 0.25; -- 1회 Update 주기 (초) 작으면 작을 수록 Frame Rate 감소 가능, 크면 Update 가 느림
ns.ACRB_HealerManaBarHeight = 4;

local Options_Default = {
    version = 251228,
    BottomHealerManaBar = true, -- 힐러 마나바
    BottomTankPowerBar = true, -- 탱커 Power 바
    ChangeIcon = true,
    ShowCooldown = true,
    CenterDefensiveSizeRate = 0.6,
    CooldownSizeRate = 1,
    ShowCasting = true,
    ShowCastingRaid = false,
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
        ACRB_Options[variable] = value;
        ns.options[variable] = value;
        if type(value) ~= "number" then
            ReloadUI();
        end
    end

    local category = Settings.RegisterVerticalLayoutCategory("asCompactRaidBuff")

    if ACRB_Options == nil or ACRB_Options.version ~= Options_Default.version then
        ACRB_Options = {};
        ACRB_Options = CopyTable(Options_Default);
    end
    ns.options = CopyTable(ACRB_Options);

    for variable, _ in pairs(Options_Default) do
        if variable ~= "version" then
            local name = variable;
            local cvar_name = "asCompactRaidBuff_" .. variable;
            local tooltip = ""
            if ACRB_Options[variable] == nil then
                ACRB_Options[variable] = Options_Default[variable];
                ns.options[variable] = Options_Default[variable];
            end
            local defaultValue = Options_Default[variable];
            local currentValue = ACRB_Options[variable];

            if tonumber(defaultValue) ~= nil then
                local setting = Settings.RegisterAddOnSetting(category, cvar_name, variable, tempoption,
                    type(defaultValue),
                    name, defaultValue);
                local options = Settings.CreateSliderOptions(0, 3, 0.1);
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
