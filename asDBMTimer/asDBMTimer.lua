local _, ns = ...;

local ADBMT_Font = "Fonts\\2002.TTF";
local ADBMT_CoolFontSize = 15;
local ADBMT_NameFontSize = 12;
local ADBMT_FontOutline = "THICKOUTLINE";
local ADBMT_MaxButtons = 10;
local ADBMT_1sHeight = 15; -- 1초의 높이
local ADBMT_IconSize = 30;
local ADBMT_X = 230;
local ADBMT_Y = 50;


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

local asDBMTimer = {};

local function deleteButton(idx, btemp)
	local button = asDBMTimer.buttons[idx]

	if button then
		if btemp then
			button.bdelete = true;
		else
			button.id = nil;
			button.cooltext:Hide();
			button.text:Hide();
			button:Hide();
			button:SetScript("OnUpdate", nil)
		end
	end
end

local function checkAllButton()
	for idx = 1, ADBMT_MaxButtons do
		local button = asDBMTimer.buttons[idx]

		if button and button.bdelete then			
			deleteButton(idx);
		elseif button and button.start and button.duration then
			local ex = button.start + button.duration;

			if ex < GetTime() then
				deleteButton(idx);
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

local function newButton(id, event)
	for i = 1, ADBMT_MaxButtons do
		local button = asDBMTimer.buttons[i];
		if button.id == nil then
			button.id = id;
			button.bdelete = false;
			button.icon:SetTexture(event.icon);
			button.icon:Show();
			button.cooltext:Show();
			button.border:Show();
			button.spellid = event.spellId;
			button.defaulttext = ""
			local msg = event.msg;

			if event.colorId and BarColors[event.colorId] then
				local info = BarColors[event.colorId];
				msg = RGBToHex(info[1], info[2], info[3]) .. info[4] .. " " .. RGBToHex(1, 1, 1) .. msg;
			end

			button.text:SetText(msg);
			button.defaulttext = msg;
			button.text:Show();
			button:Show();
			return i;
		end
	end
	return nil;
end

local function DefaultCompare(a, b)
	return a.expirationTime < b.expirationTime;
end

local dbm_event_list = TableUtil.CreatePriorityTable(DefaultCompare, TableUtil.Constants.AssociativePriorityTable);

function asDBMTimer_callback(event, id, ...)
	if event == "DBM_TimerStart" then
		local msg, timer, icon, type, spellId, colorId, modid, keep, fade, name, guid = ...;

		if ns.options.HideNamePlatesCooldown and type == "cd" and guid then
			return;
		end

		if dbm_event_list[id] and dbm_event_list[id].button_id then
			deleteButton(dbm_event_list[id].button_id, true);
		end

		local newmsg = msg;
		local strFindStart, strFindEnd = string.find(msg, " 쿨타임")
		if strFindStart ~= nil then
			newmsg = string.sub(msg, 1, strFindStart - 1);
		end
		local curtime = GetTime();
		dbm_event_list[id] = {
			msg = newmsg,
			duration = timer,
			start = curtime,
			expirationTime = timer + curtime,
			icon =
				icon,
			button_id = nil,
			colorId = colorId,
			spellId = spellId,
			guid = guid,
			unit = nil,
			aoealerted = false,
		};
	elseif event == "DBM_TimerStop" then
		if dbm_event_list[id] then
			if dbm_event_list[id].button_id then
				deleteButton(dbm_event_list[id].button_id, true);
			end
			dbm_event_list:Remove(id);
		end
	elseif event == "DBM_TimerUpdate" then
		local elapsed, totalTime = ...;
		if dbm_event_list[id] then
			if dbm_event_list[id].button_id then
				deleteButton(dbm_event_list[id].button_id, true);
			end
			dbm_event_list[id].button_id = nil;
			dbm_event_list[id].duration = totalTime;
			dbm_event_list[id].start = GetTime() - elapsed;
			dbm_event_list[id].expirationTime = GetTime() - elapsed + totalTime;
		end
	else
		--print (...);
	end
