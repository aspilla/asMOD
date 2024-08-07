local AHBB_Offset = 100;

local function AHBB_HideMenuBar(show)
	if UnitInVehicle("player") then
		show = 1;
	end

	MicroMenu:SetAlpha(show)
end

local function AHBB_HideBagsBar(show)
	if UnitInVehicle("player") then
		show = 1;
	end

	BagsBar:SetAlpha(show)
end

local function AHBB_HideContainerFrame(show)
	if UnitInVehicle("player") then
		show = 1;
	end

	CompactRaidFrameManager:SetAlpha(show)
end


local function AHBB_OnUpdate()
	local uiScale, x, y = UIParent:GetEffectiveScale(), GetCursorPosition()
	x = x / uiScale;
	y = y / uiScale;
	local menu_left, menu_top = MicroMenu:GetLeft(), MicroMenu:GetTop();
	local menu_right, menu_bottom = MicroMenu:GetRight(), MicroMenu:GetBottom();

	if x >= menu_left - AHBB_Offset and x <= menu_right + AHBB_Offset and y >= menu_bottom - AHBB_Offset and y <= menu_top + AHBB_Offset then
		
		AHBB_HideMenuBar(1);
	else
		AHBB_HideMenuBar(0);
	end
	
	local bag_left, bag_top = BagsBar:GetLeft(), BagsBar:GetTop();
	local bag_right, bag_bottom = BagsBar:GetRight(), BagsBar:GetBottom();

	if x >= bag_left - AHBB_Offset and x <= bag_right + AHBB_Offset and y >= bag_bottom - AHBB_Offset and y <= bag_top + AHBB_Offset then
		AHBB_HideBagsBar(1);
	else
		AHBB_HideBagsBar(0);
	end

	local raid_left, raid_top = CompactRaidFrameManager:GetLeft(), CompactRaidFrameManager:GetTop();
	local raid_right, raid_bottom = CompactRaidFrameManager:GetRight(), CompactRaidFrameManager:GetBottom();

	if x >= raid_left - AHBB_Offset and x <= raid_right + AHBB_Offset and y >= raid_bottom - AHBB_Offset and y <= raid_top + AHBB_Offset then
		AHBB_HideContainerFrame(1);
	else
		AHBB_HideContainerFrame(0);
	end
end

AHBB_HideMenuBar(0);
AHBB_HideBagsBar(0);
AHBB_HideContainerFrame(0);
C_Timer.NewTicker(0.5, AHBB_OnUpdate);
