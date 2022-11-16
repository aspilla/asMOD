local ASABF;
local ASABF_PLAYER_BUFF;
local ASABF_SIZE = 50;
local ASABF_PLAYER_BUFF_X = -250;

local ASABF_PLAYER_BUFF_Y = 100 ;
local ASABF_MAX_BUFF_SHOW = 7;
local ASABF_ALPHA = 1;
local ASABF_CooldownFontSize = 18;		-- Cooldown Font Size
local ASABF_CountFontSize = 18;			-- Count Font Size
local ASABF_AlphaBuff = 0.9;				-- 전투중 Alpha 값
local ASABF_AlphaCool = 0.5;			-- 비 전투중 Alpha 값
local ASABF_AzelateAutoDetect = true;	-- 자동으로 아제라이트 특성을 Detect
local ASABF_AzelateMaxCheckTier = 2;	-- 아제라이트 Check Tier 2 단계 까지 하려면 2로 변경
local ASABF_TrinketAutoDetect = true;	-- 자동으로 사용 장신구를 Detect

local PLAYER_UNITS = {
	player = true,
	vehicle = true,
	pet = true,
};


ASABF_BuffNameList = {}
ASABF_BuffIDList = {}
ASABF_AzeriteTraits = {}; 


-- 발동 주요 공격 버프
-- { 버프 이름 or Spell ID, Type, rppm 혹은 내부 쿨 혹은 리필 타임 혹은 버프 중첩}
-- Type 0 --> 버프만 표시    (음성가능)
-- Type 1 --> RPPM 표시		 (음성가능)
-- Type 2 --> 내부쿨 표시	 (음성가능)
-- Type 3 --> 리필시점 알림  (음성가능)
-- Type 4 --> 버프 중첩 알림 (음성가능)
-- 음성을 이용하려면 sound 폴더에 버프 명.mp3 파일 추가

local ASABF_ProcBuffList = {

	
	--티탄의 길
	{"골가네스의 천둥 분노", 0},
	{"골가네스의 징표", 0},
	{"지식의 돌진", 1, 1.4},
	{"노르간논의 명령", 0},
	{"세계창조주의 불길", 1, 1.4},
	{"카즈고로스의 창조", 0},
	{"이오나의 징표", 1, 1.4},
	{"이오나의 신록의 품", 0},
	{"아만툴의 위엄", 0},
	{"천상의 보루", 1, 1.4},
	{"아그라마르의 인내", 0},


	-- 무기 마부
	{"치명적인 항해", 4, 4},
	{"강인한 항해", 4, 4},
	{"유연한 항해", 4, 4},
	{"재빠른 항해", 4, 4},
	{"특화된 항해", 4, 4},
	{"강풍의 일격", 1, 1},
	{"원소의 격류", 1, 1},
	--{"해안의 파도", 1, 3},



	--장신구
	{"로아의 의지", 1, 1},
	{"영혼의 속도", 1, 1.5},
	{"쉴 틈 없이 똑딱거리는 시계", 1, 3},
	{"돌풍바람 풍경", 1, 2},
	{"어두운 속삭임의 소라", 1, 1},
	{"피의 증오", 1, 2.5},
	{"리쇼크의 위대한 장치", 0},
	{"해골 랩터 소환", 1, 1},
	{"스위트의 달콤한 주사위", 1, 1},
	{"란도이의 철저", 0},
	{"냉담한 본능", 0},
	{"공포선장의 망원경", 1, 1},
	{"해상 폭풍우", 1, 2},
	{"쿨 티란 포탄 주자", 1, 1.5},
	{"응결된 정수", 1, 1},
	{"단지 안의 작은 정령", 1, 1},
	{"공명하는 정령의 심장", 1, 1},
	{"부산스러운 혈구", 1, 2.25},
	{"티탄 과충전", 1, 1},
	{"잔존하는 포자 깍지", 1, 1.69},
	{"영혼수호자", 1, 0.85},
	{"유전적 병약의 주사기", 1, 1},
	{"크롤로크의 힘", 1, 1.75}, 
	{"도살자의 눈", 1, 1},
	{"레잔의 번뜩이는 눈", 1, 1},
	{"집중된 암흑", 1, 1},
	{"룬의 냉기", 1, 2},
	{"원시 본능", 1, 3},

	{"달의 손길", 1, 2.25},

	{"잘자익스의 잔존하는 힘", 4, 4},
	{"억제되지 않은 힘", 0},
	{"영혼 점화", 0},


	-- 다자알로 (장신구)
	{"원.기.촉.진. 가동", 0},
	{"빛나는 광택", 0},
	{"바람의 은총", 1, 1.5},
	{"다이아몬드 보호막", 0},
	{"브원삼디의 거래", 0},


	--아제
	{"구르는 천둥", 0},
	{"압도적인 힘", 0},
	{"순간 포착!", 0},


	--물약
	{"민첩의 전투 물약", 0},
	{"지능의 전투 물약", 0},
	{"체력의 전투 물약", 0},
	{"힘의 전투 물약", 0},
	{"강철피부 물약", 0},
	{"원기회복의 물약", 0},
	{"일어나는 죽음의 물약", 0},
	{"폭팔하는 피의 물약", 0},


    --잔달라
    {"파쿠의 은총", 1, 1},
    {"크라그와의 은총", 0},


    --용광로
    {"심연의 보호", 0},

    --정수
    {"집중된 불길", 0},
    {"원수의 피", 0},
    {"자각몽의 기억", 0},
    {"피투성이", 0},
    {"강화된 무의 보호막", 0},
    {"아제로스의 영원한 선물", 0},
    {"고지 사수", 0},
    {"심연의 아이기스", 0},
    {"완벽의 환영", 0},
    {"마나 과충전", 0},
    {"억제의 구슬", 0},
    {"끝없이 치솟는 파도", 0},

    --8.2 장신구
    {"폭풍의 명가 전서", 1, 6},
    {"공허 타협", 0},
    {"불지옥 연금술사 돌", 1, 1},
    {"속박꾼의 영향력", 0},
    {"무정함 증폭", 1, 1.25},
    {"조류 폭풍우", 1, 8},

}

