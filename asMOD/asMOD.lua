local asMOD;
local asMOD_UIScale = 0.75;
local asMOD_CurrVersion = 181201;
local bAction = false;
asMOD_t_position = {};

if not asMOD_position then
    asMOD_position = {}
end


local function asMOD_Setup()

	local curr = GetCVar("uiScale");
	
	if curr then
		curr = tonumber(curr);
	else
		curr = 1;
	end

	print ("[asMOD] UI Scale 을 조정합니다.");
	SetCVar("useUiScale", "1");

	if asMOD_UIScale then
		if (asMOD_UIScale < 0.64) then
			UIParent:SetScale(asMOD_UIScale)
		else
			SetCVar("uiScale", asMOD_UIScale)
		end
	end

	LoadAddOn("Skada")
	LoadAddOn("DBM-Core")
	LoadAddOn("DBM-StatusBarTimers")



	print ("[asMOD] 재사용 대기시간을 보이게 합니다.");
	SetCVar("countdownForCooldowns", "1");

	print ("[asMOD] 전투 메시지를 보이게 합니다.");
	SetCVar("enableFloatingCombatText", "1");

	print ("[asMOD] 개인 자원바를 끕니다.");
	SetCVar("nameplateShowSelf", "0");

	print ("[asMOD] 최대 시야 거리를 설정 합니다.");
	SetCVar("cameraDistanceMaxZoomFactor", "2.6");

	print ("[asMOD] 힐량와 데미지를 보이게 합니다.");
	SetCVar("floatingCombatTextCombatHealing", 1);
	SetCVar("floatingCombatTextCombatDamage", 1);

	print ("[asMOD] 자동룻 옵션");
	SetCVar("autoLootDefault", 1)

	print ("[asMOD] 이름표 항상 표시");
	SetCVar("nameplateShowAll", 1)
	SetCVar("nameplateShowEnemies", 1)
	SetCVar("nameplateShowFriends", 0)
	SetCVar("nameplateShowFriendlyNPCs", 0)


	print ("[asMOD] Unit Frame 설정 변경");
	SetCVar("showTargetOfTarget", 1)	

	print ("[asMOD] 채팅창에 직업색상을 표시하게 합니다.");
	ToggleChatColorNamesByClassGroup(true, "SAY")
	ToggleChatColorNamesByClassGroup(true, "EMOTE")
	ToggleChatColorNamesByClassGroup(true, "YELL")
	ToggleChatColorNamesByClassGroup(true, "GUILD")
	ToggleChatColorNamesByClassGroup(true, "OFFICER")
	ToggleChatColorNamesByClassGroup(true, "GUILD_ACHIEVEMENT")
	ToggleChatColorNamesByClassGroup(true, "ACHIEVEMENT")
	ToggleChatColorNamesByClassGroup(true, "WHISPER")
	ToggleChatColorNamesByClassGroup(true, "PARTY")
	ToggleChatColorNamesByClassGroup(true, "PARTY_LEADER")
	ToggleChatColorNamesByClassGroup(true, "RAID")
	ToggleChatColorNamesByClassGroup(true, "RAID_LEADER")
	ToggleChatColorNamesByClassGroup(true, "RAID_WARNING")
	ToggleChatColorNamesByClassGroup(true, "INSTANCE_CHAT")
	ToggleChatColorNamesByClassGroup(true, "INSTANCE_CHAT_LEADER")	

