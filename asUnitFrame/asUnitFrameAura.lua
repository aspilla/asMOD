local _, ns = ...;

ns.filters = {
	buff = AuraUtil.CreateFilterString(AuraUtil.AuraFilters.Helpful),
	harmful = AuraUtil.CreateFilterString(AuraUtil.AuraFilters.Harmful, AuraUtil.AuraFilters.Player),
	helpful = AuraUtil.CreateFilterString(AuraUtil.AuraFilters.Harmful),
};

function ns.update_auras(frame)
	local unit = frame.unit;
	if frame.debuffcontainer then
		if UnitCanAttack("player", unit) then
			frame.debuffcontainer:SetAuraGroupFilterString("auras", ns.filters.harmful);
		else
			frame.debuffcontainer:SetAuraGroupFilterString("auras", ns.filters.helpful);
		end

		frame.debuffcontainer:UpdateAllAuras();
	end

	if frame.buffcontainer then
		frame.buffcontainer:UpdateAllAuras();
	end
end
