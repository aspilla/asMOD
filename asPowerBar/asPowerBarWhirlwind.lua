local _, ns      = ...

local gvalue     = {
    stack         = 0,
    expiretime    = nil,
    noconsumetime = 0,
    isunhinged    = false,
}
local castguids  = {}

local configs    = {
    maxstack   = 4,
    duration   = 20,
    unhingedid = 386628,
};

local generators = {
    [190411] = true,
    [6343]   = true,
    [435222] = true,
}

local spenders   = {
    [23881]  = true,
    [85288]  = true,
    [280735] = true,
    [202168] = true,
    [184367] = true,
    [335096] = true,
    [335097] = true,
    [5308]   = true,
}

local function is_spellidrange()
    return C_Item.IsItemInRange(63427, "target")
end

local function on_event(_, event, ...)
    local unit, castguid, spellid = ...
    if unit ~= "player" then return end
    if event ~= "UNIT_SPELLCAST_SUCCEEDED" then return end

    if castguid and castguids[castguid] then return end
    if castguid then castguids[castguid] = true end

    if gvalue.isunhinged and (
            spellid == 50622
            or spellid == 46924
            or spellid == 227847
            or spellid == 184362
            or spellid == 446035
        ) then
        gvalue.noconsumetime = GetTime() + 2
    end

    if generators[spellid] then
        local hasTarget = UnitExists("target") and UnitCanAttack("player", "target") and not UnitIsDead("target");
        if hasTarget and not is_spellidrange() then return end
        C_Timer.After(0.15, function()
            if UnitAffectingCombat("player") then
                gvalue.stack = configs.maxstack
                gvalue.expiretime = GetTime() + configs.duration
                ns.show_combo(gvalue.stack);
            end
        end)

        return
    end

    if spenders[spellid] then
        if (GetTime() < gvalue.noconsumetime) and (spellid == 23881) then return end
        if (gvalue.stack or 0) <= 0 then return end
        gvalue.stack = math.max(0, (gvalue.stack or 0) - 1)
        if gvalue.stack == 0 then gvalue.expiretime = nil end

        ns.show_combo(gvalue.stack);
    end
end

local function on_update()
    if gvalue.expiretime and GetTime() >= gvalue.expiretime then
        gvalue.stack = 0
        gvalue.expiretime = nil
    end

    ns.show_combo(gvalue.stack);
end

local timer = nil;
local main_frame = CreateFrame("Frame");
main_frame:SetScript("OnEvent", on_event);

function ns.setup_whirlwind(spellid)
    main_frame:UnregisterEvent("UNIT_SPELLCAST_SUCCEEDED");
    if timer then
        timer:Cancel();
    end

    if spellid and C_SpellBook.IsSpellKnown(spellid) then
        ns.setup_max_combo(configs.maxstack);
        gvalue.isunhinged = C_SpellBook.IsSpellKnown(configs.unhingedid) or false;
        main_frame:RegisterUnitEvent("UNIT_SPELLCAST_SUCCEEDED", "player")
        timer = C_Timer.NewTicker(0.2, on_update);
    end
end
