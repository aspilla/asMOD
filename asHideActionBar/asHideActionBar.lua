local _, ns = ...;

local configs = {
	offset = 100,
	updaterate = 0.5,
};

local hidelist = {};

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

	for name, option in pairs(hidelist) do
		if option then
			local frame = _G[name];
			check_frame(frame, cpoint, configs.offset, false);
		end
	end
end

local function init()
	ns.setup_option();

	hidelist = {
		["MainActionBar"] = ns.options.HideActionBar1,
		["PetActionBar"] = ns.options.HidePetBar,
		["StanceBar"] = ns.options.HideStanceBar,
		["MultiBarBottomLeft"] = ns.options.HideActionBar2,
		["MultiBarBottomRight"] = ns.options.HideActionBar3,
		["MultiBarLeft"] = ns.options.HideActionBar4,
		["MultiBarRight"] = ns.options.HideActionBar5,
		["MultiBar5"] = ns.options.HideActionBar6,
		["MultiBar6"] = ns.options.HideActionBar7,
		["MultiBar7"] = ns.options.HideActionBar8,
	};

	for name, option in pairs(hidelist) do
		if option then
			local frame = _G[name];
			hide_frame(frame);
		end
	end

	C_Timer.NewTicker(configs.updaterate, on_update);
end

C_Timer.After(0.5, init);
