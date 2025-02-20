local _, ns = ...;

local Options_Default = {
	Version = 250111,
	ShowListOnly = false,
};

ns.ABF_SIZE = 28;
ns.ABF_SIZE_NOCOMBAT = 20;
ns.ABF_TARGET_BUFF_X = 75 + 30 + 20;
ns.ABF_TARGET_BUFF_Y = -142;
ns.ABF_PLAYER_BUFF_X = -75 - 30 - 20;
ns.ABF_PLAYER_BUFF_Y = -142;
ns.ABF_MAX_BUFF_SHOW = 7;
ns.ABF_TARGET_MAX_BUFF_SHOW = 21;
ns.ABF_ALPHA = 1;
ns.ABF_CooldownFontSize = 12; -- Cooldown Font Size
ns.ABF_CountFontSize = 11;    -- Count Font Size
ns.ABF_AlphaCombat = 1;       -- 전투중 Alpha 값
ns.ABF_AlphaNormal = 0.5;     -- 비 전투중 Alpha 값
ns.ABF_MAX_Cool = 60;         -- 최대 60초의 버프를 보임

ns.ABF_BlackList = {
	[72221] = 1
}

ns.ABF_BlackListTotem = {
	--["name"] = 1
	--[icon] = 1
}

-- 발동 주요 공격 버프
-- 보이게만 할려면 2, 강조하려면 1
ns.ABF_ProcBuffList = {
	-- 블러드
	[80353] = 1,
	[32182] = 1,
	[2825] = 1,
	[264667] = 1, -- 원초적 분노
	[390386] = 1, -- 위상의 격노
	[10060] = 1 --마력 주입
}

-- 가운데 공격 버프
-- 보이게만 할려면 1, 강조하려면 2, 빤작이 강조 3, 카운트 겅조 4 이상, 0 가운데 --> 좌측 이동

ns.ShowList_WARRIOR = {
	classbuffs = {
		--시즌2 완료
		[1218163] = 2, -- 방어 시즌2
		[1216556] = 2, -- 무기 시즌2
		[1216552] = 1, -- 무기 시즌2
		[1216561] = 1, -- 분노 시즌2
		[1216565] = 2, -- 분노 시즌2

		--전사
		[435615] = 2, --우레 작렬
		[437121] = 3, --우레 작렬
		[462131] = 4, --깨어나는 폭풍

		[393951] = 4, --피의 광기
		[393931] = 2, --학살의 일격
		[335082] = 2, -- 분노 특성 광기
		[280776] = 2, -- 분노 특성 급살

		[52437] = 2, -- 무기 특성 급살
		[386486] = 4, --방어 특성 혈안


	},

	classcountbuffs = {

	},

	classtotems = {


	},

	version = 250126,
}

ns.ShowList_ROGUE = {
	classbuffs = {
		--도적

		[457280] = 3, -- 도적 어어밤
		[452917] = 2, -- 도적 동전
		[452923] = 2, -- 도적 동전
		[441786] = 4, -- 도적 무형검
		[441326] = 2, -- 도적 무형검	
		
		[381623] = 2, -- 엉겅퀴 차
		[193538] = 1, -- 기민함	

		[455366] = 4, -- 암살 뼈가시
		[385754] = 2, -- 암살 특성 무차별 살육
		[385747] = 2, -- 암살 특성 무차별 살육

		[386270] = 3, -- 무법 특성 배포
		-- 무법 주사위 (좌측으로)
		[193356] = 0,
		[193357] = 0,
		[199603] = 0,
		[193359] = 0,
		[193358] = 0,
		[199600] = 0,

		[196911] = 4, -- 잠행 특성 그림자 기술
		[393969] = 2, -- 잠행 특성 죽음의 무도


	},

	classcountbuffs = {


	},

	classtotems = {


	},
	version = 250209,
}

