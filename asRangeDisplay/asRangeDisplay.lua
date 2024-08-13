-- 설정 (변경가능)
local ARD_Font        = "Fonts\\2002.TTF";
local ARD_FontSize    = 16;
local ARD_FontOutline = "THICKOUTLINE";
local ARD_X           = 0;
local ARD_Y           = -130;
local ARD_AHT         = false -- asHealthText에 연결
local ARD_UpdateRate  = 0.25  -- Update 주기
-- 설정끝
local FriendItems     = {
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

local HarmItems       = {
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

local mspells         = {
	--악사
	["혼돈의 일격"] = 3,
	["영혼 베어내기"] = 3,

	--전사
	["방패 밀쳐내기"] = 3,
	["필사의 일격"] = 3,
	["피의 갈증"] = 3,

	--도적
	["속결"] = 3,
	["독살"] = 3,
	["절개"] = 3,

	--사냥꾼
	["날개 절단"] = 3,

	--성기사	
	["정의의 방패"] = 8,
	["성전사 일격"] = 8,
	["기사단의 공세"] = 8,
	["기사단의 베기"] = 8,
	["성전의 강타"] = 8,

	--죽음의 기사
	["죽음의 일격"] = 3,

	--수도사
	["후려차기"] = 3,

	--드루이드
	["칼날 발톱"] = 9,
	["짓이기기"] = 11,

	--주술사
	["폭풍의 일격"] = 3,


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

local GetItemInfo = C_Item and C_Item.GetItemInfo or GetItemInfo;
local IsItemInRange = C_Item and C_Item.IsItemInRange or IsItemInRange;

local ARD_mainframe   = CreateFrame("Frame", nil, UIParent);
ARD_mainframe:SetFrameStrata("MEDIUM");
ARD_mainframe:SetFrameLevel(9000);
local ARD_RangeText;

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

	return false;
end

local function ARD_CheckRange(unit)
	local isHarm = true;
	local itemlist = FriendItems;

	if UnitIsUnit("player", unit) then
		return 0;
	else
		local reaction = UnitReaction("player", unit);

		if reaction and reaction <= 4 then
			isHarm = true;
		else
			isHarm = false;
		end
	end

	if isHarm then
		itemlist = HarmItems;
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

local function scanSpells()
	cache = {};
	for tab = 1, 5 do
		local tabName, tabTexture, tabOffset, numEntries = asGetSpellTabInfo(tab)

		if not tabName then
			return;
		end

		for i = tabOffset + 1, tabOffset + numEntries do
			local spellName, _, spellID = C_SpellBook.GetSpellBookItemName(i, Enum.SpellBookSpellBank.Player)
			local name, rank, icon, castTime, minRange, maxRange, ID, originalIcon = asGetSpellInfo(spellID);
			local mrange = mspells[name];

			if maxRange and (maxRange > 0 or mrange) then
				if mrange and mrange > maxRange then
					maxRange = mrange
				end
				tinsert(cache, { i, maxRange });
			end
		end
	end
end

local function ARD_OnUpdate()
	if UnitExists("target") then
		if not InCombatLockdown() or not IsHelpful("target") then
			local range = ARD_CheckRange("target");
			if range == 0 then
				ARD_RangeText:SetText("");
			else
				ARD_RangeText:SetText(range);
			end
			ARD_RangeText:SetTextColor(ARD_GetRangeColor(range));
		else
			local grange = 100;

			for _, v in pairs(cache) do
				local able = C_Spell.IsSpellInRange(v[1])

				if able == 1 and v[2] < grange then
					grange = v[2];
				end
			end

			ARD_RangeText:SetText(math.floor(grange + 0.5));
			ARD_RangeText:SetTextColor(ARD_GetRangeColor(grange));
		end
	else
		ARD_RangeText:SetText("");
	end
end

local function ARD_OnLoad()
	ARD_RangeText = ARD_mainframe:CreateFontString(nil, "OVERLAY")
	ARD_RangeText:SetFont(ARD_Font, ARD_FontSize, ARD_FontOutline)

	local bloaded = C_AddOns.LoadAddOn("asHealthText")

	if bloaded and ARD_AHT then
		ARD_RangeText:SetPoint("LEFT", "AHT_RaidIcon", "RIGHT", 2, 0);
	else
		ARD_RangeText:SetPoint("CENTER", UIParent, "CENTER", ARD_X, ARD_Y);
	end

	ARD_RangeText:SetText("");
	ARD_RangeText:Show();

	local bloaded = C_AddOns.LoadAddOn("asMOD")

	if bloaded and asMOD_setupFrame then
		asMOD_setupFrame(ARD_RangeText, "asRangeDisplay");
	end

	ARD_mainframe:RegisterEvent("PLAYER_TARGET_CHANGED");
	ARD_mainframe:RegisterEvent("TRAIT_CONFIG_UPDATED");
	ARD_mainframe:RegisterEvent("TRAIT_CONFIG_LIST_UPDATED");
	ARD_mainframe:RegisterEvent("ACTIVE_TALENT_GROUP_CHANGED");
	ARD_mainframe:RegisterEvent("PLAYER_ENTERING_WORLD");
	ARD_mainframe:RegisterEvent("PLAYER_REGEN_ENABLED");
end

local function ARD_OnEvent(self, event, ...)
	if event == "PLAYER_TARGET_CHANGED" then
		ARD_OnUpdate();
	else
		scanSpells();
	end
end

ARD_mainframe:SetScript("OnEvent", ARD_OnEvent);
ARD_OnLoad();
C_Timer.NewTicker(ARD_UpdateRate, ARD_OnUpdate);
