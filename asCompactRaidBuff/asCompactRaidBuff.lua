local _, ns = ...;

local ACRB_MAX_BUFFS = 6           -- 최대 표시 버프 개수 (3개 + 3개)
local ACRB_MAX_BUFFS_2 = 2         -- 최대 생존기 개수
local ACRB_MAX_DEBUFFS = 3         -- 최대 표시 디버프 개수 (3개)
local ACRB_MAX_DISPELDEBUFFS = 3   -- 최대 해제 디버프 개수 (3개)
local ACRB_MAX_CASTING = 2         -- 최대 Casting Alert
local ACRB_MaxBuffSize = 20        -- 최대 Buff Size 창을 늘려도 이 크기 이상은 안커짐
local ACRB_HealerManaBarHeight = 3 -- 힐러 마나바 크기 (안보이게 하려면 0)


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


local ACRB_mainframe = CreateFrame("Frame", nil, UIParent);

-- 직업 리필
ns.ACRB_ShowList = nil;
local asraid = {};

local function ACRB_InitList()
	local spec = GetSpecialization();
	local localizedClass, englishClass = UnitClass("player")
	local listname;

	ns.ACRB_ShowList = nil;

	if spec then
		listname = "ACRB_ShowList_" .. englishClass .. "_" .. spec;
	end

	ns.ACRB_ShowList = ns[listname];
end



-- 해제 디버프
local function ACRB_UpdateHealerMana(asframe)
	if (not asframe.asManabar) then
		return;
	end

	--마나는 unit으로만
	local unit = asframe.unit

	if not (unit) then
		return;
	end

	local role = UnitGroupRolesAssigned(unit)
	local CUF_AURA_BOTTOM_OFFSET = 4;

	local centeryoffset = 0;
	local powerBarUsedHeight = 0;


	if asframe.frame.powerBar and asframe.frame.powerBar:IsShown() then
		powerBarUsedHeight = 8;
	end

	if role and role == "HEALER" and powerBarUsedHeight == 0 then
		asframe.asManabar:SetMinMaxValues(0, UnitPowerMax(unit, Enum.PowerType.Mana))
		asframe.asManabar:SetValue(UnitPower(unit, Enum.PowerType.Mana));

		local info = PowerBarColor["MANA"];
		if (info) then
			local r, g, b = info.r, info.g, info.b;
			asframe.asManabar:SetStatusBarColor(r, g, b);
		end

		asframe.asManabar:Show();
		centeryoffset = 1;
	else
		CUF_AURA_BOTTOM_OFFSET = 1;
		asframe.asManabar:Hide();
	end

	local function layout(bottomoffset, centeroffset)
		asframe.asbuffFrames[1]:ClearAllPoints();
		asframe.asbuffFrames[1]:SetPoint("BOTTOMRIGHT", asframe.frame, "BOTTOMRIGHT", -2, bottomoffset);

		asframe.asbuffFrames[4]:ClearAllPoints();
		asframe.asbuffFrames[4]:SetPoint("RIGHT", asframe.frame, "RIGHT", -2, centeroffset);

		asframe.pvpbuffFrames[1]:ClearAllPoints()
		asframe.pvpbuffFrames[1]:SetPoint("CENTER", asframe.frame, "CENTER", 0, centeroffset);

		asframe.asdebuffFrames[1]:ClearAllPoints();
		asframe.asdebuffFrames[1]:SetPoint("BOTTOMLEFT", asframe.frame, "BOTTOMLEFT", 2, bottomoffset);
	end

	if powerBarUsedHeight > 0 then
		local buffOffset = CUF_AURA_BOTTOM_OFFSET + powerBarUsedHeight;
		centeryoffset = 4;

		if asframe.layout and asframe.layout ~= 2 then
			layout(buffOffset, centeryoffset);
			asframe.layout = 2;
		end
	elseif role and role == "HEALER" then
		local buffOffset = CUF_AURA_BOTTOM_OFFSET;
		if asframe.layout and asframe.layout ~= 1 then
			layout(buffOffset, centeryoffset);
			asframe.layout = 1;
		end
	end
