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

	print ("[asMOD] 개인 자원바를 끕니다.");
	SetCVar("nameplateShowSelf", "0");

	print ("[asMOD] 공격대창 직업 색상 표시");
	SetCVar("raidFramesDisplayClassColor", 1)
	

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

	print ("[asMOD] Skada, DBM 설정을 합니다.");

	SkadaDB = {
		["profiles"] = {
			["Default"] = {
				["windows"] = {
					{
						["y"] = 0,
						["barfont"] = "기본 글꼴",
						["background"] = {
							["height"] = 200,
						},
						["barfontsize"] = 10,
						["point"] = "BOTTOMRIGHT",
						["mode"] = "피해",
						["barwidth"] = 230,
						["x"] = 0,
					}, -- [1]
				},
				["versions"] = {
					["1.6.3"] = true,
					["1.8.0"] = true,
					["1.6.4"] = true,
					["1.6.7"] = true,
				},
				["modeclicks"] = {
					["DPS"] = 1,
				},
			},
		},
	}


	DBM_AllSavedOptions = {
		["Default"] = {
			["DontShowFarWarnings"] = true,
			["SpecialWarningFlashAlph2"] = 0.3,
			["DontShowHudMap2"] = false,
			["AlwaysPlayVoice"] = false,
			["ShowSWarningsInChat"] = false,
			["SpamSpecRoledefensive"] = false,
			["RangeFrameRadarY"] = 219.4961395263672,
			["SpamSpecRolestack"] = false,
			["DontRestoreIcons"] = false,
			["DontShowNameplateIcons"] = false,
			["SpecialWarningFlash5"] = true,
			["RangeFrameX"] = 50,
			["RangeFrameY"] = -50,
			["FilterInterruptNoteName"] = false,
			["EnableModels"] = false,
			["SpecialWarningFlashAlph3"] = 0.4,
			["SpecialWarningVibrate3"] = true,
			["SWarnNameInNote"] = true,
			["SpecialWarningSound2"] = 15391,
			["InfoFramePoint"] = "BOTTOMRIGHT",
			["EventSoundMusicCombined"] = false,
			["SpecialWarningFlashCol2"] = {
				1, -- [1]
				0.5, -- [2]
				0, -- [3]
			},
			["WarningAlphabetical"] = false,
			["WarningFont"] = "standardFont",
			["CheckGear"] = false,
			["SpecialWarningX"] = -3.792745351791382,
			["WorldBossAlert"] = false,
			["DontShowPT2"] = false,
			["GroupOptionsBySpell"] = true,
			["WorldBuffAlert"] = false,
			["SpamSpecRoledispel"] = false,
			["SpecialWarningFlashCount4"] = 2,
			["FilterTrashWarnings2"] = true,
			["DontShowPTCountdownText"] = false,
			["MoviesSeen"] = {
			},
			["DisableGuildStatus"] = false,
			["ShowQueuePop"] = true,
			["ShowAllVersions"] = false,
			["SpecialWarningSound3"] = "Interface\\AddOns\\DBM-Core\\sounds\\AirHorn.ogg",
			["DontShowTargetAnnouncements"] = true,
			["ShowWarningsInChat"] = false,
			["WarningFontStyle"] = "None",
			["ShowReminders"] = false,
			["ChosenVoicePack2"] = "None",
			["InfoFrameFontStyle"] = "None",
			["EventSoundEngage2"] = "None",
			["SpecialWarningVibrate1"] = false,
			["VPReplacesSA1"] = true,
			["InfoFrameY"] = -0,
			["SpecialWarningSound"] = 8174,
			["WarningIconRight"] = false,
			["UseSoundChannel"] = "Master",
			["ShowGuildMessages"] = false,
			["EventSoundMusic"] = "None",
			["RangeFrameRadarX"] = 0,
			["ShowRespawn"] = true,
			["SpamSpecRolesoak"] = false,
			["SpecialWarningPoint"] = "CENTER",
			["EventSoundWipe"] = "None",
			["InfoFrameCols"] = 0,
			["LogCurrentRaids"] = false,
			["ShowGuildMessagesPlus"] = false,
			["SpecialWarningFlashDura1"] = 0.3,
			["VPReplacesSA3"] = true,
			["DontShowPTNoID"] = false,
			["AutoReplySound"] = false,
			["HideBossEmoteFrame2"] = true,
			["SpecialWarningFlashCol5"] = {
				0.2, -- [1]
				1, -- [2]
				1, -- [3]
			},
			["AlwaysShowSpeedKillTimer2"] = false,
			["LatencyThreshold"] = 250,
			["SpecialWarningFlash3"] = true,
			["DebugLevel"] = 1,
			["LFDEnhance"] = false,
			["BadTimerAlert"] = false,
			["LogCurrentMythicRaids"] = false,
			["HideGarrisonToasts"] = true,
			["ArrowPosY"] = -150,
			["GUIHeight"] = 600,
			["SpecialWarningFontShadow"] = false,
			["EventMusicMythicFilter"] = false,
			["RLReadyCheckSound"] = false,
			["RangeFrameSound2"] = "none",
			["NPAuraSize"] = 40,
			["HideObjectivesFrame"] = true,
			["SpecialWarningShortText"] = true,
			["SpamSpecRoleinterrupt"] = false,
			["DontShowPTText"] = false,
			["UseNameplateHandoff"] = true,
			["SpecialWarningVibrate4"] = true,
			["SpecialWarningFontSize2"] = 15.30293083190918,
			["DontShowSpecialWarningText"] = false,
			["NewsMessageShown2"] = 1,
			["DontPlayTrivialSpecialWarningSound"] = true,
			["EventSoundPullTimer"] = "None",
			["PullVoice"] = "Corsica",
			["WarningPoint"] = "CENTER",
			["ArrowPoint"] = "TOP",
			["SpecialWarningFlashAlph4"] = 0.4,
			["SpecialWarningVibrate2"] = false,
			["SWarnClassColor"] = true,
			["PTCountThreshold2"] = 5,
			["SpecialWarningFlashCount2"] = 1,
			["VPReplacesAnnounce"] = true,
			["EventSoundDungeonBGM"] = "None",
			["oRA3AnnounceConsumables"] = false,
			["CountdownVoice2"] = "Kolt",
			["AutoAcceptGuildInvite"] = false,
			["EnableWBSharing"] = true,
			["VPReplacesCustom"] = false,
			["VPReplacesSA4"] = true,
			["AITimer"] = true,
			["LogTWDungeons"] = false,
			["WarningShortText"] = true,
			["DontShowBossAnnounces"] = false,
			["InfoFrameLines"] = 0,
			["SpecialWarningSound4"] = 9278,
			["SpecialWarningVibrate5"] = true,
			["GUIX"] = 0,
			["DisableSFX"] = false,
			["AutologBosses"] = false,
			["LogCurrentHeroic"] = false,
			["SpecialWarningFlashCount5"] = 3,
			["VPDontMuteSounds"] = false,
			["SpecialWarningFlashCol3"] = {
				1, -- [1]
				0, -- [2]
				0, -- [3]
			},
			["WarningColors"] = {
				{
					["r"] = 0.4117647409439087,
					["g"] = 0.8000000715255737,
					["b"] = 0.9411765336990356,
				}, -- [1]
				{
					["r"] = 0.9490196704864502,
					["g"] = 0.9490196704864502,
					["b"] = 0,
				}, -- [2]
				{
					["r"] = 1,
					["g"] = 0.501960813999176,
					["b"] = 0,
				}, -- [3]
				{
					["r"] = 1,
					["g"] = 0.1019607931375504,
					["b"] = 0.1019607931375504,
				}, -- [4]
			},
			["CoreSavedRevision"] = 20221206225337,
			["SWarningAlphabetical"] = true,
			["SpecialWarningFlash4"] = true,
			["BlockNoteShare"] = false,
			["SpecialWarningY"] = 165.0740356445313,
			["LogTrivialDungeons"] = false,
			["DontPlaySpecialWarningSound"] = false,
			["ModelSoundValue"] = "Short",
			["WarningY"] = 260,
			["WarningFontShadow"] = true,
			["LogCurrentMPlus"] = false,
			["RangeFrameRadarPoint"] = "BOTTOMRIGHT",
			["DontShowInfoFrame"] = true,
			["ShowEngageMessage"] = false,
			["VPReplacesSA2"] = true,
			["RangeFrameUpdates"] = "Average",
			["MovieFilter2"] = "Never",
			["DontShowRangeFrame"] = true,
			["RaidWarningSound"] = 11742,
			["DontRestoreRange"] = false,
			["WarningFontSize"] = 13.81205558776856,
			["SpecialWarningFlashCount3"] = 3,
			["RoleSpecAlert"] = false,
			["WhisperStats"] = false,
			["SilentMode"] = false,
			["EventSoundVictory2"] = "Interface\\AddOns\\DBM-Core\\sounds\\Victory\\SmoothMcGroove_Fanfare.ogg",
			["DontPlayPTCountdown"] = false,
			["SpecialWarningFlashAlph5"] = 0.5,
			["SpecialWarningDuration2"] = 1.5,
			["DoNotLogLFG"] = true,
			["SpecialWarningFlashDura2"] = 0.4,
			["WarningIconLeft"] = true,
			["RangeFrameSound1"] = "none",
			["LastRevision"] = 0,
			["DontDoSpecialWarningVibrate"] = false,
			["SpamSpecRolegtfo"] = false,
			["AutoExpandSpellGroups"] = false,
			["LogTrivialRaids"] = false,
			["GUIPoint"] = "TOPRIGHT",
			["SettingsMessageShown"] = true,
			["SpecialWarningFlashCol4"] = {
				1, -- [1]
				0, -- [2]
				1, -- [3]
			},
			["SpamSpecRoleswitch"] = false,
			["SpecialWarningFlash1"] = true,
			["GroupOptionsExcludeIcon"] = false,
			["DontSetIcons"] = false,
			["SpecialWarningFlashDura3"] = 1,
			["SpecialWarningFlashDura4"] = 0.7,
			["CountdownVoice"] = "Corsica",
			["AutoRespond"] = true,
			["DontShowUserTimers"] = false,
			["CountdownVoice3"] = "Smooth",
			["SpecialWarningFlashDura5"] = 1,
			["RecordOnlyBosses"] = false,
			["DisableStatusWhisper"] = false,
			["EventDungMusicMythicFilter"] = false,
			["GUIY"] = -79.25929260253906,
			["RangeFrameFrames"] = "radar",
			["DontPlayCountdowns"] = false,
			["SpecialWarningFlash2"] = true,
			["SpecialWarningIcon"] = true,
			["InfoFrameFont"] = "standardFont",
			["SpecialWarningFlashAlph1"] = 0.3,
			["ShowDefeatMessage"] = false,
			["FilterTankSpec"] = true,
			["WarningDuration2"] = 1.5,
			["RangeFrameLocked"] = false,
			["InfoFrameShowSelf"] = false,
			["SpecialWarningFont"] = "standardFont",
			["ShortTimerText"] = true,
			["CustomSounds"] = 0,
			["DontShowBossTimers"] = false,
			["SpecialWarningFontStyle"] = "THICKOUTLINE",
			["DontShowSpecialWarningFlash"] = false,
			["InfoFrameFontSize"] = 12,
			["SpecialWarningFontCol"] = {
				1, -- [1]
				0.7, -- [2]
				0, -- [3]
			},
			["WorldBossNearAlert"] = false,
			["WarningX"] = 0,
			["BadIDAlert"] = false,
			["ArrowPosX"] = 0,
			["AutoAcceptFriendInvite"] = false,
			["WarningIconChat"] = false,
			["SpecialWarningFlashCount1"] = 1,
			["HideGuildChallengeUpdates"] = true,
			["SpecialWarningSound5"] = 128466,
			["DontSendYells"] = false,
			["ShowPizzaMessage"] = false,
			["AdvancedAutologBosses"] = false,
			["HideTooltips"] = false,
			["LogCurrentMythicZero"] = false,
			["SpecialWarningFlashCol1"] = {
				1, -- [1]
				1, -- [2]
				0, -- [3]
			},
			["Enabled"] = true,
			["RangeFramePoint"] = "CENTER",
			["GUIWidth"] = 800,
			["FilterVoidFormSay"] = true,
			["FilterDispel"] = true,
			["SpamSpecInformationalOnly"] = false,
			["SpamSpecRoletaunt"] = false,
			["InfoFrameX"] = -233.86669921875,
			["StripServerName"] = true,
			["FakeBWVersion"] = false,
			["ChatFrame"] = "DEFAULT_CHAT_FRAME",
			["LogTWRaids"] = false,
			["DebugMode"] = false,
			["AFKHealthWarning"] = false,
			["FilterInterrupt2"] = "TandFandBossCooldown",
			["HelpMessageVersion"] = 3,
		},
	}
	DBM_MinimapIcon = {
		["minimapPos"] = 18.22282104994326,
	}
	
	
