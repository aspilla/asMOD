local configs = {
	sounds = {
		[5] = "Interface\\AddOns\\asCountdown\\sounds\\5.mp3",
		[4] = "Interface\\AddOns\\asCountdown\\sounds\\4.mp3",
		[3] = "Interface\\AddOns\\asCountdown\\sounds\\3.mp3",
		[2] = "Interface\\AddOns\\asCountdown\\sounds\\2.mp3",
		[1] = "Interface\\AddOns\\asCountdown\\sounds\\1.mp3",
	}
}

if GetLocale() == "koKR" then
	configs.sounds = {
		[5] = "Interface\\AddOns\\asCountdown\\sounds_kr\\5.mp3",
		[4] = "Interface\\AddOns\\asCountdown\\sounds_kr\\4.mp3",
		[3] = "Interface\\AddOns\\asCountdown\\sounds_kr\\3.mp3",
		[2] = "Interface\\AddOns\\asCountdown\\sounds_kr\\2.mp3",
		[1] = "Interface\\AddOns\\asCountdown\\sounds_kr\\1.mp3",
	}
end

local gvalues = {
	endtime = nil,
	timers = {},
}

local main_frame = CreateFrame("Frame", nil, UIParent);

local function sound(sec)
	PlaySoundFile(configs.sounds[sec], "Master");
end

local function cancel_timers()
	for i = 1, 5 do
		local timer = gvalues.timers[i];
		if timer then
			timer:Cancel();
		end
	end
end

local function set_timers(total)
	cancel_timers();
	for i = 1, 5 do
		if total >= i then
			local func = function()
				sound(i);
			end
			gvalues.timers[i] = C_Timer.NewTicker(total - i, func, 1);
		end
	end

end



local function on_event(self, event, ...)
	if event == "START_PLAYER_COUNTDOWN" then
		local _, remain, total = ...;		
		set_timers(total);
	elseif event == "CANCEL_PLAYER_COUNTDOWN" then		
		cancel_timers();
	end
end

main_frame:RegisterEvent("START_PLAYER_COUNTDOWN");
main_frame:RegisterEvent("CANCEL_PLAYER_COUNTDOWN");
main_frame:SetScript("OnEvent", on_event);