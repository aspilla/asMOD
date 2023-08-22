local AHM_Button = CreateFrame("Frame", nil, UIParent)

local Options_Default = {
	Text = "",
}


local playerName        = UnitName("player")
local playerClass       = select(2, UnitClass("player"))
local targetName        = nil
local MisDirectionSpell = nil
local UnitMounted       = false

local colorRed          = "|cFFFF0000"
local colorYellow       = "|cFFffff00"
local colorOrange       = "|cFFF86832"
local colorWhite        = "|cFFFFFFFF"
local color_            = "|r"
local bHunter           = false;

local function GetPartyID()
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

local function CheckPartyMember(bfinddealer)
	local bInstance, RTB_ZoneType = IsInInstance();

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
					local _, _, _, _, _, _, _, _, _, role, _, assignedRole = GetRaidRosterInfo(i) -- role = "MAINTANK|MAINASSIST", assignedRole = "TANK|HEALER|DAMAGER|NONE"

					if bfinddealer and assignedRole == "DAMAGER" and not UnitIsUnit(unitid, "player") then
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

					assignedRole = UnitGroupRolesAssigned(unitid)

					if bfinddealer and assignedRole == "DAMAGER" and not UnitIsUnit(unitid, "player") then
						return unitid;
					elseif assignedRole == "TANK" then
						return unitid;
					end
				end
			end
		end
	end

	if bfinddealer then
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
			unit = CheckPartyMember();
		else
			force_unit = unit;
		end
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

	if MisDirectionSpell then
		--macroText = string.format("#showtooltip %s\n/cast [@mouseover, exists, help, nodead][target=" .. unit ..", exists, help, nodead][help] %s", MisDirectionSpell, MisDirectionSpell)
		macroText = string.format("#showtooltip %s\n/cast [target=" .. unit .. ", exists, help, nodead][help] %s",
			MisDirectionSpell, MisDirectionSpell)
		macroID = GetMacroIndexByName(MisDirectionSpell)
		macroName = MisDirectionSpell

		if AMD_Options.Text then
			macroText = macroText .. "\n" .. AMD_Options.Text;
			print (macroText);
		end

		if (macroID == 0) then
			CreateMacro(macroName, "INV_MISC_QUESTIONMARK", macroText, 1)
		else
			EditMacro(macroID, macroName, "INV_MISC_QUESTIONMARK", macroText, 1)
		end
	end

	if UnitExists(unit) then
		if force then
			print("[afm] 강제으로 " .. UnitName(unit) .. " 이 탱커로 지정");
		else
			print("[afm] 자동으로 " .. UnitName(unit) .. " 이 탱커로 지정");
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

	local unit = GetPartyID()

	if unit then
		AHM_SetAssist(unit, true);
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

local panel = CreateFrame("Frame")
panel.name = "asMisdirection"         -- see panel fields
InterfaceOptions_AddCategory(panel) -- see InterfaceOptions API

