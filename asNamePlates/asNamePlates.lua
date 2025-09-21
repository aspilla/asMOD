---@diagnostic disable: undefined-field
local _, ns = ...;

local CONFIG_NOT_INTERRUPTIBLE_COLOR = { r = 0.9, g = 0.9, b = 0.9 };                 --차단 불가시 (내가 아닐때) 색상 (r, g, b)
local CONFIG_NOT_INTERRUPTIBLE_COLOR_TARGET = { r = 153 / 255, g = 0, b = 76 / 255 }; --차단 불가시 (내가 타겟일때) 색상 (r, g, b)
local CONFIG_INTERRUPTIBLE_COLOR = { r = 204 / 255, g = 255 / 255, b = 153 / 255 };   --차단 가능(내가 타겟이 아닐때)시 색상 (r, g, b)
local CONFIG_INTERRUPTIBLE_COLOR_TARGET = { r = 76 / 255, g = 153 / 255, b = 0 };     --차단 가능(내가 타겟일 때)시 색상 (r, g, b)

local targetIcon = CreateAtlasMarkup("poi-door-arrow-down", 16, 16, 0, 0, 255, 0, 0);
local mouseoverIcon = CreateAtlasMarkup("poi-door-arrow-up", 12, 12, 0, 0, 0, 255, 0);
local focusIcon = CreateAtlasMarkup("Vehicle-TempleofKotmogu-GreenBall", 12, 12, 0, 0);
local healerIcon = CreateAtlasMarkup("GreenCross", 12, 12, 0, 0);
local aggroIconR = CreateAtlasMarkup("QuestLegendary", 16, 16, 0, 0, 255, 0, 0);
local aggroIcon = CreateAtlasMarkup("QuestLegendary", 16, 16, 0, 0);
local petcleaveIcon = CreateAtlasMarkup("WildBattlePetCapturable", 10, 10, 0, 0);
local pettargetIcon = CreateAtlasMarkup("WildBattlePetCapturable", 10, 10, 0, 0, 255, 0, 0);
local snapshotIconG = CreateAtlasMarkup("PlayerPartyBlip", 20, 20, 0, 0, 100, 255, 100);
local snapshotIconR = CreateAtlasMarkup("PlayerPartyBlip", 20, 20, 0, 0, 255, 100, 100);

ns.DangerousSpellList = {};

local ANameP_HealerGuid = {}

local ANameP = CreateFrame("Frame", nil, UIParent);
local tanklist = {}

local PLAYER_UNITS = {
    player = true,
    vehicle = true,
    pet = true
};

local lowhealthpercent = 0;
local highhealthpercent = 200;
local playerisdealer = false;

ns.ANameP_ShowList = nil;
local playerbuffposition = ns.ANameP_PlayerBuffY;
ns.options = CopyTable(ANameP_Options_Default);

local bcheckHealer = false;
local bcheckBeastCleave = false;
local cleavedunits = {};
local lastcleavetime = 0;
local isparty = false;
local israid = false;
local ispvp = false;
local isinstance = false;


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

local MaxLevel = GetMaxLevelForExpansionLevel(10);


-- Cooldown
local function asCooldownFrame_Clear(cooldown)
    cooldown:Clear();
end
-- cooldown
local function asCooldownFrame_Set(cooldown, start, duration, enable, forceShowDrawEdge, modRate)
    if enable and enable ~= 0 and start > 0 and duration > 0 then
        cooldown:SetDrawEdge(forceShowDrawEdge);
        cooldown:SetCooldown(start, duration, modRate);
    else
        asCooldownFrame_Clear(cooldown);
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


local function scanSpells(tab)
    local tabName, tabTexture, tabOffset, numEntries = asGetSpellTabInfo(tab)

    if not tabName then
        return;
    end

    for i = tabOffset + 1, tabOffset + numEntries do
        local spellName = C_SpellBook.GetSpellBookItemName(i, Enum.SpellBookSpellBank.Player)

        if not spellName then
            do
                break
            end
        end
        local slotType, actionID, spellID = C_SpellBook.GetSpellBookItemType(i, Enum.SpellBookSpellBank.Player);

        if spellName and spellID then
            ns.KnownSpellList[spellName] = 1;
        end
    end
end

local function scanPetSpells()
    for i = 1, 20 do
        local spellName = C_SpellBook.GetSpellBookItemName(i, Enum.SpellBookSpellBank.Pet)

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

    scanSpells(1);
    scanSpells(2);
    scanSpells(3);
    scanPetSpells();
end

-- 탱커 처리부
local function updateTankerList()
    playerisdealer = false;

    if ispvp then
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

        local assignedRole = UnitGroupRolesAssigned("player");

        if (assignedRole and assignedRole ~= "TANK") then
            playerisdealer = true;
        end
    end
end


local function setFrame(frame, texture, count, expirationTime, duration, color)
    local data = frame.data;

    if (texture ~= data.icon) or
        (count ~= data.applications) or
        (expirationTime ~= data.expiration) or
        (duration ~= data.duration) then
        frame.data = {
            icon = texture,
            applications = count,
            expiration = expirationTime,
            duration = duration,
        };

        local frameIcon = frame.icon;
        frameIcon:SetTexture(texture);

        local frameCount = frame.count;
        local frameCooldown = frame.cooldown;

        if count and (count > 1) then
            frameCount:SetText(count);
            frameCount:Show();
        else
            frameCount:Hide();
        end

        asCooldownFrame_Set(frameCooldown, expirationTime - duration, duration, duration > 0, true);
        if ns.ANameP_CooldownFontSize > 0 then
            frameCooldown:SetHideCountdownNumbers(false);
        end

        local frameBorder = frame.border;
        frameBorder:SetVertexColor(color.r, color.g, color.b);
    end
end

local function setSize(frame, size)
    frame:SetWidth(size + 2);
    frame:SetHeight((size + 2) * ns.ANameP_Size_Rate);
end


