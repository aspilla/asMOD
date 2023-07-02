local APB_Font = "Fonts\\2002.TTF";
local APB_HealthSize = 12;
local APB_BuffSize = 10;
local APB_FontOutline = "OUTLINE";

local APB_WIDTH = 203;			--위치
local APB_X = 0;
local APB_Y = -142 - 70;
local APB_HEIGHT = 10
local APB_ALPHA_COMBAT = 1	-- 전투중 알파 값
local APB_ALPHA_NORMAL = 0.5
local APB_SHOW_HEALTHBAR = false -- 생명력바 표시



local bupdate_power = false;
local bupdate_rune = false;
local bupdate_spell = false;
local bupdate_buff_count = false;
local bupdate_powerbar = false;
local bupdate_healthbar = APB_SHOW_HEALTHBAR;
local bupdate_stagger = false;
local bupdate_fronzen = false;
local bupdate_windrunner = false;
local bshow_haste = false;
local bupdate_partial_power = false;
local bsmall_power_bar = false;
local bupdate_buff_combo = false;
local APB_UNIT_POWER;
local APB_POWER_LEVEL;

APB_SPELL = nil;
APB_SPELL2 = nil;
APB_BUFF = nil;
APB_BUFF2 = nil;
APB_BUFF_COMBO = nil;
APB_DEBUFF_COMBO = nil


local APB = nil;
local max_combo = nil;
local balert = false;
local balert2 = false;

local PowerTypeString = {}
PowerTypeString = {[Enum.PowerType.Focus] = "집중", [Enum.PowerType.Insanity] = "광기", [Enum.PowerType.Maelstrom] = "소용돌이", [Enum.PowerType.LunarPower] = "천공의 힘"};

local PowerTypeComboString = {}
PowerTypeComboString = {[Enum.PowerType.SoulShards] = "영혼의 조각", [Enum.PowerType.ArcaneCharges] = "비전 충전물이", [Enum.PowerType.Essence] = "정수"};

local SpellGetCosts = {};
local SpellGetPowerCosts = {};
local FrozenOrbID = 84714;
local FrozenOrbDamageID = 84721;
local function asGetCostTooltipInfo (spellID)
    if not spellID then return end

	local cost = SpellGetCosts[spellID]


	-- 8.0 change need
	--
	if cost then

		local powerType = UnitPowerType("player");
		local mana = UnitPower("player", powerType);
		local max = UnitPowerMax("player", powerType);

		local ret = math.min((max - mana), cost)
		return 0 - ret;
	end

	return  0;
end


local function asGetPowerCostTooltipInfo (spellID)
    if not spellID then return end

	local cost = SpellGetPowerCosts[spellID]


	-- 8.0 change need
	--
	if cost then
		return 0 - cost;
	end

	return  0;
end



local function APB_UnitBuff(unit, buff, casterid)


	local i = 1;
	local ret = nil;
	local filter = "INCLUDE_NAME_PLATE_ONLY";

	repeat
		local name, icon, count, debuffType, duration, expirationTime, caster, isStealable, shouldConsolidate, spellId = UnitBuff(unit, i, filter);

		if (name == buff or spellId == buff) and duration > 0 and caster == casterid  then
			return UnitBuff(unit, i, filter);
		elseif (name == buff or spellId == buff) and duration == 0 and caster == casterid   then
			ret = i;
		end

		i = i + 1;

	until (name == nil)

	if ret then
		return UnitBuff(unit, i, filter);
	end

	for slot=1, MAX_TOTEMS do
		local haveTotem, name, start, duration, icon = GetTotemInfo(slot);

		if name == buff and duration > 0 then
			return name, icon, 0, nil, duration, duration + start, "player";
		end
	end

	return nil;

end

local function APB_UnitDebuff(unit, buff, casterid)


	local i = 1;
	local ret = nil;

	repeat

		local name, _, _, _, duration, _, caster = UnitDebuff(unit, i);

		if name == buff and duration > 0 and caster == casterid  then
			return UnitDebuff(unit, i);
		elseif name == buff and duration == 0 and caster == casterid  then
			ret = i;
		end

		i = i + 1;

	until (name == nil)

	if ret then
		return UnitDebuff(unit, i);
	end

	return nil;


end


local function APB_UnitDebuff_Name(unit, buff, filter)


	local i = 1;


	repeat

		local name = UnitDebuff(unit, i, filter);

		if name == buff  then
			return UnitDebuff(unit, i, filter);
		end

		i = i + 1;

	until (name == nil)

	return nil;
end


local function APB_OnUpdateCombo(self, elapsed)

	if not self.start then
		return;
	end

	if not self.update  then
		self.update = 0;
	end

	self.update = self.update + elapsed

	if self.update >= 0.25  then
		local curr_time = GetTime();
		local curr_duration = curr_time - self.start;

		self.update = 0

		if curr_duration < self.duration then
			self:SetMinMaxValues(0, self.duration * 10)
			self:SetValue((curr_time - self.start) * 10)
		else
			self:SetMinMaxValues(0, self.duration)
			self:SetValue(self.duration)
			self.start = nil;
		end
	end
end

local prev_combo = nil;
local p_start = nil;

local function APB_ShowComboBar(combo, partial, cast, cooldown)

	local bmax = false;

	local _, Class = UnitClass("player")
	local color =RAID_CLASS_COLORS[Class]
	local value = 1;
	local gen = false;

	if prev_combo ~= combo then
		p_start = GetTime();
		prev_combo = combo;
	end


	if not cast then
		cast = 0;
	end

	if not partial then
		partial = 0;
	end

	if combo == max_combo and cast == 0 then
		bmax = true;
	end

	if combo > 10 then
		return;
	end

	if cast > 0 and combo >= cast then
		combo = combo - cast;
	elseif cast > 0 and combo < cast then
		cast = combo;
		combo = 0;

	elseif cast <= -1 then
		cast = 0 - cast;
		gen = true;
	elseif cast < 0  then

		partial = partial - (cast);
		if partial >= 1 then
			combo = combo + 1;
			partial = partial - 1;
		end
		cast = 0;
	end

	if partial > 0 then
		value = partial;		
	end

	for i = 1, max_combo do

		APB.combobar[i]:SetScript("OnUpdate", nil)

		if i <= combo then
			APB.combobar[i]:Show();
			APB.combobar[i]:SetValue(1)
			APB.combobar[i]:SetMinMaxValues(0, 1)


			if bmax then
				APB.combobar[i]:SetStatusBarColor(1, 0, 0);
			else
				APB.combobar[i]:SetStatusBarColor(color.r, color.g, color.b);
			end
		elseif i <= (combo + cast) then
			APB.combobar[i]:Show();
			APB.combobar[i]:SetValue(1)
			APB.combobar[i]:SetMinMaxValues(0, 1)

			if gen == false then
				APB.combobar[i]:SetStatusBarColor(0.5, 0.5, 0.5);
			else
				APB.combobar[i]:SetStatusBarColor(1, 1, 1);
			end
		elseif i == (combo + cast) + 1 and value < 1 then
			APB.combobar[i]:Show();
			APB.combobar[i]:SetValue(value)

			if bmax then
				APB.combobar[i]:SetStatusBarColor(1, 0, 0);
			else
				APB.combobar[i]:SetStatusBarColor(color.r, color.g, color.b);
			end
		elseif i == (combo + cast) + 1 and cooldown then
			APB.combobar[i]:SetStatusBarColor(0.3, 0.3, 0.3);
			APB.combobar[i].start = p_start;
			APB.combobar[i].duration = cooldown;
			APB.combobar[i]:SetScript("OnUpdate", APB_OnUpdateCombo)
		else
			APB.combobar[i]:Show();
			APB.combobar[i]:SetValue(0)

		end
	end

	if bupdate_partial_power then
		local power = combo + partial;
		if power > max_combo then
			power = max_combo;
		end
		APB.combobar[1].text:SetText(power);
		APB.combobar[1].text:ClearAllPoints();
		APB.combobar[1].text:SetPoint("CENTER", APB.combobar[math.ceil(max_combo/2)], "CENTER", 0, 0);
		APB.combobar[1].text:Show();
	end
end

local function APB_UpdateBuffCombo(combobar)

	if not (APB_BUFF_COMBO or APB_DEBUFF_COMBO) then
		return;
	end

	if not bupdate_buff_combo then
		return;
	end

	if APB_BUFF_COMBO then

		local name, icon, count, debuffType, duration, expirationTime, caster, isStealable, shouldConsolidate, spellId = APB_UnitBuff(combobar.unit, APB_BUFF_COMBO, "player");

		if name and caster == "player" then
			APB_ShowComboBar(count);
		else
			APB_ShowComboBar(0);
		end
	end


	if APB_DEBUFF_COMBO then

		local name, icon, count, debuffType, duration, expirationTime, caster, isStealable, shouldConsolidate, spellId = APB_UnitDebuff(combobar.unit, APB_DEBUFF_COMBO, "player");

		if name and caster == "player" then
			APB_ShowComboBar(count);
		else
			APB_ShowComboBar(0);
		end
	end

