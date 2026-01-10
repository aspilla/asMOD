local _, ns = ...;

local configs = {
    updaterate = 0.1,
    maxshow = 3,
    fontsize = 18,
    xpoint = 0,
    ypoint = -80,
    targetedvoice = "Interface\\AddOns\\asCastingAlert\\Targeted.mp3",
};

local main_frame = CreateFrame("Frame", nil, UIParent);
local showlist = {};
local castingunits = {};
ns.istank = false;
ns.casts = {};

local function check_casting(unit)
    if UnitCanAttack("player", unit) and not (not ns.options.ShowTarget and UnitIsUnit(unit, "target")) then
        local name, _, texture, starttime, endtime, _, _, notInterruptible, spellid = UnitCastingInfo(unit);
        if not name then
            name, _, texture, starttime, endtime, _, notInterruptible, spellid = UnitChannelInfo(unit);
        end

        if name then
            tinsert(showlist, { starttime = starttime, endtime = endtime, texture = texture, spellid = spellid });
            return false;
        end
    end

    return true;
end

local prevcount = 0;

local function show_castings()
    local currshow = 1;
    local soundcount = 0;


    for _, cast in pairs(showlist) do
        local starttime = cast.starttime;
        local endtime = cast.endtime;
        local texture = cast.texture;
        local spellid = cast.spellid;

        ns.casts[currshow]:SetText("|T" .. texture .. ":0|t");
        ns.casts[currshow]:SetTextColor(1, 1, 1);
        ns.casts[currshow]:Show();
        currshow = currshow + 1;

        if currshow > configs.maxshow then
            break;
        end
    end

    if not ns.options.PlaySoundTank and ns.istank then
        soundcount = 0;
        prevcount  = 0;
    end

    if ns.options.PlaySoundGroupOnly and not IsInGroup() then
        soundcount = 0;
        prevcount = 0;
    end

    if prevcount ~= soundcount then
        if prevcount == 0 and ns.options.PlaySound then
            PlaySoundFile(configs.targetedvoice, "MASTER");
        end

        prevcount = soundcount;
    end

    for i = currshow, configs.maxshow do
        ns.casts[i]:Hide();
    end
end

local function on_update()
    showlist = {};

    if (MAX_BOSS_FRAMES) then
        for i = 1, MAX_BOSS_FRAMES do
            local unit = "boss" .. i;
            if UnitExists(unit) then
                castingunits[unit] = true;
            end
        end
    end

    for unit, _ in pairs(castingunits) do
        local notcasting = check_casting(unit);

        if notcasting then
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
local function on_event(self, event, arg1, arg2, arg3, arg4)
    if bfirst then
        ns.setup_option();
        bfirst = false;
    end

    if (event == "ACTIVE_TALENT_GROUP_CHANGED" or event == "PLAYER_ENTERING_WORLD" or event == "ROLE_CHANGED_INFORM") then
        check_tank();
    else
        local unit = arg1;
        if unit and UnitCanAttack("player", unit) and UnitAffectingCombat(unit) and string.find(unit, "nameplate") then
            local isboss = false;
            if (MAX_BOSS_FRAMES) then
                for i = 1, MAX_BOSS_FRAMES do
                    if UnitIsUnit(unit, "boss" .. i) then
                        isboss = true;
                        break;
                    end
                end
            end

            if not isboss then
                castingunits[unit] = true;
            end
        end
    end
end

local function init()
    for i = 1, configs.maxshow do
        ns.casts[i] = main_frame:CreateFontString(nil, "OVERLAY");
        ns.casts[i]:SetFont(STANDARD_TEXT_FONT, configs.fontsize, "THICKOUTLINE")

        if i == 1 then
            ns.casts[i]:SetPoint("CENTER", UIParent, "CENTER", configs.xpoint, configs.ypoint);
        else
            ns.casts[i]:SetPoint("BOTTOM", ns.casts[i - 1], "TOP", 0, 3);
        end

        ns.casts[i]:EnableMouse(false);
        ns.casts[i]:SetMouseMotionEnabled(true);
        ns.casts[i]:Hide();
    end
    local bloaded = C_AddOns.LoadAddOn("asMOD");

    if bloaded and ASMODOBJ.load_position then
        ASMODOBJ.load_position(ns.casts[1], "asCastingAlert");
    end

    main_frame:SetScript("OnEvent", on_event);
    main_frame:RegisterEvent("UNIT_SPELLCAST_START");
    main_frame:RegisterEvent("UNIT_SPELLCAST_CHANNEL_START");
    main_frame:RegisterEvent("NAME_PLATE_UNIT_ADDED");
    main_frame:RegisterEvent("PLAYER_ENTERING_WORLD");
    main_frame:RegisterEvent("ACTIVE_TALENT_GROUP_CHANGED");
    main_frame:RegisterEvent("ROLE_CHANGED_INFORM");

    C_Timer.NewTicker(configs.updaterate, on_update);
end
init();
