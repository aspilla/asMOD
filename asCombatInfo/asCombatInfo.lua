local ACI = {nil, nil};
local ACI_mainframe;
ACI_SpellList = nil;

-- 설정
local ACI_SIZE = 40;									-- Button Size

local ACI_CoolButtons_X = 0 			-- 쿨 List 위치 X
local ACI_CoolButtons_Y = -162 - 20							-- Y 위치
local ACI_Alpha = 1										-- 전투중 알파값
local ACI_Alpha_Normal = 0.5							-- 비전투중 안보이게 하려면 0
local ACI_CooldownFontSize = 12;						-- Cooldown Font Size
local ACI_CountFontSize = 12;							-- Count Font Size
local ACI_MaxSpellCount = 11;							-- 최대 Spell Count
local ACI_RefreshRate = 0.5;							-- 반복 Check 주기 (초)


-- 성기사 징벌
-- 	ACI_SpellList_직업명_특성숫자
-- 	{Spell, Type, arg1} 순으로 편집
-- 	Spell 기술명 혹은 ID (버프는 ID로 입력해야 Icon 나옴)
-- 	Type : 1 Spell Cool down
-- 	Type : 2 버프 & Spell Cool down
-- 	Type : 3 버프 & Spell Cool down 상세 Value가 있는경우
-- 	Type : 4 디버프 & Spell Cool down, arg1 이 없을 경우 "target", "player"로 하면 자신의 디버프 확인 가능 "focus" 활용가능  ex	{"약점 공격", 4},
-- 	Type : 5 전투도적 통찰 only
-- 	Type : 6 버프 & Spell Cool down (버프 off 일때 회색으로)
-- 	Type : 7 버프 only Spell ID 등록해야 함 arg1 없을 경우 "player", "pet"으로 pet 버프 확인가능 ex 	{118455, 7, "pet"},
-- 	Type : 8 디버프 only Spell ID ex {55078, 8}, --> 죽기 역병
-- 	Type : 9 1 + 대상 체력 % 미만이면 강조 ex {"영혼 쐐기", 9, 35}
-- 	Type : 10 양조 수도 시간차 전용

ACI_SpellList_WARRIOR_1 = {
	{"제압", 1},
	{"필사의 일격", 1},
	{"거인의 강타", 1},
	{1, {"마무리 일격", 1, true}, {"마무리 일격", 1, true}, 1},
	{"칼날폭풍", 1},

};


ACI_SpellList_WARRIOR_2 = {
	{3, {"돌진", 1}, {"돌진", 1}, 2},
	{"분노의 강타", 1},
	{"피의 갈증", 1},
	{"무모한 희생", 2},
	{"마무리 일격", 1, true},
			
};

ACI_SpellList_WARRIOR_3 = {
	{"고통 감내", 3},
	{"방패 올리기", 1},
	{"방패 밀쳐내기", 1},
	{"복수", 1},
	{"천둥벼락", 1},

};

ACI_SpellList_ROGUE_1 = {
	{7, {"소멸", 1}, 2,{"소멸", 1}},
	{6, {"그림자 밟기", 1}, 1, 1},
	{"원한", 4},
	{"목조르기", 4, nil, 5.4},
	{"파열", 4, nil, 7.2},

};


ACI_SpellList_ROGUE_2 = {
	{"뼈주사위", 14, nil, 5},
	{"권총 사격", 1},
	{"아드레날린 촉진", 2},
	{"폭풍의 칼날", 1},
	{7, {"소멸", 1}, 1, 1},
	

};

ACI_SpellList_ROGUE_3 = {
	{7, {"소멸", 1}, 1, 1},
	{"죽음의 상징", 2, nil, 10.5},
	{"어둠의 춤", 1},
	{"어둠의 칼날", 2}, 
	{"암흑칼날", 4, nil, 4.8},


};


ACI_SpellList_HUNTER_1 = {
	{118455, 7, "pet"},
	{"살상 명령", 1},
	{"야수의 격노", 2},
	{"마무리 사격", 1},	
	{"반격의 사격", 1},
};



ACI_SpellList_HUNTER_2 = {
	{257621, 7, "player"},
	{"신비한 사격", 1},
	{"정조준", 2},	
	{"마무리 사격", 1},	
	{"속사", 1},
};


ACI_SpellList_HUNTER_3 = {
	{"야생불 폭탄", 1},
	{"저미기", 1},
	{"살상 명령", 1},
	{"협공", 2},
	{"독사 쐐기", 4},
};



ACI_SpellList_MAGE_1 = {
	{4, {"점멸", 1}, 1, 1},
	{"냉정", 1},
	{3, {116267, 7, "player", nil, 4 }, 1, {"마력의 룬", 11, nil, true}},
	{"신비의 마법 강화", 2},
	{"환기", 2},
};

ACI_SpellList_MAGE_2 = {
	{"시간 왜곡", 1},
	{"일렁임", 1},
	{"발화", 2},
	{"마력의 룬", 2},	
	{"얼음 방패", 1}, 
};

ACI_SpellList_MAGE_3 = {
	{4, {"점멸", 1}, 2, 1},
	{"눈보라", 1},
	{3, {116267, 7, "player", nil, 4}, 1, {"마력의 룬", 11, nil, true}},
	{"얼음 핏줄", 2},
	{"얼어붙은 구슬", 1},
};

ACI_SpellList_PALADIN_1 = {
	{5 , {"응징의 격노", 2}, 2, 1},
	{"빛 주입", 2},
	{"여명의 빛", 1},
	{"신성 충격", 1},
	{"심판", 1},
};


ACI_SpellList_PALADIN_2 = {
	{"신성화", 1},
	{"응징의 방패", 1},
	{"정의의 망치", 1}, 
	{"수호자의 빛", 1},
	{"심판", 1},
};

ACI_SpellList_PALADIN_3 = {
	{4, 2, 1, 1},
    {2, {"응징의 격노", 2},{"응징의 격노", 2}, 2 },
	{"성전사의 일격", 1},
	{"심판의 칼날", 1},
	{"심판", 1},

};

ACI_SpellList_PRIEST_1 = {
	{"고통 억제", 1},
	{"신의 권능: 광휘", 1},
	{"속죄", 18},
	{"환희", 2},
	{"회개", 1},
};

ACI_SpellList_PRIEST_2 = {
	{"천상의 찬가", 1},
	{"빛의 권능: 신성화", 1},
	{"빛의 권능: 평온", 1},
	{"회복의 기원", 1},
	{5, 2, {"수호 영혼", 2} , 1},
};


ACI_SpellList_PRIEST_3 = {
	{5, {194249, 7}, 1, 1},
	{"공허 방출", 1},
	{"정신 분열", 1},
	{34914, 8, nil, 4},
	{589, 8, nil, 5},

};


ACI_SpellList_DEATHKNIGHT_1 = {
	{"죽음과 부패", 1},
	{195181, 7},
	{77535, 12},
	{"피의 소용돌이", 1},
	{1, {"흡혈", 2}, 1, 1},
};

ACI_SpellList_DEATHKNIGHT_2 = {
	{7, {"룬 무기 강화", 2},  {"룬 무기 강화", 2}, 2},
	{1, 2, 2, 2},
	{"냉혹한 겨울", 1},
	{"얼음 기둥", 2},
	{6, 2, 1, 1},
	};

ACI_SpellList_DEATHKNIGHT_3 = {
	{"죽음과 부패", 1},
	{"대재앙", 1},
	{"어둠의 변신", 2, "pet"},
	{191587, 8, nil, 6.3},
	{194310, 8},
};


