local _, ns = ...;
local configs = {
	size = 40,
	xpoint = 350,
	ypoint = -400,
	alpha = 1,
	cooldownfontsize = 12,
	spellid = 20484,
}

local main_button = CreateFrame("Button", nil, UIParent, "asBattleResFrameTemplate");

local function clear_cooldownframe(self)
	self:Clear();
end

-- Function to load saved position
local function load_position(frame, option)
	frame:ClearAllPoints()
	frame:SetPoint(option.point, UIParent, option.relativePoint, option.xOfs,
		option.yOfs)
end

-- Function to save position
local function save_position(frame, option)
	local point, _, relativePoint, xOfs, yOfs = frame:GetPoint()
	option.point = point
	option.relativePoint = relativePoint
	option.xOfs = xOfs
	option.yOfs = yOfs
end

local function set_cooldownframe(self, start, duration, enable, forceShowDrawEdge, modRate)
	if enable then
		self:SetDrawEdge(forceShowDrawEdge);
		self:SetCooldown(start, duration, modRate);
	else
		clear_cooldownframe(self);
	end
end

local bMouseEnabled = true;

local function on_update()
	if ns.options.LockWindow then
		if bMouseEnabled then
			main_button:EnableMouse(false);
			bMouseEnabled = false;
		end
	else
		if not bMouseEnabled then
			main_button:EnableMouse(true);
			bMouseEnabled = true;
		end
	end

	if IsInGroup() or not ns.options.LockWindow then
		main_button:Show();
	else
		main_button:Hide();
		return;
	end

	local count = C_Spell.GetSpellDisplayCount(configs.spellid);
	local chargeinfo = C_Spell.GetSpellCharges(configs.spellid);


	main_button.count:SetText(count);
	main_button.count:Show();
	main_button.icon:SetDesaturated(false);

	if chargeinfo then
		main_button.cooldown:Show();
		set_cooldownframe(main_button.cooldown, chargeinfo.cooldownStartTime,
			chargeinfo.cooldownDuration, true, true);
	else
		main_button.cooldown:Hide();
	end
end

local function init()
	ASBR_Position = ASBR_Position or {
		point = "CENTER",
		relativePoint = "CENTER",
		xOfs = configs.xpoint,
		yOfs = configs.ypoint,
	}

	ns.setup_option();
	C_AddOns.LoadAddOn("asMOD");


	main_button:EnableMouse(true);
	main_button:RegisterForDrag("LeftButton");
	main_button:SetMovable(true);

	main_button.cooldown:SetHideCountdownNumbers(false);
	main_button.cooldown:SetDrawSwipe(true);

	for _, r in next, { main_button.cooldown:GetRegions() } do
		if r:GetObjectType() == "FontString" then
			r:SetFont(STANDARD_TEXT_FONT, configs.cooldownfontsize, "OUTLINE");
			r:SetDrawLayer("OVERLAY");
			break
		end
	end

	main_button.icon:SetTexCoord(.08, .92, .08, .92);
	main_button.border:SetTexCoord(0.08, 0.08, 0.08, 0.92, 0.92, 0.08, 0.92, 0.92);
	main_button.border:SetVertexColor(0, 0, 0);

	main_button.count:SetFont(STANDARD_TEXT_FONT, configs.cooldownfontsize, "OUTLINE")
	main_button.count:ClearAllPoints();
	main_button.count:SetPoint("BOTTOMRIGHT", main_button, "BOTTOMRIGHT", -3, 3);

	main_button:SetPoint("CENTER", configs.xpoint, configs.ypoint)
	main_button:SetWidth(configs.size);
	main_button:SetHeight(configs.size * 0.9);
	main_button:SetAlpha(configs.alpha);
	main_button:SetScale(1);


	main_button:SetScript("OnDragStart", function(self)
		if not ns.options.LockWindow then
			self:StartMoving()
			self.isMoving = true
		end
	end)

	main_button:SetScript("OnDragStop", function(self)
		if self.isMoving then
			self:StopMovingOrSizing()
			self.isMoving = false
			save_position(main_button, ASBR_Position);
		end
	end)

	load_position(main_button, ASBR_Position);

	if asMOD_setupFrame then
		asMOD_setupFrame(main_button, "asBattleRes");
	end

	local spellInfo = C_Spell.GetSpellInfo(configs.spellid);

	if spellInfo then
		main_button.icon:SetTexture(spellInfo.iconID);				
		C_Timer.NewTicker(0.25, on_update);
	end
end

C_Timer.After(0.5, init);
