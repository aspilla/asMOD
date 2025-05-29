local asInformation = CreateFrame("Frame", "asInformationFrame", UIParent)
asInformation:SetSize(100, 150)
asInformation:SetPoint("BOTTOM", UIParent, "BOTTOM", -141, 109)
asInformation:SetMovable(true)
asInformation:RegisterForDrag("LeftButton")

local updateInterval = 0.2
local defaultHasteThreshold = 100

-- Saved variables for position, lock state, and stat thresholds
asInformationSaved = asInformationSaved or {
    point = "BOTTOM",
    relativePoint = "BOTTOM",
    xOfs = -175,
    yOfs = 124,
    isLocked = true,
    hasteThreshold = defaultHasteThreshold,
    showHaste = true,
    showCrit = true,
    showMastery = true,
    showVer = true,
}

-- Localization
local L = {}
local locale = GetLocale()

-- Stat Configurations
local statConfigs = {
    Crit = { abbr = "C", gemColor = { r = 1, g = 0, b = 0 } },
    Haste = { abbr = "H", gemColor = { r = 0, g = 1, b = 0 } },
    Mastery = { abbr = "M", gemColor = { r = 0.5, g = 0, b = 1 } },
    Versatility = { abbr = "V", gemColor = { r = 0, g = 0, b = 1 } }
}

local defaultBarColor = { r = 0.5, g = 0.5, b = 0.5 }
local activatedTextColor = { r = 1, g = 1, b = 1 }

-- New data structures for tracking minimum stats over time
local statHistory = { Crit = {}, Haste = {}, Mastery = {}, Versatility = {} }
local historyDuration = 60 -- seconds
local recentMinimumStats = { Crit = nil, Haste = nil, Mastery = nil, Versatility = nil }

if locale == "koKR" then
    L["Lock Frame"] = "프레임 잠금"
    L["Haste Threshold"] = "가속 임계값"
    L["Show Haste"] = "가속 표시"
    L["Show Crit"] = "크리 표시"
    L["Show Mastery"] = "특화 표시"
    L["Show Ver"] = "유연 표시"
else -- Default to English
    L["Lock Frame"] = "Lock Frame"
    L["Haste Threshold"] = "Haste Threshold"
    L["Show Haste"] = "Show Haste"
    L["Show Crit"] = "Show Crit"
    L["Show Mastery"] = "Show Mastery"
    L["Show Ver"] = "Show Ver"
end

-- Function to load saved position
local function LoadPosition()
    asInformation:ClearAllPoints()
    asInformation:SetPoint(asInformationSaved.point, UIParent, asInformationSaved.relativePoint, asInformationSaved.xOfs,
        asInformationSaved.yOfs)
end

-- Function to save position
local function SavePosition()
    local point, _, relativePoint, xOfs, yOfs = asInformation:GetPoint()
    asInformationSaved.point = point
    asInformationSaved.relativePoint = relativePoint
    asInformationSaved.xOfs = xOfs
    asInformationSaved.yOfs = yOfs
end

local prevframe = asInformation
local combatTimeText;
-- Declare variables for bars and their texts
local critBar, critBarText
local hasteBar, hasteBarText
local masteryBar, masteryBarText
local versatilityBar, versatilityBarText
local locationPoint = "TOPLEFT"; -- Initial anchor point for the first element

local barWidth = 100
local barHeight = 12
local yOffset = -5 -- Offset between bars

if asInformationSaved.showCrit then
    critBar = CreateFrame("StatusBar", "asInformationCritBar", asInformation);
    critBar:SetSize(barWidth, barHeight)
    critBar:SetPoint(locationPoint, prevframe, locationPoint, 0, yOffset)
    critBar:SetStatusBarTexture("Interface/Addons/asInformation/UI-StatusBar")
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
    critBar.name:SetText("C");
    
    prevframe = critBar -- Next element anchors to this bar
    yOffset = -2 -- Smaller gap for subsequent bars
end

