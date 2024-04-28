local _, ns = ...;
---설정부
local CONFIG_SOUND_SPEED = 1 -- 음성안내 읽기 속도
local CONFIG_VOICE_ID = 0    -- 음성 종류 (한국 Client 는 0번 1가지만 지원)
local CONFIG_X = 230;
local CONFIG_Y = -25;
local CONFIG_SIZE = 45;
local CONFIG_VOICE_DELAY = 2 -- 케스팅 끝나고 같은 음성 2초간 금지

-- Castbar 설정
local CONFIG_WIDTH = 175
local CONFIG_HEIGHT = 20
local CONFIG_ALPHA = 0.8;                                                 --투명도 80%
local CONFIG_NAME_SIZE = CONFIG_HEIGHT * 0.5;                             --Spell 명 Font Size, 높이의 50%
local CONFIG_TIME_SIZE = CONFIG_HEIGHT * 0.3;                             --Spell 시전시간 Font Size, 높이의 30%
local CONFIG_UPDATE_RATE = 0.05                                           -- 20프레임

local CONFIG_NOT_INTERRUPTIBLE_COLOR = { 0.9, 0.9, 0.9 };                 --차단 불가시 (내가 아닐때) 색상 (r, g, b)
local CONFIG_NOT_INTERRUPTIBLE_COLOR_TARGET = { 153 / 255, 0, 76 / 255 }; --차단 불가시 (내가 타겟일때) 색상 (r, g, b)
local CONFIG_INTERRUPTIBLE_COLOR = { 204 / 255, 255 / 255, 153 / 255 };   --차단 가능(내가 타겟이 아닐때)시 색상 (r, g, b)
local CONFIG_INTERRUPTIBLE_COLOR_TARGET = { 76 / 255, 153 / 255, 0 };     --차단 가능(내가 타겟일 때)시 색상 (r, g, b)

local function isAttackable(unit)
	local reaction = UnitReaction("player", unit);
	if reaction and reaction <= 4 then
		return true;
	end
	return false;
end

local ADVA = nil;
local timer = nil;
local DangerousSpellList = {};
local CastingUnits = {};

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

local function Comparator(a, b)
	if a.focus then
		return true;
	end

	if b.focus then
		return false;
	end

	if a.target then
		return true;
	end

	if b.target then
		return false;
	end

	return a.expiration < b.expiration;
end

local castingInfos;
local prev_count = 0;
local prev_focus = 0;
local prev_target = 0;


