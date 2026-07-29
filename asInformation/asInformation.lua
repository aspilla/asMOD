local _, ns = ...;

local configs = {
	combatalpha = 1,
	normalalpha = 0.5,
	updaterate = 0.2,
	x_point = -165 - 20,
	y_point = -300,
	width = 90,
	height = 12,
	barcolor = { r = 0.5, g = 0.5, b = 0.5 },
	statinfos = {
		stat = { abbr = "S", color = { r = 1, g = 1, b = 0 } },
		crit = { abbr = "C", color = { r = 1, g = 0, b = 0 } },
		haste = { abbr = "H", color = { r = 0, g = 1, b = 0 } },
		mastery = { abbr = "M", color = { r = 0.5, g = 0, b = 1 } },
		vers = { abbr = "V", color = { r = 0, g = 0, b = 1 } },
	},
};

local gvalues = {
	historys = { stat = {}, crit = {}, haste = {}, mastery = {}, vers = {} },
	minstats = { stat = nil, crit = nil, haste = nil, mastery = nil, vers = nil },
}

local main_frame = CreateFrame("Frame", "asInformationFrame", UIParent);
main_frame:SetFrameStrata("LOW");
main_frame:SetSize(configs.width, (configs.height + 2) * 5);
main_frame:SetPoint("CENTER", UIParent, "CENTER", configs.x_point, configs.y_point);

local function create_bar(name, parent, config)
	local bar = CreateFrame("StatusBar", "asInformation" .. name .. "Bar", parent);
	bar:SetSize(configs.width, configs.height)
	bar:SetStatusBarTexture("RaidFrame-Hp-Fill")
	bar:SetStatusBarColor(config.color.r, config.color.g, config.color.b);

	bar.minbar = CreateFrame("StatusBar", nil, bar);
	bar.minbar:SetAllPoints(bar)
	bar.minbar:SetStatusBarTexture("RaidFrame-Hp-Fill")
	bar.minbar:SetStatusBarColor(configs.barcolor.r, configs.barcolor.g, configs.barcolor.b);
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
	ns.primarybar = create_bar("PrimaryStat", main_frame, configs.statinfos.stat)
	ns.critbar = create_bar("Crit", main_frame, configs.statinfos.crit)
	ns.hastebar = create_bar("Haste", main_frame, configs.statinfos.haste)
	ns.masterybar = create_bar("Mastery", main_frame, configs.statinfos.mastery)
	ns.versbar = create_bar("Versatility", main_frame, configs.statinfos.vers)
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
	local incombat = UnitAffectingCombat("player");

	if not incombat then
		local currstats = {
			stat = get_primarystat(),
			crit = get_crit(),
			haste = GetHaste(),
			mastery = GetMasteryEffect(),
			vers = GetCombatRatingBonus(CR_VERSATILITY_DAMAGE_DONE),
		}


		for name, value in pairs(currstats) do
			if not issecretvalue(value) then
				local snapshot = { value = value }
				table.insert(gvalues.historys[name], 1, snapshot)

				local listcount = #gvalues.historys[name];

				if listcount > 100 then
					table.remove(gvalues.historys[name], listcount);
				end
			end
		end

		for name, history in pairs(gvalues.historys) do
			local min = nil
			for _, snapshot in ipairs(history) do
				if min == nil or (snapshot.value < min and snapshot.value > 0) then
					min = snapshot.value
				end
			end
			gvalues.minstats[name] = min
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

	if ns.options.showCrit then update_bar(ns.critbar, crit, gvalues.minstats.crit, 100, "%.2f%%") end
	if ns.options.showHaste then update_bar(ns.hastebar, haste, gvalues.minstats.haste, 100, "%.2f%%") end
	if ns.options.showMastery then update_bar(ns.masterybar, mastery, gvalues.minstats.mastery, 100, "%.2f%%") end
	if ns.options.showVer then update_bar(ns.versbar, versatility, gvalues.minstats.vers, 100, "%.2f%%") end

	if ns.options.showPrimary then
		local min = gvalues.minstats.stat or 0;
		local max = min * 2;
		update_bar(ns.primarybar, pristat, min, max, "%d");
	end
end

local function on_update()
	check_reposition();
	recode_stats();
	update_stats();
end


local function on_event()
	if UnitAffectingCombat("player") then
		main_frame:SetAlpha(configs.combatalpha);
	else
		main_frame:SetAlpha(configs.normalalpha);
	end
end


local function init()
	ns.setup_option();
	init_frames();

	local libasConfig = LibStub:GetLibrary("LibasConfig", true);

	if libasConfig then
		libasConfig.load_position(main_frame, "asInformation", AINF_Position);
	end

	main_frame:RegisterEvent("PLAYER_ENTERING_WORLD")
	main_frame:RegisterEvent("PLAYER_REGEN_DISABLED");
	main_frame:RegisterEvent("PLAYER_REGEN_ENABLED");
	on_event();
	main_frame:SetScript("OnEvent", on_event)

	C_Timer.NewTicker(configs.updaterate, on_update);
end

C_Timer.After(1, init);
