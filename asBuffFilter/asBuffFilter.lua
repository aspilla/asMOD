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
local ABF_CooldownFontSize = 12; -- Cooldown Font Size
local ABF_CountFontSize = 11;    -- Count Font Size
local ABF_AlphaCombat = 1;       -- 전투중 Alpha 값
local ABF_AlphaNormal = 0.5;     -- 비 전투중 Alpha 값
local ABF_MAX_Cool = 60;         -- 최대 60초의 버프를 보임

local ABF_BlackList = {
	--	["문양: 기사단의 선고"] = 1,
	--	["문양: 이중 판결"] = 1,
	--	["관대한 치유사"] = 1,
	--	["법의 위세"] = 1,
	--	["피의 광기"] = 1,

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

-- PVP Buff List
local ABF_PVPBuffList = {

	--생존기 (용군단 Update 완료)
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
	[272679] = true, --HUNTER
	[53480] = true, --HUNTER
	[109304] = true, --HUNTER
	[264735] = true, --HUNTER
	[186265] = true, --HUNTER
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
	[110960] = true, --MAGE
	[125174] = true, --MONK
	[186265] = true, --HUNTER
	[378441] = true, --EVOKER
	[228049] = true, --PALADIN
	[642] = true, --PALADIN
	[409293] = true, --SHAMAN
	[45438] = true, --MAGE	
	[586] = true, --PRIEST

	--공격버프 시작 (용군단 update 완료)
	[198817] = true, --WARRIOR
	[260708] = true, --WARRIOR
	[260643] = true, --WARRIOR
	[262161] = true, --WARRIOR
	[167105] = true, --WARRIOR
	[384110] = true, --WARRIOR
	[384318] = true, --WARRIOR
	[107574] = true, --WARRIOR
	[376079] = true, --WARRIOR
	[228920] = true, --WARRIOR
	[1719] = true, --WARRIOR
	[385059] = true, --WARRIOR
	[227847] = true, --WARRIOR
	[401150] = true, --WARRIOR
	[315341] = true, --ROGUE
	[221622] = true, --ROGUE
	[269513] = true, --ROGUE
	[212283] = true, --ROGUE
	[385424] = true, --ROGUE
	[385408] = true, --ROGUE
	[385616] = true, --ROGUE
	[271877] = true, --ROGUE
	[381989] = true, --ROGUE
	[315508] = true, --ROGUE
	[13750] = true, --ROGUE
	[343142] = true, --ROGUE
	[51690] = true, --ROGUE
	[13877] = true, --ROGUE
	[196937] = true, --ROGUE
	[185422] = true, --ROGUE
	[280719] = true, --ROGUE
	[277925] = true, --ROGUE
	[384631] = true, --ROGUE
	[121471] = true, --ROGUE
	[5938] = true, --ROGUE
	[382245] = true, --ROGUE
	[381623] = true, --ROGUE
	[360194] = true, --ROGUE
	[381802] = true, --ROGUE
	[200806] = true, --ROGUE
	[385627] = true, --ROGUE
	[162264] = true, --DEMONHUNTER
	[370965] = true, --DEMONHUNTER
	[204596] = true, --DEMONHUNTER
	[390163] = true, --DEMONHUNTER
	[207407] = true, --DEMONHUNTER
	[212084] = true, --DEMONHUNTER
	[198013] = true, --DEMONHUNTER
	[258925] = true, --DEMONHUNTER
	[342817] = true, --DEMONHUNTER
	[258860] = true, --DEMONHUNTER
	[322109] = true, --MONK
	[388193] = true, --MONK
	[196725] = true, --MONK
	[124081] = true, --MONK
	[386276] = true, --MONK
	[322118] = true, --MONK
	[325197] = true, --MONK
	[116680] = true, --MONK
	[113656] = true, --MONK
	[137639] = true, --MONK
	[152173] = true, --MONK
	[123904] = true, --MONK
	[152175] = true, --MONK
	[392983] = true, --MONK
	[388686] = true, --MONK
	[123986] = true, --MONK
	[387184] = true, --MONK
	[325153] = true, --MONK
	[203173] = true, --DEATHKNIGHT
	[196770] = true, --DEATHKNIGHT
	[288853] = true, --DEATHKNIGHT
	[196770] = true, --DEATHKNIGHT
	[383269] = true, --DEATHKNIGHT
	[47568] = true, --DEATHKNIGHT
	[152279] = true, --DEATHKNIGHT
	[279302] = true, --DEATHKNIGHT
	[305392] = true, --DEATHKNIGHT
	[51271] = true, --DEATHKNIGHT
	[194844] = true, --DEATHKNIGHT
	[207289] = true, --DEATHKNIGHT
	[390279] = true, --DEATHKNIGHT
	[115989] = true, --DEATHKNIGHT
	[49206] = true, --DEATHKNIGHT
	[275699] = true, --DEATHKNIGHT
	[63560] = true, --DEATHKNIGHT
	[46584] = true, --DEATHKNIGHT
	[42650] = true, --DEATHKNIGHT
	[208652] = true, --HUNTER
	[205691] = true, --HUNTER
	[400456] = true, --HUNTER
	[269751] = true, --HUNTER
	[203415] = true, --HUNTER
	[360952] = true, --HUNTER
	[360966] = true, --HUNTER
	[257044] = true, --HUNTER
	[288613] = true, --HUNTER
	[260243] = true, --HUNTER
	[120360] = true, --HUNTER
	[212431] = true, --HUNTER
	[375891] = true, --HUNTER
	[201430] = true, --HUNTER
	[321530] = true, --HUNTER
	[131894] = true, --HUNTER
	[193530] = true, --HUNTER
	[19574] = true, --HUNTER
	[120679] = true, --HUNTER
	[359844] = true, --HUNTER
	[377509] = true, --EVOKER
	[390386] = true, --EVOKER
	[357210] = true, --EVOKER
	[382266] = true, --EVOKER
	[359816] = true, --EVOKER
	[370537] = true, --EVOKER
	[368412] = true, --EVOKER
	[367226] = true, --EVOKER
	[355936] = true, --EVOKER
	[370452] = true, --EVOKER
	[359073] = true, --EVOKER
	[368847] = true, --EVOKER
	[375087] = true, --EVOKER
	[370553] = true, --EVOKER
	[395152] = true, --EVOKER
	[403631] = true, --EVOKER
	[50334] = true, --DRUID
	[102351] = true, --DRUID
	[203651] = true, --DRUID
	[117679] = true, --DRUID
	[391528] = true, --DRUID
	[391888] = true, --DRUID
	[392160] = true, --DRUID
	[197721] = true, --DRUID
	[274837] = true, --DRUID
	[391891] = true, --DRUID
	[102543] = true, --DRUID
	[5217] = true, --DRUID
	[102558] = true, --DRUID
	[319454] = true, --DRUID
	[102560] = true, --DRUID
	[194223] = true, --DRUID
	[88747] = true, --DRUID
	[202770] = true, --DRUID
	[274281] = true, --DRUID
	[202425] = true, --DRUID
	[417537] = true, --WARLOCK
	[344566] = true, --WARLOCK
	[212459] = true, --WARLOCK
	[353601] = true, --WARLOCK
	[201996] = true, --WARLOCK
	[353753] = true, --WARLOCK
	[89751] = true, --WARLOCK
	[328774] = true, --WARLOCK
	[387976] = true, --WARLOCK
	[152108] = true, --WARLOCK
	[6353] = true, --WARLOCK
	[1122] = true, --WARLOCK
	[267218] = true, --WARLOCK
	[264130] = true, --WARLOCK
	[386833] = true, --WARLOCK
	[264119] = true, --WARLOCK
	[267171] = true, --WARLOCK
	[267211] = true, --WARLOCK
	[104316] = true, --WARLOCK
	[265273] = true, --WARLOCK
	[205180] = true, --WARLOCK
	[278350] = true, --WARLOCK
	[205179] = true, --WARLOCK
	[386951] = true, --WARLOCK
	[386997] = true, --WARLOCK
	[196447] = true, --WARLOCK
	[211522] = true, --PRIEST
	[197871] = true, --PRIEST
	[197862] = true, --PRIEST
	[316262] = true, --PRIEST
	[372760] = true, --PRIEST
	[205385] = true, --PRIEST
	[246287] = true, --PRIEST
	[373178] = true, --PRIEST
	[214621] = true, --PRIEST
	[314867] = true, --PRIEST
	[123040] = true, --PRIEST
	[47536] = true, --PRIEST
	[372616] = true, --PRIEST
	[200183] = true, --PRIEST
	[34861] = true, --PRIEST
	[2050] = true, --PRIEST
	[200174] = true, --PRIEST
	[263165] = true, --PRIEST
	[391109] = true, --PRIEST
	[228260] = true, --PRIEST
	[373481] = true, --PRIEST
	[120644] = true, --PRIEST
	[120517] = true, --PRIEST
	[375901] = true, --PRIEST
	[10060] = true, --PRIEST
	[34433] = true, --PRIEST
	[389539] = true, --PALADIN
	[375576] = true, --PALADIN
	[255937] = true, --PALADIN
	[231895] = true, --PALADIN
	[343527] = true, --PALADIN
	[343721] = true, --PALADIN
	[210294] = true, --PALADIN
	[114165] = true, --PALADIN
	[114158] = true, --PALADIN
	[216331] = true, --PALADIN
	[200652] = true, --PALADIN
	[388007] = true, --PALADIN
	[105809] = true, --PALADIN
	[152262] = true, --PALADIN
	[193876] = true, --SHAMAN
	[2825] = true, --SHAMAN
	[204330] = true, --SHAMAN
	[384352] = true, --SHAMAN
	[375982] = true, --SHAMAN
	[51533] = true, --SHAMAN
	[198067] = true, --SHAMAN
	[192249] = true, --SHAMAN
	[191634] = true, --SHAMAN
	[210714] = true, --SHAMAN
	[114050] = true, --SHAMAN
	[192222] = true, --SHAMAN
	[157153] = true, --SHAMAN
	[197995] = true, --SHAMAN
	[114052] = true, --SHAMAN
	[5394] = true, --SHAMAN
	[114051] = true, --SHAMAN
	[353128] = true, --MAGE
	[353082] = true, --MAGE
	[198144] = true, --MAGE
	[80353] = true, --MAGE
	[382440] = true, --MAGE
	[153561] = true, --MAGE
	[116011] = true, --MAGE
	[205025] = true, --MAGE
	[205021] = true, --MAGE
	[12472] = true, --MAGE
	[84714] = true, --MAGE
	[44614] = true, --MAGE
	[153595] = true, --MAGE
	[190319] = true, --MAGE
	[257541] = true, --MAGE
	[365350] = true, --MAGE
	[321507] = true, --MAGE
	[376103] = true, --MAGE
	[153626] = true, --MAGE

};

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
local GlowTexPool = CreateTexturePool(GlowParent, "BACKGROUND", 7, nil, TexPoolResetter)
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
			f.textures[i]:SetDrawLayer("BACKGROUND", 7)
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
			f.bg:SetDrawLayer("BACKGROUND", 6)
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
	f.innerGlow = f:CreateTexture(nil, "BACKGROUND")
	f.innerGlow:SetPoint("CENTER")
	f.innerGlow:SetAlpha(0)
	f.innerGlow:SetTexture([[Interface\SpellActivationOverlay\IconAlert]])
	f.innerGlow:SetTexCoord(0.00781250, 0.50781250, 0.27734375, 0.52734375)

	-- inner glow over
	f.innerGlowOver = f:CreateTexture(nil, "BACKGROUND")
	f.innerGlowOver:SetPoint("TOPLEFT", f.innerGlow, "TOPLEFT")
	f.innerGlowOver:SetPoint("BOTTOMRIGHT", f.innerGlow, "BOTTOMRIGHT")
	f.innerGlowOver:SetAlpha(0)
	f.innerGlowOver:SetTexture([[Interface\SpellActivationOverlay\IconAlert]])
	f.innerGlowOver:SetTexCoord(0.00781250, 0.50781250, 0.53515625, 0.78515625)

	-- outer glow
	f.outerGlow = f:CreateTexture(nil, "BACKGROUND")
	f.outerGlow:SetPoint("CENTER")
	f.outerGlow:SetAlpha(0)
	f.outerGlow:SetTexture([[Interface\SpellActivationOverlay\IconAlert]])
	f.outerGlow:SetTexCoord(0.00781250, 0.50781250, 0.27734375, 0.52734375)

	-- outer glow over
	f.outerGlowOver = f:CreateTexture(nil, "BACKGROUND")
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


local ABF_TalentBuffList = {};

--AuraUtil
local PLAYER_UNITS = {
	player = true,
	vehicle = true,
	pet = true,
};


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

	if overlayspell[name] or overlayspell[spellId]  then
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
			if (ABF_PVPBuffList and ABF_PVPBuffList[aura.spellId]) then
				skip = false;
			end
		else
			skip = false;
		end
	elseif unit == "player" then
		skip = true;
		if PLAYER_UNITS[aura.sourceUnit] and ((aura.duration > 0 and aura.duration <= ABF_MAX_Cool)) then
			skip = false;
		end

		if PLAYER_UNITS[aura.sourceUnit] and ((aura.applications and aura.applications > 1)) then
			skip = false;
		end

		if PLAYER_UNITS[aura.sourceUnit] and aura.nameplateShowPersonal then
			skip = false;
		end

		if (ABF_PVPBuffList and ABF_PVPBuffList[aura.spellId]) then
			skip = false;
		end

		if ABF_ProcBuffList and ABF_ProcBuffList[aura.name] then
			skip = false;
		end
	end

	if skip == false then
		if aura.isBossAura and not aura.isRaid then
			aura.buffType = UnitFrameBuffType.BossBuff;
		elseif not PLAYER_UNITS[aura.sourceUnit] then
			aura.buffType = UnitFrameBuffType.Normal;
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

				frame.totemslot = slot;
				frame.auraInstanceID = nil;

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
				if mparent and aura.buffType ~= UnitFrameBuffType.Normal and tcount <= ABF_MAX_BUFF_SHOW then
					frame = mparent.frames[tcount];
					tcount = tcount + 1;
				elseif mparent and lcount <= ABF_MAX_BUFF_SHOW then
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
			frame.totemslot = nil;

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
				local newAura = C_UnitAuras.GetAuraDataByAuraInstanceID(unit, auraInstanceID);
				activeBuffs[unit][auraInstanceID] = nil;
				local type = ProcessAura(newAura, unit);
				if type == AuraUpdateChangedType.Buff then
					buffsChanged = true;
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


local function ABF_OnEvent(self, event, arg1, ...)
	if (event == "PLAYER_TARGET_CHANGED") then
		ABF_ClearFrame();
		ABF:RegisterUnitEvent("UNIT_AURA", "target");
		UpdateAuras(nil, "target");
	elseif (event == "UNIT_AURA") then
		local unitAuraUpdateInfo = ...;
		UpdateAuras(unitAuraUpdateInfo, arg1);
	elseif (event == "PLAYER_TOTEM_UPDATE") then
		if activeBuffs["player"] == nil then
			UpdateAuras(nil, "player");
		else
			UpdateAuraFrames("player", activeBuffs["player"]);
		end		
	elseif event == "PLAYER_ENTERING_WORLD" then
		hasValidPlayer = true;
		asCheckTalent();		
		UpdateAuras(nil, "player");
		UpdateAuras(nil, "target");
	elseif event == "PLAYER_REGEN_DISABLED" then
		ABF:SetAlpha(ABF_AlphaCombat);
		DumpCaches();
	elseif event == "PLAYER_REGEN_ENABLED" then
		ABF:SetAlpha(ABF_AlphaNormal);
		DumpCaches();
	elseif (event == "PLAYER_SPECIALIZATION_CHANGED") then
		overlayspell = {};
		asCheckTalent();
	elseif (event == "SPELL_ACTIVATION_OVERLAY_SHOW") then
		if Settings.GetValue("spellActivationOverlayOpacity") and Settings.GetValue("spellActivationOverlayOpacity") > 0 then
			local name = GetSpellInfo(arg1);
			overlayspell[arg1] = true;
			overlayspell[name] = true;
		end
		overlayspell[arg1] = true;
	elseif (event == "SPELL_ACTIVATION_OVERLAY_HIDE") then
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
		frame:SetFrameStrata("LOW");
		frame:EnableMouse(false);
		frame.cooldown:SetFrameStrata("MEDIUM");
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
				elseif s.totemslot then
					GameTooltip_SetDefaultAnchor(GameTooltip, s);
					GameTooltip:SetTotem(s.totemslot)
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
end

ABF_Init();