local scrollFrame;
local scrollChild;
local function SetupOptionPanels()

	if scrollFrame then
        scrollFrame:Hide()
        scrollFrame:UnregisterAllEvents()
        scrollFrame = nil;
    end

    scrollFrame = CreateFrame("ScrollFrame", nil, panel, "UIPanelScrollFrameTemplate")
    scrollFrame:SetPoint("TOPLEFT", 3, -4)
    scrollFrame:SetPoint("BOTTOMRIGHT", -27, 4)

    -- Create the scrolling child frame, set its width to fit, and give it an arbitrary minimum height (such as 1)
    scrollChild = CreateFrame("Frame")
    scrollFrame:SetScrollChild(scrollChild)
    scrollChild:SetWidth(600)
    scrollChild:SetHeight(1)

    -- add widgets to the panel as desired
    local title = panel:CreateFontString("ARTWORK", nil, "GameFontNormalLarge")
    title:SetPoint("TOP")
    title:SetText("asMisdirection")
	
	if AMD_Options == nil then
		AMD_Options = {};
		AMD_Options = CopyTable(Options_Default);
	end

	local editBox = CreateFrame("EditBox", nil, scrollChild)
	do
		local editBoxLeft = editBox:CreateTexture(nil, "BACKGROUND")
		editBoxLeft:SetTexture(130959) --"Interface\\ChatFrame\\UI-ChatInputBorder-Left"
		editBoxLeft:SetHeight(32)
		editBoxLeft:SetWidth(32)
		editBoxLeft:SetPoint("LEFT", -14, 0)
		editBoxLeft:SetTexCoord(0, 0.125, 0, 1)
		local editBoxRight = editBox:CreateTexture(nil, "BACKGROUND")
		editBoxRight:SetTexture(130960) --"Interface\\ChatFrame\\UI-ChatInputBorder-Right"
		editBoxRight:SetHeight(32)
		editBoxRight:SetWidth(32)
		editBoxRight:SetPoint("RIGHT", 6, 0)
		editBoxRight:SetTexCoord(0.875, 1, 0, 1)
		local editBoxMiddle = editBox:CreateTexture(nil, "BACKGROUND")
		editBoxMiddle:SetTexture(130960) --"Interface\\ChatFrame\\UI-ChatInputBorder-Right"
		editBoxMiddle:SetHeight(32)
		editBoxMiddle:SetWidth(1)
		editBoxMiddle:SetPoint("LEFT", editBoxLeft, "RIGHT")
		editBoxMiddle:SetPoint("RIGHT", editBoxRight, "LEFT")
		editBoxMiddle:SetTexCoord(0, 0.9375, 0, 1)
	end

	editBox:HookScript("OnTextChanged", function() end);
	editBox:SetHeight(300)
	editBox:SetWidth(300)
	editBox:SetPoint("LEFT", scrollChild, "TOPLEFT", 100, -100)
	editBox:SetFontObject("GameFontHighlight")
	editBox:SetMultiLine(true);
	editBox:SetMaxLetters(1000);
	editBox:SetText(AMD_Options.Text);
	editBox:SetAutoFocus(false);
	editBox:ClearFocus();
	editBox:SetTextInsets(0, 0, 0, 1)
	editBox:Show();
	editBox:SetCursorPosition(0);

	local btn = CreateFrame("Button", nil, panel, "UIPanelButtonTemplate")
    btn:SetPoint("TOPRIGHT", -50, -10)
    btn:SetText("설정 적용")
    btn:SetWidth(100)
    btn:SetScript("OnClick", function()
        AMD_Options.Text = editBox:GetText();
		ReloadUI();
    end)
end

local tempTarget = nil;
local bFirst = true;

local function AHM_OnEvent(self, event, ...)

	if bFirst then
		SetupOptionPanels();
		bFirst = false;
	end
	local bfinddealer = false;
	if (event == "PLAYER_LOGIN" or event == "LEARNED_SPELL_IN_TAB") then
		MisDirectionSpell = nil;
		local maintarget = "pet";

		print("/afm : 대상을 탱커으로 지정")
		print("[afm] 매크로 창에서 탱커지원 매크로를 이용하세요.")

		AHM_Button:UnregisterEvent("PLAYER_LOGIN")
		local spellId
		if playerClass == "HUNTER" then
			spellId = 34477;
			bHunter = true;
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
		if not IsLearndSpell(spellName) then return else AHM_Button:UnregisterEvent("LEARNED_SPELL_IN_TAB") end

		MisDirectionSpell = spellName

		if not InCombatLockdown() then
			AHM_SetAssist(maintarget);
		else
			tempTarget = maintarget
		end


		print("[afm] 매크로 창에서 " .. MisDirectionSpell .. " 매크로를 이용하세요.")
	elseif (event == "GROUP_JOINED" or event == "GROUP_ROSTER_UPDATE" or event == "PLAYER_ROLES_ASSIGNED") then
		local unit = CheckPartyMember(bfinddealer);

		if unit and not InCombatLockdown() then
			if UnitExists(unit) then
				AHM_SetAssist(unit);
			end
		else
			tempTarget = unit;
		end
	elseif event == "PLAYER_REGEN_ENABLED" and tempTarget then
		if tempTarget and UnitExists(tempTarget) then
			AHM_SetAssist(tempTarget);
		end
		tempTarget = nil;
	end
end

SlashCmdList["AFM_SLASHCMD"] = AHM_SetTargetName
SLASH_AFM_SLASHCMD1 = "/afm"

AHM_Button:RegisterEvent("PLAYER_LOGIN")
AHM_Button:RegisterEvent("LEARNED_SPELL_IN_TAB")
AHM_Button:RegisterEvent("GROUP_JOINED")
AHM_Button:RegisterEvent("GROUP_ROSTER_UPDATE")
AHM_Button:RegisterEvent("PLAYER_ROLES_ASSIGNED")

AHM_Button:RegisterEvent("PLAYER_REGEN_ENABLED")


AHM_Button:SetScript("OnEvent", function(self, event, ...) AHM_OnEvent(self, event, ...) end)
