---설정부
local ANameP_SIZE = 0; 					-- Icon Size 0 이면 자동으로 설정
local ANameP_Size_Rate = 0.7;			-- Icon 가로 세로 비중
local ANameP_PVP_Debuff_Size_Rate = 4   -- PVP Debuff Icon Size 작게 하려면 - 값으로

local ANameP_PlayerBuffY = -5			-- Player 바 Buff 위치
local ANameP_TargetBuffY = 5			-- 대상바 Buff 위치
local ANameP_ComboBuffY = ANameP_TargetBuffY + 30 -- 특수 자원 표시시 Buff 위치
local ANameP_CooldownFontSize = 9;     --재사용 대기시간 Font Size
local ANameP_CountFontSize = 8;			--Count 폰트 Size
local ANameP_MaxDebuff = 8;				--최대 Debuff
local ANameP_DebuffsPerLine = 4;		--줄당 Debuff 수 (큰 이름표 일 경우 +1 됨)
local ANameP_MaxBuff = 1;				--최대 PVP Buff (안보이게 하려면 0)
local ANameP_ShowMyAll = true;			--내 buff/Debuff면 모두 보임 false 로 하면 아래 Show List 항목만 보임
local ANameP_ShowPVPDebuff = true;		--PVP Debuff 면 모두 보임 (다른 사람의 디법이면 회색으로 보임)
local ANameP_ShowPlayerBuff = true;		--Player NamePlate에 Buff를 안보일려면 false;
local ANameP_ShowPlayerBuffDefault = true; -- 기본 Plate 와 같은 BUff만 보이기
local ANameP_BuffMaxCool = 60;			--buff의 최대 Cool
local ANameP_AggroShow = true;			-- 어그로 여부를 표현할지 여부 
local ANameP_PVPAggroShow = true;		-- PVP 어그로 여부를 표현할지 여부 
local ANameP_AggroStatusBarColor = true --생명력 바 색상으로 어그로 표시 false이면 ▶◀ 모양으로 표시
local ANameP_AggroTargetColor =  {r = 0.4, g = 0.2, b = 0.8}; -- PVE 대상이 player 였을때 Color
local ANameP_AggroColor = {r = 0.5, g = 1, b = 1}; -- 어그로 대상일때 바 Color
local ANameP_TankAggroLoseColor = {r = 1, g = 0.5, b= 0.5}; -- 탱커일때 어그로가 다른 탱커가 아닌사람일때
local ANameP_TankAggroLoseColor2 = {r = 1, g = 0.1, b= 0.5}; -- 어그로가 파티내 다른 탱커일때
local ANameP_TankAggroLoseColor3 = {r = 0.1, g = 0.3, b= 1}; -- 어그로가 Pet 일때 혹은 Tanking 중인데 어그로가 낮을때
local ANameP_ShowListFirst = true		-- 알림 List 가 있다면 먼저 보인다. (가나다라 순서)
local ANameP_WeakStealableBuffAlert = false -- 훔칠 버프 알림을 약하게 기본은 꺼 있음
local ANameP_ShowCCDebuff = true		-- 오른쪽에 CC Debuff만 별도로 보이기
local ANameP_CCDebuffSize = 16			-- CC Debuff Size;

local ANameP_AggroSize = 12;			-- 어그로 표시 Text Size
local ANameP_HealerSize = 14;			-- 힐러표시 Text Size
local ANameP_TargetHealthBarHeight = 3;	-- 대상 체력바 높이 증가치 (+3)
local ANameP_HeathTextSize = 8;			-- 대상 체력숫자 크기
local ANameP_UpdateRate = 0.5;			-- 버프 Check 반복 시간 (초)
local ANameP_LowHealthAlert = true  	-- 낮은 체력 색상 변경 사용
local ANameP_LowHealthColor = {r = 1, g = 0.8, b= 0.5}; -- 낮은 체력 이름표 색상 변경
local ANameP_Alpha_Normal = 0.5			-- 비전투 중 투명도
local ANameP_Alpha_Combat = 1			-- 전투중 투명도

local ANameP_ShowList = nil;


local ANameP_Resourcetext = nil;


local debuffs_per_line = ANameP_DebuffsPerLine;


-- ANameP_ShowList_직업_특성 숫자
-- 아래와 같은 배열을 추가 하면 된다.
-- ["디법명"] = {알림 시간, 우선순위},
-- 우선순위는 숫자가 큰 경우 우선적으로 보이고, 같을 경우 먼저 걸린 순서로 보임
ANameP_ShowList_WARRIOR_1 = {
	["분쇄"] = {15 * 0.3, 1, {r = 1, g = 0.5, b = 0}},
}

ANameP_ShowList_WARRIOR_2 = {
}

ANameP_ShowList_WARRIOR_3 = {
}

ANameP_ShowList_ROGUE_1 = {
	["파열"] = {24 * 0.3, 1, {r = 1, g = 0.5, b = 0}},	
}

ANameP_ShowList_ROGUE_2 = {
	
}

ANameP_ShowList_ROGUE_3 = {
	["파열"] = {24 * 0.3, 1, {r = 1, g = 0.5, b = 0}},	
}


ANameP_ShowList_HUNTER_1 = {
	["날카로운 사격"] = {0, 1, {r = 1, g = 0.5, b = 0}},
}

ANameP_ShowList_HUNTER_2 = {
	["독사 쐐기"] = {0, 1, {r = 1, g = 0.5, b = 0}},	
}


ANameP_ShowList_HUNTER_3 = {
	["독사 쐐기"] = {0, 1, {r = 1, g = 0.5, b = 0}},	
}

ANameP_ShowList_MONK_1 = {
}



ANameP_ShowList_MONK_2 = {
}

ANameP_ShowList_MONK_3 = {
	["주학의 징표"] = {0, 1},
}





ANameP_ShowList_WARLOCK_1 = {
	["고통"] = {14 * 0.3, 3, {r = 1, g = 0.5, b = 0}},
	["불안정한 고통"] = {21 * 0.3, 2},
	["부패"] = {14 * 0.3, 1},	
}

ANameP_ShowList_WARLOCK_2 = {
	
}


ANameP_ShowList_WARLOCK_3 = {
	["제물"] = {24 * 0.3, 1, {r = 1, g = 0.5, b = 0}},	
}


ANameP_ShowList_PRIEST_1 = {
	["어둠의 권능: 고통"] = {16 * 0.3, 1, {r = 1, g = 0.5, b = 0}},	
}



ANameP_ShowList_PRIEST_2 = {
}



ANameP_ShowList_PRIEST_3 = {
	["어둠의 권능: 고통"] = {16 * 0.3 , 1, {r = 1, g = 0.5, b = 0}},	
}

ANameP_ShowList_SHAMAN_1 = {
	["화염 충격"] = {18 * 0.3 , 1, {r = 1, g = 0.5, b = 0}},	
}

ANameP_ShowList_SHAMAN_2 = {
	["화염 충격"] = {18 * 0.3 , 1, {r = 1, g = 0.5, b = 0}},	
}

ANameP_ShowList_SHAMAN_3 = {
}


ANameP_ShowList_DRUID_1 = {
	["달빛섬광"] = {22 * 0.3, 3, {r = 1, g = 0.5, b = 0}},
	["태양섬광"] = {13.5 * 0.3, 2},	
	["항성의 섬광"] = {18 * 0.3, 1},	
}


ANameP_ShowList_DRUID_2 = {
	["갈퀴 발톱"] = {15 * 0.3, 2, {r = 1, g = 0.5, b = 0}},	
	["도려내기"] = {24 * 0.3, 1},
}

ANameP_ShowList_DRUID_3 = {
	["달빛섬광"] = {22 * 0.3, 1},
}


ANameP_ShowList_DRUID_4 = {
}


ANameP_ShowList_MAGE_1 = {
}

ANameP_ShowList_MAGE_2 = {
}

ANameP_ShowList_MAGE_3 = {

}


ANameP_ShowList_DEATHKNIGHT_1 = {
	["피의 역병"] = {0, 1},
}

ANameP_ShowList_DEATHKNIGHT_2 = {
	["서리 열병"] = {0, 1},
}

ANameP_ShowList_DEATHKNIGHT_3 = {
	["악성 역병"] = {27 * 0.3, 1},
	["고름 상처"] = {0, 2},
}


ANameP_ShowList_EVOKER_1 = {
	
}

ANameP_ShowList_EVOKER_2 = {
	
}

-- 아래 유닛명이면 강조
-- 색상 지정 가능
-- { r, g, b, 빤작임 여부}
local ANameP_AlertList = {
	["폭발물"] = {1, 1, 1, 0},	 -- 흰색 빤짝이 (없음)
	["그훈의 피조물"] = {0, 1, 0, 0},	-- 녹색 빤짝이 (없음)
	["고통받는 영혼"] = {0, 1, 0, 0},	-- 녹색 빤짝이 (없음)

--	["어둠그늘 곰팡이"] = {0, 1, 0, 0},	-- 녹색 빤짝이 (없음)
	--["훈련용 허수아비"] = {1, 1, 1, 0},	
--	["던전 사용자의 허수아비"] = {1, 0, 1, 0},	
--["공격대원의 훈련용 허수아비"] = {1, 0, 1, 0},	


}


-- 안보이게 할 디법
local ANameP_BlackList = {
--	["상처 감염 독"] = 1,	
--	["맹독"] = 1,
--	["약자 고문"] = 1,
--	["슬픔"] = 1,
--	["순환하는 기원"] = 1,
	["도전자의 짐"] = 1,	
	["도전자의 힘"] = 1,	

}

-- 크게 보이게 할 Debuff 값으로 추가 Size 를 입력 0 이거나 -도 가능
-- 일단 전장 Debuff 이 포함됨
local ANameP_BigDebuff = {

}


