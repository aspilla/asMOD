local _, ns = ...;
local main_frame = CreateFrame("Frame", nil, UIParent);

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

local bsetupprivate = false;

local function create_privateframes(parent)
	if parent.PrivateAuraAnchors == nil then
		parent.PrivateAuraAnchors = {};
	end

	if UnitAffectingCombat("player") then
		return;
	end

	bsetupprivate = true;


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

	return;
end

local debufffilter_attack = AuraUtil.CreateFilterString(AuraUtil.AuraFilters.Harmful, AuraUtil.AuraFilters.Player);
local debufffilter_helpful = AuraUtil.CreateFilterString(AuraUtil.AuraFilters.Harmful);

local borderoption = {
	showIcon = false,
	showWhenHarmful = true,
	showWhenHelpful = true,
	style = AuraButtonBorderStyle.Color,
};

local function create_aurabutton(rate)
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
				r:SetFont(STANDARD_TEXT_FONT, ns.configs.cool_fontsize * rate, "OUTLINE");
				r:ClearAllPoints();
				r:SetPoint("TOP", 0, 5);
				r:SetDrawLayer("OVERLAY");
				break;
			end
		end
		frame.icon = frame:CreateTexture(nil, "BACKGROUND")
		frame.icon:SetAllPoints(frame);
		frame.icon:SetTexCoord(.08, .92, .16, .84);

		frame.border = frame:CreateTexture(nil, "ARTWORK");
		frame.border:SetTexture("Interface\\Addons\\asDebuffFilter\\border.tga")
		frame.border:SetAllPoints();
		frame.border:SetTexCoord(0.08, 0.08, 0.08, 0.92, 0.92, 0.08, 0.92, 0.92);

		frame.count = frame:CreateFontString(nil, "OVERLAY");

		frame.count:SetFont(STANDARD_TEXT_FONT, ns.configs.count_fontsize * rate, "OUTLINE")
		frame.count:ClearAllPoints();
		frame.count:SetPoint("CENTER", frame, "BOTTOM", 0, 1);
		frame.count:SetTextColor(0, 1, 0);


		-- Resize
		frame:SetWidth(ns.configs.size * rate);
		frame:SetHeight(ns.configs.size * ns.configs.sizerate * rate);


		frame:EnableMouse(false);
		frame:SetMouseMotionEnabled(true);
		frame:SetIcon(frame.icon);
		frame:SetAuraBorder(frame.border, borderoption);
		frame:SetDurationCooldown(frame.cooldown);
		frame:SetApplicationCount(frame.count);
	end
end

local function update_auras(unit)
	local filter = debufffilter_helpful;

	if UnitCanAttack("player", unit) then
		filter = debufffilter_attack;
	end

	main_frame.frames[unit]:UpdateAllAuras();
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
		update_auras("target");
	elseif (event == "PLAYER_ENTERING_WORLD") then
		update_auras("target");
		update_auras("player");
		set_combatalpha();
	elseif event == "PLAYER_REGEN_DISABLED" then
		set_combatalpha();
	elseif event == "PLAYER_REGEN_ENABLED" then
		set_combatalpha();
		if bsetupprivate == false and main_frame.private_frame then
			create_privateframes(main_frame.private_frame);
		end
	end
end


local function create_container(parent, unit, anchor, hdir, vdir, filter, rate)
	local container = CreateFrame("AuraContainer", nil, parent, "CustomAuraContainerTemplate");
	container:SetAuraLayoutAnchorPoint(anchor);
	container:SetAuraLayoutGrowthDirection(hdir, vdir);

	container:SetUnit(unit);
	container:AddAuraGroup("Debuffs", filter,
		{ maxFrameCount = ns.configs.max_debuffs, initializeFrame = create_aurabutton(rate) });
	container:SetAuraGroupLayout("Debuffs", { elementSpacingX = 1 })

	return container;
end

local function init()
	ns.setup_option();
	local libasConfig = LibStub:GetLibrary("LibasConfig", true);
	main_frame:SetFrameStrata("LOW");
	main_frame:SetPoint("CENTER", 0, 0);
	main_frame:SetWidth(1);
	main_frame:SetHeight(1);
	main_frame:Show();

	local offset = 0;
	if ASMOD_asUnitFrame and ASMOD_asUnitFrame.is_simplemode then
		offset = 16;
	end

	main_frame.frames = {};

	main_frame.frames["target"] = create_container(mainframe, "target", "LEFT", AnchorUtil.FlowDirection.Right,
		AnchorUtil.FlowDirection.Down, debufffilter_attack, 1);

	main_frame.frames["target"]:SetPoint("LEFT", UIParent, "CENTER", ns.configs.target_xpoint, ns.configs.target_ypoint - offset)
	main_frame.frames["target"]:SetWidth(1)
	main_frame.frames["target"]:SetHeight(1)
	main_frame.frames["target"]:Show()


	if libasConfig then
		libasConfig.load_position(main_frame.frames["target"], "asDebuffFilter(Target)", ADF_Positions_1);
	end


	main_frame.frames["player"] = create_container(mainframe, "player", "RIGHT", AnchorUtil.FlowDirection.Left,
		AnchorUtil.FlowDirection.Down, debufffilter_helpful, ns.options.PlayerDebuffRate);


	main_frame.frames["player"]:SetPoint("RIGHT", UIParent, "CENTER", ns.configs.player_xpoint, ns.configs.player_ypoint - offset)
	main_frame.frames["player"]:SetWidth(1)
	main_frame.frames["player"]:SetHeight(1)
	main_frame.frames["player"]:Show()


	if libasConfig then
		libasConfig.load_position(main_frame.frames["player"], "asDebuffFilter(Player)", ADF_Positions_2);
	end


	main_frame.private_frame = CreateFrame("Frame", nil, main_frame)

	main_frame.private_frame:SetPoint("CENTER", ns.configs.private_xpoint, ns.configs.private_ypoint - offset)
	main_frame.private_frame:SetWidth(1)
	main_frame.private_frame:SetHeight(1)
	main_frame.private_frame:Show();

	create_privateframes(main_frame.private_frame);

	if libasConfig then
		libasConfig.load_position(main_frame.private_frame, "asDebuffFilter(Private)", ADF_Positions_3);
	end

	main_frame:RegisterEvent("PLAYER_TARGET_CHANGED")
	main_frame:RegisterEvent("PLAYER_ENTERING_WORLD");
	main_frame:RegisterEvent("PLAYER_REGEN_DISABLED");
	main_frame:RegisterEvent("PLAYER_REGEN_ENABLED");

	main_frame:SetScript("OnEvent", on_event)

	--주기적으로 Callback
	--C_Timer.NewTicker(0.2, on_update);
	update_auras("target");
	update_auras("player");
	set_combatalpha();
end

C_Timer.After(1, init);
