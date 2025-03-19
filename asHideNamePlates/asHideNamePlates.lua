local _, ns = ...;

---설정부
local AHNameP_UpdateRate = 0.2 -- Check할 주기

local AHNameP_AlertList = {
	["폭발물"] = true,
}

local DangerousSpellList = {

}

local usePlater = C_AddOns.LoadAddOn("Plater");

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

local function checkCasting(unit)
	local name, _, _, _, _, _, _, _, spellid = UnitCastingInfo(unit);
	if not name then
		name, _, _, _, _, _, _, _, spellid = UnitChannelInfo(unit);
	end

	return name, spellid;
end

local function isShow(unit)
	if not isFaction(unit) then
		return false;
	end

	local unitname = GetUnitName(unit);

	if unitname and AHNameP_AlertList[unitname] then
		return true;
	end

	if UnitIsUnit(unit, "target") then
		return false;
	end

	local name, spellid = checkCasting(unit);
	local status = UnitThreatSituation("player", unit);

	if ns.options.Check_DBM_Interrupt_Only then
		-- 차단 가능 스킬 모두 발동
		if name and spellid and status and DangerousSpellList[spellid] then
			return true;
		end
	else
		if name and spellid and status then
			return true;
		end
	end

	return false;
end

-- Mouse Button 4 상태를 저장할 변수 추가
AHNP_mouseButton4Pressed = false;

local function checkNeedtoHide(nameplate)
	if not nameplate or nameplate:IsForbidden() then
		return false;
	end

	if not nameplate.UnitFrame or nameplate.UnitFrame:IsForbidden() then
		return false;
	end

	local unit = nameplate.namePlateUnitToken;

	if ns.options.HideModifier == 1 then
		if AHNP_mouseButton4Pressed then
			return true;
		else
			return false;
		end
	elseif ns.options.HideModifier < 6 then
		if (ns.options.HideModifier == 2 and IsAltKeyDown() and IsControlKeyDown()) or
			(ns.options.HideModifier == 3 and IsAltKeyDown()) or
			(ns.options.HideModifier == 4 and IsControlKeyDown()) or
			(ns.options.HideModifier == 5 and IsShiftKeyDown()) then
			return true;
		else
			return false;
		end
	end

	return isShow(unit);
end

local isTank = false;

local function mustShow(unit)
	if UnitIsUnit(unit, "target") or UnitIsUnit(unit, "focus") then
		return true;
	end

	local name, spellid = checkCasting(unit);
	local status = UnitThreatSituation("player", unit);

	if ns.options.Show_DBM_Interrupt_Only then
		-- 차단 가능 스킬 모두 발동
		if name and spellid and status and DangerousSpellList[spellid] then
			return true;
		end
	else
		if name and spellid and status then
			return true;
		end
	end

	if isTank and status and status < 2 then
		return true;
	end

	return false;
end

local function hideNameplates(nameplate, bshow)
	if not nameplate or nameplate:IsForbidden() then
		return;
	end

	if not nameplate.UnitFrame or nameplate.UnitFrame:IsForbidden() then
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

	if mustShow(unit) then
		unitframe:Show();
	else
		unitframe:Hide();
	end
end



local function AHNameP_OnUpdate()
	local needtohide = false;

	for _, v in pairs(C_NamePlate.GetNamePlates(issecure())) do
		local nameplate = v;

		if (nameplate) then
			if checkNeedtoHide(nameplate) then
				needtohide = true;
				break;
			end
		end
	end
	for _, v in pairs(C_NamePlate.GetNamePlates(issecure())) do
		local nameplate = v;

		if (nameplate) then
			hideNameplates(nameplate, (not needtohide));
		end
	end
end

local function AHNameP_OnEvent(self, event, ...)
	isTank = false;
	local assignedRole = UnitGroupRolesAssigned("player");

	if (assignedRole and assignedRole == "TANK") then
		isTank = true;
	end
end

local DBMobj;

local function scanDBM()
	DangerousSpellList = {};
	if DBMobj.Mods then
		for i, mod in ipairs(DBMobj.Mods) do
			if mod.announces then
				for k, obj in pairs(mod.announces) do
					if obj.spellId and obj.announceType then
						if obj.announceType == "interrupt" then
							DangerousSpellList[obj.spellId] = obj.announceType;
						end
					end
				end
			end
			if mod.specwarns then
				for k, obj in pairs(mod.specwarns) do
					if obj.spellId and obj.announceType then
						if obj.announceType == "interrupt" then
							DangerousSpellList[obj.spellId] = obj.announceType;
						end
					end
				end
			end
		end
	end
end

local function NewMod(self, ...)
	DBMobj = self;
	C_Timer.After(0.25, scanDBM);
end


local function initAddon()
	ns.SetupOptionPanels();
	AHNameP = CreateFrame("Frame", nil, UIParent)

	AHNameP:RegisterEvent("PLAYER_ENTERING_WORLD");
	AHNameP:RegisterEvent("TRAIT_CONFIG_UPDATED");
	AHNameP:RegisterEvent("TRAIT_CONFIG_LIST_UPDATED");
	AHNameP:RegisterEvent("ACTIVE_TALENT_GROUP_CHANGED");

	AHNameP:SetScript("OnEvent", AHNameP_OnEvent);

	AHNameP_OnEvent();

	--주기적으로 Callback
	C_Timer.NewTicker(AHNameP_UpdateRate, AHNameP_OnUpdate);

	local bloaded = C_AddOns.LoadAddOn("DBM-Core");
	if bloaded then
		hooksecurefunc(DBM, "NewMod", NewMod)
	end
end

BINDING_NAME_AHNP_MODIFER_KEY = "asHideNamePlates Key"
C_Timer.After(1, initAddon);
