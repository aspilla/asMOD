local _, ns = ...;

local configs = {
	font = STANDARD_TEXT_FONT,
	coolfontsize = 15,
	namefontsize = 12,
	fontoutline = "THICKOUTLINE",
	maxshow = 3,
	xpoint = 200,
	ypoint = 50,
}
-- 설정 끝

local function init_position()
	C_Timer.After(2, ns.setup_option);
end

local function on_event(self, event, arg1, ...)
	if event == "ADDON_LOADED" and arg1 == "asDBMTimer" then
		init_position();
	end
end


local function setupUI()
	ns.asDBMTimer = CreateFrame("FRAME", nil, UIParent)
	ns.asDBMTimer:SetPoint("CENTER", UIParent, "CENTER", configs.xpoint, configs.ypoint)
	ns.asDBMTimer:SetWidth(100)
	ns.asDBMTimer:SetHeight(100)
	ns.asDBMTimer:SetMovable(true);
	ns.asDBMTimer:EnableMouse(true);
	ns.asDBMTimer:RegisterForDrag("LeftButton");
	ns.asDBMTimer.text = ns.asDBMTimer:CreateFontString(nil, "OVERLAY")
	ns.asDBMTimer.text:SetFont(STANDARD_TEXT_FONT, 10, "OUTLINE")
	ns.asDBMTimer.text:SetPoint("CENTER", ns.asDBMTimer, "CENTER", 0, 0)
	ns.asDBMTimer.text:SetText("asDBMTimer(Position)");
	ns.asDBMTimer.text:Hide();
	ns.asDBMTimer.tex = ns.asDBMTimer:CreateTexture(nil, "ARTWORK");
	ns.asDBMTimer.tex:SetAllPoints();
	ns.asDBMTimer.tex:SetColorTexture(0.0, 0.5, 1.0); -- Blue color for visibility
	ns.asDBMTimer.tex:SetAlpha(0.5);
	ns.asDBMTimer.tex:Hide();
	ns.asDBMTimer:Show();
	ns.asDBMTimer:SetScript("OnEvent", on_event);
	ns.asDBMTimer:RegisterEvent("ADDON_LOADED");

	ns.asDBMTimer:SetScript("OnDragStart", function(self)
		self:StartMoving();
	end)
	ns.asDBMTimer:SetScript("OnDragStop", function(self)
		self:StopMovingOrSizing();
		ns.SavePosition(self);
	end);


	ns.asDBMTimer.buttons = {};

	for i = 1, configs.maxshow do
		ns.asDBMTimer.buttons[i] = CreateFrame("Button", nil, ns.asDBMTimer, "asDBMTimerFrameTemplate");
		local button = ns.asDBMTimer.buttons[i];
		button:SetWidth(ns.options.Size);
		button:SetHeight(ns.options.Size * 0.9);
		button:SetScale(1);
		button:SetAlpha(1);
		button:EnableMouse(false);
		button:Hide();

		button.icon:SetTexCoord(.08, .92, .08, .92);
		button.border:SetTexCoord(0.08, 0.08, 0.08, 0.92, 0.92, 0.08, 0.92, 0.92);
		button.border:SetVertexColor(0, 0, 0);
		if i == 1 then
			button:SetPoint("CENTER", 0, 0);
		else
			button:SetPoint("RIGHT", ns.asDBMTimer.buttons[i - 1], "LEFT", -1, 0);
		end
		button.cooltext = button:CreateFontString(nil, "OVERLAY");
		button.cooltext:SetFont(configs.font, configs.coolfontsize, configs.fontoutline)
		button.cooltext:SetPoint("CENTER", button, "CENTER", 0, 0);

		button.text = button:CreateFontString(nil, "OVERLAY");
		button.text:SetFont(configs.font, configs.namefontsize, configs.fontoutline)
		button.text:SetPoint("TOP", button, "BOTTOM", 0, -1);
		button.text:SetWidth(ns.options.Size);
		button:EnableMouse(false);
	end
end

local function checkList()
	local events = C_EncounterTimeline.GetEventList();
	local idx = 1;

	for _, id in pairs(events) do
		local timeRemaining = C_EncounterTimeline.GetEventTimeRemaining(id);

		if timeRemaining and timeRemaining < ns.options.MinTimetoShow then
			local eventinfo = C_EncounterTimeline.GetEventInfo(id);

			if eventinfo then
				local button = ns.asDBMTimer.buttons[idx];
				button.icon:SetTexture(eventinfo.iconFileID);
				button.cooltext:SetText(string.format("%.1f", timeRemaining));
				if ns.options.ShowName and eventinfo.spellID then
					button.text:SetText(string.format("%5s", C_Spell.GetSpellName(eventinfo.spellID)));
				else
					button.text:SetText("");
				end

				button:Show();
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


local function initAddon()
	setupUI();
	C_Timer.NewTicker(0.2, checkList);
end

function ns.GetPosition()
	local left = ns.asDBMTimer:GetLeft();
	local bottom = ns.asDBMTimer:GetBottom();
	local height = ns.asDBMTimer:GetHeight();

	return left, bottom, height;
end

initAddon();
