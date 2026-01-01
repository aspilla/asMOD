local _, ns = ...;

local gvalue = {
    maxpower = 0,
    powertype = nil,
};

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
    local powerType, powerTypeString = UnitPowerType("player");

    if powerType ~= gvalue.powertype then
        if powerTypeString then
            local info = PowerBarColor[powerTypeString];
            ns.bar:SetStatusBarColor(info.r, info.g, info.b);
        end

        if powerType == 0 then
            ns.bar.text:Hide();
        else
            ns.bar.text:Show();
        end
    end

    local value = UnitPower("player", powerType);
    local valueMax = UnitPowerMax("player", powerType);

    if not issecretvalue(valueMax) and gvalue.maxpower ~= valueMax then
        gvalue.maxpower = valueMax;
    end

    local cost = get_spellcost(powerType);

    ns.bar:SetMinMaxValues(0, valueMax)
    ns.bar:SetValue(value, Enum.StatusBarInterpolation.ExponentialEaseOut);
    ns.bar.text:SetText(tostring(value));

    update_powercost(ns.bar.predictbar, cost);
end

local timer = nil;

function ns.setup_power()
    if timer then
        timer:Cancel();
    end

    ns.bar:Show();    

    timer = C_Timer.NewTicker(0.1, update_power);
end
