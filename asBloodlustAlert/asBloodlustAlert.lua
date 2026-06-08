local _, ns        = ...;

local refresh_rate = 0.2;
local main_frame   = CreateFrame("FRAME", nil, UIParent);
local main_button  = CreateFrame("Button", nil, UIParent, "asBLAButtonTemplate");

local configs      = {
    font = STANDARD_TEXT_FONT,
    fontsize = 30,
    fontoutline = "THICKOUTLINE",
    xpoint = 0,
    ypoint = 100,
    button_xpoint = -285,
    button_ypoint = -305,
    button_size = 40,
    button_fontsize = 12,
    buff_id = 2825,
    buff_duration = 40,
};

local lust_debuffs = {
    57723,  --shaman (alliance)
    57724,  --shaman
    80354,  --mage
    264689, --hunter
    390435, --evoker
    --25771,  --test
}


local ready_msg    = "Bloodlust ready";
local start_msg    = "Bloodlust start";
local ready_sound  = "Ready.mp3";
local start_sound  = "Start.mp3";


if GetLocale() == "koKR" then
    ready_msg = "블러드 준비";
    start_msg = "블러드 시작";
    ready_sound = "Ready_kr.mp3";
    start_sound = "Start_kr.mp3";
end

local function set_cooldownframe(cooldown, durationobject, enable)
    if enable and durationobject then
        cooldown:SetDrawEdge(nil);
        cooldown:SetCooldownFromDurationObject(durationobject);
    else
        cooldown:Clear();
    end
end

local function hideMsg()
    ns.msgtext:Hide();
end

local function showstrMsg()
    ns.msgtext:Show();
    C_Timer.After(ns.options.ShowTime, hideMsg);
end

local function alert_ready()
    if ns.options.VoiceAlert then
        PlaySoundFile("Interface\\AddOns\\asBloodlustAlert\\" .. ready_sound, "MASTER")
    end
    ns.msgtext:SetText(ready_msg);
    showstrMsg();
end

local function alert_start()
    if ns.options.VoiceAlert then
        PlaySoundFile("Interface\\AddOns\\asBloodlustAlert\\" .. start_sound, "MASTER")
    end
    ns.msgtext:SetText(start_msg);
    showstrMsg();
end

local after_time = nil;
local start_time = nil;
local bfirst = true;
local bred = false;

local function update_auras()
    if bfirst then
        return;
    end

    if ns.msgtext:IsShown() then
        if bred then
            bred = false;
            ns.msgtext:SetTextColor(1, 1, 1);
        else
            bred = true;
            ns.msgtext:SetTextColor(1, 0, 0);
        end
    end

    for _, spellId in pairs(lust_debuffs) do
        local aura = C_UnitAuras.GetPlayerAuraBySpellID(spellId)
        if aura then
            local lust_debuff_time = aura.expirationTime - GetTime();

            if lust_debuff_time < 1 and after_time == nil and ns.options.ReadyAlert then
                C_Timer.After(lust_debuff_time, alert_ready);
                after_time = lust_debuff_time;
            end

            if lust_debuff_time > 590 and start_time == nil and ns.options.StartAlert then
                alert_start();
                start_time = aura.expirationTime - aura.duration;
            end

            if start_time and GetTime() - start_time < configs.buff_duration and ns.options.ShowBuff then
                main_button:Show();
                local durationobj = C_DurationUtil.CreateDuration();
                durationobj:SetTimeFromStart(start_time, configs.buff_duration);
                set_cooldownframe(main_button.cooldown, durationobj, true);
                ns.lib.ButtonGlow_Start(main_button);
            else
                main_button:Hide();
            end

            return;
        end
    end

    main_button:Hide();
    after_time = nil;
    start_time = nil;
end

local function OnEvent(self, event, ...)
    if bfirst then
        ns.SetupOptionPanels();
        bfirst = false;

        local libasConfig = LibStub:GetLibrary("LibasConfig", true);

        if libasConfig then
            libasConfig.load_position(main_frame, "asBloodlustAlert", ABLA_Positions);
            libasConfig.load_position(main_button, "asBloodlustAlert (Buff)", ABLA_Positions2);
        end

        ns.msgtext:SetFont(configs.font, ns.options.FontSize, configs.fontoutline)
        C_Timer.NewTicker(refresh_rate, update_auras);
    end
    
end

local function OnInit()
    ns.msgtext = main_frame:CreateFontString(nil, "OVERLAY");
    ns.msgtext:SetFont(configs.font, configs.fontsize, configs.fontoutline)
    ns.msgtext:SetPoint("CENTER", main_frame, "CENTER", 0, 0);

    ns.msgtext:Hide();

    main_frame:SetPoint("CENTER", UIParent, "CENTER", configs.xpoint, configs.ypoint);
    main_frame:SetSize(100, 50);
    main_frame:Show();

    main_frame:SetScript("OnEvent", OnEvent);
    main_frame:RegisterEvent("PLAYER_ENTERING_WORLD");
    main_frame:RegisterEvent("GROUP_ROSTER_UPDATE");


    main_button:SetFrameStrata("LOW");
    main_button:EnableMouse(false);
    main_button.cooldown:SetHideCountdownNumbers(false);
    main_button.cooldown:SetDrawSwipe(true);

    if ns.options.MillisecondsThreshold then
        main_button.cooldown:SetCountdownMillisecondsThreshold(ns.options.MillisecondsThreshold);
    end

    for _, r in next, { main_button.cooldown:GetRegions() } do
        if r:GetObjectType() == "FontString" then
            r:SetFont(STANDARD_TEXT_FONT, configs.button_fontsize, "OUTLINE");
            r:SetDrawLayer("OVERLAY");
            break
        end
    end

    main_button.icon:SetTexCoord(.08, .92, .08, .92);
    main_button.border:SetTexCoord(0.08, 0.08, 0.08, 0.92, 0.92, 0.08, 0.92, 0.92);
    main_button.border:SetVertexColor(0, 0, 0);

    main_button:SetPoint("CENTER", configs.button_xpoint, configs.button_ypoint)
    main_button:SetWidth(configs.button_size);
    main_button:SetHeight(configs.button_size * 0.9);

    local spellInfo = C_Spell.GetSpellInfo(configs.buff_id);

    if spellInfo then
        main_button.icon:SetTexture(spellInfo.iconID);
    end    
end

OnInit();