ACI_SpellList_MONK_1 = {
	{"무쇠가죽주", 2},
	{"의식 상실의 일격", 1},
	{"맥주통 휘두르기", 1},
	{"불의 숨결", 1},
	{"강화주", 2},
	
};

ACI_SpellList_MONK_2 = {
	{"기의 고치", 1},
	{"정수의 샘", 1},
	{"소생의 안개", 1},
	{"집중의 천둥 차", 2},
	{"재활", 1},
};



ACI_SpellList_MONK_3 = {
	{"회전 학다리차기", 1},
	{"폭풍과 대지와 불", 6},
	{"분노의 주먹", 1},
	{"해오름차기", 1},
	{6, 2, 1, 1},
};




ACI_SpellList_DRUID_1 = {
	{"달의 일격", 1},
	{"달빛섬광", 4, nil, 22 *  0.3},
	{7, {"천체의 정렬", 2} ,1 , 1},
	{"태양섬광", 4, nil, 18 * 0.3},
	{"태양의 격노", 1},

};

ACI_SpellList_DRUID_2 = {
	{6, {"난타", 4}, 1, 2},
	{7, {"광폭화", 2}, 2, 1},
	{"호랑이의 분노", 2},
	{"도려내기", 4, nil, 7.2},
	{"갈퀴 발톱", 4, nil, 4.5},
};

ACI_SpellList_DRUID_3 = {
	{"생존 본능", 2},
	{"광포한 재생력", 2},
	{"짓이기기", 1},
	{"난타", 1},
	{"나무 껍질", 2},
};

ACI_SpellList_DRUID_4 = {
	{"무쇠껍질", 2},
	{1, {"정신 자극", 1},  {"정신 자극", 1},  1},
	{"신속한 치유", 1},
	{"급속 성장", 1},
	{"평온", 1},
};



ACI_SpellList_SHAMAN_1 = {
	{7, 2, 1, 1},
	{1, {"대지 충격", 1}, {"대지 충격", 1}, 1},
	{"용암 폭발", 1},
	{6, {"불의 정령", 1}, {"불의 정령", 1}, 1},
	{"화염 충격", 4, nil, 18 * 0.3},
};


ACI_SpellList_SHAMAN_2= {
	{7, {"대지의 정령", 1}, 1, 1},
	{"대지이빨", 1},
	{"폭풍의 일격", 1},
	{"낙뢰", 1},
	{"야수 정령", 1},
};

ACI_SpellList_SHAMAN_3= {
	{"치유의 해일 토템", 11},
	{"치유의 토템", 11},
	{"성난 해일", 1},
	{"치유의 비", 1},
	{53390, 7, nil, 3, 2},
		
};



ACI_SpellList_WARLOCK_1 = {
	{2, {"암흑시선 소환", 11, "암흑시선"}, {"암흑시선 소환", 11, "암흑시선"}, 4},
	{4, {"부패의 씨앗", 4 }, 1, 1},
	{"불안정한 고통", 16, nil , 3},	
	{"부패", 4, nil , 14 * 0.3},	
	{"고통", 4, nil , 18 * 0.3},	
}


ACI_SpellList_WARLOCK_2 = {
	{138748, 15, "굴단의 손", 8},
	{"공포사냥개 부르기", 1},	
	{264173, 7, nil, 0},	
	{4, {"악마 폭군 소환", 1 }, 1, 1},
	{1, {"영원한 결의", 2},	 1, 1},
}


ACI_SpellList_WARLOCK_3 = {
  	{ 7,  {"영원한 결의", 2}, 1, 1},
	{1, {"지옥불정령 소환", 11, "지옥불정령" }, 4,1 },	
	{"점화", 1},	
	{"대혼란", 1},
	{"제물", 4, nil, 5.4},	
}


ACI_SpellList_DEMONHUNTER_1 = {
	{"글레이브 투척", 1},
	{"칼춤", 1},
	{"안광", 1},
	{7, {"탈태", 2},{"탈태", 2}, 1},
	{1, {"지옥 돌진", 1}, {"지옥 돌진", 1}, 1},
}

ACI_SpellList_DEMONHUNTER_2 = {
	{"영혼 베어내기", 1},
	{"제물의 오라", 1},
	{"악마 쐐기", 1},
	{"탈태", 2},
	{3, {"불꽃의 인장", 1}, {"불꽃의 인장", 1}, 1},
}





local update = 0;
local prev_i = {0, 0, 0, 0, 0 };
local prev_s = {0, 0, 0, 0, 0};
local prev_d = {0, 0, 0, 0, 0};
local prev_spell = {};
local prev_icon = {};
local prev_alert = {};
local prev_disable = {};
local prev_count = {};
local cast_spell = nil;
local cast_time = nil;

-- 높은 수 일 수록 보이는 우선순위 높음 (조정 필요)
local roguespell = {
	[7] = "무자비한 정밀함",
	[6] = "숨겨진 보물", 
	[5] = "집중 공격",
	[4] = "진방위",
	[3] = "대난투",
	[2] = "해적 징표", 
	[1] = "난도질", 
}


ACI_Cool_list = {};
ACI_Buff_list = {};
ACI_Debuff_list = {};
ACI_Player_Debuff_list = {};
ACI_Active_list = {};
ACI_SpellID_list = {};
ACI_Action_slot_list = {};
ACI_Alert_list = {};

local ACI_Current_Buff = "";
local ACI_Current_Count = 0;


--Overlay stuff
local unusedOverlayGlows = {};
local numOverlays = 0;
local function ACI_ActionButton_GetOverlayGlow()
	local overlay = tremove(unusedOverlayGlows);
	if ( not overlay ) then
		numOverlays = numOverlays + 1;
		overlay = CreateFrame("Frame", "ACI_ActionButtonOverlay"..numOverlays, UIParent, "ACI_ActionBarButtonSpellActivationAlert");
	end
	return overlay;
end

-- Shared between action button and MainMenuBarMicroButton
local function ACI_ShowOverlayGlow(button)
	if ( button.overlay ) then
		if ( button.overlay.animOut:IsPlaying() ) then
			button.overlay.animOut:Stop();
			button.overlay.animIn:Play();
		end
	else
		button.overlay = ACI_ActionButton_GetOverlayGlow();
		local frameWidth, frameHeight = button:GetSize();
		button.overlay:SetParent(button);
		button.overlay:ClearAllPoints();
		--Make the height/width available before the next frame:
		button.overlay:SetSize(frameWidth * 1.5, frameHeight * 1.5);
		button.overlay:SetPoint("TOPLEFT", button, "TOPLEFT", -frameWidth * 0.3, frameHeight * 0.3);
		button.overlay:SetPoint("BOTTOMRIGHT", button, "BOTTOMRIGHT", frameWidth * 0.3, -frameHeight * 0.3);
		button.overlay.animIn:Play();
	end
end

-- Shared between action button and MainMenuBarMicroButton
local function ACI_HideOverlayGlow(button)
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

ACI_ActionBarButtonSpellActivationAlertMixin = {};

function ACI_ActionBarButtonSpellActivationAlertMixin:OnUpdate(elapsed)
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

function ACI_ActionBarButtonSpellActivationAlertMixin:OnHide()
	if ( self.animOut:IsPlaying() ) then
		self.animOut:Stop();
		self.animOut:OnFinished();
	end
end

ACI_ActionBarOverlayGlowAnimInMixin = {};

function ACI_ActionBarOverlayGlowAnimInMixin:OnPlay()
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

function ACI_ActionBarOverlayGlowAnimInMixin:OnFinished()
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

