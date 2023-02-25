local ADBMT_Font = "Fonts\\2002.TTF";
local ADBMT_CoolFontSize = 18;
local ADBMT_NameFontSize = 14;
local ADBMT_FontOutline = "THICKOUTLINE";
local ADBMT_MaxButtons = 10;
local ADBMT_1sHeight = 20;	-- 1초의 높이

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

	if self.update >= 0.05  then
		self.update = 0;
		local remain = self.start + self.duration - GetTime();
		if remain > 0  then
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

local function newButton(id, msg, duration, start, icon)

	for i = 1, ADBMT_MaxButtons do
		if asDBMTimer.buttons[i].id == nil then
			asDBMTimer.buttons[i].id = id;
			asDBMTimer.buttons[i].start = start;
			asDBMTimer.buttons[i].duration = duration;
			asDBMTimer.buttons[i].icon:SetTexture(icon);
			asDBMTimer.buttons[i].icon:Show();
			asDBMTimer.buttons[i].cooltext:Show();
			asDBMTimer.buttons[i].border:Show();
			asDBMTimer.buttons[i].text:SetText(msg);
			asDBMTimer.buttons[i].text:Show();
			asDBMTimer.buttons[i].update = 0.1;
			asDBMTimer.buttons[i]:SetScript("OnUpdate", ADBMT_OnUpdate);
			asDBMTimer.buttons[i]:Show();
			return i;
		end		
	end
	return nil;
end

local dbm_event_list = {};

function asDBMTimer_callback(...)
	--print (...);

	local event, id, msg, timer, icon, type, spellId, colorId, modid, keep, fade, name, guid = ...;

	if event == "DBM_TimerStart" then
		if dbm_event_list[id] and dbm_event_list[id][5] then
			deleteButton(id);		
		end			
		local newmsg = msg;

		local strFindStart, strFindEnd = string.find(msg, " 쿨타임")
    	if strFindStart ~= nil then
          	 newmsg = string.sub(msg, 1, strFindStart-1);
		end
		dbm_event_list[id] = {newmsg, timer, GetTime(), icon, 0};
		--print (type, spellId, colorId, modid, keep, fade, name);
	elseif event == "DBM_TimerStop" then
		if dbm_event_list[id] and dbm_event_list[id][5] then
			deleteButton(id);		
		end
		dbm_event_list[id] = nil;
	else
		print (...);
	end
end

local function checkList()
	for id,v in pairs(dbm_event_list) do

		local start = GetTime();
		local remain = v[3] + v[2] - GetTime();
		if v[5] == 0 and remain > 0 and remain <= 10  then
			local idx = newButton(id, v[1], remain, start, v[4]);
			v[5] = idx;
			
		elseif remain <= 0 then
			dbm_event_list[id] = nil;
			deleteButton(id);
		end
	end
end

local function setupUI()

	asDBMTimer = CreateFrame("FRAME", nil, UIParent)
	asDBMTimer:SetPoint("CENTER",UIParent,"CENTER", 250, 0)
	asDBMTimer:SetWidth(100)
	asDBMTimer:SetHeight(100)
	asDBMTimer:Show();

	local bloaded =  LoadAddOn("asMOD")

	if bloaded and asMOD_setupFrame then
		asMOD_setupFrame (asDBMTimer, "asDBMTimer");
  	end

	asDBMTimer.square = asDBMTimer:CreateTexture(nil, "BACKGROUND");
	asDBMTimer.square:SetDrawLayer("ARTWORK", 0);
	asDBMTimer.square:SetTexture("Interface\\Addons\\asDBMTimer\\Square_White.tga")
	--asDBMTimer.square:SetBlendMode("ALPHAKEY");
	asDBMTimer.square:SetVertexColor(1,1,1,1)
	asDBMTimer.square:SetWidth(5);
	asDBMTimer.square:SetHeight(200);
	asDBMTimer.square:Show();

	asDBMTimer.buttons = {};

	for i = 1, ADBMT_MaxButtons do
		asDBMTimer.buttons[i] = CreateFrame("Button", nil, asDBMTimer, "asDBMTimerFrameTemplate");
		asDBMTimer.buttons[i]:SetWidth(40);
		asDBMTimer.buttons[i]:SetHeight(40 * 0.9);
		asDBMTimer.buttons[i]:SetScale(1);
		asDBMTimer.buttons[i]:SetAlpha(1);
		asDBMTimer.buttons[i]:EnableMouse(false);
		asDBMTimer.buttons[i]:Hide();
		
		asDBMTimer.buttons[i].count:SetPoint("BOTTOMRIGHT", -3, 3);

		asDBMTimer.buttons[i].icon:SetTexCoord(.08, .92, .08, .92);
		asDBMTimer.buttons[i].border:SetTexture("Interface\\Addons\\asDBMTimer\\border.tga");
		asDBMTimer.buttons[i].border:SetTexCoord(0.08,0.08, 0.08,0.92, 0.92,0.08, 0.92,0.92);
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
	end
end

local function initAddon()
	DBM:RegisterCallback("DBM_TimerStart", asDBMTimer_callback );
	DBM:RegisterCallback("DBM_TimerStop", asDBMTimer_callback );
	DBM:RegisterCallback("DBM_TimerFadeUpdate", asDBMTimer_callback );
	DBM:RegisterCallback("DBM_TimerUpdate", asDBMTimer_callback );
	DBM:RegisterCallback("DBM_TimerPause", asDBMTimer_callback );
	DBM:RegisterCallback("DBM_TimerResume", asDBMTimer_callback );

	C_Timer.NewTicker(0.1, checkList);
end

local bloaded = LoadAddOn("DBM-Core");
if bloaded then
	initAddon();
	setupUI();
end
