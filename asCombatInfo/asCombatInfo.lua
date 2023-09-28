-- 설정
local ACI_SIZE = 40;             -- Button Size

local ACI_CoolButtons_X = 0      -- 쿨 List 위치 X
local ACI_CoolButtons_Y = -232   -- Y 위치
local ACI_Alpha = 1              -- 전투중 알파값
local ACI_Alpha_Normal = 0.5     -- 비전투중 안보이게 하려면 0
local ACI_CooldownFontSize = 12; -- Cooldown Font Size
local ACI_CountFontSize = 11;    -- Count Font Size
local ACI_MaxSpellCount = 11;    -- 최대 Spell Count
local ACI_RefreshRate = 0.5;     -- 반복 Check 주기 (초)



-- 높은 수 일 수록 보이는 우선순위 높음 (조정 필요)
local roguespell = {
	[6] = "집중 공격",
	[5] = "무자비한 정밀함",
	[4] = "해적 징표",
	[3] = "진방위",
	[2] = "대난투",
	[1] = "숨겨진 보물",
}

local options = CopyTable(ACI_Options_Default);
local _G = _G;
local cast_spell = nil;
local cast_time = nil;

local ACI = { nil, nil };
local ACI_mainframe;
local ACI_SpellList = nil;

--globals
ACI_Buff_list = {};
ACI_Debuff_list = {};
ACI_Player_Debuff_list = {};
ACI_SpellID_list = {};


local ACI_Cool_list = {};
local ACI_Active_list = {};
local ACI_Action_slot_list = {};
local ACI_Action_to_index = {};
local ACI_Alert_list = {};
local ACI_Current_Count = 0;


--Overlay stuff


local lib = {};

local isRetail = WOW_PROJECT_ID == WOW_PROJECT_MAINLINE
local textureList = {
	empty = [[Interface\AdventureMap\BrokenIsles\AM_29]],
	white = [[Interface\BUTTONS\WHITE8X8]],
	shine = [[Interface\ItemSocketingFrame\UI-ItemSockets]]
}

local shineCoords = { 0.3984375, 0.4453125, 0.40234375, 0.44921875 }
if isRetail then
	textureList.shine = [[Interface\Artifacts\Artifacts]]
	shineCoords = { 0.8115234375, 0.9169921875, 0.8798828125, 0.9853515625 }
end

function lib.RegisterTextures(texture, id)
	textureList[id] = texture
end

lib.glowList = {}
lib.startList = {}
lib.stopList = {}

local GlowParent = UIParent

local GlowMaskPool = CreateFromMixins(ObjectPoolMixin)
lib.GlowMaskPool = GlowMaskPool
local function MaskPoolFactory(maskPool)
	return maskPool.parent:CreateMaskTexture()
end

local MaskPoolResetter = function(maskPool, mask)
	mask:Hide()
	mask:ClearAllPoints()
end

ObjectPoolMixin.OnLoad(GlowMaskPool, MaskPoolFactory, MaskPoolResetter)
GlowMaskPool.parent = GlowParent

local TexPoolResetter = function(pool, tex)
	local maskNum = tex:GetNumMaskTextures()
	for i = maskNum, 1, -1 do
		tex:RemoveMaskTexture(tex:GetMaskTexture(i))
	end
	tex:Hide()
	tex:ClearAllPoints()
end
local GlowTexPool = CreateTexturePool(GlowParent, "ARTWORK", 7, nil, TexPoolResetter)
lib.GlowTexPool = GlowTexPool

local FramePoolResetter = function(framePool, frame)
	frame:SetScript("OnUpdate", nil)
	local parent = frame:GetParent()
	if parent[frame.name] then
		parent[frame.name] = nil
	end
	if frame.textures then
		for _, texture in pairs(frame.textures) do
			GlowTexPool:Release(texture)
		end
	end
	if frame.bg then
		GlowTexPool:Release(frame.bg)
		frame.bg = nil
	end
	if frame.masks then
		for _, mask in pairs(frame.masks) do
			GlowMaskPool:Release(mask)
		end
		frame.masks = nil
	end
	frame.textures = {}
	frame.info = {}
	frame.name = nil
	frame.timer = nil
	frame:Hide()
	frame:ClearAllPoints()
end
local GlowFramePool = CreateFramePool("Frame", GlowParent, nil, FramePoolResetter)
lib.GlowFramePool = GlowFramePool

