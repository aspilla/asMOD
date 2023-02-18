---설정부
local AHNameP_HideModifier = 4			-- ALT(1), CTRL(2), SHIFT(3), 자동(4) 지원 nil이면 기능 끄기
local AHNameP_UpdateRate = 0.2			-- Check할 주기
local AHNameP_ActivateOnAllCasting = false -- 차단 가능 스킬 모두 발동


local AHNameP_AlertList = {
	["폭발물"] = true,
--	["쉬바라"] = true,	 -- 녹색 빤짝이 
--["우르줄"] = true,	 -- 녹색 빤짝이 
	--["파멸수호병"] = true,	 -- 녹색 빤짝이 
	--["지옥불정령"] = true,	 -- 녹색 빤짝이 
	--["격노수호병"] = true,
}

local AHNameP_InterruptSpellList = {

	[6552] = true, --WARRIOR
	[386071] = true, --WARRIOR
	[1766] = true, --ROGUE
	[183752] = true, --DEMONHUNTER
	[116705] = true, --MONK
	[47482] = true, --DEATHKNIGHT
	[47528] = true, --DEATHKNIGHT
	[187707] = true, --HUNTER
	[147362] = true, --HUNTER
	[351338] = true, --EVOKER
	[106839] = true, --DRUID
	[78675] = true, --DRUID
	[212619] = true, --WARLOCK
	[119898] = true, --WARLOCK
	[15487] = true, --PRIEST
	[31935] = true, --PALADIN
	[96231] = true, --PALADIN
	[57994] = true, --SHAMAN
	[2139] = true, --MAGE
}

