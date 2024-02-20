local _, ns = ...;

local ACRB_mainframe = CreateFrame("Frame", nil, UIParent);

ns.ACRB_ShowList = nil;
ns.asraid = {};
ns.asparty = {};
ns.lowhealth = 0;

local function asCheckTalent(name)
    local specID = PlayerUtil.GetCurrentSpecID();

    local configID = C_ClassTalents.GetActiveConfigID();

    if not (configID) then
        return false;
    end

    C_ClassTalents.LoadConfig(configID, true);
    local configInfo = C_Traits.GetConfigInfo(configID);
    local treeID = configInfo.treeIDs[1];

    local nodes = C_Traits.GetTreeNodes(treeID);

    for _, nodeID in ipairs(nodes) do
        local nodeInfo = C_Traits.GetNodeInfo(configID, nodeID);
        if nodeInfo.currentRank and nodeInfo.currentRank > 0 then
            local entryID = nodeInfo.activeEntry and nodeInfo.activeEntry.entryID and nodeInfo.activeEntry.entryID;
            local entryInfo = entryID and C_Traits.GetEntryInfo(configID, entryID);
            local definitionInfo = entryInfo and entryInfo.definitionID and
                C_Traits.GetDefinitionInfo(entryInfo.definitionID);

            if definitionInfo ~= nil then
                local talentName = TalentUtil.GetTalentName(definitionInfo.overrideName, definitionInfo.spellID);
                -- print(string.format("%s %d/%d", talentName, nodeInfo.currentRank, nodeInfo.maxRanks));
                if name == talentName then
                    return true;
                end
            end
        end
    end

    return false;
end

local function ACRB_InitList()
    local spec = GetSpecialization();
    local localizedClass, englishClass = UnitClass("player");
    local listname;

    ns.ACRB_ShowList = nil;

    if spec == nil or spec > 4 or (englishClass ~= "DRUID" and spec > 3) then
        spec = 1;
    end


    if spec then
        listname = "ACRB_ShowList_" .. englishClass .. "_" .. spec;
    end

    ns.ACRB_ShowList = ns[listname];

    if ns.ACRBShowList then
        for key, value in pairs(ns.ACRBShowList) do
            if tonumber(key) > 0 then
                local name = GetSpellInfo(key);
                if name then
                    ns.ACRBShowList[name] = value;
                end
            end
        end
    end

    ns.lowhealth = 0;

    if (englishClass == "PRIEST") then
        if asCheckTalent("신의 권능: 생명") then
            ns.lowhealth = 35;
        end
    end
end

local function ACRB_updatePartyAllHealerMana()
    if IsInRaid() then
        for _, asframe in pairs(ns.asraid) do
            if asframe and asframe.frame and asframe.frame:IsShown() then
                ns.ACRB_UpdateHealerMana(asframe);
                ns.ACRB_UpdateRaidIconAborbColor(asframe);
                asframe.ncasting = 0;
            end
        end
    else
        for _, asframe in pairs(ns.asparty) do
            if asframe and asframe.frame and asframe.frame:IsShown() then
                ns.ACRB_UpdateHealerMana(asframe);
                ns.ACRB_UpdateRaidIconAborbColor(asframe);
                asframe.ncasting = 0;
            end
        end
    end
end

function ns.isParty(unit)
    for i = 1, 4 do
        if unit and UnitIsUnit(unit, "party" .. i) then
            return true
        end
    end

    return false;
end

local max_y = 0;

