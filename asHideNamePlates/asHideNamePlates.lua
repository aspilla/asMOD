local _, ns = ...;

---설정부
local AHNameP_UpdateRate = 0.2 -- Check할 주기

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
	local reaction = UnitReaction("player", unit);
	if reaction and reaction <= 4 then
		return true;
	elseif UnitIsPlayer(unit) then
		return false;
	end
end

local function checkCasting(unit)
	local name = UnitCastingInfo(unit);
	if not name then
		name = UnitChannelInfo(unit);
	end

	if name then
		return true;
	else
		return false;
	end
end

local function get_typeofcast(nameplate)
	if nameplate and nameplate.UnitFrame and nameplate.UnitFrame.castBar then
		return nameplate.UnitFrame.castBar.barType;
	end
	return nil;
end

local function checkTrigger(nameplate)
	local unit = nameplate.unitToken;

	if not isFaction(unit) then
		return false;
	end

	if UnitIsUnit(unit, "target") then
		return false;
	end

	local bcasting = checkCasting(unit);
	local type = get_typeofcast(nameplate);
	local status = UnitThreatSituation("player", unit);
	local level = UnitLevel(unit);
	local isBoss = false;

	if level < 0 or level > UnitLevel("player") then
		isBoss = true;
	end

	if ns.options.Trigger_Important_Interrupt_Only then
		if status and bcasting and (type == "empowered" or isBoss == false) then
			return true;
		end
	else
		if status and bcasting and (type == "standard" or type == "channel") then
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

	return checkTrigger(nameplate);
end

local isTank = false;

local function mustShow(unit)
	if UnitIsUnit(unit, "target") or UnitIsUnit(unit, "focus") then
		return true;
	end

	local bcasting = checkCasting(unit);
	local status = UnitThreatSituation("player", unit);

	if bcasting and status then
		return true;
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

	local unit = nameplate.unitToken;

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

	for _, nameplate in pairs(C_NamePlate.GetNamePlates(issecure())) do
		if (nameplate) then
			if checkNeedtoHide(nameplate) then
				needtohide = true;
				break;
			end
		end
	end
	for _, nameplate in pairs(C_NamePlate.GetNamePlates(issecure())) do
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

local function initAddon()
	ns.SetupOptionPanels();
	AHNameP = CreateFrame("Frame", nil, UIParent)

	AHNameP:RegisterEvent("PLAYER_ENTERING_WORLD");
	AHNameP:RegisterEvent("TRAIT_CONFIG_UPDATED");
	AHNameP:RegisterEvent("TRAIT_CONFIG_LIST_UPDATED");
	AHNameP:RegisterEvent("ACTIVE_TALENT_GROUP_CHANGED");
	AHNameP:RegisterEvent("GROUP_ROSTER_UPDATE");
	AHNameP:RegisterEvent("ROLE_CHANGED_INFORM");

	AHNameP:SetScript("OnEvent", AHNameP_OnEvent);

	AHNameP_OnEvent();

	--주기적으로 Callback
	C_Timer.NewTicker(AHNameP_UpdateRate, AHNameP_OnUpdate);
end

BINDING_HEADER_ASMOD = "asMOD"
BINDING_NAME_AHNP_MODIFER_KEY = "asHideNamePlates Key"
C_Timer.After(1, initAddon);
