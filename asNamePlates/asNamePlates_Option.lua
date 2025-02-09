local _, ns = ...;

---설정부
ns.ANameP_SIZE = 0;                  -- Icon Size 0 이면 자동으로 설정
ns.ANameP_Size_Rate = 0.6;           -- Icon 가로 세로 비중
ns.ANameP_PVP_Debuff_Size_Rate = 4   -- PVP Debuff Icon Size 작게 하려면 - 값으로

ns.ANameP_PlayerBuffY = -5           -- Player 바 Buff 위치
ns.ANameP_TargetBuffY = 5            -- 대상바 Buff 위치
ns.ANameP_CooldownFontSize = 9;      --재사용 대기시간 Font Size
ns.ANameP_CountFontSize = 8;         --Count 폰트 Size
ns.ANameP_MaxDebuff = 8;             --최대 Debuff
ns.ANameP_DebuffsPerLine = 4;        --줄당 Debuff 수 (큰 이름표 일 경우 +1 됨)
ns.ANameP_MaxBuff = 1;               --최대 PVP Buff (안보이게 하려면 0)
ns.ANameP_ShowPlayerBuff = true;     --Player NamePlate에 Buff를 안보일려면 false;
ns.ANameP_BuffMaxCool = 60;          --buff의 최대 Cool
ns.ANameP_PVPAggroShow = true;       -- PVP 어그로 여부를 표현할지 여부
ns.ANameP_ShowCCDebuff = true        -- 오른쪽에 CC Debuff만 별도로 보이기
ns.ANameP_CCDebuffSize = 22          -- CC Debuff Size;
ns.ANameP_AggroSize = 12;            -- 어그로 표시 Text Size
ns.ANameP_HealerSize = 14;           -- 힐러표시 Text Size
ns.ANameP_TargetHealthBarHeight = 3; -- 대상 체력바 높이 증가치 (+3)
ns.ANameP_HeathTextSize = 8;         -- 대상 체력숫자 크기
ns.ANameP_UpdateRate = 0.5;          -- 버프 Check 반복 시간 (초)
ns.ANameP_UpdateRateTarget = 0.3;    -- 대상의 버프 Check 반복 시간 (초)


-- 아래 유닛명이면 강조
-- 색상 지정 가능
-- { r, g, b, 빤작임 여부}
ns.ANameP_AlertList = {
    ["폭발물"] = { 1, 1, 0.2, 1 }, -- 노란색 빤짝이
    ["무형의 존재"] = { 1, 1, 0.2, 0 }, -- 노란색 빤짝이 (없음)
    ["경화된 수정"] = { 1, 1, 0.2, 1 }, -- 노란색 빤짝이
    ["원한의 망령"] = { 1, 1, 0.2, 0 }, -- 노란색 빤짝이 (없음)
    --["레프티 수호병"] = { 0.2, 0.2, 0.2, 0 }, -- 노란색 빤짝이 (없음)
    --["바위주먹"] = { 1, 1, 0.2, 0 }, -- 노란색 빤짝이 (없음)
    --["절단 훈련용 허수아비"] = { 0.5, 0.5, 0.5, 0 }, -- 검은색 빤짝이 (없음)
    --["쉬바라"] = {0, 1, 0.5, 1},	 -- 녹색 빤짝이
    --["우르줄"] = {0, 1, 0.5, 1},	 -- 녹색 빤짝이
    --["파멸수호병"] = {0, 1, 0.5, 1},	 -- 녹색 빤짝이
    --["격노수호병"] = {0, 1, 0.5, 1},	 -- 녹색 빤짝이
    --["지옥불정령"] = {0, 1, 0.5, 1},	 -- 녹색 빤짝이
    --["지옥사냥개"] = {0, 1, 0.5, 1},	 -- 녹색 빤짝이

}


-- 안보이게 할 디법
ns.ANameP_BlackList = {
    --	["상처 감염 독"] = 1,	
    --	["맹독"] = 1,
    --	["약자 고문"] = 1,
    --	["슬픔"] = 1,
    --	["순환하는 기원"] = 1,
    [206151] = 1, --"도전자의 짐"
    [206150] = 1, --"도전자의 힘"

}

-- 안보이게 할 디법 (다른 케릭)
ns.ANameP_ShowOnlyMine = {
    [447513] = 1, --만신창이 (전사)
    [445584] = 1, --사형선고 (전사)
    [434473] = 1, --폭격 (기원사)
}