local function updateAuras(asframe)
    local numDebuffs = 1;
    local parent = asframe.nameplateBase;
    local healthBar = parent.UnitFrame.healthBar;
    local bShowCC = false;
    local auraData;
    local icon_size = asframe.icon_size;
    local unit = asframe.unit;
    local guid = asframe.guid;


    if not asframe.checkaura then
        asframe:Hide();
        return;
    end

    if not unit then
        return
    end

    if (parent.UnitFrame.BuffFrame and parent.UnitFrame.BuffFrame:GetAlpha() > 0 and parent.UnitFrame.BuffFrame.Hide) then
        parent.UnitFrame.BuffFrame:SetAlpha(0);
        parent.UnitFrame.BuffFrame:Hide();
        parent.UnitFrame:UnregisterEvent("UNIT_AURA");
    end

    auraData = ns.getAurasFromQ(unit);

    if auraData and auraData.type == 2 then
        auraData.buffs:Iterate(function(auraInstanceID, aura)
            if numDebuffs > ns.ANameP_MaxDebuff then
                return true;
            end


            local frame = asframe.buffList[numDebuffs];
            frame.alert = false;

            setSize(frame, icon_size);

            local color = DebuffTypeColor["Disease"];
            setFrame(frame, aura.icon, aura.applications, aura.expirationTime, aura.duration, color);

            frame.filter = auraData.bufffilter;
            frame.type = 1;
            frame:SetID(auraInstanceID);
            frame.unit = unit;

            frame:SetMouseMotionEnabled(ns.options.ANameP_Tooltip);

            numDebuffs = numDebuffs + 1;
            return false;
        end);
    elseif auraData and auraData.type == 1 then
        auraData.buffs:Iterate(function(auraInstanceID, aura)
            if numDebuffs > ns.ANameP_MaxBuff then
                return true;
            end

            local frame = asframe.buffList[numDebuffs];
            frame.alert = false;
            local size = icon_size;

            if aura.debuffType == ns.UnitFrameBuffType.PVP then
                size = icon_size + 2;
            end

            setSize(frame, size);

            local color = {
                r = 1,
                g = 1,
                b = 1
            };
            setFrame(frame, aura.icon, aura.applications, aura.expirationTime, aura.duration, color);
            if aura.isStealable then
                frame.alert = true;
            end

            frame.filter = auraData.bufffilter;
            frame.type = 1;
            frame:SetID(auraInstanceID);
            frame.unit = unit;
            frame:SetMouseMotionEnabled(ns.options.ANameP_Tooltip);

            numDebuffs = numDebuffs + 1;
            return false;
        end);

        asframe.debuffColor = 0;
        asframe.checkdebuffColor1 = false;
        asframe.checkdebuffColor2 = false;

        auraData.debuffs:Iterate(function(auraInstanceID, aura)
            local isshowlist = false;
            if numDebuffs > ns.ANameP_MaxDebuff then
                return true;
            end

            local showlist = aura.showlist;

            if ns.ANameP_ShowCCDebuff and bShowCC == false and aura.nameplateShowAll and aura.duration > 0 and aura.duration <= 10 and not (showlist) then
                bShowCC = true;

                local color = {
                    r = 0.3,
                    g = 0.3,
                    b = 0.3
                };

                setFrame(asframe.CCdebuff, aura.icon, aura.applications, aura.expirationTime, aura.duration, color);

                asframe.CCdebuff:ClearAllPoints();
                if asframe.casticon:IsShown() then
                    asframe.CCdebuff:SetPoint("LEFT", asframe.casticon, "RIGHT", 1, 0);
                else
                    asframe.CCdebuff:SetPoint("LEFT", healthBar, "RIGHT", 1, 0);
                end
                asframe.CCdebuff.filter = auraData.debufffilter;
                asframe.CCdebuff:SetID(auraInstanceID);
                asframe.CCdebuff.unit = unit;

                asframe.CCdebuff:Show();
            else
                local alert = false;
                local showlist_time = nil;
                local frame = asframe.buffList[numDebuffs];

                if showlist then
                    isshowlist = true
                    showlist_time = showlist[1];
                    local alertnameplate = showlist[3] or 0;
                    local alertcount = showlist[4] or false;
                    local checksnapshot = showlist[5] or false;

                    if showlist_time == 1 then
                        showlist_time = aura.duration * 0.3;
                        showlist[1] = showlist_time;
                    end

                    if showlist_time and showlist_time >= 0 and alertcount == false then
                        local alert_time = aura.expirationTime - showlist_time;

                        if (GetTime() >= alert_time) and aura.duration > 0 and showlist_time > 0 then
                            alert = true;
                        else
                            if alertnameplate then
                                if alertnameplate == 1 and asframe.checkdebuffColor1 == false then
                                    asframe.debuffColor = asframe.debuffColor + alertnameplate;
                                    asframe.checkdebuffColor1 = true;
                                elseif alertnameplate == 2 and asframe.checkdebuffColor2 == false then
                                    asframe.debuffColor = asframe.debuffColor + alertnameplate;
                                    asframe.checkdebuffColor2 = true;
                                end
                            end
                        end
                    elseif showlist_time and showlist_time >= 0 and alertcount then
                        if (aura.applications >= showlist_time) then
                            alert = true;
                            if alertnameplate then
                                if alertnameplate == 1 and asframe.checkdebuffColor1 == false then
                                    asframe.debuffColor = asframe.debuffColor + alertnameplate;
                                    asframe.checkdebuffColor1 = true;
                                elseif alertnameplate == 2 and asframe.checkdebuffColor2 == false then
                                    asframe.debuffColor = asframe.debuffColor + alertnameplate;
                                    asframe.checkdebuffColor2 = true;
                                end
                            end
                        end
                    end

                    if checksnapshot and asDotSnapshot and asDotSnapshot.Relative then
                        local snapshots = asDotSnapshot.Relative(guid, aura.spellId) or 1;

                        if snapshots then
                            if snapshots > 1 then
                                frame.snapshot:SetText(snapshotIconG);
                                frame.snapshot:Show();
                            elseif snapshots == 1 then
                                frame.snapshot:Hide();
                            else
                                frame.snapshot:SetText(snapshotIconR);
                                frame.snapshot:Show();
                            end
                        else
                            frame.snapshot:Hide();
                        end
                        --print("working")
                    else
                        frame.snapshot:Hide();
                    end
                else
                    frame.snapshot:Hide();
                end

                frame.alert = false;

                local size = icon_size;

                if aura.nameplateShowAll and not isshowlist and aura.duration > 0 and aura.duration <= 10 then
                    size = icon_size + ns.ANameP_PVP_Debuff_Size_Rate;
                end

                setSize(frame, size);

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

                setFrame(frame, aura.icon, aura.applications, aura.expirationTime, aura.duration,
                    color);

                if alert and aura.duration > 0 then
                    frame.alert = true;
                end
                frame.filter = auraData.debufffilter;
                frame.type = 2;
                frame:SetID(auraInstanceID);
                frame.unit = unit;
                frame:SetMouseMotionEnabled(ns.options.ANameP_Tooltip);

                numDebuffs = numDebuffs + 1;
            end

            return false;
        end);
    end

    for i = 1, numDebuffs - 1 do
        local frame = asframe.buffList[i];
        if (frame) then
            frame:Show();
            if frame.alert then
                ns.lib.ButtonGlow_Start(frame);
            else
                ns.lib.ButtonGlow_Stop(frame);
            end
        end
    end

    for i = numDebuffs, ns.ANameP_MaxDebuff do
        local frame = asframe.buffList[i];
        if (frame) then
            frame:Hide();
            ns.lib.ButtonGlow_Stop(frame);
        end
    end

    if numDebuffs > 1 then
        asframe:Show();
    end

    if bShowCC == false then
        asframe.CCdebuff:Hide();
    end
end


