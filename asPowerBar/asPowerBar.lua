local _, ns = ...;

local APB_Font = STANDARD_TEXT_FONT;
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
local APB_STACKBAR_COLOR_NORMAL = { 0.3, 1, 0.3 };
local APB_STACKBAR_COLOR_ALERT = { 1, 0.5, 0.3 };
local APB_STACKBAR_COLOR_ALERT2 = { 0.5, 1, 1 };

local bupdate_power = false;
local bupdate_rune = false;
local bupdate_spell = false;
local bupdate_buff_count = false;
local bupdate_healthbar = APB_SHOW_HEALTHBAR;
local bupdate_stagger = false;
local bupdate_fronzen = false;
local bupdate_enhaced_tempest = false;
local bupdate_element_tempest = false;
local bupdate_Howl_Pack = false;
local bupdate_partial_power = false;
local bsmall_power_bar = false;
local bupdate_buff_combo = false;
local APB_UNIT_POWER;
local APB_POWER_LEVEL;

APB_SPELL = nil;
APB_SPELL2 = nil;
APB_BUFF = nil;
APB_BUFF2 = nil;
APB_BUFF3 = nil;
APB_BUFF4 = nil;
APB_BUFF_COMBO = nil;
APB_BUFF_STACK = nil;
APB_BUFF_TIME_STACK = nil;
APB_DEBUFF_STACK = nil;
APB_DEBUFF_TIME_STACK = nil;
APB_ACTION_STACK = nil;
APB_BUFF_COMBO_MAX = nil;
APB_BUFF_COMBO_MAX_COUNT = nil;
APB_DEBUFF_COMBO = nil;
APB_ACTION_COMBO = nil;

local APB = CreateFrame("FRAME", nil, UIParent);
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

if GetLocale() == "enUS" then
    PowerTypeString = {
        [Enum.PowerType.Focus] = "Focus",
        [Enum.PowerType.Insanity] = "Insanity",
        [Enum.PowerType.Maelstrom] = "Maelstrom",
        [Enum.PowerType.LunarPower] = "LunarPower"
    };

    PowerTypeComboString = {
        [Enum.PowerType.SoulShards] = "Soul Shard",
        [Enum.PowerType.ArcaneCharges] = "Arcane Charge",
        [Enum.PowerType.Essence] = "Essence"
    };
end


local tempeststate = {
    TempestStacks = 0,
    bfirstcheck = true,
    TStacks = 0,
    currentStacks = 0,
    lastCastTime = 0,
    buffstack = 0,
    lastspellId = 0,
    lastaction = 0,
}

local splinterstorm_time = GetTime();


local special_cost_spells = {
    [386997] = { 449638, -3 },
    [265187] = { 449638, -3 },

}
local next_howl = nil;


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
    if not spellID then
        return nil;
    end

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
    if not spellID then
        return nil;
    end
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

    if special_cost_spells[spellID] then
        local v = special_cost_spells[spellID];

        if IsPlayerSpell(v[1]) then
            return v[2];
        end
    end

    return 0;
end

local function APB_UnitBuffList(unit, list)
    local ret = nil;
    local auraList = ns.ParseAllBuff(unit);


    for index, id in pairs(list) do
        local aura = auraList[id];
        if aura then
            if aura.duration > 0 then
                ret = aura;
                return true;
            elseif ret == nil then
                ret = aura;
                return true;
            end
            break;
        end
    end
    if ret then
        return ret.name, ret.icon, ret.applications, ret.debuffType, ret.duration, ret.expirationTime, ret.sourceUnit,
            ret.spellId;
    end
end

local function APB_UnitBuffCountList(unit, list)
    local auraList = ns.ParseAllBuff(unit);
    local ret = nil;



    for index, v in pairs(list) do
        local id = v[1];
        local count = v[2];
        local aura = auraList[id];
        if aura and aura.spellId == id and (count == 0 or aura.applications >= count) then
            if aura.duration > 0 then
                ret = aura;
                return true;
            elseif ret == nil then
                ret = aura;
                return true;
            end
            break;
        end
    end

    if ret then
        return ret.name, ret.icon, ret.applications, ret.debuffType, ret.duration, ret.expirationTime, ret.sourceUnit;
    end
end


local function APB_UnitBuff(unit, buff)
    local auraList = ns.ParseAllBuff(unit);
    local ret = auraList[buff];


    if ret then
        return ret.name, ret.icon, ret.applications, ret.debuffType, ret.duration, ret.expirationTime, ret.sourceUnit;
    end

    for slot = 1, MAX_TOTEMS do
        local haveTotem, name, start, duration, icon = GetTotemInfo(slot);

        if haveTotem and icon == buff and duration > 0 then
            return name, icon, 0, nil, duration, duration + start, "player";
        end
    end

    return nil;
end

local function APB_UnitDebuff(unit, buff)
    local auraList = ns.ParseAllDebuff(unit);
    local ret = auraList[buff];

    if ret then
        return ret.name, ret.icon, ret.applications, ret.debuffType, ret.duration, ret.expirationTime, ret.sourceUnit;
    end

    return nil;
end

local function APB_OnUpdateCombo(self)
    if not self.start then
        return;
    end


    local curr_time = GetTime();
    local curr_duration = curr_time - self.start;

    self.update = 0

    if self.reverse then
        if curr_duration < self.duration then
            self:SetMinMaxValues(0, self.duration * 10)
            self:SetValue((self.duration * 10) - (curr_time - self.start) * 10)
        else
            self:SetMinMaxValues(0, self.duration)
            self:SetValue(0)
            self.start = nil;
        end
    else
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
local bdeathstalker = nil;
local combobuffalertlist = nil;
local combodebuffalertlist = nil;
local combobuffcountalertlist = nil;
local combobuffcoloralertlist = nil;
local druidcomboalertid = nil;
local spellbuffcolorlist = nil;
local spell2buffcolorlist = nil;

local bshowspell = false;

local function APB_MaxSpell(max)
    max_spell = max;

    if not max or max == 0 then
        for i = 1, 10 do
            local spellbar = APB.spellbar[i];

            if spellbar then
                spellbar:Hide();
                ns.lib.PixelGlow_Stop(spellbar);
                spellbar.isAlert = false;
            end
        end
        bshowspell = false;
        return;
    end

    local width = (APB_WIDTH - (3 * (max - 1))) / max;

    for i = 1, 10 do
        local spellbar = APB.spellbar[i];
        if spellbar then
            spellbar:SetWidth(width)
            spellbar.start = nil;
            spellbar:SetMinMaxValues(0, 1)
            spellbar:SetValue(1)
            local _, Class = UnitClass("player")
            local color = RAID_CLASS_COLORS[Class]
            spellbar:SetStatusBarColor(color.r, color.g, color.b);
            if spellbar.ctimer then
                spellbar.ctimer:Cancel();
            end
            ns.lib.PixelGlow_Stop(spellbar);
            spellbar.isAlert = false;

            if i > max then
                spellbar:Hide()
            else
                spellbar:Show()
            end
        end
    end
    bshowspell = true;
end

local function APB_ShowComboBar(combobar, combo, partial, cast, cooldown, buffexpire)
    local bmax = false;
    local bmaxminus1 = false;
    local bhalf = false;
    local balert = false;

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

    if combo > 20 then
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

    if combo == combobar.max_combo then
        bmax = true;
    elseif combo == combobar.max_combo - 1 then
        bmaxminus1 = true;
    elseif combo >= (combobar.max_combo / 2) then
        bhalf = bhalf_combo;
    end

    if partial > 0 then
        value = partial;
    end

    local comboAlerts = {};
    local comboalert = false;

    -- 문책
    if brogue then
        local chargedPowerPoints = GetUnitChargedPowerPoints("player");
        for i = 1, combobar.max_combo do
            local isCharged = chargedPowerPoints and tContains(chargedPowerPoints, i) or false;

            if isCharged then
                comboAlerts[i] = true;
            end
        end
    end

    if combobuffalertlist and APB and combobar == APB.combobar then
        local name = APB_UnitBuffList("player", combobuffalertlist);

        if name then
            for i = 1, combobar.max_combo do
                comboAlerts[i] = true;
            end
        end
    end

    if combobuffcountalertlist and APB and combobar == APB.combobar then
        local name = APB_UnitBuffCountList("player", combobuffcountalertlist);

        if name then
            for i = 1, combobar.max_combo do
                comboAlerts[i] = true;
            end
        end
    end

    if combobuffcoloralertlist and APB and combobar == APB.combobar then
        local name = APB_UnitBuffList("player", combobuffcoloralertlist);

        if name then
            balert = true;
        end
    end

    if bdeathstalker and APB and combobar == APB.combobar then
        local name, _, count = APB_UnitDebuff("target", 457129);

        if name then
            comboAlerts[5] = true;
            APB.combotext:SetText(count);
            APB.combotext:Show();
        else
            APB.combotext:SetText("");
            APB.combotext:Hide();
        end

        name = APB_UnitBuff("player", 457280);

        if name then
            comboAlerts[combobar.max_combo] = true;
        end
    end

    if buffexpire and cooldown then
        combobar[1]:SetStatusBarColor(0.8, 0.5, 0.8);
        combobar[1].start = (buffexpire - cooldown);
        combobar[1].duration = cooldown
        combobar[1].reverse = true;
        local cb = function()
            APB_OnUpdateCombo(combobar[1]);
        end

        if combobar[1].ctimer == nil or combobar[1].ctimer:IsCancelled() then
            combobar[1].ctimer = C_Timer.NewTicker(0.1, cb);
        end

        return;
    end

    for i = 1, combobar.max_combo do
        combobar[1].reverse = nil;

        if i <= combo then
            if combobar[i].ctimer then
                combobar[i].ctimer:Cancel();
            end
            combobar[i]:Show();
            combobar[i]:SetValue(1)
            combobar[i]:SetMinMaxValues(0, 1)

            if balert then
                combobar[i]:SetStatusBarColor(0, 1, 1);
            elseif bmax then
                combobar[i]:SetStatusBarColor(1, 0, 0);
            elseif bhalf or bmaxminus1 then
                combobar[i]:SetStatusBarColor(1, 0.8, 0);
            else
                combobar[i]:SetStatusBarColor(color.r, color.g, color.b);
            end
        elseif i <= (combo + cast) then
            if combobar[i].ctimer then
                combobar[i].ctimer:Cancel();
            end

            combobar[i]:Show();
            combobar[i]:SetValue(1)
            combobar[i]:SetMinMaxValues(0, 1)

            if gen == false then
                combobar[i]:SetStatusBarColor(0.5, 0.5, 0.5);
            else
                combobar[i]:SetStatusBarColor(1, 1, 1);
            end
        elseif i == (combo + cast) + 1 and value < 1 then
            if combobar[i].ctimer then
                combobar[i].ctimer:Cancel();
            end

            combobar[i]:Show();
            combobar[i]:SetValue(value)

            if balert then
                combobar[i]:SetStatusBarColor(0, 1, 1);
            elseif bmax then
                combobar[i]:SetStatusBarColor(1, 0, 0);
            elseif bhalf or bmaxminus1 then
                combobar[i]:SetStatusBarColor(1, 0.8, 0);
            else
                combobar[i]:SetStatusBarColor(color.r, color.g, color.b);
            end
        elseif i == (combo + cast) + 1 and cooldown then
            combobar[i]:SetStatusBarColor(0.3, 0.3, 0.3);
            combobar[i].start = p_start;
            combobar[i].duration = cooldown;

            local cb = function()
                APB_OnUpdateCombo(combobar[i]);
            end

            if combobar[i].ctimer == nil or combobar[i].ctimer:IsCancelled() then
                combobar[i].ctimer = C_Timer.NewTicker(0.1, cb);
            end
        else
            if combobar[i].ctimer then
                combobar[i].ctimer:Cancel();
            end

            combobar[i]:Show();
            combobar[i]:SetValue(0)
        end
    end

    if bupdate_partial_power then
        local power = combo + partial;

        if gen == true then
            power = power + cast;
        end

        if power > combobar.max_combo then
            power = combobar.max_combo;
        end

        if APB then
            local combotext = APB.combotext
            combotext:SetText(power);
            combotext:Show();
        end
    end

    if druidcomboalertid then
        local name, icon, count, debuffType, duration, expirationTime, caster = APB_UnitBuff("player", druidcomboalertid);

        if name and count and count < combobar.max_combo then
            for i = 1, count do
                combobar[i]:SetStatusBarColor(0, 0.5, 1);
            end
        end
    end

    for i = 1, combobar.max_combo do
        if comboAlerts[i] then
            if not combobar[i].isAlert then
                ns.lib.PixelGlow_Start(combobar[i], { 0.5, 0.5, 1 }, nil, nil, nil, 0.5);
                combobar[i].isAlert = true;
            end
        else
            ns.lib.PixelGlow_Stop(combobar[i]);
            combobar[i].isAlert = false;
        end
    end
