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

ns.show_list = {};
ns.show_countlist = {};
ns.show_totemlist = {};

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

	return a.auraInstanceID < b.auraInstanceID
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

local function IsShown(aura)
	local name = aura.name;
	local spellId = aura.spellId
	if ns.ABF_BlackList[spellId] then
		return true;
	end

	-- asPowerBar Check
	if APB_BUFF and APB_BUFF == spellId then
		return true;
	end

	if APB_BUFF2 and APB_BUFF2 == spellId then
		return true;
	end
	if APB_BUFF3 and APB_BUFF3 == spellId then
		return true;
	end

	if APB_BUFF_COMBO and APB_BUFF_COMBO == spellId then
		return true;
	end

	if APB_BUFF_STACK and APB_BUFF_STACK == spellId then
		return true;
	end

	if APB_BUFF_COMBO_MAX and APB_BUFF_COMBO_MAX == spellId then
		return true;
	end

	aura.classbuff = ns.show_list[aura.spellId];

	if bcheckOverlay and (overlayspell[spellId] or overlayspell[name]) then
		if aura.classbuff and aura.classbuff > 1 then

		else
			return true;
		end
	end

	if ACI_Buff_list and (ACI_Buff_list[name] or (spellId and ACI_Buff_list[spellId])) then
		return true;
	end

	return false;
end

local function IsShownTotem(name, icon)
	if ns.ABF_BlackListTotem[name] or ns.ABF_BlackListTotem[icon] then
		return true;
	end

	if ACI_Totem_list and (ACI_Totem_list[name] or ACI_Totem_list[icon]) then
		return true;
	end

	return false;
end

local activeBuffs = {};


local function ProcessAura(aura, unit)
	if aura == nil or aura.icon == nil or unit == nil or not aura.isHelpful then
		return;
	end

	if IsShown(aura) then
		return;
	end

	local skip = true;
	local isPlayerUnit = PLAYER_UNITS[aura.sourceUnit];
	aura.procbuff = ns.ABF_ProcBuffList[aura.spellId];
	aura.pvpbuff = ns.ABF_PVPBuffList[aura.spellId];
	local minshowtype = 100;

	if unit == "target" then
		if UnitIsPlayer("target") then
			skip = true;
			if UnitCanAssist("target", "player") then
				-- 우리편은 내가 시전한 Buff 보임
				if isPlayerUnit and aura.duration > 0 and aura.duration <= ns.ABF_MAX_Cool then
					skip = false;
				end
			end

			if aura.isStealable then
				skip = false;
			end

			-- PVP 주요 버프는 보임
			if (aura.pvpbuff) then
				skip = false;
			end

			if not UnitAffectingCombat("player") then
				skip = false; --비전투중 모두 보임
			end
		else
			skip = false;
		end
	elseif unit == "player" then
		skip = true;
		if isPlayerUnit and ((aura.duration > 0 and aura.duration <= ns.ABF_MAX_Cool)) then
			skip = false;
		end

		if isPlayerUnit and ((aura.applications and aura.applications > 1 and aura.duration <= ns.ABF_MAX_Cool)) then
			skip = false;
		end

		if isPlayerUnit and (aura.nameplateShowPersonal or aura.classbuff) then
			skip = false;
		end

		if (aura.pvpbuff) then
			skip = false;
		end

		if aura.procbuff then
			skip = false;
		end

		if ns.options.ShowListOnly then
			minshowtype = UnitFrameBuffType.ProcBuff;
		end
	end

	if skip == false then
		if aura.isBossAura and not aura.isRaid then
			aura.buffType = UnitFrameBuffType.BossBuff;
		elseif not isPlayerUnit then
			if aura.procbuff then
				aura.buffType = UnitFrameBuffType.ProcBuff;
			else
				aura.buffType = UnitFrameBuffType.Normal;
			end
		elseif aura.classbuff then
			local ClassBuffType = aura.classbuff;
			aura.buffcheckcount = ns.show_countlist[aura.spellId];
			if aura.buffcheckcount then
				if aura.applications >= aura.buffcheckcount and ClassBuffType < 3 then
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
		elseif aura.procbuff then
			aura.buffType = UnitFrameBuffType.ProcBuff;
		elseif IsShouldDisplayBuff(aura.spellId, aura.sourceUnit, aura.isFromPlayerOrPlayerPet) then
			aura.buffType = UnitFrameBuffType.Normal;
		else
			aura.buffType = UnitFrameBuffType.Normal;
		end

		if aura.buffType <= minshowtype then
			activeBuffs[unit][aura.auraInstanceID] = aura;
		end
		return;
	end


	return;
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

