local _, ns = ...;

local ACRB_mainframe = CreateFrame("Frame", nil, UIParent);

ns.ACRB_ShowList = nil;
ns.asraid = {};
ns.asparty = {};
ns.lowhealth = 0;


asCompactPrivateAuraAnchorMixin = {};

function asCompactPrivateAuraAnchorMixin:SetUnit(unit)
    if unit == self.unit then
        return;
    end
    self.unit = unit;

    if self.anchorID then
        C_UnitAuras.RemovePrivateAuraAnchor(self.anchorID);
        self.anchorID = nil;
    end

    if unit then
        local iconAnchor =
        {
            point = "CENTER",
            relativeTo = self,
            relativePoint = "CENTER",
            offsetX = 0,
            offsetY = 0,
        };

        local privateAnchorArgs = {};
        privateAnchorArgs.unitToken = unit;
        privateAnchorArgs.auraIndex = self.auraIndex;
        privateAnchorArgs.parent = self;
        privateAnchorArgs.showCountdownFrame = true;
        privateAnchorArgs.showCountdownNumbers = true;

        privateAnchorArgs.iconInfo =
        {
            iconAnchor = iconAnchor,
            iconWidth = self:GetWidth(),
            iconHeight = self:GetHeight(),
        };
        privateAnchorArgs.durationAnchor = nil;

        self.anchorID = C_UnitAuras.AddPrivateAuraAnchor(privateAnchorArgs);
    end
end

function ns.ACRB_InitList()
    local spec = GetSpecialization();
    local localizedClass, englishClass = UnitClass("player");
    ns.listname = nil;

    ns.ACRB_ShowList = nil;

    if spec == nil or spec > 4 or (englishClass ~= "DRUID" and spec > 3) then
        spec = 1;
    end


    if spec then
        ns.listname = "ACRB_ShowList_" .. englishClass .. "_" .. spec;
    end

    ns.ACRB_ShowList = CopyTable(ns[ns.listname]);
    local savedlist = ACRB_Options[ns.listname];

    if savedlist and ns.ACRB_ShowList and savedlist.version == ns.ACRB_ShowList.version then
        ns.ACRB_ShowList = CopyTable(savedlist);
    else
        ACRB_Options[ns.listname] = {};
        ACRB_Options[ns.listname] = CopyTable(ns.ACRB_ShowList);
    end

    local saveddefensivelist = ACRB_Options.defensivelist;

    if saveddefensivelist and ns.ACRB_DefensiveBuffListDefault and saveddefensivelist.version == ns.ACRB_DefensiveBuffListDefault.version then
        ns.ACRB_DefensiveBuffList = CopyTable(saveddefensivelist);
    else
        ns.ACRB_DefensiveBuffList = CopyTable(ns.ACRB_DefensiveBuffListDefault);
        ACRB_Options.defensivelist = {};
        ACRB_Options.defensivelist = CopyTable(ns.ACRB_DefensiveBuffListDefault);
    end

    ns.lowhealth = 0;

    if (englishClass == "PRIEST") then
        if IsPlayerSpell(373481) then
            ns.lowhealth = 35;
        end
    end

    ns.refreshList();
end

local function ACRB_updatePartyAllHealerMana()
    if IsInRaid() then
        for _, asframe in pairs(ns.asraid) do
            if asframe and asframe.frame and asframe.frame:IsShown() then
                ns.ACRB_UpdateHealerMana(asframe);
                ns.ACRB_UpdateRaidIconAborbColor(asframe);
            end
        end
    else
        for _, asframe in pairs(ns.asparty) do
            if asframe and asframe.frame and asframe.frame:IsShown() then
                ns.ACRB_UpdateHealerMana(asframe);
                ns.ACRB_UpdateRaidIconAborbColor(asframe);
            end
        end
    end
end

function ns.isParty(unit)
    for i = 1, 4 do
        if unit and UnitIsUnit(unit, "party" .. i) then
            return true
        end
    end

    return false;
end

local function IsTank(unit)
    local assignedRole = UnitGroupRolesAssigned(unit);
    if assignedRole == "TANK" or assignedRole == "MAINTANK" then
        return true;
    end
    return false;
end

