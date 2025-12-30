local _, ns = ...;
local configs = {
	size = 40,
	xpoint = -365,
	ypoint = -197,
	fonts = {
		[1] = STANDARD_TEXT_FONT,
		[2] = UNIT_NAME_FONT,
		[3] = DAMAGE_TEXT_FONT,
	},
};


-- 옵션끝
local main_frame = CreateFrame("Frame", nil, UIParent);

-- Function to load saved position
local function load_position(frame, option)
	frame:ClearAllPoints()
	frame:SetPoint(option.point, UIParent, option.relativePoint, option.xOfs,
		option.yOfs)
end

-- Function to save position
local function save_position(frame, option)
	local point, _, relativePoint, xOfs, yOfs = frame:GetPoint()
	option.point = point
	option.relativePoint = relativePoint
	option.xOfs = xOfs
	option.yOfs = yOfs
end

ns.updateOptions = function()
	main_frame.timertext:SetFont(configs.fonts[ns.options.Font], ns.options.FontSize, "OUTLINE");
end

local bMouseEnabled = true;
local combat_start_time = nil;
local combat_end_time = nil;
local encounter_start_time = nil;
local encounter_end_time = nil;

-- Function to format seconds into HH:MM:SS
local function format_time(seconds)
	seconds = math.floor(seconds);
	local minutes = math.floor((seconds % 3600) / 60);
	local secs = seconds % 60;
	return string.format("[%02d:%02d]", minutes, secs);
end

local function on_update()
	local timertext = main_frame.timertext;
	if ns.options.LockWindow then
		if bMouseEnabled then
			main_frame:EnableMouse(false);
			bMouseEnabled = false;
		end
	else
		if not bMouseEnabled then
			main_frame:EnableMouse(true);
			bMouseEnabled = true;
		end
	end

	if ns.options.ShowWhenCombat and not ns.options.LockWindow then
		if InCombatLockdown() then
			main_frame:Show();
		else
			main_frame:Hide();
		end
	else
		main_frame:Show();
	end

	local time_sec = 0;

	if encounter_start_time and encounter_end_time == nil then
		time_sec = GetTime() - encounter_start_time;
	elseif encounter_start_time and encounter_end_time and combat_start_time and encounter_end_time > combat_start_time then
		time_sec = encounter_end_time - encounter_start_time;
	elseif combat_start_time and combat_end_time == nil then
		time_sec = GetTime() - combat_start_time;
	elseif combat_start_time and combat_end_time then
		time_sec = combat_end_time - combat_start_time;
	end

	if time_sec >= 0 then
		timertext:SetText(format_time(time_sec));
	end
end


local function on_event(self, event)
	if event == "PLAYER_REGEN_DISABLED" then
		combat_start_time = GetTime();
		combat_end_time = nil;
	elseif event == "PLAYER_REGEN_ENABLED" then
		combat_end_time = GetTime();
	elseif event == "ENCOUNTER_START" then
		encounter_start_time = GetTime();
		encounter_end_time = nil;
	elseif event == "ENCOUNTER_END" then
		encounter_end_time = GetTime();
	else
		encounter_end_time = GetTime();
		combat_end_time = GetTime();
	end
end

local function init()
	ASTM_Position = ASTM_Position or {
		point = "CENTER",
		relativePoint = "CENTER",
		xOfs = configs.xpoint,
		yOfs = configs.ypoint,
	}

	ns.setup_option();
	C_AddOns.LoadAddOn("asMOD");

	main_frame:EnableMouse(true);
	main_frame:RegisterForDrag("LeftButton");
	main_frame:SetMovable(true);

	main_frame.timertext = main_frame:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
	main_frame.timertext:ClearAllPoints();
	main_frame.timertext:SetPoint("CENTER", main_frame, "CENTER", 0, 0);
	main_frame.timertext:SetTextColor(1, 1, 1);
	main_frame.timertext:SetText("[00:00]");
	main_frame.timertext:Show();

	main_frame:SetPoint("CENTER", configs.xpoint, configs.ypoint)
	main_frame:SetWidth(configs.size);
	main_frame:SetHeight(configs.size * 0.9);
	main_frame:SetScale(1);
	main_frame:Show();



	main_frame:SetScript("OnDragStart", function(self)
		if not ns.options.LockWindow then
			self:StartMoving()
			self.isMoving = true
		end
	end)

	main_frame:SetScript("OnDragStop", function(self)
		if self.isMoving then
			self:StopMovingOrSizing()
			self.isMoving = false
			save_position(main_frame, ASTM_Position);
		end
	end)

	ns.updateOptions();

	load_position(main_frame, ASTM_Position);

	if asMOD_setupFrame then
		asMOD_setupFrame(main_frame, "asCombatTimer");
	end

	main_frame:RegisterEvent("PLAYER_REGEN_DISABLED");
	main_frame:RegisterEvent("PLAYER_REGEN_ENABLED");
	main_frame:RegisterEvent("ENCOUNTER_START");
	main_frame:RegisterEvent("ENCOUNTER_END");
	main_frame:RegisterEvent("PLAYER_ENTERING_WORLD");
	main_frame:SetScript("OnEvent", on_event)


	C_Timer.NewTicker(0.1, on_update);
end

C_Timer.After(0.5, init);
