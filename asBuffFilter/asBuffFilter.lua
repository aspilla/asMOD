local ABF;
local ABF_PLAYER_BUFF;
local ABF_TARGET_BUFF;
local ABF_SIZE = 28;
local ABF_TARGET_BUFF_X = 73 + 30 + 20;
local ABF_TARGET_BUFF_Y = -142;
local ABF_PLAYER_BUFF_X = -73 - 30 - 20;
local ABF_PLAYER_BUFF_Y = -142;
local ABF_MAX_BUFF_SHOW = 7;
local ABF_ALPHA = 1;
local ABF_CooldownFontSize = 12;  -- Cooldown Font Size
local ABF_CountFontSize = 11;     -- Count Font Size
local ABF_AlphaCombat = 1;        -- 전투중 Alpha 값
local ABF_AlphaNormal = 0.5;      -- 비 전투중 Alpha 값
local ABF_MAX_Cool = 60;          -- 최대 60초의 버프를 보임
local ABF_RefreshRate = 0.2;      -- Target Buff Check 주기 (초)
local ABF_ShowTalentList = false; -- 중앙 Talent Buff List 를 무조건 보이게 (Powerbar가 있으면 보임)

local PLAYER_UNITS = {
	player = true,
	vehicle = true,
	pet = true,
};

local ABF_BlackList = {
	--	["문양: 기사단의 선고"] = 1,
	--	["문양: 이중 판결"] = 1,
	--	["관대한 치유사"] = 1,
	--	["법의 위세"] = 1,
	--	["피의 광기"] = 1,

}

local ABF_ShowList;
local b_showlist = false;

-- 특정한 버프만 보이게 하려면 직업별로 편집
-- ABF_ShowList_직업명_특성
--ABF_ShowList_PALADIN_3 = {
--	["심문"] = 1,	
--}


local ABF_StackBuffList = {
	--["비전의 조화"] = 1,
}

-- 발동 주요 공격 버프
-- 보이게만 할려면 2, 강조하려면 1
local ABF_ProcBuffList = {
	--블러드
	["시간 왜곡"] = 1,
	["영웅심"] = 1,
	["피의 욕망"] = 1,
	["황천바람"] = 1,
	["고대의 격분"] = 1,
	["위상의 격노"] = 1,
	["쾌활한 생기화"] = 2,
	["넬타루스의 전리품"] = 2,
}


local ABF_Current_Buff = "";
local ABF_Current_Count = 0;

