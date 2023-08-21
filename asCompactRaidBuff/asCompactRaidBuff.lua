local ACRB_Size = 0;                                       -- Buff 아이콘 증가 크기
local ACRB_BuffSizeRate = 0.9;                             -- 기존 Size 크기 배수
local ACRB_ShowBuffCooldown = false                        -- 버프 지속시간을 보이려면
local ACRB_MinShowBuffFontSize = 5                         -- 이크기보다 Cooldown font Size 가 작으면 안보이게 한다. 무조건 보이게 하려면 0
local ACRB_CooldownFontSizeRate = 0.5                      -- 버프 Size 대비 쿨다운 폰트 사이즈
local ACRB_MAX_BUFFS = 6                                   -- 최대 표시 버프 개수 (3개 + 3개)
local ACRB_MAX_BUFFS_2 = 2                                 -- 최대 생존기 개수
local ACRB_MAX_DEBUFFS = 3                                 -- 최대 표시 디버프 개수 (3개)
local ACRB_MAX_DISPELDEBUFFS = 3                           -- 최대 해제 디버프 개수 (3개)
local ACRB_MAX_CASTING = 2                                 -- 최대 Casting Alert
local ACRB_ShowListFirst = true                            -- 알림 List 항목을 먼저 보임 (가나다 순, 같은 디법이 여러게 걸리는 경우 1개만 보일 수 있음 ex 불고)
local ACRB_ShowAlert = true                                -- HOT 리필 시 알림
local ACRB_MaxBuffSize = 20                                -- 최대 Buff Size 창을 늘려도 이 크기 이상은 안커짐
local ACRB_HealerManaBarHeight = 2                         -- 힐러 마나바 크기 (안보이게 하려면 0)
local ACRB_UpdateRate = (0.1)                              -- 1회 Update 주기 (초) 작으면 작을 수록 Frame Rate 감소 가능, 크면 Update 가 느림
local ACRB_ShowWhenSolo = true                             -- Solo Raid Frame 사용시 보이게 하려면 True (반드시 Solo Raid Frame과 사용)
local ACRB_ShowTooltip = true                              -- GameTooltip을 보이게 하려면 True
local ACRB_RangeFilterColor = { r = 0.3, g = 0.3, b = 0.3 }; --30m 이상 RangeFilter Color
local ACRB_RangeFilterAlpha = 0.5


-- 버프 남은시간에 리필 알림
-- 두번째 숫자는 표시 위치, 4(우상) 5(우중) 6(상) 1,2,3 은 우하에 보이는 우선 순위이다.
ACRB_ShowList_MONK_2 = {
	["포용의 안개"] = { 6 * 0.3, 1 },
	["소생의 안개"] = { 20 * 0.3, 4 }


}

-- 신기
ACRB_ShowList_PALADIN_1 = {
	["빛의 봉화"] = { 0, 4 },
	["신념의 봉화"] = { 0, 5 },
}

-- 수사
ACRB_ShowList_PRIEST_1 = {
	["속죄"] = { 3, 4 },
	["신의 권능: 보호막"] = { 15 * 0.3, 1 }

}


-- 신사
ACRB_ShowList_PRIEST_2 = {
	["소생"] = { 15 * 0.3, 4 },
	["회복의 기원"] = { 0, 1 },

}


ACRB_ShowList_SHAMAN_3 = {
	["성난 해일"] = { 15 * 0.3, 1 },
}


ACRB_ShowList_DRUID_4 = {
	["회복"] = { 15 * 0.3, 4 },
	["재생"] = { 12 * 0.3, 5 },
	["피어나는 생명"] = { 15 * 0.3, 6 },
	["회복 (싹틔우기)"] = { 15 * 0.3, 2 },
	["세나리온 수호물"] = { 0, 1 },


}

ACRB_ShowList_EVOKER_2 = {
	["메아리"] = { 0, 4 },

}


-- 안보이게 할 디법
local ACRB_BlackList = {
	["도전자의 짐"] = 1,
}


-- 해제 알림 스킬
local ACRB_DispelAlertList = {
	--["탈진"] = 1,	
}



--직업별 생존기 등록 (10초 쿨다운), 용군단 Version
local ACRB_PVPBuffList = {
	[236273] = true, --WARRIOR
	[213871] = true, --WARRIOR
	[118038] = true, --WARRIOR
	[12975] = true, --WARRIOR
	[1160] = true, --WARRIOR
	[871] = true, --WARRIOR
	[202168] = true, --WARRIOR
	[97463] = true, --WARRIOR
	[383762] = true, --WARRIOR
	[184364] = true, --WARRIOR
	[386394] = true, --WARRIOR
	[392966] = true, --WARRIOR
	[185311] = true, --ROGUE
	[11327] = true, --ROGUE
	[1966] = true, --ROGUE
	[31224] = true, --ROGUE
	[31230] = true, --ROGUE
	[5277] = true, --ROGUE
	[212800] = true, --DEMONHUNTER
	[203720] = true, --DEMONHUNTER
	[187827] = true, --DEMONHUNTER
	[206803] = true, --DEMONHUNTER
	[196555] = true, --DEMONHUNTER
	[204021] = true, --DEMONHUNTER
	[263648] = true, --DEMONHUNTER
	[209258] = true, --DEMONHUNTER
	[209426] = true, --DEMONHUNTER
	[202162] = true, --MONK
	[388615] = true, --MONK
	[115310] = true, --MONK
	[116849] = true, --MONK
	[115399] = true, --MONK
	[119582] = true, --MONK
	[122281] = true, --MONK
	[322507] = true, --MONK
	[120954] = true, --MONK
	[122783] = true, --MONK
	[122278] = true, --MONK
	[132578] = true, --MONK
	[115176] = true, --MONK
	[51052] = true, --DEATHKNIGHT
	[48707] = true, --DEATHKNIGHT
	[327574] = true, --DEATHKNIGHT
	[48743] = true, --DEATHKNIGHT
	[48792] = true, --DEATHKNIGHT
	[114556] = true, --DEATHKNIGHT
	[81256] = true, --DEATHKNIGHT
	[219809] = true, --DEATHKNIGHT
	[206931] = true, --DEATHKNIGHT
	[274156] = true, --DEATHKNIGHT
	[194679] = true, --DEATHKNIGHT
	[55233] = true, --DEATHKNIGHT
	[53480] = true, --HUNTER
	[109304] = true, --HUNTER
	[264735] = true, --HUNTER
	[355913] = true, --EVOKER
	[370960] = true, --EVOKER
	[363534] = true, --EVOKER
	[357170] = true, --EVOKER
	[374348] = true, --EVOKER
	[374227] = true, --EVOKER
	[363916] = true, --EVOKER
	[360827] = true, --EVOKER
	[404381] = true, --EVOKER
	[305497] = true, --DRUID
	[354654] = true, --DRUID
	[201664] = true, --DRUID
	[157982] = true, --DRUID
	[102342] = true, --DRUID
	[61336] = true, --DRUID
	[200851] = true, --DRUID
	[80313] = true, --DRUID
	[22842] = true, --DRUID
	[108238] = true, --DRUID
	[124974] = true, --DRUID
	[22812] = true, --DRUID
	[104773] = true, --WARLOCK
	[108416] = true, --WARLOCK
	[215769] = true, --PRIEST
	[328530] = true, --PRIEST
	[197268] = true, --PRIEST
	[19236] = true, --PRIEST
	[81782] = true, --PRIEST
	[33206] = true, --PRIEST
	[372835] = true, --PRIEST
	[391124] = true, --PRIEST
	[265202] = true, --PRIEST
	[64843] = true, --PRIEST
	[47788] = true, --PRIEST
	[47585] = true, --PRIEST
	[108968] = true, --PRIEST
	[15286] = true, --PRIEST
	[271466] = true, --PRIEST
	[199452] = true, --PALADIN
	[403876] = true, --PALADIN
	[31850] = true, --PALADIN
	[378279] = true, --PALADIN
	[378974] = true, --PALADIN
	[86659] = true, --PALADIN
	[387174] = true, --PALADIN
	[327193] = true, --PALADIN
	[205191] = true, --PALADIN
	[184662] = true, --PALADIN
	[498] = true, --PALADIN
	[148039] = true, --PALADIN
	[157047] = true, --PALADIN
	[31821] = true, --PALADIN
	[633] = true, --PALADIN
	[6940] = true, --PALADIN
	[1022] = true, --PALADIN
	[204018] = true, --PALADIN
	[204331] = true, --SHAMAN
	[108280] = true, --SHAMAN
	[98008] = true, --SHAMAN
	[198838] = true, --SHAMAN
	[207399] = true, --SHAMAN
	[108271] = true, --SHAMAN
	[198103] = true, --SHAMAN
	[30884] = true, --SHAMAN
	[383017] = true, --SHAMAN
	[108281] = true, --SHAMAN
	[198111] = true, --MAGE
	[110959] = true, --MAGE
	[342246] = true, --MAGE
	[11426] = true, --MAGE
	[66] = true,  --MAGE
	[235313] = true, --MAGE
	[235450] = true, --MAGE
	[55342] = true, --MAGE
	[414660] = true, --MAGE
	[414664] = true, --MAGE
	[86949] = true, --MAGE
	[235219] = true, --MAGE
	[414658] = true, --MAGE
}

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
--Action Button Glow--
local function ButtonGlowResetter(framePool, frame)
	frame:SetScript("OnUpdate", nil)
	local parent = frame:GetParent()
	if parent._ButtonGlow then
		parent._ButtonGlow = nil
	end
	frame:Hide()
	frame:ClearAllPoints()