ns.ShowList_HUNTER = {
	classbuffs = {

		--시즌2 완료
		[1218033] = 2, -- 격냥 시즌2
		[212704] = 2, -- 야냥 시즌2
		[1216874] = 1, -- 생냥 시즌2
		[1216879] = 2, -- 생냥 시즌2

		[457072] = 2, -- 아냥 시즌1
		[457116] = 2, -- 격냥 시즌1

		--사냥꾼
		[431917] = 1, --매서운 사냥
		[466991] = 3, --부패의 사격
		[468074] = 4, --부패의 사격

		[471877] = 1, --Howl of Packleader
		[472324] = 2, --Howl of Packleader
		[472325] = 2, --Howl of Packleader
		[471878] = 2, --Howl of Packleader
		[471881] = 2, --Howl of Packleader
		[472743] = 2, --Lead from the front


		[459735] = 2, -- 야수 특성 펜리르 소환
		[459731] = 4, -- 야수 특성 사냥지배자의 부름
		[459759] = 4, -- 야수 특성 저승까마귀
		[257946] = 0, -- 야수 특성 사냥의 전율
		[459689] = 4, -- 야수 특성 폭발성 맹독
		[359844] = 2, -- 야냥 특성 야생의 부름
		[281036] = 2, -- 야냥 특성 광포한 야수
		[468703] = 1, -- 야냥 특성 Serptene Ry
		[468704] = 2, -- 야냥 특성 Serptene Ry

		[461762] = 2, -- 야수 검은화살

		[459864] = 2, -- 생냥 특성 노출된 측방
		[259388] = 2, -- 생존 특성 살퀭이의 격노
		[186289] = 2, -- 생존 특성 독수리의 상
		[459870] = 2, -- 생존 특성 무자비한 맹공
		[260286] = 4, -- 생존 특성 창끝

		[459805] = 4, -- 사냥 특성 울화
		[389020] = 2, -- 격냥 특성 총알 세례
		[204090] = 2, -- 격냥 특성 명중
		[407405] = 2, -- 격냥 특성 리듬

		--시즌2사냥꾼
		[474257] = 2, -- On Target


	},

	classcountbuffs = {
		[459731] = 2, -- 야수 특성 사냥지배자의
		[459689] = 2, -- 야수 특성 폭발성 맹독
		[459759] = 4, -- 야수 특성 저승까마귀

		[259388] = 5, -- 생존 특성 살퀭이의 격노
		[260286] = 3, -- 생존 특성 창끝

		[459805] = 18, -- 사냥 특성 울화
		[468074] = 2, -- --부패의 사격

	},

	classtotems = {


	},

	version = 250111,
}

ns.ShowList_MAGE = {
	classbuffs = {
		--티어
		[1219035] = 2, -- 화법 시즌2
		[1216914] = 2, -- 냉법 시즌2
		[1216178] = 2, -- 비법 시즌2

		[455681] = 3, -- 비법 시즌1
		[455134] = 2, -- 화법 시즌1



		[449400] = 4, --법사 영웅특성
		[451049] = 3, -- 법사 영웅특성

		[451073] = 3, -- 법사 영웅특성
		[451038] = 3, -- 법사 영웅특성	(비전의 영혼)
		[431177] = 3, -- 법사 영웅특성  (서리불꽃 강화)

		[431040] = 1, -- 법사 영웅특성 FireMastery
		[431039] = 1, -- 법사 영웅특성 FrostMastery

		[438624] = 1, -- 화염 촉진
		[438611] = 1, -- 냉기 촉진		


		[454371] = 2, -- 냉법 특성 죽음의 냉기
		[382113] = 1, -- 냉법 특성 한랭 전선
		[205766] = 1, -- 사무치는 냉기

		[453601] = 3, -- 비법 특성 에테르 발동
		[458388] = 4, -- 비법 특성 에테르
		[384455] = 2, -- 비법 특성 비전의 조화
		[467634] = 2, -- 비법 에테르 조화
		[461531] = 2, -- 비법 big brained		

		[458964] = 3, -- 화법 일렁이는 열기
		[409964] = 2, -- 화법 화염의 분노
		[453329] = 2, -- 화법 화염의 분노
		[453283] = 2, -- 화법 화염의 촉진
		[453207] = 2, -- 불붙는 도화선
		--시즌2 추가		
		[1219307] = 2, -- 화법 Born of Frame
	},

	classcountbuffs = {
		[382113] = 25, -- 냉법 특성 한랭전선
		[454371] = 12, -- 냉법 특성
	},

	classtotems = {


	},

	version = 250217,

}

