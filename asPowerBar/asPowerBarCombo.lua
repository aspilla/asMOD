local _, ns        = ...;

local _, Class     = UnitClass("player")
ns.classcolor      = RAID_CLASS_COLORS[Class];
ns.maxcombo        = nil;
ns.maxcombopartial = nil;

function ns.setup_max_combo(max, maxpartial, frameonly)
    if issecretvalue(max) then
        return;
    end

    if max == 0 then
        return;
    end

    ns.maxcombo = max;
    ns.maxcombopartial = maxpartial;

    local width = (ns.config.width - (1 * (max - 1))) / max;
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

        if frameonly then
            combobar.bg:SetAlpha(0.3);
        else
            combobar.bg:SetAlpha(1);
        end
    end
end

function ns.show_combo(combo, partial)
    local combobars = ns.combobars;
    local max = ns.maxcombo;
    if partial then
        ns.combotext:SetText(partial);

        local pmax = ns.maxcombopartial;
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


    if ns.brogue then
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

function ns.update_combo()
    if ns.power_level == nil then
        return;
    end

    local power = UnitPower("player", ns.power_level);
    local partial = nil;

    if ns.bupdate_partial_power then
        partial = UnitPower("player", ns.power_level, true);
    end

    if ns.power_level == Enum.PowerType.Essence then
        local peace, interrupted = GetPowerRegenForPowerType(Enum.PowerType.Essence)
        if (peace == nil or peace == 0) then
            peace = 0.2;
        end
        local cooldownDuration = 1 / peace;
        local currtime = GetTime();
        local maxpartial = ns.maxcombopartial;
        local max = ns.maxcombo;

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
