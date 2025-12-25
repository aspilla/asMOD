local configs = {
	offset = 100,
	updaterate = 0.5,
};

local function check_frame(frame, cpoint, offset, show)
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


local function hide_frame(frame)
	if not frame then
		return;
	end

	frame:SetAlpha(0);
end

local function on_update()
	local uiScale, x, y = UIParent:GetEffectiveScale(), GetCursorPosition()
	x = x / uiScale;
	y = y / uiScale;
	local cpoint = { x = x, y = y };

	check_frame(MainActionBar, cpoint, configs.offset, false);
	check_frame(StanceBar, cpoint, configs.offset, false);
	check_frame(PetActionBar, cpoint, configs.offset, false);
end

hide_frame(MainActionBar);
hide_frame(StanceBar);
hide_frame(PetActionBar);

C_Timer.NewTicker(configs.updaterate, on_update);