ns.ShowList_MONK = {
	classbuffs = {
		--수도
		[392883] = 3, -- 특성 쾌활한 생기화

		[451021] = 4, -- 질풍격
		[470670] = 4, -- 질풍격
		[452685] = 2, -- 질풍격
		[451242] = 2, -- 질풍격
		[452688] = 2, -- 질풍격
		[452684] = 2, -- 질풍격
		[451061] = 2, -- 질풍격


		[443424] = 4, -- 옥룡의 마음
		[196741] = 1, -- 타격 연계
		[427296] = 0, -- 운무 특성 치유의 비약


	},

	classcountbuffs = {


	},

	classtotems = {


	},

	version = 250111,

}


ns.ShowList_WARLOCK = {
	classbuffs = {

		[1219034] = 2, -- 고흑 시즌2

		[455679] = 2, -- 고흑 시즌1
		[455674] = 2, -- 파흑 시즌1

		--흑마
		[457555] = 3, -- 파괴 특성 학살
		[387158] = 4, -- 파흑 특성 황폐의 예언
		[387157] = 3, -- 파괴 특성 황폐의 의식
		[417282] = 1, -- 파괴 특성 몰아치는 혼돈
		[387385] = 3, -- 파괴 특성 반발력
		[387109] = 2, -- 파괴 특성 혼돈의 거대 불길
		[387110] = 2, -- 파괴 특성 혼돈의 거대 불길


		[387079] = 3, -- 고통 특성 고통의 점증


		[442726] = 2, -- 지옥 소환사 적개심
		[449793] = 2, -- 지옥 소환사 적개심
		[433885] = 3, -- 황폐
		[433891] = 3, -- 지옥 소환사 적개심


	},

	classcountbuffs = {


	},

	classtotems = {
		[1378282] = 1, -- 악마 특성 숯사냥개
		[1709931] = 1, -- 악마
		[1709932] = 1, -- 악마
		[1616211] = 1, -- 악마
		[237562] = 1, -- 악마
		[1416161] = 1, -- 고통


	},

	version = 250111,
}

ns.ShowList_PRIEST = {
	classbuffs = {

		--사제
		[391099] = 2, -- 암흑 사도	
		[373276] = 4, -- 암흑 요그사론
		[423726] = 2, -- 암흑 죽음의 고통
		[586] = 2, -- 소실
		[390636] = 1, -- 광시곡	
		[390933] = 2, -- 수양 특성	독신자의 진언


	},

	classcountbuffs = {


	},

	classtotems = {


	},

	version = 250111,
}


ns.ShowList_SHAMAN = {
	classbuffs = {
		[1218616] = 1, -- 고술 시즌2
		[1223410] = 1, -- 고술 시즌2
		[1218612] = 2, -- 정술 시즌2


		--주술사
		[470532] = 2, -- 폭풍 전격

		[285514] = 2, -- 정기 특성
		[16166] = 2, -- 정기 특성	
		[454015] = 3, -- 정기 특성
		[455097] = 2, -- 정기 특성
		[381933] = 2, -- 정기 특성 "용암류"
		[191877] = 2, -- 정기 소용돌이의 힘

		[382043] = 2, -- 고술/정기 특성 분리된 정령	
		[462131] = 4, -- 고술/정기 특성 Awakening Storms

		[224125] = 0, -- 고술 야정 짜릿한 격동
		[224126] = 0, -- 고술 야정 용암 무기
		[224127] = 0, -- 고술 야정 얼음장 같은 예리함
		[466772] = 2, -- 고술 Doom Wind
		[333957] = 2, -- 고술 야정

		[173184] = 1, -- 고술/정기 특성 "정기 작렬: 특화"
		[173183] = 1, -- 고술/정기 특성 "정기 작렬: 가속"
		[118522] = 1, -- 고술/정기 특성 "정기 작렬: 치명타 및 극대화"



		[467665] = 4, -- 복술 만조
		[288675] = 3, -- 복술 특성 "만조"
		[462377] = 2, -- 복술 원소의 대가


	},

	classcountbuffs = {


	},

	classtotems = {
		[5927655] = 1, -- Surging Totem


	},

	version = 250204,
}


