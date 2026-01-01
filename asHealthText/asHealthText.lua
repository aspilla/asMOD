local _, ns = ...;

local configs = {
	font = STANDARD_TEXT_FONT,
	healthsize = 18,
	manasize = 14,
	petsize = 12,
	petmanasize = 10,
	fontoutline = "THICKOUTLINE",
	xpoint = 150,
	ypoint = -55,
	offcombatshow = false,
};

local main_frame = CreateFrame("Frame", nil, UIParent);
ns.unit_player = "player";
ns.unit_pet = "pet";
ns.powerlevel = nil;
ns.bupdate_stagger = false;
ns.bupdate_partial = false;

local curve = C_CurveUtil.CreateCurve();
curve:SetType(Enum.LuaCurveType.Linear);
curve:AddPoint(0, 0);
curve:AddPoint(1, 100);

local function update_health(frame, unit)
	if UnitExists(unit) then
		local valuePct = UnitHealthPercent(unit, false, curve);
		frame:SetText(string.format("%d", valuePct));
		frame:Show();

		local role = UnitGroupRolesAssigned(unit);
		if UnitIsPlayer(unit) or (role and role ~= "NONE") then
			local class = select(2, UnitClass(unit));
			local classColor = class and RAID_CLASS_COLORS[class] or nil;
			if classColor then
				frame:SetTextColor(classColor.r, classColor.g, classColor.b);
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

			frame:SetTextColor(r, g, b);
		end
	else
		frame:Hide();
	end
end

local function update_power(frame, unit)
	if UnitExists(unit) then
		local powertype = UnitPowerType(unit);

		local value     = UnitPower(unit, powertype, true);
		if powertype == 0 then
			value = UnitPowerPercent("player", powertype, false, curve);
		end

		frame:SetText(string.format("%d", value));

		local powerColor = PowerBarColor[powertype]
		if powerColor then
			frame:SetTextColor(powerColor.r, powerColor.g, powerColor.b)
		end
		frame:Show();
	else
		frame:Hide();
	end
end

local function update_frame(update_type)
	local frame;

	if update_type == 1 then
		frame = ns.playerhealth;
		update_health(frame, ns.unit_player);
	elseif update_type == 2 then
		frame = ns.player_mana;
		update_power(frame, ns.unit_player);
	elseif update_type == 3 then
		frame = ns.target_health;
		update_health(frame, "target");
	elseif update_type == 4 then
		frame = ns.target_mana;
		update_power(frame, "target");
	elseif update_type == 5 then
		frame = ns.pet_health;
		update_health(frame, ns.unit_pet);
	elseif update_type == 6 then
		frame = ns.pet_mana;
		update_power(frame, ns.unit_pet);
	end
end

local function update_threat()
	if not (UnitClassification("target") == "minus") then
		local isTanking, status, percentage, rawPercentage = UnitDetailedThreatSituation("player", "target");

		local display;

		if (isTanking) then
			display = UnitThreatPercentageOfLead("player", "target");
		end

		if not display then
			display = percentage;
		end

		if (display and display ~= 0) then
			ns.threat_value:SetText(format("%1.0f", display) .. "%");
			local r, g, b = GetThreatStatusColor(status)
			ns.threat_value:SetTextColor(r, g, b, 1);
			ns.threat_value:Show();
		else
			ns.threat_value:Hide();
		end
	end
end

local function update_rune()
	local runeReady;
	local runeCount = 0;

	for i = 1, 6 do
		_, _, runeReady = GetRuneCooldown(i);
		if runeReady then
			runeCount = runeCount + 1;
		end
	end

	ns.rune_power:SetText(runeCount);
end


