local _, ns = ...;

local configs = {
    maxshow = 10,
    updaterate = 0.2,
};

local function comparator(a, b)
    return a.level > b.level;
end

local main_frame = CreateFrame("Frame", nil, UIParent);
local showtable = TableUtil.CreatePriorityTable(comparator, TableUtil.Constants.AssociativePriorityTable);
local castingunits = {};

local function check_casting(unit)
    local istarget = UnitIsUnit(unit, "target");

    do
        local duration = nil;
        local name, _, texture, starttime, endtime, _, _, notInterruptible, spellid = UnitCastingInfo(unit);
        if not name then
            name, _, texture, starttime, endtime, _, notInterruptible, spellid = UnitChannelInfo(unit);
            duration = UnitChannelDuration(unit);
        else
            duration = UnitCastingDuration(unit);
        end

        if name then
            local level = UnitLevel(unit);

            if level < 0 then
                level = 1000;
            end

            if istarget then
                level = 0;
            end

            showtable[unit] = { level = level, duration = duration, texture = texture, spellid = spellid };
            return true;
        end
    end

    return false;
end


local function show_castings(asframe)
    local currshow = 1;
    local destunit = asframe.displayedUnit;

    local function scan_table(castunit, castinfo)
        local duration = castinfo.duration;
        local texture = castinfo.texture;
        local spellid = castinfo.spellid;
        local button = asframe.casts[currshow];

        button.icon:SetTexture(texture);
        button.cooldown:SetCooldownFromDurationObject(duration);

        local isimportant = C_Spell.IsSpellImportant(spellid);
        local alpha = C_CurveUtil.EvaluateColorValueFromBoolean(isimportant, 1, 0);
        button.important:SetAlpha(alpha);

        local istargeted = UnitIsUnit(castunit .. "target", destunit);
        alpha = C_CurveUtil.EvaluateColorValueFromBoolean(istargeted, 1, 0);
        button:SetAlpha(alpha);

        button:Show();
        currshow = currshow + 1;

        if currshow > configs.maxshow then
            return true;
        end
        return false;
    end

    showtable:Iterate(scan_table);

    for i = currshow, configs.maxshow do
        asframe.casts[i]:Hide();
    end
end

function ns.update_cast(asframe)
    if not C_CurveUtil.EvaluateColorValueFromBoolean or not ns.options.ShowCasting then
        return;
    end

    if asframe.israid and not ns.options.ShowCastingRaid then
        return;
    end

    show_castings(asframe);
end

function ns.init_cast(asframe, size)
    if asframe.casts == nil then
        asframe.casts = {};
        for i = 1, configs.maxshow do
            asframe.casts[i] = CreateFrame("Button", nil, asframe.frame, "asCompactRaidBuffCastTemplate");
            local frame = asframe.casts[i];
            local baselevel = asframe:GetFrameLevel() + 100
            frame:SetFrameLevel(baselevel - i)
            frame.cooldown:SetDrawSwipe(true);

            frame.icon:SetTexCoord(.08, .92, .16, .84);
            frame.border:SetTexCoord(0.08, 0.08, 0.08, 0.92, 0.92, 0.08, 0.92, 0.92);
            frame.border:SetVertexColor(0, 0, 0);
            frame.border:Show();
            frame.important:SetTexCoord(0.08, 0.08, 0.08, 0.92, 0.92, 0.08, 0.92, 0.92);
            frame.important:SetVertexColor(1, 1, 1);
            frame.important:SetAlpha(0);
            frame.important:Show();
            frame:SetPoint("TOP", asframe.frame, "TOP", 0, -3);
            frame:EnableMouse(false);
            frame:SetAlpha(0);
            frame:Show();
        end
    end

    for i = 1, configs.maxshow do
        local frame = asframe.casts[i];

        for _, r in next, { frame.cooldown:GetRegions() } do
            if r:GetObjectType() == "FontString" then
                r:SetFont(STANDARD_TEXT_FONT, size - 3, "OUTLINE");
                r:SetDrawLayer("OVERLAY");
                r:SetTextColor(0, 1, 0);
                break;
            end
        end

        frame:SetSize(size, size * 0.9)
    end
end

local function on_update()
    showtable:Clear();

    for unit, _ in pairs(castingunits) do
        local bcasting = check_casting(unit);

        if not bcasting then
            castingunits[unit] = nil;
        end
    end
end

local function on_event(self, event, unit)
    if unit and UnitCanAttack("player", unit) and UnitAffectingCombat(unit) and UnitClassification(unit) ~= "minus" and string.find(unit, "nameplate") then
        castingunits[unit] = true;
    end
end

C_Timer.NewTicker(configs.updaterate, on_update);
main_frame:SetScript("OnEvent", on_event);
main_frame:RegisterEvent("UNIT_SPELLCAST_START");
main_frame:RegisterEvent("UNIT_SPELLCAST_CHANNEL_START");
main_frame:RegisterEvent("NAME_PLATE_UNIT_ADDED");
