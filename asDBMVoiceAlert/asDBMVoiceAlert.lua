---설정부
local CONFIG_SOUND_SPEED = 1 -- 음성안내 읽기 속도
local CONFIG_VOICE_ID = 0    -- 음성 종류 (한국 Client 는 0번 1가지만 지원)
local CONFIG_SOUND_VOL = 100 -- 음성 안내 소리 크기

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

local ADVA_DangerousSpellList = {};
local CastingInfo = {};

function ADVA_DBMTimer_callback(event, id, ...)
	local spellId = select(5, ...);
	if spellId then
		ADVA_DangerousSpellList[spellId] = true;
	end
end

local function ADVA_OnEvent(self, event, arg1, arg2, arg3, arg4)
	local unit = arg1;
	local spellid = arg3;

	if unit and isFaction(unit) and unit ~= "target" and unit ~= "focus" and spellid then
		
		local name, _, _, _, endTime, _, _, _, spellid = UnitCastingInfo(unit);
		if not name then
			name, _, _, _, endTime, _, _, spellid = UnitChannelInfo(unit);
		end

		if name and (CastingInfo[unit] == nil or CastingInfo[unit] < endTime) then
			CastingInfo[unit] = endTime;
			if ADVA_DangerousSpellList[spellid] then
			--if true then
				C_VoiceChat.SpeakText(CONFIG_VOICE_ID, "시전 " .. name, Enum.VoiceTtsDestination.LocalPlayback,
					CONFIG_SOUND_SPEED, CONFIG_SOUND_VOL);
			end
		end
	end
end

local ADVA = nil;

local function initAddon()
	local bloaded = LoadAddOn("DBM-Core");
	if bloaded then
		DBM:RegisterCallback("DBM_TimerStart", ADVA_DBMTimer_callback);
	end

	ADVA = CreateFrame("FRAME", nil, UIParent)
	ADVA:SetPoint("BOTTOM", UIParent, "BOTTOM", 0, 0)
	ADVA:SetWidth(0)
	ADVA:SetHeight(0)
	ADVA:Show();

	ADVA:SetScript("OnEvent", ADVA_OnEvent)
	ADVA:RegisterEvent("UNIT_SPELLCAST_START");
	ADVA:RegisterEvent("UNIT_SPELLCAST_CHANNEL_START");
end



initAddon();
