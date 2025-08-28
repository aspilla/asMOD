local _, ns = ...;

--AuraUtil
local UnitFrameDebuffType = EnumUtil.MakeEnum(

    "NonBossBuff",
    "NonBossDebuff",
    "NonBossRaidDebuff",
    "PriorityDebuff",
    "namePlateShowAll",
    "nameplateShowPersonal",
    "BossBuff",
    "BossDebuff"
);

local AuraUpdateChangedType = EnumUtil.MakeEnum(
    "None",
    "Debuff",
    "Buff",
    "PVP",
    "Dispel"
);


local AuraFilters =
{
    Helpful = "HELPFUL",
    Harmful = "HARMFUL",
    Raid = "RAID",
    IncludeNameplateOnly = "INCLUDE_NAME_PLATE_ONLY",
    Player = "PLAYER",
    Cancelable = "CANCELABLE",
    NotCancelable = "NOT_CANCELABLE",
    Maw = "MAW",
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

local activeDebuffs = {};
local activeBuffs = {};

local cachedVisualizationInfo = {};

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

function ns.DumpCaches()
    cachedVisualizationInfo = {};
    cachedPriorityChecks = {};
end

local function ShouldShowDebuffs(unit, caster, nameplateShowAll, aura)
    if (nameplateShowAll) then
        return true;
    end

    if (caster and (UnitIsUnit("player", caster) or UnitIsOwnerOrControllerOfUnit("player", caster))) then
        return true;
    end

    local IsFriendly = not UnitCanAttack("player", unit);
    local IsAPlayer = UnitIsPlayer(unit);
    local IsAPlayerPet = UnitIsOtherPlayersPet(unit);
    if (not IsAPlayer and not IsAPlayerPet and not IsFriendly) then
        return false;
    end

    if IsAPlayer and ShouldDisplayDebuff(aura) then
        return true;
    end

    return false;
end

local function ProcessBuffs(aura, unit)
    if aura == nil or aura.icon == nil or unit == nil or not aura.isHelpful then
        return AuraUpdateChangedType.None;
    end

    if ns.Buff_BlackList[aura.spellId] then
        return AuraUpdateChangedType.None;
    end

    if ns.DangerousSpellList[aura.spellId] then
        aura.debuffType = UnitFrameDebuffType.BossBuff;
        return AuraUpdateChangedType.Buff;
    else
        aura.debuffType = UnitFrameDebuffType.NonBossBuff;
        return AuraUpdateChangedType.Buff;
    end
end

local bufffilter = CreateFilterString(AuraFilters.Helpful);
local function ParseBuffs(unit)
    if activeBuffs[unit] == nil then
        activeBuffs[unit] = TableUtil.CreatePriorityTable(UnitFrameDebuffComparator,
            TableUtil.Constants.AssociativePriorityTable);
    else
        activeBuffs[unit]:Clear();
    end

    local function HandleAura(aura)
        local type = ProcessBuffs(aura, unit);

        if type == AuraUpdateChangedType.Buff then
            activeBuffs[unit][aura.auraInstanceID] = aura;
        end
        return false;
    end

    local batchCount = nil;
    local usePackedAura = true;

    ForEachAura(unit, bufffilter, batchCount, HandleAura, usePackedAura);
end


local function ProcessDebuffs(aura, unit)
    if aura == nil or aura.icon == nil or unit == nil or not aura.isHarmful then
        return AuraUpdateChangedType.None;
    end

    if not aura.isRaid then
        local bshow = false;

        if aura.nameplateShowAll then
            aura.debuffType = UnitFrameDebuffType.namePlateShowAll;
            bshow = true;
        elseif IsPriorityDebuff(aura.spellId) then
            aura.debuffType = UnitFrameDebuffType.PriorityDebuff;
            bshow = true;
        elseif ShouldShowDebuffs(unit, aura.sourceUnit, aura.nameplateShowAll, aura) then
            aura.debuffType = UnitFrameDebuffType.NonBossDebuff;
            bshow = true;
        end

        if bshow then
            return AuraUpdateChangedType.Debuff;
        end
    elseif UnitIsPlayer(unit) then -- aura.isRaid
        aura.debuffType = aura.isBossAura and UnitFrameDebuffType.BossDebuff or
            UnitFrameDebuffType.NonBossRaidDebuff;

        return AuraUpdateChangedType.Debuff;
    else
        if ShouldShowDebuffs(unit, aura.sourceUnit, aura.nameplateShowAll, aura) then
            aura.debuffType = aura.isBossAura and UnitFrameDebuffType.BossDebuff or
                UnitFrameDebuffType.NonBossRaidDebuff;
            return AuraUpdateChangedType.Debuff;
        end
    end

    return AuraUpdateChangedType.None;
end

local debufffilter = CreateFilterString(AuraFilters.Harmful);
local function ParseDebuffs(unit)
    if activeDebuffs[unit] == nil then
        activeDebuffs[unit] = TableUtil.CreatePriorityTable(UnitFrameDebuffComparator,
            TableUtil.Constants.AssociativePriorityTable);
    else
        activeDebuffs[unit]:Clear();
    end

    local function HandleAura(aura)
        local type = ProcessDebuffs(aura, unit);

        if type == AuraUpdateChangedType.Debuff then
            activeDebuffs[unit][aura.auraInstanceID] = aura;
        end
        return false;
    end

    local batchCount = nil;
    local usePackedAura = true;

    ForEachAura(unit, debufffilter, batchCount, HandleAura, usePackedAura);
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

local function SetBuff(frame, icon, applications, expirationTime, duration, alert, currtime)
    local data = frame.data;

    if (applications ~= data.applications) then
        local frameCount = frame.count;
        if (applications > 1) then
            frameCount:Show();
            frameCount:SetText(applications);
        else
            frameCount:Hide();
        end
        data.applications = applications;
    end

    local isshow = false;

    if (duration > 0 and (expirationTime - currtime) <= 60) then
        isshow = true;
    end

    if (expirationTime ~= data.expirationTime) or
        (duration ~= data.duration) or
        (isshow ~= data.isshow) then
        if (isshow) then
            local startTime = expirationTime - duration;
            asCooldownFrame_Set(frame.cooldown, startTime, duration, duration > 0, true);
        else
            asCooldownFrame_Clear(frame.cooldown);
        end

        data.duration = duration;
        data.expirationTime = expirationTime;
        data.isshow = isshow;
    end

    if alert ~= data.alert then
        data.alert = alert;
        if alert then
            ns.lib.PixelGlow_Start(frame);
        else
            ns.lib.PixelGlow_Stop(frame);
        end
    end

    if (icon ~= data.icon) then
        frame.icon:SetTexture(icon);
        data.icon = icon;
        frame:Show();
    end
end
local function UpdateBuffFrames(frame, auraList)
    local i = 0;
    local parent = frame;
    local unit = frame.unit;
    local curr_time = GetTime();

    auraList:Iterate(
        function(auraInstanceID, aura)
            i = i + 1;
            if i > #(frame.buffframes) then
                return true;
            end

            local buffframe = parent.buffframes[i];
            local alert = false;

            buffframe.unit = unit;
            buffframe.auraInstanceID = auraInstanceID;

            if aura.debuffType == UnitFrameDebuffType.BossBuff then
                alert = true;
            end

            SetBuff(buffframe, aura.icon, aura.applications, aura.expirationTime, aura.duration, alert, curr_time);


            return false;
        end);

    for j = i + 1, #frame.buffframes do
        local buffframe = parent.buffframes[j];

        if (buffframe) then
            buffframe:Hide();
            ns.lib.PixelGlow_Stop(buffframe);
            buffframe.data = {};
        end
    end
end
local function SetDebuff(frame, icon, applications, expirationTime, duration, color, currtime)
    local data = frame.data;

    if (applications ~= data.applications) then
        local frameCount = frame.count;
        if (applications > 1) then
            frameCount:Show();
            frameCount:SetText(applications);
        else
            frameCount:Hide();
        end
        data.applications = applications;
    end

    local isshow = false;

    if (duration > 0 and (expirationTime - currtime) <= 60) then
        isshow = true;
    end

    if (expirationTime ~= data.expirationTime) or
        (duration ~= data.duration) or
        (isshow ~= data.isshow) then
        if (isshow) then
            local startTime = expirationTime - duration;
            asCooldownFrame_Set(frame.cooldown, startTime, duration, duration > 0, true);
        else
            asCooldownFrame_Clear(frame.cooldown);
        end

        data.duration = duration;
        data.expirationTime = expirationTime;
        data.isshow = isshow;
    end

    if color and (color ~= data.color) then
        frame.border:SetVertexColor(color.r, color.g, color.b);
        data.color = color;
    end

    if (icon ~= data.icon) then
        frame.icon:SetTexture(icon);
        data.icon = icon;
        frame:Show();
    end
end

local function UpdateDebuffFrames(frame, auraList)
    local i = 0;
    local parent = frame;
    local unit = frame.unit;
    local curr_time = GetTime();

    auraList:Iterate(
        function(auraInstanceID, aura)
            i = i + 1;
            if i > #(frame.debuffframes) then
                return true;
            end

            local debuffframe = parent.debuffframes[i];

            debuffframe.unit = unit;
            debuffframe.auraInstanceID = auraInstanceID;

            local color = nil;
            -- set debuff type color
            if (aura.dispelName) then
                color = DebuffTypeColor[aura.dispelName];
            else
                color = DebuffTypeColor["none"];
            end

            local frameBorder = debuffframe.border;
            if aura.nameplateShowAll then
                color = { r = 0.3, g = 0.3, b = 0.3 };
            end
            SetDebuff(debuffframe, aura.icon, aura.applications, aura.expirationTime, aura.duration, color, curr_time);

            return false;
        end);

    for j = i + 1, #frame.debuffframes do
        local debuffframe = parent.debuffframes[j];

        if (debuffframe) then
            debuffframe:Hide();
            debuffframe.data = {};
        end
    end
end

local CONFIG_MAX_COOL = 10;

local function UpdatePortraitFrames(frame, auraList)
    local parent = frame;
    local unit = frame.unit;
    local bshowdebuff = false;
    local curr_time = GetTime();

    auraList:Iterate(
        function(auraInstanceID, aura)
            if aura.nameplateShowAll and aura.duration > 0 and aura.duration <= CONFIG_MAX_COOL then
                local frame = parent.portrait;

                frame.unit = unit;
                frame.auraInstanceID = aura.auraInstanceID;

                -- set the icon
                local frameIcon = frame.icon
                frameIcon:SetTexture(aura.icon);
                frameIcon:Show();
                -- set the count
                local frameCount = frame.count;
                local alert = false;

                -- Handle cooldowns
                local frameCooldown = frame.cooldown;

                if (aura.applications and aura.applications > 1) then
                    frameCount:SetText(aura.applications);
                    frameCount:Show();
                else
                    frameCount:Hide();
                end

                if (aura.duration > 0) then
                    frameCooldown:Show();
                    asCooldownFrame_Set(frameCooldown, aura.expirationTime - aura.duration, aura.duration,
                        aura.duration > 0,
                        true);
                    frameCooldown:SetHideCountdownNumbers(false);
                else
                    frameCooldown:Hide();
                end

                bshowdebuff = true;
                return true;
            else
                return false;
            end
        end);

    if bshowdebuff == false then
        frame.portrait.icon:Hide();
        frame.portrait.cooldown:Hide();
        frame.portrait.count:Hide();
        frame.portrait.border:SetVertexColor(0, 0, 0);
    end
end

function ns.UpdateAuras(frame, unitAuraUpdateInfo)
    local unit = frame.unit;
    local debuffsChanged = false;
    local buffsChanged = false;
    local checkbuff = false;
    local checkdebuff = false;


    if not UnitExists(unit) then
        return
    end


    if frame.debuffupdate or frame.portraitdebuff then
        if activeDebuffs[unit] == nil then
            unitAuraUpdateInfo = nil;
        end
        checkdebuff = true;
    end

    if frame.buffupdate then
        if activeBuffs[unit] == nil then
            unitAuraUpdateInfo = nil;
        end
        checkbuff = true;
    end


    if unitAuraUpdateInfo == nil or unitAuraUpdateInfo.isFullUpdate then
        if frame.debuffupdate or frame.portraitdebuff then
            ParseDebuffs(unit);
            debuffsChanged = true;
        end
        if frame.buffupdate then
            ParseBuffs(unit);
            buffsChanged = true;
        end
    else
        if unitAuraUpdateInfo.addedAuras ~= nil then
            for _, aura in ipairs(unitAuraUpdateInfo.addedAuras) do
                if aura.isHarmful and checkdebuff then
                    local type = ProcessDebuffs(aura, unit);
                    if type == AuraUpdateChangedType.Debuff then
                        activeDebuffs[unit][aura.auraInstanceID] = aura;
                        debuffsChanged = true;
                    end
                elseif aura.isHelpful and checkbuff then
                    local type = ProcessBuffs(aura, unit);
                    if type == AuraUpdateChangedType.Buff then
                        activeBuffs[unit][aura.auraInstanceID] = aura;
                        debuffsChanged = true;
                    end
                end
            end
        end

        if unitAuraUpdateInfo.updatedAuraInstanceIDs ~= nil then
            for _, auraInstanceID in ipairs(unitAuraUpdateInfo.updatedAuraInstanceIDs) do
                if checkdebuff and activeDebuffs[unit][auraInstanceID] ~= nil then
                    local newAura = C_UnitAuras.GetAuraDataByAuraInstanceID(unit, auraInstanceID);
                    local oldDebuffType = activeDebuffs[unit][auraInstanceID].debuffType;
                    if newAura ~= nil then
                        newAura.debuffType = oldDebuffType;
                    end
                    activeDebuffs[unit][auraInstanceID] = newAura;
                    debuffsChanged = true;
                elseif checkbuff and activeBuffs[unit][auraInstanceID] ~= nil then
                    local newAura = C_UnitAuras.GetAuraDataByAuraInstanceID(unit, auraInstanceID);
                    local oldDebuffType = activeBuffs[unit][auraInstanceID].debuffType;
                    if newAura ~= nil then
                        newAura.debuffType = oldDebuffType;
                    end
                    activeBuffs[unit][auraInstanceID] = newAura;
                    buffsChanged = true;
                end
            end
        end

        if unitAuraUpdateInfo.removedAuraInstanceIDs ~= nil then
            for _, auraInstanceID in ipairs(unitAuraUpdateInfo.removedAuraInstanceIDs) do
                if checkdebuff and activeDebuffs[unit][auraInstanceID] ~= nil then
                    activeDebuffs[unit][auraInstanceID] = nil;
                    debuffsChanged = true;
                elseif checkbuff and activeBuffs[unit][auraInstanceID] ~= nil then
                    activeBuffs[unit][auraInstanceID] = nil;
                    buffsChanged = true;
                end
            end
        end
    end

    if debuffsChanged then
        if frame.debuffupdate then
            UpdateDebuffFrames(frame, activeDebuffs[unit]);
        end

        if frame.portraitdebuff then
            UpdatePortraitFrames(frame, activeDebuffs[unit]);
        end
    end

    if buffsChanged then
        UpdateBuffFrames(frame, activeBuffs[unit]);
    end
end
