local _, ns = ...;

local gvalue = {
    auraid = nil,
    check_func = nil,
};

local function check_auracount()
    local combo = 0;

    if not gvalue.auraid then
        return;
    end

    if C_Secrets.GetSpellAuraSecrecy and C_Secrets.GetSpellAuraSecrecy(gvalue.auraid) == 0 then
        local aura = C_UnitAuras.GetUnitAuraBySpellID("player", gvalue.auraid);

        if aura then
            combo = aura.applications;
        end
    end

    if combo then
        ns.show_combo(combo);
    end
end

local function check_void()
    local stack = 0;

    if C_Secrets.GetSpellAuraSecrecy and C_Secrets.GetSpellAuraSecrecy(1225789) == 0 then
        local auravoid = C_UnitAuras.GetUnitAuraBySpellID("player", 1225789);

        if auravoid then
            stack = auravoid.applications;
        end
    end

    if stack then
        --ns.combocountbar:SetMinMaxValues(0, 50)
        ns.combocountbar:SetValue(stack)
        ns.combotext:SetText(stack);
        ns.combocountbar:Show();
        ns.combotext:Show();
    end
end

local function on_event()
    if gvalue.check_func then
        gvalue.check_func();
    end
end

local main_frame = CreateFrame("Frame");
main_frame:SetScript("OnEvent", on_event);

function ns.setup_auracombo(auraid, maxcombo)
    gvalue.check_func = nil;
    main_frame:UnregisterEvent("UNIT_AURA");

    if auraid and maxcombo and ns.options.ShowCombo then
        ns.setup_max_combo(maxcombo);
        gvalue.check_func = check_auracount;
        gvalue.auraid = auraid;
        main_frame:RegisterUnitEvent("UNIT_AURA", "player");
        check_auracount();
    end
end
