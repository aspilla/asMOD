local _, ns = ...;
-----------------설정 ------------------------
local AREADY_WIDTH = 100      -- 쿨 바의 넓이
local AREADY_HEIGHT = 14      -- 쿨 바의 높이
local AREADY_X = -500;        -- X 위치
local AREADY_Y = 150;         -- Y 위치
local AREADY_Font = "Fonts\\2002.TTF";
local AREADY_Max = 10;        -- 최대 표시 List 수
local AREADY_UpdateRate = 0.2 -- Refresh 시간 초

-- 파티일경우 Check할 Spell
-- Spell Name 와 쿨 Time을 초로 입력
local trackedPartySpellNames = {
    ["들이치기"] = 15, -- Pummel
    ["발차기"] = 15, -- Kick
    ["분열"] = 15, -- Disrupt
    ["손날 찌르기"] = 15, -- Spear Hand Strike
    ["정신 얼리기"] = 15, -- Mind Freeze
    ["재갈"] = 15, -- Muzzle
    ["반격의 사격"] = 24, -- Counter Shot
    ["진압"] = 20, -- Quell
    ["두개골 강타"] = 15, -- "Skull Bash
    ["침묵"] = 45, -- Silence
    ["비난"] = 15, -- Rebuke
    ["날카로운 바람"] = 12, -- Wind Shear
    ["마법 차단"] = 24, -- Counterspell
    ["태양 광선"] = 60, -- Solar Beam
    ["도끼 던지기"] = 30,
    ["주문 잠금"] = 24
};

local trackedCoolSpellNames = {
    WARRIOR_1 = {
        ["투신"] = { 90, 20 }
    },

    WARRIOR_2 = {
        ["무모한 희생"] = { 90, 12 }
    },

    WARRIOR_3 = {
        ["투신"] = { 120, 20 }
    },

    ROGUE_1 = {
        ["죽음표식"] = { 120, 16 }
    },

    ROGUE_2 = {

        ["아드레날린 촉진"] = { 180, 20 }
    },

    ROGUE_3 = {
        ["어둠의 칼날"] = { 120, 20 }
    },

    HUNTER_1 = {
        ["야생의 부름"] = { 120, 20 }
    },

    HUNTER_2 = {
        ["정조준"] = { 120, 18 }

    },

    HUNTER_3 = {
        ["협공"] = { 120, 20 }

    },

    MONK_1 = {
        ["흑우 니우짜오의 원령"] = { 180, 25 }
    },

    MONK_2 = {
        ["주학 츠지의 원령"] = { 60, 12 },
        ["옥룡 위론의 원령"] = { 60, 12 }
    },

    MONK_3 = {
        ["백호 쉬엔의 원령"] = { 120, 20 }
    },

    WARLOCK_1 = {
        ["암흑시선 소환"] = { 120, 30 }
    },

    WARLOCK_2 = {
        ["악마 폭군 소환"] = { 60, 15 }
    },

    WARLOCK_3 = {
        ["지옥불정령 소환"] = { 120, 30 }
    },

    PRIEST_1 = {
        ["마력 주입"] = { 120, 15 }
    },

    PRIEST_2 = {
        ["마력 주입"] = { 120, 15 }
    },

    PRIEST_3 = {
        ["마력 주입"] = { 120, 15 }
    },

    SHAMAN_1 = {
        ["불의 정령"] = { 150, 30 },
        ["폭풍의 정령"] = { 150, 30 }
    },

    SHAMAN_2 = {
        ["야수 정령"] = { 90, 15 }
    },

    SHAMAN_3 = {
        [114052] = { 180, 15 }
    },

    DRUID_1 = {
        [194223] = { 180, 20 },
        [102560] = { 180, 30 }

    },

    DRUID_2 = {
        [102543] = { 180, 30 },
        [106951] = { 180, 20 }

    },

    DRUID_3 = {
        [102558] = { 180, 30 }

    },

    DRUID_4 = {
        [33891] = { 180, 30 },
        ["영혼 소집"] = { 60, 3 }

    },

    MAGE_1 = {
        ["비전 쇄도"] = { 90, 18 }
    },

    MAGE_2 = {
        ["발화"] = { 120, 12 }
    },

    MAGE_3 = {
        ["얼음 핏줄"] = { 120, 30 }

    },

    DEATHKNIGHT_1 = {
        ["춤추는 룬 무기"] = { 120, 16 }

    },

    DEATHKNIGHT_2 = {
        ["얼음 기둥"] = { 60, 12 }
    },

    DEATHKNIGHT_3 = {
        ["부정의 습격"] = { 90, 20 }
    },

    EVOKER_1 = {
        ["용의 분노"] = { 120, 18 }
    },

    EVOKER_2 = {
        ["되돌리기"] = { 180, 5 }

    },

    EVOKER_3 = {

        ["영겁의 숨결"] = { 108, 11.5 }
    },

    PALADIN_1 = {
        [31884] = { 120, 20 },
        ["응징의 성전사"] = { 60, 12 }
    },

    PALADIN_2 = {
        [31884] = { 120, 25 },
        ["파수꾼"] = { 120, 25 }
    },

    PALADIN_3 = {
        [31884] = { 60, 20 }
    },

    DEMONHUNTER_1 = {
        [191427] = { 120, 20 }
    },

    DEMONHUNTER_2 = {
        ["탈태"] = { 120, 15 }
    }
}

