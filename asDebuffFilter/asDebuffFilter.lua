local _, ns = ...;
local main_frame = CreateFrame("Frame", nil, UIParent);

local lust_debuffs = {
    [57723] = true,  --shaman (alliance)
    [57724] = true,  --shaman
    [80354] = true,  --mage
    [264689] = true, --hunter
    [390435] = true, --evoker
}
asDebuffPrivateAuraAnchorMixin = {};

function asDebuffPrivateAuraAnchorMixin:SetUnit(unit)
	if unit == self.unit then
		return;
	end
	self.unit = unit;

	if self.anchorID then
		C_UnitAuras.RemovePrivateAuraAnchor(self.anchorID);
		self.anchorID = nil;
	end

	if unit then
		local iconAnchor =
		{
			point = "CENTER",
			relativeTo = self,
			relativePoint = "CENTER",
			offsetX = 0,
			offsetY = 0,
		};

		local privateAnchorArgs = {};
		privateAnchorArgs.unitToken = unit;
		privateAnchorArgs.auraIndex = self.auraIndex;
		privateAnchorArgs.parent = self;
		privateAnchorArgs.showCountdownFrame = true;
		privateAnchorArgs.showCooldownFrame = true;
		privateAnchorArgs.showCooldownEdge = true;
		privateAnchorArgs.showCountdownNumbers = true;
		privateAnchorArgs.isContainer = false;

		privateAnchorArgs.iconInfo =
		{
			iconAnchor = iconAnchor,
			iconWidth = self:GetWidth(),
			iconHeight = self:GetHeight(),
			borderScale = 2.0,
		};
		privateAnchorArgs.durationAnchor = nil;

		self.anchorID = C_UnitAuras.AddPrivateAuraAnchor(privateAnchorArgs);
	end
end


local function create_privateframes(parent)
	if parent.PrivateAuraAnchors == nil then
		parent.PrivateAuraAnchors = {};
	end

	local size = ns.configs.size + 5;

	size = size * ns.options.PlayerDebuffRate;

	for idx = 1, ns.configs.max_private do
		parent.PrivateAuraAnchors[idx] = CreateFrame("Frame", nil, parent, "asDebuffPrivateAuraAnchorTemplate");
		parent.PrivateAuraAnchors[idx].auraIndex = idx;
		parent.PrivateAuraAnchors[idx]:SetSize((size - 5), (size - 5));
		parent.PrivateAuraAnchors[idx]:SetUnit("player");

		if idx > 1 then
			parent.PrivateAuraAnchors[idx]:ClearAllPoints();
			parent.PrivateAuraAnchors[idx]:SetPoint("RIGHT", parent.PrivateAuraAnchors[idx - 1], "LEFT", -1, 0);
		else
			parent.PrivateAuraAnchors[idx]:ClearAllPoints();
			parent.PrivateAuraAnchors[idx]:SetPoint("RIGHT", parent, "LEFT", 0, 0);
		end
	end
end

local filters = {
	helpful = AuraUtil.CreateFilterString(AuraUtil.AuraFilters.Harmful),
	harmful = AuraUtil.CreateFilterString(AuraUtil.AuraFilters.Harmful, AuraUtil.AuraFilters.Player),
};

local borderoption = {
	showIcon = false,
	showWhenHarmful = true,
	showWhenHelpful = true,
	style = AuraButtonBorderStyle.Color,
};

