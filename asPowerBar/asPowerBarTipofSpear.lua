local _, ns = ...

local gvalue = {
    stack = 0,
    expiretime = nil,
    istwinfang = false,
    isprimalsurge = false,
};

local configs = {
    maxstack = 3,
    duration = 10,
    killcommandid = 259489,
    twinfangid = 1272139,
    takedownid = 1250646,
    primalsurgeid = 1272154,
};

local spenders = {
    [186270] = true,
    [1262293] = true,
    [1261193] = true,
    [1253859] = true,
    [259495] = true,
    [193265] = true,
    [1264949] = true,
    [1262343] = true,
    [265189] = true,
    [1251592] = true,
}


local function on_event(_, event, ...)
    local unit, _, spellid = ...
    if unit ~= "player" then return end
    if event ~= "UNIT_SPELLCAST_SUCCEEDED" then return end

    if spellid == configs.killcommandid then
        gvalue.stack = math.min(configs.maxstack, gvalue.stack + (gvalue.isprimalsurge and 2 or 1));
        gvalue.expiretime = GetTime() + configs.duration;
        ns.show_combo(gvalue.stack);
        return
    end
    
    if spellid == configs.takedownid and gvalue.istwinfang then
        gvalue.stack = math.min(configs.maxstack, gvalue.stack + 3);
        gvalue.expiretime = GetTime() + configs.duration;
        ns.show_combo(gvalue.stack);
        return
    end

    if spenders[spellid] then
        if gvalue.stack > 0 then
            gvalue.stack = gvalue.stack - 1;
            if gvalue.stack == 0 then
                gvalue.expiretime = nil;
            end
            ns.show_combo(gvalue.stack);
            return
        end
    end
end

local function on_update()
    -- Check if stacks have expired
    if gvalue.expiretime and GetTime() >= gvalue.expiretime then
        gvalue.stack = 0
        gvalue.expiretime = nil
    end

    ns.show_combo(gvalue.stack);
end

local timer = nil;
local main_frame = CreateFrame("Frame");
main_frame:SetScript("OnEvent", on_event);

function ns.setup_tipofspear(spellid)
    if spellid and C_SpellBook.IsSpellKnown(spellid) then
        ns.setup_max_combo(configs.maxstack);
        gvalue.istwinfang = C_SpellBook.IsSpellKnown(configs.twinfangid) or false;
        gvalue.isprimalsurge = C_SpellBook.IsSpellKnown(configs.primalsurgeid) or false
        main_frame:RegisterUnitEvent("UNIT_SPELLCAST_SUCCEEDED", "player")
        timer = C_Timer.NewTicker(0.2, on_update);
    end
end

function ns.clear_tipofspear()
    main_frame:UnregisterEvent("UNIT_SPELLCAST_SUCCEEDED");
    if timer then
        timer:Cancel();
    end
end
