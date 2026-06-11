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
		local unit = asframe.frame.unit
		if UnitIsGroupLeader(unit) then
			asframe.leadericon:Show();
		else
			asframe.leadericon:Hide();
		end
	end
end


local function update_raidicon(asframe)
	if ns.options.ShowMark then
		local unit = asframe.frame.displayedUnit or asframe.frame.unit;
		show_raidicon(unit, asframe.raidicon);
	end
end

local function update_power(asframe)
	if not asframe.ispowerupdate then
		return;
	end

	local powertype = nil;

	if asframe.ishealer then
		powertype = 0;
	end

	local unit = asframe.frame.unit;
	local power = UnitPower(unit, powertype);
	local maxPower = UnitPowerMax(unit, powertype);
	asframe.powerbar:SetMinMaxValues(0, maxPower);
	asframe.powerbar:SetValue(power);
end

local function update_auracolor(asframe)
	if not ns.options.BuffColor then
		return;
	end

	if asframe == nil or not asframe.buffcolor then
		return;
	end
	local found = false;
	local unit = asframe.frame.displayedUnit or asframe.frame.unit;

	if ns.ACRB_ShowList and ns.ACRB_ShowList.buffid then
		local aura = C_UnitAuras.GetUnitAuraBySpellID(unit, ns.ACRB_ShowList.buffid)
		
		if aura then
			if aura.sourceUnit and UnitIsUnit(aura.sourceUnit, "player") then
				found = true;
			else
				local auras = C_UnitAuras.GetUnitAuras(unit, "PLAYER|HELPFUL");
				for _, a in ipairs(auras) do
					if not issecretvalue(a.spellId) and a.spellId == ns.ACRB_ShowList.buffid then
						found = true;
						break;
					end
				end
			end
		end
	end

	if (found) then
		asframe.buffcolor:Show();
	else
		asframe.buffcolor:Hide();
	end
	ns.update_namecolor(asframe);
end

function ns.update_namecolor(asframe)
	if asframe == nil or not asframe.buffcolor then
		return;
	end

	local frame = asframe.frame;

	if asframe.buffcolor:IsShown() and asframe.classcolor then
		frame.name:SetVertexColor(asframe.classcolor.r, asframe.classcolor.g, asframe.classcolor.b);
	else
		frame.name:SetVertexColor(1.0, 1.0, 1.0);
	end
end

function ns.update_features(asframe)
	if asframe and asframe.frame and asframe.frame:IsShown() then
		update_power(asframe);
		update_raidicon(asframe);
		update_leader(asframe);
		update_auracolor(asframe);
	end
end