end
local ButtonGlowPool = CreateFramePool("Frame", GlowParent, nil, ButtonGlowResetter)
lib.ButtonGlowPool = ButtonGlowPool

local function CreateScaleAnim(group, target, order, duration, x, y, delay)
	local scale = group:CreateAnimation("Scale")
	scale:SetChildKey(target)
	scale:SetOrder(order)
	scale:SetDuration(duration)
	scale:SetScale(x, y)

	if delay then
		scale:SetStartDelay(delay)
	end
end

local function CreateAlphaAnim(group, target, order, duration, fromAlpha, toAlpha, delay, appear)
	local alpha = group:CreateAnimation("Alpha")
	alpha:SetChildKey(target)
	alpha:SetOrder(order)
	alpha:SetDuration(duration)
	alpha:SetFromAlpha(fromAlpha)
	alpha:SetToAlpha(toAlpha)
	if delay then
		alpha:SetStartDelay(delay)
	end
	if appear then
		table.insert(group.appear, alpha)
	else
		table.insert(group.fade, alpha)
	end
end

local function AnimIn_OnPlay(group)
	local frame = group:GetParent()
	local frameWidth, frameHeight = frame:GetSize()
	frame.spark:SetSize(frameWidth, frameHeight)
	frame.spark:SetAlpha(not (frame.color) and 1.0 or 0.3 * frame.color[4])
	frame.innerGlow:SetSize(frameWidth, frameHeight)
	frame.innerGlow:SetAlpha(not (frame.color) and 1.0 or frame.color[4])
	frame.innerGlowOver:SetAlpha(not (frame.color) and 1.0 or frame.color[4])
	frame.outerGlow:SetSize(frameWidth, frameHeight)
	frame.outerGlow:SetAlpha(not (frame.color) and 1.0 or frame.color[4])
	frame.outerGlowOver:SetAlpha(not (frame.color) and 1.0 or frame.color[4])
	frame.ants:SetSize(frameWidth * 1.4 * 0.9, frameHeight * 1.4 * 0.9)
	frame.ants:SetAlpha(0)
	frame:Show()
end

local function AnimIn_OnFinished(group)
	local frame = group:GetParent()
	local frameWidth, frameHeight = frame:GetSize()
	frame.spark:SetAlpha(0)
	frame.innerGlow:SetAlpha(0)
	frame.innerGlow:SetSize(frameWidth, frameHeight)
	frame.innerGlowOver:SetAlpha(0.0)
	frame.outerGlow:SetSize(frameWidth, frameHeight)
	frame.outerGlowOver:SetAlpha(0.0)
	frame.outerGlowOver:SetSize(frameWidth, frameHeight)
	frame.ants:SetAlpha(not (frame.color) and 1.0 or frame.color[4])
end

local function AnimIn_OnStop(group)
	local frame = group:GetParent()
	local frameWidth, frameHeight = frame:GetSize()
	frame.spark:SetAlpha(0)
	frame.innerGlow:SetAlpha(0)
	frame.innerGlowOver:SetAlpha(0.0)
	frame.outerGlowOver:SetAlpha(0.0)
end

local function bgHide(self)
	if self.animOut:IsPlaying() then
		self.animOut:Stop()
		ButtonGlowPool:Release(self)
	end
end

local function bgUpdate(self, elapsed)
	AnimateTexCoords(self.ants, 256, 256, 48, 48, 22, elapsed, self.throttle);
	local cooldown = self:GetParent().cooldown;
	if (cooldown and cooldown:IsShown() and cooldown:GetCooldownDuration() > 3000) then
		self:SetAlpha(0.5);
	else
		self:SetAlpha(1.0);
	end
end

local function configureButtonGlow(f, alpha)
	f.spark = f:CreateTexture(nil, "BACKGROUND")
	f.spark:SetPoint("CENTER")
	f.spark:SetAlpha(0)
	f.spark:SetTexture([[Interface\SpellActivationOverlay\IconAlert]])
	f.spark:SetTexCoord(0.00781250, 0.61718750, 0.00390625, 0.26953125)

	-- inner glow
	f.innerGlow = f:CreateTexture(nil, "ARTWORK")
	f.innerGlow:SetPoint("CENTER")
	f.innerGlow:SetAlpha(0)
	f.innerGlow:SetTexture([[Interface\SpellActivationOverlay\IconAlert]])
	f.innerGlow:SetTexCoord(0.00781250, 0.50781250, 0.27734375, 0.52734375)

	-- inner glow over
	f.innerGlowOver = f:CreateTexture(nil, "ARTWORK")
	f.innerGlowOver:SetPoint("TOPLEFT", f.innerGlow, "TOPLEFT")
	f.innerGlowOver:SetPoint("BOTTOMRIGHT", f.innerGlow, "BOTTOMRIGHT")
	f.innerGlowOver:SetAlpha(0)
	f.innerGlowOver:SetTexture([[Interface\SpellActivationOverlay\IconAlert]])
	f.innerGlowOver:SetTexCoord(0.00781250, 0.50781250, 0.53515625, 0.78515625)

	-- outer glow
	f.outerGlow = f:CreateTexture(nil, "ARTWORK")
	f.outerGlow:SetPoint("CENTER")
	f.outerGlow:SetAlpha(0)
	f.outerGlow:SetTexture([[Interface\SpellActivationOverlay\IconAlert]])
	f.outerGlow:SetTexCoord(0.00781250, 0.50781250, 0.27734375, 0.52734375)

	-- outer glow over
	f.outerGlowOver = f:CreateTexture(nil, "ARTWORK")
	f.outerGlowOver:SetPoint("TOPLEFT", f.outerGlow, "TOPLEFT")
	f.outerGlowOver:SetPoint("BOTTOMRIGHT", f.outerGlow, "BOTTOMRIGHT")
	f.outerGlowOver:SetAlpha(0)
	f.outerGlowOver:SetTexture([[Interface\SpellActivationOverlay\IconAlert]])
	f.outerGlowOver:SetTexCoord(0.00781250, 0.50781250, 0.53515625, 0.78515625)

	-- ants
	f.ants = f:CreateTexture(nil, "OVERLAY")
	f.ants:SetPoint("CENTER")
	f.ants:SetAlpha(0)
	f.ants:SetTexture([[Interface\SpellActivationOverlay\IconAlertAnts]])

	f.animIn = f:CreateAnimationGroup()
	f.animIn.appear = {}
	f.animIn.fade = {}
	CreateScaleAnim(f.animIn, "spark", 1, 0.2, 1.5, 1.5)
	CreateAlphaAnim(f.animIn, "spark", 1, 0.2, 0, alpha, nil, true)
	CreateScaleAnim(f.animIn, "innerGlow", 1, 0.3, 2, 2)
	CreateScaleAnim(f.animIn, "innerGlowOver", 1, 0.3, 2, 2)
	CreateAlphaAnim(f.animIn, "innerGlowOver", 1, 0.3, alpha, 0, nil, false)
	CreateScaleAnim(f.animIn, "outerGlow", 1, 0.3, 0.5, 0.5)
	CreateScaleAnim(f.animIn, "outerGlowOver", 1, 0.3, 0.5, 0.5)
	CreateAlphaAnim(f.animIn, "outerGlowOver", 1, 0.3, alpha, 0, nil, false)
	CreateScaleAnim(f.animIn, "spark", 1, 0.2, 2 / 3, 2 / 3, 0.2)
	CreateAlphaAnim(f.animIn, "spark", 1, 0.2, alpha, 0, 0.2, false)
	CreateAlphaAnim(f.animIn, "innerGlow", 1, 0.2, alpha, 0, 0.3, false)
	CreateAlphaAnim(f.animIn, "ants", 1, 0.2, 0, alpha, 0.3, true)
	f.animIn:SetScript("OnPlay", AnimIn_OnPlay)
	f.animIn:SetScript("OnStop", AnimIn_OnStop)
	f.animIn:SetScript("OnFinished", AnimIn_OnFinished)

	f.animOut = f:CreateAnimationGroup()
	f.animOut.appear = {}
	f.animOut.fade = {}
	CreateAlphaAnim(f.animOut, "outerGlowOver", 1, 0.2, 0, alpha, nil, true)
	CreateAlphaAnim(f.animOut, "ants", 1, 0.2, alpha, 0, nil, false)
	CreateAlphaAnim(f.animOut, "outerGlowOver", 2, 0.2, alpha, 0, nil, false)
	CreateAlphaAnim(f.animOut, "outerGlow", 2, 0.2, alpha, 0, nil, false)
	f.animOut:SetScript("OnFinished", function(self) ButtonGlowPool:Release(self:GetParent()) end)

	f:SetScript("OnHide", bgHide)
