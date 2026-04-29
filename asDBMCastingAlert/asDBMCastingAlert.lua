local _, ns = ...;
---설정부
local configs = {
	xpoint = 230,
	ypoint = -30,
	width = 180,
	height = 17,
	alpha = 1,
	updaterate = 0.1,
	notinterruptcolor = { 0.9, 0.9, 0.9 },
	interruptcolor = { 204 / 255, 255 / 255, 153 / 255 },

	font = STANDARD_TEXT_FONT,
};

configs.namesize = configs.height * 0.5; --Spell 명 Font Size, 높이의 50%
configs.timesize = configs.height * 0.3; --Spell 시전시간 Font Size, 높이의 30%

local region = GetCurrentRegion();

if region == 2 and GetLocale() ~= "koKR" then
	configs.font = "Fonts\\2002.ttf";
end

local targetedtexts = {};

targetedtexts[1] = CreateAtlasMarkup("QuestLegendary", 16, 16, 0, 0, 255, 0, 0);
targetedtexts[2] = CreateAtlasMarkup("QuestLegendary", 16, 16, 0, 0);

local main_frame = nil;
local castingunits = {};


local function show_raidicon(unit, markframe)
	local raidicon = GetRaidTargetIndex(unit);
	if raidicon then
		SetRaidTargetIconTexture(markframe, raidicon);
		markframe:Show();
	else
		markframe:Hide();
	end
end

local function comparator(a, b)
	return a.level > b.level;
end

local castingInfos;

local function on_update()
	if castingInfos == nil then
		castingInfos = TableUtil.CreatePriorityTable(comparator, TableUtil.Constants.AssociativePriorityTable);
	else
		castingInfos:Clear();
	end


	for _, nameplate in pairs(C_NamePlate.GetNamePlates(issecure())) do

		local unit = nameplate.unitToken;

		if unit and UnitExists(unit) and UnitClassification(unit) ~= "minus" and UnitThreatSituation("player", unit) then		
			local bchannel = false;
			local duration = nil;
			local name, _, texture, starttime, endtime, _, _, notInterruptible, spellid = UnitCastingInfo(unit);
			if not name then
				bchannel = true;
				name, _, texture, starttime, endtime, _, notInterruptible, spellid = UnitChannelInfo(unit);
				duration = UnitChannelDuration(unit);
			else
				duration = UnitCastingDuration(unit);
			end

			if name then
				local level = UnitLevel(unit);

				if level < 0 then
					level = 1000;
				end

				castingInfos[unit] = {
					texture = texture,
					name = name,
					duration = duration,
					spellid = spellid,
					notInterruptible = notInterruptible,
					bchannel = bchannel,
					start = starttime,
					endtime = endtime,
					level = level,
				}
			end
		end
	end

	local i = 1;

	castingInfos:Iterate(
		function(unit, castingInfo)
			local needshow = true;

			if ns.options.HideTarget and UnitIsUnit(unit, "target") then
				needshow = false;
			end

			if ns.options.HideFocus and UnitIsUnit(unit, "focus") then
				needshow = false;
			end

			if i <= ns.options.MaxShow and main_frame and needshow then
				local castbar      = main_frame.bars[i];
				local frameicon    = castbar.button.icon;
				local text         = castbar.name;
				local time         = castbar.time;
				local targetname   = castbar.targetname;
				local mark         = castbar.mark;				
				local bchannel     = castingInfo.bchannel;
				local targettarget = unit .. "target";
				
				castbar.duration_obj = castingInfo.duration;
				frameicon:SetTexture(castingInfo.texture);
				castbar:SetReverseFill(bchannel);

				castbar:SetMinMaxValues(castingInfo.start, castingInfo.endtime)
				castbar.failstart = nil;
				castbar.castspellid = castingInfo.spellid;

				local color = configs.interruptcolor;
				castbar:SetStatusBarColor(color[1], color[2], color[3]);
				text:SetText(castingInfo.name);
				show_raidicon(unit, mark);
				frameicon:Show();
				castbar:Show();


				local isimportant = C_Spell.IsSpellImportant(castingInfo.spellid);
				local alpha = C_CurveUtil.EvaluateColorValueFromBoolean(isimportant, 1, 0);
				castbar.important:SetAlpha(alpha);

				local istargeted = UnitIsUnit(unit .. "target", "player");
				local alpha = C_CurveUtil.EvaluateColorValueFromBoolean(istargeted, 1, 0);
				castbar.targetedindi:SetAlpha(alpha);

				local alpha = C_CurveUtil.EvaluateColorValueFromBoolean(castingInfo.notInterruptible, 1, 0);
				castbar.notinterruptable:SetAlpha(alpha);

				if UnitExists(targettarget) then
					local _, class = UnitClass(targettarget)
					local classcolor = nil;
					if class then
						classcolor = RAID_CLASS_COLORS[class];
					end

					if classcolor then
						targetname:SetTextColor(classcolor.r, classcolor.g, classcolor.b);
					else
						targetname:SetTextColor(1, 1, 1);
					end

					targetname:SetText(UnitName(targettarget));
					targetname:Show();
				else
					targetname:SetText("");
					targetname:Hide();
				end

				i = i + 1;
			end

			if i > ns.options.MaxShow then
				return true;
			end

			return false;
		end)

	for j = i, ns.options.MaxShow do
		if main_frame then
			local frame = main_frame.bars[j];
			frame.duration_obj = nil;
			frame:Hide();
		end
	end
