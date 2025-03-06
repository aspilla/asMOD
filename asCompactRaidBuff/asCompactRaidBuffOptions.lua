local _, ns = ...;

ns.UpdateRate = 0.25; -- 1회 Update 주기 (초) 작으면 작을 수록 Frame Rate 감소 가능, 크면 Update 가 느림

local Options_Default = {
	version = 250108,
	ShowBuffColor = true,       -- 버프가 Frame Color 를 변경 할지
	ShowHealthColor = true,     -- 체력 낮은 사람 Color 변경 (사제 생명)
	LeftAbsorbBar = true,       -- 보호막 바
	TopCastAlert = true,        -- 케스팅 알림 (상단)
	MiddleDefensiveAlert = true, -- 생존기 Alert (중앙)	
	BorderDispelAlert = true,   -- Dispel Alert (태두리)
	LeftTopRaidIcon = true,     -- Raid Icon
	BottomHealerManaBar = true, -- 힐러 마나바
	BuffSizeRate = 0.9,         -- 기존 Size 크기 배수
	ShowBuffCooldown = true,    -- 버프 지속시간을 보이려면	
	MinCoolShowBuffSize = 10,   -- 이크기보다 Icon Size 가 작으면 안보이게 한다. 무조건 보이게 하려면 0 (기본 Buff Debuff만 보임)
	BuffFontSizeRate = 0.7, 	-- 버프 Size 대비 쿨다운 폰트 사이즈	
	ShowBuffTooltip = true,     -- Buff GameTooltip을 보이게 하려면 True
	ShowDebuffTooltip = true,   -- Debuff GameTooltip을 보이게 하려면 True	
	MinSectoShowCooldown = 10,  -- 이 시간 미만으로 남으면 Cooldown이 보이게 한다. (초)
};

-- 첫 숫자 남은시간에 리필 알림 (1이면 자동으로 30% 남으면 알림)
-- 두번째 숫자는 표시 위치, 6(우상) 5/4(우중) 1,2,3 은 우하에 보이는 우선 순위이다. (숫자가 클수록 우측에 보임)

ns.ACRB_ShowList_MONK_1 = {	
	version = 250112,
}

ns.ACRB_ShowList_MONK_2 = {
	[119611] = { 0, 6 }, --소생의 안개
	[124682] = { 0, 5 }, --포용의 안개	
	version = 250112,
}
ns.ACRB_ShowList_MONK_3 = {	
	version = 250112,
}

-- 신기
ns.ACRB_ShowList_PALADIN_1 = {
	[200025] = { 0, 6 }, -- 고결의 봉화
	[53563] = { 0, 5 }, -- 빛의 봉화
	[156910] = { 0, 5 }, -- 신념의 봉화
	[200654] = { 0, 3 }, -- 티르		
	version = 250112,
}

ns.ACRB_ShowList_PALADIN_2 = {
	version = 250112,
}

ns.ACRB_ShowList_PALADIN_3 = {
	version = 250112,
}

-- 수사
ns.ACRB_ShowList_PRIEST_1 = {
	[194384] = { 0, 6 }, -- 속죄
	[17] = { 0, 5 },  -- 신의 권능 보호막
	[139] = { 1, 4 }, -- 소생
	[41635] = { 0, 2 }, -- 회복의 기원
	[10060] = { 0, 1 }, -- 마력 주입
	version = 250112,
}


-- 신사
ns.ACRB_ShowList_PRIEST_2 = {
	[139] = { 1, 6 }, -- 소생
	[17] = { 0, 5 }, -- 신의 권능 보호막
	[41635] = { 0, 2 }, -- 회복의 기원
	[10060] = { 0, 1 }, -- 마력 주입
	version = 250112,
}

ns.ACRB_ShowList_PRIEST_3 = {
	[10060] = { 0, 1 },
	version = 250112,
}

ns.ACRB_ShowList_SHAMAN_1 = {
	version = 250112,
}

ns.ACRB_ShowList_SHAMAN_2 = {
	version = 250112,
}