end


local bshowstack = false;

local function APB_MaxStack(max)
    if not max or max == 0 then
        APB.stackbar[0]:Hide();
        bshowstack = false;
        return;
    end

    APB.stackbar[0]:SetMinMaxValues(0, max);
    APB.stackbar[0]:Show();
    APB.stackbar[0].max = max;

    APB.stackbar[0].count:Show();


    bshowstack = true;

    if bshowspell then
        APB.spellbar[1]:SetPoint("BOTTOMLEFT", APB.stackbar[0], "TOPLEFT", 0, 1);
    else
        APB.combobar[1]:SetPoint("BOTTOMLEFT", APB.stackbar[0], "TOPLEFT", 0, 1);
    end
end


local function APB_UpdateBuffStack(stackbar)
    if not (APB_BUFF_STACK or APB_BUFF_TIME_STACK or APB_DEBUFF_STACK or APB_DEBUFF_TIME_STACK or APB_ACTION_STACK or bupdate_enhaced_tempest or bupdate_element_tempest) then
        return;
    end

    if not bshowstack then
        return;
    end

    if APB_BUFF_STACK then
        local name, icon, count, debuffType, duration, expirationTime, caster = APB_UnitBuff(stackbar.unit,
            APB_BUFF_STACK);

        if name then
            if count >= stackbar.max then
                stackbar:SetValue(stackbar.max);
                stackbar:GetStatusBarTexture():SetVertexColor(APB_STACKBAR_COLOR_ALERT[1],
                    APB_STACKBAR_COLOR_ALERT[2], APB_STACKBAR_COLOR_ALERT[3]);
            else
                stackbar:SetValue(count);
                stackbar:GetStatusBarTexture():SetVertexColor(APB_STACKBAR_COLOR_NORMAL[1],
                    APB_STACKBAR_COLOR_NORMAL[2], APB_STACKBAR_COLOR_NORMAL[3]);
            end
            stackbar.prevcount = count;
            stackbar.count:SetText(count);
        else
            stackbar:SetValue(0);
            stackbar.count:SetText(count);
        end
    end

    if APB_BUFF_TIME_STACK then
        local name, icon, count, debuffType, duration, expirationTime, caster = APB_UnitBuff(stackbar.unit,
            APB_BUFF_TIME_STACK);

        local text = 0;
        if name then
            local remain = expirationTime - GetTime();
            stackbar:SetValue(stackbar.max - remain);
            stackbar:GetStatusBarTexture():SetVertexColor(APB_STACKBAR_COLOR_NORMAL[1],
                APB_STACKBAR_COLOR_NORMAL[2], APB_STACKBAR_COLOR_NORMAL[3]);

            text = math.ceil(remain);
            if bupdate_Howl_Pack and next_howl then
                text = next_howl .. " " .. text;
            end

            stackbar.count:SetText(text);
        else
            stackbar:SetValue(stackbar.max);

            if bupdate_Howl_Pack and next_howl then
                text = next_howl .. " " .. text;
            end

            stackbar:GetStatusBarTexture():SetVertexColor(APB_STACKBAR_COLOR_ALERT[1],
                APB_STACKBAR_COLOR_ALERT[2], APB_STACKBAR_COLOR_ALERT[3]);

            stackbar.count:SetText(text);
        end
    end

    if APB_DEBUFF_STACK then
        local name, icon, count, debuffType, duration, expirationTime, caster = APB_UnitDebuff(stackbar.unit,
            APB_DEBUFF_STACK);

        if name then
            if count >= stackbar.max then
                stackbar:SetValue(stackbar.max);
                stackbar:GetStatusBarTexture():SetVertexColor(APB_STACKBAR_COLOR_ALERT[1],
                    APB_STACKBAR_COLOR_ALERT[2], APB_STACKBAR_COLOR_ALERT[3]);
            else
                stackbar:SetValue(count);
                stackbar:GetStatusBarTexture():SetVertexColor(APB_STACKBAR_COLOR_NORMAL[1],
                    APB_STACKBAR_COLOR_NORMAL[2], APB_STACKBAR_COLOR_NORMAL[3]);
            end

            stackbar.prevcount = count;
            stackbar.count:SetText(count);
        else
            stackbar:SetValue(0);
            stackbar.count:SetText(count);
        end
    end

    if APB_DEBUFF_TIME_STACK then
        local name, icon, count, debuffType, duration, expirationTime, caster = APB_UnitDebuff(stackbar.unit,
            APB_DEBUFF_TIME_STACK);

        local text = 0;
        if name then
            local remain = expirationTime - GetTime();
            stackbar:SetValue(stackbar.max - remain);
            stackbar:GetStatusBarTexture():SetVertexColor(APB_STACKBAR_COLOR_NORMAL[1],
                APB_STACKBAR_COLOR_NORMAL[2], APB_STACKBAR_COLOR_NORMAL[3]);

            text = math.ceil(remain);
            stackbar.count:SetText(text);
        else
            stackbar:SetValue(stackbar.max);
            stackbar:GetStatusBarTexture():SetVertexColor(APB_STACKBAR_COLOR_ALERT[1],
                APB_STACKBAR_COLOR_ALERT[2], APB_STACKBAR_COLOR_ALERT[3]);

            stackbar.count:SetText(text);
        end
    end


    if APB_ACTION_STACK then
        local count = GetActionCount(APB_ACTION_STACK)

        if count >= stackbar.max then
            stackbar:SetValue(stackbar.max);
            stackbar:GetStatusBarTexture():SetVertexColor(APB_STACKBAR_COLOR_ALERT[1], APB_STACKBAR_COLOR_ALERT
                [2], APB_STACKBAR_COLOR_ALERT[3]);
        else
            stackbar:SetValue(count);
            stackbar:GetStatusBarTexture():SetVertexColor(APB_STACKBAR_COLOR_NORMAL[1],
                APB_STACKBAR_COLOR_NORMAL[2], APB_STACKBAR_COLOR_NORMAL[3]);
        end
        stackbar.prevcount = count;
        stackbar.count:SetText(count);
    end

    if bupdate_enhaced_tempest or bupdate_element_tempest then
        local count = tempeststate.TempestStacks

        if count >= stackbar.max then
            count = stackbar.max
            stackbar:GetStatusBarTexture():SetVertexColor(APB_STACKBAR_COLOR_NORMAL[1],
                APB_STACKBAR_COLOR_NORMAL[2], APB_STACKBAR_COLOR_NORMAL[3]);
        elseif bupdate_enhaced_tempest and count <= 10 then
            stackbar:GetStatusBarTexture():SetVertexColor(APB_STACKBAR_COLOR_ALERT[1], APB_STACKBAR_COLOR_ALERT
                [2], APB_STACKBAR_COLOR_ALERT[3]);
        elseif bupdate_element_tempest and count <= 50 then
            stackbar:GetStatusBarTexture():SetVertexColor(APB_STACKBAR_COLOR_ALERT[1], APB_STACKBAR_COLOR_ALERT
                [2], APB_STACKBAR_COLOR_ALERT[3]);
        else
            stackbar:GetStatusBarTexture():SetVertexColor(APB_STACKBAR_COLOR_NORMAL[1],
                APB_STACKBAR_COLOR_NORMAL[2], APB_STACKBAR_COLOR_NORMAL[3]);
        end
        stackbar:SetValue(count);
        stackbar.prevcount = count;
        stackbar.count:SetText(count);

        local balert = false;

        local name = APB_UnitBuff("player", 454015);

        if name then
            balert = true;
        end

        if balert then
            stackbar:GetStatusBarTexture():SetVertexColor(APB_STACKBAR_COLOR_ALERT2[1], APB_STACKBAR_COLOR_ALERT2
                [2], APB_STACKBAR_COLOR_ALERT2[3]);
        end
    end
end


local bupdatecombo = false;

local function APB_MaxCombo(combobar, max)
    combobar.max_combo = max;

    local gap = 3;

    if not max or max == 0 then
        for i = 1, 20 do
            combobar[i]:Hide();
        end
        bupdatecombo = false;
        return;
    end

    if combobar == APB.combobar2 then
        gap = 0;
    elseif max >= 10 then
        gap = 1;
    end

    local width = (APB_WIDTH - (gap * (max - 1))) / max;


    for i = 1, 20 do
        combobar[i]:SetWidth(width)
        combobar[i].start = nil;
        combobar[i]:SetMinMaxValues(0, 1)
        combobar[i]:SetValue(1)
        local _, Class = UnitClass("player")
        local color = RAID_CLASS_COLORS[Class]
        combobar[i]:SetStatusBarColor(color.r, color.g, color.b);

        if combobar[i].ctimer then
            combobar[i].ctimer:Cancel();
        end

        if i > 1 then
            combobar[i]:SetPoint("LEFT", combobar[i - 1], "RIGHT", gap, 0);
        end

        if i > max then
            combobar[i]:Hide()
        else
            combobar[i]:Show()
        end
    end

    if combobar == APB.combobar2 and APB.combobar[1]:IsShown() then
        combobar[1]:SetPoint("BOTTOMLEFT", APB.combobar[1], "TOPLEFT", 0, 1);
    elseif bshowspell then
        combobar[1]:SetPoint("BOTTOMLEFT", APB.spellbar[1], "TOPLEFT", 0, 1);
    elseif bshowstack then
        combobar[1]:SetPoint("BOTTOMLEFT", APB.stackbar[0], "TOPLEFT", 0, 1);
    else
        combobar[1]:SetPoint("BOTTOMLEFT", APB.buffbar[0], "TOPLEFT", 0, 1);
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
                APB_BUFF_COMBO_MAX);

            if APB_BUFF_COMBO_MAX ~= APB_BUFF_COMBO then
                if name and duration > 0 then
                    if combobar.max_combo > 1 then
                        APB_ShowComboBar(combobar, APB_BUFF_COMBO_MAX_COUNT);
                        APB_MaxCombo(combobar, 1);
                    end
                    local remain = expirationTime - GetTime();

                    APB_ShowComboBar(combobar, 0, nil, nil, duration, expirationTime);
                    return;
                else
                    APB_MaxCombo(combobar, APB_BUFF_COMBO_MAX_COUNT);
                end
            else
                if count and count == APB_BUFF_COMBO_MAX_COUNT and duration > 0 then
                    if combobar.max_combo > 1 then
                        APB_ShowComboBar(combobar, APB_BUFF_COMBO_MAX_COUNT);
                        APB_MaxCombo(combobar, 1);
                    end
                    local remain = expirationTime - GetTime();



                    APB_ShowComboBar(combobar, 0, nil, nil, duration, expirationTime);
                    return;
                else
                    APB_MaxCombo(combobar, APB_BUFF_COMBO_MAX_COUNT);
                end
            end
        end

        local name, icon, count, debuffType, duration, expirationTime, caster = APB_UnitBuff(combobar.unit,
            APB_BUFF_COMBO);

        if name then
            APB_ShowComboBar(combobar, count);
        else
            APB_ShowComboBar(combobar, 0);
        end
    end

    if APB_DEBUFF_COMBO then
        local name, icon, count, debuffType, duration, expirationTime, caster = APB_UnitDebuff(combobar.unit,
            APB_DEBUFF_COMBO);

        if name then
            APB_ShowComboBar(combobar, count);
        else
            APB_ShowComboBar(combobar, 0);
        end
    end

    if APB_ACTION_COMBO then
        local count = GetActionCount(APB_ACTION_COMBO)

        if count then
            APB_ShowComboBar(combobar, count);
        else
            APB_ShowComboBar(combobar, 0);
        end
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

local function APB_OnUpdateBuff(self)
    if not self.start then
        self:SetValue(0);
        self.castbar:Hide();
        return;
    end


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

