local _, ns = ...;

local configs = {
    combatalpha = 1,
    normalalpha = 0.5,
    updaterate = 0.2,    
};

local main_frame = CreateFrame("Frame", "asInformationFrame", UIParent);
main_frame:SetFrameStrata("LOW");
main_frame:SetSize(100, 100);
main_frame:SetPoint("CENTER", UIParent, "CENTER", -165, -300);
main_frame:SetMovable(true);
main_frame:RegisterForDrag("LeftButton");


-- Saved variables for position, lock state, and stat thresholds
local defaultOptions = {
    point = "TOP",
    relativePoint = "CENTER",
    xOfs = -165,
    yOfs = -250,
    isLocked = true,    
    showHaste = true,
    showCrit = true,
    showMastery = true,
    showVer = true,
    showPrimary = true, -- Add new option for primary stat
    version = 260103,
}


-- Localization
local L = {}
local locale = GetLocale()

-- Stat Configurations
local statConfigs = {
    Stat = { abbr = "S", gemColor = { r = 1, g = 1, b = 0 } },
    Crit = { abbr = "C", gemColor = { r = 1, g = 0, b = 0 } },
    Haste = { abbr = "H", gemColor = { r = 0, g = 1, b = 0 } },
    Mastery = { abbr = "M", gemColor = { r = 0.5, g = 0, b = 1 } },
    Versatility = { abbr = "V", gemColor = { r = 0, g = 0, b = 1 } }
}

local defaultBarColor = { r = 0.5, g = 0.5, b = 0.5 }
local activatedTextColor = { r = 1, g = 1, b = 1 }

-- New data structures for tracking minimum stats over time
local statHistory = { Stat = {}, Crit = {}, Haste = {}, Mastery = {}, Versatility = {} }
local recentMinimumStats = { Stat = nil, Crit = nil, Haste = nil, Mastery = nil, Versatility = nil }

if locale == "koKR" then
    L["Lock Frame"] = "프레임 잠금"
    L["State Threshold"] = "알림 임계값"
    L["Show Haste"] = "가속 표시"
    L["Show Crit"] = "크리 표시"
    L["Show Mastery"] = "특화 표시"
    L["Show Ver"] = "유연 표시"
    L["Show Primary"] = "주요 스탯 표시"
else -- Default to English
    L["Lock Frame"] = "Lock Frame"
    L["State Threshold"] = "Alert Threshold"
    L["Show Haste"] = "Show Haste"
    L["Show Crit"] = "Show Crit"
    L["Show Mastery"] = "Show Mastery"
    L["Show Ver"] = "Show Ver"
    L["Show Primary"] = "Show Primary Stat"
end

-- Function to load saved position
local function load_position()
    main_frame:ClearAllPoints()
    main_frame:SetPoint(ASInformationSaved.point, UIParent, ASInformationSaved.relativePoint, ASInformationSaved.xOfs,
        ASInformationSaved.yOfs)
end

-- Function to save position
local function save_position()
    local point, _, relativePoint, xOfs, yOfs = main_frame:GetPoint()
    ASInformationSaved.point = point
    ASInformationSaved.relativePoint = relativePoint
    ASInformationSaved.xOfs = xOfs
    ASInformationSaved.yOfs = yOfs
end


