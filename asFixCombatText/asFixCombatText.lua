-- X, Y 좌표 위치
local ASCT_X_POSITION = -300        -- X 시작점
local ASCT_Y_POSITION = 500        -- Y 시작점
local ASCT_Y_POSITION_ADDER = 250  --표시위치 Y 높이
local ASCT_STAGGERED = false       -- 데미지 안내가 좌우로 퍼지게 하려면 true
local ASCT_DEFAULT_SHOW_HEAL = nil --Heal 보이게 하려면 1
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
		
	CombatTextFont:SetFont("Fonts\\2002.ttf", 18, "OUTLINE")
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
	ASCT_UpdateDisplayedMessages()
	return;
end

function asCombatText_StandardScroll(value)
	-- Calculate x and y positions
	local xPos = ASCT_X_POSITION;
	local yPos = value.startY+((value.endY - COMBAT_TEXT_LOCATIONS.startY)*value.scrollTime/COMBAT_TEXT_SCROLLSPEED);
	return xPos, yPos;
end

function ASCT_UpdateDisplayedMessages()
	-- Update scrolldirection
	COMBAT_TEXT_SCROLL_FUNCTION = asCombatText_StandardScroll;
	COMBAT_TEXT_LOCATIONS = {
		startX = ASCT_X_POSITION,
		startY = ASCT_Y_POSITION,
		endX = ASCT_X_POSITION,
		endY = (ASCT_Y_POSITION + 225),
	};
end

init_combattext();
