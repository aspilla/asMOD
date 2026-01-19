local _, ns = ...;


ns.configs = {
    powerfontsize = 6,
    mousefontsize = 12,
    updaterate = 0.2,
};

ns.option_default = {
    version = 251220,

    ShowAggro = true,
    ShowDebuffColor = true,
    ShowQuestColor = true,
    ShowBossColor = true,
    ShowCasterColor = true,
    ShowCastColor = true,
    ShowPower = true,
    ShowCastIcon = true,
    ChangeDebuffIcon = true,
    ChangeTexture = true,
    ShowTargeted = true,
    AlertImportantSpell = true,

    AggroColor = { r = 0.4, g = 0.2, b = 0.8 },
    TankAggroLoseColor = { r = 1, g = 0.5, b = 0.5 },
    UninterruptableColor = { r = 0.9, g = 0.9, b = 0.9 },
    InterruptableColor = { r = 204 / 255, g = 255 / 255, b = 153 / 255 },
    DebuffColor = { r = 1, g = 0.5, b = 1 },
    CombatColor = { r = 0.5, g = 1, b = 1 },
    QuestColor = { r = 1, g = 0.8, b = 0.5 },
    BossColor = { r = 0, g = 1, b = 0.2 },

    nameplateOverlapV = 1.1,
};

ns.options = CopyTable(ns.option_default);

local curr_y = 0;
local y_adder = -50;

local panel = CreateFrame("Frame")
panel.name = "asNamePlates"
if InterfaceOptions_AddCategory then
    InterfaceOptions_AddCategory(panel)
else
    local category, layout = Settings.RegisterCanvasLayoutCategory(panel, panel.name);
    Settings.RegisterAddOnCategory(category);
end

local scrollFrame = nil
local scrollChild = nil;

local function setup_childpanel()
    curr_y = 0;

    if scrollFrame then
        scrollFrame:Hide()
        scrollFrame:UnregisterAllEvents()
        scrollFrame = nil;
    end

    scrollFrame = CreateFrame("ScrollFrame", nil, panel, "UIPanelScrollFrameTemplate")
    scrollFrame:SetPoint("TOPLEFT", 3, -4)
    scrollFrame:SetPoint("BOTTOMRIGHT", -27, 4)


    scrollChild = CreateFrame("Frame")
    scrollFrame:SetScrollChild(scrollChild)
    scrollChild:SetWidth(600)
    scrollChild:SetHeight(1)


    local title = panel:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
    title:SetPoint("TOP")
    title:SetText("asNamePlates")

    local btn = CreateFrame("Button", nil, panel, "UIPanelButtonTemplate")
    btn:SetPoint("TOPRIGHT", -50, -10)
    if GetLocale() == "koKR" then
        btn:SetText("설정 초기화")
    else
        btn:SetText("Reset settings")
    end
    btn:SetWidth(100)
    btn:SetScript("OnClick", function()
        ANameP_Options = {};
        ANameP_Options = CopyTable(ns.option_default);
        ReloadUI();
    end)
end

local function setup_checkboxoption(text, option)
    if ANameP_Options[option] == nil then
        ANameP_Options[option] = ns.option_default[option];
    end

    curr_y = curr_y + y_adder;

    local cb = CreateFrame("CheckButton", nil, scrollChild, "InterfaceOptionsCheckButtonTemplate")
    cb:SetPoint("TOPLEFT", 20, curr_y)
    cb.Text:SetText(text)
    cb:HookScript("OnClick", function()
        ANameP_Options[option] = cb:GetChecked();
        ns.setup_alloptions();
    end)
    cb:SetChecked(ANameP_Options[option]);
end

