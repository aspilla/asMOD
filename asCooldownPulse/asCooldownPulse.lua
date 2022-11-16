local ACDP = {};
local ACDP_Icon = {};
local ACDP_mainframe
ACDP_CoolButtons = nil;

local ACDP_SpellList = {}
local ACDP_SpellListType = {}
local ACDP_ExpirationTime = {}
local ACDP_StartTime = {}
local ACDP_bDelete = {}
local ACDP_bPet = {}
local ACDP_bUpdate = {}
local ACDP_ShowIdx = {}
local ACDP_CheckCount = {}

local update = 0
local prev_cnt = 0;

-- 설정 최소 Cooldown (단위 초)
local CONFIG_MINCOOL = 3
local CONFIG_MAXCOOL = (60 * 10)
local CONFIG_MINCOOL_PET = 20
local CONFIG_SOUND = true				-- 음성안내


ACDP_CoolButtons_X = -100				-- 쿨 List 위치
ACDP_CoolButtons_Y = -203
local ACDP_AlertButtons_X = 0			-- Alert button 위치
local ACDP_AlertButtons_Y = 0
local ACDP_AlertButtons_Size = 60		-- Alert button size 
local ACDP_AlertFadeTime = 0.5			-- Alert button Fade in-out 시간 짧으면 빨리 사라짐
local ACDP_AlertShowTime = 0.2			-- Alert button Fade in-out 시간 짧으면 빨리 사라짐



local ACDP_SIZE = 32;					-- 쿨 List Size
ACDP_Show_CoolList = true;				-- 쿨 List를 보일지 안보일지 (안보이게 하려면 false)
local ACDP_Alert_Time = 0.5;			-- 쿨 0.5초전에 알림
local ACDP_ALPHA = 1;					
local ACDP_CooldownFontSize = 11;		-- Cooldown Font Size 기본 쿨다운 지원
local ACDP_GreyColor = false 			-- Color Icon 원하면 false
local ACDP_CooldownCount = 6;			-- 줄당 보일 CooldownCount 개수가 되면 줄을 바꾸어 표시됨 1줄로 보이려면 큰수로 지정

local ACDP_NextExTime = 0xFFFFFFFF;



local KnownSpellList = {};
local ItemSlotList = {};

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

--8.2 이후 Sound 폴더에 File 저장후 이 List 에 추가 해 주어야함, 이 List 에 없는 파일은 재생 안됨
local FileExistList = {
    
    [13] = 1;
    [14] = 1;
    ["광전사의 격노"] = 1;
    ["광폭화"] = 1;
    ["날카로운 바람"] = 1;
    ["대재앙"] = 1;
    ["두개골 강타"] = 1;
    ["들이치기"] = 1;
    ["마법 차단"] = 1;
    ["무모한 희생"] = 1;
    ["반격의 사격"] = 1;
    ["발차기"] = 1;
    ["발화"] = 1;
    ["분열"] = 1;
    ["불의 정령"] = 1;
    ["비난"] = 1;
    ["비전 보주"] = 1;
    ["손날 찌르기"] = 1;
    ["신비의 마법 강화"] = 1;
    ["아그레날린 촉진"] = 1;
    ["악마 폭군 소환"] = 1;
    ["암흑시선 소환"] = 1;
    ["야생의 상"] = 1;
    ["야수 정령"] = 1;
    ["야수의 격노"] = 1;
    ["어둠의 마귀"] = 1;
    ["어둠의 칼날"] = 1;
    ["얼어붙은 구슬"] = 1;
    ["얼음 기둥"] = 1;
    ["얼음 핏줄"] = 1;
    ["원한"] = 1;
    ["응징의 격노"] = 1;
    ["재갈"] = 1;
    ["정신 얼리기"] = 1;
    ["정조준"] = 1;
    ["지옥불정령 소환"] = 1;
    ["천체의 정렬"] = 1;
    ["침묵"] = 1;
    ["칼날폭풍"] = 1;
    ["탈태"] = 1;
    ["태양 광선"] = 1;
    ["폭풍과 대지와 불"] = 1;
    ["협공"] = 1;

}


