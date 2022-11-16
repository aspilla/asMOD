local AHM_Button = CreateFrame('Button', 'AHM_Button', UIParent, "SecureActionButtonTemplate")


local playerName	= UnitName("player")
local playerClass	= select(2, UnitClass("player"))
local targetName	= nil
local MisDirectionSpell = nil
local UnitMounted	= false

local colorRed		= "|cFFFF0000"
local colorYellow	= "|cFFffff00"
local colorOrange	= "|cFFF86832" 
local colorWhite	= "|cFFFFFFFF"
local color_		= "|r"
local bHunter 		= false;

local function GetPartyID()

	if IsInGroup() then
		if IsInRaid() then -- raid
			for i=1,GetNumGroupMembers() do
				local unitid = "raid"..i
				local notMe = not UnitIsUnit('player',unitid)
				local unitName = UnitName(unitid)
				if unitName and notMe and UnitIsUnit('target',unitid) then
					return unitid;
				end
			end
		else -- party
			for i=1,GetNumSubgroupMembers() do
				local unitid = "party"..i
				local unitName = UnitName(unitid)
				if unitName and  UnitIsUnit('target',unitid) then
					return unitid;
				end
			end
		end
	end

	return "pet";
end

local function CheckPartyMember()

	local bInstance, RTB_ZoneType = IsInInstance();

	if RTB_ZoneType == "pvp" then
		return nil;
	end

	if IsInGroup() then
		if IsInRaid() then -- raid
			for i=1,GetNumGroupMembers() do
				local unitid = "raid"..i
				local notMe = not UnitIsUnit('player',unitid)
				local unitName = UnitName(unitid)
				if unitName and notMe then
					local _,_,_,_,_,_,_,_,_,role,_, assignedRole = GetRaidRosterInfo(i) -- role = 'MAINTANK|MAINASSIST', assignedRole = 'TANK|HEALER|DAMAGER|NONE'
					if assignedRole == "TANK" then
						return unitid;
					end
				end
			end
		else -- party
			for i=1,GetNumSubgroupMembers() do
				local unitid = "party"..i
				local unitName = UnitName(unitid)
				if unitName then
					local role,assignedRole
					if ( GetPartyAssignment('MAINTANK', unitid) ) then
						role = 'MAINTANK'
					end
					assignedRole = UnitGroupRolesAssigned(unitid)

					if assignedRole == "TANK" then
						return unitid;
					end

				end
			end
		end
	end

	return "pet";
end


local prev_unit = nil;
local force_unit = nil;

local function AHM_SetAssist(unit, force)

	if not force and force_unit then
		return;		
	end

	if force then
		if unit == force_unit then
			force_unit = nil;
			force = nil;
			unit = CheckPartyMember();
		else
			force_unit = unit;
		end
	end

	if unit == prev_unit then
		return;
	end

	prev_unit = unit;

	local macroText = "/assist [@".. unit .." ,exists,nodead]";
	local macroName = "탱커지원"
	local macroID = GetMacroIndexByName(macroName)

	if (macroID == 0) then
		CreateMacro(macroName, "ABILITY_ROGUE_FEIGNDEATH", macroText)
	else
		EditMacro(macroID, macroName, "ABILITY_ROGUE_FEIGNDEATH", macroText)
	end

	if MisDirectionSpell then
		--macroText = string.format("#showtooltip %s\n/cast [@mouseover, exists, help, nodead][target=" .. unit ..", exists, help, nodead][help] %s", MisDirectionSpell, MisDirectionSpell)
		macroText = string.format("#showtooltip %s\n/cast [target=" .. unit ..", exists, help, nodead][help] %s", MisDirectionSpell, MisDirectionSpell)
		macroID = GetMacroIndexByName(MisDirectionSpell)
		macroName = MisDirectionSpell

		if (macroID == 0) then
			CreateMacro(macroName, "INV_MISC_QUESTIONMARK", macroText, 1)
		else
			EditMacro(macroID, macroName, "INV_MISC_QUESTIONMARK", macroText, 1)
		end
	end

	if UnitExists(unit) then
		if force then
			print("[afm] 강제으로 "..UnitName(unit).." 이 탱커로 지정");
		else
			print("[afm] 자동으로 "..UnitName(unit).." 이 탱커로 지정");
		end
	end
	
end


-----------------------------
local function AHM_SetTargetName(...)
-----------------------------

	if InCombatLockdown() then
		ChatFrame1:AddMessage("asMisdirection: 전투중엔 대상을 설정 할 수 없습니다.")
		return
	end

	local unit =  GetPartyID()

	if unit then
		AHM_SetAssist(unit, true);
	end
end


local function IsLearndSpell(checkSpellName)
	local i = 1
	while true do
		local spellName = GetSpellBookItemName (i, BOOKTYPE_SPELL)
		if not spellName then
			do break end
		end
		if spellName == checkSpellName then
			return true
		end
		i = i + 1
	end
	return false
end



local tempTarget = nil;

local function AHM_OnEvent(self, event, ...)
	if (event == "PLAYER_LOGIN" or event == "LEARNED_SPELL_IN_TAB") then

		MisDirectionSpell = nil;

		print("/afm : 대상을 탱커으로 지정")
		print("[afm] 매크로 창에서 탱커지원 매크로를 이용하세요.")
	
		AHM_Button:UnregisterEvent("PLAYER_LOGIN")
		local spellId
		if playerClass == "HUNTER" then
			spellId = 34477
			bHunter = true;
		elseif playerClass == "ROGUE" then
			spellId = 57934
		else

			AHM_Button:UnregisterEvent("LEARNED_SPELL_IN_TAB");

			if  not InCombatLockdown() then
				AHM_SetAssist("pet");
			else
				tempTarget = "pet"
			end
			return 
		end

		local spellName = select(1, GetSpellInfo(spellId))
		if not spellName then return end
		if not IsLearndSpell(spellName) then return else AHM_Button:UnregisterEvent("LEARNED_SPELL_IN_TAB") end

		MisDirectionSpell = spellName

		if  not InCombatLockdown() then
			AHM_SetAssist("pet");
		else
			tempTarget = "pet"
		end


		print("[afm] 매크로 창에서 "..MisDirectionSpell.." 매크로를 이용하세요.")


	elseif (event == "GROUP_JOINED" or event == "GROUP_ROSTER_UPDATE" or event == "PLAYER_ROLES_ASSIGNED") then

		local unit = CheckPartyMember();

		if unit and  not InCombatLockdown() then
			if  UnitExists(unit)  then
				AHM_SetAssist(unit);
			end
		else
			tempTarget = unit;
		end
	
	elseif event == "PLAYER_REGEN_ENABLED" and tempTarget then

		if tempTarget and UnitExists(tempTarget)  then
			AHM_SetAssist(tempTarget);
		end
		tempTarget = nil;
	
	end
end

SlashCmdList['AFM_SLASHCMD'] = AHM_SetTargetName
SLASH_AFM_SLASHCMD1 = '/afm'

AHM_Button:RegisterEvent('PLAYER_LOGIN')
AHM_Button:RegisterEvent('LEARNED_SPELL_IN_TAB')
AHM_Button:RegisterEvent('GROUP_JOINED')
AHM_Button:RegisterEvent('GROUP_ROSTER_UPDATE')
AHM_Button:RegisterEvent('PLAYER_ROLES_ASSIGNED')

AHM_Button:RegisterEvent('PLAYER_REGEN_ENABLED')


AHM_Button:SetScript('OnEvent', function(self, event, ...) AHM_OnEvent(self, event, ...) end)