local function extractUnitIdSuffix(unitId)
    if not unitId then
        return nil
    end

    local suffix = string.match(unitId, "%d+") -- Matches one or more digits    
    if suffix then
        return tonumber(suffix)                -- Convert the matched string to a number
    else
        return nil                             -- No numeric suffix found
    end
end




local max_y = 0;
-- Setup
function ns.ACRB_setupFrame(asframe, bupdate)
    if not asframe.frame or asframe.frame:IsForbidden() then
        return
    end
    local frame = asframe.frame;
    local x, y = frame:GetSize();

    asframe.needtosetup = false;

    if frame.unit then
        asframe.unit = frame.unit;
    end

    if frame.displayedUnit then
        asframe.displayedUnit = frame.displayedUnit;
    else
        asframe.displayedUnit = frame.unit;
    end

    if (not UnitIsPlayer(asframe.unit)) and not ns.isParty(asframe.unit) then
        return;
    end

    asframe.isTank = IsTank(asframe.unit);
    asframe.isPlayer = UnitIsUnit(asframe.unit, "player");

    local CUF_AURA_BOTTOM_OFFSET = 2;

    local options = DefaultCompactUnitFrameSetupOptions;
    local powerBarHeight = 8;
    local powerBarUsedHeight = options.displayPowerBar and powerBarHeight or 0;
    local centeryoffset = 0;

    if powerBarUsedHeight > 0 then
        CUF_AURA_BOTTOM_OFFSET = 1;
        centeryoffset = 4;
        y = y - powerBarUsedHeight;
    end
    asframe.layout = 0;

    local size_x = x / 6 * ns.options.BuffSizeRate - 1;
    local size_y = y / 3 * ns.options.BuffSizeRate - 1;

    local baseSize = math.min(x / 7 * ns.options.BuffSizeRate, y / 3 * ns.options.BuffSizeRate);

    if baseSize > ns.ACRB_MaxBuffSize then
        baseSize = ns.ACRB_MaxBuffSize
    end

    baseSize = baseSize * 0.9;

    local fontsize = baseSize * ns.options.BuffFontSizeRate;

    if asframe.isDispellAlert == nil then
        asframe.isDispellAlert = false;
    end

    local function layoutbuff(f, t)
        local bshow = ns.options.ShowBuffTooltip;

        if t == 2 then
            bshow = ns.options.ShowDebuffTooltip;
        end

        f:EnableMouse(false);

        f.icon:SetTexCoord(.08, .92, .16, .84);
        f.border:SetTexCoord(0.08, 0.08, 0.08, 0.92, 0.92, 0.08, 0.92, 0.92);
        f.border:SetVertexColor(0, 0, 0);
        f.border:Show();

        f.cooldown:SetSwipeColor(0, 0, 0, 0.5);
        f.count:ClearAllPoints();
        f.count:SetPoint("BOTTOMRIGHT", f, "BOTTOMRIGHT", 0, 1);

        if not f:GetScript("OnEnter") then
            f:SetScript("OnEnter", function(s)
                if t == 1 then
                    if s.auraInstanceID then
                        GameTooltip_SetDefaultAnchor(GameTooltip, s);
                        GameTooltip:SetUnitBuffByAuraInstanceID(asframe.displayedUnit, s.auraInstanceID, ns.bufffilter);
                    end
                elseif t == 2 then
                    if s.auraInstanceID then
                        if s.isBossBuff then
                            GameTooltip:SetUnitBuffByAuraInstanceID(asframe.displayedUnit, s.auraInstanceID,
                                ns.bufffilter);
                        else
                            GameTooltip:SetUnitDebuffByAuraInstanceID(asframe.displayedUnit, s.auraInstanceID,
                                ns.debufffilter);
                        end
                    end
                else
                    if s.castspellid and s.castspellid > 0 then
                        GameTooltip_SetDefaultAnchor(GameTooltip, s);
                        GameTooltip:SetSpellByID(s.castspellid);
                    end
                end
            end)
            f:SetScript("OnLeave", function()
                GameTooltip:Hide();
            end)
            f:EnableMouse(false);
            f:SetMouseMotionEnabled(bshow);
        end
    end

    local function layoutcooldown(f)
        f.count:SetFont(STANDARD_TEXT_FONT, fontsize, "OUTLINE")

        for _, r in next, { f.cooldown:GetRegions() } do
            if r:GetObjectType() == "FontString" then
                r:SetFont(STANDARD_TEXT_FONT, fontsize, "OUTLINE")
                r:ClearAllPoints();
                r:SetPoint("TOPLEFT", 1, 0);
                r:SetDrawLayer("OVERLAY");
                f.cooldowntext = r;
                break
            end
        end

        f.hideCountdownNumbers = true;
        if not ns.options.ShowBuffCooldown or select(1, f:GetSize()) < ns.options.MinCoolShowBuffSize then
            f.cooldown:SetHideCountdownNumbers(true);
        else
            f.cooldown:SetHideCountdownNumbers(false);
            f.hideCountdownNumbers = false;
        end
    end

    local strata = "LOW";
    local framelevel = 4;


    if frame.buffFrames[1] then
        strata = frame.buffFrames[1]:GetFrameStrata();
        framelevel = frame.buffFrames[1]:GetFrameLevel();
    end

    if not asframe.asbuffFrames then
        asframe.asbuffFrames = {}
        for i = 1, ns.ACRB_MAX_BUFFS do
            local buffFrame = CreateFrame("Button", nil, frame, "asCompactBuffTemplate")
            layoutbuff(buffFrame, 1);
            asframe.asbuffFrames[i] = buffFrame;
            buffFrame:Hide();
            buffFrame:SetFrameStrata(strata);
            buffFrame:SetFrameLevel(framelevel);
            buffFrame.cooldown:SetFrameLevel(framelevel);
        end
    end

    if asframe.asbuffFrames then
        for i = 1, ns.ACRB_MAX_BUFFS do
            local buffFrame = asframe.asbuffFrames[i];
            buffFrame:ClearAllPoints();
            buffFrame.data = {};

            if i <= ns.ACRB_MAX_BUFFS - 3 then
                if math.fmod(i - 1, 3) == 0 then
                    if i == 1 then
                        local buffOffset = CUF_AURA_BOTTOM_OFFSET + powerBarUsedHeight;
                        buffFrame:ClearAllPoints();
                        buffFrame:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", -2, buffOffset);
                    else
                        buffFrame:SetPoint("BOTTOMRIGHT", asframe.asbuffFrames[i - 3], "TOPRIGHT", 0, 1);
                    end
                else
                    buffFrame:SetPoint("BOTTOMRIGHT", asframe.asbuffFrames[i - 1], "BOTTOMLEFT", -1, 0);
                end

                buffFrame.cooldown:SetSwipeColor(0, 0, 0, 0.5);
            else
                -- 3개는 따로 뺀다.
                if i == ns.ACRB_MAX_BUFFS then
                    -- 우상
                    buffFrame:ClearAllPoints();
                    buffFrame:SetPoint("TOPRIGHT", frame, "TOPRIGHT", -2, -2);
                elseif i == ns.ACRB_MAX_BUFFS - 1 then
                    -- 우중2
                    buffFrame:ClearAllPoints();
                    buffFrame:SetPoint("BOTTOMRIGHT", asframe.asbuffFrames[i - 1], "BOTTOMLEFT", -1, 0);
                else
                    -- 우중
                    buffFrame:ClearAllPoints();
                    buffFrame:SetPoint("RIGHT", frame, "RIGHT", -2, centeryoffset);
                end
            end
        end
    end

    -- 크기 조정
    for _, buffFrame in ipairs(asframe.asbuffFrames) do
        buffFrame:SetSize(size_x, size_y);
        layoutcooldown(buffFrame);
    end

    if not asframe.asdebuffFrames then
        asframe.asdebuffFrames = {};
        for i = 1, ns.ACRB_MAX_DEBUFFS do
            local debuffFrame = CreateFrame("Button", nil, frame, "asCompactDebuffTemplate")
            layoutbuff(debuffFrame, 2);
            asframe.asdebuffFrames[i] = debuffFrame;
            debuffFrame:Hide();
            debuffFrame:SetFrameStrata(strata);
            debuffFrame:SetFrameLevel(framelevel);
            debuffFrame.cooldown:SetFrameLevel(framelevel);
        end
    end

    if asframe.asdebuffFrames then
        for i = 1, ns.ACRB_MAX_DEBUFFS do
            local debuffFrame = asframe.asdebuffFrames[i];
            debuffFrame:ClearAllPoints();
            debuffFrame.data = {};

            if math.fmod(i - 1, 3) == 0 then
                if i == 1 then
                    local debuffOffset = CUF_AURA_BOTTOM_OFFSET + powerBarUsedHeight;
                    debuffFrame:ClearAllPoints();
                    debuffFrame:SetPoint("BOTTOMLEFT", frame, "BOTTOMLEFT", 2, debuffOffset);
                else
                    debuffFrame:SetPoint("BOTTOMLEFT", asframe.asdebuffFrames[i - 3], "TOPLEFT", 0, 1);
                end
            else
                debuffFrame:SetPoint("BOTTOMLEFT", asframe.asdebuffFrames[i - 1], "BOTTOMRIGHT", 1, 0);
            end
        end
    end

    for _, debuffFrame in ipairs(asframe.asdebuffFrames) do
        debuffFrame.size_x, debuffFrame.size_y = size_x, size_y; -- 디버프
        debuffFrame:SetSize(size_x, size_y);
        layoutcooldown(debuffFrame);
    end

    --Private Aura setting
    if frame.PrivateAuraAnchors then
        for _, privateAuraAnchor in ipairs(frame.PrivateAuraAnchors) do
            privateAuraAnchor:SetUnit(nil);
        end
    end

    if not asframe.PrivateAuraAnchors then
        asframe.PrivateAuraAnchors = {};

        for idx = 1, 2 do
            asframe.PrivateAuraAnchors[idx] = CreateFrame("Frame", nil, frame, "asCompactPrivateAuraAnchorTemplate");
            asframe.PrivateAuraAnchors[idx].auraIndex = idx;
            asframe.PrivateAuraAnchors[idx]:SetFrameLevel(9000);

            if idx == 2 then
                asframe.PrivateAuraAnchors[idx]:ClearAllPoints();
                asframe.PrivateAuraAnchors[idx]:SetPoint("TOPLEFT", asframe.PrivateAuraAnchors[1], "TOPLEFT", 1, 0);
            else
                asframe.PrivateAuraAnchors[idx]:ClearAllPoints();
                asframe.PrivateAuraAnchors[idx]:SetPoint("TOPLEFT", frame, "TOPLEFT", 1, -1);
            end
        end
    end

    if asframe.PrivateAuraAnchors then
        for _, privateAuraAnchor in ipairs(asframe.PrivateAuraAnchors) do
            privateAuraAnchor:SetSize(size_x * 1.3, size_y * 1.3);
            privateAuraAnchor:SetUnit(asframe.displayedUnit);
        end
    end


    if (not asframe.defensivebuffFrames) then
        asframe.defensivebuffFrames = {};

        for i = 1, ns.ACRB_MAX_DEFENSIVE_BUFFS do
            local pvpbuffFrame = CreateFrame("Button", nil, frame, "asCompactBuffTemplate");
            asframe.defensivebuffFrames[i] = pvpbuffFrame;
            layoutbuff(pvpbuffFrame, 1);
            pvpbuffFrame:Hide();

            pvpbuffFrame:SetFrameStrata(strata);
            pvpbuffFrame:SetFrameLevel(framelevel);
            pvpbuffFrame.cooldown:SetFrameLevel(framelevel);
        end
    end

    for i, pvpbuffFrame in ipairs(asframe.defensivebuffFrames) do
        pvpbuffFrame:SetSize(size_x, size_y);
        layoutcooldown(pvpbuffFrame);
        pvpbuffFrame:ClearAllPoints();
        pvpbuffFrame.data = {};
        if i == 1 then
            pvpbuffFrame:SetPoint("CENTER", frame, "CENTER", 0, centeryoffset);
        else
            pvpbuffFrame:SetPoint("TOPRIGHT", asframe.defensivebuffFrames[i - 1], "TOPLEFT", 0, 0);
        end
    end

    if (not asframe.castFrames) then
        asframe.castFrames = {};

        for i = 1, ns.ACRB_MAX_CASTING do
            local castFrame = CreateFrame("Button", nil, frame, "asCompactBuffTemplate");
            asframe.castFrames[i] = castFrame;
            castFrame:SetFrameStrata(strata);
            castFrame:SetFrameLevel(framelevel);
            castFrame.cooldown:SetFrameLevel(framelevel);
            castFrame:Hide();
            layoutbuff(castFrame, 3);
        end
    end

    for i, castFrame in ipairs(asframe.castFrames) do
        castFrame:SetSize(size_x, size_y);
        layoutcooldown(castFrame);
        castFrame:ClearAllPoints();
        castFrame.data = {};
        if i == 1 then
            castFrame:SetPoint("TOP", frame, "TOP", 0, -2);
        else
            castFrame:SetPoint("TOPRIGHT", asframe.castFrames[i - 1], "TOPLEFT", -1, 0);
        end
    end

    if not asframe.asdispelDebuffFrames then
        asframe.asdispelDebuffFrames = {};
        for i = 1, ns.ACRB_MAX_DISPEL_DEBUFFS do
            local dispelDebuffFrame = CreateFrame("Button", nil, frame, "asCompactDispelDebuffTemplate")
            dispelDebuffFrame:EnableMouse(false);
            asframe.asdispelDebuffFrames[i] = dispelDebuffFrame;
            dispelDebuffFrame:Hide();

            dispelDebuffFrame:SetFrameStrata(strata);
            dispelDebuffFrame:SetFrameLevel(framelevel);
        end
    end

    if asframe.asdispelDebuffFrames then
        asframe.asdispelDebuffFrames[1]:SetPoint("RIGHT", asframe.asbuffFrames[ns.ACRB_MAX_BUFFS], "LEFT", -1, 0);
        for i = 1, ns.ACRB_MAX_DISPEL_DEBUFFS do
            if (i > 1) then
                asframe.asdispelDebuffFrames[i]:SetPoint("RIGHT", asframe.asdispelDebuffFrames[i - 1], "LEFT", 0, 0);
            end
            asframe.asdispelDebuffFrames[i]:SetSize(baseSize, baseSize);
            asframe.asdispelDebuffFrames[i].data = {};
        end
    end

    if (not asframe.asManabar) then
        asframe.asManabar = CreateFrame("StatusBar", nil, frame.healthBar);
        asframe.asManabar:SetStatusBarTexture("Interface\\Addons\\asCompactRaidBuff\\UI-StatusBar");
        asframe.asManabar:GetStatusBarTexture():SetHorizTile(false);
        asframe.asManabar:SetMinMaxValues(0, 100);
        asframe.asManabar:SetValue(100);
        asframe.asManabar:SetPoint("BOTTOM", frame.healthBar, "BOTTOM", 0, 0);
        asframe.asManabar:SetFrameStrata(strata);
        asframe.asManabar:SetFrameLevel(framelevel);
        asframe.asManabar:Hide();
    end

    if asframe.asManabar then
        asframe.asManabar:SetWidth(x - 2);
        asframe.asManabar:SetHeight(ns.ACRB_HealerManaBarHeight);
    end

    if (not asframe.asraidicon) then
        asframe.asraidicon = frame:CreateFontString(nil, "OVERLAY");
        asframe.asraidicon:SetFont(STANDARD_TEXT_FONT, fontsize * 2);
        asframe.asraidicon:SetPoint("LEFT", frame.healthBar, "LEFT", 2, 0);
        asframe.asraidicon:Hide();
    end

    if asframe.asraidicon then
        asframe.asraidicon:SetFont(STANDARD_TEXT_FONT, fontsize * 2);
    end

    if not asframe.frametexture then
        asframe.frametexture = frame:CreateTexture(nil, "ARTWORK", "asBuffTextureTemplate", -2);
        asframe.frametexture:Show();
    end

    if asframe.frametexture then
        local previousTexture = frame.healthBar:GetStatusBarTexture();
        asframe.frametexture:ClearAllPoints();
        asframe.frametexture:SetAllPoints(previousTexture);
        asframe.frametexture:SetVertexColor(previousTexture:GetVertexColor());
    end

    if not asframe.buffcolor then
        asframe.buffcolor = frame:CreateTexture(nil, "ARTWORK", "asBuffTextureTemplate", -1);
        asframe.buffcolor:Hide();
    end

    if asframe.buffcolor then
        local previousTexture = frame.healthBar:GetStatusBarTexture();
        asframe.buffcolor:ClearAllPoints();
        asframe.buffcolor:SetAllPoints(previousTexture);
        asframe.buffcolor:SetVertexColor(0.5, 0.5, 0.5);
    end

    if not asframe.healthcolor then
        asframe.healthcolor = frame:CreateTexture(nil, "ARTWORK", "asBuffTextureTemplate", -1);
        asframe.healthcolor:Hide();
    end

    if asframe.healthcolor then
        asframe.healthcolor:ClearAllPoints();
        asframe.healthcolor:SetAllPoints(asframe.buffcolor);
        asframe.healthcolor:SetVertexColor(1, 0.3, 0.3);
        asframe.healthcolor:SetDrawLayer("ARTWORK");
        asframe.healthcolor:SetAlpha(0.5);
    end

    if not asframe.aborbcolor then
        asframe.aborbcolor = frame:CreateTexture(nil, "ARTWORK", "asBuffTextureTemplate", 0);
        asframe.aborbcolor:Hide();
    end

    if asframe.aborbcolor then
        local previousTexture = frame.healthBar:GetStatusBarTexture();
        asframe.aborbcolor:ClearAllPoints();
        asframe.aborbcolor:SetPoint("TOPLEFT", previousTexture, "TOPLEFT", 0, 0);
        asframe.aborbcolor:SetPoint("BOTTOMLEFT", previousTexture, "BOTTOMLEFT", 0, 0);
        asframe.aborbcolor:SetWidth(0);
        asframe.aborbcolor:SetVertexColor(0, 0, 0);
        asframe.aborbcolor:SetDrawLayer("ARTWORK");
        asframe.aborbcolor:SetAlpha(0.2);
    end

    asframe.ncasting = 0;

    --마나는 unit으로만

    local role = UnitGroupRolesAssigned(asframe.unit);
    local manaBarUsedHeight = 0;

    if asframe.frame.powerBar and asframe.frame.powerBar:IsShown() then
        manaBarUsedHeight = 8;
    end

    asframe.checkMana = false;

    if role and role == "HEALER" and manaBarUsedHeight == 0 and ns.options.BottomHealerManaBar then
        asframe.asManabar:SetMinMaxValues(0, UnitPowerMax(asframe.unit, Enum.PowerType.Mana));
        asframe.asManabar:SetValue(UnitPower(asframe.unit, Enum.PowerType.Mana));

        local info = PowerBarColor["MANA"];
        if (info) then
            local r, g, b = info.r, info.g, info.b;
            asframe.asManabar:SetStatusBarColor(r, g, b);
        end

        asframe.checkMana = true;

        asframe.asManabar:Show();
    else
        asframe.asManabar:Hide();
    end

    local function layout(bottomoffset, centeroffset)
        asframe.asbuffFrames[1]:ClearAllPoints();
        asframe.asbuffFrames[1]:SetPoint("BOTTOMRIGHT", asframe.frame, "BOTTOMRIGHT", -2, bottomoffset);

        asframe.asbuffFrames[4]:ClearAllPoints();
        asframe.asbuffFrames[4]:SetPoint("RIGHT", asframe.frame, "RIGHT", -2, centeroffset);

        asframe.defensivebuffFrames[1]:ClearAllPoints();
        asframe.defensivebuffFrames[1]:SetPoint("CENTER", asframe.frame, "CENTER", 0, centeroffset);

        asframe.asdebuffFrames[1]:ClearAllPoints();
        asframe.asdebuffFrames[1]:SetPoint("BOTTOMLEFT", asframe.frame, "BOTTOMLEFT", 2, bottomoffset);
    end

    local layouttype = 1;

    if manaBarUsedHeight > 0 then
        CUF_AURA_BOTTOM_OFFSET = 1 + manaBarUsedHeight;
        centeryoffset = 4;
        layouttype = 3;
    elseif asframe.asManabar:IsShown() then
        CUF_AURA_BOTTOM_OFFSET = ns.ACRB_HealerManaBarHeight + 1;
        centeryoffset = 1;
        layouttype = 2;
    end

    if asframe.layout and asframe.layout ~= layouttype then
        layout(CUF_AURA_BOTTOM_OFFSET, centeryoffset);
        asframe.layout = layouttype;
    end

    if bupdate then
        ns.ACRB_UpdateHealerMana(asframe);
        ns.ACRB_UpdateRaidIconAborbColor(asframe);
        ns.ACRB_UpdateAuras(asframe);
    end

    asframe.callback = function()
        if asframe.frame:IsShown() then
            ns.ACRB_UpdateAuras(asframe);
        elseif asframe.timer then
            asframe.timer:Cancel();
        end
    end

    if asframe.timer then
        asframe.timer:Cancel();
    end

    local suffix = extractUnitIdSuffix(asframe.unit);

    local updateRate = ns.UpdateRate + GetNumGroupMembers() / 1000;

    if suffix then
        updateRate = updateRate + (suffix / 2000);
    end

    if asframe.frame:IsShown() then
        asframe.timer = C_Timer.NewTicker(updateRate, asframe.callback);        
    end
    