-- Setup
local function ACRB_setupFrame(frame)
    if not frame or frame:IsForbidden() then
        return
    end

    local frameName = frame:GetName()

    local asframe;
    local x, y = frame:GetSize();

    if string.find(frameName, "CompactPartyFrameMember") then
        if ns.asparty[frameName] == nil then
            ns.asparty[frameName] = {};
        end
        asframe = ns.asparty[frameName];
    else
        if y > max_y then
            max_y = y;
        end

        if y <= max_y / 2 then
            ns.asraid[frameName] = nil;
            return;
        end

        if ns.asraid[frameName] == nil then
            ns.asraid[frameName] = {};
        end

        asframe = ns.asraid[frameName];
    end

    if frame.unit then
        asframe.unit = frame.unit;
    end

    if frame.displayedUnit then
        asframe.displayedUnit = frame.displayedUnit;
    else
        asframe.displayedUnit = frame.unit;
    end

    asframe.frame = frame;
    asframe.updatecount = nil;

    if (not UnitIsPlayer(asframe.unit)) and not ns.isParty(asframe.unit) then
        return;
    end

    local CUF_AURA_BOTTOM_OFFSET = 2;

    local options = DefaultCompactUnitFrameSetupOptions;
    local powerBarHeight = 8;
    local powerBarUsedHeight = options.displayPowerBar and powerBarHeight or 0;
    local centeryoffset = 0;

    if powerBarUsedHeight > 0 then
        CUF_AURA_BOTTOM_OFFSET = 1;
        centeryoffset = 4;
        y = y - powerBarUsedHeight;
    end
    asframe.layout = 0;

    local size_x = x / 6 * ns.options.BuffSizeRate - 1;
    local size_y = y / 3 * ns.options.BuffSizeRate - 1;

    local baseSize = math.min(x / 7 * ns.options.BuffSizeRate, y / 3 * ns.options.BuffSizeRate);

    if baseSize > ns.ACRB_MaxBuffSize then
        baseSize = ns.ACRB_MaxBuffSize
    end

    baseSize = baseSize * 0.9;

    local fontsize = baseSize * ns.options.MinShowBuffFontSizeRate;

    if asframe.isDispellAlert == nil then
        asframe.isDispellAlert = false;
    end

    local function layoutbuff(f, t)
        local bshow = ns.options.ShowBuffTooltip;

        if t == 2 then
            bshow = ns.options.ShowDebuffTooltip;
        end

        f:EnableMouse(false);

        f.icon:SetTexCoord(.08, .92, .08, .92);
        f.border:SetTexture("Interface\\Addons\\asCompactRaidBuff\\border.tga");
        f.border:SetTexCoord(0.08, 0.08, 0.08, 0.92, 0.92, 0.08, 0.92, 0.92);
        f.border:SetVertexColor(0, 0, 0);
        f.border:Show();

        f.cooldown:SetSwipeColor(0, 0, 0, 0.5);
        f.count:ClearAllPoints();
        f.count:SetPoint("BOTTOMRIGHT", f, "BOTTOMRIGHT", 0, 1);

        if not f:GetScript("OnEnter") then
            f:SetScript("OnEnter", function(s)
                if t == 1 then
                    if s.auraInstanceID then
                        GameTooltip_SetDefaultAnchor(GameTooltip, s);
                        GameTooltip:SetUnitBuffByAuraInstanceID(asframe.displayedUnit, s.auraInstanceID, ns.bufffilter);
                    end
                elseif t == 2 then
                    if s.auraInstanceID then
                        if s.isBossBuff then
                            GameTooltip:SetUnitBuffByAuraInstanceID(asframe.displayedUnit, s.auraInstanceID,
                                ns.bufffilter);
                        else
                            GameTooltip:SetUnitDebuffByAuraInstanceID(asframe.displayedUnit, s.auraInstanceID,
                                ns.debufffilter);
                        end
                    end
                else
                    if s.castspellid and s.castspellid > 0 then
                        GameTooltip_SetDefaultAnchor(GameTooltip, s);
                        GameTooltip:SetSpellByID(s.castspellid);
                    end
                end
            end)
            f:SetScript("OnLeave", function()
                GameTooltip:Hide();
            end)
            f:EnableMouse(false);
            f:SetMouseMotionEnabled(bshow);
        end
    end

    local function layoutcooldown(f)
        f.count:SetFont(STANDARD_TEXT_FONT, fontsize, "OUTLINE")
        f.remain:SetFont(STANDARD_TEXT_FONT, fontsize + 1, "OUTLINE")

        for _, r in next, { f.cooldown:GetRegions() } do
            if r:GetObjectType() == "FontString" then
                r:SetFont(STANDARD_TEXT_FONT, fontsize, "OUTLINE")
                r:ClearAllPoints();
                r:SetPoint("TOPLEFT", 1, 0);
                break
            end
        end

        if not ns.options.ShowBuffCooldown or select(1, f:GetSize()) < ns.options.MinCoolShowBuffSize then
            f.cooldown:SetHideCountdownNumbers(true);
        else
            f.cooldown:SetHideCountdownNumbers(false);
        end
    end

    local strata = "LOW";
    local framelevel = 4;


    if frame.buffFrames[1] then
        strata = frame.buffFrames[1]:GetFrameStrata();
        framelevel = frame.buffFrames[1]:GetFrameLevel();
    end

    if not asframe.asbuffFrames then
        asframe.asbuffFrames = {}
        for i = 1, ns.ACRB_MAX_BUFFS do
            local buffFrame = CreateFrame("Button", nil, frame, "asCompactBuffTemplate")
            layoutbuff(buffFrame, 1);
            asframe.asbuffFrames[i] = buffFrame;
            buffFrame:Hide();

            buffFrame:SetFrameStrata(strata);
            buffFrame:SetFrameLevel(framelevel);
        end
    end

    if asframe.asbuffFrames then
        for i = 1, ns.ACRB_MAX_BUFFS do
            local buffFrame = asframe.asbuffFrames[i];
            buffFrame:ClearAllPoints();

            if i <= ns.ACRB_MAX_BUFFS - 3 then
                if math.fmod(i - 1, 3) == 0 then
                    if i == 1 then
                        local buffOffset = CUF_AURA_BOTTOM_OFFSET + powerBarUsedHeight;
                        buffFrame:ClearAllPoints();
                        buffFrame:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", -2, buffOffset);
                    else
                        buffFrame:SetPoint("BOTTOMRIGHT", asframe.asbuffFrames[i - 3], "TOPRIGHT", 0, 1);
                    end
                else
                    buffFrame:SetPoint("BOTTOMRIGHT", asframe.asbuffFrames[i - 1], "BOTTOMLEFT", -1, 0);
                end

                buffFrame.cooldown:SetSwipeColor(0, 0, 0, 0.5);
            else
                -- 3개는 따로 뺀다.
                if i == ns.ACRB_MAX_BUFFS then
                    -- 우상
                    buffFrame:ClearAllPoints();
                    buffFrame:SetPoint("TOPRIGHT", frame, "TOPRIGHT", -2, -2);
                elseif i == ns.ACRB_MAX_BUFFS - 1 then
                    -- 우중2
                    buffFrame:ClearAllPoints();
                    buffFrame:SetPoint("BOTTOMRIGHT", asframe.asbuffFrames[i - 1], "BOTTOMLEFT", -1, 0);
                else
                    -- 우중
                    buffFrame:ClearAllPoints();
                    buffFrame:SetPoint("RIGHT", frame, "RIGHT", -2, centeryoffset);
                end

                buffFrame.cooldown:SetSwipeColor(0, 0, 0, 1);
            end
        end
    end

    -- 크기 조정
    for i, d in ipairs(asframe.asbuffFrames) do
        d:SetSize(size_x, size_y);
        layoutcooldown(d);
    end

    if not asframe.asdebuffFrames then
        asframe.asdebuffFrames = {};
        for i = 1, ns.ACRB_MAX_DEBUFFS do
            local debuffFrame = CreateFrame("Button", nil, frame, "asCompactDebuffTemplate")
            layoutbuff(debuffFrame, 2);
            asframe.asdebuffFrames[i] = debuffFrame;
            debuffFrame:Hide();

            debuffFrame:SetFrameStrata(strata);
            debuffFrame:SetFrameLevel(framelevel);
        end
    end

    if asframe.asdebuffFrames then
        for i = 1, ns.ACRB_MAX_DEBUFFS do
            local debuffFrame = asframe.asdebuffFrames[i];
            debuffFrame:ClearAllPoints()

            if math.fmod(i - 1, 3) == 0 then
                if i == 1 then
                    local debuffOffset = CUF_AURA_BOTTOM_OFFSET + powerBarUsedHeight;
                    debuffFrame:ClearAllPoints();
                    debuffFrame:SetPoint("BOTTOMLEFT", frame, "BOTTOMLEFT", 2, debuffOffset);
                else
                    debuffFrame:SetPoint("BOTTOMLEFT", asframe.asdebuffFrames[i - 3], "TOPLEFT", 0, 1);
                end
            else
                debuffFrame:SetPoint("BOTTOMLEFT", asframe.asdebuffFrames[i - 1], "BOTTOMRIGHT", 1, 0);
            end
        end
    end

    for _, d in ipairs(asframe.asdebuffFrames) do
        d.size_x, d.size_y = size_x, size_y; -- 디버프
        d:SetSize(size_x, size_y);
        layoutcooldown(d);
    end

    if (not asframe.defensivebuffFrames) then
        asframe.defensivebuffFrames = {};

        for i = 1, ns.ACRB_MAX_DEFENSIVE_BUFFS do
            local pvpbuffFrame = CreateFrame("Button", nil, frame, "asCompactBuffTemplate");
            asframe.defensivebuffFrames[i] = pvpbuffFrame;
            layoutbuff(pvpbuffFrame, 1);

            pvpbuffFrame:SetFrameStrata(strata);
            pvpbuffFrame:SetFrameLevel(framelevel);
        end
    end

    for i, d in ipairs(asframe.defensivebuffFrames) do
        d:SetSize(size_x, size_y);
        layoutcooldown(d);
        d:ClearAllPoints();
        if i == 1 then
            d:SetPoint("CENTER", frame, "CENTER", 0, centeryoffset);
        else
            d:SetPoint("TOPRIGHT", asframe.defensivebuffFrames[i - 1], "TOPLEFT", 0, 0);
        end
    end

    if (not asframe.castFrames) then
        asframe.castFrames = {};

        for i = 1, ns.ACRB_MAX_CASTING do
            local castFrame = CreateFrame("Button", nil, frame, "asCompactBuffTemplate");
            asframe.castFrames[i] = castFrame;
            castFrame:SetFrameStrata(strata);
            castFrame:SetFrameLevel(framelevel);
            layoutbuff(castFrame, 3);
        end
    end

    for i, d in ipairs(asframe.castFrames) do
        d:SetSize(size_x, size_y);
        layoutcooldown(d);
        d:ClearAllPoints();
        if i == 1 then
            d:SetPoint("TOP", frame, "TOP", 0, -2);
        else
            d:SetPoint("TOPRIGHT", asframe.castFrames[i - 1], "TOPLEFT", -1, 0);
        end
    end

    if not asframe.asdispelDebuffFrames then
        asframe.asdispelDebuffFrames = {};
        for i = 1, ns.ACRB_MAX_DISPEL_DEBUFFS do
            local dispelDebuffFrame = CreateFrame("Button", nil, frame, "asCompactDispelDebuffTemplate")
            dispelDebuffFrame:EnableMouse(false);
            asframe.asdispelDebuffFrames[i] = dispelDebuffFrame;
            dispelDebuffFrame:Hide();

            dispelDebuffFrame:SetFrameStrata(strata);
            dispelDebuffFrame:SetFrameLevel(framelevel);
        end
    end

    if asframe.asdispelDebuffFrames then
        asframe.asdispelDebuffFrames[1]:SetPoint("RIGHT", asframe.asbuffFrames[ns.ACRB_MAX_BUFFS], "LEFT", -1, 0);
        for i = 1, ns.ACRB_MAX_DISPEL_DEBUFFS do
            if (i > 1) then
                asframe.asdispelDebuffFrames[i]:SetPoint("RIGHT", asframe.asdispelDebuffFrames[i - 1], "LEFT", 0, 0);
            end
            asframe.asdispelDebuffFrames[i]:SetSize(baseSize, baseSize);
        end
    end

    if (not asframe.asManabar) then
        asframe.asManabar = CreateFrame("StatusBar", nil, frame.healthBar);
        asframe.asManabar:SetStatusBarTexture("Interface\\Addons\\asCompactRaidBuff\\UI-StatusBar");
        asframe.asManabar:GetStatusBarTexture():SetHorizTile(false);
        asframe.asManabar:SetMinMaxValues(0, 100);
        asframe.asManabar:SetValue(100);
        asframe.asManabar:SetPoint("BOTTOM", frame.healthBar, "BOTTOM", 0, 0);
        asframe.asManabar:SetFrameStrata(strata);
        asframe.asManabar:SetFrameLevel(framelevel);
        asframe.asManabar:Hide();
    end

    if asframe.asManabar then
        asframe.asManabar:SetWidth(x - 2);
        asframe.asManabar:SetHeight(ns.ACRB_HealerManaBarHeight);
    end

    if (not asframe.asraidicon) then
        asframe.asraidicon = frame:CreateFontString(nil, "OVERLAY");
        asframe.asraidicon:SetFont(STANDARD_TEXT_FONT, fontsize * 2);
        asframe.asraidicon:SetPoint("LEFT", frame.healthBar, "LEFT", 2, 0);
        asframe.asraidicon:Hide();
    end

    if asframe.asraidicon then
        asframe.asraidicon:SetFont(STANDARD_TEXT_FONT, fontsize * 2);
    end

    if not asframe.buffcolor then
        asframe.buffcolor = frame:CreateTexture(nil, "ARTWORK", "asBuffTextureTemplate", -1);
        asframe.buffcolor:Hide();
    end

    if asframe.buffcolor then
        local previousTexture = frame.healthBar:GetStatusBarTexture();
        asframe.buffcolor:ClearAllPoints();
        asframe.buffcolor:SetAllPoints(previousTexture);
        asframe.buffcolor:SetVertexColor(0.5, 0.5, 0.5);
    end

    if not asframe.healthcolor then
        asframe.healthcolor = frame:CreateTexture(nil, "ARTWORK", "asBuffTextureTemplate", -1);
        asframe.healthcolor:Hide();
    end

    if asframe.healthcolor then
        asframe.healthcolor:ClearAllPoints();
        asframe.healthcolor:SetAllPoints(asframe.buffcolor);
        asframe.healthcolor:SetVertexColor(1, 0.3, 0.3);
        asframe.healthcolor:SetDrawLayer("ARTWORK");
        asframe.healthcolor:SetAlpha(0.5);
    end

    if not asframe.aborbcolor then
        asframe.aborbcolor = frame:CreateTexture(nil, "ARTWORK", "asBuffTextureTemplate", 0);
        asframe.aborbcolor:Hide();
    end

    if asframe.aborbcolor then
        local previousTexture = frame.healthBar:GetStatusBarTexture();
        asframe.aborbcolor:ClearAllPoints();
        asframe.aborbcolor:SetPoint("TOPLEFT", previousTexture, "TOPLEFT", 0, 0);
        asframe.aborbcolor:SetPoint("BOTTOMLEFT", previousTexture, "BOTTOMLEFT", 0, 0);
        asframe.aborbcolor:SetWidth(0);
        asframe.aborbcolor:SetVertexColor(0, 0, 0);
        asframe.aborbcolor:SetDrawLayer("ARTWORK");
        asframe.aborbcolor:SetAlpha(0.2);
    end

    asframe.ncasting = 0;

    ns.ACRB_UpdateHealerMana(asframe);
    ns.ACRB_UpdateRaidIconAborbColor(asframe);
    ns.ACRB_UpdateAuras(asframe);
