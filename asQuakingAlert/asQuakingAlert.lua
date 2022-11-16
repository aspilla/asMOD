local ASQA;
local ASQA_PLAYER_BUFF;
local ASQA_SIZE = 60;
local ASQA_PLAYER_BUFF_X = 250;
local ASQA_MAX_BUFF_SHOW = 1;
local ASQA_PLAYER_BUFF_Y = 130 ;
local ASQA_ALPHA = 1;
local ASQA_CooldownFontSize = 18;		-- Cooldown Font Size
local ASQA_CountFontSize = 18;			-- Count Font Size
local ASQA_AlphaBuff = 0.9;				-- 전투중 Alpha 값
local ASQA_AlphaCool = 0.5;				-- 비 전투중 Alpha 값


local ASQA_DeBuffNameList = {}
local ASQA_DeBuffIDList = {}


-- 
-- { 디버프 이름 or Spell ID, 내부 쿨}
local ASQA_ProcDeBuffList = {

	{"전율", 20},

}

local a_isProc = {};


local ASQA_Current_Buff = "";
local ASQA_Current_Count = 0;

local function ASQA_UpdateDebuffAnchor(debuffName, index, anchorIndex, size, offsetX, right, parent)

	local buff = _G[debuffName..index];
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
		buff:SetPoint(point1, _G[debuffName..(index-1)], point3, offsetX, 0);
	end

	-- Resize
	buff:SetWidth(size);
	buff:SetHeight(size);
end


local function ASQA_UpdateDebuff(unit)

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

	selfName = "ASQA_PBUFF_";
	maxIdx = MAX_TARGET_BUFFS;
	parent = ASQA_PLAYER_BUFF;

	frametype = selfName.."Button";

	--for i = 1, maxIdx do
	i = 1;

	repeat
		local skip = false;
		local debuff;
		local bufidx;
		local isStealable = false;
		local stack = nil;
		local isTarget = false;
		local alert = false;

		
		name, icon, count, _, duration, expirationTime, _, _, _, spellID  = UnitDebuff("player", i);
		
		skip = true;

		if (icon == nil) then
			break;
		end
	

		local k = ASQA_DeBuffNameList[name] or ASQA_DeBuffIDList[spellId];

		if k then
			a_isProc[k] = { expirationTime , duration, icon, spellId};
			skip = false;
		end

		if (icon and skip == false) then

			if numDebuffs > ASQA_MAX_BUFF_SHOW then
				break;
			end

			local color;
			frameName = frametype..numDebuffs;
			frame = _G[frameName];
			
			if ( not frame ) then
				frame = CreateFrame("Button", frameName, parent, "asQuakingAlertFrameTemplate");
				frame:EnableMouse(false); 
				for _,r in next,{_G[frameName.."Cooldown"]:GetRegions()}	do 
					if r:GetObjectType()=="FontString" then 
						r:SetFont("Fonts\\2002.TTF",ASQA_CooldownFontSize,"OUTLINE")
						r:SetPoint("CENTER", 0, 0);
						break 
					end 
				end

				local font, size, flag = _G[frameName.."Count"]:GetFont()

				_G[frameName.."Count"]:SetFont(font, ASQA_CountFontSize, "OUTLINE")
				_G[frameName.."Count"]:SetPoint("BOTTOMRIGHT", -2, 2);

			end
			-- set the icon
			frameIcon = _G[frameName.."Icon"];
			frameIcon:SetTexture(icon);
			frameIcon:SetAlpha(ASQA_ALPHA);
			frameIcon:SetDesaturated(false)


			-- set the count
			frameCount = _G[frameName.."Count"];
			-- Handle cooldowns
			frameCooldown = _G[frameName.."Cooldown"];
			
			frame:SetWidth(ASQA_SIZE);
			frame:SetHeight(ASQA_SIZE);
			frame:SetAlpha(ASQA_AlphaBuff);
			frame:SetScale(1);

			if ( count > 1 ) then
				frameCount:SetText(count);
				frameCount:Show();
			else
				frameCount:Hide();
			end				
			
			if ( duration > 0 and duration <= 120 ) then
				frameCooldown:Show();
				CooldownFrame_Set(frameCooldown, expirationTime - duration, duration, duration >0,  true);
				frameCooldown:SetHideCountdownNumbers(false);
			else
				frameCooldown:Hide();
			end

			frame:ClearAllPoints();
			frame:Show();


			numDebuffs = numDebuffs + 1;
			numShow = numShow + 1;

		end
		i = i+1
	until (name == nil)

	local z;
	for z = 1 , #ASQA_ProcDeBuffList do

		if a_isProc[z]  then

			local rppm = ASQA_ProcDeBuffList[z][2];
			local icon = a_isProc[z][3]

			local laststart = a_isProc[z][1] - a_isProc[z][2]
			local currtime = GetTime();
			local duration = rppm;

			if currtime - laststart >= duration then
				a_isProc[z][1] = a_isProc[z][1] + duration;
				laststart = a_isProc[z][1] - a_isProc[z][2];
			end

			if currtime - laststart < duration then

				if numDebuffs > ASQA_MAX_BUFF_SHOW then
					break;
				end

				local color;
				frameName = frametype..numDebuffs;
				frame = _G[frameName];
			
				if ( not frame ) then
					frame = CreateFrame("Button", frameName, parent, "asQuakingAlertFrameTemplate");
					frame:EnableMouse(false); 
					for _,r in next,{_G[frameName.."Cooldown"]:GetRegions()}	do 
						if r:GetObjectType()=="FontString" then 
							r:SetFont("Fonts\\2002.TTF",ASQA_CooldownFontSize,"OUTLINE")
							r:SetPoint("CENTER", 0, 0);
							break 
						end 
					end
		
					local font, size, flag = _G[frameName.."Count"]:GetFont()
	
					_G[frameName.."Count"]:SetFont(font, ASQA_CountFontSize, "OUTLINE")
					_G[frameName.."Count"]:SetPoint("BOTTOMRIGHT", -2, 2);

				end
				-- set the icon
				frameIcon = _G[frameName.."Icon"];
				frameIcon:SetTexture(icon);
				frameIcon:SetAlpha(ASQA_ALPHA);
				frameIcon:SetDesaturated(true)
				frame:SetAlpha(ASQA_AlphaCool);
				--frame:SetScale(0.5);

				-- set the count
				frameCount = _G[frameName.."Count"];
				-- Handle cooldowns
				frameCooldown = _G[frameName.."Cooldown"];
				
				frame:SetWidth(ASQA_SIZE);
				frame:SetHeight(ASQA_SIZE);

				if ( duration > 0 ) then
					frameCooldown:Show();
					CooldownFrame_Set(frameCooldown, laststart, duration, duration >0,  true);
				else
					frameCooldown:Hide();
				end	

				frameCount:Hide();
			
				frame:ClearAllPoints();
				frame:Show();

				numDebuffs = numDebuffs + 1;

				ASQA:SetScript("OnUpdate", ASQA_OnUpdate)

			end
		end
	end


	for i=1, numDebuffs - 1 do
		if i < numShow then
			ASQA_UpdateDebuffAnchor(frametype, i, i - 1, ASQA_SIZE, 4, false, parent);
		else
			ASQA_UpdateDebuffAnchor(frametype, i, i - 1, ASQA_SIZE, 4, false, parent);
		end
	end
	
	for i = numDebuffs, maxIdx do
		frameName = frametype..i;
		frame = _G[frameName];

		if ( frame ) then
			frame:Hide();	
		end
	end
