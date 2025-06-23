-- X, Y 좌표 위치
local DEFAULT_ASCT_X_POSITION = -250 -- X 시작점 (이제 기본값으로 사용)
local DEFAULT_ASCT_Y_POSITION = 550 -- Y 시작점 (이제 기본값으로 사용)
local ASCT_Y_POSITION_ADDER = 200  --표시위치 Y 높이
local ASCT_STAGGERED = false       -- 데미지 안내가 좌우로 퍼지게 하려면 true
local ASCT_DEFAULT_SHOW_HEAL = nil --Heal 보이게 하려면 1

local asFixCombatTextFrame; -- Draggable frame
local ASCT_SAVED_POSITION = { -- Holds current/saved position for the anchor
	point = "CENTER",
	relativePoint = "CENTER",
	parent = "UIParent", -- Default parent
	xOfs = DEFAULT_ASCT_X_POSITION,
	yOfs = DEFAULT_ASCT_Y_POSITION,
}

-- Function to load saved position for a frame
local function LoadPosition(frame, positionData)
    if not frame or not positionData or not positionData.point or not positionData.relativePoint or positionData.xOfs == nil or positionData.yOfs == nil then
        -- print("asFixCombatText: Invalid data for LoadPosition")
        return
    end
    frame:ClearAllPoints()
    -- Ensure parent is valid, default to UIParent if not found or nil
    local parentFrame = UIParent
    if positionData.parent and _G[positionData.parent] then
        parentFrame = _G[positionData.parent]
    end
    frame:SetPoint(positionData.point, parentFrame, positionData.relativePoint, positionData.xOfs, positionData.yOfs)
end

-- Function to save a frame's current position
local function SavePosition(frame, positionData)
    if not frame or not positionData then return end
	local point, parent, relativePoint, xOfs, yOfs = frame:GetPoint()
	positionData.point = point
	positionData.parent = parent and parent:GetName() or "UIParent" -- Store parent name, default to UIParent
	positionData.relativePoint = relativePoint
	positionData.xOfs = xOfs
	positionData.yOfs = yOfs
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
	local bShowHeal = ASCT_DEFAULT_SHOW_HEAL

	C_AddOns.LoadAddOn("Blizzard_CombatText")
	C_Timer.After(1, updateCVar)

	CombatTextFont:SetFont(STANDARD_TEXT_FONT, 18, "OUTLINE")
	COMBAT_TEXT_HEIGHT = 16;
	COMBAT_TEXT_CRIT_MAXHEIGHT = 24;
	COMBAT_TEXT_CRIT_MINHEIGHT = 18;
	COMBAT_TEXT_STAGGER_RANGE = 5;

	COMBAT_TEXT_TYPE_INFO["DAMAGE_SHIELD"] = { r = DAMAGE_SHIELD_COLOR[1], g = DAMAGE_SHIELD_COLOR[2],
		b = DAMAGE_SHIELD_COLOR[3], show = 1 };
	COMBAT_TEXT_TYPE_INFO["SPLIT_DAMAGE"] = { r = SPLIT_DAMAGE_COLOR[1], g = SPLIT_DAMAGE_COLOR[2],
		b = SPLIT_DAMAGE_COLOR[3], show = 1 };
	COMBAT_TEXT_TYPE_INFO["DAMAGE_CRIT"] = { r = DAMAGE_COLOR[1], g = DAMAGE_COLOR[2], b = DAMAGE_COLOR[3], show = 1 };
	COMBAT_TEXT_TYPE_INFO["DAMAGE"] = { r = DAMAGE_COLOR[1], g = DAMAGE_COLOR[2], b = DAMAGE_COLOR[3],
		isStaggered = ASCT_STAGGERED, show = 1 };
	COMBAT_TEXT_TYPE_INFO["SPELL_DAMAGE_CRIT"] = { r = SPELL_DAMAGE_COLOR[1], g = SPELL_DAMAGE_COLOR[2],
		b = SPELL_DAMAGE_COLOR[3], show = 1 };
	COMBAT_TEXT_TYPE_INFO["SPELL_DAMAGE"] = { r = SPELL_DAMAGE_COLOR[1], g = SPELL_DAMAGE_COLOR[2],
		b = SPELL_DAMAGE_COLOR[3], show = 1 };
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
	asFixCombatTextFrame:SetSize(150, 30)
	asFixCombatTextFrame:SetMovable(true)
	asFixCombatTextFrame:EnableMouse(true)
	asFixCombatTextFrame:RegisterForDrag("LeftButton")
	asFixCombatTextFrame:SetClampedToScreen(true)
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
	asFixCombatTextFrame:SetScript("OnDragStart", function(self)
		if InCombatLockdown() then return end
		self:StartMoving()
		self.isMoving = true
		self.text:SetText("Moving...")
	end)
	asFixCombatTextFrame:SetScript("OnDragStop", function(self)
		if not self.isMoving then return end
		self:StopMovingOrSizing()
		self.isMoving = false
		SavePosition(self, ASCT_SAVED_POSITION)
		if _G["ASCT_FixCombatText_SavedVars"] then
			_G["ASCT_FixCombatText_SavedVars"].position = ASCT_SAVED_POSITION
		end
		ASCT_UpdateDisplayedMessages()
		self.text:SetText("Combat Anchor")
	end)
	asFixCombatTextFrame:Hide()
	return;
