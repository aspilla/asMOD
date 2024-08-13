local _, ns = ...;

ns.UpdateRate = 0.2; -- 1회 Update 주기 (초) 작으면 작을 수록 Frame Rate 감소 가능, 크면 Update 가 느림

local Options_Default = {
	version = 240723,
	ShowBuffColor = true,       -- 버프가 Frame Color 를 변경 할지
	ShowHealthColor = true,     -- 체력 낮은 사람 Color 변경 (사제 생명)
	LeftAbsorbBar = true,       -- 보호막 바
	TopCastAlert = true,        -- 케스팅 알림 (상단)
	MiddleDefensiveAlert = true, -- 생존기 Alert (중앙)
	RightOffensiveAlert = true, -- 쿨기 Alert (우측
	BorderDispelAlert = true,   -- Dispel Alert (태두리)
	LeftTopRaidIcon = true,     -- Raid Icon
	BottomHealerManaBar = true, -- 힐러 마나바
	BuffSizeRate = 0.9,         -- 기존 Size 크기 배수
	ShowBuffCooldown = true,    -- 버프 지속시간을 보이려면
	MinCoolShowBuffSize = 20,   -- 이크기보다 Icon Size 가 작으면 안보이게 한다. 무조건 보이게 하려면 0 (기본 Buff Debuff만 보임)
	MinShowBuffFontSizeRate = 0.6, -- 버프 Size 대비 쿨다운 폰트 사이즈	
	ShowBuffTooltip = true,     -- Buff GameTooltip을 보이게 하려면 True
	ShowDebuffTooltip = true,   -- Debuff GameTooltip을 보이게 하려면 True
	HideCooldown = false,       -- CooldownSwipe를 숨기고 숫자만으로 Cooldown
};

-- 첫 숫자 남은시간에 리필 알림 (1이면 자동으로 30% 남으면 알림)
-- 두번째 숫자는 표시 위치, 6(우상) 5/4(우중) 1,2,3 은 우하에 보이는 우선 순위이다. (숫자가 클수록 우측에 보임)

ns.ACRB_ShowList_MONK_2 = {
	["소생의 안개"] = { 0, 6 },
	["포용의 안개"] = { 0, 5 },
	["천지교태"] = { 0, 3 }, --시즌3
}

-- 신기
ns.ACRB_ShowList_PALADIN_1 = {
	["고결의 봉화"] = { 0, 6 },
	["빛의 봉화"] = { 0, 5 },
	["신념의 봉화"] = { 0, 5 },
	[200654] = { 0, 3 }, -- 티르	
	["신성한 울림"] = { 0, 2 }, --시즌3	
}

-- 수사
ns.ACRB_ShowList_PRIEST_1 = {
	["속죄"] = { 0, 6 },
	["신의 권능: 보호막"] = { 0, 5 },
	["소생"] = { 1, 4 },
	["회복의 기원"] = { 0, 2 },
	["마력 주입"] = { 0, 1 },
}


-- 신사
ns.ACRB_ShowList_PRIEST_2 = {
	["소생"] = { 1, 6 },
	["신의 권능: 보호막"] = { 0, 5 },
	["회복의 기원"] = { 0, 2 },
	["마력 주입"] = { 0, 1 },
}

ns.ACRB_ShowList_PRIEST_3 = {
	["마력 주입"] = { 0, 1 },
}


ns.ACRB_ShowList_SHAMAN_3 = {
	["성난 해일"] = { 1, 6 },
	["대지의 보호막"] = { 0, 5 },
	["해일의 저장소"] = { 0, 3 }, --시즌3
}


ns.ACRB_ShowList_DRUID_4 = {
	["회복"] = { 1, 6 },
	["피어나는 생명"] = { 1, 5 },
	["재생"] = { 1, 4 },
	["회복 (싹틔우기)"] = { 1, 3 },
	["세나리온 수호물"] = { 0, 2 },
}

ns.ACRB_ShowList_EVOKER_2 = {
	["메아리"] = { 0, 6 },
	["되감기"] = { 1, 5 },
}

ns.ACRB_ShowList_EVOKER_3 = {
	["예지"] = { 0, 6 },
	["끓어오르는 비늘"] = { 0, 5 },
}

-- 안보이게 할 디법
ns.ACRB_BlackList = {
	["도전자의 짐"] = 1,
}


--직업별 생존기 등록 (10초 쿨다운), 내부전쟁 Version
ns.ACRB_DefensiveBuffList = {
	-- 종특	
	[65116]  = 1, --석화

	[118038] = 1, --WARRIOR
	[23920]  = 1, --WARRIOR
	[12975]  = 1, --WARRIOR
	[1160]   = 1, --WARRIOR
	[18499]  = 1, --WARRIOR
	[871]    = 1, --WARRIOR
	[97463]  = 1, --WARRIOR
	[184364] = 1, --WARRIOR
	[386394] = 1, --WARRIOR
	[392966] = 1, --WARRIOR
	[213915] = 1, --WARRIOR
	[147833] = 1, --WARRIOR
	[386208] = 2, --WARRIOR 방어태세 딜러/힐러만

	[185311] = 1, --ROGUE
	[11327]  = 1, --ROGUE
	[1966]   = 1, --ROGUE
	[31224]  = 1, --ROGUE
	[31230]  = 1, --ROGUE
	[5277]   = 1, --ROGUE
	[199754] = 1, --ROGUE
	[45182]  = 1, --ROGUE

	[212800] = 1, --DEMONHUNTER
	[187827] = 1, --DEMONHUNTER
	[206803] = 1, --DEMONHUNTER
	[196555] = 1, --DEMONHUNTER
	[263648] = 1, --DEMONHUNTER
	[209426] = 1, --DEMONHUNTER
	[198589] = 1, --DEMONHUNTER

	[202162] = 1, --MONK
	[388615] = 1, --MONK
	[116849] = 1, --MONK
	[322507] = 1, --MONK
	[120954] = 1, --MONK
	[122783] = 1, --MONK
	[122278] = 1, --MONK
	[132578] = 1, --MONK
	[115176] = 1, --MONK
	[122470] = 1, --MONK
	[125174] = 1, --MONK
	[198065] = 1, --MONK
	[201318] = 1, --MONK
	[353319] = 1, --MONK


	[49039]  = 1, --DEATHKNIGHT
	[48707]  = 1, --DEATHKNIGHT
	[48743]  = 1, --DEATHKNIGHT
	[48792]  = 1, --DEATHKNIGHT
	[114556] = 1, --DEATHKNIGHT
	[81256]  = 1, --DEATHKNIGHT
	[219809] = 1, --DEATHKNIGHT
	[206931] = 1, --DEATHKNIGHT
	[194679] = 1, --DEATHKNIGHT
	[55233]  = 1, --DEATHKNIGHT
	[145629] = 1, --DEATHKNIGHT
	[410358] = 1, --DEATHKNIGHT
	[454863] = 1, --DEATHKNIGHT

	-- 사냥꾼 내부전쟁
	[392956] = 1, --HUNTER
	[53480]  = 1, --HUNTER	
	[264735] = 1, --HUNTER
	[186265] = 1, --HUNTER
	[459470] = 1, --HUNTER
	[202748] = 1, --HUNTER

	[355913] = 1, --EVOKER
	[370960] = 1, --EVOKER
	[363534] = 1, --EVOKER
	[357170] = 1, --EVOKER
	[374348] = 1, --EVOKER
	[374227] = 1, --EVOKER
	[363916] = 1, --EVOKER
	[360827] = 1, --EVOKER
	[404381] = 1, --EVOKER
	[378441] = 1, --EVOKER
	[378464] = 1, --EVOKER
	[373267] = 1, --EVOKER

	[305497] = 1, --DRUID
	[354654] = 1, --DRUID
	[201664] = 1, --DRUID
	[157982] = 1, --DRUID
	[102342] = 1, --DRUID
	[61336]  = 1, --DRUID
	[200851] = 1, --DRUID
	[80313]  = 1, --DRUID
	[108238] = 1, --DRUID
	[124974] = 1, --DRUID
	[22812]  = 1, --DRUID
	[5487]  = 2, --DRUID 곰변신 (딜러/힐러만)


	[104773] = 1, --WARLOCK
	[108416] = 1, --WARLOCK
	[212295] = 1, --WARLOCK


	[215769] = 1, --PRIEST
	[328530] = 1, --PRIEST
	[197268] = 1, --PRIEST
	[19236]  = 1, --PRIEST
	[81782]  = 1, --PRIEST
	[33206]  = 1, --PRIEST
	[372835] = 1, --PRIEST
	[391124] = 1, --PRIEST
	[265202] = 1, --PRIEST
	[64843]  = 1, --PRIEST
	[47788]  = 1, --PRIEST
	[47585]  = 1, --PRIEST
	[108968] = 1, --PRIEST
	[15286]  = 1, --PRIEST
	[271466] = 1, --PRIEST
	[586]    = 1, --PRIEST
	[27827]  = 1, --PRIEST
	[232707] = 1, --PRIEST
	[421453] = 1, --PRIEST
	[232708] = 1, --PRIEST

	[199452] = 1, --PALADIN
	[403876] = 1, --PALADIN
	[31850]  = 1, --PALADIN
	[378279] = 1, --PALADIN
	[378974] = 1, --PALADIN
	[86659]  = 1, --PALADIN
	[387174] = 1, --PALADIN
	[327193] = 1, --PALADIN
	[205191] = 1, --PALADIN
	[184662] = 1, --PALADIN
	[498]    = 1, --PALADIN
	[148039] = 1, --PALADIN
	[157047] = 1, --PALADIN
	[31821]  = 1, --PALADIN
	[633]    = 1, --PALADIN
	[6940]   = 1, --PALADIN
	[1022]   = 1, --PALADIN
	[204018] = 1, --PALADIN
	[228049] = 1, --PALADIN
	[642]    = 1, --PALADIN

	[204331] = 1, --SHAMAN
	[108280] = 1, --SHAMAN
	[98008]  = 1, --SHAMAN
	[198838] = 1, --SHAMAN
	[207399] = 1, --SHAMAN
	[108271] = 1, --SHAMAN
	[198103] = 1, --SHAMAN
	[30884]  = 1, --SHAMAN
	[383017] = 1, --SHAMAN
	[108281] = 1, --SHAMAN
	[462844] = 1, --SHAMAN
	[409293] = 1, --SHAMAN
	[98007]  = 1, --SHAMAN
	[204288] = 1, --SHAMAN
	[201633] = 1, --SHAMAN
	[325174] = 1, --SHAMAN
	[260881] = 1, --SHAMAN

	-- 마법사 내부전쟁
	[45438]  = 1, --MAGE 얼음 방패
	[113862] = 1, --MAGE 상투
	[414658] = 1, --MAGE 얼음장
	[342246] = 1, --MAGE 시돌
	[11426]  = 1, --MAGE 얼보
	[235313] = 1, --MAGE 이글거리는 방벽
	[235450] = 1, --MAGE 오색 방벽
	[55342]  = 1, --MAGE 환영 복제
	[414661] = 1, --MAGE 얼보 (대규모)
	[414662] = 1, --MAGE 이글 (대규모)
	[414663] = 1, --MAGE 오색 (대규모)
	[414664] = 1, --MAGE 대규모 투명화
	[86949]  = 1, --MAGE 소작


}

-- 변경하면 안됨
ns.ACRB_MAX_BUFFS = 6           -- 최대 표시 버프 개수 (3개 + 3개)
ns.ACRB_MAX_DEBUFFS = 3         -- 최대 표시 디버프 개수 (3개)
ns.ACRB_MAX_DEFENSIVE_BUFFS = 2 -- 최대 생존기 개수
ns.ACRB_MAX_DISPEL_DEBUFFS = 3  -- 최대 해제 디버프 개수 (3개)
ns.ACRB_MAX_CASTING = 2         -- 최대 Casting Alert
ns.ACRB_MaxBuffSize = 20        -- 최대 Buff Size 창을 늘려도 이 크기 이상은 안커짐
ns.ACRB_HealerManaBarHeight = 3 -- 힐러 마나바 크기 (안보이게 하려면 0)

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
		ACRB_Options[variable] = value;
		ns.options[variable] = value;
		ns.SetupAll(true);
	end

	local category = Settings.RegisterVerticalLayoutCategory("asCompactRaidBuff")

	if ACRB_Options == nil or ACRB_Options.version ~= Options_Default.version then
		ACRB_Options = {};
		ACRB_Options = CopyTable(Options_Default);
	end

	ns.options = CopyTable(ACRB_Options);

	for variable, _ in pairs(Options_Default) do
		local name = variable;

		if name ~= "version" then
			local cvar_name = "asCompactRaidBuff_" .. variable;
			local tooltip = ""
			if ACRB_Options[variable] == nil then
				if type(Options_Default[variable]) == "table" then
					ACRB_Options[variable] = CopyTable(Options_Default[variable]);
					ns.options[variable] = CopyTable(Options_Default[variable]);
				else
					ACRB_Options[variable] = Options_Default[variable];
					ns.options[variable] = Options_Default[variable];
				end
			end
			local defaultValue = ACRB_Options[variable];

			if type(defaultValue) == "table" then
				--do nothing
			elseif tonumber(defaultValue) ~= nil then
				local setting, options;
				if tonumber(defaultValue) < 1 and tonumber(defaultValue) > 0 then
					setting = Settings.RegisterAddOnSetting(category, cvar_name,  variable, tempoption, type(defaultValue), name, defaultValue);
					options = Settings.CreateSliderOptions(0.1, 0.9, 0.1);
				else
					setting = Settings.RegisterAddOnSetting(category, cvar_name,  variable, tempoption, type(defaultValue), name, defaultValue);
					options = Settings.CreateSliderOptions(0, 100, 1);
				end

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
