local _, ns = ...;

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


    icon = nil,
    iconDes = false,
    iconColor = { r = 1.0, g = 1.0, b = 1.0 },
    alpha = 1,
    borderColor = { r = 1.0, g = 1.0, b = 1.0 },
    start = 0,
    duration = 0,
    enable = false,
    reversecool = false,
    spellcool = 0,
    count = nil,
    buffalert = false,
    bufflist = {},
    alertbufflist = {},
};

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
    self.spellcool = 0;
    self.count = nil;
    self.buffalert = false;
    self.alert2 = false;

    local spellid = select(7, GetSpellInfo(self.spell));
    local name = select(1, GetSpellInfo(self.spell));

    if spellid == nil then
        spellid = select(7, GetSpellInfo(self.realspell));
        name = select(1, GetSpellInfo(self.realspell));
    end

    if spellid and spellid ~= self.spellid then
        self.spellid = spellid;
        ACI_SpellID_list[self.spellid] = true;
        if name then
            ACI_SpellID_list[name] = true;
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

        if self.number and (expirationTime - GetTime()) <= self.number and self.duration > 0 then
            self.buffalert = true;
        end

        local color;

        if aura then
            color = { r = 0, g = 1, b = 0 };
        else
            color = { r = 1, g = 0, b = 0 };
        end
        self.borderColor = color;

        if self.spellid then
            local spellstart, spellduration = GetSpellCooldown(self.spellid);
            local charges, maxCharges = GetSpellCharges(self.spellid);

            if spellduration and (charges == nil or charges == 0) then
                local _, gcd = GetSpellCooldown(61304);
                local ex = spellduration + spellstart;
                local remain = ex - GetTime();

                if spellduration > gcd and (ex < expirationTime + 10) then
                    self.spellcool = math.ceil(remain);
                end
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

    for _, buff in pairs(bufflist) do
        local aura = ns.aurafunctions.checkAura(self.unit, buff);

        if aura then
            count = count + 1;
            if self.icon == nil then
                self.icon = aura.icon;
                self.start = aura.expirationTime - aura.duration
                self.duration = aura.duration;
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

                if self.number and (aura.expirationTime - GetTime()) <= self.number and self.duration > 0 then
                    self.buffalert = true;
                end
            end
        end
    end

    if count > 2 then
        self.alert2 = true;
    end

    if count >= 1 then
        self.count = count;
        if (t ~= ns.EnumButtonType.DebuffOnly and t ~= ns.EnumButtonType.BuffOnly) and self.spellid then
            local spellstart, spellduration = GetSpellCooldown(self.spellid);
            local charges, maxCharges = GetSpellCharges(self.spellid);

            if spellduration and (charges == nil or charges == 0) then
                local _, gcd = GetSpellCooldown(61304);
                local ex = spellduration + spellstart;
                local remain = ex - GetTime();

                if spellduration > gcd and (ex < extemp + 10) then
                    self.spellcool = math.ceil(remain);
                end
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

        if self.number and (aura.expirationTime - GetTime()) <= self.number and self.duration > 0 then
            self.buffalert = true;
        end

        if aura.points and aura.points[1] then
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

        if (t ~= ns.EnumButtonType.DebuffOnly and t ~= ns.EnumButtonType.BuffOnly) and self.spellid then
            local spellstart, spellduration = GetSpellCooldown(self.spellid);
            local charges, maxCharges = GetSpellCharges(self.spellid);

            if spellduration and (charges == nil or charges == 0) then
                local _, gcd = GetSpellCooldown(61304);
                local ex = spellduration + spellstart;
                local remain = ex - GetTime();

                if spellduration > gcd and (ex < aura.expirationTime + 10) then
                    self.spellcool = math.ceil(remain);
                end
            end
            if self.count == nil and charges and charges > 0 and maxCharges and maxCharges > 1 then
                self.count = charges;                
            end
        end
    end
end

function ns.Button:checkSpell()
    if self.icon ~= nil or self.spellid == nil then
        return;
    end


    local spellid                                          = self.spellid;
    local action                                           = self.action;

    local _, _, icon                                       = GetSpellInfo(spellid)
    local start, duration, enable                          = GetSpellCooldown(spellid);
    local isUsable, notEnoughMana                          = IsUsableSpell(spellid);
    local charges, maxCharges, chargeStart, chargeDuration = GetSpellCharges(spellid);
    local count                                            = charges;
    local _, gcd                                           = GetSpellCooldown(61304);

    if count == 1 and (not maxCharges or maxCharges <= 1) then
        count = 0;
    end

    if not count or count == 0 then
        if action then
            count = GetActionCount(action);
            charges, maxCharges, chargeStart, chargeDuration = GetActionCharges(action);
        end
    end

    if isUsable and duration > gcd then
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
                    self.alert2 = true;
                else     
                    isUsable = false;
                
                end
            else 
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
    elseif (notEnoughMana) then
        self.iconColor = { r = 0.5, g = 0.5, b = 1 };
        self.iconDes = true;
    else
        self.iconColor = { r = 0.5, g = 0.5, b = 0.5 };
        self.iconDes = true;
    end

    self.alpha = 1;
    self.start = start;
    self.duration = duration;
    self.enable = false;

    if count and count > 0 then        
        self.count = count;
    end

    if self.alertbufflist then
        for _, buff in pairs(self.alertbufflist) do
            local aura = ns.aurafunctions.checkAura(self.unit, buff);
            if aura and (aura.expirationTime - GetTime()) > gcd then
                self.alert2 = true;
                break;
            end
        end        
    end