end



function ASQA_OnEvent(self, event, arg1, ...)
	if (event == "UNIT_AURA" ) then
		ASQA_UpdateDebuff("pbuff");
	elseif (event == "PLAYER_ENTERING_WORLD") then
		ASQA:SetScript("OnUpdate", nil)
		a_isProc = {};
	end
end

local update = 0;
function ASQA_OnUpdate(self, elapsed)

	update = update + elapsed

	if update >= 1  then
		update = 0
		ASQA_UpdateDebuff("pbuff");
	end
end

local function ASQA_Init()

	for k = 1 , #ASQA_ProcDeBuffList do

		local num = tonumber(ASQA_ProcDeBuffList[k][1])

		if num then
			ASQA_DeBuffIDList[num] = k;
		else
			ASQA_DeBuffNameList[ASQA_ProcDeBuffList[k][1]] = k;
		end
	end


	ASQA = CreateFrame("Frame", nil, UIParent)

	ASQA:SetPoint("CENTER", 0, 0)
	ASQA:SetWidth(1)
	ASQA:SetHeight(1)
	ASQA:SetScale(1)
	ASQA:SetAlpha(ASQA_ALPHA);
	ASQA:Show()

	ASQA_PLAYER_BUFF = CreateFrame("Frame", "ASQA_PLAYER_BUFF", ASQA)
    ASQA_PLAYER_BUFF:SetPoint("CENTER", ASQA_PLAYER_BUFF_X, ASQA_PLAYER_BUFF_Y)
	ASQA_PLAYER_BUFF:SetWidth(1)
	ASQA_PLAYER_BUFF:SetHeight(1)
	ASQA_PLAYER_BUFF:SetScale(1)
	--ASQA_PLAYER_BUFF:SetFrameStrata("BACKGROUND")
	ASQA_PLAYER_BUFF:Show()

    LoadAddOn("asMOD");

    if asMOD_setupFrame then
         asMOD_setupFrame (ASQA_PLAYER_BUFF, "asQuakingAlert");
    end

	
	ASQA:RegisterUnitEvent("UNIT_AURA", "player")
	ASQA:RegisterEvent("PLAYER_ENTERING_WORLD")
	ASQA:SetScript("OnEvent", ASQA_OnEvent)
	
end

ASQA_Init()