local function updateDebuffAnchor(frames, index, parent, anchor, offset)
    local buff = frames[index];

    buff:ClearAllPoints();

    if parent.downbuff then
        if (index == 1) then
            buff:SetPoint("TOPLEFT", anchor, "BOTTOMLEFT", 0, offset);
        elseif (index == (ns.ANameP_DebuffsPerLine + 1)) then
            buff:SetPoint("TOPLEFT", frames[1], "BOTTOMLEFT", 0, -4);
        else
            buff:SetPoint("BOTTOMLEFT", frames[index - 1], "BOTTOMRIGHT", 1, 0);
        end
    else
        if ns.options.ANameP_DebuffAnchorPoint == 2 then
            if (index == 1) then
                buff:SetPoint("RIGHT", anchor, "LEFT", offset, 0);
            else
                buff:SetPoint("RIGHT", frames[index - 1], "LEFT", -1, 0);
            end
        elseif ns.options.ANameP_DebuffAnchorPoint == 3 then
            if (index == 1) then
                buff:SetPoint("RIGHT", UIParent, "LEFT", -100, 0);
            else
                buff:SetPoint("RIGHT", frames[index - 1], "LEFT", -1, 0);
            end
        else
            if (index == 1) then
                buff:SetPoint("BOTTOMLEFT", anchor, "TOPLEFT", 0, offset);
            elseif (index == (ns.ANameP_DebuffsPerLine + 1)) then
                buff:SetPoint("BOTTOMLEFT", frames[1], "TOPLEFT", 0, 4);
            else
                buff:SetPoint("BOTTOMLEFT", frames[index - 1], "BOTTOMRIGHT", 1, 0);
            end
        end
    end
end

local function updateTargetNameP(asframe)
    if not asframe.unit or not asframe.checkaura then
        return;
    end

    local unit = asframe.unit;
    local parent = asframe.nameplateBase;

    if not parent or not parent.UnitFrame or parent.UnitFrame:IsForbidden() then
        return;
    end

    local UnitFrame = parent.UnitFrame;
    local healthBarContainer = UnitFrame.HealthBarsContainer;

    if not healthBarContainer then
        return;
    end

    local orig_height = asframe.orig_height
    local cast_height = 8;

    if UnitFrame.castBar then
        cast_height = UnitFrame.castBar:GetHeight();
    end

    if orig_height == nil then
        return;
    end

    local casticon = asframe.casticon;
    local height = orig_height;
    local width = asframe.orig_width;
    local base_y = ns.ANameP_TargetBuffY;

    if UnitFrame.name:IsShown() then
        base_y = base_y + UnitFrame.name:GetHeight();
    end

    if UnitIsUnit(unit, "target") then
        height = orig_height + ns.ANameP_TargetHealthBarHeight;
        asframe.healthtext:Show();

        local guid_mouseover = UnitGUID("mouseover")

        if asframe.guid == guid_mouseover then
            asframe.motext:Show();
        else
            asframe.motext:Hide();
        end

        if ns.options.ANameP_ShowTargetArrow then
            asframe.tgtext:Show();
        end

        if casticon then
            casticon:SetWidth((height + cast_height + 3) * 1.1); --90%
            casticon:SetHeight(height + cast_height + 3);
            casticon.border:SetVertexColor(1, 1, 1);
        end

        asframe:SetHeight(height + cast_height + 3);
        asframe:SetWidth(width + ((height + cast_height + 3) * 1.1) + 7);

        if GetCVarBool("nameplateResourceOnTarget") then
            base_y = base_y + 10;
        end

        asframe.powerbar.value:Show();
    elseif UnitIsUnit(unit, "player") then
        height = orig_height + ns.ANameP_TargetHealthBarHeight;
        asframe.healthtext:Show();
        asframe.motext:Hide();
        asframe.tgtext:Hide();
    else
        height = orig_height;

        local guid_mouseover = UnitGUID("mouseover")

        if asframe.guid == guid_mouseover then
            height = orig_height + ns.ANameP_TargetHealthBarHeight;
            asframe.healthtext:Show();
            asframe.motext:Show();
            asframe.powerbar.value:Show();
        else
            asframe.healthtext:Hide();
            asframe.motext:Hide();
            asframe.powerbar.value:Hide();
        end

        asframe.tgtext:Hide();

        if casticon then
            casticon:SetWidth((height + cast_height + 3) * 1.1);
            casticon:SetHeight(height + cast_height + 3);
            casticon.border:SetVertexColor(0, 0, 0);
        end

        asframe:SetHeight(height + cast_height + 3);
        asframe:SetWidth(width + ((height + cast_height + 3) * 1.1) + 7);

        if UnitFrame.name:IsShown() then
            base_y = base_y + 4;
        end
    end

    if ns.options.ANameP_DebuffAnchorPoint == 2 and not UnitIsUnit(unit, "player") then
        local xoffset = -5;
        if GetRaidTargetIndex(unit) then
            xoffset = -5 - 22;
        end
        updateDebuffAnchor(asframe.buffList, 1, asframe, asframe.aggro, xoffset);
    else
        local yoffset = base_y;
        if UnitIsUnit(unit, "player") and asframe.downbuff then
            yoffset = playerbuffposition - 5;
        end
        updateDebuffAnchor(asframe.buffList, 1, asframe, healthBarContainer, yoffset);
    end

    if UnitIsUnit(unit, "focus") then
        asframe.focus_indi:Show();
    else
        asframe.focus_indi:Hide();
    end

    if ns.options.ANameP_ShowPetTarget then
        if UnitIsUnit(unit, "pettarget") then
            asframe.pettarget:Show();
        else
            asframe.pettarget:Hide();
        end
    end

    -- Healthbar 크기
    healthBarContainer:SetHeight(height);


    if UnitFrame.BuffFrame then
        UnitFrame.BuffFrame:Hide();
    end
end


local function updateUnitRealHealthText(asframe)
    local value;
    local unit = asframe.unit;

    if not ns.options.ANameP_RealHealth then
        return;
    end

    if not unit or not UnitExists(unit) then
        return;
    end

    value = UnitHealth(unit);

    if value > 0 then
        local valueshow = AbbreviateLargeNumbers(value);
        asframe.realhealthtext:SetText(valueshow);
        asframe.realhealthtext:Show();
    else
        asframe.realhealthtext:SetText("");
    end
end

local function updateHealthText(asframe)
    local value;
    local valueMax;
    local valuePct;
    local unit = asframe.unit;

    if not asframe.healthtext:IsShown() then
        return;
    end

    value = UnitHealth(unit);
    valueMax = UnitHealthMax(unit);

    if valueMax > 0 then
        valuePct = (math.ceil((value / valueMax) * 100));
    end

    if valuePct > 0 then
        asframe.healthtext:SetText(valuePct);
    else
        asframe.healthtext:SetText("");
    end

    if valuePct <= lowhealthpercent or valuePct >= highhealthpercent then
        asframe.healthtext:SetTextColor(1, 0.5, 0.5, 1);
    elseif valuePct > 0 then
        asframe.healthtext:SetTextColor(1, 1, 1, 1);
    end
end

local function updatePower(asframe)
    local power;
    local maxPower;
    local unit = asframe.unit;

    if not asframe.bupdatePower then
        return;
    end

    power = UnitPower(unit);
    maxPower = UnitPowerMax(unit);
    asframe.powerbar:SetMinMaxValues(0, maxPower);
    asframe.powerbar:SetValue(power);
    asframe.powerbar.value:SetText(power);

    if power > 0 then
        asframe.powerbar:Show();
    else
        asframe.powerbar:Hide();
    end
end

-- Healthbar 색상 처리부
local function setColoronStatusBar(asframe, r, g, b)
    local parent = asframe.nameplateBase;

    if not parent or not parent.UnitFrame or parent.UnitFrame:IsForbidden() or not asframe.BarColor then
        return;
    end

    local oldR, oldG, oldB = asframe.BarColor:GetVertexColor();

    if r and g and b and (r ~= oldR or g ~= oldG or b ~= oldB) then
        asframe.BarColor:SetVertexColor(r, g, b);
    end

    asframe.BarTexture:Hide();
    asframe.BarColor:Show();
