local _, ns = ...;
local ABF;
local ABF_PLAYER_BUFF;
local ABF_TARGET_BUFF;
local ABF_SIZE = 28;
local ABF_TARGET_BUFF_X = 73 + 30 + 20;
local ABF_TARGET_BUFF_Y = -142;
local ABF_PLAYER_BUFF_X = -73 - 30 - 20;
local ABF_PLAYER_BUFF_Y = -142;
local ABF_MAX_BUFF_SHOW = 7;
local ABF_ALPHA = 1;
local ABF_CooldownFontSize = 12; -- Cooldown Font Size
local ABF_CountFontSize = 11;    -- Count Font Size
local ABF_AlphaCombat = 1;       -- 전투중 Alpha 값
local ABF_AlphaNormal = 0.5;     -- 비 전투중 Alpha 값
local ABF_MAX_Cool = 60;         -- 최대 60초의 버프를 보임

local ABF_BlackList = {
	--	["문양: 기사단의 선고"] = 1,
	--	["문양: 이중 판결"] = 1,
	--	["관대한 치유사"] = 1,
	--	["법의 위세"] = 1,
	--	["피의 광기"] = 1,

}

-- 발동 주요 공격 버프
-- 보이게만 할려면 2, 강조하려면 1
local ABF_ProcBuffList = {
	--블러드
	["시간 왜곡"] = 1,
	["영웅심"] = 1,
	["피의 욕망"] = 1,
	["황천바람"] = 1,
	["고대의 격분"] = 1,
	["위상의 격노"] = 1,
	["쾌활한 생기화"] = 2,
	["넬타루스의 전리품"] = 2,
}

