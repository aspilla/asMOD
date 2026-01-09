local _, ns = ...;
local main_frame = CreateFrame("Frame", nil, UIParent);

local configs = {
    fontsize = 12,
}

ns.tanklist = {};
ns.isparty = false;
ns.israid = false;
ns.ispvp = false;
ns.istanker = false;
ns.colorcurve = nil;

local function update_tanklist()
    if ns.ispvp then
        return nil;
    end

    ns.tanklist = {}
    if IsInGroup() then
        if IsInRaid() then -- raid
            for i = 1, GetNumGroupMembers() do
                local unitid = "raid" .. i
                local notMe = not UnitIsUnit("player", unitid)
                if UnitExists(unitid) and notMe then
                    local _, _, _, _, _, _, _, _, _, role, _, assignedRole = GetRaidRosterInfo(i);
                    if assignedRole == "TANK" then
                        table.insert(ns.tanklist, unitid);
                    end
                end
            end
        else -- party
            for i = 1, 4 do
                local unitid = "party" .. i;
                if UnitExists(unitid) then
                    local assignedRole = UnitGroupRolesAssigned(unitid);
                    if assignedRole == "TANK" then
                        table.insert(ns.tanklist, unitid);
                    end
                end
            end
        end
    end
end

local function check_playertankrole()
    local assignedRole = UnitGroupRolesAssigned("player");
    if (assignedRole == "NONE") then
        local spec = C_SpecializationInfo.GetSpecialization();
        return spec and GetSpecializationRole(spec) == "TANK";
    end
    ns.istanker = (assignedRole == "TANK");
end


local function on_asframe_event(asframe, event, ...)
    if (event == "PLAYER_TARGET_CHANGED") then
        ns.update_target(asframe);
    elseif event == "UPDATE_MOUSEOVER_UNIT" then
        ns.update_mouseover(asframe);
    else
        ns.update_cast(asframe);
        ns.update_color(asframe);
    end
end

local function remove_unit(unit)
    local namePlateFrameBase = C_NamePlate.GetNamePlateForUnit(unit, issecure());

    if not namePlateFrameBase then
        return;
    end

    if namePlateFrameBase.asNamePlates ~= nil then
        local asframe = namePlateFrameBase.asNamePlates;

        ns.lib.PixelGlow_Stop(asframe.casticon);
        ns.lib.PixelGlow_Stop(asframe);

        asframe.casticon:Hide();
        asframe.coloroverlay:Hide();

        asframe:Hide();
        asframe:UnregisterAllEvents();
        asframe:SetScript("OnEvent", nil);

        if asframe.timer then
            asframe.timer:Cancel();
            asframe.timer = nil;
        end

        asframe.alerttype = nil;
        asframe:ClearAllPoints();
        ns.free_asframe(asframe);
        asframe = nil;
    end

    if namePlateFrameBase and namePlateFrameBase.asNamePlates ~= nil then
        namePlateFrameBase.asNamePlates = nil;
    end
end


local function change_item(button)
    button.isasmod = true;

    local fontsize = configs.fontsize;


    if button.Cooldown then
        for _, r in next, { button.Cooldown:GetRegions() } do
            if r:GetObjectType() == "FontString" then
                r:SetFont(STANDARD_TEXT_FONT, fontsize, "OUTLINE");
                r:ClearAllPoints();
                r:SetPoint("CENTER", button, "TOP", 0, 0);
                r:SetDrawLayer("OVERLAY");
                break;
            end
        end
    end

    if not button.border then
        button.border = button:CreateTexture(nil, "BACKGROUND", "asNamePlatesBorderTemplate");
        button.border:SetAllPoints(button);
        button.border:SetColorTexture(0, 0, 0, 1);
        button.border:SetTexCoord(0.04, 0.04, 0.04, 0.96, 0.96, 0.04, 0.96, 0.96);
    else
        button.border:SetAlpha(1)
    end
    button.border:Show()

    if button.CountFrame and button.CountFrame.Count then
        local r = button.CountFrame.Count;

        r:SetFont(STANDARD_TEXT_FONT, fontsize + 1, "OUTLINE");
        r:ClearAllPoints();
        r:SetPoint("CENTER", button, "BOTTOM", 0, 0);
        r:SetTextColor(0, 1, 0);
        r:SetDrawLayer("OVERLAY");
    end