ACI_ActionBarOverlayGlowAnimOutMixin = {};

function ACI_ActionBarOverlayGlowAnimOutMixin:OnFinished()
	local overlay = self:GetParent();
	local actionButton = overlay:GetParent();
	overlay:Hide();
	tinsert(unusedOverlayGlows, overlay);
	actionButton.overlay = nil;
end



local function isArray(t)
	if type(t)~="table" then return nil end
	--check if all the table keys are numerical and count their number
	local count=0
	for k,v in pairs(t) do
		if type(k)~="number" then return false else count=count+1 end
	end
	--all keys are numerical. now let's see if they are sequential and start with 1
	for i=1,count do
		--Hint: the VALUE might be "nil", in that case "not t[i]" isn't enough, that's why we check the type
		if not t[i] and type(t[i])~="nil" then return false end
	end
	return true
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



local function checkBuffCount(buff)

	local count = 0;

	if IsInGroup() then
		if IsInRaid() then -- raid
			for i=1,GetNumGroupMembers() do
				local unitid = "raid"..i
				local name = getUnitBuffbyName(unitid, buff, "PLAYER") 
				if name then
					count = count + 1;	
				end
			end
		else -- party

			for i=1,GetNumSubgroupMembers() do
				local unitid = "party"..i
				local name = getUnitBuffbyName(unitid, buff, "PLAYER") 

				if name then
					count = count + 1;	
				end
			end

			local name = getUnitBuffbyName("player", buff, "PLAYER") 

			if name then
				count = count + 1;	
			end
		end
	end

	return count;
end


