local _, ns = ...;

local configs = {
    interruptcolor = { 204 / 255, 255 / 255, 153 / 255 },
    failcolor = { 1, 0, 0 },
};


local function hide_castbar(castbar)
    local targetname = castbar.targetname;
    castbar:SetValue(0);
    castbar:Hide();    
    castbar.isAlert = false;
    targetname:SetText("");
    targetname:Hide();
    castbar.failstart = nil;
    castbar.duration_obj = nil;
    castbar.notinterruptable:SetAlpha(0);
    castbar.important:SetAlpha(0);
end


local function check_casting(castbar, event)
    local unit         = castbar.unit;
    local frameIcon    = castbar.button.icon;
    local text         = castbar.name;
    local time         = castbar.time;
    local targetname   = castbar.targetname;
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
            local color = configs.failcolor;
            time:SetText(failtext);
            castbar:SetStatusBarColor(color[1], color[2], color[3]);
            castbar.failstart = currtime;
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
            frameIcon:SetTexture(texture);
            castbar:SetReverseFill(bchannel);
            castbar:SetMinMaxValues(start, endTime)
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

            frameIcon:Show();
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
    check_casting(self, event);
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
