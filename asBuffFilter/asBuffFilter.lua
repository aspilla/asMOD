local ABF;
local ABF_PLAYER_BUFF;
local ABF_TARGET_BUFF;
local ABF_SIZE = 26;
local ABF_SIZE_BIG = 27;
local ABF_SIZE_SMALL = 26;
local ABF_TARGET_BUFF_X = 73 + 30;
local ABF_TARGET_BUFF_Y = -92;
local ABF_PLAYER_BUFF_X = -73 - 30;
local ABF_PLAYER_BUFF_Y = -92 ;
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
}
	

local ABF_Current_Buff = "";
local ABF_Current_Count = 0;

-- PVP Buff List
--
local ABF_PVPBuffList = {

		-- Defensive Buffs
	[122470] =1,	-- Touch of Karma
	[116849] = 1,	-- Life Cocoon
	[33206] =1,	-- Pain Suppression
	[49039] = 1,	-- Lichborne
	--54216,	-- Master's Call UNUSED?
	[5277] = 1,	-- Evasion
	[199754] =1,	-- Riposte
	--110913,	-- Dark Bargain REMOVED IN LEGION
	[108359] = 1,	-- Dark Regeneration
	[104773] = 1,	-- Unending Resolve
	[18499] =1,	-- Berserker Rage
	[61336] = 1,	-- Survival Instincts
	[22812] = 1,	-- Barkskin
	[102342] = 1,	-- Iron Bark
	[6940] = 1,	-- Hand of Sacrifice
	[110909] = 1,	-- Alter Time
	--30823,	-- Shamanistic Rage REMOVED IN LEGION
	[118038] = 1,	-- Die by the Sword
	[33891] = 1,	-- Incarnation: Tree of Life
	[74001] = 1,	-- Combat Readiness
	[108271] =1,	-- Astral Shift
	--111397,	-- Blood Horror REMOVED IN LEGION
	[108416] =1,	-- Dark Pact
	--55694,	-- Enraged Regeneration REMOVED IN LEGION
	[47788] =1,	-- Guardian Spirit
	[122783] =1,	-- Diffuse Magic
	[12975] = 1,	-- Last Stand
	[871] = 1,	-- Shield Wall
	[212800] = 1,	-- Blur
	[55233] = 1,	-- Vampiric Blood
	[194679] =1,	-- Rune Tap
	[207319] = 1,	-- Corpse Shield


		-- Immune
	[19263] = 1,	-- Deterrence
	[186265] = 1, -- Aspect of the Turtle
	[45438] = 1,	-- Ice Block
	[642] = 1,	-- Divine Shield    
	[115018] = 1,	-- Desecrated Ground
	[31821] = 1,	-- Aura Mastery
	[1022] = 1,	-- Hand of Protection
	[47585] = 1,	-- Dispersion
	[31224] =1,	-- Cloak of Shadows
	--45182,	-- Cheating Death PROBABLY UNNECESSARY
	[8178] = 1,	-- Grounding Totem Effect (Grounding Totem)
	[76577] = 1,	-- Smoke Bomb
	[88611] = 1,	-- Smoke Bomb
	[46924] = 1,	-- Bladestorm

	-- Anti CC
	[48792] = 1,	-- Icebound Fortitude
	[48707] = 1,	-- Anti-Magic Shell
	[23920] = 1,	-- Spell Reflection
	[114028] = 1,	-- Mass Spell Reflection
	[5384] = 1,	-- Feign Death

		-- Offensive Buffs
	[51690] = 2,	-- Killing Spree
	--185422,	-- Shadow Dance UNNECESSARY, SUB ROGUES DANCE ALL THE DAMNED TIME
	--84747,	-- Deep Insight (Rogue Red Buff) REMOVED IN LEGION
	--84746,	-- Moderate Insight (Rogue Yellow Buff) REMOVED IN LEGION
	[13750] = 2,	-- Adrenaline Rush
	--112071,	-- Celestial Alignment REMOVED IN LEGION
	[31884] = 2,	-- Avenging Wrath
	[1719] = 2,	-- Battle Cry
	--113858,	-- Dark Soul REMOVED IN LEGION
	--113861,	-- Dark Soul REMOVED IN LEGION
	--113860,	-- Dark Soul REMOVED IN LEGION
	[102543] = 2,	-- Incarnation: King of the Jungle
	[106951] = 2,	-- Berserk
	[102560] = 2,	-- Incarnation: Chosen of Elune
	[12472] = 2,	-- Icy Veins
	--3045,	-- Rapid Fire UNUSED?
	[193526] = 2, -- Trueshot
	[19574] = 2,	-- Bestial Wrath
	[186289] = 2,	-- Aspect of the Eagle
	[51271] = 2,	-- Pillar of Frost
	[152279] = 2,	-- Breath of Sindragosa
	[105809] = 2,	-- Holy Avenger
	[16166] = 2,	-- Elemental Mastery
	[114050] = 2,	-- Ascendance
	[107574] = 2,	-- Avatar
	[121471] = 2,	-- Shadow Blades
	[12292] = 2,	-- Bloodbath
	[162264] = 2,	-- Metamorphosis

}