local function scanSpells(tab)

	local tabName, tabTexture, tabOffset, numEntries = GetSpellTabInfo(tab)

	if not tabName then
		return;
	end

	for i=tabOffset + 1, tabOffset + numEntries do
		local spellName, _, spellID = GetSpellBookItemName (i, BOOKTYPE_SPELL)
		if not spellID then
			do break end
		end

		KnownSpellList[spellID] = 1;
	end
end


local function scanPetSpells()

	for i = 1, 20 do
	   local slot = i + (SPELLS_PER_PAGE * (SPELLBOOK_PAGENUMBERS[BOOKTYPE_PET] - 1));
	   local spellName, _, spellID = GetSpellBookItemName (slot, BOOKTYPE_PET)
	   
		if not spellID then
			do break end
		end

		KnownSpellList[spellID] = 1;
	end

end

local function scanActionSlots()

		local lActionSlot = 0;

	for lActionSlot = 1, 120 do
		local type, id, subType, spellID = GetActionInfo(lActionSlot);
		local itemid = nil;

		
		if type and type == "macro" then

			 id = GetMacroSpell(id);
		end

		if type and type == "item" then
			itemid = id;
			 _, id = GetItemSpell(id);
		end



		if id then

				
			if itemid then
				KnownSpellList[id] = itemid; 
			else
				KnownSpellList[id] = 1;
			end
		end


	end


	for i=1, NUM_PET_ACTION_SLOTS, 1 do
		local name, texture, isToken, isActive, autoCastAllowed, autoCastEnabled, spellID = GetPetActionInfo(i);
		
		if spellID then
			KnownSpellList[spellID] = 1;
		end
	end

end

local function scanItemSlots()

	for i =1,#itemslots do 

		local  idx = GetInventorySlotInfo(itemslots[i]);

		local itemid = GetInventoryItemID("player",idx) 

		if itemid then 

			  _, id = GetItemSpell(itemid);



			if id then
				KnownSpellList[id] = itemid; 
				ItemSlotList[itemid] =  idx;
			end
		end

	end

end

local function setupKnownSpell()

	table.wipe(KnownSpellList);
	table.wipe(ItemSlotList);

	scanSpells(1)
	scanSpells(2)
	scanPetSpells()

	scanActionSlots();
	scanItemSlots();
end

local function ACDP_UpdateCoolAnchor(name, index, anchorIndex, size, offsetX, right, parent)

	local cool = _G[name..index];
	local point1 = "TOPLEFT";
	local point2 = "BOTTOMLEFT";
	local point3 = "TOPRIGHT";

	if (right == false) then
		point1 = "TOPRIGHT";
		point2 = "BOTTOMRIGHT";
		point3 = "TOPLEFT";
		offsetX = -offsetX;
	end

	local offsetY = -(size + offsetX) * math.floor(index / 6);

	if ( index % ACDP_CooldownCount == 1 ) then
		cool:SetPoint(point1, parent, point2, 0, offsetY);
	else
		cool:SetPoint(point1, _G[name..(index-1)], point3, offsetX, 0);
	end
end


