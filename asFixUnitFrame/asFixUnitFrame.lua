function asFixUnitFrame_OnCombatEvent(self, event, flags, amount, type)

	local feedbackText = self.feedbackText;
	feedbackText:Hide();
end

PlayerFrame:UnregisterEvent("UNIT_COMBAT")
TargetFrame:UnregisterEvent("UNIT_COMBAT")
PetFrame:UnregisterEvent("UNIT_COMBAT")
