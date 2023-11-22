local _, ns = ...;

local DangerousSpellList = {

}

local ANameP_HealerGuid = {

}

local ANameP = nil;
local tanklist = {}

local PLAYER_UNITS = {
	player = true,
	vehicle = true,
	pet = true,
};


local lowhealthpercent = 0;

local ColorLevel = {
	None = 0,
	Reset = 1,
	Custom = 2,
	Debuff = 3,
	Lowhealth = 4,
	Aggro = 5,
	Target = 6,
	Interrupt = 7,
	Name = 8,
};

ns.ANameP_ShowList = nil;
local ANameP_Resourcetext = nil;
local debuffs_per_line = ns.ANameP_DebuffsPerLine;
local playerbuffposition = ns.ANameP_PlayerBuffY;
ns.options = CopyTable(ANameP_Options_Default);

--Cooldown
local function asCooldownFrame_Clear(self)
	self:Clear();
end
--cooldown
local function asCooldownFrame_Set(self, start, duration, enable, forceShowDrawEdge, modRate)
	if enable and enable ~= 0 and start > 0 and duration > 0 then
		self:SetDrawEdge(forceShowDrawEdge);
		self:SetCooldown(start, duration, modRate);
	else
		asCooldownFrame_Clear(self);
	end
end

ns.KnownSpellList = {};

local function asCheckTalent()
	local specID = PlayerUtil.GetCurrentSpecID();
	local configID = C_ClassTalents.GetActiveConfigID();

	if not (configID) then
		return;
	end
	local configInfo = C_Traits.GetConfigInfo(configID);
	local treeID = configInfo.treeIDs[1];
	local nodes = C_Traits.GetTreeNodes(treeID);

	for _, nodeID in ipairs(nodes) do
		local nodeInfo = C_Traits.GetNodeInfo(configID, nodeID);
		if nodeInfo.currentRank and nodeInfo.currentRank > 0 then
			local entryID = nodeInfo.activeEntry and nodeInfo.activeEntry.entryID and nodeInfo.activeEntry.entryID;
			local entryInfo = entryID and C_Traits.GetEntryInfo(configID, entryID);
			local definitionInfo = entryInfo and entryInfo.definitionID and
				C_Traits.GetDefinitionInfo(entryInfo.definitionID);

			if definitionInfo ~= nil then
				local talentName = TalentUtil.GetTalentName(definitionInfo.overrideName, definitionInfo.spellID);
				--print(string.format("%s/%d %s/%d", talentName, definitionInfo.spellID, definitionInfo.overrideName or "", definitionInfo.overriddenSpellID or 0));
				local name, rank, icon = GetSpellInfo(definitionInfo.spellID);
				ns.KnownSpellList[talentName or ""] = true;
				ns.KnownSpellList[icon or 0] = true;
				if definitionInfo.overrideName then
					--print (definitionInfo.overrideName)
					ns.KnownSpellList[definitionInfo.overrideName] = true;
				end
			end
		end
	end
	return;
end

local function scanSpells(tab)
	local tabName, tabTexture, tabOffset, numEntries = GetSpellTabInfo(tab)

	if not tabName then
		return;
	end

	for i = tabOffset + 1, tabOffset + numEntries do
		local spellName, _, spellID = GetSpellBookItemName(i, BOOKTYPE_SPELL)
		if not spellName then
			do break end
		end

		if spellName then
			ns.KnownSpellList[spellName] = 1;
		end
	end
end

local function scanPetSpells()
	for i = 1, 20 do
		local slot = i + (SPELLS_PER_PAGE * (SPELLBOOK_PAGENUMBERS[BOOKTYPE_PET] - 1));
		local spellName, _, spellID = GetSpellBookItemName(slot, BOOKTYPE_PET)

		if not spellName then
			do break end
		end

		if spellName then
			ns.KnownSpellList[spellName] = 1;
		end
	end
end



local function setupKnownSpell()
	ns.KnownSpellList = {};

	scanSpells(1)
	scanSpells(2)
	scanSpells(3)
	scanPetSpells()
	asCheckTalent();
end

-- 탱커 처리부
local function updateTankerList()
	local bInstance, RTB_ZoneType = IsInInstance();

	if RTB_ZoneType == "pvp" or RTB_ZoneType == "arena" then
		return nil;
	end

	tanklist = {}
	if IsInGroup() then
		if IsInRaid() then -- raid
			for i = 1, GetNumGroupMembers() do
				local unitid = "raid" .. i
				local notMe = not UnitIsUnit('player', unitid)
				local unitName = UnitName(unitid)
				if unitName and notMe then
					local _, _, _, _, _, _, _, _, _, role, _, assignedRole = GetRaidRosterInfo(i);
					if assignedRole == "TANK" then
						table.insert(tanklist, unitid);
					end
				end
			end
		else -- party
			for i = 1, GetNumSubgroupMembers() do
				local unitid = "party" .. i;
				local unitName = UnitName(unitid);
				if unitName then
					local assignedRole = UnitGroupRolesAssigned(unitid);
					if assignedRole == "TANK" then
						table.insert(tanklist, unitid);
					end
				end
			end
		end
	end
end

local function IsPlayerEffectivelyTank()
	local assignedRole = UnitGroupRolesAssigned("player");
	if (assignedRole == "NONE") then
		local spec = GetSpecialization();
		return spec and GetSpecializationRole(spec) == "TANK";
	end
	return assignedRole == "TANK";
end


-- 버프 디버프 처리부
local function createDebuffFrame(parent)
	local ret = CreateFrame("Frame", nil, parent, "asNamePlatesBuffFrameTemplate");
	ret:EnableMouse(false);

	local frameCooldown = ret.cooldown;
	local frameCount = ret.count;

	for _, r in next, { frameCooldown:GetRegions() } do
		if r:GetObjectType() == "FontString" then
			r:SetFont(STANDARD_TEXT_FONT, ns.ANameP_CooldownFontSize, "OUTLINE")
			r:ClearAllPoints();
			r:SetPoint("TOP", 0, 4);
			break;
		end
	end

	local font, size, flag = frameCount:GetFont()

	frameCount:SetFont(STANDARD_TEXT_FONT, ns.ANameP_CountFontSize, "OUTLINE")
	frameCount:ClearAllPoints();
	frameCount:SetPoint("BOTTOMRIGHT", -2, 2);

	local frameIcon = ret.icon;
	local frameBorder = ret.border;

	frameIcon:SetTexCoord(.08, .92, .08, .92)
	frameBorder:SetTexture("Interface\\Addons\\asNamePlates\\border.tga");
	frameBorder:SetTexCoord(0.08, 0.08, 0.08, 0.92, 0.92, 0.08, 0.92, 0.92);

	ret.alert = false;

	if not ret:GetScript("OnEnter") and ns.options.ANameP_Tooltip then
		ret:SetScript("OnEnter", function(s)
			if s:GetID() > 0 then
				GameTooltip_SetDefaultAnchor(GameTooltip, s);
				if s.type == 1 then
					GameTooltip:SetUnitBuffByAuraInstanceID(s.unit, s:GetID(), s.filter);
				else
					GameTooltip:SetUnitDebuffByAuraInstanceID(s.unit, s:GetID(), s.filter);
				end
			end
		end)
		ret:SetScript("OnLeave", function()
			GameTooltip:Hide();
		end)
	end

	return ret;
end

local function setFrame(frame, texture, count, expirationTime, duration, color)
	local frameIcon = frame.icon;
	frameIcon:SetTexture(texture);

	local frameCount = frame.count;
	local frameCooldown = frame.cooldown;

	if count and (count > 1) then
		frameCount:SetText(count);
		frameCount:Show();
		frameCooldown:SetDrawSwipe(false);
	else
		frameCount:Hide();
		frameCooldown:SetDrawSwipe(true);
	end

	asCooldownFrame_Set(frameCooldown, expirationTime - duration, duration, duration > 0, true);
	if ns.ANameP_CooldownFontSize > 0 then
		frameCooldown:SetHideCountdownNumbers(false);
	end

	local frameBorder = frame.border;
	frameBorder:SetVertexColor(color.r, color.g, color.b);
end

local function setSize(frame, size)
	frame:SetWidth(size + 2);
	frame:SetHeight((size + 2) * ns.ANameP_Size_Rate);
