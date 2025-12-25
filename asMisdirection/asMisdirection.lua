local main_frame        = CreateFrame("Frame", nil, UIParent)

local playerClass       = select(2, UnitClass("player"))
local MisDirectionSpell = nil
local MindInfusionSpell = nil;

local gameLanguage      = GetLocale()

local function get_spellinfo(spellid)
	if not spellid then
		return nil;
	end

	local or_spellid = C_Spell.GetOverrideSpell(spellid)

	if or_spellid then
		spellid = or_spellid;
	end

	local spellInfo = C_Spell.GetSpellInfo(spellid);
	if spellInfo then
		return spellInfo.name, nil, spellInfo.iconID, spellInfo.castTime, spellInfo.minRange, spellInfo.maxRange,
			spellInfo.spellID, spellInfo.originalIconID;
	end
end


local function get_partyid()
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

local function check_party(btank)
	local _, RTB_ZoneType = IsInInstance();

	if RTB_ZoneType == "pvp" then
		return nil;
	end

	if IsInGroup() then
		if IsInRaid() then -- raid
			for i = 1, GetNumGroupMembers() do
				local unitid = "raid" .. i
				local notMe = not UnitIsUnit("player", unitid)
				local unitName = UnitName(unitid)
				if unitName and notMe then
					local assignedRole = UnitGroupRolesAssigned(unitid);

					if btank == false then
						if assignedRole == "DAMAGER" and not UnitIsUnit(unitid, "player") then
							return unitid;
						end
					else
						if assignedRole == "TANK" then
							return unitid;
						end
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

					if btank == false then
						if assignedRole == "DAMAGER" and not UnitIsUnit(unitid, "player") then
							return unitid;
						end
					else
						if assignedRole == "TANK" then
							return unitid;
						end
					end
				end
			end
		end
	end

	if btank == false then
		return "player";
	end
	return "pet";
end


local prev_unit = nil;
local force_unit = nil;

local function setup_assistmacro(unit, force)
	if not force and force_unit then
		return;
	end

	if force then
		if unit == force_unit then
			force_unit = nil;
			force = nil;
			unit = check_party(true);
		else
			force_unit = unit;
		end
	end

	if unit == prev_unit then
		return;
	end

	prev_unit = unit;

	local macroText = "/assist [@" .. unit .. " ,exists,nodead]";
	local macroName = "as_Assist Tanker"
	if (gameLanguage == "koKR") then
		macroName = "as_탱커지원"
	end
	local macroID = GetMacroIndexByName(macroName)

	if (macroID == 0) then
		local global, perChar = GetNumMacros();

		if global < 120 then
			CreateMacro(macroName, "ABILITY_ROGUE_FEIGNDEATH", macroText, true)
		else
			print("asMOD error:too many macros, so need to delete some")
		end
	else
		EditMacro(macroID, macroName, "ABILITY_ROGUE_FEIGNDEATH", macroText)
	end

	if UnitExists(unit) then
		if (gameLanguage == "koKR") then
			print("|cff33ff99[afm]|r " .. UnitName(unit) .. " 이 탱커로 지정");
		else
			print("|cff33ff99[afm]|r " .. UnitName(unit) .. " is setted as TANKER");
		end
	end
end

local prev_md_unit = nil;
local force_md_unit = nil;

local function setup_misdirection(unit, force)
	if not force and force_md_unit then
		return;
	end

	if force then
		if unit == force_md_unit then
			force_md_unit = nil;
			force = nil;
			unit = check_party(true);
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
		local macroName = "as_" .. MisDirectionSpell
		local macroID = GetMacroIndexByName(macroName)

		if (macroID == 0) then
			local global, perChar = GetNumMacros();

			if perChar < 30 then
				CreateMacro(macroName, "INV_MISC_QUESTIONMARK", macroText, true)
			elseif global < 120 then
				CreateMacro(macroName, "INV_MISC_QUESTIONMARK", macroText, false)
			else
				print("asMOD error:too many macros, so need to delete some")
			end
		else
			local oldtext = GetMacroBody(macroID);
			if oldtext then
				local start = string.find(oldtext, "help] " .. MisDirectionSpell, 0);

				if start and start > 0 then
					local addedtext = string.sub(oldtext, start + string.len("help] " .. MisDirectionSpell), -1);
					macroText = macroText .. addedtext;
				end

				EditMacro(macroID, macroName, "INV_MISC_QUESTIONMARK", macroText)
			end
		end

		if UnitExists(unit) then
			if (gameLanguage == "koKR") then
				print("|cff33ff99[afm]|r " .. UnitName(unit) .. " 이 " .. MisDirectionSpell .. " 대상으로 지정");
			else
				print("|cff33ff99[afm]|r " .. UnitName(unit) .. " is setted as the target of " .. MisDirectionSpell);
			end
		end
	end
