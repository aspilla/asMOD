local _, ns = ...;

local CONFIG_NOT_INTERRUPTIBLE_COLOR = { r = 0.9, g = 0.9, b = 0.9 };                 --차단 불가시 (내가 아닐때) 색상 (r, g, b)
local CONFIG_NOT_INTERRUPTIBLE_COLOR_TARGET = { r = 153 / 255, g = 0, b = 76 / 255 }; --차단 불가시 (내가 타겟일때) 색상 (r, g, b)
local CONFIG_INTERRUPTIBLE_COLOR = { r = 204 / 255, g = 255 / 255, b = 153 / 255 };   --차단 가능(내가 타겟이 아닐때)시 색상 (r, g, b)
local CONFIG_INTERRUPTIBLE_COLOR_TARGET = { r = 76 / 255, g = 153 / 255, b = 0 };     --차단 가능(내가 타겟일 때)시 색상 (r, g, b)

local DangerousSpellList = {}

local ANameP_HealerGuid = {}

local ANameP = nil;
local tanklist = {}

local PLAYER_UNITS = {
    player = true,
    vehicle = true,
    pet = true
};

local lowhealthpercent = 0;

ns.ANameP_ShowList = nil;
local debuffs_per_line = ns.ANameP_DebuffsPerLine;
local playerbuffposition = ns.ANameP_PlayerBuffY;
ns.options = CopyTable(ANameP_Options_Default);

-- Cooldown
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

local function isAttackable(unit)
    local reaction = UnitReaction("player", unit);
    if reaction and reaction <= 4 then
        return true;
    end
    return false;
end

ns.KnownSpellList = {};

local function asCheckTalent(findname)
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
                -- print(string.format("%s/%d %s/%d", talentName, definitionInfo.spellID, definitionInfo.overrideName or "", definitionInfo.overriddenSpellID or 0));
                local name, rank, icon = GetSpellInfo(definitionInfo.spellID);
                ns.KnownSpellList[talentName or ""] = true;
                ns.KnownSpellList[icon or 0] = true;

                if definitionInfo.overrideName then
                    -- print (definitionInfo.overrideName)
                    ns.KnownSpellList[definitionInfo.overrideName] = true;
                end

                if findname and findname == talentName then
                    return true;
                end
            end
        end
    end
    return;
end

local function scanSpells(tab)
    local tabName, tabTexture, tabOffset, numEntries = GetSpellTabInfo(tab)

    if not tabName then
        return;
    end

    for i = tabOffset + 1, tabOffset + numEntries do
        local spellName, _, spellID = GetSpellBookItemName(i, BOOKTYPE_SPELL)
        if not spellName then
            do
                break
            end
        end

        if spellName then
            ns.KnownSpellList[spellName] = 1;
        end
    end
end

local function scanPetSpells()
    for i = 1, 20 do
        local slot = i + (SPELLS_PER_PAGE * (SPELLBOOK_PAGENUMBERS[BOOKTYPE_PET] - 1));
        local spellName, _, spellID = GetSpellBookItemName(slot, BOOKTYPE_PET)

        if not spellName then
            do
                break
            end
        end

        if spellName then
            ns.KnownSpellList[spellName] = 1;
        end
    end
end

local function setupKnownSpell()
    ns.KnownSpellList = {};

    scanSpells(1)
    scanSpells(2)
    scanSpells(3)
    scanPetSpells()
    asCheckTalent();
end

-- 탱커 처리부
local function updateTankerList()
    local bInstance, RTB_ZoneType = IsInInstance();

    if RTB_ZoneType == "pvp" or RTB_ZoneType == "arena" then
        return nil;
    end

    tanklist = {}
    if IsInGroup() then
        if IsInRaid() then -- raid
            for i = 1, GetNumGroupMembers() do
                local unitid = "raid" .. i
                local notMe = not UnitIsUnit("player", unitid)
                if UnitExists(unitid) and notMe then
                    local _, _, _, _, _, _, _, _, _, role, _, assignedRole = GetRaidRosterInfo(i);
                    if assignedRole == "TANK" then
                        table.insert(tanklist, unitid);
                    end
                end
            end
        else -- party
            for i = 1, 4 do
                local unitid = "party" .. i;
                if UnitExists(unitid) then
                    local assignedRole = UnitGroupRolesAssigned(unitid);
                    if assignedRole == "TANK" then
                        table.insert(tanklist, unitid);
                    end
                end
            end
        end
    end
end


local function setFrame(frame, texture, count, expirationTime, duration, color)
    local frameIcon = frame.icon;
    frameIcon:SetTexture(texture);

    local frameCount = frame.count;
    local frameCooldown = frame.cooldown;

    if count and (count > 1) then
        frameCount:SetText(count);
        frameCount:Show();
        frameCooldown:SetDrawSwipe(false);
    else
        frameCount:Hide();
        frameCooldown:SetDrawSwipe(true);
    end

    asCooldownFrame_Set(frameCooldown, expirationTime - duration, duration, duration > 0, true);
    if ns.ANameP_CooldownFontSize > 0 then
        frameCooldown:SetHideCountdownNumbers(false);
    end

    local frameBorder = frame.border;
    frameBorder:SetVertexColor(color.r, color.g, color.b);
end

local function setSize(frame, size)
    frame:SetWidth(size + 2);
    frame:SetHeight((size + 2) * ns.ANameP_Size_Rate);
end

local function updateDebuffAnchor(frames, index, anchorIndex, size, offsetX, right, parent)
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

    buff:ClearAllPoints();

    if parent.downbuff then
        if (index == 1) then
            buff:SetPoint("TOPLEFT", parent, "BOTTOMLEFT", 0, 0);
        elseif (index == (debuffs_per_line + 1)) then
            buff:SetPoint("TOPLEFT", frames[1], "BOTTOMLEFT", 0, -4);
        else
            buff:SetPoint(point1, frames[index - 1], point3, offsetX, 0);
        end
    else
        if (index == 1) then
            buff:SetPoint("BOTTOMLEFT", parent, "TOPLEFT", 0, 0);
        elseif (index == (debuffs_per_line + 1)) then
            buff:SetPoint("BOTTOMLEFT", frames[1], "TOPLEFT", 0, 4);
        else
            buff:SetPoint(point1, frames[index - 1], point3, offsetX, 0);
        end
    end

    setSize(buff, size);
    buff:Show();
    if buff.alert then
        ns.lib.ButtonGlow_Start(buff);
    else
        ns.lib.ButtonGlow_Stop(buff);
    end
end


local classbar_height = nil;
local function GetClassBarHeight()
    if not classbar_height then
        local class = NamePlateDriverFrame:GetClassNameplateBar();

        if class then
            classbar_height = class:GetHeight();
        else
            classbar_height = 0;
        end
    end

    return classbar_height;
end