local ABF_TalentBuffList = {};

local isBig = {};
local isBigReal = {};

--Overlay stuff
local unusedOverlayGlows = {};
local numOverlays = 0;
local function ABF_ActionButton_GetOverlayGlow()
	local overlay = tremove(unusedOverlayGlows);
	if ( not overlay ) then
		numOverlays = numOverlays + 1;
		overlay = CreateFrame("Frame", "ABF_ActionButtonOverlay"..numOverlays, UIParent, "ABF_ActionBarButtonSpellActivationAlert");
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
		button.overlay:SetSize(frameWidth * 1.5, frameHeight * 1.5);
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
	local specID = PlayerUtil.GetCurrentSpecID();
   
    local configID = C_ClassTalents.GetActiveConfigID();
    local configInfo = C_Traits.GetConfigInfo(configID);
    local treeID = configInfo.treeIDs[1];
    local nodes = C_Traits.GetTreeNodes(treeID);

	table.wipe(ABF_TalentBuffList);

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
	return false;
end

local function ABF_UpdateDebuff(unit)

	local selfName;
	local numDebuffs = 1;
	local frame, frameName;
	local frameIcon, frameCount, frameCooldown, frameStealable;
	local name, rank, icon, count, debuffType, duration, expirationTime, caster, isStealable;
	local color;
	local frameBorder;
	local maxIdx;
	local parent;
	local frametype;
	local isFirst = true;

	if (unit == "tbuff") then
		selfName = "ABF_TBUFF_";
		maxIdx = MAX_TARGET_BUFFS;
		parent = ABF_TARGET_BUFF;
	elseif (unit == "target") then
		selfName = "ABF_TBUFF_";
		maxIdx = MAX_TARGET_BUFFS;
		parent = ABF_TARGET_BUFF;
	elseif (unit == "pbuff") then
		selfName = "ABF_PBUFF_";
		maxIdx = MAX_TARGET_BUFFS;
		parent = ABF_PLAYER_BUFF;
	elseif (unit == "tebuff") then
		selfName = "ABF_TBUFF_";
		maxIdx = MAX_TARGET_BUFFS;
		parent = ABF_TARGET_BUFF;
	else
		return;
	end

	frametype = selfName.."Button";

	--for i = 1, maxIdx do
	i = 1;

	local totem_i = 1;

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

			if ABF_TalentBuffList and ABF_TalentBuffList[name] then
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
			frameName = frametype..numDebuffs;
			frame = _G[frameName];

			isBigReal[numDebuffs] = isBig[i];

			if ( not frame ) then
				frame = CreateFrame("Button", frameName, parent, "asTargetBuffFrameTemplate");
				frame:EnableMouse(false); 
				for _,r in next,{_G[frameName.."Cooldown"]:GetRegions()}	do 
					if r:GetObjectType()=="FontString" then 
						r:SetFont(STANDARD_TEXT_FONT,ABF_CooldownFontSize,"OUTLINE")
						r:SetPoint("TOP", 0, 5);
						break 
					end 
				end

				local font, size, flag = _G[frameName.."Count"]:GetFont()

				_G[frameName.."Count"]:SetFont(STANDARD_TEXT_FONT, ABF_CountFontSize, "OUTLINE")
				_G[frameName.."Count"]:SetPoint("BOTTOMRIGHT", 0, 0);

			end

			if ((unit == "pbuff") or (unit == "target" and PLAYER_UNITS[caster] ) or (unit == "tbuff") or (unit == "tebuff")) then
					
				-- set the icon
				frameIcon = _G[frameName.."Icon"];
				frameIcon:SetTexture(icon);
				frameIcon:SetAlpha(ABF_ALPHA);

				-- set the count
				frameCount = _G[frameName.."Count"];
				-- Handle cooldowns
				frameCooldown = _G[frameName.."Cooldown"];
			
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
					CooldownFrame_Set(frameCooldown, expirationTime - duration, duration, duration >0,  true);
					frameCooldown:SetHideCountdownNumbers(false);
				else
					frameCooldown:Hide();
				end

				frameBorder = _G[frameName.."Border"];

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

				frameIcon:SetTexCoord(.08, .92, .08, .92);
				frameBorder:SetTexture("Interface\\Addons\\asBuffFilter\\border.tga");
				frameBorder:SetTexCoord(0.08,0.08, 0.08,0.92, 0.92,0.08, 0.92,0.92);
								
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
				ABF_UpdateDebuffAnchor(frametype, i, i - 1, ABF_SIZE_BIG, 4, false, parent);
			else
				ABF_UpdateDebuffAnchor(frametype, i, i - 1, ABF_SIZE, 4, false, parent);
			end
		end
	elseif (unit == "tbuff") then
		for i=1, numDebuffs -1  do
			if (isBigReal[i]) then
				ABF_UpdateDebuffAnchor(frametype, i, i - 1, ABF_SIZE_BIG, 4, true, parent);
			else
				ABF_UpdateDebuffAnchor(frametype, i, i - 1, ABF_SIZE, 4, true, parent);
			end
		end
	elseif (unit == "target") then
		for i=1, numDebuffs -1  do
			if (isBigReal[i]) then
				ABF_UpdateDebuffAnchor(frametype, i, i - 1, ABF_SIZE_BIG, 4, true, parent);
			else
				ABF_UpdateDebuffAnchor(frametype, i, i - 1, ABF_SIZE, 4, true, parent);
			end
		end
	elseif (unit == "tebuff") then
		for i=1, numDebuffs -1  do
			if (isBigReal[i]) then
				ABF_UpdateDebuffAnchor(frametype, i, i - 1, ABF_SIZE_BIG, 4, true, parent);
			else
				ABF_UpdateDebuffAnchor(frametype, i, i - 1, ABF_SIZE, 4, true, parent);
			end
		end
	end

	for i = numDebuffs, maxIdx do
		frameName = frametype..i;
		frame = _G[frameName];

		if ( frame ) then
			frame:Hide();	
		end
	end
end

function ABF_UpdateDebuffAnchor(debuffName, index, anchorIndex, size, offsetX, right, parent)

	local buff = _G[debuffName..index];
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
		buff:SetPoint(point1, _G[debuffName..(index-1)], point3, offsetX, 0);
	end

	-- Resize
	buff:SetWidth(size);
	buff:SetHeight(size * 0.8);
	local debuffFrame =_G[debuffName..index.."Border"];
	debuffFrame:SetWidth(size+2);
	debuffFrame:SetHeight(size * 0.8 +2);
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
		asCheckTalent();
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


  
	ABF_TARGET_BUFF = CreateFrame("Frame", "ABF_TARGET_BUFF", ABF)

	ABF_TARGET_BUFF:SetPoint("CENTER", ABF_TARGET_BUFF_X, ABF_TARGET_BUFF_Y)
	ABF_TARGET_BUFF:SetWidth(1)
	ABF_TARGET_BUFF:SetHeight(1)
	ABF_TARGET_BUFF:SetScale(1)
	--ABF_TARGET_BUFF:SetFrameStrata("BACKGROUND")
	ABF_TARGET_BUFF:Show()

	ABF_PLAYER_BUFF = CreateFrame("Frame", "ABF_PLAYER_BUFF", ABF)

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


