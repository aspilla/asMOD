local _, ns = ...;
local main_frame = CreateFrame("Frame", nil, UIParent);

local configs = {
    fontsize = 12,
    castbar_heightadder = 5,
}

ns.enums = {
    none = 0,
    party = 1,
    raid = 2,
}

ns.tanklist = {};
ns.instype = ns.enums.none;

ns.istanker = false;
ns.colorcurve = nil;

local function update_tanklist()
    if ns.instype == ns.enums.none then
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

local function restore_default(nameplate_base)
    local unitframe = nameplate_base.UnitFrame;
    if unitframe then
        local healthbar = unitframe.healthBar;
        if healthbar then
            healthbar:SetStatusBarTexture("UI-HUD-CoolDownManager-Bar");
            healthbar.bgTexture:SetAlpha(1);
            healthbar.selectedBorder:SetAlpha(1);
        end
    end
end

local function remove_unit(unit)
    local nameplate_base = C_NamePlate.GetNamePlateForUnit(unit, issecure());

    if not nameplate_base then
        return;
    end

    if nameplate_base.asNamePlates ~= nil then
        local asframe = nameplate_base.asNamePlates;

        asframe.casticon:Hide();
        asframe.coloroverlay:Hide();
        asframe.notinterruptable:SetAlpha(0);
        asframe.notinterruptable:Hide();
        asframe.important:SetAlpha(0);
        asframe.important:Hide();
        asframe.border:Hide();
        asframe.selected:Hide();

        restore_default(nameplate_base)

        asframe:Hide();
        asframe:UnregisterAllEvents();
        asframe:SetScript("OnEvent", nil);

        if asframe.timer then
            asframe.timer:Cancel();
            asframe.timer = nil;
        end

        asframe:ClearAllPoints();
        ns.free_asframe(asframe);
        asframe = nil;
    end

    if nameplate_base and nameplate_base.asNamePlates ~= nil then
        nameplate_base.asNamePlates = nil;
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
        button.border = button:CreateTexture(nil, "ARTWORK");
        button.border:SetTexture("Interface\\Addons\\asNamePlates\\border.tga")
        button.border:SetDrawLayer("ARTWORK", 6);
        button.border:SetVertexColor(0, 0, 0, 1);
        button.border:SetTexCoord(0.08, 0.08, 0.08, 0.92, 0.92, 0.08, 0.92, 0.92);
        button.border:ClearAllPoints();
        button.border:SetPoint("TOPLEFT", button, "TOPLEFT", 0, 0);
        button.border:SetPoint("BOTTOMRIGHT", button, "BOTTOMRIGHT", 0, 0);
        local mask = button.Icon:GetMaskTexture(1)
        if mask then
            button.Icon:RemoveMaskTexture(mask);
        end
        button.Icon:SetTexCoord(0.08, 0.08, 0.08, 0.92, 0.92, 0.08, 0.92, 0.92);
        button.Cooldown:SetAllPoints(button.Icon);
        button.Cooldown:SetSwipeTexture("Interface\\Buttons\\WHITE8X8");
        button.Cooldown:SetSwipeColor(0, 0, 0, 0.8);
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

local org_height = nil;

