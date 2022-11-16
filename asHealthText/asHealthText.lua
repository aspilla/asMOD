-- 설정 (변경가능)
local AHT_Font = "Fonts\\2002.TTF";
local AHT_HealthSize = 18;
local AHT_ManaSize = 14;
local AHT_PetHealthSize = 12;
local AHT_PetManaSize = 10;
local AHT_FontOutline = "THICKOUTLINE";
local AHT_X	= 100;
local AHT_Y = -25;
local AHT_SPELLBAR_X = 0;			-- Spell bar 위치
local AHT_SPELLBAR_Y = -110 - 20;
local AHT_SHOW_SPELLBAR = true;		-- Spell bar 숨기려면 false
local AHT_COMBAT_OFF_SHOW = false;	-- 비전투중에도 보이려면 true
local AHT_MANA_PREDICTION = false;	-- 마나 예상치 보이려면 true
local AHT_RIGHT_COMBO = false;		-- 오른편에 Combo를 보이려면 true
-- 설정끝

local AHT_UNIT_POWER = "";
local AHT_POWER_LEVEL = 9;
local AHT_MAX_INCOMING_HEAL_OVERFLOW = 1.2;
local bupdate_heal = true;			-- 예상힐을 안보이게 하려면 false
local bupdate_power = false;
local bupdate_stagger = false;
local bupdate_action_count = false;
local action_list = {};
AHT_UNIT_POWER_VALUE = 0;
AHT_UNIT_MANA_VALUE = 0;
AHT_TARGET_HEALTH_VALUE = 0;

local AHT_mainframe = CreateFrame("Frame", "AHT_main", UIParent);

local AHT_TargetClass = nil;
local unit_player = "player"
local unit_pet = "pet"


local function AHT_HealColor(value)
	
	local r, g, b;
	local min, max = 0, 100 * AHT_MAX_INCOMING_HEAL_OVERFLOW;

	if ( (max - min) > 0 ) then
		value = (value - min) / (max - min);
	else
		value = 0;
	end

	if(value > 0.5) then
		r = (1.0 - value) * 2;
		g = 1.0;
	else
		r = 1.0;
		g = value * 2;
	end
	b = 0.0;

	return r, g, b;
end

local function AHT_UpdateHeal()

	if bupdate_heal == false then
		return;
	end

	local allIncomingHeal = UnitGetIncomingHeals("player") or 0;
	local totalAbsorb = UnitGetTotalAbsorbs("player") or 0;
	

	local health = UnitHealth(unit_player);
	local maxHealth = UnitHealthMax(unit_player);

	if ( health + allIncomingHeal > maxHealth * AHT_MAX_INCOMING_HEAL_OVERFLOW ) then
		allIncomingHeal = maxHealth * AHT_MAX_INCOMING_HEAL_OVERFLOW - health;
	end

	health = health + allIncomingHeal;

	local valuePct = (math.ceil((health / maxHealth) * 100));
	local valuePctAbsorb = (math.ceil((totalAbsorb / maxHealth) * 100));

	local r,g,b;

	r,g,b = AHT_HealColor(valuePct);
	
	if (allIncomingHeal > 0 and totalAbsorb > 0 ) then
		AHT_Heal:SetText("|cffffffff" .. valuePct .." |r |cffff3399".. valuePctAbsorb);
	elseif (allIncomingHeal > 0) then
		AHT_Heal:SetText("|cffffffff" .. valuePct);
	elseif (totalAbsorb > 0) then
		AHT_Heal:SetText("|cffff3399" ..valuePctAbsorb);
	end

	--AHT_Heal:SetTextColor(r, g, b, 1);

	if (allIncomingHeal > 0 or totalAbsorb > 0 ) then
		AHT_Heal:Show();
	else
		AHT_Heal:Hide();
	end
end

