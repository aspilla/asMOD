local _, ns = ...;

local ACRB_MAX_BUFFS = 6           -- 최대 표시 버프 개수 (3개 + 3개)
local ACRB_MAX_BUFFS_2 = 2         -- 최대 생존기 개수
local ACRB_MAX_DEBUFFS = 3         -- 최대 표시 디버프 개수 (3개)
local ACRB_MAX_DISPELDEBUFFS = 3   -- 최대 해제 디버프 개수 (3개)
local ACRB_MAX_CASTING = 2         -- 최대 Casting Alert
local ACRB_MaxBuffSize = 20        -- 최대 Buff Size 창을 늘려도 이 크기 이상은 안커짐
local ACRB_HealerManaBarHeight = 3 -- 힐러 마나바 크기 (안보이게 하려면 0)


--Overlay stuff

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
	"BossDebuff",
	"BossBuff",
	"namePlateShowAll",
	"PriorityDebuff",
	"NonBossRaidDebuff",
	"NonBossDebuff"
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
		return a.debuffType < b.debuffType;
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



local debufffilter = CreateFilterString(AuraFilters.Harmful);
local bufffilter = CreateFilterString(AuraFilters.Helpful);


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
local function asCooldownFrame_Set(self, start, duration, enable, forceShowDrawEdge, modRate)
	if enable and enable ~= 0 and start > 0 and duration > 0 then
		self:SetDrawEdge(forceShowDrawEdge);
		self:SetCooldown(start, duration, modRate);
	else
		asCooldownFrame_Clear(self);
	end
end


local ACRB_mainframe = CreateFrame("Frame", nil, UIParent);

-- 직업 리필
local ACRB_ShowList = nil;
local asraid = {};

local function ACRB_InitList()
	local spec = GetSpecialization();
	local localizedClass, englishClass = UnitClass("player")
	local listname;

	ACRB_ShowList = nil;

	if spec then
		listname = "ACRB_ShowList_" .. englishClass .. "_" .. spec;
	end

	ACRB_ShowList = ns[listname];
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
		asCooldownFrame_Set(buffFrame.cooldown, startTime, aura.duration, true);
	else
		asCooldownFrame_Clear(buffFrame.cooldown);
	end

	if ns.ACRB_ShowAlert and ACRB_ShowList then
		local showlist_time = 0;

		if ACRB_ShowList[aura.name] then
			showlist_time = ACRB_ShowList[aura.name][1];
			if showlist_time == 1 then
				ACRB_ShowList[aura.name][1] = aura.duration * 0.3;
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
		asCooldownFrame_Set(debuffFrame.cooldown, startTime, aura.duration, true);
	else
		asCooldownFrame_Clear(debuffFrame.cooldown);
	end

	local color = DebuffTypeColor[aura.dispelName] or DebuffTypeColor["none"];
	debuffFrame.border:SetVertexColor(color.r, color.g, color.b);

	debuffFrame.isBossBuff = aura.isBossAura and aura.isHelpful;
	if (aura.isBossAura or aura.nameplateShowAll) then
		debuffFrame:SetSize((debuffFrame.size_x) * 1.3, debuffFrame.size_y * 1.3);
	else
		debuffFrame:SetSize(debuffFrame.size_x, debuffFrame.size_y);
	end

	debuffFrame:Show();
end

-- 해제 디버프
local function ACRB_UpdateHealerMana(asframe)
	if (not asframe.asManabar) then
		return;
	end

	--마나는 unit으로만
	local unit = asframe.unit

	if not (unit) then
		return;
	end

	local role = UnitGroupRolesAssigned(unit)

	if role and role == "HEALER" then
		asframe.asManabar:SetMinMaxValues(0, UnitPowerMax(unit, Enum.PowerType.Mana))
		asframe.asManabar:SetValue(UnitPower(unit, Enum.PowerType.Mana));

		local info = PowerBarColor["MANA"];
		if (info) then
			local r, g, b = info.r, info.g, info.b;
			asframe.asManabar:SetStatusBarColor(r, g, b);
		end

		asframe.asManabar:Show();
	else
		asframe.asManabar:Hide();
	end
end

local RaidIconList = {
	"|TInterface\\TargetingFrame\\UI-RaidTargetingIcon_1:",
	"|TInterface\\TargetingFrame\\UI-RaidTargetingIcon_2:",
	"|TInterface\\TargetingFrame\\UI-RaidTargetingIcon_3:",
	"|TInterface\\TargetingFrame\\UI-RaidTargetingIcon_4:",
	"|TInterface\\TargetingFrame\\UI-RaidTargetingIcon_5:",
	"|TInterface\\TargetingFrame\\UI-RaidTargetingIcon_6:",
	"|TInterface\\TargetingFrame\\UI-RaidTargetingIcon_7:",
	"|TInterface\\TargetingFrame\\UI-RaidTargetingIcon_8:",
}




