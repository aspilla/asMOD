local _, ns = ...;
local ABF;
local ABF_PLAYER_BUFF;
local ABF_TARGET_BUFF;
local ABF_TalentBuffList = {};
local ABF_TalentBuffIconList = {};
local overlayspell = {};

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
	"CountBuff",
	"BossBuff",
	"ImportantBuff",
	"PriorityBuff",
	"SelectedBuff",
	"TalentBuff",
	"ProcBuff",
	"TalentBuffLeft",
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
	-- continuationToken is the first return value of C_UnitAuras.GetAuraSlots()
	local n = select('#', ...);
	for i = 1, n do
		local slot = select(i, ...);
		local done;
		local auraInfo = C_UnitAuras.GetAuraDataBySlot(unit, slot);
		if usePackedAura then			
			done = func(auraInfo);
		else
			done = func(AuraUtil.UnpackAuraData(auraInfo));
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
			C_UnitAuras.GetAuraSlots(unit, filter, maxCount, continuationToken));
	until continuationToken == nil;
end



local filter = CreateFilterString(AuraFilters.Helpful, AuraFilters.IncludeNameplateOnly);


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

		local slotType, actionID, spellID = C_SpellBook.GetSpellBookItemType(i, Enum.SpellBookSpellBank.Player);
		local _, _, icon = asGetSpellInfo(spellID);

		if (slotType == Enum.SpellBookItemType.Flyout) then
			local _, _, numSlots = GetFlyoutInfo(actionID);
			for j = 1, numSlots do
				local flyoutSpellID, _, _, flyoutSpellName, _ = GetFlyoutSlotInfo(actionID, j);

				if flyoutSpellName then
					ABF_TalentBuffList[flyoutSpellName] = true;
					ABF_TalentBuffList[flyoutSpellID or 0] = true;
				end
			end
		else
			ABF_TalentBuffList[spellName] = true;
			ABF_TalentBuffIconList[icon or 0] = true;
			ABF_TalentBuffList[spellID or 0] = true;
		end
	end
end

local function asCheckTalent()
	ABF_TalentBuffList = {};
	ABF_TalentBuffIconList = {};
	overlayspell = {};

	if not ns.ABF_CheckTalentTree then
		return;
	end

	scanSpells(2)
	scanSpells(3)
	
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
				local name, rank, icon = asGetSpellInfo(definitionInfo.spellID);
				ABF_TalentBuffList[talentName or ""] = true;
				ABF_TalentBuffIconList[icon or 0] = true;
				ABF_TalentBuffList[definitionInfo.spellID] = true;
				if definitionInfo.overrideName then
					--print (definitionInfo.overrideName)
					ABF_TalentBuffList[definitionInfo.overrideName] = true;
				end
			end
		end
	end

	return;
end


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

local bcheckOverlay = false;

