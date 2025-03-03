local AHBB_Offset = 100;
local AHBB_UpdateRate = 0.5;

local function CheckFrame(frame, cpoint, offset, show)
	if not frame then
		return;
	end

	local left, top = frame:GetLeft(), frame:GetTop();
	local right, bottom = frame:GetRight(), frame:GetBottom();

	if show or cpoint.x >= left - offset and cpoint.x <= right + offset and cpoint.y >= bottom - offset and cpoint.y <= top + offset then
		frame:SetAlpha(1);
	else
		frame:SetAlpha(0);
	end
end


local function HideFrame(frame)
	if not frame then
		return;
	end

	frame:SetAlpha(0);
end


local function OnUpdate()
	local uiScale, x, y = UIParent:GetEffectiveScale(), GetCursorPosition()
	x = x / uiScale;
	y = y / uiScale;
	local cpoint = { x = x, y = y };

	CheckFrame(MicroMenu, cpoint, AHBB_Offset,
		(UnitInVehicle("player") or (OverrideActionBar and OverrideActionBar:IsShown())));
	CheckFrame(BagsBar, cpoint, AHBB_Offset, false);
	CheckFrame(CompactRaidFrameManager, cpoint, AHBB_Offset, false);
end

HideFrame(MicroMenu);
HideFrame(BagsBar);
HideFrame(CompactRaidFrameManager);

C_Timer.NewTicker(AHBB_UpdateRate, OnUpdate);