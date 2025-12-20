---@diagnostic disable: redundant-parameter
local _, ns = ...;

local AIF_Alpha = 1          -- 전투중 알파값
local AIF_Alpha_Normal = 0.5 -- 비전투중 안보이게 하려면 0


local asInformation = CreateFrame("Frame", "asInformationFrame", UIParent)
asInformation:SetSize(100, 150)
asInformation:SetPoint("BOTTOM", UIParent, "BOTTOM", -141, 109)
asInformation:SetMovable(true)
asInformation:RegisterForDrag("LeftButton")

local updateInterval = 0.2
local defaultThreshold = 100

-- Saved variables for position, lock state, and stat thresholds
local defaultOptions = {
    point = "BOTTOM",
    relativePoint = "BOTTOM",
    xOfs = -165,
    yOfs = 115,
    isLocked = true,
    stateThreshold = defaultThreshold,
    showHaste = true,
    showCrit = true,
    showMastery = true,
    showVer = true,
    showPrimary = true, -- Add new option for primary stat
    version = 250622,
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
local function LoadPosition()
    asInformation:ClearAllPoints()
    asInformation:SetPoint(ASInformationSaved.point, UIParent, ASInformationSaved.relativePoint, ASInformationSaved.xOfs,
        ASInformationSaved.yOfs)
end

-- Function to save position
local function SavePosition()
    local point, _, relativePoint, xOfs, yOfs = asInformation:GetPoint()
    ASInformationSaved.point = point
    ASInformationSaved.relativePoint = relativePoint
    ASInformationSaved.xOfs = xOfs
    ASInformationSaved.yOfs = yOfs
end


local primaryStatBar, primaryStatBarText -- Add primary stat bar and text
local critBar, critBarText
local hasteBar, hasteBarText
local masteryBar, masteryBarText
local versatilityBar, versatilityBarText

local function initFrames()
    local prevframe = asInformation
    -- Declare variables for bars and their texts
    local locationPoint = "TOPLEFT"; -- Initial anchor point for the first element

    local barWidth = 90
    local barHeight = 12
    local yOffset = -5 -- Offset between bars
    -- Primary Stat Bar
    primaryStatBar = CreateFrame("StatusBar", "asInformationPrimaryStatBar", asInformation);
    primaryStatBar:SetSize(barWidth, barHeight)
    primaryStatBar:SetPoint(locationPoint, prevframe, (prevframe == asInformation and "TOPLEFT" or "BOTTOMLEFT"), 0,
        yOffset)
    primaryStatBar:SetStatusBarTexture("RaidFrame-Hp-Fill")
    primaryStatBar:SetStatusBarColor(defaultBarColor.r, defaultBarColor.g, defaultBarColor.b)

    primaryStatBar.bg = primaryStatBar:CreateTexture(nil, "BACKGROUND")
    primaryStatBar.bg:SetPoint("TOPLEFT", primaryStatBar, "TOPLEFT", -1, 1)
    primaryStatBar.bg:SetPoint("BOTTOMRIGHT", primaryStatBar, "BOTTOMRIGHT", 1, -1)

    primaryStatBar.bg:SetTexture("Interface\\Addons\\asInformation\\border.tga")
    primaryStatBar.bg:SetTexCoord(0.1, 0.1, 0.1, 0.1, 0.1, 0.1, 0.1, 0.1)
    primaryStatBar.bg:SetVertexColor(0, 0, 0, 0.8);

    primaryStatBarText = primaryStatBar:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    primaryStatBarText:SetPoint("RIGHT", primaryStatBar, "RIGHT", -1, 0)
    primaryStatBarText:SetTextColor(statConfigs.Stat.gemColor.r, statConfigs.Stat.gemColor.g, statConfigs.Stat.gemColor
    .b)

    -- Primary stat color will be set dynamically

    primaryStatBar.name = primaryStatBar:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    primaryStatBar.name:SetPoint("LEFT", primaryStatBar, "LEFT", 1, 0)
    primaryStatBar.name:SetTextColor(1, 1, 1);
    primaryStatBar.name:SetText(statConfigs.Stat.abbr)
    -- Primary stat name will be set dynamically

    prevframe = primaryStatBar
    yOffset = -2

    critBar = CreateFrame("StatusBar", "asInformationCritBar", asInformation);
    critBar:SetSize(barWidth, barHeight)
    critBar:SetPoint(locationPoint, prevframe, locationPoint, 0, yOffset)
    critBar:SetStatusBarTexture("RaidFrame-Hp-Fill")
    critBar:SetStatusBarColor(defaultBarColor.r, defaultBarColor.g, defaultBarColor.b)

    critBar.bg = critBar:CreateTexture(nil, "BACKGROUND")
    critBar.bg:SetPoint("TOPLEFT", critBar, "TOPLEFT", -1, 1)
    critBar.bg:SetPoint("BOTTOMRIGHT", critBar, "BOTTOMRIGHT", 1, -1)

    critBar.bg:SetTexture("Interface\\Addons\\asInformation\\border.tga")
    critBar.bg:SetTexCoord(0.1, 0.1, 0.1, 0.1, 0.1, 0.1, 0.1, 0.1)
    critBar.bg:SetVertexColor(0, 0, 0, 0.8);

    critBarText = critBar:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    critBarText:SetPoint("RIGHT", critBar, "RIGHT", -1, 0)
    critBarText:SetTextColor(statConfigs.Crit.gemColor.r, statConfigs.Crit.gemColor.g, statConfigs.Crit.gemColor.b)

    critBar.name = critBar:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    critBar.name:SetPoint("LEFT", critBar, "LEFT", 1, 0)
    critBar.name:SetTextColor(1, 1, 1);
    critBar.name:SetText(statConfigs.Crit.abbr);

    prevframe = critBar -- Next element anchors to this bar
    yOffset = -2        -- Smaller gap for subsequent bars

    hasteBar = CreateFrame("StatusBar", "asInformationHasteBar", asInformation);
    hasteBar:SetSize(barWidth, barHeight)
    hasteBar:SetPoint(locationPoint, prevframe, (prevframe == asInformation and "TOPLEFT" or "BOTTOMLEFT"), 0, yOffset)
    hasteBar:SetStatusBarTexture("RaidFrame-Hp-Fill")
    hasteBar:SetStatusBarColor(defaultBarColor.r, defaultBarColor.g, defaultBarColor.b)

    hasteBar.bg = hasteBar:CreateTexture(nil, "BACKGROUND")
    hasteBar.bg:SetPoint("TOPLEFT", hasteBar, "TOPLEFT", -1, 1)
    hasteBar.bg:SetPoint("BOTTOMRIGHT", hasteBar, "BOTTOMRIGHT", 1, -1)

    hasteBar.bg:SetTexture("Interface\\Addons\\asInformation\\border.tga")
    hasteBar.bg:SetTexCoord(0.1, 0.1, 0.1, 0.1, 0.1, 0.1, 0.1, 0.1)
    hasteBar.bg:SetVertexColor(0, 0, 0, 0.8);

    hasteBarText = hasteBar:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    hasteBarText:SetPoint("RIGHT", hasteBar, "RIGHT", -1, 0)
    hasteBarText:SetTextColor(statConfigs.Haste.gemColor.r, statConfigs.Haste.gemColor.g, statConfigs.Haste.gemColor.b)

    hasteBar.name = hasteBar:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    hasteBar.name:SetPoint("LEFT", hasteBar, "LEFT", 1, 0)
    hasteBar.name:SetTextColor(1, 1, 1)
    hasteBar.name:SetText(statConfigs.Haste.abbr);

    prevframe = hasteBar
    yOffset = -2

    masteryBar = CreateFrame("StatusBar", "asInformationMasteryBar", asInformation);
    masteryBar:SetSize(barWidth, barHeight)
    masteryBar:SetPoint(locationPoint, prevframe, (prevframe == asInformation and "TOPLEFT" or "BOTTOMLEFT"), 0, yOffset)
    masteryBar:SetStatusBarTexture("RaidFrame-Hp-Fill")
    masteryBar:SetStatusBarColor(defaultBarColor.r, defaultBarColor.g, defaultBarColor.b)

    masteryBar.bg = masteryBar:CreateTexture(nil, "BACKGROUND")
    masteryBar.bg:SetPoint("TOPLEFT", masteryBar, "TOPLEFT", -1, 1)
    masteryBar.bg:SetPoint("BOTTOMRIGHT", masteryBar, "BOTTOMRIGHT", 1, -1)

    masteryBar.bg:SetTexture("Interface\\Addons\\asInformation\\border.tga")
    masteryBar.bg:SetTexCoord(0.1, 0.1, 0.1, 0.1, 0.1, 0.1, 0.1, 0.1)
    masteryBar.bg:SetVertexColor(0, 0, 0, 0.8);

    masteryBarText = masteryBar:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    masteryBarText:SetPoint("RIGHT", masteryBar, "RIGHT", -1, 0)
    masteryBarText:SetTextColor(statConfigs.Mastery.gemColor.r, statConfigs.Mastery.gemColor.g,
        statConfigs.Mastery.gemColor.b)
    masteryBar.name = masteryBar:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    masteryBar.name:SetPoint("LEFT", masteryBar, "LEFT", 1, 0)
    masteryBar.name:SetTextColor(1, 1, 1);
    masteryBar.name:SetText(statConfigs.Mastery.abbr);
    prevframe = masteryBar
    yOffset = -2

    versatilityBar = CreateFrame("StatusBar", "asInformationVersatilityBar", asInformation);
    versatilityBar:SetSize(barWidth, barHeight)
    versatilityBar:SetPoint(locationPoint, prevframe, (prevframe == asInformation and "TOPLEFT" or "BOTTOMLEFT"), 0,
        yOffset)
    versatilityBar:SetStatusBarTexture("RaidFrame-Hp-Fill")
    versatilityBar:SetStatusBarColor(defaultBarColor.r, defaultBarColor.g, defaultBarColor.b)

    versatilityBar.bg = versatilityBar:CreateTexture(nil, "BACKGROUND")
    versatilityBar.bg:SetPoint("TOPLEFT", versatilityBar, "TOPLEFT", -1, 1)
    versatilityBar.bg:SetPoint("BOTTOMRIGHT", versatilityBar, "BOTTOMRIGHT", 1, -1)

    versatilityBar.bg:SetTexture("Interface\\Addons\\asInformation\\border.tga")
    versatilityBar.bg:SetTexCoord(0.1, 0.1, 0.1, 0.1, 0.1, 0.1, 0.1, 0.1)
    versatilityBar.bg:SetVertexColor(0, 0, 0, 0.8);

    versatilityBarText = versatilityBar:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    versatilityBarText:SetPoint("RIGHT", versatilityBar, "RIGHT", -1, 0)
    versatilityBarText:SetTextColor(statConfigs.Versatility.gemColor.r, statConfigs.Versatility.gemColor.g,
        statConfigs.Versatility.gemColor.b)
    versatilityBar.name = versatilityBar:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    versatilityBar.name:SetPoint("LEFT", versatilityBar, "LEFT", 1, 0)
    versatilityBar.name:SetTextColor(1, 1, 1);
    versatilityBar.name:SetText(statConfigs.Versatility.abbr);

    prevframe = versatilityBar
    yOffset = -2
end

local bMouseEnabled = true;
local needReposition = true;

-- Function to get primary stat based on class, inspired by PaperDollFrame.lua
local function GetPrimaryStat()
    local currspec = C_SpecializationInfo.GetSpecialization() or 1;
    local primaryStatID = select(6, C_SpecializationInfo.GetSpecializationInfo(currspec)) or 1;
    local primaryStatValue = UnitStat("player", primaryStatID);

    return primaryStatValue;
end

local function asGetCrit()
    --PaperDollFrame_SetCritChance
    local spellCrit, rangedCrit, meleeCrit;
    local critChance;

    -- Start at 2 to skip physical damage
    local holySchool = 2;
    local minCrit = GetSpellCritChance(holySchool);
    for i = (holySchool + 1), MAX_SPELL_SCHOOLS do
        spellCrit = GetSpellCritChance(i);
        minCrit = min(minCrit, spellCrit);
    end
    spellCrit = minCrit
    rangedCrit = GetRangedCritChance();
    meleeCrit = GetCritChance();

    if (spellCrit >= rangedCrit and spellCrit >= meleeCrit) then
        critChance = spellCrit;
    elseif (rangedCrit >= meleeCrit) then
        critChance = rangedCrit;
    else
        critChance = meleeCrit;
    end

    return critChance;
end

-- Function to record current stat values into history
local function RecordCurrentStats()
    local inCombat = UnitAffectingCombat("player");

    if not inCombat then
        local currentStats = {
            Stat = GetPrimaryStat(),
            Crit = asGetCrit(),
            Haste = GetHaste(),
            Mastery = GetMasteryEffect(),
            Versatility = GetCombatRatingBonus(CR_VERSATILITY_DAMAGE_DONE) +
                GetVersatilityBonus(CR_VERSATILITY_DAMAGE_DONE)
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
                if minStat == nil or (snapshot.value < minStat and snapshot.value > 0) then
                    minStat = snapshot.value
                end
            end
            recentMinimumStats[statName] = minStat
        end
    end
end

local function UpdateStats()
    if needReposition then
        needReposition = false;

        local prevframe = asInformation;
        local yOffset = -5;

        if ASInformationSaved.showPrimary then
            primaryStatBar:SetPoint("TOPLEFT", prevframe, (prevframe == asInformation and "TOPLEFT" or "BOTTOMLEFT"), 0,
                yOffset);
            primaryStatBar:Show();
            prevframe = primaryStatBar;
            yOffset = -2;
        else
            primaryStatBar:Hide();
        end

        if ASInformationSaved.showCrit then
            critBar:SetPoint("TOPLEFT", prevframe, (prevframe == asInformation and "TOPLEFT" or "BOTTOMLEFT"), 0, yOffset);
            critBar:Show();
            prevframe = critBar;
            yOffset = -2;
        else
            critBar:Hide();
        end

        if ASInformationSaved.showHaste then
            hasteBar:SetPoint("TOPLEFT", prevframe, (prevframe == asInformation and "TOPLEFT" or "BOTTOMLEFT"), 0,
                yOffset);
            hasteBar:Show();
            prevframe = hasteBar;
            yOffset = -2;
        else
            hasteBar:Hide();
        end

        if ASInformationSaved.showMastery then
            masteryBar:SetPoint("TOPLEFT", prevframe, (prevframe == asInformation and "TOPLEFT" or "BOTTOMLEFT"), 0,
                yOffset);
            masteryBar:Show();
            prevframe = masteryBar;
            yOffset = -2;
        else
            masteryBar:Hide();
        end

        if ASInformationSaved.showVer then
            versatilityBar:SetPoint("TOPLEFT", prevframe, (prevframe == asInformation and "TOPLEFT" or "BOTTOMLEFT"), 0,
                yOffset);
            versatilityBar:Show();
            prevframe = versatilityBar;
            yOffset = -2;
        else
            versatilityBar:Hide();
        end
    end

    local haste = GetHaste()
    local crit = asGetCrit()
    local mastery = GetMasteryEffect()
    local versatility = GetCombatRatingBonus(CR_VERSATILITY_DAMAGE_DONE) +
        GetVersatilityBonus(CR_VERSATILITY_DAMAGE_DONE);
    local primaryStatValue = GetPrimaryStat()

    if ASInformationSaved.showCrit then
        if critBar and critBarText then     -- Check if bar and text elements exist
            critBar:SetMinMaxValues(0, 100) -- Assuming stats are percentage based 0-100
            critBar:SetValue(crit)
            critBar:SetMinMaxValues(0, 100) -- Assuming stats are percentage based 0-100
            critBar:SetValue(crit)
            critBarText:SetText(string.format("%.2f%%", crit))

            local minCrit = recentMinimumStats.Crit
            if minCrit ~= nil and crit > minCrit then
                critBar:SetStatusBarColor(statConfigs.Crit.gemColor.r, statConfigs.Crit.gemColor.g,
                    statConfigs.Crit.gemColor.b)
                critBarText:SetTextColor(activatedTextColor.r, activatedTextColor.g, activatedTextColor.b)
            else
                critBar:SetStatusBarColor(defaultBarColor.r, defaultBarColor.g, defaultBarColor.b)
                critBarText:SetTextColor(statConfigs.Crit.gemColor.r, statConfigs.Crit.gemColor.g,
                    statConfigs.Crit.gemColor.b)
            end

            if crit >= ASInformationSaved.stateThreshold then
                ns.lib.PixelGlow_Start(critBar);
            else
                ns.lib.PixelGlow_Stop(critBar);
            end
        end
    end

    if ASInformationSaved.showHaste then
        if hasteBar and hasteBarText then -- Check if bar and text elements exist
            hasteBar:SetMinMaxValues(0, 100)
            hasteBar:SetValue(haste)
            hasteBarText:SetText(string.format("%.2f%%", haste))

            local minHaste = recentMinimumStats.Haste
            if minHaste ~= nil and haste > minHaste then
                hasteBar:SetStatusBarColor(statConfigs.Haste.gemColor.r, statConfigs.Haste.gemColor.g,
                    statConfigs.Haste.gemColor.b)
                hasteBarText:SetTextColor(activatedTextColor.r, activatedTextColor.g, activatedTextColor.b)
            else
                hasteBar:SetStatusBarColor(defaultBarColor.r, defaultBarColor.g, defaultBarColor.b)
                hasteBarText:SetTextColor(statConfigs.Haste.gemColor.r, statConfigs.Haste.gemColor.g,
                    statConfigs.Haste.gemColor.b)
            end
            if haste >= ASInformationSaved.stateThreshold then
                ns.lib.PixelGlow_Start(hasteBar);
            else
                ns.lib.PixelGlow_Stop(hasteBar);
            end
        end
    end

    if ASInformationSaved.showMastery then
        if masteryBar and masteryBarText then -- Check if bar and text elements exist
            masteryBar:SetMinMaxValues(0, 100)
            masteryBar:SetValue(mastery)
            masteryBarText:SetText(string.format("%.2f%%", mastery))

            local minMastery = recentMinimumStats.Mastery
            if minMastery ~= nil and mastery > minMastery then
                masteryBar:SetStatusBarColor(statConfigs.Mastery.gemColor.r, statConfigs.Mastery.gemColor.g,
                    statConfigs.Mastery.gemColor.b)
                masteryBarText:SetTextColor(activatedTextColor.r, activatedTextColor.g, activatedTextColor.b)
            else
                masteryBar:SetStatusBarColor(defaultBarColor.r, defaultBarColor.g, defaultBarColor.b)
                masteryBarText:SetTextColor(statConfigs.Mastery.gemColor.r, statConfigs.Mastery.gemColor.g,
                    statConfigs.Mastery.gemColor.b)
            end
            if mastery >= ASInformationSaved.stateThreshold then
                ns.lib.PixelGlow_Start(masteryBar);
            else
                ns.lib.PixelGlow_Stop(masteryBar);
            end
        end
    end

    if ASInformationSaved.showVer then
        if versatilityBar and versatilityBarText then -- Check if bar and text elements exist
            versatilityBar:SetMinMaxValues(0, 100)
            versatilityBar:SetValue(versatility)
            versatilityBarText:SetText(string.format("%.2f%%", versatility))

            local minVersatility = recentMinimumStats.Versatility
            if minVersatility ~= nil and versatility > minVersatility then
                versatilityBar:SetStatusBarColor(statConfigs.Versatility.gemColor.r, statConfigs.Versatility.gemColor.g,
                    statConfigs.Versatility.gemColor.b)
                versatilityBarText:SetTextColor(activatedTextColor.r, activatedTextColor.g, activatedTextColor.b)
            else
                versatilityBar:SetStatusBarColor(defaultBarColor.r, defaultBarColor.g, defaultBarColor.b)
                versatilityBarText:SetTextColor(statConfigs.Versatility.gemColor.r, statConfigs.Versatility.gemColor.g,
                    statConfigs.Versatility.gemColor.b)
            end
            if versatility >= ASInformationSaved.stateThreshold then
                ns.lib.PixelGlow_Start(versatilityBar);
            else
                ns.lib.PixelGlow_Stop(versatilityBar);
            end
        end
    end

    if ASInformationSaved.showPrimary then
        if primaryStatBar and primaryStatBarText then
            -- Assuming primary stats don't have a typical "max" like secondary stats for bar display,
            -- we can set a reasonable max or just display the value. Here, we'll set a nominal max.
            -- Or, we could calculate a "max" based on typical gear levels if desired.
            -- For now, just showing the value.
            local showvalue = 0;
            local maxvalue = primaryStatValue * 0.2;

            local minStat = recentMinimumStats.Stat
            if minStat ~= nil and primaryStatValue > minStat then
                primaryStatBar:SetStatusBarColor(statConfigs.Stat.gemColor.r, statConfigs.Stat.gemColor.g,
                    statConfigs.Stat.gemColor.b)
                primaryStatBarText:SetTextColor(activatedTextColor.r, activatedTextColor.g, activatedTextColor.b)
                showvalue = primaryStatValue - minStat;
                maxvalue = minStat * 0.2;
            else
                primaryStatBar:SetStatusBarColor(defaultBarColor.r, defaultBarColor.g, defaultBarColor.b)
                primaryStatBarText:SetTextColor(statConfigs.Stat.gemColor.r, statConfigs.Stat.gemColor.g,
                    statConfigs.Stat.gemColor.b)
            end
            primaryStatBar:SetMinMaxValues(0, maxvalue) -- Dynamic max based on current value for visual effect
            primaryStatBar:SetValue(showvalue)
            primaryStatBarText:SetText(string.format("%d", showvalue))

            if showvalue >= maxvalue then
                ns.lib.PixelGlow_Start(primaryStatBar);
            else
                ns.lib.PixelGlow_Stop(primaryStatBar);
            end

            -- No threshold glow for primary stat for now, can be added if needed
        end
    end

    if ASInformationSaved.isLocked then
        if bMouseEnabled then
            asInformation:EnableMouse(false);
            bMouseEnabled = false;
        end
    else
        if not bMouseEnabled then
            asInformation:EnableMouse(true);
            bMouseEnabled = true;
        end
    end
end


-- Variables for managing stat recording frequency

local function OnUpdate()
    RecordCurrentStats()
    UpdateStats() -- This will use recentMinimumStats in the next plan step
end


-- Make the addon frame movable
asInformation:SetScript("OnMouseDown", function(self, button)
    if button == "LeftButton" and not ASInformationSaved.isLocked then
        self:StartMoving()
        self.isMoving = true
    end
end)

asInformation:SetScript("OnMouseUp", function(self, button)
    if button == "LeftButton" and self.isMoving then
        self:StopMovingOrSizing()
        self.isMoving = false
        SavePosition()
    end
end)

local function SetupOptions()
    -- Create the options panel

    if ASInformationSaved and ASInformationSaved.version == defaultOptions.version then
        -- do nothing
    else
        ASInformationSaved = defaultOptions;
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

    local hasteThresholdSlider = CreateFrame("Slider", nil, optionsPanel, "OptionsSliderTemplate")
    hasteThresholdSlider:SetPoint("TOPLEFT", primaryStatCheckbox, "BOTTOMLEFT", 0, -30)
    hasteThresholdSlider:SetMinMaxValues(0, 300)
    hasteThresholdSlider:SetValue(ASInformationSaved.stateThreshold)
    hasteThresholdSlider:SetValueStep(0.5)
    hasteThresholdSlider.text = hasteThresholdSlider:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    hasteThresholdSlider.text:SetPoint("TOP", hasteThresholdSlider, "BOTTOM", 0, -5)
    hasteThresholdSlider.text:SetText(string.format(L["State Threshold"] .. ": %d%%", ASInformationSaved.stateThreshold))
    hasteThresholdSlider:SetScript("OnValueChanged", function(self, value)
        ASInformationSaved.stateThreshold = value
        self.Text:SetText(string.format(L["State Threshold"] .. ": %d%%", value))
    end)


    optionsPanel.refresh = function()
        lockCheckbox:SetChecked(ASInformationSaved.isLocked)
        hasteThresholdSlider:SetValue(ASInformationSaved.stateThreshold)
    end

    -- Show the options panel when the slash command is used
    SLASH_ASINFORMATION1 = "/asinformation"
    SlashCmdList["ASINFORMATION"] = function()
        InterfaceOptionsFrame_OpenToCategory(optionsPanel)
        InterfaceOptionsFrame_OpenToCategory(optionsPanel) -- Double call to avoid interface bug
    end
end

local bfirst = true;

local function initAll()
    SetupOptions()
    LoadPosition()
    initFrames();
    asInformation:SetUserPlaced(true)

    C_AddOns.LoadAddOn("asMOD");

    if asMOD_setupFrame then
        asMOD_setupFrame(asInformation, "asInformation");
    end
    -- No longer registering UNIT_AURA for stat activation
    bfirst = false;
    C_Timer.NewTicker(updateInterval, OnUpdate); -- This ticker calls OnUpdate, which then calls UpdateStats
end

local function OnEvent(self, event, ...)
    local arg = ...;

    if event == "PLAYER_ENTERING_WORLD" then
        if UnitAffectingCombat("player") then
            asInformation:SetAlpha(AIF_Alpha);
        else
            asInformation:SetAlpha(AIF_Alpha_Normal);
        end
    elseif event == "PLAYER_REGEN_DISABLED" then
        asInformation:SetAlpha(AIF_Alpha);
    elseif event == "PLAYER_REGEN_ENABLED" then
        asInformation:SetAlpha(AIF_Alpha_Normal);
    elseif event == "ADDON_LOADED" and arg == "asInformation" and bfirst == true then
        initAll();
    end
end
asInformation:RegisterEvent("PLAYER_ENTERING_WORLD")
asInformation:RegisterEvent("PLAYER_REGEN_DISABLED");
asInformation:RegisterEvent("PLAYER_REGEN_ENABLED");
asInformation:RegisterEvent("ADDON_LOADED");
asInformation:SetScript("OnEvent", OnEvent)