end

local function isDangerousSpell(spellId)
    if spellId and ns.DangerousSpellList[spellId] then
        if ns.DangerousSpellList[spellId] == "interrupt" then
            return true, true;
        end
        return true, false;
    end
    return false, false;
end

local bloadedAutoMarker = false;

local function getNPCID(guid)
    if guid then
        local npcID = select(6, strsplit("-", guid));
        npcID = tonumber(npcID);
        return npcID;
    end

    return nil;
end

local function updateHealthbarColor(asframe)
    -- unit name 부터
    if not asframe.unit or not asframe.checkcolor or not asframe.BarColor or not asframe.BarTexture then
        return;
    end

    local unit = asframe.unit;
    local parent = asframe.nameplateBase;

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
            local spec = C_SpecializationInfo.GetSpecialization();
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

    local status = UnitThreatSituation("player", unit);
    local incombat = UnitAffectingCombat(unit);
    local tanker = IsPlayerEffectivelyTank();
    local isTanking = IsTanking();
    local isTargetPlayer = UnitIsUnit(unit .. "target", "player");
    local isTargetPet = UnitIsUnit(unit .. "target", "pet");
    local CastingAlertColor = nil;
    local alerttype = 0;


    -- Cast Interrupt
    if asframe.castspellid and asframe.casticon and incombat then
        local name, text, texture, startTime, endTime, isTradeSkill, castID, notInterruptible, spellid =
            UnitCastingInfo(unit);
        if not name then
            name, text, texture, startTime, endTime, isTradeSkill, notInterruptible, spellid = UnitChannelInfo(unit);
        end

        if spellid then
            local isDanger, binterrupt = isDangerousSpell(spellid);
            if notInterruptible and asframe.stunable == false then
                binterrupt = false;
            end

            asframe.castspellid = spellid;
            if isDanger then
                if binterrupt then
                    alerttype = 2;
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
                alerttype = 1;
            end
        end
    end

    if ns.options.ANameP_ShowDBMCastingColor == false then
        CastingAlertColor = nil;
    end

    local function getColor()
        local color;

        if UnitIsPlayer(unit) then
            return nil;
        end

        if asframe.namecolor == nil then
            local npcid = getNPCID(asframe.guid);
            local npccolor = ns.ANameP_AlertList[npcid];
            asframe.namecolor = npccolor;
        end

        if asframe.namecolor then
            color = {
                r = asframe.namecolor[1],
                g = asframe.namecolor[2],
                b = asframe.namecolor[3]
            };

            if asframe.namecolor[4] == 1 then
                alerttype = 3;
            end

            return color;
        end


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

            if valuePct >= highhealthpercent and UnitAffectingCombat(unit) then
                return ns.options.ANameP_LowHealthColor;
            end
        end

        -- Debuff Color
        if asframe.debuffColor > 0 then
            if asframe.debuffColor == 1 then
                return ns.options.ANameP_DebuffColor;
            elseif asframe.debuffColor == 2 then
                return ns.options.ANameP_DebuffColor2;
            elseif asframe.debuffColor > 2 then
                return ns.options.ANameP_DebuffColor3;
            end
        end
        -- 정상 Tanking
        if ns.options.ANameP_AggroShow and incombat then
            if (isTargetPlayer) then
                return ns.options.ANameP_AggroTargetColor;
            elseif (isTargetPet) then
                return ns.options.ANameP_TankAggroLoseColor3;
            elseif isTanking and tanker then
                return ns.options.ANameP_TankAggroLoseColor2;
            elseif status and status > 0 then
                return ns.options.ANameP_AggroColor;
            end
        end

        if asframe.isboss then
            return ns.options.ANameP_BossColor;
        end

        if ns.options.ANameP_AggroShow and incombat then
            if isTanking then
                return ns.options.ANameP_TankAggroLoseColor2;
            elseif status then
                return ns.options.ANameP_TankAggroLoseColor;
            end
        end

        if ns.options.ANameP_QuestAlert and not (isparty or israid) and C_QuestLog.UnitIsRelatedToActiveQuest(unit) then
            return ns.options.ANameP_QuestColor;
        end

        if asframe.automarkcolor then
            return asframe.automarkcolor;
        end

        return nil;
    end

    if bcheckBeastCleave then
        local currtime = GetTime();
        local guid = asframe.guid;
        local cleavetime = cleavedunits[guid];
        if cleavetime and currtime - cleavetime < 1.5 then
            if asframe.debuffColor == 1 then
                asframe.debuffColor = 3;
            elseif asframe.debuffColor == 0 then
                asframe.debuffColor = 2;
            end
            asframe.petcleave:Show();
        else
            asframe.petcleave:Hide();
        end
    end

    local color = getColor();

    if color then
        setColoronStatusBar(asframe, color.r, color.g, color.b);
    else
        asframe.BarColor:Hide();
        asframe.BarTexture:Show();
    end

    if alerttype ~= asframe.alerttype then
        if alerttype == 3 then
            ns.lib.PixelGlow_Start(healthBar, nil, nil, nil, nil, nil, 2, 2, nil, nil, 1000);
            ns.lib.PixelGlow_Stop(asframe.casticon);
            ns.lib.PixelGlow_Stop(asframe);
        elseif alerttype == 2 then
            ns.lib.PixelGlow_Start(asframe, { 1, 1, 0, 1 }, 16, nil, 5, 2, nil, nil, nil, nil, 1000);
            ns.lib.PixelGlow_Stop(asframe.casticon);
            ns.lib.PixelGlow_Stop(healthBar);
        elseif alerttype == 1 then
            ns.lib.PixelGlow_Start(asframe.casticon);
            ns.lib.PixelGlow_Stop(asframe);
            ns.lib.PixelGlow_Stop(healthBar);
        else
            ns.lib.PixelGlow_Stop(asframe.casticon);
            ns.lib.PixelGlow_Stop(asframe);
            ns.lib.PixelGlow_Stop(healthBar);
        end
        asframe.alerttype = alerttype;
    end
end


local function updatePVPAggro(asframe)
    if not ns.ANameP_PVPAggroShow then
        return;
    end

    if not (asframe.namecolor or asframe.checkpvptarget or asframe.partydealer) then
        return;
    end

    if not asframe.unit then
        return
    end

    local unit = asframe.unit;
    local parent = asframe.nameplateBase;

    if parent.UnitFrame:IsForbidden() then
        return;
    end

    local isTargetPlayer = UnitIsUnit(unit .. "target", "player");

    if (isTargetPlayer) then
        if asframe.markcolor and asframe.markcolor == 1 then
            asframe.aggro:SetText(aggroIconR);
            asframe.aggro:Show();
            asframe.markcolor = 0;
        else
            asframe.aggro:SetText(aggroIcon);
            asframe.aggro:Show();
            asframe.markcolor = 1;
        end
    else
        asframe.aggro:SetText("");
        asframe.aggro:Hide();
    end
end

