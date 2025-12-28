local configs = {
	width = 238,
	height = 5,
	xpoint = 0,
	ypoint = -219,
};

local main_frame = CreateFrame("FRAME", nil, UIParent)
main_frame:SetPoint("BOTTOM", UIParent, "BOTTOM", 0, 0)
main_frame:SetWidth(0)
main_frame:SetHeight(0)
main_frame:Show();

main_frame.gcdbar = CreateFrame("StatusBar", nil, UIParent)
main_frame.gcdbar:SetStatusBarTexture("RaidFrame-Hp-Fill")
main_frame.gcdbar:GetStatusBarTexture():SetHorizTile(false)
main_frame.gcdbar:SetMinMaxValues(0, 100)
main_frame.gcdbar:SetValue(0)
main_frame.gcdbar:SetHeight(configs.height)
main_frame.gcdbar:SetWidth(configs.width)
main_frame.gcdbar:SetStatusBarColor(1, 0.9, 0.9);

main_frame.gcdbar.bg = main_frame.gcdbar:CreateTexture(nil, "BACKGROUND")
main_frame.gcdbar.bg:SetPoint("TOPLEFT", main_frame.gcdbar, "TOPLEFT", -1, 1)
main_frame.gcdbar.bg:SetPoint("BOTTOMRIGHT", main_frame.gcdbar, "BOTTOMRIGHT", 1, -1)

main_frame.gcdbar.bg:SetTexture("Interface\\Addons\\asGCDBar\\border.tga")
main_frame.gcdbar.bg:SetTexCoord(0.1, 0.1, 0.1, 0.1, 0.1, 0.1, 0.1, 0.1)
main_frame.gcdbar.bg:SetVertexColor(0, 0, 0, 0.8);

main_frame.gcdbar:SetPoint("CENTER", UIParent, "CENTER", configs.xpoint, configs.ypoint)
main_frame.gcdbar:Show();

C_AddOns.LoadAddOn("asMOD");

if asMOD_setupFrame then
	asMOD_setupFrame(main_frame.gcdbar, "asGCDBar");
end

local function on_update()
	local durationinfo = C_Spell.GetSpellCooldownDuration(61304);
	main_frame.gcdbar:SetTimerDuration(durationinfo, Enum.StatusBarInterpolation.ExponentialEaseOut);
end

C_Timer.NewTicker(0.1, on_update);
