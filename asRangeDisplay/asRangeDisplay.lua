local _, ns        = ...;

local configs      = {
	font        = STANDARD_TEXT_FONT,
	fontsize    = 16,
	fontoutline = "THICKOUTLINE",
	xpoint      = 0,
	ypoint      = -120,
	focusxpoint = 365,
	focusypoint = -165,
	mousexpoint = 50,
	mouseypoint = 0,
	updaterate  = 0.25,
};

local friend_items = {
	{ 37727,  5 }, -- Ruby Acorn
	{ 63427,  6 }, -- Worgsaw
	{ 34368,  8 }, -- Attuned Crystal Cores
	{ 32321,  10 }, -- Sparrowhawk Net
	{ 1251,   15 }, -- Linen Bandage
	{ 21519,  20 }, -- Mistletoe
	{ 31463,  25 }, -- Zezzak's Shard
	{ 1180,   30 }, -- Scroll of Stamina
	{ 18904,  35 }, -- Zorbin's Ultra-Shrinker
	{ 34471,  40 }, -- Vial of the Sunwell
	{ 32698,  45 }, -- Wrangling Rope
	{ 116139, 50 }, -- Haunting Memento
	{ 32825,  60 }, -- Soul Cannon
	{ 41265,  70 }, -- Eyesore Blaster
	{ 35278,  80 }, -- Reinforced Net
}

local harm_items   = {
	{ 37727,  5 }, -- Ruby Acorn
	{ 63427,  6 }, -- Worgsaw
	{ 34368,  8 }, -- Attuned Crystal Cores
	{ 32321,  10 }, -- Sparrowhawk Net
	{ 33069,  15 }, -- Sturdy Rope
	{ 10645,  20 }, -- Gnomish Death Ray
	{ 24268,  25 }, -- Netherweave Net
	{ 835,    30 }, -- Large Rope Net
	{ 24269,  35 }, -- Heavy Netherweave Net
	{ 28767,  40 }, -- The Decapitator
	{ 23836,  45 }, -- Goblin Rocket Launcher
	{ 116139, 50 }, -- Haunting Memento
	{ 32825,  60 }, -- Soul Cannon
	{ 41265,  70 }, -- Eyesore Blaster
	{ 35278,  80 }, -- Reinforced Net
	{ 33119,  100 }, -- Malister's Frost Wand
}

local function get_spellinfo(spellid)
	if not spellid then
		return nil;
	end

	local or_spellid = C_Spell.GetOverrideSpell(spellid)

	if or_spellid then
		spellid = or_spellid;
	end

	local spellInfo = C_Spell.GetSpellInfo(spellid);
	if spellInfo then
		return spellInfo.name, nil, spellInfo.iconID, spellInfo.castTime, spellInfo.minRange, spellInfo.maxRange,
			spellInfo.spellID, spellInfo.originalIconID;
	end
end

local function get_spelltabinfo(index)
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

local main_frame = CreateFrame("Frame", nil, UIParent);

local function is_helpful(unit)
	if UnitIsUnit("player", unit) then
		return false;
	else
		local reaction = UnitReaction("player", unit);

		if reaction and reaction <= 4 then
			return false;
		else
			return true;
		end
	end
end

local function check_range(unit)
	local itemlist = harm_items;

	if UnitIsUnit("player", unit) then
		return 0;
	end

	local isHelpful = is_helpful(unit);

	if isHelpful then
		itemlist = friend_items;
	end

	for _, v in pairs(itemlist) do
		if C_Item.GetItemInfo(v[1]) and C_Item.IsItemInRange(v[1], unit) then
			return v[2];
		end
	end
	return 0;
end

local function get_rangecolor(range)
	if not range then
		return 0.9, 0.9, 0.9;
	end

	if range > 40 then
		return 1, 0, 0;
	elseif range > 30 then
		return 1.0, 0.82, 0;
	elseif range > 20 then
		return 0.035, 0.865, 0.0;
	elseif range > 5 then
		return 0.055, 0.875, 0.825
	else
		return 0.9, 0.9, 0.9;
	end
end

local cache = {}
local defaultrange = 40;

local function scan_spells()
	local localizedClass, englishClass = UnitClass("player");


	if englishClass == "EVOKER" then
		defaultrange = 25;
	end


	cache = {};



	for tab = 1, 5 do
		local tabName, tabTexture, tabOffset, numEntries = get_spelltabinfo(tab)

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
			if not isPassive and spellID then
				local name, rank, icon, castTime, minRange, maxRange, ID, originalIcon = get_spellinfo(spellID);
				if maxRange and maxRange > 0 and maxRange < defaultrange then
					tinsert(cache, { spellID, maxRange });
				end
			end
		end
	end