end

local function ACRB_UpdateRaidIconAborbColor(asframe)
	local unit = asframe.unit

	if asframe.displayedUnit and asframe.displayedUnit ~= unit then
		unit = asframe.displayedUnit;
	end


	if not (unit) then
		return;
	end

	local function ACRB_DisplayRaidIcon(unit)
		local icon = GetRaidTargetIndex(unit)
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

	if (asframe.aborbcolor) then
		local value = UnitHealth(unit);
		local valueMax = UnitHealthMax(unit);
		local totalAbsorb = UnitGetTotalAbsorbs(unit) or 0;
		local remainAbsorb = totalAbsorb - (valueMax - value);

		if remainAbsorb > 0 then
			local totalWidth, _ = asframe.frame.healthBar:GetSize();
			local barSize = (remainAbsorb / valueMax) * totalWidth;

			asframe.aborbcolor:SetWidth(barSize);
			asframe.aborbcolor:Show();
		else
			asframe.aborbcolor:Hide();
		end
	end
end

local tanklist = {};
-- 탱커 처리부
local function updateTankerList()
	local _, RTB_ZoneType = IsInInstance();

	if RTB_ZoneType == "pvp" or RTB_ZoneType == "arena" then
		return nil;
	end

	tanklist = {};
	if IsInGroup() then
		for framename, asframe in pairs(asraid) do
			if asframe and asframe.frame and asframe.frame:IsShown() and asframe.unit then
				local assignedRole = UnitGroupRolesAssigned(asframe.unit);
				if assignedRole == "TANK" or assignedRole == "MAINTANK" then
					table.insert(tanklist, framename);
				end
			end
		end
	end
end


local function ACRB_disableDefault(frame)
	if frame and not frame:IsForbidden() then
		-- 거리 기능 충돌 때문에 안됨
		--frame.optionTable.fadeOutOfRange = false;
		frame:UnregisterEvent("UNIT_AURA");
		frame:UnregisterEvent("PLAYER_REGEN_ENABLED");
		frame:UnregisterEvent("PLAYER_REGEN_DISABLED");

		do
			if frame.buffFrames then
				for i = 1, #frame.buffFrames do
					frame.buffFrames[i]:SetAlpha(0);
					frame.buffFrames[i]:Hide();
				end
			end
		end

		do
			if frame.debuffFrames then
				for i = 1, #frame.debuffFrames do
					frame.debuffFrames[i]:SetAlpha(0);
					frame.debuffFrames[i]:Hide();
				end
			end
		end

		do
			if frame.dispelDebuffFrames then
				for i = 1, #frame.dispelDebuffFrames do
					frame.dispelDebuffFrames[i]:SetAlpha(0);
					frame.dispelDebuffFrames[i]:Hide();
				end
			end
		end
	end
end

local function ACRB_updatePartyAllHealerMana()
	if IsInGroup() then
		for _, asframe in pairs(asraid) do
			if asframe and asframe.frame and asframe.frame:IsShown() then
				ACRB_UpdateHealerMana(asframe);
				ACRB_UpdateRaidIconAborbColor(asframe);
				asframe.ncasting = 0;
			end
		end
	end
end

local DangerousSpellList = {};

local function ACRB_updateCasting(asframe, unit)
	if asframe and asframe.frame and asframe.frame:IsShown() and asframe.castFrames then
		local index = asframe.ncasting + 1;
		local castFrame = asframe.castFrames[index];

		local frameunit = asframe.unit

		if asframe.displayedUnit and asframe.displayedUnit ~= frameunit then
			frameunit = asframe.displayedUnit;
		end

		if frameunit and UnitIsUnit(unit .. "target", frameunit) then
			local name, text, texture, startTime, endTime, isTradeSkill, castID, notInterruptible, spellid =
				UnitCastingInfo(unit);
			if not name then
				name, text, texture, startTime, endTime, isTradeSkill, notInterruptible, spellid = UnitChannelInfo(unit);
			end

			if name and index <= #(asframe.castFrames) then
				castFrame.icon:SetTexture(texture);
				castFrame.count:Hide();

				local curr = GetTime();
				local start = startTime / 1000;
				local duration = (endTime / 1000) - start;

				ns.asCooldownFrame_Set(castFrame.cooldown, start, duration, true);

				if DangerousSpellList[spellid] then
					if DangerousSpellList[spellid] == "interrupt" or not notInterruptible then
						ns.lib.PixelGlow_Start(castFrame, { 0, 1, 0.32, 1 });
					else
						ns.lib.PixelGlow_Start(castFrame, { 0.5, 0.5, 0.5, 1 });
					end
				else
					ns.lib.PixelGlow_Stop(castFrame);
				end
				castFrame.castspellid = spellid;

				castFrame.border:Hide();
				castFrame:Show();
				asframe.ncasting = index;

				return true;
			end
		end
	end

	return false;
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