end

local function updateAlphaAnim(f, alpha)
	for _, anim in pairs(f.animIn.appear) do
		anim:SetToAlpha(alpha)
	end
	for _, anim in pairs(f.animIn.fade) do
		anim:SetFromAlpha(alpha)
	end
	for _, anim in pairs(f.animOut.appear) do
		anim:SetToAlpha(alpha)
	end
	for _, anim in pairs(f.animOut.fade) do
		anim:SetFromAlpha(alpha)
	end
end

local ButtonGlowTextures = { ["spark"] = true, ["innerGlow"] = true, ["innerGlowOver"] = true, ["outerGlow"] = true,
	["outerGlowOver"] = true, ["ants"] = true }

function lib.ButtonGlow_Start(r, color, frequency, frameLevel)
	if not r then
		return
	end
	frameLevel = frameLevel or 8;
	local throttle
	if frequency and frequency > 0 then
		throttle = 0.25 / frequency * 0.01
	else
		throttle = 0.01
	end
	if r._ButtonGlow then
		local f = r._ButtonGlow
		local width, height = r:GetSize()
		f:SetFrameLevel(r:GetFrameLevel() + frameLevel)
		f:SetSize(width * 1.4, height * 1.4)
		f:SetPoint("TOPLEFT", r, "TOPLEFT", -width * 0.3, height * 0.3)
		f:SetPoint("BOTTOMRIGHT", r, "BOTTOMRIGHT", width * 0.3, -height * 0.3)
		f.ants:SetSize(width * 1.4 * 0.9, height * 1.4 * 0.9)
		AnimIn_OnFinished(f.animIn)
		if f.animOut:IsPlaying() then
			f.animOut:Stop()
			f.animIn:Play()
		end

		if not (color) then
			for texture in pairs(ButtonGlowTextures) do
				f[texture]:SetDesaturated(nil)
				f[texture]:SetVertexColor(1, 1, 1)
				f[texture]:SetAlpha(f[texture]:GetAlpha() / (f.color and f.color[4] or 1))
				updateAlphaAnim(f, 1)
			end
			f.color = false
		else
			for texture in pairs(ButtonGlowTextures) do
				f[texture]:SetDesaturated(1)
				f[texture]:SetVertexColor(color[1], color[2], color[3])
				f[texture]:SetAlpha(f[texture]:GetAlpha() / (f.color and f.color[4] or 1) * color[4])
				updateAlphaAnim(f, color and color[4] or 1)
			end
			f.color = color
		end
		f.throttle = throttle
	else
		local f, new = ButtonGlowPool:Acquire()
		if new then
			configureButtonGlow(f, color and color[4] or 1)
		else
			updateAlphaAnim(f, color and color[4] or 1)
		end
		r._ButtonGlow = f
		local width, height = r:GetSize()
		f:SetParent(r)
		f:SetFrameLevel(r:GetFrameLevel() + frameLevel)
		f:SetSize(width * 1.4, height * 1.4)
		f:SetPoint("TOPLEFT", r, "TOPLEFT", -width * 0.3, height * 0.3)
		f:SetPoint("BOTTOMRIGHT", r, "BOTTOMRIGHT", width * 0.3, -height * 0.3)
		if not (color) then
			f.color = false
			for texture in pairs(ButtonGlowTextures) do
				f[texture]:SetDesaturated(nil)
				f[texture]:SetVertexColor(1, 1, 1)
			end
		else
			f.color = color
			for texture in pairs(ButtonGlowTextures) do
				f[texture]:SetDesaturated(1)
				f[texture]:SetVertexColor(color[1], color[2], color[3])
			end
		end
		f.throttle = throttle
		f:SetScript("OnUpdate", bgUpdate)

		f.animIn:Play()
	end
end

function lib.ButtonGlow_Stop(r)
	if r._ButtonGlow then
		if r._ButtonGlow.animIn:IsPlaying() then
			r._ButtonGlow.animIn:Stop()
			ButtonGlowPool:Release(r._ButtonGlow)
		elseif r:IsVisible() then
			r._ButtonGlow.animOut:Play()
		else
			ButtonGlowPool:Release(r._ButtonGlow)
		end
	end
end

table.insert(lib.glowList, "Action Button Glow")
lib.startList["Action Button Glow"] = lib.ButtonGlow_Start
lib.stopList["Action Button Glow"] = lib.ButtonGlow_Stop


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

-- 직업 리필
local ACRB_ShowList = nil;
local show_30m_range = false;

local asraid = {};

