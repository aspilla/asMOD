local ASQA;
local ASQA_PLAYER_BUFF;

-- 설정부
local ASQA_SIZE = 50;
local ASQA_PLAYER_BUFF_X = 250;
local ASQA_PLAYER_BUFF_Y = 130 ;
local ASQA_ALPHA = 1;
local ASQA_CooldownFontSize = 18;		-- Cooldown Font Size
local ASQA_CountFontSize = 18;			-- Count Font Size
local ASQA_AlphaBuff = 0.9;				-- 전투중 Alpha 값
local ASQA_AlphaCool = 0.5;				-- 비 전투중 Alpha 값

-- { 디버프 이름 or Spell ID, 내부 쿨}
local ASQA_ProcDeBuffList = {

	{"전율", 20},
--	{"저체온증", 30},
--	{"시간 변위", 60},

}

local ASQA_DeBuffNameList = {};

local a_isProc = {};

local function ASQA_UpdateDebuffAnchor(frames, index, anchorIndex, size, offsetX, right, parent)

	local buff = frames[index];
	local point1 = "TOPLEFT";
	local point2 = "BOTTOMLEFT";
	local point3 = "TOPRIGHT";

	if buff == nil then
		return;
	end

	if (right == false) then
		point1 = "TOPRIGHT";
		point2 = "BOTTOMRIGHT";
		point3 = "TOPLEFT";
		offsetX = -offsetX;
	end

	if ( index == 1 ) then
		buff:SetPoint(point1, parent, point2, 0, 0);
	else
		buff:SetPoint(point1, frames[index-1], point3, offsetX, 0);
	end

	-- Resize
	buff:SetWidth(size);
	buff:SetHeight(size);
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

local function ASQA_UpdateDebuff(unit)

	local i = 1;

	repeat
		local name, icon, _, _, duration, expirationTime, _, _, _, spellID  = UnitDebuff("player", i);
		
		if (name == nil) then
			break;
		end
		
		if ASQA_DeBuffNameList[name] then
			local k = ASQA_DeBuffNameList[name];
			a_isProc[k] = { expirationTime , duration, icon, spellID};			
		end
	
		i = i + 1; 
	until (name == nil)

	local z;
	local numDebuffs = 1;
	local frame;
	local frameIcon, frameCount, frameCooldown;
	local parent;
	
	parent = ASQA_PLAYER_BUFF;

	if ASQA.frames == nil then
		ASQA.frames = {};
	end

	for z = 1 , #ASQA_ProcDeBuffList do

		if a_isProc[z]  then
			
			frame = ASQA.frames[numDebuffs];
			
			if ( not frame ) then
				ASQA.frames[numDebuffs] = CreateFrame("Button", nil, parent, "asQuakingAlertFrameTemplate");
				frame = ASQA.frames[numDebuffs];
				frame:EnableMouse(false);
				frame.icon:SetTexCoord(.08, .92, .08, .92);

				frameCooldown = frame.cooldown;
				for _,r in next,{frameCooldown:GetRegions()}	do 
					if r:GetObjectType()=="FontString" then 
						r:SetFont("Fonts\\2002.TTF",ASQA_CooldownFontSize,"OUTLINE")
						r:SetPoint("CENTER", 0, 0);
						break 
					end 
				end
				frameCooldown:SetHideCountdownNumbers(false);

				frameCount = frame.count;
				local font, size, flag = frameCount:GetFont()

				frameCount:SetFont(font, ASQA_CountFontSize, "OUTLINE")
				frameCount:SetPoint("BOTTOMRIGHT", -2, 2);

			end
			
			local icon = a_isProc[z][3];
			-- set the icon
			frameIcon = frame.icon;
			frameIcon:SetTexture(icon);
			frameIcon:SetAlpha(ASQA_ALPHA);
			frameIcon:Show();
			frame:SetAlpha(ASQA_AlphaCool);

			-- set the count
			frameCount = frame.count;
			-- Handle cooldowns
			frameCooldown = frame.cooldown;
			
			local rppm = ASQA_ProcDeBuffList[z][2];
			local expirationTime = a_isProc[z][1];
			local duration = a_isProc[z][2];
			
		
			local laststart = expirationTime - duration;
			local currtime = GetTime();

			if currtime - laststart >= duration then
				repeat
					expirationTime = expirationTime + rppm;
				until (expirationTime > currtime);
				
				if expirationTime - currtime < 3 then
					-- 3초전 빨간색
					frameIcon:SetVertexColor(1.0, 0, 0);
				else
					frameIcon:SetVertexColor(1.0, 1.0, 1.0);
				end
				frameIcon:SetDesaturated(true);
					
				asCooldownFrame_Set(frameCooldown, expirationTime - rppm, rppm, rppm >0,  true);
				frameCooldown:Show();
			else				
				frameIcon:SetDesaturated(false);

				asCooldownFrame_Set(frameCooldown, expirationTime - duration, duration, duration >0,  true);
				frameCooldown:Show();				
			end

			frameCount:Hide();
			frame:ClearAllPoints();
			frame:Show();
			numDebuffs = numDebuffs + 1;
		end
	end

	for i=1, numDebuffs - 1 do
		ASQA_UpdateDebuffAnchor(ASQA.frames, i, i - 1, ASQA_SIZE, 4, true, parent);
	end
	
	for i = numDebuffs,  #ASQA_ProcDeBuffList do
		frame = ASQA.frames[i];

		if ( frame ) then
			frame:Hide();	
		end
	end
end

local update = 0;
local function ASQA_OnUpdate()
	ASQA_UpdateDebuff("pbuff");
end

local timer = nil;
local function ASQA_OnEvent(self, event, arg1, ...)
	if (event == "PLAYER_ENTERING_WORLD") then

		if timer then
			timer:Cancel();
		end
		a_isProc = {};
		timer = C_Timer.NewTicker(0.1, ASQA_OnUpdate);
	end
end

local function ASQA_Init()

	for k = 1 , #ASQA_ProcDeBuffList do
		ASQA_DeBuffNameList[ASQA_ProcDeBuffList[k][1]] = k;
	end


	ASQA = CreateFrame("Frame", nil, UIParent)

	ASQA:SetPoint("CENTER", 0, 0)
	ASQA:SetWidth(1)
	ASQA:SetHeight(1)
	ASQA:SetScale(1)
	ASQA:SetAlpha(ASQA_ALPHA);
	ASQA:Show()

	ASQA_PLAYER_BUFF = CreateFrame("Frame", nil, ASQA)
    ASQA_PLAYER_BUFF:SetPoint("CENTER", ASQA_PLAYER_BUFF_X, ASQA_PLAYER_BUFF_Y)
	ASQA_PLAYER_BUFF:SetWidth(1)
	ASQA_PLAYER_BUFF:SetHeight(1)
	ASQA_PLAYER_BUFF:SetScale(1)
	ASQA_PLAYER_BUFF:Show()

    LoadAddOn("asMOD");

    if asMOD_setupFrame then
         asMOD_setupFrame (ASQA_PLAYER_BUFF, "asQuakingAlert");
    end
	
	ASQA:RegisterEvent("PLAYER_ENTERING_WORLD")
	ASQA:SetScript("OnEvent", ASQA_OnEvent)
	
end

ASQA_Init();