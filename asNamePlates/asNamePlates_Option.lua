local _, ns = ...;

---설정부
ns.ANameP_PowerTextSize = 6;
ns.ANameP_MouseTextSize = 12;
ns.ANameP_UpdateRate = 0.5;          -- 버프 Check 반복 시간 (초)
ns.ANameP_UpdateRateTarget = 0.3;    -- 대상의 버프 Check 반복 시간 (초)

ANameP_Options_Default = {
    version = 251220,

    ANameP_AggroShow = true,       -- 어그로 여부를 표현할지 여부
    ANameP_ShowDebuffColor = true, -- 디버프 색상를 표현할지 여부
    ANameP_QuestAlert = true,      -- Quest 몹 색상 변경 사용
    ANameP_BossHint = true,        -- Boss Mob Color 변ㅈ
    ANameP_ShowCastColor = true,    
    ANameP_ShowPower = true,       -- Power 표시
    ANameP_ShowCastIcon = true,    -- CastIcon 표시
    

    ANameP_AggroColor = { r = 0.4, g = 0.2, b = 0.8 },       -- 어그로 대상일때 바 Color
    ANameP_TankAggroLoseColor = { r = 1, g = 0.5, b = 0.5 }, -- 탱커일때 어그로가 다른 탱커가 아닌사람일때
    ANameP_DebuffColor = { r = 1, g = 0.5, b = 1 },          -- 디버프 걸렸을때 Color
    ANameP_QuestColor = { r = 1, g = 0.8, b = 0.5 },         -- Quest 몹 Color
    ANameP_BossColor = { r = 0, g = 1, b = 0.2 },            -- Boss 몹 Color

    nameplateOverlapV = 1.1,                                  -- 이름표 상하 정렬
};

ANameP_OptionM = {};
local update_callback = nil;

local curr_y = 0;
local y_adder = -50;

local panel = CreateFrame("Frame")
panel.name = "asNamePlates" -- see panel fields
if InterfaceOptions_AddCategory then
    InterfaceOptions_AddCategory(panel)
else
    local category, layout = Settings.RegisterCanvasLayoutCategory(panel, panel.name);
    Settings.RegisterAddOnCategory(category);
end

local scrollFrame = nil
local scrollChild = nil;

local function SetupChildPanel()
    curr_y = 0;


    if scrollFrame then
        scrollFrame:Hide()
        scrollFrame:UnregisterAllEvents()
        scrollFrame = nil;
    end

    scrollFrame = CreateFrame("ScrollFrame", nil, panel, "UIPanelScrollFrameTemplate")
    scrollFrame:SetPoint("TOPLEFT", 3, -4)
    scrollFrame:SetPoint("BOTTOMRIGHT", -27, 4)

    -- Create the scrolling child frame, set its width to fit, and give it an arbitrary minimum height (such as 1)
    scrollChild = CreateFrame("Frame")
    scrollFrame:SetScrollChild(scrollChild)
    scrollChild:SetWidth(600)
    scrollChild:SetHeight(1)

    -- add widgets to the panel as desired
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
        ANameP_Options = CopyTable(ANameP_Options_Default);
        ReloadUI();
    end)
end

local function SetupCheckBoxOption(text, option)
    if ANameP_Options[option] == nil then
        ANameP_Options[option] = ANameP_Options_Default[option];
    end

    curr_y = curr_y + y_adder;

    local cb = CreateFrame("CheckButton", nil, scrollChild, "InterfaceOptionsCheckButtonTemplate")
    cb:SetPoint("TOPLEFT", 20, curr_y)
    cb.Text:SetText(text)
    cb:HookScript("OnClick", function()
        ANameP_Options[option] = cb:GetChecked();
        ANameP_OptionM.UpdateAllOption();
    end)
    cb:SetChecked(ANameP_Options[option]);
end

local function SetupSliderOption(text, option)
    if ANameP_Options[option] == nil then
        ANameP_Options[option] = ANameP_Options_Default[option];
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

local function ShowColorPicker(r, g, b, a, changedCallback)
    local info = {};
    info.r, info.g, info.b = r, g, b;
    info.swatchFunc = changedCallback;
    info.cancelFunc = changedCallback;
    ColorPickerFrame:SetupColorPickerAndShow(info);
end

local function SetupColorOption(text, option)
    if ANameP_Options[option] == nil then
        ANameP_Options[option] = ANameP_Options_Default[option];
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
        ANameP_OptionM.UpdateAllOption();
    end

    btn:SetScript("OnClick", function()
        ShowColorPicker(ANameP_Options[option].r, ANameP_Options[option].g, ANameP_Options[option].b, 1, callback);
    end)
end




local bfirst = true;
ANameP_OptionM.SetupAllOption = function()
    if bfirst and not InCombatLockdown() then
        SetCVar("nameplateOverlapV", ANameP_Options["nameplateOverlapV"]);
        if update_callback then
            update_callback();
        end
        bfirst = false;
    end
end