end

local function updateDebuffAnchor(frames, index, anchorIndex, size, offsetX, right, parent)
	local buff = frames[index];
	local point1 = "BOTTOMLEFT";
	local point2 = "BOTTOMLEFT";
	local point3 = "BOTTOMRIGHT";

	if (right == false) then
		point1 = "BOTTOMRIGHT";
		point2 = "BOTTOMRIGHT";
		point3 = "BOTTOMLEFT";
		offsetX = -offsetX;
	end

	buff:ClearAllPoints();

	if parent.downbuff then
		if (index == 1) then
			buff:SetPoint("TOPLEFT", parent, "BOTTOMLEFT", 0, 0);
		elseif (index == (debuffs_per_line + 1)) then
			buff:SetPoint("TOPLEFT", frames[1], "BOTTOMLEFT", 0, -4);
		else
			buff:SetPoint(point1, frames[index - 1], point3, offsetX, 0);
		end
	else
		if (index == 1) then
			buff:SetPoint("BOTTOMLEFT", parent, "TOPLEFT", 0, 0);
		elseif (index == (debuffs_per_line + 1)) then
			buff:SetPoint("BOTTOMLEFT", frames[1], "TOPLEFT", 0, 4);
		else
			buff:SetPoint(point1, frames[index - 1], point3, offsetX, 0);
		end
	end

	setSize(buff, size);
	buff:Show();
	if buff.alert then
		ns.lib.ButtonGlow_Start(buff);
	else
		ns.lib.ButtonGlow_Stop(buff);
	end
end

local function Comparison(AIndex, BIndex)
	local AID = AIndex[2];
	local BID = BIndex[2];

	if (AID ~= BID) then
		return AID > BID;
	end

	return false;
end

local classbar_height = nil;
local function GetClassBarHeight()
	if not classbar_height then
		local class = NamePlateDriverFrame:GetClassNameplateBar();

		if class then
			classbar_height = class:GetHeight();
		else
			classbar_height = 0;
		end
	end

	return classbar_height;
end



local function updateAuras(self, unit)
	local numDebuffs = 1;
	local size_list = {};
	local parent = self:GetParent():GetParent();
	local healthBar = parent.UnitFrame.healthBar;
	local bShowCC = false;
	local auraData;
	local icon_size = self.icon_size;

	if not unit then
		return
	end

	auraData = ns.UpdateAuras(unit);

	if auraData and auraData.type == 2 then
		auraData.buffs:Iterate(function(auraInstanceID, aura)
			if numDebuffs > ns.ANameP_MaxDebuff then
				return true;
			end
	
			if (not self.buffList[numDebuffs]) then
				self.buffList[numDebuffs] = createDebuffFrame(self);
			end
	
	
			local frame = self.buffList[numDebuffs];
			frame.alert = false;
			size_list[numDebuffs] = icon_size;			
	
			setSize(frame, size_list[numDebuffs]);
	
			local color = DebuffTypeColor["Disease"];
			setFrame(self.buffList[numDebuffs], aura.icon, aura.applications, aura.expirationTime, aura.duration, color);
	
			self.buffList[numDebuffs].filter = auraData.bufffilter;
			self.buffList[numDebuffs].type = 1;
			self.buffList[numDebuffs]:SetID(auraInstanceID);
			self.buffList[numDebuffs].unit = unit;
	
			numDebuffs = numDebuffs + 1;
			return false;
		end);

	elseif auraData and auraData.type == 1 then
		auraData.buffs:Iterate(function(auraInstanceID, aura)
			if numDebuffs > ns.ANameP_MaxBuff then
				return true;
			end

			if (not self.buffList[numDebuffs]) then
				self.buffList[numDebuffs] = createDebuffFrame(self);
			end


			local frame = self.buffList[numDebuffs];
			frame.alert = false;

			if aura.debuffType == ns.UnitFrameBuffType.PVP then
				size_list[numDebuffs] = icon_size + 2;
			else
				size_list[numDebuffs] = icon_size;
			end

			setSize(frame, size_list[numDebuffs]);

			local color = { r = 1, g = 1, b = 1 };
			setFrame(self.buffList[numDebuffs], aura.icon, aura.applications, aura.expirationTime, aura.duration, color);
			if aura.isStealable then
				frame.alert = true;
			end

			self.buffList[numDebuffs].filter = auraData.bufffilter;
			self.buffList[numDebuffs].type = 1;
			self.buffList[numDebuffs]:SetID(auraInstanceID);
			self.buffList[numDebuffs].unit = unit;

			numDebuffs = numDebuffs + 1;
			return false;
		end);

		self.debuffColor = 0;

		auraData.debuffs:Iterate(function(auraInstanceID, aura)
			if numDebuffs > ns.ANameP_MaxDebuff then
				return true;
			end

			if ns.ANameP_ShowCCDebuff and bShowCC == false and aura.nameplateShowAll and aura.duration > 0 and aura.duration <= 10 then
				show = false;
				bShowCC = true;

				local color = { r = 0.3, g = 0.3, b = 0.3 };

				setFrame(self.CCdebuff, aura.icon, aura.applications, aura.expirationTime, aura.duration, color);


				self.CCdebuff:ClearAllPoints();
				if self.casticon:IsShown() then
					self.CCdebuff:SetPoint("LEFT", self.casticon, "RIGHT", 1, 0);
				else
					self.CCdebuff:SetPoint("LEFT", healthBar, "RIGHT", 1, 0);
				end
				self.CCdebuff.filter = auraData.debufffilter;
				self.CCdebuff:SetID(auraInstanceID);
				self.CCdebuff.unit = unit;

				self.CCdebuff:Show();
			else
				local alert = false;
				local showlist_time = nil;
				if ns.ANameP_ShowList and ns.ANameP_ShowList[aura.name] then
					showlist_time = ns.ANameP_ShowList[aura.name][1];
					local alertcount = ns.ANameP_ShowList[aura.name][4] or false;
					local alertnameplate = ns.ANameP_ShowList[aura.name][3] or 0;

					if showlist_time == 1 then
						showlist_time = aura.duration * 0.3;
						ns.ANameP_ShowList[aura.name][1] = showlist_time;
					end

					if showlist_time and showlist_time >= 0 and alertcount == false then
						local alert_time = aura.expirationTime - showlist_time;

						if (GetTime() >= alert_time) and aura.duration > 0 then
							alert = true;
						else
							if alertnameplate then
								self.debuffColor = self.debuffColor + alertnameplate;
							end
						end
					elseif showlist_time and showlist_time >= 0 and alertcount then
						if (aura.applications >= showlist_time) then
							alert = true;
							if alertnameplate then
								self.debuffColor = self.debuffColor + alertnameplate;
							end
						end
					end
				end


				if (not self.buffList[numDebuffs]) then
					self.buffList[numDebuffs] = createDebuffFrame(self);
				end


				local frame = self.buffList[numDebuffs];
				frame.alert = false;

				local size = icon_size;

				if aura.nameplateShowAll then
					size = icon_size + ns.ANameP_PVP_Debuff_Size_Rate;
				end

				size_list[numDebuffs] = size;

				setSize(frame, size_list[numDebuffs]);

				local color = DebuffTypeColor["none"];

				if (not PLAYER_UNITS[aura.sourceUnit]) then
					color = { r = 0.3, g = 0.3, b = 0.3 };
				end

				if aura.dispelName then
					color = DebuffTypeColor[aura.dispelName];
				end

				setFrame(self.buffList[numDebuffs], aura.icon, aura.applications, aura.expirationTime, aura.duration, color);

				if alert and aura.duration > 0 then
					frame.alert = true;
				end
				self.buffList[numDebuffs].filter = auraData.debufffilter;
				self.buffList[numDebuffs].type = 2;
				self.buffList[numDebuffs]:SetID(auraInstanceID);
				self.buffList[numDebuffs].unit = unit;

				numDebuffs = numDebuffs + 1;
			end

			return false;
		end);
	end

	for i = 1, numDebuffs - 1 do
		updateDebuffAnchor(self.buffList, i, i - 1, size_list[i], 1, true, self);
	end	

	for i = numDebuffs, ns.ANameP_MaxDebuff do
		if (self.buffList[i]) then
			self.buffList[i]:Hide();
			ns.lib.ButtonGlow_Stop(self.buffList[i]);
		end
	end

	if numDebuffs > 1 then
		self:Show();
	end

	if bShowCC == false then
		self.CCdebuff:Hide();
	end
