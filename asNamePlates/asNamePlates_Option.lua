ANameP_Options_Default = {
    version = 230314;
    ANameP_ShowKnownSpell = true,                           -- [디버프] 기본 + 사용 가능 스킬 디버프 추가
    ANameP_ShowMyAll = false,                               -- [디버프] 전부 보이기
    ANameP_ShowPlayerBuffAll = false,                       -- [버프] 전부 보이기
    ANameP_AggroShow = true,			                    -- 어그로 여부를 표현할지 여부 
    ANameP_LowHealthAlert = true,                           -- 낮은 체력 색상 변경 사용

    ANameP_AggroTargetColor =  {r = 0.4, g = 0.2, b = 0.8}, -- PVE 대상이 player 였을때 Color
    ANameP_AggroColor = {r = 0.5, g = 1, b = 1},            -- 어그로 대상일때 바 Color
    ANameP_TankAggroLoseColor = {r = 1, g = 0.5, b= 0.5},   -- 탱커일때 어그로가 다른 탱커가 아닌사람일때
    ANameP_TankAggroLoseColor2 = {r = 1, g = 0.1, b= 0.5},  -- 어그로가 파티내 다른 탱커일때
    ANameP_TankAggroLoseColor3 = {r = 0.1, g = 0.3, b= 1},  -- 어그로가 Pet 일때 혹은 Tanking 중인데 어그로가 낮을때
    ANameP_LowHealthColor = {r = 1, g = 0.8, b= 0.5},       -- 낮은 체력 이름표 색상 변경
    ANameP_DebuffColor = {r = 1, g = 0.5, b = 0},           -- 디버프 걸렸을때 Color

-- ANameP_ShowList_직업_특성 숫자
-- 아래와 같은 배열을 추가 하면 된다.
-- ["디법명"] = {알림 시간, 우선순위, 색상 변경 여부},
-- 우선순위는 숫자가 큰 경우 우선적으로 보이고, 같을 경우 먼저 걸린 순서로 보임
    ANameP_ShowList_WARRIOR_1 = {
	    ["분쇄"] = {15 * 0.3, 1, true},
    },

    ANameP_ShowList_WARRIOR_2 = {
    },

    ANameP_ShowList_WARRIOR_3 = {
    },

    ANameP_ShowList_ROGUE_1 = {
	    ["파열"] = {24 * 0.3, 1, true},
	    ["목조르기"] = {18 * 0.3, 2},
    },

    ANameP_ShowList_ROGUE_2 = {

    },

    ANameP_ShowList_ROGUE_3 = {
	    ["파열"] = {24 * 0.3, 1, true},
    },


    ANameP_ShowList_HUNTER_1 = {
	    ["날카로운 사격"] = {0, 1, true},
	    ["잠재된 독"] = {0, 2},
    },

    ANameP_ShowList_HUNTER_2 = {
	    ["독사 쐐기"] = {0, 1, true},
	    ["잠재된 독"] = {0, 2},
    },

    ANameP_ShowList_HUNTER_3 = {
	    ["독사 쐐기"] = {0, 1, true},
	    ["잠재된 독"] = {0, 2},
    },

    ANameP_ShowList_MONK_1 = {
    },

    ANameP_ShowList_MONK_2 = {
    },

    ANameP_ShowList_MONK_3 = {
	    ["주학의 징표"] = {0, 1},
    },

    ANameP_ShowList_WARLOCK_1 = {
	    ["고통"] = {14 * 0.3, 3, true},
	    ["불안정한 고통"] = {21 * 0.3, 2},
	    ["부패"] = {14 * 0.3, 1},
    },

    ANameP_ShowList_WARLOCK_2 = {
    },


    ANameP_ShowList_WARLOCK_3 = {
	    ["제물"] = {24 * 0.3, 1, true},
    },


    ANameP_ShowList_PRIEST_1 = {
	    ["어둠의 권능: 고통"] = {16 * 0.3, 1, true},
    },

    ANameP_ShowList_PRIEST_2 = {
    },


    ANameP_ShowList_PRIEST_3 = {
	    ["어둠의 권능: 고통"] = {16 * 0.3 , 1, true},
    },

    ANameP_ShowList_SHAMAN_1 = {
	    ["화염 충격"] = {18 * 0.3 , 1, true},
    },

    ANameP_ShowList_SHAMAN_2 = {
	    ["화염 충격"] = {18 * 0.3 , 1, true},
    },

    ANameP_ShowList_SHAMAN_3 = {
    },


    ANameP_ShowList_DRUID_1 = {
	    ["달빛섬광"] = {22 * 0.3, 3, true},
	    ["태양섬광"] = {13.5 * 0.3, 2},
	    ["항성의 섬광"] = {18 * 0.3, 1},
    },


    ANameP_ShowList_DRUID_2 = {
	    ["갈퀴 발톱"] = {15 * 0.3, 2, true},
	    ["도려내기"] = {24 * 0.3, 1},
    },

    ANameP_ShowList_DRUID_3 = {
	    ["달빛섬광"] = {22 * 0.3, 1, true},
    },


    ANameP_ShowList_DRUID_4 = {
    },


    ANameP_ShowList_MAGE_1 = {
	    ["빛나는 불꽃 약화"] = {0, 1, true},
    },

    ANameP_ShowList_MAGE_2 = {
	    ["작열"] = {0, 1},
    },

    ANameP_ShowList_MAGE_3 = {
	    ["혹한의 추위"] = {10, 1},

    },


    ANameP_ShowList_DEATHKNIGHT_1 = {
	    ["피의 역병"] = {0, 1},
    },

    ANameP_ShowList_DEATHKNIGHT_2 = {
	    ["서리 열병"] = {0, 1},
    },

    ANameP_ShowList_DEATHKNIGHT_3 = {
	    ["악성 역병"] = {27 * 0.3, 1},
	    ["고름 상처"] = {0, 2},
    },


    ANameP_ShowList_EVOKER_1 = {
    },

    ANameP_ShowList_EVOKER_2 = {

    },
};