end

local function ACRB_disableDefault(frame)
    if frame and not frame:IsForbidden() then
        -- 거리 기능 충돌 때문에 안됨
        -- frame.optionTable.fadeOutOfRange = false;
        frame:UnregisterEvent("UNIT_AURA");
        frame:UnregisterEvent("PLAYER_REGEN_ENABLED");
        frame:UnregisterEvent("PLAYER_REGEN_DISABLED");

        do
            if frame.buffFrames then
                for i = 1, #frame.buffFrames do
                    frame.buffFrames[i]:SetAlpha(0);
                    frame.buffFrames[i]:Hide();
                end
            end
        end

        do
            if frame.debuffFrames then
                for i = 1, #frame.debuffFrames do
                    frame.debuffFrames[i]:SetAlpha(0);
                    frame.debuffFrames[i]:Hide();
                end
            end
        end

        do
            if frame.dispelDebuffFrames then
                for i = 1, #frame.dispelDebuffFrames do
                    frame.dispelDebuffFrames[i]:SetAlpha(0);
                    frame.dispelDebuffFrames[i]:Hide();
                end
            end
        end
    end
end

local function ARCB_UpdateAll(frame)
    if frame and not frame:IsForbidden() and frame.GetName then
        local name = frame:GetName();

        if name and not (name == nil) and
            (string.find(name, "CompactPartyFrameMember") or string.find(name, "CompactRaidGroup") or
                string.find(name, "CompactRaidFrame")) then
            if not (frame.unit and UnitIsPlayer(frame.unit)) and not ns.isParty(frame.unit) then
                return
            end
            ACRB_disableDefault(frame);
            ACRB_setupFrame(frame);
        end
    end