end

local prev_mi_unit = nil;
local force_mi_unit = nil;

local function setup_mindinfustion(unit, force)
	if not force and force_mi_unit then
		return;
	end

	if force then
		if unit == force_mi_unit then
			force_mi_unit = nil;
			force = nil;
			unit = check_party(false);
		else
			force_mi_unit = unit;
		end
	end

	if unit == prev_mi_unit then
		return;
	end

	prev_mi_unit = unit;

	if MindInfusionSpell then
		--macroText = string.format("#showtooltip %s\n/cast [@mouseover, exists, help, nodead][target=" .. unit ..", exists, help, nodead][help] %s", MindInfusionSpell, MindInfusionSpell)
		local macroText = string.format("#showtooltip %s\n/cast [target=" .. unit .. ", exists, help, nodead][] %s",
			MindInfusionSpell, MindInfusionSpell)
		local macroName = "as_" .. MindInfusionSpell
		local macroID = GetMacroIndexByName(macroName)

		if (macroID == 0) then
			local global, perChar = GetNumMacros();

			if perChar < 30 then
				CreateMacro(macroName, "INV_MISC_QUESTIONMARK", macroText, true)
			elseif global < 120 then
				CreateMacro(macroName, "INV_MISC_QUESTIONMARK", macroText, false)
			else
				print("asMOD error:too many macros, so need to delete some")
			end
		else
			local oldtext = GetMacroBody(macroID);
			if oldtext then
				local start = string.find(oldtext, "] " .. MindInfusionSpell, 0);

				if start and start > 0 then
					local addedtext = string.sub(oldtext, start + string.len("] " .. MindInfusionSpell), -1);
					macroText = macroText .. addedtext;
				end

				EditMacro(macroID, macroName, "INV_MISC_QUESTIONMARK", macroText)
			end
		end

		if UnitExists(unit) then
			if (gameLanguage == "koKR") then
				print("|cff33ff99[afm]|r " .. UnitName(unit) .. " 이 " .. MindInfusionSpell .. " 대상으로 지정");
			else
				print("|cff33ff99[afm]|r " .. UnitName(unit) .. " is setted as the target of " .. MindInfusionSpell);
			end
		end
	end
end

local function setup_target(...)
	if InCombatLockdown() then
		if (gameLanguage == "koKR") then
			ChatFrame1:AddMessage("|cff33ff99[afm]|r 전투중엔 대상을 설정 할 수 없습니다.");
		else
			ChatFrame1:AddMessage("|cff33ff99[afm]|r Can't set during the combat");
		end
		return;
	end

	local unit = get_partyid();

	if unit then
		setup_assistmacro(unit, true);
		setup_misdirection(unit, true);
		setup_mindinfustion(unit, true);
	end
end

local tempTanker = nil;
local tempDealer = nil;
local check_spells = {
	[34477] = true,
	[57934] = true,
	[360827] = true,
	[10060] = true,
}