end

local RaidIconList = {
	"|TInterface\\TargetingFrame\\UI-RaidTargetingIcon_1:",
	"|TInterface\\TargetingFrame\\UI-RaidTargetingIcon_2:",
	"|TInterface\\TargetingFrame\\UI-RaidTargetingIcon_3:",
	"|TInterface\\TargetingFrame\\UI-RaidTargetingIcon_4:",
	"|TInterface\\TargetingFrame\\UI-RaidTargetingIcon_5:",
	"|TInterface\\TargetingFrame\\UI-RaidTargetingIcon_6:",
	"|TInterface\\TargetingFrame\\UI-RaidTargetingIcon_7:",
	"|TInterface\\TargetingFrame\\UI-RaidTargetingIcon_8:",
}


local function DisplayRaidIcon(unit)
	local icon = GetRaidTargetIndex(unit)
	if icon and RaidIconList[icon] then
		return RaidIconList[icon] .. "0|t"
	else
		return ""
	end
end

local function checkNameplate(nameplate, guid)
	if nameplate then
		if not nameplate or nameplate:IsForbidden() then
			return nil;
		end

		local nunit = nameplate.namePlateUnitToken;

		local reaction = UnitReaction("player", nunit);
		if reaction and reaction <= 4 and guid == UnitGUID(nunit) then
			return nunit;
		end
	end
	return nil;
end

local function UnitIsBoss(unit)
	local classification = UnitClassification(unit)
	local unitlevel = UnitLevel(unit)
	local playerlevel = UnitLevel("player")

	if (classification == "worldboss" or (unitlevel - playerlevel) > 1) then
		return true;
	else
		return false;
	end
end

local function checkList()
	local curtime = GetTime();

	dbm_event_list:Iterate(function(id, event)
		local start_old = event.start;
		local duration = event.duration;
		local remain = start_old + duration - curtime;
		local unitisdead = false;

		if event.guid then
			local nunit = nil;

			for _, v in pairs(C_NamePlate.GetNamePlates(issecure())) do
				local nameplate = v;
				if (nameplate) then
					nunit = checkNameplate(nameplate, event.guid);
				end
				if nunit then
					break;
				end
			end
			event.unit = nunit;
			if event.unit then
				unitisdead = UnitIsDead(event.unit);

				if ns.options.ShowInterruptOnlyforNormal and not UnitIsBoss(event.unit) and event.colorId ~= 4 then
					unitisdead = true;
				end
			end
		end

		if remain > 0 and remain <= ns.options.MinTimetoShow then
			if event.button_id == nil then
				local idx = newButton(id, event);
				event.button_id = idx;
			end
		elseif remain <= 0 then
			if event.button_id then
				deleteButton(event.button_id);
			end
			dbm_event_list:Remove(id);
		end

		if unitisdead then
			if event.button_id then
				deleteButton(event.button_id);
			end
			dbm_event_list:Remove(id);
		end
	end)

	local prev_ex = 0;
	local prev_button = nil;

	dbm_event_list:Iterate(function(id, event)
		if event.button_id then
			local button = asDBMTimer.buttons[event.button_id];
			local remain = event.start + event.duration - curtime;

			local icontext = ""

			if event.unit then
				icontext = DisplayRaidIcon(event.unit)
			end

			if ns.options.AOESound then
				if event.colorId == 2 and remain <= ns.options.AOESound and event.aoealerted == false then
					PlaySoundFile("Interface\\AddOns\\asDBMTimer\\aoe.mp3", "MASTER");
					event.aoealerted = true;
				end
			end

			button.text:SetText(icontext .. button.defaulttext);

			if remain > 0 then
				button:ClearAllPoints();

				if prev_ex > 0 and event.expirationTime - prev_ex <= (ADBMT_IconSize / ADBMT_1sHeight) then
					button:SetPoint("BOTTOM", prev_button, "TOP", 0, 1);
					prev_ex = prev_ex + (ADBMT_IconSize / ADBMT_1sHeight);
				else
					button:SetPoint("BOTTOM", button:GetParent(), "BOTTOM", 0, remain * ADBMT_1sHeight);
					prev_ex = event.expirationTime;
				end

				button.cooltext:SetText(("%02.1f"):format(remain))
				if remain <= 3 then
					button.cooltext:SetTextColor(1, 0, 0, 1);
				else
					button.cooltext:SetTextColor(1, 1, 1, 1);
				end
				prev_button = button;
			end
		end
	end)

	checkAllButton();