-- PVP Buff List
local ABF_PVPBuffList = {

	--생존기 (용군단 Update 완료)
	[236273] = true, --WARRIOR
	[213871] = true, --WARRIOR
	[118038] = true, --WARRIOR
	[12975] = true, --WARRIOR
	[1160] = true, --WARRIOR
	[871] = true, --WARRIOR
	[202168] = true, --WARRIOR
	[97463] = true, --WARRIOR
	[383762] = true, --WARRIOR
	[184364] = true, --WARRIOR
	[386394] = true, --WARRIOR
	[392966] = true, --WARRIOR
	[185311] = true, --ROGUE
	[11327] = true, --ROGUE
	[1966] = true, --ROGUE
	[31224] = true, --ROGUE
	[31230] = true, --ROGUE
	[5277] = true, --ROGUE
	[212800] = true, --DEMONHUNTER
	[203720] = true, --DEMONHUNTER
	[187827] = true, --DEMONHUNTER
	[206803] = true, --DEMONHUNTER
	[196555] = true, --DEMONHUNTER
	[204021] = true, --DEMONHUNTER
	[263648] = true, --DEMONHUNTER
	[209258] = true, --DEMONHUNTER
	[209426] = true, --DEMONHUNTER
	[202162] = true, --MONK
	[388615] = true, --MONK
	[115310] = true, --MONK
	[116849] = true, --MONK
	[115399] = true, --MONK
	[119582] = true, --MONK
	[122281] = true, --MONK
	[322507] = true, --MONK
	[120954] = true, --MONK
	[122783] = true, --MONK
	[122278] = true, --MONK
	[132578] = true, --MONK
	[115176] = true, --MONK
	[51052] = true, --DEATHKNIGHT
	[48707] = true, --DEATHKNIGHT
	[327574] = true, --DEATHKNIGHT
	[48743] = true, --DEATHKNIGHT
	[48792] = true, --DEATHKNIGHT
	[114556] = true, --DEATHKNIGHT
	[81256] = true, --DEATHKNIGHT
	[219809] = true, --DEATHKNIGHT
	[206931] = true, --DEATHKNIGHT
	[274156] = true, --DEATHKNIGHT
	[194679] = true, --DEATHKNIGHT
	[55233] = true, --DEATHKNIGHT
	[272679] = true, --HUNTER
	[53480] = true, --HUNTER
	[109304] = true, --HUNTER
	[264735] = true, --HUNTER
	[186265] = true, --HUNTER
	[355913] = true, --EVOKER
	[370960] = true, --EVOKER
	[363534] = true, --EVOKER
	[357170] = true, --EVOKER
	[374348] = true, --EVOKER
	[374227] = true, --EVOKER
	[363916] = true, --EVOKER
	[360827] = true, --EVOKER
	[404381] = true, --EVOKER
	[305497] = true, --DRUID
	[354654] = true, --DRUID
	[201664] = true, --DRUID
	[157982] = true, --DRUID
	[102342] = true, --DRUID
	[61336] = true, --DRUID
	[200851] = true, --DRUID
	[80313] = true, --DRUID
	[22842] = true, --DRUID
	[108238] = true, --DRUID
	[124974] = true, --DRUID
	[22812] = true, --DRUID
	[104773] = true, --WARLOCK
	[108416] = true, --WARLOCK
	[215769] = true, --PRIEST
	[328530] = true, --PRIEST
	[197268] = true, --PRIEST
	[19236] = true, --PRIEST
	[81782] = true, --PRIEST
	[33206] = true, --PRIEST
	[372835] = true, --PRIEST
	[391124] = true, --PRIEST
	[265202] = true, --PRIEST
	[64843] = true, --PRIEST
	[47788] = true, --PRIEST
	[47585] = true, --PRIEST
	[108968] = true, --PRIEST
	[15286] = true, --PRIEST
	[271466] = true, --PRIEST
	[199452] = true, --PALADIN
	[403876] = true, --PALADIN
	[31850] = true, --PALADIN
	[378279] = true, --PALADIN
	[378974] = true, --PALADIN
	[86659] = true, --PALADIN
	[387174] = true, --PALADIN
	[327193] = true, --PALADIN
	[205191] = true, --PALADIN
	[184662] = true, --PALADIN
	[498] = true, --PALADIN
	[148039] = true, --PALADIN
	[157047] = true, --PALADIN
	[31821] = true, --PALADIN
	[633] = true, --PALADIN
	[6940] = true, --PALADIN
	[1022] = true, --PALADIN
	[204018] = true, --PALADIN
	[204331] = true, --SHAMAN
	[108280] = true, --SHAMAN
	[98008] = true, --SHAMAN
	[198838] = true, --SHAMAN
	[207399] = true, --SHAMAN
	[108271] = true, --SHAMAN
	[198103] = true, --SHAMAN
	[30884] = true, --SHAMAN
	[383017] = true, --SHAMAN
	[108281] = true, --SHAMAN
	[198111] = true, --MAGE
	[110959] = true, --MAGE
	[342246] = true, --MAGE
	[11426] = true, --MAGE
	[66] = true,  --MAGE
	[235313] = true, --MAGE
	[235450] = true, --MAGE
	[55342] = true, --MAGE
	[414660] = true, --MAGE
	[414664] = true, --MAGE
	[86949] = true, --MAGE
	[235219] = true, --MAGE
	[414658] = true, --MAGE
	[110960] = true, --MAGE
	[125174] = true, --MONK
	[186265] = true, --HUNTER
	[378441] = true, --EVOKER
	[228049] = true, --PALADIN
	[642] = true, --PALADIN
	[409293] = true, --SHAMAN
	[45438] = true, --MAGE	
	[586] = true, --PRIEST

	--공격버프 시작 (용군단 update 완료)
	[198817] = true, --WARRIOR
	[260708] = true, --WARRIOR
	[260643] = true, --WARRIOR
	[262161] = true, --WARRIOR
	[167105] = true, --WARRIOR
	[384110] = true, --WARRIOR
	[384318] = true, --WARRIOR
	[107574] = true, --WARRIOR
	[376079] = true, --WARRIOR
	[228920] = true, --WARRIOR
	[1719] = true, --WARRIOR
	[385059] = true, --WARRIOR
	[227847] = true, --WARRIOR
	[401150] = true, --WARRIOR
	[315341] = true, --ROGUE
	[221622] = true, --ROGUE
	[269513] = true, --ROGUE
	[212283] = true, --ROGUE
	[385424] = true, --ROGUE
	[385408] = true, --ROGUE
	[385616] = true, --ROGUE
	[271877] = true, --ROGUE
	[381989] = true, --ROGUE
	[315508] = true, --ROGUE
	[13750] = true, --ROGUE
	[343142] = true, --ROGUE
	[51690] = true, --ROGUE
	[13877] = true, --ROGUE
	[196937] = true, --ROGUE
	[185422] = true, --ROGUE
	[280719] = true, --ROGUE
	[277925] = true, --ROGUE
	[384631] = true, --ROGUE
	[121471] = true, --ROGUE
	[5938] = true, --ROGUE
	[382245] = true, --ROGUE
	[381623] = true, --ROGUE
	[360194] = true, --ROGUE
	[381802] = true, --ROGUE
	[200806] = true, --ROGUE
	[385627] = true, --ROGUE
	[162264] = true, --DEMONHUNTER
	[370965] = true, --DEMONHUNTER
	[204596] = true, --DEMONHUNTER
	[390163] = true, --DEMONHUNTER
	[207407] = true, --DEMONHUNTER
	[212084] = true, --DEMONHUNTER
	[198013] = true, --DEMONHUNTER
	[258925] = true, --DEMONHUNTER
	[342817] = true, --DEMONHUNTER
	[258860] = true, --DEMONHUNTER
	[322109] = true, --MONK
	[388193] = true, --MONK
	[196725] = true, --MONK
	[124081] = true, --MONK
	[386276] = true, --MONK
	[322118] = true, --MONK
	[325197] = true, --MONK
	[116680] = true, --MONK
	[113656] = true, --MONK
	[137639] = true, --MONK
	[152173] = true, --MONK
	[123904] = true, --MONK
	[152175] = true, --MONK
	[392983] = true, --MONK
	[388686] = true, --MONK
	[123986] = true, --MONK
	[387184] = true, --MONK
	[325153] = true, --MONK
	[203173] = true, --DEATHKNIGHT
	[196770] = true, --DEATHKNIGHT
	[288853] = true, --DEATHKNIGHT
	[196770] = true, --DEATHKNIGHT
	[383269] = true, --DEATHKNIGHT
	[47568] = true, --DEATHKNIGHT
	[152279] = true, --DEATHKNIGHT
	[279302] = true, --DEATHKNIGHT
	[305392] = true, --DEATHKNIGHT
	[51271] = true, --DEATHKNIGHT
	[194844] = true, --DEATHKNIGHT
	[207289] = true, --DEATHKNIGHT
	[390279] = true, --DEATHKNIGHT
	[115989] = true, --DEATHKNIGHT
	[49206] = true, --DEATHKNIGHT
	[275699] = true, --DEATHKNIGHT
	[63560] = true, --DEATHKNIGHT
	[46584] = true, --DEATHKNIGHT
	[42650] = true, --DEATHKNIGHT
	[208652] = true, --HUNTER
	[205691] = true, --HUNTER
	[400456] = true, --HUNTER
	[269751] = true, --HUNTER
	[203415] = true, --HUNTER
	[360952] = true, --HUNTER
	[360966] = true, --HUNTER
	[257044] = true, --HUNTER
	[288613] = true, --HUNTER
	[260243] = true, --HUNTER
	[120360] = true, --HUNTER
	[212431] = true, --HUNTER
	[375891] = true, --HUNTER
	[201430] = true, --HUNTER
	[321530] = true, --HUNTER
	[131894] = true, --HUNTER
	[193530] = true, --HUNTER
	[19574] = true, --HUNTER
	[120679] = true, --HUNTER
	[359844] = true, --HUNTER
	[377509] = true, --EVOKER
	[390386] = true, --EVOKER
	[357210] = true, --EVOKER
	[382266] = true, --EVOKER
	[359816] = true, --EVOKER
	[370537] = true, --EVOKER
	[368412] = true, --EVOKER
	[367226] = true, --EVOKER
	[355936] = true, --EVOKER
	[370452] = true, --EVOKER
	[359073] = true, --EVOKER
	[368847] = true, --EVOKER
	[375087] = true, --EVOKER
	[370553] = true, --EVOKER
	[395152] = true, --EVOKER
	[403631] = true, --EVOKER
	[50334] = true, --DRUID
	[102351] = true, --DRUID
	[203651] = true, --DRUID
	[117679] = true, --DRUID
	[391528] = true, --DRUID
	[391888] = true, --DRUID
	[392160] = true, --DRUID
	[197721] = true, --DRUID
	[274837] = true, --DRUID
	[391891] = true, --DRUID
	[102543] = true, --DRUID
	[5217] = true, --DRUID
	[102558] = true, --DRUID
	[319454] = true, --DRUID
	[102560] = true, --DRUID
	[194223] = true, --DRUID
	[88747] = true, --DRUID
	[202770] = true, --DRUID
	[274281] = true, --DRUID
	[202425] = true, --DRUID
	[417537] = true, --WARLOCK
	[344566] = true, --WARLOCK
	[212459] = true, --WARLOCK
	[353601] = true, --WARLOCK
	[201996] = true, --WARLOCK
	[353753] = true, --WARLOCK
	[89751] = true, --WARLOCK
	[328774] = true, --WARLOCK
	[387976] = true, --WARLOCK
	[152108] = true, --WARLOCK
	[6353] = true, --WARLOCK
	[1122] = true, --WARLOCK
	[267218] = true, --WARLOCK
	[264130] = true, --WARLOCK
	[386833] = true, --WARLOCK
	[264119] = true, --WARLOCK
	[267171] = true, --WARLOCK
	[267211] = true, --WARLOCK
	[104316] = true, --WARLOCK
	[265273] = true, --WARLOCK
	[205180] = true, --WARLOCK
	[278350] = true, --WARLOCK
	[205179] = true, --WARLOCK
	[386951] = true, --WARLOCK
	[386997] = true, --WARLOCK
	[196447] = true, --WARLOCK
	[211522] = true, --PRIEST
	[197871] = true, --PRIEST
	[197862] = true, --PRIEST
	[316262] = true, --PRIEST
	[372760] = true, --PRIEST
	[205385] = true, --PRIEST
	[246287] = true, --PRIEST
	[373178] = true, --PRIEST
	[214621] = true, --PRIEST
	[314867] = true, --PRIEST
	[123040] = true, --PRIEST
	[47536] = true, --PRIEST
	[372616] = true, --PRIEST
	[200183] = true, --PRIEST
	[34861] = true, --PRIEST
	[2050] = true, --PRIEST
	[200174] = true, --PRIEST
	[263165] = true, --PRIEST
	[391109] = true, --PRIEST
	[228260] = true, --PRIEST
	[373481] = true, --PRIEST
	[120644] = true, --PRIEST
	[120517] = true, --PRIEST
	[375901] = true, --PRIEST
	[10060] = true, --PRIEST
	[34433] = true, --PRIEST
	[389539] = true, --PALADIN
	[375576] = true, --PALADIN
	[255937] = true, --PALADIN
	[231895] = true, --PALADIN
	[343527] = true, --PALADIN
	[343721] = true, --PALADIN
	[210294] = true, --PALADIN
	[114165] = true, --PALADIN
	[114158] = true, --PALADIN
	[216331] = true, --PALADIN
	[200652] = true, --PALADIN
	[388007] = true, --PALADIN
	[105809] = true, --PALADIN
	[152262] = true, --PALADIN
	[193876] = true, --SHAMAN
	[2825] = true, --SHAMAN
	[204330] = true, --SHAMAN
	[384352] = true, --SHAMAN
	[375982] = true, --SHAMAN
	[51533] = true, --SHAMAN
	[198067] = true, --SHAMAN
	[192249] = true, --SHAMAN
	[191634] = true, --SHAMAN
	[210714] = true, --SHAMAN
	[114050] = true, --SHAMAN
	[192222] = true, --SHAMAN
	[157153] = true, --SHAMAN
	[197995] = true, --SHAMAN
	[114052] = true, --SHAMAN
	[5394] = true, --SHAMAN
	[114051] = true, --SHAMAN
	[353128] = true, --MAGE
	[353082] = true, --MAGE
	[198144] = true, --MAGE
	[80353] = true, --MAGE
	[382440] = true, --MAGE
	[153561] = true, --MAGE
	[116011] = true, --MAGE
	[205025] = true, --MAGE
	[205021] = true, --MAGE
	[12472] = true, --MAGE
	[84714] = true, --MAGE
	[44614] = true, --MAGE
	[153595] = true, --MAGE
	[190319] = true, --MAGE
	[257541] = true, --MAGE
	[365350] = true, --MAGE
	[321507] = true, --MAGE
	[376103] = true, --MAGE
	[153626] = true, --MAGE

};



