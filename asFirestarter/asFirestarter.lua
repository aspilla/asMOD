local _, ns = ...;

local configs = {
	updaterate = 0.2,
	maxshow = 2,
	xpoint = 0,
	ypoint = -60,
	baseframelevel = 1000,
	alpha = 1,
};


local main_frame = CreateFrame("Frame", nil, UIParent);
ns.buttons       = {}
local hcurve     = C_CurveUtil.CreateCurve();
hcurve:SetType(Enum.LuaCurveType.Linear);
hcurve:AddPoint(0, 0);
hcurve:AddPoint(1, 100);

local function on_update()
	for i = 1, configs.maxshow do
		local button = ns.buttons[i];
		local curve = button.curve;

		if curve then
			if UnitExists("target") and UnitCanAttack("player", "target") and not UnitIsDead("target") then
				local alpha = UnitHealthPercent("target", true, curve);

				button:Show();
				button:SetAlpha(alpha);
				if ns.options.ShowHealth then
					local pct = UnitHealthPercent("target", true, hcurve);
					button.health:SetText(string.format("%.1f", pct));
				else
					button.health:Hide();
				end
			else
				button:Hide();
			end
		end
	end
end

local function setup_button(spellid, currshow, percentage, high)
	local spellinfo = C_Spell.GetSpellInfo(spellid);

	if not spellinfo then
		return currshow;
	end

	local button = ns.buttons[currshow];
	button.icon:SetTexture(spellinfo.iconID);

	button:SetAlpha(0);
	button:Show();

	if high then
		button.curve = C_CurveUtil.CreateCurve();
		button.curve:SetType(Enum.LuaCurveType.Step);
		button.curve:AddPoint(percentage / 100, 1.0);
		button.curve:AddPoint(0.0, 0.0);
	else
		button.curve = C_CurveUtil.CreateCurve();
		button.curve:SetType(Enum.LuaCurveType.Step);
		button.curve:AddPoint(percentage / 100, 0.0);
		button.curve:AddPoint(0.0, 1.0);
	end

	return currshow + 1;
end

local function init_lowhealth()
	local localizedClass, englishClass = UnitClass("player");
	local currshow = 1;

	for i = 1, configs.maxshow do
		ns.buttons[i]:Hide();
		ns.buttons[i].curve = nil;
	end


	do
		if (englishClass == "MAGE") then
			if (C_SpellBook.IsSpellKnown(2948)) or (C_SpellBook.IsSpellKnown(450746)) then
				currshow = setup_button(2948, currshow, 30, false);
			end

			if (C_SpellBook.IsSpellKnown(205026)) then
				currshow = setup_button(205026, currshow, 90, true);
			end
		end
	end
end



local function on_event(self, event, ...)
	init_lowhealth();
end


local function init()
	ns.setup_option();

	for i = 1, configs.maxshow do
		ns.buttons[i] = CreateFrame("Button", nil, main_frame, "asFirestarterTemplate");
		local button = ns.buttons[i];
		button:SetFrameLevel(configs.baseframelevel - i)
		button.icon:SetTexCoord(.08, .92, .16, .84);

		button.health:SetFont(STANDARD_TEXT_FONT, ns.options.FontSize, "OUTLINE")
		button.health:ClearAllPoints();
		button.health:SetPoint("CENTER", button, "CENTER", 0, 0);
		button.health:Show();
		button.border:SetTexCoord(0.08, 0.08, 0.08, 0.92, 0.92, 0.08, 0.92, 0.92);
		button.border:SetVertexColor(0, 0, 0);
		button.border:Show();
		button:SetPoint("CENTER", main_frame, "CENTER", 0, 0);
		button:EnableMouse(false);
		button:SetAlpha(0);
		button:SetSize(ns.options.Size, ns.options.Size * 0.9)
		button:Show();
	end

	main_frame:SetFrameStrata("LOW");
	main_frame:SetPoint("CENTER", UIParent, "CENTER", configs.xpoint, configs.ypoint);
	main_frame:SetAlpha(configs.alpha);
	main_frame:SetSize(1, 1);
	main_frame:EnableMouse(false);
	main_frame:Show();

	main_frame:RegisterEvent("TRAIT_CONFIG_UPDATED");
	main_frame:RegisterEvent("TRAIT_CONFIG_LIST_UPDATED");
	main_frame:RegisterEvent("ACTIVE_TALENT_GROUP_CHANGED");

	main_frame:SetScript("OnEvent", on_event)

	local libasConfig = LibStub:GetLibrary("LibasConfig", true);

	if libasConfig then
		libasConfig.load_position(main_frame, "asFirestarter", AFS_Positions);
	end

	init_lowhealth();

	C_Timer.NewTicker(configs.updaterate, on_update);
end

C_Timer.After(0.5, init);
