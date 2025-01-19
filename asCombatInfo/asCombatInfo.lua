local _, ns = ...;
-- 설정
local ACI_SIZE = 40;               -- Button Size

local ACI_CoolButtons_X = 0        -- 쿨 List 위치 X
local ACI_CoolButtons_Y = -232     -- Y 위치
local ACI_Alpha = 1                -- 전투중 알파값
local ACI_Alpha_Normal = 0.5       -- 비전투중 안보이게 하려면 0
local ACI_CooldownFontSize = 12;   -- Cooldown Font Size
local ACI_CountFontSize = 11;      -- Count Font Size
local ACI_MaxSpellCount = 11;      -- 최대 Spell Count
local ACI_RefreshRate = 0.2;       -- 반복 Check 주기 (초)
local ACI_BackGroundCoolDiff = 10; -- 버프/디버프시 Spell Cool이 보이는 시간차이 (초)



local asGetSpellInfo = function(spellID)
	if not spellID then
		return nil;
	end

	local ospellID = C_Spell.GetOverrideSpell(spellID)

	if ospellID then
		spellID = ospellID;
	end

	local spellInfo = C_Spell.GetSpellInfo(spellID);


	if spellInfo then
		return spellInfo.name, nil, spellInfo.iconID, spellInfo.castTime, spellInfo.minRange, spellInfo.maxRange,
			spellInfo.spellID, spellInfo.originalIconID;
	end
end

local asGetSpellTabInfo = function(index)
	local skillLineInfo = C_SpellBook.GetSpellBookSkillLineInfo(index);
	if skillLineInfo then
		return skillLineInfo.name,
			skillLineInfo.iconID,
			skillLineInfo.itemIndexOffset,
			skillLineInfo.numSpellBookItems,
			skillLineInfo.isGuild,
			skillLineInfo.offSpecID,
			skillLineInfo.shouldHide,
			skillLineInfo.specID;
	end
end


local function asIsPlayerSpell(spell)

	if IsPlayerSpell(spell) then
		return true;
	end

	for tab = 1, 3 do
		local tabName, tabTexture, tabOffset, numEntries = asGetSpellTabInfo(tab)

		if not tabName then
			return;
		end

		for i = tabOffset + 1, tabOffset + numEntries do
			local spellName = C_SpellBook.GetSpellBookItemName(i, Enum.SpellBookSpellBank.Player)

			if not spellName then
				do break end
			end

			local slotType, actionID, spellID = C_SpellBook.GetSpellBookItemType(i, Enum.SpellBookSpellBank.Player);
			local _, _, icon = asGetSpellInfo(spellID);

			if (slotType == Enum.SpellBookItemType.Flyout) then
				local _, _, numSlots = GetFlyoutInfo(actionID);
				for j = 1, numSlots do
					local flyoutSpellID, _, _, flyoutSpellName, _ = GetFlyoutSlotInfo(actionID, j);


					if spell == flyoutSpellName or spell == flyoutSpellID then						
						return true;
					end
				end
			else
				if spell == spellName or spell == spellID then					
					return true;
				end
			end
		end
	end
end

local options = CopyTable(ACI_Options_Default);
local _G = _G;
local cast_spell = nil;
local cast_time = nil;

local ACI = { nil, nil };
local ACI_mainframe;
local ACI_SpellList = nil;

--globals
ACI_Buff_list = {};
ACI_Debuff_list = {};
ACI_SpellID_list = {};
ACI_Totem_list = {};

local function setupMouseOver(frame)
	frame.spellid = nil;
	frame.tooltip = nil;

	if not frame:GetScript("OnEnter") then
		frame:SetScript("OnEnter", function(s)
			if s.spellid and s.spellid > 0 then
				local spellid = s.spellid;
				local ospellID = C_Spell.GetOverrideSpell(spellid)

				if ospellID then
					spellid = ospellID;
				end
				GameTooltip_SetDefaultAnchor(GameTooltip, s);
				GameTooltip:SetSpellByID(spellid);
			elseif s.tooltip then
				GameTooltip_SetDefaultAnchor(GameTooltip, s);
				GameTooltip:SetText(s.tooltip);
			end
		end)
		frame:SetScript("OnLeave", function()
			GameTooltip:Hide();
		end)
	end
	frame:EnableMouse(false);
	frame:SetMouseMotionEnabled(true);