local function updateAuras(self, unit)
    local numDebuffs = 1;
    local size_list = {};
    local parent = self.nameplateBase;
    local healthBar = parent.UnitFrame.healthBar;
    local bShowCC = false;
    local auraData;
    local icon_size = self.icon_size;

    if not unit then
        return
    end

    if (parent.UnitFrame.BuffFrame and parent.UnitFrame.BuffFrame.Hide) then
        parent.UnitFrame.BuffFrame:SetAlpha(0);
        parent.UnitFrame.BuffFrame:Hide();
        parent.UnitFrame:UnregisterEvent("UNIT_AURA");
    end

    auraData = ns.UpdateAuras(unit);

    if auraData and auraData.type == 2 then
        auraData.buffs:Iterate(function(auraInstanceID, aura)
            if numDebuffs > ns.ANameP_MaxDebuff then
                return true;
            end


            local frame = self.buffList[numDebuffs];
            frame.alert = false;
            size_list[numDebuffs] = icon_size;

            setSize(frame, size_list[numDebuffs]);

            local color = DebuffTypeColor["Disease"];
            setFrame(self.buffList[numDebuffs], aura.icon, aura.applications, aura.expirationTime, aura.duration, color);

            self.buffList[numDebuffs].filter = auraData.bufffilter;
            self.buffList[numDebuffs].type = 1;
            self.buffList[numDebuffs]:SetID(auraInstanceID);
            self.buffList[numDebuffs].unit = unit;

            self.buffList[numDebuffs]:SetMouseMotionEnabled(ns.options.ANameP_Tooltip);

            numDebuffs = numDebuffs + 1;
            return false;
        end);
    elseif auraData and auraData.type == 1 then
        auraData.buffs:Iterate(function(auraInstanceID, aura)
            if numDebuffs > ns.ANameP_MaxBuff then
                return true;
            end

            local frame = self.buffList[numDebuffs];
            frame.alert = false;

            if aura.debuffType == ns.UnitFrameBuffType.PVP then
                size_list[numDebuffs] = icon_size + 2;
            else
                size_list[numDebuffs] = icon_size;
            end

            setSize(frame, size_list[numDebuffs]);

            local color = {
                r = 1,
                g = 1,
                b = 1
            };
            setFrame(self.buffList[numDebuffs], aura.icon, aura.applications, aura.expirationTime, aura.duration, color);
            if aura.isStealable then
                frame.alert = true;
            end

            self.buffList[numDebuffs].filter = auraData.bufffilter;
            self.buffList[numDebuffs].type = 1;
            self.buffList[numDebuffs]:SetID(auraInstanceID);
            self.buffList[numDebuffs].unit = unit;
            self.buffList[numDebuffs]:SetMouseMotionEnabled(ns.options.ANameP_Tooltip);

            numDebuffs = numDebuffs + 1;
            return false;
        end);

        self.debuffColor = 0;

        auraData.debuffs:Iterate(function(auraInstanceID, aura)
            if numDebuffs > ns.ANameP_MaxDebuff then
                return true;
            end

            if ns.ANameP_ShowCCDebuff and bShowCC == false and aura.nameplateShowAll and aura.duration > 0 and
                aura.duration <= 10 then
                show = false;
                bShowCC = true;

                local color = {
                    r = 0.3,
                    g = 0.3,
                    b = 0.3
                };

                setFrame(self.CCdebuff, aura.icon, aura.applications, aura.expirationTime, aura.duration, color);

                self.CCdebuff:ClearAllPoints();
                if self.casticon:IsShown() then
                    self.CCdebuff:SetPoint("LEFT", self.casticon, "RIGHT", 1, 0);
                else
                    self.CCdebuff:SetPoint("LEFT", healthBar, "RIGHT", 1, 0);
                end
                self.CCdebuff.filter = auraData.debufffilter;
                self.CCdebuff:SetID(auraInstanceID);
                self.CCdebuff.unit = unit;

                self.CCdebuff:Show();
            else
                local alert = false;
                local showlist_time = nil;
                if ns.ANameP_ShowList and ns.ANameP_ShowList[aura.name] then
                    showlist_time = ns.ANameP_ShowList[aura.name][1];
                    local alertcount = ns.ANameP_ShowList[aura.name][4] or false;
                    local alertnameplate = ns.ANameP_ShowList[aura.name][3] or 0;

                    if showlist_time == 1 then
                        showlist_time = aura.duration * 0.3;
                        ns.ANameP_ShowList[aura.name][1] = showlist_time;
                    end

                    if showlist_time and showlist_time >= 0 and alertcount == false then
                        local alert_time = aura.expirationTime - showlist_time;

                        if (GetTime() >= alert_time) and aura.duration > 0 then
                            alert = true;
                        else
                            if alertnameplate then
                                self.debuffColor = self.debuffColor + alertnameplate;
                            end
                        end
                    elseif showlist_time and showlist_time >= 0 and alertcount then
                        if (aura.applications >= showlist_time) then
                            alert = true;
                            if alertnameplate then
                                self.debuffColor = self.debuffColor + alertnameplate;
                            end
                        end
                    end
                end

                local frame = self.buffList[numDebuffs];
                frame.alert = false;

                local size = icon_size;

                if aura.nameplateShowAll then
                    size = icon_size + ns.ANameP_PVP_Debuff_Size_Rate;
                end

                size_list[numDebuffs] = size;

                setSize(frame, size_list[numDebuffs]);

                local color = DebuffTypeColor["none"];

                if (not PLAYER_UNITS[aura.sourceUnit]) then
                    color = {
                        r = 0.3,
                        g = 0.3,
                        b = 0.3
                    };
                end

                if aura.dispelName then
                    color = DebuffTypeColor[aura.dispelName];
                end

                setFrame(self.buffList[numDebuffs], aura.icon, aura.applications, aura.expirationTime, aura.duration,
                    color);

                if alert and aura.duration > 0 then
                    frame.alert = true;
                end
                self.buffList[numDebuffs].filter = auraData.debufffilter;
                self.buffList[numDebuffs].type = 2;
                self.buffList[numDebuffs]:SetID(auraInstanceID);
                self.buffList[numDebuffs].unit = unit;
                self.buffList[numDebuffs]:SetMouseMotionEnabled(ns.options.ANameP_Tooltip);

                numDebuffs = numDebuffs + 1;
            end

            return false;
        end);
    end

    for i = 1, numDebuffs - 1 do
        updateDebuffAnchor(self.buffList, i, i - 1, size_list[i], 1, true, self);
    end

    for i = numDebuffs, ns.ANameP_MaxDebuff do
        if (self.buffList[i]) then
            self.buffList[i]:Hide();
            ns.lib.ButtonGlow_Stop(self.buffList[i]);
        end
    end

    if numDebuffs > 1 then
        self:Show();
    end

    if bShowCC == false then
        self.CCdebuff:Hide();
    end
end

