local _, ns = ...;

local APB_Font = "Fonts\\2002.TTF";
local APB_HealthSize = 12;
local APB_BuffSize = 10;
local APB_FontOutline = "OUTLINE";

local APB_WIDTH = 203; -- 위치
local APB_X = 0;
local APB_Y = -142 - 70;
local APB_HEIGHT = 10
local APB_ALPHA_COMBAT = 1       -- 전투중 알파 값
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
local bupdate_partial_power = false;
local bsmall_power_bar = false;
local bupdate_buff_combo = false;
local bupdate_direbeast_combo = false;
local bupdate_shadow_tech = false;
local APB_UNIT_POWER;
local APB_POWER_LEVEL;

APB_SPELL = nil;
APB_SPELL2 = nil;
APB_BUFF = nil;
APB_BUFF2 = nil;
APB_BUFF3 = nil;
APB_BUFF4 = nil;
APB_BUFF_COMBO = nil;
APB_BUFF_COMBO_MAX = nil;
APB_BUFF_COMBO_MAX_COUNT = nil;
APB_DEBUFF_COMBO = nil;
APB_ACTION_COMBO = nil;

local APB = nil;
local max_combo = nil;
local max_spell = nil;
local balert = false;
local balert2 = false;

local PowerTypeString = {}
PowerTypeString = {
    [Enum.PowerType.Focus] = "집중",
    [Enum.PowerType.Insanity] = "광기",
    [Enum.PowerType.Maelstrom] = "소용돌이",
    [Enum.PowerType.LunarPower] = "천공의 힘"
};

local PowerTypeComboString = {}
PowerTypeComboString = {
    [Enum.PowerType.SoulShards] = "영혼의 조각",
    [Enum.PowerType.ArcaneCharges] = "비전 충전물이",
    [Enum.PowerType.Essence] = "정수"
};

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

local asGetSpellCooldown = function(spellID)
    local ospellID = C_Spell.GetOverrideSpell(spellID)

    if ospellID then
        spellID = ospellID;
    end

    local spellCooldownInfo = C_Spell.GetSpellCooldown(spellID);
    if spellCooldownInfo then
        return spellCooldownInfo.startTime, spellCooldownInfo.duration, spellCooldownInfo.isEnabled,
            spellCooldownInfo.modRate;
    end
end

local asGetSpellCharges = function(spellID)
    local ospellID = C_Spell.GetOverrideSpell(spellID)

    if ospellID then
        spellID = ospellID;
    end

    local spellChargeInfo = C_Spell.GetSpellCharges(spellID);
    if spellChargeInfo then
        return spellChargeInfo.currentCharges, spellChargeInfo.maxCharges, spellChargeInfo.cooldownStartTime,
            spellChargeInfo.cooldownDuration, spellChargeInfo.chargeModRate;
    end
end


local SpellGetCosts = {};
local SpellGetPowerCosts = {};
local FrozenOrbID = 84714;
local FrozenOrbDamageID = 84721;
local function asGetCostTooltipInfo(spellID)
    if not spellID then
        return
    end

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

    return 0;
end

local function asGetPowerCostTooltipInfo(spellID)
    if not spellID then
        return
    end

    local cost = SpellGetPowerCosts[spellID]

    -- 8.0 change need
    --
    if cost then
        return 0 - cost;
    end

    return 0;
end

local function APB_UnitBuff(unit, buff, casterid)
    local ret = nil;
    local auraList = ns.ParseAllBuff(unit);

    auraList:Iterate(function(auraInstanceID, aura)
        if aura and (aura.name == buff or aura.spellId == buff) and aura.sourceUnit == casterid then
            if aura.duration > 0 then
                ret = aura;
            elseif ret == nil then
                ret = aura;
            end
        end
    end);

    if ret then
        return ret.name, ret.icon, ret.applications, ret.debuffType, ret.duration, ret.expirationTime, ret.sourceUnit;
    end

    for slot = 1, MAX_TOTEMS do
        local haveTotem, name, start, duration, icon = GetTotemInfo(slot);

        if haveTotem and name == buff and duration > 0 then
            return name, icon, 0, nil, duration, duration + start, "player";
        end
    end

    return nil;
end

local function APB_UnitDebuff(unit, buff, casterid)
    local i = 1;
    local ret = nil;

    local auraList = ns.ParseAllDebuff(unit);

    auraList:Iterate(function(auraInstanceID, aura)
        if aura and (aura.name == buff or aura.spellId == buff) and aura.sourceUnit == casterid then
            if aura.duration > 0 then
                ret = aura;
            elseif ret == nil then
                ret = aura;
            end
        end
    end);

    if ret then
        return ret.name, ret.icon, ret.applications, ret.debuffType, ret.duration, ret.expirationTime, ret.sourceUnit;
    end

    return nil;
end

local function APB_UnitDebuff_Name(unit, buff, filter)
    local i = 1;
    local ret = nil;

    local auraList = ns.ParseAllDebuff(unit);

    auraList:Iterate(function(auraInstanceID, aura)
        if aura and aura.name == buff then
            if aura.duration > 0 then
                ret = aura;
            elseif ret == nil then
                ret = aura;
            end
        end
    end);

    if ret then
        return ret.name, ret.icon, ret.applications, ret.debuffType, ret.duration, ret.expirationTime, ret.sourceUnit;
    end

    return nil;
end

local function APB_OnUpdateCombo(self, elapsed)
    if not self.start then
        return;
    end

    if not self.update then
        self.update = 0;
    end

    self.update = self.update + elapsed

    if self.update >= 0.25 then
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
local bhalf_combo = false;
local bdruid = false;
local brogue = false;

local bshowspell = false;

local function APB_MaxSpell(max)
    max_spell = max;

    if not max or max == 0 then
        for i = 1, 10 do
            APB.spellbar[i]:Hide();
        end
        bshowspell = false;
        return;
    end

    local width = (APB_WIDTH - (3 * (max - 1))) / max;

    for i = 1, 10 do
        APB.spellbar[i]:SetWidth(width)
        APB.spellbar[i].start = nil;
        APB.spellbar[i]:SetMinMaxValues(0, 1)
        APB.spellbar[i]:SetValue(1)
        local _, Class = UnitClass("player")
        local color = RAID_CLASS_COLORS[Class]
        APB.spellbar[i]:SetStatusBarColor(color.r, color.g, color.b);
        APB.spellbar[i]:SetScript("OnUpdate", nil)

        if i > max then
            APB.spellbar[i]:Hide()
        else
            APB.spellbar[i]:Show()
        end
    end
    bshowspell = true;
end

local function APB_ShowComboBar(combo, partial, cast, cooldown, buffexpire)
    local bmax = false;
    local bmaxminus1 = false;
    local bhalf = false;

    local _, Class = UnitClass("player")
    local color = RAID_CLASS_COLORS[Class]
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
    elseif combo == max_combo - 1 and cast == 0 then
        bmaxminus1 = true;
    elseif combo >= (max_combo / 2) and cast == 0 then
        bhalf = bhalf_combo;
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
    elseif cast < 0 then
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

    -- 문책
    if brogue then
        local chargedPowerPoints = GetUnitChargedPowerPoints("player");
        for i = 1, max_combo do
            local isCharged = chargedPowerPoints and tContains(chargedPowerPoints, i) or false;

            if isCharged then
                ns.lib.PixelGlow_Start(APB.combobar[i], { 0.5, 0.5, 1 });
                if combo == i then
                    bmax = true;
                end
            else
                ns.lib.PixelGlow_Stop(APB.combobar[i]);
            end
        end
    end

    if bupdate_shadow_tech then
        local name, icon, count, debuffType, duration, expirationTime, caster = APB_UnitBuff("player", "그림자 기술", "player");

        if name and count > 0 then
            APB.combobar[1].text:SetText(count);
            APB.combobar[1].text:ClearAllPoints();
            APB.combobar[1].text:SetPoint("CENTER", APB.combobar[math.ceil(max_combo / 2)], "CENTER", 0, 0);
            APB.combobar[1].text:Show();
        else
            APB.combobar[1].text:Hide();
        end
    end

    if buffexpire and cooldown then
        APB.combobar[1]:SetStatusBarColor(0.3, 0.3, 0.3);
        APB.combobar[1].start = (buffexpire - cooldown);
        APB.combobar[1].duration = cooldown
        APB.combobar[1]:SetScript("OnUpdate", APB_OnUpdateCombo)
        return;
    end

    for i = 1, max_combo do
        APB.combobar[i]:SetScript("OnUpdate", nil)

        if i <= combo then
            APB.combobar[i]:Show();
            APB.combobar[i]:SetValue(1)
            APB.combobar[i]:SetMinMaxValues(0, 1)

            if bmax then
                APB.combobar[i]:SetStatusBarColor(1, 0, 0);
            elseif bhalf or bmaxminus1 then
                APB.combobar[i]:SetStatusBarColor(1, 0.8, 0);
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
            elseif bhalf or bmaxminus1 then
                APB.combobar[i]:SetStatusBarColor(1, 0.8, 0);
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
        APB.combobar[1].text:SetPoint("CENTER", APB.combobar[math.ceil(max_combo / 2)], "CENTER", 0, 0);
        APB.combobar[1].text:Show();
    end
end



local bupdatecombo = false;

local function APB_MaxCombo(max)
    max_combo = max;

    if not max or max == 0 then
        for i = 1, 10 do
            APB.combobar[i]:Hide();
        end
        bupdatecombo = false;
        return;
    end

    local width = (APB_WIDTH - (3 * (max - 1))) / max;

    for i = 1, 10 do
        APB.combobar[i]:SetWidth(width)
        APB.combobar[i].start = nil;
        APB.combobar[i]:SetMinMaxValues(0, 1)
        APB.combobar[i]:SetValue(1)
        local _, Class = UnitClass("player")
        local color = RAID_CLASS_COLORS[Class]
        APB.combobar[i]:SetStatusBarColor(color.r, color.g, color.b);
        APB.combobar[i]:SetScript("OnUpdate", nil)

        if i > max then
            APB.combobar[i]:Hide()
        else
            APB.combobar[i]:Show()
        end
    end

    if bshowspell then
        APB.combobar[1]:SetPoint("BOTTOMLEFT", APB.spellbar[1], "TOPLEFT", 0, 1);
    else
        APB.combobar[1]:SetPoint("BOTTOMLEFT", APB.buffbar[0], "TOPLEFT", 0, 1);
    end

    bupdatecombo = true;
