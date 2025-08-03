---@diagnostic disable: param-type-mismatch
local _, ns = ...;
local version = select(4, GetBuildInfo());

ns.EnumButtonType = EnumUtil.MakeEnum(
	"Spell",
	"Buff",
	"BuffOnly",
	"Debuff",
	"DebuffOnly",
	"Totem"
);


ACI_Options_Default = {
	version = 250207,
	-- 	ACI_SpellList_직업명_특성숫자
	-- 	{Spell, Type, unit, number, countbuff, realbuff, countdebuff, bufflist, alertbufflist, checkcool, checkplatecount, buffshowtime, checksnapshot, countauraremain} 순으로 편집
	-- 	Spell 기술명 혹은 ID (버프는 ID로 입력해야 Icon 나옴)
	-- 	Type : 1 Spell Cool down
	-- 	Type : 2 버프 & Spell Cool down, buff가 없으면 Cooldown check
	-- 	Type : 3 버프 only buff ID 등록해야 함 arg1 없을 경우 "player", "pet"으로 pet 버프 확인가능 ex 	{118455, 3, "pet"},
	-- 	Type : 4 디버프 & Spell Cool down, arg1 이 없을 경우 "target", "player"로 하면 자신의 디버프 확인 가능 "focus" 활용가능  ex	{"약점 공격", 4},
	-- 	Type : 5 디버프 only debuff ID ex {55078, 5}, --> 죽기 역병
	-- 	Type : 6 Totem 버프
	-- 시작은 99로 하면 다음 특성 이름이 켜 있을때 없을때로 구분 예 {99, "주문술사의 흐름", {116267, 7, "player", nil, 4}, {"마력의 룬", 11, nil, true}}, 면 주문술사 켜 있으면 첫 array, 아니면 다음 array


	-- 무전
	ACI_SpellList_WARRIOR_1 = {
		version = 250207,
		{ 260708, 2 },
		{ 12294,  1, nil, nil, 7384 },
		{ 167105, 1 },
		{ 163201, 1 },
		{ 772,    4, nil, 1 },

	},


	-- 분전
	ACI_SpellList_WARRIOR_2 = {
		version = 250303,
		{ 85288,       1 },
		{ 23881,       1 },
		{ 1719,        2 },
		{ 163201,      1 },
		{ { 6343, 1 }, { 315720, 1 }, { 385059, 1 }, { 446035, 1 }, { 384318, 1 } },


	},

	-- 방전
	ACI_SpellList_WARRIOR_3 = {
		version = 250730,
		{ 190456, 2 },
		{ 23922,  1 },
		{{436358, 4, nil, nil, nil, 447513}, { 1160,   4 }},
		{ 6343,   1 },
		{ 23920,  2 },
	},

	-- 암살
	ACI_SpellList_ROGUE_1 = {
		version = 250207,
		{ { 121411, 4, nil, 12 * 0.3 }, { 32645, 2 } },
		{ 5938,                         4 },
		{ { 385627, 2 },                { 360194, 4 } },
		{ 703,                          4,            nil, 1,        nil, 703, nil, nil, nil, nil, nil, nil, true },
		{ 1943,                         4,            nil, 24 * 0.3, nil, nil, nil, nil, nil, nil, 6 },
	},

	--무법
	ACI_SpellList_ROGUE_2 = {
		version = 250207,
		{ 315508, 2, nil, nil, nil, nil, nil, { 193359, 193356, 193357, 199603, 193358, 199600 } },
		{ 195627, 3, nil, 20 },
		{ 13750,  2, nil, nil, nil, nil, nil, nil,                                               nil,       1 },
		{ 13877,  2, nil, nil, nil, nil, nil, nil,                                               nil,       1 },
		{ 315341, 1, nil, nil, nil, nil, nil, nil,                                               { 115192 } },
	},

	--잠행
	ACI_SpellList_ROGUE_3 = {
		version = 250207,
		{ 212283, 2 },
		{ 185313, 2 },
		{ 121471, 2 },
		{ 280719, 1 },
		{ 1943,   4, nil, 24 * 0.3, nil, nil, nil, nil, nil, nil, 6 },
	},

	--야수
	ACI_SpellList_HUNTER_1 = {
		version = 250207,
		{ 99,            115939,               { 118455, 3, "pet", 2 }, { 212431, 1 } },
		{ 34026,         1 },
		{ 19574,         2 },
		{ 53351,         1 },
		{ { 120679, 1 }, { 217200, 5, nil, 1 } },
	},

	--사격
	ACI_SpellList_HUNTER_2 = {
		version = 250227,
		{ { 260243, 2 }, { 342076, 2, nil, 2, 342076 } },
		{ 257044, 1 },
		{ 288613, 2 },
		{ 53351,  1 },
		{ 212431, 1 },
	};

	--생존
	ACI_SpellList_HUNTER_3 = {
		version = 250303,
		{ 212436,        1 },
		{ 259489,        1 },
		{ { 203415, 1 }, { 360966, 4 }, { 360952, 2} },
		{ 53351,         1 },
		{ { 269751, 1 }, { 259491, 5, nil, 1 } },
	},

	--비전
	ACI_SpellList_MAGE_1 = {
		version = 250207,
		{ 383783, 3 },
		{ 153626, 1 },
		{ 365350, 2 },
		{ 321507, 4 },
		{ 382440, 1 },
	},

	--화염	
	ACI_SpellList_MAGE_2 = {
		version = 250315,
		{ 382440,                                 1 },
		{ { 2948, 1, nil, 30, nil, nil, 383608, nil, nil, nil, nil, nil, nil, 4 }, { 382440, 1 } },
		{ 190319,                                 2 },
		{ { 153561, 1 },                          { 31661, 1 }, { 157980, 1 } },
		{ 99,                                     431044,       { 431177, 3 }, { 12654, 5 } },
	},

	--냉기
	ACI_SpellList_MAGE_3 = {
		version = 250208,
		{ 99,     270233, { 190356, 1 }, { 382440, 1 } },
		{ 84714,  1 },
		{ 99,     417493, { 120, 1 },    { 12472, 2 } },
		{ 153595, 1 },
		{ 228358, 5,      nil,           6.3,          nil, nil, nil, { 122, 136511, 33395, 157997, 378760, 228600 } },
	},

	--신성
	ACI_SpellList_PALADIN_1 = {
		version = 250207,
		{ 26573,  6 },
		{ 35395,  1 },
		{ 99,     432459, { 432459, 1 }, { 31884, 2 } },
		{ 24275,  1 },
		{ 275779, 4,      nil,           nil,         nil, 414022 },
	},

	--보호
	ACI_SpellList_PALADIN_2 = {
		version = 250207,
		{ 26573,  6 },
		{ 31935,  1 },
		{ 99,     427445, { 387174, 1 }, { 432459, 1 } },
		{ 24275,  1 },
		{ 275779, 4 },
	},

	--징벌
	ACI_SpellList_PALADIN_3 = {
		version = 250207,
		{ { 343721, 4 },                                      { 343527, 4 } },
		{ 99,                                                 404542,                                           { 255937, 1 }, { 35395, 1 } },
		{ { 231895, 2, nil, nil, nil, nil, nil, { 454373 } }, { 31884, 2, nil, nil, nil, nil, nil, { 454351 } } },
		{ 24275,                                              1 },
		{ 275779,                                             4 },
	},

	--수양
	ACI_SpellList_PRIEST_1 = {
		version = 250207,
		{ 34433, 6 },
		{ 47540, 1,      nil,           nil,         373183 },
		{ 99,    428924, { 428924, 1 }, { 47536, 2 } },
		{ 32379, 1 },
		{ 589,   4,      nil,           1 },
	},

	--신성
	ACI_SpellList_PRIEST_2 = {
		version = 250207,
		{ 33076,         1 },
		{ { 204883, 1 }, { 47788, 2 } },
		{ 99,            428924,      { 428924, 1 }, { 120517, 2, nil, nil, nil, 453846 } },
		{ 88625,         1 },
		{ 14914,         4 },
	},

	--암흑
	ACI_SpellList_PRIEST_3 = {
		version = 250802,
		{ 335467,        4 },
		{ { 263165, 1 },{ 120644, 1 },  { 589, 4, nil, 1 } },
		{ { 228260, 1 }, { 391109, 2 } },
		{ 32379,         1 },
		{ 34914,         4,                 nil, 1 },
	},

	--혈기
	ACI_SpellList_DEATHKNIGHT_1 = {
		version = 250207,
		{ 43265,  2, nil, nil, nil, 188290 },
		{ 77535,  3 },
		{ 55233,  2 },
		{ 50842,  1 },
		{ 195292, 4, nil, nil, nil, 55078 },

	},

	--냉기
	ACI_SpellList_DEATHKNIGHT_2 = {
		version = 250207,
		{ 43265,                  2,           nil, nil, nil, 188290 },
		{ 196770,                 2 },
		{ 51271,                  2,           nil, nil, nil, nil,   nil, { 51271, 377195 } },
		{ { 343294, 1, nil, 35 }, { 47568, 2 } },
		{ 49184,                  4,           nil, nil, nil, 55095 },

	},

	--부정
	ACI_SpellList_DEATHKNIGHT_3 = {
		version = 250207,
		{ 43265,                  2,            nil,  nil, nil, 188290 },
		{ 85948,                  4,            nil,  0,   nil, 194310 },
		{ 63560,                  2,            "pet" },
		{ { 343294, 1, nil, 35 }, { 207289, 2 } },
		{ 77575,                  4,            nil,  1,   nil, 191587 },

	},

	--양조
	ACI_SpellList_MONK_1 = {
		version = 250207,
		{ { 116847, 2 }, { 322120, 3 } },
		{ 107428,        1 },
		{ 121253,        1 },
		{ 205523,        1 },
		{ 322101,        1 },
	},

	--운무
	ACI_SpellList_MONK_2 = {
		version = 250207,
		{ 100784,                                  1,                                   nil, nil, 202090 },
		{ 107428,                                  1 },
		{ { 325197, 6, nil, nil, 343820, 877514 }, { 322118, 6, nil, nil, nil, 574571 } }, --츠지, 위론
		{ { 388193, 1 },                           { 116849, 1 } },
		{ 116680,                                  2 },
	},

	--풍운
	ACI_SpellList_MONK_3 = {
		version = 250207,
		{ 101546, 1 },
		{ 107428, 1, nil, nil, 202090 },
		{ 137639, 2, nil, nil, nil,   137639 },
		{ 113656, 1, nil, nil, 195321 },
		{ 392983, 4, nil, nil, nil,   451582 },
	},

	--조화
	ACI_SpellList_DRUID_1 = {
		version = 250207,
		{ 8921,                  4,             nil,           1 },
		{ { 274281, 1 },         { 202770, 1 }, { 205636, 1 }, { 202425, 1 } },
		{ { 102560, 2 },         { 194223, 2 } },
		{ { 202347, 4, nil, 1 }, { 202345, 3 } },
		{ 93402,                 4,             nil,           1 },
	},

	--야성
	ACI_SpellList_DRUID_2 = {
		version = 250207,
		{ 106830,                                              4,             nil,          1,        nil, 405233, nil, nil, nil, nil, nil, nil, true },
		{ { 391888, 4, nil, nil, nil, nil, nil, nil, nil, 1 }, { 274837, 1 }, { 106951, 2 } },
		{ 5217,                                                2 },
		{ 1079,                                                4,             nil,          19 * 0.3, nil, 1079,   nil, nil, nil, nil, nil, nil, true },
		{ 1822,                                                4,             nil,          1,        nil, 155722, nil, nil, nil, nil, nil, nil, true },
	},

	--수호
	ACI_SpellList_DRUID_3 = {
		version = 250207,
		{ 77758,         1 },
		{ 33917,         1 },
		{ 50334,         2 },
		{ { 204066, 2 }, { 200851, 2 }, { 22812, 2 } },
		{ 8921,          4,             nil,         1 },
	},

	--회복
	ACI_SpellList_DRUID_4 = {
		version = 250207,
		{ 145205,        2 },
		{ 18562,         1 },
		{ { 391528, 1 }, { 33891, 2, nil, nil, nil, 117679 } },
		{ 48438,         1 },
		{ 8921,          4,                                  nil, 1 },
	},


	--정기
	ACI_SpellList_SHAMAN_1 = {
		version = 250721,
		{ 260734,        3 },
		{ { 375982, 1 }, { 114050, 1 } },
		{ 99,            462816,       { 191634, 2 },                   { 192249, 6, nil, nil, nil, 2065626, nil, { 1020304 }, nil, nil, nil, 24 }, { 198067, 6, nil, nil, nil, 135790, nil, nil, nil, nil, nil, 24 } },
		{ 99,            462816,       { 196840, 1, nil, nil, 462818 }, { 191634, 2 } },
		{ 470411,        4,            nil,                             18 * 0.3,                                                                   nil,                                                              nil, nil, nil, nil, nil, 6 },

	},

	--고양	
	ACI_SpellList_SHAMAN_2 = {
		version = 250228,
		{ { 60103, 1, nil, nil, 390371 }, { 470194, 1 }, { 333974, 1 },                   { 114051, 2 } },
		{ 17364,                          1 },
		{ 99,                             469314,        { 384352, 2 },                   { 51533, 2, nil, nil, nil, 333957, nil, { 1, 224125, 224126, 224127 }, nil, 1 } }, -- 야수정령
		{ 99,                             334195,        { 196840, 1, nil, nil, 334196 }, { 375982, 1 },                                                                  { 444995, 6 }, { 187874, 1 } },
		{ 99, 469344, {197214, 1}, { 470411,                         4,             nil,                             18 * 0.3,                                                                       nil,           nil,          nil, nil, nil, nil, 6 }},
	};

	--복원
	ACI_SpellList_SHAMAN_3 = {
		version = 250208,
		{ 73920,                                1 },
		{ 51505,                                1 },
		{ { 73685, 1 },                         { 108280, 6 } },
		{ { 157153, 6, nil, nil, nil, 971076 }, { 5394, 6 } },
		{ 470411,                               4,            nil, 18 * 0.3 },
	},


	--고통
	ACI_SpellList_WARLOCK_1 = {
		version = 250207,
		{ 48181,         4 },
		{ 316099,        4,                                    nil, 1 },
		{ { 442726, 2 }, { 205180, 6, nil, nil, nil, 1416161 } },
		{ 172,           4,                                    nil, 1 },
		{ 980,           4,                                    nil, 1 },

	},

	--악마
	ACI_SpellList_WARLOCK_2 = {
		version = 250303,
		{ 99,     264130, { 264130, 1 }, { 89751, 2, "pet", nil, nil, 89751 } },
		{ 104316, 1 },
		{ 265187, 2,      "pet",         nil,                                 nil, 265273 },
		{ 264057, 1 },
		{ 99,     264119, { 264119, 1 }, { 460553, 5 } },
	},

	--파괴
	ACI_SpellList_WARLOCK_3 = {
		version = 250620,
		{ 196406,        3 },
		{ 99,            456985,                            { 6353, 1 },                               { 196447, 1 } },
		{ { 442726, 2 }, { 1122, 6, nil, nil, nil, 136219 } },
		{ 99,            387506,                            { 394087, 5, "nameplate", 5, nil, 80240 }, { 80240, 4, "nameplate" } },
		{ 99,            445468,                           { 445468, 4, nil, 1 } ,    { 348, 4, nil, 1 }},

	},


	--악딜
	ACI_SpellList_DEMONHUNTER_1 = {
		version = 250226,
		{ 258920,        2,            nil, nil, nil, nil, nil, {258920, 427912 } },
		{ 188499,        1 },
		{ 191427,        2 },
		{ 198013,        1 },
		{ { 232893, 1 }, { 204596, 4 } },

	},

	--복수
	ACI_SpellList_DEMONHUNTER_2 = {
		version = 250207,
		{ 258920, 2, nil, nil, nil, 258920 },
		{ 204596, 4 },
		{ 204021, 4 },
		{ 212084, 1 },
		{ 224509, 5 },
	},

	--황폐
	ACI_SpellList_EVOKER_1 = {
		version = 250207,
		{ 99,            375801,       { 375802, 3 }, { 357210, 1 } },
		{ { 370452, 4 }, { 357210, 1 } },
		{ 375087,        2 },
		{ 359073,        1 },
		{ 357208,        1 },
	},

	--기원
	ACI_SpellList_EVOKER_2 = {
		version = 250207,
		{ 360995,        1 },
		{ 366155,        1 },
		{ 382731,        1 },
		{ 382614,        1 },
		{ { 373861, 1 }, { 382266, 1 } },
	},

	--증강
	ACI_SpellList_EVOKER_3 = {
		version = 250207,
		{ 409311, 1 },
		{ 395152, 1 },
		{ 442204, 1 },
		{ 396286, 1 },
		{ 357208, 1 },
	},

};