local function APB_UpdateBuff(buffbar)
    if not (buffbar.buff or buffbar.debuff) then
        return;
    end

    local bbuff2 = false;
    local balert = false;

    if buffbar.buff then
        local name, icon, count, debuffType, duration, expirationTime, caster;

        if buffbar.buff2 then
            name, icon, count, debuffType, duration, expirationTime, caster =
                APB_UnitBuff(buffbar.unit, buffbar.buff2);
            if name then
                buffbar.tooltip = buffbar.buff2;
                bbuff2 = true;
            end
        end

        if not name then
            buffbar.tooltip = buffbar.buff;
            name, icon, count, debuffType, duration, expirationTime, caster =
                APB_UnitBuff(buffbar.unit, buffbar.buff);
        end

        if name then
            buffbar.start = expirationTime - duration;
            buffbar.duration = duration;
            if bupdate_buff_count then
                buffbar.count:SetText(count);
                if buffbar.alertcount and count >= buffbar.alertcount then
                    balert = true;
                end
            end
        else
            buffbar.start = nil;
            buffbar:SetMinMaxValues(0, 1)
            buffbar:SetValue(0)
            buffbar.text:SetText("");
            buffbar.count:SetText("");
        end

        if balert then
            buffbar:SetStatusBarColor(0.3, 1, 0.7);
        elseif bbuff2 then
            buffbar:SetStatusBarColor(0.7, 0.9, 0.9);
        else
            buffbar:SetStatusBarColor(0.8, 0.8, 1);
        end

        buffbar:Show();
        buffbar.text:Show();
        buffbar.count:Show();

        if buffbar.buff3 then
            name, icon, count, debuffType, duration, expirationTime, caster =
                APB_UnitBuff(buffbar.unit, buffbar.buff3);
            if name then
                buffbar.buff3barex = expirationTime;
            else
                buffbar.buff3barex = nil;
            end
        end
    end

    if buffbar.debuff then
        local name, icon, count, debuffType, duration, expirationTime, caster =
            APB_UnitDebuff(buffbar.unit, buffbar.debuff);

        if name then
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
        local cb = function()
            APB_OnUpdateBuff(buffbar);
        end
        if buffbar.ctimer == nil or buffbar.ctimer:IsCancelled() then
            buffbar.ctimer = C_Timer.NewTicker(0.1, cb);
        end
    else
        if buffbar.ctimer then
            buffbar.ctimer:Cancel();
        end
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

            local cb = function()
                APB_OnUpdateBuff(self);
            end
            if self.ctimer == nil or self.ctimer:IsCancelled() then
                self.ctimer = C_Timer.NewTicker(0.1, cb);
            end
        else
            self:SetMinMaxValues(0, 1)
            self:SetValue(0)
            self.text:SetText("");
            self.start = 0;
            self.duraton = duration;
            self.castbar:Hide();
            if self.ctimer then
                self.ctimer:Cancel();
            end
        end
        self.count:SetText("");
        self:Show();
        self.tooltip = "FrozenOrbTime";
    end
end


local function APB_MaxRune()
    local max = 6;
    local width = (APB_WIDTH - (3 * (max - 1))) / max;
    local combobar = APB.combobar;

    for i = 1, 20 do
        combobar[i]:Hide();
    end

    for i = 1, 6 do
        combobar[i]:SetWidth(width)
        combobar[i]:Show();
    end

    if bshowspell then
        combobar[1]:SetPoint("BOTTOMLEFT", APB.spellbar[1], "TOPLEFT", 0, 1);
    elseif bshowstack then
        combobar[1]:SetPoint("BOTTOMLEFT", APB.stackbar[0], "TOPLEFT", 0, 1);
    else
        combobar[1]:SetPoint("BOTTOMLEFT", APB.buffbar[0], "TOPLEFT", 0, 1);
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

    local combobar = APB.combobar;

    for i, index in ipairs(APB.runeIndexes) do
        local start, duration, runeReady = GetRuneCooldown(index);

        if runeReady then
            combobar[i].start = nil;
            -- combobar[i2]:SetStatusBarColor(1,1,0)

            local _, Class = UnitClass("player")
            local color = RAID_CLASS_COLORS[Class]
            combobar[i]:SetStatusBarColor(color.r, color.g, color.b);

            combobar[i]:SetMinMaxValues(0, 1)
            combobar[i]:SetValue(1)
            if combobar[i].ctimer then
                combobar[i].ctimer:Cancel();
            end
        else
            combobar[i]:SetStatusBarColor(1, 1, 1)
            combobar[i].start = start;
            combobar[i].duration = duration;

            local cb = function()
                APB_OnUpdateCombo(combobar[i]);
            end
            if combobar[i].ctimer == nil or combobar[i].ctimer:IsCancelled() then
                combobar[i].ctimer = C_Timer.NewTicker(0.1, cb);
            end
        end
    end
end

local function APB_UpdatePower()
    if bupdate_power == false then
        return;
    end

    local combobar = APB.combobar;

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
        APB_MaxCombo(combobar, max);
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

    APB_ShowComboBar(combobar, power, partial, cast, cooldownDuration);
end

local bupdate_druid = false;

local function APB_GetActionSlots(arg1)
    local ret = {};
    local spellname = asGetSpellInfo(arg1);

    for lActionSlot = 1, 180 do
        local type, id, subType, spellID = GetActionInfo(lActionSlot);

        if id and type and type == "macro" then
            local name = asGetSpellInfo(id);
            if name and name == spellname then
                ret[lActionSlot] = true;
            end
        end
    end

    for lActionSlot = 1, 180 do
        local type, id, subType, spellID = GetActionInfo(lActionSlot);

        if id and type and type == "spell" then
            local name = asGetSpellInfo(id);
            if name and name == spellname then
                ret[lActionSlot] = true;
            end
        end
    end



    return ret;
end

local function APB_GetActionSlot(arg1)
    local ret;
    local spellname = asGetSpellInfo(arg1);

    for lActionSlot = 1, 180 do
        local type, id, subType, spellID = GetActionInfo(lActionSlot);

        if id and type and type == "macro" then
            local name = asGetSpellInfo(id);
            if name and name == spellname then
                ret = lActionSlot;
            end
        end
    end

    for lActionSlot = 1, 180 do
        local type, id, subType, spellID = GetActionInfo(lActionSlot);

        if id and type and type == "spell" then
            local name = asGetSpellInfo(id);
            if name and name == spellname then
                ret = lActionSlot;
            end
        end
    end

    return ret;
end

local curr_maxspell = nil;
local curr_maxspell2 = nil;

local function APB_SpellMax(spell, spell2)
    local newspell, _, _, _, _, _, spellid = asGetSpellInfo(spell);
    local Charges, maxCharges = asGetSpellCharges(spellid);

    if bupdate_druid then
        maxCharges = 2;
    end

    local boverided = false;
    if spell ~= spellid then
        boverided = true;
    end

    if Charges == nil and maxCharges == nil and boverided then
        maxCharges, Charges = 1, 1;
    end

    curr_maxspell = maxCharges;

    if spell2 then
        local newspell2, _, _, _, _, _, spellid2 = asGetSpellInfo(spell2);
        local Charges2, maxCharges2 = asGetSpellCharges(spell2);
        local isUsable2 = C_Spell.IsSpellUsable(spellid2);

        if bupdate_druid then
            maxCharges2 = 2;
        end

        local boverided = false;
        if spell2 ~= spellid2 then
            boverided = true;
        end

        if Charges2 == nil and maxCharges2 == nil and boverided then
            maxCharges2, Charges2 = 1, 1;
        end

        if maxCharges2 then
            maxCharges = maxCharges + maxCharges2
            curr_maxspell2 = maxCharges2;
        end
    end

    if maxCharges and maxCharges > 0 then
        APB_MaxSpell(maxCharges);
    else
        APB_MaxSpell(0);
    end

    if bshowstack then
        APB.spellbar[1]:SetPoint("BOTTOMLEFT", APB.stackbar[0], "TOPLEFT", 0, 1);
    else
        APB.spellbar[1]:SetPoint("BOTTOMLEFT", APB.buffbar[0], "TOPLEFT", 0, 1);
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
            elseif s.tooltip and type(s.tooltip) == "number" then
                GameTooltip_SetDefaultAnchor(GameTooltip, s);
                GameTooltip:SetSpellByID(s.tooltip);
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
    local newspell, _, _, _, _, _, spellid = asGetSpellInfo(spell);

    if not spellid then
        return;
    end
    local charges, maxCharges, chargeStart, chargeDuration = asGetSpellCharges(spellid);
    local _, notEnoughMana = C_Spell.IsSpellUsable(spellid);
    local boverided = false;
    local colorbuffed = false;
    if spell ~= spellid then
        boverided = true;
    end

    if bupdate_druid then
        charges = C_Spell.GetSpellCastCount(spellid);
        maxCharges = 2;
        chargeStart = 0;
        chargeDuration = 0;
    end

    if maxCharges == nil and charges == nil and boverided then
        maxCharges, charges = 1, 1;
    end

    if maxCharges ~= curr_maxspell then
        APB_SpellMax(spell, spell2)
    end

    if not charges or not maxCharges then
        return;
    end

    if spellbuffcolorlist then
        local name = APB_UnitBuffList("player", spellbuffcolorlist);

        if name then
            colorbuffed = true;
        end
    end

    for i = 1, charges do
        local spellbar = APB.spellbar[i];
        spellbar.start = nil;
        --	spellbar:SetStatusBarColor(1,1,0)
        local _, Class = UnitClass("player")
        local color = RAID_CLASS_COLORS[Class]
        local rate = 0;
        local rate2 = 0;

        if bupdatecombo then
            rate = 0.2;
        end

        if boverided then
            rate2 = 0.3;
        end
        spellbar:SetStatusBarColor(color.r + rate, color.g + rate, color.b + rate + rate2);

        spellbar:SetMinMaxValues(0, 1)
        spellbar:SetValue(1);

        if spellbar.ctimer then
            spellbar.ctimer:Cancel();
        end
        spellbar.spellid = spellid;

        if balert then
            if not spellbar.isAlert then
                ns.lib.PixelGlow_Start(spellbar, nil, nil, nil, nil, 0.5);
                spellbar.isAlert = true;
            end
        else
            ns.lib.PixelGlow_Stop(spellbar);
            spellbar.isAlert = false;
        end

        if inrange == false then
            spellbar:SetStatusBarColor(0.6, 0, 0);
        elseif notEnoughMana then
            spellbar:SetStatusBarColor(0.3, 0.3, 0.3);
        elseif colorbuffed then
            spellbar:SetStatusBarColor(0, 0.5, 0);
        end
    end

    if charges < maxCharges then
        local spellbar = APB.spellbar[charges + 1];
        spellbar:SetStatusBarColor(1, 1, 1)
        spellbar.start = chargeStart;
        spellbar.duration = chargeDuration;

        local cb = function()
            APB_OnUpdateCombo(spellbar);
        end
        spellbar.spellid = spellid;
        if spellbar.ctimer == nil or spellbar.ctimer:IsCancelled() then
            spellbar.ctimer = C_Timer.NewTicker(0.1, cb);
        end

        if balert then
            if not spellbar.isAlert then
                ns.lib.PixelGlow_Start(spellbar, nil, nil, nil, nil, 0.5);
                spellbar.isAlert = true;
            end
        else
            ns.lib.PixelGlow_Stop(spellbar);
            spellbar.isAlert = false;
        end

        if inrange == false then
            spellbar:SetStatusBarColor(0.6, 0, 0);
        elseif notEnoughMana then
            spellbar:SetStatusBarColor(0.3, 0.3, 0.3);
        elseif colorbuffed then
            spellbar:SetStatusBarColor(0.8, 1, 0.8);
        end
    end

    if charges < maxCharges - 1 then
        for i = charges + 2, maxCharges do
            local spellbar = APB.spellbar[i];
            spellbar:SetValue(0)
            spellbar.start = nil;
            if spellbar.ctimer then
                spellbar.ctimer:Cancel();
            end
            ns.lib.PixelGlow_Stop(spellbar);
            spellbar.isAlert = false;
        end
    end

    if spell2 then
        local newspell2, _, _, _, _, _, spellid = asGetSpellInfo(spell2);
        local charges, maxCharges2, chargeStart, chargeDuration = asGetSpellCharges(spellid);
        local boverided = false
        local colorbuffed = false

        if not spellid then
            return;
        end

        if spell2 ~= spellid then
            boverided = true;
        end

        local _, notEnoughMana = C_Spell.IsSpellUsable(spellid);

        if bupdate_druid then
            charges = C_Spell.GetSpellCastCount(spellid);
            maxCharges2 = 2;
            chargeStart = 0;
            chargeDuration = 0;
        end

        if maxCharges2 == nil and charges == nil and boverided then
            maxCharges2, charges = 1, 1;
        end

        if maxCharges2 ~= curr_maxspell2 then
            APB_SpellMax(spell, spell2)
        end

        if not charges or not maxCharges2 then
            return;
        end

        if spell2buffcolorlist then
            local name = APB_UnitBuffList("player", spell2buffcolorlist);

            if name then
                colorbuffed = true;
            end
        end


        for i = maxCharges + 1, maxCharges + charges do
            local spellbar = APB.spellbar[i];
            local rate2 = 0;

            if boverided then
                --rate2 = 0.3;
            end

            spellbar.start = nil;

            spellbar:SetStatusBarColor(1, 0.7, 0.3 + rate2);

            spellbar:SetMinMaxValues(0, 1)
            spellbar:SetValue(1)
            if spellbar.ctimer then
                spellbar.ctimer:Cancel();
            end
            spellbar.spellid = spellid;

            if balert2 then
                if not spellbar.isAlert then
                    ns.lib.PixelGlow_Start(spellbar, nil, nil, nil, nil, 0.5);
                    spellbar.isAlert = true;
                end
            else
                ns.lib.PixelGlow_Stop(spellbar);
                spellbar.isAlert = false;
            end

            if inrange2 == false then
                spellbar:SetStatusBarColor(0.3, 0, 0);
            elseif notEnoughMana then
                spellbar:SetStatusBarColor(0.6, 0.6, 0.6);
            elseif colorbuffed then
                spellbar:SetStatusBarColor(0, 0.8, 0);
            end
        end

        if charges < maxCharges2 then
            local spellbar = APB.spellbar[maxCharges + charges + 1];
            spellbar:SetStatusBarColor(0.5, 0.5, 0.5)
            spellbar.start = chargeStart;
            spellbar.duration = chargeDuration;

            local cb = function()
                APB_OnUpdateCombo(spellbar);
            end
            spellbar.spellid = spellid;
            if spellbar.ctimer == nil or spellbar.ctimer:IsCancelled() then
                spellbar.ctimer = C_Timer.NewTicker(0.1, cb);
            end

            if balert2 then
                if not spellbar.isAlert then
                    ns.lib.PixelGlow_Start(spellbar, nil, nil, nil, nil, 0.5);
                    spellbar.isAlert = true;
                end
            else
                ns.lib.PixelGlow_Stop(spellbar);
                spellbar.isAlert = false;
            end

            if inrange2 == false then
                spellbar:SetStatusBarColor(0.3, 0, 0);
            elseif notEnoughMana then
                spellbar:SetStatusBarColor(0.6, 0.6, 0.6);
            elseif colorbuffed then
                spellbar:SetStatusBarColor(0.9, 1, 0.9);
            end
        end

        if charges < maxCharges2 - 1 then
            for i = maxCharges + charges + 2, maxCharges + maxCharges2 do
                local spellbar = APB.spellbar[i];
                spellbar:SetValue(0)
                spellbar.start = nil;
                if spellbar.ctimer then
                    spellbar.ctimer:Cancel();
                end
                ns.lib.PixelGlow_Stop(spellbar);
                spellbar.isAlert = false;
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

    do
        local balert = false;
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



