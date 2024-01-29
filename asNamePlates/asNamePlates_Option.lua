local _, ns = ...;

---설정부
ns.ANameP_SIZE = 0;                  -- Icon Size 0 이면 자동으로 설정
ns.ANameP_Size_Rate = 0.7;           -- Icon 가로 세로 비중
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
ns.ANameP_CCDebuffSize = 16          -- CC Debuff Size;
ns.ANameP_AggroSize = 12;            -- 어그로 표시 Text Size
ns.ANameP_HealerSize = 14;           -- 힐러표시 Text Size
ns.ANameP_TargetHealthBarHeight = 3; -- 대상 체력바 높이 증가치 (+3)
ns.ANameP_HeathTextSize = 8;         -- 대상 체력숫자 크기
ns.ANameP_UpdateRate = 0.5;          -- 버프 Check 반복 시간 (초)


-- 아래 유닛명이면 강조
-- 색상 지정 가능
-- { r, g, b, 빤작임 여부}
ns.ANameP_AlertList = {
    ["폭발물"] = { 0, 1, 0.5, 1 }, -- 녹색 빤짝이
    ["무형의 존재"] = { 0, 1, 0.5, 0 }, -- 녹색 빤짝이
    --["쉬바라"] = {0, 1, 0.5, 1},	 -- 녹색 빤짝이
    --["우르줄"] = {0, 1, 0.5, 1},	 -- 녹색 빤짝이
    --	["파멸수호병"] = {0, 1, 0.5, 1},	 -- 녹색 빤짝이
    --	["격노수호병"] = {0, 1, 0.5, 1},	 -- 녹색 빤짝이
    --	["지옥불정령"] = {0, 1, 0.5, 1},	 -- 녹색 빤짝이
    --	["지옥사냥개"] = {0, 1, 0.5, 1},	 -- 녹색 빤짝이
    --	["원한의 망령"] = {1, 1, 1, 0},	-- 흰색 빤짝이 (없음)
    --	["어둠그늘 곰팡이"] = {0, 1, 0, 0},	-- 녹색 빤짝이 (없음)
    --["절단 훈련용 허수아비"] = {0, 1, 0.5, 1},	
    --	["던전 사용자의 허수아비"] = {1, 0, 1, 0},	
    --["공격대원의 훈련용 허수아비"] = {1, 0, 1, 0},	

}


-- 안보이게 할 디법
ns.ANameP_BlackList = {
    --	["상처 감염 독"] = 1,	
    --	["맹독"] = 1,
    --	["약자 고문"] = 1,
    --	["슬픔"] = 1,
    --	["순환하는 기원"] = 1,
    ["도전자의 짐"] = 1,
    ["도전자의 힘"] = 1,

}

