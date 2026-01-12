local _, ns = ...;
local configs = {
    size = 30,
    targetsize = 25,
    xpoint = 55,
    ypoint = -57,
    focusxpoint = 0,
    focusypoint = 67,
    mousexpoint = 50,
    mouseypoint = -20,
    fontsize = 9,
};


local main_frame = CreateFrame("Frame");
local interruptSpells = {};
local stunSpells = {};

local function init_player()
    local function compare(a, b)
        if a.cooldown == b.cooldown then
            return a.spellid < b.spellid;
        end
        return a.cooldown < b.cooldown;
    end

    interruptSpells = {};
    stunSpells = {};

    for id, cooldown in pairs(ns.InterruptSpells) do
        if C_SpellBook.IsSpellKnown(id) then
            id = C_Spell.GetOverrideSpell(id);
            table.insert(interruptSpells, { spellid = id, cooldown = cooldown })
        end
    end
    table.sort(interruptSpells, compare);

    for id, cooldown in pairs(ns.StunSpells) do
        if C_SpellBook.IsSpellKnown(id) then
            id = C_Spell.GetOverrideSpell(id);
            table.insert(stunSpells, { spellid = id, cooldown = cooldown })
        end
    end

    table.sort(stunSpells, compare);
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


local function show_interruptspell(frame, spellid)
    spellid = C_Spell.GetOverrideSpell(spellid);
    local spellInfo = C_Spell.GetSpellInfo(spellid);

    if not spellInfo then
        return;
    end

    local spellCooldownInfo = C_Spell.GetSpellCooldown(spellid);
    if not spellCooldownInfo then
        return;
    end

    if not (frame) then
        return;
    end

    local isUsable, notEnoughMana = C_Spell.IsSpellUsable(spellid);

    frame.icon:SetTexture(spellInfo.iconID);

    if (isUsable) then
        frame.icon:SetVertexColor(1.0, 1.0, 1.0);
    elseif (notEnoughMana) then
        frame.icon:SetVertexColor(0.5, 0.5, 1.0);
    else
        frame.icon:SetVertexColor(0.4, 0.4, 0.4);
    end

    set_cooldownframe(frame.cooldown, spellCooldownInfo.startTime, spellCooldownInfo.duration, true);

    frame:Show();
end


local function is_attackable(unit)
    local reaction = UnitReaction("player", unit);
    if reaction and reaction <= 4 then
        return true;
    end
    return false;
end

local function get_typeofcast(unit)
    local nameplate = C_NamePlate.GetNamePlateForUnit(unit, issecure())
    if nameplate and nameplate.UnitFrame and nameplate.UnitFrame.castBar then
        return nameplate.UnitFrame.castBar.barType;
    end
    return nil;
end

local function check_needtointerrupt(unit)
    if UnitExists(unit) and is_attackable(unit) then
        local name = UnitCastingInfo(unit);
        if not name then
            name = UnitChannelInfo(unit);
        end

        if name then
            local casttype = get_typeofcast(unit);
            return name, casttype == "uninterruptable";
        end
    end

    return nil;
end


local function find_spell(notInterruptible, isBoss)
    local list;

    if notInterruptible then
        list = stunSpells;

        for _, v in pairs(list) do
            return v.spellid;
        end
    else
        list = interruptSpells;

        for _, v in pairs(list) do
            return v.spellid;
        end

        if not isBoss then
            for _, v in pairs(stunSpells) do
                return v.spellid;
            end
        end
    end
end


local function check_casting(frame, unit)
    if not UnitExists(unit) then
        frame:Hide();
        return;
    end

    local name, notInterruptible = check_needtointerrupt(unit)

    if name then
        local isBoss = false;
        local needtointerrupt = true;
        local level = UnitLevel(unit);

        if level < 0 or level > UnitLevel("player") then
            isBoss = true;
        end

        if notInterruptible then
            if isBoss then
                needtointerrupt = false;
            end
        end

        if needtointerrupt then
            local spellID = find_spell(notInterruptible, isBoss);

            if spellID then
                show_interruptspell(frame, spellID);
            end
        end
    else
        frame:Hide();
    end
end


local function on_mouseupdate()
    local frame = main_frame.mouseframe;
    if frame then
        frame:ClearAllPoints();
        local x, y = GetCursorPosition() -- 마우스 좌표 가져오기
        frame:SetPoint("CENTER", UIParent, "BOTTOMLEFT", x + configs.mousexpoint, y + configs.mouseypoint)
    end
end


local function create_button(unit)
    local size = configs.size;

    if unit == "target" then
        size = configs.targetsize;
    end

    local frame = CreateFrame("Button", nil, main_frame, "AIHFrameTemplate");
    frame:SetWidth(size);
    frame:SetHeight(size * 0.9);

    frame.cooldown:SetHideCountdownNumbers(false);
    for _, r in next, { frame.cooldown:GetRegions() } do
        if r:GetObjectType() == "FontString" then
            r:SetFont(STANDARD_TEXT_FONT, configs.fontsize, "OUTLINE")
            frame.cooldowntext = r;
            break
        end
    end
    if unit == "mouseover" then
        frame:SetFrameStrata("MEDIUM");
    end

    frame.icon:SetTexCoord(.08, .92, .08, .92);
    frame.border:SetTexCoord(0.08, 0.08, 0.08, 0.92, 0.92, 0.08, 0.92, 0.92);
    frame.border:SetVertexColor(0, 0, 0);

    frame:EnableMouse(false);
    frame:Hide();

    local function on_update()
        check_casting(frame, unit);
    end

    C_Timer.NewTicker(0.3, on_update);

    return frame;
end

local bfirst = true

local function on_event(self, event)
    if bfirst then
        bfirst = false;
        ns.setup_option();

        local libasConfig = LibStub:GetLibrary("LibasConfig", true);

        if ns.options.ShowTarget then
            main_frame.targetframe = create_button("target");
            main_frame.targetframe:SetPoint("CENTER", UIParent, "CENTER", configs.xpoint, configs.ypoint);
           
            if libasConfig then
                libasConfig.load_position(main_frame.targetframe, "asInterruptHelper (Target)", AIH_Positions_1);
            end
        end

        if ns.options.ShowFocus then
            main_frame.focusframe = create_button("focus");
            main_frame.focusframe:SetPoint("CENTER", UIParent, "CENTER", configs.focusxpoint, configs.focusypoint);

            if libasConfig then
                libasConfig.load_position(main_frame.focusframe, "asInterruptHelper (Focus)", AIH_Positions_2);
            end
        end


        if ns.options.ShowMouseOver then
            main_frame.mouseframe = create_button("mouseover");
            C_Timer.NewTicker(0.05, on_mouseupdate);
        end
    end

    init_player();
end

local function init()
    main_frame:SetScript("OnEvent", on_event)
    main_frame:RegisterEvent("PLAYER_ENTERING_WORLD")
    main_frame:RegisterEvent("TRAIT_CONFIG_UPDATED")
    main_frame:RegisterEvent("TRAIT_CONFIG_LIST_UPDATED")
    main_frame:RegisterEvent("ACTIVE_TALENT_GROUP_CHANGED")
    main_frame:RegisterUnitEvent("UNIT_PET", "player")
end

init();
