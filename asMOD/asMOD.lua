local _, ns = ...;
local version = select(4, GetBuildInfo());
local asMOD;
local asMOD_UIScale = 0.75;
local asMOD_CurrVersion = 250122;

if version >= 110105 then
	asMOD_CurrVersion = 250413;
end

local bAction = false;
asMOD_t_position = {};

if not asMOD_position then
	asMOD_position = {}
end

local detailsprofile = ns.detailsEn;
local layoutInfo;

if GetLocale() == "koKR" then
	detailsprofile = ns.detailsKr;
end

local function asMOD_Import_Layout(text, name)
	local importLayoutInfo = C_EditMode.ConvertStringToLayoutInfo(text);
	if not layoutInfo then
		layoutInfo = C_EditMode.GetLayouts();
	end

	if importLayoutInfo and layoutInfo then
		local layoutType = Enum.EditModeLayoutType.Account;
		importLayoutInfo.layoutType = layoutType;
		importLayoutInfo.layoutName = name;

		local newLayoutIndex = 1;

		for index, layout in ipairs(layoutInfo.layouts) do
			if layout.layoutType == layoutType and layout.layoutName == name then
				newLayoutIndex = 0;
				layoutInfo.layouts[index] = importLayoutInfo;
				break;
			else
				newLayoutIndex = newLayoutIndex + 1;
			end
		end

		if newLayoutIndex > 0 then
			table.insert(layoutInfo.layouts, newLayoutIndex, importLayoutInfo);
		end
	end
end

local function asMOD_Import_Commit()
	C_EditMode.SaveLayouts(layoutInfo);

	local layoutinfo = C_EditMode.GetLayouts()
	local index = nil;

	for i, element in ipairs(layoutinfo.layouts) do
		if element.layoutName == "asMOD_layout" then
			index = i;
			break;
		end
	end

	if index then
		C_EditMode.SetActiveLayout(index + 2);
	end
end

local function createMacro()
	local macroText =
	"/run SetCVar (\"nameplateGlobalScale\", 1.2)\n/run SetCVar (\"nameplateSelectedScale\", 1.3)\n/console WorldTextScale 0.5\n/console turnspeed 180\n/console set ResampleAlwaysSharpen 1";
	local macroName = "asMOD Setup";
	local macroID = GetMacroIndexByName(macroName);


	if (macroID == 0) then
		CreateMacro(macroName, "Inv_10_inscription3_darkmoondeckbox_black", macroText, false);
	else
		EditMacro(macroID, macroName,"Inv_10_inscription3_darkmoondeckbox_black", macroText)
	end
end

