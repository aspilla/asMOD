local ABF;
local ABF_PLAYER_BUFF;
local ABF_TARGET_BUFF;
local ABF_SIZE = 28;
local ABF_SIZE_BIG = 30;
local ABF_SIZE_SMALL = 28;
local ABF_TARGET_BUFF_X = 73 + 30;
local ABF_TARGET_BUFF_Y = -142;
local ABF_PLAYER_BUFF_X = -73 - 30;
local ABF_PLAYER_BUFF_Y = -142 ;
local ABF_MAX_BUFF_SHOW = 7;
local ABF_ALPHA = 1;
local ABF_CooldownFontSize = 12;		-- Cooldown Font Size
local ABF_CountFontSize = 11;			-- Count Font Size
local ABF_AlphaCombat = 1;				-- 전투중 Alpha 값
local ABF_AlphaNormal = 0.5;			-- 비 전투중 Alpha 값
local ABF_MAX_Cool = 60;				-- 최대 60초의 버프를 보임
local ABF_RefreshRate = 0.5;			-- Target Buff Check 주기 (초)

local PLAYER_UNITS = {
	player = true,
	vehicle = true,
	pet = true,
};

local ABF_BlackList = {
--	["문양: 기사단의 선고"] = 1,
--	["문양: 이중 판결"] = 1,
--	["관대한 치유사"] = 1,
--	["법의 위세"] = 1,
--	["피의 광기"] = 1,

}

local ABF_ShowList;
local b_showlist = false;

-- 특정한 버프만 보이게 하려면 직업별로 편집
-- ABF_ShowList_직업명_특성
--ABF_ShowList_PALADIN_3 = {
--	["심문"] = 1,	
--}


local ABF_StackBuffList = {
	--["비전의 조화"] = 1,
}

-- 발동 주요 공격 버프
-- 보이게만 할려면 2, 강조하려면 1
local ABF_ProcBuffList = {
	--블러드
	["시간 왜곡"] = 1,
	["영웅심"] = 1,
	["피의 욕망"] = 1,
	["황천바람"] = 1,
	["고대의 격분"] = 1,
	["위상의 격노"] = 1,
	["쾌활한 생기화"] = 2,
}
	

local ABF_Current_Buff = "";
local ABF_Current_Count = 0;