local function SetBuff(frame, icon, applications, expirationTime, duration, color, alert, bigcount, countcolor, currtime)
	local data = frame.data;

	if (applications ~= data.applications) then
		local frameCount = frame.count;
		if bigcount then
			frameCount = frame.bigcount;
			frame.count:Hide();
		else
			frame.bigcount:Hide();
		end

		if (applications > 1) then
			frameCount:Show();
			frameCount:SetText(applications);
			if countcolor then
				frameCount:SetTextColor(countcolor.r, countcolor.g, countcolor.b);
			end
		else
			frameCount:Hide();
		end
		data.applications = applications;
	end

	local isshow = false;

	if (duration > 0 and (expirationTime - currtime) <= 60) then
		isshow = true;
	end

	if (expirationTime ~= data.expirationTime) or
		(duration ~= data.duration) or
 		(isshow ~= data.isshow) then
		if (isshow) then
			local startTime = expirationTime - duration;
			asCooldownFrame_Set(frame.cooldown, startTime, duration, duration > 0, true);
		else
			asCooldownFrame_Clear(frame.cooldown);
		end

		data.duration = duration;
		data.expirationTime = expirationTime;
		data.isshow = isshow;
	end

	if (color ~= data.color) then
		frame.border:SetVertexColor(color.r, color.g, color.b);
		data.color = color;
	end

	if (alert ~= data.alert) then
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
		data.alert = alert;
	end

	if (icon ~= data.icon) then
		frame.icon:SetTexture(icon);
		data.icon = icon;
		frame:Show();
	end
end

local function updateTotemAura()
	local left = 1;
	local center = 1;
	local curr_time = GetTime();

	for slot = 1, MAX_TOTEMS do
		local haveTotem, name, start, duration, icon = GetTotemInfo(slot);

		if haveTotem and icon then
			if not (IsShownTotem(name, icon)) then
				local frame = nil;
				local alert = ns.show_totemlist[icon] or 0;

				if alert > 0 then
					frame = ABF_TALENT_BUFF.frames[center];
					center = center + 1;
				else
					frame = ABF_PLAYER_BUFF.frames[left];
					left = left + 1;
				end

				local expirationTime = start + duration;

				frame.totemslot = slot;
				frame.auraInstanceID = nil;
				local color = { r = 0.5, g = 0.5, b = 0.5 };

				SetBuff(frame, icon, 0, expirationTime, duration, color, alert, false, nil, curr_time);
			end
		end
	end

	return left, center;
end

local function HideFrame(p, idx)
	local frame = p.frames[idx];

	if (frame) then
		ns.lib.ButtonGlow_Stop(frame);
		ns.lib.PixelGlow_Stop(frame);
		frame.data = {};
		frame:Hide();
	end
end

local function UpdateAuraFrames(unit, auraList)
	local i = 0;
	local curr_time = GetTime();
	local parent = ABF_TARGET_BUFF;
	local mparent = nil;
	local toshow = ns.ABF_MAX_BUFF_SHOW;

	if (unit == "player") then
		parent = ABF_PLAYER_BUFF;
		mparent = ABF_TALENT_BUFF;
	else
		if not UnitAffectingCombat(unit) then
			toshow = ns.ABF_TARGET_MAX_BUFF_SHOW;
		end
	end

	local max = #(parent.frames)
	local numAuras = max;
	local tcount = 1;
	local lcount = 1;

	if (unit == "player") then
		lcount, tcount = updateTotemAura();
		numAuras = math.min(max * 2, auraList:Size());
	else
		numAuras = math.min(max, auraList:Size(), toshow);
		tcount = 1;
		lcount = 1;
	end


	auraList:Iterate(
		function(auraInstanceID, aura)
			i = i + 1;
			if i > numAuras then
				return true;
			end

			local frame = nil;

			if mparent then
				if aura.buffType < UnitFrameBuffType.ProcBuff and tcount <= max then
					frame = mparent.frames[tcount];
					tcount = tcount + 1;
				elseif mparent and lcount <= max then
					frame = parent.frames[lcount];
					lcount = lcount + 1;
				else
					return true;
				end
			else
				frame = parent.frames[i];
			end

			frame.unit = unit;
			frame.auraInstanceID = auraInstanceID;
			frame.totemslot = nil;
			local alert = 0;
			local countcolor = nil;

			local color = { r = 0, g = 0, b = 0 };
			local bigcount = false;

			if (aura.isStealable) or (aura.procbuff) then
				alert = 3;
			else
				if aura.buffType == UnitFrameBuffType.PriorityBuff then
					alert = 2;
				elseif aura.buffType == UnitFrameBuffType.ImportantBuff then
					alert = 3;
				end
			end

			if aura.buffType == UnitFrameBuffType.CountBuff and aura.applications then
				if aura.buffcheckcount and aura.applications >= aura.buffcheckcount then
					countcolor = { r = 1, g = 0, b = 0 };
					alert = 3;
				else
					countcolor = { r = 1, g = 1, b = 1 };
				end
				bigcount = true;
			end

			if aura.buffType == UnitFrameBuffType.CountBuff then
				aura.duration = 0;
			end

			SetBuff(frame, aura.icon, aura.applications, aura.expirationTime, aura.duration, color, alert, bigcount,
				countcolor, curr_time);

			frame:Show();
			return false;
		end);

	if mparent then
		for j = tcount, max do
			HideFrame(mparent, j);
		end
		for j = lcount, max do
			HideFrame(parent, j);
		end
	else
		for j = i + 1, max do
			HideFrame(parent, j);
		end
	end