ANameP_OptionM.UpdateAllOption = function()
    ANameP_OptionM.SetupAllOption()
end

ANameP_OptionM.RegisterCallback = function(callback_func)
    update_callback = callback_func;
end

function panel:OnEvent(event, addOnName)
    if addOnName == "asNamePlates" then
        if ANameP_Options == nil then
            ANameP_Options = {};
            ANameP_Options = CopyTable(ANameP_Options_Default);
        end

        if ANameP_Options.version ~= ANameP_Options_Default.version then
            ANameP_Options = CopyTable(ANameP_Options_Default);
        end

        ANameP_OptionM.SetupAllOption();
    elseif event == "TRAIT_CONFIG_UPDATED" or event == "TRAIT_CONFIG_LIST_UPDATED" or event == "ACTIVE_TALENT_GROUP_CHANGED" then
        ANameP_OptionM.SetupAllOption();
    elseif event == "PLAYER_REGEN_ENABLED" then
        ANameP_OptionM.SetupAllOption();
    end
end

local function panelOnShow()
    SetupChildPanel();

    -- Check if the locale is Korean ("koKR")
    if GetLocale() == "koKR" then
        -- Set up checkbox options with Korean descriptions
        SetupCheckBoxOption("[기능] 어그로 색상 표시", "ANameP_AggroShow"); -- Show aggro colors
        SetupColorOption("[색상] 어그로 상위", "ANameP_AggroColor"); -- Nameplate color: Top aggro
        SetupColorOption("[색상] 어그로 상실", "ANameP_TankAggroLoseColor"); -- Tank nameplate color: Aggro lost
        SetupCheckBoxOption("[기능] 디버프 색상 표시", "ANameP_ShowDebuffColor"); -- Show aggro colors
        SetupColorOption("[색상] 디버프", "ANameP_DebuffColor"); -- Nameplate color: Debuff
        SetupCheckBoxOption("[기능] 시전 색상 표시", "ANameP_ShowCastColor");
        SetupCheckBoxOption("[기능] Quest 몹 색상 표시", "ANameP_QuestAlert"); -- Show quest mob colors
        SetupColorOption("[색상] Quest", "ANameP_QuestColor"); -- Nameplate color: Quest

        SetupCheckBoxOption("[기능] Boss 몹 색상 표시", "ANameP_BossHint"); -- Show DBM casting mob colors
        SetupColorOption("[색상] Boss Mob", "ANameP_BossColor"); -- Nameplate color: BossColor
        SetupCheckBoxOption("[기능] 하단에 기력 표시", "ANameP_ShowPower"); -- Show Power
        SetupCheckBoxOption("[기능] 좌측에 시전 Icon 표시", "ANameP_ShowCastIcon"); 

         SetupSliderOption("이름표 상하 정렬 정도 (nameplateOverlapV)", "nameplateOverlapV"); -- Nameplate vertical alignment (nameplateOverlapV)
    else
        -- Set up checkbox options with English descriptions

        SetupCheckBoxOption("[Feature] Show aggro colors", "ANameP_AggroShow");
        SetupColorOption("[Color] Top aggro", "ANameP_AggroColor");
        SetupColorOption("[Color] Aggro lost", "ANameP_TankAggroLoseColor");
        SetupCheckBoxOption("[Feature] Show debuff color", "ANameP_ShowDebuffColor"); -- Show aggro colors
        SetupColorOption("[Color] Debuff", "ANameP_DebuffColor");
        SetupCheckBoxOption("[Feature] Show cast color", "ANameP_ShowCastColor");
        SetupCheckBoxOption("[Feature] Show quest mob colors", "ANameP_QuestAlert");
        SetupColorOption("[Color] Quest", "ANameP_QuestColor");
        SetupCheckBoxOption("[Feature] Show boss hint", "ANameP_BossHint"); -- Show DBM casting mob colors
        SetupColorOption("[Color] Boss Mobs", "ANameP_BossColor");
        SetupCheckBoxOption("[Feature] Show Power below", "ANameP_ShowPower");            -- Show Power
        SetupCheckBoxOption("[Feature] Show cast icon on right", "ANameP_ShowCastIcon"); 

        SetupSliderOption("Nameplate vertical alignment (nameplateOverlapV)", "nameplateOverlapV");
     
    end    
end
local function panelOnHide()
    if scrollFrame then
        scrollFrame:Hide()
        scrollFrame:UnregisterAllEvents()
        scrollFrame = nil;
    end
end

panel:RegisterEvent("ADDON_LOADED")
panel:RegisterEvent("TRAIT_CONFIG_UPDATED");
panel:RegisterEvent("TRAIT_CONFIG_LIST_UPDATED");
panel:RegisterEvent("ACTIVE_TALENT_GROUP_CHANGED")
panel:RegisterEvent("PLAYER_REGEN_ENABLED");
panel:SetScript("OnEvent", panel.OnEvent)
panel:SetScript("OnShow", panelOnShow)
panel:SetScript("OnHide", panelOnHide);