local _, ns = ...;
local Options_Default = {
    Version = 240910,
    PlaySound = true,
    AlwaysShowButtons = false,
    SoundVolume = 50,
    SoundCooldown = 15,
    EnableTTS = true,
    SlotNameTTS = true,
    TTS_ID = -1,
    Aware_ASMOD_Cooldown = 5,
    Aware_PowerBar = true,
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
        ACDP_Options[variable] = value;
        ns.options[variable] = value;
    end

    local category = Settings.RegisterVerticalLayoutCategory("asCooldownPulse")

    if ACDP_Options == nil or Options_Default.Version ~= ACDP_Options.Version then
        ACDP_Options = {};
        ACDP_Options = CopyTable(Options_Default);
    end

    ns.options = CopyTable(ACDP_Options);

    for variable, _ in pairs(Options_Default) do
        local name = variable;
        local cvar_name = "asCooldownPulse_" .. variable;
        local tooltip = ""
        if ACDP_Options[variable] == nil then
            ACDP_Options[variable] = Options_Default[variable];
            ns.options[variable] = Options_Default[variable];
        end
        local defaultValue = ACDP_Options[variable];

        if name ~= "Version" then
            if name == "TTS_ID" then
                local function GetOptions()
                    local container = Settings.CreateControlTextContainer()

                    local ttsinfos = C_VoiceChat.GetTtsVoices();
                    for id, v in pairs(ttsinfos) do
                        container:Add(v.voiceID, v.name);
                    end
                    return container:GetData()
                end

                if defaultValue < 0 then
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
                            defaultValue = v.voiceID;
                            ACDP_Options[variable] = defaultValue;
                            ns.options[variable] = defaultValue;
                        end
                    end
                end

                local setting = Settings.RegisterAddOnSetting(category, cvar_name,  variable, tempoption, type(defaultValue), name, defaultValue);

                Settings.CreateDropdown(category, setting, GetOptions, tooltip)
                Settings.SetOnValueChangedCallback(cvar_name, OnSettingChanged)
            elseif tonumber(defaultValue) ~= nil then
                local setting = Settings.RegisterAddOnSetting(category, cvar_name,  variable, tempoption, type(defaultValue), name, defaultValue);
                local options = Settings.CreateSliderOptions(0, 100, 1);
                options:SetLabelFormatter(MinimalSliderWithSteppersMixin.Label.Right);
                Settings.CreateSlider(category, setting, options, tooltip);
                Settings.SetOnValueChangedCallback(cvar_name, OnSettingChanged);
            else
                local setting = Settings.RegisterAddOnSetting(category, cvar_name,  variable, tempoption, type(defaultValue), name, defaultValue);

                Settings.CreateCheckboxWithOptions(category, setting, nil, tooltip);
                Settings.SetOnValueChangedCallback(cvar_name, OnSettingChanged);
            end
        end
    end

    Settings.RegisterAddOnCategory(category)
end
