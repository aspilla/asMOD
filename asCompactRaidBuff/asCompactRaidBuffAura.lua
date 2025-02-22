local _, ns = ...;

ns.IsInRaid = true;

-- AuraUtil
local PLAYER_UNITS = {
    player = true,
    vehicle = true,
    pet = true
};

local DispellableDebuffTypes = {
    Magic = 0,
    Curse = 0,
    Disease = 0,
    Poison = 0
};

local typeCheck = {
    ["Magic"] = {
        [88423] = 1,  --Druid
        [115450] = 1, --Monk
        [527] = 1,    --Priest
        [32375] = 1,  --Priest
        [4987] = 1,   --Paladin
        [77130] = 1,  --Shaman
        [89808] = 2,  --Warlock
        [360823] = 1, --Evoker
    },
    ["Curse"] = {
        [392378] = 1, --Druid
        [2782] = 1,   --Druid
        [51886] = 1,  --Shaman
        [77130] = 1,  --Shaman
        [475] = 1,    --Mage
        [374251] = 1, --Evoker
    },
    ["Poison"] = {
        [392378] = 1, --Druid
        [2782] = 1,   --Druid
        [388874] = 1, --Monk
        [218164] = 1, --Monk
        [393024] = 1, --Paladin
        [213644] = 1, --Paladin
        [374251] = 1, --Evoker
        [365585] = 1, --Evoker
        [383013] = 1, --Shaman
        [459517] = 3, --Hunter Player Only
    },
    ["Disease"] = {
        [388874] = 1, --Monk
        [218164] = 1, --Monk
        [213634] = 1, --Priest
        [390632] = 1, --Priest
        [393024] = 1, --Paladin
        [213644] = 1, --Paladin
        [374251] = 1, --Evoker
        [459517] = 3, --Hunter Player Only
    },

}

function ns.UpdateDispellable()
    local function asIsPetSpell(search)
        if C_SpellBook.HasPetSpells() then
            for i = 1, C_SpellBook.HasPetSpells() do
                local sBookItemInfo = C_SpellBook.GetSpellBookItemInfo(i, Enum.SpellBookSpellBank.Pet)
                local spellID = sBookItemInfo.spellID;
                -- not sure what the non-spell IDs are
                if spellID == search then
                    return true;
                end
            end
        end
        return false;
    end
    for dispelType, _ in pairs(DispellableDebuffTypes) do
        DispellableDebuffTypes[dispelType] = 0;
        for spellID, spelltype in pairs(typeCheck[dispelType]) do
            if spelltype == 1 and IsPlayerSpell(spellID) then
                DispellableDebuffTypes[dispelType] = 1;
            elseif spelltype == 2 and asIsPetSpell(spellID) then
                DispellableDebuffTypes[dispelType] = 1;
            elseif spelltype == 3 and IsPlayerSpell(spellID) then
                DispellableDebuffTypes[dispelType] = 2;
            end
        end
    end
end

local AuraUpdateChangedType = EnumUtil.MakeEnum("None", "Debuff", "Buff", "Defensive", "Dispel");

local UnitFrameDebuffType = EnumUtil.MakeEnum("NonBossDebuff", "NonBossRaidDebuff", "PriorityDebuff",
    "namePlateShowAll", "BossBuff", "BossDebuff");

local UnitFrameBuffType = EnumUtil.MakeEnum("Normal");

local AuraFilters = {
    Helpful = "HELPFUL",
    Harmful = "HARMFUL",
    Raid = "RAID",
    IncludeNameplateOnly = "INCLUDE_NAME_PLATE_ONLY",
    Player = "PLAYER",
    Cancelable = "CANCELABLE",
    NotCancelable = "NOT_CANCELABLE",
    Maw = "MAW"
};

local function CreateFilterString(...)
    return table.concat({ ... }, '|');
end

local function DefaultAuraCompare(a, b)
    local aFromPlayer = (a.sourceUnit ~= nil) and UnitIsUnit("player", a.sourceUnit) or false;
    local bFromPlayer = (b.sourceUnit ~= nil) and UnitIsUnit("player", b.sourceUnit) or false;
    if aFromPlayer ~= bFromPlayer then
        return aFromPlayer;
    end

    if a.canApplyAura ~= b.canApplyAura then
        return a.canApplyAura;
    end

    return a.auraInstanceID < b.auraInstanceID;
end

local function UnitFrameDebuffComparator(a, b)
    if a.debuffType ~= b.debuffType then
        return a.debuffType > b.debuffType;
    end

    return DefaultAuraCompare(a, b);
