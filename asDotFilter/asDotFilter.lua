local _, ns = ...;
local ADotF_SIZE = 30;
local ADotF_MAX_DEBUFF_SHOW = 2;
local ADotF_ALPHA = 0.9;
local ADotF_CooldownFontSize = 12;
local ADotF_CountFontSize = 12;


--설정 표시할 Unit
local ADotF_UnitList = {
    "focus", -- 주시대상 표시 안하길 원하면 이 줄 삭제
    "boss1",
    "boss2",
    "boss3",
    "boss4",
    "boss5",
}

--설정 끝
local ADotF = CreateFrame("Frame", "ADotF", UIParent);

local function asCooldownFrame_Clear(self)
    self:Clear();
end

local function asCooldownFrame_Set(self, extime, duration, enable)
    if enable then
        self:SetDrawEdge(nil);
        self:SetCooldownFromExpirationTime(extime, duration, nil);
    else
        asCooldownFrame_Clear(self);
    end
end

local function ADotF_UpdateDebuffAnchor(frames, index, size, offsetX, right, parent, isboss)
    local buff = frames[index];
    local point1 = "LEFT";
    local point2 = "RIGHT";
    local point3 = "RIGHT";

    if (right == false) then
        point1 = "RIGHT";
        point2 = "LEFT";
        point3 = "LEFT";
        offsetX = -offsetX;
    end

    if (index == 1) then
        if isboss then
            buff:SetPoint(point1, parent, point2, -50, 0);
        else
            buff:SetPoint(point1, parent, point2, 3, 0);
        end
    else
        buff:SetPoint(point1, frames[index - 1], point3, offsetX, 0);
    end

    -- Resize
    buff:SetWidth(size);
    buff:SetHeight(size * 0.8);
end


local function SetDebuff(frame, unit, aura, color)
    frame.icon:SetTexture(aura.icon);
    frame:Show();

    frame.count:Show();
    frame.count:SetText(C_UnitAuras.GetAuraApplicationDisplayCount(unit, aura.auraInstanceID, 1, 100));
    
    asCooldownFrame_Set(frame.cooldown, aura.expirationTime, aura.duration, true);


    frame.border:SetVertexColor(color.r, color.g, color.b);
end

local filter = AuraUtil.CreateFilterString(AuraUtil.AuraFilters.Harmful, AuraUtil.AuraFilters.Player);
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