local function IsShown(name, spellId)
	if ns.ABF_BlackList[name] then
		return true;
	end

	-- asPowerBar Check
	if APB_BUFF and APB_BUFF == name then
		return true;
	end

	if APB_BUFF2 and APB_BUFF2 == name then
		return true;
	end
	if APB_BUFF3 and APB_BUFF3 == name then
		return true;
	end

	if APB_BUFF_COMBO and (APB_BUFF_COMBO == name or APB_BUFF_COMBO == spellId) then
		return true;
	end

	if APB_BUFF_STACK and APB_BUFF_STACK == spellId then
		return true;
	end

	if APB_BUFF_COMBO_MAX and (APB_BUFF_COMBO_MAX == name or APB_BUFF_COMBO_MAX == spellId) then
		return true;
	end

	if bcheckOverlay and (overlayspell[spellId] or overlayspell[name]) then
		if ns.ABF_ClassBuffList[spellId] and ns.ABF_ClassBuffList[spellId] > 1 then

		elseif ns.ABF_ClassBuffList[name] and ns.ABF_ClassBuffList[name] > 1 then

		else
			return true;
		end
	end

	if ACI_Buff_list and (ACI_Buff_list[name] or (spellId and ACI_Buff_list[spellId])) then
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

	local skip = true;
	if unit == "target" then
		if UnitIsPlayer("target") then
			skip = true;
			if UnitCanAssist("target", "player") then
				-- 우리편은 내가 시전한 Buff 보임
				if PLAYER_UNITS[aura.sourceUnit] and aura.duration > 0 and aura.duration <= ns.ABF_MAX_Cool then
					skip = false;
				end
			end

			if aura.isStealable then
				skip = false;
			end

			-- PVP 주요 버프는 보임
			if (ns.ABF_PVPBuffList and ns.ABF_PVPBuffList[aura.spellId]) then
				skip = false;
			end
		else
			skip = false;
		end
	elseif unit == "player" then
		skip = true;
		if PLAYER_UNITS[aura.sourceUnit] and ((aura.duration > 0 and aura.duration <= ns.ABF_MAX_Cool)) then
			skip = false;
		end

		if PLAYER_UNITS[aura.sourceUnit] and ((aura.applications and aura.applications > 1 and aura.duration <= ns.ABF_MAX_Cool)) then
			skip = false;
		end

		if PLAYER_UNITS[aura.sourceUnit] and (aura.nameplateShowPersonal or ns.ABF_ClassBuffList[aura.name] or ns.ABF_ClassBuffList[aura.spellId]) then
			skip = false;
		end

		if (ns.ABF_PVPBuffList and ns.ABF_PVPBuffList[aura.spellId]) then
			skip = false;
		end

		if ns.ABF_ProcBuffList and ns.ABF_ProcBuffList[aura.name] then
			skip = false;
		end
	end

	if skip == false then
		if aura.isBossAura and not aura.isRaid then
			aura.buffType = UnitFrameBuffType.BossBuff;
		elseif not PLAYER_UNITS[aura.sourceUnit] then
			if ns.ABF_ProcBuffList and ns.ABF_ProcBuffList[aura.name] then
				aura.buffType = UnitFrameBuffType.ProcBuff;
			else
				aura.buffType = UnitFrameBuffType.Normal;
			end
		elseif ns.ABF_ClassBuffList[aura.name] or ns.ABF_ClassBuffList[aura.spellId] then
			local ClassBuffType = ns.ABF_ClassBuffList[aura.name] or ns.ABF_ClassBuffList[aura.spellId];
			if ns.ABF_ClassBuffCountList[aura.name] or ns.ABF_ClassBuffCountList[aura.spellId] then
				local buffcheckcount = ns.ABF_ClassBuffCountList[aura.name] or ns.ABF_ClassBuffCountList[aura.spellId];
				if aura.applications >= buffcheckcount and ClassBuffType < 3 then
					ClassBuffType = ClassBuffType + 1;
				end
			end

			if ClassBuffType == 1 then
				aura.buffType = UnitFrameBuffType.SelectedBuff;
			elseif ClassBuffType == 2 then
				aura.buffType = UnitFrameBuffType.PriorityBuff;
			elseif ClassBuffType == 3 then
				aura.buffType = UnitFrameBuffType.ImportantBuff;
			elseif ClassBuffType == 4 then
				aura.buffType = UnitFrameBuffType.CountBuff;
			else
				aura.buffType = UnitFrameBuffType.TalentBuffLeft;
			end
		elseif aura.nameplateShowPersonal then
			aura.buffType = UnitFrameBuffType.PriorityBuff;
		elseif ns.ABF_ProcBuffList and ns.ABF_ProcBuffList[aura.name] then
			aura.buffType = UnitFrameBuffType.ProcBuff;
		elseif IsShouldDisplayBuff(aura.spellId, aura.sourceUnit, aura.isFromPlayerOrPlayerPet) then
			aura.buffType = UnitFrameBuffType.Normal;
		elseif ABF_TalentBuffList[aura.spellId] == true then
			aura.buffType = UnitFrameBuffType.TalentBuff;
		elseif ABF_TalentBuffList[aura.name] == true then
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
	local left = 1;
	local center = 1;

	for slot = 1, MAX_TOTEMS do
		local haveTotem, name, start, duration, icon = GetTotemInfo(slot);

		if haveTotem and icon then
			if not (IsShown(name)) then
				local frame = nil;
				local alert = ns.ABF_ClassBuffList[name] or 0;

				if alert > 0 then
					frame = ABF_TALENT_BUFF.frames[center];
					center = center + 1;
				else
					frame = ABF_PLAYER_BUFF.frames[left];
					left = left + 1;
				end

				local expirationTime = start + duration;


				-- set the icon
				local frameIcon = frame.icon;
				frameIcon:SetTexture(icon);

				frame.totemslot = slot;
				frame.auraInstanceID = nil;

				-- set the count
				local frameCount = frame.count;
				local frameBigCount = frame.bigcount;
				-- Handle cooldowns
				local frameCooldown = frame.cooldown;

				frameCount:Hide();
				frameBigCount:Hide();

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
				frame:Show();

				if alert == 2 then
					ns.lib.ButtonGlow_Stop(frame);
					ns.lib.PixelGlow_Start(frame);
				elseif alert == 3 then
					ns.lib.PixelGlow_Stop(frame);
					ns.lib.ButtonGlow_Start(frame);
				else
					ns.lib.ButtonGlow_Stop(frame);
					ns.lib.PixelGlow_Stop(frame);
				end
			end
		end
	end

	return left, center;
