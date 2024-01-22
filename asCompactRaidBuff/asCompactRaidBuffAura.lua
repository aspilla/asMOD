local _, ns = ...;

ns.IsInRaid = true;

-- AuraUtil
local PLAYER_UNITS = {
    player = true,
    vehicle = true,
    pet = true
};

local DispellableDebuffTypes = {
    Magic = true,
    Curse = true,
    Disease = true,
    Poison = true
};

local dispelNodeIDs = {
    -- DRUID ----------------
    -- 102 - Balance
    [102] = { ["Curse"] = 82205, ["Poison"] = 82205 },
    -- 103 - Feral
    [103] = { ["Curse"] = 82204, ["Poison"] = 82204 },
    -- 104 - Guardian
    [104] = { ["Curse"] = 82215, ["Poison"] = 82215 },
    -- Restoration
    [105] = { ["Curse"] = 82203, ["Magic"] = true, ["Poison"] = 82203 },
    -------------------------

    -- EVOKER ---------------
    -- 1467 - Devastation
    [1467] = { ["Curse"] = 93294, ["Disease"] = 93294, ["Poison"] = { 93306, 93294 }, ["Bleed"] = 93294 },
    -- 1468	- Preservation
    [1468] = { ["Curse"] = 93294, ["Disease"] = 93294, ["Magic"] = true, ["Poison"] = true, ["Bleed"] = 93294 },
    -- 1473 - Augmentation
    [1473] = { ["Curse"] = 93294, ["Disease"] = 93294, ["Poison"] = { 93306, 93294 }, ["Bleed"] = 93294 },
    -------------------------

    -- MAGE -----------------
    -- 62 - Arcane
    [62] = { ["Curse"] = 62116 },
    -- 63 - Fire
    [63] = { ["Curse"] = 62116 },
    -- 64 - Frost
    [64] = { ["Curse"] = 62116 },
    -------------------------

    -- MONK -----------------
    -- 268 - Brewmaster
    [268] = { ["Disease"] = 81633, ["Poison"] = 81633 },
    -- 269 - Windwalker
    [269] = { ["Disease"] = 80606, ["Poison"] = 80606 },
    -- 270 - Mistweaver
    [270] = { ["Disease"] = 81634, ["Magic"] = true, ["Poison"] = 81634 },
    -------------------------

    -- PALADIN --------------
    -- 65 - Holy
    [65] = { ["Disease"] = 81508, ["Magic"] = true, ["Poison"] = 81508 },
    -- 66 - Protection
    [66] = { ["Disease"] = 81507, ["Poison"] = 81507 },
    -- 70 - Retribution
    [70] = { ["Disease"] = 81507, ["Poison"] = 81507 },
    -------------------------

    -- PRIEST ---------------
    -- 256 - Discipline
    [256] = { ["Disease"] = 82705, ["Magic"] = true },
    -- 257 - Holy
    [257] = { ["Disease"] = 82705, ["Magic"] = true },
    -- 258 - Shadow
    [258] = { ["Disease"] = 82704, ["Magic"] = 82699 },
    -------------------------

    -- SHAMAN ---------------
    -- 262 - Elemental
    [262] = { ["Curse"] = 81075, ["Poison"] = 81093 },
    -- 263 - Enhancement
    [263] = { ["Curse"] = 81077, ["Poison"] = 81093 },
    -- 264 - Restoration
    [264] = { ["Curse"] = 81073, ["Magic"] = true, ["Poison"] = 81093 },
    -------------------------

    -- WARLOCK --------------
    -- 265 - Affliction
    -- [265] = {["Magic"] = function() return IsSpellKnown(89808, true) end},
    -- 266 - Demonology
    -- [266] = {["Magic"] = function() return IsSpellKnown(89808, true) end},
    -- 267 - Destruction
    -- [267] = {["Magic"] = function() return IsSpellKnown(89808, true) end},
    -------------------------
}


