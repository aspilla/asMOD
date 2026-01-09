local _, ns = ...;
---설정부
local ACTA_UpdateRate = 0.1 -- Check할 주기
local ACTA_MaxShow = 3      -- 최대로 보여줄 개수
local ACTA_FontSize = 18;
local ACTA_X = 0;
local ACTA_Y = -80;
local CONFIG_VOICE_TARGETED = "Interface\\AddOns\\asCastingAlert\\Targeted.mp3"

local function isAttackable(unit)
    local reaction = UnitReaction("player", unit);
    if reaction and reaction <= 4 then
        return true;
    end
    return false;
end

local DangerousSpellList = {};
local showlist = {};
local CastingUnits = {};

local function CheckCasting(unit)
    if isAttackable(unit) and UnitIsUnit(unit .. "target", "player") and not (not ns.options.ShowTarget and UnitIsUnit(unit, "target")) then
        local name, _, texture, _, endTime, _, _, notInterruptible, spellid = UnitCastingInfo(unit);
        if not name then
            name, _, texture, _, endTime, _, notInterruptible, spellid = UnitChannelInfo(unit);
        end

        if name then
            local curr = GetTime();
            local remain = (endTime / 1000) - curr;

            if remain > 0 then
                local type = 2;

                if DangerousSpellList[spellid] then
                    type = 1;
                end

                tinsert(showlist, { type, remain, texture, spellid });

                return false;
            end
        end
    end

    return true;
end

local function Comparison(AIndex, BIndex)
    if AIndex[1] ~= BIndex[1] then
        return AIndex[1] < BIndex[1]
    elseif AIndex[2] ~= BIndex[2] then
        return AIndex[2] < BIndex[2]
    end
    return false;
end

local prevcount = 0;
local istank = false;

local function checkTank()
    local assignedRole = UnitGroupRolesAssigned("player");
    if assignedRole == "TANK" or assignedRole == "MAINTANK" then
        istank = true;
    else
        istank = false;
    end
end

local function ShowCasting()
    local currshow = 1;
    local soundcount = 0;

    table.sort(showlist, Comparison);
    for _, v in pairs(showlist) do
        local type = v[1];
        local remain = v[2];
        local texture = v[3];
        local spellid = v[4];

        ACTA.cast[currshow]:SetText("|T" .. texture .. ":0|t " .. format("%.1f", max(remain, 0)) .. " |T" .. texture ..
            ":0|t");

        ACTA.cast[currshow].castspellid = spellid;

        if type == 1 then
            ACTA.cast[currshow]:SetTextColor(1, 1, 0.5);

            if ns.options.PlaySoundDBMOnly then
                soundcount = soundcount + 1;
            end
        else
            ACTA.cast[currshow]:SetTextColor(1, 1, 1);
            if not ns.options.PlaySoundDBMOnly then
                soundcount = soundcount + 1;
            end
        end



        ACTA.cast[currshow]:Show();
        currshow = currshow + 1;

        if currshow > ACTA_MaxShow then
            break
        end
    end

    if not ns.options.PlaySoundTank and istank then
        soundcount = 0;
        prevcount  = 0;
    end

    if ns.options.PlaySoundGroupOnly and not IsInGroup() then
        soundcount = 0;
        prevcount = 0;
    end

    if prevcount ~= soundcount then
        if prevcount == 0 and ns.options.PlaySound then
            PlaySoundFile(CONFIG_VOICE_TARGETED, "MASTER");
        end

        prevcount = soundcount;
    end

    for i = currshow, ACTA_MaxShow do
        ACTA.cast[i]:Hide();
    end
end

local function ACTA_OnUpdate()
    showlist = {};

    if (MAX_BOSS_FRAMES) then
        for i = 1, MAX_BOSS_FRAMES do
            local unit = "boss" .. i;
            if UnitExists(unit) then
                CastingUnits[unit] = true;
            end
        end
    end

    for unit, _ in pairs(CastingUnits) do
        local notcasting = CheckCasting(unit);

        if notcasting then
            CastingUnits[unit] = nil;
        end
    end

    ShowCasting();
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
    C_Timer.After(2, scanDBM);
end

local bfirst = true;
local function ACTA_OnEvent(self, event, arg1, arg2, arg3, arg4)
    if bfirst then
        ns.setup_option();
        bfirst = false;
    end

    if (event == "ACTIVE_TALENT_GROUP_CHANGED" or event == "PLAYER_ENTERING_WORLD" or event == "ROLE_CHANGED_INFORM") then
        checkTank();
    else
        local unit = arg1;
        if unit and isAttackable(unit) and UnitAffectingCombat(unit) and string.find(unit, "nameplate") then
            local isboss = false;
            if (MAX_BOSS_FRAMES) then
                for i = 1, MAX_BOSS_FRAMES do
                    if UnitIsUnit(unit, "boss" .. i) then
                        isboss = true;
                        break;
                    end
                end
            end

            if not isboss then
                CastingUnits[unit] = true;
            end
        end
    end
end

local function initAddon()
    ACTA = CreateFrame("Frame", nil, UIParent);
    ACTA.cast = {};

    for i = 1, ACTA_MaxShow do
        ACTA.cast[i] = ACTA:CreateFontString(nil, "OVERLAY");
        ACTA.cast[i]:SetFont(STANDARD_TEXT_FONT, ACTA_FontSize, "THICKOUTLINE")

        if i == 1 then
            ACTA.cast[i]:SetPoint("CENTER", UIParent, "CENTER", ACTA_X, ACTA_Y);
        else
            ACTA.cast[i]:SetPoint("BOTTOM", ACTA.cast[i - 1], "TOP", 0, 3);
        end

        ACTA.cast[i]:EnableMouse(false);


        if not ACTA.cast[i]:GetScript("OnEnter") then
            ACTA.cast[i]:SetScript("OnEnter", function(s)
                if s.castspellid and s.castspellid > 0 then
                    GameTooltip_SetDefaultAnchor(GameTooltip, s);
                    GameTooltip:SetSpellByID(s.castspellid);
                end
            end)
            ACTA.cast[i]:SetScript("OnLeave", function()
                GameTooltip:Hide();
            end)
        end

        ACTA.cast[i]:EnableMouse(false);
        ACTA.cast[i]:SetMouseMotionEnabled(true);
        ACTA.cast[i]:Hide();
    end
    local bloaded = C_AddOns.LoadAddOn("asMOD");

    if bloaded and ASMODOBJ.load_position then
        ASMODOBJ.load_position(ACTA.cast[1], "asCastingAlert");
    end


    ACTA:SetScript("OnEvent", ACTA_OnEvent);
    ACTA:RegisterEvent("UNIT_SPELLCAST_START");
    ACTA:RegisterEvent("UNIT_SPELLCAST_CHANNEL_START");
    ACTA:RegisterEvent("NAME_PLATE_UNIT_ADDED");
    ACTA:RegisterEvent("PLAYER_ENTERING_WORLD");
    ACTA:RegisterEvent("ACTIVE_TALENT_GROUP_CHANGED");
    ACTA:RegisterEvent("ROLE_CHANGED_INFORM");


    -- 주기적으로 Callback
    C_Timer.NewTicker(ACTA_UpdateRate, ACTA_OnUpdate);

    local bloaded = C_AddOns.LoadAddOn("DBM-Core");
    if bloaded then
        hooksecurefunc(DBM, "NewMod", NewMod)
    end
end
initAddon();
