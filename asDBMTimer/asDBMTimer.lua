local ADBMT_Font = "Fonts\\2002.TTF";
local ADBMT_CoolFontSize = 15;
local ADBMT_NameFontSize = 12;
local ADBMT_FontOutline = "THICKOUTLINE";
local ADBMT_MaxButtons = 10;
local ADBMT_1sHeight = 15; -- 1초의 높이
local ADBMT_IconSize = 30;
local ADBMT_X = -380;
local ADBMT_Y = 0;


local BarColors = {
	--Type 0
	[0] = { 1, 0.7, 0, "" },
	--Type 1 (Add)
	[1] = { 0.375, 0.545, 1, "[추가]" },
	--Type 2 (AOE)
	[2] = { 1, 0.466, 0.459, "[광역]" },
	--Type 3 (Targeted)
	[3] = { 0.9, 0.3, 1, "[대상]" },
	--Type 4 (Interrupt)
	[4] = { 0.47, 0.97, 1, "[차단]" },
	--Type 5 (Role)
	[5] = { 0.5, 1, 0.5, "[임무]" },
	--Type 6 (Phase)
	[6] = { 1, 0.776, 0.420, "[단계]" },
	--Type 7 (Important/User set only)
	[7] = { 1, 1, 0.06, "" },
}

-- 설정 끝

local asDBMTimer = nil;

local function getButton(id)
	local button = nil

	for i = 1, ADBMT_MaxButtons do
		if asDBMTimer.buttons[i].id == id then
			button = asDBMTimer.buttons[i];
			break;
		end
	end

	return button;
end

local function deleteButton(id)
	local button = getButton(id);

	if button then
		button.id = nil;
		button.cooltext:Hide();
		button.text:Hide();
		button:Hide();
		button:SetScript("OnUpdate", nil)
	end
end

function ADBMT_OnUpdate(self, elapsed)
	self.update = self.update + elapsed

	if self.update >= 0.05 then
		self.update = 0;
		local remain = self.start + self.duration - GetTime();
		if remain > 0 then
			self:ClearAllPoints();
			self:SetPoint("BOTTOM", self:GetParent(), "BOTTOM", 0, remain * ADBMT_1sHeight);
			self.cooltext:SetText(("%02.1f"):format(remain))
			if remain <= 3 then
				self.cooltext:SetTextColor(1, 0, 0, 1);
			else
				self.cooltext:SetTextColor(1, 1, 1, 1);
			end
		end
	end
end

local function RGBToHex(r, g, b)
	r = math.floor(r * 255)
	g = math.floor(g * 255)
	b = math.floor(b * 255)
	return string.format("|cff%02x%02x%02x", r, g, b)
end

local function newButton(id, msg, duration, start, icon, colorId, spellID)
	for i = 1, ADBMT_MaxButtons do
		local button = asDBMTimer.buttons[i];
		if button.id == nil then
			button.id = id;
			button.start = start;
			button.duration = duration;
			button.icon:SetTexture(icon);
			button.icon:Show();
			button.cooltext:Show();
			button.border:Show();
			button.spellid = spellID;

			if colorId and BarColors[colorId] then
				local info = BarColors[colorId];

				msg = RGBToHex(info[1], info[2], info[3]) .. info[4] .. " " .. RGBToHex(1, 1, 1) .. msg;
			end

			button.text:SetText(msg);
			button.text:Show();
			button.update = 0.1;
			button:SetScript("OnUpdate", ADBMT_OnUpdate);
			button:Show();

			return i;
		end
	end
	return nil;
end

local dbm_event_list = {};

function asDBMTimer_callback(event, id, ...)
	if event == "DBM_TimerStart" then
		local msg, timer, icon, type, spellId, colorId, modid, keep, fade, name, guid = ...;
		if dbm_event_list[id] and dbm_event_list[id][5] then
			deleteButton(id);
		end
		local newmsg = msg;
		local strFindStart, strFindEnd = string.find(msg, " 쿨타임")
		if strFindStart ~= nil then
			newmsg = string.sub(msg, 1, strFindStart - 1);
		end
		dbm_event_list[id] = { newmsg, timer, GetTime(), icon, 0, colorId, spellId };
	elseif event == "DBM_TimerStop" then
		if dbm_event_list[id] and dbm_event_list[id][5] then
			deleteButton(id);
		end
		dbm_event_list[id] = nil;
	elseif event == "DBM_TimerUpdate" then
		local elapsed, totalTime = ...;
		if dbm_event_list[id] then
			if dbm_event_list[id][5] then
				deleteButton(id);
			end
			dbm_event_list[id][5] = 0;
			dbm_event_list[id][2] = totalTime;
			dbm_event_list[id][3] = GetTime() - elapsed;
		end
	else
		--print (...);
	end
end

local function checkList()
	for id, v in pairs(dbm_event_list) do
		local start = GetTime();
		local remain = v[3] + v[2] - GetTime();
		if v[5] == 0 and remain > 0 and remain <= 10 then
			local idx = newButton(id, v[1], remain, start, v[4], v[6], v[7]);
			v[5] = idx;
		elseif remain <= 0 then
			dbm_event_list[id] = nil;
			deleteButton(id);
		end
	end