end


local curr_gcd = 0;

local function APB_OnUpdateBuff(self, elapsed)

	if not self.start then
		return;
	end

	if not self.update  then
		self.update = 0;
	end

	self.update = self.update + elapsed

	if self.update >= 0.1 and self.start  then
		local curr_time = GetTime();
		local curr_duration = curr_time - self.start;

		self.update = 0

		if curr_duration < self.duration then

			local remain_buff = (self.duration + self.start - curr_time)
			local start, gcd  = GetSpellCooldown(61304);

			if gcd > 0 then
				curr_gcd = gcd;
			end

			self:SetMinMaxValues(0, self.duration * 1000)
			self:SetValue( remain_buff * 1000)
			self.text:SetText(("%02.1f"):format(self.duration + self.start - curr_time))

			if self.buff then
				if curr_gcd and remain_buff < curr_gcd * 2 then
					self:SetStatusBarColor(1, 0, 1);
				else
					self:SetStatusBarColor(0.8, 0.8, 1);
				end
			end
		end
	end
end


local function APB_UpdateBuff(buffbar)

	if not (buffbar.buff or buffbar.debuff) then
		return;
	end


	if buffbar.buff then

		local name,  icon, count, debuffType, duration, expirationTime, caster, isStealable, shouldConsolidate, spellId = APB_UnitBuff(buffbar.unit, buffbar.buff, "player");

		if name and caster == "player" then
			buffbar.start = expirationTime - duration;
			buffbar.duration = duration;
			if bupdate_buff_count then
				buffbar.count:SetText(count);
			end
		else
			buffbar.start = nil;
			buffbar:SetMinMaxValues(0, 1)
			buffbar:SetValue(0)
			buffbar.text:SetText("");
			buffbar.count:SetText("");
		end

		--buffbar:SetStatusBarColor(0.8, 0.8, 1);

		buffbar:Show();
		buffbar.text:Show();
		buffbar.count:Show();

		buffbar.tooltip = buffbar.buff;
	end

	if buffbar.debuff then

		local name, icon, count, debuffType, duration, expirationTime, caster, isStealable, shouldConsolidate, spellId = APB_UnitDebuff_Name(buffbar.unit, buffbar.debuff);

		if name and caster == "player" then
			buffbar.start = expirationTime - duration;
			buffbar.duration = duration;
			if bupdate_buff_count then
				buffbar.count:SetText(count);
			end
		else
			buffbar.start = nil;
			buffbar:SetMinMaxValues(0, 1)
			buffbar:SetValue(0)
			buffbar.text:SetText("");
			buffbar.count:SetText("");
		end

		buffbar:SetStatusBarColor(1, 0.9, 0.9);

		buffbar:Show();
		buffbar.text:Show();
		buffbar.count:Show();
		buffbar.tooltip = buffbar.debuff;
	end

	if buffbar.start then
		buffbar:SetScript("OnUpdate", APB_OnUpdateBuff)
	else
		buffbar:SetScript("OnUpdate", nil)

		for i = 1, 10 do
			APB.buffbar[0].square[i]:Hide();
		end
		if not bupdate_power and not bupdate_rune and not bupdate_spell then
			buffbar:Hide();
		end
	end

end




local function APB_UpdateStagger(self)
	if bupdate_stagger then
		local val = UnitStagger("player");
		local valmax = UnitHealthMax("player");

		if val == nil then
			return
		end

		local stagger = math.ceil(val/valmax * 100);

		local info = PowerBarColor["STAGGER"];


		if (stagger > 100) then
			stagger = 100
		end

		self:SetMinMaxValues(0, 100)
		self:SetValue(stagger)
		self.text:SetText(stagger);
		self.count:SetText("");


		if (stagger > 30 and stagger < 60) then
			info = info[2];
		elseif (stagger > 60) then
			info = info[3];
		else
			info = info[1];
		end

		self:SetStatusBarColor(info.r, info.g, info.b);
		self:Show();
		self.tooltip = "STAGGER";
	end

end

local FrozenOrbTime = nil;
local FrozenOrbDuration = 10;

local function APB_UpdateFronzenOrb(self)
	if bupdate_fronzen then
		local start = FrozenOrbTime;
		local currtime = GetTime();
		local duration = 0;

		if start ~= nil and currtime - start <= 10 then
			duration = FrozenOrbDuration;
		else
			duration = 0;
		end

		if duration > 0 then
			self.start = start;
			self.duration = duration;
			self:SetScript("OnUpdate", APB_OnUpdateBuff)
		else
			self:SetMinMaxValues(0, 1)
			self:SetValue(0)
			self.text:SetText("");
			self.start = 0;
			self.duraton = duration;
			self:SetScript("OnUpdate", nil)
		end
		self.count:SetText("");
		self:Show();
		self.tooltip = "FrozenOrbTime";
	end

end


local function APB_MaxCombo(max)

	max_combo = max;

	if not max or  max == 0 then
		for i = 1, 10 do
			APB.combobar[i]:Hide();
		end
		return;
	end

	local width = (APB_WIDTH - (3 *(max - 1)))/max;

	for i = 1, 10 do
		APB.combobar[i]:SetWidth(width)
		APB.combobar[i].start = nil;
		APB.combobar[i]:SetMinMaxValues(0, 1)
		APB.combobar[i]:SetValue(1)
		local _, Class = UnitClass("player")
		local color =RAID_CLASS_COLORS[Class]
		APB.combobar[i]:SetStatusBarColor(color.r, color.g, color.b);
		APB.combobar[i]:SetScript("OnUpdate", nil)

		if i > max then
			APB.combobar[i]:Hide()
		else
			APB.combobar[i]:Show()
		end
	end
end

local function APB_MaxRune()

	local max = 6;
	local width = (APB_WIDTH - (3 *(max - 1)))/max;


	for i = 1, 10 do
		APB.combobar[i]:Hide();
	end


	for i = 1, 6 do
		APB.combobar[i]:SetWidth(width)
		APB.combobar[i]:Show();
	end


end

local function RuneComparison(runeAIndex, runeBIndex)
	local runeAStart, runeADuration, runeARuneReady = GetRuneCooldown(runeAIndex);
	local runeBStart, runeBDuration, runeBRuneReady = GetRuneCooldown(runeBIndex);

	if (runeARuneReady ~= runeBRuneReady) then
		return runeARuneReady;
	end

	if (runeAStart ~= runeBStart) then
		return runeAStart < runeBStart;
	end

	return runeAIndex < runeBIndex;
end



local function APB_UpdateRune()

	table.sort(APB.runeIndexes, RuneComparison);

	for i, index in ipairs(APB.runeIndexes) do

		local start, duration, runeReady = GetRuneCooldown(index);

		if runeReady then
			APB.combobar[i].start = nil;
			--APB.combobar[i2]:SetStatusBarColor(1,1,0)

			local _, Class = UnitClass("player")
			local color =RAID_CLASS_COLORS[Class]
			APB.combobar[i]:SetStatusBarColor(color.r, color.g, color.b);

			APB.combobar[i]:SetMinMaxValues(0, 1)
			APB.combobar[i]:SetValue(1)
			APB.combobar[i]:SetScript("OnUpdate", nil)
		else
			APB.combobar[i]:SetStatusBarColor(1,1,1)
			APB.combobar[i].start = start;
			APB.combobar[i].duration = duration;
			APB.combobar[i]:SetScript("OnUpdate", APB_OnUpdateCombo)


		end
	end
end


local function APB_UpdatePower()

	if bupdate_power == false then
		return;
	end

	local power = UnitPower("player", APB_POWER_LEVEL);
	local max = UnitPowerMax("player", APB_POWER_LEVEL);

	local partial = nil;

	if bupdate_partial_power then
		_, partial = math.modf(UnitPower("player", APB_POWER_LEVEL, true) / UnitPowerDisplayMod(APB_POWER_LEVEL));
	end

	local cooldownDuration = nil;
	if APB_UNIT_POWER == "POWER_TYPE_ESSENCE" then
		local peace,interrupted = GetPowerRegenForPowerType(Enum.PowerType.Essence)
		if (peace == nil or peace == 0) then
			peace = 0.2;
		end
		cooldownDuration = 1 / peace;
	end


	if (APB.powermax and APB.powermax ~= max) or not APB.powermax then
		APB_MaxCombo(max);
		APB.powermax = max;
	end

	local _, _, _, startTime, endTime, isTradeSkill, castID, notInterruptible, spellID = UnitCastingInfo("player");
	local cast = nil;

	if spellID then
		local costTable = GetSpellPowerCost(spellID);

		for _, costInfo in pairs(costTable) do
			if (costInfo.type == APB_POWER_LEVEL) then
				cast = costInfo.cost;
				break;
			end
		end

		if cast == nil then
			cast = asGetPowerCostTooltipInfo(spellID);
		end
	end

	APB_ShowComboBar(power, partial, cast, cooldownDuration);

end

local bupdate_druid = false;

local function APB_GetActionSlot(arg1)
	local lActionSlot = 0;

	for lActionSlot = 1, 120 do
		local type, id, subType, spellID = GetActionInfo(lActionSlot);

		if id and type and type == "macro" then
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

