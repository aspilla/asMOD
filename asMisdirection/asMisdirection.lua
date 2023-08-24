local AHM_Button        = CreateFrame("Frame", nil, UIParent)

local playerClass       = select(2, UnitClass("player"))
local MisDirectionSpell = nil

local function GetTargetPartyID()
	if IsInGroup() then
		if IsInRaid() then -- raid
			for i = 1, GetNumGroupMembers() do
				local unitid = "raid" .. i
				local notMe = not UnitIsUnit("player", unitid)
				local unitName = UnitName(unitid)
				if unitName and notMe and UnitIsUnit("target", unitid) then
					return unitid;
				end
			end
		else -- party
			for i = 1, GetNumSubgroupMembers() do
				local unitid = "party" .. i
				local unitName = UnitName(unitid)
				if unitName and UnitIsUnit("target", unitid) then
					return unitid;
				end
			end
		end
	end

	return "pet";
end

local bfinddealer = false;

local function CheckPartyMember(btank)
	local _, RTB_ZoneType = IsInInstance();

	if RTB_ZoneType == "pvp" then
		return nil;
	end

	local finddealer = bfinddealer;
	if btank then
		finddealer = false;
	end

	if IsInGroup() then
		if IsInRaid() then -- raid
			for i = 1, GetNumGroupMembers() do
				local unitid = "raid" .. i
				local notMe = not UnitIsUnit("player", unitid)
				local unitName = UnitName(unitid)
				if unitName and notMe then
					local _, _, _, _, _, _, _, _, _, role, _, assignedRole = GetRaidRosterInfo(i);

					if finddealer and assignedRole == "DAMAGER" and not UnitIsUnit(unitid, "player") then
						return unitid;
					elseif assignedRole == "TANK" then
						return unitid;
					end
				end
			end
		else -- party
			for i = 1, GetNumSubgroupMembers() do
				local unitid = "party" .. i
				local unitName = UnitName(unitid)
				if unitName then
					local assignedRole;

					assignedRole = UnitGroupRolesAssigned(unitid);

					if finddealer and assignedRole == "DAMAGER" and not UnitIsUnit(unitid, "player") then
						return unitid;
					elseif assignedRole == "TANK" then
						return unitid;
					end
				end
			end
		end
	end

	if finddealer then
		return "player";
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
			unit = CheckPartyMember(true);
		else
			force_unit = unit;
		end
	elseif bfinddealer then
		unit = CheckPartyMember(true);
	end

	if unit == prev_unit then
		return;
	end

	prev_unit = unit;

	local macroText = "/assist [@" .. unit .. " ,exists,nodead]";
	local macroName = "탱커지원"
	local macroID = GetMacroIndexByName(macroName)

	if (macroID == 0) then
		CreateMacro(macroName, "ABILITY_ROGUE_FEIGNDEATH", macroText)
	else
		EditMacro(macroID, macroName, "ABILITY_ROGUE_FEIGNDEATH", macroText)
	end

	if UnitExists(unit) then
		if force then
			print("[afm] 강제으로 " .. UnitName(unit) .. " 이 탱커로 지정");
		else
			print("[afm] 자동으로 " .. UnitName(unit) .. " 이 탱커로 지정");
		end
	end
end

local prev_md_unit = nil;
local force_md_unit = nil;

local function AHM_SetMisdirection(unit, force)
	if not force and force_md_unit then
		return;
	end

	if force then
		if unit == force_md_unit then
			force_md_unit = nil;
			force = nil;
			unit = CheckPartyMember(false);
		else
			force_md_unit = unit;
		end
	end

	if unit == prev_md_unit then
		return;
	end

	prev_md_unit = unit;

	if MisDirectionSpell then
		--macroText = string.format("#showtooltip %s\n/cast [@mouseover, exists, help, nodead][target=" .. unit ..", exists, help, nodead][help] %s", MisDirectionSpell, MisDirectionSpell)
		local macroText = string.format("#showtooltip %s\n/cast [target=" .. unit .. ", exists, help, nodead][help] %s",
			MisDirectionSpell, MisDirectionSpell)
		local macroID = GetMacroIndexByName(MisDirectionSpell)
		local macroName = MisDirectionSpell

		if (macroID == 0) then
			CreateMacro(macroName, "INV_MISC_QUESTIONMARK", macroText, 1)
		else
			local oldtext = GetMacroBody(macroID);
			local start = string.find(oldtext, "help] " .. MisDirectionSpell, 0);

			if start and start > 0 then
				local addedtext = string.sub(oldtext, start + string.len("help] " .. MisDirectionSpell), -1);
				macroText = macroText .. addedtext;
			end

			EditMacro(macroID, macroName, "INV_MISC_QUESTIONMARK", macroText, 1)
		end

		if UnitExists(unit) then
			if force then
				print("[afm] 강제으로 " .. UnitName(unit) .. " 이 " .. MisDirectionSpell .. " 대상으로 지정");
			else
				print("[afm] 자동으로 " .. UnitName(unit) .. " 이 " .. MisDirectionSpell .. " 대상으로 지정");
			end
		end
	end

	
