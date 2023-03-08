local ACDP = {};
local ACDP_Icon = {};
local ACDP_mainframe
local ACDP_CoolButtons = nil;

local prev_cnt = 0;

-- 설정 최소 Cooldown (단위 초)
local CONFIG_MINCOOL = 3
local CONFIG_MAXCOOL = (60 * 5)
local CONFIG_MINCOOL_PET = 20
local CONFIG_SOUND = true				-- 음성안내


local ACDP_CoolButtons_X = -98				-- 쿨 List 위치
local ACDP_CoolButtons_Y = -250
local ACDP_AlertButtons_X = 0			-- Alert button 위치
local ACDP_AlertButtons_Y = 0
local ACDP_AlertButtons_Size = 60		-- Alert button size 
local ACDP_AlertFadeTime = 0.5			-- Alert button Fade in-out 시간 짧으면 빨리 사라짐
local ACDP_AlertShowTime = 0.2			-- Alert button Fade in-out 시간 짧으면 빨리 사라짐



local ACDP_SIZE = 32;					-- 쿨 List Size
local ACDP_Show_CoolList = true;		-- 쿨 List를 보일지 안보일지 (안보이게 하려면 false)
local ACDP_Alert_Time = 0.5;			-- 쿨 1초전에 알림
local ACDP_ALPHA = 1;
local ACDP_CooldownFontSize = 11;		-- Cooldown Font Size 기본 쿨다운 지원
local ACDP_GreyColor = false 			-- Color Icon 원하면 false
local ACDP_CooldownCount = 6;			-- 줄당 보일 CooldownCount 개수가 되면 줄을 바꾸어 표시됨 1줄로 보이려면 큰수로 지정
local ACDP_UpdateRate = 0.2;			-- 0.2 초마다 check




-- Alpha animation stuff
local asFADEFRAMES = {};


local frameFadeManager = CreateFrame("FRAME");

local function asUIFrameFadeRemoveFrame(frame)
	tDeleteItem(asFADEFRAMES, frame);
end

local function asUIFrameFade_OnUpdate(self, elapsed)
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
local function asUIFrameFade(frame, fadeInfo)
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
local function asUIFrameFadeIn(frame, timeToFade, startAlpha, endAlpha)
	local fadeInfo = {};
	fadeInfo.mode = "IN";
	fadeInfo.timeToFade = timeToFade;
	fadeInfo.startAlpha = startAlpha;
	fadeInfo.endAlpha = endAlpha;
	asUIFrameFade(frame, fadeInfo);
end

-- Convenience function to do a simple fade out
local function asUIFrameFadeOut(frame, timeToFade, startAlpha, endAlpha)
	local fadeInfo = {};
	fadeInfo.mode = "OUT";
	fadeInfo.timeToFade = timeToFade;
	fadeInfo.startAlpha = startAlpha;
	fadeInfo.endAlpha = endAlpha;
	asUIFrameFade(frame, fadeInfo);
end

local KnownSpellList = {};
local ItemSlotList = {};
local showlist_id = {};

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

local function scanSpells(tab)

	local tabName, tabTexture, tabOffset, numEntries = GetSpellTabInfo(tab)

	if not tabName then
		return;
	end

	for i=tabOffset + 1, tabOffset + numEntries do
		local spellName, _, spellID = GetSpellBookItemName (i, BOOKTYPE_SPELL)
		if not spellName then
			do break end
		end

		if spellID then
			KnownSpellList[spellID] = 1;
		end
	end
end


local function scanPetSpells()

	for i = 1, 20 do
	   	local slot = i + (SPELLS_PER_PAGE * (SPELLBOOK_PAGENUMBERS[BOOKTYPE_PET] - 1));
	   	local spellName, _, spellID = GetSpellBookItemName (slot, BOOKTYPE_PET)

		if not spellName then
			do break end
		end

		if spellID then
			KnownSpellList[spellID] = 2;
		end
	end

end

local function scanActionSlots()

	for lActionSlot = 1, 120 do
		local type, id, subType, spellID = GetActionInfo(lActionSlot);
		local itemid = nil;


		if id and type and type == "macro" then
			 id = GetMacroSpell(id);
		end

		if type and type == "item" then
			itemid = id;
			 _, id = GetItemSpell(id);
		end

		if id then
			if itemid then
				KnownSpellList[id] = itemid;
			elseif KnownSpellList[id] == nil then
				KnownSpellList[id] = 1;
			end
		end
	end

	for i=1, NUM_PET_ACTION_SLOTS, 1 do
		local name, texture, isToken, isActive, autoCastAllowed, autoCastEnabled, spellID = GetPetActionInfo(i);
		if spellID and KnownSpellList[spellID] == nil then
			KnownSpellList[spellID] = 2;
		end
	end

