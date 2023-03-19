-----------------설정 ------------------------
local ATCB_WIDTH = 150
local ATCB_HEIGHT = 17
local ATCB_X = 0;
local ATCB_Y = -100;
local ATCB_ALPHA = 0.8;											--투명도 80%
local ATCB_NAME_SIZE = ATCB_HEIGHT * 0.7;						--Spell 명 Font Size, 높이의 70%
local ATCB_TIME_SIZE = ATCB_HEIGHT * 0.5;						--Spell 시전시간 Font Size, 높이의 50%
local ATCB_NOT_INTERRUPTIBLE_COLOR = {0.8, 0.8, 0.8}; 			--차단 불가시 (내가 아닐때) 색상 (r, g, b)
local ATCB_NOT_INTERRUPTIBLE_COLOR_TARGET = {0.8, 0.5, 0.5}; 	--차단 불가시 (내가 타겟일때) 색상 (r, g, b)
local ATCB_INTERRUPTIBLE_COLOR = {0, 0.9, 0}; 					--차단 가능(내가 타겟이 아닐때)시 색상 (r, g, b)
local ATCB_INTERRUPTIBLE_COLOR_TARGET = {0.5, 1, 1}; 			--차단 가능(내가 타겟일 때)시 색상 (r, g, b)
local ATCB_UPDATE_RATE = 0.05									-- 20프레임


