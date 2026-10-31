local _, ns = ...;

local configs = {

    xpoint = -433,
    ypoint = -145,
    width = 118,
    height = 14,
    alpha = 1,
    font = STANDARD_TEXT_FONT,
};

configs.textsize = configs.height * 0.7;
local main_frame;
local interrupt_infos = {};


local function insert_interrupt(interruptedby, unit, spellid)
    if interruptedby then
        local unitname = UnitNameFromGUID(interruptedby);
        if unitname then
            local _, class, _ = UnitClassFromGUID(interruptedby);
            if class then
                local color = C_ClassColor.GetClassColor(class);
                local duration = C_DurationUtil.CreateDuration();
                local start = GetTime()
                duration:SetTimeFromStart(start, ns.options.MaxTime);
                local spellinfo = C_Spell.GetSpellInfo(spellid);
                if spellinfo then
                    table.insert(interrupt_infos, 1, {
                        start = start,
                        raidicon = GetRaidTargetIndex(unit),
                        spellid = spellid,
                        icon = spellinfo.iconID,
                        color = color,
                        unitname =
                            unitname,
                        duration = duration,

                    });
                end
            end
        end
    end
end

local function checkstatus()
    local isparty = not IsInRaid() and IsInGroup();
    wipe(interrupt_infos);
    if isparty then
        main_frame:RegisterEvent("UNIT_SPELLCAST_INTERRUPTED");
        main_frame:RegisterEvent("UNIT_SPELLCAST_CHANNEL_STOP");
        main_frame:RegisterEvent("UNIT_SPELLCAST_EMPOWER_STOP");
    else
        main_frame:UnregisterEvent("UNIT_SPELLCAST_INTERRUPTED");
        main_frame:UnregisterEvent("UNIT_SPELLCAST_CHANNEL_STOP");
        main_frame:UnregisterEvent("UNIT_SPELLCAST_EMPOWER_STOP");
    end
end

local function on_event(_, event, ...)
    if event == "PLAYER_ENTERING_WORLD" or event == "GROUP_JOINED" or event == "GROUP_ROSTER_UPDATE" then
        checkstatus();
    else
        local interruptedby = nil;
        local complete = nil;

        local unit, casterGUID, spellid = ...;
        local binterrupted = false;

        if UnitCanAttack("player", unit) and string.find(unit, "nameplate") then
            if (event == "UNIT_SPELLCAST_INTERRUPTED") then
                interruptedby = select(4, ...);
                binterrupted = true;
            elseif (event == "UNIT_SPELLCAST_CHANNEL_STOP") then
                interruptedby = select(4, ...);
                complete = interruptedby == nil;
                if (not complete) then
                    binterrupted = true;
                end
            elseif (event == "UNIT_SPELLCAST_EMPOWER_STOP") then
                _, _, _, complete, interruptedby = ...;
                if (not issecretvalue(complete)) and (not complete) then
                    binterrupted = true;
                end
            end

            if binterrupted then
                insert_interrupt(interruptedby, unit, spellid);
            end
        end
    end
end

local function show_raidicon(raidicon, markframe)
    if raidicon then
        SetRaidTargetIconTexture(markframe, raidicon);
        markframe:Show();
    else
        markframe:Hide();
    end
end

local zero_duration = C_DurationUtil.CreateDuration();

