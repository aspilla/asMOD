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
    return table.concat({ ... }, '|');
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
local bufflist = {};
local debufflist = {};
local buffscanall = true;
local debuffscanall = true;

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
    buffscanall = true;
end

function ns.AddBuffC(auras)
    if auras then
        for _, list in pairs(auras) do
            if type(list) == "table" and list[1] then
                bufflist[list[1]] = true;
            end
        end
    end
    buffscanall = true;
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

    debuffscanall = true;
end

function ns.GetAuraDataBySpellName(unit, spell, bdebuff)
    if bdebuff then
        return C_UnitAuras.GetAuraDataBySpellName(unit, spell, auraData.debufffilter);
    else
        return C_UnitAuras.GetAuraDataBySpellName(unit, spell, auraData.bufffilter);
    end
end


local function parseAllBuff(unit)
    if auraData.buffs[unit] == nil then
        auraData.buffs[unit] = TableUtil.CreatePriorityTable(DefaultCompare, TableUtil.Constants
            .AssociativePriorityTable);
    else
        auraData.buffs[unit]:Clear();
    end

    local batchCount = nil;
    local usePackedAura = true;
    local function HandleAura(aura)
        if aura and bufflist[aura.spellId] then
            auraData.buffs[unit][aura.auraInstanceID] = aura;
        end
    end
    ForEachAura(unit, auraData.bufffilter, batchCount, HandleAura, usePackedAura);

    return;
end

local function updateBuffs(unit, unitAuraUpdateInfo, callback_func)
    local buffupdated = false;

    if auraData.buffs[unit] == nil then
        unitAuraUpdateInfo = nil;
    end


    if unitAuraUpdateInfo == nil or unitAuraUpdateInfo.isFullUpdate or buffscanall then
        parseAllBuff(unit);
        buffscanall = false;
        buffupdated = true;
    else
        local bufffilter = auraData.bufffilter;
        local buffData = auraData.buffs[unit];

        if unitAuraUpdateInfo.addedAuras ~= nil then
            for _, aura in ipairs(unitAuraUpdateInfo.addedAuras) do
                if not C_UnitAuras.IsAuraFilteredOutByInstanceID(unit, aura.auraInstanceID, bufffilter) then
                    if aura and bufflist[aura.spellId] then
                        buffData[aura.auraInstanceID] = aura;
                        buffupdated = true;
                    end
                end
            end
        end

        if unitAuraUpdateInfo.updatedAuraInstanceIDs ~= nil then
            for _, auraInstanceID in ipairs(unitAuraUpdateInfo.updatedAuraInstanceIDs) do
                if buffData[auraInstanceID] ~= nil then
                    local newAura = C_UnitAuras.GetAuraDataByAuraInstanceID(unit, auraInstanceID);
                    buffData[auraInstanceID] = newAura;
                    buffupdated = true;
                end
            end
        end

        if unitAuraUpdateInfo.removedAuraInstanceIDs ~= nil then
            for _, auraInstanceID in ipairs(unitAuraUpdateInfo.removedAuraInstanceIDs) do
                if buffData[auraInstanceID] ~= nil then
                    buffData[auraInstanceID] = nil;
                    buffupdated = true;
                end
            end
        end
    end

    if buffupdated and callback_func then
        callback_func();
    end
end

local function onBuffEvent(self, event, ...)
    if (event == "UNIT_AURA") then
        local unit, info = ...;
        updateBuffs(unit, info, ns.update_callback);
    else
        updateBuffs("pet", nil, ns.update_callback);
    end
end

local buffeventframe = CreateFrame("Frame");
buffeventframe:RegisterUnitEvent("UNIT_AURA", "player", "pet");
buffeventframe:RegisterUnitEvent("UNIT_PET", "player");
buffeventframe:SetScript("OnEvent", onBuffEvent);