local function ADotF_UpdateDebuff(unit)
    local numDebuffs = 1;
    local frame;
    local frameIcon, frameCount, frameCooldown;
    local icon, count, debuffType, duration, expirationTime, caster, spellId;
    local color;
    local frameBorder;
    local parent;
    local find = false;
    local isboss = true;

    for i = 1, #ADotF_UnitList do
        if unit == ADotF_UnitList[i] then
            find = true;
            break;
        end
    end

    if not find then
        return;
    end

    if not ADotF.units then
        ADotF.units = {};
    end

    if not ADotF.units[unit] then
        ADotF.units[unit] = {};
    end

    if not ADotF.units[unit].frames then
        ADotF.units[unit].frames = {};
    end

    if UnitExists(unit) then
        if (unit == "target") then
            if AUF_TargetFrame then
                parent = AUF_TargetFrame;
            else
                parent = _G["TargetFrame"];
            end


            isboss = false;
        elseif (unit == "focus") then
            if AUF_FocusFrame then
                parent = AUF_FocusFrame;
            else
                parent = _G["FocusFrame"];
            end
            isboss = false;
        elseif (unit == "boss1") then
            if AUF_BossFrames and AUF_BossFrames[1] then
                parent = AUF_BossFrames[1];
                isboss = false;
            else
                parent = _G["Boss1TargetFrame"];
            end
        elseif (unit == "boss2") then
            if AUF_BossFrames and AUF_BossFrames[2] then
                parent = AUF_BossFrames[2];
                isboss = false;
            else
                parent = _G["Boss2TargetFrame"];
            end
        elseif (unit == "boss3") then
            if AUF_BossFrames and AUF_BossFrames[3] then
                parent = AUF_BossFrames[3];
                isboss = false;
            else
                parent = _G["Boss3TargetFrame"];
            end
        elseif (unit == "boss4") then
            if AUF_BossFrames and AUF_BossFrames[4] then
                parent = AUF_BossFrames[4];
                isboss = false;
            else
                parent = _G["Boss4TargetFrame"];
            end
        elseif (unit == "boss5") then
            if AUF_BossFrames and AUF_BossFrames[5] then
                parent = AUF_BossFrames[5];
                isboss = false;
            else
                parent = _G["Boss5TargetFrame"];
            end
        else
            return;
        end

        local aura_list = C_UnitAuras.GetUnitAuras(unit, filter, ADotF_MAX_DEBUFF_SHOW);

        for _index, aura in ipairs(aura_list) do
            if numDebuffs > ADotF_MAX_DEBUFF_SHOW then
                break;
            end

            frame = ADotF.units[unit].frames[numDebuffs];

            if (not frame) then
                ADotF.units[unit].frames[numDebuffs] = CreateFrame("Button", nil, ADotF, "asTargetDotFrameTemplate");
                frame = ADotF.units[unit].frames[numDebuffs];
                frame:EnableMouse(false);
                frame.cooldown:SetDrawSwipe(true);
                for _, r in next, { frame.cooldown:GetRegions() } do
                    if r:GetObjectType() == "FontString" then
                        r:SetFont(STANDARD_TEXT_FONT, ADotF_CooldownFontSize, "OUTLINE");
                        r:ClearAllPoints();
                        r:SetPoint("TOP", 0, 5);
                        r:SetDrawLayer("OVERLAY");
                        break;
                    end
                end

                frame.icon:SetTexCoord(.08, .92, .18, .82);
                frame.icon:SetAlpha(ADotF_ALPHA);
                frame.border:SetTexCoord(0.08, 0.08, 0.08, 0.92, 0.92, 0.08, 0.92, 0.92);
                frame.border:SetAlpha(ADotF_ALPHA);

                frame.count:SetFont(STANDARD_TEXT_FONT, ADotF_CountFontSize, "OUTLINE");
                frame.count:ClearAllPoints();
                frame.count:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", -2, 2);

                frame.snapshot:SetFont(STANDARD_TEXT_FONT, ADotF_CountFontSize - 1, "OUTLINE")
                frame.snapshot:ClearAllPoints();
                frame.snapshot:SetPoint("CENTER", frame, "BOTTOM", 0, 1);
                frame.data = {};
            end

            color = C_UnitAuras.GetAuraDispelTypeColor(unit, aura.auraInstanceID, colorcurve);


            SetDebuff(frame, unit, aura, color);
            frame:ClearAllPoints();
            numDebuffs = numDebuffs + 1;
        end

        for i = 1, numDebuffs - 1 do
            ADotF_UpdateDebuffAnchor(ADotF.units[unit].frames, i, ADotF_SIZE, 2, true, parent, isboss);
        end
    end

    for i = numDebuffs, ADotF_MAX_DEBUFF_SHOW do
        frame = ADotF.units[unit].frames[i];

        if (frame) then
            frame:Hide();
            frame.data = {};            
        end
    end
end


local function ADotF_UpdateAllFrames()
    for i = 1, #ADotF_UnitList do
        ADotF_UpdateDebuff(ADotF_UnitList[i]);
    end
end

local function ADotF_OnEvent(self, event, arg1)
    local unit;

    if (event == "PLAYER_FOCUS_CHANGED") then
        unit = "focus"
        ADotF_UpdateDebuff(unit);
    elseif (event == "PLAYER_TARGET_CHANGED") then
        unit = "target";
        ADotF_UpdateDebuff(unit);
    elseif (event == "INSTANCE_ENCOUNTER_ENGAGE_UNIT") then
        ADotF_UpdateAllFrames();
    elseif (event == "PLAYER_ENTERING_WORLD") then        
        ADotF_UpdateAllFrames();    
    end
end

local function ADotF_OnUpdate()
    ADotF_UpdateAllFrames();
end

local function ADotF_Init()
    ADotF:SetPoint("CENTER", 0, 0)
    ADotF:SetWidth(1)
    ADotF:SetHeight(1)
    ADotF:SetScale(1)
    ADotF:Show()
    ADotF:RegisterEvent("PLAYER_FOCUS_CHANGED")
    ADotF:RegisterEvent("PLAYER_TARGET_CHANGED")
    ADotF:RegisterEvent("INSTANCE_ENCOUNTER_ENGAGE_UNIT")
    ADotF:RegisterEvent("PLAYER_ENTERING_WORLD")    
    ADotF:SetScript("OnEvent", ADotF_OnEvent)
    C_Timer.NewTicker(0.2, ADotF_OnUpdate);
end

ADotF_Init();