if asInformationSaved.showHaste then
    hasteBar = CreateFrame("StatusBar", "asInformationHasteBar", asInformation );
    hasteBar:SetSize(barWidth, barHeight)
    hasteBar:SetPoint(locationPoint, prevframe, (prevframe == asInformation and "TOPLEFT" or "BOTTOMLEFT"), 0, yOffset)
    hasteBar:SetStatusBarTexture("Interface/Addons/asInformation/UI-StatusBar")
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
    hasteBar.name:SetText("H");

    prevframe = hasteBar
    yOffset = -2
end

if asInformationSaved.showMastery then
    masteryBar = CreateFrame("StatusBar", "asInformationMasteryBar", asInformation);
    masteryBar:SetSize(barWidth, barHeight)
    masteryBar:SetPoint(locationPoint, prevframe, (prevframe == asInformation and "TOPLEFT" or "BOTTOMLEFT"), 0, yOffset)
    masteryBar:SetStatusBarTexture("Interface/Addons/asInformation/UI-StatusBar")
    masteryBar:SetStatusBarColor(defaultBarColor.r, defaultBarColor.g, defaultBarColor.b)

    masteryBar.bg = masteryBar:CreateTexture(nil, "BACKGROUND")
    masteryBar.bg:SetPoint("TOPLEFT", masteryBar, "TOPLEFT", -1, 1)
    masteryBar.bg:SetPoint("BOTTOMRIGHT", masteryBar, "BOTTOMRIGHT", 1, -1)

    masteryBar.bg:SetTexture("Interface\\Addons\\asInformation\\border.tga")
    masteryBar.bg:SetTexCoord(0.1, 0.1, 0.1, 0.1, 0.1, 0.1, 0.1, 0.1)
    masteryBar.bg:SetVertexColor(0, 0, 0, 0.8);

    masteryBarText = masteryBar:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    masteryBarText:SetPoint("RIGHT", masteryBar, "RIGHT", -1, 0)
    masteryBarText:SetTextColor(statConfigs.Mastery.gemColor.r, statConfigs.Mastery.gemColor.g, statConfigs.Mastery.gemColor.b)
    masteryBar.name = masteryBar:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    masteryBar.name:SetPoint("LEFT", masteryBar, "LEFT", 1, 0)
    masteryBar.name:SetTextColor(1, 1, 1);
    masteryBar.name:SetText("M");
    prevframe = masteryBar
    yOffset = -2
end

if asInformationSaved.showVer then
    versatilityBar = CreateFrame("StatusBar", "asInformationVersatilityBar", asInformation);
    versatilityBar:SetSize(barWidth, barHeight)
    versatilityBar:SetPoint(locationPoint, prevframe, (prevframe == asInformation and "TOPLEFT" or "BOTTOMLEFT"), 0, yOffset)
    versatilityBar:SetStatusBarTexture("Interface/Addons/asInformation/UI-StatusBar")
    versatilityBar:SetStatusBarColor(defaultBarColor.r, defaultBarColor.g, defaultBarColor.b)

    versatilityBar.bg = versatilityBar:CreateTexture(nil, "BACKGROUND")
    versatilityBar.bg:SetPoint("TOPLEFT", versatilityBar, "TOPLEFT", -1, 1)
    versatilityBar.bg:SetPoint("BOTTOMRIGHT", versatilityBar, "BOTTOMRIGHT", 1, -1)

    versatilityBar.bg:SetTexture("Interface\\Addons\\asInformation\\border.tga")
    versatilityBar.bg:SetTexCoord(0.1, 0.1, 0.1, 0.1, 0.1, 0.1, 0.1, 0.1)
    versatilityBar.bg:SetVertexColor(0, 0, 0, 0.8);

    versatilityBarText = versatilityBar:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    versatilityBarText:SetPoint("RIGHT", versatilityBar, "RIGHT", -1, 0)
    versatilityBarText:SetTextColor(statConfigs.Versatility.gemColor.r, statConfigs.Versatility.gemColor.g, statConfigs.Versatility.gemColor.b)
    versatilityBar.name = versatilityBar:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    versatilityBar.name:SetPoint("LEFT", versatilityBar, "LEFT", 1, 0)
    versatilityBar.name:SetTextColor(1, 1, 1);
    versatilityBar.name:SetText("V");
    
    prevframe = versatilityBar
    yOffset = -2
end

