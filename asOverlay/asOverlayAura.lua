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
		return spellInfo.name, nil, spellInfo.iconID, spellInfo.castTime, spellInfo.minRange, spellInfo.maxRange, spellInfo.spellID, spellInfo.originalIconID;
	end
end

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

local function ProcessAura(aura, id, name)
    if aura == nil then
        return false;
    end

    if aura.spellId == id or aura.name == name then
        return true;
    end
end

local auraData = {};
auraData.bufffilter = CreateFilterString(AuraFilters.Helpful, AuraFilters.Player, AuraFilters.IncludeNameplateOnly);

local function ParseAllAuras(unit, id)
    if auraData.buffs == nil then
        auraData.buffs = TableUtil.CreatePriorityTable(DefaultCompare, TableUtil.Constants.AssociativePriorityTable);
    else
        auraData.buffs:Clear();
    end

    local batchCount = nil;
    local usePackedAura = true;
    local name = asGetSpellInfo(id);
    local function HandleAura(aura)
        local type = ProcessAura(aura, id, name);

        if type then
            auraData.buffs[aura.auraInstanceID] = aura;
        end
    end
    ForEachAura(unit, auraData.bufffilter, batchCount, HandleAura, usePackedAura);
end

function ns.getExpirationTimeUnitAurabyID(unit, id, idonly)
    ParseAllAuras(unit, id);

    local auraList = auraData.buffs;
    local ret = nil;

    auraList:Iterate(function(auraInstanceID, aura)
        if aura.spellId == id then
            ret = aura;
        end
    end);

    if ret == nil and not idonly then
        local name = asGetSpellInfo(id);

        auraList:Iterate(function(auraInstanceID, aura)
            if aura.name == name then
                ret = aura;
            end
        end);
    end

    return ret;
end
