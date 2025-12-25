local _, ns = ...;

---설정부
local configs = {
	updaterate = 0.2,
};

local usePlater = C_AddOns.LoadAddOn("Plater");

local function get_unitframe(nameplate)
	if usePlater then
		return nameplate.unitFrame
	else
		return nameplate.UnitFrame
	end
end

local function is_faction(unit)
	local reaction = UnitReaction("player", unit);
	if reaction and reaction <= 4 then
		return true;
	elseif UnitIsPlayer(unit) then
		return false;
	end
end

local function check_cast(unit)
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

local function check_trigger(nameplate)
	local unit = nameplate.unitToken;

	if not is_faction(unit) then
		return false;
	end

	if UnitIsUnit(unit, "target") then
		return false;
	end

	local status = UnitThreatSituation("player", unit);

	if status then
		local bcasting = check_cast(unit);
		if bcasting then
			local type = get_typeofcast(nameplate);
			if type ~= "uninterruptable" then
				return true;
			end
		end
	end

	return false;
end

-- Mouse Button 4 상태를 저장할 변수 추가
AHNP_ButtonPressed = false;

local function check_needtohide(nameplate)
	if not nameplate or nameplate:IsForbidden() then
		return false;
	end

	if not nameplate.UnitFrame or nameplate.UnitFrame:IsForbidden() then
		return false;
	end

	if ns.options.HideModifier == 1 then
		if AHNP_ButtonPressed then
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

	return check_trigger(nameplate);
end

local isTank = false;

local function is_mustshow(unit)
	if UnitIsUnit(unit, "target") or UnitIsUnit(unit, "focus") then
		return true;
	end

	local bcasting = check_cast(unit);
	local status = UnitThreatSituation("player", unit);

	if bcasting and status then
		return true;
	end


	if isTank and status and status < 2 then
		return true;
	end

	return false;
end

local function hide_nameplates(nameplate, bshow)
	if not nameplate or nameplate:IsForbidden() then
		return;
	end

	if not nameplate.UnitFrame or nameplate.UnitFrame:IsForbidden() then
		return false;
	end

	local unit = nameplate.unitToken;

	if is_faction(unit) == false then
		return;
	end

	local unitframe = get_unitframe(nameplate);

	if bshow then
		unitframe:Show();
		return;
	end

	if is_mustshow(unit) then
		unitframe:Show();
	else
		unitframe:Hide();
	end
end



local function on_update()
	local needtohide = false;

	for _, nameplate in pairs(C_NamePlate.GetNamePlates(issecure())) do
		if (nameplate) then
			if check_needtohide(nameplate) then
				needtohide = true;
				break;
			end
		end
	end
	for _, nameplate in pairs(C_NamePlate.GetNamePlates(issecure())) do
		if (nameplate) then
			hide_nameplates(nameplate, (not needtohide));
		end
	end
end

local function on_event(self, event, ...)
	isTank = false;
	local assignedRole = UnitGroupRolesAssigned("player");

	if (assignedRole and assignedRole == "TANK") then
		isTank = true;
	end
end

local function init()
	ns.SetupOptionPanels();
	AHNameP = CreateFrame("Frame", nil, UIParent)

	AHNameP:RegisterEvent("PLAYER_ENTERING_WORLD");
	AHNameP:RegisterEvent("TRAIT_CONFIG_UPDATED");
	AHNameP:RegisterEvent("TRAIT_CONFIG_LIST_UPDATED");
	AHNameP:RegisterEvent("ACTIVE_TALENT_GROUP_CHANGED");
	AHNameP:RegisterEvent("GROUP_ROSTER_UPDATE");
	AHNameP:RegisterEvent("ROLE_CHANGED_INFORM");

	AHNameP:SetScript("OnEvent", on_event);

	on_event();

	--주기적으로 Callback
	C_Timer.NewTicker(configs.updaterate, on_update);
end

BINDING_HEADER_ASMOD = "asMOD"
BINDING_NAME_AHNP_MODIFER_KEY = "asHideNamePlates Key"
C_Timer.After(1, init);
