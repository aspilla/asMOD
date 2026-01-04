local _, ns = ...;

local gvalue = {
    spellid = nil,
    actionslots = nil,
    maxspell = 0,
    inrange = true,
};

local function setup_max_spell(max)
    if issecretvalue(max) then
        return;
    end

    if max == 0 and gvalue.maxspell == max then
        return;
    end

    gvalue.maxspell = max;

    local width = ((ns.configs.width + 2) / max);
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

local function update_framerange(inrange, notenough)
    local spellframes = ns.spellframes;

    if inrange == false then
        for i = 1, gvalue.maxspell do
            local spellframe = spellframes[i];
            spellframe.range:Show();
            spellframe.notenough:Hide();
        end
    elseif notenough == true then
        for i = 1, gvalue.maxspell do
            local spellframe = spellframes[i];
            spellframe.range:Hide();
            spellframe.notenough:Show();
        end
    else
        for i = 1, gvalue.maxspell do
            local spellframe = spellframes[i];
            spellframe.range:Hide();
            spellframe.notenough:Hide();
        end
    end
end


local function check_spellcooldown(spellid)
    local chargeinfo = C_Spell.GetSpellCharges(spellid);
    local durationinfo = C_Spell.GetSpellChargeDuration(spellid);
    local _, notenough = C_Spell.IsSpellUsable(spellid);

    setup_max_spell(chargeinfo.maxCharges);
    ns.combocountbar:SetMinMaxValues(0, chargeinfo.maxCharges)
    ns.combocountbar:SetValue(chargeinfo.currentCharges);
    ns.chargebar:SetTimerDuration(durationinfo, 0, 1);
    update_framerange(gvalue.inrange, notenough);
end


local function update_spell()
    if not gvalue.spellid then
        return;
    end

    check_spellcooldown(gvalue.spellid);
end

local function get_actionslot(spellid)
    local ret = {};

    spellid = C_Spell.GetOverrideSpell(spellid)

    for slot = 1, 180 do
        local type, id, subType = GetActionInfo(slot);

        if id and type and type == "macro" then
            if id == spellid then
                ret[slot] = true;
            end
        end
    end

    for slot = 1, 180 do
        local type, id, subType = GetActionInfo(slot);

        if id and type and type == "spell" then
            if id == spellid then
                ret[slot] = true;
            end
        end
    end

    return ret;
end

local function on_event(self, event, arg1, arg2, arg3)
    if event == "ACTION_RANGE_CHECK_UPDATE" then
        local action, inrange, checkrange = arg1, arg2, arg3;

        if action and gvalue.actionslots[action] then
            if (checkrange and not inrange) then
                gvalue.inrange = false;
            else
                gvalue.inrange = true;
            end
        end
    elseif event == "SPELL_ACTIVATION_OVERLAY_GLOW_SHOW" then
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
    main_frame:UnregisterEvent("SPELL_ACTIVATION_OVERLAY_GLOW_SHOW");
    main_frame:UnregisterEvent("SPELL_ACTIVATION_OVERLAY_GLOW_HIDE");
    main_frame:UnregisterEvent("ACTION_RANGE_CHECK_UPDATE");

    if timer then
        timer:Cancel();
    end

    if spellid and ns.options.ShowClassResource then
        gvalue.spellid = spellid
        gvalue.actionslots = get_actionslot(spellid);
        gvalue.inrange = true;
        ns.combocountbar.bg:SetVertexColor(0.3, 0.3, 0.3, 1);
        ns.combocountbar:Show();
        ns.combocountbar:SetStatusBarColor(ns.classcolor.r, ns.classcolor.g, ns.classcolor.b);
        ns.chargebar:SetReverseFill(true);
        ns.chargebar:Show();

        main_frame:RegisterEvent("SPELL_ACTIVATION_OVERLAY_GLOW_SHOW");
        main_frame:RegisterEvent("SPELL_ACTIVATION_OVERLAY_GLOW_HIDE");
        main_frame:RegisterEvent("ACTION_RANGE_CHECK_UPDATE");

        timer = C_Timer.NewTicker(0.2, update_spell);
    end
end