local function ADCA_OnUpdate()
	if castingInfos == nil then
		castingInfos = TableUtil.CreatePriorityTable(Comparator, TableUtil.Constants.AssociativePriorityTable);
	else
		castingInfos:Clear();
	end

	local alert_name = nil;
	local alert_noi = false;
	local alert_focus = false;
	local alert_focus_noi = false;
	local alert_target = false;
	local alert_target_noi = false;

	for unit, needtosound in pairs(CastingUnits) do
		if UnitExists(unit) then
			local name, text, texture, startTimeMS, endTimeMS, isTradeSkill, castID, notInterruptible, spellId =
				UnitCastingInfo(unit);
			if not name then
				name, text, texture, startTimeMS, endTimeMS, isTradeSkill, notInterruptible, spellId = UnitChannelInfo(
					unit);
			end

			if name and DangerousSpellList[spellId] then
				-- Handle cooldowns						
				local start = startTimeMS / 1000;
				local duration = (endTimeMS - startTimeMS) / 1000;
				local expirationTime = endTimeMS / 1000;

				castingInfos[unit] = {
					icon = texture,
					name = name,
					start = start,
					duration = duration,
					expiration = expirationTime,
					spellId = spellId,
					notInterruptible = notInterruptible,
					focus = UnitExists("focus") and UnitIsUnit("focus", unit),
					needtointerrupt = (DangerousSpellList[spellId] == "interrupt"),
					target = UnitExists("target") and UnitIsUnit("target", unit),
				}
			else
				CastingUnits[unit] = nil;
			end
		else
			CastingUnits[unit] = nil;
		end
	end

	local i = 1;

	castingInfos:Iterate(
		function(unit, castingInfo)
			if i > 3 then
				return true;
			end

			local targetunit = unit .. "target";
			local btargeted = UnitExists(targetunit) and UnitIsUnit(targetunit, "player");

			if castingInfo.needtointerrupt then
				if castingInfo.focus then
					if castingInfo.notInterruptible then
						alert_focus_noi = true;
					end
					alert_focus = true;
				elseif castingInfo.target then
					if castingInfo.notInterruptible then
						alert_target_noi = true;
					end
					alert_target = true;
				else
					if alert_name == nil then
						alert_name = castingInfo.name;
						if castingInfo.notInterruptible then
							alert_noi = true;
						end
					end
				end
			end

			if ns.options.HideTarget and castingInfo.target and not castingInfo.focus then
				return false;
			end


			local frame = ADVA.bars[i];
			local color = CONFIG_INTERRUPTIBLE_COLOR;
			frame.castspellid = castingInfo.spellId;

			-- set the icon
			local frameIcon = frame.button.icon
			frameIcon:SetTexture(castingInfo.icon);
			local frameName = frame.name;
			frameName:SetText(castingInfo.name);
			frameName:Show();

			local frameMark = frame.button.mark;
			frameMark:SetText(ADCA_DisplayRaidIcon(unit));
			frameMark:Show();

			frame.start = castingInfo.start;
			frame.duration = castingInfo.duration;

			frame:SetMinMaxValues(0, frame.duration);

			if castingInfo.notInterruptible then
				if btargeted then
					color = CONFIG_NOT_INTERRUPTIBLE_COLOR_TARGET;
				else
					color = CONFIG_NOT_INTERRUPTIBLE_COLOR;
				end
			else
				if btargeted then
					color = CONFIG_INTERRUPTIBLE_COLOR_TARGET;
				else
					color = CONFIG_INTERRUPTIBLE_COLOR;
				end
			end

			if castingInfo.needtointerrupt then
				ns.lib.PixelGlow_Start(frame.button, { 1, 1, 0, 1 });
				ns.lib.PixelGlow_Start(frame, { 1, 1, 0, 1 });
			else
				ns.lib.PixelGlow_Stop(frame.button);
				ns.lib.PixelGlow_Stop(frame);
			end

			frame:SetStatusBarColor(color[1], color[2], color[3]);
			local targetname = frame.targetname;

			if UnitExists(targetunit) and UnitIsPlayer(targetunit) then
				local _, Class = UnitClass(targetunit)
				local color = RAID_CLASS_COLORS[Class]
				targetname:SetTextColor(color.r, color.g, color.b);
				targetname:SetText(UnitName(targetunit));
				targetname:Show();
			else
				targetname:SetText("");
				targetname:Hide();
			end

			frame:Show();

			i = i + 1;
		end)

	for j = i, 3 do
		local frame = ADVA.bars[j];
		frame.start = 0;
		frame:Hide();
	end

	if ns.options.PlaySound then
		if alert_focus and prev_focus == 0 then
			if not ns.options.TTS then
				if alert_focus_noi then
					PlaySoundFile("Interface\\AddOns\\asDBMCastingAlert\\focusstun.mp3", "MASTER");
				else
					PlaySoundFile("Interface\\AddOns\\asDBMCastingAlert\\focus.mp3", "MASTER");
				end
			else
				if alert_focus_noi then
					C_VoiceChat.SpeakText(CONFIG_VOICE_ID, "주시스턴", Enum.VoiceTtsDestination.LocalPlayback,
						CONFIG_SOUND_SPEED, ns.options.SoundVolume);
				else
					C_VoiceChat.SpeakText(CONFIG_VOICE_ID, "주시짤", Enum.VoiceTtsDestination.LocalPlayback,
						CONFIG_SOUND_SPEED, ns.options.SoundVolume);
				end
			end
		end

		if alert_target and prev_target == 0 then
			if not ns.options.TTS then
				if alert_target_noi then
					PlaySoundFile("Interface\\AddOns\\asDBMCastingAlert\\stun.mp3", "MASTER");
				else
					PlaySoundFile("Interface\\AddOns\\asDBMCastingAlert\\target.mp3", "MASTER");
				end
			else
				if alert_target_noi then
					C_VoiceChat.SpeakText(CONFIG_VOICE_ID, "스턴", Enum.VoiceTtsDestination.LocalPlayback,
						CONFIG_SOUND_SPEED, ns.options.SoundVolume);
				else
					C_VoiceChat.SpeakText(CONFIG_VOICE_ID, "짤", Enum.VoiceTtsDestination.LocalPlayback,
						CONFIG_SOUND_SPEED, ns.options.SoundVolume);
				end
			end
		end

		if alert_name and prev_count == 0 then
			if not ns.options.TTS then
				if alert_noi then
					PlaySoundFile("Interface\\AddOns\\asDBMCastingAlert\\stun2.mp3", "MASTER");
				else
					PlaySoundFile("Interface\\AddOns\\asDBMCastingAlert\\alert.mp3", "MASTER");
				end
			else
				C_VoiceChat.SpeakText(CONFIG_VOICE_ID, alert_name, Enum.VoiceTtsDestination.LocalPlayback,
					CONFIG_SOUND_SPEED, ns.options.SoundVolume);
			end
		end
	end

	if alert_focus then
		prev_focus = 1;
	else
		prev_focus = 0;
	end

	if alert_target then
		prev_target = 1;
	else
		prev_target = 0;
	end

	if alert_name then
		prev_count = 1;
	else
		prev_count = 0;
	end
