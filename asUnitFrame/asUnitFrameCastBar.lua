local _, ns = ...;
local CONFIG_NOT_INTERRUPTIBLE_COLOR = { 0.9, 0.9, 0.9 };                 --차단 불가시 (내가 아닐때) 색상 (r, g, b)
local CONFIG_NOT_INTERRUPTIBLE_COLOR_TARGET = { 153 / 255, 0, 76 / 255 }; --차단 불가시 (내가 타겟일때) 색상 (r, g, b)
local CONFIG_INTERRUPTIBLE_COLOR = { 204 / 255, 255 / 255, 153 / 255 };   --차단 가능(내가 타겟이 아닐때)시 색상 (r, g, b)
local CONFIG_INTERRUPTIBLE_COLOR_TARGET = { 76 / 255, 153 / 255, 0 };     --차단 가능(내가 타겟일 때)시 색상 (r, g, b)
local CONFIG_FAILED_COLOR = { 1, 0, 0 };                                  --cast fail


local function hideCastBar(castBar)
    local targetname = castBar.targetname;
    castBar:SetValue(0);
    castBar:Hide();
    ns.lib.PixelGlow_Stop(castBar);
    castBar.isAlert = false;
    castBar.start = 0;
    targetname:SetText("");
    targetname:Hide();
    castBar.failstart = nil;
end

local function get_typeofcast(unit)
    local nameplate = C_NamePlate.GetNamePlateForUnit(unit, issecure())
    if nameplate and nameplate.UnitFrame and nameplate.UnitFrame.castBar then
        return nameplate.UnitFrame.castBar.barType;
    end
    return nil;
end


local function checkCasting(castBar, event)
    local unit         = castBar.unit;
    local frameIcon    = castBar.button.icon;
    local text         = castBar.name;
    local time         = castBar.time;
    local targetname   = castBar.targetname;
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
            castBar:SetMinMaxValues(0, 100);
            castBar:SetValue(100);
            local failtext = "Interrupted"
            local color = CONFIG_FAILED_COLOR;
            time:SetText(failtext);
            castBar:SetStatusBarColor(color[1], color[2], color[3]);
            castBar.failstart = currtime;
            castBar:Show();
        elseif name then
            local current = GetTime();
            frameIcon:SetTexture(texture);
            castBar:SetReverseFill(bchannel);
            castBar:SetMinMaxValues(start, endTime)
            castBar.failstart = nil;

            local color = {};

            color = CONFIG_INTERRUPTIBLE_COLOR;

            color = CONFIG_INTERRUPTIBLE_COLOR;
            local type = get_typeofcast(unit);

            if type and type == "uninterruptable" then
                color = CONFIG_NOT_INTERRUPTIBLE_COLOR;
            end

            castBar:SetStatusBarColor(color[1], color[2], color[3]);

            text:SetText(name);

            frameIcon:Show();
            castBar:Show();

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
            if castBar.failstart == nil then
                hideCastBar(castBar);
            end
        end
    else
        hideCastBar(castBar);
    end
end

function ns.registerCastBarEvents(frame, unit)
    if not frame then
        return;
    end

    frame.unit = unit;
    frame:RegisterUnitEvent("UNIT_SPELLCAST_INTERRUPTED", unit);
    frame:RegisterUnitEvent("UNIT_SPELLCAST_DELAYED", unit);
    frame:RegisterUnitEvent("UNIT_SPELLCAST_CHANNEL_START", unit);
    frame:RegisterUnitEvent("UNIT_SPELLCAST_CHANNEL_UPDATE", unit);
    frame:RegisterUnitEvent("UNIT_SPELLCAST_CHANNEL_STOP", unit);
    frame:RegisterUnitEvent("UNIT_SPELLCAST_EMPOWER_START", unit);
    frame:RegisterUnitEvent("UNIT_SPELLCAST_EMPOWER_UPDATE", unit);
    frame:RegisterUnitEvent("UNIT_SPELLCAST_EMPOWER_STOP", unit);
    frame:RegisterUnitEvent("UNIT_SPELLCAST_INTERRUPTIBLE", unit);
    frame:RegisterUnitEvent("UNIT_SPELLCAST_NOT_INTERRUPTIBLE", unit);
    frame:RegisterUnitEvent("UNIT_SPELLCAST_START", unit);
    frame:RegisterUnitEvent("UNIT_SPELLCAST_STOP", unit);
    frame:RegisterUnitEvent("UNIT_SPELLCAST_FAILED", unit);
    frame:RegisterUnitEvent("UNIT_TARGET", unit);
    frame.failstart = nil;

    checkCasting(frame, "NOTHING");
end

function ns.onCastBarEvent(self, event, ...)
    checkCasting(self, event);
end

function ns.updateCastBar(castBar)
    local start = castBar.start;
    local duration = castBar.duration;
    local failstart = castBar.failstart;
    local current = GetTime();

    if failstart then
        if current - failstart > 0.5 then
            hideCastBar(castBar);
        end
        --[[
    elseif start > 0 and start + duration >= current then
        local bchannel = castBar.bchannel;
        local time = castBar.time;
        if bchannel then
            castBar:SetValue((start + duration - current));
            time:SetText(format("%.1f/%.1f", max((start + duration - current), 0), max(duration, 0)));
        else
            castBar:SetValue((current - start));
            time:SetText(format("%.1f/%.1f", max((current - start), 0), max(duration, 0)));
        end
        ]]
    else
        castBar.time:SetText("");
        castBar:SetValue(current * 1000, Enum.StatusBarInterpolation.ExponentialEaseOut);
    end
end
