local CONFIG_X = -138;
local CONFIG_Y = -80;
local CONFIG_SIZE = 28;
local CONFIG_COUNT_SIZE = 14;
local CONFIG_COOLDOWN_SIZE = 12;


local ast_frame = CreateFrame("Frame", "AsTrackSummonsFrame", UIParent)

ast_frame:SetSize(CONFIG_SIZE, CONFIG_SIZE * 0.8)                    -- Changed size to be more compact
ast_frame:SetPoint("BOTTOM", UIParent, "CENTER", CONFIG_X, CONFIG_Y) -- Repositioned to the left

-- Create 10 vertical bars
local bars = {};
local buttons = {};
for i = 1, 10 do
    local bar = CreateFrame("StatusBar", "AsTrackSummonsBar" .. i, ast_frame)
    bar:SetStatusBarTexture("Interface\\addons\\asTrackSummons\\UI-StatusBar");
    bar:GetStatusBarTexture():SetHorizTile(false)
    bar:SetMinMaxValues(0, 100)
    bar:SetValue(100)
    bar:SetHeight(50)
    bar:SetWidth(20)
    bar:SetStatusBarColor(1, 0.9, 0.9);
    bar:SetAlpha(1);
    bar:SetOrientation("VERTICAL")

    bar.bg = bar:CreateTexture(nil, "BACKGROUND")
    bar.bg:SetPoint("TOPLEFT", bar, "TOPLEFT", -1, 1)
    bar.bg:SetPoint("BOTTOMRIGHT", bar, "BOTTOMRIGHT", 1, -1)

    bar.bg:SetTexture("Interface\\Addons\\asTrackSummons\\border.tga")
    bar.bg:SetTexCoord(0.1, 0.1, 0.1, 0.1, 0.1, 0.1, 0.1, 0.1)
    bar.bg:SetVertexColor(0, 0, 0, 0.8);
    bar.count = bar:CreateFontString(nil, "OVERLAY");
    bar.count:SetFont(STANDARD_TEXT_FONT, CONFIG_COOLDOWN_SIZE);
    bar.count:SetPoint("BOTTOM", bar, "BOTTOM", 0, 1);

    bar.time = bar:CreateFontString(nil, "OVERLAY");
    bar.time:SetFont(STANDARD_TEXT_FONT, CONFIG_COOLDOWN_SIZE);
    bar.time:SetPoint("TOP", bar, "BOTTOM", 0, -1);
    bar:Hide();
    tinsert(bars, bar);

    local button = CreateFrame("Button", nil, ast_frame, "asSUMMONTTemplate");
    button:SetWidth(28);
    button:SetHeight(28 * 0.8);
    button:SetScale(1);
    button:SetAlpha(1);
    button:EnableMouse(false);
    button.icon:SetTexCoord(.08, .92, .16, .84);
    button.count:SetFont(STANDARD_TEXT_FONT, CONFIG_COUNT_SIZE, "OUTLINE")
    button.count:SetTextColor(1, 1, 1);
    button.count:ClearAllPoints()
    button.count:SetPoint("CENTER", button.icon, "CENTER", 0, 0);
    button.border:SetTexCoord(0.08, 0.08, 0.08, 0.92, 0.92, 0.08, 0.92, 0.92);
    button.border:SetVertexColor(0, 0, 0);
    button.cooldown:SetDrawSwipe(true);
    button.cooldown:SetHideCountdownNumbers(false);

    for _, r in next, { button.cooldown:GetRegions() } do
        if r:GetObjectType() == "FontString" then
            r:SetFont(STANDARD_TEXT_FONT, CONFIG_COOLDOWN_SIZE, "OUTLINE");
            r:ClearAllPoints();
            r:SetPoint("TOP", 0, 5);
            r:SetDrawLayer("OVERLAY");
            break;
        end
    end
    if not button:GetScript("OnEnter") then
        button:SetScript("OnEnter", function(s)
            if s.spellId and s.spellId > 0 then
                GameTooltip_SetDefaultAnchor(GameTooltip, s);
                GameTooltip:SetSpellByID(s.spellId);
            end
        end)
        button:SetScript("OnLeave", function()
            GameTooltip:Hide();
        end)
    end
    if i == 1 then
        bar:SetPoint("BOTTOM", ast_frame, "BOTTOM", 0, 0)
        button:SetPoint("BOTTOM", ast_frame, "BOTTOM", 0, 0)
    else
        bar:SetPoint("BOTTOMRIGHT", bars[i - 1], "BOTTOMLEFT", -1, 0)       -- Spaced out vertically
        button:SetPoint("BOTTOMRIGHT", buttons[i - 1], "BOTTOMLEFT", -1, 0) -- Spaced out vertically
    end

    button.data = {};

    button:Hide();

    tinsert(buttons, button);