end

local function updateUnitAuras(unit)
	local nameplate = C_NamePlate.GetNamePlateForUnit(unit, issecure());
	if (nameplate and nameplate.asNamePlates and not nameplate:IsForbidden()) then
		if nameplate.asNamePlates.checkaura then
			updateAuras(nameplate.asNamePlates, nameplate.namePlateUnitToken);
		else
			nameplate.asNamePlates:Hide();
		end
	end
end

local function updateTargetNameP(self)
	if not self.unit or not self.checkaura then
		return;
	end

	local unit = self.unit;
	local parent = self:GetParent():GetParent();

	if not parent or not parent.UnitFrame or parent.UnitFrame:IsForbidden() then
		return;
	end

	local UnitFrame = parent.UnitFrame;
	local healthBar = UnitFrame.healthBar;

	if not healthBar then
		return;
	end

	local orig_height = self.orig_height
	local cast_height = 8;

	if UnitFrame.castBar then
		cast_height = UnitFrame.castBar:GetHeight();
	end

	if orig_height == nil then
		return;
	end

	local casticon = self.casticon;
	local height = orig_height;
	local base_y = ns.ANameP_TargetBuffY;

	if UnitFrame.name:IsShown() then
		base_y = base_y + UnitFrame.name:GetHeight();
	end

	if UnitIsUnit(unit, "target") then
		height = orig_height + ns.ANameP_TargetHealthBarHeight;
		self.healthtext:Show();

		if casticon then
			casticon:SetWidth((height + cast_height + 2) * 1.2);
			casticon:SetHeight(height + cast_height + 2);
			casticon.border:SetVertexColor(1, 1, 1);
		end

		if GetCVarBool("nameplateResourceOnTarget") then
			base_y = base_y + GetClassBarHeight();
		end
	elseif UnitIsUnit(unit, "player") then
		self.alerthealthbar = false;
		height = orig_height + ns.ANameP_TargetHealthBarHeight;
		self.healthtext:Show();
	else
		height = orig_height;
		self.healthtext:Hide();

		if casticon then
			casticon:SetWidth((height + cast_height + 2) * 1.2);
			casticon:SetHeight(height + cast_height + 2);
			casticon.border:SetVertexColor(0, 0, 0);
		end

		if UnitFrame.name:IsShown() then
			base_y = base_y + 4;
		end
	end

	--Healthbar 크기
	healthBar:SetHeight(height);

	--버프 Position
	self:ClearAllPoints();
	if UnitIsUnit(unit, "player") then
		if self.downbuff then
			self:SetPoint("TOPLEFT", ClassNameplateManaBarFrame, "BOTTOMLEFT", 0, playerbuffposition);
		else
			self:SetPoint("BOTTOMLEFT", healthBar, "TOPLEFT", 0, base_y);
		end
		-- 크기 조정이 안된다.
		--ClassNameplateManaBarFrame:SetHeight(height);

		if UnitFrame.BuffFrame then
			UnitFrame.BuffFrame:Hide();
		end
	else
		self:SetPoint("BOTTOMLEFT", healthBar, "TOPLEFT", 0, base_y);
		if UnitFrame.BuffFrame then
			UnitFrame.BuffFrame:Hide();
		end
	end
end

local function updateUnitHealthText(self, unit)
	local value;
	local valueMax;
	local valuePct;
	local namePlateFrameBase = C_NamePlate.GetNamePlateForUnit(unit, issecure());
	if not namePlateFrameBase then
		return;
	end
	local frame = namePlateFrameBase.asNamePlates;

	if not frame then
		return;
	end

	value = UnitHealth(unit);
	valueMax = UnitHealthMax(unit);

	if valueMax > 0 then
		valuePct = (math.ceil((value / valueMax) * 100));
	end

	if valuePct > 0 then
		frame.healthtext:SetText(valuePct);
	else
		frame.healthtext:SetText("");
	end

	if valuePct <= lowhealthpercent then
		frame.healthtext:SetTextColor(1, 0.5, 0.5, 1);
	elseif valuePct > 0 then
		frame.healthtext:SetTextColor(1, 1, 1, 1);
	end
end

-- Healthbar 색상 처리부
local function setColoronStatusBar(self, r, g, b)
	local parent = self:GetParent():GetParent();

	if not parent or not parent.UnitFrame or parent.UnitFrame:IsForbidden() or not self.BarColor then
		return;
	end

	local oldR, oldG, oldB = self.BarColor:GetVertexColor();

	if (r ~= oldR or g ~= oldG or b ~= oldB) then
		self.BarColor:SetVertexColor(r, g, b);
	end

	self.BarColor:Show();
end

local function isDangerousSpell(spellId)
	if spellId and DangerousSpellList[spellId] then
		if DangerousSpellList[spellId] == "interrupt" then
			return true, true;
		end
		return true, false;
	end
	return false, false;
end

local bloadedAutoMarker = false;

