---설정부
local CONFIG_SOUND_SPEED = 1 -- 음성안내 읽기 속도
local CONFIG_VOICE_ID = 3    -- 음성 종류 (한국 Client 는 0번 1가지만 지원)
local CONFIG_SOUND_VOL = 100 -- 음성 안내 소리 크기
local CONFIG_SOUND = true    -- 음성 여부
local CONFIG_X = 170;
local CONFIG_Y = 0;
local CONFIG_SIZE = 45;

local function isFaction(unit)
	if UnitIsUnit("player", unit) then
		return false;
	else
		local reaction = UnitReaction("player", unit);
		if reaction and reaction <= 4 then
			return true;
		elseif UnitIsPlayer(unit) then
			return false;
		end
	end
end

local ADVA = nil;
local timer = nil;
local ADCA_DangerousSpellList = {};
local CastingUnits = {};
local SoundedUnits = {};

function ADCA_DBMTimer_callback(event, id, ...)
	local spellId = select(5, ...);
	if spellId then
		ADCA_DangerousSpellList[spellId] = true;
	end
end

local function asCooldownFrame_Clear(self)
	self:Clear();
end

local function asCooldownFrame_Set(self, start, duration, enable, forceShowDrawEdge, modRate)
	if enable and enable ~= 0 and start > 0 and duration > 0 then
		self:SetDrawEdge(forceShowDrawEdge);
		self:SetCooldown(start, duration, modRate);
	else
		asCooldownFrame_Clear(self);
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


local function ADCA_DisplayRaidIcon(unit)
	local icon = GetRaidTargetIndex(unit)
	if icon and RaidIconList[icon] then
		return RaidIconList[icon] .. "0|t"
	else
		return ""
	end
end

local function ADCA_OnUpdate()
	local i = 1;
	for unit, bupdate in pairs(CastingUnits) do
		if UnitExists(unit) then
			local name, text, texture, startTimeMS, endTimeMS, isTradeSkill, castID, notInterruptible, spellId =
				UnitCastingInfo(unit);
			if not name then
				name, text, texture, startTimeMS, endTimeMS, isTradeSkill, notInterruptible, spellId = UnitChannelInfo(
					unit);
			end

			if name then
				if i <= 3 and ADCA_DangerousSpellList[spellId] then
					if CONFIG_SOUND and SoundedUnits[unit] == nil then
						C_VoiceChat.SpeakText(CONFIG_VOICE_ID, name, Enum.VoiceTtsDestination.LocalPlayback,
							CONFIG_SOUND_SPEED, CONFIG_SOUND_VOL);
						SoundedUnits[unit] = true;
					end
					local frame = ADVA.frames[i];
					frame.castspellid = spellId;

					-- set the icon
					local frameIcon = frame.icon
					frameIcon:SetTexture(texture);
					local frameName = frame.text;
					frameName:SetText(name);
					frameName:Show();

					local frameMark = frame.mark;
					frameMark:SetText(ADCA_DisplayRaidIcon(unit));
					frameMark:Show();

					-- Handle cooldowns
					local frameCooldown = frame.cooldown;
					local expirationTime = endTimeMS / 1000;
					local duration = (endTimeMS - startTimeMS) / 1000;

					if (duration > 0) then
						frameCooldown:Show();
						asCooldownFrame_Set(frameCooldown, expirationTime - duration, duration, duration > 0,
							true);
					else
						frameCooldown:Hide();
					end

					local frameBorder = frame.border;

					if notInterruptible then
						frameBorder:SetVertexColor(0, 0, 0);
					else
						frameBorder:SetVertexColor(0, 1, 0);
					end


					frame:Show();


					i = i + 1;
				end
			else
				CastingUnits[unit] = nil;
				SoundedUnits[unit] = nil;
			end
		else
			CastingUnits[unit] = nil;
			SoundedUnits[unit] = nil;
		end
	end

	for j = i, 3 do
		local frame = ADVA.frames[j];

		frame:Hide();
	end
end