local function ACRB_InitList()
	local spec = GetSpecialization();
	local localizedClass, englishClass = UnitClass("player")
	local listname;

	ACRB_ShowList = nil;

	if spec then
		listname = "ACRB_ShowList_" .. englishClass .. "_" .. spec;
	end

	ACRB_ShowList = _G[listname];

	--기원사 힐이면 30미터 Filter 추가
	if englishClass == "EVOKER" and spec == 2 then
		show_30m_range = true;
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
		--크기 조정을 위해 아래 코드를 돌린다.
	end

	if frame.displayedUnit then
		asraid[frameName].displayedUnit = frame.displayedUnit;
	else
		asraid[frameName].displayedUnit = frame.unit;
	end

	asraid[frameName].frame = frame;

	if not UnitIsPlayer(asraid[frameName].displayedUnit) then
		return;
	end

	local CUF_AURA_BOTTOM_OFFSET = 2;
	local CUF_NAME_SECTION_SIZE = 15;

	local frameHeight = EditModeManagerFrame:GetRaidFrameHeight(frame.isParty);
	local options = DefaultCompactUnitFrameSetupOptions;
	local powerBarHeight = 8;
	local powerBarUsedHeight = options.displayPowerBar and powerBarHeight or 0;


	local x, y = frame:GetSize();

	y = y - powerBarUsedHeight;

	local size_x = x / 6 * ACRB_BuffSizeRate;
	local size_y = y / 3 * ACRB_BuffSizeRate;

	local baseSize = math.min(x / 7 * ACRB_BuffSizeRate, y / 3 * ACRB_BuffSizeRate);

	if baseSize > ACRB_MaxBuffSize then
		baseSize = ACRB_MaxBuffSize
	end

	baseSize = baseSize * 0.9;

	local fontsize = baseSize * ACRB_CooldownFontSizeRate;

	-- 힐거리 기능
	if not asraid[frameName].rangetex then
		asraid[frameName].rangetex = frame:CreateTexture(nil, "ARTWORK");
		asraid[frameName].rangetex:SetAllPoints();
		asraid[frameName].rangetex:SetColorTexture(ACRB_RangeFilterColor.r, ACRB_RangeFilterColor.g,
			ACRB_RangeFilterColor.b);
		asraid[frameName].rangetex:SetAlpha(ACRB_RangeFilterAlpha);
		asraid[frameName].rangetex:Hide();
	end

	if asraid[frameName].isDispellAlert == nil then
		asraid[frameName].isDispellAlert = false;
	end

	if not asraid[frameName].asbuffFrames then
		asraid[frameName].asbuffFrames = {}
		for i = 1, ACRB_MAX_BUFFS do
			local buffFrame = CreateFrame("Button", nil, frame, "asCompactBuffTemplate")
			buffFrame:EnableMouse(ACRB_ShowTooltip);
			buffFrame.icon:SetTexCoord(.08, .92, .08, .92);
			buffFrame.border:SetTexture("Interface\\Addons\\asCompactRaidBuff\\border.tga");
			buffFrame.border:SetTexCoord(0.08, 0.08, 0.08, 0.92, 0.92, 0.08, 0.92, 0.92);
			if ACRB_ShowTooltip and not buffFrame:GetScript("OnEnter") then
				buffFrame:SetScript("OnEnter", function(s)
					if s:GetID() > 0 then
						GameTooltip_SetDefaultAnchor(GameTooltip, s);
						GameTooltip:SetUnitBuff(s.unit, s:GetID(), s.filter);
					end
				end)
				buffFrame:SetScript("OnLeave", function()
					GameTooltip:Hide();
				end)
			end

			asraid[frameName].asbuffFrames[i] = buffFrame;
			buffFrame:Hide();
		end
	end

	if asraid[frameName].asbuffFrames then
		for i = 1, ACRB_MAX_BUFFS do
			local buffFrame = asraid[frameName].asbuffFrames[i];
			buffFrame:ClearAllPoints()


			if i <= ACRB_MAX_BUFFS - 3 then
				if math.fmod(i - 1, 3) == 0 then
					if i == 1 then
						local buffPos, buffRelativePoint, buffOffset = "BOTTOMRIGHT", "BOTTOMLEFT",
							CUF_AURA_BOTTOM_OFFSET + powerBarUsedHeight;
						buffFrame:ClearAllPoints();
						buffFrame:SetPoint(buffPos, frame, "BOTTOMRIGHT", -2, buffOffset);
					else
						buffFrame:SetPoint("BOTTOMRIGHT", asraid[frameName].asbuffFrames[i - 3], "TOPRIGHT", 0, 1)
					end
				else
					buffFrame:SetPoint("BOTTOMRIGHT", asraid[frameName].asbuffFrames[i - 1], "BOTTOMLEFT", -1, 0)
				end
			else
				-- 3개는 따로 뺀다.
				if i == ACRB_MAX_BUFFS - 2 then
					-- 우상
					buffFrame:ClearAllPoints();
					buffFrame:SetPoint("TOPRIGHT", frame, "TOPRIGHT", -2, -2);
				elseif i == ACRB_MAX_BUFFS - 1 then
					-- 우중
					buffFrame:ClearAllPoints();
					buffFrame:SetPoint("RIGHT", frame, "RIGHT", -2, 0);
				else
					-- 우중2
					buffFrame:ClearAllPoints();
					buffFrame:SetPoint("BOTTOMRIGHT", asraid[frameName].asbuffFrames[i - 1], "BOTTOMLEFT", -1, 0)
				end
			end
		end
	end


	--크기 조정
	for _, d in ipairs(asraid[frameName].asbuffFrames) do
		d:SetSize(size_x, size_y);

		d.count:SetFont(STANDARD_TEXT_FONT, fontsize, "OUTLINE")
		d.count:ClearAllPoints();
		d.count:SetPoint("BOTTOM", 0, 1);
		if ACRB_ShowBuffCooldown and fontsize >= ACRB_MinShowBuffFontSize then
			d.cooldown:SetHideCountdownNumbers(false);
			for _, r in next, { d.cooldown:GetRegions() } do
				if r:GetObjectType() == "FontString" then
					r:SetFont(STANDARD_TEXT_FONT, fontsize, "OUTLINE")
					r:ClearAllPoints();
					r:SetPoint("TOP", 0, 2);
					break
				end
			end
		end
	end

	if not asraid[frameName].asdebuffFrames then
		asraid[frameName].asdebuffFrames = {};
		for i = 1, ACRB_MAX_DEBUFFS do
			local debuffFrame = CreateFrame("Button", nil, frame, "asCompactDebuffTemplate")
			debuffFrame:EnableMouse(ACRB_ShowTooltip);
			debuffFrame.icon:SetTexCoord(.08, .92, .08, .92);
			debuffFrame.border:SetTexture("Interface\\Addons\\asCompactRaidBuff\\border.tga");
			debuffFrame.border:SetTexCoord(0.08, 0.08, 0.08, 0.92, 0.92, 0.08, 0.92, 0.92);

			if ACRB_ShowTooltip and not debuffFrame:GetScript("OnEnter") then
				debuffFrame:SetScript("OnEnter", function(s)
					if s:GetID() > 0 then
						GameTooltip_SetDefaultAnchor(GameTooltip, s);
						GameTooltip:SetUnitDebuff(s.unit, s:GetID(), s.filter);
					end
				end)

				debuffFrame:SetScript("OnLeave", function()
					GameTooltip:Hide();
				end)
			end

			asraid[frameName].asdebuffFrames[i] = debuffFrame;
			debuffFrame:Hide();
		end
	end

	if asraid[frameName].asbuffFrames then
		for i = 1, ACRB_MAX_DEBUFFS do
			local debuffFrame = asraid[frameName].asdebuffFrames[i];
			debuffFrame:ClearAllPoints()

			if math.fmod(i - 1, 3) == 0 then
				if i == 1 then
					local debuffPos, debuffRelativePoint, debuffOffset = "BOTTOMLEFT", "BOTTOMRIGHT",
						CUF_AURA_BOTTOM_OFFSET + powerBarUsedHeight;
					debuffFrame:ClearAllPoints();
					debuffFrame:SetPoint(debuffPos, frame, "BOTTOMLEFT", 3, debuffOffset);
				else
					debuffFrame:SetPoint("BOTTOMLEFT", asraid[frameName].asdebuffFrames[i - 3], "TOPLEFT", 0, 1)
				end
			else
				debuffFrame:SetPoint("BOTTOMLEFT", asraid[frameName].asdebuffFrames[i - 1], "BOTTOMRIGHT", 1, 0)
			end
		end
	end

	for _, d in ipairs(asraid[frameName].asdebuffFrames) do
		d.size_x, d.size_y = size_x, size_y; -- 디버프
		d.maxHeight = frameHeight - powerBarUsedHeight - CUF_AURA_BOTTOM_OFFSET - CUF_NAME_SECTION_SIZE;
		d.count:SetFont(STANDARD_TEXT_FONT, fontsize, "OUTLINE")
		d.count:ClearAllPoints();
		d.count:SetPoint("BOTTOM", 0, 1);

		if ACRB_ShowBuffCooldown and fontsize >= ACRB_MinShowBuffFontSize then
			d.cooldown:SetHideCountdownNumbers(false);
			for _, r in next, { d.cooldown:GetRegions() } do
				if r:GetObjectType() == "FontString" then
					r:SetFont(STANDARD_TEXT_FONT, fontsize, "OUTLINE");
					r:ClearAllPoints();
					r:SetPoint("TOP", 0, 2);
					break
				end
			end
		end
	end


	if not asraid[frameName].asdispelDebuffFrames then
		asraid[frameName].asdispelDebuffFrames = {};
		for i = 1, ACRB_MAX_DISPELDEBUFFS do
			local dispelDebuffFrame = CreateFrame("Button", nil, frame, "asCompactDispelDebuffTemplate")
			dispelDebuffFrame:EnableMouse(false);
			asraid[frameName].asdispelDebuffFrames[i] = dispelDebuffFrame;
			dispelDebuffFrame:Hide();
		end
	end

	asraid[frameName].asdispelDebuffFrames[1]:SetPoint("RIGHT", asraid[frameName].asbuffFrames[(ACRB_MAX_BUFFS - 2)],
		"LEFT", -1, 0);
	for i = 1, ACRB_MAX_DISPELDEBUFFS do
		if (i > 1) then
			asraid[frameName].asdispelDebuffFrames[i]:SetPoint("RIGHT", asraid[frameName].asdispelDebuffFrames[i - 1],
				"LEFT", 0, 0);
		end
		asraid[frameName].asdispelDebuffFrames[i]:SetSize(baseSize, baseSize);
	end

	if (not asraid[frameName].asManabar and not frame.powerBar:IsShown()) then
		asraid[frameName].asManabar = CreateFrame("StatusBar", nil, frame.healthBar)
		asraid[frameName].asManabar:SetStatusBarTexture("Interface\\TARGETINGFRAME\\UI-StatusBar")
		asraid[frameName].asManabar:GetStatusBarTexture():SetHorizTile(false)
		asraid[frameName].asManabar:SetMinMaxValues(0, 100)
		asraid[frameName].asManabar:SetValue(100)
		asraid[frameName].asManabar:SetPoint("BOTTOM", frame.healthBar, "BOTTOM", 0, 0)
		asraid[frameName].asManabar:Hide();
	end

	if asraid[frameName].asManabar then
		asraid[frameName].asManabar:SetWidth(x - 2);
		asraid[frameName].asManabar:SetHeight(ACRB_HealerManaBarHeight)
	end

	if (not asraid[frameName].asraidicon) then
		asraid[frameName].asraidicon = frame:CreateFontString(nil, "OVERLAY")
		asraid[frameName].asraidicon:SetFont(STANDARD_TEXT_FONT, fontsize * 2)
		asraid[frameName].asraidicon:SetPoint("LEFT", frame.healthBar, "LEFT", 2, 0)
		asraid[frameName].asraidicon:Hide();
	end

	asraid[frameName].asraidicon:SetFont(STANDARD_TEXT_FONT, fontsize * 2);

	if (not asraid[frameName].buffFrames2) then
		asraid[frameName].buffFrames2 = {};

		for i = 1, ACRB_MAX_BUFFS_2 do
			asraid[frameName].buffFrames2[i] = CreateFrame("Button", nil, frame, "asCompactBuffTemplate")
			asraid[frameName].buffFrames2[i]:EnableMouse(ACRB_ShowTooltip);
			asraid[frameName].buffFrames2[i].icon:SetTexCoord(.08, .92, .08, .92);
			asraid[frameName].buffFrames2[i].count:SetFont(STANDARD_TEXT_FONT, fontsize, "OUTLINE");
			asraid[frameName].buffFrames2[i].count:ClearAllPoints();
			asraid[frameName].buffFrames2[i].count:SetPoint("BOTTOM", 0, 0);
			asraid[frameName].buffFrames2[i]:Hide();

			if ACRB_ShowBuffCooldown and fontsize >= ACRB_MinShowBuffFontSize then
				asraid[frameName].buffFrames2[i].cooldown:SetHideCountdownNumbers(false);
				for _, r in next, { asraid[frameName].buffFrames2[i].cooldown:GetRegions() } do
					if r:GetObjectType() == "FontString" then
						r:SetFont(STANDARD_TEXT_FONT, fontsize, "OUTLINE");
						r:ClearAllPoints();
						r:SetPoint("TOP", 0, 2);
						break
					end
				end
			else
				asraid[frameName].buffFrames2[i].cooldown:SetHideCountdownNumbers(true);
			end

			if ACRB_ShowTooltip and not asraid[frameName].buffFrames2[i]:GetScript("OnEnter") then
				asraid[frameName].buffFrames2[i]:SetScript("OnEnter", function(s)
					if s:GetID() > 0 then
						GameTooltip_SetDefaultAnchor(GameTooltip, s);
						GameTooltip:SetUnitBuff(s.unit, s:GetID(), s.filter);
					end
				end)

				asraid[frameName].buffFrames2[i]:SetScript("OnLeave", function()
					GameTooltip:Hide();
				end)
			end
		end
	end

	if (asraid[frameName].buffFrames2) then
		for i = 1, ACRB_MAX_BUFFS_2 do
			asraid[frameName].buffFrames2[i]:SetSize(size_x, size_y);
			asraid[frameName].buffFrames2[i].count:SetFont(STANDARD_TEXT_FONT, fontsize, "OUTLINE");
			asraid[frameName].buffFrames2[i]:ClearAllPoints()
			if i == 1 then
				asraid[frameName].buffFrames2[i]:SetPoint("CENTER", frame.healthBar, "CENTER", 0, 0)
			else
				asraid[frameName].buffFrames2[i]:SetPoint("TOPRIGHT", asraid[frameName].buffFrames2[i - 1], "TOPLEFT", 0,
					0)
			end
		end
	end


	if (not asraid[frameName].castFrames) then
		asraid[frameName].castFrames = {};

		for i = 1, ACRB_MAX_CASTING do
			asraid[frameName].castFrames[i] = CreateFrame("Button", nil, frame, "asCompactBuffTemplate")
			asraid[frameName].castFrames[i]:EnableMouse(ACRB_ShowTooltip);
			asraid[frameName].castFrames[i].icon:SetTexCoord(.08, .92, .08, .92);
			asraid[frameName].castFrames[i].count:SetFont(STANDARD_TEXT_FONT, fontsize, "OUTLINE");
			asraid[frameName].castFrames[i].count:ClearAllPoints();
			asraid[frameName].castFrames[i].count:SetPoint("BOTTOM", 0, 0);
			asraid[frameName].castFrames[i]:Hide();

			if ACRB_ShowBuffCooldown and fontsize >= ACRB_MinShowBuffFontSize then
				asraid[frameName].castFrames[i].cooldown:SetHideCountdownNumbers(false);
				for _, r in next, { asraid[frameName].castFrames[i].cooldown:GetRegions() } do
					if r:GetObjectType() == "FontString" then
						r:SetFont(STANDARD_TEXT_FONT, fontsize, "OUTLINE");
						r:ClearAllPoints();
						r:SetPoint("TOP", 0, 2);
						break
					end
				end
			else
				asraid[frameName].castFrames[i].cooldown:SetHideCountdownNumbers(true);
			end

			if ACRB_ShowTooltip and not asraid[frameName].castFrames[i]:GetScript("OnEnter") then
				asraid[frameName].castFrames[i]:SetScript("OnEnter", function(s)
					if s.castspellid and s.castspellid > 0 then
						GameTooltip_SetDefaultAnchor(GameTooltip, s);
						GameTooltip:SetSpellByID(s.castspellid);
					end
				end)

				asraid[frameName].castFrames[i]:SetScript("OnLeave", function()
					GameTooltip:Hide();
				end)
			end
		end
	end

	if (asraid[frameName].castFrames) then
		for i = 1, ACRB_MAX_CASTING do
			asraid[frameName].castFrames[i]:SetSize(size_x, size_y);
			asraid[frameName].castFrames[i].count:SetFont(STANDARD_TEXT_FONT, fontsize, "OUTLINE");
			asraid[frameName].castFrames[i]:ClearAllPoints()
			if i == 1 then
				asraid[frameName].castFrames[i]:SetPoint("TOP", frame.healthBar, "TOP", 0, 0)
			else
				asraid[frameName].castFrames[i]:SetPoint("TOPRIGHT", asraid[frameName].castFrames[i - 1], "TOPLEFT", -1,
					0)
			end
		end
	end

	asraid[frameName].ncasting = 0;
