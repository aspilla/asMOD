local _, ns = ...;

local configs = {
    width = 180,
    height = 17,
    xpoint = 0,
    ypoint = -100,
    alpha = 1,
    notinterruptcolor = { 0.9, 0.9, 0.9 },
    interruptcolor = { 204 / 255, 255 / 255, 153 / 255 },
    failedcolor = { 1, 0, 0 },
    updaterate = 0.05,
    font = STANDARD_TEXT_FONT,
    kickvoice = "Interface\\AddOns\\asTargetCastBar\\Target_Kick_En.mp3",
    stunvoice = "Interface\\AddOns\\asTargetCastBar\\Target_Stun_En.mp3",
    focuskickvoice = "Interface\\AddOns\\asTargetCastBar\\Focus_Kick_En.mp3",
    focusstunvoice = "Interface\\AddOns\\asTargetCastBar\\Focus_Stun_En.mp3",

}

configs.namesize = configs.height * 0.7;
configs.timesize = configs.height * 0.5;

local region = GetCurrentRegion();

if region == 2 and GetLocale() ~= "koKR" then
    configs.font = "Fonts\\2002.ttf";
end

if GetLocale() == "koKR" then
    configs.kickvoice = "Interface\\AddOns\\asTargetCastBar\\Target_Kick.mp3"
    configs.stunvoice = "Interface\\AddOns\\asTargetCastBar\\Target_Stun.mp3"
    configs.focuskickvoice = "Interface\\AddOns\\asTargetCastBar\\Focus_Kick.mp3"
    configs.focusstunvoice = "Interface\\AddOns\\asTargetCastBar\\Focus_Stun.mp3"
end

local main_frame = CreateFrame("FRAME", nil, UIParent)
main_frame:SetPoint("BOTTOM", UIParent, "BOTTOM", 0, 0)
main_frame:SetWidth(0)
main_frame:SetHeight(0)
main_frame:Show();

local function setup_castbar()
    local castbar = CreateFrame("StatusBar", nil, UIParent)
    castbar:SetStatusBarTexture("RaidFrame-Hp-Fill")
    castbar:GetStatusBarTexture():SetHorizTile(false)
    castbar:SetMinMaxValues(0, 100)
    castbar:SetValue(100)
    castbar:SetHeight(configs.height)
    castbar:SetWidth(configs.width - (configs.height + 2) * 1.2)
    castbar:SetStatusBarColor(1, 0.9, 0.9);
    castbar:SetAlpha(configs.alpha);

    castbar.important = castbar:CreateTexture(nil, "BACKGROUND")
    castbar.important:SetPoint("TOPLEFT", castbar, "TOPLEFT", -2, 2)
    castbar.important:SetPoint("BOTTOMRIGHT", castbar, "BOTTOMRIGHT", 2, -2)

    castbar.important:SetTexture("Interface\\Addons\\asTargetCastBar\\border.tga")
    castbar.important:SetTexCoord(0.1, 0.1, 0.1, 0.1, 0.1, 0.1, 0.1, 0.1)
    castbar.important:SetVertexColor(1, 0, 0, 1);
    castbar.important:SetAlpha(0);
    castbar.important:Show();
    

    castbar.bg = castbar:CreateTexture(nil, "BACKGROUND")
    castbar.bg:SetPoint("TOPLEFT", castbar, "TOPLEFT", -1, 1)
    castbar.bg:SetPoint("BOTTOMRIGHT", castbar, "BOTTOMRIGHT", 1, -1)

    castbar.bg:SetTexture("Interface\\Addons\\asTargetCastBar\\border.tga")
    castbar.bg:SetTexCoord(0.1, 0.1, 0.1, 0.1, 0.1, 0.1, 0.1, 0.1)
    castbar.bg:SetVertexColor(0, 0, 0, 1);
    castbar.bg:Show();

    castbar.name = castbar:CreateFontString(nil, "OVERLAY");
    castbar.name:SetFont(STANDARD_TEXT_FONT, configs.namesize);
    castbar.name:SetPoint("LEFT", castbar, "LEFT", 3, 0);

    castbar.time = castbar:CreateFontString(nil, "OVERLAY");
    castbar.time:SetFont(STANDARD_TEXT_FONT, configs.timesize);
    castbar.time:SetPoint("RIGHT", castbar, "RIGHT", -3, 0);

    castbar:EnableMouse(false);
    castbar.isAlert = false;
    castbar:Hide();

    castbar.button = CreateFrame("Button", nil, castbar, "ATCBFrameTemplate");
    castbar.button:SetPoint("RIGHT", castbar, "LEFT", -1, 0)
    castbar.button:SetWidth((configs.height + 2) * 1.2);
    castbar.button:SetHeight(configs.height + 2);
    castbar.button:SetScale(1);
    castbar.button:SetAlpha(1);
    castbar.button:EnableMouse(false);
    castbar.button.icon:SetTexCoord(.08, .92, .16, .84);
    castbar.button.border:SetTexCoord(0.08, 0.08, 0.08, 0.92, 0.92, 0.08, 0.92, 0.92);
    castbar.button.border:SetVertexColor(0, 0, 0);
    castbar.button.border:Show();
    castbar.button:Show();

    castbar.targetname = castbar:CreateFontString(nil, "ARTWORK");
    castbar.targetname:SetFont(configs.font, configs.namesize);
    castbar.targetname:SetPoint("TOPRIGHT", castbar, "BOTTOMRIGHT", 0, -2);

    castbar.mark = castbar:CreateTexture(nil, "ARTWORK");
    castbar.mark:SetTexture("Interface\\TargetingFrame\\UI-RaidTargetingIcons");
    castbar.mark:SetSize(configs.namesize + 3, configs.namesize + 3);
    castbar.mark:SetPoint("RIGHT", castbar.button, "LEFT", -1, 0);
    castbar.start = 0;
    castbar.duration = 0;
    castbar.soundalerted = false;
    castbar.istargetplayer = false;
    return castbar;
