local _, ns     = ...;

ns.tbuttons     = {};
ns.ibuttons     = {};
ns.sbuttons     = {};
ns.trinkets     = { 13, 14 };
ns.items        = { 241308, 241304, 5512 };
ns.racials      = { 26297, 265221, 357214, 20594, 58984, 202719, 20572, 20549, 274738, 59752, 256948, 312411, 7744, 255647, 287712, 312924, 68992, 69070, 291944, 1237885, 255654, 107079, 20589, 59542, 436344, 155145 };
ns.trackspells  = {};
ns.racial_spell = nil;
ns.isdemonstone = false;
local configs   = {
    size = 28,
    font_size = 12,
    t_xpoint = -124,
    t_ypoint = -165,
    i_xpoint = -326,
    i_ypoint = -165,
    s_xpoint = 124,
    s_ypoint = -217,
    combatalpha = 1,
    normalalpha = 0.5,
    maxtrackspells = 10,
}



local main_frame = CreateFrame("Frame", nil, UIParent);

function ns.get_spellinfo(spellid)
    if not spellid then
        return nil;
    end

    local or_spellid = C_Spell.GetOverrideSpell(spellid)

    if or_spellid then
        spellid = or_spellid;
    end

    local spellInfo = C_Spell.GetSpellInfo(spellid);
    if spellInfo then
        return spellid, spellInfo.name, nil, spellInfo.iconID, spellInfo.castTime, spellInfo.minRange, spellInfo
            .maxRange,
            spellInfo.spellID, spellInfo.originalIconID;
    end
end

local function clear_cooldownframe(self)
    self:Clear();
end

local function set_cooldownframe(self, start, duration, enable, forceShowDrawEdge, modRate)
    if enable then
        self:SetDrawEdge(forceShowDrawEdge);
        self:SetCooldown(start, duration, modRate);
    else
        clear_cooldownframe(self);
    end
end

local coolcurve = C_CurveUtil.CreateCurve();
coolcurve:AddPoint(0.0, 0);
coolcurve:AddPoint(1.5, 0);
coolcurve:AddPoint(1.6, 1);

local function update_spellbutton(frame, spellid)
    local or_spellid, _, _, icon = ns.get_spellinfo(spellid);
    local isUsable, notEnoughMana = C_Spell.IsSpellUsable(or_spellid);
    local durationobj = C_Spell.GetSpellCooldownDuration(or_spellid);
    local count = C_Spell.GetSpellDisplayCount(or_spellid);
    local chargeinfo = C_Spell.GetSpellCharges(or_spellid);

    frame.icon:SetTexture(icon);
    frame.icon_desaturated:SetTexture(icon);
    if (isUsable) then
        frame.icon:SetVertexColor(1.0, 1.0, 1.0);
    elseif (notEnoughMana) then
        frame.icon:SetVertexColor(0.5, 0.5, 1.0);
    else
        frame.icon:SetVertexColor(0.4, 0.4, 0.4);
    end


    frame.count:SetText(count);
    frame.count:Show();

    if chargeinfo then
        frame.cooldown:Show();
        set_cooldownframe(frame.cooldown, chargeinfo.cooldownStartTime,
            chargeinfo.cooldownDuration, true, true);
        frame.icon_desaturated:SetAlpha(0);
    else
        if durationobj then
            set_cooldownframe(frame.cooldown, durationobj:GetStartTime(), durationobj:GetTotalDuration(), true);
            frame.icon_desaturated:SetAlpha(durationobj:EvaluateRemainingDuration(coolcurve));
        else
            set_cooldownframe(frame.cooldown, 0, 0, false);
            frame.icon_desaturated:SetAlpha(1);
        end
    end

    frame:Show()
end

