local _, ns = ...;

function ns.update_power(asframe)
    if not ns.options.ShowPower then
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

local function update_barcolor(asframe, color)
    local parent = asframe.nameplateBase;

    if not parent or not parent.UnitFrame or parent.UnitFrame:IsForbidden() or not asframe.BarColor then
        return;
    end

    asframe.BarColor:SetVertexColor(color.r, color.g, color.b);
    asframe.BarColor:Show();
end

local function get_auracount(list)
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

function ns.update_color(asframe)
    if not asframe.unit or not asframe.checkcolor or not asframe.BarColor then
        return;
    end

    local unit = asframe.unit;
    local nameplate = asframe.nameplateBase;

    if not nameplate or not nameplate.UnitFrame or nameplate.UnitFrame:IsForbidden() then
        return;
    end
    local UnitFrame = nameplate.UnitFrame;
    local healthBar = UnitFrame.healthBar;
    local castbar = UnitFrame.castBar;
    local debufflist = UnitFrame.AurasFrame.DebuffListFrame

    if not healthBar and healthBar:IsForbidden() then
        return;
    end

    local status = UnitThreatSituation("player", unit);
    local incombat = UnitAffectingCombat(unit);
    local alerttype = 0;

    local function getColor()
        if UnitIsPlayer(unit) then
            return nil;
        end

        --Target and Aggro High Priority
        if IsInGroup() and ns.options.ShowAggro and incombat then
            if ns.istanker then
                if status == nil or status == 0 then
                    return ns.options.TankAggroLoseColor;
                end
            end
            if status and status > 0 then
                return ns.options.AggroColor;
            end
        end

        --Cast Color
        if asframe.casticon:IsShown() and ns.options.ShowCastColor then
            local bartype = castbar.barType;
            if bartype == "uninterruptable" then
                return ns.options.UninterruptableColor;
            end

            return ns.options.InterruptableColor;
        end


        --Debuff Color
        if ns.options.ShowDebuffColor then
            local activeDebuffs = get_auracount(debufflist);

            if activeDebuffs > 0 then
                return ns.options.DebuffColor;
            end
        end

        if status and ns.options.ShowAggro then
            --return UnitHealthPercent(unit, ns.colorcurve);
            return ns.options.CombatColor;
        end

        if asframe.isboss and ns.options.ShowBossColor then
            return ns.options.BossColor;
        end

        if not (ns.isparty or ns.israid) and ns.options.ShowQuestColor and C_QuestLog.UnitIsRelatedToActiveQuest(unit) then
            return ns.options.QuestColor;
        end

        return nil;
    end

    local color = getColor();

    if color then
        update_barcolor(asframe, color);
    else
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

function ns.update_cast(asframe)
    if not ns.options.ShowCastIcon then
        return;
    end

    local unit = asframe.unit;
    local name, _, texture = UnitCastingInfo(unit);
    if not name then
        name, _, texture = UnitChannelInfo(unit);
    end

    if name then
        asframe.casticon.icon:SetTexture(texture);
        asframe.casticon:Show();
    else
        asframe.casticon:Hide();
    end
end

function ns.update_target(asframe)
    if asframe.unit and UnitIsUnit(asframe.unit, "target") then
        ns.update_power(asframe);
        return;
    end
end

function ns.update_mouseover(asframe)
    if UnitExists("mouseover") then
        if asframe.unit and UnitIsUnit(asframe.unit, "mouseover") then
            asframe.motext:Show();
            return;
        end
    end
    asframe.motext:Hide();
end