local function ACDP_UpdateCooldown()

	local selfName;
	local numCools = 1;
	local frame, frameName;
	local frameIcon, frameCooldown;
	local name, icon, duration, start;
	local color;
	local frameBorder;
	local maxIdx;
	local parent;
	local frametype;

	selfName = "ACDP_Cool_";

	maxIdx = #ACDP_SpellList;
	parent = ACDP_CoolButtons;

	frametype = selfName.."Button";


	if (ACDP_Show_CoolList == false) then

		for i = 1, ACDP_CooldownCount do
			frameName = frametype..i;
			frame = _G[frameName];

			if ( frame ) then
			frame:Hide();	
			end
		end

		return;
	end


	for i = 1, maxIdx do
		local skip = false;
		local debuff;
		local idx = i;
		local array = ACDP_SpellList;
		local type = ACDP_SpellListType[idx];
	
	
		if ACI_SpellID_list and ACI_SpellID_list[array[idx]] then
			skip = true;
		end
					
		if ACDP_StartTime[idx] > 0 and ACDP_bDelete[idx] == false and skip == false then
			
			if (type == "spell") then
				name, discard, icon = GetSpellInfo(array[idx]);
				start, duration = GetSpellCooldown(array[idx]);
			elseif (type =="action") then
				name, discard, discard, discard, discard, discard, discard, discard, discard, icon = GetItemInfo(GetInventoryItemLink("player",array[idx]))
				start, duration = GetInventoryItemCooldown("player", array[idx]);
			else
				name, discard, discard, discard, discard, discard, discard, discard, discard, icon = GetItemInfo(array[idx])
				start, duration = GetItemCooldown(array[idx]);
			end

			if ACI_SpellID_list and ACI_SpellID_list[name] then
				skip = true;
			end

			if (icon and duration > 0) and skip == false then
				frameName = frametype..numCools;
				frame = _G[frameName];

				if ( not frame ) then
					frame = CreateFrame("Button", frameName, parent, "asCooldownPulseFrameTemplate");
					frame:SetWidth(ACDP_SIZE);
					frame:SetHeight(ACDP_SIZE);
					frame:EnableMouse(false); 
					frame:Disable();

					for _,r in next,{_G[frameName.."Cooldown"]:GetRegions()}	do 
						if r:GetObjectType()=="FontString" then 
							r:SetFont("Fonts\\2002.TTF",ACDP_CooldownFontSize,"OUTLINE")
							break 
						end 
					end

				end

				if (not (ACDP_ShowIdx[numCools] == array[idx])) or 
					(not (ACDP_ExpirationTime[idx] == start + duration)) or
					(ACDP_bUpdate[idx] == true) then
					-- set the icon
					frameIcon = _G[frameName.."Icon"];
					frameIcon:SetTexture(icon);
					frameIcon:SetAlpha(ACDP_ALPHA);
					frameIcon:SetDesaturated(ACDP_GreyColor)

					frameBorder = _G[frameName.."Border"];
					frameBorder:Hide();

					--[[

					frameIcon:SetTexCoord(.08, .92, .08, .92)

	--CreateBDFrame(frameBorder, 1);
					frameBorder:SetTexture("Interface\\Addons\\asCombatInfo\\border.tga")
					frameBorder:SetTexCoord(0.08,0.08, 0.08,0.92, 0.92,0.08, 0.92,0.92)	
					frameBorder:SetVertexColor(0, 0, 0);
					frameBorder:Show();

					--]]


					-- set the count
					frameCooldown = _G[frameName.."Cooldown"];
					frameCooldown:Show();
					CooldownFrame_Set(frameCooldown, start, duration, duration > 0, true);
					frameCooldown:SetHideCountdownNumbers(false);
					ACDP_bUpdate[idx] = false;
					ACDP_ShowIdx[numCools] = array[idx]; 

					local ex = start + duration;

					if ACDP_NextExTime > ex then
						ACDP_NextExTime = ex;
					end
					
					--ChatFrame1:AddMessage(start.." "..duration.." "..ACDP_SpellList[i].." "..ACDP_SpellListType[i].." "..name)
				end
			
				numCools = numCools + 1;

				frame:ClearAllPoints();
				frame:Show();

				if numCools > ACDP_CooldownCount then
					break;

				end

			else
				ACDP_bDelete[idx] = true;
			end

		end
	end

	for i=1, numCools - 1 do
		-- anchor the current aura
		ACDP_UpdateCoolAnchor(frametype, i, i- 1, ACDP_SIZE, 1.4, true, parent);
	end

	-- 이후 전에 보였던 frame을 지운다.
	for i = numCools, prev_cnt do
		frameName = frametype..i;
		frame = _G[frameName];

		if ( frame ) then
			frame:Hide();	
			ACDP_ShowIdx[i] = nil; 
		end
	end

	prev_cnt = numCools;
end


local ACDP_Icon_Idx = 1;



