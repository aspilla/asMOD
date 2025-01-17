local _, ns = ...;
local ADotF_SIZE = 30;
local ADotF_MAX_DEBUFF_SHOW = 5;
local ADotF_ALPHA = 0.9;
local ADotF_CooldownFontSize = 12;
local ADotF_CountFontSize = 12;

ADotF_ShowList_WARRIOR_1 = {
    { 445584, 0 },
    { 447513, 0 },
    { 388539, 1 },
}

ADotF_ShowList_WARRIOR_2 = {
    { 445584, 0 },
}

ADotF_ShowList_WARRIOR_3 = {
    { 447513, 0 },
    { 388539, 1 },
}

ADotF_ShowList_ROGUE_1 = {
    { 457129, 0 },
    { 703, 1, true },
    { 1943, 24 * 0.3 },    
}

ADotF_ShowList_ROGUE_2 = {
    { 441224, 0 },
}

ADotF_ShowList_ROGUE_3 = {
    { 457129, 0 },
    { 1943, 24 * 0.3 },
    { 441224, 0 },
    
}

ADotF_ShowList_HUNTER_1 = {
    { 217200, 1 },
    { 271788, 0 },
    { 131894, 0 },
}

ADotF_ShowList_HUNTER_2 = {
    { 271788, 1 },
    
}

ADotF_ShowList_HUNTER_3 = {
    { 259491, 1 },
}

ADotF_ShowList_MONK_1 = {
}

ADotF_ShowList_MONK_2 = {
}

ADotF_ShowList_MONK_3 = {
    { 228287, 0 },
}

ADotF_ShowList_WARLOCK_1 = {
    { 980, 1 },
    { 316099, 1 },
    { 146739, 1 },    
    { 445474, 1 },
}

ADotF_ShowList_WARLOCK_2 = {
    { 460553, 0 },
    { 270569, 0 },
}


ADotF_ShowList_WARLOCK_3 = {
    { 157736, 1 },
    { 445474, 1 },
}

ADotF_ShowList_PRIEST_1 = {
    {204213, 1 },           -- 사악
    {589, 1 },              -- 고통
}

ADotF_ShowList_PRIEST_2 = {
    {14914, 0},              --신충
    {589, 1 },              -- 고통
}

ADotF_ShowList_PRIEST_3 = {
    {589, 1 },              -- 고통
    {34914, 1},              --흡선
    {335467, 0 },           -- 파멸
}

ADotF_ShowList_SHAMAN_1 = {
    { 188389, 18 * 0.3 },
}

ADotF_ShowList_SHAMAN_2 = {
    { 188389, 18 * 0.3 },
}

ADotF_ShowList_SHAMAN_3 = {
    { 188389, 18 * 0.3 },
}

ADotF_ShowList_DRUID_1 = {
    { 164812, 1 },
    { 164815, 1 },
    { 202347, 1 },
}


ADotF_ShowList_DRUID_2 = {
    { 155722, 12 * 0.3, true },
    { 155625, 1, true },    
    { 1079, 19 * 0.3, true },   
}

ADotF_ShowList_DRUID_3 = {
    { 164812, 1 },
}

ADotF_ShowList_DRUID_4 = {
    { 164812, 1 },
    { 155722, 12 * 0.3 },
    { 164815, 1 },    
    { 1079, 19 * 0.3 },    
}


ADotF_ShowList_MAGE_1 = {
    {210824, 0}, 
    {444735, 0},
}

ADotF_ShowList_MAGE_2 = {
    { 453268, 0 },
    { 12654, 0 },
}

ADotF_ShowList_MAGE_3 = {
    { 228358, 0 },
    { 443740, 0}, 
}

ADotF_ShowList_DEATHKNIGHT_1 = {
    { 434765, 0 },
    { 458478, 0 },
    { 55078, 0 },
}

ADotF_ShowList_DEATHKNIGHT_2 = {
    { 434765, 0 },
    { 55095, 0 },
}

