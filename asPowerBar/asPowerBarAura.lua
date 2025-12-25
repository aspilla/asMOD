local _, ns = ...;


function ns.check_storm()
    local combo = 0;

    if C_Secrets.GetSpellAuraSecrecy(344179) == 0 then
        local aurastorm = C_UnitAuras.GetUnitAuraBySpellID("player", 344179);

        if aurastorm then
            combo = aurastorm.applications;
        end
    end

    if combo then
        ns.show_combo(combo);
    end
end

function ns.check_void()
    local stack = 0;

    if C_Secrets.GetSpellAuraSecrecy(1225789) == 0  then
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