--[[
	print ("[asMOD] 기본 공격대 프레임 설정을 합니다.");

	SetCVar("useCompactPartyFrames", 1);
	LoadAddOn("Blizzard_CUFProfiles")

	if CompactUnitFrameProfiles.selectedProfile then 
		SetRaidProfileOption(CompactUnitFrameProfiles.selectedProfile, "useClassColors", true)
		SetRaidProfileOption(CompactUnitFrameProfiles.selectedProfile, "displayPowerBar", false)
		SetRaidProfileOption(CompactUnitFrameProfiles.selectedProfile, "displayBorder", false)
		SetRaidProfileOption(CompactUnitFrameProfiles.selectedProfile, "keepGroupsTogether", true)
		SetRaidProfileOption(CompactUnitFrameProfiles.selectedProfile, "displayMainTankAndAssist", false)
		CompactUnitFrameProfiles_ApplyCurrentSettings()
		CompactUnitFrameProfiles_UpdateCurrentPanel()
	end

	print ("[asMOD] Skada, DBM 설정을 합니다.");

	SkadaDB = {
	["profiles"] = {
		["Default"] = {
			["showself"] = true,
			["modeclicks"] = {
				["피해"] = 1,
			},
			["modulesBlocked"] = {
				["Debuffs"] = true,
				["CC"] = true,
				["Power"] = true,
				["Healing"] = false,
				["DamageTaken"] = false,
				["Themes"] = true,
				["Tweaks"] = false,
				["Overhealing"] = true,
				["Interrupts"] = true,
				["Threat"] = true,
				["Enemies"] = true,
				["Deaths"] = true,
				["Dispels"] = true,
			},
			["windows"] = {
				{
					["y"] = 0,
					["barfont"] = "기본 글꼴",
					["point"] = "BOTTOMRIGHT",
					["barfontsize"] = 11,
					["mode"] = "피해",
					["barwidth"] = 228,
					["background"] = {
						["height"] = 203,
					},
					["x"] = 0,
				}, -- [1]
			},
			["columns"] = {
				["총 치유_Percent"] = false,
			},
			["updatefrequency"] = 0.5,
			["versions"] = {
				["1.6.7"] = true,
				["1.6.4"] = true,
				["1.6.3"] = true,
			},
			["hidedisables"] = false,
			["sortmodesbyusage"] = false,
			["onlykeepbosses"] = true,
		},
	},
}


DBM_AllSavedOptions = {
	["Default"] = {
		["HUDTextureOverride"] = false,
		["DontShowFarWarnings"] = true,
		["ChosenVoicePack"] = "Mununyu",
		["DontShowHudMap2"] = true,
		["AlwaysPlayVoice"] = false,
		["ShowSWarningsInChat"] = false,
		["DontShowNameplateLines"] = false,
		["RangeFrameRadarY"] = 0,
		["HUDAlpha1"] = 0.5,
		["StatusEnabled"] = true,
		["InfoFrameX"] = 0,
		["DontShowNameplateIcons"] = true,
		["CoreSavedRevision"] = 20190807031920,
		["RangeFrameX"] = -50,
		["AlwaysShowSpeedKillTimer"] = true,
		["RangeFrameY"] = -50,
		["FilterSayAndYell"] = false,
		["EnableModels"] = true,
		["SpecialWarningFlashAlph3"] = 0.4,
		["ArrowPoint"] = "TOP",
		["SWarnNameInNote"] = true,
		["FakeBWVersion"] = false,
		["InfoFramePoint"] = "RIGHT",
		["CRT_Enabled"] = false,
		["EventSoundMusicCombined"] = false,
		["SpecialWarningFlashCol2"] = {
			1, -- [1]
			0.5, -- [2]
			0, -- [3]
		},
		["WarningAlphabetical"] = true,
		["WarningFont"] = "Fonts\\2002.TTF",
		["CheckGear"] = true,
		["SpecialWarningX"] = 0,
		["WorldBossAlert"] = false,
		["HUDSize3"] = 5,
		["DontShowPT2"] = false,
		["MCMessageShown"] = false,
		["DontShowSpecialWarnings"] = false,
		["ShowFlashFrame"] = false,
		["ShowMinimapButton"] = true,
		["MoviesSeen"] = {
			[686] = true,
			[688] = true,
			[917] = true,
		},
		["HUDColor1"] = {
			1, -- [1]
			1, -- [2]
			0, -- [3]
		},
		["ShowQueuePop"] = true,
		["ShowAllVersions"] = false,
		["DebugMode"] = false,
		["DontShowTargetAnnouncements"] = true,
		["ShowWarningsInChat"] = false,
		["InfoFrameLocked"] = true,
		["DontRestoreIcons"] = false,
		["SpecialWarningFontCol"] = {
			1, -- [1]
			0.7, -- [2]
			0, -- [3]
		},
		["SpecialWarningPoint"] = "CENTER",
		["FilterInterruptNoteName"] = false,
		["WarningFontStyle"] = "None",
		["EventSoundEngage2"] = "None",
		["InfoFrameY"] = -221.643371582031,
		["ChatFrame"] = "DEFAULT_CHAT_FRAME",
		["WarningIconRight"] = true,
		["UseSoundChannel"] = "Dialog",
		["EventSoundTurle"] = "None",
		["StripServerName"] = true,
		["RangeFrameRadarX"] = -230,
		["SpecialWarningDuration"] = 4,
		["LogOnlyRaidBosses"] = false,
		["SpamBlockBossWhispers"] = true,
		["HideQuestTooltips"] = true,
		["ShowRespawn"] = true,
		["FilterTrashWarnings2"] = true,
		["DisableGuildStatus"] = false,
		["BCTWMessageShown"] = false,
		["WarningPoint"] = "CENTER",
		["FilterDispel"] = true,
		["ArrowPosY"] = -150,
		["HideBossEmoteFrame2"] = true,
		["HUDSize2"] = 5,
		["AlwaysShowSpeedKillTimer2"] = false,
		["LatencyThreshold"] = 250,
		["HideTooltips"] = false,
		["DontShowHealthFrame"] = true,
		["LFDEnhance"] = true,
		["SpecialWarningFlashDura1"] = 0.4,
		["DontShowPTNoID"] = false,
		["HideGarrisonToasts"] = true,
		["RangeFramePoint"] = "BOTTOMRIGHT",
		["PGMessageShown2"] = false,
		["SpecialWarningFontShadow"] = false,
		["EventMusicMythicFilter"] = true,
		["AutoReplySound"] = true,
		["RangeFrameSound2"] = "none",
		["WOTLKTWMessageShown"] = false,
		["HideObjectivesFrame"] = true,
		["SpecialWarningFlashCol1"] = {
			1, -- [1]
			1, -- [2]
			0, -- [3]
		},
		["ShowPizzaMessage"] = false,
		["DontShowPTText"] = false,
		["SpecialWarningFlashAlph2"] = 0.3,
		["SpecialWarningSound5"] = 128466,
		["SpecialWarningFontSize2"] = 26,
		["DontShowSpecialWarningText"] = false,
		["ShowGuildMessages"] = false,
		["HUDTexture3"] = "highlight",
		["SpecialWarningFlashDura5"] = 1,
		["SpecialWarningSound2"] = 15391,
		["SpecialWarningSound"] = 8174,
		["AlwaysShowHealthFrame"] = false,
		["SpecialWarningFlashAlph4"] = 0.4,
		["InfoFrameLines"] = 0,
		["SpecialWarningSound3"] = "Interface\\AddOns\\DBM-Core\\sounds\\AirHorn.ogg",
		["PTCountThreshold2"] = 5,
		["HealthFrameLocked"] = false,
		["EventSoundDungeonBGM"] = "None",
		["HUDSizeOverride"] = false,
		["HUDColorOverride"] = false,
		["CountdownVoice2"] = "VP:Mununyu",
		["AutoAcceptGuildInvite"] = false,
		["DontShowFlexMessage"] = false,
		["ArrowPosX"] = 0,
		["HUDSize1"] = 5,
		["AITimer"] = true,
		["SpecialWarningFlashDura3"] = 1,
		["MovieFilter"] = "AfterFirst",
		["HPFramePoint"] = "CENTER",
		["SpecialWarningFlashCol4"] = {
			1, -- [1]
			0, -- [2]
			1, -- [3]
		},
		["SpecialWarningSound4"] = 9278,
		["HUDAlpha2"] = 0.5,
		["WarningFontShadow"] = true,
		["DisableSFX"] = false,
		["AutologBosses"] = false,
		["SpecialWarningFlashDura4"] = 0.7,
		["WarningDuration"] = 4,
		["HUDColor3"] = {
			1, -- [1]
			0.5, -- [2]
			0, -- [3]
		},
		["SpecialWarningFlashCol3"] = {
			1, -- [1]
			0, -- [2]
			0, -- [3]
		},
		["WarningColors"] = {
			{
				["b"] = 0.9411764705882353,
				["g"] = 0.8,
				["r"] = 0.4117647058823529,
			}, -- [1]
			{
				["b"] = 0,
				["g"] = 0.9490196078431372,
				["r"] = 0.9490196078431372,
			}, -- [2]
			{
				["b"] = 0,
				["g"] = 0.5019607843137255,
				["r"] = 1,
			}, -- [3]
			{
				["b"] = 0.1019607843137255,
				["g"] = 0.1019607843137255,
				["r"] = 1,
			}, -- [4]
		},
		["DontShowRangeFrame"] = true,
		["SWarningAlphabetical"] = true,
		["FilterTankSpec"] = true,
		["BlockNoteShare"] = false,
		["FilterInterrupt"] = true,
		["SpecialWarningY"] = 186,
		["MovieFilter2"] = "OnlyFight",
		["ModelSoundValue"] = "Short",
		["FilterSelfHud"] = true,
		["DontRestoreRange"] = false,
		["HUDTexture2"] = "highlight",
		["RangeFrameRadarPoint"] = "BOTTOMRIGHT",
		["DontShowInfoFrame"] = false,
		["MISTSTWMessageShown"] = false,
		["DontPlayCountdowns"] = false,
		["RangeFrameUpdates"] = "Average",
		["AutoCorrectTimer"] = false,
		["RangeFrameFrames"] = "radar",
		["WarningY"] = 260,
		["CustomSounds"] = 0,
		["HUDAlpha3"] = 0.5,
		["SpecialWarningFlashRepeat3"] = true,
		["ShortTimerText"] = true,
		["WhisperStats"] = false,
		["VoiceOverSpecW2"] = "DefaultOnly",
		["HealthFrameGrowUp"] = false,
		["DontPlayPTCountdown"] = false,
		["SpecialWarningFlashAlph5"] = 0.5,
		["SpecialWarningDuration2"] = 1.5,
		["HealthFrameWidth"] = 200,
		["DisableStatusWhisper"] = false,
		["WarningIconLeft"] = true,
		["RangeFrameLocked"] = false,
		["HPFrameY"] = 50,
		["WarningFontSize"] = 20,
		["EventSoundVictory2"] = "None",
		["SpecialWarningFlashDura2"] = 0.4,
		["LastRevision"] = 0,
		["ShowEngageMessage"] = false,
		["SettingsMessageShown"] = true,
		["PGMessageShown"] = false,
		["DontShowBossAnnounces"] = false,
		["SpecialWarningFlashRepeat2"] = false,
		["RaidWarningSound"] = 11742,
		["DontSetIcons"] = false,
		["BigBrotherAnnounceToRaid"] = false,
		["CountdownVoice"] = "VP:Mununyu",
		["SpecialWarningFlashRepeat4"] = false,
		["BonusFilter"] = "Never",
		["DontShowUserTimers"] = false,
		["CountdownVoice3"] = "VP:Mununyu",
		["RoleSpecAlert"] = true,
		["SpecialWarningFlashRepeat5"] = true,
		["AutoRespond"] = true,
		["EventDungMusicMythicFilter"] = true,
		["RangeFrameSound1"] = "none",
		["HideBossEmoteFrame"] = true,
		["HUDTexture1"] = "highlight",
		["ShowBigBrotherOnCombatStart"] = false,
		["SpecialWarningIcon"] = true,
		["CountdownVoice3v2"] = "Corsica",
		["SpecialWarningFlashAlph1"] = 0.3,
		["ShowDefeatMessage"] = false,
		["HUDAlphaOverride"] = false,
		["WarningDuration2"] = 1.5,
		["HUDSize4"] = 5,
		["InfoFrameShowSelf"] = false,
		["SpecialWarningFont"] = "Fonts\\2002.TTF",
		["HUDColor2"] = {
			1, -- [1]
			0, -- [2]
			0, -- [3]
		},
		["SpecialWarningFontStyle"] = "THICKOUTLINE",
		["DontShowBossTimers"] = false,
		["HUDTexture4"] = "highlight",
		["DontShowPTCountdownText"] = false,
		["SWarnClassColor"] = true,
		["WarningX"] = 0,
		["WorldBossNearAlert"] = false,
		["HPFrameMaxEntries"] = 5,
		["HUDColor4"] = {
			0, -- [1]
			1, -- [2]
			0, -- [3]
		},
		["SpecialWarningFlashRepeatAmount"] = 2,
		["AutoAcceptFriendInvite"] = false,
		["WarningIconChat"] = false,
		["SpecialWarningFlashCol5"] = {
			0.2, -- [1]
			1, -- [2]
			1, -- [3]
		},
		["HideGuildChallengeUpdates"] = true,
		["DontShowCTCount"] = false,
		["DontSendYells"] = false,
		["HUDAlpha4"] = 0.5,
		["AdvancedAutologBosses"] = false,
		["SpecialWarningFlashRepeat1"] = false,
		["RLReadyCheckSound"] = true,
		["ShowGuildMessagesPlus"] = false,
		["Enabled"] = true,
		["DebugLevel"] = 1,
		["EventSoundEngage"] = "",
		["FilterVoidFormSay"] = true,
		["PTCountThreshold"] = 5,
		["EventSoundWipe"] = "None",
		["ForumsMessageShown"] = 16096,
		["NewsMessageShown"] = 12,
		["EventSoundMusic"] = "None",
		["ShowCountdownText"] = false,
		["DontShowReminders"] = false,
		["HPFrameX"] = -50,
		["FilterInterrupt2"] = "TandFandBossCooldown",
		["AFKHealthWarning"] = false,
		["CATATWMessageShown"] = false,
		["HelpMessageVersion"] = 3,
	},
}
DBM_MinimapIcon = {
	["minimapPos"] = 340.1155155406294,
}

DBT_AllPersistentOptions = {
	["Default"] = {
		["DBM"] = {
			["StartColorPR"] = 1,
			["Scale"] = 0.899999976158142,
			["EnlargeBarsPercent"] = 0.10,
			["TimerY"] = 223.98356628418,
			["EndColorPR"] = 0.501960784313726,
			["TimerPoint"] = "BOTTOMRIGHT",
			["EndColorDG"] = 0,
			["HugeTimerPoint"] = "CENTER",
			["StartColorIR"] = 0.470588235294118,
			["StartColorUIR"] = 1,
			["StartColorAG"] = 0.545098039215686,
			["EndColorDR"] = 1,
			["HugeBarXOffset"] = 0,
			["StartColorRR"] = 0.501960784313726,
			["StartColorUIG"] = 1,
			["HugeScale"] = 1.20,
			["BarYOffset"] = 0,
			["StartColorDG"] = 0.301960784313726,
			["StartColorAR"] = 0.376470588235294,
			["EndColorAER"] = 1,
			["StartColorIB"] = 1,
			["EndColorAEB"] = 0.247058823529412,
			["HugeTimerX"] = -320,
			["BarXOffset"] = 0,
			["EndColorB"] = 0,
			["EndColorDB"] = 1,
			["EndColorUIB"] = 0.0117647058823529,
			["Decimal"] = 60,
			["EndColorIB"] = 1,
			["EndColorRB"] = 0.301960784313726,
			["TimerX"] = -305.668060302734,
			["EndColorIR"] = 0.0470588235294118,
			["EndColorRR"] = 0.109803921568627,
			["EnlargeBarTime"] = 11,
			["StartColorPG"] = 0.776470588235294,
			["EndColorAB"] = 1,
			["Width"] = 170,
			["EndColorPG"] = 0.411764705882353,
			["EndColorIG"] = 0.87843137254902,
			["EndColorAEG"] = 0.0431372549019608,
			["StartColorAEB"] = 0.458823529411765,
			["HugeTimerY"] = 40.000030517578,
			["EndColorG"] = 0,
			["StartColorIG"] = 0.968627450980392,
			["StartColorAB"] = 1,
			["EndColorAR"] = 0.149019607843137,
			["StartColorB"] = 0,
			["FontSize"] = 10,
			["StartColorAER"] = 1,
			["StartColorAEG"] = 0.466666666666667,
			["HugeWidth"] = 110,
			["EndColorUIR"] = 1,
			["EndColorRG"] = 1,
			["StartColorUIB"] = 0.0627450980392157,
			["StartColorG"] = 0.701960784313726,
			["StartColorRG"] = 1,
			["StartColorDR"] = 0.901960784313726,
			["EndColorR"] = 1,
			["StartColorPB"] = 0.419607843137255,
			["EndColorUIG"] = 0.92156862745098,
			["StartColorRB"] = 0.501960784313726,
			["EndColorAG"] = 0.384313725490196,
			["EndColorPB"] = 0.286274509803922,
			["StartColorDB"] = 1,
			["HugeBarYOffset"] = 0,
			["StartColorR"] = 1,
			["Height"] = 20,
		},
	},
}

]]
	ReloadUI();