local function APB_SpellMax(spell, spell2)

	local _, maxCharges = GetSpellCharges(spell);

	if bupdate_druid then
		maxCharges = 2;
	end

	if spell2 then
		local _, maxCharges2 = GetSpellCharges(spell2);

		if bupdate_druid then
			maxCharges2 = 2;
		end

		if maxCharges2 then
			maxCharges = maxCharges + maxCharges2
		end

	end


	if maxCharges and  maxCharges > 0 then
		APB_MaxCombo(maxCharges);
	else
		APB_MaxCombo(0);
	end


end

local function setupMouseOver(frame)

	frame.spellid = nil;
	frame.tooltip = nil;

	if not frame:GetScript("OnEnter") then
		frame:SetScript("OnEnter", function(s)
			if s.spellid and s.spellid > 0 then
				GameTooltip_SetDefaultAnchor(GameTooltip, s);
				GameTooltip:SetSpellByID(s.spellid);
			elseif s.tooltip then
				GameTooltip_SetDefaultAnchor(GameTooltip, s);
				GameTooltip:SetText(s.tooltip);
			end
		end)
		frame:SetScript("OnLeave", function()
			GameTooltip:Hide();
		end)
	end

end

local function APB_UpdateSpell(spell, spell2)

	local charges, maxCharges, chargeStart, chargeDuration = GetSpellCharges(spell);
	local spellid = select(7, GetSpellInfo(spell));

	if bupdate_druid then
		local slot = APB_GetActionSlot(spell);
		if slot then
			charges= GetActionCount(slot);
			maxCharges = 2;
			chargeStart = 0;
			chargeDuration = 0;
		end
	end

	if not maxCharges then
		return;
	end
	for i = 1, charges do
		APB.combobar[i].start = nil;
	--	APB.combobar[i]:SetStatusBarColor(1,1,0)
		local _, Class = UnitClass("player")
		local color =RAID_CLASS_COLORS[Class]
		APB.combobar[i]:SetStatusBarColor(color.r, color.g, color.b);

		APB.combobar[i]:SetMinMaxValues(0, 1)
		APB.combobar[i]:SetValue(1)
		APB.combobar[i]:SetScript("OnUpdate", nil)


		if balert then
			APB.combobar[i]:SetStatusBarColor(0,1,0)
		end

		APB.combobar[i].spellid = spellid;		
	end

	if charges < maxCharges then
		APB.combobar[charges + 1]:SetStatusBarColor(1,1,1)
		APB.combobar[charges + 1].start = chargeStart;
		APB.combobar[charges + 1].duration = chargeDuration;
		APB.combobar[charges + 1]:SetScript("OnUpdate", APB_OnUpdateCombo)

		if balert then
			APB.combobar[charges + 1]:SetStatusBarColor(0,1,1)
		end

		APB.combobar[charges + 1].spellid = spellid;
	end

	if charges < maxCharges - 1 then
		for i = charges + 2, maxCharges do
			APB.combobar[i]:SetValue(0)
			APB.combobar[i].start = nil;
			APB.combobar[i]:SetScript("OnUpdate", nil)
			
		end
	end

	if spell2 then
		local charges, maxCharges2, chargeStart, chargeDuration = GetSpellCharges(spell2);
		spellid = select(7, GetSpellInfo(spell2));

		if not maxCharges2 then
			local slot = APB_GetActionSlot(spell2);
			if slot then
				charges= GetActionCount(slot);
				maxCharges2 = 2;
				chargeStart = 0;
				chargeDuration = 0;
			end

			if not maxCharges2 then
				return;
			end
		end


		for i = maxCharges + 1, maxCharges + charges do
			APB.combobar[i].start = nil;
			APB.combobar[i]:SetStatusBarColor(1, 0.7, 0.3);

			APB.combobar[i]:SetMinMaxValues(0, 1)
			APB.combobar[i]:SetValue(1)
			APB.combobar[i]:SetScript("OnUpdate", nil)
			APB.combobar[i].spellid = spellid;		
			
			if balert2 then
				APB.combobar[i]:SetStatusBarColor(0,1,1)
			end
		end

		if charges < maxCharges2 then
			APB.combobar[maxCharges + charges + 1]:SetStatusBarColor(0.5,0.5,0.5)
			APB.combobar[maxCharges + charges + 1].start = chargeStart;
			APB.combobar[maxCharges + charges + 1].duration = chargeDuration;
			APB.combobar[maxCharges + charges + 1]:SetScript("OnUpdate", APB_OnUpdateCombo)

			APB.combobar[maxCharges + charges + 1].spellid = spellid;			
		end

		if charges < maxCharges2 - 1 then
			for i = maxCharges + charges + 2, maxCharges + maxCharges2 do
				APB.combobar[i]:SetValue(0)
				APB.combobar[i].start = nil;
				APB.combobar[i]:SetScript("OnUpdate", nil)

			end
		end
	end
end

local APB_MAX_INCOMING_HEAL_OVERFLOW = 1.2;

local function APB_HealColor(value)

	local r, g, b;
	local min, max = 0, 100 * APB_MAX_INCOMING_HEAL_OVERFLOW;

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



local function APB_Update(self)
	local valuePct;
	local valuePct_orig;

	if not bupdate_powerbar then
		APB.bar:Hide();
	else
		local powerType, powerTypeString = UnitPowerType("player");

		self.powerType = powerType

		local value = UnitPower("player", powerType);
		local valueMax = UnitPowerMax("player", powerType);
		local value_orig = value;

		if self.predictedPowerCost and  self.predictedPowerCost  > 0  then
			value = value - self.predictedPowerCost;
		end


		if (powerType == Enum.PowerType.Mana ) then
			valuePct =  (math.ceil((value / valueMax) * 100));
			valuePct_orig = (math.ceil((value_orig / valueMax) * 100));

		else
			valuePct = value;
			valuePct_orig = value_orig
		end

		if powerTypeString then
			local info = PowerBarColor[powerTypeString];
			APB.bar:SetStatusBarColor(info.r, info.g, info.b);
			--APB.bg:SetVertexColor(info.r, info.g, info.b);
		end

		APB.bar:SetMinMaxValues(0, valueMax)
		APB.bar:SetValue(value)


		if bshow_haste then
			local haste = UnitSpellHaste("player")
			APB.bar.count:SetText(format("%d%%", haste + 0.5));
		end

		if self.predictedPowerCost and  not (self.predictedPowerCost == 0) then

			if  self.predictedPowerCost < 0 then

				if (powerType == Enum.PowerType.Mana ) then
					valuePct =  (math.ceil(((value - self.predictedPowerCost) / valueMax) * 100));
				else
					valuePct =  (math.ceil(((value - self.predictedPowerCost))));
				end

				APB.bar.text:SetText(valuePct_orig.. "(" ..valuePct ..")");
			else
				APB.bar.text:SetText(valuePct_orig.. "(" ..valuePct ..")");
			end
		else
			APB.bar.text:SetText(valuePct);
		end

	end


	if not bupdate_healthbar then
		APB.healthbar:Hide();
	else
		local value = UnitHealth("player");
		local valueMax = UnitHealthMax("player");
		local value_orig = value;


		local allIncomingHeal = UnitGetIncomingHeals("player") or 0;
		local totalAbsorb = UnitGetTotalAbsorbs("player") or 0;
		local total = allIncomingHeal + totalAbsorb;

		valuePct =  (math.ceil((value / valueMax) * 100));
		valuePct_orig = (math.ceil((value_orig / valueMax) * 100));
		local valuePctAbsorb = (math.ceil((total / valueMax) * 100));

		APB.healthbar:SetMinMaxValues(0, valueMax)
		APB.healthbar:SetValue(value)

		local r,g,b;

		r,g,b = APB_HealColor(valuePct);

		APB.healthbar:SetStatusBarColor(r, g, b);


		if valuePctAbsorb > 0 then
			APB.healthbar.text:SetText(valuePct.. "(" ..valuePctAbsorb ..")");
		else
			APB.healthbar.text:SetText(valuePct);
		end

	end

end


local update = 0;
local update2 = 0;

local function APB_OnUpdate(self, elapsed)

	update = update + elapsed
	update2 = update2 + elapsed

	if update >= 0.1  then
		update = 0
		APB_Update(self)
	end

	if update2 >= 0.5  then
		update2 = 0
		APB_UpdateBuff(self.buffbar[0]);
		APB_UpdateBuffCombo(self.combobar);
		APB_UpdateStagger(self.buffbar[0]);
		APB_UpdatePower();
	end

end



local function APB_InitPowerBar(self)

	self:RegisterUnitEvent("UNIT_SPELLCAST_START", "player");
	self:RegisterUnitEvent("UNIT_SPELLCAST_STOP", "player");
	self:RegisterUnitEvent("UNIT_SPELLCAST_FAILED", "player");
	self:RegisterUnitEvent("UNIT_SPELLCAST_SUCCEEDED", "player");

end

