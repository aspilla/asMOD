local _, ns = ...;

local configs = {
	pointx = 0,
	pointy = 10,
	alerttime = 0.2,
	fadetime = 1,
	defaultitems = {
		[241308] = false,
		[241304] = false,
		[5512] = false,
		[224464] = false,
	},
	updaterate = 0.2,
};

local blacklists = {
	[125439] = true,
}

local main_frame = CreateFrame("Frame");
local frames = {};
local frameidx = 1;
local alertspells = {
}

local alertitems = {
}

local function showfade(icon)
	frames[frameidx].icon:SetTexture(icon);
	ns.fadein(frames[frameidx], configs.alerttime, 0, 1)
	ns.fadeout(frames[frameidx], configs.fadetime, 1, 0)

	frameidx = frameidx + 1;

	if frameidx > 10 then
		frameidx = 1;
	end
end

local function showalert(id, isitem)
	if isitem then
		local _, _, _, _, _, _, _, _, _, icon = C_Item.GetItemInfo(id);
		if icon then
			showfade(icon);
		end
	else
		local info = C_Spell.GetSpellInfo(id);

		if info then
			showfade(info.iconID);
		end
	end
end

local function onupdate()
	for spellid, start in pairs(alertspells) do
		local or_spellid = C_Spell.GetOverrideSpell(spellid)
		local id = spellid;

		if or_spellid then
			id = or_spellid;
		end
		local cd = C_Spell.GetSpellCooldown(id)
		if cd then
			if start > 0 then
				if not cd.isActive then
					local duration = GetTime() - start;
					if duration > 2 then
						showalert(id);
					end
					alertspells[spellid] = 0;
				end
			else
				if cd.isActive and not cd.isOnGCD then
					alertspells[spellid] = GetTime();
				end
			end
		end
	end

	for itemid, iscool in pairs(alertitems) do
		local start, duration, enable = C_Item.GetItemCooldown(itemid);

		if start == 0 then
			if iscool then
				showalert(itemid, true);
			end
			alertitems[itemid] = false;
		elseif duration > 2 then
			alertitems[itemid] = true;
		end
	end
end

local function checktrinkets(slot)
	local itemid = GetInventoryItemID("player", slot);
	if itemid then
		local isusable = C_Item.IsUsableItem(itemid);
		if isusable then
			alertitems[itemid] = false;
		end
	end
end

local function scan_spellbook(tab)
	local lineinfo = C_SpellBook.GetSpellBookSkillLineInfo(tab);

	if not lineinfo or not lineinfo.name then
		return;
	end

	for i = lineinfo.itemIndexOffset + 1, lineinfo.itemIndexOffset + lineinfo.numSpellBookItems do
		local spellname = C_SpellBook.GetSpellBookItemName(i, Enum.SpellBookSpellBank.Player);

		if not spellname then
			do break end
		end

		local slottype, actionid, spellid = C_SpellBook.GetSpellBookItemType(i, Enum.SpellBookSpellBank.Player);
		local ispassive = C_SpellBook.IsSpellBookItemPassive(i, Enum.SpellBookSpellBank.Player)

		if not ispassive then
			if (slottype == Enum.SpellBookItemType.Flyout) then
				local _, _, slots = GetFlyoutInfo(actionid);
				for j = 1, slots do
					local fspellid, _, _, _, _ = GetFlyoutSlotInfo(actionid, j);

					if fspellid and not blacklists[fspellid] then
						alertspells[fspellid] = 0;
					end
				end
			else
				if spellid and not blacklists[spellid] then
					alertspells[spellid] = 0;
				end
			end
		end
	end
end

local function init_spells()
	wipe(alertspells);

	if ns.racial_spell then
		alertspells[ns.racial_spell] = 0;
	end
	scan_spellbook(2);
	scan_spellbook(3);
end

local function init_items()
	wipe(alertitems);
	alertitems = CopyTable(configs.defaultitems);
	checktrinkets(13);
	checktrinkets(14);
end

local function on_event(_, event)
	if event == "SPELL_UPDATE_COOLDOWN" then
		onupdate();
	elseif event == "PLAYER_EQUIPMENT_CHANGED" then
		C_Timer.After(1, init_items);
	else
		C_Timer.After(1, init_spells);
	end
end

function ns.init_alert()
	local i = 1;

	while (i <= 10) do
		frames[i] = CreateFrame("Frame", nil, UIParent)
		if i == 1 then
			frames[i]:SetPoint("CENTER", configs.pointx, configs.pointy);
		else
			frames[i]:SetPoint("CENTER", frames[i - 1], "CENTER", 0, 0);
		end


		frames[i]:SetWidth(ns.options.ReadyAlertSize);
		frames[i]:SetHeight(ns.options.ReadyAlertSize * 0.9);
		frames[i]:SetScale(1);
		frames[i]:SetAlpha(0);
		frames[i]:SetFrameStrata("LOW");
		frames[i]:EnableMouse(false);
		frames[i]:Show();

		frames[i].icon = frames[i]:CreateTexture(nil, "BACKGROUND");
		frames[i].icon:SetTexture("");
		frames[i].icon:ClearAllPoints();
		frames[i].icon:SetAllPoints(frames[i]);
		frames[i].icon:SetTexCoord(.08, .92, .08, .92);
		frames[i].icon:Show();

		i = i + 1;
	end

	local libasConfig = LibStub:GetLibrary("LibasConfig", true);
	if libasConfig then
		libasConfig.load_position(frames[1], "asCooldownPulse(Alert)", ACDP_Positions_4);
	end

	main_frame:RegisterEvent("TRAIT_CONFIG_UPDATED");
	main_frame:RegisterEvent("TRAIT_CONFIG_LIST_UPDATED");
	main_frame:RegisterEvent("ACTIVE_TALENT_GROUP_CHANGED");
	main_frame:RegisterEvent("PLAYER_EQUIPMENT_CHANGED");
	main_frame:RegisterEvent("SPELL_UPDATE_COOLDOWN");
	main_frame:RegisterUnitEvent("UNIT_PET", "player");

	init_spells();
	init_items();
	main_frame:SetScript("OnEvent", on_event);

	C_Timer.NewTicker(configs.updaterate, onupdate);
end
