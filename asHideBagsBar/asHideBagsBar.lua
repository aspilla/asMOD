local function AHBB_HideBagBar(show)

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

local function AHBB_OnUpdate()
		
	local uiScale, x, y = UIParent:GetEffectiveScale(), GetCursorPosition()

	x =	x / uiScale;
	y = y / uiScale;
	x = UIParent:GetWidth() - x;

	local bagx, bagy = MicroButtonAndBagsBar:GetSize();

	if x < bagx and y < bagy then
		AHBB_HideBagBar(1);
	else
		AHBB_HideBagBar(0);
	end
end

AHBB_HideBagBar(0);
C_Timer.NewTicker(0.5, AHBB_OnUpdate);