-----------------설정 끝 ------------------------

local interruptcools = {};
local offensivecools = {};
local raidframes = {};
local partyframes = {};



local AREADY = CreateFrame("FRAME", nil, UIParent)
AREADY:SetPoint("BOTTOM", UIParent, "BOTTOM", 0, 0)
AREADY:SetWidth(0)
AREADY:SetHeight(0)
AREADY:Show();

AREADY.bar = {};

LoadAddOn("asMOD");

for idx = 1, AREADY_Max do
    AREADY.bar[idx] = CreateFrame("StatusBar", nil, UIParent)
    AREADY.bar[idx]:SetStatusBarTexture("Interface\\addons\\asReady\\UI-StatusBar.blp", "BORDER")
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
    AREADY.bar[idx].button.icon:SetTexCoord(.08, .92, .08, .92);
    AREADY.bar[idx].button.border:SetTexture("Interface\\Addons\\asReady\\border.tga");
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
    local name, _, icon = GetSpellInfo(spellid)
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

-- cooldown
local function asCooldownFrame_Clear(self)
    self:Clear();
end
-- cooldown
local function asCooldownFrame_Set(self, start, duration, enable, forceShowDrawEdge, modRate)
    if enable and enable ~= 0 and start > 0 and duration > 0 then
        self:SetDrawEdge(forceShowDrawEdge);
        self:SetCooldown(start, duration, modRate);
    else
        asCooldownFrame_Clear(self);
    end
end

local function GetUnitBuff(unit, buff)
    local ret = nil;
    local auraList = ns.ParseAllBuff(unit);

    auraList:Iterate(function(auraInstanceID, aura)
        if aura and (aura.name == buff or aura.spellId == buff) and aura.sourceUnit == unit then
            if aura.duration > 0 then
                ret = aura;
            elseif ret == nil then
                ret = aura;
            end
        end
    end);

    return ret;
end

local function UtilSetCooldown(offensivecool, unit, asframe)
    local spellid = offensivecool[2];
    local time = offensivecool[3];
    local cool = offensivecool[4];
    local buffcool = offensivecool[5];
    local buffFrame = asframe.asbuffFrame;
    local frame = asframe.frame;
    local name, _, icon = GetSpellInfo(spellid);

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
        local aura;
        if IsInRaid() then
            --if true then
            buffFrame:SetSize(x / 6 - 1, y / 3 - 1);
        else
            buffFrame:SetSize(y / 2 * 1.2, y / 2);
            aura = GetUnitBuff(unit, name);
        end

        if aura then
            buffcool = aura.duration;
            time = aura.expirationTime - aura.duration;
            buffFrame.icon:SetTexture(aura.icon);
        else
            buffFrame.icon:SetTexture(icon);
        end

        local currtime = GetTime();
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
        elseif currtime <= time + cool - 0.5 then
            local expirationTime = time + cool;

            local remain = math.ceil(expirationTime - currtime);
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
        buffFrame:Show();
    else
        buffFrame:Hide();
    end
end

local function AREADY_OnUpdate()
    local idx = 1;

    if IsInRaid() then
        hide_bar_icon(idx);

        if ns.options.ShowRaidCool then
            for name, raidframe in pairs(raidframes) do
                local unit = raidframe.frame.unit;
                if raidframe.needtocheck and unit and offensivecools[unit] and offensivecools[unit][1] and raidframe.frame:IsShown() then
                    UtilSetCooldown(offensivecools[unit], unit, raidframe);
                else
                    raidframe.asbuffFrame:Hide()
                end
            end
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

        hide_bar_icon(idx);

        if ns.options.ShowPartyCool then
            for i = 1, 5 do
                local unit;
                if i == 5 then
                    unit = "player"
                else
                    unit = "party" .. i;
                end
                if partyframes[unit] then
                    if offensivecools[unit] and offensivecools[unit][1] and partyframes[unit].frame:IsShown() then
                        UtilSetCooldown(offensivecools[unit], unit, partyframes[unit]);
                    elseif partyframes[unit] then
                        partyframes[unit].asbuffFrame:Hide()
                    end
                end
            end
        end
    end
end

local timer = nil;

local function layoutbuff(f, unit)
    f:EnableMouse(false);
    f.icon:SetTexCoord(.08, .92, .08, .92);
    f.border:SetTexture("Interface\\Addons\\asReady\\border.tga");
    f.border:SetTexCoord(0.08, 0.08, 0.08, 0.92, 0.92, 0.08, 0.92, 0.92);
    f.border:SetVertexColor(0, 0, 0);
    f.border:Show();

    f.cooldown:SetSwipeColor(0, 0, 0, 0.5);
    f.remain:SetPoint("CENTER", 0, 0);
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

local function scanUnitSpecID(unit)
    GameTooltip:SetUnit(unit);
    local tooltipdata = GameTooltip:GetTooltipData();

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

