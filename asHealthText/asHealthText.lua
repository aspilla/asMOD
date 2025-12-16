-- 설정 (변경가능)
local AHT_Font = STANDARD_TEXT_FONT;
local AHT_HealthSize = 18;
local AHT_ManaSize = 14;
local AHT_PetHealthSize = 12;
local AHT_PetManaSize = 10;
local AHT_FontOutline = "THICKOUTLINE";
local AHT_X = 150;
local AHT_Y = -55;
local AHT_COMBAT_OFF_SHOW = false; -- 비전투중에도 보이려면 true
local AHT_RIGHT_COMBO = false;     -- 오른편에 Combo를 보이려면 true
-- 설정끝
local AHT_POWER_LEVEL = nil;
local AHT_MAX_INCOMING_HEAL_OVERFLOW = 1.2;
local bupdate_heal = true;
local bupdate_stagger = false;
local bupdate_partial = false;

local AHT_mainframe = CreateFrame("Frame", nil, UIParent);
local unit_player = "player"
local unit_pet = "pet"

local AHT_PlayerHPT
local AHT_PlayerMPT
local AHT_TargetHPT
local AHT_TargetMPT
local AHT_PetHPT
local AHT_PetMPT
local AHT_Threat
local AHT_ThreatPVP
local AHT_Rune
local AHT_Heal
local AHT_RaidIcon
local AHT_Power

local function AHT_UpdateHeal()
	if bupdate_heal == false then
		return;
	end

	local allIncomingHeal = UnitGetIncomingHeals("player") or 0;
	local totalAbsorb = UnitGetTotalAbsorbs("player") or 0;


	--[[
	local health = UnitHealth(unit_player);
	local maxHealth = UnitHealthMax(unit_player);

	if (health + allIncomingHeal > maxHealth * AHT_MAX_INCOMING_HEAL_OVERFLOW) then
		allIncomingHeal = maxHealth * AHT_MAX_INCOMING_HEAL_OVERFLOW - health;
	end

	health = health + allIncomingHeal;

	local valuePct = (math.ceil((health / maxHealth) * 100));
	local valuePctAbsorb = (math.ceil((totalAbsorb / maxHealth) * 100));

	if (allIncomingHeal > 0 and totalAbsorb > 0) then
		AHT_Heal:SetText("|cffffffff" .. valuePct .. " |r |cffff3399" .. valuePctAbsorb);
	elseif (allIncomingHeal > 0) then
		AHT_Heal:SetText("|cffffffff" .. valuePct);
	elseif (totalAbsorb > 0) then
		AHT_Heal:SetText("|cffff3399" .. valuePctAbsorb);
	end

	if (allIncomingHeal > 0 or totalAbsorb > 0) then
		AHT_Heal:Show();
	else
		AHT_Heal:Hide();
	end

	]]
end

local curve = C_CurveUtil.CreateCurve();
curve:SetType(Enum.LuaCurveType.Linear);
curve:AddPoint(0, 0);
curve:AddPoint(1, 100);

local function update_health(frame, unit)
	if UnitExists(unit) then
		local valuePct = UnitHealthPercent(unit, false, curve);
		frame:SetText(string.format("%d", valuePct));
		frame:Show();

		local role = UnitGroupRolesAssigned(unit);
		if UnitIsPlayer(unit) or (role and role ~= "NONE") then
			local class = select(2, UnitClass(unit));
			local classColor = class and RAID_CLASS_COLORS[class] or nil;
			if classColor then
				frame:SetTextColor(classColor.r, classColor.g, classColor.b);
			end
		else
			local r = 0;
			local g = 1.0;
			local b = 0;
			local reaction = UnitReaction("player", unit);
			if (reaction) then
				r = FACTION_BAR_COLORS[reaction].r;
				g = FACTION_BAR_COLORS[reaction].g;
				b = FACTION_BAR_COLORS[reaction].b;
			end

			frame:SetTextColor(r, g, b);
		end
	else
		frame:Hide();
	end
