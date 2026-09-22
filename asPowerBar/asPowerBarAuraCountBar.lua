local _, ns = ...;

local main_frame = CreateFrame("Frame", nil, UIParent);
main_frame:SetSize(1, 1);
main_frame:Show();

local function create_aurabutton(color, maxcount, showduration)
    return function(frame)
        frame:SetWidth(1);
        frame:SetHeight(1);
        frame.bar = CreateFrame("StatusBar", nil, frame)
        frame.bar:SetStatusBarTexture("RaidFrame-Hp-Fill")
        frame.bar:GetStatusBarTexture():SetHorizTile(false)
        frame.bar:SetStatusBarColor(color:GetRGB());
        frame.bar:SetWidth(ns.options.BarWidth)
            frame.bar:SetHeight(ns.combocountbar:GetHeight())
        frame.bar:SetPoint("BOTTOM", frame, "BOTTOM", 0, 0)
        frame.bar:Show();
        frame.bar:EnableMouse(false);

        frame.remainbar = CreateFrame("StatusBar", nil, frame)
        frame.remainbar:SetFrameLevel(frame.bar:GetFrameLevel() + 1);
        frame.remainbar:SetStatusBarTexture("RaidFrame-Hp-Fill")
        frame.remainbar:GetStatusBarTexture():SetHorizTile(false)
        frame.remainbar:SetStatusBarColor(1, 1, 1);
        frame.remainbar:SetWidth(ns.options.BarWidth)
        frame.remainbar:SetHeight(2)
        frame.remainbar:SetPoint("BOTTOM", frame, "BOTTOM", 0, 0)
        frame.remainbar:Show();
        frame.remainbar:EnableMouse(false);
        frame.bg = frame:CreateTexture(nil, "BACKGROUND");
        frame.bg:SetPoint("TOPLEFT", frame.bar, "TOPLEFT", -1, 1);
        frame.bg:SetPoint("BOTTOMRIGHT", frame.bar, "BOTTOMRIGHT", 1, -1);
        frame.bg:SetColorTexture(0.1, 0.1, 0.1, 1);


        frame.overlay = CreateFrame("Frame", nil, frame);
        frame.overlay:SetFrameLevel(frame:GetFrameLevel() + 200);
        frame.text = frame.overlay:CreateFontString(nil, "OVERLAY");
        frame.text:SetFont(ns.configs.font, ns.options.FontSize, ns.configs.fontOutline)
        frame.text:ClearAllPoints();
        frame.text:SetPoint("LEFT", frame.bar, "LEFT", 3, 0);
        frame.text:SetTextColor(1, 1, 1);
        if maxcount then
            frame:SetApplicationBar(frame.bar, { maxApplications = maxcount, interpolation = ns.bartype });
            if showduration then
                frame:SetDurationBar(frame.remainbar, { interpolation = ns.bartype, direction = 1 });
            else
                frame.remainbar:Hide();
            end

        else
            frame:SetApplicationCount(frame.text);
            frame:SetDurationBar(frame.bar, { interpolation = ns.bartype, direction = 1 });
            frame.remainbar:Hide();
        end
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

local function setup_container(spellid, color, maxcount, showduration)
    local filter = AuraUtil.CreateFilterString(AuraUtil.AuraFilters.Helpful, AuraUtil.AuraFilters.Player);
    local cfilters = { includeSpellIDs = { [spellid] = true } };

    if main_frame.containers[spellid] == nil then
        main_frame.containers[spellid] = create_container(main_frame, "player", "BOTTOM", AnchorUtil.FlowDirection.Right,
            AnchorUtil.FlowDirection.Down);
        local container = main_frame.containers[spellid];
        container:SetFrameLevel(main_frame:GetFrameLevel() + #(main_frame.containers))
        add_group(container, "aurabar", filter, cfilters,
            { maxFrameCount = 1, initializeFrame = create_aurabutton(color, maxcount, showduration) });
        container:SetPoint("BOTTOM", ns.combocountbar, "BOTTOM", 0, 0);
        container:SetWidth(1)
        container:SetHeight(1)
    end
    main_frame.containers[spellid]:Show()
    main_frame.containers[spellid]:SetEnabled(true);
end

function ns.setup_auracountbar(spellids, maxcount, showduration)
    main_frame:SetParent(ns.main_frame);
    main_frame:SetFrameLevel(ns.configs.framelevel + 200);
    ns.combocountbar:SetValue(0);
    ns.combocountbar:Show();
    if main_frame.containers == nil then
        main_frame.containers = {};
    end
    for spellid, color in pairs(spellids) do
        setup_container(spellid, color, maxcount, showduration);
    end
end

function ns.clear_auracountbar()
    if main_frame.containers then
        for _, container in pairs(main_frame.containers) do
            container:SetEnabled(false);
            container:Hide();
        end
        main_frame.containers = {};
    end
end