local ABF_TalentBuffList = {};

--AuraUtil
local PLAYER_UNITS = {
	player = true,
	vehicle = true,
	pet = true,
};


local DispellableDebuffTypes =
{
	Magic = true,
	Curse = true,
	Disease = true,
	Poison = true
};


local AuraUpdateChangedType = EnumUtil.MakeEnum(
	"None",
	"Debuff",
	"Buff",
	"PVP",
	"Dispel"
);

local UnitFrameBuffType = EnumUtil.MakeEnum(
	"BossBuff",
	"PriorityBuff",
	"TalentBuff",
	"ShouldShowBuff",
	"Normal"
);



local AuraFilters =
{
	Helpful = "HELPFUL",
	Harmful = "HARMFUL",
	Raid = "RAID",
	IncludeNameplateOnly = "INCLUDE_NAME_PLATE_ONLY",
	Player = "PLAYER",
	Cancelable = "CANCELABLE",
	NotCancelable = "NOT_CANCELABLE",
	Maw = "MAW",
};

local function CreateFilterString(...)
	return table.concat({ ... }, '|');
end

local function DefaultAuraCompare(a, b)
	local aFromPlayer = (a.sourceUnit ~= nil) and UnitIsUnit("player", a.sourceUnit) or false;
	local bFromPlayer = (b.sourceUnit ~= nil) and UnitIsUnit("player", b.sourceUnit) or false;
	if aFromPlayer ~= bFromPlayer then
		return aFromPlayer;
	end

	if a.canApplyAura ~= b.canApplyAura then
		return a.canApplyAura;
	end

	return a.spellId < b.spellId