local function ACDP_Alert(spell, type)

	if type == "spell" then
		local name,discard,icon,discard,discard,discard,discard,discard,discard = GetSpellInfo(spell)
		ACDP_Icon[ACDP_Icon_Idx]:SetTexture(icon)
		if CONFIG_SOUND and FileExistList[name] then
            PlaySoundFile("Interface\\AddOns\\asCooldownPulse\\SpellSound\\".. name.. ".mp3", "DIALOG")
        end
	elseif type == "action" then
		local icon = select(10,GetItemInfo(GetInventoryItemLink("player",spell)))
		ACDP_Icon[ACDP_Icon_Idx]:SetTexture(icon)

		if CONFIG_SOUND and FileExistList[spell] then
            PlaySoundFile("Interface\\AddOns\\asCooldownPulse\\SpellSound\\".. spell.. ".mp3", "DIALOG")
		end
	elseif type == "item" then
		local name, discard, discard, discard, discard, discard, discard, discard, discard, icon = GetItemInfo(spell)
		ACDP_Icon[ACDP_Icon_Idx]:SetTexture(icon)
		if CONFIG_SOUND and FileExistList[name] then

            PlaySoundFile("Interface\\AddOns\\asCooldownPulse\\SpellSound\\".. name.. ".mp3")
			
			if ItemSlotList[spell] and FileExistList[ ItemSlotList[spell]] then
                PlaySoundFile("Interface\\AddOns\\asCooldownPulse\\SpellSound\\".. ItemSlotList[spell].. ".mp3", "DIALOG")
            end

		end

	end

	asUIFrameFadeIn(ACDP[ACDP_Icon_Idx], ACDP_AlertShowTime, 0, 1)
	asUIFrameFadeOut(ACDP[ACDP_Icon_Idx], ACDP_AlertFadeTime, 1, 0)

	ACDP_Icon_Idx = ACDP_Icon_Idx + 1;

	if ACDP_Icon_Idx >10 then
		ACDP_Icon_Idx = 1;
	end

	return;
end

local function ACDP_Init()

	
	local i = 1;

	while ( i <=  10) do

		ACDP[i] = CreateFrame("Frame", nil, UIParent)

		--[[
		if ( i % 2 == 0) then
			ACDP[i]:SetPoint("CENTER", 0 - ACDP_AlertButtons_X, ACDP_AlertButtons_Y)
		else
			ACDP[i]:SetPoint("CENTER", ACDP_AlertButtons_X, ACDP_AlertButtons_Y)
		end
		--]]

		ACDP[i]:SetPoint("CENTER", ACDP_AlertButtons_X, ACDP_AlertButtons_Y)


		ACDP[i]:SetWidth(ACDP_AlertButtons_Size)
		ACDP[i]:SetHeight(ACDP_AlertButtons_Size)
		ACDP[i]:SetScale(1)
		ACDP[i]:SetAlpha(0)
		ACDP[i]:SetFrameStrata("LOW")
		ACDP[i]:EnableMouse(false); 
		ACDP[i]:Show()


		ACDP_Icon[i] = ACDP[i]:CreateTexture("ACDP_Texture", nil)
		ACDP_Icon[i]:SetTexture("")
		ACDP_Icon[i]:ClearAllPoints()
		ACDP_Icon[i]:SetAllPoints(ACDP[i])
		ACDP_Icon[i]:Show()


		
		i = i + 1;
	end



	ACDP_CoolButtons = CreateFrame("Frame", "ACDP_CoolButtons", UIParent)

	ACDP_CoolButtons:SetPoint("CENTER", ACDP_CoolButtons_X, ACDP_CoolButtons_Y)

	ACDP_CoolButtons:SetWidth(1)
	ACDP_CoolButtons:SetHeight(1)
	ACDP_CoolButtons:SetScale(1)
	ACDP_CoolButtons:SetFrameStrata("LOW")
	ACDP_CoolButtons:Show()

    LoadAddOn("asMOD");

    if asMOD_setupFrame then
         asMOD_setupFrame (ACDP_CoolButtons, "asCooldownPulselist");
    end


end

