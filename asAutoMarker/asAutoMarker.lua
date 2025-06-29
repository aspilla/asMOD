local _, ns = ...;
---설정부
local AAM_UpdateRate = 0.2 -- Check할 주기
local AAM_MaxMark = 7      -- 최대 징표 X까지 찍도록 설정
local AAM_TANKMark = 6;
local AAM_HEALERMark = 5;

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

asAutoMarkerF = {};

asAutoMarkerF.IsAutoMarkerMob = function(unit)
	local guid = UnitGUID(unit);
	if guid then
		local npcID = select(6, strsplit("-", guid));
		npcID = tonumber(npcID);

		if ns.NPCTable[npcID] and ns.NPCTable[npcID] > 0 then
			return ns.NPCTable[npcID];
		end
	end

	return 0;
end

local needtowork = false;

local function isAttackable(unit)
	local reaction = UnitReaction("player", unit);
	if reaction and reaction <= 4 then
		return true;
	end
	return false;
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

	for i = 0, GetNumGroupMembers() do
		local partyunit = "party" .. i;
		local partymark = GetRaidTargetIndex(partyunit);

		if partymark ~= nil and partymark <= AAM_MaxMark then
			abledMarks[partymark] = false;
		end
	end
end

local function updateMark(unit)
	local assignedRole = UnitGroupRolesAssigned(unit);

	if assignedRole == "TANK" and AAM_TANKMark then
		SetRaidTarget(unit, AAM_TANKMark);
	elseif assignedRole == "HEALER" then
		SetRaidTarget(unit, AAM_HEALERMark);
	end
end

local function UpdatePartyMarks()
	if not ns.options.TankHealerMark then
		return;
	end
	for i = 0, GetNumGroupMembers() do
		local partyunit = "party" .. i;
		updateMark(partyunit);
	end

	updateMark("player");
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

	if unit and isAttackable(unit) and not UnitIsDead(unit) then
		if ((unit == "mouseover" and ns.options.MouseOverMark) or (status and status > 0)) then
			local guid = UnitGUID(unit);
			if asAutoMarkerF.IsAutoMarkerMob(unit) > 1 and guid then
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

local bfirst = true;

local function AAM_OnEvent(self, event, ...)
	if bfirst then
		bfirst = false;
		ns.SetupOptionPanels();
	end

	if event == "PLAYER_ENTERING_WORLD" or event == "GROUP_JOINED" or event == "GROUP_ROSTER_UPDATE" or event == "PLAYER_ROLES_ASSIGNED" then
		needtowork = false;
		local inInstance, instanceType = IsInInstance();
		local assignedRole = UnitGroupRolesAssigned("player");

		if (inInstance and instanceType == "party") and (assignedRole and assignedRole == "TANK") then
			needtowork = true;
			AAM:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED");
			AAM:RegisterEvent("PLAYER_REGEN_ENABLED");
			AAM:RegisterEvent("UPDATE_MOUSEOVER_UNIT");
			UpdatePartyMarks();
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