local function updateHealthbarColor(self)
	--unit name 부터
	if not self.unit or not self.checkcolor then
		return;
	end

	local unit = self.unit;
	local parent = self:GetParent():GetParent();

	if not parent or not parent.UnitFrame or parent.UnitFrame:IsForbidden() then
		return;
	end
	local UnitFrame = parent.UnitFrame;
	local healthBar = UnitFrame.healthBar;

	if not healthBar and healthBar:IsForbidden() then
		return;
	end

	local shouldshow = false;
	-- ColorLevel.Name;
	local unitname = GetUnitName(unit);

	if unitname and ns.ANameP_AlertList[unitname] then
		if self.colorlevel < ColorLevel.Name then
			self.colorlevel = ColorLevel.Name;
			setColoronStatusBar(self, ns.ANameP_AlertList[unitname][1], ns.ANameP_AlertList[unitname][2],
				ns.ANameP_AlertList[unitname][3]);
		end

		if ns.ANameP_AlertList[unitname][4] == 1 then
			ns.lib.PixelGlow_Start(healthBar);
			self.alerthealthbar = true;
		end
		return;
	end

	-- Cast Interrupt
	local status = UnitThreatSituation("player", unit);

	if self.castspellid and self.casticon and status then
		local name, text, texture, startTime, endTime, isTradeSkill, castID, notInterruptible, spellid = UnitCastingInfo(
			unit);
		if not name then
			name, text, texture, startTime, endTime, isTradeSkill, notInterruptible, spellid = UnitChannelInfo(unit);
		end

		if spellid then
			local isDanger, binterrupt = isDangerousSpell(spellid);

			self.castspellid = spellid;
			if isDanger and (binterrupt == true or not notInterruptible) then
				ns.lib.PixelGlow_Start(self.casticon, { 0, 1, 0.32, 1 });
				ns.lib.PixelGlow_Start(healthBar, { 0, 1, 0.32, 1 });
			elseif isDanger then
				ns.lib.PixelGlow_Start(self.casticon, { 0.5, 0.5, 0.5, 1 });
				ns.lib.PixelGlow_Start(healthBar, { 0.5, 0.5, 0.5, 1 });
			elseif notInterruptible == false then
				ns.lib.PixelGlow_Start(self.casticon);
				ns.lib.PixelGlow_Stop(healthBar);
			else
				ns.lib.PixelGlow_Stop(self.casticon);
				ns.lib.PixelGlow_Stop(healthBar);
			end
		else
			ns.lib.PixelGlow_Stop(self.casticon);
			ns.lib.PixelGlow_Stop(healthBar);
		end
	else
		if self.casticon then
			ns.lib.PixelGlow_Stop(self.casticon);
		end
		ns.lib.PixelGlow_Stop(healthBar);
	end

	--Target Check
	local isTargetPlayer = UnitIsUnit(unit .. "target", "player");

	if (isTargetPlayer) and ns.options.ANameP_AggroTargetColor then
		if self.colorlevel < ColorLevel.Target then
			self.colorlevel = ColorLevel.Target;
			setColoronStatusBar(self, ns.options.ANameP_AggroTargetColor.r, ns.options.ANameP_AggroTargetColor.g,
				ns.options.ANameP_AggroTargetColor.b);
		end
		return;
	elseif self.colorlevel == ColorLevel.Target then
		self.colorlevel = ColorLevel.Reset;
	end

	-- Aggro Check
	local aggrocolor;

	if status and ns.options.ANameP_AggroShow then
		local tanker = IsPlayerEffectivelyTank();
		if tanker then
			if status >= 2 then
				-- Tanking
				aggrocolor = ns.options.ANameP_AggroColor;
			else
				aggrocolor = ns.options.ANameP_TankAggroLoseColor;
				if #tanklist > 0 then
					for _, othertank in ipairs(tanklist) do
						if UnitIsUnit(unit .. "target", othertank) and not UnitIsUnit(unit .. "target", "player") then
							aggrocolor = ns.options.ANameP_TankAggroLoseColor2;
							break;
						end
					end
				end
			end
			self.colorlevel = ColorLevel.Aggro;
			setColoronStatusBar(self, aggrocolor.r, aggrocolor.g, aggrocolor.b);
			return;
		else -- Tanker가 아닐때
			if status >= 1 then
				-- Tanking
				aggrocolor = ns.options.ANameP_AggroColor;
				self.colorlevel = ColorLevel.Aggro;
				setColoronStatusBar(self, aggrocolor.r, aggrocolor.g, aggrocolor.b);
				return;
			elseif self.colorlevel == ColorLevel.Aggro then
				self.colorlevel = ColorLevel.Reset;
			end
		end
	end

	if lowhealthpercent > 0 then
		--Lowhealth 처리부
		local value = UnitHealth(unit);
		local valueMax = UnitHealthMax(unit);
		local valuePct = 0;

		if valueMax > 0 then
			valuePct = (math.ceil((value / valueMax) * 100));
		end

		if valuePct <= lowhealthpercent then
			setColoronStatusBar(self, ns.options.ANameP_LowHealthColor.r, ns.options.ANameP_LowHealthColor.g,
				ns.options.ANameP_LowHealthColor.b);
			self.colorlevel = ColorLevel.Lowhealth;
			return;
		elseif self.colorlevel == ColorLevel.Lowhealth then
			self.colorlevel = ColorLevel.Reset;
		end
	end

	-- Debuff Color
	if self.debuffColor > 0 then
		if self.colorlevel <= ColorLevel.Debuff then
			self.colorlevel = ColorLevel.Debuff;
			if self.debuffColor == 1 then
				setColoronStatusBar(self, ns.options.ANameP_DebuffColor.r, ns.options.ANameP_DebuffColor.g,
					ns.options.ANameP_DebuffColor.b);
			elseif self.debuffColor == 2 then
				setColoronStatusBar(self, ns.options.ANameP_DebuffColor2.r, ns.options.ANameP_DebuffColor2.g,
					ns.options.ANameP_DebuffColor2.b);
			elseif self.debuffColor > 2 then
				setColoronStatusBar(self, ns.options.ANameP_DebuffColor3.r, ns.options.ANameP_DebuffColor3.g,
					ns.options.ANameP_DebuffColor3.b);
			end
		end

		return;
	else
		if self.colorlevel == ColorLevel.Debuff then
			self.colorlevel = ColorLevel.Reset;
		end
	end

	if ns.options.ANameP_AutoMarker and bloadedAutoMarker and asAutoMarkerF and asAutoMarkerF.IsAutoMarkerMob(unit) then
		local color = ns.options.ANameP_AutoMarkerColor;
		self.colorlevel = ColorLevel.Custom;
		setColoronStatusBar(self, color.r, color.g, color.b);
		return;
	end

	if status then
		if #tanklist > 0 then
			for _, othertank in ipairs(tanklist) do
				if UnitIsUnit(unit .. "target", othertank) and not UnitIsUnit(unit .. "target", "player") then
					aggrocolor = ns.options.ANameP_TankAggroLoseColor2;
					self.colorlevel = ColorLevel.Custom;
					setColoronStatusBar(self, aggrocolor.r, aggrocolor.g, aggrocolor.b);
					return;
				elseif self.colorlevel == ColorLevel.Custom then
					self.colorlevel = ColorLevel.Reset;
				end
			end
		end
	end

	if UnitIsUnit(unit .. "target", "pet") then
		aggrocolor = ns.options.ANameP_TankAggroLoseColor3;
		self.colorlevel = ColorLevel.Custom;
		setColoronStatusBar(self, aggrocolor.r, aggrocolor.g, aggrocolor.b);
		return;
	elseif self.colorlevel == ColorLevel.Custom then
		self.colorlevel = ColorLevel.Reset;
	end



	if ns.options.ANameP_QuestAlert and not IsInInstance() and C_QuestLog.UnitIsRelatedToActiveQuest(unit) then
		local color = ns.options.ANameP_QuestColor;
		self.colorlevel = ColorLevel.Custom;
		setColoronStatusBar(self, color.r, color.g, color.b);
		return;
	end

	-- None
	if self.colorlevel > ColorLevel.None then
		self.colorlevel = ColorLevel.None;
	end

	if self.BarColor then
		self.BarColor:Hide();
	end

	return;
end

local function updatePVPAggro(self)
	if not ns.ANameP_PVPAggroShow then
		return
	end

	if not self.unit then
		return
	end

	local unit = self.unit;
	local parent = self:GetParent():GetParent();

	if parent.UnitFrame:IsForbidden() then
		return;
	end

	local isTargetPlayer = UnitIsUnit(unit .. "target", "player");

	if (isTargetPlayer) then
		self.aggro1:SetTextColor(1, 0, 0, 1);

		self.aggro1:SetText("▶");
		self.aggro1:Show();

		self.aggro2:SetTextColor(1, 0, 0, 1);

		self.aggro2:SetText("◀");
		self.aggro2:Show();
	else
		self.aggro1:Hide();
		self.aggro2:Hide();
	end
end


local function initAlertList()
	local spec = GetSpecialization();
	local localizedClass, englishClass = UnitClass("player");
	local listname;

	ns.ANameP_ShowList = nil;

	if spec == nil then
		spec = 1;
	end

	if spec then
		listname = "ANameP_ShowList_" .. englishClass .. "_" .. spec;
	end

	if ns.options[listname] then
		ns.ANameP_ShowList = CopyTable(ns.options[listname]);
	else
		ns.ANameP_ShowList = {};
	end

	ANameP_HealerGuid = {};

	lowhealthpercent = 0;

	if ns.options.ANameP_LowHealthAlert then
		if (englishClass == "MAGE") then
			if (asCheckTalent("불타는 손길")) then
				lowhealthpercent = 30;
			end

			if (asCheckTalent("비전 폭격")) then
				lowhealthpercent = 35;
			end
		end

		if (englishClass == "HUNTER") then
			if (asCheckTalent("마무리 사격")) then
				lowhealthpercent = 20;
			end
		end


		if (englishClass == "WARRIOR") then
			if (asCheckTalent("대학살")) then
				lowhealthpercent = 35;
			else
				lowhealthpercent = 20;
			end
		end

		if (englishClass == "PRIEST") then
			lowhealthpercent = 20;
		end

		if (englishClass == "PALADIN") then
			lowhealthpercent = 20;
		end

		if (englishClass == "DEATHKNIGHT") then
			if (asCheckTalent("영혼 수확자")) then
				lowhealthpercent = 35;
			end
		end
	end
end

local unit_guid_list = {};

local Aggro_Y = -5;

local function checkSpellCasting(self)
	if not self.unit then
		return;
	end

	local unit = self.unit;
	local name, text, texture, startTime, endTime, isTradeSkill, castID, notInterruptible, spellid = UnitCastingInfo(
		unit);
	if not name then
		name, text, texture, startTime, endTime, isTradeSkill, notInterruptible, spellid = UnitChannelInfo(unit);
	end

	if self.casticon then
		local frameIcon = self.casticon.icon;
		if name and frameIcon then
			frameIcon:SetTexture(texture);
			self.casticon:Show();
			self.castspellid = spellid;
			self.casticon.castspellid = spellid;
		else
			self.casticon:Hide();
			self.castspellid = nil;
		end
	end
end


