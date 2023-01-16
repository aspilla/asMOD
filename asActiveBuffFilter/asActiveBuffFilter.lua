local ASABF;
local ASABF_PLAYER_BUFF;
local ASABF_SIZE = 25;
local ASABF_PLAYER_BUFF_X = -100;
local ASABF_PLAYER_BUFF_Y = -145;
local ASABF_MAX_BUFF_SHOW = 2;
local ASABF_ALPHA = 1;
local ASABF_CooldownFontSize = 12;		-- Cooldown Font Size
local ASABF_CountFontSize = 11;			-- Count Font Size
local ASABF_AlphaBuff = 0.9;				-- 전투중 Alpha 값
local ASABF_AlphaCool = 0.5;			-- 비 전투중 Alpha 값
local ASABF_AzelateAutoDetect = true;	-- 자동으로 아제라이트 특성을 Detect
local ASABF_AzelateMaxCheckTier = 2;	-- 아제라이트 Check Tier 2 단계 까지 하려면 2로 변경
local ASABF_TrinketAutoDetect = true;	-- 자동으로 사용 장신구를 Detect

local PLAYER_UNITS = {
	player = true,
	vehicle = true,
	pet = true,
};


ASABF_BuffNameList = {}
ASABF_BuffIDList = {}
ASABF_AzeriteTraits = {}; 


-- 발동 주요 공격 버프
-- { 버프 이름 or Spell ID, Type, rppm 혹은 내부 쿨 혹은 리필 타임 혹은 버프 중첩}
-- Type 0 --> 버프만 표시    (음성가능)
-- Type 1 --> RPPM 표시		 (음성가능)
-- Type 2 --> 내부쿨 표시	 (음성가능)
-- Type 3 --> 리필시점 알림  (음성가능)
-- Type 4 --> 버프 중첩 알림 (음성가능)
-- 음성을 이용하려면 sound 폴더에 버프 명.mp3 파일 추가

local ASABF_ProcBuffList = {

	

	--장신구
	{"시카르 여사냥꾼의 기술", 1, 1.5},
	{"소용돌이치는 바람", 1, 1},
	

	--물약

    --잔달라
   

    --8.2 장신구
  
    

}

	
local _G = _G;

local ASABF_Current_Buff = "";
local ASABF_Current_Count = 0;


local a_isProc = {};
local a_isBuffShow = {};
local a_State = {};
local a_Name = {};



local unusedOverlayGlows = {};
local numOverlays = 0;

function  AABF_GetOverlayGlow()
	local overlay = tremove(unusedOverlayGlows);
	if ( not overlay ) then
		numOverlays = numOverlays + 1;
		overlay = CreateFrame("Frame", nil, UIParent, "AABF_ActionBarButtonSpellActivationAlert");
	end
	return overlay;
end


function AABF_ShowOverlayGlow(self)
	if ( self.overlay ) then
		if ( self.overlay.animOut:IsPlaying() ) then
			self.overlay.animOut:Stop();
			self.overlay.animIn:Play();
		end
	else
		self.overlay = AABF_GetOverlayGlow();
		local frameWidth, frameHeight = self:GetSize();
		self.overlay:SetParent(self);
		self.overlay:ClearAllPoints();
		--Make the height/width available before the next frame:
		self.overlay:SetSize(frameWidth * 1.5, frameHeight * 1.5);
		self.overlay:SetPoint("TOPLEFT", self, "TOPLEFT", -frameWidth * 0.3, frameHeight * 0.3);
		self.overlay:SetPoint("BOTTOMRIGHT", self, "BOTTOMRIGHT", frameWidth * 0.3, -frameHeight * 0.3);
		self.overlay.animIn:Play();
	end
end

function AABF_HideOverlayGlow(self)
	if ( self.overlay ) then
		if ( self.overlay.animIn:IsPlaying() ) then
			self.overlay.animIn:Stop();
		end
		if ( self:IsVisible() ) then
			self.overlay.animOut:Play();
		else
			AABF_OverlayGlowAnimOutFinished(self.overlay.animOut);	--We aren't shown anyway, so we'll instantly hide it.
		end
	end