ns.ACRB_ShowList_SHAMAN_3 = {
	[61295] = { 1, 6 }, --성난 해일
	[383648] = { 0, 5 }, --대지의 보호막
	[974] = { 0, 4 }, --대지의 보호막
	version = 250112,
}

ns.ACRB_ShowList_DRUID_1 = {
	version = 250113,
}

ns.ACRB_ShowList_DRUID_2 = {
	version = 250113,
}

ns.ACRB_ShowList_DRUID_3 = {
	version = 250113,
}

ns.ACRB_ShowList_DRUID_4 = {
	[188550] = { 1, 6 }, -- 피어나는 생명
	[33763] = { 1, 6 }, -- 피어나는 생명
	[774] = { 1, 5 }, --회복		
	[8936] = { 1, 4 }, -- 재생
	[155777] = { 1, 3 }, -- 회복 (싹틔우기)
	[102351] = { 0, 2 }, -- 세나리온 수호물
	version = 250306,
}

ns.ACRB_ShowList_EVOKER_1 = {	
	version = 250112,
}

ns.ACRB_ShowList_EVOKER_2 = {
	[364343] = { 0, 6 }, --메아리
	[366155] = { 1, 5 }, --되감기
	version = 250112,
}

ns.ACRB_ShowList_EVOKER_3 = {
	[410089] = { 0, 6 }, --예지
	[360827] = { 0, 5 }, --끓어오르는 비늘
	version = 250112,
}

ns.ACRB_ShowList_WARRIOR_1 = {	
	version = 250112,
}

ns.ACRB_ShowList_WARRIOR_2 = {	
	version = 250112,
}

ns.ACRB_ShowList_WARRIOR_3 = {	
	version = 250112,
}

ns.ACRB_ShowList_ROGUE_1 = {	
	version = 250112,
}

ns.ACRB_ShowList_ROGUE_2 = {	
	version = 250112,
}

ns.ACRB_ShowList_ROGUE_3 = {	
	version = 250112,
}

ns.ACRB_ShowList_HUNTER_1 = {	
	version = 250112,
}

ns.ACRB_ShowList_HUNTER_2 = {	
	version = 250112,
}

ns.ACRB_ShowList_HUNTER_3 = {	
	version = 250112,
}

ns.ACRB_ShowList_MAGE_1 = {	
	version = 250112,
}

ns.ACRB_ShowList_MAGE_2 = {	
	version = 250112,
}

ns.ACRB_ShowList_MAGE_3 = {	
	version = 250112,
}

ns.ACRB_ShowList_WARLOCK_1 = {	
	version = 250112,
}

ns.ACRB_ShowList_WARLOCK_2 = {	
	version = 250112,
}

ns.ACRB_ShowList_WARLOCK_3 = {	
	version = 250112,
}

ns.ACRB_ShowList_DEATHKNIGHT_1 = {	
	version = 250112,
}

ns.ACRB_ShowList_DEATHKNIGHT_2 = {	
	version = 250112,
}

ns.ACRB_ShowList_DEATHKNIGHT_3 = {	
	version = 250112,
}

ns.ACRB_ShowList_DEMONHUNTER_1 = {	
	version = 250112,
}

ns.ACRB_ShowList_DEMONHUNTER_2 = {	
	version = 250112,
}




-- 안보이게 할 디법
ns.ACRB_BlackList = {
	[206151] = 1, --도전자의 짐
}