function ns.UpdateDispellable()
    -- update dispellable
    wipe(DispellableDebuffTypes)
    local specID = GetSpecializationInfo(GetSpecialization())    
    local activeConfigID = C_ClassTalents.GetActiveConfigID()
    if activeConfigID and dispelNodeIDs[specID] then
        for dispelType, value in pairs(dispelNodeIDs[specID]) do
            if type(value) == "boolean" then                
                DispellableDebuffTypes[dispelType] = value
            elseif type(value) == "table" then     -- more than one trait
                for _, v in pairs(value) do
                    local nodeInfo = C_Traits.GetNodeInfo(activeConfigID, v)
                    if nodeInfo and nodeInfo.ranksPurchased ~= 0 then
                        DispellableDebuffTypes[dispelType] = true
                        break
                    end
                end
            else     -- number: check node info
                local nodeInfo = C_Traits.GetNodeInfo(activeConfigID, value)
                if nodeInfo and nodeInfo.ranksPurchased ~= 0 then                    
                    DispellableDebuffTypes[dispelType] = true
                end
            end
        end
    end

    -- texplore(dispellable)
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
    return table.concat({...}, '|');
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
    -- continuationToken is the first return value of UnitAuraSlots()
    local n = select('#', ...);
    for i = 1, n do
        local slot = select(i, ...);
        local done;
        if usePackedAura then
            local auraInfo = C_UnitAuras.GetAuraDataBySlot(unit, slot);
            done = func(auraInfo);
        else
            done = func(UnitAuraBySlot(unit, slot));
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
            UnitAuraSlots(unit, filter, maxCount, continuationToken));
    until continuationToken == nil;
end

function ns.updateDispelType(new)
    DispellableDebuffTypes = new;
end

ns.debufffilter = CreateFilterString(AuraFilters.Harmful);
ns.bufffilter = CreateFilterString(AuraFilters.Helpful);

local cachedVisualizationInfo = {};
ns.hasValidPlayer = false;

local function GetCachedVisibilityInfo(spellId)
    if cachedVisualizationInfo[spellId] == nil then
        local newInfo = {SpellGetVisibilityInfo(spellId,
            UnitAffectingCombat("player") and "RAID_INCOMBAT" or "RAID_OUTOFCOMBAT")};
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

local function IsPriorityDebuff(spellId)
    local _, classFilename = UnitClass("player");
    if (classFilename == "PALADIN") then
        local isForbearance = (spellId == 25771);
        return isForbearance or CheckIsPriorityAura(spellId);
    else
        return CheckIsPriorityAura(spellId);
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
    dispellDebuffFrame:Show();
    dispellDebuffFrame.icon:SetTexture("Interface\\RaidFrame\\Raid-Icon-Debuff" .. aura.dispelName);
    dispellDebuffFrame.auraInstanceID = aura.auraInstanceID;
end

local function ARCB_UtilSetBuff(buffFrame, aura)
    buffFrame.icon:SetTexture(aura.icon);
    if (aura.applications > 1) then
        local countText = aura.applications;
        if (aura.applications >= 100) then
            countText = BUFF_STACKS_OVERFLOW;
        end
        buffFrame.count:Show();
        buffFrame.count:SetText(countText);
    else
        buffFrame.count:Hide();
    end
    buffFrame.auraInstanceID = aura.auraInstanceID;
    local enabled = aura.expirationTime and aura.expirationTime ~= 0;
    if enabled and not ns.options.HideCooldown then
        local startTime = aura.expirationTime - aura.duration;
        ns.asCooldownFrame_Set(buffFrame.cooldown, startTime, aura.duration, true);
    else
        asCooldownFrame_Clear(buffFrame.cooldown);
    end

    if ns.options.HideCooldown then
        local remain = math.ceil(aura.expirationTime - GetTime());

        if remain > 0 and remain < 10 then
            buffFrame.remain:SetText(remain);
            buffFrame.remain:Show();
        else
            buffFrame.remain:Hide();
        end
    else
        buffFrame.remain:Hide();
    end

    if ns.ACRB_ShowList then
        local showlist_time = 0;

        if ns.ACRB_ShowList[aura.name] then
            showlist_time = ns.ACRB_ShowList[aura.name][1];
            if showlist_time == 1 then
                ns.ACRB_ShowList[aura.name][1] = aura.duration * 0.3;
            end
        end

        if showlist_time > 0 and aura.expirationTime - GetTime() < showlist_time then
            buffFrame.border:SetVertexColor(1, 1, 1);
            buffFrame.remain:SetTextColor(1, 0, 0);
        else
            buffFrame.border:SetVertexColor(0, 0, 0);
            buffFrame.remain:SetTextColor(1, 1, 1);
        end
    end

    buffFrame:Show();
end