local function AHT_Update(self)
	--local discard, valueMax = self:GetMinMaxValues();
	--local value = self:GetValue();
	local value;
	local valueMax;
	local valuePct = ""
	local frame;
	local health = false;
	local target = false;
	local mana = false;
	local pre_mana = nil;
	local predict = false;
	local powerType;
	
	if self == 1 then
		frame = AHT_PlayerHPT; 

		value = UnitHealth(unit_player);
		valueMax = UnitHealthMax(unit_player);
		health = true;
	elseif self == 2 then

		frame = AHT_PlayerMPT; 

		powerType, powerTypeString = UnitPowerType(unit_player);
		value = UnitPower(unit_player, powerType);
		valueMax = UnitPowerMax(unit_player, powerType);
		mana = true;

	elseif self == 3 then
		frame = AHT_TargetHPT; 
	
		if UnitExists("target") then
			value = UnitHealth("target");
			valueMax = UnitHealthMax("target");
		else
			value = 0;
			valueMax = 100;
		end

		health = true;
		target = true;
	elseif self == 4 then
		frame = AHT_TargetMPT; 
		
		if UnitExists("target") then
			powerType, powerTypeString = UnitPowerType("target");
			value = UnitPower("target", powerType);
			valueMax = UnitPowerMax("target", powerType);
		else
			value = 0;
			valueMax = 100;
		end

		mana = true;

	elseif self == 5 then
		frame = AHT_PetHPT;
		value = UnitHealth(unit_pet);
		valueMax = UnitHealthMax(unit_pet);

		health = true;
	elseif self == 6 then
		frame = AHT_PetMPT;

		powerType, powerTypeString = UnitPowerType(unit_pet);
		value = UnitPower(unit_pet, powerType);
		valueMax = UnitPowerMax(unit_pet, powerType);

		mana = true;

	end

	if valueMax > 0 then
		valuePct =  (math.ceil((value / valueMax) * 100));
	end

	if (valueMax <= 300) then
		valuePct = value;
	end

	if valuePct > 0 then
		frame:SetText(valuePct);
		frame:Show();
	else
		frame:SetText("");
		--frame:Hide();
	end


	if health and valuePct > 0 then

		local color = nil;
		if AHT_TargetClass then
			color = RAID_CLASS_COLORS[AHT_TargetClass];
		end

		if color and target then
			frame:SetTextColor(color.r, color.g, color.b, 1);
		else
			local r,g,b = AHT_HealColor(valuePct);
			frame:SetTextColor(r, g, b, 1);
		end
	else

		if mana and powerType then
			local info = PowerBarColor[powerType];
			frame:SetTextColor(info.r, info.g, info.b);
		end
	end

end

local function AHT_UpdateThreat()

	if not (UnitClassification("target") == "minus")  then
		local isTanking, status, percentage, rawPercentage = UnitDetailedThreatSituation("player", "target");
	
		local display;

		if ( isTanking ) then
			display = UnitThreatPercentageOfLead("player", "target");
		end

		if not display then
			display = percentage;
		end
		
		if ( display and display ~= 0 ) then
			AHT_Threat:SetText(format("%1.0f", display).."%");
			local r, g, b =	GetThreatStatusColor(status)
			AHT_Threat:SetTextColor(r, g, b, 1);
			AHT_Threat:Show();
			--AHT_ThreatPVP:Hide();
		else
			AHT_Threat:Hide();
		end
	end

end


local move_frame = false;

local RUNETYPE_BLOOD = 1

local RUNETYPE_FROST = 3
local RUNETYPE_DEATH = 4
local runes = {0,0,0,0}

local function AHT_UpdateRune()

	local i;
	local text = "";
	local runeReady, runeType;
	local runeCount = 0;
	runes = {0,0,0,0}
	for i = 1, 6 do 
		discard, discard, runeReady = GetRuneCooldown(i);
			if runeReady then
				runeCount = runeCount + 1;
			end
	end

	AHT_Rune:SetText(runeCount);
end


local function AHT_UpdatePower()

	if  bupdate_power then
	
		local power = UnitPower("player", AHT_POWER_LEVEL);
		local max = UnitPowerMax("player", AHT_POWER_LEVEL);
	
		AHT_Power:SetText(power);
		AHT_UNIT_POWER_VALUE = power;
		AHT_Power:Show();

		if max == power then
			AHT_Power:SetTextColor(1, 0, 0)
		else
			AHT_Power:SetTextColor(1, 1, 0)
		end	


		local localizedClass, englishClass = UnitClass("player")

		if (englishClass == "DRUID") then
			local form  = GetShapeshiftFormID();
	
			if (form ~= CAT_FORM) then
				AHT_Power:SetText("");
				AHT_Power:Hide();
			end

		end

		if AHT_UNIT_POWER == "SHADOW_ORBS" then

			if GetSpecialization() < 3 then
				AHT_Power:SetText("");
				AHT_Power:Hide();
			end
		end
	end
