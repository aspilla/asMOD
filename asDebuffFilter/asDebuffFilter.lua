local ADF;
local ADF_PLAYER_DEBUFF;
local ADF_TARGET_DEBUFF;
local ADF_DeBuffList = {}

local ADF_SIZE = 32;
local ADF_TARGET_DEBUFF_X = 73 + 30 + 20;
local ADF_TARGET_DEBUFF_Y = -110;
local ADF_PLAYER_DEBUFF_X = -73 - 30 - 20;
local ADF_PLAYER_DEBUFF_Y = -110;
local ADF_MAX_DEBUFF_SHOW = 7;
local ADF_ALPHA = 1
local ADF_CooldownFontSize = 14      -- Cooldown Font Size
local ADF_CountFontSize = 13;        -- Count Font Size
local ADF_AlphaCombat = 1;           -- 전투중 Alpha 값
local ADF_AlphaNormal = 0.5;         -- 비 전투중 Alpha 값
local ADF_MAX_Cool = 120             -- 최대 120초까지의 Debuff를 보임
local ADF_Show_TargetDebuff = true   -- 대상이 시전한 Debuff를 보임 (false 이면 Player가 건 Debuff 만 보임)
local ADF_Show_PVPDebuff = true      -- 다른사람이 건 PVP Debuff를 보임 (점감 효과를 갖는 Debuff) (false 이면 Player가 건 Debuff 만 보임)

local ADF_Show_ShowBossDebuff = true -- Boss Type Debuff를 보임 (false 이면 Player가 건 Debuff 만 보임)
local ADF_RefreshRate = 0.5;         -- Target Debuff Check 주기 (초)

local ADF_BlackList = {

    ["도전자의 짐"] = 1,
    --	["상처 감염 독"] = 1,	
    --	["신경 마취 독"] = 1,
    --	["맹독"] = 1,
}

local PLAYER_UNITS = {
    player = true,
    vehicle = true,
    pet = true,
};

-- 특정한 버프만 보이게 하려면 직업별로 편집
-- ABF_ShowList_직업명_특성
--[[
ADF_ShowList_PALADIN_3 = {
	["불신임"] = 1,	
}
--]]

local ADF_ShowList;
local b_showlist = false;
local dispellableDebuffTypes = { Magic = true, Curse = true, Disease = true, Poison = true };

-- 반짝이 처리부

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

local function asCooldownFrame_Set(self, start, duration, enable, forceShowDrawEdge, modRate)
    if enable and enable ~= 0 and start > 0 and duration > 0 then
        self:SetDrawEdge(forceShowDrawEdge);
        self:SetCooldown(start, duration, modRate);
    else
        asCooldownFrame_Clear(self);
    end
end