local function ARCB_HideCast(asframe)
	if asframe and asframe.castFrames then
		for i = asframe.ncasting + 1, #asframe.castFrames do
			asframe.castFrames[i]:Hide();
		end
	end
end

local function CheckCasting(nameplate)
	if not nameplate or nameplate:IsForbidden() then
		return;
	end

	local unit = nameplate.UnitFrame.unit;

	if isFaction(unit) then
		local name, text, texture, startTime, endTime, isTradeSkill, castID, notInterruptible, spellid = UnitCastingInfo(
			unit);
		if not name then
			name, text, texture, startTime, endTime, isTradeSkill, notInterruptible, spellid = UnitChannelInfo(unit);
		end

		if name then
			--탱커 부터
			for _, framename in pairs(tanklist) do
				local asframe = asraid[framename]
				if ACRB_updateCasting(asframe, unit) then
					return;
				end
			end

			if (IsInGroup()) then
				for _, asframe in pairs(asraid) do
					if asframe and asframe.frame and asframe.frame:IsShown() then
						if ACRB_updateCasting(asframe, unit) then
							return;
						end
					end
				end
			end
		end
	end
end


local function ACRB_CheckCasting()
	if (IsInGroup()) then
		for _, v in pairs(C_NamePlate.GetNamePlates(issecure())) do
			local nameplate = v;
			if (nameplate) then
				CheckCasting(nameplate);
			end
		end


		for _, asframe in pairs(asraid) do
			if asframe and asframe.frame and asframe.frame:IsShown() then
				ARCB_HideCast(asframe);
			end
		end
	end
end