local ANameP_PVPBuffList = {


--생존기 시작 (용군단 Update 완료)
	--기원사
	[357170] = 1, --시간 팽창
	[363916] = 1, --흑요석 비늘
	[374348] = 1, --소생의 불길
	[363534] = 1, --되돌리기
	[370960] = 1, --애매랄드 교감
	[378441] = 1, --시간정지

	--전사
	[236273] = 1, --결투
	[118038] = 1, --투사의 혼
	[12975] = 1, --최후의 저항
	[871] = 1, --방패의 벽
	[97463] = 1, --재집결의 함성
	[184364] = 1, --격노의 재생력
	[386394] = 1, --역전의 용사
	[392966] = 1, --주문막기

	--도적
	[185311] = 1, --진홍색 약병
	[11327] = 1, --소멸
	[31224] = 1, --그림자 망토
	[31230] = 1, --구사일생
	[5277] = 1, --회피

	--악사
	[212800] = 1, --흐릿해지기
	[187827] = 1, --탈태
	[206803] = 1, --하늘에서 내리는 비
	[196555] = 1, --황천걸음
	[209426] = 1, --어둠


	--수도
	[202162] = 1, --해악방지
	[116849] = 1, --기의고치
	[322507] = 1, --천신주
	[115203] = 1, --강화주
	[122783] = 1, --마법해소
	[122278] = 1, --해악감퇴
	[132578] = 1, --흑우의 원령
	[115176] = 1, --명상
	[125174] = 1, --업보의 손아귀

	--죽기
	[51052] = 1, --대마법지대
	[48707] = 1, --대마법 보호막
	[48743] = 1, --죽음의 서약
	[48792] = 1, --얼음같은 인내력
	[114556] = 1, --연옥
	[81256] = 1, --춤추는 룬무기
	[219809] = 1, --묘비
	[55233] = 1, --흡혈

	--사냥꾼
	[53480] = 1, --희생의 표효
	[109304] = 1, --활기
	[264735] = 1, --적자 생존
	[186265] = 1, --거북의 상

	--성기사
	[228049] = 1, --잊힌 여왕의 수호자
	[642] = 1, --천상의 보호막
	[31850] = 1, --헌신적인 수호자
	[86659] = 1, --고대 왕의 수호자
	[327193] = 1, --영광의 순간
	[205191] = 1, --눈에는 눈
	[498] = 1, --신의 가호
	[31821] = 1, --오라 숙련
	[6940] = 1, --희생의 축복
	[1022] = 1, --보호의 축복
	[204018] = 1, --주문수호의 축복
	
	--주술사
	[210918] = 1, -- 에테리얼 형상
	[108271] = 1, --영혼-이동
	[108281] = 1, --고대의 인도

	--마법사 
	[45438] = 1, --얼음 방패
	[198111] = 1, --시간의 보호막
	[110959] = 1, --상급 투명화
	[342246] = 1, --시간돌리기
	[55342] = 1, --환영복제
	--드루이드
	[305497] = 1, --가시
	[354654] = 1, --숲의 보호
	[22812] = 1, --나무 껍질
	[157982] = 1, --평온
	[102342] = 1, --무쇠 껍질
	[61336] = 1, --생존본능
	[200851] = 1, --잠자는-자의-분노

	--흑마법사
	[104773] = 1, --영원한 결의
	[108416] = 1, --어둠의 서약

	--사제
	[215769] = 1, --구원의 영혼
	[328530] = 1, --신속한 승천
	[197268] = 1, --희망의 빛줄기
	[19236] = 1, --구원의 기도
	[81782] = 1, --신의 권능 방벽
	[33206] = 1, --고통억제
	[64843] = 1, --천상의 찬가
	[47788] = 1, --수호영혼
	[47585] = 1, --분산

--공격버프 시작 (용군단 Update 필요)
	-- Mage
	[80353] = 2, --Timewarp
	[12042] = 2, --Arcane Power
	[190319] = 2, --Combustion - burst
	[12472] = 2, --Icy Veins
	[82691] = 2, --Ring of frost
	[198144] = 2, --Ice form (pvp)
	[86949] = 2, --Cauterize

	-- DK
	[47476] = 2, --Strangulate (pvp) - silence
	[48792] = 2, --Icebound Fortitude
	[116888] = 2, --Shroud of Purgatory
	[114556] = 2, --Purgatory (cd)

	-- Shaman
	[32182] = 2, --Heroism
	[2825] = 2, --Bloodlust
	[108271] = 2, --Astral shift
	[16166] = 2, --Elemental Mastery - burst
	[204288] = 2, --Earth Shield
	[114050] = 2, --Ascendance

	-- Druid
	[106951] = 2, --Berserk - burst
	[102543] = 2, --Incarnation: King of the Jungle - burst
	[102560] = 2, --Incarnation: Chosen of Elune - burst
	[33891] = 2, --Incarnation: Tree of Life
	[1850] = 2, --Dash
	[22812] = 2, --Barkskin
	[194223] = 2, --Celestial Alignment - burst
	[78675] = 2, --Solar beam
	[77761] = 2, --Stampeding Roar
	[102793] = 2, --Ursol's Vortex
	[102342] = 2, --Ironbark
	[339] = 2, --Entangling Roots
	[102359] = 2, --Mass Entanglement
	[22570] = 2, --Maim

	-- Paladin
	[1022] = 2, --Blessing of Protection
	[204018] = 2, --Blessing of Spellwarding
	[1044] = 2, --Blessing of Freedom
	[31884] = 2, --Avenging Wrath
	[224668] = 2, --Crusade
	[216331] = 2, --Avenging Crusader
	[20066] = 2, --Repentance
	[184662] = 2, --Shield of Vengeance
	[498] = 2, --Divine Protection
	[53563] = 2, --Beacon of Light
	[156910] = 2, --Beacon of Faith
	[115750] = 2, --Blinding Light

	-- Warrior
	[1719] = 2, --Battle Cry
	[23920] = 2, --Spell Reflection
	[46968] = 2, --Shockwave
	[18499] = 2, --Berserker Rage
	[107574] = 2, --Avatar
	[213915] = 2, --Mass Spell Reflection
	[118038] = 2, --Die by the Sword
	[46924] = 2, --Bladestorm
	[12292] = 2, --Bloodbath
	[199261] = 2, --Death Wish
	[107570] = 2, --Storm Bolt

	-- Rogue
	[45182] = 2, --Cheating Death
	[31230] = 2, --Cheat Death (cd)
	[31224] = 2, --Cloak of Shadows
	[2983] = 2, --Sprint
	[121471] = 2, --Shadow Blades
	[1966] = 2, --Feint
	[5277] = 2, --Evasion
	[212182] = 2, --Smoke Bomb
	[13750] = 2, --Adrenaline Rush
	[199754] = 2, --Riposte
	[198529] = 2, --Plunder Armor
	[199804] = 2, --Between the Eyes
	[1833] = 2, --Cheap Shot
	[1776] = 2, --Gouge
	[408] = 2, --Kidney Shot

	-- Hunter
	[117526] = 2, --Binding Shot
	[209790] = 2, --Freezing Arrow
	[213691] = 2, --Scatter Shot
	[3355] = 2, --Freezing Trap
	[162480] = 2, -- Steel Trap
	[19574] = 2, --Bestial Wrath
	[193526] = 2, --Trueshot
	[19577] = 2, --Intimidation
	[90355] = 2, --Ancient Hysteria
	[160452] = 2, --Netherwinds

	-- Monk
	[125174] = 2, --Touch of Karma
	[116849] = 2, -- Life Cocoon
	[119381] = 2, --Leg Sweep

	-- Priest
	[10060] = 2, --Power Infusion
	[9484] = 2, --Shackle Undead
	[200183] = 2, --Apotheosis
	[15487] = 2, --Silence
	[15286] = 2, --Vampiric Embrace
	[193223] = 2, --Surrender to Madness
	[88625] = 2, --Holy Word: Chastise

	-- Warlock
	[108416] = 2, --Dark Pact
	[196098] = 2 , --Soul Harvest
	[30283] = 2, --Shadowfury

	-- Demon Hunter
	[198589] = 2, --Blur
	[179057] = 2, --Chaos Nova
	[209426] = 2, --Darkness
	[217832] = 2, --Imprison
	[206491] = 2, --Nemesis
	[211048] = 2, --Chaos Blades
	[207685] = 2, --Sigil of Misery
	[209261] = 2, --Last Resort (cd)
	[207810] = 2, --Nether Bond

	----
	[2335] = 2, --Swiftness Potion
	[6624] = 2, --Free Action Potion
	[67867] = 2, --Trampled (ToC arena spell when you run over someone)



}

local ANameP_PVEBuffList = {

	[277242] = 5, --'그훈의 공생체' 
	[209859] = 0, --'강화' 
}

local ANameP_DangerousSpellList = { 

   -- [297972] = true,
}




local ANameP_HealSpellList = {};

