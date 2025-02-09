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
auraData.buffs = {};
auraData.debuffs = {};
auraData.bufffilter = CreateFilterString(AuraFilters.Helpful, AuraFilters.Player, AuraFilters.IncludeNameplateOnly);
auraData.debufffilter = CreateFilterString(AuraFilters.Harmful, AuraFilters.Player);
local bufftime = {};
local debufftime = {};
ns.needtocheckAura = true;
local bufflist = {};
local debufflist = {};

function ns.ClearLists()
    bufflist = {};
    debufflist = {};
end

function ns.AddBuff(auras)

    if auras then
        if type(auras) == "table" then
            for _, id in pairs(auras) do
                bufflist[id] = true;    
            end
        else    
            bufflist[auras] = true;
        end
    end
end

function ns.AddBuffC(auras)

    if auras then
        for _, list in pairs(auras) do
            if type(list) == "table" and list[1] then
                bufflist[list[1]] = true;                  
            end            
        end
    end
end

function ns.AddDebuff(auras)

    if auras then
        if type(auras) == "table" then
            for _, id in pairs(auras) do
                debufflist[id] = true;                
            end
        else    
            debufflist[auras] = true;            
        end
    end
end

function ns.GetAuraDataBySpellName(unit, spell, bdebuff)

    if bdebuff then
        return C_UnitAuras.GetAuraDataBySpellName(unit, spell, auraData.debufffilter);
    else
        return C_UnitAuras.GetAuraDataBySpellName(unit, spell, auraData.bufffilter);
    end

end

function ns.ParseAllBuff(unit)

    if bufftime[unit] and GetTime() - bufftime[unit] < 0.1 and not((unit == "player" or unit == "pet") and ns.needtocheckAura) then        
        return auraData.buffs[unit]
    end

    ns.needtocheckAura = false;

    bufftime[unit] = GetTime();

    if auraData.buffs[unit] == nil then
        auraData.buffs[unit] = TableUtil.CreatePriorityTable(DefaultCompare, TableUtil.Constants.AssociativePriorityTable);
    else
        auraData.buffs[unit]:Clear();
    end

    local batchCount = nil;
    local usePackedAura = true;
    local function HandleAura(aura)
        if aura and bufflist[aura.spellId] then
            auraData.buffs[unit][aura.spellId] = aura;
        end
    end
    ForEachAura(unit, auraData.bufffilter, batchCount, HandleAura, usePackedAura);

    return auraData.buffs[unit];
end

function ns.ParseAllDebuff(unit)

    if debufftime[unit] and GetTime() - debufftime[unit] < 0.1 then        
        return auraData.debuffs[unit]
    end

    debufftime[unit] = GetTime();

    if auraData.debuffs[unit] == nil then
        auraData.debuffs[unit] = TableUtil.CreatePriorityTable(DefaultCompare, TableUtil.Constants.AssociativePriorityTable);
    else
        auraData.debuffs[unit]:Clear();
    end

    local batchCount = nil;
    local usePackedAura = true;
    local function HandleAura(aura)
        if aura and debufflist[aura.spellId] then
            auraData.debuffs[unit][aura.spellId] = aura;            
        end
    end
    ForEachAura(unit, auraData.debufffilter, batchCount, HandleAura, usePackedAura);

    return auraData.debuffs[unit];
end
