local _, ns = ...;
local Options_Default = {
    Version = 260725,
    ShowPortrait = true,
    ShowTotemBar = true,
    ShowBossBuff = true,
    ShowTargetBorder = true,
    ShowDebuff = true,
    HideBloodDebuff = true,
    ShowAggroInfo = true,
    CheckRange = true,
    CombatAlphaChange = true,
    ShowLowHealth = true,
    Width = 200,
    Height = 30,
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
    MillisecondsThreshold = 3,
};

ns.options = CopyTable(Options_Default);
local tempoption = {};

local L = {
    ShowPortrait = "Show portrait",
    ShowTotemBar = "Show totem bar",
    ShowBossBuff = "Show boss buffs (Max 4)",
    ShowTargetBorder = "Show target border on focus/boss",
    ShowDebuff = "Show debuff on pet/target of target",
    HideBloodDebuff = "Hide bloodlust debuffs",
    ShowAggroInfo = "Show aggro status and player rest state",
    CheckRange = "Check range with target/focus/boss",
    CombatAlphaChange = "Transparency change out of combat",
    ShowLowHealth = "Change health bar color for low health targets",
    Width = "Width",
    Height = "Height",
    PowerWidth = "Power bar width",
    PowerHeight = "Power bar height",
    FontSize = "Font size",
    FocusWidth = "Width",
    FocusHeight = "Height",
    FocusPowerWidth = "Power bar width",
    FocusPowerHeight = "Power bar height",
    FocusFontSize = "Font size",
    PetWidth = "Width",
    PetHeight = "Height",
    PetPowerWidth = "Power bar width",
    PetPowerHeight = "Power bar height",
    PetFontSize = "Font size",
    MillisecondsThreshold = "Milliseconds threshold (0.1s cooldown increments)",
}

local L_Headings = {
    General = "General Settings",
    PlayerTarget = "Player & Target Frame Size",
    FocusBoss = "Focus & Boss Frame Size",
    PetToT = "Pet & Target of Target Frame Size",
}

if GetLocale() == "koKR" then
    L = {
        ShowPortrait = "초상화 표시",
        ShowTotemBar = "플레이어 프레임 하단에 토템바 표시",
        ShowBossBuff = "보스 프레임 버프 표시 (최대 4개)",
        ShowTargetBorder = "주시/보스가 대상인 경우 하얀색 테두리 표시",
        ShowDebuff = "소환수/대상의대상 프레임에 디버프 표시",
        HideBloodDebuff = "블러드 디버프는 숨김",
        ShowAggroInfo = "어그로 및 플레이어 휴식 상태 표시",
        CheckRange = "대상/주시/보스와의 거리 체크",
        CombatAlphaChange = "비전투 시 투명도 변경",
        ShowLowHealth = "대상 낮은 체력 시 색상 변경",
        Width = "너비",
        Height = "높이",
        PowerWidth = "자원 바 너비",
        PowerHeight = "자원 바 높이",
        FontSize = "글자 크기",
        FocusWidth = "너비",
        FocusHeight = "높이",
        FocusPowerWidth = "자원 바 너비",
        FocusPowerHeight = "자원 바 높이",
        FocusFontSize = "글자 크기",
        PetWidth = "너비",
        PetHeight = "높이",
        PetPowerWidth = "자원 바 너비",
        PetPowerHeight = "자원 바 높이",
        PetFontSize = "글자 크기",
        MillisecondsThreshold = "남은 쿨을 0.1초 단위로 보여줄 최소 시간",
    }
    L_Headings = {
        General = "기본 설정",
        PlayerTarget = "플레이어 및 대상 크기 설정",
        FocusBoss = "주시 및 보스 크기 설정",
        PetToT = "소환수 및 대상의 대상 크기 설정",
    }
end