local function asNamePlates_OnEvent(self, event, ...)
	if (event == "UNIT_THREAT_SITUATION_UPDATE" or event == "UNIT_THREAT_LIST_UPDATE") then
		updateHealthbarColor(self)
	elseif (event == "PLAYER_TARGET_CHANGED") then
		updateTargetNameP(self);
	else
		checkSpellCasting(self);
		updateHealthbarColor(self);
	end
end

local function createNamePlate(namePlateFrameBase)
end



local namePlateVerticalScale = nil;
local g_orig_height = nil;


local function removeNamePlate(namePlateUnitToken)
	local namePlateFrameBase = C_NamePlate.GetNamePlateForUnit(namePlateUnitToken, issecure());
	if namePlateFrameBase and namePlateFrameBase.asNamePlates then
		for i = 1, ns.ANameP_MaxDebuff do
			if (namePlateFrameBase.asNamePlates.buffList[i]) then
				namePlateFrameBase.asNamePlates.buffList[i]:Hide();
				ns.lib.ButtonGlow_Stop(namePlateFrameBase.asNamePlates.buffList[i]);
				namePlateFrameBase.asNamePlates.buffList[i] = nil;
			end
		end

		ns.lib.PixelGlow_Stop(namePlateFrameBase.asNamePlates.casticon);

		namePlateFrameBase.asNamePlates.unit = nil;
		namePlateFrameBase.asNamePlates.aggro1:Hide();
		namePlateFrameBase.asNamePlates.aggro1 = nil;
		namePlateFrameBase.asNamePlates.aggro2:Hide();
		namePlateFrameBase.asNamePlates.aggro2 = nil;
		namePlateFrameBase.asNamePlates.CCdebuff:Hide();
		namePlateFrameBase.asNamePlates.CCdebuff = nil;
		namePlateFrameBase.asNamePlates.healthtext:Hide();
		namePlateFrameBase.asNamePlates.healthtext = nil;
		namePlateFrameBase.asNamePlates.casticon:Hide();
		namePlateFrameBase.asNamePlates.casticon = nil;
		namePlateFrameBase.asNamePlates.healer:Hide();
		namePlateFrameBase.asNamePlates.healer = nil;
		namePlateFrameBase.asNamePlates:Hide();
		namePlateFrameBase.asNamePlates:UnregisterEvent("UNIT_THREAT_SITUATION_UPDATE");
		namePlateFrameBase.asNamePlates:UnregisterEvent("PLAYER_TARGET_CHANGED");
		namePlateFrameBase.asNamePlates:UnregisterEvent("UNIT_SPELLCAST_START");
		namePlateFrameBase.asNamePlates:UnregisterEvent("UNIT_SPELLCAST_CHANNEL_START");
		namePlateFrameBase.asNamePlates:UnregisterEvent("UNIT_SPELLCAST_SUCCEEDED");
		namePlateFrameBase.asNamePlates:UnregisterEvent("UNIT_SPELLCAST_INTERRUPTED");
		namePlateFrameBase.asNamePlates:UnregisterEvent("UNIT_SPELLCAST_DELAYED");
		namePlateFrameBase.asNamePlates:UnregisterEvent("UNIT_SPELLCAST_CHANNEL_STOP");
		namePlateFrameBase.asNamePlates:UnregisterEvent("UNIT_SPELLCAST_STOP");
		namePlateFrameBase.asNamePlates:UnregisterEvent("UNIT_SPELLCAST_FAILED");
		namePlateFrameBase.asNamePlates:SetScript("OnEvent", nil);
		namePlateFrameBase.asNamePlates.r = nil;
		namePlateFrameBase.asNamePlates.debuffColor = 0;
		namePlateFrameBase.asNamePlates.castspellid = nil;
		namePlateFrameBase.asNamePlates.BarColor:Hide();
		namePlateFrameBase.asNamePlates.BarColor = nil;

		if namePlateFrameBase.UnitFrame and namePlateFrameBase.UnitFrame.healthBar then
			if namePlateFrameBase.asNamePlates.alerthealthbar then
				ns.lib.PixelGlow_Stop(namePlateFrameBase.UnitFrame.healthBar);
				namePlateFrameBase.asNamePlates.alerthealthbar = false;
				namePlateFrameBase.asNamePlates.colorlevel = ColorLevel.None;
			end

			if namePlateFrameBase.asNamePlates.colorlevel > ColorLevel.None then
				namePlateFrameBase.asNamePlates.colorlevel = ColorLevel.None;
			end
		end

		namePlateFrameBase.asNamePlates = nil;
	end

	if UnitIsPlayer(namePlateUnitToken) and UnitGUID(namePlateUnitToken) then
		unit_guid_list[UnitGUID(namePlateUnitToken)] = nil;
	end
end