local function ADF_UpdateDebuff(unit)
    local numDebuffs = 1;
    local frame;
    local frameIcon, frameCount, frameCooldown;
    local name, icon, count, debuffType, duration, expirationTime, caster, isStealable, shouldConsolidate, spellId, canApplyAura, isBossDebuff, casterIsPlayer, nameplateShowAll;
    local color;
    local frameBorder;
    local parent;
    local filter = nil;
    isBossDebuff = nil;
    local i;


    if (unit == "target") then
        parent = ADF_TARGET_DEBUFF;
    elseif (unit == "targethelp") then
        parent = ADF_TARGET_DEBUFF;
    elseif (unit == "targethelp2") then
        parent = ADF_TARGET_DEBUFF;
    elseif (unit == "player") then
        parent = ADF_PLAYER_DEBUFF;
    else
        return;
    end

    local bBattle = false;

    local RTB_PVPType = GetZonePVPInfo();
    local _, RTB_ZoneType = IsInInstance();
    local alert = false;

    if RTB_PVPType == "combat" or RTB_ZoneType == "pvp" then
        bBattle = true;
    end

    local dispel_debuff_name = {};

    if unit ~= "target" then
        i = 1;
        -- Dispel Debuff Check
        repeat
            filter = "RAID"
            name, _, _, debuffType, _, _, _, _, _, spellId = UnitDebuff(unit, i, filter);
            if (dispellableDebuffTypes[debuffType]) then
                dispel_debuff_name[spellId] = true;
            end

            i = i + 1;
        until (name == nil)
    end

    filter = nil;

    i = 1;
    repeat
        local skip = false;
        local debuff;
        local candispel = false;

        alert = false;

        if (unit == "target") then
            filter                                                                                                                                                                = "";
            name, icon, count, debuffType, duration, expirationTime, caster, isStealable, shouldConsolidate, spellId, canApplyAura, isBossDebuff, casterIsPlayer, nameplateShowAll =
            UnitDebuff("target", i, filter);

            if (icon == nil) then
                break;
            end

            skip = true;

            if (casterIsPlayer) then
                skip = true;
            end
            -- 내가 시전한 Debuff는 보이고
            if caster and PLAYER_UNITS[caster] then
                skip = false;
            end

            if caster and ADF_Show_TargetDebuff and not UnitIsPlayer("target") and UnitIsUnit("target", caster) then
                skip = false;
            end

            if (spellId and ADF_Show_PVPDebuff and nameplateShowAll) then
                skip = false;
            end

            -- CombatInfo 에서 보이는 Debuff 는 숨기고
            if ACI_Debuff_list and ACI_Debuff_list[name] then
                skip = true;
            end

            -- PowerBar에서 보이는 Debuff 는 숨기고
            if APB_DEBUFF and APB_DEBUFF == name then
                skip = true;
            end

            if b_showlist == true then
                skip = true;
                if ADF_ShowList[name] then
                    skip = false;
                end
            end

            if skip == false and ADF_BlackList[name] then
                skip = true;
            end
        elseif (unit == "targethelp") then
            name, icon, count, debuffType, duration, expirationTime, caster, isStealable, shouldConsolidate, spellId, canApplyAura, isBossDebuff, casterIsPlayer, nameplateShowAll =
            UnitDebuff("target", i, filter);

            if (icon == nil) then
                break;
            end

            skip = false;

            if (casterIsPlayer) then
                skip = true;
            end

            -- 내가 시전한 Debuff는 보이고
            if PLAYER_UNITS[caster] then
                skip = false;
            end

            if ADF_Show_ShowBossDebuff and isBossDebuff then
                skip = false;
            end

            -- 상대 가 Player 면 PVP Debuff 만 보임		
            if (spellId and ADF_Show_PVPDebuff and nameplateShowAll) then
                skip = false;
            end

            if dispel_debuff_name[spellId] then
                skip = false;
                candispel = true;
            end

            -- ACI 에서 보이는 Debuff 는 숨기고
            if ACI_Debuff_list and ACI_Debuff_list[name] then
                skip = true;
            end

            if b_showlist == true then
                skip = true;
                if ADF_ShowList[name] then
                    skip = false;
                end
            end

            if skip == false and ADF_BlackList[name] then
                skip = true;
            end
        elseif (unit == "player") then
            filter = "";
            name, icon, count, debuffType, duration, expirationTime, caster, isStealable, shouldConsolidate, spellId, canApplyAura, isBossDebuff, _, nameplateShowAll =
            UnitDebuff("player", i, filter);


            skip = false;


            if (icon == nil) then
                break;
            end

            if duration > ADF_MAX_Cool then
                skip = true;
            end

            -- 내가 해제할 수 있는 Debuff는 보이기
            if dispel_debuff_name[spellId] then
                skip = false;
                candispel = true;
            end

            -- 주요 PVP Debuff만 보이기
            if (spellId and nameplateShowAll) then
                skip = false;
            end


            if isBossDebuff then
                skip = false;
                alert = true;
            end

            -- ACI 에서 보이는 Debuff 면 숨기기
            if ACI_Player_Debuff_list and skip == false and ACI_Player_Debuff_list[name] then
                skip = true;
            end

            if skip == false and ADF_BlackList[name] then
                skip = true;
            end
        end


        if (icon and skip == false) then
            if numDebuffs > ADF_MAX_DEBUFF_SHOW then
                break;
            end


            frame = parent.frames[numDebuffs];

            -- set the icon
            frameIcon = frame.icon
            frameIcon:SetTexture(icon);
            frameIcon:SetAlpha(ADF_ALPHA);
            -- set the count
            frameCount = frame.count;

            -- Handle cooldowns
            frameCooldown = frame.cooldown;

            if (count > 1) then
                frameCount:SetText(count);
                frameCount:Show();
                frameCooldown:SetDrawSwipe(false);
            else
                frameCount:Hide();
                frameCooldown:SetDrawSwipe(true);
            end

            if (duration > 0) then
                frameCooldown:Show();
                asCooldownFrame_Set(frameCooldown, expirationTime - duration, duration, duration > 0, true);
                frameCooldown:SetHideCountdownNumbers(false);
            else
                frameCooldown:Hide();
            end

            -- set debuff type color
            if (debuffType) then
                color = DebuffTypeColor[debuffType];
            else
                color = DebuffTypeColor["none"];
            end

            if (unit ~= "player" and caster ~= nil and not PLAYER_UNITS[caster]) then
                color = { r = 0.3, g = 0.3, b = 0.3 };
            end

            if candispel then
                color = { r = 1, g = 1, b = 1 };
            end

            frameBorder = frame.border;
            frameBorder:SetVertexColor(color.r, color.g, color.b);
            frameBorder:SetAlpha(ADF_ALPHA);

            frame.filter = filter;
            frame:SetID(i);
            frame.unit = unit;

            if frame.unit == "targethelp" then
                frame.unit = "target"
            end

            frame:Show();


            if (alert) then
                lib.ButtonGlow_Start(frame);
            else
                lib.ButtonGlow_Stop(frame);
            end

            numDebuffs = numDebuffs + 1;
        end
        i = i + 1
    until (name == nil)

    for i = numDebuffs, ADF_MAX_DEBUFF_SHOW do
        frame = parent.frames[i];

        if (frame) then
            frame:Hide();
            lib.ButtonGlow_Stop(frame);
        end
    end
