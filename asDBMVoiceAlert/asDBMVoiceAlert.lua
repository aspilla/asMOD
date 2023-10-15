---설정부
local ADVA_UpdateRate = 0.2 -- Check할 주기

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
local TTL_Cache = {};

local function CheckCasting(nameplate)
	if not nameplate or nameplate:IsForbidden() then
		return false;
	end

	if not nameplate.UnitFrame or nameplate.UnitFrame:IsForbidden() then
		return false;
	end

	local unit = nameplate.UnitFrame.unit;

	if isFaction(unit) then
		local name, _, texture, _, endTime, _, _, _, spellid = UnitCastingInfo(unit);
		if not name then
			name, _, texture, _, endTime, _, _, spellid = UnitChannelInfo(unit);
		end

		if name then
			if ADVA_DangerousSpellList[spellid] and (TTL_Cache[unit] == nil or TTL_Cache[unit] ~= spellid) then
			--if (TTL_Cache[unit] == nil or TTL_Cache[unit] ~= spellid) then
				C_VoiceChat.SpeakText(0, "시전 "..name, Enum.VoiceTtsDestination.LocalPlayback, 0, 100);
				TTL_Cache[unit] = spellid;
			end
		else
			TTL_Cache[unit] = nil;
		end
	end
end

local bflush = false;

local function ADVA_OnUpdate()
	if InCombatLockdown() then

		bflush = false;

		for _, v in pairs(C_NamePlate.GetNamePlates(issecure())) do
			local nameplate = v;
			if (nameplate) then
				CheckCasting(nameplate);
			end
		end
	elseif bflush == false then
		TTL_Cache = {};
		bflush = true;		
	end
end


function ADVA_DBMTimer_callback(event, id, ...)
	local spellId = select(5, ...);
	if spellId then
		ADVA_DangerousSpellList[spellId] = true;
	end
end

local function initAddon()
	local bloaded = LoadAddOn("DBM-Core");
	if bloaded then
		DBM:RegisterCallback("DBM_TimerStart", ADVA_DBMTimer_callback);
	end

	--주기적으로 Callback
	C_Timer.NewTicker(ADVA_UpdateRate, ADVA_OnUpdate);
end
initAddon();