-- Setup
local function ACRB_setupFrame(frame)
	if not frame or frame:IsForbidden() then
		return
	end


	local frameName = frame:GetName()
	if asraid[frameName] == nil then
		asraid[frameName] = {};
	end

	local asframe = asraid[frameName];

	if frame.unit then
		asframe.unit = frame.unit;
	end

	local displayedUnit;

	if frame.displayedUnit then
		asframe.displayedUnit = frame.displayedUnit;

		if (frame.unit ~= frame.displayedUnit) then
			displayedUnit = frame.displayedUnit;
		end
	else
		asframe.displayedUnit = frame.unit;
	end

	asframe.frame = frame;

	if not UnitIsPlayer(asframe.unit) then
		return;
	end



	local CUF_AURA_BOTTOM_OFFSET = 4;

	local frameHeight = EditModeManagerFrame:GetRaidFrameHeight(frame.isParty);
	local options = DefaultCompactUnitFrameSetupOptions;
	local powerBarHeight = 8;
	local powerBarUsedHeight = options.displayPowerBar and powerBarHeight or 0;
	local centeryoffset = 0;

	local x, y = frame:GetSize();
	if powerBarUsedHeight > 0 then
		CUF_AURA_BOTTOM_OFFSET = 1;
		centeryoffset = 4;
		y = y - powerBarUsedHeight;
	end
	asframe.layout = 0;

	local size_x = x / 6 * ns.ACRB_BuffSizeRate - 1;
	local size_y = y / 3 * ns.ACRB_BuffSizeRate - 1;

	local baseSize = math.min(x / 7 * ns.ACRB_BuffSizeRate, y / 3 * ns.ACRB_BuffSizeRate);

	if baseSize > ACRB_MaxBuffSize then
		baseSize = ACRB_MaxBuffSize
	end

	baseSize = baseSize * 0.9;

	local fontsize = baseSize * ns.ACRB_MinShowBuffFontSizeRate;

	if asframe.isDispellAlert == nil then
		asframe.isDispellAlert = false;
	end

	if not asframe.buffcolor then
		asframe.buffcolor = frame:CreateTexture(nil, "ARTWORK", "asBuffTextureTemplate", -1);
		asframe.buffcolor:Hide();
	end

	if asframe.buffcolor then
		local previousTexture = frame.healthBar:GetStatusBarTexture();
		asframe.buffcolor:ClearAllPoints();
		asframe.buffcolor:SetAllPoints(previousTexture);
		asframe.buffcolor:SetVertexColor(0.5, 0.5, 0.5);
	end

	if not asframe.aborbcolor then
		asframe.aborbcolor = frame:CreateTexture(nil, "ARTWORK", "asBuffTextureTemplate", 0);
		asframe.aborbcolor:Hide();
	end

	if asframe.aborbcolor then
		local previousTexture = frame.healthBar:GetStatusBarTexture();
		asframe.aborbcolor:ClearAllPoints();
		asframe.aborbcolor:SetPoint("TOPLEFT", previousTexture, "TOPLEFT", 0, 0);
		asframe.aborbcolor:SetPoint("BOTTOMLEFT", previousTexture, "BOTTOMLEFT", 0, 0);
		asframe.aborbcolor:SetWidth(0);
		asframe.aborbcolor:SetVertexColor(0, 0, 0);
		asframe.aborbcolor:SetAlpha(0.2);
	end

	local function layoutbuff(f, t)
		f:EnableMouse(ns.ACRB_ShowTooltip);
		f.icon:SetTexCoord(.08, .92, .08, .92);
		f.border:SetTexture("Interface\\Addons\\asCompactRaidBuff\\border.tga");
		f.border:SetTexCoord(0.08, 0.08, 0.08, 0.92, 0.92, 0.08, 0.92, 0.92);
		f.border:SetVertexColor(0, 0, 0);
		f.border:Show();

		f.cooldown:SetSwipeColor(0, 0, 0, 0.5);
		f.count:ClearAllPoints();
		f.count:SetPoint("BOTTOM", 0, 1);

		if ns.ACRB_ShowTooltip and not f:GetScript("OnEnter") then
			f:SetScript("OnEnter", function(s)
				if s.auraInstanceID then
					GameTooltip_SetDefaultAnchor(GameTooltip, s);
					if t == 1 then
						GameTooltip:SetUnitBuffByAuraInstanceID(asframe.displayedUnit, s.auraInstanceID,
							ns.bufffilter);
					elseif t == 2 then
						if s.isBossBuff then
							GameTooltip:SetUnitBuffByAuraInstanceID(asframe.displayedUnit, s.auraInstanceID,
								ns.bufffilter);
						else
							GameTooltip:SetUnitDebuffByAuraInstanceID(asframe.displayedUnit, s.auraInstanceID,
								ns.debufffilter);
						end
					else
						if s.castspellid and s.castspellid > 0 then
							GameTooltip_SetDefaultAnchor(GameTooltip, s);
							GameTooltip:SetSpellByID(s.castspellid);
						end
					end
				end
			end)
			f:SetScript("OnLeave", function()
				GameTooltip:Hide();
			end)
		end
	end

	local function layoutcooldown(f)
		f.count:SetFont(STANDARD_TEXT_FONT, fontsize, "OUTLINE")
		if ns.ACRB_ShowBuffCooldown and fontsize >= ns.ACRB_MinShowBuffFontSize then
			f.cooldown:SetHideCountdownNumbers(true);
			for _, r in next, { f.cooldown:GetRegions() } do
				if r:GetObjectType() == "FontString" then
					r:SetFont(STANDARD_TEXT_FONT, fontsize, "OUTLINE")
					r:ClearAllPoints();
					r:SetPoint("TOPLEFT", 1, 0);
					break
				end
			end
		end
	end

	if not asframe.asbuffFrames then
		asframe.asbuffFrames = {}
		for i = 1, ACRB_MAX_BUFFS do
			local buffFrame = CreateFrame("Button", nil, frame, "asCompactBuffTemplate")
			layoutbuff(buffFrame, 1);
			asframe.asbuffFrames[i] = buffFrame;
			buffFrame:Hide();
		end
	end

	if asframe.asbuffFrames then
		for i = 1, ACRB_MAX_BUFFS do
			local buffFrame = asframe.asbuffFrames[i];
			buffFrame:ClearAllPoints();

			if i <= ACRB_MAX_BUFFS - 3 then
				if math.fmod(i - 1, 3) == 0 then
					if i == 1 then
						local buffOffset = CUF_AURA_BOTTOM_OFFSET + powerBarUsedHeight;
						buffFrame:ClearAllPoints();
						buffFrame:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", -2, buffOffset);
					else
						buffFrame:SetPoint("BOTTOMRIGHT", asframe.asbuffFrames[i - 3], "TOPRIGHT", 0, 1)
					end
				else
					buffFrame:SetPoint("BOTTOMRIGHT", asframe.asbuffFrames[i - 1], "BOTTOMLEFT", -1, 0)
				end

				buffFrame.cooldown:SetSwipeColor(0, 0, 0, 0.5);
			else
				-- 3개는 따로 뺀다.
				if i == ACRB_MAX_BUFFS then
					-- 우상
					buffFrame:ClearAllPoints();
					buffFrame:SetPoint("TOPRIGHT", frame, "TOPRIGHT", -2, -2);
				elseif i == ACRB_MAX_BUFFS - 1 then
					-- 우중2
					buffFrame:ClearAllPoints();
					buffFrame:SetPoint("BOTTOMRIGHT", asframe.asbuffFrames[i - 1], "BOTTOMLEFT", -1, 0)
				else
					-- 우중
					buffFrame:ClearAllPoints();
					buffFrame:SetPoint("RIGHT", frame, "RIGHT", -2, centeryoffset);
				end

				buffFrame.cooldown:SetSwipeColor(0, 0, 0, 1);
			end
		end
	end


	--크기 조정
	for i, d in ipairs(asframe.asbuffFrames) do
		d:SetSize(size_x, size_y);
		layoutcooldown(d);
	end

	if not asframe.asdebuffFrames then
		asframe.asdebuffFrames = {};
		for i = 1, ACRB_MAX_DEBUFFS do
			local debuffFrame = CreateFrame("Button", nil, frame, "asCompactDebuffTemplate")
			layoutbuff(debuffFrame, 2);
			asframe.asdebuffFrames[i] = debuffFrame;
			debuffFrame:Hide();
		end
	end

	if asframe.asdebuffFrames then
		for i = 1, ACRB_MAX_DEBUFFS do
			local debuffFrame = asframe.asdebuffFrames[i];
			debuffFrame:ClearAllPoints()

			if math.fmod(i - 1, 3) == 0 then
				if i == 1 then
					local debuffOffset = CUF_AURA_BOTTOM_OFFSET + powerBarUsedHeight;
					debuffFrame:ClearAllPoints();
					debuffFrame:SetPoint("BOTTOMLEFT", frame, "BOTTOMLEFT", 2, debuffOffset);
				else
					debuffFrame:SetPoint("BOTTOMLEFT", asframe.asdebuffFrames[i - 3], "TOPLEFT", 0, 1)
				end
			else
				debuffFrame:SetPoint("BOTTOMLEFT", asframe.asdebuffFrames[i - 1], "BOTTOMRIGHT", 1, 0)
			end
		end
	end

	for _, d in ipairs(asframe.asdebuffFrames) do
		d.size_x, d.size_y = size_x, size_y; -- 디버프
		d:SetSize(size_x, size_y);
		layoutcooldown(d);
	end


	if not asframe.asdispelDebuffFrames then
		asframe.asdispelDebuffFrames = {};
		for i = 1, ACRB_MAX_DISPELDEBUFFS do
			local dispelDebuffFrame = CreateFrame("Button", nil, frame, "asCompactDispelDebuffTemplate")
			dispelDebuffFrame:EnableMouse(false);
			asframe.asdispelDebuffFrames[i] = dispelDebuffFrame;
			dispelDebuffFrame:Hide();
		end
	end

	if asframe.asdispelDebuffFrames then
		asframe.asdispelDebuffFrames[1]:SetPoint("RIGHT", asframe.asbuffFrames[ACRB_MAX_BUFFS],
			"LEFT", -1, 0);
		for i = 1, ACRB_MAX_DISPELDEBUFFS do
			if (i > 1) then
				asframe.asdispelDebuffFrames[i]:SetPoint("RIGHT", asframe.asdispelDebuffFrames[i - 1],
					"LEFT", 0, 0);
			end
			asframe.asdispelDebuffFrames[i]:SetSize(baseSize, baseSize);
		end
	end

	if (not asframe.asManabar) then
		asframe.asManabar = CreateFrame("StatusBar", nil, frame.healthBar)
		asframe.asManabar:SetStatusBarTexture("Interface\\Addons\\asCompactRaidBuff\\UI-StatusBar")
		asframe.asManabar:GetStatusBarTexture():SetHorizTile(false)
		asframe.asManabar:SetMinMaxValues(0, 100)
		asframe.asManabar:SetValue(100)
		asframe.asManabar:SetPoint("BOTTOM", frame.healthBar, "BOTTOM", 0, 0)
		asframe.asManabar:Hide();
	end

	if asframe.asManabar then
		asframe.asManabar:SetWidth(x - 2);
		asframe.asManabar:SetHeight(ACRB_HealerManaBarHeight)
	end

	if (not asframe.asraidicon) then
		asframe.asraidicon = frame:CreateFontString(nil, "OVERLAY")
		asframe.asraidicon:SetFont(STANDARD_TEXT_FONT, fontsize * 2)
		asframe.asraidicon:SetPoint("LEFT", frame.healthBar, "LEFT", 2, 0)
		asframe.asraidicon:Hide();
	end

	if asframe.asraidicon then
		asframe.asraidicon:SetFont(STANDARD_TEXT_FONT, fontsize * 2);
	end

	if (not asframe.pvpbuffFrames) then
		asframe.pvpbuffFrames = {};

		for i = 1, ACRB_MAX_BUFFS_2 do
			local pvpbuffFrame = CreateFrame("Button", nil, frame, "asCompactBuffTemplate")
			asframe.pvpbuffFrames[i] = pvpbuffFrame;
			layoutbuff(pvpbuffFrame, 1);
		end
	end

	for i, d in ipairs(asframe.pvpbuffFrames) do
		d:SetSize(size_x, size_y);
		layoutcooldown(d);
		d:ClearAllPoints()
		if i == 1 then
			d:SetPoint("CENTER", frame, "CENTER", 0, centeryoffset)
		else
			d:SetPoint("TOPRIGHT", asframe.pvpbuffFrames[i - 1], "TOPLEFT",
				0,
				0)
		end
	end


	if (not asframe.castFrames) then
		asframe.castFrames = {};

		for i = 1, ACRB_MAX_CASTING do
			local castFrame = CreateFrame("Button", nil, frame, "asCompactBuffTemplate")
			asframe.castFrames[i] = castFrame;
			layoutbuff(castFrame, 3);
		end
	end

	for i, d in ipairs(asframe.castFrames) do
		d:SetSize(size_x, size_y);
		layoutcooldown(d);
		d:ClearAllPoints()
		if i == 1 then
			d:SetPoint("TOP", frame, "TOP", 0, -2)
		else
			d:SetPoint("TOPRIGHT", asframe.castFrames[i - 1], "TOPLEFT", -1,
				0)
		end
	end

	asframe.ncasting = 0;

	ns.ACRB_UpdateAuras(asframe);