-- PVP Buff List
--
local ABF_PVPBuffList = {

	--생존기 시작 (용군단 Update 완료)
	--기원사
	[357170] = 1, --시간 팽창
	[363916] = 1, --흑요석 비늘
	[374348] = 1, --소생의 불길
	[363534] = 1, --되돌리기
	[370960] = 1, --애매랄드 교감
	[378441] = 1, --시간정지

	--전사
	[236273] = 1, --결투
	[118038] = 1, --투사의 혼
	[12975] = 1, --최후의 저항
	[871] = 1, --방패의 벽
	[97463] = 1, --재집결의 함성
	[184364] = 1, --격노의 재생력
	[386394] = 1, --역전의 용사
	[392966] = 1, --주문막기

	--도적
	[185311] = 1, --진홍색 약병
	[11327] = 1, --소멸
	[31224] = 1, --그림자 망토
	[31230] = 1, --구사일생
	[5277] = 1, --회피

	--악사
	[212800] = 1, --흐릿해지기
	[187827] = 1, --탈태
	[206803] = 1, --하늘에서 내리는 비
	[196555] = 1, --황천걸음
	[209426] = 1, --어둠


	--수도
	[202162] = 1, --해악방지
	[116849] = 1, --기의고치
	[322507] = 1, --천신주
	[115203] = 1, --강화주
	[122783] = 1, --마법해소
	[122278] = 1, --해악감퇴
	[132578] = 1, --흑우의 원령
	[115176] = 1, --명상
	[125174] = 1, --업보의 손아귀

	--죽기
	[51052] = 1, --대마법지대
	[48707] = 1, --대마법 보호막
	[48743] = 1, --죽음의 서약
	[48792] = 1, --얼음같은 인내력
	[114556] = 1, --연옥
	[81256] = 1, --춤추는 룬무기
	[219809] = 1, --묘비
	[55233] = 1, --흡혈

	--사냥꾼
	[53480] = 1, --희생의 표효
	[109304] = 1, --활기
	[264735] = 1, --적자 생존
	[186265] = 1, --거북의 상

	--성기사
	[228049] = 1, --잊힌 여왕의 수호자
	[642] = 1, --천상의 보호막
	[31850] = 1, --헌신적인 수호자
	[86659] = 1, --고대 왕의 수호자
	[327193] = 1, --영광의 순간
	[205191] = 1, --눈에는 눈
	[498] = 1, --신의 가호
	[31821] = 1, --오라 숙련
	[6940] = 1, --희생의 축복
	[1022] = 1, --보호의 축복
	[204018] = 1, --주문수호의 축복

	--주술사
	[210918] = 1, -- 에테리얼 형상
	[108271] = 1, --영혼-이동
	[108281] = 1, --고대의 인도

	--마법사
	[45438] = 1, --얼음 방패
	[198111] = 1, --시간의 보호막
	[110959] = 1, --상급 투명화
	[342246] = 1, --시간돌리기
	[55342] = 1, --환영복제
	--드루이드
	[305497] = 1, --가시
	[354654] = 1, --숲의 보호
	[22812] = 1, --나무 껍질
	[157982] = 1, --평온
	[102342] = 1, --무쇠 껍질
	[61336] = 1, --생존본능
	[200851] = 1, --잠자는-자의-분노

	--흑마법사
	[104773] = 1, --영원한 결의
	[108416] = 1, --어둠의 서약

	--사제
	[215769] = 1, --구원의 영혼
	[328530] = 1, --신속한 승천
	[197268] = 1, --희망의 빛줄기
	[19236] = 1, --구원의 기도
	[81782] = 1, --신의 권능 방벽
	[33206] = 1, --고통억제
	[64843] = 1, --천상의 찬가
	[47788] = 1, --수호영혼
	[47585] = 1, --분산

	--공격버프 시작 (용군단 Update 필요)
	-- Mage
	[80353] = 2, --Timewarp
	[12042] = 2, --Arcane Power
	[190319] = 2, --Combustion - burst
	[12472] = 2, --Icy Veins
	[82691] = 2, --Ring of frost
	[198144] = 2, --Ice form (pvp)
	[86949] = 2, --Cauterize

	-- DK
	[47476] = 2, --Strangulate (pvp) - silence
	[116888] = 2, --Shroud of Purgatory

	-- Shaman
	[32182] = 2, --Heroism
	[2825] = 2, --Bloodlust
	[16166] = 2, --Elemental Mastery - burst
	[204288] = 2, --Earth Shield
	[114050] = 2, --Ascendance

	-- Druid
	[106951] = 2, --Berserk - burst
	[102543] = 2, --Incarnation: King of the Jungle - burst
	[102560] = 2, --Incarnation: Chosen of Elune - burst
	[33891] = 2, --Incarnation: Tree of Life
	[1850] = 2, --Dash
	[194223] = 2, --Celestial Alignment - burst
	[78675] = 2, --Solar beam
	[77761] = 2, --Stampeding Roar
	[102793] = 2, --Ursol's Vortex
	[339] = 2, --Entangling Roots
	[102359] = 2, --Mass Entanglement
	[22570] = 2, --Maim

	-- Paladin
	[1044] = 2, --Blessing of Freedom
	[31884] = 2, --Avenging Wrath
	[224668] = 2, --Crusade
	[216331] = 2, --Avenging Crusader
	[20066] = 2, --Repentance
	[184662] = 2, --Shield of Vengeance
	[53563] = 2, --Beacon of Light
	[156910] = 2, --Beacon of Faith
	[115750] = 2, --Blinding Light

	-- Warrior
	[1719] = 2, --Battle Cry
	[23920] = 2, --Spell Reflection
	[46968] = 2, --Shockwave
	[18499] = 2, --Berserker Rage
	[107574] = 2, --Avatar
	[213915] = 2, --Mass Spell Reflection
	[46924] = 2, --Bladestorm
	[12292] = 2, --Bloodbath
	[199261] = 2, --Death Wish
	[107570] = 2, --Storm Bolt

	-- Rogue
	[45182] = 2, --Cheating Death
	[2983] = 2, --Sprint
	[121471] = 2, --Shadow Blades
	[1966] = 2, --Feint
	[212182] = 2, --Smoke Bomb
	[13750] = 2, --Adrenaline Rush
	[199754] = 2, --Riposte
	[198529] = 2, --Plunder Armor
	[199804] = 2, --Between the Eyes
	[1833] = 2, --Cheap Shot
	[1776] = 2, --Gouge
	[408] = 2, --Kidney Shot

	-- Hunter
	[117526] = 2, --Binding Shot
	[209790] = 2, --Freezing Arrow
	[213691] = 2, --Scatter Shot
	[3355] = 2, --Freezing Trap
	[162480] = 2, -- Steel Trap
	[19574] = 2, --Bestial Wrath
	[193526] = 2, --Trueshot
	[19577] = 2, --Intimidation
	[90355] = 2, --Ancient Hysteria
	[160452] = 2, --Netherwinds

	-- Monk
	[119381] = 2, --Leg Sweep

	-- Priest
	[10060] = 2, --Power Infusion
	[9484] = 2, --Shackle Undead
	[200183] = 2, --Apotheosis
	[15487] = 2, --Silence
	[15286] = 2, --Vampiric Embrace
	[193223] = 2, --Surrender to Madness
	[88625] = 2, --Holy Word: Chastise

	-- Warlock
	[196098] = 2, --Soul Harvest
	[30283] = 2, --Shadowfury

	-- Demon Hunter
	[198589] = 2, --Blur
	[179057] = 2, --Chaos Nova
	[217832] = 2, --Imprison
	[206491] = 2, --Nemesis
	[211048] = 2, --Chaos Blades
	[207685] = 2, --Sigil of Misery
	[209261] = 2, --Last Resort (cd)
	[207810] = 2, --Nether Bond

	----
	[2335] = 2, --Swiftness Potion
	[6624] = 2, --Free Action Potion
	[67867] = 2, --Trampled (ToC arena spell when you run over someone)

}



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
	frame.ants:SetSize(frameWidth * 0.9, frameHeight * 0.9)
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