end

local bfirst = true;
local function ADCA_OnEvent(self, event, arg1, arg2, arg3, arg4)
	if bfirst then
		ns.SetupOptionPanels();
		bfirst = false;
	end

	if event == "PLAYER_ENTERING_WORLD" then
		VoiceAlertTime = {};
	else
		local unit = arg1;
		local spellid = arg3;
		if unit and spellid and isAttackable(unit) and UnitAffectingCombat(unit) and string.find(unit, "nameplate") then
			CastingUnits[unit] = true;
		end
	end
end

local function Bar_OnUpdate(self, ef)
	local start = self.start;
	self.ef = self.ef + ef;


	if start > 0 and self.ef > CONFIG_UPDATE_RATE then
		self.ef = 0;

		local castBar = self;
		local duration = self.duration;
		local current = GetTime();
		local time = self.time;
		castBar:SetValue((current - start));
		time:SetText(format("%.1f/%.1f", max((current - start), 0), max(duration, 0)));
	end
end


local function CreateCastbars(parent)
	if parent.bars == nil then
		parent.bars = {};
	end

	for idx = 1, 3 do
		parent.bars[idx] = CreateFrame("StatusBar", nil, UIParent)
		local frame = parent.bars[idx];
		frame:SetStatusBarTexture("Interface\\addons\\asDBMCastingAlert\\UI-StatusBar", "BORDER")
		frame:GetStatusBarTexture():SetHorizTile(false)
		frame:SetMinMaxValues(0, 100)
		frame:SetValue(100)
		frame:SetHeight(CONFIG_HEIGHT)
		frame:SetWidth(CONFIG_WIDTH - CONFIG_HEIGHT / 2)
		frame:SetStatusBarColor(1, 0.9, 0.9);
		frame:SetAlpha(1);

		frame.bg = frame:CreateTexture(nil, "BACKGROUND")
		frame.bg:SetPoint("TOPLEFT", frame, "TOPLEFT", -1, 1)
		frame.bg:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", 1, -1)

		frame.bg:SetTexture("Interface\\Addons\\asDBMCastingAlert\\border.tga")
		frame.bg:SetTexCoord(0.1, 0.1, 0.1, 0.1, 0.1, 0.1, 0.1, 0.1)
		frame.bg:SetVertexColor(0, 0, 0, 0.8);
		frame.bg:Show();

		frame.name = frame:CreateFontString(nil, "OVERLAY");
		frame.name:SetFont(STANDARD_TEXT_FONT, CONFIG_NAME_SIZE);
		frame.name:SetPoint("LEFT", frame, "LEFT", 3, 0);

		frame.time = frame:CreateFontString(nil, "OVERLAY");
		frame.time:SetFont(STANDARD_TEXT_FONT, CONFIG_TIME_SIZE);
		frame.time:SetPoint("TOPRIGHT", frame, "TOPRIGHT", -3, -2);

		if idx == 1 then
			frame:SetPoint("TOPRIGHT", parent, "TOP", 150, 0)
		else
			frame:SetPoint("TOPRIGHT", parent.bars[idx - 1], "BOTTOMRIGHT", 0, -1)
		end

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

		frame:EnableMouse(false);
		frame:SetMouseMotionEnabled(true);
		frame:Hide();

		frame.button = CreateFrame("Button", nil, frame, "asDCATemplate");
		frame.button:SetPoint("RIGHT", frame, "LEFT", -1, 0)
		frame.button:SetWidth((CONFIG_HEIGHT + 2) * 1.2);
		frame.button:SetHeight(CONFIG_HEIGHT + 2);
		frame.button:SetScale(1);
		frame.button:SetAlpha(1);
		frame.button:EnableMouse(false);
		frame.button:Show();
		frame.button.mark:ClearAllPoints();
		frame.button.mark:SetPoint("RIGHT", frame.button, "LEFT", -1, 0)
		frame.button.icon:SetTexCoord(.08, .92, .08, .92);
		frame.button.border:SetTexture("Interface\\Addons\\asDBMCastingAlert\\border.tga");
		frame.button.border:SetTexCoord(0.08, 0.08, 0.08, 0.92, 0.92, 0.08, 0.92, 0.92);
		frame.button.border:SetVertexColor(0, 0, 0);
		frame.button.border:Show();

		frame.targetname = frame:CreateFontString(nil, "OVERLAY");
		frame.targetname:SetFont(STANDARD_TEXT_FONT, CONFIG_TIME_SIZE);
		frame.targetname:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", -2, 2);

		frame.start = 0;
		frame.duration = 0;
		frame.ef = 0;

		frame:SetScript("OnUpdate", Bar_OnUpdate);
	end