end


local function APB_UpdateBuffCombo(combobar)
    if not (APB_BUFF_COMBO or APB_DEBUFF_COMBO or APB_ACTION_COMBO) then
        return;
    end

    if not bupdate_buff_combo then
        return;
    end

    if APB_BUFF_COMBO then
        if APB_BUFF_COMBO_MAX then
            local name, icon, count, debuffType, duration, expirationTime, caster = APB_UnitBuff(combobar.unit,
                APB_BUFF_COMBO_MAX, "player");

            if name and caster == "player" and duration > 0 then
                if max_combo > 1 then
                    APB_MaxCombo(1);
                end
                local remain = expirationTime - GetTime();

                APB_ShowComboBar(0, nil, nil, duration, expirationTime);
                return;
            else
                APB_MaxCombo(APB_BUFF_COMBO_MAX_COUNT);
            end
        end

        local name, icon, count, debuffType, duration, expirationTime, caster = APB_UnitBuff(combobar.unit,
            APB_BUFF_COMBO, "player");

        if name and caster == "player" then
            APB_ShowComboBar(count);
        else
            APB_ShowComboBar(0);
        end
    end

    if APB_DEBUFF_COMBO then
        local name, icon, count, debuffType, duration, expirationTime, caster = APB_UnitDebuff(combobar.unit,
            APB_DEBUFF_COMBO, "player");

        if name and caster == "player" then
            APB_ShowComboBar(count);
        else
            APB_ShowComboBar(0);
        end
    end

    if APB_ACTION_COMBO then
        local count = GetActionCount(APB_ACTION_COMBO)

        if count then
            APB_ShowComboBar(count);
        else
            APB_ShowComboBar(0);
        end
    end
end

local prev_dire_beast_time = 0;
local prev_dire_pack_time = 0;
local dire_beast_count = 0;
local function checkDireBeast()
    local auraList = ns.ParseAllBuff("player");

    auraList:Iterate(function(auraInstanceID, aura)
        if aura.name and aura.spellId == 281036 and aura.expirationTime > prev_dire_beast_time then
            dire_beast_count = dire_beast_count + 1;
            prev_dire_beast_time = aura.expirationTime;
        elseif aura.name and aura.spellId == 378747 and aura.expirationTime > prev_dire_pack_time then
            dire_beast_count = 0;
            prev_dire_pack_time = aura.expirationTime;
        end
    end);

    return dire_beast_count;
end

local function APB_UpdateDireBeastCombo(combobar)
    if not bupdate_direbeast_combo then
        return;
    end

    local count = checkDireBeast();

    if count > 0 then
        APB_ShowComboBar(count);
    else
        APB_ShowComboBar(0);
    end
end

local function asUnitFrameUtil_UpdateFillBuffBarBase(realbar, bar, amount, alert)
    if not amount or (amount == 0) then
        bar:Hide();
        return
    end

    local previousTexture = realbar:GetStatusBarTexture();
    bar:ClearAllPoints();
    bar:SetPoint("TOPRIGHT", previousTexture, "TOPRIGHT", 0, 0);
    bar:SetPoint("BOTTOMRIGHT", previousTexture, "BOTTOMRIGHT", 0, 0);
    local totalWidth, totalHeight = realbar:GetSize();

    local _, totalMax = realbar:GetMinMaxValues();

    local barSize = (amount / totalMax) * totalWidth;
    bar:SetWidth(barSize);
    if alert == true then
        bar:SetVertexColor(1, 0.5, 0.5);
    else
        bar:SetVertexColor(0.5, 0.5, 1);
    end
    bar:Show();
end

local function asUnitFrameUtil_UpdateFillBuffBarBaseforBuff(realbar, bar, amount, alert)
    if not amount or (amount == 0) then
        bar:Hide();
        return
    end

    local previousTexture = realbar:GetStatusBarTexture();
    bar:ClearAllPoints();
    bar:SetPoint("TOPLEFT", previousTexture, "TOPLEFT", 0, 0);
    bar:SetPoint("BOTTOMLEFT", previousTexture, "BOTTOMLEFT", 0, 0);
    local totalWidth, totalHeight = realbar:GetSize();

    local _, totalMax = realbar:GetMinMaxValues();

    local barSize = (amount / totalMax) * totalWidth;
    bar:SetWidth(barSize);
    if alert == true then
        bar:SetVertexColor(1, 0.5, 0.5);
    else
        bar:SetVertexColor(0.5, 1, 1);
    end

    bar:Show();
end

local function APB_OnUpdateBuff(self, elapsed)
    if not self.start then
        self:SetValue(0);
        self.castbar:Hide();
        return;
    end

    if not self.update then
        self.update = 0;
    end

    self.update = self.update + elapsed

    if self.update >= 0.1 and self.start then
        local curr_time = GetTime();
        local curr_duration = curr_time - self.start;
        local expertedendtime = self.duration + self.start;

        self.update = 0

        if curr_duration < self.duration then
            local remain_buff = (self.duration + self.start - curr_time)

            if self.max and self.max >= remain_buff then
                self:SetMinMaxValues(0, self.max * 1000)
            else
                self:SetMinMaxValues(0, self.duration * 1000)
            end

            self:SetValue(remain_buff * 1000)
            self.text:SetText(("%02.1f"):format(remain_buff))

            if self.maxshow then
                self:SetMinMaxValues(0, self.maxshow * 1000)
                if self.maxshow < remain_buff then
                    remain_buff = self.maxshow;
                    expertedendtime = self.start + remain_buff;
                    self:SetValue(remain_buff * 1000);
                end
            end

            -- Check Casting And GCD
            local timetoready = 0;
            local _, _, _, _, endTime = UnitCastingInfo("player");
            local alert = false;

            if not endTime then
                _, _, _, _, endTime = UnitChannelInfo("player");
            end

            if not endTime then
                local start, duration = asGetSpellCooldown(61304);
                endTime = (start + duration) * 1000;
            end

            if endTime then
                if endTime > (expertedendtime * 1000) then
                    endTime = (expertedendtime * 1000);
                    alert = true;
                end

                timetoready = endTime - (curr_time * 1000);
            end

            if timetoready < 0 then
                timetoready = 0;
            end

            asUnitFrameUtil_UpdateFillBuffBarBase(self, self.castbar, timetoready, alert);
            if self.buff3barex then
                local buff3remain = (self.buff3barex - curr_time) * 1000;
                asUnitFrameUtil_UpdateFillBuffBarBaseforBuff(self, self.buff3bar, buff3remain, timetoready > buff3remain);
            else
                self.buff3bar:Hide();
            end
        end
    end
end

local function APB_UpdateBuff(buffbar)
    if not (buffbar.buff or buffbar.debuff) then
        return;
    end

    local bbuff2 = false;

    if buffbar.buff then
        local name, icon, count, debuffType, duration, expirationTime, caster;

        if buffbar.buff2 then
            name, icon, count, debuffType, duration, expirationTime, caster =
                APB_UnitBuff(buffbar.unit, buffbar.buff2, "player");
            if name then
                buffbar.tooltip = buffbar.buff2;
                bbuff2 = true;
            end
        end

        if not name then
            buffbar.tooltip = buffbar.buff;
            name, icon, count, debuffType, duration, expirationTime, caster =
                APB_UnitBuff(buffbar.unit, buffbar.buff, "player");
        end

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

        if bbuff2 then
            buffbar:SetStatusBarColor(0.7, 0.9, 0.9);
        else
            buffbar:SetStatusBarColor(0.8, 0.8, 1);
        end

        buffbar:Show();
        buffbar.text:Show();
        buffbar.count:Show();

        if buffbar.buff3 then
            name, icon, count, debuffType, duration, expirationTime, caster =
                APB_UnitBuff(buffbar.unit, buffbar.buff3, "player");
            if name and caster == "player" then
                buffbar.buff3barex = expirationTime;
            else
                buffbar.buff3barex = nil;
            end
        end
    end

    if buffbar.debuff then
        local name, icon, count, debuffType, duration, expirationTime, caster =
            APB_UnitDebuff_Name(buffbar.unit, buffbar.debuff);

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
        buffbar:SetValue(0);
        buffbar.castbar:Hide();
        buffbar.buff3bar:Hide();
    end
end

local function APB_UpdateStagger(self)
    if bupdate_stagger then
        local val = UnitStagger("player");
        local valmax = UnitHealthMax("player");

        if val == nil then
            return
        end

        local stagger = math.ceil(val / valmax * 100);

        local info = PowerBarColor["STAGGER"];
        local color = nil;

        if (stagger > 100) then
            stagger = 100
        end

        self:SetMinMaxValues(0, 100)
        self:SetValue(stagger)
        self.text:SetText(val);
        self.count:SetText(stagger);
        self.text:Show();
        self.count:Show();

        if stagger >= 60 then
            color = info.red;
        elseif stagger >= 30 then
            color = info.yellow;
        else
            color = info.green;
        end

        self:SetStatusBarColor(color.r, color.g, color.b);
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

        if start ~= nil and currtime - start <= FrozenOrbDuration then
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
            self.castbar:Hide();
            self:SetScript("OnUpdate", nil)
        end
        self.count:SetText("");
        self:Show();
        self.tooltip = "FrozenOrbTime";
    end
end