end

-- 버프 설정 부
local function asCompactUnitFrame_UtilShouldDisplayBuff_buff(unit, index, filter)
	local name, icon, count, debuffType, duration, expirationTime, unitCaster, canStealOrPurge, _, spellId, canApplyAura =
	UnitBuff(unit, index, filter);

	if ACRB_BlackList and ACRB_BlackList[name] then
		return false;
	end

	if ACRB_ShowListFirst and ACRB_ShowList and ACRB_ShowList[name] then
		return false;
	end

	local hasCustom, alwaysShowMine, showForMySpec = SpellGetVisibilityInfo(spellId,
		UnitAffectingCombat("player") and "RAID_INCOMBAT" or "RAID_OUTOFCOMBAT");

	if (hasCustom) then
		return showForMySpec or
		(alwaysShowMine and (unitCaster == "player" or unitCaster == "pet" or unitCaster == "vehicle"));
	else
		return (unitCaster == "player" or unitCaster == "pet" or unitCaster == "vehicle") and canApplyAura and
		not SpellIsSelfBuff(spellId);
	end
end

local function asCompactUnitFrame_UtilIsBossAura(unit, index, filter, checkAsBuff)
	-- make sure you are using the correct index here!	allAurasIndex ~= debuffIndex
	local name, icon, count, debuffType, duration, expirationTime, unitCaster, canStealOrPurge, _, spellId, canApplyAura, isBossAura;
	if (checkAsBuff) then
		name, icon, count, debuffType, duration, expirationTime, unitCaster, canStealOrPurge, _, spellId, canApplyAura, isBossAura =
		UnitBuff(unit, index, filter);
	else
		name, icon, count, debuffType, duration, expirationTime, unitCaster, canStealOrPurge, _, spellId, canApplyAura, isBossAura =
		UnitDebuff(unit, index, filter);
	end
	return isBossAura;
end

local function asCompactUnitFrame_UtilSetDispelDebuff(dispellDebuffFrame, debuffType, index)
	dispellDebuffFrame:Show();
	dispellDebuffFrame.icon:SetTexture("Interface\\RaidFrame\\Raid-Icon-Debuff" .. debuffType);
	dispellDebuffFrame:SetID(index);
end




local function asCompactUnitFrame_UtilSetBuff2(buffFrame, unit, index, filter)
	local name, icon, count, debuffType, duration, expirationTime, unitCaster, canStealOrPurge, _, spellId, canApplyAura =
	UnitBuff(unit, index, filter);
	buffFrame.icon:SetTexture(icon);
	if (count > 1) then
		local countText = count;
		if (count >= 100) then
			countText = BUFF_STACKS_OVERFLOW;
		end
		buffFrame.count:Show();
		buffFrame.count:SetText(countText);
	else
		buffFrame.count:Hide();
	end
	buffFrame:SetID(index);
	buffFrame.unit = unit;
	buffFrame.filter = filter;
	local enabled = expirationTime and expirationTime ~= 0;
	if enabled then
		local startTime = expirationTime - duration;
		asCooldownFrame_Set(buffFrame.cooldown, startTime, duration, true);

		if ACRB_ShowList and ACRB_ShowAlert then
			local showlist_time = 0;

			if ACRB_ShowList[name] then
				showlist_time = ACRB_ShowList[name][1];
			end

			if expirationTime - GetTime() < showlist_time then
				buffFrame.border:SetVertexColor(1, 1, 1);
				buffFrame.border:Show();
				--lib.PixelGlow_Start(buffFrame, {1,1,1,1});
			else
				buffFrame.border:Hide();
				--lib.PixelGlow_Stop(buffFrame);
			end
		else
			buffFrame.border:Hide();
		end
	else
		buffFrame.border:Hide()
		asCooldownFrame_Clear(buffFrame.cooldown);
	end
	buffFrame:Show();
end

local function Comparison(AIndex, BIndex)
	local AID = AIndex[2];
	local BID = BIndex[2];

	if (AID ~= BID) then
		return AID > BID;
	end

	return false;
end


