local _, ns = ...;
local AIH_SIZE = 30;
local AIH_X = 0;
local AIH_Y = 50;
local AIH_M_X = 50;
local AIH_M_Y = -20;
local AIH_CooldownFontSize = 9;
local mainframe = CreateFrame("Frame");

local interruptSpells = {};
local stunSpells = {};
local DangerousSpellList = {};


local function initPlayer()
    interruptSpells = {};
    stunSpells = {};

    for id, cooldown in pairs(ns.InterruptSpells) do
        if IsPlayerSpell(id) then
            id = C_Spell.GetOverrideSpell(id);
            interruptSpells[id] = cooldown;
        end
    end

    for id, cooldown in pairs(ns.StunSpells) do
        if IsPlayerSpell(id) then
            id = C_Spell.GetOverrideSpell(id);
            stunSpells[id] = cooldown;
        end
    end
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

local function showInterruptCooldown(spellID, isDangerous, endRemain)
    spellID = C_Spell.GetOverrideSpell(spellID);
    local spellInfo = C_Spell.GetSpellInfo(spellID);

    if not spellInfo then
        return;
    end

    local spellCooldownInfo = C_Spell.GetSpellCooldown(spellID);
    if not spellCooldownInfo then
        return;
    end

    local frame = mainframe.cooldownframe;

    if not (frame) then
        mainframe.cooldownframe = CreateFrame("Button", nil, mainframe, "AIHFrameTemplate");
        frame = mainframe.cooldownframe;
        frame:SetWidth(AIH_SIZE);
        frame:SetHeight(AIH_SIZE * 0.9);

        for _, r in next, { frame.cooldown:GetRegions() } do
            if r:GetObjectType() == "FontString" then
                r:SetFont(STANDARD_TEXT_FONT, AIH_CooldownFontSize, "OUTLINE")
                frame.cooldowntext = r;
                break
            end
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

local function hideInterruptCooldown()
    local frame = mainframe.cooldownframe;

    if frame then
        frame:Hide()
    end
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

        for id, cooldown in pairs(list) do
            if spellIntime(id, endRemain) then
                return id;
            end
        end
    else
        list = interruptSpells;

        for id, cooldown in pairs(list) do
            if spellIntime(id, endRemain) then
                return id;
            end
        end

        if not isBoss then
            for id, cooldown in pairs(stunSpells) do
                if spellIntime(id, endRemain) then
                    return id;
                end
            end
        end
    end

    for id, cooldown in pairs(list) do
        return id;
    end
end

local bmouseover = false;
local MaxLevel = GetMaxLevelForExpansionLevel(10);

local function AIH_OnUpdate()
    local unit = "focus"
    local mobspellID, notInterruptible, endRemain = UnitNeedtoInterrupt(unit)

    if mobspellID == nil then
        unit = "mouseover";
        mobspellID, notInterruptible, endRemain = UnitNeedtoInterrupt(unit);

        if mobspellID == nil then
            unit = "target"
            mobspellID, notInterruptible, endRemain = UnitNeedtoInterrupt(unit);
            bmouseover = false;
        else
            bmouseover = true;
        end
    else
        bmouseover = false;
    end

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
                showInterruptCooldown(spellID, isDangerous, endRemain)
            end
        end
    else
        hideInterruptCooldown()
    end

    if ns.options.AlwaysOnMouse then
        bmouseover = true;
    end
end


local function onUpdateMouse()
    local frame = mainframe.cooldownframe;

    if frame then
        frame:ClearAllPoints();
        if bmouseover then
            local x, y = GetCursorPosition() -- 마우스 좌표 가져오기
            frame:SetPoint("CENTER", UIParent, "BOTTOMLEFT", x + AIH_M_X, y + AIH_M_Y)
        else
            frame:SetPoint("CENTER", UIParent, "CENTER", AIH_X, AIH_Y);
        end
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

local bfirst = true

local function AIH_OnEvent(self)
    if bfirst then
        bfirst = false;
        ns.SetupOptionPanels();
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

    C_Timer.NewTicker(0.3, AIH_OnUpdate);
    C_Timer.NewTicker(0.05, onUpdateMouse);
end

initAddon();