local function updatePowerBar()
    APB_Update(APB);
end

local function updateBuffBar()
    APB_UpdateBuff(APB.buffbar[0]);
    APB_UpdateBuff(APB.buffbar[1]);
    APB_UpdateBuffCombo(APB.buffcombobar);
    APB_UpdateBuffStack(APB.stackbar[0]);
    APB_UpdateStagger(APB.buffbar[0]);
end

local function updatePower()
    APB_UpdatePower();
end

local function APB_InitPowerBar(self)
    self:RegisterUnitEvent("UNIT_SPELLCAST_START", "player");
    self:RegisterUnitEvent("UNIT_SPELLCAST_STOP", "player");
    self:RegisterUnitEvent("UNIT_SPELLCAST_FAILED", "player");
    self:RegisterUnitEvent("UNIT_SPELLCAST_SUCCEEDED", "player");
end


local function HowManyHasSet(setID)
    local itemList = C_LootJournal.GetItemSetItems(setID)
    if not itemList then
        return 0
    end
    local setName = C_Item.GetItemSetInfo(setID)
    local max = #itemList
    local equipped = 0
    for _, v in ipairs(itemList) do
        if C_Item.IsEquippedItem(v.itemID) then
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
    APB:UnregisterEvent("UNIT_SPELLCAST_START");
    APB:UnregisterEvent("UNIT_SPELLCAST_STOP");
    APB:UnregisterEvent("UNIT_SPELLCAST_FAILED");
    APB:UnregisterEvent("UNIT_SPELLCAST_SUCCEEDED");
    APB:UnregisterEvent("UNIT_SPELLCAST_CHANNEL_START");
    APB:UnregisterEvent("UNIT_SPELLCAST_CHANNEL_STOP");
    APB:UnregisterEvent("PLAYER_TARGET_CHANGED");
    APB:UnregisterEvent("COMBAT_LOG_EVENT_UNFILTERED");

    if APB.timerPowerBar then
        APB.timerPowerBar:Cancel()
    end

    if APB.timerPower then
        APB.timerPower:Cancel()
    end

    if APB.timerBuffBar then
        APB.timerBuffBar:Cancel()
    end

    bshowspell = false;
    bshowstack = false;
    bupdate_power = false;
    bupdate_rune = false;
    bupdate_spell = false;
    bupdate_buff_count = false;
    bupdate_buff_combo = false;
    bupdate_stagger = false;
    bupdate_fronzen = false;
    bupdate_partial_power = false;
    bsmall_power_bar = false;
    bhalf_combo = false;
    bupdate_enhaced_tempest = false;
    bupdate_element_tempest = false;
    bupdate_Howl_Pack = false;
    bdruid = false;
    brogue = false;
    bdeathstalker = nil;
    combobuffalertlist = nil;
    combodebuffalertlist = nil;
    combobuffcountalertlist = nil;
    combobuffcoloralertlist = nil;
    druidcomboalertid = nil;
    spellbuffcolorlist = nil;
    spell2buffcolorlist = nil;

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
    APB_BUFF_STACK = nil;
    APB_BUFF_TIME_STACK = nil;
    APB_DEBUFF_STACK = nil;
    APB_DEBUFF_TIME_STACK = nil;
    APB_ACTION_STACK = nil;
    APB_BUFF_COMBO_MAX = nil;
    APB_BUFF_COMBO_MAX_COUNT = nil;
    APB_DEBUFF_COMBO = nil;
    APB_ACTION_COMBO = nil;

    ns.ClearLists();

    APB.bar:Hide();
    APB.bar.text:SetText("");
    APB.bar.count:SetText("");
    setupMouseOver(APB.bar);

    APB.combotext:SetText("");
    APB.combotext:Hide();
    APB.combotext2:SetText("");
    APB.combotext2:Hide();
    APB.buffcombobar = APB.combobar;

    for i = 1, 20 do
        ns.lib.PixelGlow_Stop(APB.combobar[i]);
        APB.combobar[i].isAlert = false;
        setupMouseOver(APB.combobar[i]);

        ns.lib.PixelGlow_Stop(APB.combobar2[i]);
        APB.combobar2[i].isAlert = false;
        setupMouseOver(APB.combobar2[i]);
    end

    APB_MaxCombo(self.combobar, 0);
    APB_MaxCombo(self.combobar2, 0);

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

        for i = 1, 10 do
            APB.buffbar[j].square[i]:Hide();
        end
    end

    for j = 0, 0 do
        APB.stackbar[j]:Hide();
        APB.stackbar[j].count:SetText("");
        APB.stackbar[j].castbar:Hide();
        APB.stackbar[j].max = nil;
        APB.stackbar[j].spellid = nil;
        if APB.stackbar[j].ctimer then
            APB.stackbar[j].ctimer:Cancel();
        end


        setupMouseOver(APB.stackbar[j]);
    end
    bshowstack = false;

    if (englishClass == "EVOKER") then
        -- 기원사
        APB_UNIT_POWER = "POWER_TYPE_ESSENCE";
        APB_POWER_LEVEL = Enum.PowerType.Essence;
        APB:RegisterUnitEvent("UNIT_POWER_UPDATE", "player");
        APB:RegisterUnitEvent("UNIT_DISPLAYPOWER", "player");
        bupdate_power = true;
        bsmall_power_bar = true;

        if IsPlayerSpell(443328) then --업화
            APB_SPELL = 443328;
            APB_SpellMax(APB_SPELL);
            APB_UpdateSpell(APB_SPELL);
            bupdate_spell = true;
        end

        if IsPlayerSpell(357211) then --기염
            APB_ACTION_STACK = APB_GetActionSlot(357211);
            APB.stackbar[0].spellid = 357211;
            APB_MaxStack(20);
        end

        if (spec and spec == 2) then
            bsmall_power_bar = false;
        end

        if (spec and spec == 3) then
            if IsPlayerSpell(395152) then --칠흑의 힘
                APB_BUFF = 395296;
                APB.buffbar[0].buff = APB_BUFF;
                APB.buffbar[0].unit = "player"
                APB.buffbar[0].max = 20;
            end
        end
    end

    if (englishClass == "PALADIN") then
        APB_UNIT_POWER = "HOLY_POWER";
        APB_POWER_LEVEL = Enum.PowerType.HolyPower;
        APB:RegisterUnitEvent("UNIT_POWER_UPDATE", "player");
        APB:RegisterUnitEvent("UNIT_DISPLAYPOWER", "player");
        bupdate_power = true;
        combobuffalertlist = { 408458, 223819, 326733, 1216837 };
        combobuffcoloralertlist = { 326733 }; --창공의 힘

        if (spec and spec == 1) then
            APB_SPELL = 20473; --신성 충격
            APB_SpellMax(APB_SPELL);
            APB_UpdateSpell(APB_SPELL);
            bupdate_spell = true;
        end

        if (spec and spec == 2) then
            APB_SPELL = 35395 --성전사의 일격
            APB_SpellMax(APB_SPELL);
            APB_UpdateSpell(APB_SPELL);
            bupdate_spell = true;

            bsmall_power_bar = true;

            APB_BUFF = 132403; --정의의 방패
            APB.buffbar[0].buff = APB_BUFF;
            APB.buffbar[0].unit = "player";
        end

        if (spec and spec == 3) then
            APB_SPELL = 184575; --심판의 칼날
            APB_SpellMax(APB_SPELL);
            APB_UpdateSpell(APB_SPELL);
            bupdate_spell = true;
            bsmall_power_bar = true;
            if IsPlayerSpell(431533) then --격동하는 천상
                APB_BUFF = 431536;
                APB.buffbar[0].buff = APB_BUFF;
                APB.buffbar[0].unit = "player"
            end
        end
    end

    if (englishClass == "MAGE") then
        if (spec and spec == 1) then
            if (IsPlayerSpell(383980)) then
                APB_BUFF = 383997;
                APB.buffbar[0].buff = APB_BUFF
                APB.buffbar[0].unit = "player";
                bupdate_buff_count = true;
            end

            APB_UNIT_POWER = "ARCANE_CHARGES"
            APB_POWER_LEVEL = Enum.PowerType.ArcaneCharges
            APB:RegisterUnitEvent("UNIT_POWER_UPDATE", "player")
            APB:RegisterUnitEvent("UNIT_DISPLAYPOWER", "player");
            bupdate_power = true;

            --시즌1 티어 Intuition 특성으로 변경
            combobuffalertlist = { 451073, 451038, 1223797 };

            for i = 1, 20 do
                APB.combobar[i].tooltip = "ARCANE_CHARGES";
            end

            if IsPlayerSpell(448601) then
                APB_BUFF_COMBO = 449400;
                APB_BUFF_COMBO_MAX = 451049;
                APB_BUFF_COMBO_MAX_COUNT = 6;
                self.buffcombobar = self.combobar2;
                APB_MaxCombo(self.combobar2, APB_BUFF_COMBO_MAX_COUNT, true);
                APB.combobar2.unit = "player"
                bupdate_buff_combo = true;

                for i = 1, 20 do
                    APB.combobar2[i].tooltip = APB_BUFF_COMBO;
                end
            end
        end

        if (spec and spec == 2) then
            if IsPlayerSpell(383391) then
                APB_BUFF = 383395;
                APB.buffbar[0].buff = APB_BUFF
                APB.buffbar[0].unit = "player";
                bupdate_buff_count = true;
            end

            if IsPlayerSpell(383886) then
                APB_BUFF_COMBO = 383882;
                APB_BUFF_COMBO_MAX = 383883;
                APB_BUFF_COMBO_MAX_COUNT = 10;
                APB_MaxCombo(self.combobar, APB_BUFF_COMBO_MAX_COUNT);
                APB.combobar.unit = "player"
                bupdate_buff_combo = true;
                bsmall_power_bar = true;

                for i = 1, 20 do
                    APB.combobar[i].tooltip = APB_BUFF_COMBO;
                end
            elseif IsPlayerSpell(448601) then
                APB_BUFF_COMBO = 449400;
                APB_BUFF_COMBO_MAX = 451049;
                APB_BUFF_COMBO_MAX_COUNT = 6;
                self.buffcombobar = self.combobar2;
                APB_MaxCombo(self.combobar2, APB_BUFF_COMBO_MAX_COUNT, true);
                APB.combobar2.unit = "player"
                bupdate_buff_combo = true;

                for i = 1, 20 do
                    APB.combobar2[i].tooltip = APB_BUFF_COMBO;
                end
            end

            APB_SPELL = 108853;

            --불붙는 도화선
            spellbuffcolorlist = { 453207 };

            if IsPlayerSpell(257541) then
                APB_SPELL2 = 257541
                APB_SpellMax(APB_SPELL, APB_SPELL2);
                APB_UpdateSpell(APB_SPELL, APB_SPELL2);
                -- 화염의 분노
                spell2buffcolorlist = { 409964, 1219307 };
            else
                APB_SpellMax(APB_SPELL);
                APB_UpdateSpell(APB_SPELL);
            end

            bupdate_spell = true;
            bsmall_power_bar = true;
        end

        if (spec and spec == 3) then
            APB_SPELL = 44614; --진눈개비
            APB_SpellMax(APB_SPELL);
            APB_UpdateSpell(APB_SPELL);
            bupdate_spell = true;

            APB_BUFF_COMBO = 205473; --고드름
            APB_MaxCombo(self.combobar, 5);
            APB.combobar.unit = "player"
            bupdate_buff_combo = true;

            --냉기 과잉
            spellbuffcolorlist = { 438611 };

            for i = 1, 10 do
                APB.combobar[i].tooltip = APB_BUFF_COMBO;
            end

            FrozenOrbDuration = 10;
            if IsPlayerSpell(385167) then --영원한 서리
                FrozenOrbDuration = 12;
            end

            bupdate_fronzen = true;

            combobuffalertlist = { 431177 }; -- 서리 불꽃

            bsmall_power_bar = true;
        end
    end

    if (englishClass == "WARLOCK") then
        APB_UNIT_POWER = "SOUL_SHARDS"
        APB_POWER_LEVEL = Enum.PowerType.SoulShards
        APB:RegisterUnitEvent("UNIT_POWER_UPDATE", "player")
        APB:RegisterUnitEvent("UNIT_DISPLAYPOWER", "player");
        bupdate_power = true;

        combobuffcoloralertlist = { 433891 };            --지옥불 화살
        combobuffalertlist = { 387079, 387157, 433885 }; -- 코스트 안드는 스킬들

        for i = 1, 20 do
            APB.combobar[i].tooltip = "SOUL_SHARDS";
        end

        if (spec and spec == 1) then
            if IsPlayerSpell(32388) then --어둠의 선물
                APB_DEBUFF = 32390;
                if IsPlayerSpell(453080) then
                    APB_DEBUFF = 453206;
                end

                APB.buffbar[0].debuff = APB_DEBUFF
                APB.buffbar[0].unit = "target";

                APB:RegisterEvent("PLAYER_TARGET_CHANGED");
                bupdate_buff_count = true;
            end
        end

        if (spec and spec == 2) then
            if IsPlayerSpell(267170) then --악의 아귀
                APB_DEBUFF = 270569;
                APB.buffbar[0].debuff = APB_DEBUFF;
                APB.buffbar[0].unit = "target"
                APB:RegisterEvent("PLAYER_TARGET_CHANGED");
            end

            if IsPlayerSpell(196277) then --임프
                APB_ACTION_STACK = APB_GetActionSlot(196277);
                APB.stackbar[0].spellid = 196277;
                APB_MaxStack(15);
            end
        end

        if (spec and spec == 3) then
            APB_SPELL = 17962; --점화
            bupdate_spell = true;
            bupdate_partial_power = true;

            if IsPlayerSpell(17877) then
                APB_SPELL2 = 17877; --어둠의 연소
                APB_SpellMax(APB_SPELL, APB_SPELL2);
                APB_UpdateSpell(APB_SPELL, APB_SPELL2);
            else
                APB_SpellMax(APB_SPELL);
                APB_UpdateSpell(APB_SPELL);
            end

            if IsPlayerSpell(205184) and IsPlayerSpell(196412) then
                APB_DEBUFF = 265931; --점화 울부짖는 불길
                APB.buffbar[0].debuff = APB_DEBUFF;
                APB.buffbar[0].unit = "target"

                APB_DEBUFF2 = 196414; --박멸
                APB.buffbar[1].debuff = APB_DEBUFF2;
                APB.buffbar[1].unit = "target"
                APB:RegisterEvent("PLAYER_TARGET_CHANGED");
            elseif IsPlayerSpell(205184) then
                APB_DEBUFF = 265931; --점화 울부짖는 불길
                APB.buffbar[0].debuff = APB_DEBUFF;
                APB.buffbar[0].unit = "target"
                APB:RegisterEvent("PLAYER_TARGET_CHANGED");
            elseif IsPlayerSpell(196412) then
                APB_DEBUFF = 196414; --박멸
                APB.buffbar[0].debuff = APB_DEBUFF;
                APB.buffbar[0].unit = "target"
                APB:RegisterEvent("PLAYER_TARGET_CHANGED");
            end
        end

        bsmall_power_bar = true;
    end

    if (englishClass == "DRUID") then
        bupdate_druid = false;

        if (spec and spec == 1) then
            if IsPlayerSpell(429523) then
                APB_BUFF = 48518; --일월식 (달)
                APB.buffbar[0].buff = APB_BUFF
                APB.buffbar[0].unit = "player"

                APB_SPELL = 190984;
                bupdate_druid = true;
                APB_SpellMax(APB_SPELL, APB_SPELL2);
                APB_UpdateSpell(APB_SPELL, APB_SPELL2);
                bupdate_spell = true;
            else
                APB_BUFF = 48518;
                APB.buffbar[0].buff = APB_BUFF
                APB.buffbar[0].unit = "player"


                APB_BUFF2 = 48517; --일월식 (태양)
                APB.buffbar[1].buff = APB_BUFF2
                APB.buffbar[1].unit = "player"

                APB_SPELL = 194153;
                APB_SPELL2 = 190984
                bupdate_druid = true;
                APB_SpellMax(APB_SPELL, APB_SPELL2);
                APB_UpdateSpell(APB_SPELL, APB_SPELL2);

                bupdate_spell = true;
            end
        end

        if (spec and spec == 2) then
            APB_UNIT_POWER = "COMBO_POINTS"
            APB_POWER_LEVEL = Enum.PowerType.ComboPoints
            APB:RegisterUnitEvent("UNIT_POWER_UPDATE", "player")
            APB:RegisterUnitEvent("UNIT_DISPLAYPOWER", "player");
            APB:RegisterEvent("UPDATE_SHAPESHIFT_FORM");
            bupdate_power = true;

            combobuffalertlist = { 391882 };      --최상위
            combobuffcoloralertlist = { 441585 }; --찟어발기기

            druidcomboalertid = 405189;           --넘쳐 흐르는 힘

            if IsPlayerSpell(202028) then         --잔혹한 베기
                APB_SPELL = 202028;
                APB_SpellMax(APB_SPELL);
                APB_UpdateSpell(APB_SPELL);
                bupdate_spell = true;
            end

            for i = 1, 20 do
                APB.combobar[i].tooltip = "COMBO_POINTS";
            end
        end

        if (spec and spec == 3) then
            APB_BUFF = 192081; --무쇠가죽
            APB.buffbar[0].buff = APB_BUFF
            APB.buffbar[0].unit = "player"
            bupdate_buff_count = true;

            APB_UNIT_POWER = "COMBO_POINTS"
            APB_POWER_LEVEL = Enum.PowerType.ComboPoints
            APB:RegisterUnitEvent("UNIT_POWER_UPDATE", "player")
            APB:RegisterUnitEvent("UNIT_DISPLAYPOWER", "player");
            APB:RegisterEvent("UPDATE_SHAPESHIFT_FORM");
            bupdate_power = false;
            bdruid = true;

            APB_SPELL = 22842; --광포한 재생력
            APB_SpellMax(APB_SPELL);
            APB_UpdateSpell(APB_SPELL);
            bupdate_spell = true;

            for i = 1, 20 do
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

            if IsPlayerSpell(102693) then --숲 수호자
                APB_SPELL = 102693;
                APB_SpellMax(APB_SPELL);
                APB_UpdateSpell(APB_SPELL);
                bupdate_spell = true;
            end

            if IsPlayerSpell(274902) then --광합성
                APB_BUFF = 188550;        --피어나는 생명
                APB.buffbar[0].buff = APB_BUFF
                APB.buffbar[0].unit = "player"
            end

            for i = 1, 20 do
                APB.combobar[i].tooltip = "COMBO_POINTS";
            end
        end
    end

    if (englishClass == "MONK") then
        if (spec and spec == 1) then
            bupdate_stagger = true;

            if IsPlayerSpell(119582) then
                APB_SPELL = 119582;
                APB_SpellMax(APB_SPELL);
                APB_UpdateSpell(APB_SPELL);
                bupdate_spell = true;
            end
        end
        if (spec and spec == 2) then
            APB_SPELL = 115151; --소생의 안개
            APB_SpellMax(APB_SPELL);
            APB_UpdateSpell(APB_SPELL);
            bupdate_spell = true;

            if IsPlayerSpell(467293) then
                APB_BUFF = 388026;
                APB.buffbar[0].buff = APB_BUFF;
                APB.buffbar[0].unit = "player"
            end
            if IsPlayerSpell(399491) then
                APB_ACTION_COMBO = APB_GetActionSlot(399491);
                APB_MaxCombo(self.combobar, 10);
                bupdate_buff_combo = true;

                for i = 1, 20 do
                    APB.combobar[i].tooltip = APB_ACTION_COMBO;
                end
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

        if IsPlayerSpell(382513) then
            APB_SPELL = 1856; --소멸
            APB_SpellMax(APB_SPELL);
            APB_UpdateSpell(APB_SPELL);
            bupdate_spell = true;
        end

        if IsPlayerSpell(421975) then --"부식성 분사"
            APB_DEBUFF = 421976;
            APB.buffbar[0].debuff = APB_DEBUFF;
            APB.buffbar[0].unit = "target"
            APB:RegisterEvent("PLAYER_TARGET_CHANGED");
        elseif IsPlayerSpell(423703) then --일발필중
            APB_BUFF = 115192;            --기만
            APB.buffbar[0].buff = APB_BUFF;
            APB.buffbar[0].unit = "player"
        elseif IsPlayerSpell(91023) then --약점포착
            APB_DEBUFF = 316220;
            APB.buffbar[0].debuff = APB_DEBUFF;
            APB.buffbar[0].unit = "target"
            APB:RegisterEvent("PLAYER_TARGET_CHANGED");
        end

        if IsPlayerSpell(457052) then --죽음 추적자
            bdeathstalker = true;
        end

        APB_UNIT_POWER = "COMBO_POINTS"
        APB_POWER_LEVEL = Enum.PowerType.ComboPoints
        APB:RegisterUnitEvent("UNIT_POWER_UPDATE", "player")
        APB:RegisterUnitEvent("UNIT_DISPLAYPOWER", "player");
        bupdate_power = true;

        for i = 1, 20 do
            APB.combobar[i].tooltip = "COMBO_POINTS";
        end
    end

    if (englishClass == "DEATHKNIGHT") then
        if (spec and spec == 1) then
            if IsPlayerSpell(194679) then --룬전환
                APB_SPELL = 194679;
                APB_SpellMax(APB_SPELL);
                APB_UpdateSpell(APB_SPELL);
                bupdate_spell = true;
            end

            APB_BUFF = 195181; --뼈의 보호막
            APB.buffbar[0].buff = APB_BUFF;
            APB.buffbar[0].unit = "player"
            APB.buffbar[0].alertcount = 5;

            bupdate_buff_count = true;
        end

        if (spec and spec == 2) then
            if IsPlayerSpell(376905) then --풀려난 광란
                APB_BUFF = 376907;
                APB.buffbar[0].buff = APB_BUFF
                APB.buffbar[0].unit = "player"

                bupdate_buff_count = true;
            elseif IsPlayerSpell(194878) then --얼음 발톱
                APB_BUFF = 194879;
                APB.buffbar[0].buff = APB_BUFF
                APB.buffbar[0].unit = "player"

                bupdate_buff_count = true;
            end
        end

        if (spec and spec == 3 and IsPlayerSpell(390175)) then -- 역병인도자
            APB_BUFF = 390178;
            APB.buffbar[0].buff = APB_BUFF
            APB.buffbar[0].unit = "player"
        end

        APB_MaxRune();
        APB_UpdateRune()
        APB:RegisterEvent("RUNE_POWER_UPDATE")
        bupdate_rune = true;

        for i = 1, 20 do
            APB.combobar[i].tooltip = "RUNE_POWER";
        end
    end

    if (englishClass == "PRIEST") then
        if (spec and spec == 1) then
            APB_SPELL = 194509;
            APB_SPELL2 = 8092;
            APB_SpellMax(APB_SPELL, APB_SPELL2);
            APB_UpdateSpell(APB_SPELL, APB_SPELL2);
            bupdate_spell = true;

            if IsPlayerSpell(424509) then --분파
                APB_DEBUFF = 214621;
                APB.buffbar[0].debuff = APB_DEBUFF;
                APB.buffbar[0].unit = "target"
                APB:RegisterEvent("PLAYER_TARGET_CHANGED");
            end
        end

        if (spec and spec == 2) then
            APB_SPELL = 2050;   --빛의 권능: 평온
            APB_SPELL2 = 34861; --빛의 권능: 신성화
            APB_SpellMax(APB_SPELL, APB_SPELL2);
            APB_UpdateSpell(APB_SPELL, APB_SPELL2);
            bupdate_spell = true;

            if IsPlayerSpell(392988) then --신성한 환영
                APB_BUFF = 405963;
                APB.buffbar[0].buff = APB_BUFF
                APB.buffbar[0].unit = "player"

                bupdate_buff_count = true;
            end
        end

        if (spec and spec == 3) then
            APB_SPELL = 8092;
            APB_SpellMax(APB_SPELL);
            APB_UpdateSpell(APB_SPELL);
            bupdate_spell = true;

            if HowManyHasSet(1688) == 4 then --내부전쟁 시즌1
                APB_BUFF = 454638;           --게걸스러운 합창
                APB.buffbar[0].buff = APB_BUFF
                APB.buffbar[0].unit = "player"
            end
        end
    end

    if (englishClass == "WARRIOR") then
        if (spec and spec == 1) then
            if IsPlayerSpell(7384) then
                APB_SPELL = 7384; --제압
                APB_SpellMax(APB_SPELL);
                APB_UpdateSpell(APB_SPELL);
                bupdate_spell = true;
            end
            APB_DEBUFF = 208086; --거인의 강타
            APB.buffbar[0].debuff = APB_DEBUFF;
            APB.buffbar[0].unit = "target";
            APB:RegisterEvent("PLAYER_TARGET_CHANGED");
        end

        if (spec and spec == 2) then
            APB_BUFF = 184362; --격노
            APB.buffbar[0].buff = APB_BUFF;
            APB.buffbar[0].unit = "player"


            if IsPlayerSpell(12950) then -- 소용돌이 연마
                APB_BUFF_COMBO = 85739;

                if IsPlayerSpell(280392) then -- 고기칼
                    APB_MaxCombo(self.combobar, 4);
                else
                    APB_MaxCombo(self.combobar, 2);
                end
                APB.combobar.unit = "player"
                bupdate_buff_combo = true;
            end
        end

        if (spec and spec == 3) then
            APB_SPELL = 2565;
            APB_SpellMax(APB_SPELL);
            APB_UpdateSpell(APB_SPELL);
            bupdate_spell = true;
            APB_BUFF = 132404;
            APB.buffbar[0].buff = APB_BUFF
            APB.buffbar[0].unit = "player"
        end
    end

    if (englishClass == "DEMONHUNTER") then
        if (spec and spec == 1) then
            if IsPlayerSpell(206476) then --탄력
                APB_BUFF = 208628;
                APB.buffbar[0].buff = APB_BUFF;
                APB.buffbar[0].unit = "player"
                APB.buffbar[0].max = 20;
            elseif IsPlayerSpell(427640) then --타성
                APB_BUFF = 427641;
                APB.buffbar[0].buff = APB_BUFF;
                APB.buffbar[0].unit = "player"
            end

            APB_SPELL = 195072;  --지옥돌진
            APB_SPELL2 = 185123; --글레이브 투척
            APB_SpellMax(APB_SPELL, APB_SPELL2);
            APB_UpdateSpell(APB_SPELL, APB_SPELL2);
            bupdate_spell = true;
        end

        if (spec and spec == 2) then
            APB_SPELL = 203720; --악마쐐기

            if IsPlayerSpell(263642) then
                APB_SPELL2 = 263642; --균열
                APB_SpellMax(APB_SPELL, APB_SPELL2);
                APB_UpdateSpell(APB_SPELL, APB_SPELL2);
            else
                APB_SpellMax(APB_SPELL);
                APB_UpdateSpell(APB_SPELL);
            end

            bupdate_spell = true;
            APB_BUFF = 203819; --악마 쐐기
            APB.buffbar[0].buff = APB_BUFF;
            APB.buffbar[0].unit = "player"


            APB_BUFF_COMBO = 203981; --영혼 파편
            APB_MaxCombo(self.combobar, 5);
            APB.combobar.unit = "player"

            bupdate_buff_combo = true;

            for i = 1, 20 do
                APB.combobar[i].tooltip = APB_BUFF_COMBO;
            end
        end
    end

    if (englishClass == "HUNTER") then
        if (spec and spec == 1) then
            if IsPlayerSpell(217200) then --날카로운 사격
                APB_SPELL = 217200;
                APB_SpellMax(APB_SPELL);
                APB_UpdateSpell(APB_SPELL);
                bupdate_spell = true;
            end

            APB_BUFF = 272795; --광기
            APB.buffbar[0].buff = APB_BUFF;
            APB.buffbar[0].unit = "player"
            bupdate_buff_count = true;

            if IsPlayerSpell(472357) then --무리의 지도자의 포효
                APB_BUFF_TIME_STACK = 471877;
                APB.stackbar[0].unit = "player";
                APB.stackbar[0].spellid = 471877;
                APB_MaxStack(25);
                bupdate_Howl_Pack = true;
                APB:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED");
            end
        end

        if (spec and spec == 2) then
            if IsPlayerSpell(19434) then --조준 사격
                APB_SPELL = 19434;
                APB_SpellMax(APB_SPELL);
                APB_UpdateSpell(APB_SPELL);
                bupdate_spell = true;
            end

            if IsPlayerSpell(257621) then --교묘한사격
                APB_BUFF = 257622;
                APB_BUFF3 = 260243;       --연발공격
                APB.buffbar[0].buff = APB_BUFF;
                APB.buffbar[0].buff3 = APB_BUFF3;
                APB.buffbar[0].unit = "player"
                APB.buffbar[0].maxshow = 6;
            end

            if IsPlayerSpell(450385) then
                APB_DEBUFF_TIME_STACK = 451803;
                APB.stackbar[0].unit = "player";
                APB.stackbar[0].spellid = APB_DEBUFF_TIME_STACK;
                APB_MaxStack(30);
            end
        end

        if (spec and spec == 3) then
            if IsPlayerSpell(259495) then --야생불 폭탄
                APB_SPELL = 259495;
                APB_SpellMax(APB_SPELL);
                APB_UpdateSpell(APB_SPELL);
                bupdate_spell = true;
            end

            if IsPlayerSpell(259387) then --살쾡이의 이빨
                APB_BUFF = 259388;
                APB.buffbar[0].buff = APB_BUFF;
                bupdate_buff_count = true;
                APB.buffbar[0].unit = "player";
            elseif IsPlayerSpell(260285) then --창끝
                APB_BUFF_COMBO = 260286;
                APB_MaxCombo(self.combobar, 3);
                APB.combobar.unit = "player"

                bupdate_buff_combo = true;

                for i = 1, 20 do
                    APB.combobar[i].tooltip = APB_BUFF_COMBO;
                end
            end

            if IsPlayerSpell(450385) then
                APB_DEBUFF_TIME_STACK = 451803;
                APB.stackbar[0].unit = "player";
                APB.stackbar[0].spellid = APB_DEBUFF_TIME_STACK;
                APB_MaxStack(30);
            elseif IsPlayerSpell(472357) then --무리의 지도자의 포효
                APB_BUFF_TIME_STACK = 471877;
                APB.stackbar[0].unit = "player";
                APB.stackbar[0].spellid = 471877;
                APB_MaxStack(20);
                bupdate_Howl_Pack = true;
                APB:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED");
            end
        end
    end

    if (englishClass == "SHAMAN") then
        if spec and spec == 1 then
            APB_SPELL = 51505; --용암 폭발
            APB_SpellMax(APB_SPELL);
            APB_UpdateSpell(APB_SPELL);
            bupdate_spell = true;

            if IsPlayerSpell(378270) then --깊이 뿌리내린 정기
                APB_BUFF = 1219480;
                APB.buffbar[0].buff = APB_BUFF;
                APB.buffbar[0].unit = "player"
            end

            if IsPlayerSpell(454009) then
                bupdate_element_tempest = true;
                tempeststate.TempestStacks = 300;
                tempeststate.bfirstcheck = true;
                tempeststate.TStacks = 0;
                APB_MaxStack(tempeststate.TempestStacks);
                self.stackbar[0].spellid = 454009;

                APB:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED");
            end
        end

        if spec and spec == 2 then
            if IsPlayerSpell(117014) then
                APB_SPELL = 117014; --정기 작렬
                APB_SpellMax(APB_SPELL);
                APB_UpdateSpell(APB_SPELL);
                bupdate_spell = true;
            end

            APB_BUFF_COMBO = 344179;
            APB_MaxCombo(self.combobar, 10);
            APB.combobar.unit = "player"

            bupdate_buff_combo = true;
            bsmall_power_bar = true;

            for i = 1, 20 do
                APB.combobar[i].tooltip = APB_BUFF_COMBO;
            end
            bhalf_combo = true;

            if IsPlayerSpell(187874) then --낙뢰
                APB_BUFF = 187878;
                APB.buffbar[0].buff = APB_BUFF;
                APB.buffbar[0].unit = "player"
            end

            if IsPlayerSpell(454009) then
                bupdate_enhaced_tempest = true;
                tempeststate.TempestStacks = 40;
                tempeststate.bfirstcheck = true;
                tempeststate.TStacks = 0;
                APB_MaxStack(tempeststate.TempestStacks);
                self.stackbar[0].spellid = 454009;

                APB:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED");
                combobuffcoloralertlist = { 454015 }; --폭풍 색상 변경
            end
        end

        if (spec and spec == 3) then
            APB_SPELL = 61295; --성난 해일
            APB_SpellMax(APB_SPELL);
            APB_UpdateSpell(APB_SPELL);
            bupdate_spell = true;

            APB_BUFF_COMBO = 53390; --굽이치는 물결

            if IsPlayerSpell(443448) then
                APB_MaxCombo(self.combobar, 4);
            else
                APB_MaxCombo(self.combobar, 2);
            end
            APB.combobar.unit = "player"

            bupdate_buff_combo = true;

            for i = 1, 20 do
                APB.combobar[i].tooltip = APB_BUFF_COMBO;
            end
        end
    end

    ns.AddBuff(APB_BUFF);
    ns.AddBuff(APB_BUFF2);
    ns.AddBuff(self.buffbar[0].buff2);
    ns.AddBuff(self.buffbar[1].buff2);
    ns.AddBuff(APB_BUFF2);
    ns.AddBuff(APB_BUFF_STACK);
    ns.AddBuff(APB_BUFF_TIME_STACK);
    ns.AddBuff(APB_BUFF_COMBO);
    ns.AddBuff(APB_BUFF_COMBO_MAX);
    ns.AddBuff(combobuffalertlist);
    ns.AddBuff(combobuffcoloralertlist);
    ns.AddBuff(spellbuffcolorlist);
    ns.AddBuff(spell2buffcolorlist);
    ns.AddBuff(druidcomboalertid);

    if bdeathstalker then
        ns.AddBuff(457280);
        ns.AddDebuff(457129);
    end

    if bupdate_enhaced_tempest or bupdate_element_tempest then
        ns.AddBuff(454015);
    end

    ns.AddBuffC(combobuffcountalertlist);

    ns.AddDebuff(APB_DEBUFF);
    ns.AddDebuff(APB_DEBUFF2);
    ns.AddDebuff(APB_DEBUFF_STACK);
    ns.AddDebuff(APB_DEBUFF_TIME_STACK);
    ns.AddDebuff(APB_DEBUFF_COMBO);
    ns.AddDebuff(combodebuffalertlist);


    if APB_SPELL then
        APB_ACTION = APB_GetActionSlots(APB_SPELL);
    end

    if APB_SPELL2 then
        APB_ACTION2 = APB_GetActionSlots(APB_SPELL2);
    end

    if not bupdate_power and not bupdate_rune and not bupdate_buff_combo then
        APB_MaxCombo(self.combobar, 0);
    end

    if not bupdate_spell then
        APB_MaxSpell(0);
    end

    if bupdate_healthbar then
        APB.bar:SetHeight(APB_HEIGHT);
        APB.healthbar:SetHeight(APB_HEIGHT);
        APB.healthbar:Show();
        APB.healthbar.text:Show();
    else
        APB.healthbar:SetHeight(0.01);
        APB.healthbar.text:Hide();
        APB.healthbar.count:Hide();
        APB.healthbar:Hide();
    end

    for i = 1, 20 do
        APB.combobar[i]:SetHeight(APB_HEIGHT * 0.7);
    end

    APB_InitPowerBar(self);
    APB.bar:SetHeight(APB_HEIGHT * 1.5);
    APB.bar:Show();
    APB.bar.text:Show();

    APB.timerPowerBar = C_Timer.NewTicker(0.1, updatePowerBar);
    APB.timerPower = C_Timer.NewTicker(0.2, updatePower);
    APB.timerBuffBar = C_Timer.NewTicker(0.2, updateBuffBar);

    if bsmall_power_bar then
        APB.bar:SetHeight(APB_HEIGHT * 0.5);
        APB.bar.text:Hide();
        -- APB.bar.count:Hide();
    end

    if not (APB_BUFF or APB_DEBUFF or bupdate_stagger or bupdate_fronzen) then
        APB.buffbar[0]:SetHeight(0.01);
        APB.buffbar[0].text:Hide();
        APB.buffbar[0].count:Hide();
        APB.buffbar[0]:Hide();
    else
        APB.buffbar[0]:SetHeight(APB_HEIGHT);

        APB_UpdateBuff(self.buffbar[0]);
        if (APB_BUFF2 or APB_DEBUFF2) then
            APB.buffbar[1]:SetHeight(APB_HEIGHT);
            APB.buffbar[1]:SetWidth(APB_WIDTH / 2);
            APB.buffbar[0]:SetWidth(APB_WIDTH / 2);
            APB_UpdateBuff(self.buffbar[1]);
            APB.buffbar[1]:SetHeight(APB_HEIGHT);
        else
            APB.buffbar[0]:SetWidth(APB_WIDTH);
        end

        if bupdate_fronzen then
            APB_UpdateFronzenOrb(self.buffbar[0]);

            local width = self.buffbar[0]:GetWidth() / FrozenOrbDuration * 3;

            for i = 1, 3 do
                local square = APB.buffbar[0].square[i]
                square:SetWidth(2);
                square:SetHeight(APB.buffbar[0]:GetHeight() - 1);
                square:ClearAllPoints()
                square:SetPoint("CENTER", APB.buffbar[0], "RIGHT", -(width * i), 0);
                square:Show();
            end
        end
    end

    if bupdate_partial_power then
        local combotext = APB.combotext;

        combotext:ClearAllPoints();
        combotext:SetPoint("CENTER", APB.combobar[3], "CENTER", 0, 0);
    end

    if bdeathstalker then
        local combotext = APB.combotext;

        combotext:ClearAllPoints();
        combotext:SetPoint("CENTER", APB.combobar[5], "CENTER", 0, 0);
    end
