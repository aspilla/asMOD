---설정부
local ACTA_UpdateRate = 0.2			-- Check할 주기
local ACTA_MaxShow = 3				-- 최대로 보여줄 개수
local ACTA_FontSize = 18;
local ACTA_X = 0;
local ACTA_Y = -80;
local needtowork = false;

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

local currshow = 1;

local ACTA_DangerousSpellList = {};
local IsDanger = false;

local function CheckCasting(nameplate)

	if not nameplate or nameplate:IsForbidden()  then
		return false;
	end

	if not nameplate.UnitFrame or nameplate.UnitFrame:IsForbidden()  then
		return false;
	end

	local unit = nameplate.UnitFrame.unit;

	if isFaction(unit) and UnitIsUnit(unit .."target", "player") and not UnitIsUnit(unit, "target") then
		local name,  text, texture, startTime, endTime, isTradeSkill, castID, notInterruptible, spellid = UnitCastingInfo(unit);
		if not name then
			name,  text, texture, startTime, endTime, isTradeSkill, notInterruptible, spellid = UnitChannelInfo(unit);
		end

		if name then

			local curr = GetTime();
			local remain = (endTime/1000) - curr;

			if remain > 0 then
				ACTA.cast[currshow]:SetText("|T"..texture..":0|t" .. format("%.1f", max(remain, 0)) .. "|T"..texture..":0|t");
				if remain < 1.5 then
					ACTA.cast[currshow]:SetTextColor(0.8, 0.5, 0.5);
				else
					ACTA.cast[currshow]:SetTextColor(1, 1, 1);
				end

				ACTA.cast[currshow]:Show();
				currshow = currshow + 1;

				if ACTA_DangerousSpellList[spellid] then
					IsDanger = true;
				end
			end			
		end
	end
end

local function ACTA_OnUpdate()

	local prev_show = currshow;

	currshow = 1;
	IsDanger = false;

	for _,v in pairs(C_NamePlate.GetNamePlates(issecure())) do
		local nameplate = v;
		if (nameplate) then

			CheckCasting(nameplate);
			if currshow > ACTA_MaxShow then
				break;
			end
		end
	end

	for i = currshow, ACTA_MaxShow do
		ACTA.cast[i]:Hide();
	end

	if currshow > prev_show and IsDanger then
		--PlaySoundFile("Interface\\AddOns\\asCastingAlert\\alert.mp3", "DIALOG")
	end
end




local function ACTA_OnEvent(self, event)

	if event == "PLAYER_ENTERING_WORLD" then
		needtowork = false;
		local inInstance, instanceType = IsInInstance();

		if (inInstance and instanceType == "party") then
			needtowork = true;
		end

		ACTA_DangerousSpellList = {};
	end
end

function ACTA_DBMTimer_callback(event, id, ...)
	local msg, timer, icon, type, spellId, colorId, modid, keep, fade, name, guid = ...;
	if spellId then
		ACTA_DangerousSpellList[spellId] = true;
	end
end


local function initAddon()
	ACTA = CreateFrame("Frame", nil, UIParent);
	ACTA.cast = {};

	for i = 1, ACTA_MaxShow do
		ACTA.cast[i] = ACTA:CreateFontString(nil, "OVERLAY");
		ACTA.cast[i]:SetFont("Fonts\\2002.TTF", ACTA_FontSize, "THICKOUTLINE")

		if i == 1 then
			ACTA.cast[i]:SetPoint("CENTER", UIParent, "CENTER", ACTA_X , ACTA_Y);
		else
			ACTA.cast[i]:SetPoint("BOTTOM", ACTA.cast[i - 1], "TOP", 0 , 3);
		end
		ACTA.cast[i]:Hide();
	end

	ACTA:RegisterEvent("PLAYER_ENTERING_WORLD");
	ACTA:SetScript("OnEvent", ACTA_OnEvent)
	--주기적으로 Callback
	C_Timer.NewTicker(ACTA_UpdateRate, ACTA_OnUpdate);

	local bloaded = LoadAddOn("DBM-Core");
	if bloaded then
		DBM:RegisterCallback("DBM_TimerStart", ACTA_DBMTimer_callback );
	end

end
initAddon();