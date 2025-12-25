local _, ns = ...;

local function clear_cooldownframe(self)
    self:Clear();
end

local function set_cooldownframe(self, extime, duration, enable)
    if enable then
        self:SetDrawEdge(nil);
        self:SetCooldownFromExpirationTime(extime, duration, nil);
    else
        clear_cooldownframe(self);
    end
end

local function SetAura(frame, unit, aura, color)
    frame.icon:SetTexture(aura.icon);
    frame:Show();

    frame.count:Show();
    frame.count:SetText(C_UnitAuras.GetAuraApplicationDisplayCount(unit, aura.auraInstanceID, 1, 100));

    set_cooldownframe(frame.cooldown, aura.expirationTime, aura.duration, true);

    frame.border:SetVertexColor(color.r, color.g, color.b);    
end
local function UpdateBuffFrames(frame, auraList)
    local i = 0;
    local parent = frame;
    local unit = frame.unit;

    for _index, aura in ipairs(auraList) do
        i = i + 1;
        if i > #(frame.buffframes) then
            break;
        end


        local buffframe = parent.buffframes[i];

        buffframe.unit = unit;
        buffframe.auraInstanceID = aura.auraInstanceID;
        local color = { r = 0, g = 0, b = 0 };

        SetAura(buffframe, unit, aura, color);
    end

    for j = i + 1, #frame.buffframes do
        local buffframe = parent.buffframes[j];

        if (buffframe) then
            buffframe:Hide();
            ns.lib.PixelGlow_Stop(buffframe);
            buffframe.data = {};
        end
    end
end

local debuffinfo = {
	[1] = DEBUFF_TYPE_MAGIC_COLOR,
	[2] = DEBUFF_TYPE_CURSE_COLOR,
	[3] = DEBUFF_TYPE_DISEASE_COLOR,
	[4] = DEBUFF_TYPE_POISON_COLOR, 
	[5] = DEBUFF_TYPE_BLEED_COLOR, 
	[0] = DEBUFF_TYPE_NONE_COLOR,
};
local colorcurve = C_CurveUtil.CreateColorCurve();
colorcurve:SetType(Enum.LuaCurveType.Step);
for dispeltype, v in pairs(debuffinfo) do
    colorcurve:AddPoint(dispeltype, v);
end

local function UpdateDebuffFrames(frame, auraList)
    local i = 0;
    local parent = frame;
    local unit = frame.unit;

    for _index, aura in ipairs(auraList) do
        i = i + 1;
        if i > #(frame.debuffframes)  then
            break;
        end

        local debuffframe = parent.debuffframes[i];

        debuffframe.unit = unit;
        debuffframe.auraInstanceID = aura.auraInstanceID;

        local color = C_UnitAuras.GetAuraDispelTypeColor(unit, aura.auraInstanceID, colorcurve);

         SetAura(debuffframe, unit, aura, color);
    end

    for j = i + 1, #frame.debuffframes do
        local debuffframe = parent.debuffframes[j];

        if (debuffframe) then
            debuffframe:Hide();
            debuffframe.data = {};
        end
    end
end

local bufffilter = AuraUtil.CreateFilterString(AuraUtil.AuraFilters.Helpful);
local debufffilter_attack = AuraUtil.CreateFilterString(AuraUtil.AuraFilters.Harmful, AuraUtil.AuraFilters.Player);
local debufffilter_helpful = AuraUtil.CreateFilterString(AuraUtil.AuraFilters.Harmful);

function ns.UpdateAuras(frame)
    local unit = frame.unit; 
    if frame.debuffupdate  then
        local filter = debufffilter_helpful;

        if UnitCanAttack("player", unit) then
            filter = debufffilter_attack;
        end

        local activeDebuffs = C_UnitAuras.GetUnitAuras(unit, filter, #(frame.debuffframes));
        UpdateDebuffFrames(frame, activeDebuffs);
    end

    if frame.buffupdate then
        local activeBuffs = C_UnitAuras.GetUnitAuras(unit, bufffilter, #(frame.buffframes));
        UpdateBuffFrames(frame, activeBuffs);
    end
end
