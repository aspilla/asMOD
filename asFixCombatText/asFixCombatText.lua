-- X, Y 좌표 위치
local _, ns = ...;
local ASCT_STAGGERED = false      -- 데미지 안내가 좌우로 퍼지게 하려면 true
local DAMAGE_COLOR = { 1, 0.1, 0.1 };
local SPELL_DAMAGE_COLOR = { 0.79, 0.3, 0.85 };
local DAMAGE_SHIELD_COLOR = { 1, 0.3, 0.3 };
local SPLIT_DAMAGE_COLOR = { 1, 1, 1 }

local function updateCVar()
	if not InCombatLockdown() then
		SetCVar("enableFloatingCombatText", 1);
	end
end

local leftpoint;

local function asCombatText_StandardScroll(value)
	-- Calculate x and y positions

	if leftpoint then

		local xPos = leftpoint;
		local yPos = value.startY + ((value.endY - COMBAT_TEXT_LOCATIONS.startY) * value.scrollTime / COMBAT_TEXT_SCROLLSPEED);
		return xPos, yPos;

	end
end

local function ASCT_UpdateDisplayedMessages()

	local left, bottom, height = ns.GetPosition();
	local width = UIParent:GetWidth();

	leftpoint = left - width/2 + 50;
	-- Update scrolldirection
	COMBAT_TEXT_SCROLL_FUNCTION = asCombatText_StandardScroll;
	COMBAT_TEXT_LOCATIONS = {
		startX = leftpoint,
		startY = bottom + 100,
		endX = leftpoint,
		endY = (bottom + 100 + height),
	};


end

function ns.init_combattext()
	local bShowHeal = AFCT_Options.ShowHeal;

	C_AddOns.LoadAddOn("Blizzard_CombatText")
	C_Timer.After(1, updateCVar);

	local fontsize = AFCT_Options.FontSize;

	CombatTextFont:SetFont(STANDARD_TEXT_FONT, fontsize, "OUTLINE")
	COMBAT_TEXT_HEIGHT = fontsize;
	COMBAT_TEXT_CRIT_MAXHEIGHT = fontsize + 2
	COMBAT_TEXT_CRIT_MINHEIGHT = fontsize + 1;
	COMBAT_TEXT_STAGGER_RANGE = 0;

	COMBAT_TEXT_TYPE_INFO["DAMAGE_SHIELD"] = {
		r = DAMAGE_SHIELD_COLOR[1],
		g = DAMAGE_SHIELD_COLOR[2],
		b = DAMAGE_SHIELD_COLOR[3],
		show = 1
	};
	COMBAT_TEXT_TYPE_INFO["SPLIT_DAMAGE"] = {
		r = SPLIT_DAMAGE_COLOR[1],
		g = SPLIT_DAMAGE_COLOR[2],
		b = SPLIT_DAMAGE_COLOR[3],
		show = 1
	};
	COMBAT_TEXT_TYPE_INFO["DAMAGE_CRIT"] = { r = DAMAGE_COLOR[1], g = DAMAGE_COLOR[2], b = DAMAGE_COLOR[3], show = 1 };
	COMBAT_TEXT_TYPE_INFO["DAMAGE"] = {
		r = DAMAGE_COLOR[1],
		g = DAMAGE_COLOR[2],
		b = DAMAGE_COLOR[3],
		isStaggered = ASCT_STAGGERED,
		show = 1
	};
	COMBAT_TEXT_TYPE_INFO["SPELL_DAMAGE_CRIT"] = {
		r = SPELL_DAMAGE_COLOR[1],
		g = SPELL_DAMAGE_COLOR[2],
		b = SPELL_DAMAGE_COLOR[3],
		show = 1
	};
	COMBAT_TEXT_TYPE_INFO["SPELL_DAMAGE"] = {
		r = SPELL_DAMAGE_COLOR[1],
		g = SPELL_DAMAGE_COLOR[2],
		b = SPELL_DAMAGE_COLOR[3],
		show = 1
	};
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


local frame = CreateFrame("Frame");
frame:RegisterEvent("ADDON_LOADED");


frame:SetScript("OnEvent", function(self, event, arg1)
	if event == "ADDON_LOADED" and arg1 == "asFixCombatText" then
		C_Timer.After(1, ns.SetupOptionPanels);
	end
end);