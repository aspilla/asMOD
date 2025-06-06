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

local auraData = {};
auraData.bufffilter = CreateFilterString(AuraFilters.Helpful, AuraFilters.Player, AuraFilters.IncludeNameplateOnly);
auraData.debufffilter = CreateFilterString(AuraFilters.Harmful, AuraFilters.Player);
local debufflist = {};

function ns.ClearLists()
    debufflist = {};
end

function ns.AddDebuff(auras)
    if auras then
        debufflist[auras] = true;            
    end
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
        if aura and debufflist[aura.spellId] then
            auraData.debuffs[aura.spellId] = aura;
        end
    end
    ForEachAura(unit, auraData.debufffilter, batchCount, HandleAura, usePackedAura);

    return auraData.debuffs;
end
