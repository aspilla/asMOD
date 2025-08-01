﻿local _, ns = ...;

-- 설정 최소 Cooldown (단위 초)
local CONFIG_MINCOOL = 2 -- 최소안내 쿨타임
local CONFIG_MAXCOOL = (60 * 5)
local CONFIG_MINCOOL_PET = 20
local CONFIG_SOUND_SPEED = 1      -- 음성안내 읽기 속도
local ACDP_CoolButtons_X = -98    -- 쿨 List 위치
local ACDP_CoolButtons_Y = -250
local ACDP_AlertButtons_X = 0     -- Alert button 위치
local ACDP_AlertButtons_Y = 0
local ACDP_AlertButtons_Size = 60 -- Alert button size
local ACDP_AlertFadeTime = 1      -- Alert button Fade in-out 시간 짧으면 빨리 사라짐
local ACDP_AlertShowTime = 0.2    -- Alert button Fade in-out 시간 짧으면 빨리 사라짐
local ACDP_SIZE = 32;             -- 쿨 List Size
local ACDP_Alert_Time = 0.7;      -- 쿨 1초전에 알림
local ACDP_ALPHA = 1;
local ACDP_CooldownFontSize = 11; -- Cooldown Font Size 기본 쿨다운 지원
local ACDP_GreyColor = false      -- Color Icon 원하면 false
local ACDP_CooldownCount = 6;     -- 줄당 보일 CooldownCount 개수가 되면 줄을 바꾸어 표시됨 1줄로 보이려면 큰수로 지정
local ACDP_UpdateRate = 0.2;      -- 0.2 초마다 check


local itemslots = {
	"HeadSlot",
	"NeckSlot",
	"ShoulderSlot",
	"BackSlot",
	"ChestSlot",
	"WristSlot",
	"HandsSlot",
	"WaistSlot",
	"LegsSlot",
	"FeetSlot",
	"Finger0Slot",
	"Finger1Slot",
	"Trinket0Slot",
	"Trinket1Slot",
	"MainHandSlot",
	"SecondaryHandSlot",
}

local itemslotNames = {
	"투구",
	"목걸이",
	"어깨",
	"겉옷",
	"가슴",
	"허리",
	"다리",
	"장화",
	"손목",
	"장갑",
	"반지 1",
	"반지 2",
	"장신구 1",
	"장신구 2",
	"등",
	"무기 1",
	"무기 2",
}

local black_list = {
	[125439] = true,

}

local voice_remap = {
	["들이치기"] = "차단쿨다운",
	["발차기"] = "차단쿨다운",
	["분열"] = "차단쿨다운",
	["손날 찌르기"] = "차단쿨다운",
	["정신 얼리기"] = "차단쿨다운",
	["재갈"] = "차단쿨다운",
	["반격의 사격"] = "차단쿨다운",
	["진압"] = "차단쿨다운",
	["두개골 강타"] = "차단쿨다운",
	["침묵"] = "차단쿨다운",
	["비난"] = "차단쿨다운",
	["날카로운 바람"] = "차단쿨다운",
	["마법 차단"] = "차단쿨다운",
	["태양 광선"] = "차단쿨다운",
	["도끼 던지기"] = "차단쿨다운",
	["주문 잠금"] = "차단쿨다운",
	["정화"] = "해제쿨다운",
	["소작의 불길"] = "해제쿨다운",
	["자연화"] = "해제쿨다운",
	["영혼 정화"] = "해제쿨다운",
	["해독"] = "해제쿨다운",
	["해제"] = "해제쿨다운",
	["독소 정화"] = "해제쿨다운",
	["저주 해제"] = "해제쿨다운",
	["자연의 치유력"] = "해제쿨다운",
}

local GetItemInfo = C_Item and C_Item.GetItemInfo;
local GetItemSpell = C_Item and C_Item.GetItemSpell;
local GetItemCooldown = C_Item and C_Item.GetItemCooldown;

local asGetSpellInfo = function(spellID, skip)
	if not spellID then
		return nil;
	end

	if not skip then
		local ospellID = C_Spell.GetOverrideSpell(spellID)

		if ospellID then
			spellID = ospellID;
		end
	end

	local spellInfo = C_Spell.GetSpellInfo(spellID);
	if spellInfo then
		return spellInfo.name, nil, spellInfo.iconID, spellInfo.castTime, spellInfo.minRange, spellInfo.maxRange,
			spellInfo.spellID, spellInfo.originalIconID;
	end
