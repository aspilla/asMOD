local _, ns = ...;

------------------------------------------
---설정부
------------------------------------------

local Update_Rate = 0.1 -- 0.1 초마다 Update
local xposition = 225;
local yposition = -195;
local healthheight = 35;
local powerheight = 5;

local CONFIG_NOT_INTERRUPTIBLE_COLOR = { 0.9, 0.9, 0.9 };                 --차단 불가시 (내가 아닐때) 색상 (r, g, b)
local CONFIG_NOT_INTERRUPTIBLE_COLOR_TARGET = { 153 / 255, 0, 76 / 255 }; --차단 불가시 (내가 타겟일때) 색상 (r, g, b)
local CONFIG_INTERRUPTIBLE_COLOR = { 204 / 255, 255 / 255, 153 / 255 };   --차단 가능(내가 타겟이 아닐때)시 색상 (r, g, b)
local CONFIG_INTERRUPTIBLE_COLOR_TARGET = { 76 / 255, 153 / 255, 0 };     --차단 가능(내가 타겟일 때)시 색상 (r, g, b)
---
---

local RaidIconList = {
    "|TInterface\\TargetingFrame\\UI-RaidTargetingIcon_1:",
    "|TInterface\\TargetingFrame\\UI-RaidTargetingIcon_2:",
    "|TInterface\\TargetingFrame\\UI-RaidTargetingIcon_3:",
    "|TInterface\\TargetingFrame\\UI-RaidTargetingIcon_4:",
    "|TInterface\\TargetingFrame\\UI-RaidTargetingIcon_5:",
    "|TInterface\\TargetingFrame\\UI-RaidTargetingIcon_6:",
    "|TInterface\\TargetingFrame\\UI-RaidTargetingIcon_7:",
    "|TInterface\\TargetingFrame\\UI-RaidTargetingIcon_8:",
}

local leaderIcon = CreateAtlasMarkup("groupfinder-icon-leader", 14, 9, 0, 0);

local function UpdateFillBarBase(realbar, bar, amount)
    if not amount or (amount == 0) then
        bar:Hide();
        return
    end

    local previousTexture = realbar:GetStatusBarTexture();

    local gen = false;

    bar:ClearAllPoints();
    bar:SetPoint("TOPLEFT", previousTexture, "TOPRIGHT", 0, 0);
    bar:SetPoint("BOTTOMLEFT", previousTexture, "BOTTOMRIGHT", 0, 0);

    if amount < 0 then
        amount = 0 - amount;
        gen = true;
    end

    local totalWidth, totalHeight = realbar:GetSize();

    local _, totalMax = realbar:GetMinMaxValues();

    local barSize = (amount / totalMax) * totalWidth;
    bar:SetWidth(barSize);
    if gen then
        bar:SetVertexColor(1, 1, 1)
    else
        bar:SetVertexColor(0.5, 0.5, 0.5)
    end
    bar:Show();
end

local unit_player = "player";
local unit_pet = "pet";

local function UpdatePlayerUnit()
    local hasValidVehicleUI = UnitHasVehicleUI("player");
    local unitVehicleToken;
    if (hasValidVehicleUI) then
        local prefix, id, suffix = string.match("player", "([^%d]+)([%d]*)(.*)")
        unitVehicleToken = prefix .. "pet" .. id .. suffix;
        if (not UnitExists(unitVehicleToken)) then
            hasValidVehicleUI = false;
        end
    end

    if (hasValidVehicleUI) then
        unit_player = unitVehicleToken
        unit_pet = "player"
    else
        unit_player = "player"
        unit_pet = "pet"
    end
end