end

local function asMOD_Popup()
	StaticPopup_Show ("asMOD")
end


local function funcDragStop (self)

    local _, _, _, x, y =  self:GetPoint();
    self.text:SetText(self.addonName.."\n"..string.format("%5.1f", x).."\n"..string.format("%5.1f", y));
    self.StopMovingOrSizing(self);
end

local asMOD_AFFL_frame;
local asMOD_ACB_frame;
local asMOD_ASQA_frame;

local function setupFrame(frame, Name, addonName,  config)
    frame = CreateFrame("Frame", Name, UIParent)
    frame.addonName = addonName;
    frame.text = frame:CreateFontString(Name.."_Text", "OVERLAY")
    frame.text:SetFont("Fonts\\2002.TTF", 10, "OUTLINE")
    frame.text:SetPoint("CENTER", frame, "CENTER", 0, 0)
    frame.text:SetText(frame.addonName);
    frame:SetMovable(true)
    frame:EnableMouse(true)
    frame:RegisterForDrag("LeftButton")
    frame:SetScript("OnDragStart", frame.StartMoving)
    frame:SetScript("OnDragStop", funcDragStop);
    -- The code below makes the frame visible, and is not necessary to enable dragging.
    frame:SetPoint(config["anchor1"], config["parent"], config["anchor2"], config["x"], config["y"] );
    if config["width"] and config["width"] > 5 then
        frame:SetWidth(config["width"]); 
    else
        frame:SetWidth(64);
    end

    if config["height"] and config["height"] > 5  then
        frame:SetHeight(config["height"]);
    else
        frame:SetHeight(64);
    end

    local tex = frame:CreateTexture("ARTWORK");
    tex:SetAllPoints();
    tex:SetTexture(1.0, 0.5, 0); tex:SetAlpha(0.5);
    return frame