ANameP_HealSpellList["사제"] = {

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

ANameP_HealSpellList["드루이드"] = {

        [102342] = "DRUID", -- Ironbark
        [033763] = "DRUID", -- Lifebloom
        [088423] = "DRUID", -- Nature's Cure
        [033891] = "DRUID", -- Incarnation: Tree of Life
        [048438] = "DRUID", -- Wild Growth
        [000740] = "DRUID", -- Tranquility
	};


ANameP_HealSpellList["주술사"] = {

        [061295] = "SHAMAN", -- Riptide
        [077472] = "SHAMAN", -- Healing Wave
        [098008] = "SHAMAN", -- Spirit link totem
        [001064] = "SHAMAN", -- Chain Heal
        [073920] = "SHAMAN", -- Healing Rain

	};

ANameP_HealSpellList["성기사"] = {

        [020473] = "PALADIN", -- Holy Shock
        [053563] = "PALADIN", -- Beacon of Light
        [082326] = "PALADIN", -- Holy Light
        [085222] = "PALADIN", -- Light of Dawn
	};


ANameP_HealSpellList["수도사"] = {
        [115175] = "MONK", -- Soothing Mist
        [115310] = "MONK", -- Revival
        [116670] = "MONK", -- Vivify
        [116680] = "MONK", -- Thunder Focus Tea
        [116849] = "MONK", -- Life Cocoon
        [119611] = "MONK", -- Renewing mist

};

ANameP_HealSpellList["기원사"] = {
        [355936] = "EVOKER", -- 꿈의 숨결
		[364446] = "EVOKER", -- 메아리
		[366155] = "EVOKER", -- 되감기
		[367226] = "EVOKER", -- 영혼 만개
        
};

local ANameP_HealerGuid = {

}

local ANameP = nil;

local unusedOverlayGlows = {};
local numOverlays = 0;
local tanklist = {}

local PLAYER_UNITS = {
	player = true,
	vehicle = true,
	pet = true,
};


local lowhealthpercent = 0;

local ColorLevel = {
	None = 0,
	Reset = 1,
	Custom = 2,
	Debuff = 3,
	Lowhealth = 4,
	Aggro = 5,
	Target = 6,
	Name = 7,
};

local nameheight_value = nil;
local asnameplateResourceOnTarget = true;
local playerbuffposition = ANameP_PlayerBuffY;

-- 반짝이 처리부

--Overlay stuff
local unusedOverlayGlows = {};
local numOverlays = 0;
local function ANameP_ActionButton_GetOverlayGlow()
	local overlay = tremove(unusedOverlayGlows);
	if ( not overlay ) then
		numOverlays = numOverlays + 1;
		overlay = CreateFrame("Frame", nil, UIParent, "ANameP_ActionBarButtonSpellActivationAlert");
	end
	return overlay;
end

-- Shared between action button and MainMenuBarMicroButton
local function ANameP_ShowOverlayGlow(button, bhideflash)
	if ( button.overlay ) then
		button.overlay.bhideflash = bhideflash;
		if ( button.overlay.animOut:IsPlaying() ) then
			button.overlay.animOut:Stop();
			button.overlay.animIn:Play();
		end
	else
		button.overlay = ANameP_ActionButton_GetOverlayGlow();
		local frameWidth, frameHeight = button:GetSize();
		button.overlay:SetParent(button);
		button.overlay:ClearAllPoints();
		--Make the height/width available before the next frame:
		button.overlay:SetSize(frameWidth * 1.3, frameHeight * 1.3);
		button.overlay:SetPoint("TOPLEFT", button, "TOPLEFT", -frameWidth * 0.3, frameHeight * 0.3);
		button.overlay:SetPoint("BOTTOMRIGHT", button, "BOTTOMRIGHT", frameWidth * 0.3, -frameHeight * 0.3);
		button.overlay.bhideflash = bhideflash;
		button.overlay.animIn:Play();
	end
end

-- Shared between action button and MainMenuBarMicroButton
local function ANameP_HideOverlayGlow(button)
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

ANameP_ActionBarButtonSpellActivationAlertMixin = {};

function ANameP_ActionBarButtonSpellActivationAlertMixin:OnUpdate(elapsed)
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

function ANameP_ActionBarButtonSpellActivationAlertMixin:OnHide()
	if ( self.animOut:IsPlaying() ) then
		self.animOut:Stop();
		self.animOut:OnFinished();
	end
end

ANameP_ActionBarOverlayGlowAnimInMixin = {};

function ANameP_ActionBarOverlayGlowAnimInMixin:OnPlay()
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

	if frame.bhideflash then
		frame.spark:SetAlpha(0.3);
		frame.innerGlow:SetAlpha(0);
		frame.innerGlowOver:SetAlpha(0);
		frame.outerGlow:SetAlpha(0);
		frame.outerGlowOver:SetAlpha(0);
	end
	frame:Show();
end

function ANameP_ActionBarOverlayGlowAnimInMixin:OnFinished()
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

ANameP_ActionBarOverlayGlowAnimOutMixin = {};

function ANameP_ActionBarOverlayGlowAnimOutMixin:OnFinished()
	local overlay = self:GetParent();
	local actionButton = overlay:GetParent();
	overlay:Hide();
	tinsert(unusedOverlayGlows, overlay);
	actionButton.overlay = nil;
end

--Cooldown
local function asCooldownFrame_Clear(self)
	self:Clear();
end
--cooldown
local function asCooldownFrame_Set(self, start, duration, enable, forceShowDrawEdge, modRate)
	if enable and enable ~= 0 and start > 0 and duration > 0 then
		self:SetDrawEdge(forceShowDrawEdge);
		self:SetCooldown(start, duration, modRate);
	else
		asCooldownFrame_Clear(self);
	end
end

-- 탱커 처리부
local function updateTankerList()

	local bInstance, RTB_ZoneType = IsInInstance();

	if RTB_ZoneType == "pvp" or RTB_ZoneType == "arena" then
		return nil;
	end

	tanklist =	table.wipe(tanklist)
	if IsInGroup() then
		if IsInRaid() then -- raid
			for i=1,GetNumGroupMembers() do
				local unitid = "raid"..i
				local notMe = not UnitIsUnit('player',unitid)
				local unitName = UnitName(unitid)
				if unitName and notMe then
					local _,_,_,_,_,_,_,_,_,role,_, assignedRole = GetRaidRosterInfo(i);
					if assignedRole == "TANK" then
						table.insert(tanklist, unitid);
					end
				end
			end
		else -- party
			for i=1,GetNumSubgroupMembers() do
				local unitid = "party"..i;
				local unitName = UnitName(unitid);
				if unitName then
					local assignedRole = UnitGroupRolesAssigned(unitid);
					if assignedRole == "TANK" then
						table.insert(tanklist, unitid);
					end
				end
			end
		end
	end
end

local function IsPlayerEffectivelyTank()
	local assignedRole = UnitGroupRolesAssigned("player");
	if ( assignedRole == "NONE" ) then
		local spec = GetSpecialization();
		return spec and GetSpecializationRole(spec) == "TANK";
	end
	return assignedRole == "TANK";
end


-- 버프 디버프 처리부
local function createDebuffFrame(parent, frameName)

	local ret = CreateFrame("Frame", nil, parent, "asNamePlatesBuffFrameTemplate");
	ret:EnableMouse(false);

	local frameCooldown = ret.cooldown;
	local frameCount = ret.count;
					
	for _,r in next,{frameCooldown:GetRegions()}	do 
		if r:GetObjectType()=="FontString" then 
			r:SetFont(STANDARD_TEXT_FONT, ANameP_CooldownFontSize,"OUTLINE")
			r:ClearAllPoints();
			r:SetPoint("TOP", 0, 4);
			break;
		end 
	end

	local font, size, flag = frameCount:GetFont()

	frameCount:SetFont(STANDARD_TEXT_FONT, ANameP_CountFontSize, "OUTLINE")
	frameCount:ClearAllPoints();
	frameCount:SetPoint("BOTTOM", 0, -4);

	local frameIcon = ret.icon;
	local frameBorder = ret.border;
					
	frameIcon:SetTexCoord(.08, .92, .08, .92)
	frameBorder:SetTexture("Interface\\Addons\\asNamePlates\\border.tga")
	frameBorder:SetTexCoord(0.08,0.08, 0.08,0.92, 0.92,0.08, 0.92,0.92)	

	return ret;

end

local function setFrame(frame, texture, count, expirationTime, duration, color)

	local frameIcon = frame.icon;
	frameIcon:SetTexture(texture);

	local frameCount = frame.count;
	local frameCooldown = frame.cooldown;

	if count and  (count > 1) then
		frameCount:SetText(count);
		frameCount:Show();
		frameCooldown:SetDrawSwipe(false);
	else
		frameCount:Hide();
		frameCooldown:SetDrawSwipe(true);
	end

	asCooldownFrame_Set(frameCooldown, expirationTime - duration, duration, duration > 0, true);
	if ANameP_CooldownFontSize > 0 then
		frameCooldown:SetHideCountdownNumbers(false);
	end
						
	local frameBorder = frame.border;
	frameBorder:SetVertexColor(color.r, color.g, color.b);
end

local function setSize(frame, size)

	frame:SetWidth(size + 2);
	frame:SetHeight((size + 2) * ANameP_Size_Rate);

end

local function updateDebuffAnchor(frames, index, anchorIndex, size, offsetX, right, parent)

	local buff = frames[index];
	local point1 = "BOTTOMLEFT";
	local point2 = "BOTTOMLEFT";
	local point3 = "BOTTOMRIGHT";

	if (right == false) then
		point1 = "BOTTOMRIGHT";
		point2 = "BOTTOMRIGHT";
		point3 = "BOTTOMLEFT";
		offsetX = -offsetX;
	end

	buff:ClearAllPoints();

	if parent.downbuff then
		if ( index == 1 ) then
			buff:SetPoint("TOPLEFT", parent, "BOTTOMLEFT", 0, 0);
		elseif ( index == (debuffs_per_line + 1) ) then
			buff:SetPoint("TOPLEFT", frames[1], "BOTTOMLEFT", 0, -4);
		else
			buff:SetPoint(point1, frames[index -1], point3, offsetX, 0);
		end
	else
		if ( index == 1 ) then
			buff:SetPoint("BOTTOMLEFT", parent, "TOPLEFT", 0, 0);
		elseif ( index == (debuffs_per_line + 1) ) then
			buff:SetPoint("BOTTOMLEFT", frames[1], "TOPLEFT", 0, 4);
		else
			buff:SetPoint(point1, frames[index-1], point3, offsetX, 0);
		end
	end

	setSize(buff, size);
end

local function Comparison(AIndex, BIndex)
	local AID = AIndex[2];
	local BID = BIndex[2];

	if (AID ~= BID) then
		return AID > BID;
	end

	return false;
end

local function setStatusBarColor(self, color)	
	local parent = self:GetParent();
	if parent then
		if parent.UnitFrame then
			if parent.UnitFrame.healthBar and not parent.UnitFrame.healthBar:IsForbidden() then
				parent.UnitFrame.healthBar:SetStatusBarColor(color[1], color[2], color[3]);		
			end
		end
	end
end

local classbar_height = nil;
local function GetClassBarHeight()

	if not classbar_height then
		local class = NamePlateDriverFrame:GetClassNameplateBar();

		if class then
			classbar_height = class:GetHeight();
		else
			classbar_height = 0;
		end
	end

	return classbar_height;
end



local function updateAuras(self, unit, filter, showbuff, helpful, showdebuff)

	local numDebuffs = 1;
	local frametype = self:GetParent():GetName() .. "Buff"
	local size_list = {};
	local parent = self:GetParent();
	local healthBar = parent.UnitFrame.healthBar;

	self.unit = unit;
	self.reflesh_time = nil;

	local bShowCC = false;

	if not self.unit then
		return
	end
	
	local icon_size = self.icon_size; 

	if showbuff and not showdebuff then
		local aShowIdx = {};
		local aShowNum = 1;

		for i = 1, BUFF_MAX_DISPLAY do
			if (filter == "NONE" and self.buffList[i]) then
				self.buffList[i]:Hide();
				self:Hide();
				return;
			end
		
			local name,  texture, count, debuffType, duration, expirationTime, caster, isStealable, nameplateShowPersonal, spellId, _, _, _, nameplateShowAll = UnitAura(unit, i, "HELPFUL");
			if name then
				local show = false;
				local bPVP = false;

				if UnitIsPlayer(unit) then
					show = ANameP_PVPBuffList[spellId];
					bPVP = true;
				else
					if ANameP_PVEBuffList and  ANameP_PVEBuffList[spellId] then
						show = true;
					elseif isStealable then
						show = true;
					elseif caster and UnitIsUnit(unit, caster) then
						show = true;
					end

					if show and ANameP_BlackList[name] then
						show = false;
					end
				end
						
				if show then
					if UnitIsPlayer(unit) then
						aShowIdx[aShowNum] = {i, 0};
						aShowNum =aShowNum  + 1;
						-- 일단 1개만
						if numDebuffs + aShowNum - 1 > ANameP_MaxBuff then
							break;
						end
					else				
						if ANameP_PVEBuffList and ANameP_PVEBuffList[spellId] then
							aShowIdx[aShowNum] = {i, ANameP_PVEBuffList[spellId]};
						elseif isStealable then
							aShowIdx[aShowNum] = {i, 4};
						else
							aShowIdx[aShowNum] = {i, 1};
						end
						
						aShowNum =aShowNum  + 1;
						-- PVE 는 계속
					end
				end
			else
				break;
			end
		end

		if ANameP_ShowListFirst then
			-- sort
			table.sort(aShowIdx, Comparison);
		end

		for v = 1, aShowNum - 1 do
			if numDebuffs  > ANameP_MaxBuff  then
				break;
			end

			local i = aShowIdx[v][1];			
			local name,  texture, count, debuffType, duration, expirationTime, caster, isStealable, nameplateShowPersonal, spellId, _, _, _, nameplateShowAll = UnitAura(unit, i, "HELPFUL");
			local frameName = frametype.. numDebuffs;
					
			if (not self.buffList[numDebuffs]) then
				self.buffList[numDebuffs] = createDebuffFrame(self, frameName);
			end

			local frame = self.buffList[numDebuffs];

			if bPVP == true then
				size_list[numDebuffs] = icon_size + 2;
			else
				size_list[numDebuffs] = icon_size;
			end

			setSize (frame, size_list[numDebuffs]);
						
			if isStealable then
				ANameP_ShowOverlayGlow(frame, ANameP_WeakStealableBuffAlert);
			else
				ANameP_HideOverlayGlow(frame);
			end

			local color = {r = 1, g = 1, b = 1};
			setFrame(self.buffList[numDebuffs], texture, count, expirationTime, duration, color);		
			frame:Show();

			numDebuffs = numDebuffs + 1;
		end
	end

	if not showdebuff then
		local aShowIdx = {};
		local aShowNum = 1;
		
		for i = 1, BUFF_MAX_DISPLAY do
			if (filter == "NONE" and self.buffList[i]) then
				self.buffList[i]:Hide();
				self:Hide();
				return;
			end

			if numDebuffs + aShowNum - 1 > ANameP_MaxDebuff then
				break;
			end

			local name,  texture, count, debuffType, duration, expirationTime, caster, _, nameplateShowPersonal, spellId, _, isBossDebuff, _, nameplateShowAll  = UnitAura(unit, i, filter);
			if name then
				-- Default 로 Show List 에 있는 것만 보임
				local show = PLAYER_UNITS[caster] and (ANameP_ShowList and ANameP_ShowList[name]);

				-- Player 일 경우
				if  UnitIsUnit("player", unit) then
					if ANameP_ShowPlayerBuffDefault then
						show = nameplateShowPersonal;
					else
						if ANameP_ShowPlayerBuff and PLAYER_UNITS[caster] and duration > 0 and duration <= ANameP_BuffMaxCool then
							show = true;
						end
					end	
				else
					if ANameP_ShowMyAll and PLAYER_UNITS[caster] then
						if helpful then
							if duration > 0 and duration <= ANameP_BuffMaxCool then
								show = true;
							end
						else
							show = true;
						end
					elseif not ANameP_ShowMyAll and PLAYER_UNITS[caster] and nameplateShowPersonal then
						show = true;
					end

					if ANameP_ShowPVPDebuff and nameplateShowAll and duration <= 10 then

						if ANameP_ShowCCDebuff then
							show = false;
							if bShowCC == false then
								bShowCC = true;		

								local color = { r = 0.3, g = 0.3, b = 0.3 };
							
								setFrame(self.CCdebuff, texture, count, expirationTime, duration, color);		

								self.CCdebuff:ClearAllPoints();
								if self.casticon:IsShown() then
									
									self.CCdebuff:SetPoint("LEFT", self.casticon, "RIGHT", 1, 0);
								else
									
									self.CCdebuff:SetPoint("LEFT", healthBar, "RIGHT", 1, 0);

								end
								self.CCdebuff:Show();
							end
						else
							show = true;
						end
					end

					if isBossDebuff or ( caster and  not UnitIsPlayer(unit) and UnitIsUnit(unit, caster)) then
						show = true;
					end					
				end
										
				if show  and ANameP_BlackList[name] then
					show = false;
				end
			
				if show then
					if ANameP_ShowList and ANameP_ShowList[name]  then
						aShowIdx[aShowNum] = {i, ANameP_ShowList[name][2]};
					else
						aShowIdx[aShowNum] = {i, 0};
					end
					aShowNum =aShowNum  + 1;
				end
			else
				break;
			end
		end

		if ANameP_ShowListFirst then
			-- sort
			table.sort(aShowIdx, Comparison);
		end

		local bcannotfinddebuff = true;
		
		for v = 1 , aShowNum - 1 do
			local i = aShowIdx[v][1];			
			local name,  texture, count, debuffType, duration, expirationTime, caster, _, nameplateShowPersonal, spellId, _, isBossDebuff, _, nameplateShowAll = UnitAura(unit, i, filter);				
			local alert = false;
			local showlist_time = 0;
			
			if ANameP_ShowList and ANameP_ShowList[name] then
				showlist_time = ANameP_ShowList[name][1];
			
				if  showlist_time >= 0  then
					local alert_time = expirationTime - showlist_time;
		
					if (GetTime() >= alert_time) and duration > 0  then
						alert = true;
					else
						if self.reflesh_time and self.reflesh_time >= alert_time then
							self.reflesh_time = alert_time;
						elseif self.reflesh_time == nil then
							self.reflesh_time = alert_time;
						end

						if ANameP_ShowList[name][3] and self.colorlevel <= ColorLevel.Debuff then
							self.debuffColor = ANameP_ShowList[name][3];
							self.colorlevel = ColorLevel.Debuff;
							bcannotfinddebuff = false;
						end
					end
				end
			end

			local frameName = frametype.. numDebuffs;
			if (not self.buffList[numDebuffs]) then
				self.buffList[numDebuffs] = createDebuffFrame(self, frameName)
			end

			local frame = self.buffList[numDebuffs];
			size_list[numDebuffs] = icon_size;

			if (showlist_time) then
				size_list[numDebuffs] = icon_size;
			end

			if not PLAYER_UNITS[caster] then
				size_list[numDebuffs] = icon_size - 2;
			end

			if nameplateShowAll then
				size_list[numDebuffs] = icon_size + ANameP_PVP_Debuff_Size_Rate;
			end

			if isBossDebuff then
				size_list[numDebuffs] = icon_size + ANameP_PVP_Debuff_Size_Rate;
			end

			setSize (frame, size_list[numDebuffs]);

			if alert and duration > 0  then
				ANameP_ShowOverlayGlow(frame, false);
			else
				ANameP_HideOverlayGlow(frame);
			end
		
			local color =DebuffTypeColor["none"];

			if helpful then
				color =DebuffTypeColor["Disease"];
			end

			if ( not UnitIsUnit("player", unit) and not PLAYER_UNITS[caster]) then
				color = { r = 0.3, g = 0.3, b = 0.3 };
			end

			if debuffType then
				color = DebuffTypeColor[debuffType];
			end

			setFrame(self.buffList[numDebuffs], texture, count, expirationTime, duration, color);		
			frame:Show();
			numDebuffs = numDebuffs + 1;
		end

		if self.colorlevel == ColorLevel.Debuff and bcannotfinddebuff == true then
			self.colorlevel = ColorLevel.Reset;
		end
	end

	if not showdebuff then
		for i = 1, numDebuffs - 1 do
			updateDebuffAnchor(self.buffList, i, i - 1, size_list[i], 1, true, self);
		end
	end

	for i = numDebuffs, ANameP_MaxDebuff do
		if ( self.buffList[i] ) then
			self.buffList[i]:Hide();	
		end
	end

	if numDebuffs > 1 then
		self:Show();
	end

	if bShowCC == false then		
		self.CCdebuff:Hide();
	end
end

local function updateUnitAuras(unit)
	local nameplate = C_NamePlate.GetNamePlateForUnit(unit, issecure());
	if (nameplate and nameplate.asNamePlates and not nameplate:IsForbidden()) then	
		if nameplate.asNamePlates.checkaura then
			updateAuras(nameplate.asNamePlates, nameplate.namePlateUnitToken, nameplate.asNamePlates.filter, nameplate.asNamePlates.showbuff, nameplate.asNamePlates.helpful, nameplate.asNamePlates.showdebuff);
		else
			nameplate.asNamePlates:Hide();
		end
	end
end

local function updateTargetNameP(self)

	if not self.unit or not self.checkaura then
		return;
	end

	local parent = self:GetParent();

    if not parent or not parent.UnitFrame or parent.UnitFrame:IsForbidden()  then
		return;
    end

	local UnitFrame = parent.UnitFrame;	
	local healthBar = UnitFrame.healthBar;

    if not healthBar then
		return;
    end



	local orig_height = self.orig_height
	local cast_height = 8;

	if UnitFrame.castBar then
		cast_height = UnitFrame.castBar:GetHeight();
	end		

	if orig_height == nil then
		return;
	end

	local casticon = self.casticon;
	local height = orig_height;
	local base_y = ANameP_TargetBuffY;
	
	if UnitFrame.name:IsShown() then
		base_y = base_y + UnitFrame.name:GetHeight();
	end

	if UnitIsUnit(self.unit, "target") then		
		if self.alerthealthbar then
			--ANameP_HideOverlayGlow(healthBar);
		end

		self.alerthealthbar = false;
		height = orig_height + ANameP_TargetHealthBarHeight;
		self.healthtext:Show();

		if casticon then
			casticon:SetWidth((height + cast_height + 2) * 1.2);
			casticon:SetHeight(height + cast_height + 2);
			casticon.border:SetVertexColor(1,1,1);

			--Alert 크기 조정
			if casticon.alert then
				ANameP_HideOverlayGlow(casticon);
				if casticon.alert == 1 then
					ANameP_ShowOverlayGlow(casticon, false);
				else
					ANameP_ShowOverlayGlow(casticon, true);
				end
			end
		end

		

		if GetCVarBool("nameplateResourceOnTarget") then
			base_y = base_y +  GetClassBarHeight();	
		end
	elseif UnitIsUnit(self.unit, "player") then
		self.alerthealthbar = false;
		height = orig_height + ANameP_TargetHealthBarHeight;
		self.healthtext:Show();
	else
		height = orig_height;
		self.healthtext:Hide();
		
		if casticon then
			casticon:SetWidth((height + cast_height + 2) * 1.2);
			casticon:SetHeight(height + cast_height + 2);
			casticon.border:SetVertexColor(0,0,0);

			--Alert 크기 조정
			if casticon.alert then
				ANameP_HideOverlayGlow(casticon);
				if casticon.alert == 1 then
					ANameP_ShowOverlayGlow(casticon, false);
				else
					ANameP_ShowOverlayGlow(casticon, true);
				end
			end
		end
		
		if UnitFrame.name:IsShown() then
			base_y = base_y + 4;
		end
	end

	--Healthbar 크기
	healthBar:SetHeight(height);
	
	--버프 Position
	self:ClearAllPoints();
	if UnitIsUnit(self.unit, "player") then

		if self.downbuff then
			self:SetPoint("TOPLEFT", ClassNameplateManaBarFrame, "BOTTOMLEFT", 0, playerbuffposition );		
		else
			self:SetPoint("BOTTOMLEFT", healthBar, "TOPLEFT", 0, base_y);
		end
		if UnitFrame.BuffFrame then
			UnitFrame.BuffFrame:Hide();
		end
	else
		self:SetPoint("BOTTOMLEFT", healthBar, "TOPLEFT", 0, base_y);
		if UnitFrame.BuffFrame then
			UnitFrame.BuffFrame:Hide();
		end
	end

end

local function updateUnitHealthText(self, unit)
	local value;
	local valueMax;
	local valuePct = "";
	local namePlateFrameBase = C_NamePlate.GetNamePlateForUnit(unit, issecure());
	if not namePlateFrameBase then
		return;
	end
	local frame = namePlateFrameBase.asNamePlates;

	if not frame then
		return;
	end

	value = UnitHealth(unit);
	valueMax = UnitHealthMax(unit);

	if valueMax > 0 then
		valuePct =  (math.ceil((value / valueMax) * 100));
	end

	if (valueMax <= 300) then
		valuePct = value;
	end

	if valuePct > 0 then
		frame.healthtext:SetText(valuePct);
	else
		frame.healthtext:SetText("");
	end

	if valuePct <= lowhealthpercent then
		frame.healthtext:SetTextColor(1, 0.5, 0.5, 1);
	elseif valuePct > 0 then
		frame.healthtext:SetTextColor(1, 1, 1, 1);
	end	
end

-- Healthbar 색상 처리부
local function setColoronStatusBar(self, r, g, b)

	local parent = self:GetParent();

    if not parent or not parent.UnitFrame or parent.UnitFrame:IsForbidden()  then
		return;
    end
	
	local healthBar = parent.UnitFrame.healthBar;

    if not healthBar and healthBar:IsForbidden() then
		return;
    end

	if ( r ~= self.r or g ~= self.g or b ~= self.b ) then
		healthBar:SetStatusBarColor(r, g, b);
		self.r, self.g, self.b = r, g, b;
	end
end


local function asCompactUnitFrame_UpdateHealthColor(frame, asNameplates)
	local r, g, b;
	if ( not UnitIsConnected(frame.unit) ) then
		--Color it gray
		r, g, b = 0.5, 0.5, 0.5;
	elseif (UnitIsDead(frame.unit)) then
		--Color it gray
		r, g, b = 0.5, 0.5, 0.5;
		-- Also hide the health bar
		frame.hideHealthbar = true;
	else
		--Try to color it by class.
		local localizedClass, englishClass = UnitClass(frame.unit);
		local classColor = RAID_CLASS_COLORS[englishClass];
			--debug
			--classColor = RAID_CLASS_COLORS["PRIEST"];
			if ( (frame.optionTable.allowClassColorsForNPCs or UnitIsPlayer(frame.unit) or UnitTreatAsPlayerForDisplay(frame.unit)) and classColor and frame.optionTable.useClassColors ) then
				-- Use class colors for players if class color option is turned on
				r, g, b = classColor.r, classColor.g, classColor.b;
			elseif ( CompactUnitFrame_IsTapDenied(frame) ) then
				-- Use grey if not a player and can't get tap on unit
				r, g, b = 0.9, 0.9, 0.9;
			elseif ( frame.optionTable.colorHealthBySelection ) then
				-- Use color based on the type of unit (neutral, etc.)
				if ( frame.optionTable.considerSelectionInCombatAsHostile and CompactUnitFrame_IsOnThreatListWithPlayer(frame.displayedUnit) ) then
					r, g, b = 1.0, 0.0, 0.0;
				elseif ( UnitIsPlayer(frame.displayedUnit) and UnitIsFriend("player", frame.displayedUnit) ) then
					-- We don't want to use the selection color for friendly player nameplates because
					-- it doesn't show player health clearly enough.
					r, g, b = 0.667, 0.667, 1.0;
				else
					r, g, b = UnitSelectionColor(frame.unit, frame.optionTable.colorHealthWithExtendedColors);
				end
			elseif ( UnitIsFriend("player", frame.unit) ) then
				r, g, b = 0.0, 1.0, 0.0;
			else
				r, g, b = 1.0, 0.0, 0.0;
			end
	
	end
	setColoronStatusBar(asNameplates, r, g, b);

	if (frame.optionTable.colorHealthWithExtendedColors) then
		frame.selectionHighlight:SetVertexColor(r, g, b);
	else
		frame.selectionHighlight:SetVertexColor(1, 1, 1);
	end	
end


local function updateHealthbarColor(self)
	--unit name 부터
	if not self.unit or not self.checkcolor then
		return;
	end
	
	local unit = self.unit;

	local parent = self:GetParent();

    if not parent or not parent.UnitFrame or parent.UnitFrame:IsForbidden()  then
		return;
    end
	
	local healthBar = parent.UnitFrame.healthBar;

    if not healthBar and healthBar:IsForbidden() then
		return;
    end

	-- ColorLevel.Name;
	local unitname = GetUnitName(self.unit);
	
	if unitname and ANameP_AlertList[unitname] then
		if self.colorlevel < ColorLevel.Name then
			self.colorlevel = ColorLevel.Name;
			healthBar:SetStatusBarColor(ANameP_AlertList[unitname][1], ANameP_AlertList[unitname][2], ANameP_AlertList[unitname][3]);
		end

		if ANameP_AlertList[unitname][4] == 1 then
			--ANameP_ShowOverlayGlow(healthBar);
			self.alerthealthbar = true	
		end
		return;
	end

	--Target Check 
	local isTargetPlayer = UnitIsUnit(unit .. "target", "player");

	if (isTargetPlayer) then
		if self.colorlevel < ColorLevel.Target then
			self.colorlevel = ColorLevel.Target;
			setColoronStatusBar(self, ANameP_AggroTargetColor.r, ANameP_AggroTargetColor.g, ANameP_AggroTargetColor.b);
		end
		return;
	end

	-- Aggro Check
	local status = UnitThreatSituation("player", self.unit);
	
	if status and ANameP_AggroShow then
		local tanker = IsPlayerEffectivelyTank();		
		if tanker then			
			local aggrocolor;
			if status >= 2 then
				-- Tanking
				aggrocolor = ANameP_AggroColor;
			else
				aggrocolor = ANameP_TankAggroLoseColor;
				if #tanklist > 0 then
					for _, othertank in ipairs(tanklist) do
						if UnitIsUnit(self.unit.."target", othertank ) and not UnitIsUnit(self.unit.."target", "player" ) then
							aggrocolor = ANameP_TankAggroLoseColor2;
							break;
						end
					end													
				end					
			end
			self.colorlevel = ColorLevel.Aggro;		
			setColoronStatusBar(self, aggrocolor.r, aggrocolor.g, aggrocolor.b);
			return;
		else -- Tanker가 아닐때
			local aggrocolor;
			if status >= 1 then
				-- Tanking
				aggrocolor = ANameP_AggroColor;
				self.colorlevel = ColorLevel.Aggro;
				setColoronStatusBar(self, aggrocolor.r, aggrocolor.g, aggrocolor.b);
				return;
			end
		end
	end
	
	if lowhealthpercent > 0  then
		--Lowhealth 처리부
		local value = UnitHealth(unit);
		local valueMax = UnitHealthMax(unit);
		local valuePct = 0;

		if valueMax > 0 then
			valuePct =  (math.ceil((value / valueMax) * 100));
		end

		if valuePct <= lowhealthpercent then
			setColoronStatusBar(self, ANameP_LowHealthColor.r, ANameP_LowHealthColor.g, ANameP_LowHealthColor.b);
			self.colorlevel = ColorLevel.Lowhealth;
			return;
		end		
	end

	-- Debuff Color
	if self.colorlevel == ColorLevel.Debuff then
		setColoronStatusBar(self, self.debuffColor.r, self.debuffColor.g, self.debuffColor.b);
		return;
	end

	if status then
		if #tanklist > 0 then
			for _, othertank in ipairs(tanklist) do
				if UnitIsUnit(self.unit.."target", othertank ) and not UnitIsUnit(self.unit.."target", "player" ) then
					aggrocolor = ANameP_TankAggroLoseColor2;
					self.colorlevel = ColorLevel.Custom;
					setColoronStatusBar(self, aggrocolor.r, aggrocolor.g, aggrocolor.b);
					return;					
				end
			end
		end		
	end

	if UnitIsUnit(self.unit.."target", "pet" )  then
		aggrocolor = ANameP_TankAggroLoseColor3;
		self.colorlevel = ColorLevel.Custom;
		setColoronStatusBar(self, aggrocolor.r, aggrocolor.g, aggrocolor.b);
		return;
	end	

	-- None
	if self.colorlevel > ColorLevel.None then
		self.colorlevel = ColorLevel.None;
		asCompactUnitFrame_UpdateHealthColor(parent.UnitFrame, self);
	end

	return;
end

local function updatePVPAggro(self)

	if not ANameP_PVPAggroShow then
		return
	end

	if not self.unit then
		return
	end

	local unit = self.unit;
	local parent = self:GetParent();

	if parent.UnitFrame:IsForbidden() then
		return;
	end	

	local isTargetPlayer = UnitIsUnit(unit .. "target", "player");

	if ( isTargetPlayer) then
		self.aggro1:SetTextColor(1, 0, 0, 1);

		self.aggro1:SetText("▶");
		self.aggro1:Show();
	
		self.aggro2:SetTextColor(1, 0, 0, 1);
	
		self.aggro2:SetText("◀");
		self.aggro2:Show();
	else
		self.aggro1:Hide();
		self.aggro2:Hide();
	end
end

local function asCheckTalent(name)
	local specID = PlayerUtil.GetCurrentSpecID();
   
    local configID = C_ClassTalents.GetActiveConfigID();

	if not (configID) then
		return false;
	end
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

local function initAlertList()

	local spec = GetSpecialization();
	local localizedClass, englishClass = UnitClass("player")

	ANameP_ShowList = nil;

	if spec then
		listname = "ANameP_ShowList_" .. englishClass .. "_" .. spec;
	end

	ANameP_ShowList = _G[listname];

	ANameP_HealerGuid = {};

	lowhealthpercent = 0;

	if ANameP_LowHealthAlert then 
		local localizedClass, englishClass = UnitClass("player")
		local spec = GetSpecialization();
		local talentgroup = GetActiveSpecGroup();

		if (englishClass == "MAGE") then
			if (asCheckTalent("불타는 손길")) then
				lowhealthpercent = 30;
			end
		end

		if (englishClass == "HUNTER") then			
			if (asCheckTalent("마무리 사격")) then
				lowhealthpercent = 20;
			end			
		end


		if (englishClass == "WARRIOR") then			
			if (asCheckTalent("대학살")) then
				lowhealthpercent = 35;
			else
				lowhealthpercent = 20;
			end			
		end
	end
end

local unit_guid_list = {};

local Aggro_Y = -5;

local function isDangerousSpell(spellId, unit)
    if ANameP_DangerousSpellList[spellId] then
    	return true
     end
    return false
end

local function asNamePlates_OnEvent(self, event, ...)	
	if ( event == "UNIT_THREAT_SITUATION_UPDATE" or event == "UNIT_THREAT_LIST_UPDATE" ) then
		updateHealthbarColor(self)
	elseif( event == "PLAYER_TARGET_CHANGED") then
		updateTargetNameP(self);
	elseif( event == "UNIT_SPELLCAST_START" or event == "UNIT_SPELLCAST_CHANNEL_START" or event == "UNIT_SPELLCAST_SUCCEEDED" 
	or event == "UNIT_SPELLCAST_INTERRUPTED"  or event == "UNIT_SPELLCAST_DELAYED"  or event == "UNIT_SPELLCAST_CHANNEL_STOP"
	or event == "UNIT_SPELLCAST_STOP" ) then
	
		local unit, name , spellid = ...;

		if not (unit == self.unit) then
			return
		end

		local alert = false;		
		local name,  text, texture, startTime, endTime, isTradeSkill, castID, notInterruptible, spellid = UnitCastingInfo(unit);	
		if not name then
			name,  text, texture, startTime, endTime, isTradeSkill, notInterruptible, spellid = UnitChannelInfo(unit);
		end
		--local isTargetPlayer = UnitIsUnit (unit .. "target", "player");
		if self.casticon then
			local isDanger = isDangerousSpell (spellid, unit);
			local frameIcon = self.casticon.icon; 
			if name and frameIcon then
			--if name and frameIcon and isTargetPlayer then
				frameIcon:SetTexture(texture);
				self.casticon:Show();
				if  isDanger then
					alert = true;						
				end
			else
				self.casticon:Hide();
			end

			if alert then
				ANameP_ShowOverlayGlow(self.casticon, false);
				self.casticon.alert = 1;
			elseif notInterruptible == false then
				ANameP_ShowOverlayGlow(self.casticon, true);
				self.casticon.alert = 2;
			else
				ANameP_HideOverlayGlow(self.casticon);
				self.casticon.alert = nil;
			end
		end
	end
end

local function createNamePlate(namePlateFrameBase)
	--do nothing
end

local namePlateVerticalScale = nil;
local g_orig_height = nil;

local function addNamePlate(namePlateUnitToken)
	local namePlateFrameBase = C_NamePlate.GetNamePlateForUnit(namePlateUnitToken, issecure());

	if namePlateFrameBase.UnitFrame:IsForbidden() then
		return;
	end

	local unitFrame = namePlateFrameBase.UnitFrame;
	local healthbar = namePlateFrameBase.UnitFrame.healthBar;
	
	if UnitIsUnit("player", namePlateUnitToken) then
		if not ANameP_ShowPlayerBuff then
			if namePlateFrameBase.asNamePlates then
				namePlateFrameBase.asNamePlates.checkaura = false;
				namePlateFrameBase.asNamePlates.checkcolor = false;
				namePlateFrameBase.asNamePlates.checkpvptarget = false;
				namePlateFrameBase.asNamePlates:Hide();
				unitFrame.BuffFrame:SetAlpha(1);
			end
			return;
		end
	else
		local reaction = UnitReaction("player", namePlateUnitToken);
		if reaction and reaction <= 4 then
			-- Reaction 4 is neutral and less than 4 becomes increasingly more hostile
		elseif UnitIsPlayer(namePlateUnitToken) then
			if namePlateFrameBase.asNamePlates then
				namePlateFrameBase.asNamePlates.checkaura = false;
				namePlateFrameBase.asNamePlates.checkcolor = false;
				namePlateFrameBase.asNamePlates.checkpvptarget = false;
				namePlateFrameBase.asNamePlates:Hide();
				namePlateFrameBase.asNamePlates.healthtext:Hide();
				unitFrame.BuffFrame:SetAlpha(1);
			end
			return;
		end
	end
		
	if not namePlateFrameBase.asNamePlates then
		namePlateFrameBase.asNamePlates = CreateFrame("Frame", nil, namePlateFrameBase);
	else
		if namePlateFrameBase.asNamePlates.colorlevel > ColorLevel.None  then
			namePlateFrameBase.asNamePlates.r = nil; -- 무조건 Recover
			asCompactUnitFrame_UpdateHealthColor(unitFrame, namePlateFrameBase.asNamePlates);
		end
    end
 
	namePlateFrameBase.asNamePlates:EnableMouse(false);
	
	if not namePlateFrameBase.asNamePlates.buffList then
		namePlateFrameBase.asNamePlates.buffList = {};
	end
	namePlateFrameBase.asNamePlates.unit = nil;
	namePlateFrameBase.asNamePlates.reflesh_time = nil;
	namePlateFrameBase.asNamePlates.update = 0;
	namePlateFrameBase.asNamePlates.alerthealthbar = false;	
	namePlateFrameBase.asNamePlates.filter = nil;
	namePlateFrameBase.asNamePlates.helpful = false;
	namePlateFrameBase.asNamePlates.checkaura = false;
	namePlateFrameBase.asNamePlates.showbuff = false;
	namePlateFrameBase.asNamePlates.downbuff = false;
	namePlateFrameBase.asNamePlates.checkpvptarget = false;
	namePlateFrameBase.asNamePlates.colorlevel = ColorLevel.None;
	namePlateFrameBase.asNamePlates.bhideframe = false;
	namePlateFrameBase.asNamePlates.isshown = nil;
	namePlateFrameBase.asNamePlates.originalcolor = {r = healthbar.r, g = healthbar.g, b = healthbar.b};
	namePlateFrameBase.asNamePlates.checkcolor = false;
	
	namePlateFrameBase.asNamePlates:UnregisterEvent("UNIT_THREAT_SITUATION_UPDATE");
	namePlateFrameBase.asNamePlates:UnregisterEvent("PLAYER_TARGET_CHANGED");
	namePlateFrameBase.asNamePlates:UnregisterEvent("UNIT_SPELLCAST_START");
	namePlateFrameBase.asNamePlates:UnregisterEvent("UNIT_SPELLCAST_CHANNEL_START");
	namePlateFrameBase.asNamePlates:UnregisterEvent("UNIT_SPELLCAST_SUCCEEDED");
	namePlateFrameBase.asNamePlates:UnregisterEvent("UNIT_SPELLCAST_INTERRUPTED");
	namePlateFrameBase.asNamePlates:UnregisterEvent("UNIT_SPELLCAST_DELAYED");
	namePlateFrameBase.asNamePlates:UnregisterEvent("UNIT_SPELLCAST_CHANNEL_STOP");
	namePlateFrameBase.asNamePlates:UnregisterEvent("UNIT_SPELLCAST_STOP");
	namePlateFrameBase.asNamePlates:SetScript("OnEvent", nil);

	
	local Size = ANameP_AggroSize;
	
	if namePlateVerticalScale ~= tonumber(GetCVar("NamePlateVerticalScale")) then
		namePlateVerticalScale = tonumber(GetCVar("NamePlateVerticalScale"));
		g_orig_height = healthbar:GetHeight();
	end
		
	if namePlateVerticalScale > 1.0 then
		Aggro_Y = -1
		Size = ANameP_AggroSize + 2
		debuffs_per_line = ANameP_DebuffsPerLine + 1;
	else
		debuffs_per_line = ANameP_DebuffsPerLine;
	end

	ANameP_MaxDebuff = debuffs_per_line * 2;	 
	Aggro_Y = 0;

	namePlateFrameBase.asNamePlates.orig_height = g_orig_height;

	namePlateFrameBase.asNamePlates:ClearAllPoints();
	namePlateFrameBase.asNamePlates:SetPoint("CENTER", healthbar, "CENTER", 0  , 0)
	
	if not namePlateFrameBase.asNamePlates.aggro1  then
		namePlateFrameBase.asNamePlates.aggro1 = healthbar:CreateFontString(nil, "OVERLAY");
	end

	namePlateFrameBase.asNamePlates.aggro1:SetFont(STANDARD_TEXT_FONT, Size, "THICKOUTLINE");
    namePlateFrameBase.asNamePlates.aggro1:ClearAllPoints();
	namePlateFrameBase.asNamePlates.aggro1:SetPoint("RIGHT", healthbar, "LEFT", -5  , Aggro_Y)


	if not namePlateFrameBase.asNamePlates.aggro2  then
		namePlateFrameBase.asNamePlates.aggro2 = healthbar:CreateFontString(nil, "OVERLAY");
	end
	namePlateFrameBase.asNamePlates.aggro2:SetFont(STANDARD_TEXT_FONT, Size, "THICKOUTLINE");
    namePlateFrameBase.asNamePlates.aggro2:ClearAllPoints();
	namePlateFrameBase.asNamePlates.aggro2:SetPoint("LEFT", healthbar, "RIGHT", 0, Aggro_Y)

	if not namePlateFrameBase.asNamePlates.healer  then
		namePlateFrameBase.asNamePlates.healer = healthbar:CreateFontString(nil, "OVERLAY");
	end
	if ANameP_HealerSize > 0 then
		namePlateFrameBase.asNamePlates.healer:SetFont(STANDARD_TEXT_FONT, ANameP_HealerSize, "THICKOUTLINE");
	else
		namePlateFrameBase.asNamePlates.healer:SetFont(STANDARD_TEXT_FONT, 1, "THICKOUTLINE");
	end
    namePlateFrameBase.asNamePlates.healer:ClearAllPoints();
	namePlateFrameBase.asNamePlates.healer:SetPoint("RIGHT", healthbar, "LEFT", -5  , Aggro_Y)
	namePlateFrameBase.asNamePlates.healer:SetText("★");
	namePlateFrameBase.asNamePlates.healer:SetTextColor(0, 1, 0, 1);
	namePlateFrameBase.asNamePlates.healer:Hide();

	if not namePlateFrameBase.asNamePlates.healthtext then
		namePlateFrameBase.asNamePlates.healthtext = healthbar:CreateFontString(nil, "OVERLAY");
	end

	namePlateFrameBase.asNamePlates.healthtext:SetFont(STANDARD_TEXT_FONT, ANameP_HeathTextSize, "OUTLINE");
	namePlateFrameBase.asNamePlates.healthtext:ClearAllPoints();
	namePlateFrameBase.asNamePlates.healthtext:SetPoint("CENTER", healthbar, "CENTER", 0  , 0)

	if unitFrame.castBar then
		if not namePlateFrameBase.asNamePlates.casticon  then
			namePlateFrameBase.asNamePlates.casticon = CreateFrame("Frame", nil, unitFrame.castBar, "asNamePlatesBuffFrameTemplate");
		end
		namePlateFrameBase.asNamePlates.casticon:EnableMouse(false);
        namePlateFrameBase.asNamePlates.casticon:ClearAllPoints();
		namePlateFrameBase.asNamePlates.casticon:SetPoint("BOTTOMLEFT", unitFrame.castBar, "BOTTOMRIGHT", 0, 1);
		namePlateFrameBase.asNamePlates.casticon:SetWidth(13);
		namePlateFrameBase.asNamePlates.casticon:SetHeight(13);

		local frameIcon = namePlateFrameBase.asNamePlates.casticon.icon; 
		local frameBorder = namePlateFrameBase.asNamePlates.casticon.border;
				
		frameIcon:SetTexCoord(.08, .92, .08, .92);
		frameBorder:SetTexture("Interface\\Addons\\asNamePlates\\border.tga");
		frameBorder:SetTexCoord(0.08,0.08, 0.08,0.92, 0.92,0.08, 0.92,0.92);
		namePlateFrameBase.asNamePlates.casticon:Hide();
	end


	if not namePlateFrameBase.asNamePlates.CCdebuff  then
		namePlateFrameBase.asNamePlates.CCdebuff = CreateFrame("Frame", nil, unitFrame.healthBar, "asNamePlatesBuffFrameTemplate");
	end
	namePlateFrameBase.asNamePlates.CCdebuff:EnableMouse(false);
    namePlateFrameBase.asNamePlates.CCdebuff:ClearAllPoints();
	namePlateFrameBase.asNamePlates.CCdebuff:SetPoint("LEFT", namePlateFrameBase.asNamePlates.casticon, "RIGHT", 1, 0);
	namePlateFrameBase.asNamePlates.CCdebuff:SetWidth(ANameP_CCDebuffSize * 1.2);
	namePlateFrameBase.asNamePlates.CCdebuff:SetHeight(ANameP_CCDebuffSize);

	local frameIcon = namePlateFrameBase.asNamePlates.CCdebuff.icon;
	local frameBorder = namePlateFrameBase.asNamePlates.CCdebuff.border;
			
	frameIcon:SetTexCoord(.08, .92, .08, .92);
	frameBorder:SetTexture("Interface\\Addons\\asNamePlates\\border.tga");
	frameBorder:SetTexCoord(0.08,0.08, 0.08,0.92, 0.92,0.08, 0.92,0.92);

	for _,r in next,{namePlateFrameBase.asNamePlates.CCdebuff.cooldown:GetRegions()}	do 
		if r:GetObjectType()=="FontString" then 
			r:SetFont(STANDARD_TEXT_FONT, ANameP_CooldownFontSize,"OUTLINE")
			r:SetPoint("TOP", 0, 4);
			break;
		end 
	end

	namePlateFrameBase.asNamePlates.CCdebuff:Hide();
	
	if namePlateFrameBase.asNamePlates then 
		namePlateFrameBase.asNamePlates.unit = namePlateUnitToken;
		namePlateFrameBase.asNamePlates.filter = nil;
		namePlateFrameBase.asNamePlates.helpful = false;
		namePlateFrameBase.asNamePlates.checkaura = false;
		namePlateFrameBase.asNamePlates.showbuff = false;
		namePlateFrameBase.asNamePlates.downbuff = false;
		namePlateFrameBase.asNamePlates.healthtext:Hide();
		namePlateFrameBase.asNamePlates.checkpvptarget = false;
		namePlateFrameBase.asNamePlates.colorlevel = ColorLevel.None;
		namePlateFrameBase.asNamePlates.checkcolor = false;
		
		for i = 1, ANameP_MaxDebuff do
			if ( namePlateFrameBase.asNamePlates.buffList[i] ) then
				namePlateFrameBase.asNamePlates.buffList[i]:Hide();	
			end
		end

        if UnitIsPlayer(namePlateUnitToken) then
			namePlateFrameBase.asNamePlates.colorlevel = ColorLevel.Name;
		else
			local bInstance, RTB_ZoneType = IsInInstance();
			if not (RTB_ZoneType == "pvp" or RTB_ZoneType == "arena") then
				--PVP 에서는 어그로 Check 안함
				namePlateFrameBase.asNamePlates:RegisterUnitEvent("UNIT_THREAT_SITUATION_UPDATE", "player", namePlateUnitToken );
				namePlateFrameBase.asNamePlates:RegisterUnitEvent("UNIT_THREAT_LIST_UPDATE", "player", namePlateUnitToken );
			end

			namePlateFrameBase.asNamePlates:SetScript("OnEvent", asNamePlates_OnEvent);
			namePlateFrameBase.asNamePlates:RegisterEvent("PLAYER_TARGET_CHANGED");
			namePlateFrameBase.asNamePlates:RegisterUnitEvent("UNIT_SPELLCAST_START", namePlateUnitToken);
			namePlateFrameBase.asNamePlates:RegisterUnitEvent("UNIT_SPELLCAST_CHANNEL_START", namePlateUnitToken);
			namePlateFrameBase.asNamePlates:RegisterUnitEvent("UNIT_SPELLCAST_SUCCEEDED", namePlateUnitToken);
			namePlateFrameBase.asNamePlates:RegisterUnitEvent("UNIT_SPELLCAST_INTERRUPTED", namePlateUnitToken);
			namePlateFrameBase.asNamePlates:RegisterUnitEvent("UNIT_SPELLCAST_DELAYED", namePlateUnitToken);
			namePlateFrameBase.asNamePlates:RegisterUnitEvent("UNIT_SPELLCAST_CHANNEL_STOP", namePlateUnitToken);
			namePlateFrameBase.asNamePlates:RegisterUnitEvent("UNIT_SPELLCAST_STOP", namePlateUnitToken);

		end			
			
		if ANameP_SIZE > 0 then
			namePlateFrameBase.asNamePlates.icon_size = ANameP_SIZE;
		else
			local orig_width = healthbar:GetWidth();
			namePlateFrameBase.asNamePlates.icon_size = (orig_width / debuffs_per_line) - (debuffs_per_line - 1);
		end
				
		local class = UnitClassification(namePlateUnitToken)

		namePlateFrameBase.asNamePlates.aggro1:ClearAllPoints();

		if class == "worldboss" or class == "elite" then
			namePlateFrameBase.asNamePlates.aggro1:SetPoint("RIGHT", healthbar, "LEFT", -5, Aggro_Y);
		else
			namePlateFrameBase.asNamePlates.aggro1:SetPoint("RIGHT", healthbar, "LEFT", 0, Aggro_Y);
		end

		namePlateFrameBase.asNamePlates.aggro1:Hide();
		namePlateFrameBase.asNamePlates.aggro2:Hide();
		namePlateFrameBase.asNamePlates:SetWidth(1);
		namePlateFrameBase.asNamePlates:SetHeight(1);
		namePlateFrameBase.asNamePlates:SetScale(1);		

		local showbuff = false;
		local helpful = false;
		local showhealer = false;
		local checkaura = false;
		local showdebuff = false;
		local checkpvptarget = false;
		local checkcolor = false;

		if UnitIsUnit("player", namePlateUnitToken) then
			--namePlateFrameBase.asNamePlates:Hide();
			if ANameP_ShowPlayerBuff then

				if ANameP_ShowPlayerBuffDefault then
					filter = "HELPFUL|INCLUDE_NAME_PLATE_ONLY";
				else
					filter = "HELPFUL|PLAYER|INCLUDE_NAME_PLATE_ONLY";
				end
				helpful = true;
				checkaura = true;
				unitFrame.BuffFrame:SetAlpha(0);
				unitFrame:UnregisterEvent("UNIT_AURA");
				namePlateFrameBase.asNamePlates:Show();	
				
				-- Resource Text
				if ClassNameplateManaBarFrame and ANameP_Resourcetext == nil then
					ANameP_Resourcetext = ClassNameplateManaBarFrame:CreateFontString(nil, "OVERLAY");
					ANameP_Resourcetext:SetFont(STANDARD_TEXT_FONT, ANameP_HeathTextSize, "OUTLINE");
					ANameP_Resourcetext:SetAllPoints(true);
					ANameP_Resourcetext:SetPoint("CENTER", ClassNameplateManaBarFrame, "CENTER", 0  , 0);
				end

				Buff_Y = ANameP_PlayerBuffY;

				if Buff_Y < 0 then
					namePlateFrameBase.asNamePlates.downbuff = true;
					namePlateFrameBase.asNamePlates:ClearAllPoints();
					if GetCVar("nameplateResourceOnTarget") == "0" then
						playerbuffposition = Buff_Y - GetClassBarHeight();
					else
						playerbuffposition = Buff_Y;
					end	
				end
			else
				checkaura = false;
			end			
		else
			local reaction = UnitReaction("player", namePlateUnitToken);
			if reaction and reaction <= 4 then
				-- Reaction 4 is neutral and less than 4 becomes increasingly more hostile
				filter = "HARMFUL|INCLUDE_NAME_PLATE_ONLY";
				showbuff = true;

				if UnitIsPlayer(namePlateUnitToken) and ANameP_HealerGuid[UnitGUID(namePlateUnitToken)] then
					showhealer = true;
				end

				if UnitIsPlayer(namePlateUnitToken) then
					checkpvptarget = true;
				else
					checkcolor = true;
				end
				checkaura = true;
				unitFrame.BuffFrame:SetAlpha(0);
				unitFrame:UnregisterEvent("UNIT_THREAT_SITUATION_UPDATE");
				unitFrame:UnregisterEvent("UNIT_THREAT_LIST_UPDATE");
				unitFrame:UnregisterEvent("UNIT_AURA");
				namePlateFrameBase.asNamePlates:Show();
			elseif not namePlateFrameBase:IsForbidden() then
				filter = "HELPFUL|INCLUDE_NAME_PLATE_ONLY|PLAYER";
				helpful = true;
				showbuff = false;

				checkaura = false
			
				if not showdebuff  and not UnitIsUnit(namePlateUnitToken, "player") and  ANameP_HealerGuid[UnitGUID(namePlateUnitToken)] then
					showhealer = true;
				end
				namePlateFrameBase.asNamePlates:Hide();
			end
		end

		namePlateFrameBase.asNamePlates.filter = filter;
		namePlateFrameBase.asNamePlates.helpful = helpful;
		namePlateFrameBase.asNamePlates.checkaura = checkaura;
		namePlateFrameBase.asNamePlates.showbuff = showbuff;
		namePlateFrameBase.asNamePlates.showdebuff = showdebuff;
		namePlateFrameBase.asNamePlates.checkpvptarget = checkpvptarget;
		namePlateFrameBase.asNamePlates.checkcolor = checkcolor;

		if showhealer and ANameP_HealerSize > 0  then
			namePlateFrameBase.asNamePlates.healer:Show();
		else
			namePlateFrameBase.asNamePlates.healer:Hide();
		end
	end

	if UnitIsPlayer(namePlateUnitToken) then
		unit_guid_list[UnitGUID(namePlateUnitToken)] = namePlateUnitToken;
	end	
end

local function removeNamePlate(namePlateUnitToken)
	local namePlateFrameBase = C_NamePlate.GetNamePlateForUnit(namePlateUnitToken, issecure());
	if namePlateFrameBase and namePlateFrameBase.asNamePlates then
		for i = 1, ANameP_MaxDebuff do
			if ( namePlateFrameBase.asNamePlates.buffList[i] ) then
				namePlateFrameBase.asNamePlates.buffList[i]:Hide();	
			end
		end

		namePlateFrameBase.asNamePlates.aggro1:Hide();
		namePlateFrameBase.asNamePlates.aggro2:Hide();
		namePlateFrameBase.asNamePlates:Hide();
		namePlateFrameBase.asNamePlates:UnregisterEvent("UNIT_THREAT_SITUATION_UPDATE");
		namePlateFrameBase.asNamePlates:UnregisterEvent("PLAYER_TARGET_CHANGED");
		namePlateFrameBase.asNamePlates:UnregisterEvent("UNIT_SPELLCAST_START");
		namePlateFrameBase.asNamePlates:UnregisterEvent("UNIT_SPELLCAST_CHANNEL_START");
		namePlateFrameBase.asNamePlates:SetScript("OnEvent", nil);
		namePlateFrameBase.asNamePlates.r = nil;
		-- Add할때 다시 Color를 복구 하자
		--namePlateFrameBase.asNamePlates.colorlevel = ColorLevel.None;

		if namePlateFrameBase.UnitFrame and namePlateFrameBase.UnitFrame.healthBar then

			if namePlateFrameBase.asNamePlates.alerthealthbar then
				--ANameP_HideOverlayGlow(namePlateFrameBase.UnitFrame.healthBar);
				namePlateFrameBase.asNamePlates.alerthealthbar = false;
				namePlateFrameBase.UnitFrame.healthBar:SetStatusBarColor(namePlateFrameBase.asNamePlates.originalcolor.r, namePlateFrameBase.asNamePlates.originalcolor.g, namePlateFrameBase.asNamePlates.originalcolor.b);
				namePlateFrameBase.asNamePlates.colorlevel = ColorLevel.None;
			end

			if namePlateFrameBase.asNamePlates.colorlevel > ColorLevel.None then
				namePlateFrameBase.UnitFrame.healthBar:SetStatusBarColor(namePlateFrameBase.asNamePlates.originalcolor.r, namePlateFrameBase.asNamePlates.originalcolor.g, namePlateFrameBase.asNamePlates.originalcolor.b);
				namePlateFrameBase.asNamePlates.colorlevel = ColorLevel.None;
			end
		end		
	end

	if UnitIsPlayer(namePlateUnitToken) and  UnitGUID(namePlateUnitToken) then
		unit_guid_list[UnitGUID(namePlateUnitToken)] = nil;
	end
end

local function updateHealerMark(guid)
	local unit = unit_guid_list[guid];
	
	if unit and ANameP_HealerGuid[guid] and not UnitIsUnit(unit, "player") then
		local nameplate = C_NamePlate.GetNamePlateForUnit(unit, issecure());
		if (nameplate and nameplate.asNamePlates and not nameplate:IsForbidden() and not nameplate.asNamePlates.showdebuff and nameplate.asNamePlates.checkpvptarget ) then
			nameplate.asNamePlates.healer:Show();
		end
	end
end

local function asCompactUnitFrame_UpdateNameFaction(namePlateUnitToken)
	local namePlateFrameBase = C_NamePlate.GetNamePlateForUnit(namePlateUnitToken, issecure());
	if namePlateFrameBase and namePlateFrameBase.asNamePlates and not namePlateFrameBase:IsForbidden() then
		addNamePlate(namePlateUnitToken);
		if namePlateFrameBase.asNamePlates then
			updateTargetNameP(namePlateFrameBase.asNamePlates);
			updateUnitAuras(namePlateUnitToken);
			updateHealthbarColor(namePlateFrameBase.asNamePlates);
		end		
	end
end

local function ANameP_OnEvent(self, event, ...)	
	if event == "NAME_PLATE_CREATED" then
		local namePlateFrameBase = ...;
		createNamePlate(namePlateFrameBase);
	elseif event == "NAME_PLATE_UNIT_ADDED"then
		local namePlateUnitToken = ...;
		local namePlateFrameBase = C_NamePlate.GetNamePlateForUnit(namePlateUnitToken, issecure());
		addNamePlate(namePlateUnitToken);
		if namePlateFrameBase.asNamePlates then
			updateTargetNameP(namePlateFrameBase.asNamePlates);
			updateUnitAuras(namePlateUnitToken);
			updateUnitHealthText(self, "target");
			updateUnitHealthText(self, "player");
			updateHealthbarColor(namePlateFrameBase.asNamePlates);
		end		
	elseif event == "NAME_PLATE_UNIT_REMOVED"  then
		local namePlateUnitToken = ...;
		removeNamePlate(namePlateUnitToken);
	elseif event == event == "UNIT_SPELLCAST_SUCCEEDED" and arg1 == "player"  then
		updateUnitAuras("target");
		updateUnitAuras("player");
		updateUnitHealthText(self, "target");
	elseif event == "PLAYER_TARGET_CHANGED" then
		updateUnitAuras("target");
		updateUnitHealthText(self, "target");
	elseif (event == "TRAIT_CONFIG_UPDATED") or (event == "TRAIT_CONFIG_LIST_UPDATED") or (event == "ACTIVE_TALENT_GROUP_CHANGED") then
		C_Timer.After(0.5, initAlertList);		
	elseif (event == "PLAYER_ENTERING_WORLD") then
		isInstance, instanceType = IsInInstance();
		if isInstance and (instance=="party" or instance=="raid" or instance=="scenario") then
			self:UnregisterEvent("COMBAT_LOG_EVENT_UNFILTERED");
		else
			self:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED");
		end
		updateTankerList();

		-- 0.5 초 뒤에 Load
		C_Timer.After(0.5, initAlertList);

	elseif event == "COMBAT_LOG_EVENT_UNFILTERED" then	
		local _, eventType, _, sourceGUID, _, _, _, destGUID, _, _, _, spellID, _, _, auraType = CombatLogGetCurrentEventInfo();
		if eventType == "SPELL_CAST_SUCCESS" and sourceGUID and not (sourceGUID == "") then
			local className = GetPlayerInfoByGUID(sourceGUID);
			if className  and ANameP_HealSpellList[className] and  ANameP_HealSpellList[className][spellID]  then
				ANameP_HealerGuid[sourceGUID] = true;
				updateHealerMark(sourceGUID);
			end
		end
	elseif ( event == "UNIT_FACTION" ) then
		local namePlateUnitToken = ...;
		asCompactUnitFrame_UpdateNameFaction(namePlateUnitToken);
	elseif (event == "GROUP_JOINED" or event == "GROUP_ROSTER_UPDATE" or event == "PLAYER_ROLES_ASSIGNED") then
		updateTankerList();	
	end
end

local function updateUnitResourceText(self, unit)
	local value;
	local valueMax;
	local valuePct = ""
	if UnitIsUnit("player", unit) then
	else
		return;
	end

	if ANameP_Resourcetext == nil then
		return;
	end

	value = UnitPower(unit);
	valueMax = UnitPowerMax(unit);

	if valueMax > 0 then
		valuePct =  (math.ceil((value / valueMax) * 100));
	end

	if (valueMax <= 300) then
		valuePct = value;
	end

	if valuePct > 0 then
		ANameP_Resourcetext:SetText(valuePct);
	else
		ANameP_Resourcetext:SetText("");
	end


	if valuePct > 0 then

		ANameP_Resourcetext:SetTextColor(1, 1, 1, 1);
	end

end


local function ANameP_OnUpdate()
	updateUnitHealthText(ANameP, "target");
	updateUnitHealthText(ANameP, "player");
	updateUnitResourceText(ANameP, "player");
	
	for _,v in pairs(C_NamePlate.GetNamePlates(issecure())) do
		local nameplate = v;

		if (nameplate and  nameplate.asNamePlates and not nameplate:IsForbidden()) then
			if nameplate.asNamePlates.checkaura then
				updateAuras(nameplate.asNamePlates, nameplate.namePlateUnitToken, nameplate.asNamePlates.filter, nameplate.asNamePlates.showbuff, nameplate.asNamePlates.helpful, nameplate.asNamePlates.showdebuff);
			else
				nameplate.asNamePlates:Hide();
			end

			if nameplate.asNamePlates.checkpvptarget then
				updatePVPAggro(nameplate.asNamePlates);
			end
			updateHealthbarColor(nameplate.asNamePlates);
		end
	end
end

local function initAddon()
	ANameP = CreateFrame("Frame", nil, UIParent)

	ANameP:RegisterEvent("NAME_PLATE_CREATED");
	ANameP:RegisterEvent("NAME_PLATE_UNIT_ADDED");
	ANameP:RegisterEvent("NAME_PLATE_UNIT_REMOVED");
	-- 나중에 추가 처리가 필요하면 하자.
	--ANameP:RegisterEvent("FORBIDDEN_NAME_PLATE_UNIT_ADDED");
	--ANameP:RegisterEvent("FORBIDDEN_NAME_PLATE_UNIT_REMOVED");
	ANameP:RegisterEvent("PLAYER_TARGET_CHANGED");
	ANameP:RegisterEvent("PLAYER_ENTERING_WORLD");
	ANameP:RegisterEvent("ADDON_LOADED")
	ANameP:RegisterEvent("TRAIT_CONFIG_UPDATED");
	ANameP:RegisterEvent("TRAIT_CONFIG_LIST_UPDATED");
	ANameP:RegisterEvent("ACTIVE_TALENT_GROUP_CHANGED");
	ANameP:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED");
	ANameP:RegisterEvent("UNIT_FACTION");
	ANameP:RegisterUnitEvent("UNIT_SPELLCAST_SUCCEEDED", "player");
	ANameP:RegisterEvent("GROUP_JOINED");
	ANameP:RegisterEvent("GROUP_ROSTER_UPDATE");
	ANameP:RegisterEvent("PLAYER_ROLES_ASSIGNED");
	
	ANameP:SetScript("OnEvent", ANameP_OnEvent)
	--주기적으로 Callback
	C_Timer.NewTicker(ANameP_UpdateRate, ANameP_OnUpdate);	

	hooksecurefunc("DefaultCompactNamePlateFrameAnchorInternal", function(frame, setupOptions)
		if ( frame:IsForbidden() ) then return end
						
		local pframe = C_NamePlate.GetNamePlateForUnit("target", issecure())

		if pframe and frame.BuffFrame.unit == pframe.namePlateUnitToken and pframe.asNamePlates then
			updateTargetNameP(pframe.asNamePlates);
		end		
	end)
end

initAddon();

