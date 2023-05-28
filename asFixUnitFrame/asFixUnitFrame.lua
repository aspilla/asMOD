PlayerFrame:UnregisterEvent("UNIT_COMBAT");
TargetFrame:UnregisterEvent("UNIT_COMBAT");
PetFrame:UnregisterEvent("UNIT_COMBAT");
TargetFrame:UnregisterEvent("UNIT_AURA");
local function asTargetFrame_UpdateBuffAnchor(self, buff)
	--For mirroring vertically
	buff:Hide();
end

hooksecurefunc("TargetFrame_UpdateBuffAnchor", asTargetFrame_UpdateBuffAnchor);
hooksecurefunc("TargetFrame_UpdateDebuffAnchor", asTargetFrame_UpdateBuffAnchor);