end


local function update_castbar(castbar)
	local current = GetTime();

	if castbar.duration_obj then
		castbar.time:SetText(string.format("%.1f/%.1f", castbar.duration_obj:GetRemainingDuration(0),
			castbar.duration_obj:GetTotalDuration(0)));
		castbar:SetValue(current * 1000, Enum.StatusBarInterpolation.ExponentialEaseOut);
	end


	if castbar.updatecount == nil then
		castbar.updatecount = 0;
	end

	castbar.updatecount = castbar.updatecount + 1;

	if castbar.updatecount > 3 then
		castbar.targetedindi:SetText(targetedtexts[castbar.targetedinditype]);
		castbar.targetedinditype = (castbar.targetedinditype + 1);

		if castbar.targetedinditype == 3 then
			castbar.targetedinditype = 1;
		end

		if castbar.important:IsShown() then
			castbar.important:Hide();
		else
			castbar.important:Show();
		end

		castbar.updatecount = 1;
	end
end

local function setup_castbar()
	local castbar = CreateFrame("StatusBar", nil, UIParent)
	castbar:SetFrameStrata("LOW");
	castbar:SetStatusBarTexture("RaidFrame-Hp-Fill")
	local statustexture = castbar:GetStatusBarTexture();
	statustexture:SetHorizTile(false)
	castbar:SetMinMaxValues(0, 100)
	castbar:SetValue(100)
	castbar:SetHeight(configs.height)
	castbar:SetWidth(configs.width - (configs.height + 2) * 1.2)
	castbar:SetStatusBarColor(1, 0.9, 0.9);
	castbar:SetAlpha(configs.alpha);

	castbar.notinterruptable = castbar:CreateTexture(nil, "ARTWORK", "asTargetCastBarNotInteruptTemplate", 1);
	castbar.notinterruptable:SetParent(castbar);
	castbar.notinterruptable:ClearAllPoints();
	castbar.notinterruptable:SetPoint("TOPLEFT", statustexture, "TOPLEFT", 0, 0);
	castbar.notinterruptable:SetPoint("BOTTOMRIGHT", statustexture, "BOTTOMRIGHT", 0, 0);
	castbar.notinterruptable:SetVertexColor(configs.notinterruptcolor[1], configs.notinterruptcolor[2],
		configs.notinterruptcolor[3]);
	castbar.notinterruptable:SetAlpha(0);
	castbar.notinterruptable:Show();

	castbar.important = castbar:CreateTexture(nil, "BACKGROUND");
	castbar.important:SetDrawLayer("BACKGROUND", -6);
	castbar.important:SetPoint("TOPLEFT", castbar, "TOPLEFT", -2, 2);
	castbar.important:SetPoint("BOTTOMRIGHT", castbar, "BOTTOMRIGHT", 2, -2);
	castbar.important:SetColorTexture(1, 0, 0, 1);
	castbar.important:SetAlpha(0);
	castbar.important:Show();


	castbar.bg = castbar:CreateTexture(nil, "BACKGROUND")
	castbar.bg:SetPoint("TOPLEFT", castbar, "TOPLEFT", -1, 1)
	castbar.bg:SetPoint("BOTTOMRIGHT", castbar, "BOTTOMRIGHT", 1, -1)
	castbar.bg:SetColorTexture(0, 0, 0, 1);
	castbar.bg:Show();

	castbar.name = castbar:CreateFontString(nil, "OVERLAY");
	castbar.name:SetFont(STANDARD_TEXT_FONT, configs.namesize);
	castbar.name:SetPoint("LEFT", castbar, "LEFT", 3, 0);

	castbar.time = castbar:CreateFontString(nil, "OVERLAY");
	castbar.time:SetFont(STANDARD_TEXT_FONT, configs.timesize);
	castbar.time:SetPoint("TOPRIGHT", castbar, "TOPRIGHT", -3, -1);

	if not castbar:GetScript("OnEnter") then
		castbar:SetScript("OnEnter", function(self)
			if self.castspellid then
				GameTooltip_SetDefaultAnchor(GameTooltip, self);
				GameTooltip:SetSpellByID(self.castspellid);
			end
		end)
		castbar:SetScript("OnLeave", function()
			GameTooltip:Hide();
		end)
	end

	castbar:EnableMouse(false);
	castbar:SetMouseMotionEnabled(true);
	castbar.isAlert = false;
	castbar:Hide();

	castbar.button = CreateFrame("Button", nil, castbar, "ATCBFrameTemplate");
	castbar.button:SetPoint("RIGHT", castbar, "LEFT", -1, 0)
	castbar.button:SetWidth((configs.height + 2) * 1.2);
	castbar.button:SetHeight(configs.height + 2);
	castbar.button:SetAlpha(1);
	castbar.button:EnableMouse(false);
	castbar.button.icon:SetTexCoord(.08, .92, .16, .84);
	castbar.button.border:SetTexCoord(0.08, 0.08, 0.08, 0.92, 0.92, 0.08, 0.92, 0.92);
	castbar.button.border:SetVertexColor(0, 0, 0);
	castbar.button.border:Show();
	castbar.button:Show();

	

	castbar.mark = castbar:CreateTexture(nil, "ARTWORK");
	castbar.mark:SetTexture("Interface\\TargetingFrame\\UI-RaidTargetingIcons");
	castbar.mark:SetSize(configs.namesize + 3, configs.namesize + 3);
	castbar.mark:SetPoint("RIGHT", castbar.button, "LEFT", -1, 0);

	castbar.targetedindi = castbar:CreateFontString(nil, "ARTWORK");
	castbar.targetedindi:SetFont(configs.font, configs.namesize + 1, "OUTLINE");
	castbar.targetedindi:SetPoint("LEFT", castbar, "RIGHT", 0, 1);
	castbar.targetedindi:Show();

	castbar.targetname = castbar:CreateFontString(nil, "ARTWORK");
	castbar.targetname:SetFont(configs.font, configs.namesize);
	castbar.targetname:SetPoint("BOTTOMRIGHT", castbar, "BOTTOMRIGHT", -3, 1);


	castbar.start = 0;
	castbar.duration = 0;
	castbar.targetedinditype = 1;

	local cb = function()
		update_castbar(castbar);
	end

	if castbar.ctimer then
		castbar.ctimer:Cancel();
	end

	castbar.ctimer = C_Timer.NewTicker(0.1, cb);
	return castbar;
end

local function init()
	ns.SetupOptionPanels();
	main_frame = CreateFrame("FRAME", nil, UIParent)

	if main_frame.bars == nil then
		main_frame.bars = {};
	end

	for idx = 1, ns.options.MaxShow do
		main_frame.bars[idx] = setup_castbar();

		if idx == 1 then
			main_frame.bars[idx]:SetPoint("CENTER", configs.xpoint, configs.ypoint)
		else
			main_frame.bars[idx]:SetPoint("TOPRIGHT", main_frame.bars[idx - 1], "BOTTOMRIGHT", 0, -4);
		end
	end

	local libasConfig = LibStub:GetLibrary("LibasConfig", true);

	if libasConfig then
		libasConfig.load_position(main_frame.bars[1], "asDBMCastingAlert", ADCA_Position);
	end

	local timer = C_Timer.NewTicker(0.2, on_update);
end


C_Timer.After(0.5, init);
