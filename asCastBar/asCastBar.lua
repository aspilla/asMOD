local _, ns = ...;

local configs = {
    xpoint = 0,
    ypoint = -273,
    alpha = 1,
    notinterruptcolor = { 0.9, 0.9, 0.9 },
    interruptcolor = { 204 / 255, 255 / 255, 153 / 255 },
    failedcolor = { 1, 0, 0 },
    updaterate = 0.1,
    font = STANDARD_TEXT_FONT,
    interruptedtext = INTERRUPTED,
    maxtick = 10,
}

configs.tickspells = {
    -- ----------------------------------------------------------------
    -- 사제 (Priest)
    -- ----------------------------------------------------------------
    [15407]  = 6, -- 정신 채찍 (Mind Flay) - 암흑
    [391403] = 6, -- 정신 채찍: 광기 (Mind Flay: Insanity) - 암흑
    -- ----------------------------------------------------------------
    -- 마법사 (Mage)
    -- ----------------------------------------------------------------
    [5143]   = 7, -- 신비한 화살 (Arcane Missiles) - 비전 (기본 2.5초 동안 5연사)

    -- ----------------------------------------------------------------
    -- 흑마법사 (Warlock)
    -- ----------------------------------------------------------------
    [198590] = 5, -- 영혼 흡수 (Drain Soul) - 고통 (기본 6초 유지, 1초마다 틱)

}


local region = GetCurrentRegion();

if region == 2 and GetLocale() ~= "koKR" then
    configs.font = "Fonts\\2002.ttf";
end

if GetLocale() == "koKR" then
    configs.interruptedtext = "차단됨";
end

local main_frame = CreateFrame("FRAME", nil, UIParent)
main_frame:SetFrameStrata("LOW");
main_frame:SetPoint("BOTTOM", UIParent, "BOTTOM", 0, 0)
main_frame:SetWidth(0)
main_frame:SetHeight(0)
main_frame:Show();

local function setup_castbar()
    configs.namesize = ns.options.BarHeight * 0.6;
    configs.timesize = ns.options.BarHeight * 0.5;
    local castbar = CreateFrame("StatusBar", nil, UIParent)
    castbar:SetFrameStrata("LOW");
    castbar:SetStatusBarTexture("RaidFrame-Hp-Fill")
    local statustexture = castbar:GetStatusBarTexture();
    statustexture:SetHorizTile(false)
    castbar:SetMinMaxValues(0, 100)
    castbar:SetValue(100)
    castbar:SetHeight(ns.options.BarHeight)
    castbar:SetWidth(ns.options.BarWidth - (ns.options.BarHeight + 2) * 1.2)
    castbar:SetStatusBarColor(1, 0.9, 0.9);
    castbar:SetAlpha(configs.alpha);

    castbar.notinterruptable = castbar:CreateTexture(nil, "ARTWORK", "asCastBarNotInteruptTemplate", 1);
    castbar.notinterruptable:SetParent(castbar);
    castbar.notinterruptable:ClearAllPoints();
    castbar.notinterruptable:SetPoint("TOPLEFT", statustexture, "TOPLEFT", 0, 0);
    castbar.notinterruptable:SetPoint("BOTTOMRIGHT", statustexture, "BOTTOMRIGHT", 0, 0);
    castbar.notinterruptable:SetVertexColor(configs.notinterruptcolor[1], configs.notinterruptcolor[2],
        configs.notinterruptcolor[3]);
    castbar.notinterruptable:SetAlpha(0);
    castbar.notinterruptable:Show();

    castbar.bg = castbar:CreateTexture(nil, "BACKGROUND")
    castbar.bg:SetPoint("TOPLEFT", castbar, "TOPLEFT", -1, 1)
    castbar.bg:SetPoint("BOTTOMRIGHT", castbar, "BOTTOMRIGHT", 1, -1)
    castbar.bg:SetColorTexture(0, 0, 0, 1);
    castbar.bg:Show();

    castbar.name = castbar:CreateFontString(nil, "OVERLAY");
    castbar.name:SetFont(STANDARD_TEXT_FONT, configs.namesize);
    castbar.name:SetPoint("LEFT", castbar, "LEFT", 3, 0);

    castbar.time = castbar:CreateFontString(nil, "OVERLAY");
    castbar.time:SetFont(STANDARD_TEXT_FONT, configs.timesize);
    castbar.time:SetPoint("RIGHT", castbar, "RIGHT", -3, 0);

    castbar.ticks = {}

    for i = 1, configs.maxtick do
        local tick = castbar:CreateTexture(nil, "OVERLAY");
        tick:SetTexture("Interface\\Buttons\\WHITE8X8");
        tick:SetVertexColor(1, 1, 1, 1);
        tick:SetWidth(1);
        tick:SetHeight(ns.options.BarHeight);
        tick:Hide();
        castbar.ticks[i] = tick;
    end

    if not castbar:GetScript("OnEnter") then
        castbar:SetScript("OnEnter", function(self)
            if self.castspellid then
                GameTooltip_SetDefaultAnchor(GameTooltip, self);
                GameTooltip:SetSpellByID(self.castspellid);
            end
        end)
        castbar:SetScript("OnLeave", function()
            GameTooltip:Hide();
        end)
    end

    castbar:EnableMouse(false);
    castbar:SetMouseMotionEnabled(true);
    castbar.isAlert = false;
    castbar:Hide();

    castbar.button = CreateFrame("Button", nil, castbar, "ACBFrameTemplate");
    castbar.button:SetPoint("RIGHT", castbar, "LEFT", -1, 0)
    castbar.button:SetWidth((ns.options.BarHeight + 2) * 1.2);
    castbar.button:SetHeight(ns.options.BarHeight + 2);
    castbar.button:SetAlpha(1);
    castbar.button:EnableMouse(false);
    castbar.button.icon:SetTexCoord(.08, .92, .16, .84);
    castbar.button.border:SetTexCoord(0.08, 0.08, 0.08, 0.92, 0.92, 0.08, 0.92, 0.92);
    castbar.button.border:SetVertexColor(0, 0, 0);
    castbar.button.border:Show();
    castbar.button:Show();

    castbar.start = 0;
    castbar.duration = 0;
    return castbar;