local FileExistList = {

    ["원소의 격류"] = 1;
    ["잘자익스의 잔존하는 힘"] = 1;

}
	

local ASABF_Current_Buff = "";
local ASABF_Current_Count = 0;


local a_isProc = {};
local a_isBuffShow = {};
local a_State = {};
local a_Name = {};



local unusedOverlayGlows = {};
local numOverlays = 0;

function  AABF_GetOverlayGlow()
	local overlay = tremove(unusedOverlayGlows);
	if ( not overlay ) then
		numOverlays = numOverlays + 1;
		overlay = CreateFrame("Frame", "AABF_ActionButtonOverlay"..numOverlays, UIParent, "AABF_ActionBarButtonSpellActivationAlert");
	end
	return overlay;
end


function AABF_ShowOverlayGlow(self)
	if ( self.overlay ) then
		if ( self.overlay.animOut:IsPlaying() ) then
			self.overlay.animOut:Stop();
			self.overlay.animIn:Play();
		end
	else
		self.overlay = AABF_GetOverlayGlow();
		local frameWidth, frameHeight = self:GetSize();
		self.overlay:SetParent(self);
		self.overlay:ClearAllPoints();
		--Make the height/width available before the next frame:
		self.overlay:SetSize(frameWidth * 1.5, frameHeight * 1.5);
		self.overlay:SetPoint("TOPLEFT", self, "TOPLEFT", -frameWidth * 0.3, frameHeight * 0.3);
		self.overlay:SetPoint("BOTTOMRIGHT", self, "BOTTOMRIGHT", frameWidth * 0.3, -frameHeight * 0.3);
		self.overlay.animIn:Play();
	end
end

function AABF_HideOverlayGlow(self)
	if ( self.overlay ) then
		if ( self.overlay.animIn:IsPlaying() ) then
			self.overlay.animIn:Stop();
		end
		if ( self:IsVisible() ) then
			self.overlay.animOut:Play();
		else
			AABF_OverlayGlowAnimOutFinished(self.overlay.animOut);	--We aren't shown anyway, so we'll instantly hide it.
		end
	end
end