local AHNameP_DangerousSpellList = { 
	[135234] = true,
	[133262] = true,
	[294665] = true,
	[39945] = true,
	[134795] = true,
	[124935] = true,
	[135621] = true,
	[140983] = true,
	[142621] = true,
	[33975] = true,
	[282081] = true,
	[385652] = true,
	[29427] = true,
	[17843] = true,
	[46181] = true,
	[36819] = true,
	[39013] = true,
	[255824] = true,
	[253562] = true,
	[253583] = true,
	[255041] = true,
	[253544] = true,
	[253517] = true,
	[256849] = true,
	[252781] = true,
	[250368] = true,
	[250096] = true,
	[257397] = true,
	[257899] = true,
	[257736] = true,
	[258779] = true,
	[257784] = true,
	[257732] = true,
	[256060] = true,
	[267273] = true,
	[269973] = true,
	[270923] = true,
	[270901] = true,
	[270492] = true,
	[267763] = true,
	[257791] = true,
	[300764] = true,
	[300650] = true,
	[300171] = true,
	[299588] = true,
	[300087] = true,
	[300414] = true,
	[300514] = true,
	[300436] = true,
	[301629] = true,
	[284219] = true,
	[301088] = true,
	[293729] = true,
	[298669] = true,
	[268050] = true,
	[268030] = true,
	[268309] = true,
	[267977] = true,
	[274437] = true,
	[268317] = true,
	[268322] = true,
	[268375] = true,
	[276767] = true,
	[267818] = true,
	[256957] = true,
	[274569] = true,
	[272571] = true,
	[263318] = true,
	[263775] = true,
	[268061] = true,
	[265968] = true,
	[261635] = true,
	[272700] = true,
	[268061] = true,
	[265912] = true,
	[268709] = true,
	[263202] = true,
	[280604] = true,
	[268129] = true,
	[268702] = true,
	[263103] = true,
	[263066] = true,
	[268797] = true,
	[269090] = true,
	[262540] = true,
	[262092] = true,
	[260879] = true,
	[266106] = true,
	[265089] = true,
	[265091] = true,
	[265433] = true,
	[272183] = true,
	[278961] = true,
	[265523] = true,
	[257791] = true,
	[258128] = true,
	[258153] = true,
	[258313] = true,
	[258869] = true,
	[258634] = true,
	[258935] = true,
	[266225] = true,
	[263959] = true,
	[265876] = true,
	[265368] = true,
	[266036] = true,
	[278551] = true,
	[265407] = true,
	[82362] = true,
	[75823] = true,
	[102173] = true,
	[75763] = true,
	[80352] = true,
	[93468] = true,
	[93844] = true,
	[79351] = true,
	[76171] = true,
	[76008] = true,
	[103241] = true,
	[43451] = true,
	[43431] = true,
	[43548] = true,
	[96435] = true,
	[96466] = true,
	[310839] = true,
	[396640] = true,
	[367500] = true,
	[384638] = true,
	[377950] = true,
	[381770] = true,
	[363607] = true,
	[374080] = true,
	[384014] = true,
	[375056] = true,
	[378282] = true,
	[373680] = true,
	[384194] = true,
	[392451] = true,
	[373932] = true,
	[375596] = true,
	[387564] = true,
	[386546] = true,
	[376725] = true,
	[363607] = true,
	[384808] = true,
	[386024] = true,
	[387411] = true,
	[373395] = true,
	[369675] = true,
	[369602] = true,
	[369674] = true,
	[369823] = true,
	[225573] = true,
	[197797] = true,
	[237391] = true,
	[238543] = true,
	[242724] = true,
	[212773] = true,
	[209485] = true,
	[209410] = true,
	[209413] = true,
	[211470] = true,
	[225100] = true,
	[211299] = true,
	[207980] = true,
	[196870] = true,
	[195046] = true,
	[195284] = true,
	[197502] = true,
	[192003] = true,
	[192005] = true,
	[191848] = true,
	[215433] = true,
	[198934] = true,
	[192563] = true,
	[199726] = true,
	[192288] = true,
	[198750] = true,
	[194266] = true,
	[198495] = true,
	[198405] = true,
	[227800] = true,
	[227823] = true,
	[227592] = true,
	[228025] = true,
	[228019] = true,
	[227987] = true,
	[227420] = true,
	[228255] = true,
	[228239] = true,
	[227917] = true,
	[228625] = true,
	[228606] = true,
	[229714] = true,
	[248831] = true,
	[245585] = true,
	[245727] = true,
	[248133] = true,
	[248184] = true,
	[244751] = true,
	[211757] = true,
	[226206] = true,
	[196392] = true,
	[203957] = true,
	[191823] = true,
	[200905] = true,
	[193069] = true,
	[204963] = true,
	[205088] = true,
	[395859] = true,
	[395872] = true,
	[397801] = true,
	[118963] = true,
	[118940] = true,
	[118903] = true,
	[123654] = true,
	[113134] = true,
	[12039] = true,
	[130857] = true,
	[113691] = true,
	[113690] = true,
	[107356] = true,
	[332666] = true,
	[332706] = true,
	[332612] = true,
	[332084] = true,
	[323064] = true,
	[325700] = true,
	[325701] = true,
	[326607] = true,
	[323538] = true,
	[323552] = true,
	[323057] = true,
	[321828] = true,
	[322938] = true,
	[324914] = true,
	[324776] = true,
	[326046] = true,
	[340544] = true,
	[322450] = true,
	[257397] = true,
	[319070] = true,
	[328338] = true,
	[328016] = true,
	[326836] = true,
	[321038] = true,
	[327481] = true,
	[317936] = true,
	[317963] = true,
	[327413] = true,
	[328295] = true,
	[328137] = true,
	[328331] = true,
	[358131] = true,
	[350922] = true,
	[357404] = true,
	[355888] = true,
	[355930] = true,
	[355934] = true,
	[354297] = true,
	[356537] = true,
	[347775] = true,
	[347903] = true,
	[355057] = true,
	[355225] = true,
	[357260] = true,
	[356407] = true,
	[356404] = true,
	[324589] = true,
	[341902] = true,
	[341969] = true,
	[342139] = true,
	[330562] = true,
	[330810] = true,
	[333231] = true,
	[320170] = true,
	[322493] = true,
	[334748] = true,
	[320462] = true,
	[324293] = true,
	[338353] = true,
	[257397] = true,
	[149955] = true,
	[86620] = true,
	[11082] = true,
	[11085] = true,
	[93655] = true,
	[21807] = true,
	[21807] = true,
	[119300] = true,
	[15245] = true,
	[16798] = true,
	[12471] = true,
	[68982] = true,
	[374623] = true,
	[372315] = true,
	[372394] = true,
	[310839] = true,
	[81713] = true,
	[80734] = true,
}

