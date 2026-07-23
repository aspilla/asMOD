local _, ns = ...;
local configs = {
	size = 40,
    xpoint = -240,
    ypoint = -305,
	alpha = 1,
	cool_fontsize = 12,
	spellid = 20484,
}

local main_button = CreateFrame("Button", nil, UIParent, "asBattleResFrameTemplate");



local function set_cooldownframe(cooldown, durationobject, enable)
	if enable and durationobject then
		cooldown:SetDrawEdge(nil);
		cooldown:SetCooldownFromDurationObject(durationobject);
	else
		cooldown:Clear();
	end
end

local function on_update()
	if IsInGroup() then
		main_button:Show();
	else
		main_button:Hide();
		return;
	end

	local count = C_Spell.GetSpellDisplayCount(configs.spellid);
	local chargeinfo = C_Spell.GetSpellCharges(configs.spellid);
	local chargeduration = C_Spell.GetSpellChargeDuration(configs.spellid);


	main_button.count:SetText(count);
	main_button.count:Show();
	main_button.icon:SetDesaturated(false);

	if chargeinfo then
		main_button.cooldown:Show();
		set_cooldownframe(main_button.cooldown, chargeduration, true);
	else
		main_button.cooldown:Hide();
	end
end

local function init()
	ns.setup_option();

	main_button:SetFrameStrata("LOW");
	main_button:EnableMouse(true);
	main_button:RegisterForDrag("LeftButton");
	main_button:SetMovable(true);

	main_button.cooldown:SetHideCountdownNumbers(false);
	main_button.cooldown:SetDrawSwipe(true);

	if ns.options.MillisecondsThreshold then
		main_button.cooldown:SetCountdownMillisecondsThreshold(ns.options.MillisecondsThreshold);
	end

	for _, r in next, { main_button.cooldown:GetRegions() } do
		if r:GetObjectType() == "FontString" then
			r:SetFont(STANDARD_TEXT_FONT, configs.cool_fontsize, "OUTLINE");
			r:SetDrawLayer("OVERLAY");
			break
		end
	end

	main_button.icon:SetTexCoord(.08, .92, .08, .92);
	main_button.border:SetTexCoord(0.08, 0.08, 0.08, 0.92, 0.92, 0.08, 0.92, 0.92);
	main_button.border:SetVertexColor(0, 0, 0);

	main_button.count:SetFont(STANDARD_TEXT_FONT, configs.cool_fontsize, "OUTLINE")
	main_button.count:ClearAllPoints();
	main_button.count:SetPoint("BOTTOMRIGHT", main_button, "BOTTOMRIGHT", -3, 3);

	main_button:SetPoint("CENTER", configs.xpoint, configs.ypoint)
	main_button:SetWidth(configs.size);
	main_button:SetHeight(configs.size * 0.9);
	main_button:SetAlpha(configs.alpha);

	local libasConfig = LibStub:GetLibrary("LibasConfig", true);

	if libasConfig then
		libasConfig.load_position(main_button, "asBattleRes", ASBR_Position);
	end

	local spellInfo = C_Spell.GetSpellInfo(configs.spellid);

	if spellInfo then
		main_button.icon:SetTexture(spellInfo.iconID);
		C_Timer.NewTicker(0.25, on_update);
	end
end

C_Timer.After(0.5, init);