local function asCheckTalent (name)

	local specID = PlayerUtil.GetCurrentSpecID();

    local configID = C_ClassTalents.GetActiveConfigID();

	if not (configID) then
		return false;
	end

	C_ClassTalents.LoadConfig(configID, true);
    local configInfo = C_Traits.GetConfigInfo(configID);
    local treeID = configInfo.treeIDs[1];

    local nodes = C_Traits.GetTreeNodes(treeID);

    for _, nodeID in ipairs(nodes) do
        local nodeInfo = C_Traits.GetNodeInfo(configID, nodeID);
        if nodeInfo.currentRank and nodeInfo.currentRank > 0 then
            local entryID = nodeInfo.activeEntry and nodeInfo.activeEntry.entryID and nodeInfo.activeEntry.entryID;
            local entryInfo = entryID and C_Traits.GetEntryInfo(configID, entryID);
            local definitionInfo = entryInfo and entryInfo.definitionID and C_Traits.GetDefinitionInfo(entryInfo.definitionID);

            if definitionInfo ~= nil then
                local talentName = TalentUtil.GetTalentName(definitionInfo.overrideName, definitionInfo.spellID);
				--print(string.format("%s %d/%d", talentName, nodeInfo.currentRank, nodeInfo.maxRanks));
				if name == talentName then
					return true;
				end
            end
        end
    end

	return false;
end

