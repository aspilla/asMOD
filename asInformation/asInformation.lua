local asInformation = CreateFrame("Frame", "asInformationFrame", UIParent)
asInformation:SetSize(100, 150)
asInformation:SetPoint("BOTTOM", UIParent, "BOTTOM", -141, 109)
asInformation:EnableMouse(true)
asInformation:SetMovable(true)
asInformation:RegisterForDrag("LeftButton")

local updateInterval = 0.2
local timeSinceLastUpdate = 0
local defaultHasteThreshold = 50

-- Saved variables for position, lock state, and stat thresholds
asInformationSaved = asInformationSaved or {
    point = "BOTTOM",
    relativePoint = "BOTTOM",
    xOfs = -141,
    yOfs = 109,
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
local hasteText;
local critText
local masteryText
local versatilityText
local locationPoint = "TOPLEFT";

if asInformationSaved.showCrit then
    critText = asInformation:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    critText:SetPoint("TOPLEFT", prevframe, locationPoint, 0, -5)
    critText:SetTextColor(1, 1, 1)
    prevframe = critText
    locationPoint = "BOTTOMLEFT";
end

if asInformationSaved.showHaste then
    -- Create font strings for displaying stats
    hasteText = asInformation:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    hasteText:SetPoint("TOPLEFT", prevframe, locationPoint, 0, -5)
    hasteText:SetTextColor(1, 1, 1)
    prevframe = hasteText
    locationPoint = "BOTTOMLEFT";
end

if asInformationSaved.showMastery then
    masteryText = asInformation:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    masteryText:SetPoint("TOPLEFT", prevframe, locationPoint, 0, -5)
    masteryText:SetTextColor(1, 1, 1)
    prevframe = masteryText
    locationPoint = "BOTTOMLEFT";
end
if asInformationSaved.showVer then
    versatilityText = asInformation:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    versatilityText:SetPoint("TOPLEFT", prevframe, locationPoint, 0, -5)
    versatilityText:SetTextColor(1, 1, 1)
    prevframe = versatilityText
    locationPoint = "BOTTOMLEFT";
end


local function UpdateStats()
    local haste = GetHaste()
    local crit = GetCritChance()
    local mastery = GetMasteryEffect()
    local versatility = GetCombatRatingBonus(CR_VERSATILITY_DAMAGE_DONE)

    if asInformationSaved.showHaste then
        hasteText:SetText(string.format("H" .. ": %.2f%%", haste))

        if haste >= asInformationSaved.hasteThreshold then
            hasteText:SetFontObject(GameFontHighlightLarge)
            hasteText:SetTextColor(1, 1, 0)
        else
            hasteText:SetFontObject(GameFontNormal)
            hasteText:SetTextColor(1, 1, 1)
        end
    end

    if asInformationSaved.showCrit then
        critText:SetText(string.format("C" .. ": %.2f%%", crit))
    end

    if asInformationSaved.showMastery then
        masteryText:SetText(string.format("M" .. ": %.2f%%", mastery))
    end

    if asInformationSaved.showVer then
        versatilityText:SetText(string.format("V" .. ": %.2f%%", versatility))
    end
end


local function OnUpdate(self, elapsed)
    timeSinceLastUpdate = timeSinceLastUpdate + elapsed
    if timeSinceLastUpdate >= updateInterval then
        UpdateStats()
        timeSinceLastUpdate = 0
    end
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
    InterfaceOptions_AddCategory(optionsPanel)

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
        end
        UpdateStats()
    end
end

asInformation:RegisterEvent("PLAYER_ENTERING_WORLD")
asInformation:RegisterEvent("ENCOUNTER_START")
asInformation:RegisterEvent("ENCOUNTER_END")
asInformation:SetScript("OnEvent", OnEvent)
asInformation:SetScript("OnUpdate", OnUpdate)