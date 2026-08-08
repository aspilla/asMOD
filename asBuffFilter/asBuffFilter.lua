local _, ns = ...;
local main_frame = CreateFrame("Frame", nil, UIParent);

local filters = {
	helpful = AuraUtil.CreateFilterString(AuraUtil.AuraFilters.Helpful, AuraUtil.AuraFilters.Player,
		AuraUtil.AuraFilters.RaidInCombat),
	harmful = AuraUtil.CreateFilterString(AuraUtil.AuraFilters.Helpful),
}

local borderoption = {
	showIcon = false,
	showWhenHarmful = true,
	showWhenHelpful = true,
	style = AuraButtonBorderStyle.Color,
};



local function create_aurabutton(size, issteal)
	local formatter = C_StringUtil.CreateNumericRuleFormatter();
	if ns.options.MillisecondsThreshold then
		formatter:AddBreakpoint({
			threshold = 0,
			format = "%.1f",
            step = 0.1,
			rounding = 1,
		});
		formatter:AddBreakpoint({
			threshold = ns.options.MillisecondsThreshold,
			format = "%d",
			step = 1,
			rounding = 1,
		});
	else
		formatter:AddBreakpoint({
			threshold = 0,
			format = "%d",
			step = 1,
			rounding = 1,
		});
	end

	if GetLocale() == "koKR" then
		formatter:AddBreakpoint({
			threshold = 60,
			format = "%d분",
			components = {
				{ div = 60, step = 1, rounding = 1 } },
		});
		formatter:AddBreakpoint({
			threshold = 3600,
			format = "%d시간",
			components = {
				{ div = 3600, step = 1, rounding = 1 } },
		});
		formatter:AddBreakpoint({
			threshold = 86400,
			format = "%d일",
			components = {
				{ div = 86400, step = 1, rounding = 1 } },
		});
	else
		formatter:AddBreakpoint({
			threshold = 60,
			format = "%dm",
			components = {
				{ div = 60, step = 1, rounding = 1 } },
		});
		formatter:AddBreakpoint({
			threshold = 3600,
			format = "%dh",
			components = {
				{ div = 3600, step = 1, rounding = 1 } },
		});
		formatter:AddBreakpoint({
			threshold = 86400,
			format = "%dd",
			components = {
				{ div = 86400, step = 1, rounding = 1 } },
		});
	end
	return function(frame)
		frame.cooldown = CreateFrame("Cooldown", nil, frame, "CooldownFrameTemplate")
		frame.cooldown:SetAllPoints(frame);
		frame.cooldown:SetDrawSwipe(true);
		frame.cooldown:SetReverse(true);
		frame.cooldown:SetHideCountdownNumbers(true);

		frame.icon = frame:CreateTexture(nil, "BACKGROUND")
		frame.icon:SetAllPoints(frame);
		frame.icon:SetTexCoord(.08, .92, .16, .84);

		frame.overlay = CreateFrame("Frame", nil, frame);
		frame.overlay:SetFrameLevel(frame:GetFrameLevel() + 5);
		frame.overlay:SetAllPoints(frame);

		frame.borderb = frame.overlay:CreateTexture(nil, "BORDER");
		frame.borderb:SetTexture("Interface\\Addons\\asBuffFilter\\border.tga")
		frame.borderb:SetAllPoints(frame.overlay);
		frame.borderb:SetTexCoord(0.08, 0.08, 0.08, 0.92, 0.92, 0.08, 0.92, 0.92);
		frame.borderb:SetVertexColor(0, 0, 0);

		frame.border = frame.overlay:CreateTexture(nil, "ARTWORK");
		frame.border:SetTexture("Interface\\Addons\\asBuffFilter\\border.tga")
		frame.border:SetAllPoints(frame.overlay);
		frame.border:SetTexCoord(0.08, 0.08, 0.08, 0.92, 0.92, 0.08, 0.92, 0.92);
		frame.border:SetVertexColor(0, 0, 0);

		frame.count = frame.overlay:CreateFontString(nil, "OVERLAY");
		frame.count:SetFont(STANDARD_TEXT_FONT, size * ns.configs.count_fontsize_rate, "OUTLINE")
		frame.count:ClearAllPoints();
		frame.count:SetPoint("CENTER", frame.overlay, "BOTTOM", 0, 1);
		frame.count:SetTextColor(0, 1, 0);

		frame.remain = frame.overlay:CreateFontString(nil, "OVERLAY");
		frame.remain:SetFont(STANDARD_TEXT_FONT, size * ns.configs.count_fontsize_rate, "OUTLINE")
		frame.remain:ClearAllPoints();
		frame.remain:SetPoint("CENTER", frame.overlay, "TOP", 0, -1);
		frame.remain:SetTextColor(1, 1, 1);

		frame:SetWidth(size);
		frame:SetHeight(size * ns.configs.sizerate);

		frame:EnableMouse(false);
		frame:SetMouseMotionEnabled(true);

		frame:SetIcon(frame.icon);
		if issteal then
			frame.borderb:Hide();
			frame.border:SetVertexColor(1, 1, 1);
			frame.border:Show();
		else
			frame:SetAuraBorder(frame.border, borderoption);
		end
		frame:SetDurationCooldown(frame.cooldown);
		frame:SetDurationText(frame.remain, {
			textFormat = {
				formatString = "{}",
				components = {
					{
						property = 0,
						formatter = formatter
					}
				}
			}
		});
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

