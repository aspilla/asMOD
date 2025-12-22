local _, ns = ...;
local ANameP = CreateFrame("Frame", nil, UIParent);
local tanklist = {}

local CONFIG_NOT_INTERRUPTIBLE_COLOR = { r = 0.9, g = 0.9, b = 0.9 };               --차단 불가시 (내가 아닐때) 색상 (r, g, b)
local CONFIG_INTERRUPTIBLE_COLOR = { r = 204 / 255, g = 255 / 255, b = 153 / 255 }; --차단 가능(내가 타겟이 아닐때)시 색상 (r, g, b)


ns.ANameP_ShowList = nil;

ns.options = CopyTable(ANameP_Options_Default);

local isparty = false;
local israid = false;
local ispvp = false;

-- 탱커 처리부
local function updateTankerList()
    if ispvp then
        return nil;
    end

    tanklist = {}
    if IsInGroup() then
        if IsInRaid() then -- raid
            for i = 1, GetNumGroupMembers() do
                local unitid = "raid" .. i
                local notMe = not UnitIsUnit("player", unitid)
                if UnitExists(unitid) and notMe then
                    local _, _, _, _, _, _, _, _, _, role, _, assignedRole = GetRaidRosterInfo(i);
                    if assignedRole == "TANK" then
                        table.insert(tanklist, unitid);
                    end
                end
            end
        else -- party
            for i = 1, 4 do
                local unitid = "party" .. i;
                if UnitExists(unitid) then
                    local assignedRole = UnitGroupRolesAssigned(unitid);
                    if assignedRole == "TANK" then
                        table.insert(tanklist, unitid);
                    end
                end
            end
        end
    end
end

local function updatePower(asframe)
    if not ns.options.ANameP_ShowPower then
        return;
    end



    local unit = asframe.unit;

    local powerType, powerTypeString = UnitPowerType(unit);

    if powerType > 0 and UnitIsUnit(unit, "target") then
        local power = UnitPower(unit);
        local maxPower = UnitPowerMax(unit);


        asframe.powerbar:SetMinMaxValues(0, maxPower);
        asframe.powerbar:SetValue(power);
        asframe.powerbar.value:SetText(power);
        asframe.powerbar:Show();
    else
        asframe.powerbar:Hide();
    end
end

-- Healthbar 색상 처리부
local function setColoronStatusBar(asframe, color)
    local parent = asframe.nameplateBase;

    if not parent or not parent.UnitFrame or parent.UnitFrame:IsForbidden() or not asframe.BarColor then
        return;
    end



    asframe.BarColor:SetVertexColor(color.r, color.g, color.b);
    --healthbar:SetStatusBarTexture(asframe.BarColor);
    asframe.BarColor:Show();
end

local AuraFilters =
{
    Helpful = "HELPFUL",
    Harmful = "HARMFUL",
    Raid = "RAID",
    IncludeNameplateOnly = "INCLUDE_NAME_PLATE_ONLY",
    Player = "PLAYER",
    Cancelable = "CANCELABLE",
    NotCancelable = "NOT_CANCELABLE",
    Maw = "MAW",
};

local function CreateFilterString(...)
    return table.concat({ ... }, '|');
end

local filter = CreateFilterString(AuraFilters.Harmful, AuraFilters.Player);

local function scanauralist(list)
    local count = 0;
    if list:IsForbidden() then
        return count
    end
    local children = list:GetLayoutChildren()
    if #children == 0 then
        return count;
    end
    for _, child in ipairs(children) do
        if child.auraInstanceID then
            count = count + 1;
        end
    end

    return count;
end

local colorcurve = C_CurveUtil.CreateColorCurve();
colorcurve:SetType(Enum.LuaCurveType.Step);
colorcurve:AddPoint(0.0, CreateColor(0.5, 1, 1, 1));