end

function ns.resize(castbar)
    configs.namesize = ns.options.BarHeight * 0.6;
    configs.timesize = ns.options.BarHeight * 0.5;
    castbar:SetHeight(ns.options.BarHeight)
    castbar:SetWidth(ns.options.BarWidth - (ns.options.BarHeight + 2) * 1.2)
    castbar.name:SetFont(STANDARD_TEXT_FONT, configs.namesize);
    castbar.time:SetFont(STANDARD_TEXT_FONT, configs.timesize);

    castbar.button:SetWidth((ns.options.BarHeight + 2) * 1.2);
    castbar.button:SetHeight(ns.options.BarHeight + 2);
end

local function hide_castbar(castbar)
    castbar:SetValue(0);
    castbar:Hide();
    castbar.isAlert = false;
    castbar.failstart = nil;
    castbar.donestart = nil;
    castbar.duration_obj = nil;

    castbar.notinterruptable:SetAlpha(0);
    for i = 1, configs.maxtick do
        local tick = castbar.ticks[i]
        tick:Hide();
    end
end

local function getStageDuration(stage, NumStages, unit)
    if stage == NumStages then
        return GetUnitEmpowerHoldAtMaxTime(unit);
    else
        return GetUnitEmpowerStageDuration(unit, stage - 1);
    end
end