end


local function ARCB_UpdateAll(frame)
	if frame and not frame:IsForbidden() and frame.GetName then
		local name = frame:GetName();

		if name and not (name == nil) and (string.find(name, "CompactRaidGroup") or string.find(name, "CompactPartyFrameMember") or string.find(name, "CompactRaidFrame")) then
			if not (frame.displayedUnit and UnitIsPlayer(frame.displayedUnit)) then return end
			if not (frame.unit and UnitIsPlayer(frame.unit)) then return end
			ACRB_disableDefault(frame);
			ACRB_setupFrame(frame);
		end
	end
end

local function ACRB_updatePartyAllAura(auraonly)
	if (IsInGroup()) then
		for _, asframe in pairs(asraid) do
			if asframe and asframe.frame and asframe.frame:IsShown() then
				if auraonly then
					ns.ACRB_UpdateAuras(asframe);
				else
					ACRB_setupFrame(asframe.frame);
				end
			end
		end
	end
end

local function ACRB_OnUpdate()
	ACRB_updatePartyAllAura(true);
	ACRB_updatePartyAllHealerMana();
	ACRB_CheckCasting();
end


ACRB_InitList();

local function DumpCaches()
	ns.DumpCache();
	ACRB_updatePartyAllAura(false);
end

local DBMobj;