end

local asGetSpellCooldown = function(spellID)
	if not spellID then
		return nil;
	end

	local spellCooldownInfo = C_Spell.GetSpellCooldown(spellID);
	if spellCooldownInfo then
		return spellCooldownInfo.startTime, spellCooldownInfo.duration, spellCooldownInfo.isEnabled,
			spellCooldownInfo.modRate;
	end
end


local asGetSpellTabInfo = function(index)
	local skillLineInfo = C_SpellBook.GetSpellBookSkillLineInfo(index);
	if skillLineInfo then
		return skillLineInfo.name,
			skillLineInfo.iconID,
			skillLineInfo.itemIndexOffset,
			skillLineInfo.numSpellBookItems,
			skillLineInfo.isGuild,
			skillLineInfo.offSpecID,
			skillLineInfo.shouldHide,
			skillLineInfo.specID;
	end
end


local ACDP = {};
local ACDP_Icon = {};
local ACDP_mainframe = CreateFrame("Frame", nil, UIParent);
local ACDP_CoolButtons = CreateFrame("Frame", nil, UIParent);

local KnownSpellList = {};
local ItemSpellList = {};
local SpellIconList = {};
local ItemSlotList = {};
local showlist_id = {};
local spell_cooldown = {};
local item_cooldown = {};
local SPELL_TYPE_USER = 1;
local SPELL_TYPE_PET = 2;

local prev_cnt = 0;
local bCombatInfoLoaded = false;

local function scanSpells(tab)
	local tabName, tabTexture, tabOffset, numEntries = asGetSpellTabInfo(tab)

	if not tabName then
		return;
	end

	for i = tabOffset + 1, tabOffset + numEntries do
		local spellName = C_SpellBook.GetSpellBookItemName(i, Enum.SpellBookSpellBank.Player);

		if not spellName then
			do break end
		end

		local slotType, actionID, spellID = C_SpellBook.GetSpellBookItemType(i, Enum.SpellBookSpellBank.Player);
		local isPassive = C_SpellBook.IsSpellBookItemPassive(i, Enum.SpellBookSpellBank.Player)

		if not isPassive then
			if (slotType == Enum.SpellBookItemType.Flyout) then
				local _, _, numSlots = GetFlyoutInfo(actionID);
				for j = 1, numSlots do
					local flyoutSpellID, _, _, flyoutSpellName, _ = GetFlyoutSlotInfo(actionID, j);

					if flyoutSpellID and not black_list[flyoutSpellID] then
						KnownSpellList[flyoutSpellID] = SPELL_TYPE_USER;
					end
				end
			else
				if spellID and not black_list[spellID] then
					KnownSpellList[spellID] = SPELL_TYPE_USER;
				end
			end
		end
	end
end


local function scanPetSpells()
	for i = 1, 20 do
		local slotType, actionID, spellID = C_SpellBook.GetSpellBookItemType(i, Enum.SpellBookSpellBank.Pet);

		if not spellID then
			break;
		end

		local isPassive = C_SpellBook.IsSpellBookItemPassive(i, Enum.SpellBookSpellBank.Pet)

		if not isPassive then
			if spellID and not black_list[spellID] then
				KnownSpellList[spellID] = SPELL_TYPE_PET;
			end
		end
	end
end

local function scanActionSlots()
	
	if not ns.options.ScanActionSlots then
		return;
	end
	--등록된 item만
	for lActionSlot = 1, 180 do
		local type, id, subType = GetActionInfo(lActionSlot);
		local itemid = nil;
		local spellID = id;

		if id then
			if type and type == "item" then
				itemid = id;
				_, spellID = GetItemSpell(id);
			else
				spellID = 0;
			end

			if spellID and spellID > 0 then
				if itemid then
					ItemSpellList[spellID] = itemid;
				end
			end
		end
	end
end

local function scanItemSlots()
	for _, v in pairs(itemslots) do
		local idx = GetInventorySlotInfo(string.upper(v));
		local itemid = GetInventoryItemID("player", idx)

		if itemid then
			local _, id = GetItemSpell(itemid);
			if id then
				KnownSpellList[id] = itemid;
				ItemSlotList[itemid] = idx;
			end
		end
	end