local function init_frames()
    local prevframe = main_frame
    -- Declare variables for bars and their texts
    local locationPoint = "TOPLEFT"; -- Initial anchor point for the first element

    local barWidth = 90
    local barHeight = 12
    local yOffset = -5 -- Offset between bars
    -- Primary Stat Bar
    ns.primarybar = CreateFrame("StatusBar", "asInformationPrimaryStatBar", main_frame);
    ns.primarybar:SetSize(barWidth, barHeight)
    ns.primarybar:SetPoint(locationPoint, prevframe, (prevframe == main_frame and "TOPLEFT" or "BOTTOMLEFT"), 0,
        yOffset)
    ns.primarybar:SetStatusBarTexture("RaidFrame-Hp-Fill")
    ns.primarybar:SetStatusBarColor(statConfigs.Stat.gemColor.r, statConfigs.Stat.gemColor.g,
        statConfigs.Stat.gemColor.b);


    ns.primarybar_min = CreateFrame("StatusBar", nil, main_frame);
    ns.primarybar_min:SetSize(barWidth, barHeight)
    ns.primarybar_min:SetPoint(locationPoint, prevframe, (prevframe == main_frame and "TOPLEFT" or "BOTTOMLEFT"), 0,
        yOffset)
    ns.primarybar_min:SetStatusBarTexture("RaidFrame-Hp-Fill")
    ns.primarybar_min:SetStatusBarColor(defaultBarColor.r, defaultBarColor.g, defaultBarColor.b);
    ns.primarybar_min:SetFrameLevel(ns.primarybar:GetFrameLevel() + 10);


    ns.primarybar.bg = ns.primarybar:CreateTexture(nil, "BACKGROUND")
    ns.primarybar.bg:SetPoint("TOPLEFT", ns.primarybar, "TOPLEFT", -1, 1)
    ns.primarybar.bg:SetPoint("BOTTOMRIGHT", ns.primarybar, "BOTTOMRIGHT", 1, -1)
    ns.primarybar.bg:SetColorTexture(0, 0, 0, 1);

    ns.primarytext = ns.primarybar_min:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    ns.primarytext:SetPoint("RIGHT", ns.primarybar_min, "RIGHT", -1, 0)
    ns.primarytext:SetTextColor(statConfigs.Stat.gemColor.r, statConfigs.Stat.gemColor.g, statConfigs.Stat.gemColor
        .b)

    -- Primary stat color will be set dynamically

    ns.primarybar.name = ns.primarybar_min:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    ns.primarybar.name:SetPoint("LEFT", ns.primarybar_min, "LEFT", 1, 0)
    ns.primarybar.name:SetTextColor(1, 1, 1);
    ns.primarybar.name:SetText(statConfigs.Stat.abbr)
    -- Primary stat name will be set dynamically

    prevframe = ns.primarybar
    yOffset = -2

    ns.critbar = CreateFrame("StatusBar", "asInformationCritBar", main_frame);
    ns.critbar:SetSize(barWidth, barHeight)
    ns.critbar:SetPoint(locationPoint, prevframe, (prevframe == main_frame and "TOPLEFT" or "BOTTOMLEFT"), 0,
        yOffset)
    ns.critbar:SetStatusBarTexture("RaidFrame-Hp-Fill")
    ns.critbar:SetStatusBarColor(statConfigs.Crit.gemColor.r, statConfigs.Crit.gemColor.g, statConfigs.Crit.gemColor.b);

    ns.critbar_min = CreateFrame("StatusBar", nil, main_frame);
    ns.critbar_min:SetSize(barWidth, barHeight)
    ns.critbar_min:SetPoint(locationPoint, prevframe, (prevframe == main_frame and "TOPLEFT" or "BOTTOMLEFT"), 0,
        yOffset)
    ns.critbar_min:SetStatusBarTexture("RaidFrame-Hp-Fill")
    ns.critbar_min:SetStatusBarColor(defaultBarColor.r, defaultBarColor.g, defaultBarColor.b)

    ns.critbar_min:SetFrameLevel(ns.critbar:GetFrameLevel() + 10);

    ns.critbar.bg = ns.critbar:CreateTexture(nil, "BACKGROUND")
    ns.critbar.bg:SetPoint("TOPLEFT", ns.critbar, "TOPLEFT", -1, 1)
    ns.critbar.bg:SetPoint("BOTTOMRIGHT", ns.critbar, "BOTTOMRIGHT", 1, -1)
    ns.critbar.bg:SetColorTexture(0, 0, 0, 1);

    ns.crittext = ns.critbar_min:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    ns.crittext:SetPoint("RIGHT", ns.critbar_min, "RIGHT", -1, 0)
    ns.crittext:SetTextColor(statConfigs.Crit.gemColor.r, statConfigs.Crit.gemColor.g, statConfigs.Crit.gemColor.b)

    ns.critbar.name = ns.critbar_min:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    ns.critbar.name:SetPoint("LEFT", ns.critbar_min, "LEFT", 1, 0)
    ns.critbar.name:SetTextColor(1, 1, 1);
    ns.critbar.name:SetText(statConfigs.Crit.abbr);

    prevframe = ns.critbar -- Next element anchors to this bar
    yOffset = -2           -- Smaller gap for subsequent bars

    ns.hastebar = CreateFrame("StatusBar", "asInformationHasteBar", main_frame);
    ns.hastebar:SetSize(barWidth, barHeight)
    ns.hastebar:SetPoint(locationPoint, prevframe, (prevframe == main_frame and "TOPLEFT" or "BOTTOMLEFT"), 0, yOffset)
    ns.hastebar:SetStatusBarTexture("RaidFrame-Hp-Fill")
    ns.hastebar:SetStatusBarColor(statConfigs.Haste.gemColor.r, statConfigs.Haste.gemColor.g,
        statConfigs.Haste.gemColor.b)

    ns.hastebar_min = CreateFrame("StatusBar", nil, main_frame);
    ns.hastebar_min:SetSize(barWidth, barHeight)
    ns.hastebar_min:SetPoint(locationPoint, prevframe, (prevframe == main_frame and "TOPLEFT" or "BOTTOMLEFT"), 0,
        yOffset)
    ns.hastebar_min:SetStatusBarTexture("RaidFrame-Hp-Fill")
    ns.hastebar_min:SetStatusBarColor(defaultBarColor.r, defaultBarColor.g, defaultBarColor.b)
    ns.hastebar_min:SetFrameLevel(ns.hastebar:GetFrameLevel() + 10);

    ns.hastebar.bg = ns.hastebar:CreateTexture(nil, "BACKGROUND")
    ns.hastebar.bg:SetPoint("TOPLEFT", ns.hastebar, "TOPLEFT", -1, 1)
    ns.hastebar.bg:SetPoint("BOTTOMRIGHT", ns.hastebar, "BOTTOMRIGHT", 1, -1)
    ns.hastebar.bg:SetColorTexture(0, 0, 0, 1);

    ns.hastetext = ns.hastebar_min:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    ns.hastetext:SetPoint("RIGHT", ns.hastebar_min, "RIGHT", -1, 0)
    ns.hastetext:SetTextColor(statConfigs.Haste.gemColor.r, statConfigs.Haste.gemColor.g, statConfigs.Haste.gemColor.b)

    ns.hastebar.name = ns.hastebar_min:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    ns.hastebar.name:SetPoint("LEFT", ns.hastebar_min, "LEFT", 1, 0)
    ns.hastebar.name:SetTextColor(1, 1, 1)
    ns.hastebar.name:SetText(statConfigs.Haste.abbr);

    prevframe = ns.hastebar
    yOffset = -2

    ns.masterybar = CreateFrame("StatusBar", "asInformationMasteryBar", main_frame);
    ns.masterybar:SetSize(barWidth, barHeight)
    ns.masterybar:SetPoint(locationPoint, prevframe, (prevframe == main_frame and "TOPLEFT" or "BOTTOMLEFT"), 0, yOffset)
    ns.masterybar:SetStatusBarTexture("RaidFrame-Hp-Fill")
    ns.masterybar:SetStatusBarColor(statConfigs.Mastery.gemColor.r, statConfigs.Mastery.gemColor.g,
        statConfigs.Mastery.gemColor.b)

    ns.masterybar_min = CreateFrame("StatusBar", nil, main_frame);
    ns.masterybar_min:SetSize(barWidth, barHeight)
    ns.masterybar_min:SetPoint(locationPoint, prevframe, (prevframe == main_frame and "TOPLEFT" or "BOTTOMLEFT"), 0,
        yOffset)
    ns.masterybar_min:SetStatusBarTexture("RaidFrame-Hp-Fill")
    ns.masterybar_min:SetStatusBarColor(defaultBarColor.r, defaultBarColor.g, defaultBarColor.b)
    ns.masterybar_min:SetFrameLevel(ns.masterybar:GetFrameLevel() + 10);

    ns.masterybar.bg = ns.masterybar:CreateTexture(nil, "BACKGROUND")
    ns.masterybar.bg:SetPoint("TOPLEFT", ns.masterybar, "TOPLEFT", -1, 1)
    ns.masterybar.bg:SetPoint("BOTTOMRIGHT", ns.masterybar, "BOTTOMRIGHT", 1, -1)
    ns.masterybar.bg:SetColorTexture(0, 0, 0, 1);

    ns.masterytext = ns.masterybar_min:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    ns.masterytext:SetPoint("RIGHT", ns.masterybar_min, "RIGHT", -1, 0)
    ns.masterytext:SetTextColor(statConfigs.Mastery.gemColor.r, statConfigs.Mastery.gemColor.g,
        statConfigs.Mastery.gemColor.b)
    ns.masterybar.name = ns.masterybar_min:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    ns.masterybar.name:SetPoint("LEFT", ns.masterybar_min, "LEFT", 1, 0)
    ns.masterybar.name:SetTextColor(1, 1, 1);
    ns.masterybar.name:SetText(statConfigs.Mastery.abbr);
    prevframe = ns.masterybar
    yOffset = -2

    ns.versbar = CreateFrame("StatusBar", "asInformationVersatilityBar", main_frame);
    ns.versbar:SetSize(barWidth, barHeight)
    ns.versbar:SetPoint(locationPoint, prevframe, (prevframe == main_frame and "TOPLEFT" or "BOTTOMLEFT"), 0,
        yOffset)
    ns.versbar:SetStatusBarTexture("RaidFrame-Hp-Fill")
    ns.versbar:SetStatusBarColor(statConfigs.Versatility.gemColor.r, statConfigs.Versatility.gemColor.g,
        statConfigs.Versatility.gemColor.b);

    ns.versbar_min = CreateFrame("StatusBar", nil, main_frame);
    ns.versbar_min:SetSize(barWidth, barHeight)
    ns.versbar_min:SetPoint(locationPoint, prevframe, (prevframe == main_frame and "TOPLEFT" or "BOTTOMLEFT"), 0,
        yOffset)
    ns.versbar_min:SetStatusBarTexture("RaidFrame-Hp-Fill")
    ns.versbar_min:SetStatusBarColor(defaultBarColor.r, defaultBarColor.g, defaultBarColor.b)
    ns.versbar_min:SetFrameLevel(ns.versbar:GetFrameLevel() + 10);


    ns.versbar.bg = ns.versbar:CreateTexture(nil, "BACKGROUND")
    ns.versbar.bg:SetPoint("TOPLEFT", ns.versbar, "TOPLEFT", -1, 1)
    ns.versbar.bg:SetPoint("BOTTOMRIGHT", ns.versbar, "BOTTOMRIGHT", 1, -1)
    ns.versbar.bg:SetColorTexture(0, 0, 0, 1);

    ns.verstext = ns.versbar_min:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    ns.verstext:SetPoint("RIGHT", ns.versbar_min, "RIGHT", -1, 0)
    ns.verstext:SetTextColor(statConfigs.Versatility.gemColor.r, statConfigs.Versatility.gemColor.g,
        statConfigs.Versatility.gemColor.b)
    ns.versbar.name = ns.versbar_min:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    ns.versbar.name:SetPoint("LEFT", ns.versbar_min, "LEFT", 1, 0)
    ns.versbar.name:SetTextColor(1, 1, 1);
    ns.versbar.name:SetText(statConfigs.Versatility.abbr);

    prevframe = ns.versbar
    yOffset = -2