local function create_aurabutton(size)
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
		frame.borderb:SetTexture("Interface\\Addons\\asDebuffFilter\\border.tga")
		frame.borderb:SetAllPoints(frame.overlay);
		frame.borderb:SetTexCoord(0.08, 0.08, 0.08, 0.92, 0.92, 0.08, 0.92, 0.92);
		frame.borderb:SetVertexColor(0, 0, 0);

		frame.border = frame.overlay:CreateTexture(nil, "ARTWORK");
		frame.border:SetTexture("Interface\\Addons\\asDebuffFilter\\border.tga")
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
		frame:SetAuraBorder(frame.border, borderoption);
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
	if main_frame.targetframe then
		if UnitCanAttack("player", "target") then
			main_frame.targetframe:SetAuraGroupFilterString("debuffs", filters.harmful);
			main_frame.targetframe:SetAuraGroupFilterString("dots", filters.harmful);
		else
			main_frame.targetframe:SetAuraGroupFilterString("debuffs", filters.helpful);
			main_frame.targetframe:SetAuraGroupFilterString("dots", filters.helpful);
		end
		main_frame.targetframe:UpdateAllAuras();
	end
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

	if ns.options.ShowTarget then
        local cfilters = { nameplateShowPersonal = false };

        if ns.options.HideBloodDebuff then
        	cfilters.excludeSpellIDs = lust_debuffs;
        end

		main_frame.targetframe = create_container(main_frame, "target", "LEFT", AnchorUtil.FlowDirection.Right,
			AnchorUtil.FlowDirection.Down);
		add_group(main_frame.targetframe, "dots", filters.helpful, { nameplateShowPersonal = true },
			{ maxFrameCount = ns.configs.max_debuffs, initializeFrame = create_aurabutton(ns.configs.size) });
		add_group(main_frame.targetframe, "debuffs", filters.helpful, cfilters,
			{ maxFrameCount = ns.configs.max_debuffs, initializeFrame = create_aurabutton(ns.configs.size) });
		main_frame.targetframe:SetEnabled(true);

		main_frame.targetframe:SetPoint("LEFT", UIParent, "CENTER", ns.configs.target_xpoint,
			ns.configs.target_ypoint - offset)
		main_frame.targetframe:SetWidth(1)
		main_frame.targetframe:SetHeight(1)
		main_frame.targetframe:Show()

		if libasConfig then
			libasConfig.load_position(main_frame.targetframe, "asDebuffFilter(Target)", ADF_Positions_1);
		end
	end


	if ns.options.ShowPlayer then
        local cfilter = {}

        if ns.options.HideBloodDebuff then
        	cfilter.excludeSpellIDs = lust_debuffs;
        end

		main_frame.playerframe = create_container(main_frame, "player", "RIGHT", AnchorUtil.FlowDirection.Left,
			AnchorUtil.FlowDirection.Down);

		add_group(main_frame.playerframe, "debuffs", filters.helpful, cfilter,
			{ maxFrameCount = ns.configs.max_debuffs, initializeFrame = create_aurabutton(ns.configs.size * ns.options.PlayerDebuffRate) });
		main_frame.playerframe:SetEnabled(true);


		main_frame.playerframe:SetPoint("RIGHT", UIParent, "CENTER", ns.configs.player_xpoint,
			ns.configs.player_ypoint - offset)
		main_frame.playerframe:SetWidth(1)
		main_frame.playerframe:SetHeight(1)
		main_frame.playerframe:Show()
		main_frame.playerframe:SetEnabled(true);

		if libasConfig then
			libasConfig.load_position(main_frame.playerframe, "asDebuffFilter(Player)", ADF_Positions_2);
		end
	end

	if ns.options.ShowPrivate then
		main_frame.private_frame = CreateFrame("Frame", nil, main_frame)

		main_frame.private_frame:SetPoint("RIGHT", UIParent, "CENTER", ns.configs.private_xpoint, ns.configs.private_ypoint - offset)
		main_frame.private_frame:SetWidth(1)
		main_frame.private_frame:SetHeight(1)
		main_frame.private_frame:Show();

		create_privateframes(main_frame.private_frame);

		if libasConfig then
			libasConfig.load_position(main_frame.private_frame, "asDebuffFilter(Private)", ADF_Positions_3);
		end
	end
	update_target();
end

local function on_event(self, event, arg1, ...)
	if (event == "PLAYER_TARGET_CHANGED") then
		update_target();
	elseif (event == "PLAYER_ENTERING_WORLD") then
		update_target();
		set_combatalpha();
	elseif event == "PLAYER_REGEN_DISABLED" then
		set_combatalpha();
	elseif event == "PLAYER_REGEN_ENABLED" then
		set_combatalpha();
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

	main_frame:SetScript("OnEvent", on_event)

	set_combatalpha();
end

C_Timer.After(1, init);