ns.ShowList_DRUID = {
	classbuffs = {


		[455070] = 2, -- 회드 시즌1
		[1217236] = 1, -- 야드 시즌2
		[1217245] = 2, -- 야드 시즌2	
		--조드필요 없음

		[454957] = 2, -- 야드 시즌1

		--드루
		[441701] = 4, --드루 영웅특성
		[439893] = 2, --드루 영웅특성 전략적 주입
		[439891] = 2, --드루 영웅특성 전략적 주입
		[204066] = 2, --수드 달광선
		[392360] = 4, --회드 특성 삼림재생
		[117679] = 2, --회드 화신
		[207640] = 4, --회드 풍요
		[428737] = 2, --숲의 조화
		[434112] = 2, --꿈의 쐐도
		[433832] = 2, --꿈의 폭발
		[441825] = 2, --목숨을 끊는 일격

		[145152] = 4, --야드 피투성이 손길
		[391882] = 3, -- 야성 특성 최상위
		[391974] = 3, -- 야성 기습공격


	},

	classcountbuffs = {
		[392360] = 2, -- 회드 특성 삼림 재생


	},

	classtotems = {
		[132129] = 1,


	},

	version = 250121,
}



ns.ShowList_DEATHKNIGHT = {
	classbuffs = {

		-- 시즌2 완료
		--혈죽 없음
		[1216813] = 2, -- 부죽 시즌2
		[1217897] = 2, -- 냉죽 시즌2

		[457189] = 2, -- 냉죽 시즌1
		--죽기
		[433925] = 2, -- 피의 여왕의 정수
		[47568] = 2, -- 룬무기 강화
		[441416] = 3, -- 몰살

		[377101] = 2, -- 냉기 뼈 분쇄
		[377103] = 3, -- 냉기 뼈 분쇄 (강화)	
		[152279] = 3, -- 냉죽 특성 신드라고사의 숨결

		[459238] = 4, -- 부정 부패의 낫
		[458123] = 3, -- 부정 부패의 낫
		[453773] = 1, -- 부정 부패의 낫
		[207289] = 2, -- 부정의 습격
		[377591] = 2, -- 부정 특성 곪아 터진 힘

		[55233] = 2, -- 혈죽 흡혈
		[48792] = 2, -- 혈죽 얼인
		[81256] = 2, -- 혈죽 룬무기


	},

	classcountbuffs = {


	},

	classtotems = {
		[298667] = 1, -- 부죽 	"흉물"

	},

	version = 250220,

}


ns.ShowList_EVOKER = {
	classbuffs = {

		[1217769] = 2, --황패 시즌2
		[456142] = 2, -- 증강 시즌1	
		--기원사
		[443176] = 3, --보존 생명 불꽃



	},

	classcountbuffs = {


	},

	classtotems = {


	},

	version = 250119,
}


ns.ShowList_PALADIN = {
	classbuffs = {
		--시즌2 (완)
		--신기 시즌2 없음
		[1216837] = 3, -- 징기 시즌2
		[1216828] = 2, -- 징기 시즌2
		[1218114] = 2, -- 보기 시즌2

		[454693] = 2, -- 징벌 시즌1
		[454653] = 2, -- 징벌 시즌1
		[456700] = 1, -- 보기 시즌1
		--성기사
		[414196] = 4, -- 신기 각성
		[182104] = 4, -- 보기 눈부신 빛
		[327510] = 3, -- 보기 눈부신 빛
		[385724] = 2, -- 보기 신앙의 철옹성
		[379041] = 2, -- 보기 빛을 향한 믿음
		[460822] = 1, -- 보기 천상의 인도
		[86659] = 2, -- 보기 고대왕
		[432502] = 2, -- 신성한 검
		[432496] = 2, -- 신성한 보루
		[406975] = 4, -- 징벌 특성 천상의 심판관
		[433674] = 4, -- 징벌 특성
		[326733] = 3, -- 징벌 (창공의 힘)
		[408458] = 3, -- 특성 신성한 목적		

	},

	classcountbuffs = {
		[406975] = 25, -- 징벌 특성 천상의 심판관

	},

	classtotems = {


	},

	version = 250220,
}