local function update_combo()
	if ns.powerlevel then
		local power = UnitPower("player", ns.powerlevel, ns.bupdate_partial);
		local showstr = string.format("%d", power);

		if ns.bupdate_partial then
			local maxpartial = UnitPowerDisplayMod(ns.powerlevel);
			showstr = string.format("%.1f", power / maxpartial);
		end

		ns.combo_power:SetText(showstr);
		ns.combo_power:Show();
		if max == power then
			ns.combo_power:SetTextColor(1, 0, 0)
		else
			ns.combo_power:SetTextColor(1, 1, 0)
		end
	end
end

local function update_stagger()
	if ns.bupdate_stagger then
		local stagger = math.ceil(UnitStagger("player") / UnitHealthMax("player") * 100);

		if stagger > 0 then
			ns.combo_power:SetText(stagger);
			ns.combo_power:Show();
		else
			ns.combo_power:SetText("");
			ns.combo_power:Hide();
		end
	end
end

local function check_playerunit()
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

local function init_frames()
	check_playerunit()
	update_frame(1)
	update_frame(2)
	update_frame(3)
	update_frame(4)
	update_frame(5)
	update_frame(6)
	update_combo()
end

local function init_powertype()
	local localizedClass, englishClass = UnitClass("player")
	local spec = C_SpecializationInfo.GetSpecialization();

	main_frame:UnregisterEvent("UNIT_POWER_UPDATE")
	main_frame:UnregisterEvent("UNIT_DISPLAYPOWER");
	main_frame:UnregisterEvent("RUNE_POWER_UPDATE")
	main_frame:UnregisterEvent("UNIT_AURA");

	ns.bupdate_stagger = false;
	ns.bupdate_partial = false;

	ns.combo_power:SetText("");
	ns.combo_power:Hide();
	ns.powerlevel = nil;

	if (englishClass == "EVOKER") then
		ns.powerlevel = Enum.PowerType.Essence;
	end

	if (englishClass == "DEATHKNIGHT") then
		update_rune();
		ns.rune_power:Show();
		main_frame:RegisterEvent("RUNE_POWER_UPDATE");
	end

	if (englishClass == "PALADIN") then
		ns.powerlevel = Enum.PowerType.HolyPower;
	end

	if (englishClass == "WARRIOR") then

	end

	if (englishClass == "DEMONHUNTER") then

	end


	if (englishClass == "MAGE") then
		if (spec and spec == 1) then
			ns.powerlevel = Enum.PowerType.ArcaneCharges;
		end
	end


	if (englishClass == "WARLOCK") then
		ns.powerlevel = Enum.PowerType.SoulShards;
		if (spec and spec == 3) then
			ns.bupdate_partial = true;
		end
	end

	if (englishClass == "DRUID") then
		ns.powerlevel = Enum.PowerType.ComboPoints;
		main_frame:RegisterEvent("UPDATE_SHAPESHIFT_FORM");
	end

	if (englishClass == "MONK") then
		if (spec and spec == 3) then
			ns.powerlevel = Enum.PowerType.Chi;
		elseif (spec and spec == 1) then
			ns.bupdate_stagger = true;
			main_frame:RegisterUnitEvent("UNIT_AURA", "player");
		end
	end

	if (englishClass == "ROGUE") then
		ns.powerlevel = Enum.PowerType.ComboPoints;
	end

	if (englishClass == "SHAMAN") then
	end

	if (englishClass == "HUNTER") then
	end


	if (englishClass == "PRIEST") then

	end


	if ns.powerlevel then
		main_frame:RegisterUnitEvent("UNIT_POWER_UPDATE", "player");
		main_frame:RegisterUnitEvent("UNIT_DISPLAYPOWER", "player");
	end
end


local function update_raidicon()
	local raidicon = GetRaidTargetIndex("target");
	if raidicon then
		SetRaidTargetIconTexture(ns.raidicon, raidicon);
		ns.raidicon:Show();
	else
		ns.raidicon:Hide();
	end
end


local function on_update()
	update_frame(1)
	update_frame(2)
	update_frame(3)
	update_frame(4)
	update_frame(5)
	update_frame(6)
	update_threat();
end