local function APB_CheckPower(self)

	self = APB;
	local localizedClass, englishClass = UnitClass("player")
	local spec = GetSpecialization();
	local talentgroup = GetActiveSpecGroup();

	APB:UnregisterEvent("UNIT_POWER_UPDATE")
	APB:UnregisterEvent("UNIT_DISPLAYPOWER");
	APB:UnregisterEvent("UPDATE_SHAPESHIFT_FORM");
	APB:UnregisterEvent("RUNE_POWER_UPDATE");
	APB:UnregisterEvent("UNIT_AURA");
	APB:UnregisterEvent("UNIT_SPELLCAST_START");
	APB:UnregisterEvent("UNIT_SPELLCAST_STOP");
	APB:UnregisterEvent("UNIT_SPELLCAST_FAILED");
	APB:UnregisterEvent("UNIT_SPELLCAST_SUCCEEDED");
	APB:UnregisterEvent("PLAYER_TARGET_CHANGED");
	APB:UnregisterEvent("COMBAT_LOG_EVENT_UNFILTERED")



	APB:SetScript("OnUpdate", nil);



	bupdate_power = false;
	bupdate_rune = false;
	bupdate_spell = false;
	bupdate_buff_count = false;
	bshow_haste = false;
	bupdate_powerbar = true;
	bupdate_buff_combo = false;
	bupdate_stagger = false;
	bupdate_fronzen = false;
	bupdate_windrunner = false;
	bupdate_partial_power = false;
	bsmall_power_bar = false;

	APB_BUFF = nil;
	APB_BUFF2 = nil;
	APB_DEBUFF = nil;
	APB_DEBUFF2 = nil;
	APB_SPELL = nil;
	APB_SPELL2 = nil;
	APB_UNIT_POWER = nil;
	APB_POWER_LEVEL = nil;
	APB_BUFF_COMBO = nil;
	APB_DEBUFF_COMBO = nil


	APB.bar:Hide();
	APB.bar.text:SetText("");
	APB.bar.count:SetText("");
	setupMouseOver(APB.bar);

	APB.combobar[1].text:SetText("");
	APB.combobar[1].text:Hide();

	for i = 1, 10 do		
		setupMouseOver(APB.combobar[i]);
	end

	for j = 0, 1 do
		APB.buffbar[j]:Hide();
		APB.buffbar[j].text:SetText("");
		APB.buffbar[j].count:SetText("");
		APB.buffbar[j].cast:Hide();
		APB.powermax = nil;

		for i = 1, 10 do
			APB.buffbar[j].square[i]:Hide();
		end

		APB.buffbar[j].buff = nil;
		APB.buffbar[j].debuff = nil;

		setupMouseOver(APB.buffbar[j]);

	end	

	if (englishClass == "EVOKER") then
		--기원사
		APB_UNIT_POWER = "POWER_TYPE_ESSENCE";
		APB_POWER_LEVEL = Enum.PowerType.Essence;
		APB:RegisterUnitEvent("UNIT_POWER_UPDATE", "player");
		APB:RegisterUnitEvent("UNIT_DISPLAYPOWER", "player");
		bupdate_power = true;
	end

	if (englishClass == "PALADIN") then

		APB_UNIT_POWER = "HOLY_POWER";
		APB_POWER_LEVEL = Enum.PowerType.HolyPower;
		APB:RegisterUnitEvent("UNIT_POWER_UPDATE", "player");
		APB:RegisterUnitEvent("UNIT_DISPLAYPOWER", "player");
		bupdate_power = true;

		if (spec and spec == 2) then

			bsmall_power_bar = true;

			APB_BUFF = "정의의 방패";
			APB.buffbar[0].buff = "정의의 방패"
			APB_SPELL = "정의의 방패";
			APB_SpellMax(APB_SPELL);
			APB_UpdateSpell(APB_SPELL);
			bupdate_spell = true;
			APB:RegisterUnitEvent("UNIT_AURA", "player");
			--APB:SetScript("OnUpdate", APB_OnUpdate);

			APB.buffbar[0].unit = "player"

			bsmall_power_bar = true;
			APB_UpdateBuff(self.buffbar[0])

		end

		if (spec and spec == 3) then
			bsmall_power_bar = true;
		end
	end

	if (englishClass == "MAGE") then
		if (spec and spec == 1) then
			APB_UNIT_POWER = "ARCANE_CHARGES"
			APB_POWER_LEVEL = Enum.PowerType.ArcaneCharges
			APB:RegisterUnitEvent("UNIT_POWER_UPDATE", "player")
			APB:RegisterUnitEvent("UNIT_DISPLAYPOWER", "player");
			bupdate_power = true;

			for i = 1, 10 do		
				APB.combobar[i].tooltip = "ARCANE_CHARGES";				
			end

		end

		if (spec and spec == 2) then
			if (asCheckTalent("화상의 자극")) then
				APB_BUFF = "화상의 자극";
				APB.buffbar[0].buff = "화상의 자극"
				APB.buffbar[0].unit = "player";
				APB:RegisterUnitEvent("UNIT_AURA", "player");
				bupdate_buff_count = true;
				APB_UpdateBuff(self.buffbar[0])

			elseif (asCheckTalent("불꽃정신")) then
				APB_BUFF = "불꽃정신";
				APB.buffbar[0].buff = "불꽃정신"
				APB.buffbar[0].unit = "player"
				APB:RegisterUnitEvent("UNIT_AURA", "player");
				bupdate_buff_count = true;
				APB_UpdateBuff(self.buffbar[0]);
			end

			APB_SPELL = "화염 작렬";

			if asCheckTalent("불사조의 불길") then
				APB_SPELL2 = "불사조의 불길"
				APB_SpellMax(APB_SPELL, APB_SPELL2);
				APB_UpdateSpell(APB_SPELL, APB_SPELL2);
			else
				APB_SpellMax(APB_SPELL);
				APB_UpdateSpell(APB_SPELL);
			end

			bupdate_spell = true;
			bsmall_power_bar = true;
		end

		if (spec and spec == 3 ) then

			APB_BUFF_COMBO = "고드름";
			APB_MaxCombo(5);
			APB.combobar.unit = "player"
			APB:RegisterUnitEvent("UNIT_AURA", "player");
			APB_UpdateBuffCombo(self.combobar)
			bupdate_buff_combo = true;

			for i = 1, 10 do		
				APB.combobar[i].tooltip = "고드름";				
			end

			FrozenOrbDuration = 10;
			if asCheckTalent("영원한 서리") then
				FrozenOrbDuration = 12;
			end

			bupdate_fronzen = true;
			APB:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")

			bsmall_power_bar = true;
		end

	end


	if (englishClass == "WARLOCK") then
		APB_UNIT_POWER = "SOUL_SHARDS"
		APB_POWER_LEVEL = Enum.PowerType.SoulShards
		APB:RegisterUnitEvent("UNIT_POWER_UPDATE", "player")
		APB:RegisterUnitEvent("UNIT_DISPLAYPOWER", "player");
		bupdate_power = true;

		for i = 1, 10 do		
			APB.combobar[i].tooltip = "SOUL_SHARDS";				
		end

		if (spec and spec == 3) then
			if asCheckTalent("불확실성 역전") then
				APB_BUFF = "불확실성 역전";
				APB.buffbar[0].buff = "불확실성 역전"
				APB.buffbar[0].unit = "player"
				APB:RegisterUnitEvent("UNIT_AURA", "player");
				APB_UpdateBuff(self.buffbar[0]);
			end
			bupdate_partial_power = true;
		end

		bsmall_power_bar = true;

	end

	if (englishClass == "DRUID") then
		bupdate_druid = false;

		if (spec and spec == 1) then
			APB_BUFF = "일월식 (달)";
			APB.buffbar[0].buff = "일월식 (달)"
			APB.buffbar[0].unit = "player"
			APB:RegisterUnitEvent("UNIT_AURA", "player");
			APB_UpdateBuff(self.buffbar[0]);

			APB_BUFF2 = "일월식 (태양)";
			APB.buffbar[1].buff = "일월식 (태양)"
			APB.buffbar[1].unit = "player"
			APB:RegisterUnitEvent("UNIT_AURA", "player");
			APB_UpdateBuff(self.buffbar[1]);

			APB_SPELL = "별빛섬광";
			APB_SPELL2 = "천벌"
			bupdate_druid = true;
			APB_SpellMax(APB_SPELL, APB_SPELL2);
			APB_UpdateSpell(APB_SPELL, APB_SPELL2);

			bupdate_spell = true;



		end


		if (spec and spec == 2) then

			APB_UNIT_POWER = "COMBO_POINTS"
			APB_POWER_LEVEL = Enum.PowerType.ComboPoints
			APB:RegisterUnitEvent("UNIT_POWER_UPDATE", "player")
			APB:RegisterUnitEvent("UNIT_DISPLAYPOWER", "player");
			APB:RegisterEvent("UPDATE_SHAPESHIFT_FORM");
			bupdate_power = true;

			for i = 1, 10 do		
				APB.combobar[i].tooltip = "COMBO_POINTS";				
			end
		end

		if (spec and spec == 3) then
			APB_BUFF = "무쇠가죽";
			APB.buffbar[0].buff = "무쇠가죽"
			APB.buffbar[0].unit = "player"
			APB:RegisterUnitEvent("UNIT_AURA", "player");
			bupdate_buff_count = true;

			APB_UpdateBuff(self.buffbar[0]);
		end
	end

	if (englishClass == "MONK") then

		if (spec and spec == 1) then
			bupdate_stagger = true;
			APB_UpdateStagger(self.buffbar[0]);
		end


		if (spec and spec == 3) then
			APB_UNIT_POWER = "CHI"
			APB_POWER_LEVEL = Enum.PowerType.Chi
			APB:RegisterUnitEvent("UNIT_POWER_UPDATE", "player")
			APB:RegisterUnitEvent("UNIT_DISPLAYPOWER", "player");
			bupdate_power = true;
		end
	end

	if (englishClass == "ROGUE") then
		APB_UNIT_POWER = "COMBO_POINTS"
		APB_POWER_LEVEL = Enum.PowerType.ComboPoints
		APB:RegisterUnitEvent("UNIT_POWER_UPDATE", "player")
		APB:RegisterUnitEvent("UNIT_DISPLAYPOWER", "player");
		bupdate_power = true;

		for i = 1, 10 do		
			APB.combobar[i].tooltip = "COMBO_POINTS";				
		end

		APB_BUFF = "난도질";
		APB.buffbar[0].buff = "난도질";
		APB.buffbar[0].unit = "player"
		APB:RegisterUnitEvent("UNIT_AURA", "player");
		APB_UpdateBuff(self.buffbar[0])
	end

	if (englishClass == "DEATHKNIGHT") then
		APB_MaxRune();
		APB_UpdateRune()
		APB:RegisterEvent("RUNE_POWER_UPDATE")
		bupdate_rune = true;

		for i = 1, 10 do		
			APB.combobar[i].tooltip = "RUNE_POWER";				
		end


		if (spec and spec == 1) then
			APB_BUFF = "뼈의 보호막";
			APB.buffbar[0].buff = "뼈의 보호막";
			APB.buffbar[0].unit = "player"
			APB:RegisterUnitEvent("UNIT_AURA", "player");
			bupdate_buff_count = true;
			APB_UpdateBuff(self.buffbar[0]);

		end



	end

	if (englishClass == "PRIEST") then
		if (spec and spec == 3) then
			APB_SPELL = "정신 분열";
			APB_SpellMax(APB_SPELL);
			APB_UpdateSpell(APB_SPELL);
			bupdate_spell = true;
			APB_DEBUFF = "파멸의 역병";
			APB.buffbar[0].debuff = "파멸의 역병"
			APB.buffbar[0].unit = "target";
			APB:SetScript("OnUpdate", APB_OnUpdate);
		end
	end

	if (englishClass == "WARRIOR") then
		if (spec and spec == 1) then
			APB_SPELL = "제압";
			APB_SpellMax(APB_SPELL);
			APB_UpdateSpell(APB_SPELL);
			bupdate_spell = true;
			APB_DEBUFF = "거인의 강타";
			APB.buffbar[0].debuff = "거인의 강타"
			APB.buffbar[0].unit = "target";
			APB:SetScript("OnUpdate", APB_OnUpdate);

			APB:RegisterEvent("PLAYER_TARGET_CHANGED");
			APB_UpdateBuff(self.buffbar[0])
		end

		if (spec and spec == 2) then
			APB_BUFF = "격노";
			APB.buffbar[0].buff = "격노";
			APB.buffbar[0].unit = "player"
			APB:RegisterUnitEvent("UNIT_AURA", "player");
			--APB:SetScript("OnUpdate", APB_OnUpdate);
			APB_UpdateBuff(self.buffbar[0]);


			if asCheckTalent("소용돌이 연마") then
				APB_BUFF_COMBO = "소용돌이";

				if asCheckTalent("고기칼") then
					APB_MaxCombo(4);
				else
					APB_MaxCombo(2);
				end
				APB.combobar.unit = "player"
				APB_UpdateBuffCombo(self.combobar)
				bupdate_buff_combo = true;
			end

		end

		if (spec and spec == 3) then
			APB_SPELL = "방패 올리기";
			APB_SpellMax(APB_SPELL);
			APB_UpdateSpell(APB_SPELL);
			bupdate_spell = true;
			APB_BUFF = "방패 올리기";
			APB.buffbar[0].buff = "방패 올리기"
			APB.buffbar[0].unit = "player"
			APB:RegisterUnitEvent("UNIT_AURA", "player");
			--APB:SetScript("OnUpdate", APB_OnUpdate);

			APB_UpdateBuff(self.buffbar[0])

		end


	end


	if (englishClass == "DEMONHUNTER") then

		if (spec and spec == 1) then

			if asCheckTalent("탄력") then
				APB_BUFF = "탄력";
				APB.buffbar[0].buff = "탄력";
				APB.buffbar[0].unit = "player"
				APB:RegisterUnitEvent("UNIT_AURA", "player");
				--APB:SetScript("OnUpdate", APB_OnUpdate);

				APB_UpdateBuff(self.buffbar[0])
			end

			APB_SPELL = "지옥 돌진";
			APB_SpellMax(APB_SPELL);
			APB_UpdateSpell(APB_SPELL);
			bupdate_spell = true;

		end


		if (spec and spec == 2) then
			APB_SPELL = "악마 쐐기";
			APB_SpellMax(APB_SPELL);
			APB_UpdateSpell(APB_SPELL);
			bupdate_spell = true;
			APB_BUFF = "악마 쐐기";
			APB.buffbar[0].buff = "악마 쐐기";
			APB.buffbar[0].unit = "player"
			APB:RegisterUnitEvent("UNIT_AURA", "player");
			--APB:SetScript("OnUpdate", APB_OnUpdate);

			APB_UpdateBuff(self.buffbar[0])

		end


	end



	if (englishClass == "HUNTER") then

		if (spec and spec == 1 and asCheckTalent("날카로운 사격") ) then
			APB_SPELL = "날카로운 사격";
			APB_SpellMax(APB_SPELL);
			APB_UpdateSpell(APB_SPELL);
			bupdate_spell = true;

			APB_BUFF = "광기";
			APB.buffbar[0].buff = "광기";
			APB.buffbar[0].unit = "player"
			bupdate_buff_count = true;
			APB:RegisterUnitEvent("UNIT_AURA", "player");
			--APB:SetScript("OnUpdate", APB_OnUpdate);

			APB_UpdateBuff(self.buffbar[0])
		end



		if (spec and spec == 2) then


			APB_SPELL = "조준 사격";
			APB_SpellMax(APB_SPELL);
			APB_UpdateSpell(APB_SPELL);
			bupdate_spell = true;

			if asCheckTalent("교묘한 사격") then
				APB_BUFF = "교묘한 사격";
				APB.buffbar[0].buff = "교묘한 사격";
				APB.buffbar[0].unit = "player"
				APB:RegisterUnitEvent("UNIT_AURA", "player");
				APB_UpdateBuff(self.buffbar[0])
			end

			if asCheckTalent("윈드러너의 인도") then
				bupdate_windrunner = true;
				APB:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
			end
		end


		if (spec and spec == 3 and asCheckTalent("살쾡이의 이빨")) then
			APB_BUFF_COMBO = "살쾡이의 격노";
			APB_MaxCombo(5);
			APB.combobar.unit = "player"
			APB_UpdateBuffCombo(self.combobar)
			bupdate_buff_combo = true;

			for i = 1, 10 do		
				APB.combobar[i].tooltip = "살쾡이의 격노";				
			end

			APB_BUFF = "살쾡이의 격노";
			APB.buffbar[0].buff = "살쾡이의 격노";
			--bupdate_buff_count = true;
			APB.buffbar[0].unit = "player";
			APB:RegisterUnitEvent("UNIT_AURA", "player");
			--APB:SetScript("OnUpdate", APB_OnUpdate);
			APB_UpdateBuff(self.buffbar[0])
		end

	end

	if (englishClass == "SHAMAN") then

		if spec and spec == 2 then
			APB_BUFF_COMBO = "소용돌이치는 무기";
			APB_MaxCombo(10);
			APB.combobar.unit = "player"
			APB:RegisterUnitEvent("UNIT_AURA", "player");
			APB_UpdateBuffCombo(self.combobar)
			bupdate_buff_combo = true;
			bsmall_power_bar = true;

			for i = 1, 10 do		
				APB.combobar[i].tooltip = "소용돌이치는 무기";				
			end
		end

	end



	if not bupdate_power and not bupdate_rune and not bupdate_spell and not bupdate_buff_combo then
		APB_MaxCombo(0);
	end


	if bupdate_healthbar then

		APB.bar:SetHeight(APB_HEIGHT);
		APB.healthbar:SetHeight(APB_HEIGHT);
		APB:SetScript("OnUpdate", APB_OnUpdate);
		APB.healthbar:Show();
		APB.healthbar.text:Show();

	else

		APB.healthbar:SetHeight(0.01);
		APB.healthbar.text:Hide();
		APB.healthbar.count:Hide();
		APB.healthbar:Hide();


	end


	if bupdate_powerbar then
		for i = 1, 10 do
			APB.combobar[i]:SetHeight(APB_HEIGHT * 0.7);
		end

		APB_InitPowerBar(self);
		APB.bar:SetHeight(APB_HEIGHT * 1.5);
		APB:SetScript("OnUpdate", APB_OnUpdate);
		APB.bar:Show();
		APB.bar.text:Show();
	else
		for i = 1, 10 do
			APB.combobar[i]:SetHeight(APB_HEIGHT);
		end

		APB.bar:SetHeight(0.01);
		APB.bar.text:Hide();
		APB.bar.count:Hide();
		APB.bar:Hide();
	end


	if not (APB_BUFF or APB_DEBUFF or bupdate_stagger or bupdate_fronzen) then
		APB.buffbar[0]:SetHeight(0.01);
		APB.buffbar[0].text:Hide();
		APB.buffbar[0].count:Hide();
		APB.buffbar[0]:Hide();
	else
		APB.buffbar[0]:SetHeight(APB_HEIGHT);

		if bupdate_buff_count then
			APB.buffbar[0]:SetHeight(APB_HEIGHT + 2);
		end

		if (APB_BUFF2 or APB_DEBUFF2) then
			APB.buffbar[1]:SetHeight(APB_HEIGHT);
			APB.buffbar[1]:SetWidth(APB_WIDTH/2);
			APB.buffbar[0]:SetWidth(APB_WIDTH/2);
			if bupdate_buff_count then
				APB.buffbar[1]:SetHeight(APB_HEIGHT + 2);
			end
		else
			APB.buffbar[0]:SetWidth(APB_WIDTH);
		end
	end


	if bsmall_power_bar then

		for i = 1, 10 do
			APB.combobar[i]:SetHeight(APB_HEIGHT);
		end

		APB.bar:SetHeight(APB_HEIGHT * 0.5);
		APB.bar.text:Hide();
		--APB.bar.count:Hide();
	end