local function on_update()
    local i = 1;
    local curr = GetTime();

    local max_bars = math.min(ns.options.MaxShow, #main_frame.bars);

    for idx = #interrupt_infos, 1, -1 do
        local interrupt_info = interrupt_infos[idx];
        local remain = curr - interrupt_info.start;
        if remain >= ns.options.MaxTime then
            table.remove(interrupt_infos, idx);
        end
    end
    for idx, interrupt_info in ipairs(interrupt_infos) do
        if i <= max_bars and main_frame then
            local remainbar = main_frame.bars[i];
            local frameicon = remainbar.button.icon;
            local text      = remainbar.name;
            local mark      = remainbar.mark;
            local raidicon  = interrupt_info.raidicon;
            local duration  = interrupt_info.duration;

            frameicon:SetTexture(interrupt_info.icon);
            remainbar.duration_obj = duration;
            remainbar:SetTimerDuration(duration, 0, Enum.StatusBarTimerDirection.RemainingTime);
            remainbar.castspellid = interrupt_info.spellid;

            local color = interrupt_info.color
            remainbar:SetStatusBarColor(color:GetRGBA());
            text:SetText(interrupt_info.unitname);
            show_raidicon(raidicon, mark);
            remainbar:Show();
            i = i + 1;
        end
    end
    for j = i, max_bars do
        if main_frame and main_frame.bars[j] then
            local frame = main_frame.bars[j];
            frame:SetTimerDuration(zero_duration);
            frame.duration_obj = nil;
            frame:Hide();
        end
    end
end

local function update_castbar(remainbar)
    if not remainbar:IsShown() then
        return;
    end

    if remainbar.duration_obj then
        remainbar.time:SetText(string.format("%.1f", remainbar.duration_obj:GetRemainingDuration(0)));
    end
end

local function setup_bar()
    local remainbar = CreateFrame("StatusBar", nil, UIParent)
    remainbar:SetFrameStrata("LOW");
    remainbar:SetStatusBarTexture("RaidFrame-Hp-Fill")
    local statustexture = remainbar:GetStatusBarTexture();
    statustexture:SetHorizTile(false)
    remainbar:SetMinMaxValues(0, 100)
    remainbar:SetValue(100)
    remainbar:SetHeight(configs.height)
    remainbar:SetWidth(configs.width - (configs.height + 2) * 1.2)
    remainbar:SetStatusBarColor(1, 0.9, 0.9);
    remainbar:SetAlpha(configs.alpha);

    remainbar.bg = remainbar:CreateTexture(nil, "BACKGROUND")
    remainbar.bg:SetPoint("TOPLEFT", remainbar, "TOPLEFT", -1, 1)
    remainbar.bg:SetPoint("BOTTOMRIGHT", remainbar, "BOTTOMRIGHT", 1, -1)
    remainbar.bg:SetColorTexture(0, 0, 0, 1);
    remainbar.bg:Show();

    remainbar.name = remainbar:CreateFontString(nil, "OVERLAY");
    remainbar.name:SetFont(STANDARD_TEXT_FONT, configs.textsize);
    remainbar.name:SetPoint("LEFT", remainbar, "LEFT", 3, 0);

    remainbar.time = remainbar:CreateFontString(nil, "OVERLAY");
    remainbar.time:SetFont(STANDARD_TEXT_FONT, configs.textsize);
    remainbar.time:SetPoint("RIGHT", remainbar, "RIGHT", -3, 0);

    if not remainbar:GetScript("OnEnter") then
        remainbar:SetScript("OnEnter", function(self)
            if self.castspellid then
                GameTooltip_SetDefaultAnchor(GameTooltip, self);
                GameTooltip:SetSpellByID(self.castspellid);
            end
        end)
        remainbar:SetScript("OnLeave", function()
            GameTooltip:Hide();
        end)
    end

    remainbar:EnableMouse(false);
    remainbar:SetMouseMotionEnabled(true);
    remainbar:Hide();

    remainbar.button = CreateFrame("Button", nil, remainbar, "ASRYFrameTemplate");
    remainbar.button:SetPoint("RIGHT", remainbar, "LEFT", -1, 0)
    remainbar.button:SetWidth((configs.height) * 1.2);
    remainbar.button:SetHeight(configs.height);
    remainbar.button:SetAlpha(1);
    remainbar.button:EnableMouse(false);
    remainbar.button.icon:SetTexCoord(.08, .92, .16, .84);
    remainbar.button.bg = remainbar.button:CreateTexture(nil, "BACKGROUND", nil, -7)
    remainbar.button.bg:SetPoint("TOPLEFT", remainbar.button, "TOPLEFT", -1, 1)
    remainbar.button.bg:SetPoint("BOTTOMRIGHT", remainbar.button, "BOTTOMRIGHT", 1, -1)
    remainbar.button.bg:SetColorTexture(0, 0, 0, 1);
    remainbar.button.bg:Show();
    remainbar.button:Show();

    remainbar.mark = remainbar:CreateTexture(nil, "ARTWORK");
    remainbar.mark:SetTexture("Interface\\TargetingFrame\\UI-RaidTargetingIcons");
    remainbar.mark:SetSize(configs.textsize + 3, configs.textsize + 3);
    remainbar.mark:SetPoint("RIGHT", remainbar.button, "LEFT", -1, 0);

    local cb = function()
        update_castbar(remainbar);
    end

    if remainbar.ctimer then
        remainbar.ctimer:Cancel();
    end

    remainbar.ctimer = C_Timer.NewTicker(0.1, cb);
    return remainbar;
end


local function init()
    ns.SetupOptionPanels();
    main_frame = CreateFrame("FRAME", nil, UIParent)
    main_frame:SetScript("OnEvent", on_event);

    main_frame:RegisterEvent("PLAYER_ENTERING_WORLD");
    main_frame:RegisterEvent("GROUP_JOINED");
    main_frame:RegisterEvent("GROUP_ROSTER_UPDATE");

    if main_frame.bars == nil then
        main_frame.bars = {};
    end

    for idx = 1, ns.options.MaxShow do
        main_frame.bars[idx] = setup_bar();

        if idx == 1 then
            main_frame.bars[idx]:SetPoint("CENTER", configs.xpoint, configs.ypoint)
        else
            main_frame.bars[idx]:SetPoint("TOPRIGHT", main_frame.bars[idx - 1], "BOTTOMRIGHT", 0, -1);
        end
    end

    local libasConfig = LibStub:GetLibrary("LibasConfig", true);

    if libasConfig then
        libasConfig.load_position(main_frame.bars[1], "asReady", ARDY_Positions);
    end

    checkstatus();
    local timer = C_Timer.NewTicker(0.2, on_update);
end


C_Timer.After(0.5, init);
