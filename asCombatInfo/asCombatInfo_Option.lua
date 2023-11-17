--무법
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
	version = 231118,


	-- 	ACI_SpellList_직업명_특성숫자
	-- 	{Spell, Type, arg1} 순으로 편집
	-- 	Spell 기술명 혹은 ID (버프는 ID로 입력해야 Icon 나옴)
	-- 	Type : 1 Spell Cool down
	-- 	Type : 2 버프 & Spell Cool down
	-- 	Type : 3 버프 & Spell Cool down 상세 Value가 있는경우
	-- 	Type : 4 디버프 & Spell Cool down, arg1 이 없을 경우 "target", "player"로 하면 자신의 디버프 확인 가능 "focus" 활용가능  ex	{"약점 공격", 4},
	-- 	Type : 7 버프 only Spell ID 등록해야 함 arg1 없을 경우 "player", "pet"으로 pet 버프 확인가능 ex 	{118455, 7, "pet"},
	-- 	Type : 8 디버프 only Spell ID ex {55078, 8}, --> 죽기 역병
	-- 	Type : 9 1 + 대상 체력 % 미만이면 강조 ex {"영혼 쐐기", 9, 35}
	-- 	Type : 11 Totem 버프
	-- 	Type : 14 뼈주사위
	-- 시작은 99로 하면 다음 특성 이름이 켜 있을때 없을때로 구분 예 {99, "주문술사의 흐름", {116267, 7, "player", nil, 4}, {"마력의 룬", 11, nil, true}}, 면 주문술사 켜 있으면 첫 array, 아니면 다음 array


	-- 무전
	ACI_SpellList_WARRIOR_1 = {

		{ "휩쓸기 일격", 2 },
		{ "필사의 일격", 1, nil, nil, "제압" },
		{ "거인의 강타", 1 },
		{ "마무리 일격", 1},
		{ "분쇄", 4, nil, 1 },

	},


	-- 분전
	ACI_SpellList_WARRIOR_2 = {
		{ 99, "파멸자", { 335077, 3 }, { "분노의 강타", 1 } },
		{ "피의 갈증", 1, nil, nil, "끓어오르는 피의 갈증" },
		{ "무모한 희생", 2 },
		{ "마무리 일격", 1},
		{ 99, "맹공", { "맹공", 1 }, { "오딘의 격노", 1 } },


	},

	-- 방전
	ACI_SpellList_WARRIOR_3 = {
		{ "고통 감내", 2 },
		{ "방패 밀쳐내기", 1 },
		{ 99, "투신", { "투신", 2 }, { "천둥의 포효", 1 } },
		{ "천둥벼락", 1 },
		{ "사기의 외침", 4 },

	},

	-- 암살
	ACI_SpellList_ROGUE_1 = {
		{ 99, "혈폭풍", { "혈폭풍", 4, nil, 12 * 0.3 }, { "독살", 2, nil, 1, nil, nil, "증폭의 독" } },
		{ "독칼", 4 },
		{ "죽음표식", 4 },
		{ "목조르기", 4, nil, 1 },
		{ "파열", 4, nil, 24 * 0.3 },
	},

	ACI_SpellList_ROGUE_2 = {
		{ "뼈주사위", 2, nil, 5, nil, nil, nil, { "집중 공격", "무자비한 정밀함", "해적 징표", "진방위", "대난투", "숨겨진 보물" } },
		{ 195627, 3, nil, 20 },
		{ "아드레날린 촉진", 2 },
		{ "폭풍의 칼날", 2 },
		{ "미간 적중", 1, nil, nil, nil, nil, nil, nil, { "기만", "어둠의 춤" } },
	},

	--잠행
	ACI_SpellList_ROGUE_3 = {
		{ "죽음의 상징", 2 },
		{ "어둠의 춤", 2 },
		{ "어둠의 칼날", 2 },
		{ 91021, 5, nil, 10 },
		{ "파열", 4, nil, 24 * 0.3 },
	},

	--야수
	ACI_SpellList_HUNTER_1 = {
		{ 99, "야수의 회전베기", { 118455, 3, "pet", 2 }, { "광포한 야수", 2 } },
		{ "살상 명령", 1 },
		{ "야수의 격노", 2 },
		{ "마무리 사격", 1 },
		{ 217200, 5, nil, 1 },
	},

	--사격
	ACI_SpellList_HUNTER_2 = {
		{ 99, "꾸준한 집중", { 193533, 3 }, { "폭발 사격", 1 } },
		{ "속사", 1 },
		{ "정조준", 2, nil, nil, "윈드러너의 인도" },
		{ "마무리 사격", 1 },
		{ 99, "죽음의 회전 표창", { "죽음의 회전 표창", 4 }, { "독사 쐐기", 4, nil, 1 } },
	},

	--생존
	ACI_SpellList_HUNTER_3 = {
		{ "야생불 폭탄", 1 },
		{ "살상 명령", 1, nil, nil, "창끝" },
		{ 99, "협공", { "협공", 2 }, { "측방 강타", 1 } },
		{ "마무리 사격", 1},
		{ "독사 쐐기", 4, nil, 1 },
	},

	--비전
	ACI_SpellList_MAGE_1 = {
		{ "비전의 여파", 4 },
		{ "비전 보주", 1 },
		{ "비전 쇄도", 2 },
		{ 99, "빛나는 불꽃", { "빛나는 불꽃", 4, nil, nil, nil, "빛나는 불꽃 약화" },
			{ 332769, 3 } },
		{ "황천의 폭풍우", 4 },
	},

	--화염
	ACI_SpellList_MAGE_2 = {
		{ 383883, 3, nil, 30, "태양왕의 축복" },
		{ "불태우기", 1, nil, 30, "불태우기 연마" },
		{ "발화", 2 },
		{ "용의 숨결", 1 },
		{ 99, "유성", { "유성", 1 }, { "힘의 전환", 1 } },
	},

	--냉기
	ACI_SpellList_MAGE_3 = {
		{ 99, "혜성 폭풍", { "혜성 폭풍", 1 }, { "냉기 돌풍", 1 } },
		{ "얼어붙은 구슬", 1 },
		{ "얼음 핏줄", 2 },
		{ "눈보라", 1 },
		{ 228358, 5, nil, 6.3 },
	},

	--신성
	ACI_SpellList_PALADIN_1 = {
		{ 99, "신성한 반사", { "신성한 반사", 1 }, { "빛의 망치", 1 } },
		{ "성전사의 일격", 1 },
		{ "응징의 격노", 2 },
		{ "천벌의 망치", 1 },
		{ "심판", 4, nil, nil, nil, "무가치한 존재" },
	},

	--보호
	ACI_SpellList_PALADIN_2 = {
		{ "신성화", 6, nil, nil, "축성" },
		{ "응징의 방패", 1 },
		{ "응징의 격노", 2 },
		{ "천벌의 망치", 1 },
		{ "심판", 4 },
	},

	--징벌
	ACI_SpellList_PALADIN_3 = {
		{ 99, "최후의 집행", { "최후의 집행", 4 }, { "사형 선고", 4 } },
		{ 99, "성전의 강타", { "파멸의 재", 1 }, { "성전사의 일격", 1 } },
		{ "응징의 격노", 2 },
		{ "천벌의 망치", 1 },
		{ "심판", 4 },
	},

	--수양
	ACI_SpellList_PRIEST_1 = {

		{ "어둠의 마귀", 2, nil, nil, nil, "어둠의 서약" },
		{ "회개", 1, nil, nil, "엄격한 규율" },
		{ "환희", 2 },
		{ "어둠의 권능: 죽음", 1 },
		{ "어둠의 권능: 고통", 4, nil, 1 },
	},

	--신성
	ACI_SpellList_PRIEST_2 = {

		{ "회복의 기원", 1 },
		{ 99, "치유의 마법진", { "치유의 마법진", 1 }, { "수호 영혼", 2 } },
		{ "천상의 찬가", 2 },
		{ "빛의 권능: 응징", 1 },
		{ "신성한 불꽃", 4 },
	},

	--암흑
	ACI_SpellList_PRIEST_3 = {

		{ "파멸의 역병", 4 },
		{ 99, "공허의 격류", { "공허의 격류", 1 }, { "어둠의 권능: 고통", 4, nil, 1 } },
		{ 99, "공허 방출", { "공허 방출", 1 }, { "어둠의 승천", 2 } },
		{ "어둠의 권능: 죽음", 1, nil, nil, "죽음의 고통" },
		{ "흡혈의 손길", 4, nil, 1 },
	},

	--혈기
	ACI_SpellList_DEATHKNIGHT_1 = {

		{ "죽음과 부패", 2, nil, nil, nil, "죽음과 부패" },
		{ 77535, 3 },
		{ "춤추는 룬 무기", 2 },
		{ "피의 소용돌이", 1 },
		{ "죽음의 마수", 4, nil, nil, nil, "피의 역병" },

	},

	--냉기
	ACI_SpellList_DEATHKNIGHT_2 = {
		{ "죽음과 부패", 2, nil, nil, nil, "죽음과 부패" },
		{ 99, "영혼 수확자", {"영혼 수확자", 1, nil, 35}, { "몰아치는 한기", 2, nil, nil, nil, "싸늘한 분노" }},
		{ "얼음 기둥", 2 },
		{ "냉혹한 겨울", 2 },
		{ "울부짖는 한파", 4, nil, nil, nil, "서리 열병" },

	},

	--부정
	ACI_SpellList_DEATHKNIGHT_3 = {
		{ "죽음과 부패", 2, nil, nil, nil, "죽음과 부패" },
		{ 99, "영혼 수확자", {"영혼 수확자", 1, nil, 35}, { "부정의 습격", 2 }},
		{ "어둠의 변신", 2, "pet" },
		{ "돌발 열병", 4, nil, 1, nil, "악성 역병" },
		{ "고름 일격", 4, nil, 0, nil, "고름 상처" },
	},

	--양조
	ACI_SpellList_MONK_1 = {
		{ 99, "비취 돌풍", { "비취 돌풍", 2 }, { 322120, 3 } },
		{ "해오름차기", 1 },
		{ "맥주통 휘두르기", 1 },
		{ "후려차기", 1 },
		{ "해악 축출", 1 },
	},

	--운무
	ACI_SpellList_MONK_2 = {
		{ 99, "셰이룬의 선물", { "셰이룬의 선물", 1 }, { "후려차기", 1, nil, nil, "수도원의 가르침" } },
		{ 99, "셰이룬의 선물", { "해오름차기", 1, nil, nil, "수도원의 가르침" }, { "해오름차기", 1 } },
		{ 99, "주학 츠지의 원령", { "주학 츠지의 원령", 6, nil, nil, "주학 츠지의 원령", "츠지" },
			{ "옥룡 위론의 원령",
				6, nil, nil, nil, "위론" } },
		{ 99, "페이 지맥 울리기", { "페이 지맥 울리기", 1 }, { "집중의 천둥 차", 2 } },
		{ "정수의 샘", 1 },
	},


	--풍운
	ACI_SpellList_MONK_3 = {
		{ 99, "폭풍과 대지와 불", { "폭풍과 대지와 불", 2, nil, nil, nil, "폭풍과 대지와 불" },
			{ "평안", 2 } },
		{ "해오름차기", 1, nil, nil, "수도원의 가르침" },
		{ "백호 쉬엔의 원령", 6, nil, nil, "쉬엔의 분노", "쉬엔" },
		{ "분노의 주먹", 1, nil, nil, "힘 전달" },
		{ 99, "츠지의 춤", { "회전 학다리차기", 1 }, { "해악 축출", 1 } },
	},

	--조화
	ACI_SpellList_DRUID_1 = {
		{ "달빛섬광", 4, nil, 1 },
		{ 99, "엘룬의 분노", { "엘룬의 분노", 1 }, { "초승달", 1 } },
		{ "천체의 정렬", 2, nil, nil, "태고의 비전 맥동" },
		{ 99, "항성의 섬광", { "항성의 섬광", 4, nil, 1 }, { 202345, 3 } },
		{ "태양섬광", 4, nil, 1 },
	},

	--야성
	ACI_SpellList_DRUID_2 = {
		{ "난타", 4 },
		{ 99, "야성의 광기", { "야성의 광기", 2, nil, nil, nil, "이글거리는 광란" }, { "광폭화",
			2 } },
		{ "호랑이의 분노", 2 },
		{ "도려내기", 4, nil, 19 * 0.3 },
		{ "갈퀴 발톱", 4, nil, 1 },
	},

	--수호
	ACI_SpellList_DRUID_3 = {
		{ 99, "잠자는 자의 분노", { "잠자는 자의 분노", 2 }, { "나무 껍질", 2 } },
		{ "난타", 1 },
		{ "광폭화", 2 },
		{ "짓이기기", 1 },
		{ "달빛섬광", 4, nil, 1 },
	},

	--회복
	ACI_SpellList_DRUID_4 = {
		{ "꽃피우기", 2 },
		{ "신속한 치유", 1 },
		{ 99, "영혼 소집", { "영혼 소집", 1 }, { "화신: 생명의 나무", 2, nil, nil, nil, "화신" } },
		{ "급속 성장", 1 },
		{ 99, "평온", { "평온", 1 }, { "번성", 1 } },
	},


	--정기
	ACI_SpellList_SHAMAN_1 = {
		{ 99, "폭풍수호자", { "폭풍수호자", 2 }, { 16166, 3, "player" } },
		{ "용암 폭발", 1 },
		{ 99, "폭풍의 정령", { "폭풍의 정령", 6, nil, nil, nil, "상급 폭풍의 정령" }, { "불의 정령", 11,
			"상급 불의 정령" } },
		{ 99, "얼음격노", { "얼음격노", 2 }, { "태고의 파도", 2 } },
		{ "화염 충격", 4, nil, 1 },

	},

	--고양
	ACI_SpellList_SHAMAN_2 = {
		{ "폭풍의 일격", 1 },
		{ "용암 채찍", 1, nil, nil, "잿빛 수정" },
		{ "야수 정령", 2 },
		{ 99, "우박폭풍", { "냉기 충격", 1, nil, nil, "우박폭풍" }, { "용암 폭발", 1 } },
		{ "화염 충격", 4, nil, 1 },
	},

	--복원
	ACI_SpellList_SHAMAN_3 = {

		{ 53390, 3 },
		{ "용암 폭발", 1 },
		{ "치유의 해일 토템", 6 },
		{ 99, "폭우의 토템", { "폭우의 토템", 6 }, { "치유의 토템", 6 } },
		{ "화염 충격", 4, nil, 1 },
	},


	--고통
	ACI_SpellList_WARLOCK_1 = {

		{ 99, "생명력 착취", { "생명력 착취", 4, nil, 1 }, { "암흑시선 소환", 6, nil, nil, nil, "암흑시선" } },
		{ "유령 출몰", 4 },
		{ "불안정한 고통", 4, nil, 1 },
		{ "부패", 4, nil, 1 },
		{ "고통", 4, nil, 1 },

	},

	--악마
	ACI_SpellList_WARLOCK_2 = {

		{ "마력 착취", 1 },
		{ 99, "흑마법서: 지옥수호병", { "흑마법서: 지옥수호병", 6, nil, nil, nil, "지옥수호병" }, { "지옥폭풍",
			1 } },
		{ "악마 폭군 소환", 2, "pet", nil, nil, "악마의 힘" },
		{ 99, "파열", { "파열", 1 }, { "악마의 기운", 2, "pet" } },
		{ "공포사냥개 부르기", 4, nil, 0, nil, "사냥개조련사의 책략" },
	},

	--파괴
	ACI_SpellList_WARLOCK_3 = {


		{ 99, "악마불 집중", { "악마불 집중", 1 }, { "어둠의 연소", 1 } },
		{ 196406, 3 },
		{ 99, "지옥불정령 소환", { "지옥불정령 소환", 6, nil, nil, nil, "지옥불정령" }, { "어둠의 연소", 1 } },
		{ 99, "차원의 균열", { "차원의 균열", 1 }, { "대혼란", 1 } },
		{ "제물", 4, nil, 1 },

	},


	--악딜
	ACI_SpellList_DEMONHUNTER_1 = {

		{ "제물의 오라", 2 },
		{ "칼춤", 1 },
		{ "탈태", 2 },
		{ "안광", 1 },
		{ 99, "지옥칼", { "지옥칼", 1 }, { "불꽃의 인장", 4 } },

	},

	--복수
	ACI_SpellList_DEMONHUNTER_2 = {

		{ "제물의 오라", 2 },
		{ "불타는 낙인", 4 },
		{ "탈태", 2 },
		{ "불꽃의 인장", 4 },
		{ 224509, 5 },
	},

	--황폐
	ACI_SpellList_EVOKER_1 = {
		{ 99, "불태움", { 375802, 3 }, { "깊은 숨결", 1 } },
		{ 99, "산산이 부서지는 별", { "산산이 부서지는 별", 4 }, { "기염", 1 } },
		{ "용의 분노", 2 },
		{ "영원의 쇄도", 1 },
		{ "불의 숨결", 1 },
	},

	--기원
	ACI_SpellList_EVOKER_2 = {
		{ "신록의 품", 1 },
		{ "되감기", 1 },
		{ "영혼 만개", 1 },
		{ "꿈의 숨결", 1 },
		{ 99, "시간 변칙", { "시간 변칙", 1 }, { "불의 숨결", 1 } },
	},

	ACI_SpellList_EVOKER_3 = {
		{ "예지", 1 },
		{ "칠흑의 힘", 1 },
		{ "깊은 숨결", 1 },
		{ "지각 변동", 1 },
		{ "불의 숨결", 1 },
	},

};