local function ACRB_UpdateRaidIconAborbColor(asframe)
	local unit = asframe.unit

	if asframe.displayedUnit and asframe.displayedUnit ~= unit then
		unit = asframe.displayedUnit;
	end


	if not (unit) then
		return;
	end

	local function ACRB_DisplayRaidIcon(unit)
		local icon = GetRaidTargetIndex(unit)
		if icon and RaidIconList[icon] then
			return RaidIconList[icon] .. "0|t"
		else
			return ""
		end
	end


	if (asframe.asraidicon) then
		local text = ACRB_DisplayRaidIcon(unit);
		asframe.asraidicon:SetText(text);
		asframe.asraidicon:Show();
	end

	if (asframe.aborbcolor) then
		local value = UnitHealth(unit);
		local valueMax = UnitHealthMax(unit);
		local totalAbsorb = UnitGetTotalAbsorbs(unit) or 0;
		local remainAbsorb = totalAbsorb - (valueMax - value);

		if remainAbsorb > 0 then
			local totalWidth, _ = asframe.frame.healthBar:GetSize();
			local barSize = (remainAbsorb / valueMax) * totalWidth;

			asframe.aborbcolor:SetWidth(barSize);
			asframe.aborbcolor:Show();
		else
			asframe.aborbcolor:Hide();
		end
	end
end

local tanklist = {};
-- 탱커 처리부
local function updateTankerList()
	local _, RTB_ZoneType = IsInInstance();

	if RTB_ZoneType == "pvp" or RTB_ZoneType == "arena" then
		return nil;
	end

	tanklist = {};
	if IsInGroup() then
		for framename, asframe in pairs(asraid) do
			if asframe and asframe.frame and asframe.frame:IsShown() and asframe.unit then
				local assignedRole = UnitGroupRolesAssigned(asframe.unit);
				if assignedRole == "TANK" or assignedRole == "MAINTANK" then
					table.insert(tanklist, framename);
				end
			end
		end
	end
end


local function ACRB_disableDefault(frame)
	if frame and not frame:IsForbidden() then
		-- 거리 기능 충돌 때문에 안됨
		--frame.optionTable.fadeOutOfRange = false;
		frame:UnregisterEvent("UNIT_AURA");
		frame:UnregisterEvent("PLAYER_REGEN_ENABLED");
		frame:UnregisterEvent("PLAYER_REGEN_DISABLED");

		do
			if frame.buffFrames then
				for i = 1, #frame.buffFrames do
					frame.buffFrames[i]:SetAlpha(0);
					frame.buffFrames[i]:Hide();
				end
			end
		end

		do
			if frame.debuffFrames then
				for i = 1, #frame.debuffFrames do
					frame.debuffFrames[i]:SetAlpha(0);
					frame.debuffFrames[i]:Hide();
				end
			end
		end

		do
			if frame.dispelDebuffFrames then
				for i = 1, #frame.dispelDebuffFrames do
					frame.dispelDebuffFrames[i]:SetAlpha(0);
					frame.dispelDebuffFrames[i]:Hide();
				end
			end
		end
	end
end

local function ACRB_updatePartyAllHealerMana()
	if IsInGroup() then
		for _, asframe in pairs(asraid) do
			if asframe and asframe.frame and asframe.frame:IsShown() then
				ACRB_UpdateHealerMana(asframe);
				ACRB_UpdateRaidIconAborbColor(asframe);
				asframe.ncasting = 0;
			end
		end
	end
end

local ACRB_DangerousSpellList = {};

local function ACRB_updateCasting(asframe, unit)
	if asframe and asframe.frame and asframe.frame:IsShown() and asframe.castFrames then
		local index = asframe.ncasting + 1;
		local castFrame = asframe.castFrames[index];

		local frameunit = asframe.unit

		if asframe.displayedUnit and asframe.displayedUnit ~= frameunit then
			frameunit = asframe.displayedUnit;
		end

		if frameunit and UnitIsUnit(unit .. "target", frameunit) then
			local name, text, texture, startTime, endTime, isTradeSkill, castID, notInterruptible, spellid =
				UnitCastingInfo(unit);
			if not name then
				name, text, texture, startTime, endTime, isTradeSkill, notInterruptible, spellid = UnitChannelInfo(unit);
			end

			if name and index <= #(asframe.castFrames) then
				castFrame.icon:SetTexture(texture);
				castFrame.count:Hide();

				local curr = GetTime();
				local start = startTime / 1000;
				local duration = (endTime / 1000) - start;

				asCooldownFrame_Set(castFrame.cooldown, start, duration, true);

				if ACRB_DangerousSpellList[spellid] then
					ns.lib.PixelGlow_Start(castFrame);
				else
					ns.lib.PixelGlow_Stop(castFrame);
				end
				castFrame.castspellid = spellid;

				castFrame.border:Hide();
				castFrame:Show();
				asframe.ncasting = index;

				return true;
			end
		end
	end

	return false;
