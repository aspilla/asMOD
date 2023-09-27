local _, ns = ...;
local ACRB_BuffSizeRate = 0.9;        -- 기존 Size 크기 배수
local ACRB_ShowBuffCooldown = false   -- 버프 지속시간을 보이려면
local ACRB_MinShowBuffFontSize = 5    -- 이크기보다 Cooldown font Size 가 작으면 안보이게 한다. 무조건 보이게 하려면 0
local ACRB_CooldownFontSizeRate = 0.5 -- 버프 Size 대비 쿨다운 폰트 사이즈
local ACRB_MAX_BUFFS = 6              -- 최대 표시 버프 개수 (3개 + 3개)
local ACRB_MAX_BUFFS_2 = 2            -- 최대 생존기 개수
local ACRB_MAX_DEBUFFS = 3            -- 최대 표시 디버프 개수 (3개)
local ACRB_MAX_DISPELDEBUFFS = 3      -- 최대 해제 디버프 개수 (3개)
local ACRB_MAX_CASTING = 2            -- 최대 Casting Alert
local ACRB_ShowAlert = true           -- HOT 리필 시 알림
local ACRB_MaxBuffSize = 20           -- 최대 Buff Size 창을 늘려도 이 크기 이상은 안커짐
local ACRB_HealerManaBarHeight = 3    -- 힐러 마나바 크기 (안보이게 하려면 0)
local ACRB_UpdateRate = (0.2)         -- 1회 Update 주기 (초) 작으면 작을 수록 Frame Rate 감소 가능, 크면 Update 가 느림
local ACRB_ShowWhenSolo = true        -- Solo Raid Frame 사용시 보이게 하려면 True (반드시 Solo Raid Frame과 사용)
local ACRB_ShowTooltip = true         -- GameTooltip을 보이게 하려면 True

-- 버프 남은시간에 리필 알림
-- 두번째 숫자는 표시 위치, 4(우상) 5(우중) 6(우중2) 7(상바) 1,2,3 은 우하에 보이는 우선 순위이다.
ACRB_ShowList_MONK_2 = {
	["소생의 안개"] = { 0, 4 },
	["포용의 안개"] = { 0, 5 },


}

-- 신기
ACRB_ShowList_PALADIN_1 = {
	["빛의 자락"] = { 0, 4 },
	["빛의 봉화"] = { 0, 5 },
	["신념의 봉화"] = { 0, 6 },
}

-- 수사
ACRB_ShowList_PRIEST_1 = {
	["속죄"] = { 0, 4 },
	["소생"] = { 1, 5 },
	["신의 권능: 보호막"] = { 0, 6 },
	["회복의 기원"] = { 0, 2 },
	["마력 주입"] = { 0, 1 },

}


-- 신사
ACRB_ShowList_PRIEST_2 = {
	["소생"] = { 1, 4 },
	["신의 권능: 보호막"] = { 0, 5 },
	["회복의 기원"] = { 0, 2 },
	["마력 주입"] = { 0, 1 },

}

ACRB_ShowList_PRIEST_3 = {
	["마력 주입"] = { 0, 1 },
}


ACRB_ShowList_SHAMAN_3 = {
	["성난 해일"] = { 1, 4 },
}


ACRB_ShowList_DRUID_4 = {
	["회복"] = { 1, 4 },
	["피어나는 생명"] = { 1, 5 },
	["재생"] = { 1, 6 },
	["회복 (싹틔우기)"] = { 1, 2 },
	["세나리온 수호물"] = { 0, 1 },
}

ACRB_ShowList_EVOKER_2 = {
	["메아리"] = { 0, 4 },
	["되감기"] = { 1, 5 },

}


-- 안보이게 할 디법
local ACRB_BlackList = {
	["도전자의 짐"] = 1,
}


-- 해제 알림 스킬
local ACRB_DispelAlertList = {
	--["탈진"] = 1,	
}



--직업별 생존기 등록 (10초 쿨다운), 용군단 Version
local ACRB_PVPBuffList = {
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
}

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
local dispelfilter = CreateFilterString(AuraFilters.Harmful, AuraFilters.Raid);
-- Buff/Debuff Cache


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
		self:SetSwipeColor(0, 0, 0, 1);
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

	ACRB_ShowList = _G[listname];
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
		buffFrame.border:Hide();
	else
		buffFrame.border:Hide();
		asCooldownFrame_Clear(buffFrame.cooldown);
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
	if (aura.isBossAura) then
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


	if role == "HEALER" then
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