local function updateUnitAuras(unit)
    local nameplate = C_NamePlate.GetNamePlateForUnit(unit, issecure());
    if (nameplate and nameplate.asNamePlates ~= nil and not nameplate:IsForbidden()) then
        if nameplate.asNamePlates.checkaura then
            updateAuras(nameplate.asNamePlates, nameplate.namePlateUnitToken);
        else
            nameplate.asNamePlates:Hide();
        end
    end
end

local function updateTargetNameP(self)
    if not self.unit or not self.checkaura then
        return;
    end

    local unit = self.unit;
    local parent = self.nameplateBase;

    if not parent or not parent.UnitFrame or parent.UnitFrame:IsForbidden() then
        return;
    end

    local UnitFrame = parent.UnitFrame;
    local healthBar = UnitFrame.healthBar;

    if not healthBar then
        return;
    end

    local orig_height = self.orig_height
    local cast_height = 8;

    if UnitFrame.castBar then
        cast_height = UnitFrame.castBar:GetHeight();
    end

    if orig_height == nil then
        return;
    end

    local casticon = self.casticon;
    local height = orig_height;
    local base_y = ns.ANameP_TargetBuffY;

    if UnitFrame.name:IsShown() then
        base_y = base_y + UnitFrame.name:GetHeight();
    end

    if UnitIsUnit(unit, "target") then
        height = orig_height + ns.ANameP_TargetHealthBarHeight;
        self.healthtext:Show();

        if casticon then
            casticon:SetWidth((height + cast_height + 2) * 1.2);
            casticon:SetHeight(height + cast_height + 2);
            casticon.border:SetVertexColor(1, 1, 1);
        end

        if GetCVarBool("nameplateResourceOnTarget") then
            base_y = base_y + GetClassBarHeight();
        end
    elseif UnitIsUnit(unit, "player") then
        self.alerthealthbar = false;
        height = orig_height + ns.ANameP_TargetHealthBarHeight;
        self.healthtext:Show();
    else
        height = orig_height;
        self.healthtext:Hide();

        if casticon then
            casticon:SetWidth((height + cast_height + 2) * 1.2);
            casticon:SetHeight(height + cast_height + 2);
            casticon.border:SetVertexColor(0, 0, 0);
        end

        if UnitFrame.name:IsShown() then
            base_y = base_y + 4;
        end
    end

    -- Healthbar 크기
    healthBar:SetHeight(height);

    -- 버프 Position
    self:ClearAllPoints();
    if UnitIsUnit(unit, "player") then
        if self.downbuff then
            self:SetPoint("TOPLEFT", ClassNameplateManaBarFrame, "BOTTOMLEFT", 0, playerbuffposition);
        else
            self:SetPoint("BOTTOMLEFT", healthBar, "TOPLEFT", 0, base_y);
        end
        -- 크기 조정이 안된다.
        -- ClassNameplateManaBarFrame:SetHeight(height);

        if UnitFrame.BuffFrame then
            UnitFrame.BuffFrame:Hide();
        end
    else
        self:SetPoint("BOTTOMLEFT", healthBar, "TOPLEFT", 0, base_y);
        if UnitFrame.BuffFrame then
            UnitFrame.BuffFrame:Hide();
        end
    end
end

local function updateUnitHealthText(unit)
    local value;
    local valueMax;
    local valuePct;
    local namePlateFrameBase = C_NamePlate.GetNamePlateForUnit(unit, issecure());
    if not namePlateFrameBase or namePlateFrameBase.asNamePlates == nil then
        return;
    end
    local frame = namePlateFrameBase.asNamePlates;

    value = UnitHealth(unit);
    valueMax = UnitHealthMax(unit);

    if valueMax > 0 then
        valuePct = (math.ceil((value / valueMax) * 100));
    end

    if valuePct > 0 then
        frame.healthtext:SetText(valuePct);
    else
        frame.healthtext:SetText("");
    end

    if valuePct <= lowhealthpercent then
        frame.healthtext:SetTextColor(1, 0.5, 0.5, 1);
    elseif valuePct > 0 then
        frame.healthtext:SetTextColor(1, 1, 1, 1);
    end
end

-- Healthbar 색상 처리부
local function setColoronStatusBar(self, r, g, b)
    local parent = self.nameplateBase;

    if not parent or not parent.UnitFrame or parent.UnitFrame:IsForbidden() or not self.BarColor then
        return;
    end

    local oldR, oldG, oldB = self.BarColor:GetVertexColor();

    if (r ~= oldR or g ~= oldG or b ~= oldB) then
        self.BarColor:SetVertexColor(r, g, b);
    end

    self.BarTexture:Hide();
    self.BarColor:Show();
end

local function isDangerousSpell(spellId)
    if spellId and DangerousSpellList[spellId] then
        if DangerousSpellList[spellId] == "interrupt" then
            return true, true;
        end
        return true, false;
    end
    return false, false;
end

local bloadedAutoMarker = false;

