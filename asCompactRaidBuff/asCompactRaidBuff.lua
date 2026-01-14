local _, ns = ...;

local main_frame = CreateFrame("Frame", nil, UIParent);

local configs = {
    iconrate = 0.9,
}

ns.asraid = {};
ns.asparty = {};

local function is_party(unit)
    for i = 1, 4 do
        if unit and UnitIsUnit(unit, "party" .. i) then
            return true
        end
    end

    return false;
end

local function is_tank(unit)
    local assignedRole = UnitGroupRolesAssigned(unit);
    if assignedRole == "TANK" or assignedRole == "MAINTANK" then
        return true;
    end
    return false;
end

local function is_healer(unit)
    local assignedRole = UnitGroupRolesAssigned(unit);
    if assignedRole == "HEALER" then
        return true;
    end
    return false;
end



function ns.setup_frame(asframe)
    if not asframe.frame or asframe.frame:IsForbidden() then
        return
    end
    local frame = asframe.frame;
    local width, height = frame:GetSize();

    asframe.needtosetup = false;

    if frame.unit then
        asframe.unit = frame.unit;
    end

    if frame.displayedUnit then
        asframe.displayedUnit = frame.displayedUnit;
    else
        asframe.displayedUnit = frame.unit;
    end

    if (not UnitIsPlayer(asframe.unit)) and not is_party(asframe.unit) then
        return;
    end

    local istanker = is_tank(asframe.unit);
    local ishealer = is_healer(asframe.unit);

    local strata = "LOW";
    local framelevel = 4;

    if (not asframe.powerbar) then
        asframe.powerbar = CreateFrame("StatusBar", nil, frame.healthBar);
        asframe.powerbar:SetStatusBarTexture("RaidFrame-Hp-Fill");
        asframe.powerbar:GetStatusBarTexture():SetHorizTile(false);
        asframe.powerbar:SetMinMaxValues(0, 100);
        asframe.powerbar:SetValue(100);
        asframe.powerbar:SetPoint("BOTTOM", frame.healthBar, "BOTTOM", 0, 0);
        asframe.powerbar:SetFrameStrata(strata);
        asframe.powerbar:SetFrameLevel(framelevel);
        asframe.powerbar:Hide();
    end

    if asframe.powerbar then
        asframe.powerbar:SetWidth(width - 2);
        asframe.powerbar:SetHeight(ns.ACRB_HealerManaBarHeight);

        local powertype = UnitPowerType(asframe.unit);
        local powercolor = PowerBarColor[powertype]
        if powercolor then
            asframe.powerbar:SetStatusBarColor(powercolor.r, powercolor.g, powercolor.b)
        end

        asframe.ispowerupdate = false;
        asframe.ishealer = false
        if ishealer then
            if ns.options.BottomHealerManaBar then
                asframe.ispowerupdate = true;
                asframe.ishealer = true;
            end
        elseif istanker then
            if ns.options.BottomTankPowerBar and powertype > 0 then
                asframe.ispowerupdate = true;
            end
        end

        if asframe.ispowerupdate then
            asframe.powerbar:Show();
        else
            asframe.powerbar:Hide();
        end
    end

    if (not asframe.raidicon) then
        asframe.raidicon = frame:CreateTexture(nil, "ARTWORK");
        asframe.raidicon:SetTexture("Interface\\TargetingFrame\\UI-RaidTargetingIcons");
        asframe.raidicon:SetPoint("LEFT", frame.healthBar, "LEFT", 2, 0);
        asframe.raidicon:Hide();
    end

    if asframe.raidicon then
        asframe.raidicon:SetSize(height / 3 - 3, height / 3 - 3);
    end

    ns.init_cast(asframe, (height / 3 - 3));
    ns.update_features(asframe);

    asframe.callback = function()
        if asframe.frame:IsShown() then
            if asframe.needtosetup then
                ns.setup_frame(asframe);
            end
            ns.update_cast(asframe);
        elseif asframe.timer then
            asframe.timer:Cancel();
        end
    end

    if asframe.timer then
        asframe.timer:Cancel();
    end

    if asframe.frame:IsShown() then
        asframe.timer = C_Timer.NewTicker(ns.UpdateRate, asframe.callback);
    end
end

local framebuffer = {};

local function hook_func(frame)
    if frame and not frame:IsForbidden() and frame.GetName then
        local name = frame:GetName();
        if name then
            framebuffer[name] = frame;
        end
    end
end