local ATCB_DangerousSpellList = { 
	[135234] = true,
	[133262] = true,
	[294665] = true,
	[39945] = true,
	[134795] = true,
	[124935] = true,
	[135621] = true,
	[140983] = true,
	[142621] = true,
	[33975] = true,
	[282081] = true,
	[385652] = true,
	[29427] = true,
	[17843] = true,
	[46181] = true,
	[36819] = true,
	[39013] = true,
	[255824] = true,
	[253562] = true,
	[253583] = true,
	[255041] = true,
	[253544] = true,
	[253517] = true,
	[256849] = true,
	[252781] = true,
	[250368] = true,
	[250096] = true,
	[257397] = true,
	[257899] = true,
	[257736] = true,
	[258779] = true,
	[257784] = true,
	[257732] = true,
	[256060] = true,
	[267273] = true,
	[269973] = true,
	[270923] = true,
	[270901] = true,
	[270492] = true,
	[267763] = true,
	[257791] = true,
	[300764] = true,
	[300650] = true,
	[300171] = true,
	[299588] = true,
	[300087] = true,
	[300414] = true,
	[300514] = true,
	[300436] = true,
	[301629] = true,
	[284219] = true,
	[301088] = true,
	[293729] = true,
	[298669] = true,
	[268050] = true,
	[268030] = true,
	[268309] = true,
	[267977] = true,
	[274437] = true,
	[268317] = true,
	[268322] = true,
	[268375] = true,
	[276767] = true,
	[267818] = true,
	[256957] = true,
	[274569] = true,
	[272571] = true,
	[263318] = true,
	[263775] = true,
	[268061] = true,
	[265968] = true,
	[261635] = true,
	[272700] = true,
	[268061] = true,
	[265912] = true,
	[268709] = true,
	[263202] = true,
	[280604] = true,
	[268129] = true,
	[268702] = true,
	[263103] = true,
	[263066] = true,
	[268797] = true,
	[269090] = true,
	[262540] = true,
	[262092] = true,
	[260879] = true,
	[266106] = true,
	[265089] = true,
	[265091] = true,
	[265433] = true,
	[272183] = true,
	[278961] = true,
	[265523] = true,
	[257791] = true,
	[258128] = true,
	[258153] = true,
	[258313] = true,
	[258869] = true,
	[258634] = true,
	[258935] = true,
	[266225] = true,
	[263959] = true,
	[265876] = true,
	[265368] = true,
	[266036] = true,
	[278551] = true,
	[265407] = true,
	[82362] = true,
	[75823] = true,
	[102173] = true,
	[75763] = true,
	[80352] = true,
	[93468] = true,
	[93844] = true,
	[79351] = true,
	[76171] = true,
	[76008] = true,
	[103241] = true,
	[43451] = true,
	[43431] = true,
	[43548] = true,
	[96435] = true,
	[96466] = true,
	[310839] = true,
	[396640] = true,
	[367500] = true,
	[384638] = true,
	[377950] = true,
	[381770] = true,
	[363607] = true,
	[374080] = true,
	[384014] = true,
	[375056] = true,
	[378282] = true,
	[373680] = true,
	[384194] = true,
	[392451] = true,
	[373932] = true,
	[375596] = true,
	[387564] = true,
	[386546] = true,
	[376725] = true,
	[363607] = true,
	[384808] = true,
	[386024] = true,
	[387411] = true,
	[373395] = true,
	[369675] = true,
	[369602] = true,
	[369674] = true,
	[369823] = true,
	[225573] = true,
	[197797] = true,
	[237391] = true,
	[238543] = true,
	[242724] = true,
	[212773] = true,
	[209485] = true,
	[209410] = true,
	[209413] = true,
	[211470] = true,
	[225100] = true,
	[211299] = true,
	[207980] = true,
	[196870] = true,
	[195046] = true,
	[195284] = true,
	[197502] = true,
	[192003] = true,
	[192005] = true,
	[191848] = true,
	[215433] = true,
	[198934] = true,
	[192563] = true,
	[199726] = true,
	[192288] = true,
	[198750] = true,
	[194266] = true,
	[198495] = true,
	[198405] = true,
	[227800] = true,
	[227823] = true,
	[227592] = true,
	[228025] = true,
	[228019] = true,
	[227987] = true,
	[227420] = true,
	[228255] = true,
	[228239] = true,
	[227917] = true,
	[228625] = true,
	[228606] = true,
	[229714] = true,
	[248831] = true,
	[245585] = true,
	[245727] = true,
	[248133] = true,
	[248184] = true,
	[244751] = true,
	[211757] = true,
	[226206] = true,
	[196392] = true,
	[203957] = true,
	[191823] = true,
	[200905] = true,
	[193069] = true,
	[204963] = true,
	[205088] = true,
	[395859] = true,
	[395872] = true,
	[397801] = true,
	[118963] = true,
	[118940] = true,
	[118903] = true,
	[123654] = true,
	[113134] = true,
	[12039] = true,
	[130857] = true,
	[113691] = true,
	[113690] = true,
	[107356] = true,
	[332666] = true,
	[332706] = true,
	[332612] = true,
	[332084] = true,
	[323064] = true,
	[325700] = true,
	[325701] = true,
	[326607] = true,
	[323538] = true,
	[323552] = true,
	[323057] = true,
	[321828] = true,
	[322938] = true,
	[324914] = true,
	[324776] = true,
	[326046] = true,
	[340544] = true,
	[322450] = true,
	[257397] = true,
	[319070] = true,
	[328338] = true,
	[328016] = true,
	[326836] = true,
	[321038] = true,
	[327481] = true,
	[317936] = true,
	[317963] = true,
	[327413] = true,
	[328295] = true,
	[328137] = true,
	[328331] = true,
	[358131] = true,
	[350922] = true,
	[357404] = true,
	[355888] = true,
	[355930] = true,
	[355934] = true,
	[354297] = true,
	[356537] = true,
	[347775] = true,
	[347903] = true,
	[355057] = true,
	[355225] = true,
	[357260] = true,
	[356407] = true,
	[356404] = true,
	[324589] = true,
	[341902] = true,
	[341969] = true,
	[342139] = true,
	[330562] = true,
	[330810] = true,
	[333231] = true,
	[320170] = true,
	[322493] = true,
	[334748] = true,
	[320462] = true,
	[324293] = true,
	[338353] = true,
	[257397] = true,
	[149955] = true,
	[86620] = true,
	[11082] = true,
	[11085] = true,
	[93655] = true,
	[21807] = true,
	[21807] = true,
	[119300] = true,
	[15245] = true,
	[16798] = true,
	[12471] = true,
	[68982] = true,
	[374623] = true,
	[372315] = true,
	[372394] = true,
	[310839] = true,
	[81713] = true,
	[80734] = true,
}

