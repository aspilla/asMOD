local _, ns = ...;

ns.lib = {};

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

function ns.lib.RegisterTextures(texture, id)
	textureList[id] = texture
end

ns.lib.glowList = {}
ns.lib.startList = {}
ns.lib.stopList = {}

local GlowParent = UIParent
local GlowMaskPool = {
    createFunc = function(self)
        return self.parent:CreateMaskTexture()
    end,
    resetFunc = function(self, mask)
        mask:Hide()
        mask:ClearAllPoints()
    end,
    AddObject = function(self, object)
        local dummy = true
        self.activeObjects[object] = dummy
        self.activeObjectCount = self.activeObjectCount + 1
    end,
    ReclaimObject = function(self, object)
        tinsert(self.inactiveObjects, object)
        self.activeObjects[object] = nil
        self.activeObjectCount = self.activeObjectCount - 1
    end,
    Release = function(self, object)
        local active = self.activeObjects[object] ~= nil
        if active then
            self:resetFunc(object)
            self:ReclaimObject(object)
        end
        return active
    end,
    Acquire = function(self)
        local object = tremove(self.inactiveObjects)
        local new = object == nil
        if new then
            object = self:createFunc()
            self:resetFunc(object, new)
        end
        self:AddObject(object)
        return object, new
    end,
    Init = function(self, parent)
        self.activeObjects = {}
        self.inactiveObjects = {}
        self.activeObjectCount = 0
        self.parent = parent
    end
}
GlowMaskPool:Init(GlowParent)

local TexPoolResetter = function(pool, tex)
	local maskNum = tex:GetNumMaskTextures()
	for i = maskNum, 1, -1 do
		tex:RemoveMaskTexture(tex:GetMaskTexture(i))
	end
	tex:Hide()
	tex:ClearAllPoints()
end
local GlowTexPool = CreateTexturePool(GlowParent, "BACKGROUND", 7, nil, TexPoolResetter)
ns.lib.GlowTexPool = GlowTexPool

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
ns.lib.GlowFramePool = GlowFramePool

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

function ns.lib.PixelGlow_Start(r, color, N, frequency, length, th, xOffset, yOffset, border, key, frameLevel)
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

function ns.lib.PixelGlow_Stop(r, key)
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

table.insert(ns.lib.glowList, "Pixel Glow")
ns.lib.startList["Pixel Glow"] = ns.lib.PixelGlow_Start
ns.lib.stopList["Pixel Glow"] = ns.lib.PixelGlow_Stop

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
ns.lib.ButtonGlowPool = ButtonGlowPool

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

function ns.lib.ButtonGlow_Start(r, color, frequency, frameLevel)
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

function ns.lib.ButtonGlow_Stop(r)
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

table.insert(ns.lib.glowList, "Action Button Glow")
ns.lib.startList["Action Button Glow"] = ns.lib.ButtonGlow_Start
ns.lib.stopList["Action Button Glow"] = ns.lib.ButtonGlow_Stop
