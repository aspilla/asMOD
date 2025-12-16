local _, ns      = ...;

local _, Class   = UnitClass("player")
local classcolor = RAID_CLASS_COLORS[Class];
local prevmax    = nil;

function ns.setup_max_combo(max, maxpartial)
    if issecretvalue(max) then
        return;
    end

    if max == 0 then
        return;
    end

    prevmax = max;

    local width = (ns.config.width - (1 * (max - 1))) / max;
    local combobars = ns.combobars;
    ns.combocountbar:Hide();
    ns.combotext:Hide();

    for i = 1, 20 do
        combobars[i]:Hide();
    end

    for i = 1, max do
        combobars[i]:SetWidth(width)

        if max == 10 then
            if i == max then
                combobars[i]:SetStatusBarColor(1, 0, 0);
            elseif i >= 5 then
                combobars[i]:SetStatusBarColor(0, 1, 0);
            else
                combobars[i]:SetStatusBarColor(classcolor.r, classcolor.g, classcolor.b);
            end
        else
            if max > 5 and i == max then
                combobars[i]:SetStatusBarColor(1, 0, 0);
            elseif max > 5 and i > 5 then
                combobars[i]:SetStatusBarColor(0, 1, 0);
            else
                combobars[i]:SetStatusBarColor(classcolor.r, classcolor.g, classcolor.b);
            end
        end


        if maxpartial then
            combobars[i]:SetMinMaxValues(0, maxpartial);
        else
            combobars[i]:SetMinMaxValues(0, 1);
        end
        combobars[i]:SetValue(0);
        combobars[i]:Show();
    end
end

function ns.show_combo(combo, max, partial)
    local combobars = ns.combobars;
    if partial then
        ns.combotext:SetText(partial);

        local _, pmax = combobars[1]:GetMinMaxValues();
        combo = math.floor(partial / pmax);
        local pvalue = partial % pmax;

        for i = 1, max do
            if pvalue > 0 and i == (combo + 1) then
                combobars[i]:SetValue(pvalue);
                combobars[i]:SetStatusBarColor(1, 1, 1);
            elseif i <= combo then
                combobars[i]:SetValue(pmax);
                combobars[i]:SetStatusBarColor(classcolor.r, classcolor.g, classcolor.b);
            else
                combobars[i]:SetValue(0);
                combobars[i]:SetStatusBarColor(classcolor.r, classcolor.g, classcolor.b);
            end
        end
    else
        ns.combotext:SetText(combo);
        for i = 1, max do
            if i <= combo then
                combobars[i]:SetValue(1);
            else
                combobars[i]:SetValue(0);
            end
        end
    end


    if ns.brogue then
        local chargedPowerPoints = GetUnitChargedPowerPoints("player");
        for i = 1, max do
            local isCharged = chargedPowerPoints and tContains(chargedPowerPoints, i) or false;
            if isCharged then
                ns.lib.PixelGlow_Start(combobars[i]);
            else
                ns.lib.PixelGlow_Stop(combobars[i]);
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
    local max = UnitPowerMax("player", ns.power_level);

    local maxupdate = false;
    if max ~= prevmax then
        maxupdate = true;
    end

    local partial = nil;
    local maxpartial = nil;

    if ns.bupdate_partial_power then
        partial = UnitPower("player", ns.power_level, true);
        maxpartial = UnitPowerDisplayMod(ns.power_level)
    end

    if ns.power_level == Enum.PowerType.Essence then
        local peace, interrupted = GetPowerRegenForPowerType(Enum.PowerType.Essence)
        if (peace == nil or peace == 0) then
            peace = 0.2;
        end
        local cooldownDuration = 1 / peace;
        local currtime = GetTime();
        maxpartial = 10;

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

    if maxupdate then
        ns.setup_max_combo(max, maxpartial);
    end
    ns.show_combo(power, max, partial);
end
