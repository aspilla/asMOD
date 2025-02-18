﻿local _, ns = ...;
-----------------설정 ------------------------
local AREADY_WIDTH = 100      -- 쿨 바의 넓이
local AREADY_HEIGHT = 14      -- 쿨 바의 높이
local AREADY_X = -501;        -- X 위치
local AREADY_Y = 150;         -- Y 위치
local AREADY_Font = STANDARD_TEXT_FONT;
local AREADY_Max = 10;        -- 최대 표시 List 수
local AREADY_UpdateRate = 0.3 -- Refresh 시간 초
local AREADY_CDupdateRate = 2 -- Cooldown Check Rate 2초

-----------------설정 끝 ------------------------

local interruptcools = {};
local offensivecools = {};
local raidframes = {};
local partyframes = {};

local cachedoffensive = {};

local asGetSpellInfo = function(spellID)
    if not spellID then
        return nil;
    end

    local ospellID = C_Spell.GetOverrideSpell(spellID)

    if ospellID then
        spellID = ospellID;
    end

    local spellInfo = C_Spell.GetSpellInfo(spellID);
    if spellInfo then
        return spellInfo.name, nil, spellInfo.iconID, spellInfo.castTime, spellInfo.minRange, spellInfo.maxRange,
            spellInfo.spellID, spellInfo.originalIconID;
    end
end



local AREADY = CreateFrame("FRAME", nil, UIParent)
AREADY:SetPoint("BOTTOM", UIParent, "BOTTOM", 0, 0)
AREADY:SetWidth(0)
AREADY:SetHeight(0)
AREADY:Show();

AREADY.bar = {};

C_AddOns.LoadAddOn("asMOD");

for idx = 1, AREADY_Max do
    AREADY.bar[idx] = CreateFrame("StatusBar", nil, UIParent)
    AREADY.bar[idx]:SetStatusBarTexture("Interface\\addons\\asReady\\UI-StatusBar", "BORDER")
    AREADY.bar[idx]:GetStatusBarTexture():SetHorizTile(false)
    AREADY.bar[idx]:SetMinMaxValues(0, 100)
    AREADY.bar[idx]:SetValue(0)
    AREADY.bar[idx]:SetHeight(AREADY_HEIGHT)
    AREADY.bar[idx]:SetWidth(AREADY_WIDTH)

    AREADY.bar[idx].bg = AREADY.bar[idx]:CreateTexture(nil, "BACKGROUND")
    AREADY.bar[idx].bg:SetPoint("TOPLEFT", AREADY.bar[idx], "TOPLEFT", -1, 1)
    AREADY.bar[idx].bg:SetPoint("BOTTOMRIGHT", AREADY.bar[idx], "BOTTOMRIGHT", 1, -1)

    AREADY.bar[idx].bg:SetTexture("Interface\\Addons\\asReady\\border.tga")
    AREADY.bar[idx].bg:SetTexCoord(0.1, 0.1, 0.1, 0.1, 0.1, 0.1, 0.1, 0.1)
    AREADY.bar[idx].bg:SetVertexColor(0, 0, 0, 0.8);

    if idx == 1 then
        AREADY.bar[idx]:SetPoint("CENTER", UIParent, "CENTER", AREADY_X, AREADY_Y)
    else
        AREADY.bar[idx]:SetPoint("BOTTOMLEFT", AREADY.bar[idx - 1], "TOPLEFT", 0, 2)
    end

    AREADY.bar[idx].playname = AREADY.bar[idx]:CreateFontString(nil, "OVERLAY")
    AREADY.bar[idx].playname:SetFont(AREADY_Font, AREADY_HEIGHT - 2, "OUTLINE")
    AREADY.bar[idx].playname:SetPoint("LEFT", AREADY.bar[idx], "LEFT", 2, 0)
    AREADY.bar[idx].cooltime = AREADY.bar[idx]:CreateFontString(nil, "OVERLAY")
    AREADY.bar[idx].cooltime:SetFont(AREADY_Font, AREADY_HEIGHT - 3, "OUTLINE")
    AREADY.bar[idx].cooltime:SetPoint("RIGHT", AREADY.bar[idx], "RIGHT", -2, 0)

    AREADY.bar[idx].button = CreateFrame("Button", nil, AREADY.bar[idx], "AREADYFrameTemplate");
    AREADY.bar[idx].button:SetPoint("RIGHT", AREADY.bar[idx], "LEFT", -1, 0);
    AREADY.bar[idx].button:SetWidth((AREADY_HEIGHT + 1) * 1.2);
    AREADY.bar[idx].button:SetHeight(AREADY_HEIGHT + 1);
    AREADY.bar[idx].button:SetScale(1);
    AREADY.bar[idx].button:SetAlpha(1);
    AREADY.bar[idx].button:EnableMouse(false);
    AREADY.bar[idx].button.icon:SetTexCoord(.08, .92, .16, .84);
    AREADY.bar[idx].button.border:SetTexCoord(0.08, 0.08, 0.08, 0.92, 0.92, 0.08, 0.92, 0.92);
    AREADY.bar[idx].button.border:SetVertexColor(0, 0, 0);
    AREADY.bar[idx].button:Hide();
    AREADY.bar[idx]:Hide();

    if idx == 1 then
        if asMOD_setupFrame then
            asMOD_setupFrame(AREADY.bar[idx], "asReady");
        end
    end