end

local function AHT_UpdateStagger()
	if bupdate_stagger then

		local stagger = math.ceil(UnitStagger("player")/UnitHealthMax("player") * 100);


		if stagger > 0 then
			AHT_Power:SetText(stagger);
			AHT_UNIT_POWER_VALUE = stagger;
			AHT_Power:Show();
		else
			AHT_Power:SetText("");
			AHT_Power:Hide();
		end				
	end
		
end

local function AHT_UnitBuff(unit, buff, filter)

	local i = 1;
	repeat

		local name = UnitBuff(unit, i, filter);

		if name == buff then
			return 	UnitBuff(unit, i, filter);
		end


		i = i + 1;


	until (name == nil)

	return nil
end



local function AHT_UpdateBuff()
	if bupdate_buff then


		local buff,  _, buff_count = AHT_UnitBuff("player", AHT_UNIT_POWER);

		if buff and buff_count and  buff_count > 0 then
			AHT_Power:SetText(buff_count);
			AHT_UNIT_POWER_VALUE = buff_count;
			AHT_Power:Show();
		elseif buff then
			AHT_Power:SetText(1);
			AHT_UNIT_POWER_VALUE = 1;
			AHT_Power:Show();
		else
			AHT_Power:Hide();
		end				
	end
		
end

local function AHT_GetActionSlot(arg1)
	local lActionSlot = 0;

	for lActionSlot = 1, 120 do
		local type, id, subType, spellID = GetActionInfo(lActionSlot);

		if type and type == "macro" then
			id = GetMacroSpell(id);
		end
	
		if id then
			local name = GetSpellInfo(id);


			if name and name == arg1 then
				return lActionSlot;
			end
		end
	end

	return nil;
end


local function AHT_UpdateActionCount()
	if bupdate_action_count and action_list then

		local text = "";

		for i = 1, #action_list do

			if action_list[i][1] then
				if not action_list[i][2] then
					local slot = AHT_GetActionSlot(action_list[i][1]);
					action_list[i][2] = slot;
				end


				local count, max = GetSpellCharges(action_list[i][1]);
				
				if (not count or (count and count == 0)) and 	action_list[i][2]  then
					count = GetActionCount(	action_list[i][2] );

					max = 1000;
				end

				if count then
					if i == 1 then
						text = count;
					else
						text = text .."/"..count;
					end
				end				
			end

		end

		if text then
			AHT_Power:SetText(text);
			AHT_Power:Show();
		else
			AHT_Power:Hide();
		end				
	end
		
end

local function AHT_UpdatePlayerUnit()

	local hasValidVehicleUI = UnitHasVehicleUI("player");
	local unitVehicleToken;
	if ( hasValidVehicleUI ) then
		local prefix, id, suffix = string.match("player", "([^%d]+)([%d]*)(.*)")
		unitVehicleToken = prefix.."pet"..id..suffix;
		if ( not UnitExists(unitVehicleToken) ) then
			hasValidVehicleUI = false;
		end
	end
	
	if ( hasValidVehicleUI ) then
		unit_player = unitVehicleToken
		unit_pet = "player"
	else
		unit_player = "player"
		unit_pet = "pet"
	end



end



local function AHT_InitValue()
	AHT_UpdatePlayerUnit()
	AHT_Update(1)
	AHT_Update(2)
	AHT_Update(3)
	AHT_Update(4)
	AHT_Update(5)
	AHT_Update(6)
	AHT_UpdatePower()
end


local function AHT_CheckHeal()

	local masteryIndex = GetSpecialization ();
	local name = nil;

	local role = nil

	if GetSpecialization() ~= nil then
		role = GetSpecializationRole(GetSpecialization())
	end

	AHT_mainframe:RegisterUnitEvent("UNIT_HEAL_PREDICTION", "player");
	AHT_mainframe:RegisterUnitEvent("UNIT_ABSORB_AMOUNT_CHANGED", "player");
	AHT_mainframe:RegisterUnitEvent("UNIT_HEAL_ABSORB_AMOUNT_CHANGED", "player");

		
	if (bupdate_heal == false) then
		AHT_Heal:Hide();
	end