end


function AABF_OverlayGlowAnimOutFinished(animGroup)
	local overlay = animGroup:GetParent();
	local actionButton = overlay:GetParent();
	overlay:Hide();
	tinsert(unusedOverlayGlows, overlay);
	actionButton.overlay = nil;
end

function AABF_OverlayGlowOnUpdate(self, elapsed)
	AnimateTexCoords(self.ants, 256, 256, 48, 48, 22, elapsed, 0.01);
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

local function ASABF_UpdateBuffAnchor(frames, index, anchorIndex, size, offsetX, right, parent)

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

	if ( index == 1 ) then
		buff:SetPoint(point1, parent, point2, 0, 0);
	else
		buff:SetPoint(point1, frames[index - 1], point3, offsetX, 0);
	end

	-- Resize
	buff:SetWidth(size * 1.3);
	buff:SetHeight(size);
end

local function ASABF_UpdateBuff(unit)

	local selfName;
	local numDebuffs = 1;
	local numShow = 1;
	local frame, frameName;
	local frameIcon, frameCount, frameCooldown, frameStealable;
	local name, rank, icon, count, debuffType, duration, expirationTime, caster, isStealable;
	local color;
	local frameBorder;
	local maxIdx;
	local parent;
	local frametype;
	local isFirst = true;

	maxIdx = MAX_TARGET_BUFFS;
	parent = ASABF_PLAYER_BUFF;
		
	i = 1;

	local a_isShow = {};

	if parent.frames == nil then
		parent.frames = {};
	end

	for k = 1 , #ASABF_ProcBuffList do
		a_isShow[k] = false;
	end

	a_isProc2Cnt = 0;

	repeat
		local skip = false;
		local debuff;
		local bufidx;
		local isStealable = false;
		local stack = nil;
		local isTarget = false;
		local alert = false;
		local azerite = false;

		
		name,  icon, count, debuffType, duration, expirationTime, caster, isStealable, shouldConsolidate, spellId, _,_ , casterIsPlayer, nameplateShowAll, stack,value2,value3  = UnitBuff("player", i);
		
		skip = true;

		if (icon == nil) then
			break;
		end


	

		local k = ASABF_BuffNameList[name] or ASABF_BuffIDList[spellId];

		if k and (duration > 0 or count > 1)  then


			a_isProc[k] = { expirationTime , duration, icon, spellId, name};
			a_isShow[k] = true;
			skip = false;
			a_isBuffShow[k] = false;
		elseif ASABF_AzeriteTraits[name] then
			skip = false;
			azerite = true;
		end

		if (icon and skip == false) then

			if numDebuffs > ASABF_MAX_BUFF_SHOW then
				break;
			end

			local color;
			frame = parent.frames[numDebuffs];
			
			if ( not frame ) then
				parent.frames[numDebuffs] = CreateFrame("Button", nil, parent, "asActiveBuffFrameTemplate");
				frame = parent.frames[numDebuffs];
				frame:EnableMouse(false); 
				for _,r in next,{frame.cooldown:GetRegions()}	do 
					if r:GetObjectType()=="FontString" then 
						r:SetFont("Fonts\\2002.TTF",ASABF_CooldownFontSize,"OUTLINE")
						r:SetPoint("TOP", 0, 4);
						break 
					end 
				end

				local font, size, flag = frame.count:GetFont()

				frame.count:SetFont(font, ASABF_CountFontSize, "OUTLINE")
				frame.count:SetPoint("BOTTOMRIGHT", -2, 2);

				frame.icon:SetTexCoord(.08, .92, .08, .92);
				frame.border:SetTexture("Interface\\Addons\\asActiveBuffFilter\\border.tga");
				frame.border:SetTexCoord(0.08,0.08, 0.08,0.92, 0.92,0.08, 0.92,0.92);
				frame.border:SetVertexColor(0, 0, 0);
			end
			-- set the icon
			frameIcon = frame.icon;
			frameIcon:SetTexture(icon);
			frameIcon:SetAlpha(ASABF_ALPHA);
			frameIcon:SetDesaturated(false)


			-- set the count
			frameCount =frame.count;
			-- Handle cooldowns
			frameCooldown = frame.cooldown;
			frame:SetAlpha(ASABF_AlphaBuff);			

			if ( count > 1 ) then
				frameCount:SetText(count);
				frameCount:Show();
			else
				if (stack > 1) then
					if(stack > 999999) then 
						stack = math.ceil(stack/1000000) .. "m" 
					elseif(stack > 999) then 
						stack = math.ceil(stack/1000) .. "k" 
					end   						
						
					frameCount:SetText(stack);
					frameCount:Show();
				else
					frameCount:Hide();
				end

			end				
			
			if ( duration > 0 and duration <= 120 ) then
				frameCooldown:Show();
				asCooldownFrame_Set(frameCooldown, expirationTime - duration, duration, duration >0,  true);
				frameCooldown:SetHideCountdownNumbers(false);

			else
				frameCooldown:Hide();
			end

			if azerite then
				AABF_HideOverlayGlow(frame);				
			elseif  ASABF_ProcBuffList[k][2] == 3 then 
				local alert_du = ASABF_ProcBuffList[k][3]
				if alert_du and (expirationTime - GetTime()) <= alert_du and duration > 0  then
					AABF_ShowOverlayGlow(frame);
					if a_State[k] == nil or a_State[k] == 0 then
						a_State[k] = 1;
                        PlaySoundFile("Interface\\AddOns\\asActiveBuffFilter\\Sound\\".. name.. ".mp3", "DIALOG")                        
					end


			  	else
					AABF_HideOverlayGlow(frame);
				end
			elseif ASABF_ProcBuffList[k][2] == 4 then 
				local alert_count = ASABF_ProcBuffList[k][3]
				if alert_count and count and  count >= alert_count  then
					AABF_ShowOverlayGlow(frame);

					if a_State[k] == nil or a_State[k] == 0 then
						a_State[k] = 1;
						PlaySoundFile("Interface\\AddOns\\asActiveBuffFilter\\Sound\\".. name.. ".mp3", "DIALOG")                        
					end

			  	else
					AABF_HideOverlayGlow(frame);
				end
			else
				AABF_HideOverlayGlow(frame);
			end

			if  not azerite and ASABF_ProcBuffList[k][2] < 2 then
				if a_State[k] == nil or a_State[k] == 0 then
					a_State[k] = 1;
                    PlaySoundFile("Interface\\AddOns\\asActiveBuffFilter\\Sound\\".. name.. ".mp3", "DIALOG")                    
				end
			end

		

			frame:ClearAllPoints();
			frame:Show();

			if  not azerite then
				a_isBuffShow[k] = true;
			end

			numDebuffs = numDebuffs + 1;
			numShow = numShow + 1;
		end
		i = i+1
	until (name == nil)
	

	local z;
	for z = 1 , #ASABF_ProcBuffList do

	
		if a_isProc[z] and not (a_isShow[z]) then
			local activetype = ASABF_ProcBuffList[z][2];
			local rppm = ASABF_ProcBuffList[z][3];
			local icon = a_isProc[z][3]
			local name = a_isProc[z][5]
			
			if activetype == 1 then

				local laststart = a_isProc[z][1] - a_isProc[z][2]
				local currtime = GetTime();
				local haste = GetHaste() / 100 
				local since = currtime - laststart;


				--print (haste, rppm, since);ASABF_SIZE

				--local proc_val = math.floor((rppm * haste * (currtime - laststart) / 60) * 100);


				local proc_val = math.floor((rppm * (1 + haste) * (math.min(since, 10)/60) * math.max(1, ((1+(since/(60/rppm))) - 1.5) * 3))* 100);

				if proc_val < 100 then
					if numDebuffs > ASABF_MAX_BUFF_SHOW then
						break;
					end

					local color;
					frame = parent.frames[numDebuffs];
			
					if ( not frame ) then
						parent.frames[numDebuffs] = CreateFrame("Button", nil, parent, "asActiveBuffFrameTemplate");
						frame = parent.frames[numDebuffs];
						frame:EnableMouse(false); 
						for _,r in next,{frame.cooldown:GetRegions()}	do 
							if r:GetObjectType()=="FontString" then 
								r:SetFont("Fonts\\2002.TTF",ASABF_CooldownFontSize,"OUTLINE")
								r:SetPoint("TOP", 0, 4);
								break 
							end 
						end
		
						local font, size, flag = frame.count:GetFont()
	
						frame.count:SetFont(font, ASABF_CountFontSize, "OUTLINE")
						frame.count:SetPoint("BOTTOMRIGHT", -2, 2);
						frame.icon:SetTexCoord(.08, .92, .08, .92);
						frame.border:SetTexture("Interface\\Addons\\asActiveBuffFilter\\border.tga");
						frame.border:SetTexCoord(0.08,0.08, 0.08,0.92, 0.92,0.08, 0.92,0.92);
						frame.border:SetVertexColor(0, 0, 0);	

					end
				-- set the icon
					frameIcon = frame.icon;
					frameIcon:SetTexture(icon);
					frameIcon:SetAlpha(ASABF_ALPHA);
					frameIcon:SetDesaturated(true)

					frame:SetAlpha(ASABF_AlphaCool);
					
					-- set the count
					frameCount = frame.count;
					-- Handle cooldowns
					frameCooldown = frame.cooldown;
					frameCooldown:Hide();

					if ( proc_val > 0 ) then
						frameCount:SetText(proc_val .. "%");
						frameCount:Show();
					end				

					AABF_HideOverlayGlow(frame);
			
					frame:ClearAllPoints();
					frame:Show();

					numDebuffs = numDebuffs + 1;
				end
			elseif activetype == 2 then
				local laststart = a_isProc[z][1] - a_isProc[z][2]
				local currtime = GetTime();
				local duration = rppm;

				if currtime - laststart < duration then

					if numDebuffs > ASABF_MAX_BUFF_SHOW then
						break;
					end

					local color;
					frame = parent.frames[numDebuffs];
			
					if ( not frame ) then
						parent.frames[numDebuffs] = CreateFrame("Button", nil, parent, "asActiveBuffFrameTemplate");
						frame = parent.frames[numDebuffs];
						frame:EnableMouse(false); 
						for _,r in next,{frame.cooldown:GetRegions()}	do 
							if r:GetObjectType()=="FontString" then 
								r:SetFont("Fonts\\2002.TTF",ASABF_CooldownFontSize,"OUTLINE")
								r:SetPoint("TOP", 0, 4);
								break 
							end 
						end
		
						local font, size, flag = frame.count:GetFont()
	
						frame.count:SetFont(font, ASABF_CountFontSize, "OUTLINE")
						frame.count:SetPoint("BOTTOMRIGHT", -2, 2);
						frame.icon:SetTexCoord(.08, .92, .08, .92);
						frame.border:SetTexture("Interface\\Addons\\asActiveBuffFilter\\border.tga");
						frame.border:SetTexCoord(0.08,0.08, 0.08,0.92, 0.92,0.08, 0.92,0.92);
						frame.border:SetVertexColor(0, 0, 0);

					end
				-- set the icon
					frameIcon = frame.icon;
					frameIcon:SetTexture(icon);
					frameIcon:SetAlpha(ASABF_ALPHA);
					frameIcon:SetDesaturated(true)
					frame:SetAlpha(ASABF_AlphaCool);

					-- set the count
					frameCount = frame.count;
					-- Handle cooldowns
					frameCooldown = frame.cooldown;

					if ( duration > 0 ) then
						frameCooldown:Show();
						asCooldownFrame_Set(frameCooldown, laststart, duration, duration >0,  true);
					else
						frameCooldown:Hide();
					end	


					if (laststart + duration - GetTime()) <= 3 and duration > 0  then
						AABF_ShowOverlayGlow(frame);
				  	else
						AABF_HideOverlayGlow(frame);
					end
					frameCount:Hide();
			
					frame:ClearAllPoints();
					frame:Show();

					numDebuffs = numDebuffs + 1;

					a_State[z] = 2;
				else
					if  a_State[z] == 2 then
						a_State[z] = 0 
						--PlaySoundFile("Interface\\AddOns\\asActiveBuffFilter\\Sound\\".. name.. ".mp3", "DIALOG")
					end
				end			
			end
		end

		if a_isShow[z] == false and (a_State[z] == nil or a_State[z] == 1)  then
			a_State[z] = 0;
		end

	end


	


	for i=1, numDebuffs - 1 do
		if i < numShow then
			ASABF_UpdateBuffAnchor(parent.frames, i, i - 1, ASABF_SIZE, 1, true, parent);
		else
			ASABF_UpdateBuffAnchor(parent.frames, i, i - 1, ASABF_SIZE, 1, true, parent);
		end
	end
	
	for i = numDebuffs, maxIdx do
		frame = parent.frames[i];

		if ( frame ) then
			frame:Hide();	
		end
	end