end

local function UpdateAuraFrames(unit, auraList)
	local i = 0;
	local parent = ABF_TARGET_BUFF;
	local numAuras = math.min(ns.ABF_MAX_BUFF_SHOW, auraList:Size());
	local tcount = 1;
	local lcount = 1;
	local mparent = nil;
	local curr_time = GetTime();

	if (unit == "player") then
		lcount, tcount = updateTotemAura();
		parent = ABF_PLAYER_BUFF;
		mparent = ABF_TALENT_BUFF;
		numAuras = math.min(ns.ABF_MAX_BUFF_SHOW * 2, auraList:Size());
	end


	auraList:Iterate(
		function(auraInstanceID, aura)
			i = i + 1;
			if i > numAuras then
				return true;
			end

			local frame = nil;

			if mparent then
				if aura.buffType < UnitFrameBuffType.ProcBuff and tcount <= ns.ABF_MAX_BUFF_SHOW then
					frame = mparent.frames[tcount];
					tcount = tcount + 1;
				elseif mparent and lcount <= ns.ABF_MAX_BUFF_SHOW then
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
			-- set the count
			local frameCount = frame.count;
			local frameBigCount = frame.bigcount;

			-- Handle cooldowns
			local frameCooldown = frame.cooldown;
			local balertcount = false;

			if aura.buffType == UnitFrameBuffType.CountBuff and aura.applications then
				local buffcheckcount = ns.ABF_ClassBuffCountList[aura.name] or ns.ABF_ClassBuffCountList[aura.spellId];
				if buffcheckcount and aura.applications >= buffcheckcount then
					frameBigCount:SetTextColor(1, 0, 0, 1);
					balertcount = true;
				else
					frameBigCount:SetTextColor(1, 1, 1,1 );
				end
				

				frameBigCount:SetText(aura.applications);
				frameBigCount:Show();
				frameCount:Hide();
			else
				if (aura.applications and aura.applications > 1) then
					frameCount:SetText(aura.applications);
					frameCount:Show();
					frameBigCount:Hide();
					frameCooldown:SetDrawSwipe(false);
				else
					frameCount:Hide();
					frameBigCount:Hide();
					frameCooldown:SetDrawSwipe(true);
				end
			end

			if aura.buffType == UnitFrameBuffType.CountBuff then
				frameCooldown:Hide();
			elseif (aura.duration > 0 and (aura.expirationTime - curr_time) <= 60) then
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

			if (aura.isStealable) or (ns.ABF_ProcBuffList and ns.ABF_ProcBuffList[aura.name] and ns.ABF_ProcBuffList[aura.name] == 1) then
				ns.lib.ButtonGlow_Start(frame);
			else
				if balertcount then
					ns.lib.PixelGlow_Stop(frame);
					ns.lib.ButtonGlow_Start(frame);				
				elseif aura.buffType == UnitFrameBuffType.PriorityBuff then
					ns.lib.ButtonGlow_Stop(frame);
					ns.lib.PixelGlow_Start(frame);
				elseif aura.buffType == UnitFrameBuffType.ImportantBuff then
					ns.lib.PixelGlow_Stop(frame);
					ns.lib.ButtonGlow_Start(frame);
				else
					ns.lib.ButtonGlow_Stop(frame);
					ns.lib.PixelGlow_Stop(frame);
				end
			end

			frame:Show();
			return false;
		end);

	local function HideFrame(p, idx)
		local frame = p.frames[idx];

		if (frame) then
			ns.lib.ButtonGlow_Stop(frame);
			ns.lib.PixelGlow_Stop(frame);
			frame:Hide();
		end
	end


	if mparent then
		for j = tcount, ns.ABF_MAX_BUFF_SHOW do
			HideFrame(mparent, j);
		end
		for j = lcount, ns.ABF_MAX_BUFF_SHOW do
			HideFrame(parent, j);
		end
	else
		for j = i + 1, ns.ABF_MAX_BUFF_SHOW do
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

	for i = 1, ns.ABF_MAX_BUFF_SHOW do
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
		UpdateAuras(nil, "target");
	elseif (event == "UNIT_AURA") then
		local unitAuraUpdateInfo = ...;
		local unit = arg1;
		if unit and unit == "player" then
			UpdateAuras(nil, unit);
		end
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
		ABF:SetAlpha(ns.ABF_AlphaCombat);
		DumpCaches();
	elseif event == "PLAYER_REGEN_ENABLED" then
		ABF:SetAlpha(ns.ABF_AlphaNormal);
		DumpCaches();
	elseif event == "TRAIT_CONFIG_UPDATED" or event == "TRAIT_CONFIG_LIST_UPDATED" or event == "ACTIVE_TALENT_GROUP_CHANGED" then
		asCheckTalent();
	elseif (event == "SPELL_ACTIVATION_OVERLAY_SHOW") and arg1 then
		local spell_name = asGetSpellInfo(arg1);
		overlayspell[arg1] = true;
		overlayspell[spell_name] = true;
	elseif (event == "SPELL_ACTIVATION_OVERLAY_HIDE") then
	elseif (event == "PLAYER_LEAVING_WORLD") then
		hasValidPlayer = false;
	elseif (event == "CVAR_UPDATE") then
		local cvar_ovelay = Settings.GetValue("spellActivationOverlayOpacity");

		if cvar_ovelay and cvar_ovelay > 0 then
			bcheckOverlay = true;
		else
			bcheckOverlay = false;
		end
	end