end

local function AHT_CheckSpec(line,col)


	local talentgroup = GetActiveSpecGroup();

	if talentgroup then
		local talentID, name, iconTexture, selected, available, _, _, _, _, _, grantedByAura  = GetTalentInfo(line, col, talentgroup);

		if selected or grantedByAura  then
			return true;
		end
	end
	return false;
end

local function AHT_CheckPower()
	
	local localizedClass, englishClass = UnitClass("player")
	local spec = GetSpecialization();

	AHT_mainframe:UnregisterEvent("UNIT_POWER_UPDATE")
	AHT_mainframe:UnregisterEvent("UNIT_DISPLAYPOWER");
	AHT_mainframe:UnregisterEvent("RUNE_POWER_UPDATE")
	AHT_mainframe:UnregisterEvent("UNIT_AURA");
	AHT_mainframe:UnregisterEvent("ACTIONBAR_UPDATE_COOLDOWN");
	
	bupdate_power = false;
	bupdate_stagger = false;
	bupdate_action_count = false;
	
	AHT_Power:SetText("");
	AHT_Power:Hide();
	
	if (englishClass == "DEATHKNIGHT") then
		AHT_UpdateRune()
		AHT_Rune:Show()
		AHT_mainframe:RegisterEvent("RUNE_POWER_UPDATE")
	end

	if (englishClass == "PALADIN") then
	

		if (spec and spec == 2) then

			AHT_UNIT_POWER = "HOLY_POWER"
			AHT_POWER_LEVEL = Enum.PowerType.HolyPower

			AHT_mainframe:RegisterUnitEvent("UNIT_POWER_UPDATE", "player")
			AHT_mainframe:RegisterUnitEvent("UNIT_DISPLAYPOWER", "player");
			bupdate_power = true;
		elseif (spec and spec == 3) then

			AHT_UNIT_POWER = "HOLY_POWER"
			AHT_POWER_LEVEL = Enum.PowerType.HolyPower

			AHT_mainframe:RegisterUnitEvent("UNIT_POWER_UPDATE", "player")
			AHT_mainframe:RegisterUnitEvent("UNIT_DISPLAYPOWER", "player");
			bupdate_power = true;
		end
	end

	if (englishClass == "WARRIOR") then

	end

	if (englishClass == "DEMONHUNTER") then


	end


	if (englishClass == "MAGE") then

		if (spec and spec == 1) then

			AHT_UNIT_POWER = "ARCANE_CHARGES"
			AHT_POWER_LEVEL = Enum.PowerType.ArcaneCharges 
			AHT_mainframe:RegisterUnitEvent("UNIT_POWER_UPDATE", "player")
			AHT_mainframe:RegisterUnitEvent("UNIT_DISPLAYPOWER", "player");
			bupdate_power = true;
		end
	end


	if (englishClass == "WARLOCK") then

		AHT_UNIT_POWER = "SOUL_SHARDS"
		AHT_POWER_LEVEL = Enum.PowerType.SoulShards 
		AHT_mainframe:RegisterUnitEvent("UNIT_POWER_UPDATE", "player")
		AHT_mainframe:RegisterUnitEvent("UNIT_DISPLAYPOWER", "player");
		bupdate_power = true;
	end

	if (englishClass == "DRUID") then

		if (spec and spec == 1) then
		else
			AHT_UNIT_POWER = "COMBO_POINTS"
			AHT_POWER_LEVEL = Enum.PowerType.ComboPoints
			AHT_mainframe:RegisterUnitEvent("UNIT_POWER_UPDATE", "player")
			AHT_mainframe:RegisterUnitEvent("UNIT_DISPLAYPOWER", "player");
			AHT_mainframe:RegisterEvent("UPDATE_SHAPESHIFT_FORM");
			bupdate_power = true;
		end

	end

	if (englishClass == "MONK") then

		if (spec and spec == 3) then


			AHT_UNIT_POWER = "CHI"
			AHT_POWER_LEVEL = Enum.PowerType.Chi

			AHT_mainframe:RegisterUnitEvent("UNIT_POWER_UPDATE", "player")
			AHT_mainframe:RegisterUnitEvent("UNIT_DISPLAYPOWER", "player");
			bupdate_power = true;
		elseif (spec and spec == 1) then
			bupdate_stagger = true;
			AHT_mainframe:RegisterUnitEvent("UNIT_AURA", "player");
		end
	end

	if (englishClass == "ROGUE") then
		AHT_UNIT_POWER = "COMBO_POINTS"
		AHT_POWER_LEVEL = Enum.PowerType.ComboPoints
		AHT_mainframe:RegisterUnitEvent("UNIT_POWER_UPDATE", "player")
		AHT_mainframe:RegisterUnitEvent("UNIT_DISPLAYPOWER", "player");
		bupdate_power = true;
	end
	
	if (englishClass == "SHAMAN") then
	end

	if (englishClass == "HUNTER") then
	end


	if (englishClass == "PRIEST") then

	end