local function APB_MaxRune()
    local max = 6;
    local width = (APB_WIDTH - (3 * (max - 1))) / max;

    for i = 1, 10 do
        APB.combobar[i]:Hide();
    end

    for i = 1, 6 do
        APB.combobar[i]:SetWidth(width)
        APB.combobar[i]:Show();
    end

    if bshowspell then
        APB.combobar[1]:SetPoint("BOTTOMLEFT", APB.spellbar[1], "TOPLEFT", 0, 1);
    else
        APB.combobar[1]:SetPoint("BOTTOMLEFT", APB.buffbar[0], "TOPLEFT", 0, 1);
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
            -- APB.combobar[i2]:SetStatusBarColor(1,1,0)

            local _, Class = UnitClass("player")
            local color = RAID_CLASS_COLORS[Class]
            APB.combobar[i]:SetStatusBarColor(color.r, color.g, color.b);

            APB.combobar[i]:SetMinMaxValues(0, 1)
            APB.combobar[i]:SetValue(1)
            APB.combobar[i]:SetScript("OnUpdate", nil)
        else
            APB.combobar[i]:SetStatusBarColor(1, 1, 1)
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
        local peace, interrupted = GetPowerRegenForPowerType(Enum.PowerType.Essence)
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
        local costTable = C_Spell.GetSpellPowerCost(spellID);

        if costTable then
            for _, costInfo in pairs(costTable) do
                if (costInfo.type == APB_POWER_LEVEL) then
                    cast = costInfo.cost;
                    break
                end
            end
        end

        if cast == nil then
            cast = asGetPowerCostTooltipInfo(spellID);
        end
    end

    APB_ShowComboBar(power, partial, cast, cooldownDuration);
end

local bupdate_druid = false;

local function APB_GetActionSlots(arg1)
    local ret = {};

    for lActionSlot = 1, 180 do
        local type, id, subType, spellID = GetActionInfo(lActionSlot);

        if id and type and type == "macro" then
            local name = asGetSpellInfo(id);
            if name and name == arg1 then
                ret[lActionSlot] = true;
            end
        end
    end

    for lActionSlot = 1, 180 do
        local type, id, subType, spellID = GetActionInfo(lActionSlot);

        if id and type and type == "spell" then
            local name = asGetSpellInfo(id);
            if name and name == arg1 then
                ret[lActionSlot] = true;
            end
        end
    end



    return ret;
end

local function APB_GetActionSlot(arg1)
    local ret;

    for lActionSlot = 1, 180 do
        local type, id, subType, spellID = GetActionInfo(lActionSlot);

        if id and type and type == "macro" then
            local name = GetSpellInfo(id);
            if name and name == arg1 then
                ret = lActionSlot;
            end
        end
    end

    for lActionSlot = 1, 180 do
        local type, id, subType, spellID = GetActionInfo(lActionSlot);

        if id and type and type == "spell" then
            local name = GetSpellInfo(id);
            if name and name == arg1 then
                ret = lActionSlot;
            end
        end
    end

    return ret;
end

local function APB_SpellMax(spell, spell2)
    local _, maxCharges = asGetSpellCharges(spell);

    if bupdate_druid then
        maxCharges = 2;
    end

    if spell2 then
        local _, maxCharges2 = asGetSpellCharges(spell2);

        if bupdate_druid then
            maxCharges2 = 2;
        end

        if maxCharges2 then
            maxCharges = maxCharges + maxCharges2
        end
    end

    if maxCharges and maxCharges > 0 then
        APB_MaxSpell(maxCharges);
    else
        APB_MaxSpell(0);
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
    frame:EnableMouse(false);
    frame:SetMouseMotionEnabled(true);
end

local inrange, inrange2 = true, true;

local function APB_UpdateSpell(spell, spell2)
    local charges, maxCharges, chargeStart, chargeDuration = asGetSpellCharges(spell);
    local spellid = select(7, asGetSpellInfo(spell));

    if not spellid then
        return;
    end

    local _, notEnoughMana = C_Spell.IsSpellUsable(spellid);

    if bupdate_druid then
        charges = GetSpellCount(spellid);
        maxCharges = 2;
        chargeStart = 0;
        chargeDuration = 0;
    end

    if not charges or not maxCharges then
        return;
    end
    for i = 1, charges do
        local spellbar = APB.spellbar[i];
        spellbar.start = nil;
        --	spellbar:SetStatusBarColor(1,1,0)
        local _, Class = UnitClass("player")
        local color = RAID_CLASS_COLORS[Class]
        local rate = 0;

        if bupdatecombo then
            rate = 0.2;
        end
        spellbar:SetStatusBarColor(color.r + rate, color.g + rate, color.b + rate);

        spellbar:SetMinMaxValues(0, 1)
        spellbar:SetValue(1)
        spellbar:SetScript("OnUpdate", nil)
        spellbar.spellid = spellid;

        if balert then
            spellbar:SetStatusBarColor(0, 1, 0)
        end

        if inrange == false then
            spellbar:SetStatusBarColor(0.6, 0, 0);
        elseif notEnoughMana then
            spellbar:SetStatusBarColor(0.3, 0.3, 0.3);
        end
    end

    if charges < maxCharges then
        local spellbar = APB.spellbar[charges + 1];
        spellbar:SetStatusBarColor(1, 1, 1)
        spellbar.start = chargeStart;
        spellbar.duration = chargeDuration;
        spellbar:SetScript("OnUpdate", APB_OnUpdateCombo)
        spellbar.spellid = spellid;

        if balert then
            spellbar:SetStatusBarColor(0, 1, 1)
        end

        if inrange == false then
            spellbar:SetStatusBarColor(0.6, 0, 0);
        elseif notEnoughMana then
            spellbar:SetStatusBarColor(0.3, 0.3, 0.3);
        end
    end

    if charges < maxCharges - 1 then
        for i = charges + 2, maxCharges do
            local spellbar = APB.spellbar[i];
            spellbar:SetValue(0)
            spellbar.start = nil;
            spellbar:SetScript("OnUpdate", nil)
        end
    end

    if spell2 then
        local charges, maxCharges2, chargeStart, chargeDuration = asGetSpellCharges(spell2);
        spellid = select(7, asGetSpellInfo(spell2));

        if not spellid then
            return;
        end
        local isUsable, notEnoughMana = C_Spell.IsSpellUsable(spellid);

        if bupdate_druid then
            charges = GetSpellCount(spellid);
            maxCharges2 = 2;
            chargeStart = 0;
            chargeDuration = 0;
        end

        if not charges or not maxCharges2 then
            return;
        end

        for i = maxCharges + 1, maxCharges + charges do
            local spellbar = APB.spellbar[i];
            spellbar.start = nil;
            spellbar:SetStatusBarColor(1, 0.7, 0.3);

            spellbar:SetMinMaxValues(0, 1)
            spellbar:SetValue(1)
            spellbar:SetScript("OnUpdate", nil)
            spellbar.spellid = spellid;

            if balert2 then
                spellbar:SetStatusBarColor(0, 1, 1)
            end

            if inrange2 == false then
                spellbar:SetStatusBarColor(0.3, 0, 0);
            elseif notEnoughMana then
                spellbar:SetStatusBarColor(0.6, 0.6, 0.6);
            end
        end

        if charges < maxCharges2 then
            local spellbar = APB.spellbar[maxCharges + charges + 1];
            spellbar:SetStatusBarColor(0.5, 0.5, 0.5)
            spellbar.start = chargeStart;
            spellbar.duration = chargeDuration;
            spellbar:SetScript("OnUpdate", APB_OnUpdateCombo)

            spellbar.spellid = spellid;

            if balert2 then
                spellbar:SetStatusBarColor(0, 1, 1)
            end

            if inrange2 == false then
                spellbar:SetStatusBarColor(0.3, 0, 0);
            elseif notEnoughMana then
                spellbar:SetStatusBarColor(0.6, 0.6, 0.6);
            end
        end

        if charges < maxCharges2 - 1 then
            for i = maxCharges + charges + 2, maxCharges + maxCharges2 do
                local spellbar = APB.spellbar[i];
                spellbar:SetValue(0)
                spellbar.start = nil;
                spellbar:SetScript("OnUpdate", nil)
            end
        end
    end
end
local APB_MAX_INCOMING_HEAL_OVERFLOW = 1.2;

local function APB_HealColor(value)
    local r, g, b;
    local min, max = 0, 100 * APB_MAX_INCOMING_HEAL_OVERFLOW;

    if ((max - min) > 0) then
        value = (value - min) / (max - min);
    else
        value = 0;
    end

    if (value > 0.5) then
        r = (1.0 - value) * 2;
        g = 1.0;
    else
        r = 1.0;
        g = value * 2;
    end
    b = 0.0;

    return r, g, b;
end