end


local function UpdateAuras(unit)
	ParseAllAuras(unit);
	UpdateAuraFrames(unit, activeBuffs[unit]);
end



local function ABF_ClearFrame()
	local parent = ABF_TARGET_BUFF;
	local max = #(parent.frames);

	for i = 1, max do
		local frame = parent.frames[i];

		if (frame) then
			frame:Hide();
			frame.data = {};
			ns.lib.ButtonGlow_Stop(frame);
			ns.lib.PixelGlow_Stop(frame);
		else
			break;
		end
	end
end

local function ABF_Resize()
	local parent = ABF_TARGET_BUFF;
	local max = #(parent.frames);
	local size = ns.ABF_SIZE;

	if not UnitAffectingCombat("player") then
		size = ns.ABF_SIZE_NOCOMBAT;
	end

	for i = 1, max do
		local frame = parent.frames[i];

		if (frame) then
			-- Resize
			frame:SetWidth(size);
			frame:SetHeight(size * 0.8);
		end
	end
end


local function ABF_OnEvent(self, event, arg1, ...)
	if (event == "UNIT_AURA") then
		UpdateAuras("player");
	elseif (event == "PLAYER_TARGET_CHANGED") then
		ABF_ClearFrame();
		ABF_Resize();
		UpdateAuras("target");
	elseif (event == "PLAYER_TOTEM_UPDATE") then
		UpdateAuras("player");
	elseif event == "PLAYER_ENTERING_WORLD" then
		hasValidPlayer = true;
		ABF_Resize();
		UpdateAuras("player");
		UpdateAuras("target");
	elseif event == "PLAYER_REGEN_DISABLED" then
		ABF:SetAlpha(ns.ABF_AlphaCombat);
		ABF_Resize();
		DumpCaches();
	elseif event == "PLAYER_REGEN_ENABLED" then
		ABF:SetAlpha(ns.ABF_AlphaNormal);
		ABF_Resize();
		DumpCaches();
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
		UpdateAuras("target");
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

local function CreatBuffFrames(parent, bright, bcenter, max)
	if parent.frames == nil then
		parent.frames = {};
	end

	for idx = 1, max do
		parent.frames[idx] = CreateFrame("Button", nil, parent, "asTargetBuffFrameTemplate");
		local frame = parent.frames[idx];
		frame.cooldown:SetDrawSwipe(true);
		frame.cooldown:SetHideCountdownNumbers(false);

		for _, r in next, { frame.cooldown:GetRegions() } do
			if r:GetObjectType() == "FontString" then
				r:SetFont(STANDARD_TEXT_FONT, ns.ABF_CooldownFontSize, "OUTLINE");
				r:ClearAllPoints();
				r:SetPoint("TOP", 0, 5);
				r:SetDrawLayer("OVERLAY");
				break;
			end
		end

		frame.count:SetFont(STANDARD_TEXT_FONT, ns.ABF_CountFontSize, "OUTLINE")
		frame.count:ClearAllPoints()
		frame.count:SetPoint("BOTTOMRIGHT", frame.icon, "BOTTOMRIGHT", -2, 2);

		frame.bigcount:SetFont(STANDARD_TEXT_FONT, ns.ABF_CountFontSize + 3, "OUTLINE")
		frame.bigcount:ClearAllPoints()
		frame.bigcount:SetPoint("CENTER", frame.icon, "CENTER", 0, 0);

		frame.icon:SetTexCoord(.08, .92, .16, .84);
		frame.icon:SetAlpha(ns.ABF_ALPHA);
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

		frame.data = {};

		frame:Hide();
	end

	return;
