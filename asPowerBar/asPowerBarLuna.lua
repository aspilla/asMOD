local _, ns = ...;
local configs = {
    colors = {
    	[48518] = CreateColor(0.5, 0.2, 1),
     	[48517] = CreateColor(1, 0.5, 0.2),
	}
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
		frame.bar:SetWidth(ns.options.BarWidth / 2)
		frame.bar:SetHeight(ns.combocountbar:GetHeight())
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
	return container;
end

local function add_group(container, gname, filter, cfilters, initinfos)
	container:AddAuraGroup(gname, filter, initinfos);
	container:SetAuraGroupLayout(gname, { elementSpacingX = 0.1 });
	container:SetAuraGroupCandidateFilters(gname, cfilters);
end

local function setup_container(idx, spellid)
	local filter = AuraUtil.CreateFilterString(AuraUtil.AuraFilters.Helpful, AuraUtil.AuraFilters.Player);
	local cfilters = { includeSpellIDs = { [spellid] = true } };

	if main_frame.containers == nil then
		main_frame.containers = {};
	end

	--idx should be 1 or 2
	if main_frame.containers[idx] == nil then
		local xoffset = ns.options.BarWidth / 4;
        local color = configs.colors[spellid];

        if idx == 1 then
			xoffset = -(ns.options.BarWidth / 4);
		end

		main_frame.containers[idx] = create_container(main_frame, "player", "BOTTOM", AnchorUtil.FlowDirection.Right,
			AnchorUtil.FlowDirection.Down);
		add_group(main_frame.containers[idx], "aurabar", filter, cfilters,
			{ maxFrameCount = 1, initializeFrame = create_aurabutton(color) });


		main_frame.containers[idx]:SetPoint("BOTTOM", ns.combocountbar, "BOTTOM", xoffset, 0);
		main_frame.containers[idx]:SetWidth(1)
		main_frame.containers[idx]:SetHeight(1)
	end
	main_frame.containers[idx]:Show()
	main_frame.containers[idx]:SetEnabled(true);
end

function ns.setup_luna(spellids)
	ns.combocountbar:SetValue(0);
	ns.combocountbar:Show();
	main_frame:SetParent(ns.main_frame);
	main_frame:SetFrameLevel(ns.configs.framelevel + 200);
	for idx = 1, 2 do
		setup_container(idx, spellids[idx]);
	end
end

function ns.clear_luna()
	for idx = 1, 2 do
		if main_frame.containers and main_frame.containers[idx] then
			main_frame.containers[idx]:SetEnabled(false);
			main_frame.containers[idx]:Hide();
		end
	end
end