end

C_AddOns.LoadAddOn("asMOD");

if asMOD_setupFrame then
    asMOD_setupFrame(ast_frame, "asSummonTracker");
end
local playerGUID = UnitGUID("player");

local summons = {};
local summon_spelllist = {

    [444251] = 10,
    [444252] = 10,
    [444254] = 10,
    [444248] = 10,

}
local summon_colorlist = {

    [444251] = { 1, 1, 1 },
    [444252] = { 1, 0, 0 },
    [444254] = { 0, 1, 0 },
    [444248] = { 0, 0, 1 },

}

local showtype = 0;

local function asCooldownFrame_Clear(self)
    self:Clear();
end

local function asCooldownFrame_Set(self, start, duration, enable, forceShowDrawEdge, modRate)
    if enable and enable ~= 0 and start > 0 and duration > 0 then
        self:SetDrawEdge(forceShowDrawEdge);
        self:SetCooldown(start, duration, modRate);
    else
        asCooldownFrame_Clear(self);
    end
end

local function set_button(button, spellId, count, start, duration)
    local data = button.data;

    if spellId ~= data.spellId then
        data.spellId = spellId;
        local spellinfo = C_Spell.GetSpellInfo(spellId);


        if spellinfo then
            button.icon:SetTexture(spellinfo.iconID);
            button.spellId = spellId;
        end
    end

    if count and count ~= data.count then
        data.count = count;
        if count > 0 then
            button.count:SetText(count);
            button.count:Show();
        else
            button.count:Hide();
        end
    end

    if start and duration and (start ~= data.start or duration ~= data.duration) then
        data.start = start;
        data.duration = duration;

        asCooldownFrame_Set(button.cooldown, start, duration, duration > 0, true);
    end
end



local function onupdate()
    local count = 0;
    local currentTime = GetTime();

    for idx, v in pairs(summons) do
        local timestamp = v[1];
        local duration = v[5];

        if currentTime - timestamp >= duration then
            table.remove(summons, idx);
        else
            count = count + 1;
        end
    end

    if showtype == 1 then
        --count only
        if count > 0 then
            local spellId = summons[1][2];

            local button = buttons[1];
            set_button(button, spellId, count);
            button:Show();
            for i = 2, 10 do
                buttons[i]:Hide();
            end
        else
            for i = 1, 10 do
                buttons[i]:Hide();
            end
        end
    elseif showtype == 2 then
        --icons
        for i = 1, 10 do
            if i <= count then
                local button = buttons[i];
                local idx = count - i + 1;
                local spellId = summons[idx][2];
                local start = summons[idx][1];
                local duration = summons[idx][5];

                set_button(button, spellId, nil, start, duration);
                button:Show();
            else
                buttons[i]:Hide()
            end
        end
    elseif showtype == 3 then
        --bars
        for i = 1, 10 do
            if i <= count then
                bars[i]:Show()
                local duration = summons[i][5];
                local remaining = duration - (currentTime - summons[i][1])
                local spellcolor = summon_colorlist[summons[i][2]];
                bars[i]:SetMinMaxValues(0, duration * 100)
                bars[i]:SetValue(remaining * 100)
                bars[i].time:SetText(math.ceil(remaining));
                if summons[i][3] > 1 then
                    bars[i].count:SetText(summons[i][3]);
                    bars[i].count:Show();
                else
                    bars[i].count:Hide();
                end
                if spellcolor then
                    bars[i]:SetStatusBarColor(spellcolor[1], spellcolor[2], spellcolor[3]);
                else
                    bars[i]:SetStatusBarColor(1, 0.9, 0.9);
                end
            else
                bars[i]:Hide()
            end
        end
    end
