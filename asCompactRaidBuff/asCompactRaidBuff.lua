local _, ns = ...;

local main_frame = CreateFrame("Frame", nil, UIParent);

ns.asraid = {};
ns.asparty = {};

local function update_power_raidicon()
    if IsInRaid() then
        for _, asframe in pairs(ns.asraid) do
            if asframe and asframe.frame and asframe.frame:IsShown() then
                ns.update_power(asframe);
                ns.update_raidicon(asframe);
            end
        end
    else
        for _, asframe in pairs(ns.asparty) do
            if asframe and asframe.frame and asframe.frame:IsShown() then
                ns.update_power(asframe);
                ns.update_raidicon(asframe);
            end
        end
    end
end

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


local max_y = 0;
-- Setup
function ns.setup_frame(asframe)
    if not asframe.frame or asframe.frame:IsForbidden() then
        return
    end
    local frame = asframe.frame;
    local x, y = frame:GetSize();

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

    asframe.isTank = is_tank(asframe.unit);
    asframe.isPlayer = UnitIsUnit(asframe.unit, "player");



    local strata = "LOW";
    local framelevel = 4;
    local fontsize = 10;


    if (not asframe.asManabar) then
        asframe.asManabar = CreateFrame("StatusBar", nil, frame.healthBar);
        asframe.asManabar:SetStatusBarTexture("Interface\\Addons\\asCompactRaidBuff\\UI-StatusBar");
        asframe.asManabar:GetStatusBarTexture():SetHorizTile(false);
        asframe.asManabar:SetMinMaxValues(0, 100);
        asframe.asManabar:SetValue(100);
        asframe.asManabar:SetPoint("BOTTOM", frame.healthBar, "BOTTOM", 0, 0);
        asframe.asManabar:SetFrameStrata(strata);
        asframe.asManabar:SetFrameLevel(framelevel);
        asframe.asManabar:Hide();
    end

    if asframe.asManabar then
        asframe.asManabar:SetWidth(x - 2);
        asframe.asManabar:SetHeight(ns.ACRB_HealerManaBarHeight);
    end

    if (not asframe.raidicon) then
        asframe.raidicon = frame:CreateTexture(nil, "ARTWORK");
        asframe.raidicon:SetTexture("Interface\\TargetingFrame\\UI-RaidTargetingIcons");
        asframe.raidicon:SetSize(fontsize, fontsize);
        asframe.raidicon:SetPoint("LEFT", frame.healthBar, "LEFT", 2, 0);
        asframe.raidicon:Hide();
    end

    --마나는 unit으로만

    local role = UnitGroupRolesAssigned(asframe.unit);
    local manaBarUsedHeight = 0;

    if asframe.frame.powerBar and asframe.frame.powerBar:IsShown() then
        manaBarUsedHeight = 8;
    end

    asframe.checkManaType = nil;


    if manaBarUsedHeight == 0 then
        if role then
            if (role == "HEALER") and ns.options.BottomHealerManaBar then
                asframe.checkManaType = Enum.PowerType.Mana;
            elseif (role == "TANK") and ns.options.BottomTankPowerBar then
                local localizedClass, englishClass = UnitClass(asframe.unit);

                if englishClass == "WARRIOR" or englishClass == "DRUID" then
                    asframe.checkManaType = Enum.PowerType.Rage;
                elseif englishClass == "DEATHKNIGHT" then
                    asframe.checkManaType = Enum.PowerType.RunicPower;
                elseif englishClass == "DEMONHUNTER" then
                    asframe.checkManaType = Enum.PowerType.Fury;
                end
            end
        end
    end

    if asframe.checkManaType then
        asframe.asManabar:SetMinMaxValues(0, UnitPowerMax(asframe.unit, asframe.checkManaType));
        asframe.asManabar:SetValue(UnitPower(asframe.unit, asframe.checkManaType));

        local info = PowerBarColor[asframe.checkManaType];
        if (info) then
            local r, g, b = info.r, info.g, info.b;
            asframe.asManabar:SetStatusBarColor(r, g, b);
        end

        asframe.asManabar:Show();
    else
        asframe.asManabar:Hide();
    end

    ns.update_power(asframe);
    ns.update_raidicon(asframe);



    asframe.callback = function()
        if asframe.frame:IsShown() then
            if asframe.needtosetup then
                ns.setup_frame(asframe);
            end
        elseif asframe.timer then
            asframe:UnregisterEvent("UNIT_AURA");
            asframe.timer:Cancel();
        end
    end

    if asframe.timer then
        asframe.timer:Cancel();
    end

    local updateRate = ns.UpdateRate * 4;

    if asframe.frame:IsShown() then
        asframe.timer = C_Timer.NewTicker(updateRate, asframe.callback);
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

local function update_all(frame)
    if frame and not frame:IsForbidden() and frame.GetName then
        local name = frame:GetName();

        if name and not (name == nil) then
            if string.find(name, "CompactRaidGroup") or string.find(name, "CompactRaidFrame") then
                if not (frame.unit and UnitIsPlayer(frame.unit)) and not is_party(frame.unit) then
                    return
                end

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
                ns.asraid[name].frame = frame;
            elseif string.find(name, "CompactPartyFrameMember") then
                if not (frame.unit and UnitIsPlayer(frame.unit)) and not is_party(frame.unit) then
                    return
                end

                if ns.asparty[name] == nil then
                    ns.asparty[name] = CreateFrame("Frame");
                end

                ns.asparty[name].needtosetup = true;
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

local function on_update_feature()
    update_power_raidicon();
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
    timero2 = C_Timer.NewTicker(ns.UpdateRate + 0.02, on_update_feature);
end

local bfirst = true;

local function on_event(self, event)
    if bfirst then
        ns.SetupOptionPanels();
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