end

local updatecount = 0;
local NUM_MEMBERS = 5;

local function ACRB_updatePartyAllAura(auraonly, update_all)
    if auraonly then
        local count = 0;
        local newcount = (updatecount + 1) % 100;

        if (IsInRaid()) then
            for _, asframe in pairs(ns.asraid) do
                if asframe and asframe.frame and (asframe.updatecount == nil or asframe.updatecount == updatecount) then
                    if asframe.frame:IsShown() then
                        ns.ACRB_UpdateAuras(asframe);
                        count = count + 1;
                    end
                    asframe.updatecount = newcount;
                    if count == NUM_MEMBERS and update_all == false then
                        return;
                    end
                end
            end
            updatecount = newcount;
        elseif (IsInGroup()) then
            for _, asframe in pairs(ns.asparty) do
                if asframe and asframe.frame and (asframe.updatecount == nil or asframe.updatecount == updatecount) then
                    if asframe.frame:IsShown() then
                        ns.ACRB_UpdateAuras(asframe);
                    end
                end
            end
        end
    else
        if (IsInRaid()) then
            for _, asframe in pairs(ns.asraid) do
                if asframe and asframe.frame and asframe.frame:IsShown() then
                    ACRB_setupFrame(asframe.frame);
                end
            end
        elseif (IsInGroup()) then
            for _, asframe in pairs(ns.asparty) do
                if asframe and asframe.frame and asframe.frame:IsShown() then
                    ACRB_setupFrame(asframe.frame);
                end
            end
        end
    end
