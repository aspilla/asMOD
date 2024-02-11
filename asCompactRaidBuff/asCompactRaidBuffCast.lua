local _, ns = ...;

local DangerousSpellList = {};
local tanklist = {};

ns.CastingUnits = {};

-- 탱커 처리부
function ns.updateTankerList()
    local _, RTB_ZoneType = IsInInstance();

    if RTB_ZoneType == "pvp" or RTB_ZoneType == "arena" then
        return nil;
    end

    tanklist = {};
    if IsInRaid() then
        for framename, asframe in pairs(ns.asraid) do
            if asframe and asframe.frame and asframe.frame:IsShown() and asframe.unit then
                local assignedRole = UnitGroupRolesAssigned(asframe.unit);
                if assignedRole == "TANK" or assignedRole == "MAINTANK" then
                    table.insert(tanklist, framename);
                end
            end
        end
    elseif IsInGroup() then
        for framename, asframe in pairs(ns.asparty) do
            if asframe and asframe.frame and asframe.frame:IsShown() and asframe.unit then
                local assignedRole = UnitGroupRolesAssigned(asframe.unit);
                if assignedRole == "TANK" or assignedRole == "MAINTANK" then
                    table.insert(tanklist, framename);
                end
            end
        end
    end
end

local function ACRB_updateCasting(asframe, unit)
    if asframe and asframe.frame and asframe.frame:IsShown() and asframe.castFrames then
        local index = asframe.ncasting + 1;
        local castFrame = asframe.castFrames[index];

        local frameunit = asframe.unit

        if asframe.displayedUnit and asframe.displayedUnit ~= frameunit then
            frameunit = asframe.displayedUnit;
        end

        if frameunit and UnitIsUnit(unit .. "target", frameunit) then
            local name, text, texture, startTime, endTime, isTradeSkill, castID, notInterruptible, spellid =
                UnitCastingInfo(unit);
            if not name then
                name, text, texture, startTime, endTime, isTradeSkill, notInterruptible, spellid = UnitChannelInfo(unit);
            end

            if name and index <= #(asframe.castFrames) then
                castFrame.icon:SetTexture(texture);
                castFrame.count:Hide();

                local curr = GetTime();
                local start = startTime / 1000;
                local duration = (endTime / 1000) - start;

                ns.asCooldownFrame_Set(castFrame.cooldown, start, duration, true);

                if DangerousSpellList[spellid] then
                    if DangerousSpellList[spellid] == "interrupt" or not notInterruptible then
                        ns.lib.PixelGlow_Start(castFrame, { 0, 1, 0.32, 1 });
                    else
                        ns.lib.PixelGlow_Start(castFrame, { 0.5, 0.5, 0.5, 1 });
                    end
                else
                    ns.lib.PixelGlow_Stop(castFrame);
                end
                castFrame.castspellid = spellid;
                castFrame:Show();
                asframe.ncasting = index;

                return true;
            end
        end
    end

    return false;
end

function ns.isFaction(unit)
    if UnitIsUnit("player", unit) then
        return false;
    else
        local reaction = UnitReaction("player", unit);
        if reaction and reaction <= 4 then
            return true;
        elseif UnitIsPlayer(unit) then
            return false;
        end
    end
end

local function ARCB_HideCast(asframe)
    if asframe and asframe.castFrames then
        for i = asframe.ncasting + 1, #asframe.castFrames do
            asframe.castFrames[i]:Hide();
        end
    end
end

local function CheckCasting(unit)
    if ns.isFaction(unit) then
        local name = UnitCastingInfo(unit);
        if not name then
            name = UnitChannelInfo(unit);
        end

        if name then
            -- 탱커 부터
            for _, framename in pairs(tanklist) do
                local asframe;
                if IsInRaid() then
                    asframe = ns.asraid[framename];
                else
                    asframe = ns.asparty[framename];
                end
                if ACRB_updateCasting(asframe, unit) then
                    return;
                end
            end

            if (IsInRaid()) then
                for _, asframe in pairs(ns.asraid) do
                    if asframe and asframe.frame and asframe.frame:IsShown() then
                        if ACRB_updateCasting(asframe, unit) then
                            return;
                        end
                    end
                end
            elseif (IsInGroup()) then
                for _, asframe in pairs(ns.asparty) do
                    if asframe and asframe.frame and asframe.frame:IsShown() then
                        if ACRB_updateCasting(asframe, unit) then
                            return;
                        end
                    end
                end
            end
            return false;
        end
    end

    return true;
end

function ns.ACRB_CheckCasting()
    if not ns.options.TopCastAlert then
        return;
    end

    if (IsInGroup()) then
        for unit, _ in pairs(ns.CastingUnits) do
            local notcasting = CheckCasting(unit);

            if notcasting then
                ns.CastingUnits[unit] = nil;
            end
        end

        if (IsInRaid()) then
            for _, asframe in pairs(ns.asraid) do
                if asframe and asframe.frame and asframe.frame:IsShown() then
                    ARCB_HideCast(asframe);
                end
            end
        elseif (IsInGroup()) then
            for _, asframe in pairs(ns.asparty) do
                if asframe and asframe.frame and asframe.frame:IsShown() then
                    ARCB_HideCast(asframe);
                end
            end
        end
    end
end

local DBMobj;

local function scanDBM()
    DangerousSpellList = {};
    if DBMobj.Mods then
        for i, mod in ipairs(DBMobj.Mods) do
            if mod.announces then
                for k, obj in pairs(mod.announces) do
                    if obj.spellId and obj.announceType then
                        if DangerousSpellList[obj.spellId] == nil or DangerousSpellList[obj.spellId] ~= "interrupt" then
                            DangerousSpellList[obj.spellId] = obj.announceType;
                        end
                    end
                end
            end
            if mod.specwarns then
                for k, obj in pairs(mod.specwarns) do
                    if obj.spellId and obj.announceType then
                        if DangerousSpellList[obj.spellId] == nil or DangerousSpellList[obj.spellId] ~= "interrupt" then
                            DangerousSpellList[obj.spellId] = obj.announceType;
                        end
                    end
                end
            end
        end
    end
end

function ns.NewMod(self, ...)
    DBMobj = self;
    C_Timer.After(0.25, scanDBM);
end