end

local DBMobj;

local function scanDBM()
	DangerousSpellList = {};

	if DBMobj.Mods then
		for i, mod in ipairs(DBMobj.Mods) do
			if mod.announces then
				for k, obj in pairs(mod.announces) do
					if obj.spellId and obj.announceType then
						if DangerousSpellList[obj.spellId] == nil or DangerousSpellList[obj.spellId] ~= "interrupt" then
							DangerousSpellList[obj.spellId] = obj.announceType;
						end
					end
				end
			end
			if mod.specwarns then
				for k, obj in pairs(mod.specwarns) do
					if obj.spellId and obj.announceType then
						if DangerousSpellList[obj.spellId] == nil or DangerousSpellList[obj.spellId] ~= "interrupt" then
							DangerousSpellList[obj.spellId] = obj.announceType;
						end
					end
				end
			end
		end
	end
end

local function NewMod(self, ...)
	DBMobj = self;
	C_Timer.After(0.25, scanDBM);
end

local function initAddon()
	local bloaded = LoadAddOn("DBM-Core");
	if bloaded then
		hooksecurefunc(DBM, "NewMod", NewMod)
	end

	ADVA = CreateFrame("FRAME", nil, UIParent)
	ADVA:SetPoint("CENTER", CONFIG_X, CONFIG_Y)
	ADVA:SetWidth(1)
	ADVA:SetHeight(1)
	ADVA:Show();

	bloaded = LoadAddOn("asMOD")

	CreateCastbars(ADVA);

	if bloaded and asMOD_setupFrame then
		asMOD_setupFrame(ADVA, "asDBMCastingAlert");
	end

	ADVA:SetScript("OnEvent", ADCA_OnEvent);
	ADVA:RegisterEvent("UNIT_SPELLCAST_START");
	ADVA:RegisterEvent("UNIT_SPELLCAST_CHANNEL_START");
	ADVA:RegisterEvent("PLAYER_ENTERING_WORLD");

	timer = C_Timer.NewTicker(0.2, ADCA_OnUpdate);
	local ttsinfos = C_VoiceChat.GetTtsVoices();
	local locale = GetLocale();
	local findLang = "Korean";

	if not (locale == "koKR") then
		findLang = "English";
	end

	for id, v in pairs(ttsinfos) do
		if strfind(v.name, findLang) then
			CONFIG_VOICE_ID = v.voiceID;
			print("[asDBMCastingAlert]" .. v.name .. "로 음성 설정");
		end
	end
end



initAddon();