local function on_event(self, event, arg1)
	if (event == "PLAYER_LOGIN" or (event == "LEARNED_SPELL_IN_SKILL_LINE" and arg1 and  check_spells[arg1])) then
		MisDirectionSpell = nil;
		MindInfusionSpell = nil;
		local maintarget = "pet";
		local dealspell = false;

		if (gameLanguage == "koKR") then
			print("|cff33ff99/afm|r : 대상을 탱커으로 지정")
			print("|cff33ff99[afm]|r 매크로 창(|cff33ff99/m|r)에서 탱커지원 매크로를 이용하세요.")
		else
			print("|cff33ff99/afm|r : set the target player as a main tank to assist")
			print("|cff33ff99[afm]|r use macros in the macro window, has created, using |cff33ff99/m|r")
		end

		main_frame:UnregisterEvent("PLAYER_LOGIN")
		local spellId
		if playerClass == "HUNTER" then
			spellId = 34477;
		elseif playerClass == "ROGUE" then
			spellId = 57934;
		elseif playerClass == "EVOKER" then
			spellId = 360827;
			maintarget = "player"
		elseif playerClass == "PRIEST" then
			spellId = 10060;
			maintarget = "player"
			dealspell = true;
		else
			--AHM_Button:UnregisterEvent("LEARNED_SPELL_IN_TAB");

			if not InCombatLockdown() then
				setup_assistmacro(maintarget);
			else
				tempTanker = maintarget;
				tempDealer = maintarget;
			end
			return
		end

		local spellName = select(1, get_spellinfo(spellId))
		if not spellName then return end
		if not C_SpellBook.IsSpellKnown(spellId) then
			return
		else
			--AHM_Button:UnregisterEvent("LEARNED_SPELL_IN_TAB")
		end

		if dealspell then
			MindInfusionSpell = spellName

			if not InCombatLockdown() then
				setup_assistmacro(maintarget);
				setup_mindinfustion(maintarget);
			else
				tempTanker = maintarget
				tempDealer = maintarget
			end

			if (gameLanguage == "koKR") then
				print("|cff33ff99[afm]|r 매크로 창에서 as_" .. MindInfusionSpell .. " 매크로를 이용하세요.")
			else
				print("|cff33ff99[afm]|r use as_" .. MindInfusionSpell .. " macro.")
			end
		else
			MisDirectionSpell = spellName

			if not InCombatLockdown() then
				setup_assistmacro(maintarget);
				setup_misdirection(maintarget);
			else
				tempTanker = maintarget
			end

			if (gameLanguage == "koKR") then
				print("|cff33ff99[afm]|r 매크로 창에서 as_" .. MisDirectionSpell .. " 매크로를 이용하세요.")
			else
				print("|cff33ff99[afm]|r use as_" .. MisDirectionSpell .. " macro.")
			end
		end
	elseif (event == "GROUP_JOINED" or event == "GROUP_ROSTER_UPDATE" or event == "PLAYER_ROLES_ASSIGNED") then
		local tank = check_party(true);
		local dealer = check_party(false);

		if tank and not InCombatLockdown() then
			if UnitExists(tank) then
				setup_assistmacro(tank);
				setup_misdirection(tank);
			end
		else
			tempTanker = tank;
		end

		if dealer and not InCombatLockdown() then
			if UnitExists(dealer) then
				setup_mindinfustion(dealer);
			end
		else
			tempDealer = dealer;
		end
	elseif (event == "GROUP_LEFT") then
		force_md_unit = nil;
		force_unit = nil;

		local tank = check_party(true);
		local dealer = check_party(false);

		if tank and not InCombatLockdown() then
			if UnitExists(tank) then
				setup_assistmacro(tank);
				setup_misdirection(tank);
			end
		else
			tempTanker = tank;
		end

		if dealer and not InCombatLockdown() then
			if UnitExists(dealer) then
				setup_mindinfustion(dealer);
			end
		else
			tempDealer = dealer;
		end
	elseif event == "PLAYER_REGEN_ENABLED" and tempTanker then
		if tempTanker and UnitExists(tempTanker) then
			setup_assistmacro(tempTanker);
			setup_misdirection(tempTanker);
		end
		tempTanker = nil;

		if tempDealer and UnitExists(tempDealer) then
			setup_mindinfustion(tempDealer);
		end
		tempDealer = nil;
	end
end

SlashCmdList["AFM_SLASHCMD"] = setup_target
SLASH_AFM_SLASHCMD1 = "/afm"

main_frame:RegisterEvent("PLAYER_LOGIN")
main_frame:RegisterEvent("LEARNED_SPELL_IN_SKILL_LINE")
main_frame:RegisterEvent("GROUP_LEFT")
main_frame:RegisterEvent("GROUP_JOINED")
main_frame:RegisterEvent("GROUP_ROSTER_UPDATE")
main_frame:RegisterEvent("PLAYER_ROLES_ASSIGNED")
main_frame:RegisterEvent("PLAYER_REGEN_ENABLED")


main_frame:SetScript("OnEvent", on_event);