if version >= 110200 then
	--부정
	ACI_Options_Default.ACI_SpellList_DEATHKNIGHT_3 = {
		version = 250803,
		{ 43265,                  2,            nil,  nil, nil, 188290 },
		{ 85948,                  4,            nil,  0,   nil, 194310 },
		{{ 275699,                  2,     nil, nil, nil, 1235391 },{ 63560,                  2,            "pet" }},
		{ { 343294, 1, nil, 35 }, { 207289, 2 } },
		{ 77575,                  4,            nil,  1,   nil, 191587 },

	};
	ACI_Options_Default.ACI_SpellList_DEATHKNIGHT_2 = {
		version = 250804,
		{ 43265,                  2,           nil, nil, nil, 188290 },
		{ 196770,                 2 },
		{ 51271,                  2,           nil, nil, nil, nil,   nil, { 51271, 377195 } },
		{ { 343294, 1, nil, 35 }, { 1249658, 2 }, { 279302, 1 } },
		{ 49184,                  4,           nil, nil, nil, 55095 },

	};

	--야수
	ACI_Options_Default.ACI_SpellList_HUNTER_1 = {
		version = 250710,
		{ 99,            115939,               { 118455, 3, "pet", 2 }, { 212431, 1 }, {359844, 2}, {264735, 2}  },
		{ 34026,         1 },
		{ 19574,         2 },
		{ 53351,         1 },
		{ { 321530, 4 }, { 217200, 5, nil, 1 } },
	};

	--사격
	ACI_Options_Default.ACI_SpellList_HUNTER_2 = {
		version = 250227,
		{ { 260243, 2 }, { 342076, 2, nil, 2, 342076 } },
		{ 257044, 1 },
		{ 288613, 2 },
		{ 53351,  1 },
		{ 212431, 1 },
	};

	--생존
	ACI_Options_Default.ACI_SpellList_HUNTER_3 = {
		version = 250303,
		{ 212436,        1 },
		{ 259489,        1 },
		{ { 203415, 1 }, { 360966, 4 }, { 360952, 2} },
		{ 53351,         1 },
		{ { 269751, 1 }, { 259491, 5, nil, 1 } },
	};