-----------------설정 끝------------------------
-- 반짝이 처리부

local lib = {};

local isRetail = WOW_PROJECT_ID == WOW_PROJECT_MAINLINE
local textureList = {
    empty = [[Interface\AdventureMap\BrokenIsles\AM_29]],
    white = [[Interface\BUTTONS\WHITE8X8]],
    shine = [[Interface\ItemSocketingFrame\UI-ItemSockets]]
}

local shineCoords = {0.3984375, 0.4453125, 0.40234375, 0.44921875}
if isRetail then
    textureList.shine = [[Interface\Artifacts\Artifacts]]
    shineCoords = {0.8115234375,0.9169921875,0.8798828125,0.9853515625}
end

function lib.RegisterTextures(texture,id)
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

local MaskPoolResetter = function(maskPool,mask)
    mask:Hide()
    mask:ClearAllPoints()
end

ObjectPoolMixin.OnLoad(GlowMaskPool,MaskPoolFactory,MaskPoolResetter)
GlowMaskPool.parent =  GlowParent

local TexPoolResetter = function(pool,tex)
    local maskNum = tex:GetNumMaskTextures()
    for i = maskNum , 1, -1 do
        tex:RemoveMaskTexture(tex:GetMaskTexture(i))
    end
    tex:Hide()
    tex:ClearAllPoints()
end
local GlowTexPool = CreateTexturePool(GlowParent ,"ARTWORK",7,nil,TexPoolResetter)
lib.GlowTexPool = GlowTexPool

local FramePoolResetter = function(framePool,frame)
    frame:SetScript("OnUpdate",nil)
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
        for _,mask in pairs(frame.masks) do
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
local GlowFramePool = CreateFramePool("Frame",GlowParent,nil,FramePoolResetter)
lib.GlowFramePool = GlowFramePool

