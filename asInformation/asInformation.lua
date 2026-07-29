local _, ns = ...;

local configs = {
	combatalpha = 1,
	normalalpha = 0.5,
	updaterate = 0.2,
	x_point = -165 - 20,
	y_point = -300,
	width = 90,
	height = 12,
};

local stat_configs = {
	Stat = { abbr = "S", gemColor = { r = 1, g = 1, b = 0 } },
	Crit = { abbr = "C", gemColor = { r = 1, g = 0, b = 0 } },
	Haste = { abbr = "H", gemColor = { r = 0, g = 1, b = 0 } },
	Mastery = { abbr = "M", gemColor = { r = 0.5, g = 0, b = 1 } },
	Versatility = { abbr = "V", gemColor = { r = 0, g = 0, b = 1 } }
}

local main_frame = CreateFrame("Frame", "asInformationFrame", UIParent);
main_frame:SetFrameStrata("LOW");
main_frame:SetSize(configs.width, (configs.height + 2) * 5);
main_frame:SetPoint("CENTER", UIParent, "CENTER", configs.x_point, configs.y_point);

local defaultBarColor = { r = 0.5, g = 0.5, b = 0.5 }
local stat_historys = { Stat = {}, Crit = {}, Haste = {}, Mastery = {}, Versatility = {} }
local recent_minstats = { Stat = nil, Crit = nil, Haste = nil, Mastery = nil, Versatility = nil }

local function create_bar(name, parent, config)
	local bar = CreateFrame("StatusBar", "asInformation" .. name .. "Bar", parent);
	bar:SetSize(configs.width, configs.height)
	bar:SetStatusBarTexture("RaidFrame-Hp-Fill")
	bar:SetStatusBarColor(config.gemColor.r, config.gemColor.g, config.gemColor.b);

	bar.minbar = CreateFrame("StatusBar", nil, bar);
	bar.minbar:SetAllPoints(bar)
	bar.minbar:SetStatusBarTexture("RaidFrame-Hp-Fill")
	bar.minbar:SetStatusBarColor(defaultBarColor.r, defaultBarColor.g, defaultBarColor.b);
	bar.minbar:SetFrameLevel(bar:GetFrameLevel() + 10);

	bar.bg = bar:CreateTexture(nil, "BACKGROUND")
	bar.bg:SetPoint("TOPLEFT", bar, "TOPLEFT", -1, 1)
	bar.bg:SetPoint("BOTTOMRIGHT", bar, "BOTTOMRIGHT", 1, -1)
	bar.bg:SetColorTexture(0, 0, 0, 1);

	bar.text = bar.minbar:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
	bar.text:SetPoint("RIGHT", bar.minbar, "RIGHT", -1, 0)
	bar.text:SetTextColor(config.gemColor.r, config.gemColor.g, config.gemColor.b)

	bar.name = bar.minbar:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
	bar.name:SetPoint("LEFT", bar.minbar, "LEFT", 1, 0)
	bar.name:SetTextColor(1, 1, 1);
	bar.name:SetText(config.abbr)

	return bar
end

local function init_frames()
	ns.primarybar = create_bar("PrimaryStat", main_frame, stat_configs.Stat)
	ns.critbar = create_bar("Crit", main_frame, stat_configs.Crit)
	ns.hastebar = create_bar("Haste", main_frame, stat_configs.Haste)
	ns.masterybar = create_bar("Mastery", main_frame, stat_configs.Mastery)
	ns.versbar = create_bar("Versatility", main_frame, stat_configs.Versatility)
end

ns.needreposition = true;

local function get_primarystat()
	local currspec = C_SpecializationInfo.GetSpecialization() or 1;
	local primaryStatID = select(6, C_SpecializationInfo.GetSpecializationInfo(currspec)) or 1;
	local primaryStatValue = UnitStat("player", primaryStatID);

	return primaryStatValue;
end

local critfunc = nil;

local function get_crit()
	if UnitAffectingCombat("player") then
		if critfunc then
			return critfunc();
		end
		return 0;
	end

	local spellCrit, rangedCrit, meleeCrit;
	local critChance;

	spellCrit = GetSpellCritChance();
	rangedCrit = GetRangedCritChance();
	meleeCrit = GetCritChance();

	if issecretvalue(rangedCrit) or issecretvalue(spellCrit) or issecretvalue(meleeCrit) then
		if critfunc then
			return critfunc();
		end
		return 0;
	end

	if (spellCrit >= rangedCrit and spellCrit >= meleeCrit) then
		critfunc = GetSpellCritChance;
		critChance = spellCrit;
	elseif (rangedCrit >= meleeCrit) then
		critfunc = GetRangedCritChance;
		critChance = rangedCrit;
	else
		critfunc = GetCritChance;
		critChance = meleeCrit;
	end

	return critChance;
end

local function recode_stats()
	local inCombat = UnitAffectingCombat("player");

	if not inCombat then
		local currentStats = {
			Stat = get_primarystat(),
			Crit = get_crit(),
			Haste = GetHaste(),
			Mastery = GetMasteryEffect(),
			Versatility = GetCombatRatingBonus(CR_VERSATILITY_DAMAGE_DONE),
		}


		for statName, value in pairs(currentStats) do
			if not issecretvalue(value) then
				local snapshot = { value = value }
				table.insert(stat_historys[statName], 1, snapshot)

				local numList = #stat_historys[statName];

				if numList > 100 then
					table.remove(stat_historys[statName], numList);
				end
			end
		end

		for statName, history in pairs(stat_historys) do
			-- Calculate minimum from combat snapshots
			local minStat = nil
			for _, snapshot in ipairs(history) do
				if minStat == nil or (snapshot.value < minStat and snapshot.value > 0) then
					minStat = snapshot.value
				end
			end
			recent_minstats[statName] = minStat
		end
	end
