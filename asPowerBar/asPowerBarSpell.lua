local _, ns = ...;
ns.spellid = nil;


local function check_spellcooldown(spellid)
    local chargeinfo = C_Spell.GetSpellCharges(spellid);
    local durationinfo = C_Spell.GetSpellChargeDuration(spellid);

    ns.setup_max_combo(chargeinfo.maxCharges, nil, true);
    ns.combocountbar:SetMinMaxValues(0, chargeinfo.maxCharges)
    ns.combocountbar:SetValue(chargeinfo.currentCharges);
    ns.combocountbar:Show();
    ns.combocountbar:SetStatusBarColor(ns.classcolor.r, ns.classcolor.g, ns.classcolor.b);

    ns.chargebar:SetTimerDuration(durationinfo, 0, 1);    
    ns.chargebar:SetReverseFill(true);
    ns.chargebar:Show();
end


local function update_spell()
    if not ns.spellid then
        return;
    end

    check_spellcooldown(ns.spellid);
end

C_Timer.NewTicker(0.2, update_spell);

local function on_event(self, event, arg1)
    if event == "SPELL_ACTIVATION_OVERLAY_GLOW_SHOW" then
        if arg1 == ns.spellid and ns.maxcombo then
            for i = 1, ns.maxcombo do
                ns.lib.PixelGlow_Start(ns.combobars[i]);
            end
        end
    elseif event == "SPELL_ACTIVATION_OVERLAY_GLOW_HIDE" then
        if arg1 == ns.spellid then
            for i = 1, ns.maxcombo and ns.maxcombo do
                ns.lib.PixelGlow_Stop(ns.combobars[i]);
            end
        end
    end
end


local main_frame = CreateFrame("Frame");
main_frame:RegisterEvent("SPELL_ACTIVATION_OVERLAY_GLOW_SHOW")
main_frame:RegisterEvent("SPELL_ACTIVATION_OVERLAY_GLOW_HIDE")
main_frame:SetScript("OnEvent", on_event);