ns.ANameP_PVPBuffList = {
    -- 종특	
    [65116]  = 1, --석화

    [118038] = 1, --WARRIOR
    [23920]  = 1, --WARRIOR
    [12975]  = 1, --WARRIOR
    [1160]   = 1, --WARRIOR
    [18499]  = 1, --WARRIOR
    [871]    = 1, --WARRIOR
    [97463]  = 1, --WARRIOR
    [184364] = 1, --WARRIOR
    [386394] = 1, --WARRIOR
    [392966] = 1, --WARRIOR
    [213915] = 1, --WARRIOR
    [147833] = 1, --WARRIOR
    [386208] = 2, --WARRIOR 방어태세 딜러/힐러만

    [185311] = 1, --ROGUE
    [11327]  = 1, --ROGUE
    [1966]   = 1, --ROGUE
    [31224]  = 1, --ROGUE
    [31230]  = 1, --ROGUE
    [5277]   = 1, --ROGUE
    [199754] = 1, --ROGUE
    [45182]  = 1, --ROGUE

    [212800] = 1, --DEMONHUNTER
    [187827] = 1, --DEMONHUNTER
    [206803] = 1, --DEMONHUNTER
    [196555] = 1, --DEMONHUNTER
    [263648] = 1, --DEMONHUNTER
    [209426] = 1, --DEMONHUNTER
    [198589] = 1, --DEMONHUNTER

    [202162] = 1, --MONK
    [388615] = 1, --MONK
    [116849] = 1, --MONK
    [322507] = 1, --MONK
    [120954] = 1, --MONK
    [122783] = 1, --MONK
    [122278] = 1, --MONK
    [132578] = 1, --MONK
    [115176] = 1, --MONK
    [122470] = 1, --MONK
    [125174] = 1, --MONK
    [198065] = 1, --MONK
    [201318] = 1, --MONK
    [353319] = 1, --MONK


    [49039]  = 1, --DEATHKNIGHT
    [48707]  = 1, --DEATHKNIGHT
    [48743]  = 1, --DEATHKNIGHT
    [48792]  = 1, --DEATHKNIGHT
    [114556] = 1, --DEATHKNIGHT
    [81256]  = 1, --DEATHKNIGHT
    [219809] = 1, --DEATHKNIGHT
    [206931] = 1, --DEATHKNIGHT
    [194679] = 1, --DEATHKNIGHT
    [55233]  = 1, --DEATHKNIGHT
    [145629] = 1, --DEATHKNIGHT
    [410358] = 1, --DEATHKNIGHT
    [454863] = 1, --DEATHKNIGHT

    -- 사냥꾼 내부전쟁
    [392956] = 1, --HUNTER
    [53480]  = 1, --HUNTER	
    [264735] = 1, --HUNTER
    [186265] = 1, --HUNTER
    [459470] = 1, --HUNTER
    [202748] = 1, --HUNTER

    [355913] = 1, --EVOKER
    [370960] = 1, --EVOKER
    [363534] = 1, --EVOKER
    [357170] = 1, --EVOKER
    [374348] = 1, --EVOKER
    [374227] = 1, --EVOKER
    [363916] = 1, --EVOKER
    [360827] = 1, --EVOKER
    [404381] = 1, --EVOKER
    [378441] = 1, --EVOKER
    [378464] = 1, --EVOKER
    [373267] = 1, --EVOKER

    [305497] = 1, --DRUID
    [354654] = 1, --DRUID
    [201664] = 1, --DRUID
    [157982] = 1, --DRUID
    [102342] = 1, --DRUID
    [61336]  = 1, --DRUID
    [200851] = 1, --DRUID
    [80313]  = 1, --DRUID
    [108238] = 1, --DRUID
    [124974] = 1, --DRUID
    [22812]  = 1, --DRUID
    [5487]   = 2, --DRUID 곰변신 (딜러/힐러만)


    [104773] = 1, --WARLOCK
    [108416] = 1, --WARLOCK
    [212295] = 1, --WARLOCK


    [215769] = 1, --PRIEST
    [328530] = 1, --PRIEST
    [197268] = 1, --PRIEST
    [19236]  = 1, --PRIEST
    [81782]  = 1, --PRIEST
    [33206]  = 1, --PRIEST
    [372835] = 1, --PRIEST
    [391124] = 1, --PRIEST
    [265202] = 1, --PRIEST
    [64843]  = 1, --PRIEST
    [47788]  = 1, --PRIEST
    [47585]  = 1, --PRIEST
    [108968] = 1, --PRIEST
    [15286]  = 1, --PRIEST
    [271466] = 1, --PRIEST
    [586]    = 1, --PRIEST
    [27827]  = 1, --PRIEST
    [232707] = 1, --PRIEST
    [421453] = 1, --PRIEST
    [232708] = 1, --PRIEST

    [199452] = 1, --PALADIN
    [403876] = 1, --PALADIN
    [31850]  = 1, --PALADIN
    [378279] = 1, --PALADIN
    [378974] = 1, --PALADIN
    [86659]  = 1, --PALADIN
    [387174] = 1, --PALADIN
    [327193] = 1, --PALADIN
    [205191] = 1, --PALADIN
    [184662] = 1, --PALADIN
    [498]    = 1, --PALADIN
    [148039] = 1, --PALADIN
    [157047] = 1, --PALADIN
    [31821]  = 1, --PALADIN
    [633]    = 1, --PALADIN
    [6940]   = 1, --PALADIN
    [1022]   = 1, --PALADIN
    [204018] = 1, --PALADIN
    [228049] = 1, --PALADIN
    [642]    = 1, --PALADIN

    [204331] = 1, --SHAMAN
    [108280] = 1, --SHAMAN
    [98008]  = 1, --SHAMAN
    [198838] = 1, --SHAMAN
    [207399] = 1, --SHAMAN
    [108271] = 1, --SHAMAN
    [198103] = 1, --SHAMAN
    [30884]  = 1, --SHAMAN
    [383017] = 1, --SHAMAN
    [108281] = 1, --SHAMAN
    [462844] = 1, --SHAMAN
    [409293] = 1, --SHAMAN
    [98007]  = 1, --SHAMAN
    [204288] = 1, --SHAMAN
    [201633] = 1, --SHAMAN
    [325174] = 1, --SHAMAN
    [260881] = 1, --SHAMAN

    -- 마법사 내부전쟁
    [45438]  = 1, --MAGE 얼음 방패
    [113862] = 1, --MAGE 상투
    [414658] = 1, --MAGE 얼음장
    [342246] = 1, --MAGE 시돌
    [11426]  = 1, --MAGE 얼보
    [235313] = 1, --MAGE 이글거리는 방벽
    [235450] = 1, --MAGE 오색 방벽
    [55342]  = 1, --MAGE 환영 복제
    [414661] = 1, --MAGE 얼보 (대규모)
    [414662] = 1, --MAGE 이글 (대규모)
    [414663] = 1, --MAGE 오색 (대규모)
    [414664] = 1, --MAGE 대규모 투명화
    [86949]  = 1, --MAGE 소작
}

ns.ANameP_HealSpellList = {};

ns.ANameP_HealSpellList["사제"] = {

    [047540] = "PRIEST", -- Penance XXX strange error received from user on 2015-10-15 (this spell was cast by a hunter...)
    [109964] = "PRIEST", -- Spirit shell -- not seen in disc
    [002060] = "PRIEST", -- Greater Heal
    [014914] = "PRIEST", -- Holy Fire
    [033206] = "PRIEST", -- Pain Suppression
    [000596] = "PRIEST", -- Prayer of Healing
    [000527] = "PRIEST", -- Purify
    [081749] = "PRIEST", -- Atonement
    [132157] = "PRIEST", -- Holy Nova
    [034861] = "PRIEST", -- Circle of Healing
    [064843] = "PRIEST", -- Divine Hymn
    [047788] = "PRIEST", -- Guardian Spirit
    [032546] = "PRIEST", -- Binding Heal
    [077485] = "PRIEST", -- Mastery: Echo of Light -- the passibe ability
    [077489] = "PRIEST", -- Echo of Light -- the aura applied by the afformentioned
    [000139] = "PRIEST", -- Renew

};

ns.ANameP_HealSpellList["드루이드"] = {

    [102342] = "DRUID", -- Ironbark
    [033763] = "DRUID", -- Lifebloom
    [088423] = "DRUID", -- Nature's Cure
    [033891] = "DRUID", -- Incarnation: Tree of Life
    [048438] = "DRUID", -- Wild Growth
    [000740] = "DRUID", -- Tranquility
};


ns.ANameP_HealSpellList["주술사"] = {

    [061295] = "SHAMAN", -- Riptide
    [077472] = "SHAMAN", -- Healing Wave
    [098008] = "SHAMAN", -- Spirit link totem
    [001064] = "SHAMAN", -- Chain Heal
    [073920] = "SHAMAN", -- Healing Rain

};

ns.ANameP_HealSpellList["성기사"] = {

    [020473] = "PALADIN", -- Holy Shock
    [053563] = "PALADIN", -- Beacon of Light
    [082326] = "PALADIN", -- Holy Light
    [085222] = "PALADIN", -- Light of Dawn
};


ns.ANameP_HealSpellList["수도사"] = {
    [115175] = "MONK", -- Soothing Mist
    [115310] = "MONK", -- Revival
    [116670] = "MONK", -- Vivify
    [116680] = "MONK", -- Thunder Focus Tea
    [116849] = "MONK", -- Life Cocoon
    [119611] = "MONK", -- Renewing mist

};