end

local function UnitFrameBuffComparator(a, b)
	if a.buffType ~= b.buffType then
		return a.buffType < b.buffType;
	end

	return DefaultAuraCompare(a, b);
end


local function ForEachAuraHelper(unit, filter, func, usePackedAura, continuationToken, ...)
	-- continuationToken is the first return value of UnitAuraSlots()
	local n = select('#', ...);
	for i = 1, n do
		local slot = select(i, ...);
		local done;
		if usePackedAura then
			local auraInfo = C_UnitAuras.GetAuraDataBySlot(unit, slot);
			done = func(auraInfo);
		else
			done = func(UnitAuraBySlot(unit, slot));
		end
		if done then
			-- if func returns true then no further slots are needed, so don't return continuationToken
			return nil;
		end
	end
	return continuationToken;
end
local function ForEachAura(unit, filter, maxCount, func, usePackedAura)
	if maxCount and maxCount <= 0 then
		return;
	end
	local continuationToken;
	repeat
		-- continuationToken is the first return value of UnitAuraSltos
		continuationToken = ForEachAuraHelper(unit, filter, func, usePackedAura,
			UnitAuraSlots(unit, filter, maxCount, continuationToken));
	until continuationToken == nil;
end



local filter = CreateFilterString(AuraFilters.Helpful);


local function scanSpells(tab)
	local tabName, tabTexture, tabOffset, numEntries = GetSpellTabInfo(tab)

	if not tabName then
		return;
	end

	for i = tabOffset + 1, tabOffset + numEntries do
		local spellName, _, spellID = GetSpellBookItemName(i, BOOKTYPE_SPELL)
		local _, _, icon = GetSpellInfo(spellID);
		if not spellName then
			do break end
		end

		ABF_TalentBuffList[spellName] = true;
		ABF_TalentBuffList[icon or 0] = true;
	end
end

local function asCheckTalent()
	table.wipe(ABF_TalentBuffList);

	local specID = PlayerUtil.GetCurrentSpecID();
	local configID = C_ClassTalents.GetActiveConfigID();

	if not (configID) then
		return;
	end
	local configInfo = C_Traits.GetConfigInfo(configID);
	local treeID = configInfo.treeIDs[1];
	local nodes = C_Traits.GetTreeNodes(treeID);

	for _, nodeID in ipairs(nodes) do
		local nodeInfo = C_Traits.GetNodeInfo(configID, nodeID);
		if nodeInfo.currentRank and nodeInfo.currentRank > 0 then
			local entryID = nodeInfo.activeEntry and nodeInfo.activeEntry.entryID and nodeInfo.activeEntry.entryID;
			local entryInfo = entryID and C_Traits.GetEntryInfo(configID, entryID);
			local definitionInfo = entryInfo and entryInfo.definitionID and
				C_Traits.GetDefinitionInfo(entryInfo.definitionID);

			if definitionInfo ~= nil then
				local talentName = TalentUtil.GetTalentName(definitionInfo.overrideName, definitionInfo.spellID);
				--print(string.format("%s/%d %s/%d", talentName, definitionInfo.spellID, definitionInfo.overrideName or "", definitionInfo.overriddenSpellID or 0));
				local name, rank, icon = GetSpellInfo(definitionInfo.spellID);
				ABF_TalentBuffList[talentName or ""] = true;
				ABF_TalentBuffList[icon or 0] = true;
				if definitionInfo.overrideName then
					--print (definitionInfo.overrideName)
					ABF_TalentBuffList[definitionInfo.overrideName] = true;
				end
			end
		end
	end
	scanSpells(2)
	scanSpells(3)
	return;