local function updateHealthbarColor(asframe)
    -- unit name 부터
    if not asframe.unit or not asframe.checkcolor or not asframe.BarColor then
        return;
    end

    local unit = asframe.unit;
    local parent = asframe.nameplateBase;

    if not parent or not parent.UnitFrame or parent.UnitFrame:IsForbidden() then
        return;
    end
    local UnitFrame = parent.UnitFrame;
    local healthBar = UnitFrame.healthBar;
    local castbar = UnitFrame.castBar;
    local debufflist = UnitFrame.AurasFrame.DebuffListFrame

    if not healthBar and healthBar:IsForbidden() then
        return;
    end

    local function IsPlayerEffectivelyTank()
        local assignedRole = UnitGroupRolesAssigned("player");
        if (assignedRole == "NONE") then
            local spec = C_SpecializationInfo.GetSpecialization();
            return spec and GetSpecializationRole(spec) == "TANK";
        end
        return assignedRole == "TANK";
    end


    local status = UnitThreatSituation("player", unit);
    local incombat = UnitAffectingCombat(unit);
    local tanker = IsPlayerEffectivelyTank();
    local alerttype = 0;

    local function getColor()
        if UnitIsPlayer(unit) then
            return nil;
        end

        --Target and Aggro High Priority
        if IsInGroup() and ns.options.ANameP_AggroShow and incombat then
            if tanker then
                if status == nil or status == 0 then
                    return ns.options.ANameP_TankAggroLoseColor;
                end
            end
            if status and status > 0 then
                return ns.options.ANameP_AggroColor;
            end
        end

        --Cast Color
        if asframe.casticon:IsShown() and ns.options.ANameP_ShowCastColor then
            local bartype = castbar.barType;
            if bartype == "uninterruptable" then
                return CONFIG_NOT_INTERRUPTIBLE_COLOR;
            elseif bartype == "empowered" then
                alerttype = 2;
            end

            return CONFIG_INTERRUPTIBLE_COLOR;
        end


        --Debuff Color
        if ns.options.ANameP_ShowDebuffColor then
            local activeDebuffs = scanauralist(debufflist);

            if activeDebuffs > 0 then
                return ns.options.ANameP_DebuffColor;
            end
        end

        if status and ns.options.ANameP_AggroShow then
            --return UnitHealthPercent(unit, colorcurve);
            return ns.options.ANameP_CombatColor;
        end

        if asframe.isboss and ns.options.ANameP_BossHint then
            return ns.options.ANameP_BossColor;
        end

        if not (isparty or israid) and ns.options.ANameP_QuestAlert and C_QuestLog.UnitIsRelatedToActiveQuest(unit) then
            return ns.options.ANameP_QuestColor;
        end

        return nil;
    end

    local color = getColor();

    if color then
        setColoronStatusBar(asframe, color);
    else
        --healthBar:SetStatusBarTexture(asframe.orginaltexture);
        asframe.BarColor:Hide();
    end

    if alerttype ~= asframe.alerttype then
        if alerttype == 3 then
            ns.lib.PixelGlow_Start(healthBar, nil, nil, nil, nil, nil, nil, nil, nil, nil, 1000);
            ns.lib.PixelGlow_Stop(asframe.casticon);
            ns.lib.PixelGlow_Stop(asframe);
        elseif alerttype == 2 then
            ns.lib.PixelGlow_Start(asframe, { 1, 1, 0, 1 }, 16, nil, 5, 2, nil, nil, nil, nil, 1000);
            ns.lib.PixelGlow_Stop(asframe.casticon);
            ns.lib.PixelGlow_Stop(healthBar);
        elseif alerttype == 1 then
            ns.lib.PixelGlow_Start(asframe.casticon);
            ns.lib.PixelGlow_Stop(asframe);
            ns.lib.PixelGlow_Stop(healthBar);
        else
            ns.lib.PixelGlow_Stop(asframe.casticon);
            ns.lib.PixelGlow_Stop(asframe);
            ns.lib.PixelGlow_Stop(healthBar);
        end
        asframe.alerttype = alerttype;
    end
end



local function checkSpellCasting(asframe)
    if not ns.options.ANameP_ShowCastIcon then
        return;
    end

    local unit = asframe.unit;
    local name, text, texture, startTime, endTime, isTradeSkill, castID, notInterruptible, spellid = UnitCastingInfo(
        unit);
    if not name then
        name, text, texture, startTime, endTime, isTradeSkill, notInterruptible, spellid = UnitChannelInfo(unit);
    end

    if asframe.casticon then
        local frameIcon = asframe.casticon.icon;
        if frameIcon then
            if name then
                frameIcon:SetTexture(texture);
                asframe.casticon:Show();
            else
                asframe.casticon:Hide();
            end
        end
    end
end

local function updatetarget(asframe)
    if asframe.unit and UnitIsUnit(asframe.unit, "target") then
        updatePower(asframe);
        return;
    end
end

local function updatemouseover(asframe)
    if UnitExists("mouseover") then
        if asframe.unit and UnitIsUnit(asframe.unit, "mouseover") then
            asframe.motext:Show();
            return;
        end
    end
    asframe.motext:Hide();