end

local function scanItemSlots()

	for i =1,#itemslots do

		local idx = GetInventorySlotInfo(itemslots[i]);
		local itemid = GetInventoryItemID("player",idx)

		if itemid then
			local  _, id = GetItemSpell(itemid);
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
	table.wipe(showlist_id);

	scanSpells(1)
	scanSpells(2)
	scanSpells(3)
	scanPetSpells()
	scanItemSlots();
	scanActionSlots();
end

local function ACDP_UpdateCoolAnchor(frames, index, anchorIndex, size, offsetX, right, parent)

	local cool = frames[index];
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
		cool:SetPoint(point1, frames[index-1], point3, offsetX, 0);
	end
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

local function Comparison(AIndex, BIndex)
	local AID = AIndex[1];
	local BID = BIndex[1];

	if (AID ~= BID) then
		return AID < BID;
	end

	return false;
end


local function ACDP_UpdateCooldown()

	local numCools = 1;
	local frame;
	local frameIcon, frameCooldown;
	local frameBorder;
	local parent;
	local showlist = {};

	parent = ACDP_CoolButtons;

	if parent and parent.frames == nil then
		parent.frames = {};
	end

	if (ACDP_Show_CoolList == false) then

		for i = 1, ACDP_CooldownCount do
			frame = parent.frames[i];

			if ( frame ) then
				frame:Hide();
			end
		end

		return;
	end


	for spellid, type in pairs(showlist_id) do
		local skip = false;
		local name, icon, duration, start;

		if ACI_SpellID_list and ACI_SpellID_list[spellid] then
			skip = true;
		end

		if (type == 1 or type == 2) then
			name, _, icon = GetSpellInfo(spellid);
			if APB_SPELL and APB_SPELL == name then
				skip = true;
			end

			if APB_SPELL2 and APB_SPELL2 == name then
				skip = true;
			end

			if ACI_SpellID_list and ACI_SpellID_list[name] then
				skip = true;
			end
		end

		if skip == false then

			if (type == 1 or type == 2) then
				name, _, icon = GetSpellInfo(spellid);
				start, duration = GetSpellCooldown(spellid);
			else
				name, _, _, _, _, _, _, _, _, icon = GetItemInfo(type)
				start, duration = GetItemCooldown(type);
			end

			if (icon and duration > 0) and skip == false then
				local currtime = GetTime();
				tinsert(showlist, {start+duration -currtime, start, duration, icon} );
			end
		end
	end

	table.sort(showlist, Comparison);

	numCools = 1;

	for i = 1, #showlist do

		local start = showlist[i][2];
		local duration = showlist[i][3];
		local icon = showlist[i][4];

		frame = parent.frames[i];

		if ( not frame ) then
			parent.frames[i] = CreateFrame("Button", nil, parent, "asCooldownPulseFrameTemplate");
			frame = parent.frames[i];
			frame:SetWidth(ACDP_SIZE);
			frame:SetHeight(ACDP_SIZE * 0.9);
			frame:EnableMouse(false);
			frame:Disable();

			for _,r in next,{frame.cooldown:GetRegions()}	do
				if r:GetObjectType()=="FontString" then
					r:SetFont("Fonts\\2002.TTF",ACDP_CooldownFontSize,"OUTLINE")
					break
				end
			end

			frame.icon:SetTexCoord(.08, .92, .08, .92);
			frame.border:SetTexture("Interface\\Addons\\asCooldownPulse\\border.tga");
			frame.border:SetTexCoord(0.08,0.08, 0.08,0.92, 0.92,0.08, 0.92,0.92);

		end
		-- set the icon
		frameIcon = frame.icon;
		frameIcon:SetTexture(icon);
		frameIcon:SetAlpha(ACDP_ALPHA);
		frameIcon:SetDesaturated(ACDP_GreyColor)

		frameBorder = frame.border;
		frameBorder:SetVertexColor(0, 0, 0);
		frameBorder:Show();


		-- set the count
		frameCooldown = frame.cooldown;
		frameCooldown:Show();
		asCooldownFrame_Set(frameCooldown, start, duration, duration > 0, true);
		frameCooldown:SetHideCountdownNumbers(false);
		frame:ClearAllPoints();
		frame:Show();


		numCools = numCools + 1;

		if numCools > ACDP_CooldownCount then
			break;
		end

	end

	for i=1, numCools - 1 do
		-- anchor the current aura
		ACDP_UpdateCoolAnchor(parent.frames, i, i- 1, ACDP_SIZE, 1, true, parent);
	end

	-- 이후 전에 보였던 frame을 지운다.
	for i = numCools, prev_cnt do

		frame = parent.frames[i];

		if ( frame ) then
			frame:Hide();
		end
	end

	prev_cnt = numCools;
end