local function updateUnit(frame)
    local unit = frame.unit;
    local showplayermana = false;

    if unit == "player" then
        UpdatePlayerUnit()
        unit = unit_player;
        showplayermana = (unit ~= "player");
    elseif unit == "pet" then
        unit = unit_pet;
    end

    if not UnitExists(unit) then
        frame:SetAlpha(0);
        return;
    else
        if not InCombatLockdown() then
            frame:SetAlpha(0.5);
        else
            frame:SetAlpha(1);
        end
    end

    -- Healthbar
    local value = UnitHealth(unit);
    local valueMax = UnitHealthMax(unit);
    local value_orig = value;

    local allIncomingHeal = UnitGetIncomingHeals(unit) or 0;
    local totalAbsorb = UnitGetTotalAbsorbs(unit) or 0;
    local total = allIncomingHeal + totalAbsorb;

    valuePct = (math.ceil((value / valueMax) * 100));
    valuePct_orig = (math.ceil((value_orig / valueMax) * 100));
    local valuePctAbsorb = (math.ceil((total / valueMax) * 100));

    frame.healthbar:SetMinMaxValues(0, valueMax)
    frame.healthbar:SetValue(value)

    if valuePctAbsorb > 0 then
        frame.healthbar.pvalue:SetText(valuePct .. "(" .. valuePctAbsorb .. ")");
    else
        frame.healthbar.pvalue:SetText(valuePct);
    end

    local totalAbsorbremain = totalAbsorb;
    local remainhealth = valueMax - value;

    if totalAbsorbremain > remainhealth then
        totalAbsorbremain = remainhealth;
    end

    UpdateFillBarBase(frame.healthbar, frame.healthbar.absorbBar, totalAbsorbremain);

    --Castbar
    local current = GetTime();

    if frame.castbar.start and frame.castbar.start > 0 and frame.castbar.start + frame.castbar.duration >= current then
        local castBar = frame.castbar;
        local start = castBar.start;
        local duration = castBar.duration;        
        local time = castBar.time;

        if castBar.bchanneling then
            castBar:SetValue((start + duration - current));
            time:SetText(format("%.1f/%.1f", max((start + duration - current), 0), max(duration, 0)));
        else
            castBar:SetValue((current - start));
            time:SetText(format("%.1f/%.1f", max((current - start), 0), max(duration, 0)));
        end
        
    end

    if frame.updatecount == 1 then
        frame.updatecount = 0;
    else
        frame.updatecount = frame.updatecount + 1;
        return;
    end

    --ClassColor
    if UnitIsPlayer(unit) then
        local class = select(2, UnitClass(unit));
        local classColor = class and RAID_CLASS_COLORS[class] or nil;
        if classColor then
            frame.healthbar:SetStatusBarColor(classColor.r, classColor.g, classColor.b);
        end
    else
        local r = 0;
        local g = 1.0;
        local b = 0;
        local reaction = UnitReaction("player", unit);
        if (reaction) then
            r = FACTION_BAR_COLORS[reaction].r;
            g = FACTION_BAR_COLORS[reaction].g;
            b = FACTION_BAR_COLORS[reaction].b;
        end

        frame.healthbar:SetStatusBarColor(r, g, b);
    end

    --Name
    local unitlevel = UnitLevel(unit);
    if unitlevel < 0 then
        unitlevel = "??"
    end

    local mark = "";
    local icon = GetRaidTargetIndex(unit)
    if icon and RaidIconList[icon] then
        mark = RaidIconList[icon] .. "0|t"
    end

    if IsResting() and frame == AUF_PlayerFrame then
        mark = mark .. " " .. "zzz"
    end

    local name = UnitName(unit);

    if UnitIsGroupLeader(unit) then
        name = leaderIcon .. " " .. name;
    end

    local classification = UnitClassification(unit)

    if classification and classification ~= "minus" and classification ~= "normal" and classification ~= "trivial" then
        name = classification .. " " .. name;
    end

    name = unitlevel .. " " .. name;

    --Power
    frame.healthbar.hvalue:SetText(AbbreviateLargeNumbers(value))
    frame.healthbar.name:SetText(name);
    frame.healthbar.mark:SetText(mark);

    local power = UnitPower(unit)
    local maxPower = UnitPowerMax(unit)
    frame.powerbar:SetMinMaxValues(0, maxPower)
    frame.powerbar:SetValue(power)
    frame.powerbar.value:SetText(power)

    local powerType, powerToken = UnitPowerType(unit)

    if powerType ~= nil then
        local powerColor = PowerBarColor[powerType]
        if powerColor then
            frame.powerbar:SetStatusBarColor(powerColor.r, powerColor.g, powerColor.b)
        end

        if frame == AUF_PlayerFrame then
            if powerType > 0 then
                local manavalue = UnitPower(unit, 0);
                local manaMax = UnitPowerMax(unit, 0);

                if manavalue > 0 then
                    frame.healthbar:SetHeight(healthheight - powerheight);
                    frame.powerbar:SetHeight(powerheight);
                    frame.powerbar:SetMinMaxValues(0, manaMax)
                    frame.powerbar:SetValue(manavalue);
                    frame.powerbar.value:SetText(manavalue)
                    local powerColor = PowerBarColor[0]
                    frame.powerbar:SetStatusBarColor(powerColor.r, powerColor.g, powerColor.b)
                elseif showplayermana then
                    frame.healthbar:SetHeight(healthheight - powerheight);
                    frame.powerbar:SetHeight(powerheight);
                else
                    frame.healthbar:SetHeight(healthheight);
                    frame.powerbar:SetHeight(0);
                end
            else
                frame.healthbar:SetHeight(healthheight);
                frame.powerbar:SetHeight(0);
            end
        end
    end

    --Threat
    if frame ~= AUF_PlayerFrame and frame ~= AUF_PetFrame and frame ~= AUF_PetFrame and frame ~= AUF_TargetTargetFrame and not UnitIsPlayer(unit) then
        local isTanking, status, percentage, rawPercentage = UnitDetailedThreatSituation("player", unit);

        local display;

        if (isTanking) then
            display = UnitThreatPercentageOfLead("player", unit);
        end

        if not display then
            display = percentage;
        end

        if (display and display ~= 0) then
            frame.healthbar.aggro:SetText(format("%1.0f", display) .. "%");
            local r, g, b = GetThreatStatusColor(status)
            frame.healthbar.aggro:SetTextColor(r, g, b, 1);
            frame.healthbar.aggro:Show();
        else
            frame.healthbar.aggro:Hide();
        end
    end

    --Debuff
    if frame.debuffupdate then
        ns.UpdateAuras(frame);
    end