end

local callfunc = nil;
local direbeast_duration = 8;
local direbeast_spells = {
    [132764] = true,
    [122804] = true,
}

local function direbeast()
    local timestamp, eventType, _, sourceGUID, _, _, _, destGUID, _, _, _, spellId, _, _, auraType, amount =
        CombatLogGetCurrentEventInfo();


    if sourceGUID and sourceGUID == playerGUID then
        if eventType == "SPELL_CAST_SUCCESS" and direbeast_spells[spellId] then
            local currentTime = GetTime();
            table.insert(summons, 1, { currentTime, spellId, 1, timestamp, direbeast_duration });
            --elseif eventType == "SPELL_SUMMON" and spellId == 104317 then
        end
    end
end

local apo_time = nil;
local apo_spells =
{
    [279302] = true,
    [42650] = true,
    [383269] = true,
    [455395] = true,
}
local function four_knights()
    local timestamp, eventType, _, sourceGUID, _, _, _, destGUID, _, _, _, spellId, _, _, auraType, amount =
        CombatLogGetCurrentEventInfo();


    if sourceGUID and sourceGUID == playerGUID then
        if eventType == "SPELL_CAST_SUCCESS" and apo_spells[spellId] then
            local currentTime = GetTime();
            apo_time = timestamp;
            --elseif eventType == "SPELL_SUMMON" and spellId == 104317 then
            for idx, v in pairs(summons) do
                local start = v[1];
                local duration = v[5];

                if currentTime <= (start + duration) then
                    summons[idx][1] = currentTime;
                    summons[idx][4] = timestamp;
                    summons[idx][5] = 20;
                end
            end
        elseif eventType == "SPELL_SUMMON" and summon_spelllist[spellId] then
            local currentTime = GetTime();
            local duration = summon_spelllist[spellId]

            if apo_time and timestamp == apo_time then
                duration = duration * 2;
            end

            if summons[1] and summons[1][2] == spellId and timestamp - summons[1][4] < 1 then
                summons[1][3] = summons[1][3] + 1;
            else
                table.insert(summons, 1, { currentTime, spellId, 1, timestamp, duration });
            end
        end
    end
end

local timer = nil;

local function checkspec()
    ast_frame:UnregisterEvent("COMBAT_LOG_EVENT_UNFILTERED");

    if timer then
        timer:Cancel();
    end

    local localizedClass, englishClass = UnitClass("player");

    if englishClass == "DEATHKNIGHT" then
        if IsPlayerSpell(444005) then
            showtype = 2;
            callfunc = four_knights;
            ast_frame:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
            timer = C_Timer.NewTicker(0.1, onupdate);
        end
    elseif englishClass == "HUNTER" then
        if IsPlayerSpell(120679) then
            showtype = 1;
            callfunc = direbeast;

            if IsPlayerSpell(385810) then
                direbeast_duration = 10;
            end

            ast_frame:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
            timer = C_Timer.NewTicker(0.1, onupdate);
        end
    end
end

local function onevent(self, event, ...)
    if event == "COMBAT_LOG_EVENT_UNFILTERED" then
        if callfunc then
            callfunc();
        end
    else
        checkspec();
    end
end

-- Register for the combat log event
ast_frame:RegisterEvent("PLAYER_ENTERING_WORLD");
ast_frame:RegisterEvent("ACTIVE_TALENT_GROUP_CHANGED");
ast_frame:RegisterEvent("TRAIT_CONFIG_UPDATED");
ast_frame:RegisterEvent("TRAIT_CONFIG_LIST_UPDATED");
ast_frame:SetScript("OnEvent", onevent);