end


local function asCooldownFrame_Clear(self)
	self:Clear();
end

local overlayspell = {};

local function asCooldownFrame_Set(self, start, duration, enable, forceShowDrawEdge, modRate)
	if enable and enable ~= 0 and start > 0 and duration > 0 then
		self:SetDrawEdge(forceShowDrawEdge);
		self:SetCooldown(start, duration, modRate);
	else
		asCooldownFrame_Clear(self);
	end
end

local cachedVisualizationInfo = {};
local hasValidPlayer = false;

local function GetCachedVisibilityInfo(spellId)
	if cachedVisualizationInfo[spellId] == nil then
		local newInfo = {
			SpellGetVisibilityInfo(spellId, UnitAffectingCombat("player") and "RAID_INCOMBAT" or "RAID_OUTOFCOMBAT") };
		if not hasValidPlayer then
			-- Don't cache the info if the player is not valid since we didn't get a valid result
			return unpack(newInfo);
		end
		cachedVisualizationInfo[spellId] = newInfo;
	end

	local info = cachedVisualizationInfo[spellId];
	return unpack(info);
end


local cachedSelfBuffChecks = {};
local function CheckIsSelfBuff(spellId)
	if cachedSelfBuffChecks[spellId] == nil then
		cachedSelfBuffChecks[spellId] = SpellIsSelfBuff(spellId);
	end

	return cachedSelfBuffChecks[spellId];
end

local function DumpCaches()
	cachedVisualizationInfo = {};
	cachedSelfBuffChecks = {};
end

-- 버프 설정 부
local function IsShouldDisplayBuff(spellId, unitCaster, canApplyAura)
	local hasCustom, alwaysShowMine, showForMySpec = GetCachedVisibilityInfo(spellId);

	if (hasCustom) then
		return showForMySpec or
			(alwaysShowMine and (unitCaster == "player" or unitCaster == "pet" or unitCaster == "vehicle"));
	else
		return (unitCaster == "player" or unitCaster == "pet" or unitCaster == "vehicle") and canApplyAura and
			not CheckIsSelfBuff(spellId);
	end
end


local function IsShown(name, spellId)
	-- asPowerBar Check
	if APB_BUFF and APB_BUFF == name then
		return true;
	end

	if APB_BUFF2 and APB_BUFF2 == name then
		return true;
	end

	if APB_BUFF_COMBO and APB_BUFF_COMBO == name then
		return true;
	end

	if ACI_Buff_list and (ACI_Buff_list[name] or ACI_Buff_list[spellId]) then
		return true;
	end

	if overlayspell[name] or overlayspell[spellId]  then
		return true;
	end

	return false;
end

local activeBuffs = {};




local function ProcessAura(aura, unit)
	if aura == nil or aura.icon == nil or unit == nil or not aura.isHelpful then
		return AuraUpdateChangedType.None;
	end

	if IsShown(aura.name, aura.spellId) then
		return AuraUpdateChangedType.None;
	end

	if ABF_BlackList[aura.name] then
		return AuraUpdateChangedType.None;
	end

	local skip = true;
	if unit == "target" then
		if UnitIsPlayer("target") then
			skip = true;
			if UnitCanAssist("target", "player") then
				-- 우리편은 내가 시전한 Buff 보임
				if PLAYER_UNITS[aura.sourceUnit] and aura.duration > 0 and aura.duration <= ABF_MAX_Cool then
					skip = false;
				end
			end

			if aura.isStealable then
				skip = false;
			end

			-- PVP 주요 버프는 보임
			if (ABF_PVPBuffList and ABF_PVPBuffList[aura.spellId]) then
				skip = false;
			end
		else
			skip = false;
		end
	elseif unit == "player" then
		skip = true;
		if PLAYER_UNITS[aura.sourceUnit] and ((aura.duration > 0 and aura.duration <= ABF_MAX_Cool)) then
			skip = false;
		end

		if PLAYER_UNITS[aura.sourceUnit] and ((aura.applications and aura.applications > 1)) then
			skip = false;
		end

		if PLAYER_UNITS[aura.sourceUnit] and aura.nameplateShowPersonal then
			skip = false;
		end

		if (ABF_PVPBuffList and ABF_PVPBuffList[aura.spellId]) then
			skip = false;
		end

		if ABF_ProcBuffList and ABF_ProcBuffList[aura.name] then
			skip = false;
		end
	end

	if skip == false then
		if aura.isBossAura and not aura.isRaid then
			aura.buffType = UnitFrameBuffType.BossBuff;
		elseif not PLAYER_UNITS[aura.sourceUnit] then
			aura.buffType = UnitFrameBuffType.Normal;
		elseif aura.nameplateShowPersonal then
			aura.buffType = UnitFrameBuffType.PriorityBuff;
		elseif IsShouldDisplayBuff(aura.spellId, aura.sourceUnit, aura.isFromPlayerOrPlayerPet) then
			aura.buffType = UnitFrameBuffType.Normal;
		elseif ABF_TalentBuffList[aura.name] == true or ABF_TalentBuffList[aura.icon] == true then
			aura.buffType = UnitFrameBuffType.TalentBuff;
		else
			aura.buffType = UnitFrameBuffType.Normal;
		end

		activeBuffs[unit][aura.auraInstanceID] = aura;
		return AuraUpdateChangedType.Buff;
	end


	return AuraUpdateChangedType.None;
end

