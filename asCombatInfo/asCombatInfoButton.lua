local _, ns = ...;

local rangeIcon = CreateAtlasMarkup("PlayerPartyBlip", 32, 32, 0, 0, 255, 0, 0);
local notuseIcon = CreateAtlasMarkup("PlayerPartyBlip", 32, 32, 0, 0, 100, 100, 100);

ns.Button = {
    type = nil,
    realspell = nil,
    spell = nil,
    unit = nil,
    spellid = nil,
    action = nil,
    frame = nil,
    inRange = true,
    alert = false,
    snapshotalert = false,
    checkcool = nil,
    checkplatecount = nil,
    buffshowtime = nil,
    realstartime = nil,


    icon = nil,
    iconDes = false,
    iconColor = { r = 1.0, g = 1.0, b = 1.0 },
    alpha = 1,
    borderColor = { r = 1.0, g = 1.0, b = 1.0 },
    start = 0,
    duration = 0,
    enable = false,
    reversecool = false,
    spellcool = nil,
    spellcoolColor = { r = 0.8, g = 0.8, b = 1 },
    count = nil,
    buffalert = false,
    coolalert = false,
    bufflist = {},
    alertbufflist = {},

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


function ns.Button:initButton()
    self.icon = nil;
    self.iconDes = false;
    self.iconColor = { r = 1.0, g = 1.0, b = 1.0 };
    self.alpha = 1;
    self.borderColor = { r = 0, g = 0, b = 0 };
    self.start = 0;
    self.duration = 0;
    self.enable = false;
    self.reversecool = false;
    self.spellcool = nil;
    self.spellcoolColor = { r = 0.8, g = 0.8, b = 1 };
    self.count = nil;
    self.buffalert = false;
    self.alert2 = false;
    self.coolalert = false;
    self.snapshotalert = false;
    self.improvebuff = false;
    self.currtime = GetTime();
    self.gcd = select(2, asGetSpellCooldown(61304));

    local name, _, _, _, _, _, spellid = asGetSpellInfo(self.realspell);

    if spellid and spellid ~= self.spellid then
        self.spellid = spellid;
        self.spell = name;
        ACI_SpellID_list[self.spellid] = true;
        if name then
            ACI_SpellID_list[name] = true;
        end

        if self.type ~= ns.EnumButtonType.BuffOnly and self.type ~= ns.EnumButtonType.DebuffOnly then
            ns.eventhandler.registerEventFilter(name, self);
        end
        if self.type == ns.EnumButtonType.Debuff or self.type == ns.EnumButtonType.DebuffOnly then
            ACI_Debuff_list[name] = true;
            ns.eventhandler.registerAura(self.unit, name);
            if self.checkplatecount then
                ns.eventhandler.registerAura("nameplate", name, self.checkplatecount);
            end
        elseif self.type == ns.EnumButtonType.Buff or self.type == ns.EnumButtonType.BuffOnly or self.type == ns.EnumButtonType.Totem then
            ns.eventhandler.registerAura(self.unit, name);
            ACI_Buff_list[name] = true;
        end

        if self.type == ns.EnumButtonType.Totem then
            ns.eventhandler.registerTotem(name, self);
        end
    end
end

function ns.Button:checkTotem()
    if self.spell == nil then
        return;
    end

    local t = self.type;

    if t ~= ns.EnumButtonType.Totem then
        return;
    end
    local buff = self.spell;

    if self.realbuff then
        buff = self.realbuff;
    end

    local totem = ns.aurafunctions.checkTotem(buff);
    local aura = ns.aurafunctions.checkAura("player", buff);

    if totem then
        self.icon = totem[4];
        self.iconDes = false;
        self.iconColor = { r = 1.0, g = 1.0, b = 1.0 };
        self.alpha = 1;
        self.start = totem[2]
        self.duration = totem[3];
        self.enable = true;
        self.reversecool = true;
        local expirationTime = self.start + self.duration;

        if self.number == 1 then
            self.number = self.duration * 0.3;
        end

        if self.number and (expirationTime - self.currtime) <= self.number and self.duration > 0 then
            self.buffalert = true;
        end

        local color;

        if aura then
            color = { r = 0, g = 1, b = 0 };
        else
            color = { r = 1, g = 0, b = 0 };
        end
        self.borderColor = color;
    else
        local bufflist = self.bufflist;
        for _, buff in pairs(bufflist) do
            local totem = ns.aurafunctions.checkTotem(buff);
            local aura = ns.aurafunctions.checkAura("player", buff);

            if totem then
                self.icon = totem[4];
                self.iconDes = false;
                self.iconColor = { r = 1.0, g = 1.0, b = 1.0 };
                self.alpha = 1;
                self.start = totem[2]
                self.duration = totem[3];
                self.enable = true;
                self.reversecool = true;
                local expirationTime = self.start + self.duration;

                if self.number == 1 then
                    self.number = self.duration * 0.3;
                end

                if self.number and (expirationTime - self.currtime) <= self.number and self.duration > 0 then
                    self.buffalert = true;
                end

                local color;

                if aura then
                    color = { r = 0, g = 1, b = 0 };
                else
                    color = { r = 1, g = 0, b = 0 };
                end
                self.borderColor = color;
                break;
            end
        end
    end
end

function ns.Button:checkBuffList()
    if self.unit == nil or self.bufflist == nil then
        return;
    end

    local bufflist = self.bufflist;
    local t = self.type;

    local count = 0;
    local extemp = 0;

    if self.type == ns.EnumButtonType.Buff or self.type == ns.EnumButtonType.BuffOnly then
        if bufflist[1] == 1 then
            count = ns.aurafunctions.checkAuraList(self.unit, bufflist);
        else
            for _, buff in pairs(bufflist) do
                local aura = ns.aurafunctions.checkAura(self.unit, buff);

                if aura then
                    count = count + 1;
                    -- 주사위 최대 버프 시간을 우선으로 보이자
                    if self.icon == nil or aura.expirationTime > (self.start + self.duration) then
                        self.icon = aura.icon;
                        self.start = aura.expirationTime - aura.duration
                        self.duration = aura.duration;
                        self.reversecool = true;
                        extemp = aura.expirationTime;

                        local color;
                        local buff_miss = false;

                        if aura.dispelName then
                            color = DebuffTypeColor[aura.dispelName];
                        elseif buff_miss then
                            color = { r = 1.0, g = 0, b = 0 };
                        else
                            if t == 4 or t == 8 then
                                color = DebuffTypeColor["none"];
                            else
                                color = DebuffTypeColor["Disease"];
                            end
                        end
                        self.borderColor = color;

                        if self.number == 1 then
                            self.number = self.duration * 0.3;
                        end

                        if self.number and (aura.expirationTime - self.currtime) <= self.number and self.duration > 0 then
                            self.buffalert = true;
                        end
                    end
                end
            end

            if count > 3 then
                self.alert2 = true;
            end
        end
        
        if count > 1 then
            self.count = count;
        end
    elseif self.type == ns.EnumButtonType.Debuff or self.type == ns.EnumButtonType.DebuffOnly then
        for _, buff in pairs(bufflist) do
            local aura = ns.aurafunctions.checkAura(self.unit, buff);

            if aura then
                self.icon = aura.icon;
                self.start = aura.expirationTime - aura.duration
                self.duration = aura.duration;
                self.reversecool = true;
                extemp = aura.expirationTime;

                local color;
                local buff_miss = false;

                if aura.dispelName then
                    color = DebuffTypeColor[aura.dispelName];
                elseif buff_miss then
                    color = { r = 1.0, g = 0, b = 0 };
                else
                    if t == 4 or t == 8 then
                        color = DebuffTypeColor["none"];
                    else
                        color = DebuffTypeColor["Disease"];
                    end
                end
                self.borderColor = color;

                if self.number == 1 then
                    self.number = self.duration * 0.3;
                end

                if self.number and (aura.expirationTime - self.currtime) <= self.number and self.duration > 0 then
                    self.buffalert = true;
                end
                break;
            end
        end
    end
end

function ns.Button:checkBuff()
    if self.unit == nil or self.spell == nil then
        return;
    end

    local t = self.type;

    if t < ns.EnumButtonType.Buff or t == ns.EnumButtonType.Totem then
        return;
    end

    local buff = self.spell;

    if self.realbuff then
        buff = self.realbuff;
    end

    local aura = ns.aurafunctions.checkAura(self.unit, buff);

    if aura then
        self.icon = aura.icon;
        self.iconDes = false;
        self.iconColor = { r = 1.0, g = 1.0, b = 1.0 };
        self.alpha = 1;
        self.start = aura.expirationTime - aura.duration
        self.duration = aura.duration;
        self.enable = true;
        self.reversecool = true;
        if aura.applications and aura.applications > 0 then
            self.count = aura.applications;
        end

        if self.number == 1 then
            self.number = self.duration * 0.3;
        end

        if self.number and (aura.expirationTime - self.currtime) <= self.number and self.duration > 0 then
            self.buffalert = true;
        end

        if aura.points and aura.points[1] and not (aura.applications and aura.applications > 0) then
            if (aura.points[1] > 999999) then
                self.count = math.ceil(aura.points[1] / 1000000) .. "m"
            elseif (aura.points[1] > 999) then
                self.count = math.ceil(aura.points[1] / 1000) .. "k"
            end          
        end
        
        local color;
        local buff_miss = false;

        if aura.dispelName then
            color = DebuffTypeColor[aura.dispelName];
        elseif buff_miss then
            color = { r = 1.0, g = 0, b = 0 };
        else
            if t == ns.EnumButtonType.Debuff or t == ns.EnumButtonType.DebuffOnly then
                color = DebuffTypeColor["none"];
            else
                color = DebuffTypeColor["Disease"];
            end
        end
        self.borderColor = color;
    end
end

function ns.Button:checkOthers()
    if self.alertbufflist then
        for _, buff in pairs(self.alertbufflist) do
            local aura = ns.aurafunctions.checkAura(self.unit, buff);
            if aura and (aura.expirationTime - self.currtime) > self.gcd then
                self.alert2 = true;
                break;
            end
        end
    end
end

local function checkImprovedBuffList(self, aura, cachelist)
    for i, v in pairs(cachelist) do
        if v.expirationTime == aura.expirationTime then            
            return;
        end     
    end

    for i, v in pairs(cachelist) do
        if self.currtime - v.expirationTime > 30 then
            cachelist[i] = nil;            
        end        
    end

    tinsert(cachelist, aura);
end

local function isImprovedBuff(start, cachelist)
    for _, buffs in pairs(cachelist) do
        for _, aura in pairs(buffs) do
            if start < aura.expirationTime and start > aura.expirationTime - aura.duration then
                return true;
            end
        end
    end

    return false;
end


function ns.Button:checkSpellCoolInBuff()
    if not self.icon and self.start and self.duration then
        return;
    end

    local t = self.type;

    if (t ~= ns.EnumButtonType.DebuffOnly and t ~= ns.EnumButtonType.BuffOnly) and self.spellid then
        local spellstart, spellduration = asGetSpellCooldown(self.spellid);
        local charges, maxCharges = asGetSpellCharges(self.spellid);

        if spellduration and (charges == nil or charges == 0) then
            local ex = spellduration + spellstart;
            local remain = ex - GetTime();

            if spellduration > self.gcd then
                self.spellcool = math.ceil(remain);
            end
        end

        local isUsable, notEnoughMana = C_Spell.IsSpellUsable(self.spellid);

        if self.spellcool == nil then
            if self.inRange == false and isUsable then
                self.spellcool = rangeIcon;
            elseif not isUsable then
                self.spellcool = notuseIcon;
            end
        end
    end
end

local function GetAction(actionlist, spell)
    for _, action in pairs(actionlist) do
        local type, id, subType, spellID = GetActionInfo(action);

        if id and type and (type == "spell" or type == "macro") then
            local name = asGetSpellInfo(id);
            if name and name == spell then
                return action;
            end
        end
    end
end

function ns.Button:checkSpell()
    if self.icon ~= nil or self.spellid == nil then
        return;
    end


    local spellid                                          = self.spellid;
    local action                                           = GetAction(self.actionlist, self.spell)

    local spellname, _, icon                               = asGetSpellInfo(spellid)
    local start, duration, enable                          = asGetSpellCooldown(spellid);
    local isUsable, notEnoughMana                          = C_Spell.IsSpellUsable(spellid);
    local charges, maxCharges, chargeStart, chargeDuration = asGetSpellCharges(spellid);
    local count                                            = charges;

    if count == 1 and (not maxCharges or maxCharges <= 1) then
        count = 0;
    end

    if action then
        isUsable = IsUsableAction(action);
    end

    if not count or count == 0 then
        count = C_Spell.GetSpellCastCount(spellid);
    end

    if (not charges or charges == 0) and action then
        charges, maxCharges, chargeStart, chargeDuration = GetActionCharges(action);
    end

    if isUsable and duration > self.gcd then
        isUsable = false
    end

    if (charges and maxCharges and maxCharges > 1 and charges < maxCharges) then
        start = chargeStart;
        duration = chargeDuration;
    end


    --seting
    local t = self.type;

    self.icon = icon;

    if t == ns.EnumButtonType.BuffOnly or t == ns.EnumButtonType.DebuffOnly then
        isUsable = false;
        start = 0;
        duration = 0;
        count = 0;
    end


    if t == ns.EnumButtonType.Spell and self.number then
        if self.number == 1 then
            if isUsable then
                --마격
                self.alert2 = true;
            end
        elseif self.number > 10 then
            if UnitHealth("target") and UnitHealthMax("target") > 0 and UnitHealth("target") > 0 then
                local health = UnitHealth("target") / UnitHealthMax("target") * 100

                if health <= self.number then
                    -- 화법 마격 알림으로 끔
                    --self.alert2 = true;
                elseif not (self.alert == true) then
                    isUsable = false;
                end
            elseif not (self.alert == true) then
                isUsable = false;
            end
        end
    end

    if (isUsable) then
        self.iconDes = false;
        if t == ns.EnumButtonType.Spell then
            self.iconColor = { r = 1.0, g = 1.0, b = 1.0 };
        else
            self.iconColor = { r = 0.5, g = 0.5, b = 0.5 };
        end

        if self.inRange == false then
            self.iconColor = { r = 0.3, g = 0, b = 0 };
        end
    else
        self.iconDes = true;
        self.iconColor = { r = 0.5, g = 0.5, b = 0.5 };

        if (notEnoughMana) then
            -- do nothing
        end

        if not (t == ns.EnumButtonType.BuffOnly or t == ns.EnumButtonType.DebuffOnly) then
            if self.inRange == false then
                self.spellcool = rangeIcon;
            end
        end
    end


    self.alpha = 1;
    self.start = start;
    self.duration = duration;
    self.enable = false;

    if count and count > 0 then
        self.count = count;
    end

    if self.buffshowtime then
        local realcasttime = ns.eventhandler.getCastTime(self.spellid);

        if realcasttime then
            if self.currtime < realcasttime + self.buffshowtime then
                self.start = realcasttime;
                self.duration = self.buffshowtime;
                self.iconDes = false;
                self.iconColor = { r = 1.0, g = 1.0, b = 1.0 };
                self.alpha = 1;
                self.enable = true;
                self.reversecool = true;
                self.borderColor = DebuffTypeColor["none"];
                self.count = nil;
            end
        end
    end
end

function ns.Button:checkCount()
    if self.checkplatecount then
        local buff = self.spell;

        if self.realbuff then
            buff = self.realbuff;
        end
        local count = ns.aurafunctions.getPlateCount(buff);

        if count then
            self.count = count;
        end
    end

    local buff = self.countbuff;
    local unit = "player"

    if self.countdebuff then
        buff = self.countdebuff;
        unit = "target"
    end

    if buff == nil then
        return;
    end

    local aura = ns.aurafunctions.checkAura(unit, buff);

    if aura then
        if aura.applications and aura.applications > 0 then
            self.count = aura.applications;

            if self.number and self.count >= self.number then
                self.buffalert = true;
            else
                self.buffalert = false;
            end
        end
    end
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

function ns.Button:showButton()
    local frameIcon;
    local frameCooldown;
    local frameCount;
    local frameBorder;    
    local guid = UnitGUID(self.unit);

    local frame = self.frame;
    if not frame then
        return;
    end
    frameIcon = frame.icon;
    frameCooldown = frame.cooldown;    
    frameBorder = frame.border;
    frameCount = frame.count;

    if self.icon == nil then
        frame:Hide();
        return;
    else
        frame:Show();
    end

    frameIcon:SetTexture(self.icon);
    frameIcon:SetDesaturated(self.iconDes);
    frameIcon:SetVertexColor(self.iconColor.r, self.iconColor.g, self.iconColor.b);
    frameIcon:SetAlpha(self.alpha);
    frameBorder:SetVertexColor(self.borderColor.r, self.borderColor.g, self.borderColor.b);
    frameBorder:Show();

    if self.improvebuff then       
        frameBorder:SetVertexColor(1,1,1);
        self.buffalert = false;
    end


    if (self.duration ~= nil and self.duration > 0 and self.duration < 500) then
        -- set the count
        asCooldownFrame_Set(frameCooldown, self.start, self.duration, self.duration > 0, self.enable);                
        frameCooldown:Show();
        frameCooldown:SetReverse(self.reversecool);


        local remain = self.start + self.duration - GetTime();
        if self.improvebuff then  
            frame.cooldownfont:SetTextColor(0.7, 1, 0.7);
            frame.cooldownfont:SetFont(STANDARD_TEXT_FONT, frame.cooldownfont.fontsize + 3, "OUTLINE")
        elseif remain < 5 then
            frame.cooldownfont:SetTextColor(1, 0.3, 0.3);
            frame.cooldownfont:SetFont(STANDARD_TEXT_FONT, frame.cooldownfont.fontsize + 3, "OUTLINE")
        elseif remain < 10 then
            frame.cooldownfont:SetTextColor(1, 1, 0.3);
            frame.cooldownfont:SetFont(STANDARD_TEXT_FONT, frame.cooldownfont.fontsize + 1, "OUTLINE")
        else
            frame.cooldownfont:SetTextColor(0.8, 0.8, 1);
            frame.cooldownfont:SetFont(STANDARD_TEXT_FONT, frame.cooldownfont.fontsize, "OUTLINE")
        end
    else
        frameCooldown:Hide();
    end

    if self.spellcool then
        frame.spellcool:SetText(self.spellcool);
        frame.spellcool:SetVertexColor(self.spellcoolColor.r, self.spellcoolColor.g, self.spellcoolColor.b);
        frame.spellcool:Show();
        
    else
        frame.spellcool:Hide();
    end

    self.coolalert = false;
    if self.checkcool then
        if (self.reversecool == false) then
            if self.duration == nil or self.duration <= self.gcd then
                self.coolalert = true;
            end
        else
            if self.spellcool == nil or tonumber(self.spellcool) == nil then
                self.coolalert = true;
            end
        end
    end

    if self.count then
        if frame.cooldownfont then
            frame.cooldownfont:ClearAllPoints();
            frame.cooldownfont:SetPoint("TOPLEFT", 4, -4);            
        end

        frameCount:SetText(self.count)
        frameCount:Show();
    else
        if frame.cooldownfont then
            frame.cooldownfont:ClearAllPoints();
            frame.cooldownfont:SetPoint("CENTER", 0, 0);            
        end

        frameCount:Hide();
    end

    if self.checksnapshot and asDotSnapshot and asDotSnapshot.Relative then
        
        local snapshots = asDotSnapshot.Relative(guid, self.realbuff);

        if snapshots then

            frame.snapshot:SetText(math.floor(snapshots * 100));
            if snapshots > 1 then
                frame.snapshot:SetTextColor(0.5, 1, 0.5);                
                frame.snapshot:Show();
            elseif snapshots == 1 then
                frame.snapshot:SetTextColor(0.5, 0.5, 0.5);                
                frame.snapshot:Hide();
            else
                frame.snapshot:SetTextColor(1, 0.5, 0.5);
                frame.snapshot:Show();
                self.snapshotalert = true;
            end   
            
        else            
            frame.snapshot:Hide();
        end
        --print("working")
    else
        frame.snapshot:Hide();
    end

    if self.snapshotalert then
        ns.lib.PixelGlow_Start(frame, { 1, 0.5, 0.5 });
    elseif self.buffalert then
        ns.lib.PixelGlow_Start(frame, { 0.5, 1, 0.5 });
    elseif self.alert2 then
        ns.lib.PixelGlow_Start(frame, { 0.7, 0.7, 1 });
    elseif self.coolalert then
        ns.lib.PixelGlow_Start(frame, { 1, 1, 1 });
    elseif self.alert then
        ns.lib.PixelGlow_Start(frame);
    else
        ns.lib.PixelGlow_Stop(frame)
    end
end

local function GetActionSlot(arg1)
    local ret = {};


    for lActionSlot = 1, 180 do
        local type, id, subType, spellID = GetActionInfo(lActionSlot);

        if id and type and type == "macro" then
            local name = asGetSpellInfo(id);

            if name and name == arg1 then
                tinsert(ret, lActionSlot);
            end
        end
    end

    for lActionSlot = 1, 180 do
        local type, id, subType, spellID = GetActionInfo(lActionSlot);

        if id and type and type == "spell" then
            local name = asGetSpellInfo(id);

            if name and name == arg1 then
                tinsert(ret, lActionSlot);
            end
        end
    end



    return ret;
end

function ns.Button:clear()
    if self.time then
        self.time:Cancel();
    end
end

function ns.Button:init(config, frame)
    if self.time then
        self.time:Cancel();
    end

    self.realspell = config[1];
    self.spell = select(1, asGetSpellInfo(config[1]));
    self.type = config[2];
    self.unit = config[3];
    self.number = config[4];
    self.countbuff = config[5];
    if type(self.countbuff) == "number" then
        self.countbuff = select(1, asGetSpellInfo(self.countbuff));
    end
    self.realbuff = config[6];
    self.countdebuff = config[7];
    self.bufflist = config[8];
    self.alertbufflist = config[9];
    self.checkcool = config[10];
    self.checkplatecount = config[11];
    self.buffshowtime = config[12];    
    self.checksnapshot = config[13];
    self.spellid = select(7, asGetSpellInfo(self.spell));
    if self.spellid == nil then
        self.spellid = select(7, asGetSpellInfo(self.realspell));
    end

    ns.lib.PixelGlow_Stop(self.frame)

    if self.spell == nil then
        return;
    end

    self.frame = frame;

    local actionlist = GetActionSlot(self.spell);
    self.actionlist = actionlist;

    self.inRange = true;

    if self.unit == nil then
        if self.type == ns.EnumButtonType.Debuff or self.type == ns.EnumButtonType.DebuffOnly then
            self.unit = "target"
        else
            self.unit = "player"
        end
    end

    if self.type ~= ns.EnumButtonType.BuffOnly and self.type ~= ns.EnumButtonType.DebuffOnly then
        ACI_SpellID_list[self.spell] = true;
        ACI_SpellID_list[self.spellid] = true;
        ns.eventhandler.registerEventFilter(self.spell, self);

        if self.countbuff then
            ns.eventhandler.registerEventFilter(self.countbuff, self);
        end

        for _, action in pairs(actionlist) do
            ns.eventhandler.registerAction(action, self);
        end
    end
    if self.type == ns.EnumButtonType.Debuff or self.type == ns.EnumButtonType.DebuffOnly then
        ACI_Debuff_list[self.spell] = true;
        ns.eventhandler.registerAura(self.unit, self.spell);
        if self.checkplatecount then
            ns.eventhandler.registerAura("nameplate", self.spell, self.checkplatecount);
        end

        if self.bufflist then
            for _, debuff in pairs(self.bufflist) do
                ns.eventhandler.registerAura(self.unit, debuff);
            end
        end
    elseif self.type == ns.EnumButtonType.Buff or self.type == ns.EnumButtonType.BuffOnly or self.type == ns.EnumButtonType.Totem then
        ACI_Buff_list[self.spell] = true;
        ns.eventhandler.registerAura(self.unit, self.spell);

        if self.bufflist then
            for _, buff in pairs(self.bufflist) do
                ns.eventhandler.registerAura("player", buff);
            end
        end
    end

    if self.type == ns.EnumButtonType.Totem then
        ACI_Totem_list[self.spell] = true;
        ns.eventhandler.registerTotem(self.spell, self);
        if self.realbuff then
            ACI_Totem_list[self.realbuff] = true;
            ns.eventhandler.registerTotem(self.realbuff, self);
        end

        if self.bufflist then
            for _, buff in pairs(self.bufflist) do
                ACI_Totem_list[buff] = true;
                ns.eventhandler.registerTotem(buff, self);
            end
        end
    end

    if self.realbuff then
        ns.eventhandler.registerAura(self.unit, self.realbuff);

        if self.type == ns.EnumButtonType.Debuff or self.type == ns.EnumButtonType.DebuffOnly then
            ACI_Debuff_list[self.realbuff] = true;
        else
            ACI_Buff_list[self.realbuff] = true;
        end
    end

    if self.countbuff then
        ns.eventhandler.registerAura("player", self.countbuff);
    end

    if self.countdebuff then
        ns.eventhandler.registerAura("target", self.countdebuff);
    end

    if self.alertbufflist then
        for _, buff in pairs(self.alertbufflist) do
            ns.eventhandler.registerAura("player", buff);
        end
    end

    if self.buffshowtime then
        ns.eventhandler.registerCastTime(self.spellid);
    end

    local function update()
        self:initButton();
        self:checkTotem();
        self:checkBuffList();
        self:checkBuff();        
        self:checkSpellCoolInBuff();
        self:checkSpell();
        self:checkCount();
        self:checkOthers();        
        self:showButton();
    end

    update();
    self.time = C_Timer.NewTicker(0.2, update)
end

function ns.Button:new(o)
    o = o or {} -- create object if user does not provide one
    setmetatable(o, self)
    self.__index = self
    return o
end