local function addNamePlate(namePlateUnitToken)
	local namePlateFrameBase = C_NamePlate.GetNamePlateForUnit(namePlateUnitToken, issecure());

	if not namePlateFrameBase or namePlateFrameBase.UnitFrame:IsForbidden() then
		return;
	end

	local unitFrame = namePlateFrameBase.UnitFrame;
	local healthbar = namePlateFrameBase.UnitFrame.healthBar;
	local unit = unitFrame.unit;

	if UnitIsUnit("player", unit) then
		if not ns.ANameP_ShowPlayerBuff then
			if namePlateFrameBase.asNamePlates then
				removeNamePlate(namePlateUnitToken);
				unitFrame.BuffFrame:SetAlpha(1);
				unitFrame.BuffFrame:Show();
			end
			return;
		end
	else
		local reaction = UnitReaction("player", unit);
		if reaction and reaction <= 4 then
			-- Reaction 4 is neutral and less than 4 becomes increasingly more hostile
		elseif UnitIsPlayer(unit) then
			if namePlateFrameBase.asNamePlates then
				removeNamePlate(namePlateUnitToken);
				unitFrame.BuffFrame:SetAlpha(1);
				unitFrame.BuffFrame:Show();
			end
			return;
		end
	end

	if not namePlateFrameBase.asNamePlates then
		namePlateFrameBase.asNamePlates = CreateFrame("Frame", nil, unitFrame);
	end

	namePlateFrameBase.asNamePlates:EnableMouse(false);

	if not namePlateFrameBase.asNamePlates.buffList then
		namePlateFrameBase.asNamePlates.buffList = {};
	end
	namePlateFrameBase.asNamePlates.unit = nil;
	namePlateFrameBase.asNamePlates.update = 0;
	namePlateFrameBase.asNamePlates.alerthealthbar = false;
	namePlateFrameBase.asNamePlates.checkaura = false;
	namePlateFrameBase.asNamePlates.downbuff = false;
	namePlateFrameBase.asNamePlates.checkpvptarget = false;
	namePlateFrameBase.asNamePlates.colorlevel = ColorLevel.None;
	namePlateFrameBase.asNamePlates.bhideframe = false;
	namePlateFrameBase.asNamePlates.isshown = nil;
	namePlateFrameBase.asNamePlates.originalcolor = { r = healthbar.r, g = healthbar.g, b = healthbar.b };
	namePlateFrameBase.asNamePlates.checkcolor = false;
	namePlateFrameBase.asNamePlates.debuffColor = 0;

	namePlateFrameBase.asNamePlates:UnregisterEvent("UNIT_THREAT_SITUATION_UPDATE");
	namePlateFrameBase.asNamePlates:UnregisterEvent("PLAYER_TARGET_CHANGED");
	namePlateFrameBase.asNamePlates:UnregisterEvent("UNIT_SPELLCAST_START");
	namePlateFrameBase.asNamePlates:UnregisterEvent("UNIT_SPELLCAST_CHANNEL_START");
	namePlateFrameBase.asNamePlates:UnregisterEvent("UNIT_SPELLCAST_SUCCEEDED");
	namePlateFrameBase.asNamePlates:UnregisterEvent("UNIT_SPELLCAST_INTERRUPTED");
	namePlateFrameBase.asNamePlates:UnregisterEvent("UNIT_SPELLCAST_DELAYED");
	namePlateFrameBase.asNamePlates:UnregisterEvent("UNIT_SPELLCAST_CHANNEL_STOP");
	namePlateFrameBase.asNamePlates:UnregisterEvent("UNIT_SPELLCAST_STOP");
	namePlateFrameBase.asNamePlates:UnregisterEvent("UNIT_SPELLCAST_FAILED");
	namePlateFrameBase.asNamePlates:SetScript("OnEvent", nil);


	local Size = ns.ANameP_AggroSize;

	if namePlateVerticalScale ~= tonumber(GetCVar("NamePlateVerticalScale")) then
		namePlateVerticalScale = tonumber(GetCVar("NamePlateVerticalScale"));
		g_orig_height = healthbar:GetHeight();
	end

	if namePlateVerticalScale > 1.0 then
		Aggro_Y = -1
		Size = ns.ANameP_AggroSize + 2
		debuffs_per_line = ns.ANameP_DebuffsPerLine + 1;
	else
		debuffs_per_line = ns.ANameP_DebuffsPerLine;
	end

	ns.ANameP_MaxDebuff = debuffs_per_line * 2;
	Aggro_Y = 0;

	namePlateFrameBase.asNamePlates.orig_height = g_orig_height;

	namePlateFrameBase.asNamePlates:ClearAllPoints();
	namePlateFrameBase.asNamePlates:SetPoint("CENTER", healthbar, "CENTER", 0, 0)

	if not namePlateFrameBase.asNamePlates.aggro1 then
		namePlateFrameBase.asNamePlates.aggro1 = healthbar:CreateFontString(nil, "OVERLAY");
	end

	namePlateFrameBase.asNamePlates.aggro1:SetFont(STANDARD_TEXT_FONT, Size, "THICKOUTLINE");
	namePlateFrameBase.asNamePlates.aggro1:ClearAllPoints();
	namePlateFrameBase.asNamePlates.aggro1:SetPoint("RIGHT", healthbar, "LEFT", -5, Aggro_Y)


	if not namePlateFrameBase.asNamePlates.aggro2 then
		namePlateFrameBase.asNamePlates.aggro2 = healthbar:CreateFontString(nil, "OVERLAY");
	end
	namePlateFrameBase.asNamePlates.aggro2:SetFont(STANDARD_TEXT_FONT, Size, "THICKOUTLINE");
	namePlateFrameBase.asNamePlates.aggro2:ClearAllPoints();
	namePlateFrameBase.asNamePlates.aggro2:SetPoint("LEFT", healthbar, "RIGHT", 0, Aggro_Y)

	if not namePlateFrameBase.asNamePlates.healer then
		namePlateFrameBase.asNamePlates.healer = healthbar:CreateFontString(nil, "OVERLAY");
	end
	if ns.ANameP_HealerSize > 0 then
		namePlateFrameBase.asNamePlates.healer:SetFont(STANDARD_TEXT_FONT, ns.ANameP_HealerSize, "THICKOUTLINE");
	else
		namePlateFrameBase.asNamePlates.healer:SetFont(STANDARD_TEXT_FONT, 1, "THICKOUTLINE");
	end
	namePlateFrameBase.asNamePlates.healer:ClearAllPoints();
	namePlateFrameBase.asNamePlates.healer:SetPoint("RIGHT", healthbar, "LEFT", -5, Aggro_Y)
	namePlateFrameBase.asNamePlates.healer:SetText("★");
	namePlateFrameBase.asNamePlates.healer:SetTextColor(0, 1, 0, 1);
	namePlateFrameBase.asNamePlates.healer:Hide();

	if not namePlateFrameBase.asNamePlates.healthtext then
		namePlateFrameBase.asNamePlates.healthtext = healthbar:CreateFontString(nil, "OVERLAY");
	end

	namePlateFrameBase.asNamePlates.healthtext:SetFont(STANDARD_TEXT_FONT, ns.ANameP_HeathTextSize, "OUTLINE");
	namePlateFrameBase.asNamePlates.healthtext:ClearAllPoints();
	namePlateFrameBase.asNamePlates.healthtext:SetPoint("CENTER", healthbar, "CENTER", 0, 0)

	if unitFrame.castBar then
		if not namePlateFrameBase.asNamePlates.casticon then
			namePlateFrameBase.asNamePlates.casticon = CreateFrame("Frame", nil, unitFrame.castBar,
				"asNamePlatesBuffFrameTemplate");

			if not namePlateFrameBase.asNamePlates.casticon:GetScript("OnEnter") then
				namePlateFrameBase.asNamePlates.casticon:SetScript("OnEnter", function(s)
					if s.castspellid and s.castspellid > 0 then
						GameTooltip_SetDefaultAnchor(GameTooltip, s);
						GameTooltip:SetSpellByID(s.castspellid);
					end
				end)
				namePlateFrameBase.asNamePlates.casticon:SetScript("OnLeave", function()
					GameTooltip:Hide();
				end)
			end
		end
		namePlateFrameBase.asNamePlates.casticon:EnableMouse(true);
		namePlateFrameBase.asNamePlates.casticon:ClearAllPoints();
		namePlateFrameBase.asNamePlates.casticon:SetPoint("BOTTOMLEFT", unitFrame.castBar, "BOTTOMRIGHT", 0, 1);
		namePlateFrameBase.asNamePlates.casticon:SetWidth(13);
		namePlateFrameBase.asNamePlates.casticon:SetHeight(13);

		local frameIcon = namePlateFrameBase.asNamePlates.casticon.icon;
		local frameBorder = namePlateFrameBase.asNamePlates.casticon.border;

		frameIcon:SetTexCoord(.08, .92, .08, .92);
		frameBorder:SetTexture("Interface\\Addons\\asNamePlates\\border.tga");
		frameBorder:SetTexCoord(0.08, 0.08, 0.08, 0.92, 0.92, 0.08, 0.92, 0.92);
		namePlateFrameBase.asNamePlates.casticon:Hide();
		namePlateFrameBase.asNamePlates.castspellid = nil;
	end


	if not namePlateFrameBase.asNamePlates.CCdebuff then
		namePlateFrameBase.asNamePlates.CCdebuff = CreateFrame("Frame", nil, unitFrame.healthBar,
			"asNamePlatesBuffFrameTemplate");
		if not namePlateFrameBase.asNamePlates.CCdebuff:GetScript("OnEnter") then
			namePlateFrameBase.asNamePlates.CCdebuff:SetScript("OnEnter", function(s)
				if s:GetID() > 0 then
					GameTooltip_SetDefaultAnchor(GameTooltip, s);
					GameTooltip:SetUnitDebuffByAuraInstanceID(s.unit, s:GetID(), s.filter);
				end
			end)
			namePlateFrameBase.asNamePlates.CCdebuff:SetScript("OnLeave", function()
				GameTooltip:Hide();
			end)
		end
	end
	--namePlateFrameBase.asNamePlates.CCdebuff:EnableMouse(false);
	namePlateFrameBase.asNamePlates.CCdebuff:ClearAllPoints();
	namePlateFrameBase.asNamePlates.CCdebuff:SetPoint("LEFT", namePlateFrameBase.asNamePlates.casticon, "RIGHT", 1, 0);
	namePlateFrameBase.asNamePlates.CCdebuff:SetWidth(ns.ANameP_CCDebuffSize * 1.2);
	namePlateFrameBase.asNamePlates.CCdebuff:SetHeight(ns.ANameP_CCDebuffSize);

	local frameIcon = namePlateFrameBase.asNamePlates.CCdebuff.icon;
	local frameBorder = namePlateFrameBase.asNamePlates.CCdebuff.border;

	frameIcon:SetTexCoord(.08, .92, .08, .92);
	frameBorder:SetTexture("Interface\\Addons\\asNamePlates\\border.tga");
	frameBorder:SetTexCoord(0.08, 0.08, 0.08, 0.92, 0.92, 0.08, 0.92, 0.92);

	for _, r in next, { namePlateFrameBase.asNamePlates.CCdebuff.cooldown:GetRegions() } do
		if r:GetObjectType() == "FontString" then
			r:SetFont(STANDARD_TEXT_FONT, ns.ANameP_CooldownFontSize, "OUTLINE")
			r:SetPoint("TOP", 0, 4);
			break;
		end
	end

	namePlateFrameBase.asNamePlates.CCdebuff:Hide();

	if not namePlateFrameBase.asNamePlates.BarColor then
		namePlateFrameBase.asNamePlates.BarColor = healthbar:CreateTexture(nil, "ARTWORK", "asColorTextureTemplate", 2);
	end

	if namePlateFrameBase.asNamePlates.BarColor then
		local previousTexture = healthbar:GetStatusBarTexture();
		namePlateFrameBase.asNamePlates.BarColor:ClearAllPoints();
		namePlateFrameBase.asNamePlates.BarColor:SetAllPoints(previousTexture);
		namePlateFrameBase.asNamePlates.BarColor:SetVertexColor(1, 1, 1)
		namePlateFrameBase.asNamePlates.BarColor:Hide();
	end


	if namePlateFrameBase.asNamePlates then
		namePlateFrameBase.asNamePlates.unit = unit;
		namePlateFrameBase.asNamePlates.checkaura = false;
		namePlateFrameBase.asNamePlates.downbuff = false;
		namePlateFrameBase.asNamePlates.healthtext:Hide();
		namePlateFrameBase.asNamePlates.checkpvptarget = false;
		namePlateFrameBase.asNamePlates.colorlevel = ColorLevel.None;
		namePlateFrameBase.asNamePlates.checkcolor = false;

		for i = 1, ns.ANameP_MaxDebuff do
			if (namePlateFrameBase.asNamePlates.buffList[i]) then
				namePlateFrameBase.asNamePlates.buffList[i]:Hide();
			end
		end

		if UnitIsPlayer(unit) then
			namePlateFrameBase.asNamePlates.colorlevel = ColorLevel.Name;
		else
			local bInstance, RTB_ZoneType = IsInInstance();
			if not (RTB_ZoneType == "pvp" or RTB_ZoneType == "arena") then
				--PVP 에서는 어그로 Check 안함
				namePlateFrameBase.asNamePlates:RegisterUnitEvent("UNIT_THREAT_SITUATION_UPDATE", "player", unit);
				namePlateFrameBase.asNamePlates:RegisterUnitEvent("UNIT_THREAT_LIST_UPDATE", "player", unit);
			end

			namePlateFrameBase.asNamePlates:SetScript("OnEvent", asNamePlates_OnEvent);
			namePlateFrameBase.asNamePlates:RegisterEvent("PLAYER_TARGET_CHANGED");
			namePlateFrameBase.asNamePlates:RegisterUnitEvent("UNIT_SPELLCAST_START", unit);
			namePlateFrameBase.asNamePlates:RegisterUnitEvent("UNIT_SPELLCAST_CHANNEL_START", unit);
			namePlateFrameBase.asNamePlates:RegisterUnitEvent("UNIT_SPELLCAST_SUCCEEDED", unit);
			namePlateFrameBase.asNamePlates:RegisterUnitEvent("UNIT_SPELLCAST_INTERRUPTED", unit);
			namePlateFrameBase.asNamePlates:RegisterUnitEvent("UNIT_SPELLCAST_DELAYED", unit);
			namePlateFrameBase.asNamePlates:RegisterUnitEvent("UNIT_SPELLCAST_CHANNEL_STOP", unit);
			namePlateFrameBase.asNamePlates:RegisterUnitEvent("UNIT_SPELLCAST_STOP", unit);
			namePlateFrameBase.asNamePlates:RegisterUnitEvent("UNIT_SPELLCAST_FAILED", unit);
		end

		if ns.ANameP_SIZE > 0 then
			namePlateFrameBase.asNamePlates.icon_size = ns.ANameP_SIZE;
		else
			local orig_width = healthbar:GetWidth();
			namePlateFrameBase.asNamePlates.icon_size = (orig_width / debuffs_per_line) - (debuffs_per_line - 1);
		end

		local class = UnitClassification(unit)

		namePlateFrameBase.asNamePlates.aggro1:ClearAllPoints();

		if class == "worldboss" or class == "elite" then
			namePlateFrameBase.asNamePlates.aggro1:SetPoint("RIGHT", healthbar, "LEFT", -5, Aggro_Y);
		else
			namePlateFrameBase.asNamePlates.aggro1:SetPoint("RIGHT", healthbar, "LEFT", 0, Aggro_Y);
		end

		namePlateFrameBase.asNamePlates.aggro1:Hide();
		namePlateFrameBase.asNamePlates.aggro2:Hide();
		namePlateFrameBase.asNamePlates:SetWidth(1);
		namePlateFrameBase.asNamePlates:SetHeight(1);
		namePlateFrameBase.asNamePlates:SetScale(1);

		local helpful = false;
		local showhealer = false;
		local checkaura = false;
		local checkpvptarget = false;
		local checkcolor = false;
		local filter = nil;

		if UnitIsUnit("player", unit) then
			--namePlateFrameBase.asNamePlates:Hide();
			if ns.ANameP_ShowPlayerBuff then
				checkaura = true;
				unitFrame.BuffFrame:SetAlpha(0);
				unitFrame.BuffFrame:Hide();
				unitFrame:UnregisterEvent("UNIT_AURA");
				namePlateFrameBase.asNamePlates:Show();

				-- Resource Text
				if ClassNameplateManaBarFrame and ANameP_Resourcetext == nil then
					ANameP_Resourcetext = ClassNameplateManaBarFrame:CreateFontString(nil, "OVERLAY");
					ANameP_Resourcetext:SetFont(STANDARD_TEXT_FONT, ns.ANameP_HeathTextSize - 3, "OUTLINE");
					ANameP_Resourcetext:SetAllPoints(true);
					ANameP_Resourcetext:SetPoint("CENTER", ClassNameplateManaBarFrame, "CENTER", 0, 0);
				end

				Buff_Y = ns.ANameP_PlayerBuffY;

				if Buff_Y < 0 then
					namePlateFrameBase.asNamePlates.downbuff = true;
					namePlateFrameBase.asNamePlates:ClearAllPoints();
					if GetCVar("nameplateResourceOnTarget") == "0" then
						playerbuffposition = Buff_Y - GetClassBarHeight();
					else
						playerbuffposition = Buff_Y;
					end
				end
			else
				checkaura = false;
			end
		else
			local reaction = UnitReaction("player", unit);
			if reaction and reaction <= 4 then
				if UnitIsPlayer(unit) and ANameP_HealerGuid[UnitGUID(unit)] then
					showhealer = true;
				end

				if UnitIsPlayer(unit) then
					checkpvptarget = true;
				else
					checkcolor = true;
				end
				checkaura = true;
				unitFrame.BuffFrame:SetAlpha(0);
				unitFrame.BuffFrame:Hide();

				unitFrame:UnregisterEvent("UNIT_THREAT_SITUATION_UPDATE");
				unitFrame:UnregisterEvent("UNIT_THREAT_LIST_UPDATE");
				unitFrame:UnregisterEvent("UNIT_AURA");
				namePlateFrameBase.asNamePlates:Show();
			elseif not namePlateFrameBase:IsForbidden() then
				checkaura = false;
				namePlateFrameBase.asNamePlates:Hide();
			end
		end

		namePlateFrameBase.asNamePlates.checkaura = checkaura;
		namePlateFrameBase.asNamePlates.checkpvptarget = checkpvptarget;
		namePlateFrameBase.asNamePlates.checkcolor = checkcolor;

		if showhealer and ns.ANameP_HealerSize > 0 then
			namePlateFrameBase.asNamePlates.healer:Show();
		else
			namePlateFrameBase.asNamePlates.healer:Hide();
		end
	end


	if UnitIsPlayer(unit) then
		unit_guid_list[UnitGUID(unit)] = unit;
	end