end

local RaidIconList = {
	"|TInterface\\TargetingFrame\\UI-RaidTargetingIcon_1:",
	"|TInterface\\TargetingFrame\\UI-RaidTargetingIcon_2:",
	"|TInterface\\TargetingFrame\\UI-RaidTargetingIcon_3:",
	"|TInterface\\TargetingFrame\\UI-RaidTargetingIcon_4:",
	"|TInterface\\TargetingFrame\\UI-RaidTargetingIcon_5:",
	"|TInterface\\TargetingFrame\\UI-RaidTargetingIcon_6:",
	"|TInterface\\TargetingFrame\\UI-RaidTargetingIcon_7:",
	"|TInterface\\TargetingFrame\\UI-RaidTargetingIcon_8:",
}

local function AHT_DisplayRaidIcon(unit)
	local icon = GetRaidTargetIndex(unit)
	if icon and RaidIconList[icon] then
		return RaidIconList[icon] .. "0|t"
	else	
		return ""
	end
end

local function AHT_UpdateRaidIcon()
	local text = AHT_DisplayRaidIcon("target");

	AHT_RaidIcon:SetText(text);
end


local function AHT_OnUpdate()

	AHT_Update(1)
	AHT_Update(2)
	AHT_Update(3)
	AHT_Update(4)
	AHT_Update(5)
	AHT_Update(6)
	AHT_UpdateThreat();
	
end