-- For UpdateStats compatibility, assign new text elements to old variable names
local critText = critBarText
local hasteText = hasteBarText
local masteryText = masteryBarText
local versatilityText = versatilityBarText

local bMouseEnabled = true;

-- Function to record current stat values into history
local function RecordCurrentStats()
    local now = GetTime()
    local inCombat = UnitAffectingCombat("player")

    local currentStats = {
        Crit = GetCritChance(),
        Haste = GetHaste(),
        Mastery = GetMasteryEffect(),
        Versatility = GetCombatRatingBonus(CR_VERSATILITY_DAMAGE_DONE) + GetVersatilityBonus(CR_VERSATILITY_DAMAGE_DONE)
    }

    for statName, value in pairs(currentStats) do
        local snapshot = { value = value, time = now, inCombat = inCombat }
        table.insert(statHistory[statName], 1, snapshot)
    end
end

-- Function to prune old stat history and calculate recent minimums during combat
local function UpdateRecentMinimumStats()
    local now = GetTime()
    for statName, history in pairs(statHistory) do
        -- Prune old entries
        for i = #history, 1, -1 do
            if now - history[i].time > historyDuration then
                table.remove(history, i)
            end
        end

        -- Calculate minimum from combat snapshots
        local minStat = nil
        for _, snapshot in ipairs(history) do
            if snapshot.inCombat then
                if minStat == nil or snapshot.value < minStat then
                    minStat = snapshot.value
                end
            end
        end
        recentMinimumStats[statName] = minStat
    end
end

-- Helper function to reset stat history and minimums
local function ResetStatHistoryAndMinimums()
    local statNames = {"Crit", "Haste", "Mastery", "Versatility"}
    for _, statName in ipairs(statNames) do
        if statHistory[statName] then
            statHistory[statName] = {}
        end
        if recentMinimumStats[statName] ~= nil then -- Check before assigning nil to avoid redundant table access if already nil
            recentMinimumStats[statName] = nil
        end
    end
    -- It might be beneficial to also call UpdateStats() here to immediately reflect the reset state.
    -- However, sticking to the current plan, UpdateStats will pick up changes on its own ticker.
end

