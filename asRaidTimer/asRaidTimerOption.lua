local _, ns = ...;
local Options_Default = {
	Version = 260706,
	MinTimetoShow = 10,
	Size = 50,
	TextSize = 15,
	ListSize = 13,
	ShowName = true,
	ShowButton = true,
	ShowText = true,
};

local L = {
	MinTimetoShow = "Minimum time to trigger the alert",
	Size = "[Button] Icon size",
	TextSize = "[Center] Text size",
	ListSize = "[TopLeft] List text size",
	ShowName = "[Button] Whether to display skill names",
	ShowButton = "[Button] Whether to display the icon",
	ShowText = "[Center] Whether to display text notifications in the center of the screen",
	Delete = "Delete",
	ShowHide = "Test/Hide",
	Import = "Import",
	Error = "[asRaidTimer] Invalid Syntax",
	Error2 = "[asRaidTimer] Not support phase 2 or bigger",
}


if GetLocale() == "koKR" then
	L = {
		MinTimetoShow = "최소 표시 시간",
		Size = "[버튼] 아이콘 크기",
		TextSize = "[중앙] 글자 크기",
		ListSize = "[좌상] 리스트 글자 크기",
		ShowName = "[버튼] 스킬명 표시 여부",
		ShowButton = "[버튼] 아이콘 표시 여부",
		ShowText = "[중앙] 화면가운데 글씨 알림 여부",
		Delete = "삭제",
		ShowHide = "테스트/숨기기",
		Import = "적용",
		Error = "[asRaidTimer] 잘못된 형식",
		Error2 = "[asRaidTimer] Phase 2 이상 미지원",
	}
end


ns.options = CopyTable(Options_Default);
ns.infos = {};

local tempoption = {};
local subpanel = CreateFrame("Frame")

local function parsestring(data_str)
	local encounter_data = {
		info = {},
		timeline = {},
	}

	local id = nil;
	local difficulty = 1;
	for line in string.gmatch(data_str, "[^\r\n]+") do
		if string.match(line, "^EncounterID") then
			for key, value in string.gmatch(line, "([^;:]+):([^;:]+)") do
				if key == "EncounterID" then
					id = tonumber(value);
					encounter_data.info[key] = id
				elseif key == "Difficulty" then
					if value == "Mythic" then
						difficulty = 2;
					end
					encounter_data.info[key] = value
				else
					encounter_data.info[key] = value
				end
			end
			if not encounter_data.info.EncounterID or not encounter_data.info.Name or not encounter_data.info.Difficulty then
				print(L "Error");
				return;
			end
		elseif string.match(line, "^time") then
			local row = {}
			for key, value in string.gmatch(line, "([^;:]+):([^;:]*)") do
				if value == "tag" then
					row[key] = value;
				elseif value ~= "" then
					row[key] = tonumber(value);
				else
					row[key] = nil
				end
			end
			if not row.time or not row.spellid then
				print(L "Error");
				return;
			elseif row.ph and row.ph > 1 then
				print(L "Error2");
				return;
			end
			table.insert(encounter_data.timeline, row)
		end
	end

	local spec = C_SpecializationInfo.GetSpecialization();
	if id and difficulty and spec then
		if ns.infos[spec] == nil then
			ns.infos[spec] = {};
		end

		if ns.infos[spec][difficulty] == nil then
			ns.infos[spec][difficulty] = {};
		end
		ns.infos[spec][difficulty][id] = encounter_data;
	end

	ARTI_Data = CopyTable(ns.infos);
	ns.refreshlist();
end

local gvalues = {
	textframes = {},
	buttonframes = {},
	delbuttonframes = {},
	framemax = 0,
};

local function setupline(panel, idx, infotext, did, eid)
	if gvalues.textframes[idx] == nil then
		gvalues.textframes[idx] = panel:CreateFontString(nil, "ARTWORK");
		gvalues.textframes[idx]:SetFont(STANDARD_TEXT_FONT, 10, "OUTLINE");
		gvalues.buttonframes[idx] = CreateFrame("Button", nil, panel, "UIPanelButtonTemplate")
		gvalues.delbuttonframes[idx] = CreateFrame("Button", nil, panel, "UIPanelButtonTemplate")
		gvalues.framemax = gvalues.framemax + 1;
	end

	local textframe = gvalues.textframes[idx];
	textframe:SetPoint("LEFT", panel, "TOPLEFT", 10, -(50 + 30 * idx))
	textframe:SetText(infotext);
	textframe:Show();
	local btn = gvalues.buttonframes[idx];
	btn:SetPoint("RIGHT", panel, "TOPRIGHT", -150, -(50 + 30 * idx))
	btn:SetText(L["ShowHide"])
	btn:SetWidth(100)
	btn:SetScript("OnClick", function()
		ns.showtest(did, eid);
	end);
	btn:Show();
	local dbtn = gvalues.delbuttonframes[idx];
	dbtn:SetPoint("RIGHT", panel, "TOPRIGHT", -50, -(50 + 30 * idx))
	dbtn:SetText(L["Delete"])
	dbtn:SetWidth(100)
	dbtn:SetScript("OnClick", function()
		ns.deletetest(did, eid);
	end);
	dbtn:Show();
end

local function hideline(idx)
	gvalues.textframes[idx]:Hide();
	gvalues.buttonframes[idx]:Hide();
	gvalues.delbuttonframes[idx]:Hide();
end


