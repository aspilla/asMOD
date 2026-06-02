local _, ns = ...;

ns.UpdateRate = 0.25; -- 1회 Update 주기 (초) 작으면 작을 수록 Frame Rate 감소 가능, 크면 Update 가 느림
ns.ACRB_HealerManaBarHeight = 4;

local Options_Default = {
    version = 251228,
    BottomHealerManaBar = true, -- 힐러 마나바
    BottomTankPowerBar = true,  -- 탱커 Power 바
    ShowMark = true,
    ShowLeader = true,
    BuffColor = true,
    --RemoveGroupText = true,
};


local L = {
    BottomHealerManaBar = "[Bottom] Displays the healer mana bar",
    BottomTankPowerBar = "[Bottom] Displays the tank power bar",
    ShowMark = "[Left] Displays the marker icon",
    ShowLeader = "[Top Left] Displays the party/raid leader icon",
    BuffColor = "[Color] Change health color when HOT buffed",
}


if GetLocale() == "koKR" then
    L = {
        BottomHealerManaBar = "[하단] 힐러 마나 표시",
        BottomTankPowerBar = "[하단] 탱커 파워 표시",
        ShowMark = "[좌측] 징표 아이콘을 표시",
        ShowLeader = "[좌상] 파티/공격대 리더 표시",
        BuffColor = "[색상] 힐러 HOT 버프시 색상 변경",
    }
end


ns.ACRB_ShowList_MONK_1 = {

}

ns.ACRB_ShowList_MONK_2 = {
    buffid = 119611, --소생의 안개	

}
ns.ACRB_ShowList_MONK_3 = {

}

-- 신기
ns.ACRB_ShowList_PALADIN_1 = {
    buffid = 200025, -- 고결의 봉화	

}

ns.ACRB_ShowList_PALADIN_2 = {

}

ns.ACRB_ShowList_PALADIN_3 = {

}

-- 수사
ns.ACRB_ShowList_PRIEST_1 = {
    buffid = 194384, -- 속죄	

}

-- 신사
ns.ACRB_ShowList_PRIEST_2 = {
    buffid = 139, -- 소생

}

ns.ACRB_ShowList_PRIEST_3 = {

}

ns.ACRB_ShowList_SHAMAN_1 = {

}

ns.ACRB_ShowList_SHAMAN_2 = {

}

ns.ACRB_ShowList_SHAMAN_3 = {
    buffid = 61295, --성난 해일

}

ns.ACRB_ShowList_DRUID_1 = {
    
}

ns.ACRB_ShowList_DRUID_2 = {
    
}

ns.ACRB_ShowList_DRUID_3 = {
    
}

ns.ACRB_ShowList_DRUID_4 = {

    buffid = 774, --회복			
    
}

ns.ACRB_ShowList_EVOKER_1 = {

}

ns.ACRB_ShowList_EVOKER_2 = {
    buffid = 364343, --메아리

}

ns.ACRB_ShowList_EVOKER_3 = {
    buffid = 410089, --예지

}

ns.ACRB_ShowList_WARRIOR_1 = {

}

ns.ACRB_ShowList_WARRIOR_2 = {

}

ns.ACRB_ShowList_WARRIOR_3 = {

}

ns.ACRB_ShowList_ROGUE_1 = {

}

ns.ACRB_ShowList_ROGUE_2 = {

}

ns.ACRB_ShowList_ROGUE_3 = {

}

ns.ACRB_ShowList_HUNTER_1 = {

}

ns.ACRB_ShowList_HUNTER_2 = {

}

ns.ACRB_ShowList_HUNTER_3 = {

}

ns.ACRB_ShowList_MAGE_1 = {

}

ns.ACRB_ShowList_MAGE_2 = {

}

ns.ACRB_ShowList_MAGE_3 = {

}

ns.ACRB_ShowList_WARLOCK_1 = {

}

ns.ACRB_ShowList_WARLOCK_2 = {

}

ns.ACRB_ShowList_WARLOCK_3 = {

}

ns.ACRB_ShowList_DEATHKNIGHT_1 = {

}

ns.ACRB_ShowList_DEATHKNIGHT_2 = {

}

ns.ACRB_ShowList_DEATHKNIGHT_3 = {

}

ns.ACRB_ShowList_DEMONHUNTER_1 = {

}

ns.ACRB_ShowList_DEMONHUNTER_2 = {

}

ns.ACRB_ShowList_DEMONHUNTER_3 = {

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
                    L[name], defaultValue);
                local options = Settings.CreateSliderOptions(0, 3, 0.1);
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