local function asMOD_Setup()
	-- 모든 UI 위치를 Reset 한다.
	asMOD_position = {};

	local curr = GetCVar("uiScale");

	if curr then
		curr = tonumber(curr);
	else
		curr = 1;
	end

	--print("[asMOD] UI Scale 을 조정합니다.");
	SetCVar("useUiScale", "1");

	if asMOD_UIScale then
		if (asMOD_UIScale < 0.64) then
			UIParent:SetScale(asMOD_UIScale)
		else
			SetCVar("uiScale", asMOD_UIScale)
		end
	end


	--print("[asMOD] 재사용 대기시간을 보이게 합니다.");
	SetCVar("countdownForCooldowns", "1");

	--print("[asMOD] 주문 경보 투명도 설정");
	SetCVar("spellActivationOverlayOpacity", 0.65);

	--print("[asMOD] 힐량와 데미지를 보이게 합니다.");
	SetCVar("floatingCombatTextCombatHealing", 1);
	SetCVar("floatingCombatTextCombatDamage", 1);

	--print("[asMOD] 이름표 항상 표시");
	SetCVar("nameplateShowAll", 1)
	SetCVar("nameplateShowEnemies", 1)
	SetCVar("nameplateShowFriends", 0)
	SetCVar("nameplateShowFriendlyNPCs", 0)

	--print("[asMOD] 개인 자원바를 끕니다.");
	SetCVar("nameplateShowSelf", "0");

	--print("[asMOD] 공격대창 직업 색상 표시");
	SetCVar("raidFramesDisplayClassColor", 1)

	--print("[asMOD] Unit Frame 설정 변경");
	SetCVar("showTargetOfTarget", 1)

	if version >= 110105 then
	--쿨다운 Viewer 끄기
		SetCVar("cooldownViewerEnabled", 0);
	end

	--print("[asMOD] 채팅창에 직업색상을 표시하게 합니다.");
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

	-- 기본 Setup macro 생성
	createMacro();

	asMOD_Import_Layout(ns.layout, "asMOD_layout");
	asMOD_Import_Commit();

	--print("[asMOD] Details, Bigwigs, DBM 설정을 합니다.");

	local bload = C_AddOns.LoadAddOn("BugSack")

	if bload then
		BugSackDB = {
			["soundMedia"] = "BugSack: Fatality",
			["altwipe"] = true,
			["useMaster"] = false,
			["fontSize"] = "GameFontHighlight",
			["mute"] = true,
			["auto"] = false,
			["chatframe"] = false,
		}
		BugSackLDBIconDB = {
			["minimapPos"] = 234.2022186215915,
		}
	end

	bload = C_AddOns.LoadAddOn("DBM-Core")
	if bload then
		DBM_AllSavedOptions = {
			["Default"] = {
				["DontShowFarWarnings"] = true,
				["FilterInterrupt2"] = "TandFandBossCooldown",
				["SpamSpecRolestack"] = false,
				["InfoFrameX"] = -357.1292419433594,
				["DontShowNameplateIcons"] = true,
				["SpecialWarningFlash5"] = true,
				["FilterInterruptNoteName"] = false,
				["EnableModels"] = true,
				["DontPlayTrivialSpecialWarningSound"] = true,
				["SWarnNameInNote"] = true,
				["DontShowPTCountdownText"] = false,
				["InfoFramePoint"] = "BOTTOMRIGHT",
				["OverrideBossSay"] = false,
				["WorldBossAlert"] = false,
				["SpamSpecInformationalOnly"] = false,
				["WorldBuffAlert"] = false,
				["SpamSpecRoledispel"] = false,
				["DisableMusic"] = false,
				["ShowGuildMessages"] = false,
				["ShowAllVersions"] = true,
				["SpecialWarningSound3"] = "Interface\\AddOns\\DBM-Core\\sounds\\AirHorn.ogg",
				["SpamSpecRolesoak"] = false,
				["ShowWarningsInChat"] = false,
				["InfoFrameFontStyle"] = "None",
				["WarningFontStyle"] = "None",
				["VPReplacesSA1"] = true,
				["ChatFrame"] = "DEFAULT_CHAT_FRAME",
				["CastNPIconGlowBehavior"] = 1,
				["RangeFrameRadarX"] = -230.9038238525391,
				["LogCurrentRaids"] = true,
				["InfoFrameCols"] = 0,
				["NPIconTimerEnabled"] = true,
				["LatencyThreshold"] = 250,
				["ShowGuildMessagesPlus"] = false,
				["LFDEnhance"] = false,
				["LogCurrentMythicRaids"] = true,
				["DontPlayPrivateAuraSound"] = false,
				["HideBossEmoteFrame2"] = true,
				["DisableChatBubbles"] = false,
				["NPAuraSize"] = 40,
				["HideObjectivesFrame"] = true,
				["SpecialWarningShortText"] = true,
				["DontShowPTText"] = false,
				["FilterBInterruptHealer"] = false,
				["SpecialWarningFontSize2"] = 20.12609481811523,
				["SpecialWarningFlashCol5"] = {
					0.2,
					1,
					1,
				},
				["NewsMessageShown2"] = 1,
				["NPIconTextFont"] = "standardFont",
				["EventSoundPullTimer"] = "None",
				["NPIconTimerFontStyle"] = "None",
				["SpecialWarningVibrate2"] = false,
				["SpecialWarningFlashCount2"] = 1,
				["NPAuraText"] = true,
				["EventSoundDungeonBGM"] = "None",
				["DisableRaidIcons"] = false,
				["VPReplacesCustom"] = false,
				["VPReplacesSA4"] = true,
				["SpecialWarningFlashDura3"] = 1,
				["WarningShortText"] = true,
				["SpecialWarningFlash4"] = true,
				["DisableSFX"] = false,
				["SpecialWarningFlashDura4"] = 0.7,
				["SpecialWarningFlashCol3"] = {
					1,
					0,
					0,
				},
				["ModelSoundValue"] = "Short",
				["SpecialWarningY"] = 75,
				["VPReplacesSA2"] = true,
				["ReplaceMyConfigOnOverride"] = false,
				["LogTrivialDungeons"] = false,
				["WarningY"] = 260,
				["CustomSounds"] = 0,
				["ShortTimerText"] = true,
				["LogCurrentMPlus"] = true,
				["DontPlayPTCountdown"] = false,
				["DoNotLogLFG"] = true,
				["WarningIconLeft"] = true,
				["RangeFrameLocked"] = false,
				["DontDoSpecialWarningVibrate"] = false,
				["SpamSpecRolegtfo"] = false,
				["SpecialWarningFlashDura2"] = 0.4,
				["LogTrivialRaids"] = false,
				["FilterVoidFormSay2"] = false,
				["VPReplacesSADefault"] = true,
				["GroupOptionsExcludeIcon"] = false,
				["FilterBTargetFocus"] = true,
				["RecordOnlyBosses"] = false,
				["ShowBerserkWarnings"] = true,
				["DontPlayCountdowns"] = false,
				["OverrideBossIcon"] = false,
				["SpecialWarningFlashAlph1"] = 0.3,
				["ShowDefeatMessage"] = false,
				["DontShowRangeFrame"] = true,
				["InfoFrameShowSelf"] = false,
				["WarningFontShadow"] = true,
				["DontShowBossTimers"] = false,
				["SpecialWarningFontStyle"] = "THICKOUTLINE",
				["DontShowBossAnnounces"] = false,
				["BadIDAlert"] = false,
				["WarningIconChat"] = false,
				["HideGuildChallengeUpdates"] = true,
				["ShowPizzaMessage"] = false,
				["RangeFrameSound2"] = "none",
				["GUIHeight"] = 600,
				["LogCurrentMythicZero"] = false,
				["GUIWidth"] = 800,
				["FilterVoidFormSay"] = true,
				["NPIconTextFontSize"] = 10,
				["EventSoundMusic"] = "None",
				["GroupOptionsExcludePAura"] = false,
				["LogTWRaids"] = false,
				["NoTimerOverridee"] = true,
				["HelpMessageVersion"] = 3,
				["SpecialWarningFlashAlph2"] = 0.3,
				["DontShowHudMap2"] = true,
				["SpecialWarningFlashCount4"] = 2,
				["ShowSWarningsInChat"] = false,
				["SpamSpecRoledefensive"] = false,
				["RangeFrameRadarY"] = 0.9783453345298767,
				["OverrideBossAnnounce"] = false,
				["CoreSavedRevision"] = 20250208184718,
				["RangeFrameX"] = -229.7040557861328,
				["NPIconGrowthDirection"] = "CENTER",
				["RangeFrameY"] = 76.74076080322266,
				["SpecialWarningFlashAlph3"] = 0.4,
				["FilterTInterruptHealer"] = false,
				["FakeBWVersion"] = false,
				["NPIconXOffset"] = 0,
				["SpecialWarningFlashCol2"] = {
					1,
					0.5,
					0,
				},
				["WarningAlphabetical"] = true,
				["SpecialWarningPoint"] = "CENTER",
				["FilterBInterruptCooldown"] = true,
				["CheckGear"] = true,
				["NPIconTextEnabled"] = true,
				["SpecialWarningX"] = 0,
				["DontShowPT2"] = false,
				["MoviesSeen"] = {
				},
				["ShowQueuePop"] = true,
				["SpecialWarningFlashCol4"] = {
					1,
					0,
					1,
				},
				["DebugMode"] = false,
				["DisableGuildStatus"] = false,
				["ShowReminders"] = true,
				["SpecialWarningFontCol"] = {
					1,
					0.7,
					0,
				},
				["NPIconTimerFont"] = "standardFont",
				["AFKHealthWarning2"] = false,
				["SpecialWarningVibrate1"] = false,
				["EventSoundEngage2"] = "None",
				["InfoFrameY"] = 18.01542472839356,
				["SpecialWarningSound"] = 569200,
				["WarningIconRight"] = false,
				["UseSoundChannel"] = "Master",
				["ShowRespawn"] = true,
				["HideMovieNonInstanceAnywhere"] = false,
				["DontAutoGossip"] = false,
				["VPReplacesSA3"] = true,
				["LeavingCombatAlert"] = false,
				["AlwaysKeepNPs"] = true,
				["AlwaysShowSpeedKillTimer2"] = false,
				["NoAnnounceOverride"] = true,
				["DebugLevel"] = 1,
				["VPReplacesGTFO"] = true,
				["BadTimerAlert"] = false,
				["DontShowPTNoID"] = false,
				["HideGarrisonToasts"] = true,
				["RangeFramePoint"] = "BOTTOMRIGHT",
				["SpecialWarningFontShadow"] = false,
				["EventMusicMythicFilter"] = false,
				["SpecialWarningFlashCol1"] = {
					1,
					1,
					0,
				},
				["SpecialWarningVibrate4"] = true,
				["SWarnClassColor"] = true,
				["UseNameplateHandoff"] = true,
				["DontShowNameplateIconsCast"] = true,
				["SpecialWarningFlashAlph4"] = 0.4,
				["PTCountThreshold2"] = 5,
				["FilterDispel"] = true,
				["VPReplacesAnnounce"] = true,
				["ShowWAKeys"] = true,
				["oRA3AnnounceConsumables"] = false,
				["CountdownVoice2"] = "Kolt",
				["InfoFrameLocked"] = true,
				["EnableWBSharing"] = false,
				["ArrowPosX"] = 0,
				["CastNPIconGlowType2"] = 4,
				["AITimer"] = true,
				["LogTWDungeons"] = false,
				["HealthWarningLow"] = false,
				["EventMusicNoBuiltIn"] = false,
				["FilterCrowdControl"] = true,
				["SpecialWarningSound4"] = 552035,
				["DontShowEventTimers"] = false,
				["NPIconOffsetX"] = 0,
				["DontShowTrashTimers"] = false,
				["GUIX"] = -92.32605743408203,
				["LogCurrentHeroic"] = false,
				["CDNPIconGlowType"] = 1,
				["VPDontMuteSounds"] = false,
				["WarningDuration2"] = 1.5,
				["WarningColors"] = {
					{
						["b"] = 0.9411765336990356,
						["g"] = 0.8000000715255737,
						["r"] = 0.4117647409439087,
					},
					{
						["b"] = 0,
						["g"] = 0.9490196704864502,
						["r"] = 0.9490196704864502,
					},
					{
						["b"] = 0,
						["g"] = 0.501960813999176,
						["r"] = 1,
					},
					{
						["b"] = 0.1019607931375504,
						["g"] = 0.1019607931375504,
						["r"] = 1,
					},
				},
				["NPIconAnchorPoint"] = "TOP",
				["SWarningAlphabetical"] = true,
				["NPIconGlowBehavior"] = 1,
				["BlockNoteShare"] = false,
				["NPIconTextMaxLen"] = 7,
				["NPIconSize"] = 30,
				["DontPlaySpecialWarningSound"] = false,
				["SpecialWarningSound2"] = 543587,
				["NPIconTimerFontSize"] = 18,
				["SpamSpecRoletaunt"] = false,
				["GroupOptionsExcludePA"] = false,
				["RangeFrameRadarPoint"] = "BOTTOMRIGHT",
				["DontShowInfoFrame"] = true,
				["AdvancedAutologBosses"] = false,
				["NPIconYOffset"] = 0,
				["WarningX"] = 0,
				["MovieFilter2"] = "Never",
				["ArrowPoint"] = "TOP",
				["RoleSpecAlert"] = true,
				["DontRestoreRange"] = false,
				["SpecialWarningFlash1"] = true,
				["SpecialWarningFlashCount3"] = 3,
				["SpecialWarningVibrate3"] = true,
				["WhisperStats"] = false,
				["SilentMode"] = false,
				["AlwaysPlayVoice"] = false,
				["DontShowTimersWithNameplates"] = true,
				["SpecialWarningFlashAlph5"] = 0.5,
				["SpecialWarningDuration2"] = 1.5,
				["WarningFont"] = "standardFont",
				["WarningFontSize"] = 16.47568893432617,
				["ShowEngageMessage"] = false,
				["RangeFrameSound1"] = "none",
				["DontSendBossGUIDs"] = true,
				["FilterTTargetFocus"] = true,
				["EventSoundVictory2"] = "None",
				["AutoExpandSpellGroups"] = false,
				["LastRevision"] = 0,
				["GUIPoint"] = "CENTER",
				["SettingsMessageShown"] = true,
				["AutoAcceptGuildInvite"] = false,
				["FilterTrashWarnings2"] = true,
				["SpecialWarningFlashCount5"] = 3,
				["AutologBosses"] = false,
				["DontSetIcons"] = false,
				["SpamSpecRoleswitch"] = false,
				["FilterTInterruptCooldown"] = true,
				["CountdownVoice"] = "Corsica",
				["WarningPoint"] = "CENTER",
				["DontShowSpecialWarningText"] = false,
				["CountdownVoice3"] = "Smooth",
				["DisableStatusWhisper"] = false,
				["NPIconSpacing"] = 0,
				["AutoRespond"] = true,
				["EventDungMusicMythicFilter"] = false,
				["GUIY"] = -30.34099960327148,
				["RangeFrameFrames"] = "radar",
				["SpecialWarningIcon"] = true,
				["CastNPIconGlowType"] = 2,
				["EnteringCombatAlert"] = false,
				["InfoFrameFont"] = "standardFont",
				["HideTooltips"] = false,
				["GroupOptionsBySpell"] = true,
				["FilterTankSpec"] = true,
				["EventSoundWipe"] = "None",
				["RLReadyCheckSound"] = true,
				["SpecialWarningFlashDura5"] = 1,
				["DontShowTargetAnnouncements"] = true,
				["InfoFrameLines"] = 0,
				["ArrowPosY"] = -150,
				["SpecialWarningFlashDura1"] = 0.3,
				["SpecialWarningFont"] = "standardFont",
				["DontShowSpecialWarningFlash"] = false,
				["AutoReplySound"] = false,
				["OverrideBossTimer"] = false,
				["WorldBossNearAlert"] = false,
				["SpecialWarningVibrate5"] = true,
				["EventSoundMusicCombined"] = false,
				["DebugSound"] = true,
				["AutoAcceptFriendInvite"] = false,
				["NPIconOffsetY"] = 20,
				["SpecialWarningFlashCount1"] = 1,
				["PullVoice"] = "Corsica",
				["SpecialWarningSound5"] = 554236,
				["DontSendYells"] = false,
				["SpamSpecRoleinterrupt"] = false,
				["SpecialWarningFlash2"] = true,
				["NPIconTextFontStyle"] = "None",
				["SpecialWarningFlash3"] = true,
				["DontShowNameplateIconsCD"] = true,
				["Enabled"] = true,
				["InfoFrameFontSize"] = 12,
				["DontRestoreIcons"] = false,
				["RangeFrameUpdates"] = "Average",
				["DontShowUserTimers"] = false,
				["RaidWarningSound"] = 566558,
				["HideMovieDuringFight"] = true,
				["SendDungeonBossGUIDs"] = true,
				["StripServerName"] = true,
				["NoCombatScanningFeatures"] = false,
				["HideMovieOnlyAfterSeen"] = true,
				["HideMovieInstanceAnywhere"] = true,
				["ChosenVoicePack2"] = "None",
				["AFKHealthWarning"] = false,
				["DisableAmbiance"] = false,
				["ZoneCombatSyncing"] = false,
			},
		}
		DBM_MinimapIcon = {
			["minimapPos"] = 249.9876931591084,
			["showInCompartment"] = true,
		}
		DBM_AnnoyingPopupDisables = nil
		DBM_ModsToLoadWithFullTestSupport = {
			["addonsWithTests"] = {
			},
			["bossModsWithTests"] = {
			},
		}




		DBT_AllPersistentOptions = {
			["Default"] = {
				["DBM"] = {
					["StartColorPR"] = 1,
					["Scale"] = 0.9,
					["HugeBarsEnabled"] = false,
					["StartColorR"] = 1,
					["EndColorPR"] = 0.5,
					["Sort"] = "Sort",
					["ExpandUpwardsLarge"] = false,
					["ExpandUpwards"] = true,
					["TimerPoint"] = "BOTTOMRIGHT",
					["EndColorDG"] = 0,
					["Alpha"] = 0.8,
					["EndColorI2G"] = 0.5058823823928833,
					["HugeTimerPoint"] = "CENTER",
					["StartColorIR"] = 0.47,
					["DisableRightClick"] = true,
					["StartColorUIR"] = 1,
					["StartColorAG"] = 0.545,
					["EndColorDR"] = 1,
					["TDecimal"] = 11,
					["StartColorI2G"] = 0.6745098233222961,
					["EndColorI2R"] = 1,
					["StartColorRR"] = 0.5,
					["StartColorUIG"] = 1,
					["FillUpLargeBars"] = true,
					["HugeScale"] = 1.03,
					["BarYOffset"] = 0,
					["StartColorDG"] = 0.3,
					["StartColorAR"] = 0.375,
					["ClickThrough"] = true,
					["VarianceAlpha"] = 0.5,
					["Skin"] = "",
					["TextColorR"] = 1,
					["EndColorAER"] = 1,
					["StartColorIB"] = 1,
					["HugeBarXOffset"] = 0,
					["StartColorB"] = 0,
					["IconRight"] = false,
					["EndColorDB"] = 1,
					["Font"] = "standardFont",
					["StartColorAEG"] = 0.466,
					["EndColorAEB"] = 0.247,
					["Height"] = 20,
					["HugeSort"] = "Sort",
					["BarXOffset"] = 0,
					["NoBarFade"] = false,
					["EndColorAR"] = 0.15,
					["EndColorG"] = 0,
					["StartColorAER"] = 1,
					["StartColorPB"] = 0.42,
					["StartColorI2R"] = 1,
					["FadeBars"] = true,
					["TextColorB"] = 1,
					["EndColorIB"] = 1,
					["EndColorI2B"] = 0,
					["EndColorPB"] = 0.285,
					["EndColorRB"] = 0.3,
					["TimerX"] = -106.855583190918,
					["EndColorIR"] = 0.047,
					["DynamicColor"] = true,
					["EndColorRR"] = 0.11,
					["Bar7ForceLarge"] = false,
					["BarStyle"] = "NoAnim",
					["EnlargeBarTime"] = 11,
					["Spark"] = true,
					["StartColorDR"] = 0.9,
					["FontSize"] = 10,
					["FontFlag"] = "None",
					["EndColorAB"] = 1,
					["IconLocked"] = true,
					["EndColorPG"] = 0.41,
					["HugeHeight"] = 20,
					["EndColorIG"] = 0.88,
					["EndColorAEG"] = 0.043,
					["StartColorPG"] = 0.776,
					["StartColorAEB"] = 0.459,
					["Texture"] = "Interface\\AddOns\\Details\\images\\BantoBar",
					["TextColorG"] = 1,
					["KeepBars"] = true,
					["HugeTimerX"] = -326.1634826660156,
					["HugeTimerY"] = 2.310630559921265,
					["HugeBarYOffset"] = 0,
					["DesaturateValue"] = 1,
					["ColorByType"] = true,
					["FillUpBars"] = true,
					["TimerY"] = 244.8362579345703,
					["Bar7CustomInline"] = true,
					["StartColorAB"] = 1,
					["EndColorUIB"] = 0.0117647058823529,
					["EndColorUIG"] = 0.92156862745098,
					["HugeWidth"] = 100,
					["IconLeft"] = true,
					["HugeAlpha"] = 1,
					["FlashBar"] = false,
					["EndColorUIR"] = 1,
					["EndColorRG"] = 1,
					["StartColorUIB"] = 0.0627450980392157,
					["StartColorG"] = 0.7,
					["Width"] = 235,
					["StartColorRB"] = 0.5,
					["EndColorR"] = 1,
					["StartColorRG"] = 1,
					["EndColorB"] = 0,
					["InlineIcons"] = true,
					["EndColorAG"] = 0.385,
					["StartColorIG"] = 0.97,
					["StartColorDB"] = 1,
					["StartColorI2B"] = 0,
					["VarianceBehavior"] = "ZeroAtMinTimerAndNeg",
					["VarianceEnabled"] = true,
				},
			},
		}
	end


	bload = C_AddOns.LoadAddOn("Details")
	if bload then
		Details:EraseProfile("asMOD");
		Details:ImportProfile(detailsprofile, "asMOD", true, true);
	end
	ReloadUI();
