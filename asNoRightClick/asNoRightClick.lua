local configs = {
	doubleclicktime = 0.4,
};

local lasttime = 0;

local function stop_click()
	lasttime = GetTime();
	MouselookStop()
end

WorldFrame:HookScript("OnMouseUp", function(self, button)
	if button == "RightButton" then
		if UnitAffectingCombat("player") then
			if configs.doubleclicktime + lasttime < GetTime() then
				stop_click()
			end
		end
	end
end)