end
ns.targetcastbar = setup_castbar();
ns.targetcastbar:SetPoint("CENTER", UIParent, "CENTER", configs.xpoint + ((configs.height + 2) * 1.2) / 2, configs
    .ypoint)
ns.focuscastbar = setup_castbar();
ns.focuscastbar:SetPoint("CENTER", UIParent, "CENTER", configs.xpoint + ((configs.height + 2) * 1.2) / 2,
    configs.ypoint + 150)



local bloaded = C_AddOns.LoadAddOn("asMOD");

if bloaded and ASMODOBJ.load_position then
    ASMODOBJ.load_position(ns.targetcastbar, "asTargetCastBar (Target)");
    ASMODOBJ.load_position(ns.focuscastbar, "asTargetCastBar (Focus)");
end

local function hide_castbar(castbar)
    local targetname = castbar.targetname;
    castbar:SetValue(0);
    castbar:Hide();
    ns.lib.PixelGlow_Stop(castbar);
    castbar.isAlert = false;
    targetname:SetText("");
    targetname:Hide();
    castbar.failstart = nil;
    castbar.soundalerted = false;
    castbar.duration_obj = nil;
end


local function show_raidicon(unit, markframe)
    local raidicon = GetRaidTargetIndex(unit);
    if raidicon then
        SetRaidTargetIconTexture(markframe, raidicon);
        markframe:Show();
    else
        markframe:Hide();
    end
end

local function get_typeofcast(unit)
    local nameplate = C_NamePlate.GetNamePlateForUnit(unit, issecure())
    if nameplate and nameplate.UnitFrame and nameplate.UnitFrame.castBar then
        return nameplate.UnitFrame.castBar.barType;
    end
    return nil;
end

local function check_casting(castbar, event)
    local unit         = castbar.unit;
    local frameicon    = castbar.button.icon;
    local text         = castbar.name;
    local time         = castbar.time;
    local targetname   = castbar.targetname;
    local mark         = castbar.mark;
    local targettarget = unit .. "target";
    local currtime     = GetTime();

    if UnitExists(unit) then
        local bchannel = false;
        local name, _, texture, start, endTime, isTradeSkill, castID, notInterruptible, spellid = UnitCastingInfo(
            unit);

        if not name then
            name, _, texture, start, endTime, isTradeSkill, notInterruptible, spellid = UnitChannelInfo(unit);
            bchannel = true;
        end

        if event == "UNIT_SPELLCAST_INTERRUPTED" then
            castbar:SetMinMaxValues(0, 100);
            castbar:SetValue(100);
            local failtext = "Interrupted"
            local color = configs.failedcolor;

            time:SetText(failtext);
            castbar:SetStatusBarColor(color[1], color[2], color[3]);
            castbar.failstart = currtime;
            castbar:SetStatusBarDesaturated(false);
            castbar.duration_obj = nil;
            castbar:Show();
        elseif name then
            local duration;

            if bchannel then
                duration = UnitChannelDuration(unit);
            else
                duration = UnitCastingDuration(unit);
            end
            castbar.duration_obj = duration;
            frameicon:SetTexture(texture);
            castbar:SetReverseFill(bchannel);

            castbar:SetMinMaxValues(start, endTime)
            castbar.failstart = nil;

            local color = configs.interruptcolor;
            local type = get_typeofcast(unit);

            if C_CurveUtil.EvaluateColorValueFromBoolean then
                local isimportant = C_Spell.IsSpellImportant(spellid);
                local alpha = C_CurveUtil.EvaluateColorValueFromBoolean(isimportant, 1, 0);
                castbar.important:SetAlpha(alpha);
            end

            if type and type == "uninterruptable" then
                color = configs.notinterruptcolor;
            else
                color = configs.interruptcolor;
            end           
            
            castbar:SetStatusBarColor(color[1], color[2], color[3]);
            text:SetText(name);
            show_raidicon(unit, mark);
            frameicon:Show();
            castbar:Show();

            if UnitExists(targettarget) then
                local _, Class = UnitClass(targettarget)
                if Class then
                    local classcolor = RAID_CLASS_COLORS[Class]
                    if classcolor then
                        targetname:SetTextColor(classcolor.r, classcolor.g, classcolor.b);
                        targetname:SetText(UnitName("targettarget"));
                        targetname:Show();
                    end
                end
            else
                targetname:SetText("");
                targetname:Hide();
            end


            if name and castbar.soundalerted == false then
                local isfocus = UnitIsUnit(unit, "focus");
                local soundfile = nil;

                if type == "uninterruptable" then
                    if ns.options.PlaySoundStun then
                        local stunable = UnitLevel(unit) <= UnitLevel("player");
                        if stunable then
                            if isfocus then
                                soundfile = configs.focusstunvoice
                            else
                                soundfile = configs.stunvoice;
                            end
                        end
                    end
                else
                    if ns.options.PlaySoundKick then
                        if isfocus then
                            soundfile = configs.focuskickvoice
                        else
                            soundfile = configs.kickvoice;
                        end
                    end
                end

                if soundfile then
                    castbar.soundalerted = true;
                    PlaySoundFile(soundfile, "MASTER");
                end
            end
        else
            if castbar.failstart == nil then
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

    if unit == "focus" then
        if not ns.options.ShowFocus then
            return;
        end
    end

    castbar.failstart = nil;


    check_casting(castbar, "NOTHING");
