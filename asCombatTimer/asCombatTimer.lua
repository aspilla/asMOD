local _, ns = ...;
local ASTM_SIZE = 40;
local ASTM_TimerFrame_X = -365
local ASTM_TimerFrame_Y = -197

-- 옵션끝
local ASTM_Frame;
local ASTM_Fonts = {
	[1] = STANDARD_TEXT_FONT,
	[2] = UNIT_NAME_FONT,
	[3] = DAMAGE_TEXT_FONT,
}

-- Function to load saved position
local function LoadPosition(frame, option)
	frame:ClearAllPoints()
	frame:SetPoint(option.point, UIParent, option.relativePoint, option.xOfs,
		option.yOfs)
end

-- Function to save position
local function SavePosition(frame, option)
	local point, _, relativePoint, xOfs, yOfs = frame:GetPoint()
	option.point = point
	option.relativePoint = relativePoint
	option.xOfs = xOfs
	option.yOfs = yOfs
end

ns.updateOptions = function()
	ASTM_Frame.timertext:SetFont(ASTM_Fonts[ns.options.Font], ns.options.FontSize, "OUTLINE");
end

local bMouseEnabled = true;
local combat_start_time = nil;
local combat_end_time = nil;
local encounter_start_time = nil;
local encounter_end_time = nil;

-- Function to format seconds into HH:MM:SS
local function FormatTime(seconds)
	seconds = math.floor(seconds);
	local hours = math.floor(seconds / 3600);
	local minutes = math.floor((seconds % 3600) / 60);
	local secs = seconds % 60;
	return string.format("[%02d:%02d]", minutes, secs);
end

local function ASTM_Update()
	local timertext = ASTM_Frame.timertext;
	if ns.options.LockWindow then
		if bMouseEnabled then
			ASTM_Frame:EnableMouse(false);
			bMouseEnabled = false;
		end
	else
		if not bMouseEnabled then
			ASTM_Frame:EnableMouse(true);
			bMouseEnabled = true;
		end
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
		timertext:SetText(FormatTime(time_sec));
	end
end


local function ASTM_OnEvent(self, event, arg1, ...)
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

local function ASTM_Init()
	ASTM_Position = ASTM_Position or {
		point = "CENTER",
		relativePoint = "CENTER",
		xOfs = ASTM_TimerFrame_X,
		yOfs = ASTM_TimerFrame_Y,
	}

	ns.SetupOptionPanels();
	C_AddOns.LoadAddOn("asMOD");


	ASTM_Frame = CreateFrame("Frame", nil, UIParent);
	ASTM_Frame:EnableMouse(true);
	ASTM_Frame:RegisterForDrag("LeftButton");
	ASTM_Frame:SetMovable(true);

	ASTM_Frame.timertext = ASTM_Frame:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
	ASTM_Frame.timertext:ClearAllPoints();
	ASTM_Frame.timertext:SetPoint("CENTER", ASTM_Frame, "CENTER", 0, 0);
	ASTM_Frame.timertext:SetTextColor(1, 1, 1);
	ASTM_Frame.timertext:SetText("[00:00]");
	ASTM_Frame.timertext:Show();

	ASTM_Frame:SetPoint("CENTER", ASTM_TimerFrame_X, ASTM_TimerFrame_Y)
	ASTM_Frame:SetWidth(ASTM_SIZE);
	ASTM_Frame:SetHeight(ASTM_SIZE * 0.9);
	ASTM_Frame:SetScale(1);
	ASTM_Frame:Show();



	ASTM_Frame:SetScript("OnDragStart", function(self)
		if not ns.options.LockWindow then
			self:StartMoving()
			self.isMoving = true
		end
	end)

	ASTM_Frame:SetScript("OnDragStop", function(self)
		if self.isMoving then
			self:StopMovingOrSizing()
			self.isMoving = false
			SavePosition(ASTM_Frame, ASTM_Position);
		end
	end)

	ns.updateOptions();

	LoadPosition(ASTM_Frame, ASTM_Position);

	if asMOD_setupFrame then
		asMOD_setupFrame(ASTM_Frame, "asCombatTimer");
	end

	ASTM_Frame:RegisterEvent("PLAYER_REGEN_DISABLED");
	ASTM_Frame:RegisterEvent("PLAYER_REGEN_ENABLED");
	ASTM_Frame:RegisterEvent("ENCOUNTER_START");
	ASTM_Frame:RegisterEvent("ENCOUNTER_END");
	ASTM_Frame:RegisterEvent("PLAYER_ENTERING_WORLD");
	ASTM_Frame:SetScript("OnEvent", ASTM_OnEvent)


	C_Timer.NewTicker(0.1, ASTM_Update);
end

C_Timer.After(0.5, ASTM_Init);