function AABF_OverlayGlowAnimOutFinished(animGroup)
	local overlay = animGroup:GetParent();
	local actionButton = overlay:GetParent();
	overlay:Hide();
	tinsert(unusedOverlayGlows, overlay);
	actionButton.overlay = nil;
end

function AABF_OverlayGlowOnUpdate(self, elapsed)
	AnimateTexCoords(self.ants, 256, 256, 48, 48, 22, elapsed, 0.01);
end

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
   
	azeriteTraits = {};
	ASABF_AzeriteTraits = {};
   
    local azeriteItemLocation = C_AzeriteItem.FindActiveAzeriteItem()
    if azeriteItemLocation and ASABF_AzelateAutoDetect then
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
                        if tierInfo then
                            local tierCount = #tierInfo
                            local showcount = ASABF_AzelateMaxCheckTier
                            if tierCount < 5 then
                                showcount = ASABF_AzelateMaxCheckTier - 1
                            end

                            for azeriteTier, tierInfo in pairs(tierInfo) do
                              for i, idx in pairs(tierInfo.azeritePowerIDs) do
                                    if C_AzeriteEmpoweredItem.IsPowerSelected(itemLoc, idx) then
                                        local azeriteSpellID = GetAzeritePowerID(idx)
                                        if azeriteSpellID ~= 263978 and azeriteTier <= showcount then
                                   	    	local azeritePowerName, _, icon = GetSpellInfo(azeriteSpellID)
		    							    ASABF_AzeriteTraits[azeritePowerName] = 1
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


   for i =1,#slotNames do 
		local  idx = GetInventorySlotInfo(slotNames[i]);
		local itemid = GetInventoryItemID("player",idx) 

		if itemid and ASABF_TrinketAutoDetect then 

			  _, id = GetItemSpell(itemid);

			if id then
				local SlotSpellName, _, icon = GetSpellInfo(id)
				ASABF_AzeriteTraits[SlotSpellName] = 1
			end
		end

	end

    
end