end

local function ACRB_disableDefault(frame)
    if frame and not frame:IsForbidden() then
        -- 거리 기능 충돌 때문에 안됨
        -- frame.optionTable.fadeOutOfRange = false;
        frame:UnregisterEvent("UNIT_AURA");
        frame:UnregisterEvent("PLAYER_REGEN_ENABLED");
        frame:UnregisterEvent("PLAYER_REGEN_DISABLED");

        do
            if frame.buffFrames then
                for i = 1, #frame.buffFrames do
                    frame.buffFrames[i]:SetAlpha(0);
                    frame.buffFrames[i]:Hide();
                end
            end
        end

        do
            if frame.debuffFrames then
                for i = 1, #frame.debuffFrames do
                    frame.debuffFrames[i]:SetAlpha(0);
                    frame.debuffFrames[i]:Hide();
                end
            end
        end

        do
            if frame.dispelDebuffFrames then
                for i = 1, #frame.dispelDebuffFrames do
                    frame.dispelDebuffFrames[i]:SetAlpha(0);
                    frame.dispelDebuffFrames[i]:Hide();
                end
            end
        end
    end
end

local frameBuffer = {};

local function hookfunc(frame)
    if frame and not frame:IsForbidden() and frame.GetName then
        local name = frame:GetName();
        if name then
            frameBuffer[name] = frame;
        end
    end