end

local function create_bar_icon(idx, unit, spellid, time, cool)
    local name, _, icon = asGetSpellInfo(spellid)
    local _, englishClass = UnitClass(unit);
    local color = RAID_CLASS_COLORS[englishClass]
    local curtime = GetTime();
    local curcool;

    if not color then
        return;
    end

    if time > curtime then
        AREADY.bar[idx]:Hide();
        return;
    end

    local remain = curtime - time;

    if remain < cool then
        curcool = remain;
    else
        curcool = cool;
    end

    AREADY.bar[idx]:SetStatusBarColor(color.r, color.g, color.b);
    AREADY.bar[idx]:SetMinMaxValues(0, cool)
    AREADY.bar[idx]:SetValue(curcool)
    if icon then
        local frameIcon = AREADY.bar[idx].button.icon;
        frameIcon:SetTexture(icon);
        frameIcon:Show();
        AREADY.bar[idx].button:Show();
    end

    AREADY.bar[idx].playname:SetText(UnitName(unit));
    AREADY.bar[idx].playname:Show();

    if curcool == cool then
        AREADY.bar[idx].cooltime:SetText("ON");
        AREADY.bar[idx].cooltime:SetTextColor(0, 1, 0);
    else
        AREADY.bar[idx].cooltime:SetText(format("%.1f", cool - curcool));
        AREADY.bar[idx].cooltime:SetTextColor(1, 1, 1);
    end
    AREADY.bar[idx].cooltime:Show();
    AREADY.bar[idx]:Show();
end

local function hide_bar_icon(max)
    for i = max, AREADY_Max do
        if AREADY.bar and AREADY.bar[i] then
            AREADY.bar[i]:Hide();
            AREADY.bar[i].button:Hide();
        end
    end
end

local openRaidLib = LibStub:GetLibrary("LibOpenRaid-1.0", true);