end

local function scanSpellIcons()
	SpellIconList = {};
	for id, ty in pairs(KnownSpellList) do
		if ty <= 2 then
			local name, _, icon = asGetSpellInfo(id, true);
			SpellIconList[id] = { name, icon };
		end
	end
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

	if (index % ACDP_CooldownCount == 1) then
		cool:SetPoint(point1, parent, point2, 0, offsetY);
	else
		cool:SetPoint(point1, frames[index - 1], point3, offsetX, 0);
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

local function checkASMOD(spellid)
	if ACI_SpellID_list and ACI_SpellID_list[spellid] then
		return 1;
	end
	local name, _, icon = asGetSpellInfo(spellid);
	if APB_SPELL then
		local newspell = asGetSpellInfo(APB_SPELL)
		if name == newspell then
			return 2;
		end
	end

	if APB_SPELL2 then
		local newspell = asGetSpellInfo(APB_SPELL2)
		if name == newspell then
			return 2;
		end
	end

	if ACI_SpellID_list and ACI_SpellID_list[name] then
		return 1;
	end


	return 0;
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

	if ns.options.AlwaysShowButtons ~= true and (bCombatInfoLoaded == false or (bCombatInfoLoaded == true and ACI_HideCooldownPulse ~= nil and ACI_HideCooldownPulse == true)) then
		for i = 1, ACDP_CooldownCount do
			frame = parent.frames[i];

			if (frame) then
				frame:Hide();
			end
		end

		return;
	end


	for spellid, type in pairs(showlist_id) do
		local skip = checkASMOD(spellid);
		local name, icon, duration, start;

		if skip == 0 then
			if (type == SPELL_TYPE_USER or type == SPELL_TYPE_PET) then
				local info = SpellIconList[spellid];
				if info == nil then
					name, _, icon = asGetSpellInfo(spellid, true);
				else
					name, icon = info[1], info[2];
				end
				start, duration = asGetSpellCooldown(spellid);
			else
				local itemid = type;
				name, _, _, _, _, _, _, _, _, icon = GetItemInfo(itemid)
				start, duration = GetItemCooldown(itemid);
			end

			if (icon and duration > 0) and skip == 0 then
				local currtime = GetTime();
				tinsert(showlist, { start + duration - currtime, start, duration, icon, spellid, type });
			end
		end
	end

	table.sort(showlist, Comparison);

	numCools = 1;

	local prev_icon;

	for _, v in pairs(showlist) do
		local start = v[2];
		local duration = v[3];
		local icon = v[4];
		local spellid = v[5];
		local type = v[6];

		if not (icon == prev_icon) then
			prev_icon = icon;

			frame = parent.frames[numCools];

			if (not frame) then
				parent.frames[numCools] = CreateFrame("Button", nil, parent, "asCooldownPulseFrameTemplate");
				frame = parent.frames[numCools];
				frame:SetWidth(ACDP_SIZE);
				frame:SetHeight(ACDP_SIZE * 0.9);
				frame:EnableMouse(false);
				frame:SetMouseMotionEnabled();

				for _, r in next, { frame.cooldown:GetRegions() } do
					if r:GetObjectType() == "FontString" then
						r:SetFont(STANDARD_TEXT_FONT, ACDP_CooldownFontSize, "OUTLINE")
						frame.cooldowntext = r;
						r:SetDrawLayer("OVERLAY");
						break;
					end
				end

				frame.icon:SetTexCoord(.08, .92, .08, .92);
				frame.border:SetTexCoord(0.08, 0.08, 0.08, 0.92, 0.92, 0.08, 0.92, 0.92);

				if not frame:GetScript("OnEnter") then
					frame:SetScript("OnEnter", function(s)
						if s.spellid and s.spellid > 0 then
							GameTooltip_SetDefaultAnchor(GameTooltip, s);
							GameTooltip:SetSpellByID(s.spellid);
						elseif s.itemid and s.itemid > 0 then
							GameTooltip_SetDefaultAnchor(GameTooltip, s);
							GameTooltip:SetItemByID(s.itemid);
						end
					end)
					frame:SetScript("OnLeave", function()
						GameTooltip:Hide();
					end)
				end
				frame:EnableMouse(false);
				frame:SetMouseMotionEnabled(true);
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
			local remain = start + duration - GetTime();
			asCooldownFrame_Set(frameCooldown, start, duration, duration > 0, true);
			frameCooldown:SetHideCountdownNumbers(false);

			if remain < 5 then
				frame.cooldowntext:SetTextColor(1, 0.3, 0.3);
				frame.cooldowntext:SetFont(STANDARD_TEXT_FONT, ACDP_CooldownFontSize + 3, "OUTLINE")
			elseif remain < 10 then
				frame.cooldowntext:SetTextColor(1, 1, 0.3);
				frame.cooldowntext:SetFont(STANDARD_TEXT_FONT, ACDP_CooldownFontSize + 1, "OUTLINE")
			else
				frame.cooldowntext:SetTextColor(0.8, 0.8, 1);
				frame.cooldowntext:SetFont(STANDARD_TEXT_FONT, ACDP_CooldownFontSize, "OUTLINE")
			end

			frame:ClearAllPoints();

			if type == SPELL_TYPE_USER or type == SPELL_TYPE_PET then
				frame.spellid = spellid;
				frame.itemid = 0;
			else
				frame.spellid = 0;
				frame.itemid = type;
			end

			frame:Show();

			numCools = numCools + 1;

			if numCools > ACDP_CooldownCount then
				break;
			end
		end
	end

	for i = 1, numCools - 1 do
		-- anchor the current aura
		ACDP_UpdateCoolAnchor(parent.frames, i, i - 1, ACDP_SIZE, 1, true, parent);
	end

	-- 이후 전에 보였던 frame을 지운다.
	for i = numCools, prev_cnt do
		frame = parent.frames[i];

		if (frame) then
			frame:Hide();
		end
	end

	prev_cnt = numCools;