end


function asMOD_setupFrame(frame, addonName)

    local parent;
    asMOD_t_position[addonName] = {["name"] = addonName, ["parent"] = "UIParent", ["anchor1"] = "CENTER", ["anchor2"] = "CENTER", ["x"] = 0, ["y"] = 0, ["width"] = 0, ["height"] = 0};
    asMOD_t_position[addonName]["anchor1"], _ , asMOD_t_position[addonName]["anchor2"], asMOD_t_position[addonName]["x"], asMOD_t_position[addonName]["y"] = frame:GetPoint();
    asMOD_t_position[addonName]["width"] = frame:GetWidth();
    asMOD_t_position[addonName]["height"] = frame:GetHeight();

    if asMOD_position[addonName] then
        frame:ClearAllPoints();
        frame:SetPoint(asMOD_position[addonName]["anchor1"], asMOD_position[addonName]["parent"], asMOD_position[addonName]["anchor2"], asMOD_position[addonName]["x"], asMOD_position[addonName]["y"])
    end
end

local framelist = {};

local function asMOD_Popup_Config()

    for i,value in pairs(asMOD_t_position) do 

        local index = value["name"]

        if not asMOD_position[index] then
            asMOD_position[index] = asMOD_t_position[index]
        end
        framelist[index] = nil

        
        framelist[index] = setupFrame(framelist[index], "asMOD_frame".. index, index, asMOD_position[index]);

	end

    StaticPopup_Show ("asConfig")
