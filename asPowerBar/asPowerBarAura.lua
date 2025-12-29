local _, ns = ...;

ns.auraid = nil;


function ns.check_auracount()
    local combo = 0;

    if not ns.auraid then
        return;
    end

    if C_Secrets.GetSpellAuraSecrecy and C_Secrets.GetSpellAuraSecrecy(ns.auraid) == 0 then
        local aura = C_UnitAuras.GetUnitAuraBySpellID("player", ns.auraid);

        if aura then
            combo = aura.applications;
        end
    end

    if combo then
        ns.show_combo(combo);
    end
end

function ns.check_void()
    local stack = 0;

    if C_Secrets.GetSpellAuraSecrecy and C_Secrets.GetSpellAuraSecrecy(1225789) == 0  then
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