local function asCompactUnitFrame_UpdateBuffs(asframe)
	if (not asframe.asbuffFrames) then
		return;
	end

	local unit = asframe.displayedUnit

	if not (unit) then
		return;
	end

	if asframe.rangetex and not UnitIsUnit("player", unit) then
		local inRange, checkedRange = UnitInRange(unit);
		--40미터 밖
		if (checkedRange and not inRange) then --If we weren't able to check the range for some reason, we'll just treat them as in-range (for example, enemy units)
			asframe.rangetex:Show();
		elseif show_30m_range then
			local reaction = UnitReaction("player", unit);

			if reaction and reaction <= 4 then
				if GetItemInfo(835) and IsItemInRange(835, unit) then
					asframe.rangetex:Hide();
				else
					asframe.rangetex:Show();
				end
			else
				if GetItemInfo(1180) and IsItemInRange(1180, unit) then
					asframe.rangetex:Hide();
				else
					asframe.rangetex:Show();
				end
			end
		else
			asframe.rangetex:Hide();
		end
	end

	local index = 1;
	local frameNum = 1;
	local filter = nil;


	if UnitAffectingCombat("player") then
		filter = "PLAYER"
	end

	local aShowIdx = {};

	while (frameNum <= 20) do
		local buffName = UnitBuff(unit, index, filter);
		if (buffName) then
			if ACRB_ShowList and ACRB_ShowList[buffName] then
				aShowIdx[frameNum] = { index, ACRB_ShowList[buffName][2] }
				frameNum = frameNum + 1;
			elseif (asCompactUnitFrame_UtilShouldDisplayBuff_buff(unit, index, filter) and not asCompactUnitFrame_UtilIsBossAura(unit, index, filter, true)) then
				aShowIdx[frameNum] = { index, 0 }
				frameNum = frameNum + 1;
			end
		else
			break;
		end
		index = index + 1;
	end

	if ACRB_ShowListFirst then
		-- sort
		table.sort(aShowIdx, Comparison);
	end

	local frameidx = 1;
	local showframe = {};

	for i = 1, frameNum - 1 do
		if aShowIdx[i][2] > ACRB_MAX_BUFFS - 3 then
			local buffFrame = asframe.asbuffFrames[aShowIdx[i][2]];
			asCompactUnitFrame_UtilSetBuff2(buffFrame, unit, aShowIdx[i][1], filter);
			showframe[aShowIdx[i][2]] = true;
		else
			local buffFrame = asframe.asbuffFrames[frameidx];
			asCompactUnitFrame_UtilSetBuff2(buffFrame, unit, aShowIdx[i][1], filter);
			frameidx = frameidx + 1;
		end

		if frameidx > (ACRB_MAX_BUFFS - 3) then
			break
		end
	end



	for i = frameidx, ACRB_MAX_BUFFS - 3 do
		local buffFrame = asframe.asbuffFrames[i];
		buffFrame:Hide();
	end

	for i = ACRB_MAX_BUFFS - 2, ACRB_MAX_BUFFS do
		if showframe[i] == nil then
			local buffFrame = asframe.asbuffFrames[i];
			buffFrame:Hide();
		end
	end
end



local function asCompactUnitFrame_UtilShouldDisplayBuff(unit, index, filter)
	local name, icon, count, debuffType, duration, expirationTime, unitCaster, canStealOrPurge, _, spellId, canApplyAura =
	UnitBuff(unit, index, filter);

	if ACRB_PVPBuffList[spellId] then
		return true;
	end

	return false;
end

local function asCompactUnitFrame_UtilSetBuff(buffFrame, unit, index, filter)
	local name, icon, count, debuffType, duration, expirationTime, unitCaster, canStealOrPurge, _, spellId, canApplyAura =
	UnitBuff(unit, index, filter);
	buffFrame.icon:SetTexture(icon);
	if (count > 1) then
		local countText = count;
		if (count >= 100) then
			countText = BUFF_STACKS_OVERFLOW;
		end
		buffFrame.count:Show();
		buffFrame.count:SetText(countText);
	else
		buffFrame.count:Hide();
	end
	buffFrame:SetID(index);
	buffFrame.unit = unit;
	buffFrame.filter = filter;
	local enabled = expirationTime and expirationTime ~= 0;
	if enabled then
		local startTime = expirationTime - duration;
		asCooldownFrame_Set(buffFrame.cooldown, startTime, duration, true);
	else
		asCooldownFrame_Clear(buffFrame.cooldown);
	end

	buffFrame.border:Hide();
	buffFrame:Show();
end



-- Debuff 설정 부
local function asCompactUnitFrame_UtilSetDebuff(debuffFrame, unit, index, filter, isBossAura, isBossBuff)
	-- make sure you are using the correct index here!
	--isBossAura says make this look large.
	--isBossBuff looks in HELPFULL auras otherwise it looks in HARMFULL ones
	local name, icon, count, debuffType, duration, expirationTime, unitCaster, canStealOrPurge, _, spellId;
	if (isBossBuff) then
		name, icon, count, debuffType, duration, expirationTime, unitCaster, canStealOrPurge, _, spellId = UnitBuff(unit,
			index, filter);
	else
		name, icon, count, debuffType, duration, expirationTime, unitCaster, canStealOrPurge, _, spellId = UnitDebuff(
		unit, index, filter);
	end

	debuffFrame.icon:SetTexture(icon);
	if (count > 1) then
		local countText = count;
		if (count >= 100) then
			countText = BUFF_STACKS_OVERFLOW;
		end
		debuffFrame.count:Show();
		debuffFrame.count:SetText(countText);
	else
		debuffFrame.count:Hide();
	end
	debuffFrame:SetID(index);
	debuffFrame.filter = filter;
	debuffFrame.unit = unit;
	local enabled = expirationTime and expirationTime ~= 0;
	if enabled then
		local startTime = expirationTime - duration;
		asCooldownFrame_Set(debuffFrame.cooldown, startTime, duration, true);
	else
		asCooldownFrame_Clear(debuffFrame.cooldown);
	end

	local color = DebuffTypeColor[debuffType] or DebuffTypeColor["none"];
	debuffFrame.border:SetVertexColor(color.r, color.g, color.b);

	debuffFrame.isBossBuff = isBossBuff;

	if (isBossAura) then
		debuffFrame:SetSize((debuffFrame.size_x) * 1.3, debuffFrame.size_y * 1.3);
	else
		debuffFrame:SetSize(debuffFrame.size_x, debuffFrame.size_y);
	end

	debuffFrame:Show();
end

local function asCompactUnitFrame_UtilIsBossAura(unit, index, filter, checkAsBuff)
	-- make sure you are using the correct index here!	allAurasIndex ~= debuffIndex
	local name, icon, count, debuffType, duration, expirationTime, unitCaster, canStealOrPurge, _, spellId, canApplyAura, isBossAura, nameplateShowAll;
	if (checkAsBuff) then
		name, icon, count, debuffType, duration, expirationTime, unitCaster, canStealOrPurge, _, spellId, canApplyAura, isBossAura =
		UnitBuff(unit, index, filter);
	else
		name, icon, count, debuffType, duration, expirationTime, unitCaster, canStealOrPurge, _, spellId, canApplyAura, isBossAura, _, nameplateShowAll =
		UnitDebuff(unit, index, filter);
	end

	return isBossAura or nameplateShowAll;
end

local function asCompactUnitFrame_UtilShouldDisplayDebuff(unit, index, filter)
	local name, icon, count, debuffType, duration, expirationTime, unitCaster, canStealOrPurge, _, spellId, canApplyAura, isBossAura, _, nameplateShowAll =
	UnitDebuff(unit, index, filter);


	if ACRB_BlackList and ACRB_BlackList[name] then
		return false;
	end

	if nameplateShowAll then
		return true;
	end


	local hasCustom, alwaysShowMine, showForMySpec = SpellGetVisibilityInfo(spellId,
		UnitAffectingCombat("player") and "RAID_INCOMBAT" or "RAID_OUTOFCOMBAT");
	if (hasCustom) then
		return showForMySpec or
		(alwaysShowMine and (unitCaster == "player" or unitCaster == "pet" or unitCaster == "vehicle"));                    --Would only be "mine" in the case of something like forbearance.
	else
		return true;
	end
end

local function asCompactUnitFrame_UtilIsPriorityDebuff(unit, index, filter)
	local name, icon, count, debuffType, duration, expirationTime, unitCaster, canStealOrPurge, _, spellId, canApplyAura, isBossAura =
	UnitDebuff(unit, index, filter);

	local _, classFilename = UnitClass("player");
	if (classFilename == "PALADIN") then
		if (spellId == 25771) then --Forbearance
			return true;
		end
	elseif (classFilename == "PRIEST") then
		if (spellId == 6788) then --Weakened Soul
			return true;
		end
	end
	return false;
end

