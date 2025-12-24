local _, ns = ...;
ns.spellid = nil;
local update_spell = function()

    if not ns.spellid  then
        return;
    end

    local count = C_Spell.GetSpellDisplayCount(ns.spellid);

    ns.combocountbar:SetValue(count);
    ns.combocountbar:Show();
    ns.combotext:SetText(count);
    ns.combotext:Show();

end

C_Timer.NewTicker(0.2, update_spell);