ns.ANameP_PVPBuffList = {
    [236273] = 1, --WARRIOR
    [213871] = 1, --WARRIOR
    [118038] = 1, --WARRIOR
    [12975] = 1,  --WARRIOR
    [1160] = 1,   --WARRIOR
    [871] = 1,    --WARRIOR
    [202168] = 1, --WARRIOR
    [97463] = 1,  --WARRIOR
    [383762] = 1, --WARRIOR
    [184364] = 1, --WARRIOR
    [386394] = 1, --WARRIOR
    [392966] = 1, --WARRIOR
    [185311] = 1, --ROGUE
    [11327] = 1,  --ROGUE
    [1966] = 1,   --ROGUE
    [31224] = 1,  --ROGUE
    [31230] = 1,  --ROGUE
    [5277] = 1,   --ROGUE
    [212800] = 1, --DEMONHUNTER
    [203720] = 1, --DEMONHUNTER
    [187827] = 1, --DEMONHUNTER
    [206803] = 1, --DEMONHUNTER
    [196555] = 1, --DEMONHUNTER
    [204021] = 1, --DEMONHUNTER
    [263648] = 1, --DEMONHUNTER
    [209258] = 1, --DEMONHUNTER
    [209426] = 1, --DEMONHUNTER
    [202162] = 1, --MONK
    [388615] = 1, --MONK
    [115310] = 1, --MONK
    [116849] = 1, --MONK
    [115399] = 1, --MONK
    [119582] = 1, --MONK
    [122281] = 1, --MONK
    [322507] = 1, --MONK
    [120954] = 1, --MONK
    [122783] = 1, --MONK
    [122278] = 1, --MONK
    [132578] = 1, --MONK
    [115176] = 1, --MONK
    [51052] = 1,  --DEATHKNIGHT
    [48707] = 1,  --DEATHKNIGHT
    [327574] = 1, --DEATHKNIGHT
    [48743] = 1,  --DEATHKNIGHT
    [48792] = 1,  --DEATHKNIGHT
    [114556] = 1, --DEATHKNIGHT
    [81256] = 1,  --DEATHKNIGHT
    [219809] = 1, --DEATHKNIGHT
    [206931] = 1, --DEATHKNIGHT
    [274156] = 1, --DEATHKNIGHT
    [194679] = 1, --DEATHKNIGHT
    [55233] = 1,  --DEATHKNIGHT
    [53480] = 1,  --HUNTER
    [109304] = 1, --HUNTER
    [264735] = 1, --HUNTER
    [355913] = 1, --EVOKER
    [370960] = 1, --EVOKER
    [363534] = 1, --EVOKER
    [357170] = 1, --EVOKER
    [374348] = 1, --EVOKER
    [374227] = 1, --EVOKER
    [363916] = 1, --EVOKER
    [360827] = 1, --EVOKER
    [404381] = 1, --EVOKER
    [305497] = 1, --DRUID
    [354654] = 1, --DRUID
    [201664] = 1, --DRUID
    [157982] = 1, --DRUID
    [102342] = 1, --DRUID
    [61336] = 1,  --DRUID
    [200851] = 1, --DRUID
    [80313] = 1,  --DRUID
    [22842] = 1,  --DRUID
    [108238] = 1, --DRUID
    [124974] = 1, --DRUID
    [104773] = 1, --WARLOCK
    [108416] = 1, --WARLOCK
    [215769] = 1, --PRIEST
    [328530] = 1, --PRIEST
    [197268] = 1, --PRIEST
    [19236] = 1,  --PRIEST
    [81782] = 1,  --PRIEST
    [33206] = 1,  --PRIEST
    [372835] = 1, --PRIEST
    [391124] = 1, --PRIEST
    [265202] = 1, --PRIEST
    [64843] = 1,  --PRIEST
    [47788] = 1,  --PRIEST
    [47585] = 1,  --PRIEST
    [108968] = 1, --PRIEST
    [15286] = 1,  --PRIEST
    [271466] = 1, --PRIEST
    [199452] = 1, --PALADIN
    [403876] = 1, --PALADIN
    [31850] = 1,  --PALADIN
    [378279] = 1, --PALADIN
    [378974] = 1, --PALADIN
    [86659] = 1,  --PALADIN
    [387174] = 1, --PALADIN
    [327193] = 1, --PALADIN
    [205191] = 1, --PALADIN
    [184662] = 1, --PALADIN
    [498] = 1,    --PALADIN
    [148039] = 1, --PALADIN
    [157047] = 1, --PALADIN
    [31821] = 1,  --PALADIN
    [633] = 1,    --PALADIN
    [6940] = 1,   --PALADIN
    [1022] = 1,   --PALADIN
    [204018] = 1, --PALADIN
    [204331] = 1, --SHAMAN
    [108280] = 1, --SHAMAN
    [98008] = 1,  --SHAMAN
    [198838] = 1, --SHAMAN
    [207399] = 1, --SHAMAN
    [108271] = 1, --SHAMAN
    [198103] = 1, --SHAMAN
    [30884] = 1,  --SHAMAN
    [383017] = 1, --SHAMAN
    [108281] = 1, --SHAMAN
    [198111] = 1, --MAGE
    [110959] = 1, --MAGE
    [342246] = 1, --MAGE
    [11426] = 1,  --MAGE
    [66] = 1,     --MAGE
    [235313] = 1, --MAGE
    [235450] = 1, --MAGE
    [55342] = 1,  --MAGE
    [414660] = 1, --MAGE
    [414664] = 1, --MAGE
    [86949] = 1,  --MAGE
    [235219] = 1, --MAGE
    [414658] = 1, --MAGE
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
    version = 240124,
    ANameP_ShowKnownSpell = true,                             -- [디버프] 기본 + 사용 가능 스킬 디버프 추가
    ANameP_ShowMyAll = false,                                 -- [디버프] 전부 보이기
    ANameP_ShowListOnly = false,                              -- [디버프] List 만 보이기
    ANameP_ShowPlayerBuffAll = false,                         -- [버프] 전부 보이기
    ANameP_AggroShow = true,                                  -- 어그로 여부를 표현할지 여부
    ANameP_LowHealthAlert = true,                             -- 낮은 체력 색상 변경 사용
    ANameP_QuestAlert = true,                                 -- Quest 몹 색상 변경 사용
    ANameP_AutoMarker = true,                                 -- AutoMarker 몹 색상 변경 사용
    ANameP_Tooltip = true,                                    -- Tooltip 표시
    ANameP_ShowDBM = true,                                    -- DBM Cooldown을 표시

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

    nameplateOverlapV = 0.7,                                  -- 이름표 상하 정렬



    -- ANameP_ShowList_직업_특성 숫자
    -- 아래와 같은 배열을 추가 하면 된다.
    -- ["디법명"] = {알림 시간, 우선순위, 색상 변경 여부},
    -- 우선순위는 숫자가 큰 경우 우선적으로 보이고, 같을 경우 먼저 걸린 순서로 보임
    ANameP_ShowList_WARRIOR_1 = {
        ["분쇄"] = { 1, 5, 1 },
    },

    ANameP_ShowList_WARRIOR_2 = {
    },

    ANameP_ShowList_WARRIOR_3 = {
    },

    ANameP_ShowList_ROGUE_1 = {
        ["목조르기"] = { 1, 5, 2 },
        ["파열"] = { 24 * 0.3, 4, 1 },
        ["혈폭풍"] = { 12 * 0.3, 3 },

    },

    ANameP_ShowList_ROGUE_2 = {

        ["유령의 일격"] = { 0, 5, 1 },
    },

    ANameP_ShowList_ROGUE_3 = {
        ["파열"] = { 24 * 0.3, 5, 1 },
    },


    ANameP_ShowList_HUNTER_1 = {
        ["사냥꾼의 징표"] = { 0, 5 },
        ["날카로운 사격"] = { 1, 4, 1 },
        ["잠재된 독"] = { 8, 3, 0, true },
        ["독사 쐐기"] = { 1, 2, 2 },
    },

    ANameP_ShowList_HUNTER_2 = {
        ["사냥꾼의 징표"] = { 0, 5 },
        ["잠재된 독"] = { 8, 4, 2, true },
        ["독사 쐐기"] = { 1, 3, 1 },

    },

    ANameP_ShowList_HUNTER_3 = {
        ["사냥꾼의 징표"] = { 0, 5 },
        ["잠재된 독"] = { 8, 4, 2, true },
        ["독사 쐐기"] = { 1, 3, 1 },

    },

    ANameP_ShowList_MONK_1 = {
    },

    ANameP_ShowList_MONK_2 = {
    },

    ANameP_ShowList_MONK_3 = {
        ["하늘탑"] = { 10, 5 },
        ["주학의 징표"] = { 0, 4, 1 },
        ["암흑불길 저항력 약화"] = { 0, 3 }, --시즌2
    },

    ANameP_ShowList_WARLOCK_1 = {
        ["고통"] = { 1, 5, 1 },
        ["불안정한 고통"] = { 1, 4 },
        ["부패"] = { 1, 3, 2 },
        ["생명력 착취"] = { 1, 2 },
    },

    ANameP_ShowList_WARLOCK_2 = {
        ["파멸의 낙인"] = { 0, 5, 2 }, --시즌3
        ["사냥개조련사의 책략"] = { 0, 4, 1 },
    },


    ANameP_ShowList_WARLOCK_3 = {
        ["제물"] = { 1, 5, 1 },
    },


    ANameP_ShowList_PRIEST_1 = {
        ["사악의 정화"] = { 1, 5, 1 },
        ["어둠의 권능: 고통"] = { 1, 5, 1 },
    },

    ANameP_ShowList_PRIEST_2 = {
        ["어둠의 권능: 고통"] = { 1, 5, 1 },
    },


    ANameP_ShowList_PRIEST_3 = {
        ["어둠의 권능: 고통"] = { 1, 5, 1 },
    },

    ANameP_ShowList_SHAMAN_1 = {
        ["화염 충격"] = { 18 * 0.3, 5, 1 },
    },

    ANameP_ShowList_SHAMAN_2 = {
        ["채찍 화염"] = { 0, 5 },
        ["화염 충격"] = { 18 * 0.3, 4, 1 },
    },

    ANameP_ShowList_SHAMAN_3 = {
        ["화염 충격"] = { 18 * 0.31, 5, 1 },
    },


    ANameP_ShowList_DRUID_1 = {
        ["달빛섬광"] = { 1, 5, 1 },
        ["태양섬광"] = { 1, 4, 2 },
        ["항성의 섬광"] = { 1, 3 },
    },


    ANameP_ShowList_DRUID_2 = {
        ["갈퀴 발톱"] = { 12 * 0.3, 5, 1 },
        ["도려내기"] = { 19 * 0.3, 4 },
        ["달빛섬광"] = { 1, 3 },
    },

    ANameP_ShowList_DRUID_3 = {
        ["달빛섬광"] = { 1, 5 },
    },


    ANameP_ShowList_DRUID_4 = {
        ["달빛섬광"] = { 1, 5, 1 },
        ["갈퀴 발톱"] = { 12 * 0.3, 4, 2 },
    },


    ANameP_ShowList_MAGE_1 = {
        ["빛나는 불꽃 약화"] = { 0, 5, 1 },
    },

    ANameP_ShowList_MAGE_2 = {
        ["사르는 잿불"] = { 0, 5, 1 }, --시즌2
        ["작열"] = { 0, 4 },
    },

    ANameP_ShowList_MAGE_3 = {
        ["혹한의 추위"] = { 0, 5, 1 },

    },


    ANameP_ShowList_DEATHKNIGHT_1 = {
        ["잿빛 부패"] = { 0, 5 }, --시즌3
        ["피의 역병"] = { 0, 4 },

    },

    ANameP_ShowList_DEATHKNIGHT_2 = {
        ["잔존하는 한기"] = { 0, 5, 1 }, --시즌2
        ["서리 열병"] = { 0, 4 },
    },

    ANameP_ShowList_DEATHKNIGHT_3 = {
        ["악성 역병"] = { 1, 4, 1 },
        ["고름 상처"] = { 0, 5 },
    },


    ANameP_ShowList_EVOKER_1 = {
        ["불의 숨결"] = { 0, 5, 1 },
    },

    ANameP_ShowList_EVOKER_2 = {
        ["불의 숨결"] = { 0, 5, 1 },

    },

    ANameP_ShowList_EVOKER_3 = {

        ["시간의 상처"] = { 0, 5, 1 },
    },


    ANameP_ShowList_PALADIN_1 = {
        ["빛의 자락"] = { 0, 5, 1 },
        ["무가치한 존재"] = { 0, 4 },
    },

    ANameP_ShowList_PALADIN_2 = {
        ["심판"] = { 0, 5 },
    },

    ANameP_ShowList_PALADIN_3 = {
        ["심판"] = { 0, 5, 1 },
    },

    ANameP_ShowList_DEMONHUNTER_1 = {
        ["불타는 상처"] = { 0, 5, 1 },
    },

    ANameP_ShowList_DEMONHUNTER_2 = {
        ["불타는 낙인"] = { 0, 5 },
        ["약화"] = { 0, 4 },
    },


};

