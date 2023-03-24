---설정부
local AAM_UpdateRate = 0.2			-- Check할 주기
local AAM_MaxMark = 7				-- 최대 징표 X까지 찍도록 설정

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
	[56448] = true,
	[62358] = true,
	[200137] = true,
	[200126] = true,
	[59555] = true,
	[59552] = true,
	[59546] = true,
	[76104] = true,
	[75459] = true,
	[75713] = true,
	[76446] = true,
	[77700] = true,
	[75506] = true,
	[104217] = true,
	[104247] = true,
	[104246] = true,
	[104270] = true,
	[104300] = true,
	[105715] = true,
	[97202] = true,
	[102019] = true,
	[95834] = true,
	[97197] = true,
	[96664] = true,
	[95842] = true,
	[97081] = true,
	[95843] = true,
	[97083] = true,
	[97084] = true,
	[196202] = true,
	[192333] = true,
	[196548] = true,
	[196798] = true,
	[196045] = true,
	[196576] = true,
	[197905] = true,
	[196044] = true,
	[186339] = true,
	[193462] = true,
	[199717] = true,
	[192800] = true,
	[191847] = true,
	[190294] = true,
	[199719] = true,
	[195696] = true,
	[195877] = true,
	[195928] = true,
	[195927] = true,
	[195930] = true,
	[195929] = true,
	[195265] = true,
	[194317] = true,
	[194315] = true,
	[194316] = true,
	[195842] = true,
	[195851] = true,
	[186741] = true,
	[196115] = true,
	[191164] = true,
	[196102] = true,
	[190187] = true,
	[187155] = true,
	[187154] = true,
	[188252] = true,
	[189886] = true,
	[197985] = true,
	[188067] = true,
	[187969] = true,
	[197535] = true,
	[197509] = true,
	[190207] = true,
	[190206] = true,
	[198047] = true,
};

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
local abledMarks = {true, true, true, true, true, true, true, true};


local function CheckMarks(nameplate)

	local unit;

	if nameplate then
		if not nameplate or nameplate:IsForbidden()  then
			return false;
		end

		if not nameplate.UnitFrame or nameplate.UnitFrame:IsForbidden()  then
			return false;
		end

		unit = nameplate.namePlateUnitToken;
	else
		return
	end

	if unit and isFaction(unit)  then
		local mark = GetRaidTargetIndex(unit);

		if  mark ~= nil and mark <= AAM_MaxMark then
			abledMarks[mark] = false;
		end
	end
end

local function CheckPartyMarks()

	local unit = "player";
	local mark = GetRaidTargetIndex(unit);

	if  mark ~= nil and mark <= AAM_MaxMark then
		abledMarks[mark] = false;
	end

	for i=1,GetNumGroupMembers() do
		local unit = "party"..i;
		local mark = GetRaidTargetIndex(unit);

		if  mark ~= nil and mark <= AAM_MaxMark then
			abledMarks[mark] = false;			
		end
	end
end

local function UpdateMarks(nameplate)

	local unit = "mouseover"

	if nameplate then
		if not nameplate or nameplate:IsForbidden()  then
			return false;
		end

		if not nameplate.UnitFrame or nameplate.UnitFrame:IsForbidden()  then
			return false;
		end

		unit = nameplate.namePlateUnitToken;
	end

	local status = UnitThreatSituation("player", unit);

	if unit == "mouseover" or (unit and isFaction(unit) and status and status > 0) then
		local guid = UnitGUID(unit);
		if guid then
			local npcID = select(6, strsplit("-", guid));
   			npcID = tonumber(npcID);

			if NPCTable[npcID] == true then

				local mark = GetRaidTargetIndex(unit);

				while (curr_mark <= AAM_MaxMark) do

					if abledMarks[curr_mark] then
						break;
					else
						curr_mark = curr_mark + 1;
					end
				end

				if tmp[guid] == nil and mark == nil and curr_mark <= AAM_MaxMark then
					SetRaidTarget(unit, curr_mark);
					tmp[guid] = true;
					curr_mark = curr_mark + 1;
				end
			end
		end
	end
end

local function AAM_OnUpdate()

	if not needtowork then
		return;
	end

	curr_mark = 1;

	abledMarks = {true, true, true, true, true, true, true, true};

	CheckPartyMarks();

	for _,v in pairs(C_NamePlate.GetNamePlates(issecure())) do
		local nameplate = v;
		if (nameplate) then
			CheckMarks(nameplate);
		end
	end

	for _,v in pairs(C_NamePlate.GetNamePlates(issecure())) do
		local nameplate = v;
		if (nameplate) then
			UpdateMarks(nameplate);
		end
	end

	UpdateMarks();
end



local function AAM_OnEvent(self, event)

	if event == "PLAYER_ENTERING_WORLD" then
		needtowork = false;
		local inInstance, instanceType = IsInInstance();
		local assignedRole = UnitGroupRolesAssigned("player");

		if (inInstance and instanceType == "party") and (assignedRole and assignedRole == "TANK") then
			needtowork = true;
		end
	elseif event == "PLAYER_REGEN_ENABLED" then
		tmp = {};
	end
end


local function initAddon()
	AAM = CreateFrame("Frame", nil, UIParent);
	AAM:RegisterEvent("PLAYER_ENTERING_WORLD");
	AAM:RegisterEvent("PLAYER_REGEN_ENABLED");
	AAM:SetScript("OnEvent", AAM_OnEvent)
	--주기적으로 Callback
	C_Timer.NewTicker(AAM_UpdateRate, AAM_OnUpdate);
end
initAddon();