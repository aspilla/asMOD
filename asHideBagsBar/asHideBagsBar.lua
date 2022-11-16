local function hideBagBar(show)

	if UnitInVehicle("player") then
		show = 1;
	end

	MicroButtonAndBagsBar:SetAlpha(show)
	CharacterMicroButton:SetAlpha(show)
	SpellbookMicroButton:SetAlpha(show)
	TalentMicroButton:SetAlpha(show)
	AchievementMicroButton:SetAlpha(show)
	QuestLogMicroButton:SetAlpha(show)
	GuildMicroButton:SetAlpha(show)
	LFDMicroButton:SetAlpha(show)
	CollectionsMicroButton:SetAlpha(show)
	EJMicroButton:SetAlpha(show)
	StoreMicroButton:SetAlpha(show)
	MainMenuMicroButton:SetAlpha(show)

end


local function OnEnter()
	hideBagBar(1)
end
local function OnLeave()
	hideBagBar(0)
end


local update = 0;

local function OnUpdate(self, elapsed)
		
	update = update + elapsed;

	if update >= 0.5 then
		update = 0;

		local uiScale, x, y = UIParent:GetEffectiveScale(), GetCursorPosition()

		x =	x / uiScale;
		y = y / uiScale;

		x = UIParent:GetWidth() - x;

		local bagx, bagy = MicroButtonAndBagsBar:GetSize();

		if x < bagx and y < bagy then
			hideBagBar(1);

		else
			hideBagBar(0);
		end
	end
end

local bagframe;

hideBagBar(0);

bagframe = CreateFrame("Frame", "asBagHide", UIParent)
bagframe:SetScript("OnUpdate", OnUpdate);