end



local function asUnitFrameUtil_UpdateFillBarBase(frame, realbar, previousTexture, bar, amount, barOffsetXPercent)
	if not amount or  ( amount == 0 ) then
		bar:Hide();
		return
	end


	local gen = false;


	local barOffsetX = 0;
	if ( barOffsetXPercent ) then
		local realbarSizeX = realbar:GetWidth();
		barOffsetX = realbarSizeX * barOffsetXPercent;
	end

	bar:ClearAllPoints();

		bar:SetPoint("TOPLEFT", previousTexture, "TOPRIGHT", barOffsetX, 0);
		bar:SetPoint("BOTTOMLEFT", previousTexture, "BOTTOMRIGHT", barOffsetX, 0);

		if amount < 0 then
			amount = 0 - amount;
			gen = true;
		end

	local totalWidth, totalHeight = realbar:GetSize();

	local _, totalMax = realbar:GetMinMaxValues();

	local barSize = (amount / totalMax) * totalWidth;
	bar:SetWidth(barSize);
	if gen then
		bar:SetVertexColor(1 , 1, 1)
	else
		bar:SetVertexColor(0.5 , 0.5, 0.5)
	end
	bar:Show();
end

local gpredictedPowerCost = nil;

local function checkSpellCost(id)


	local i = 1

	if id then
		local spell = Spell:CreateFromSpellID(id);
		spell:ContinueOnSpellLoad(function()
			local costText = spell:GetSpellDescription();
			local powerType = UnitPowerType("player");


			if  costText and PowerTypeString[powerType] and string.match(costText,  PowerTypeString[powerType] ) and string.match(costText,  "생성" )   then
				local findstring = "%d의 "..PowerTypeString[powerType];
				local start = string.find(costText, findstring, 0);

				if start and start > 5 then
					local costText2 = string.sub(costText, start-5);
					local s2 = string.find(costText2, findstring, findstring:len() + 5);

					if (s2) and s2 > 5 then
						costText2 = string.sub(costText2, s2-5);
					end

					local cost = gsub(costText2, "[^0-9]", "")
					if tonumber(cost) > 0 then
						SpellGetCosts[id] = tonumber(cost);
					end
				end
			end
		end)

		return;
	end
end



local function checkSpellPowerCost(id)

	local i = 1

	if not APB_POWER_LEVEL then
		return;
	end

	local powerTypeString = PowerTypeComboString[APB_POWER_LEVEL];


	local localizedClass, englishClass = UnitClass("player")
	local spec = GetSpecialization();
	local disWarlock = false;

	if (englishClass == "WARLOCK") then
		if (spec and spec == 3) then
			powerTypeString = "영혼의 조각 파편";
			disWarlock = true;
		end
	end

	if id then
		local spell = Spell:CreateFromSpellID(id);
		spell:ContinueOnSpellLoad(function()
			local costText = spell:GetSpellDescription();

			if  costText and powerTypeString and string.match(costText, powerTypeString ) and string.match(costText,  "생성" )   then
				local findstring = "%d의 "..powerTypeString;
				local start = string.find(costText, findstring, 0);
				if start and start > 10 then
					local costText2 = string.sub(costText, start - 5);
					local cost = gsub(costText2, "[^0-9]", "")
					if tonumber(cost) > 0 then

						if disWarlock then
							SpellGetPowerCosts[id] = tonumber(cost) / 10;
						else
							SpellGetPowerCosts[id] = tonumber(cost);
						end
						return;
					end
				end


				findstring = powerTypeString .. " %d개";
				start = string.find(costText, findstring, 0);
				if start and start > 10 then
					local costText2 = string.sub(costText, start);
					local start2 = string.find(costText2, "합니다.", 0);
					costText2 = string.sub(costText2, 0, start2);
					local cost = gsub(costText2, "[^0-9]", "")
					if tonumber(cost) > 0 then

						if disWarlock then
							SpellGetPowerCosts[id] = tonumber(cost) / 10;
						else
							SpellGetPowerCosts[id] = tonumber(cost);

						end
						return;
					end
				end


			end
		end)

		return;
	end
end




local function asUnitFrameManaCostPredictionBars_Update(frame, isStarting, startTime, endTime, spellID)

	local cost = 0;
	if (not isStarting or startTime == endTime) then
		frame.predictedPowerCost = nil;
		frame.caststart = nil;
		gpredictedPowerCost = nil;
	else
		local costTable = GetSpellPowerCost(spellID);

		for _, costInfo in pairs(costTable) do

			if (costInfo.type == frame.powerType) then
				cost = costInfo.cost;
				break;
			end
		end

		if cost == 0 then
			cost = asGetCostTooltipInfo(spellID);
		end

		frame.predictedPowerCost = cost;
		gpredictedPowerCost = cost;
		frame.caststart = startTime;
		frame.castend = endTime;

	end



	local manaBarTexture = frame.bar:GetStatusBarTexture();
	APB_Update(frame);
	asUnitFrameUtil_UpdateFillBarBase(frame, frame.bar, manaBarTexture, frame.bar.myManaCostPredictionBar, cost);
end





local prev_cast_info = nil;
local windrunner_count = 0;