ns.ANameP_HealSpellList["기원사"] = {
    [355936] = "EVOKER", -- 꿈의 숨결
    [364446] = "EVOKER", -- 메아리
    [366155] = "EVOKER", -- 되감기
    [367226] = "EVOKER", -- 영혼 만개

};



ANameP_Options_Default = {
    version = 250203,
    ANameP_ShowKnownSpell = false,                            -- [디버프] 기본 + 사용 가능 스킬 디버프 추가
    ANameP_ShowMyAll = false,                                 -- [디버프] 전부 보이기
    ANameP_ShowListOnly = false,                              -- [디버프] List 만 보이기
    ANameP_ShowPlayerBuffAll = false,                         -- [버프] 전부 보이기
    ANameP_AggroShow = true,                                  -- 어그로 여부를 표현할지 여부
    ANameP_LowHealthAlert = true,                             -- 낮은 체력 색상 변경 사용
    ANameP_QuestAlert = true,                                 -- Quest 몹 색상 변경 사용
    ANameP_AutoMarker = true,                                 -- AutoMarker 몹 색상 변경 사용
    ANameP_Tooltip = true,                                    -- Tooltip 표시
    ANameP_ShowDBM = true,                                    -- DBM Cooldown을 표시
    ANameP_ShowDBMCastingColor = true,                        -- DBM CastingColor을 표시
    ANameP_ShortFriendNP = true,                              -- 아군 체력바 크기 조정
    ANameP_RealHealth = true,                                 -- 체력 수치 표시
    ANameP_ShowPetTarget = true,                              -- Pet 대상 표시
    ANameP_ShowTargetArrow = false,                           -- 대상 빨간 화살표 표시
    ANameP_DebuffAnchorPoint = 1,                             -- Debuff 표시 위치 1 Top, 2 Right, 3 Hide

    ANameP_AggroTargetColor = { r = 0.4, g = 0.2, b = 0.8 },  -- PVE 대상이 player 였을때 Color
    ANameP_AggroColor = { r = 0.5, g = 1, b = 1 },            -- 어그로 대상일때 바 Color
    ANameP_TankAggroLoseColor = { r = 1, g = 0.5, b = 0.5 },  -- 탱커일때 어그로가 다른 탱커가 아닌사람일때
    ANameP_TankAggroLoseColor2 = { r = 1, g = 0.1, b = 0.5 }, -- 어그로가 파티내 다른 탱커일때
    ANameP_TankAggroLoseColor3 = { r = 0.1, g = 0.3, b = 1 }, -- 어그로가 Pet 일때 혹은 Tanking 중인데 어그로가 낮을때
    ANameP_LowHealthColor = { r = 1, g = 0.8, b = 0.5 },      -- 낮은 체력 이름표 색상 변경
    ANameP_DebuffColor = { r = 1, g = 0.5, b = 0 },           -- 디버프 걸렸을때 Color
    ANameP_DebuffColor2 = { r = 0, g = 0.5, b = 1 },          -- 디버프 걸렸을때 Color
    ANameP_DebuffColor3 = { r = 1, g = 0.5, b = 1 },          -- 디버프 걸렸을때 Color
    ANameP_QuestColor = { r = 1, g = 0.8, b = 0.5 },          -- Quest 몹 Color
    ANameP_AutoMarkerColor = { r = 0.5, g = 1, b = 0.5 },     -- AutoMarker 몹 Color
    ANameP_AutoMarkerColor2 = { r = 1, g = 1, b = 0.2 },      -- AutoMarker 몹 Color2

    nameplateOverlapV = 1.0,                                  -- 이름표 상하 정렬



    -- ANameP_ShowList_직업_특성 숫자
    -- 아래와 같은 배열을 추가 하면 된다.
    -- ["디법명"] = {알림 시간, 우선순위, 색상 변경 여부},
    -- 우선순위는 숫자가 큰 경우 우선적으로 보이고, 같을 경우 먼저 걸린 순서로 보임
    ANameP_ShowList_WARRIOR_1 = {
        [445584] = { 0, 5, 2 }, --사형 선고됨
        [447513] = { 0, 4, 2 }, --만신창이
        [388539] = { 1, 3, 1 }, --분쇄
    },

    ANameP_ShowList_WARRIOR_2 = {
        [445584] = { 0, 5, 1 }, --사형 선고됨
    },

    ANameP_ShowList_WARRIOR_3 = {
        [447513] = { 0, 5 }, --만신창이
        [388539] = { 1, 4 }, --분쇄
    },

    ANameP_ShowList_ROGUE_1 = {
        [457129] = { 0, 5 },              --죽음추적자의 징표
        [703] = { 1, 4, 2, false, true }, --목조르기
        [1943] = { 24 * 0.3, 3, 1 },      --파열
        [121411] = { 12 * 0.3, 2 },       --혈폭풍

    },

    ANameP_ShowList_ROGUE_2 = {
        [196937] = { 0, 5, 1 }, --유령의 일격
        [441224] = { 0, 4, 2 }, --당혹 상태
    },

    ANameP_ShowList_ROGUE_3 = {
        [457129] = { 0, 5, 2 },      --죽음추적자의 징표
        [1943] = { 24 * 0.3, 4, 1 }, --파열
        [441224] = { 0, 3, 2 },      --당혹 상태
    },


    ANameP_ShowList_HUNTER_1 = {
        [468572] = { 0, 5 },    --검은 화살
        [217200] = { 1, 4, 1 }, --날카로운 사격
        [271788] = { 0, 3 },    --독사 쐐기
        [131894] = { 0, 2 },    --저승까마귀
        [257284] = { 0, 1 },    --사냥꾼의 징표
    },

    ANameP_ShowList_HUNTER_2 = {
        [468572] = { 0, 5, 2 }, --검은 화살
        [271788] = { 1, 4, 1 }, --독사 쐐기
        [450387] = { 0, 3 },    --파수꾼
        [257284] = { 0, 2 },    --사냥꾼의 징표

    },

    ANameP_ShowList_HUNTER_3 = {
        [259491] = { 1, 5, 1 }, --독사 쐐기
        [450387] = { 0, 4 },    --파수꾼
        [257284] = { 0, 3 },    --사냥꾼의 징표

    },

    ANameP_ShowList_MONK_1 = {
        [387179] = { 0, 5 }, --질서의 무기
    },

    ANameP_ShowList_MONK_2 = {
    },

    ANameP_ShowList_MONK_3 = {
        [228287] = { 0, 5, 1 }, --주학의 징표
    },

    ANameP_ShowList_WARLOCK_1 = {
        [980] = { 1, 5, 1 },    --고통
        [316099] = { 1, 4 },    --불안정한 고통
        [146739] = { 1, 3, 2 }, --부패
        [445474] = { 1, 2, 2 }, --쇠퇴
    },

    ANameP_ShowList_WARLOCK_2 = {
        [460553] = { 0, 5, 2 }, --파멸
        [270569] = { 0, 4, 1 }, --악의 아귀
    },


    ANameP_ShowList_WARLOCK_3 = {
        [157736] = { 1, 5, 1 }, --제물
        [445474] = { 1, 4, 1 }, --쇠퇴

    },


    ANameP_ShowList_PRIEST_1 = {
        [204213] = { 1, 5, 1 }, --사악의 정화
        [589] = { 1, 4, 1 },    --고통
    },

    ANameP_ShowList_PRIEST_2 = {
        [14914] = { 0, 5, 1 }, --신충
        [589] = { 1, 4, 2 },   --고통
    },


    ANameP_ShowList_PRIEST_3 = {
        [589] = { 1, 5, 1 },    --고통
        [34914] = { 0, 4 },     --흡선
        [335467] = { 0, 3, 2 }, --파멸
        [453850] = { 0, 2 },    --공명
    },

    ANameP_ShowList_SHAMAN_1 = {
        [188389] = { 18 * 0.3, 5, 1 }, --화염 충격
        [197209] = { 0, 4, 2 },        --피뢰침
    },

    ANameP_ShowList_SHAMAN_2 = {
        [334168] = { 0, 5, 2 },        --채찍 화염
        [188389] = { 18 * 0.3, 4, 1 }, --화염 충격
        [197209] = { 0, 3, 2 },        --피뢰침
    },

    ANameP_ShowList_SHAMAN_3 = {
        [188389] = { 18 * 0.31, 5, 1 }, --화염 충격
    },


    ANameP_ShowList_DRUID_1 = {
        [164812] = { 1, 5, 1 }, --달빛섬광
        [164815] = { 1, 4, 2 }, --태양섬광
        [202347] = { 1, 3 },    --항성의 섬광
        [430589] = { 0, 2 },    --기후 노출
    },


    ANameP_ShowList_DRUID_2 = {
        [155722] = { 12 * 0.3, 5, 1, false, true }, --갈퀴 발톱
        [155625] = { 1, 4, 2, false, true },        --달빛섬광
        [391889] = { 1, 3 },                        --적응의 무리
        [1079] = { 19 * 0.3, 2, nil, false, true }, --도려내기
        [405233] = { 0, 1, nil, false, true },      --Trash

    },

    ANameP_ShowList_DRUID_3 = {
        [164812] = { 1, 5 }, --달빛섬광
        [192090] = { 0, 4 }, --난타
        [430589] = { 0, 3 }, --기후 노출
    },


    ANameP_ShowList_DRUID_4 = {
        [164812] = { 1, 5, 1 },        --달빛섬광
        [155722] = { 12 * 0.3, 4, 2 }, --갈퀴 발톱
        [164815] = { 1, 3 },           --태양섬광
        [1079] = { 19 * 0.3, 2 },      --도려내기
        [439531] = { 0, 1 },           --피바라미 덩굴
    },


    ANameP_ShowList_MAGE_1 = {
        [210824] = { 0, 5, 1 }, --비전의 여파
        [453599] = { 0, 4 },    --비전 쇠약
        [444735] = { 0, 3 },    --박힌 쐐편 파편
    },

    ANameP_ShowList_MAGE_2 = {
        [453268] = { 0, 5, 1 }, --파괴 제어
        [12654] = { 0, 4 },     --작열
    },

    ANameP_ShowList_MAGE_3 = {
        [228358] = { 0, 5, 1 }, -- 혹한의 추위
        [443740] = { 0, 4 },    --박힌 냉기 파편
        [122] = { 0, 3, 2 },
        [136511] = { 0, 3, 2 },
        [33395] = { 0, 3, 2 },
        [157997] = { 0, 3, 2 },
        [378760] = { 0, 3, 2 }, --냉증
        [228600] = { 0, 3, 2 }, --혹한의 쐐기
    },


    ANameP_ShowList_DEATHKNIGHT_1 = {
        [434765] = { 0, 5, 1 }, --사신의 징표
        [458478] = { 0, 4 },    --공포 유발
        [55078] = { 0, 3 },     --피의 역병

    },

    ANameP_ShowList_DEATHKNIGHT_2 = {
        [434765] = { 0, 5, 1 }, --사신의 징표
        [55095] = { 0, 4 },     --서리 열병
    },

    ANameP_ShowList_DEATHKNIGHT_3 = {
        [458478] = { 0, 5, 2 }, --공포 유발
        [194310] = { 0, 4 },    --고름 상처
        [191587] = { 1, 3, 1 }, --악성 역병

    },


    ANameP_ShowList_EVOKER_1 = {
        [357209] = { 0, 5, 1 }, --불의 숨결
        [434473] = { 0, 4 },    --폭격
    },

    ANameP_ShowList_EVOKER_2 = {
        [357209] = { 0, 5, 1 }, --불의 숨결

    },

    ANameP_ShowList_EVOKER_3 = {
        [409560] = { 0, 5, 1 }, --시간의 상처
        [357209] = { 0, 4, 2 }, --불의 숨결
        [434473] = { 0, 3 },    --폭격
    },


    ANameP_ShowList_PALADIN_1 = {
        [414022] = { 0, 5, 1 }, --무가치한 존재
    },

    ANameP_ShowList_PALADIN_2 = {
        [197277] = { 0, 5 }, --심판
    },

    ANameP_ShowList_PALADIN_3 = {
        [197277] = { 0, 5, 1 }, --심판
    },

    ANameP_ShowList_DEMONHUNTER_1 = {
        [442624] = { 0, 5, 2 }, --파괴자의 징표
        [391191] = { 0, 4, 1 }, --불타는 상처

    },

    ANameP_ShowList_DEMONHUNTER_2 = {
        [442624] = { 0, 5 }, --파괴자의 징표
        [207771] = { 0, 4 }, --불타는 낙인
        [247456] = { 0, 3 }, --약화
    },


};