function ASABF_UpdateBuff(unit)

	local selfName;
	local numDebuffs = 1;
	local numShow = 1;
	local frame, frameName;
	local frameIcon, frameCount, frameCooldown, frameStealable;
	local name, rank, icon, count, debuffType, duration, expirationTime, caster, isStealable;
	local color;
	local frameBorder;
	local maxIdx;
	local parent;
	local frametype;
	local isFirst = true;

	selfName = "ASABF_PBUFF_";
	maxIdx = MAX_TARGET_BUFFS;
	parent = ASABF_PLAYER_BUFF;

	frametype = selfName.."Button";

	--for i = 1, maxIdx do
	i = 1;

	local a_isShow = {};

	for k = 1 , #ASABF_ProcBuffList do
		a_isShow[k] = false;


	end

	a_isProc2Cnt = 0;

	repeat
		local skip = false;
		local debuff;
		local bufidx;
		local isStealable = false;
		local stack = nil;
		local isTarget = false;
		local alert = false;
		local azerite = false;

		
		name,  icon, count, debuffType, duration, expirationTime, caster, isStealable, shouldConsolidate, spellId, _,_ , casterIsPlayer, nameplateShowAll, stack,value2,value3  = UnitBuff("player", i);
		
		skip = true;

		if (icon == nil) then
			break;
		end


	

		local k = ASABF_BuffNameList[name] or ASABF_BuffIDList[spellId];

		if k and (duration > 0 or count > 1)  then


			a_isProc[k] = { expirationTime , duration, icon, spellId, name};
			a_isShow[k] = true;
			skip = false;
			a_isBuffShow[k] = false;
		elseif ASABF_AzeriteTraits[name] then
			skip = false;
			azerite = true;
		end

		if (icon and skip == false) then

			if numDebuffs > ASABF_MAX_BUFF_SHOW then
				break;
			end

			local color;
			frameName = frametype..numDebuffs;
			frame = _G[frameName];
			
			if ( not frame ) then
				frame = CreateFrame("Button", frameName, parent, "asActiveBuffFrameTemplate");
				frame:EnableMouse(false); 
				for _,r in next,{_G[frameName.."Cooldown"]:GetRegions()}	do 
					if r:GetObjectType()=="FontString" then 
						r:SetFont("Fonts\\2002.TTF",ASABF_CooldownFontSize,"OUTLINE")
						r:SetPoint("CENTER", 0, 0);
						break 
					end 
				end

				local font, size, flag = _G[frameName.."Count"]:GetFont()

				_G[frameName.."Count"]:SetFont(font, ASABF_CountFontSize, "OUTLINE")
				_G[frameName.."Count"]:SetPoint("BOTTOMRIGHT", -2, 2);

			end
			-- set the icon
			frameIcon = _G[frameName.."Icon"];
			frameIcon:SetTexture(icon);
			frameIcon:SetAlpha(ASABF_ALPHA);
			frameIcon:SetDesaturated(false)


			-- set the count
			frameCount = _G[frameName.."Count"];
			-- Handle cooldowns
			frameCooldown = _G[frameName.."Cooldown"];
			
			frame:SetWidth(ASABF_SIZE);
			frame:SetHeight(ASABF_SIZE);
			frame:SetAlpha(ASABF_AlphaBuff);
			frame:SetScale(1);

			if ( count > 1 ) then
				    frameCount:SetText(count);
				frameCount:Show();
			else
				if (stack > 1) then
					if(stack > 999999) then 
						stack = math.ceil(stack/1000000) .. "m" 
					elseif(stack > 999) then 
						stack = math.ceil(stack/1000) .. "k" 
					end   						
						
					frameCount:SetText(stack);
					frameCount:Show();
				else
					frameCount:Hide();
				end

			end				
			
			if ( duration > 0 and duration <= 120 ) then
				frameCooldown:Show();
				CooldownFrame_Set(frameCooldown, expirationTime - duration, duration, duration >0,  true);
				frameCooldown:SetHideCountdownNumbers(false);

			else
				frameCooldown:Hide();
			end

			if azerite then
				AABF_HideOverlayGlow(frame);				
			elseif  ASABF_ProcBuffList[k][2] == 3 then 
				local alert_du = ASABF_ProcBuffList[k][3]
				if alert_du and (expirationTime - GetTime()) <= alert_du and duration > 0  then
					AABF_ShowOverlayGlow(frame);
					if a_State[k] == nil or a_State[k] == 0 then
						a_State[k] = 1;
                        if FileExistList[name] then
						    PlaySoundFile("Interface\\AddOns\\asActiveBuffFilter\\Sound\\".. name.. ".mp3", "DIALOG")
                        end
					end


			  	else
					AABF_HideOverlayGlow(frame);
				end
			elseif ASABF_ProcBuffList[k][2] == 4 then 
				local alert_count = ASABF_ProcBuffList[k][3]
				if alert_count and count and  count >= alert_count  then
					AABF_ShowOverlayGlow(frame);

					if a_State[k] == nil or a_State[k] == 0 then
						a_State[k] = 1;
                        if FileExistList[name] then
    						PlaySoundFile("Interface\\AddOns\\asActiveBuffFilter\\Sound\\".. name.. ".mp3", "DIALOG")
                        end
					end

			  	else
					AABF_HideOverlayGlow(frame);
				end
			else
				AABF_HideOverlayGlow(frame);
			end

			if  not azerite and ASABF_ProcBuffList[k][2] < 2 then

				if a_State[k] == nil or a_State[k] == 0 then
					a_State[k] = 1;
                    if FileExistList[name] then
    					PlaySoundFile("Interface\\AddOns\\asActiveBuffFilter\\Sound\\".. name.. ".mp3", "DIALOG")
                    end
				end


			end

		

			frame:ClearAllPoints();
			frame:Show();

			if  not azerite then
				a_isBuffShow[k] = true;
			end

			numDebuffs = numDebuffs + 1;
			numShow = numShow + 1;
		end
		i = i+1
	until (name == nil)
	

	local z;
	for z = 1 , #ASABF_ProcBuffList do

	
		if a_isProc[z] and not (a_isShow[z]) then
			local activetype = ASABF_ProcBuffList[z][2];
			local rppm = ASABF_ProcBuffList[z][3];
			local icon = a_isProc[z][3]
			local name = a_isProc[z][5]
			
			if activetype == 1 then

				local laststart = a_isProc[z][1] - a_isProc[z][2]
				local currtime = GetTime();
				local haste = GetHaste() / 100 
				local since = currtime - laststart;


				--print (haste, rppm, since);

				--local proc_val = math.floor((rppm * haste * (currtime - laststart) / 60) * 100);


				local proc_val = math.floor((rppm * (1 + haste) * (math.min(since, 10)/60) * math.max(1, ((1+(since/(60/rppm))) - 1.5) * 3))* 100);

				if proc_val < 100 then
					if numDebuffs > ASABF_MAX_BUFF_SHOW then
						break;
					end

					local color;
					frameName = frametype..numDebuffs;
					frame = _G[frameName];
			
					if ( not frame ) then
						frame = CreateFrame("Button", frameName, parent, "asActiveBuffFrameTemplate");
						frame:EnableMouse(false); 
						for _,r in next,{_G[frameName.."Cooldown"]:GetRegions()}	do 
							if r:GetObjectType()=="FontString" then 
								r:SetFont("Fonts\\2002.TTF",ASABF_CooldownFontSize,"OUTLINE")
								r:SetPoint("CENTER", 0, 0);
								break 
							end 
						end
		
						local font, size, flag = _G[frameName.."Count"]:GetFont()
	
						_G[frameName.."Count"]:SetFont(font, ASABF_CountFontSize, "OUTLINE")
						_G[frameName.."Count"]:SetPoint("BOTTOMRIGHT", -2, 2);

					end
				-- set the icon
					frameIcon = _G[frameName.."Icon"];
					frameIcon:SetTexture(icon);
					frameIcon:SetAlpha(ASABF_ALPHA);
					frameIcon:SetDesaturated(true)

					frame:SetAlpha(ASABF_AlphaCool);
					frame:SetScale(0.5);


					-- set the count
					frameCount = _G[frameName.."Count"];
					-- Handle cooldowns
					frameCooldown = _G[frameName.."Cooldown"];
				
					frame:SetWidth(ASABF_SIZE);
					frame:SetHeight(ASABF_SIZE);

					frameCooldown:Hide();

					if ( proc_val > 0 ) then
						frameCount:SetText(proc_val .. "%");
						frameCount:Show();
					end				

					AABF_HideOverlayGlow(frame);
			
					frame:ClearAllPoints();
					frame:Show();

					numDebuffs = numDebuffs + 1;
				end
			elseif activetype == 2 then
				local laststart = a_isProc[z][1] - a_isProc[z][2]
				local currtime = GetTime();
				local duration = rppm;

				if currtime - laststart < duration then

					if numDebuffs > ASABF_MAX_BUFF_SHOW then
						break;
					end

					local color;
					frameName = frametype..numDebuffs;
					frame = _G[frameName];
			
					if ( not frame ) then
						frame = CreateFrame("Button", frameName, parent, "asActiveBuffFrameTemplate");
						frame:EnableMouse(false); 
						for _,r in next,{_G[frameName.."Cooldown"]:GetRegions()}	do 
							if r:GetObjectType()=="FontString" then 
								r:SetFont("Fonts\\2002.TTF",ASABF_CooldownFontSize,"OUTLINE")
								r:SetPoint("CENTER", 0, 0);
								break 
							end 
						end
		
						local font, size, flag = _G[frameName.."Count"]:GetFont()
	
						_G[frameName.."Count"]:SetFont(font, ASABF_CountFontSize, "OUTLINE")
						_G[frameName.."Count"]:SetPoint("BOTTOMRIGHT", -2, 2);

					end
				-- set the icon
					frameIcon = _G[frameName.."Icon"];
					frameIcon:SetTexture(icon);
					frameIcon:SetAlpha(ASABF_ALPHA);
					frameIcon:SetDesaturated(true)
					frame:SetAlpha(ASABF_AlphaCool);
					frame:SetScale(0.5);

					-- set the count
					frameCount = _G[frameName.."Count"];
					-- Handle cooldowns
					frameCooldown = _G[frameName.."Cooldown"];
				
					frame:SetWidth(ASABF_SIZE);
					frame:SetHeight(ASABF_SIZE);

					if ( duration > 0 ) then
						frameCooldown:Show();
						CooldownFrame_Set(frameCooldown, laststart, duration, duration >0,  true);
					else
						frameCooldown:Hide();
					end	


					if (laststart + duration - GetTime()) <= 3 and duration > 0  then
						AABF_ShowOverlayGlow(frame);
				  	else
						AABF_HideOverlayGlow(frame);
					end
					frameCount:Hide();
			
					frame:ClearAllPoints();
					frame:Show();

					numDebuffs = numDebuffs + 1;

					a_State[z] = 2;
				else
					if  a_State[z] == 2 then
						a_State[z] = 0 
						--PlaySoundFile("Interface\\AddOns\\asActiveBuffFilter\\Sound\\".. name.. ".mp3", "DIALOG")
					end
				end			
			end
		end

		if a_isShow[z] == false and (a_State[z] == nil or a_State[z] == 1)  then
			a_State[z] = 0;
		end

	end


	


	for i=1, numDebuffs - 1 do
		if i < numShow then
			ASABF_UpdateBuffAnchor(frametype, i, i - 1, ASABF_SIZE, 4, false, parent);
		else
			ASABF_UpdateBuffAnchor(frametype, i, i - 1, ASABF_SIZE, 4, false, parent);
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

