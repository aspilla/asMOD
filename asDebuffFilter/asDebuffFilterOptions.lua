local _, ns = ...;

ns.ADF_SIZE = 28;
ns.ADF_TARGET_DEBUFF_X = 73 + 30 + 20;
ns.ADF_TARGET_DEBUFF_Y = -110 - 28;
ns.ADF_PLAYER_DEBUFF_X = -73 - 30 - 20;
ns.ADF_PLAYER_DEBUFF_Y = -110 - 28;
ns.ADF_MAX_DEBUFF_SHOW = 7;
ns.ADF_ALPHA = 1
ns.ADF_CooldownFontSize = 12 -- Cooldown Font Size
ns.ADF_CountFontSize = 11;   -- Count Font Size
ns.ADF_AlphaCombat = 1;      -- 전투중 Alpha 값
ns.ADF_AlphaNormal = 0.5;    -- 비 전투중 Alpha 값
ns.ADF_MAX_Cool = 120        -- 최대 120초까지의 Debuff를 보임

-- ANameP_ShowList_직업_특성 숫자
-- 아래와 같은 배열을 추가 하면 된다.
-- ["디법명"] = {알림 시간, 우선순위, 색상 변경 여부},
-- 우선순위는 숫자가 큰 경우 우선적으로 보이고, 같을 경우 먼저 걸린 순서로 보임
ns.ShowList_WARRIOR_1 = {
    ["분쇄"] = { 1, 5, true },
}

ns.ShowList_WARRIOR_2 = {
}

ns.ShowList_WARRIOR_3 = {
}

ns.ShowList_ROGUE_1 = {
    ["목조르기"] = { 1, 5 },
    ["파열"] = { 24 * 0.3, 4, true },
    ["혈폭풍"] = { 12 * 0.3, 3 },

}

ns.ShowList_ROGUE_2 = {

}

ns.ShowList_ROGUE_3 = {
    ["파열"] = { 24 * 0.3, 5, true },
}


ns.ShowList_HUNTER_1 = {

    ["날카로운 사격"] = { 1, 5, true },
    ["독사 쐐기"] = { 0, 4 },
    ["저승까마귀"] = { 0, 3 },
    ["사냥꾼의 징표"] = { 0, 2 },
}

ns.ShowList_HUNTER_2 = {
    ["독사 쐐기"] = { 1, 5, true },
    ["사냥꾼의 징표"] = { 0, 4 },

}

ns.ShowList_HUNTER_3 = {
    ["독사 쐐기"] = { 1, 5, true },
    ["사냥꾼의 징표"] = { 0, 4 },

}

ns.ShowList_MONK_1 = {
}

ns.ShowList_MONK_2 = {
}

ns.ShowList_MONK_3 = {
    ["하늘탑"] = { 10, 5 },
    ["주학의 징표"] = { 0, 4, true },
    ["암흑불길 저항력 약화"] = { 0, 3 }, --시즌2
}

ns.ShowList_WARLOCK_1 = {
    ["고통"] = { 1, 5, true },
    ["불안정한 고통"] = { 1, 4 },
    ["부패"] = { 1, 3 },
    ["생명력 착취"] = { 1, 2 },
}

ns.ShowList_WARLOCK_2 = {
    ["파멸"] = { 0, 5 }, --시즌3
    ["악의 아귀"] = { 0, 4, true },
}


ns.ShowList_WARLOCK_3 = {
    ["제물"] = { 1, 5, true },
}


ns.ShowList_PRIEST_1 = {
    ["사악의 정화"] = { 1, 5, true },
    ["어둠의 권능: 고통"] = { 1, 5, true },
}

ns.ShowList_PRIEST_2 = {
    ["어둠의 권능: 고통"] = { 1, 5, true },
}


ns.ShowList_PRIEST_3 = {
    ["어둠의 권능: 고통"] = { 1, 5, true },
}

ns.ShowList_SHAMAN_1 = {
    ["화염 충격"] = { 18 * 0.3, 5, true },
}

ns.ShowList_SHAMAN_2 = {
    ["채찍 화염"] = { 0, 5 },
    ["화염 충격"] = { 18 * 0.3, 4, true },
}

ns.ShowList_SHAMAN_3 = {
    ["화염 충격"] = { 18 * 0.3, 5, true },
}


ns.ShowList_DRUID_1 = {
    ["달빛섬광"] = { 1, 5, true },
    ["태양섬광"] = { 1, 4 },
    ["항성의 섬광"] = { 1, 3 },
}


ns.ShowList_DRUID_2 = {
    ["갈퀴 발톱"] = { 12 * 0.3, 5, true },
    ["도려내기"] = { 19 * 0.3, 4 },
    ["달빛섬광"] = { 1, 3 },
}

ns.ShowList_DRUID_3 = {
    ["달빛섬광"] = { 1, 5 },
}


ns.ShowList_DRUID_4 = {
    ["달빛섬광"] = { 1, 5, true },
}


ns.ShowList_MAGE_1 = {
    ["비전의 여파"] = { 0, 5 },
}

ns.ShowList_MAGE_2 = {
    ["작열"] = { 0, 5 },
}

ns.ShowList_MAGE_3 = {
    ["혹한의 추위"] = { 0, 5, true },

}


ns.ShowList_DEATHKNIGHT_1 = {
    ["잿빛 부패"] = { 0, 5 }, --시즌3
    ["피의 역병"] = { 0, 4 },

}

ns.ShowList_DEATHKNIGHT_2 = {
    ["잔존하는 한기"] = { 0, 5, true }, --시즌2
    ["서리 열병"] = { 0, 4 },
}

ns.ShowList_DEATHKNIGHT_3 = {
    ["악성 역병"] = { 1, 4, true },
    ["고름 상처"] = { 0, 5 },
}


ns.ShowList_EVOKER_1 = {
    ["불의 숨결"] = { 0, 5, true },
}

ns.ShowList_EVOKER_2 = {
    ["불의 숨결"] = { 0, 5, true },

}

ns.ShowList_EVOKER_3 = {

    ["시간의 상처"] = { 0, 5, true },
}


ns.ShowList_PALADIN_1 = {
    ["무가치한 존재"] = { 0, 4 },
}

ns.ShowList_PALADIN_2 = {
    ["심판"] = { 0, 5 },
}

ns.ShowList_PALADIN_3 = {
    ["심판"] = { 0, 5, true },
}

ns.ShowList_DEMONHUNTER_1 = {
    ["불타는 상처"] = { 0, 5, true },
}

ns.ShowList_DEMONHUNTER_2 = {
    ["불타는 낙인"] = { 0, 5 },
    ["약화"] = { 0, 4 },
}