local ButtonGlowTextures = {
	["spark"] = true,
	["innerGlow"] = true,
	["innerGlowOver"] = true,
	["outerGlow"] = true,
	["outerGlowOver"] = true,
	["ants"] = true
}

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




local _G = _G;

local ABF_TalentBuffList = {};
local IsPowerbar = LoadAddOn("asPowerBar");



--AuraUtil

local DispellableDebuffTypes =
{
	Magic = true,
	Curse = true,
	Disease = true,
	Poison = true
};


local AuraUpdateChangedType = EnumUtil.MakeEnum(
	"None",
	"Debuff",
	"Buff",
	"PVP",
	"Dispel"
);

local UnitFrameBuffType = EnumUtil.MakeEnum(
	"BossBuff",
	"PriorityBuff",
	"TalentBuff",
	"ShouldShowBuff",
	"Normal"
);



local AuraFilters =
{
	Helpful = "HELPFUL",
	Harmful = "HARMFUL",
	Raid = "RAID",
	IncludeNameplateOnly = "INCLUDE_NAME_PLATE_ONLY",
	Player = "PLAYER",
	Cancelable = "CANCELABLE",
	NotCancelable = "NOT_CANCELABLE",
	Maw = "MAW",
};

local function CreateFilterString(...)
	return table.concat({ ... }, '|');
end

local function DefaultAuraCompare(a, b)
	local aFromPlayer = (a.sourceUnit ~= nil) and UnitIsUnit("player", a.sourceUnit) or false;
	local bFromPlayer = (b.sourceUnit ~= nil) and UnitIsUnit("player", b.sourceUnit) or false;
	if aFromPlayer ~= bFromPlayer then
		return aFromPlayer;
	end

	if a.canApplyAura ~= b.canApplyAura then
		return a.canApplyAura;
	end

	return a.spellId < b.spellId
end

local function UnitFrameBuffComparator(a, b)
	if a.buffType ~= b.buffType then
		return a.buffType < b.buffType;
	end

	return DefaultAuraCompare(a, b);
end


local function ForEachAuraHelper(unit, filter, func, usePackedAura, continuationToken, ...)
	-- continuationToken is the first return value of UnitAuraSlots()
	local n = select('#', ...);
	for i = 1, n do
		local slot = select(i, ...);
		local done;
		if usePackedAura then
			local auraInfo = C_UnitAuras.GetAuraDataBySlot(unit, slot);
			done = func(auraInfo);
		else
			done = func(UnitAuraBySlot(unit, slot));
		end
		if done then
			-- if func returns true then no further slots are needed, so don't return continuationToken
			return nil;
		end
	end
	return continuationToken;
end
local function ForEachAura(unit, filter, maxCount, func, usePackedAura)
	if maxCount and maxCount <= 0 then
		return;
	end
	local continuationToken;
	repeat
		-- continuationToken is the first return value of UnitAuraSltos
		continuationToken = ForEachAuraHelper(unit, filter, func, usePackedAura,
			UnitAuraSlots(unit, filter, maxCount, continuationToken));
	until continuationToken == nil;
end



