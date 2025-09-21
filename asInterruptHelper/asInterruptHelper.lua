local _, ns = ...;
local AIH_SIZE = 30;
local AIH_TARGET_SIZE = 25;
local AIH_X = 55;
local AIH_Y = -57;
local AIH_F_X = 0;
local AIH_F_Y = 67;
local AIH_M_X = 50;
local AIH_M_Y = -20;
local AIH_CooldownFontSize = 9;
local mainframe = CreateFrame("Frame");

local interruptSpells = {};
local stunSpells = {};
local DangerousSpellList = {};


local function initPlayer()
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

local function asCooldownFrame_Clear(self)
    self:Clear();
end

local function asCooldownFrame_Set(self, start, duration, enable, forceShowDrawEdge, modRate)
    if enable and enable ~= 0 and start > 0 and duration > 0 then
        self:SetDrawEdge(forceShowDrawEdge);
        self:SetCooldown(start, duration, modRate);
    else
        asCooldownFrame_Clear(self);
    end
end

local function showInterruptCooldown(frame, spellID, isDangerous, endRemain)
    spellID = C_Spell.GetOverrideSpell(spellID);
    local spellInfo = C_Spell.GetSpellInfo(spellID);

    if not spellInfo then
        return;
    end

    local spellCooldownInfo = C_Spell.GetSpellCooldown(spellID);
    if not spellCooldownInfo then
        return;
    end

    if not (frame) then
        return;
    end
    -- set the icon
    local frameIcon = frame.icon;
    frameIcon:SetTexture(spellInfo.iconID);
    frameIcon:SetAlpha(1);


    local frameBorder = frame.border;
    frameBorder:SetVertexColor(0, 0, 0);
    frameBorder:Show();

    -- set the count
    local frameCooldown = frame.cooldown;
    frameCooldown:Show();
    local remain = spellCooldownInfo.startTime + spellCooldownInfo.duration - GetTime();
    asCooldownFrame_Set(frameCooldown, spellCooldownInfo.startTime, spellCooldownInfo.duration,
        spellCooldownInfo.duration > 0, true);
    frameCooldown:SetHideCountdownNumbers(false);

    if remain <= endRemain then
        frame.cooldowntext:SetTextColor(1, 0.3, 0.3);
        frame.cooldowntext:SetFont(STANDARD_TEXT_FONT, AIH_CooldownFontSize + 3, "OUTLINE")
        frameIcon:SetDesaturated(false);
    else
        frame.cooldowntext:SetTextColor(0.8, 0.8, 1);
        frame.cooldowntext:SetFont(STANDARD_TEXT_FONT, AIH_CooldownFontSize, "OUTLINE")
        frameIcon:SetDesaturated(true);
    end

    if isDangerous then
        ns.lib.PixelGlow_Start(frame);
    else
        ns.lib.PixelGlow_Stop(frame);
    end

    frame.spellID = spellID;
    frame:Show();
end


local function isAttackable(unit)
    local reaction = UnitReaction("player", unit);
    if reaction and reaction <= 4 then
        return true;
    end
    return false;
end

local function UnitNeedtoInterrupt(unit)
    if UnitExists(unit) and isAttackable(unit) then
        local name, text, texture, startTime, endTime, isTradeSkill, castID, notInterruptible, spellid = UnitCastingInfo(
            unit);
        if not name then
            name, text, texture, startTime, endTime, isTradeSkill, notInterruptible, spellid = UnitChannelInfo(unit);
        end

        if name then
            return spellid, notInterruptible, (endTime / 1000 - GetTime());
        end
    end

    return nil;
end


local function spellIntime(spellid, endRemain)
    local id = C_Spell.GetOverrideSpell(spellid);
    local spellCooldownInfo = C_Spell.GetSpellCooldown(id);
    if spellCooldownInfo then
        local remain = spellCooldownInfo.startTime + spellCooldownInfo.duration - GetTime();
        if remain < endRemain then
            return true;
        end
    end

    return false;
end

local function findInterruptSpell(notInterruptible, isDangerous, endRemain, isBoss)
    local list;

    if notInterruptible then
        list = stunSpells;

        for _, v in pairs(list) do
            if spellIntime(v.spellid, endRemain) then
                return v.spellid;
            end
        end
    else
        list = interruptSpells;

        for _, v in pairs(list) do
            if spellIntime(v.spellid, endRemain) then
                return v.spellid;
            end
        end

        if not isBoss then
            for _, v in pairs(stunSpells) do
                if spellIntime(v.spellid, endRemain) then
                    return v.spellid;
                end
            end
        end
    end

    for _, v in pairs(list) do
        return v.spellid;
    end
end


local MaxLevel = GetMaxLevelForExpansionLevel(10);

local function check_casting(frame, unit)
    if not UnitExists(unit) then
        frame:Hide();
        return;
    end

    local mobspellID, notInterruptible, endRemain = UnitNeedtoInterrupt(unit)

    if mobspellID and endRemain then
        local isDangerous = ("interrupt" == DangerousSpellList[mobspellID]);
        local isBoss = false;
        local needtointerrupt = true;
        local level = UnitLevel(unit);

        if level < 0 or level > MaxLevel then
            isBoss = true;
        end

        if notInterruptible then
            if isBoss then
                needtointerrupt = false;
            end
        end


        if needtointerrupt then
            local spellID = findInterruptSpell(notInterruptible, isDangerous, endRemain, isBoss);

            if spellID then
                showInterruptCooldown(frame, spellID, isDangerous, endRemain)
            end
        end
    else
        frame:Hide();
    end