local function ACI_Alert(self, bcastspell)

	if not self.idx then
		return;
	end

	local i = self.idx;

	
	if ACI_SpellList == nil or ACI_SpellList[i] == nil then
		ACI[i]:Hide();
		return;
	end

	if self.alert == nil then
		self.alert = false;
	end

	local spellname = ACI_SpellList[i][1];
	local t = ACI_SpellList[i][2];
	local discard,discard,icon;	
	local start, duration, enable;
	local isUsable, notEnoughMana;
	local count;
	local buff_cool = false;
	local buff_miss = false;
	local debuffType = nil;
	local frameIcon;
	local frameCooldown;
	local frameCount;
	local frameBorder;
	local frame;
	local alert_count = nil;
	local charges, maxCharges, chargeStart, chargeDuration, chargeModRate; 
	local chargecool = false;


	frame = _G["ACI"..i];
	frameIcon = _G["ACI"..i.."Icon"];
	frameCooldown = _G["ACI"..i.."Cooldown"];
	frameCount =  _G["ACI"..i.."Count"];
	frameBorder = _G["ACI"..i.."Border"];
	

	if t == 1 or t == 9  then
	
		discard,discard,icon = GetSpellInfo(spellname)
		start, duration, enable = GetSpellCooldown(spellname);
		local _, gcd  = GetSpellCooldown(61304);
		isUsable, notEnoughMana = IsUsableSpell(spellname);
		count = GetSpellCharges(spellname);
		charges, maxCharges, chargeStart, chargeDuration, chargeModRate = GetSpellCharges(spellname);

		if count == 1 and (not maxCharges or maxCharges <= 1) then
			count = 0;
		end


		if not count or count == 0 then
			if ACI_Action_slot_list[i]  then
				count = GetActionCount(ACI_Action_slot_list[i]);
				charges, maxCharges, chargeStart, chargeDuration, chargeModRate = GetActionCharges(ACI_Action_slot_list[i]);
			end
		end

		

		if isUsable and duration > gcd then
			isUsable = false
		end

		if ( charges and maxCharges and maxCharges > 1 and charges < maxCharges ) then
			start = chargeStart;
			duration = chargeDuration;
			chargecool = true
		end


		if t == 9 and ACI_SpellList[i][3] then

			if  UnitHealthMax("target") > 0 then
				local health =  UnitHealth("target") / UnitHealthMax("target") * 100

				if health <= ACI_SpellList[i][3] then
					ACI_Alert_list[spellname] = true;
				else
					ACI_Alert_list[spellname] = false;
				end
			end
		elseif t == 1 and ACI_SpellList[i][3] then
			if isUsable or notEnoughMana then
				ACI_Alert_list[spellname] = true;
			else
				ACI_Alert_list[spellname] = false;
			end
		end

	elseif t == 2 or t==3 or t == 5  or t == 6 or t == 7 or t == 12 or t == 17 or t == 18 then



		if t == 5 then
			spellname = ACI_Current_Buff;
			if spellname == "" then
				spellname = 84745;
			end
		end

		local unit = ACI_SpellList[i][3];
		if unit == nil then
			unit = "player"
		end

		alert_count = ACI_SpellList[i][5];

		ACI_Alert_list[spellname] = false;
		
		if t == 5 and spellname == "깊은 통찰" then
			ACI_Alert_list[spellname] = true;
		end

		local alert_du = ACI_SpellList[i][4];
		local disablespell = ACI_SpellList[i][6];

		local buff_name = spellname;
	
		if 	t == 7 or t == 12 or t == 17 then
			buff_name = GetSpellInfo(spellname)
		end

		if not buff_name then
			buff_name = spellname
		end

		
		if (t == 17) then
			local debuff_idx = 1;
			count = 0;
			expirationTime = 0xFFFFFFFF;
			icon = nil;

			repeat
				local nametemp, icontemp, _, debuffTypetemp, durationtemp, expirationTimetemp, castertemp, _, _  = UnitBuff(unit, debuff_idx);

				if nametemp and nametemp == buff_name and castertemp and UnitIsUnit(castertemp, "player") then
					count = count + 1;

					if expirationTimetemp < expirationTime then
						expirationTime = expirationTimetemp
						duration = durationtemp;
					end
					icon = icontemp;
					caster = "player";
				end
						
				debuff_idx = debuff_idx + 1;

			until (nametemp == nil)
		
		else
			_,  icon, count, _, duration, expirationTime, _, _, _, _, _,_ ,_,_,_,stack  = getUnitBuffbyName(unit, buff_name);

		end
		if icon then		
			start = expirationTime - duration;
			isUsable = true
			enable = 1
	
			if count <= 1 then
				count = GetSpellCharges(spellname);
				charges, maxCharges, chargeStart, chargeDuration, chargeModRate = GetSpellCharges(spellname);
				
				if count == 1 and (not maxCharges or maxCharges <= 1) then
					count = 0;
				end
			end
			buff_cool = true;
		
			self.exTime = nil;
			if alert_du and (expirationTime - GetTime()) <= alert_du  then
				ACI_Alert_list[spellname] = true;
			elseif alert_du then
				self.exTime = expirationTime - alert_du; 
			end

		elseif not disablespell then
			discard,discard,icon = GetSpellInfo(spellname)
			start, duration, enable = GetSpellCooldown(spellname);
			isUsable, notEnoughMana = IsUsableSpell(spellname);
			count = GetSpellCharges(spellname);
			charges, maxCharges, chargeStart, chargeDuration, chargeModRate = GetSpellCharges(spellname);

			if count == 1 and (not maxCharges or maxCharges <= 1) then
				count = 0;
			end

			if not count or count == 0 then
				if ACI_Action_slot_list[i]  then
					count = GetActionCount(ACI_Action_slot_list[i]);
					charges, maxCharges, chargeStart, chargeDuration, chargeModRate = GetActionCharges(ACI_Action_slot_list[i]);				
				end
			end

			if buff_name ~= spellname then
				isUsable = false;
			end

			if ( charges and maxCharges and maxCharges > 1 and charges < maxCharges ) then
				start = chargeStart;
				duration = chargeDuration;
				chargecool = true
			end



		end

		if t == 3 or t == 12 then
			count = stack
		end

		if t == 5 then
			count = ACI_Current_Count;
		end

		if t == 18 then
			count = checkBuffCount(buff_name);
		end

	elseif t == 4 or t == 8 or t == 16 then


		local unit = ACI_SpellList[i][3];
		if unit == nil then
			unit = "target"
		end

		local filter = nil;
		
		if unit == "target" then
			filter = "PLAYER"
		end


		local buff_name = spellname;

		ACI_Alert_list[spellname] = false;
		local alert_du = ACI_SpellList[i][4];

		alert_count = ACI_SpellList[i][5];

		if 	t == 8 then
			buff_name = GetSpellInfo(spellname)
		end

		if not buff_name then
			buff_name = spellname
		end


		if (t == 16) then
			local debuff_idx = 1;
			count = 0;
			expirationTime = 0xFFFFFFFF;
			icon = nil;

			repeat
				local nametemp, icontemp, _, debuffTypetemp, durationtemp, expirationTimetemp, castertemp, _, _  = UnitDebuff(unit, debuff_idx, filter);

				if nametemp and nametemp == buff_name and castertemp and UnitIsUnit(castertemp, "player") then
					count = count + 1;

					if expirationTimetemp < expirationTime then
						expirationTime = expirationTimetemp
						duration = durationtemp;
					end
					icon = icontemp;
					caster = "player";
				end
						
				debuff_idx = debuff_idx + 1;

			until (nametemp == nil)
		
		else
			_, icon, count, debuffType, duration, expirationTime, caster, _, _, _, _,_ ,_,_,_,stack  = getUnitDebuffbyName(unit, buff_name, filter);
			
		end

		if (not (unit == "player") ) and caster ~= "player" then
			icon = nil;
		end

		if icon then		
			start = expirationTime - duration;
			isUsable = 1
			enable = 1

			if count <= 1 then
				count = GetSpellCharges(spellname);

				charges, maxCharges, chargeStart, chargeDuration, chargeModRate = GetSpellCharges(spellname);
				
				if count == 1 and (not maxCharges or maxCharges <= 1) then
					count = 0;
				end

			end
			buff_cool = true;

			self.exTime = nil;

			if alert_du and (expirationTime - GetTime()) <= alert_du and duration > 0  then
				ACI_Alert_list[spellname] = true;
			elseif  alert_du then
				self.exTime = expirationTime - alert_du; 
			end

		else
			discard,discard,icon = GetSpellInfo(spellname)
			start, duration, enable = GetSpellCooldown(spellname);
			isUsable, notEnoughMana = IsUsableSpell(spellname);
			count = GetSpellCharges(spellname);
			charges, maxCharges, chargeStart, chargeDuration, chargeModRate = GetSpellCharges(spellname);
			if count == 1 and (not maxCharges or maxCharges <= 1) then
				count = 0;
			end

			if not count or count == 0 then
				if ACI_Action_slot_list[i]  then
					count = GetActionCount(ACI_Action_slot_list[i]);
					charges, maxCharges, chargeStart, chargeDuration, chargeModRate = GetActionCharges(ACI_Action_slot_list[i]);
				end
			end


			isUsable = false;

			if ( charges and maxCharges and maxCharges > 1 and charges < maxCharges ) then
				start = chargeStart;
				duration = chargeDuration;
				chargecool = true
			end

		end

		--count = nil
	elseif t == 10 then
	
		buff_name = nil
		spellname = 124275;

		_, _, icon, count, debuffType, duration, expirationTime, caster, _, _, _, _,_ ,_,stack  = getUnitDebuffbyName("player",  "작은 시간차");

		if icon then
			buff_name = "작은 시간차";
			spellname = 124275;
		end

		_, _, icon, count, debuffType, duration, expirationTime, caster, _, _, _, _,_ ,_,stack  = getUnitDebuffbyName("player",  "중간 시간차");
		
		if icon then
			buff_name = "중간 시간차";
			spellname = 124274;
		end

		_, _, icon, count, debuffType, duration, expirationTime, caster, _, _, _, _,_ ,_,stack  = getUnitDebuffbyName("player",  "큰 시간차");
		
		if icon then
			buff_name = "큰 시간차";
			spellname = 124273;
		end
		
		icon = nil;

		if buff_name then
			_, _, icon, count, debuffType, duration, expirationTime, caster, _, _, _, _,_ ,_,stack  = getUnitDebuffbyName("player",  buff_name);
		end


		if icon then		
			start = expirationTime - duration;
			isUsable = 1
			enable = 1
			count = math.ceil(UnitStagger("player")/UnitHealthMax("player") * 100);
			buff_cool = true;
		else
			discard,discard,icon = GetSpellInfo(spellname)
			start, duration, enable = GetSpellCooldown(spellname);
			isUsable, notEnoughMana = IsUsableSpell(spellname);
			count = GetSpellCharges(spellname);
			charges, maxCharges, chargeStart, chargeDuration, chargeModRate = GetSpellCharges(spellname);

			if count == 1 and (not maxCharges or maxCharges <= 1) then
				count = 0;
			end


			if not count or count == 0 then
				if ACI_Action_slot_list[i]  then
					count = GetActionCount(ACI_Action_slot_list[i]);
					charges, maxCharges, chargeStart, chargeDuration, chargeModRate = GetActionCharges(ACI_Action_slot_list[i]);
				end
			end

			isUsable = false;

			if ( charges and maxCharges and maxCharges > 1 and charges < maxCharges ) then
				start = chargeStart;
				duration = chargeDuration;
				chargecool = true
			end

		end

	elseif t == 11  then

		isUsable = false;

		local slot_name = ACI_SpellList[i][3];
		local check_buff = ACI_SpellList[i][4];

		if slot_name == nil then

			slot_name = spellname;
		end


		if check_buff == nil then
			check_buff = false;

		end

	
		for slot=1, MAX_TOTEMS do
			local haveTotem;
			haveTotem, name, start, duration, icon = GetTotemInfo(slot);

			if name == slot_name then
				buff_cool = true;
				isUsable = true;
				enable = 1;
				count = 0;

				if check_buff then
					local hasbuff  = getUnitBuffbyName("player", slot_name);

					if not hasbuff then
						buff_miss = true;
						
					end
				end

				break;
			end
		end

		if isUsable == false then
			discard,discard,icon = GetSpellInfo(spellname)
			start, duration, enable = GetSpellCooldown(spellname);
			isUsable, notEnoughMana = IsUsableSpell(spellname);
			count = GetSpellCharges(spellname);


			charges, maxCharges, chargeStart, chargeDuration, chargeModRate = GetSpellCharges(spellname);

			if count == 1 and (not maxCharges or maxCharges <= 1) then
				count = 0;
			end


			if not count or count == 0 then
				if ACI_Action_slot_list[i]  then
					count = GetActionCount(ACI_Action_slot_list[i]);
					charges, maxCharges, chargeStart, chargeDuration, chargeModRate = GetActionCharges(ACI_Action_slot_list[i]);
				end
			end
		
			if ( charges and maxCharges and maxCharges > 1 and charges < maxCharges ) then
				start = chargeStart;
				duration = chargeDuration;
				chargecool = true
			end

		end

	elseif t == 14 then
	
		spellname = 193316;

		local idx;

		discard,discard,icon = GetSpellInfo(spellname);
		duration = 0;
		start = 0;
		isUsable = 0
		enable = 0
		count = 0;
		for _,buffname in ipairs(roguespell) do

			local texture;
			local temp_du;
			local temp_ex;



			name ,  texture, _, _, temp_du, temp_ex = getUnitBuffbyName("player",  buffname, "PLAYER");

			if name then
				count = count + 1;
				icon = texture;
				duration = temp_du;
				start = temp_ex - duration;
				isUsable = 1
				enable = 1
				buff_cool = true;
			end
		end

		if count > 2 then
			ACI_Alert_list[spellname] = true;
		else
			ACI_Alert_list[spellname] = false;
		end

	elseif t == 15  then

		isUsable = false;

		local slot_name = ACI_SpellList[i][3];
		local slot_du = ACI_SpellList[i][4];


		if slot_name == nil then
			slot_name = spellname;
		end

		if slot_du == nil then
			slot_du = 0;
		end


		if ACI_SpellList[i][5] == nil then
			ACI_SpellList[i][5] = {};
		end


		count = 0;
		if cast_spell and GetSpellInfo(cast_spell) == slot_name and bcastspell then
			cast_spell = nil;
			tinsert(ACI_SpellList[i][5], cast_time)
		end



		local currtime = GetTime();
		for k,v in pairs(ACI_SpellList[i][5]) do
			if (v + slot_du) < currtime then
				tremove(ACI_SpellList[i][5], k);
			else
				discard,discard,icon = GetSpellInfo(spellname)
				start = v;
				duration = slot_du;
				buff_cool = true;
				isUsable = true;
				enable = 1;
			end
		end

        count = #ACI_SpellList[i][5];


		if isUsable == false then
			discard,discard,icon = GetSpellInfo(spellname)
			start, duration, enable = GetSpellCooldown(spellname);
			isUsable, notEnoughMana = IsUsableSpell(spellname);
			count = GetSpellCharges(spellname);
		end
	end

	if icon == nil then

	--	frame:Hide();
		frameBorder:Hide();
		frameIcon:SetDesaturated(true)
		frameCooldown:Hide();
		frameCount:Hide();


		return;
	else
		frame:Show();
	end

	local skip = false

	if ( isUsable ) then

		frameIcon:SetDesaturated(false)

		frameIcon:SetVertexColor(1.0, 1.0, 1.0);
		frameIcon:SetAlpha(1);
	
		if t >= 2 and t ~= 9 then

			if buff_cool then
				frameIcon:SetVertexColor(1.0, 1.0, 1.0);
				frameIcon:SetAlpha(1);

				if t == 3 and count == 0 then
					frameIcon:SetDesaturated(true)
				end

			else
				frameIcon:SetVertexColor(0.7, 0.7, 0.7);
				frameIcon:SetAlpha(1);
				
				if  t == 6 then
					frameIcon:SetDesaturated(false)
				else
				 	frameIcon:SetDesaturated(true)
				end

			end
		end

		if t == 5 and count == 0 then
			frameIcon:SetDesaturated(true)
		end

	elseif ( notEnoughMana ) then
		frameIcon:SetVertexColor(0.5, 0.5, 1);
		frameIcon:SetAlpha(1);
		frameIcon:SetDesaturated(true)
	else
		frameIcon:SetVertexColor(0.4, 0.4, 0.4);
		frameIcon:SetAlpha(1);
		frameIcon:SetDesaturated(true)
	end

	--[[
	frameIcon:SetTexCoord(.08, .92, .08, .92)

	--CreateBDFrame(frameBorder, 1);
	frameBorder:SetTexture("Interface\\Addons\\asCombatInfo\\border.tga")
	frameBorder:SetTexCoord(0.08,0.08, 0.08,0.92, 0.92,0.08, 0.92,0.92)	
	frameBorder:SetVertexColor(0, 0, 0);
	--]]

	if ( buff_cool ) then

		if debuffType then
			color = DebuffTypeColor[debuffType];
		elseif buff_miss then
			color = {r = 1.0, g = 0, b = 0};
		else
			if t == 4 or t == 8 then
				color = DebuffTypeColor["none"];
			else
				color = DebuffTypeColor["Disease"];
			end
		end
		frameBorder:SetVertexColor(color.r, color.g, color.b);
		frameBorder:SetAlpha(1);
		frameBorder:Show();
	else
		frameBorder:Hide();
	end

	if alert_count and count and count >= alert_count  then
		ACI_Alert_list[spellname] = true;
	end


	if  ACI_Active_list[spellname] or ACI_Alert_list[spellname]  then
		if self.alert == false then
			ACI_ShowOverlayGlow(frame);
		end
		self.alert = true;
	else
		if self.alert == true then
			ACI_HideOverlayGlow(frame);
		end
		self.alert = false;

	end


	frameIcon:SetTexture(icon);

	if (duration ~= nil and duration > 0 and duration < 500 ) then		
			-- set the count
		CooldownFrame_Set(frameCooldown, start, duration, duration > 0, enable);
		frameCooldown:SetDrawSwipe(false);
		frameCooldown:Show();
		frameCooldown:SetHideCountdownNumbers(false);
	else
		frameCooldown:Hide();
	end

	if ( count and count > 0 ) then

		if(count > 999999) then 
			count = math.ceil(count/1000000) .. "m" 
		elseif(count > 999) then 
			count = math.ceil(count/1000) .. "k" 
		end   						

		if frame.cooldownfont then
			frame.cooldownfont:ClearAllPoints();
			frame.cooldownfont:SetPoint("TOPLEFT", 4, -4);
			frameCooldown:SetDrawSwipe(false);
		end
	
		frameCount:SetText(count)
		frameCount:Show();
	else

		if frame.cooldownfont then
			frame.cooldownfont:ClearAllPoints();
			frame.cooldownfont:SetPoint("CENTER", 0, 0);
			frameCooldown:SetDrawSwipe(true);
		end

		frameCount:Hide();
	end

	return;