ANameP_OptionM = {};
local update_callback = nil;

local curr_y = 0;
local y_adder = -50;

local panel = CreateFrame("Frame")
panel.name = "asNamePlates" -- see panel fields
if InterfaceOptions_AddCategory then
    InterfaceOptions_AddCategory(panel)
else
    local category, layout = Settings.RegisterCanvasLayoutCategory(panel, panel.name);
    Settings.RegisterAddOnCategory(category);
end

local scrollFrame = nil
local scrollChild = nil;

local function SetupChildPanel()
    curr_y = 0;

    if scrollFrame then
        scrollFrame:Hide()
        scrollFrame:UnregisterAllEvents()
        scrollFrame = nil;
    end

    scrollFrame = CreateFrame("ScrollFrame", nil, panel, "UIPanelScrollFrameTemplate")
    scrollFrame:SetPoint("TOPLEFT", 3, -4)
    scrollFrame:SetPoint("BOTTOMRIGHT", -27, 4)

    -- Create the scrolling child frame, set its width to fit, and give it an arbitrary minimum height (such as 1)
    scrollChild = CreateFrame("Frame")
    scrollFrame:SetScrollChild(scrollChild)
    scrollChild:SetWidth(600)
    scrollChild:SetHeight(1)

    -- add widgets to the panel as desired
    local title = panel:CreateFontString("ARTWORK", nil, "GameFontNormalLarge")
    title:SetPoint("TOP")
    title:SetText("asNamePlates")

    local btn = CreateFrame("Button", nil, panel, "UIPanelButtonTemplate")
    btn:SetPoint("TOPRIGHT", -50, -10)
    if GetLocale() == "koKR" then
        btn:SetText("설정 초기화")
    else
        btn:SetText("Reset settings")
    end
    btn:SetWidth(100)
    btn:SetScript("OnClick", function()
        ANameP_Options = {};
        ANameP_Options = CopyTable(ANameP_Options_Default);
        ReloadUI();
    end)