end

local bMouseEnabled = true;
local needReposition = true;

-- Function to get primary stat based on class, inspired by PaperDollFrame.lua
local function get_primarystat()
    local currspec = C_SpecializationInfo.GetSpecialization() or 1;
    local primaryStatID = select(6, C_SpecializationInfo.GetSpecializationInfo(currspec)) or 1;
    local primaryStatValue = UnitStat("player", primaryStatID);

    return primaryStatValue;
end

local critfunc = nil;

local function get_crit()
    if UnitAffectingCombat("player") then
        if critfunc then
            return critfunc();
        end
        return 0;
    end

    --PaperDollFrame_SetCritChance
    local spellCrit, rangedCrit, meleeCrit;
    local critChance;

    -- Start at 2 to skip physical damage
    spellCrit = GetSpellCritChance();
    rangedCrit = GetRangedCritChance();
    meleeCrit = GetCritChance();

    if issecretvalue(rangedCrit) or issecretvalue(spellCrit) or issecretvalue(meleeCrit) then
        if critfunc then
            return critfunc();
        end
        return 0;
    end

    if (spellCrit >= rangedCrit and spellCrit >= meleeCrit) then
        critfunc = GetSpellCritChance;
        critChance = spellCrit;
    elseif (rangedCrit >= meleeCrit) then
        critfunc = GetRangedCritChance;
        critChance = rangedCrit;
    else
        critfunc = GetCritChance;
        critChance = meleeCrit;
    end

    return critChance;