end

local function ACI_OnUpdate()

	for i = 1, ACI_mainframe.maxIdx do
		if ACI[i].updateaura then
			ACI_Alert(ACI[i]);
		end
	end
end

local function ACI_ButtonOnEvent(self, event, arg1, ...)

	if (event == "PLAYER_TARGET_CHANGED") then
		
		if UnitHealthMax(self.unit) > 0 then

			local health =  UnitHealth(self.unit) / UnitHealthMax(self.unit) * 100

			if self.health and self.health >= health then
				self.checkhealth = true;
			else
				self.checkhealth = false;
			end
		end

		ACI_Alert(self);
	elseif (event == "UNIT_AURA" and arg1 == self.unit) then
		ACI_Alert(self);
	elseif event == "ACTIONBAR_UPDATE_COOLDOWN" then
		ACI_Alert(self);
	elseif event == "ACTIONBAR_UPDATE_USABLE" then
		ACI_Alert(self);
	elseif event == "SPELL_UPDATE_CHARGES" then
		ACI_Alert(self);
	elseif event == "UNIT_SPELLCAST_SUCCEEDED" then
		_, cast_spell = ...;
		cast_time = GetTime();
		ACI_Alert(self, true);
	elseif event == "PLAYER_TOTEM_UPDATE" then
		ACI_Alert(self);
	elseif event == "UNIT_HEALTH" and arg1 == self.unit then
		local health =  UnitHealth(self.unit) / UnitHealthMax(self.unit) * 100

		if self.health >= health  then

			if (self.checkhealth == false) then
				self.checkhealth = true;
				ACI_Alert(self);
			end
		else
			self.checkhealth = false;
		end
	end
end


