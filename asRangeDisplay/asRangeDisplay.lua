local _, ns           = ...;
-- 설정 (변경가능)
local ARD_Font        = STANDARD_TEXT_FONT;
local ARD_FontSize    = 16;
local ARD_FontOutline = "THICKOUTLINE";
local ARD_X           = 0;
local ARD_Y           = -120;
local ARD_Focus_X     = 365;
local ARD_Focus_Y     = -165;
local ARD_Mouse_X     = 50;
local ARD_Mouse_Y     = 0;
local ARD_UpdateRate  = 0.25 -- Update 주기
-- 설정끝



local FriendItems       = {
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

local HarmItems         = {
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

local asGetSpellInfo    = function(spellID)
	if not spellID then
		return nil;
	end

	local ospellID = C_Spell.GetOverrideSpell(spellID)

	if ospellID then
		spellID = ospellID;
	end

	local spellInfo = C_Spell.GetSpellInfo(spellID);
	if spellInfo then
		return spellInfo.name, nil, spellInfo.iconID, spellInfo.castTime, spellInfo.minRange, spellInfo.maxRange,
			spellInfo.spellID, spellInfo.originalIconID;
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

local GetItemInfo       = C_Item and C_Item.GetItemInfo;
local IsItemInRange     = C_Item and C_Item.IsItemInRange;

local ARD_mainframe     = CreateFrame("Frame", nil, UIParent);
--asOverlay 위에 뜨게 하기 위해 MEDIUM으로 설정
ARD_mainframe:SetFrameStrata("MEDIUM");
ARD_mainframe:SetFrameLevel(9000);
local ARD_TargetRangeText;
local ARD_MouseRangeText;
local ARD_FocusRangeText;

local function IsHelpful(unit)
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

local function ARD_CheckRange(unit)
	local itemlist = HarmItems;

	if UnitIsUnit("player", unit) then
		return 0;
	end

	local isHelpful = IsHelpful(unit);

	if isHelpful then
		itemlist = FriendItems;
	end

	for _, v in pairs(itemlist) do
		if GetItemInfo(v[1]) and IsItemInRange(v[1], unit) then
			return v[2];
		end
	end
	return 0;
end

local function ARD_GetRangeColor(range)
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

local function scanSpells()
	local localizedClass, englishClass = UnitClass("player");


	if englishClass == "EVOKER" then
		defaultrange = 25;
	end


	cache = {};



	for tab = 1, 5 do
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
			if not isPassive and spellID then
				local name, rank, icon, castTime, minRange, maxRange, ID, originalIcon = asGetSpellInfo(spellID);
				if maxRange and maxRange > 0 and maxRange < defaultrange then
					tinsert(cache, { spellID, maxRange });
				end
			end
		end
	end
end

local function updateUnitRange(unit, frame)
	if UnitExists(unit) then
		if not InCombatLockdown() or not IsHelpful(unit) then
			local range = ARD_CheckRange(unit);
			if range == 0 then
				frame:SetText("");
			else
				frame:SetText(range);
			end
			frame:SetTextColor(ARD_GetRangeColor(range));
		else
			local grange = 80;

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

			frame:SetText(math.floor(grange + 0.5));
			frame:SetTextColor(ARD_GetRangeColor(grange));
		end
	else
		frame:SetText("");
	end
end

local function ARD_OnUpdateTarget()
	if ns.options.ShowTarget then
		updateUnitRange("target", ARD_TargetRangeText);
	end
end

local function ARD_OnUpdateMouse()
	if ns.options.ShowMouseOver then
		updateUnitRange("mouseover", ARD_MouseRangeText);
	end
end

local function ARD_OnUpdateFocus()
	if ns.options.ShowFocus then
		updateUnitRange("focus", ARD_FocusRangeText);
	end
end

local function ARD_OnMouseUpdate()
	ARD_MouseRangeText:ClearAllPoints();
	local uiScale, x, y = UIParent:GetEffectiveScale(), GetCursorPosition()
	ARD_MouseRangeText:SetPoint("CENTER", UIParent, "BOTTOMLEFT", x / uiScale + ARD_Mouse_X, y / uiScale + ARD_Mouse_Y);
end

local function ARD_OnLoad()
	ARD_TargetRangeText = ARD_mainframe:CreateFontString(nil, "OVERLAY")
	ARD_TargetRangeText:SetFont(ARD_Font, ARD_FontSize, ARD_FontOutline)
	ARD_TargetRangeText:SetPoint("CENTER", UIParent, "CENTER", ARD_X, ARD_Y);
	ARD_TargetRangeText:SetText("");
	ARD_TargetRangeText:Show();

	ARD_MouseRangeText = ARD_mainframe:CreateFontString(nil, "OVERLAY")
	ARD_MouseRangeText:SetFont(ARD_Font, ARD_FontSize, ARD_FontOutline)
	ARD_MouseRangeText:SetPoint("CENTER", UIParent, "CENTER", ARD_X, ARD_Y);
	ARD_MouseRangeText:SetText("");
	ARD_MouseRangeText:Show();

	ARD_FocusRangeText = ARD_mainframe:CreateFontString(nil, "OVERLAY")
	ARD_FocusRangeText:SetFont(ARD_Font, ARD_FontSize, ARD_FontOutline)
	ARD_FocusRangeText:SetPoint("CENTER", UIParent, "CENTER", ARD_Focus_X, ARD_Focus_Y);
	ARD_FocusRangeText:SetText("");
	ARD_FocusRangeText:Show();
	local bloaded = C_AddOns.LoadAddOn("asMOD")

	if bloaded and asMOD_setupFrame then
		asMOD_setupFrame(ARD_TargetRangeText, "asRangeDisplay(Target)");
		asMOD_setupFrame(ARD_FocusRangeText, "asRangeDisplay(Focus)");
	end

	ARD_mainframe:RegisterEvent("PLAYER_TARGET_CHANGED");
	ARD_mainframe:RegisterEvent("TRAIT_CONFIG_UPDATED");
	ARD_mainframe:RegisterEvent("TRAIT_CONFIG_LIST_UPDATED");
	ARD_mainframe:RegisterEvent("ACTIVE_TALENT_GROUP_CHANGED");
	ARD_mainframe:RegisterEvent("PLAYER_ENTERING_WORLD");
	ARD_mainframe:RegisterEvent("PLAYER_REGEN_ENABLED");
end

local bfirst = true;

local function ARD_OnEvent(self, event, ...)
	if event == "PLAYER_TARGET_CHANGED" then
		ARD_OnUpdateTarget();
	else
		if bfirst then
			bfirst = false;
			ns.SetupOptionPanels();
		end
		scanSpells();
	end
end

ARD_mainframe:SetScript("OnEvent", ARD_OnEvent);
ARD_OnLoad();
C_Timer.NewTicker(ARD_UpdateRate, ARD_OnUpdateTarget);
C_Timer.NewTicker(ARD_UpdateRate, ARD_OnUpdateMouse);
C_Timer.NewTicker(ARD_UpdateRate, ARD_OnUpdateFocus);
C_Timer.NewTicker(0.05, ARD_OnMouseUpdate);