local function UpdateFillBarBase(realbar, bar, amount)
    if not amount or (amount == 0) then
        bar:Hide();
        return
    end

    local previousTexture = realbar:GetStatusBarTexture();

    local gen = false;

    bar:ClearAllPoints();
    bar:SetPoint("TOPLEFT", previousTexture, "TOPRIGHT", 0, 0);
    bar:SetPoint("BOTTOMLEFT", previousTexture, "BOTTOMRIGHT", 0, 0);

    if amount < 0 then
        amount = 0 - amount;
        gen = true;
    end

    local totalWidth, totalHeight = realbar:GetSize();

    local _, totalMax = realbar:GetMinMaxValues();

    local barSize = (amount / totalMax) * totalWidth;
    bar:SetWidth(barSize);
    if gen then
        bar:SetVertexColor(1, 1, 1)
    else
        bar:SetVertexColor(0.5, 0.5, 0.5)
    end
    bar:Show();
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
        local predictedPowerCost = self.predictedPowerCost;

        if predictedPowerCost and predictedPowerCost > 0 then
            if predictedPowerCost >= value then
                predictedPowerCost = value;
                self.predictedPowerCost = value;
            end
            value = value - predictedPowerCost;
        end

        if (powerType == Enum.PowerType.Mana) and valueMax then
            valuePct = (math.ceil((value / valueMax) * 100));
            valuePct_orig = (math.ceil((value_orig / valueMax) * 100));
        else
            valuePct = value;
            valuePct_orig = value_orig
        end

        if powerTypeString then
            local info = PowerBarColor[powerTypeString];
            APB.bar:SetStatusBarColor(info.r, info.g, info.b);
        end

        APB.bar:SetMinMaxValues(0, valueMax)
        APB.bar:SetValue(value)

        if predictedPowerCost and predictedPowerCost < 0 and self.startTime and self.endTime then
            local currtime = GetTime() * 1000;

            if currtime >= self.startTime and currtime < self.endTime then
                local totalsec = math.floor((self.endTime - self.startTime) / 1000 + 0.5); -- round up
                local numtick = math.floor(totalsec / 0.75);
                local tick = predictedPowerCost / numtick;
                local remaintick = numtick - math.floor((currtime - self.startTime) / 750);
                predictedPowerCost = tick * remaintick;
            end
        end

        if predictedPowerCost and predictedPowerCost < 0 then
            local remain = valueMax - value;

            if remain < -predictedPowerCost then
                predictedPowerCost = -remain;
            end
        end

        if predictedPowerCost and not (predictedPowerCost == 0) then
            if predictedPowerCost < 0 then
                if (powerType == Enum.PowerType.Mana) then
                    valuePct = (math.ceil(((value - predictedPowerCost) / valueMax) * 100));
                else
                    valuePct = (math.ceil(((value - predictedPowerCost))));
                end

                APB.bar.text:SetText(valuePct_orig .. "(" .. valuePct .. ")");
            else
                APB.bar.text:SetText(valuePct_orig .. "(" .. valuePct .. ")");
            end
        else
            APB.bar.text:SetText(valuePct);
        end

        UpdateFillBarBase(self.bar, self.bar.PredictionBar, predictedPowerCost);
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

        valuePct = (math.ceil((value / valueMax) * 100));
        valuePct_orig = (math.ceil((value_orig / valueMax) * 100));
        local valuePctAbsorb = (math.ceil((total / valueMax) * 100));

        APB.healthbar:SetMinMaxValues(0, valueMax)
        APB.healthbar:SetValue(value)

        local r, g, b;

        r, g, b = APB_HealColor(valuePct);

        APB.healthbar:SetStatusBarColor(r, g, b);

        if valuePctAbsorb > 0 then
            APB.healthbar.text:SetText(valuePct .. "(" .. valuePctAbsorb .. ")");
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

    if update >= 0.1 then
        update = 0
        APB_Update(self)
    end

    if update2 >= 0.2 then
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

local function asCheckTalent(name)
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
            local definitionInfo = entryInfo and entryInfo.definitionID and
                C_Traits.GetDefinitionInfo(entryInfo.definitionID);

            if definitionInfo ~= nil then
                local talentName = TalentUtil.GetTalentName(definitionInfo.overrideName, definitionInfo.spellID);
                -- print(string.format("%s %d/%d", talentName, nodeInfo.currentRank, nodeInfo.maxRanks));
                if name == talentName then
                    return true;
                end
            end
        end
    end

    return false;
end

local function HowManyHasSet(setID)
    local itemList = C_LootJournal.GetItemSetItems(setID)
    if not itemList then
        return 0
    end
    local setName = GetItemSetInfo(setID)
    local max = #itemList
    local equipped = 0
    for _, v in ipairs(itemList) do
        if IsEquippedItem(v.itemID) then
            equipped = equipped + 1
        end
    end
    return equipped;
end

