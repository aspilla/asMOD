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
	Stat = { abbr = "S", color = { r = 1, g = 1, b = 0 } },
	Crit = { abbr = "C", color = { r = 1, g = 0, b = 0 } },
	Haste = { abbr = "H", color = { r = 0, g = 1, b = 0 } },
	Mastery = { abbr = "M", color = { r = 0.5, g = 0, b = 1 } },
	Versatility = { abbr = "V", color = { r = 0, g = 0, b = 1 } }
}

local main_frame = CreateFrame("Frame", "asInformationFrame", UIParent);
main_frame:SetFrameStrata("LOW");
main_frame:SetSize(configs.width, (configs.height + 2) * 5);
main_frame:SetPoint("CENTER", UIParent, "CENTER", configs.x_point, configs.y_point);

local default_barcolor = { r = 0.5, g = 0.5, b = 0.5 }
local stat_historys = { Stat = {}, Crit = {}, Haste = {}, Mastery = {}, Versatility = {} }
local recent_minstats = { Stat = nil, Crit = nil, Haste = nil, Mastery = nil, Versatility = nil }

local function create_bar(name, parent, config)
	local bar = CreateFrame("StatusBar", "asInformation" .. name .. "Bar", parent);
	bar:SetSize(configs.width, configs.height)
	bar:SetStatusBarTexture("RaidFrame-Hp-Fill")
	bar:SetStatusBarColor(config.color.r, config.color.g, config.color.b);

	bar.minbar = CreateFrame("StatusBar", nil, bar);
	bar.minbar:SetAllPoints(bar)
	bar.minbar:SetStatusBarTexture("RaidFrame-Hp-Fill")
	bar.minbar:SetStatusBarColor(default_barcolor.r, default_barcolor.g, default_barcolor.b);
	bar.minbar:SetFrameLevel(bar:GetFrameLevel() + 10);

	bar.bg = bar:CreateTexture(nil, "BACKGROUND")
	bar.bg:SetPoint("TOPLEFT", bar, "TOPLEFT", -1, 1)
	bar.bg:SetPoint("BOTTOMRIGHT", bar, "BOTTOMRIGHT", 1, -1)
	bar.bg:SetColorTexture(0, 0, 0, 1);

	bar.text = bar.minbar:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
	bar.text:SetPoint("RIGHT", bar.minbar, "RIGHT", -1, 0)
	bar.text:SetTextColor(config.color.r, config.color.g, config.color.b)

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
	local pristatid = select(6, C_SpecializationInfo.GetSpecializationInfo(currspec)) or 1;
	local pristat = UnitStat("player", pristatid);

	return pristat;
end

local critfunc = nil;

local function get_crit()
	if UnitAffectingCombat("player") then
		if critfunc then
			return critfunc();
		end
		return 0;
	end

	local spellcrit, rangedcrit, meleecrit;
	local critchance;

	spellcrit = GetSpellCritChance();
	rangedcrit = GetRangedCritChance();
	meleecrit = GetCritChance();

	if issecretvalue(rangedcrit) or issecretvalue(spellcrit) or issecretvalue(meleecrit) then
		if critfunc then
			return critfunc();
		end
		return 0;
	end

	if (spellcrit >= rangedcrit and spellcrit >= meleecrit) then
		critfunc = GetSpellCritChance;
		critchance = spellcrit;
	elseif (rangedcrit >= meleecrit) then
		critfunc = GetRangedCritChance;
		critchance = rangedcrit;
	else
		critfunc = GetCritChance;
		critchance = meleecrit;
	end

	return critchance;
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
	if not ns.needreposition then return end
	ns.needreposition = false;

	local prevframe = main_frame;
	local yoffset = 0;

	local function update_bar_visibility(bar, show)
		if show then
			bar:SetPoint("TOPLEFT", prevframe, (prevframe == main_frame and "TOPLEFT" or "BOTTOMLEFT"), 0, yoffset);
			bar:Show();
			prevframe = bar;
			yoffset = -2;
		else
			bar:Hide();
		end
	end

	update_bar_visibility(ns.primarybar, ns.options.showPrimary);
	update_bar_visibility(ns.critbar, ns.options.showCrit);
	update_bar_visibility(ns.hastebar, ns.options.showHaste);
	update_bar_visibility(ns.masterybar, ns.options.showMastery);
	update_bar_visibility(ns.versbar, ns.options.showVer);
end

local function update_bar(bar, value, minvalue, max, formatString)
	if bar and bar.text then
		bar:SetMinMaxValues(0, max);
		bar:SetValue(value, Enum.StatusBarInterpolation.ExponentialEaseOut);
		bar.text:SetText(string.format(formatString, value));

		bar.minbar:SetMinMaxValues(0, max);
		bar.minbar:SetValue(minvalue or 0, Enum.StatusBarInterpolation.ExponentialEaseOut);
	end
end

local function update_stats()
	local haste = GetHaste();
	local crit = get_crit();
	local mastery = GetMasteryEffect();
	local versatility = GetCombatRatingBonus(CR_VERSATILITY_DAMAGE_DONE) or 0;
	local pristat = get_primarystat();

	if ns.options.showCrit then update_bar(ns.critbar, crit, recent_minstats.Crit, 100, "%.2f%%") end
	if ns.options.showHaste then update_bar(ns.hastebar, haste, recent_minstats.Haste, 100, "%.2f%%") end
	if ns.options.showMastery then update_bar(ns.masterybar, mastery, recent_minstats.Mastery, 100, "%.2f%%") end
	if ns.options.showVer then update_bar(ns.versbar, versatility, recent_minstats.Versatility, 100, "%.2f%%") end

	if ns.options.showPrimary then
		local min = recent_minstats.Stat or 0;
		local max = min * 2;
		update_bar(ns.primarybar, pristat, min, max, "%d");
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