end

local function asTargetFrame_OpenMenu(self, unit)
    local which;
    local name;
    if (UnitIsUnit(unit, "player")) then
        which = "SELF";
    elseif (UnitIsUnit(unit, "vehicle")) then
        -- NOTE: vehicle check must come before pet check for accuracy's sake because
        -- a vehicle may also be considered your pet
        which = "VEHICLE";
    elseif (UnitIsUnit(unit, "pet")) then
        which = "PET";
    elseif (UnitIsOtherPlayersBattlePet(unit)) then
        which = "OTHERBATTLEPET";
    elseif (UnitIsBattlePet(unit)) then
        which = "BATTLEPET";
    elseif (UnitIsOtherPlayersPet(unit)) then
        which = "OTHERPET";
    elseif (UnitIsPlayer(unit)) then
        if (UnitInRaid(unit)) then
            which = "RAID_PLAYER";
        elseif (UnitInParty(unit)) then
            which = "PARTY";
        else
            if (not UnitIsMercenary("player")) then
                if (UnitCanCooperate("player", unit)) then
                    which = "PLAYER";
                else
                    which = "ENEMY_PLAYER"
                end
            else
                if (UnitCanAttack("player", unit)) then
                    which = "ENEMY_PLAYER"
                else
                    which = "PLAYER";
                end
            end
        end
    else
        which = "TARGET";
        name = RAID_TARGET_ICON;
    end
    if (which) then
        local contextData = {
            fromTargetFrame = true,
            unit = unit,
            name = name,
        };

        UnitPopup_OpenMenu(which, contextData);
    end
end

local function OpenContextMenu(s, unit, button, isKeyPress)
    return asTargetFrame_OpenMenu(s, s.unit);
end

local function UpdateDebuffAnchor(frames, index, offsetX, right, parent, width)
    local buff = frames[index];

    if (index == 1) then
        buff:SetPoint("TOPLEFT", parent.powerbar, "BOTTOMLEFT", 0, -2);
    else
        buff:SetPoint("BOTTOMLEFT", frames[index - 1], "BOTTOMRIGHT", offsetX, 0);
    end

    -- Resize
    buff:SetWidth(width - offsetX);
    buff:SetHeight(width * 0.8);
end


local function CreatDebuffFrames(parent, bright, fontsize, width, count)
    if parent.frames == nil then
        parent.frames = {};
    end

    for idx = 1, count do
        parent.frames[idx] = CreateFrame("Button", nil, parent, "AUFDebuffFrameTemplate");
        local frame = parent.frames[idx];
        for _, r in next, { frame.cooldown:GetRegions() } do
            if r:GetObjectType() == "FontString" then
                r:SetFont(STANDARD_TEXT_FONT, fontsize, "OUTLINE");
                r:ClearAllPoints();
                r:SetPoint("CENTER", 0, 0);
                break
            end
        end

        frame.count:SetFont(STANDARD_TEXT_FONT, fontsize, "OUTLINE")
        frame.count:ClearAllPoints()
        frame.count:SetPoint("BOTTOMRIGHT", -2, 2);

        frame.icon:SetTexCoord(.08, .92, .08, .92);
        frame.icon:SetAlpha(1);
        frame.border:SetTexture("Interface\\Addons\\asUnitFrame\\border.tga");
        frame.border:SetTexCoord(0.08, 0.08, 0.08, 0.92, 0.92, 0.08, 0.92, 0.92);
        frame.border:SetAlpha(1);

        frame:ClearAllPoints();
        UpdateDebuffAnchor(parent.frames, idx, 1, bright, parent, width/count);

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

        frame:Hide();
    end

    return;
end