end

-- Function to record current stat values into history
local function recode_stats()
    local inCombat = UnitAffectingCombat("player");

    if not inCombat then
        local currentStats = {
            Stat = get_primarystat(),
            Crit = get_crit(),
            Haste = GetHaste(),
            Mastery = GetMasteryEffect(),
            Versatility = GetCombatRatingBonus(CR_VERSATILITY_DAMAGE_DONE),
        }

        for statName, value in pairs(currentStats) do
            local snapshot = { value = value }
            table.insert(statHistory[statName], 1, snapshot)

            local numList = #statHistory[statName];

            if numList > 100 then
                table.remove(statHistory[statName], numList);
            end
        end

        for statName, history in pairs(statHistory) do
            -- Calculate minimum from combat snapshots
            local minStat = nil
            for _, snapshot in ipairs(history) do
                if not issecretvalue(snapshot.value) and (minStat == nil or (snapshot.value < minStat and snapshot.value > 0)) then
                    minStat = snapshot.value
                end
            end
            recentMinimumStats[statName] = minStat
        end
    end
end

local function update_stats()
    if needReposition then
        needReposition = false;

        local prevframe = main_frame;
        local yOffset = -5;

        if ASInformationSaved.showPrimary then
            ns.primarybar:SetPoint("TOPLEFT", prevframe, (prevframe == main_frame and "TOPLEFT" or "BOTTOMLEFT"), 0,
                yOffset);
            ns.primarybar:Show();
            prevframe = ns.primarybar;
            yOffset = -2;
        else
            ns.primarybar:Hide();
        end

        if ASInformationSaved.showCrit then
            ns.critbar:SetPoint("TOPLEFT", prevframe, (prevframe == main_frame and "TOPLEFT" or "BOTTOMLEFT"), 0, yOffset);
            ns.critbar:Show();
            prevframe = ns.critbar;
            yOffset = -2;
        else
            ns.critbar:Hide();
        end

        if ASInformationSaved.showHaste then
            ns.hastebar:SetPoint("TOPLEFT", prevframe, (prevframe == main_frame and "TOPLEFT" or "BOTTOMLEFT"), 0,
                yOffset);
            ns.hastebar:Show();
            prevframe = ns.hastebar;
            yOffset = -2;
        else
            ns.hastebar:Hide();
        end

        if ASInformationSaved.showMastery then
            ns.masterybar:SetPoint("TOPLEFT", prevframe, (prevframe == main_frame and "TOPLEFT" or "BOTTOMLEFT"), 0,
                yOffset);
            ns.masterybar:Show();
            prevframe = ns.masterybar;
            yOffset = -2;
        else
            ns.masterybar:Hide();
        end

        if ASInformationSaved.showVer then
            ns.versbar:SetPoint("TOPLEFT", prevframe, (prevframe == main_frame and "TOPLEFT" or "BOTTOMLEFT"), 0,
                yOffset);
            ns.versbar:Show();
            prevframe = ns.versbar;
            yOffset = -2;
        else
            ns.versbar:Hide();
        end
    end

    local haste = GetHaste()
    local crit = get_crit()
    local mastery = GetMasteryEffect()
    local versatility = GetCombatRatingBonus(CR_VERSATILITY_DAMAGE_DONE);
    local primaryStatValue = get_primarystat()

    if ASInformationSaved.showCrit then
        if ns.critbar and ns.crittext then     -- Check if bar and text elements exist
            ns.critbar:SetMinMaxValues(0, 100) -- Assuming stats are percentage based 0-100
            ns.critbar:SetValue(crit, Enum.StatusBarInterpolation.ExponentialEaseOut)
            ns.crittext:SetText(string.format("%.2f%%", crit));

            local minCrit = recentMinimumStats.Crit or 0
            ns.critbar_min:SetMinMaxValues(0, 100) -- Assuming stats are percentage based 0-100
            ns.critbar_min:SetValue(minCrit, Enum.StatusBarInterpolation.ExponentialEaseOut);
        end
    end

    if ASInformationSaved.showHaste then
        if ns.hastebar and ns.hastetext then -- Check if bar and text elements exist
            ns.hastebar:SetMinMaxValues(0, 100)
            ns.hastebar:SetValue(haste, Enum.StatusBarInterpolation.ExponentialEaseOut)
            ns.hastetext:SetText(string.format("%.2f%%", haste))

            local minHaste = recentMinimumStats.Haste or 0;

            ns.hastebar_min:SetMinMaxValues(0, 100)
            ns.hastebar_min:SetValue(minHaste, Enum.StatusBarInterpolation.ExponentialEaseOut);
        end
    end

    if ASInformationSaved.showMastery then
        if ns.masterybar and ns.masterytext then -- Check if bar and text elements exist
            ns.masterybar:SetMinMaxValues(0, 100)
            ns.masterybar:SetValue(mastery, Enum.StatusBarInterpolation.ExponentialEaseOut)
            ns.masterytext:SetText(string.format("%.2f%%", mastery))

            local minMastery = recentMinimumStats.Mastery or 0;

            ns.masterybar_min:SetMinMaxValues(0, 100)
            ns.masterybar_min:SetValue(minMastery, Enum.StatusBarInterpolation.ExponentialEaseOut);
        end
    end

    if ASInformationSaved.showVer then
        if ns.versbar and ns.verstext then -- Check if bar and text elements exist
            ns.versbar:SetMinMaxValues(0, 100)
            ns.versbar:SetValue(versatility, Enum.StatusBarInterpolation.ExponentialEaseOut)
            ns.verstext:SetText(string.format("%.2f%%", versatility))

            local minVersatility = recentMinimumStats.Versatility or 0;
            ns.versbar_min:SetMinMaxValues(0, 100)
            ns.versbar_min:SetValue(minVersatility, Enum.StatusBarInterpolation.ExponentialEaseOut);
        end
    end

    if ASInformationSaved.showPrimary then
        if ns.primarybar and ns.primarytext then
            -- Assuming primary stats don't have a typical "max" like secondary stats for bar display,
            -- we can set a reasonable max or just display the value. Here, we'll set a nominal max.
            -- Or, we could calculate a "max" based on typical gear levels if desired.
            -- For now, just showing the value.
            local minStat = recentMinimumStats.Stat or 0;
            ns.primarybar:SetMinMaxValues(0, minStat * 2) -- Dynamic max based on current value for visual effect
            ns.primarybar:SetValue(primaryStatValue, Enum.StatusBarInterpolation.ExponentialEaseOut)
            ns.primarytext:SetText(string.format("%d", primaryStatValue))

            ns.primarybar_min:SetMinMaxValues(0, minStat * 2) -- Dynamic max based on current value for visual effect
            ns.primarybar_min:SetValue(minStat, Enum.StatusBarInterpolation.ExponentialEaseOut);
        end
    end

    if ASInformationSaved.isLocked then
        if bMouseEnabled then
            main_frame:EnableMouse(false);
            bMouseEnabled = false;
        end
    else
        if not bMouseEnabled then
            main_frame:EnableMouse(true);
            bMouseEnabled = true;
        end
    end