end


local function register_unit(castbar, unit)
    castbar.unit = unit;
    castbar:RegisterUnitEvent("UNIT_SPELLCAST_INTERRUPTED", unit);
    castbar:RegisterUnitEvent("UNIT_SPELLCAST_DELAYED", unit);
    castbar:RegisterUnitEvent("UNIT_SPELLCAST_CHANNEL_START", unit);
    castbar:RegisterUnitEvent("UNIT_SPELLCAST_CHANNEL_UPDATE", unit);
    castbar:RegisterUnitEvent("UNIT_SPELLCAST_CHANNEL_STOP", unit);
    castbar:RegisterUnitEvent("UNIT_SPELLCAST_EMPOWER_START", unit);
    castbar:RegisterUnitEvent("UNIT_SPELLCAST_EMPOWER_UPDATE", unit);
    castbar:RegisterUnitEvent("UNIT_SPELLCAST_EMPOWER_STOP", unit);
    castbar:RegisterUnitEvent("UNIT_SPELLCAST_INTERRUPTIBLE", unit);
    castbar:RegisterUnitEvent("UNIT_SPELLCAST_NOT_INTERRUPTIBLE", unit);
    castbar:RegisterUnitEvent("UNIT_SPELLCAST_START", unit);
    castbar:RegisterUnitEvent("UNIT_SPELLCAST_STOP", unit);
    castbar:RegisterUnitEvent("UNIT_SPELLCAST_FAILED", unit);
    castbar:RegisterUnitEvent("UNIT_TARGET", unit);
end

local function on_unit_event(castbar, event, ...)
    --[[
    if event == "UNIT_TARGET" then
        local unit = ...;

        if UnitIsUnit("player", unit .. "target") then
            castbar.istargetplayer = true;
        else
            castbar.istargetplayer = false;
        end
    end
    ]]
    check_casting(castbar, event);
end

ns.targetcastbar:SetScript("OnEvent", on_unit_event);
register_unit(ns.targetcastbar, "target");
ns.focuscastbar:SetScript("OnEvent", on_unit_event);
register_unit(ns.focuscastbar, "focus");

local function on_event(self, event, ...)
    if event == "PLAYER_TARGET_CHANGED" then
        ns.targetcastbar.soundalerted = nil;
        check_unit(ns.targetcastbar, "target");
    elseif event == "PLAYER_FOCUS_CHANGED" then
        ns.focuscastbar.soundalerted = nil;
        check_unit(ns.focuscastbar, "focus");
    elseif event == "PLAYER_ENTERING_WORLD" then
        check_unit(ns.targetcastbar, "target");
        check_unit(ns.focuscastbar, "focus");
    elseif event == "ADDON_LOADED" then
        local name = ...;

        if name == "asTargetCastBar" then
            ns.setup_option();
        end
    end
end


local function update_castbar(castbar)
    local failstart = castbar.failstart;
    local current = GetTime();

    if failstart then
        if current - failstart > 0.5 then
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
    update_castbar(ns.targetcastbar);
    update_castbar(ns.focuscastbar);
end

main_frame:SetScript("OnEvent", on_event)
main_frame:RegisterEvent("PLAYER_TARGET_CHANGED");
main_frame:RegisterEvent("PLAYER_FOCUS_CHANGED");
main_frame:RegisterEvent("ADDON_LOADED");
main_frame:RegisterEvent("PLAYER_ENTERING_WORLD");

C_Timer.NewTicker(configs.updaterate, on_update);
