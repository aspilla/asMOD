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
                local data = castFrame.data;
                local hidecool = true;
                local coolcolor = { r = 0.8, g = 0.8, b = 1 };

                if spellid ~= data.spellid then
                    castFrame.icon:SetTexture(texture);
                    castFrame.count:Hide();

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

                    data.spellid = spellid;
                end

                local start = startTime / 1000;
                local duration = (endTime / 1000) - start;
                local expirationTime = start + duration;

                if start ~= data.start or duration ~= data.duration then
                    ns.asCooldownFrame_Set(castFrame.cooldown, start, duration, true);
                    data.start = start;
                    data.duration = duration;
                end

                local currtime = GetTime();
                local remain = math.ceil(expirationTime - currtime);
                if castFrame.hideCountdownNumbers == false then                    
                    if remain < ns.options.MinSectoShowCooldown then
                        hidecool = false;

                        if remain > 0 and remain < 10 then
                            coolcolor = { r = 1, g = 1, b = 0.3 };
                        end
                    end
                end

                if (hidecool ~= data.hidecool) then
                    castFrame.cooldown:SetHideCountdownNumbers(hidecool);
                    data.hidecool = hidecool;
                end

                if hidecool == false and (data.coolcolor == nil or coolcolor.g ~= data.coolcolor.g) then
                    castFrame.cooldowntext:SetVertexColor(coolcolor.r, coolcolor.g, coolcolor.b);
                    data.coolcolor = coolcolor;
                end

                asframe.ncasting = index;
                return true;
            end
        end
    end

    return false;
end

function ns.isAttackable(unit)
    local reaction = UnitReaction("player", unit);
    if reaction and reaction <= 4 then
        return true;
    end
    return false;
end

local function ARCB_HideCast(asframe)
    if asframe and asframe.castFrames then
        for i = asframe.ncasting + 1, #asframe.castFrames do
            asframe.castFrames[i]:Hide();
            asframe.castFrames[i].data = {};
        end
    end

    if asframe then
        asframe.ncasting = 0;
    end
end

local function CheckCasting(unit)
    if ns.isAttackable(unit) then
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
        if (MAX_BOSS_FRAMES) then
            for i = 1, MAX_BOSS_FRAMES do
                local unit = "boss" .. i;
                if UnitExists(unit) then
                    ns.CastingUnits[unit] = true;
                end
            end
        end

        for unit, check in pairs(ns.CastingUnits) do
            if check then
                local notcasting = CheckCasting(unit);

                if notcasting then
                    ns.CastingUnits[unit] = nil;
                end
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
            if mod.Options and mod.announces then
                for k, obj in pairs(mod.announces) do
                    if obj.spellId and obj.announceType and obj.option then
                        if (DangerousSpellList[obj.spellId] == nil or DangerousSpellList[obj.spellId] ~= "interrupt") and mod.Options[obj.option] then
                            DangerousSpellList[obj.spellId] = obj.announceType;
                        end
                    end 
                end
            end

            if mod.Options and mod.specwarns then
                for k, obj in pairs(mod.specwarns) do
                    if obj.spellId and obj.announceType and obj.option then
                        if (DangerousSpellList[obj.spellId] == nil or DangerousSpellList[obj.spellId] ~= "interrupt") and mod.Options[obj.option] then
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
    C_Timer.After(2, scanDBM);
end
