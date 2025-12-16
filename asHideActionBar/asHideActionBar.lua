local AHAB_Offset = 100;
local AHAB_UpdateRate = 0.5;

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

local version = select(4, GetBuildInfo());
local action1 = MainActionBar;

local function OnUpdate()
	local uiScale, x, y = UIParent:GetEffectiveScale(), GetCursorPosition()
	x = x / uiScale;
	y = y / uiScale;
	local cpoint = { x = x, y = y };

	CheckFrame(action1, cpoint, AHAB_Offset, false);
	CheckFrame(StanceBar, cpoint, AHAB_Offset, false);
	CheckFrame(PetActionBar, cpoint, AHAB_Offset, false);
end

HideFrame(action1);
HideFrame(StanceBar);
HideFrame(PetActionBar);

C_Timer.NewTicker(AHAB_UpdateRate, OnUpdate);