end

local function asNamePlates_OnEvent(asframe, event, ...)
    if (event == "PLAYER_TARGET_CHANGED") then
        updatetarget(asframe);
    elseif event == "UPDATE_MOUSEOVER_UNIT" then
        updatemouseover(asframe);
    else
        checkSpellCasting(asframe);
        updateHealthbarColor(asframe);
    end
end

local function createNamePlate(namePlateFrameBase)
end


local function removeUnit(unitToken)
    local namePlateFrameBase = C_NamePlate.GetNamePlateForUnit(unitToken, issecure());

    if not namePlateFrameBase then
        return;
    end

    if namePlateFrameBase.asNamePlates ~= nil then
        local asframe = namePlateFrameBase.asNamePlates;

        ns.lib.PixelGlow_Stop(asframe.casticon);
        ns.lib.PixelGlow_Stop(asframe);

        asframe.casticon:Hide();
        asframe.BarColor:Hide();

        asframe:Hide();
        asframe:UnregisterAllEvents();
        asframe:SetScript("OnEvent", nil);

        if asframe.timer then
            asframe.timer:Cancel();
            asframe.timer = nil;
        end

        asframe.alerttype = nil;
        asframe:ClearAllPoints();
        ns.freeasframe(asframe);
        asframe = nil;
    end

    if namePlateFrameBase and namePlateFrameBase.asNamePlates ~= nil then
        namePlateFrameBase.asNamePlates = nil;
    end
end

local function updateAll(asframe)
    updatemouseover(asframe);
    updatePower(asframe);
    updateHealthbarColor(asframe);
    checkSpellCasting(asframe);
end

local function updateNamePlate(namePlateFrameBase)
    if (namePlateFrameBase and namePlateFrameBase.asNamePlates ~= nil and not namePlateFrameBase:IsForbidden() and namePlateFrameBase.UnitFrame and namePlateFrameBase.UnitFrame:IsShown()) then
        local asframe = namePlateFrameBase.asNamePlates;
        updateAll(asframe);
    end
end


local function addNamePlate(namePlateFrameBase)
    if not namePlateFrameBase and not namePlateFrameBase.unitToken then
        return;
    end

    if namePlateFrameBase.UnitFrame:IsForbidden() then
        return;
    end



    local unitFrame = namePlateFrameBase.UnitFrame;
    local healthbar = unitFrame.healthBar;
    local healthBarContainer = unitFrame.HealthBarsContainer;
    local unit = namePlateFrameBase.unitToken;

    if not UnitCanAttack("player", unit) then
        if namePlateFrameBase.asNamePlates then
            removeUnit(unit);
        end
        return;
    end

    if namePlateFrameBase.asNamePlates == nil then
        namePlateFrameBase.asNamePlates = ns.getasframe();
    end

    local asframe = namePlateFrameBase.asNamePlates;
    asframe:SetParent(healthbar);
    asframe:SetFrameLevel(healthbar:GetFrameLevel() + 1000);
    asframe.nameplateBase = namePlateFrameBase;
    asframe.unit = unit;
    asframe.alerttype = nil;
    asframe.checkcolor = false;


    asframe:UnregisterAllEvents();
    asframe:SetScript("OnEvent", nil);

    if unitFrame.castBar then
        asframe.casticon:ClearAllPoints();
        asframe.casticon:SetPoint("BOTTOMLEFT", unitFrame.castBar, "BOTTOMRIGHT", 0.5, -0.3);
        local scale = NamePlateDriverMixin:GetNamePlateScale();
        local height = 22 * scale.vertical + 10
        asframe.casticon:SetWidth(height * 1.2);
        asframe.casticon:SetHeight(height);
        asframe.casticon:Hide();
        asframe.iscast = false;
    end

    local previousTexture = healthbar:GetStatusBarTexture();
    asframe.BarColor:SetParent(healthbar);
    asframe.BarColor:ClearAllPoints();
    asframe.BarColor:SetAllPoints(previousTexture);
    asframe.BarColor:SetVertexColor(previousTexture:GetVertexColor());
    asframe.BarColor:Hide();

    asframe:SetScript("OnEvent", asNamePlates_OnEvent);

    if not UnitIsPlayer(unit) then
        asframe:RegisterEvent("PLAYER_TARGET_CHANGED");
        asframe:RegisterEvent("UPDATE_MOUSEOVER_UNIT");
        asframe:RegisterUnitEvent("UNIT_SPELLCAST_START", unit);
        asframe:RegisterUnitEvent("UNIT_SPELLCAST_CHANNEL_START", unit);
        asframe:RegisterUnitEvent("UNIT_SPELLCAST_SUCCEEDED", unit);
        asframe:RegisterUnitEvent("UNIT_SPELLCAST_INTERRUPTED", unit);
        asframe:RegisterUnitEvent("UNIT_SPELLCAST_DELAYED", unit);
        asframe:RegisterUnitEvent("UNIT_SPELLCAST_CHANNEL_STOP", unit);
        asframe:RegisterUnitEvent("UNIT_SPELLCAST_STOP", unit);
        asframe:RegisterUnitEvent("UNIT_SPELLCAST_FAILED", unit);
    end

    asframe.powerbar:ClearAllPoints();
    asframe.powerbar:SetPoint("TOP", healthbar, "BOTTOM", 0, 2);    
    asframe.powerbar:Hide();

    asframe.motext:ClearAllPoints();
    asframe.motext:SetPoint("TOP", healthbar, "BOTTOM", 0, -1);    
    asframe.motext:Hide();


    local powerType, powerToken = UnitPowerType(unit);

    local powerColor = PowerBarColor[powerType]
    if powerColor then
        asframe.powerbar:SetStatusBarColor(powerColor.r, powerColor.g, powerColor.b)
    end

    asframe:ClearAllPoints();
    asframe:SetPoint("TOPLEFT", healthBarContainer, "TOPLEFT", -5, 1);

    local checkcolor = false;

    if UnitIsPlayer(unit) then
    else
        checkcolor = true;
    end

    unitFrame:UnregisterEvent("UNIT_THREAT_SITUATION_UPDATE");
    unitFrame:UnregisterEvent("UNIT_THREAT_LIST_UPDATE");
    asframe:Show();

    asframe.checkcolor = checkcolor;

    local level = UnitLevel(unit);

    asframe.isboss = false;
    if isparty and level then
        if level < 0 or level > UnitLevel("player") then
            asframe.isboss = true;
        end
    end

    updatetarget(asframe);
    updatemouseover(asframe);

    local function callback()
        updateNamePlate(namePlateFrameBase);
    end

    if asframe.timer then
        asframe.timer:Cancel();
    end

    asframe.timer = C_Timer.NewTicker(ns.ANameP_UpdateRate, callback);