end

local function ASABF_OnEvent(self, event, arg1, ...)
	if (event == "UNIT_AURA" and arg1 == "player") then
		ASABF_UpdateBuff("pbuff");
	end
end

local update = 0;
local function ASABF_OnUpdate(self, elapsed)

	update = update + elapsed

	if update >= 1  then
		update = 0
		ASABF_UpdateBuff("pbuff");
	end
end

local function ASABF_Init()

	for k = 1 , #ASABF_ProcBuffList do

		local num = tonumber(ASABF_ProcBuffList[k][1])

		if num then
			ASABF_BuffIDList[num] = k;
		else
			ASABF_BuffNameList[ASABF_ProcBuffList[k][1]] = k;
		end
	end


	ASABF = CreateFrame("Frame", nil, UIParent)

	ASABF:SetPoint("CENTER", 0, 0)
	ASABF:SetWidth(1)
	ASABF:SetHeight(1)
	ASABF:SetScale(1)
	ASABF:SetAlpha(ASABF_ALPHA);
	ASABF:Show()

	ASABF_PLAYER_BUFF = CreateFrame("Frame", nil, ASABF);
	ASABF_PLAYER_BUFF:SetPoint("CENTER", ASABF_PLAYER_BUFF_X, ASABF_PLAYER_BUFF_Y)
	ASABF_PLAYER_BUFF:SetWidth(1)
	ASABF_PLAYER_BUFF:SetHeight(1)
	ASABF_PLAYER_BUFF:SetScale(1)
	--ASABF_PLAYER_BUFF:SetFrameStrata("BACKGROUND")
	ASABF_PLAYER_BUFF:Show()

    LoadAddOn("asMOD");

    if asMOD_setupFrame then
        asMOD_setupFrame (ASABF_PLAYER_BUFF, "asActiveBuffFilter");
    end
	
	ASABF:RegisterUnitEvent("UNIT_AURA", "player")
	ASABF:RegisterEvent("AZERITE_ITEM_POWER_LEVEL_CHANGED")
	ASABF:RegisterEvent("AZERITE_EMPOWERED_ITEM_SELECTION_UPDATED")
	
	ASABF:RegisterEvent("PLAYER_EQUIPMENT_CHANGED")
	ASABF:RegisterEvent("PLAYER_ENTERING_WORLD")



	ASABF:SetScript("OnEvent", ASABF_OnEvent)
	ASABF:SetScript("OnUpdate", ASABF_OnUpdate)

end

ASABF_Init()



