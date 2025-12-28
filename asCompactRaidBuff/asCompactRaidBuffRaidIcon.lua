local _, ns = ...;

local function DisplayRaidIcon(unit, markframe)
    local raidicon = GetRaidTargetIndex(unit);
    if raidicon then
        SetRaidTargetIconTexture(markframe, raidicon);
        markframe:Show();
    else
        markframe:Hide();
    end
end

function ns.update_raidicon(asframe)
	if asframe.needtosetup then
		ns.setup_frame(asframe);
	end
	DisplayRaidIcon(asframe.unit, asframe.raidicon);
end

function ns.update_power(asframe)
	if asframe.needtosetup then
		ns.setup_frame(asframe);
	end

	--[[
	if (not asframe.asManabar) or (asframe.checkManaType == nil) then
		return;
	end

	asframe.asManabar:SetMinMaxValues(0, UnitPowerMax(asframe.unit, asframe.checkManaType));
	asframe.asManabar:SetValue(UnitPower(asframe.unit, asframe.checkManaType));
	]]
end