function ASABF_UpdateBuffAnchor(debuffName, index, anchorIndex, size, offsetX, right, parent)

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
	buff:SetHeight(size);
end


function ASABF_OnEvent(self, event, arg1, ...)
	if (event == "UNIT_AURA" and arg1 == "player") then
		ASABF_UpdateBuff("pbuff");
	elseif (event == "AZERITE_ITEM_POWER_LEVEL_CHANGED" or event == "AZERITE_EMPOWERED_ITEM_SELECTION_UPDATED" or event == "PLAYER_EQUIPMENT_CHANGED" or event == "PLAYER_ENTERING_WORLD") then
		checkAzerite();
	end
end

local update = 0;
function ASABF_OnUpdate(self, elapsed)

	update = update + elapsed

	if update >= 1  then
		update = 0
		ASABF_UpdateBuff("pbuff");
	end
end

function ASABF_Init()

	for k = 1 , #ASABF_ProcBuffList do

		local num = tonumber(ASABF_ProcBuffList[k][1])

		if num then
			ASABF_BuffIDList[num] = k;
		else
			ASABF_BuffNameList[ASABF_ProcBuffList[k][1]] = k;
		end
	end


	ASABF = CreateFrame("Frame", nil, UIParent)

	ASABF:SetPoint("CENTER", 0, 0)
	ASABF:SetWidth(1)
	ASABF:SetHeight(1)
	ASABF:SetScale(1)
	ASABF:SetAlpha(ASABF_ALPHA);
	ASABF:Show()

	ASABF_PLAYER_BUFF = CreateFrame("Frame", "ASABF_PLAYER_BUFF", ASABF)

	ASABF_PLAYER_BUFF:SetPoint("CENTER", ASABF_PLAYER_BUFF_X, ASABF_PLAYER_BUFF_Y)
	ASABF_PLAYER_BUFF:SetWidth(1)
	ASABF_PLAYER_BUFF:SetHeight(1)
	ASABF_PLAYER_BUFF:SetScale(1)
	--ASABF_PLAYER_BUFF:SetFrameStrata("BACKGROUND")
	ASABF_PLAYER_BUFF:Show()

    LoadAddOn("asMOD");

    if asMOD_setupFrame then
        asMOD_setupFrame (ASABF_PLAYER_BUFF, "asActiveBuffFilter");
    end
	
	ASABF:RegisterUnitEvent("UNIT_AURA", "player")
	ASABF:RegisterEvent("AZERITE_ITEM_POWER_LEVEL_CHANGED")
	ASABF:RegisterEvent("AZERITE_EMPOWERED_ITEM_SELECTION_UPDATED")
	
	ASABF:RegisterEvent("PLAYER_EQUIPMENT_CHANGED")
	ASABF:RegisterEvent("PLAYER_ENTERING_WORLD")



	ASABF:SetScript("OnEvent", ASABF_OnEvent)
	ASABF:SetScript("OnUpdate", ASABF_OnUpdate)

end

ASABF_Init()