end

function ASCT_UpdateDisplayedMessages()
    if not asFixCombatTextFrame then return end

    local targetX, targetY
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
            if _G["asMOD_ConfigModeActive"] then -- Check if asMOD config mode is active
                 LoadPosition(asFixCombatTextFrame, asmodPosData)
            end
            useAsModPos = true
        end
    end

    if not useAsModPos then
        LoadPosition(asFixCombatTextFrame, ASCT_SAVED_POSITION)
        targetX = asFixCombatTextFrame:GetLeft()
        targetY = asFixCombatTextFrame:GetTop()
    end

    COMBAT_TEXT_SCROLL_FUNCTION = _G["asCombatText_StandardScroll_Overridden"] or asCombatText_StandardScroll_Original;
    COMBAT_TEXT_LOCATIONS = {
        startX = targetX,
        startY = targetY,
        endX = targetX,
        endY = targetY - ASCT_Y_POSITION_ADDER,
    };
end

-- Store original scroll function
asCombatText_StandardScroll_Original = asCombatText_StandardScroll

-- Create the new scroll function under a different name to avoid potential global conflicts if already defined
function asCombatText_StandardScroll_Overridden(value)
    if not asFixCombatTextFrame then
        local x = DEFAULT_ASCT_X_POSITION;
        local y = value.startY + ((value.endY - (COMBAT_TEXT_LOCATIONS and COMBAT_TEXT_LOCATIONS.startY or DEFAULT_ASCT_Y_POSITION)) * value.scrollTime / COMBAT_TEXT_SCROLLSPEED);
        if value.isStaggered and ASCT_STAGGERED then x = x + value.staggerOffset; end
        return x, y;
    end

    local frameX, frameY = asFixCombatTextFrame:GetLeft(), asFixCombatTextFrame:GetTop()
    local currentXPos = frameX;
    local scrollProgress = value.scrollTime / COMBAT_TEXT_SCROLLSPEED;
    local currentYPos = frameY - (ASCT_Y_POSITION_ADDER * scrollProgress);

    if value.isStaggered and ASCT_STAGGERED then
        currentXPos = currentXPos + value.staggerOffset;
    end
    return currentXPos, currentYPos;
end


local asctEventHandler = CreateFrame("Frame")
asctEventHandler:RegisterEvent("ADDON_LOADED")
asctEventHandler:RegisterEvent("PLAYER_ENTERING_WORLD")

asctEventHandler:SetScript("OnEvent", function(self, event, arg1)
    if event == "ADDON_LOADED" and arg1 == "asFixCombatText" then
        _G["ASCT_FixCombatText_SavedVars"] = _G["ASCT_FixCombatText_SavedVars"] or {}
        _G["ASCT_FixCombatText_SavedVars"].position = _G["ASCT_FixCombatText_SavedVars"].position or {
            point = "CENTER",
            relativePoint = "CENTER",
            parent = "UIParent",
            xOfs = DEFAULT_ASCT_X_POSITION,
            yOfs = DEFAULT_ASCT_Y_POSITION,
        }
        ASCT_SAVED_POSITION = _G["ASCT_FixCombatText_SavedVars"].position
        init_combattext()
        if asFixCombatTextFrame then
            LoadPosition(asFixCombatTextFrame, ASCT_SAVED_POSITION)
            ASCT_UpdateDisplayedMessages()
        end
        C_Timer.After(1.0, function()
            if _G["asMOD_setupFrame"] and asFixCombatTextFrame then
                _G["asMOD_setupFrame"](asFixCombatTextFrame, "asFixCombatText")
                ASCT_UpdateDisplayedMessages()
            end
        end)
    elseif event == "PLAYER_ENTERING_WORLD" then
        if asFixCombatTextFrame and ASCT_SAVED_POSITION then
            LoadPosition(asFixCombatTextFrame, ASCT_SAVED_POSITION)
            ASCT_UpdateDisplayedMessages()
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
