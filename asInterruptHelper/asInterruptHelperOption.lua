local _, ns = ...;
local Options_Default = {
	version = 250727,
	ShowTarget = true,
	ShowFocus = true,
	ShowMouseOver = true,
    CheckRange = true,
	ShowStunOnInterrupt = true,
};

local L = {
	ShowTarget = "Display Target Interrupt Skill",
	ShowFocus = "Display Focus Target Interrupt Skill",
	ShowMouseOver = "Display Mouseover Target Interrupt Skill",
	CheckRange = "Display in Red When Out of Range",
	ShowStunOnInterrupt = "Display Stun Skill When Interrupt is on Cooldown",
}


if GetLocale() == "koKR" then
	L = {
		ShowTarget = "대상 차단 스킬 표시 여부",
		ShowFocus = "주시 대상의 차단 스킬 표시 여부",
		ShowMouseOver = "마우스 오버 대상의 차단 스킬 표시 여부",
		CheckRange = "사거리 밖이면 붉은색으로 표시",
		ShowStunOnInterrupt = "차단 스킬이 쿨일 경우 스턴 스킬로 표시",
	}
end

ns.options = CopyTable(Options_Default);

-- 파티일경우 Check할 Spell
-- Spell Name 와 쿨 Time을 초로 입력
ns.InterruptSpells = {
	[6552]   = 15, -- Pummel "들이치기"
	[1766]   = 15, -- Kick"발차기"
	[183752] = 15, -- Disrupt "분열"
	[116705] = 15, -- Spear Hand Strike "손날 찌르기"
	[47528]  = 15, -- Mind Freeze, "정신 얼리기"
	[187707] = 13, -- Muzzle    "재갈"
	[147362] = 22, -- Counter Shot "반격의 사격"
	[351338] = 20, -- Quell "진압"
	[106839] = 15, -- "Skull Bash "두개골 강타"
	[15487]  = 45, -- Silence 침묵
	[96231]  = 15, -- 성기사 비난
	[57994]  = 12, -- Wind Shear"날카로운 바람"
	[2139]   = 24, -- Counterspell     "마법 차단"
	[78675]  = 60, -- Solar Beam     "태양 광선"
	[89766]  = 30, --흑마 도끼 던지기
	[119914] = 30, --흑마 도끼 던지기
	[19647]  = 24, --흑마 주문 잠금
	[119910] = 24, --흑마 주문 잠금
};

ns.StunSpells = {
	[31661] = 45,   --마법사 용의 숨결
	[157980] = 45,  --마법사 초신성

	[221562] = 45,  --죽기 어둠의 질식
	[49576] = 15,   --죽기 죽음의 손아귀
	[207167] = 60,  --죽기 눈부신 진눈깨비

	[853] = 30,     --기사 심판의 망치
	[115750] = 90,  --기사 눈부신 빛

	[8122] = 40,    --사제 영혼의 절규

	[2094] = 60,   --도적 실명
	[1833] = 12,    --도적 비열한 습격
	[1776] = 25,    --도적 후려치기
	[408] = 30,     --도적 급소가격

	[51490] = 30,   --술사 천둥폭풍
	[192058] = 60,  --술사 축전토템

	[30283] = 60,   --흑마 어둠의 격노
	[6789] = 45,    --흑마 필멸의 고리

	[119381] = 50,  --수도사 팽이차기
	[116844] = 40,  --수도사 평화의 고리

	[368970] = 60, --기원사 꼬리 휘둘러 치기

	[99] = 30,      --드루이드 행동불가의 표효
	[5211] = 60,    -- 드루이드 거센강타
	[132469] = 30,  --드루이드 태풍

	[46968] = 40,   --전사 충격파
	[107570] = 30,  --전사 폭풍망치

	[19577] = 50,   --사냥꾼 위협
	[474421] = 60,  --사냥꾼 위협

	[179057] = 45,  --악사 혼도의 회오리
	[207684] = 90,  --악사 불행의 인장
	[1234195] = 45, --악사 공허 회오리

	[357214] = 60, --폭풍 날개 (종특으로 우선순위를 낮춘다)
	[107079] = 120, 	--종특 전율의 장풍
	[20549] = 90, 	--종특 발구르기
}