local function update_itembutton(frame, itemid, istrinket, ishealthstone)
    local _, _, _, _, _, _, _, _, _, icon = C_Item.GetItemInfo(itemid)
    local start, duration = C_Item.GetItemCooldown(itemid);
    local count = C_Item.GetItemCount(itemid, false, true, false, false);

    if istrinket then
        count = 0;
    end

    frame.icon:SetTexture(icon);
    frame.icon_desaturated:SetTexture(icon);
    set_cooldownframe(frame.cooldown, start, duration, true);
    if duration > 2 then
        frame.icon_desaturated:SetAlpha(1);
    else
        frame.icon_desaturated:SetAlpha(0);
    end
    if count > 0 then
        frame.count:SetText(count);
        frame.count:Show();
    else
        frame.count:Hide();
    end
    if ishealthstone then
        if count > 0 then
            frame:Show();
        else
            frame:Hide();
        end
    else
        frame:Show()
    end
end

local function update_buttons(list, buttons, spellid)
    local i = 1;

    for _, itemid in pairs(list) do
        local isusable = true;
        local istrinket = false;
        local ishealthstone = false;
        if itemid < 20 then
            itemid = GetInventoryItemID("player", itemid);
            if itemid then
                isusable = C_Item.IsUsableItem(itemid);
            end
            istrinket = true;
        elseif itemid == 5512 then
            if ns.isdemonstone then
                itemid = 224464;
            end
            ishealthstone = true;
        end

        if itemid and isusable then
            local frame = buttons[i];
            update_itembutton(frame, itemid, istrinket, ishealthstone);
            i = i + 1;
        end
    end

    if spellid then
        local frame = buttons[i];
        update_spellbutton(frame, spellid);
        i = i + 1;
    end

    for j = i, #buttons do
        buttons[j]:Hide();
    end
end

local function update_spells(buttons, list)
    local i = 1;

    for _, value in pairs(list) do
        local frame = buttons[i];
        local spellid = value[1];
        update_spellbutton(frame, spellid);
        i = i + 1;
    end

    for j = i, #buttons do
        buttons[j]:Hide();
    end
end

local function create_button(size)
    local fontsize = size / 2 - 2;
    local frame = CreateFrame("Button", nil, main_frame, "asCooldownPulseFrameTemplate");
    frame.cooldown:SetHideCountdownNumbers(false);
    frame.cooldown:SetDrawSwipe(true);

    for _, r in next, { frame.cooldown:GetRegions() } do
        if r:GetObjectType() == "FontString" then
            r:SetFont(STANDARD_TEXT_FONT, fontsize, "OUTLINE");
            r:SetDrawLayer("OVERLAY");
            break
        end
    end

    frame.icon:SetTexCoord(.08, .92, .08, .92);
    frame.icon_desaturated:SetTexCoord(.08, .92, .08, .92);
    frame.icon_desaturated:SetDesaturated(true);
    frame.border:SetTexCoord(0.08, 0.08, 0.08, 0.92, 0.92, 0.08, 0.92, 0.92);
    frame.border:SetVertexColor(0, 0, 0);

    frame.count:SetFont(STANDARD_TEXT_FONT, fontsize, "OUTLINE");
    frame.count:ClearAllPoints();
    frame.count:SetTextColor(0, 1, 0);
    frame.count:SetPoint("CENTER", frame, "BOTTOM", 0, 0);
    frame:SetWidth(size);
    frame:SetHeight(size * 0.9);
    frame:Hide();
    return frame;
end


