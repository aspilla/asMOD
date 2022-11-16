local ADotF = nil;
local ADotF_PLAYER_DEBUFF;
local ADotF_TARGET_DEBUFF;
local ADotF_DeBuffList = {}

local ADotF_SIZE = 40;
local ADotF_DEBUFF_X = 0;
local ADotF_DEBUFF_Y = 10;
local ADotF_MAX_DEBUFF_SHOW = 5;
local ADotF_ALPHA = 0.9;
local ADotF_CooldownFontSize = 12;
local ADotF_CountFontSize = 12;			


ADotF_ShowList = nil;
ADotF_NameList = {};


ADotF_ShowList_WARRIOR_1 = {
	{"난도질" , 15 * 0.3},	
}

ADotF_ShowList_WARRIOR_2 = {
}

ADotF_ShowList_WARRIOR_3 = {
}




ADotF_ShowList_ROGUE_1 = {
	{"파열" , 24 * 0.3},	
}

ADotF_ShowList_ROGUE_2 = {
	
}

ADotF_ShowList_ROGUE_3 = {
	
}

ADotF_ShowList_WARLOCK_1 = {
	{"고통" , 14 * 0.3},	
	{"불안정한 고통" , 21 * 0.3},	
	{"부패" , 14 * 0.3},	
}

ADotF_ShowList_WARLOCK_2 = {
	
}


ADotF_ShowList_WARLOCK_3 = {
	{"제물" , 24 * 0.3},	
	
}

ADotF_ShowList_PRIEST_1 = {
	{"어둠의 권능: 고통" , 16 * 0.3},
}


ADotF_ShowList_PRIEST_3 = {
	{"어둠의 권능: 고통" , 16 * 0.3},	
}

ADotF_ShowList_SHAMAN_1 = {
	{"화염 충격" , 18 * 0.3},	
}

ADotF_ShowList_SHAMAN_2 = {
}

ADotF_ShowList_DRUID_1 = {
	{"달빛섬광" , 22 * 0.3},	
	{"태양섬광" , 18 * 0.3},	
}


ADotF_ShowList_DRUID_2 = {
	{"갈퀴 발톱" , 15 * 0.3},
	{"도려내기" , 24 * 0.3},	
}

ADotF_ShowList_DEATHKNIGHT_1 = {
	
}

ADotF_ShowList_DEATHKNIGHT_2 = {
	
}

ADotF_ShowList_DEATHKNIGHT_3 = {
	{"악성 역병", 24 * 0.3},
}

ADotF_ShowList_HUNTER_2 = {

}

ADotF_ShowList_HUNTER_3 = {
	{"독사 쐐기", 12 * 0.3},
}




local Prev_ExTime = {};


--설정 표시할 Unit
local ADotF_UnitList = {
	"target", 		-- 대상 표시 안하길 원하면 이 줄 삭제
	"focus",			-- 주시대상 표시 안하길 원하면 이 줄 삭제
	"boss1",
	"boss2",
	"boss3",
	"boss4",
	"boss5",
}

local prev_info = {};


local function ADotF_UnitDebuff_Name(unit, buff, filter)

	local name, icon, count, debuffType, duration, expirationTime, caster, isStealable, shouldConsolidate, spellId, canApplyAura, isBossDebuff, value1, value2, value3;
	local i = 1;
	repeat

		name, icon, count, debuffType, duration, expirationTime, caster, isStealable, shouldConsolidate, spellId, canApplyAura, isBossDebuff, value1, value2, value3 = UnitDebuff(unit, i, filter);

		if name == buff then
			return 	name, icon, count, debuffType, duration, expirationTime, caster, isStealable, shouldConsolidate, spellId, canApplyAura, isBossDebuff, value1, value2, value3;
		end


		i = i + 1;


	until (name == nil)

	return name, icon, count, debuffType, duration, expirationTime, caster, isStealable, shouldConsolidate, spellId, canApplyAura, isBossDebuff, value1, value2, value3;