local function initAlertList()
    local spec = C_SpecializationInfo.GetSpecialization();
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
    highhealthpercent = 200;


    if ns.options.ANameP_LowHealthAlert then
        if (englishClass == "MAGE") then
            if (C_SpellBook.IsSpellKnown(2948)) then
                lowhealthpercent = 30;
            end

            if (C_SpellBook.IsSpellKnown(384581)) then
                lowhealthpercent = 35;
            end
        end

        if (englishClass == "HUNTER") then
            if (C_SpellBook.IsSpellKnown(53351)) then
                lowhealthpercent = 20;
            end

            if (C_SpellBook.IsSpellKnown(466932)) then
                highhealthpercent = 80;
            end

            if (C_SpellBook.IsSpellKnown(115939)) and ns.options.ANameP_ShowPetTarget then
                bcheckBeastCleave = true;
                ANameP:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED");
            else
                bcheckBeastCleave = false;
                if not bcheckHealer then
                    ANameP:UnregisterEvent("COMBAT_LOG_EVENT_UNFILTERED");
                end
            end
        end

        if (englishClass == "WARRIOR") then
            if (C_SpellBook.IsSpellKnown(281001)) then
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
            if (C_SpellBook.IsSpellKnown(343294)) then
                lowhealthpercent = 35;
            end
        end

        if (englishClass == "WARLOCK") then
            if (C_SpellBook.IsSpellKnown(17877)) then --어연
                lowhealthpercent = 30;
            end
        end
    end
end

local unit_guid_list = {};

local Aggro_Y = -5;

local function checkSpellCasting(asframe)
    if not asframe.unit or UnitIsUnit(asframe.unit, "player") then
        return;
    end

    local unit = asframe.unit;
    local name, text, texture, startTime, endTime, isTradeSkill, castID, notInterruptible, spellid = UnitCastingInfo(
        unit);
    if not name then
        name, text, texture, startTime, endTime, isTradeSkill, notInterruptible, spellid = UnitChannelInfo(unit);
    end

    if asframe.casticon then
        local frameIcon = asframe.casticon.icon;
        if frameIcon then
            if name then
                frameIcon:SetTexture(texture);
                frameIcon:SetDesaturated(false);
                frameIcon:SetVertexColor(1, 1, 1);
                asframe.casticon:Show();
                asframe.casticon.timetext:Hide();
                asframe.castspellid = spellid;
                asframe.casticon.castspellid = spellid;

                local targettarget = unit .. "target";

                if UnitExists(targettarget) then
                    local _, Class = UnitClass(targettarget)
                    if Class then
                        local color = RAID_CLASS_COLORS[Class]
                        if color then
                            asframe.casticon.targetname:SetTextColor(color.r, color.g, color.b);
                            asframe.casticon.targetname:SetText(UnitName(targettarget));
                            asframe.casticon.targetname:Show();
                        end
                    end
                else
                    asframe.casticon.targetname:SetText("");
                    asframe.casticon.targetname:Hide();
                end
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
                        elseif guid and asframe.guid == guid and remain < min_remain then
                            frameIcon:SetTexture(icon);
                            asframe.casticon:Show();
                            asframe.casticon.castspellid = dbmspellid;
                            frameIcon:SetDesaturated(true);
                            if remain > 2 then
                                if colorid ~= 4 then
                                    frameIcon:SetVertexColor(1, 0.9, 0.9);
                                    asframe.casticon.timetext:SetTextColor(1, 1, 1);
                                else
                                    frameIcon:SetVertexColor(0.9, 1, 0.9);
                                    asframe.casticon.timetext:SetTextColor(1, 1, 1);
                                end
                            else
                                local color = frameIcon:GetVertexColor();
                                if colorid ~= 4 then
                                    frameIcon:SetVertexColor(1, 0.3, 0.3);
                                    asframe.casticon.timetext:SetTextColor(0, 1, 0);
                                else
                                    frameIcon:SetVertexColor(0.3, 1, 0.3);
                                    asframe.casticon.timetext:SetTextColor(1, 0, 0);
                                end
                            end

                            if remain > 0 then
                                asframe.casticon.timetext:SetText(math.ceil(remain));
                                asframe.casticon.timetext:Show();
                            else
                                asframe.casticon.timetext:Hide();
                            end

                            dbm_show = true;
                            min_remain = remain;
                        end
                    end
                end

                if dbm_show == false then
                    asframe.casticon:Hide();
                end
                asframe.castspellid = nil;
                asframe.casticon.targetname:Hide();
            end
        end
    end
end


local function asNamePlates_OnEvent(asframe, event, ...)
    if (event == "UNIT_AURA") then
        local unit, info = ...;
        ns.UpdateEventAuras(unit, info);
    elseif (event == "PLAYER_TARGET_CHANGED") then
        updateTargetNameP(asframe);
        updateHealthText(asframe);
        updatePower(asframe);
    else
        checkSpellCasting(asframe);
        updateHealthbarColor(asframe);
    end
end

local function createNamePlate(namePlateFrameBase)
end

local namePlateVerticalScale = nil;
local g_orig_height = nil;
local prev_mouseover = nil;

local function removeUnit(namePlateUnitToken)
    local namePlateFrameBase = C_NamePlate.GetNamePlateForUnit(namePlateUnitToken, issecure());

    if not namePlateFrameBase then
        return;
    end

    if namePlateFrameBase.asNamePlates ~= nil then
        local asframe = namePlateFrameBase.asNamePlates;

        for i = 1, ns.ANameP_MaxDebuff do
            if (asframe.buffList[i]) then
                asframe.buffList[i]:Hide();
                ns.lib.ButtonGlow_Stop(asframe.buffList[i]);
            end
        end

        if prev_mouseover == asframe then
            prev_mouseover = nil;
        end
        ns.lib.PixelGlow_Stop(asframe.casticon);
        ns.lib.PixelGlow_Stop(asframe);

        asframe.aggro:Hide();
        asframe.petcleave:Hide();
        asframe.pettarget:Hide();
        asframe.CCdebuff:Hide();
        asframe.healthtext:Hide();
        asframe.realhealthtext:Hide();
        asframe.motext:Hide();
        asframe.tgtext:Hide();
        asframe.resourcetext:Hide();
        asframe.casticon:Hide();
        asframe.healer:Hide();
        asframe.focus_indi:Hide();
        asframe.BarTexture:Hide();
        asframe.BarColor:Hide();

        asframe:Hide();
        asframe:UnregisterAllEvents();
        asframe:SetScript("OnEvent", nil);

        if asframe.timer then
            asframe.timer:Cancel();
            asframe.timer = nil;
        end


        ---@diagnostic disable-next-line: undefined-field
        if namePlateFrameBase.UnitFrame and namePlateFrameBase.UnitFrame.healthBar then
            ---@diagnostic disable-next-line: undefined-field
            ns.lib.PixelGlow_Stop(namePlateFrameBase.UnitFrame.healthBar);
        end
        asframe.alerttype = nil;

        asframe:ClearAllPoints();
        ns.freeasframe(asframe);
        asframe = nil;
    end

    if namePlateFrameBase and namePlateFrameBase.asNamePlates ~= nil then
        ---@diagnostic disable-next-line: inject-field
        namePlateFrameBase.asNamePlates = nil;
    end

    if UnitIsPlayer(namePlateUnitToken) and UnitGUID(namePlateUnitToken) then
        unit_guid_list[UnitGUID(namePlateUnitToken)] = nil;
    end
end

