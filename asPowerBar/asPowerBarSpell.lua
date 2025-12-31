local _, ns = ...;

local gvalue = {
    spellid = nil,
    maxspell = 0,
};

local function setup_max_spell(max)
    if issecretvalue(max) then
        return;
    end

    if max == 0 and gvalue.maxspell == max then
        return;
    end

    gvalue.maxspell = max;

    local width = ((ns.config.width + 2) / max);
    local spellframes = ns.spellframes;

    ns.chargebar:SetWidth(width)

    for i = 1, 20 do
        spellframes[i]:Hide();
    end

    for i = 1, max do
        local spellframe = spellframes[i];
        spellframe:SetWidth(width);
        spellframe:Show();
    end
end


local function check_spellcooldown(spellid)
    local chargeinfo = C_Spell.GetSpellCharges(spellid);
    local durationinfo = C_Spell.GetSpellChargeDuration(spellid);

    setup_max_spell(chargeinfo.maxCharges);
    ns.combocountbar:SetMinMaxValues(0, chargeinfo.maxCharges)
    ns.combocountbar:SetValue(chargeinfo.currentCharges);
    ns.chargebar:SetTimerDuration(durationinfo, 0, 1);
end


local function update_spell()
    if not gvalue.spellid then
        return;
    end

    check_spellcooldown(gvalue.spellid);
end

local function on_event(self, event, arg1)
    if event == "SPELL_ACTIVATION_OVERLAY_GLOW_SHOW" then
        if arg1 == gvalue.spellid and gvalue.maxspell then
            for i = 1, gvalue.maxspell do
                ns.lib.PixelGlow_Start(ns.spellframes[i]);
            end
        end
    elseif event == "SPELL_ACTIVATION_OVERLAY_GLOW_HIDE" then
        if (arg1 == nil or arg1 == gvalue.spellid) and gvalue.maxspell then
            for i = 1, gvalue.maxspell do
                ns.lib.PixelGlow_Stop(ns.spellframes[i]);
            end
        end
    end
end


local main_frame = CreateFrame("Frame");
local timer = nil;

main_frame:SetScript("OnEvent", on_event);

function ns.setup_spell(spellid)
    main_frame:UnregisterEvent("SPELL_ACTIVATION_OVERLAY_GLOW_SHOW")
    main_frame:UnregisterEvent("SPELL_ACTIVATION_OVERLAY_GLOW_HIDE");

    if timer then
        timer:Cancel();
    end

    if spellid and ns.options.ShowClassResource then
        gvalue.spellid = spellid
        ns.combocountbar.bg:SetVertexColor(0.3, 0.3, 0.3, 1);
        ns.combocountbar:Show();
        ns.combocountbar:SetStatusBarColor(ns.classcolor.r, ns.classcolor.g, ns.classcolor.b);
        ns.chargebar:SetReverseFill(true);
        ns.chargebar:Show();

        main_frame:RegisterEvent("SPELL_ACTIVATION_OVERLAY_GLOW_SHOW");
        main_frame:RegisterEvent("SPELL_ACTIVATION_OVERLAY_GLOW_HIDE");
        timer = C_Timer.NewTicker(0.2, update_spell);
    end
end
