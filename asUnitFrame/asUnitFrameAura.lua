local _, ns = ...;

--AuraUtil


local UnitFrameDebuffType = EnumUtil.MakeEnum(

    "NonBossDebuff",
    "NonBossRaidDebuff",
    "PriorityDebuff",
    "namePlateShowAll",
    "nameplateShowPersonal",
    "BossBuff",
    "BossDebuff"
);

local AuraUpdateChangedType = EnumUtil.MakeEnum(
    "None",
    "Debuff",
    "Buff",
    "PVP",
    "Dispel"
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

local activeDebuffs = {};

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

local function ProcessAura(aura, unit)
    if aura == nil or aura.icon == nil or unit == nil or not aura.isHarmful then
        return AuraUpdateChangedType.None;
    end


    if not aura.isRaid then
        if aura.isBossAura then
            aura.debuffType = UnitFrameDebuffType.BossDebuff
        elseif IsPriorityDebuff(aura.spellId) then
            aura.debuffType = UnitFrameDebuffType.PriorityDebuff;
        else
            aura.debuffType = UnitFrameDebuffType.NonBossDebuff;
        end
    elseif aura.isRaid then
        aura.debuffType = aura.isBossAura and UnitFrameDebuffType.BossDebuff or
            UnitFrameDebuffType.NonBossRaidDebuff;
    else
        aura.debuffType = UnitFrameDebuffType.NonBossDebuff;
    end

    activeDebuffs[unit][aura.auraInstanceID] = aura;

    return AuraUpdateChangedType.Debuff;
end

local filter = CreateFilterString(AuraFilters.Harmful);
local function ParseAllAuras(unit)
    
    if activeDebuffs[unit] == nil then
        activeDebuffs[unit] = TableUtil.CreatePriorityTable(UnitFrameDebuffComparator,
            TableUtil.Constants.AssociativePriorityTable);
    else
        activeDebuffs[unit]:Clear();
    end

    local function HandleAura(aura)        
        ProcessAura(aura, unit);
        return false;
    end

    local batchCount = nil;
    local usePackedAura = true;
    
    ForEachAura(unit, filter, batchCount, HandleAura, usePackedAura);
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

local function UpdateAuraFrames(frame, auraList)
    local i = 0;
    local parent = frame;
    local unit = frame.unit;

    auraList:Iterate(
        function(auraInstanceID, aura)
            i = i + 1;
            if i > #(frame.frames) then
                return true;
            end

            local frame = parent.frames[i];

            frame.unit = unit;
            frame.auraInstanceID = aura.auraInstanceID;

            -- set the icon
            local frameIcon = frame.icon
            frameIcon:SetTexture(aura.icon);
            -- set the count
            local frameCount = frame.count;
            local alert = false;

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

            local color = nil;
            -- set debuff type color
            if (aura.dispelName) then
                color = DebuffTypeColor[aura.dispelName];
            else
                color = DebuffTypeColor["none"];
            end

            local frameBorder = frame.border;
            if aura.nameplateShowAll then
                frameBorder:SetVertexColor(0.3, 0.3, 0.3);
            else
                frameBorder:SetVertexColor(color.r, color.g, color.b);
            end

            frame:Show();
            return false;
        end);

    for j = i + 1, #frame.frames do
        local frame = parent.frames[j];

        if (frame) then
            frame:Hide();
        end
    end
end

function ns.UpdateAuras(frame)
    local unit = frame.unit;

    ParseAllAuras(unit);
    UpdateAuraFrames(frame, activeDebuffs[unit]);
end
