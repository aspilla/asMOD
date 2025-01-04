local _, ns = ...;

--AuraUtil


local UnitFrameDebuffType = EnumUtil.MakeEnum(

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

local cachedVisualizationInfo = {};
local hasValidPlayer = false;

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


local function ProcessAura(aura, unit)
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

local filter = CreateFilterString(AuraFilters.Harmful);
local function ParseAllAuras(unit)
    if activeDebuffs[unit] == nil then
        activeDebuffs[unit] = TableUtil.CreatePriorityTable(UnitFrameDebuffComparator,
            TableUtil.Constants.AssociativePriorityTable);
    else
        activeDebuffs[unit]:Clear();
    end

    local function HandleAura(aura)
        local type = ProcessAura(aura, unit);

        if type == AuraUpdateChangedType.Debuff then
            activeDebuffs[unit][aura.auraInstanceID] = aura;
        end
        return false;
    end

    local batchCount = nil;
    local usePackedAura = true;

    ForEachAura(unit, filter, batchCount, HandleAura, usePackedAura);
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

local function UpdateAuraFrames(frame, auraList)
    local i = 0;
    local parent = frame;
    local unit = frame.unit;

    auraList:Iterate(
        function(auraInstanceID, aura)
            i = i + 1;
            if i > #(frame.frames) then
                return true;
            end

            local frame = parent.frames[i];

            frame.unit = unit;
            frame.auraInstanceID = aura.auraInstanceID;

            -- set the icon
            local frameIcon = frame.icon
            frameIcon:SetTexture(aura.icon);
            -- set the count
            local frameCount = frame.other.count;
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
                asCooldownFrame_Set(frameCooldown, aura.expirationTime - aura.duration, aura.duration, aura.duration > 0,
                    true);
                frameCooldown:SetHideCountdownNumbers(false);
            else
                frameCooldown:Hide();
            end

            local color = nil;
            -- set debuff type color
            if (aura.dispelName) then
                color = DebuffTypeColor[aura.dispelName];
            else
                color = DebuffTypeColor["none"];
            end

            local frameBorder = frame.border;
            if aura.nameplateShowAll then
                frameBorder:SetVertexColor(0.3, 0.3, 0.3);
            else
                frameBorder:SetVertexColor(color.r, color.g, color.b);
            end

            frame:Show();
            return false;
        end);

    for j = i + 1, #frame.frames do
        local frame = parent.frames[j];

        if (frame) then
            frame:Hide();
        end
    end
end

local CONFIG_MAX_COOL = 10;

local function UpdatePortraitFrames(frame, auraList)
    local parent = frame;
    local unit = frame.unit;
    local bshowdebuff = false;

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
                local frameCount = frame.other.count;
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

                local color = nil;
                -- set debuff type color
                if (aura.dispelName) then
                    color = DebuffTypeColor[aura.dispelName];
                else
                    color = DebuffTypeColor["none"];
                end

                local frameBorder = frame.border;
                if aura.nameplateShowAll then
                    frameBorder:SetVertexColor(0.3, 0.3, 0.3);
                else
                    frameBorder:SetVertexColor(color.r, color.g, color.b);
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
        frame.portrait.other.count:Hide();
        frame.portrait.border:SetVertexColor(0,0,0);
    end
end

function ns.UpdateAuras(frame)
    local unit = frame.unit;

    ParseAllAuras(unit);
    if frame.debuffupdate then
        UpdateAuraFrames(frame, activeDebuffs[unit]);
    end

    if frame.portraitdebuff then
        UpdatePortraitFrames(frame, activeDebuffs[unit]);
    end
end