local function APB_OnEvent(self, event, arg1, arg2, arg3, ...)


	if event == "UNIT_AURA" then
		APB_UpdateBuff(self.buffbar[0]);
		APB_UpdateBuff(self.buffbar[1]);
		APB_UpdateBuffCombo(self.combobar);
		APB_UpdateStagger(self.buffbar[0]);
	elseif event == "ACTIONBAR_UPDATE_COOLDOWN"  or event == "ACTIONBAR_UPDATE_USABLE" then
		if APB_SPELL then
			APB_UpdateSpell(APB_SPELL, APB_SPELL2);
		end
		APB_UpdateFronzenOrb(self.buffbar[0]);
	elseif event == "UNIT_POWER_UPDATE" and arg1 == "player" then
		APB_UpdatePower();
	elseif event == "RUNE_POWER_UPDATE" then
		APB_UpdateRune();
	elseif ( event == "UNIT_SPELLCAST_START" or event == "UNIT_SPELLCAST_STOP" or event == "UNIT_SPELLCAST_FAILED" or event == "UNIT_SPELLCAST_SUCCEEDED" ) and arg1 == "player" then
			local name,  text, texture, startTime, endTime, isTradeSkill, castID, notInterruptible, spellID = UnitCastingInfo(arg1);
			checkSpellCost(spellID);
			checkSpellPowerCost(spellID);
			asUnitFrameManaCostPredictionBars_Update(self, (event == "UNIT_SPELLCAST_START" or not(startTime == endTime)), startTime, endTime, spellID);
			APB_UpdatePower();
			APB_UpdateFronzenOrb(self.buffbar[0]);
	elseif event == "PLAYER_TARGET_CHANGED" then
		APB_UpdateBuff(self.buffbar[0]);
		APB_UpdateBuff(self.buffbar[1]);
		APB_UpdateBuffCombo(self.combobar);
	elseif event == "COMBAT_LOG_EVENT_UNFILTERED" then

		if bupdate_fronzen then
			local timestamp, eventType, _, sourceGUID, _, _, _, destGUID, _, _, _, spellID, _, _, auraType = CombatLogGetCurrentEventInfo();
			if sourceGUID and (sourceGUID == UnitGUID("player")) then
				if (eventType == "SPELL_CAST_SUCCESS") and spellID == FrozenOrbID then
					FrozenOrbTime = nil;
				elseif FrozenOrbTime == nil and  (eventType == "SPELL_DAMAGE") and spellID == FrozenOrbDamageID then
					FrozenOrbTime = GetTime();
				end
			end
		elseif bupdate_windrunner then

			local timestamp, subEvent, _, sourceGUID, _, _, _, destGUID, _, _, _, spellID, _, _, auraType = CombatLogGetCurrentEventInfo();
		    if sourceGUID == UnitGUID("player") and subEvent == "SPELL_DAMAGE" and spellID == 191043 then
        		windrunner_count =  windrunner_count + 1
    		end

    		if sourceGUID == UnitGUID("player") and subEvent == "SPELL_ENERGIZE" and spellID == 406449 then
        		windrunner_count = 0
    		end

    		local textToShow = windrunner_count.."/24";

			APB.combobar[1].text:SetText(textToShow);
			if windrunner_count >= 20 then
				APB.combobar[1].text:SetTextColor(0,1,0);
			else
				APB.combobar[1].text:SetTextColor(1,1,1);
			end
			APB.combobar[1].text:Show();
		end   	

	elseif event == "PLAYER_ENTERING_WORLD" then
		checkSpellCost();
		checkSpellPowerCost();

		if UnitAffectingCombat("player") then
			APB:SetAlpha(APB_ALPHA_COMBAT);
		else
			APB:SetAlpha(APB_ALPHA_NORMAL);
		end

		C_Timer.After(0.5, APB_CheckPower);
		C_Timer.After(0.5, APB_UpdatePower);


	elseif (event == "TRAIT_CONFIG_UPDATED") or (event == "TRAIT_CONFIG_LIST_UPDATED") or event == "ACTIVE_TALENT_GROUP_CHANGED" then
		C_Timer.After(0.5, APB_CheckPower);
		C_Timer.After(0.5, APB_UpdatePower);
	elseif event == "SPELLS_CHANGED" then
		checkSpellCost();
		checkSpellPowerCost();
	elseif event == "UPDATE_SHAPESHIFT_FORM" then
		APB_UpdatePower();
	elseif event == "PLAYER_REGEN_DISABLED" then
		APB:SetAlpha(APB_ALPHA_COMBAT);
	elseif event == "PLAYER_REGEN_ENABLED" then
		APB:SetAlpha(APB_ALPHA_NORMAL);
	elseif event == "UNIT_ENTERING_VEHICLE" then
		APB:SetAlpha(0);
	elseif event == "UNIT_EXITING_VEHICLE" then
		if UnitAffectingCombat("player") then
			APB:SetAlpha(APB_ALPHA_COMBAT);
		else
			APB:SetAlpha(APB_ALPHA_NORMAL);
		end

	elseif event == "SPELL_ACTIVATION_OVERLAY_GLOW_SHOW" then
		local name = GetSpellInfo(arg1);
		if APB_SPELL and  APB_SPELL == name then
			balert = true;
		end

		if APB_SPELL2 and  APB_SPELL2 == name then
			balert2 = true;
		end
		
	elseif event == "SPELL_ACTIVATION_OVERLAY_GLOW_HIDE" then

		local name = GetSpellInfo(arg1);
		if APB_SPELL and  APB_SPELL == name then
			balert = false;
		end
		if APB_SPELL2 and  APB_SPELL2 == name then
			balert2 = false;
		end

	elseif event == "PLAYER_EQUIPMENT_CHANGED" then
		--hast19 = HowManyHasSet(1284);
		--hast20 = HowManyHasSet(1304);
		C_Timer.After(0.5, APB_CheckPower);
		C_Timer.After(0.5, APB_UpdatePower);
	end

	return;
end