local function updateAll(asframe)
    updateAuras(asframe);
    updateTargetNameP(asframe);
    updateHealthText(asframe);
    updatePower(asframe);
    updateUnitRealHealthText(asframe);
    updateHealthbarColor(asframe);
    updatePVPAggro(asframe);
    checkSpellCasting(asframe);
end

local function updateNamePlate(namePlateFrameBase)
    if (namePlateFrameBase and namePlateFrameBase.asNamePlates ~= nil and not namePlateFrameBase:IsForbidden() and namePlateFrameBase.UnitFrame and namePlateFrameBase.UnitFrame:IsShown()) then
        local asframe = namePlateFrameBase.asNamePlates;
        updateAll(asframe);
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
    local healthbar = unitFrame.healthBar;
    local healthBarContainer = unitFrame.HealthBarsContainer;
    local unit = namePlateFrameBase.namePlateUnitToken;

    if UnitIsUnit("player", unit) then
        if not ns.ANameP_ShowPlayerBuff then
            if namePlateFrameBase.asNamePlates ~= nil then
                removeUnit(unit);
                unitFrame.BuffFrame:SetAlpha(1);
                unitFrame.BuffFrame:Show();
            end
            return;
        end
    else
        if not isAttackable(unit) then
            if namePlateFrameBase.asNamePlates ~= nil then
                removeUnit(unit);
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
    asframe:SetParent(healthbar);
    asframe:SetFrameLevel(healthbar:GetFrameLevel() + 20);
    asframe.nameplateBase = namePlateFrameBase;
    asframe.unit = unit;
    asframe.update = 0;
    asframe.alerttype = nil;
    asframe.namecolor = nil;
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
    asframe.partydealer = false;
    asframe.debuffColor = 0;

    asframe:UnregisterAllEvents();
    asframe:SetScript("OnEvent", nil);

    local Size = ns.ANameP_AggroSize;

    if namePlateVerticalScale ~= tonumber(GetCVar("NamePlateVerticalScale")) then
        namePlateVerticalScale = tonumber(GetCVar("NamePlateVerticalScale"));
        g_orig_height = healthbar:GetHeight();
    end

    if namePlateVerticalScale > 1.0 then
        Size = ns.ANameP_AggroSize + 2;
    end

    Aggro_Y = 0;

    asframe.orig_height = g_orig_height;

    asframe.aggro:SetFont(STANDARD_TEXT_FONT, Size, "THICKOUTLINE");
    asframe.petcleave:SetFont(STANDARD_TEXT_FONT, Size, "THICKOUTLINE");
    asframe.pettarget:SetFont(STANDARD_TEXT_FONT, Size, "THICKOUTLINE");
    asframe.focus_indi:SetFont(STANDARD_TEXT_FONT, Size, "THICKOUTLINE");

    if ns.ANameP_HealerSize > 0 then
        asframe.healer:SetFont(STANDARD_TEXT_FONT, ns.ANameP_HealerSize, "THICKOUTLINE");
    else
        asframe.healer:SetFont(STANDARD_TEXT_FONT, 1, "THICKOUTLINE");
    end
    asframe.healer:ClearAllPoints();
    asframe.healer:SetPoint("RIGHT", healthbar, "LEFT", -5, Aggro_Y)
    asframe.healer:SetText(healerIcon);
    asframe.healer:Hide();

    if unitFrame.castBar then
        asframe.casticon:SetMouseMotionEnabled(ns.options.ANameP_Tooltip);
        asframe.casticon:ClearAllPoints();
        asframe.casticon:SetPoint("BOTTOMLEFT", unitFrame.castBar, "BOTTOMRIGHT", 0, -0.3);
        asframe.casticon:SetWidth(13);
        asframe.casticon:SetHeight(13);
        asframe.casticon:Hide();
        asframe.castspellid = nil;
    end

    asframe.CCdebuff:SetMouseMotionEnabled(ns.options.ANameP_Tooltip);
    asframe.CCdebuff:ClearAllPoints();
    asframe.CCdebuff:SetPoint("LEFT", asframe.casticon, "RIGHT", 1, 0);
    asframe.CCdebuff:SetWidth(ns.ANameP_CCDebuffSize);
    asframe.CCdebuff:SetHeight(ns.ANameP_CCDebuffSize * 0.6);
    asframe.CCdebuff:Hide();

    asframe.focus_indi:ClearAllPoints();
    asframe.focus_indi:SetPoint("BOTTOM", healthbar, "TOPLEFT", 3, -1);
    asframe.focus_indi:SetText(focusIcon);
    asframe.focus_indi:Hide();

    local previousTexture = healthbar:GetStatusBarTexture();


    asframe.BarTexture:ClearAllPoints();
    asframe.BarTexture:SetAllPoints(previousTexture);
    asframe.BarTexture:SetVertexColor(previousTexture:GetVertexColor());
    asframe.BarTexture:Show();

    asframe.BarColor:ClearAllPoints();
    asframe.BarColor:SetAllPoints(previousTexture);
    asframe.BarColor:SetVertexColor(previousTexture:GetVertexColor())
    asframe.BarColor:Hide();

    asframe.healthtext:ClearAllPoints();
    asframe.healthtext:SetPoint("CENTER", healthbar, "CENTER", 0, 0)
    asframe.healthtext:Hide();

    asframe.realhealthtext:ClearAllPoints();
    asframe.realhealthtext:SetPoint("BOTTOMLEFT", healthbar, "BOTTOMLEFT", 1, 0);
    asframe.realhealthtext:SetTextColor(1, 1, 1, 1);
    asframe.realhealthtext:Hide();

    asframe.motext:ClearAllPoints();
    asframe.motext:SetPoint("TOP", healthbar, "BOTTOM", 0, -1)
    asframe.motext:SetText(mouseoverIcon);
    asframe.motext:Hide();

    asframe.tgtext:ClearAllPoints();
    asframe.tgtext:SetPoint("BOTTOM", healthbar, "TOP", 0, -1)
    asframe.tgtext:SetText(targetIcon);
    asframe.tgtext:Hide();

    asframe.checkaura = false;
    asframe.downbuff = false;
    asframe.checkpvptarget = false;
    asframe.checkcolor = false;

    for i = 1, ns.ANameP_MaxDebuff do
        if (asframe.buffList[i]) then
            asframe.buffList[i]:Hide();
        end
    end
    asframe:SetScript("OnEvent", asNamePlates_OnEvent);
    asframe:RegisterUnitEvent("UNIT_AURA", unit);

    if not UnitIsPlayer(unit) then
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

    ns.UpdateEventAuras(unit);

    local orig_width = healthbar:GetWidth();
    asframe.orig_width = orig_width;
    if ns.ANameP_SIZE > 0 then
        asframe.icon_size = ns.ANameP_SIZE;
    else
        asframe.icon_size = (orig_width / ns.ANameP_DebuffsPerLine) - (ns.ANameP_DebuffsPerLine - 1);
    end

    asframe.guid = UnitGUID(unit);

    local class = UnitClassification(unit)

    asframe.aggro:ClearAllPoints();

    if (class == "elite" or class == "worldboss" or class == "rare" or class == "rareelite") then
        asframe.aggro:SetPoint("RIGHT", healthbar, "LEFT", -8, Aggro_Y);
    else
        asframe.aggro:SetPoint("RIGHT", healthbar, "LEFT", 0, Aggro_Y);
    end

    asframe.aggro:Hide();

    asframe.petcleave:ClearAllPoints();
    asframe.petcleave:SetPoint("TOPRIGHT", healthbar, "BOTTOMRIGHT", 0, -1);
    asframe.petcleave:SetText(petcleaveIcon);
    asframe.petcleave:Hide();

    asframe.pettarget:ClearAllPoints();
    asframe.pettarget:SetPoint("TOPRIGHT", healthbar, "BOTTOMRIGHT", 0, -1);
    asframe.pettarget:SetText(pettargetIcon);
    asframe.pettarget:Hide();

    asframe.powerbar:ClearAllPoints();
    asframe.powerbar:SetPoint("TOP", healthbar, "BOTTOM", 0, -1);
    asframe.powerbar:SetWidth(orig_width / 2)
    asframe.bupdatePower = false;

    local powerType, powerToken = UnitPowerType(unit);

    if ns.options.ANameP_ShowPower and powerType ~= nil and powerType ~= Enum.PowerType.Mana and not UnitIsUnit(unit, "player") then
        local powerColor = PowerBarColor[powerType]
        if powerColor then
            asframe.powerbar:SetStatusBarColor(powerColor.r, powerColor.g, powerColor.b)
        end
        asframe.bupdatePower = true;
    else
        asframe.powerbar:Hide();
    end

    asframe:SetWidth(orig_width + 30);
    asframe:SetHeight(g_orig_height);
    asframe:ClearAllPoints();
    asframe:SetPoint("TOPLEFT", healthBarContainer, "TOPLEFT", -5, 1);


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
                asframe.resourcetext:SetPoint("TOP", healthbar, "BOTTOM", 0, -1);
            end

            Buff_Y = ns.ANameP_PlayerBuffY;

            if Buff_Y < 0 then
                asframe.downbuff = true;
                if GetCVar("nameplateResourceOnTarget") == "0" then
                    playerbuffposition = Buff_Y - 23;
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
        if UnitIsPlayer(unit) and ANameP_HealerGuid[asframe.guid] then
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
        asframe.resourcetext:Hide();

        unitFrame:UnregisterEvent("UNIT_THREAT_SITUATION_UPDATE");
        unitFrame:UnregisterEvent("UNIT_THREAT_LIST_UPDATE");
        unitFrame:UnregisterEvent("UNIT_AURA");
        asframe:Show();
    end

    for i = 1, ns.ANameP_MaxDebuff do
        updateDebuffAnchor(asframe.buffList, i, asframe, asframe.aggro, 1);
    end

    asframe.checkaura = checkaura;
    asframe.checkpvptarget = checkpvptarget;
    asframe.checkcolor = checkcolor;
    if checkcolor and playerisdealer then
        asframe.partydealer = true;
    end


    if showhealer and ns.ANameP_HealerSize > 0 then
        asframe.healer:Show();
    else
        asframe.healer:Hide();
    end

    if UnitIsPlayer(unit) then
        unit_guid_list[asframe.guid] = unit;
    end

    local level = UnitLevel(unit);

    asframe.isboss = false;
    if isparty and ns.options.ANameP_BossHint and level then
        if level < 0 or level > MaxLevel then
            asframe.isboss = true;
        end
    end

    asframe.stunable = true;
    if level < 0 or level > MaxLevel then
        asframe.stunable = false;
    end


    asframe.automarkcolor = nil;
    if ns.options.ANameP_AutoMarker and isinstance and bloadedAutoMarker and asAutoMarkerF then
        local mobtype = asAutoMarkerF.IsAutoMarkerMob(unit);
        if mobtype and mobtype >= 2 then
            asframe.automarkcolor = ns.options.ANameP_AutoMarkerColor;
        elseif mobtype and mobtype >= 1 then
            asframe.automarkcolor = ns.options.ANameP_AutoMarkerColor2;
        end
    end

    local function callback()
        updateNamePlate(namePlateFrameBase);
    end

    if asframe.timer then
        asframe.timer:Cancel();
    end

    asframe.timer = C_Timer.NewTicker(ns.ANameP_UpdateRate, callback);