end

local function update_power(frame, unit)
	if UnitExists(unit) then
		local powerType = UnitPowerType(unit);

		local value     = UnitPower("player", powerType, true);		
		frame:SetText(string.format("%d", value));

		local powerColor = PowerBarColor[powerType]
		if powerColor then
			frame:SetTextColor(powerColor.r, powerColor.g, powerColor.b)
		end
		frame:Show();
	else
		frame:Hide();
	end
end

local function AHT_Update(update_type)
	local frame;

	if update_type == 1 then
		frame = AHT_PlayerHPT;
		update_health(frame, unit_player);
	elseif update_type == 2 then
		frame = AHT_PlayerMPT;
		update_power(frame, unit_player);
	elseif update_type == 3 then
		frame = AHT_TargetHPT;
		update_health(frame, "target");
	elseif update_type == 4 then
		frame = AHT_TargetMPT;
		update_power(frame, "target");
	elseif update_type == 5 then
		frame = AHT_PetHPT;
		update_health(frame, unit_pet);
	elseif update_type == 6 then
		frame = AHT_PetMPT;
		update_power(frame, unit_pet);
	end
end

local function AHT_UpdateThreat()
	if not (UnitClassification("target") == "minus") then
		local isTanking, status, percentage, rawPercentage = UnitDetailedThreatSituation("player", "target");

		local display;

		if (isTanking) then
			display = UnitThreatPercentageOfLead("player", "target");
		end

		if not display then
			display = percentage;
		end

		if (display and display ~= 0) then
			AHT_Threat:SetText(format("%1.0f", display) .. "%");
			local r, g, b = GetThreatStatusColor(status)
			AHT_Threat:SetTextColor(r, g, b, 1);
			AHT_Threat:Show();
		else
			AHT_Threat:Hide();
		end
	end
end

local function AHT_UpdateRune()
	local runeReady;
	local runeCount = 0;

	for i = 1, 6 do
		_, _, runeReady = GetRuneCooldown(i);
		if runeReady then
			runeCount = runeCount + 1;
		end
	end

	AHT_Rune:SetText(runeCount);
end


local function AHT_UpdatePower()
	if AHT_POWER_LEVEL then
		local power = UnitPower("player", AHT_POWER_LEVEL, bupdate_partial);		

		AHT_Power:SetText(power);
		AHT_Power:Show();
		if max == power then
			AHT_Power:SetTextColor(1, 0, 0)
		else
			AHT_Power:SetTextColor(1, 1, 0)
		end
	end
end

local function AHT_UpdateStagger()
	if bupdate_stagger then
		local stagger = math.ceil(UnitStagger("player") / UnitHealthMax("player") * 100);

		if stagger > 0 then
			AHT_Power:SetText(stagger);
			AHT_Power:Show();
		else
			AHT_Power:SetText("");
			AHT_Power:Hide();
		end
	end
end

local function AHT_UpdatePlayerUnit()
	local hasValidVehicleUI = UnitHasVehicleUI("player");
	local unitVehicleToken;
	if (hasValidVehicleUI) then
		local prefix, id, suffix = string.match("player", "([^%d]+)([%d]*)(.*)")
		unitVehicleToken = prefix .. "pet" .. id .. suffix;
		if (not UnitExists(unitVehicleToken)) then
			hasValidVehicleUI = false;
		end
	end

	if (hasValidVehicleUI) then
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
	AHT_mainframe:RegisterUnitEvent("UNIT_HEAL_PREDICTION", "player");
	AHT_mainframe:RegisterUnitEvent("UNIT_ABSORB_AMOUNT_CHANGED", "player");
	AHT_mainframe:RegisterUnitEvent("UNIT_HEAL_ABSORB_AMOUNT_CHANGED", "player");


	if (bupdate_heal == false) then
		AHT_Heal:Hide();
	end
end