local function ParseAllAuras(unit)
	if activeBuffs[unit] == nil then
		activeBuffs[unit] = TableUtil.CreatePriorityTable(UnitFrameBuffComparator,
			TableUtil.Constants.AssociativePriorityTable);
	else
		activeBuffs[unit]:Clear();
	end

	local function HandleAura(aura)
		ProcessAura(aura, unit);
		return false;
	end

	local batchCount = nil;
	local usePackedAura = true;
	ForEachAura(unit, filter, batchCount, HandleAura, usePackedAura);
end

local function updateTotemAura()
	local totem_i = 0;

	for slot = 1, MAX_TOTEMS do
		local haveTotem, name, start, duration, icon = GetTotemInfo(slot);

		if haveTotem and icon then
			if not (ACI_Buff_list and ACI_Buff_list[name]) then
				totem_i = totem_i + 1;
				local expirationTime = start + duration;
				local frame = ABF_TALENT_BUFF.frames[totem_i];

				-- set the icon
				local frameIcon = frame.icon;
				frameIcon:SetTexture(icon);
				frameIcon:SetAlpha(ABF_ALPHA);

				frame.totemslot = slot;
				frame.auraInstanceID = nil;

				-- set the count
				local frameCount = frame.count;
				-- Handle cooldowns
				local frameCooldown = frame.cooldown;

				frameCount:Hide();

				if (duration > 0 and duration <= 120) then
					frameCooldown:Show();
					asCooldownFrame_Set(frameCooldown, expirationTime - duration, duration, duration > 0, true);
					frameCooldown:SetHideCountdownNumbers(false);
				else
					frameCooldown:Hide();
				end

				local frameBorder = frame.border;

				local color = { r = 0, g = 1, b = 0 };

				frameBorder:SetVertexColor(color.r, color.g, color.b);
				frameBorder:SetAlpha(ABF_ALPHA);
				frame:Show();
			end
		else
			return totem_i + 1;
		end
	end

	return totem_i + 1;
end

local function UpdateAuraFrames(unit, auraList)
	local i = 0;
	local parent = ABF_TARGET_BUFF;
	local numAuras = math.min(ABF_MAX_BUFF_SHOW, auraList:Size());
	local tcount = 1;
	local lcount = 1;
	local mparent = nil;

	if (unit == "player") then
		tcount = updateTotemAura();
		parent = ABF_PLAYER_BUFF;
		mparent = ABF_TALENT_BUFF;
		numAuras = math.min(ABF_MAX_BUFF_SHOW * 2, auraList:Size());
	end


	auraList:Iterate(
		function(auraInstanceID, aura)
			i = i + 1;
			if i > numAuras then
				return true;
			end

			local frame = nil;

			if mparent then
				if mparent and aura.buffType ~= UnitFrameBuffType.Normal and tcount <= ABF_MAX_BUFF_SHOW then
					frame = mparent.frames[tcount];
					tcount = tcount + 1;
				elseif mparent and lcount <= ABF_MAX_BUFF_SHOW then
					frame = parent.frames[lcount];
					lcount = lcount + 1;
				else
					return true;
				end
			else
				frame = parent.frames[i];
			end

			frame.unit = unit;
			frame.auraInstanceID = aura.auraInstanceID;
			frame.totemslot = nil;

			-- set the icon
			local frameIcon = frame.icon
			frameIcon:SetTexture(aura.icon);
			frameIcon:SetAlpha(ABF_ALPHA);
			-- set the count
			local frameCount = frame.count;

			-- Handle cooldowns
			local frameCooldown = frame.cooldown;

			if (aura.applications and aura.applications > 1) then
				frameCount:SetText(aura.applications);
				frameCount:Show();
				frameCooldown:SetDrawSwipe(false);
			else
				frameCount:Hide();
				frameCooldown:SetDrawSwipe(true);
			end

			if (aura.duration > 0) then
				frameCooldown:Show();
				asCooldownFrame_Set(frameCooldown, aura.expirationTime - aura.duration, aura.duration, aura.duration > 0,
					true);
				frameCooldown:SetHideCountdownNumbers(false);
			else
				frameCooldown:Hide();
			end

			local frameBorder = frame.border;
			local color = DebuffTypeColor["Disease"];
			frameBorder:SetVertexColor(color.r, color.g, color.b);
			frameBorder:SetAlpha(ABF_ALPHA);

			if (aura.isStealable) or (ABF_ProcBuffList and ABF_ProcBuffList[aura.name] and ABF_ProcBuffList[aura.name] == 1) then
				ns.lib.ButtonGlow_Start(frame);
			else
				ns.lib.ButtonGlow_Stop(frame);

				if aura.nameplateShowPersonal then
					ns.lib.PixelGlow_Start(frame);
				else
					ns.lib.PixelGlow_Stop(frame);
				end
			end

			frame:Show();
			return false;
		end);

	local function HideFrame(p, idx)
		local frame = p.frames[idx];

		if (frame) then
			frame:Hide();
			ns.lib.ButtonGlow_Stop(frame);
			ns.lib.PixelGlow_Stop(frame);
		end
	end


	if mparent then
		for j = tcount, ABF_MAX_BUFF_SHOW do
			HideFrame(mparent, j);
		end
		for j = lcount, ABF_MAX_BUFF_SHOW do
			HideFrame(parent, j);
		end
	else
		for j = i + 1, ABF_MAX_BUFF_SHOW do
			HideFrame(parent, j);
		end
	end
end


