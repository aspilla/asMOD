ANS= nil;
ANS_mainframe = nil;
ANS_SpellList = nil;
ANS_Main= nil;
ANS_SpellNameList = nil;

-- 설정
ANS_SIZE = 30;	


local ANS_CoolButtons_X = -210			-- 쿨 List 위치
local ANS_CoolButtons_Y = 0
local ANS_Alpha = 1
local ANS_CooldownFontSize = 10;
local ANS_ShowActiveAlert = true; 		-- 발동시 테두리 모드 
local ANS_ShowVertical = true			-- 새로로 보이게 ? false로 하면 가로 모드로 변경



-- 	ANS_SpellList_직업명_특성숫자
--[[

	{"스킬명, 0 or 1 or 2 (0은 Main Skill, 2는 광역 스킬 혹은 긴 쿨기 스킬), true or false (마나가 없을때도 알림), 조건 A, 조건 B, 조건C, ...},

	조건 A 와 조건 B와 조건 C를 모두 만족해야 알림

	조건 내용은 아래와 같음

	1. 발동시 알림
	ex {1}

	2. 버프시 알림
	ex {2, "버프이름", "target", 남은시간 혹은 Count, 반대 Check false시 Count보다 크게, Count Check 여부 false 시 남은 시간}
	{2, "난도질", "player", 11, true, false}

	3. 디버프 시 알림
	ex {3, "디버프이름", "target", 남은시간 혹은 Count, 반대 Check false시 Count보다 크게, Count Check 여부 false 시 남은 시간}

	4. Mana 보고 알림
	{4, 마나, unit, reverse, percentage 여부}
	ex {4, 40, "player", true, true}

	5. Power Count 보고 알림
	{5, Power Count, unit, reverse}
	{5, 2, "player", true}

	6. Health 보고 알림
	{6, 체력, unit, reverse}
	{6, 40, "player", true}

	7. Action Count 시 
	{7, action count, do not check max, remain time to charge}
	
	8. 이전 Skill Check (풍운 전용)
	{8}

	9. 특성
	{9, 특성 Line (1 ~ 7), 특성 칸 (1~3), 안찍을 경우면 true}
	{9, 7, 3}

	10. 거리
	11. 토템류

	15. 시전시 알리지 않음
	{15}


	
--]]

--신성
ANS_SpellList_PALADIN_1 = {
};

--보호
----8.0.1 완료
ANS_SpellList_PALADIN_2 = {
	--[[
	{"정의의 방패", 2, false, {2, "정의의 방패", "player", 0.5, true, false}},
	{"수호자의 빛", 2, false, {6, 50, "player", true}},
	{"신성화", 2, false},
	{"심판", 1, false},
	{"응징의 방패", 1, false},
	{"정의의 망치", 0, false},
	]]
};

--징벌
--8.0.1 완료
ANS_SpellList_PALADIN_3 = {
	--[[
	{"파멸의 재", 2, false, {5, 1, "player", true}}, 
	{"심문", 1, false, {2, "심문", "player", 3, true, false}, {5, 2, "player", false}},
	{"심판관의 복수", 2, false}, 
	{"사형 선고", 1, false}, 
	{"기사단의 선고", 1, false}, 
	{"심판의 칼날", 0, false}, 
	{"심판", 1, false}, 
	{"천벌의 망치", 1, false}, 
	{"신성화", 1, false}, 
	{"성전사의 일격", 1, false}, 
	]]
};

-- 야수
--10.0 완료
ANS_SpellList_HUNTER_1 = {
	{"날카로운 사격", 1, false, {2, "광기", "pet", 1.5, true, false}, {2, "광기", "pet", 0, false, false}},
	{"날카로운 사격", 0, false, {7, 2, nil, 2}},
	{"살상 명령", 1, false, {7, 2, nil, 1}},
	{"일제 사격", 2, true, {2, "야수의 회전베기", "pet", 1, true, false}},
	{"야수의 격노", 2, false}, 
	{"살상 명령", 1, false}, 
	{"마무리 사격", 1, false}, 
	{"코브라 사격", 1, false, {14, 70, "player", false, true, 4}},
	{"자동 사격", 1, false},
	
};

--사격
--10.0 완료
ANS_SpellList_HUNTER_2 = {
	
	
	{"마무리 사격", 1, false},
	{"속사", 1, false},
	{"조준 사격", 1, false, {7, 2}},
	{"신비한 사격", 1, false, {1}, {14, 55, "player", false, true, 4}},
	{"신비한 사격", 1, false, {16, "조준 사격"}, {14, 55, "player", false, true, 4}}, 	
	{"조준 사격", 0, false},
	{"고정 사격", 1, true},
};


--생존
--10.0 완료
ANS_SpellList_HUNTER_3 = {
	--[[
	{"야생불 폭탄", 2},
	{"살상 명령",  1, false, {1}},
	{"도살", 1, false, {3, "유산탄","target", 0,  false, false}},
	{"랩터의 일격", 1, false, {3, "유산탄","target", 0,  false, false}},
	{"살상 명령", 1, false, {3, "페로몬 폭탄","target", 0,  false, false}},
	{"랩터의 일격", 1, false, {4, 80, "player", false, false}},
	{"살상 명령",  0},
	{"살쾡이의 이빨",  1, false, {2, "살쾡이의 격노", "player", 0, false, true}},
	{"랩터의 일격", 1, false},	
	]]
};

--혈기
ANS_SpellList_DEATHKNIGHT_1 = {
	--[[
	{"죽음과 부패", 2},
	{"골수분쇄", 1, false, {2, "뼈의 보호막","player", 3, true, false}},
	{"죽음의 일격", 1, false, {4, 100, "player", false, true}},
	{"피의 소용돌이", 1, false, {3, "피의 역병","target", 7.2, true, false}},
	{"골수분쇄", 0, false, {2, "뼈의 보호막","player", 6, true, true}},
	{"심장 강타", 1, false, {5, 3, "player", false}},
	{"피의 소용돌이", 1},
	{"자동 공격", 1},
	]]

};

--냉기
----8.0.1 완료
ANS_SpellList_DEATHKNIGHT_2 = {
	--[[
	{"얼음 결계", 2, false, {9,1,3}, {2, "차가운 마음", "player", 19, false, true}},
	{"냉기의 일격", 1, false, {9,1,2}, {2, "얼음 발톱", "player", 2, true, false}},
	{"울부짖는 한파", 1, false, {3, "서리 열병","target", 3, true, false}},
	{"서리낫", 2, false, {1}, {9, 7, 2}, {2, "얼음 기둥", "player", 0.1, false, false}},
	{"절멸", 1, false, {1}, {9, 7, 2}, {2, "얼음 기둥", "player", 0.1, false, false}},
	{"냉기의 일격", 1, false, {9, 7, 2}, {2, "얼음 기둥", "player", 0.1, false, false}}, 
	{"냉혹한 겨울", 1, false},
	{"울부짖는 한파", 1, false, {1}},
	{"서리낫", 2, false, {1}},
	{"냉기의 일격", 1, false, {4, 90, "player", false, true}, {2, "신드라고사의 숨결", "player", 0.1, true, false}},
	{"절멸", 1, false, {1}},
	{"절멸", 1, false},
	{"겨울의 뿔피리", 2, false},
	{"냉기의 일격", 1, false, {9, 7, 3, true}},
	{"냉기의 일격", 1, false, {9, 7, 3}, {2, "신드라고사의 숨결", "player", 0.1, true, false}},
	{"냉혹한 겨울", 0},
	]]
}; 


--부정
ANS_SpellList_DEATHKNIGHT_3 = {
	--[[
	{"돌발 열병", 1, false, {3, "악성 역병","target", 3, true, false}},
	{"죽음의 고리", 1, false, {4, 100, "player", false, true}},
	{"스컬지의 일격", 1, false, {2, "죽음과 부패","player", 0, false, false}, {3, "고름 상처","target", 1, false, true}},
	{"스컬지의 일격", 1, false, {2, "괴사","player", 0, false, false}, {3, "고름 상처","target", 1, false, true}},
	{"죽음의 고리", 1, false, {1}},
	{"고름 일격", 1, false, {3, "고름 상처","target", 4, true, true}},
	{"죽음과 부패", 2, false},
	{"스컬지의 일격", 1, false, {3, "고름 상처","target", 3, false, true}},
	{"죽음의 고리", 1, false, {4, 70, "player", false, true}},
	{"죽음의 일격", 1, false, {1}},
	{"자동 공격", 1, false},
	{"고름 일격", 0, true},
	]]

};


--무기
----8.0.1 완료
ANS_SpellList_WARRIOR_1 = {
	
	{"분쇄", 2, false, {3, "분쇄", "target", 4, true, false}},-- 분쇄 타겟 디버프 4 초
	{"거인의 강타", 2, false},
	{"필사의 일격", 0, false, {3, "치명상", "target", 1, true, false}},
	{"마무리 일격", 1, false},
	{"필사의 일격", 1, false},	
	{"제압", 1, false, {4, 70, "player", true, false}},
	{"격돌", 1, false},
	{"자동 공격", 1},
}; 


--분노
----8.0.1 완료
ANS_SpellList_WARRIOR_2 = {
	{"광란", 1, false, {2, "격노","player", 0.1, true, false}}, -- 격노 없을 때 
	{"마무리 일격", 1, false}, -- 격노 있을 때
	{"분노의 강타", 0, false, {9, "파멸자", true}},
	{"피의 갈증", 1, false},
	{"소용돌이", 1, false},
}; 




-- 방어
-- 8.0.1 완료
ANS_SpellList_WARRIOR_3 = {
	--[[
	{"연전연승", 1, false, {6, 70, "player", true, false}},
	{"방패 올리기", 2, false, {9, 4, 3, true}, {2, "방패 올리기","player", 0.3, true, false}},
	{"방패 올리기", 2, false, {9, 4, 3}, {2, "방패 올리기","player", 0.3, true, false}, {2, "최후의 저항","player", 0.3, true, false}},
	{"고통 감내", 2, false, {4, 90, "player", false, false}},
	{"천둥벼락", 1, false, {30, "고막파열 강타"}, {3, "사기의 외침", "target", 0.1, false, false} },
	{"방패 밀쳐내기", 1, false},
	{"천둥벼락", 0},
	{"복수", 1, false, {1}},
	{"압도", 1, false, {9, 6, 3, true}}, 
	{"자동 공격", 1},
	]]
}; 

--양조
----8.0.1 완료
ANS_SpellList_MONK_1 = {
	--[[
	{"무쇠가죽주", 2, false, {2, "무쇠가죽주","player", 1.5, true, false}},
	{"해악 축출", 2, false, {6, 30, "player", true, false}},
	{"범의 장풍", 1, false, {9, 7, 3}, {2, "의식 상실 연계", "player", 0, false, false}},
	{"맥주통 휘두르기", 0},
	{"의식 상실의 일격", 1},
	{"불의 숨결", 1},
	{"비취 돌풍", 1, false, {2, "비취 돌풍","player", 0.3, true, false}},
	{"범의 장풍", 1, false, {4, 65, "player", false, true}}, 
	{"기의 물결", 1},
	{"기의 파동", 1, {15}},
	]]
}; 

--운무
ANS_SpellList_MONK_2 = {
}; 

--풍운
----8.0.1 완료
ANS_SpellList_MONK_3 = {
	--[[
	{"비취 돌풍", 2, false, {8}},
	{"백호의 주먹", 1, false, {8}, {5, 2, "player", true},{4, 99, "player", false, true}},
	{"범의 장풍", 1, false, {8}, {5, 4, "player", true},{4, 99, "player", false, true}},
	{"소용돌이 용의 주먹", 1, false, {8}},
	{"해오름차기", 1, false, {8}},
	{"분노의 주먹", 1, false, {8}},
	{"기의 파동", 1, false, {8}, {5, 3, "player", true}, {15}},
	{"회전 학다리차기", 2, false, {8}, {7, 3}},
	{"백호의 주먹", 1, false, {8}, {5, 2, "player", true}},
	{"후려차기", 1, false, {8}},
	{"기의 물결", 1, false, {8}},
	{"범의 장풍", 1, false, {8}},
	]]
}; 


--고통
----8.0.1 완료
ANS_SpellList_WARLOCK_1 = {

	--[[
	{"부패의 씨앗", 2, false},
	{"고통", 1, false, {3, "고통","target", 18 * 0.3, true, false}},
	{"부패", 1, false, {3, "부패","target", 14 * 0.3, true, false}},
	{"생명력 착취", 1, false, {3, "생명력 착취","target", 15 * 0.3, true, false}},
	{"불안정한 고통", 1, false, {5, 5, "player", false}, {15}},
	{"유령 출몰", 1, false},
	{"유령 특이점", 2, false},
	{"사악한 타락", 2, false},
	{"죽음의 화살", 1, false, {3, "불안정한 고통","target", 8 * 0.3, false, false}},
	{"불안정한 고통", 1, false, {3, "불안정한 고통","target", 8 * 0.3, true, false},{15}},
	{"어둠의 화살", 0, true},
	]]
}; 
--악마
----8.0.1 완료
ANS_SpellList_WARLOCK_2 = {
	--[[
	{"담즙스컬지 폭격", 2, false},
	{"썩은마귀 소환", 2, false},
	{"파멸", 2, false, {3, "파멸","target", 0.1, true, false}},
	{"공포사냥개 부르기",1, true, {5, 2, "player", false}}, 
	{"굴단의 손", 1, true, {5, 4, "player", false}}, 
	{"악마 화살", 1, false,{2, "악마의 핵", "player", 1, false, false}},
	{"마력 착취", 2, false},
	{"굴단의 손", 1, true, {5, 3, "player", false}}, 
	{"영혼의 일격", 1, false},
	{"어둠의 화살", 1, true},
	{"공포사냥개 부르기",0 }
	]]
};


--파괴
----8.0.1 완료
ANS_SpellList_WARLOCK_3 = {

	--[[
	{"제물", 1, false, {3, "제물","target", 18 * 0.3, true, false}, {15}},
	{"혼돈의 화살",1, false, {5, 5, "player", false}},
	{"점화", 1, false, {7, 2}},
	{"악마불 집중",1, false},
	{"혼돈의 화살", 1, false, {9,1,2}, {3, "박멸","target", 7 * 0.3, true, false}, {15}},
	{"대재앙", 2, false},
	{"어둠의 연소", 2, false},
	{"영혼의 불꽃",1, false},
	{"점화", 0, false},
	{"소각", 1, true},
	]]
}; 


--정기
----8.0.1 완료
ANS_SpellList_SHAMAN_1 = {
	--[[
	{"토템 특화", 1, false, {11, "토템 특화", 0.1, true}},
	{"화염 충격", 1, false, {3, "화염 충격","target", 6, true, false}},
	{"번개 화살", 1, false, {15},{3, "노출된 원소","target", 2, false, false}},
	{"대지 충격", 1, false, {4, 60, "player", false, true}, {2, "원소의 대가", "player", 0, false, false}},
	{"정기 작렬", 1, false, {15}},
	{"마그마 토템", 2, false},
	{"연쇄 번개", 2, false, {20, "연쇄 번개", 3}},
	{"대지 충격", 1, false, {4, 90, "player", false, true}},
	{"용암 폭발", 0, false, {15} },
	{"얼음격노", 1, false, {15}},
	{"냉기 충격", 1, false, {2, "얼음격노", "player", 0, false, false }},
	{"토템 특화", 1, false, {11, "토템 특화", 9, true}},
	{"번개 화살", 1},
	]]
}; 

--고양
----8.0.1완료
ANS_SpellList_SHAMAN_2 = {
	--[[
	{"바람의 격노", 1, false, {9, 6, 2}, {2, "바람의 격노", "player", 0.1, true, false}},
	{"토템 특화", 1, false, {11, "토템 특화", 0.1, true}},
	{"폭풍의 일격", 1, false, {2, "승천", "player", 0.1, false, false} },
	{"불꽃혓바닥", 1, false, {2, "불꽃혓바닥", "player", 0.1, true, false}},
	{"대지의 쐐기", 1, false},
	{"냉기의 무기", 1, false, {9, 4, 2}, {2, "냉기의 무기", "player", 0.1, true, false}},
	{"폭풍의 일격", 0, false, {1}},
	{"용암 채찍", 1, false, {1}},
	{"폭풍의 일격", 1, false},
	{"낙뢰", 2, false},
	{"번개 화살", 1, false, {9, 4, 3}, {4, 50, "player", false, false}},
	{"불꽃혓바닥", 1, false, {9, 4, 1}},
	{"대지이빨", 1, false, {7,2} , {4, 70, "player", true, false}},
	{"불꽃혓바닥", 1, false, {2, "불꽃혓바닥", "player", 4.5, true, false}},
	{"냉기의 무기", 1, false, {9, 4, 2}, {2, "냉기의 무기", "player", 4.5, true, false}},
	{"용암 채찍", 1, false, {4, 50, "player", false, false}},
	{"대지이빨", 1, false},
	]]
}; 

--복원
ANS_SpellList_SHAMAN_3 = {
};

--수양
----7.1.5 완료
ANS_SpellList_PRIEST_1 = {
	
};

--신성
ANS_SpellList_PRIEST_2 = {
};

--암흑
----8.0.1 완료
ANS_SpellList_PRIEST_3 = {
	--[[
	{"어둠의 권능: 고통", 1, false, {9, 3, 2, true}, {3, "어둠의 권능: 고통","target", 5.4, true, false}},
	{"흡혈의 손길", 1, false, {3, "흡혈의 손길","target", 4, true, false}, {15}},
	{"공허 방출", 1, false, {2, "공허의 형상","player", 0, false, false}},
	{"공허 방출", 2, false, {1}},
	{"정신 분열", 0, false, {9, 1, 3, true}, {15}},
	{"어둠의 권능: 공허", 1, false, {9, 1, 3}, {7, 2}},
	{"어둠의 권능: 죽음", 1, false, {2, "공허의 형상","player", 0, false, false}},
	{"어둠의 권능: 죽음", 1, false, {7, 2}},
	{"어둠 붕괴", 2, false},
	{"공허의 격류", 1, false},
	{"어둠의 권능: 공허", 1, false, {9, 1, 3}, {7, 1}},
	{"정신의 채찍", 1},
	]]
};


--조화
----8.0.1 완료
ANS_SpellList_DRUID_1 = {
	--[[
	{"태양섬광", 1, false, {3, "태양섬광","target", 18 * 0.3, true, false}},

	{"달빛섬광", 1, false, {3, "달빛섬광","target", 22 * 0.3, true, false}},
	{"항성의 섬광", 1, false, {3, "항성의 섬광","target", 24 * 0.3, true, false}},
	{"달의 일격", 1, false, {7, 3, true}},
	{"태양의 격노", 1, false, {7, 3, true}},
	{"별빛쇄도", 1, true, {4, 40, "player", false, false}},
	{"초승달", 0, false, {7, 3, true}},
	{"달의 일격", 1, false, {2, "올빼미야수의 광기","player", 0, false, false}},
	{"달의 일격", 1, false, {7, 2, true}},
	{"달의 일격", 1, false, {7, 1, true}},
	{"태양의 격노", 1, false, {7, 2, true}},
	{"태양의 격노", 1, false, {7, 1, true}},
	{"초승달", 1, false},
	{"태양의 격노", 1},
	]]
}; 

--야성
----7.1.5 완료
ANS_SpellList_DRUID_2 = {
	--[[
	{"호랑이의 분노", 2, false, {4, 40, "player", true, false}},
	{"도려내기", 1, false, {3, "도려내기", "target", 19.2 * 0.3, true, false}, {5, 5, "player", false, false}},
	{"도려내기", 1, false, {9, 7, 2}, {3, "도려내기", "target", 10, true, false}, {2, "피투성이 손길", "player", 0, false, false},{5, 5, "player", false, false}},
	{"야생의 포효", 1, true, {2, "야생의 포효", "player", 12 * 0.3, true, false}},
	{"갈퀴 발톱", 1, true, {3, "갈퀴 발톱","target", 12 * 0.3, true, false}, {5, 5, "player", true, false}},
	{"잔혹한 베기", 1, true, {9, 6, 2}, {7,3}},
	{"칼날 발톱", 1, false, {4, 40, "player", false, false}, {5, 5, "player", true, false}},
	{"재생", 1, false, {9, 7, 2}, {2, "야생의 신속함", "player", 1, false, false}},
	{"잔혹한 베기", 1, true, {9, 6, 2}, {2, "번뜩임", "player", 0, false, false}},
	{"칼날 발톱", 1, false, {2, "번뜩임", "player", 0, false, false}},
	{"흉포한 이빨", 1, false, {6, 25, "target", true}, {3, "도려내기", "target", 0, false, false}, {3, "도려내기", "target", 7.2, true, false}},
	{"흉포한 이빨", 1, false, {9, 6, 1}, {3, "도려내기", "target", 0, false, false}, {3, "도려내기", "target", 7.2, true, false}},
	{"야성의 광기", 0, false, {9, 7, 3}},
	{"달빛섬광", 1, false, {9, 1, 3}, {3, "달빛섬광", "target", 4.8, true, false}},
	{"흉포한 이빨", 1, false, {4, 70, "player", false, false}},
	{"자동 공격", 1, false},
	]]

}; 

-- 수호
-- --8.0.1 완료
ANS_SpellList_DRUID_3 = {
	--[[
	{"무쇠가죽", 2, false, {2, "무쇠가죽","player", 0.3, true, false}},
	{"달빛섬광", 1, false, {3, "달빛섬광","target", 4.8, true, false}},
	{"파쇄", 1, false, {3, "난타", "target", 1, false, true}, {2, "파쇄","player", 3, true, false}},
	{"짓이기기", 1},
	{"난타", 1}, 
	{"달빛섬광", 1, false, {1}},
	{"후려갈기기", 1, false, {4, 80, "player", false, false}},
	{"휘둘러치기", 1}, 
	]]
};
-- 회복

ANS_SpellList_DRUID_4 = {
};

-- 비전
--8.0.1 완료
ANS_SpellList_MAGE_1 = {
	--[[
	{"충전 완료", 2, false, {5, 1, "player", true}},
	{"황천의 폭풍우", 1, false, {5, 4, "player", false} ,{3, "황천의 폭풍우", "target", 4, true, false}},
	{"비전 보주", 2, false, {5, 4, "player", true}},
	{"마력의 룬", 2, false, {5, 4, "player", false} },
	{"비전 작렬", 1, false, {2, "3의 법칙", "player", 0.1, false, false}, {15}},
	{"신비한 폭발", 2, false, {2, "신비의 마법 강화", "player", 0.1, false, false}},
	{"신비한 화살", 1, false, {1}, {9,1,1}, {2, "신비의 마법 강화", "player", 0.1, false, false}},
	{"비전 작렬", 1, false, {2, "신비의 마법 강화", "player", 0.1, false, false}},
	{"신비한 화살", 1, false, {1}},
	{"비전 탄막", 1, false, {4, 80, "player", true, true}, {5, 4, "player", false}, {2, "마력의 룬", "player", 0.1, true, false}},
	{"신비한 폭발", 2, false},
	{"초신성", 1},
	{"비전 작렬", 1},
	{"신비한 화살", 0},
	]]
};

--화염
--8.0.1 완료
ANS_SpellList_MAGE_2 = {
	--[[
	{"불덩이 작렬", 1, true, {2, "몰아치는 열기!", "player", 0.1, false, false}},
	{"불덩이 작렬", 1, false,{6, 30, "target", true}, {2, "열기","player", 0.1, false, false}, {16, "불태우기"}},
	{"불덩이 작렬", 1, false, {2, "발화", "player", 0.1, false, false}, {2, "열기","player", 0.1, false, false}, {16, "불태우기"}},
	{"불사조의 불길", 1, false, {2, "열기","player", 0.1, true, false}, {2, "발화", "player", 0.1, false, false}},
	{"화염 작렬", 1, false, {6, 30, "target", true} ,{2, "열기","player", 0.1, true, false}, {16, "불태우기"}},
	{"불태우기", 1, false, {6, 30, "target", true}},
	{"화염 작렬", 1, false, {2, "열기","player", 0.1, false, false}},
	{"화염구", 1},
	{"화염 작렬", 0},
	]]
};

--냉기
--8.0.1 완료
ANS_SpellList_MAGE_3 = {
	--[[
	{"마력의 룬", 2, false, {7, 2}},
	{"눈보라", 2, false},
	{"얼음창", 1, false, {3, "혹한의 추위", "target", 0, false, false}},
	{"얼음창", 1, false, {3, "얼음 회오리", "target", 0, false, false}},
	{"얼음창", 1, false, {12, "진눈깨비"}},
	{"얼음창", 1, false, {2, "서리의 손가락", "player", 1, false, true}},
	{"얼음창", 1, false, {2, "서리의 손가락", "player", 0, false, true}, {2, "서리의 손가락", "player", 2, true, false}},
	{"진눈깨비", 1, false, {1}, {16, "혹한의 쐐기"}},
	{"진눈깨비", 1, false, {1}, {9, 7, 3, true}, {16, "얼음 화살"}},
	{"진눈깨비", 1, false, {2, "고드름", "player", 4, true, true}, {16, "칠흑화살"}},
	{"진눈깨비", 1, false, {1}, {9, 7, 3}, {2, "고드름", "player", 3, true, true}, {16, "얼음 화살"} },
	{"얼음창", 1, false, {2, "서리의 손가락", "player", 0, false, true}, {2, "두뇌 빙결", "player", 0, false, false}},
	{"칠흑화살", 1, false, {2, "고드름", "player", 4, true, true}, {2, "두뇌 빙결", "player", 0.1, true, false}},
	{"얼어붙은 구슬", 2, false, {2, "서리의 손가락", "player", 0, true, true}},
	{"얼음창", 1, false, {2, "서리의 손가락", "player", 0, false, true}},
	{"혹한의 쐐기", 1, false, {1}, {2, "두뇌 빙결", "player", 0, false, false} , {15}},
	{"혹한의 쐐기", 1, true, {2, "두뇌 빙결", "player", 2.8, false, false}, {2, "고드름", "player", 3, false, true}, {15}, {16, "얼음 화살"} },
	{"혹한의 쐐기", 1, false, {1}, {15}, {16, "칠흑화살"} },
	{"칠흑화살", 1, false, {9, 7, 3}, {2, "두뇌 빙결", "player", 0.1, true, false}, {2, "고드름", "player", 4, false, true}},
	{"칠흑화살", 1, false, {9, 7, 3}, {2, "두뇌 빙결", "player", 0.1, true, false}, {2, "고드름", "player", 3, false, true}, {16, "얼음 화살"}},
	{"혜성 폭풍", 2},
	{"얼음 화살", 1},
	{"얼음창", 0},
	]]
};

--암살
----8.0.1 완료
ANS_SpellList_ROGUE_1 = {
	--[[
	{"파열", 1, true, {5, 2, "player", true, true}, {3, "파열", "target", 4, true, false}},
	{"독살", 1, true, {5, 8, "player", false}},
	{"맹독 칼날", 2, true},
	{"독살", 1, true, {5, 2, "player", true, true}},
	{"목조르기", 0, true, {3, "목조르기", "target", 4, true, false}},
	{"방혈", 2, true,{3, "목조르기", "target", 10, false, false},{3, "파열", "target", 20, false, false}},
	{"죽음의 표적", 2, true, {5, 2, "player", true} },
	{"칼날 부채", 2, true, {9, 7, 2}, {2, "숨겨진 칼날","player", 19, false, true} },
	{"독칼", 1, true, {2, "날카로운 날","player", 29, false, true} },
	{"사각 지대", 1, true, {1}},
	{"절단", 1, true},
	]]

};

--무법
----8.0.1 완료

ANS_SpellList_ROGUE_2 = {
	--[[
	{"뼈주사위", 2, true, {2, "무자비한 정밀함", "player", 3.6, true, false}, {2, "숨겨진 보물", "player", 3.6, true, false}, {2, "집중 공격", "player", 3.6, true, false}, {2, "진방위", "player", 3.6, true, false}, {2, "대난투", "player", 3.6, true, false}, {2, "해적 징표", "player", 3.6, true, false}},
	{"난도질", 2, true, {2, "난도질", "player", 10.8, true, false}},
	{"유령의 일격", 1, true, {3, "유령의 일격", "target", 4.5, true, false}},
	{"미간 적중", 1, true, {5, 4, "player", false}, {2, "무자비한 정밀함", "player", 0, false, false}},
	{"미간 적중", 1, true, {5, 4, "player", false}, {30, "필살탄"}},
	{"죽음의 표적", 2, true, {5, 2, "player", true} },
	{"속결", 1, true, {5, 4, "player", false}},
	{"권총 사격", 1, true, {2, "기회", "player", 0, false, false}},
	{"사악한 일격", 1, true},
	]]
}; 

--잠행
----8.0.1 완료

ANS_SpellList_ROGUE_3 = {
	--[[
	{"암흑칼날", 1, true, {3, "암흑칼날", "target", 4.8, true, false}},
	{"어둠의 춤", 2, true, {2, "어둠의 춤", "player", 0.1, true, false}, {2, "기만", "player", 0.1, true, false} },
	{"죽음의 상징", 2, true},
	{"은밀한 기술", 2, true, {5, 8, "player", false}},
	{"절개", 1, true, {5, 8, "player", false}},
	{"그림자 일격", 1, true},
	{"죽음의 표적", 2, true, {5, 2, "player", true} },
	{"기습", 1, true},
	]]
};

--파멸
----8.0.1완료
ANS_SpellList_DEMONHUNTER_1 = {
	
	{"안광", 2, false},	
	{"혼돈의 일격", 1, false, {1}},
	{"칼춤", 1, false},
	{"지옥칼", 0, false, {4, 80, "player", true, false} },
	{"제물의 오라", 1, false},
	{"혼돈의 일격", 1, false},
	{"악마의 이빨", 1, false},
};

--복수
----8.0.1 완료
ANS_SpellList_DEMONHUNTER_2 = {
	--[[
	{"악마 쐐기", 2, false, {2, "악마 쐐기", "player", 0.5, true, false} },
	{"영혼 베어내기", 2, false},
	{"균열", 1, false, {4, 75, "player", true, false} },
	{"제물의 오라", 0, false},
	{"지옥칼", 1, false,{4, 70, "player", true, false} },
	{"불꽃의 인장", 2, false},
	{"절단", 1, false},
]]
};

ANS_SpellList_EVOKER_1 = {
	
};

--복수
----8.0.1 완료
ANS_SpellList_EVOKER_2 = {

};

local update = 0;
local prev_i = {0, 0, 0};
local prev_s = {0, 0, 0};
local prev_d = {0, 0, 0};
local prev_v = {0, 0, 0};
local prev_c = {0, 0, 0};
local active_list = {};
local ANS_UNIT_POWER;
local ANS_POWER_LEVEL = nil; 
local check_prev = false;
local prev_skill = nil;
local prev_time = nil;
local prev_count = 0;
local prev_skill2 = nil;
local prev_time2 = nil;

local prev_idx = nil;

local ANS_Action_slot_list = {}
local ANS_Bonus_IDs = {}
local ANS_Item_IDs = {}


local bupdate_partial_power = false;


local PowerTypeString = {}
PowerTypeString = {[Enum.PowerType.Insanity] = "광기", [Enum.PowerType.Maelstrom] = "소용돌이", [Enum.PowerType.LunarPower] = "천공의 힘"};

local PowerTypeComboString = {}
PowerTypeComboString = {[Enum.PowerType.SoulShards] = "영혼의 조각", [Enum.PowerType.ArcaneCharges] = "비전 충전물이" };


local SpellGetCosts = {};
local SpellGetPowerCosts = {};

local smackloc



--Overlay stuff
local unusedOverlayGlows = {};
local numOverlays = 0;
local function ANS_ActionButton_GetOverlayGlow()
	local overlay = tremove(unusedOverlayGlows);
	if ( not overlay ) then
		numOverlays = numOverlays + 1;
		overlay = CreateFrame("Frame", "ANS_ActionButtonOverlay"..numOverlays, UIParent, "ANS_ActionBarButtonSpellActivationAlert");
	end
	return overlay;
end

-- Shared between action button and MainMenuBarMicroButton
local function ANS_ShowOverlayGlow(button)
	if ( button.overlay ) then
		if ( button.overlay.animOut:IsPlaying() ) then
			button.overlay.animOut:Stop();
			button.overlay.animIn:Play();
		end
	else
		button.overlay = ANS_ActionButton_GetOverlayGlow();
		local frameWidth, frameHeight = button:GetSize();
		button.overlay:SetParent(button);
		button.overlay:ClearAllPoints();
		--Make the height/width available before the next frame:
		button.overlay:SetSize(frameWidth * 1.3, frameHeight * 1.3);
		button.overlay:SetPoint("TOPLEFT", button, "TOPLEFT", -frameWidth * 0.3, frameHeight * 0.3);
		button.overlay:SetPoint("BOTTOMRIGHT", button, "BOTTOMRIGHT", frameWidth * 0.3, -frameHeight * 0.3);
		button.overlay.animIn:Play();
	end
end

-- Shared between action button and MainMenuBarMicroButton
local function ANS_HideOverlayGlow(button)
	if ( button.overlay ) then
		if ( button.overlay.animIn:IsPlaying() ) then
			button.overlay.animIn:Stop();
		end
		if ( button:IsVisible() ) then
			button.overlay.animOut:Play();
		else
			button.overlay.animOut:OnFinished();	--We aren't shown anyway, so we'll instantly hide it.
		end
	end
end

ANS_ActionBarButtonSpellActivationAlertMixin = {};

function ANS_ActionBarButtonSpellActivationAlertMixin:OnUpdate(elapsed)
	AnimateTexCoords(self.ants, 256, 256, 48, 48, 22, elapsed, 0.01);
	local cooldown = self:GetParent().cooldown;
	-- we need some threshold to avoid dimming the glow during the gdc
	-- (using 1500 exactly seems risky, what if casting speed is slowed or something?)
	if(cooldown and cooldown:IsShown() and cooldown:GetCooldownDuration() > 3000) then
		self:SetAlpha(0.5);
	else
		self:SetAlpha(1.0);
	end
end

function ANS_ActionBarButtonSpellActivationAlertMixin:OnHide()
	if ( self.animOut:IsPlaying() ) then
		self.animOut:Stop();
		self.animOut:OnFinished();
	end
end

ANS_ActionBarOverlayGlowAnimInMixin = {};

function ANS_ActionBarOverlayGlowAnimInMixin:OnPlay()
	local frame = self:GetParent();
	local frameWidth, frameHeight = frame:GetSize();
	frame.spark:SetSize(frameWidth, frameHeight);
	frame.spark:SetAlpha(0.3);
	frame.innerGlow:SetSize(frameWidth / 2, frameHeight / 2);
	frame.innerGlow:SetAlpha(1.0);
	frame.innerGlowOver:SetAlpha(1.0);
	frame.outerGlow:SetSize(frameWidth * 2, frameHeight * 2);
	frame.outerGlow:SetAlpha(1.0);
	frame.outerGlowOver:SetAlpha(1.0);
	frame.ants:SetSize(frameWidth * 0.85, frameHeight * 0.85)
	frame.ants:SetAlpha(0);
	frame:Show();
end

function ANS_ActionBarOverlayGlowAnimInMixin:OnFinished()
	local frame = self:GetParent();
	local frameWidth, frameHeight = frame:GetSize();
	frame.spark:SetAlpha(0);
	frame.innerGlow:SetAlpha(0);
	frame.innerGlow:SetSize(frameWidth, frameHeight);
	frame.innerGlowOver:SetAlpha(0.0);
	frame.outerGlow:SetSize(frameWidth, frameHeight);
	frame.outerGlowOver:SetAlpha(0.0);
	frame.outerGlowOver:SetSize(frameWidth, frameHeight);
	frame.ants:SetAlpha(1.0);
end

ANS_ActionBarOverlayGlowAnimOutMixin = {};

function ANS_ActionBarOverlayGlowAnimOutMixin:OnFinished()
	local overlay = self:GetParent();
	local actionButton = overlay:GetParent();
	overlay:Hide();
	tinsert(unusedOverlayGlows, overlay);
	actionButton.overlay = nil;
end



local function asGetCostTooltipInfo (spellID)
    if not spellID then return end

	local cost = SpellGetCosts[spellID] 


	-- 8.0 change need
	--
	if cost then

		local powerType = UnitPowerType("player");
		local mana = UnitPower("player", powerType);
		local max = UnitPowerMax("player", powerType);
		
		local ret = math.min((max - mana), cost) 
		return 0 - ret;
	end

	return  0;
end

local function asGetPowerCostTooltipInfo (spellID)
    if not spellID then return end

	local cost = SpellGetPowerCosts[spellID] 


	-- 8.0 change need
	--
	if cost then
		return 0 - cost;
	end

	return  0;
end




local function checkSpellCost(id)


	local i = 1
	if id then
		local spell = Spell:CreateFromSpellID(id);
		spell:ContinueOnSpellLoad(function()
			local costText = spell:GetSpellDescription();
			local powerType = UnitPowerType("player");

			if  costText and PowerTypeString[powerType] and string.match(costText,  PowerTypeString[powerType] ) and string.match(costText,  "생성" )   then
				local findstring = "%d의 "..PowerTypeString[powerType];
				local start = string.find(costText, findstring, 0);
		
			
				if start and start > 5 then

					local costText2 = string.sub(costText, start-5);
					local s2 = string.find(costText2, findstring, findstring:len() + 5);

					if (s2) and s2 > 5 then
						costText2 = string.sub(costText2, s2-5);
					end

					local cost = gsub(costText2, "[^0-9]", "")
					if tonumber(cost) > 0 then
						SpellGetCosts[id] = tonumber(cost);
					end
				end
			end
		end)
		return;
	end

	--[[
	while true do
		local spellName, _, spellID = GetSpellBookItemName (i, BOOKTYPE_SPELL)

		if not spellName then
			do break end
		end
		if spellID then
			local spell = Spell:CreateFromSpellID(spellID);
			spell:ContinueOnSpellLoad(function()
				local costText = spell:GetSpellDescription();
				local powerType = UnitPowerType("player");

				if  costText and PowerTypeString[powerType] and string.match(costText,  PowerTypeString[powerType] ) and string.match(costText,  "생성" )   then
					local findstring = "%d의 "..PowerTypeString[powerType];
					local start = string.find(costText, findstring, 0);
					if start and start > 10 then
						local costText2 = string.sub(costText, start - 5);
						local cost = gsub(costText2, "[^0-9]", "")
						if tonumber(cost) > 0 then
							SpellGetCosts[spellID] = tonumber(cost);
						end
					end
				end
			end)
		end

	
		i = i + 1
	end
	--]]

end


local function checkSpellPowerCost(id)


	local i = 1

	if not ANS_POWER_LEVEL then
		return;
	end

	local powerTypeString = PowerTypeComboString[ANS_POWER_LEVEL];


	local localizedClass, englishClass = UnitClass("player")
	local spec = GetSpecialization();
	local disWarlock = false;

	if (englishClass == "WARLOCK") then
		if (spec and spec == 3) then
			powerTypeString = "영혼의 조각 파편";
			disWarlock = true;
		end
	end




	if id then
		local spell = Spell:CreateFromSpellID(id);
		spell:ContinueOnSpellLoad(function()
			local costText = spell:GetSpellDescription();

			if  costText and powerTypeString and string.match(costText, powerTypeString ) and string.match(costText,  "생성" )   then
				local findstring = "%d의 "..powerTypeString;
				local start = string.find(costText, findstring, 0);
				if start and start > 10 then
					local costText2 = string.sub(costText, start - 5);
					local cost = gsub(costText2, "[^0-9]", "")
					if tonumber(cost) > 0 then
						
						if disWarlock then

							SpellGetPowerCosts[id] = tonumber(cost) / 10;

						else
							SpellGetPowerCosts[id] = tonumber(cost);

						end
						return;
					end
				end


				local findstring = powerTypeString .. " %d개";
				local start = string.find(costText, findstring, 0);
				if start and start > 10 then
					local costText2 = string.sub(costText, start);
					local start2 = string.find(costText2, "합니다.", 0);
					local costText2 = string.sub(costText2, 0, start2);
					local cost = gsub(costText2, "[^0-9]", "")
					if tonumber(cost) > 0 then
						
						if disWarlock then
							SpellGetPowerCosts[id] = tonumber(cost) / 10;
						else
							SpellGetPowerCosts[id] = tonumber(cost);

						end
						return;
					end
				end


			end
		end)

		return;
	end

end




local function getUnitBuffbyName(unit, buff, filter)

	local i = 1;
	repeat

		local name = UnitBuff(unit, i, filter);

		if name == buff then
			return 	UnitBuff(unit, i, filter);
		end

		i = i + 1;


	until (name == nil)

	return nil;
end



local function getUnitDebuffbyName(unit, buff, filter)

	local i = 1;
	repeat

		local name = UnitDebuff(unit, i, filter);

		if name == buff then
			return 	UnitDebuff(unit, i, filter);
		end

		i = i + 1;


	until (name == nil)

	return nil;
end





local function HowManyHasSet(setID)
    local itemList = C_LootJournal.GetItemSetItems(setID)
    if not itemList then return end
    local setName = GetItemSetInfo(setID)
    local max = #itemList
    local equipped = 0
    for _,v in ipairs(itemList) do
        if IsEquippedItem(v.itemID) then
            equipped = equipped + 1
        end
    end
    return equipped;
end

local ANS_AzeriteTraits = {}; 

local function GetAzeritePowerID(spellID)
	local powerInfo = C_AzeriteEmpoweredItem.GetPowerInfo(spellID)
    	if (powerInfo) then
            local azeriteSpellID = powerInfo["spellID"]
            return azeriteSpellID
        end
end


local function checkAzerite()

	local slotNames = {"HeadSlot", "NeckSlot", "ShoulderSlot", "BackSlot", "ChestSlot", "ShirtSlot", "TabardSlot", "WristSlot", "HandsSlot", "WaistSlot", "LegsSlot", "FeetSlot", "Finger0Slot", "Finger1Slot", "Trinket0Slot", "Trinket1Slot", "MainHandSlot", "SecondaryHandSlot", "AmmoSlot" };    
    local index = 1
   
	ANS_AzeriteTraits = {};
   
    local azeriteItemLocation = C_AzeriteItem.FindActiveAzeriteItem()
    if azeriteItemLocation  then
        for slotNum=1, #slotNames do
            local slotId = GetInventorySlotInfo(slotNames[slotNum])
            local itemLink = GetInventoryItemLink('player', slotId)
            
            if itemLink ~= nil then
                
                local azeriteItemLocation = C_AzeriteItem.FindActiveAzeriteItem()
                local currentLevel = C_AzeriteItem.GetPowerLevel(azeriteItemLocation)
                local allTierInfo = C_AzeriteEmpoweredItem.GetAllTierInfoByItemID(itemLink)
                local itemLoc = ItemLocation:CreateFromEquipmentSlot(slotId)
                
                if itemLoc and C_AzeriteEmpoweredItem  then
                    if C_AzeriteEmpoweredItem.IsAzeriteEmpoweredItem(itemLoc) then
                        
                        local  tierInfo = C_AzeriteEmpoweredItem.GetAllTierInfo(itemLoc)
                        for azeriteTier, tierInfo in pairs(tierInfo) do
                            for i, idx in pairs(tierInfo.azeritePowerIDs) do
                                if C_AzeriteEmpoweredItem.IsPowerSelected(itemLoc, idx) then
                                    local azeriteSpellID = GetAzeritePowerID(idx)
                                    if azeriteSpellID ~= 263978  then
                                   		local azeritePowerName, _, icon = GetSpellInfo(azeriteSpellID)
										ANS_AzeriteTraits[azeritePowerName] = 1

                                    end                         
                                    
                                end
                            end
                        end
                    end
                end
                
            end
        end
   end


    
end



function ANS_Alert(i, idx)

	if ANS_SpellList[i] == nil then
		ANS:Hide();
		ANSMain:Hide();
		ANS2:Hide();
		return
	end	

	local discard,discard,icon = GetSpellInfo(ANS_SpellList[i][1])
	local start, duration, enable = GetSpellCooldown(ANS_SpellList[i][1]);
	local charges, maxCharges, chargeStart, chargeDuration, chargeModRate; 
	local isUsable, notEnoughMana = IsUsableSpell(ANS_SpellList[i][1]);
	local _, gcd  = GetSpellCooldown(61304);
	local count = 0;
	local valid = 0;
	local chargecool = false;

	if isUsable and duration > gcd then
		isUsable = false
	end

	if ANS_Action_slot_list[i] then
		count = GetActionCount(ANS_Action_slot_list[i]);
		charges, maxCharges, chargeStart, chargeDuration, chargeModRate = GetActionCharges(ANS_Action_slot_list[i]);
	end

	if count == nil or count == 0 then
		count = GetSpellCharges(ANS_SpellList[i][1]);
		charges, maxCharges, chargeStart, chargeDuration, chargeModRate = GetSpellCharges(ANS_SpellList[i][1]);
		if count == 1 and (not maxCharges or maxCharges <= 1) then
			count = 0;
		end

	end


	if ( charges and maxCharges and maxCharges > 1 and charges < maxCharges ) then
		start = chargeStart;
		duration = chargeDuration;
		chargecool = true
	end

	valid = IsSpellInRange( ANS_SpellList[i][1], "target");

	if icon == nil then
		if idx == 2 then
			ANSMain:Hide();
		elseif idx == 3 then
			ANS2:Hide();
		else
			ANS:Hide();
		end

		return;
	end
	local frame;

	local frameIcon;
	local frameCooldown;
	local frameCount;
	local frameBorder;

	if idx == 2  then
		frame = _G["ANSMain"];
		frameIcon = _G["ANSMain".."Icon"];
		frameCooldown = _G["ANSMain".."Cooldown"];
		frameCount = _G["ANSMain".."Count"];
		frameBorder = _G["ANSMain".."Border"];
	elseif idx == 3 then
		frame = _G["ANS2"];
		frameIcon = _G["ANS2".."Icon"];
		frameCooldown = _G["ANS2".."Cooldown"];
		frameCount = _G["ANS2".."Count"];
		frameBorder = _G["ANS2".."Border"];

	else
		frame = _G["ANS"];
		frameIcon = _G["ANS".."Icon"];
		frameCooldown = _G["ANS".."Cooldown"];
		frameCount = _G["ANS".."Count"];
		frameBorder = _G["ANS".."Border"];
	end

	local skip = false

	if not (prev_i[idx] == i) then
		-- set the icon
		frameIcon:SetTexture(icon);

		prev_i[idx] = i
		prev_s[idx] = start
		prev_v[idx] = valid
		prev_c[idx] = count
		prev_d[idx]  = duration;
	else
		if prev_s[idx]  == start and duration <= prev_d[idx] and valid == prev_v[idx] and count == prev_c[idx]  then
			skip = true;
		end
		prev_s[idx]  = start;
		prev_v[idx] = valid;
		prev_c[idx] = count
		prev_d[idx]  = duration;

	end

	if (duration ~= nil and duration > 0 ) then		
			-- set the count
			--
		frameCooldown:Show();

		if skip == false  then
			CooldownFrame_Set(frameCooldown, start, duration, duration > 0, enable);
			frameCooldown:SetHideCountdownNumbers(false);

		end

		if chargecool then
			frameCooldown:SetDrawSwipe(false);
		else
			frameCooldown:SetDrawSwipe(true);
		end

	else
		frameCooldown:Hide();
	end


	if ( isUsable ) then
		frameIcon:SetVertexColor(1.0, 1.0, 1.0);

		if ( valid == 0 ) then
			frameIcon:SetVertexColor(1.0, 0.1, 0.1);
		end
		frameIcon:SetDesaturated(false)

	elseif ( notEnoughMana ) then
		frameIcon:SetVertexColor(0.5, 0.5, 1.0);
		frameIcon:SetDesaturated(true)

	else
		frameIcon:SetVertexColor(0.4, 0.4, 0.4);
		frameIcon:SetDesaturated(true)
	end

	frameIcon:SetTexCoord(.08, .92, .08, .92)
	frameBorder:SetTexture("Interface\\Addons\\asNextSkill\\border.tga")
	frameBorder:SetTexCoord(0.08,0.08, 0.08,0.92, 0.92,0.08, 0.92,0.92)	
	frameBorder:SetVertexColor(0, 0, 0);
	frameBorder:Show();

	if count and  count > 0 then
		frameCount:SetText(count);
		frameCount:Show();
		frame.cooldownfont:ClearAllPoints();
		frame.cooldownfont:SetPoint("TOPLEFT", 4, -4);
	else
		frame.cooldownfont:ClearAllPoints();
		frame.cooldownfont:SetPoint("CENTER", 0, 0);
		frameCount:Hide();
	end

	if ANS_ShowActiveAlert then
		if (active_list and active_list[ANS_SpellList[i][1]]) then
			ANS_ShowOverlayGlow(frame);
		else
			ANS_HideOverlayGlow(frame);
		end
	end


	if UnitAffectingCombat("player") or (UnitExists("target") and UnitCanAttack("player", "target"))  then
		frame:Show();
	else
		frame:Hide();
	end


	return;
end

local function check_prevskill (spell)
	
	if check_prev then
	   if not prev_skill or (prev_skill and prev_skill ~= spell) then
		   return true;
	   else
		   return false;
	   end
   else
	   return true;
   end

end


local function get_power (power_count)

	local power = 0

	if ANS_UNIT_POWER == "RUNE" then
		
		local i;

		for i = 1, 6 do 
			discard, discard, runeReady = GetRuneCooldown(i);
	
			if runeReady then
				power = power + 1;
			end
		end

	elseif ANS_POWER_LEVEL then
		power = UnitPower("player", ANS_POWER_LEVEL);
		maxpower = UnitPowerMax("player", ANS_POWER_LEVEL);

		local partial = 0;

		if bupdate_partial_power then
			_, partial = math.modf(UnitPower("player", ANS_POWER_LEVEL, true) / UnitPowerDisplayMod(ANS_POWER_LEVEL))
		end
				
		if power_count > maxpower and power == maxpower then
			power = power_count;
		end

		local _, _, _, startTime, endTime, isTradeSkill, castID, notInterruptible, spellID = UnitCastingInfo("player");
		local cost = nil;

		if spellID then
			local costTable = GetSpellPowerCost(spellID);
			
			for _, costInfo in pairs(costTable) do
				if (costInfo.type == ANS_POWER_LEVEL) then
					cost = costInfo.cost;
					break;
				end
			end

			if cost  then

				if cost > power then
					--print (cost)
				end
				power = power - cost;
			else
				cost = asGetPowerCostTooltipInfo(spellID);

				if cost <= -1 then
					power = power - cost;
				elseif cost < 0 and bupdate_partial_power then
					partial = partial - cost;

					if partial > 1 then
						power = power + 1;
					end
					
				end
			end
		end
	end

	return power;
end

local PLAYER_UNITS = {
	player = true,
	vehicle = true,
	pet = true,
};


local main_idx = nil;


local check_nameplate_rate = 0;

local function check_nameplate (skill, check_count, aggro, check_action)


	local count = 0;

	for i = 1, 40 do

		local unit = "nameplate" .. i;

		if UnitExists(unit) and UnitIsVisible(unit) then

			local reaction = UnitReaction("player", unit);
			local inRange = false;

			if check_action and smackloc then
			    inRange = IsActionInRange(smackloc,unit)
			elseif skill then
				inRange = IsSpellInRange(skill, unit);
			end

			if reaction and reaction <= 4 and inRange then
				if aggro then
					local isTanking, status, percentage, v, v2 = UnitDetailedThreatSituation("player", unit);
	
					if v then
						count = count + 1;
					end
				else
					count = count + 1;
				end
			end
		else
			return count;
		end

		if count >= check_count then
			return count;
		end
	end


	return count;
end

local function asCheckTalent(name)
	local specID = PlayerUtil.GetCurrentSpecID();
   
    local configID = C_ClassTalents.GetActiveConfigID();
    local configInfo = C_Traits.GetConfigInfo(configID);
    local treeID = configInfo.treeIDs[1];

    local nodes = C_Traits.GetTreeNodes(treeID);

    for _, nodeID in ipairs(nodes) do
        local nodeInfo = C_Traits.GetNodeInfo(configID, nodeID);
        if nodeInfo.currentRank and nodeInfo.currentRank > 0 then
            local entryID = nodeInfo.activeEntry and nodeInfo.activeEntry.entryID and nodeInfo.activeEntry.entryID;
            local entryInfo = entryID and C_Traits.GetEntryInfo(configID, entryID);
            local definitionInfo = entryInfo and entryInfo.definitionID and C_Traits.GetDefinitionInfo(entryInfo.definitionID);

            if definitionInfo ~= nil then
                local talentName = TalentUtil.GetTalentName(definitionInfo.overrideName, definitionInfo.spellID);
				--print(string.format("%s %d/%d", talentName, nodeInfo.currentRank, nodeInfo.maxRanks));;
				if name == talentName then
					return true;
				end
            end
        end
    end
	return false;
end

function ANS_UpdateCooldown()

	local i, maxIdx;
	local min_cool = 0xFFFFFFFF
	local min_cool2 = 0xFFFFFFFF

	if ANS_SpellList == nil then
		return;
	end

	maxIdx = #ANS_SpellList;

	local min_i = maxIdx + 1;
	local min_i2 = maxIdx + 1;

	local enemy_count = nil;



	for i = 1, maxIdx do


		local spell = ANS_SpellList[i][1];
		local alert_nomana = ANS_SpellList[i][3];
		local active = false;
 
		local start, duration, enable = GetSpellCooldown(spell);
		local _, gcd  = GetSpellCooldown(61304);


		if gcd > 0 and gcd == duration then
			start = 0;
			duration = 0;
		end

		local usable, nomana = IsUsableSpell(spell);

		if alert_nomana and not usable then
			usable = nomana;
		end
		if alert_nomana then
			--usable = true;
		end

		active = usable;

		if ANS_SpellList[i][2] >  2 then
			active = false;
		end

		local j = 4

		while ANS_SpellList[i][j] and active  do
			local check_list =  ANS_SpellList[i][j];
			local check_type = check_list[1];

			if check_type then
				if check_type == 1 then
					-- 발동시 알림
					-- {1}
					if (active_list and active_list[spell]) then
						active = true;
					else
						active = false;
					end

				elseif check_type == 2 then
					-- 버프시 알림
					-- {2, "난도질", "player", 11, true}
					--

					local buff_name = check_list[2];
					local unit = check_list[3];
					local buff_time = check_list[4];
					local reverse = check_list[5];
					local bcount = check_list[6];

					if unit == nil then
						unit = "player";
					end

					local name, _, count, _, duration, extime = getUnitBuffbyName(unit, buff_name);
										
					local remain_time = 0;
					local remain_count = 0;
								
			

					if name then
						if duration > 0 then
							remain_time = extime - GetTime();
						else
							remain_time = 1000;
						end

						if gcd and remain_time > gcd then
							remain_time = remain_time - gcd
						end

						remain_count = count;
					end

					if reverse then
						if bcount then
							if remain_count < buff_time then
								active = true;
							else
								active = false;
							end

						else
							if remain_time < buff_time then

								active = true;
							else
								active = false;
							end
						end
					else
						if bcount then
							if remain_count > buff_time then
								active = true;
							else
								active = false;
							end
						else
							if remain_time > buff_time then
								active = true;
							else
								active = false;
							end
						end
					end

	
				elseif check_type == 3 then
					-- 디버프시 알림
					-- {3, "파열", "target", 7.5, true, false}
					--

					local buff_name = check_list[2];
					local unit = check_list[3];
					local buff_time = check_list[4];
					local reverse = check_list[5];
					local bcount = check_list[6];


					if unit == nil then
						unit = "player";
					end
					
					local remain_time = 0;
					local remain_count = 0;


					local name,  _, count, _, duration, extime, caster = getUnitDebuffbyName(unit, buff_name);

					if name and caster == "player" then
						if duration > 0 then
							remain_time = extime - GetTime();
						else
							remain_time = 1000;
						end

						if gcd and remain_time > gcd then
							remain_time = remain_time - gcd
						end


						remain_count = count;
					end

					if reverse then
						if bcount then
							if remain_count < buff_time then
								active = true;
							else
								active = false;
							end

						else
							if remain_time < buff_time then
								active = true;
							else
								active = false;
							end
						end
					else
						if bcount then
							if remain_count > buff_time then
								active = true;
							else
								active = false;
							end
						else
							if remain_time > buff_time then
								active = true;
							else
								active = false;
							end
						end
					end

			

				elseif check_type == 4 then
					-- Mana 보고 알림
					-- {4, 40, "player", true, true}

					local mana_count = check_list[2];
					local unit = check_list[3];
					local reverse = check_list[4];
					local bpercent = check_list[5];

					if unit == nil then
						unit = "player"
					end

					local powerType, powerTypeString = UnitPowerType("player");

					local mana = UnitPower("player", powerType);
					local max = UnitPowerMax("player", powerType);

					local _, _, _, startTime, endTime, isTradeSkill, castID, notInterruptible, spellID = UnitCastingInfo("player");
					local cost = nil;

					if spellID then
						local costTable = GetSpellPowerCost(spellID);
						local powerType, powerTypeString = UnitPowerType("player");
					
						for _, costInfo in pairs(costTable) do
							if (costInfo.type == powerType) then
								cost = costInfo.cost;
								break;
							end
						end
	
						if cost == nil or cost == 0 then
							cost = asGetCostTooltipInfo(spellID);
						end

						if cost then
							mana = mana - cost;
						end
					end

			
					if bpercent and max > 0 then
						mana = math.ceil((mana / max) * 100);
					end

					if reverse then
						if mana  and mana < mana_count then
							active = true;
						else
							active = false;
						end
					else
						if mana  and mana >= mana_count then
							active = true;
						else
							active = false;
						end
					end
				elseif check_type == 14 then
					-- Mana 보고 알림 (예상)
					-- {14, 40, "player", true, true, 4}

					local mana_count = check_list[2];
					local unit = check_list[3];
					local reverse = check_list[4];
					local bpercent = check_list[5];
					local regen = check_list[6];

					if unit == nil then
						unit = "player"
					end

					local powerType, powerTypeString = UnitPowerType("player");

					local mana = UnitPower("player", powerType);
					local max = UnitPowerMax("player", powerType);

				
					local _,  _, _, startTime, endTime, isTradeSkill, castID, notInterruptible, spellID = UnitCastingInfo("player");
					local cost = nil;

					if spellID then
						local costTable = GetSpellPowerCost(spellID);
						local powerType, powerTypeString = UnitPowerType("player");
					
						for _, costInfo in pairs(costTable) do
							if (costInfo.type == powerType) then
								cost = costInfo.cost;
								break;
							end
						end

						local curr_time = GetTime();
						local remain_time = 0;
						remain_time = (endTime/1000) - curr_time;
							--print (remain_time);
						if cost then
							mana = mana - cost;
						end

					else
						if gcd then
							remain_time = gcd
						end
					end
										
					if remain_time and regen then
						local haste = UnitSpellHaste("player") 
						--print (regen * remain_time * (1 + haste/100))
						mana = mana + (regen * remain_time * (1 + haste/100));
						--print (haste .. " ".. remain_time.. " "..mana);
					end

					if bpercent and max > 0 then
						mana = math.ceil((mana / max) * 100);
					end

					if reverse then
						if mana  and mana < mana_count then
							active = true;
						else
							active = false;
						end
					else
						if mana  and mana >= mana_count then
							active = true;
						else
							active = false;
						end
					end


				elseif check_type == 5 then
					-- Power Count 보고 알림
					-- {5, 2, "player", true}

					local power_count = check_list[2];
					local unit = check_list[3];
					local reverse = check_list[4];
					local frommax = check_list[5];

					if unit == nil then
						unit = "player"
					end

					local power = get_power(power_count);	


					if frommax and ANS_POWER_LEVEL then
						local max  = UnitPowerMax("player", ANS_POWER_LEVEL);

						power = max - power;
					
					end

					if reverse then
						if power < power_count then
							active = true;
						else
							active = false;
						end
					else
						if power >= power_count then
							active = true;
						else
							active = false;
						end
					end

				elseif check_type == 6 then
					-- Health 보고 알림
					-- {6, 40, "player", true}

					local health_count = check_list[2];
					local unit = check_list[3];
					local reverse = check_list[4];

					if unit == nil then
						unit = "target"
					end

					local health = UnitHealth(unit);
					local max = UnitHealthMax(unit);

					if max > 0 then
						health = math.ceil((health / max) * 100);
					end

					if reverse then
						if health and health < health_count then
							active = true;
						else
							active = false;
						end
					else
						if health and  health >= health_count then
							active = true;
						else
							active = false;
						end
					end

				elseif check_type == 7 then
					-- Action Count 시 
					local action_count = check_list[2];
					local donot_check_max = check_list[3];
					local check_remain_time = check_list[4];
					local maxcharge = 0;
					local count = 0;
					local realID;
					local remain_time = 1000;

		
					if ANS_Action_slot_list[i]  then
						count = GetActionCount(ANS_Action_slot_list[i]);
						_, maxcharge, chargeStart, chargeDuration, chargeModRate = GetActionCharges(ANS_Action_slot_list[i]);


						local type, id, subType, spellID = GetActionInfo(ANS_Action_slot_list[i] );

						if type and type == "macro" then
							 id = GetMacroSpell(id);
						end

						realID = id;

					end
				
					if count == nil or count == 0 then
						count, maxcharge, chargeStart, chargeDuration, chargeModRate = GetSpellCharges(spell);
					end



				
					local name,  _, _, startTime, endTime, isTradeSkill, castID, notInterruptible, spellID = UnitCastingInfo("player");

					if spellID and realID and (spellID == realID) and count and count > 0 then
						count = count - 1;
					end

												
					if count and count >= action_count then
						active = true
					elseif count and count >= action_count - 1 then

						active = false


						if chargeDuration > 0 then
							remain_time = chargeStart + chargeDuration - GetTime();
						else
							remain_time = 1000;
						end

						if gcd and remain_time > gcd then
							remain_time = remain_time - gcd
						end

						if check_remain_time then
							remain_time = remain_time - check_remain_time;							
						end

						if remain_time <= 0 then
							active = true
						else
							if donot_check_max == nil and maxcharge and count and count >= maxcharge then
								active = true
							end
						end

	
					else


						active = false
						if donot_check_max == nil and maxcharge and count and count >= maxcharge then
							active = true
						end

					end


				elseif check_type == 8 then
					-- 이전 Skill Check (풍운) 
					--
					if check_prevskill(spell) then
						active = true;
					else
						active = false;
					end


				elseif check_type == 12 then
					-- 이전 Skill 보고 글쿨 내면  알림
					--
					--{12, "바람 폭발", 3}
					--바람 폭발 Casting 
					local spell = check_list[2];
					
					local GCDmax = 1.5 / (( GetHaste() / 100 ) + 1)
	
					if GCDmax < 0.750 then
						GCDmax = 0.750
					end

					if prev_skill and prev_skill == spell and prev_time > GetTime() - GCDmax then
						active = true;
					else

						active = false;
					end
					
				elseif check_type == 16 then
					--
					--특정 스킬 케스팅 중이면 알림
					--{16, "조준 사격"}
					--조준 사격 Casting 
					local spell = check_list[2];

					local name,  _, _, startTime, endTime, isTradeSkill, castID, notInterruptible, spellID = UnitCastingInfo("player");

					if name and name == spell then
						active = true;
					else
						active = false;
					end

		
				elseif check_type == 9 then
					-- 특성 보고 알림
					-- {9, "고기칼", reverse}

					local name = check_list[2];
					local reverse = check_list[3];

					local selected = asCheckTalent(name)

					if reverse then
						if selected then	
							active = false;
						else
							active = true;
						end
					else
						if selected then	
							active = true;
						else
							active = false;
						end
					end
				elseif check_type == 10 then
					-- Spell Range

					local unit = check_list[2];

					if unit == nil then
						unit = "target";
					end

					local inRange = IsSpellInRange(spell, unit)

					if inRange == 0 then
						active = false;
					else
						active = true;
					end
				elseif check_type == 11 then
					-- 토템시 알림
					-- {11, "난도질",  11, true}
					--

					local buff_name = check_list[2];
					local buff_time = check_list[3];
					local reverse = check_list[4];
					
					local remain_time = 0;
					local remain_count = 0;

					local name, count, duration, extime;
					local bfind = false;


					for slot=1, MAX_TOTEMS do
						local haveTotem;
						haveTotem, name, start, duration, icon = GetTotemInfo(slot);

						if name == buff_name then
							bfind = true;
							extime = start + duration;
							break;
						end
					end
					
				
					if bfind then
						if duration > 0 then
							remain_time = extime - GetTime();
						else
							remain_time = 1000;
						end
						remain_count = count;
					end

					if reverse then
						if remain_time < buff_time then
							active = true;
						else
							active = false;
						end
					else
						if remain_time > buff_time then
							active = true;
						else
							active = false;
						end
					end

				elseif check_type == 15 then
					-- Casting 시 알리지 않음
					-- {15}
	
					local name,  _, _, startTime, endTime, isTradeSkill, castID, notInterruptible, spellID = UnitCastingInfo("player");
					local realID;
					local realName;
					
					if ANS_Action_slot_list[i]  then

						local type, id, subType, spellID = GetActionInfo(ANS_Action_slot_list[i] );

						if type and type == "macro" then
							 id = GetMacroSpell(id);
						end

						realID = id;

						realName = GetSpellInfo(realID);

					end


					if name and realName and name == realName then
						active = false;
					else
						active = true;
					end

				elseif check_type == 17 then

					-- Spell Cool보고 알림
					local cool_spell_name = check_list[2];
					local cool_time = check_list[3];
					local reverse = check_list[4];
					
					local remain_time = 0;

					local start, duration, enable = GetSpellCooldown(cool_spell_name);
					local curr_time = GetTime();
					local gcdstart, gcd  = GetSpellCooldown(61304);

					
					
					if start > 0 then
						remain_time = start + duration - curr_time;
					end

								
					if reverse then
						if remain_time < cool_time then
							active = true;
						else
							active = false;
						end
					else
						if remain_time > cool_time then
							active = true;
						else
							active = false;
						end
					end


				elseif check_type == 18 then
					-- Item ID
					-- {18, 1234, reverse}					
					local item_id = tonumber(check_list[2]);
					local reverse = check_list[3];



					if ANS_Item_IDs[item_id] then
						if reverse then
							active = false;
						else
							active = true;
						end
					else
						if reverse then
							active = true;
						else
							active = false;
						end
					end


				elseif check_type == 20 then
					-- 광역 check
					-- {20, "연발 사격", 3}
					
					local spell_name = check_list[2];
					local check_count = check_list[3];
					local check_aggro = check_list[4];
					local check_unit = check_list[5];

					
					if not enemy_count then
						enemy_count = check_nameplate (spell_name, 5, check_aggro, false);
					end
					

					if enemy_count >= check_count then
						active = true;
					else
						active = false;
					end


				elseif check_type == 21 then
					-- 광역 check
					-- {20, "연발 사격", 3}
					
					local check_count = check_list[2];
										
					if not enemy_count then
						enemy_count = check_nameplate (nil, 5, nil, true);
					end
					

					if enemy_count >= check_count then
						active = true;
					else
						active = false;
					end


				elseif check_type == 30 then
					-- 아제 Check
					local check_name = check_list[2];
					
					if check_name and  ANS_AzeriteTraits[check_name] then
						active = true;
					else
						active = false;
					end
			

				end
			end

		    j = j + 1;
	    end
		

		if ANS_SpellList[i][2] == 2 then
			if  usable and active and start + duration < min_cool2 then
				min_i2 = i
				min_cool2 = start + duration				
			end
		else
			if  usable and active and start + duration < min_cool then
				min_i = i
				min_cool = start + duration
			end
		end
			-- 더이상 볼 필요 없음
		if (min_cool == 0) then
			break;
		end

	end

	if min_i < maxIdx + 1 then
		ANS_Alert(min_i, 1);
	else
		ANS:Hide();
	end

	if min_i2 < maxIdx + 1 then
		ANS_Alert(min_i2, 3);
	else
		ANS2:Hide();
	end

	if check_prev then
		if 	prev_skill then
			ANS_Alert(prev_idx, 2);
		else
			ANSMain:Hide();
		end
	else

		if main_idx then
			ANS_Alert(main_idx, 2);
		else
			ANSMain:Hide();
		end
	end
end


local function ANS_UpdatePrevSkill(spellid)
	
	local i;

	if ANS_SpellList == nil then
		return;
	end

	maxIdx = #ANS_SpellList;

	local spellname = GetSpellInfo(spellid);

	for i = 1, maxIdx do

		local spell = ANS_SpellList[i][1];

		if spell == spellname then
			prev_idx = i;
			prev_skill = spellname;
			prev_time = GetTime();
		
			if check_prev then
				ANS_Alert(prev_idx, 2);
			end
	
			return;
		end
	end
	
end

local itemslots = {

	"HeadSlot",
	"NeckSlot",
	"ShoulderSlot",
	"BackSlot",
	"ChestSlot",
	"WristSlot",
	"MainHandSlot",
	"SecondaryHandSlot",
	"HandsSlot",
	"WaistSlot",
	"LegsSlot",
	"FeetSlot",
	"Finger0Slot",
	"Finger1Slot",
	"Trinket0Slot",
	"Trinket1Slot",
}




local function GetBonusID (itemString)

	local _, itemID, enchantID, gemID1, gemID2, gemID3, gemID4, suffixID, uniqueID, linkLevel, specializationID, upgradeTypeID, instanceDifficultyID, numBonusIDs = strsplit(":", itemString)

	if itemID then
		ANS_Item_IDs[tonumber(itemID)] = 1;
	end


end

local function ScanItems ()

	local i;
	 
	ANS_Bonus_IDs = {};
	ANS_Item_IDs = {};

	for i =1,#itemslots do 
		local  idx = GetInventorySlotInfo(itemslots[i]);
		local k = GetInventoryItemLink("player" ,idx);
		if k then
			GetBonusID(k);
		end

	end
end


local function ANS_OnUpdate()

	if ANS_SpellList and #ANS_SpellList > 0 and ANS:IsShown() then
		ANS_UpdateCooldown();
	end
end

local bfirst = false;


local function getloc(id)
   		local id = id
		    for i=1, 72 do
		        if select(2, GetActionInfo(i)) == id and IsUsableAction(i) then
	            return i
	        end
	    end
		return nil;
end


local function findsmackloc()

	local smackid = 49966
	local clawid = 16827
	local biteid = 17253



	local ret = nil
	ret = getloc(smackid)

	if ret == nil then
		ret =  getloc(clawid)
	end

	if ret == nil then

		ret = getloc(biteid)
	end

	smackloc = ret;
end




function ANS_OnEvent(self, event, arg1, arg2, arg3, arg4, arg5)

	if event == "PLAYER_ENTERING_WORLD" then
		main_idx = nil;
		ANS_Init();
		ANS_InitSlotInfo();
		ScanItems();
		checkSpellCost();
		checkSpellPowerCost();
		findsmackloc();
		checkAzerite();
		bfirst = true;
	elseif event == "ACTIVE_TALENT_GROUP_CHANGED" then
		main_idx = nil;
		ANS_Init();
		ANS_InitSlotInfo();
		checkSpellCost();
		checkSpellPowerCost();
		findsmackloc();
		bfirst = true;
	elseif event == "SPELLS_CHANGED" then
		checkSpellCost();
		checkSpellPowerCost();
		findsmackloc();

	elseif event == "ACTIONBAR_SLOT_CHANGED" and bfirst then
		ANS_InitSlotInfo();
		bfirst = false;
	elseif event == "ACTIONBAR_UPDATE_COOLDOWN" then
		ANS_UpdateCooldown();
	elseif event == "SPELL_ACTIVATION_OVERLAY_GLOW_SHOW" then
		active_list[GetSpellInfo(arg1)] = true;
		ANS_UpdateCooldown()
	elseif event == "SPELL_ACTIVATION_OVERLAY_GLOW_HIDE" then
		active_list[GetSpellInfo(arg1)] = false;
		ANS_UpdateCooldown()
	elseif event == "PLAYER_REGEN_ENABLED" then
	--	ANS:Hide();
	--	ANSMain:Hide();
	elseif event == "PLAYER_REGEN_DISABLED" then
		ANS:Show();
		ANSMain:Show();
		ANS2:Show();
		ANS_UpdateCooldown();
	elseif event == "PLAYER_TARGET_CHANGED" then

		if UnitExists("target") and  UnitCanAttack("player", "target") then
 			ANS:Show();
			ANSMain:Show();
			ANS2:Show();
			ANS_UpdateCooldown();
		elseif not UnitAffectingCombat("player") then
			ANS:Hide();
			ANSMain:Hide();
			ANS2:Hide();
		end
	elseif ( event == "PLAYER_EQUIPMENT_CHANGED" ) then
		ScanItems();
		checkSpellCost();
		checkSpellPowerCost();
		checkAzerite();

	elseif 	( event == "UNIT_SPELLCAST_START" or event == "UNIT_SPELLCAST_STOP" or event == "UNIT_SPELLCAST_FAILED" or event == "UNIT_SPELLCAST_SUCCEEDED" ) then


			local name,  text, texture, startTime, endTime, isTradeSkill, castID, notInterruptible, spellID = UnitCastingInfo("player");
			checkSpellCost(spellID);
			checkSpellPowerCost(spellID);

			ANS_UnitFrameManaCostPredictionBars_Update(self, (event == "UNIT_SPELLCAST_START" or not(startTime == endTime)), startTime, endTime, spellID, name, event);

			if event == "UNIT_SPELLCAST_SUCCEEDED"  and (arg1 == "player" or arg1 == "pet") then
				ANS_UpdatePrevSkill(arg3);
				ANS_UpdateCooldown();
			end
	elseif 	event == "UNIT_PET" then
		
		findsmackloc();
	elseif (event == "AZERITE_ITEM_POWER_LEVEL_CHANGED" or event == "AZERITE_EMPOWERED_ITEM_SELECTION_UPDATED" ) then
		checkAzerite();

	end

	return;
end 

function ANS_UnitFrameManaCostPredictionBars_Update(frame, isStarting, startTime, endTime, spellID, name, event)

	local cost = 0;
	if (not isStarting or startTime == endTime) then
		frame.predictedPowerCost = nil;
		if not (event == "UNIT_SPELLCAST_SUCCEEDED") then
			prev_skill2 = nil;
		end
	else
		local costTable = GetSpellPowerCost(spellID);
		for _, costInfo in pairs(costTable) do
			local powerType, powerTypeString = UnitPowerType("player");
			if (costInfo.type == powerType) then
				cost = costInfo.cost;
				break;
			end
		end

		if cost == 0 then
			cost = asGetCostTooltipInfo(spellID);
		end
		frame.predictedPowerCost = cost;

		if event == "UNIT_SPELLCAST_START" then
			prev_skill2 = name;
			prev_time2 = GetTime();
		end

	end
end


local function ANS_CheckPower()
	
	local localizedClass, englishClass = UnitClass("player")
	local spec = GetSpecialization();

	check_prev = false;
	prev_skill = nil;
	prev_time = nil;
	prev_skill2 = nil;
	prev_time2 = nil;

	bupdate_partial_power = false;

	if (englishClass == "PALADIN") then
		if (spec and spec == 3) then

			ANS_UNIT_POWER = "HOLY_POWER"
			ANS_POWER_LEVEL = Enum.PowerType.HolyPower
		end
	end

	if (englishClass == "MAGE") then

		if (spec and spec == 1) then

			ANS_UNIT_POWER = "ARCANE_CHARGES"
			ANS_POWER_LEVEL = Enum.PowerType.ArcaneCharges 
		end
	end


	if (englishClass == "WARLOCK") then

		ANS_UNIT_POWER = "SOUL_SHARDS"
		ANS_POWER_LEVEL = Enum.PowerType.SoulShards 

		if (spec and spec == 3) then
			bupdate_partial_power = true;
		end
	end

	if (englishClass == "DRUID") then
		ANS_UNIT_POWER = "COMBO_POINTS"
		ANS_POWER_LEVEL = Enum.PowerType.ComboPoints
	end

	if (englishClass == "MONK") then
		if (spec and spec == 3) then
			ANS_UNIT_POWER = "CHI"
			ANS_POWER_LEVEL = Enum.PowerType.Chi

			check_prev = true;
		end
	end

	if (englishClass == "ROGUE") then
		ANS_UNIT_POWER = "COMBO_POINTS"
		ANS_POWER_LEVEL = Enum.PowerType.ComboPoints

	end

	if (englishClass == "DEATHKNIGHT") then
		ANS_UNIT_POWER = "RUNE";
	end


end

function ANS_InitSlotInfo()

	local maxIdx = #ANS_SpellList;

	for i = 1, maxIdx do
		ANS_Action_slot_list[i] = ANS_GetActionSlot(ANS_SpellList[i][1]);
	end


end

local timer;

function ANS_Init()

	local localizedClass, englishClass = UnitClass("player")
	local spec = GetSpecialization();
	local listname = "ANS_SpellList";

	if timer then
		timer:Cancel();
	end

	ANS_SpellList = {};


	if spec then
		listname = "ANS_SpellList" .. "_" .. englishClass .. "_" .. spec;
		ANS_SpellList = _G[listname];
	else
		ANS_SpellList = {};
	end

	prev_i = {0, 0};
	ANS_SpellNameList = {};
	ANS_Action_slot_list = {};

	ANS_CheckPower();

	if (ANS_SpellList and #ANS_SpellList) then
	--	ChatFrame1:AddMessage("[ANS] ".. listname .. "을 Load 합니다.");
		local maxIdx = #ANS_SpellList;


		for i = 1, maxIdx do

			local t = ANS_SpellList[i][2];

			if t == 0 or t == 100 then
				main_idx = i;
			end
		
		end

		ANSMain:Hide();
		
		timer = C_Timer.NewTicker(0.5, ANS_OnUpdate);

	else
	--	ChatFrame1:AddMessage("[ANS] 비활성화 합니다.");
	end

	return;

end

function ANS_GetActionSlot(arg1)
	local lActionSlot = 0;



	for lActionSlot = 1, 120 do
		local type, id, subType, spellID = GetActionInfo(lActionSlot);

		if type and type == "macro" then
		 id = GetMacroSpell(id);
		end
	
		if id then
			local name = GetSpellInfo(id);


			if name and name == arg1 then
				return lActionSlot;
			end
		end
	end



	return nil;
end


ANS_mainframe = CreateFrame("Frame", nil, UIParent);
ANS = CreateFrame("Button", "ANS", UIParent, "asNextSkillFrameTemplate");
ANS:SetPoint("CENTER", ANS_CoolButtons_X, ANS_CoolButtons_Y);
ANS:SetWidth(ANS_SIZE);
ANS:SetHeight(ANS_SIZE * 0.9);
ANS:SetScale(1);
ANS:SetAlpha(ANS_Alpha);
ANS:EnableMouse(false);
ANS:Hide();
ANSMain = CreateFrame("Button", "ANSMain", UIParent, "asNextSkillFrameTemplate");
ANSMain:SetWidth(ANS_SIZE - 5);
ANSMain:SetHeight((ANS_SIZE - 5)* 0.9);
ANSMain:SetScale(1);
ANSMain:SetAlpha(ANS_Alpha);
ANSMain:EnableMouse(false);
ANSMain:Hide();

ANS2 = CreateFrame("Button", "ANS2", UIParent, "asNextSkillFrameTemplate");
ANS2:SetWidth(ANS_SIZE - 5);
ANS2:SetHeight((ANS_SIZE - 5)* 0.9);
ANS2:SetScale(1);
ANS2:SetAlpha(ANS_Alpha);
ANS2:EnableMouse(false);
ANS2:Hide();

if ANS_ShowVertical then
	ANSMain:SetPoint("BOTTOM", ANS, "TOP", 0, 1);
	ANS2:SetPoint("TOP", ANS, "BOTTOM", 0, -1);
else
	ANSMain:SetPoint("RIGHT", ANS, "LEFT", -1, 0);
	ANS2:SetPoint("LEFT", ANS, "RIGHT", 1, 0);

end


LoadAddOn("asMOD");

if asMOD_setupFrame then
    asMOD_setupFrame (ANS, "asNextSkill");
end


ANS_mainframe:SetScript("OnEvent", ANS_OnEvent);
ANS_mainframe:RegisterEvent("PLAYER_ENTERING_WORLD");
ANS_mainframe:RegisterEvent("ACTIVE_TALENT_GROUP_CHANGED");
ANS_mainframe:RegisterEvent("SPELLS_CHANGED");
ANS_mainframe:RegisterEvent("PLAYER_REGEN_DISABLED");
ANS_mainframe:RegisterEvent("PLAYER_REGEN_ENABLED");
ANS_mainframe:RegisterUnitEvent("UNIT_SPELLCAST_START", "player");
ANS_mainframe:RegisterUnitEvent("UNIT_SPELLCAST_STOP", "player");
ANS_mainframe:RegisterUnitEvent("UNIT_SPELLCAST_FAILED", "player");
ANS_mainframe:RegisterUnitEvent("UNIT_SPELLCAST_SUCCEEDED", "player");
ANS_mainframe:RegisterUnitEvent("UNIT_PET", "player");

ANS_mainframe:RegisterEvent("ACTIONBAR_UPDATE_COOLDOWN")
ANS_mainframe:RegisterEvent("SPELL_ACTIVATION_OVERLAY_GLOW_SHOW")
ANS_mainframe:RegisterEvent("SPELL_ACTIVATION_OVERLAY_GLOW_HIDE")
ANS_mainframe:RegisterEvent("ACTIONBAR_SLOT_CHANGED")
ANS_mainframe:RegisterEvent("PLAYER_TARGET_CHANGED")
ANS_mainframe:RegisterEvent("PLAYER_EQUIPMENT_CHANGED")
ANS_mainframe:RegisterEvent("AZERITE_ITEM_POWER_LEVEL_CHANGED")
ANS_mainframe:RegisterEvent("AZERITE_EMPOWERED_ITEM_SELECTION_UPDATED")




for _,r in next,{_G["ANSCooldown"]:GetRegions()}	do 
	if r:GetObjectType()=="FontString" then 
		r:SetFont("Fonts\\2002.TTF",ANS_CooldownFontSize,"OUTLINE")
		ANS.cooldownfont = r;
		break 
	end 
end

for _,r in next,{_G["ANS2Cooldown"]:GetRegions()}	do 
	if r:GetObjectType()=="FontString" then 
		r:SetFont("Fonts\\2002.TTF",ANS_CooldownFontSize,"OUTLINE")
		ANS2.cooldownfont = r;
		break 
	end 
end

for _,r in next,{_G["ANSMainCooldown"]:GetRegions()}	do 
	if r:GetObjectType()=="FontString" then 
		r:SetFont("Fonts\\2002.TTF",ANS_CooldownFontSize,"OUTLINE")
		ANSMain.cooldownfont = r;
		break 
	end 
end