end

local function asMOD_Cancel_Position()

    for i,value in pairs(asMOD_t_position) do 
		
        local index = value["name"]
        framelist[index]:Hide()

	end

end


local function asMOD_Setup_Position()

    for i,value in pairs(asMOD_t_position) do 
        local index = value["name"]
        asMOD_position[index]["anchor1"], _ ,  asMOD_position[index]["anchor2"], asMOD_position[index]["x"],  asMOD_position[index]["y"] =  framelist[index]:GetPoint();
	end
    asMOD_Cancel_Position();

   	ReloadUI();
end


local function asMOD_Popup_Clear()
    StaticPopup_Show ("asClear")
end

local function asMOD_Clear()
    asMOD_position = {};
  	ReloadUI();
end

function asMOD_OnEvent(self, event, arg1)

	if event == "ADDON_LOADED" and arg1 == "asMOD" then
		if not asMOD_version or asMOD_version ~= asMOD_CurrVersion then
			asMOD_Popup()
			asMOD_config = true;	
			asMOD_version = asMOD_CurrVersion;
		end

		DEFAULT_CHAT_FRAME:AddMessage("/asMOD : 최적화된 Interface 옵션 Setup")
        DEFAULT_CHAT_FRAME:AddMessage("/asConfig : asMOD 의 위치 조정")
        DEFAULT_CHAT_FRAME:AddMessage("/asClear : asMOD 기본 위치로 설정 초기화")

		SlashCmdList['asMOD'] = asMOD_Popup
        SlashCmdList['asConfig'] = asMOD_Popup_Config
        SlashCmdList['asClear'] = asMOD_Popup_Clear
		SLASH_asMOD1 = '/asMOD'
        SLASH_asConfig1 = '/asConfig'
        SLASH_asClear1 = '/asClear'
	end

	return;