end

ACI_OptionM = {};
local update_callback = nil;

local curr_y = 0;
local y_adder = -40;

local panel = CreateFrame("Frame")
panel.name = "asCombatInfo" -- see panel fields
if InterfaceOptions_AddCategory then
	InterfaceOptions_AddCategory(panel)
else
	local category, layout = Settings.RegisterCanvasLayoutCategory(panel, panel.name);
	Settings.RegisterAddOnCategory(category);
end

local spelllist = {};
local scrollFrame = nil;

local function SetupEditBoxOption()
	curr_y = 0;

	if scrollFrame then
		scrollFrame:Hide()
		scrollFrame:UnregisterAllEvents()
		scrollFrame = nil;
	end

	scrollFrame = CreateFrame("ScrollFrame", nil, panel, "UIPanelScrollFrameTemplate")
	scrollFrame:SetPoint("TOPLEFT", 3, -4)
	scrollFrame:SetPoint("BOTTOMRIGHT", -27, 4)

	-- Create the scrolling child frame, set its width to fit, and give it an arbitrary minimum height (such as 1)
	local scrollChild = CreateFrame("Frame")
	scrollFrame:SetScrollChild(scrollChild)
	scrollChild:SetWidth(600)
	scrollChild:SetHeight(1)

	-- add widgets to the panel as desired
	local title = panel:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
	title:SetPoint("TOP")
	title:SetText("asCombatInfo")

	local btn = CreateFrame("Button", nil, panel, "UIPanelButtonTemplate")
	btn:SetPoint("TOPRIGHT", -50, -10)
	btn:SetText("Reset")
	btn:SetWidth(100)
	btn:SetScript("OnClick", function()
		ACI_Options = {};
		ACI_Options.version = ACI_Options_Default.version;
		local spec = GetSpecialization();
		local specID = PlayerUtil.GetCurrentSpecID();
		local configID = (C_ClassTalents.GetLastSelectedSavedConfigID(specID) or 0) + 19;
		local _, englishClass = UnitClass("player");
		local listname = "ACI_SpellList_" .. englishClass .. "_" .. spec;
		local default = ACI_Options_Default[listname];

		if spec == nil or spec > 4 or (englishClass ~= "DRUID" and spec > 3) then
			spec = 1;
		end

		if ACI_Options[spec] == nil then
			ACI_Options[spec] = {};
		end



		if default then
			if type(default) == "table" then
				ACI_Options[spec][configID] = CopyTable(default);
			end
		end

		ACI_OptionM.UpdateAllOption();
		ReloadUI();
	end)

	local spec = GetSpecialization();
	local specID = PlayerUtil.GetCurrentSpecID();
	local configID = (C_ClassTalents.GetLastSelectedSavedConfigID(specID) or 0) + 19;
	local _, englishClass = UnitClass("player");

	if spec == nil or spec > 4 or (englishClass ~= "DRUID" and spec > 3) then
		spec = 1;
	end

	local count = 1;

	curr_y = curr_y + y_adder;

	local x = 50;

	local title = scrollChild:CreateFontString(nil, "ARTWORK", "GameFontNormal");
	title:SetPoint("TOPLEFT", x, curr_y);
	title:SetText("Spell/Buff/Debuff name or ID");

	x = x + 300


	title = scrollChild:CreateFontString(nil, "ARTWORK", "GameFontNormal");
	title:SetPoint("TOPLEFT", x, curr_y);
	title:SetText("Type");



	for idx = 1, 11 do
		curr_y = curr_y + y_adder;

		title = scrollChild:CreateFontString(nil, "ARTWORK", "GameFontNormal");
		title:SetPoint("LEFT", 10, curr_y);
		title:SetText(tostring(idx));


		local x = 50;
		local initdata = "";
		local initselect = 0;
		local values = spelllist[idx];

		if values and type(values) == "table" and values.config and values.config == true and values[1] ~= nil and values[2] ~= nil then
			initdata = values[1];
			initselect = values[2];
		elseif values and type(values) == "table" and values[1] ~= nil then
			initdata = values[1];
			initselect = 7;
		end

		local editBox = CreateFrame("EditBox", nil, scrollChild)
		do
			local editBoxLeft = editBox:CreateTexture(nil, "BACKGROUND")
			editBoxLeft:SetTexture(130959) --"Interface\\ChatFrame\\UI-ChatInputBorder-Left"
			editBoxLeft:SetHeight(32)
			editBoxLeft:SetWidth(32)
			editBoxLeft:SetPoint("LEFT", -14, 0)
			editBoxLeft:SetTexCoord(0, 0.125, 0, 1)
			local editBoxRight = editBox:CreateTexture(nil, "BACKGROUND")
			editBoxRight:SetTexture(130960) --"Interface\\ChatFrame\\UI-ChatInputBorder-Right"
			editBoxRight:SetHeight(32)
			editBoxRight:SetWidth(32)
			editBoxRight:SetPoint("RIGHT", 6, 0)
			editBoxRight:SetTexCoord(0.875, 1, 0, 1)
			local editBoxMiddle = editBox:CreateTexture(nil, "BACKGROUND")
			editBoxMiddle:SetTexture(130960) --"Interface\\ChatFrame\\UI-ChatInputBorder-Right"
			editBoxMiddle:SetHeight(32)
			editBoxMiddle:SetWidth(1)
			editBoxMiddle:SetPoint("LEFT", editBoxLeft, "RIGHT")
			editBoxMiddle:SetPoint("RIGHT", editBoxRight, "LEFT")
			editBoxMiddle:SetTexCoord(0, 0.9375, 0, 1)
		end

		editBox:HookScript("OnTextChanged", function() end);
		editBox:SetHeight(32)
		editBox:SetWidth(200)
		editBox:SetPoint("LEFT", scrollChild, "TOPLEFT", x, curr_y)
		editBox:SetFontObject("GameFontHighlight")
		editBox:SetMultiLine(false);
		editBox:SetMaxLetters(20);
		editBox:SetText(initdata);
		editBox:SetAutoFocus(false);
		editBox:ClearFocus();
		editBox:SetTextInsets(0, 0, 0, 1);
		editBox:SetNumeric(true);
		editBox:Show();
		editBox:SetCursorPosition(0);
		x = x + 210;

		local dropDown = CreateFrame("Frame", nil, scrollChild, "UIDropDownMenuTemplate")
		dropDown:SetPoint("LEFT", scrollChild, "TOPLEFT", x, curr_y)
		UIDropDownMenu_SetWidth(dropDown, 200) -- Use in place of dropDown:SetWidth


		local dropdownOptions = {
			{ text = "Spell (SpellId)",          value = 1 },
			{ text = "Spell + Buff (SpellId)",   value = 2 },
			{ text = "Buff Only (BuffId)",       value = 3 },
			{ text = "Spell + Debuff (SpellId)", value = 4 },
			{ text = "Debuff Only (DebuffId)",   value = 5 },
			{ text = "Spell + Totem (SpellId)",  value = 6 },
			{ text = "Default",                  disabled = true, value = 7 },
		}

		local function updatedata()
			local data = editBox:GetNumber()
			local type = UIDropDownMenu_GetSelectedValue(dropDown);

			if data ~= nil and type > 0 and type <= 6 then
				ACI_Options[spec][configID][idx] = {};
				ACI_Options[spec][configID][idx].config = true;
				ACI_Options[spec][configID][idx][1] = data;
				ACI_Options[spec][configID][idx][2] = tonumber(type);

				if update_callback then
					update_callback();
				end
			end
		end


		UIDropDownMenu_Initialize(dropDown, function(self, level)
			for _, option in ipairs(dropdownOptions) do
				local info = UIDropDownMenu_CreateInfo()
				info.text = option.text
				info.value = option.value
				info.disabled = option.disabled
				local function Dropdown_OnClick()
					UIDropDownMenu_SetSelectedValue(dropDown, option.value);
					updatedata();
				end
				info.func = Dropdown_OnClick;
				UIDropDownMenu_AddButton(info, level)
			end
		end);
		UIDropDownMenu_SetSelectedValue(dropDown, initselect);


		editBox:HookScript("OnTextChanged", function(self, updated)
			if updated == false then
				return;
			end

			updatedata();
		end)

		count = count + 1;
	end