local function on_load()
	ns.playerhealth = main_frame:CreateFontString(nil, "OVERLAY");
	ns.player_mana = main_frame:CreateFontString(nil, "OVERLAY");
	ns.target_health = main_frame:CreateFontString(nil, "OVERLAY");
	ns.target_mana = main_frame:CreateFontString(nil, "OVERLAY");
	ns.pet_health = main_frame:CreateFontString(nil, "OVERLAY");
	ns.pet_mana = main_frame:CreateFontString(nil, "OVERLAY");
	ns.threat_value = main_frame:CreateFontString(nil, "OVERLAY");
	ns.targettarget = main_frame:CreateFontString(nil, "OVERLAY");
	ns.rune_power = main_frame:CreateFontString(nil, "OVERLAY");
	ns.raidicon = main_frame:CreateTexture(nil, "ARTWORK");
	ns.combo_power = main_frame:CreateFontString(nil, "OVERLAY");

	ns.playerhealth:SetFont(configs.font, configs.healthsize, configs.fontoutline)
	ns.player_mana:SetFont(configs.font, configs.manasize, configs.fontoutline)
	ns.target_health:SetFont(configs.font, configs.healthsize, configs.fontoutline)
	ns.target_mana:SetFont(configs.font, configs.manasize, configs.fontoutline)
	ns.pet_health:SetFont(configs.font, configs.petsize, configs.fontoutline)
	ns.pet_mana:SetFont(configs.font, configs.petmanasize, configs.fontoutline)
	ns.threat_value:SetFont(configs.font, configs.manasize, configs.fontoutline)
	ns.targettarget:SetFont(configs.font, configs.manasize, configs.fontoutline)
	ns.rune_power:SetFont(configs.font, configs.healthsize, configs.fontoutline)
	ns.raidicon:SetTexture("Interface\\TargetingFrame\\UI-RaidTargetingIcons");
	ns.raidicon:SetSize(configs.healthsize, configs.healthsize);
	ns.combo_power:SetFont(configs.font, configs.healthsize, configs.fontoutline)

	ns.playerhealth:SetPoint("CENTER", UIParent, "CENTER", 0 - configs.xpoint, configs.ypoint)
	ns.player_mana:SetPoint("TOP", ns.playerhealth, "BOTTOM", 0, -2)
	ns.target_health:SetPoint("CENTER", UIParent, "CENTER", configs.xpoint, configs.ypoint)
	ns.target_mana:SetPoint("TOP", ns.target_health, "BOTTOM", 0, -2)
	ns.targettarget:SetPoint("BOTTOM", ns.target_health, "TOP", 0, 2)
	ns.threat_value:SetPoint("BOTTOM", ns.targettarget, "TOP", 0, 2)

	ns.rune_power:SetPoint("RIGHT", ns.playerhealth, "LEFT", -2, 0)
	ns.combo_power:SetPoint("RIGHT", ns.rune_power, "LEFT", 0, 0)
	ns.raidicon:SetPoint("LEFT", ns.target_health, "RIGHT", 2, 0)
	ns.pet_health:SetPoint("RIGHT", ns.combo_power, "LEFT", -2, 0)
	ns.pet_mana:SetPoint("TOP", ns.pet_health, "BOTTOM", 0, -2)


	ns.combo_power:SetTextColor(1, 1, 0, 1)


	init_powertype();

	main_frame:RegisterEvent("PLAYER_ENTERING_WORLD")
	main_frame:RegisterEvent("PLAYER_TARGET_CHANGED")
	main_frame:RegisterEvent("PLAYER_REGEN_DISABLED")
	main_frame:RegisterEvent("PLAYER_REGEN_ENABLED")
	main_frame:RegisterUnitEvent("UNIT_ENTERED_VEHICLE", "player")
	main_frame:RegisterUnitEvent("UNIT_EXITED_VEHICLE", "player")
	main_frame:RegisterEvent("VARIABLES_LOADED")
	main_frame:RegisterEvent("ACTIVE_TALENT_GROUP_CHANGED")
	main_frame:RegisterEvent("PLAYER_TALENT_UPDATE")
	main_frame:RegisterUnitEvent("UNIT_TARGET", "target")
	main_frame:RegisterUnitEvent("UNIT_THREAT_SITUATION_UPDATE", "player", "target");
	main_frame:RegisterEvent("RAID_TARGET_UPDATE");
