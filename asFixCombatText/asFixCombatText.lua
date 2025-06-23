local ns = _G["asFixCombatText"] or {} -- Use existing namespace or create one
_G["asFixCombatText"] = ns -- Ensure it's global

local asFixCombatTextFrame; -- Draggable frame, will be defined in init_combattext

-- Core constants that might not need to be in options or are fundamental
local COMBAT_TEXT_SCROLLSPEED_BASE = COMBAT_TEXT_SCROLLSPEED -- Preserve base game value if needed, though we mostly use our own logic

-- Function to load saved position for a frame (moved from top for clarity, as it uses ns.options)
local function LoadPosition(frame, positionData)
    if not frame or not positionData or not positionData.point or not positionData.relativePoint or positionData.xOfs == nil or positionData.yOfs == nil then
        -- print("asFixCombatText: Invalid data for LoadPosition")
        return
    end
    frame:ClearAllPoints()
    local parentFrame = UIParent
    if positionData.parent and _G[positionData.parent] then
        parentFrame = _G[positionData.parent]
    end
    frame:SetPoint(positionData.point, parentFrame, positionData.relativePoint, positionData.xOfs, positionData.yOfs)
    -- Apply height if available in positionData (which now comes from ns.options.Position or ns.options itself)
    if positionData.height then
        frame:SetHeight(positionData.height)
    elseif ns.options and ns.options.Height then -- Fallback to general height option
         frame:SetHeight(ns.options.Height)
    end
end

-- Function to save a frame's current position and size
local function SavePositionAndSize(frame)
    if not frame or not ns.options or not ns.options.Position then return end
	local point, parent, relativePoint, xOfs, yOfs = frame:GetPoint()
	ns.options.Position.point = point
	ns.options.Position.parent = parent and parent:GetName() or "UIParent"
	ns.options.Position.relativePoint = relativePoint
	ns.options.Position.xOfs = xOfs
	ns.options.Position.yOfs = yOfs
    ns.options.Height = frame:GetHeight() -- Save height
    -- Note: ASCT_FixCombatText_SavedVars is automatically saved by WoW.
    -- ns.options points to ASCT_FixCombatText_SavedVars.
end

local DAMAGE_COLOR = { 1, 0.1, 0.1 };
local SPELL_DAMAGE_COLOR = { 0.79, 0.3, 0.85 };
local DAMAGE_SHIELD_COLOR = { 1, 0.3, 0.3 };
local SPLIT_DAMAGE_COLOR = { 1, 1, 1 }

local function updateCVar ()
	if not InCombatLockdown() then
		SetCVar("enableFloatingCombatText", 1);
	end
end

