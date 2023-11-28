local _, ns = ...;


local ACRB_MAX_BUFFS = 6           -- 최대 표시 버프 개수 (3개 + 3개)
local ACRB_MAX_BUFFS_2 = 2         -- 최대 생존기 개수
local ACRB_MAX_DEBUFFS = 3         -- 최대 표시 디버프 개수 (3개)
local ACRB_MAX_DISPELDEBUFFS = 3   -- 최대 해제 디버프 개수 (3개)

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

local UnitFrameDebuffType = EnumUtil.MakeEnum(
	"NonBossDebuff",
	"NonBossRaidDebuff",
	"PriorityDebuff",
	"namePlateShowAll",
	"BossBuff",
	"BossDebuff"
);

local UnitFrameBuffType = EnumUtil.MakeEnum(
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

	return a.auraInstanceID < b.auraInstanceID;
end

local function UnitFrameDebuffComparator(a, b)
	if a.debuffType ~= b.debuffType then
		return a.debuffType > b.debuffType;
	end

	return DefaultAuraCompare(a, b);
end

local function UnitFrameBuffComparator(a, b)
	if a.debuffType ~= b.debuffType then
		return a.debuffType > b.debuffType;
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



ns.debufffilter = CreateFilterString(AuraFilters.Harmful);
ns.bufffilter = CreateFilterString(AuraFilters.Helpful);


local cachedVisualizationInfo = {};
ns.hasValidPlayer = false;

local function GetCachedVisibilityInfo(spellId)
	if cachedVisualizationInfo[spellId] == nil then
		local newInfo = {
			SpellGetVisibilityInfo(spellId, UnitAffectingCombat("player") and "RAID_INCOMBAT" or "RAID_OUTOFCOMBAT") };
		if not ns.hasValidPlayer then
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

-- 버프 설정 부
local function ShouldDisplayBuff(aura)
	local unitCaster = aura.sourceUnit;
	local spellId = aura.spellId;
	local canApplyAura = aura.canApplyAura;

	local hasCustom, alwaysShowMine, showForMySpec = GetCachedVisibilityInfo(spellId);

	if (hasCustom) then
		return showForMySpec or
			(alwaysShowMine and (unitCaster == "player" or unitCaster == "pet" or unitCaster == "vehicle"));
	else
		return (unitCaster == "player" or unitCaster == "pet" or unitCaster == "vehicle") and ((canApplyAura and
			not CheckIsSelfBuff(spellId)));
	end
end

local cachedPriorityChecks = {};
local function CheckIsPriorityAura(spellId)
	if cachedPriorityChecks[spellId] == nil then
		cachedPriorityChecks[spellId] = SpellIsPriorityAura(spellId);
	end

	return cachedPriorityChecks[spellId];
end


local function IsPriorityDebuff(spellId)
	local _, classFilename = UnitClass("player");
	if (classFilename == "PALADIN") then
		local isForbearance = (spellId == 25771);
		return isForbearance or CheckIsPriorityAura(spellId);
	else
		return CheckIsPriorityAura(spellId);
	end
end

local function ShouldDisplayDebuff(aura)
	local unitCaster = aura.sourceUnit;
	local spellId = aura.spellId;

	local hasCustom, alwaysShowMine, showForMySpec = GetCachedVisibilityInfo(spellId);
	if (hasCustom) then
		return showForMySpec or
			(alwaysShowMine and (unitCaster == "player" or unitCaster == "pet" or unitCaster == "vehicle"));
		--Would only be "mine" in the case of something like forbearance.
	else
		return true;
	end
end

--cooldown
local function asCooldownFrame_Clear(self)
	self:Clear();
end
--cooldown
function ns.asCooldownFrame_Set(self, start, duration, enable, forceShowDrawEdge, modRate)
	if enable and enable ~= 0 and start > 0 and duration > 0 then
		self:SetDrawEdge(forceShowDrawEdge);
		self:SetCooldown(start, duration, modRate);
	else
		asCooldownFrame_Clear(self);
	end
end

function ns.DumpCaches()
	cachedVisualizationInfo = {};
	cachedSelfBuffChecks = {};
	cachedPriorityChecks = {};	
end

-- 버프 설정 부
local function ACRB_UtilSetDispelDebuff(dispellDebuffFrame, aura)
	dispellDebuffFrame:Show();
	dispellDebuffFrame.icon:SetTexture("Interface\\RaidFrame\\Raid-Icon-Debuff" .. aura.dispelName);
	dispellDebuffFrame.auraInstanceID = aura.auraInstanceID;
end




local function ARCB_UtilSetBuff(buffFrame, aura)
	buffFrame.icon:SetTexture(aura.icon);
	if (aura.applications > 1) then
		local countText = aura.applications;
		if (aura.applications >= 100) then
			countText = BUFF_STACKS_OVERFLOW;
		end
		buffFrame.count:Show();
		buffFrame.count:SetText(countText);
	else
		buffFrame.count:Hide();
	end
	buffFrame.auraInstanceID = aura.auraInstanceID;
	local enabled = aura.expirationTime and aura.expirationTime ~= 0;
	if enabled then
		local startTime = aura.expirationTime - aura.duration;
		ns.asCooldownFrame_Set(buffFrame.cooldown, startTime, aura.duration, true);
	else
		asCooldownFrame_Clear(buffFrame.cooldown);
	end

	if ns.ACRB_ShowAlert and ns.ACRB_ShowList then
		local showlist_time = 0;

		if ns.ACRB_ShowList[aura.name] then
			showlist_time = ns.ACRB_ShowList[aura.name][1];
			if showlist_time == 1 then
				ns.ACRB_ShowList[aura.name][1] = aura.duration * 0.3;
			end
		end

		if showlist_time > 0 and aura.expirationTime - GetTime() < showlist_time then
			buffFrame.border:SetVertexColor(1, 1, 1);
		else
			buffFrame.border:SetVertexColor(0, 0, 0);
		end
	end

	buffFrame:Show();
end


-- Debuff 설정 부
local function ACRB_UtilSetDebuff(debuffFrame, aura)
	debuffFrame.filter = aura.isRaid and AuraFilters.Raid or nil;
	debuffFrame.icon:SetTexture(aura.icon);
	if (aura.applications > 1) then
		local countText = aura.applications;
		if (aura.applications >= 100) then
			countText = BUFF_STACKS_OVERFLOW;
		end
		debuffFrame.count:Show();
		debuffFrame.count:SetText(countText);
	else
		debuffFrame.count:Hide();
	end
	debuffFrame.auraInstanceID = aura.auraInstanceID;
	local enabled = aura.expirationTime and aura.expirationTime ~= 0;
	if enabled then
		local startTime = aura.expirationTime - aura.duration;
		ns.asCooldownFrame_Set(debuffFrame.cooldown, startTime, aura.duration, true);
	else
		asCooldownFrame_Clear(debuffFrame.cooldown);
	end

	local color = DebuffTypeColor[aura.dispelName] or DebuffTypeColor["none"];
	debuffFrame.border:SetVertexColor(color.r, color.g, color.b);

	debuffFrame.isBossBuff = aura.isBossAura and aura.isHelpful;
	if (aura.isBossAura or (aura.nameplateShowAll and aura.duration > 0 and aura.duration < 10)) then
		debuffFrame:SetSize((debuffFrame.size_x) * 1.3, debuffFrame.size_y * 1.3);
		debuffFrame.cooldown:SetHideCountdownNumbers(false);
	else
		debuffFrame:SetSize(debuffFrame.size_x, debuffFrame.size_y);
		debuffFrame.cooldown:SetHideCountdownNumbers(true);
	end

	debuffFrame:Show();
end


local function ProcessAura(aura)
	if aura == nil then
		return AuraUpdateChangedType.None;
	end

	if aura.isNameplateOnly then
		return AuraUpdateChangedType.None;
	end

	if ns.ACRB_BlackList and ns.ACRB_BlackList[aura.name] then
		return AuraUpdateChangedType.None;
	end

	if aura.isBossAura and not aura.isRaid then
		aura.debuffType = aura.isHarmful and UnitFrameDebuffType.BossDebuff or
			UnitFrameDebuffType.BossBuff;
		return AuraUpdateChangedType.Debuff;
	elseif aura.isHarmful then
		if not aura.isRaid then
			if aura.nameplateShowAll then
				aura.debuffType = UnitFrameDebuffType.namePlateShowAll;
				return AuraUpdateChangedType.Debuff;
			elseif IsPriorityDebuff(aura.spellId) then
				aura.debuffType = UnitFrameDebuffType.PriorityDebuff;
				return AuraUpdateChangedType.Debuff;
			elseif ShouldDisplayDebuff(aura) then
				aura.debuffType = UnitFrameDebuffType.NonBossDebuff;
				return AuraUpdateChangedType.Debuff;
			end
		else --aura.isRaid
			if DispellableDebuffTypes[aura.dispelName] ~= nil then
				aura.debuffType = aura.isBossAura and UnitFrameDebuffType.BossDebuff or
					UnitFrameDebuffType.NonBossRaidDebuff;
				return AuraUpdateChangedType.Dispel;
			end
		end
	elseif aura.isHelpful then
		local showlist = ns.ACRB_ShowList and ns.ACRB_ShowList[aura.name];
		if showlist and PLAYER_UNITS[aura.sourceUnit] then
			aura.debuffType = UnitFrameBuffType.Normal + showlist[2];
			return AuraUpdateChangedType.Buff;
		elseif ShouldDisplayBuff(aura) then
			aura.debuffType = UnitFrameBuffType.Normal;
			return AuraUpdateChangedType.Buff;
		elseif ns.ACRB_PVPBuffList[aura.spellId] then
			aura.debuffType = UnitFrameBuffType.Normal;
			return AuraUpdateChangedType.PVP;
		end
	end

	return AuraUpdateChangedType.None;
end


local function ACRB_ParseAllAuras(asframe)
	if asframe.debuffs == nil then
		asframe.debuffs = TableUtil.CreatePriorityTable(UnitFrameDebuffComparator,
			TableUtil.Constants.AssociativePriorityTable);
		asframe.buffs = TableUtil.CreatePriorityTable(UnitFrameBuffComparator,
			TableUtil.Constants.AssociativePriorityTable);
		asframe.pvpbuffs = TableUtil.CreatePriorityTable(DefaultAuraCompare, TableUtil.Constants
			.AssociativePriorityTable);
		asframe.dispels = {};
		for type, _ in pairs(DispellableDebuffTypes) do
			asframe.dispels[type] = TableUtil.CreatePriorityTable(DefaultAuraCompare,
				TableUtil.Constants.AssociativePriorityTable);
		end
	else
		asframe.debuffs:Clear();
		asframe.buffs:Clear();
		asframe.pvpbuffs:Clear();
		for type, _ in pairs(DispellableDebuffTypes) do
			asframe.dispels[type]:Clear();
		end
	end

	local batchCount = nil;
	local usePackedAura = true;
	local function HandleAura(aura)
		local type = ProcessAura(aura);

		if type == AuraUpdateChangedType.Debuff then
			asframe.debuffs[aura.auraInstanceID] = aura;
		elseif type == AuraUpdateChangedType.Buff then
			asframe.buffs[aura.auraInstanceID] = aura;
		elseif type == AuraUpdateChangedType.PVP then
			asframe.pvpbuffs[aura.auraInstanceID] = aura;
		elseif type == AuraUpdateChangedType.Dispel then
			asframe.dispels[aura.dispelName][aura.auraInstanceID] = aura;
			asframe.debuffs[aura.auraInstanceID] = aura;
		end
	end
	ForEachAura(asframe.displayedUnit, ns.bufffilter, batchCount, HandleAura, usePackedAura);
	ForEachAura(asframe.displayedUnit, ns.debufffilter, batchCount, HandleAura, usePackedAura);
end

function ns.UpdateNameColor(frame)
	if not frame or frame:IsForbidden() then
		return
	end

	local frameName = frame:GetName()
	local asframe = (frameName and asraid[frameName]) or nil;

	if asframe == nil or not asframe.buffcolor then
		return;
	end

	if asframe.buffcolor:IsShown() then
		local class = select(2, UnitClass(frame.unit));
		local classColor = class and RAID_CLASS_COLORS[class] or nil;
		if classColor then
			frame.name:SetVertexColor(classColor.r, classColor.g, classColor.b);
		end
	else
		frame.name:SetVertexColor(1.0, 1.0, 1.0);
	end
end

function ns.ACRB_UpdateAuras(asframe)
	local debuffsChanged = true;
	local buffsChanged = true;
	local pvpbuffsChanged = true;
	local dispelsChanged = true;

	ACRB_ParseAllAuras(asframe);

	if debuffsChanged then
		local frameNum = 1;
		local maxDebuffs = ACRB_MAX_DEBUFFS;
		asframe.debuffs:Iterate(function(auraInstanceID, aura)
			if frameNum > maxDebuffs then
				return true;
			end

			local debuffFrame = asframe.asdebuffFrames[frameNum];
			ACRB_UtilSetDebuff(debuffFrame, aura);
			frameNum = frameNum + 1;

			if aura.isBossAura or (aura.nameplateShowAll and aura.duration > 0 and aura.duration < 10) then
				maxDebuffs = maxDebuffs - 1;
			end

			return false;
		end);

		for i = frameNum, ACRB_MAX_DEBUFFS do
			local debuffFrame = asframe.asdebuffFrames[i];
			debuffFrame:Hide();
		end
	end

	if buffsChanged then
		local frameNum = 1;
		local frameIdx = 1;
		local frameIdx2 = 4;
		local showframe = {};
		asframe.buffs:Iterate(function(auraInstanceID, aura)
			if frameNum > ACRB_MAX_BUFFS + 1 then
				return true;
			end

			local type = 1;

			if ns.ACRB_ShowList and ns.ACRB_ShowList[aura.name] and ns.ACRB_ShowList[aura.name][2] then
				type = ns.ACRB_ShowList[aura.name][2];
			end

			if type == 6 and not showframe[type] then
				local buffFrame = asframe.asbuffFrames[type];
				asframe.buffcolor:Show();
				ns.UpdateNameColor(asframe.frame);
				ARCB_UtilSetBuff(buffFrame, aura);
				showframe[type] = true;
			elseif type > 3 and not showframe[frameIdx2] then
				local buffFrame = asframe.asbuffFrames[frameIdx2];
				ARCB_UtilSetBuff(buffFrame, aura);
				showframe[frameIdx2] = true;
				frameIdx2 = frameIdx2 + 1;
			else
				local buffFrame = asframe.asbuffFrames[frameIdx];
				ARCB_UtilSetBuff(buffFrame, aura);
				frameIdx = frameIdx + 1;
			end

			frameNum = frameNum + 1;
			return false;
		end);

		for i = frameIdx, ACRB_MAX_BUFFS - 3 do
			local buffFrame = asframe.asbuffFrames[i];
			buffFrame:Hide();
		end

		for i = ACRB_MAX_BUFFS - 2, ACRB_MAX_BUFFS do
			if not showframe[i] then
				local buffFrame = asframe.asbuffFrames[i];
				if i == 6 then
					asframe.buffcolor:Hide();
					ns.UpdateNameColor(asframe.frame);
				end
				buffFrame:Hide();
			end
		end
	end

	if pvpbuffsChanged then
		local frameNum = 1;
		local maxBuffs = ACRB_MAX_BUFFS_2;
		asframe.pvpbuffs:Iterate(function(auraInstanceID, aura)
			if frameNum > maxBuffs then
				return true;
			end

			local buffFrame = asframe.pvpbuffFrames[frameNum];
			ARCB_UtilSetBuff(buffFrame, aura);
			frameNum = frameNum + 1;

			return false;
		end);

		for i = frameNum, ACRB_MAX_BUFFS_2 do
			local buffFrame = asframe.pvpbuffFrames[i];
			if buffFrame then
				buffFrame:Hide();
			end
		end
	end

	if dispelsChanged then
		local frameNum = 1;
		local showdispell = false;

		for _, auraTbl in pairs(asframe.dispels) do
			if frameNum > ACRB_MAX_DISPELDEBUFFS then
				break;
			end

			if auraTbl:Size() ~= 0 then
				local aura = auraTbl:GetTop();
				local dispellDebuffFrame = asframe.asdispelDebuffFrames[frameNum];
				ACRB_UtilSetDispelDebuff(dispellDebuffFrame, aura);
				frameNum = frameNum + 1;

				local color = DebuffTypeColor[aura.dispelName] or DebuffTypeColor["none"];

				if not asframe.isDispellAlert then
					ns.lib.PixelGlow_Start(asframe.frame, { color.r, color.g, color.b, 1 })
					asframe.isDispellAlert = true;
				end
				showdispell = true;
			end
		end
		for i = frameNum, ACRB_MAX_DISPELDEBUFFS do
			local dispellDebuffFrame = asframe.asdispelDebuffFrames[i];
			dispellDebuffFrame:Hide();
		end

		if showdispell == false then
			if asframe.isDispellAlert then
				ns.lib.PixelGlow_Stop(asframe.frame);
				asframe.isDispellAlert = false;
			end
		end
	end
end
