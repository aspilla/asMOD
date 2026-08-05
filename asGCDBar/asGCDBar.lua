local _, ns = ...;

local configs = {
	xpoint = 0,
	ypoint = -215,
	combatalpha = 1,
	normalalpha = 0.5,
};

local main_frame = CreateFrame("FRAME", nil, UIParent)

local function on_update()
	local durationinfo = C_Spell.GetSpellCooldownDuration(61304);
	main_frame.gcdbar:SetTimerDuration(durationinfo, ns.bartype);
end

local function on_event(self, event)
	if event == "PLAYER_REGEN_DISABLED" then
		if ns.options.CombatAlphaChange then
			main_frame:SetAlpha(configs.combatalpha);
		else
			main_frame:SetAlpha(1);
		end
	elseif event == "PLAYER_REGEN_ENABLED" then
		if ns.options.CombatAlphaChange then
			main_frame:SetAlpha(configs.normalalpha);
		else
			main_frame:SetAlpha(1);
		end
	elseif event == "PLAYER_ENTERING_WORLD" then
		if ns.options.CombatAlphaChange then
			if UnitAffectingCombat("player") then
				main_frame:SetAlpha(configs.combatalpha);
			else
				main_frame:SetAlpha(configs.normalalpha);
			end
		else
			main_frame:SetAlpha(1);
		end
	end
end

local function init()
	ns.setup_option();

	main_frame:SetFrameStrata("LOW");
	main_frame:SetPoint("BOTTOM", UIParent, "BOTTOM", 0, 0)
	main_frame:SetWidth(0)
	main_frame:SetHeight(0)
	main_frame:Show();

	main_frame.gcdbar = CreateFrame("StatusBar", nil, main_frame)
	main_frame.gcdbar:SetStatusBarTexture("RaidFrame-Hp-Fill")
	main_frame.gcdbar:GetStatusBarTexture():SetHorizTile(false)
	main_frame.gcdbar:SetMinMaxValues(0, 100)
	main_frame.gcdbar:SetValue(0)
	main_frame.gcdbar:SetHeight(ns.options.BarHeight)
	main_frame.gcdbar:SetWidth(ns.options.BarWidth)
	main_frame.gcdbar:SetStatusBarColor(1, 0.9, 0.9);

	main_frame.gcdbar.bg = main_frame.gcdbar:CreateTexture(nil, "BACKGROUND")
	main_frame.gcdbar.bg:SetPoint("TOPLEFT", main_frame.gcdbar, "TOPLEFT", -1, 1)
	main_frame.gcdbar.bg:SetPoint("BOTTOMRIGHT", main_frame.gcdbar, "BOTTOMRIGHT", 1, -1)
	main_frame.gcdbar.bg:SetColorTexture(0.1, 0.1, 0.1, 1);

	main_frame.gcdbar:SetPoint("CENTER", UIParent, "CENTER", configs.xpoint, configs.ypoint)
	main_frame.gcdbar:Show();

	if AGCDB_Positions == nil then
		AGCDB_Positions = {};
	end

	local libasConfig = LibStub:GetLibrary("LibasConfig", true);

	if libasConfig then
		libasConfig.load_position(main_frame.gcdbar, "asGCDBar", AGCDB_Positions);
	end

	main_frame:RegisterEvent("TRAIT_CONFIG_UPDATED");
	main_frame:RegisterEvent("TRAIT_CONFIG_LIST_UPDATED");
	main_frame:RegisterEvent("ACTIVE_TALENT_GROUP_CHANGED");
	main_frame:RegisterEvent("PLAYER_REGEN_DISABLED");
	main_frame:RegisterEvent("PLAYER_REGEN_ENABLED");
	main_frame:RegisterEvent("PLAYER_ENTERING_WORLD");
	main_frame:SetScript("OnEvent", on_event);
	C_Timer.NewTicker(0.1, on_update);

	if ns.options.CombatAlphaChange then
		if UnitAffectingCombat("player") then
			main_frame:SetAlpha(configs.combatalpha);
		else
			main_frame:SetAlpha(configs.normalalpha);
		end
	else
		main_frame:SetAlpha(1);
	end
end

C_Timer.After(0.5, init);