end


local ACDP_Icon_Idx = 1;


local alert_start = {};
local voicealert_start = {};

local function ACDP_Alert(spell, type)
	local currtime = GetTime();
	local bsound = false;
	local name, _, icon;

	if not (alert_start[spell] == nil or (currtime > alert_start[spell])) then
		return;
	end

	alert_start[spell] = currtime + 1.6;

	if type == SPELL_TYPE_USER or type == SPELL_TYPE_PET then
		local info = SpellIconList[spell];
		if info == nil then
			name, _, icon = asGetSpellInfo(spell, true);
		else
			name, icon = info[1], info[2];
		end

		ACDP_Icon[ACDP_Icon_Idx]:SetTexture(icon)

		if voice_remap[name] then
			name = voice_remap[name];
			bsound = true;
		end
		--print(name);
		if ns.options.PlaySound and name then
			if ns.options.Aware_ASMOD_Cooldown and bCombatInfoLoaded then
				local asmodtype = checkASMOD(spell)
				if ns.options.Aware_PowerBar and asmodtype == 2 then --PowerBar Spell
					bsound = false;
				elseif asmodtype == 1 then
					if (spell_cooldown[spell] and spell_cooldown[spell] >= ns.options.SoundCooldown) then
						bsound = true;
					end
				else
					if (spell_cooldown[spell] and spell_cooldown[spell] >= ns.options.Aware_ASMOD_Cooldown) then
						bsound = true;
					end
				end
			else
				if (spell_cooldown[spell] and spell_cooldown[spell] >= ns.options.SoundCooldown) then
					bsound = true;
				end
			end
		end
	else
		name, _, _, _, _, _, _, _, _, icon = GetItemInfo(type)
		ACDP_Icon[ACDP_Icon_Idx]:SetTexture(icon)

		if ns.options.PlaySound and name then
			if item_cooldown[type] and item_cooldown[type] >= ns.options.SoundCooldown then
				bsound = true;
				if (not ns.options.EnableTTS or ns.options.SlotNameTTS) and ItemSlotList[type] then
					name = ItemSlotList[type];
				end
			end
		end
	end

	if bsound and name and (voicealert_start[name] == nil or voicealert_start[name] < currtime) then
		--3초간 금지
		voicealert_start[name] = currtime + 3;
		if ns.options.EnableTTS then
			if ns.options.SlotNameTTS and itemslotNames[name] then
				name = itemslotNames[name];
			end

			C_VoiceChat.SpeakText(ns.options.TTS_ID, name, Enum.VoiceTtsDestination.LocalPlayback, CONFIG_SOUND_SPEED,
				ns.options.SoundVolume);
		else
			PlaySoundFile("Interface\\AddOns\\asCooldownPulse\\SpellSound\\" .. name .. ".mp3", "MASTER")
		end
	end

	ns.asUIFrameFadeIn(ACDP[ACDP_Icon_Idx], ACDP_AlertShowTime, 0, 1)
	ns.asUIFrameFadeOut(ACDP[ACDP_Icon_Idx], ACDP_AlertFadeTime, 1, 0)

	ACDP_Icon_Idx = ACDP_Icon_Idx + 1;

	if ACDP_Icon_Idx > 10 then
		ACDP_Icon_Idx = 1;
	end

	return;