end

local function AHM_SetTargetName(...)
	if InCombatLockdown() then
		ChatFrame1:AddMessage("asMisdirection: 전투중엔 대상을 설정 할 수 없습니다.");
		return;
	end

	local unit = GetTargetPartyID();

	if unit then
		AHM_SetAssist(unit, true);
		AHM_SetMisdirection(unit, true);
	end
end

local function IsLearndSpell(checkSpellName)
	local i = 1

	if playerClass == "HUNTER" or playerClass == "ROGUE" then
		return true;
	end

	while true do
		local spellName = GetSpellBookItemName(i, BOOKTYPE_SPELL)
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
		local maintarget = "pet";

		print("/afm : 대상을 탱커으로 지정")
		print("[afm] 매크로 창에서 탱커지원 매크로를 이용하세요.")

		AHM_Button:UnregisterEvent("PLAYER_LOGIN")
		local spellId
		if playerClass == "HUNTER" then
			spellId = 34477;
		elseif playerClass == "ROGUE" then
			spellId = 57934;
		elseif playerClass == "EVOKER" then
			spellId = 360827;
			maintarget = "player"
		elseif playerClass == "PRIEST" then
			spellId = 122860;
			bfinddealer = true;
			maintarget = "player"
		else
			AHM_Button:UnregisterEvent("LEARNED_SPELL_IN_TAB");

			if not InCombatLockdown() then
				AHM_SetAssist(maintarget);
			else
				tempTarget = maintarget
			end
			return
		end

		local spellName = select(1, GetSpellInfo(spellId))
		if not spellName then return end
		if not IsLearndSpell(spellName) then
			return
		else
			AHM_Button:UnregisterEvent("LEARNED_SPELL_IN_TAB")
		end

		MisDirectionSpell = spellName

		if not InCombatLockdown() then
			AHM_SetAssist(maintarget);
			AHM_SetMisdirection(maintarget);
		else
			tempTarget = maintarget
		end

		print("[afm] 매크로 창에서 " .. MisDirectionSpell .. " 매크로를 이용하세요.")
	elseif (event == "GROUP_JOINED" or event == "GROUP_ROSTER_UPDATE" or event == "PLAYER_ROLES_ASSIGNED") then
		local unit = CheckPartyMember();

		if unit and not InCombatLockdown() then
			if UnitExists(unit) then
				AHM_SetAssist(unit);
				AHM_SetMisdirection(unit);
			end
		else
			tempTarget = unit;
		end
	elseif (event == "GROUP_LEFT") then
		force_md_unit = nil;
		force_unit = nil;

		local unit = CheckPartyMember();

		if unit and not InCombatLockdown() then
			if UnitExists(unit) then
				AHM_SetAssist(unit);
				AHM_SetMisdirection(unit);
			end
		else
			tempTarget = unit;
		end
	elseif event == "PLAYER_REGEN_ENABLED" and tempTarget then
		if tempTarget and UnitExists(tempTarget) then
			AHM_SetAssist(tempTarget);
			AHM_SetMisdirection(tempTarget);
		end
		tempTarget = nil;
	end
end

SlashCmdList["AFM_SLASHCMD"] = AHM_SetTargetName
SLASH_AFM_SLASHCMD1 = "/afm"

AHM_Button:RegisterEvent("PLAYER_LOGIN")
AHM_Button:RegisterEvent("LEARNED_SPELL_IN_TAB")
AHM_Button:RegisterEvent("GROUP_LEFT")
AHM_Button:RegisterEvent("GROUP_JOINED")
AHM_Button:RegisterEvent("GROUP_ROSTER_UPDATE")
AHM_Button:RegisterEvent("PLAYER_ROLES_ASSIGNED")

AHM_Button:RegisterEvent("PLAYER_REGEN_ENABLED")


AHM_Button:SetScript("OnEvent", function(self, event, ...) AHM_OnEvent(self, event, ...) end)