local function ACDP_Delete(idx)
	
	tremove(ACDP_SpellList, idx);
	tremove(ACDP_SpellListType, idx);
	tremove(ACDP_ExpirationTime, idx);
	tremove(ACDP_StartTime, idx);
	tremove(ACDP_bDelete, idx);
	tremove(ACDP_bPet, idx);
	tremove(ACDP_bUpdate, idx);
	tremove(ACDP_CheckCount, idx);
	--ChatFrame1:AddMessage("Delete "..#ACDP_SpellList);
end

local function ACDP_Checkcooldown()

	local i = 1;
	local bupdate = false;
	

	while ( i <=  #ACDP_SpellList) do

		if ACDP_SpellList[i] and ACDP_bDelete[i] == false then
			local start, duration, enabled;
			local check_duration = CONFIG_MINCOOL;
		
			if ACDP_bPet[i] == true then
				check_duration = CONFIG_MINCOOL_PET;
			end

			if ACDP_SpellListType[i] == "spell" then
				start, duration, enabled = GetSpellCooldown(ACDP_SpellList[i])
			elseif ACDP_SpellListType[i] == "action" then
				start, duration, enabled = GetInventoryItemCooldown("player", ACDP_SpellList[i])
			elseif ACDP_SpellListType[i] == "item" then
				start, duration, enabled = GetItemCooldown(ACDP_SpellList[i])
			end

			local _, gcd  = GetSpellCooldown(61304);

			
			--ChatFrame1:AddMessage(start.." "..duration.." "..ACDP_SpellList[i].." "..enabled.." "..ACDP_SpellListType[i])

			
			--if start and start > 0 and enabled and enabled == 1 and duration and duration > 0 and duration <= CONFIG_MAXCOOL then
			if start and start > 0 and duration and duration > 0 and duration <= CONFIG_MAXCOOL then


				local expirationTime = duration + start;

				if ACDP_NextExTime > expirationTime then
					ACDP_NextExTime = expirationTime;
				end
									
				if (ACDP_StartTime[i] == 0) then
					if duration >= check_duration then
						ACDP_ExpirationTime[i] = expirationTime;
						ACDP_StartTime[i] = start;
						ACDP_bUpdate[i] = true;
						bupdate = true;
					else
						--ACDP_bDelete[i] = true;
						ACDP_CheckCount[i] = ACDP_CheckCount[i] + 1;
						--print ("3" .. GetSpellInfo(ACDP_SpellList[i]));
					end
				elseif (not (ACDP_StartTime[i] == start) or not (ACDP_ExpirationTime[i] == expirationTime)) then

					if (duration == gcd) then
						--글쿨
						ACDP_bDelete[i] = true;
						--print ("1" .. GetSpellInfo(ACDP_SpellList[i]));
					else
						ACDP_StartTime[i] = start;
						ACDP_ExpirationTime[i] = expirationTime;
						bupdate = true;
						ACDP_bUpdate[i] = true;
					end
				end
			else
				--print ("2" .. GetSpellInfo(ACDP_SpellList[i]));
				--
				if (ACDP_StartTime[i] > 0  and ACDP_ExpirationTime[i] > 0) then
					ACDP_bDelete[i] = true;
					ACDP_bUpdate[i] = true;
					bupdate = true;
				elseif (ACDP_StartTime[i] > 0 or (ACDP_SpellListType[i] == "spell" and start == 0)) then
					ACDP_NextExTime = GetTime() + 0.25;
					--print ("2" .. GetSpellInfo(ACDP_SpellList[i]));
					ACDP_CheckCount[i] = ACDP_CheckCount[i] + 1;

					if ACDP_CheckCount[i] > 50 then
					--print ("5" .. GetSpellInfo(ACDP_SpellList[i]));
						ACDP_bDelete[i] = true;
						bupdate = true;
						ACDP_NextExTime = GetTime() + 0.25;
					end
				end
			end

		end
		
		i = i + 1
	end

	if (bupdate == true) then
		ACDP_UpdateCooldown();
	end
end

local function ACDP_Spell(name, type, unit)

	local i;
	local bPet = false;

	if unit and unit == "pet" then
		bPet = true;
	end

	--ChatFrame1:AddMessage(name .. " " .. type.. " " .. unit)

	if type == "action" or type == "item" then
		for i = 1, #ACDP_SpellList do
			if ACDP_SpellList[i] == name and ACDP_SpellListType[i] == type then
				return;
			end
		end
	elseif type == "spell" then

		local curr_time = GetTime();
		local spell_name = GetSpellInfo(name);
	
		for i = 1, #ACDP_SpellList do
			local spell_name2 = GetSpellInfo(ACDP_SpellList[i]);
			--if (ACDP_SpellList[i] == name or spell_name2 == spell_name) and ACDP_SpellListType[i] == type then
			--
			if ACDP_SpellList[i] == name  and ACDP_SpellListType[i] == type then
				
				if ACDP_StartTime[i] > 0 then
					if ACDP_ExpirationTime[i] > 0 and  ACDP_ExpirationTime[i] - ACDP_Alert_Time <= curr_time then
						ACDP_Alert(name, type);
					end
					ACDP_ExpirationTime[i] = 0;
					ACDP_StartTime[i] = 0;
					return;
				else
					return;
				end
			end
		end
	end


	local badd = true;
	
	--[[
	local next_list = ANS_SpellList;

	if next_list and #next_list > 0 then

		CONFIG_MINCOOL = 4;

		for i = 1, #next_list do
			local _, _, _, _, _, _, spellID = GetSpellInfo(next_list[i][1])
			if spellID == name then
				badd = false;
			end
		end
	end
	--]]

	if (badd) then


		tinsert(ACDP_SpellList, name)
		tinsert(ACDP_SpellListType , type)
		tinsert(ACDP_ExpirationTime, 0)
		tinsert(ACDP_StartTime, 0)
		tinsert(ACDP_bDelete, false)
		tinsert(ACDP_bPet, bPet)
		tinsert(ACDP_bUpdate, false)
		tinsert(ACDP_CheckCount, 0);

		--ACDP_NextExTime = 0;
	
		if type == "action" or type == "item" then
			ACDP_Checkcooldown();	
		end
	end
end


local function ACDP_OnUpdate()

	if #ACDP_SpellList > 0 then

		local i = 1;
		local curr_time = GetTime();
		local bupdate = false;
		local bcheck = false;

		ACDP_Checkcooldown();	
	
		if	ACDP_NextExTime  - ACDP_Alert_Time <= curr_time  then
			ACDP_NextExTime = 0xFFFFFFFF;

			while (i <= #ACDP_SpellList) do
	
				local bDelete = false;

				if ACDP_SpellList[i] and (ACDP_StartTime[i] > 0 or ACDP_bDelete[i] == true) then
								
					if ACDP_ExpirationTime[i] - ACDP_Alert_Time <= curr_time  then
						if ACDP_StartTime[i] > 0 then
							ACDP_Alert(ACDP_SpellList[i], ACDP_SpellListType[i])
						end
						ACDP_Delete(i)
						bupdate = true;
						bDelete = true;
					elseif ACDP_bDelete[i] then
						if ACDP_StartTime[i] > 0 then
							ACDP_Alert(ACDP_SpellList[i], ACDP_SpellListType[i])
						end
						ACDP_Delete(i)
						bupdate = true;
						bDelete = true;
					elseif ACDP_NextExTime > ACDP_ExpirationTime[i] then
						ACDP_NextExTime = ACDP_ExpirationTime[i];

					end
				end	

				if ACDP_StartTime[i] == 0 then
					bcheck = true;				
				end

				if (bDelete == false) then
					i = i + 1;
				end
			end


			if bcheck == true then
				ACDP_Checkcooldown();
			end
	
			if bupdate == true then
				ACDP_UpdateCooldown();
			end
		end
		
	end
end

local function ACDP_OnEvent(self, event, arg1, arg2, arg3, arg4, arg5)

	local bupdate = true;

	if event == "UNIT_SPELLCAST_SUCCEEDED" and (arg1 == "player" or arg1 == "pet") then

		if KnownSpellList[arg3] == 1 then
			ACDP_Spell(arg3, "spell", arg1)
		elseif KnownSpellList[arg3] then
			ACDP_Spell( KnownSpellList[arg3] , "item")
		end

		--[[
		if IsSpellKnown(arg3, (arg1 == "pet")) then
			print (arg3);
			ACDP_Spell(arg3, "spell", arg1)
		else
			print ("n"..arg3);
		end
		--]]
	elseif event == "ACTIONBAR_UPDATE_COOLDOWN" or event == "BAG_UPDATE_COOLDOWN"  then
		ACDP_Checkcooldown()

	elseif event == "PLAYER_ENTERING_WORLD" then
		ACDP_UpdateCooldown()

		local GN={"ActionButton","MultiBarBottomLeftButton","MultiBarBottomRightButton","MultiBarLeftButton","MultiBarRightButton", "PetActionButton",  "StanceButton" }

		for _,f in next,GN do 
			for i=1,12 do 
				local cd = _G[f..i.."Cooldown"]
				if cd then
					for _,r in next,{cd:GetRegions()}	do 
						if r:GetObjectType()=="FontString" then 
							r:SetFont("Fonts\\2002.TTF",ACDP_CooldownFontSize,"OUTLINE")
							break 
						end 
					end 
				end
			end 
		end

		setupKnownSpell();


		if UnitAffectingCombat("player") then
			ACDP_CoolButtons:SetAlpha(ACDP_ALPHA);
		else
			ACDP_CoolButtons:SetAlpha(0.5);
		end

	elseif event == "PLAYER_REGEN_DISABLED" then
		ACDP_CoolButtons:SetAlpha(ACDP_ALPHA);
	elseif event == "PLAYER_REGEN_ENABLED" then
		ACDP_CoolButtons:SetAlpha(0.5);
	elseif event == "SPELLS_CHANGED" then
		scanSpells(2);
	elseif event == "UNIT_PET" then
		scanPetSpells();
	elseif event == "ACTIONBAR_SLOT_CHANGED" then
		scanActionSlots();
	elseif event == "PLAYER_EQUIPMENT_CHANGED" then
		scanItemSlots();
	end



	--[[
	if UnitAffectingCombat("player") then
		ACDP_CoolButtons:SetAlpha(ACDP_ALPHA);
	else
		ACDP_CoolButtons:SetAlpha(0.5);
	end
	--]]



	return;
end 

local function ACDP_ActionHook(slot)


	local item = GetItemInfo(GetInventoryItemLink("player",slot) or "")
    if (item) then
		ACDP_Spell(slot, "action")
	end
end

local function ACDP_AHook(slot)

	local actionType,itemID = GetActionInfo(slot)
    if (actionType == "item") then
		ACDP_Spell(itemID , "item")
	end
end



ACDP_mainframe = CreateFrame("Frame", nil, UIParent)
C_Timer.NewTicker(0.25, ACDP_OnUpdate);
ACDP_mainframe:SetScript("OnEvent", ACDP_OnEvent)
ACDP_mainframe:RegisterEvent("UNIT_SPELLCAST_SUCCEEDED")
--ACDP_mainframe:RegisterEvent("ACTIONBAR_UPDATE_COOLDOWN")
--ACDP_mainframe:RegisterEvent("BAG_UPDATE_COOLDOWN")
ACDP_mainframe:RegisterEvent("PLAYER_ENTERING_WORLD")
ACDP_mainframe:RegisterEvent("PLAYER_REGEN_DISABLED")
ACDP_mainframe:RegisterEvent("PLAYER_REGEN_ENABLED")
ACDP_mainframe:RegisterEvent("SPELLS_CHANGED")
ACDP_mainframe:RegisterUnitEvent("UNIT_PET", "player")
ACDP_mainframe:RegisterEvent("ACTIONBAR_SLOT_CHANGED")
ACDP_mainframe:RegisterEvent("PLAYER_EQUIPMENT_CHANGED")




ACDP_Init()

--hooksecurefunc("UseInventoryItem", ACDP_ActionHook)
--hooksecurefunc("UseAction", ACDP_AHook)

-- Alpha animation stuff
asFADEFRAMES = {};


local frameFadeManager = CreateFrame("FRAME");

function asUIFrameFade_OnUpdate(self, elapsed)
	local index = 1;
	local frame, fadeInfo;
	while asFADEFRAMES[index] do
		frame = asFADEFRAMES[index];
		fadeInfo = asFADEFRAMES[index].fadeInfo;
		-- Reset the timer if there isn't one, this is just an internal counter
		if ( not fadeInfo.fadeTimer ) then
			fadeInfo.fadeTimer = 0;
		end
		fadeInfo.fadeTimer = fadeInfo.fadeTimer + elapsed;

		-- If the fadeTimer is less then the desired fade time then set the alpha otherwise hold the fade state, call the finished function, or just finish the fade
		if ( fadeInfo.fadeTimer < fadeInfo.timeToFade ) then
			if ( fadeInfo.mode == "IN" ) then
				frame:SetAlpha((fadeInfo.fadeTimer / fadeInfo.timeToFade) * (fadeInfo.endAlpha - fadeInfo.startAlpha) + fadeInfo.startAlpha);
			elseif ( fadeInfo.mode == "OUT" ) then
				frame:SetAlpha(((fadeInfo.timeToFade - fadeInfo.fadeTimer) / fadeInfo.timeToFade) * (fadeInfo.startAlpha - fadeInfo.endAlpha)  + fadeInfo.endAlpha);
			end
		else
			frame:SetAlpha(fadeInfo.endAlpha);
			-- If there is a fadeHoldTime then wait until its passed to continue on
			if ( fadeInfo.fadeHoldTime and fadeInfo.fadeHoldTime > 0  ) then
				fadeInfo.fadeHoldTime = fadeInfo.fadeHoldTime - elapsed;
			else
				-- Complete the fade and call the finished function if there is one
				asUIFrameFadeRemoveFrame(frame);
				if ( fadeInfo.finishedFunc ) then
					fadeInfo.finishedFunc(fadeInfo.finishedArg1, fadeInfo.finishedArg2, fadeInfo.finishedArg3, fadeInfo.finishedArg4);
					fadeInfo.finishedFunc = nil;
				end
			end
		end

		index = index + 1;
	end

	if ( #asFADEFRAMES == 0 ) then
		self:SetScript("OnUpdate", nil);
	end
end


-- Generic fade function
function asUIFrameFade(frame, fadeInfo)
	if (not frame) then
		return;
	end
	if ( not fadeInfo.mode ) then
		fadeInfo.mode = "IN";
	end
	local alpha;
	if ( fadeInfo.mode == "IN" ) then
		if ( not fadeInfo.startAlpha ) then
			fadeInfo.startAlpha = 0;
		end
		if ( not fadeInfo.endAlpha ) then
			fadeInfo.endAlpha = 1.0;
		end
		alpha = 0;
	elseif ( fadeInfo.mode == "OUT" ) then
		if ( not fadeInfo.startAlpha ) then
			fadeInfo.startAlpha = 1.0;
		end
		if ( not fadeInfo.endAlpha ) then
			fadeInfo.endAlpha = 0;
		end
		alpha = 1.0;
	end
	frame:SetAlpha(fadeInfo.startAlpha);

	frame.fadeInfo = fadeInfo;
	frame:Show();

	local index = 1;
	while asFADEFRAMES[index] do
		-- If frame is already set to fade then return
		if ( asFADEFRAMES[index] == frame ) then
			return;
		end
		index = index + 1;
	end
	tinsert(asFADEFRAMES, frame);
	frameFadeManager:SetScript("OnUpdate", asUIFrameFade_OnUpdate);
end

-- Convenience function to do a simple fade in
function asUIFrameFadeIn(frame, timeToFade, startAlpha, endAlpha)
	local fadeInfo = {};
	fadeInfo.mode = "IN";
	fadeInfo.timeToFade = timeToFade;
	fadeInfo.startAlpha = startAlpha;
	fadeInfo.endAlpha = endAlpha;
	asUIFrameFade(frame, fadeInfo);
end

-- Convenience function to do a simple fade out
function asUIFrameFadeOut(frame, timeToFade, startAlpha, endAlpha)
	local fadeInfo = {};
	fadeInfo.mode = "OUT";
	fadeInfo.timeToFade = timeToFade;
	fadeInfo.startAlpha = startAlpha;
	fadeInfo.endAlpha = endAlpha;
	asUIFrameFade(frame, fadeInfo);
end

function asUIFrameFadeRemoveFrame(frame)
	tDeleteItem(asFADEFRAMES, frame);
end



