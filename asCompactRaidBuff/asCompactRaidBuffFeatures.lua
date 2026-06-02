local _, ns = ...;

local function show_raidicon(unit, markframe)
	if markframe then
		local raidicon = GetRaidTargetIndex(unit);

		if raidicon then
			SetRaidTargetIconTexture(markframe, raidicon);
			markframe:Show();
		else
			markframe:Hide();
		end
	end
end

local function update_leader(asframe)
	if ns.options.ShowLeader and asframe.leadericon then
		if UnitIsGroupLeader(asframe.displayedUnit) then
			asframe.leadericon:Show();
		else
			asframe.leadericon:Hide();
		end
	end
end


local function update_raidicon(asframe)
	if asframe.needtosetup then
		ns.setup_frame(asframe);
	end

	if ns.options.ShowMark then
		show_raidicon(asframe.displayedUnit, asframe.raidicon);
	end
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
		update_leader(asframe);
	end
end

function ns.update_namecolor(asframe)
	if not ns.options.BuffColor then
		return;
	end

	if asframe == nil or not asframe.buffcolor then
		return;
	end
	local found = false;

	if ns.ACRB_ShowList and ns.ACRB_ShowList.buffid then
		local auras = C_UnitAuras.GetUnitAuras(asframe.displayedUnit, "PLAYER|HELPFUL");
		for _, aura in ipairs(auras) do
			if not issecretvalue(aura.spellId) and aura.spellId == ns.ACRB_ShowList.buffid then
				found = true;
				break;
			end
		end
	end

	if (found) then
		asframe.buffcolor:Show();
	else
		asframe.buffcolor:Hide();
	end

	local frame = asframe.frame;

	if asframe.buffcolor:IsShown() and asframe.classcolor then
		frame.name:SetVertexColor(asframe.classcolor.r, asframe.classcolor.g, asframe.classcolor.b);
	else
		frame.name:SetVertexColor(1.0, 1.0, 1.0);
	end
end