end

local function hook_refresh(auraframe)
    if auraframe.auraItemFramePool then
        local pool = auraframe.auraItemFramePool;
        for button in pool:EnumerateActive() do
            if button.isasmod == nil then
                change_item(button);
            end
        end
    end
end


local function add_unit(unit)
    local namePlateFrameBase = C_NamePlate.GetNamePlateForUnit(unit, issecure());

    if not namePlateFrameBase then
        return;
    end

    if namePlateFrameBase.UnitFrame:IsForbidden() then
        return;
    end

    local unitFrame = namePlateFrameBase.UnitFrame;
    local healthbar = unitFrame.healthBar;
    local container = unitFrame.HealthBarsContainer;

    if not UnitCanAttack("player", unit) then
        if namePlateFrameBase.asNamePlates then
            remove_unit(unit);
        end
        return;
    end

    if namePlateFrameBase.asNamePlates == nil then
        namePlateFrameBase.asNamePlates = ns.get_asframe();
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
        asframe.casticon:SetPoint("BOTTOMLEFT", unitFrame.castBar, "BOTTOMRIGHT", 0.5, -1);
        local scale = NamePlateDriverMixin:GetNamePlateScale();
        local height = 22 * scale.vertical + 10
        asframe.casticon:SetWidth(height * 1.2);
        asframe.casticon:SetHeight(height);
        asframe.casticon:Hide();
        asframe.iscast = false;
    end

    if ns.options.ChangeTexture and not healthbar.border then
        healthbar:SetStatusBarTexture("RaidFrame-Hp-Fill");
        healthbar.bgTexture:Hide();



        healthbar.border = healthbar:CreateTexture(nil, "BACKGROUND", "asNamePlatesBorderTemplate");
        healthbar.border:SetPoint("TOPLEFT", healthbar, "TOPLEFT", -1, 1);
        healthbar.border:SetPoint("BOTTOMRIGHT", healthbar, "BOTTOMRIGHT", 1, -1);
        healthbar.border:SetColorTexture(0, 0, 0, 0.5);

        healthbar.border:Show();



        healthbar.selectedBorder:SetTexture("Interface\\Addons\\asNamePlates\\border.tga");
        healthbar.selectedBorder:SetPoint("TOPLEFT", healthbar, "TOPLEFT", -2, 2);
        healthbar.selectedBorder:SetPoint("BOTTOMRIGHT", healthbar, "BOTTOMRIGHT", 2, -2);
    end

    local previousTexture = healthbar:GetStatusBarTexture();
    asframe.coloroverlay:SetParent(healthbar);
    asframe.coloroverlay:ClearAllPoints();
    asframe.coloroverlay:SetPoint("TOPLEFT", previousTexture, "TOPLEFT", 0, 0);
    asframe.coloroverlay:SetPoint("BOTTOMRIGHT", previousTexture, "BOTTOMRIGHT", 0, 0);
    asframe.coloroverlay:SetVertexColor(previousTexture:GetVertexColor());
    asframe.coloroverlay:Hide();

    asframe:SetScript("OnEvent", on_asframe_event);

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

    asframe.targetedindi:ClearAllPoints();
    asframe.targetedindi:SetPoint("RIGHT", healthbar, "LEFT", 5, 0);
    asframe.targetedindi:SetAlpha(0);
    asframe.targetedindi:Show();
    asframe.targetedinditype = 1;
    
    local powertype = UnitPowerType(unit);

    local powerColor = PowerBarColor[powertype]
    if powerColor then
        asframe.powerbar:SetStatusBarColor(powerColor.r, powerColor.g, powerColor.b);        
    end
    asframe.powertype = powertype;

    asframe:ClearAllPoints();
    asframe:SetPoint("TOPLEFT", healthbar, "TOPLEFT", -5, 1);

    local checkcolor = false;

    if UnitIsPlayer(unit) then
    else
        checkcolor = true;
    end

    asframe:Show();

    asframe.checkcolor = checkcolor;

    local level = UnitLevel(unit);

    asframe.isboss = false;
    if ns.isparty and level then
        if level < 0 or level > UnitLevel("player") then
            asframe.isboss = true;
        end
    end

    local function callback()
        ns.update_power(asframe);
        ns.update_color(asframe);
        ns.update_targeted(asframe);
    end

    if asframe.timer then
        asframe.timer:Cancel();
    end

    asframe.timer = C_Timer.NewTicker(ns.configs.updaterate, callback);

    if ns.options.ChangeDebuffIcon and unitFrame.AurasFrame.RefreshList then
        hooksecurefunc(unitFrame.AurasFrame, "RefreshList", function()
            hook_refresh(unitFrame.AurasFrame)
        end)
    end
