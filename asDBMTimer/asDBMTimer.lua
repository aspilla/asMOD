local _, ns = ...;

local configs = {
	font = STANDARD_TEXT_FONT,
	coolfontsize = 15,
	namefontsize = 12,
	fontoutline = "THICKOUTLINE",
	maxshow = 3,
	xpoint = 290,
	ypoint = 50,
	maxicons = 4,
	text_xpoint = 0,
	text_ypoint = 20,

}
-- 설정 끝

local function setupUI()
	ns.setup_option();

	ns.asDBMTimer = CreateFrame("FRAME", nil, UIParent);
	local timerframe = ns.asDBMTimer;
	timerframe:SetFrameStrata("LOW");
	timerframe:SetPoint("CENTER", UIParent, "CENTER", configs.xpoint, configs.ypoint)
	timerframe:SetWidth(100)
	timerframe:SetHeight(100)
	timerframe:Show();
	timerframe.buttons = {};

	for i = 1, configs.maxshow do
		timerframe.buttons[i] = CreateFrame("Button", nil, timerframe, "asDBMTimerFrameTemplate");
		local button = timerframe.buttons[i];
		button:SetWidth(ns.options.Size);
		button:SetHeight(ns.options.Size * 0.9);
		button:SetAlpha(1);
		button:EnableMouse(false);
		button:Hide();

		button.icon:SetTexCoord(.08, .92, .08, .92);
		button.border:SetTexCoord(0.08, 0.08, 0.08, 0.92, 0.92, 0.08, 0.92, 0.92);
		button.border:SetVertexColor(0, 0, 0);
		if i == 1 then
			button:SetPoint("CENTER", 0, 0);
		else
			button:SetPoint("RIGHT", timerframe.buttons[i - 1], "LEFT", -1, 0);
		end
		button.cooltext = button:CreateFontString(nil, "OVERLAY");
		button.cooltext:SetFont(configs.font, configs.coolfontsize, configs.fontoutline)
		button.cooltext:SetPoint("CENTER", button, "CENTER", 0, 0);

		button.text = button:CreateFontString(nil, "OVERLAY");
		button.text:SetFont(configs.font, configs.namefontsize, configs.fontoutline)
		button.text:SetPoint("LEFT", button, "BOTTOMLEFT", 0, -15);
		button.text:SetWidth(ns.options.Size);

		button.icons = {};
		for j = 1, configs.maxicons do
			button.icons[j] = button:CreateTexture(nil, "ARTWORK");
			button.icons[j]:SetSize(ns.options.Size / 2 - 2, ns.options.Size / 2 - 2);
			if j == 1 then
				button.icons[j]:SetPoint("BOTTOMLEFT", button, "TOPLEFT", 0, 1);
			elseif j == 3 then
				button.icons[j]:SetPoint("BOTTOMLEFT", button.icons[1], "TOPLEFT", 0, 1);
			else
				button.icons[j]:SetPoint("LEFT", button.icons[j - 1], "RIGHT", 1, 0);
			end
			if ns.options.ShowRole then
				button.icons[j]:Show();
			else
				button.icons[j]:Hide();
			end
		end

		button:EnableMouse(false);
	end

	local libasConfig = LibStub:GetLibrary("LibasConfig", true);

	if libasConfig then
		libasConfig.load_position(timerframe, "asDBMTimer", ADTI_Positions);
	end


	ns.asDBMText = CreateFrame("FRAME", nil, UIParent);
	local textframe = ns.asDBMText;

	textframe:SetFrameStrata("LOW");
	textframe:SetPoint("CENTER", UIParent, "CENTER", configs.text_xpoint, configs.text_ypoint)
	textframe:SetWidth(100)
	textframe:SetHeight(ns.options.TextSize);
	textframe:Show();

	textframe.text = textframe:CreateFontString(nil, "OVERLAY");
	textframe.text:SetFont(configs.font, ns.options.TextSize, configs.fontoutline)
	textframe.text:SetPoint("CENTER", textframe, "CENTER", 0, 0);
	textframe.text:Show();

	textframe.icons = {};
	for j = 1, configs.maxicons do
		textframe.icons[j] = textframe:CreateTexture(nil, "ARTWORK");
		textframe.icons[j]:SetSize(ns.options.TextSize, ns.options.TextSize);
		if j == 1 then
			textframe.icons[j]:SetPoint("RIGHT", textframe.text, "LEFT", -1, 0);
		else
			textframe.icons[j]:SetPoint("RIGHT", textframe.icons[j - 1], "LEFT", -1, 0);
		end
		if ns.options.ShowRole then
			textframe.icons[j]:Show();
		else
			textframe.icons[j]:Hide();
		end
	end

	if libasConfig then
		libasConfig.load_position(textframe, "asDBMTimer(Text)", ADTI_Positions2);
	end
end

local textinfo = {
	name = "",
	remain = nil,
	extime = nil,
	icon = nil,
}

local function check_list()
	local events = C_EncounterTimeline.GetEventList();
	local idx = 1;

	textinfo.remain = nil;
	textinfo.extime = nil;

	for _, id in pairs(events) do
		local remain = C_EncounterTimeline.GetEventTimeRemaining(id);
		local state = C_EncounterTimeline.GetEventState(id)

		if remain and remain < ns.options.MinTimetoShow and state and state < 2 then
			local eventinfo = C_EncounterTimeline.GetEventInfo(id);


			if eventinfo then
				local button = ns.asDBMTimer.buttons[idx];
				button.icon:SetTexture(eventinfo.iconFileID);
				button.cooltext:SetText(string.format("%.1f", remain));
				if ns.options.ShowName and eventinfo.spellID then
					button.text:SetText(string.format("%5s", C_Spell.GetSpellName(eventinfo.spellID)));
				else
					button.text:SetText("");
				end

				if ns.options.ShowRole then
					C_EncounterTimeline.SetEventIconTextures(id,
						Constants.EncounterTimelineIconMasks.EncounterTimelineAllIcons, button.icons);
				end

				if state == 0 and remain > 0 and (textinfo.remain == nil or textinfo.remain > remain) then
					textinfo.name = C_Spell.GetSpellName(eventinfo.spellID);
					textinfo.icon = eventinfo.iconFileID;
					textinfo.remain = remain;
					textinfo.extime = remain + GetTime();
					textinfo.eventid = id;
				end

				if ns.options.ShowButton then
					button:Show();
				else
					button:Hide();
				end
				idx = idx + 1;

				if idx > configs.maxshow then
					break;
				end
			end
		end
	end

	for i = idx, configs.maxshow do
		local button = ns.asDBMTimer.buttons[i];
		button:Hide();
	end
end

local function update_text()
	local textframe = ns.asDBMText;
	if ns.options.ShowText and textinfo.extime then
		local remain = textinfo.extime - GetTime();
		if remain > 0 and remain < ns.options.MinTimetoShow and textinfo.name and textinfo.icon then
			textframe.text:SetText(string.format("|T" .. textinfo.icon .. ":0|t %s %.1f", textinfo.name, remain));
			if ns.options.ShowRole then
				C_EncounterTimeline.SetEventIconTextures(textinfo.eventid,
					Constants.EncounterTimelineIconMasks.EncounterTimelineAllIcons, textframe.icons);
			end

			textframe:Show();
		else
			textframe:Hide();
		end
	else
		textframe:Hide();
	end
end


local function initAddon()
	setupUI();
	C_Timer.NewTicker(0.2, check_list);
	C_Timer.NewTicker(0.1, update_text);
end


C_Timer.After(0.5, initAddon);