local function check_casting(castbar, event, unit, complete)
    local frameicon = castbar.button.icon;
    local text      = castbar.name;
    local time      = castbar.time;
    local currtime  = GetTime();

    if UnitExists(unit) then
        local bchannel = false;
        local stages = nil;
        local name, _, texture, start, endTime, isTradeSkill, castID, notInterruptible, spellid = UnitCastingInfo(
            unit);

        if not name then
            name, _, texture, start, endTime, isTradeSkill, notInterruptible, spellid, _, stages = UnitChannelInfo(
                unit);
            bchannel = true;
        end

        if event == "UNIT_SPELLCAST_INTERRUPTED" then
            castbar:SetMinMaxValues(0, 100);
            castbar:SetValue(100);
            local failtext = configs.interruptedtext;
            local color = configs.failedcolor;

            time:SetText(failtext);
            castbar:SetStatusBarColor(color[1], color[2], color[3]);
            castbar.failstart = currtime;
            castbar:SetStatusBarDesaturated(false);
            castbar.duration_obj = nil;
            castbar.notinterruptable:SetAlpha(0);
            castbar:Show();
        elseif complete then
            castbar.donestart = currtime;
            castbar:Show();
        elseif name then
            local duration;
            local reverse = bchannel;

            if bchannel then
                if stages and stages > 0 then
                    duration = UnitEmpoweredChannelDuration(unit, true);
                    reverse = false;
                else
                    duration = UnitChannelDuration(unit);
                end
            else
                duration = UnitCastingDuration(unit);
            end
            castbar.duration_obj = duration;
            frameicon:SetTexture(texture);

            castbar:SetReverseFill(reverse);
            castbar:SetMinMaxValues(duration:GetStartTime() * 1000, duration:GetEndTime() * 1000);
            castbar.failstart = nil;
            castbar.donestart = nil;
            castbar.castspellid = spellid;

            local _, class = UnitClass(unit)
            local color = configs.interruptcolor;

            if class then
                color = RAID_CLASS_COLORS[class];
            end
            castbar:SetStatusBarColor(color.r, color.g, color.b);
            text:SetText(name);
            frameicon:Show();
            castbar:Show();

            local alpha = C_CurveUtil.EvaluateColorValueFromBoolean(notInterruptible, 1, 0);
            castbar.notinterruptable:SetAlpha(alpha);

            if stages and stages > 0 then
                local maxstages = stages + 1;
                local sum = 0;
                local left = castbar:GetLeft();
                local right = castbar:GetRight();

                if not left or not right then
                    return;
                end

                local width = right - left;

                for i = 1, maxstages - 1, 1 do
                    local stageduration = getStageDuration(i, maxstages, unit);
                    local tick = castbar.ticks[i];
                    if (stageduration > -1) then
                        sum = sum + stageduration;
                        local portion = sum / (duration:GetTotalDuration() * 1000);
                        local offset = width * portion;

                        if tick then
                            tick:ClearAllPoints();
                            tick:SetPoint("TOP", castbar, "TOPLEFT", offset, -1);
                            tick:SetPoint("BOTTOM", castbar, "BOTTOMLEFT", offset, 1);
                            tick:Show();
                        end
                    end
                end

                for i = maxstages, configs.maxtick do
                    local tick = castbar.ticks[i]
                    tick:Hide();
                end
            elseif (ns.options.ShowTick and bchannel and configs.tickspells[spellid]) then
                local tickcount = configs.tickspells[spellid];

                if tickcount > 0 then
                    local count = math.min(tickcount, configs.maxtick);
                    local width = castbar:GetWidth();

                    for i = 1, count - 1 do
                        local tick = castbar.ticks[i];

                        tick:ClearAllPoints();
                        tick:SetPoint("TOP", castbar, "TOPRIGHT", -(width * i / tickcount), -1);
                        tick:SetPoint("BOTTOM", castbar, "BOTTOMRIGHT", -(width * i / tickcount), 1);
                        tick:Show();
                    end

                    for i = count, configs.maxtick do
                        local tick = castbar.ticks[i]
                        tick:Hide();
                    end
                else
                    for i = 1, configs.maxtick do
                        local tick = castbar.ticks[i]
                        tick:Hide();
                    end
                end
            else
                for i = 1, configs.maxtick do
                    local tick = castbar.ticks[i]
                    tick:Hide();
                end
            end
        else
            if castbar.failstart == nil and castbar.donestart == nil then
                hide_castbar(castbar);
            end
        end
    else
        hide_castbar(castbar);
    end
end

local function check_unit(castbar, unit)
    if not castbar then
        return;
    end

    if not UnitExists(unit) then
        hide_castbar(castbar);
        return;
    end

    castbar.failstart = nil;
    castbar.donestart = nil;
    check_casting(castbar, "NOTHING", unit);
end