end

local function update_unitrange(unit, frame)
	if UnitExists(unit) then
		if not InCombatLockdown() or not is_helpful(unit) then
			local range = check_range(unit);
			if range == 0 then
				frame:SetText("");
			else
				frame:SetText(range);
			end
			frame:SetTextColor(get_rangecolor(range));
		else
			local grange = 100;

			--[[
			if UnitInParty(unit) or UnitInRaid(unit) then
				local inRange, checkedRange = UnitInRange(unit)

				if inRange and checkedRange then
					grange = defaultrange;
				end
			end
			]]

			if UnitIsUnit(unit, "target") then
				for _, v in pairs(cache) do
					if v[2] < grange then
						local able = C_Spell.IsSpellInRange(v[1])

						if able then
							grange = v[2];
						end
					end
				end
			end

			if grange < 100 then
				frame:SetText(math.floor(grange + 0.5));
				frame:SetTextColor(get_rangecolor(grange));
			else
				frame:SetText("");
			end
		end
	else
		frame:SetText("");
	end
end

local function on_targetupdate()
	if ns.options.ShowTarget then
		update_unitrange("target", main_frame.targettext);
	end
end

local function on_mouseupdate()
	if ns.options.ShowMouseOver then
		update_unitrange("mouseover", main_frame.mousetext);
	end
end

local function on_focusupdate()
	if ns.options.ShowFocus then
		update_unitrange("focus", main_frame.focustext);
	end
end

local function on_update()
	main_frame.mousetext:ClearAllPoints();
	local uiScale, x, y = UIParent:GetEffectiveScale(), GetCursorPosition()
	main_frame.mousetext:SetPoint("CENTER", UIParent, "BOTTOMLEFT", x / uiScale + configs.mousexpoint,
		y / uiScale + configs.mouseypoint);
end


local function on_event(self, event, ...)
	if event == "PLAYER_TARGET_CHANGED" then
		on_targetupdate();
	else
		scan_spells();
	end
end

local function init()
	ns.setup_option();
	--asOverlay 위에 뜨게 하기 위해 MEDIUM으로 설정
	main_frame:SetFrameStrata("MEDIUM");
	main_frame:SetFrameLevel(9000);

	main_frame.targettext = main_frame:CreateFontString(nil, "OVERLAY")
	main_frame.targettext:SetFont(configs.font, configs.fontsize, configs.fontoutline)
	main_frame.targettext:SetPoint("CENTER", UIParent, "CENTER", configs.xpoint, configs.ypoint);
	main_frame.targettext:SetText("");
	main_frame.targettext:Show();

	main_frame.mousetext = main_frame:CreateFontString(nil, "OVERLAY")
	main_frame.mousetext:SetFont(configs.font, configs.fontsize, configs.fontoutline)
	main_frame.mousetext:SetPoint("CENTER", UIParent, "CENTER", configs.xpoint, configs.ypoint);
	main_frame.mousetext:SetText("");
	main_frame.mousetext:Show();

	main_frame.focustext = main_frame:CreateFontString(nil, "OVERLAY")
	main_frame.focustext:SetFont(configs.font, configs.fontsize, configs.fontoutline)
	main_frame.focustext:SetPoint("CENTER", UIParent, "CENTER", configs.focusxpoint, configs.focusypoint);
	main_frame.focustext:SetText("");
	main_frame.focustext:Show();
	
	local libasConfig = LibStub:GetLibrary("LibasConfig", true);

	if libasConfig then
		libasConfig.load_position(main_frame.targettext, "asRangeDisplay(Target)", ARD_Positions_1);
		libasConfig.load_position(main_frame.focustext, "asRangeDisplay(Focus)", ARD_Positions_2);
	end

	main_frame:RegisterEvent("PLAYER_TARGET_CHANGED");
	main_frame:RegisterEvent("TRAIT_CONFIG_UPDATED");
	main_frame:RegisterEvent("TRAIT_CONFIG_LIST_UPDATED");
	main_frame:RegisterEvent("ACTIVE_TALENT_GROUP_CHANGED");
	main_frame:RegisterEvent("PLAYER_ENTERING_WORLD");
	main_frame:RegisterEvent("PLAYER_REGEN_ENABLED");

	main_frame:SetScript("OnEvent", on_event);

	C_Timer.NewTicker(configs.updaterate, on_targetupdate);
	C_Timer.NewTicker(configs.updaterate, on_mouseupdate);
	C_Timer.NewTicker(configs.updaterate, on_focusupdate);
	C_Timer.NewTicker(0.05, on_update);
end


C_Timer.After(0.5, init);
