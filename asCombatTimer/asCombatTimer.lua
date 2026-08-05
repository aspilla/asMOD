local _, ns = ...;
local configs = {
	size = 40,
	xpoint = 164,
	ypoint = -270,
	fonts = {
		[1] = STANDARD_TEXT_FONT,
		[2] = UNIT_NAME_FONT,
		[3] = DAMAGE_TEXT_FONT,
	},
	updaterate = 0.05
};


-- 옵션끝
local main_frame = CreateFrame("Frame", nil, UIParent);

ns.update_options = function()
	main_frame.timertext:SetFont(configs.fonts[ns.options.Font], ns.options.FontSize, "OUTLINE");
	if main_frame.timertext_sub then
		main_frame.timertext_sub:SetFont(configs.fonts[ns.options.Font], ns.options.FontSize * 0.8, "OUTLINE");
	end

	if main_frame.bg then
		main_frame.bg:ClearAllPoints();
		if ns.options.ShowSubSeconds then
			main_frame.bg:SetPoint("TOPLEFT", main_frame.timertext, "TOPLEFT", -6, 3);
			main_frame.bg:SetPoint("BOTTOMRIGHT", main_frame.timertext_sub, "BOTTOMRIGHT", 6, -3);
		else
			main_frame.bg:SetPoint("TOPLEFT", main_frame.timertext, "TOPLEFT", -6, 3);
			main_frame.bg:SetPoint("BOTTOMRIGHT", main_frame.timertext, "BOTTOMRIGHT", 6, -3);
		end
	end
end

local gvalues = {
	combatstart = nil,
	combatend = nil,
	encounterstart = nil,
	encounterend = nil,
}

-- Function to format seconds into HH:MM:SS
local function format_time(seconds)
	if ns.options.ShowSubSeconds then
		local minutes = math.floor((seconds % 3600) / 60);
		local secs = seconds % 60;
		local formatted_secs = string.format("%04.1f", secs);
		local main_part = string.format("%02d:%s.", minutes, formatted_secs:sub(1, -3));
		local sub_part = string.format("%s", formatted_secs:sub(-1));
		return main_part, sub_part;
	else
		seconds = math.floor(seconds);
		local minutes = math.floor((seconds % 3600) / 60);
		local secs = seconds % 60;
		return string.format("%02d:%02d", minutes, secs), nil;
	end
end

local function on_update()
	local timertext = main_frame.timertext;
	local timertext_sub = main_frame.timertext_sub;

	if ns.options.ShowWhenCombat then
		if InCombatLockdown() then
			main_frame:Show();
		else
			main_frame:Hide();
		end
	else
		main_frame:Show();
	end

	local time_sec = 0;

	if gvalues.encounterstart and gvalues.encounterend == nil then
		time_sec = GetTime() - gvalues.encounterstart;
	elseif gvalues.encounterstart and gvalues.encounterend and gvalues.combatstart and gvalues.encounterend > gvalues.combatstart then
		time_sec = gvalues.encounterend - gvalues.encounterstart;
	elseif gvalues.combatstart and gvalues.combatend == nil then
		time_sec = GetTime() - gvalues.combatstart;
	elseif gvalues.combatstart and gvalues.combatend then
		time_sec = gvalues.combatend - gvalues.combatstart;
	end

	if time_sec >= 0 then
		local main_part, sub_part = format_time(time_sec);
		timertext:SetText(main_part);
		if sub_part then
			timertext_sub:SetText(sub_part);
			timertext_sub:Show();
		else
			timertext_sub:SetText("");
			timertext_sub:Hide();
		end
	end
end


local function on_event(self, event)
	if event == "PLAYER_REGEN_DISABLED" then
		gvalues.combatstart = GetTime();
		gvalues.combatend = nil;
	elseif event == "PLAYER_REGEN_ENABLED" then
		gvalues.combatend = GetTime();
	elseif event == "ENCOUNTER_START" then
		gvalues.encounterstart = GetTime();
		gvalues.encounterend = nil;
	elseif event == "ENCOUNTER_END" then
		gvalues.encounterend = GetTime();
	else
		gvalues.encounterend = GetTime();
		gvalues.combatend = GetTime();
	end
end

local function init()
	ns.setup_option();

	main_frame:SetFrameStrata("LOW");

	main_frame.timertext = main_frame:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
	main_frame.timertext:ClearAllPoints();
	main_frame.timertext:SetPoint("LEFT", main_frame, "LEFT", 6, 0);
	main_frame.timertext:SetTextColor(1, 1, 1);

	main_frame.timertext_sub = main_frame:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
	main_frame.timertext_sub:ClearAllPoints();
	main_frame.timertext_sub:SetPoint("BOTTOMLEFT", main_frame.timertext, "BOTTOMRIGHT", 0, 0);
	main_frame.timertext_sub:SetTextColor(1, 1, 1);

	main_frame.bg = main_frame:CreateTexture(nil, "BACKGROUND");
	main_frame.bg:SetColorTexture(0.1, 0.1, 0.1, 0.8);

	if ns.options.ShowSubSeconds then
		main_frame.timertext:SetText("00:00.");
		main_frame.timertext_sub:SetText("0");
		main_frame.timertext_sub:Show();
	else
		main_frame.timertext:SetText("00:00");
		main_frame.timertext_sub:SetText("");
		main_frame.timertext_sub:Hide();
	end
	main_frame.timertext:Show();

	main_frame:SetPoint("CENTER", configs.xpoint, configs.ypoint)
	main_frame:SetWidth(configs.size);
	main_frame:SetHeight(configs.size * 0.9);
	main_frame:Show();

	ns.update_options();

	local libasConfig = LibStub:GetLibrary("LibasConfig", true);

	if libasConfig then
		libasConfig.load_position(main_frame, "asCombatTimer", ASTM_Position);
	end

	main_frame:RegisterEvent("PLAYER_REGEN_DISABLED");
	main_frame:RegisterEvent("PLAYER_REGEN_ENABLED");
	main_frame:RegisterEvent("ENCOUNTER_START");
	main_frame:RegisterEvent("ENCOUNTER_END");
	main_frame:RegisterEvent("PLAYER_ENTERING_WORLD");
	main_frame:SetScript("OnEvent", on_event);

	C_Timer.NewTicker(configs.updaterate, on_update);
end

C_Timer.After(0.5, init);