end

local function asMOD_Popup()
	StaticPopup_Show("asMOD")
end


local function funcDragStop(self)
	local _, _, _, x, y = self:GetPoint();
	self.text:SetText(self.addonName .. "\n" .. string.format("%5.1f", x) .. "\n" .. string.format("%5.1f", y));
	self.StopMovingOrSizing(self);
end

local asMOD_AFFL_frame;
local asMOD_ACB_frame;
local asMOD_ASQA_frame;

local function setupFrame(frame, Name, addonName, config)
	frame = CreateFrame("Frame", Name, UIParent)
	frame.addonName = addonName;
	frame.text = frame:CreateFontString(nil, "OVERLAY")
	frame.text:SetFont(STANDARD_TEXT_FONT, 10, "OUTLINE")
	frame.text:SetPoint("CENTER", frame, "CENTER", 0, 0)
	frame.text:SetText(frame.addonName);
	frame:SetMovable(true)
	frame:EnableMouse(true)
	frame:RegisterForDrag("LeftButton")
	frame:SetFrameStrata("HIGH");
	frame:SetScript("OnDragStart", frame.StartMoving)
	frame:SetScript("OnDragStop", funcDragStop);
	-- The code below makes the frame visible, and is not necessary to enable dragging.
	frame:SetPoint(config["anchor1"], config["parent"], config["anchor2"], config["x"], config["y"]);
	if config["width"] and config["width"] > 5 then
		frame:SetWidth(config["width"]);
	else
		frame:SetWidth(40);
	end

	if config["height"] and config["height"] > 5 then
		frame:SetHeight(config["height"]);
	else
		frame:SetHeight(10);
	end

	local tex = frame:CreateTexture(nil, "ARTWORK");
	tex:SetAllPoints();
	tex:SetTexture(1.0, 0.5, 0); tex:SetAlpha(0.5);
	return frame