end

local function UnitFrameBuffComparator(a, b)
    if a.debuffType ~= b.debuffType then
        return a.debuffType > b.debuffType;
    end

    return DefaultAuraCompare(a, b);
end

local function UnitFrameDefensiveComparator(a, b)
    if a.debuffType ~= b.debuffType then
        return a.debuffType < b.debuffType;
    end

    return DefaultAuraCompare(a, b);
end

local function ForEachAuraHelper(unit, filter, func, usePackedAura, continuationToken, ...)
    -- continuationToken is the first return value of C_UnitAuras.GetAuraSlots()
    local n = select('#', ...);
    for i = 1, n do
        local slot = select(i, ...);
        local done;
        local auraInfo = C_UnitAuras.GetAuraDataBySlot(unit, slot);
        if usePackedAura then
            done = func(auraInfo);
        else
            done = func(AuraUtil.UnpackAuraData(auraInfo));
        end
        if done then
            -- if func returns true then no further slots are needed, so don't return continuationToken
            return nil;
        end
    end
    return continuationToken;
end
local function ForEachAura(unit, filter, maxCount, func, usePackedAura)
    if maxCount and maxCount <= 0 then
        return;
    end
    local continuationToken;
    repeat
        -- continuationToken is the first return value of UnitAuraSltos
        continuationToken = ForEachAuraHelper(unit, filter, func, usePackedAura,
            C_UnitAuras.GetAuraSlots(unit, filter, maxCount, continuationToken));
    until continuationToken == nil;
end


ns.debufffilter = CreateFilterString(AuraFilters.Harmful);
ns.bufffilter = CreateFilterString(AuraFilters.Helpful);

local cachedVisualizationInfo = {};
ns.hasValidPlayer = false;

local function GetCachedVisibilityInfo(spellId)
    if cachedVisualizationInfo[spellId] == nil then
        local newInfo = { SpellGetVisibilityInfo(spellId,
            UnitAffectingCombat("player") and "RAID_INCOMBAT" or "RAID_OUTOFCOMBAT") };
        if not ns.hasValidPlayer then
            -- Don't cache the info if the player is not valid since we didn't get a valid result
            return unpack(newInfo);
        end
        cachedVisualizationInfo[spellId] = newInfo;
    end

    local info = cachedVisualizationInfo[spellId];
    return unpack(info);
end

local cachedSelfBuffChecks = {};
local function CheckIsSelfBuff(spellId)
    if cachedSelfBuffChecks[spellId] == nil then
        cachedSelfBuffChecks[spellId] = SpellIsSelfBuff(spellId);
    end

    return cachedSelfBuffChecks[spellId];
end

-- 버프 설정 부
local function ShouldDisplayBuff(aura)
    local unitCaster = aura.sourceUnit;
    local spellId = aura.spellId;
    local canApplyAura = aura.canApplyAura;

    local hasCustom, alwaysShowMine, showForMySpec = GetCachedVisibilityInfo(spellId);

    if (hasCustom) then
        return showForMySpec or
            (alwaysShowMine and (unitCaster == "player" or unitCaster == "pet" or unitCaster == "vehicle"));
    else
        return (unitCaster == "player" or unitCaster == "pet" or unitCaster == "vehicle") and
            ((canApplyAura and not CheckIsSelfBuff(spellId)));
    end
end

local cachedPriorityChecks = {};
local function CheckIsPriorityAura(spellId)
    if cachedPriorityChecks[spellId] == nil then
        cachedPriorityChecks[spellId] = SpellIsPriorityAura(spellId);
    end

    return cachedPriorityChecks[spellId];
end


local IsPriorityDebuff = function(spellId)
    return CheckIsPriorityAura(spellId);
end

local _, classFilename = UnitClass("player");
if (classFilename == "PALADIN") then
    IsPriorityDebuff = function(spellId)
        local isForbearance = (spellId == 25771);
        return isForbearance or CheckIsPriorityAura(spellId);
    end
end

local function ShouldDisplayDebuff(aura)
    local unitCaster = aura.sourceUnit;
    local spellId = aura.spellId;

    local hasCustom, alwaysShowMine, showForMySpec = GetCachedVisibilityInfo(spellId);
    if (hasCustom) then
        return showForMySpec or
            (alwaysShowMine and (unitCaster == "player" or unitCaster == "pet" or unitCaster == "vehicle"));
        -- Would only be "mine" in the case of something like forbearance.
    else
        return true;
    end
