---설정부
local AHNameP_HideModifier = 4			-- ALT(1), CTRL(2), SHIFT(3), 자동(4) 지원 nil이면 기능 끄기
local AHNameP_UpdateRate = 0.2			-- Check할 주기
local AHNameP_ActivateOnAllCasting = false -- 차단 가능 스킬 모두 발동


local AHNameP_AlertList = {
	["폭발물"] = true,
	--["쉬바라"] = true,	 -- 녹색 빤짝이 
	--["우르줄"] = true,	 -- 녹색 빤짝이 
--	["파멸수호병"] = true,	 -- 녹색 빤짝이 
--	["지옥불정령"] = true,	 -- 녹색 빤짝이 
--	["격노수호병"] = true,
--	["지옥사냥개"] = true,
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

local learnedlist = {};

local function isInterruptReady()

	for _,spellid in ipairs(learnedlist) do
		local start, duration, enable = GetSpellCooldown(spellid);
		local _, gcd  = GetSpellCooldown(61304);

		if enable and duration <= gcd then
			return true;
		end

	end

	return false;

end

local function scanSpells(tab)

	local tabName, tabTexture, tabOffset, numEntries = GetSpellTabInfo(tab)

	if not tabName then
		return;
	end

	for i=tabOffset + 1, tabOffset + numEntries do
		local spellName, _, spellID = GetSpellBookItemName (i, BOOKTYPE_SPELL)
		if not spellName then
			do break end
		end

		if AHNameP_InterruptSpellList[spellID] then
			learnedlist[#learnedlist + 1] = spellID;
		end
	end
end

local function scanPetSpells()

	for i = 1, 20 do
	   	local slot = i + (SPELLS_PER_PAGE * (SPELLBOOK_PAGENUMBERS[BOOKTYPE_PET] - 1));
	   	local spellName, _, spellID = GetSpellBookItemName (slot, BOOKTYPE_PET)

		if not spellName then
			do break end
		end

		if AHNameP_InterruptSpellList[spellID] then
			learnedlist[#learnedlist + 1] = spellID;
		end
	end

end

local function updateInterruptIDs()
	learnedlist = {};

	scanSpells(2);
	scanSpells(3);
	scanPetSpells();

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
		if name and spellid and status and notInterruptible == false and (AHNameP_HideModifier <= 3 or isInterruptReady()) then
			return true;
		end
	else
		if name and spellid and status and notInterruptible == false and AHNameP_DangerousSpellList[spellid] and (AHNameP_HideModifier <= 3 or isInterruptReady()) then
			return true;
		end
	end
end

local isTank = false;

local function mustShow(unit)

	local name,  text, texture, startTime, endTime, isTradeSkill, castID, notInterruptible, spellid = UnitCastingInfo(unit);
	if not name then
		name,  text, texture, startTime, endTime, isTradeSkill, notInterruptible, spellid = UnitChannelInfo(unit);
	end

	local status = UnitThreatSituation("player", unit);

	 -- 차단 가능 스킬 모두 발동
	if name and spellid and status  then
		return true;
	end

	if isTank and status and status < 2 then
		return true;
	end

end

local function checkNeedtoHide(nameplate)

	if not nameplate or nameplate:IsForbidden()  then
		return false;
    end

	if not nameplate.UnitFrame or nameplate.UnitFrame:IsForbidden()  then
		return false;
    end

	local unit = nameplate.namePlateUnitToken;

	if UnitIsUnit(unit, "target") then
		return false;
	end

	if (AHNameP_HideModifier == 1 and  IsAltKeyDown()) or (AHNameP_HideModifier == 2 and  IsControlKeyDown()) or  (AHNameP_HideModifier == 3 and  IsShiftKeyDown()) then
		return true;
	end

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

	if UnitIsUnit(unit, "target") or UnitIsUnit(unit, "focus") or isShow(unit) or mustShow(unit) then
		unitframe:Show();
	else
		unitframe:Hide();
	end
end

local needtowork = false;

local function AHNameP_OnUpdate()

	local needtohide = false;

	if needtowork then

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
end



local function AHNameP_OnEvent(self, event)

	-- 0.5 초 뒤에 Load
	C_Timer.After(0.5, updateInterruptIDs);

	AHNameP_DangerousSpellList = {};

	if event == "PLAYER_ENTERING_WORLD" then
		needtowork = false;
		local inInstance, instanceType = IsInInstance();

		if (inInstance and instanceType == "party") then
			needtowork = true;
		end

		isTank = false;
		local assignedRole = UnitGroupRolesAssigned("player");

		if (assignedRole and assignedRole == "TANK") then
			isTank = true;
		end
	end
end

function AHNameP_DBMTimer_callback(event, id, ...)
	local msg, timer, icon, type, spellId, colorId, modid, keep, fade, name, guid = ...;
	if spellId then
		AHNameP_DangerousSpellList[spellId] = true;
	end
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

	local bloaded = LoadAddOn("DBM-Core");
	if bloaded then
		DBM:RegisterCallback("DBM_TimerStart", AHNameP_DBMTimer_callback );
	end

end

initAddon();