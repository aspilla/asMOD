---설정부
local AAM_UpdateRate = 0.2 -- Check할 주기
local AAM_MaxMark = 7      -- 최대 징표 X까지 찍도록 설정

--[[

1 = Yellow 4-point Star
2 = Orange Circle
3 = Purple Diamond
4 = Green Triangle
5 = White Crescent Moon
6 = Blue Square
7 = Red "X" Cross
8 = White Skull

]]

local NPCTable = {

	-- 용군단 시즌 3 (https://wago.io/3bViaBtT1)

	[100486] = 2,
	[100527] = 2,
	[101991] = 2,
	[102788] = 2,
	[122969] = 2,
	[122971] = 0,
	[122972] = 2,
	[122973] = 2,
	[122984] = 0,
	[125977] = 2,
	[127879] = 2,
	[128434] = 2,
	[129553] = 2,
	[131586] = 2,
	[131587] = 2,
	[131666] = 0,
	[131670] = 2,
	[131677] = 2,
	[131685] = 2,
	[131812] = 2,
	[131818] = 0,
	[131819] = 2,
	[131850] = 2,
	[131858] = 0,
	[132126] = 0,
	[134024] = 1,			-- 탐욕스러운 구더기, 징표 안찍음
	[135365] = 2,
	[135474] = 2,
	[135552] = 0,
	[199748] = 2,
	[201223] = 2,
	[204560] = 0,
	[204918] = 2,
	[205158] = 2,
	[205212] = 2,
	[205337] = 2,
	[205363] = 2,
	[205384] = 2,
	[205408] = 0,
	[205691] = 2,
	[205727] = 2,
	[206064] = 0,
	[206066] = 0,
	[206074] = 2,
	[206140] = 2,
	[212775] = 2,
	[213806] = 2,
	[214209] = 2,
	[40634] = 2,
	[40925] = 0,
	[40943] = 2,
	[44404] = 2,
	[81819] = 2,
	[81820] = 2,
	[81985] = 0,
	[83892] = 2,
	[83893] = 2,
	[84957] = 2,
	[84989] = 2,
	[84990] = 2,
	[95766] = 0,
	[95769] = 2,
	[95771] = 2,
	[98280] = 2,
	[98370] = 2,
	[98521] = 2,
	[98691] = 2,
	[98810] = 0,
	[98813] = 2,
	[99366] = 2,


	-- 용군단 시즌 2 (https://wago.io/3bViaBtT1)
	[102232] = 2,
	[126919] = 2,
	[127111] = 0,
	[128551] = 0,
	[129527] = 2,
	[129529] = 2,
	[129547] = 0,
	[129559] = 2,
	[129600] = 2,
	[129788] = 2,
	[130012] = 2,
	[130909] = 2,
	[131436] = 0,
	[131492] = 2,
	[133685] = 2,
	[133835] = 0,
	[133836] = 0,
	[133870] = 2,
	[133912] = 2,
	[134284] = 2,
	[138187] = 2,
	[184022] = 2,
	[184023] = 0,
	[184132] = 2,
	[184301] = 2,
	[184319] = 0,
	[184580] = 0,
	[185528] = 2,
	[185656] = 2,
	[186125] = 0,
	[186191] = 2,
	[186208] = 2,
	[186220] = 2,
	[186226] = 2,
	[186229] = 2,
	[186246] = 2,
	[186420] = 2,
	[186658] = 2,
	[189235] = 0,
	[189247] = 0,
	[189265] = 2,
	[189299] = 2,
	[189363] = 0,
	[189464] = 2,
	[189470] = 0,
	[189531] = 2,
	[190340] = 2,
	[190342] = 2,
	[190345] = 0,
	[190362] = 2,
	[190368] = 2,
	[190373] = 2,
	[190377] = 2,
	[190405] = 2,
	[190407] = 0,
	[192788] = 2,
	[193352] = 0,
	[193799] = 0,
	[193944] = 2,
	[195135] = 2,
	[196043] = 2,
	[199037] = 2,
	[45477] = 0,
	[45704] = 2,
	[45912] = 2,
	[45915] = 0,
	[45922] = 2,
	[45924] = 0,
	[45928] = 2,
	[45930] = 0,
	[45935] = 2,
	[90998] = 2,
	[91000] = 0,
	[91001] = 0,
	[91006] = 2,
	[92538] = 2,
	-- 용군단 시즌1

	[56448] = 2,
	[200137] = 2,
	[200126] = 2,
	[59555] = 2,
	[59552] = 2,
	[59546] = 2,
	[76104] = 2,
	[75459] = 2,
	[75713] = 2,
	[76446] = 2,
	[77700] = 2,
	[75506] = 2,
	[104217] = 2,
	[104247] = 2,
	[104246] = 2,
	[104270] = 2,
	[104300] = 2,
	[105715] = 2,
	[97202] = 2,
	[102019] = 2,
	[95834] = 2,
	[97197] = 2,
	[96664] = 2,
	[95842] = 2,
	[97081] = 2,
	[95843] = 2,
	[97083] = 2,
	[97084] = 2,
	[196202] = 2,
	[192333] = 2,
	[196548] = 2,
	[196798] = 2,
	[196045] = 2,
	[196576] = 2,
	[197905] = 2,
	[196044] = 2,
	[186339] = 2,
	[193462] = 2,
	[199717] = 2,
	[192800] = 2,
	[191847] = 2,
	[190294] = 2,
	[199719] = 2,
	[195696] = 2,
	[195877] = 2,
	[195928] = 2,
	[195927] = 2,
	[195930] = 2,
	[195929] = 2,
	[195265] = 2,
	[194317] = 2,
	[194315] = 2,
	[194316] = 2,
	[195842] = 2,
	[195851] = 2,
	[186741] = 2,
	[196115] = 2,
	[191164] = 2,
	[196102] = 2,
	[190187] = 2,
	[187155] = 2,
	[187154] = 2,
	[188252] = 2,
	[189886] = 2,
	[197985] = 2,
	[188067] = 2,
	[187969] = 2,
	[197535] = 2,
	[197509] = 2,
	[190207] = 2,
	[190206] = 2,
	[198047] = 2,
};

asAutoMarkerF = {};

asAutoMarkerF.IsAutoMarkerMob = function(unit)
	local guid = UnitGUID(unit);
	if guid then
		local npcID = select(6, strsplit("-", guid));
		npcID = tonumber(npcID);

		if NPCTable[npcID] and NPCTable[npcID] > 0 then
			return true;
		end
	end

	return false;
end

local function checkMob(unit)
	local guid = UnitGUID(unit);
	if guid then
		local npcID = select(6, strsplit("-", guid));
		npcID = tonumber(npcID);

		if NPCTable[npcID] and NPCTable[npcID] > 0 then
			return NPCTable[npcID];
		end
	end

	return 0;
end

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

local curr_mark = 1;
local tmp = {};
local abledMarks = { true, true, true, true, true, true, true, true };

local function CheckPartyMarks()
	local unit = "player";
	local mark = GetRaidTargetIndex(unit);

	if mark ~= nil and mark <= AAM_MaxMark then
		abledMarks[mark] = false;
	end

	for i = 1, GetNumGroupMembers() do
		local unit = "party" .. i;
		local mark = GetRaidTargetIndex(unit);

		if mark ~= nil and mark <= AAM_MaxMark then
			abledMarks[mark] = false;
		end
	end
end

local function UpdateMarks(nameplate)
	local unit = "mouseover"

	if nameplate then
		if not nameplate or nameplate:IsForbidden() then
			return false;
		end

		unit = nameplate.namePlateUnitToken;
	end

	local status = UnitThreatSituation("player", unit);

	if (unit == "mouseover" or (unit and status and status > 0)) and isFaction(unit) and not UnitIsDead(unit) then
		local guid = UnitGUID(unit);
		if checkMob(unit) > 1 then
			while (curr_mark <= AAM_MaxMark) do
				if abledMarks[curr_mark] then
					break;
				else
					curr_mark = curr_mark + 1;
				end
			end

			if tmp[guid] == nil and curr_mark <= AAM_MaxMark then
				SetRaidTarget(unit, curr_mark);
				tmp[guid] = curr_mark;
				abledMarks[curr_mark] = false;
				curr_mark = curr_mark + 1;
			end
		end
	end

end

local function AAM_OnUpdate()
	if not needtowork then
		return;
	end

	curr_mark = 1;

	CheckPartyMarks();

	UpdateMarks();

	for _, v in pairs(C_NamePlate.GetNamePlates(issecure())) do
		local nameplate = v;
		if (nameplate) then
			UpdateMarks(nameplate);
		end
	end	
end



local function AAM_OnEvent(self, event, ...)
	if event == "PLAYER_ENTERING_WORLD" or event == "GROUP_JOINED" or event == "GROUP_ROSTER_UPDATE" or event == "PLAYER_ROLES_ASSIGNED" then
		needtowork = false;
		local inInstance, instanceType = IsInInstance();
		local assignedRole = UnitGroupRolesAssigned("player");

		if (inInstance and instanceType == "party") and (assignedRole and assignedRole == "TANK") then
			needtowork = true;
			AAM:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED");
			AAM:RegisterEvent("PLAYER_REGEN_ENABLED");
			AAM:RegisterEvent("UPDATE_MOUSEOVER_UNIT");
		else
			AAM:UnregisterEvent("COMBAT_LOG_EVENT_UNFILTERED");
			AAM:UnregisterEvent("PLAYER_REGEN_ENABLED");
			AAM:UnregisterEvent("UPDATE_MOUSEOVER_UNIT");
		end

		abledMarks = { true, true, true, true, true, true, true, true };
		tmp = {};
	elseif event == "PLAYER_REGEN_ENABLED" then
		abledMarks = { true, true, true, true, true, true, true, true };
		tmp = {};
	elseif event == "UPDATE_MOUSEOVER_UNIT" then
		AAM_OnUpdate();
	elseif (event == "COMBAT_LOG_EVENT_UNFILTERED") then
		local eventData = { CombatLogGetCurrentEventInfo() };
		local logEvent = eventData[2];
		local unitGUID = eventData[8];
		if ((logEvent == "UNIT_DIED") or (logEvent == "UNIT_DESTROYED")) then
			if tmp[unitGUID] then
				local mark = tmp[unitGUID];

				if mark <= AAM_MaxMark then
					abledMarks[mark] = true;					
				end
				tmp[unitGUID] = nil;
			end
		end
	end
end


local function initAddon()
	AAM = CreateFrame("Frame", nil, UIParent);
	AAM:RegisterEvent("PLAYER_ENTERING_WORLD");
	AAM:RegisterEvent("GROUP_JOINED");
	AAM:RegisterEvent("GROUP_ROSTER_UPDATE");
	AAM:RegisterEvent("PLAYER_ROLES_ASSIGNED");
	AAM:SetScript("OnEvent", AAM_OnEvent)
	--주기적으로 Callback
	C_Timer.NewTicker(AAM_UpdateRate, AAM_OnUpdate);
end
initAddon();