local function UtilSetCooldown(offensivecool, unit, asframe)
    local spellid = offensivecool[2];
    local time = offensivecool[3];
    local cool = offensivecool[4];
    local buffcool = offensivecool[5];
    local realremain = offensivecool[6];
    local buffFrame = asframe.asbuffFrame;
    local frame = asframe.frame;
    local name, _, icon = asGetSpellInfo(spellid);

    local x, y = frame:GetSize();

    if not UnitExists(unit) then
        buffFrame:Hide();
        return;
    else
        local assignedRole = UnitGroupRolesAssigned(unit);

        if (IsInRaid() and assignedRole and assignedRole ~= "DAMAGER") then
            buffFrame:Hide();
            return;
        end
    end

    if name then
        local currtime = GetTime();

        if IsInRaid() then
            --if true then
            buffFrame:SetSize(x / 6 - 1, y / 3 - 1);
        else
            buffFrame:SetSize(y / 2 * 1.2, y / 2);
        end

        buffFrame.icon:SetTexture(icon);

        if currtime <= time + buffcool then
            local expirationTime = time + buffcool;
            local remain = math.ceil(expirationTime - currtime);
            buffFrame.cooldown:Hide();
            buffFrame.icon:SetDesaturated(false);
            buffFrame.icon:SetVertexColor(1, 1, 1);

            if remain > 0 and remain < 100 then
                buffFrame.remain:SetText(remain);
                buffFrame.remain:SetTextColor(1, 1, 1);
                buffFrame.remain:Show();
            else
                buffFrame.remain:Hide();
            end
        elseif time then
            local expirationTime = time + cool;
            local remain = math.ceil(expirationTime - currtime);

            if realremain and realremain < remain then
                remain = realremain;
            end

            if remain > 0 then
                buffFrame.cooldown:Hide();
                buffFrame.icon:SetDesaturated(true);
                buffFrame.icon:SetVertexColor(1, 1, 1);

                if remain > 0 and remain < 100 then
                    buffFrame.remain:SetText(remain);
                    if remain < 4 then
                        buffFrame.remain:SetTextColor(1, 0, 0);
                    else
                        buffFrame.remain:SetTextColor(0, 1, 0);
                    end
                    buffFrame.remain:Show();
                else
                    buffFrame.remain:Hide();
                end
            else
                buffFrame.icon:SetDesaturated(true);
                buffFrame.icon:SetVertexColor(0, 1, 0);
                buffFrame.remain:Hide();
                buffFrame.cooldown:Hide();
            end
        end
        buffFrame:Show();
    else
        buffFrame:Hide();
    end
end

local function showallframes(frames)
    for _, raidframe in pairs(frames) do
        local unit = raidframe.frame.unit;

        if raidframe.needtosetup then
            ns.SetupPartyCool(raidframe);
        end

        if raidframe.needtocheck and unit and offensivecools[unit] and offensivecools[unit][1] and raidframe.frame:IsShown() then
            UtilSetCooldown(offensivecools[unit], unit, raidframe);
        elseif raidframe.asbuffFrame then
            raidframe.asbuffFrame:Hide()
        end
    end
end

local function checkallframes(frames)
    local currtime = GetTime();
    for _, raidframe in pairs(frames) do
        local unit = raidframe.frame.unit;

        if raidframe.needtocheck and unit and offensivecools[unit] and offensivecools[unit][1] and raidframe.frame:IsShown() then
            local remain = nil;
            local spellid = offensivecools[unit][2];

            if UnitIsUnit(unit, "player") then
                local spellCooldownInfo = C_Spell.GetSpellCooldown(spellid);
                if spellCooldownInfo then
                    local expirationTime = spellCooldownInfo.startTime + spellCooldownInfo.duration;
                    remain = math.ceil(expirationTime - currtime);
                end
            elseif openRaidLib and openRaidLib.GetUnitCooldownInfo then
                local cooldowninfo = openRaidLib.GetUnitCooldownInfo(unit, spellid);

                if cooldowninfo then
                    local timeLeft = cooldowninfo[1];
                    if cooldowninfo[2] > 0 then
                        timeLeft = 0;
                    end
                    remain = math.ceil(timeLeft);
                end
            end

            offensivecools[unit][6] = remain;
        end
    end
end

local checkcoollist = {};

local function IsUnitInGroup(unit)
    return UnitInParty(unit) or UnitInRaid(unit) ~= nil
end

