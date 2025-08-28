local _, ns = ...;

local eventframe = CreateFrame("Frame", nil, UIParent)
eventframe:Hide();

local eventlib = {};
local aurafilter = {};
local eventfilter = {};
local actionfilter = {};
local totemfilter = {};
local castfilter = {};
ns.eventhandler = {};
ns.aurafunctions = {};
local platedebuffcount = 0;
local platemaxcount = 0;

local PLAYER_UNITS = {
    player = true,
    vehicle = true,
    pet = true,
};


local AuraUpdateChangedType = EnumUtil.MakeEnum(
    "None",
    "Show"
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

local black_list = {
    [458525] = true, --승천
    [458524] = true, --승천
    [458503] = true, --승천
    [458502] = true, --승천
}

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

local function DefaultTomtemCompare(a, b)
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

local debufffilter = CreateFilterString(AuraFilters.Harmful, AuraFilters.Player);
local bufffilter = CreateFilterString(AuraFilters.Helpful, AuraFilters.IncludeNameplateOnly);

local function ProcessAura(unit, aura, searchinfo)
    if aura == nil then
        return AuraUpdateChangedType.None;
    end

    if black_list[aura.spellId] then
        return AuraUpdateChangedType.None;
    end

    if PLAYER_UNITS[aura.sourceUnit] and (searchinfo[aura.name] or searchinfo[aura.spellId]) then
        return AuraUpdateChangedType.Show;
    end

    return AuraUpdateChangedType.None;
end

local function ACRB_ParseAllAuras(unit, filter)
    local ret = false;

    if aurafilter[unit] == nil then
        return ret;
    end

    if eventlib[unit] == nil then
        eventlib[unit] = {};
        eventlib[unit].auralist = TableUtil.CreatePriorityTable(DefaultAuraCompare,
            TableUtil.Constants.AssociativePriorityTable);
    else
        eventlib[unit].auralist:Clear();
    end

    if not UnitExists(unit) then
        return ret;
    end


    local batchCount = nil;
    local usePackedAura = true;
    local function HandleAura(aura)
        local type = ProcessAura(unit, aura, aurafilter[unit]);

        if type == AuraUpdateChangedType.Show then
            eventlib[unit].auralist[aura.auraInstanceID] = aura;
            ret = true;
        end
    end
    ForEachAura(unit, filter, batchCount, HandleAura, usePackedAura);

    return ret;
end

local function ACRB_ParseAllNameplateAuras(filter)
    local ret = false;
    local unit = "nameplate"
    platedebuffcount = 0;
    local aurainfo = aurafilter[unit];

    if aurainfo == nil then
        return ret;
    end

    if eventlib[unit] == nil then
        eventlib[unit] = {};
        eventlib[unit].auralist = TableUtil.CreatePriorityTable(DefaultAuraCompare,
            TableUtil.Constants.AssociativePriorityTable);
    else
        eventlib[unit].auralist:Clear();
    end

    local function checkNameplate(nameplate)
        if nameplate then
            if not nameplate or nameplate:IsForbidden() then
                return false;
            end

            local nunit = nameplate.namePlateUnitToken;

            local reaction = UnitReaction("player", nunit);
            if reaction and reaction <= 4 then
                local batchCount = nil;
                local usePackedAura = true;
                local function HandleAura(aura)
                    if aurainfo[aura.name] or aurainfo[aura.spellId] then
                        eventlib[unit].auralist[aura.spellId] = aura;
                        platedebuffcount = platedebuffcount + 1;
                        if platedebuffcount >= platemaxcount then
                            ret = true;
                        end
                        return true;
                    end
                end
                ForEachAura(nunit, filter, batchCount, HandleAura, usePackedAura);
            end
        end
    end

    for _, v in pairs(C_NamePlate.GetNamePlates(issecure())) do
        local nameplate = v;
        if (nameplate) then
            checkNameplate(nameplate);
            if ret then
                return ret;
            end
        end
    end
    return ret;
end

local function UpdateAuras(unit, auraUpdateInfo)
    if unit == "nameplate" then
        ACRB_ParseAllNameplateAuras(debufffilter);
    else
        local filter = bufffilter;
        if unit == "target" then
            filter = debufffilter;
        end

        if auraUpdateInfo == nil or auraUpdateInfo.isFullUpdate or aurafilter[unit] == nil then
            ACRB_ParseAllAuras(unit, filter);
        else
            if auraUpdateInfo.addedAuras ~= nil then
                for _, aura in ipairs(auraUpdateInfo.addedAuras) do
                    if not C_UnitAuras.IsAuraFilteredOutByInstanceID(unit, aura.auraInstanceID, filter) then
                        local type = ProcessAura(unit, aura, aurafilter[unit]);
                        if type == AuraUpdateChangedType.Show then
                            eventlib[unit].auralist[aura.auraInstanceID] = aura;
                        end
                    end
                end
            end

            if auraUpdateInfo.updatedAuraInstanceIDs ~= nil then
                for _, auraInstanceID in ipairs(auraUpdateInfo.updatedAuraInstanceIDs) do
                    if eventlib[unit].auralist[auraInstanceID] ~= nil then
                        local newAura = C_UnitAuras.GetAuraDataByAuraInstanceID(unit, auraInstanceID);
                        eventlib[unit].auralist[auraInstanceID] = newAura;
                    end
                end
            end

            if auraUpdateInfo.removedAuraInstanceIDs ~= nil then
                for _, auraInstanceID in ipairs(auraUpdateInfo.removedAuraInstanceIDs) do
                    if eventlib[unit].auralist[auraInstanceID] ~= nil then
                        eventlib[unit].auralist[auraInstanceID] = nil;
                    end
                end
            end
        end
    end
end

local function UpdateTotem()
    local trigger = false;
    eventlib.totemlist = {};

    for slot = 1, MAX_TOTEMS do
        local haveTotem, name, start, duration, icon = GetTotemInfo(slot);
        --print (icon);
        --print (name);
        if haveTotem and (totemfilter[name] or totemfilter[icon]) then
            tinsert(eventlib.totemlist, { name, start, duration, icon })
            trigger = true;
        end
    end
end

local function ABF_OnEvent(self, event, arg1, ...)
    if (event == "UNIT_AURA") then
        local unit = arg1;
        local auraUpdateInfo = ...;
        UpdateAuras(unit, auraUpdateInfo);
    elseif (event == "UNIT_SPELLCAST_SUCCEEDED") then
        local arg2, spell = ...;

        if castfilter[spell] ~= nil then
            castfilter[spell] = GetTime();
        end
    elseif (event == "PLAYER_TOTEM_UPDATE") then
        UpdateTotem();
    elseif (event == "PLAYER_TARGET_CHANGED") then
        self:RegisterUnitEvent("UNIT_AURA", "player", "pet", "target");
        UpdateAuras("target");
    elseif event == "SPELL_ACTIVATION_OVERLAY_GLOW_SHOW" then
        local spell = asGetSpellInfo(arg1);

        for spellorg, button in pairs(eventfilter) do
            local spellnow = asGetSpellInfo(spellorg);
            if spell == spellnow or spell == spellorg then
                button.alert = true;
            end
        end
    elseif event == "SPELL_ACTIVATION_OVERLAY_GLOW_HIDE" then
        local spell = asGetSpellInfo(arg1);
        for spellorg, button in pairs(eventfilter) do
            local spellnow = asGetSpellInfo(spellorg);
            if spell == spellnow or spell == spellorg then
                button.alert = false;
            end
        end
    elseif event == "ACTION_RANGE_CHECK_UPDATE" then
        local action, inRange, checksRange = arg1, ...;

        if actionfilter[action] then
            local button = actionfilter[action];

            local type, id, subType = GetActionInfo(action);

            if id then
                if id == button.spellid then
                    if (checksRange and not inRange) then
                        button.inRange = false;
                    else
                        button.inRange = true
                    end
                end
            end
        end
    elseif event == "PLAYER_ENTERING_WORLD" then
        self:RegisterUnitEvent("UNIT_AURA", "player", "pet", "target");
        UpdateTotem();
        UpdateAuras("target");
        UpdateAuras("player");
        UpdateAuras("nameplate");
        UpdateAuras("pet");
    end
end


local function OnUpdate()
    UpdateAuras("target");
end

local function OnUpdate2()
    UpdateAuras("nameplate");
end

do
    eventframe:RegisterUnitEvent("UNIT_AURA", "player", "pet", "target");
    eventframe:RegisterEvent("PLAYER_TARGET_CHANGED");
    eventframe:RegisterEvent("SPELL_ACTIVATION_OVERLAY_GLOW_SHOW");
    eventframe:RegisterEvent("SPELL_ACTIVATION_OVERLAY_GLOW_HIDE");
    eventframe:RegisterEvent("ACTION_RANGE_CHECK_UPDATE");
    eventframe:RegisterEvent("PLAYER_TOTEM_UPDATE");
    eventframe:RegisterEvent("PLAYER_ENTERING_WORLD");

    eventframe:SetScript("OnEvent", ABF_OnEvent)

    --주기적으로 Callback
    -- C_Timer.NewTicker(0.2, OnUpdate);
    C_Timer.NewTicker(0.2, OnUpdate2);
end

function ns.eventhandler.init()
    aurafilter = {};
    eventfilter = {};
    actionfilter = {};
    totemfilter = {};
    castfilter = {};
end

function ns.eventhandler.registerAura(unit, spell, count)
    if unit == nil then
        return;
    end
    if aurafilter[unit] == nil then
        aurafilter[unit] = {};
    end

    aurafilter[unit][spell] = true;

    if unit == "nameplate" then
        if count then
            platemaxcount = count;
        else
            platemaxcount = 1;
        end
    end

    UpdateAuras(unit);
end

function ns.eventhandler.registerEventFilter(spell, button)
    eventfilter[spell] = button;
end

function ns.eventhandler.registerAction(action, button)
    if action then
        actionfilter[action] = button;
    end
end

function ns.eventhandler.registerTotem(spell)
    totemfilter[spell] = true;
end

function ns.eventhandler.registerCastTime(spell)
    eventframe:RegisterUnitEvent("UNIT_SPELLCAST_SUCCEEDED", "player", "pet");
    castfilter[spell] = 0;
end

function ns.eventhandler.getCastTime(spell)
    return castfilter[spell];
end

function ns.aurafunctions.checkAura(unit, spell)
    if eventlib[unit] == nil then
        return;
    end

    local auraList = eventlib[unit].auralist;
    local ret = nil;

    auraList:Iterate(
        function(auraInstanceID, aura)
            if aura.name == spell or aura.spellId == spell then
                ret = aura;
                return true;
            end

            return false;
        end);

    return ret;
end

function ns.aurafunctions.checkAuraList(unit, list)
    if eventlib[unit] == nil then
        return;
    end

    local auraids = {};

    for _, v in pairs(list) do
        auraids[v] = true;
    end

    local count = 0;

    local auraList = eventlib[unit].auralist;
    local ret = nil;

    auraList:Iterate(
        function(auraInstanceID, aura)
            if auraids[aura.spellId] then
                count = count + 1;
            end
            return false;
        end);

    return count;
end

function ns.aurafunctions.checkTotem(spell)
    local totemlist = eventlib.totemlist;
    local ret = nil;

    if totemlist then
        for _, v in pairs(totemlist) do
            if v[1] == spell or v[4] == spell then
                ret = v;
            end
        end
    end

    return ret;
end

function ns.aurafunctions.getPlateCount()
    return platedebuffcount;
end
