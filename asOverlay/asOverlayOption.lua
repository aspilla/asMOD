local _, ns = ...;
local Options_Default = {
    version = 240301,
    ShowAlpha = false,
    ShowCount = false,
    ShowRemainTime = false,
};

-- 색상 변경 
ns.spelllists = {
    [263725] = {424331, 0, 1, 0.5, 0.5}; -- 비법, 번뜩임 + 비전포(용군단 시즌3)
    [187890] = {187890, 8, 1, 0.5, 0.5}; -- 고술, 소용돌이 8중
    [264173] = {264173, 4, 0.5, 1, 0.5}; -- 악흑, 악마의핵 4중
    [16870] = {16870, 2, 1, 0.5, 0.5}; -- 회드, 번뜩임 2중
    [54149] = {54149, 2, 1, 0.5, 0.5}; -- 신기, 빛주입 2중
    [270437] = {260242, 2, 1, 0.5, 0.5}; -- 사격, 정밀사격 2중
    [81340] = {81340, 2, 1, 0.5, 0.5}; -- 부정, 불시의 파멸 2중
};

ns.options = CopyTable(Options_Default);


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

            local setting = Settings.RegisterAddOnSetting(category, name, cvar_name, type(defaultValue), defaultValue)
            Settings.CreateCheckBox(category, setting, tooltip)
            Settings.SetOnValueChangedCallback(cvar_name, OnSettingChanged)
        end
    end

    Settings.RegisterAddOnCategory(category)
end