local usePlater = LoadAddOn("Plater");

local function getUnitFrame(nameplate)
	if usePlater then
        return nameplate.unitFrame
    else
        return nameplate.UnitFrame
    end
end

local function isFaction(unit)
	if UnitIsUnit("player", unit) then
		return false;		
	else
		local reaction = UnitReaction("player", unit);
		if reaction and reaction <= 4 then
			return true;		
		elseif UnitIsPlayer(unit) then		
			return false;
		end
	end

end

local function isShow(unit)
	local unitname = GetUnitName(unit);

	if unitname and AHNameP_AlertList[unitname] then
		return true;
	end

	local name,  text, texture, startTime, endTime, isTradeSkill, castID, notInterruptible, spellid = UnitCastingInfo(unit);	
	if not name then
		name,  text, texture, startTime, endTime, isTradeSkill, notInterruptible, spellid = UnitChannelInfo(unit);
	end

	local status = UnitThreatSituation("player", unit);

	if AHNameP_ActivateOnAllCasting then
		 -- 차단 가능 스킬 모두 발동
		if name and spellid and status and notInterruptible == false  then
			return true;
		end
	else
		if name and spellid and AHNameP_DangerousSpellList[spellid] then
			return true;
		end
	end
end

local function checkNeedtoHide(nameplate)

	if not nameplate or nameplate:IsForbidden()  then		
		return false;
    end

	if not nameplate.UnitFrame or nameplate.UnitFrame:IsForbidden()  then		
		return false;
    end

	if (AHNameP_HideModifier == 1 and  IsAltKeyDown()) or (AHNameP_HideModifier == 2 and  IsControlKeyDown()) or  (AHNameP_HideModifier == 3 and  IsShiftKeyDown()) then
		return true;
	end

	local unit = nameplate.namePlateUnitToken;
	
	return isFaction(unit) and isShow(unit);
end


local function hideNameplates(nameplate, bshow)

	if not nameplate or nameplate:IsForbidden()  then
		return;
    end

	if not nameplate.UnitFrame or nameplate.UnitFrame:IsForbidden()  then		
		return false;
    end

	local unit = nameplate.namePlateUnitToken;

	if isFaction(unit) == false then
		return;
	end

	local unitframe = getUnitFrame(nameplate);

	if bshow then
		unitframe:Show();		
		return;
	end

	if UnitIsUnit(unit, "target") or UnitIsUnit(unit, "focus") or isShow(unit) then
		unitframe:Show();		
	else
		unitframe:Hide();		
	end
end



local function AHNameP_OnUpdate()

	local needtohide = false;

	for _,v in pairs(C_NamePlate.GetNamePlates(issecure())) do
		local nameplate = v;

		if (nameplate) then
			if checkNeedtoHide(nameplate) then
				needtohide = true;
				break;
			end

		end
	end

	for _,v in pairs(C_NamePlate.GetNamePlates(issecure())) do
		local nameplate = v;

		if (nameplate) then
			hideNameplates(nameplate, (not needtohide));
		end
	end
end

local function updateInterruptIDs()

end

local function AHNameP_OnEvent(self)

	-- 0.5 초 뒤에 Load
	C_Timer.After(0.5, updateInterruptIDs);
end


local function initAddon()
	AHNameP = CreateFrame("Frame", nil, UIParent)

	AHNameP:RegisterEvent("PLAYER_ENTERING_WORLD");
	AHNameP:RegisterEvent("TRAIT_CONFIG_UPDATED");
	AHNameP:RegisterEvent("TRAIT_CONFIG_LIST_UPDATED");
	AHNameP:RegisterEvent("ACTIVE_TALENT_GROUP_CHANGED");
	
	AHNameP:SetScript("OnEvent", AHNameP_OnEvent)
	--주기적으로 Callback
	C_Timer.NewTicker(AHNameP_UpdateRate, AHNameP_OnUpdate);

end

initAddon();