end

local function isFaction(unit)
	if UnitIsUnit("player", unit) then
		return false;
	else
		local reaction = UnitReaction("player", unit);
		if reaction and reaction <= 4 then
			return true;
		elseif UnitIsPlayer(unit) then
			return false;
		end
	end
end

local function ARCB_HideCast(asframe)
	if asframe and asframe.castFrames then
		for i = asframe.ncasting + 1, #asframe.castFrames do
			asframe.castFrames[i]:Hide();
		end
	end
end

local function CheckCasting(nameplate)
	if not nameplate or nameplate:IsForbidden() then
		return;
	end

	if not nameplate.UnitFrame or nameplate.UnitFrame:IsForbidden() then
		return;
	end

	local unit = nameplate.UnitFrame.unit;

	if isFaction(unit) then
		local name, text, texture, startTime, endTime, isTradeSkill, castID, notInterruptible, spellid = UnitCastingInfo(
			unit);
		if not name then
			name, text, texture, startTime, endTime, isTradeSkill, notInterruptible, spellid = UnitChannelInfo(unit);
		end

		if name then
			--탱커 부터
			for _, framename in pairs(tanklist) do
				local asframe = asraid[framename]
				if ACRB_updateCasting(asframe, unit) then
					return;
				end
			end

			if (IsInGroup()) then
				for _, asframe in pairs(asraid) do
					if asframe and asframe.frame and asframe.frame:IsShown() then
						if ACRB_updateCasting(asframe, unit) then
							return;
						end
					end
				end
			end
		end
	end
end


local function ACRB_CheckCasting()
	if (IsInGroup()) then
		for _, v in pairs(C_NamePlate.GetNamePlates(issecure())) do
			local nameplate = v;
			if (nameplate) then
				CheckCasting(nameplate);
			end
		end


		for _, asframe in pairs(asraid) do
			if asframe and asframe.frame and asframe.frame:IsShown() then
				ARCB_HideCast(asframe);
			end
		end
	end
end

function ACTA_DBMTimer_callback(event, id, ...)
	local msg, timer, icon, type, spellId, colorId, modid, keep, fade, name, guid = ...;
	if spellId then
		ACRB_DangerousSpellList[spellId] = true;
	end
end

local function ProcessAura(aura)
	if aura == nil then
		return AuraUpdateChangedType.None;
	end

	if aura.isNameplateOnly then
		return AuraUpdateChangedType.None;
	end

	if ns.ACRB_ShowList and ns.ACRB_ShowList[aura.name] then
		return AuraUpdateChangedType.None;
	end

	if aura.isBossAura and not aura.isRaid then
		aura.debuffType = aura.isHarmful and UnitFrameDebuffType.BossDebuff or
			UnitFrameDebuffType.BossBuff;
		return AuraUpdateChangedType.Debuff;
	elseif aura.isHarmful and not aura.isRaid then
		if aura.nameplateShowAll then
			aura.debuffType = UnitFrameDebuffType.namePlateShowAll;
		elseif IsPriorityDebuff(aura.spellId) then
			aura.debuffType = UnitFrameDebuffType.PriorityDebuff;
			return AuraUpdateChangedType.Debuff;
		elseif ShouldDisplayDebuff(aura) then
			aura.debuffType = UnitFrameDebuffType.NonBossDebuff;
			return AuraUpdateChangedType.Debuff;
		end
	elseif aura.isHarmful and aura.isRaid then
		if DispellableDebuffTypes[aura.dispelName] ~= nil then
			aura.debuffType = aura.isBossAura and UnitFrameDebuffType.BossDebuff or
				UnitFrameDebuffType.NonBossRaidDebuff;
			return AuraUpdateChangedType.Dispel;
		end
	elseif aura.isHelpful and ShouldDisplayBuff(aura) then
		aura.isBuff = true;
		return AuraUpdateChangedType.Buff;
	elseif aura.isHelpful and (PLAYER_UNITS[aura.sourceUnit] and ACRB_ShowList and ACRB_ShowList[aura.name]) then
		aura.isBuff = true;
		return AuraUpdateChangedType.Buff;
	elseif aura.isHelpful and ns.ACRB_PVPBuffList[aura.spellId] then
		return AuraUpdateChangedType.PVP;	
	end

	return AuraUpdateChangedType.None;
end

local function UpdateNameColor(frame)
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