end


function asMOD_setupFrame(frame, addonName)
	local parent;
	asMOD_t_position[addonName] = {
		["name"] = addonName,
		["parent"] = "UIParent",
		["anchor1"] = "CENTER",
		["anchor2"] = "CENTER",
		["x"] = 0,
		["y"] = 0,
		["width"] = 0,
		["height"] = 0
	};
	asMOD_t_position[addonName]["anchor1"], _, asMOD_t_position[addonName]["anchor2"], asMOD_t_position[addonName]["x"], asMOD_t_position[addonName]["y"] =
		frame:GetPoint();
	asMOD_t_position[addonName]["width"] = frame:GetWidth();
	asMOD_t_position[addonName]["height"] = frame:GetHeight();

	if asMOD_position[addonName] then
		frame:ClearAllPoints();
		frame:SetPoint(asMOD_position[addonName]["anchor1"], asMOD_position[addonName]["parent"],
			asMOD_position[addonName]["anchor2"], asMOD_position[addonName]["x"], asMOD_position[addonName]["y"])
	end
end

local framelist = {};

local function asMOD_Popup_Config()
	for i, value in pairs(asMOD_t_position) do
		local index = value["name"]

		if not asMOD_position[index] then
			asMOD_position[index] = asMOD_t_position[index]
		end
		framelist[index] = nil


		framelist[index] = setupFrame(framelist[index], "asMOD_frame" .. index, index, asMOD_position[index]);
	end

	StaticPopup_Show("asConfig")