local function APB_CheckPower(self)
    self = APB;
    local localizedClass, englishClass = UnitClass("player")
    local spec = GetSpecialization();
    local talentgroup = GetActiveSpecGroup();
    local version = select(4, GetBuildInfo());

    if spec == nil or spec > 4 or (englishClass ~= "DRUID" and spec > 3) then
        spec = 1;
    end

    APB:UnregisterEvent("UNIT_POWER_UPDATE")
    APB:UnregisterEvent("UNIT_DISPLAYPOWER");
    APB:UnregisterEvent("UPDATE_SHAPESHIFT_FORM");
    APB:UnregisterEvent("RUNE_POWER_UPDATE");
    APB:UnregisterEvent("UNIT_AURA");
    APB:UnregisterEvent("UNIT_SPELLCAST_START");
    APB:UnregisterEvent("UNIT_SPELLCAST_STOP");
    APB:UnregisterEvent("UNIT_SPELLCAST_FAILED");
    APB:UnregisterEvent("UNIT_SPELLCAST_SUCCEEDED");
    APB:UnregisterEvent("UNIT_SPELLCAST_CHANNEL_START");
    APB:UnregisterEvent("UNIT_SPELLCAST_CHANNEL_STOP");
    APB:UnregisterEvent("PLAYER_TARGET_CHANGED");
    APB:UnregisterEvent("COMBAT_LOG_EVENT_UNFILTERED");
    APB:SetScript("OnUpdate", nil);

    bupdate_power = false;
    bupdate_rune = false;
    bupdate_spell = false;
    bupdate_buff_count = false;
    bupdate_powerbar = true;
    bupdate_buff_combo = false;
    bupdate_direbeast_combo = false;
    bupdate_shadow_tech = false;
    bupdate_stagger = false;
    bupdate_fronzen = false;
    bupdate_partial_power = false;
    bsmall_power_bar = false;
    bhalf_combo = false;
    bdruid = false;
    brogue = false;

    APB_BUFF = nil;
    APB_BUFF2 = nil;
    APB_BUFF3 = nil;
    APB_BUFF4 = nil;
    APB_DEBUFF = nil;
    APB_DEBUFF2 = nil;
    APB_SPELL = nil;
    APB_SPELL2 = nil;
    APB_ACTION = nil;
    APB_ACTION2 = nil;
    inrange = true;
    inrange2 = true;
    APB_UNIT_POWER = nil;
    APB_POWER_LEVEL = nil;
    APB_BUFF_COMBO = nil;
    APB_BUFF_COMBO_MAX = nil;
    APB_BUFF_COMBO_MAX_COUNT = nil;
    APB_DEBUFF_COMBO = nil;
    APB_ACTION_COMBO = nil;

    APB.bar:Hide();
    APB.bar.text:SetText("");
    APB.bar.count:SetText("");
    setupMouseOver(APB.bar);

    APB.combobar[1].text:SetText("");
    APB.combobar[1].text:Hide();

    APB.text:SetText("")
    APB.text:Hide();

    for i = 1, 10 do
        ns.lib.PixelGlow_Stop(APB.combobar[i]);
        setupMouseOver(APB.combobar[i]);
    end

    for i = 1, 10 do
        setupMouseOver(APB.spellbar[i]);
    end

    for j = 0, 1 do
        APB.buffbar[j]:Hide();
        APB.buffbar[j].text:SetText("");
        APB.buffbar[j].count:SetText("");
        APB.buffbar[j].castbar:Hide();
        APB.powermax = nil;

        APB.buffbar[j].buff = nil;
        APB.buffbar[j].buff2 = nil;
        APB.buffbar[j].debuff = nil;
        APB.buffbar[j].max = nil;
        APB.buffbar[j].maxshow = nil;


        setupMouseOver(APB.buffbar[j]);
    end

    if (englishClass == "EVOKER") then
        -- 기원사
        APB_UNIT_POWER = "POWER_TYPE_ESSENCE";
        APB_POWER_LEVEL = Enum.PowerType.Essence;
        APB:RegisterUnitEvent("UNIT_POWER_UPDATE", "player");
        APB:RegisterUnitEvent("UNIT_DISPLAYPOWER", "player");
        bupdate_power = true;
        bsmall_power_bar = true;

        if (spec and spec == 1) then
            if HowManyHasSet(1543) >= 2 or HowManyHasSet(1594) >= 2 then
                APB_DEBUFF = "흑요석 파편";
                APB.buffbar[0].debuff = APB_DEBUFF
                APB.buffbar[0].unit = "target";
                APB:SetScript("OnUpdate", APB_OnUpdate);

                APB:RegisterEvent("PLAYER_TARGET_CHANGED");
                APB_UpdateBuff(self.buffbar[0])
            end
        end

        if (spec and spec == 2) then
            bsmall_power_bar = false;
        end

        if (spec and spec == 3) then
            if asCheckTalent("칠흑의 힘") then
                APB_BUFF = "칠흑의 힘";
                APB.buffbar[0].buff = "칠흑의 힘"
                APB.buffbar[0].unit = "player"
                APB.buffbar[0].max = 20;
                APB:RegisterUnitEvent("UNIT_AURA", "player");
                APB_UpdateBuff(self.buffbar[0]);
            end
        end
    end

    if (englishClass == "PALADIN") then
        APB_UNIT_POWER = "HOLY_POWER";
        APB_POWER_LEVEL = Enum.PowerType.HolyPower;
        APB:RegisterUnitEvent("UNIT_POWER_UPDATE", "player");
        APB:RegisterUnitEvent("UNIT_DISPLAYPOWER", "player");
        bupdate_power = true;

        if (spec and spec == 1) then
            APB_SPELL = "신성 충격"
            APB_SpellMax(APB_SPELL);
            APB_UpdateSpell(APB_SPELL);
            bupdate_spell = true;
        end

        if (spec and spec == 2) then
            APB_SPELL = "성전사의 일격"
            APB_SpellMax(APB_SPELL);
            APB_UpdateSpell(APB_SPELL);
            bupdate_spell = true;

            bsmall_power_bar = true;

            APB_BUFF = "정의의 방패";
            APB.buffbar[0].buff = "정의의 방패"
            APB:RegisterUnitEvent("UNIT_AURA", "player");
            -- APB:SetScript("OnUpdate", APB_OnUpdate);

            APB.buffbar[0].unit = "player"

            bsmall_power_bar = true;
            APB_UpdateBuff(self.buffbar[0])
        end

        if (spec and spec == 3) then
            APB_SPELL = "심판의 칼날"
            APB_SpellMax(APB_SPELL);
            APB_UpdateSpell(APB_SPELL);
            bupdate_spell = true;
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
                APB.buffbar[0].buff = APB_BUFF
                APB.buffbar[0].unit = "player";
                APB:RegisterUnitEvent("UNIT_AURA", "player");
                bupdate_buff_count = true;
                APB_UpdateBuff(self.buffbar[0])            
            end

            if asCheckTalent("태양왕의 축복") then
                APB_BUFF_COMBO = "태양왕의 축복";
                APB_BUFF_COMBO_MAX = "태양왕의 격분";
                APB_BUFF_COMBO_MAX_COUNT = 9;
                APB_MaxCombo(APB_BUFF_COMBO_MAX_COUNT);
                APB.combobar.unit = "player"
                APB:RegisterUnitEvent("UNIT_AURA", "player");
                APB_UpdateBuffCombo(self.combobar)
                bupdate_buff_combo = true;
                bsmall_power_bar = true;

                for i = 1, 10 do
                    APB.combobar[i].tooltip = "태양왕의 축복";
                end
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

        if (spec and spec == 3) then
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

            APB_SPELL = "진눈깨비";
            APB_SpellMax(APB_SPELL);
            APB_UpdateSpell(APB_SPELL);
            bupdate_spell = true;

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

        if (spec and spec == 1) then
            if asCheckTalent("어둠의 선물") then
                APB_DEBUFF = "어둠의 선물";
                APB.buffbar[0].debuff = APB_DEBUFF
                APB.buffbar[0].unit = "target";
                APB:SetScript("OnUpdate", APB_OnUpdate);

                APB:RegisterEvent("PLAYER_TARGET_CHANGED");
                APB_UpdateBuff(self.buffbar[0])
                bupdate_buff_count = true;
            end
        end

        if (spec and spec == 2) then
            APB_BUFF = "악마의 핵";
            APB.buffbar[0].buff = APB_BUFF;
            APB.buffbar[0].unit = "player"
            APB:RegisterUnitEvent("UNIT_AURA", "player");
            APB_UpdateBuff(self.buffbar[0])
            bupdate_buff_count = true;
        end

        if (spec and spec == 3) then
            APB_SPELL = "점화";
            APB_SpellMax(APB_SPELL);
            APB_UpdateSpell(APB_SPELL);
            bupdate_spell = true;
            bupdate_partial_power = true;

            if asCheckTalent("박멸") then
                APB_DEBUFF = "박멸";
                APB.buffbar[0].debuff = APB_DEBUFF;
                APB.buffbar[0].unit = "target"
                APB:SetScript("OnUpdate", APB_OnUpdate);
                APB:RegisterEvent("PLAYER_TARGET_CHANGED");
                APB_UpdateBuff(self.buffbar[0])
            end
        end

        bsmall_power_bar = true;
    end

    if (englishClass == "DRUID") then
        bupdate_druid = false;

        if (spec and spec == 1) then
            APB_BUFF = "일월식 (달)";
            APB.buffbar[0].buff = APB_BUFF
            APB.buffbar[0].unit = "player"
            APB:RegisterUnitEvent("UNIT_AURA", "player");
            APB_UpdateBuff(self.buffbar[0]);

            APB_BUFF2 = "일월식 (태양)";
            APB.buffbar[1].buff = APB_BUFF2
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

            if asCheckTalent("잔혹한 베기") then
                APB_SPELL = "잔혹한 베기";
                APB_SpellMax(APB_SPELL);
                APB_UpdateSpell(APB_SPELL);
                bupdate_spell = true;
            end

            for i = 1, 10 do
                APB.combobar[i].tooltip = "COMBO_POINTS";
            end
        end

        if (spec and spec == 3) then
            APB_BUFF = "무쇠가죽";
            APB.buffbar[0].buff = APB_BUFF
            APB.buffbar[0].unit = "player"
            APB:RegisterUnitEvent("UNIT_AURA", "player");
            bupdate_buff_count = true;

            APB_UpdateBuff(self.buffbar[0]);

            APB_UNIT_POWER = "COMBO_POINTS"
            APB_POWER_LEVEL = Enum.PowerType.ComboPoints
            APB:RegisterUnitEvent("UNIT_POWER_UPDATE", "player")
            APB:RegisterUnitEvent("UNIT_DISPLAYPOWER", "player");
            APB:RegisterEvent("UPDATE_SHAPESHIFT_FORM");
            bupdate_power = false;
            bdruid = true;

            APB_SPELL = "광포한 재생력";
            APB_SpellMax(APB_SPELL);
            APB_UpdateSpell(APB_SPELL);
            bupdate_spell = true;

            for i = 1, 10 do
                APB.combobar[i].tooltip = "COMBO_POINTS";
            end
        end

        if (spec and spec == 4) then
            APB_UNIT_POWER = "COMBO_POINTS"
            APB_POWER_LEVEL = Enum.PowerType.ComboPoints
            APB:RegisterUnitEvent("UNIT_POWER_UPDATE", "player")
            APB:RegisterUnitEvent("UNIT_DISPLAYPOWER", "player");
            APB:RegisterEvent("UPDATE_SHAPESHIFT_FORM");
            bupdate_power = false;
            bdruid = true;

            if asCheckTalent("숲 수호자") then
                APB_SPELL = "숲 수호자";
                APB_SpellMax(APB_SPELL);
                APB_UpdateSpell(APB_SPELL);
                bupdate_spell = true;
            end

            if asCheckTalent("광합성") then
                APB_BUFF = "피어나는 생명";
                APB.buffbar[0].buff = APB_BUFF
                APB.buffbar[0].unit = "player"
                APB:RegisterUnitEvent("UNIT_AURA", "player");

                APB_UpdateBuff(self.buffbar[0]);
            end

            for i = 1, 10 do
                APB.combobar[i].tooltip = "COMBO_POINTS";
            end
        end
    end

    if (englishClass == "MONK") then
        if (spec and spec == 1) then
            bupdate_stagger = true;
            APB_UpdateStagger(self.buffbar[0]);

            APB_SPELL = "정화주";
            APB_SpellMax(APB_SPELL);
            APB_UpdateSpell(APB_SPELL);
            bupdate_spell = true;
        end
        if (spec and spec == 2) then
            APB_SPELL = "소생의 안개";
            APB_SpellMax(APB_SPELL);
            APB_UpdateSpell(APB_SPELL);
            bupdate_spell = true;

            if asCheckTalent("고대의 가르침") then
                APB_BUFF = "고대의 가르침";
                APB.buffbar[0].buff = APB_BUFF;
                APB.buffbar[0].unit = "player"
                APB:RegisterUnitEvent("UNIT_AURA", "player");
                APB_UpdateBuff(self.buffbar[0])
            end
            if asCheckTalent("셰이룬의 선물") then
                APB_ACTION_COMBO = APB_GetActionSlot("셰이룬의 선물");
                APB_MaxCombo(10);
                APB_UpdateBuffCombo(self.combobar)
                bupdate_buff_combo = true;
            end
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
        brogue = true;
        APB_UNIT_POWER = "COMBO_POINTS"
        APB_POWER_LEVEL = Enum.PowerType.ComboPoints
        APB:RegisterUnitEvent("UNIT_POWER_UPDATE", "player")
        APB:RegisterUnitEvent("UNIT_DISPLAYPOWER", "player");
        bupdate_power = true;

        for i = 1, 10 do
            APB.combobar[i].tooltip = "COMBO_POINTS";
        end

        if IsPlayerSpell(382513) then
            APB_SPELL = "소멸";
            APB_SpellMax(APB_SPELL);
            APB_UpdateSpell(APB_SPELL);
            bupdate_spell = true;
        end

        if asCheckTalent("부식성 분사") then
            APB_DEBUFF = "부식성 분사";
            APB.buffbar[0].debuff = APB_DEBUFF;
            APB.buffbar[0].unit = "target"
            APB:SetScript("OnUpdate", APB_OnUpdate);
            APB:RegisterEvent("PLAYER_TARGET_CHANGED");
            APB_UpdateBuff(self.buffbar[0])
        elseif asCheckTalent("일발필중") then
            APB_BUFF = "기만";
            APB.buffbar[0].buff = APB_BUFF;
            APB.buffbar[0].unit = "player"
            APB:RegisterUnitEvent("UNIT_AURA", "player");
            APB_UpdateBuff(self.buffbar[0])
        else
            APB_BUFF = "난도질";
            APB.buffbar[0].buff = APB_BUFF;
            APB.buffbar[0].unit = "player"
            APB:RegisterUnitEvent("UNIT_AURA", "player");
            APB_UpdateBuff(self.buffbar[0])
        end

        if (spec and spec == 3) then
            bupdate_shadow_tech = true;
        end
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
            if IsPlayerSpell(194679) then
                APB_SPELL = "룬 전환";
                APB_SpellMax(APB_SPELL);
                APB_UpdateSpell(APB_SPELL);
                bupdate_spell = true;
            end

            APB_BUFF = "뼈의 보호막";
            APB.buffbar[0].buff = APB_BUFF;
            APB.buffbar[0].unit = "player"
            APB:RegisterUnitEvent("UNIT_AURA", "player");
            bupdate_buff_count = true;
            APB_UpdateBuff(self.buffbar[0]);
        end

        if (spec and spec == 2) then
            if asCheckTalent("풀려난 광란") then
                APB_BUFF = "풀려난 광란";
                APB.buffbar[0].buff = APB_BUFF
                APB.buffbar[0].unit = "player"
                APB:RegisterUnitEvent("UNIT_AURA", "player");
                bupdate_buff_count = true;
                APB_UpdateBuff(self.buffbar[0]);
            elseif asCheckTalent("얼음 발톱") then
                APB_BUFF = "얼음 발톱";
                APB.buffbar[0].buff = APB_BUFF
                APB.buffbar[0].unit = "player"
                APB:RegisterUnitEvent("UNIT_AURA", "player");
                bupdate_buff_count = true;
                APB_UpdateBuff(self.buffbar[0]);
            end
        end

        if (spec and spec == 3 and asCheckTalent("역병인도자")) then
            APB_BUFF = "역병인도자";
            APB.buffbar[0].buff = APB_BUFF
            APB.buffbar[0].unit = "player"
            APB:RegisterUnitEvent("UNIT_AURA", "player");
            APB_UpdateBuff(self.buffbar[0]);
        end
    end

    if (englishClass == "PRIEST") then
        if (spec and spec == 1) then
            APB_SPELL = "신의 권능: 광휘";
            APB_SPELL2 = "정신 분열";
            APB_SpellMax(APB_SPELL, APB_SPELL2);
            APB_UpdateSpell(APB_SPELL, APB_SPELL2);
            bupdate_spell = true;

            if asCheckTalent("분파") then
                APB_DEBUFF = "분파";
                APB.buffbar[0].debuff = APB_DEBUFF;
                APB.buffbar[0].unit = "target"
                APB:SetScript("OnUpdate", APB_OnUpdate);
                APB:RegisterEvent("PLAYER_TARGET_CHANGED");
                APB_UpdateBuff(self.buffbar[0])
            end
        end

        if (spec and spec == 2) then
            APB_SPELL = "빛의 권능: 평온";
            APB_SPELL2 = "빛의 권능: 신성화";
            APB_SpellMax(APB_SPELL, APB_SPELL2);
            APB_UpdateSpell(APB_SPELL, APB_SPELL2);
            bupdate_spell = true;
        end

        if (spec and spec == 3) then
            APB_SPELL = "정신 분열";
            APB_SpellMax(APB_SPELL);
            APB_UpdateSpell(APB_SPELL);
            bupdate_spell = true;
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
            APB.buffbar[0].buff = APB_BUFF;
            APB.buffbar[0].unit = "player"
            APB:RegisterUnitEvent("UNIT_AURA", "player");
            -- APB:SetScript("OnUpdate", APB_OnUpdate);
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
            -- APB:SetScript("OnUpdate", APB_OnUpdate);

            APB_UpdateBuff(self.buffbar[0])
        end
    end

    if (englishClass == "DEMONHUNTER") then
        if (spec and spec == 1) then
            if asCheckTalent("탄력") then
                APB_BUFF = "탄력";
                APB.buffbar[0].buff = APB_BUFF;
                APB.buffbar[0].unit = "player"
                APB.buffbar[0].max = 20;
                APB:RegisterUnitEvent("UNIT_AURA", "player");
                -- APB:SetScript("OnUpdate", APB_OnUpdate);

                APB_UpdateBuff(self.buffbar[0])
            elseif asCheckTalent("타성") then
                APB_BUFF = "타성";
                APB.buffbar[0].buff = APB_BUFF;
                APB.buffbar[0].unit = "player"
                APB:RegisterUnitEvent("UNIT_AURA", "player");
                -- APB:SetScript("OnUpdate", APB_OnUpdate);

                APB_UpdateBuff(self.buffbar[0])
            end

            APB_SPELL = "지옥 돌진";
            APB_SPELL2 = "글레이브 투척"
            APB_SpellMax(APB_SPELL, APB_SPELL2);
            APB_UpdateSpell(APB_SPELL, APB_SPELL2);
            bupdate_spell = true;
        end

        if (spec and spec == 2) then
            APB_SPELL = "악마 쐐기";

            if asCheckTalent("균열") then
                APB_SPELL2 = "균열"
                APB_SpellMax(APB_SPELL, APB_SPELL2);
                APB_UpdateSpell(APB_SPELL, APB_SPELL2);
            else
                APB_SpellMax(APB_SPELL);
                APB_UpdateSpell(APB_SPELL);
            end

            bupdate_spell = true;
            APB_BUFF = "악마 쐐기";
            APB.buffbar[0].buff = APB_BUFF;
            APB.buffbar[0].unit = "player"
            APB:RegisterUnitEvent("UNIT_AURA", "player");
            -- APB:SetScript("OnUpdate", APB_OnUpdate);

            APB_UpdateBuff(self.buffbar[0]);

            APB_BUFF_COMBO = "영혼 파편";
            APB_MaxCombo(5);
            APB.combobar.unit = "player"
            APB:RegisterUnitEvent("UNIT_AURA", "player");
            APB_UpdateBuffCombo(self.combobar)
            bupdate_buff_combo = true;

            for i = 1, 10 do
                APB.combobar[i].tooltip = "고영혼 파편";
            end
        end
    end

    if (englishClass == "HUNTER") then
        if (spec and spec == 1) then
            APB_SPELL = "날카로운 사격";
            APB_SpellMax(APB_SPELL);
            APB_UpdateSpell(APB_SPELL);
            bupdate_spell = true;

            APB_BUFF = "광기";
            APB.buffbar[0].buff = APB_BUFF;
            APB.buffbar[0].unit = "player"
            bupdate_buff_count = true;
            APB:RegisterUnitEvent("UNIT_AURA", "player");
            -- APB:SetScript("OnUpdate", APB_OnUpdate);
            APB_UpdateBuff(self.buffbar[0])

            if asCheckTalent("폭발성 맹독") then
                APB_BUFF_COMBO = "폭발성 맹독";
                APB_MaxCombo(5);
                APB.combobar.unit = "player"
                APB:RegisterUnitEvent("UNIT_AURA", "player");
                APB_UpdateBuffCombo(self.combobar)
                bupdate_buff_combo = true;
            elseif asCheckTalent("저승까마귀") then
                APB_BUFF_COMBO = "저승까마귀";
                APB_MaxCombo(4);
                APB.combobar.unit = "player"
                APB:RegisterUnitEvent("UNIT_AURA", "player");
                APB_UpdateBuffCombo(self.combobar)
                bupdate_buff_combo = true;
            end
        end

        if (spec and spec == 2) then
            APB_SPELL = "조준 사격";
            APB_SpellMax(APB_SPELL);
            APB_UpdateSpell(APB_SPELL);
            bupdate_spell = true;

            if asCheckTalent("교묘한 사격") then
                APB_BUFF = "교묘한 사격";
                APB_BUFF3 = "연발 공격";
                APB.buffbar[0].buff = APB_BUFF;
                APB.buffbar[0].buff3 = APB_BUFF3;
                APB.buffbar[0].unit = "player"
                APB.buffbar[0].maxshow = 6;
                APB:RegisterUnitEvent("UNIT_AURA", "player");
                APB_UpdateBuff(self.buffbar[0])            
            end
        end

        if (spec and spec == 3) then
            if asCheckTalent("도살") then
                APB_SPELL = "도살";
            else
                APB_SPELL = "저미기"
            end

            APB_SpellMax(APB_SPELL);
            APB_UpdateSpell(APB_SPELL);
            bupdate_spell = true;

            if asCheckTalent("살쾡이의 이빨") then
                APB_BUFF_COMBO = "살쾡이의 격노";
                APB_MaxCombo(5);
                APB.combobar.unit = "player"
                APB_UpdateBuffCombo(self.combobar)
                bupdate_buff_combo = true;

                for i = 1, 10 do
                    APB.combobar[i].tooltip = APB_BUFF_COMBO;
                end

                APB_BUFF = "살쾡이의 격노";
                APB.buffbar[0].buff = APB_BUFF;
                -- bupdate_buff_count = true;
                APB.buffbar[0].unit = "player";
                APB:RegisterUnitEvent("UNIT_AURA", "player");
                -- APB:SetScript("OnUpdate", APB_OnUpdate);
                APB_UpdateBuff(self.buffbar[0])
            elseif asCheckTalent("창끝") then
                APB_BUFF_COMBO = "창끝";
                APB_MaxCombo(3);
                APB.combobar.unit = "player"
                APB:RegisterUnitEvent("UNIT_AURA", "player");
                APB_UpdateBuffCombo(self.combobar)
                bupdate_buff_combo = true;
            end
        end
    end

    if (englishClass == "SHAMAN") then
        if spec and spec == 1 then
            if asCheckTalent("깊이 뿌리내린 정기") then
                APB_BUFF = "승천";
                APB.buffbar[0].buff = APB_BUFF;
                APB.buffbar[0].unit = "player"
                APB:RegisterUnitEvent("UNIT_AURA", "player");
                APB_UpdateBuff(self.buffbar[0])
            end
        end

        if spec and spec == 2 then
            APB_BUFF_COMBO = "소용돌이치는 무기";
            APB_BUFF4 = "소용돌이"; --asOverlay 삭제용
            APB_MaxCombo(10);
            APB.combobar.unit = "player"
            APB:RegisterUnitEvent("UNIT_AURA", "player");
            APB_UpdateBuffCombo(self.combobar)
            bupdate_buff_combo = true;
            bsmall_power_bar = true;

            for i = 1, 10 do
                APB.combobar[i].tooltip = "소용돌이치는 무기";
            end
            bhalf_combo = true;

            if asCheckTalent("낙뢰") then
                APB_BUFF = "낙뢰";
                APB.buffbar[0].buff = 187878;
                APB.buffbar[0].unit = "player"
                APB:RegisterUnitEvent("UNIT_AURA", "player");
                APB_UpdateBuff(self.buffbar[0])
            end
        end

        if (spec and spec == 3) then
            APB_SPELL = "성난 해일";
            APB_SpellMax(APB_SPELL);
            APB_UpdateSpell(APB_SPELL);
            bupdate_spell = true;

            APB_BUFF_COMBO = "굽이치는 물결";
            APB_MaxCombo(2);
            APB.combobar.unit = "player"
            APB:RegisterUnitEvent("UNIT_AURA", "player");
            APB_UpdateBuffCombo(self.combobar)
            bupdate_buff_combo = true;

            for i = 1, 10 do
                APB.combobar[i].tooltip = "굽이치는 물결";
            end
        end
    end

    if APB_SPELL then
        APB_ACTION = APB_GetActionSlots(APB_SPELL);
    end

    if APB_SPELL2 then
        APB_ACTION2 = APB_GetActionSlots(APB_SPELL2);
    end

    if not bupdate_power and not bupdate_rune and not bupdate_buff_combo and not bupdate_direbeast_combo then
        APB_MaxCombo(0);
    end

    if not bupdate_spell then
        APB_MaxSpell(0);
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
            APB.buffbar[1]:SetWidth(APB_WIDTH / 2);
            APB.buffbar[0]:SetWidth(APB_WIDTH / 2);
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
        -- APB.bar.count:Hide();
    end