local function ACRB_ParseAllAuras(asframe)
	if asframe.debuffs == nil then
		asframe.debuffs = TableUtil.CreatePriorityTable(UnitFrameDebuffComparator,
			TableUtil.Constants.AssociativePriorityTable);
		asframe.buffs = TableUtil.CreatePriorityTable(DefaultAuraCompare, TableUtil.Constants.AssociativePriorityTable);
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
	ForEachAura(asframe.displayedUnit, bufffilter, batchCount, HandleAura, usePackedAura);
	ForEachAura(asframe.displayedUnit, debufffilter, batchCount, HandleAura, usePackedAura);
end

local function ACRB_UpdateAuras(asframe, unitAuraUpdateInfo)
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

			if aura.isBossAura or aura.nameplateShowAll then
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
		local showframe = {};
		asframe.buffs:Iterate(function(auraInstanceID, aura)
			if frameNum > ACRB_MAX_BUFFS + 1 then
				return true;
			end

			local type = 1;

			if ACRB_ShowList and ACRB_ShowList[aura.name] and ACRB_ShowList[aura.name][2] then
				type = ACRB_ShowList[aura.name][2];
			end

			if type > ACRB_MAX_BUFFS - 3 and not showframe[type] then
				local buffFrame = asframe.asbuffFrames[type];
				if type == 4 then
					asframe.buffcolor:Show();
					UpdateNameColor(asframe.frame);
				end
				ARCB_UtilSetBuff(buffFrame, aura);
				showframe[type] = true;
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
				if i == 4 then
					asframe.buffcolor:Hide();
					UpdateNameColor(asframe.frame);
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

-- Setup
local function ACRB_setupFrame(frame)
	if not frame or frame:IsForbidden() then
		return
	end


	local frameName = frame:GetName()
	if asraid[frameName] == nil then
		asraid[frameName] = {};
	end

	local asframe = asraid[frameName];

	if frame.unit then
		asframe.unit = frame.unit;
	end

	local displayedUnit;

	if frame.displayedUnit then
		asframe.displayedUnit = frame.displayedUnit;

		if (frame.unit ~= frame.displayedUnit) then
			displayedUnit = frame.displayedUnit;
		end
	else
		asframe.displayedUnit = frame.unit;
	end

	asframe.frame = frame;

	if not UnitIsPlayer(asframe.unit) then
		return;
	end



	local CUF_AURA_BOTTOM_OFFSET = 2;
	local CUF_NAME_SECTION_SIZE = 15;

	local frameHeight = EditModeManagerFrame:GetRaidFrameHeight(frame.isParty);
	local options = DefaultCompactUnitFrameSetupOptions;
	local powerBarHeight = 8;
	local powerBarUsedHeight = options.displayPowerBar and powerBarHeight or 0;


	local x, y = frame:GetSize();

	y = y - powerBarUsedHeight;

	local size_x = x / 6 * ns.ACRB_BuffSizeRate - 1;
	local size_y = y / 3 * ns.ACRB_BuffSizeRate - 1;

	local baseSize = math.min(x / 7 * ns.ACRB_BuffSizeRate, y / 3 * ns.ACRB_BuffSizeRate);

	if baseSize > ACRB_MaxBuffSize then
		baseSize = ACRB_MaxBuffSize
	end

	baseSize = baseSize * 0.9;

	local fontsize = baseSize * ns.ACRB_MinShowBuffFontSize;

	if asframe.isDispellAlert == nil then
		asframe.isDispellAlert = false;
	end

	if not asframe.buffcolor then
		asframe.buffcolor = frame:CreateTexture(nil, "ARTWORK", "asBuffTextureTemplate", -1);
		asframe.buffcolor:Hide();
	end

	if asframe.buffcolor then
		local previousTexture = frame.healthBar:GetStatusBarTexture();
		asframe.buffcolor:ClearAllPoints();
		asframe.buffcolor:SetAllPoints(previousTexture);
		asframe.buffcolor:SetVertexColor(0.5, 0.5, 0.5);
	end

	if not asframe.aborbcolor then
		asframe.aborbcolor = frame:CreateTexture(nil, "ARTWORK", "asBuffTextureTemplate", 0);
		asframe.aborbcolor:Hide();
	end

	if asframe.aborbcolor then
		local previousTexture = frame.healthBar:GetStatusBarTexture();
		asframe.aborbcolor:ClearAllPoints();
		asframe.aborbcolor:SetPoint("TOPLEFT", previousTexture, "TOPLEFT", 0, 0);
		asframe.aborbcolor:SetPoint("BOTTOMLEFT", previousTexture, "BOTTOMLEFT", 0, 0);
		asframe.aborbcolor:SetWidth(0);
		asframe.aborbcolor:SetVertexColor(0, 0, 0);
		asframe.aborbcolor:SetAlpha(0.2);
	end

	if not asframe.asbuffFrames then
		asframe.asbuffFrames = {}
		for i = 1, ACRB_MAX_BUFFS do
			local buffFrame = CreateFrame("Button", nil, frame, "asCompactBuffTemplate")
			buffFrame:EnableMouse(ns.ACRB_ShowTooltip);
			buffFrame.icon:SetTexCoord(.08, .92, .08, .92);
			buffFrame.border:SetTexture("Interface\\Addons\\asCompactRaidBuff\\border.tga");
			buffFrame.border:SetTexCoord(0.08, 0.08, 0.08, 0.92, 0.92, 0.08, 0.92, 0.92);
			buffFrame.border:SetVertexColor(0, 0, 0);
			buffFrame.border:Show();
			asframe.asbuffFrames[i] = buffFrame;
			buffFrame:Hide();
		end
	end

	if asframe.asbuffFrames then
		for i = 1, ACRB_MAX_BUFFS do
			local buffFrame = asframe.asbuffFrames[i];
			buffFrame:ClearAllPoints()

			if ns.ACRB_ShowTooltip and not buffFrame:GetScript("OnEnter") then
				buffFrame:SetScript("OnEnter", function(s)
					if s.auraInstanceID then
						GameTooltip_SetDefaultAnchor(GameTooltip, s);
						GameTooltip:SetUnitBuffByAuraInstanceID(asframe.displayedUnit, s.auraInstanceID,
							bufffilter);
					end
				end)
				buffFrame:SetScript("OnLeave", function()
					GameTooltip:Hide();
				end)
			end


			if i <= ACRB_MAX_BUFFS - 3 then
				if math.fmod(i - 1, 3) == 0 then
					if i == 1 then
						local buffPos, buffRelativePoint, buffOffset = "BOTTOMRIGHT", "BOTTOMLEFT",
							CUF_AURA_BOTTOM_OFFSET + powerBarUsedHeight;
						buffFrame:ClearAllPoints();
						buffFrame:SetPoint(buffPos, frame, "BOTTOMRIGHT", -2, buffOffset);
					else
						buffFrame:SetPoint("BOTTOMRIGHT", asframe.asbuffFrames[i - 3], "TOPRIGHT", 0, 1)
					end
				else
					buffFrame:SetPoint("BOTTOMRIGHT", asframe.asbuffFrames[i - 1], "BOTTOMLEFT", -1, 0)
				end

				buffFrame.cooldown:SetSwipeColor(0, 0, 0, 0.5);
			else
				-- 3개는 따로 뺀다.
				if i == ACRB_MAX_BUFFS - 2 then
					-- 우상
					buffFrame:ClearAllPoints();
					buffFrame:SetPoint("TOPRIGHT", frame, "TOPRIGHT", -2, -2);
				elseif i == ACRB_MAX_BUFFS - 1 then
					-- 우중
					buffFrame:ClearAllPoints();
					buffFrame:SetPoint("RIGHT", frame, "RIGHT", -2, 0);
				else
					-- 우중2
					buffFrame:ClearAllPoints();
					buffFrame:SetPoint("BOTTOMRIGHT", asframe.asbuffFrames[i - 1], "BOTTOMLEFT", -1, 0)
				end

				buffFrame.cooldown:SetSwipeColor(0, 0, 0, 1);
			end
		end
	end


	--크기 조정
	for _, d in ipairs(asframe.asbuffFrames) do
		d:SetSize(size_x, size_y);

		d.count:SetFont(STANDARD_TEXT_FONT, fontsize, "OUTLINE")
		d.count:ClearAllPoints();
		d.count:SetPoint("BOTTOM", 0, 1);
		if ns.ACRB_ShowBuffCooldown and fontsize >= ns.ACRB_MinShowBuffFontSize then
			d.cooldown:SetHideCountdownNumbers(false);
			for _, r in next, { d.cooldown:GetRegions() } do
				if r:GetObjectType() == "FontString" then
					r:SetFont(STANDARD_TEXT_FONT, fontsize, "OUTLINE")
					r:ClearAllPoints();
					r:SetPoint("TOP", 0, 2);
					break
				end
			end
		end
	end

	if not asframe.asdebuffFrames then
		asframe.asdebuffFrames = {};
		for i = 1, ACRB_MAX_DEBUFFS do
			local debuffFrame = CreateFrame("Button", nil, frame, "asCompactDebuffTemplate")
			debuffFrame:EnableMouse(ns.ACRB_ShowTooltip);
			debuffFrame.icon:SetTexCoord(.08, .92, .08, .92);
			debuffFrame.border:SetTexture("Interface\\Addons\\asCompactRaidBuff\\border.tga");
			debuffFrame.border:SetTexCoord(0.08, 0.08, 0.08, 0.92, 0.92, 0.08, 0.92, 0.92);
			asframe.asdebuffFrames[i] = debuffFrame;
			debuffFrame:Hide();
		end
	end

	if asframe.asbuffFrames then
		for i = 1, ACRB_MAX_DEBUFFS do
			local debuffFrame = asframe.asdebuffFrames[i];
			debuffFrame:ClearAllPoints()

			if math.fmod(i - 1, 3) == 0 then
				if i == 1 then
					local debuffPos, debuffRelativePoint, debuffOffset = "BOTTOMLEFT", "BOTTOMRIGHT",
						CUF_AURA_BOTTOM_OFFSET + powerBarUsedHeight;
					debuffFrame:ClearAllPoints();
					debuffFrame:SetPoint(debuffPos, frame, "BOTTOMLEFT", 3, debuffOffset);
				else
					debuffFrame:SetPoint("BOTTOMLEFT", asframe.asdebuffFrames[i - 3], "TOPLEFT", 0, 1)
				end
			else
				debuffFrame:SetPoint("BOTTOMLEFT", asframe.asdebuffFrames[i - 1], "BOTTOMRIGHT", 1, 0)
			end

			debuffFrame.cooldown:SetSwipeColor(0, 0, 0, 0.5);

			if ns.ACRB_ShowTooltip and not debuffFrame:GetScript("OnEnter") then
				debuffFrame:SetScript("OnEnter", function(s)
					if s.auraInstanceID then
						GameTooltip_SetDefaultAnchor(GameTooltip, s);
						if s.isBossBuff then
							GameTooltip:SetUnitBuffByAuraInstanceID(asframe.displayedUnit, s.auraInstanceID,
								bufffilter);
						else
							GameTooltip:SetUnitDebuffByAuraInstanceID(asframe.displayedUnit, s.auraInstanceID,
								debufffilter);
						end
					end
				end)

				debuffFrame:SetScript("OnLeave", function()
					GameTooltip:Hide();
				end)
			end
		end
	end

	for _, d in ipairs(asframe.asdebuffFrames) do
		d.size_x, d.size_y = size_x, size_y; -- 디버프
		d.maxHeight = frameHeight - powerBarUsedHeight - CUF_AURA_BOTTOM_OFFSET - CUF_NAME_SECTION_SIZE;
		d.count:SetFont(STANDARD_TEXT_FONT, fontsize, "OUTLINE")
		d.count:ClearAllPoints();
		d.count:SetPoint("BOTTOM", 0, 1);

		if ns.ACRB_ShowBuffCooldown and fontsize >= ns.ACRB_MinShowBuffFontSize then
			d.cooldown:SetHideCountdownNumbers(false);
			for _, r in next, { d.cooldown:GetRegions() } do
				if r:GetObjectType() == "FontString" then
					r:SetFont(STANDARD_TEXT_FONT, fontsize, "OUTLINE");
					r:ClearAllPoints();
					r:SetPoint("TOP", 0, 2);
					break
				end
			end
		end
	end


	if not asframe.asdispelDebuffFrames then
		asframe.asdispelDebuffFrames = {};
		for i = 1, ACRB_MAX_DISPELDEBUFFS do
			local dispelDebuffFrame = CreateFrame("Button", nil, frame, "asCompactDispelDebuffTemplate")
			dispelDebuffFrame:EnableMouse(false);
			asframe.asdispelDebuffFrames[i] = dispelDebuffFrame;
			dispelDebuffFrame:Hide();
		end
	end

	asframe.asdispelDebuffFrames[1]:SetPoint("RIGHT", asframe.asbuffFrames[(ACRB_MAX_BUFFS - 2)],
		"LEFT", -1, 0);
	for i = 1, ACRB_MAX_DISPELDEBUFFS do
		if (i > 1) then
			asframe.asdispelDebuffFrames[i]:SetPoint("RIGHT", asframe.asdispelDebuffFrames[i - 1],
				"LEFT", 0, 0);
		end
		asframe.asdispelDebuffFrames[i]:SetSize(baseSize, baseSize);
	end

	if (not asframe.asManabar and not frame.powerBar:IsShown()) then
		asframe.asManabar = CreateFrame("StatusBar", nil, frame.healthBar)
		asframe.asManabar:SetStatusBarTexture("Interface\\Addons\\asCompactRaidBuff\\UI-StatusBar")
		asframe.asManabar:GetStatusBarTexture():SetHorizTile(false)
		asframe.asManabar:SetMinMaxValues(0, 100)
		asframe.asManabar:SetValue(100)
		asframe.asManabar:SetPoint("BOTTOM", frame.healthBar, "BOTTOM", 0, 0)
		asframe.asManabar:Hide();
	end

	if asframe.asManabar then
		asframe.asManabar:SetWidth(x - 2);
		asframe.asManabar:SetHeight(ACRB_HealerManaBarHeight)
	end

	if (not asframe.asraidicon) then
		asframe.asraidicon = frame:CreateFontString(nil, "OVERLAY")
		asframe.asraidicon:SetFont(STANDARD_TEXT_FONT, fontsize * 2)
		asframe.asraidicon:SetPoint("LEFT", frame.healthBar, "LEFT", 2, 0)
		asframe.asraidicon:Hide();
	end

	asframe.asraidicon:SetFont(STANDARD_TEXT_FONT, fontsize * 2);

	if (not asframe.pvpbuffFrames) then
		asframe.pvpbuffFrames = {};

		for i = 1, ACRB_MAX_BUFFS_2 do
			local pvpbuffFrame = CreateFrame("Button", nil, frame, "asCompactBuffTemplate")
			asframe.pvpbuffFrames[i] = pvpbuffFrame;
			pvpbuffFrame:EnableMouse(ns.ACRB_ShowTooltip);
			pvpbuffFrame.icon:SetTexCoord(.08, .92, .08, .92);
			pvpbuffFrame.count:SetFont(STANDARD_TEXT_FONT, fontsize, "OUTLINE");
			pvpbuffFrame.count:ClearAllPoints();
			pvpbuffFrame.count:SetPoint("BOTTOM", 0, 0);
			pvpbuffFrame:Hide();

			if ns.ACRB_ShowBuffCooldown and fontsize >= ns.ACRB_MinShowBuffFontSize then
				pvpbuffFrame.cooldown:SetHideCountdownNumbers(false);
				for _, r in next, { pvpbuffFrame.cooldown:GetRegions() } do
					if r:GetObjectType() == "FontString" then
						r:SetFont(STANDARD_TEXT_FONT, fontsize, "OUTLINE");
						r:ClearAllPoints();
						r:SetPoint("TOP", 0, 2);
						break
					end
				end
			else
				pvpbuffFrame.cooldown:SetHideCountdownNumbers(true);
			end
			pvpbuffFrame.border:SetTexture("Interface\\Addons\\asCompactRaidBuff\\border.tga");
			pvpbuffFrame.border:SetTexCoord(0.08, 0.08, 0.08, 0.92, 0.92, 0.08, 0.92, 0.92);
			pvpbuffFrame.border:SetVertexColor(0, 0, 0);
			pvpbuffFrame.border:Show();

			pvpbuffFrame.cooldown:SetSwipeColor(0, 0, 0, 0.5);
		end
	end

	for i, d in ipairs(asframe.pvpbuffFrames) do
		d:SetSize(size_x, size_y);
		d.count:SetFont(STANDARD_TEXT_FONT, fontsize, "OUTLINE");
		d:ClearAllPoints()
		if i == 1 then
			d:SetPoint("CENTER", frame.healthBar, "CENTER", 0, 0)
		else
			d:SetPoint("TOPRIGHT", asframe.pvpbuffFrames[i - 1], "TOPLEFT",
				0,
				0)
		end

		if ns.ACRB_ShowTooltip and not d:GetScript("OnEnter") then
			d:SetScript("OnEnter", function(s)
				if s.auraInstanceID then
					GameTooltip_SetDefaultAnchor(GameTooltip, s);
					GameTooltip:SetUnitBuffByAuraInstanceID(asframe.displayedUnit, s.auraInstanceID,
						bufffilter);
				end
			end)

			d:SetScript("OnLeave", function()
				GameTooltip:Hide();
			end)
		end
	end


	if (not asframe.castFrames) then
		asframe.castFrames = {};

		for i = 1, ACRB_MAX_CASTING do
			local castFrame = CreateFrame("Button", nil, frame, "asCompactBuffTemplate")
			asframe.castFrames[i] = castFrame;
			castFrame:EnableMouse(ns.ACRB_ShowTooltip);
			castFrame.icon:SetTexCoord(.08, .92, .08, .92);
			castFrame.count:SetFont(STANDARD_TEXT_FONT, fontsize, "OUTLINE");
			castFrame.count:ClearAllPoints();
			castFrame.count:SetPoint("BOTTOM", 0, 0);
			castFrame:Hide();

			castFrame.cooldown:SetSwipeColor(0, 0, 0, 0.5);

			if ns.ACRB_ShowBuffCooldown and fontsize >= ns.ACRB_MinShowBuffFontSize then
				castFrame.cooldown:SetHideCountdownNumbers(false);
				for _, r in next, { castFrame.cooldown:GetRegions() } do
					if r:GetObjectType() == "FontString" then
						r:SetFont(STANDARD_TEXT_FONT, fontsize, "OUTLINE");
						r:ClearAllPoints();
						r:SetPoint("TOP", 0, 2);
						break
					end
				end
			else
				castFrame.cooldown:SetHideCountdownNumbers(true);
			end



			if ns.ACRB_ShowTooltip and not castFrame:GetScript("OnEnter") then
				castFrame:SetScript("OnEnter", function(s)
					if s.castspellid and s.castspellid > 0 then
						GameTooltip_SetDefaultAnchor(GameTooltip, s);
						GameTooltip:SetSpellByID(s.castspellid);
					end
				end)

				castFrame:SetScript("OnLeave", function()
					GameTooltip:Hide();
				end)
			end
		end
	end

	for i, d in ipairs(asframe.castFrames) do
		d:SetSize(size_x, size_y);
		d.count:SetFont(STANDARD_TEXT_FONT, fontsize, "OUTLINE");
		d:ClearAllPoints()
		if i == 1 then
			d:SetPoint("TOP", frame.healthBar, "TOP", 0, 0)
		else
			d:SetPoint("TOPRIGHT", asframe.castFrames[i - 1], "TOPLEFT", -1,
				0)
		end
	end

	asframe.ncasting = 0;

	ACRB_UpdateAuras(asframe, nil);
end


local function ARCB_UpdateAll(frame)
	if frame and not frame:IsForbidden() and frame.GetName then
		local name = frame:GetName();

		if name and not (name == nil) and (string.find(name, "CompactRaidGroup") or string.find(name, "CompactPartyFrameMember") or string.find(name, "CompactRaidFrame")) then
			if not (frame.displayedUnit and UnitIsPlayer(frame.displayedUnit)) then return end
			if not (frame.unit and UnitIsPlayer(frame.unit)) then return end
			ACRB_disableDefault(frame);
			ACRB_setupFrame(frame);
		end
	end
end

local function ACRB_updatePartyAllAura(auraonly)
	if (IsInGroup()) then
		for _, asframe in pairs(asraid) do
			if asframe and asframe.frame and asframe.frame:IsShown() then
				if auraonly then
					ACRB_UpdateAuras(asframe, nil);
				else
					ACRB_setupFrame(asframe.frame);
				end
			end
		end
	end
end

local function ACRB_OnUpdate()
	ACRB_updatePartyAllAura(true);
	ACRB_updatePartyAllHealerMana();
	ACRB_CheckCasting();
end


ACRB_InitList();

local function DumpCaches()
	cachedVisualizationInfo = {};
	cachedSelfBuffChecks = {};
	cachedPriorityChecks = {};
	ACRB_updatePartyAllAura(false);
end

local function ACRB_OnEvent(self, event, ...)
	local arg1 = ...;

	if (event == "PLAYER_ENTERING_WORLD") then
		ACRB_DangerousSpellList = {};
		ACRB_InitList();
		hasValidPlayer = true;
		local bloaded = LoadAddOn("DBM-Core");
		if bloaded then
			DBM:RegisterCallback("DBM_TimerStart", ACTA_DBMTimer_callback);
		end
		updateTankerList();
		DumpCaches();
	elseif (event == "ACTIVE_TALENT_GROUP_CHANGED") then
		ACRB_InitList();
		DumpCaches();
	elseif (event == "GROUP_ROSTER_UPDATE") or (event == "CVAR_UPDATE") or (event == "ROLE_CHANGED_INFORM") then
		updateTankerList();
	elseif (event == "PLAYER_REGEN_ENABLED" or event == "PLAYER_REGEN_DISABLED") then
		DumpCaches();
	elseif (event == "PLAYER_LEAVING_WORLD") then
		hasValidPlayer = false;
	end
end

ACRB_mainframe:SetScript("OnEvent", ACRB_OnEvent)
ACRB_mainframe:RegisterEvent("GROUP_ROSTER_UPDATE");
ACRB_mainframe:RegisterEvent("PLAYER_ENTERING_WORLD");
ACRB_mainframe:RegisterEvent("PLAYER_LEAVING_WORLD");
ACRB_mainframe:RegisterEvent("ACTIVE_TALENT_GROUP_CHANGED");
ACRB_mainframe:RegisterEvent("CVAR_UPDATE");
ACRB_mainframe:RegisterEvent("ROLE_CHANGED_INFORM");
ACRB_mainframe:RegisterEvent("VARIABLES_LOADED");
ACRB_mainframe:RegisterEvent("PLAYER_REGEN_ENABLED");
ACRB_mainframe:RegisterEvent("PLAYER_REGEN_DISABLED");

C_Timer.NewTicker(ns.ACRB_UpdateRate, ACRB_OnUpdate);

hooksecurefunc("CompactUnitFrame_UpdateAll", ARCB_UpdateAll);
hooksecurefunc("CompactUnitFrame_UpdateName", UpdateNameColor);