local function AHT_CheckPower()
	local localizedClass, englishClass = UnitClass("player")
	local spec = C_SpecializationInfo.GetSpecialization();

	AHT_mainframe:UnregisterEvent("UNIT_POWER_UPDATE")
	AHT_mainframe:UnregisterEvent("UNIT_DISPLAYPOWER");
	AHT_mainframe:UnregisterEvent("RUNE_POWER_UPDATE")
	AHT_mainframe:UnregisterEvent("UNIT_AURA");

	bupdate_stagger = false;
	bupdate_partial = false;

	AHT_Power:SetText("");
	AHT_Power:Hide();
	AHT_POWER_LEVEL = nil;

	if (englishClass == "EVOKER") then
		AHT_POWER_LEVEL = Enum.PowerType.Essence;
	end

	if (englishClass == "DEATHKNIGHT") then
		AHT_UpdateRune();
		AHT_Rune:Show();
		AHT_mainframe:RegisterEvent("RUNE_POWER_UPDATE");
	end

	if (englishClass == "PALADIN") then
		AHT_POWER_LEVEL = Enum.PowerType.HolyPower;
	end

	if (englishClass == "WARRIOR") then

	end

	if (englishClass == "DEMONHUNTER") then

	end


	if (englishClass == "MAGE") then
		if (spec and spec == 1) then
			AHT_POWER_LEVEL = Enum.PowerType.ArcaneCharges;
		end
	end


	if (englishClass == "WARLOCK") then
		AHT_POWER_LEVEL = Enum.PowerType.SoulShards;
		if (spec and spec == 3) then
			bupdate_partial = true;
		end
	end

	if (englishClass == "DRUID") then
		AHT_POWER_LEVEL = Enum.PowerType.ComboPoints;
		AHT_mainframe:RegisterEvent("UPDATE_SHAPESHIFT_FORM");
	end

	if (englishClass == "MONK") then
		if (spec and spec == 3) then
			AHT_POWER_LEVEL = Enum.PowerType.Chi;
		elseif (spec and spec == 1) then
			bupdate_stagger = true;
			AHT_mainframe:RegisterUnitEvent("UNIT_AURA", "player");
		end
	end

	if (englishClass == "ROGUE") then
		AHT_POWER_LEVEL = Enum.PowerType.ComboPoints;
	end

	if (englishClass == "SHAMAN") then
	end

	if (englishClass == "HUNTER") then
	end


	if (englishClass == "PRIEST") then

	end


	if AHT_POWER_LEVEL then
		AHT_mainframe:RegisterUnitEvent("UNIT_POWER_UPDATE", "player");
		AHT_mainframe:RegisterUnitEvent("UNIT_DISPLAYPOWER", "player");
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
	--[[
	local icon = GetRaidTargetIndex(unit)
	if icon and RaidIconList[icon] then
		return RaidIconList[icon] .. "0|t"
	else
		return ""
	end
	]]
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
	AHT_PlayerHPT = AHT_mainframe:CreateFontString(nil, "OVERLAY");
	AHT_PlayerMPT = AHT_mainframe:CreateFontString(nil, "OVERLAY");
	AHT_TargetHPT = AHT_mainframe:CreateFontString(nil, "OVERLAY");
	AHT_TargetMPT = AHT_mainframe:CreateFontString(nil, "OVERLAY");
	AHT_PetHPT = AHT_mainframe:CreateFontString(nil, "OVERLAY");
	AHT_PetMPT = AHT_mainframe:CreateFontString(nil, "OVERLAY");
	AHT_Threat = AHT_mainframe:CreateFontString(nil, "OVERLAY");
	AHT_ThreatPVP = AHT_mainframe:CreateFontString(nil, "OVERLAY");
	AHT_Rune = AHT_mainframe:CreateFontString(nil, "OVERLAY");
	AHT_Heal = AHT_mainframe:CreateFontString(nil, "OVERLAY");
	AHT_RaidIcon = AHT_mainframe:CreateFontString(nil, "OVERLAY");
	AHT_Power = AHT_mainframe:CreateFontString(nil, "OVERLAY");


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
	AHT_Power:SetFont(AHT_Font, AHT_HealthSize, AHT_FontOutline)

	AHT_PlayerHPT:SetPoint("CENTER", UIParent, "CENTER", 0 - AHT_X, AHT_Y)
	AHT_PlayerMPT:SetPoint("TOP", AHT_PlayerHPT, "BOTTOM", 0, -2)
	AHT_TargetHPT:SetPoint("CENTER", UIParent, "CENTER", AHT_X, AHT_Y)
	AHT_TargetMPT:SetPoint("TOP", AHT_TargetHPT, "BOTTOM", 0, -2)
	AHT_ThreatPVP:SetPoint("BOTTOM", AHT_TargetHPT, "TOP", 0, 2)
	AHT_Threat:SetPoint("BOTTOM", AHT_ThreatPVP, "TOP", 0, 2)
	AHT_Heal:SetPoint("BOTTOM", AHT_PlayerHPT, "TOP", 0, 2)

	if AHT_RIGHT_COMBO then
		AHT_Rune:SetPoint("LEFT", AHT_TargetHPT, "RIGHT", 2, 0)
		AHT_Power:SetPoint("LEFT", AHT_Rune, "RIGHT", 0, 0)
		AHT_RaidIcon:SetPoint("LEFT", AHT_Power, "RIGHT", 2, 0)
		AHT_PetHPT:SetPoint("RIGHT", AHT_PlayerHPT, "LEFT", -4, 0)
		AHT_PetMPT:SetPoint("TOP", AHT_PetHPT, "BOTTOM", 0, -2)
	else
		AHT_Rune:SetPoint("RIGHT", AHT_PlayerHPT, "LEFT", -2, 0)
		AHT_Power:SetPoint("RIGHT", AHT_Rune, "LEFT", 0, 0)
		AHT_RaidIcon:SetPoint("LEFT", AHT_TargetHPT, "RIGHT", 2, 0)
		AHT_PetHPT:SetPoint("RIGHT", AHT_Power, "LEFT", -2, 0)
		AHT_PetMPT:SetPoint("TOP", AHT_PetHPT, "BOTTOM", 0, -2)
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
	AHT_mainframe:RegisterUnitEvent("UNIT_THREAT_SITUATION_UPDATE", "player", "target");
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

			if UnitIsPlayer("targettarget") then
				local _, class = UnitClass("targettarget");
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
			local _, class = UnitClass("targettarget");
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
	elseif event == "UNIT_DISPLAYPOWER" and arg1 == "player" then
		AHT_UpdatePower();
	elseif event == "UNIT_HEAL_PREDICTION" and arg1 == "player" then
		AHT_UpdateHeal();
	elseif event == "UNIT_ABSORB_AMOUNT_CHANGED" and arg1 == "player" then
		AHT_UpdateHeal();
	elseif event == "UNIT_HEAL_ABSORB_AMOUNT_CHANGED" and arg1 == "player" then
		AHT_UpdateHeal();
	elseif event == "ACTIVE_TALENT_GROUP_CHANGED" or event == "PLAYER_TALENT_UPDATE" then
		AHT_CheckPower();
		AHT_UpdatePower();
		AHT_CheckHeal();
		AHT_InitValue();
	elseif event == "UPDATE_SHAPESHIFT_FORM" then
		AHT_UpdatePower();
	elseif event == "RAID_TARGET_UPDATE" then
		AHT_UpdateRaidIcon();
	elseif (event == "UNIT_THREAT_SITUATION_UPDATE") then
		AHT_UpdateThreat();
	end

	return;
end

AHT_mainframe:SetScript("OnEvent", AHT_OnEvent)
C_Timer.NewTicker(0.1, AHT_OnUpdate);
AHT_OnLoad()