end


local function init_class()
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
        ns.colorcurve = C_CurveUtil.CreateColorCurve();
        ns.colorcurve:SetType(Enum.LuaCurveType.Step);
        ns.colorcurve:AddPoint(highhealthpercent / 100, CreateColor(1, 0.2, 0.2, 1));
        ns.colorcurve:AddPoint(lowhealthpercent / 100, CreateColor(0.5, 1, 1, 1));
        ns.colorcurve:AddPoint(0, CreateColor(1, 0, 0, 1));
    elseif lowhealthpercent > 0 then
        ns.colorcurve = C_CurveUtil.CreateColorCurve();
        ns.colorcurve:SetType(Enum.LuaCurveType.Step);
        ns.colorcurve:AddPoint(lowhealthpercent / 100, CreateColor(0.5, 1, 1, 1));
        ns.colorcurve:AddPoint(0, CreateColor(1, 0, 0, 1));
    else
        ns.colorcurve = C_CurveUtil.CreateColorCurve();
        ns.colorcurve:SetType(Enum.LuaCurveType.Step);
        ns.colorcurve:AddPoint(0, CreateColor(0.5, 1, 1, 1));
    end
end


local function on_main_event(self, event, ...)
    if event == "NAME_PLATE_UNIT_ADDED" then
        local unit = ...;
        add_unit(unit);
    elseif event == "NAME_PLATE_UNIT_REMOVED" then
        local unit = ...;
        remove_unit(unit);
    elseif event == "UNIT_FACTION" then
        local unit = ...;
        add_unit(unit);
    elseif event == "PLAYER_ENTERING_WORLD" then
        local isInstance, instanceType = IsInInstance();
        ns.ispvp = false;
        ns.israid = false;
        ns.isparty = false;
        if isInstance and (instanceType == "party" or instanceType == "raid" or instanceType == "scenario") then
            if instanceType == "raid" then
                ns.israid = true;
            else
                ns.isparty = true;
            end
        else
            ns.ispvp = true;
        end
        update_tanklist();
        init_class();
        check_playertankrole();
    elseif event == "GROUP_JOINED" or event == "GROUP_ROSTER_UPDATE" or event == "PLAYER_ROLES_ASSIGNED" then
        update_tanklist();
        check_playertankrole();
    elseif event == "ACTIVE_TALENT_GROUP_CHANGED" or event == "TRAIT_CONFIG_UPDATED" or event == "TRAIT_CONFIG_LIST_UPDATED" then
        init_class();
        check_playertankrole();
    end
end


local function init()
    main_frame:RegisterEvent("NAME_PLATE_UNIT_ADDED");
    main_frame:RegisterEvent("NAME_PLATE_UNIT_REMOVED");
    -- 나중에 추가 처리가 필요하면 하자.
    -- ANameP:RegisterEvent("FORBIDDEN_NAME_PLATE_UNIT_ADDED");
    -- ANameP:RegisterEvent("FORBIDDEN_NAME_PLATE_UNIT_REMOVED");

    main_frame:RegisterEvent("PLAYER_ENTERING_WORLD");
    main_frame:RegisterEvent("ADDON_LOADED")
    main_frame:RegisterEvent("UNIT_FACTION");
    main_frame:RegisterEvent("GROUP_JOINED");
    main_frame:RegisterEvent("GROUP_ROSTER_UPDATE");
    main_frame:RegisterEvent("PLAYER_ROLES_ASSIGNED");
    main_frame:RegisterEvent("PLAYER_REGEN_ENABLED");
    main_frame:RegisterEvent("TRAIT_CONFIG_UPDATED");
    main_frame:RegisterEvent("TRAIT_CONFIG_LIST_UPDATED");
    main_frame:RegisterEvent("ACTIVE_TALENT_GROUP_CHANGED");

    main_frame:SetScript("OnEvent", on_main_event)
end

init();
