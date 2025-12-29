local _, ns = ...;
ns.spellid = nil;
ns.maxspell = 0;

local function setup_max_spell(max)
    if issecretvalue(max) then
        return;
    end

    if max == 0 then
        return;
    end

    ns.maxspell = max;

    local width = ((ns.config.width + 2)  / max);
    local spellframes = ns.spellframes;

    ns.chargebar:SetWidth(width)

    for i = 1, 20 do
        spellframes[i]:Hide();
    end

    for i = 1, max do
        local spellframe = spellframes[i];
        spellframe:SetWidth(width)

        spellframe:Show();
    end
end


local function check_spellcooldown(spellid)
    local chargeinfo = C_Spell.GetSpellCharges(spellid);
    local durationinfo = C_Spell.GetSpellChargeDuration(spellid);

    setup_max_spell(chargeinfo.maxCharges);
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
        if arg1 == ns.spellid and ns.maxspell then
            for i = 1, ns.maxspell do
                ns.lib.PixelGlow_Start(ns.spellframes[i]);
            end
        end
    elseif event == "SPELL_ACTIVATION_OVERLAY_GLOW_HIDE" then
        if arg1 == ns.spellid and ns.maxspell then
            for i = 1, ns.maxspell do
                ns.lib.PixelGlow_Stop(ns.spellframes[i]);
            end
        end
    end
end


local main_frame = CreateFrame("Frame");
main_frame:RegisterEvent("SPELL_ACTIVATION_OVERLAY_GLOW_SHOW")
main_frame:RegisterEvent("SPELL_ACTIVATION_OVERLAY_GLOW_HIDE")
main_frame:SetScript("OnEvent", on_event);
