local _, ns = ...;
-----------------설정 ------------------------
local ATCB_WIDTH = 180
local ATCB_HEIGHT = 17
local ATCB_X = 0;
local ATCB_Y = -100;
local ATCB_ALPHA = 0.8;                                                   --투명도 80%
local ATCB_NAME_SIZE = ATCB_HEIGHT * 0.7;                                 --Spell 명 Font Size, 높이의 70%
local ATCB_TIME_SIZE = ATCB_HEIGHT * 0.5;                                 --Spell 시전시간 Font Size, 높이의 50%
local CONFIG_NOT_INTERRUPTIBLE_COLOR = { 0.9, 0.9, 0.9 };                 --차단 불가시 (내가 아닐때) 색상 (r, g, b)
local CONFIG_INTERRUPTIBLE_COLOR = { 204 / 255, 255 / 255, 153 / 255 };   --차단 가능(내가 타겟이 아닐때)시 색상 (r, g, b)
local CONFIG_FAILED_COLOR = { 1, 0, 0 };                                  --cast fail
local ATCB_UPDATE_RATE = 0.05                                             -- 20프레임

-----------------설정 끝------------------------
local CONFIG_FONT = STANDARD_TEXT_FONT;
local region = GetCurrentRegion();

if region == 2 and GetLocale() ~= "koKR" then
    CONFIG_FONT = "Fonts\\2002.ttf";
end

local CONFIG_VOICE_TARGET_KICK = "Interface\\AddOns\\asTargetCastBar\\Target_Kick_En.mp3"
local CONFIG_VOICE_TARGET_STUN = "Interface\\AddOns\\asTargetCastBar\\Target_Stun_En.mp3"
local CONFIG_VOICE_FOCUS_KICK = "Interface\\AddOns\\asTargetCastBar\\Focus_Kick_En.mp3"
local CONFIG_VOICE_FOCUS_STUN = "Interface\\AddOns\\asTargetCastBar\\Focus_Stun_En.mp3"

if GetLocale() == "koKR" then
    CONFIG_VOICE_TARGET_KICK = "Interface\\AddOns\\asTargetCastBar\\Target_Kick.mp3"
    CONFIG_VOICE_TARGET_STUN = "Interface\\AddOns\\asTargetCastBar\\Target_Stun.mp3"
    CONFIG_VOICE_FOCUS_KICK = "Interface\\AddOns\\asTargetCastBar\\Focus_Kick.mp3"
    CONFIG_VOICE_FOCUS_STUN = "Interface\\AddOns\\asTargetCastBar\\Focus_Stun.mp3"
end

local ATCB = CreateFrame("FRAME", nil, UIParent)
ATCB:SetPoint("BOTTOM", UIParent, "BOTTOM", 0, 0)
ATCB:SetWidth(0)
ATCB:SetHeight(0)
ATCB:Show();