end


function ADotF_UpdateDebuff(unit)

	local selfName;
	local numDebuffs = 1;
	local frame, frameName;
	local frameIcon, frameCount, frameCooldown;
	local name, rank, icon, count, debuffType, duration, expirationTime, caster, isStealable, shouldConsolidate, spellId ;
	local color;
	local frameBorder;
	local maxIdx;
	local parent;
	local frametype;
	local filter = nil;
	local find = false
	local powerbar;


	for i = 1, #ADotF_UnitList do
		if unit == ADotF_UnitList[i] then
			find = true;
			break;
		end			
	end

	if not find then
		return;
	end


	if (unit == "target") then
		selfName = "ADotF_TargetDEBUFF_";
		maxIdx = MAX_TARGET_DEBUFFS;
		parent = _G["TargetFrame"];
		powerbar = _G["TargetFramePowerBarAlt"];
	elseif (unit == "focus") then
		selfName = "ADotF_FocusDEBUFF_";
		maxIdx = MAX_TARGET_DEBUFFS;
		parent = _G["FocusFrame"];
	elseif (unit == "boss1") then
		selfName = "ADotF_Boss1DEBUFF_";
		maxIdx = MAX_TARGET_DEBUFFS;
		parent = _G["Boss1TargetFrame"];
		powerbar = _G["Boss1TargetFramePowerBarAlt"];
	elseif (unit == "boss2") then
		selfName = "ADotF_Boss2DEBUFF_";
		maxIdx = MAX_TARGET_DEBUFFS;
		parent = _G["Boss2TargetFrame"];
		powerbar = _G["Boss2TargetFramePowerBarAlt"];
	elseif (unit == "boss3") then
		selfName = "ADotF_Boss3DEBUFF_";
		maxIdx = MAX_TARGET_DEBUFFS;
		parent = _G["Boss3TargetFrame"];
		powerbar = _G["Boss3TargetFramePowerBarAlt"];
	elseif (unit == "boss4") then
		selfName = "ADotF_Boss4DEBUFF_";
		maxIdx = MAX_TARGET_DEBUFFS;
		parent = _G["Boss4TargetFrame"];
		powerbar = _G["Boss4TargetFramePowerBarAlt"];
	elseif (unit == "boss5") then
		selfName = "ADotF_Boss5DEBUFF_";
		maxIdx = MAX_TARGET_DEBUFFS;
		parent = _G["Boss5TargetFrame"];
		powerbar = _G["Boss5TargetFramePowerBarAlt"];
	else
		return;
	end

	frametype = selfName.."Button";
	isMine = {};
	
	if not ADotF_ShowList then
		return;
	end

	if not Prev_ExTime[unit] then
		Prev_ExTime[unit] = {}
	end

	maxIdx =  #ADotF_ShowList;


	--print ("update");

	--for i = 1, maxIdx do
	for i = 1, #ADotF_ShowList do 
		local skip = false;
		local debuff;

			
		local filter;

		name, icon, count, debuffType, duration, expirationTime, caster, isStealable, shouldConsolidate, spellId, canApplyAura, isBossDebuff, value1, value2, value3   = ADotF_UnitDebuff_Name(unit, ADotF_ShowList[i][1], "PLAYER");

		local prev = prev_info[unit][numDebuffs]

		if unit == "target" and ACI_Debuff_list and ACI_Debuff_list[name] then
			icon = nil;
		end

		if icon and  caster == "player" or caster == "pet"  then
			
			local bAlert = false;
				
			if numDebuffs > ADotF_MAX_DEBUFF_SHOW then
				break;
			end

			if ((expirationTime - GetTime()) <= ADotF_ShowList[i][2]) and duration > 0  then
				bAlert = true;
			end

		
			if not ( prev[1] == spellId and prev[2] == duration and prev[3] == expirationTime and prev[4] == bAlert )then


				prev_info[unit][numDebuffs] = {spellId, duration, expirationTime, bAlert};

				Prev_ExTime[unit][i] = expirationTime;

				frameName = frametype..numDebuffs;
	
				frame = _G[frameName];

				if ( not frame ) then
					frame = CreateFrame("Button", frameName, parent, "asTargetDotFrameTemplate");
					frame:EnableMouse(false); 
					for _,r in next,{_G[frameName.."Cooldown"]:GetRegions()}	do 
						if r:GetObjectType()=="FontString" then 
							r:SetFont("Fonts\\2002.TTF",ADotF_CooldownFontSize,"OUTLINE")
							break 
						end 
					end

					local font, size, flag = _G[frameName.."Count"]:GetFont()

					_G[frameName.."Count"]:SetFont(font, ADotF_CountFontSize, "OUTLINE")
					_G[frameName.."Count"]:SetPoint("BOTTOMRIGHT", -2, 2);
				end

				-- set the icon
				frameIcon = _G[frameName.."Icon"];
				frameIcon:SetTexture(icon);
				frameIcon:SetAlpha(ADotF_ALPHA);

				-- set the count
				frameCount = _G[frameName.."Count"];

				-- Handle cooldowns
				frameCooldown = _G[frameName.."Cooldown"];
		
				if ( count > 1 ) then
					frameCount:SetText(count);
					frameCount:Show();
					frameCooldown:SetDrawSwipe(false);
				else
					frameCount:Hide();
					frameCooldown:SetDrawSwipe(true);
				end

		
				if ( duration > 0 ) then
					frameCooldown:Show();
					CooldownFrame_Set(frameCooldown, expirationTime - duration, duration, duration > 0, true);
					frameCooldown:SetHideCountdownNumbers(false);
				else
					frameCooldown:Hide();
				end

				-- set debuff type color
				if ( debuffType ) then
					color = DebuffTypeColor[debuffType];
				else
					color = DebuffTypeColor["none"];
				end
			
				frameBorder = _G[frameName.."Border"];
				frameBorder:SetVertexColor(color.r, color.g, color.b);
				frameBorder:SetAlpha(ADotF_ALPHA);
							
				frame:ClearAllPoints();
				frame:Show();

				if (bAlert) then
					ADotF_ShowOverlayGlow(frame);
					Prev_ExTime[unit][i] = nil;
				else
					ADotF_HideOverlayGlow(frame);
				end


				numDebuffs = numDebuffs + 1;
			else
				numDebuffs = numDebuffs + 1;
			end
		end
	end

	if (unit == "target")  then
		for i=1, numDebuffs - 1 do
			ADotF_UpdateDebuffAnchor(frametype, i, i - 1, ADotF_SIZE, 4, true, parent, powerbar);
		end
	else
		for i=1, numDebuffs - 1 do
			ADotF_UpdateDebuffAnchor(frametype, i, i - 1, ADotF_SIZE, 4, false, parent, powerbar);
		end
	end

	for i = numDebuffs, maxIdx do
		frameName = frametype..i;
		frame = _G[frameName];

		if ( frame ) then
			ADotF_HideOverlayGlow(frame);
			frame:Hide();	
		end

		prev_info[unit][i] =  {0, 0, 0, false};

	end