ANameP_OptionM = {};
local update_callback = nil;

local curr_y = 0;
local y_adder = -50;

local panel = CreateFrame("Frame")
panel.name = "asNamePlates"               -- see panel fields
InterfaceOptions_AddCategory(panel)  -- see InterfaceOptions API

local scrollFrame = CreateFrame("ScrollFrame", nil, panel, "UIPanelScrollFrameTemplate")
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
title:SetText("asNamePlates")

local btn = CreateFrame("Button", nil, panel, "UIPanelButtonTemplate")
btn:SetPoint("TOPRIGHT", -50, -10)
btn:SetText("설정 초기화")
btn:SetWidth(100)
btn:SetScript("OnClick", function()
	ANameP_Options = {};
    ANameP_Options = CopyTable(ANameP_Options_Default);
    ANameP_OptionM.UpdateAllOption();
end)

local function SetupCheckBoxOption(text, option)

    if ANameP_Options[option] == nil then
        ANameP_Options[option] = ANameP_Options_Default[option];
    end

    curr_y = curr_y + y_adder;

    local cb = CreateFrame("CheckButton", nil, scrollChild, "InterfaceOptionsCheckButtonTemplate")
    ANameP_OptionM[option] = cb;
    cb:SetPoint("TOPLEFT", 20, curr_y)
    cb.Text:SetText(text)
    cb:HookScript("OnClick", function()
        ANameP_Options[option] = cb:GetChecked();
        ANameP_OptionM.UpdateAllOption();
    end)
    cb:SetChecked(ANameP_Options[option]);
end

local function UpdateCheckBoxValue(option)
    if ANameP_OptionM[option] then
        ANameP_OptionM[option]:SetChecked(ANameP_Options[option]);
    end
end

local function ShowColorPicker(r, g, b, a, changedCallback)
    ColorPickerFrame:SetColorRGB(r,g,b);
    ColorPickerFrame.hasOpacity, ColorPickerFrame.opacity = (a ~= nil), a;
    ColorPickerFrame.previousValues = {r,g,b,a};
    ColorPickerFrame.func, ColorPickerFrame.opacityFunc, ColorPickerFrame.cancelFunc = changedCallback, changedCallback, changedCallback;
    ColorPickerFrame:Hide(); -- Need to run the OnShow handler.
    ColorPickerFrame:Show();
end