local function parseAllDebuff(unit)
    if auraData.debuffs[unit] == nil then
        auraData.debuffs[unit] = TableUtil.CreatePriorityTable(DefaultCompare,
            TableUtil.Constants.AssociativePriorityTable);
    else
        auraData.debuffs[unit]:Clear();
    end

    local batchCount = nil;
    local usePackedAura = true;
    local function HandleAura(aura)
        if aura and debufflist[aura.spellId] then
            auraData.debuffs[unit][aura.auraInstanceID] = aura;
        end
    end
    ForEachAura(unit, auraData.debufffilter, batchCount, HandleAura, usePackedAura);

    return;
end

local function updateDebuffs(unit, unitAuraUpdateInfo, callback_func)
    local debuffupdated = false;
    if auraData.debuffs[unit] == nil then
        unitAuraUpdateInfo = nil;
    end


    if unitAuraUpdateInfo == nil or unitAuraUpdateInfo.isFullUpdate or debuffscanall then
        parseAllDebuff(unit);
        debuffscanall = false;
        debuffupdated = true;
    else
        local debufffilter = auraData.debufffilter;
        local debuffData = auraData.debuffs[unit];

        if unitAuraUpdateInfo.addedAuras ~= nil then
            for _, aura in ipairs(unitAuraUpdateInfo.addedAuras) do
                if not C_UnitAuras.IsAuraFilteredOutByInstanceID(unit, aura.auraInstanceID, debufffilter) then
                    if aura and debufflist[aura.spellId] then
                        debuffData[aura.auraInstanceID] = aura;
                        debuffupdated = true;
                    end
                end
            end
        end

        if unitAuraUpdateInfo.updatedAuraInstanceIDs ~= nil then
            for _, auraInstanceID in ipairs(unitAuraUpdateInfo.updatedAuraInstanceIDs) do
                if debuffData[auraInstanceID] ~= nil then
                    local newAura = C_UnitAuras.GetAuraDataByAuraInstanceID(unit, auraInstanceID);
                    debuffData[auraInstanceID] = newAura;
                    debuffupdated = true;
                end
            end
        end

        if unitAuraUpdateInfo.removedAuraInstanceIDs ~= nil then
            for _, auraInstanceID in ipairs(unitAuraUpdateInfo.removedAuraInstanceIDs) do
                if debuffData[auraInstanceID] ~= nil then
                    debuffData[auraInstanceID] = nil;
                    debuffupdated = true;
                end
            end
        end
    end

    if debuffupdated and callback_func then
        callback_func();
    end
end

local function onDebuffEvent(self, event, ...)
    if (event == "UNIT_AURA") then
        local unit, info = ...;
        updateDebuffs(unit, info, ns.update_callback);
    elseif (event == "PLAYER_TARGET_CHANGED") then
        updateDebuffs("target", nil, ns.update_callback);
    else  
        auraData.buffs = {};
        auraData.debuffs = {};
    end
end
local debuffeventframe = CreateFrame("Frame");
debuffeventframe:RegisterUnitEvent("UNIT_AURA", "player", "target");
debuffeventframe:RegisterEvent("PLAYER_TARGET_CHANGED");
debuffeventframe:RegisterEvent("PLAYER_ENTERING_WORLD");
debuffeventframe:SetScript("OnEvent", onDebuffEvent);

function ns.getUnitBuffByID(unit, spellId)
    if not (unit == "player" or unit == "pet") then
       updateBuffs(unit);
    end
    local ret = nil;
    if auraData.buffs[unit] then
        auraData.buffs[unit]:Iterate(
            function(auraInstanceID, aura)
                if aura.spellId == spellId then
                    ret = aura;
                    return true;
                end
                return false
            end);
    end

    return ret;
end

function ns.getUnitDebuffByID(unit, spellId)
    if not (unit == "player" or unit == "target") then
       updateBuffs(unit);
    end
    local ret = nil;
    if auraData.debuffs[unit] then
        auraData.debuffs[unit]:Iterate(
            function(auraInstanceID, aura)
                if aura.spellId == spellId then
                    ret = aura;
                    return true;
                end
                return false
            end);
    end

    return ret;
end