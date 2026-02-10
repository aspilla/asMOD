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

    if C_SpellBook.IsSpellKnown(119898) then --warlock
        local id = C_Spell.GetOverrideSpell(119898);
        if ns.InterruptSpells[id] then
            table.insert(interruptSpells, { spellid = id, cooldown = ns.InterruptSpells[id] })
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

local coolcurve = C_CurveUtil.CreateCurve();
coolcurve:AddPoint(0.0, 0);
coolcurve:AddPoint(1.5, 0);
coolcurve:AddPoint(1.6, 1);

local function show_interruptspell(frame, spellid, alpha)
    spellid = C_Spell.GetOverrideSpell(spellid);
    local spellInfo = C_Spell.GetSpellInfo(spellid);

    if not spellInfo then
        return;
    end

    local durationobj = C_Spell.GetSpellCooldownDuration(spellid);
    if not durationobj then
        return;
    end

    if not (frame) then
        return;
    end

    local isUsable, notEnoughMana = C_Spell.IsSpellUsable(spellid);

    frame.icon:SetTexture(spellInfo.iconID);
    frame.icon_desaturated:SetTexture(spellInfo.iconID);

    if (isUsable) then
        frame.icon:SetVertexColor(1.0, 1.0, 1.0);
    elseif (notEnoughMana) then
        frame.icon:SetVertexColor(0.5, 0.5, 1.0);
    else
        frame.icon:SetVertexColor(0.4, 0.4, 0.4);
    end

    set_cooldownframe(frame.cooldown, durationobj:GetStartTime(), durationobj:GetTotalDuration(), true);
    frame.icon_desaturated:SetAlpha(durationobj:EvaluateRemainingDuration(coolcurve));

    frame:SetAlpha(alpha);
    frame:Show();
end

local function check_needtointerrupt(unit)
    if UnitExists(unit) and UnitCanAttack("player", unit) then
        local name, _, texture, starttime, endtime, _, _, notinterruptible, spellid = UnitCastingInfo(unit);
        if not name then
            name, _, texture, starttime, endtime, _, notinterruptible, spellid = UnitChannelInfo(unit);
        end

        if name then
            return name, nil, notinterruptible;
        end
    end

    return nil, nil;
end


local function find_spell(isboss)
    local interrupt_spellid = nil;
    local stun_spellid = nil;

    do
        for _, v in pairs(interruptSpells) do
            interrupt_spellid = v.spellid;
            break;
        end
    end

    if not isboss then
        for _, v in pairs(stunSpells) do
            stun_spellid = v.spellid;
            break;
        end
    end

    return interrupt_spellid, stun_spellid;
end

local function check_casting(frame, unit)
    if not UnitExists(unit) then
        frame:Hide();
        return;
    end

    local name, notinterruptible, realnotinterruptible = check_needtointerrupt(unit)

    if name then
        local isboss = false;

        local level = UnitLevel(unit);

        if level < 0 or level > UnitLevel("player") then
            isboss = true;
        end

        local interrupt_spellid, stun_spellid = find_spell(isboss);

        if interrupt_spellid then
            show_interruptspell(frame.ibutton, interrupt_spellid, 0);
        else
            frame.ibutton:Hide();
        end

        if stun_spellid then
            show_interruptspell(frame.sbutton, stun_spellid, 1);
        else
            frame.sbutton:Hide();
        end

        local alpha = C_CurveUtil.EvaluateColorValueFromBoolean(realnotinterruptible, 0, 1);
        frame.ibutton:SetAlpha(alpha);
        frame:Show();
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

local function register_unit(button, unit)
    button.unit = unit;
    button:RegisterUnitEvent("UNIT_SPELLCAST_INTERRUPTED", unit);
    button:RegisterUnitEvent("UNIT_SPELLCAST_DELAYED", unit);
    button:RegisterUnitEvent("UNIT_SPELLCAST_CHANNEL_START", unit);
    button:RegisterUnitEvent("UNIT_SPELLCAST_CHANNEL_UPDATE", unit);
    button:RegisterUnitEvent("UNIT_SPELLCAST_CHANNEL_STOP", unit);
    button:RegisterUnitEvent("UNIT_SPELLCAST_EMPOWER_START", unit);
    button:RegisterUnitEvent("UNIT_SPELLCAST_EMPOWER_UPDATE", unit);
    button:RegisterUnitEvent("UNIT_SPELLCAST_EMPOWER_STOP", unit);
    button:RegisterUnitEvent("UNIT_SPELLCAST_INTERRUPTIBLE", unit);
    button:RegisterUnitEvent("UNIT_SPELLCAST_NOT_INTERRUPTIBLE", unit);
    button:RegisterUnitEvent("UNIT_SPELLCAST_START", unit);
    button:RegisterUnitEvent("UNIT_SPELLCAST_STOP", unit);
    button:RegisterUnitEvent("UNIT_SPELLCAST_FAILED", unit);
    button:RegisterEvent("PLAYER_TARGET_CHANGED");
    button:RegisterEvent("PLAYER_FOCUS_CHANGED");
end

local function create_coolbutton(parent, size, level)
    local frame = CreateFrame("Button", nil, parent, "AIHFrameTemplate");
    frame:SetWidth(size);
    frame:SetHeight(size * 0.9);
    frame:SetPoint("CENTER", parent, "CENTER", 0, 0);
    frame:SetFrameLevel(level);
    frame:EnableMouse(false);

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
    frame.icon_desaturated:SetTexCoord(.08, .92, .08, .92);
    frame.icon_desaturated:SetDesaturated(true);
    frame.border:SetTexCoord(0.08, 0.08, 0.08, 0.92, 0.92, 0.08, 0.92, 0.92);
    frame.border:SetVertexColor(0, 0, 0);


    frame:Hide();
    return frame;
end

local function create_button(unit)
    local size = configs.size;

    if unit == "target" then
        size = configs.targetsize;
    end

    local frame = CreateFrame("Frame");
    frame:SetWidth(size);
    frame:SetHeight(size * 0.9);
    frame:EnableMouse(false);
    frame:Show();

    frame.sbutton = create_coolbutton(frame, size, 1000);
    frame.ibutton = create_coolbutton(frame, size, 2000);

    if unit == "target" then
        local function on_unit_event(_, event)
            check_casting(frame, unit);
        end

        register_unit(frame, unit);
        frame:SetScript("OnEvent", on_unit_event);
    elseif unit == "focus" then
        local function on_unit_event()
            check_casting(frame, unit);
        end

        register_unit(frame, unit);
        frame:SetScript("OnEvent", on_unit_event);
    else
        local function on_update()
            check_casting(frame, unit);
        end

        C_Timer.NewTicker(0.3, on_update);
    end

    return frame;
end

local function on_event()
    init_player();
end

local function init()
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

    main_frame:SetScript("OnEvent", on_event)
    main_frame:RegisterEvent("PLAYER_ENTERING_WORLD");
    main_frame:RegisterEvent("TRAIT_CONFIG_UPDATED");
    main_frame:RegisterEvent("TRAIT_CONFIG_LIST_UPDATED");
    main_frame:RegisterEvent("ACTIVE_TALENT_GROUP_CHANGED");
    main_frame:RegisterUnitEvent("UNIT_PET", "player");

    init_player();
end

C_Timer.After(0.5, init);