local function CreateUnitFrame(frame, unit, x, y, width, height, powerbarheight, fontsize, debuffupdate)
    local FontOutline = "OUTLINE";

    frame:ClearAllPoints();
    frame:SetPoint("CENTER", UIParent, "CENTER", x, y);
    frame:SetSize(width, height)

    frame.healthbar = CreateFrame("StatusBar", nil, frame);
    frame.healthbar:SetStatusBarTexture("Interface\\addons\\asUnitFrame\\UI-StatusBar", "BORDER")
    frame.healthbar:GetStatusBarTexture():SetHorizTile(false)
    frame.healthbar:SetMinMaxValues(0, 100)
    frame.healthbar:SetValue(100)
    frame.healthbar:SetWidth(width)
    frame.healthbar:SetHeight(height - powerbarheight)
    frame.healthbar:SetPoint("CENTER", frame, "CENTER", 0, 0);
    frame.healthbar:Show();


    frame.healthbar.predictionBar = frame.healthbar:CreateTexture(nil, "BORDER");
    frame.healthbar.predictionBar:SetTexture("Interface\\addons\\asUnitFrame\\UI-StatusBar", "BORDER");
    frame.healthbar.predictionBar:Hide();

    frame.healthbar.absorbBar = frame.healthbar:CreateTexture(nil, "BORDER");
    frame.healthbar.absorbBar:SetTexture("Interface\\addons\\asUnitFrame\\UI-StatusBar", "BORDER");
    frame.healthbar.absorbBar:Hide();


    frame.healthbar.bg = frame.healthbar:CreateTexture(nil, "BACKGROUND");
    frame.healthbar.bg:SetPoint("TOPLEFT", frame.healthbar, "TOPLEFT", -1, 1);
    frame.healthbar.bg:SetPoint("BOTTOMRIGHT", frame.healthbar, "BOTTOMRIGHT", 1, -1);

    frame.healthbar.bg:SetTexture("Interface\\Addons\\asUnitFrame\\border.tga");
    frame.healthbar.bg:SetTexCoord(0.1, 0.1, 0.1, 0.1, 0.1, 0.1, 0.1, 0.1);
    frame.healthbar.bg:SetVertexColor(0, 0, 0, 0.8);

    frame.healthbar.pvalue = frame.healthbar:CreateFontString(nil, "ARTWORK");
    frame.healthbar.pvalue:SetFont(STANDARD_TEXT_FONT, fontsize + 1, FontOutline);
    frame.healthbar.pvalue:SetTextColor(1, 1, 1, 1)

    frame.healthbar.hvalue = frame.healthbar:CreateFontString(nil, "ARTWORK");
    frame.healthbar.hvalue:SetFont(STANDARD_TEXT_FONT, fontsize - 1, FontOutline);
    frame.healthbar.hvalue:SetTextColor(1, 1, 1, 1)

    frame.healthbar.name = frame.healthbar:CreateFontString(nil, "ARTWORK");
    frame.healthbar.name:SetFont(STANDARD_TEXT_FONT, fontsize - 1, FontOutline);
    frame.healthbar.name:SetTextColor(1, 1, 1, 1)

    frame.healthbar.aggro = frame.healthbar:CreateFontString(nil, "ARTWORK");
    frame.healthbar.aggro:SetFont(STANDARD_TEXT_FONT, fontsize, FontOutline);
    frame.healthbar.aggro:SetTextColor(1, 1, 1, 1)

    if x < 0 then
        frame.healthbar.pvalue:SetPoint("LEFT", frame.healthbar, "LEFT", 2, 0);
        frame.healthbar.hvalue:SetPoint("RIGHT", frame.healthbar, "RIGHT", -2, 0);
        frame.healthbar.name:SetPoint("BOTTOMLEFT", frame.healthbar, "TOPLEFT", 2, 1);
        frame.healthbar.aggro:SetPoint("BOTTOMRIGHT", frame.healthbar, "TOPRIGHT", -2, 1);
    else
        frame.healthbar.pvalue:SetPoint("RIGHT", frame.healthbar, "RIGHT", -2, 0);
        frame.healthbar.hvalue:SetPoint("LEFT", frame.healthbar, "LEFT", 2, 0);
        frame.healthbar.name:SetPoint("BOTTOMRIGHT", frame.healthbar, "TOPRIGHT", -2, 1);
        frame.healthbar.aggro:SetPoint("BOTTOMLEFT", frame.healthbar, "TOPLEFT", 2, 1);
    end

    frame.healthbar.mark = frame.healthbar:CreateFontString(nil, "ARTWORK");
    frame.healthbar.mark:SetFont(STANDARD_TEXT_FONT, fontsize, FontOutline);
    frame.healthbar.mark:SetTextColor(1, 1, 1, 1)
    frame.healthbar.mark:SetPoint("CENTER", frame.healthbar, "CENTER", 0, 0);

    frame.powerbar = CreateFrame("StatusBar", nil, frame);
    frame.powerbar:SetStatusBarTexture("Interface\\addons\\asUnitFrame\\UI-StatusBar", "BORDER")
    frame.powerbar:GetStatusBarTexture():SetHorizTile(false)
    frame.powerbar:SetMinMaxValues(0, 100)
    frame.powerbar:SetValue(100)
    frame.powerbar:SetWidth(width)
    frame.powerbar:SetHeight(powerbarheight)
    frame.powerbar:SetPoint("TOPLEFT", frame.healthbar, "BOTTOMLEFT", 0, 0);
    frame.powerbar:Show();

    frame.powerbar.bg = frame.healthbar:CreateTexture(nil, "BACKGROUND");
    frame.powerbar.bg:SetPoint("TOPLEFT", frame.powerbar, "TOPLEFT", -1, 1);
    frame.powerbar.bg:SetPoint("BOTTOMRIGHT", frame.powerbar, "BOTTOMRIGHT", 1, -1);

    frame.powerbar.bg:SetTexture("Interface\\Addons\\asUnitFrame\\border.tga");
    frame.powerbar.bg:SetTexCoord(0.1, 0.1, 0.1, 0.1, 0.1, 0.1, 0.1, 0.1);
    frame.powerbar.bg:SetVertexColor(0, 0, 0, 0.8);

    frame.powerbar.value = frame.healthbar:CreateFontString(nil, "ARTWORK");
    frame.powerbar.value:SetFont(STANDARD_TEXT_FONT, fontsize - 2, FontOutline);
    frame.powerbar.value:SetTextColor(1, 1, 1, 1)
    frame.powerbar.value:SetPoint("CENTER", frame.powerbar, "CENTER", 0, 0);

    frame.unit = unit;
    -- 유닛 설정 (예시: 'player' 또는 'target' 등)
    frame:SetAttribute("unit", unit);
    SecureUnitButton_OnLoad(frame, frame.unit, OpenContextMenu);
    Mixin(frame, PingableType_UnitFrameMixin);
    frame:SetAttribute("ping-receiver", true);

    if not frame:GetScript("OnEnter") then
        frame:SetScript("OnEnter", function(s)
            if s.unit then
                GameTooltip_SetDefaultAnchor(GameTooltip, s);
                GameTooltip:SetUnit(s.unit);
            end
        end)
        frame:SetScript("OnLeave", function()
            GameTooltip:Hide();
        end)
    end

    local castbarheight = height - 5;

    frame.castbar = CreateFrame("StatusBar", nil, frame)
    frame.castbar:SetPoint("TOPRIGHT", frame.powerbar, "BOTTOMRIGHT", 0, -2);
    frame.castbar:SetStatusBarTexture("Interface\\addons\\asUnitFrame\\UI-StatusBar", "BORDER")
    frame.castbar:GetStatusBarTexture():SetHorizTile(false)
    frame.castbar:SetMinMaxValues(0, 100)
    frame.castbar:SetValue(100)
    frame.castbar:SetHeight(castbarheight)
    frame.castbar:SetWidth(width - ((castbarheight + 1) * 1.2) - 1)
    frame.castbar:SetStatusBarColor(1, 0.9, 0.9);
    frame.castbar:SetAlpha(1);

    frame.castbar.bg = frame.castbar:CreateTexture(nil, "BACKGROUND")
    frame.castbar.bg:SetPoint("TOPLEFT", frame.castbar, "TOPLEFT", -1, 1)
    frame.castbar.bg:SetPoint("BOTTOMRIGHT", frame.castbar, "BOTTOMRIGHT", 1, -1)

    frame.castbar.bg:SetTexture("Interface\\Addons\\asUnitFrame\\border.tga")
    frame.castbar.bg:SetTexCoord(0.1, 0.1, 0.1, 0.1, 0.1, 0.1, 0.1, 0.1)
    frame.castbar.bg:SetVertexColor(0, 0, 0, 0.8);
    frame.castbar.bg:Show();

    frame.castbar.name = frame.castbar:CreateFontString(nil, "OVERLAY");
    frame.castbar.name:SetFont(STANDARD_TEXT_FONT, fontsize - 1);
    frame.castbar.name:SetPoint("LEFT", frame.castbar, "LEFT", 3, 0);

    frame.castbar.time = frame.castbar:CreateFontString(nil, "OVERLAY");
    frame.castbar.time:SetFont(STANDARD_TEXT_FONT, fontsize - 1);
    frame.castbar.time:SetPoint("RIGHT", frame.castbar, "RIGHT", -3, 0);

    if not frame.castbar:GetScript("OnEnter") then
        frame.castbar:SetScript("OnEnter", function(s)
            if s.castspellid and s.castspellid > 0 then
                GameTooltip_SetDefaultAnchor(GameTooltip, s);
                GameTooltip:SetSpellByID(s.castspellid);
            end
        end)
        frame.castbar:SetScript("OnLeave", function()
            GameTooltip:Hide();
        end)
    end

    frame.castbar:EnableMouse(false);
    frame.castbar:SetMouseMotionEnabled(true);
    frame.castbar:Hide();

    frame.castbar.button = CreateFrame("Button", nil, frame.castbar, "AUFFrameTemplate");
    frame.castbar.button:SetPoint("RIGHT", frame.castbar, "LEFT", -2, 0)
    frame.castbar.button:SetWidth((castbarheight + 1) * 1.2);
    frame.castbar.button:SetHeight(castbarheight + 1);
    frame.castbar.button:SetScale(1);
    frame.castbar.button:SetAlpha(1);
    frame.castbar.button:EnableMouse(false);
    frame.castbar.button.icon:SetTexCoord(.08, .92, .08, .92);
    frame.castbar.button.border:SetTexCoord(0.08, 0.08, 0.08, 0.92, 0.92, 0.08, 0.92, 0.92);
    frame.castbar.button.border:SetVertexColor(0, 0, 0);
    frame.castbar.button.border:Show();
    frame.castbar.button:Show();

    frame.castbar.targetname = frame.castbar:CreateFontString(nil, "OVERLAY");
    frame.castbar.targetname:SetFont(STANDARD_TEXT_FONT, fontsize - 1);
    frame.castbar.targetname:SetPoint("TOPRIGHT", frame.castbar, "BOTTOMRIGHT", 0, -2);
    frame.debuffupdate = false;

    if debuffupdate then        
        CreatDebuffFrames(frame, true, fontsize, width, 4);
        frame.debuffupdate = true;
    end

    frame.updatecount = 1;

    frame:Show();

    frame.callback = function ()
        updateUnit(frame);
    end

    C_Timer.NewTicker(Update_Rate, frame.callback);
   
