local _, ns = ...;

local AuraFilters = {
    Helpful = "HELPFUL",
    Harmful = "HARMFUL",
    Raid = "RAID",
    IncludeNameplateOnly = "INCLUDE_NAME_PLATE_ONLY",
    Player = "PLAYER",
    Cancelable = "CANCELABLE",
    NotCancelable = "NOT_CANCELABLE",
    Maw = "MAW"
};

local function CreateFilterString(...)
    return table.concat({...}, '|');
end

local function DefaultCompare(a, b)
    return a.auraInstanceID < b.auraInstanceID;
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

local auraData = {};
auraData.bufffilter = CreateFilterString(AuraFilters.Helpful, AuraFilters.Player, AuraFilters.IncludeNameplateOnly);
auraData.debufffilter = CreateFilterString(AuraFilters.Harmful, AuraFilters.Player);

function ns.ParseAllBuff(unit)

    if auraData.buffs == nil then
        auraData.buffs = TableUtil.CreatePriorityTable(DefaultCompare, TableUtil.Constants.AssociativePriorityTable);
    else
        auraData.buffs:Clear();
    end

    local batchCount = nil;
    local usePackedAura = true;
    local function HandleAura(aura)
        if aura then
            auraData.buffs[aura.auraInstanceID] = aura;
        end
    end
    ForEachAura(unit, auraData.bufffilter, batchCount, HandleAura, usePackedAura);

    return auraData.buffs;
end

function ns.ParseAllDebuff(unit)

    if auraData.debuffs == nil then
        auraData.debuffs = TableUtil.CreatePriorityTable(DefaultCompare, TableUtil.Constants.AssociativePriorityTable);
    else
        auraData.debuffs:Clear();
    end

    local batchCount = nil;
    local usePackedAura = true;
    local function HandleAura(aura)
        if aura then
            auraData.debuffs[aura.auraInstanceID] = aura;
        end
    end
    ForEachAura(unit, auraData.debufffilter, batchCount, HandleAura, usePackedAura);

    return auraData.debuffs;
end