end

function ADF_ClearFrame()
    for i = 1, ADF_MAX_DEBUFF_SHOW do
        local frame = ADF_TARGET_DEBUFF.frames[i];

        if (frame) then
            frame:Hide();
            lib.ButtonGlow_Stop(frame);
        end
    end
end

function ADF_InitShowList()
    local localizedClass, englishClass = UnitClass("player")
    local spec = GetSpecialization();
    local listname = "ADF_ShowList";
    if spec then
        listname = "ADF_ShowList" .. "_" .. englishClass .. "_" .. spec;
    end

    ADF_ShowList = _G[listname];

    b_showlist = false;

    if (ADF_ShowList and #ADF_ShowList) then
        b_showlist = true;
    end
end

function ADF_OnEvent(self, event, arg1)
    if (event == "PLAYER_TARGET_CHANGED") then
        ADF_ClearFrame();

        if UnitCanAssist("player", "target") then
            ADF_UpdateDebuff("targethelp");
        else
            ADF_UpdateDebuff("target");
        end
    elseif (event == "ACTIONBAR_UPDATE_COOLDOWN") and UnitExists("target") then
        if UnitCanAssist("player", "target") then
            ADF_UpdateDebuff("targethelp");
        else
            ADF_UpdateDebuff("target");
        end
    elseif (event == "UNIT_AURA" and arg1 == "player") then
        ADF_UpdateDebuff("player");
    elseif event == "PLAYER_ENTERING_WORLD" then
        ADF_InitShowList();
    elseif event == "ACTIVE_TALENT_GROUP_CHANGED" then
        ADF_InitShowList();
    elseif event == "PLAYER_REGEN_DISABLED" then
        ADF:SetAlpha(ADF_AlphaCombat);
    elseif event == "PLAYER_REGEN_ENABLED" then
        ADF:SetAlpha(ADF_AlphaNormal);
    end
end

local function ADF_OnUpdate()
    if UnitCanAssist("player", "target") then
        ADF_UpdateDebuff("targethelp");
    else
        ADF_UpdateDebuff("target");
    end
end

local function ADF_UpdateDebuffAnchor(frames, index, offsetX, right, parent)
    local buff = frames[index];
    local point1 = "TOPLEFT";
    local point2 = "BOTTOMLEFT";
    local point3 = "TOPRIGHT";

    if (right == false) then
        point1 = "TOPRIGHT";
        point2 = "BOTTOMRIGHT";
        point3 = "TOPLEFT";
        offsetX = -offsetX;
    end

    if (index == 1) then
        buff:SetPoint(point1, parent, point2, 0, 0);
    else
        buff:SetPoint(point1, frames[index - 1], point3, offsetX, 0);
    end

    -- Resize
    buff:SetWidth(ADF_SIZE);
    buff:SetHeight(ADF_SIZE * 0.8);
end


local function CreatDebuffFrames(parent, bright)
    if parent.frames == nil then
        parent.frames = {};
    end

    for idx = 1, ADF_MAX_DEBUFF_SHOW do
        parent.frames[idx] = CreateFrame("Button", nil, parent, "asTargetDebuffFrameTemplate");
        local frame = parent.frames[idx];
        frame:EnableMouse(false);
        for _, r in next, { frame.cooldown:GetRegions() } do
            if r:GetObjectType() == "FontString" then
                r:SetFont(STANDARD_TEXT_FONT, ADF_CooldownFontSize, "OUTLINE");
                r:ClearAllPoints();
                r:SetPoint("TOP", 0, 5);
                break
            end
        end

        frame.count:SetFont(STANDARD_TEXT_FONT, ADF_CountFontSize, "OUTLINE")
        frame.count:ClearAllPoints()
        frame.count:SetPoint("BOTTOMRIGHT", -2, 2);

        frame.icon:SetTexCoord(.08, .92, .08, .92);
        frame.border:SetTexture("Interface\\Addons\\asDebuffFilter\\border.tga");
        frame.border:SetTexCoord(0.08, 0.08, 0.08, 0.92, 0.92, 0.08, 0.92, 0.92);

        frame:ClearAllPoints();
        ADF_UpdateDebuffAnchor(parent.frames, idx, 1, bright, parent);

        if not frame:GetScript("OnEnter") then
            frame:SetScript("OnEnter", function(s)
                if s:GetID() > 0 then
                    GameTooltip_SetDefaultAnchor(GameTooltip, s);
                    GameTooltip:SetUnitDebuff(s.unit, s:GetID(), s.filter);
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

local function ADF_Init()
    local bloaded = LoadAddOn("asMOD")

    ADF = CreateFrame("Frame", nil, UIParent)

    ADF:SetPoint("CENTER", 0, 0)
    ADF:SetWidth(1)
    ADF:SetHeight(1)
    ADF:SetScale(1)
    ADF:SetAlpha(ADF_AlphaNormal);
    ADF:Show()

    ADF_TARGET_DEBUFF = CreateFrame("Frame", nil, ADF)

    ADF_TARGET_DEBUFF:SetPoint("CENTER", ADF_TARGET_DEBUFF_X, ADF_TARGET_DEBUFF_Y)
    ADF_TARGET_DEBUFF:SetWidth(1)
    ADF_TARGET_DEBUFF:SetHeight(1)
    ADF_TARGET_DEBUFF:SetScale(1)
    ADF_TARGET_DEBUFF:Show()

    CreatDebuffFrames(ADF_TARGET_DEBUFF, true);

    if bloaded and asMOD_setupFrame then
        asMOD_setupFrame(ADF_TARGET_DEBUFF, "asDebuffFilter(Target)");
    end

    ADF_PLAYER_DEBUFF = CreateFrame("Frame", nil, ADF)

    ADF_PLAYER_DEBUFF:SetPoint("CENTER", ADF_PLAYER_DEBUFF_X, ADF_PLAYER_DEBUFF_Y)
    ADF_PLAYER_DEBUFF:SetWidth(1)
    ADF_PLAYER_DEBUFF:SetHeight(1)
    ADF_PLAYER_DEBUFF:SetScale(1)
    ADF_PLAYER_DEBUFF:Show()

    CreatDebuffFrames(ADF_PLAYER_DEBUFF, false);

    if bloaded and asMOD_setupFrame then
        asMOD_setupFrame(ADF_PLAYER_DEBUFF, "asDebuffFilter(Player)");
    end

    ADF:RegisterEvent("PLAYER_TARGET_CHANGED")
    ADF:RegisterUnitEvent("UNIT_AURA", "player")
    ADF:RegisterEvent("PLAYER_ENTERING_WORLD");
    ADF:RegisterEvent("ACTIVE_TALENT_GROUP_CHANGED");
    ADF:RegisterEvent("PLAYER_REGEN_DISABLED");
    ADF:RegisterEvent("PLAYER_REGEN_ENABLED");
    ADF:RegisterEvent("ACTIONBAR_UPDATE_COOLDOWN");


    ADF:SetScript("OnEvent", ADF_OnEvent)
    C_Timer.NewTicker(ADF_RefreshRate, ADF_OnUpdate);
end

ADF_Init();