end


local function updateHealerMark(guid)
	local unit = unit_guid_list[guid];

	if unit and ANameP_HealerGuid[guid] and not UnitIsUnit(unit, "player") then
		local nameplate = C_NamePlate.GetNamePlateForUnit(unit, issecure());
		if (nameplate and nameplate.asNamePlates and not nameplate:IsForbidden() and nameplate.asNamePlates.checkpvptarget) then
			nameplate.asNamePlates.healer:Show();
		end
	end
end

local function asCompactUnitFrame_UpdateNameFaction(namePlateUnitToken)
	local namePlateFrameBase = C_NamePlate.GetNamePlateForUnit(namePlateUnitToken, issecure());
	if namePlateFrameBase and namePlateFrameBase.asNamePlates and not namePlateFrameBase:IsForbidden() then
		addNamePlate(namePlateUnitToken);
		if namePlateFrameBase.asNamePlates then
			updateTargetNameP(namePlateFrameBase.asNamePlates);
			updateUnitAuras(namePlateUnitToken);
			updateHealthbarColor(namePlateFrameBase.asNamePlates);
		end
	end
end

local bfirst = true;

local function setupFriendlyPlates()
	local isInstance, instanceType = IsInInstance();
	if bfirst and not isInstance and not InCombatLockdown() then
		C_NamePlate.SetNamePlateFriendlySize(60, 30);
		bfirst = false;
	end