end

local function check_reposition()
	if ns.needreposition then
		ns.needreposition = false;

		local prevframe = main_frame;
		local yOffset = 0;

		if ns.options.showPrimary then
			ns.primarybar:SetPoint("TOPLEFT", prevframe, (prevframe == main_frame and "TOPLEFT" or "BOTTOMLEFT"), 0,
				yOffset);
			ns.primarybar:Show();
			prevframe = ns.primarybar;
			yOffset = -2;
		else
			ns.primarybar:Hide();
		end

		if ns.options.showCrit then
			ns.critbar:SetPoint("TOPLEFT", prevframe, (prevframe == main_frame and "TOPLEFT" or "BOTTOMLEFT"), 0, yOffset);
			ns.critbar:Show();
			prevframe = ns.critbar;
			yOffset = -2;
		else
			ns.critbar:Hide();
		end

		if ns.options.showHaste then
			ns.hastebar:SetPoint("TOPLEFT", prevframe, (prevframe == main_frame and "TOPLEFT" or "BOTTOMLEFT"), 0,
				yOffset);
			ns.hastebar:Show();
			prevframe = ns.hastebar;
			yOffset = -2;
		else
			ns.hastebar:Hide();
		end

		if ns.options.showMastery then
			ns.masterybar:SetPoint("TOPLEFT", prevframe, (prevframe == main_frame and "TOPLEFT" or "BOTTOMLEFT"), 0,
				yOffset);
			ns.masterybar:Show();
			prevframe = ns.masterybar;
			yOffset = -2;
		else
			ns.masterybar:Hide();
		end

		if ns.options.showVer then
			ns.versbar:SetPoint("TOPLEFT", prevframe, (prevframe == main_frame and "TOPLEFT" or "BOTTOMLEFT"), 0,
				yOffset);
			ns.versbar:Show();
			prevframe = ns.versbar;
			yOffset = -2;
		else
			ns.versbar:Hide();
		end
	end
end

local function update_stats()
	local function update_bar(bar, value, minValue, formatString)
		if bar and bar.text then
			bar:SetMinMaxValues(0, 100);
			bar:SetValue(value, Enum.StatusBarInterpolation.ExponentialEaseOut);
			bar.text:SetText(string.format(formatString, value));

			bar.minbar:SetMinMaxValues(0, 100);
			bar.minbar:SetValue(minValue or 0, Enum.StatusBarInterpolation.ExponentialEaseOut);
		end
	end

	local haste = GetHaste();
	local crit = get_crit();
	local mastery = GetMasteryEffect();
	local versatility = GetCombatRatingBonus(CR_VERSATILITY_DAMAGE_DONE) or 0;
	local primaryStatValue = get_primarystat();

	if ns.options.showCrit then update_bar(ns.critbar, crit, recent_minstats.Crit, "%.2f%%") end
	if ns.options.showHaste then update_bar(ns.hastebar, haste, recent_minstats.Haste, "%.2f%%") end
	if ns.options.showMastery then update_bar(ns.masterybar, mastery, recent_minstats.Mastery, "%.2f%%") end
	if ns.options.showVer then update_bar(ns.versbar, versatility, recent_minstats.Versatility, "%.2f%%") end

	if ns.options.showPrimary then
		if ns.primarybar and ns.primarybar.text then
			local minStat = recent_minstats.Stat or 0;
			local maxVal = minStat * 2;
			ns.primarybar:SetMinMaxValues(0, maxVal);
			ns.primarybar:SetValue(primaryStatValue, Enum.StatusBarInterpolation.ExponentialEaseOut);
			ns.primarybar.text:SetText(string.format("%d", primaryStatValue));

			ns.primarybar.minbar:SetMinMaxValues(0, maxVal);
			ns.primarybar.minbar:SetValue(minStat, Enum.StatusBarInterpolation.ExponentialEaseOut);
		end
	end
end

local function on_update()
	check_reposition();
	recode_stats();
	update_stats();
end

local bfirst = true;

local function init()
	ns.setup_option();
	init_frames();

	local libasConfig = LibStub:GetLibrary("LibasConfig", true);

	if libasConfig then
		libasConfig.load_position(main_frame, "asInformation", AINF_Position);
	end

	bfirst = false;
	C_Timer.NewTicker(configs.updaterate, on_update);
end

local function on_event(self, event, ...)
	local arg = ...;

	if event == "PLAYER_ENTERING_WORLD" then
		if UnitAffectingCombat("player") then
			main_frame:SetAlpha(configs.combatalpha);
		else
			main_frame:SetAlpha(configs.normalalpha);
		end
	elseif event == "PLAYER_REGEN_DISABLED" then
		main_frame:SetAlpha(configs.combatalpha);
	elseif event == "PLAYER_REGEN_ENABLED" then
		main_frame:SetAlpha(configs.normalalpha);
	elseif event == "ADDON_LOADED" and arg == "asInformation" and bfirst == true then
		C_Timer.After(0.5, init);
	end
end
main_frame:RegisterEvent("PLAYER_ENTERING_WORLD")
main_frame:RegisterEvent("PLAYER_REGEN_DISABLED");
main_frame:RegisterEvent("PLAYER_REGEN_ENABLED");
main_frame:RegisterEvent("ADDON_LOADED");
main_frame:SetScript("OnEvent", on_event)