local function ACRB_UpdateRaidIcon(asframe)
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

	do
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
local together = nil;
-- 탱커 처리부
local function updateTankerList()
	local bInstance, RTB_ZoneType = IsInInstance();

	if RTB_ZoneType == "pvp" or RTB_ZoneType == "arena" then
		return nil;
	end

	tanklist = table.wipe(tanklist)
	if IsInGroup() then
		if IsInRaid() then -- raid
			if together == true then
				for i = 1, 8 do
					for k = 1, 5 do
						local framename = "CompactRaidGroup" .. i .. "Member" .. k
						local asframe = asraid[framename]
						if asframe and asframe.unit then
							local assignedRole = UnitGroupRolesAssigned(asframe.unit);
							if assignedRole == "TANK" then
								table.insert(tanklist, framename);
							end
						end
					end
				end
			else
				for i = 1, 40 do
					local framename = "CompactRaidFrame" .. i
					local asframe = asraid[framename]
					if asframe and asframe.unit then
						local assignedRole = UnitGroupRolesAssigned(asframe.unit);
						if assignedRole == "TANK" then
							table.insert(tanklist, framename);
						end
					end
				end
			end

			for i = 1, GetNumGroupMembers() do
				local unitid = "raid" .. i
				local notMe = not UnitIsUnit('player', unitid)
				local unitName = UnitName(unitid)
				if unitName and notMe then
					local _, _, _, _, _, _, _, _, _, role, _, assignedRole = GetRaidRosterInfo(i);
					if assignedRole == "TANK" then
						table.insert(tanklist, unitid);
					end
				end
			end
		else -- party
			for i = 1, 5 do
				local framename = "CompactPartyFrameMember" .. i
				local asframe = asraid[framename]
				if asframe and asframe.unit then
					local assignedRole = UnitGroupRolesAssigned(asframe.unit);
					if assignedRole == "TANK" then
						table.insert(tanklist, framename);
					end
				end
			end
		end
	end
end

local function ARCB_HideAllBuffs(frame, startingIndex)
	if frame.buffFrames then
		for i = startingIndex or 1, #frame.buffFrames do
			frame.buffFrames[i]:SetAlpha(0);
			frame.buffFrames[i]:Hide();
		end
	end
end

local function ARCB_HideAllDebuffs(frame, startingIndex)
	if frame.debuffFrames then
		for i = startingIndex or 1, #frame.debuffFrames do
			frame.debuffFrames[i]:SetAlpha(0);
			frame.debuffFrames[i]:Hide();
		end
	end
end

local function ARCB_HideAllDispelDebuffs(frame, startingIndex)
	if frame.dispelDebuffFrames then
		for i = startingIndex or 1, #frame.dispelDebuffFrames do
			frame.dispelDebuffFrames[i]:SetAlpha(0);
			frame.dispelDebuffFrames[i]:Hide();
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

		ARCB_HideAllBuffs(frame);
		ARCB_HideAllDebuffs(frame)
		ARCB_HideAllDispelDebuffs(frame);
	end
end

local function ACRB_updateAllHealerMana(asframe)
	if asframe and asframe.frame and asframe.frame:IsShown() then
		ACRB_UpdateHealerMana(asframe);
		ACRB_UpdateRaidIcon(asframe);
		asframe.ncasting = 0;
	end
end

local function ACRB_updatePartyAllHealerMana()
	if (IsInGroup() or (ACRB_ShowWhenSolo)) then
		if IsInRaid() then -- raid
			if together == true then
				for i = 1, 8 do
					for k = 1, 5 do
						local asframe = asraid["CompactRaidGroup" .. i .. "Member" .. k]
						ACRB_updateAllHealerMana(asframe);
					end
				end
			else
				for i = 1, 40 do
					local asframe = asraid["CompactRaidFrame" .. i]
					ACRB_updateAllHealerMana(asframe);
				end
			end
		else -- party
			for i = 1, 5 do
				local asframe = asraid["CompactPartyFrameMember" .. i]
				ACRB_updateAllHealerMana(asframe);
			end
		end
	end
end

local function ACRB_DisableAura()
	if (IsInGroup() or (ACRB_ShowWhenSolo)) then
		if IsInRaid() then -- raid
			if together == true then
				for i = 1, 8 do
					for k = 1, 5 do
						local frame = _G["CompactRaidGroup" .. i .. "Member" .. k]
						ACRB_disableDefault(frame);
					end
				end
			else
				for i = 1, 40 do
					local frame = _G["CompactRaidFrame" .. i]
					ACRB_disableDefault(frame);
				end
			end
		else -- party
			for i = 1, 5 do
				local frame = _G["CompactPartyFrameMember" .. i]
				ACRB_disableDefault(frame);
			end
		end
	end
end

local ACRB_DangerousSpellList = {};