end

local function setupUI()
	asDBMTimer = CreateFrame("FRAME", nil, UIParent)
	asDBMTimer:SetPoint("CENTER", UIParent, "CENTER", ADBMT_X, ADBMT_Y)
	asDBMTimer:SetWidth(100)
	asDBMTimer:SetHeight(100)
	asDBMTimer:Show();

	local bloaded = C_AddOns.LoadAddOn("asMOD")

	if bloaded and asMOD_setupFrame then
		asMOD_setupFrame(asDBMTimer, "asDBMTimer");
	end

	asDBMTimer.buttons = {};

	for i = 1, ADBMT_MaxButtons do
		asDBMTimer.buttons[i] = CreateFrame("Button", nil, asDBMTimer, "asDBMTimerFrameTemplate");
		local button = asDBMTimer.buttons[i];
		button.icon:SetDrawLayer("BACKGROUND", 2);
		button:SetWidth(ADBMT_IconSize);
		button:SetHeight(ADBMT_IconSize * 0.9);
		button:SetScale(1);
		button:SetAlpha(1);
		button:EnableMouse(false);
		button:Hide();

		button.count:SetPoint("BOTTOMRIGHT", -3, 3);

		button.icon:SetTexCoord(.08, .92, .08, .92);
		button.border:SetTexture("Interface\\Addons\\asDBMTimer\\border.tga");
		button.border:SetTexCoord(0.08, 0.08, 0.08, 0.92, 0.92, 0.08, 0.92, 0.92);
		button.border:SetVertexColor(0, 0, 0);

		button:SetPoint("CENTER", 0, 0);

		button.cooltext = button:CreateFontString(nil, "OVERLAY");
		button.cooltext:SetFont(ADBMT_Font, ADBMT_CoolFontSize, ADBMT_FontOutline)
		button.cooltext:SetPoint("RIGHT", button, "LEFT", -2, 0);

		button.text = button:CreateFontString(nil, "OVERLAY");
		button.text:SetFont(ADBMT_Font, ADBMT_NameFontSize, ADBMT_FontOutline)
		button.text:SetPoint("LEFT", button, "RIGHT", 2, 0);
		button.id = nil;
		button.start = nil;
		button.duration = nil;

		if not button:GetScript("OnEnter") then
			button:SetScript("OnEnter", function(s)
				if s.spellid and type(s.spellid) == "number" and s.spellid > 0 then
					GameTooltip_SetDefaultAnchor(GameTooltip, s);
					GameTooltip:SetSpellByID(s.spellid);
				end
			end)
			button:SetScript("OnLeave", function()
				GameTooltip:Hide();
			end)
		end
	end
end

local function initAddon()
	C_Timer.After(1, ns.SetupOptionPanels);

	DBM:RegisterCallback("DBM_TimerStart", asDBMTimer_callback);
	DBM:RegisterCallback("DBM_TimerStop", asDBMTimer_callback);
	DBM:RegisterCallback("DBM_TimerFadeUpdate", asDBMTimer_callback);
	DBM:RegisterCallback("DBM_TimerUpdate", asDBMTimer_callback);
	DBM:RegisterCallback("DBM_TimerPause", asDBMTimer_callback);
	DBM:RegisterCallback("DBM_TimerResume", asDBMTimer_callback);

	C_Timer.NewTicker(0.05, checkList);
end

local bloaded = C_AddOns.LoadAddOn("DBM-Core");
if bloaded then
	initAddon();
	setupUI();
end