local filter = CreateFilterString(AuraFilters.Helpful);


local function scanSpells(tab)
	local tabName, tabTexture, tabOffset, numEntries = GetSpellTabInfo(tab)

	if not tabName then
		return;
	end

	for i = tabOffset + 1, tabOffset + numEntries do
		local spellName, _, spellID = GetSpellBookItemName(i, BOOKTYPE_SPELL)
		local _, _, icon = GetSpellInfo(spellID);
		if not spellName then
			do break end
		end

		ABF_TalentBuffList[spellName] = true;
		ABF_TalentBuffList[icon or 0] = true;
	end
end

local function asCheckTalent()
	table.wipe(ABF_TalentBuffList);

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
				ABF_TalentBuffList[talentName or ""] = true;
				ABF_TalentBuffList[icon or 0] = true;
				if definitionInfo.overrideName then
					--print (definitionInfo.overrideName)
					ABF_TalentBuffList[definitionInfo.overrideName] = true;
				end
			end
		end
	end
	scanSpells(2)
	scanSpells(3)
	return;
end


local function asCooldownFrame_Clear(self)
	self:Clear();
end

local overlayspell = {};

local function asCooldownFrame_Set(self, start, duration, enable, forceShowDrawEdge, modRate)
	if enable and enable ~= 0 and start > 0 and duration > 0 then
		self:SetDrawEdge(forceShowDrawEdge);
		self:SetCooldown(start, duration, modRate);
	else
		asCooldownFrame_Clear(self);
	end
end

local cachedVisualizationInfo = {};
local hasValidPlayer = false;

local function GetCachedVisibilityInfo(spellId)
	if cachedVisualizationInfo[spellId] == nil then
		local newInfo = {
			SpellGetVisibilityInfo(spellId, UnitAffectingCombat("player") and "RAID_INCOMBAT" or "RAID_OUTOFCOMBAT") };
		if not hasValidPlayer then
			-- Don't cache the info if the player is not valid since we didn't get a valid result
			return unpack(newInfo);
		end
		cachedVisualizationInfo[spellId] = newInfo;
	end

	local info = cachedVisualizationInfo[spellId];
	return unpack(info);
end


local cachedSelfBuffChecks = {};
local function CheckIsSelfBuff(spellId)
	if cachedSelfBuffChecks[spellId] == nil then
		cachedSelfBuffChecks[spellId] = SpellIsSelfBuff(spellId);
	end

	return cachedSelfBuffChecks[spellId];
end

local function DumpCaches()
	cachedVisualizationInfo = {};
	cachedSelfBuffChecks = {};
end

-- 버프 설정 부
local function IsShouldDisplayBuff(spellId, unitCaster, canApplyAura)
	local hasCustom, alwaysShowMine, showForMySpec = GetCachedVisibilityInfo(spellId);

	if (hasCustom) then
		return showForMySpec or
			(alwaysShowMine and (unitCaster == "player" or unitCaster == "pet" or unitCaster == "vehicle"));
	else
		return (unitCaster == "player" or unitCaster == "pet" or unitCaster == "vehicle") and canApplyAura and
			not CheckIsSelfBuff(spellId);
	end
end


local function IsShown(name, spellId)
	-- asPowerBar Check
	if APB_BUFF and APB_BUFF == name then
		return true;
	end

	if APB_BUFF2 and APB_BUFF2 == name then
		return true;
	end

	if APB_BUFF_COMBO and APB_BUFF_COMBO == name then
		return true;
	end

	if ACI_Buff_list and (ACI_Buff_list[name] or ACI_Buff_list[spellId]) then
		return true;
	end

	if overlayspell[spellId] then
		return true;
	end

	return false;
end

local activeBuffs = {};




