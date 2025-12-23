local _, ns = ...;

function ns.update_stagger()
    local val = UnitStagger("player");
    local valmax = UnitHealthMax("player");

    ns.combocountbar:SetMinMaxValues(0, valmax)
    ns.combocountbar:SetValue(val)
    ns.combotext:SetText(val);
    ns.combocountbar:Show();
    ns.combotext:Show();
end

function ns.update_special()
    if ns.special_func then
        ns.special_func()
    end
end