local function UpdateAuras(unitAuraUpdateInfo, unit)
	local buffsChanged = false;

	if unitAuraUpdateInfo == nil or unitAuraUpdateInfo.isFullUpdate or activeBuffs[unit] == nil then
		ParseAllAuras(unit);
		buffsChanged = true;
	else
		if unitAuraUpdateInfo.addedAuras ~= nil then
			for _, aura in ipairs(unitAuraUpdateInfo.addedAuras) do
				local type = ProcessAura(aura, unit);
				if type == AuraUpdateChangedType.Buff then
					buffsChanged = true;
				end
			end
		end

		if unitAuraUpdateInfo.updatedAuraInstanceIDs ~= nil then
			for _, auraInstanceID in ipairs(unitAuraUpdateInfo.updatedAuraInstanceIDs) do
				local newAura = C_UnitAuras.GetAuraDataByAuraInstanceID(unit, auraInstanceID);
				activeBuffs[unit][auraInstanceID] = nil;
				local type = ProcessAura(newAura, unit);
				if type == AuraUpdateChangedType.Buff then
					buffsChanged = true;
				end
			end
		end

		if unitAuraUpdateInfo.removedAuraInstanceIDs ~= nil then
			for _, auraInstanceID in ipairs(unitAuraUpdateInfo.removedAuraInstanceIDs) do
				if activeBuffs[unit][auraInstanceID] ~= nil then
					activeBuffs[unit][auraInstanceID] = nil;
					buffsChanged = true;
				end
			end
		end
	end

	if not buffsChanged then
		return;
	end

	UpdateAuraFrames(unit, activeBuffs[unit]);
end



local function ABF_ClearFrame()
	local parent = ABF_TARGET_BUFF;

	for i = 1, ABF_MAX_BUFF_SHOW do
		local frame = parent.frames[i];

		if (frame) then
			frame:Hide();
			ns.lib.ButtonGlow_Stop(frame);
			ns.lib.PixelGlow_Stop(frame);
		else
			break;
		end
	end
end


local function ABF_OnEvent(self, event, arg1, ...)
	if (event == "PLAYER_TARGET_CHANGED") then
		ABF_ClearFrame();
		ABF:RegisterUnitEvent("UNIT_AURA", "target");
		UpdateAuras(nil, "target");
	elseif (event == "UNIT_AURA") then
		local unitAuraUpdateInfo = ...;
		UpdateAuras(unitAuraUpdateInfo, arg1);
	elseif (event == "PLAYER_TOTEM_UPDATE") then
		if activeBuffs["player"] == nil then
			UpdateAuras(nil, "player");
		else
			UpdateAuraFrames("player", activeBuffs["player"]);
		end		
	elseif event == "PLAYER_ENTERING_WORLD" then
		hasValidPlayer = true;
		asCheckTalent();		
		UpdateAuras(nil, "player");
		UpdateAuras(nil, "target");
	elseif event == "PLAYER_REGEN_DISABLED" then
		ABF:SetAlpha(ABF_AlphaCombat);
		DumpCaches();
	elseif event == "PLAYER_REGEN_ENABLED" then
		ABF:SetAlpha(ABF_AlphaNormal);
		DumpCaches();
	elseif (event == "PLAYER_SPECIALIZATION_CHANGED") then
		overlayspell = {};
		asCheckTalent();
	elseif (event == "SPELL_ACTIVATION_OVERLAY_SHOW") then
		if Settings.GetValue("spellActivationOverlayOpacity") and Settings.GetValue("spellActivationOverlayOpacity") > 0 then
			local name = GetSpellInfo(arg1);
			overlayspell[arg1] = true;
			overlayspell[name] = true;
		end
		overlayspell[arg1] = true;
	elseif (event == "SPELL_ACTIVATION_OVERLAY_HIDE") then
	elseif (event == "PLAYER_LEAVING_WORLD") then
		hasValidPlayer = false;
	end
end

local function ABF_UpdateBuffAnchor(frames, index, offsetX, right, center, parent)
	local buff = frames[index];
	buff:ClearAllPoints();

	if center then
		if (index == 1) then
			buff:SetPoint("TOP", parent, "CENTER", 0, 0);
		elseif (index == 2) then
			buff:SetPoint("RIGHT", frames[index - 1], "LEFT", -offsetX, 0);
		elseif (math.fmod(index, 2) == 1) then
			buff:SetPoint("LEFT", frames[index - 2], "RIGHT", offsetX, 0);
		else
			buff:SetPoint("RIGHT", frames[index - 2], "LEFT", -offsetX, 0);
		end
	else
		local point1 = "TOPLEFT";
		local point2 = "CENTER";
		local point3 = "TOPRIGHT";

		if (right == false) then
			point1 = "TOPRIGHT";
			point2 = "CENTER";
			point3 = "TOPLEFT";
			offsetX = -offsetX;
		end

		if (index == 1) then
			buff:SetPoint(point1, parent, point2, 0, 0);
		else
			buff:SetPoint(point1, frames[index - 1], point3, offsetX, 0);
		end
	end
	-- Resize
	buff:SetWidth(ABF_SIZE);
	buff:SetHeight(ABF_SIZE * 0.8);
end