end

local function ANameP_OnEvent(self, event, ...)
	local arg1 = ...;
	if event == "NAME_PLATE_CREATED" then
		local namePlateFrameBase = ...;
		createNamePlate(namePlateFrameBase);
	elseif event == "NAME_PLATE_UNIT_ADDED" then
		local namePlateUnitToken = ...;
		local namePlateFrameBase = C_NamePlate.GetNamePlateForUnit(namePlateUnitToken, issecure());
		if namePlateFrameBase then
			addNamePlate(namePlateUnitToken);
			if namePlateFrameBase.asNamePlates then
				updateTargetNameP(namePlateFrameBase.asNamePlates);
				updateUnitAuras(namePlateUnitToken);
				updateUnitHealthText(self, "target");
				updateUnitHealthText(self, "player");
				checkSpellCasting(namePlateFrameBase.asNamePlates);
				updateHealthbarColor(namePlateFrameBase.asNamePlates);
			end
		end
	elseif event == "NAME_PLATE_UNIT_REMOVED" then
		local namePlateUnitToken = ...;
		removeNamePlate(namePlateUnitToken);
	elseif event == "UNIT_SPELLCAST_SUCCEEDED" and arg1 == "player" then
		updateUnitAuras("target");
		updateUnitAuras("player");
		updateUnitHealthText(self, "target");
	elseif event == "PLAYER_TARGET_CHANGED" then
		updateUnitAuras("target");
		updateUnitHealthText(self, "target");
	elseif (event == "TRAIT_CONFIG_UPDATED") or (event == "TRAIT_CONFIG_LIST_UPDATED") or (event == "ACTIVE_TALENT_GROUP_CHANGED") then
		setupKnownSpell();
		C_Timer.After(0.5, initAlertList);
	elseif (event == "PLAYER_ENTERING_WORLD") then
		local isInstance, instanceType = IsInInstance();
		if isInstance and (instanceType == "party" or instanceType == "raid" or instanceType == "scenario") then
			self:UnregisterEvent("COMBAT_LOG_EVENT_UNFILTERED");
		else
			self:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED");
		end
		updateTankerList();
		setupKnownSpell();
		-- 0.5 초 뒤에 Load
		C_Timer.After(0.5, initAlertList);
		C_Timer.After(0.5, setupFriendlyPlates);
	elseif event == "COMBAT_LOG_EVENT_UNFILTERED" then
		local _, eventType, _, sourceGUID, _, _, _, destGUID, _, _, _, spellID, _, _, auraType =
			CombatLogGetCurrentEventInfo();
		if eventType == "SPELL_CAST_SUCCESS" and sourceGUID and not (sourceGUID == "") then
			local className = GetPlayerInfoByGUID(sourceGUID);
			if className and ns.ANameP_HealSpellList[className] and ns.ANameP_HealSpellList[className][spellID] then
				ANameP_HealerGuid[sourceGUID] = true;
				updateHealerMark(sourceGUID);
			end
		end
	elseif (event == "UNIT_FACTION") then
		local namePlateUnitToken = ...;
		asCompactUnitFrame_UpdateNameFaction(namePlateUnitToken);
	elseif (event == "GROUP_JOINED" or event == "GROUP_ROSTER_UPDATE" or event == "PLAYER_ROLES_ASSIGNED") then
		updateTankerList();
	elseif event == "PLAYER_REGEN_ENABLED" then
		setupFriendlyPlates();
	end
end

local function updateUnitResourceText(self, unit)
	local value;
	local valueMax;
	local valuePct;
	if UnitIsUnit("player", unit) then
	else
		return;
	end

	if ANameP_Resourcetext == nil then
		return;
	end

	value = UnitPower(unit);
	valueMax = UnitPowerMax(unit);

	if valueMax > 0 then
		valuePct = (math.ceil((value / valueMax) * 100));
	end

	if (valueMax <= 300) then
		valuePct = value;
	end

	if valuePct > 0 then
		ANameP_Resourcetext:SetText(valuePct);
	else
		ANameP_Resourcetext:SetText("");
	end


	if valuePct > 0 then
		ANameP_Resourcetext:SetTextColor(1, 1, 1, 1);
	end
end


local function ANameP_OnUpdate()
	updateUnitHealthText(ANameP, "target");
	updateUnitHealthText(ANameP, "player");
	updateUnitResourceText(ANameP, "player");

	for _, v in pairs(C_NamePlate.GetNamePlates(issecure())) do
		local nameplate = v;

		if (nameplate and nameplate.asNamePlates and not nameplate:IsForbidden()) then
			if nameplate.asNamePlates.checkaura then
				updateAuras(nameplate.asNamePlates, nameplate.namePlateUnitToken);
			else
				nameplate.asNamePlates:Hide();
			end

			if nameplate.asNamePlates.checkpvptarget then
				updatePVPAggro(nameplate.asNamePlates);
			end
			checkSpellCasting(nameplate.asNamePlates);
			updateHealthbarColor(nameplate.asNamePlates);
		end
	end
end

local function flushoption()
	ns.options = CopyTable(ANameP_Options);
	C_Timer.After(0.5, initAlertList);
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

local function initAddon()
	ANameP = CreateFrame("Frame", nil, UIParent)

	ANameP:RegisterEvent("NAME_PLATE_CREATED");
	ANameP:RegisterEvent("NAME_PLATE_UNIT_ADDED");
	ANameP:RegisterEvent("NAME_PLATE_UNIT_REMOVED");
	-- 나중에 추가 처리가 필요하면 하자.
	--ANameP:RegisterEvent("FORBIDDEN_NAME_PLATE_UNIT_ADDED");
	--ANameP:RegisterEvent("FORBIDDEN_NAME_PLATE_UNIT_REMOVED");
	ANameP:RegisterEvent("PLAYER_TARGET_CHANGED");
	ANameP:RegisterEvent("PLAYER_ENTERING_WORLD");
	ANameP:RegisterEvent("ADDON_LOADED")
	ANameP:RegisterEvent("TRAIT_CONFIG_UPDATED");
	ANameP:RegisterEvent("TRAIT_CONFIG_LIST_UPDATED");
	ANameP:RegisterEvent("ACTIVE_TALENT_GROUP_CHANGED");
	ANameP:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED");
	ANameP:RegisterEvent("UNIT_FACTION");
	ANameP:RegisterUnitEvent("UNIT_SPELLCAST_SUCCEEDED", "player");
	ANameP:RegisterEvent("GROUP_JOINED");
	ANameP:RegisterEvent("GROUP_ROSTER_UPDATE");
	ANameP:RegisterEvent("PLAYER_ROLES_ASSIGNED");
	ANameP:RegisterEvent("PLAYER_REGEN_ENABLED");

	ANameP:SetScript("OnEvent", ANameP_OnEvent)
	--주기적으로 Callback
	C_Timer.NewTicker(ns.ANameP_UpdateRate, ANameP_OnUpdate);

	hooksecurefunc("DefaultCompactNamePlateFrameAnchorInternal", function(frame, setupOptions)
		if (frame:IsForbidden()) then return end

		local pframe = C_NamePlate.GetNamePlateForUnit("target", issecure())

		if pframe and frame.BuffFrame.unit == pframe.namePlateUnitToken and pframe.asNamePlates then
			updateTargetNameP(pframe.asNamePlates);
		end
	end)

	ANameP_OptionM.RegisterCallback(flushoption);

	local bloaded = LoadAddOn("DBM-Core");
	if bloaded then
		hooksecurefunc(DBM, "NewMod", NewMod)
	end

	bloadedAutoMarker = LoadAddOn("asAutoMarker");
end

initAddon();
