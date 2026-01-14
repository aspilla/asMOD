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
    kickvoice = "Interface\\AddOns\\asInterruptHelper\\Sound\\Target_Kick_En.mp3",
    stunvoice = "Interface\\AddOns\\asInterruptHelper\\Sound\\Target_Stun_En.mp3",
    focuskickvoice = "Interface\\AddOns\\asInterruptHelper\\Sound\\Focus_Kick_En.mp3",
    focusstunvoice = "Interface\\AddOns\\asInterruptHelper\\Sound\\Focus_Stun_En.mp3",
};

if GetLocale() == "koKR" then
    configs.kickvoice = "Interface\\AddOns\\asInterruptHelper\\Sound\\Target_Kick.mp3"
    configs.stunvoice = "Interface\\AddOns\\asInterruptHelper\\Sound\\Target_Stun.mp3"
    configs.focuskickvoice = "Interface\\AddOns\\asInterruptHelper\\Sound\\Focus_Kick.mp3"
    configs.focusstunvoice = "Interface\\AddOns\\asInterruptHelper\\Sound\\Focus_Stun.mp3"
end


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
            if casttype == nil then
                return nil, false;
            else
                return name, casttype == "uninterruptable";
            end
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

local function check_sound(frame, unit, notInterruptible)
    if frame.soundalerted == false and unit ~= "mouseover" then
        local isfocus = false;
        if unit == "focus" then
            if UnitIsUnit(unit, "target") then
                return;
            end
            isfocus = UnitIsUnit(unit, "focus") and unit ~= "target";
        end

        local soundfile = nil;

        if notInterruptible then
            if ns.options.PlaySoundStun then
                if isfocus then
                    soundfile = configs.focusstunvoice
                else
                    soundfile = configs.stunvoice;
                end
            end
        else
            if ns.options.PlaySoundKick then
                if isfocus then
                    soundfile = configs.focuskickvoice
                else
                    soundfile = configs.kickvoice;
                end
            end
        end

        if soundfile then
            frame.soundalerted = true;
            PlaySoundFile(soundfile, "MASTER");
        end
    end
end



local function check_casting(frame, unit)
    if not UnitExists(unit) then
        frame.soundalerted = false;
        frame:Hide();
        return;
    end

    local name, not_interruptible = check_needtointerrupt(unit)

    if name then
        local isBoss = false;
        local needtointerrupt = true;
        local level = UnitLevel(unit);

        if level < 0 or level > UnitLevel("player") then
            isBoss = true;
        end

        if not_interruptible then
            if isBoss then
                needtointerrupt = false;
            end
        end

        if needtointerrupt then
            local spellID = find_spell(not_interruptible, isBoss);

            if spellID then
                show_interruptspell(frame, spellID);
                check_sound(frame, unit, not_interruptible);
            end
        end
    else
        frame.soundalerted = false;
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
    frame.soundalerted = false;

    local function on_update()
        check_casting(frame, unit);
    end

    C_Timer.NewTicker(0.3, on_update);

    return frame;
end

local function on_event(self, event)
    if event == "PLAYER_TARGET_CHANGED" then
        main_frame.targetframe.soundalerted = false;
    elseif event == "PLAYER_FOCUS_CHANGED" then
        main_frame.focusframe.soundalerted = false;
    else
        init_player();
    end
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
    main_frame:RegisterEvent("PLAYER_TARGET_CHANGED");
    main_frame:RegisterEvent("PLAYER_FOCUS_CHANGED");

    init_player();
end

C_Timer.After(0.5, init);