end


local function GetMinRuneCooldown()
	local _, englishClass = UnitClass("player")

	if englishClass == "DEATHKNIGHT" then
		for index = 1, 6 do
			local start, duration = GetRuneCooldown(index);
			if start > 0 then
				return duration;
			end
		end
	elseif englishClass == "EVOKER" then
		local peace = GetPowerRegenForPowerType(Enum.PowerType.Essence)
		if (peace == nil or peace == 0) then
			peace = 0.2;
		end
		return 1 / peace;
	end

	return 0;
end


local function ACDP_Checkcooldown()
	local _, gcd = asGetSpellCooldown(61304);

	local lc_data = C_LossOfControl.GetActiveLossOfControlData(LOSS_OF_CONTROL_ACTIVE_INDEX);
	local lc_duration = 0;
	if lc_data then
		lc_duration = lc_data.duration;
	end
	for spellid, type in pairs(KnownSpellList) do
		local start, duration;
		local check_duration = CONFIG_MINCOOL;

		if type == 2 then
			check_duration = CONFIG_MINCOOL_PET;
		end

		if type == SPELL_TYPE_USER or type == SPELL_TYPE_PET then
			start, duration = asGetSpellCooldown(spellid);
		else
			start, duration = GetItemCooldown(type);
		end

		local currtime = GetTime();

		if start and start > 0 and duration then
			local remain = start + duration - currtime;

			if duration > check_duration and duration <= CONFIG_MAXCOOL and (lc_duration == 0 or duration ~= lc_duration) then
				if showlist_id[spellid] == nil then
					local runeduration = GetMinRuneCooldown()


					if remain <= duration and (runeduration == 0 or (math.abs(runeduration - duration) > 0.1 and math.abs(duration % runeduration) > 0.1)) then
						showlist_id[spellid] = type;

						if type == SPELL_TYPE_USER or type == SPELL_TYPE_PET then
							spell_cooldown[spellid] = duration;
							--print (runeduration)
							--print(duration)
						else
							item_cooldown[type] = duration;
						end
					end
					--print("등록")
				end
			end

			if (remain <= gcd or remain <= ACDP_Alert_Time) then
				if showlist_id[spellid] and showlist_id[spellid] == type then
					showlist_id[spellid] = nil;
					ACDP_Alert(spellid, type);
					--print("해제1")
				end
			end
		elseif start and start == 0 then
			if showlist_id[spellid] and showlist_id[spellid] == type then
				showlist_id[spellid] = nil;
				ACDP_Alert(spellid, type);
				--print("해제2".. asGetSpellInfo(spellid));
			end
		end
	end
end


local function ACDP_OnUpdate()
	ACDP_Checkcooldown();
end

local function ACDP_OnUpdate2()
	ACDP_UpdateCooldown();
end


local timer;
local timer2;

local function setupKnownSpell()
	if timer then
		timer:Cancel();
	end
	if timer2 then
		timer2:Cancel();
	end

	KnownSpellList = {};
	ItemSpellList = {};
	ItemSlotList = {};
	showlist_id = {};
	spell_cooldown = {};
	item_cooldown = {};


	scanSpells(1);
	scanSpells(2)
	scanSpells(3)

	scanPetSpells();
	scanItemSlots();
	scanActionSlots();
	scanSpellIcons();

	--print("초기화")
	timer = C_Timer.NewTicker(ACDP_UpdateRate * 2, ACDP_OnUpdate);
	timer2 = C_Timer.NewTicker(ACDP_UpdateRate, ACDP_OnUpdate2);
