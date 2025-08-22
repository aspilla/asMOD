local _, ns        = ...;

local refresh_rate = 0.5;
local ABLA         = CreateFrame("FRAME", nil, UIParent);

local lust_debuffs = {
    57723,  --shaman (alliance)
    57724,  --shaman
    80354,  --mage
    264689, --hunter
    390435, --evoker
    --25771,  --test
}

local lust_classes = {
    ["MAGE"] = true,
    ["SHAMAN"] = true,
    ["HUNTER"] = true,
    ["EVOKER"] = true,
}

local ready_msg    = "Bloodlust ready";

if GetLocale() == "koKR" then
    ready_msg = "블러드 준비";
end

local function alertMsg()
    if not IsInInstance() then
        return;
    end

    if ns.options.VoiceAlert then
        PlaySoundFile("Interface\\AddOns\\asBloodlustAlert\\Ready.mp3", "MASTER")
    end
    C_ChatInfo.SendChatMessage(ready_msg);
end

local after_time = nil;

local function updateAuras()
    if not IsInInstance() then
        return;
    end

    for _, spellId in pairs(lust_debuffs) do
        local aura = C_UnitAuras.GetPlayerAuraBySpellID(spellId)
        if aura then
            local lust_debuff_time = aura.expirationTime - GetTime();

            if lust_debuff_time < 1 and after_time == nil then              
                C_Timer.After(lust_debuff_time, alertMsg);
                after_time = lust_debuff_time;
            end
            return;
        end
    end

    after_time = nil;

end

local function isNeedtowork()
    local _, englishClass = UnitClass("player");
    if ns.options.ClassOnly then
        if lust_classes[englishClass] ~= true then
            return false;
        end
    end

    if (IsInGroup()) then
        if IsInRaid() then
            if ns.options.InRaid == false then
                return false;
            else
                return true;
            end
        end

        return true;
    end

    return false;
end

local timer = nil;

ns.checkStatus = function()
    if timer then
        timer:Cancel();
    end

    if isNeedtowork() then
        timer = C_Timer.NewTicker(refresh_rate, updateAuras);
    end
end


local bfirst = true;

local function OnEvent(self, event, ...)
    if bfirst then
        ns.SetupOptionPanels();
        bfirst = false;
    end
    ns.checkStatus();
end

local function OnInit()
    ABLA:SetScript("OnEvent", OnEvent);
    ABLA:RegisterEvent("PLAYER_ENTERING_WORLD");
    ABLA:RegisterEvent("GROUP_ROSTER_UPDATE");
end

OnInit();