local function updateHealthbarColor(self)
    -- unit name 부터
    if not self.unit or not self.checkcolor or not self.BarColor or not self.BarTexture then
        return;
    end

    local unit = self.unit;
    local parent = self.nameplateBase;

    if not parent or not parent.UnitFrame or parent.UnitFrame:IsForbidden() then
        return;
    end
    local UnitFrame = parent.UnitFrame;
    local healthBar = UnitFrame.healthBar;

    if not healthBar and healthBar:IsForbidden() then
        return;
    end

    local function IsPlayerEffectivelyTank()
        local assignedRole = UnitGroupRolesAssigned("player");
        if (assignedRole == "NONE") then
            local spec = GetSpecialization();
            return spec and GetSpecializationRole(spec) == "TANK";
        end
        return assignedRole == "TANK";
    end

    local function IsTanking()
        if #tanklist > 0 then
            for _, othertank in ipairs(tanklist) do
                if UnitIsUnit(unit .. "target", othertank) then
                    return true;
                end
            end
        end
        return false;
    end

    local unitname = GetUnitName(unit);
    local status = UnitThreatSituation("player", unit);
    local incombat = UnitAffectingCombat(unit);
    local tanker = IsPlayerEffectivelyTank();
    local isTanking = IsTanking();
    local isTargetPlayer = UnitIsUnit(unit .. "target", "player");
    local isTargetPet = UnitIsUnit(unit .. "target", "pet");
    local CastingAlertColor = nil;


    -- Cast Interrupt
    if self.castspellid and self.casticon and incombat then
        local name, text, texture, startTime, endTime, isTradeSkill, castID, notInterruptible, spellid =
            UnitCastingInfo(unit);
        if not name then
            name, text, texture, startTime, endTime, isTradeSkill, notInterruptible, spellid = UnitChannelInfo(unit);
        end

        if spellid then
            local isDanger, binterrupt = isDangerousSpell(spellid);

            self.castspellid = spellid;
            if isDanger then
                if binterrupt then
                    ns.lib.PixelGlow_Start(self.casticon, { 1, 1, 0, 1 });
                    ns.lib.PixelGlow_Start(healthBar, { 1, 1, 0, 1 }, nil, nil, nil, nil, nil, nil, nil, nil,
                        healthBar:GetFrameLevel() + 10);
                end

                if isTargetPlayer then
                    if notInterruptible then
                        CastingAlertColor = CONFIG_NOT_INTERRUPTIBLE_COLOR_TARGET;
                    else
                        CastingAlertColor = CONFIG_INTERRUPTIBLE_COLOR_TARGET;
                    end
                else
                    if notInterruptible then
                        CastingAlertColor = CONFIG_NOT_INTERRUPTIBLE_COLOR;
                    else
                        CastingAlertColor = CONFIG_INTERRUPTIBLE_COLOR;
                    end
                end
            elseif notInterruptible == false then
                ns.lib.PixelGlow_Start(self.casticon);
                ns.lib.PixelGlow_Stop(healthBar);
            else
                ns.lib.PixelGlow_Stop(self.casticon);
                ns.lib.PixelGlow_Stop(healthBar);
            end
        else
            ns.lib.PixelGlow_Stop(self.casticon);
            ns.lib.PixelGlow_Stop(healthBar);
        end
    else
        if self.casticon then
            ns.lib.PixelGlow_Stop(self.casticon);
        end
        ns.lib.PixelGlow_Stop(healthBar);
    end

    if ns.options.ANameP_ShowDBMCastingColor == false then
        CastingAlertColor = nil;
    end

    local function getColor()
        local color;

        if UnitIsPlayer(unit) then
            return nil;
        end
        -- ColorLevel.Name;
        if unitname and ns.ANameP_AlertList[unitname] then
            color = {
                r = ns.ANameP_AlertList[unitname][1],
                g = ns.ANameP_AlertList[unitname][2],
                b = ns
                    .ANameP_AlertList[unitname][3]
            };

            if ns.ANameP_AlertList[unitname][4] == 1 then
                ns.lib.PixelGlow_Start(healthBar);
                self.alerthealthbar = true;
            end

            self.namecolor = true;
            return color;
        end

        self.namecolor = false;
        --Target and Aggro High Priority
        if IsInGroup() and ns.options.ANameP_AggroShow and incombat then
            if tanker then
                if (not isTargetPlayer or not isTargetPet) and UnitExists(unit .. "target") and not (isAttackable(unit .. "target")) then
                    if isTanking then
                        return ns.options.ANameP_TankAggroLoseColor2;
                    elseif status == nil or status == 0 then
                        return ns.options.ANameP_TankAggroLoseColor;
                    end
                end
            end

            if CastingAlertColor then
                return CastingAlertColor;
            end

            if (isTargetPlayer) then
                return ns.options.ANameP_AggroTargetColor;
            end

            if (isTargetPet) then
                return ns.options.ANameP_TankAggroLoseColor3;
            end

            if status and status > 0 then
                return ns.options.ANameP_AggroColor;
            end
        end


        if lowhealthpercent > 0 then
            -- Lowhealth 처리부
            local value = UnitHealth(unit);
            local valueMax = UnitHealthMax(unit);
            local valuePct = 0;

            if valueMax > 0 then
                valuePct = (math.ceil((value / valueMax) * 100));
            end

            if valuePct <= lowhealthpercent then
                return ns.options.ANameP_LowHealthColor;
            end
        end

        -- Debuff Color
        if self.debuffColor > 0 then
            if self.debuffColor == 1 then
                return ns.options.ANameP_DebuffColor;
            elseif self.debuffColor == 2 then
                return ns.options.ANameP_DebuffColor2;
            elseif self.debuffColor > 2 then
                return ns.options.ANameP_DebuffColor3;
            end
        end

        -- 정상 Tanking
        if ns.options.ANameP_AggroShow and incombat then
            if (isTargetPlayer) then
                return ns.options.ANameP_AggroTargetColor;
            elseif (isTargetPet) then
                return ns.options.ANameP_TankAggroLoseColor3;
            elseif isTanking then
                return ns.options.ANameP_TankAggroLoseColor2;
            elseif status and status > 0 then
                return ns.options.ANameP_AggroColor;
            elseif status then
                return ns.options.ANameP_TankAggroLoseColor;
            end
        end

        if ns.options.ANameP_AutoMarker and bloadedAutoMarker and asAutoMarkerF and asAutoMarkerF.IsAutoMarkerMob(unit) then
            return ns.options.ANameP_AutoMarkerColor;
        end

        if ns.options.ANameP_QuestAlert and not IsInInstance() and C_QuestLog.UnitIsRelatedToActiveQuest(unit) then
            return ns.options.ANameP_QuestColor;
        end

        return nil;
    end

    local color = getColor();

    if color then
        setColoronStatusBar(self, color.r, color.g, color.b);
    else
        self.BarColor:Hide();
        self.BarTexture:Show();
        --parent.UnitFrame.healthBar:SetStatusBarColor(self.BarTexture:GetVertexColor());
    end
end

local function updatePVPAggro(self)
    if not ns.ANameP_PVPAggroShow or not self.namecolor then
        return
    end

    if not self.unit then
        return
    end

    local unit = self.unit;
    local parent = self.nameplateBase;

    if parent.UnitFrame:IsForbidden() then
        return;
    end

    local isTargetPlayer = UnitIsUnit(unit .. "target", "player");

    if (isTargetPlayer) then
        self.aggro1:SetTextColor(1, 0, 0, 1);

        self.aggro1:SetText("▶");
        self.aggro1:Show();

        self.aggro2:SetTextColor(1, 0, 0, 1);

        self.aggro2:SetText("◀");
        self.aggro2:Show();
    else
        self.aggro1:Hide();
        self.aggro2:Hide();
    end
end

local function initAlertList()
    local spec = GetSpecialization();
    local localizedClass, englishClass = UnitClass("player");
    local listname;

    ns.ANameP_ShowList = nil;

    if spec == nil or spec > 4 or (englishClass ~= "DRUID" and spec > 3) then
        spec = 1;
    end

    if spec then
        listname = "ANameP_ShowList_" .. englishClass .. "_" .. spec;
    end

    if ns.options[listname] then
        ns.ANameP_ShowList = CopyTable(ns.options[listname]);
    else
        ns.ANameP_ShowList = {};
    end

    ANameP_HealerGuid = {};

    lowhealthpercent = 0;


    if ns.options.ANameP_LowHealthAlert then
        if (englishClass == "MAGE") then
            if (asCheckTalent("불타는 손길")) then
                lowhealthpercent = 30;
            end

            if (asCheckTalent("비전 폭격")) then
                lowhealthpercent = 35;
            end
        end

        if (englishClass == "HUNTER") then
            if (asCheckTalent("마무리 사격")) then
                lowhealthpercent = 20;
            end
        end

        if (englishClass == "WARRIOR") then
            if (asCheckTalent("대학살")) then
                lowhealthpercent = 35;
            else
                lowhealthpercent = 20;
            end
        end

        if (englishClass == "PRIEST") then
            lowhealthpercent = 20;
        end

        if (englishClass == "PALADIN") then
            lowhealthpercent = 20;
        end

        if (englishClass == "DEATHKNIGHT") then
            if (asCheckTalent("영혼 수확자")) then
                lowhealthpercent = 35;
            end
        end
    end