end

local function SetupCheckBoxOption(text, option)
    if ANameP_Options[option] == nil then
        ANameP_Options[option] = ANameP_Options_Default[option];
    end

    curr_y = curr_y + y_adder;

    local cb = CreateFrame("CheckButton", nil, scrollChild, "InterfaceOptionsCheckButtonTemplate")
    cb:SetPoint("TOPLEFT", 20, curr_y)
    cb.Text:SetText(text)
    cb:HookScript("OnClick", function()
        ANameP_Options[option] = cb:GetChecked();
        ANameP_OptionM.UpdateAllOption();
    end)
    cb:SetChecked(ANameP_Options[option]);
end

local function SetupSliderOption(text, option)
    if ANameP_Options[option] == nil then
        ANameP_Options[option] = ANameP_Options_Default[option];
    end

    curr_y = curr_y + y_adder;

    local title = scrollChild:CreateFontString("ARTWORK", nil, "GameFontNormal");
    title:SetPoint("TOPLEFT", 20, curr_y);
    title:SetText(text);

    local Slider = CreateFrame("Slider", nil, scrollChild, "OptionsSliderTemplate");
    Slider:SetOrientation('HORIZONTAL');
    Slider:SetPoint("LEFT", title, "RIGHT", 5, 0);
    Slider:SetWidth(200)
    Slider:SetHeight(20)
    Slider.Text:SetText(format("%.1f", max(ANameP_Options[option], 0)));
    Slider:SetMinMaxValues(0.3, 2);
    Slider:SetValue(ANameP_Options[option]);

    Slider:HookScript("OnValueChanged", function()
        ANameP_Options[option] = Slider:GetValue();
        Slider.Text:SetText(format("%.1f", max(ANameP_Options[option], 0)));
        if not InCombatLockdown() then
            SetCVar("nameplateOverlapV", ANameP_Options[option]);
        end
    end)
    Slider:Show();
    if not InCombatLockdown() then
        SetCVar("nameplateOverlapV", ANameP_Options[option]);
    end
end

local function ShowColorPicker(r, g, b, a, changedCallback)
    local info = {};
    info.r, info.g, info.b = r, g, b;
    info.swatchFunc = changedCallback;
    info.cancelFunc = changedCallback;
    ColorPickerFrame:SetupColorPickerAndShow(info);
end

local function SetupColorOption(text, option)
    if ANameP_Options[option] == nil then
        ANameP_Options[option] = ANameP_Options_Default[option];
    end

    curr_y = curr_y + y_adder;

    local title = scrollChild:CreateFontString("ARTWORK", nil, "GameFontNormal");
    title:SetPoint("TOPLEFT", 20, curr_y);
    title:SetText(text);
    title:SetTextColor(ANameP_Options[option].r, ANameP_Options[option].g, ANameP_Options[option].b, 1);

    local btn = CreateFrame("Button", nil, scrollChild, "UIPanelButtonTemplate")
    btn:SetPoint("LEFT", title, "RIGHT", 5, 0);

    if GetLocale() == "koKR" then
        btn:SetText("색상 변경")
    else
        btn:SetText("Change color")
    end
    btn:SetWidth(100)

    local callback = function(restore)
        local newR, newG, newB, newA;
        if restore then
            newR, newG, newB, newA = unpack(restore);
        else
            newR, newG, newB, newA = ColorPickerFrame:GetColorRGB();
        end
        ANameP_Options[option].r, ANameP_Options[option].g, ANameP_Options[option].b = newR, newG, newB;
        ANameP_OptionM.UpdateAllOption();
    end

    btn:SetScript("OnClick", function()
        ShowColorPicker(ANameP_Options[option].r, ANameP_Options[option].g, ANameP_Options[option].b, 1, callback);
    end)
end