local function ACRB_updateCasting(asframe, unit)
	if asframe and asframe.frame and asframe.frame:IsShown() then
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

			if name and asframe.castFrames and index <= #(asframe.castFrames) then
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
				if IsInRaid() then -- raid
					if together == true then
						for i = 1, 8 do
							for k = 1, 5 do
								local asframe = asraid["CompactRaidGroup" .. i .. "Member" .. k]
								if ACRB_updateCasting(asframe, unit) then
									return;
								end
							end
						end
					else
						for i = 1, 40 do
							local asframe = asraid["CompactRaidFrame" .. i]
							if ACRB_updateCasting(asframe, unit) then
								return;
							end
						end
					end
				else -- party
					for i = 1, 5 do
						local asframe = asraid["CompactPartyFrameMember" .. i]
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
	for _, v in pairs(C_NamePlate.GetNamePlates(issecure())) do
		local nameplate = v;
		if (nameplate) then
			CheckCasting(nameplate);
		end
	end

	if (IsInGroup()) then
		if IsInRaid() then -- raid
			if together == true then
				for i = 1, 8 do
					for k = 1, 5 do
						local asframe = asraid["CompactRaidGroup" .. i .. "Member" .. k]
						ARCB_HideCast(asframe);
					end
				end
			else
				for i = 1, 40 do
					local asframe = asraid["CompactRaidFrame" .. i]
					ARCB_HideCast(asframe);
				end
			end
		else -- party
			for i = 1, 5 do
				local asframe = asraid["CompactPartyFrameMember" .. i]
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

local mustdisable = true;

local function ACRB_OnUpdate()
	if mustdisable then
		mustdisable = false;
		together = EditModeManagerFrame:ShouldRaidFrameShowSeparateGroups();
		if together == nil then
			together = true;
		end
		ACRB_DisableAura();
	end
	ACRB_updatePartyAllHealerMana();
	ACRB_CheckCasting();
end


local function ProcessAura(aura)
	if aura == nil then
		return AuraUpdateChangedType.None;
	end

	if aura.isNameplateOnly then
		return AuraUpdateChangedType.None;
	end

	if ACRB_BlackList and ACRB_BlackList[aura.name] then
		return AuraUpdateChangedType.None;
	end	
	
	if aura.isBossAura and not aura.isRaid then
		aura.debuffType = aura.isHarmful and UnitFrameDebuffType.BossDebuff or
			UnitFrameDebuffType.BossBuff;
		return AuraUpdateChangedType.Debuff;
	elseif aura.isHarmful and not aura.isRaid then
		if IsPriorityDebuff(aura.spellId) then
			aura.debuffType = UnitFrameDebuffType.PriorityDebuff;
			return AuraUpdateChangedType.Debuff;
		elseif ShouldDisplayDebuff(aura) then
			aura.debuffType = UnitFrameDebuffType.NonBossDebuff;
			return AuraUpdateChangedType.Debuff;
		end
	elseif aura.isHelpful and ACRB_PVPBuffList[aura.spellId] then
		return AuraUpdateChangedType.PVP;
	elseif aura.isHelpful and ShouldDisplayBuff(aura) then
		aura.isBuff = true;
		return AuraUpdateChangedType.Buff;
	elseif aura.isHelpful and (PLAYER_UNITS[aura.sourceUnit] and ACRB_ShowList and ACRB_ShowList[aura.name]) then
		aura.isBuff = true;
		return AuraUpdateChangedType.Buff;		
	elseif aura.isHarmful and aura.isRaid then
		if DispellableDebuffTypes[aura.dispelName] ~= nil then
			aura.debuffType = aura.isBossAura and UnitFrameDebuffType.BossDebuff or
				UnitFrameDebuffType.NonBossRaidDebuff;
			return AuraUpdateChangedType.Dispel;
		end
	end

	return AuraUpdateChangedType.None;
end

function ACRB_IsPvpFrame(asframe)
	local frame = asframe.frame;
	return frame.groupType and frame.groupType == CompactRaidGroupTypeEnum.Arena;
end

function ACRB_ProcessAura(asframe, aura)
	local type = ProcessAura(aura);

	-- Can't dispell debuffs on pvp frames
	if type == AuraUpdateChangedType.Dispel and ACRB_IsPvpFrame(asframe) then
		type = AuraUpdateChangedType.Debuff;
	end

	return type;
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
		local type = ACRB_ProcessAura(asframe, aura);

		if type == AuraUpdateChangedType.Debuff then
			asframe.debuffs[aura.auraInstanceID] = aura;
		elseif type == AuraUpdateChangedType.Buff then
			asframe.buffs[aura.auraInstanceID] = aura;
		elseif type == AuraUpdateChangedType.PVP then
			asframe.pvpbuffs[aura.auraInstanceID] = aura;
		elseif type == AuraUpdateChangedType.Dispel then
			asframe.debuffs[aura.auraInstanceID] = aura;
		end
	end
	ForEachAura(asframe.displayedUnit, bufffilter, batchCount, HandleAura, usePackedAura);
	ForEachAura(asframe.displayedUnit, debufffilter, batchCount, HandleAura, usePackedAura);
	ForEachAura(asframe.displayedUnit, dispelfilter, batchCount, HandleAura, usePackedAura);
end

