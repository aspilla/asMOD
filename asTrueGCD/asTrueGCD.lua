-----------------설정 ------------------------
local ATGCD_X = 56;
local ATGCD_Y = -350;
local AGCICON = 25;


local AGCD_BlackList = {
	[75] = 1,
	[6603] = 1,
	[240022] = 1,
	[467718] = 1,
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

	ATGCD.frame[i].count:SetFont(STANDARD_TEXT_FONT, 16, "OUTLINE");
    ATGCD.frame[i].count:ClearAllPoints();
    ATGCD.frame[i].count:SetPoint("CENTER", ATGCD.frame[i], "CENTER", 0, 0);

	ATGCD.frame[i].text:SetFont(STANDARD_TEXT_FONT, 16, "OUTLINE");
    ATGCD.frame[i].text:ClearAllPoints();
    ATGCD.frame[i].text:SetPoint("CENTER", ATGCD.frame[i], "CENTER", 0, 0);
    
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


local prev_spell_time = nil;
local prev_spell_id = nil;
local seq_spell_count = 0;
local icons = {};
local texts = {};
local spells = {};

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
		icon = select(10, GetItemInfo(spellid));
	end


	if icon == nil then
		return;
	elseif icon == 136243 then
		return;
	end

	local current = GetTime();

	if #spells > 3 then
		table.remove(spells, 4);
	end

	table.insert(spells, 1, { icon, seq_spell_count, bcancel, current });

	return;
end


local function ATGCD_OnUpdate()
	local current = GetTime();

	for i = 1, 3 do
		local spell = spells[4 - i];
		local frame = ATGCD.frame[4 - i];

		if spell then
			if spell[4] and current - spell[4] > 5 then
				frame:Hide();
			else
				frame.icon:SetTexture(spell[1]);
				frame:Show();

				if spell[3] then
					frame.text:SetText("X");
					frame.text:SetTextColor(1, 0, 0);
				elseif spell[2] > 0 then
					frame.text:SetText(spell[2] + 1);
					frame.text:SetTextColor(1, 1, 1);
				else
					frame.text:SetText("");
				end
			end
		end
	end
end
local interrupttime = 0;
local interruptprevicon = nil;

local previcon = nil;
local prevtime = 0;
local channel_spell = nil;
local lastgcd = 1.5 / ((GetHaste() / 100) + 1);

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
		local frame = ATGCD.frame[0];
		local frameIcon = frame.icon;
		local frameCooldown = frame.cooldown;

		if name and frameIcon then
			--if name and frameIcon and isTargetPlayer then
			frameIcon:SetTexture(texture);

			if spellid == prev_spell_id then
				frame.text:SetText(seq_spell_count + 2);
				frame.text:SetTextColor(1, 1, 1);
				frame.text:Show();
			else
				frame.text:Hide();
			end
			frameIcon:Show();
			local duration = (endTime - startTime) / 1000;
			endTime = endTime / 1000;
			asCooldownFrame_Set(frameCooldown, endTime - duration, duration, duration > 0, true);
			frameCooldown:SetHideCountdownNumbers(true);
			frame:Show();
		else
			frameIcon:Hide();
			frame:Hide();
		end
	elseif (event == "UNIT_SPELLCAST_CHANNEL_START") then
		local name, text, texture, startTime, endTime, isTradeSkill, notInterruptible, spellid = UnitChannelInfo(
			"player");
		local frame = ATGCD.frame[0];
		local frameIcon = frame.icon;
		local frameCooldown = frame.cooldown;

		if name and frameIcon then
			channel_spell = spellid;
			--if name and frameIcon and isTargetPlayer then
			frameIcon:SetTexture(texture);

			if spellid == prev_spell_id then
				frame.text:SetText(seq_spell_count + 2);
				frame.text:SetTextColor(1, 1, 1);
				frame.text:Show();
			else
				frame.text:Hide();
			end
			frameIcon:Show();
			local duration = (endTime - startTime) / 1000;
			endTime = endTime / 1000;
			asCooldownFrame_Set(frameCooldown, endTime - duration, duration, duration > 0, true);
			frameCooldown:SetHideCountdownNumbers(true);
			frame:Show();
		else
			frameIcon:Hide();
			frame:Hide();
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
		local spellid = arg3;

		local name, discard, icon = asGetSpellInfo(spellid);
		local gcd = select(2, asGetSpellCooldown(61304));
		local curtime = GetTime();

		if gcd > 0 then
			lastgcd = gcd;
		end

		if (previcon and previcon == icon and (curtime - prevtime) < lastgcd) then

		else
			local itemid = KnownSpellList[spellid];

			if itemid then
				ATGCD_Alert(itemid, nil, true);				
			else
				ATGCD_Alert(spellid, nil);				
			end
			previcon = icon;
			prevtime = curtime;
		end
	elseif event == "UNIT_SPELLCAST_INTERRUPTED" and arg1 == "player" then
		local spellid = arg3;
		local name, discard, icon = asGetSpellInfo(spellid);
		local gcd = select(2, asGetSpellCooldown(61304));		
		local curtime = GetTime();

		if gcd > 0 then
			lastgcd = gcd;
		end

		if (interruptprevicon and interruptprevicon == icon and (curtime - interrupttime) < lastgcd) then
			
		else
			local itemid = KnownSpellList[spellid];

			if itemid then
				ATGCD_Alert(itemid, true, true);
			else
				ATGCD_Alert(spellid, true);		

			end
			interruptprevicon = icon;
			interrupttime = curtime;
		end
	else
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
ATGCD:RegisterEvent("PLAYER_ENTERING_WORLD");
ATGCD:RegisterEvent("PLAYER_EQUIPMENT_CHANGED");