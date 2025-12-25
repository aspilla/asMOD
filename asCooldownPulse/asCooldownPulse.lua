local tbuttons = {};
local ibuttons = {};
local trinkets = { 13, 14 };
local items = { 5512, 241308, 241304 };
local racials = { 26297, 265221, 357214, 20594, 58984, 202719, 20572, 20549, 274738, 59752, 256948, 312411, 7744, 255647, 287712, 312924, 68992, 69070, 291944, 1237885, 255654, 107079, 20589, 59542, 436344 };
local racial_spell = nil;
local configs = {
    size = 28,
    font_size = 12,
    t_xpoint = -125,
    t_ypoint = -140,
    i_xpoint = -298,
    i_ypoint = -140,
}

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
        return spellInfo.name, nil, spellInfo.iconID, spellInfo.castTime, spellInfo.minRange, spellInfo.maxRange,
            spellInfo.spellID, spellInfo.originalIconID;
    end
end

local function get_spellcooldown(spellid)
    if not spellid then
        return nil;
    end

    local or_spellid = C_Spell.GetOverrideSpell(spellid)

    if or_spellid then
        spellid = or_spellid;
    end

    local spellCooldownInfo = C_Spell.GetSpellCooldown(spellid);
    if spellCooldownInfo then
        return spellCooldownInfo.startTime, spellCooldownInfo.duration, spellCooldownInfo.isEnabled,
            spellCooldownInfo.modRate;
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


local isdemonstone = false;

local function updateitems(list, buttons, spellid)
    local i = 1;

    for _, itemid in pairs(list) do
        local isusable = true
        if itemid < 20 then
            itemid = GetInventoryItemID("player", itemid);
            if itemid then
                isusable = C_Item.IsUsableItem(itemid);
            end
        elseif itemid == 5512 and isdemonstone then
            itemid = 224464;
        end
        if itemid then
            local _, _, _, _, _, _, _, _, _, icon = C_Item.GetItemInfo(itemid)
            local start, duration = C_Item.GetItemCooldown(itemid);
            local count = 0;

            if isusable then
                local frame = buttons[i];
                frame.icon:SetTexture(icon);
                set_cooldownframe(frame.cooldown, start, duration, true);
                if duration > 10 then
                    frame.icon:SetDesaturated(true);
                else
                    frame.icon:SetDesaturated(false);
                end
                if count > 0 then
                    frame.count:SetText(count);
                    frame.count:Show();
                else
                    frame.count:Hide();
                end
                frame:Show()
                i = i + 1;
            end
        end
    end

    if spellid then
        local _, _, icon = get_spellinfo(spellid);
        local start, duration, enable = get_spellcooldown(spellid);
        local isUsable, notEnoughMana = C_Spell.IsSpellUsable(spellid);

        local frame = buttons[i];
        frame.icon:SetTexture(icon);
        set_cooldownframe(frame.cooldown, start, duration, true);
        if (isUsable) then
            frame.icon:SetVertexColor(1.0, 1.0, 1.0);
        elseif (notEnoughMana) then
            frame.icon:SetVertexColor(0.5, 0.5, 1.0);
        else
            frame.icon:SetVertexColor(0.4, 0.4, 0.4);
        end
        frame.count:Hide();
        frame:Show()
        i = i + 1;

        for j = i, #list + 1 do
            local frame = buttons[j];
            frame:Hide();
        end
    else
        for j = i, #list do
            local frame = buttons[j];
            frame:Hide();
        end
    end
end


local function createitembuttons()
    local bloaded = C_AddOns.LoadAddOn("asMOD")
    for i = 1, #trinkets + 1 do
        local frame = CreateFrame("Button", nil, UIParent, "asCooldownPulseFrameTemplate");
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

        frame.count:SetFont(STANDARD_TEXT_FONT, configs.font_size, "OUTLINE")
        frame.count:ClearAllPoints();
        frame.count:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", -3, 3);

        if i == 1 then
            frame:SetPoint("TOPRIGHT", UIParent, "CENTER", configs.t_xpoint, configs.t_ypoint)
            if bloaded and asMOD_setupFrame then
                asMOD_setupFrame(frame, "asCooldownPulse(Trinkets)");
            end
        else
            frame:SetPoint("RIGHT", tbuttons[i - 1], "LEFT", -0.5, 0);
        end
        frame:SetWidth(configs.size);
        frame:SetHeight(configs.size * 0.9);
        frame:SetScale(1);
        frame:Hide();
        tbuttons[i] = frame;
    end

    for i = 1, #items do
        local frame = CreateFrame("Button", nil, UIParent, "asCooldownPulseFrameTemplate");
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

        frame.count:SetFont(STANDARD_TEXT_FONT, configs.font_size, "OUTLINE")
        frame.count:ClearAllPoints();
        frame.count:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", -3, 3);

        if i == 1 then
            frame:SetPoint("TOPRIGHT", UIParent, "CENTER", configs.i_xpoint, configs.i_ypoint)
            if bloaded and asMOD_setupFrame then
                asMOD_setupFrame(frame, "asCooldownPulse(Item)");
            end
        else
            frame:SetPoint("LEFT", ibuttons[i - 1], "RIGHT", -0.5, 0);
        end
        frame:SetWidth(configs.size);
        frame:SetHeight(configs.size * 0.9);
        frame:SetScale(1);
        frame:Hide();
        ibuttons[i] = frame;
    end
end

createitembuttons();
local function update()
    updateitems(trinkets, tbuttons, racial_spell);
    updateitems(items, ibuttons);
end
C_Timer.NewTicker(0.2, update);

local function onevent()
    if C_SpellBook.IsSpellKnown(386689) then
        isdemonstone = true;
    else
        isdemonstone = false;
    end

    racial_spell = nil;
    for _, spellid in pairs(racials) do
        if C_SpellBook.IsSpellKnown(spellid) then
            racial_spell = spellid;
            return;
        end
    end
end


local frame = CreateFrame("Frame", nil);
frame:RegisterEvent("TRAIT_CONFIG_UPDATED");
frame:RegisterEvent("TRAIT_CONFIG_LIST_UPDATED");
frame:RegisterEvent("ACTIVE_TALENT_GROUP_CHANGED");

frame:SetScript("OnEvent", onevent)