end


local function updateHealerMark(guid)
    local unit = unit_guid_list[guid];

    if unit and ANameP_HealerGuid[guid] and not UnitIsUnit(unit, "player") then
        local nameplate = C_NamePlate.GetNamePlateForUnit(unit, issecure());
        if (nameplate and nameplate.asNamePlates ~= nil and not nameplate:IsForbidden() and
                nameplate.asNamePlates.checkpvptarget) then
            ---@diagnostic disable-next-line: undefined-field
            nameplate.asNamePlates.healer:Show();
        end
    end
end

local function addUnit(namePlateUnitToken)
    local namePlateFrameBase = C_NamePlate.GetNamePlateForUnit(namePlateUnitToken, issecure());

    if namePlateFrameBase then
        addNamePlate(namePlateFrameBase);
        if namePlateFrameBase.asNamePlates ~= nil then
            local asframe = namePlateFrameBase.asNamePlates;
            updateAll(asframe);
        end
    end
end

local function updateUnitResourceText(asframe)
    local value;
    local valueMax;
    local valuePct;
    local unit = asframe.unit;
    local frame = asframe.resourcetext;

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

local function updateUnit(namePlateUnitToken, bquick)
    local namePlateFrameBase = C_NamePlate.GetNamePlateForUnit(namePlateUnitToken, issecure());
    if namePlateFrameBase and not namePlateFrameBase:IsForbidden() then
        if namePlateFrameBase.asNamePlates ~= nil then
            local asframe = namePlateFrameBase.asNamePlates;
            updateTargetNameP(asframe);
            updateHealthText(asframe);
            updatePower(asframe);

            if not bquick then
                updateAuras(asframe);
                updateUnitRealHealthText(asframe);
                updateHealthbarColor(asframe);

                if namePlateUnitToken == "player" then
                    updateUnitResourceText(asframe);
                end
            end
        end
    end
end

local bfirst = true;

