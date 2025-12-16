local _, ns = ...;

local hiddenParent = CreateFrame("Frame", nil, _G.UIParent)
hiddenParent:SetAllPoints()
hiddenParent:Hide()

local function HideFrame(frame)
    if not frame then return end

    frame:UnregisterAllEvents()
    frame:Hide()
    frame:SetParent(hiddenParent)

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

local function HideBlizzardUnitFrame(unit)
    if unit == "player" and _G.PlayerFrame then
        HideFrame(_G.PlayerFrame)
    elseif unit == "target" and _G.TargetFrame then
        HideFrame(_G.TargetFrame)
    elseif unit == "focus" and _G.FocusFrame then
        HideFrame(_G.FocusFrame)
    elseif unit == "pet" and _G.PetFrame then
        HideFrame(_G.PetFrame)
    end
end

function ns.HideDefaults()
    HideBlizzardUnitFrame("player");
    HideBlizzardUnitFrame("target");
    HideBlizzardUnitFrame("focus");
    HideBlizzardUnitFrame("pet");

    if (MAX_BOSS_FRAMES) then
        for i = 1, MAX_BOSS_FRAMES do
            local bossframe = _G["Boss" .. i .. "TargetFrame"];

            if bossframe then
                HideFrame(bossframe);
            end
        end
    end
end

ns.HideDefaults();