ns.SpellRanges = {

	-- 차단기
	[6552]    = 5,  -- Pummel "들이치기"
	[1766]    = 5,  -- Kick"발차기"
	[183752]  = 10, -- Disrupt "분열", 포식 30ms로 변경
	[116705]  = 5,  -- Spear Hand Strike "손날 찌르기"
	[47528]   = 15, -- Mind Freeze, "정신 얼리기"
	[187707]  = 5,  -- Muzzle    "재갈"
	[147362]  = 40, -- Counter Shot "반격의 사격"
	[351338]  = 30, -- Quell "진압"
	[106839]  = 13, -- "Skull Bash "두개골 강타"
	[15487]   = 40, -- Silence 침묵
	[96231]   = 5,  -- 성기사 비난
	[57994]   = 40, -- Wind Shear"날카로운 바람"
	[2139]    = 40, -- Counterspell     "마법 차단"
	[78675]   = 40, -- Solar Beam     "태양 광선"
	[89766]   = 40, --흑마 도끼 던지기
	[119914]  = 40, --흑마 도끼 던지기
	[19647]   = 40, --흑마 주문 잠금
	[119910]  = 40, --흑마 주문 잠금

	-- 스턴기
	[31661]   = 10, --마법사 용의 숨결
	[157980]  = 40, --마법사 초신성

	[221562]  = 20, --죽기 어둠의 질식
	[49576]   = 30, --죽기 죽음의 손아귀
	[207167]  = 10, --죽기 눈부신 진눈깨비

	[853]     = 10, --기사 심판의 망치
	[115750]  = 10, --기사 눈부신 빛

	[8122]    = 8, --사제 영혼의 절규

	[2094] = 15,   --도적 실명
	[1833] = 5,    --도적 비열한 습격
	[1776] = 5,    --도적 후려치기
	[408] = 5,     --도적 급소가격

	[51490]   = 10, --술사 천둥폭풍
	[192058]  = 40, --술사 축전토템

	[30283]   = 35, --흑마 어둠의 격노
	[6789]    = 20, --흑마 필멸의 고리

	[119381]  = 5, --수도사 팽이차기
	[116844]  = 40, --수도사 평화의 고리

	[368970]  = 8, --기원사 꼬리 휘둘러 치기

	[99]      = 10, --드루이드 행동불가의 표효
	[5211]    = 5,  -- 드루이드 거센강타
	[132469]  = 15, --드루이드 태풍

	[46968]   = 15, --전사 충격파 (16미터이나 15미터 뿐이 없음)
	[107570]  = 25, --전사 폭풍망치

	[19577]   = 40, --사냥꾼 위협
	[474421]  = 40, --사냥꾼 위협

	[179057]  = 8,  --악사 혼도의 회오리
	[207684]  = 30, --악사 불행의 인장
	[1234195] = 30, --악사 공허 회오리

	[107079]  = 5, --전율의 장풍 (종특)
	[357214]  = 25, --폭풍 날개(종특)
	[20549] = 8, 	--종특 발구르기
};

local tempoption = {};

function ns.setup_option()
	local function OnSettingChanged(_, setting, value)
		local function get_variable_from_cvar_name(cvar_name)
			local variable_start_index = string.find(cvar_name, "_") + 1
			local variable = string.sub(cvar_name, variable_start_index)
			return variable
		end

		local cvar_name = setting:GetVariable()
		local variable = get_variable_from_cvar_name(cvar_name)
		AIH_Options[variable] = value;
		ns.options[variable] = value;
		ReloadUI();
	end

	local category = Settings.RegisterVerticalLayoutCategory("asInterruptHelper")



	if AIH_Options == nil or AIH_Options.version ~= Options_Default.version then
		AIH_Options = {};
		AIH_Options = CopyTable(Options_Default);
	end

	if AIH_Positions_1 == nil then
		AIH_Positions_1 = {};
	end

	if AIH_Positions_2 == nil then
		AIH_Positions_2 = {};
	end

	ns.options = CopyTable(AIH_Options);

	for variable, _ in pairs(Options_Default) do
		if variable ~= "version" then
			local name = variable;
			local cvar_name = "asInterruptHelper_" .. variable;
			local tooltip = ""
			if AIH_Options[variable] == nil then
				AIH_Options[variable] = Options_Default[variable];
				ns.options[variable] = Options_Default[variable];
			end
			local defaultValue = Options_Default[variable];
			local currentValue = AIH_Options[variable];

			local setting = Settings.RegisterAddOnSetting(category, cvar_name, variable, tempoption, type(defaultValue),
				L[name], defaultValue);
			Settings.CreateCheckboxWithOptions(category, setting, nil, tooltip);
			Settings.SetValue(cvar_name, currentValue);
			Settings.SetOnValueChangedCallback(cvar_name, OnSettingChanged);
		end
	end

	Settings.RegisterAddOnCategory(category)
end