local function OnEvent(self, event, arg1, arg2, arg3)
    if arg1 and arg3 then
        local spellid = arg3;
        local unit = arg1;
        local time = GetTime();
        local name = GetSpellInfo(spellid);
        if self.coolspelllist then
            local coolspelllist = self.coolspelllist;

            if coolspelllist and coolspelllist[name] or coolspelllist[spellid] then
                local info = coolspelllist[name] or coolspelllist[spellid];
                local cool = info[1];
                local buffcool = info[2];
                offensivecools[unit] = { unit, spellid, time, cool, buffcool };
            end
        end

        if not IsInRaid() and (trackedPartySpellNames[name] or trackedPartySpellNames[spellid]) then
            local cool = trackedPartySpellNames[name] or trackedPartySpellNames[spellid];
            interruptcools[unit] = { unit, spellid, time, cool, 0 };
        end
    end
end

local function SetupPartyCool(frame, raidframe)
    if frame and not frame:IsForbidden() and frame:IsShown() and frame.GetName then
        local name = frame:GetName();

        if name and not (name == nil) and (string.find(name, "CompactPartyFrameMember") or string.find(name, "CompactRaidGroup") or string.find(name, "CompactRaidFrame")) then
            if not (frame.displayedUnit and UnitIsPlayer(frame.displayedUnit)) then
                return;
            end
            if not (frame.unit and UnitIsPlayer(frame.unit)) then
                return;
            end

            if raidframe == nil then
                if IsInRaid() then
                    if not raidframes[name] then
                        raidframes[name] = CreateFrame("FRAME", nil);
                        raidframes[name]:Hide();
                    end
                    raidframe = raidframes[name];
                else
                    if not partyframes[frame.unit] then
                        partyframes[frame.unit] = CreateFrame("FRAME", nil);
                        partyframes[frame.unit]:Hide();
                    end
                    raidframe = partyframes[frame.unit];
                end
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
                local newcoollist = trackedCoolSpellNames[englishClass .. "_" .. spec];
                local newlistname = GetUnitName(frame.unit) .. englishClass .. "_" .. spec;

                if raidframe.listname == nil or raidframe.listname ~= newlistname then
                    interruptcools = {};
                    offensivecools = {};
                    raidframe.listname = newlistname;
                end

                raidframe.coolspelllist = newcoollist;
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
                d:SetSize(y / 2 * 1.2, y / 2);
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
                raidframe:UnregisterEvent("UNIT_SPELLCAST_SUCCEEDED");
                raidframe:SetScript("OnEvent", nil);
                raidframe.needtocheck = false;
            else
                raidframe:RegisterUnitEvent("UNIT_SPELLCAST_SUCCEEDED", frame.unit);
                raidframe:SetScript("OnEvent", OnEvent);
                raidframe.needtocheck = true;
            end
        end
    end
end

local function checkallraid()
    for name, raidframe in pairs(raidframes) do
        if raidframe and raidframe.frame then
            SetupPartyCool(raidframe.frame, raidframe);
        end
    end
end

local bfirst = true;

local function AREADY_OnEvent(self, event, arg1, arg2, arg3)
    if bfirst then
        ns.SetupOptionPanels();
        bfirst = false;
    end

    if timer then
        timer:Cancel();
    end

    if IsInRaid() then
        if ns.options.ShowRaidCool then
            if event == "ENCOUNTER_END" then
                offensivecools = {};
            end

            checkallraid();
            timer = C_Timer.NewTicker(AREADY_UpdateRate, AREADY_OnUpdate);
        else
            interruptcools = {};
            offensivecools = {};
            AREADY_OnUpdate();
        end
    elseif IsInGroup() then
        if event == "ENCOUNTER_END" then
            return;
        end

        for k = 1, 5 do
            local frame = _G["CompactPartyFrameMember" .. k];
            if frame then
                SetupPartyCool(frame);
            end
        end

        timer = C_Timer.NewTicker(AREADY_UpdateRate, AREADY_OnUpdate);
    else
        interruptcools = {};
        offensivecools = {};
        AREADY_OnUpdate();
    end

    return;
end

local function checkraidframe(frame)
    if ns.options.ShowRaidCool and frame and not frame:IsForbidden() and frame.GetName then
        local name = frame:GetName();

        if name and not (name == nil) and
            (string.find(name, "CompactRaidGroup") or string.find(name, "CompactRaidFrame")) then
            if not (frame.unit and UnitIsPlayer(frame.unit)) then
                return
            end
            SetupPartyCool(frame);
        end
    end
end

AREADY:SetScript("OnEvent", AREADY_OnEvent)
AREADY:RegisterEvent("PLAYER_ENTERING_WORLD");
AREADY:RegisterEvent("GROUP_JOINED");
AREADY:RegisterEvent("GROUP_ROSTER_UPDATE");
AREADY:RegisterEvent("ACTIVE_TALENT_GROUP_CHANGED");
AREADY:RegisterEvent("PLAYER_SPECIALIZATION_CHANGED");
AREADY:RegisterEvent("ENCOUNTER_END");

hooksecurefunc("CompactUnitFrame_UpdateAll", checkraidframe);