local function setupCastBar()
    local frame = CreateFrame("StatusBar", nil, UIParent)
    frame:SetStatusBarTexture("RaidFrame-Hp-Fill")
    frame:GetStatusBarTexture():SetHorizTile(false)
    frame:SetMinMaxValues(0, 100)
    frame:SetValue(100)
    frame:SetHeight(ATCB_HEIGHT)
    frame:SetWidth(ATCB_WIDTH - (ATCB_HEIGHT + 2) * 1.2)
    frame:SetStatusBarColor(1, 0.9, 0.9);
    frame:SetAlpha(ATCB_ALPHA);

    frame.bg = frame:CreateTexture(nil, "BACKGROUND")
    frame.bg:SetPoint("TOPLEFT", frame, "TOPLEFT", -1, 1)
    frame.bg:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", 1, -1)

    frame.bg:SetTexture("Interface\\Addons\\asTargetCastBar\\border.tga")
    frame.bg:SetTexCoord(0.1, 0.1, 0.1, 0.1, 0.1, 0.1, 0.1, 0.1)
    frame.bg:SetVertexColor(0, 0, 0, 0.8);
    frame.bg:Show();

    frame.name = frame:CreateFontString(nil, "OVERLAY");
    frame.name:SetFont(STANDARD_TEXT_FONT, ATCB_NAME_SIZE);
    frame.name:SetPoint("LEFT", frame, "LEFT", 3, 0);

    frame.time = frame:CreateFontString(nil, "OVERLAY");
    frame.time:SetFont(STANDARD_TEXT_FONT, ATCB_TIME_SIZE);
    frame.time:SetPoint("RIGHT", frame, "RIGHT", -3, 0);

    frame:EnableMouse(false);
    frame.isAlert = false;
    frame:Hide();

    frame.button = CreateFrame("Button", nil, frame, "ATCBFrameTemplate");
    frame.button:SetPoint("RIGHT", frame, "LEFT", -1, 0)
    frame.button:SetWidth((ATCB_HEIGHT + 2) * 1.2);
    frame.button:SetHeight(ATCB_HEIGHT + 2);
    frame.button:SetScale(1);
    frame.button:SetAlpha(1);
    frame.button:EnableMouse(false);
    frame.button.icon:SetTexCoord(.08, .92, .16, .84);
    frame.button.border:SetTexCoord(0.08, 0.08, 0.08, 0.92, 0.92, 0.08, 0.92, 0.92);
    frame.button.border:SetVertexColor(0, 0, 0);
    frame.button.border:Show();
    frame.button:Show();

    frame.targetname = frame:CreateFontString(nil, "OVERLAY");
    frame.targetname:SetFont(CONFIG_FONT, ATCB_NAME_SIZE);
    frame.targetname:SetPoint("TOPRIGHT", frame, "BOTTOMRIGHT", 0, -2);

    frame.mark = frame:CreateFontString(nil, "OVERLAY");
    frame.mark:SetFont(STANDARD_TEXT_FONT, ATCB_NAME_SIZE + 3);
    frame.mark:SetPoint("RIGHT", frame.button, "LEFT", -1, 0);
    frame.mark:Show();
    frame.start = 0;
    frame.duration = 0;
    frame.soundalerted = false;
    return frame;
end
ATCB.targetCastBar = setupCastBar();
ATCB.targetCastBar:SetPoint("CENTER", UIParent, "CENTER", ATCB_X + ((ATCB_HEIGHT + 2) * 1.2) / 2, ATCB_Y)
ATCB.focusCastBar = setupCastBar();
ATCB.focusCastBar:SetPoint("CENTER", UIParent, "CENTER", ATCB_X + ((ATCB_HEIGHT + 2) * 1.2) / 2, ATCB_Y + 150)
ns.focusCastBar = ATCB.focusCastBar;


C_AddOns.LoadAddOn("asMOD");

if asMOD_setupFrame then
    asMOD_setupFrame(ATCB.targetCastBar, "asTargetCastBar (Target)");
    asMOD_setupFrame(ATCB.focusCastBar, "asTargetCastBar (Focus)");
end

local function hideCastBar(castBar)
    local targetname = castBar.targetname;
    castBar:SetValue(0);
    castBar:Hide();
    ns.lib.PixelGlow_Stop(castBar);
    castBar.isAlert = false;
    castBar.start = 0;
    targetname:SetText("");
    targetname:Hide();
    castBar.failstart = nil;
    castBar.soundalerted = false;
end

local RaidIconList = {
    "|TInterface\\TargetingFrame\\UI-RaidTargetingIcon_1:",
    "|TInterface\\TargetingFrame\\UI-RaidTargetingIcon_2:",
    "|TInterface\\TargetingFrame\\UI-RaidTargetingIcon_3:",
    "|TInterface\\TargetingFrame\\UI-RaidTargetingIcon_4:",
    "|TInterface\\TargetingFrame\\UI-RaidTargetingIcon_5:",
    "|TInterface\\TargetingFrame\\UI-RaidTargetingIcon_6:",
    "|TInterface\\TargetingFrame\\UI-RaidTargetingIcon_7:",
    "|TInterface\\TargetingFrame\\UI-RaidTargetingIcon_8:",
}