end


local function onUpdateMouse()
    local frame = mainframe.mouseframe;
    if frame then
        frame:ClearAllPoints();
        local x, y = GetCursorPosition() -- 마우스 좌표 가져오기
        frame:SetPoint("CENTER", UIParent, "BOTTOMLEFT", x + AIH_M_X, y + AIH_M_Y)
    end
end


local DBMobj;
local function scanDBM()
    DangerousSpellList = {};
    if DBMobj.Mods then
        for i, mod in ipairs(DBMobj.Mods) do
            if mod.Options and mod.announces then
                for k, obj in pairs(mod.announces) do
                    if obj.spellId and obj.announceType and obj.option then
                        if (DangerousSpellList[obj.spellId] == nil or DangerousSpellList[obj.spellId] ~= "interrupt") and mod.Options[obj.option] then
                            DangerousSpellList[obj.spellId] = obj.announceType;
                        end
                    end
                end
            end

            if mod.Options and mod.specwarns then
                for k, obj in pairs(mod.specwarns) do
                    if obj.spellId and obj.announceType and obj.option then
                        if (DangerousSpellList[obj.spellId] == nil or DangerousSpellList[obj.spellId] ~= "interrupt") and mod.Options[obj.option] then
                            DangerousSpellList[obj.spellId] = obj.announceType;
                        end
                    end
                end
            end
        end
    end
end


local function NewMod(self, ...)
    DBMobj = self;
    C_Timer.After(0.1, scanDBM);
end

local function createbutton(unit)
    local size = AIH_SIZE;

    if unit == "target" then
        size = AIH_TARGET_SIZE;
    end

    local frame = CreateFrame("Button", nil, mainframe, "AIHFrameTemplate");
    frame:SetWidth(size);
    frame:SetHeight(size * 0.9);

    for _, r in next, { frame.cooldown:GetRegions() } do
        if r:GetObjectType() == "FontString" then
            r:SetFont(STANDARD_TEXT_FONT, AIH_CooldownFontSize, "OUTLINE")
            frame.cooldowntext = r;
            break
        end
    end
    if unit == "mouseover" then
        frame:SetFrameStrata("MEDIUM");
    end

    frame.icon:SetTexCoord(.08, .92, .08, .92);
    frame.border:SetTexCoord(0.08, 0.08, 0.08, 0.92, 0.92, 0.08, 0.92, 0.92);

    if not frame:GetScript("OnEnter") then
        frame:SetScript("OnEnter", function(s)
            if s.spellID and s.spellID > 0 then
                GameTooltip_SetDefaultAnchor(GameTooltip, s);
                GameTooltip:SetSpellByID(s.spellID);
            end
        end)
        frame:SetScript("OnLeave", function()
            GameTooltip:Hide();
        end)
    end
    frame:EnableMouse(false);
    frame:SetMouseMotionEnabled(true);
    frame:Hide();

    local function OnUpdate()
        check_casting(frame, unit);
    end


    C_Timer.NewTicker(0.3, OnUpdate);

    return frame;
end

local bfirst = true

local function AIH_OnEvent(self, event)
    if bfirst then
        bfirst = false;
        ns.SetupOptionPanels();

        if ns.options.ShowTarget then
            mainframe.targetframe = createbutton("target");
            mainframe.targetframe:SetPoint("CENTER", UIParent, "CENTER", AIH_X, AIH_Y);
            if asMOD_setupFrame then
                asMOD_setupFrame(mainframe.targetframe, "asInterruptHelper (Target)");
            end
        end

        if ns.options.ShowFocus then
            mainframe.focusframe = createbutton("focus");
            mainframe.focusframe:SetPoint("CENTER", UIParent, "CENTER", AIH_F_X, AIH_F_Y);
            if asMOD_setupFrame then
                asMOD_setupFrame(mainframe.focusframe, "asInterruptHelper (Focus)");
            end
        end


        if ns.options.ShowMouseOver then
            mainframe.mouseframe = createbutton("mouseover");
            C_Timer.NewTicker(0.05, onUpdateMouse);
        end
    end

    initPlayer();
end

local function initAddon()
    local bloaded = C_AddOns.LoadAddOn("DBM-Core");
    if bloaded then
        hooksecurefunc(DBM, "NewMod", NewMod)
    end


    mainframe:SetScript("OnEvent", AIH_OnEvent)
    mainframe:RegisterEvent("PLAYER_ENTERING_WORLD")
    mainframe:RegisterEvent("TRAIT_CONFIG_UPDATED")
    mainframe:RegisterEvent("TRAIT_CONFIG_LIST_UPDATED")
    mainframe:RegisterEvent("ACTIVE_TALENT_GROUP_CHANGED")
    mainframe:RegisterUnitEvent("UNIT_PET", "player")
end

initAddon();