local function setup_slideoption(text, option)
    if ANameP_Options[option] == nil then
        ANameP_Options[option] = ns.option_default[option];
    end

    curr_y = curr_y + y_adder;

    if scrollChild == nil then
        return;
    end

    local title = scrollChild:CreateFontString(nil, "ARTWORK", "GameFontNormal");
    title:SetPoint("TOPLEFT", 20, curr_y);
    title:SetText(text);

    local Slider = CreateFrame("Slider", nil, scrollChild, "OptionsSliderTemplate");
    Slider:SetOrientation('HORIZONTAL');
    Slider:SetPoint("LEFT", title, "RIGHT", 5, 0);
    Slider:SetWidth(200)
    Slider:SetHeight(20)
    Slider.Text:SetText(format("%.1f", max(ANameP_Options[option], 0)));
    Slider:SetMinMaxValues(0.3, 2);
    Slider:SetValue(ANameP_Options[option]);

    Slider:HookScript("OnValueChanged", function()
        ANameP_Options[option] = Slider:GetValue();
        Slider.Text:SetText(format("%.1f", max(ANameP_Options[option], 0)));
        if not InCombatLockdown() then
            SetCVar("nameplateOverlapV", ANameP_Options[option]);
        end
    end)
    Slider:Show();
    if not InCombatLockdown() then
        SetCVar("nameplateOverlapV", ANameP_Options[option]);
    end
end

local function show_colorpicker(r, g, b, a, changedCallback)
    local info = {};
    info.r, info.g, info.b = r, g, b;
    info.swatchFunc = changedCallback;
    info.cancelFunc = changedCallback;
    ColorPickerFrame:SetupColorPickerAndShow(info);
end

local function setup_coloroption(text, option)
    if ANameP_Options[option] == nil then
        ANameP_Options[option] = ns.option_default[option];
        ns.options = CopyTable(ANameP_Options);
    end

    curr_y = curr_y + y_adder;

    if scrollChild == nil then
        return;
    end

    local title = scrollChild:CreateFontString(nil, "ARTWORK", "GameFontNormal");
    title:SetPoint("TOPLEFT", 20, curr_y);
    title:SetText(text);
    title:SetTextColor(ANameP_Options[option].r, ANameP_Options[option].g, ANameP_Options[option].b, 1);

    local btn = CreateFrame("Button", nil, scrollChild, "UIPanelButtonTemplate")
    btn:SetPoint("LEFT", title, "RIGHT", 5, 0);

    if GetLocale() == "koKR" then
        btn:SetText("색상 변경")
    else
        btn:SetText("Change color")
    end
    btn:SetWidth(100)

    local callback = function(restore)
        local newR, newG, newB, newA;
        if restore then
            newR, newG, newB, newA = unpack(restore);
        else
            newR, newG, newB, newA = ColorPickerFrame:GetColorRGB();
        end
        ANameP_Options[option].r, ANameP_Options[option].g, ANameP_Options[option].b = newR, newG, newB;
        title:SetTextColor(ANameP_Options[option].r, ANameP_Options[option].g, ANameP_Options[option].b, 1);
        ns.setup_alloptions();
    end

    btn:SetScript("OnClick", function()
        show_colorpicker(ANameP_Options[option].r, ANameP_Options[option].g, ANameP_Options[option].b, 1, callback);
    end)
end

local bfirst = true;
ns.setup_alloptions = function()
    if bfirst and not InCombatLockdown() then
        SetCVar("nameplateOverlapV", ANameP_Options["nameplateOverlapV"]);
        bfirst = false;
    end
end


local function on_event(self, event, addOnName)
    if addOnName == "asNamePlates" then
        if ANameP_Options == nil then
            ANameP_Options = {};
            ANameP_Options = CopyTable(ns.option_default);
        end

        if ANameP_Options.version ~= ns.option_default.version then
            ANameP_Options = CopyTable(ns.option_default);
        end

        ns.setup_alloptions();
    elseif event == "PLAYER_REGEN_ENABLED" then
        ns.setup_alloptions();
    end
end

