local _, ns = ...;

local AHCA = CreateFrame("FRAME", nil, UIParent);
local gunit = nil;
local bfirst = true;

local function CheckHealer()
    local playerishealer = (UnitGroupRolesAssigned("player") == "HEALER") or AHCA_Options.AlertAnyway;

    if playerishealer == false then
        gunit = nil;
        return;
    end

    if (IsInGroup()) then
        if IsInRaid() then -- raid
            gunit = nil;
            return;
        else -- party
            if UnitGroupRolesAssigned("player") == "HEALER" then
                gunit = "player";
                return;
            end
            for i = 1, 5 do
                local unit = "party" .. i;
                local role = UnitGroupRolesAssigned(unit);
                if role == "HEALER" then
                    gunit = unit;
                    return;
                end
            end
        end
    end
end

local function UpdateAlert()
    if gunit == nil then
        return;
    end

    if not IsInInstance() then
        return;
    end


    local max = UnitPowerMax(gunit, Enum.PowerType.Mana);
    local mana = UnitPower(gunit, Enum.PowerType.Mana);
    if max and mana and mana > 0 and max > 0 then
        local percent = math.ceil(mana / max * 100);
        if AHCA_Options.AnnounceMana and percent < tonumber(AHCA_Options.AnnounceMana) then
            local msg = "힐러마나 " .. percent .. "%";
            --print (msg);
            C_ChatInfo.SendChatMessage(msg);
        end
    end
end

local function OnEvent(self, event, ...)
    if bfirst then
        ns.setup_option();
        bfirst = false;
    end

    CheckHealer();
    if event == "PLAYER_REGEN_ENABLED" then
        UpdateAlert();
    end
end

local function OnInit()
    AHCA:SetScript("OnEvent", OnEvent);
    AHCA:RegisterEvent("PLAYER_REGEN_ENABLED");
    AHCA:RegisterEvent("PLAYER_ENTERING_WORLD");
    AHCA:RegisterEvent("ACTIVE_TALENT_GROUP_CHANGED");
    AHCA:RegisterEvent("GROUP_ROSTER_UPDATE");
    AHCA:RegisterEvent("ROLE_CHANGED_INFORM");
end

OnInit();
