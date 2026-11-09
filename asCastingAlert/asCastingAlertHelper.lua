local _, ns = ...;
local configs = {
    maxshow = 10,
    size = 30,
    xpoint = 35,
    ypoint = -30,
    fontsize = 9,
    update_rate = 0.3,
};

ns.vanishspells = {
    [66] = 60,--Invisibility
    [1856] = 60, -- Vanish
    [5384] = 60, -- Feign Death
    [23920] = 60,  -- Spell Reflection
    [58984] = 120, --Shadowmeld
};

ns.helpers = {};

local main_frame = CreateFrame("Frame", nil, UIParent);
local vanishspells = {};

local function init_player()
    local function compare(a, b)
        if a.cooldown == b.cooldown then
            return a.spellid < b.spellid;
        end
        return a.cooldown < b.cooldown;
    end

    vanishspells = {};

    for id, cooldown in pairs(ns.vanishspells) do
        if C_SpellBook.IsSpellKnown(id) then
            id = C_Spell.GetOverrideSpell(id);
            table.insert(vanishspells, { spellid = id, cooldown = cooldown })
        end
    end

    table.sort(vanishspells, compare);
end

local function set_cooldownframe(cooldown, durationobject, enable)
    if enable and durationobject then
        cooldown:SetDrawEdge(nil);
        cooldown:SetCooldownFromDurationObject(durationobject);
    else
        cooldown:Clear();
    end
end

local coolcurve = C_CurveUtil.CreateCurve();
coolcurve:AddPoint(0.0, 0);
coolcurve:AddPoint(1.5, 0);
coolcurve:AddPoint(1.6, 1);

local function show_spell(frame, spellid)
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

    set_cooldownframe(frame.cooldown, durationobj, true);
    frame.icon_desaturated:SetAlpha(durationobj:EvaluateRemainingDuration(coolcurve));
end


local function find_spell()
    local vanish_spellid = nil;

    do
        local firstspellid = nil;
        for _, v in pairs(vanishspells) do
            local cd = C_Spell.GetSpellCooldown(v.spellid)
            local isUsable, notEnoughMana = C_Spell.IsSpellUsable(v.spellid);
            if firstspellid == nil then
                firstspellid = v.spellid;
            end
            if isUsable and cd then
                if not cd.isActive or cd.isOnGCD then
                    vanish_spellid = v.spellid;
                    break;
                end
            end
        end
        if vanish_spellid == nil then
            vanish_spellid = firstspellid;
        end
    end

    return vanish_spellid;
end

function ns.check_helper(frame)
    local vanishspellid = find_spell();

    if vanishspellid then
        show_spell(frame, vanishspellid);
        frame:Show();
    else
        frame:Hide();
    end
end

local function create_helper(parent, size, level)
    local frame = CreateFrame("Button", nil, parent, "asCAVanishTemplate");
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

    frame.icon:SetTexCoord(.08, .92, .08, .92);
    frame.icon_desaturated:SetTexCoord(.08, .92, .08, .92);
    frame.icon_desaturated:SetDesaturated(true);
    frame.border:SetTexCoord(0.08, 0.08, 0.08, 0.92, 0.92, 0.08, 0.92, 0.92);
    frame.border:SetVertexColor(0, 0, 0);


    frame:Hide();
    return frame;
end

local function on_event()
    C_Timer.After(0.5, init_player);
end

function ns.inithelper()
    local size = configs.size;
    local libasConfig = LibStub:GetLibrary("LibasConfig", true);

    main_frame:SetFrameStrata("LOW");
    main_frame:SetPoint("CENTER", UIParent, "CENTER", configs.xpoint, configs.ypoint);
    main_frame:SetAlpha(1);
    main_frame:SetSize(1, 1);
    main_frame:EnableMouse(false);
    main_frame:Show();

    if libasConfig then
        libasConfig.load_position(main_frame, "asCastingAlert(Vanish)", ACTA_Positions2);
    end
    if ns.options.ShowHelper then
        for i = 1, configs.maxshow do
            if not ns.helpers[i] then
                ns.helpers[i] =  create_helper(main_frame, size, 1000);
            end
        end
    end
    main_frame:SetScript("OnEvent", on_event)
    main_frame:RegisterEvent("PLAYER_ENTERING_WORLD");
    main_frame:RegisterEvent("TRAIT_CONFIG_UPDATED");
    main_frame:RegisterEvent("TRAIT_CONFIG_LIST_UPDATED");
    main_frame:RegisterEvent("ACTIVE_TALENT_GROUP_CHANGED");
    main_frame:RegisterUnitEvent("UNIT_PET", "player");

    init_player();
end
