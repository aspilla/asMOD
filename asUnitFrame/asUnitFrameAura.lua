local _, ns = ...;

local bufffilter = AuraUtil.CreateFilterString(AuraUtil.AuraFilters.Helpful);
local debufffilter_attack = AuraUtil.CreateFilterString(AuraUtil.AuraFilters.Harmful, AuraUtil.AuraFilters.Player);
local debufffilter_helpful = AuraUtil.CreateFilterString(AuraUtil.AuraFilters.Harmful);

function ns.update_auras(frame)
    local unit = frame.unit;
    if frame.debuffupdate then
        local filter = debufffilter_helpful;

        if UnitCanAttack("player", unit) then
            filter = debufffilter_attack;
        end

    end

    if frame.buffupdate then
    end
end