local function CreatBuffFrames(parent, bright, bcenter)
	if parent.frames == nil then
		parent.frames = {};
	end

	for idx = 1, ABF_MAX_BUFF_SHOW do
		parent.frames[idx] = CreateFrame("Button", nil, parent, "asTargetBuffFrameTemplate");
		local frame = parent.frames[idx];
		frame:SetFrameStrata("LOW");
		frame:EnableMouse(false);
		frame.cooldown:SetFrameStrata("MEDIUM");
		for _, r in next, { frame.cooldown:GetRegions() } do
			if r:GetObjectType() == "FontString" then
				r:SetFont(STANDARD_TEXT_FONT, ABF_CooldownFontSize, "OUTLINE");
				r:ClearAllPoints();
				r:SetPoint("TOP", 0, 5);
				break
			end
		end

		local font, size, flag = frame.count:GetFont()

		frame.count:SetFont(STANDARD_TEXT_FONT, ABF_CountFontSize, "OUTLINE")
		frame.count:ClearAllPoints()
		frame.count:SetPoint("BOTTOMRIGHT", -2, 2);

		frame.icon:SetTexCoord(.08, .92, .08, .92);
		frame.border:SetTexture("Interface\\Addons\\asDebuffFilter\\border.tga");
		frame.border:SetTexCoord(0.08, 0.08, 0.08, 0.92, 0.92, 0.08, 0.92, 0.92);

		ABF_UpdateBuffAnchor(parent.frames, idx, 1, bright, bcenter, parent);

		if not frame:GetScript("OnEnter") then
			frame:SetScript("OnEnter", function(s)
				if s.auraInstanceID then
					GameTooltip_SetDefaultAnchor(GameTooltip, s);
					GameTooltip:SetUnitBuffByAuraInstanceID(s.unit, s.auraInstanceID, filter);
				elseif s.totemslot then
					GameTooltip_SetDefaultAnchor(GameTooltip, s);
					GameTooltip:SetTotem(s.totemslot)
				end
			end)
			frame:SetScript("OnLeave", function()
				GameTooltip:Hide();
			end)
		end

		frame:Hide();
	end

	return;
end

local function ABF_Init()
	ABF = CreateFrame("Frame", nil, UIParent)

	ABF:SetPoint("CENTER", 0, 0)
	ABF:SetWidth(1)
	ABF:SetHeight(1)
	ABF:SetScale(1)
	ABF:SetAlpha(ABF_AlphaNormal);
	ABF:Show()


	local bloaded = LoadAddOn("asMOD")

	ABF_TARGET_BUFF = CreateFrame("Frame", nil, ABF)

	ABF_TARGET_BUFF:SetPoint("CENTER", ABF_TARGET_BUFF_X, ABF_TARGET_BUFF_Y)
	ABF_TARGET_BUFF:SetWidth(1)
	ABF_TARGET_BUFF:SetHeight(1)
	ABF_TARGET_BUFF:SetScale(1)
	ABF_TARGET_BUFF:Show()

	CreatBuffFrames(ABF_TARGET_BUFF, true, false);

	if bloaded and asMOD_setupFrame then
		asMOD_setupFrame(ABF_TARGET_BUFF, "asBuffFilter(Target)");
	end

	ABF_PLAYER_BUFF = CreateFrame("Frame", nil, ABF)

	ABF_PLAYER_BUFF:SetPoint("CENTER", ABF_PLAYER_BUFF_X, ABF_PLAYER_BUFF_Y)
	ABF_PLAYER_BUFF:SetWidth(1)
	ABF_PLAYER_BUFF:SetHeight(1)
	ABF_PLAYER_BUFF:SetScale(1)
	ABF_PLAYER_BUFF:Show()

	CreatBuffFrames(ABF_PLAYER_BUFF, false, false);

	if bloaded and asMOD_setupFrame then
		asMOD_setupFrame(ABF_PLAYER_BUFF, "asBuffFilter(Player)");
	end

	ABF_TALENT_BUFF = CreateFrame("Frame", nil, ABF)

	ABF_TALENT_BUFF:SetPoint("CENTER", 0, ABF_PLAYER_BUFF_Y)
	ABF_TALENT_BUFF:SetWidth(1)
	ABF_TALENT_BUFF:SetHeight(1)
	ABF_TALENT_BUFF:SetScale(1)

	ABF_TALENT_BUFF:Show()

	CreatBuffFrames(ABF_TALENT_BUFF, false, true);

	if bloaded and asMOD_setupFrame then
		asMOD_setupFrame(ABF_TALENT_BUFF, "asBuffFilter(Talent)");
	end


	ABF:RegisterEvent("PLAYER_TARGET_CHANGED")
	ABF_TARGET_BUFF:RegisterUnitEvent("UNIT_AURA", "target")
	ABF_PLAYER_BUFF:RegisterUnitEvent("UNIT_AURA", "player");
	ABF:RegisterEvent("PLAYER_ENTERING_WORLD");
	ABF:RegisterEvent("PLAYER_LEAVING_WORLD");
	ABF:RegisterEvent("PLAYER_REGEN_DISABLED");
	ABF:RegisterEvent("PLAYER_REGEN_ENABLED");
	ABF:RegisterEvent("PLAYER_TOTEM_UPDATE");
	ABF:RegisterEvent("PLAYER_SPECIALIZATION_CHANGED");


	bloaded = LoadAddOn("asOverlay")
	if bloaded then
		ABF:RegisterEvent("SPELL_ACTIVATION_OVERLAY_SHOW");
		ABF:RegisterEvent("SPELL_ACTIVATION_OVERLAY_HIDE");
	end


	ABF:SetScript("OnEvent", ABF_OnEvent)
	ABF_TARGET_BUFF:SetScript("OnEvent", ABF_OnEvent)
	ABF_PLAYER_BUFF:SetScript("OnEvent", ABF_OnEvent)
end

ABF_Init();