ns.ShowList_DEMONHUNTER = {
	classbuffs = {
		--시즌2 (완)
		[1217011] = 4, -- 파멸
		[1220706] = 2, -- 파멸
		[1217055] = 2, -- 파멸
		[1219012] = 2, -- 복수

		--악사
		[444661] = 4, -- 악사 전투 검술
		[452416] = 2, -- 악사 악마쇄도
		[442688] = 2, -- 악사 전투의 전율
		[442695] = 2, -- 악사 전투의 전율

		[391215] = 3, -- 파멸 특성	선제 공격

	},

	classcountbuffs = {


	},

	classtotems = {


	},
	version = 250111,
}

--장신구등
ns.ABF_OtherBuffList = {
	[451199] = 0, -- 첩보단장
}


-- PVP Buff List
ns.ABF_PVPBuffList = {
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

};

local asGetSpellInfo = function(spellID)
	if not spellID then
		return nil;
	end

	local ospellID = C_Spell.GetOverrideSpell(spellID)

	if ospellID then
		spellID = ospellID;
	end

	local spellInfo = C_Spell.GetSpellInfo(spellID);
	if spellInfo then
		return spellInfo.name, nil, spellInfo.iconID, spellInfo.castTime, spellInfo.minRange, spellInfo.maxRange,
			spellInfo.spellID, spellInfo.originalIconID;
	end
end

ns.options = CopyTable(Options_Default);
local tempoption = {};

ns.buffpanel = CreateFrame("Frame")
ns.totempanel = CreateFrame("Frame")

function ns.refreshList()
	if ns.buffpanel.bufflisttext then
		local text = "";
		for id, value in pairs(ns.show_list) do
			local name, _, icon = asGetSpellInfo(id)

			if name then
				text = text .. value .. " |T" .. icon .. ":0|t " .. name .. " " .. id .. "\n";
			end
		end

		ns.buffpanel.bufflisttext:SetText(text);
	end

	if ns.totempanel.bufflisttext then
		local text = "";
		for icon, value in pairs(ns.show_totemlist) do

			if icon then
				text = text .. value .. " |T" .. icon .. ":0|t "  .. icon .. "\n";
			end
		end

		ns.totempanel.bufflisttext:SetText(text);
	end
end