local function UpdateStats()
    local haste = GetHaste()
    local crit = GetCritChance()
    local mastery = GetMasteryEffect()
    local versatility =  GetCombatRatingBonus(CR_VERSATILITY_DAMAGE_DONE) + GetVersatilityBonus(CR_VERSATILITY_DAMAGE_DONE);

    if asInformationSaved.showCrit then
        if critBar and critText then -- Check if bar and text elements exist
            critBar:SetMinMaxValues(0, 100) -- Assuming stats are percentage based 0-100
            critBar:SetValue(crit)
            critBar:SetMinMaxValues(0, 100) -- Assuming stats are percentage based 0-100
            critBar:SetValue(crit)
            critText:SetText(string.format("%.2f%%", crit))
            
            local minCrit = recentMinimumStats.Crit
            if minCrit ~= nil and crit > minCrit then
                critBar:SetStatusBarColor(statConfigs.Crit.gemColor.r, statConfigs.Crit.gemColor.g, statConfigs.Crit.gemColor.b)
                critText:SetTextColor(activatedTextColor.r, activatedTextColor.g, activatedTextColor.b)
            else
                critBar:SetStatusBarColor(defaultBarColor.r, defaultBarColor.g, defaultBarColor.b)
                critText:SetTextColor(statConfigs.Crit.gemColor.r, statConfigs.Crit.gemColor.g, statConfigs.Crit.gemColor.b)
            end
        end
    end

    if asInformationSaved.showHaste then
        if hasteBar and hasteText then -- Check if bar and text elements exist
            hasteBar:SetMinMaxValues(0, 100)
            hasteBar:SetValue(haste)
            hasteText:SetText(string.format("%.2f%%", haste))

            local minHaste = recentMinimumStats.Haste
            if minHaste ~= nil and haste > minHaste then
                hasteBar:SetStatusBarColor(statConfigs.Haste.gemColor.r, statConfigs.Haste.gemColor.g, statConfigs.Haste.gemColor.b)
                hasteText:SetTextColor(activatedTextColor.r, activatedTextColor.g, activatedTextColor.b)
            else
                hasteBar:SetStatusBarColor(defaultBarColor.r, defaultBarColor.g, defaultBarColor.b)
                hasteText:SetTextColor(statConfigs.Haste.gemColor.r, statConfigs.Haste.gemColor.g, statConfigs.Haste.gemColor.b)
            end
        end
    end

    if asInformationSaved.showMastery then
        if masteryBar and masteryText then -- Check if bar and text elements exist
            masteryBar:SetMinMaxValues(0, 100)
            masteryBar:SetValue(mastery)
            masteryText:SetText(string.format("%.2f%%",  mastery))

            local minMastery = recentMinimumStats.Mastery
            if minMastery ~= nil and mastery > minMastery then
                masteryBar:SetStatusBarColor(statConfigs.Mastery.gemColor.r, statConfigs.Mastery.gemColor.g, statConfigs.Mastery.gemColor.b)
                masteryText:SetTextColor(activatedTextColor.r, activatedTextColor.g, activatedTextColor.b)
            else
                masteryBar:SetStatusBarColor(defaultBarColor.r, defaultBarColor.g, defaultBarColor.b)
                masteryText:SetTextColor(statConfigs.Mastery.gemColor.r, statConfigs.Mastery.gemColor.g, statConfigs.Mastery.gemColor.b)
            end
        end
    end

    if asInformationSaved.showVer then
        if versatilityBar and versatilityText then -- Check if bar and text elements exist
            versatilityBar:SetMinMaxValues(0, 100)
            versatilityBar:SetValue(versatility)
            versatilityText:SetText(string.format("%.2f%%", versatility))

            local minVersatility = recentMinimumStats.Versatility
            if minVersatility ~= nil and versatility > minVersatility then
                versatilityBar:SetStatusBarColor(statConfigs.Versatility.gemColor.r, statConfigs.Versatility.gemColor.g, statConfigs.Versatility.gemColor.b)
                versatilityText:SetTextColor(activatedTextColor.r, activatedTextColor.g, activatedTextColor.b)
            else
                versatilityBar:SetStatusBarColor(defaultBarColor.r, defaultBarColor.g, defaultBarColor.b)
                versatilityText:SetTextColor(statConfigs.Versatility.gemColor.r, statConfigs.Versatility.gemColor.g, statConfigs.Versatility.gemColor.b)
            end
        end
    end

    if asInformationSaved.isLocked then
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
local timeSinceLastRecord = 0

local function OnUpdate()
        RecordCurrentStats()
        UpdateRecentMinimumStats()
        timeSinceLastRecord = timeSinceLastRecord - updateInterval -- Subtract to carry over excess time
    UpdateStats() -- This will use recentMinimumStats in the next plan step
end