-- PVP Buff List
--
local ABF_PVPBuffList = {

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

local _G = _G;

local ABF_TalentBuffList = {};
local ABF_TalentShowList = {};

local isBig = {};
local isBigReal = {};



--Overlay stuff
local unusedOverlayGlows = {};
local numOverlays = 0;
local function ABF_ActionButton_GetOverlayGlow()
	local overlay = tremove(unusedOverlayGlows);
	if ( not overlay ) then
		numOverlays = numOverlays + 1;
		overlay = CreateFrame("Frame", nil, UIParent, "ABF_ActionBarButtonSpellActivationAlert");
	end
	return overlay;
end

-- Shared between action button and MainMenuBarMicroButton
local function ABF_ShowOverlayGlow(button)
	if ( button.overlay ) then
		if ( button.overlay.animOut:IsPlaying() ) then
			button.overlay.animOut:Stop();
			button.overlay.animIn:Play();
		end
	else
		button.overlay = ABF_ActionButton_GetOverlayGlow();
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
local function ABF_HideOverlayGlow(button)
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

ABF_ActionBarButtonSpellActivationAlertMixin = {};

function ABF_ActionBarButtonSpellActivationAlertMixin:OnUpdate(elapsed)
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

function ABF_ActionBarButtonSpellActivationAlertMixin:OnHide()
	if ( self.animOut:IsPlaying() ) then
		self.animOut:Stop();
		self.animOut:OnFinished();
	end
end

ABF_ActionBarOverlayGlowAnimInMixin = {};

function ABF_ActionBarOverlayGlowAnimInMixin:OnPlay()
	local frame = self:GetParent();
	local frameWidth, frameHeight = frame:GetSize();
	frame.spark:SetSize(frameWidth, frameHeight);
	frame.spark:SetAlpha(0);
	frame.innerGlow:SetSize(frameWidth, frameHeight);
	frame.innerGlow:SetAlpha(1);
	frame.innerGlowOver:SetAlpha(1);
	frame.outerGlow:SetSize(frameWidth, frameHeight);
	frame.outerGlow:SetAlpha(1);
	frame.outerGlowOver:SetAlpha(1);
	frame.ants:SetSize(frameWidth * 0.8, frameHeight * 0.8)
	frame.ants:SetAlpha(0);
	frame:Show();
end

function ABF_ActionBarOverlayGlowAnimInMixin:OnFinished()
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

ABF_ActionBarOverlayGlowAnimOutMixin = {};

function ABF_ActionBarOverlayGlowAnimOutMixin:OnFinished()
	local overlay = self:GetParent();
	local actionButton = overlay:GetParent();
	overlay:Hide();
	tinsert(unusedOverlayGlows, overlay);
	actionButton.overlay = nil;
end


local function asCheckTalent()

	table.wipe(ABF_TalentBuffList);

	local specID = PlayerUtil.GetCurrentSpecID();
	local configID = C_ClassTalents.GetActiveConfigID();

	if not (configID) then
		return;
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
				ABF_TalentBuffList[talentName] = true;
			end
        end
    end
	return;
end

local function asCooldownFrame_Clear(self)
	self:Clear();
end

local function asCooldownFrame_Set(self, start, duration, enable, forceShowDrawEdge, modRate)
	if enable and enable ~= 0 and start > 0 and duration > 0 then
		self:SetDrawEdge(forceShowDrawEdge);
		self:SetCooldown(start, duration, modRate);
	else
		asCooldownFrame_Clear(self);
	end
end

local function ABF_UpdateDebuff(unit)

	local numDebuffs = 1;
	local frame;
	local frameIcon, frameCount, frameCooldown, frameStealable;
	local name, rank, icon, count, debuffType, duration, expirationTime, caster, isStealable;
	local color;
	local frameBorder;
	local maxIdx;
	local parent;
	local isFirst = true;

	if (unit == "tbuff") then
		maxIdx = MAX_TARGET_BUFFS;
		parent = ABF_TARGET_BUFF;
	elseif (unit == "target") then
		
		maxIdx = MAX_TARGET_BUFFS;
		parent = ABF_TARGET_BUFF;
	elseif (unit == "pbuff") then
		
		maxIdx = MAX_TARGET_BUFFS;
		parent = ABF_PLAYER_BUFF;
	elseif (unit == "tebuff") then
		
		maxIdx = MAX_TARGET_BUFFS;
		parent = ABF_TARGET_BUFF;
	else
		return;
	end

	--for i = 1, maxIdx do
	i = 1;

	local totem_i = 1;

	if parent.frames == nil then
		parent.frames = {};
	end

	repeat
		local skip = false;
		local debuff;
		local bufidx;
		local isStealable = false;
		local stack = nil;
		local isTarget = false;
		local alert = false;

		isBig[i] = false;
		
		if (unit == "tbuff") then
			name, icon, count, debuffType, duration, expirationTime, caster, isStealable, shouldConsolidate, spellId = UnitBuff("target", i);

			-- 적대적 NPC 는 무조건 Buff 를 보임

			if (icon == nil) then
				break;
			end

			if isStealable  then
				isBig[i] = true;
				alert = true;
			end

		elseif (unit == "target") then
						
			name,  icon, count, debuffType, duration, expirationTime, caster, isStealable, shouldConsolidate, spellId = UnitBuff("target", i);
			if (icon == nil) then
				break;
			end

			skip = true;

			-- 우리편은 내가 시전한 Buff 보임
			if PLAYER_UNITS[caster] and duration > 0  and duration <= ABF_MAX_Cool then
				skip = false;
			end

				-- PVP 주요 버프는 보임
			if (name ~= nil and ABF_PVPBuffList[spellId]) then
				isBig[i] = true;
				skip = false;
			end

			if ACI_Buff_list and skip == false and ACI_Buff_list[name] then
				skip = true;
			end


		elseif (unit == "pbuff") then

			if totem_i <= MAX_TOTEMS then

				for slot= totem_i, MAX_TOTEMS do
					local haveTotem;
					haveTotem, name, start, duration, icon = GetTotemInfo(slot);

					totem_i = slot + 1;
						
					if haveTotem and icon then
						caster = "player";
						expirationTime = start + duration;
						debuffType = "totem";
						isStealable = nil;
						stack = nil;
						count = 0;

						skip = false;
						i = 0;
						break;
					else
						icon = nil;
					end
				end

				if icon == nil then
					i = 1;
					name, icon, count, debuffType, duration, expirationTime, caster, isStealable, shouldConsolidate, spellId, _,_ , casterIsPlayer, nameplateShowAll, stack,value2,value3  = UnitBuff("player", i, "INCLUDE_NAME_PLATE_ONLY");

				end

			else

				name, icon, count, debuffType, duration, expirationTime, caster, isStealable, nameplateShowPersonal, spellId, _,_ , casterIsPlayer, nameplateShowAll, stack,value2,value3  = UnitBuff("player", i, "INCLUDE_NAME_PLATE_ONLY");
			end

			skip = true;
			
			if (icon == nil) then
				break;
			end
			
			if PLAYER_UNITS[caster] and duration > 0 and duration <= ABF_MAX_Cool then
				skip = false;
			end

			if PLAYER_UNITS[caster] and duration == 0 and ABF_TalentShowList and ABF_TalentShowList[name] then
				-- 특성이면 보이게
				skip = false;
			end

			if PLAYER_UNITS[caster] and duration == 0 and ABF_TalentBuffList and ABF_TalentBuffList[name] and count > 1 then
				-- 특성이면 보이게
				skip = false;
				ABF_TalentShowList[name] = true;
			end

		

			if nameplateShowPersonal and PLAYER_UNITS[caster]  then
				skip = false;
			end
						
			stack = nil;

			--결의 보호막 처리부 asCombatInfo로 이동
			if  ABF_StackBuffList[name] == 1 and stack and stack > 0 then
				skip = false;
			else
				stack = nil;
			end

			-- asPowerBar Check 
			if APB_BUFF and APB_BUFF == name then
				skip = true;
			end
			
			if APB_BUFF2 and APB_BUFF2 == name then
				skip = true;
			end

			if APB_BUFF_COMBO and APB_BUFF_COMBO == name then
				skip = true;
			end

			if (name ~= nil and ABF_PVPBuffList[spellId]) then
				isBig[i] = true;
				skip = false;
			end			

			if skip == false and ABF_BlackList[name] then
				skip = true;
			end

			if b_showlist == true then
				skip = true;
				if ABF_ShowList[name] then
					skip = false;
				end
			end
			
			if ABF_ProcBuffList and ABF_ProcBuffList[name] then

				if	ABF_ProcBuffList[name] == 1 then
					alert = true;
					isBig[i] = true;
				end
				skip = false;
			end			

			if ACI_Buff_list and skip == false and ACI_Buff_list[name] then
				skip = true;
			end

			if ASABF_BuffIDList and skip == false and ASABF_BuffIDList[spellId] then
				skip = true;
			end

			if ASABF_BuffNameList and skip == false and ASABF_BuffNameList[name] then
				skip = true;
			end

			if ASABF_AzeriteTraits and skip == false and ASABF_AzeriteTraits[name] then
				skip = true;
			end

		elseif (unit == "tebuff") then
			name,  icon, count, debuffType, duration, expirationTime, caster, isStealable, shouldConsolidate, spellId  = UnitBuff("target", i);
			if (icon == nil) then
				break;
			end

			skip = true;
			

			if isStealable and isFirst then
				skip = false;
				isFirst = false;
				alert = true;
			end


			if (name ~= nil and ABF_PVPBuffList[spellId]) then
				isBig[i] = true;
				skip = false;
			end


		end

		if (icon and skip == false) then

			if numDebuffs > ABF_MAX_BUFF_SHOW then
				break;
			end

			local color;
			
			frame = parent.frames[numDebuffs];
			isBigReal[numDebuffs] = isBig[i];

			if ( not frame ) then
				parent.frames[numDebuffs] = CreateFrame("Button", nil, parent, "asTargetBuffFrameTemplate");
				frame = parent.frames[numDebuffs];
				frame:EnableMouse(false); 
				for _,r in next,{frame.cooldown:GetRegions()}	do 
					if r:GetObjectType()=="FontString" then 
						r:SetFont(STANDARD_TEXT_FONT,ABF_CooldownFontSize,"OUTLINE");
						r:ClearAllPoints();
						r:SetPoint("TOP", 0, 5);
						break 
					end 
				end

				local font, size, flag = frame.count:GetFont()

				frame.count:SetFont(STANDARD_TEXT_FONT, ABF_CountFontSize, "OUTLINE")
				frame.count:ClearAllPoints()
				frame.count:SetPoint("BOTTOM", 0, -5);

				frame.icon:SetTexCoord(.08, .92, .08, .92);
				frame.border:SetTexture("Interface\\Addons\\asDebuffFilter\\border.tga");
				frame.border:SetTexCoord(0.08,0.08, 0.08,0.92, 0.92,0.08, 0.92,0.92);

			end

			if ((unit == "pbuff") or (unit == "target" and PLAYER_UNITS[caster] ) or (unit == "tbuff") or (unit == "tebuff")) then
					
				-- set the icon
				frameIcon = frame.icon;
				frameIcon:SetTexture(icon);
				frameIcon:SetAlpha(ABF_ALPHA);

				-- set the count
				frameCount = frame.count;
				-- Handle cooldowns
				frameCooldown = frame.cooldown;
			
				if isBig[i] then
					frame:SetWidth(ABF_SIZE_BIG);
					frame:SetHeight(ABF_SIZE_BIG * 0.8);
				else
					frame:SetWidth(ABF_SIZE);
					frame:SetHeight(ABF_SIZE * 0.8);
				end

				if ( count > 1 ) then
					frameCount:SetText(count);
					frameCount:Show();
					frameCooldown:SetDrawSwipe(false);
				else
					if (stack ) then
						if(stack > 999999) then 
							stack = math.ceil(stack/1000000) .. "m" 
						elseif(stack > 999) then 
							stack = math.ceil(stack/1000) .. "k" 
						end   						
						
						frameCount:SetText(stack);
						frameCount:Show();
						frameCooldown:SetDrawSwipe(false);
					else
						if (name == ABF_Current_Buff) then
							frameCount:SetText(ABF_Current_Count);
							frameCount:Show();
							frameCooldown:SetDrawSwipe(false);
						else
							frameCount:Hide();
							frameCooldown:SetDrawSwipe(true);
						end
					end

				end
							
				if ( duration > 0 and duration <= 120 ) then
					frameCooldown:Show();
					asCooldownFrame_Set(frameCooldown, expirationTime - duration, duration, duration >0,  true);
					frameCooldown:SetHideCountdownNumbers(false);
				else
					frameCooldown:Hide();
				end

				frameBorder = frame.border;

				color = DebuffTypeColor["Disease"];
	
				if debuffType then
					if debuffType == "totem" then
						color = { r = 0, g = 1, b = 0 };
					else
						color = DebuffTypeColor[debuffType];
					end
				end

				if isStealable then
					color = { r = 1, g = 1, b = 1 };
				end

				if (alert ) then
					ABF_ShowOverlayGlow(frame);
				else
					ABF_HideOverlayGlow(frame);
				end

				frameBorder:SetVertexColor(color.r, color.g, color.b);
				frameBorder:SetAlpha(ABF_ALPHA);
						
				frame:ClearAllPoints();
				frame:Show();

				numDebuffs = numDebuffs + 1;
			end
		end
		i = i+1
	until (name == nil)
	

	if (unit == "pbuff") then
		for i=1, numDebuffs - 1 do
			if (isBigReal[i]) then
				ABF_UpdateDebuffAnchor(parent.frames, i, i - 1, ABF_SIZE_BIG, 1, false, parent);
			else
				ABF_UpdateDebuffAnchor(parent.frames, i, i - 1, ABF_SIZE, 1, false, parent);
			end
		end
	elseif (unit == "tbuff") then
		for i=1, numDebuffs -1  do
			if (isBigReal[i]) then
				ABF_UpdateDebuffAnchor(parent.frames, i, i - 1, ABF_SIZE_BIG, 1, true, parent);
			else
				ABF_UpdateDebuffAnchor(parent.frames, i, i - 1, ABF_SIZE, 1, true, parent);
			end
		end
	elseif (unit == "target") then
		for i=1, numDebuffs -1  do
			if (isBigReal[i]) then
				ABF_UpdateDebuffAnchor(parent.frames, i, i - 1, ABF_SIZE_BIG, 1, true, parent);
			else
				ABF_UpdateDebuffAnchor(parent.frames, i, i - 1, ABF_SIZE, 1, true, parent);
			end
		end
	elseif (unit == "tebuff") then
		for i=1, numDebuffs -1  do
			if (isBigReal[i]) then
				ABF_UpdateDebuffAnchor(parent.frames, i, i - 1, ABF_SIZE_BIG, 1, true, parent);
			else
				ABF_UpdateDebuffAnchor(parent.frames, i, i - 1, ABF_SIZE, 1, true, parent);
			end
		end
	end

	for i = numDebuffs, maxIdx do

		frame = parent.frames[i];

		if ( frame ) then
			frame:Hide();	
		end
		
	end
end

function ABF_UpdateDebuffAnchor(frames, index, anchorIndex, size, offsetX, right, parent)

	local buff = frames[index];
	local point1 = "TOPLEFT";
	local point2 = "BOTTOMLEFT";
	local point3 = "TOPRIGHT";

	if (right == false) then
		point1 = "TOPRIGHT";
		point2 = "BOTTOMRIGHT";
		point3 = "TOPLEFT";
		offsetX = -offsetX;
	end

	if ( index == 1 ) then
		buff:SetPoint(point1, parent, point2, 0, 0);
	else
		buff:SetPoint(point1, frames[index - 1], point3, offsetX, 0);
	end

	-- Resize
	buff:SetWidth(size);
	buff:SetHeight(size * 0.8);
	--[[
	local border =frames[index].border;
	debuffFrame:SetWidth(size+2);
	debuffFrame:SetHeight(size * 0.8 +2);
	]]
end


function ABF_ClearFrame()
	
	local selfName = "ABF_TBUFF_";

	for i = 1, MAX_TARGET_BUFFS do
		frameName = selfName.."Button"..i;
		frame = _G[frameName];

		if ( frame ) then
			frame:Hide();	
		else
			break;
		end
	end
end

function ABF_InitShowList()

	local localizedClass, englishClass = UnitClass("player")
	local spec = GetSpecialization();
	local listname = "ABF_ShowList";
	if spec then
		listname = "ABF_ShowList" .. "_" .. englishClass .. "_" .. spec;
	end

	ABF_ShowList = _G[listname];

	b_showlist = false;

	if (ABF_ShowList and #ABF_ShowList) then
--		ChatFrame1:AddMessage("[ABF] ".. listname .. "을 Load 합니다.");
		b_showlist = true;
	else
--		ChatFrame1:AddMessage("[ABF] Show List를 비활성화 합니다..");
	end
end

local function ABF_OnUpdate()

	if UnitIsEnemy("player", "target") then
		if (UnitIsPlayer("target")) then
			ABF_UpdateDebuff("tebuff");
		else
			ABF_UpdateDebuff("tbuff");
		end
	else
		ABF_UpdateDebuff("target");
	end

end


function ABF_OnEvent(self, event, arg1, ...)
	if (event == "PLAYER_TARGET_CHANGED") then
		ABF_ClearFrame();
		if UnitIsEnemy("player", "target") then
			if (UnitIsPlayer("target")) then
				ABF_UpdateDebuff("tebuff");
			else
				ABF_UpdateDebuff("tbuff");
			end
		else
			ABF_UpdateDebuff("target");
		end
	elseif (event == "UNIT_AURA" and arg1 == "player") then
		ABF_UpdateDebuff("pbuff");
	elseif (event == "PLAYER_TOTEM_UPDATE") then
		ABF_UpdateDebuff("pbuff");
	elseif event == "PLAYER_ENTERING_WORLD" or event == "ACTIVE_TALENT_GROUP_CHANGED"  then
		ABF_InitShowList();
	elseif event == "PLAYER_REGEN_DISABLED" then
		ABF:SetAlpha(ABF_AlphaCombat);
	elseif event == "PLAYER_REGEN_ENABLED" then
		ABF:SetAlpha(ABF_AlphaNormal);
	elseif (event == "TRAIT_CONFIG_UPDATED") or (event == "TRAIT_CONFIG_LIST_UPDATED") then
		C_Timer.After(0.5, asCheckTalent);
	end
end

function ABF_Init()

	ABF = CreateFrame("Frame", nil, UIParent)

	ABF:SetPoint("CENTER", 0, 0)
	ABF:SetWidth(1)
	ABF:SetHeight(1)
	ABF:SetScale(1)
	ABF:SetAlpha(ABF_AlphaNormal);
	ABF:Show()


  
	ABF_TARGET_BUFF = CreateFrame("Frame", nil, ABF)

	ABF_TARGET_BUFF:SetPoint("CENTER", ABF_TARGET_BUFF_X, ABF_TARGET_BUFF_Y)
	ABF_TARGET_BUFF:SetWidth(1)
	ABF_TARGET_BUFF:SetHeight(1)
	ABF_TARGET_BUFF:SetScale(1)
	--ABF_TARGET_BUFF:SetFrameStrata("BACKGROUND")
	ABF_TARGET_BUFF:Show()

	ABF_PLAYER_BUFF = CreateFrame("Frame", nil, ABF)

	ABF_PLAYER_BUFF:SetPoint("CENTER", ABF_PLAYER_BUFF_X, ABF_PLAYER_BUFF_Y)
	ABF_PLAYER_BUFF:SetWidth(1)
	ABF_PLAYER_BUFF:SetHeight(1)
	ABF_PLAYER_BUFF:SetScale(1)
	--ABF_PLAYER_BUFF:SetFrameStrata("BACKGROUND")
	ABF_PLAYER_BUFF:Show()
	
	ABF:RegisterEvent("PLAYER_TARGET_CHANGED")
	ABF:RegisterUnitEvent("UNIT_AURA", "player")
	ABF:RegisterEvent("PLAYER_ENTERING_WORLD");
	ABF:RegisterEvent("ACTIVE_TALENT_GROUP_CHANGED");
	ABF:RegisterEvent("PLAYER_REGEN_DISABLED");
	ABF:RegisterEvent("PLAYER_REGEN_ENABLED");
	ABF:RegisterEvent("PLAYER_TOTEM_UPDATE");
	ABF:RegisterEvent("TRAIT_CONFIG_UPDATED");
	ABF:RegisterEvent("TRAIT_CONFIG_LIST_UPDATED");

	ABF:SetScript("OnEvent", ABF_OnEvent)
	C_Timer.NewTicker(ABF_RefreshRate, ABF_OnUpdate);

end

ABF_Init()


