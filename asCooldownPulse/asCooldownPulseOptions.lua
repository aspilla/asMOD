local _, ns = ...;
local Options_Default = {
    version = 261124,
    ReadyAlertSize = 80,
    MinCooldown = 15,
    UseBlacklist = false,
    EnableTTS = true,
    TTS_ID = -1,
    SoundVolume = 70,
    AlertSound = false,
    ShowScaleAnim = true,
};

local L = {
    ReadyAlertSize = "Icon size for skill ready alert.",
    MinCooldown = "Minimum time(second) of cooldown to alert.",
    UseBlacklist = "Use Blacklist (Ignore cooldown time)",
    UseBlacklistTooltip = "When enabled, only non-blacklisted spells/items are alerted. 1.6 seconds for minimum time.",
    EnableTTS = "Alert spell sound using TTS",
    TTS_ID = "TTS ID",
    SoundVolume = "Sound Volume",
    AlertSound = "Sound notification for skill ready alert.",
    ShowScaleAnim = "Scale animation for alert button",
    Blacklist = "Blacklist Settings",
    BlacklistDesc = "Uncheck spells or items to add them to the blacklist (exclude from alerts).",
    CurrentSpec = "Specialization: ",
    SelectAll = "Check All",
    UnselectAll = "Uncheck All",
    SpellsHeader = "Spells",
    ItemsHeader = "Items",
};

if GetLocale() == "koKR" then
    L = {
        ReadyAlertSize = "스킬 사용가능 알림 아이콘 크기",
        MinCooldown = "알림할 최소 쿨다운 시간(초)",
        UseBlacklist = "블랙리스트 사용 (쿨다운 시간 무시)",
        UseBlacklistTooltip = "블랙리스트를 사용합니다. 이 옵션을 켜면 최소 쿨다운 시간은 1.6초로 설정 됨.",
        EnableTTS = "TTS 로 스킬 쿨 음성 알림",
        TTS_ID = "TTS ID",
        SoundVolume = "음성 크기",
        AlertSound = "스킬 쿨다운시 알림음 재생",
        ShowScaleAnim = "알림시 크기 애니메이션",
        Blacklist = "블랙리스트 설정",
        BlacklistDesc = "체크를 해제하면 해당 스킬/아이템이 블랙리스트에 등록(알림 제외)됩니다.",
        CurrentSpec = "전문화: ",
        SelectAll = "모두 선택",
        UnselectAll = "모두 해제",
        SpellsHeader = "스킬 목록",
        ItemsHeader = "아이템 목록",
    };
end

ns.options = CopyTable(Options_Default);
local tempoption = {};
local bupdated = false;