local function SetupEditBoxOption()
    local spec = GetSpecialization();
    local localizedClass, englishClass = UnitClass("player");
    local listname;

    if spec == nil or spec > 4 or (englishClass ~= "DRUID" and spec > 3) then
        spec = 1;
    end

    if spec then
        listname = "ANameP_ShowList_" .. englishClass .. "_" .. spec;
    else
        return;
    end

    if ANameP_Options[listname] == nil then
        if ANameP_Options_Default[listname] then
            ANameP_Options[listname] = ANameP_Options_Default[listname];
        else
            listname = "ANameP_ShowList_" .. englishClass .. "_" .. 1;
            ANameP_Options[listname] = ANameP_Options_Default[listname];
        end
    end

    local listdata = ANameP_Options[listname];

    if listdata == nil then
        return;
    end

    local count = 1;

    curr_y = curr_y + y_adder;

    local localeTexts = { "Priority", "Debuff ID", "Remain/Count", "Nameplate color", "Alert count" };
    if GetLocale() == "koKR" then
        localeTexts = { "우선순위", "디버프 ID", "시간/중첩", "이름표 색상", "디법 중첩 알림" };
    end

    local x = 10;

    local title = scrollChild:CreateFontString("ARTWORK", nil, "GameFontNormal");
    title:SetPoint("TOPLEFT", x, curr_y);
    title:SetText(localeTexts[1]);

    x = 60;

    title = scrollChild:CreateFontString("ARTWORK", nil, "GameFontNormal");
    title:SetPoint("TOPLEFT", x, curr_y);
    title:SetText(localeTexts[2]);

    x = x + 150;


    title = scrollChild:CreateFontString("ARTWORK", nil, "GameFontNormal");
    title:SetPoint("TOPLEFT", x, curr_y);
    title:SetText(localeTexts[3]);

    x = x + 150

    title = scrollChild:CreateFontString("ARTWORK", nil, "GameFontNormal");
    title:SetPoint("TOPLEFT", x, curr_y);
    title:SetText(localeTexts[4]);

    x = x + 200

    title = scrollChild:CreateFontString("ARTWORK", nil, "GameFontNormal");
    title:SetPoint("TOPLEFT", x, curr_y);
    title:SetText(localeTexts[5]);

    local prioritytable = {};

    for spell, values in pairs(listdata) do
        local priority = 6 - values[2];
        local time = values[1];
        local bshowcolor = values[3];
        local bcount = values[4];

        prioritytable[priority] = { spell, time, bshowcolor, bcount };
    end



    for idx = 1, 5 do
        curr_y = curr_y + y_adder;

        title = scrollChild:CreateFontString("ARTWORK", nil, "GameFontNormal");
        title:SetPoint("LEFT", 10, curr_y);
        title:SetText(idx);

        local spell = "";
        local time = 0;
        local showcolor = 0;
        local bcount = 0;

        if prioritytable[idx] and type(prioritytable[idx]) == "table" then
            spell = prioritytable[idx][1];
            time = prioritytable[idx][2];

            if prioritytable[idx][3] then
                showcolor = prioritytable[idx][3];
            else
                showcolor = 0;
            end

            if prioritytable[idx][4] then
                bcount = 1;
            else
                bcount = 2;
            end
        end

        local x = 50;

        local editBox = CreateFrame("EditBox", nil, scrollChild)
        do
            local editBoxLeft = editBox:CreateTexture(nil, "BACKGROUND")
            editBoxLeft:SetTexture(130959) --"Interface\\ChatFrame\\UI-ChatInputBorder-Left"
            editBoxLeft:SetHeight(32)
            editBoxLeft:SetWidth(32)
            editBoxLeft:SetPoint("LEFT", -14, 0)
            editBoxLeft:SetTexCoord(0, 0.125, 0, 1)
            local editBoxRight = editBox:CreateTexture(nil, "BACKGROUND")
            editBoxRight:SetTexture(130960) --"Interface\\ChatFrame\\UI-ChatInputBorder-Right"
            editBoxRight:SetHeight(32)
            editBoxRight:SetWidth(32)
            editBoxRight:SetPoint("RIGHT", 6, 0)
            editBoxRight:SetTexCoord(0.875, 1, 0, 1)
            local editBoxMiddle = editBox:CreateTexture(nil, "BACKGROUND")
            editBoxMiddle:SetTexture(130960) --"Interface\\ChatFrame\\UI-ChatInputBorder-Right"
            editBoxMiddle:SetHeight(32)
            editBoxMiddle:SetWidth(1)
            editBoxMiddle:SetPoint("LEFT", editBoxLeft, "RIGHT")
            editBoxMiddle:SetPoint("RIGHT", editBoxRight, "LEFT")
            editBoxMiddle:SetTexCoord(0, 0.9375, 0, 1)
        end

        editBox:HookScript("OnTextChanged", function() end);
        editBox:SetHeight(32)
        editBox:SetWidth(150)
        editBox:SetPoint("LEFT", scrollChild, "TOPLEFT", x, curr_y)
        editBox:SetFontObject("GameFontHighlight")
        editBox:SetMultiLine(false);
        editBox:SetMaxLetters(20);
        editBox:SetText(spell);
        editBox:SetAutoFocus(false);
        editBox:ClearFocus();
        editBox:SetTextInsets(0, 0, 0, 1);
        editBox:SetNumeric(true);
        editBox:Show();
        editBox:SetCursorPosition(0);
        x = x + 180;

        local editBox2 = CreateFrame("EditBox", nil, scrollChild)
        do
            local editBoxLeft = editBox2:CreateTexture(nil, "BACKGROUND")
            editBoxLeft:SetTexture(130959) --"Interface\\ChatFrame\\UI-ChatInputBorder-Left"
            editBoxLeft:SetHeight(32)
            editBoxLeft:SetWidth(32)
            editBoxLeft:SetPoint("LEFT", -14, 0)
            editBoxLeft:SetTexCoord(0, 0.125, 0, 1)
            local editBoxRight = editBox2:CreateTexture(nil, "BACKGROUND")
            editBoxRight:SetTexture(130960) --"Interface\\ChatFrame\\UI-ChatInputBorder-Right"
            editBoxRight:SetHeight(32)
            editBoxRight:SetWidth(32)
            editBoxRight:SetPoint("RIGHT", 6, 0)
            editBoxRight:SetTexCoord(0.875, 1, 0, 1)
            local editBoxMiddle = editBox2:CreateTexture(nil, "BACKGROUND")
            editBoxMiddle:SetTexture(130960) --"Interface\\ChatFrame\\UI-ChatInputBorder-Right"
            editBoxMiddle:SetHeight(32)
            editBoxMiddle:SetWidth(1)
            editBoxMiddle:SetPoint("LEFT", editBoxLeft, "RIGHT")
            editBoxMiddle:SetPoint("RIGHT", editBoxRight, "LEFT")
            editBoxMiddle:SetTexCoord(0, 0.9375, 0, 1)
        end

        editBox2:HookScript("OnTextChanged", function() end);
        editBox2:SetHeight(32)
        editBox2:SetWidth(100)
        editBox2:SetPoint("LEFT", scrollChild, "TOPLEFT", x, curr_y)
        editBox2:SetFontObject("GameFontHighlight")
        editBox2:SetMultiLine(false);
        editBox2:SetMaxLetters(20);
        editBox2:SetNumeric(false);
        editBox2:SetText(time);
        editBox2:SetAutoFocus(false);
        editBox2:ClearFocus();
        editBox2:SetTextInsets(0, 0, 0, 1)
        editBox2:Show();
        editBox2:SetCursorPosition(0);
        x = x + 130;


        local dropDown = CreateFrame("Frame", nil, scrollChild, "UIDropDownMenuTemplate")
        dropDown:SetPoint("LEFT", scrollChild, "TOPLEFT", x, curr_y)
        UIDropDownMenu_SetWidth(dropDown, 100) -- Use in place of dropDown:SetWidth

        local dropdownOptions = {
            { text = "No nameplate color", value = 0 },
            { text = "Nameplate color 1",  value = 1 },
            { text = "Nameplate color 2",  value = 2 },

        }

        if GetLocale() == "koKR" then
            dropdownOptions = {
                { text = "이름표색상없음", value = 0 },
                { text = "이름표색상변경", value = 1 },
                { text = "이름표색상변경2", value = 2 },
            }
        end

        x = x + 130;

        local dropDown2 = CreateFrame("Frame", nil, scrollChild, "UIDropDownMenuTemplate")
        dropDown2:SetPoint("LEFT", scrollChild, "TOPLEFT", x, curr_y)
        UIDropDownMenu_SetWidth(dropDown2, 100) -- Use in place of dropDown:SetWidth

        local dropdownOptions2 = {
            { text = "Alert by count",  value = 1 },
            { text = "Alert by remain", value = 2 },
        }

        if GetLocale() == "koKR" then
            dropdownOptions2 = {
                { text = "중첩으로 알림", value = 1 },
                { text = "시간으로 알림", value = 2 },
            }
        end

        local function updatedata()
            local newspell = editBox:GetNumber();
            local newtime = tonumber(editBox2:GetText());
            local newcolor = (UIDropDownMenu_GetSelectedValue(dropDown));
            local newbcount = (UIDropDownMenu_GetSelectedValue(dropDown2) == 1);

            if newspell ~= "" and newtime ~= nil and newcolor >= 0 and newbcount ~= nil then
                prioritytable[idx] = { newspell, newtime, newcolor, newbcount }
            end
        end

        UIDropDownMenu_Initialize(dropDown, function(self, level)
            for _, option in ipairs(dropdownOptions) do
                local info = UIDropDownMenu_CreateInfo()
                info.text = option.text
                info.value = option.value
                info.disabled = option.disabled
                local function Dropdown_OnClick()
                    UIDropDownMenu_SetSelectedValue(dropDown, option.value);
                    updatedata();
                end
                info.func = Dropdown_OnClick;
                UIDropDownMenu_AddButton(info, level)
            end
        end);
        UIDropDownMenu_SetSelectedValue(dropDown, showcolor);

        UIDropDownMenu_Initialize(dropDown2, function(self, level)
            for _, option in ipairs(dropdownOptions2) do
                local info = UIDropDownMenu_CreateInfo()
                info.text = option.text
                info.value = option.value
                info.disabled = option.disabled
                local function Dropdown_OnClick()
                    UIDropDownMenu_SetSelectedValue(dropDown2, option.value);
                    updatedata();
                end
                info.func = Dropdown_OnClick;
                UIDropDownMenu_AddButton(info, level)
            end
        end);
        UIDropDownMenu_SetSelectedValue(dropDown2, bcount);


        editBox:HookScript("OnTextChanged", function(self, updated)
            if updated == false then
                return;
            end

            updatedata();
        end)

        editBox2:HookScript("OnTextChanged", function(self, updated)
            if updated == false then
                return;
            end

            updatedata();
        end)

        count = count + 1;
    end

    curr_y = curr_y + y_adder;

    local btn = CreateFrame("Button", nil, scrollChild, "UIPanelButtonTemplate")
    btn:SetPoint("TOPRIGHT", -50, curr_y)
    if GetLocale() == "koKR" then
        btn:SetText("설정 반영")
    else
        btn:SetText("Confirm")
    end
    btn:SetWidth(100)
    btn:SetScript("OnClick", function()
        for idx, values in pairs(prioritytable) do
            local priority = 6 - idx;            
            local spell = values[1];
            local time = values[2];
            local bshowcolor = values[3];
            local bcount = values[4];

            if spell and spell > 0 then
                ANameP_Options[listname][spell] = { time, priority, bshowcolor, bcount };
            end
            
        end
        C_Timer.After(1.5, ReloadUI());
    end)