local function ProcessAura(aura, unit)
	if aura == nil or aura.icon == nil or unit == nil or not aura.isHelpful then
		return AuraUpdateChangedType.None;
	end

	if IsShown(aura.name, aura.spellId) then
		return AuraUpdateChangedType.None;
	end

	if ABF_BlackList[aura.name] then
		return AuraUpdateChangedType.None;
	end

	local skip = true;
	if unit == "target" then
		if UnitIsPlayer("target") then
			skip = true;
			if UnitCanAssist("target", "player") then
				-- 우리편은 내가 시전한 Buff 보임
				if PLAYER_UNITS[aura.sourceUnit] and aura.duration > 0 and aura.duration <= ABF_MAX_Cool then
					skip = false;
				end
			end

			if aura.isStealable then
				skip = false;
			end

			-- PVP 주요 버프는 보임
			if (aura.name ~= nil and ABF_PVPBuffList[aura.spellId]) then
				skip = false;
			end
		else
			skip = false;
		end
	elseif unit == "player" then
		skip = true;
		if PLAYER_UNITS[aura.sourceUnit] and ((aura.duration > 0 and aura.duration <= ABF_MAX_Cool) or (aura.applications and aura.applications > 1)) then
			skip = false;
		end

		if aura.nameplateShowPersonal then
			skip = false;
		end

		if (aura.spellId ~= nil and ABF_PVPBuffList[aura.spellId]) then
			skip = false;
		end

		if ABF_ProcBuffList and ABF_ProcBuffList[aura.name] then
			skip = false;
		end
	end

	if skip == false then
		if aura.isBossAura and not aura.isRaid then
			aura.buffType = UnitFrameBuffType.BossBuff;
		elseif aura.nameplateShowPersonal then
			aura.buffType = UnitFrameBuffType.PriorityBuff;
		elseif IsShouldDisplayBuff(aura.spellId, aura.sourceUnit, aura.isFromPlayerOrPlayerPet) then
			aura.buffType = UnitFrameBuffType.Normal;
		elseif ABF_TalentBuffList[aura.name] == true or ABF_TalentBuffList[aura.icon] == true then
			aura.buffType = UnitFrameBuffType.TalentBuff;
		else
			aura.buffType = UnitFrameBuffType.Normal;
		end

		activeBuffs[unit][aura.auraInstanceID] = aura;
		return AuraUpdateChangedType.Buff;
	end


	return AuraUpdateChangedType.None;
end

local function ParseAllAuras(unit)
	if activeBuffs[unit] == nil then
		activeBuffs[unit] = TableUtil.CreatePriorityTable(UnitFrameBuffComparator,
			TableUtil.Constants.AssociativePriorityTable);
	else
		activeBuffs[unit]:Clear();
	end

	local function HandleAura(aura)
		ProcessAura(aura, unit);
		return false;
	end

	local batchCount = nil;
	local usePackedAura = true;
	ForEachAura(unit, filter, batchCount, HandleAura, usePackedAura);
end

local function updateTotemAura()
	local totem_i = 0;

	for slot = 1, MAX_TOTEMS do
		local haveTotem, name, start, duration, icon = GetTotemInfo(slot);

		if haveTotem and icon then
			if not (ACI_Buff_list and ACI_Buff_list[name]) then
				totem_i = totem_i + 1;
				local expirationTime = start + duration;
				local frame = ABF_TALENT_BUFF.frames[totem_i];

				-- set the icon
				local frameIcon = frame.icon;
				frameIcon:SetTexture(icon);
				frameIcon:SetAlpha(ABF_ALPHA);

				-- set the count
				local frameCount = frame.count;
				-- Handle cooldowns
				local frameCooldown = frame.cooldown;

				frameCount:Hide();

				if (duration > 0 and duration <= 120) then
					frameCooldown:Show();
					asCooldownFrame_Set(frameCooldown, expirationTime - duration, duration, duration > 0, true);
					frameCooldown:SetHideCountdownNumbers(false);
				else
					frameCooldown:Hide();
				end

				local frameBorder = frame.border;

				local color = { r = 0, g = 1, b = 0 };

				frameBorder:SetVertexColor(color.r, color.g, color.b);
				frameBorder:SetAlpha(ABF_ALPHA);
				frame:Show();
			end
		else
			return totem_i + 1;
		end
	end

	return totem_i + 1;
end

