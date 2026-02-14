local _, ns = ...;

local configs = {
	font = STANDARD_TEXT_FONT,
	coolfontsize = 15,
	namefontsize = 12,
	fontoutline = "THICKOUTLINE",
	maxshow = 3,
	xpoint = 200,
	ypoint = 50,	
	maxicons = 4,
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

		button.icons = {};
		for j = 1, configs.maxicons do
			button.icons[j] = button:CreateTexture(nil, "ARTWORK");
			button.icons[j]:SetSize(ns.options.Size/2 - 2, ns.options.Size/2 - 2);
			if j == 1 then
				button.icons[j]:SetPoint("BOTTOMLEFT", button, "TOPLEFT", 0, 1);
			elseif j == 3 then
				button.icons[j]:SetPoint("BOTTOMLEFT", button.icons[1], "TOPLEFT", 0, 1);
			else
				button.icons[j]:SetPoint("LEFT", button.icons[j - 1], "RIGHT", 1, 0);
			end
			button.icons[j]:Hide();
		end

		button:EnableMouse(false);
	end
end

local atlases = {
	[Enum.EncounterEventIconmask.TankRole] = "icons_16x16_tank",
	[Enum.EncounterEventIconmask.DpsRole] = "icons_16x16_damage",
	[Enum.EncounterEventIconmask.HealerRole] = "icons_16x16_heal",
	[Enum.EncounterEventIconmask.DeadlyEffect] = "icons_16x16_deadly",
	[Enum.EncounterEventIconmask.MagicEffect] = "icons_16x16_magic",
	[Enum.EncounterEventIconmask.CurseEffect] = "icons_16x16_curse",
	[Enum.EncounterEventIconmask.PoisonEffect] = "icons_16x16_poison",
	[Enum.EncounterEventIconmask.DiseaseEffect] = "icons_16x16_disease",
	[Enum.EncounterEventIconmask.EnrageEffect] = "icons_16x16_enrage",
	[Enum.EncounterEventIconmask.BleedEffect] = "icons_16x16_bleed",
};

local function checkList()
	local events = C_EncounterTimeline.GetEventList();
	local idx = 1;

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
				
				--[[
				local j = 1;
				local color = {0, 0, 0};
				if eventinfo.icons and not issecretvalue(eventinfo.icons) then
					for _, mask in pairs(Enum.EncounterEventIconmask) do
						if FlagsUtil.IsSet(eventinfo.icons, mask) then
							local atlas = atlases[mask];

							if mask == Enum.EncounterEventIconmask.DeadlyEffect then
								color = {1, 0, 0};							
							end

							button.icons[j]:SetAtlas(atlas);
							button.icons[j]:Show();
							j = j + 1;
							if j > configs.maxicons then
								break;
							end
						end
					end
				end

				for i = j, configs.maxicons do
					button.icons[i]:Hide();
				end

				button.border:SetVertexColor(color[1], color[2], color[3]);
				]]

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