end

local gpredictedPowerCost = nil;

local function checkSpellCost(id)
    local i = 1

    if id then
        local spell = Spell:CreateFromSpellID(id);
        spell:ContinueOnSpellLoad(function()
            local costText = spell:GetSpellDescription();
            local powerType = UnitPowerType("player");

            if costText and PowerTypeString[powerType] and string.match(costText, PowerTypeString[powerType]) and
                string.match(costText, "생성") then
                local findstring = "%d의 " .. PowerTypeString[powerType];
                local start = string.find(costText, findstring, 0);

                if start and start > 5 then
                    local costText2 = string.sub(costText, start - 5);
                    local s2 = string.find(costText2, findstring, findstring:len() + 5);

                    if (s2) and s2 > 5 then
                        costText2 = string.sub(costText2, s2 - 5);
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

    if spec == nil or spec > 4 or (englishClass ~= "DRUID" and spec > 3) then
        spec = 1;
    end

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

            if costText and powerTypeString and string.match(costText, powerTypeString) and
                string.match(costText, "생성") then
                local findstring = "%d의 " .. powerTypeString;
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

                local notfindstring = "죽으면 " .. findstring;

                local start = string.find(costText, findstring, 0);
                local startno = string.find(costText, notfindstring, 0);

                if startno and startno > 10 then
                    SpellGetPowerCosts[id] = 0;
                    return;
                end

                if start and start > 10 and startno == nil then
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

local ticktime = {}

local function asUnitFrameManaCostPredictionBars_Update(frame, isStarting, startTime, endTime, spellID, bchanneling)
    local cost = 0;
    if (not isStarting or startTime == endTime) then
        frame.predictedPowerCost = nil;
        frame.startTime = nil;
        frame.endTime = nil;
    else
        local costTable = C_Spell.GetSpellPowerCost(spellID);

        if costTable then
            for _, costInfo in pairs(costTable) do
                if (costInfo.type == frame.powerType) then
                    cost = costInfo.cost;
                    break
                end
            end
        end

        if cost == 0 then
            cost = asGetCostTooltipInfo(spellID);
        end

        frame.predictedPowerCost = cost;
        if bchanneling then
            frame.startTime = startTime;
            frame.endTime = endTime;
        else
            frame.startTime = nil;
            frame.endTime = nil;
        end
    end

    APB_Update(frame);
end

local windrunner_count = 0;

local function APB_OnEvent(self, event, arg1, arg2, arg3, ...)
    if event == "UNIT_AURA" then
        APB_UpdateBuff(self.buffbar[0]);
        APB_UpdateBuff(self.buffbar[1]);
        APB_UpdateBuffCombo(self.combobar);
        APB_UpdateDireBeastCombo(self.combobar);
        APB_UpdateStagger(self.buffbar[0]);
    elseif event == "ACTIONBAR_UPDATE_COOLDOWN" or event == "ACTIONBAR_UPDATE_USABLE" then
        if APB_SPELL then
            APB_UpdateSpell(APB_SPELL, APB_SPELL2);
        end
        APB_UpdateFronzenOrb(self.buffbar[0]);
    elseif event == "UNIT_POWER_UPDATE" and arg1 == "player" then
        APB_UpdatePower();
    elseif event == "RUNE_POWER_UPDATE" then
        APB_UpdateRune();
    elseif (event == "UNIT_SPELLCAST_START" or event == "UNIT_SPELLCAST_STOP" or event == "UNIT_SPELLCAST_FAILED" or
            event == "UNIT_SPELLCAST_SUCCEEDED") and arg1 == "player" then
        local name, text, texture, startTime, endTime, isTradeSkill, castID, notInterruptible, spellID =
            UnitCastingInfo(arg1);
        local bchanneling = false;
        checkSpellCost(spellID);
        checkSpellPowerCost(spellID);
        asUnitFrameManaCostPredictionBars_Update(self, (event == "UNIT_SPELLCAST_START" or not (startTime == endTime)),
            startTime, endTime, spellID, bchanneling);
        APB_UpdatePower();
        APB_UpdateFronzenOrb(self.buffbar[0]);
    elseif event == "PLAYER_TARGET_CHANGED" then
        APB_UpdateBuff(self.buffbar[0]);
        APB_UpdateBuff(self.buffbar[1]);
        APB_UpdateBuffCombo(self.combobar);
    elseif event == "COMBAT_LOG_EVENT_UNFILTERED" then
        if bupdate_fronzen then
            local timestamp, eventType, _, sourceGUID, _, _, _, destGUID, _, _, _, spellID, _, _, auraType =
                CombatLogGetCurrentEventInfo();
            if sourceGUID and (sourceGUID == UnitGUID("player")) then
                if (eventType == "SPELL_CAST_SUCCESS") and spellID == FrozenOrbID then
                    FrozenOrbTime = nil;
                elseif FrozenOrbTime == nil and (eventType == "SPELL_DAMAGE") and spellID == FrozenOrbDamageID then
                    FrozenOrbTime = GetTime();
                end
            end
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
    elseif (event == "TRAIT_CONFIG_UPDATED") or (event == "TRAIT_CONFIG_LIST_UPDATED") or event ==
        "ACTIVE_TALENT_GROUP_CHANGED" then
        C_Timer.After(0.5, APB_CheckPower);
        C_Timer.After(0.5, APB_UpdatePower);
    elseif event == "SPELLS_CHANGED" then
        checkSpellCost();
        checkSpellPowerCost();
    elseif event == "UPDATE_SHAPESHIFT_FORM" then
        if bdruid then
            local form = GetShapeshiftForm();
            if form == 2 then
                bupdate_power = true;
            else
                bupdate_power = false;
                for i = 1, #APB.combobar do
                    APB.combobar[i]:Hide();
                end
            end
        end

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
        local name = asGetSpellInfo(arg1);
        if APB_SPELL and APB_SPELL == name then
            balert = true;
        end

        if APB_SPELL2 and APB_SPELL2 == name then
            balert2 = true;
        end
    elseif event == "SPELL_ACTIVATION_OVERLAY_GLOW_HIDE" then
        local name = asGetSpellInfo(arg1);
        if APB_SPELL and APB_SPELL == name then
            balert = false;
        end
        if APB_SPELL2 and APB_SPELL2 == name then
            balert2 = false;
        end
    elseif event == "PLAYER_EQUIPMENT_CHANGED" then
        C_Timer.After(0.5, APB_CheckPower);
        C_Timer.After(0.5, APB_UpdatePower);
    elseif event == "ACTION_RANGE_CHECK_UPDATE" then
        local action, inRange, checksRange = arg1, arg2, arg3;

        if APB_ACTION and APB_ACTION[action] then
            local type, id, subType, spellID = GetActionInfo(action);

            if id then
                local name = asGetSpellInfo(id);
                local spellname = asGetSpellInfo(APB_SPELL);

                if name and spellname and name == spellname then
                    if (checksRange and not inRange) then
                        inrange = false;
                    else
                        inrange = true;
                    end
                end
            end

            if APB_SPELL then
                APB_UpdateSpell(APB_SPELL, APB_SPELL2);
            end
        elseif APB_ACTION2 and APB_ACTION2[action] then
            local type, id, subType, spellID = GetActionInfo(action);

            if id then
                local name = asGetSpellInfo(id);
                local spellname = asGetSpellInfo(APB_SPELL2);

                if name and spellname and name == spellname then
                    if (checksRange and not inRange) then
                        inrange2 = false;
                    else
                        inrange2 = true;
                    end
                end
            end

            if APB_SPELL then
                APB_UpdateSpell(APB_SPELL, APB_SPELL2);
            end
        end
    end

    return;
end

do
    APB = CreateFrame("FRAME", nil, UIParent)
    APB:SetPoint("BOTTOM", UIParent, "CENTER", APB_X, APB_Y)
    APB:SetWidth(APB_WIDTH)
    APB:SetHeight(APB_HEIGHT)
    APB:Show();

    APB.bar = CreateFrame("StatusBar", nil, APB)
    APB.bar:SetStatusBarTexture("Interface\\addons\\aspowerbar\\UI-StatusBar", "BORDER")
    APB.bar:GetStatusBarTexture():SetHorizTile(false)
    APB.bar:SetMinMaxValues(0, 100)
    APB.bar:SetValue(100)
    APB.bar:SetWidth(APB_WIDTH)
    APB.bar:SetHeight(APB_HEIGHT)
    APB.bar:SetPoint("BOTTOM", APB, "BOTTOM", 0, 0)
    APB.bar:Hide();

    APB.bar.bg = APB.bar:CreateTexture(nil, "BACKGROUND");
    APB.bar.bg:SetPoint("TOPLEFT", APB.bar, "TOPLEFT", -1, 1);
    APB.bar.bg:SetPoint("BOTTOMRIGHT", APB.bar, "BOTTOMRIGHT", 1, -1);

    APB.bar.bg:SetTexture("Interface\\Addons\\asPowerBar\\border.tga");
    APB.bar.bg:SetTexCoord(0.1, 0.1, 0.1, 0.1, 0.1, 0.1, 0.1, 0.1);
    APB.bar.bg:SetVertexColor(0, 0, 0, 0.8);

    APB.bar.text = APB.bar:CreateFontString(nil, "ARTWORK");
    APB.bar.text:SetFont(APB_Font, APB_HealthSize, APB_FontOutline);
    APB.bar.text:SetPoint("CENTER", APB.bar, "CENTER", 0, 0);
    APB.bar.text:SetTextColor(1, 1, 1, 1);

    APB.bar.count = APB.bar:CreateFontString(nil, "ARTWORK");
    APB.bar.count:SetFont(APB_Font, APB_HealthSize, APB_FontOutline);
    APB.bar.count:SetPoint("RIGHT", APB.bar, "RIGHT", -4, 0);
    APB.bar.count:SetTextColor(1, 1, 1, 1);

    APB.bar.PredictionBar = APB.bar:CreateTexture(nil, "BORDER", "asPredictionBarTemplate");
    APB.bar.PredictionBar:Hide();

    APB.healthbar = CreateFrame("StatusBar", nil, APB);
    APB.healthbar:SetStatusBarTexture("Interface\\addons\\aspowerbar\\UI-StatusBar", "BORDER")
    APB.healthbar:GetStatusBarTexture():SetHorizTile(false)
    APB.healthbar:SetMinMaxValues(0, 100)
    APB.healthbar:SetValue(100)
    APB.healthbar:SetWidth(APB_WIDTH)
    APB.healthbar:SetHeight(APB_HEIGHT)
    APB.healthbar:SetPoint("BOTTOMLEFT", APB.bar, "TOPLEFT", 0, 1)
    APB.healthbar:Hide();

    APB.healthbar.myManaCostPredictionBar = APB.healthbar:CreateTexture(nil, "BORDER", "asPredictionBarTemplate")
    APB.healthbar.myManaCostPredictionBar:Hide();

    APB.healthbar.bg = APB.bar:CreateTexture(nil, "BACKGROUND");
    APB.healthbar.bg:SetPoint("TOPLEFT", APB.healthbar, "TOPLEFT", -1, 1);
    APB.healthbar.bg:SetPoint("BOTTOMRIGHT", APB.healthbar, "BOTTOMRIGHT", 1, -1);

    APB.healthbar.bg:SetTexture("Interface\\Addons\\asPowerBar\\border.tga");
    APB.healthbar.bg:SetTexCoord(0.1, 0.1, 0.1, 0.1, 0.1, 0.1, 0.1, 0.1);
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
        APB.buffbar[j]:SetStatusBarTexture("Interface\\addons\\aspowerbar\\UI-StatusBar", "BORDER")
        APB.buffbar[j]:GetStatusBarTexture():SetHorizTile(false);
        APB.buffbar[j]:SetMinMaxValues(0, 100);
        APB.buffbar[j]:SetValue(100);
        APB.buffbar[j]:SetHeight(APB_HEIGHT);
        APB.buffbar[j]:SetWidth(APB_WIDTH);

        APB.buffbar[j].bg = APB.buffbar[j]:CreateTexture(nil, "BACKGROUND");
        APB.buffbar[j].bg:SetPoint("TOPLEFT", APB.buffbar[j], "TOPLEFT", -1, 1);
        APB.buffbar[j].bg:SetPoint("BOTTOMRIGHT", APB.buffbar[j], "BOTTOMRIGHT", 1, -1);

        APB.buffbar[j].bg:SetTexture("Interface\\Addons\\asPowerBar\\border.tga");
        APB.buffbar[j].bg:SetTexCoord(0.1, 0.1, 0.1, 0.1, 0.1, 0.1, 0.1, 0.1);
        APB.buffbar[j].bg:SetVertexColor(0, 0, 0, 0.8);

        if j == 0 then
            APB.buffbar[j]:SetPoint("BOTTOMLEFT", APB.healthbar, "TOPLEFT", 0, 1);
        else
            APB.buffbar[j]:SetPoint("BOTTOMLEFT", APB.healthbar, "TOP", 0, 1);
        end
        APB.buffbar[j]:Hide();

        APB.buffbar[j].buff3bar = APB.buffbar[j]:CreateTexture(nil, "ARTWORK", "asPredictionBarTemplate", 2);
        APB.buffbar[j].buff3bar:Hide();

        APB.buffbar[j].castbar = APB.buffbar[j]:CreateTexture(nil, "ARTWORK", "asPredictionBarTemplate", 3);
        APB.buffbar[j].castbar:Hide();

        APB.buffbar[j].text = APB.buffbar[j]:CreateFontString(nil, "ARTWORK")
        APB.buffbar[j].text:SetFont(APB_Font, APB_BuffSize, APB_FontOutline)
        APB.buffbar[j].text:SetPoint("LEFT", APB.buffbar[j], "LEFT", 5, 0)
        APB.buffbar[j].text:SetTextColor(1, 1, 1, 1)

        APB.buffbar[j].count = APB.buffbar[j]:CreateFontString(nil, "ARTWORK")
        APB.buffbar[j].count:SetFont(APB_Font, APB_BuffSize + 5, APB_FontOutline)
        APB.buffbar[j].count:SetPoint("RIGHT", APB.buffbar[j], "RIGHT", -4, 0)
        APB.buffbar[j].count:SetTextColor(1, 1, 1, 1)
    end

    APB.combobar = {};
    APB.runeIndexes = { 1, 2, 3, 4, 5, 6 };

    for i = 1, 10 do
        APB.combobar[i] = CreateFrame("StatusBar", nil, APB);
        APB.combobar[i]:SetStatusBarTexture("Interface\\addons\\aspowerbar\\UI-StatusBar", "BORDER");
        APB.combobar[i]:GetStatusBarTexture():SetHorizTile(false);
        APB.combobar[i]:SetMinMaxValues(0, 100);
        APB.combobar[i]:SetValue(100);
        APB.combobar[i]:SetHeight(APB_HEIGHT);
        APB.combobar[i]:SetWidth(20);

        APB.combobar[i].bg = APB.combobar[i]:CreateTexture(nil, "BACKGROUND");
        APB.combobar[i].bg:SetPoint("TOPLEFT", APB.combobar[i], "TOPLEFT", -1, 1);
        APB.combobar[i].bg:SetPoint("BOTTOMRIGHT", APB.combobar[i], "BOTTOMRIGHT", 1, -1);

        APB.combobar[i].bg:SetTexture("Interface\\Addons\\asPowerBar\\border.tga");
        APB.combobar[i].bg:SetTexCoord(0.1, 0.1, 0.1, 0.1, 0.1, 0.1, 0.1, 0.1);
        APB.combobar[i].bg:SetVertexColor(0, 0, 0, 0.8);

        if i == 1 then
            APB.combobar[i]:SetPoint("BOTTOMLEFT", APB.buffbar[0], "TOPLEFT", 0, 1);
        else
            APB.combobar[i]:SetPoint("LEFT", APB.combobar[i - 1], "RIGHT", 3, 0);
        end

        APB.combobar[i]:Hide();
        APB.combobar[i]:EnableMouse(false);
    end

    APB.combobar[1].text = APB.combobar[1]:CreateFontString(nil, "ARTWORK");
    APB.combobar[1].text:SetFont(APB_Font, APB_HealthSize - 2, APB_FontOutline);
    APB.combobar[1].text:SetPoint("BOTTOMLEFT", APB.combobar[1], "TOPLEFT", 0, 2);
    APB.combobar[1].text:SetTextColor(1, 1, 1, 1)
    APB.combobar[1].text:Hide();

    APB.spellbar = {};

    for i = 1, 10 do
        APB.spellbar[i] = CreateFrame("StatusBar", nil, APB);
        APB.spellbar[i]:SetStatusBarTexture("Interface\\addons\\aspowerbar\\UI-StatusBar", "BORDER");
        APB.spellbar[i]:GetStatusBarTexture():SetHorizTile(false);
        APB.spellbar[i]:SetMinMaxValues(0, 100);
        APB.spellbar[i]:SetValue(100);
        APB.spellbar[i]:SetHeight(APB_HEIGHT * 0.7);
        APB.spellbar[i]:SetWidth(20);

        APB.spellbar[i].bg = APB.spellbar[i]:CreateTexture(nil, "BACKGROUND");
        APB.spellbar[i].bg:SetPoint("TOPLEFT", APB.spellbar[i], "TOPLEFT", -1, 1);
        APB.spellbar[i].bg:SetPoint("BOTTOMRIGHT", APB.spellbar[i], "BOTTOMRIGHT", 1, -1);

        APB.spellbar[i].bg:SetTexture("Interface\\Addons\\asPowerBar\\border.tga");
        APB.spellbar[i].bg:SetTexCoord(0.1, 0.1, 0.1, 0.1, 0.1, 0.1, 0.1, 0.1);
        APB.spellbar[i].bg:SetVertexColor(0, 0, 0, 0.8);

        if i == 1 then
            APB.spellbar[i]:SetPoint("BOTTOMLEFT", APB.buffbar[0], "TOPLEFT", 0, 1);
        else
            APB.spellbar[i]:SetPoint("LEFT", APB.spellbar[i - 1], "RIGHT", 3, 0);
        end

        APB.spellbar[i]:Hide();
        APB.spellbar[i]:EnableMouse(false);
    end

    APB.text = APB:CreateFontString(nil, "ARTWORK");
    APB.text:SetFont(APB_Font, APB_HealthSize - 2, APB_FontOutline);
    APB.text:SetPoint("BOTTOMLEFT", APB.spellbar[1], "TOPRIGHT", -10, 2);
    APB.text:SetTextColor(1, 1, 1, 1)
    APB.text:Hide();

    LoadAddOn("asMOD");

    if asMOD_setupFrame then
        asMOD_setupFrame(APB, "asPowerBar");
    end

    -- APB:SetScript("OnUpdate", APB_OnUpdate)
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
    APB:RegisterEvent("ACTION_RANGE_CHECK_UPDATE");
    APB:RegisterUnitEvent("UNIT_ENTERING_VEHICLE", "player");
    APB:RegisterUnitEvent("UNIT_EXITING_VEHICLE", "player");

    if UnitAffectingCombat("player") then
        APB:SetAlpha(APB_ALPHA_COMBAT);
    else
        APB:SetAlpha(APB_ALPHA_NORMAL);
    end
end