function ns.refreshlist()
	local spec = C_SpecializationInfo.GetSpecialization();
	local idx = 1;

	for did = 1, 2 do
		if ns.infos[spec] and ns.infos[spec][did] then
			for eid, data in pairs(ns.infos[spec][did]) do
				local text = "";
				for key, value in pairs(data.info) do
					text = text .. value .. " ";
				end

				setupline(subpanel, idx, text, did, eid);
				idx = idx + 1;
			end
		end
	end

	for i = idx, gvalues.framemax do
		hideline(i);
	end
end

local function SetupSubOption(panel)
	local curr_y = 0;
	local y_adder = -40;

	local title = panel:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
	title:SetPoint("TOP")
	title:SetText("List")

	curr_y = curr_y + y_adder;

	local x = 10;

	local editBox = CreateFrame("EditBox", nil, panel)
	do
		local editBoxLeft = editBox:CreateTexture(nil, "BACKGROUND")
		editBoxLeft:SetTexture(130959)
		editBoxLeft:SetHeight(32)
		editBoxLeft:SetWidth(32)
		editBoxLeft:SetPoint("LEFT", -14, 0)
		editBoxLeft:SetTexCoord(0, 0.125, 0, 1)
		local editBoxRight = editBox:CreateTexture(nil, "BACKGROUND")
		editBoxRight:SetTexture(130960)
		editBoxRight:SetHeight(32)
		editBoxRight:SetWidth(32)
		editBoxRight:SetPoint("RIGHT", 6, 0)
		editBoxRight:SetTexCoord(0.875, 1, 0, 1)
		local editBoxMiddle = editBox:CreateTexture(nil, "BACKGROUND")
		editBoxMiddle:SetTexture(130960)
		editBoxMiddle:SetHeight(32)
		editBoxMiddle:SetWidth(1)
		editBoxMiddle:SetPoint("LEFT", editBoxLeft, "RIGHT")
		editBoxMiddle:SetPoint("RIGHT", editBoxRight, "LEFT")
		editBoxMiddle:SetTexCoord(0, 0.9375, 0, 1)
	end

	editBox:SetHeight(32)
	editBox:SetWidth(400)
	editBox:SetPoint("LEFT", panel, "TOPLEFT", x, curr_y)
	editBox:SetFontObject("GameFontHighlight")
	editBox:SetMultiLine(true);
	editBox:SetMaxLetters(20000);
	editBox:SetText("");
	editBox:SetAutoFocus(false);
	editBox:ClearFocus();
	editBox:SetTextInsets(0, 0, 0, 1);
	editBox:Show();
	editBox:SetCursorPosition(0);

	local btn = CreateFrame("Button", nil, panel, "UIPanelButtonTemplate")
	btn:SetPoint("RIGHT", panel, "TOPRIGHT", -150, curr_y)
	btn:SetText(L["Import"])
	btn:SetWidth(100)
	btn:SetScript("OnClick", function()
		local strtext = editBox:GetText();
		parsestring(strtext);
		editBox:SetText("");
	end);

	ns.refreshlist();
end

function ns.setup_option()
	local function OnSettingChanged(_, setting, value)
		local function get_variable_from_cvar_name(cvar_name)
			local variable_start_index = string.find(cvar_name, "_") + 1
			local variable = string.sub(cvar_name, variable_start_index)
			return variable
		end

		local cvar_name = setting:GetVariable()
		local variable = get_variable_from_cvar_name(cvar_name)
		ARTI_Options[variable] = value;
		ns.options[variable] = value;
	end

	local category = Settings.RegisterVerticalLayoutCategory("asRaidTimer")
	local _, _ = Settings.RegisterCanvasLayoutSubcategory(category, subpanel, "Timer Data");

	if ARTI_Options == nil or Options_Default.Version ~= ARTI_Options.Version then
		ARTI_Options = {}
		ARTI_Options = CopyTable(Options_Default);
	end

	if ARTI_Positions == nil then
		ARTI_Positions = {};
	end

	if ARTI_Positions2 == nil then
		ARTI_Positions2 = {};
	end
	if ARTI_Positions3 == nil then
		ARTI_Positions3 = {};
	end

	if ARTI_Data == nil then
		ARTI_Data = {};
	end
	ns.options = CopyTable(ARTI_Options);
	ns.infos = CopyTable(ARTI_Data);

	for variable, _ in pairs(Options_Default) do
		local name = variable;

		local cvar_name = "asRaidTimer_" .. variable;
		local tooltip = ""
		if ARTI_Options[variable] == nil then
			ARTI_Options[variable] = Options_Default[variable];
			ns.options[variable] = Options_Default[variable];
		end
		local defaultValue = Options_Default[variable]
		local currentValue = ARTI_Options[variable];

		if name ~= "Version" then
			if tonumber(defaultValue) ~= nil then
				local setting = Settings.RegisterAddOnSetting(category, cvar_name, variable, tempoption,
					type(defaultValue),
					L[name], defaultValue);
				local options = Settings.CreateSliderOptions(0, 100, 1);
				options:SetLabelFormatter(MinimalSliderWithSteppersMixin.Label.Right);
				Settings.CreateSlider(category, setting, options, tooltip);
				Settings.SetValue(cvar_name, currentValue);
				Settings.SetOnValueChangedCallback(cvar_name, OnSettingChanged);
			else
				local setting = Settings.RegisterAddOnSetting(category, cvar_name, variable, tempoption,
					type(defaultValue),
					L[name], defaultValue);
				Settings.CreateCheckboxWithOptions(category, setting, nil, tooltip);
				Settings.SetValue(cvar_name, currentValue);
				Settings.SetOnValueChangedCallback(cvar_name, OnSettingChanged);
			end
		end
	end

	Settings.RegisterAddOnCategory(category)
	SetupSubOption(subpanel);
end
