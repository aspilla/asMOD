local _, ns = ...;
local Options_Default = {
    version = 240211,
    ShowPartyInterrupt = true, --파티 차단
    ShowPartyCool = true,      -- 파티 쿨다운
    ShowRaidCool = true,       -- 공격대 쿨다운
};

ns.options = CopyTable(Options_Default);

-- 파티일경우 Check할 Spell
-- Spell Name 와 쿨 Time을 초로 입력
ns.trackedPartySpellNames = {
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
    [119914] = 30,          --흑마 도끼 던지기
    [19647]  = 24,           --흑마 주문 잠금
    [119910] = 24,          --흑마 주문 잠금
};

ns.trackedCoolSpellNames = {
    WARRIOR_1 = {
        [107574] = { 90, 20 }           --투신
    },

    WARRIOR_2 = {
        [1719] = { 90, 12 }             --"무모한 희생"
    },

    WARRIOR_3 = {
        [401150] = { 90, 20 }          --투신
    },

    ROGUE_1 = {
        [360194] = { 120, 16 }          --"죽음표식"
    },

    ROGUE_2 = {
        [13750] = { 180, 20 }           --"아드레날린 촉진"
    },

    ROGUE_3 = {
        [121471] = { 90, 20 }           --"어둠의 칼날"
    },

    HUNTER_1 = {
        [359844] = { 120, 20 }          --"야생의 부름"
    },

    HUNTER_2 = {
        [288613] = { 120, 15 }          --"정조준"

    },

    HUNTER_3 = {
        [360952] = { 120, 20 }          --"협공"

    },

    MONK_1 = {
        [132578] = { 180, 25 }          --흑우 니우짜오의 원령
    },

    MONK_2 = {
        [325197] = { 60, 12 },          --"주학 츠지의 원령"
        [322118] = { 60, 12 }           --옥룡 위론의 원령
    },

    MONK_3 = {
        [123904] = { 120, 20 }          --백호 쉬엔의 원령
    },

    WARLOCK_1 = {
        [205180] = { 120, 20 }      --암흑시선 소환
    },

    WARLOCK_2 = {
        [111898] = { 120, 17 }      --지옥수호병
    },

    WARLOCK_3 = {
        [1122] = { 120, 30 }        --지옥불정령 소환
    },

    PRIEST_1 = {
        [10060] = { 120, 15 }       --마력 주입
    },

    PRIEST_2 = {
        [10060] = { 120, 15 }       --마력 주입
    },

    PRIEST_3 = {
        [10060] = { 120, 15 }       --마력 주입
    },

    SHAMAN_1 = {
        [198067] = { 150, 20 },
        [192249] = { 150, 20 },
    },

    SHAMAN_2 = {
        [114051] = { 120, 15 }
    },

    SHAMAN_3 = {
        [114052] = { 120, 15 }
    },

    DRUID_1 = {
        [194223] = { 90, 12 },
        [102560] = { 90, 16 },       

    },

    DRUID_2 = {
        [102543] = { 120, 20 },
        [106951] = { 120, 15 }

    },

    DRUID_3 = {
        [50334] = { 180, 15 },
        [102558] = { 180, 30 }

    },

    DRUID_4 = {
        [33891] = { 180, 30 },
        [391518] = { 60, 3 }        --"영혼 소집"

    },

    MAGE_1 = {
        [365350] = { 90, 15 }      --"비전 쇄도"
    },

    MAGE_2 = {
        [190319] = { 120, 12 }      --"발화"
    },

    MAGE_3 = {
        [12472] = { 120, 30 }     --"얼음 핏줄"

    },

    DEATHKNIGHT_1 = {
        [49028] = { 120, 8 }       --"춤추는 룬 무기"

    },

    DEATHKNIGHT_2 = {
        [47568] = { 120, 20 }       --"룬 무기 강화"
    },

    DEATHKNIGHT_3 = {
        [207289] = { 90, 20 }       --"부정의 습격"
    },

    EVOKER_1 = {
        [375087] = { 120, 18 }      --용의 분노
    },

    EVOKER_2 = {
        [363534] = { 240, 5 }       --되돌리기

    },

    EVOKER_3 = {

        [442204] = { 108, 11.5 }    --영겁의 숨결
    },

    PALADIN_1 = {
        [31884] = { 120, 20 },      --응징의 격노
        [216331] = { 60, 12 }       --응징의 성전사
    },

    PALADIN_2 = {
        [31884] = { 120, 25 },      --응징의 격노
        [389539] = { 120, 20 }      --파수꾼
    },

    PALADIN_3 = {
        [31884] = { 60, 20 }        --응징의 격노
    },

    DEMONHUNTER_1 = {
        [191427] = { 120, 20 }      --탈태
    },

    DEMONHUNTER_2 = {
        [187827] = { 120, 15 }       --탈태
    }
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
        ARDY_Options[variable] = value;
        ns.options[variable] = value;
        ReloadUI();
    end

    local category = Settings.RegisterVerticalLayoutCategory("asReady")



    if ARDY_Options == nil or ARDY_Options.version ~= Options_Default.version then
        ARDY_Options = {};
        ARDY_Options = CopyTable(Options_Default);
    end
    ns.options = CopyTable(ARDY_Options);

    for variable, _ in pairs(Options_Default) do
        if variable ~= "version" then
            local name = variable;
            local cvar_name = "asReady_" .. variable;
            local tooltip = ""
            if ARDY_Options[variable] == nil then
                ARDY_Options[variable] = Options_Default[variable];
                ns.options[variable] = Options_Default[variable];
            end
            local defaultValue = Options_Default[variable];
            local currentValue = ARDY_Options[variable];

            local setting = Settings.RegisterAddOnSetting(category, cvar_name,  variable, tempoption, type(defaultValue), name, defaultValue);
            Settings.CreateCheckboxWithOptions(category, setting, nil, tooltip);
            Settings.SetValue(cvar_name, currentValue);
            Settings.SetOnValueChangedCallback(cvar_name, OnSettingChanged);
        end
    end

    Settings.RegisterAddOnCategory(category)
end
