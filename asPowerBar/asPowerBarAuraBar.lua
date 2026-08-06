local _, ns = ...;

local gvalues = {
	spellids = {},
}

local main_frame = CreateFrame("Frame", nil, UIParent);
main_frame:SetSize(1, 1);
main_frame:Show();

local formatter = C_StringUtil.CreateNumericRuleFormatter();
formatter:AddBreakpoint({
	threshold = 0,
	format = "%.1f"
});

local function create_aurabutton(color)
	return function(frame)
		frame:SetWidth(1);
		frame:SetHeight(1);
		frame.bar = CreateFrame("StatusBar", nil, frame)
		frame.bar:SetStatusBarTexture("RaidFrame-Hp-Fill")
		frame.bar:GetStatusBarTexture():SetHorizTile(false)
		frame.bar:SetStatusBarColor(color:GetRGB());
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
		frame.text = frame.overlay:CreateFontString(nil, "OVERLAY");
		frame.text:SetFont(ns.configs.font, ns.options.FontSize, ns.configs.fontOutline)
		frame.text:ClearAllPoints();
		frame.text:SetPoint("CENTER", frame.bar, "CENTER", 0, 0);
		frame.text:SetTextColor(1, 1, 1);
		frame:SetDurationText(frame.text, {
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
		frame:SetDurationBar(frame.bar, { interpolation = ns.bartype, direction = 1 });
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

local function setup_container(spellid, color)
	local filter = AuraUtil.CreateFilterString(AuraUtil.AuraFilters.Helpful, AuraUtil.AuraFilters.Player);
	local cfilters = { includeSpellIDs = { [spellid] = true } };

	if main_frame.containers[spellid] == nil then
		main_frame.containers[spellid] = create_container(main_frame, "player", "BOTTOM", AnchorUtil.FlowDirection.Right,
			AnchorUtil.FlowDirection.Down);
		local container = main_frame.containers[spellid];
		container:SetFrameLevel(main_frame:GetFrameLevel() + #(main_frame.containers))
		add_group(container, "aurabar", filter, cfilters,
			{ maxFrameCount = 1, initializeFrame = create_aurabutton(color) });
		container:SetPoint("BOTTOM", ns.bar, "BOTTOM", 0, 0);
		container:SetWidth(1)
		container:SetHeight(1)
	end
	main_frame.containers[spellid]:Show()
	main_frame.containers[spellid]:SetEnabled(true);
end

function ns.setup_aurabar(spellids)
	main_frame:SetParent(ns.main_frame);
	main_frame:SetFrameLevel(ns.configs.framelevel + 200);
	ns.bar:SetValue(0);
	ns.bar.text:Hide();
	if main_frame.containers == nil then
		main_frame.containers = {};
	end
	for spellid, color in pairs(spellids) do
		setup_container(spellid, color);
	end
end

function ns.clear_aurabar()
	if main_frame.containers then
		for _, container in pairs(main_frame.containers) do
			container:SetEnabled(false);
			container:Hide();
		end
		main_frame.containers = {};
	end
end
