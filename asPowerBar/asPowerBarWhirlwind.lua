local _, ns = ...;

local configs = {
	max = 4,
	spellid = 85739,
	barcolor = C_ClassColor.GetClassColor("WARRIOR");
}

local main_frame = CreateFrame("Frame", nil, UIParent);
main_frame:SetSize(1, 1);
main_frame:Show();

local function create_aurabutton(max)
	return function(frame)
		frame:SetWidth(1);
		frame:SetHeight(1);
		frame.bar = CreateFrame("StatusBar", nil, frame)
		frame.bar:SetStatusBarTexture("RaidFrame-Hp-Fill")
		frame.bar:GetStatusBarTexture():SetHorizTile(false)
		frame.bar:SetStatusBarColor(configs.barcolor:GetRGB());
		frame.bar:SetMinMaxValues(0, max);
		frame.bar:SetWidth(ns.options.BarWidth)
		frame.bar:SetHeight(ns.options.ComboBarHeight)
		frame.bar:SetPoint("BOTTOM", frame, "BOTTOM", 0, 0)
		frame.bar:Show();
		frame.bar:EnableMouse(false);

		frame.bg = frame:CreateTexture(nil, "BACKGROUND");
		frame.bg:SetPoint("TOPLEFT", frame.bar, "TOPLEFT", -1, 1);
		frame.bg:SetPoint("BOTTOMRIGHT", frame.bar, "BOTTOMRIGHT", 1, -1);
		frame.bg:SetColorTexture(0.1, 0.1, 0.1, 1);
		frame:SetApplicationBar(frame.bar, { maxApplications = max });
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

local function setup_max_whilwind(max)

	local filter = AuraUtil.CreateFilterString(AuraUtil.AuraFilters.Helpful, AuraUtil.AuraFilters.Player);
	local cfilters = { includeSpellIDs = { [configs.spellid] = true } };

	if main_frame.container == nil then
		main_frame.container = create_container(main_frame, "player", "BOTTOM", AnchorUtil.FlowDirection.Right,
			AnchorUtil.FlowDirection.Down);
		add_group(main_frame.container, "whirlwind", filter, cfilters,
			{ maxFrameCount = 1, initializeFrame = create_aurabutton(max) });
		main_frame.container:SetPoint("BOTTOM", ns.combocountbar, "BOTTOM", 0, 0);
		main_frame.container:SetWidth(1)
		main_frame.container:SetHeight(1)
		main_frame.container:Show()
	end
end


function ns.setup_whirlwind()
	ns.setup_max_spell(configs.max);
    ns.combocountbar:Show();
	ns.combocountbar:SetValue(0);
	main_frame:SetParent(ns.main_frame);
	main_frame:SetFrameLevel(ns.configs.framelevel);
	setup_max_whilwind(configs.max);
	main_frame.container:SetEnabled(true);
end

function ns.clear_whirlwind()
	ns.combocountbar:Hide();
	if main_frame.container then
		main_frame.container:SetEnabled(false);
	end
end