local function scanDBM()
	DangerousSpellList = {};
	if DBMobj.Mods then
		for i, mod in ipairs(DBMobj.Mods) do
			if mod.announces then
				for k, obj in pairs(mod.announces) do
					if obj.spellId and obj.announceType then
						if DangerousSpellList[obj.spellId] == nil or DangerousSpellList[obj.spellId] ~= "interrupt" then
							DangerousSpellList[obj.spellId] = obj.announceType;
						end
					end
				end
			end
			if mod.specwarns then
				for k, obj in pairs(mod.specwarns) do
					if obj.spellId and obj.announceType then
						if DangerousSpellList[obj.spellId] == nil or DangerousSpellList[obj.spellId] ~= "interrupt" then
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
local function ACRB_OnEvent(self, event, ...)
	local arg1 = ...;

	if (event == "PLAYER_ENTERING_WORLD") then
		ACRB_InitList();
		ns.hasValidPlayer = true;
		local bloaded = LoadAddOn("DBM-Core");
		if bloaded then
			hooksecurefunc(DBM, "NewMod", NewMod)
		end
		updateTankerList();
		DumpCaches();
	elseif (event == "ACTIVE_TALENT_GROUP_CHANGED") then
		ACRB_InitList();
		DumpCaches();
	elseif (event == "GROUP_ROSTER_UPDATE") or (event == "CVAR_UPDATE") or (event == "ROLE_CHANGED_INFORM") then
		updateTankerList();
	elseif (event == "PLAYER_REGEN_ENABLED" or event == "PLAYER_REGEN_DISABLED") then
		DumpCaches();
	elseif (event == "PLAYER_LEAVING_WORLD") then
		ns.hasValidPlayer = false;
	end
end

ACRB_mainframe:SetScript("OnEvent", ACRB_OnEvent)
ACRB_mainframe:RegisterEvent("GROUP_ROSTER_UPDATE");
ACRB_mainframe:RegisterEvent("PLAYER_ENTERING_WORLD");
ACRB_mainframe:RegisterEvent("PLAYER_LEAVING_WORLD");
ACRB_mainframe:RegisterEvent("ACTIVE_TALENT_GROUP_CHANGED");
ACRB_mainframe:RegisterEvent("CVAR_UPDATE");
ACRB_mainframe:RegisterEvent("ROLE_CHANGED_INFORM");
ACRB_mainframe:RegisterEvent("VARIABLES_LOADED");
ACRB_mainframe:RegisterEvent("PLAYER_REGEN_ENABLED");
ACRB_mainframe:RegisterEvent("PLAYER_REGEN_DISABLED");

C_Timer.NewTicker(ns.ACRB_UpdateRate, ACRB_OnUpdate);

hooksecurefunc("CompactUnitFrame_UpdateAll", ARCB_UpdateAll);
hooksecurefunc("CompactUnitFrame_UpdateName", ns.UpdateNameColor);