local function create_container(parent, unit, anchor, hdir, vdir)
	local container = CreateFrame("AuraContainer", nil, parent, "CustomAuraContainerTemplate");
	container:SetFlowLayoutAnchorPoint(anchor);
	container:SetFlowLayoutGrowthDirection(hdir, vdir);
	container:SetUnit(unit);
	container:SetEnabled(false);
	return container;
end

local function add_group(container, gname, filter, cfilters, initinfos)
	container:AddAuraGroup(gname, filter, initinfos);
	container:SetAuraGroupLayout(gname, { elementSpacingX = 0.1 });
	container:SetAuraGroupCandidateFilters(gname, cfilters);
end

local function setup_frames()
	local libasConfig = LibStub:GetLibrary("LibasConfig", true);
	local offset = 0;
	if ASMOD_asUnitFrame and ASMOD_asUnitFrame.is_simplemode then
		offset = 14;
	end

	main_frame.helpfulframe = create_container(main_frame, "target", "LEFT", AnchorUtil.FlowDirection.Right,
		AnchorUtil.FlowDirection.Down);
	add_group(main_frame.helpfulframe, "buffs", filters.helpful, cfilters,
		{ maxFrameCount = ns.configs.combat_max_buffs, initializeFrame = create_aurabutton(ns.configs.size, false) });
	main_frame.helpfulframe:SetPoint("LEFT", UIParent, "CENTER", ns.configs.target_xpoint,
		ns.configs.target_ypoint - offset)
	main_frame.helpfulframe:SetWidth(1)
	main_frame.helpfulframe:SetHeight(1)
	main_frame.helpfulframe:Show()

	main_frame.nchelpfulframe = create_container(main_frame, "target", "LEFT",
		AnchorUtil.FlowDirection.Right,
		AnchorUtil.FlowDirection.Down);
	add_group(main_frame.nchelpfulframe, "buffs", filters.harmful, {},
		{
			maxFrameCount = ns.configs.nocombat_max_buffs,
			initializeFrame = create_aurabutton(ns.configs.nocombat_size,
				false)
		});
	main_frame.nchelpfulframe:SetPoint("LEFT", UIParent, "CENTER", ns.configs.target_xpoint,
		ns.configs.target_ypoint - offset)
	main_frame.nchelpfulframe:SetWidth(1)
	main_frame.nchelpfulframe:SetHeight(1)
	main_frame.nchelpfulframe:Show()

	main_frame.harmfulframe = create_container(main_frame, "target", "LEFT", AnchorUtil.FlowDirection.Right,
		AnchorUtil.FlowDirection.Down);
	add_group(main_frame.harmfulframe, "steal", filters.harmful, { isStealable = true },
		{ maxFrameCount = ns.configs.combat_max_buffs, initializeFrame = create_aurabutton(ns.configs.size, true) });
	add_group(main_frame.harmfulframe, "buffs", filters.harmful, { isStealable = false },
		{ maxFrameCount = ns.configs.combat_max_buffs, initializeFrame = create_aurabutton(ns.configs.size, false) });
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
	main_frame:SetFrameLevel(9600);
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