local function SetupColorOption(text, option)

    if ANameP_Options[option] == nil then
        ANameP_Options[option] = ANameP_Options_Default[option];
    end

    curr_y = curr_y + y_adder;

    local title = scrollChild:CreateFontString("ARTWORK", nil, "GameFontNormal");
    title:SetPoint("TOPLEFT", 20 , curr_y);
    title:SetText(text);
    title:SetTextColor(ANameP_Options[option].r,ANameP_Options[option].g,ANameP_Options[option].b,1);
    ANameP_OptionM[option] = title;

    local btn = CreateFrame("Button", nil, scrollChild, "UIPanelButtonTemplate")
    btn:SetPoint("TOPLEFT", 220, curr_y)
    btn:SetText("색상 변경")
    btn:SetWidth(100)

    local callback = function (restore)
        local newR, newG, newB, newA;
        if restore then
            newR, newG, newB, newA = unpack(restore);
        else
            newA, newR, newG, newB = OpacitySliderFrame:GetValue(), ColorPickerFrame:GetColorRGB();
        end
        ANameP_Options[option].r, ANameP_Options[option].g, ANameP_Options[option].b = newR, newG, newB;
        ANameP_OptionM.UpdateAllOption();
    end

    btn:SetScript("OnClick", function()
        ShowColorPicker(ANameP_Options[option].r, ANameP_Options[option].g, ANameP_Options[option].b, 1, callback);
    end)
end

local function UpdateSliderValue(option)
    if ANameP_OptionM[option] then
        ANameP_OptionM[option]:SetTextColor(ANameP_Options[option].r,ANameP_Options[option].g,ANameP_Options[option].b,1);
    end
end

local function SetupEditBoxOption()
--[[
    local spec = GetSpecialization();
	local localizedClass, englishClass = UnitClass("player");
	local listname;

    if spec then
		listname = "ANameP_ShowList_" .. englishClass .. "_" .. spec;
	end

    if ANameP_Options[listname] == nil then
        ANameP_Options[listname] = ANameP_Options_Default[listname];
    end

    local list = ANameP_Options[listname];
    local count = 1;

    for spell, value in pairs(list) do
        curr_y = curr_y + y_adder;
        local eb = CreateFrame("EditBox", nil, scrollChild, "InputBoxTemplate")
        eb:SetTextInsets(5, 5, 5, -5);
        eb:SetFont("GameFontNormal", 12, "OUTLINE, THICK");
        eb:SetPoint("TOPLEFT", 20, curr_y);
        eb:SetJustifyV("TOP")
        eb:SetJustifyH("LEFT")
        eb:SetHistoryLines(1);
        eb:SetMaxLetters(20);
        eb:SetSize(200, 70);
        eb:SetAutoFocus(false);
        eb:SetMultiLine(false);
        eb:Show();
        eb:Insert(spell);   

        local eb = CreateFrame("EditBox", nil, scrollChild, "InputBoxTemplate")
        eb:SetTextInsets(5, 5, 5, -5);
        eb:SetFont("GameFontNormal", 12, "OUTLINE, THICK");
        eb:SetPoint("TOPLEFT", 250, curr_y);
        eb:SetJustifyV("TOP")
        eb:SetJustifyH("LEFT")
        eb:SetHistoryLines(1);
        eb:SetMaxLetters(20);
        eb:SetSize(200, 70);
        eb:SetAutoFocus(false);
        eb:SetMultiLine(false);
        eb:Show();
        eb:Insert(value[1]);

        local eb = CreateFrame("EditBox", nil, scrollChild, "InputBoxTemplate")
        eb:SetTextInsets(5, 5, 5, -5);
        eb:SetFont("GameFontNormal", 12, "OUTLINE, THICK");
        eb:SetPoint("TOPLEFT", 500, curr_y);
        eb:SetJustifyV("TOP")
        eb:SetJustifyH("LEFT")
        eb:SetHistoryLines(1);
        eb:SetMaxLetters(20);
        eb:SetSize(200, 70);
        eb:SetAutoFocus(false);
        eb:SetMultiLine(false);
        eb:Show();
        count = count + 1;
    end

    for i = count, 5 do
        curr_y = curr_y + y_adder;
        local eb = CreateFrame("EditBox", nil, scrollChild, "InputBoxTemplate")
        eb:SetTextInsets(5, 5, 5, -5);
        eb:SetFont("GameFontNormal", 12, "OUTLINE, THICK");
        eb:SetPoint("TOPLEFT", 20, curr_y);
        eb:SetJustifyV("TOP")
        eb:SetJustifyH("LEFT")
        eb:SetHistoryLines(1);
        eb:SetMaxLetters(20);
        eb:SetSize(200, 70);
        eb:SetAutoFocus(false);
        eb:SetMultiLine(false);
        eb:Show();
        
        local eb = CreateFrame("EditBox", nil, scrollChild, "InputBoxTemplate")
        eb:SetTextInsets(5, 5, 5, -5);
        eb:SetFont("GameFontNormal", 12, "OUTLINE, THICK");
        eb:SetPoint("TOPLEFT", 250, curr_y);
        eb:SetJustifyV("TOP")
        eb:SetJustifyH("LEFT")
        eb:SetHistoryLines(1);
        eb:SetMaxLetters(20);
        eb:SetSize(200, 70);
        eb:SetAutoFocus(false);
        eb:SetMultiLine(false);
        eb:Show();

        local eb = CreateFrame("EditBox", nil, scrollChild, "InputBoxTemplate")
        eb:SetTextInsets(5, 5, 5, -5);
        eb:SetFont("GameFontNormal", 12, "OUTLINE, THICK");
        eb:SetPoint("TOPLEFT", 500, curr_y);
        eb:SetJustifyV("TOP")
        eb:SetJustifyH("LEFT")
        eb:SetHistoryLines(1);
        eb:SetMaxLetters(20);
        eb:SetSize(200, 70);
        eb:SetAutoFocus(false);
        eb:SetMultiLine(false);
        eb:Show();

    end

    ]]
