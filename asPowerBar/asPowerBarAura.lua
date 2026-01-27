local _, ns = ...;

local gvalue = {
    auraid = nil,
    check_func = nil,
};

local function check_auracount()
    if not gvalue.auraid then
        return;
    end

    local aura = C_UnitAuras.GetUnitAuraBySpellID("player", gvalue.auraid);
    local count = aura and aura.applications or 0
    ns.show_combo(count);
end

local function check_void()
    local aura = C_UnitAuras.GetPlayerAuraBySpellID(1225789) or C_UnitAuras.GetPlayerAuraBySpellID(1227702)
    local count = aura and aura.applications or 0
    local max = C_SpellBook.IsSpellKnown(1247534) and 35 or 50

    if count then
        ns.combocountbar:SetMinMaxValues(0, max)
        ns.combocountbar:SetValue(count)
        ns.combotext:SetText(count);
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
    ns.setup_whirlwind();
    ns.setup_tipofspear();

    if auraid and maxcombo and ns.options.ShowClassResource then
        if auraid == 1225789 then
            gvalue.check_func = check_void;
            main_frame:RegisterUnitEvent("UNIT_AURA", "player");
            ns.combocountbar:SetStatusBarColor(ns.classcolor.r, ns.classcolor.g, ns.classcolor.b);
            ns.combocountbar.bg:SetVertexColor(0, 0, 0, 1);
            check_void();
        elseif auraid == 12950 then
            ns.setup_whirlwind(auraid);
        elseif auraid == 260285 then
            ns.setup_tipofspear(auraid);
        else
            ns.setup_max_combo(maxcombo);
            gvalue.check_func = check_auracount;
            gvalue.auraid = auraid;
            main_frame:RegisterUnitEvent("UNIT_AURA", "player");
            check_auracount();
        end
    end
end
