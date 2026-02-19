local _, ns = ...;
local version = select(4, GetBuildInfo());

local configs = {
	uiscale = 0.75,
	version = 260108,
};

local function import_layout(layout_text, name)
	local importLayoutInfo = C_EditMode.ConvertStringToLayoutInfo(layout_text);
	local layoutInfo = C_EditMode.GetLayouts();

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

	C_EditMode.SaveLayouts(layoutInfo);
end

local function select_layout(name)
	local layoutinfo = C_EditMode.GetLayouts()
	local index = nil;

	for i, element in ipairs(layoutinfo.layouts) do
		if element.layoutName == name then
			index = i;
			break;
		end
	end

	if index then
		C_EditMode.SetActiveLayout(index + 2);
	end
end

local function create_macro()
	if InCombatLockdown() then
		return;
	end

	local macroText =
	"/console WorldTextScale_v2 0.5\n/console turnspeed 180\n/console set ResampleAlwaysSharpen 1";
	local macroName = "asMOD Setup";
	local macroID = GetMacroIndexByName(macroName);


	if (macroID == 0) then
		local global, perChar = GetNumMacros();

		if global < 120 then
			CreateMacro(macroName, "Inv_10_inscription3_darkmoondeckbox_black", macroText, false);
		else
			print("asMOD error:too many macros, so need to delete some")
		end
	else
		EditMacro(macroID, macroName, "Inv_10_inscription3_darkmoondeckbox_black", macroText)
	end
end

local function setup_wowoptions()
	-- 모든 UI 위치를 Reset 한다.
	--asMOD_position = {};


	--UI Scale 을 조정합니다.
	SetCVar("useUiScale", "1");

	if configs.uiscale then
		if (configs.uiscale < 0.64) then
			UIParent:SetScale(configs.uiscale)
		else
			SetCVar("uiScale", configs.uiscale)
		end
	end


	--재사용 대기시간
	SetCVar("countdownForCooldowns", "1");

	--주문 경보 투명도 설정
	SetCVar("spellActivationOverlayOpacity", 0.65);

	--힐량 데미지
	SetCVar("floatingCombatTextCombatHealing_v2", 1);
	SetCVar("floatingCombatTextCombatDamage_v2", 1);

	--이름표
	SetCVar("nameplateShowAll", 1)
	SetCVar("nameplateShowEnemies", 1)
	SetCVar("nameplateShowFriends", 0)
	SetCVar("nameplateShowFriendlyNPCs", 0)
	SetCVar("namePlateStyle", Enum.NamePlateStyle.Block);

	--개인 자원바
	SetCVar("nameplateShowSelf", "0");

	--공격대창
	SetCVar("raidFramesDisplayClassColor", 1);
	SetCVar("raidFramesDisplayDebuffs", 1);
	SetCVar("raidFramesDispelIndicatorType", 1);
	SetCVar("raidFramesDisplayPowerBars", 0);

	--Unit Frame 설정 변경
	SetCVar("showTargetOfTarget", 1);

	-- 쿨다운 뷰어
	SetCVar("cooldownViewerEnabled", 1);

	-- 전투 상황 알림
	SetCVar("enableFloatingCombatText", 0);

	--데미지 미터
	SetCVar("damageMeterEnabled", 1);

	--보스 타임라인
	SetCVar("combatWarningsEnabled", 1);


	--채팅창에 직업색상을 표시하게 합니다.
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

	import_layout(ns.layout, "asMOD_layout");
	select_layout("asMOD_layout");

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

	ReloadUI();
end

local function show_asMODpopup()
	StaticPopup_Show("asMOD")
end

local function on_event(self, event, arg1)
	if event == "ADDON_LOADED" and arg1 == "asMOD" then
		if not asMOD_version or asMOD_version ~= configs.version then
			show_asMODpopup()
			asMOD_config = true;
			asMOD_version = configs.version;
		end

		C_Timer.After(1, create_macro);

		if GetLocale() == "koKR" then
			DEFAULT_CHAT_FRAME:AddMessage("/asMOD : 최적화된 Interface 옵션 Setup")
		else
			DEFAULT_CHAT_FRAME:AddMessage("/asMOD : Setup optimized interface options")
		end

		SlashCmdList['asMOD'] = show_asMODpopup;
		SLASH_asMOD1 = '/asMOD';
	end

	return;
end

local main_frame = CreateFrame("Frame")
main_frame:SetScript("OnEvent", on_event)
main_frame:RegisterEvent("ADDON_LOADED")
main_frame:RegisterEvent("PLAYER_ENTERING_WORLD")

if GetLocale() == "koKR" then
	StaticPopupDialogs["asMOD"] = {
		text = "asMOD가 '기본 인터페이스 설정'을 변경합니다. \n채팅창에 '/asMOD'명령어로 기능을 다시 불러 올 수 있습니다.",
		button1 = "변경",
		button2 = "다음에",
		OnAccept = function()
			setup_wowoptions()
		end,
		timeout = 0,
		whileDead = true,
		hideOnEscape = true,
		preferredIndex = 3,
	}	
else
	StaticPopupDialogs["asMOD"] = {
		text =
		"asMOD will change the 'Default Interface Settings'. \nYou can reload the features using the '/asMOD' command in the chat.",
		button1 = "Confirm",
		button2 = "Cancel",
		OnAccept = function()
			setup_wowoptions()
		end,
		timeout = 0,
		whileDead = true,
		hideOnEscape = true,
		preferredIndex = 3,
	}	
end