end

function ADotF_UpdateDebuffAnchor(debuffName, index, anchorIndex, size, offsetX, right, parent, powerbar)

	local buff = _G[debuffName..index];
	local point1 = "LEFT";
	local point2 = "RIGHT";
	local point3 = "RIGHT";

	if powerbar and (powerbar:IsShown())then
		parent = powerbar;	
	end


	if (right == false) then
		point1 = "RIGHT";
		point2 = "LEFT";
		point3 = "LEFT";
		offsetX = -offsetX;
	end
	
	if ( index == 1 ) then
		buff:SetPoint(point1, parent, point2, ADotF_DEBUFF_X, ADotF_DEBUFF_Y);
	else

		buff:SetPoint(point1, _G[debuffName..anchorIndex], point3, offsetX, 0);
	end

	-- Resize
	buff:SetWidth(size);
	buff:SetHeight(size);
	local debuffFrame =_G[debuffName..index.."Border"];
	debuffFrame:SetWidth(size+2);
	debuffFrame:SetHeight(size+2);
end


function ADotF_ClearFrame()
	
	local selfName = "ADotF_FocusDEBUFF_";

	for i = 1, MAX_TARGET_DEBUFFS do
		frameName = selfName.."Debuff"..i;
		frame = _G[frameName];

		if ( frame ) then
			frame:Hide();	
		end
	end
