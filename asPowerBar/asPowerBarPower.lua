local _, ns = ...;

ns.powermax = 100;

local function getspellcost(powerType)
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

local function updatepowercost(bar, amount)
    if not amount or (amount == 0) then
        bar:Hide();
        return
    end

    local barSize = (amount / ns.powermax) * ns.config.width;
    bar:SetWidth(barSize);
    bar:Show();
end

function ns.update_power()
    local powerType, powerTypeString = UnitPowerType("player");

    if powerTypeString then
        local info = PowerBarColor[powerTypeString];
        ns.bar:SetStatusBarColor(info.r, info.g, info.b);
    end

    local value = UnitPower("player", powerType);
    local valueMax = UnitPowerMax("player", powerType);

    if not issecretvalue(valueMax) and ns.powermax ~= valueMax then
        ns.powermax = valueMax;
    end

    local cost = getspellcost(powerType);

    ns.bar:SetMinMaxValues(0, valueMax)
    ns.bar:SetValue(value, Enum.StatusBarInterpolation.ExponentialEaseOut);
    ns.bar.text:SetText(tostring(value));

    updatepowercost(ns.bar.predictbar, cost);
end