local ACDP_Icon_Idx = 1;



local function ACDP_Alert(spell, type)

	if type == 1 or type == 2 then
		local name,_,icon,_,_,_,_,_,_ = GetSpellInfo(spell)
		ACDP_Icon[ACDP_Icon_Idx]:SetTexture(icon)
		if CONFIG_SOUND and name then
            PlaySoundFile("Interface\\AddOns\\asCooldownPulse\\SpellSound\\".. name.. ".mp3", "DIALOG")
        end
	else
		local name, _, _, _, _, _, _, _, _, icon = GetItemInfo(spell)
		ACDP_Icon[ACDP_Icon_Idx]:SetTexture(icon)

		if CONFIG_SOUND and name then

            PlaySoundFile("Interface\\AddOns\\asCooldownPulse\\SpellSound\\".. name.. ".mp3")

			if ItemSlotList[spell] then
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
		ACDP[i]:SetPoint("CENTER", ACDP_AlertButtons_X, ACDP_AlertButtons_Y)


		ACDP[i]:SetWidth(ACDP_AlertButtons_Size)
		ACDP[i]:SetHeight(ACDP_AlertButtons_Size * 0.9)
		ACDP[i]:SetScale(1)
		ACDP[i]:SetAlpha(0)
		ACDP[i]:SetFrameStrata("LOW")
		ACDP[i]:EnableMouse(false);
		ACDP[i]:Show()


		ACDP_Icon[i] = ACDP[i]:CreateTexture(nil, "BACKGROUND")
		ACDP_Icon[i]:SetTexture("")
		ACDP_Icon[i]:ClearAllPoints()
		ACDP_Icon[i]:SetAllPoints(ACDP[i])
		ACDP_Icon[i]:SetTexCoord(.08, .92, .08, .92);
		ACDP_Icon[i]:Show()

		i = i + 1;
	end
	ACDP_CoolButtons = CreateFrame("Frame", nil, UIParent)

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

local function ACDP_Checkcooldown()

	for spellid, type in pairs(KnownSpellList) do
		local start, duration, enabled;
		local check_duration = CONFIG_MINCOOL;
	
		if type == 2 then
			check_duration = CONFIG_MINCOOL_PET;
		end

		if type == 1 or type == 2 then
			start, duration, enabled = GetSpellCooldown(spellid);
		else
			--print(spellid);
			start, duration, enabled = GetItemCooldown(type);
			--print (duration);
		end

		local _, gcd  = GetSpellCooldown(61304);
		local currtime = GetTime();

		if start and start > 0 and duration then
			local remain = start + duration - currtime;
			if (remain <= gcd or remain <= ACDP_Alert_Time) and showlist_id[spellid] ~= nil then
				showlist_id[spellid] = nil;
				ACDP_Alert(spellid, type);
			elseif remain >= (check_duration - ACDP_UpdateRate) and duration >= check_duration and duration <= CONFIG_MAXCOOL and showlist_id[spellid] == nil then
				showlist_id[spellid] = type;
			
			elseif duration > CONFIG_MAXCOOL then
				-- remove from KnownSpellList
			end
		elseif start and start == 0 and showlist_id[spellid] ~= nil then
			showlist_id[spellid] = nil;
			ACDP_Alert(spellid, type);
		end

	end
end


local function ACDP_OnUpdate()
	ACDP_Checkcooldown();
	ACDP_UpdateCooldown();

end

local function ACDP_OnEvent(self, event)

	if event == "PLAYER_ENTERING_WORLD" then
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
		scanSpells(1);
		scanSpells(2);
		scanSpells(3);
	elseif event == "UNIT_PET" then
		scanPetSpells();
	elseif event == "ACTIONBAR_SLOT_CHANGED" then
		scanActionSlots();
	elseif event == "PLAYER_EQUIPMENT_CHANGED" then
		scanItemSlots();
	end

	return;
end

ACDP_mainframe = CreateFrame("Frame", nil, UIParent)
ACDP_mainframe:SetScript("OnEvent", ACDP_OnEvent)
ACDP_mainframe:RegisterEvent("PLAYER_ENTERING_WORLD")
ACDP_mainframe:RegisterEvent("PLAYER_REGEN_DISABLED")
ACDP_mainframe:RegisterEvent("PLAYER_REGEN_ENABLED")
ACDP_mainframe:RegisterEvent("SPELLS_CHANGED")
ACDP_mainframe:RegisterUnitEvent("UNIT_PET", "player")
ACDP_mainframe:RegisterEvent("ACTIONBAR_SLOT_CHANGED")
ACDP_mainframe:RegisterEvent("PLAYER_EQUIPMENT_CHANGED")

ACDP_Init()
C_Timer.NewTicker(ACDP_UpdateRate, ACDP_OnUpdate);