end


local function SetupDebuffPointOption()
    curr_y = curr_y + y_adder;

    local localeTexts = { "Debuff Point" };
    if GetLocale() == "koKR" then
        localeTexts = { "디버프 위치" };
    end

    local x = 10;

    local title = scrollChild:CreateFontString("ARTWORK", nil, "GameFontNormal");
    title:SetPoint("TOPLEFT", x, curr_y);
    title:SetText(localeTexts[1]);

    x = 60;

    local dropDown = CreateFrame("Frame", nil, scrollChild, "UIDropDownMenuTemplate")
    dropDown:SetPoint("LEFT", scrollChild, "TOPLEFT", x, curr_y-5)
    UIDropDownMenu_SetWidth(dropDown, 100)     -- Use in place of dropDown:SetWidth

    local dropdownOptions = {
        { text = "Top",  value = 1 },
        { text = "Left", value = 2 },
        { text = "Hide", value = 3 },

    }

    x = x + 130;

    local function updatedata()
        local newpoint = (UIDropDownMenu_GetSelectedValue(dropDown));
        ns.options.ANameP_DebuffAnchorPoint = newpoint;
        ANameP_Options.ANameP_DebuffAnchorPoint = newpoint;
    end

    UIDropDownMenu_Initialize(dropDown, function(self, level)
        for _, option in ipairs(dropdownOptions) do
            local info = UIDropDownMenu_CreateInfo()
            info.text = option.text
            info.value = option.value
            info.disabled = option.disabled
            local function Dropdown_OnClick()
                UIDropDownMenu_SetSelectedValue(dropDown, option.value);
                updatedata();
            end
            info.func = Dropdown_OnClick;
            UIDropDownMenu_AddButton(info, level)
        end
    end);
    UIDropDownMenu_SetSelectedValue(dropDown, ns.options.ANameP_DebuffAnchorPoint);
end


local bfirst = true;
ANameP_OptionM.SetupAllOption = function()
    if bfirst and not InCombatLockdown() then
        SetCVar("nameplateOverlapV", ANameP_Options["nameplateOverlapV"]);
        if update_callback then
            update_callback();
        end
        bfirst = false;
    end
end

ANameP_OptionM.UpdateAllOption = function()
    ANameP_OptionM.SetupAllOption()
end

ANameP_OptionM.RegisterCallback = function(callback_func)
    update_callback = callback_func;
end

function panel:OnEvent(event, addOnName)
    if addOnName == "asNamePlates" then
        if ANameP_Options == nil then
            ANameP_Options = {};
            ANameP_Options = CopyTable(ANameP_Options_Default);
        end

        if ANameP_Options.version ~= ANameP_Options_Default.version then
            ANameP_Options = CopyTable(ANameP_Options_Default);
        end

        ANameP_OptionM.SetupAllOption();
    elseif event == "TRAIT_CONFIG_UPDATED" or event == "TRAIT_CONFIG_LIST_UPDATED" or event == "ACTIVE_TALENT_GROUP_CHANGED" then
        ANameP_OptionM.SetupAllOption();
    elseif event == "PLAYER_REGEN_ENABLED" then
        ANameP_OptionM.SetupAllOption();
    end
end

