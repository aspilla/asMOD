local _, ns = ...;

local configs = {
    size = 30,
    sizerate = 0.8,
    cool_fontsize = 12,
    count_fontsize = 13,

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
local bsetup = false;

local function create_aurabutton()
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
				r:SetFont(STANDARD_TEXT_FONT, configs.cool_fontsize, "OUTLINE");
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
		frame.borderb:SetTexture("Interface\\Addons\\asDotFilter\\border.tga")
		frame.borderb:SetAllPoints(frame);
		frame.borderb:SetTexCoord(0.08, 0.08, 0.08, 0.92, 0.92, 0.08, 0.92, 0.92);
		frame.borderb:SetVertexColor(0, 0, 0);

		frame.border = frame:CreateTexture(nil, "ARTWORK");
		frame.border:SetTexture("Interface\\Addons\\asDotFilter\\border.tga")
		frame.border:SetAllPoints(frame);
		frame.border:SetTexCoord(0.08, 0.08, 0.08, 0.92, 0.92, 0.08, 0.92, 0.92);
		frame.border:SetVertexColor(0, 0, 0);

		frame.overlay = CreateFrame("Frame", nil, frame);
		frame.overlay:SetFrameLevel(frame:GetFrameLevel() + 5);

		frame.count = frame.overlay:CreateFontString(nil, "OVERLAY");
		frame.count:SetFont(STANDARD_TEXT_FONT, configs.count_fontsize, "OUTLINE")
		frame.count:ClearAllPoints();
		frame.count:SetPoint("CENTER", frame, "BOTTOM", 0, 1);
		frame.count:SetTextColor(0, 1, 0);

		frame:SetWidth(configs.size);
		frame:SetHeight(configs.size * configs.sizerate);

		frame:EnableMouse(false);
		frame:SetMouseMotionEnabled(true);

		frame:SetIcon(frame.icon);
		frame:SetAuraBorder(frame.border, borderoption);
		frame:SetDurationCooldown(frame.cooldown);
		frame:SetApplicationCount(frame.count);
	end
end
local function update_debuffs(unit)
	if main_frame.helpfulframes[unit] then
		if UnitCanAttack("player", unit) then
			main_frame.harmfulframes[unit]:SetEnabled(true);
			main_frame.helpfulframes[unit]:SetEnabled(false);
			main_frame.harmfulframes[unit]:Show();
			main_frame.helpfulframes[unit]:Hide();
			main_frame.harmfulframes[unit]:UpdateAllAuras();
		else
			main_frame.harmfulframes[unit]:SetEnabled(false);
			main_frame.helpfulframes[unit]:SetEnabled(true);
			main_frame.harmfulframes[unit]:Hide();
			main_frame.helpfulframes[unit]:Show();
			main_frame.helpfulframes[unit]:UpdateAllAuras();
		end
	end
end

local function update_allframes()
    for unit, _ in pairs(configs.unitlist) do
        update_debuffs(unit);
    end
end

local function create_container(parent, unit, filter, anchor, hdir, vdir, bnameplate)
	local container = CreateFrame("AuraContainer", nil, parent, "CustomAuraContainerTemplate");
	container:SetAuraLayoutAnchorPoint(anchor);
	container:SetAuraLayoutGrowthDirection(hdir, vdir);

	container:AddAuraGroup("debuffs", filter,
		{ maxFrameCount = ns.options.MaxShow, initializeFrame = create_aurabutton() });
	container:SetAuraGroupLayout("debuffs", { elementSpacingX = 0.1 });
	container:SetAuraProcessingPolicy(CustomAuraContainerAuraProcessingPolicy.ProcessAura);
	if bnameplate then
		container:SetAuraGroupCandidateFilters("debuffs", {nameplateShowPersonal = true});
	end
	container:SetUnit(unit);
	container:SetEnabled(false);
	return container;
end

local function setup_frame(unit)

    local parent = parentframes[unit].frame;
    local isboss = parentframes[unit].isboss;
    local offset = 3;

    if isboss then
    	offset = -50;
    end

	main_frame.helpfulframes[unit] = create_container(parent, unit, filters.helpful, "LEFT",
		AnchorUtil.FlowDirection.Right,
		AnchorUtil.FlowDirection.Down, false);

	main_frame.helpfulframes[unit]:SetPoint("LEFT", parent, "RIGHT", offset, 0);
	main_frame.helpfulframes[unit]:SetWidth(1)
	main_frame.helpfulframes[unit]:SetHeight(1)
	main_frame.helpfulframes[unit]:Show()

	main_frame.harmfulframes[unit]= create_container(parent, unit, filters.harmful, "LEFT",
		AnchorUtil.FlowDirection.Right,
		AnchorUtil.FlowDirection.Down, ns.options.ShowNameplatesOnly);

    main_frame.harmfulframes[unit]:SetPoint("LEFT", parent, "RIGHT", offset, 0);
	main_frame.harmfulframes[unit]:SetWidth(1)
	main_frame.harmfulframes[unit]:SetHeight(1)
	main_frame.harmfulframes[unit]:Show();

end

local function setup_frames()
	if UnitAffectingCombat("player") then
		return;
	end
	bsetup = true;
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
    elseif event == "PLAYER_REGEN_ENABLED" then
    	if bsetup == false then
			setup_frames();
		end
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
    main_frame.harmfulframes = {};
    main_frame.helpfulframes = {};

    setup_frames();

    main_frame:RegisterEvent("PLAYER_FOCUS_CHANGED")
    main_frame:RegisterEvent("INSTANCE_ENCOUNTER_ENGAGE_UNIT")
    main_frame:RegisterEvent("PLAYER_ENTERING_WORLD")
    main_frame:RegisterEvent("PLAYER_REGEN_ENABLED");
    main_frame:SetScript("OnEvent", on_event)

end

C_Timer.After(1, init);