end

local unit_guid_list = {};

local Aggro_Y = -5;

local function checkSpellCasting(self)
    if not self.unit then
        return;
    end

    local unit = self.unit;
    local name, text, texture, startTime, endTime, isTradeSkill, castID, notInterruptible, spellid = UnitCastingInfo(
        unit);
    if not name then
        name, text, texture, startTime, endTime, isTradeSkill, notInterruptible, spellid = UnitChannelInfo(unit);
    end

    if self.casticon then
        local frameIcon = self.casticon.icon;
        if frameIcon then
            if name then
                frameIcon:SetTexture(texture);
                frameIcon:SetDesaturated(false);
                frameIcon:SetVertexColor(1, 1, 1);
                self.casticon:Show();
                self.casticon.timetext:Hide();
                self.castspellid = spellid;
                self.casticon.castspellid = spellid;
            else
                local dbm_show = false;
                local min_remain = 100;
                if ns.dbm_event_list then
                    for id, v in pairs(ns.dbm_event_list) do
                        local icon = v[4]
                        local remain = v[3] + v[2] - GetTime();
                        local guid = v[8];
                        local colorid = v[6];
                        local dbmspellid = v[7];

                        if remain < -1 then
                            ns.dbm_event_list[id] = nil;
                        elseif guid and UnitGUID(unit) == guid and remain < min_remain then
                            frameIcon:SetTexture(icon);
                            self.casticon:Show();
                            self.casticon.castspellid = dbmspellid;
                            frameIcon:SetDesaturated(true);
                            if remain > 2 then
                                if colorid ~= 4 then
                                    frameIcon:SetVertexColor(1, 0.9, 0.9);
                                    self.casticon.timetext:SetTextColor(1, 1, 1);
                                else
                                    frameIcon:SetVertexColor(0.9, 1, 0.9);
                                    self.casticon.timetext:SetTextColor(1, 1, 1);
                                end
                            else
                                local color = frameIcon:GetVertexColor();
                                if colorid ~= 4 then
                                    frameIcon:SetVertexColor(1, 0.3, 0.3);
                                    self.casticon.timetext:SetTextColor(0, 1, 0);
                                else
                                    frameIcon:SetVertexColor(0.3, 1, 0.3);
                                    self.casticon.timetext:SetTextColor(1, 0, 0);
                                end
                            end

                            if remain > 0 then
                                self.casticon.timetext:SetText(math.ceil(remain));
                                self.casticon.timetext:Show();
                            else
                                self.casticon.timetext:Hide();
                            end

                            dbm_show = true;
                            min_remain = remain;
                        end
                    end
                end

                if dbm_show == false then
                    self.casticon:Hide();
                end
                self.castspellid = nil;
            end
        end
    end
end

local function asNamePlates_OnEvent(self, event, ...)
    if (event == "UNIT_THREAT_SITUATION_UPDATE" or event == "UNIT_THREAT_LIST_UPDATE") then
        updateHealthbarColor(self)
    elseif (event == "PLAYER_TARGET_CHANGED") then
        updateTargetNameP(self);
    else
        checkSpellCasting(self);
        updateHealthbarColor(self);
    end
end

local function createNamePlate(namePlateFrameBase)
end

local namePlateVerticalScale = nil;
local g_orig_height = nil;

local function removeNamePlate(namePlateFrameBase)
    if not namePlateFrameBase or not namePlateFrameBase.namePlateUnitToken then
        return;
    end

    local namePlateUnitToken = namePlateFrameBase.namePlateUnitToken;

    if namePlateFrameBase.asNamePlates ~= nil then
        local asframe = namePlateFrameBase.asNamePlates;

        for i = 1, ns.ANameP_MaxDebuff do
            if (asframe.buffList[i]) then
                asframe.buffList[i]:Hide();
                ns.lib.ButtonGlow_Stop(asframe.buffList[i]);
            end
        end
        ns.lib.PixelGlow_Stop(asframe.casticon);

        asframe.aggro1:Hide();
        asframe.aggro2:Hide();
        asframe.CCdebuff:Hide();
        asframe.healthtext:Hide();
        asframe.resourcetext:Hide();
        asframe.casticon:Hide();
        asframe.healer:Hide();
        asframe.BarTexture:Hide();
        asframe.BarColor:Hide();

        asframe:Hide();
        asframe:UnregisterEvent("UNIT_THREAT_SITUATION_UPDATE");
        asframe:UnregisterEvent("PLAYER_TARGET_CHANGED");
        asframe:UnregisterEvent("UNIT_SPELLCAST_START");
        asframe:UnregisterEvent("UNIT_SPELLCAST_CHANNEL_START");
        asframe:UnregisterEvent("UNIT_SPELLCAST_SUCCEEDED");
        asframe:UnregisterEvent("UNIT_SPELLCAST_INTERRUPTED");
        asframe:UnregisterEvent("UNIT_SPELLCAST_DELAYED");
        asframe:UnregisterEvent("UNIT_SPELLCAST_CHANNEL_STOP");
        asframe:UnregisterEvent("UNIT_SPELLCAST_STOP");
        asframe:UnregisterEvent("UNIT_SPELLCAST_FAILED");
        asframe:SetScript("OnEvent", nil);


        if namePlateFrameBase.UnitFrame and namePlateFrameBase.UnitFrame.healthBar then
            if asframe.alerthealthbar then
                ns.lib.PixelGlow_Stop(namePlateFrameBase.UnitFrame.healthBar);
                asframe.alerthealthbar = false;
            end
        end

        asframe:ClearAllPoints();
        ns.freeasframe(asframe);
        asframe = nil;
    end

    if namePlateFrameBase and namePlateFrameBase.asNamePlates ~= nil then
        namePlateFrameBase.asNamePlates = nil;
    end

    if UnitIsPlayer(namePlateUnitToken) and UnitGUID(namePlateUnitToken) then
        unit_guid_list[UnitGUID(namePlateUnitToken)] = nil;
    end
end