end

-- cooldown
local function asCooldownFrame_Clear(self)
    self:Clear();
end

-- cooldown
function ns.asCooldownFrame_Set(self, start, duration, enable, forceShowDrawEdge, modRate)
    if enable and enable ~= 0 and start > 0 and duration > 0 then
        self:SetDrawEdge(forceShowDrawEdge);
        self:SetCooldown(start, duration, modRate);
    else
        asCooldownFrame_Clear(self);
    end
end

function ns.DumpCaches()
    cachedVisualizationInfo = {};
    cachedSelfBuffChecks = {};
    cachedPriorityChecks = {};
end

-- 버프 설정 부
local function ACRB_UtilSetDispelDebuff(dispellDebuffFrame, aura)
    local data = dispellDebuffFrame.data;

    if aura.dispelName ~= data.dispelName then
        dispellDebuffFrame.icon:SetTexture("Interface\\RaidFrame\\Raid-Icon-Debuff" .. aura.dispelName);
        dispellDebuffFrame.auraInstanceID = aura.auraInstanceID;
        dispellDebuffFrame:Show();
        data.dispelName = aura.dispelName;
    end
end

local function ARCB_UtilSetBuff(frame, aura, currtime)
    local data = frame.data;
    local enabled = aura.expirationTime and aura.expirationTime ~= 0;
    local hidecool = true;
    local coolcolor = { r = 0.8, g = 0.8, b = 1 };
    local bordercolor = { r = 0, g = 0, b = 0 };

    frame.auraInstanceID = aura.auraInstanceID;

    if (aura.spellId ~= data.spellId) then
        frame.icon:SetTexture(aura.icon);
        frame:Show();
        data.spellId = aura.spellId;
    end

    if (aura.applications ~= data.applications) then
        if (aura.applications > 1) then
            local countText = aura.applications;
            if (aura.applications >= 100) then
                countText = BUFF_STACKS_OVERFLOW;
            end
            frame.count:Show();
            frame.count:SetText(countText);
        else
            frame.count:Hide();
        end
        data.applications = aura.applications;
    end

    if (aura.expirationTime ~= data.expirationTime) or (aura.duration ~= data.duration) then
        if enabled then
            local startTime = aura.expirationTime - aura.duration;
            ns.asCooldownFrame_Set(frame.cooldown, startTime, aura.duration, true);
        else
            asCooldownFrame_Clear(frame.cooldown);
        end
        data.expirationTime = aura.expirationTime;
        data.duration = aura.duration;
    end

    if enabled then
        local remain = math.ceil(aura.expirationTime - currtime);
        if frame.hideCountdownNumbers == false then
            if remain < ns.options.MinSectoShowCooldown then
                hidecool = false;

                if remain > 0 and remain < 10 then
                    coolcolor = { r = 1, g = 1, b = 0.3 };
                end
            end
        end

        if ns.ACRB_ShowList then
            local showlist_time = 0;

            local showinfo = aura.showlist;

            if showinfo and showinfo[1] then
                showlist_time = showinfo[1];
                if showlist_time == 1 then
                    showinfo[1] = aura.duration * 0.3;
                end
            end

            if showlist_time > 0 and aura.expirationTime - currtime < showlist_time then
                bordercolor = { r = 1, g = 1, b = 1 };
                if frame.hideCountdownNumbers == false then
                    coolcolor = { r = 1, g = 0.3, b = 0.3 };
                end
            end
        end
    end

    if (hidecool ~= data.hidecool) then
        frame.cooldown:SetHideCountdownNumbers(hidecool);
        data.hidecool = hidecool;
    end

    if hidecool == false and (data.coolcolor == nil or coolcolor.g ~= data.coolcolor.g) then
        frame.cooldowntext:SetVertexColor(coolcolor.r, coolcolor.g, coolcolor.b);
        data.coolcolor = coolcolor;
    end

    if data.bordercolor == nil or bordercolor.r ~= data.bordercolor.r then
        frame.border:SetVertexColor(bordercolor.r, bordercolor.g, bordercolor.b);
        data.bordercolor = bordercolor;
    end
end