end


local function on_event(self, event, arg1, arg2, arg3, ...)
	if event == "PLAYER_ENTERING_WORLD" or event == "VARIABLES_LOADED" then
		init_frames();
		if event == "PLAYER_ENTERING_WORLD" then
			init_powertype();
		end

		if UnitIsConnected("target") then
			--do nothing
		else
			ns.target_health:SetText("");
			ns.target_mana:SetText("");
		end

		if UnitAffectingCombat("player") then
			main_frame:Show();
		else
			if configs.offcombatshow then
				main_frame:Show();
			else
				main_frame:Hide();
			end
		end
	elseif event == "PLAYER_TARGET_CHANGED" then
		AHT_TargetClass = nil;
		if UnitIsConnected("target") then
			if UnitIsPlayer("target") then
				_, AHT_TargetClass = UnitClass("target")
			end

			if UnitIsPlayer("targettarget") then
				local _, class = UnitClass("targettarget");
				local color = nil;

				if class then
					color = RAID_CLASS_COLORS[class];
				end

				if color then
					ns.targettarget:SetTextColor(color.r, color.g, color.b, 1);
				end

				ns.targettarget:SetText(UnitName("targettarget"));
				ns.targettarget:Show();
			else
				ns.targettarget:SetText("");
				ns.targettarget:Hide();
			end
			init_frames();
		else
			ns.targettarget:SetText("");
			ns.targettarget:Hide();

			ns.target_health:SetText("");
			ns.target_mana:SetText("");
		end

		update_threat();

		update_raidicon();
	elseif event == "UNIT_TARGET" and arg1 == "target" then
		if UnitIsPlayer("targettarget") then
			local _, class = UnitClass("targettarget");
			local color = nil;

			if class then
				color = RAID_CLASS_COLORS[class];
			end

			if color then
				ns.targettarget:SetTextColor(color.r, color.g, color.b, 1);
			end

			ns.targettarget:SetText(UnitName("targettarget"));
			ns.targettarget:Show();
		else
			ns.targettarget:SetText("");
			ns.targettarget:Hide();
		end
	elseif event == "UNIT_ENTERED_VEHICLE" and arg1 == "player" then
		init_frames();
	elseif event == "UNIT_EXITED_VEHICLE" and arg1 == "player" then
		init_frames();
	elseif event == "PLAYER_REGEN_DISABLED" then
		main_frame:Show();
	elseif event == "PLAYER_REGEN_ENABLED" then
		if configs.offcombatshow then
			main_frame:Show();
		else
			main_frame:Hide();
		end
	elseif event == "RUNE_POWER_UPDATE" then
		update_rune();
	elseif event == "UNIT_POWER_UPDATE" and arg1 == "player" then
		update_combo();
	elseif event == "UNIT_AURA" and arg1 == "player" then
		update_stagger();
	elseif event == "UNIT_DISPLAYPOWER" and arg1 == "player" then
		update_combo();
	elseif event == "ACTIVE_TALENT_GROUP_CHANGED" or event == "PLAYER_TALENT_UPDATE" then
		init_powertype();
		update_combo();
		init_frames();
	elseif event == "UPDATE_SHAPESHIFT_FORM" then
		update_combo();
	elseif event == "RAID_TARGET_UPDATE" then
		update_raidicon();
	elseif (event == "UNIT_THREAT_SITUATION_UPDATE") then
		update_threat();
	end

	return;
end

main_frame:SetScript("OnEvent", on_event)
C_Timer.NewTicker(0.1, on_update);
on_load()