end

local function ARCB_UpdateAll(frame)
    if frame and not frame:IsForbidden() and frame.GetName then
        local name = frame:GetName();

        if name and not (name == nil) then
            if string.find(name, "CompactRaidGroup") or string.find(name, "CompactRaidFrame") then
                if not (frame.unit and UnitIsPlayer(frame.unit)) and not ns.isParty(frame.unit) then
                    return
                end
                ACRB_disableDefault(frame);

                local x, y = frame:GetSize();

                if y > max_y then
                    max_y = y;
                end

                if y <= max_y / 2 then
                    ns.asraid[name] = nil;
                    return;
                end

                if ns.asraid[name] == nil then
                    ns.asraid[name] = {};
                end

                ns.asraid[name].needtosetup = true;
                ns.asraid[name].frame = frame;
            elseif string.find(name, "CompactPartyFrameMember") then
                if not (frame.unit and UnitIsPlayer(frame.unit)) and not ns.isParty(frame.unit) then
                    return
                end
                ACRB_disableDefault(frame);

                if ns.asparty[name] == nil then
                    ns.asparty[name] = {};
                end

                ns.asparty[name].needtosetup = true;
                ns.asparty[name].frame = frame;
            end
        end
    end
end

local function ACRB_updateSetupAll()
    if (IsInRaid()) then
        for _, asframe in pairs(ns.asraid) do
            if asframe and asframe.frame and asframe.frame:IsShown() then
                ns.ACRB_setupFrame(asframe, true);
            end
        end
    elseif (IsInGroup()) then
        for _, asframe in pairs(ns.asparty) do
            if asframe and asframe.frame and asframe.frame:IsShown() then
                ns.ACRB_setupFrame(asframe, true);
            end
        end
    end
