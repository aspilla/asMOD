local _, ns = ...;

local CONFIG_SOUND_SPEED = 1      -- 음성안내 읽기 속도
local ABLA = CreateFrame("FRAME", nil, UIParent);

local lust_debuffs = {
    57723,  --shaman (alliance)
    57724,  --shaman
    80354,  --mage
    264689, --hunter
    390435, --evoker
}

local lust_classes = {
    ["MAGE"] = true,
    ["SHAMAN"] = true,
    ["HUNTER"] = true,
    ["EVOKER"] = true,
}

local ready_msg = "Bloodlust ready";

if GetLocale() == "koKR" then
    ready_msg = "블러드 준비";
end

local lust_debuff_time = 0;

local function updateAuras()
    if not IsInInstance() then
        return;
    end

    for _, spellId in pairs(lust_debuffs) do
        local aura = C_UnitAuras.GetPlayerAuraBySpellID(spellId)
        if aura then
            lust_debuff_time = aura.expirationTime - GetTime();
            return;
        end
    end

    if lust_debuff_time > 0 and lust_debuff_time < 1 then
        if ns.options.VoiceAlert then
			PlaySoundFile("Interface\\AddOns\\asBloodlustAlert\\Ready.mp3", "MASTER")
        end
        SendChatMessage(ready_msg);
    end

    lust_debuff_time = 0;
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
        timer = C_Timer.NewTicker(0.5, updateAuras);
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