local function init_combattext()
	-- Use ns.options for defaults now
	local bShowHeal = ns.options.ShowHeal

	C_AddOns.LoadAddOn("Blizzard_CombatText")
	C_Timer.After(1, updateCVar)

	CombatTextFont:SetFont(STANDARD_TEXT_FONT, 18, "OUTLINE")
	-- These Blizzard globals might still be used by CombatText_UpdateDisplayedMessages or other C functions
	COMBAT_TEXT_HEIGHT = 16;
	COMBAT_TEXT_CRIT_MAXHEIGHT = 24;
	COMBAT_TEXT_CRIT_MINHEIGHT = 18;
	COMBAT_TEXT_STAGGER_RANGE = 5; -- This could also be an option if desired

	-- Update combat text type info based on options
	COMBAT_TEXT_TYPE_INFO["DAMAGE_SHIELD"] = { r = DAMAGE_COLOR[1], g = DAMAGE_COLOR[2], b = DAMAGE_COLOR[3], show = 1 };
	COMBAT_TEXT_TYPE_INFO["SPLIT_DAMAGE"] = { r = SPLIT_DAMAGE_COLOR[1], g = SPLIT_DAMAGE_COLOR[2], b = SPLIT_DAMAGE_COLOR[3], show = 1 };
	COMBAT_TEXT_TYPE_INFO["DAMAGE_CRIT"] = { r = DAMAGE_COLOR[1], g = DAMAGE_COLOR[2], b = DAMAGE_COLOR[3], show = 1 };
	COMBAT_TEXT_TYPE_INFO["DAMAGE"] = { r = DAMAGE_COLOR[1], g = DAMAGE_COLOR[2], b = DAMAGE_COLOR[3], isStaggered = ns.options.Staggered, show = 1 };
	COMBAT_TEXT_TYPE_INFO["SPELL_DAMAGE_CRIT"] = { r = SPELL_DAMAGE_COLOR[1], g = SPELL_DAMAGE_COLOR[2], b = SPELL_DAMAGE_COLOR[3], show = 1 };
	COMBAT_TEXT_TYPE_INFO["SPELL_DAMAGE"] = { r = SPELL_DAMAGE_COLOR[1], g = SPELL_DAMAGE_COLOR[2], b = SPELL_DAMAGE_COLOR[3], isStaggered = ns.options.Staggered, show = 1 };
	COMBAT_TEXT_TYPE_INFO["ENTERING_COMBAT"] = { r = 1, g = 0.1, b = 0.1, show = 1 };
	COMBAT_TEXT_TYPE_INFO["LEAVING_COMBAT"] = { r = 0.1, g = 1, b = 0.1, show = 1 };
	COMBAT_TEXT_TYPE_INFO["HEAL_CRIT"] = { r = 0.1, g = 1, b = 0.1, show = bShowHeal };
	COMBAT_TEXT_TYPE_INFO["HEAL"] = { r = 0.1, g = 1, b = 0.1, show = bShowHeal };
	COMBAT_TEXT_TYPE_INFO["PERIODIC_HEAL_ABSORB"] = { r = 0.1, g = 1, b = 0.1, show = bShowHeal };
	COMBAT_TEXT_TYPE_INFO["HEAL_CRIT_ABSORB"] = { r = 0.1, g = 1, b = 0.1, show = bShowHeal };
	COMBAT_TEXT_TYPE_INFO["HEAL_ABSORB"] = { r = 0.1, g = 1, b = 0.1, show = bShowHeal };
	COMBAT_TEXT_TYPE_INFO["PERIODIC_HEAL"] = { r = 0.1, g = 1, b = 0.1, show = bShowHeal };
	COMBAT_TEXT_TYPE_INFO["PERIODIC_HEAL_CRIT"] = { r = 0.1, g = 1, b = 0.1, show = bShowHeal };
	COMBAT_TEXT_TYPE_INFO["ABSORB_ADDED"] = { r = 0.1, g = 1, b = 0.1, show = bShowHeal };

	hooksecurefunc("CombatText_UpdateDisplayedMessages", ASCT_UpdateDisplayedMessages);

	asFixCombatTextFrame = CreateFrame("Frame", "asFixCombatTextMovableFrame", UIParent)
	-- Set initial size from options
	asFixCombatTextFrame:SetSize(150, ns.options.Height or 30) -- Default width 150, height from options or 30
	asFixCombatTextFrame:SetMovable(true)
	asFixCombatTextFrame:EnableMouse(true)
	asFixCombatTextFrame:RegisterForDrag("LeftButton")
	asFixCombatTextFrame:SetClampedToScreen(true)
	-- Enable resizing (height only for now)
	asFixCombatTextFrame:SetResizable(true)
	asFixCombatTextFrame:SetMinResize(100, 20) -- Min width, Min height
	asFixCombatTextFrame:SetMaxResize(500, 100) -- Max width, Max height (adjust as needed)

	asFixCombatTextFrame:SetBackdrop({
		bgFile = "Interface/Tooltips/UI-Tooltip-Background",
		edgeFile = "Interface/Tooltips/UI-Tooltip-Border",
		tile = true, tileSize = 16, edgeSize = 16,
		insets = { left = 4, right = 4, top = 4, bottom = 4 }
	})
	asFixCombatTextFrame:SetBackdropColor(0.1, 0.1, 0.1, 0.65)
	asFixCombatTextFrame:SetBackdropBorderColor(0.6, 0.6, 0.6, 0.8)

	asFixCombatTextFrame.text = asFixCombatTextFrame:CreateFontString(nil, "OVERLAY")
	asFixCombatTextFrame.text:SetFont(STANDARD_TEXT_FONT, 10, "OUTLINE")
	asFixCombatTextFrame.text:SetPoint("CENTER")
	asFixCombatTextFrame.text:SetText("Combat Anchor")

	-- Create a resize handle (e.g., a small button at the bottom-right)
	local resizeHandle = CreateFrame("Button", nil, asFixCombatTextFrame)
	resizeHandle:SetSize(12, 12)
	resizeHandle:SetPoint("BOTTOMRIGHT", -2, -2) -- Position slightly inset
	resizeHandle:SetNormalTexture("Interface\\ChatFrame\\ChatFrameExpandButton") -- Example texture

	resizeHandle:SetScript("OnMouseDown", function(self, button)
        if button == "LeftButton" and not InCombatLockdown() then
            asFixCombatTextFrame:StartSizing("BOTTOMRIGHT")
            asFixCombatTextFrame.isResizing = true
            asFixCombatTextFrame.text:SetText("Resizing...")
        end
    end)
    resizeHandle:SetScript("OnMouseUp", function(self, button)
        if button == "LeftButton" and asFixCombatTextFrame.isResizing then
            asFixCombatTextFrame:StopMovingOrSizing()
            asFixCombatTextFrame.isResizing = false
            SavePositionAndSize(asFixCombatTextFrame) -- Save new size
            ASCT_UpdateDisplayedMessages()
            asFixCombatTextFrame.text:SetText("Combat Anchor")
        end
    end)


	asFixCombatTextFrame:SetScript("OnDragStart", function(self)
		if InCombatLockdown() or self.isResizing then return end
		self:StartMoving()
		self.isMoving = true
		self.text:SetText("Moving...")
	end)
	asFixCombatTextFrame:SetScript("OnDragStop", function(self)
		if not self.isMoving or self.isResizing then return end
		self:StopMovingOrSizing()
		self.isMoving = false
		SavePositionAndSize(asFixCombatTextFrame) -- Now saves size too
		ASCT_UpdateDisplayedMessages()
		self.text:SetText("Combat Anchor")
	end)

	-- Show/hide based on ns.options.ShowAnchor, but prioritize asMOD config mode
    if ns.options.ShowAnchor or (_G["asMOD_ConfigModeActive"] and _G["asMOD_ConfigModeActive"]["asFixCombatText"]) then
        asFixCombatTextFrame:Show()
    else
        asFixCombatTextFrame:Hide()
    end
	return;