-- Debuff 설정 부
local function ACRB_UtilSetDebuff(frame, aura, currtime)
    local data = frame.data;
    local enabled = aura.expirationTime and aura.expirationTime ~= 0;
    local hidecool = true;
    local coolcolor = { r = 0.8, g = 0.8, b = 1 };

    frame.filter = aura.isRaid and AuraFilters.Raid or nil;
    frame.auraInstanceID = aura.auraInstanceID;

    if (aura.spellId ~= data.spellId) then
        local color = DebuffTypeColor[aura.dispelName] or DebuffTypeColor["none"];
        local sizerate = 1;

        frame.icon:SetTexture(aura.icon);
        frame.border:SetVertexColor(color.r, color.g, color.b);

        frame.isBossBuff = aura.isBossAura and aura.isHelpful;
        if (aura.isBossAura or (aura.nameplateShowAll and aura.duration > 0 and aura.duration < 10)) then
            sizerate = 1.3;
        end

        if sizerate ~= data.sizerate then
            frame:SetSize((frame.size_x) * sizerate, frame.size_y * sizerate);
            data.sizerate = sizerate;
        end

        data.spellId = aura.spellId;

        frame:Show();
    end

    if (aura.applications ~= data.applications) then
        if (aura.applications > 1) then
            local countText = aura.applications;
            if (aura.applications >= 100) then
                countText = BUFF_STACKS_OVERFLOW;
            end
            frame.count:Show();
            frame.count:SetText(countText);
        else
            frame.count:Hide();
        end
        data.applications = aura.applications;
    end

    if (aura.expirationTime ~= data.expirationTime) or (aura.duration ~= data.duration) then
        if enabled then
            local startTime = aura.expirationTime - aura.duration;
            ns.asCooldownFrame_Set(frame.cooldown, startTime, aura.duration, true);
        else
            asCooldownFrame_Clear(frame.cooldown);
        end
        data.expirationTime = aura.expirationTime;
        data.duration = aura.duration;
    end

    if enabled then
        local remain = math.ceil(aura.expirationTime - currtime);

        if frame.hideCountdownNumbers == false then
            if remain < ns.options.MinSectoShowCooldown then
                hidecool = false;

                if remain > 0 and remain < 10 then
                    coolcolor = { r = 1, g = 1, b = 0.3 };
                end
            end
        end
    end

    if (hidecool ~= data.hidecool) then
        frame.cooldown:SetHideCountdownNumbers(hidecool);
        data.hidecool = hidecool;
    end

    if hidecool == false and (data.coolcolor == nil or coolcolor.g ~= data.coolcolor.g) then
        frame.cooldowntext:SetVertexColor(coolcolor.r, coolcolor.g, coolcolor.b);
        data.coolcolor = coolcolor;
    end
end

local function ProcessAura(aura, asframe)
    if aura == nil then
        return AuraUpdateChangedType.None;
    end

    if aura.isNameplateOnly then
        return AuraUpdateChangedType.None;
    end

    local spellId = aura.spellId;

    if ns.ACRB_BlackList[spellId] then
        return AuraUpdateChangedType.None;
    end

    if aura.isBossAura and not aura.isRaid then
        aura.debuffType = aura.isHarmful and UnitFrameDebuffType.BossDebuff or UnitFrameDebuffType.BossBuff;
        return AuraUpdateChangedType.Debuff;
    end

    if aura.isHarmful then
        -- Determine debuff type and show logic
        local function getDebuffType()
            if aura.isRaid then
                return (aura.isBossAura and UnitFrameDebuffType.BossDebuff) or UnitFrameDebuffType.NonBossRaidDebuff;
            end

            if aura.nameplateShowAll then
                return UnitFrameDebuffType.namePlateShowAll;
            elseif IsPriorityDebuff(spellId) then
                return UnitFrameDebuffType.PriorityDebuff;
            elseif ShouldDisplayDebuff(aura) then
                return UnitFrameDebuffType.NonBossDebuff;
            end

            return nil;
        end

        local debuffType = getDebuffType();
        if debuffType then
            aura.debuffType = debuffType;

            local dispellable = DispellableDebuffTypes[aura.dispelName];
            if dispellable then
                if dispellable == 1 or (dispellable == 2 and asframe.isPlayer) then
                    return AuraUpdateChangedType.Dispel;
                end
            end

            return AuraUpdateChangedType.Debuff;
        end

        -- If none of the above, do not show
        return AuraUpdateChangedType.None;
    end

    if aura.isHelpful then
        aura.showlist = ns.ACRB_ShowList and PLAYER_UNITS[aura.sourceUnit] and ns.ACRB_ShowList[spellId];
        if aura.showlist then
            aura.debuffType = UnitFrameBuffType.Normal + (aura.showlist[2] or 0);
            return AuraUpdateChangedType.Buff;
        end

        if ShouldDisplayBuff(aura) then
            aura.debuffType = UnitFrameBuffType.Normal;
            return AuraUpdateChangedType.Buff;
        end

        local depensiveBuffType = ns.ACRB_DefensiveBuffList[spellId];
        if depensiveBuffType then
            -- longer duration should have lower priority.
            if not (depensiveBuffType == 2 and asframe.isTank) then
                aura.debuffType = UnitFrameBuffType.Normal + aura.duration;
                return AuraUpdateChangedType.Defensive;
            end
        end

        -- If none of the above, do not show
        return AuraUpdateChangedType.None;
    end

    return AuraUpdateChangedType.None;
