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

if not ATCB.castbar:GetScript("OnEnter") then
    ATCB.castbar:SetScript("OnEnter", function(s)
        if s.castspellid and s.castspellid > 0 then
            GameTooltip_SetDefaultAnchor(GameTooltip, s);
            GameTooltip:SetSpellByID(s.castspellid);
        end
    end)
    ATCB.castbar:SetScript("OnLeave", function()
        GameTooltip:Hide();
    end)
end
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

ATCB.targetname = ATCB:CreateFontString( nil , "OVERLAY");
ATCB.targetname:SetFont(STANDARD_TEXT_FONT, ATCB_NAME_SIZE);
ATCB.targetname:SetPoint("TOPRIGHT", ATCB.castbar, "BOTTOMRIGHT", 0, -2);

ATCB.start = 0;
ATCB.duration = 0;


LoadAddOn("asMOD");

if asMOD_setupFrame then
    asMOD_setupFrame (ATCB.castbar, "asTargetCastBar");
end

function ATCB_DBMTimer_callback(event, id, ...)
    local msg, timer, icon, type, spellId, colorId, modid, keep, fade, name, guid = ...;
    if spellId then
	    ATCB_DangerousSpellList[spellId] = true;
    end
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

    local frameIcon = self.button.icon; 
    local castBar = self.castbar;
    local text  = self.castbar.name;
    local time = self.castbar.time;
    local targetname = self.targetname;

    if UnitExists("target") then

        local name,  _, texture, start, endTime, isTradeSkill, castID, notInterruptible, spellid = UnitCastingInfo("target");

        if not name then
            name,  _, texture, start, endTime, isTradeSkill, notInterruptible, spellid = UnitChannelInfo("target");
        end
                        
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

                if (name ~= prev_name) and ATCB_DangerousSpellList[spellid] then
                    --PlaySoundFile("Interface\\AddOns\\asTargetCastBar\\alert.mp3", "DIALOG");                    
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

            castBar.castspellid = spellid;

            castBar:SetStatusBarColor(color[1], color[2], color[3]);
                        
            text:SetText(name);
            time:SetText(format("%.1f/%.1f", max((current - self.start), 0), max(self.duration, 0)));
            
            frameIcon:Show();			
            castBar:Show();
            if ATCB_DangerousSpellList[spellid] and notInterruptible == false then
                lib.PixelGlow_Start(castBar, {0, 1, 0.32, 1});
            elseif ATCB_DangerousSpellList[spellid] then
                lib.PixelGlow_Start(castBar, {0, 1, 1, 1});
            end

            if UnitExists("targettarget") and UnitIsPlayer("targettarget") then
                local _, Class = UnitClass("targettarget")
		        local color =RAID_CLASS_COLORS[Class]
		        targetname:SetTextColor(color.r, color.g, color.b);
                targetname:SetText(UnitName("targettarget"));      
                targetname:Show();
            else
                targetname:SetText("");
                targetname:Hide();
            end
                    
        else
            castBar:SetValue(0);
            frameIcon:Hide();
            castBar:Hide();
            lib.PixelGlow_Stop(castBar);
            self.start = 0;
            prev_name = nil;
            targetname:SetText("");
            targetname:Hide();
        end
    else
        castBar:SetValue(0);
        frameIcon:Hide();
        castBar:Hide();
        lib.PixelGlow_Stop(castBar);
        self.start = 0;
        prev_name = nil;
        targetname:SetText("");
        targetname:Hide();

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

local bloaded = LoadAddOn("DBM-Core");
if bloaded then
    DBM:RegisterCallback("DBM_TimerStart", ATCB_DBMTimer_callback );
end