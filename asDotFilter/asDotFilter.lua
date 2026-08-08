local _, ns = ...;

local configs = {
	size = 30,
	sizerate = 0.8,
	cool_fontsize_rate = 12 / 30,
	count_fontsize_rate = 13 / 30,

	--설정 표시할 Unit
	unitlist = {
		["focus"] = true, -- 주시대상 표시 안하길 원하면 이 줄 삭제
		["boss1"] = true,
		["boss2"] = true,
		["boss3"] = true,
		["boss4"] = true,
		["boss5"] = true,
	},
};

local parentframes = {
	["focus"] = { frame = _G["FocusFrame"], isboss = false },
	["boss1"] = { frame = _G["Boss1TargetFrame"], isboss = true },
	["boss2"] = { frame = _G["Boss2TargetFrame"], isboss = true },
	["boss3"] = { frame = _G["Boss3TargetFrame"], isboss = true },
	["boss4"] = { frame = _G["Boss4TargetFrame"], isboss = true },
	["boss5"] = { frame = _G["Boss5TargetFrame"], isboss = true },
};

local lust_debuffs = {
	[57723] = true, --shaman (alliance)
	[57724] = true, --shaman
	[80354] = true, --mage
	[264689] = true, --hunter
	[390435] = true, --evoker
};

local filters = {
	harmful = AuraUtil.CreateFilterString(AuraUtil.AuraFilters.Harmful, AuraUtil.AuraFilters.Player),
	helpful = AuraUtil.CreateFilterString(AuraUtil.AuraFilters.Harmful),
}

local borderoption = {
	showIcon = false,
	showWhenHarmful = true,
	showWhenHelpful = true,
	style = AuraButtonBorderStyle.Color,
};

local main_frame = CreateFrame("Frame", "ADotF", UIParent);
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
		frame.borderb:SetTexture("Interface\\Addons\\asDotFilter\\border.tga")
		frame.borderb:SetAllPoints(frame.overlay);
		frame.borderb:SetTexCoord(0.08, 0.08, 0.08, 0.92, 0.92, 0.08, 0.92, 0.92);
		frame.borderb:SetVertexColor(0, 0, 0);

		frame.border = frame.overlay:CreateTexture(nil, "ARTWORK");
		frame.border:SetTexture("Interface\\Addons\\asDotFilter\\border.tga")
		frame.border:SetAllPoints(frame.overlay);
		frame.border:SetTexCoord(0.08, 0.08, 0.08, 0.92, 0.92, 0.08, 0.92, 0.92);
		frame.border:SetVertexColor(0, 0, 0);

		frame.pborder = frame.overlay:CreateTexture(nil, "ARTWORK");
		frame.pborder:SetTexture("Interface\\Addons\\asDotFilter\\border.tga")
		frame.pborder:SetAllPoints(frame.overlay);
		frame.pborder:SetTexCoord(0.08, 0.08, 0.08, 0.92, 0.92, 0.08, 0.92, 0.92);
		frame.pborder:SetVertexColor(1, 1, 1);

		frame.count = frame.overlay:CreateFontString(nil, "OVERLAY");
		frame.count:SetFont(STANDARD_TEXT_FONT, size * configs.count_fontsize_rate, "OUTLINE")
		frame.count:ClearAllPoints();
		frame.count:SetPoint("CENTER", frame.overlay, "BOTTOM", 0, 1);
		frame.count:SetTextColor(0, 1, 0);

		frame.remain = frame.overlay:CreateFontString(nil, "OVERLAY");
		frame.remain:SetFont(STANDARD_TEXT_FONT, size * configs.count_fontsize_rate, "OUTLINE")
		frame.remain:ClearAllPoints();
		frame.remain:SetPoint("CENTER", frame.overlay, "TOP", 0, -1);
		frame.remain:SetTextColor(1, 1, 1);

		frame:SetWidth(size);
		frame:SetHeight(size * configs.sizerate);

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
		frame:AddPandemicRegion(frame.pborder);
	end
end
local function update_debuffs(unit)
	local container = main_frame.containers[unit];
	if container then
		if UnitCanAttack("player", unit) then
			container:SetAuraGroupFilterString("dots", filters.harmful);
			if not ns.options.ShowNameplatesOnly then
				container:SetAuraGroupFilterString("debuffs", filters.harmful);
			end
		else
			container:SetAuraGroupFilterString("dots", filters.helpful);
			if not ns.options.ShowNameplatesOnly then
				container:SetAuraGroupFilterString("debuffs", filters.helpful);
			end
		end
		container:UpdateAllAuras();
	end
