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
local CONFIG_NOT_INTERRUPTIBLE_COLOR_TARGET = { 153 / 255, 0, 76 / 255 }; --차단 불가시 (내가 타겟일때) 색상 (r, g, b)
local CONFIG_INTERRUPTIBLE_COLOR = { 204 / 255, 255 / 255, 153 / 255 };   --차단 가능(내가 타겟이 아닐때)시 색상 (r, g, b)
local CONFIG_INTERRUPTIBLE_COLOR_TARGET = { 76 / 255, 153 / 255, 0 };     --차단 가능(내가 타겟일 때)시 색상 (r, g, b)
local CONFIG_FAILED_COLOR = { 1, 0, 0 };                                  --cast fail

local ATCB_UPDATE_RATE = 0.05                                             -- 20프레임

local DangerousSpellList = {

}

-----------------설정 끝------------------------
local CONFIG_FONT = STANDARD_TEXT_FONT;
local region = GetCurrentRegion();

if region == 2 and GetLocale() ~= "koKR" then
    CONFIG_FONT = "Fonts\\2002.ttf";
end

local ATCB = CreateFrame("FRAME", nil, UIParent)
ATCB:SetPoint("BOTTOM", UIParent, "BOTTOM", 0, 0)
ATCB:SetWidth(0)
ATCB:SetHeight(0)
ATCB:Show();

local function setupCastBar()
    local frame = CreateFrame("StatusBar", nil, UIParent)
    frame:SetStatusBarTexture("Interface\\addons\\asTargetCastBar\\UI-StatusBar")
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

    if not frame:GetScript("OnEnter") then
        frame:SetScript("OnEnter", function(s)
            if s.castspellid and s.castspellid > 0 then
                GameTooltip_SetDefaultAnchor(GameTooltip, s);
                GameTooltip:SetSpellByID(s.castspellid);
            end
        end)
        frame:SetScript("OnLeave", function()
            GameTooltip:Hide();
        end)
    end

    frame:EnableMouse(false);
    frame:SetMouseMotionEnabled(true);
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

    frame.start = 0;
    frame.duration = 0;
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
local MaxLevel = GetMaxLevelForExpansionLevel(10);

local function hideCastBar(castBar)
    local targetname   = castBar.targetname;
    castBar:SetValue(0);
    castBar:Hide();
    ns.lib.PixelGlow_Stop(castBar);
    castBar.isAlert = false;
    castBar.start = 0;
    targetname:SetText("");
    targetname:Hide();
    castBar.failstart = nil;
end

local function checkCasting(castBar, event)
    local unit         = castBar.unit;
    local frameIcon    = castBar.button.icon;
    local text         = castBar.name;
    local time         = castBar.time;
    local targetname   = castBar.targetname;
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

        if event == "UNIT_SPELLCAST_INTERRUPTED" or event == "UNIT_SPELLCAST_FAILED" then
            castBar:SetMinMaxValues(0, 100);
            castBar:SetValue(100);
            local failtext = "Interrupted"
            local color = CONFIG_FAILED_COLOR;

            if event == "UNIT_SPELLCAST_FAILED" then
                failtext = "Failed"
            end

            time:SetText(failtext);
            castBar:SetStatusBarColor(color[1], color[2], color[3]);
            castBar.failstart = currtime;
            castBar:Show();
        elseif name then
            local current = GetTime();
            frameIcon:SetTexture(texture);

            castBar.start = start / 1000;
            castBar.duration = (endTime - start) / 1000;
            castBar.bchannel = bchannel;
            castBar:SetMinMaxValues(0, castBar.duration)
            castBar.failstart = nil;

            if bchannel then
                castBar:SetValue(castBar.start + castBar.duration - current);
            else
                castBar:SetValue(current - castBar.start);
            end

            local color = {};

            if UnitIsUnit(targettarget, "player") then
                if notInterruptible then
                    color = CONFIG_NOT_INTERRUPTIBLE_COLOR_TARGET;
                else
                    color = CONFIG_INTERRUPTIBLE_COLOR_TARGET;
                end
            else
                if notInterruptible then
                    color = CONFIG_NOT_INTERRUPTIBLE_COLOR;
                else
                    color = CONFIG_INTERRUPTIBLE_COLOR;
                end
            end

            castBar.castspellid = spellid;

            castBar:SetStatusBarColor(color[1], color[2], color[3]);

            text:SetText(name);
            time:SetText(format("%.1f/%.1f", max((current - castBar.start), 0), max(castBar.duration, 0)));

            frameIcon:Show();
            castBar:Show();
            local level = UnitLevel(unit);
            local isBoss = false;

            if level < 0 or level > MaxLevel then
                isBoss = true;
            end
            if DangerousSpellList[spellid] and DangerousSpellList[spellid] == "interrupt" and (isBoss == false or notInterruptible == false) then
                if not castBar.isAlert then
                    ns.lib.PixelGlow_Start(castBar, { 1, 1, 0, 1 });
                    castBar.isAlert = true;
                end
            end

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
        else
            if castBar.failstart == nil then
                hideCastBar(castBar);
            end
        end
    else
        hideCastBar(castBar);
    end
end

local function registerEvents(frame, unit)
    if not frame then
        return;
    end

    if not UnitExists(unit) then
        frame:Hide()
        return;
    end

    if unit == "focus" then
        if not ns.options.ShowFocus then
            return;
        end
    end

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
    frame.failstart = nil;


    checkCasting(frame, "NOTHING");
end

local function on_unit_event(self, event, ...)
    checkCasting(self, event);
end

ATCB.targetCastBar:SetScript("OnEvent", on_unit_event);
ATCB.focusCastBar:SetScript("OnEvent", on_unit_event);

local function ATCB_OnEvent(self, event, ...)
    if event == "PLAYER_TARGET_CHANGED" then
        registerEvents(ATCB.targetCastBar, "target");
    elseif event == "PLAYER_FOCUS_CHANGED" then
        registerEvents(ATCB.focusCastBar, "focus");
    elseif event == "PLAYER_ENTERING_WORLD" then
        registerEvents(ATCB.targetCastBar, "target");
        registerEvents(ATCB.focusCastBar, "focus");
    elseif event == "ADDON_LOADED" then
        local name = ...;

        if name == "asTargetCastBar" then
            ns.SetupOptionPanels();
        end
    end
end


local function updateCastBar(castBar)
    local start = castBar.start;
    local duration = castBar.duration;
    local failstart = castBar.failstart;
    local current = GetTime();

    if failstart then
        if current - failstart > 0.5 then
            hideCastBar(castBar);
        end
    elseif start > 0 and start + duration >= current then
        local bchannel = castBar.bchannel;
        local time = castBar.time;
        if bchannel then
            castBar:SetValue((start + duration - current));
            time:SetText(format("%.1f/%.1f", max((start + duration - current), 0), max(duration, 0)));
        else
            castBar:SetValue((current - start));
            time:SetText(format("%.1f/%.1f", max((current - start), 0), max(duration, 0)));
        end
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

local function NewMod(self, ...)
    DBMobj = self;
    C_Timer.After(2, scanDBM);
end

local bloaded = C_AddOns.LoadAddOn("DBM-Core");
if bloaded then
    hooksecurefunc(DBM, "NewMod", NewMod)
end