end

local bfirst = true;

local function ACDP_OnEvent(self, event, ...)
	if bfirst then
		ns.SetupOptionPanels();
		bfirst = false;
	end

	if event == "UNIT_SPELLCAST_SUCCEEDED" then
		local _, _, spellid = ...;
		if spellid then
			local itemid = ItemSpellList[spellid];

			if itemid and itemid > 0 then
				KnownSpellList[spellid] = itemid;
			end
		end
	elseif event == "PLAYER_ENTERING_WORLD" then
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
	elseif event == "UNIT_PET" then
		scanPetSpells();
	elseif event == "PLAYER_EQUIPMENT_CHANGED" then
		setupKnownSpell();
	elseif event == "TRAIT_CONFIG_UPDATED" or event == "TRAIT_CONFIG_LIST_UPDATED" or event == "ACTIVE_TALENT_GROUP_CHANGED" then
		C_Timer.After(0.5, setupKnownSpell);
	end

	return;
end

local function ACDP_Init()
	local i = 1;

	while (i <= 10) do
		ACDP[i] = CreateFrame("Frame", nil, UIParent)
		if i == 1 then
			ACDP[i]:SetPoint("CENTER", ACDP_AlertButtons_X, ACDP_AlertButtons_Y);
		else
			ACDP[i]:SetPoint("CENTER", ACDP[i - 1], "CENTER", 0, 0);
		end


		ACDP[i]:SetWidth(ACDP_AlertButtons_Size)
		ACDP[i]:SetHeight(ACDP_AlertButtons_Size * 0.9)
		ACDP[i]:SetScale(1)
		ACDP[i]:SetAlpha(0)
		ACDP[i]:SetFrameStrata("LOW")
		ACDP[i]:EnableMouse(false);
		ACDP[i]:Show();

		ACDP_Icon[i] = ACDP[i]:CreateTexture(nil, "BACKGROUND")
		ACDP_Icon[i]:SetTexture("")
		ACDP_Icon[i]:ClearAllPoints()
		ACDP_Icon[i]:SetAllPoints(ACDP[i])
		ACDP_Icon[i]:SetTexCoord(.08, .92, .08, .92);
		ACDP_Icon[i]:Show()

		i = i + 1;
	end

	ACDP_CoolButtons:SetPoint("CENTER", ACDP_CoolButtons_X, ACDP_CoolButtons_Y)

	ACDP_CoolButtons:SetWidth(1)
	ACDP_CoolButtons:SetHeight(1)
	ACDP_CoolButtons:SetScale(1)
	ACDP_CoolButtons:SetFrameStrata("LOW")
	ACDP_CoolButtons:Show()

	C_AddOns.LoadAddOn("asMOD");

	if asMOD_setupFrame then
		asMOD_setupFrame(ACDP_CoolButtons, "asCooldownPulselist");
		asMOD_setupFrame(ACDP[1], "asCooldownAlertButton");
	end

	bCombatInfoLoaded = C_AddOns.LoadAddOn("asCombatInfo") or false;

	ACDP_mainframe:SetScript("OnEvent", ACDP_OnEvent)
	ACDP_mainframe:RegisterEvent("PLAYER_ENTERING_WORLD")
	ACDP_mainframe:RegisterEvent("PLAYER_REGEN_DISABLED")
	ACDP_mainframe:RegisterEvent("PLAYER_REGEN_ENABLED")
	ACDP_mainframe:RegisterUnitEvent("UNIT_PET", "player")
	ACDP_mainframe:RegisterEvent("PLAYER_EQUIPMENT_CHANGED")
	ACDP_mainframe:RegisterEvent("TRAIT_CONFIG_UPDATED")
	ACDP_mainframe:RegisterEvent("TRAIT_CONFIG_LIST_UPDATED")
	ACDP_mainframe:RegisterEvent("ACTIVE_TALENT_GROUP_CHANGED")
	ACDP_mainframe:RegisterUnitEvent("UNIT_SPELLCAST_SUCCEEDED", "player")
end


ACDP_Init()
