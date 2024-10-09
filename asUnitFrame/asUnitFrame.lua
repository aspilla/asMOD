local _, ns = ...;

local function CreateUnitFrame(frame, unit, x, y, width, height, powerbarheight, fontsize)
    local Font = "Fonts\\2002.TTF";
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
    frame.healthbar.pvalue:SetFont(Font, fontsize + 1, FontOutline);
    frame.healthbar.pvalue:SetTextColor(1, 1, 1, 1)

    frame.healthbar.hvalue = frame.healthbar:CreateFontString(nil, "ARTWORK");
    frame.healthbar.hvalue:SetFont(Font, fontsize - 1, FontOutline);
    frame.healthbar.hvalue:SetTextColor(1, 1, 1, 1)

    frame.healthbar.name = frame.healthbar:CreateFontString(nil, "ARTWORK");
    frame.healthbar.name:SetFont(Font, fontsize - 1, FontOutline);
    frame.healthbar.name:SetTextColor(1, 1, 1, 1)

    if x < 0 then
        frame.healthbar.pvalue:SetPoint("LEFT", frame.healthbar, "LEFT", 2, 0);
        frame.healthbar.hvalue:SetPoint("RIGHT", frame.healthbar, "RIGHT", -2, 0);
        frame.healthbar.name:SetPoint("BOTTOMLEFT", frame.healthbar, "TOPLEFT", 2, 1);
    else
        frame.healthbar.pvalue:SetPoint("RIGHT", frame.healthbar, "RIGHT", -2, 0);
        frame.healthbar.hvalue:SetPoint("LEFT", frame.healthbar, "LEFT", 2, 0);
        frame.healthbar.name:SetPoint("BOTTOMRIGHT", frame.healthbar, "TOPRIGHT", -2, 1);
    end

    frame.healthbar.mark = frame.healthbar:CreateFontString(nil, "ARTWORK");
    frame.healthbar.mark:SetFont(Font, fontsize, FontOutline);
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
    frame.powerbar.value:SetFont(Font, fontsize - 2, FontOutline);
    frame.powerbar.value:SetTextColor(1, 1, 1, 1)
    frame.powerbar.value:SetPoint("CENTER", frame.powerbar, "CENTER", 0, 0);

    frame.unit = unit;
    -- 유닛 설정 (예시: 'player' 또는 'target' 등)
    frame:SetAttribute("unit", unit)

    local function OpenContextMenu(frame, unit, button, isKeyPress)
        local which = nil;
        local contextData = {
            fromPlayerFrame = true,
        };



        if frame.unit == "vehicle" then
            which = "VEHICLE";
            contextData.unit = "vehicle";
        elseif frame.unit == "player" then
            which = "SELF";
            contextData.unit = frame.unit;
        else
            which            = "SELF";
            contextData      = {};
            contextData.unit = frame.unit;
        end
        UnitPopup_OpenMenu(which, contextData);
    end

    SecureUnitButton_OnLoad(frame, frame.unit, OpenContextMenu);
    --frame:RegisterForClicks("AnyUp")

    frame:Show();
end
local xposition = 224;
local yposition = -195;
local healthheight = 35;
local powerheight = 5;
AUF_PlayerFrame = CreateFrame("Button", nil, UIParent, "SecureUnitButtonTemplate", "PingableUnitFrameTemplate");
AUF_TargetFrame = CreateFrame("Button", nil, UIParent, "SecureUnitButtonTemplate", "PingableUnitFrameTemplate");
AUF_FocusFrame = CreateFrame("Button", nil, UIParent, "SecureUnitButtonTemplate", "PingableUnitFrameTemplate");
AUF_PetFrame = CreateFrame("Button", nil, UIParent, "SecureUnitButtonTemplate", "PingableUnitFrameTemplate");
AUF_TargetTargetFrame = CreateFrame("Button", nil, UIParent, "SecureUnitButtonTemplate",
    "PingableUnitFrameTemplate");
CreateUnitFrame(AUF_PlayerFrame, "player", -xposition, yposition, 200, healthheight, 0, 12);
CreateUnitFrame(AUF_TargetFrame, "target", xposition, yposition, 200, healthheight, powerheight, 12);
CreateUnitFrame(AUF_FocusFrame, "focus", xposition + 200, yposition, 150, 20, 3, 11);
CreateUnitFrame(AUF_PetFrame, "pet", -xposition - 50, yposition - 40, 100, 15, 2, 9);
CreateUnitFrame(AUF_TargetTargetFrame, "targettarget", xposition + 50, yposition - 40, 100, 15, 2, 9);


C_AddOns.LoadAddOn("asMOD");

if asMOD_setupFrame then
    asMOD_setupFrame(AUF_PlayerFrame, "AUF_PlayerFrame");
    asMOD_setupFrame(AUF_TargetFrame, "AUF_TargetFrame");
    asMOD_setupFrame(AUF_FocusFrame, "AUF_FocusFrame");
    asMOD_setupFrame(AUF_PetFrame, "AUF_PetFrame");
    asMOD_setupFrame(AUF_TargetTargetFrame, "AUF_TargetTargetFrame");
end

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

local function updateUnit(frame)
    local unit = frame.unit;

    if unit == "player" then
        unit = unit_player;
    elseif unit == "pet" then
        unit = unit_pet;
    end

    if not UnitExists(unit) then
        frame:SetAlpha(0);
        return;
    else
        frame:SetAlpha(1);
    end

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
    local unitlevel = UnitLevel(unit);
    if unitlevel < 0 then
        unitlevel = "??"
    end

    local mark = "";
    local icon = GetRaidTargetIndex(unit)
    if icon and RaidIconList[icon] then
        mark = RaidIconList[icon] .. "0|t"
    end

    frame.healthbar.hvalue:SetText(AbbreviateLargeNumbers(value))
    frame.healthbar.name:SetText(unitlevel .. " " .. UnitName(unit));
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

        if unit == "player" then
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
end

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

local function OnUpdate()
    UpdatePlayerUnit();
    updateUnit(AUF_PlayerFrame);
    updateUnit(AUF_TargetFrame);
    updateUnit(AUF_FocusFrame);
    updateUnit(AUF_PetFrame);
    updateUnit(AUF_TargetTargetFrame);
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
end

C_Timer.NewTicker(0.1, OnUpdate);
HideDefaults();


local function AUF_OnEvent(self, event, arg1, arg2, arg3)
    HideDefaults();
    return;
end

local AUF = CreateFrame("Frame")
AUF:SetScript("OnEvent", AUF_OnEvent)
AUF:RegisterEvent("PLAYER_ENTERING_WORLD");