end


ANameP_OptionM.SetupAllOption = function()
    SetupCheckBoxOption("[디버프] 기본에 스팰북 스킬 디버프 추가", "ANameP_ShowKnownSpell");
    SetupCheckBoxOption("[디버프] 내 디버프 모두 보임", "ANameP_ShowMyAll");
    SetupCheckBoxOption("[버프] 내 버프 모두 보임", "ANameP_ShowPlayerBuffAll");
    SetupCheckBoxOption("[색상] 어그로 색상 표시", "ANameP_AggroShow");
    SetupCheckBoxOption("[색상] 낮은 생명력 색상 표시", "ANameP_LowHealthAlert");
    SetupEditBoxOption();
    SetupColorOption("[이름표 색상] 어그로 대상", "ANameP_AggroTargetColor");
    SetupColorOption("[이름표 색상] 어그로 상위", "ANameP_AggroColor");
    SetupColorOption("[탱커 이름표 색상] 어그로 상실", "ANameP_TankAggroLoseColor");
    SetupColorOption("[탱커 이름표 색상] 어그로 다른 탱커",  "ANameP_TankAggroLoseColor2");
    SetupColorOption("[이름표 색상] 어그로 소환수", "ANameP_TankAggroLoseColor3");
    SetupColorOption("[이름표 색상] 낮은 체력", "ANameP_LowHealthColor");
    SetupColorOption("[이름표 색상] 디버프", "ANameP_DebuffColor");
    update_callback();
end

ANameP_OptionM.UpdateAllOption = function()
    UpdateCheckBoxValue("ANameP_ShowKnownSpell");
    UpdateCheckBoxValue("ANameP_ShowMyAll");
    UpdateCheckBoxValue("ANameP_AggroShow");
    UpdateCheckBoxValue("ANameP_ShowPlayerBuffAll");
    UpdateCheckBoxValue("ANameP_LowHealthAlert");
    UpdateSliderValue("ANameP_AggroTargetColor");
    UpdateSliderValue("ANameP_AggroColor");
    UpdateSliderValue("ANameP_TankAggroLoseColor");
    UpdateSliderValue("ANameP_TankAggroLoseColor2");
    UpdateSliderValue("ANameP_TankAggroLoseColor3");
    UpdateSliderValue("ANameP_LowHealthColor");
    UpdateSliderValue("ANameP_DebuffColor");
    update_callback();
end

ANameP_OptionM.RegisterCallback = function (callback_func)
    update_callback = callback_func;
end

function panel:OnEvent(event, addOnName)
	if addOnName == "asNamePlates" then
		if ANameP_Options == nil then
            ANameP_Options = {};
            ANameP_Options = CopyTable(ANameP_Options_Default);
        end

        if ANameP_Options.version ~= ANameP_Options_Default.version then
            ANameP_Options = CopyTable(ANameP_Options_Default);
        end

        ANameP_OptionM.SetupAllOption();
	end
end

panel:RegisterEvent("ADDON_LOADED")
panel:SetScript("OnEvent", panel.OnEvent)