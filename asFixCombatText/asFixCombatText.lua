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

local function ASCT_UpdateDisplayedMessages(self)

	local left, bottom, height = ns.GetPosition();
	local width = UIParent:GetWidth();

	leftpoint = left - width/2 + 50;
	-- Update scrolldirection

	CombatTextMixin.scrollFunction = CombatTextUtil.StandardScroll;
	CombatTextMixin.textLocations = {
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
	CombatTextConstants.MessageHeight = fontsize;
	CombatTextConstants.CriticalHitMaxHeight = fontsize + 2
	CombatTextConstants.CriticalHitMinHeight = fontsize + 1;
	CombatTextConstants.StaggerRange = 0;

	CombatTextTypeInfo["DAMAGE_SHIELD"] = {
		r = DAMAGE_SHIELD_COLOR[1],
		g = DAMAGE_SHIELD_COLOR[2],
		b = DAMAGE_SHIELD_COLOR[3],
		show = 1
	};
	CombatTextTypeInfo["SPLIT_DAMAGE"] = {
		r = SPLIT_DAMAGE_COLOR[1],
		g = SPLIT_DAMAGE_COLOR[2],
		b = SPLIT_DAMAGE_COLOR[3],
		show = 1
	};
	CombatTextTypeInfo["DAMAGE_CRIT"] = { r = DAMAGE_COLOR[1], g = DAMAGE_COLOR[2], b = DAMAGE_COLOR[3], show = 1 };
	CombatTextTypeInfo["DAMAGE"] = {
		r = DAMAGE_COLOR[1],
		g = DAMAGE_COLOR[2],
		b = DAMAGE_COLOR[3],
		isStaggered = ASCT_STAGGERED,
		show = 1
	};
	CombatTextTypeInfo["SPELL_DAMAGE_CRIT"] = {
		r = SPELL_DAMAGE_COLOR[1],
		g = SPELL_DAMAGE_COLOR[2],
		b = SPELL_DAMAGE_COLOR[3],
		show = 1
	};
	CombatTextTypeInfo["SPELL_DAMAGE"] = {
		r = SPELL_DAMAGE_COLOR[1],
		g = SPELL_DAMAGE_COLOR[2],
		b = SPELL_DAMAGE_COLOR[3],
		show = 1
	};
	CombatTextTypeInfo["ENTERING_COMBAT"] = { r = 1, g = 0.1, b = 0.1, show = 1 };
	CombatTextTypeInfo["LEAVING_COMBAT"] = { r = 0.1, g = 1, b = 0.1, show = 1 };
	CombatTextTypeInfo["HEAL_CRIT"] = { r = 0.1, g = 1, b = 0.1, show = bShowHeal };
	CombatTextTypeInfo["HEAL"] = { r = 0.1, g = 1, b = 0.1, show = bShowHeal };
	CombatTextTypeInfo["PERIODIC_HEAL_ABSORB"] = { r = 0.1, g = 1, b = 0.1, show = bShowHeal };
	CombatTextTypeInfo["HEAL_CRIT_ABSORB"] = { r = 0.1, g = 1, b = 0.1, show = bShowHeal };
	CombatTextTypeInfo["HEAL_ABSORB"] = { r = 0.1, g = 1, b = 0.1, show = bShowHeal };
	CombatTextTypeInfo["PERIODIC_HEAL"] = { r = 0.1, g = 1, b = 0.1, show = bShowHeal };
	CombatTextTypeInfo["PERIODIC_HEAL_CRIT"] = { r = 0.1, g = 1, b = 0.1, show = bShowHeal };
	CombatTextTypeInfo["ABSORB_ADDED"] = { r = 0.1, g = 1, b = 0.1, show = bShowHeal };

	ASCT_UpdateDisplayedMessages();
	return;
end


local frame = CreateFrame("Frame");
frame:RegisterEvent("ADDON_LOADED");


frame:SetScript("OnEvent", function(self, event, arg1)
	if event == "ADDON_LOADED" and arg1 == "asFixCombatText" then
		C_Timer.After(1, ns.SetupOptionPanels);
	end
end);