ANameP_OptionM = {};
local update_callback = nil;

local curr_y = 0;
local y_adder = -50;

local panel = CreateFrame("Frame")
panel.name = "asNamePlates"         -- see panel fields
InterfaceOptions_AddCategory(panel) -- see InterfaceOptions API

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
    btn:SetText("설정 초기화")
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
    Slider:SetMinMaxValues(0.3, 1.1);
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
    btn:SetText("색상 변경")
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

    local x = 10;

    local title = scrollChild:CreateFontString("ARTWORK", nil, "GameFontNormal");
    title:SetPoint("TOPLEFT", x, curr_y);
    title:SetText("우선순위");

    x = 60;

    title = scrollChild:CreateFontString("ARTWORK", nil, "GameFontNormal");
    title:SetPoint("TOPLEFT", x, curr_y);
    title:SetText("디버프명");

    x = x + 150;


    title = scrollChild:CreateFontString("ARTWORK", nil, "GameFontNormal");
    title:SetPoint("TOPLEFT", x, curr_y);
    title:SetText("시간/중첩");

    x = x + 150

    title = scrollChild:CreateFontString("ARTWORK", nil, "GameFontNormal");
    title:SetPoint("TOPLEFT", x, curr_y);
    title:SetText("이름표 색상");

    x = x + 200

    title = scrollChild:CreateFontString("ARTWORK", nil, "GameFontNormal");
    title:SetPoint("TOPLEFT", x, curr_y);
    title:SetText("디법 중첩 알림");

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
        editBox:SetTextInsets(0, 0, 0, 1)
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
            { text = "이름표색상없음", value = 0 },
            { text = "이름표색상변경", value = 1 },
            { text = "이름표색상변경2", value = 2 },

        }

        x = x + 130;

        local dropDown2 = CreateFrame("Frame", nil, scrollChild, "UIDropDownMenuTemplate")
        dropDown2:SetPoint("LEFT", scrollChild, "TOPLEFT", x, curr_y)
        UIDropDownMenu_SetWidth(dropDown2, 100) -- Use in place of dropDown:SetWidth


        local dropdownOptions2 = {
            { text = "중첩으로 알림", value = 1 },
            { text = "시간으로 알림", value = 2 },
        }

        local function updatedata()
            local newspell = editBox:GetText();
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
    btn:SetText("설정 반영")
    btn:SetWidth(100)
    btn:SetScript("OnClick", function()
        for idx, values in pairs(prioritytable) do
            local priority = 6 - idx;
            local spell = values[1];
            local time = values[2];
            local bshowcolor = values[3];
            local bcount = values[4];

            if spell and spell ~= "" then
                ANameP_Options[listname][spell] = { time, priority, bshowcolor, bcount };
            end
        end
        C_Timer.After(1.5, ReloadUI());
    end)
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
    SetupCheckBoxOption("[디버프] 기본에 스팰북 스킬 디버프 추가", "ANameP_ShowKnownSpell");
    SetupCheckBoxOption("[디버프] 내 디버프 모두 보임", "ANameP_ShowMyAll");
    SetupCheckBoxOption("[디버프] List 등록 디버프만 보임", "ANameP_ShowListOnly");
    SetupCheckBoxOption("[버프] 내 버프 모두 보임", "ANameP_ShowPlayerBuffAll");
    SetupCheckBoxOption("[툴팁] 버프/디버프 툴팁 표시", "ANameP_Tooltip");
    SetupCheckBoxOption("[쿨다운] DBM 쿨다운 표시", "ANameP_ShowDBM");
    SetupCheckBoxOption("[색상] 어그로 색상 표시", "ANameP_AggroShow");
    SetupCheckBoxOption("[색상] 낮은 생명력 색상 표시", "ANameP_LowHealthAlert");
    SetupCheckBoxOption("[색상] Quest 몹 색상 표시", "ANameP_QuestAlert");
    SetupCheckBoxOption("[색상] AutoMarker 몹 색상 표시", "ANameP_AutoMarker");


    SetupSliderOption("이름표 상하 정렬 정도 (nameplateOverlapV)", "nameplateOverlapV");
    SetupColorOption("[이름표 색상] 어그로 대상", "ANameP_AggroTargetColor");
    SetupColorOption("[이름표 색상] 어그로 상위", "ANameP_AggroColor");
    SetupColorOption("[탱커 이름표 색상] 어그로 상실", "ANameP_TankAggroLoseColor");
    SetupColorOption("[탱커 이름표 색상] 어그로 다른 탱커", "ANameP_TankAggroLoseColor2");
    SetupColorOption("[이름표 색상] 어그로 소환수", "ANameP_TankAggroLoseColor3");
    SetupColorOption("[이름표 색상] 낮은 체력", "ANameP_LowHealthColor");
    SetupColorOption("[이름표 색상] 디버프", "ANameP_DebuffColor");
    SetupColorOption("[이름표 색상] 디버프2", "ANameP_DebuffColor2");
    SetupColorOption("[이름표 색상] 디버프3", "ANameP_DebuffColor3");
    SetupColorOption("[이름표 색상] Quest", "ANameP_QuestColor");
    SetupColorOption("[이름표 색상] AutoMarker", "ANameP_AutoMarkerColor");
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