local function SetupSubOption(panel, titlename, coption, soption)

	local curr_y = 0;
	local y_adder = -40;	

	if panel.scrollframe then
		panel.scrollframe:Hide()
		panel.scrollframe:UnregisterAllEvents()
		panel.scrollframe = nil;
	end

	panel.scrollframe = CreateFrame("ScrollFrame", nil, panel, "UIPanelScrollFrameTemplate")
	panel.scrollframe:SetPoint("TOPLEFT", 3, -4)
	panel.scrollframe:SetPoint("BOTTOMRIGHT", -27, 4)

	-- Create the scrolling child frame, set its width to fit, and give it an arbitrary minimum height (such as 1)
	panel.scrollchild = CreateFrame("Frame")
	panel.scrollframe:SetScrollChild(panel.scrollchild)
	panel.scrollchild:SetWidth(600)
	panel.scrollchild:SetHeight(1)

	-- add widgets to the panel as desired
	local title = panel:CreateFontString("ARTWORK", nil, "GameFontNormalLarge")
	title:SetPoint("TOP")
	title:SetText(titlename)

	curr_y = curr_y + y_adder;

	local localeTexts = { "Buff ID", "Type" };

	local x = 10;
	
	local title = panel.scrollchild:CreateFontString("ARTWORK", nil, "GameFontNormal");
	title:SetPoint("TOPLEFT", x, curr_y);
	title:SetText(localeTexts[1]);

	x = 200;

	title = panel.scrollchild:CreateFontString("ARTWORK", nil, "GameFontNormal");
	title:SetPoint("TOPLEFT", x, curr_y);
	title:SetText(localeTexts[2]);

	x = 350;

	local btn0 = CreateFrame("Button", nil, panel.scrollchild, "UIPanelButtonTemplate")
	btn0:SetPoint("LEFT", panel.scrollchild, "TOPLEFT", x, curr_y)
	btn0:SetText("Load Default")
	btn0:SetWidth(100)
	btn0:SetScript("OnClick", function()
		ABF_Options[ns.listname] = CopyTable(ns[ns.listname])
		ns.Loadoptions();
		ns.refreshList();
	end);


	curr_y = curr_y + y_adder;



	local x = 10;

	local editBox = CreateFrame("EditBox", nil, panel.scrollchild)
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
	editBox:SetPoint("LEFT", panel.scrollchild, "TOPLEFT", x, curr_y)
	editBox:SetFontObject("GameFontHighlight")
	editBox:SetMultiLine(false);
	editBox:SetMaxLetters(20);
	editBox:SetText("");
	editBox:SetAutoFocus(false);
	editBox:ClearFocus();
	editBox:SetTextInsets(0, 0, 0, 1);
	editBox:SetNumeric(true);
	editBox:Show();
	editBox:SetCursorPosition(0);
	x = x + 150;


	local dropDown = CreateFrame("Frame", nil, panel.scrollchild, "UIDropDownMenuTemplate")
	dropDown:SetPoint("LEFT", panel.scrollchild, "TOPLEFT", x, curr_y)
	UIDropDownMenu_SetWidth(dropDown, 100) -- Use in place of dropDown:SetWidth

	local dropdownOptions = {
		{ text = "Left",           value = 0 },
		{ text = "Middle",         value = 1 },
		{ text = "Middle Alert",   value = 2 },
		{ text = "Middle Alert 2", value = 3 },
		{ text = "Middle Count",   value = 4 },
	};


	UIDropDownMenu_Initialize(dropDown, function(self, level)
		for _, option in ipairs(dropdownOptions) do
			local info = UIDropDownMenu_CreateInfo()
			info.text = option.text
			info.value = option.value
			info.disabled = option.disabled
			local function Dropdown_OnClick()
				UIDropDownMenu_SetSelectedValue(dropDown, option.value);				
			end
			info.func = Dropdown_OnClick;
			UIDropDownMenu_AddButton(info, level)
		end
		UIDropDownMenu_SetSelectedValue(dropDown, 0);
	end);	

	x = x + 150;

	local btn = CreateFrame("Button", nil, panel.scrollchild, "UIPanelButtonTemplate")
	btn:SetPoint("LEFT", panel.scrollchild, "TOPLEFT", x, curr_y)
	btn:SetText("Add")
	btn:SetWidth(100)
	btn:SetScript("OnClick", function()
		local newspell = editBox:GetNumber();            
        local newtype = tonumber(UIDropDownMenu_GetSelectedValue(dropDown));
		if newspell and newspell > 0 then
			coption[newspell] = newtype;
			if soption then
				soption[newspell] = newtype;
		end
			ns.refreshList();
		end

	end);

	x = x + 120;

	local btn2 = CreateFrame("Button", nil, panel.scrollchild, "UIPanelButtonTemplate")
	btn2:SetPoint("LEFT", panel.scrollchild, "TOPLEFT", x, curr_y)
	btn2:SetText("Delete")
	btn2:SetWidth(100)
	btn2:SetScript("OnClick", function()
		local newspell = editBox:GetNumber();   
		if newspell and newspell > 0 then
			coption[newspell] = nil;
			if soption then
				soption[newspell] = nil;
			end
			ns.refreshList();
		end

	end);

	curr_y = curr_y + y_adder;

	panel.explaintext = panel.scrollchild:CreateFontString("ARTWORK", nil, "GameFontNormal");
	panel.explaintext:SetFont(STANDARD_TEXT_FONT, 12, "THICKOUTLINE");
	panel.explaintext:SetPoint("TOPLEFT", 10, curr_y);
	panel.explaintext:SetTextColor(1, 1, 1);
	panel.explaintext:SetJustifyH("LEFT");
	panel.explaintext:SetText("0-Left, 1-Middle, 2-Middle Alert, 3-Middle More Alert, 4-Count")
	panel.explaintext:Show();


	curr_y = curr_y + y_adder;

	panel.bufflisttext = panel.scrollchild:CreateFontString("ARTWORK", nil, "GameFontNormal");
	panel.bufflisttext:SetFont(STANDARD_TEXT_FONT, 20, "THICKOUTLINE");
	panel.bufflisttext:SetPoint("TOPLEFT", 10, curr_y);
	panel.bufflisttext:SetTextColor(1, 1, 1);
	panel.bufflisttext:SetJustifyH("LEFT");
	panel.bufflisttext:Show();

	ns.refreshList();