--직업별 생존기 등록 (10초 쿨다운), 내부전쟁 Version
ns.ACRB_DefensiveBuffListDefault = {

	version = 250112,

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
	[5487]   = 2, --DRUID 곰변신 (딜러/힐러만)


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



ns.buffpanel = CreateFrame("Frame")
ns.defensivepanel = CreateFrame("Frame")

local asGetSpellInfo = function(spellID)
	if not spellID then
		return nil;
	end

	local ospellID = C_Spell.GetOverrideSpell(spellID)

	if ospellID then
		spellID = ospellID;
	end

	local spellInfo = C_Spell.GetSpellInfo(spellID);
	if spellInfo then
		return spellInfo.name, nil, spellInfo.iconID, spellInfo.castTime, spellInfo.minRange, spellInfo.maxRange,
			spellInfo.spellID, spellInfo.originalIconID;
	end
end

function ns.refreshList()
	if ns.buffpanel.bufflisttext and ns.ACRB_ShowList then
		local text = "";
		for id, value in pairs(ns.ACRB_ShowList) do
		local name, _, icon = asGetSpellInfo(id)

			if name then
				text = text.. "position: ".. value[2] .. " Refresh alert: ".. value[1] .. " |T" .. icon .. ":0|t " .. name .. " " .. id .. "\n";
			end
		end

		ns.buffpanel.bufflisttext:SetText(text);
	end

	if ns.defensivepanel.bufflisttext and ns.ACRB_DefensiveBuffList then
		local text = "";
		for id, value in pairs(ns.ACRB_DefensiveBuffList) do
		local name, _, icon = asGetSpellInfo(id)

			if name then
				text = text.. "|T" .. icon .. ":0|t " .. name .. " " .. id .. "\n";
			end
		end

		ns.defensivepanel.bufflisttext:SetText(text);
	end
end

local function SetupSubOption(panel, titlename)

	local curr_y = 0;
	local y_adder = -40;	

	if panel.scrollframe then
		panel.scrollframe:Hide()
		panel.scrollframe:UnregisterAllEvents()
		panel.scrollframe = nil;
	end

	panel.scrollframe = CreateFrame("ScrollFrame", nil, panel, "UIPanelScrollFrameTemplate")
	panel.scrollframe:SetPoint("TOPLEFT", 3, -4)
	panel.scrollframe:SetPoint("BOTTOMRIGHT", -27, 4)

	-- Create the scrolling child frame, set its width to fit, and give it an arbitrary minimum height (such as 1)
	panel.scrollchild = CreateFrame("Frame")
	panel.scrollframe:SetScrollChild(panel.scrollchild)
	panel.scrollchild:SetWidth(600)
	panel.scrollchild:SetHeight(1)

	-- add widgets to the panel as desired
	local title = panel:CreateFontString("ARTWORK", nil, "GameFontNormalLarge")
	title:SetPoint("TOP")
	title:SetText(titlename)

	curr_y = curr_y + y_adder;

	local localeTexts = { "Buff ID", "Position", "Refresh Alert" };

	local x = 10;

	local title = panel.scrollchild:CreateFontString("ARTWORK", nil, "GameFontNormal");
	title:SetPoint("TOPLEFT", x, curr_y);
	title:SetText(localeTexts[1]);

	x = 200;

	title = panel.scrollchild:CreateFontString("ARTWORK", nil, "GameFontNormal");
	title:SetPoint("TOPLEFT", x, curr_y);
	title:SetText(localeTexts[2]);

	x = 310;

	title = panel.scrollchild:CreateFontString("ARTWORK", nil, "GameFontNormal");
	title:SetPoint("TOPLEFT", x, curr_y);
	title:SetText(localeTexts[3]);

	x = 450;
	local btn0 = CreateFrame("Button", nil, panel.scrollchild, "UIPanelButtonTemplate")
	btn0:SetPoint("LEFT", panel.scrollchild, "TOPLEFT", x, curr_y)
	btn0:SetText("Load Default")
	btn0:SetWidth(100)
	btn0:SetScript("OnClick", function()
		ACRB_Options[ns.listname] = CopyTable(ns[ns.listname])
		ns.ACRB_ShowList = CopyTable(ns[ns.listname]);		
		ns.refreshList();
	end);


	curr_y = curr_y + y_adder;



	local x = 10;

	local editBox = CreateFrame("EditBox", nil, panel.scrollchild)
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
	editBox:SetWidth(150)
	editBox:SetPoint("LEFT", panel.scrollchild, "TOPLEFT", x, curr_y)
	editBox:SetFontObject("GameFontHighlight")
	editBox:SetMultiLine(false);
	editBox:SetMaxLetters(20);
	editBox:SetText("");
	editBox:SetAutoFocus(false);
	editBox:ClearFocus();
	editBox:SetNumeric(true);
	editBox:SetTextInsets(0, 0, 0, 1);
	editBox:Show();
	editBox:SetCursorPosition(0);
	x = x + 150;


	local dropDown = CreateFrame("Frame", nil, panel.scrollchild, "UIDropDownMenuTemplate")
	dropDown:SetPoint("LEFT", panel.scrollchild, "TOPLEFT", x, curr_y)
	UIDropDownMenu_SetWidth(dropDown, 100) -- Use in place of dropDown:SetWidth

	local dropdownOptions = {
		{ text = "TOPRIGHT(Color)",           value = 6 },
		{ text = "RIGHT1",         value = 5 },
		{ text = "RIGHT2",   value = 4 },
		{ text = "BOTTOMRIGHT1", value = 3 },
		{ text = "BOTTOMRIGHT2",   value = 2 },
		{ text = "BOTTOMRIGHT3",   value = 1 },
	};


	UIDropDownMenu_Initialize(dropDown, function(self, level)
		for _, option in ipairs(dropdownOptions) do
			local info = UIDropDownMenu_CreateInfo()
			info.text = option.text
			info.value = option.value
			info.disabled = option.disabled
			local function Dropdown_OnClick()
				UIDropDownMenu_SetSelectedValue(dropDown, option.value);				
			end
			info.func = Dropdown_OnClick;
			UIDropDownMenu_AddButton(info, level);			
		end
		UIDropDownMenu_SetSelectedValue(dropDown, 1);
	end);
	
	x = x + 120;


	local dropDown2 = CreateFrame("Frame", nil, panel.scrollchild, "UIDropDownMenuTemplate")
	dropDown2:SetPoint("LEFT", panel.scrollchild, "TOPLEFT", x, curr_y)
	UIDropDownMenu_SetWidth(dropDown2, 100) -- Use in place of dropDown:SetWidth

	local dropdownOptions2 = {
		{ text = "Alert Refresh",           value = 1 },
		{ text = "No Alert",         value = 0 },		
	};


	UIDropDownMenu_Initialize(dropDown2, function(self, level)
		for _, option in ipairs(dropdownOptions2) do
			local info = UIDropDownMenu_CreateInfo()
			info.text = option.text
			info.value = option.value
			info.disabled = option.disabled
			local function Dropdown_OnClick2()
				UIDropDownMenu_SetSelectedValue(dropDown2, option.value);				
			end
			info.func = Dropdown_OnClick2;
			UIDropDownMenu_AddButton(info, level)
		end
		UIDropDownMenu_SetSelectedValue(dropDown2, 0);
	end);	

	x = x + 140;

	local btn = CreateFrame("Button", nil, panel.scrollchild, "UIPanelButtonTemplate")
	btn:SetPoint("LEFT", panel.scrollchild, "TOPLEFT", x, curr_y)
	btn:SetText("Add")
	btn:SetWidth(100)
	btn:SetScript("OnClick", function()
		local newspell = editBox:GetNumber();            
        local newtype1 = tonumber(UIDropDownMenu_GetSelectedValue(dropDown));
		local newtype2 = tonumber(UIDropDownMenu_GetSelectedValue(dropDown2));
		if newspell > 0 then
			ns.ACRB_ShowList[newspell] = {newtype2, newtype1};
			if ACRB_Options[ns.listname] then
				ACRB_Options[ns.listname][newspell] = {newtype2, newtype1};
			end
			ns.refreshList();
		end

	end);

	x = x + 105;

	local btn2 = CreateFrame("Button", nil, panel.scrollchild, "UIPanelButtonTemplate")
	btn2:SetPoint("LEFT", panel.scrollchild, "TOPLEFT", x, curr_y)
	btn2:SetText("Delete")
	btn2:SetWidth(100)
	btn2:SetScript("OnClick", function()
		local newspell = editBox:GetNumber();   
		if newspell > 0 then
			ns.ACRB_ShowList[newspell] = nil;
			if ACRB_Options[ns.listname] then
				ACRB_Options[ns.listname][newspell] = nil;
			end
			ns.refreshList();
		end

	end);

	curr_y = curr_y + y_adder;

	panel.explaintext = panel.scrollchild:CreateFontString("ARTWORK", nil, "GameFontNormal");
	panel.explaintext:SetFont(STANDARD_TEXT_FONT, 12, "THICKOUTLINE");
	panel.explaintext:SetPoint("TOPLEFT", 10, curr_y);
	panel.explaintext:SetTextColor(1, 1, 1);
	panel.explaintext:SetJustifyH("LEFT");
	panel.explaintext:SetText("6-TOPRIGHT, 5~4-RIGHT, 3~1-BOTTOMRIGHT")
	panel.explaintext:Show();


	curr_y = curr_y + y_adder;

	panel.bufflisttext = panel.scrollchild:CreateFontString("ARTWORK", nil, "GameFontNormal");
	panel.bufflisttext:SetFont(STANDARD_TEXT_FONT, 20, "THICKOUTLINE");
	panel.bufflisttext:SetPoint("TOPLEFT", 10, curr_y);
	panel.bufflisttext:SetTextColor(1, 1, 1);
	panel.bufflisttext:SetJustifyH("LEFT");
	panel.bufflisttext:Show();

	ns.refreshList();
end

local function SetupSubOptionDefensive(panel, titlename)

	local curr_y = 0;
	local y_adder = -40;	

	if panel.scrollframe then
		panel.scrollframe:Hide()
		panel.scrollframe:UnregisterAllEvents()
		panel.scrollframe = nil;
	end

	panel.scrollframe = CreateFrame("ScrollFrame", nil, panel, "UIPanelScrollFrameTemplate")
	panel.scrollframe:SetPoint("TOPLEFT", 3, -4)
	panel.scrollframe:SetPoint("BOTTOMRIGHT", -27, 4)

	-- Create the scrolling child frame, set its width to fit, and give it an arbitrary minimum height (such as 1)
	panel.scrollchild = CreateFrame("Frame")
	panel.scrollframe:SetScrollChild(panel.scrollchild)
	panel.scrollchild:SetWidth(600)
	panel.scrollchild:SetHeight(1)

	-- add widgets to the panel as desired
	local title = panel:CreateFontString("ARTWORK", nil, "GameFontNormalLarge")
	title:SetPoint("TOP")
	title:SetText(titlename)

	curr_y = curr_y + y_adder;

	local localeTexts = { "Buff ID" };

	local x = 10;

	local title = panel.scrollchild:CreateFontString("ARTWORK", nil, "GameFontNormal");
	title:SetPoint("TOPLEFT", x, curr_y);
	title:SetText(localeTexts[1]);

	x = 450;
	local btn0 = CreateFrame("Button", nil, panel.scrollchild, "UIPanelButtonTemplate")
	btn0:SetPoint("LEFT", panel.scrollchild, "TOPLEFT", x, curr_y)
	btn0:SetText("Load Default")
	btn0:SetWidth(100)
	btn0:SetScript("OnClick", function()
		ns.ACRB_DefensiveBuffList = CopyTable(ns.ACRB_DefensiveBuffListDefault);
        ACRB_Options.defensivelist = {};
        ACRB_Options.defensivelist = CopyTable(ns.ACRB_DefensiveBuffListDefault);	
		ns.refreshList();
	end);


	curr_y = curr_y + y_adder;

	local x = 10;

	local editBox = CreateFrame("EditBox", nil, panel.scrollchild)
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
	editBox:SetWidth(150)
	editBox:SetPoint("LEFT", panel.scrollchild, "TOPLEFT", x, curr_y)
	editBox:SetFontObject("GameFontHighlight")
	editBox:SetMultiLine(false);
	editBox:SetMaxLetters(20);
	editBox:SetText("");
	editBox:SetAutoFocus(false);
	editBox:ClearFocus();
	editBox:SetTextInsets(0, 0, 0, 1)
	editBox:Show();
	editBox:SetCursorPosition(0);
	x = x + 150;

	local btn = CreateFrame("Button", nil, panel.scrollchild, "UIPanelButtonTemplate")
	btn:SetPoint("LEFT", panel.scrollchild, "TOPLEFT", x, curr_y)
	btn:SetText("Add")
	btn:SetWidth(100)
	btn:SetScript("OnClick", function()
		local newspell = editBox:GetNumber();            
		if newspell > 0 then
			ns.ACRB_DefensiveBuffList[newspell] = 1;
			ACRB_Options.defensivelist[newspell] = 1;
			ns.refreshList();
		end

	end);

	x = x + 105;

	local btn2 = CreateFrame("Button", nil, panel.scrollchild, "UIPanelButtonTemplate")
	btn2:SetPoint("LEFT", panel.scrollchild, "TOPLEFT", x, curr_y)
	btn2:SetText("Delete")
	btn2:SetWidth(100)
	btn2:SetScript("OnClick", function()
		local newspell = editBox:GetNumber();   
		if newspell > 0 then
			ns.ACRB_DefensiveBuffList[newspell] = nil;
			ACRB_Options.defensivelist[newspell] = nil;
			ns.refreshList();
		end

	end);

	curr_y = curr_y + y_adder;

	panel.bufflisttext = panel.scrollchild:CreateFontString("ARTWORK", nil, "GameFontNormal");
	panel.bufflisttext:SetFont(STANDARD_TEXT_FONT, 20, "THICKOUTLINE");
	panel.bufflisttext:SetPoint("TOPLEFT", 10, curr_y);
	panel.bufflisttext:SetTextColor(1, 1, 1);
	panel.bufflisttext:SetJustifyH("LEFT");
	panel.bufflisttext:Show();

	ns.refreshList();
end


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

	local category = Settings.RegisterVerticalLayoutCategory("asCompactRaidBuff");
	local subcategory, subcategoryLayout = Settings.RegisterCanvasLayoutSubcategory(category, ns.buffpanel, "Class Buff List");
	local subcategory, subcategoryLayout = Settings.RegisterCanvasLayoutSubcategory(category, ns.defensivepanel, "Defensive Buff List");


	if ACRB_Options == nil or ACRB_Options.version ~= Options_Default.version then
		ACRB_Options = {};
		ACRB_Options = CopyTable(Options_Default);
	end
	
	ns.options = CopyTable(ACRB_Options);

	ns.ACRB_InitList();

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
			local defaultValue = Options_Default[variable];
			local currentValue = ACRB_Options[variable];

			if type(defaultValue) == "table" then
				--do nothing
			elseif tonumber(defaultValue) ~= nil then
				local setting, options;
				if tonumber(defaultValue) < 1 and tonumber(defaultValue) > 0 then
					setting = Settings.RegisterAddOnSetting(category, cvar_name, variable, tempoption, type(defaultValue),
						name, defaultValue);
					options = Settings.CreateSliderOptions(0.1, 0.9, 0.1);
				else
					setting = Settings.RegisterAddOnSetting(category, cvar_name, variable, tempoption, type(defaultValue),
						name, defaultValue);
					options = Settings.CreateSliderOptions(0, 100, 1);
				end

				options:SetLabelFormatter(MinimalSliderWithSteppersMixin.Label.Right);
				Settings.CreateSlider(category, setting, options, tooltip);
				Settings.SetValue(cvar_name, currentValue);
				Settings.SetOnValueChangedCallback(cvar_name, OnSettingChanged);
				
			else
				local setting = Settings.RegisterAddOnSetting(category, cvar_name, variable, tempoption,
					type(defaultValue), name, defaultValue);
				Settings.CreateCheckboxWithOptions(category, setting, nil, tooltip);
				Settings.SetValue(cvar_name, currentValue);
				Settings.SetOnValueChangedCallback(cvar_name, OnSettingChanged);				
			end
		end
	end

	Settings.RegisterAddOnCategory(category);
	SetupSubOption(ns.buffpanel, "Class Buff List");
	SetupSubOptionDefensive(ns.defensivepanel, "Defensive Buff List");
end