end

function ns.Button:checkCount()
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
    local frameSpellCool;

    local frame = self.frame;
    if not frame then
        return;
    end
    frameIcon = frame.icon;
    frameCooldown = frame.cooldown;
    frameCount = frame.count;
    frameBorder = frame.border;
    frameSpellCool = frame.spellcoolframe;

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


    if (self.duration ~= nil and self.duration > 0 and self.duration < 500) then
        -- set the count
        asCooldownFrame_Set(frameCooldown, self.start, self.duration, self.duration > 0, self.enable);
        frameCooldown:SetDrawSwipe(false);
        frameCooldown:SetHideCountdownNumbers(false);
        frameCooldown:Show();
        frameCooldown:SetReverse(self.reversecool);
    else
        frameCooldown:Hide();
    end

    if self.spellcool > 0 then
        frameSpellCool.spellcool:SetText(self.spellcool)
        frameSpellCool.spellcool:Show();
        frameSpellCool:Show();
    else
        frameSpellCool:Hide();
    end

    if self.count then
        if frame.cooldownfont then
            frame.cooldownfont:ClearAllPoints();
            frame.cooldownfont:SetPoint("TOPLEFT", 4, -4);
            frameCooldown:SetDrawSwipe(false);
        end

        frameCount:SetText(self.count)
        frameCount:Show();
    else
        if frame.cooldownfont then
            frame.cooldownfont:ClearAllPoints();
            frame.cooldownfont:SetPoint("CENTER", 0, 0);
            frameCooldown:SetDrawSwipe(true);
        end

        frameCount:Hide();
    end


    if self.buffalert then
        ns.lib.PixelGlow_Start(frame, { 0.5, 1, 0.5 });
    elseif self.alert2 then
        ns.lib.PixelGlow_Start(frame, { 0.7, 0.7, 1 });
    elseif self.alert then
        ns.lib.PixelGlow_Start(frame);
    else
        ns.lib.PixelGlow_Stop(frame)
    end
end

function ns.Button:update()
    self:initButton();
    self:checkTotem();
    self:checkBuffList();
    self:checkBuff();
    self:checkSpell();
    self:checkCount();
    self:showButton();
end

local function GetActionSlot(arg1)
    for lActionSlot = 1, 180 do
        local type, id, subType, spellID = GetActionInfo(lActionSlot);

        if id and type and type == "spell" then
            local name = GetSpellInfo(id);
            if name and name == arg1 then
                return lActionSlot;
            end
        end
    end

    for lActionSlot = 1, 180 do
        local type, id, subType, spellID = GetActionInfo(lActionSlot);

        if id and type and type == "macro" then
            local name = GetSpellInfo(id);


            if name and name == arg1 then
                return lActionSlot;
            end
        end
    end

    return nil;
end

function ns.Button:init(config, frame)
    self.realspell = config[1];
    self.spell = select(1, GetSpellInfo(config[1]));
    self.type = config[2];
    self.unit = config[3];
    self.number = config[4];
    self.countbuff = config[5];
    self.realbuff = config[6];
    self.countdebuff = config[7];
    self.bufflist = config[8];
    self.alertbufflist = config[9];
    self.spellid = select(7, GetSpellInfo(self.spell));
    if self.spellid == nil then
        self.spellid = select(7, GetSpellInfo(self.realspell));
    end

    if self.spell == nil then
        return;
    end

    self.frame = frame;
    self.action = GetActionSlot(self.spell);
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
    end
    if self.type == ns.EnumButtonType.Debuff or self.type == ns.EnumButtonType.DebuffOnly then
        ACI_Debuff_list[self.spell] = true;
    elseif self.type == ns.EnumButtonType.Buff or self.type == ns.EnumButtonType.BuffOnly or self.type == ns.EnumButtonType.Totem then
        ACI_Buff_list[self.spell] = true;
        ns.eventhandler.registerBuffTimer(self);
    end

    ns.eventhandler.registerAura(self.unit, self.spell);
    ns.eventhandler.registerAction(self.action, self);

    if self.type == ns.EnumButtonType.Totem then
        ns.eventhandler.registerTotem(self.spell, self);
        ns.eventhandler.registerTotemTimer(self);
        if self.realbuff then
            ns.eventhandler.registerTotem(self.realbuff, self);
        end
    end

    if self.realbuff then
        ns.eventhandler.registerAura(self.unit, self.realbuff);
        ACI_Buff_list[self.realbuff] = true;
    end

    if self.countbuff then
        ns.eventhandler.registerAura("player", self.countbuff);
        ACI_Buff_list[self.countbuff] = true;
    end

    if self.countdebuff then
        ns.eventhandler.registerAura("target", self.countdebuff);
        ACI_Debuff_list[self.countdebuff] = true;
    end

    if self.bufflist then
        for _, buff in pairs(self.bufflist) do
            ns.eventhandler.registerAura("player", buff);
        end
    end

    if self.alertbufflist then
        for _, buff in pairs(self.alertbufflist) do
            ns.eventhandler.registerAura("player", buff);
        end

        if self.type == ns.EnumButtonType.Spell then
            ns.eventhandler.registerBuffTimer(self);
        end
    end

    ns.eventhandler.registerTimer(self);

    self:update();
end

function ns.Button:new(o)
    o = o or {} -- create object if user does not provide one
    setmetatable(o, self)
    self.__index = self
    return o
end