local function ADCA_OnEvent(self, event, arg1, arg2, arg3, arg4)
	if event == "PLAYER_ENTERING_WORLD" then
		ADCA_DangerousSpellList = {};
	else
		local unit = arg1;
		local spellid = arg3;
		if unit and spellid and isFaction(unit) and string.find(unit, "nameplate") then
			CastingUnits[unit] = true;
			ADCA_OnUpdate();
		end
	end
end


local function UpdateBuffAnchor(frames, index, offsetX, right, center, parent)
	local buff = frames[index];
	buff:ClearAllPoints();

	if center then
		if (index == 1) then
			buff:SetPoint("TOP", parent, "CENTER", 0, 0);
		elseif (index == 2) then
			buff:SetPoint("RIGHT", frames[index - 1], "LEFT", -offsetX, 0);
		elseif (math.fmod(index, 2) == 1) then
			buff:SetPoint("LEFT", frames[index - 2], "RIGHT", offsetX, 0);
		else
			buff:SetPoint("RIGHT", frames[index - 2], "LEFT", -offsetX, 0);
		end
	else
		local point1 = "TOPLEFT";
		local point2 = "CENTER";
		local point3 = "TOPRIGHT";

		if (right == false) then
			point1 = "TOPRIGHT";
			point2 = "CENTER";
			point3 = "TOPLEFT";
			offsetX = -offsetX;
		end

		if (index == 1) then
			buff:SetPoint(point1, parent, point2, 0, 0);
		else
			buff:SetPoint(point1, frames[index - 1], point3, offsetX, 0);
		end
	end
	-- Resize
	buff:SetWidth(CONFIG_SIZE);
	buff:SetHeight(CONFIG_SIZE * 0.8);
end

local function CreatBuffFrames(parent, bright, bcenter)
	if parent.frames == nil then
		parent.frames = {};
	end

	for idx = 1, 3 do
		parent.frames[idx] = CreateFrame("Button", nil, parent, "asDCATemplate");
		local frame = parent.frames[idx];
		frame:EnableMouse(false);
		frame.icon:SetTexCoord(.08, .92, .08, .92);
		frame.icon:SetAlpha(1);
		frame.border:SetTexture("Interface\\Addons\\asDBMCastingAlert\\border.tga");
		frame.border:SetTexCoord(0.08, 0.08, 0.08, 0.92, 0.92, 0.08, 0.92, 0.92);
		frame.border:SetAlpha(1);

		UpdateBuffAnchor(parent.frames, idx, 1, bright, bcenter, parent);

		if not frame:GetScript("OnEnter") then
			frame:SetScript("OnEnter", function(s)
				if s.castspellid and s.castspellid > 0 then
					GameTooltip_SetDefaultAnchor(GameTooltip, s);
					GameTooltip:SetSpellByID(s.castspellid);
				end
			end)
			frame:SetScript("OnLeave", function()
				GameTooltip:Hide();
			end)
		end

		frame:Hide();
	end

	return;
end

local function initAddon()
	local bloaded = LoadAddOn("DBM-Core");
	if bloaded then
		DBM:RegisterCallback("DBM_TimerStart", ADCA_DBMTimer_callback);
	end

	ADVA = CreateFrame("FRAME", nil, UIParent)
	ADVA:SetPoint("CENTER", CONFIG_X, CONFIG_Y)
	ADVA:SetWidth(1)
	ADVA:SetHeight(1)
	ADVA:Show();

	bloaded = LoadAddOn("asMOD")

	CreatBuffFrames(ADVA, true, false);

	if bloaded and asMOD_setupFrame then
		asMOD_setupFrame(ADVA, "asDBMCastingAlert");
	end

	ADVA:SetScript("OnEvent", ADCA_OnEvent);
	ADVA:RegisterEvent("UNIT_SPELLCAST_START");
	ADVA:RegisterEvent("UNIT_SPELLCAST_CHANNEL_START");
	ADVA:RegisterEvent("PLAYER_ENTERING_WORLD");

	timer = C_Timer.NewTicker(0.2, ADCA_OnUpdate);
end



initAddon();