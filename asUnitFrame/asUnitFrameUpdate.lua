local _, ns = ...;

local icons = {
	leader = CreateAtlasMarkup("groupfinder-icon-leader", 14, 9, 0, 0),
	combat = CreateAtlasMarkup("pvptalents-warmode-swords", 14, 14),
	resting = CreateAtlasMarkup("Innkeeper", 14, 14),
	elite = CreateAtlasMarkup("nameplates-icon-elite-gold", 14, 14),
	rare = CreateAtlasMarkup("UI-HUD-UnitFrame-Target-PortraitOn-Boss-Rare-Star", 14, 14),
	rareelite = CreateAtlasMarkup("nameplates-icon-elite-silver", 14, 14),
	tank = CreateAtlasMarkup("roleicon-tiny-tank"),
	dps = CreateAtlasMarkup("roleicon-tiny-dps"),
	healer = CreateAtlasMarkup("roleicon-tiny-healer"),

};

local pctcurve = C_CurveUtil.CreateCurve();
pctcurve:SetType(Enum.LuaCurveType.Linear);
pctcurve:AddPoint(0, 0);
pctcurve:AddPoint(1, 100);

local function update_playerunit()
	local hasValidVehicleUI = UnitHasVehicleUI("player");
	local unitVehicleToken;
	if (hasValidVehicleUI) then
		local prefix, id, suffix = string.match("player", "([^%d]+)([%d]*)(.*)")
		unitVehicleToken = prefix .. "pet" .. id .. suffix;
		if (not UnitExists(unitVehicleToken)) then
			hasValidVehicleUI = false;
		end
	end

	if (hasValidVehicleUI) then
		ns.unit_player = unitVehicleToken
		ns.unit_pet = "player"
	else
		ns.unit_player = "player"
		ns.unit_pet = "pet"
	end
end

function ns.update_unithealth(frame, updated)
	local unit = frame.unit;

	if frame.isplayerframe then
		unit = ns.unit_player;
	elseif frame.ispetframe then
		unit = ns.unit_pet;
	end

	if not UnitExists(unit) then
		return;
	end

	local type = Enum.StatusBarInterpolation.ExponentialEaseOut;

	if updated then
		type = 0;
	end


	-- Healthbar
	local value = UnitHealth(unit);
	local max = UnitHealthMax(unit);
	local pct = UnitHealthPercent(unit, true, pctcurve);

	local incomingheal = UnitGetIncomingHeals(unit) or 0;
	local totalabsorb = UnitGetTotalAbsorbs(unit) or 0;
	local totalhealabsorb = UnitGetTotalHealAbsorbs(unit) or 0;


	frame.healthbar:SetMinMaxValues(0, max)
	frame.healthbar:SetValue(value, type);
	frame.healthbar.absorbBar:SetMinMaxValues(0, max);
	frame.healthbar.absorbBar:SetValue(totalabsorb, type);
	frame.healthbar.healabsorbBar:SetMinMaxValues(0, max);
	frame.healthbar.healabsorbBar:SetValue(totalhealabsorb, type);
	frame.healthbar.incominghealBar:SetMinMaxValues(0, max);
	frame.healthbar.incominghealBar:SetValue(incomingheal, type);
	if UnitIsDead(unit) then
		frame.pvalue:SetText("Dead");
	else
		frame.pvalue:SetText(string.format("%.1f", pct));
	end

	frame.hvalue:SetText(AbbreviateLargeNumbers(value));

	if ns.colorcurve and ns.options.ShowLowHealth and UnitCanAttack("player", unit) then
		local color = UnitHealthPercent(unit, true, ns.colorcurve);

		frame.healthbar.bg:SetColorTexture(color:GetRGBA());
	else
		frame.healthbar.bg:SetColorTexture(0, 0, 0);
	end
end

