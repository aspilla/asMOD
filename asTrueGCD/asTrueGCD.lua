-----------------설정 ------------------------
local ATGCD_X = 56;
local ATGCD_Y = -350;
local AGCICON = 25;


local AGCD_BlackList = {
	["자동 사격"] = 1,
	["자동 공격"] = 1,
	[240022] = 1,
}

local GetItemInfo = C_Item and C_Item.GetItemInfo or GetItemInfo;
local GetItemSpell = C_Item and C_Item.GetItemSpell or GetItemSpell;

local KnownSpellList = {};

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
		return spellInfo.name, nil, spellInfo.iconID, spellInfo.castTime, spellInfo.minRange, spellInfo.maxRange, spellInfo.spellID, spellInfo.originalIconID;
	end
end

local asGetSpellTabInfo = function(index)
	local skillLineInfo = C_SpellBook.GetSpellBookSkillLineInfo(index);
	if skillLineInfo then
		return	skillLineInfo.name, 
				skillLineInfo.iconID, 
				skillLineInfo.itemIndexOffset, 
				skillLineInfo.numSpellBookItems, 
				skillLineInfo.isGuild, 
				skillLineInfo.offSpecID,
				skillLineInfo.shouldHide,
				skillLineInfo.specID;
	end
end



local function scanSpells(tab)
	local tabName, tabTexture, tabOffset, numEntries = asGetSpellTabInfo(tab)

	if not tabName then
		return;
	end

	for i = tabOffset + 1, tabOffset + numEntries do
		local spellName = C_SpellBook.GetSpellBookItemName(i, Enum.SpellBookSpellBank.Player)

		if not spellName then
			do break end
		end

		local slotType, actionID, spellID  = C_SpellBook.GetSpellBookItemType(i, Enum.SpellBookSpellBank.Player);

		if (slotType == Enum.SpellBookItemType.Flyout) then
			local _, _, numSlots = GetFlyoutInfo(actionID);
			for j = 1, numSlots do
				local flyoutSpellID = GetFlyoutSlotInfo(actionID, j);

				if flyoutSpellID  and IsPlayerSpell(flyoutSpellID) then
					KnownSpellList[flyoutSpellID] = 1;
				end
			end
		else
			if spellID and IsPlayerSpell(spellID) then
				KnownSpellList[spellID] = 1;
			end
		end
	end
end


local function scanPetSpells()
	for i = 1, 20 do
		local spellName, _, spellID = C_SpellBook.GetSpellBookItemName(i, Enum.SpellBookSpellBank.Pet);

		if not spellName then
			do break end
		end		

		if spellID then
			KnownSpellList[spellID] = 1;
		end
	end
end

local function scanActionSlots()
	for lActionSlot = 1, 180 do
		local type, id, subType, spellID = GetActionInfo(lActionSlot);
		local itemid = nil;


		if id and type and type == "macro" then
			id = id;
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


	for i = 1, NUM_PET_ACTION_SLOTS, 1 do
		local name, texture, isToken, isActive, autoCastAllowed, autoCastEnabled, spellID = GetPetActionInfo(i);

		if spellID then
			KnownSpellList[spellID] = 1;
		end
	end
end

local function scanItemSlots()
	for _, v in pairs(itemslots) do
		local idx = GetInventorySlotInfo(v);

		local itemid = GetInventoryItemID("player", idx)

		if itemid then
			local _, id = GetItemSpell(itemid);
			if id then
				KnownSpellList[id] = itemid;
			end
		end
	end
end


local ATGCD = CreateFrame("FRAME", nil, UIParent)
ATGCD:SetPoint("BOTTOM", UIParent, "BOTTOM", 0, 0)
ATGCD:SetWidth(0)
ATGCD:SetHeight(0)
ATGCD:Show();


ATGCD.frame = {};
ATGCD.icontime = {};
for i = 0, 3 do
	ATGCD.frame[i] = CreateFrame("Button", nil, UIParent, "ATGCDFrameTemplate");

	if i == 0 then
		ATGCD.frame[i]:SetPoint("CENTER", UIParent, "CENTER", ATGCD_X, ATGCD_Y)
	else
		ATGCD.frame[i]:SetPoint("BOTTOMRIGHT", ATGCD.frame[i - 1], "BOTTOMLEFT", -1, 0);
	end


	ATGCD.frame[i]:SetWidth(AGCICON);
	ATGCD.frame[i]:SetHeight(AGCICON * 0.9);
	ATGCD.frame[i]:SetScale(1);
	ATGCD.frame[i]:SetAlpha(1);
	ATGCD.frame[i]:EnableMouse(false);
	ATGCD.frame[i].icon:SetTexCoord(.08, .92, .08, .92);
	ATGCD.frame[i].border:SetTexCoord(0.08, 0.08, 0.08, 0.92, 0.92, 0.08, 0.92, 0.92);
	ATGCD.frame[i].border:SetVertexColor(0, 0, 0);
	ATGCD.frame[i].border:Show();
	ATGCD.frame[i]:Hide();
end