-- Debuff 설정 부
local function ACRB_UtilSetDebuff(debuffFrame, aura)
    debuffFrame.filter = aura.isRaid and AuraFilters.Raid or nil;
    debuffFrame.icon:SetTexture(aura.icon);
    if (aura.applications > 1) then
        local countText = aura.applications;
        if (aura.applications >= 100) then
            countText = BUFF_STACKS_OVERFLOW;
        end
        debuffFrame.count:Show();
        debuffFrame.count:SetText(countText);
    else
        debuffFrame.count:Hide();
    end
    debuffFrame.auraInstanceID = aura.auraInstanceID;
    local enabled = aura.expirationTime and aura.expirationTime ~= 0;
    if enabled and not ns.options.HideCooldown then
        local startTime = aura.expirationTime - aura.duration;
        ns.asCooldownFrame_Set(debuffFrame.cooldown, startTime, aura.duration, true);
    else
        asCooldownFrame_Clear(debuffFrame.cooldown);
    end

    if ns.options.HideCooldown then
        local remain = math.ceil(aura.expirationTime - GetTime());

        if remain > 0 and remain < 10 then
            debuffFrame.remain:SetText(remain);
            debuffFrame.remain:Show();
        else
            debuffFrame.remain:Hide();
        end
    else
        debuffFrame.remain:Hide();
    end

    local color = DebuffTypeColor[aura.dispelName] or DebuffTypeColor["none"];
    debuffFrame.border:SetVertexColor(color.r, color.g, color.b);

    debuffFrame.isBossBuff = aura.isBossAura and aura.isHelpful;
    if (aura.isBossAura or (aura.nameplateShowAll and aura.duration > 0 and aura.duration < 10)) then
        debuffFrame:SetSize((debuffFrame.size_x) * 1.3, debuffFrame.size_y * 1.3);
    else
        debuffFrame:SetSize(debuffFrame.size_x, debuffFrame.size_y);
    end

    if not ns.options.ShowBuffCooldown or select(1, debuffFrame:GetSize()) < ns.options.MinCoolShowBuffSize then
        debuffFrame.cooldown:SetHideCountdownNumbers(true);
    else
        debuffFrame.cooldown:SetHideCountdownNumbers(false);
    end

    debuffFrame:Show();
end

local function ProcessAura(aura)
    if aura == nil then
        return AuraUpdateChangedType.None;
    end

    if aura.isNameplateOnly then
        return AuraUpdateChangedType.None;
    end

    if ns.ACRB_BlackList and ns.ACRB_BlackList[aura.name] then
        return AuraUpdateChangedType.None;
    end

    if aura.isBossAura and not aura.isRaid then
        aura.debuffType = aura.isHarmful and UnitFrameDebuffType.BossDebuff or UnitFrameDebuffType.BossBuff;
        return AuraUpdateChangedType.Debuff;
    elseif aura.isHarmful then
        if not aura.isRaid then
            if aura.nameplateShowAll then
                aura.debuffType = UnitFrameDebuffType.namePlateShowAll;
                return AuraUpdateChangedType.Debuff;
            elseif IsPriorityDebuff(aura.spellId) then
                aura.debuffType = UnitFrameDebuffType.PriorityDebuff;
                return AuraUpdateChangedType.Debuff;
            elseif ShouldDisplayDebuff(aura) then
                aura.debuffType = UnitFrameDebuffType.NonBossDebuff;
                return AuraUpdateChangedType.Debuff;
            end
        else -- aura.isRaid
            aura.debuffType = aura.isBossAura and UnitFrameDebuffType.BossDebuff or
                                      UnitFrameDebuffType.NonBossRaidDebuff;
            if DispellableDebuffTypes[aura.dispelName] then                
                return AuraUpdateChangedType.Dispel;
            else
                return AuraUpdateChangedType.Debuff;
            end
        end
    elseif aura.isHelpful then
        local showlist = ns.ACRB_ShowList and ns.ACRB_ShowList[aura.name];
        if showlist and PLAYER_UNITS[aura.sourceUnit] then
            aura.debuffType = UnitFrameBuffType.Normal + showlist[2];
            return AuraUpdateChangedType.Buff;
        elseif ShouldDisplayBuff(aura) then
            aura.debuffType = UnitFrameBuffType.Normal;
            return AuraUpdateChangedType.Buff;
        elseif ns.ACRB_DefensiveBuffList[aura.spellId] then
            -- longer duration should have lower priority.
            aura.debuffType = UnitFrameBuffType.Normal + aura.duration;
            return AuraUpdateChangedType.Defensive;
        end
    end

    return AuraUpdateChangedType.None;
end

