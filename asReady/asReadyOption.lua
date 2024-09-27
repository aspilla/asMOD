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
    ["들이치기"] = 15, -- Pummel
    ["발차기"] = 15, -- Kick
    ["분열"] = 15, -- Disrupt
    ["손날 찌르기"] = 15, -- Spear Hand Strike
    ["정신 얼리기"] = 15, -- Mind Freeze
    ["재갈"] = 15, -- Muzzle
    ["반격의 사격"] = 24, -- Counter Shot
    ["진압"] = 20, -- Quell
    ["두개골 강타"] = 15, -- "Skull Bash
    ["침묵"] = 45, -- Silence
    ["비난"] = 15, -- Rebuke
    ["날카로운 바람"] = 12, -- Wind Shear
    ["마법 차단"] = 24, -- Counterspell
    ["태양 광선"] = 60, -- Solar Beam
    ["도끼 던지기"] = 30,
    ["주문 잠금"] = 24
};

ns.trackedCoolSpellNames = {
    WARRIOR_1 = {
        ["투신"] = { 90, 20 }
    },

    WARRIOR_2 = {
        ["무모한 희생"] = { 90, 12 }
    },

    WARRIOR_3 = {
        ["투신"] = { 120, 20 }
    },

    ROGUE_1 = {
        ["죽음표식"] = { 120, 16 }
    },

    ROGUE_2 = {
        ["아드레날린 촉진"] = { 180, 20 }
    },

    ROGUE_3 = {
        ["어둠의 칼날"] = { 120, 20 }
    },

    HUNTER_1 = {
        ["야생의 부름"] = { 120, 20 }
    },

    HUNTER_2 = {
        ["정조준"] = { 120, 18 }

    },

    HUNTER_3 = {
        ["협공"] = { 120, 20 }

    },

    MONK_1 = {
        ["흑우 니우짜오의 원령"] = { 180, 25 }
    },

    MONK_2 = {
        ["주학 츠지의 원령"] = { 60, 12 },
        ["옥룡 위론의 원령"] = { 60, 12 }
    },

    MONK_3 = {
        ["백호 쉬엔의 원령"] = { 120, 20 }
    },

    WARLOCK_1 = {
        ["암흑시선 소환"] = { 120, 30 }
    },

    WARLOCK_2 = {
        [111898] = { 120, 17 }
    },

    WARLOCK_3 = {
        ["지옥불정령 소환"] = { 120, 30 }
    },

    PRIEST_1 = {
        ["마력 주입"] = { 120, 15 }
    },

    PRIEST_2 = {
        ["마력 주입"] = { 120, 15 }
    },

    PRIEST_3 = {
        ["마력 주입"] = { 120, 15 }
    },

    SHAMAN_1 = {
        [198067] = { 150, 36 },
        [192249] = { 150, 36 },
    },

    SHAMAN_2 = {
        [114051] = { 180, 15 }
    },

    SHAMAN_3 = {
        [114052] = { 180, 15 }
    },

    DRUID_1 = {
        [194223] = { 180, 20 },
        [102560] = { 180, 30 },
        [390414] = { 180, 20 },

    },

    DRUID_2 = {
        [102543] = { 180, 30 },
        [106951] = { 180, 20 }

    },

    DRUID_3 = {
        [102558] = { 180, 30 }

    },

    DRUID_4 = {
        [33891] = { 180, 30 },
        ["영혼 소집"] = { 60, 3 }

    },

    MAGE_1 = {
        ["비전 쇄도"] = { 90, 18 }
    },

    MAGE_2 = {
        ["발화"] = { 120, 12 }
    },

    MAGE_3 = {
        ["얼음 핏줄"] = { 120, 30 }

    },

    DEATHKNIGHT_1 = {
        ["춤추는 룬 무기"] = { 120, 16 }

    },

    DEATHKNIGHT_2 = {
        ["얼음 기둥"] = { 60, 12 }
    },

    DEATHKNIGHT_3 = {
        ["부정의 습격"] = { 90, 20 }
    },

    EVOKER_1 = {
        ["용의 분노"] = { 120, 18 }
    },

    EVOKER_2 = {
        ["되돌리기"] = { 180, 5 }

    },

    EVOKER_3 = {

        ["영겁의 숨결"] = { 108, 11.5 }
    },

    PALADIN_1 = {
        [31884] = { 120, 20 },
        ["응징의 성전사"] = { 60, 12 }
    },

    PALADIN_2 = {
        [31884] = { 120, 25 },
        ["파수꾼"] = { 120, 25 }
    },

    PALADIN_3 = {
        [31884] = { 60, 20 }
    },

    DEMONHUNTER_1 = {
        [191427] = { 120, 20 }
    },

    DEMONHUNTER_2 = {
        ["탈태"] = { 120, 15 }
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
            local defaultValue = ARDY_Options[variable];

            local setting = Settings.RegisterAddOnSetting(category, cvar_name,  variable, tempoption, type(defaultValue), name, defaultValue);
            Settings.CreateCheckboxWithOptions(category, setting, nil, tooltip)
            Settings.SetOnValueChangedCallback(cvar_name, OnSettingChanged)
        end
    end

    Settings.RegisterAddOnCategory(category)
end