local function addNamePlate(namePlateFrameBase)
    if not namePlateFrameBase and not namePlateFrameBase.namePlateUnitToken then
        return;
    end

    if namePlateFrameBase.UnitFrame:IsForbidden() then
        return;
    end

    local unitFrame = namePlateFrameBase.UnitFrame;
    local healthbar = namePlateFrameBase.UnitFrame.healthBar;
    local unit = namePlateFrameBase.namePlateUnitToken;

    if UnitIsUnit("player", unit) then
        if not ns.ANameP_ShowPlayerBuff then
            if namePlateFrameBase.asNamePlates ~= nil then
                removeNamePlate(namePlateFrameBase);
                unitFrame.BuffFrame:SetAlpha(1);
                unitFrame.BuffFrame:Show();
            end
            return;
        end
    else
        if not isAttackable(unit) then
            if namePlateFrameBase.asNamePlates ~= nil then
                removeNamePlate(namePlateFrameBase);
                unitFrame.BuffFrame:SetAlpha(1);
                unitFrame.BuffFrame:Show();
            end
            return;
        end
    end


    if namePlateFrameBase.asNamePlates == nil then
        namePlateFrameBase.asNamePlates = ns.getasframe();
    end

    local asframe = namePlateFrameBase.asNamePlates;

    asframe:ClearAllPoints();
    asframe:SetParent(healthbar);
    asframe:SetFrameLevel(healthbar:GetFrameLevel() + 20);
    asframe:SetPoint("CENTER", healthbar, "CENTER", 0, 0);
    asframe.nameplateBase = namePlateFrameBase;
    asframe.unit = unit;
    asframe.update = 0;
    asframe.alerthealthbar = false;
    asframe.namecolor = false;
    asframe.checkaura = false;
    asframe.downbuff = false;
    asframe.checkpvptarget = false;
    asframe.bhideframe = false;
    asframe.isshown = nil;
    asframe.originalcolor = {
        r = healthbar.r,
        g = healthbar.g,
        b = healthbar.b
    };
    asframe.checkcolor = false;
    asframe.debuffColor = 0;

    asframe:UnregisterEvent("UNIT_THREAT_SITUATION_UPDATE");
    asframe:UnregisterEvent("PLAYER_TARGET_CHANGED");
    asframe:UnregisterEvent("UNIT_SPELLCAST_START");
    asframe:UnregisterEvent("UNIT_SPELLCAST_CHANNEL_START");
    asframe:UnregisterEvent("UNIT_SPELLCAST_SUCCEEDED");
    asframe:UnregisterEvent("UNIT_SPELLCAST_INTERRUPTED");
    asframe:UnregisterEvent("UNIT_SPELLCAST_DELAYED");
    asframe:UnregisterEvent("UNIT_SPELLCAST_CHANNEL_STOP");
    asframe:UnregisterEvent("UNIT_SPELLCAST_STOP");
    asframe:UnregisterEvent("UNIT_SPELLCAST_FAILED");
    asframe:SetScript("OnEvent", nil);

    local Size = ns.ANameP_AggroSize;

    if namePlateVerticalScale ~= tonumber(GetCVar("NamePlateVerticalScale")) then
        namePlateVerticalScale = tonumber(GetCVar("NamePlateVerticalScale"));
        g_orig_height = healthbar:GetHeight();
    end

    if namePlateVerticalScale > 1.0 then
        Aggro_Y = -1
        Size = ns.ANameP_AggroSize + 2
        debuffs_per_line = ns.ANameP_DebuffsPerLine + 1;
    else
        debuffs_per_line = ns.ANameP_DebuffsPerLine;
    end

    ns.ANameP_MaxDebuff = debuffs_per_line * 2;
    Aggro_Y = 0;

    asframe.orig_height = g_orig_height;

    asframe.aggro1:SetFont(STANDARD_TEXT_FONT, Size, "THICKOUTLINE");
    asframe.aggro1:ClearAllPoints();
    asframe.aggro1:SetPoint("RIGHT", healthbar, "LEFT", -5, Aggro_Y)
 

    asframe.aggro2:SetFont(STANDARD_TEXT_FONT, Size, "THICKOUTLINE");
    asframe.aggro2:ClearAllPoints();
    asframe.aggro2:SetPoint("LEFT", healthbar, "RIGHT", 0, Aggro_Y)

    if ns.ANameP_HealerSize > 0 then
        asframe.healer:SetFont(STANDARD_TEXT_FONT, ns.ANameP_HealerSize, "THICKOUTLINE");
    else
        asframe.healer:SetFont(STANDARD_TEXT_FONT, 1, "THICKOUTLINE");
    end
    asframe.healer:ClearAllPoints();
    asframe.healer:SetPoint("RIGHT", healthbar, "LEFT", -5, Aggro_Y)
    asframe.healer:SetText("★");
    asframe.healer:SetTextColor(0, 1, 0, 1);
    asframe.healer:Hide();

    if unitFrame.castBar then
        asframe.casticon:SetMouseMotionEnabled(ns.options.ANameP_Tooltip);
        asframe.casticon:ClearAllPoints();
        asframe.casticon:SetPoint("BOTTOMLEFT", unitFrame.castBar, "BOTTOMRIGHT", 0, 1);
        asframe.casticon:SetWidth(13);
        asframe.casticon:SetHeight(13);
        asframe.casticon:Hide();
        asframe.castspellid = nil;
    end

    asframe.CCdebuff:SetMouseMotionEnabled(ns.options.ANameP_Tooltip);
    asframe.CCdebuff:ClearAllPoints();
    asframe.CCdebuff:SetPoint("LEFT", asframe.casticon, "RIGHT", 1, 0);
    asframe.CCdebuff:SetWidth(ns.ANameP_CCDebuffSize * 1.2);
    asframe.CCdebuff:SetHeight(ns.ANameP_CCDebuffSize);

    for _, r in next, { asframe.CCdebuff.cooldown:GetRegions() } do
        if r:GetObjectType() == "FontString" then
            r:SetFont(STANDARD_TEXT_FONT, ns.ANameP_CooldownFontSize, "OUTLINE")
            r:SetPoint("TOP", 0, 4);
            break
        end
    end

    asframe.CCdebuff:Hide();

    local previousTexture = healthbar:GetStatusBarTexture();


    asframe.BarTexture:ClearAllPoints();
    asframe.BarTexture:SetAllPoints(previousTexture);
    asframe.BarTexture:SetDrawLayer("OVERLAY", 6);
    asframe.BarTexture:SetVertexColor(previousTexture:GetVertexColor());
    asframe.BarTexture:Show();

    asframe.BarColor:ClearAllPoints();
    asframe.BarColor:SetAllPoints(previousTexture);
    asframe.BarColor:SetDrawLayer("OVERLAY", 7);
    asframe.BarColor:SetVertexColor(previousTexture:GetVertexColor())
    asframe.BarColor:Hide();

    asframe.healthtext:ClearAllPoints();
    asframe.healthtext:SetPoint("CENTER", healthbar, "CENTER", 0, 0)
    asframe.checkaura = false;
    asframe.downbuff = false;
    asframe.healthtext:Hide();
    asframe.checkpvptarget = false;
    asframe.checkcolor = false;

    for i = 1, ns.ANameP_MaxDebuff do
        if (asframe.buffList[i]) then
            asframe.buffList[i]:Hide();
        end
    end

    if not UnitIsPlayer(unit) then
        local bInstance, RTB_ZoneType = IsInInstance();
        if not (RTB_ZoneType == "pvp" or RTB_ZoneType == "arena") then
            -- PVP 에서는 어그로 Check 안함
            asframe:RegisterUnitEvent("UNIT_THREAT_SITUATION_UPDATE", "player", unit);
            asframe:RegisterUnitEvent("UNIT_THREAT_LIST_UPDATE", "player", unit);
        end

        asframe:SetScript("OnEvent", asNamePlates_OnEvent);
        asframe:RegisterEvent("PLAYER_TARGET_CHANGED");
        asframe:RegisterUnitEvent("UNIT_SPELLCAST_START", unit);
        asframe:RegisterUnitEvent("UNIT_SPELLCAST_CHANNEL_START", unit);
        asframe:RegisterUnitEvent("UNIT_SPELLCAST_SUCCEEDED", unit);
        asframe:RegisterUnitEvent("UNIT_SPELLCAST_INTERRUPTED", unit);
        asframe:RegisterUnitEvent("UNIT_SPELLCAST_DELAYED", unit);
        asframe:RegisterUnitEvent("UNIT_SPELLCAST_CHANNEL_STOP", unit);
        asframe:RegisterUnitEvent("UNIT_SPELLCAST_STOP", unit);
        asframe:RegisterUnitEvent("UNIT_SPELLCAST_FAILED", unit);
    end

    if ns.ANameP_SIZE > 0 then
        asframe.icon_size = ns.ANameP_SIZE;
    else
        local orig_width = healthbar:GetWidth();
        asframe.icon_size = (orig_width / debuffs_per_line) - (debuffs_per_line - 1);
    end

    local class = UnitClassification(unit)

    asframe.aggro1:ClearAllPoints();

    if (class == "elite" or class == "worldboss" or class == "rare" or class == "rareelite") then
        asframe.aggro1:SetPoint("RIGHT", healthbar, "LEFT", -12, Aggro_Y);
    else
        asframe.aggro1:SetPoint("RIGHT", healthbar, "LEFT", 0, Aggro_Y);
    end

    asframe.aggro1:Hide();
    asframe.aggro2:Hide();
    asframe:SetWidth(1);
    asframe:SetHeight(1);
    asframe:SetScale(1);

    local showhealer = false;
    local checkaura = false;
    local checkpvptarget = false;
    local checkcolor = false;

    if UnitIsUnit("player", unit) then
        -- asframe:Hide();
        if ns.ANameP_ShowPlayerBuff then
            unitFrame.BuffFrame:SetAlpha(0);
            unitFrame.BuffFrame:Hide();
            unitFrame:UnregisterEvent("UNIT_AURA");

            -- Resource Text

            if ClassNameplateManaBarFrame then
                asframe.resourcetext:SetFont(STANDARD_TEXT_FONT, ns.ANameP_HeathTextSize - 3, "OUTLINE");
                asframe.resourcetext:ClearAllPoints();
                asframe.resourcetext:SetPoint("CENTER", ClassNameplateManaBarFrame, "CENTER", 0, 0);
            end

            Buff_Y = ns.ANameP_PlayerBuffY;

            if Buff_Y < 0 then
                asframe.downbuff = true;
                if GetCVar("nameplateResourceOnTarget") == "0" then
                    playerbuffposition = Buff_Y - GetClassBarHeight();
                else
                    playerbuffposition = Buff_Y;
                end
            end
            checkaura = true;
            asframe:Show();
        else
            checkaura = false;
            asframe:Hide();
        end
    else
        if UnitIsPlayer(unit) and ANameP_HealerGuid[UnitGUID(unit)] then
            showhealer = true;
        end

        if UnitIsPlayer(unit) then
            checkpvptarget = true;
        else
            checkcolor = true;
        end
        checkaura = true;
        unitFrame.BuffFrame:SetAlpha(0);
        unitFrame.BuffFrame:Hide();

        unitFrame:UnregisterEvent("UNIT_THREAT_SITUATION_UPDATE");
        unitFrame:UnregisterEvent("UNIT_THREAT_LIST_UPDATE");
        unitFrame:UnregisterEvent("UNIT_AURA");
        asframe:Show();
    end

    asframe.checkaura = checkaura;
    asframe.checkpvptarget = checkpvptarget;
    asframe.checkcolor = checkcolor;

    if showhealer and ns.ANameP_HealerSize > 0 then
        asframe.healer:Show();
    else
        asframe.healer:Hide();
    end


    if UnitIsPlayer(unit) then
        unit_guid_list[UnitGUID(unit)] = unit;
    end