local function ACRB_ParseAllAuras(asframe)

    local DispellTypes = {
        Magic = true,
        Curse = true,
        Disease = true,
        Poison = true
    };

    if asframe.debuffs == nil then
        asframe.debuffs = TableUtil.CreatePriorityTable(UnitFrameDebuffComparator,
            TableUtil.Constants.AssociativePriorityTable);
        asframe.buffs = TableUtil.CreatePriorityTable(UnitFrameBuffComparator,
            TableUtil.Constants.AssociativePriorityTable);
        asframe.defensivebuffs = TableUtil.CreatePriorityTable(UnitFrameDefensiveComparator,
            TableUtil.Constants.AssociativePriorityTable);
        asframe.dispels = {};
        for type, _ in pairs(DispellTypes) do
            asframe.dispels[type] = TableUtil.CreatePriorityTable(DefaultAuraCompare,
                TableUtil.Constants.AssociativePriorityTable);
        end
    else
        asframe.debuffs:Clear();
        asframe.buffs:Clear();
        asframe.defensivebuffs:Clear();
        for type, _ in pairs(DispellTypes) do
            asframe.dispels[type]:Clear();
        end
    end

    local batchCount = nil;
    local usePackedAura = true;
    local function HandleAura(aura)
        local type = ProcessAura(aura);

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
    ForEachAura(asframe.displayedUnit, ns.bufffilter, batchCount, HandleAura, usePackedAura);
    ForEachAura(asframe.displayedUnit, ns.debufffilter, batchCount, HandleAura, usePackedAura);
end

function ns.ACRB_UpdateAuras(asframe)

    local frame = asframe.frame;

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

    ACRB_ParseAllAuras(asframe);

    do
        local frameNum = 1;
        local maxDebuffs = ns.ACRB_MAX_DEBUFFS;
        asframe.debuffs:Iterate(function(auraInstanceID, aura)
            if frameNum > maxDebuffs then
                return true;
            end

            local debuffFrame = asframe.asdebuffFrames[frameNum];
            ACRB_UtilSetDebuff(debuffFrame, aura);
            frameNum = frameNum + 1;

            if aura.isBossAura or (aura.nameplateShowAll and aura.duration > 0 and aura.duration < 10) then
                maxDebuffs = maxDebuffs - 1;
            end

            return false;
        end);

        for i = frameNum, ns.ACRB_MAX_DEBUFFS do
            local debuffFrame = asframe.asdebuffFrames[i];
            debuffFrame:Hide();
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

            if ns.ACRB_ShowList and ns.ACRB_ShowList[aura.name] and ns.ACRB_ShowList[aura.name][2] then
                type = ns.ACRB_ShowList[aura.name][2];
            end

            if type == 6 and not showframe[type] then
                local buffFrame = asframe.asbuffFrames[type];
                ns.UpdateNameColor(asframe.frame, true);
                ARCB_UtilSetBuff(buffFrame, aura);
                showframe[type] = true;
            elseif type > 3 and not showframe[frameIdx2] then
                local buffFrame = asframe.asbuffFrames[frameIdx2];
                ARCB_UtilSetBuff(buffFrame, aura);
                showframe[frameIdx2] = true;
                frameIdx2 = frameIdx2 + 1;
            else
                local buffFrame = asframe.asbuffFrames[frameIdx];
                ARCB_UtilSetBuff(buffFrame, aura);
                frameIdx = frameIdx + 1;
            end

            frameNum = frameNum + 1;
            return false;
        end);

        for i = frameIdx, ns.ACRB_MAX_BUFFS - 3 do
            local buffFrame = asframe.asbuffFrames[i];
            buffFrame:Hide();
        end

        for i = ns.ACRB_MAX_BUFFS - 2, ns.ACRB_MAX_BUFFS do
            if not showframe[i] then
                local buffFrame = asframe.asbuffFrames[i];
                if i == 6 then
                    ns.UpdateNameColor(asframe.frame, false);
                end
                buffFrame:Hide();
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
                ARCB_UtilSetBuff(buffFrame, aura);
                frameNum = frameNum + 1;

                return false;
            end);
        end

        for i = frameNum, ns.ACRB_MAX_DEFENSIVE_BUFFS do
            local buffFrame = asframe.defensivebuffFrames[i];
            if buffFrame then
                buffFrame:Hide();
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
                    ns.lib.PixelGlow_Start(asframe.frame, {color.r, color.g, color.b, 1})
                    asframe.isDispellAlert = true;
                end
                showdispell = true;
            end
        end
        for i = frameNum, ns.ACRB_MAX_DISPEL_DEBUFFS do
            local dispellDebuffFrame = asframe.asdispelDebuffFrames[i];
            dispellDebuffFrame:Hide();
        end

        if showdispell == false then
            if asframe.isDispellAlert then
                ns.lib.PixelGlow_Stop(asframe.frame);
                asframe.isDispellAlert = false;
            end
        end
    end
end