end


local function ACI_OnEvent(self, event, arg1, ...)
	if event == "PLAYER_ENTERING_WORLD" then
		C_Timer.After(0.5, ACI_Init);
		bfirst = true;
		if UnitAffectingCombat("player") then
			for i = 1, ACI_MaxSpellCount do
				ACI[i]:SetAlpha(ACI_Alpha);
			end
		else
			for i = 1, ACI_MaxSpellCount do
				ACI[i]:SetAlpha(ACI_Alpha_Normal);
			end
		end
	elseif event == "PLAYER_REGEN_DISABLED" then
		for i = 1, ACI_MaxSpellCount do
			ACI[i]:SetAlpha(ACI_Alpha);
		end
	elseif event == "PLAYER_REGEN_ENABLED" then
		for i = 1, ACI_MaxSpellCount do
			ACI[i]:SetAlpha(ACI_Alpha_Normal);
		end
	elseif event == "UNIT_ENTERING_VEHICLE" then
		for i = 1, ACI_MaxSpellCount do
			ACI[i]:SetAlpha(0);
		end
	elseif event == "UNIT_EXITING_VEHICLE" then
		if UnitAffectingCombat("player") then
			for i = 1, ACI_MaxSpellCount do
				ACI[i]:SetAlpha(ACI_Alpha);
			end
		else
			for i = 1, ACI_MaxSpellCount do
				ACI[i]:SetAlpha(ACI_Alpha_Normal);
			end
		end
	elseif event == "TRAIT_CONFIG_UPDATED" or event == "TRAIT_CONFIG_LIST_UPDATED" or event == "ACTIVE_TALENT_GROUP_CHANGED" then
		C_Timer.After(0.5, ACI_Init);
	end
end

local ACI_Spec = nil;
local ACI_timer = nil;

ACI_HideCooldownPulse = false;