end

local function InitOption()
	local spec = GetSpecialization();
	local specID = PlayerUtil.GetCurrentSpecID();
	local configID = (C_ClassTalents.GetLastSelectedSavedConfigID(specID) or 0) + 19;
	local _, englishClass = UnitClass("player");

	if spec == nil or spec > 4 or (englishClass ~= "DRUID" and spec > 3) then
		spec = 1;
	end

	local listname = "ACI_SpellList_" .. englishClass .. "_" .. spec;
	local default = ACI_Options_Default[listname];

	if ACI_Options == nil or ACI_Options.version ~= ACI_Options_Default.version then
		ACI_Options = {};
		ACI_Options.version = (ACI_Options_Default.version);
		ACI_Options[spec] = {};
		ACI_Options[spec][configID] = CopyTable(default);
	elseif ACI_Options[spec] and ACI_Options[spec][configID] then
		if default.version ~= ACI_Options[spec][configID].version then
			ACI_Options[spec][configID] = CopyTable(default);
		end
	elseif ACI_Options[spec] then
		ACI_Options[spec][configID] = CopyTable(default);
	else
		ACI_Options[spec] = {};
		ACI_Options[spec][configID] = CopyTable(default);
	end
end


ACI_OptionM.SetupAllOption = function()
	if update_callback then
		update_callback();
	end
