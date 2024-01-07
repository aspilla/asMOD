local _, ns = ...;

ns.UpdateRate = 0.2;           -- 1회 Update 주기 (초) 작으면 작을 수록 Frame Rate 감소 가능, 크면 Update 가 느림

local Options_Default = {
	version = 240108,
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
	ShowTooltip = true,         -- GameTooltip을 보이게 하려면 True
	HideCooldown = false,		-- CooldownSwipe를 숨기게

	-- 첫 숫자 남은시간에 리필 알림 (1이면 자동으로 30% 남으면 알림)
	-- 두번째 숫자는 표시 위치, 6(우상) 5/4(우중) 1,2,3 은 우하에 보이는 우선 순위이다. (숫자가 클수록 우측에 보임)
	
	ACRB_ShowList_MONK_2 = {
		["소생의 안개"] = { 0, 6 },
		["포용의 안개"] = { 0, 5 },
		["천지교태"] = { 0, 3 }, --시즌3
	},

	-- 신기
	ACRB_ShowList_PALADIN_1 = {
		["빛의 자락"] = { 0, 6 },
		["빛의 봉화"] = { 0, 5 },
		["신념의 봉화"] = { 0, 4 },
		["신성한 울림"] = { 0, 3 }, --시즌3
	},

	-- 수사
	ACRB_ShowList_PRIEST_1 = {
		["속죄"] = { 0, 6 },
		["신의 권능: 보호막"] = { 0, 5 },
		["소생"] = { 1, 4 },
		["회복의 기원"] = { 0, 2 },
		["마력 주입"] = { 0, 1 },
	},


	-- 신사
	ACRB_ShowList_PRIEST_2 = {
		["소생"] = { 1, 6 },
		["신의 권능: 보호막"] = { 0, 5 },
		["회복의 기원"] = { 0, 2 },
		["마력 주입"] = { 0, 1 },
	},

	ACRB_ShowList_PRIEST_3 = {
		["마력 주입"] = { 0, 1 },
	},


	ACRB_ShowList_SHAMAN_3 = {
		["성난 해일"] = { 1, 6 },
		["대지의 보호막"] = { 0, 5 },
		["해일의 저장소"] = { 0, 3 }, --시즌3
	},


	ACRB_ShowList_DRUID_4 = {
		["회복"] = { 1, 6 },
		["피어나는 생명"] = { 1, 5 },
		["재생"] = { 1, 4 },
		["회복 (싹틔우기)"] = { 1, 2 },
		["세나리온 수호물"] = { 0, 1 },
	},

	ACRB_ShowList_EVOKER_2 = {
		["메아리"] = { 0, 6 },
		["되감기"] = { 1, 5 },
	},

	ACRB_ShowList_EVOKER_3 = {
		["예지"] = { 0, 6 },
		["끓어오르는 비늘"] = { 0, 5 },
	},
};

-- 안보이게 할 디법
ns.ACRB_BlackList = {
	["도전자의 짐"] = 1,
}