end

function ASCT_UpdateDisplayedMessages()
    if not asFixCombatTextFrame then return end

    local targetX, targetY, targetHeight
    local useAsModPos = false

    if _G["asMOD_position"] and _G["asMOD_position"]["asFixCombatText"] then
        local asmodPosData = _G["asMOD_position"]["asFixCombatText"]
        if asmodPosData.point and asmodPosData.relativePoint and asmodPosData.xOfs ~= nil and asmodPosData.yOfs ~= nil then
            local tempFrame = _G["ASCT_TempFrame"] or CreateFrame("Frame", "ASCT_TempFrame", UIParent)
            tempFrame:ClearAllPoints()
            local parentFrame = UIParent
            if asmodPosData.parent and _G[asmodPosData.parent] then
                parentFrame = _G[asmodPosData.parent]
            end
            tempFrame:SetPoint(asmodPosData.point, parentFrame, asmodPosData.relativePoint, asmodPosData.xOfs, asmodPosData.yOfs)
            targetX = tempFrame:GetLeft()
            targetY = tempFrame:GetTop()
            targetHeight = asmodPosData.height or ns.options.Height -- Use asMOD height if available

            if _G["asMOD_ConfigModeActive"] then
                 LoadPosition(asFixCombatTextFrame, asmodPosData) -- This will also set height if present in asmodPosData
                 asFixCombatTextFrame:SetHeight(targetHeight) -- Ensure height is set
            end
            useAsModPos = true
        end
    end

    if not useAsModPos then
        LoadPosition(asFixCombatTextFrame, ns.options.Position) -- Loads position and height from ns.options
        targetX = asFixCombatTextFrame:GetLeft()
        targetY = asFixCombatTextFrame:GetTop()
        targetHeight = ns.options.Height
    end

    asFixCombatTextFrame:SetHeight(targetHeight) -- Ensure anchor frame has the correct height

	-- Use ns.options for scroll distance
    local scrollDistance = ns.options.ScrollDistance
    COMBAT_TEXT_SCROLL_FUNCTION = _G["asCombatText_StandardScroll_Overridden"] or asCombatText_StandardScroll_Original;
    COMBAT_TEXT_LOCATIONS = {
        startX = targetX,
        startY = targetY,
        endX = targetX,
        endY = targetY - scrollDistance, -- Use scrollDistance from options
    };
