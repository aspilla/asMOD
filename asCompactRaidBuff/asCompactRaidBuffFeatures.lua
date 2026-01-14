local _, ns = ...;

local function show_raidicon(unit, markframe)
	local raidicon = GetRaidTargetIndex(unit);
	if raidicon then
		SetRaidTargetIconTexture(markframe, raidicon);
		markframe:Show();
	else
		markframe:Hide();
	end
end

local function update_raidicon(asframe)
	if asframe.needtosetup then
		ns.setup_frame(asframe);
	end
	show_raidicon(asframe.displayedUnit, asframe.raidicon);
end

local function update_power(asframe)
	if asframe.needtosetup then
		ns.setup_frame(asframe);
	end

	if not asframe.ispowerupdate then
		return;
	end

	local powertype = nil;

	if asframe.ishealer then
		powertype = 0;
	end

	local unit = asframe.unit;
	local power = UnitPower(unit, powertype);
	local maxPower = UnitPowerMax(unit, powertype);
	asframe.powerbar:SetMinMaxValues(0, maxPower);
	asframe.powerbar:SetValue(power);
end


function ns.update_featuresforall()
	if IsInRaid() then
		for _, asframe in pairs(ns.asraid) do
			if asframe and asframe.frame and asframe.frame:IsShown() then
				update_power(asframe);
				update_raidicon(asframe);
			end
		end
	else
		for _, asframe in pairs(ns.asparty) do
			if asframe and asframe.frame and asframe.frame:IsShown() then
				update_power(asframe);
				update_raidicon(asframe);
			end
		end
	end
end

function ns.update_features(asframe)
	if asframe and asframe.frame and asframe.frame:IsShown() then
		update_power(asframe);
		update_raidicon(asframe);
	end
end
