local _, ns = ...;

local Options_Default = {
    LockPosition = true, -- 무조건 알리기
    ShowHeal = false,
    FontSize = 14,
}

local AFCT_X_POSITION = -250      -- X 시작점
local AFCT_Y_POSITION = 550       -- Y 시작점
local AFCT_Y_POSITION_ADDER = 200 --표시위치 Y 높이

local OtherOptions_Default = {
    point = "CENTER",
    point2 = "BOTTOM",
    x = AFCT_X_POSITION,
    y = AFCT_Y_POSITION,
    h = AFCT_Y_POSITION_ADDER,
    version = 250628,
}


local asFixCombatText = CreateFrame("Frame", nil, UIParent)
asFixCombatText:SetSize(100, AFCT_Y_POSITION_ADDER)
asFixCombatText:SetPoint("CENTER", UIParent, "BOTTOM", AFCT_X_POSITION, AFCT_Y_POSITION)
asFixCombatText:SetMovable(true);
asFixCombatText:EnableMouse(true);
asFixCombatText:RegisterForDrag("LeftButton")
asFixCombatText.text = asFixCombatText:CreateFontString(nil, "OVERLAY")
asFixCombatText.text:SetFont(STANDARD_TEXT_FONT, 10, "OUTLINE")
asFixCombatText.text:SetPoint("CENTER", asFixCombatText, "CENTER", 0, 0)
asFixCombatText.text:SetText("asFixCombatText(Position)");
local tex = asFixCombatText:CreateTexture(nil, "ARTWORK");
tex:SetAllPoints();
tex:SetColorTexture(1.0, 0.5, 0);
tex:SetAlpha(0.5);
asFixCombatText:Hide();

-- Function to load saved position
local function LoadPosition()
    asFixCombatText:ClearAllPoints()
    asFixCombatText:SetPoint(AFCT_OtherOptions.point, UIParent, AFCT_OtherOptions.point2, AFCT_OtherOptions.x,
        AFCT_OtherOptions.y);
end

-- Function to save position
local function SavePosition(self)
    AFCT_OtherOptions.point, _, AFCT_OtherOptions.point2, AFCT_OtherOptions.x, AFCT_OtherOptions.y = self:GetPoint();
    self.StopMovingOrSizing(self);
    ns.init_combattext();
end

asFixCombatText:SetScript("OnDragStart", asFixCombatText.StartMoving)
asFixCombatText:SetScript("OnDragStop", SavePosition);

function ns.GetPosition()
    local left = asFixCombatText:GetLeft();
    local bottom = asFixCombatText:GetBottom();
    local height = asFixCombatText:GetHeight();

    return left, bottom, height;
end

local tempoption = {};

function ns.setup_option()
    local function OnSettingChanged(_, setting, value)
        local function get_variable_from_cvar_name(cvar_name)
            local variable_start_index = string.find(cvar_name, "_") + 1
            local variable = string.sub(cvar_name, variable_start_index)
            return variable
        end

        local cvar_name = setting:GetVariable()
        local variable = get_variable_from_cvar_name(cvar_name)
        AFCT_Options[variable] = value;


        if cvar_name == "asFixCombatText_LockPosition" then
            if value == true then
                asFixCombatText:Hide();
            else
                asFixCombatText:Show();
            end
        end
        ns.init_combattext();
    end

    local category = Settings.RegisterVerticalLayoutCategory("asFixCombatText")


    if AFCT_OtherOptions == nil or AFCT_OtherOptions == nil or OtherOptions_Default.version ~= AFCT_OtherOptions.version then
        AFCT_Options = {};
        AFCT_Options = CopyTable(Options_Default);
        AFCT_OtherOptions = {};
        AFCT_OtherOptions = CopyTable(OtherOptions_Default);
    end


    for variable, _ in pairs(Options_Default) do
        local name = variable;
        local cvar_name = "asFixCombatText_" .. variable;
        local tooltip = ""
        if AFCT_Options[variable] == nil then
            AFCT_Options[variable] = Options_Default[variable];
        end
        local defaultValue = Options_Default[variable];
        local currentValue = AFCT_Options[variable];


        if tonumber(defaultValue) ~= nil then
            local setting = Settings.RegisterAddOnSetting(category, cvar_name, variable, tempoption, type(defaultValue),
                name, defaultValue);
            local options = Settings.CreateSliderOptions(5, 50, 1);
            options:SetLabelFormatter(MinimalSliderWithSteppersMixin.Label.Right);
            Settings.CreateSlider(category, setting, options, tooltip);
            Settings.SetValue(cvar_name, currentValue);
            Settings.SetOnValueChangedCallback(cvar_name, OnSettingChanged);
        else
            local setting = Settings.RegisterAddOnSetting(category, cvar_name, variable, tempoption, type(defaultValue),
                name, defaultValue);

            Settings.CreateCheckboxWithOptions(category, setting, nil, tooltip);
            Settings.SetValue(cvar_name, currentValue);
            Settings.SetOnValueChangedCallback(cvar_name, OnSettingChanged);
        end
    end

    Settings.RegisterAddOnCategory(category)
    LoadPosition();

    local bloaded = C_AddOns.LoadAddOn("asMOD");

    if bloaded and ASMODOBJ.load_position then
        ASMODOBJ.load_position(asFixCombatText, "asFixCombatText");
        AFCT_OtherOptions.point, _, AFCT_OtherOptions.point2, AFCT_OtherOptions.x, AFCT_OtherOptions.y = asFixCombatText
            :GetPoint();
    end

    if AFCT_Options.LockPosition then
        asFixCombatText:Hide();
    else
        asFixCombatText:Show();
    end

    ns.init_combattext();
end