end

AUF_PlayerFrame = CreateFrame("Button", nil, UIParent, "AUFUnitButtonTemplate");
AUF_TargetFrame = CreateFrame("Button", nil, UIParent, "AUFUnitButtonTemplate");
AUF_FocusFrame = CreateFrame("Button", nil, UIParent, "AUFUnitButtonTemplate");
AUF_PetFrame = CreateFrame("Button", nil, UIParent, "AUFUnitButtonTemplate");
AUF_TargetTargetFrame = CreateFrame("Button", nil, UIParent, "AUFUnitButtonTemplate");


CreateUnitFrame(AUF_PlayerFrame, "player", -xposition, yposition, 200, healthheight, 0, 12, false);
CreateUnitFrame(AUF_TargetFrame, "target", xposition, yposition, 200, healthheight, powerheight, 12, false);
CreateUnitFrame(AUF_FocusFrame, "focus", xposition + 200, yposition, 150, 20, 3, 11, false);
CreateUnitFrame(AUF_PetFrame, "pet", -xposition - 50, yposition - 40, 100, 15, 2, 9, true);
CreateUnitFrame(AUF_TargetTargetFrame, "targettarget", xposition + 50, yposition - 40, 100, 15, 2, 9, true);

AUF_BossFrames = {};
if (MAX_BOSS_FRAMES) then
    for i = 1, MAX_BOSS_FRAMES do
        AUF_BossFrames[i] = CreateFrame("Button", nil, UIParent, "AUFUnitButtonTemplate");
        CreateUnitFrame(AUF_BossFrames[i], "boss" .. i, xposition + 250, 200 - (i - 1) * 70, 150, 20, 3, 11);
    end