local function on_panelshow()
    setup_childpanel();


    if GetLocale() == "koKR" then
        setup_checkboxoption("[기능] 이름표 모양 변경", "ChangeTexture");
        setup_checkboxoption("[기능] 하단에 기력 표시", "ShowPower");
        setup_checkboxoption("[기능] 시전 Icon 표시", "ShowCastIcon");
        setup_checkboxoption("[기능] Debuff Icon 변경", "ChangeDebuffIcon");
        setup_checkboxoption("[기능] Targeted 강조", "ShowTargeted");
        setup_checkboxoption("[기능] 중요 스킬 시전 강조", "AlertImportantSpell");

        setup_slideoption("이름표 상하 정렬 정도 (nameplateOverlapV)", "nameplateOverlapV");

        setup_checkboxoption("[기능] 어그로 색상 표시", "ShowAggro");
        setup_coloroption("[색상] 어그로 상위", "AggroColor");
        setup_coloroption("[색상] 어그로 상실", "TankAggroLoseColor");
        setup_coloroption("[색상] 어그로 전투중 색상", "CombatColor");

        setup_checkboxoption("[기능] 디버프 색상 표시", "ShowDebuffColor");
        setup_coloroption("[색상] 디버프", "DebuffColor");

        setup_checkboxoption("[기능] 시전 색상 표시", "ShowCastColor");
        setup_coloroption("[색상] 차단가능", "InterruptableColor");
        setup_coloroption("[색상] 차단불가", "UninterruptableColor");

        setup_checkboxoption("[기능] 던전, Boss 몹 색상 표시", "ShowBossColor");
        setup_coloroption("[색상] Boss Mob", "BossColor");

        setup_checkboxoption("[기능] 던전, Caster 몹 색상 표시", "ShowCasterColor");
        setup_checkboxoption("[기능] 필드, Quest 몹 색상 표시", "ShowQuestColor");
        setup_coloroption("[색상] Quest, Caster", "QuestColor");
    else
        setup_checkboxoption("[Feature] Change Texture", "ChangeTexture");
        setup_checkboxoption("[Feature] Show Power below", "ShowPower");
        setup_checkboxoption("[Feature] Show cast icon", "ShowCastIcon");
        setup_checkboxoption("[Feature] Change Debuff Icon", "ChangeDebuffIcon");
        setup_checkboxoption("[Feature] Alert Targeted", "ShowTargeted");
        setup_checkboxoption("[Feature] Alert Important Spell Casting", "AlertImportantSpell");

        setup_slideoption("Nameplate vertical alignment (nameplateOverlapV)", "nameplateOverlapV");

        setup_checkboxoption("[Feature] Show aggro colors", "ShowAggro");
        setup_coloroption("[Color] Top aggro", "AggroColor");
        setup_coloroption("[Color] Aggro lost", "TankAggroLoseColor");
        setup_coloroption("[Color] Aggro combat normal", "CombatColor");

        setup_checkboxoption("[Feature] Show cast color", "ShowCastColor");
        setup_coloroption("[Color] Interrutable", "InterruptableColor");
        setup_coloroption("[Color] Uninterruptable", "UninterruptableColor");

        setup_checkboxoption("[Feature] Show debuff color", "ShowDebuffColor");
        setup_coloroption("[Color] Debuff", "DebuffColor");

        setup_checkboxoption("[Feature] Dungoen, Show boss hint", "ShowBossColor");
        setup_coloroption("[Color] Boss Mobs", "BossColor");

        setup_checkboxoption("[Feature] Dungeon, Show Caster hint", "ShowCasterColor");
        setup_checkboxoption("[Feature] Field, Show quest mob colors", "ShowQuestColor");
        setup_coloroption("[Color] Quest/Caster", "QuestColor");
    end
end
local function on_panelhide()
    if scrollFrame then
        scrollFrame:Hide()
        scrollFrame:UnregisterAllEvents()
        scrollFrame = nil;
    end
end

panel:RegisterEvent("ADDON_LOADED");
panel:RegisterEvent("PLAYER_REGEN_ENABLED");
panel:SetScript("OnEvent", on_event);
panel:SetScript("OnShow", on_panelshow);
panel:SetScript("OnHide", on_panelhide);