local function UpdateAuraFrames(unit, auraList)
	local i = 0;
	local parent = ABF_TARGET_BUFF;
	local numAuras = math.min(ABF_MAX_BUFF_SHOW, auraList:Size());
	local tcount = 1;
	local lcount = 1;
	local mparent = nil;

	if (unit == "player") then
		tcount = updateTotemAura();
		parent = ABF_PLAYER_BUFF;
		mparent = ABF_TALENT_BUFF;
		numAuras = math.min(ABF_MAX_BUFF_SHOW * 2, auraList:Size());
	end


	auraList:Iterate(
		function(auraInstanceID, aura)
			i = i + 1;
			if i > numAuras then
				return true;
			end

			local frame = nil;

			if mparent then
				if mparent and aura.buffType ~= UnitFrameBuffType.Normal and tcount < ABF_MAX_BUFF_SHOW then
					frame = mparent.frames[tcount];
					tcount = tcount + 1;
				elseif mparent and lcount < ABF_MAX_BUFF_SHOW then
					frame = parent.frames[lcount];
					lcount = lcount + 1;
				else
					return true;
				end
			else
				frame = parent.frames[i];
			end

			frame.unit = unit;
			frame.auraInstanceID = aura.auraInstanceID;

			-- set the icon
			local frameIcon = frame.icon
			frameIcon:SetTexture(aura.icon);
			frameIcon:SetAlpha(ABF_ALPHA);
			-- set the count
			local frameCount = frame.count;

			-- Handle cooldowns
			local frameCooldown = frame.cooldown;

			if (aura.applications and aura.applications > 1) then
				frameCount:SetText(aura.applications);
				frameCount:Show();
				frameCooldown:SetDrawSwipe(false);
			else
				frameCount:Hide();
				frameCooldown:SetDrawSwipe(true);
			end

			if (aura.duration > 0) then
				frameCooldown:Show();
				asCooldownFrame_Set(frameCooldown, aura.expirationTime - aura.duration, aura.duration, aura.duration > 0,
					true);
				frameCooldown:SetHideCountdownNumbers(false);
			else
				frameCooldown:Hide();
			end

			local frameBorder = frame.border;
			local color = DebuffTypeColor["Disease"];
			frameBorder:SetVertexColor(color.r, color.g, color.b);
			frameBorder:SetAlpha(ABF_ALPHA);

			if (aura.isStealable) or (ABF_ProcBuffList and ABF_ProcBuffList[aura.name] and ABF_ProcBuffList[aura.name] == 1) then
				lib.ButtonGlow_Start(frame);
			else
				lib.ButtonGlow_Stop(frame);

				if aura.nameplateShowPersonal then
					lib.PixelGlow_Start(frame);
				else
					lib.PixelGlow_Stop(frame);
				end
			end

			frame:Show();
			return false;
		end);

	local function HideFrame(p, idx)
		local frame = p.frames[idx];

		if (frame) then
			frame:Hide();
			lib.ButtonGlow_Stop(frame);
			lib.PixelGlow_Stop(frame);
		end
	end


	if mparent then
		for j = tcount, ABF_MAX_BUFF_SHOW do
			HideFrame(mparent, j);
		end
		for j = lcount, ABF_MAX_BUFF_SHOW do
			HideFrame(parent, j);
		end
	else
		for j = i + 1, ABF_MAX_BUFF_SHOW do
			HideFrame(parent, j);
		end
	end
end


local function UpdateAuras(unitAuraUpdateInfo, unit)
	local buffsChanged = false;

	if unitAuraUpdateInfo == nil or unitAuraUpdateInfo.isFullUpdate or activeBuffs[unit] == nil then
		ParseAllAuras(unit);
		buffsChanged = true;
	else
		if unitAuraUpdateInfo.addedAuras ~= nil then
			for _, aura in ipairs(unitAuraUpdateInfo.addedAuras) do
				local type = ProcessAura(aura, unit);
				if type == AuraUpdateChangedType.Buff then
					buffsChanged = true;
				end
			end
		end

		if unitAuraUpdateInfo.updatedAuraInstanceIDs ~= nil then
			for _, auraInstanceID in ipairs(unitAuraUpdateInfo.updatedAuraInstanceIDs) do
				local wasInBuff = activeBuffs[unit][auraInstanceID] ~= nil;
				if wasInBuff then
					local newAura = C_UnitAuras.GetAuraDataByAuraInstanceID(unit, auraInstanceID);
					activeBuffs[unit][auraInstanceID] = nil;
					local type = ProcessAura(newAura, unit);
					if type == AuraUpdateChangedType.Buff or wasInBuff then
						buffsChanged = true;
					end
				end
			end
		end

		if unitAuraUpdateInfo.removedAuraInstanceIDs ~= nil then
			for _, auraInstanceID in ipairs(unitAuraUpdateInfo.removedAuraInstanceIDs) do
				if activeBuffs[unit][auraInstanceID] ~= nil then
					activeBuffs[unit][auraInstanceID] = nil;
					buffsChanged = true;
				end
			end
		end
	end

	if not buffsChanged then
		return;
	end

	UpdateAuraFrames(unit, activeBuffs[unit]);
end



local function ABF_ClearFrame()
	local parent = ABF_TARGET_BUFF;

	for i = 1, ABF_MAX_BUFF_SHOW do
		local frame = parent.frames[i];

		if (frame) then
			frame:Hide();
			lib.ButtonGlow_Stop(frame);
			lib.PixelGlow_Stop(frame);
		else
			break;
		end
	end
end