end


C_AddOns.LoadAddOn("asMOD");

if asMOD_setupFrame then
    asMOD_setupFrame(AUF_PlayerFrame, "AUF_PlayerFrame");
    asMOD_setupFrame(AUF_TargetFrame, "AUF_TargetFrame");
    asMOD_setupFrame(AUF_FocusFrame, "AUF_FocusFrame");
    asMOD_setupFrame(AUF_PetFrame, "AUF_PetFrame");
    asMOD_setupFrame(AUF_TargetTargetFrame, "AUF_TargetTargetFrame");

    if (MAX_BOSS_FRAMES) then
        for i = 1, MAX_BOSS_FRAMES do            
            asMOD_setupFrame(AUF_BossFrames[i], "AUF_BossFrame"..i);            
        end
    end
end


-- stolen from cell, which is stolen from elvui
local hiddenParent = CreateFrame("Frame", nil, _G.UIParent)
hiddenParent:SetAllPoints()
hiddenParent:Hide()

local function HideFrame(frame)
    if not frame then return end

    frame:UnregisterAllEvents()
    frame:Hide()
    frame:SetParent(hiddenParent)

    local health = frame.healthBar or frame.healthbar
    if health then
        health:UnregisterAllEvents()
    end

    local power = frame.manabar
    if power then
        power:UnregisterAllEvents()
    end

    local spell = frame.castBar or frame.spellbar
    if spell then
        spell:UnregisterAllEvents()
    end

    local altpowerbar = frame.powerBarAlt
    if altpowerbar then
        altpowerbar:UnregisterAllEvents()
    end

    local buffFrame = frame.BuffFrame
    if buffFrame then
        buffFrame:UnregisterAllEvents()
    end

    local petFrame = frame.PetFrame
    if petFrame then
        petFrame:UnregisterAllEvents()
    end