end

function ADotF_UpdateBossFrame()

		unit = "boss1";

		prev_info[unit] = {};

		for i = 1, ADotF_MAX_DEBUFF_SHOW do 
			prev_info[unit][i] = {0, 0, 0, false};
		end
		
		ADotF_UpdateDebuff(unit);


		unit = "boss2";

		prev_info[unit] = {};

		for i = 1, ADotF_MAX_DEBUFF_SHOW do 
			prev_info[unit][i] =  {0, 0, 0, false};
		end
		
		ADotF_UpdateDebuff(unit);

		unit = "boss3";

		prev_info[unit] = {};

		for i = 1, ADotF_MAX_DEBUFF_SHOW do 
			prev_info[unit][i] = {0, 0, 0, false};
		end
		
		ADotF_UpdateDebuff(unit);

		unit = "boss4";

		prev_info[unit] = {};

		for i = 1, ADotF_MAX_DEBUFF_SHOW do 
			prev_info[unit][i] = {0, 0, 0, false};
		end
		
		ADotF_UpdateDebuff(unit);

		unit = "boss5";

		prev_info[unit] = {};

		for i = 1, ADotF_MAX_DEBUFF_SHOW do 
			prev_info[unit][i] = {0, 0, 0, false};
		end
		
		ADotF_UpdateDebuff(unit);


end



function ADotF_OnEvent(self, event, arg1)

	local unit;

	if (event == "PLAYER_FOCUS_CHANGED") then
		
		unit = "focus";

		prev_info[unit] = {};

		for i = 1, ADotF_MAX_DEBUFF_SHOW do 
			prev_info[unit][i] =  {0, 0, 0, false};

		end
		
		ADotF_UpdateDebuff(unit);
	elseif (event == "PLAYER_TARGET_CHANGED") then
			
		unit = "target";

		prev_info[unit] = {};

		for i = 1, ADotF_MAX_DEBUFF_SHOW do 
			prev_info[unit][i] =  {0, 0, 0, false};
		end
		
		ADotF_UpdateDebuff(unit);

	elseif (event == "INSTANCE_ENCOUNTER_ENGAGE_UNIT") then
		
		ADotF_UpdateBossFrame();


	elseif (event == "ACTIONBAR_UPDATE_COOLDOWN") then

		for i = 1, #ADotF_UnitList do
			if arg1 == ADotF_UnitList[i] then
				ADotF_UpdateDebuff(ADotF_UnitList[i]);
			end
		end

	elseif (event == "PLAYER_ENTERING_WORLD") then
		ADotF_InitList();
		ADotF_UpdateBossFrame();
	elseif (event == "ACTIVE_TALENT_GROUP_CHANGED") then
		ADotF_InitList();
		
	end
end

local function ADotF_OnUpdate()

	

	for idx = 1, #ADotF_UnitList do

		local unit = ADotF_UnitList[idx];

		ADotF_UpdateDebuff(unit);
			--[[


			if not ADotF_ShowList then
				return;
			end

			for i = 1, #ADotF_ShowList do 
				if Prev_ExTime[unit] then
					local expirationTime = Prev_ExTime[unit][i];
					
					if expirationTime and ((expirationTime - GetTime()) <= ADotF_ShowList[i][2]) then
						Prev_ExTime[unit][i] = nil;
						ADotF_UpdateDebuff(unit);
					end
				end
			end
			--]]
	end