end


function ns.Loadoptions()
	overlayspell = {};

	local localizedClass, englishClass = UnitClass("player");

	ns.listname = "ShowList_" .. englishClass;
	local classlist = ns[ns.listname];
	local savedlist = ABF_Options[ns.listname];

	if savedlist and savedlist.classbuffs and savedlist.classcountbuffs and savedlist.classtotems and savedlist.version == classlist.version then
		ns.show_list = CopyTable(savedlist.classbuffs);
		ns.show_countlist = CopyTable(savedlist.classcountbuffs);
		ns.show_totemlist = CopyTable(savedlist.classtotems);
	elseif classlist and classlist.classbuffs and classlist.classcountbuffs and classlist.classtotems then
		ns.show_list = CopyTable(classlist.classbuffs);
		ns.show_countlist = CopyTable(classlist.classcountbuffs);
		ns.show_totemlist = CopyTable(classlist.classtotems);
		ABF_Options[ns.listname] = {};
		ABF_Options[ns.listname] = CopyTable(classlist);
	else
		ns.show_list = {};
		ns.show_countlist = {};
		ns.show_totemlist = {};
	end

	for id, value in pairs(ns.ABF_OtherBuffList) do
		ns.show_list[id] = value;
	end

	ABF_Resize();
	UpdateAuras("player");
	UpdateAuras("target");
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

	CreatBuffFrames(ABF_TARGET_BUFF, true, false, ns.ABF_TARGET_MAX_BUFF_SHOW);

	if bloaded and asMOD_setupFrame then
		asMOD_setupFrame(ABF_TARGET_BUFF, "asBuffFilter(Target)");
	end

	ABF_PLAYER_BUFF = CreateFrame("Frame", nil, ABF)

	ABF_PLAYER_BUFF:SetPoint("CENTER", ns.ABF_PLAYER_BUFF_X, ns.ABF_PLAYER_BUFF_Y)
	ABF_PLAYER_BUFF:SetWidth(1)
	ABF_PLAYER_BUFF:SetHeight(1)
	ABF_PLAYER_BUFF:SetScale(1)
	ABF_PLAYER_BUFF:Show()

	CreatBuffFrames(ABF_PLAYER_BUFF, false, false, ns.ABF_MAX_BUFF_SHOW);

	if bloaded and asMOD_setupFrame then
		asMOD_setupFrame(ABF_PLAYER_BUFF, "asBuffFilter(Player)");
	end

	ABF_TALENT_BUFF = CreateFrame("Frame", nil, ABF)

	ABF_TALENT_BUFF:SetPoint("CENTER", 0, ns.ABF_PLAYER_BUFF_Y)
	ABF_TALENT_BUFF:SetWidth(1)
	ABF_TALENT_BUFF:SetHeight(1)
	ABF_TALENT_BUFF:SetScale(1)

	ABF_TALENT_BUFF:Show()

	CreatBuffFrames(ABF_TALENT_BUFF, false, true, ns.ABF_MAX_BUFF_SHOW);

	if bloaded and asMOD_setupFrame then
		asMOD_setupFrame(ABF_TALENT_BUFF, "asBuffFilter(Talent)");
	end




	ABF:RegisterEvent("PLAYER_TARGET_CHANGED")
	ABF:RegisterUnitEvent("UNIT_AURA", "player");
	ABF:RegisterEvent("PLAYER_ENTERING_WORLD");
	ABF:RegisterEvent("PLAYER_LEAVING_WORLD");
	ABF:RegisterEvent("PLAYER_REGEN_DISABLED");
	ABF:RegisterEvent("PLAYER_REGEN_ENABLED");
	ABF:RegisterEvent("PLAYER_TOTEM_UPDATE");
	ABF:RegisterEvent("CVAR_UPDATE");


	bloaded = C_AddOns.LoadAddOn("asOverlay")
	if bloaded then
		ABF:RegisterEvent("SPELL_ACTIVATION_OVERLAY_SHOW");
		ABF:RegisterEvent("SPELL_ACTIVATION_OVERLAY_HIDE");
	end

	ns.SetupOptionPanels();

	ABF:SetScript("OnEvent", ABF_OnEvent)

	--주기적으로 Callback
	C_Timer.NewTicker(0.25, OnUpdate);
end

C_Timer.After(0.5, ABF_Init);