-- Make the addon frame movable
asInformation:SetScript("OnMouseDown", function(self, button)
    if button == "LeftButton" and not asInformationSaved.isLocked then
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
    lockCheckbox:SetChecked(asInformationSaved.isLocked)

    lockCheckbox:SetScript("OnClick", function(self)
        asInformationSaved.isLocked = self:GetChecked()
    end)


    local critCheckbox = CreateFrame("CheckButton", nil, optionsPanel, "InterfaceOptionsCheckButtonTemplate")
    critCheckbox:SetPoint("TOPLEFT", lockCheckbox, "BOTTOMLEFT", 0, -30)
    critCheckbox.Text:SetText(L["Show Crit"])
    critCheckbox:SetChecked(asInformationSaved.showCrit)
    critCheckbox:SetScript("OnClick", function(self)
        asInformationSaved.showCrit = self:GetChecked()
    end)

    local hasteCheckbox = CreateFrame("CheckButton", nil, optionsPanel, "InterfaceOptionsCheckButtonTemplate")
    hasteCheckbox:SetPoint("TOPLEFT", critCheckbox, "BOTTOMLEFT", 0, -30)
    hasteCheckbox.Text:SetText(L["Show Haste"])
    hasteCheckbox:SetChecked(asInformationSaved.showHaste)
    hasteCheckbox:SetScript("OnClick", function(self)
        asInformationSaved.showHaste = self:GetChecked()
    end)

    local masteryCheckbox = CreateFrame("CheckButton", nil, optionsPanel, "InterfaceOptionsCheckButtonTemplate")
    masteryCheckbox:SetPoint("TOPLEFT", hasteCheckbox, "BOTTOMLEFT", 0, -30)
    masteryCheckbox.Text:SetText(L["Show Mastery"])
    masteryCheckbox:SetChecked(asInformationSaved.showMastery)
    masteryCheckbox:SetScript("OnClick", function(self)
        asInformationSaved.showMastery = self:GetChecked()
    end)

    local verCheckbox = CreateFrame("CheckButton", nil, optionsPanel, "InterfaceOptionsCheckButtonTemplate")
    verCheckbox:SetPoint("TOPLEFT", masteryCheckbox, "BOTTOMLEFT", 0, -30)
    verCheckbox.Text:SetText(L["Show Ver"])
    verCheckbox:SetChecked(asInformationSaved.showVer)
    verCheckbox:SetScript("OnClick", function(self)
        asInformationSaved.showVer = self:GetChecked()
    end)


    local hasteThresholdSlider = CreateFrame("Slider", nil, optionsPanel, "OptionsSliderTemplate")
    hasteThresholdSlider:SetPoint("TOPLEFT", verCheckbox, "BOTTOMLEFT", 0, -30)
    hasteThresholdSlider:SetMinMaxValues(0, 300)
    hasteThresholdSlider:SetValue(asInformationSaved.hasteThreshold)
    hasteThresholdSlider:SetValueStep(0.5)
    hasteThresholdSlider.Text = hasteThresholdSlider:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    hasteThresholdSlider.Text:SetPoint("TOP", hasteThresholdSlider, "BOTTOM", 0, -5)
    hasteThresholdSlider.Text:SetText(string.format(L["Haste Threshold"] .. ": %d%%", asInformationSaved.hasteThreshold))
    hasteThresholdSlider:SetScript("OnValueChanged", function(self, value)
        asInformationSaved.hasteThreshold = value
        self.Text:SetText(string.format(L["Haste Threshold"] .. ": %d%%", value))
    end)


    optionsPanel.refresh = function()
        lockCheckbox:SetChecked(asInformationSaved.isLocked)
        hasteThresholdSlider:SetValue(asInformationSaved.hasteThreshold)
    end

    -- Show the options panel when the slash command is used
    SLASH_ASINFORMATION1 = "/asinformation"
    SlashCmdList["ASINFORMATION"] = function()
        InterfaceOptionsFrame_OpenToCategory(optionsPanel)
        InterfaceOptionsFrame_OpenToCategory(optionsPanel) -- Double call to avoid interface bug
    end
end

local bfirst = true;

local function OnEvent(self, event, ...)
    if event == "PLAYER_ENTERING_WORLD" then
        if bfirst then
            SetupOptions()
            LoadPosition()
            asInformation:SetUserPlaced(true)
            -- No longer registering UNIT_AURA for stat activation
            bfirst = false;
        end
        RecordCurrentStats() -- Initial recording
        UpdateRecentMinimumStats() -- Initial calculation
        UpdateStats() -- Update stats display
    elseif event == "PLAYER_REGEN_DISABLED" then
        -- Player entered combat
        ResetStatHistoryAndMinimums()
        -- Optional: Could call RecordCurrentStats() and UpdateRecentMinimumStats() here
        -- to establish an immediate baseline for the new combat session.
        -- For now, the OnUpdate ticker will handle this within the recordInterval.
    elseif event == "PLAYER_REGEN_ENABLED" then
        -- Player left combat
        ResetStatHistoryAndMinimums()
    end
end

asInformation:RegisterEvent("PLAYER_ENTERING_WORLD")
asInformation:RegisterEvent("PLAYER_REGEN_DISABLED") -- For combat enter
asInformation:RegisterEvent("PLAYER_REGEN_ENABLED")  -- For combat leave
asInformation:RegisterEvent("ENCOUNTER_START") 
asInformation:RegisterEvent("ENCOUNTER_END")   
asInformation:SetScript("OnEvent", OnEvent)
C_Timer.NewTicker(updateInterval, OnUpdate); -- This ticker calls OnUpdate, which then calls UpdateStats