local function ACRB_UpdateAuras(asframe, unitAuraUpdateInfo)
	local debuffsChanged = false;
	local buffsChanged = false;
	local pvpbuffsChanged = false;
	local dispelsChanged = false;

	if unitAuraUpdateInfo == nil or unitAuraUpdateInfo.isFullUpdate or asframe.debuffs == nil then
		ACRB_ParseAllAuras(asframe);
		debuffsChanged = true;
		buffsChanged = true;
		pvpbuffsChanged = true;
		dispelsChanged = true;
	else
		if unitAuraUpdateInfo.addedAuras ~= nil then
			for _, aura in ipairs(unitAuraUpdateInfo.addedAuras) do
				local type = ACRB_ProcessAura(asframe, aura);
				if type == AuraUpdateChangedType.Debuff then
					asframe.debuffs[aura.auraInstanceID] = aura;
					debuffsChanged = true;
				elseif type == AuraUpdateChangedType.Buff then
					asframe.buffs[aura.auraInstanceID] = aura;
					buffsChanged = true;
				elseif type == AuraUpdateChangedType.PVP then
					asframe.pvpbuffs[aura.auraInstanceID] = aura;
					pvpbuffsChanged = true;
				elseif type == AuraUpdateChangedType.Dispel then
					asframe.debuffs[aura.auraInstanceID] = aura;
					debuffsChanged = true;
					asframe.dispels[aura.dispelName][aura.auraInstanceID] = aura;
					dispelsChanged = true;
				end
			end
		end

		if unitAuraUpdateInfo.updatedAuraInstanceIDs ~= nil then
			for _, auraInstanceID in ipairs(unitAuraUpdateInfo.updatedAuraInstanceIDs) do
				if asframe.debuffs[auraInstanceID] ~= nil then
					local newAura = C_UnitAuras.GetAuraDataByAuraInstanceID(asframe.displayedUnit, auraInstanceID);
					local oldDebuffType = asframe.debuffs[auraInstanceID].debuffType;
					if newAura ~= nil then
						newAura.debuffType = oldDebuffType;
					end
					asframe.debuffs[auraInstanceID] = newAura;
					debuffsChanged = true;

					for _, tbl in pairs(asframe.dispels) do
						if tbl[auraInstanceID] ~= nil then
							tbl[auraInstanceID] = C_UnitAuras.GetAuraDataByAuraInstanceID(asframe.displayedUnit,
								auraInstanceID);
							dispelsChanged = true;
							break;
						end
					end
				elseif asframe.buffs[auraInstanceID] ~= nil then
					local newAura = C_UnitAuras.GetAuraDataByAuraInstanceID(asframe.displayedUnit, auraInstanceID);
					if newAura ~= nil then
						newAura.isBuff = true;
					end
					asframe.buffs[auraInstanceID] = newAura;
					buffsChanged = true;
				elseif asframe.pvpbuffs[auraInstanceID] ~= nil then
					local newAura = C_UnitAuras.GetAuraDataByAuraInstanceID(asframe.displayedUnit, auraInstanceID);
					if newAura ~= nil then
						newAura.isBuff = true;
					end
					asframe.pvpbuffs[auraInstanceID] = newAura;
					pvpbuffsChanged = true;
				end
			end
		end

		if unitAuraUpdateInfo.removedAuraInstanceIDs ~= nil then
			for _, auraInstanceID in ipairs(unitAuraUpdateInfo.removedAuraInstanceIDs) do
				if asframe.debuffs[auraInstanceID] ~= nil then
					asframe.debuffs[auraInstanceID] = nil;
					debuffsChanged = true;

					for _, tbl in pairs(asframe.dispels) do
						if tbl[auraInstanceID] ~= nil then
							tbl[auraInstanceID] = nil;
							dispelsChanged = true;
							break;
						end
					end
				elseif asframe.buffs[auraInstanceID] ~= nil then
					asframe.buffs[auraInstanceID] = nil;
					buffsChanged = true;
				elseif asframe.pvpbuffs[auraInstanceID] ~= nil then
					asframe.pvpbuffs[auraInstanceID] = nil;
					pvpbuffsChanged = true;
				end
			end
		end
	end

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

			if aura.isBossAura then
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
					showdispell = true;
				end
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