end

local DispellTypes = {
    Magic = true,
    Curse = true,
    Disease = true,
    Poison = true
};

local DEFAULT_PRIORITY = TableUtil.Constants.AssociativePriorityTable;

local function ACRB_ParseAllAuras(asframe)
    if not asframe.debuffs then
        asframe.debuffs = TableUtil.CreatePriorityTable(UnitFrameDebuffComparator, DEFAULT_PRIORITY);
        asframe.buffs = TableUtil.CreatePriorityTable(UnitFrameBuffComparator, DEFAULT_PRIORITY);
        asframe.defensivebuffs = TableUtil.CreatePriorityTable(UnitFrameDefensiveComparator, DEFAULT_PRIORITY);

        -- Initialize dispel tables
        asframe.dispels = {};
        for type, _ in pairs(DispellTypes) do
            asframe.dispels[type] = TableUtil.CreatePriorityTable(DefaultAuraCompare, DEFAULT_PRIORITY);
        end;
    else
        -- Clear existing auras efficiently
        asframe.debuffs:Clear();
        asframe.buffs:Clear();
        asframe.defensivebuffs:Clear();

        -- Reset dispel tables while reusing existing structures
        for type in pairs(DispellTypes) do
            if asframe.dispels[type] then
                asframe.dispels[type]:Clear();
            end;
        end;
    end;

    local function HandleAura(aura)
        local type = ProcessAura(aura, asframe);

        if type == AuraUpdateChangedType.Debuff then
            asframe.debuffs[aura.auraInstanceID] = aura;
        elseif type == AuraUpdateChangedType.Buff then
            asframe.buffs[aura.auraInstanceID] = aura;
        elseif type == AuraUpdateChangedType.Defensive then
            asframe.defensivebuffs[aura.auraInstanceID] = aura;
        elseif type == AuraUpdateChangedType.Dispel then
            asframe.dispels[aura.dispelName][aura.auraInstanceID] = aura;
            asframe.debuffs[aura.auraInstanceID] = aura;
        end
    end
    ForEachAura(asframe.displayedUnit, ns.bufffilter, nil, HandleAura, true);
    ForEachAura(asframe.displayedUnit, ns.debufffilter, nil, HandleAura, true);
end

local function resetframe(frame)
    if frame.buffFrames and frame.buffFrames[1]:GetAlpha() > 0 then
        for i = 1, #frame.buffFrames do
            frame.buffFrames[i]:SetAlpha(0);
            frame.buffFrames[i]:Hide();
        end
    end

    if frame.debuffFrames and frame.debuffFrames[1]:GetAlpha() > 0 then
        for i = 1, #frame.debuffFrames do
            frame.debuffFrames[i]:SetAlpha(0);
            frame.debuffFrames[i]:Hide();
        end
    end

    if frame.dispelDebuffFrames and frame.dispelDebuffFrames[1]:GetAlpha() > 0 then
        for i = 1, #frame.dispelDebuffFrames do
            frame.dispelDebuffFrames[i]:SetAlpha(0);
            frame.dispelDebuffFrames[i]:Hide();
        end
    end
end