local function asCompactUnitFrame_UpdateDebuffs(asframe)
	if (not asframe.asdebuffFrames) then
		return;
	end


	local unit = asframe.displayedUnit;

	if not (unit) then
		return;
	end


	local index = 1;
	local frameNum = 1;
	local filter = nil;
	local maxDebuffs = ACRB_MAX_DEBUFFS;
	--Show both Boss buffs & debuffs in the debuff location
	--First, we go through all the debuffs looking for any boss flagged ones.
	while (frameNum <= maxDebuffs) do
		local debuffName = UnitDebuff(unit, index, filter);
		if (debuffName) then
			if (asCompactUnitFrame_UtilIsBossAura(unit, index, filter, false)) then
				local debuffFrame = asframe.asdebuffFrames[frameNum];
				asCompactUnitFrame_UtilSetDebuff(debuffFrame, unit, index, filter, true, false);
				frameNum = frameNum + 1;
				--Boss debuffs are about twice as big as normal debuffs, so display one less.
				local bossDebuffScale = 1.3;
				maxDebuffs = maxDebuffs - (bossDebuffScale - 1);
			end
		else
			break;
		end
		index = index + 1;
	end
	--Then we go through all the buffs looking for any boss flagged ones.
	index = 1;
	while (frameNum <= maxDebuffs) do
		local debuffName = UnitBuff(unit, index, filter);
		if (debuffName) then
			if (asCompactUnitFrame_UtilIsBossAura(unit, index, filter, true)) then
				local debuffFrame = asframe.asdebuffFrames[frameNum];
				asCompactUnitFrame_UtilSetDebuff(debuffFrame, unit, index, filter, true, true);
				frameNum = frameNum + 1;
				--Boss debuffs are about twice as big as normal debuffs, so display one less.
				local bossDebuffScale = 1.3;
				maxDebuffs = maxDebuffs - (bossDebuffScale - 1);
			end
		else
			break;
		end
		index = index + 1;
	end

	--Now we go through the debuffs with a priority (e.g. Weakened Soul and Forbearance)
	index = 1;
	while (frameNum <= maxDebuffs) do
		local debuffName = UnitDebuff(unit, index, filter);
		if (debuffName) then
			if (asCompactUnitFrame_UtilIsPriorityDebuff(unit, index, filter)) then
				local debuffFrame = asframe.asdebuffFrames[frameNum];
				asCompactUnitFrame_UtilSetDebuff(debuffFrame, unit, index, filter, false, false);

				frameNum = frameNum + 1;
			end
		else
			break;
		end
		index = index + 1;
	end


	index = 1;
	--Now, we display all normal debuffs.
	while (frameNum <= maxDebuffs) do
		local debuffName = UnitDebuff(unit, index, filter);
		if (debuffName) then
			if (asCompactUnitFrame_UtilShouldDisplayDebuff(unit, index, filter) and not asCompactUnitFrame_UtilIsBossAura(unit, index, filter, false) and
					not asCompactUnitFrame_UtilIsPriorityDebuff(unit, index, filter)) then
				local debuffFrame = asframe.asdebuffFrames[frameNum];
				asCompactUnitFrame_UtilSetDebuff(debuffFrame, unit, index, filter, false, false);
				frameNum = frameNum + 1;
			end
		else
			break;
		end
		index = index + 1;
	end

	for i = frameNum, ACRB_MAX_DEBUFFS do
		local debuffFrame = asframe.asdebuffFrames[i];
		debuffFrame:Hide();
	end
end

-- 해제 디버프

local dispellableDebuffTypes = { Magic = true, Curse = true, Disease = true, Poison = true };
local function asCompactUnitFrame_UpdateDispellableDebuffs(asframe)
	if not asframe.asdispelDebuffFrames then
		return;
	end

	local showdispell = false;

	local unit = asframe.displayedUnit;

	if not (unit) then
		return;
	end



	--Clear what we currently have.
	for debuffType, display in pairs(dispellableDebuffTypes) do
		if (display) then
			asframe["ashasDispel" .. debuffType] = false;
		end
	end

	local index = 1;
	local frameNum = 1;
	local filter = "RAID"; --Only dispellable debuffs.
	while (frameNum <= ACRB_MAX_DISPELDEBUFFS) do
		local name, icon, count, debuffType, duration, expirationTime, unitCaster, canStealOrPurge, _, spellId =
		UnitDebuff(unit, index, filter);

		if (dispellableDebuffTypes[debuffType] and not asframe["ashasDispel" .. debuffType]) then
			asframe["ashasDispel" .. debuffType] = true;
			local dispellDebuffFrame = asframe.asdispelDebuffFrames[frameNum];
			asCompactUnitFrame_UtilSetDispelDebuff(dispellDebuffFrame, debuffType, index)

			showdispell = true;

			local color = DebuffTypeColor[debuffType] or DebuffTypeColor["none"];

			if not asframe.isDispellAlert then
				lib.PixelGlow_Start(asframe.frame, { color.r, color.g, color.b, 1 })
				asframe.isDispellAlert = true;
			end

			frameNum = frameNum + 1;
		elseif (not name) then
			break;
		end
		index = index + 1;
	end
	for i = frameNum, ACRB_MAX_DISPELDEBUFFS do
		local dispellDebuffFrame = asframe.asdispelDebuffFrames[i];
		dispellDebuffFrame:Hide();
	end

	if showdispell == false then
		if asframe.isDispellAlert then
			lib.PixelGlow_Stop(asframe.frame);
			asframe.isDispellAlert = false;
		end
	end
end



local function asCompactUnitFrame_UpdateHealerMana(asframe)
	if (not asframe.asManabar) then
		return;
	end

	local unit = asframe.displayedUnit

	if not (unit) then
		return;
	end

	local role = UnitGroupRolesAssigned(unit)


	if role == "HEALER" then
		asframe.asManabar:SetMinMaxValues(0, UnitPowerMax(unit, Enum.PowerType.Mana))
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
end

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

local function ACRB_DisplayRaidIcon(unit)
	local icon = GetRaidTargetIndex(unit)
	if icon and RaidIconList[icon] then
		return RaidIconList[icon] .. "0|t"
	else
		return ""
	end
end


local function asCompactUnitFrame_UpdateBuffsPVP(asframe)
	local unit = asframe.displayedUnit


	if not (unit) then
		return;
	end


	if (asframe.asraidicon) then
		local text = ACRB_DisplayRaidIcon(unit);
		asframe.asraidicon:SetText(text);
		asframe.asraidicon:Show();
	end

	if (asframe.buffFrames2) then
		local index = 1;
		local frameNum = 1;
		local filter = nil;
		while (frameNum <= ACRB_MAX_BUFFS_2) do
			local buffName = UnitBuff(unit, index, filter);
			if (buffName) then
				if (asCompactUnitFrame_UtilShouldDisplayBuff(unit, index, filter)) then
					local buffFrame = asframe.buffFrames2[frameNum];
					asCompactUnitFrame_UtilSetBuff(buffFrame, unit, index, filter);
					frameNum = frameNum + 1;
				end
			else
				break;
			end
			index = index + 1;
		end
		for i = frameNum, ACRB_MAX_BUFFS_2 do
			local buffFrame = asframe.buffFrames2[i];
			if buffFrame then
				buffFrame:Hide();
			end
		end
	end
end

local tanklist = {};
local together = nil;
-- 탱커 처리부
local function updateTankerList()
	local bInstance, RTB_ZoneType = IsInInstance();

	if RTB_ZoneType == "pvp" or RTB_ZoneType == "arena" then
		return nil;
	end

	tanklist = table.wipe(tanklist)
	if IsInGroup() then
		if IsInRaid() then -- raid
			if together == true then
				for i = 1, 8 do
					for k = 1, 5 do
						local framename = "CompactRaidGroup" .. i .. "Member" .. k
						local asframe = asraid[framename]
						if asframe and asframe.displayedUnit then
							local assignedRole = UnitGroupRolesAssigned(asframe.displayedUnit);
							if assignedRole == "TANK" then
								table.insert(tanklist, framename);
							end
						end
					end
				end
			else
				for i = 1, 40 do
					local framename = "CompactRaidFrame" .. i
					local asframe = asraid[framename]
					if asframe and asframe.displayedUnit then
						local assignedRole = UnitGroupRolesAssigned(asframe.displayedUnit);
						if assignedRole == "TANK" then
							table.insert(tanklist, framename);
						end
					end
				end
			end

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
			for i = 1, 5 do
				local framename = "CompactPartyFrameMember" .. i
				local asframe = asraid[framename]
				if asframe and asframe.displayedUnit then
					local assignedRole = UnitGroupRolesAssigned(asframe.displayedUnit);
					if assignedRole == "TANK" then
						table.insert(tanklist, framename);
					end
				end
			end
		end
	end
end

local function asCompactUnitFrame_HideAllBuffs(frame, startingIndex)
	if frame.buffFrames then
		for i = startingIndex or 1, #frame.buffFrames do
			frame.buffFrames[i]:SetAlpha(0);
			frame.buffFrames[i]:Hide();
		end
	end
end

local function asCompactUnitFrame_HideAllDebuffs(frame, startingIndex)
	if frame.debuffFrames then
		for i = startingIndex or 1, #frame.debuffFrames do
			frame.debuffFrames[i]:SetAlpha(0);
			frame.debuffFrames[i]:Hide();
		end
	end
end

local function asCompactUnitFrame_HideAllDispelDebuffs(frame, startingIndex)
	if frame.dispelDebuffFrames then
		for i = startingIndex or 1, #frame.dispelDebuffFrames do
			frame.dispelDebuffFrames[i]:SetAlpha(0);
			frame.dispelDebuffFrames[i]:Hide();
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

		asCompactUnitFrame_HideAllBuffs(frame);
		asCompactUnitFrame_HideAllDebuffs(frame)
		asCompactUnitFrame_HideAllDispelDebuffs(frame);
	end
end

local function ACRB_updateAllBuff(asframe)
	if asframe and asframe.frame and asframe.frame:IsShown() then
		asCompactUnitFrame_UpdateBuffs(asframe);
		asCompactUnitFrame_UpdateBuffsPVP(asframe);
	end
end


local function ACRB_updateAllDebuff(asframe)
	if asframe and asframe.frame and asframe.frame:IsShown() then
		asCompactUnitFrame_UpdateDebuffs(asframe);
		asCompactUnitFrame_UpdateDispellableDebuffs(asframe);
		asframe.ncasting = 0;
	end
end


local function ACRB_updateAllHealerMana(asframe)
	if asframe and asframe.frame and asframe.frame:IsShown() then
		asCompactUnitFrame_UpdateHealerMana(asframe);
	end