end


-- Variables for managing stat recording frequency

local function on_update()
    recode_stats()
    update_stats() -- This will use recentMinimumStats in the next plan step
end


-- Make the addon frame movable
main_frame:SetScript("OnMouseDown", function(self, button)
    if button == "LeftButton" and not ASInformationSaved.isLocked then
        self:StartMoving()
        self.isMoving = true
    end
end)

main_frame:SetScript("OnMouseUp", function(self, button)
    if button == "LeftButton" and self.isMoving then
        self:StopMovingOrSizing()
        self.isMoving = false
        save_position()
    end
end)

local function setup_option()
    -- Create the options panel

    if ASInformationSaved and ASInformationSaved.version == defaultOptions.version then
        -- do nothing
    else
        ASInformationSaved = CopyTable(defaultOptions);
    end

    if ASInformation_Positions == nil then
        ASInformation_Positions = {};
    end

    local optionsPanel = CreateFrame("Frame", "asInformationOptionsPanel", InterfaceOptionsFramePanelContainer)
    optionsPanel.name = "asInformation"
    if InterfaceOptions_AddCategory then
        InterfaceOptions_AddCategory(optionsPanel)
    else
        local category, layout = Settings.RegisterCanvasLayoutCategory(optionsPanel, optionsPanel.name);
        Settings.RegisterAddOnCategory(category);
    end

    local title = optionsPanel:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
    title:SetPoint("TOPLEFT", 16, -16)
    title:SetText("asInformation Options")

    local lockCheckbox = CreateFrame("CheckButton", nil, optionsPanel, "InterfaceOptionsCheckButtonTemplate")
    lockCheckbox:SetPoint("TOPLEFT", title, "BOTTOMLEFT", 0, -16)
    lockCheckbox.Text:SetText(L["Lock Frame"])
    lockCheckbox:SetChecked(ASInformationSaved.isLocked)

    lockCheckbox:SetScript("OnClick", function(self)
        ASInformationSaved.isLocked = self:GetChecked()
    end)


    local critCheckbox = CreateFrame("CheckButton", nil, optionsPanel, "InterfaceOptionsCheckButtonTemplate")
    critCheckbox:SetPoint("TOPLEFT", lockCheckbox, "BOTTOMLEFT", 0, -30)
    critCheckbox.Text:SetText(L["Show Crit"])
    critCheckbox:SetChecked(ASInformationSaved.showCrit)
    critCheckbox:SetScript("OnClick", function(self)
        ASInformationSaved.showCrit = self:GetChecked()
        needReposition = true;
    end)

    local hasteCheckbox = CreateFrame("CheckButton", nil, optionsPanel, "InterfaceOptionsCheckButtonTemplate")
    hasteCheckbox:SetPoint("TOPLEFT", critCheckbox, "BOTTOMLEFT", 0, -30)
    hasteCheckbox.Text:SetText(L["Show Haste"])
    hasteCheckbox:SetChecked(ASInformationSaved.showHaste)
    hasteCheckbox:SetScript("OnClick", function(self)
        ASInformationSaved.showHaste = self:GetChecked()
        needReposition = true;
    end)

    local masteryCheckbox = CreateFrame("CheckButton", nil, optionsPanel, "InterfaceOptionsCheckButtonTemplate")
    masteryCheckbox:SetPoint("TOPLEFT", hasteCheckbox, "BOTTOMLEFT", 0, -30)
    masteryCheckbox.Text:SetText(L["Show Mastery"])
    masteryCheckbox:SetChecked(ASInformationSaved.showMastery)
    masteryCheckbox:SetScript("OnClick", function(self)
        ASInformationSaved.showMastery = self:GetChecked()
        needReposition = true;
    end)

    local verCheckbox = CreateFrame("CheckButton", nil, optionsPanel, "InterfaceOptionsCheckButtonTemplate")
    verCheckbox:SetPoint("TOPLEFT", masteryCheckbox, "BOTTOMLEFT", 0, -30)
    verCheckbox.Text:SetText(L["Show Ver"])
    verCheckbox:SetChecked(ASInformationSaved.showVer)
    verCheckbox:SetScript("OnClick", function(self)
        ASInformationSaved.showVer = self:GetChecked()
        needReposition = true;
    end)

    local primaryStatCheckbox = CreateFrame("CheckButton", nil, optionsPanel, "InterfaceOptionsCheckButtonTemplate")
    primaryStatCheckbox:SetPoint("TOPLEFT", verCheckbox, "BOTTOMLEFT", 0, -30)
    primaryStatCheckbox.Text:SetText(L["Show Primary"])
    primaryStatCheckbox:SetChecked(ASInformationSaved.showPrimary)
    primaryStatCheckbox:SetScript("OnClick", function(self)
        ASInformationSaved.showPrimary = self:GetChecked()
        needReposition = true;
    end)

    optionsPanel.refresh = function()
        lockCheckbox:SetChecked(ASInformationSaved.isLocked)        
    end

    -- Show the options panel when the slash command is used
    SLASH_ASINFORMATION1 = "/asinformation"
    SlashCmdList["ASINFORMATION"] = function()
        InterfaceOptionsFrame_OpenToCategory(optionsPanel)
        InterfaceOptionsFrame_OpenToCategory(optionsPanel) -- Double call to avoid interface bug
    end