local function SetupBlacklistPanel(panel)
    panel.title = panel:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge");
    panel.title:SetPoint("TOPLEFT", 16, -16);
    panel.title:SetText("asCooldownPulse - " .. L.Blacklist);

    panel.specText = panel:CreateFontString(nil, "ARTWORK", "GameFontHighlight");
    panel.specText:SetPoint("TOPLEFT", panel.title, "BOTTOMLEFT", 0, -8);

    panel.desc = panel:CreateFontString(nil, "ARTWORK", "GameFontNormalSmall");
    panel.desc:SetPoint("TOPLEFT", panel.specText, "BOTTOMLEFT", 0, -6);
    panel.desc:SetText(L.BlacklistDesc);
    panel.desc:SetTextColor(0.8, 0.8, 0.8);

    local btnSelectAll = CreateFrame("Button", nil, panel, "UIPanelButtonTemplate");
    btnSelectAll:SetSize(100, 24);
    btnSelectAll:SetPoint("TOPRIGHT", -120, -16);
    btnSelectAll:SetText(L.SelectAll);
    btnSelectAll:SetScript("OnClick", function()
        local specID = ns.get_current_spec_id and ns.get_current_spec_id() or 0;
        ACDP_Options.Blacklists = ACDP_Options.Blacklists or {};
        ACDP_Options.Blacklists[specID] = {};
        if ns.refresh_blacklist_ui then
            ns.refresh_blacklist_ui();
        end
        if ns.refresh_alerts then
            ns.refresh_alerts();
        end
    end);

    local btnUnselectAll = CreateFrame("Button", nil, panel, "UIPanelButtonTemplate");
    btnUnselectAll:SetSize(100, 24);
    btnUnselectAll:SetPoint("LEFT", btnSelectAll, "RIGHT", 8, 0);
    btnUnselectAll:SetText(L.UnselectAll);
    btnUnselectAll:SetScript("OnClick", function()
        local specID = ns.get_current_spec_id and ns.get_current_spec_id() or 0;
        ACDP_Options.Blacklists = ACDP_Options.Blacklists or {};
        ACDP_Options.Blacklists[specID] = ACDP_Options.Blacklists[specID] or {};
        if ns.all_spells then
            for id, _ in pairs(ns.all_spells) do
                ACDP_Options.Blacklists[specID][id] = true;
            end
        end
        if ns.all_items then
            for id, _ in pairs(ns.all_items) do
                ACDP_Options.Blacklists[specID][id] = true;
            end
        end
        if ns.refresh_blacklist_ui then
            ns.refresh_blacklist_ui();
        end
        if ns.refresh_alerts then
            ns.refresh_alerts();
        end
    end);

    local scrollFrame = CreateFrame("ScrollFrame", nil, panel, "UIPanelScrollFrameTemplate");
    scrollFrame:SetPoint("TOPLEFT", 16, -75);
    scrollFrame:SetPoint("BOTTOMRIGHT", -36, 16);
    panel.scrollframe = scrollFrame;

    local scrollChild = CreateFrame("Frame", nil, scrollFrame);
    scrollChild:SetWidth(560);
    scrollChild:SetHeight(1);
    scrollFrame:SetScrollChild(scrollChild);
    panel.scrollchild = scrollChild;

    local rowPool = {};
    local headerPool = {};

    local function GetHeader(idx)
        if not headerPool[idx] then
            local h = scrollChild:CreateFontString(nil, "ARTWORK", "GameFontNormal");
            h:SetJustifyH("LEFT");
            headerPool[idx] = h;
        end
        return headerPool[idx];
    end

    local function GetRow(idx)
        if not rowPool[idx] then
            local row = CreateFrame("Frame", nil, scrollChild);
            row:SetSize(560, 26);

            local cb = CreateFrame("CheckButton", nil, row, "UICheckButtonTemplate");
            cb:SetSize(24, 24);
            cb:SetPoint("LEFT", row, "LEFT", 0, 0);
            row.checkbox = cb;

            local icon = row:CreateTexture(nil, "ARTWORK");
            icon:SetSize(20, 20);
            icon:SetPoint("LEFT", cb, "RIGHT", 4, 0);
            icon:SetTexCoord(0.08, 0.92, 0.08, 0.92);
            row.icon = icon;

            local text = row:CreateFontString(nil, "ARTWORK", "GameFontHighlight");
            text:SetPoint("LEFT", icon, "RIGHT", 6, 0);
            text:SetPoint("RIGHT", row, "RIGHT", -10, 0);
            text:SetJustifyH("LEFT");
            row.text = text;

            local infoBtn = CreateFrame("Button", nil, row);
            infoBtn:SetPoint("TOPLEFT", icon, "TOPLEFT");
            infoBtn:SetPoint("BOTTOMRIGHT", row, "BOTTOMRIGHT");
            infoBtn:SetScript("OnEnter", function()
                if row.data then
                    GameTooltip:SetOwner(row, "ANCHOR_TOPLEFT");
                    if row.data.isItem then
                        GameTooltip:SetItemByID(row.data.id);
                    else
                        GameTooltip:SetSpellByID(row.data.id);
                    end
                    GameTooltip:Show();
                end
            end);
            infoBtn:SetScript("OnLeave", function()
                GameTooltip:Hide();
            end);

            cb:SetFrameLevel(infoBtn:GetFrameLevel() + 2);

            cb:SetScript("OnClick", function(self)
                local checked = self:GetChecked();
                local data = row.data;
                if data then
                    local specID = ns.get_current_spec_id and ns.get_current_spec_id() or 0;
                    ACDP_Options.Blacklists = ACDP_Options.Blacklists or {};
                    ACDP_Options.Blacklists[specID] = ACDP_Options.Blacklists[specID] or {};
                    if checked then
                        ACDP_Options.Blacklists[specID][data.id] = nil;
                    else
                        ACDP_Options.Blacklists[specID][data.id] = true;
                    end
                    if ns.refresh_alerts then
                        ns.refresh_alerts();
                    end
                end
            end);

            rowPool[idx] = row;
        end
        return rowPool[idx];
    end

    function ns.refresh_blacklist_ui()
        if not panel:IsShown() then
            return;
        end

        local specID = ns.get_current_spec_id and ns.get_current_spec_id() or 0;
        local specName = ns.get_current_spec_name and ns.get_current_spec_name() or "Specialization";
        panel.specText:SetText(L.CurrentSpec .. "|cffffd100" .. specName .. "|r (ID: " .. specID .. ")");

        local spec_bl = (ACDP_Options.Blacklists and ACDP_Options.Blacklists[specID]) or {};

        local sortedSpells = {};
        if ns.all_spells then
            for id, info in pairs(ns.all_spells) do
                table.insert(sortedSpells, info);
            end
            table.sort(sortedSpells, function(a, b)
                return (a.name or "") < (b.name or "");
            end);
        end

        local sortedItems = {};
        if ns.all_items then
            for id, info in pairs(ns.all_items) do
                table.insert(sortedItems, info);
            end
            table.sort(sortedItems, function(a, b)
                return (a.name or "") < (b.name or "");
            end);
        end

        local curr_y = -4;
        local row_idx = 1;
        local header_idx = 1;

        local hSpell = GetHeader(header_idx);
        header_idx = header_idx + 1;
        hSpell:ClearAllPoints();
        hSpell:SetPoint("TOPLEFT", scrollChild, "TOPLEFT", 6, curr_y);
        hSpell:SetText("|cffffd100=== " .. L.SpellsHeader .. " (" .. #sortedSpells .. ") ===|r");
        hSpell:Show();
        curr_y = curr_y - 24;

        for _, info in ipairs(sortedSpells) do
            local row = GetRow(row_idx);
            row_idx = row_idx + 1;
            row:ClearAllPoints();
            row:SetPoint("TOPLEFT", scrollChild, "TOPLEFT", 6, curr_y);

            row.data = { id = info.id, isItem = false };
            local isBlacklisted = spec_bl[info.id] == true;
            row.checkbox:SetChecked(not isBlacklisted);
            row.icon:SetTexture(info.icon or 134400);
            row.text:SetText((info.name or ("Spell " .. info.id)) .. " |cff888888(" .. info.id .. ")|r");
            row:Show();

            curr_y = curr_y - 28;
        end

        curr_y = curr_y - 10;

        local hItem = GetHeader(header_idx);
        header_idx = header_idx + 1;
        hItem:ClearAllPoints();
        hItem:SetPoint("TOPLEFT", scrollChild, "TOPLEFT", 6, curr_y);
        hItem:SetText("|cffffd100=== " .. L.ItemsHeader .. " (" .. #sortedItems .. ") ===|r");
        hItem:Show();
        curr_y = curr_y - 24;

        for _, info in ipairs(sortedItems) do
            local row = GetRow(row_idx);
            row_idx = row_idx + 1;
            row:ClearAllPoints();
            row:SetPoint("TOPLEFT", scrollChild, "TOPLEFT", 6, curr_y);

            row.data = { id = info.id, isItem = true };
            local isBlacklisted = spec_bl[info.id] == true;
            row.checkbox:SetChecked(not isBlacklisted);
            row.icon:SetTexture(info.icon or 134400);
            row.text:SetText((info.name or ("Item " .. info.id)) .. " |cff888888(" .. info.id .. ")|r");
            row:Show();

            curr_y = curr_y - 28;
        end

        for i = row_idx, #rowPool do
            rowPool[i]:Hide();
        end
        for i = header_idx, #headerPool do
            headerPool[i]:Hide();
        end

        scrollChild:SetHeight(math.abs(curr_y) + 20);
    end

    panel:SetScript("OnShow", function()
        ns.refresh_blacklist_ui();
    end);
end

function ns.setup_option()
    local function OnSettingChanged(_, setting, value)
        local function get_variable_from_cvar_name(cvar_name)
            local variable_start_index = string.find(cvar_name, "_") + 1
            local variable = string.sub(cvar_name, variable_start_index)
            return variable
        end

        local cvar_name = setting:GetVariable()
        local variable = get_variable_from_cvar_name(cvar_name)
        ACDP_Options[variable] = value;
        ns.options[variable] = value;
        if variable == "UseBlacklist" or variable == "MinCooldown" then
            if ns.refresh_alerts then
                ns.refresh_alerts();
            end
        else
            bupdated = true;
        end
    end

    local category = Settings.RegisterVerticalLayoutCategory("asCooldownPulse");

    if not category then
        return;
    end

    ns.blacklistpanel = CreateFrame("Frame");
    SetupBlacklistPanel(ns.blacklistpanel);
    local subcategory, subcategoryLayout = Settings.RegisterCanvasLayoutSubcategory(category, ns.blacklistpanel, L.Blacklist);

    if ACDP_Options == nil then
        ACDP_Options = CopyTable(Options_Default);
        ACDP_Positions = {};
    else
        for k, v in pairs(Options_Default) do
            if ACDP_Options[k] == nil then
                ACDP_Options[k] = v;
            end
        end
    end

    if ACDP_Positions == nil then
        ACDP_Positions = {};
    end

    if ACDP_Options.Blacklists == nil then
        ACDP_Options.Blacklists = {};
    end

    ns.options = CopyTable(ACDP_Options);

    for variable, _ in pairs(Options_Default) do
        if variable ~= "version" then
            local name = variable;
            local cvar_name = "asCooldownPulse_" .. variable;
            local tooltip = L[name .. "Tooltip"] or "";
            if ACDP_Options[variable] == nil then
                ACDP_Options[variable] = Options_Default[variable];
                ns.options[variable] = Options_Default[variable];
            end
            local defaultValue = Options_Default[variable];
            local currentValue = ACDP_Options[variable];

            if name == "TTS_ID" then
                local function GetOptions()
                    local container = Settings.CreateControlTextContainer()

                    local ttsinfos = C_VoiceChat.GetTtsVoices();
                    for id, v in pairs(ttsinfos) do
                        container:Add(v.voiceID, v.name);
                    end
                    return container:GetData()
                end

                if currentValue < 0 then
                    local ttsinfos = C_VoiceChat.GetTtsVoices();
                    local locale = GetLocale();
                    local findLang = "Korean";

                    if not (locale == "koKR") then
                        findLang = "English";
                    end

                    ACDP_Options[variable] = 0;
                    ns.options[variable] = 0;

                    for id, v in pairs(ttsinfos) do
                        if strfind(v.name, findLang) then
                            currentValue = v.voiceID;
                            ACDP_Options[variable] = currentValue;
                            ns.options[variable] = currentValue;
                        end
                    end
                end

                local setting = Settings.RegisterAddOnSetting(category, cvar_name, variable, tempoption,
                    type(defaultValue), L[name], defaultValue);

                Settings.CreateDropdown(category, setting, GetOptions, tooltip);
                Settings.SetValue(cvar_name, currentValue);
                Settings.SetOnValueChangedCallback(cvar_name, OnSettingChanged);
            elseif name == "SoundVolume" then
                local setting = Settings.RegisterAddOnSetting(category, cvar_name, variable, tempoption,
                    type(defaultValue), L[name], defaultValue);
                local options = Settings.CreateSliderOptions(0, 100, 1);
                options:SetLabelFormatter(MinimalSliderWithSteppersMixin.Label.Right);
                Settings.CreateSlider(category, setting, options, tooltip);
                Settings.SetValue(cvar_name, currentValue);
                Settings.SetOnValueChangedCallback(cvar_name, OnSettingChanged);
            elseif tonumber(defaultValue) ~= nil then
                local setting = Settings.RegisterAddOnSetting(category, cvar_name, variable, tempoption,
                    type(defaultValue), L[name], defaultValue);
                local options = Settings.CreateSliderOptions(0, 400, 1);
                options:SetLabelFormatter(MinimalSliderWithSteppersMixin.Label.Right);
                Settings.CreateSlider(category, setting, options, tooltip);
                Settings.SetValue(cvar_name, currentValue);
                Settings.SetOnValueChangedCallback(cvar_name, OnSettingChanged);
            else
                local setting = Settings.RegisterAddOnSetting(category, cvar_name, variable, tempoption,
                    type(defaultValue),
                    L[name], defaultValue);
                Settings.CreateCheckboxWithOptions(category, setting, nil, tooltip);
                Settings.SetValue(cvar_name, currentValue);
                Settings.SetOnValueChangedCallback(cvar_name, OnSettingChanged);
            end
        end
    end

    Settings.RegisterAddOnCategory(category)
    if subcategory then
        Settings.RegisterAddOnCategory(subcategory)
    end

    EventRegistry:RegisterCallback("SettingsPanel.OnHide", function()
        if bupdated then
            ReloadUI();
        end
    end);
end
