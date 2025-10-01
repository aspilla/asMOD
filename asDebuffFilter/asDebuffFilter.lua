local _, ns = ...;
local ADF;
local ADF_PLAYER_DEBUFF;
local ADF_TARGET_DEBUFF;


local ADF_BlackList = {

    [206151] = 1, --도전자의 짐
    --	["상처 감염 독"] = 1,	
    --	["신경 마취 독"] = 1,
    --	["맹독"] = 1,
}

local DispellableDebuffTypes =
{
    Magic = true,
    Curse = true,
    Disease = true,
    Poison = true
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

local function UpdateDispellable()
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
        DispellableDebuffTypes[dispelType] = false;
        for spellID, spelltype in pairs(typeCheck[dispelType]) do
            if spelltype == 1 and C_SpellBook.IsSpellKnown(spellID) then
                DispellableDebuffTypes[dispelType] = true;
            elseif spelltype == 2 and asIsPetSpell(spellID) then
                DispellableDebuffTypes[dispelType] = true;
            elseif spelltype == 3 and C_SpellBook.IsSpellKnown(spellID) then
                DispellableDebuffTypes[dispelType] = true;
            end
        end
    end
end

asDebuffPrivateAuraAnchorMixin = {};

function asDebuffPrivateAuraAnchorMixin:SetUnit(unit)
    if unit == self.unit then
        return;
    end
    self.unit = unit;

    if self.anchorID then
        C_UnitAuras.RemovePrivateAuraAnchor(self.anchorID);
        self.anchorID = nil;
    end

    if unit then
        local iconAnchor =
        {
            point = "CENTER",
            relativeTo = self,
            relativePoint = "CENTER",
            offsetX = 0,
            offsetY = 0,
        };

        local privateAnchorArgs = {};
        privateAnchorArgs.unitToken = unit;
        privateAnchorArgs.auraIndex = self.auraIndex;
        privateAnchorArgs.parent = self;
        privateAnchorArgs.showCountdownFrame = true;
        privateAnchorArgs.showCountdownNumbers = true;

        privateAnchorArgs.iconInfo =
        {
            iconAnchor = iconAnchor,
            iconWidth = self:GetWidth(),
            iconHeight = self:GetHeight(),
        };
        privateAnchorArgs.durationAnchor = nil;

        self.anchorID = C_UnitAuras.AddPrivateAuraAnchor(privateAnchorArgs);
    end
end

local function CreatPrivateFrames(parent)
    if parent.PrivateAuraAnchors == nil then
        parent.PrivateAuraAnchors = {};
    end


    local size = ns.ADF_SIZE + 5;

    size = size * ns.options.PlayerDebuffRate;

    for idx = 1, 2 do
        parent.PrivateAuraAnchors[idx] = CreateFrame("Frame", nil, parent, "asDebuffPrivateAuraAnchorTemplate");
        parent.PrivateAuraAnchors[idx].auraIndex = idx;
        parent.PrivateAuraAnchors[idx]:SetSize(size, size * 0.8);
        parent.PrivateAuraAnchors[idx]:SetUnit("player");

        if idx == 2 then
            parent.PrivateAuraAnchors[idx]:ClearAllPoints();
            parent.PrivateAuraAnchors[idx]:SetPoint("RIGHT", parent.PrivateAuraAnchors[1], "LEFT", -1, 0);
        end
    end

    return;
end



local AuraUpdateChangedType = EnumUtil.MakeEnum(
    "None",
    "Debuff",
    "Buff",
    "PVP",
    "Dispel"
);

local UnitFrameDebuffType = EnumUtil.MakeEnum(

    "NonBossDebuff",
    "NonBossRaidDebuff",
    "PriorityDebuff",
    "namePlateShowAll",
    "L0",
    "nameplateShowPersonal",
    "BossBuff",
    "BossDebuff"
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

local asGetSpellTabInfo = function(index)
    local skillLineInfo = C_SpellBook.GetSpellBookSkillLineInfo(index);
    if skillLineInfo then
        return skillLineInfo.name,
            skillLineInfo.iconID,
            skillLineInfo.itemIndexOffset,
            skillLineInfo.numSpellBookItems,
            skillLineInfo.isGuild,
            skillLineInfo.offSpecID,
            skillLineInfo.shouldHide,
            skillLineInfo.specID;
    end
end

local show_list = {};

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



local filter = CreateFilterString(AuraFilters.Harmful);

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

local KnownSpellList = {};

local function asCheckTalent()
    local specID = PlayerUtil.GetCurrentSpecID();
    local configID = C_ClassTalents.GetActiveConfigID();

    if not (configID) then
        return;
    end
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
                --print(string.format("%s/%d %s/%d", talentName, definitionInfo.spellID, definitionInfo.overrideName or "", definitionInfo.overriddenSpellID or 0));
                local name, rank, icon = asGetSpellInfo(definitionInfo.spellID);
                KnownSpellList[talentName or ""] = true;
                KnownSpellList[icon or 0] = true;
                if definitionInfo.overrideName then
                    --print (definitionInfo.overrideName)
                    KnownSpellList[definitionInfo.overrideName] = true;
                end
            end
        end
    end
    return;
end

local function scanSpells(tab)
    local tabName, tabTexture, tabOffset, numEntries = asGetSpellTabInfo(tab)

    if not tabName then
        return;
    end

    for i = tabOffset + 1, tabOffset + numEntries do
        local spellName = C_SpellBook.GetSpellBookItemName(i, Enum.SpellBookSpellBank.Player)
        if not spellName then
            do break end
        end
        local slotType, actionID, spellID = C_SpellBook.GetSpellBookItemType(i, Enum.SpellBookSpellBank.Player);

        if spellName and spellID and C_SpellBook.IsSpellKnown(spellID) then
            KnownSpellList[spellName] = 1;
        end
    end
end

local function scanPetSpells()
    for i = 1, 20 do
        local spellName, _, spellID = C_SpellBook.GetSpellBookItemName(i, Enum.SpellBookSpellBank.Pet)

        if not spellName then
            do break end
        end

        if spellName then
            KnownSpellList[spellName] = 1;
        end
    end
end



local function setupKnownSpell()
    KnownSpellList = {};

    scanSpells(1)
    scanSpells(2)
    scanSpells(3)

    scanPetSpells();
    asCheckTalent();
end

local function ShouldShowDebuffs(unit, caster, nameplateShowAll)
    if (GetCVarBool("noBuffDebuffFilterOnTarget")) then
        return true;
    end

    if (nameplateShowAll) then
        return true;
    end

    if (caster and (UnitIsUnit("player", caster) or UnitIsOwnerOrControllerOfUnit("player", caster))) then
        return true;
    end

    if (UnitIsUnit("player", unit)) then
        return true;
    end

    local targetIsFriendly = not UnitCanAttack("player", unit);
    local targetIsAPlayer = UnitIsPlayer(unit);
    local targetIsAPlayerPet = UnitIsOtherPlayersPet(unit);
    if (not targetIsAPlayer and not targetIsAPlayerPet and not targetIsFriendly) then
        return false;
    end

    return true;
end


local activeDebuffs = {};


local function ProcessAura(aura, unit)
    if aura == nil or aura.icon == nil or unit == nil or not aura.isHarmful then
        return AuraUpdateChangedType.None;
    end

    if ADF_BlackList[aura.spellId] then
        return AuraUpdateChangedType.None;
    end

    local skip = true;
    if unit == "target" then
        skip = true;

        if ShouldShowDebuffs(unit, aura.sourceUnit, aura.nameplateShowAll) then
            skip = false;
        end

        if skip == false then
            if APB_DEBUFF and (APB_DEBUFF == aura.spellId) then
                skip = true;
            elseif APB_DEBUFF2 and (APB_DEBUFF2 == aura.spellId) then
                skip = true;
            elseif APB_DEBUFF_STACK and APB_DEBUFF_STACK == aura.spellId then
                skip = true;
            elseif APB_DEBUFF_TIME_STACK and APB_DEBUFF_TIME_STACK == aura.spellId then
                skip = true;
            elseif ACI_Debuff_list and (ACI_Debuff_list[aura.spellId] or ACI_Debuff_list[aura.name]) then
                skip = true;
            end
        end
    elseif unit == "player" then
        skip = false;

        if APB_DEBUFF_TIME_STACK and APB_DEBUFF_TIME_STACK == aura.spellId then
            skip = true;
        end

        if aura.duration > ns.ADF_MAX_Cool then
            skip = true;
        end

        if aura.isRaid or aura.isBossAura then
            skip = false;
        end
    end

    if skip == false then
        if unit == "target" then
            local showlist = show_list and show_list[aura.spellId];
            if showlist then
                if showlist[2] then
                    aura.debuffType = UnitFrameDebuffType.BossDebuff + showlist[2];
                end
            elseif aura.nameplateShowPersonal then
                aura.debuffType = UnitFrameDebuffType.nameplateShowPersonal;
            elseif (KnownSpellList[aura.name] or KnownSpellList[aura.texture]) then
                aura.debuffType = UnitFrameDebuffType.L0;
            elseif aura.nameplateShowAll then
                aura.debuffType = UnitFrameDebuffType.namePlateShowAll;
            else
                aura.debuffType = UnitFrameDebuffType.NonBossDebuff;
            end
        else
            if not aura.isRaid then
                if aura.isBossAura then
                    aura.debuffType = UnitFrameDebuffType.BossDebuff
                elseif IsPriorityDebuff(aura.spellId) then
                    aura.debuffType = UnitFrameDebuffType.PriorityDebuff;
                else
                    aura.debuffType = UnitFrameDebuffType.NonBossDebuff;
                end
            elseif aura.isRaid then
                aura.debuffType = aura.isBossAura and UnitFrameDebuffType.BossDebuff or
                    UnitFrameDebuffType.NonBossRaidDebuff;
            else
                aura.debuffType = UnitFrameDebuffType.NonBossDebuff;
            end
        end



        activeDebuffs[unit][aura.auraInstanceID] = aura;
        return AuraUpdateChangedType.Debuff;
    end


    return AuraUpdateChangedType.None;
end

local function ParseAllAuras(unit)
    if activeDebuffs[unit] == nil then
        activeDebuffs[unit] = TableUtil.CreatePriorityTable(UnitFrameDebuffComparator,
            TableUtil.Constants.AssociativePriorityTable);
    else
        activeDebuffs[unit]:Clear();
    end

    local function HandleAura(aura)
        ProcessAura(aura, unit);
        return false;
    end

    local batchCount = nil;
    local usePackedAura = true;
    ForEachAura(unit, filter, batchCount, HandleAura, usePackedAura);
end

local function format_count(n)
    local sign = ""
    if n < 0 then
        sign = "-"
        n = -n
    end

    if (n > 999999) then
        n = (math.ceil(n / 1000000) .. "m");
    elseif (n > 999) then
        n = (math.ceil(n / 1000) .. "k");
    end

    return tostring(sign .. n)
end

local function SetDebuff(frame, icon, applications, expirationTime, duration, color, snapshot, alert, currtime, size,
                         points)
    local data = frame.data;

    local count = 0;
    local point = 0;
    local bshowcount = false;

    if (icon ~= data.icon) then
        frame.icon:SetTexture(icon);
        data = {};
        data.icon = icon;
        frame:Show();
    end

    if applications and applications > 0 then
        count = applications;
    end

    if points and points[1] and points[1] ~= 0 then
        point = points[1];
    end

    if count ~= data.count then
        data.count = count;
        if count > 0 then
            bshowcount = true;
            frame.count:Show();
            frame.count:SetText(count);
        else
            frame.count:Hide();
        end
    end

    if bshowcount or count > 0 then
        frame.point:Hide()
    elseif point ~= data.point then
        data.point = point;

        if point > 100 then
            frame.point:SetText(format_count(point));
            frame.point:Show();
        else
            frame.point:Hide();
        end
    end

    if snapshot ~= data.snapshot then
        frame.snapshot:SetText(math.floor(snapshot * 100));
        if snapshot > 1 then
            frame.snapshot:SetTextColor(0.5, 1, 0.5);
            frame.snapshot:Show();
        elseif snapshot == 1 then
            frame.snapshot:Hide();
        else
            frame.snapshot:SetTextColor(1, 0.5, 0.5);
            frame.snapshot:Show();
        end
        data.snapshot = snapshot;
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

    if (alert ~= data.alert) then
        if alert == 3 then
            ns.lib.PixelGlow_Stop(frame);
            ns.lib.ButtonGlow_Start(frame);
        elseif alert == 2 then
            ns.lib.ButtonGlow_Stop(frame);
            ns.lib.PixelGlow_Start(frame);
        elseif alert == 1 then
            ns.lib.ButtonGlow_Stop(frame);
            ns.lib.PixelGlow_Start(frame);
        else
            ns.lib.ButtonGlow_Stop(frame);
            ns.lib.PixelGlow_Stop(frame);
        end
        data.alert = alert;
    end

    if (size ~= data.size) then
        frame:SetWidth(size);
        frame:SetHeight(size * 0.8);
        data.size = size;
    end
end

local function UpdateAuraFrames(unit, auraList, numAuras)
    local i = 0;
    local parent = ADF_TARGET_DEBUFF;
    local guid = UnitGUID("target");
    local curr_time = GetTime();

    if (unit == "player") then
        parent = ADF_PLAYER_DEBUFF;
    end


    auraList:Iterate(
        function(auraInstanceID, aura)
            i = i + 1;
            if i > numAuras then
                return true;
            end

            local frame = parent.frames[i];

            frame.unit = unit;
            frame.auraInstanceID = aura.auraInstanceID;

            local alert = 0;
            local snapshot = 1;

            local showlist = show_list and show_list[aura.spellId];

            if unit == "target" and showlist then
                local showlist_time = showlist[1];
                local alertcount = showlist[4] or false;
                local checksnapshot = showlist[5] or false;
                local alertnameplate = showlist[3] or false;

                if showlist_time == 1 then
                    showlist_time = aura.duration * 0.3;
                    showlist[1] = showlist_time;
                end

                if showlist_time >= 0 and alertcount == false then
                    local alert_time = aura.expirationTime - showlist_time;

                    if (curr_time >= alert_time) and aura.duration > 0 then
                        alert = 2;
                    end
                elseif showlist_time >= 0 and alertcount then
                    if (aura.applications >= showlist_time) then
                        alert = 2;
                    end
                end

                if checksnapshot and asDotSnapshot and asDotSnapshot.Relative then
                    snapshot = asDotSnapshot.Relative(guid, aura.spellId) or 1;
                end
            end

            local color = nil;
            -- set debuff type color
            if (aura.dispelName) then
                color = DebuffTypeColor[aura.dispelName];
            else
                color = DebuffTypeColor["none"];
            end

            if (unit == "player" or UnitCanAssist(unit, "player")) and DispellableDebuffTypes[aura.dispelName] then
                alert = 1;
            end

            local size = ns.ADF_SIZE + 4;


            if aura.debuffType == UnitFrameDebuffType.NonBossDebuff then
                size = ns.ADF_SIZE;
            end

            if unit == "player" then
                size = size * ns.options.PlayerDebuffRate;
            end

            if aura.nameplateShowAll then
                color = { r = 0.3, g = 0.3, b = 0.3 };
            end

            if (aura.isBossDebuff) then
                alert = 3;
            end

            SetDebuff(frame, aura.icon, aura.applications, aura.expirationTime, aura.duration, color, snapshot, alert,
                curr_time, size, aura.points);

            return false;
        end);

    for j = i + 1, ns.ADF_MAX_DEBUFF_SHOW do
        local frame = parent.frames[j];

        if (frame) then
            ns.lib.ButtonGlow_Stop(frame);
            ns.lib.PixelGlow_Stop(frame);
            frame:Hide();
            frame.data = {};
        end
    end

    if parent == ADF_PLAYER_DEBUFF then
        parent.PrivateAuraAnchors[1]:ClearAllPoints();
        if i == 0 then
            parent.PrivateAuraAnchors[1]:SetPoint("BOTTOMRIGHT", ADF_PLAYER_DEBUFF, "BOTTOMLEFT", 0, 0);
        else
            parent.PrivateAuraAnchors[1]:SetPoint("BOTTOMRIGHT", parent.frames[i], "BOTTOMLEFT", -1, 0);
        end
    end
end

local function UpdateAuras(unit, unitAuraUpdateInfo)
    local debuffsChanged = false;

    if activeDebuffs[unit] == nil then
        unitAuraUpdateInfo = nil;
    end

    if unitAuraUpdateInfo == nil or unitAuraUpdateInfo.isFullUpdate then
        ParseAllAuras(unit);
        debuffsChanged = true;
    else
        if unitAuraUpdateInfo.addedAuras ~= nil then
            for _, aura in ipairs(unitAuraUpdateInfo.addedAuras) do
                if not C_UnitAuras.IsAuraFilteredOutByInstanceID(unit, aura.auraInstanceID, filter) then
                    local type = ProcessAura(aura, unit);
                    if type == AuraUpdateChangedType.Debuff then
                        activeDebuffs[unit][aura.auraInstanceID] = aura;
                        debuffsChanged = true;
                    end
                end
            end
        end

        if unitAuraUpdateInfo.updatedAuraInstanceIDs ~= nil then
            for _, auraInstanceID in ipairs(unitAuraUpdateInfo.updatedAuraInstanceIDs) do
                if activeDebuffs[unit][auraInstanceID] ~= nil then
                    local newAura = C_UnitAuras.GetAuraDataByAuraInstanceID(unit, auraInstanceID);
                    local oldDebuffType = activeDebuffs[unit][auraInstanceID].debuffType;
                    if newAura ~= nil then
                        newAura.debuffType = oldDebuffType;
                    end
                    activeDebuffs[unit][auraInstanceID] = newAura;
                    debuffsChanged = true;
                end
            end
        end

        if unitAuraUpdateInfo.removedAuraInstanceIDs ~= nil then
            for _, auraInstanceID in ipairs(unitAuraUpdateInfo.removedAuraInstanceIDs) do
                if activeDebuffs[unit][auraInstanceID] ~= nil then
                    activeDebuffs[unit][auraInstanceID] = nil;
                    debuffsChanged = true;
                end
            end
        end
    end

    if debuffsChanged then
        local numDebuffs = math.min(ns.ADF_MAX_DEBUFF_SHOW, activeDebuffs[unit]:Size());
        UpdateAuraFrames(unit, activeDebuffs[unit], numDebuffs);
    end
end

function ADF_ClearFrame()
    for i = 1, ns.ADF_MAX_DEBUFF_SHOW do
        local frame = ADF_TARGET_DEBUFF.frames[i];

        if (frame) then
            frame:Hide();
            frame.data = {};
            ns.lib.ButtonGlow_Stop(frame);
            ns.lib.PixelGlow_Stop(frame);
        end
    end
end

local function initList()
    local spec = C_SpecializationInfo.GetSpecialization();
    local localizedClass, englishClass = UnitClass("player");
    local listname;

    show_list = nil;

    if spec == nil or spec > 4 or (englishClass ~= "DRUID" and spec > 3) then
        spec = 1;
    end

    if spec then
        listname = "ShowList_" .. englishClass .. "_" .. spec;
    end

    if ns[listname] then
        show_list = CopyTable(ns[listname]);
    else
        show_list = {};
    end

    setupKnownSpell();
    UpdateDispellable();
end

function ADF_OnEvent(self, event, arg1, ...)
    if (event == "UNIT_AURA") then
        local info = ...;
        UpdateAuras(arg1, info);
    elseif (event == "PLAYER_TARGET_CHANGED") then
        ADF_ClearFrame();
        UpdateAuras("target");
    elseif (event == "PLAYER_ENTERING_WORLD") then
        UpdateAuras("target");
        UpdateAuras("player");
    elseif event == "PLAYER_REGEN_DISABLED" then
        ADF:SetAlpha(ns.ADF_AlphaCombat);
        cachedPriorityChecks = {};
    elseif event == "PLAYER_REGEN_ENABLED" then
        ADF:SetAlpha(ns.ADF_AlphaNormal);
        cachedPriorityChecks = {};
    elseif (event == "TRAIT_CONFIG_UPDATED") or (event == "TRAIT_CONFIG_LIST_UPDATED") or (event == "ACTIVE_TALENT_GROUP_CHANGED") or (event == "UNIT_PET") then
        C_Timer.After(0.5, initList);
    elseif (event == "PLAYER_ENTERING_WORLD") then
        C_Timer.After(0.5, initList);
    end
end

local function OnUpdate()
    if (UnitExists("target")) then
        UpdateAuras("target");
    end
end

local function ADF_UpdateDebuffAnchor(frames, index, offsetX, right, parent)
    local buff = frames[index];
    local point1 = "BOTTOMLEFT";
    local point2 = "BOTTOMLEFT";
    local point3 = "BOTTOMRIGHT";

    if (right == false) then
        point1 = "BOTTOMRIGHT";
        point2 = "BOTTOMRIGHT";
        point3 = "BOTTOMLEFT";
        offsetX = -offsetX;
    end

    if (index == 1) then
        buff:SetPoint(point1, parent, point2, 0, 0);
    else
        buff:SetPoint(point1, frames[index - 1], point3, offsetX, 0);
    end

    -- Resize
    buff:SetWidth(ns.ADF_SIZE);
    buff:SetHeight(ns.ADF_SIZE * 0.8);
end


local function CreatDebuffFrames(parent, bright, rate)
    if parent.frames == nil then
        parent.frames = {};
    end

    for idx = 1, ns.ADF_MAX_DEBUFF_SHOW do
        parent.frames[idx] = CreateFrame("Button", nil, parent, "asTargetDebuffFrameTemplate");
        local frame = parent.frames[idx];
        frame.cooldown:SetDrawSwipe(true);

        for _, r in next, { frame.cooldown:GetRegions() } do
            if r:GetObjectType() == "FontString" then
                r:SetFont(STANDARD_TEXT_FONT, ns.ADF_CooldownFontSize * rate, "OUTLINE");
                r:ClearAllPoints();
                r:SetPoint("TOP", 0, 5);
                r:SetDrawLayer("OVERLAY");
                break;
            end
        end
        frame.icon:SetTexCoord(.08, .92, .16, .84);
        frame.icon:SetAlpha(ns.ADF_ALPHA);
        frame.border:SetTexCoord(0.08, 0.08, 0.08, 0.92, 0.92, 0.08, 0.92, 0.92);
        frame.border:SetAlpha(ns.ADF_ALPHA);

        frame.count:SetFont(STANDARD_TEXT_FONT, ns.ADF_CountFontSize, "OUTLINE")
        frame.count:ClearAllPoints();
        frame.count:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", -2, 2);

        frame.point:SetFont(STANDARD_TEXT_FONT, ns.ADF_CountFontSize - 3, "OUTLINE")
        frame.point:ClearAllPoints();
        frame.point:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", -2, 2);
        frame.point:SetTextColor(0, 1, 0);

        frame.snapshot:SetFont(STANDARD_TEXT_FONT, ns.ADF_CountFontSize - 1, "OUTLINE")
        frame.snapshot:ClearAllPoints();
        frame.snapshot:SetPoint("CENTER", frame, "BOTTOM", 0, 1);

        frame:ClearAllPoints();
        ADF_UpdateDebuffAnchor(parent.frames, idx, 1, bright, parent);

        if not frame:GetScript("OnEnter") then
            frame:SetScript("OnEnter", function(s)
                if s.auraInstanceID then
                    GameTooltip_SetDefaultAnchor(GameTooltip, s);
                    GameTooltip:SetUnitDebuffByAuraInstanceID(s.unit, s.auraInstanceID, filter);
                end
            end)
            frame:SetScript("OnLeave", function()
                GameTooltip:Hide();
            end)
        end

        frame:EnableMouse(false);
        frame:SetMouseMotionEnabled(true);
        frame.data = {};
        frame:Hide();
    end

    return;
end


local function ADF_Init()
    ns.SetupOptionPanels();
    local bloaded = C_AddOns.LoadAddOn("asMOD")

    ADF = CreateFrame("Frame", nil, UIParent)

    ADF:SetPoint("CENTER", 0, 0)
    ADF:SetWidth(1)
    ADF:SetHeight(1)
    ADF:SetScale(1)
    ADF:SetAlpha(ns.ADF_AlphaNormal);
    ADF:Show()

    ADF_TARGET_DEBUFF = CreateFrame("Frame", nil, ADF)

    ADF_TARGET_DEBUFF:SetPoint("CENTER", ns.ADF_TARGET_DEBUFF_X, ns.ADF_TARGET_DEBUFF_Y)
    ADF_TARGET_DEBUFF:SetWidth(1)
    ADF_TARGET_DEBUFF:SetHeight(1)
    ADF_TARGET_DEBUFF:SetScale(1)
    ADF_TARGET_DEBUFF:Show()

    CreatDebuffFrames(ADF_TARGET_DEBUFF, true, 1);

    if bloaded and asMOD_setupFrame then
        asMOD_setupFrame(ADF_TARGET_DEBUFF, "asDebuffFilter(Target)");
    end

    ADF_PLAYER_DEBUFF = CreateFrame("Frame", nil, ADF)

    ADF_PLAYER_DEBUFF:SetPoint("CENTER", ns.ADF_PLAYER_DEBUFF_X, ns.ADF_PLAYER_DEBUFF_Y)
    ADF_PLAYER_DEBUFF:SetWidth(1)
    ADF_PLAYER_DEBUFF:SetHeight(1)
    ADF_PLAYER_DEBUFF:SetScale(1)
    ADF_PLAYER_DEBUFF:Show()

    CreatDebuffFrames(ADF_PLAYER_DEBUFF, false, ns.options.PlayerDebuffRate);
    CreatPrivateFrames(ADF_PLAYER_DEBUFF);

    if bloaded and asMOD_setupFrame then
        asMOD_setupFrame(ADF_PLAYER_DEBUFF, "asDebuffFilter(Player)");
    end

    ADF:RegisterEvent("PLAYER_TARGET_CHANGED")
    ADF:RegisterUnitEvent("UNIT_AURA", "player", "target")
    ADF:RegisterEvent("PLAYER_ENTERING_WORLD");
    ADF:RegisterEvent("PLAYER_REGEN_DISABLED");
    ADF:RegisterEvent("PLAYER_REGEN_ENABLED");
    ADF:RegisterEvent("TRAIT_CONFIG_UPDATED");
    ADF:RegisterEvent("TRAIT_CONFIG_LIST_UPDATED");
    ADF:RegisterEvent("ACTIVE_TALENT_GROUP_CHANGED");
    ADF:RegisterUnitEvent("UNIT_PET", "player")


    ADF:SetScript("OnEvent", ADF_OnEvent)

    --주기적으로 Callback
    C_Timer.NewTicker(1, OnUpdate);
    UpdateAuras("target");
    UpdateAuras("player");
end

C_Timer.After(1, ADF_Init);