end

local numberofgroups = 1;

local function ACRB_OnUpdateAura()
    ACRB_updatePartyAllAura(true, false);
end

local function ACRB_OnUpdate()
    ACRB_updatePartyAllHealerMana();
    ns.ACRB_CheckCasting();
end

local timero;
local timeroAura;

function ns.SetupAll(init)
    ns.DumpCaches();
    if timero then
        timero:Cancel();
    end

    if timeroAura then
        timeroAura:Cancel();
    end

    local function get_party_count(member_count)
        if member_count == 0 then
            return 1;
        end
        if member_count % NUM_MEMBERS == 0 then
            return member_count / NUM_MEMBERS
        else
            return math.floor(member_count / NUM_MEMBERS) + 1
        end
    end

    numberofgroups = get_party_count(GetNumGroupMembers());

    if init then
        ACRB_InitList();
    end
    ACRB_updatePartyAllAura(false, true);
    timero = C_Timer.NewTicker(ns.UpdateRate, ACRB_OnUpdate);
    timeroAura = C_Timer.NewTicker(ns.UpdateRate / numberofgroups, ACRB_OnUpdateAura);
end

local bfirst = true;

local function ACRB_OnEvent(self, event, arg1, arg2, arg3)
    if bfirst then
        ns.SetupOptionPanels();
        ns.SetupAll(true);
        bfirst = false;
    end

    if event == "UNIT_SPELLCAST_SUCCEEDED" and arg1 == "player" then
        ACRB_updatePartyAllAura(true, true);
    elseif event == "UNIT_SPELLCAST_START" or event == "UNIT_SPELLCAST_CHANNEL_START" then
        local unit = arg1;
        local spellid = arg3;
        if unit and spellid and ns.isAttackable(unit) and string.find(unit, "nameplate") then
            ns.CastingUnits[unit] = true;
        end
    elseif (event == "PLAYER_ENTERING_WORLD") then
        ns.hasValidPlayer = true;
        local bloaded = LoadAddOn("DBM-Core");
        if bloaded then
            hooksecurefunc(DBM, "NewMod", ns.NewMod)
        end
        ns.updateTankerList();
    elseif (event == "TRAIT_CONFIG_UPDATED") or (event == "TRAIT_CONFIG_LIST_UPDATED") or (event == "ACTIVE_TALENT_GROUP_CHANGED") then
        ns.SetupAll(true);
        ns.UpdateDispellable();
    elseif (event == "GROUP_ROSTER_UPDATE") or (event == "CVAR_UPDATE") or (event == "ROLE_CHANGED_INFORM") then
        ns.updateTankerList();
        ns.SetupAll(false);
    elseif (event == "PLAYER_REGEN_ENABLED" or event == "PLAYER_REGEN_DISABLED") then
        ns.SetupAll(false);
    elseif (event == "PLAYER_LEAVING_WORLD") then
        ns.hasValidPlayer = false;
    end
