local lasttime = 0;

local function stop_click()
	lasttime = GetTime();
	MouselookStop()
end

WorldFrame:HookScript("OnMouseUp", function(self, button)
	if button == "RightButton" then
		if UnitAffectingCombat("player") then
			if 0.2 + lasttime < GetTime() then
				stop_click()
			end
		end
	end
end)
