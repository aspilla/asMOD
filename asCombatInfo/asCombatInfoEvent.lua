local _, ns = ...;

local eventframe = CreateFrame("Frame", nil, UIParent)
eventframe:Hide();

local eventlib = {};
local aurafilter = {};
local eventfilter = {};
local actionfilter = {};
local totemfilter = {};
local timerfilter = {};
local bufftimerfilter = {};
local totemtimerfilter = {};
ns.eventhandler = {};
ns.aurafunctions = {};

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



local debufffilter = CreateFilterString(AuraFilters.Harmful, AuraFilters.Player);
local bufffilter = CreateFilterString(AuraFilters.Helpful);


local function ProcessAura(unit, aura)
    if aura == nil then
        return AuraUpdateChangedType.None;
    end
    if PLAYER_UNITS[aura.sourceUnit] and (aurafilter[unit][aura.name] or aurafilter[unit][aura.spellId]) then
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
        local type = ProcessAura(unit, aura);

        if type == AuraUpdateChangedType.Show then
            eventlib[unit].auralist[aura.auraInstanceID] = aura;
            ret = true;
        end
    end
    ForEachAura(unit, filter, batchCount, HandleAura, usePackedAura);

    return ret;
end

local function UpdateAuras(unit)
    local trigger = false;

    if unit == "target" then
        trigger = ACRB_ParseAllAuras(unit, debufffilter);
    else
        trigger = ACRB_ParseAllAuras(unit, bufffilter);

        -- call back
        for _, button in pairs(bufftimerfilter) do
            button:update();
        end
    end
end

local function UpdateTotem()
    local trigger = false;
    eventlib.totemlist = {};

    for slot = 1, MAX_TOTEMS do
        local haveTotem, name, start, duration, icon = GetTotemInfo(slot);

        if totemfilter[name] then
            tinsert(eventlib.totemlist, { name, start, duration, icon })
            trigger = true;
        end
    end

    -- call back
    for _, button in pairs(totemtimerfilter) do
        button:update();
    end
end



local function ABF_OnEvent(self, event, arg1, ...)
    if (event == "UNIT_AURA") then
        local unit = arg1;
        if unit and (unit == "player" or unit == "pet") then
            UpdateAuras(unit);
        end
    elseif (event == "PLAYER_TOTEM_UPDATE") then
        UpdateTotem();
    elseif (event == "PLAYER_TARGET_CHANGED") then
        UpdateAuras("target");
    elseif (event == "ACTIONBAR_UPDATE_COOLDOWN" or event == "ACTIONBAR_UPDATE_USABLE") then
        -- call back
        for _, button in pairs(actionfilter) do
            button:update();
        end
    elseif event == "SPELL_ACTIVATION_OVERLAY_GLOW_SHOW" then
        local spell = GetSpellInfo(arg1);
        if eventfilter[spell] then            
            local button = eventfilter[spell];
            button.alert = true;
            button:update();
        end
    elseif event == "SPELL_ACTIVATION_OVERLAY_GLOW_HIDE" then
        local spell = GetSpellInfo(arg1);
        if eventfilter[spell] then
            local button = eventfilter[spell];
            button.alert = false;
            button:update();
        end
    elseif event == "ACTION_RANGE_CHECK_UPDATE" then
        local action, inRange, checksRange = arg1, ...;

        if actionfilter[action] then
            local button = actionfilter[action];

            if (checksRange and not inRange) then
                button.inRange = false;
            else
                button.inRange = true
            end
            button:update();
        end
    elseif event == "PLAYER_ENTERING_WORLD" then

    end
end


local function OnUpdate()
    UpdateAuras("target");

    for _, button in pairs(timerfilter) do
        button:update();
    end
end

do
    eventframe:RegisterUnitEvent("UNIT_AURA", "player", "pet");
    eventframe:RegisterEvent("PLAYER_TARGET_CHANGED");
    eventframe:RegisterEvent("ACTIONBAR_UPDATE_COOLDOWN");
    eventframe:RegisterEvent("ACTIONBAR_UPDATE_USABLE");
    eventframe:RegisterEvent("SPELL_ACTIVATION_OVERLAY_GLOW_SHOW");
    eventframe:RegisterEvent("SPELL_ACTIVATION_OVERLAY_GLOW_HIDE");
    eventframe:RegisterEvent("ACTION_RANGE_CHECK_UPDATE");    
    eventframe:RegisterEvent("PLAYER_TOTEM_UPDATE");
    eventframe:RegisterEvent("PLAYER_ENTERING_WORLD");

    eventframe:SetScript("OnEvent", ABF_OnEvent)

    --주기적으로 Callback
    C_Timer.NewTicker(0.2, OnUpdate);
end

function ns.eventhandler.init()
    aurafilter["target"] = {};
    aurafilter["player"] = {};
    aurafilter["pet"] = {};
    eventfilter = {};
    actionfilter = {};
    totemfilter = {};
    timerfilter = {};
    bufftimerfilter = {};
    totemtimerfilter = {};
end

function ns.eventhandler.registerAura(unit, spell)
    if unit == nil then
        return;
    end
    if aurafilter[unit] == nil then
        aurafilter[unit] = {};
    end

    aurafilter[unit][spell] = true;
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

function ns.eventhandler.registerTotemTimer(spell, button)
    tinsert(totemtimerfilter, button);
end

function ns.eventhandler.registerTimer(button)
    tinsert(timerfilter, button);
end

function ns.eventhandler.registerBuffTimer(button)
    tinsert(bufftimerfilter, button);
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
                return;
            end

            return;
        end);

    return ret;
end

function ns.aurafunctions.checkTotem(spell)
    local totemlist = eventlib.totemlist;
    local ret = nil;

    if totemlist then
        for _, v in pairs(totemlist) do
            if v[1] == spell then
                ret = v;
            end
        end
    end

    return ret;
end
