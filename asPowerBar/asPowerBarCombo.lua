local _, ns  = ...;

local gvalue = {
    maxcombo   = nil,
    maxpartial = nil,
    bpartial   = false,
    powerlevel = nil,
    brogue     = false,
}

function ns.setup_max_combo(max, maxpartial)
    if issecretvalue(max) then
        return;
    end

    if max == 0 then
        return;
    end

    gvalue.maxcombo = max;
    gvalue.maxpartial = maxpartial;

    local width = (ns.configs.width - (1 * (max - 1))) / max;
    local combobars = ns.combobars;

    ns.chargebar:SetWidth(width)

    for i = 1, 20 do
        combobars[i]:Hide();
    end

    for i = 1, max do
        local combobar = combobars[i];
        combobar:SetWidth(width)


        if max == 10 then
            if i == max then
                combobar:SetStatusBarColor(1, 0, 0);
            elseif i >= 5 then
                combobar:SetStatusBarColor(0, 1, 0);
            else
                combobar:SetStatusBarColor(ns.classcolor.r, ns.classcolor.g, ns.classcolor.b);
            end
        else
            if max > 5 and i == max then
                combobar:SetStatusBarColor(1, 0, 0);
            elseif max > 5 and i >= 5 then
                combobar:SetStatusBarColor(0, 1, 0);
            else
                combobar:SetStatusBarColor(ns.classcolor.r, ns.classcolor.g, ns.classcolor.b);
            end
        end


        if maxpartial then
            combobar:SetMinMaxValues(0, maxpartial);
        else
            combobar:SetMinMaxValues(0, 1);
        end
        combobar:SetValue(0);
        combobar:Show();
    end
end

function ns.show_combo(combo, partial)
    local combobars = ns.combobars;
    local max = gvalue.maxcombo;
    if partial then
        ns.combotext:SetText(partial);

        local pmax = gvalue.maxpartial;
        combo = math.floor(partial / pmax);
        local pvalue = partial % pmax;

        for i = 1, max do
            local combobar = combobars[i];
            if pvalue > 0 and i == (combo + 1) then
                combobar:SetValue(pvalue, Enum.StatusBarInterpolation.ExponentialEaseOut);
                combobar:SetStatusBarColor(1, 1, 1);
            elseif i <= combo then
                combobar:SetValue(pmax);
                combobar:SetStatusBarColor(ns.classcolor.r, ns.classcolor.g, ns.classcolor.b);
            else
                combobar:SetValue(0);
                combobar:SetStatusBarColor(ns.classcolor.r, ns.classcolor.g, ns.classcolor.b);
            end
        end
    else
        ns.combotext:SetText(combo);
        for i = 1, max do
            local combobar = combobars[i];
            if i <= combo then
                combobar:SetValue(1);
            else
                combobar:SetValue(0);
            end
        end
    end


    if gvalue.brogue then
        local chargedPowerPoints = GetUnitChargedPowerPoints("player");
        for i = 1, max do
            local combobar = combobars[i];
            local isCharged = chargedPowerPoints and tContains(chargedPowerPoints, i) or false;
            if isCharged then
                ns.lib.PixelGlow_Start(combobar);
            else
                ns.lib.PixelGlow_Stop(combobar);
            end
        end
    end
end

local prevpower = nil;
local prevstart = nil;

local function update_combo()
    if gvalue.powerlevel == nil then
        return;
    end

    local power = UnitPower("player", gvalue.powerlevel);
    local partial = nil;

    if gvalue.bpartial then
        partial = UnitPower("player", gvalue.powerlevel, true);
    end

    if gvalue.powerlevel == Enum.PowerType.Essence then
        local peace, interrupted = GetPowerRegenForPowerType(Enum.PowerType.Essence)
        if (peace == nil or peace == 0) then
            peace = 0.2;
        end
        local cooldownDuration = 1 / peace;
        local currtime = GetTime();
        local maxpartial = gvalue.maxpartial;
        local max = gvalue.maxcombo;

        if power ~= prevpower then
            prevpower = power;
            prevstart = currtime;
        end

        local remain = 0;

        if prevstart and prevpower < max then
            remain = math.ceil(maxpartial * (currtime - prevstart) / cooldownDuration);
            if remain >= maxpartial then
                remain = maxpartial - 1;
            end
        end

        partial = prevpower * maxpartial + remain;
    end
    ns.show_combo(power, partial);
end

local function on_event(self, event, arg1)
    update_combo();
end

local main_frame = CreateFrame("Frame");
local timer = nil;

main_frame:SetScript("OnEvent", on_event);

function ns.setup_combo(powerlevel, bpartial, brogue)
    main_frame:UnregisterEvent("UNIT_POWER_UPDATE")
    main_frame:UnregisterEvent("UNIT_DISPLAYPOWER");

    if timer then
        timer:Cancel();
    end

    if powerlevel and ns.options.ShowClassResource then
        gvalue.bpartial = bpartial;
        gvalue.powerlevel = powerlevel;
        gvalue.brogue = brogue;
        local max = UnitPowerMax("player", gvalue.powerlevel);
        local maxpartial = nil;
        if gvalue.bpartial then
            maxpartial = UnitPowerDisplayMod(gvalue.powerlevel)
        elseif gvalue.powerlevel == Enum.PowerType.Essence then
            maxpartial = 10;
        end

        ns.setup_max_combo(max, maxpartial);
        main_frame:RegisterEvent("UNIT_POWER_UPDATE");
        main_frame:RegisterEvent("UNIT_DISPLAYPOWER");
        timer = C_Timer.NewTicker(0.2, update_combo);
    end
end
