local _, ns = ...;
local main_frame = CreateFrame("Frame", nil, UIParent);

local lnfusion_buffs = {
    [10060] = true,
}

local filters = {
    helpful = AuraUtil.CreateFilterString(AuraUtil.AuraFilters.Helpful),
};

local function create_aurabutton(size)
    return function(frame)
        frame.cooldown = CreateFrame("Cooldown", nil, frame, "CooldownFrameTemplate")
        frame.cooldown:SetAllPoints(frame);
        frame.cooldown:SetDrawSwipe(true);
        frame.cooldown:SetReverse(true);

        frame.icon = frame:CreateTexture(nil, "BACKGROUND")
        frame.icon:SetAllPoints(frame);
        frame.icon:SetTexCoord(.08, .92, .16, .84);

        frame.overlay = CreateFrame("Frame", nil, frame);
        frame.overlay:SetFrameLevel(frame:GetFrameLevel() + 5);
        frame.overlay:SetAllPoints(frame);

        frame.borderb = frame.overlay:CreateTexture(nil, "BORDER");
        frame.borderb:SetTexture("Interface\\Addons\\asPowerInfusion\\border.tga")
        frame.borderb:SetAllPoints(frame.overlay);
        frame.borderb:SetTexCoord(0.08, 0.08, 0.08, 0.92, 0.92, 0.08, 0.92, 0.92);
        frame.borderb:SetVertexColor(0, 0, 0);

        frame:SetWidth(size);
        frame:SetHeight(size * ns.configs.sizerate);

        frame:EnableMouse(false);
        frame:SetIcon(frame.icon);
        frame:SetDurationCooldown(frame.cooldown);
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

    main_frame.playeranchor = CreateFrame("Frame", nil, UIParent);
    main_frame.playeranchor:SetPoint("RIGHT", UIParent, "CENTER", ns.configs.player_xpoint,
        ns.configs.player_ypoint);
    main_frame.playeranchor:SetWidth(1);
    main_frame.playeranchor:SetHeight(1);
    main_frame.playeranchor:Show();

    if libasConfig then
        libasConfig.load_position(main_frame.playeranchor, "asPowerInfusion(Player)", API_Positions);
    end
    local cfilter = {}

    cfilter.includeSpellIDs = lnfusion_buffs;
    main_frame.playerframe = create_container(main_frame, "player", "RIGHT", AnchorUtil.FlowDirection.Left,
        AnchorUtil.FlowDirection.Down);

    add_group(main_frame.playerframe, "debuffs", filters.helpful, cfilter,
        {
            maxFrameCount = 1,
            initializeFrame = create_aurabutton(ns.configs.size)
        });
    main_frame.playerframe:SetEnabled(true);
    main_frame.playerframe:SetPoint("RIGHT", main_frame.playeranchor, "RIGHT", 0, 0)
    main_frame.playerframe:SetWidth(1)
    main_frame.playerframe:SetHeight(1)
    main_frame.playerframe:Show()
    main_frame.playerframe:SetEnabled(true);
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
end

C_Timer.After(1, init);
