local _, ns = ...;

--lib
local fadeframes = {};
local timer = nil;

local function removeframe(frame)
	tDeleteItem(fadeframes, frame);
end

local function onfadeupdate()
	local index = 1;
	local frame, fadeInfo;
	local elapsed = 0.1;
	while fadeframes[index] do
		frame = fadeframes[index];
		fadeInfo = fadeframes[index].fadeInfo;
		-- Reset the timer if there isn't one, this is just an internal counter
		if (not fadeInfo.fadeTimer) then
			fadeInfo.fadeTimer = 0;
		end
		fadeInfo.fadeTimer = fadeInfo.fadeTimer + elapsed;

		-- If the fadeTimer is less then the desired fade time then set the alpha otherwise hold the fade state, call the finished function, or just finish the fade
		if (fadeInfo.fadeTimer < fadeInfo.timeToFade) then
			if (fadeInfo.mode == "IN") then
				frame:SetAlpha((fadeInfo.fadeTimer / fadeInfo.timeToFade) * (fadeInfo.endAlpha - fadeInfo.startAlpha) +
					fadeInfo.startAlpha);
			elseif (fadeInfo.mode == "OUT") then
				frame:SetAlpha(((fadeInfo.timeToFade - fadeInfo.fadeTimer) / fadeInfo.timeToFade) *
					(fadeInfo.startAlpha - fadeInfo.endAlpha) + fadeInfo.endAlpha);
			end
		else
			frame:SetAlpha(fadeInfo.endAlpha);
			-- If there is a fadeHoldTime then wait until its passed to continue on
			if (fadeInfo.fadeHoldTime and fadeInfo.fadeHoldTime > 0) then
				fadeInfo.fadeHoldTime = fadeInfo.fadeHoldTime - elapsed;
			else
				-- Complete the fade and call the finished function if there is one
				removeframe(frame);
				if (fadeInfo.finishedFunc) then
					fadeInfo.finishedFunc(fadeInfo.finishedArg1, fadeInfo.finishedArg2, fadeInfo.finishedArg3,
						fadeInfo.finishedArg4);
					fadeInfo.finishedFunc = nil;
				end
			end
		end

		index = index + 1;
	end

	if (#fadeframes == 0) then
		if timer then
			timer:Cancel();
		end
	end
end


local function dofade(frame, fadeInfo)
	if (not frame) then
		return;
	end
	if (not fadeInfo.mode) then
		fadeInfo.mode = "IN";
	end
	local alpha;
	if (fadeInfo.mode == "IN") then
		if (not fadeInfo.startAlpha) then
			fadeInfo.startAlpha = 0;
		end
		if (not fadeInfo.endAlpha) then
			fadeInfo.endAlpha = 1.0;
		end
		alpha = 0;
	elseif (fadeInfo.mode == "OUT") then
		if (not fadeInfo.startAlpha) then
			fadeInfo.startAlpha = 1.0;
		end
		if (not fadeInfo.endAlpha) then
			fadeInfo.endAlpha = 0;
		end
		alpha = 1.0;
	end
	frame:SetAlpha(fadeInfo.startAlpha);

	frame.fadeInfo = fadeInfo;
	frame:Show();

	local index = 1;
	while fadeframes[index] do
		-- If frame is already set to fade then return
		if (fadeframes[index] == frame) then
			return;
		end
		index = index + 1;
	end
	tinsert(fadeframes, frame);
	if timer then
		timer:Cancel();
	end
	timer = C_Timer.NewTicker(0.1, onfadeupdate);
end

-- Convenience function to do a simple fade in
function ns.fadein(frame, timeToFade, startAlpha, endAlpha)
	local fadeInfo = {};
	fadeInfo.mode = "IN";
	fadeInfo.timeToFade = timeToFade;
	fadeInfo.startAlpha = startAlpha;
	fadeInfo.endAlpha = endAlpha;
	dofade(frame, fadeInfo);
end

-- Convenience function to do a simple fade out
function ns.fadeout(frame, timeToFade, startAlpha, endAlpha)
	local fadeInfo = {};
	fadeInfo.mode = "OUT";
	fadeInfo.timeToFade = timeToFade;
	fadeInfo.startAlpha = startAlpha;
	fadeInfo.endAlpha = endAlpha;
	dofade(frame, fadeInfo);
end
