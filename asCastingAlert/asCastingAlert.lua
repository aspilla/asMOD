local _, ns = ...;

local configs = {
    updaterate = 0.1,
    maxshow = 10,
    fontsize = 18,
    size = 35,
    xpoint = 0,
    ypoint = -30,
    targetedvoice = "Interface\\AddOns\\asCastingAlert\\Targeted.mp3",
    baseframelevel = 1000,
    alpha = 1,
};

local function comparator(a, b)
    if a.level ~= b.level then
        return a.level > b.level;
    end
end

local main_frame = CreateFrame("Frame", nil, UIParent);
local showtable = TableUtil.CreatePriorityTable(comparator, TableUtil.Constants.AssociativePriorityTable);
local castingunits = {};
ns.istank = false;
ns.casts = {};

local function check_casting(unit)
    local istarget = UnitIsUnit(unit, "target");

    if not (not ns.options.ShowTarget and istarget) then
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


local function show_castings()
    local currshow = 1;

    local function scan_table(unit, castinfo)
        local duration = castinfo.duration;
        local texture = castinfo.texture;
        local spellid = castinfo.spellid;
        local button = ns.casts[currshow];

        button.icon:SetTexture(texture);
        button.cooldown:SetCooldownFromDurationObject(duration);

        local isimportant = C_Spell.IsSpellImportant(spellid);
        local alpha = C_CurveUtil.EvaluateColorValueFromBoolean(isimportant, 1, 0);
        button.important:SetAlpha(alpha);

        local istargeted = UnitIsUnit(unit .. "target", "player");
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
        ns.casts[i]:Hide();
    end
end

local function on_update()

    if not C_CurveUtil.EvaluateColorValueFromBoolean then
        return;
    end

    showtable:Clear();

    for unit, _ in pairs(castingunits) do
        local bcasting = check_casting(unit);

        if not bcasting then
            castingunits[unit] = nil;
        end
    end

    show_castings();
end


local function check_tank()
    local assignedRole = UnitGroupRolesAssigned("player");
    if assignedRole == "TANK" or assignedRole == "MAINTANK" then
        ns.istank = true;
    else
        ns.istank = false;
    end
end

local bfirst = true;
local function on_event(self, event, unit)
    if bfirst then
        ns.setup_option();
        bfirst = false;
    end

    if (event == "ACTIVE_TALENT_GROUP_CHANGED" or event == "PLAYER_ENTERING_WORLD" or event == "ROLE_CHANGED_INFORM") then
        check_tank();
    else
        if unit and UnitCanAttack("player", unit) and UnitAffectingCombat(unit) and UnitClassification(unit) ~= "minus" and string.find(unit, "nameplate") then
            castingunits[unit] = true;
        end
    end
end

local function init()
    for i = 1, configs.maxshow do
        ns.casts[i] = CreateFrame("Button", nil, main_frame, "asCastingAlertTemplate");
        local frame = ns.casts[i];
        frame:SetFrameLevel(configs.baseframelevel - i)
        frame.cooldown:SetDrawSwipe(true);


        for _, r in next, { frame.cooldown:GetRegions() } do
            if r:GetObjectType() == "FontString" then
                r:SetFont(STANDARD_TEXT_FONT, configs.fontsize, "OUTLINE");
                r:SetDrawLayer("OVERLAY");
                r:SetTextColor(0, 1, 0);
                break;
            end
        end

        frame.icon:SetTexCoord(.08, .92, .16, .84);
        frame.border:SetTexCoord(0.08, 0.08, 0.08, 0.92, 0.92, 0.08, 0.92, 0.92);
        frame.border:SetVertexColor(0, 0, 0);
        frame.border:Show();
        frame.important:SetTexCoord(0.08, 0.08, 0.08, 0.92, 0.92, 0.08, 0.92, 0.92);
        frame.important:SetVertexColor(1, 1, 1);
        frame.important:SetAlpha(0);
        frame.important:Show();
        frame:SetPoint("CENTER", main_frame, "CENTER", 0, 0);
        frame:EnableMouse(false);
        frame:SetAlpha(0);
        frame:SetSize(configs.size, configs.size * 0.9)
        frame:Show();
    end

    main_frame:SetScript("OnEvent", on_event);
    main_frame:RegisterEvent("UNIT_SPELLCAST_START");
    main_frame:RegisterEvent("UNIT_SPELLCAST_CHANNEL_START");
    main_frame:RegisterEvent("NAME_PLATE_UNIT_ADDED");
    main_frame:RegisterEvent("PLAYER_ENTERING_WORLD");
    main_frame:RegisterEvent("ACTIVE_TALENT_GROUP_CHANGED");
    main_frame:RegisterEvent("ROLE_CHANGED_INFORM");
    main_frame:SetPoint("CENTER", UIParent, "CENTER", configs.xpoint, configs.ypoint);
    main_frame:SetAlpha(configs.alpha);
    main_frame:SetSize(1, 1);
    main_frame:EnableMouse(false);
    main_frame:Show();

    local bloaded = C_AddOns.LoadAddOn("asMOD");

    if bloaded and ASMODOBJ.load_position then
        ASMODOBJ.load_position(main_frame, "asCastingAlert");
    end

    C_Timer.NewTicker(configs.updaterate, on_update);
end
init();