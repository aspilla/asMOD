local _, ns = ...;
local main_frame = CreateFrame("Frame", nil, UIParent);

local filters = {
	helpful = AuraUtil.CreateFilterString(AuraUtil.AuraFilters.Helpful, AuraUtil.AuraFilters.Player),
	harmful = AuraUtil.CreateFilterString(AuraUtil.AuraFilters.Helpful),
}

local borderoption = {
	showIcon = false,
	showWhenHarmful = true,
	showWhenHelpful = true,
	style = AuraButtonBorderStyle.Color,
};

local function create_aurabutton(size)
	return function(frame)
		frame.cooldown = CreateFrame("Cooldown", nil, frame, "CooldownFrameTemplate")
		frame.cooldown:SetAllPoints(frame);
		frame.cooldown:SetDrawSwipe(true);
		frame.cooldown:SetReverse(true);

		if ns.options.MillisecondsThreshold then
			frame.cooldown:SetCountdownMillisecondsThreshold(ns.options.MillisecondsThreshold);
		end

		for _, r in next, { frame.cooldown:GetRegions() } do
			if r:GetObjectType() == "FontString" then
				r:SetFont(STANDARD_TEXT_FONT, size * 0.4, "OUTLINE");
				r:ClearAllPoints();
				r:SetPoint("TOP", 0, 5);
				r:SetDrawLayer("OVERLAY");
				break;
			end
		end
		frame.icon = frame:CreateTexture(nil, "BACKGROUND")
		frame.icon:SetAllPoints(frame);
		frame.icon:SetTexCoord(.08, .92, .16, .84);

		frame.borderb = frame:CreateTexture(nil, "BORDER");
		frame.borderb:SetTexture("Interface\\Addons\\asBuffFilter\\border.tga")
		frame.borderb:SetAllPoints(frame);
		frame.borderb:SetTexCoord(0.08, 0.08, 0.08, 0.92, 0.92, 0.08, 0.92, 0.92);
		frame.borderb:SetVertexColor(0, 0, 0);

		frame.border = frame:CreateTexture(nil, "ARTWORK");
		frame.border:SetTexture("Interface\\Addons\\asBuffFilter\\border.tga")
		frame.border:SetAllPoints(frame);
		frame.border:SetTexCoord(0.08, 0.08, 0.08, 0.92, 0.92, 0.08, 0.92, 0.92);
		frame.border:SetVertexColor(0, 0, 0);

		frame.overlay = CreateFrame("Frame", nil, frame);
		frame.overlay:SetFrameLevel(frame:GetFrameLevel() + 5);

		frame.count = frame.overlay:CreateFontString(nil, "OVERLAY");
		frame.count:SetFont(STANDARD_TEXT_FONT, size * 0.5, "OUTLINE")
		frame.count:ClearAllPoints();
		frame.count:SetPoint("CENTER", frame, "BOTTOM", 0, 1);
		frame.count:SetTextColor(0, 1, 0);

		frame:SetWidth(size);
		frame:SetHeight(size * ns.configs.sizerate);

		frame:EnableMouse(false);
		frame:SetMouseMotionEnabled(true);

		frame:SetIcon(frame.icon);
		frame:SetAuraBorder(frame.border, borderoption);
		frame:SetDurationCooldown(frame.cooldown);
		frame:SetApplicationCount(frame.count);
	end
end
local function update_target()
	if main_frame.helpfulframe then
		if UnitCanAttack("player", "target") then
			main_frame.harmfulframe:SetEnabled(true);
			main_frame.helpfulframe:SetEnabled(false);
			main_frame.nchelpfulframe:SetEnabled(false);
			main_frame.harmfulframe:Show();
			main_frame.helpfulframe:Hide();
			main_frame.nchelpfulframe:Hide();
			main_frame.harmfulframe:UpdateAllAuras();
		else
			if not UnitAffectingCombat("player") then
				main_frame.harmfulframe:SetEnabled(false);
				main_frame.helpfulframe:SetEnabled(false);
				main_frame.nchelpfulframe:SetEnabled(true);
				main_frame.harmfulframe:Hide();
				main_frame.helpfulframe:Hide();
				main_frame.nchelpfulframe:Show();
				main_frame.nchelpfulframe:UpdateAllAuras();
			else
				main_frame.harmfulframe:SetEnabled(false);
				main_frame.helpfulframe:SetEnabled(true);
				main_frame.nchelpfulframe:SetEnabled(false);
				main_frame.harmfulframe:Hide();
				main_frame.helpfulframe:Show();
				main_frame.nchelpfulframe:Hide();
				main_frame.helpfulframe:UpdateAllAuras();
			end
		end
	end