end

local function OnUpdate()
	if (UnitExists("target")) then
		UpdateAuras(nil, "target");
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
	buff:SetWidth(ns.ABF_SIZE);
	buff:SetHeight(ns.ABF_SIZE * 0.8);
end

local function CreatBuffFrames(parent, bright, bcenter)
	if parent.frames == nil then
		parent.frames = {};
	end

	for idx = 1, ns.ABF_MAX_BUFF_SHOW do
		parent.frames[idx] = CreateFrame("Button", nil, parent, "asTargetBuffFrameTemplate");
		local frame = parent.frames[idx];
		frame:SetFrameStrata("MEDIUM");
		frame:SetFrameLevel(9000);
		frame.cooldown:SetFrameLevel(9100);
		for _, r in next, { frame.cooldown:GetRegions() } do
			if r:GetObjectType() == "FontString" then
				r:SetFont(STANDARD_TEXT_FONT, ns.ABF_CooldownFontSize, "OUTLINE");
				r:ClearAllPoints();
				r:SetPoint("TOP", 0, 5);
				break
			end
		end

		frame.count:SetFont(STANDARD_TEXT_FONT, ns.ABF_CountFontSize, "OUTLINE")
		frame.count:ClearAllPoints()
		frame.count:SetPoint("BOTTOMRIGHT", -2, 2);

		frame.bigcount:SetFont(STANDARD_TEXT_FONT, ns.ABF_CountFontSize + 3, "OUTLINE")
		frame.bigcount:ClearAllPoints()
		frame.bigcount:SetPoint("CENTER", 0, 0);		

		frame.icon:SetTexCoord(.08, .92, .08, .92);
		frame.icon:SetAlpha(ns.ABF_ALPHA);
		frame.border:SetTexture("Interface\\Addons\\asBuffFilter\\border.tga");
		frame.border:SetTexCoord(0.08, 0.08, 0.08, 0.92, 0.92, 0.08, 0.92, 0.92);
		frame.border:SetAlpha(ns.ABF_ALPHA);

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

		frame:EnableMouse(false);
		frame:SetMouseMotionEnabled(true);

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
	ABF:SetAlpha(ns.ABF_AlphaNormal);
	ABF:Show()


	local bloaded = C_AddOns.LoadAddOn("asMOD")

	ABF_TARGET_BUFF = CreateFrame("Frame", nil, ABF)

	ABF_TARGET_BUFF:SetPoint("CENTER", ns.ABF_TARGET_BUFF_X, ns.ABF_TARGET_BUFF_Y)
	ABF_TARGET_BUFF:SetWidth(1)
	ABF_TARGET_BUFF:SetHeight(1)
	ABF_TARGET_BUFF:SetScale(1)
	ABF_TARGET_BUFF:Show()

	CreatBuffFrames(ABF_TARGET_BUFF, true, false);

	if bloaded and asMOD_setupFrame then
		asMOD_setupFrame(ABF_TARGET_BUFF, "asBuffFilter(Target)");
	end

	ABF_PLAYER_BUFF = CreateFrame("Frame", nil, ABF)

	ABF_PLAYER_BUFF:SetPoint("CENTER", ns.ABF_PLAYER_BUFF_X, ns.ABF_PLAYER_BUFF_Y)
	ABF_PLAYER_BUFF:SetWidth(1)
	ABF_PLAYER_BUFF:SetHeight(1)
	ABF_PLAYER_BUFF:SetScale(1)
	ABF_PLAYER_BUFF:Show()

	CreatBuffFrames(ABF_PLAYER_BUFF, false, false);

	if bloaded and asMOD_setupFrame then
		asMOD_setupFrame(ABF_PLAYER_BUFF, "asBuffFilter(Player)");
	end

	ABF_TALENT_BUFF = CreateFrame("Frame", nil, ABF)

	ABF_TALENT_BUFF:SetPoint("CENTER", 0, ns.ABF_PLAYER_BUFF_Y)
	ABF_TALENT_BUFF:SetWidth(1)
	ABF_TALENT_BUFF:SetHeight(1)
	ABF_TALENT_BUFF:SetScale(1)

	ABF_TALENT_BUFF:Show()

	CreatBuffFrames(ABF_TALENT_BUFF, false, true);

	if bloaded and asMOD_setupFrame then
		asMOD_setupFrame(ABF_TALENT_BUFF, "asBuffFilter(Talent)");
	end


	ABF:RegisterEvent("PLAYER_TARGET_CHANGED")
	ABF_PLAYER_BUFF:RegisterUnitEvent("UNIT_AURA", "player");
	ABF:RegisterEvent("PLAYER_ENTERING_WORLD");
	ABF:RegisterEvent("PLAYER_LEAVING_WORLD");
	ABF:RegisterEvent("PLAYER_REGEN_DISABLED");
	ABF:RegisterEvent("PLAYER_REGEN_ENABLED");
	ABF:RegisterEvent("PLAYER_TOTEM_UPDATE");
	ABF:RegisterEvent("ACTIVE_TALENT_GROUP_CHANGED");
	ABF:RegisterEvent("TRAIT_CONFIG_LIST_UPDATED");
	ABF:RegisterEvent("TRAIT_CONFIG_UPDATED");
	ABF:RegisterEvent("CVAR_UPDATE");


	bloaded = C_AddOns.LoadAddOn("asOverlay")
	if bloaded then
		ABF:RegisterEvent("SPELL_ACTIVATION_OVERLAY_SHOW");
		ABF:RegisterEvent("SPELL_ACTIVATION_OVERLAY_HIDE");
	end


	ABF:SetScript("OnEvent", ABF_OnEvent)
	ABF_TARGET_BUFF:SetScript("OnEvent", ABF_OnEvent)
	ABF_PLAYER_BUFF:SetScript("OnEvent", ABF_OnEvent)

	--주기적으로 Callback
	C_Timer.NewTicker(0.2, OnUpdate);
end

ABF_Init();
