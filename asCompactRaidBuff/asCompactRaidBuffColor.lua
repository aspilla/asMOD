local _, ns = ...;

local RaidIconList = {
	"|TInterface\\TargetingFrame\\UI-RaidTargetingIcon_1:",
	"|TInterface\\TargetingFrame\\UI-RaidTargetingIcon_2:",
	"|TInterface\\TargetingFrame\\UI-RaidTargetingIcon_3:",
	"|TInterface\\TargetingFrame\\UI-RaidTargetingIcon_4:",
	"|TInterface\\TargetingFrame\\UI-RaidTargetingIcon_5:",
	"|TInterface\\TargetingFrame\\UI-RaidTargetingIcon_6:",
	"|TInterface\\TargetingFrame\\UI-RaidTargetingIcon_7:",
	"|TInterface\\TargetingFrame\\UI-RaidTargetingIcon_8:",
}


function ns.UpdateNameColor(frame)
	if not frame or frame:IsForbidden() then
		return
	end

	local frameName = frame:GetName()
	local asframe = (frameName and ns.asraid[frameName]) or nil;

	if asframe == nil or not asframe.buffcolor then
		return;
	end

	if asframe.buffcolor:IsShown() or asframe.healthcolor:IsShown() then
		local class = select(2, UnitClass(frame.unit));
		local classColor = class and RAID_CLASS_COLORS[class] or nil;
		if classColor then
			frame.name:SetVertexColor(classColor.r, classColor.g, classColor.b);
		end
	else
		frame.name:SetVertexColor(1.0, 1.0, 1.0);
	end
end

function ns.ACRB_UpdateRaidIconAborbColor(asframe)
	local unit = asframe.unit;

	if asframe.displayedUnit and asframe.displayedUnit ~= unit then
		unit = asframe.displayedUnit;
	end


	if not (unit) then
		return;
	end

	local function ACRB_DisplayRaidIcon(u)
		local icon = GetRaidTargetIndex(u);
		if icon and RaidIconList[icon] then
			return RaidIconList[icon] .. "0|t"
		else
			return ""
		end
	end

	if (asframe.asraidicon) then
		local text = ACRB_DisplayRaidIcon(unit);
		asframe.asraidicon:SetText(text);
		asframe.asraidicon:Show();
	end

	local value = UnitHealth(unit);
	local valueMax = UnitHealthMax(unit);

	if (asframe.aborbcolor) then
		local totalAbsorb = UnitGetTotalAbsorbs(unit) or 0;
		local remainAbsorb = totalAbsorb - (valueMax - value);

		if remainAbsorb > 0 and remainAbsorb <= valueMax then
			local totalWidth, _ = asframe.frame.healthBar:GetSize();
			local barSize = (remainAbsorb / valueMax) * totalWidth;

			asframe.aborbcolor:SetWidth(barSize);
			asframe.aborbcolor:Show();
		else
			asframe.aborbcolor:Hide();
		end
	end

	if ns.lowhealth and asframe.healthcolor then
		local percent = (value / valueMax) * 100;
		if percent <= ns.lowhealth then
			asframe.healthcolor:Show();            
		else
			asframe.healthcolor:Hide();            
		end
        ns.UpdateNameColor(asframe.frame);
	end
end

function ns.ACRB_UpdateHealerMana(asframe)
	if (not asframe.asManabar) then
		return;
	end

	--마나는 unit으로만
	local unit = asframe.unit;

	if not (unit) then
		return;
	end

	local role = UnitGroupRolesAssigned(unit);
	local powerBarUsedHeight = 0;

	if asframe.frame.powerBar and asframe.frame.powerBar:IsShown() then
		powerBarUsedHeight = 8;
	end

	if role and role == "HEALER" and powerBarUsedHeight == 0 then
		asframe.asManabar:SetMinMaxValues(0, UnitPowerMax(unit, Enum.PowerType.Mana));
		asframe.asManabar:SetValue(UnitPower(unit, Enum.PowerType.Mana));

		local info = PowerBarColor["MANA"];
		if (info) then
			local r, g, b = info.r, info.g, info.b;
			asframe.asManabar:SetStatusBarColor(r, g, b);
		end

		asframe.asManabar:Show();		
	else
		asframe.asManabar:Hide();
	end

	local function layout(bottomoffset, centeroffset)
		asframe.asbuffFrames[1]:ClearAllPoints();
		asframe.asbuffFrames[1]:SetPoint("BOTTOMRIGHT", asframe.frame, "BOTTOMRIGHT", -2, bottomoffset);

		asframe.asbuffFrames[4]:ClearAllPoints();
		asframe.asbuffFrames[4]:SetPoint("RIGHT", asframe.frame, "RIGHT", -2, centeroffset);

		asframe.pvpbuffFrames[1]:ClearAllPoints();
		asframe.pvpbuffFrames[1]:SetPoint("CENTER", asframe.frame, "CENTER", 0, centeroffset);

		asframe.asdebuffFrames[1]:ClearAllPoints();
		asframe.asdebuffFrames[1]:SetPoint("BOTTOMLEFT", asframe.frame, "BOTTOMLEFT", 2, bottomoffset);
	end

	local CUF_AURA_BOTTOM_OFFSET = 2;
	local centeryoffset = 0;
	local layouttype = 1;

	if powerBarUsedHeight > 0 then
		CUF_AURA_BOTTOM_OFFSET = 1 + powerBarUsedHeight;
		centeryoffset = 4;
		layouttype = 3;	
	elseif role and role == "HEALER" then
		CUF_AURA_BOTTOM_OFFSET = ns.ACRB_HealerManaBarHeight + 1;
		centeryoffset = 1;
		layouttype = 2;
	end

	if asframe.layout and asframe.layout ~= layouttype then
		layout(CUF_AURA_BOTTOM_OFFSET, centeryoffset);
		asframe.layout = layouttype;
	end
end