local _, ns = ...;

-- Alpha animation stuff
local asFADEFRAMES = {};


local frameFadeManager = CreateFrame("FRAME");

local function asUIFrameFadeRemoveFrame(frame)
	tDeleteItem(asFADEFRAMES, frame);
end

local function asUIFrameFade_OnUpdate(self, elapsed)
	local index = 1;
	local frame, fadeInfo;
	while asFADEFRAMES[index] do
		frame = asFADEFRAMES[index];
		fadeInfo = asFADEFRAMES[index].fadeInfo;
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
				asUIFrameFadeRemoveFrame(frame);
				if (fadeInfo.finishedFunc) then
					fadeInfo.finishedFunc(fadeInfo.finishedArg1, fadeInfo.finishedArg2, fadeInfo.finishedArg3,
						fadeInfo.finishedArg4);
					fadeInfo.finishedFunc = nil;
				end
			end
		end

		index = index + 1;
	end

	if (#asFADEFRAMES == 0) then
		self:SetScript("OnUpdate", nil);
	end
end


-- Generic fade function
local function asUIFrameFade(frame, fadeInfo)
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
	while asFADEFRAMES[index] do
		-- If frame is already set to fade then return
		if (asFADEFRAMES[index] == frame) then
			return;
		end
		index = index + 1;
	end
	tinsert(asFADEFRAMES, frame);
	frameFadeManager:SetScript("OnUpdate", asUIFrameFade_OnUpdate);
end

-- Convenience function to do a simple fade in
function ns.asUIFrameFadeIn(frame, timeToFade, startAlpha, endAlpha)
	local fadeInfo = {};
	fadeInfo.mode = "IN";
	fadeInfo.timeToFade = timeToFade;
	fadeInfo.startAlpha = startAlpha;
	fadeInfo.endAlpha = endAlpha;
	asUIFrameFade(frame, fadeInfo);
end

-- Convenience function to do a simple fade out
function ns.asUIFrameFadeOut(frame, timeToFade, startAlpha, endAlpha)
	local fadeInfo = {};
	fadeInfo.mode = "OUT";
	fadeInfo.timeToFade = timeToFade;
	fadeInfo.startAlpha = startAlpha;
	fadeInfo.endAlpha = endAlpha;
	asUIFrameFade(frame, fadeInfo);
end