local function panelOnShow()
    SetupChildPanel();

    -- Check if the locale is Korean ("koKR")
    if GetLocale() == "koKR" then
        -- Set up checkbox options with Korean descriptions
        SetupCheckBoxOption("[디버프] 기본에 스팰북 스킬 디버프 추가", "ANameP_ShowKnownSpell"); -- Add spellbook skill debuffs to default debuffs
        SetupCheckBoxOption("[디버프] 내 디버프 모두 보임", "ANameP_ShowMyAll"); -- Show all my debuffs
        SetupCheckBoxOption("[디버프] List 등록 디버프만 보임", "ANameP_ShowListOnly"); -- Show only debuffs registered in the list
        SetupCheckBoxOption("[버프] 내 버프 모두 보임", "ANameP_ShowPlayerBuffAll"); -- Show all my buffs
        SetupCheckBoxOption("[툴팁] 버프/디버프 툴팁 표시", "ANameP_Tooltip"); -- Show buff/debuff tooltips
        SetupCheckBoxOption("[쿨다운] DBM 쿨다운 표시", "ANameP_ShowDBM"); -- Show DBM cooldowns
        SetupCheckBoxOption("[색상] 어그로 색상 표시", "ANameP_AggroShow"); -- Show aggro colors
        SetupCheckBoxOption("[색상] 낮은 생명력 색상 표시", "ANameP_LowHealthAlert"); -- Show low health colors
        SetupCheckBoxOption("[색상] Quest 몹 색상 표시", "ANameP_QuestAlert"); -- Show quest mob colors
        SetupCheckBoxOption("[색상] AutoMarker 몹 색상 표시", "ANameP_AutoMarker"); -- Show AutoMarker mob colors
        SetupCheckBoxOption("[색상] DBM Casting 몹 색상 표시", "ANameP_ShowDBMCastingColor"); -- Show DBM casting mob colors
        SetupCheckBoxOption("[크기] 아군 체력바 크기 조정", "ANameP_ShortFriendNP"); -- Adjust friendly health bar size
        SetupCheckBoxOption("[체력] 체력 수치를 좌측에 표시", "ANameP_RealHealth"); -- Display health values on the left
        SetupCheckBoxOption("[소환수] 소환수 대상 및 야수의 회전 베기 표시", "ANameP_ShowPetTarget"); -- Show pet's target and Beast Cleave
        SetupCheckBoxOption("[대상] 대상에 빨간 화살표 표시", "ANameP_ShowTargetArrow"); -- Show pet's target and Beast Cleave

        -- Set up slider and color options with Korean descriptions
        SetupSliderOption("이름표 상하 정렬 정도 (nameplateOverlapV)", "nameplateOverlapV"); -- Nameplate vertical alignment (nameplateOverlapV)
        SetupColorOption("[이름표 색상] 어그로 대상", "ANameP_AggroTargetColor"); -- Nameplate color: Aggro target
        SetupColorOption("[이름표 색상] 어그로 상위", "ANameP_AggroColor"); -- Nameplate color: Top aggro
        SetupColorOption("[탱커 이름표 색상] 어그로 상실", "ANameP_TankAggroLoseColor"); -- Tank nameplate color: Aggro lost
        SetupColorOption("[탱커 이름표 색상] 어그로 다른 탱커", "ANameP_TankAggroLoseColor2"); -- Tank nameplate color: Aggro on another tank
        SetupColorOption("[이름표 색상] 어그로 소환수", "ANameP_TankAggroLoseColor3"); -- Nameplate Color: Aggro Pet
        SetupColorOption("[이름표 색상] 낮은 체력", "ANameP_LowHealthColor"); -- Nameplate color: Low health
        SetupColorOption("[이름표 색상] 디버프", "ANameP_DebuffColor"); -- Nameplate color: Debuff
        SetupColorOption("[이름표 색상] 디버프2", "ANameP_DebuffColor2"); -- Nameplate color: Debuff 2
        SetupColorOption("[이름표 색상] 디버프3", "ANameP_DebuffColor3"); -- Nameplate color: Debuff 3
        SetupColorOption("[이름표 색상] Quest", "ANameP_QuestColor"); -- Nameplate color: Quest
        SetupColorOption("[이름표 색상] AutoMarker", "ANameP_AutoMarkerColor"); -- Nameplate color: AutoMarker
        SetupColorOption("[이름표 색상] AutoMarker2", "ANameP_AutoMarkerColor2"); -- Nameplate color: AutoMarker 2
    else
        -- Set up checkbox options with English descriptions
        SetupCheckBoxOption("[Debuff] Add spellbook skill debuffs to default", "ANameP_ShowKnownSpell");
        SetupCheckBoxOption("[Debuff] Show all my debuffs", "ANameP_ShowMyAll");
        SetupCheckBoxOption("[Debuff] Show only debuffs in the list", "ANameP_ShowListOnly");
        SetupCheckBoxOption("[Buff] Show all my buffs", "ANameP_ShowPlayerBuffAll");
        SetupCheckBoxOption("[Tooltip] Show buff/debuff tooltips", "ANameP_Tooltip");
        SetupCheckBoxOption("[Cooldown] Show DBM cooldowns", "ANameP_ShowDBM");
        SetupCheckBoxOption("[Color] Show aggro colors", "ANameP_AggroShow");
        SetupCheckBoxOption("[Color] Show low health colors", "ANameP_LowHealthAlert");
        SetupCheckBoxOption("[Color] Show quest mob colors", "ANameP_QuestAlert");
        SetupCheckBoxOption("[Color] Show AutoMarker mob colors", "ANameP_AutoMarker");
        SetupCheckBoxOption("[Color] Show DBM casting mob colors", "ANameP_ShowDBMCastingColor");
        SetupCheckBoxOption("[Size] Adjust friendly health bar size", "ANameP_ShortFriendNP");
        SetupCheckBoxOption("[Health] Display health values on the left", "ANameP_RealHealth");
        SetupCheckBoxOption("[Pet] Show pet's target and Beast Cleave", "ANameP_ShowPetTarget");
        SetupCheckBoxOption("[Target] Show arrow on target", "ANameP_ShowTargetArrow"); -- Show pet's target and Beast Cleave

        -- Set up slider and color options with English descriptions
        SetupSliderOption("Nameplate vertical alignment (nameplateOverlapV)", "nameplateOverlapV");
        SetupColorOption("[Nameplate Color] Aggro target", "ANameP_AggroTargetColor");
        SetupColorOption("[Nameplate Color] Top aggro", "ANameP_AggroColor");
        SetupColorOption("[Tank Nameplate Color] Aggro lost", "ANameP_TankAggroLoseColor");
        SetupColorOption("[Tank Nameplate Color] Aggro on another tank", "ANameP_TankAggroLoseColor2");
        SetupColorOption("[Nameplate Color] Aggro Pet", "ANameP_TankAggroLoseColor3");
        SetupColorOption("[Nameplate Color] Low health", "ANameP_LowHealthColor");
        SetupColorOption("[Nameplate Color] Debuff", "ANameP_DebuffColor");
        SetupColorOption("[Nameplate Color] Debuff 2", "ANameP_DebuffColor2");
        SetupColorOption("[Nameplate Color] Debuff 3", "ANameP_DebuffColor3");
        SetupColorOption("[Nameplate Color] Quest", "ANameP_QuestColor");
        SetupColorOption("[Nameplate Color] AutoMarker", "ANameP_AutoMarkerColor");
        SetupColorOption("[Nameplate Color] AutoMarker 2", "ANameP_AutoMarkerColor2");
    end
    SetupDebuffPointOption();
    SetupEditBoxOption();
end
local function panelOnHide()
    if scrollFrame then
        scrollFrame:Hide()
        scrollFrame:UnregisterAllEvents()
        scrollFrame = nil;
    end
end

panel:RegisterEvent("ADDON_LOADED")
panel:RegisterEvent("TRAIT_CONFIG_UPDATED");
panel:RegisterEvent("TRAIT_CONFIG_LIST_UPDATED");
panel:RegisterEvent("ACTIVE_TALENT_GROUP_CHANGED")
panel:RegisterEvent("PLAYER_REGEN_ENABLED");
panel:SetScript("OnEvent", panel.OnEvent)
panel:SetScript("OnShow", panelOnShow)
panel:SetScript("OnHide", panelOnHide);