end

local function HideBlizzardUnitFrame(unit)
    if unit == "player" and _G.PlayerFrame then
        HideFrame(_G.PlayerFrame)
    elseif unit == "target" and _G.TargetFrame then
        HideFrame(_G.TargetFrame)
    elseif unit == "focus" and _G.FocusFrame then
        HideFrame(_G.FocusFrame)
    elseif unit == "pet" and _G.PetFrame then
        HideFrame(_G.PetFrame)
    end
end

local function HideDefaults()
    HideBlizzardUnitFrame("player");
    HideBlizzardUnitFrame("target");
    HideBlizzardUnitFrame("focus");
    HideBlizzardUnitFrame("pet");

    if (MAX_BOSS_FRAMES) then
        for i = 1, MAX_BOSS_FRAMES do
            local bossframe = _G["Boss" .. i .. "TargetFrame"];

            if bossframe then
                HideFrame(bossframe);
            end
        end
    end
end

HideDefaults();

local DangerousSpellList = {};

local function updateCastBar(frame)
    local castbar    = frame.castbar;
    local frameIcon  = castbar.button.icon;
    local text       = castbar.name;
    local time       = castbar.time;
    local targetname = castbar.targetname;
    local unit       = frame.unit;
    local unittarget = unit .. "target";

    if UnitExists(unit) then
        local bchanneling = false;
        local name, _, texture, start, endTime, isTradeSkill, castID, notInterruptible, spellid = UnitCastingInfo(
            unit);

        if not name then
            bchanneling = true;
            name, _, texture, start, endTime, isTradeSkill, notInterruptible, spellid = UnitChannelInfo(unit);
        end

        if name then
            local current = GetTime();
            frameIcon:SetTexture(texture);

            castbar.start = start / 1000;
            castbar.duration = (endTime - start) / 1000;
            castbar.bchanneling = bchanneling;
           
            castbar:SetMinMaxValues(0, castbar.duration)

            if bchanneling then
                castbar:SetValue(castbar.start + castbar.duration - current);
            else
                castbar:SetValue(current - castbar.start);
            end
            

            local color = {};

            if UnitIsUnit(unittarget, "player") then
                if notInterruptible then
                    color = CONFIG_NOT_INTERRUPTIBLE_COLOR_TARGET;
                else
                    color = CONFIG_INTERRUPTIBLE_COLOR_TARGET;
                end
            else
                if notInterruptible then
                    color = CONFIG_NOT_INTERRUPTIBLE_COLOR;
                else
                    color = CONFIG_INTERRUPTIBLE_COLOR;
                end
            end

            castbar.castspellid = spellid;

            castbar:SetStatusBarColor(color[1], color[2], color[3]);

            text:SetText(name);
            time:SetText(format("%.1f/%.1f", max((current - castbar.start), 0), max(castbar.duration, 0)));

            frameIcon:Show();
            castbar:Show();
            if DangerousSpellList[spellid] and DangerousSpellList[spellid] == "interrupt" then
                ns.lib.PixelGlow_Start(castBar, { 1, 1, 0, 1 });
            end

            if UnitExists(unittarget) and UnitIsPlayer(unittarget) then
                local _, Class = UnitClass(unittarget)
                local color = RAID_CLASS_COLORS[Class]
                targetname:SetTextColor(color.r, color.g, color.b);
                targetname:SetText(UnitName(unittarget));
                targetname:Show();
            else
                targetname:SetText("");
                targetname:Hide();
            end
        else
            castbar:SetValue(0);
            frameIcon:Hide();
            castbar:Hide();
            ns.lib.PixelGlow_Stop(castbar);
            castbar.start = 0;
            targetname:SetText("");
            targetname:Hide();
        end
    else
        castbar:SetValue(0);
        frameIcon:Hide();
        castbar:Hide();
        ns.lib.PixelGlow_Stop(castbar);
        castbar.start = 0;
        targetname:SetText("");
        targetname:Hide();
    end
