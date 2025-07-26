local _, ns = ...;
local Options_Default = {
    version = 250727,
    AlwaysOnMouse = false;
};

ns.options = CopyTable(Options_Default);

-- 파티일경우 Check할 Spell
-- Spell Name 와 쿨 Time을 초로 입력
ns.InterruptSpells = {
    [6552] = 15,            -- Pummel "들이치기"
    [1766] = 15,            -- Kick"발차기"
    [183752] = 15,          -- Disrupt "분열"
    [116705] = 15,          -- Spear Hand Strike "손날 찌르기"
    [47528] = 15,           -- Mind Freeze, "정신 얼리기"
    [187707] = 13,          -- Muzzle    "재갈"
    [147362] = 22,          -- Counter Shot "반격의 사격"
    [351338] = 20,          -- Quell "진압"
    [106839] = 15,          -- "Skull Bash "두개골 강타"
    [15487] = 45,           -- Silence 침묵
    [96231] = 15,           -- 성기사 비난
    [57994] = 12,           -- Wind Shear"날카로운 바람"
    [2139] = 24,            -- Counterspell     "마법 차단"
    [78675] = 60,           -- Solar Beam     "태양 광선"
    [89766] = 30,           --흑마 도끼 던지기
    [119914] = 30,           --흑마 도끼 던지기
    [19647]  = 24,           --흑마 주문 잠금
    [119910] = 24,          --흑마 주문 잠금

    --탱커 전용
    [31935] = 14,           -- 보기 응징의 방패
    [202137] = 90,          -- 침묵의 인장
};

ns.StunSpells = {
    [31661] = 45,       --마법사 용의 숨결
    [157980] = 45,      --마법사 초신성
    [157981] = 30,      --마법사 화염폭풍    
    [221562] = 45,      --죽기 어둠의 질식
    [49576] = 25,       --죽기 죽음의 손아귀
    [207167] = 60,      --죽기 눈부신 진눈깨비
    [853] = 30,         --기사 심판의 망치
    [115750] = 90,      --기사 눈부신 빛
    [8122] = 45,        --암사 영혼의 절규
    [2094] = 120,       --도적 실명
    [1776] = 25,        --도적 후려치기
    [408] = 35,         --도적 급소가격
    [51490] = 25,         --술사 천둥폭풍
    [192058] = 54,         --술사 축전토템
    [30283] = 60,         --흑마 어둠의 격노
    [6789] = 45,         --흑마 필멸의 고리
    [119381] = 50,         --수도사 팽이차기
    [116844] = 45,         --수도사 평화의 고리
    [107079] = 120,         --수도사 전율의 장풍
    [368970] = 180,         --기원사 꼬리 휘둘러 치기
    [357214] = 180,         --폭풍 날개
    [99] = 30,         --드루이드 행동불가의 표효
    [132469] = 30,         --드루이드 태풍
    [46968] = 40,         --전사 충격파
    [107570] = 30,         --전사 폭풍망치
    [462031] = 60,         --사냥꾼 내파덫
    [186387] = 30,         --사냥꾼 방출 사격
    [19577] = 55,         --사냥꾼 위협
    [179057] = 45,         --악사 혼도의 회오리
    [211881] = 30,         --악사 지옥분출
    [207684] = 90,         --악사 불행의 인장    
    
}

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
        AIH_Options[variable] = value;
        ns.options[variable] = value;
        ReloadUI();
    end

    local category = Settings.RegisterVerticalLayoutCategory("asInterruptHelper")



    if AIH_Options == nil or AIH_Options.version ~= Options_Default.version then
        AIH_Options = {};
        AIH_Options = CopyTable(Options_Default);
    end
    ns.options = CopyTable(AIH_Options);

    for variable, _ in pairs(Options_Default) do
        if variable ~= "version" then
            local name = variable;
            local cvar_name = "asInterruptHelper_" .. variable;
            local tooltip = ""
            if AIH_Options[variable] == nil then
                AIH_Options[variable] = Options_Default[variable];
                ns.options[variable] = Options_Default[variable];
            end
            local defaultValue = Options_Default[variable];
            local currentValue = AIH_Options[variable];

            local setting = Settings.RegisterAddOnSetting(category, cvar_name,  variable, tempoption, type(defaultValue), name, defaultValue);
            Settings.CreateCheckboxWithOptions(category, setting, nil, tooltip);
            Settings.SetValue(cvar_name, currentValue);
            Settings.SetOnValueChangedCallback(cvar_name, OnSettingChanged);
        end
    end

    Settings.RegisterAddOnCategory(category)
end


