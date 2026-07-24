local _, ns = ...;

local configs = {
	font = STANDARD_TEXT_FONT,
	coolfontsize = 15,
	namefontsize = 12,
	fontoutline = "THICKOUTLINE",
	maxshow = 3,
	xpoint = -290,
	ypoint = 50,
	text_xpoint = 0,
	text_ypoint = 40,
	list_xpoint = 0,
	list_ypoint = 0,
	text_updaterate = 0.1,
	button_updaterate = 0.2,
}

local main_frame = CreateFrame("Frame", nil, UIParent);

local function createstring(listframe, i)
	listframe.texts[i] = listframe:CreateFontString(nil, "OVERLAY");
	listframe.texts[i]:SetFont(configs.font, ns.options.ListSize, configs.fontoutline);
	if i == 1 then
		listframe.texts[i]:SetPoint("TOPLEFT", listframe, "TOPLEFT", 0, 0);
	else
		listframe.texts[i]:SetPoint("TOPLEFT", listframe.texts[i - 1], "BOTTOMLEFT", 0, -1);
	end
	listframe.texts[i]:Hide();
end

local function setupUI()
	ns.setup_option();

	ns.timerframe = CreateFrame("FRAME", nil, UIParent);
	local timerframe = ns.timerframe;
	timerframe:SetFrameStrata("LOW");
	timerframe:SetPoint("CENTER", UIParent, "CENTER", configs.xpoint, configs.ypoint)
	timerframe:SetWidth(100)
	timerframe:SetHeight(100)
	timerframe:Show();
	timerframe.buttons = {};

	for i = 1, configs.maxshow do
		timerframe.buttons[i] = CreateFrame("Button", nil, timerframe, "asRaidTimerFrameTemplate");
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
			button:SetPoint("LEFT", timerframe.buttons[i - 1], "RIGHT", 1, 0);
		end
		button.cooltext = button:CreateFontString(nil, "OVERLAY");
		button.cooltext:SetFont(configs.font, configs.coolfontsize, configs.fontoutline)
		button.cooltext:SetPoint("CENTER", button, "CENTER", 0, 0);

		button.text = button:CreateFontString(nil, "OVERLAY");
		button.text:SetFont(configs.font, configs.namefontsize, configs.fontoutline)
		button.text:SetPoint("LEFT", button, "BOTTOMLEFT", 0, -15);
		button.text:SetWidth(ns.options.Size);

		button.icons = {};
		button:EnableMouse(false);
	end

	local libasConfig = LibStub:GetLibrary("LibasConfig", true);

	if libasConfig then
		libasConfig.load_position(timerframe, "asRaidTimer", ARTI_Positions);
	end


	ns.textframe = CreateFrame("FRAME", nil, UIParent);
	local textframe = ns.textframe;

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

	if libasConfig then
		libasConfig.load_position(textframe, "asRaidTimer(Text)", ARTI_Positions2);
	end

	ns.listframe = CreateFrame("FRAME", nil, UIParent);
	local listframe = ns.listframe;

	listframe:SetFrameStrata("LOW");
	listframe:SetPoint("TOPLEFT", UIParent, "TOPLEFT", configs.list_xpoint, configs.list_ypoint)
	listframe:SetWidth(100)
	listframe:SetHeight(ns.options.TextSize);
	listframe:Show();
	if libasConfig then
		libasConfig.load_position(listframe, "asRaidTimer(List)", ARTI_Positions3);
	end

	listframe.texts = {}
	for i = 1, 100 do
		createstring(listframe, i);
	end
end


local gvalues = {
	encounterstart = nil,
	data = nil,
	previdx = 1,
	textinfo = {
		name = "",
		remain = nil,
		extime = nil,
		icon = nil,
	},
}


