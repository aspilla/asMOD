local _, ns = ...;
local Options_Default = {
    version = 240301,
    ShowAlpha = false,
    ShowCount = false,
    ShowRemainTime = false,
};

-- 색상 변경
ns.spelllists = {
    [263725] = { { 263725, 3, 1, 0.5, 0.5, "RIGHT" }, { 449400, 5, 0.5, 1, 1, "LEFT" }, { 453601, 0, 0.5, 1, 0.5, "LEFT" } },   -- 비법, 번뜩임3(빨), 비전태양 5중(파),  에테르 조율(초)
    [264173] = { { 264173, 4, 0, 1, 0, "RIGHT" }, { 264173, 3, 0, 1, 0, "LEFT" } },                                             -- 악흑, 악마의핵 3/4중
    [135286] = { { 135286, 2, 0.2, 0.2, 0.2, "RIGHT" } },                                                                       -- 수드, 맹위 2중
    [44544] = { { 438624, 0, 1, 0.2, 0.2, "LEFT" } },                                                                           -- 냉법, 화염 촉진                         
};

-- 1 중시 좌측만
ns.countaware = {
    [263725] = 263725, -- 번뜩임
    [264173] = 264173, -- 악마의핵
    [264571] = 264571, -- 일몰
    [81340] = 81340,  -- 부정, 불시의 파멸 2중
    [16870] = 16870,  -- 회드, 번뜩임 2중
    [270436] = 260242, --정밀 사격
    [270437] = 260242, --정밀 사격
}

-- 아래를 위로
ns.positionaware = {
    [451038] = {"BOTTOM", "TOP"}, --비전
    --[201846] = {"BOTTOM", "TOP"}, --고술

}

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
            local defaultValue = ASO_Options[variable];

            local setting = Settings.RegisterAddOnSetting(category, cvar_name, variable, tempoption, type(defaultValue),
            name, defaultValue);

            Settings.CreateCheckboxWithOptions(category, setting, nil, tooltip)
            Settings.SetOnValueChangedCallback(cvar_name, OnSettingChanged)
        end
    end

    Settings.RegisterAddOnCategory(category)
end