end

-- Store original scroll function from Blizzard's CombatText code if not already done
if not asCombatText_StandardScroll_Original then
    asCombatText_StandardScroll_Original = CombatText_StandardScroll
    -- It's possible CombatText_StandardScroll is not global.
    -- If so, this needs to be handled carefully, perhaps by finding it in Blizzard's CombatText source.
    -- For now, assume it's accessible or that our override is sufficient.
    -- If it's not global, we might need to hook `CombatText_UpdateDisplayedMessages`
    -- to always assign our `asCombatText_StandardScroll_Overridden` to `COMBAT_TEXT_SCROLL_FUNCTION`.
end


-- Create the new scroll function under a different name to avoid potential global conflicts if already defined
function asCombatText_StandardScroll_Overridden(value)
    if not asFixCombatTextFrame then
        -- Fallback to a simplified default if frame isn't ready
        local x = ns.options.Position.xOfs or -250; -- Use default X from options
        -- Simplified Y calculation for fallback
        local y = (ns.options.Position.yOfs or 550) - ( (ns.options.ScrollDistance or 200) * (value.scrollTime / (COMBAT_TEXT_SCROLLSPEED_BASE or COMBAT_TEXT_SCROLLSPEED)));
        if value.isStaggered and ns.options.Staggered then x = x + value.staggerOffset; end
        return x, y;
    end

    local frameX, frameY = asFixCombatTextFrame:GetLeft(), asFixCombatTextFrame:GetTop()
    local currentXPos = frameX;
    local scrollProgress = value.scrollTime / (COMBAT_TEXT_SCROLLSPEED_BASE or COMBAT_TEXT_SCROLLSPEED); -- Use base scroll speed
    local currentYPos = frameY - (ns.options.ScrollDistance * scrollProgress); -- Use scroll distance from options

    if value.isStaggered and ns.options.Staggered then -- Use stagger from options
        currentXPos = currentXPos + value.staggerOffset;
    end
    return currentXPos, currentYPos;
end


local asctEventHandler = CreateFrame("Frame")
asctEventHandler:RegisterEvent("ADDON_LOADED")
asctEventHandler:RegisterEvent("PLAYER_ENTERING_WORLD")

asctEventHandler:SetScript("OnEvent", function(self, event, arg1)
    if event == "ADDON_LOADED" and arg1 == "asFixCombatText" then
        -- Options are now initialized in asFixCombatTextOption.lua and available via ns.options
        -- Ensure ns.options is populated by the time init_combattext is called.
        -- This usually means asFixCombatTextOption.lua should be listed before this file in the .toc
        -- or loaded explicitly first.

        init_combattext() # Initialize frames and combat text hooks

        if asFixCombatTextFrame then
            LoadPosition(asFixCombatTextFrame, ns.options.Position) # Load position and height
            ASCT_UpdateDisplayedMessages()
        end

        C_Timer.After(1.0, function()
            if _G["asMOD_setupFrame"] and asFixCombatTextFrame then
                _G["asMOD_setupFrame"](asFixCombatTextFrame, "asFixCombatText")
                ASCT_UpdateDisplayedMessages()
            end
        end)
    elseif event == "PLAYER_ENTERING_WORLD" then
        if asFixCombatTextFrame and ns.options and ns.options.Position then
            LoadPosition(asFixCombatTextFrame, ns.options.Position)
            ASCT_UpdateDisplayedMessages()
            -- Update anchor visibility based on option
            if ns.options.ShowAnchor or (_G["asMOD_ConfigModeActive"] and _G["asMOD_ConfigModeActive"]["asFixCombatText"]) then
                asFixCombatTextFrame:Show()
            else
                asFixCombatTextFrame:Hide()
            end
        end
        C_Timer.After(1.2, function()
            if _G["asMOD_setupFrame"] and asFixCombatTextFrame then
                if not asFixCombatTextFrame.asMODRegistered then
                    _G["asMOD_setupFrame"](asFixCombatTextFrame, "asFixCombatText")
                    asFixCombatTextFrame.asMODRegistered = true
                end
                ASCT_UpdateDisplayedMessages()
            end
        end)
    end
end)