end

local function addUnit(unitToken)
    local namePlateFrameBase = C_NamePlate.GetNamePlateForUnit(unitToken, issecure());

    if namePlateFrameBase then
        addNamePlate(namePlateFrameBase);
        if namePlateFrameBase.asNamePlates ~= nil then
            local asframe = namePlateFrameBase.asNamePlates;
            updateAll(asframe);
        end
    end
end

local function updateUnit(unitToken)
    local namePlateFrameBase = C_NamePlate.GetNamePlateForUnit(unitToken, issecure());
    if namePlateFrameBase and not namePlateFrameBase:IsForbidden() then
        if namePlateFrameBase.asNamePlates ~= nil then
            local asframe = namePlateFrameBase.asNamePlates;
            updatePower(asframe);
            updateHealthbarColor(asframe);
        end
    end
end


local function initclass()
    local localizedClass, englishClass = UnitClass("player");

    local lowhealthpercent = 0;
    local highhealthpercent = 0;
    do
        if (englishClass == "MAGE") then
            if (C_SpellBook.IsSpellKnown(2948)) then
                lowhealthpercent = 30;
            end

            if (C_SpellBook.IsSpellKnown(384581)) then
                lowhealthpercent = 35;
            end
        end

        if (englishClass == "HUNTER") then
            if (C_SpellBook.IsSpellKnown(466930) or C_SpellBook.IsSpellKnown(466932)) then
                highhealthpercent = 80;
                lowhealthpercent = 20;
            elseif (C_SpellBook.IsSpellKnown(53351)) then
                lowhealthpercent = 20;
            end
        end

        if (englishClass == "WARRIOR") then
            if (C_SpellBook.IsSpellKnown(281001)) then
                lowhealthpercent = 35;
            else
                lowhealthpercent = 20;
            end
        end

        if (englishClass == "PRIEST") then
            lowhealthpercent = 20;
        end

        if (englishClass == "PALADIN") then
            lowhealthpercent = 20;
        end

        if (englishClass == "DEATHKNIGHT") then
            if (C_SpellBook.IsSpellKnown(343294)) then
                lowhealthpercent = 35;
            end
        end

        if (englishClass == "WARLOCK") then
            if (C_SpellBook.IsSpellKnown(17877)) then --어연
                lowhealthpercent = 30;
            end
        end
    end

    if highhealthpercent > 0 and lowhealthpercent > 0 then
        colorcurve = C_CurveUtil.CreateColorCurve();
        colorcurve:SetType(Enum.LuaCurveType.Step);
        colorcurve:AddPoint(highhealthpercent / 100, CreateColor(1, 0.2, 0.2, 1));
        colorcurve:AddPoint(lowhealthpercent / 100, CreateColor(0.5, 1, 1, 1));
        colorcurve:AddPoint(0, CreateColor(1, 0, 0, 1));
    elseif lowhealthpercent > 0 then
        colorcurve = C_CurveUtil.CreateColorCurve();
        colorcurve:SetType(Enum.LuaCurveType.Step);
        colorcurve:AddPoint(lowhealthpercent / 100, CreateColor(0.5, 1, 1, 1));
        colorcurve:AddPoint(0, CreateColor(1, 0, 0, 1));
    else
        colorcurve = C_CurveUtil.CreateColorCurve();
        colorcurve:SetType(Enum.LuaCurveType.Step);
        colorcurve:AddPoint(0, CreateColor(0.5, 1, 1, 1));
    end