end


function ns.SetupOptionPanels()
	local function OnSettingChanged(_, setting, value)
		local function get_variable_from_cvar_name(cvar_name)
			local variable_start_index = string.find(cvar_name, "_") + 1
			local variable = string.sub(cvar_name, variable_start_index)
			return variable
		end

		local cvar_name = setting:GetVariable()
		local variable = get_variable_from_cvar_name(cvar_name)
		ABF_Options[variable] = value;
		ns.options[variable] = value;

		ReloadUI();
	end

	local category = Settings.RegisterVerticalLayoutCategory("asBuffFilter")
	local subcategory, subcategoryLayout = Settings.RegisterCanvasLayoutSubcategory(category, ns.buffpanel, "Class Buff List");
	local subcategory, subcategoryLayout = Settings.RegisterCanvasLayoutSubcategory(category, ns.totempanel, "Totem List");

	if ABF_Options == nil or Options_Default.Version ~= ABF_Options.Version then
		ABF_Options = {};
		ABF_Options = CopyTable(Options_Default);
	end

	ns.options = CopyTable(ABF_Options);

	for variable, _ in pairs(Options_Default) do
		local name = variable;

		if name ~= "Version" then
			local cvar_name = "asBuffFilter_" .. variable;
			local tooltip = ""
			if ABF_Options[variable] == nil then
				ABF_Options[variable] = Options_Default[variable];
				ns.options[variable] = Options_Default[variable];
			end
			local defaultValue = Options_Default[variable];
			local currentValue = ABF_Options[variable];

			if tonumber(defaultValue) ~= nil then
				local setting = Settings.RegisterAddOnSetting(category, cvar_name, variable, tempoption,
					type(defaultValue), name, defaultValue);
				local options = Settings.CreateSliderOptions(0, 100, 1);
				options:SetLabelFormatter(MinimalSliderWithSteppersMixin.Label.Right);
				Settings.CreateSlider(category, setting, options, tooltip);
				Settings.SetValue(cvar_name, currentValue);
				Settings.SetOnValueChangedCallback(cvar_name, OnSettingChanged);
			else
				local setting = Settings.RegisterAddOnSetting(category, cvar_name, variable, tempoption,
					type(defaultValue), name, defaultValue);

				Settings.CreateCheckboxWithOptions(category, setting, nil, tooltip);
				Settings.SetValue(cvar_name, currentValue);
				Settings.SetOnValueChangedCallback(cvar_name, OnSettingChanged);
			end
		end
	end

	Settings.RegisterAddOnCategory(category)

	ns.Loadoptions();
	SetupSubOption(ns.buffpanel, "Class Buff List", ns.show_list , ABF_Options[ns.listname].classbuffs);
	SetupSubOption(ns.totempanel, "Totem List", ns.show_totemlist , ABF_Options[ns.listname].classtotems);
end