ADotF_ShowList_DEATHKNIGHT_3 = {
    { 458478, 0 },
    { 194310, 0 },
    { 191587, 1 },    
}

ADotF_ShowList_EVOKER_1 = {
    { 357209, 0 },

}

ADotF_ShowList_EVOKER_2 = {
    { 357209, 0 },
}

ADotF_ShowList_EVOKER_3 = {
    { 409560, 0 },
    { 357209, 0 },
}

ADotF_ShowList_PALADIN_1 = {    
    { 414022, 0 },
}

ADotF_ShowList_PALADIN_2 = {
    { 197277, 0 },
}

ADotF_ShowList_PALADIN_3 = {
    { 197277, 0 },
}

ADotF_ShowList_DEMONHUNTER_1 = {
    {442624, 0},
    {391191, 0},
}

ADotF_ShowList_DEMONHUNTER_2 = {
    {442624, 0},
    { 207771, 0 },
    { 247456, 0 },
}



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

local ADotF = nil;
ADotF_ShowList = nil;
ADotF_NameList = {};


local function ADotF_UnitDebuff(unit, buff, filter)

    local i = 1;
    local ret = nil;

    local auraList = ns.ParseAllDebuff(unit);

    auraList:Iterate(function(auraInstanceID, aura)
        if aura and aura.spellId == buff then
            if aura.duration > 0 then
                ret = aura;
                return true;
            elseif ret == nil then
                ret = aura;
                return true;
            end
        end
        return false;
    end);

    if ret then
        return ret.name, ret.icon, ret.applications, ret.debuffType, ret.duration, ret.expirationTime, ret.sourceUnit, ret.spellId;
    end

    return nil;
end

local function asCooldownFrame_Clear(self)
    self:Clear();
end

local function asCooldownFrame_Set(self, start, duration, enable, forceShowDrawEdge, modRate)
    if enable and enable ~= 0 and start > 0 and duration > 0 then
        self:SetDrawEdge(forceShowDrawEdge);
        self:SetCooldown(start, duration, modRate);
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
            buff:SetPoint(point1, parent, point2, 2, 0);
        end
    else
        buff:SetPoint(point1, frames[index - 1], point3, offsetX, 0);
    end

    -- Resize
    buff:SetWidth(size);
    buff:SetHeight(size * 0.8);
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

    if not ADotF_ShowList then
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

    local maxIdx = #ADotF_ShowList;

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

        local guid = UnitGUID(unit);

        for i = 1, #ADotF_ShowList do
            _, icon, count, debuffType, duration, expirationTime, caster, spellId = ADotF_UnitDebuff(unit,
                ADotF_ShowList[i][1], "PLAYER");

            if icon and caster == "player" or caster == "pet" then
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
                    frame.count:SetPoint("BOTTOMRIGHT", frame ,"BOTTOMRIGHT", -2, 2);

                    frame.snapshot:SetFont(STANDARD_TEXT_FONT, ADotF_CountFontSize - 1, "OUTLINE")
                    frame.snapshot:ClearAllPoints();
                    frame.snapshot:SetPoint("CENTER", frame ,"BOTTOM", 0, 1);
                end

                -- set the icon
                frameIcon = frame.icon;
                frameIcon:SetTexture(icon);                

                -- set the count
                frameCount = frame.count;

                -- Handle cooldowns
                frameCooldown = frame.cooldown;

                if (count > 1) then
                    frameCount:SetText(count);
                    frameCount:Show();
                    
                else
                    frameCount:Hide();                    
                end

                if (duration > 0) then
                    frameCooldown:Show();
                    asCooldownFrame_Set(frameCooldown, expirationTime - duration, duration, duration > 0, true);
                    frameCooldown:SetHideCountdownNumbers(false);
                else
                    frameCooldown:Hide();
                end

                -- set debuff type color
                if (debuffType) then
                    color = DebuffTypeColor[debuffType];
                else
                    color = DebuffTypeColor["none"];
                end

                frameBorder = frame.border;
                frameBorder:SetVertexColor(color.r, color.g, color.b);                

                frame:ClearAllPoints();
                frame:Show();

                local alert_du = ADotF_ShowList[i][2];
                local checksnapshot = ADotF_ShowList[i][3];
                
                if alert_du == 1 then
                    alert_du = duration * 0.3;
                    ADotF_ShowList[i][2] = alert_du;
                end

                if  checksnapshot and asDotSnapshot and asDotSnapshot.Relative then                
                    local snapshots = asDotSnapshot.Relative(guid, spellId);
            
                    if snapshots then
            
                        frame.snapshot:SetText(math.floor(snapshots * 100));
                        if snapshots > 1 then
                            frame.snapshot:SetTextColor(0.5, 1, 0.5);                
                            frame.snapshot:Show();
                        elseif snapshots == 1 then                                         
                            frame.snapshot:Hide();
                        else
                            frame.snapshot:SetTextColor(1, 0.5, 0.5);
                            frame.snapshot:Show();
                        end                 
                        
                    else            
                        frame.snapshot:Hide();
                    end
                    --print("working")
                else
                    frame.snapshot:Hide();
                end

                if (((expirationTime - GetTime()) <= alert_du) and duration > 0) then
                    ns.lib.ButtonGlow_Start(frame);
                else
                    ns.lib.ButtonGlow_Stop(frame);
                end
                numDebuffs = numDebuffs + 1;
            end
        end

        for i = 1, numDebuffs - 1 do
            ADotF_UpdateDebuffAnchor(ADotF.units[unit].frames, i, ADotF_SIZE, 2, true, parent, isboss);
        end
    end

    for i = numDebuffs, maxIdx do
        frame = ADotF.units[unit].frames[i];

        if (frame) then
            frame:Hide();
            ns.lib.ButtonGlow_Stop(frame);
        end
    end