local function register_unit(castbar)
    local unit, unit2 = "player", "vehicle";
    castbar:RegisterUnitEvent("UNIT_SPELLCAST_INTERRUPTED", unit, unit2);
    castbar:RegisterUnitEvent("UNIT_SPELLCAST_DELAYED", unit, unit2);
    castbar:RegisterUnitEvent("UNIT_SPELLCAST_CHANNEL_START", unit, unit2);
    castbar:RegisterUnitEvent("UNIT_SPELLCAST_CHANNEL_UPDATE", unit, unit2);
    castbar:RegisterUnitEvent("UNIT_SPELLCAST_CHANNEL_STOP", unit, unit2);
    castbar:RegisterUnitEvent("UNIT_SPELLCAST_EMPOWER_START", unit, unit2);
    castbar:RegisterUnitEvent("UNIT_SPELLCAST_EMPOWER_UPDATE", unit, unit2);
    castbar:RegisterUnitEvent("UNIT_SPELLCAST_EMPOWER_STOP", unit, unit2);
    castbar:RegisterUnitEvent("UNIT_SPELLCAST_INTERRUPTIBLE", unit, unit2);
    castbar:RegisterUnitEvent("UNIT_SPELLCAST_NOT_INTERRUPTIBLE", unit, unit2);
    castbar:RegisterUnitEvent("UNIT_SPELLCAST_START", unit, unit2);
    castbar:RegisterUnitEvent("UNIT_SPELLCAST_STOP", unit, unit2);
    castbar:RegisterUnitEvent("UNIT_SPELLCAST_FAILED", unit, unit2);
    castbar:RegisterUnitEvent("UNIT_TARGET", unit, unit2);
end

local function on_unit_event(castbar, event, ...)
    local interruptedby = nil;
    local complete = nil;
    local unit = ...;

    if (event == "UNIT_SPELLCAST_INTERRUPTED") then
        interruptedby = select(4, ...);
    elseif (event == "UNIT_SPELLCAST_CHANNEL_STOP") then
        interruptedby = select(4, ...);
        complete = interruptedby == nil;
        if (not complete) then
            event = "UNIT_SPELLCAST_INTERRUPTED";
        end
    elseif (event == "UNIT_SPELLCAST_EMPOWER_STOP") then
        _, _, _, complete, interruptedby = ...;

        if (not issecretvalue(complete)) and (not complete) then
            event = "UNIT_SPELLCAST_INTERRUPTED";
        end
    end
    check_casting(castbar, event, unit, complete);
end

local function on_event(self, event, ...)
    if event == "PLAYER_ENTERING_WORLD" then
        check_unit(ns.playercastbar, "player");
        check_unit(ns.playercastbar, "vehicle");
    end
end

local function update_castbar(castbar)
    local failstart = castbar.failstart;
    local donestart = castbar.donestart;
    local current = GetTime();

    if failstart then
        if current - failstart > 1 then
            hide_castbar(castbar);
        end
    elseif donestart then
        if current - donestart > 0.2 then
            hide_castbar(castbar);
        end
    else
        if castbar.duration_obj then
            castbar.time:SetText(string.format("%.1f/%.1f", castbar.duration_obj:GetRemainingDuration(0),
                castbar.duration_obj:GetTotalDuration(0)));
        end
        castbar:SetValue(current * 1000, Enum.StatusBarInterpolation.ExponentialEaseOut);
    end
end

local function on_update()
    update_castbar(ns.playercastbar);
end

local function hidedefault(castframe)
    castframe:UnregisterAllEvents();
    castframe:Hide();
end

local function init()
    ns.setup_option();

    if ns.options.SimpleDesign then
        ns.playercastbar = setup_castbar();
        ns.playercastbar:SetPoint("CENTER", UIParent, "CENTER", configs.xpoint + ((ns.options.BarHeight + 2) * 1.2) / 2,
            configs
            .ypoint)

        ns.playercastbar:SetScript("OnEvent", on_unit_event);
        register_unit(ns.playercastbar);


        local libasConfig = LibStub:GetLibrary("LibasConfig", true);

        if libasConfig then
            libasConfig.load_position(ns.playercastbar, "asCastBar", ACB_Positions);
        end

        check_unit(ns.playercastbar, "player");
        check_unit(ns.playercastbar, "vehicle");

        main_frame:SetScript("OnEvent", on_event)
        main_frame:RegisterEvent("PLAYER_ENTERING_WORLD");

        C_Timer.NewTicker(configs.updaterate, on_update);

        hidedefault(PlayerCastingBarFrame);
        hidedefault(PetCastingBarFrame);
    end
end

C_Timer.After(0.5, init);