--직업별 생존기 등록 (10초 쿨다운), 용군단 Version
ns.ACRB_DefensiveBuffList = {
	[213871] = 2, --WARRIOR
	[118038] = 2, --WARRIOR
	[236273] = 2, --WARRIOR
	[12975] = 2, --WARRIOR
	[1160] = 2, --WARRIOR
	[871] = 2, --WARRIOR
	[202168] = 2, --WARRIOR
	[97463] = 2, --WARRIOR
	[383762] = 2, --WARRIOR
	[184364] = 2, --WARRIOR
	[386394] = 2, --WARRIOR
	[392966] = 2, --WARRIOR
	[185311] = 2, --ROGUE
	[11327] = 2, --ROGUE
	[1966] = 2, --ROGUE
	[31224] = 2, --ROGUE
	[31230] = 2, --ROGUE
	[5277] = 2, --ROGUE
	[212800] = 2, --DEMONHUNTER
	[203720] = 2, --DEMONHUNTER
	[187827] = 2, --DEMONHUNTER
	[206803] = 2, --DEMONHUNTER
	[196555] = 2, --DEMONHUNTER
	[204021] = 2, --DEMONHUNTER
	[263648] = 2, --DEMONHUNTER
	[209258] = 2, --DEMONHUNTER
	[209426] = 2, --DEMONHUNTER
	[202162] = 2, --MONK
	[388615] = 2, --MONK
	[115310] = 2, --MONK
	[116849] = 2, --MONK
	[115399] = 2, --MONK
	[119582] = 2, --MONK
	[122281] = 2, --MONK
	[322507] = 2, --MONK
	[120954] = 2, --MONK
	[122783] = 2, --MONK
	[122278] = 2, --MONK
	[132578] = 2, --MONK
	[115176] = 2, --MONK
	[51052] = 2, --DEATHKNIGHT
	[48707] = 2, --DEATHKNIGHT
	[327574] = 2, --DEATHKNIGHT
	[48743] = 2, --DEATHKNIGHT
	[48792] = 2, --DEATHKNIGHT
	[114556] = 2, --DEATHKNIGHT
	[81256] = 2, --DEATHKNIGHT
	[219809] = 2, --DEATHKNIGHT
	[206931] = 2, --DEATHKNIGHT
	[274156] = 2, --DEATHKNIGHT
	[194679] = 2, --DEATHKNIGHT
	[55233] = 2, --DEATHKNIGHT
	[272679] = 2, --HUNTER
	[53480] = 2, --HUNTER
	[109304] = 2, --HUNTER
	[264735] = 2, --HUNTER
	[186265] = 2, --HUNTER
	[355913] = 2, --EVOKER
	[370960] = 2, --EVOKER
	[363534] = 2, --EVOKER
	[357170] = 2, --EVOKER
	[374348] = 2, --EVOKER
	[374227] = 2, --EVOKER
	[363916] = 2, --EVOKER
	[360827] = 1, --EVOKER
	[404381] = 2, --EVOKER
	[305497] = 2, --DRUID
	[354654] = 2, --DRUID
	[201664] = 2, --DRUID
	[157982] = 2, --DRUID
	[102342] = 2, --DRUID
	[61336] = 2, --DRUID
	[200851] = 2, --DRUID
	[80313] = 2, --DRUID
	[22842] = 2, --DRUID
	[108238] = 2, --DRUID
	[124974] = 2, --DRUID
	[22812] = 2, --DRUID
	[104773] = 2, --WARLOCK
	[108416] = 1, --WARLOCK
	[215769] = 2, --PRIEST
	[328530] = 2, --PRIEST
	[197268] = 2, --PRIEST
	[19236] = 2, --PRIEST
	[81782] = 2, --PRIEST
	[33206] = 2, --PRIEST
	[372835] = 2, --PRIEST
	[391124] = 2, --PRIEST
	[265202] = 2, --PRIEST
	[64843] = 2, --PRIEST
	[47788] = 2, --PRIEST
	[47585] = 2, --PRIEST
	[108968] = 2, --PRIEST
	[15286] = 2, --PRIEST
	[271466] = 2, --PRIEST
	[199452] = 2, --PALADIN
	[403876] = 2, --PALADIN
	[31850] = 2, --PALADIN
	[378279] = 2, --PALADIN
	[378974] = 2, --PALADIN
	[86659] = 2, --PALADIN
	[387174] = 2, --PALADIN
	[327193] = 2, --PALADIN
	[205191] = 2, --PALADIN
	[184662] = 2, --PALADIN
	[498] = 2, --PALADIN
	[148039] = 2, --PALADIN
	[157047] = 2, --PALADIN
	[31821] = 2, --PALADIN
	[633] = 2, --PALADIN
	[6940] = 2, --PALADIN
	[1022] = 2, --PALADIN
	[204018] = 2, --PALADIN
	[204331] = 2, --SHAMAN
	[108280] = 2, --SHAMAN
	[98008] = 2, --SHAMAN
	[198838] = 2, --SHAMAN
	[207399] = 2, --SHAMAN
	[108271] = 2, --SHAMAN
	[198103] = 2, --SHAMAN
	[30884] = 2, --SHAMAN
	[383017] = 2, --SHAMAN
	[108281] = 2, --SHAMAN
	[198111] = 2, --MAGE
	[110959] = 2, --MAGE
	[342246] = 2, --MAGE
	[11426] = 2, --MAGE
	[66] = 2,  --MAGE
	[235313] = 2, --MAGE
	[235450] = 2, --MAGE
	[55342] = 2, --MAGE
	[414660] = 2, --MAGE
	[414664] = 2, --MAGE
	[86949] = 2, --MAGE
	[235219] = 2, --MAGE
	[414658] = 2, --MAGE
	[110960] = 2, --MAGE
	[125174] = 2, --MONK
	[186265] = 2, --HUNTER
	[378441] = 2, --EVOKER
	[228049] = 2, --PALADIN
	[642] = 2, --PALADIN
	[409293] = 2, --SHAMAN
	[45438] = 2, --MAGE	
	[586] = 2, --PRIEST
}

-- 변경하면 안됨
ns.ACRB_MAX_BUFFS = 6           -- 최대 표시 버프 개수 (3개 + 3개)
ns.ACRB_MAX_DEBUFFS = 3         -- 최대 표시 디버프 개수 (3개)
ns.ACRB_MAX_DEFENSIVE_BUFFS = 2       -- 최대 생존기 개수
ns.ACRB_MAX_DISPEL_DEBUFFS = 3  -- 최대 해제 디버프 개수 (3개)
ns.ACRB_MAX_CASTING = 2         -- 최대 Casting Alert
ns.ACRB_MaxBuffSize = 20        -- 최대 Buff Size 창을 늘려도 이 크기 이상은 안커짐
ns.ACRB_HealerManaBarHeight = 3 -- 힐러 마나바 크기 (안보이게 하려면 0)

ns.options = {};



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
					setting = Settings.RegisterAddOnSetting(category, name, cvar_name, type(defaultValue), defaultValue);
					options = Settings.CreateSliderOptions(0.1, 0.9, 0.1);
				else
					setting = Settings.RegisterAddOnSetting(category, name, cvar_name, type(defaultValue), defaultValue);
					options = Settings.CreateSliderOptions(0, 100, 1);
				end

				options:SetLabelFormatter(MinimalSliderWithSteppersMixin.Label.Right);
				Settings.CreateSlider(category, setting, options, tooltip);
				Settings.SetOnValueChangedCallback(cvar_name, OnSettingChanged);
			else
				local setting = Settings.RegisterAddOnSetting(category, name, cvar_name, type(defaultValue), defaultValue);
				Settings.CreateCheckBox(category, setting, tooltip);
				Settings.SetOnValueChangedCallback(cvar_name, OnSettingChanged);
			end
		end
	end

	Settings.RegisterAddOnCategory(category)
end
