local _, ns        = ...;

local refresh_rate = 0.5;
local main_frame   = CreateFrame("FRAME", nil, UIParent);

local configs      = {
    font = STANDARD_TEXT_FONT,
    fontsize = 30,
    fontoutline = "THICKOUTLINE",
    xpoint = 0,
    ypoint = 100,    
};

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
local mp3_file = "Ready.mp3";


if GetLocale() == "koKR" then
    ready_msg = "블러드 준비";
    mp3_file = "Ready_kr.mp3";
end

local function hideMsg()
    ns.msgtext:Hide();
end

local function showstrMsg()
    ns.msgtext:Show();
    C_Timer.After(ns.options.ShowTime, hideMsg);
end

local function alertMsg()
    if not IsInInstance() then
        --return;
    end
    if ns.options.VoiceAlert then
        PlaySoundFile("Interface\\AddOns\\asBloodlustAlert\\".. mp3_file, "MASTER")
    end
    showstrMsg();
end

local after_time = nil;
local bfirst = true;
local bred = false;

local function updateAuras()
    if not IsInInstance() then
        return;
    end

    if bfirst then
        return;
    end

    if ns.msgtext:IsShown() then
        if bred then
            bred = false;
            ns.msgtext:SetTextColor(1,1,1);
        else
            bred = true;
            ns.msgtext:SetTextColor(1, 0, 0);
        end
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

local function OnEvent(self, event, ...)
    if bfirst then
        ns.SetupOptionPanels();
        bfirst = false;

        local libasConfig = LibStub:GetLibrary("LibasConfig", true);

        if libasConfig then
            libasConfig.load_position(main_frame, "asBloodlustAlert", ABLA_Positions);
        end

        ns.msgtext:SetFont(configs.font, ns.options.FontSize, configs.fontoutline)
    end
    ns.checkStatus();
end

local function OnInit()

    ns.msgtext = main_frame:CreateFontString(nil, "OVERLAY");
    ns.msgtext:SetFont(configs.font, configs.fontsize, configs.fontoutline)
    ns.msgtext:SetPoint("CENTER", main_frame, "CENTER", 0, 0);
    ns.msgtext:SetText(ready_msg);
    ns.msgtext:Hide();

    main_frame:SetPoint("CENTER", UIParent, "CENTER", configs.xpoint, configs.ypoint);
    main_frame:SetSize(100, 50);
    main_frame:Show();

    main_frame:SetScript("OnEvent", OnEvent);
    main_frame:RegisterEvent("PLAYER_ENTERING_WORLD");
    main_frame:RegisterEvent("GROUP_ROSTER_UPDATE");

    --alertMsg();
end

OnInit();