local isparty = not IsInRaid() and IsInGroup();

local function OnSpellEvent(unit, spellid)
    if unit and spellid then
        if UnitCanAttack("player", unit) then
            return;
        end

        local isinterruptspell = 0;

        if isparty then
            isinterruptspell = ns.trackedPartySpellNames[spellid] or 0;
            if not (isinterruptspell > 0 or cachedoffensive[spellid]) then
                return;
            end

            if isinterruptspell then
                if UnitIsUnit(unit, "pet") then
                    unit = "player";
                elseif string.match(unit, "partypet") then
                    unit = string.gsub(unit, "partypet", "party");
                end
            end
        else
            if not (cachedoffensive[spellid]) then
                return;
            end
        end

        if IsUnitInGroup(unit) then
            local time = GetTime();
            local coolspelllist = checkcoollist[unit];

            if coolspelllist then
                local info = coolspelllist[spellid];
                if info then
                    local cool = info[1];
                    local buffcool = info[2];
                    offensivecools[unit] = { unit, spellid, time, cool, buffcool, nil };
                end
            end

            if isparty then
                local cool = isinterruptspell;
                if cool > 0 then
                    interruptcools[unit] = { unit, spellid, time, cool, 0 };
                end
            end
        end
    end
end

local timer = nil;

local function layoutbuff(f, unit)
    f:EnableMouse(false);
    f.icon:SetTexCoord(.08, .92, .08, .92);
    f.border:SetTexCoord(0.08, 0.08, 0.08, 0.92, 0.92, 0.08, 0.92, 0.92);
    f.border:SetVertexColor(0, 0, 0);
    f.border:Show();

    f.cooldown:SetSwipeColor(0, 0, 0, 0.5);
    f.remain:ClearAllPoints();
    f.remain:SetPoint("CENTER", f, "CENTER", 0, 0);
end

local function layoutcooldown(f)
    for _, r in next, { f.cooldown:GetRegions() } do
        if r:GetObjectType() == "FontString" then
            r:SetFont(STANDARD_TEXT_FONT, 12, "OUTLINE")
            r:ClearAllPoints();
            r:SetPoint("CENTER", 0, 0);
            break
        end
    end

    f.cooldown:SetHideCountdownNumbers(false);
end

local function SpecIDfromSpecName(specname, unit)
    local localizedClass, englishClass, classID = UnitClass(unit);
    if classID then
        for i = 1, 4 do
            local name = select(2, GetSpecializationInfoForClassID(classID, i));
            if name and string.find(specname, name) then
                return i;
            end
        end
    end
    return nil;
end
local asTooltip = CreateFrame("GameTooltip", "asTooltip", nil, "GameTooltipTemplate")

local function scanUnitSpecID(unit)
    asTooltip:SetUnit(unit);
    local tooltipdata = asTooltip:GetTooltipData();

    if tooltipdata and tooltipdata.lines then
        for i = 1, #tooltipdata.lines do
            if tooltipdata.lines[i].leftText then
                local spec = SpecIDfromSpecName(tooltipdata.lines[i].leftText, unit);

                if spec ~= nil then
                    return spec;
                end
            end

            if tooltipdata.lines[i].rightText then
                local spec = SpecIDfromSpecName(tooltipdata.lines[i].rightText, unit);

                if spec ~= nil then
                    return spec;
                end
            end
        end
    end
end


local max_y = 0;

