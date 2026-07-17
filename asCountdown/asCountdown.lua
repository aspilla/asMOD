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

local function sound(sec)
	if configs.sounds[sec] then
		PlaySoundFile(configs.sounds[sec], "Master");
	end
end

local function hook_func(timer)
	local digit = floor(timer.time);
	if digit and not issecretvalue(digit) and digit <= 5 then
		sound(digit);
	end
end

hooksecurefunc("StartTimer_SetTexNumbers", hook_func);
