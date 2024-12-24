local _, ns = ...;

-- AuraUtil
local PLAYER_UNITS = {
    player = true,
    vehicle = true,
    pet = true
};

local AuraUpdateChangedType = EnumUtil.MakeEnum("None", "Debuff", "Buff");

ns.UnitFrameDebuffType = EnumUtil.MakeEnum("Normal", "namePlateShowAll", "Player", "nameplateShowPersonal", "Priority");

ns.UnitFrameBuffType = EnumUtil.MakeEnum("Normal", "PVP", "Stealable", "nameplateShowPersonal");

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

local function UnitFrameDebuffComparator(a, b)
    if a.debuffType ~= b.debuffType then
        return a.debuffType > b.debuffType;
    end

    return DefaultAuraCompare(a, b);
end

local function UnitFrameBuffComparator(a, b)
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

local function ProcessAura(aura, unit, type)
    if aura == nil then
        return AuraUpdateChangedType.None;
    end

    local isPlayer = PLAYER_UNITS[aura.sourceUnit];

    if type == 1 then
        if aura.isHarmful then
            local show = false;
            aura.showlist = ns.ANameP_ShowList and ns.ANameP_ShowList[aura.spellId];
            

            if ns.options.ANameP_ShowMyAll then
                if aura.duration <= ns.ANameP_BuffMaxCool then
                    show = true;
                end
            else
                if (aura.nameplateShowPersonal or
                        (ns.options.ANameP_ShowKnownSpell and (ns.KnownSpellList[aura.name] or ns.KnownSpellList[aura.icon]))) then
                    show = true;
                elseif aura.showlist then
                    show = true;
                end
            end

            if ns.options.ANameP_ShowListOnly then
                if not (aura.showlist) then
                    show = false;
                end
            end

            if not isPlayer then
                show = false;
            end

            if aura.nameplateShowAll and (isPlayer or not ns.ANameP_ShowOnlyMine[aura.spellId]) then
                show = true;
            end

            if show and ns.ANameP_BlackList[aura.spellId] then
                show = false;
            end

            if show then
                if aura.showlist then                    
                    aura.debuffType = ns.UnitFrameDebuffType.Priority + aura.showlist[2];
                elseif isPlayer then
                    if aura.nameplateShowPersonal then
                        aura.debuffType = ns.UnitFrameDebuffType.nameplateShowPersonal;
                    else
                        aura.debuffType = ns.UnitFrameDebuffType.Player;
                    end
                elseif aura.nameplateShowAll then
                    aura.debuffType = ns.UnitFrameDebuffType.namePlateShowAll;

                    if aura.duration == 0 or aura.duration > 10 then
                        return AuraUpdateChangedType.None;
                    end
                else
                    aura.debuffType = ns.UnitFrameDebuffType.Normal;
                end
                return AuraUpdateChangedType.Debuff;
            end
        elseif aura.isHelpful then
            local show = false;
            local isPVP = ns.ANameP_PVPBuffList and ns.ANameP_PVPBuffList[aura.spellId];
            if isPVP then
                show = true;
            elseif aura.isStealable then
                show = true;
            end

            if show and ns.ANameP_BlackList[aura.spellId] then
                show = false;
            end

            if show then
                if aura.isStealable then
                    aura.debuffType = ns.UnitFrameBuffType.Stealable;
                elseif isPVP then
                    aura.debuffType = ns.UnitFrameBuffType.PVP;
                else
                    aura.debuffType = ns.UnitFrameBuffType.Normal;
                end

                return AuraUpdateChangedType.Buff;
            end
        end
    elseif type == 2 then
        if aura.isHelpful then
            local show = false;

            if ns.options.ANameP_ShowPlayerBuffAll == false then
                show = aura.nameplateShowPersonal;
            else
                if ns.ANameP_ShowPlayerBuff and isPlayer and aura.duration > 0 and aura.duration <=
                    ns.ANameP_BuffMaxCool then
                    show = true;
                end
            end

            if show then
                if aura.nameplateShowPersonal then
                    aura.debuffType = ns.UnitFrameBuffType.nameplateShowPersonal;
                else
                    aura.debuffType = ns.UnitFrameBuffType.Normal;
                end

                return AuraUpdateChangedType.Buff;
            end
        end
    end

    return AuraUpdateChangedType.None;
end

local auraDatas = {};

local function ParseAllAuras(unit)
    local auraData = auraDatas[unit];

    if not auraData then
        return;
    end

    if auraData.debuffs == nil then
        auraData.debuffs = TableUtil.CreatePriorityTable(UnitFrameDebuffComparator,
            TableUtil.Constants.AssociativePriorityTable);
        auraData.buffs = TableUtil.CreatePriorityTable(UnitFrameBuffComparator,
            TableUtil.Constants.AssociativePriorityTable);
    else
        auraData.debuffs:Clear();
        auraData.buffs:Clear();
    end

    local batchCount = nil;
    local usePackedAura = true;
    local function HandleAura(aura)
        local type = ProcessAura(aura, unit, auraData.type);

        if type == AuraUpdateChangedType.Debuff then
            auraData.debuffs[aura.auraInstanceID] = aura;
        elseif type == AuraUpdateChangedType.Buff then
            auraData.buffs[aura.auraInstanceID] = aura;
        end
    end
    if auraData.bufffilter then
        ForEachAura(unit, auraData.bufffilter, batchCount, HandleAura, usePackedAura);
    end
    if auraData.debufffilter then
        ForEachAura(unit, auraData.debufffilter, batchCount, HandleAura, usePackedAura);
    end
end

function ns.UpdateAuras(unit)
    local reaction = UnitReaction("player", unit);
    if reaction and reaction <= 4 then
        if auraDatas[unit] == nil then
            auraDatas[unit] = {};
        end

        auraDatas[unit].bufffilter = CreateFilterString(AuraFilters.Helpful);
        auraDatas[unit].debufffilter = CreateFilterString(AuraFilters.Harmful, AuraFilters.IncludeNameplateOnly);
        auraDatas[unit].type = 1;
    elseif UnitIsPlayer(unit) then
        if auraDatas[unit] == nil then
            auraDatas[unit] = {};
        end

        auraDatas[unit].bufffilter = CreateFilterString(AuraFilters.Helpful, AuraFilters.Player,
            AuraFilters.IncludeNameplateOnly);
        auraDatas[unit].debufffilter = nil
        auraDatas[unit].type = 2;
    else
        return nil;
    end

    ParseAllAuras(unit);
    return auraDatas[unit];
end