local function ABF_InitShowList()
	local localizedClass, englishClass = UnitClass("player")
	local spec = GetSpecialization();
	local listname = "ABF_ShowList";
	if spec then
		listname = "ABF_ShowList" .. "_" .. englishClass .. "_" .. spec;
	end

	ABF_ShowList = _G[listname];

	b_showlist = false;

	if (ABF_ShowList and #ABF_ShowList) then
		b_showlist = true;
	end
end

local function ABF_OnUpdate()

end

local function ABF_OnEvent(self, event, arg1, ...)
	if (event == "PLAYER_TARGET_CHANGED") then
		ABF_ClearFrame();
		ABF:RegisterUnitEvent("UNIT_AURA", "target");
		UpdateAuras(nil, "target");
	elseif (event == "UNIT_AURA") then
		local unitAuraUpdateInfo = ...;
		UpdateAuras(unitAuraUpdateInfo, arg1);
	elseif (event == "PLAYER_TOTEM_UPDATE") then
		UpdateAuras(nil, "player");
	elseif event == "PLAYER_ENTERING_WORLD" then
		ABF_InitShowList();
		hasValidPlayer = true;
		UpdateAuras(nil, "player");
		UpdateAuras(nil, "target");
		asCheckTalent();
	elseif event == "PLAYER_REGEN_DISABLED" then
		ABF:SetAlpha(ABF_AlphaCombat);
		DumpCaches();
	elseif event == "PLAYER_REGEN_ENABLED" then
		ABF:SetAlpha(ABF_AlphaNormal);
		DumpCaches();
	elseif (event == "PLAYER_SPECIALIZATION_CHANGED") then
		asCheckTalent();
	elseif (event == "SPELL_ACTIVATION_OVERLAY_SHOW") then
		if Settings.GetValue("spellActivationOverlayOpacity") > 0 then
			overlayspell[arg1] = true;
		end
		overlayspell[arg1] = true;
	elseif (event == "SPELL_ACTIVATION_OVERLAY_HIDE") then
		if arg1 then
			overlayspell[arg1] = false;
		else
			overlayspell = {};
		end
	elseif (event == "PLAYER_LEAVING_WORLD") then
		hasValidPlayer = false;
	end
end

local function ABF_UpdateBuffAnchor(frames, index, offsetX, right, center, parent)
	local buff = frames[index];
	buff:ClearAllPoints();

	if center then
		if (index == 1) then
			buff:SetPoint("TOP", parent, "CENTER", 0, 0);
		elseif (index == 2) then
			buff:SetPoint("RIGHT", frames[index - 1], "LEFT", -offsetX, 0);
		elseif (math.fmod(index, 2) == 1) then
			buff:SetPoint("LEFT", frames[index - 2], "RIGHT", offsetX, 0);
		else
			buff:SetPoint("RIGHT", frames[index - 2], "LEFT", -offsetX, 0);
		end
	else
		local point1 = "TOPLEFT";
		local point2 = "CENTER";
		local point3 = "TOPRIGHT";

		if (right == false) then
			point1 = "TOPRIGHT";
			point2 = "CENTER";
			point3 = "TOPLEFT";
			offsetX = -offsetX;
		end

		if (index == 1) then
			buff:SetPoint(point1, parent, point2, 0, 0);
		else
			buff:SetPoint(point1, frames[index - 1], point3, offsetX, 0);
		end
	end
	-- Resize
	buff:SetWidth(ABF_SIZE);
	buff:SetHeight(ABF_SIZE * 0.8);
end

local function CreatBuffFrames(parent, bright, bcenter)
	if parent.frames == nil then
		parent.frames = {};
	end

	for idx = 1, ABF_MAX_BUFF_SHOW do
		parent.frames[idx] = CreateFrame("Button", nil, parent, "asTargetBuffFrameTemplate");
		local frame = parent.frames[idx];
		frame:EnableMouse(false);
		for _, r in next, { frame.cooldown:GetRegions() } do
			if r:GetObjectType() == "FontString" then
				r:SetFont(STANDARD_TEXT_FONT, ABF_CooldownFontSize, "OUTLINE");
				r:ClearAllPoints();
				r:SetPoint("TOP", 0, 5);
				break
			end
		end

		local font, size, flag = frame.count:GetFont()

		frame.count:SetFont(STANDARD_TEXT_FONT, ABF_CountFontSize, "OUTLINE")
		frame.count:ClearAllPoints()
		frame.count:SetPoint("BOTTOMRIGHT", -2, 2);

		frame.icon:SetTexCoord(.08, .92, .08, .92);
		frame.border:SetTexture("Interface\\Addons\\asDebuffFilter\\border.tga");
		frame.border:SetTexCoord(0.08, 0.08, 0.08, 0.92, 0.92, 0.08, 0.92, 0.92);

		ABF_UpdateBuffAnchor(parent.frames, idx, 1, bright, bcenter, parent);

		if not frame:GetScript("OnEnter") then
			frame:SetScript("OnEnter", function(s)
				if s.auraInstanceID then
                    GameTooltip_SetDefaultAnchor(GameTooltip, s);
                    GameTooltip:SetUnitBuffByAuraInstanceID(s.unit, s.auraInstanceID, filter);
                end
			end)
			frame:SetScript("OnLeave", function()
				GameTooltip:Hide();
			end)
		end

		frame:Hide();
	end

	return;
end

local function ABF_Init()
	ABF = CreateFrame("Frame", nil, UIParent)

	ABF:SetPoint("CENTER", 0, 0)
	ABF:SetWidth(1)
	ABF:SetHeight(1)
	ABF:SetScale(1)
	ABF:SetAlpha(ABF_AlphaNormal);
	ABF:Show()


	local bloaded = LoadAddOn("asMOD")

	ABF_TARGET_BUFF = CreateFrame("Frame", nil, ABF)

	ABF_TARGET_BUFF:SetPoint("CENTER", ABF_TARGET_BUFF_X, ABF_TARGET_BUFF_Y)
	ABF_TARGET_BUFF:SetWidth(1)
	ABF_TARGET_BUFF:SetHeight(1)
	ABF_TARGET_BUFF:SetScale(1)
	ABF_TARGET_BUFF:Show()

	CreatBuffFrames(ABF_TARGET_BUFF, true, false);

	if bloaded and asMOD_setupFrame then
		asMOD_setupFrame(ABF_TARGET_BUFF, "asBuffFilter(Target)");
	end

	ABF_PLAYER_BUFF = CreateFrame("Frame", nil, ABF)

	ABF_PLAYER_BUFF:SetPoint("CENTER", ABF_PLAYER_BUFF_X, ABF_PLAYER_BUFF_Y)
	ABF_PLAYER_BUFF:SetWidth(1)
	ABF_PLAYER_BUFF:SetHeight(1)
	ABF_PLAYER_BUFF:SetScale(1)
	ABF_PLAYER_BUFF:Show()

	CreatBuffFrames(ABF_PLAYER_BUFF, false, false);

	if bloaded and asMOD_setupFrame then
		asMOD_setupFrame(ABF_PLAYER_BUFF, "asBuffFilter(Player)");
	end

	ABF_TALENT_BUFF = CreateFrame("Frame", nil, ABF)

	ABF_TALENT_BUFF:SetPoint("CENTER", 0, ABF_PLAYER_BUFF_Y)
	ABF_TALENT_BUFF:SetWidth(1)
	ABF_TALENT_BUFF:SetHeight(1)
	ABF_TALENT_BUFF:SetScale(1)

	ABF_TALENT_BUFF:Show()

	CreatBuffFrames(ABF_TALENT_BUFF, false, true);

	if bloaded and asMOD_setupFrame then
		asMOD_setupFrame(ABF_TALENT_BUFF, "asBuffFilter(Talent)");
	end


	ABF:RegisterEvent("PLAYER_TARGET_CHANGED")
	ABF_TARGET_BUFF:RegisterUnitEvent("UNIT_AURA", "target")
	ABF_PLAYER_BUFF:RegisterUnitEvent("UNIT_AURA", "player");
	ABF:RegisterEvent("PLAYER_ENTERING_WORLD");
	ABF:RegisterEvent("PLAYER_LEAVING_WORLD");
	ABF:RegisterEvent("PLAYER_REGEN_DISABLED");
	ABF:RegisterEvent("PLAYER_REGEN_ENABLED");
	ABF:RegisterEvent("PLAYER_TOTEM_UPDATE");
	ABF:RegisterEvent("PLAYER_SPECIALIZATION_CHANGED");


	bloaded = LoadAddOn("asOverlay")
	if bloaded then
		ABF:RegisterEvent("SPELL_ACTIVATION_OVERLAY_SHOW");
		ABF:RegisterEvent("SPELL_ACTIVATION_OVERLAY_HIDE");
	end


	ABF:SetScript("OnEvent", ABF_OnEvent)
	ABF_TARGET_BUFF:SetScript("OnEvent", ABF_OnEvent)
	ABF_PLAYER_BUFF:SetScript("OnEvent", ABF_OnEvent)
	--C_Timer.NewTicker(ABF_RefreshRate, ABF_OnUpdate);
end

ABF_Init();