end


function ADotF_InitList()

	local spec = GetSpecialization();
	local localizedClass, englishClass = UnitClass("player")


	if spec then
		listname = "ADotF_ShowList_" .. englishClass .. "_" .. spec;
	end

	ADotF_ShowList = _G[listname];

	for idx = 1, #ADotF_UnitList do
		local unit = ADotF_UnitList[idx];

		prev_info[unit] = {};

		for i = 1, ADotF_MAX_DEBUFF_SHOW do 
			prev_info[unit][i] =  {0, 0, 0, false};
		end

	end

	ADotF_NameList = {};

	if ADotF_ShowList then
		for idx = 1, #ADotF_ShowList do	
			ADotF_NameList[ADotF_ShowList[idx][1]] = ADotF_ShowList[idx][2];
		end
	end



end


local unusedOverlayGlows = {};
local numOverlays = 0;

function  ADotF_GetOverlayGlow()
	local overlay = tremove(unusedOverlayGlows);
	if ( not overlay ) then
		numOverlays = numOverlays + 1;
		overlay = CreateFrame("Frame", "ADotF_ActionButtonOverlay"..numOverlays, UIParent, "ADotF_ActionBarButtonSpellActivationAlert");
	end
	return overlay;
end


function ADotF_ShowOverlayGlow(self)
	if ( self.overlay ) then
		if ( self.overlay.animOut:IsPlaying() ) then
			self.overlay.animOut:Stop();
			self.overlay.animIn:Play();
		end
	else
		self.overlay = ADotF_GetOverlayGlow();
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

function ADotF_OverlayGlowAnimOutFinished(animGroup)
	local overlay = animGroup:GetParent();
	local actionButton = overlay:GetParent();
	overlay:Hide();
	tinsert(unusedOverlayGlows, overlay);
	actionButton.overlay = nil;
end


function ADotF_HideOverlayGlow(self)
	if ( self.overlay ) then
		if ( self.overlay.animIn:IsPlaying() ) then
			self.overlay.animIn:Stop();
		end
		if ( self:IsVisible() ) then
			self.overlay.animOut:Play();
		else
			ADotF_OverlayGlowAnimOutFinished(self.overlay.animOut);	--We aren't shown anyway, so we'll instantly hide it.
		end
	end
end

function ADotF_OverlayGlowOnUpdate(self, elapsed)
	AnimateTexCoords(self.ants, 256, 256, 48, 48, 22, elapsed, 0.01);
end





function ADotF_Init()
	

	ADotF = CreateFrame("Frame", "ADotF", UIParent)

	ADotF:SetPoint("CENTER", 0, 0)
	ADotF:SetWidth(1)
	ADotF:SetHeight(1)
	ADotF:SetScale(1)
	ADotF:Show()
	ADotF:RegisterEvent("PLAYER_FOCUS_CHANGED")
	ADotF:RegisterEvent("PLAYER_TARGET_CHANGED")
	--ADotF:RegisterUnitEvent("UNIT_AURA", "target", "focus","boss1", "boss2", "boss3", "boss4", "boss5" )
	ADotF:RegisterEvent("INSTANCE_ENCOUNTER_ENGAGE_UNIT")
	ADotF:RegisterEvent("PLAYER_ENTERING_WORLD")
	ADotF:RegisterEvent("ACTIVE_TALENT_GROUP_CHANGED")
	ADotF:RegisterEvent("ACTIONBAR_UPDATE_COOLDOWN")



	ADotF:SetScript("OnEvent", ADotF_OnEvent)
	C_Timer.NewTicker(0.5, ADotF_OnUpdate);
	
end

ADotF_Init()

