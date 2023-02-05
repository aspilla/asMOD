local ADotF_SIZE = 30;
local ADotF_MAX_DEBUFF_SHOW = 5;
local ADotF_ALPHA = 0.9;
local ADotF_CooldownFontSize = 12;
local ADotF_CountFontSize = 12;	

ADotF_ShowList_WARRIOR_1 = {
	{"분쇄" , 15 * 0.3},	
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
	{"파열" , 24 * 0.3},	
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

ADotF_ShowList_PRIEST_2 = {
}

ADotF_ShowList_PRIEST_3 = {
	{"어둠의 권능: 고통" , 16 * 0.3},	
}

ADotF_ShowList_SHAMAN_1 = {
	{"화염 충격" , 18 * 0.3},	
}

ADotF_ShowList_SHAMAN_2 = {
}

ADotF_ShowList_SHAMAN_3 = {
}

ADotF_ShowList_DRUID_1 = {
	{"달빛섬광" , 22 * 0.3},	
	{"태양섬광" , 13.5 * 0.3},	
	{"항성의 섬광" , 18 * 0.3},	
}


ADotF_ShowList_DRUID_2 = {
	{"갈퀴 발톱" , 15 * 0.3},
	{"도려내기" , 24 * 0.3},	
}

ADotF_ShowList_DRUID_3 = {
	{"달빛섬광" , 22 * 0.3},		
}

ADotF_ShowList_DRUID_4 = {
	{"달빛섬광" , 22 * 0.3},		
}

ADotF_ShowList_DEATHKNIGHT_1 = {
	{"서리 열병", 0},
}

ADotF_ShowList_DEATHKNIGHT_2 = {
	{"피의 역병", 0},
}

ADotF_ShowList_DEATHKNIGHT_3 = {
	{"악성 역병", 24 * 0.3},
	{"고름 상처", 0},
}

ADotF_ShowList_HUNTER_1 = {
	{"날카로운 사격", 2},
	{"독사 쐐기", 12 * 0.3},
}

ADotF_ShowList_HUNTER_2 = {
	{"독사 쐐기", 12 * 0.3},
}

ADotF_ShowList_HUNTER_3 = {
	{"독사 쐐기", 12 * 0.3},
}


--설정 표시할 Unit
local ADotF_UnitList = {
	"focus",			-- 주시대상 표시 안하길 원하면 이 줄 삭제
	"boss1",
	"boss2",
	"boss3",
	"boss4",
	"boss5",
}

--설정 끝

local ADotF = nil;
ADotF_ShowList = nil;
ADotF_NameList = {};


--Overlay stuff
local unusedOverlayGlows = {};
local numOverlays = 0;
local function ADotF_ActionButton_GetOverlayGlow()
	local overlay = tremove(unusedOverlayGlows);
	if ( not overlay ) then
		numOverlays = numOverlays + 1;
		overlay = CreateFrame("Frame", "ADotF_ActionButtonOverlay"..numOverlays, UIParent, "ADotF_ActionBarButtonSpellActivationAlert");
	end
	return overlay;
end

-- Shared between action button and MainMenuBarMicroButton
local function ADotF_ActionButton_ShowOverlayGlow(button)
	if ( button.overlay ) then
		if ( button.overlay.animOut:IsPlaying() ) then
			button.overlay.animOut:Stop();
			button.overlay.animIn:Play();
		end
	else
		button.overlay = ADotF_ActionButton_GetOverlayGlow();
		local frameWidth, frameHeight = button:GetSize();
		button.overlay:SetParent(button);
		button.overlay:ClearAllPoints();
		--Make the height/width available before the next frame:
		button.overlay:SetSize(frameWidth * 1.5, frameHeight * 1.5);
		button.overlay:SetPoint("TOPLEFT", button, "TOPLEFT", -frameWidth * 0.3, frameHeight * 0.3);
		button.overlay:SetPoint("BOTTOMRIGHT", button, "BOTTOMRIGHT", frameWidth * 0.3, -frameHeight * 0.3);
		button.overlay.animIn:Play();
	end
end

-- Shared between action button and MainMenuBarMicroButton
local function ADotF_ActionButton_HideOverlayGlow(button)
	if ( button.overlay ) then
		if ( button.overlay.animIn:IsPlaying() ) then
			button.overlay.animIn:Stop();
		end
		if ( button:IsVisible() ) then
			button.overlay.animOut:Play();
		else
			button.overlay.animOut:OnFinished();	--We aren't shown anyway, so we'll instantly hide it.
		end
	end
end

ADotF_ActionBarButtonSpellActivationAlertMixin = {};

function ADotF_ActionBarButtonSpellActivationAlertMixin:OnUpdate(elapsed)
	AnimateTexCoords(self.ants, 256, 256, 48, 48, 22, elapsed, 0.01);
	local cooldown = self:GetParent().cooldown;
	-- we need some threshold to avoid dimming the glow during the gdc
	-- (using 1500 exactly seems risky, what if casting speed is slowed or something?)
	if(cooldown and cooldown:IsShown() and cooldown:GetCooldownDuration() > 3000) then
		self:SetAlpha(0.5);
	else
		self:SetAlpha(1.0);
	end
end

function ADotF_ActionBarButtonSpellActivationAlertMixin:OnHide()
	if ( self.animOut:IsPlaying() ) then
		self.animOut:Stop();
		self.animOut:OnFinished();
	end
end

ADotF_ActionBarOverlayGlowAnimInMixin = {};

function ADotF_ActionBarOverlayGlowAnimInMixin:OnPlay()
	local frame = self:GetParent();
	local frameWidth, frameHeight = frame:GetSize();
	frame.spark:SetSize(frameWidth, frameHeight);
	frame.spark:SetAlpha(0);
	frame.innerGlow:SetSize(frameWidth, frameHeight);
	frame.innerGlow:SetAlpha(1);
	frame.innerGlowOver:SetAlpha(1);
	frame.outerGlow:SetSize(frameWidth, frameHeight);
	frame.outerGlow:SetAlpha(1);
	frame.outerGlowOver:SetAlpha(1);
	frame.ants:SetSize(frameWidth * 0.8, frameHeight * 0.8)
	frame.ants:SetAlpha(0);
	frame:Show();
end

function ADotF_ActionBarOverlayGlowAnimInMixin:OnFinished()
	local frame = self:GetParent();
	local frameWidth, frameHeight = frame:GetSize();
	frame.spark:SetAlpha(0);
	frame.innerGlow:SetAlpha(0);
	frame.innerGlow:SetSize(frameWidth, frameHeight);
	frame.innerGlowOver:SetAlpha(0.0);
	frame.outerGlow:SetSize(frameWidth, frameHeight);
	frame.outerGlowOver:SetAlpha(0.0);
	frame.outerGlowOver:SetSize(frameWidth, frameHeight);
	frame.ants:SetAlpha(1.0);
end

ADotF_ActionBarOverlayGlowAnimOutMixin = {};

function ADotF_ActionBarOverlayGlowAnimOutMixin:OnFinished()
	local overlay = self:GetParent();
	local actionButton = overlay:GetParent();
	overlay:Hide();
	tinsert(unusedOverlayGlows, overlay);
	actionButton.overlay = nil;
end


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

local function ADotF_UpdateDebuffAnchor(frames, index, size, offsetX, right, parent, isboss)

	local buff = frames[index];
	local point1 = "LEFT";
	local point2 = "RIGHT";
	local point3 = "RIGHT";

	if (right == false) then
		point1 = "RIGHT";
		point2 = "LEFT";
		point3 = "LEFT";
		offsetX = -offsetX;
	end

	if ( index == 1 ) then
		if isboss then
			buff:SetPoint(point1, parent, point2, -60, 0);
		else
			buff:SetPoint(point1, parent, point2, 0, 0);
		end
	else
		buff:SetPoint(point1, frames[index-1], point3, offsetX, 0);
	end

	-- Resize
	buff:SetWidth(size);
	buff:SetHeight(size * 0.8);
end


local function ADotF_UpdateDebuff(unit)

	local numDebuffs = 1;
	local frame;
	local frameIcon, frameCount, frameCooldown;
	local icon, count, debuffType, duration, expirationTime, caster;
	local color;
	local frameBorder;
	local parent;
	local find = false;
	local isboss = true;
	
	for i = 1, #ADotF_UnitList do
		if unit == ADotF_UnitList[i] then
			find = true;
			break;
		end			
	end

	if not find then
		return;
	end

	if not ADotF_ShowList then
		return;
	end

	if not ADotF.units then
		ADotF.units = {};		
	end

	if not ADotF.units[unit] then
		ADotF.units[unit] = {};		
	end

	if not ADotF.units[unit].frames then
		ADotF.units[unit].frames = {};		
	end

	local maxIdx =  #ADotF_ShowList;

	if UnitExists(unit) then
	
		if (unit == "target") then
			parent = _G["TargetFrame"];
			isboss = false;
		elseif (unit == "focus") then
			parent = _G["FocusFrame"];
			isboss = false;
		elseif (unit == "boss1") then
			parent = _G["Boss1TargetFrame"];
		elseif (unit == "boss2") then
			parent = _G["Boss2TargetFrame"];
		elseif (unit == "boss3") then
			parent = _G["Boss3TargetFrame"];
		elseif (unit == "boss4") then
			parent = _G["Boss4TargetFrame"];
		elseif (unit == "boss5") then
			parent = _G["Boss5TargetFrame"];
		else
			return;
		end
			
		for i = 1, #ADotF_ShowList do 
		
			_, icon, count, debuffType, duration, expirationTime, caster = ADotF_UnitDebuff_Name(unit, ADotF_ShowList[i][1], "PLAYER");

			if icon and  caster == "player" or caster == "pet"  then
		
				if numDebuffs > ADotF_MAX_DEBUFF_SHOW then
					break;
				end
		
				frame = ADotF.units[unit].frames[numDebuffs];

				if ( not frame ) then
					ADotF.units[unit].frames[numDebuffs] = CreateFrame("Button", nil, ADotF, "asTargetDotFrameTemplate");
					frame = ADotF.units[unit].frames[numDebuffs];
					frame:EnableMouse(false); 
					for _,r in next,{frame.cooldown:GetRegions()}	do 
						if r:GetObjectType()=="FontString" then 
							r:SetFont("Fonts\\2002.TTF",ADotF_CooldownFontSize,"OUTLINE");
							r:ClearAllPoints();
							r:SetPoint("TOP", 0, 5);
							break;
						end 
					end

					frame.icon:SetTexCoord(.08, .92, .08, .92);
					frame.border:SetTexture("Interface\\Addons\\asDotFilter\\border.tga");
					frame.border:SetTexCoord(0.08,0.08, 0.08,0.92, 0.92,0.08, 0.92,0.92);

					local font = frame.count:GetFont()

					frame.count:SetFont(font, ADotF_CountFontSize, "OUTLINE")
					frame.count:SetPoint("BOTTOMRIGHT", -2, 2);
				end

				-- set the icon
				frameIcon = frame.icon;
				frameIcon:SetTexture(icon);
				frameIcon:SetAlpha(ADotF_ALPHA);

				-- set the count
				frameCount = frame.count;

				-- Handle cooldowns
				frameCooldown = frame.cooldown;
			
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
					asCooldownFrame_Set(frameCooldown, expirationTime - duration, duration, duration > 0, true);
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
				
				frameBorder = frame.border;
				frameBorder:SetVertexColor(color.r, color.g, color.b);
				frameBorder:SetAlpha(ADotF_ALPHA);
								
				frame:ClearAllPoints();
				frame:Show();

				if (((expirationTime - GetTime()) <= ADotF_ShowList[i][2]) and duration > 0) then
					ADotF_ActionButton_ShowOverlayGlow(frame);
				else
					ADotF_ActionButton_HideOverlayGlow(frame);
				end
				numDebuffs = numDebuffs + 1;
			end
		end

		for i=1, numDebuffs - 1 do
			ADotF_UpdateDebuffAnchor(ADotF.units[unit].frames, i, ADotF_SIZE, 2, true, parent, isboss);
		end
	end
	
	for i = numDebuffs, maxIdx do
		frame = ADotF.units[unit].frames[i];

		if ( frame ) then
			ADotF_ActionButton_HideOverlayGlow(frame);
			frame:Hide();	
		end
	end
end


local function ADotF_UpdateAllFrames()
	for i = 1, #ADotF_UnitList do
		ADotF_UpdateDebuff(ADotF_UnitList[i]);
	end
end

local function ADotF_InitList()

	local spec = GetSpecialization();
	local _, englishClass = UnitClass("player");
	local listname = "ADotF_ShowList_";

	if spec then
		listname = "ADotF_ShowList_" .. englishClass .. "_" .. spec;
	end

	ADotF_ShowList = _G[listname];
	ADotF_NameList = {};

	if ADotF_ShowList then
		for idx = 1, #ADotF_ShowList do	
			ADotF_NameList[ADotF_ShowList[idx][1]] = ADotF_ShowList[idx][2];
		end
	end
end

local function ADotF_OnEvent(self, event, arg1)

	local unit;

	if (event == "PLAYER_FOCUS_CHANGED") then
		unit = "focus"
		ADotF_UpdateDebuff(unit);
	elseif (event == "PLAYER_TARGET_CHANGED") then
		unit = "target";
		ADotF_UpdateDebuff(unit);
	elseif (event == "INSTANCE_ENCOUNTER_ENGAGE_UNIT") then		
		ADotF_UpdateAllFrames();
	elseif (event == "ACTIONBAR_UPDATE_COOLDOWN") then
	elseif (event == "PLAYER_ENTERING_WORLD") then
		ADotF_InitList();
		ADotF_UpdateAllFrames();
	elseif (event == "ACTIVE_TALENT_GROUP_CHANGED") then
		ADotF_InitList();		
	end
end

local function ADotF_OnUpdate()
	ADotF_UpdateAllFrames();
end

local function ADotF_Init()
	ADotF = CreateFrame("Frame", "ADotF", UIParent)

	ADotF:SetPoint("CENTER", 0, 0)
	ADotF:SetWidth(1)
	ADotF:SetHeight(1)
	ADotF:SetScale(1)
	ADotF:Show()
	ADotF:RegisterEvent("PLAYER_FOCUS_CHANGED")
	ADotF:RegisterEvent("PLAYER_TARGET_CHANGED")
	ADotF:RegisterEvent("INSTANCE_ENCOUNTER_ENGAGE_UNIT")
	ADotF:RegisterEvent("PLAYER_ENTERING_WORLD")
	ADotF:RegisterEvent("ACTIVE_TALENT_GROUP_CHANGED")
	ADotF:RegisterEvent("ACTIONBAR_UPDATE_COOLDOWN")
	ADotF:SetScript("OnEvent", ADotF_OnEvent)
	C_Timer.NewTicker(0.2, ADotF_OnUpdate);	
end

ADotF_Init();