local function create_buttons()
    local libasConfig = LibStub:GetLibrary("LibasConfig", true);

    local offset = 0;
    if ASMOD_asUnitFrame and ASMOD_asUnitFrame.is_simplemode then
        offset = 14;
    end

    for i = 1, #ns.trinkets + 1 do
        local frame = create_button(ns.options.TrinketSize);

        if i == 1 then
            frame:SetPoint("BOTTOMRIGHT", UIParent, "CENTER", configs.t_xpoint, configs.t_ypoint - offset)

            if libasConfig then
                libasConfig.load_position(frame, "asCooldownPulse(Trinkets)", ACDP_Positions_1);
            end
        else
            frame:SetPoint("RIGHT", ns.tbuttons[i - 1], "LEFT", -0.5, 0);
        end
        ns.tbuttons[i] = frame;
    end

    for i = 1, #ns.items do
        local frame = create_button(ns.options.ItemSize);

        if i == 1 then
            frame:SetPoint("BOTTOMLEFT", UIParent, "CENTER", configs.i_xpoint, configs.i_ypoint - offset)
            if libasConfig then
                libasConfig.load_position(frame, "asCooldownPulse(Item)", ACDP_Positions_2);
            end
        else
            frame:SetPoint("LEFT", ns.ibuttons[i - 1], "RIGHT", -0.5, 0);
        end
        ns.ibuttons[i] = frame;
    end

    for i = 1, configs.maxtrackspells do
        local frame = create_button(ns.options.SpellSize);
        if i == 1 then
            frame:SetPoint("TOPLEFT", UIParent, "CENTER", configs.s_xpoint, configs.s_ypoint)
            if libasConfig then
                libasConfig.load_position(frame, "asCooldownPulse(Spell)", ACDP_Positions_3);
            end
        else
            frame:SetPoint("LEFT", ns.sbuttons[i - 1], "RIGHT", -0.5, 0);
        end
        ns.sbuttons[i] = frame;
    end
end


local function on_update()
    if ns.options.ShowTrinkets then
        update_buttons(ns.trinkets, ns.tbuttons, ns.racial_spell);
    end

    if ns.options.ShowItems then
        update_buttons(ns.items, ns.ibuttons);
    end

    if ns.options.ShowSpells then
        update_spells(ns.sbuttons, ns.trackspells);
    end
end

function ns.scan_spells()
    if C_SpellBook.IsSpellKnown(386689, 0) then
        ns.isdemonstone = true;
    else
        ns.isdemonstone = false;
    end

    ns.racial_spell = nil;
    for _, spellid in pairs(ns.racials) do
        if C_SpellBook.IsSpellKnown(spellid) then
            ns.racial_spell = spellid;
            break;
        end
    end

    local i = 1;

    wipe(ns.trackspells);
    for spellid, priority in pairs(ns.show_list) do
        if C_SpellBook.IsSpellKnown(spellid) then
            table.insert(ns.trackspells, i, { spellid, priority });
            i = i + 1;

            if i > configs.maxtrackspells then
                break;
            end
        end
    end

    table.sort(ns.trackspells, function(a, b)
        return a[2] > b[2]
    end)
end

local function on_event(self, event)
    if event == "PLAYER_REGEN_DISABLED" then
        if ns.options.CombatAlphaChange then
            main_frame:SetAlpha(configs.combatalpha);
        end
    elseif event == "PLAYER_REGEN_ENABLED" then
        if ns.options.CombatAlphaChange then
            main_frame:SetAlpha(configs.normalalpha);
        end
    elseif event == "PLAYER_ENTERING_WORLD" then
        if ns.options.CombatAlphaChange then
            if UnitAffectingCombat("player") then
                main_frame:SetAlpha(configs.combatalpha);
            else
                main_frame:SetAlpha(configs.normalalpha);
            end
        end
    else
        ns.scan_spells();
    end
end

local function init()
    ns.setup_option();
    create_buttons();
    ns.scan_spells();
    C_Timer.NewTicker(0.2, on_update);

    if ns.options.CombatAlphaChange then
        if UnitAffectingCombat("player") then
            main_frame:SetAlpha(configs.combatalpha);
        else
            main_frame:SetAlpha(configs.normalalpha);
        end
    else
        main_frame:SetAlpha(configs.combatalpha);
    end
end

main_frame:RegisterEvent("TRAIT_CONFIG_UPDATED");
main_frame:RegisterEvent("TRAIT_CONFIG_LIST_UPDATED");
main_frame:RegisterEvent("ACTIVE_TALENT_GROUP_CHANGED");
main_frame:RegisterEvent("PLAYER_REGEN_DISABLED");
main_frame:RegisterEvent("PLAYER_REGEN_ENABLED");
main_frame:RegisterEvent("PLAYER_ENTERING_WORLD");
main_frame:RegisterUnitEvent("UNIT_PET", "player");

main_frame:SetScript("OnEvent", on_event);
main_frame:EnableMouse(false);
main_frame:Show();
main_frame:SetSize(0, 0);

C_Timer.After(0.5, init);