end

local function setupUI()
	asDBMTimer = CreateFrame("FRAME", nil, UIParent)
	asDBMTimer:SetPoint("CENTER", UIParent, "CENTER", ADBMT_X, ADBMT_Y)
	asDBMTimer:SetWidth(100)
	asDBMTimer:SetHeight(100)
	asDBMTimer:Show();

	local bloaded = LoadAddOn("asMOD")

	if bloaded and asMOD_setupFrame then
		asMOD_setupFrame(asDBMTimer, "asDBMTimer");
	end

	--[[
	asDBMTimer.square = asDBMTimer:CreateTexture(nil, "BACKGROUND");
	asDBMTimer.square:SetDrawLayer("ARTWORK", 0);
	asDBMTimer.square:SetTexture("Interface\\Addons\\asDBMTimer\\Square_White.tga")
	--asDBMTimer.square:SetBlendMode("ALPHAKEY");
	asDBMTimer.square:SetVertexColor(0.5,0.5,0.5, 0.3)
	asDBMTimer.square:ClearAllPoints();
	asDBMTimer.square:SetPoint("BOTTOM", asDBMTimer, "BOTTOM", 0, 0);
	asDBMTimer.square:SetWidth(2);
	asDBMTimer.square:SetHeight(ADBMT_1sHeight * 10);
	asDBMTimer.square:SetAlpha(1);
	asDBMTimer.square:Show();
	]]

	asDBMTimer.buttons = {};

	for i = 1, ADBMT_MaxButtons do
		asDBMTimer.buttons[i] = CreateFrame("Button", nil, asDBMTimer, "asDBMTimerFrameTemplate");
		asDBMTimer.buttons[i].icon:SetDrawLayer("BACKGROUND", 2);
		asDBMTimer.buttons[i]:SetWidth(ADBMT_IconSize);
		asDBMTimer.buttons[i]:SetHeight(ADBMT_IconSize * 0.9);
		asDBMTimer.buttons[i]:SetScale(1);
		asDBMTimer.buttons[i]:SetAlpha(1);
		asDBMTimer.buttons[i]:EnableMouse(false);
		asDBMTimer.buttons[i]:Hide();

		asDBMTimer.buttons[i].count:SetPoint("BOTTOMRIGHT", -3, 3);

		asDBMTimer.buttons[i].icon:SetTexCoord(.08, .92, .08, .92);
		asDBMTimer.buttons[i].border:SetTexture("Interface\\Addons\\asDBMTimer\\border.tga");
		asDBMTimer.buttons[i].border:SetTexCoord(0.08, 0.08, 0.08, 0.92, 0.92, 0.08, 0.92, 0.92);
		asDBMTimer.buttons[i].border:SetVertexColor(0, 0, 0);

		asDBMTimer.buttons[i]:SetPoint("CENTER", 0, 0);

		asDBMTimer.buttons[i].cooltext = asDBMTimer.buttons[i]:CreateFontString(nil, "OVERLAY");
		asDBMTimer.buttons[i].cooltext:SetFont(ADBMT_Font, ADBMT_CoolFontSize, ADBMT_FontOutline)
		asDBMTimer.buttons[i].cooltext:SetPoint("RIGHT", asDBMTimer.buttons[i], "LEFT", -2, 0);

		asDBMTimer.buttons[i].text = asDBMTimer.buttons[i]:CreateFontString(nil, "OVERLAY");
		asDBMTimer.buttons[i].text:SetFont(ADBMT_Font, ADBMT_NameFontSize, ADBMT_FontOutline)
		asDBMTimer.buttons[i].text:SetPoint("LEFT", asDBMTimer.buttons[i], "RIGHT", 2, 0);
		asDBMTimer.buttons[i].id = nil;
		asDBMTimer.buttons[i].start = nil;
		asDBMTimer.buttons[i].duration = nil;

		if not asDBMTimer.buttons[i]:GetScript("OnEnter") then
			asDBMTimer.buttons[i]:SetScript("OnEnter", function(s)
				if s.spellid and type(s.spellid) == "number" and s.spellid > 0 then
					GameTooltip_SetDefaultAnchor(GameTooltip, s);
					GameTooltip:SetSpellByID(s.spellid);
				end
			end)
			asDBMTimer.buttons[i]:SetScript("OnLeave", function()
				GameTooltip:Hide();
			end)
		end
	end
end

local function initAddon()
	DBM:RegisterCallback("DBM_TimerStart", asDBMTimer_callback);
	DBM:RegisterCallback("DBM_TimerStop", asDBMTimer_callback);
	DBM:RegisterCallback("DBM_TimerFadeUpdate", asDBMTimer_callback);
	DBM:RegisterCallback("DBM_TimerUpdate", asDBMTimer_callback);
	DBM:RegisterCallback("DBM_TimerPause", asDBMTimer_callback);
	DBM:RegisterCallback("DBM_TimerResume", asDBMTimer_callback);

	C_Timer.NewTicker(0.1, checkList);
end

local bloaded = LoadAddOn("DBM-Core");
if bloaded then
	initAddon();
	setupUI();
end