end

ACI_OptionM.UpdateAllOption = function()
	if update_callback then
		update_callback();
	end
end

ACI_OptionM.RegisterCallback = function(callback_func)
	update_callback = callback_func;
end

ACI_OptionM.UpdateSpellList = function(spell_list)
	spelllist = spell_list;
end

function panel:OnEvent(event, arg1)
	if event == "ADDON_LOADED" and arg1 == "asCombatInfo" then
		C_Timer.After(1, InitOption);
		C_Timer.After(1.5, ACI_OptionM.SetupAllOption)
	elseif event == "TRAIT_CONFIG_UPDATED" or event == "TRAIT_CONFIG_LIST_UPDATED" or event == "ACTIVE_TALENT_GROUP_CHANGED" then
		C_Timer.After(1, InitOption);
		C_Timer.After(1.5, ACI_OptionM.SetupAllOption)
	end
end

local function panelOnShow()
	SetupEditBoxOption();
end
local function panelOnHide()
	if scrollFrame then
		scrollFrame:Hide()
		scrollFrame:UnregisterAllEvents()
		scrollFrame = nil;
	end
end

panel:RegisterEvent("ADDON_LOADED")
panel:RegisterEvent("TRAIT_CONFIG_UPDATED");
panel:RegisterEvent("TRAIT_CONFIG_LIST_UPDATED");
panel:RegisterEvent("ACTIVE_TALENT_GROUP_CHANGED")
panel:SetScript("OnEvent", panel.OnEvent)
panel:SetScript("OnShow", panelOnShow)
panel:SetScript("OnHide", panelOnHide);