DBT_AllPersistentOptions = {
	["Default"] = {
		["DBM"] = {
			["StartColorPR"] = 1,
			["Scale"] = 0.9,
			["HugeBarsEnabled"] = true,
			["StartColorR"] = 1,
			["EndColorPR"] = 0.5,
			["Sort"] = "Sort",
			["ExpandUpwardsLarge"] = false,
			["ExpandUpwards"] = false,
			["TimerPoint"] = "BOTTOMRIGHT",
			["EndColorDG"] = 0,
			["Alpha"] = 0.8,
			["HugeTimerPoint"] = "CENTER",
			["StartColorIR"] = 0.47,
			["StartColorUIR"] = 1,
			["StartColorAG"] = 0.545,
			["EndColorDR"] = 1,
			["TDecimal"] = 11,
			["StartColorRR"] = 0.5,
			["StartColorUIG"] = 1,
			["FillUpLargeBars"] = true,
			["HugeScale"] = 1.03,
			["BarYOffset"] = 0,
			["StartColorDG"] = 0.3,
			["StartColorAR"] = 0.375,
			["TextColorR"] = 1,
			["EndColorAER"] = 1,
			["StartColorIB"] = 1,
			["ClickThrough"] = false,
			["Font"] = "standardFont",
			["Skin"] = "",
			["EndColorAEB"] = 0.247,
			["Height"] = 20,
			["HugeSort"] = "Invert",
			["BarXOffset"] = 0,
			["EndColorB"] = 0,
			["EndColorAR"] = 0.15,
			["EndColorG"] = 0,
			["HugeBarXOffset"] = 0,
			["StartColorB"] = 0,
			["StartColorAEG"] = 0.466,
			["FadeBars"] = true,
			["TextColorB"] = 1,
			["EndColorIB"] = 1,
			["StartColorAER"] = 1,
			["InlineIcons"] = true,
			["EndColorRB"] = 0.3,
			["TimerX"] = -313.54833984375,
			["EndColorIR"] = 0.047,
			["Bar7ForceLarge"] = false,
			["EndColorRR"] = 0.11,
			["DynamicColor"] = true,
			["BarStyle"] = "NoAnim",
			["EnlargeBarTime"] = 11,
			["Spark"] = true,
			["StartColorDR"] = 0.9,
			["StartColorPB"] = 0.42,
			["FontFlag"] = "None",
			["EndColorAB"] = 1,
			["IconLocked"] = true,
			["EndColorPG"] = 0.41,
			["HugeHeight"] = 17,
			["EndColorIG"] = 0.88,
			["EndColorAEG"] = 0.043,
			["EndColorPB"] = 0.285,
			["StartColorAEB"] = 0.459,
			["FontSize"] = 10,
			["TextColorG"] = 1,
			["KeepBars"] = true,
			["HugeTimerX"] = -325.2148742675781,
			["HugeTimerY"] = -24.71101760864258,
			["HugeAlpha"] = 1,
			["IconLeft"] = true,
			["ColorByType"] = true,
			["HugeWidth"] = 100,
			["HugeBarYOffset"] = 0,
			["DesaturateValue"] = 1,
			["StartColorAB"] = 1,
			["FillUpBars"] = true,
			["TimerY"] = 221.1336822509766,
			["Bar7CustomInline"] = true,
			["EndColorUIB"] = 0.0117647058823529,
			["EndColorUIG"] = 0.92156862745098,
			["FlashBar"] = false,
			["EndColorUIR"] = 1,
			["EndColorRG"] = 1,
			["StartColorUIB"] = 0.0627450980392157,
			["StartColorG"] = 0.7,
			["Texture"] = "Interface\\Addons\\Skada\\media\\statusbar\\BantoBar",
			["StartColorPG"] = 0.776,
			["EndColorR"] = 1,
			["StartColorRG"] = 1,
			["Width"] = 183,
			["StartColorRB"] = 0.5,
			["EndColorAG"] = 0.385,
			["NoBarFade"] = false,
			["StartColorDB"] = 1,
			["StartColorIG"] = 0.97,
			["EndColorDB"] = 1,
			["IconRight"] = false,
		},
	},
}

	

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

