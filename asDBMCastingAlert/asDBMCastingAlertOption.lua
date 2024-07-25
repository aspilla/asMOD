local _, ns = ...;
local Options_Default = {
    Version = 240608,
    PlaySound = true,
    SoundVolume = 50,
    TTS = false,
    HideTarget = true,
    TTS_ID = -1,
};

ns.options = CopyTable(Options_Default);

local function GetOptions()
    local container = Settings.CreateControlTextContainer()

    local ttsinfos = C_VoiceChat.GetTtsVoices();
    for id, v in pairs(ttsinfos) do
        container:Add(v.voiceID, v.name);
    end
    return container:GetData()
end


function ns.SetupOptionPanels()
    local function OnSettingChanged(_, setting, value)
        local function get_variable_from_cvar_name(cvar_name)
            local variable_start_index = string.find(cvar_name, "_") + 1
            local variable = string.sub(cvar_name, variable_start_index)
            return variable
        end

        local cvar_name = setting:GetVariable()
        local variable = get_variable_from_cvar_name(cvar_name)
        ADCA_Options[variable] = value;
        ns.options[variable] = value;
    end

    local category = Settings.RegisterVerticalLayoutCategory("asDBMCastingAlert")

    if not category then
        return;
    end

    if ADCA_Options == nil or Options_Default.Version ~= ACDP_Options.Version then
        ADCA_Options = {};
        ADCA_Options = CopyTable(Options_Default);
    end

    ns.options = CopyTable(ADCA_Options);

    for variable, _ in pairs(Options_Default) do
        local name = variable;
        local cvar_name = "asDBMCastingAlert_" .. variable;
        local tooltip = ""
        if ADCA_Options[variable] == nil then
            ADCA_Options[variable] = Options_Default[variable];
            ns.options[variable] = Options_Default[variable];
        end
        local defaultValue = ADCA_Options[variable];

        if name ~= "Version" then
            if name == "TTS_ID" then
                if defaultValue < 0 then
                    local ttsinfos = C_VoiceChat.GetTtsVoices();
                    local locale = GetLocale();
                    local findLang = "Korean";

                    if not (locale == "koKR") then
                        findLang = "English";
                    end

                    ADCA_Options[variable] = 0;
                    ns.options[variable] = 0;

                    for id, v in pairs(ttsinfos) do
                        if strfind(v.name, findLang) then
                            defaultValue = v.voiceID;
                            ADCA_Options[variable] = defaultValue;
                            ns.options[variable] = defaultValue;
                        end
                    end
                end
                
                local setting = Settings.RegisterAddOnSetting(category, name, cvar_name, type(defaultValue), defaultValue);
                Settings.CreateDropdown(category, setting, GetOptions, tooltip)
                Settings.SetOnValueChangedCallback(cvar_name, OnSettingChanged)               
            elseif tonumber(defaultValue) ~= nil then
                local setting = Settings.RegisterAddOnSetting(category, name, cvar_name, type(defaultValue), defaultValue);
                local options = Settings.CreateSliderOptions(0, 100, 1);
                options:SetLabelFormatter(MinimalSliderWithSteppersMixin.Label.Right);
                Settings.CreateSlider(category, setting, options, tooltip);
                Settings.SetOnValueChangedCallback(cvar_name, OnSettingChanged);
            else
                local setting = Settings.RegisterAddOnSetting(category, name, cvar_name, type(defaultValue), defaultValue);
                Settings.CreateCheckboxWithOptions(category, setting, nil, tooltip)
                Settings.SetOnValueChangedCallback(cvar_name, OnSettingChanged);
            end
        end
    end

    Settings.RegisterAddOnCategory(category)
end