end


local function updateHealerMark(guid)
    local unit = unit_guid_list[guid];

    if unit and ANameP_HealerGuid[guid] and not UnitIsUnit(unit, "player") then
        local nameplate = C_NamePlate.GetNamePlateForUnit(unit, issecure());
        if (nameplate and nameplate.asNamePlates ~= nil and not nameplate:IsForbidden() and
                nameplate.asNamePlates.checkpvptarget) then
            nameplate.asNamePlates.healer:Show();
        end
    end
end

local function asCompactUnitFrame_UpdateNameFaction(namePlateUnitToken)
    local namePlateFrameBase = C_NamePlate.GetNamePlateForUnit(namePlateUnitToken, issecure());
    if namePlateFrameBase and not namePlateFrameBase:IsForbidden() then
        addNamePlate(namePlateFrameBase);
        if namePlateFrameBase.asNamePlates ~= nil then
            updateTargetNameP(namePlateFrameBase.asNamePlates);
            updateUnitAuras(namePlateUnitToken);
            updateHealthbarColor(namePlateFrameBase.asNamePlates);
        end
    end
end

local bfirst = true;

local function setupFriendlyPlates()
    local isInstance, instanceType = IsInInstance();
    if bfirst and not isInstance and not InCombatLockdown() then
        C_NamePlate.SetNamePlateFriendlySize(60, 30);
        bfirst = false;
    end
end