end


local function ANameP_OnEvent(self, event, ...)
    local arg1 = ...;

    if event == "NAME_PLATE_CREATED" then
        local namePlateFrameBase = ...;
        createNamePlate(namePlateFrameBase);
    elseif event == "NAME_PLATE_UNIT_ADDED" then
        local unitToken = ...;
        addUnit(unitToken);
    elseif event == "NAME_PLATE_UNIT_REMOVED" then
        local unitToken = ...;
        removeUnit(unitToken);
    elseif event == "PLAYER_ENTERING_WORLD" then
        local isInstance, instanceType = IsInInstance();
        ispvp = false;
        israid = false;
        isparty = false;
        if isInstance and (instanceType == "party" or instanceType == "raid" or instanceType == "scenario") then
            if instanceType == "raid" then
                israid = true;
            else
                isparty = true;
            end
        else
            ispvp = true;
        end
        updateTankerList();
        initclass();
    elseif event == "UNIT_FACTION" then
        local unitToken = ...;
        addUnit(unitToken);
    elseif event == "GROUP_JOINED" or event == "GROUP_ROSTER_UPDATE" or event == "PLAYER_ROLES_ASSIGNED" then
        updateTankerList();
    elseif event == "ACTIVE_TALENT_GROUP_CHANGED" or event == "TRAIT_CONFIG_UPDATED" or event == "TRAIT_CONFIG_LIST_UPDATED" then
        initclass();
    end
end

local function ANameP_OnUpdate()
    updateUnit("target");
end


local function initAddon()
    ANameP:RegisterEvent("NAME_PLATE_CREATED");
    ANameP:RegisterEvent("NAME_PLATE_UNIT_ADDED");
    ANameP:RegisterEvent("NAME_PLATE_UNIT_REMOVED");
    -- 나중에 추가 처리가 필요하면 하자.
    -- ANameP:RegisterEvent("FORBIDDEN_NAME_PLATE_UNIT_ADDED");
    -- ANameP:RegisterEvent("FORBIDDEN_NAME_PLATE_UNIT_REMOVED");

    ANameP:RegisterEvent("PLAYER_ENTERING_WORLD");
    ANameP:RegisterEvent("ADDON_LOADED")
    ANameP:RegisterEvent("UNIT_FACTION");
    ANameP:RegisterEvent("GROUP_JOINED");
    ANameP:RegisterEvent("GROUP_ROSTER_UPDATE");
    ANameP:RegisterEvent("PLAYER_ROLES_ASSIGNED");
    ANameP:RegisterEvent("PLAYER_REGEN_ENABLED");
    ANameP:RegisterEvent("TRAIT_CONFIG_UPDATED");
    ANameP:RegisterEvent("TRAIT_CONFIG_LIST_UPDATED");
    ANameP:RegisterEvent("ACTIVE_TALENT_GROUP_CHANGED");

    ANameP:SetScript("OnEvent", ANameP_OnEvent)
    -- 주기적으로 Callback
    C_Timer.NewTicker(ns.ANameP_UpdateRateTarget, ANameP_OnUpdate);
end

initAddon();
