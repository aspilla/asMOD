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


function ns.UpdateNameColor(frame, showbuffcolor, showhealthcolor)
	if not frame or frame:IsForbidden() then
		return
	end

	local frameName = frame:GetName()
	local asframe;

	if IsInRaid() then
		asframe = (frameName and ns.asraid[frameName]) or nil;
	else
		asframe = (frameName and ns.asparty[frameName]) or nil;
	end

	if asframe == nil or not asframe.buffcolor then
		return;
	end


	if showbuffcolor ~= nil then
		if ns.options.ShowBuffColor then
			if ns.options.ShowBuffColor2 then
				if showbuffcolor > 0 then
					if showbuffcolor ~= asframe.buffcolor.currcolor then
						asframe.buffcolor.currcolor = showbuffcolor;
						if showbuffcolor == 3 then
							asframe.buffcolor:SetVertexColor(0.7, 0.7, 0.7);
						elseif showbuffcolor == 2 then
							asframe.buffcolor:SetVertexColor(0.3, 0.3, 0.3);
						else
							asframe.buffcolor:SetVertexColor(0.5, 0.5, 0.5);
						end
					end
					asframe.buffcolor:Show();
				else
					asframe.buffcolor:Hide();
				end
			else
				if showbuffcolor == 1 or showbuffcolor == 3 then
					asframe.buffcolor:Show();
				else
					asframe.buffcolor:Hide();
				end
			end
		else
			asframe.buffcolor:Hide();
		end
	end

	if showhealthcolor ~= nil then
		if ns.options.ShowHealthColor then
			if showhealthcolor == true then
				asframe.healthcolor:Show();
			elseif showhealthcolor == false then
				asframe.healthcolor:Hide();
			end
		else
			asframe.healthcolor:Hide();
		end
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

	local previousTexture = frame.healthBar:GetStatusBarTexture();
	asframe.frametexture:SetVertexColor(previousTexture:GetVertexColor());
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

	if (asframe.asraidicon and ns.options.LeftTopRaidIcon) then
		local text = ACRB_DisplayRaidIcon(unit);
		asframe.asraidicon:SetText(text);
		asframe.asraidicon:Show();
	end

	local value = UnitHealth(unit);
	local valueMax = UnitHealthMax(unit);

	if (asframe.aborbcolor and ns.options.LeftAbsorbBar) then
		local totalAbsorb = UnitGetTotalAbsorbs(unit) or 0;
		local remainAbsorb = totalAbsorb - (valueMax - value);

		if remainAbsorb > valueMax then
			remainAbsorb = valueMax;
		end

		if remainAbsorb > 0 then
			local totalWidth, _ = asframe.frame.healthBar:GetSize();
			local barSize = (remainAbsorb / valueMax) * totalWidth;

			asframe.aborbcolor:SetWidth(barSize);
			asframe.aborbcolor:Show();
		else
			asframe.aborbcolor:Hide();
		end
	end

	if ns.lowhealth and asframe.healthcolor and valueMax and valueMax > 0 then
		local percent = (value / valueMax) * 100;
		if percent <= ns.lowhealth then
			ns.UpdateNameColor(asframe.frame, nil, true);
		else
			ns.UpdateNameColor(asframe.frame, nil, false);
		end
	end
end

function ns.ACRB_UpdateHealerMana(asframe)
	if asframe.needtosetup then
		ns.ACRB_setupFrame(asframe);
	end

	if (not asframe.asManabar) or (asframe.checkManaType == nil) then
		return;
	end

	asframe.asManabar:SetMinMaxValues(0, UnitPowerMax(asframe.unit, asframe.checkManaType));
	asframe.asManabar:SetValue(UnitPower(asframe.unit, asframe.checkManaType));
end