local bfirst = false;
local event_frames = {}
event_frames["PLAYER_TARGET_CHANGED"] = {};
event_frames["UNIT_AURA"] = {};
event_frames["ACTIONBAR_UPDATE_COOLDOWN"] = {};
event_frames["ACTIONBAR_UPDATE_USABLE"] = {};
event_frames["SPELL_UPDATE_CHARGES"] = {};
event_frames["UNIT_SPELLCAST_SUCCEEDED"] = {};
event_frames["PLAYER_TOTEM_UPDATE"] = {};
event_frames["UNIT_HEALTH"] = {};


local function EventsFrame_RegisterFrame(event, frame)
	tinsert(event_frames[event], frame);
end



local function ACI_OnEvent(self, event, arg1, ...)
	
	if event_frames[event] and #event_frames[event] > 0 then	
		for k, frame in pairs(event_frames[event]) do
			ACI_ButtonOnEvent(frame, event, arg1, ...);
		end
		return;
	end


	if event == "PLAYER_ENTERING_WORLD" then
		ACI_Init();
		bfirst = true;
		if UnitAffectingCombat("player") then
			for i = 1, ACI_MaxSpellCount do
				ACI[i]:SetAlpha(ACI_Alpha);
			end
		else
			for i = 1, ACI_MaxSpellCount do
				ACI[i]:SetAlpha(ACI_Alpha_Normal);
			end
		end
	elseif event == "PLAYER_REGEN_DISABLED" then
		for i = 1, ACI_MaxSpellCount do
			ACI[i]:SetAlpha(ACI_Alpha);
		end
	elseif event == "PLAYER_REGEN_ENABLED" then
		for i = 1, ACI_MaxSpellCount do
			ACI[i]:SetAlpha(ACI_Alpha_Normal);
		end

	elseif event == "UNIT_ENTERING_VEHICLE" then
		for i = 1, ACI_MaxSpellCount do
			ACI[i]:SetAlpha(0);
		end
	elseif event == "UNIT_EXITING_VEHICLE" then
		if UnitAffectingCombat("player") then
			for i = 1, ACI_MaxSpellCount do
				ACI[i]:SetAlpha(ACI_Alpha);
			end
		else
			for i = 1, ACI_MaxSpellCount do
				ACI[i]:SetAlpha(ACI_Alpha_Normal);
			end
		end

	elseif event == "ACTIVE_TALENT_GROUP_CHANGED" or event == "PLAYER_TALENT_UPDATE" then
		ACI_Init();
		bfirst = true;
	elseif event == "ACTIONBAR_SLOT_CHANGED" and bfirst then
		bfirst = false;
		ACI_Init();
	elseif event == "SPELL_ACTIVATION_OVERLAY_GLOW_SHOW" then
		local spell = GetSpellInfo(arg1);
		ACI_Active_list[spell] = true;
		ACI_Active_list[arg1] = true;
		if ACI_Cool_list and  ACI_Cool_list[spell] then
			ACI_Alert(ACI[ACI_Cool_list[spell]]);
		end
	elseif event == "SPELL_ACTIVATION_OVERLAY_GLOW_HIDE" then
		local spell = GetSpellInfo(arg1);
		ACI_Active_list[spell] = false;
		ACI_Active_list[arg1] = false;
		if ACI_Cool_list and  ACI_Cool_list[spell] then
			ACI_Alert(ACI[ACI_Cool_list[spell]]);
		end
	end
	return;
end 

local function ACI_GetActionSlot(arg1)
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


---------------
--  Options  --
---------------
local function deepcopy(orig)
    local orig_type = type(orig)
    local copy
    if orig_type == 'table' then
        copy = {}
        for orig_key, orig_value in next, orig, nil do
            copy[deepcopy(orig_key)] = deepcopy(orig_value)
        end
        setmetatable(copy, deepcopy(getmetatable(orig)))
    else -- number, string, boolean, etc
        copy = orig
    end
    return copy
end



local ACI_Spec = nil;
local ACI_timer = nil;