function ns.SetupPartyCool(raidframe)
    local frame = raidframe.frame;
    raidframe.needtosetup = false;
    if frame and not frame:IsForbidden() and frame:IsShown() then
        if not (frame.displayedUnit and UnitIsPlayer(frame.displayedUnit)) then
            return;
        end
        if not (frame.unit and UnitIsPlayer(frame.unit)) then
            return;
        end

        local useHorizontalGroups = EditModeManagerFrame:ShouldRaidFrameUseHorizontalRaidGroups(
            CompactPartyFrame.groupType);
        local x, y = frame:GetSize();
        raidframe.frame = frame;

        local localizedClass, englishClass, classID = UnitClass(frame.unit);
        local spec = scanUnitSpecID(frame.unit);

        if spec == nil or spec == 0 then
            spec = scanUnitSpecID(frame.unit);
        end

        if spec == nil or spec == 0 then
            spec = 1;
        end

        if englishClass then
            local newcoollist = ns.trackedCoolSpellNames[englishClass .. "_" .. spec];
            local newlistname = GetUnitName(frame.unit) .. englishClass .. "_" .. spec;

            if raidframe.listname == nil or raidframe.listname ~= newlistname then
                interruptcools[frame.unit] = {};
                offensivecools[frame.unit] = {};
                raidframe.listname = newlistname;
            end

            raidframe.coolspelllist = newcoollist;
            checkcoollist[frame.unit] = newcoollist;

            for id, _ in pairs(newcoollist) do
                cachedoffensive[id] = true;
            end
        end

        if not raidframe.asbuffFrame then
            local buffFrame = CreateFrame("Button", nil, frame, "AREADYFrameTemplate")
            layoutbuff(buffFrame, frame.unit);
            raidframe.asbuffFrame = buffFrame;
            buffFrame:Hide();
        end

        if IsInRaid() then
            --if true then
            local d = raidframe.asbuffFrame;
            d:SetSize(x / 6 - 1, y / 3 - 1);
            d.remain:SetFont(STANDARD_TEXT_FONT, 9, "OUTLINE");
            layoutcooldown(d);
            d:ClearAllPoints();
            d:SetPoint("TOPLEFT", frame, "TOPLEFT", 2, -2);
        else
            local d = raidframe.asbuffFrame;
            d:SetSize(y / 2 * 1.1, y / 2);
            d.remain:SetFont(STANDARD_TEXT_FONT, 12, "OUTLINE");
            layoutcooldown(d);
            d:ClearAllPoints();
            if useHorizontalGroups then
                d:SetPoint("TOP", frame, "BOTTOM", 0, -1);
            else
                d:SetPoint("RIGHT", frame, "LEFT", -1, 0);
            end
        end

        local assignedRole = UnitGroupRolesAssigned(frame.unit);

        if (IsInRaid() and assignedRole and assignedRole ~= "DAMAGER") then
            raidframe.needtocheck = false;
        else
            raidframe.needtocheck = true;
        end
    end
end

local function checkallraid(frames)
    for _, raidframe in pairs(frames) do
        ns.SetupPartyCool(raidframe);
    end
end

local frameBuffer = {};

local function hookfunc(frame)
    if frame and not frame:IsForbidden() and frame.GetName then
        local framename = frame:GetName();
        if framename then
            frameBuffer[framename] = frame;
        end
    end
end

local function setupframe(frame, framename)
    if frame and not frame:IsForbidden() and frame:IsShown() then
        local name = framename;

        if name and not (name == nil) then
            if not (frame.displayedUnit and UnitIsPlayer(frame.displayedUnit)) then
                return;
            end
            if not (frame.unit and UnitIsPlayer(frame.unit)) then
                return;
            end

            local raidframe;

            if string.find(name, "CompactRaidGroup") or string.find(name, "CompactRaidFrame") then
                if not ns.options.ShowRaidCool then
                    return;
                end

                local x, y = frame:GetSize();
                if y > max_y then
                    max_y = y;
                end

                if y <= max_y / 2 then
                    return;
                end
                if raidframes[name] == nil then
                    raidframes[name] = {};
                end
                raidframe = raidframes[name];
            elseif string.find(name, "CompactPartyFrameMember") then
                if partyframes[name] == nil then
                    partyframes[name] = {};
                end
                raidframe = partyframes[name];
            else
                return;
            end

            raidframe.frame = frame;
            raidframe.needtosetup = true;
        end
    end