local function addFrameAndTex(r, color, name, key, N, xOffset, yOffset, texture, texCoord, desaturated, frameLevel)
	key = key or ""
	frameLevel = frameLevel or 8
	if not r[name .. key] then
		r[name .. key] = GlowFramePool:Acquire()
		r[name .. key]:SetParent(r)
		r[name .. key].name = name .. key
	end
	local f = r[name .. key]
	f:SetFrameLevel(r:GetFrameLevel() + frameLevel)
	f:SetPoint("TOPLEFT", r, "TOPLEFT", -xOffset + 0.05, yOffset + 0.05)
	f:SetPoint("BOTTOMRIGHT", r, "BOTTOMRIGHT", xOffset, -yOffset + 0.05)
	f:Show()

	if not f.textures then
		f.textures = {}
	end

	for i = 1, N do
		if not f.textures[i] then
			f.textures[i] = GlowTexPool:Acquire()
			f.textures[i]:SetTexture(texture)
			f.textures[i]:SetTexCoord(texCoord[1], texCoord[2], texCoord[3], texCoord[4])
			f.textures[i]:SetDesaturated(desaturated)
			f.textures[i]:SetParent(f)
			f.textures[i]:SetDrawLayer("ARTWORK", 7)
			if not isRetail and name == "_AutoCastGlow" then
				f.textures[i]:SetBlendMode("ADD")
			end
		end
		f.textures[i]:SetVertexColor(color[1], color[2], color[3], color[4])
		f.textures[i]:Show()
	end
	while #f.textures > N do
		GlowTexPool:Release(f.textures[#f.textures])
		table.remove(f.textures)
	end
end


--Pixel Glow Functions--
local pCalc1 = function(progress, s, th, p)
	local c
	if progress > p[3] or progress < p[0] then
		c = 0
	elseif progress > p[2] then
		c = s - th - (progress - p[2]) / (p[3] - p[2]) * (s - th)
	elseif progress > p[1] then
		c = s - th
	else
		c = (progress - p[0]) / (p[1] - p[0]) * (s - th)
	end
	return math.floor(c + 0.5)
end

local pCalc2 = function(progress, s, th, p)
	local c
	if progress > p[3] then
		c = s - th - (progress - p[3]) / (p[0] + 1 - p[3]) * (s - th)
	elseif progress > p[2] then
		c = s - th
	elseif progress > p[1] then
		c = (progress - p[1]) / (p[2] - p[1]) * (s - th)
	elseif progress > p[0] then
		c = 0
	else
		c = s - th - (progress + 1 - p[3]) / (p[0] + 1 - p[3]) * (s - th)
	end
	return math.floor(c + 0.5)
end

local pUpdate = function(self, elapsed)
	self.timer = self.timer + elapsed / self.info.period
	if self.timer > 1 or self.timer < -1 then
		self.timer = self.timer % 1
	end
	local progress = self.timer
	local width, height = self:GetSize()
	if width ~= self.info.width or height ~= self.info.height then
		local perimeter = 2 * (width + height)
		if not (perimeter > 0) then
			return
		end
		self.info.width = width
		self.info.height = height
		self.info.pTLx = {
			[0] = (height + self.info.length / 2) / perimeter,
			[1] = (height + width + self.info.length / 2) / perimeter,
			[2] = (2 * height + width - self.info.length / 2) / perimeter,
			[3] = 1 - self.info.length / 2 / perimeter
		}
		self.info.pTLy = {
			[0] = (height - self.info.length / 2) / perimeter,
			[1] = (height + width + self.info.length / 2) / perimeter,
			[2] = (height * 2 + width + self.info.length / 2) / perimeter,
			[3] = 1 - self.info.length / 2 / perimeter
		}
		self.info.pBRx = {
			[0] = self.info.length / 2 / perimeter,
			[1] = (height - self.info.length / 2) / perimeter,
			[2] = (height + width - self.info.length / 2) / perimeter,
			[3] = (height * 2 + width + self.info.length / 2) / perimeter
		}
		self.info.pBRy = {
			[0] = self.info.length / 2 / perimeter,
			[1] = (height + self.info.length / 2) / perimeter,
			[2] = (height + width - self.info.length / 2) / perimeter,
			[3] = (height * 2 + width - self.info.length / 2) / perimeter
		}
	end
	if self:IsShown() then
		if not (self.masks[1]:IsShown()) then
			self.masks[1]:Show()
			self.masks[1]:SetPoint("TOPLEFT", self, "TOPLEFT", self.info.th, -self.info.th)
			self.masks[1]:SetPoint("BOTTOMRIGHT", self, "BOTTOMRIGHT", -self.info.th, self.info.th)
		end
		if self.masks[2] and not (self.masks[2]:IsShown()) then
			self.masks[2]:Show()
			self.masks[2]:SetPoint("TOPLEFT", self, "TOPLEFT", self.info.th + 1, -self.info.th - 1)
			self.masks[2]:SetPoint("BOTTOMRIGHT", self, "BOTTOMRIGHT", -self.info.th - 1, self.info.th + 1)
		end
		if self.bg and not (self.bg:IsShown()) then
			self.bg:Show()
		end
		for k, line in pairs(self.textures) do
			line:SetPoint("TOPLEFT", self, "TOPLEFT",
				pCalc1((progress + self.info.step * (k - 1)) % 1, width, self.info.th, self.info.pTLx),
				-pCalc2((progress + self.info.step * (k - 1)) % 1, height, self.info.th, self.info.pTLy))
			line:SetPoint("BOTTOMRIGHT", self, "TOPLEFT",
				self.info.th + pCalc2((progress + self.info.step * (k - 1)) % 1, width, self.info.th, self.info.pBRx),
				-height + pCalc1((progress + self.info.step * (k - 1)) % 1, height, self.info.th, self.info.pBRy))
		end
	end
end

function lib.PixelGlow_Start(r, color, N, frequency, length, th, xOffset, yOffset, border, key, frameLevel)
	if not r then
		return
	end
	if not color then
		color = { 0.95, 0.95, 0.32, 1 }
	end

	if not (N and N > 0) then
		N = 8
	end

	local period
	if frequency then
		if not (frequency > 0 or frequency < 0) then
			period = 4
		else
			period = 1 / frequency
		end
	else
		period = 4
	end
	local width, height = r:GetSize()
	length = length or math.floor((width + height) * (2 / N - 0.1))
	length = min(length, min(width, height))
	th = th or 1
	xOffset = xOffset or 0
	yOffset = yOffset or 0
	key = key or ""

	addFrameAndTex(r, color, "_PixelGlow", key, N, xOffset, yOffset, textureList.white, { 0, 1, 0, 1 }, nil, frameLevel)
	local f = r["_PixelGlow" .. key]
	if not f.masks then
		f.masks = {}
	end
	if not f.masks[1] then
		f.masks[1] = GlowMaskPool:Acquire()
		f.masks[1]:SetTexture(textureList.empty, "CLAMPTOWHITE", "CLAMPTOWHITE")
		f.masks[1]:Show()
	end
	f.masks[1]:SetPoint("TOPLEFT", f, "TOPLEFT", th, -th)
	f.masks[1]:SetPoint("BOTTOMRIGHT", f, "BOTTOMRIGHT", -th, th)

	if not (border == false) then
		if not f.masks[2] then
			f.masks[2] = GlowMaskPool:Acquire()
			f.masks[2]:SetTexture(textureList.empty, "CLAMPTOWHITE", "CLAMPTOWHITE")
		end
		f.masks[2]:SetPoint("TOPLEFT", f, "TOPLEFT", th + 1, -th - 1)
		f.masks[2]:SetPoint("BOTTOMRIGHT", f, "BOTTOMRIGHT", -th - 1, th + 1)

		if not f.bg then
			f.bg = GlowTexPool:Acquire()
			f.bg:SetColorTexture(0.1, 0.1, 0.1, 0.8)
			f.bg:SetParent(f)
			f.bg:SetAllPoints(f)
			f.bg:SetDrawLayer("ARTWORK", 6)
			f.bg:AddMaskTexture(f.masks[2])
		end
	else
		if f.bg then
			GlowTexPool:Release(f.bg)
			f.bg = nil
		end
		if f.masks[2] then
			GlowMaskPool:Release(f.masks[2])
			f.masks[2] = nil
		end
	end
	for _, tex in pairs(f.textures) do
		if tex:GetNumMaskTextures() < 1 then
			tex:AddMaskTexture(f.masks[1])
		end
	end
	f.timer = f.timer or 0
	f.info = f.info or {}
	f.info.step = 1 / N
	f.info.period = period
	f.info.th = th
	if f.info.length ~= length then
		f.info.width = nil
		f.info.length = length
	end
	pUpdate(f, 0)
	f:SetScript("OnUpdate", pUpdate)
end

function lib.PixelGlow_Stop(r, key)
	if not r then
		return
	end
	key = key or ""
	if not r["_PixelGlow" .. key] then
		return false
	else
		GlowFramePool:Release(r["_PixelGlow" .. key])
	end
end

table.insert(lib.glowList, "Pixel Glow")
lib.startList["Pixel Glow"] = lib.PixelGlow_Start
lib.stopList["Pixel Glow"] = lib.PixelGlow_Stop

local unusedOverlayGlows = {};
local numOverlays = 0;
local function ACI_ActionButton_GetOverlayGlow()
	local overlay = tremove(unusedOverlayGlows);
	if (not overlay) then
		numOverlays = numOverlays + 1;
		overlay = CreateFrame("Frame", "ACI_ActionButtonOverlay" .. numOverlays, UIParent,
			"ACI_ActionBarButtonSpellActivationAlert");
	end
	return overlay;
end

-- Shared between action button and MainMenuBarMicroButton
local function ACI_ShowOverlayGlow(button)
	if (button.overlay) then
		if (button.overlay.animOut:IsPlaying()) then
			button.overlay.animOut:Stop();
			button.overlay.animIn:Play();
		end
	else
		button.overlay = ACI_ActionButton_GetOverlayGlow();
		local frameWidth, frameHeight = button:GetSize();
		button.overlay:SetParent(button);
		button.overlay:ClearAllPoints();
		--Make the height/width available before the next frame:
		button.overlay:SetSize(frameWidth * 1.4, frameHeight * 1.4);
		button.overlay:SetPoint("TOPLEFT", button, "TOPLEFT", -frameWidth * 0.3, frameHeight * 0.3);
		button.overlay:SetPoint("BOTTOMRIGHT", button, "BOTTOMRIGHT", frameWidth * 0.3, -frameHeight * 0.3);
		button.overlay.animIn:Play();
	end
end
-- Shared between action button and MainMenuBarMicroButton
local function ACI_HideOverlayGlow(button)
	if (button.overlay) then
		if (button.overlay.animIn:IsPlaying()) then
			button.overlay.animIn:Stop();
		end
		button.overlay.animOut:OnFinished(); --We aren't shown anyway, so we'll instantly hide it.
	end
end

ACI_ActionBarButtonSpellActivationAlertMixin = {};

function ACI_ActionBarButtonSpellActivationAlertMixin:OnUpdate(elapsed)
	AnimateTexCoords(self.ants, 256, 256, 48, 48, 22, elapsed, 0.01);
	local cooldown = self:GetParent().cooldown;
	-- we need some threshold to avoid dimming the glow during the gdc
	-- (using 1500 exactly seems risky, what if casting speed is slowed or something?)
	if (cooldown and cooldown:IsShown() and cooldown:GetCooldownDuration() > 3000) then
		self:SetAlpha(0.5);
	else
		self:SetAlpha(1.0);
	end
end

function ACI_ActionBarButtonSpellActivationAlertMixin:OnHide()
	if (self.animOut:IsPlaying()) then
		self.animOut:Stop();
		self.animOut:OnFinished();
	end
end

ACI_ActionBarOverlayGlowAnimInMixin = {};

function ACI_ActionBarOverlayGlowAnimInMixin:OnPlay()
	local frame = self:GetParent();
	local frameWidth, frameHeight = frame:GetSize();
	frame.spark:SetSize(frameWidth, frameHeight);
	frame.spark:SetAlpha(0);
	frame.innerGlow:SetSize(frameWidth, frameHeight);
	frame.innerGlow:SetAlpha(1);
	frame.innerGlowOver:SetAlpha(1);
	frame.outerGlow:SetSize(frameWidth, frameHeight);
	frame.outerGlow:SetAlpha(1);
	frame.outerGlowOver:SetAlpha(1);
	frame.ants:SetSize(frameWidth * 0.8, frameHeight * 0.8)
	frame.ants:SetAlpha(0);
	frame:Show();
end

function ACI_ActionBarOverlayGlowAnimInMixin:OnFinished()
	local frame = self:GetParent();
	local frameWidth, frameHeight = frame:GetSize();
	frame.spark:SetAlpha(0);
	frame.innerGlow:SetAlpha(0);
	frame.innerGlow:SetSize(frameWidth, frameHeight);
	frame.innerGlowOver:SetAlpha(0.0);
	frame.outerGlow:SetSize(frameWidth, frameHeight);
	frame.outerGlowOver:SetAlpha(0.0);
	frame.outerGlowOver:SetSize(frameWidth, frameHeight);
	frame.ants:SetAlpha(1.0);
end

ACI_ActionBarOverlayGlowAnimOutMixin = {};

function ACI_ActionBarOverlayGlowAnimOutMixin:OnFinished()
	local overlay = self:GetParent();
	local actionButton = overlay:GetParent();
	overlay:Hide();
	tinsert(unusedOverlayGlows, overlay);
	actionButton.overlay = nil;
end

local function setupMouseOver(frame)
	frame.spellid = nil;
	frame.tooltip = nil;

	if not frame:GetScript("OnEnter") then
		frame:SetScript("OnEnter", function(s)
			if s.spellid and s.spellid > 0 then
				GameTooltip_SetDefaultAnchor(GameTooltip, s);
				GameTooltip:SetSpellByID(s.spellid);
			elseif s.tooltip then
				GameTooltip_SetDefaultAnchor(GameTooltip, s);
				GameTooltip:SetText(s.tooltip);
			end
		end)
		frame:SetScript("OnLeave", function()
			GameTooltip:Hide();
		end)
	end
end

local function getUnitBuffbyName(unit, buff, filter)
	local i = 1;
	repeat
		local name = UnitBuff(unit, i, filter);

		if name == buff then
			return UnitBuff(unit, i, filter);
		end

		i = i + 1;
	until (name == nil)

	return nil;
end


local function getUnitDebuffbyName(unit, buff, filter)
	local i = 1;
	repeat
		local name = UnitDebuff(unit, i, filter);

		if name == buff then
			return UnitDebuff(unit, i, filter);
		end

		i = i + 1;
	until (name == nil)

	return nil;
end



local function checkBuffCount(buff)
	local count = 0;

	if IsInGroup() then
		if IsInRaid() then -- raid
			for i = 1, GetNumGroupMembers() do
				local unitid = "raid" .. i
				local name = getUnitBuffbyName(unitid, buff, "PLAYER")
				if name then
					count = count + 1;
				end
			end
		else -- party
			for i = 1, GetNumSubgroupMembers() do
				local unitid = "party" .. i
				local name = getUnitBuffbyName(unitid, buff, "PLAYER")

				if name then
					count = count + 1;
				end
			end

			local name = getUnitBuffbyName("player", buff, "PLAYER")

			if name then
				count = count + 1;
			end
		end
	end

	return count;
end

local function asCooldownFrame_Clear(self)
	self:Clear();
end

local function asCooldownFrame_Set(self, start, duration, enable, forceShowDrawEdge, modRate)
	if enable and enable ~= 0 and start > 0 and duration > 0 then
		self:SetDrawEdge(forceShowDrawEdge);
		self:SetCooldown(start, duration, modRate);
	else
		asCooldownFrame_Clear(self);
	end
end

local PLAYER_UNITS = {
	player = true,
	vehicle = true,
	pet = true,
};

local prev_dire_beast_time = 0;
local prev_dire_pack_time = 0;
local dire_beast_count = 0;
local function checkDireBeast()
	local i = 1;
	local name, icon, count, debuffType, duration, expirationTime, caster, isStealable, nameplateShowPersonal, spellId;

	repeat
		name, icon, count, debuffType, duration, expirationTime, caster, isStealable, nameplateShowPersonal, spellId =
			UnitBuff("player", i, "INCLUDE_NAME_PLATE_ONLY");

		if name and spellId == 281036 and expirationTime > prev_dire_beast_time then
			dire_beast_count = dire_beast_count + 1;
			prev_dire_beast_time = expirationTime;
		elseif name and spellId == 378747 and expirationTime > prev_dire_pack_time then
			dire_beast_count = 0;
			prev_dire_pack_time = expirationTime;
		end

		i = i + 1;
	until (name == nil)

	return dire_beast_count;
end

local function ACI_Alert(self, bcastspell)
	if not self.idx then
		return;
	end

	local i = self.idx;


	if ACI_SpellList == nil or ACI_SpellList[i] == nil then
		ACI[i]:Hide();
		return;
	end

	if self.alert == nil then
		self.alert = false;
	end

	local spellname = ACI_SpellList[i][1];
	local t = ACI_SpellList[i][2];
	local icon;
	local start, duration, enable;
	local isUsable, notEnoughMana;
	local count;
	local buff_cool = false;
	local buff_miss = false;
	local debuffType = nil;
	local frameIcon;
	local frameCooldown;
	local frameCount;
	local frameBorder;
	local frame;
	local alert_count = nil;
	local charges, maxCharges, chargeStart, chargeDuration, chargeModRate, stack;
	local expirationTime;
	local caster;
	local name;
	local bspell = false;
	local not_buffed = false;

	frame = ACI[i];
	if not frame then
		return;
	end
	frameIcon = frame.icon;
	frameCooldown = frame.cooldown;
	frameCount = frame.count;
	frameBorder = frame.border;


	if t == 1 or t == 9 then
		local spell_temp;
		spell_temp, _, icon = GetSpellInfo(spellname)
		if spell_temp then
			spellname = spell_temp;
		end
		start, duration, enable                                         = GetSpellCooldown(spellname);
		local _, gcd                                                    = GetSpellCooldown(61304);
		isUsable, notEnoughMana                                         = IsUsableSpell(spellname);
		count                                                           = GetSpellCharges(spellname);
		charges, maxCharges, chargeStart, chargeDuration, chargeModRate = GetSpellCharges(spellname);

		if ACI_Action_slot_list[i] then
			start, duration, enable = GetActionCooldown(ACI_Action_slot_list[i]);
		end

		if count == 1 and (not maxCharges or maxCharges <= 1) then
			count = 0;
		end

		if not count or count == 0 then
			if ACI_Action_slot_list[i] then
				count = GetActionCount(ACI_Action_slot_list[i]);
				charges, maxCharges, chargeStart, chargeDuration, chargeModRate = GetActionCharges(ACI_Action_slot_list
					[i]);
			end
		end

		if isUsable and duration > gcd then
			isUsable = false
		end

		if (charges and maxCharges and maxCharges > 1 and charges < maxCharges) then
			start = chargeStart;
			duration = chargeDuration;
		end

		if t == 9 and ACI_SpellList[i][3] then
			if UnitHealthMax("target") > 0 and UnitHealth("target") > 0 then
				local health = UnitHealth("target") / UnitHealthMax("target") * 100

				if health <= ACI_SpellList[i][3] then
					ACI_Alert_list[spellname] = true;
				else
					ACI_Alert_list[spellname] = false;
					isUsable = false;
				end
			else
				ACI_Alert_list[spellname] = false;
				isUsable = false;
			end
		elseif t == 1 and ACI_SpellList[i][3] then
			if isUsable or notEnoughMana then
				ACI_Alert_list[spellname] = true;
			else
				ACI_Alert_list[spellname] = false;
			end
		else
			ACI_Alert_list[spellname] = false;
		end

		-- 우박폭풍
		if t == 1 and spellname == "냉기 충격" then
			_, _, count = getUnitBuffbyName("player", "우박폭풍");
			if count == nil then
				count = 0;
			end
		end

		bspell = true;
	elseif t == 2 or t == 3 or t == 5 or t == 6 or t == 7 or t == 12 then
		local unit = ACI_SpellList[i][3];
		if unit == nil then
			unit = "player"
		end

		alert_count = ACI_SpellList[i][5];

		ACI_Alert_list[spellname] = false;

		local alert_du = ACI_SpellList[i][4];
		local buff_name = GetSpellInfo(spellname);
		
		if not buff_name then
			buff_name = spellname
		end

		if ACI_SpellList[i][7] then
			buff_name = ACI_SpellList[i][7];			
		end

		_, icon, count, _, duration, expirationTime, _, _, _, _, _, _, _, _, _, stack = getUnitBuffbyName(unit,
			buff_name);

		if icon then
			start = expirationTime - duration;
			isUsable = true
			enable = 1

			if count <= 1 then
				count = GetSpellCharges(spellname);
				charges, maxCharges, chargeStart, chargeDuration, chargeModRate = GetSpellCharges(spellname);

				if count == 1 and (not maxCharges or maxCharges <= 1) then
					count = 0;
				end
			end
			buff_cool = true;

			self.exTime = nil;

			if alert_du == 1 then
				alert_du = duration * 0.3;
				ACI_SpellList[i][4] = alert_du;
			end

			if alert_du and (expirationTime - GetTime()) <= alert_du then
				ACI_Alert_list[spellname] = true;
			elseif alert_du then
				self.exTime = expirationTime - alert_du;
			end
		else
			_, _, icon                                                      = GetSpellInfo(spellname)
			start, duration, enable                                         = GetSpellCooldown(spellname);
			isUsable, notEnoughMana                                         = IsUsableSpell(spellname);
			count                                                           = GetSpellCharges(spellname);
			charges, maxCharges, chargeStart, chargeDuration, chargeModRate = GetSpellCharges(spellname);
			local _, gcd                                                    = GetSpellCooldown(61304);

			if count == 1 and (not maxCharges or maxCharges <= 1) then
				count = 0;
			end

			if not count or count == 0 then
				if ACI_Action_slot_list[i] then
					count = GetActionCount(ACI_Action_slot_list[i]);
					charges, maxCharges, chargeStart, chargeDuration, chargeModRate = GetActionCharges(
						ACI_Action_slot_list[i]);
				end
			end

			if isUsable and duration > gcd then
				isUsable = false
			end

			if (charges and maxCharges and maxCharges > 1 and charges < maxCharges) then
				start = chargeStart;
				duration = chargeDuration;
			end
		end

		if t == 3 or t == 12 then
			if stack and stack > 1000 then
				count = (math.ceil((stack / UnitHealthMax("player")) * 100));
			else
				count = stack;
			end
		end

		if t == 5 then
			count = ACI_Current_Count;
		end

		-- 광포한 무리
		if t == 7 and spellname == 378745 then
			count = checkDireBeast()
		end

		-- 태양왕
		if t == 7 and spellname == 383883 then
			_, _, count = getUnitBuffbyName(unit, "태양왕의 축복");
			if count == nil then
				count = 0;
			end
		end
	elseif t == 4 or t == 8 then
		local unit = ACI_SpellList[i][3];
		if unit == nil then
			unit = "target"
		end

		local filter = nil;

		if unit == "target" then
			filter = "PLAYER"
		end


		local buff_name = GetSpellInfo(spellname);

		ACI_Alert_list[spellname] = false;
		local alert_du = ACI_SpellList[i][4];

		alert_count = ACI_SpellList[i][5];

		if ACI_SpellList[i][6] then
			buff_name = ACI_SpellList[i][6];
		end

		if not buff_name then
			buff_name = spellname
		end

		_, icon, count, debuffType, duration, expirationTime, caster, _, _, _, _, _, _, _, _, stack =
			getUnitDebuffbyName(unit, buff_name, filter);

		if (not (unit == "player")) and not PLAYER_UNITS[caster] then
			icon = nil;
		end

		if icon then
			start = expirationTime - duration;
			isUsable = 1
			enable = 1

			if count <= 1 then
				count = GetSpellCharges(spellname);

				charges, maxCharges, chargeStart, chargeDuration, chargeModRate = GetSpellCharges(spellname);

				if count == 1 and (not maxCharges or maxCharges <= 1) then
					count = 0;
				end
			end
			buff_cool = true;

			self.exTime = nil;

			if alert_du == 1 then
				alert_du = duration * 0.3;
				ACI_SpellList[i][4] = alert_du;
			end

			if alert_du and (expirationTime - GetTime()) <= alert_du and duration > 0 then
				ACI_Alert_list[spellname] = true;
			elseif alert_du then
				self.exTime = expirationTime - alert_du;
			end
		else
			_, _, icon                                                      = GetSpellInfo(spellname)
			start, duration, enable                                         = GetSpellCooldown(spellname);
			isUsable, notEnoughMana                                         = IsUsableSpell(spellname);
			count                                                           = GetSpellCharges(spellname);
			charges, maxCharges, chargeStart, chargeDuration, chargeModRate = GetSpellCharges(spellname);
			local _, gcd                                                    = GetSpellCooldown(61304);

			if  ACI_Action_slot_list[i] then
				start, duration, enable = GetActionCooldown(ACI_Action_slot_list[i]);
			end

			if count == 1 and (not maxCharges or maxCharges <= 1) then
				count = 0;
			end

			if not count or count == 0 then
				if ACI_Action_slot_list[i] then
					count = GetActionCount(ACI_Action_slot_list[i]);
					charges, maxCharges, chargeStart, chargeDuration, chargeModRate = GetActionCharges(
						ACI_Action_slot_list[i]);
				end
			end

			if isUsable and duration > gcd then
				isUsable = false
			end

			if (charges and maxCharges and maxCharges > 1 and charges < maxCharges) then
				start = chargeStart;
				duration = chargeDuration;
			end
		end
	elseif t == 11 then
		isUsable = false;

		local slot_name = ACI_SpellList[i][3];
		local check_buff = ACI_SpellList[i][4];

		if slot_name == nil then
			slot_name = spellname;
		end


		if check_buff == nil then
			check_buff = true;
		end

		for slot = 1, MAX_TOTEMS do
			local haveTotem;
			haveTotem, name, start, duration, icon = GetTotemInfo(slot);

			if name == slot_name then
				buff_cool = true;
				isUsable = true;
				enable = 1;
				count = 0;

				if check_buff then
					local hasbuff = getUnitBuffbyName("player", slot_name);

					if not hasbuff then
						buff_miss = true;
					end
				end

				break;
			end
		end

		if isUsable == false then
			_, _, icon              = GetSpellInfo(spellname)
			start, duration, enable = GetSpellCooldown(spellname);
			isUsable, notEnoughMana = IsUsableSpell(spellname);
			count                   = GetSpellCharges(spellname);
			local _, gcd            = GetSpellCooldown(61304);
			

			charges, maxCharges, chargeStart, chargeDuration, chargeModRate = GetSpellCharges(spellname);

			if ACI_Action_slot_list[i] then
				start, duration, enable = GetActionCooldown(ACI_Action_slot_list[i]);
			end

			if count == 1 and (not maxCharges or maxCharges <= 1) then
				count = 0;
			end

			if isUsable and duration > gcd then
				isUsable = false
			end


			if not count or count == 0 then
				if ACI_Action_slot_list[i] then
					count = GetActionCount(ACI_Action_slot_list[i]);
					charges, maxCharges, chargeStart, chargeDuration, chargeModRate = GetActionCharges(
						ACI_Action_slot_list[i]);
				end
			end

			if (charges and maxCharges and maxCharges > 1 and charges < maxCharges) then
				start = chargeStart;
				duration = chargeDuration;
			end
		end
	elseif t == 14 then
		spellname = 193316;

		local idx;

		_, _, icon = GetSpellInfo(spellname);
		duration = 0;
		start = 0;
		isUsable = false
		enable = 0
		count = 0;
		for _, buffname in ipairs(roguespell) do
			local texture;
			local temp_du;
			local temp_ex;

			name, texture, _, _, temp_du, temp_ex = getUnitBuffbyName("player", buffname, "PLAYER");

			if name then
				count = count + 1;
				icon = texture;
				duration = temp_du;
				start = temp_ex - duration;
				isUsable = 1
				enable = 1
				buff_cool = true;
			end
		end

		if count > 2 then
			ACI_Alert_list[spellname] = true;
		else
			ACI_Alert_list[spellname] = false;
		end

		if isUsable == false then
			spellname, _, icon      = GetSpellInfo(spellname)

			start, duration, enable = GetSpellCooldown(spellname);
			isUsable, notEnoughMana = IsUsableSpell(spellname);
			count                   = GetSpellCharges(spellname);
			local _, gcd            = GetSpellCooldown(61304);


			charges, maxCharges, chargeStart, chargeDuration, chargeModRate = GetSpellCharges(spellname);

			if ACI_Action_slot_list[i] then
				start, duration, enable = GetActionCooldown(ACI_Action_slot_list[i]);
			end

			if count == 1 and (not maxCharges or maxCharges <= 1) then
				count = 0;
			end

			if isUsable and duration > gcd then
				isUsable = false
			end

			if not count or count == 0 then
				if ACI_Action_slot_list[i] then
					count = GetActionCount(ACI_Action_slot_list[i]);
					charges, maxCharges, chargeStart, chargeDuration, chargeModRate = GetActionCharges(
						ACI_Action_slot_list[i]);
				end
			end

			if (charges and maxCharges and maxCharges > 1 and charges < maxCharges) then
				start = chargeStart;
				duration = chargeDuration;
			end
		end
	end

	ACI_SpellID_list[spellname] = true;

	if icon == nil then
		--	frame:Hide();
		frameBorder:Hide();
		frameIcon:SetDesaturated(true)
		frameCooldown:Hide();
		frameCount:Hide();


		return;
	else
		frame:Show();
	end

	local skip = false
	frameIcon:SetAlpha(1);

	if (isUsable) then
		frameIcon:SetDesaturated(false);
		frameIcon:SetVertexColor(1.0, 1.0, 1.0);


		if t >= 2 and t ~= 9 then
			if buff_cool then
				frameIcon:SetVertexColor(1.0, 1.0, 1.0);

				if t == 3 and count == 0 then
					frameIcon:SetDesaturated(true)
				end
			else
				if frame.inRange == false then
					frameIcon:SetVertexColor(0.3, 0, 0);
				else
					frameIcon:SetVertexColor(0.5, 0.5, 0.5);
				end

				if t == 6 or t == 2 or t == 4 or t == 11 or t == 14 then
					frameIcon:SetDesaturated(false)
				else
					frameIcon:SetDesaturated(true)
				end
			end
		end


		if (t == 1 or t == 9 or t == 11) and frame.inRange == false then
			frameIcon:SetVertexColor(0.3, 0, 0);
		end

		if t == 5 and count == 0 then
			frameIcon:SetDesaturated(true)
		end
	elseif (notEnoughMana) then
		frameIcon:SetVertexColor(0.5, 0.5, 1);
		frameIcon:SetDesaturated(true)
	else
		frameIcon:SetVertexColor(0.5, 0.5, 0.5);
		frameIcon:SetDesaturated(true)
	end



	if (buff_cool) then
		local color;

		if debuffType then
			color = DebuffTypeColor[debuffType];
		elseif buff_miss then
			color = { r = 1.0, g = 0, b = 0 };
		else
			if t == 4 or t == 8 then
				color = DebuffTypeColor["none"];
			else
				color = DebuffTypeColor["Disease"];
			end
		end
		frameBorder:SetVertexColor(color.r, color.g, color.b);
		frameBorder:SetAlpha(1);
		frameBorder:Show();
	else
		frameBorder:SetVertexColor(0, 0, 0);
		frameBorder:Show();
	end

	if alert_count and count and count >= alert_count then
		ACI_Alert_list[spellname] = true;
	end


	if ACI_Active_list[spellname] or ACI_Alert_list[spellname] then
		if self.alert == false then
			lib.PixelGlow_Start(frame);
		end
		self.alert = true;
	else
		if self.alert == true then
			lib.PixelGlow_Stop(frame)
		end
		self.alert = false;
	end


	frameIcon:SetTexture(icon);

	if (duration ~= nil and duration > 0 and duration < 500) then
		-- set the count
		asCooldownFrame_Set(frameCooldown, start, duration, duration > 0, enable);
		frameCooldown:SetDrawSwipe(false);
		frameCooldown:Show();
		frameCooldown:SetHideCountdownNumbers(false);
		if bspell then
			frameCooldown:SetReverse(false);
		else
			frameCooldown:SetReverse(true);
		end
	else
		frameCooldown:Hide();
	end

	if (count and count > 0) then
		if (count > 999999) then
			count = math.ceil(count / 1000000) .. "m"
		elseif (count > 999) then
			count = math.ceil(count / 1000) .. "k"
		end

		if frame.cooldownfont then
			frame.cooldownfont:ClearAllPoints();
			frame.cooldownfont:SetPoint("TOPLEFT", 4, -4);
			frameCooldown:SetDrawSwipe(false);
		end

		frameCount:SetText(count)
		frameCount:Show();
	else
		if frame.cooldownfont then
			frame.cooldownfont:ClearAllPoints();
			frame.cooldownfont:SetPoint("CENTER", 0, 0);
			frameCooldown:SetDrawSwipe(true);
		end

		frameCount:Hide();
	end

	return;
end

local function ACI_OnUpdate()
	for i = 1, ACI_mainframe.maxIdx do
		if ACI[i].updateaura then
			ACI_Alert(ACI[i]);
		end
	end
end

local function ACI_ButtonOnEvent(self, event, arg1, ...)
	if (event == "PLAYER_TARGET_CHANGED") then
		if self.unit then
			if UnitHealthMax(self.unit) > 0 then
				local health = UnitHealth(self.unit) / UnitHealthMax(self.unit) * 100

				if self.health and self.health >= health then
					self.checkhealth = true;
				else
					self.checkhealth = false;
				end
			end
		end

		ACI_Alert(self);
	elseif (event == "UNIT_AURA" and arg1 == self.unit) then
		ACI_Alert(self);
	elseif event == "ACTIONBAR_UPDATE_COOLDOWN" then
		ACI_Alert(self);
	elseif event == "ACTIONBAR_UPDATE_USABLE" then
		ACI_Alert(self);
	elseif event == "SPELL_UPDATE_CHARGES" then
		ACI_Alert(self);
	elseif event == "UNIT_SPELLCAST_SUCCEEDED" then
		_, cast_spell = ...;
		cast_time = GetTime();
		ACI_Alert(self, true);
	elseif event == "PLAYER_TOTEM_UPDATE" then
		ACI_Alert(self);
	elseif event == "UNIT_HEALTH" and arg1 == self.unit then
		local health = UnitHealth(self.unit) / UnitHealthMax(self.unit) * 100

		if self.health >= health then
			if (self.checkhealth == false) then
				self.checkhealth = true;
				ACI_Alert(self);
			end
		else
			self.checkhealth = false;
		end
	end
end


local bfirst = false;
local event_frames = {}
event_frames["PLAYER_TARGET_CHANGED"] = {};
event_frames["UNIT_AURA"] = {};
event_frames["ACTIONBAR_UPDATE_COOLDOWN"] = {};
event_frames["ACTIONBAR_UPDATE_USABLE"] = {};
event_frames["SPELL_UPDATE_CHARGES"] = {};
event_frames["UNIT_SPELLCAST_SUCCEEDED"] = {};
event_frames["PLAYER_TOTEM_UPDATE"] = {};
event_frames["UNIT_HEALTH"] = {};


local function EventsFrame_RegisterFrame(event, frame)
	tinsert(event_frames[event], frame);
end



local function ACI_OnEvent(self, event, arg1, ...)
	if event_frames[event] and #event_frames[event] > 0 then
		for k, frame in pairs(event_frames[event]) do
			ACI_ButtonOnEvent(frame, event, arg1, ...);
		end
		return;
	end


	if event == "PLAYER_ENTERING_WORLD" then
		ACI_Init();
		bfirst = true;
		if UnitAffectingCombat("player") then
			for i = 1, ACI_MaxSpellCount do
				ACI[i]:SetAlpha(ACI_Alpha);
			end
		else
			for i = 1, ACI_MaxSpellCount do
				ACI[i]:SetAlpha(ACI_Alpha_Normal);
			end
		end
	elseif event == "PLAYER_REGEN_DISABLED" then
		for i = 1, ACI_MaxSpellCount do
			ACI[i]:SetAlpha(ACI_Alpha);
		end
	elseif event == "PLAYER_REGEN_ENABLED" then
		for i = 1, ACI_MaxSpellCount do
			ACI[i]:SetAlpha(ACI_Alpha_Normal);
		end
	elseif event == "UNIT_ENTERING_VEHICLE" then
		for i = 1, ACI_MaxSpellCount do
			ACI[i]:SetAlpha(0);
		end
	elseif event == "UNIT_EXITING_VEHICLE" then
		if UnitAffectingCombat("player") then
			for i = 1, ACI_MaxSpellCount do
				ACI[i]:SetAlpha(ACI_Alpha);
			end
		else
			for i = 1, ACI_MaxSpellCount do
				ACI[i]:SetAlpha(ACI_Alpha_Normal);
			end
		end
	elseif event == "TRAIT_CONFIG_UPDATED" or event == "TRAIT_CONFIG_LIST_UPDATED" or event == "ACTIVE_TALENT_GROUP_CHANGED" then
		C_Timer.After(0.5, ACI_Init);
		bfirst = true;
	elseif event == "ACTIONBAR_SLOT_CHANGED" and bfirst then
		C_Timer.After(0.5, ACI_Init);
		bfirst = false;
	elseif event == "SPELL_ACTIVATION_OVERLAY_GLOW_SHOW" then
		local spell = GetSpellInfo(arg1);
		ACI_Active_list[spell] = true;
		ACI_Active_list[arg1] = true;
		if ACI_Cool_list and ACI_Cool_list[spell] then
			ACI_Alert(ACI[ACI_Cool_list[spell]]);
		end
	elseif event == "SPELL_ACTIVATION_OVERLAY_GLOW_HIDE" then
		local spell = GetSpellInfo(arg1);
		ACI_Active_list[spell] = false;
		ACI_Active_list[arg1] = false;
		if ACI_Cool_list and ACI_Cool_list[spell] then
			ACI_Alert(ACI[ACI_Cool_list[spell]]);
		end
	elseif event == "ACTION_RANGE_CHECK_UPDATE" then
		local action, inRange, checksRange = arg1, ...;

		if ACI_Action_to_index[action] then
			local index = ACI_Action_to_index[action];
			if ACI[index] then
				if ( checksRange and not inRange ) then
					ACI[index].inRange = false;
				else
					ACI[index].inRange = true
				end
				ACI_Alert(ACI[index]);
			end
		end
	end
	return;
end

local function ACI_GetActionSlot(arg1)
	for lActionSlot = 1, 180 do
		local type, id, subType, spellID = GetActionInfo(lActionSlot);

		if id and type and type == "macro" then
			id = GetMacroSpell(id);
		end

		if id then
			local name = GetSpellInfo(id);


			if name and name == arg1 then
				return lActionSlot;
			end
		end
	end

	return nil;
end

-- 용군단 Talent Check 함수
local function asCheckTalent(name)
	local specID = PlayerUtil.GetCurrentSpecID();
	local configID = C_ClassTalents.GetActiveConfigID();
	if not (configID) then
		return false;
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
				--print(string.format("%s %d/%d", talentName, nodeInfo.currentRank, nodeInfo.maxRanks));;
				if name == talentName then
					return true;
				end
			end
		end
	end
	return false;
end


local ACI_Spec = nil;
local ACI_timer = nil;

ACI_HideCooldownPulse = false;

function ACI_Init()
	local localizedClass, englishClass = UnitClass("player")
	local spec = GetSpecialization();
	local talentgroup = GetActiveSpecGroup();
	local specID = PlayerUtil.GetCurrentSpecID();
	local configID = (C_ClassTalents.GetLastSelectedSavedConfigID(specID) or 0) + 19;
	local listname = "ACI_SpellList";


	if spec == nil then
		spec = 1;
	end

	ACI_mainframe.update = 0;

	if ACI_timer then
		ACI_timer:Cancel();
	end
	--버튼
	ACI_SpellList = {};


	if spec and configID then
		listname = "ACI_SpellList" .. "_" .. englishClass .. "_" .. spec;
		if options[spec] and options[spec][configID] then
			ACI_SpellListtmp = CopyTable(options[spec][configID]);
		else
			if ACI_Options_Default[listname] then
				ACI_SpellListtmp = CopyTable(ACI_Options_Default[listname]);
			else
				ACI_SpellListtmp = {};
			end
		end
	else
		ACI_SpellListtmp = {};
	end

	ACI_SpellList = nil;

	ACI_Cool_list = {}
	ACI_Buff_list = {}
	ACI_Debuff_list = {}
	ACI_SpellID_list = {}
	ACI_Player_Debuff_list = {}
	ACI_Action_slot_list = {};
	ACI_Action_to_index = {};


	if ACI_SpellListtmp and #ACI_SpellListtmp then
		ACI_SpellList = {}

		for i = 1, #ACI_SpellListtmp do
			local value1 = ACI_SpellListtmp[i][1];
			local value2 = ACI_SpellListtmp[i][2];
			local value3 = ACI_SpellListtmp[i][3];
			local value4 = ACI_SpellListtmp[i][4];
			local value5 = ACI_SpellListtmp[i][5];
			local value6 = ACI_SpellListtmp[i][6];
			local value7 = ACI_SpellListtmp[i][7];
			local value8 = ACI_SpellListtmp[i][8];
			local value9 = ACI_SpellListtmp[i][9];
			local value10 = ACI_SpellListtmp[i][10];

			ACI_SpellList[i] = { value1, value2, value3, value4, value5, value6, value7, value8, value9, value10 };
		end
	end

	if #ACI_SpellList >= 6 then
		-- asCooldownPulse 를 숨긴다.
		ACI_HideCooldownPulse = true;
	end

	event_frames["PLAYER_TARGET_CHANGED"] = {};
	event_frames["UNIT_AURA"] = {};
	event_frames["ACTIONBAR_UPDATE_COOLDOWN"] = {};
	event_frames["ACTIONBAR_UPDATE_USABLE"] = {};
	event_frames["SPELL_UPDATE_CHARGES"] = {};
	event_frames["UNIT_SPELLCAST_SUCCEEDED"] = {};
	event_frames["PLAYER_TOTEM_UPDATE"] = {};
	event_frames["UNIT_HEALTH"] = {};

	for i = 1, ACI_MaxSpellCount do
		ACI[i].update = 0;
		ACI[i]:Hide();
		--ACI_Alert(ACI[i]);
		setupMouseOver(ACI[i]);
	end

	if (ACI_SpellList and #ACI_SpellList) then
		if ACI_Spec == nil and ACI_Spec ~= spec then
			--	ChatFrame1:AddMessage("[ACI] ".. listname .. "을 Load 합니다.");
			ACI_Spec = spec;
		end

		local maxIdx = #ACI_SpellList;

		if maxIdx > ACI_MaxSpellCount then
			maxIdx = ACI_MaxSpellCount;
		end

		ACI_mainframe.maxIdx = maxIdx;

		for i = 1, maxIdx do
			--ACI_Action_slot_list[i] = ACI_GetActionSlot(ACI_SpellList[i][2]);

			local check = tonumber(ACI_SpellList[i][1]);

			if check and check == 99 then
				local bselected = false;
				local spell_name = ACI_SpellList[i][2];
				if asCheckTalent(spell_name) then
					if ACI_SpellList[i][3] then
						local array = ACI_SpellList[i][3];
						if type(array) == "table" then
							ACI_SpellList[i][3] = nil;
							ACI_SpellList[i][4] = nil;

							for z, v in pairs(array) do
								ACI_SpellList[i][z] = v;
							end
						end
					end
				else
					if ACI_SpellList[i][4] then
						local array = ACI_SpellList[i][4];
						if type(array) == "table" then
							ACI_SpellList[i][3] = nil;
							ACI_SpellList[i][4] = nil;

							for z, v in pairs(array) do
								ACI_SpellList[i][z] = v;
							end
						end
					end
				end
			end


			if ACI_SpellList[i][2] == 1 or ACI_SpellList[i][2] == 9 then
				ACI_Cool_list[ACI_SpellList[i][1]] = i;
				local id = select(7, GetSpellInfo(ACI_SpellList[i][1]));

				ACI_Action_slot_list[i] = ACI_GetActionSlot(ACI_SpellList[i][1]);
				if ACI_Action_slot_list[i] then
					ACI_Action_to_index[ACI_Action_slot_list[i]] = i;
				end

				if id then
					ACI_SpellID_list[id] = true;
				end
			elseif ACI_SpellList[i][2] == 2 or ACI_SpellList[i][2] == 3 or ACI_SpellList[i][2] == 5 or ACI_SpellList[i][2] == 6 then
				ACI_Action_slot_list[i] = ACI_GetActionSlot(ACI_SpellList[i][1]);
				if ACI_Action_slot_list[i] then
					ACI_Action_to_index[ACI_Action_slot_list[i]] = i;
				end

				local name = GetSpellInfo(ACI_SpellList[i][1]);

				if name then
					ACI_Buff_list[name] = i;
				else
					ACI_Buff_list[ACI_SpellList[i][1]] = i;
				end


				local id = select(7, GetSpellInfo(ACI_SpellList[i][1]));
				if id then
					ACI_SpellID_list[id] = true;
				end
			elseif ACI_SpellList[i][2] == 4 then
				local name = GetSpellInfo(ACI_SpellList[i][1]);
				if ACI_SpellList[i][6] then
					ACI_Debuff_list[ACI_SpellList[i][6]] = i;
				elseif name then
					ACI_Debuff_list[name] = i;
				else
					ACI_Debuff_list[ACI_SpellList[i][1]] = i;
				end

				local id = select(7, GetSpellInfo(ACI_SpellList[i][1]));

				ACI_Action_slot_list[i] = ACI_GetActionSlot(ACI_SpellList[i][1]);
				if ACI_Action_slot_list[i] then
					ACI_Action_to_index[ACI_Action_slot_list[i]] = i;
				end

				if id then
					ACI_SpellID_list[id] = true;
				end

				if ACI_SpellList[i][3] and ACI_SpellList[i][3] == "player" then
					ACI_Player_Debuff_list[ACI_SpellList[i][1]] = i;
				end
			elseif ACI_SpellList[i][2] == 7 or ACI_SpellList[i][2] == 12 then
				local name = GetSpellInfo(ACI_SpellList[i][1]);

				ACI_Action_slot_list[i] = ACI_GetActionSlot(name);

				if name then
					ACI_Buff_list[name] = i;
				end
				ACI_SpellID_list[ACI_SpellList[i][1]] = true;
			elseif ACI_SpellList[i][2] == 8 then
				local name = GetSpellInfo(ACI_SpellList[i][1]);

				ACI_Action_slot_list[i] = ACI_GetActionSlot(name);

				if name then
					ACI_Debuff_list[name] = i;
				end
				ACI_SpellID_list[ACI_SpellList[i][1]] = true;

				if name and ACI_SpellList[i][3] and ACI_SpellList[i][3] == "player" then
					ACI_Player_Debuff_list[name] = i;
				end
			elseif ACI_SpellList[i][2] == 14 then
				ACI_Action_slot_list[i] = ACI_GetActionSlot(ACI_SpellList[i][1]);
				if ACI_Action_slot_list[i] then
					ACI_Action_to_index[ACI_Action_slot_list[i]] = i;
				end
			elseif ACI_SpellList[i][2] == 11 then
				local slot_name = ACI_SpellList[i][3];

				if slot_name == nil then
					ACI_Buff_list[ACI_SpellList[i][1]] = true;
				else
					ACI_Buff_list[slot_name] = true;
				end


				ACI_SpellID_list[ACI_SpellList[i][1]] = true;
			end
			ACI[i].idx = i;

			ACI_Alert(ACI[i]);


			ACI[i].update = 0;
			ACI[i].updateaura = true;

			ACI[i].tooltip = (ACI_SpellList[i][1]);
			ACI[i].spellid = tonumber(ACI_SpellList[i][1]);
			ACI[i].inRange = true;




			local t = ACI_SpellList[i][2];

			if t == 4 or t == 8 then
				ACI[i].unit = ACI_SpellList[i][3];
				if ACI[i].unit == nil then
					ACI[i].unit = "target"
				end

				if ACI[i].unit == "player" then
					EventsFrame_RegisterFrame("UNIT_AURA", ACI[i]);
				else
					ACI[i].updateaura = true;
				end

				if ACI[i].unit == "target" then
					EventsFrame_RegisterFrame("PLAYER_TARGET_CHANGED", ACI[i]);
				end

				EventsFrame_RegisterFrame("ACTIONBAR_UPDATE_USABLE", ACI[i]);
				EventsFrame_RegisterFrame("ACTIONBAR_UPDATE_COOLDOWN", ACI[i]);
				EventsFrame_RegisterFrame("SPELL_UPDATE_CHARGES", ACI[i]);
				EventsFrame_RegisterFrame("UNIT_SPELLCAST_SUCCEEDED", ACI[i]);
			elseif t == 2 or t == 3 or t == 5 or t == 6 or t == 7 then
				ACI[i].unit = ACI_SpellList[i][3];
				if ACI[i].unit == nil then
					ACI[i].unit = "player"
				end

				if ACI[i].unit == "player" then
					EventsFrame_RegisterFrame("UNIT_AURA", ACI[i]);
				else
					ACI[i].updateaura = true;
				end

				if ACI[i].unit == "target" then
					EventsFrame_RegisterFrame("PLAYER_TARGET_CHANGED", ACI[i]);
				end

				if t == 2 or t == 6 then
					EventsFrame_RegisterFrame("ACTIONBAR_UPDATE_USABLE", ACI[i]);
					EventsFrame_RegisterFrame("ACTIONBAR_UPDATE_COOLDOWN", ACI[i]);
					EventsFrame_RegisterFrame("SPELL_UPDATE_CHARGES", ACI[i]);
					EventsFrame_RegisterFrame("UNIT_SPELLCAST_SUCCEEDED", ACI[i]);
				end
			elseif t == 11 then
				EventsFrame_RegisterFrame("PLAYER_TOTEM_UPDATE", ACI[i]);
				EventsFrame_RegisterFrame("ACTIONBAR_UPDATE_USABLE", ACI[i]);
				EventsFrame_RegisterFrame("ACTIONBAR_UPDATE_COOLDOWN", ACI[i]);
				EventsFrame_RegisterFrame("SPELL_UPDATE_CHARGES", ACI[i]);
				EventsFrame_RegisterFrame("UNIT_SPELLCAST_SUCCEEDED", ACI[i]);
			elseif t == 15 then
				EventsFrame_RegisterFrame("PLAYER_TOTEM_UPDATE", ACI[i]);
				EventsFrame_RegisterFrame("ACTIONBAR_UPDATE_USABLE", ACI[i]);
				EventsFrame_RegisterFrame("ACTIONBAR_UPDATE_COOLDOWN", ACI[i]);
				EventsFrame_RegisterFrame("SPELL_UPDATE_CHARGES", ACI[i]);
				EventsFrame_RegisterFrame("UNIT_SPELLCAST_SUCCEEDED", ACI[i]);
				ACI[i].updateaura = true;
			else
				EventsFrame_RegisterFrame("ACTIONBAR_UPDATE_USABLE", ACI[i]);
				EventsFrame_RegisterFrame("ACTIONBAR_UPDATE_COOLDOWN", ACI[i]);
				EventsFrame_RegisterFrame("SPELL_UPDATE_CHARGES", ACI[i]);
				EventsFrame_RegisterFrame("UNIT_SPELLCAST_SUCCEEDED", ACI[i]);


				if t == 9 and ACI_SpellList[i][3] then
					ACI[i].unit = "target";
					ACI[i].health = ACI_SpellList[i][3];
					EventsFrame_RegisterFrame("PLAYER_TARGET_CHANGED", ACI[i]);
					ACI[i].updateaura = true;
				end
			end
		end

		ACI_Timer = C_Timer.NewTicker(0.2, ACI_OnUpdate);

		local bload = LoadAddOn("asCooldownPulse")

		if bload and #ACI_SpellList > 5 and ACDP_Show_CoolList == true then
			ACDP_Show_CoolList = false;
		end
	end

	ACI_OptionM.UpdateSpellList(ACI_SpellList);

	return;
end

local function flushoption()
	if ACI_Options then
		options = CopyTable(ACI_Options);
		ACI_Init();
		ACI_OptionM.UpdateSpellList(ACI_SpellList);
	end
end


ACI_mainframe = CreateFrame("Frame", nil, UIParent);
ACI_mainframe:SetScript("OnEvent", ACI_OnEvent);
ACI_mainframe:RegisterEvent("PLAYER_ENTERING_WORLD");
ACI_mainframe:RegisterEvent("TRAIT_CONFIG_UPDATED");
ACI_mainframe:RegisterEvent("TRAIT_CONFIG_LIST_UPDATED");
ACI_mainframe:RegisterEvent("ACTIVE_TALENT_GROUP_CHANGED");
ACI_mainframe:RegisterEvent("PLAYER_REGEN_DISABLED");
ACI_mainframe:RegisterEvent("PLAYER_REGEN_ENABLED");
ACI_mainframe:RegisterEvent("VARIABLES_LOADED");
ACI_mainframe:RegisterEvent("SPELL_ACTIVATION_OVERLAY_GLOW_SHOW")
ACI_mainframe:RegisterEvent("SPELL_ACTIVATION_OVERLAY_GLOW_HIDE")
ACI_mainframe:RegisterEvent("ACTIONBAR_SLOT_CHANGED")
ACI_mainframe:RegisterUnitEvent("UNIT_ENTERING_VEHICLE", "player")
ACI_mainframe:RegisterUnitEvent("UNIT_EXITING_VEHICLE", "player")
ACI_mainframe:RegisterUnitEvent("UNIT_AURA", "player", "pet");
ACI_mainframe:RegisterUnitEvent("UNIT_SPELLCAST_SUCCEEDED", "player", "pet");

ACI_mainframe:RegisterEvent("ACTIONBAR_UPDATE_USABLE");
ACI_mainframe:RegisterEvent("ACTIONBAR_UPDATE_COOLDOWN");
ACI_mainframe:RegisterEvent("SPELL_UPDATE_CHARGES");
ACI_mainframe:RegisterEvent("PLAYER_TOTEM_UPDATE");
ACI_mainframe:RegisterEvent("PLAYER_TARGET_CHANGED");
ACI_mainframe:RegisterEvent("ACTION_RANGE_CHECK_UPDATE");


for i = 1, 5 do
	ACI[i] = CreateFrame("Button", nil, UIParent, "asCombatInfoFrameTemplate");
	ACI[i]:SetWidth(ACI_SIZE);
	ACI[i]:SetHeight(ACI_SIZE * 0.9);
	ACI[i]:SetScale(1);
	ACI[i]:SetAlpha(ACI_Alpha);
	ACI[i]:EnableMouse(false);
	ACI[i]:Hide();

	setupMouseOver(ACI[i])
end

for i = 1, 5 do
	if i == 3 then
		ACI[i]:SetPoint("CENTER", ACI_CoolButtons_X, ACI_CoolButtons_Y)
	elseif i < 3 then
		ACI[i]:SetPoint("RIGHT", ACI[i + 1], "LEFT", -1, 0);
	elseif i > 3 then
		ACI[i]:SetPoint("LEFT", ACI[i - 1], "RIGHT", 1, 0);
	end
end


for i = 6, 11 do
	ACI[i] = CreateFrame("Button", nil, UIParent, "asCombatInfoFrameTemplate");

	ACI[i]:SetWidth(ACI_SIZE - 8);
	ACI[i]:SetHeight((ACI_SIZE - 8) * 0.9);
	ACI[i]:SetScale(1);
	ACI[i]:SetAlpha(ACI_Alpha);
	ACI[i]:EnableMouse(false);
	ACI[i]:Hide();
end

for i = 6, 11 do
	if i == 8 then
		ACI[i]:SetPoint("TOPRIGHT", ACI[i - 5], "BOTTOM", -0.5, -1);
	elseif i == 9 then
		ACI[i]:SetPoint("TOPLEFT", ACI[i - 6], "BOTTOM", 0.5, -1);
	elseif i < 8 then
		ACI[i]:SetPoint("RIGHT", ACI[i + 1], "LEFT", -1, 0);
	elseif i > 9 then
		ACI[i]:SetPoint("LEFT", ACI[i - 1], "RIGHT", 1, 0);
	end
end

for i = 1, ACI_MaxSpellCount do
	for _, r in next, { ACI[i].cooldown:GetRegions() } do
		if r:GetObjectType() == "FontString" then
			if i < 6 then
				r:SetFont("Fonts\\2002.TTF", ACI_CooldownFontSize, "OUTLINE")
			else
				r:SetFont("Fonts\\2002.TTF", ACI_CooldownFontSize - 2, "OUTLINE")
			end

			ACI[i].cooldownfont = r;
			break
		end
	end


	if i < 6 then
		ACI[i].count:SetFont("Fonts\\2002.TTF", ACI_CountFontSize, "OUTLINE")
	else
		ACI[i].count:SetFont("Fonts\\2002.TTF", ACI_CountFontSize - 2, "OUTLINE")
	end

	ACI[i].count:SetPoint("BOTTOMRIGHT", -3, 3);

	ACI[i].icon:SetTexCoord(.08, .92, .08, .92);
	ACI[i].border:SetTexture("Interface\\Addons\\asCombatInfo\\border.tga");
	ACI[i].border:SetTexCoord(0.08, 0.08, 0.08, 0.92, 0.92, 0.08, 0.92, 0.92);

	ACI[i].border:Hide();
end


LoadAddOn("asMOD");

if asMOD_setupFrame then
	asMOD_setupFrame(ACI[3], "asCombatInfo");
end

ACI_OptionM.RegisterCallback(flushoption);