local function AHT_OnLoad()

	AHT_mainframe:CreateFontString("AHT_PlayerHPT", "OVERLAY")
	AHT_mainframe:CreateFontString("AHT_PlayerMPT", "OVERLAY")
	AHT_mainframe:CreateFontString("AHT_TargetHPT", "OVERLAY")
	AHT_mainframe:CreateFontString("AHT_TargetMPT", "OVERLAY")
	AHT_mainframe:CreateFontString("AHT_PetHPT", "OVERLAY")
	AHT_mainframe:CreateFontString("AHT_PetMPT", "OVERLAY")
	AHT_mainframe:CreateFontString("AHT_Threat", "OVERLAY")
	AHT_mainframe:CreateFontString("AHT_ThreatPVP", "OVERLAY")
	AHT_mainframe:CreateFontString("AHT_Rune", "OVERLAY")
	AHT_mainframe:CreateFontString("AHT_Heal", "OVERLAY")
	AHT_mainframe:CreateFontString("AHT_RaidIcon", "OVERLAY")
	AHT_mainframe:CreateFontString("AHT_Power", "OVERLAY")

	AHT_PlayerHPT:SetFont(AHT_Font, AHT_HealthSize, AHT_FontOutline)
	AHT_PlayerMPT:SetFont(AHT_Font, AHT_ManaSize, AHT_FontOutline)
	AHT_TargetHPT:SetFont(AHT_Font, AHT_HealthSize, AHT_FontOutline)
	AHT_TargetMPT:SetFont(AHT_Font, AHT_ManaSize, AHT_FontOutline)
	AHT_PetHPT:SetFont(AHT_Font, AHT_PetHealthSize, AHT_FontOutline)
	AHT_PetMPT:SetFont(AHT_Font, AHT_PetManaSize, AHT_FontOutline)
	AHT_Threat:SetFont(AHT_Font, AHT_ManaSize, AHT_FontOutline)
	AHT_ThreatPVP:SetFont(AHT_Font, AHT_ManaSize, AHT_FontOutline)
	AHT_Rune:SetFont(AHT_Font, AHT_HealthSize, AHT_FontOutline)
	AHT_Heal:SetFont(AHT_Font, AHT_ManaSize, AHT_FontOutline)
	AHT_RaidIcon:SetFont(AHT_Font, AHT_HealthSize, AHT_FontOutline)
	AHT_Power:SetFont(AHT_Font, AHT_HealthSize , AHT_FontOutline)

	AHT_PlayerHPT:SetPoint("CENTER", UIParent, "CENTER", 0 - AHT_X, AHT_Y)
	AHT_PlayerMPT:SetPoint("TOP", AHT_PlayerHPT, "BOTTOM", 0, -2)
	AHT_TargetHPT:SetPoint("CENTER", UIParent, "CENTER", AHT_X, AHT_Y)
	AHT_TargetMPT:SetPoint("TOP", AHT_TargetHPT, "BOTTOM", 0, -2)
	AHT_ThreatPVP:SetPoint("BOTTOM", AHT_TargetHPT, "TOP", 0, 2)
	AHT_Threat:SetPoint("BOTTOM", AHT_ThreatPVP, "TOP", 0, 2)
	AHT_Heal:SetPoint("BOTTOM", AHT_PlayerHPT, "TOP", 0 , 2 )

	if AHT_RIGHT_COMBO then
		AHT_Rune:SetPoint("LEFT", AHT_TargetHPT, "RIGHT", 2 , 0)
		AHT_Power:SetPoint("LEFT", AHT_Rune, "RIGHT", 0, 0)
		AHT_RaidIcon:SetPoint("LEFT", AHT_Power, "RIGHT", 2, 0)
		AHT_PetHPT:SetPoint("RIGHT", AHT_PlayerHPT, "LEFT", -4, 0)
		AHT_PetMPT:SetPoint("TOP", AHT_PetHPT, "BOTTOM", 0,  -2)
	else
		AHT_Rune:SetPoint("RIGHT", AHT_PlayerHPT, "LEFT", -2 , 0)
		AHT_Power:SetPoint("RIGHT", AHT_Rune, "LEFT", 0, 0)
		AHT_RaidIcon:SetPoint("LEFT", AHT_TargetHPT, "RIGHT", 2, 0)
		AHT_PetHPT:SetPoint("RIGHT", AHT_Power, "LEFT", -2, 0)
		AHT_PetMPT:SetPoint("TOP", AHT_PetHPT, "BOTTOM", 0,  -2)
	end

	AHT_Power:SetTextColor(1, 1, 0, 1)

	
	AHT_CheckPower();

	AHT_mainframe:RegisterEvent("PLAYER_ENTERING_WORLD")
	AHT_mainframe:RegisterEvent("PLAYER_TARGET_CHANGED")
	AHT_mainframe:RegisterEvent("PLAYER_REGEN_DISABLED")
	AHT_mainframe:RegisterEvent("PLAYER_REGEN_ENABLED")
	AHT_mainframe:RegisterUnitEvent("UNIT_ENTERED_VEHICLE", "player")
	AHT_mainframe:RegisterUnitEvent("UNIT_EXITED_VEHICLE", "player")
	AHT_mainframe:RegisterEvent("VARIABLES_LOADED")
	AHT_mainframe:RegisterEvent("ACTIVE_TALENT_GROUP_CHANGED")
	AHT_mainframe:RegisterEvent("PLAYER_TALENT_UPDATE")
	AHT_mainframe:RegisterUnitEvent("UNIT_TARGET", "target")
	AHT_mainframe:RegisterUnitEvent("UNIT_THREAT_SITUATION_UPDATE", "player", "target" );
	AHT_mainframe:RegisterEvent("RAID_TARGET_UPDATE");


end