do
	APB = CreateFrame("FRAME", nil, UIParent)
	APB:SetPoint("BOTTOM",UIParent,"CENTER", APB_X, APB_Y)
	APB:SetWidth(APB_WIDTH)
	APB:SetHeight(APB_HEIGHT)
	APB:Show();

	APB.bar = CreateFrame("StatusBar", nil, APB)
	APB.bar:SetStatusBarTexture("Interface\\addons\\aspowerbar\\UI-StatusBar.blp", "BORDER")
	APB.bar:GetStatusBarTexture():SetHorizTile(false)
	APB.bar:SetMinMaxValues(0, 100)
	APB.bar:SetValue(100)
	APB.bar:SetWidth(APB_WIDTH)
	APB.bar:SetHeight(APB_HEIGHT)
	APB.bar:SetPoint("BOTTOM",APB,"BOTTOM", 0, 0)
	APB.bar:Hide();

	APB.bar.bg = APB.bar:CreateTexture(nil, "BACKGROUND");
	APB.bar.bg:SetPoint("TOPLEFT", APB.bar, "TOPLEFT", -1, 1);
	APB.bar.bg:SetPoint("BOTTOMRIGHT", APB.bar, "BOTTOMRIGHT", 1, -1);

	APB.bar.bg:SetTexture("Interface\\Addons\\asPowerBar\\border.tga");
	APB.bar.bg:SetTexCoord(0.1,0.1, 0.1,0.1, 0.1,0.1, 0.1,0.1);
	APB.bar.bg:SetVertexColor(0, 0, 0, 0.8);

	APB.bar.text = APB.bar:CreateFontString(nil, "ARTWORK");
	APB.bar.text:SetFont(APB_Font, APB_HealthSize, APB_FontOutline);
	APB.bar.text:SetPoint("CENTER", APB.bar, "CENTER", 0, 0);
	APB.bar.text:SetTextColor(1, 1, 1, 1);

	APB.bar.count = APB.bar:CreateFontString(nil, "ARTWORK");
	APB.bar.count:SetFont(APB_Font, APB_HealthSize, APB_FontOutline);
	APB.bar.count:SetPoint("RIGHT", APB.bar, "RIGHT", -4, 0);
	APB.bar.count:SetTextColor(1, 1, 1, 1);

	APB.bar.myManaCostPredictionBar = APB.bar:CreateTexture(nil, "BORDER" ,"MyManaCostPredictionBarTemplate");
	APB.bar.myManaCostPredictionBar:Hide();

	APB.healthbar = CreateFrame("StatusBar", nil, APB);
	APB.healthbar:SetStatusBarTexture("Interface\\addons\\aspowerbar\\UI-StatusBar.blp", "BORDER")
	APB.healthbar:GetStatusBarTexture():SetHorizTile(false)
	APB.healthbar:SetMinMaxValues(0, 100)
	APB.healthbar:SetValue(100)
	APB.healthbar:SetWidth(APB_WIDTH)
	APB.healthbar:SetHeight(APB_HEIGHT)
	APB.healthbar:SetPoint("BOTTOMLEFT",APB.bar,"TOPLEFT", 0, 1)
	APB.healthbar:Hide();

	APB.healthbar.myManaCostPredictionBar = APB.healthbar:CreateTexture(nil, "BORDER" ,"MyManaCostPredictionBarTemplate")
	APB.healthbar.myManaCostPredictionBar:Hide();

	APB.healthbar.bg = APB.bar:CreateTexture(nil, "BACKGROUND");
	APB.healthbar.bg:SetPoint("TOPLEFT", APB.healthbar, "TOPLEFT", -1, 1);
	APB.healthbar.bg:SetPoint("BOTTOMRIGHT", APB.healthbar, "BOTTOMRIGHT", 1, -1);

	APB.healthbar.bg:SetTexture("Interface\\Addons\\asPowerBar\\border.tga");
	APB.healthbar.bg:SetTexCoord(0.1,0.1, 0.1,0.1, 0.1,0.1, 0.1,0.1);
	APB.healthbar.bg:SetVertexColor(0, 0, 0, 0.8);

	APB.healthbar.text = APB.healthbar:CreateFontString(nil, "ARTWORK");
	APB.healthbar.text:SetFont(APB_Font, APB_HealthSize, APB_FontOutline);
	APB.healthbar.text:SetPoint("CENTER", APB.healthbar, "CENTER", 0, 0);
	APB.healthbar.text:SetTextColor(1, 1, 1, 1)

	APB.healthbar.count = APB.bar:CreateFontString(nil, "ARTWORK");
	APB.healthbar.count:SetFont(APB_Font, APB_HealthSize, APB_FontOutline);
	APB.healthbar.count:SetPoint("RIGHT", APB.bar, "RIGHT", -4, 0);
	APB.healthbar.count:SetTextColor(1, 1, 1, 1);

	APB.buffbar = {};

	for j = 0, 1 do

		APB.buffbar[j] = CreateFrame("StatusBar", nil, APB);
		APB.buffbar[j]:SetStatusBarTexture("Interface\\addons\\aspowerbar\\UI-StatusBar.blp", "BORDER")
		APB.buffbar[j]:GetStatusBarTexture():SetHorizTile(false);
		APB.buffbar[j]:SetMinMaxValues(0, 100);
		APB.buffbar[j]:SetValue(100);
		APB.buffbar[j]:SetHeight(APB_HEIGHT);
		APB.buffbar[j]:SetWidth(APB_WIDTH);

		APB.buffbar[j].bg = APB.buffbar[j]:CreateTexture(nil, "BACKGROUND");
		APB.buffbar[j].bg:SetPoint("TOPLEFT", APB.buffbar[j], "TOPLEFT", -1, 1);
		APB.buffbar[j].bg:SetPoint("BOTTOMRIGHT", APB.buffbar[j], "BOTTOMRIGHT", 1, -1);

		APB.buffbar[j].bg:SetTexture("Interface\\Addons\\asPowerBar\\border.tga");
		APB.buffbar[j].bg:SetTexCoord(0.1,0.1, 0.1,0.1, 0.1,0.1, 0.1,0.1);
		APB.buffbar[j].bg:SetVertexColor(0, 0, 0, 0.8);

		if j == 0 then
			APB.buffbar[j]:SetPoint("BOTTOMLEFT",APB.healthbar,"TOPLEFT", 0, 1);
		else
			APB.buffbar[j]:SetPoint("BOTTOMLEFT",APB.healthbar,"TOP", 0, 1);
		end
		APB.buffbar[j]:Hide();



		APB.buffbar[j].text = APB.buffbar[j]:CreateFontString(nil, "ARTWORK")
		APB.buffbar[j].text:SetFont(APB_Font, APB_BuffSize, APB_FontOutline)
		APB.buffbar[j].text:SetPoint("LEFT", APB.buffbar[j], "LEFT", 5, 0)
		APB.buffbar[j].text:SetTextColor(1, 1, 1, 1)

		APB.buffbar[j].count = APB.buffbar[j]:CreateFontString(nil, "ARTWORK")
		APB.buffbar[j].count:SetFont(APB_Font, APB_BuffSize + 5, APB_FontOutline)
		APB.buffbar[j].count:SetPoint("RIGHT", APB.buffbar[j], "RIGHT", -4, 0)
		APB.buffbar[j].count:SetTextColor(1, 1, 1, 1)

		APB.buffbar[j].cast = APB.buffbar[j]:CreateTexture(nil, "BACKGROUND");
		APB.buffbar[j].cast:SetDrawLayer("ARTWORK", 0);
		APB.buffbar[j].cast:SetTexture("Interface\\Addons\\asPowerBar\\Square_White.tga")
		APB.buffbar[j].cast:SetBlendMode("ALPHAKEY");
		APB.buffbar[j].cast:SetVertexColor(1,1,1,0.3)
		APB.buffbar[j].cast:SetWidth(50);
		APB.buffbar[j].cast:SetHeight((APB.buffbar[j]:GetHeight())/1.5);
		APB.buffbar[j].cast:Hide();

		APB.buffbar[j].square = {};
		for i = 1, 10 do
			APB.buffbar[j].square[i] = APB.buffbar[j]:CreateTexture(nil, "BACKGROUND");
			APB.buffbar[j].square[i]:SetDrawLayer("ARTWORK", 0);
			APB.buffbar[j].square[i]:SetTexture("Interface\\Addons\\asPowerBar\\Square_White.tga")
			APB.buffbar[j].square[i]:SetBlendMode("ALPHAKEY");
			APB.buffbar[j].square[i]:SetVertexColor(1,1,1,1)
			APB.buffbar[j].square[i]:SetWidth(3);
			APB.buffbar[j].square[i]:SetHeight(APB.buffbar[j]:GetHeight()-1);
			APB.buffbar[j].square[i]:Hide();
		end
	end

	APB.combobar = {};
	APB.runeIndexes = {1, 2, 3, 4, 5, 6};


	for i = 1, 10 do
		APB.combobar[i] = CreateFrame("StatusBar", nil, APB);
		APB.combobar[i]:SetStatusBarTexture("Interface\\addons\\aspowerbar\\UI-StatusBar.blp", "BORDER");
		APB.combobar[i]:GetStatusBarTexture():SetHorizTile(false);
		APB.combobar[i]:SetMinMaxValues(0, 100);
		APB.combobar[i]:SetValue(100);
		APB.combobar[i]:SetHeight(APB_HEIGHT);
		APB.combobar[i]:SetWidth(20);

		APB.combobar[i].bg = APB.combobar[i]:CreateTexture(nil, "BACKGROUND");
		APB.combobar[i].bg:SetPoint("TOPLEFT", APB.combobar[i], "TOPLEFT", -1, 1);
		APB.combobar[i].bg:SetPoint("BOTTOMRIGHT", APB.combobar[i], "BOTTOMRIGHT", 1, -1);

		APB.combobar[i].bg:SetTexture("Interface\\Addons\\asPowerBar\\border.tga");
		APB.combobar[i].bg:SetTexCoord(0.1,0.1, 0.1,0.1, 0.1,0.1, 0.1,0.1);
		APB.combobar[i].bg:SetVertexColor(0, 0, 0, 0.8);

		if i == 1 then
			APB.combobar[i]:SetPoint("BOTTOMLEFT",APB.buffbar[0],"TOPLEFT", 0, 1);
		else
			APB.combobar[i]:SetPoint("LEFT",APB.combobar[i-1],"RIGHT", 3, 0);
		end

		APB.combobar[i]:Hide();
		APB.combobar[i]:EnableMouse(true);
	end

	APB.combobar[1].text = APB.combobar[1]:CreateFontString(nil, "ARTWORK");
	APB.combobar[1].text:SetFont(APB_Font, APB_HealthSize - 2, APB_FontOutline);
	APB.combobar[1].text:SetPoint("BOTTOMLEFT", APB.combobar[1], "TOPLEFT", 0, 2);
	APB.combobar[1].text:SetTextColor(1, 1, 1, 1)
	APB.combobar[1].text:Hide();

	LoadAddOn("asMOD");

	if asMOD_setupFrame then
		asMOD_setupFrame (APB, "asPowerBar");
	end

	--APB:SetScript("OnUpdate", APB_OnUpdate)
	APB:SetScript("OnEvent", APB_OnEvent)

	APB:RegisterEvent("PLAYER_ENTERING_WORLD");
	APB:RegisterEvent("PLAYER_REGEN_DISABLED");
	APB:RegisterEvent("PLAYER_REGEN_ENABLED");
	APB:RegisterEvent("TRAIT_CONFIG_UPDATED");
	APB:RegisterEvent("TRAIT_CONFIG_LIST_UPDATED");
	APB:RegisterEvent("ACTIVE_TALENT_GROUP_CHANGED");
	APB:RegisterEvent("PLAYER_EQUIPMENT_CHANGED");
	APB:RegisterEvent("SPELLS_CHANGED");
	APB:RegisterEvent("ACTIONBAR_UPDATE_USABLE");
	APB:RegisterEvent("ACTIONBAR_UPDATE_COOLDOWN");
	APB:RegisterEvent("SPELL_ACTIVATION_OVERLAY_GLOW_SHOW");
	APB:RegisterEvent("SPELL_ACTIVATION_OVERLAY_GLOW_HIDE");
	APB:RegisterUnitEvent("UNIT_ENTERING_VEHICLE", "player");
	APB:RegisterUnitEvent("UNIT_EXITING_VEHICLE", "player");


	if UnitAffectingCombat("player") then
		APB:SetAlpha(APB_ALPHA_COMBAT);
	else
		APB:SetAlpha(APB_ALPHA_NORMAL);
	end
end
