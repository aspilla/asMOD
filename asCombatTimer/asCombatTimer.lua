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

ns.update_options = function()
	main_frame.timertext:SetFont(configs.fonts[ns.options.Font], ns.options.FontSize, "OUTLINE");
end

local gvalues = {
	bmouseenabled = true,
	combatstart = nil,
	combatend = nil,
	encounterstart = nil,
	encounterend = nil,
}

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
		if gvalues.bmouseenabled then
			main_frame:EnableMouse(false);
			gvalues.bmouseenabled = false;
		end
	else
		if not gvalues.bmouseenabled then
			main_frame:EnableMouse(true);
			gvalues.bmouseenabled = true;
		end
	end

	if ns.options.ShowWhenCombat and ns.options.LockWindow then
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
		timertext:SetText(format_time(time_sec));
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
	ASTM_Position = ASTM_Position or {
		point = "CENTER",
		relativePoint = "CENTER",
		xOfs = configs.xpoint,
		yOfs = configs.ypoint,
	}

	ns.setup_option();	

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

	ns.update_options();

	load_position(main_frame, ASTM_Position);

	local libasConfig = LibStub:GetLibrary("LibasConfig", true);

	if libasConfig then
		libasConfig.load_position(main_frame, "asCombatTimer", ASTM_Position);
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
