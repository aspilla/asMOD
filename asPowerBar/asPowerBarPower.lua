local _, ns = ...;

local gvalue = {
    maxpower = 0,
    powertype = nil,
};

local curve = C_CurveUtil.CreateCurve();
curve:SetType(Enum.LuaCurveType.Linear);
curve:AddPoint(0, 0);
curve:AddPoint(1, 100);

local function get_spellcost(powerType)
    local cost = 0;
    local spellID = select(9, UnitCastingInfo("player"));
    if spellID then
        local costTable = C_Spell.GetSpellPowerCost(spellID) or {};
        for _, costInfo in pairs(costTable) do
            if costInfo.type == powerType then
                cost = costInfo.cost;
                break;
            end
        end
    end
    return cost
end

local function update_powercost(bar, amount)
    if not amount or (amount == 0) then
        bar:Hide();
        return
    end

    local barSize = (amount / gvalue.maxpower) * ns.config.width;
    bar:SetWidth(barSize);
    bar:Show();
end

local function update_power()
    local powertype, powerstring = UnitPowerType("player");

    if not powertype then
        return;
    end

    if powertype ~= gvalue.powertype then
        if powerstring then
            local info = PowerBarColor[powerstring];
            ns.bar:SetStatusBarColor(info.r, info.g, info.b);
        end
    end

    local value = UnitPower("player", powertype);
    local valueMax = UnitPowerMax("player", powertype);


    if not issecretvalue(valueMax) and gvalue.maxpower ~= valueMax then
        gvalue.maxpower = valueMax;
    end

    local cost = get_spellcost(powertype);

    ns.bar:SetMinMaxValues(0, valueMax)
    ns.bar:SetValue(value, Enum.StatusBarInterpolation.ExponentialEaseOut);

    if powertype > 0 then
        ns.bar.text:SetText(tostring(value));
    else
        local valueper = UnitPowerPercent("player", powertype, false, curve);
        ns.bar.text:SetText(string.format("%d", valueper));
    end

    update_powercost(ns.bar.predictbar, cost);
end

local timer = nil;

function ns.setup_power()
    if timer then
        timer:Cancel();
    end

    ns.bar:Show();
    ns.bar.text:Show();

    timer = C_Timer.NewTicker(0.1, update_power);
end