ATGCD.frame[0]:SetWidth(AGCICON * 1.3);
ATGCD.frame[0]:SetHeight(AGCICON * 1.3 * 0.9);
ATGCD.frame[0].icon:Hide();
ATGCD.frame[0]:Hide();

local bloaded = C_AddOns.LoadAddOn("asMOD")
if bloaded and asMOD_setupFrame then
	asMOD_setupFrame(ATGCD.frame[0], "asTrueGCD");	
end


local prev_spell = nil;
local prev_spell_time = nil;
local prev_spell_id = nil;
local seq_spell_count = 0;


local function ATGCD_Alert(spellid, bcancel, bitem)
	if spellid == nil then
		--ATGCD.icon:Hide();
		return
	end

	if AGCD_BlackList[spellid] then
		return;
	end

	if spellid == prev_spell_id and not bcancel then
		seq_spell_count = seq_spell_count + 1;
	elseif not bcancel then
		prev_spell_id = spellid;
		seq_spell_count = 0;
	end

	local name, discard, icon = asGetSpellInfo(spellid)

	if bitem then
		local itemName, itemLink, itemRarity, itemLevel, itemMinLevel, itemType, itemSubType, itemStackCount, itemEquipLoc, iconFileDataID, itemSellPrice, itemClassID, itemSubClassID, bindType, expacID, itemSetID, isCraftingReagent =
			GetItemInfo(spellid);
		name = itemName
		icon = iconFileDataID
	end


	if icon == nil then
		--ATGCD.icon:Hide();
		return;
	elseif icon == 136243 then
		return;
	end

	if AGCD_BlackList[name] then
		return;
	end


	local current = GetTime();

	for i = 1, 3 do
		local frame = ATGCD.frame[4 - i];
		local frameIcon = frame.icon;
		local frameborder = frame.border;
		local frameCancel = frame.text;

		if i == 3 then
			-- set the icon
			frameIcon:SetTexture(icon);
			frameIcon:Show();
			frame:Show();
			ATGCD.icontime[4 - i] = GetTime();

			if bcancel then
				frameCancel:SetText("X");
				frameCancel:SetTextColor(1, 0, 0);
				frameCancel:Show();
			elseif seq_spell_count > 0 then
				frameCancel:SetText(seq_spell_count + 1);
				frameCancel:SetTextColor(1, 1, 1);
				frameCancel:Show();
			else
				frameCancel:SetText("");
				frameCancel:Hide();
			end
		else
			local frameIcon2 = ATGCD.frame[(4 - i - 1)].icon
			local icon2 = frameIcon2:GetTexture()
			local time2 = ATGCD.icontime[4 - i - 1];
			local frameCancel2 = ATGCD.frame[(4 - i - 1)].text;

			if icon2 then
				if time2 and current - time2 > 5 then
					ATGCD.icontime[4 - i] = nil;
					frameCancel:Hide();
					frame:Hide();
				elseif time2 then
					frameIcon:SetTexture(icon2);
					local prev_text = frameCancel2:GetText();
					--frameborder:Hide();
					if frameCancel2:IsShown() and prev_text == "X" then
						frameCancel:SetText("X");
						frameCancel:SetTextColor(1, 0, 0);
						frameCancel:Show();
					elseif frameCancel2:IsShown() then
						frameCancel:SetText(prev_text);
						frameCancel:SetTextColor(1, 1, 1);
						frameCancel:Show();
					else
						frameCancel:Hide();
					end
					frame:Show();
					ATGCD.icontime[4 - i] = time2;
				else
					ATGCD.icontime[4 - i] = nil;
					frameCancel:Hide();
					frame:Hide();
				end
			else
				ATGCD.icontime[4 - i] = nil;
				frameCancel:Hide();
				frame:Hide();
			end
		end
	end
	return;
end


local function ATGCD_OnUpdate()
	local current = GetTime();
	for i = 1, 3 do
		if ATGCD.icontime[i] and current - ATGCD.icontime[i] > 5 then
			ATGCD.frame[i]:Hide();
			local frameCancel = ATGCD.frame[i].text;
			frameCancel:Hide();
		end
	end
end
local interruptprev = nil;
local interrupttime = 0;


local prev = nil;
local prevtime = 0;
local channel_spell = nil;

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