local function asframe_OnEvent(self, event, ...)
	if event == "UNIT_AURA" then
		local unitAuraUpdateInfo = select(2, ...);
		ACRB_UpdateAuras(self.asframe, unitAuraUpdateInfo);
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
		--크기 조정을 위해 아래 코드를 돌린다.
		asraid[frameName].eventframe = CreateFrame("Frame", nil, ACRB_mainframe);
		asraid[frameName].eventframe:Hide();
		asraid[frameName].eventframe.asframe = asraid[frameName];
	end

	if frame.unit then
		asraid[frameName].unit = frame.unit;
	end

	local displayedUnit;

	if frame.displayedUnit then
		asraid[frameName].displayedUnit = frame.displayedUnit;

		if (frame.unit ~= frame.displayedUnit) then
			displayedUnit = frame.displayedUnit;
		end
	else
		asraid[frameName].displayedUnit = frame.unit;
	end

	asraid[frameName].frame = frame;
	asraid[frameName].eventframe:SetScript("OnEvent", nil);

	if not UnitIsPlayer(asraid[frameName].unit) then
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

	local size_x = x / 6 * ACRB_BuffSizeRate;
	local size_y = y / 3 * ACRB_BuffSizeRate;

	local baseSize = math.min(x / 7 * ACRB_BuffSizeRate, y / 3 * ACRB_BuffSizeRate);

	if baseSize > ACRB_MaxBuffSize then
		baseSize = ACRB_MaxBuffSize
	end

	baseSize = baseSize * 0.9;

	local fontsize = baseSize * ACRB_CooldownFontSizeRate;

	if asraid[frameName].isDispellAlert == nil then
		asraid[frameName].isDispellAlert = false;
	end

	if not asraid[frameName].buffcolor then
		asraid[frameName].buffcolor = frame:CreateTexture(nil, "ARTWORK", "asBuffTextureTemplate", -1);
		asraid[frameName].buffcolor:Hide();
	end

	if asraid[frameName].buffcolor then
		local previousTexture = frame.healthBar:GetStatusBarTexture();
		asraid[frameName].buffcolor:ClearAllPoints();
		asraid[frameName].buffcolor:SetAllPoints(previousTexture);
		asraid[frameName].buffcolor:SetVertexColor(0.5, 0.5, 0.5);
	end

	if not asraid[frameName].aborbcolor then
		asraid[frameName].aborbcolor = frame:CreateTexture(nil, "ARTWORK", "asBuffTextureTemplate", 0);
		asraid[frameName].aborbcolor:Hide();
	end

	if asraid[frameName].aborbcolor then
		local previousTexture = frame.healthBar:GetStatusBarTexture();
		asraid[frameName].aborbcolor:ClearAllPoints();
		asraid[frameName].aborbcolor:SetPoint("TOPLEFT", previousTexture, "TOPLEFT", 0, 0);
		asraid[frameName].aborbcolor:SetPoint("BOTTOMLEFT", previousTexture, "BOTTOMLEFT", 0, 0);
		asraid[frameName].aborbcolor:SetWidth(0);
		asraid[frameName].aborbcolor:SetVertexColor(0, 0, 0);
		asraid[frameName].aborbcolor:SetAlpha(0.2);
	end

	if not asraid[frameName].asbuffFrames then
		asraid[frameName].asbuffFrames = {}
		for i = 1, ACRB_MAX_BUFFS do
			local buffFrame = CreateFrame("Button", nil, frame, "asCompactBuffTemplate")
			buffFrame:EnableMouse(ACRB_ShowTooltip);
			buffFrame.icon:SetTexCoord(.08, .92, .08, .92);
			buffFrame.border:SetTexture("Interface\\Addons\\asCompactRaidBuff\\border.tga");
			buffFrame.border:SetTexCoord(0.08, 0.08, 0.08, 0.92, 0.92, 0.08, 0.92, 0.92);
			asraid[frameName].asbuffFrames[i] = buffFrame;
			buffFrame:Hide();
		end
	end

	if asraid[frameName].asbuffFrames then
		for i = 1, ACRB_MAX_BUFFS do
			local buffFrame = asraid[frameName].asbuffFrames[i];
			buffFrame:ClearAllPoints()

			if ACRB_ShowTooltip and not buffFrame:GetScript("OnEnter") then
				buffFrame:SetScript("OnEnter", function(s)
					if s.auraInstanceID then
						GameTooltip_SetDefaultAnchor(GameTooltip, s);
						GameTooltip:SetUnitBuffByAuraInstanceID(asraid[frameName].displayedUnit, s.auraInstanceID,
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
						buffFrame:SetPoint("BOTTOMRIGHT", asraid[frameName].asbuffFrames[i - 3], "TOPRIGHT", 0, 1)
					end
				else
					buffFrame:SetPoint("BOTTOMRIGHT", asraid[frameName].asbuffFrames[i - 1], "BOTTOMLEFT", -1, 0)
				end
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
					buffFrame:SetPoint("BOTTOMRIGHT", asraid[frameName].asbuffFrames[i - 1], "BOTTOMLEFT", -1, 0)
				end
			end
		end
	end


	--크기 조정
	for _, d in ipairs(asraid[frameName].asbuffFrames) do
		d:SetSize(size_x, size_y);

		d.count:SetFont(STANDARD_TEXT_FONT, fontsize, "OUTLINE")
		d.count:ClearAllPoints();
		d.count:SetPoint("BOTTOM", 0, 1);
		if ACRB_ShowBuffCooldown and fontsize >= ACRB_MinShowBuffFontSize then
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

	if not asraid[frameName].asdebuffFrames then
		asraid[frameName].asdebuffFrames = {};
		for i = 1, ACRB_MAX_DEBUFFS do
			local debuffFrame = CreateFrame("Button", nil, frame, "asCompactDebuffTemplate")
			debuffFrame:EnableMouse(ACRB_ShowTooltip);
			debuffFrame.icon:SetTexCoord(.08, .92, .08, .92);
			debuffFrame.border:SetTexture("Interface\\Addons\\asCompactRaidBuff\\border.tga");
			debuffFrame.border:SetTexCoord(0.08, 0.08, 0.08, 0.92, 0.92, 0.08, 0.92, 0.92);
			asraid[frameName].asdebuffFrames[i] = debuffFrame;
			debuffFrame:Hide();
		end
	end

	if asraid[frameName].asbuffFrames then
		for i = 1, ACRB_MAX_DEBUFFS do
			local debuffFrame = asraid[frameName].asdebuffFrames[i];
			debuffFrame:ClearAllPoints()

			if math.fmod(i - 1, 3) == 0 then
				if i == 1 then
					local debuffPos, debuffRelativePoint, debuffOffset = "BOTTOMLEFT", "BOTTOMRIGHT",
						CUF_AURA_BOTTOM_OFFSET + powerBarUsedHeight;
					debuffFrame:ClearAllPoints();
					debuffFrame:SetPoint(debuffPos, frame, "BOTTOMLEFT", 3, debuffOffset);
				else
					debuffFrame:SetPoint("BOTTOMLEFT", asraid[frameName].asdebuffFrames[i - 3], "TOPLEFT", 0, 1)
				end
			else
				debuffFrame:SetPoint("BOTTOMLEFT", asraid[frameName].asdebuffFrames[i - 1], "BOTTOMRIGHT", 1, 0)
			end

			if ACRB_ShowTooltip and not debuffFrame:GetScript("OnEnter") then
				debuffFrame:SetScript("OnEnter", function(s)
					if s.auraInstanceID then
						GameTooltip_SetDefaultAnchor(GameTooltip, s);
						GameTooltip:SetUnitDebuffByAuraInstanceID(asraid[frameName].displayedUnit, s.auraInstanceID,
							debufffilter);
					end
				end)

				debuffFrame:SetScript("OnLeave", function()
					GameTooltip:Hide();
				end)
			end
		end
	end

	for _, d in ipairs(asraid[frameName].asdebuffFrames) do
		d.size_x, d.size_y = size_x, size_y; -- 디버프
		d.maxHeight = frameHeight - powerBarUsedHeight - CUF_AURA_BOTTOM_OFFSET - CUF_NAME_SECTION_SIZE;
		d.count:SetFont(STANDARD_TEXT_FONT, fontsize, "OUTLINE")
		d.count:ClearAllPoints();
		d.count:SetPoint("BOTTOM", 0, 1);

		if ACRB_ShowBuffCooldown and fontsize >= ACRB_MinShowBuffFontSize then
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


	if not asraid[frameName].asdispelDebuffFrames then
		asraid[frameName].asdispelDebuffFrames = {};
		for i = 1, ACRB_MAX_DISPELDEBUFFS do
			local dispelDebuffFrame = CreateFrame("Button", nil, frame, "asCompactDispelDebuffTemplate")
			dispelDebuffFrame:EnableMouse(false);
			asraid[frameName].asdispelDebuffFrames[i] = dispelDebuffFrame;
			dispelDebuffFrame:Hide();
		end
	end

	asraid[frameName].asdispelDebuffFrames[1]:SetPoint("RIGHT", asraid[frameName].asbuffFrames[(ACRB_MAX_BUFFS - 2)],
		"LEFT", -1, 0);
	for i = 1, ACRB_MAX_DISPELDEBUFFS do
		if (i > 1) then
			asraid[frameName].asdispelDebuffFrames[i]:SetPoint("RIGHT", asraid[frameName].asdispelDebuffFrames[i - 1],
				"LEFT", 0, 0);
		end
		asraid[frameName].asdispelDebuffFrames[i]:SetSize(baseSize, baseSize);
	end

	if (not asraid[frameName].asManabar and not frame.powerBar:IsShown()) then
		asraid[frameName].asManabar = CreateFrame("StatusBar", nil, frame.healthBar)
		asraid[frameName].asManabar:SetStatusBarTexture("Interface\\Addons\\asCompactRaidBuff\\UI-StatusBar")
		asraid[frameName].asManabar:GetStatusBarTexture():SetHorizTile(false)
		asraid[frameName].asManabar:SetMinMaxValues(0, 100)
		asraid[frameName].asManabar:SetValue(100)
		asraid[frameName].asManabar:SetPoint("BOTTOM", frame.healthBar, "BOTTOM", 0, 0)
		asraid[frameName].asManabar:Hide();
	end

	if asraid[frameName].asManabar then
		asraid[frameName].asManabar:SetWidth(x - 2);
		asraid[frameName].asManabar:SetHeight(ACRB_HealerManaBarHeight)
	end

	if (not asraid[frameName].asraidicon) then
		asraid[frameName].asraidicon = frame:CreateFontString(nil, "OVERLAY")
		asraid[frameName].asraidicon:SetFont(STANDARD_TEXT_FONT, fontsize * 2)
		asraid[frameName].asraidicon:SetPoint("LEFT", frame.healthBar, "LEFT", 2, 0)
		asraid[frameName].asraidicon:Hide();
	end

	asraid[frameName].asraidicon:SetFont(STANDARD_TEXT_FONT, fontsize * 2);

	if (not asraid[frameName].pvpbuffFrames) then
		asraid[frameName].pvpbuffFrames = {};

		for i = 1, ACRB_MAX_BUFFS_2 do
			asraid[frameName].pvpbuffFrames[i] = CreateFrame("Button", nil, frame, "asCompactBuffTemplate")
			asraid[frameName].pvpbuffFrames[i]:EnableMouse(ACRB_ShowTooltip);
			asraid[frameName].pvpbuffFrames[i].icon:SetTexCoord(.08, .92, .08, .92);
			asraid[frameName].pvpbuffFrames[i].count:SetFont(STANDARD_TEXT_FONT, fontsize, "OUTLINE");
			asraid[frameName].pvpbuffFrames[i].count:ClearAllPoints();
			asraid[frameName].pvpbuffFrames[i].count:SetPoint("BOTTOM", 0, 0);
			asraid[frameName].pvpbuffFrames[i]:Hide();

			if ACRB_ShowBuffCooldown and fontsize >= ACRB_MinShowBuffFontSize then
				asraid[frameName].pvpbuffFrames[i].cooldown:SetHideCountdownNumbers(false);
				for _, r in next, { asraid[frameName].pvpbuffFrames[i].cooldown:GetRegions() } do
					if r:GetObjectType() == "FontString" then
						r:SetFont(STANDARD_TEXT_FONT, fontsize, "OUTLINE");
						r:ClearAllPoints();
						r:SetPoint("TOP", 0, 2);
						break
					end
				end
			else
				asraid[frameName].pvpbuffFrames[i].cooldown:SetHideCountdownNumbers(true);
			end
		end
	end

	if (asraid[frameName].pvpbuffFrames) then
		for i = 1, ACRB_MAX_BUFFS_2 do
			asraid[frameName].pvpbuffFrames[i]:SetSize(size_x, size_y);
			asraid[frameName].pvpbuffFrames[i].count:SetFont(STANDARD_TEXT_FONT, fontsize, "OUTLINE");
			asraid[frameName].pvpbuffFrames[i]:ClearAllPoints()
			if i == 1 then
				asraid[frameName].pvpbuffFrames[i]:SetPoint("CENTER", frame.healthBar, "CENTER", 0, 0)
			else
				asraid[frameName].pvpbuffFrames[i]:SetPoint("TOPRIGHT", asraid[frameName].pvpbuffFrames[i - 1], "TOPLEFT",
					0,
					0)
			end

			if ACRB_ShowTooltip and not asraid[frameName].pvpbuffFrames[i]:GetScript("OnEnter") then
				asraid[frameName].pvpbuffFrames[i]:SetScript("OnEnter", function(s)
					if s.auraInstanceID then
						GameTooltip_SetDefaultAnchor(GameTooltip, s);
						GameTooltip:SetUnitBuffByAuraInstanceID(asraid[frameName].displayedUnit, s.auraInstanceID,
							bufffilter);
					end
				end)

				asraid[frameName].pvpbuffFrames[i]:SetScript("OnLeave", function()
					GameTooltip:Hide();
				end)
			end
		end
	end


	if (not asraid[frameName].castFrames) then
		asraid[frameName].castFrames = {};

		for i = 1, ACRB_MAX_CASTING do
			asraid[frameName].castFrames[i] = CreateFrame("Button", nil, frame, "asCompactBuffTemplate")
			asraid[frameName].castFrames[i]:EnableMouse(ACRB_ShowTooltip);
			asraid[frameName].castFrames[i].icon:SetTexCoord(.08, .92, .08, .92);
			asraid[frameName].castFrames[i].count:SetFont(STANDARD_TEXT_FONT, fontsize, "OUTLINE");
			asraid[frameName].castFrames[i].count:ClearAllPoints();
			asraid[frameName].castFrames[i].count:SetPoint("BOTTOM", 0, 0);
			asraid[frameName].castFrames[i]:Hide();

			if ACRB_ShowBuffCooldown and fontsize >= ACRB_MinShowBuffFontSize then
				asraid[frameName].castFrames[i].cooldown:SetHideCountdownNumbers(false);
				for _, r in next, { asraid[frameName].castFrames[i].cooldown:GetRegions() } do
					if r:GetObjectType() == "FontString" then
						r:SetFont(STANDARD_TEXT_FONT, fontsize, "OUTLINE");
						r:ClearAllPoints();
						r:SetPoint("TOP", 0, 2);
						break
					end
				end
			else
				asraid[frameName].castFrames[i].cooldown:SetHideCountdownNumbers(true);
			end

			if ACRB_ShowTooltip and not asraid[frameName].castFrames[i]:GetScript("OnEnter") then
				asraid[frameName].castFrames[i]:SetScript("OnEnter", function(s)
					if s.castspellid and s.castspellid > 0 then
						GameTooltip_SetDefaultAnchor(GameTooltip, s);
						GameTooltip:SetSpellByID(s.castspellid);
					end
				end)

				asraid[frameName].castFrames[i]:SetScript("OnLeave", function()
					GameTooltip:Hide();
				end)
			end
		end
	end

	if (asraid[frameName].castFrames) then
		for i = 1, ACRB_MAX_CASTING do
			asraid[frameName].castFrames[i]:SetSize(size_x, size_y);
			asraid[frameName].castFrames[i].count:SetFont(STANDARD_TEXT_FONT, fontsize, "OUTLINE");
			asraid[frameName].castFrames[i]:ClearAllPoints()
			if i == 1 then
				asraid[frameName].castFrames[i]:SetPoint("TOP", frame.healthBar, "TOP", 0, 0)
			else
				asraid[frameName].castFrames[i]:SetPoint("TOPRIGHT", asraid[frameName].castFrames[i - 1], "TOPLEFT", -1,
					0)
			end
		end
	end

	asraid[frameName].ncasting = 0;

	asraid[frameName].eventframe:RegisterUnitEvent("UNIT_AURA", asraid[frameName].unit, displayedUnit);
	asraid[frameName].eventframe:SetScript("OnEvent", asframe_OnEvent);

	ACRB_UpdateAuras(asraid[frameName], nil);
end


local function ARCB_UpdateAll(frame)
	if frame and not frame:IsForbidden() and frame.GetName then
		local name = frame:GetName();

		if name and not (name == nil) and (string.find(name, "CompactRaidGroup") or string.find(name, "CompactPartyFrameMember") or string.find(name, "CompactRaidFrame")) then
			ACRB_disableDefault(frame);
			ACRB_setupFrame(frame);
			mustdisable = true;
		end
	end
end

local function ACRB_updatePartyAllAura()
	if (IsInGroup() or (ACRB_ShowWhenSolo)) then
		if IsInRaid() then -- raid
			if together == true then
				for i = 1, 8 do
					for k = 1, 5 do
						local frame = _G["CompactRaidGroup" .. i .. "Member" .. k]
						ACRB_setupFrame(frame);
					end
				end
			else
				for i = 1, 40 do
					local frame = _G["CompactRaidFrame" .. i]
					ACRB_setupFrame(frame);
				end
			end
		else -- party
			for i = 1, 5 do
				local frame = _G["CompactPartyFrameMember" .. i]
				ACRB_setupFrame(frame);
			end
		end
	end
end

ACRB_InitList();

local function DumpCaches()
	cachedVisualizationInfo = {};
	cachedSelfBuffChecks = {};
	cachedPriorityChecks = {};
	ACRB_updatePartyAllAura();
end

local function ACRB_OnEvent(self, event, ...)
	local arg1 = ...;

	if (event == "PLAYER_ENTERING_WORLD") then
		ACRB_InitList();
		mustdisable = true;
		hasValidPlayer = true;
		local bloaded = LoadAddOn("DBM-Core");
		if bloaded then
			DBM:RegisterCallback("DBM_TimerStart", ACTA_DBMTimer_callback);
		end
		updateTankerList();
		DumpCaches();
	elseif (event == "PLAYER_SPECIALIZATION_CHANGED") then
		ACRB_InitList();
		DumpCaches();
	elseif (event == "GROUP_ROSTER_UPDATE") or (event == "CVAR_UPDATE") or (event == "ROLE_CHANGED_INFORM") then
		updateTankerList();
		mustdisable = true;
	elseif (event == "PLAYER_REGEN_ENABLED" or event == "PLAYER_REGEN_DISABLED") then
		DumpCaches();
	elseif (event == "PLAYER_LEAVING_WORLD") then
		hasValidPlayer = false;
	elseif (event == "COMPACT_UNIT_FRAME_PROFILES_LOADED") then
		together = EditModeManagerFrame:ShouldRaidFrameShowSeparateGroups();
		if together == nil then
			together = true;
		end
	end
end

ACRB_mainframe:SetScript("OnEvent", ACRB_OnEvent)
ACRB_mainframe:RegisterEvent("GROUP_ROSTER_UPDATE");
ACRB_mainframe:RegisterEvent("PLAYER_ENTERING_WORLD");
ACRB_mainframe:RegisterEvent("PLAYER_LEAVING_WORLD");
--ACRB_mainframe:RegisterUnitEvent("UNIT_SPELLCAST_SUCCEEDED", "player");
ACRB_mainframe:RegisterEvent("PLAYER_SPECIALIZATION_CHANGED");
ACRB_mainframe:RegisterEvent("CVAR_UPDATE");
ACRB_mainframe:RegisterEvent("ROLE_CHANGED_INFORM");
ACRB_mainframe:RegisterEvent("COMPACT_UNIT_FRAME_PROFILES_LOADED");
ACRB_mainframe:RegisterEvent("VARIABLES_LOADED");
ACRB_mainframe:RegisterEvent("PLAYER_REGEN_ENABLED");
ACRB_mainframe:RegisterEvent("PLAYER_REGEN_DISABLED");

C_Timer.NewTicker(ACRB_UpdateRate, ACRB_OnUpdate);

hooksecurefunc("CompactUnitFrame_UpdateAll", ARCB_UpdateAll);