local function addFrameAndTex(r,color,name,key,N,xOffset,yOffset,texture,texCoord,desaturated,frameLevel)
    key = key or ""
	frameLevel = frameLevel or 8
    if not r[name..key] then
        r[name..key] = GlowFramePool:Acquire()
        r[name..key]:SetParent(r)
        r[name..key].name = name..key
    end
    local f = r[name..key]
	f:SetFrameLevel(r:GetFrameLevel()+frameLevel)
    f:SetPoint("TOPLEFT",r,"TOPLEFT",-xOffset+0.05,yOffset+0.05)
    f:SetPoint("BOTTOMRIGHT",r,"BOTTOMRIGHT",xOffset,-yOffset+0.05)
    f:Show()

    if not f.textures then
        f.textures = {}
    end

    for i=1,N do
        if not f.textures[i] then
            f.textures[i] = GlowTexPool:Acquire()
            f.textures[i]:SetTexture(texture)
            f.textures[i]:SetTexCoord(texCoord[1],texCoord[2],texCoord[3],texCoord[4])
            f.textures[i]:SetDesaturated(desaturated)
            f.textures[i]:SetParent(f)
            f.textures[i]:SetDrawLayer("ARTWORK",7)
            if not isRetail and name == "_AutoCastGlow" then
                f.textures[i]:SetBlendMode("ADD")
            end
        end
        f.textures[i]:SetVertexColor(color[1],color[2],color[3],color[4])
        f.textures[i]:Show()
    end
    while #f.textures>N do
        GlowTexPool:Release(f.textures[#f.textures])
        table.remove(f.textures)
    end
end


--Pixel Glow Functions--
local pCalc1 = function(progress,s,th,p)
    local c
    if progress>p[3] or progress<p[0] then
        c = 0
    elseif progress>p[2] then
        c =s-th-(progress-p[2])/(p[3]-p[2])*(s-th)
    elseif progress>p[1] then
        c =s-th
    else
        c = (progress-p[0])/(p[1]-p[0])*(s-th)
    end
    return math.floor(c+0.5)
end

local pCalc2 = function(progress,s,th,p)
    local c
    if progress>p[3] then
        c = s-th-(progress-p[3])/(p[0]+1-p[3])*(s-th)
    elseif progress>p[2] then
        c = s-th
    elseif progress>p[1] then
        c = (progress-p[1])/(p[2]-p[1])*(s-th)
    elseif progress>p[0] then
        c = 0
    else
        c = s-th-(progress+1-p[3])/(p[0]+1-p[3])*(s-th)
    end
    return math.floor(c+0.5)
end

local  pUpdate = function(self,elapsed)
    self.timer = self.timer+elapsed/self.info.period
    if self.timer>1 or self.timer <-1 then
        self.timer = self.timer%1
    end
    local progress = self.timer
    local width,height = self:GetSize()
    if width ~= self.info.width or height ~= self.info.height then
        local perimeter = 2*(width+height)
        if not (perimeter>0) then
            return
        end
        self.info.width = width
        self.info.height = height
        self.info.pTLx = {
            [0] = (height+self.info.length/2)/perimeter,
            [1] = (height+width+self.info.length/2)/perimeter,
            [2] = (2*height+width-self.info.length/2)/perimeter,
            [3] = 1-self.info.length/2/perimeter
        }
        self.info.pTLy ={
            [0] = (height-self.info.length/2)/perimeter,
            [1] = (height+width+self.info.length/2)/perimeter,
            [2] = (height*2+width+self.info.length/2)/perimeter,
            [3] = 1-self.info.length/2/perimeter
        }
        self.info.pBRx ={
            [0] = self.info.length/2/perimeter,
            [1] = (height-self.info.length/2)/perimeter,
            [2] = (height+width-self.info.length/2)/perimeter,
            [3] = (height*2+width+self.info.length/2)/perimeter
        }
        self.info.pBRy ={
            [0] = self.info.length/2/perimeter,
            [1] = (height+self.info.length/2)/perimeter,
            [2] = (height+width-self.info.length/2)/perimeter,
            [3] = (height*2+width-self.info.length/2)/perimeter
        }
    end
    if self:IsShown() then
        if not (self.masks[1]:IsShown()) then
            self.masks[1]:Show()
            self.masks[1]:SetPoint("TOPLEFT",self,"TOPLEFT",self.info.th,-self.info.th)
            self.masks[1]:SetPoint("BOTTOMRIGHT",self,"BOTTOMRIGHT",-self.info.th,self.info.th)
        end
        if self.masks[2] and not(self.masks[2]:IsShown()) then
            self.masks[2]:Show()
            self.masks[2]:SetPoint("TOPLEFT",self,"TOPLEFT",self.info.th+1,-self.info.th-1)
            self.masks[2]:SetPoint("BOTTOMRIGHT",self,"BOTTOMRIGHT",-self.info.th-1,self.info.th+1)
        end
        if self.bg and not(self.bg:IsShown()) then
            self.bg:Show()
        end
        for k,line  in pairs(self.textures) do
            line:SetPoint("TOPLEFT",self,"TOPLEFT",pCalc1((progress+self.info.step*(k-1))%1,width,self.info.th,self.info.pTLx),-pCalc2((progress+self.info.step*(k-1))%1,height,self.info.th,self.info.pTLy))
            line:SetPoint("BOTTOMRIGHT",self,"TOPLEFT",self.info.th+pCalc2((progress+self.info.step*(k-1))%1,width,self.info.th,self.info.pBRx),-height+pCalc1((progress+self.info.step*(k-1))%1,height,self.info.th,self.info.pBRy))
        end
    end
end

function lib.PixelGlow_Start(r,color,N,frequency,length,th,xOffset,yOffset,border,key,frameLevel)
    if not r then
        return
    end

    if not color then
        color = {0.95,0.95,0.32,1}
    end

    if not(N and N>0) then
        N = 8
    end

    local period
    if frequency then
        if not(frequency>0 or frequency<0) then
            period = 4
        else
            period = 1/frequency
        end
    else
        period = 4
    end
    local width,height = r:GetSize()
    length = length or math.floor((width+height)*(2/N-0.1))
    length = min(length,min(width,height))
    th = th or 1
    xOffset = xOffset or 0
    yOffset = yOffset or 0
    key = key or ""

    addFrameAndTex(r,color,"_PixelGlow",key,N,xOffset,yOffset,textureList.white,{0,1,0,1},nil,frameLevel)
    local f = r["_PixelGlow"..key]
    if not f.masks then
        f.masks = {}
    end
    if not f.masks[1] then
        f.masks[1] = GlowMaskPool:Acquire()
        f.masks[1]:SetTexture(textureList.empty, "CLAMPTOWHITE","CLAMPTOWHITE")
        f.masks[1]:Show()
    end
    f.masks[1]:SetPoint("TOPLEFT",f,"TOPLEFT",th,-th)
    f.masks[1]:SetPoint("BOTTOMRIGHT",f,"BOTTOMRIGHT",-th,th)

    if not(border==false) then
        if not f.masks[2] then
            f.masks[2] = GlowMaskPool:Acquire()
            f.masks[2]:SetTexture(textureList.empty, "CLAMPTOWHITE","CLAMPTOWHITE")
        end
        f.masks[2]:SetPoint("TOPLEFT",f,"TOPLEFT",th+1,-th-1)
        f.masks[2]:SetPoint("BOTTOMRIGHT",f,"BOTTOMRIGHT",-th-1,th+1)

        if not f.bg then
            f.bg = GlowTexPool:Acquire()
            f.bg:SetColorTexture(0.1,0.1,0.1,0.8)
            f.bg:SetParent(f)
            f.bg:SetAllPoints(f)
            f.bg:SetDrawLayer("ARTWORK",6)
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
    for _,tex in pairs(f.textures) do
        if tex:GetNumMaskTextures() < 1 then
            tex:AddMaskTexture(f.masks[1])
        end
    end
    f.timer = f.timer or 0
    f.info = f.info or {}
    f.info.step = 1/N
    f.info.period = period
    f.info.th = th
    if f.info.length ~= length then
        f.info.width = nil
        f.info.length = length
    end
    pUpdate(f, 0)
    f:SetScript("OnUpdate",pUpdate)
end

function lib.PixelGlow_Stop(r,key)
    if not r then
        return
   	end

    key = key or ""
    if not r["_PixelGlow"..key] then
        return false
    else
        GlowFramePool:Release(r["_PixelGlow"..key])
    end
end

table.insert(lib.glowList, "Pixel Glow")
lib.startList["Pixel Glow"] = lib.PixelGlow_Start
lib.stopList["Pixel Glow"] = lib.PixelGlow_Stop




local ATCB = CreateFrame("FRAME", nil, UIParent)
ATCB:SetPoint("BOTTOM",UIParent,"BOTTOM", 0, 0)
ATCB:SetWidth(0)
ATCB:SetHeight(0)
ATCB:Show();

ATCB.castbar = CreateFrame("StatusBar", nil, UIParent)
ATCB.castbar:SetStatusBarTexture("Interface\\addons\\asTargetCastBar\\UI-StatusBar.blp", "BORDER")
ATCB.castbar:GetStatusBarTexture():SetHorizTile(false)
ATCB.castbar:SetMinMaxValues(0, 100)
ATCB.castbar:SetValue(100)
ATCB.castbar:SetHeight(ATCB_HEIGHT)
ATCB.castbar:SetWidth(ATCB_WIDTH - ATCB_HEIGHT/2)
ATCB.castbar:SetStatusBarColor(1, 0.9, 0.9);
ATCB.castbar:SetAlpha(ATCB_ALPHA);

ATCB.castbar.bg = ATCB.castbar:CreateTexture(nil, "BACKGROUND")
ATCB.castbar.bg:SetPoint("TOPLEFT", ATCB.castbar, "TOPLEFT", -1, 1)
ATCB.castbar.bg:SetPoint("BOTTOMRIGHT", ATCB.castbar, "BOTTOMRIGHT", 1, -1)

ATCB.castbar.bg:SetTexture("Interface\\Addons\\asTargetCastBar\\border.tga")
ATCB.castbar.bg:SetTexCoord(0.1,0.1, 0.1,0.1, 0.1,0.1, 0.1,0.1)	
ATCB.castbar.bg:SetVertexColor(0, 0, 0, 0.8);
ATCB.castbar.bg:Show();

ATCB.castbar.name = ATCB.castbar:CreateFontString( nil , "OVERLAY");
ATCB.castbar.name:SetFont(STANDARD_TEXT_FONT, ATCB_NAME_SIZE);
ATCB.castbar.name:SetPoint("LEFT", ATCB.castbar, "LEFT", 3, 0);

ATCB.castbar.time = ATCB.castbar:CreateFontString( nil , "OVERLAY");
ATCB.castbar.time:SetFont(STANDARD_TEXT_FONT, ATCB_TIME_SIZE);
ATCB.castbar.time:SetPoint("RIGHT", ATCB.castbar, "RIGHT", -3, 0);

ATCB.castbar:SetPoint("CENTER",UIParent,"CENTER", ATCB_X + ATCB_HEIGHT/2, ATCB_Y)
ATCB.castbar:Hide();

ATCB.button = CreateFrame("Button", nil, ATCB.castbar, "ATCBFrameTemplate");
ATCB.button:SetPoint("RIGHT", ATCB.castbar,"LEFT", -1, 0)
ATCB.button:SetWidth((ATCB_HEIGHT + 2) * 1.2);
ATCB.button:SetHeight(ATCB_HEIGHT + 2);
ATCB.button:SetScale(1);
ATCB.button:SetAlpha(1);
ATCB.button:EnableMouse(false);
ATCB.button.icon:SetTexCoord(.08, .92, .08, .92);
ATCB.button.border:SetTexCoord(0.08,0.08, 0.08,0.92, 0.92,0.08, 0.92,0.92);
ATCB.button.border:SetVertexColor(0, 0, 0);
ATCB.button.border:Show();
ATCB.button:Show();

ATCB.start = 0;
ATCB.duration = 0;


LoadAddOn("asMOD");

if asMOD_setupFrame then
    asMOD_setupFrame (ATCB.castbar, "asTargetCastBar");
end

local prev_name = nil;

local function ATCB_OnEvent(self, event, ...)

	if event == "PLAYER_TARGET_CHANGED" or event == "PLAYER_ENTERING_WORLD" then
		
		if UnitExists("target") then
			ATCB:RegisterUnitEvent("UNIT_SPELLCAST_INTERRUPTED", "target");
			ATCB:RegisterUnitEvent("UNIT_SPELLCAST_DELAYED", "target");
			ATCB:RegisterUnitEvent("UNIT_SPELLCAST_CHANNEL_START", "target");
			ATCB:RegisterUnitEvent("UNIT_SPELLCAST_CHANNEL_UPDATE", "target");
			ATCB:RegisterUnitEvent("UNIT_SPELLCAST_CHANNEL_STOP", "target");
			ATCB:RegisterUnitEvent("UNIT_SPELLCAST_EMPOWER_START", "target");
			ATCB:RegisterUnitEvent("UNIT_SPELLCAST_EMPOWER_UPDATE", "target");
			ATCB:RegisterUnitEvent("UNIT_SPELLCAST_EMPOWER_STOP", "target");
			ATCB:RegisterUnitEvent("UNIT_SPELLCAST_INTERRUPTIBLE", "target");
			ATCB:RegisterUnitEvent("UNIT_SPELLCAST_NOT_INTERRUPTIBLE", "target");
			ATCB:RegisterUnitEvent("UNIT_SPELLCAST_START", "target");
			ATCB:RegisterUnitEvent("UNIT_SPELLCAST_STOP", "target");
			ATCB:RegisterUnitEvent("UNIT_SPELLCAST_FAILED", "target");
		else
			ATCB:UnregisterEvent("UNIT_SPELLCAST_INTERRUPTED");
			ATCB:UnregisterEvent("UNIT_SPELLCAST_DELAYED");
			ATCB:UnregisterEvent("UNIT_SPELLCAST_CHANNEL_START");
			ATCB:UnregisterEvent("UNIT_SPELLCAST_CHANNEL_UPDATE");
			ATCB:UnregisterEvent("UNIT_SPELLCAST_CHANNEL_STOP");
			ATCB:UnregisterEvent("UNIT_SPELLCAST_EMPOWER_START");
			ATCB:UnregisterEvent("UNIT_SPELLCAST_EMPOWER_UPDATE");
			ATCB:UnregisterEvent("UNIT_SPELLCAST_EMPOWER_STOP");
			ATCB:UnregisterEvent("UNIT_SPELLCAST_INTERRUPTIBLE");
			ATCB:UnregisterEvent("UNIT_SPELLCAST_NOT_INTERRUPTIBLE");
			ATCB:UnregisterEvent("UNIT_SPELLCAST_START");
			ATCB:UnregisterEvent("UNIT_SPELLCAST_STOP");
			ATCB:UnregisterEvent("UNIT_SPELLCAST_FAILED");
		end	
	end

		local name,  _, texture, start, endTime, isTradeSkill, castID, notInterruptible, spellid = UnitCastingInfo("target");

		if not name then
			name,  _, texture, start, endTime, isTradeSkill, notInterruptible, spellid = UnitChannelInfo("target");
		end
		
		local frameIcon = self.button.icon; 
		local castBar = self.castbar;
		local text  = self.castbar.name;
		local time = self.castbar.time;
		
		if name then
			local current = GetTime();
			frameIcon:SetTexture(texture);

			self.start = start / 1000;
			self.duration = (endTime - start) /1000;
			castBar:SetMinMaxValues(0, self.duration)
			castBar:SetValue(current - self.start);

			local color = {};

			if UnitIsUnit("targettarget", "player") then
				if notInterruptible then
					color = ATCB_NOT_INTERRUPTIBLE_COLOR_TARGET;
				else
					color = ATCB_INTERRUPTIBLE_COLOR_TARGET;
				end

				if (name ~= prev_name) then
					PlaySoundFile("Interface\\AddOns\\asTargetCastBar\\alert.mp3", "DIALOG");
					prev_name = name;
				end

			else
				if notInterruptible then
					color = ATCB_NOT_INTERRUPTIBLE_COLOR;
				else
					color = ATCB_INTERRUPTIBLE_COLOR;
				end
				prev_name = nil;
			end

			castBar:SetStatusBarColor(color[1], color[2], color[3]);
						
			text:SetText(name);
			time:SetText(format("%.1f/%.1f", max((current - self.start), 0), max(self.duration, 0)));
			
			frameIcon:Show();			
			castBar:Show();
			if ATCB_DangerousSpellList[spellid] then
				lib.PixelGlow_Start(castBar, {0, 1, 0.32, 1});
			end
					
		else
			castBar:SetValue(0);
			frameIcon:Hide();
			castBar:Hide();
			lib.PixelGlow_Stop(castBar);
			self.start = 0;
			prev_name = nil;
		end
end


local function ATCB_OnUpdate()

	local start = ATCB.start;

	if start > 0 then
		local castBar = ATCB.castbar;
		local duration = ATCB.duration;
		local current = GetTime();
		local time = ATCB.castbar.time;
		castBar:SetValue((current - start));
		time:SetText(format("%.1f/%.1f", max((current - start), 0), max(duration, 0)));
	end
	
end

ATCB:SetScript("OnEvent", ATCB_OnEvent)
ATCB:RegisterEvent("PLAYER_TARGET_CHANGED");
ATCB:RegisterEvent("PLAYER_ENTERING_WORLD");

C_Timer.NewTicker(ATCB_UPDATE_RATE, ATCB_OnUpdate);