end

local function ACRB_OnUpdate()
    for _, newframe in pairs(frameBuffer) do
        ARCB_UpdateAll(newframe);
    end

    frameBuffer = {};
end

local function ACRB_OnUpdate2()
    ACRB_updatePartyAllHealerMana();
end

local function ACRB_OnUpdate3()
    ns.ACRB_CheckCasting();
end


local timero;
local timero2;
local timero3;

function ns.SetupAll(init)
    ns.DumpCaches();
    if timero then
        timero:Cancel();
    end

    if timero2 then
        timero2:Cancel();
    end

    if timero3 then
        timero3:Cancel();
    end

    if init then
        ns.ACRB_InitList();
    end
    ACRB_updateSetupAll();
    timero = C_Timer.NewTicker(ns.UpdateRate + 0.01, ACRB_OnUpdate);
    timero2 = C_Timer.NewTicker(ns.UpdateRate + 0.02, ACRB_OnUpdate2);
    timero3 = C_Timer.NewTicker(ns.UpdateRate + 0.05, ACRB_OnUpdate3);
end

local bfirst = true;

local function ACRB_OnEvent(self, event, arg1, arg2, arg3)
    if bfirst then
        ns.SetupOptionPanels();
        ns.SetupAll(true);
        bfirst = false;
    end

    if event == "UNIT_SPELLCAST_START" or event == "UNIT_SPELLCAST_CHANNEL_START" or event == "NAME_PLATE_UNIT_ADDED" then
        local unit = arg1;
        if unit and ns.isAttackable(unit) and UnitAffectingCombat(unit) and string.find(unit, "nameplate") then
            local isboss = false;
            if (MAX_BOSS_FRAMES) then
                for i = 1, MAX_BOSS_FRAMES do
                    if UnitIsUnit(unit, "boss" .. i) then
                        isboss = true;
                        break;
                    end
                end
            end

            if not isboss then
                ns.CastingUnits[unit] = true;
            end
        end
    elseif (event == "PLAYER_ENTERING_WORLD") then
        ns.hasValidPlayer = true;
        local bloaded = C_AddOns.LoadAddOn("DBM-Core");
        if bloaded then
            hooksecurefunc(DBM, "NewMod", ns.NewMod)
        end
        ns.updateTankerList();
    elseif (event == "TRAIT_CONFIG_UPDATED") or (event == "TRAIT_CONFIG_LIST_UPDATED") or (event == "ACTIVE_TALENT_GROUP_CHANGED") then
        ns.SetupAll(true);
        ns.UpdateDispellable();
    elseif (event == "UNIT_PET") then
        ns.UpdateDispellable();
    elseif (event == "GROUP_ROSTER_UPDATE") or (event == "CVAR_UPDATE") or (event == "ROLE_CHANGED_INFORM") then
        ns.updateTankerList();
        ns.SetupAll(false);
    elseif (event == "PLAYER_REGEN_ENABLED" or event == "PLAYER_REGEN_DISABLED") then
        ns.SetupAll(false);
    elseif (event == "PLAYER_LEAVING_WORLD") then
        ns.hasValidPlayer = false;
    end
