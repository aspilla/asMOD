local _, ns = ...;

local main_frame = CreateFrame("Frame", nil, UIParent);
main_frame:SetSize(1, 1);
main_frame:Show();

local function create_aurabutton(max, color)
	return function(frame)
		frame:SetWidth(1);
		frame:SetHeight(1);
		frame.bar = CreateFrame("StatusBar", nil, frame)
		frame.bar:SetStatusBarTexture("RaidFrame-Hp-Fill")
		frame.bar:GetStatusBarTexture():SetHorizTile(false)
		frame.bar:SetStatusBarColor(color:GetRGB());
		frame.bar:SetMinMaxValues(0, max);
		frame.bar:SetWidth(ns.options.BarWidth)
		frame.bar:SetHeight(ns.bar:GetHeight())
		frame.bar:SetPoint("BOTTOM", frame, "BOTTOM", 0, 0)
		frame.bar:Show();
		frame.bar:EnableMouse(false);

		frame.bg = frame:CreateTexture(nil, "BACKGROUND");
		frame.bg:SetPoint("TOPLEFT", frame.bar, "TOPLEFT", -1, 1);
		frame.bg:SetPoint("BOTTOMRIGHT", frame.bar, "BOTTOMRIGHT", 1, -1);
		frame.bg:SetColorTexture(0.1, 0.1, 0.1, 1);


		frame.overlay = CreateFrame("Frame", nil, frame);
		frame.overlay:SetFrameLevel(frame:GetFrameLevel() + 200);
		frame.count = frame.overlay:CreateFontString(nil, "OVERLAY");
		frame.count:SetFont(ns.configs.font, ns.options.FontSize, ns.configs.fontOutline)
		frame.count:ClearAllPoints();
		frame.count:SetPoint("CENTER", frame.bar, "CENTER", 0, 0);
		frame.count:SetTextColor(1, 1, 1);
		frame:SetApplicationCount(frame.count);
		frame:SetApplicationBar(frame.bar, { maxApplications = max , interpolation = ns.bartype});
		frame:Show();
	end
end

local function create_container(parent, unit, anchor, hdir, vdir)
	local container = CreateFrame("AuraContainer", nil, parent, "CustomAuraContainerTemplate");
	container:SetFlowLayoutAnchorPoint(anchor);
	container:SetFlowLayoutGrowthDirection(hdir, vdir);
	container:SetUnit(unit);
	container:SetEnabled(true);
	return container;
end

local function add_group(container, gname, filter, cfilters, initinfos)
	container:AddAuraGroup(gname, filter, initinfos);
	container:SetAuraGroupLayout(gname, { elementSpacingX = 0.1 });
	container:SetAuraGroupCandidateFilters(gname, cfilters);
end

local function setup_container(spellid, max, color, unit)
	local frames = ns.bar.countframes;
	for i = 1, 20 do
		frames[i]:Hide();
	end

	if max == 0 then
		return;
	end
	local width = ((ns.options.BarWidth + 2) / max);
	for i = 1, max do
		local frame = frames[i];
		frame:SetWidth(width);
		frame:Show();
	end

	local filter = AuraUtil.CreateFilterString(AuraUtil.AuraFilters.Helpful, AuraUtil.AuraFilters.Player);
	local cfilters = { includeSpellIDs = { [spellid] = true } };

	if unit == "target" then
		filter = AuraUtil.CreateFilterString(AuraUtil.AuraFilters.Harmful, AuraUtil.AuraFilters.Player);
	end

	if main_frame.container == nil then
		main_frame.container = create_container(main_frame, unit, "BOTTOM", AnchorUtil.FlowDirection.Right,
			AnchorUtil.FlowDirection.Down);
		add_group(main_frame.container, "stack", filter, cfilters,
			{ maxFrameCount = 1, initializeFrame = create_aurabutton(max, color) });
		main_frame.container:SetPoint("BOTTOM", ns.bar, "BOTTOM", 0, 0);
		main_frame.container:SetWidth(1)
		main_frame.container:SetHeight(1)
	end
	main_frame.container:Show()
	main_frame.container:SetEnabled(true);
end

local function on_event(_, event)
	if (event == "PLAYER_TARGET_CHANGED") and main_frame.container then
		main_frame.container:UpdateAllAuras();
	end
end

function ns.setup_stack(stackinfo)
	main_frame:SetParent(ns.main_frame);
	main_frame:SetFrameLevel(ns.configs.framelevel + 200);
	ns.bar:SetValue(0);
	ns.bar.text:Hide();
	setup_container(stackinfo.spellid, stackinfo.max, stackinfo.color, stackinfo.unit);

	if stackinfo.unit == "target" then
		main_frame:RegisterEvent("PLAYER_TARGET_CHANGED")
		main_frame:SetScript("OnEvent", on_event)
	end
end

function ns.clear_stack()
	local frames = ns.bar.countframes;
	for i = 1, 20 do
		frames[i]:Hide();
	end
	if main_frame.container then
		main_frame.container:SetEnabled(false);
		main_frame.container:Hide();
	end
	main_frame:UnregisterAllEvents();
end