function ns.update_unitframe_other(frame, updated)
	local unit = frame.unit;
	local showplayermana = false;

	if frame.isplayerframe then
		update_playerunit()
		unit = ns.unit_player;
		showplayermana = (unit ~= "player");
		if not InCombatLockdown() and unit ~= frame:GetAttribute("unit") then
			frame:SetAttribute("unit", unit);
		end
	elseif frame.ispetframe then
		unit = ns.unit_pet;
	end

	if not UnitExists(unit) then
		return;
	end

	local role = UnitGroupRolesAssigned(unit);

	--ClassColor
	if UnitIsPlayer(unit) or (role and role ~= "NONE") then
		local class = select(2, UnitClass(unit));
		local classColor = class and RAID_CLASS_COLORS[class] or nil;
		if classColor then
			frame.healthbar:SetStatusBarColor(classColor.r, classColor.g, classColor.b);
		end
	else
		local r = 0;
		local g = 1.0;
		local b = 0;
		local reaction = UnitReaction("player", unit);
		if (reaction) then
			r = FACTION_BAR_COLORS[reaction].r;
			g = FACTION_BAR_COLORS[reaction].g;
			b = FACTION_BAR_COLORS[reaction].b;
		end

		frame.healthbar:SetStatusBarColor(r, g, b);
	end


	local raidicon = GetRaidTargetIndex(unit)

	--Name
	local leveltext = ""
	local unitlevel = UnitLevel(unit);
	if unitlevel < 0 then
		leveltext = "??"
	else
		leveltext = tostring(unitlevel);
	end
	local name = UnitName(unit);

	if not frame.is_small then
		name = leveltext .. " " .. name;
	end

	-- Type
	local classtext = "";

	local classification = UnitClassification(unit)

	if (classification == "elite" or classification == "worldboss") then
		classtext = icons.elite;
	elseif (classification == "rare") then
		classtext = icons.rare;
	elseif (classification == "rareelite") then
		classtext = icons.rareelite;
	end

	if frame.isplayerframe or frame.istargetframe then
		if UnitIsGroupLeader(unit) then
			classtext = classtext .. icons.leader;
		end

		if (role and role ~= "NONE") then
			local texture = nil;
			if (role == "TANK") then
				texture = icons.tank;
			elseif (role == "DAMAGER") then
				texture = icons.dps;
			elseif (role == "HEALER") then
				texture = icons.healer;
			end

			if texture then
				classtext = classtext .. texture;
			end
		end


		if UnitAffectingCombat(unit) then
			classtext = classtext .. icons.combat;
		end

		if IsResting() and frame.isplayerframe then
			classtext = classtext .. icons.resting;
		end

		--[[
        local creatureType = UnitCreatureType(unit)

        if creatureType and not UnitIsPlayer(unit) then
            classtext = classtext .. " (" .. creatureType .. ")";
        end
        ]]
	end

	frame.name:SetText(name);
	if raidicon then
		SetRaidTargetIconTexture(frame.mark, raidicon);
		frame.mark:Show();
	else
		frame.mark:Hide();
	end
	frame.classtext:SetText(classtext);

	--Power
	local power = UnitPower(unit)
	local maxPower = UnitPowerMax(unit)
	frame.powerbar:SetMinMaxValues(0, maxPower)
	if udpated then
		frame.powerbar:SetValue(power);
	else
		frame.powerbar:SetValue(power, Enum.StatusBarInterpolation.ExponentialEaseOut);
	end
	frame.powerbar.value:SetText(power)

	local powerType, powerToken = UnitPowerType(unit)

	if powerType ~= nil then
		local powerColor = PowerBarColor[powerType]
		if powerColor then
			frame.powerbar:SetStatusBarColor(powerColor.r, powerColor.g, powerColor.b)
		end

		if frame.isplayerframe then
			if powerType > 0 then
				local manavalue = UnitPower(unit, 0);
				local manaMax = UnitPowerMax(unit, 0);

				if manaMax > 0 then
					frame.powerbar:SetMinMaxValues(0, manaMax)
					frame.powerbar:SetValue(manavalue, Enum.StatusBarInterpolation.ExponentialEaseOut);
					frame.powerbar.value:SetText(manavalue)
					local powerColor = PowerBarColor[0]
					frame.powerbar:SetStatusBarColor(powerColor.r, powerColor.g, powerColor.b)
					frame.powerbar:Show();
				elseif showplayermana then
					frame.powerbar:Show();
				else
					frame.powerbar:Hide();
				end
			else
				frame.powerbar:Hide();
			end
		end
	end

	--Target

	if ns.options.ShowTargetBorder and frame.bchecktarget then
		if UnitIsUnit(unit, "target") then
			frame.targetborder:Show();
		else
			frame.targetborder:Hide();
		end
	end

	--Threat
	if frame.istargetframe and not UnitIsPlayer(unit) then
		local isTanking, status, percentage, rawPercentage = UnitDetailedThreatSituation("player", unit);

		local display;

		if (isTanking) then
			display = UnitThreatPercentageOfLead("player", unit);
		end

		if not display then
			display = percentage;
		end

		if (display and display ~= 0) then
			frame.aggro:SetText(format("%1.0f", display) .. "%");
			local r, g, b = GetThreatStatusColor(status)
			frame.aggro:SetTextColor(r, g, b, 1);
		else
			frame.aggro:SetText("");
		end
	else
		frame.aggro:SetText("");
	end

	if UnitAffectingCombat("player") then
		frame:SetAlpha(1);
	elseif ns.options.CombatAlphaChange then
		frame:SetAlpha(0.5);
	end

	local needtohide = true;

	if ns.options.CheckRange then
		if UnitCanAttack("player", unit) then
			local outofrange = ns.check_range(unit, ns.isevoker);
			if outofrange then
				frame.range:Show();
				needtohide = false;
			end
		end
	end

	if needtohide then
		frame.range:Hide();
	end
end

function ns.update_unitframe_portrait(frame)
	local unit = frame.unit;


	if frame.isplayerframe then
		unit = ns.unit_player;
	elseif frame.ispetframe then
		unit = ns.unit_pet;
	end

	if frame.portrait then
		SetPortraitTexture(frame.portrait.portrait, unit, false);
	end
end