local function ANameP_OnEvent(self, event, ...)
    local arg1 = ...;
    if event == "NAME_PLATE_CREATED" then
        local namePlateFrameBase = ...;
        createNamePlate(namePlateFrameBase);
    elseif event == "NAME_PLATE_UNIT_ADDED" then
        local namePlateUnitToken = ...;
        local namePlateFrameBase = C_NamePlate.GetNamePlateForUnit(namePlateUnitToken, issecure());

        if namePlateFrameBase then
            addNamePlate(namePlateFrameBase);
            if namePlateFrameBase.asNamePlates ~= nil then
                updateTargetNameP(namePlateFrameBase.asNamePlates);
                updateUnitAuras(namePlateUnitToken);
                updateUnitHealthText("target");
                updateUnitHealthText("player");
                checkSpellCasting(namePlateFrameBase.asNamePlates);
                updateHealthbarColor(namePlateFrameBase.asNamePlates);
            end
        end
    elseif event == "NAME_PLATE_UNIT_REMOVED" then
        local namePlateUnitToken = ...;

        local namePlateFrameBase = C_NamePlate.GetNamePlateForUnit(namePlateUnitToken, issecure());
        if namePlateFrameBase then
            removeNamePlate(namePlateFrameBase);
        end
    elseif event == "UNIT_SPELLCAST_SUCCEEDED" and arg1 == "player" then
        updateUnitAuras("target");
        updateUnitAuras("player");
        updateUnitHealthText("target");
    elseif event == "PLAYER_TARGET_CHANGED" then
        updateUnitAuras("target");
        updateUnitHealthText("target");
    elseif (event == "TRAIT_CONFIG_UPDATED") or (event == "TRAIT_CONFIG_LIST_UPDATED") or
        (event == "ACTIVE_TALENT_GROUP_CHANGED") then
        setupKnownSpell();
        C_Timer.After(0.5, initAlertList);
    elseif (event == "PLAYER_ENTERING_WORLD") then
        local isInstance, instanceType = IsInInstance();
        if isInstance and (instanceType == "party" or instanceType == "raid" or instanceType == "scenario") then
            self:UnregisterEvent("COMBAT_LOG_EVENT_UNFILTERED");
        else
            self:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED");
        end
        updateTankerList();
        setupKnownSpell();
        -- 0.5 초 뒤에 Load
        C_Timer.After(0.5, initAlertList);
        C_Timer.After(0.5, setupFriendlyPlates);
    elseif event == "COMBAT_LOG_EVENT_UNFILTERED" then
        local _, eventType, _, sourceGUID, _, _, _, destGUID, _, _, _, spellID, _, _, auraType =
            CombatLogGetCurrentEventInfo();
        if eventType == "SPELL_CAST_SUCCESS" and sourceGUID and not (sourceGUID == "") then
            local className = GetPlayerInfoByGUID(sourceGUID);
            if className and ns.ANameP_HealSpellList[className] and ns.ANameP_HealSpellList[className][spellID] then
                ANameP_HealerGuid[sourceGUID] = true;
                updateHealerMark(sourceGUID);
            end
        end
    elseif (event == "UNIT_FACTION") then
        local namePlateUnitToken = ...;
        asCompactUnitFrame_UpdateNameFaction(namePlateUnitToken);
    elseif (event == "GROUP_JOINED" or event == "GROUP_ROSTER_UPDATE" or event == "PLAYER_ROLES_ASSIGNED") then
        updateTankerList();
    elseif event == "PLAYER_REGEN_ENABLED" then
        setupFriendlyPlates();
    end
end

local function updateUnitResourceText()
    local value;
    local valueMax;
    local valuePct;
    local unit = "player"
    local frame;
    local pframe = C_NamePlate.GetNamePlateForUnit("player", issecure())

    if not pframe or pframe.asNamePlates == nil then
        return;
    else
        frame = pframe.asNamePlates.resourcetext;
    end

    if frame == nil then
        return;
    end

    value = UnitPower(unit);
    valueMax = UnitPowerMax(unit);

    if valueMax > 0 then
        valuePct = (math.ceil((value / valueMax) * 100));
    end

    if (valueMax <= 300) then
        valuePct = value;
    end

    if valuePct > 0 then
        frame:SetText(valuePct);
    else
        frame:SetText("");
    end

    if valuePct > 0 then
        frame:SetTextColor(1, 1, 1, 1);
    end

    frame:Show();
end

local function ANameP_OnUpdate()
    updateUnitHealthText("target");
    updateUnitHealthText("player");
    updateUnitResourceText();

    for _, v in pairs(C_NamePlate.GetNamePlates(issecure())) do
        local nameplate = v;

        if (nameplate and nameplate.asNamePlates ~= nil and not nameplate:IsForbidden()) then
            if nameplate.asNamePlates.checkaura then
                updateAuras(nameplate.asNamePlates, nameplate.namePlateUnitToken);
            else
                nameplate.asNamePlates:Hide();
            end

            if nameplate.asNamePlates.checkpvptarget or nameplate.asNamePlates.namecolor then
                updatePVPAggro(nameplate.asNamePlates);
            end
            checkSpellCasting(nameplate.asNamePlates);
            updateHealthbarColor(nameplate.asNamePlates);
        end
    end
end

local function flushoption()
    ns.options = CopyTable(ANameP_Options);
    C_Timer.After(0.5, initAlertList);
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

local function initAddon()
    ANameP = CreateFrame("Frame", nil, UIParent)

    ANameP:RegisterEvent("NAME_PLATE_CREATED");
    ANameP:RegisterEvent("NAME_PLATE_UNIT_ADDED");
    ANameP:RegisterEvent("NAME_PLATE_UNIT_REMOVED");
    -- 나중에 추가 처리가 필요하면 하자.
    -- ANameP:RegisterEvent("FORBIDDEN_NAME_PLATE_UNIT_ADDED");
    -- ANameP:RegisterEvent("FORBIDDEN_NAME_PLATE_UNIT_REMOVED");
    ANameP:RegisterEvent("PLAYER_TARGET_CHANGED");
    ANameP:RegisterEvent("PLAYER_ENTERING_WORLD");
    ANameP:RegisterEvent("ADDON_LOADED")
    ANameP:RegisterEvent("TRAIT_CONFIG_UPDATED");
    ANameP:RegisterEvent("TRAIT_CONFIG_LIST_UPDATED");
    ANameP:RegisterEvent("ACTIVE_TALENT_GROUP_CHANGED");
    ANameP:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED");
    ANameP:RegisterEvent("UNIT_FACTION");
    ANameP:RegisterUnitEvent("UNIT_SPELLCAST_SUCCEEDED", "player");
    ANameP:RegisterEvent("GROUP_JOINED");
    ANameP:RegisterEvent("GROUP_ROSTER_UPDATE");
    ANameP:RegisterEvent("PLAYER_ROLES_ASSIGNED");
    ANameP:RegisterEvent("PLAYER_REGEN_ENABLED");

    ANameP:SetScript("OnEvent", ANameP_OnEvent)
    -- 주기적으로 Callback
    C_Timer.NewTicker(ns.ANameP_UpdateRate, ANameP_OnUpdate);

    hooksecurefunc("DefaultCompactNamePlateFrameAnchorInternal", function(frame, setupOptions)
        if (frame:IsForbidden()) then
            return;
        end

        local pframe = C_NamePlate.GetNamePlateForUnit("target", issecure())

        if pframe and pframe.asNamePlates ~= nil and frame.unit and UnitIsUnit(frame.unit, "target") then
            updateTargetNameP(pframe.asNamePlates);
        end
    end)

    ANameP_OptionM.RegisterCallback(flushoption);

    local bloaded = LoadAddOn("DBM-Core");
    if bloaded then
        hooksecurefunc(DBM, "NewMod", NewMod)
    end

    bloadedAutoMarker = LoadAddOn("asAutoMarker");
end

initAddon();