local function check_list()
	local idx = 1;
	gvalues.textinfo.remain = nil;
	gvalues.textinfo.extime = nil;

	local info = gvalues.data;

	if gvalues.encounterstart and info then
		local currtime = GetTime() - gvalues.encounterstart;
		for i = gvalues.previdx, #(info.timeline) do
			local event = info.timeline[i];
			local remain = event.time - currtime;
			if remain and remain >= 0 and remain <= ns.options.MinTimetoShow then
				local button = ns.timerframe.buttons[idx];
				local spellinfo = C_Spell.GetSpellInfo(event.spellid);
				if spellinfo then
					button.icon:SetTexture(spellinfo.iconID);
					button.cooltext:SetText(string.format("%.1f", remain));
					if ns.options.ShowName and event.spellid then
						button.text:SetText(string.format("%5s", spellinfo.name));
					else
						button.text:SetText("");
					end
					if remain > 0 and (gvalues.textinfo.remain == nil or gvalues.textinfo.remain > remain) then
						gvalues.textinfo.name = spellinfo.name;
						gvalues.textinfo.icon = spellinfo.iconID;
						gvalues.textinfo.remain = remain;
						gvalues.textinfo.extime = remain + GetTime();
					end

					ns.listframe.texts[i + 1]:SetTextColor(1, 0, 0);


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
			elseif remain and remain < 0 then
				ns.listframe.texts[i + 1]:SetTextColor(1, 1, 1);
				gvalues.previdx = i + 1;
			elseif remain and remain > ns.options.MinTimetoShow then
				ns.listframe.texts[i + 1]:SetTextColor(1, 1, 0);
				break;
			end
		end
	end
	for i = idx, configs.maxshow do
		local button = ns.timerframe.buttons[i];
		button:Hide();
	end
end

local function update_text()
	local textframe = ns.textframe;
	if ns.options.ShowText and gvalues.textinfo.extime then
		local remain = gvalues.textinfo.extime - GetTime();
		if remain > 0 and remain < ns.options.MinTimetoShow and gvalues.textinfo.name and gvalues.textinfo.icon then
			textframe.text:SetText(string.format("|T" .. gvalues.textinfo.icon .. ":0|t %s %.1f", gvalues.textinfo.name,
				remain));
			textframe:Show();
		else
			textframe:Hide();
		end
	else
		textframe:Hide();
	end
end

local function format_time(seconds)
	seconds = math.floor(seconds);
	local minutes = math.floor((seconds % 3600) / 60);
	local secs = seconds % 60;
	return string.format("[%02d:%02d]", minutes, secs);
end

local function updatelist(data)
	if data then
		local text = data.info.Difficulty .. " " .. data.info.Name;
		ns.listframe.texts[1]:SetText(text);
		ns.listframe.texts[1]:Show();
		for i = 1, #(data.timeline) do
			text = "";
			local event = data.timeline[i];
			local textframe = ns.listframe.texts[i + 1];

			if textframe == nil then
				createstring(ns.listframe, i + 1);
				textframe = ns.listframe.texts[i + 1];
			end

			local spellinfo = C_Spell.GetSpellInfo(event.spellid);
			if spellinfo then
				textframe:SetText(string.format("%s |T" .. spellinfo.iconID .. ":0|t %s", format_time(event.time),
					spellinfo.name));
				textframe:SetTextColor(1, 1, 1);
				textframe:Show();
			end
		end
	end
end

local function hidelist()
	local frame = ns.listframe;
	for i = 1, #(frame.texts) do
		frame.texts[i]:Hide();
	end
end

local function on_event(_, event, eid, _, difficultyid)
	if event == "ENCOUNTER_START" then
		local spec = C_SpecializationInfo.GetSpecialization();
		if spec and ns.info and ns.info[spec] and eid and difficultyid then
			local did = 1;
			if difficultyid == 16 then
				did = 2;
			end
			if ns.info[spec][did] then
				local data = ns.infos[spec][did][eid];
				if data then
					updatelist(data);
					gvalues.encounterstart = GetTime();
					gvalues.data = data;
					gvalues.previdx = 1;
				end
			end
		end
	else
		hidelist();
		gvalues.encounterstart = nil;
	end
end

function ns.showtest(did, eid)
	if ns.listframe.texts[1]:IsShown() then
		hidelist();
		gvalues.encounterstart = nil;
	else
		local spec = C_SpecializationInfo.GetSpecialization();
		if eid and spec and did then
			local data = ns.infos[spec][did][eid];
			if data then
				updatelist(data);
				gvalues.encounterstart = GetTime();
				gvalues.data = data;
				gvalues.previdx = 1;
			end
		end
	end
end

function ns.deletetest(did, eid)
	local spec = C_SpecializationInfo.GetSpecialization();
	if eid and spec and did then
		ns.infos[spec][did][eid] = nil;
	end
	ARTI_Data = CopyTable(ns.infos);
	ns.refreshlist();
end

local function initAddon()
	setupUI();
	main_frame:RegisterEvent("ENCOUNTER_START");
	main_frame:RegisterEvent("ENCOUNTER_END");
	main_frame:RegisterEvent("PLAYER_ENTERING_WORLD");
	main_frame:SetScript("OnEvent", on_event);
	C_Timer.NewTicker(configs.button_updaterate, check_list);
	C_Timer.NewTicker(configs.text_updaterate, update_text);
end
C_Timer.After(0.5, initAddon);