local function change_button(button, notchangerate, changesize)
    local width = button:GetWidth();

    if changesize then
        width = width * ns.options.CenterDefensiveSizeRate;
    end

    local rate = configs.iconrate;
    
    if notchangerate then
        rate = 1;
    end

    if ns.options.ChangeIcon then
        button:SetSize(width, width * rate);

        if button.icon then
            button.icon:ClearAllPoints();
            button.icon:SetPoint("CENTER", 0, 0);
            button.icon:SetSize(width - 2, width * rate - 2);
            button.icon:SetTexCoord(.08, .92, .08, .92);
        end

        if not button.border then
            button.border = button:CreateTexture(nil, "BACKGROUND", "asCompactRaidBuffBorderTemplate");
            button.border:SetDrawLayer("BACKGROUND");
            button.border:SetColorTexture(0, 0, 0, 1);
            button.border:SetTexCoord(0.08, 0.08, 0.08, 0.92, 0.92, 0.08, 0.92, 0.92);
            button.border:Show();
        end
        button.border:ClearAllPoints();
        button.border:SetPoint("TOPLEFT", button, "TOPLEFT", 0, 0);
        button.border:SetPoint("BOTTOMRIGHT", button, "BOTTOMRIGHT", 0, 0);
    end

    if button.count then
        button.count:SetFont(STANDARD_TEXT_FONT, (width / 2) * ns.options.CooldownSizeRate, "OUTLINE");
        button.count:ClearAllPoints();
        button.count:SetPoint("CENTER", button, "BOTTOM", 0, 1);
        button.count:SetTextColor(0, 1, 0);
    end

    if button.cooldown and ns.options.ShowCooldown then
        button.cooldown:SetHideCountdownNumbers(false);

        for _, r in next, { button.cooldown:GetRegions() } do
            if r:GetObjectType() == "FontString" then
                r:SetFont(STANDARD_TEXT_FONT, (width / 2) * ns.options.CooldownSizeRate, "OUTLINE");
                r:ClearAllPoints();
                r:SetPoint("CENTER", button, "TOP", 0, 0);
                r:SetDrawLayer("OVERLAY");
                break;
            end
        end
    end
end

local function change_defaults(frame)
    if frame and not frame:IsForbidden() then
        if frame.buffFrames then
            for i = 1, #frame.buffFrames do
                change_button(frame.buffFrames[i]);
            end
        end
        if frame.debuffFrames then
            for i = 1, #frame.debuffFrames do
                change_button(frame.debuffFrames[i], true);
            end
        end
        if frame.CenterDefensiveBuff then
            change_button(frame.CenterDefensiveBuff, false ,true);
        end
    end
end



local max_y = 0;
local function update_all(frame)
    if frame and not frame:IsForbidden() and frame.GetName then
        local name = frame:GetName();

        if name and not (name == nil) then
            if string.find(name, "CompactRaidGroup") or string.find(name, "CompactRaidFrame") then
                if not (frame.unit and UnitIsPlayer(frame.unit)) and not is_party(frame.unit) then
                    return
                end
                change_defaults(frame);

                local x, y = frame:GetSize();

                if y > max_y then
                    max_y = y;
                end

                if y <= max_y / 2 then
                    ns.asraid[name] = nil;
                    return;
                end

                if ns.asraid[name] == nil then
                    ns.asraid[name] = CreateFrame("Frame");
                end

                ns.asraid[name].needtosetup = true;
                ns.asraid[name].israid = true;
                ns.asraid[name].frame = frame;
            elseif string.find(name, "CompactPartyFrameMember") then
                if not (frame.unit and UnitIsPlayer(frame.unit)) and not is_party(frame.unit) then
                    return
                end
                change_defaults(frame);

                if ns.asparty[name] == nil then
                    ns.asparty[name] = CreateFrame("Frame");
                end

                ns.asparty[name].needtosetup = true;
                ns.asparty[name].israid = false;
                ns.asparty[name].frame = frame;
            end
        end
    end
end

local function setup_frames()
    if (IsInRaid()) then
        for _, asframe in pairs(ns.asraid) do
            if asframe and asframe.frame and asframe.frame:IsShown() then
                ns.setup_frame(asframe);
            end
        end
    elseif (IsInGroup()) then
        for _, asframe in pairs(ns.asparty) do
            if asframe and asframe.frame and asframe.frame:IsShown() then
                ns.setup_frame(asframe);
            end
        end
    end
end

local function on_update()
    for _, newframe in pairs(framebuffer) do
        update_all(newframe);
    end

    framebuffer = {};
end


local timero;
local timero2;

local function init()
    if timero then
        timero:Cancel();
    end

    if timero2 then
        timero2:Cancel();
    end

    setup_frames();
    timero = C_Timer.NewTicker(ns.UpdateRate + 0.01, on_update);
    timero2 = C_Timer.NewTicker(ns.UpdateRate + 0.02, ns.update_featuresforall);
end

local bfirst = true;

local function on_event(self, event)
    if bfirst then
        ns.setup_option();
        init();
        bfirst = false;
    end

    if (event == "PLAYER_ENTERING_WORLD") then

    elseif (event == "TRAIT_CONFIG_UPDATED") or (event == "TRAIT_CONFIG_LIST_UPDATED") or (event == "ACTIVE_TALENT_GROUP_CHANGED") then
        init();
    elseif (event == "GROUP_ROSTER_UPDATE") or (event == "CVAR_UPDATE") or (event == "ROLE_CHANGED_INFORM") then
        init();
    elseif (event == "PLAYER_REGEN_ENABLED" or event == "PLAYER_REGEN_DISABLED") then
        init();
    end
end

main_frame:SetScript("OnEvent", on_event)
main_frame:RegisterEvent("GROUP_ROSTER_UPDATE");
main_frame:RegisterEvent("PLAYER_ENTERING_WORLD");
main_frame:RegisterEvent("ACTIVE_TALENT_GROUP_CHANGED");
main_frame:RegisterEvent("TRAIT_CONFIG_UPDATED");
main_frame:RegisterEvent("TRAIT_CONFIG_LIST_UPDATED");
main_frame:RegisterEvent("CVAR_UPDATE");
main_frame:RegisterEvent("ROLE_CHANGED_INFORM");
main_frame:RegisterEvent("PLAYER_REGEN_ENABLED");
main_frame:RegisterEvent("PLAYER_REGEN_DISABLED");


hooksecurefunc("DefaultCompactUnitFrameSetup", hook_func);