end

local gpredictedPowerCost = nil;
local generateText = "생성";
local generateText2 = "%d의 ";
local generateText3 = " %d개";

if GetLocale() == "enUS" then
    generateText = "[Gg]enerat";
    generateText2 = "%d ";
    generateText3 = " %d";
end

local function checkSpellCost(id)
    local i = 1

    if id then
        local spell = Spell:CreateFromSpellID(id);
        spell:ContinueOnSpellLoad(function()
            local costText = spell:GetSpellDescription();
            local powerType = UnitPowerType("player");

            if costText and PowerTypeString[powerType] and string.match(costText, PowerTypeString[powerType]) and
                string.match(costText, generateText) then
                local findstring = generateText2 .. PowerTypeString[powerType];
                local start, endpoint = string.find(costText, findstring, 0);

                if start and start > 5 then
                    local costText2 = string.sub(costText, start - 5, endpoint);
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

local function scanSpellCost(id, powerTypeString, disWarlock)
    if id then
        local spell = Spell:CreateFromSpellID(id);
        spell:ContinueOnSpellLoad(function()
            local costText = spell:GetSpellDescription();
            if costText and powerTypeString and string.match(costText, powerTypeString) and
                string.match(costText, generateText) then
                local findstring = generateText2 .. powerTypeString;
                local start, endpoint = string.find(costText, findstring, 0);

                if start and start > 5 then
                    local costText2 = string.sub(costText, start - 5, endpoint);
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

                findstring = powerTypeString .. generateText3;
                start = string.find(costText, findstring, 0);

                local notfindstring = "죽으면 " .. findstring;

                local start, endpoint = string.find(costText, findstring, 0);
                local startno = string.find(costText, notfindstring, 0);

                if startno and startno > 10 then
                    SpellGetPowerCosts[id] = 0;
                    return;
                end

                if start and start > 5 and startno == nil then
                    local costText2 = string.sub(costText, start - 5, endpoint);

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
    end
end

local soulshardtext = "영혼의 조각 파편";

if GetLocale() == "enUS" then
    soulshardtext = "Soul Shard Fragments"
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

    if (englishClass == "WARLOCK") and (spec and spec == 3) then
        scanSpellCost(id, powerTypeString, disWarlock);
        disWarlock = true;
        scanSpellCost(id, soulshardtext, disWarlock);
    else
        scanSpellCost(id, powerTypeString, disWarlock);
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

local enhanced_listOfSpenders = {
    [8004] = true,    -- Healing Surge
    [1064] = true,    -- Chain Heal
    [51505] = true,   -- Lava Burst
    [188443] = true,  -- Chain Lightning
    [117014] = true,  -- Elemental Blast
    [188196] = true,  -- Lightning Bolt
    [452201] = true,  -- Tempest
    [320674] = true,  -- Chain Harvest
    [1218090] = true, --Primordial Storm 11.1


};

local elemental_listOfSpenders = {
    [117014] = true, -- Elemental Blast
    [8042] = true,   -- Earth Shock
    [61882] = true,  -- Earthquake
    [462620] = true, -- Earthquake (@target)


};

local howl_pack_auras = {
    [472324] = "Bear",
    [472325] = "Wyvern",
    [471878] = "Boar",
}



local playerGUID = UnitGUID("player");

local function updateCombatLog()
    local timestamp, eventType, _, sourceGUID, _, _, _, destGUID, _, _, _, spellId, _, _, auraType, amount =
        CombatLogGetCurrentEventInfo();

    if sourceGUID and (sourceGUID == playerGUID) then
        if bupdate_enhaced_tempest then
            if (eventType == "SPELL_AURA_REMOVED" and spellId == 462131) then
                tempeststate.lastaction = 4;
                --print("Awaken");
            elseif (eventType == "SPELL_AURA_REMOVED" and spellId == 454015) then
                tempeststate.buffstack = 0;

                if tempeststate.lastaction == 1 and tempeststate.lastspellId == 452201 then
                    tempeststate.lastaction = 5;
                    --print("rTempestS");
                else
                    tempeststate.lastaction = 3;
                    --print("rTempest");
                end
            elseif (eventType == "SPELL_AURA_REMOVED_DOSE" and spellId == 454015) then
                tempeststate.buffstack = amount;
                if tempeststate.lastaction == 1 and tempeststate.lastspellId == 452201 then
                    tempeststate.lastaction = 5;
                    -- print("rTempestS");
                else
                    tempeststate.lastaction = 3;
                    --print("rTempest");
                end
            elseif ((eventType == "SPELL_AURA_APPLIED" or eventType == "SPELL_AURA_REFRESH" or eventType == "SPELL_AURA_APPLIED_DOSE") and spellId == 454015) then -- Tempest buff
                local needtoreset = false;
                if amount == nil then
                    amount = 1;
                end

                --print(eventType .. amount);

                local buffcount = amount - tempeststate.buffstack;
                local castTimeDiff = timestamp - tempeststate.lastCastTime;

                if buffcount == 2 then
                    needtoreset = true;
                elseif buffcount == 1 then
                    if (tempeststate.lastaction == 1 or tempeststate.lastaction == 5) and castTimeDiff < 0.5 then
                        needtoreset = true;
                    elseif tempeststate.lastaction == 2 and castTimeDiff < 1 then
                        needtoreset = true;
                    end
                end

                if needtoreset then
                    if tempeststate.bfirstcheck then
                        tempeststate.bfirstcheck = false;
                        tempeststate.TStacks = 0
                    elseif tempeststate.TStacks >= 40 then
                        -- Reset due to Tempest buff gained with >= 40 MSW consumed
                        tempeststate.TStacks = tempeststate.TStacks - 40
                    else
                        -- Reset to 0 due to desync
                        tempeststate.TStacks = 0
                    end
                end
                tempeststate.buffstack = amount;
                tempeststate.lastaction = 2;
                --Maelstorm
            elseif (eventType == "SPELL_CAST_SUCCESS" and enhanced_listOfSpenders[spellId]) then
                tempeststate.lastCastTime = timestamp;
                tempeststate.lastspellId = spellId;
                tempeststate.lastaction = 1;
                --print("spell");
            elseif (eventType == "SPELL_AURA_REMOVED_DOSE" and spellId == 344179) then
                if (timestamp - tempeststate.lastCastTime < 0.1) then
                    local consumed = tempeststate.currentStacks - amount;
                    tempeststate.TStacks = tempeststate.TStacks + consumed;
                end
                tempeststate.currentStacks = amount;
            elseif (eventType == "SPELL_AURA_REMOVED" and spellId == 344179) then
                if (timestamp - tempeststate.lastCastTime < 0.1) then
                    local consumed = tempeststate.currentStacks;
                    tempeststate.TStacks = tempeststate.TStacks + consumed;
                end
                tempeststate.currentStacks = 0;
            elseif (eventType == "SPELL_AURA_APPLIED" and spellId == 344179) then
                tempeststate.currentStacks = 1
            elseif (eventType == "SPELL_AURA_APPLIED_DOSE" and spellId == 344179) then
                tempeststate.currentStacks = amount
            end

            -- Fail-safe to reset stacks if they exceed 49
            if tempeststate.TStacks > 49 then
                tempeststate.TStacks = 0
            end

            tempeststate.TempestStacks = 40 - tempeststate.TStacks;

            if tempeststate.TempestStacks < 0 then
                tempeststate.TempestStacks = 0
            end
        elseif bupdate_element_tempest then
            if (eventType == "SPELL_AURA_REMOVED" and spellId == 462131) then
                tempeststate.lastaction = 4;
            elseif (eventType == "SPELL_AURA_REMOVED" and spellId == 454015) then
                tempeststate.buffstack = 0;
                tempeststate.lastaction = 3;
            elseif (eventType == "SPELL_AURA_REMOVED_DOSE" and spellId == 454015) then
                tempeststate.buffstack = amount;
                tempeststate.lastaction = 3;
            elseif ((eventType == "SPELL_AURA_APPLIED" or eventType == "SPELL_AURA_REFRESH" or eventType == "SPELL_AURA_APPLIED_DOSE") and spellId == 454015) then -- Tempest buff
                local needtoreset = false;
                if amount == nil then
                    amount = 1;
                end

                local buffcount = amount - tempeststate.buffstack;
                local castTimeDiff = timestamp - tempeststate.lastCastTime;

                if buffcount == 2 then
                    needtoreset = true;
                elseif buffcount == 1 then
                    if tempeststate.lastaction == 1 and castTimeDiff < 0.5 then
                        needtoreset = true;
                    elseif tempeststate.lastaction == 2 and castTimeDiff < 1 then
                        needtoreset = true;
                    end
                end

                if needtoreset then
                    if tempeststate.bfirstcheck then
                        tempeststate.bfirstcheck = false;
                        tempeststate.TStacks = 0
                    elseif tempeststate.TStacks >= 300 then
                        -- Reset due to Tempest buff gained with >= 40 MSW consumed
                        tempeststate.TStacks = tempeststate.TStacks - 300
                    else
                        -- Reset to 0 due to desync
                        tempeststate.TStacks = 0
                    end
                end
                tempeststate.buffstack = amount;
                tempeststate.lastaction = 2;
            elseif (eventType == "SPELL_CAST_SUCCESS" and elemental_listOfSpenders[spellId]) then
                tempeststate.lastCastTime = timestamp;

                local cost = C_Spell.GetSpellPowerCost(spellId)
                if cost[1].name == "MAELSTROM" then
                    cost = cost[1].cost
                else
                    cost = cost[2].cost
                end

                tempeststate.TStacks = tempeststate.TStacks + cost;
                tempeststate.lastaction = 1;
            end

            -- Fail-safe to reset stacks if they exceed 49
            if tempeststate.TStacks > 400 then
                tempeststate.TStacks = 0
            end

            tempeststate.TempestStacks = 300 - tempeststate.TStacks;

            if tempeststate.TempestStacks < 0 then
                tempeststate.TempestStacks = 0
            end
        elseif bupdate_Howl_Pack then
            if (eventType == "SPELL_AURA_REMOVED" and howl_pack_auras[spellId]) then
                next_howl = howl_pack_auras[spellId];
            end
        end
    end
end

local function APB_OnEvent(self, event, arg1, arg2, arg3, ...)
    if event == "UNIT_AURA" then
        ns.needtocheckAura = true;
        updateBuffBar();
    elseif event == "ACTIONBAR_UPDATE_COOLDOWN" or event == "ACTIONBAR_UPDATE_USABLE" then
        if APB_SPELL then
            APB_UpdateSpell(APB_SPELL, APB_SPELL2);
        end
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

        if bupdate_fronzen then
            if event == "UNIT_SPELLCAST_SUCCEEDED" and arg3 == FrozenOrbID then
                FrozenOrbTime = GetTime();
            end
            APB_UpdateFronzenOrb(self.buffbar[0]);
        end
    elseif event == "PLAYER_TARGET_CHANGED" then
        ns.needtocheckAura = true;
        updateBuffBar();
    elseif event == "COMBAT_LOG_EVENT_UNFILTERED" then
        updateCombatLog();
    elseif event == "PLAYER_ENTERING_WORLD" then
        if UnitAffectingCombat("player") then
            APB:SetAlpha(APB_ALPHA_COMBAT);
        else
            APB:SetAlpha(APB_ALPHA_NORMAL);
        end

        C_Timer.After(0.5, APB_CheckPower);
        C_Timer.After(0.5, APB_UpdatePower);
    elseif (event == "TRAIT_CONFIG_UPDATED") or (event == "TRAIT_CONFIG_LIST_UPDATED") or event ==
        "ACTIVE_TALENT_GROUP_CHANGED" then
        APB_SPELL = nil;
        APB_SPELL2 = nil;
        C_Timer.After(0.5, APB_CheckPower);
        C_Timer.After(0.5, APB_UpdatePower);
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
    elseif event == "SPELL_ACTIVATION_OVERLAY_GLOW_SHOW" then
        local name = asGetSpellInfo(arg1);
        local newname = asGetSpellInfo(APB_SPELL);
        if APB_SPELL and name == newname then
            balert = true;
        end

        local newname2 = asGetSpellInfo(APB_SPELL2);
        if APB_SPELL2 and name == newname2 then
            balert2 = true;
        end
    elseif event == "SPELL_ACTIVATION_OVERLAY_GLOW_HIDE" then
        local name = asGetSpellInfo(arg1);
        local newname = asGetSpellInfo(APB_SPELL);
        if APB_SPELL and name == newname then
            balert = false;
        end

        local newname2 = asGetSpellInfo(APB_SPELL2);
        if APB_SPELL2 and name == newname2 then
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
    APB:SetPoint("BOTTOM", UIParent, "CENTER", APB_X, APB_Y)
    APB:SetWidth(APB_WIDTH)
    APB:SetHeight(APB_HEIGHT)
    APB:SetFrameLevel(9100);
    APB:Show();

    APB.bar = CreateFrame("StatusBar", nil, APB)
    APB.bar:SetStatusBarTexture("Interface\\addons\\aspowerbar\\UI-StatusBar")
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
    APB.healthbar:SetStatusBarTexture("Interface\\addons\\aspowerbar\\UI-StatusBar")
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
        APB.buffbar[j]:SetStatusBarTexture("Interface\\addons\\aspowerbar\\UI-StatusBar")
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

        APB.buffbar[j].square = {};
        for i = 1, 10 do
            APB.buffbar[j].square[i] = APB.buffbar[j]:CreateTexture(nil);
            APB.buffbar[j].square[i]:SetDrawLayer("ARTWORK", 5);
            APB.buffbar[j].square[i]:SetTexture("Interface\\Addons\\asPowerBar\\Square_White.tga")
            APB.buffbar[j].square[i]:SetBlendMode("ALPHAKEY");
            APB.buffbar[j].square[i]:SetVertexColor(0, 0, 0, 1)
            APB.buffbar[j].square[i]:SetWidth(3);
            APB.buffbar[j].square[i]:SetHeight(APB.buffbar[j]:GetHeight() - 1);
            APB.buffbar[j].square[i]:Hide();
        end
    end



    APB.stackbar = {};

    for j = 0, 0 do
        APB.stackbar[j] = CreateFrame("StatusBar", nil, APB);
        APB.stackbar[j]:SetStatusBarTexture("Interface\\addons\\aspowerbar\\UI-StatusBar")
        APB.stackbar[j]:GetStatusBarTexture():SetHorizTile(false);
        APB.stackbar[j]:SetMinMaxValues(0, 100);
        APB.stackbar[j]:SetValue(100);
        APB.stackbar[j]:SetHeight(APB_HEIGHT / 2);
        APB.stackbar[j]:SetWidth(APB_WIDTH);
        APB.stackbar[j].bg = APB.stackbar[j]:CreateTexture(nil, "BACKGROUND");
        APB.stackbar[j].bg:SetPoint("TOPLEFT", APB.stackbar[j], "TOPLEFT", -1, 1);
        APB.stackbar[j].bg:SetPoint("BOTTOMRIGHT", APB.stackbar[j], "BOTTOMRIGHT", 1, -1);
        APB.stackbar[j].bg:SetTexture("Interface\\Addons\\asPowerBar\\border.tga");
        APB.stackbar[j].bg:SetTexCoord(0.1, 0.1, 0.1, 0.1, 0.1, 0.1, 0.1, 0.1);
        APB.stackbar[j].bg:SetVertexColor(0, 0, 0, 0.8);

        if j == 0 then
            APB.stackbar[j]:SetPoint("BOTTOMLEFT", APB.buffbar[j], "TOPLEFT", 0, 1);
        else
            APB.stackbar[j]:SetPoint("BOTTOMLEFT", APB.buffbar[j], "TOPLEFT", 0, 1);
        end
        APB.stackbar[j]:Hide();

        APB.stackbar[j].buff3bar = APB.stackbar[j]:CreateTexture(nil, "ARTWORK", "asPredictionBarTemplate", 2);
        APB.stackbar[j].buff3bar:Hide();

        APB.stackbar[j].castbar = APB.stackbar[j]:CreateTexture(nil, "ARTWORK", "asPredictionBarTemplate", 3);
        APB.stackbar[j].castbar:Hide();

        APB.stackbar[j].text = APB.stackbar[j]:CreateFontString(nil, "ARTWORK")
        APB.stackbar[j].text:SetFont(APB_Font, APB_BuffSize, APB_FontOutline)
        APB.stackbar[j].text:SetPoint("LEFT", APB.stackbar[j], "LEFT", 5, 0)
        APB.stackbar[j].text:SetTextColor(1, 1, 1, 1)

        APB.stackbar[j].count = APB.stackbar[j]:CreateFontString(nil, "ARTWORK")
        APB.stackbar[j].count:SetFont(APB_Font, APB_BuffSize + 1, APB_FontOutline)
        APB.stackbar[j].count:SetPoint("CENTER", APB.stackbar[j], "CENTER", 0, 0)
        APB.stackbar[j].count:SetTextColor(1, 1, 1, 1);
        --APB.stackbar[j]:Show()
    end

    APB.combobar = {};
    APB.runeIndexes = { 1, 2, 3, 4, 5, 6 };

    for i = 1, 20 do
        APB.combobar[i] = CreateFrame("StatusBar", nil, APB);
        APB.combobar[i]:SetStatusBarTexture("Interface\\addons\\aspowerbar\\UI-StatusBar");
        APB.combobar[i]:GetStatusBarTexture():SetHorizTile(false);
        APB.combobar[i]:SetFrameLevel(9000);
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
            APB.combobar[i]:SetPoint("BOTTOMLEFT", APB.stackbar[0], "TOPLEFT", 0, 1);
        else
            APB.combobar[i]:SetPoint("LEFT", APB.combobar[i - 1], "RIGHT", 3, 0);
        end

        APB.combobar[i]:Hide();
        APB.combobar[i]:EnableMouse(false);
    end

    APB.combotext = APB:CreateFontString(nil, "OVERLAY");
    APB.combotext:SetFont(APB_Font, APB_HealthSize - 2, APB_FontOutline);
    APB.combotext:SetPoint("BOTTOMLEFT", APB.combobar[1], "TOPLEFT", 0, 2);
    APB.combotext:SetTextColor(1, 1, 1, 1)
    APB.combotext:Hide();
    APB.buffcombobar = APB.combobar;


    APB.combobar2 = {};

    for i = 1, 20 do
        APB.combobar2[i] = CreateFrame("StatusBar", nil, APB);
        APB.combobar2[i]:SetStatusBarTexture("Interface\\addons\\aspowerbar\\UI-StatusBar");
        APB.combobar2[i]:GetStatusBarTexture():SetHorizTile(false);
        APB.combobar2[i]:SetMinMaxValues(0, 100);
        APB.combobar2[i]:SetValue(100);
        APB.combobar2[i]:SetHeight(APB_HEIGHT / 2);
        APB.combobar2[i]:SetWidth(20);

        APB.combobar2[i].bg = APB.combobar2[i]:CreateTexture(nil, "BACKGROUND");
        APB.combobar2[i].bg:SetPoint("TOPLEFT", APB.combobar2[i], "TOPLEFT", -1, 1);
        APB.combobar2[i].bg:SetPoint("BOTTOMRIGHT", APB.combobar2[i], "BOTTOMRIGHT", 1, -1);

        APB.combobar2[i].bg:SetTexture("Interface\\Addons\\asPowerBar\\border.tga");
        APB.combobar2[i].bg:SetTexCoord(0.1, 0.1, 0.1, 0.1, 0.1, 0.1, 0.1, 0.1);
        APB.combobar2[i].bg:SetVertexColor(0, 0, 0, 0.8);

        if i == 1 then
            APB.combobar2[i]:SetPoint("BOTTOMLEFT", APB.combobar[1], "TOPLEFT", 0, 1);
        else
            APB.combobar2[i]:SetPoint("LEFT", APB.combobar2[i - 1], "RIGHT", 0, 0);
        end

        APB.combobar2[i]:Hide();
        APB.combobar2[i]:EnableMouse(false);
    end

    APB.combotext2 = APB.combobar2[1]:CreateFontString(nil, "ARTWORK", nil, 3);
    APB.combotext2:SetFont(APB_Font, APB_HealthSize - 2, APB_FontOutline);
    APB.combotext2:SetPoint("BOTTOMLEFT", APB.combobar2[1], "TOPLEFT", 0, 2);
    APB.combotext2:SetTextColor(1, 1, 1, 1)
    APB.combotext2:Hide();


    APB.spellbar = {};

    for i = 1, 10 do
        APB.spellbar[i] = CreateFrame("StatusBar", nil, APB);
        APB.spellbar[i]:SetStatusBarTexture("Interface\\addons\\aspowerbar\\UI-StatusBar");
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
            APB.spellbar[i]:SetPoint("BOTTOMLEFT", APB.stackbar[0], "TOPLEFT", 0, 1);
        else
            APB.spellbar[i]:SetPoint("LEFT", APB.spellbar[i - 1], "RIGHT", 3, 0);
        end

        APB.spellbar[i]:Hide();
        APB.spellbar[i]:EnableMouse(false);
    end

    C_AddOns.LoadAddOn("asMOD");

    if asMOD_setupFrame then
        asMOD_setupFrame(APB, "asPowerBar");
    end

    APB:SetScript("OnEvent", APB_OnEvent)

    APB:RegisterEvent("PLAYER_ENTERING_WORLD");
    APB:RegisterEvent("PLAYER_REGEN_DISABLED");
    APB:RegisterEvent("PLAYER_REGEN_ENABLED");
    APB:RegisterEvent("TRAIT_CONFIG_UPDATED");
    APB:RegisterEvent("TRAIT_CONFIG_LIST_UPDATED");
    APB:RegisterEvent("ACTIVE_TALENT_GROUP_CHANGED");
    APB:RegisterEvent("PLAYER_EQUIPMENT_CHANGED");
    APB:RegisterEvent("ACTIONBAR_UPDATE_USABLE");
    APB:RegisterEvent("ACTIONBAR_UPDATE_COOLDOWN");
    APB:RegisterEvent("SPELL_ACTIVATION_OVERLAY_GLOW_SHOW");
    APB:RegisterEvent("SPELL_ACTIVATION_OVERLAY_GLOW_HIDE");
    APB:RegisterEvent("ACTION_RANGE_CHECK_UPDATE");
    APB:RegisterUnitEvent("UNIT_AURA", "player");

    if UnitAffectingCombat("player") then
        APB:SetAlpha(APB_ALPHA_COMBAT);
    else
        APB:SetAlpha(APB_ALPHA_NORMAL);
    end
end