function ACI_Init()
	local localizedClass, englishClass = UnitClass("player")
	local spec = GetSpecialization();
	local talentgroup = GetActiveSpecGroup();
	local specID = PlayerUtil.GetCurrentSpecID();
	local configID = ((specID and C_ClassTalents.GetLastSelectedSavedConfigID(specID) or 0) + 19)
	local listname = "ACI_SpellList";


	if spec == nil or spec > 4 or (englishClass ~= "DRUID" and spec > 3) then
		spec = 1;
	end

	if ACI_timer then
		ACI_timer:Cancel();
	end
	--버튼
	ACI_SpellList = {};


	if spec and configID then
		listname = "ACI_SpellList" .. "_" .. englishClass .. "_" .. spec;
		if options[spec] and options[spec][configID] then
			ACI_SpellListtmp = CopyTable(options[spec][configID]);
		else
			if ACI_Options_Default[listname] then
				ACI_SpellListtmp = CopyTable(ACI_Options_Default[listname]);
			else
				ACI_SpellListtmp = {};
			end
		end
	else
		ACI_SpellListtmp = {};
	end

	ACI_Buff_list = {};
	ACI_Debuff_list = {};

	ACI_SpellID_list = {};
	ACI_Totem_list = {};


	if ACI_SpellListtmp and #ACI_SpellListtmp then
		ACI_SpellList = {}

		for i = 1, #ACI_SpellListtmp do
			ACI_SpellList[i] = CopyTable(ACI_SpellListtmp[i]);
		end
	end

	if #ACI_SpellList >= 6 then
		-- asCooldownPulse 를 숨긴다.
		ACI_HideCooldownPulse = true;
	end

	for i = 1, ACI_MaxSpellCount do
		ACI[i]:Hide();
		setupMouseOver(ACI[i]);
	end

	ns.eventhandler.init();

	if (ACI_SpellList and #ACI_SpellList) then
		if ACI_Spec == nil and ACI_Spec ~= spec then
			--	ChatFrame1:AddMessage("[ACI] ".. listname .. "을 Load 합니다.");
			ACI_Spec = spec;
		end

		local maxIdx = #ACI_SpellList;

		if maxIdx > ACI_MaxSpellCount then
			maxIdx = ACI_MaxSpellCount;
		end

		ACI_mainframe.maxIdx = maxIdx;

		for i = 1, maxIdx do
			if type(ACI_SpellList[i][1]) == "table" then
				for _, array in pairs(ACI_SpellList[i]) do
					local spell_name = array[1];
					if asIsPlayerSpell(spell_name) then
						ACI_SpellList[i] = {};
						for z, v in pairs(array) do
							ACI_SpellList[i][z] = v;
						end
						break;
					end
				end

				if type(ACI_SpellList[i][1]) == "table" then
					local array = ACI_SpellList[i][1];
					for z, v in pairs(array) do
						ACI_SpellList[i][z] = v;
					end
				end
			else
				local check = tonumber(ACI_SpellList[i][1]);

				if check and check == 99 then
					local bselected = false;
					local spell_name = ACI_SpellList[i][2];
					if asIsPlayerSpell(spell_name) then
						if ACI_SpellList[i][3] then
							local array = ACI_SpellList[i][3];
							if type(array) == "table" then
								ACI_SpellList[i][3] = nil;
								ACI_SpellList[i][4] = nil;

								for z, v in pairs(array) do
									ACI_SpellList[i][z] = v;
								end
							end
						end
					else
						if ACI_SpellList[i][4] then
							local array = ACI_SpellList[i][4];
							if type(array) == "table" then
								ACI_SpellList[i][3] = nil;
								ACI_SpellList[i][4] = nil;

								for z, v in pairs(array) do
									ACI_SpellList[i][z] = v;
								end
							end
						end
					end
				end
			end

			ACI[i].obutton:init(ACI_SpellList[i], ACI[i]);
			ACI[i].tooltip = (ACI_SpellList[i][1]);
			if type(ACI_SpellList[i][1]) == "number" then
				ACI[i].spellid = ACI_SpellList[i][1];
			else
				ACI[i].spellid = select(7, asGetSpellInfo(ACI_SpellList[i][1]));
			end
		end

		local bload = C_AddOns.LoadAddOn("asCooldownPulse")

		if bload and #ACI_SpellList > 5 and ACDP_Show_CoolList == true then
			ACDP_Show_CoolList = false;
		end
	end

	ACI_OptionM.UpdateSpellList(ACI_SpellList);

	return;
end

local function flushoption()
	if ACI_Options then
		options = CopyTable(ACI_Options);
		ACI_Init();
		ACI_OptionM.UpdateSpellList(ACI_SpellList);
	end
end


ACI_mainframe = CreateFrame("Frame", nil, UIParent);
ACI_mainframe:SetScript("OnEvent", ACI_OnEvent);
ACI_mainframe:RegisterEvent("PLAYER_ENTERING_WORLD");
ACI_mainframe:RegisterEvent("TRAIT_CONFIG_UPDATED");
ACI_mainframe:RegisterEvent("TRAIT_CONFIG_LIST_UPDATED");
ACI_mainframe:RegisterEvent("ACTIVE_TALENT_GROUP_CHANGED");
ACI_mainframe:RegisterEvent("PLAYER_REGEN_DISABLED");
ACI_mainframe:RegisterEvent("PLAYER_REGEN_ENABLED");
ACI_mainframe:RegisterUnitEvent("UNIT_ENTERING_VEHICLE", "player")
ACI_mainframe:RegisterUnitEvent("UNIT_EXITING_VEHICLE", "player")


for i = 1, 5 do
	ACI[i] = CreateFrame("Button", nil, UIParent, "asCombatInfoFrameTemplate");
	ACI[i]:SetWidth(ACI_SIZE);
	ACI[i]:SetHeight(ACI_SIZE * 0.9);
	ACI[i]:SetScale(1);
	ACI[i]:SetAlpha(ACI_Alpha);
	ACI[i]:EnableMouse(false);
	ACI[i]:Hide();

	ACI[i].obutton = ns.Button:new();

	setupMouseOver(ACI[i])
end

for i = 1, 5 do
	if i == 3 then
		ACI[i]:SetPoint("CENTER", ACI_CoolButtons_X, ACI_CoolButtons_Y)
	elseif i < 3 then
		ACI[i]:SetPoint("RIGHT", ACI[i + 1], "LEFT", -1, 0);
	elseif i > 3 then
		ACI[i]:SetPoint("LEFT", ACI[i - 1], "RIGHT", 1, 0);
	end
end


for i = 6, 11 do
	ACI[i] = CreateFrame("Button", nil, UIParent, "asCombatInfoFrameTemplate");

	ACI[i]:SetWidth(ACI_SIZE - 8);
	ACI[i]:SetHeight((ACI_SIZE - 8) * 0.9);
	ACI[i]:SetScale(1);
	ACI[i]:SetAlpha(ACI_Alpha);
	ACI[i]:EnableMouse(false);
	ACI[i]:Hide();
	ACI[i].obutton = ns.Button:new();
end

for i = 6, 11 do
	if i == 8 then
		ACI[i]:SetPoint("TOPRIGHT", ACI[i - 5], "BOTTOM", -0.5, -1);
	elseif i == 9 then
		ACI[i]:SetPoint("TOPLEFT", ACI[i - 6], "BOTTOM", 0.5, -1);
	elseif i < 8 then
		ACI[i]:SetPoint("RIGHT", ACI[i + 1], "LEFT", -1, 0);
	elseif i > 9 then
		ACI[i]:SetPoint("LEFT", ACI[i - 1], "RIGHT", 1, 0);
	end
end

for i = 1, ACI_MaxSpellCount do
	for _, r in next, { ACI[i].cooldown:GetRegions() } do
		if r:GetObjectType() == "FontString" then
			ACI[i].cooldownfont = r;
			if i < 6 then
				r:SetFont(STANDARD_TEXT_FONT, ACI_CooldownFontSize, "OUTLINE")
				ACI[i].cooldownfont.fontsize = ACI_CooldownFontSize;
			else
				r:SetFont(STANDARD_TEXT_FONT, ACI_CooldownFontSize - 2, "OUTLINE")
				ACI[i].cooldownfont.fontsize = ACI_CooldownFontSize - 2;
			end			
			break
		end
	end
	ACI[i].cooldown:SetDrawSwipe(true);
	ACI[i].cooldown:SetHideCountdownNumbers(false);

	ACI[i].icon:SetTexCoord(.08, .92, .08, .92);
	ACI[i].border:SetTexCoord(0.08, 0.08, 0.08, 0.92, 0.92, 0.08, 0.92, 0.92);
	ACI[i].border:Hide();	

	if i < 6 then
		ACI[i].count:SetFont(STANDARD_TEXT_FONT, ACI_CountFontSize, "OUTLINE")
	else
		ACI[i].count:SetFont(STANDARD_TEXT_FONT, ACI_CountFontSize - 2, "OUTLINE")
	end
	
	ACI[i].count:ClearAllPoints();
	ACI[i].count:SetPoint("BOTTOMRIGHT", ACI[i], "BOTTOMRIGHT", -3, 3);
	
	ACI[i].spellcool:ClearAllPoints();
	ACI[i].spellcool:SetPoint("CENTER", ACI[i], "BOTTOM", 0, 0);
	ACI[i].spellcool:SetFont(STANDARD_TEXT_FONT, ACI_CooldownFontSize - 2, "OUTLINE");
	ACI[i].spellcool:SetTextColor(0.8, 0.8, 1);
	ACI[i].spellcool:Hide();

	ACI[i].snapshot:SetFont(STANDARD_TEXT_FONT, ACI_CountFontSize - 2, "OUTLINE")
	ACI[i].snapshot:SetText("");
	ACI[i].snapshot:SetTextColor(1, 0.5, 0.5);
	ACI[i].snapshot:ClearAllPoints();
	ACI[i].snapshot:SetPoint("CENTER", ACI[i], "TOP", 0, -8);
	ACI[i].snapshot:Hide();
	
end


C_AddOns.LoadAddOn("asMOD");

if asMOD_setupFrame then
	asMOD_setupFrame(ACI[3], "asCombatInfo");
end

ACI_OptionM.RegisterCallback(flushoption);
