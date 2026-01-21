local _, ns = ...;

local main_frame = CreateFrame("Frame", nil, UIParent)
main_frame:SetAllPoints()
main_frame:Hide()

local function hide_frame(frame)
    if not frame then return end

    frame:UnregisterAllEvents()
    frame:Hide()
    frame:SetParent(main_frame)

    local health = frame.healthBar or frame.healthbar
    if health then
        health:UnregisterAllEvents()
    end

    local power = frame.manabar
    if power then
        power:UnregisterAllEvents()
    end

    local spell = frame.castBar or frame.spellbar
    if spell then
        spell:UnregisterAllEvents()
    end

    local altpowerbar = frame.powerBarAlt
    if altpowerbar then
        altpowerbar:UnregisterAllEvents()
    end

    local buffFrame = frame.BuffFrame
    if buffFrame then
        buffFrame:UnregisterAllEvents()
    end

    local petFrame = frame.PetFrame
    if petFrame then
        petFrame:UnregisterAllEvents()
    end
end

local function hide_unitframe(unit)
    if unit == "player" and PlayerFrame then
        hide_frame(PlayerFrame)
    elseif unit == "target" and TargetFrame then
        hide_frame(TargetFrame)
    elseif unit == "focus" and FocusFrame then
        hide_frame(FocusFrame)
    elseif unit == "pet" and PetFrame then
        hide_frame(PetFrame)
    end
end

function ns.hide_defauls()
    hide_unitframe("player");
    hide_unitframe("target");
    hide_unitframe("focus");
    hide_unitframe("pet");

    if (MAX_BOSS_FRAMES) then
        for i = 1, MAX_BOSS_FRAMES do
            local bossframe = _G["Boss" .. i .. "TargetFrame"];

            if bossframe then
                hide_frame(bossframe);
            end
        end
    end
end

ns.hide_defauls();