end

local function asMOD_Cancel_Position()
	for i, value in pairs(asMOD_t_position) do
		local index = value["name"]
		framelist[index]:Hide()
	end
end


local function asMOD_Setup_Position()
	for i, value in pairs(asMOD_t_position) do
		local index = value["name"]
		asMOD_position[index]["anchor1"], _, asMOD_position[index]["anchor2"], asMOD_position[index]["x"], asMOD_position[index]["y"] =
			framelist[index]:GetPoint();
	end
	asMOD_Cancel_Position();

	ReloadUI();
end


local function asMOD_Popup_Clear()
	StaticPopup_Show("asClear")
end

local function asMOD_Clear()
	asMOD_position = {};
	ReloadUI();
end

local function asMOD_OnEvent(self, event, arg1)
	if event == "ADDON_LOADED" and arg1 == "asMOD" then
		if not asMOD_version or asMOD_version ~= asMOD_CurrVersion then
			asMOD_Popup()
			asMOD_config = true;
			asMOD_version = asMOD_CurrVersion;
		end

		if GetLocale() == "koKR" then
			DEFAULT_CHAT_FRAME:AddMessage("/asMOD : 최적화된 Interface 옵션 Setup")
			DEFAULT_CHAT_FRAME:AddMessage("/asConfig : asMOD 의 위치 조정")
			DEFAULT_CHAT_FRAME:AddMessage("/asClear : asMOD 기본 위치로 설정 초기화")
		else
			DEFAULT_CHAT_FRAME:AddMessage("/asMOD : Setup asMOD")
			DEFAULT_CHAT_FRAME:AddMessage("/asConfig : Config positions of asMOD addons")
			DEFAULT_CHAT_FRAME:AddMessage("/asClear : Reset positions as default configuration")
		end

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

if GetLocale() == "koKR" then
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

		OnCancel = function(_, reason)
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
else
	StaticPopupDialogs["asMOD"] = {
		text = "Setup default configurations for asMOD",
		button1 = "Confirm",
		button2 = "Cancel",
		OnAccept = function()
			asMOD_Setup()
		end,
		timeout = 0,
		whileDead = true,
		hideOnEscape = true,
		preferredIndex = 3,
	}

	StaticPopupDialogs["asConfig"] = {
		text = "Config positions of asMOD addons",
		button1 = "Save",
		button2 = "Cancel",
		OnAccept = function()
			asMOD_Setup_Position()
		end,

		OnCancel = function(_, reason)
			asMOD_Cancel_Position();
		end,
		timeout = 0,
		whileDead = true,
		hideOnEscape = true,
		preferredIndex = 3,
	}


	StaticPopupDialogs["asClear"] = {
		text = "Reset all configurations to default",
		button1 = "Confirm",
		button2 = "Cancel",
		OnAccept = function()
			asMOD_Clear()
		end,
		timeout = 0,
		whileDead = true,
		hideOnEscape = true,
		preferredIndex = 3,
	}
end