function ACI_Init()



	local localizedClass, englishClass = UnitClass("player")
	local spec = GetSpecialization();
	local talentgroup = GetActiveSpecGroup();
	local listname = "ACI_SpellList";


	ACI_mainframe.update = 0;

	if ACI_timer then
		ACI_timer:Cancel();
	end
	
	--버튼
	ACI_SpellList = {};


	if spec then
		listname = "ACI_SpellList" .. "_" .. englishClass .. "_" .. spec;
	end

	prev_i = {};
	prev_icon = {};
	prev_alert = {};
	prev_disable = {};
	prev_count = {};

	ACI_SpellList = nil;
	ACI_SpellListtmp = _G[listname];
	ACI_Cool_list = {}
	ACI_Buff_list = {}
	ACI_Debuff_list = {}
	ACI_SpellID_list = {}
	ACI_Player_Debuff_list = {}
	ACI_Action_slot_list = {};


	if ACI_SpellListtmp and #ACI_SpellListtmp then
		ACI_SpellList = {}

		for i = 1, #ACI_SpellListtmp do
			local value1 =ACI_SpellListtmp[i][1];
			local value2 =ACI_SpellListtmp[i][2];
			local value3 =ACI_SpellListtmp[i][3];
			local value4 =ACI_SpellListtmp[i][4];
			local value5 =ACI_SpellListtmp[i][5];

			ACI_SpellList[i] = {value1, value2, value3, value4, value5};
		end

	end

	--[[

	if type(ACI_Settings)~="table" then
		ACI_Settings = {}
	end
	if spec then

		if type(ACI_Settings[spec])~="table" or #ACI_Settings[spec]== 0 then
			ACI_Settings[spec] = deepcopy(ACI_SpellList)
		end

		ACI_SpellList = deepcopy(ACI_Settings[spec])
	else
		ACI_SpellList = nil;
		return;

	end

	--]]
	--
	event_frames["PLAYER_TARGET_CHANGED"] = {};
	event_frames["UNIT_AURA"] = {};
	event_frames["ACTIONBAR_UPDATE_COOLDOWN"] = {};
	event_frames["ACTIONBAR_UPDATE_USABLE"] = {};
	event_frames["SPELL_UPDATE_CHARGES"] = {};
	event_frames["UNIT_SPELLCAST_SUCCEEDED"] = {};
	event_frames["PLAYER_TOTEM_UPDATE"] = {};
	event_frames["UNIT_HEALTH"] = {};


	for i = 1, ACI_MaxSpellCount do
			
		ACI[i].update = 0;
		ACI[i]:Hide();
			--ACI_Alert(ACI[i]);
	end

	if (ACI_SpellList and #ACI_SpellList) then

		if ACI_Spec == nil and ACI_Spec ~= spec then
		--	ChatFrame1:AddMessage("[ACI] ".. listname .. "을 Load 합니다.");
			ACI_Spec = spec;
		end
		
		local maxIdx = #ACI_SpellList;

		if maxIdx > ACI_MaxSpellCount then
			maxIdx = ACI_MaxSpellCount;
		end

		ACI_mainframe.maxIdx = maxIdx;

		for i = 1, maxIdx do

			--ACI_Action_slot_list[i] = ACI_GetActionSlot(ACI_SpellList[i][2]);

			local tier = tonumber (ACI_SpellList[i][1]);

			if tier and talentgroup and tier < 9 then
				local bselected = false;
				for column = 1, 3 do
					local talentID, name, texture, selected, available, spellID, _, _, _, _, grantedByAura = GetTalentInfo(tier, column, talentgroup);

					if selected or grantedByAura  then

						bselected = true;
						local frame = _G["ACI"..i];

						local frameIcon = _G["ACI"..i.."Icon"];

						frameIcon:SetTexture(texture);

						frameIcon:SetVertexColor(1.0, 1.0, 1.0);
						frameIcon:SetAlpha(1);
						frameIcon:SetDesaturated(true)
						frame:Show();


						ACI_SpellList[i][1] = name;

						if ACI_SpellList[i][column + 1] then

							local array = ACI_SpellList[i][column + 1];


							if type(array) == "table"	then
								local z;

								ACI_SpellList[i][3] = nil;
								ACI_SpellList[i][4] = nil;

								for z = 1, #array do
									ACI_SpellList[i][z] = array[z];			
								end

							else
								ACI_SpellList[i][2] = tonumber(ACI_SpellList[i][column + 1]);
								ACI_SpellList[i][3] = nil;
								ACI_SpellList[i][4] = nil;
							end
						else

							if IsHarmfulSpell(name) then
								ACI_SpellList[i][2] = 4;
							elseif IsPassiveSpell(name) then
								ACI_SpellList[i][2] = 2;
							elseif IsHelpfulSpell(name) then
								ACI_SpellList[i][2] = 2;
							else
								ACI_SpellList[i][2] = 6;
							end
						end
					end
				end

				if not bselected then
					ACI_SpellList[i][1] = nil;
					ACI_SpellList[i][2] = nil;

					ACI_SpellList[i][3] = nil;
					ACI_SpellList[i][4] = nil;

				end
			end


			if ACI_SpellList[i][2] == 1 or ACI_SpellList[i][2] == 9 then
				ACI_Cool_list[ACI_SpellList[i][1]] = i;
				local id = select (7, GetSpellInfo(ACI_SpellList[i][1]));

				ACI_Action_slot_list[i] = ACI_GetActionSlot(ACI_SpellList[i][1]);

				if id then
					ACI_SpellID_list[id] = true;
				end
			elseif ACI_SpellList[i][2] == 2 or ACI_SpellList[i][2] == 3 or ACI_SpellList[i][2] == 5 or  ACI_SpellList[i][2] == 6 then

				ACI_Action_slot_list[i] = ACI_GetActionSlot(ACI_SpellList[i][1]);

				ACI_Buff_list[ACI_SpellList[i][1]] = i;
				local id = select (7, GetSpellInfo(ACI_SpellList[i][1]));
				if id then
					ACI_SpellID_list[id] = true;
				end
			
			elseif ACI_SpellList[i][2] == 4 or ACI_SpellList[i][2] == 16  then 
				ACI_Debuff_list[ACI_SpellList[i][1]] = i;

				local id = select (7, GetSpellInfo(ACI_SpellList[i][1]));

				ACI_Action_slot_list[i] = ACI_GetActionSlot(ACI_SpellList[i][1]);

				if id then
					ACI_SpellID_list[id] = true;
				end

				if ACI_SpellList[i][3] and ACI_SpellList[i][3] == "player" then
					ACI_Player_Debuff_list[ACI_SpellList[i][1]] = i;
				end

			elseif ACI_SpellList[i][2] == 7 or ACI_SpellList[i][2] == 12 or ACI_SpellList[i][2] == 17 or ACI_SpellList[i][2] == 18  then 
				local name = GetSpellInfo(ACI_SpellList[i][1]);

				ACI_Action_slot_list[i] = ACI_GetActionSlot(name);

				if name then
					ACI_Buff_list[name] = i;
				end
				ACI_SpellID_list[ACI_SpellList[i][1]] = true;

			elseif ACI_SpellList[i][2] == 8 then 

				local name = GetSpellInfo(ACI_SpellList[i][1]);

				ACI_Action_slot_list[i] = ACI_GetActionSlot(name);

				if name then
					ACI_Debuff_list[name] = i;
				end
				ACI_SpellID_list[ACI_SpellList[i][1]] = true;

				if name and ACI_SpellList[i][3] and ACI_SpellList[i][3] == "player" then
					ACI_Player_Debuff_list[name] = i;
				end

			elseif ACI_SpellList[i][2] == 10 then 
				ACI_Player_Debuff_list["작은 시간차"] = true;
				ACI_Player_Debuff_list["중간 시간차"] = true;
				ACI_Player_Debuff_list["큰 시간차"] = true;
			elseif ACI_SpellList[i][2] == 14 then 
				ACI_Buff_list["난도질"] = true;
			elseif ACI_SpellList[i][2] == 11  or ACI_SpellList[i][2] == 15  then 

				local slot_name = ACI_SpellList[i][3];

				if slot_name == nil then
					ACI_Buff_list[ACI_SpellList[i][1]] = true;
				else
					ACI_Buff_list[slot_name] = true;
				end


				ACI_SpellID_list[ACI_SpellList[i][1]] = true;

			end
			ACI[i].idx = i;
	
			ACI_Alert(ACI[i]);


			ACI[i].update = 0;
			ACI[i].updateaura = true;




			
			local t = ACI_SpellList[i][2];

			if t == 4 or t == 8 or t == 16 then
				ACI[i].unit =ACI_SpellList[i][3];
				if ACI[i].unit == nil then
					ACI[i].unit  = "target"
				end

				if ACI[i].unit  == "player" then
					EventsFrame_RegisterFrame("UNIT_AURA", ACI[i]);
				else
					ACI[i].updateaura = true;
				end
				
				if ACI[i].unit == "target" then
					EventsFrame_RegisterFrame("PLAYER_TARGET_CHANGED", ACI[i]);
				end

				EventsFrame_RegisterFrame("ACTIONBAR_UPDATE_USABLE", ACI[i]);
				EventsFrame_RegisterFrame("ACTIONBAR_UPDATE_COOLDOWN", ACI[i]);
				EventsFrame_RegisterFrame("SPELL_UPDATE_CHARGES", ACI[i]);
				EventsFrame_RegisterFrame("UNIT_SPELLCAST_SUCCEEDED", ACI[i]);





			elseif t == 2 or t==3 or t == 5  or t == 6 or t == 7 or t == 10 or t == 14 or t == 17 or t == 18 then
				ACI[i].unit =ACI_SpellList[i][3];
				if ACI[i].unit == nil then
					ACI[i].unit  = "player"
				end

				if ACI[i].unit  == "player" then
					EventsFrame_RegisterFrame("UNIT_AURA", ACI[i]);
				else
					ACI[i].updateaura = true;
				end

				if ACI[i].unit == "target" then
					EventsFrame_RegisterFrame("PLAYER_TARGET_CHANGED", ACI[i]);
				end

				if t == 2 or t == 6 or t == 18 then
					EventsFrame_RegisterFrame("ACTIONBAR_UPDATE_USABLE", ACI[i]);
					EventsFrame_RegisterFrame("ACTIONBAR_UPDATE_COOLDOWN", ACI[i]);
					EventsFrame_RegisterFrame("SPELL_UPDATE_CHARGES", ACI[i]);
					EventsFrame_RegisterFrame("UNIT_SPELLCAST_SUCCEEDED", ACI[i]);
				end

			elseif t == 11 then
				EventsFrame_RegisterFrame("PLAYER_TOTEM_UPDATE", ACI[i]);
				EventsFrame_RegisterFrame("ACTIONBAR_UPDATE_USABLE", ACI[i]);
				EventsFrame_RegisterFrame("ACTIONBAR_UPDATE_COOLDOWN", ACI[i]);
				EventsFrame_RegisterFrame("SPELL_UPDATE_CHARGES", ACI[i]);
				EventsFrame_RegisterFrame("UNIT_SPELLCAST_SUCCEEDED", ACI[i]);
			elseif t == 15 then
				EventsFrame_RegisterFrame("PLAYER_TOTEM_UPDATE", ACI[i]);
				EventsFrame_RegisterFrame("ACTIONBAR_UPDATE_USABLE", ACI[i]);
				EventsFrame_RegisterFrame("ACTIONBAR_UPDATE_COOLDOWN", ACI[i]);
				EventsFrame_RegisterFrame("SPELL_UPDATE_CHARGES", ACI[i]);
				EventsFrame_RegisterFrame("UNIT_SPELLCAST_SUCCEEDED", ACI[i]);
				ACI[i].updateaura = true;

			else
				EventsFrame_RegisterFrame("ACTIONBAR_UPDATE_USABLE", ACI[i]);
				EventsFrame_RegisterFrame("ACTIONBAR_UPDATE_COOLDOWN", ACI[i]);
				EventsFrame_RegisterFrame("SPELL_UPDATE_CHARGES", ACI[i]);
				EventsFrame_RegisterFrame("UNIT_SPELLCAST_SUCCEEDED", ACI[i]);
			

				if t == 9 and ACI_SpellList[i][3] then
					ACI[i].unit = "target";
					ACI[i].health = ACI_SpellList[i][3];
					EventsFrame_RegisterFrame("PLAYER_TARGET_CHANGED", ACI[i]);
					ACI[i].updateaura = true;
				end
			end

		end

		ACI_Timer =	C_Timer.NewTicker(0.5, ACI_OnUpdate);
		
		LoadAddOn("asCooldownPulse")

		if #ACI_SpellList > 5 then
			ACDP_Show_CoolList = false
		else
			ACDP_Show_CoolList = true
		end
	else
		--ChatFrame1:AddMessage("[ACI] 비활성화 합니다.");
		--[[
		if ACDP_Show_CoolList then
			ACDP_CoolButtons:SetPoint("CENTER", ACDP_CoolButtons_X , ACDP_CoolButtons_Y)
			--ACDP_Show_CoolList = false
		end
		--]]

		LoadAddOn("asCooldownPulse")
		ACDP_Show_CoolList = true
	end


	for i = 1, ACI_MaxSpellCount do

		local font, size, flag = _G["ACI"..i.."Count"]:GetFont()

		for _,r in next,{_G["ACI".. i.."Cooldown"]:GetRegions()}	do 
			if r:GetObjectType()=="FontString" then 
				if i < 6 then
					r:SetFont("Fonts\\2002.TTF",ACI_CooldownFontSize,"OUTLINE")
				else
					r:SetFont("Fonts\\2002.TTF",ACI_CooldownFontSize - 2,"OUTLINE")
				end

				ACI[i].cooldownfont = r;
				break 
			end 
		end


		if i < 6 then
			_G["ACI"..i.."Count"]:SetFont(font, ACI_CountFontSize, "OUTLINE")
		else
			_G["ACI"..i.."Count"]:SetFont(font, ACI_CountFontSize - 2, "OUTLINE")

		end

				_G["ACI"..i.."Count"]:SetPoint("BOTTOMRIGHT", -3, 3);

		_G["ACI".. i.."Border"]:Hide();
	end



	return;

end

ACI_mainframe = CreateFrame("Frame", nil, UIParent);
ACI_mainframe:SetScript("OnEvent", ACI_OnEvent);
ACI_mainframe:RegisterEvent("PLAYER_ENTERING_WORLD");
ACI_mainframe:RegisterEvent("ACTIVE_TALENT_GROUP_CHANGED");
ACI_mainframe:RegisterEvent("PLAYER_REGEN_DISABLED");
ACI_mainframe:RegisterEvent("PLAYER_REGEN_ENABLED");
ACI_mainframe:RegisterEvent("VARIABLES_LOADED");
ACI_mainframe:RegisterEvent("PLAYER_TALENT_UPDATE");
ACI_mainframe:RegisterEvent("SPELL_ACTIVATION_OVERLAY_GLOW_SHOW")
ACI_mainframe:RegisterEvent("SPELL_ACTIVATION_OVERLAY_GLOW_HIDE")
ACI_mainframe:RegisterEvent("ACTIONBAR_SLOT_CHANGED")
ACI_mainframe:RegisterUnitEvent("UNIT_ENTERING_VEHICLE", "player")
ACI_mainframe:RegisterUnitEvent("UNIT_EXITING_VEHICLE", "player")
ACI_mainframe:RegisterUnitEvent("UNIT_AURA", "player" , "pet" );
ACI_mainframe:RegisterUnitEvent("UNIT_SPELLCAST_SUCCEEDED", "player" , "pet" );

ACI_mainframe:RegisterEvent("ACTIONBAR_UPDATE_USABLE");
ACI_mainframe:RegisterEvent("ACTIONBAR_UPDATE_COOLDOWN");
ACI_mainframe:RegisterEvent("SPELL_UPDATE_CHARGES");
ACI_mainframe:RegisterEvent("PLAYER_TOTEM_UPDATE");
ACI_mainframe:RegisterEvent("PLAYER_TARGET_CHANGED");








for i = 1, 5 do

	ACI[i] = CreateFrame("Button", "ACI"..i, UIParent, "asCombatInfoFrameTemplate");
	ACI[i]:SetWidth(ACI_SIZE);
	ACI[i]:SetHeight(ACI_SIZE);
	ACI[i]:SetScale(1);
	ACI[i]:SetAlpha(ACI_Alpha);
	ACI[i]:EnableMouse(false);
	ACI[i]:Hide();
	
end

for i = 1, 5 do
	if i == 3 then
		ACI[i]:SetPoint("CENTER", ACI_CoolButtons_X, ACI_CoolButtons_Y)
	elseif i < 3 then
		ACI[i]:SetPoint("RIGHT", ACI[i+1], "LEFT", -2, 0);
	elseif i > 3 then
		ACI[i]:SetPoint("LEFT", ACI[i-1], "RIGHT", 2, 0);
	end
end


for i = 6, 11 do

	ACI[i] = CreateFrame("Button", "ACI"..i, UIParent, "asCombatInfoFrameTemplate");

	ACI[i]:SetWidth(ACI_SIZE - 8);
	ACI[i]:SetHeight(ACI_SIZE - 8);
	ACI[i]:SetScale(1);
	ACI[i]:SetAlpha(ACI_Alpha);
	ACI[i]:EnableMouse(false);
	ACI[i]:Hide();
	
end

for i = 6, 11 do
	if i == 8 then
		ACI[i]:SetPoint("TOPRIGHT", ACI[i-5], "BOTTOM", -0.5, -1);
	elseif i == 9 then
		ACI[i]:SetPoint("TOPLEFT", ACI[i-6], "BOTTOM", 0.5, -1);
	elseif i < 8 then
		ACI[i]:SetPoint("RIGHT", ACI[i+1], "LEFT", -1, 0);
	elseif i > 9 then
		ACI[i]:SetPoint("LEFT", ACI[i-1], "RIGHT", 1, 0);
	end
end


LoadAddOn("asMOD");

if asMOD_setupFrame then
         asMOD_setupFrame (ACI[3], "asCombatInfo");
end


--[[

ACI_Options = {};
ACI_Options.panel = CreateFrame( "Frame", "ACI_Panel", UIParent, "asCombatInfoOptionFrameTemplate" );
ACI_Options.panel.name = "asCombatInfo";

ACI_Options.panel.okay  = function()
end

ACI_Options.panel.cancel = function() 
end

	-- Add the panel to the Interface Options
InterfaceOptions_AddCategory(ACI_Options.panel);
--]]