local function setupFriendlyPlates()
    if bfirst and not isinstance and not InCombatLockdown() and ns.options.ANameP_ShortFriendNP then
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
        addUnit(namePlateUnitToken);
    elseif event == "NAME_PLATE_UNIT_REMOVED" then
        local namePlateUnitToken = ...;
        removeUnit(namePlateUnitToken);
    elseif event == "COMBAT_LOG_EVENT_UNFILTERED" then
        local _, eventType, _, sourceGUID, _, _, _, destGUID, _, _, _, spellID, _, _, auraType =
            CombatLogGetCurrentEventInfo();

        if bcheckHealer then
            if eventType == "SPELL_CAST_SUCCESS" and sourceGUID and not (sourceGUID == "") then
                local className = GetPlayerInfoByGUID(sourceGUID);
                if className and ns.ANameP_HealSpellList[className] and ns.ANameP_HealSpellList[className][spellID] then
                    ANameP_HealerGuid[sourceGUID] = true;
                    updateHealerMark(sourceGUID);
                end
            end
        end

        if bcheckBeastCleave and self.petGUID then
            local currtime = GetTime();
            if sourceGUID and sourceGUID == self.petGUID then
                if (eventType == "SPELL_DAMAGE" or eventType == "SPELL_MISSED")
                    and (spellID == 118459) then
                    if currtime - lastcleavetime > 0.5 then
                        cleavedunits = {};
                    end
                    cleavedunits[destGUID] = currtime;
                    lastcleavetime = currtime;
                end
            end
        end
    elseif event == "UPDATE_MOUSEOVER_UNIT" then
        local bupdate = false;
        if UnitExists("mouseover") then
            local pframe = C_NamePlate.GetNamePlateForUnit("mouseover", issecure())
            if pframe and pframe.asNamePlates ~= nil then
                bupdate = true;
                if prev_mouseover and prev_mouseover ~= pframe.asNamePlates then
                    updateTargetNameP(prev_mouseover);
                end
                prev_mouseover = pframe.asNamePlates;
            end
        end

        if bupdate == false then
            if prev_mouseover then
                updateTargetNameP(prev_mouseover);
            end
            prev_mouseover = nil;
        end

        updateUnit("mouseover", true);
    elseif (event == "TRAIT_CONFIG_UPDATED") or (event == "TRAIT_CONFIG_LIST_UPDATED") or
        (event == "ACTIVE_TALENT_GROUP_CHANGED") then
        C_Timer.After(0.5, setupKnownSpell);
        C_Timer.After(0.5, initAlertList);
    elseif (event == "PLAYER_ENTERING_WORLD") then
        local isInstance, instanceType = IsInInstance();

        isinstance = isInstance;
        ispvp = false;
        israid = false;
        isparty = false;
        if isInstance and (instanceType == "party" or instanceType == "raid" or instanceType == "scenario") then
            if not bcheckBeastCleave then
                self:UnregisterEvent("COMBAT_LOG_EVENT_UNFILTERED");
            end
            bcheckHealer = false;
            if instanceType == "raid" then
                israid = true;
            else
                isparty = true;
            end
        else
            self:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED");
            bcheckHealer = true;

            ispvp = true;
        end

        updateTankerList();
        setupKnownSpell();
        -- 0.5 초 뒤에 Load
        C_Timer.After(0.5, initAlertList);
        C_Timer.After(0.5, setupFriendlyPlates);
    elseif (event == "UNIT_FACTION") then
        local namePlateUnitToken = ...;
        addUnit(namePlateUnitToken);
    elseif (event == "GROUP_JOINED" or event == "GROUP_ROSTER_UPDATE" or event == "PLAYER_ROLES_ASSIGNED") then
        updateTankerList();
    elseif event == "PLAYER_REGEN_ENABLED" then
        setupFriendlyPlates();
    elseif event == "UNIT_PET" then
        self.petGUID = UnitGUID("pet");
    end
end

local function ANameP_OnUpdate()
    updateUnit("target", false);
end

local function ANameP_OnUpdate2()
    updateUnit("player", false);
end

local function ANameP_OnUpdate3()
    updateUnit("mouseover", false);
end

local function flushoption()
    ns.options = CopyTable(ANameP_Options);
    C_Timer.After(0.5, initAlertList);
end

local DBMobj;

local function scanDBM()
    ns.DangerousSpellList = {};
    if DBMobj.Mods then
        for i, mod in ipairs(DBMobj.Mods) do
            if mod.Options and mod.announces then
                for k, obj in pairs(mod.announces) do
                    if obj.spellId and obj.announceType and obj.option then
                        if (ns.DangerousSpellList[obj.spellId] == nil or ns.DangerousSpellList[obj.spellId] ~= "interrupt") and mod.Options[obj.option] then
                            ns.DangerousSpellList[obj.spellId] = obj.announceType;
                        end
                    end
                end
            end

            if mod.Options and mod.specwarns then
                for k, obj in pairs(mod.specwarns) do
                    if obj.spellId and obj.announceType and obj.option then
                        if (ns.DangerousSpellList[obj.spellId] == nil or ns.DangerousSpellList[obj.spellId] ~= "interrupt") and mod.Options[obj.option] then
                            ns.DangerousSpellList[obj.spellId] = obj.announceType;
                        end
                    end
                end
            end
        end
    end
end

local function NewMod(self, ...)
    DBMobj = self;
    C_Timer.After(2, scanDBM);
end

local function initAddon()
    ANameP:RegisterEvent("NAME_PLATE_CREATED");
    ANameP:RegisterEvent("NAME_PLATE_UNIT_ADDED");
    ANameP:RegisterEvent("NAME_PLATE_UNIT_REMOVED");
    -- 나중에 추가 처리가 필요하면 하자.
    -- ANameP:RegisterEvent("FORBIDDEN_NAME_PLATE_UNIT_ADDED");
    -- ANameP:RegisterEvent("FORBIDDEN_NAME_PLATE_UNIT_REMOVED");

    ANameP:RegisterEvent("PLAYER_ENTERING_WORLD");
    ANameP:RegisterEvent("ADDON_LOADED")
    ANameP:RegisterEvent("TRAIT_CONFIG_UPDATED");
    ANameP:RegisterEvent("TRAIT_CONFIG_LIST_UPDATED");
    ANameP:RegisterEvent("ACTIVE_TALENT_GROUP_CHANGED");
    ANameP:RegisterEvent("UNIT_FACTION");
    ANameP:RegisterEvent("UPDATE_MOUSEOVER_UNIT");
    ANameP:RegisterEvent("GROUP_JOINED");
    ANameP:RegisterEvent("GROUP_ROSTER_UPDATE");
    ANameP:RegisterEvent("PLAYER_ROLES_ASSIGNED");
    ANameP:RegisterEvent("PLAYER_REGEN_ENABLED");
    ANameP:RegisterUnitEvent("UNIT_PET", "player");

    ANameP:SetScript("OnEvent", ANameP_OnEvent)
    -- 주기적으로 Callback
    C_Timer.NewTicker(ns.ANameP_UpdateRateTarget, ANameP_OnUpdate);
    C_Timer.NewTicker(ns.ANameP_UpdateRateTarget, ANameP_OnUpdate2);
    C_Timer.NewTicker(ns.ANameP_UpdateRateTarget, ANameP_OnUpdate3);

    hooksecurefunc("DefaultCompactNamePlateFrameAnchorInternal", function(frame, setupOptions)
        if (frame:IsForbidden()) then
            return;
        end


        if frame.unit and UnitIsUnit(frame.unit, "target") then
            local pframe = C_NamePlate.GetNamePlateForUnit("target", issecure())
            if pframe and pframe.asNamePlates ~= nil then
                updateTargetNameP(pframe.asNamePlates);
            end
        end

        if frame.unit and UnitExists("mouseover") then
            local guid_mouseover = UnitGUID("mouseover")
            if UnitGUID(frame.unit) == guid_mouseover then
                local pframe = C_NamePlate.GetNamePlateForUnit("mouseover", issecure())
                if pframe and pframe.asNamePlates ~= nil then
                    updateTargetNameP(pframe.asNamePlates);
                end
            end
        end
    end)

    ANameP_OptionM.RegisterCallback(flushoption);

    local bloaded = C_AddOns.LoadAddOn("DBM-Core");
    if bloaded then
        hooksecurefunc(DBM, "NewMod", NewMod)
    end

    bloadedAutoMarker = C_AddOns.LoadAddOn("asAutoMarker") or false;
end

initAddon();
