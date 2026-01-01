local _, ns     = ...;
local configs = {
	xpoint = 56,
	ypoint = -360,
	iconsize = 25,
};


ns.blacklist = {
	[75] = 1,
	[6603] = 1,
	[240022] = 1,
	[467718] = 1,
	[1228085] = 1,
	[463429] = 1,
	[7268] = 1,
}

ns.knownspelllist = {};

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

local function scan_itemslots()
	for _, v in pairs(itemslots) do
		local idx = GetInventorySlotInfo(string.upper(v));

		local itemid = GetInventoryItemID("player", idx)

		if itemid then
			local _, id = C_Item.GetItemSpell(itemid);
			if id then
				ns.knownspelllist[id] = itemid;
			end
		end
	end
end


local main_frame = CreateFrame("FRAME", nil, UIParent)
main_frame:SetPoint("BOTTOM", UIParent, "BOTTOM", 0, 0)
main_frame:SetWidth(0)
main_frame:SetHeight(0)
main_frame:Show();


main_frame.frames = {};
for i = 0, 3 do
	local frame = CreateFrame("Button", nil, UIParent, "ATGCDFrameTemplate");

	if i == 0 then
		frame:SetPoint("CENTER", UIParent, "CENTER", configs.xpoint, configs.ypoint)
	else
		frame:SetPoint("BOTTOMRIGHT", main_frame.frames[i - 1], "BOTTOMLEFT", -1, 0);
	end

	frame:SetWidth(configs.iconsize);
	frame:SetHeight(configs.iconsize * 0.9);
	frame:SetScale(1);
	frame:SetAlpha(1);
	frame:EnableMouse(false);
	frame.icon:SetTexCoord(.08, .92, .08, .92);
	frame.icon:Show();
	frame.border:SetTexCoord(0.08, 0.08, 0.08, 0.92, 0.92, 0.08, 0.92, 0.92);
	frame.border:SetVertexColor(0, 0, 0);
	frame.border:Show();

	frame.cooldown:SetHideCountdownNumbers(true);
	
	frame.text:SetFont(STANDARD_TEXT_FONT, 16, "OUTLINE");
	frame.text:ClearAllPoints();
	frame.text:SetPoint("CENTER", frame, "CENTER", 0, 0);

	frame:Hide();
	frame:EnableMouse(false);

	main_frame.frames[i] = frame;
end

local castframe = main_frame.frames[0];

castframe:SetWidth(configs.iconsize * 1.3);
castframe:SetHeight(configs.iconsize * 1.3 * 0.9);
castframe:Hide();

local bloaded = C_AddOns.LoadAddOn("asMOD")
if bloaded and asMOD_setupFrame then
	asMOD_setupFrame(castframe, "asTrueGCD");
end


local prevspellid = nil;
local spellseqcount = 0;
ns.spelllist = {};

local function insert_spell(spellid, bcancel, bitem)
	if spellid == nil then		
		return
	end

	if ns.blacklist[spellid] then
		return;
	end

	if spellid == prevspellid and not bcancel then
		spellseqcount = spellseqcount + 1;
	elseif not bcancel then
		prevspellid = spellid;
		spellseqcount = 0;
	end

	local name, discard, icon = asGetSpellInfo(spellid)

	if bitem then
		icon = select(10, C_Item.GetItemInfo(spellid));
	end


	if icon == nil then
		return;
	elseif icon == 136243 then
		return;
	end

	local current = GetTime();

	if #ns.spelllist > 3 then
		table.remove(ns.spelllist, 4);
	end

	table.insert(ns.spelllist, 1, { icon, spellseqcount, bcancel, current, spellid });

	return;
end


local function on_update()
	local current = GetTime();

	for i = 1, 3 do
		local spell = ns.spelllist[4 - i];
		local frame = main_frame.frames[4 - i];

		if spell then
			if spell[4] and current - spell[4] > 5 then
				frame:Hide();
			else
				frame.icon:SetTexture(spell[1]);
				frame.spellid = spell[5];				

				if spell[3] then
					frame.text:SetText("X");
					frame.text:SetTextColor(1, 0, 0);
				elseif spell[2] > 0 then
					frame.text:SetText(spell[2] + 1);
					frame.text:SetTextColor(1, 1, 1);
				else
					frame.text:SetText("");
				end
				frame:Show();
			end
		end
	end
end
local interrupttime = 0;
local interruptprevicon = nil;

local previcon = nil;
local prevtime = 0;

local function clear_cooldownframe(self)
	self:Clear();
end

