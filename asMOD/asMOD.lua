local _, ns = ...;
local version = select(4, GetBuildInfo());

local configs = {
	uiscale = 0.75,
	version = 260108,
};

local positions = {};
ASMODOBJ = {};

if not asMOD_position then
	asMOD_position = {};
end

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
	"/console WorldTextScale 0.5\n/console turnspeed 180\n/console set ResampleAlwaysSharpen 1";
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
	asMOD_position = {};


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
	SetCVar("floatingCombatTextCombatHealing", 1);
	SetCVar("floatingCombatTextCombatDamage", 1);

	--이름표
	SetCVar("nameplateShowAll", 1)
	SetCVar("nameplateShowEnemies", 1)
	SetCVar("nameplateShowFriends", 0)
	SetCVar("nameplateShowFriendlyNPCs", 0)
	SetCVar("namePlateStyle", Enum.NamePlateStyle.Modern);

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


local function on_stopdrag(self)
	local _, _, _, x, y = self:GetPoint();
	self.text:SetText(self.addonName .. "\n" .. string.format("%5.1f", x) .. "\n" .. string.format("%5.1f", y));
	self.StopMovingOrSizing(self);
end


local function setup_frame(frame, Name, addonName, config)
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
	frame:SetScript("OnDragStop", on_stopdrag);
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
	tex:SetColorTexture(1.0, 0.5, 0); tex:SetAlpha(0.5);
	return frame
end


function ASMODOBJ.load_position(frame, addonName)
	positions[addonName] = {
		["name"] = addonName,
		["parent"] = "UIParent",
		["anchor1"] = "CENTER",
		["anchor2"] = "CENTER",
		["x"] = 0,
		["y"] = 0,
		["width"] = 0,
		["height"] = 0
	};
	positions[addonName]["anchor1"], _, positions[addonName]["anchor2"], positions[addonName]["x"], positions[addonName]["y"] =
		frame:GetPoint();
	positions[addonName]["width"] = frame:GetWidth();
	positions[addonName]["height"] = frame:GetHeight();

	if asMOD_position[addonName] then
		frame:ClearAllPoints();
		frame:SetPoint(asMOD_position[addonName]["anchor1"], asMOD_position[addonName]["parent"],
			asMOD_position[addonName]["anchor2"], asMOD_position[addonName]["x"], asMOD_position[addonName]["y"])
	end
end

local framelist = {};

local function show_configpopup()
	for i, value in pairs(positions) do
		local index = value["name"]

		if not asMOD_position[index] then
			asMOD_position[index] = positions[index]
		end
		framelist[index] = nil


		framelist[index] = setup_frame(framelist[index], "asMOD_frame" .. index, index, asMOD_position[index]);
	end

	StaticPopup_Show("asConfig")
end

local function cancel_position()
	for i, value in pairs(positions) do
		local index = value["name"]
		framelist[index]:Hide()
	end
end


local function save_positions()
	for i, value in pairs(positions) do
		local index = value["name"]
		asMOD_position[index]["anchor1"], _, asMOD_position[index]["anchor2"], asMOD_position[index]["x"], asMOD_position[index]["y"] =
			framelist[index]:GetPoint();
	end
	cancel_position();

	ReloadUI();
end


local function show_clearpopup()
	StaticPopup_Show("asClear")
end

local function reset_positions()
	asMOD_position = {};
	ReloadUI();
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
			DEFAULT_CHAT_FRAME:AddMessage("/asConfig : asMOD 의 위치 조정")
			DEFAULT_CHAT_FRAME:AddMessage("/asClear : asMOD 기본 위치로 설정 초기화")
		else
			DEFAULT_CHAT_FRAME:AddMessage("/asMOD : Setup optimized interface options")
			DEFAULT_CHAT_FRAME:AddMessage("/asConfig : Config positions of asMOD addons")
			DEFAULT_CHAT_FRAME:AddMessage("/asClear : Reset positions as default configuration")
		end

		SlashCmdList['asMOD'] = show_asMODpopup
		SlashCmdList['asConfig'] = show_configpopup
		SlashCmdList['asClear'] = show_clearpopup
		SLASH_asMOD1 = '/asMOD'
		SLASH_asConfig1 = '/asConfig'
		SLASH_asClear1 = '/asClear'
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

	StaticPopupDialogs["asConfig"] = {
		text = "asMOD 애드온의 위치를 조정 합니다. 완료를 누르면 위치가 저장 됩니다. 원치 않을 경우 취소를 누르세요",
		button1 = "완료",
		button2 = "취소",
		OnAccept = function()
			save_positions()
		end,

		OnCancel = function(_, reason)
			cancel_position();
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
			reset_positions()
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

	StaticPopupDialogs["asConfig"] = {
		text = "Config positions of asMOD addons",
		button1 = "Save",
		button2 = "Cancel",
		OnAccept = function()
			save_positions()
		end,

		OnCancel = function(_, reason)
			cancel_position();
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
			reset_positions()
		end,
		timeout = 0,
		whileDead = true,
		hideOnEscape = true,
		preferredIndex = 3,
	}
end