local Option_Sections = {
    {
        Header = "General",
        Variables = {
            "ShowPortrait",
            "ShowTotemBar",
            "ShowBossBuff",
            "ShowTargetBorder",
            "ShowDebuff",
            "HideBloodDebuff",
            "ShowAggroInfo",
            "CheckRange",
            "CombatAlphaChange",
            "ShowLowHealth",
            "MillisecondsThreshold",
        }
    },
    {
        Header = "PlayerTarget",
        Variables = {
            "Width",
            "Height",
            "PowerWidth",
            "PowerHeight",
            "FontSize",
        }
    },
    {
        Header = "FocusBoss",
        Variables = {
            "FocusWidth",
            "FocusHeight",
            "FocusPowerWidth",
            "FocusPowerHeight",
            "FocusFontSize",
        }
    },
    {
        Header = "PetToT",
        Variables = {
            "PetWidth",
            "PetHeight",
            "PetPowerWidth",
            "PetPowerHeight",
            "PetFontSize",
        }
    }
}


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

    local category, layout = Settings.RegisterVerticalLayoutCategory("asUnitFrame")

    if AUF_Options == nil or Options_Default.Version ~= AUF_Options.Version then
        AUF_Options = {};
        AUF_Options = CopyTable(Options_Default);
        AUF_Positions = nil;
    end

    if AUF_Positions == nil then
        AUF_Positions = {};
        AUF_Positions.PlayerFrame = {};
        AUF_Positions.TargetFrame = {};
        AUF_Positions.FocusFrame = {};
        AUF_Positions.PetFrame = {};
        AUF_Positions.TargetTargetFrame = {};
        AUF_Positions.FocusTargetFrame = {};

        AUF_Positions.BossFrames = {};
        if (MAX_BOSS_FRAMES) then
            for i = 1, MAX_BOSS_FRAMES do
                AUF_Positions.BossFrames[i] = {};
            end
        end
    end

    for variable, _ in pairs(Options_Default) do
        if variable ~= "Version" then
            if AUF_Options[variable] == nil  then
                AUF_Options[variable] = Options_Default[variable];
                ns.options[variable] = Options_Default[variable];
            end
        end
    end

    ns.options = CopyTable(AUF_Options);

    for _, section in ipairs(Option_Sections) do
        local headingText = L_Headings[section.Header];
        if layout and CreateSettingsListSectionHeaderInitializer then
            layout:AddInitializer(CreateSettingsListSectionHeaderInitializer(headingText));
        end

        for _, variable in ipairs(section.Variables) do
            local name = variable;
            local cvar_name = "asUnitFrame_" .. variable;
            local tooltip = ""
            local defaultValue = Options_Default[variable];
            local currentValue = AUF_Options[variable];

            if name == "MillisecondsThreshold" then
				local setting = Settings.RegisterAddOnSetting(category, cvar_name, variable, tempoption,
					type(defaultValue), L[name], defaultValue);
				local options = Settings.CreateSliderOptions(0, 10, 1);
				options:SetLabelFormatter(MinimalSliderWithSteppersMixin.Label.Right);
				Settings.CreateSlider(category, setting, options, tooltip);
				Settings.SetValue(cvar_name, currentValue);
				Settings.SetOnValueChangedCallback(cvar_name, OnSettingChanged);

            elseif tonumber(defaultValue) ~= nil then
                local setting = Settings.RegisterAddOnSetting(category, cvar_name,  variable, tempoption, type(defaultValue), L[name], defaultValue);
                local options = Settings.CreateSliderOptions(0, 400, 1);
                options:SetLabelFormatter(MinimalSliderWithSteppersMixin.Label.Right);
                Settings.CreateSlider(category, setting, options, tooltip);
                Settings.SetValue(cvar_name, currentValue);
                Settings.SetOnValueChangedCallback(cvar_name, OnSettingChanged);
            else
                local setting = Settings.RegisterAddOnSetting(category, cvar_name,  variable, tempoption, type(defaultValue), L[name], defaultValue);

                Settings.CreateCheckboxWithOptions(category, setting, nil, tooltip);
                Settings.SetValue(cvar_name, currentValue);
                Settings.SetOnValueChangedCallback(cvar_name, OnSettingChanged);
            end
        end
    end

    Settings.RegisterAddOnCategory(category)
end