end

ACRB_mainframe:SetScript("OnEvent", ACRB_OnEvent)
ACRB_mainframe:RegisterEvent("UNIT_SPELLCAST_START");
ACRB_mainframe:RegisterEvent("UNIT_SPELLCAST_CHANNEL_START");
ACRB_mainframe:RegisterEvent("GROUP_ROSTER_UPDATE");
ACRB_mainframe:RegisterEvent("PLAYER_ENTERING_WORLD");
ACRB_mainframe:RegisterEvent("PLAYER_LEAVING_WORLD");
ACRB_mainframe:RegisterEvent("ACTIVE_TALENT_GROUP_CHANGED");
ACRB_mainframe:RegisterEvent("TRAIT_CONFIG_UPDATED");
ACRB_mainframe:RegisterEvent("TRAIT_CONFIG_LIST_UPDATED");
ACRB_mainframe:RegisterEvent("CVAR_UPDATE");
ACRB_mainframe:RegisterEvent("ROLE_CHANGED_INFORM");
ACRB_mainframe:RegisterEvent("VARIABLES_LOADED");
ACRB_mainframe:RegisterEvent("PLAYER_REGEN_ENABLED");
ACRB_mainframe:RegisterEvent("PLAYER_REGEN_DISABLED");
-- CPU 리소스
-- ACRB_mainframe:RegisterUnitEvent("UNIT_SPELLCAST_SUCCEEDED", "player");

hooksecurefunc("CompactUnitFrame_UpdateAll", ARCB_UpdateAll);
hooksecurefunc("CompactUnitFrame_UpdateName", ns.UpdateNameColor);
