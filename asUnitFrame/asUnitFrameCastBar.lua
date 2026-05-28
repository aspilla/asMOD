local _, ns = ...;

local configs = {
    interruptcolor = { 204 / 255, 255 / 255, 153 / 255 },
    failcolor = { 1, 0, 0 },
    interruptedtext = INTERRUPTED,
    faildonetime = 1,
};

if GetLocale() == "koKR" then
    configs.interruptedtext = "차단됨";
end


local function hide_castbar(castbar)
    local targetname = castbar.targetname;
    castbar:SetValue(0);
    castbar:Hide();
    castbar.isAlert = false;
    targetname:SetText("");
    targetname:Hide();
    castbar.failstart = nil;
    castbar.duration_obj = nil;
    castbar.important:SetAlpha(0);
    castbar.notinterruptable:SetAlpha(0);
end

local function get_interrupttext(interruptedby)
    if interruptedby then
        local unitname = UnitNameFromGUID(interruptedby);
        if unitname then
            return SPELL_INTERRUPTED_BY:format(unitname);
        end
    end

    return INTERRUPTED;
end



local function check_casting(castbar, event, interuptedby, complete)
    local unit         = castbar.unit;
    local frameicon    = castbar.button.icon;
    local text         = castbar.name;
    local time         = castbar.time;
    local targetname   = castbar.targetname;
    local targettarget = unit .. "target";
    local currtime     = GetTime();

    if UnitExists(unit) then
        local bchannel = false;
        local numStages = nil;
        local name, _, texture, start, endTime, isTradeSkill, castID, notInterruptible, spellid = UnitCastingInfo(
            unit);

        if not name then
            name, _, texture, start, endTime, isTradeSkill, notInterruptible, spellid, _, numStages = UnitChannelInfo(
                unit);
            bchannel = true;
        end
        if event == "UNIT_SPELLCAST_INTERRUPTED" then
            castbar:SetMinMaxValues(0, 100);
            castbar:SetValue(100);
            local failtext = configs.interruptedtext;
            local color = configs.failcolor;
            time:SetText(failtext);
            castbar:SetStatusBarColor(color[1], color[2], color[3]);
            castbar.failstart = currtime;
            castbar.duration_obj = nil;
            if interuptedby then
                targetname:SetText(get_interrupttext(interuptedby));
                targetname:SetTextColor(1, 1, 1);
            else
                targetname:SetText("");
            end
            castbar.important:SetAlpha(0);
            castbar.notinterruptable:SetAlpha(0);
            castbar:Show();
        elseif name and not complete then
            local duration;

            if bchannel then
                if numStages and numStages > 0 then
                    duration = UnitEmpoweredChannelDuration(unit, true);
                    bchannel = false;
                else
                    duration = UnitChannelDuration(unit);
                end
            else
                duration = UnitCastingDuration(unit);
            end
            castbar.duration_obj = duration;
            frameicon:SetTexture(texture);
            castbar:SetReverseFill(bchannel);
            castbar:SetMinMaxValues(duration:GetStartTime(), duration:GetEndTime());
            castbar.failstart = nil;
            castbar.castspellid = spellid;

            local color = {};
            color = configs.interruptcolor;
            castbar:SetStatusBarColor(color[1], color[2], color[3]);

            if C_CurveUtil and C_CurveUtil.EvaluateColorValueFromBoolean then
                local isimportant = C_Spell.IsSpellImportant(spellid);
                local alpha = C_CurveUtil.EvaluateColorValueFromBoolean(isimportant, 1, 0);
                castbar.important:SetAlpha(alpha);

                local alpha = C_CurveUtil.EvaluateColorValueFromBoolean(notInterruptible, 1, 0);
                castbar.notinterruptable:SetAlpha(alpha);
            end

            text:SetText(name);

            frameicon:Show();
            castbar:Show();

            if UnitExists(targettarget) then
                local _, Class = UnitClass(targettarget)
                local classcolor = nil;
                if Class then
                    classcolor = RAID_CLASS_COLORS[Class];
                end

                if classcolor then
                    targetname:SetTextColor(classcolor.r, classcolor.g, classcolor.b);
                else
                    targetname:SetTextColor(1, 1, 1);
                end

                targetname:SetText(UnitName(targettarget));
                targetname:Show();
            else
                targetname:SetText("");
                targetname:Hide();
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

local function on_castevent(self, event, ...)
    local interruptedby = nil;
    local complete = nil;
    local bdone = false;

    if (event == "UNIT_SPELLCAST_INTERRUPTED") then
        interruptedby = select(4, ...);
    elseif (event == "UNIT_SPELLCAST_CHANNEL_STOP") then
        interruptedby = select(4, ...);
        complete = interruptedby == nil;
        if (not complete) then
            event = "UNIT_SPELLCAST_INTERRUPTED";
        end
        bdone = true;
    elseif (event == "UNIT_SPELLCAST_EMPOWER_STOP") then
        _, _, _, complete, interruptedby = ...;        
        if (not issecretvalue(complete)) and (not complete) then
            event = "UNIT_SPELLCAST_INTERRUPTED";
        end
        bdone = true;
    end
    check_casting(self, event, interruptedby, bdone);
end

function ns.register_castevents(castbar, unit)
    if not castbar then
        return;
    end

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
    castbar.failstart = nil;
    castbar:SetScript("OnEvent", on_castevent);

    check_casting(castbar, "NOTHING");
end

function ns.update_castbar(castbar)
    local failstart = castbar.failstart;
    local current = GetTime();

    if failstart then
        if current - failstart > configs.faildonetime then
            hide_castbar(castbar);
        end
    else
        if castbar.duration_obj then
            castbar.time:SetText(string.format("%.1f/%.1f", castbar.duration_obj:GetRemainingDuration(0),
                castbar.duration_obj:GetTotalDuration(0)));
        end
        castbar:SetValue(current, Enum.StatusBarInterpolation.ExponentialEaseOut);
    end
end