end

local function update_allframes()
	for unit, _ in pairs(configs.unitlist) do
		update_debuffs(unit);
	end
end

local function create_container(parent, unit, anchor, hdir, vdir, sortmethod, sortdirection)
	local container = CreateFrame("AuraContainer", nil, parent, "CustomAuraContainerTemplate");
	container:SetFlowLayoutAnchorPoint(anchor);
	container:SetFlowLayoutGrowthDirection(hdir, vdir);
	container:SetUnit(unit);
	container:SetEnabled(false);
	return container;
end

local function add_group(container, gname, filter, cfilters, initinfos, sortmethod, sortdirection)
	container:AddAuraGroup(gname, filter, initinfos);
	container:SetAuraGroupLayout(gname, { elementSpacingX = 0.1 });
	container:SetAuraGroupCandidateFilters(gname, cfilters);
	if sortmethod then
		container:SetAuraGroupSortMethod(gname, sortmethod, sortdirection);
	end
end

local function setup_frame(unit)
	local parent = parentframes[unit].frame;
	local isboss = parentframes[unit].isboss;
	local offset = 3;

	local cfilters = { nameplateShowPersonal = false };

	if ns.options.HideBloodDebuff then
		cfilters.excludeSpellIDs = lust_debuffs;
	end

	if isboss then
		offset = -50;
	end

	main_frame.containers[unit] = create_container(parent, unit, "LEFT",
		AnchorUtil.FlowDirection.Right,
		AnchorUtil.FlowDirection.Down);

	add_group(main_frame.containers[unit], "dots", filters.helpful, { nameplateShowPersonal = true },
		{ maxFrameCount = ns.options.MaxShow, initializeFrame = create_aurabutton(configs.size) },
		AuraContainerSortMethod.NameOnly, AuraContainerSortDirection.Normal);

	if not ns.options.ShowNameplatesOnly then
		add_group(main_frame.containers[unit], "debuffs", filters.helpful, cfilters,
			{ maxFrameCount = ns.options.MaxShow, initializeFrame = create_aurabutton(configs.size) },
			AuraContainerSortMethod.NameOnly, AuraContainerSortDirection.Normal);
	end

	main_frame.containers[unit]:SetEnabled(true);

	main_frame.containers[unit]:SetPoint("LEFT", parent, "RIGHT", offset, 0);
	main_frame.containers[unit]:SetWidth(1)
	main_frame.containers[unit]:SetHeight(1)
	main_frame.containers[unit]:Show()
end

local function setup_frames()
	for unit, _ in pairs(configs.unitlist) do
		setup_frame(unit);
	end
	update_allframes();
end

local function on_event(self, event)
	if (event == "PLAYER_FOCUS_CHANGED") then
		update_debuffs("focus");
	elseif (event == "INSTANCE_ENCOUNTER_ENGAGE_UNIT") then
		update_allframes();
	elseif (event == "PLAYER_ENTERING_WORLD") then
		update_allframes();
	end
end

local function init()
	ns.setup_option();

	local bloaded = C_AddOns.LoadAddOn("asUnitFrame");

	if bloaded then
		parentframes = {
			["focus"] = { frame = ASMOD_asUnitFrame.FocusFrame, isboss = false },
			["boss1"] = { frame = ASMOD_asUnitFrame.BossFrames[1], isboss = false },
			["boss2"] = { frame = ASMOD_asUnitFrame.BossFrames[2], isboss = false },
			["boss3"] = { frame = ASMOD_asUnitFrame.BossFrames[3], isboss = false },
			["boss4"] = { frame = ASMOD_asUnitFrame.BossFrames[4], isboss = false },
			["boss5"] = { frame = ASMOD_asUnitFrame.BossFrames[5], isboss = false },
		};
	end
	main_frame:SetPoint("CENTER", 0, 0)
	main_frame:SetWidth(1)
	main_frame:SetHeight(1)
	main_frame:Show()
	main_frame.containers = {};

	setup_frames();

	main_frame:RegisterEvent("PLAYER_FOCUS_CHANGED")
	main_frame:RegisterEvent("INSTANCE_ENCOUNTER_ENGAGE_UNIT")
	main_frame:RegisterEvent("PLAYER_ENTERING_WORLD")
	main_frame:SetScript("OnEvent", on_event)
end

C_Timer.After(1, init);
