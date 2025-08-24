local _, ns = ...;
local Options_Default = {
    version = 250117,
    BackgroundAlpha = 0.4,
    Check_asMOD = false,
};

-- ID 변경
ns.aurachangelist = {
    [270437] = 260242,                   --격냥 조준
    [270436] = 260242,                   --격냥 조준
    [126084] = 44544,                    --냉법 서리 손가락
    [438833] = 51124,                    --냉죽 도살기
    [461135] = 81340,                    --부죽 불시의 파멸
    [170585] = 344179,                   --고술 소용돌이
    [170586] = 344179,                   --고술 소용돌이
    [170587] = 344179,                   --고술 소용돌이
    [170588] = 344179,                   --고술 소용돌이
    [187890] = 344179,                   --고술 소용돌이
    [467442] = 344179,                   --고술 넘치는 소용돌이
    [409129] = 391401,                   --암사 광기
    [361519] = { 392268, 369299, 359618 }, --기원사 정수 폭발

}

-- 색상 변경
ns.spelllists = {
    [263725] = { { 263725, 3, 1, 0.5, 0.5, Enum.ScreenLocationType.Right }, { 453601, 0, 0.5, 1, 0.5, Enum.ScreenLocationType.Left } }, -- 비법, 번뜩임3(빨), 에테르 조율(초)
    [264173] = { { 264173, 4, 0, 1, 0, Enum.ScreenLocationType.Right }, { 264173, 3, 0, 1, 0, Enum.ScreenLocationType.Left } },         -- 악흑, 악마의핵 3/4중
    [135286] = { { 135286, 2, 0.2, 0.2, 0.2, Enum.ScreenLocationType.Right } },                                                         -- 수드, 맹위 2중
    [44544] = { { 438624, 0, 1, 0.2, 0.2, Enum.ScreenLocationType.Left } },                                                             -- 냉법, 화염 촉진
    [391401] = { { 391401, 3, 0, 1, 0, Enum.ScreenLocationType.Left } },                                                                -- 암사 광기 3 중
    [409129] = { { 391401, 4, 0, 1, 0, Enum.ScreenLocationType.Right } },                                                               -- 암사 광기 4 중
    [443176] = { { 443176, 2, 0, 1, 0, Enum.ScreenLocationType.Top } },                                                                 -- 보존 생명 블꽃 2중
};

-- 1 중시 좌측만
ns.countaware = {
    [263725] = { 263725 },         -- 번뜩임
    [264173] = { 264173 },         -- 악마의핵
    [264571] = { 264571 },         -- 일몰
    [16870] = { 16870 },           -- 회드, 번뜩임 2중
    [135700] = { 135700 },         -- 야드 번뜩임
}

-- 아래를 위로
ns.positionaware = {
    --[451038] = { "BOTTOM", "TOP" }, --비전
    --[201846] = {"BOTTOM", "TOP"}, --고술

}

ns.ShowList_SHAMAN_2 = {
    [215785] = { 449490, Enum.ScreenLocationType.LeftRight, 1, 255, 255, 255 }, --고술 뜨거운손

};

ns.options = CopyTable(Options_Default);
local tempoption = {};


function ns.SetupOptionPanels()
    local function OnSettingChanged(_, setting, value)
        local function get_variable_from_cvar_name(cvar_name)
            local variable_start_index = string.find(cvar_name, "_") + 1
            local variable = string.sub(cvar_name, variable_start_index)
            return variable
        end

        local cvar_name = setting:GetVariable()
        local variable = get_variable_from_cvar_name(cvar_name)
        ASO_Options[variable] = value;
        ns.options[variable] = value;
    end

    local category = Settings.RegisterVerticalLayoutCategory("asOverlay");

    if ASO_Options == nil or ASO_Options.version ~= Options_Default.version then
        ASO_Options = {};
        ASO_Options = CopyTable(Options_Default);
    end
    ns.options = CopyTable(ASO_Options);

    for variable, _ in pairs(Options_Default) do
        if variable ~= "version" then
            local name = variable;
            local cvar_name = "asOverlay_" .. variable;
            local tooltip = ""
            if ASO_Options[variable] == nil then
                ASO_Options[variable] = Options_Default[variable];
                ns.options[variable] = Options_Default[variable];
            end
            local defaultValue = Options_Default[variable];
            local currentValue = ASO_Options[variable];

            if tonumber(defaultValue) ~= nil then
                local setting = Settings.RegisterAddOnSetting(category, cvar_name, variable, tempoption,
                    type(defaultValue), name, defaultValue);
                local options = Settings.CreateSliderOptions(0, 1, 0.1);
                options:SetLabelFormatter(MinimalSliderWithSteppersMixin.Label.Right);
                Settings.CreateSlider(category, setting, options, tooltip);
                Settings.SetValue(cvar_name, currentValue);
                Settings.SetOnValueChangedCallback(cvar_name, OnSettingChanged);
            else
                local setting = Settings.RegisterAddOnSetting(category, cvar_name, variable, tempoption,
                type(defaultValue),
                    name, defaultValue);

                Settings.CreateCheckboxWithOptions(category, setting, nil, tooltip);
                Settings.SetValue(cvar_name, currentValue);
                Settings.SetOnValueChangedCallback(cvar_name, OnSettingChanged);
            end
        end
    end

    Settings.RegisterAddOnCategory(category)
end