function ns.ACRB_UpdateAuras(asframe)
    local frame = asframe.frame;

    if asframe.needtosetup then
        ns.ACRB_setupFrame(asframe);
    end

    resetframe(frame);

    ACRB_ParseAllAuras(asframe);
    local currtime = GetTime();

    do
        local frameNum = 1;
        local maxDebuffs = ns.ACRB_MAX_DEBUFFS;
        asframe.debuffs:Iterate(function(auraInstanceID, aura)
            if frameNum > maxDebuffs then
                return true;
            end

            local debuffFrame = asframe.asdebuffFrames[frameNum];
            ACRB_UtilSetDebuff(debuffFrame, aura, currtime);
            frameNum = frameNum + 1;

            if aura.isBossAura or (aura.nameplateShowAll and aura.duration > 0 and aura.duration < 10) then
                maxDebuffs = maxDebuffs - 1;
            end

            return false;
        end);

        for i = frameNum, ns.ACRB_MAX_DEBUFFS do
            local debuffFrame = asframe.asdebuffFrames[i];
            debuffFrame:Hide();
            debuffFrame.data = {};
        end
    end

    do
        local frameNum = 1;
        local frameIdx = 1;
        local frameIdx2 = 4;
        local showframe = {};
        asframe.buffs:Iterate(function(auraInstanceID, aura)
            if frameNum > ns.ACRB_MAX_BUFFS + 1 then
                return true;
            end

            local type = 1;

            local showinfo = aura.showlist;

            if showinfo and showinfo[2] then
                type = showinfo[2];
            end

            if type == 6 and not showframe[type] then
                local buffFrame = asframe.asbuffFrames[type];
                ns.UpdateNameColor(asframe.frame, true);
                ARCB_UtilSetBuff(buffFrame, aura, currtime);
                showframe[type] = true;
            elseif type > 3 and not showframe[frameIdx2] then
                local buffFrame = asframe.asbuffFrames[frameIdx2];
                ARCB_UtilSetBuff(buffFrame, aura, currtime);
                showframe[frameIdx2] = true;
                frameIdx2 = frameIdx2 + 1;
            else
                local buffFrame = asframe.asbuffFrames[frameIdx];
                ARCB_UtilSetBuff(buffFrame, aura, currtime);
                frameIdx = frameIdx + 1;
            end

            frameNum = frameNum + 1;
            return false;
        end);

        for i = frameIdx, ns.ACRB_MAX_BUFFS - 3 do
            local buffFrame = asframe.asbuffFrames[i];
            buffFrame:Hide();
            buffFrame.data = {};
        end

        for i = ns.ACRB_MAX_BUFFS - 2, ns.ACRB_MAX_BUFFS do
            if not showframe[i] then
                local buffFrame = asframe.asbuffFrames[i];
                if i == 6 then
                    ns.UpdateNameColor(asframe.frame, false);
                end
                buffFrame:Hide();
                buffFrame.data = {};
            end
        end
    end

    do
        local frameNum = 1;
        local maxBuffs = ns.ACRB_MAX_DEFENSIVE_BUFFS;

        if ns.options.MiddleDefensiveAlert then
            asframe.defensivebuffs:Iterate(function(auraInstanceID, aura)
                if frameNum > maxBuffs then
                    return true;
                end

                local buffFrame = asframe.defensivebuffFrames[frameNum];
                ARCB_UtilSetBuff(buffFrame, aura, currtime);
                frameNum = frameNum + 1;

                return false;
            end);
        end

        for i = frameNum, ns.ACRB_MAX_DEFENSIVE_BUFFS do
            local buffFrame = asframe.defensivebuffFrames[i];
            if buffFrame then
                buffFrame:Hide();
                buffFrame.data = {};
            end
        end
    end

    do
        local frameNum = 1;
        local showdispell = false;

        for _, auraTbl in pairs(asframe.dispels) do
            if frameNum > ns.ACRB_MAX_DISPEL_DEBUFFS then
                break
            end

            if auraTbl:Size() ~= 0 then
                local aura = auraTbl:GetTop();
                local dispellDebuffFrame = asframe.asdispelDebuffFrames[frameNum];
                ACRB_UtilSetDispelDebuff(dispellDebuffFrame, aura);
                frameNum = frameNum + 1;

                local color = DebuffTypeColor[aura.dispelName] or DebuffTypeColor["none"];

                if not asframe.isDispellAlert and ns.options.BorderDispelAlert then
                    ns.lib.PixelGlow_Start(asframe.frame, { color.r, color.g, color.b, 1 })
                    asframe.isDispellAlert = true;
                end
                showdispell = true;
            end
        end
        for i = frameNum, ns.ACRB_MAX_DISPEL_DEBUFFS do
            local dispellDebuffFrame = asframe.asdispelDebuffFrames[i];
            dispellDebuffFrame:Hide();
            dispellDebuffFrame.data = {};
        end

        if showdispell == false then
            if asframe.isDispellAlert then
                ns.lib.PixelGlow_Stop(asframe.frame);
                asframe.isDispellAlert = false;
            end
        end
    end
end