local function DisplayRaidIcon(unit)
    local icon = GetRaidTargetIndex(unit);
    --[[
    if icon and RaidIconList[icon] then
        return RaidIconList[icon] .. "0|t"
    else
        return ""
    end
    ]]
end

local function get_typeofcast(unit)
    local nameplate = C_NamePlate.GetNamePlateForUnit(unit, issecure())
    if nameplate and nameplate.UnitFrame and nameplate.UnitFrame.castBar then
        return nameplate.UnitFrame.castBar.barType;
    end
    return nil;
end

local function checkCasting(castBar, event)
    local unit         = castBar.unit;
    local frameIcon    = castBar.button.icon;
    local text         = castBar.name;
    local time         = castBar.time;
    local targetname   = castBar.targetname;
    local mark         = castBar.mark;
    local targettarget = unit .. "target";
    local currtime     = GetTime();

    if UnitExists(unit) then
        local bchannel = false;
        local name, _, texture, start, endTime, isTradeSkill, castID, notInterruptible, spellid = UnitCastingInfo(
            unit);

        if not name then
            name, _, texture, start, endTime, isTradeSkill, notInterruptible, spellid = UnitChannelInfo(unit);
            bchannel = true;
        end

        if event == "UNIT_SPELLCAST_INTERRUPTED" then
            castBar:SetMinMaxValues(0, 100);
            castBar:SetValue(100);
            local failtext = "Interrupted"
            local color = CONFIG_FAILED_COLOR;

            time:SetText(failtext);
            castBar:SetStatusBarColor(color[1], color[2], color[3]);
            castBar.failstart = currtime;            
            castBar:SetStatusBarDesaturated(false);
            castBar:Show();
        elseif name then
            local current = GetTime();
            frameIcon:SetTexture(texture);
            castBar:SetReverseFill(bchannel);

            castBar:SetMinMaxValues(start, endTime)
            castBar.failstart = nil;

            local color = {};


            color = CONFIG_INTERRUPTIBLE_COLOR;
            local type = get_typeofcast(unit);

            if type then
                if type == "uninterruptable" then
                    color = CONFIG_NOT_INTERRUPTIBLE_COLOR;
                elseif type == "empowered" then
                    if not castBar.isAlert then
                        ns.lib.PixelGlow_Start(castBar, { 1, 1, 0, 1 });
                        castBar.isAlert = true;
                    end
                end
            end
            castBar:SetStatusBarColor(color[1], color[2], color[3]);
            text:SetText(name);
            mark:SetText(DisplayRaidIcon(unit));
            frameIcon:Show();
            castBar:Show();

            if UnitExists(targettarget) then
                local _, Class = UnitClass(targettarget)
                if Class then
                    local classcolor = RAID_CLASS_COLORS[Class]
                    if classcolor then
                        targetname:SetTextColor(classcolor.r, classcolor.g, classcolor.b);
                        targetname:SetText(UnitName("targettarget"));
                        targetname:Show();
                    end
                end
            else
                targetname:SetText("");
                targetname:Hide();
            end


            if name and castBar.soundalerted == false then
                local isfocus = UnitIsUnit(unit, "focus");
                local soundfile = nil;

                if type == "uninterruptable" then
                    if ns.options.PlaySoundStun then
                        local stunable = UnitLevel(unit) <= UnitLevel("player");
                        if stunable then
                            if isfocus then
                                soundfile = CONFIG_VOICE_FOCUS_STUN
                            else
                                soundfile = CONFIG_VOICE_TARGET_STUN;
                            end
                        end
                    end
                else
                    if ns.options.PlaySoundKick then
                        if isfocus then
                            soundfile = CONFIG_VOICE_FOCUS_KICK
                        else
                            soundfile = CONFIG_VOICE_TARGET_KICK;
                        end
                    end
                end

                if soundfile then
                    castBar.soundalerted = true;
                    PlaySoundFile(soundfile, "MASTER");
                end
            end
        else
            if castBar.failstart == nil then
                hideCastBar(castBar);
            end
        end
    else
        hideCastBar(castBar);
    end