local function ATGCD_OnEvent(self, event, arg1, arg2, arg3, arg4, arg5)
	if (event == "UNIT_SPELLCAST_START") then
		local name, text, texture, startTime, endTime, isTradeSkill, castID, notInterruptible, spellid = UnitCastingInfo(
			"player");
		local frameIcon = ATGCD.frame[0].icon;
		local frameCooldown = ATGCD.frame[0].cooldown;

		if name and frameIcon then
			--if name and frameIcon and isTargetPlayer then
			frameIcon:SetTexture(texture);

			if spellid == prev_spell_id then
				ATGCD.frame[0].text:SetText(seq_spell_count + 2);
				ATGCD.frame[0].text:SetTextColor(1, 1, 1);
				ATGCD.frame[0].text:Show();
			else
				ATGCD.frame[0].text:Hide();
			end
			frameIcon:Show();
			local duration = (endTime - startTime) / 1000;
			endTime = endTime / 1000;
			asCooldownFrame_Set(frameCooldown, endTime - duration, duration, duration > 0, true);
			frameCooldown:SetHideCountdownNumbers(true);
			ATGCD.frame[0]:Show();
		else
			frameIcon:Hide();
			ATGCD.frame[0]:Hide();
		end
	elseif (event == "UNIT_SPELLCAST_CHANNEL_START") then
		local name, text, texture, startTime, endTime, isTradeSkill, notInterruptible, spellid = UnitChannelInfo(
			"player");
		local frameIcon = ATGCD.frame[0].icon;
		local frameCooldown = ATGCD.frame[0].cooldown;

		if name and frameIcon then
			channel_spell = spellid;
			--if name and frameIcon and isTargetPlayer then
			frameIcon:SetTexture(texture);

			if spellid == prev_spell_id then
				ATGCD.frame[0].text:SetText(seq_spell_count + 2);
				ATGCD.frame[0].text:SetTextColor(1, 1, 1);
				ATGCD.frame[0].text:Show();
			else
				ATGCD.frame[0].text:Hide();
			end
			frameIcon:Show();
			local duration = (endTime - startTime) / 1000;
			endTime = endTime / 1000;
			asCooldownFrame_Set(frameCooldown, endTime - duration, duration, duration > 0, true);
			frameCooldown:SetHideCountdownNumbers(true);
			ATGCD.frame[0]:Show();
		else
			frameIcon:Hide();
			ATGCD.frame[0]:Hide();
		end
	elseif event == "UNIT_SPELLCAST_STOP" then
		local name = UnitCastingInfo("player");
		if not name then
			ATGCD.frame[0]:Hide();
		end
	elseif event == "UNIT_SPELLCAST_CHANNEL_STOP" then
		local name = UnitChannelInfo("player");
		if not name then
			channel_spell = nil;
			ATGCD.frame[0]:Hide();
		end
	elseif event == "UNIT_SPELLCAST_SUCCEEDED" and arg1 == "player" then
		prev_spell = arg3;
		local GCDmax = 1.5 / ((GetHaste() / 100) + 1)

		if (prev and prev == prev_spell and (GetTime() - prevtime) < (GCDmax - 0.1)) then

		else
			if KnownSpellList[prev_spell] == 1 then
				prev = prev_spell;
				prevtime = GetTime();
				ATGCD_Alert(prev_spell, nil);
			elseif KnownSpellList[prev_spell] then
				prev = prev_spell;
				prevtime = GetTime();
				ATGCD_Alert(KnownSpellList[prev_spell], nil, true);
			end
		end
	elseif event == "UNIT_SPELLCAST_INTERRUPTED" and arg1 == "player" then
		prev_spell = arg3;

		local GCDmax = 1.5 / ((GetHaste() / 100) + 1)

		if interruptprev and interruptprev == prev_spell and (GetTime() - interrupttime) < (GCDmax - 0.1) then

		else
			if KnownSpellList[prev_spell] == 1 then
				interruptprev = prev_spell;
				interrupttime = GetTime();
				ATGCD_Alert(prev_spell, true);
			elseif KnownSpellList[prev_spell] then
				interruptprev = prev_spell;
				interrupttime = GetTime();
				ATGCD_Alert(KnownSpellList[prev_spell], true, true);
			end
		end
	elseif event == "SPELLS_CHANGED" then
		scanSpells(1);
		scanSpells(2)
		scanSpells(3)

	elseif event == "UNIT_PET" then
		scanPetSpells();
	elseif event == "ACTIONBAR_SLOT_CHANGED" then
		scanActionSlots();
	elseif event == "PLAYER_EQUIPMENT_CHANGED" then
		scanItemSlots();
	end

	return;
end



C_Timer.NewTicker(0.25, ATGCD_OnUpdate);
ATGCD:SetScript("OnEvent", ATGCD_OnEvent)

ATGCD:RegisterUnitEvent("UNIT_SPELLCAST_SUCCEEDED", "player");
ATGCD:RegisterUnitEvent("UNIT_SPELLCAST_INTERRUPTED", "player");
ATGCD:RegisterUnitEvent("UNIT_SPELLCAST_START", "player");
ATGCD:RegisterUnitEvent("UNIT_SPELLCAST_CHANNEL_START", "player");
ATGCD:RegisterUnitEvent("UNIT_SPELLCAST_CHANNEL_STOP", "player");
ATGCD:RegisterUnitEvent("UNIT_SPELLCAST_STOP", "player");
ATGCD:RegisterEvent("SPELLS_CHANGED")
ATGCD:RegisterUnitEvent("UNIT_PET", "player")
ATGCD:RegisterEvent("ACTIONBAR_SLOT_CHANGED")
ATGCD:RegisterEvent("PLAYER_ENTERING_WORLD")
ATGCD:RegisterEvent("PLAYER_EQUIPMENT_CHANGED")