ACI_OptionM = {};
local update_callback = nil;

local curr_y = 0;
local y_adder = -40;

local panel = CreateFrame("Frame")
panel.name = "asCombatInfo"         -- see panel fields
InterfaceOptions_AddCategory(panel) -- see InterfaceOptions API

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
	local title = panel:CreateFontString("ARTWORK", nil, "GameFontNormalLarge")
	title:SetPoint("TOP")
	title:SetText("asCombatInfo")

	local btn = CreateFrame("Button", nil, panel, "UIPanelButtonTemplate")
	btn:SetPoint("TOPRIGHT", -50, -10)
	btn:SetText("설정 초기화")
	btn:SetWidth(100)
	btn:SetScript("OnClick", function()
		ACI_Options = {};
		ACI_Options.version = ACI_Options_Default.version;
		local spec = GetSpecialization();
		local specID = PlayerUtil.GetCurrentSpecID();
		local configID = (C_ClassTalents.GetLastSelectedSavedConfigID(specID) or 0) + 19;
		local localizedClass, englishClass = UnitClass("player");
		local listname;

		if spec == nil then
			spec = 1;
		end

		if spec and ACI_Options[spec] == nil then
			ACI_Options[spec] = {};
		end

		if spec and configID and ACI_Options[spec][configID] == nil then
			listname = "ACI_SpellList_" .. englishClass .. "_" .. spec;
			ACI_Options[spec][configID] = CopyTable(ACI_Options_Default[listname]);
		end
		ACI_OptionM.UpdateAllOption();
		ReloadUI();
	end)

	local spec = GetSpecialization();
	local specID = PlayerUtil.GetCurrentSpecID();
	local configID = (C_ClassTalents.GetLastSelectedSavedConfigID(specID) or 0) + 19;
	local localizedClass, englishClass = UnitClass("player");
	local listname;

	if spec == nil then
		spec = 1;
	end

	local count = 1;

	curr_y = curr_y + y_adder;

	local x = 50;

	local title = scrollChild:CreateFontString("ARTWORK", nil, "GameFontNormal");
	title:SetPoint("TOPLEFT", x, curr_y);
	title:SetText("Spell/Buff/Debuff name or ID");

	x = x + 300


	title = scrollChild:CreateFontString("ARTWORK", nil, "GameFontNormal");
	title:SetPoint("TOPLEFT", x, curr_y);
	title:SetText("Type");



	for idx = 1, 11 do
		curr_y = curr_y + y_adder;

		title = scrollChild:CreateFontString("ARTWORK", nil, "GameFontNormal");
		title:SetPoint("LEFT", 10, curr_y);
		title:SetText(idx);


		local x = 50;
		local initdata = "";
		local initselect = 0;
		local values = spelllist[idx];

		if values and type(values) == "table" and values[10] == true and values[1] ~= nil and values[2] ~= nil then
			initdata = values[1];
			initselect = values[2];
		elseif values and type(values) == "table" and values[1] ~= nil then
			initdata = values[1];
			initselect = 6;
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
		editBox:SetTextInsets(0, 0, 0, 1)
		editBox:Show();
		editBox:SetCursorPosition(0);
		x = x + 210;

		local dropDown = CreateFrame("Frame", nil, scrollChild, "UIDropDownMenuTemplate")
		dropDown:SetPoint("LEFT", scrollChild, "TOPLEFT", x, curr_y)
		UIDropDownMenu_SetWidth(dropDown, 200) -- Use in place of dropDown:SetWidth


		local dropdownOptions = {
			{ text = "스펠", value = 1 },
			{ text = "버프", value = 2 },
			{ text = "버프(숫자)", disabled = true , value = 3 },						
			{ text = "디버프", value = 4 },
			{ text = "디버프(숫자)", disabled = true , value = 5 },						
			{ text = "기본 설정 사용", disabled = true, value = 6 },

		}

		local function updatedata()
			local data = editBox:GetText();

			local type = UIDropDownMenu_GetSelectedValue(dropDown);

			if data ~= "" and type > 0 and type <= 4 then
				ACI_Options[spec][configID][idx] = {};

				local number = tonumber(data);
				ACI_Options[spec][configID][idx][10] = true;				
				if number then
					ACI_Options[spec][configID][idx][1] = number;
					ACI_Options[spec][configID][idx][2] = tonumber(type) + 1;
				else
					data = tostring(data);
					ACI_Options[spec][configID][idx][1] = data;
					ACI_Options[spec][configID][idx][2] = tonumber(type);				
				end
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
	local localizedClass, englishClass = UnitClass("player");
	local listname;

	if spec == nil then
		spec = 1;
	end


	if ACI_Options == nil or ACI_Options.version ~= ACI_Options_Default.version then
		ACI_Options = {};
		ACI_Options.version = (ACI_Options_Default.version);

		if spec and configID then
			listname = "ACI_SpellList_" .. englishClass .. "_" .. spec;
			ACI_Options[spec] = {};
			ACI_Options[spec][configID] = CopyTable(ACI_Options_Default[listname]);
		end
	end

	if spec and ACI_Options[spec] == nil then
		ACI_Options[spec] = {};
	end

	if spec and configID and ACI_Options[spec][configID] == nil then
		listname = "ACI_SpellList_" .. englishClass .. "_" .. spec;
		ACI_Options[spec][configID] = CopyTable(ACI_Options_Default[listname]);
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