end

local bfirst = true;

local function init()
    setup_option()
    load_position()
    init_frames();
    main_frame:SetUserPlaced(true)

    local libasConfig = LibStub:GetLibrary("LibasConfig", true);

    if libasConfig then
        libasConfig.load_position(main_frame, "asInformation", ASInformation_Positions);
    end

    -- No longer registering UNIT_AURA for stat activation
    bfirst = false;
    C_Timer.NewTicker(configs.updaterate, on_update); -- This ticker calls OnUpdate, which then calls UpdateStats
end

local function on_event(self, event, ...)
    local arg = ...;

    if event == "PLAYER_ENTERING_WORLD" then
        if UnitAffectingCombat("player") then
            main_frame:SetAlpha(configs.combatalpha);
        else
            main_frame:SetAlpha(configs.normalalpha);
        end
    elseif event == "PLAYER_REGEN_DISABLED" then
        main_frame:SetAlpha(configs.combatalpha);
    elseif event == "PLAYER_REGEN_ENABLED" then
        main_frame:SetAlpha(configs.normalalpha);
    elseif event == "ADDON_LOADED" and arg == "asInformation" and bfirst == true then
        C_Timer.After(0.5, init);
    end
end
main_frame:RegisterEvent("PLAYER_ENTERING_WORLD")
main_frame:RegisterEvent("PLAYER_REGEN_DISABLED");
main_frame:RegisterEvent("PLAYER_REGEN_ENABLED");
main_frame:RegisterEvent("ADDON_LOADED");
main_frame:SetScript("OnEvent", on_event)