end


local function ACRB_updatePartyAllBuff()
	if (IsInGroup() or (ACRB_ShowWhenSolo)) then
		if IsInRaid() then -- raid
			if together == true then
				for i = 1, 8 do
					for k = 1, 5 do
						local asframe = asraid["CompactRaidGroup" .. i .. "Member" .. k]
						ACRB_updateAllBuff(asframe);
					end
				end
			else
				for i = 1, 40 do
					local asframe = asraid["CompactRaidFrame" .. i]
					ACRB_updateAllBuff(asframe);
				end
			end
		else -- party
			for i = 1, 5 do
				local asframe = asraid["CompactPartyFrameMember" .. i]
				ACRB_updateAllBuff(asframe);
			end
		end
	end
end


local function ACRB_updatePartyAllDebuff()
	if (IsInGroup() or (ACRB_ShowWhenSolo)) then
		if IsInRaid() then -- raid
			if together == true then
				for i = 1, 8 do
					for k = 1, 5 do
						local asframe = asraid["CompactRaidGroup" .. i .. "Member" .. k]
						ACRB_updateAllDebuff(asframe);
					end
				end
			else
				for i = 1, 40 do
					local asframe = asraid["CompactRaidFrame" .. i]
					ACRB_updateAllDebuff(asframe);
				end
			end
		else -- party
			for i = 1, 5 do
				local asframe = asraid["CompactPartyFrameMember" .. i]
				ACRB_updateAllDebuff(asframe);
			end
		end
	end
end


local function ACRB_updatePartyAllHealerMana()
	if (IsInGroup() or (ACRB_ShowWhenSolo)) then
		if IsInRaid() then -- raid
			if together == true then
				for i = 1, 8 do
					for k = 1, 5 do
						local asframe = asraid["CompactRaidGroup" .. i .. "Member" .. k]
						ACRB_updateAllHealerMana(asframe);
					end
				end
			else
				for i = 1, 40 do
					local asframe = asraid["CompactRaidFrame" .. i]
					ACRB_updateAllHealerMana(asframe);
				end
			end
		else -- party
			for i = 1, 5 do
				local asframe = asraid["CompactPartyFrameMember" .. i]
				ACRB_updateAllHealerMana(asframe);
			end
		end
	end
end


local function ACRB_DisableAura()
	if (IsInGroup() or (ACRB_ShowWhenSolo)) then
		if IsInRaid() then -- raid
			if together == true then
				for i = 1, 8 do
					for k = 1, 5 do
						local frame = _G["CompactRaidGroup" .. i .. "Member" .. k]
						ACRB_disableDefault(frame);
					end
				end
			else
				for i = 1, 40 do
					local frame = _G["CompactRaidFrame" .. i]
					ACRB_disableDefault(frame);
				end
			end
		else -- party
			for i = 1, 5 do
				local frame = _G["CompactPartyFrameMember" .. i]
				ACRB_disableDefault(frame);
			end
		end
	end
end

local ACRB_DangerousSpellList = {};

local function ACRB_updateCasting(asframe, unit)
	if asframe and asframe.frame and asframe.frame:IsShown() then
		local index = asframe.ncasting + 1;
		local castFrame = asframe.castFrames[index];

		if asframe.displayedUnit and UnitIsUnit(unit .. "target", asframe.displayedUnit) then
			local name, text, texture, startTime, endTime, isTradeSkill, castID, notInterruptible, spellid =
			UnitCastingInfo(unit);
			if not name then
				name, text, texture, startTime, endTime, isTradeSkill, notInterruptible, spellid = UnitChannelInfo(unit);
			end

			if name and asframe.castFrames and index <= #(asframe.castFrames) then
				castFrame.icon:SetTexture(texture);
				castFrame.count:Hide();

				local curr = GetTime();
				local start = startTime / 1000;
				local duration = (endTime / 1000) - start;

				asCooldownFrame_Set(castFrame.cooldown, start, duration, true);

				if ACRB_DangerousSpellList[spellid] then
					lib.PixelGlow_Start(castFrame);
				else
					lib.PixelGlow_Stop(castFrame);
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

local function asCompactUnitFrame_HideCast(asframe)
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

	if not nameplate.UnitFrame or nameplate.UnitFrame:IsForbidden() then
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
				if IsInRaid() then -- raid
					if together == true then
						for i = 1, 8 do
							for k = 1, 5 do
								local asframe = asraid["CompactRaidGroup" .. i .. "Member" .. k]
								if ACRB_updateCasting(asframe, unit) then
									return;
								end
							end
						end
					else
						for i = 1, 40 do
							local asframe = asraid["CompactRaidFrame" .. i]
							if ACRB_updateCasting(asframe, unit) then
								return;
							end
						end
					end
				else -- party
					for i = 1, 5 do
						local asframe = asraid["CompactPartyFrameMember" .. i]
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
	for _, v in pairs(C_NamePlate.GetNamePlates(issecure())) do
		local nameplate = v;
		if (nameplate) then
			CheckCasting(nameplate);
		end
	end

	if (IsInGroup()) then
		if IsInRaid() then -- raid
			if together == true then
				for i = 1, 8 do
					for k = 1, 5 do
						local asframe = asraid["CompactRaidGroup" .. i .. "Member" .. k]
						asCompactUnitFrame_HideCast(asframe);
					end
				end
			else
				for i = 1, 40 do
					local asframe = asraid["CompactRaidFrame" .. i]
					asCompactUnitFrame_HideCast(asframe);
				end
			end
		else -- party
			for i = 1, 5 do
				local asframe = asraid["CompactPartyFrameMember" .. i]
				asCompactUnitFrame_HideCast(asframe);
			end
		end
	end
end

function ACTA_DBMTimer_callback(event, id, ...)
	local msg, timer, icon, type, spellId, colorId, modid, keep, fade, name, guid = ...;
	if spellId then
		ACRB_DangerousSpellList[spellId] = true;
	end
end

local mustdisable = true;



local function ACRB_OnUpdate()
	if mustdisable then
		mustdisable = false;
		together = EditModeManagerFrame:ShouldRaidFrameShowSeparateGroups();
		if together == nil then
			together = true;
		end
		ACRB_DisableAura();
	end

	ACRB_updatePartyAllBuff();
	ACRB_updatePartyAllDebuff();
	ACRB_updatePartyAllHealerMana();
	ACRB_CheckCasting();
end

local function ACRB_OnEvent(self, event, ...)
	local arg1 = ...;

	if event == "UNIT_SPELLCAST_SUCCEEDED" and arg1 == "player" then
		--CPU 사용률 감소
		--ACRB_updatePartyAllBuff();
	elseif (event == "PLAYER_ENTERING_WORLD") then
		ACRB_InitList();
		mustdisable = true;

		local bloaded = LoadAddOn("DBM-Core");
		if bloaded then
			DBM:RegisterCallback("DBM_TimerStart", ACTA_DBMTimer_callback);
		end
		updateTankerList();
	elseif (event == "ACTIVE_TALENT_GROUP_CHANGED") then
		ACRB_InitList();
	elseif (event == "GROUP_ROSTER_UPDATE") or (event == "CVAR_UPDATE") or (event == "ROLE_CHANGED_INFORM") then
		updateTankerList();
		mustdisable = true;
	elseif (event == "COMPACT_UNIT_FRAME_PROFILES_LOADED") then
		together = EditModeManagerFrame:ShouldRaidFrameShowSeparateGroups();
		if together == nil then
			together = true;
		end
	end
end

local function asCompactUnitFrame_UpdateAll(frame)
	if frame and not frame:IsForbidden() and frame.GetName then
		local name = frame:GetName();

		if name and not (name == nil) and (string.find(name, "CompactRaidGroup") or string.find(name, "CompactPartyFrameMember") or string.find(name, "CompactRaidFrame")) then
			ACRB_disableDefault(frame);
			ACRB_setupFrame(frame);
			mustdisable = true;
		end
	end
end

local ACRB_mainframe = CreateFrame("Frame", nil, UIParent);
ACRB_mainframe:SetScript("OnEvent", ACRB_OnEvent)
ACRB_mainframe:RegisterEvent("GROUP_ROSTER_UPDATE");
ACRB_mainframe:RegisterEvent("PLAYER_ENTERING_WORLD");
--ACRB_mainframe:RegisterUnitEvent("UNIT_SPELLCAST_SUCCEEDED", "player");
ACRB_mainframe:RegisterEvent("ACTIVE_TALENT_GROUP_CHANGED");
ACRB_mainframe:RegisterEvent("CVAR_UPDATE");
ACRB_mainframe:RegisterEvent("ROLE_CHANGED_INFORM");
ACRB_mainframe:RegisterEvent("COMPACT_UNIT_FRAME_PROFILES_LOADED");
ACRB_mainframe:RegisterEvent("VARIABLES_LOADED");

C_Timer.NewTicker(ACRB_UpdateRate, ACRB_OnUpdate);

hooksecurefunc("CompactUnitFrame_UpdateAll", asCompactUnitFrame_UpdateAll);