end


local function ADotF_UpdateAllFrames()
    for i = 1, #ADotF_UnitList do
        ADotF_UpdateDebuff(ADotF_UnitList[i]);
    end
end

local function ADotF_InitList()
    local spec = GetSpecialization();
    local _, englishClass = UnitClass("player");
    local listname = "ADotF_ShowList_";

    if spec == nil or spec > 4 or (englishClass ~= "DRUID" and spec > 3) then
		spec = 1;
	end

    if spec then
        listname = "ADotF_ShowList_" .. englishClass .. "_" .. spec;
    end

    ADotF_ShowList = _G[listname];
    ADotF_NameList = {};

    if ADotF_ShowList then
        for idx = 1, #ADotF_ShowList do
            ADotF_NameList[ADotF_ShowList[idx][1]] = ADotF_ShowList[idx][2];
        end
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
        ADotF_InitList();
        ADotF_UpdateAllFrames();
    elseif (event == "ACTIVE_TALENT_GROUP_CHANGED") then
        ADotF_InitList();
    end
end

local function ADotF_OnUpdate()
    ADotF_UpdateAllFrames();
end

local function ADotF_Init()
    ADotF = CreateFrame("Frame", "ADotF", UIParent)

    ADotF:SetPoint("CENTER", 0, 0)
    ADotF:SetWidth(1)
    ADotF:SetHeight(1)
    ADotF:SetScale(1)
    ADotF:Show()
    ADotF:RegisterEvent("PLAYER_FOCUS_CHANGED")
    ADotF:RegisterEvent("PLAYER_TARGET_CHANGED")
    ADotF:RegisterEvent("INSTANCE_ENCOUNTER_ENGAGE_UNIT")
    ADotF:RegisterEvent("PLAYER_ENTERING_WORLD")
    ADotF:RegisterEvent("ACTIVE_TALENT_GROUP_CHANGED")    
    ADotF:SetScript("OnEvent", ADotF_OnEvent)
    C_Timer.NewTicker(0.2, ADotF_OnUpdate);
end

ADotF_Init();