local function add_unit(unit)
    local nameplate_base = C_NamePlate.GetNamePlateForUnit(unit, issecure());

    if not nameplate_base then
        return;
    end

    if nameplate_base.UnitFrame:IsForbidden() then
        return;
    end

    local unitframe = nameplate_base.UnitFrame;
    local healthbar = unitframe.healthBar;
    local castbar = unitframe.castBar;

    if not UnitCanAttack("player", unit) then
        if nameplate_base.asNamePlates then
            remove_unit(unit);
        else
            restore_default(nameplate_base);
        end
        return;
    end

    if nameplate_base.asNamePlates == nil then
        nameplate_base.asNamePlates = ns.get_asframe();
    end

    local asframe = nameplate_base.asNamePlates;
    local scale = NamePlateDriverMixin:GetNamePlateScale();
    asframe:SetParent(healthbar);
    asframe:SetFrameLevel(healthbar:GetFrameLevel() + 1000);
    asframe.nameplateBase = nameplate_base;
    asframe.unit = unit;
    asframe.checkcolor = false;

    asframe:UnregisterAllEvents();
    asframe:SetScript("OnEvent", nil);

    if org_height == nil then
        local healthbar_height = healthbar:GetHeight();
        local castbar_height = castbar:GetHeight();

        if not issecretvalue(healthbar_height) then
            org_height = healthbar_height + castbar_height;
        end
    end

    if castbar then
        asframe.casticon:ClearAllPoints();
        PixelUtil.SetPoint(asframe.casticon, "BOTTOMLEFT", castbar, "BOTTOMRIGHT", 1.5, -1);

        local height = 36 * scale.vertical;

        if org_height then
            height = org_height + configs.castbar_heightadder;
        end

        asframe.casticon:SetWidth(height * 1.1);
        asframe.casticon:SetHeight(height);
        asframe.casticon:Hide();
        asframe.iscast = false;
    end

    if ns.options.ChangeTexture then
        if not healthbar.border then
            healthbar:SetStatusBarTexture("RaidFrame-Hp-Fill");

            asframe.selected:SetParent(healthbar);
            asframe.selected:SetDrawLayer("BACKGROUND", -6);
            asframe.selected:ClearAllPoints();
            PixelUtil.SetPoint(asframe.selected, "TOPLEFT", healthbar, "TOPLEFT", -2, 2);
            PixelUtil.SetPoint(asframe.selected, "BOTTOMRIGHT", healthbar, "BOTTOMRIGHT", 2, -2);
            asframe.selected:SetAlpha(1);

            asframe.border:SetParent(healthbar);
            asframe.border:SetDrawLayer("BACKGROUND", -5);
            asframe.border:ClearAllPoints();
            PixelUtil.SetPoint(asframe.border, "TOPLEFT", healthbar, "TOPLEFT", -1, 1);
            PixelUtil.SetPoint(asframe.border, "BOTTOMRIGHT", healthbar, "BOTTOMRIGHT", 1, -1);
            asframe.border:SetAlpha(1);
            asframe.border:Show();

            healthbar.bgTexture:SetAlpha(0);
            healthbar.selectedBorder:SetAlpha(0)
        end
    else
        asframe.selected:SetAlpha(0);
        asframe.border:SetAlpha(0);
    end

    asframe.important:ClearAllPoints();
    asframe.important:SetParent(healthbar);
    asframe.important:SetDrawLayer("OVERLAY", 1);
    asframe.important:SetPoint("TOPLEFT", healthbar, "TOPLEFT", -1, 1);
    asframe.important:SetPoint("BOTTOMRIGHT", healthbar, "BOTTOMRIGHT", 1, -1);
    asframe.important:SetAlpha(0);
    asframe.important:Show();
    asframe.importantshowtype = 1;

    local previousTexture = healthbar:GetStatusBarTexture();
    asframe.coloroverlay:SetParent(healthbar);
    asframe.coloroverlay:ClearAllPoints();
    PixelUtil.SetPoint(asframe.coloroverlay, "TOPLEFT", previousTexture, "TOPLEFT", 0, 0);
    PixelUtil.SetPoint(asframe.coloroverlay, "BOTTOMRIGHT", previousTexture, "BOTTOMRIGHT", 0, 0);
    asframe.coloroverlay:SetVertexColor(previousTexture:GetVertexColor());
    asframe.coloroverlay:Hide();

    asframe.notinterruptable:SetParent(healthbar);
    asframe.notinterruptable:ClearAllPoints();
    PixelUtil.SetPoint(asframe.notinterruptable, "TOPLEFT", previousTexture, "TOPLEFT", 0, 0);
    PixelUtil.SetPoint(asframe.notinterruptable, "BOTTOMRIGHT", previousTexture, "BOTTOMRIGHT", 0, 0);
    asframe.notinterruptable:SetAlpha(0);
    asframe.notinterruptable:Hide();


    asframe.powerbar:ClearAllPoints();
    PixelUtil.SetPoint(asframe.powerbar, "TOP", healthbar, "BOTTOM", 0, 2);
    asframe.powerbar:Hide();

    asframe.motext:ClearAllPoints();
    PixelUtil.SetPoint(asframe.motext, "TOP", healthbar, "BOTTOM", 0, -1);
    asframe.motext:Hide();

    asframe.targetedindi:ClearAllPoints();
    PixelUtil.SetPoint(asframe.targetedindi, "RIGHT", healthbar, "LEFT", 0, 0);
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
    PixelUtil.SetPoint(asframe, "TOPLEFT", healthbar, "TOPLEFT", -5, 1);

    local checkcolor = false;

    if UnitIsPlayer(unit) then
    else
        checkcolor = true;
    end

    asframe:Show();

    asframe.checkcolor = checkcolor;

    local level = UnitLevel(unit);

    asframe.isboss = false;
    if ns.instype == ns.enums.party and level then
        if level < 0 or level > UnitLevel("player") then
            asframe.isboss = true;
        end
    end

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

    local function callback()
        ns.update_power(asframe);
        ns.update_color(asframe);
        ns.update_targeted(asframe);
        ns.update_mouseover(asframe);
    end

    if asframe.timer then
        asframe.timer:Cancel();
    end

    asframe.timer = C_Timer.NewTicker(ns.configs.updaterate, callback);

    if ns.options.ChangeDebuffIcon and unitframe.AurasFrame.RefreshList then
        hooksecurefunc(unitframe.AurasFrame, "RefreshList", function()
            hook_refresh(unitframe.AurasFrame)
        end)
    end

    ns.update_target(asframe);
    ns.update_color(asframe);
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
        ns.instype = ns.enums.none;
        if isInstance and (instanceType == "party" or instanceType == "raid" or instanceType == "scenario") then
            if instanceType == "raid" then
                ns.instype = ns.enums.raid;
            else
                ns.instype = ns.enums.party;
            end
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

local function create_macro()
    if InCombatLockdown() then
        return;
    end
    local macroText =
    "/run SetCVar (\"nameplateGlobalScale\", 1.0)\n/run SetCVar (\"nameplateSelectedScale\", 1.3)\n/run SetCVar(\"nameplateUseClassColorForFriendlyPlayerUnitNames\", 1)\n/run SetCVar(\"nameplateShowOnlyNameForFriendlyPlayerUnits\", 1)\n/reload";
    local macroName = "asNamePlates Setup";
    local macroID = GetMacroIndexByName(macroName);


    if (macroID == 0) then
        local global, perChar = GetNumMacros();

        if global < 120 then
            CreateMacro(macroName, "Inv_10_inscription3_darkmoondeckbox_black", macroText, false);
        else
            print("asMOD error:too many macros, so need to delete some")
        end
    else
        EditMacro(macroID, macroName, "Inv_10_inscription3_darkmoondeckbox_black", macroText)
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

    C_Timer.After(1, create_macro);
end

init();
