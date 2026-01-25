local configs = {
	size = 26,
	xpoint = 0,
	ypoint = -26,
	alpha = 0.9,
	fontsize = 10,
}

local main_frame = CreateFrame("Button", nil, parent, "asNextSkillFrameTemplate");

local function on_update()
	local nextspellid = C_AssistedCombat.GetNextCastSpell(false);

	local info = C_Spell.GetSpellInfo(nextspellid);
	if info then
		main_frame.icon:SetTexture(info.iconID);
		main_frame:Show();
	else
		main_frame:Hide();
	end
end

local function init()
	if ASNS_Positions == nil then
		ASNS_Positions = {};
	end

	local libasConfig = LibStub:GetLibrary("LibasConfig", true);

	if libasConfig then
		libasConfig.load_position(main_frame, "asNextSkill", ASNS_Positions);
	end

	C_Timer.NewTicker(0.2, on_update);
end

main_frame:EnableMouse(false);

for _, r in next, { main_frame.cooldown:GetRegions() } do
	if r:GetObjectType() == "FontString" then
		r:SetFont(STANDARD_TEXT_FONT, configs.fontsize, "OUTLINE");
		r:SetDrawLayer("OVERLAY");
		break
	end
end

main_frame.icon:SetTexCoord(.08, .92, .08, .92)
main_frame.icon:SetAlpha(configs.alpha);
main_frame.border:SetTexCoord(0.08, 0.08, 0.08, 0.92, 0.92, 0.08, 0.92, 0.92)
main_frame.border:SetVertexColor(0, 0, 0);
main_frame.cooldown:Show();

main_frame:ClearAllPoints();
main_frame:SetPoint("CENTER", UIParent, "CENTER", configs.xpoint, configs.ypoint);
main_frame:SetSize(configs.size, configs.size * 0.9);
main_frame:SetAlpha(configs.alpha);
main_frame:Show();

C_Timer.After(0.5, init);