end

local function AUF_OnEventSpell(self, event, arg1, arg2, arg3)
    updateCastBar(self);
end

local function RegisterAll(frame, unit)
    if UnitExists(unit) then
        frame:RegisterUnitEvent("UNIT_SPELLCAST_INTERRUPTED", unit);
        frame:RegisterUnitEvent("UNIT_SPELLCAST_DELAYED", unit);
        frame:RegisterUnitEvent("UNIT_SPELLCAST_CHANNEL_START", unit);
        frame:RegisterUnitEvent("UNIT_SPELLCAST_CHANNEL_UPDATE", unit);
        frame:RegisterUnitEvent("UNIT_SPELLCAST_CHANNEL_STOP", unit);
        frame:RegisterUnitEvent("UNIT_SPELLCAST_EMPOWER_START", unit);
        frame:RegisterUnitEvent("UNIT_SPELLCAST_EMPOWER_UPDATE", unit);
        frame:RegisterUnitEvent("UNIT_SPELLCAST_EMPOWER_STOP", unit);
        frame:RegisterUnitEvent("UNIT_SPELLCAST_INTERRUPTIBLE", unit);
        frame:RegisterUnitEvent("UNIT_SPELLCAST_NOT_INTERRUPTIBLE", unit);
        frame:RegisterUnitEvent("UNIT_SPELLCAST_START", unit);
        frame:RegisterUnitEvent("UNIT_SPELLCAST_STOP", unit);
        frame:RegisterUnitEvent("UNIT_SPELLCAST_FAILED", unit);
        frame:RegisterUnitEvent("UNIT_TARGET", unit);
        frame:SetScript("OnEvent", AUF_OnEventSpell);
        updateCastBar(frame);
    else
        frame:UnregisterEvent("UNIT_SPELLCAST_INTERRUPTED");
        frame:UnregisterEvent("UNIT_SPELLCAST_DELAYED");
        frame:UnregisterEvent("UNIT_SPELLCAST_CHANNEL_START");
        frame:UnregisterEvent("UNIT_SPELLCAST_CHANNEL_UPDATE");
        frame:UnregisterEvent("UNIT_SPELLCAST_CHANNEL_STOP");
        frame:UnregisterEvent("UNIT_SPELLCAST_EMPOWER_START");
        frame:UnregisterEvent("UNIT_SPELLCAST_EMPOWER_UPDATE");
        frame:UnregisterEvent("UNIT_SPELLCAST_EMPOWER_STOP");
        frame:UnregisterEvent("UNIT_SPELLCAST_INTERRUPTIBLE");
        frame:UnregisterEvent("UNIT_SPELLCAST_NOT_INTERRUPTIBLE");
        frame:UnregisterEvent("UNIT_SPELLCAST_START");
        frame:UnregisterEvent("UNIT_SPELLCAST_STOP");
        frame:UnregisterEvent("UNIT_SPELLCAST_FAILED");
        frame:UnregisterEvent("UNIT_TARGET");
        frame:SetScript("OnEvent", nil);
    end
end

local function AUF_OnEvent(self, event, arg1, arg2, arg3)
    if event == "PLAYER_FOCUS_CHANGED" then
        RegisterAll(AUF_FocusFrame, "focus");
    elseif event == "INSTANCE_ENCOUNTER_ENGAGE_UNIT" then
        if (MAX_BOSS_FRAMES) then
            for i = 1, MAX_BOSS_FRAMES do
                RegisterAll(AUF_BossFrames[i], "boss"..i);
            end
        end
    elseif event == "PLAYER_ENTERING_WORLD" then
        RegisterAll(AUF_FocusFrame, "focus");
        if (MAX_BOSS_FRAMES) then
            for i = 1, MAX_BOSS_FRAMES do
                RegisterAll(AUF_BossFrames[i], "boss"..i);
            end
        end
        HideDefaults();
    end

    return;
end

local AUF = CreateFrame("Frame")
AUF:SetScript("OnEvent", AUF_OnEvent)
AUF:RegisterEvent("PLAYER_ENTERING_WORLD");
AUF:RegisterEvent("PLAYER_FOCUS_CHANGED");
AUF:RegisterEvent("INSTANCE_ENCOUNTER_ENGAGE_UNIT");

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

local bloaded = C_AddOns.LoadAddOn("DBM-Core");
if bloaded then
    hooksecurefunc(DBM, "NewMod", NewMod)
end