end


local function AREADY_OnUpdate()
    for newname, newframe in pairs(frameBuffer) do
        setupframe(newframe, newname);
    end

    frameBuffer = {};

    local idx = 1;

    if IsInRaid() then
        hide_bar_icon(idx);

        if ns.options.ShowRaidCool then
            showallframes(raidframes);
        end
    else
        if ns.options.ShowPartyInterrupt then
            for i = 1, 5 do
                local unit;
                if i == 5 then
                    unit = "player"
                else
                    unit = "party" .. (5 - i);
                end
                if interruptcools[unit] then
                    local v = interruptcools[unit];

                    if (v[2]) then
                        local spellid = v[2];
                        local time = v[3];
                        local cool = v[4];
                        local prev_idx = v[5];

                        local currtime = GetTime();
                        if currtime <= time + cool + 1 or prev_idx ~= idx then
                            create_bar_icon(idx, unit, spellid, time, cool);
                            v[5] = idx;
                        end

                        idx = idx + 1;

                        if idx > AREADY_Max then
                            break
                        end
                    end
                end
            end
        end

        hide_bar_icon(idx);

        if ns.options.ShowPartyCool then
            showallframes(partyframes);
        end
    end
end

local function AREADY_OnUpdate2()
    local idx = 1;

    if IsInRaid() then
        if ns.options.ShowRaidCool then
            checkallframes(raidframes);
        end
    else
        if ns.options.ShowPartyCool then
            checkallframes(partyframes);
        end
    end
end



local bfirst = true;

local function AREADY_OnEvent(self, event, arg1, arg2, arg3)
    if event == "UNIT_SPELLCAST_SUCCEEDED" then
        OnSpellEvent(arg1, arg3);
    else
        if bfirst then
            ns.SetupOptionPanels();
            bfirst = false;
        end

        if timer then
            timer:Cancel();
        end

        if timer2 then
            timer2:Cancel();
        end

        AREADY:UnregisterEvent("UNIT_SPELLCAST_SUCCEEDED");

        isparty = not IsInRaid() and IsInGroup();

        if IsInRaid() then
            if ns.options.ShowRaidCool then
                if event == "ENCOUNTER_END" then
                    offensivecools = {};
                end
                checkallraid(raidframes);
                timer = C_Timer.NewTicker(AREADY_UpdateRate, AREADY_OnUpdate);
                timer2 = C_Timer.NewTicker(AREADY_CDupdateRate, AREADY_OnUpdate2);
                AREADY:RegisterEvent("UNIT_SPELLCAST_SUCCEEDED");
            else
                interruptcools = {};
                offensivecools = {};
                AREADY_OnUpdate();
            end
        elseif IsInGroup() then
            if not (event == "ENCOUNTER_END") then
                checkallraid(partyframes);
            end
            timer = C_Timer.NewTicker(AREADY_UpdateRate / 3, AREADY_OnUpdate);
            timer2 = C_Timer.NewTicker(AREADY_CDupdateRate, AREADY_OnUpdate2);
            AREADY:RegisterEvent("UNIT_SPELLCAST_SUCCEEDED");
        else
            interruptcools = {};
            offensivecools = {};
            cachedoffensive = {};
            AREADY_OnUpdate();
        end
    end

    return;
end

AREADY:SetScript("OnEvent", AREADY_OnEvent)
AREADY:RegisterEvent("PLAYER_ENTERING_WORLD");
AREADY:RegisterEvent("GROUP_JOINED");
AREADY:RegisterEvent("GROUP_ROSTER_UPDATE");
AREADY:RegisterEvent("ACTIVE_TALENT_GROUP_CHANGED");
AREADY:RegisterEvent("PLAYER_SPECIALIZATION_CHANGED");
AREADY:RegisterEvent("ENCOUNTER_END");


hooksecurefunc("DefaultCompactUnitFrameSetup", hookfunc);
