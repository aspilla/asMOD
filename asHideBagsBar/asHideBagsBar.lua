local AHBB_Offset = 100;
local AHBB_UpdateRate = 0.5;

local function CheckFramePosition(frame, cpoint, offset, show)
	local left, top = frame:GetLeft(), frame:GetTop();
	local right, bottom = frame:GetRight(), frame:GetBottom();

	if show or cpoint.x >= left - offset and cpoint.x <= right + offset and cpoint.y >= bottom - offset and cpoint.y <= top + offset then
		frame:SetAlpha(1);
	else
		frame:SetAlpha(0);
	end
end


local function OnUpdate()
	local uiScale, x, y = UIParent:GetEffectiveScale(), GetCursorPosition()
	x = x / uiScale;
	y = y / uiScale;
	local cpoint = { x = x, y = y };

	CheckFramePosition(MicroMenu, cpoint, AHBB_Offset,
		(UnitInVehicle("player") or (OverrideActionBar and OverrideActionBar:IsShown())));
	CheckFramePosition(BagsBar, cpoint, AHBB_Offset, (UnitInVehicle("player")));
	CheckFramePosition(CompactRaidFrameManager, cpoint, AHBB_Offset, (UnitInVehicle("player")));
end

MicroMenu:SetAlpha(0);
BagsBar:SetAlpha(0);
CompactRaidFrameManager:SetAlpha(0);
C_Timer.NewTicker(AHBB_UpdateRate, OnUpdate);