function AHT_OnEvent(self, event, arg1, arg2, arg3, ...)

	if event == "PLAYER_ENTERING_WORLD" or event == "VARIABLES_LOADED" then
		AHT_InitValue();
		if event == "PLAYER_ENTERING_WORLD" then
			AHT_CheckHeal();
			AHT_CheckPower();

		end

		if UnitIsConnected("target") then
			--do nothing
		else
			AHT_TargetHPT:SetText("");
			AHT_TargetMPT:SetText("");
		end

		if UnitAffectingCombat("player") then
			AHT_mainframe:Show();
		else
			if AHT_COMBAT_OFF_SHOW then
				AHT_mainframe:Show();
			else
				AHT_mainframe:Hide();
			end
		end

	elseif event == "PLAYER_TARGET_CHANGED" then
		AHT_TargetClass = nil;
		if UnitIsConnected("target") then
			if UnitIsPlayer("target") then
				_, AHT_TargetClass = UnitClass("target")
			end

			if  UnitIsPlayer("targettarget") then
					local _,class = UnitClass("targettarget");
					local color = nil;

					if class then
						color = RAID_CLASS_COLORS[class];
					end

					if color then
						AHT_ThreatPVP:SetTextColor(color.r, color.g, color.b, 1);
					end

					AHT_ThreatPVP:SetText(UnitName("targettarget"));
					AHT_ThreatPVP:Show();
				else
					AHT_ThreatPVP:SetText("");
					AHT_ThreatPVP:Hide();
				end
			--else
			--	AHT_ThreatPVP:Hide();
			--end
			AHT_InitValue();
		else
			AHT_ThreatPVP:SetText("");
			AHT_ThreatPVP:Hide();
			
			AHT_TargetHPT:SetText("");
			AHT_TargetMPT:SetText("");
		end

		AHT_UpdateThreat();

		AHT_UpdateRaidIcon();

	elseif event == "UNIT_TARGET" and arg1 == "target" then
		if UnitIsPlayer("targettarget") then

			local _,class = UnitClass("targettarget");
			local color = nil;

			if class then
				color = RAID_CLASS_COLORS[class];
			end

			if color then
				AHT_ThreatPVP:SetTextColor(color.r, color.g, color.b, 1);
			end

			AHT_ThreatPVP:SetText(UnitName("targettarget"));
			AHT_ThreatPVP:Show();
		else
			AHT_ThreatPVP:SetText("");
			AHT_ThreatPVP:Hide();
		end

	elseif event == "UNIT_ENTERED_VEHICLE" and arg1 == "player" then
		AHT_InitValue();
	elseif event == "UNIT_EXITED_VEHICLE" and arg1 == "player" then
		AHT_InitValue();
	elseif event == "PLAYER_REGEN_DISABLED" then
		AHT_mainframe:Show();
	elseif event == "PLAYER_REGEN_ENABLED" then
		if AHT_COMBAT_OFF_SHOW then
			AHT_mainframe:Show();
		else
			AHT_mainframe:Hide();
		end
	elseif event == "RUNE_POWER_UPDATE" then
		AHT_UpdateRune();
	elseif event == "UNIT_POWER_UPDATE" and arg1 == "player" then
		AHT_UpdatePower();
	elseif event == "UNIT_AURA" and arg1 == "player" then
		AHT_UpdateStagger();
		AHT_UpdateBuff();
	elseif event == "ACTIONBAR_UPDATE_COOLDOWN" then
		AHT_UpdateActionCount();
	elseif event == "UNIT_DISPLAYPOWER" and arg1 == "player"  then
		AHT_UpdatePower();
	elseif event == "UNIT_HEAL_PREDICTION" and arg1 == "player" then
		AHT_UpdateHeal();
	elseif event == "UNIT_ABSORB_AMOUNT_CHANGED" and arg1 == "player" then
		AHT_UpdateHeal();
	elseif event == "UNIT_HEAL_ABSORB_AMOUNT_CHANGED" and arg1 == "player" then
		AHT_UpdateHeal();
	elseif event == "ACTIVE_TALENT_GROUP_CHANGED" or event ==  "PLAYER_TALENT_UPDATE" then
		AHT_CheckPower();
		AHT_UpdatePower();
		AHT_CheckHeal();
		AHT_InitValue();

	elseif event == "UPDATE_SHAPESHIFT_FORM" then
		AHT_UpdatePower();
	elseif event == "RAID_TARGET_UPDATE" then
		AHT_UpdateRaidIcon();

	elseif ( event == "UNIT_THREAT_SITUATION_UPDATE") then
		AHT_UpdateThreat();

	end

	return;
end 


AHT_mainframe:SetScript("OnEvent", AHT_OnEvent)
C_Timer.NewTicker(0.1, AHT_OnUpdate);
AHT_OnLoad()