end

local function create_container(parent, unit, filter, anchor, hdir, vdir, size, maxcount)
	local container = CreateFrame("AuraContainer", nil, parent, "CustomAuraContainerTemplate");
	container:SetFlowLayoutAnchorPoint(anchor);
	container:SetFlowLayoutGrowthDirection(hdir, vdir);

	container:AddAuraGroup("buffs", filter,
		{ maxFrameCount = maxcount, initializeFrame = create_aurabutton(size) });
	container:SetAuraGroupLayout("buffs", { elementSpacingX = 0.1 });
	container:SetAuraProcessingPolicy(CustomAuraContainerAuraProcessingPolicy.ProcessAura);
	container:SetUnit(unit);
	container:SetEnabled(false);
	return container;
end

local function setup_frames()

	local libasConfig = LibStub:GetLibrary("LibasConfig", true);
	local offset = 0;
	if ASMOD_asUnitFrame and ASMOD_asUnitFrame.is_simplemode then
		offset = 16;
	end

	main_frame.helpfulframe = create_container(main_frame, "target", filters.helpful, "LEFT",
		AnchorUtil.FlowDirection.Right,
		AnchorUtil.FlowDirection.Down, ns.configs.size, ns.configs.combat_max_buffs);

	main_frame.helpfulframe:SetPoint("LEFT", UIParent, "CENTER", ns.configs.target_xpoint,
		ns.configs.target_ypoint - offset)
	main_frame.helpfulframe:SetWidth(1)
	main_frame.helpfulframe:SetHeight(1)
	main_frame.helpfulframe:Show()

	main_frame.nchelpfulframe = create_container(main_frame, "target", filters.harmful, "LEFT",
		AnchorUtil.FlowDirection.Right,
		AnchorUtil.FlowDirection.Down, ns.configs.nocombat_size, ns.configs.nocombat_max_buffs);

	main_frame.nchelpfulframe:SetPoint("LEFT", UIParent, "CENTER", ns.configs.target_xpoint,
		ns.configs.target_ypoint - offset)
	main_frame.nchelpfulframe:SetWidth(1)
	main_frame.nchelpfulframe:SetHeight(1)
	main_frame.nchelpfulframe:Show()

	main_frame.harmfulframe = create_container(main_frame, "target", filters.harmful, "LEFT",
		AnchorUtil.FlowDirection.Right,
		AnchorUtil.FlowDirection.Down, ns.configs.size, ns.configs.combat_max_buffs);

	main_frame.harmfulframe:SetPoint("LEFT", UIParent, "CENTER", ns.configs.target_xpoint,
		ns.configs.target_ypoint - offset)
	main_frame.harmfulframe:SetWidth(1)
	main_frame.harmfulframe:SetHeight(1)
	main_frame.harmfulframe:Show()

	if libasConfig then
		libasConfig.load_position(main_frame.helpfulframe, "asBuffFilter(Target)", ABF_Positions);
		libasConfig.load_position(main_frame.nchelpfulframe, "asBuffFilter(Target)", ABF_Positions);
		libasConfig.load_position(main_frame.harmfulframe, "asBuffFilter(Target)", ABF_Positions);
	end

	update_target();
end

local function set_combatalpha()
	if ns.options.CombatAlphaChange then
		if UnitAffectingCombat("player") then
			main_frame:SetAlpha(ns.configs.combat_alpha);
		else
			main_frame:SetAlpha(ns.configs.normal_alpha);
		end
	end
end

local function on_event(self, event, arg1, ...)
	if (event == "PLAYER_TARGET_CHANGED") then
		update_target();
	elseif event == "PLAYER_ENTERING_WORLD" then
		update_target();
		set_combatalpha();
	elseif event == "PLAYER_REGEN_DISABLED" then
		set_combatalpha();
		update_target();
	elseif event == "PLAYER_REGEN_ENABLED" then
		set_combatalpha();

		update_target();
	end
end




local function init()
	ns.setup_option();
	main_frame:SetFrameStrata("LOW");
	main_frame:SetPoint("CENTER", 0, 0);
	main_frame:SetWidth(1);
	main_frame:SetHeight(1);
	main_frame:Show();

	setup_frames();

	main_frame:RegisterEvent("PLAYER_TARGET_CHANGED")
	main_frame:RegisterEvent("PLAYER_ENTERING_WORLD");
	main_frame:RegisterEvent("PLAYER_REGEN_DISABLED");
	main_frame:RegisterEvent("PLAYER_REGEN_ENABLED");
	main_frame:SetScript("OnEvent", on_event);

	set_combatalpha();
end

C_Timer.After(1, init);