local function set_cooldownframe(self, start, duration, enable, forceShowDrawEdge, modRate)
	if enable and enable ~= 0 and start > 0 and duration > 0 then
		self:SetDrawEdge(forceShowDrawEdge);
		self:SetCooldown(start, duration, modRate);
	else
		clear_cooldownframe(self);
	end
end

local function on_event(self, event, arg1, arg2, arg3, arg4, arg5)
	if (event == "UNIT_SPELLCAST_START") then
		local name, text, texture, startTime, endTime, isTradeSkill, castID, notInterruptible, spellid = UnitCastingInfo(
			"player");
		local frame = castframe;
		local frameIcon = frame.icon;
		local frameCooldown = frame.cooldown;

		if name and frameIcon then
			--if name and frameIcon and isTargetPlayer then
			frameIcon:SetTexture(texture);
			frame.spellid = spellid;

			if spellid == prevspellid then
				frame.text:SetText(spellseqcount + 2);
				frame.text:SetTextColor(1, 1, 1);
				frame.text:Show();
			else
				frame.text:Hide();
			end

			local duration = (endTime - startTime) / 1000;
			endTime = endTime / 1000;
			set_cooldownframe(frameCooldown, endTime - duration, duration, duration > 0, true);
			frame:Show();
		else
			frame:Hide();
		end
	elseif (event == "UNIT_SPELLCAST_CHANNEL_START") then
		local name, text, texture, startTime, endTime, isTradeSkill, notInterruptible, spellid = UnitChannelInfo(
			"player");
		local frame = castframe;
		local frameIcon = frame.icon;
		local frameCooldown = frame.cooldown;

		if name and frameIcon then
			--if name and frameIcon and isTargetPlayer then
			frameIcon:SetTexture(texture);
			frame.spellid = spellid;

			if spellid == prevspellid then
				frame.text:SetText(spellseqcount + 2);
				frame.text:SetTextColor(1, 1, 1);
				frame.text:Show();
			else
				frame.text:Hide();
			end

			local duration = (endTime - startTime) / 1000;
			endTime = endTime / 1000;
			set_cooldownframe(frameCooldown, endTime - duration, duration, duration > 0, true);
			frame:Show();
		else
			frame:Hide();
		end
	elseif event == "UNIT_SPELLCAST_STOP" then
		local name = UnitCastingInfo("player");
		if not name then
			castframe:Hide();
		end
	elseif event == "UNIT_SPELLCAST_CHANNEL_STOP" then
		local name = UnitChannelInfo("player");
		if not name then
			castframe:Hide();
		end
	elseif event == "UNIT_SPELLCAST_SUCCEEDED" and arg1 == "player" then
		local spellid = arg3;
		local name, discard, icon = asGetSpellInfo(spellid);
		local curtime = GetTime();

		if (previcon and previcon == icon and (curtime - prevtime) < 0.5) then

		else
			local itemid = ns.knownspelllist[spellid];

			if itemid then
				insert_spell(itemid, nil, true);
			else
				insert_spell(spellid, nil);
			end
			previcon = icon;
			prevtime = curtime;
		end
	elseif event == "UNIT_SPELLCAST_INTERRUPTED" and arg1 == "player" then
		local spellid = arg3;
		local name, discard, icon = asGetSpellInfo(spellid);

		local curtime = GetTime();
		if (interruptprevicon and interruptprevicon == icon and (curtime - interrupttime) < 0.5) then

		else
			local itemid = ns.knownspelllist[spellid];

			if itemid then
				insert_spell(itemid, true, true);
			else
				insert_spell(spellid, true);
			end
			interruptprevicon = icon;
			interrupttime = curtime;
		end
	else
		scan_itemslots();
	end

	return;
end

C_Timer.NewTicker(0.25, on_update);
main_frame:SetScript("OnEvent", on_event)

main_frame:RegisterUnitEvent("UNIT_SPELLCAST_SUCCEEDED", "player");
main_frame:RegisterUnitEvent("UNIT_SPELLCAST_INTERRUPTED", "player");
main_frame:RegisterUnitEvent("UNIT_SPELLCAST_START", "player");
main_frame:RegisterUnitEvent("UNIT_SPELLCAST_CHANNEL_START", "player");
main_frame:RegisterUnitEvent("UNIT_SPELLCAST_CHANNEL_STOP", "player");
main_frame:RegisterUnitEvent("UNIT_SPELLCAST_STOP", "player");
main_frame:RegisterEvent("PLAYER_ENTERING_WORLD");
main_frame:RegisterEvent("PLAYER_EQUIPMENT_CHANGED");