end

ACRB_mainframe:SetScript("OnEvent", ACRB_OnEvent)
ACRB_mainframe:RegisterEvent("UNIT_SPELLCAST_START");
ACRB_mainframe:RegisterEvent("UNIT_SPELLCAST_CHANNEL_START");
ACRB_mainframe:RegisterEvent("GROUP_ROSTER_UPDATE");
ACRB_mainframe:RegisterEvent("PLAYER_ENTERING_WORLD");
ACRB_mainframe:RegisterEvent("PLAYER_LEAVING_WORLD");
ACRB_mainframe:RegisterEvent("ACTIVE_TALENT_GROUP_CHANGED");
ACRB_mainframe:RegisterEvent("TRAIT_CONFIG_UPDATED");
ACRB_mainframe:RegisterEvent("TRAIT_CONFIG_LIST_UPDATED");
ACRB_mainframe:RegisterEvent("CVAR_UPDATE");
ACRB_mainframe:RegisterEvent("ROLE_CHANGED_INFORM");
ACRB_mainframe:RegisterEvent("VARIABLES_LOADED");
ACRB_mainframe:RegisterEvent("PLAYER_REGEN_ENABLED");
ACRB_mainframe:RegisterEvent("PLAYER_REGEN_DISABLED");
ACRB_mainframe:RegisterEvent("NAME_PLATE_UNIT_ADDED");
ACRB_mainframe:RegisterUnitEvent("UNIT_PET", "player")

hooksecurefunc("DefaultCompactUnitFrameSetup", hookfunc);
hooksecurefunc("CompactUnitFrame_UpdateName", ns.UpdateNameColor);
