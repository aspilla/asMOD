local _, ns     = ...;

ns.tbuttons     = {};
ns.ibuttons     = {};
ns.trinkets     = { 13, 14 };
ns.items        = { 241308, 241304, 5512 };
ns.racials      = { 26297, 265221, 357214, 20594, 58984, 202719, 20572, 20549, 274738, 59752, 256948, 312411, 7744, 255647, 287712, 312924, 68992, 69070, 291944, 1237885, 255654, 107079, 20589, 59542, 436344, 155145 };
ns.racial_spell = nil;
ns.isdemonstone = false;
local configs   = {
    size = 28,
    font_size = 12,
    t_xpoint = -125,
    t_ypoint = -140,
    i_xpoint = -298,
    i_ypoint = -140,
    combatalpha = 1,
    normalalpha = 0.5,
}



local main_frame = CreateFrame("Frame", nil, UIParent);

local function get_spellinfo(spellid)
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

local function set_cooldownframe(self, start, duration, enable)
    if enable then
        self:SetDrawEdge(nil);
        self:SetCooldown(start, duration, nil);
    else
        clear_cooldownframe(self);
    end
end

local coolcurve = C_CurveUtil.CreateCurve();
coolcurve:AddPoint(0.0, 0);
coolcurve:AddPoint(0.001, 1);
coolcurve:AddPoint(1.0, 1);

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
        if itemid then
            local _, _, _, _, _, _, _, _, _, icon = C_Item.GetItemInfo(itemid)
            local start, duration = C_Item.GetItemCooldown(itemid);
            local count = C_Item.GetItemCount(itemid, false, true, false, false);

            if istrinket then
                count = 0;
            end

            if isusable then
                local frame = buttons[i];
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
                i = i + 1;
            end
        end
    end

    if spellid then
        local or_spellid, _, _, icon = get_spellinfo(spellid);
        local isUsable, notEnoughMana = C_Spell.IsSpellUsable(or_spellid);
        local durationobj = C_Spell.GetSpellCooldownDuration(or_spellid);


        local frame = buttons[i];
        frame.icon:SetTexture(icon);
        frame.icon_desaturated:SetTexture(icon);
        if (isUsable) then
            frame.icon:SetVertexColor(1.0, 1.0, 1.0);
        elseif (notEnoughMana) then
            frame.icon:SetVertexColor(0.5, 0.5, 1.0);
        else
            frame.icon:SetVertexColor(0.4, 0.4, 0.4);
        end
        if durationobj then
            set_cooldownframe(frame.cooldown, durationobj:GetStartTime(), durationobj:GetTotalDuration(), true);
            frame.icon_desaturated:SetAlpha(durationobj:EvaluateRemainingPercent(coolcurve));
        else
            set_cooldownframe(frame.cooldown, 0, 0, false);
            frame.icon_desaturated:SetAlpha(1);
        end

        frame.count:Hide();
        frame:Show()
        i = i + 1;

        for j = i, #list + 1 do
            buttons[j]:Hide();
        end
    else
        for j = i, #list do
            buttons[j]:Hide();
        end
    end
end


local function create_buttons()
    local libasConfig = LibStub:GetLibrary("LibasConfig", true);

    local offset = 0;
    if ASMOD_asUnitFrame and ASMOD_asUnitFrame.is_simplemode then
        offset = 14;
    end

    for i = 1, #ns.trinkets + 1 do
        local frame = CreateFrame("Button", nil, main_frame, "asCooldownPulseFrameTemplate");
        frame.cooldown:SetHideCountdownNumbers(false);
        frame.cooldown:SetDrawSwipe(true);

        for _, r in next, { frame.cooldown:GetRegions() } do
            if r:GetObjectType() == "FontString" then
                r:SetFont(STANDARD_TEXT_FONT, configs.font_size, "OUTLINE");
                r:SetDrawLayer("OVERLAY");
                break
            end
        end

        frame.icon:SetTexCoord(.08, .92, .08, .92);
        frame.icon_desaturated:SetTexCoord(.08, .92, .08, .92);
        frame.icon_desaturated:SetDesaturated(true);
        frame.border:SetTexCoord(0.08, 0.08, 0.08, 0.92, 0.92, 0.08, 0.92, 0.92);
        frame.border:SetVertexColor(0, 0, 0);

        frame.count:SetFont(STANDARD_TEXT_FONT, configs.font_size, "OUTLINE")
        frame.count:ClearAllPoints();
        frame.count:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", -3, 3);

        if i == 1 then
            frame:SetPoint("TOPRIGHT", UIParent, "CENTER", configs.t_xpoint, configs.t_ypoint - offset)

            if libasConfig then
                libasConfig.load_position(frame, "asCooldownPulse(Trinkets)", ACDP_Positions_1);
            end
        else
            frame:SetPoint("RIGHT", ns.tbuttons[i - 1], "LEFT", -0.5, 0);
        end
        frame:SetWidth(configs.size);
        frame:SetHeight(configs.size * 0.9);
        frame:Hide();
        ns.tbuttons[i] = frame;
    end

    for i = 1, #ns.items do
        local frame = CreateFrame("Button", nil, main_frame, "asCooldownPulseFrameTemplate");
        frame.cooldown:SetHideCountdownNumbers(false);
        frame.cooldown:SetDrawSwipe(true);

        for _, r in next, { frame.cooldown:GetRegions() } do
            if r:GetObjectType() == "FontString" then
                r:SetFont(STANDARD_TEXT_FONT, configs.font_size, "OUTLINE");
                r:SetDrawLayer("OVERLAY");
                break
            end
        end

        frame.icon:SetTexCoord(.08, .92, .08, .92);
        frame.border:SetTexCoord(0.08, 0.08, 0.08, 0.92, 0.92, 0.08, 0.92, 0.92);
        frame.border:SetVertexColor(0, 0, 0);

        frame.count:SetFont(STANDARD_TEXT_FONT, configs.font_size - 1, "OUTLINE")
        frame.count:ClearAllPoints();
        frame.count:SetTextColor(0, 1, 0);
        frame.count:SetPoint("CENTER", frame, "BOTTOM", 0, 0);

        if i == 1 then
            frame:SetPoint("TOPRIGHT", UIParent, "CENTER", configs.i_xpoint, configs.i_ypoint - offset)
            if libasConfig then
                libasConfig.load_position(frame, "asCooldownPulse(Item)", ACDP_Positions_2);
            end
        else
            frame:SetPoint("LEFT", ns.ibuttons[i - 1], "RIGHT", -0.5, 0);
        end
        frame:SetWidth(configs.size);
        frame:SetHeight(configs.size * 0.9);
        frame:Hide();
        ns.ibuttons[i] = frame;
    end
end


local function on_update()
    update_buttons(ns.trinkets, ns.tbuttons, ns.racial_spell);
    update_buttons(ns.items, ns.ibuttons);
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
        if C_SpellBook.IsSpellKnown(386689, 0) then
            ns.isdemonstone = true;
        else
            ns.isdemonstone = false;
        end

        ns.racial_spell = nil;
        for _, spellid in pairs(ns.racials) do
            if C_SpellBook.IsSpellKnown(spellid) then
                ns.racial_spell = spellid;
                return;
            end
        end
    end
end

local function init()
    ns.setup_option();
    create_buttons();
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

main_frame:SetScript("OnEvent", on_event);
main_frame:EnableMouse(false);
main_frame:Show();
main_frame:SetSize(0, 0);

C_Timer.After(0.5, init);
