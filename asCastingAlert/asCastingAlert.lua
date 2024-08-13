---설정부
local ACTA_UpdateRate = 0.1 -- Check할 주기
local ACTA_MaxShow = 3      -- 최대로 보여줄 개수
local ACTA_FontSize = 18;
local ACTA_X = 0;
local ACTA_Y = -80;

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
    if isAttackable(unit) and UnitIsUnit(unit .. "target", "player") and not UnitIsUnit(unit, "target") then
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

local function ShowCasting()
    local currshow = 1;

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
            ACTA.cast[currshow]:SetTextColor(1, 0, 0);
        else
            ACTA.cast[currshow]:SetTextColor(1, 1, 1);
        end
        ACTA.cast[currshow]:Show();
        currshow = currshow + 1;

        if currshow > ACTA_MaxShow then
            break
        end
    end

    for i = currshow, ACTA_MaxShow do
        ACTA.cast[i]:Hide();
    end
end

local function ACTA_OnUpdate()
    showlist = {};
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
            if mod.announces then
                for k, obj in pairs(mod.announces) do
                    if obj.spellId and obj.announceType then
                        if DangerousSpellList[obj.spellId] == nil or DangerousSpellList[obj.spellId] ~= "interrupt" then
                            DangerousSpellList[obj.spellId] = obj.announceType;
                        end
                    end
                end
            end

            if mod.specwarns then
                for k, obj in pairs(mod.specwarns) do
                    if obj.spellId and obj.announceType then
                        if DangerousSpellList[obj.spellId] == nil or DangerousSpellList[obj.spellId] ~= "interrupt" then
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
    C_Timer.After(0.25, scanDBM);
end

local function ACTA_OnEvent(self, event, arg1, arg2, arg3, arg4)
    local unit = arg1;
    local spellid = arg3;

    if unit and spellid and isAttackable(unit) and string.find(unit, "nameplate") then
        CastingUnits[unit] = true;
    end
end

local function initAddon()
    ACTA = CreateFrame("Frame", nil, UIParent);
    ACTA.cast = {};

    for i = 1, ACTA_MaxShow do
        ACTA.cast[i] = ACTA:CreateFontString(nil, "OVERLAY");
        ACTA.cast[i]:SetFont("Fonts\\2002.TTF", ACTA_FontSize, "THICKOUTLINE")

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


    ACTA:SetScript("OnEvent", ACTA_OnEvent);
    ACTA:RegisterEvent("UNIT_SPELLCAST_START");
    ACTA:RegisterEvent("UNIT_SPELLCAST_CHANNEL_START");

    -- 주기적으로 Callback
    C_Timer.NewTicker(ACTA_UpdateRate, ACTA_OnUpdate);

    local bloaded = C_AddOns.LoadAddOn("DBM-Core");
    if bloaded then
        hooksecurefunc(DBM, "NewMod", NewMod)
    end
end
initAddon();