end 

asMOD = CreateFrame("Frame")
asMOD:SetScript("OnEvent", asMOD_OnEvent)
asMOD:RegisterEvent("ADDON_LOADED")
asMOD:RegisterEvent("PLAYER_ENTERING_WORLD")


StaticPopupDialogs["asMOD"] = {
  text = "asMOD가 '기본 인터페이스 설정'을 변경합니다. \n채팅창에 '/asMOD'명령어로 기능을 다시 불러 올 수 있습니다.",
  button1 = "변경",
  button2 = "다음에",
  OnAccept = function()
      asMOD_Setup()
  end,
  timeout = 0,
  whileDead = true,
  hideOnEscape = true,
  preferredIndex = 3, 
}


StaticPopupDialogs["asConfig"] = {
  text = "asMOD 애드온의 위치를 조정 합니다. 완료를 누르면 위치가 저장 됩니다. 원치 않을 경우 취소를 누르세요",
  button1 = "완료",
  button2 = "취소",
  OnAccept = function()
      asMOD_Setup_Position()
  end,

  OnCancel = function (_,reason)
      asMOD_Cancel_Position(); 
  end,
  timeout = 0,
  whileDead = true,
  hideOnEscape = true,
  preferredIndex = 3, 
}


StaticPopupDialogs["asClear"] = {
  text = "asMOD 위치를 모두 기본으로 초기화 합니다.",
  button1 = "변경",
  button2 = "다음에",
  OnAccept = function()
      asMOD_Clear()
  end,
  timeout = 0,
  whileDead = true,
  hideOnEscape = true,
  preferredIndex = 3, 
}