end

local function checkUnit(frame, unit)
    if not frame then
        return;
    end

    if not UnitExists(unit) then
        hideCastBar(frame);
        return;
    end

    if unit == "focus" then
        if not ns.options.ShowFocus then
            return;
        end
    end

    frame.failstart = nil;


    checkCasting(frame, "NOTHING");
end


local function registerUnit(frame, unit)
    frame.unit = unit;
    frame:RegisterUnitEvent("UNIT_SPELLCAST_INTERRUPTED", unit);
    frame:RegisterUnitEvent("UNIT_SPELLCAST_DELAYED", unit);
    frame:RegisterUnitEvent("UNIT_SPELLCAST_CHANNEL_START", unit);
    frame:RegisterUnitEvent("UNIT_SPELLCAST_CHANNEL_UPDATE", unit);
    frame:RegisterUnitEvent("UNIT_SPELLCAST_CHANNEL_STOP", unit);
    frame:RegisterUnitEvent("UNIT_SPELLCAST_EMPOWER_START", unit);
    frame:RegisterUnitEvent("UNIT_SPELLCAST_EMPOWER_UPDATE", unit);
    frame:RegisterUnitEvent("UNIT_SPELLCAST_EMPOWER_STOP", unit);
    frame:RegisterUnitEvent("UNIT_SPELLCAST_INTERRUPTIBLE", unit);
    frame:RegisterUnitEvent("UNIT_SPELLCAST_NOT_INTERRUPTIBLE", unit);
    frame:RegisterUnitEvent("UNIT_SPELLCAST_START", unit);
    frame:RegisterUnitEvent("UNIT_SPELLCAST_STOP", unit);
    frame:RegisterUnitEvent("UNIT_SPELLCAST_FAILED", unit);
    frame:RegisterUnitEvent("UNIT_TARGET", unit);
end

local function on_unit_event(self, event, ...)
    checkCasting(self, event);
end

ATCB.targetCastBar:SetScript("OnEvent", on_unit_event);
registerUnit(ATCB.targetCastBar, "target");
ATCB.focusCastBar:SetScript("OnEvent", on_unit_event);
registerUnit(ATCB.focusCastBar, "focus");

local function ATCB_OnEvent(self, event, ...)
    if event == "PLAYER_TARGET_CHANGED" then
        ATCB.targetCastBar.soundalerted = nil;
        checkUnit(ATCB.targetCastBar, "target");
    elseif event == "PLAYER_FOCUS_CHANGED" then
        ATCB.focusCastBar.soundalerted = nil;
        checkUnit(ATCB.focusCastBar, "focus");
    elseif event == "PLAYER_ENTERING_WORLD" then
        checkUnit(ATCB.targetCastBar, "target");
        checkUnit(ATCB.focusCastBar, "focus");
    elseif event == "ADDON_LOADED" then
        local name = ...;

        if name == "asTargetCastBar" then
            ns.SetupOptionPanels();
        end
    end
end


local function updateCastBar(castBar)
    local failstart = castBar.failstart;
    local current = GetTime();

    if failstart then
        if current - failstart > 0.5 then
            hideCastBar(castBar);
        end
    else
        castBar.time:SetText("");
        castBar:SetValue(current * 1000, Enum.StatusBarInterpolation.ExponentialEaseOut);
    end
end

local function ATCB_OnUpdate()
    updateCastBar(ATCB.targetCastBar);
    updateCastBar(ATCB.focusCastBar);
end

ATCB:SetScript("OnEvent", ATCB_OnEvent)
ATCB:RegisterEvent("PLAYER_TARGET_CHANGED");
ATCB:RegisterEvent("PLAYER_FOCUS_CHANGED");
ATCB:RegisterEvent("ADDON_LOADED");
ATCB:RegisterEvent("PLAYER_ENTERING_WORLD");

C_Timer.NewTicker(ATCB_UPDATE_RATE, ATCB_OnUpdate);
