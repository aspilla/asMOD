local ADF;
local ADF_PLAYER_DEBUFF;
local ADF_TARGET_DEBUFF;
local ADF_DeBuffList = {}

local ADF_SIZE = 32;
local ADF_TARGET_DEBUFF_X = 73 + 30;
local ADF_TARGET_DEBUFF_Y = -110;
local ADF_PLAYER_DEBUFF_X = -73 - 30;
local ADF_PLAYER_DEBUFF_Y = -110;
local ADF_MAX_DEBUFF_SHOW = 7;
local ADF_ALPHA = 1
local ADF_CooldownFontSize = 14			-- Cooldown Font Size
local ADF_CountFontSize = 13;			-- Count Font Size
local ADF_AlphaCombat = 1;				-- 전투중 Alpha 값
local ADF_AlphaNormal = 0.5;			-- 비 전투중 Alpha 값
local ADF_MAX_Cool = 120				-- 최대 120초까지의 Debuff를 보임
local ADF_Show_TargetDebuff = true		-- 대상이 시전한 Debuff를 보임 (false 이면 Player가 건 Debuff 만 보임)
local ADF_Show_PVPDebuff = true			-- 다른사람이 건 PVP Debuff를 보임 (점감 효과를 갖는 Debuff) (false 이면 Player가 건 Debuff 만 보임)

local ADF_Show_ShowBossDebuff = true	-- Boss Type Debuff를 보임 (false 이면 Player가 건 Debuff 만 보임)
local ADF_RefreshRate = 0.5;			-- Target Debuff Check 주기 (초)

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
local dispellableDebuffTypes = { Magic = true, Curse = true, Disease = true, Poison = true};


--Overlay stuff
local unusedOverlayGlows = {};
local numOverlays = 0;
local function ADF_ActionButton_GetOverlayGlow()
	local overlay = tremove(unusedOverlayGlows);
	if ( not overlay ) then
		numOverlays = numOverlays + 1;
		overlay = CreateFrame("Frame", nil, UIParent, "ADF_ActionBarButtonSpellActivationAlert");
	end
	return overlay;
end

-- Shared between action button and MainMenuBarMicroButton
local function ADF_ShowOverlayGlow(button)
	if ( button.overlay ) then
		if ( button.overlay.animOut:IsPlaying() ) then
			button.overlay.animOut:Stop();
			button.overlay.animIn:Play();
		end
	else
		button.overlay = ADF_ActionButton_GetOverlayGlow();
		local frameWidth, frameHeight = button:GetSize();
		button.overlay:SetParent(button);
		button.overlay:ClearAllPoints();
		--Make the height/width available before the next frame:
		button.overlay:SetSize(frameWidth * 1.3, frameHeight * 1.3);
		button.overlay:SetPoint("TOPLEFT", button, "TOPLEFT", -frameWidth * 0.3, frameHeight * 0.3);
		button.overlay:SetPoint("BOTTOMRIGHT", button, "BOTTOMRIGHT", frameWidth * 0.3, -frameHeight * 0.3);
		button.overlay.animIn:Play();
	end
end

-- Shared between action button and MainMenuBarMicroButton
local function ADF_HideOverlayGlow(button)
	if ( button.overlay ) then
		if ( button.overlay.animIn:IsPlaying() ) then
			button.overlay.animIn:Stop();
		end
		button.overlay.animOut:OnFinished();	--We aren't shown anyway, so we'll instantly hide it.
	end
end

ADF_ActionBarButtonSpellActivationAlertMixin = {};

function ADF_ActionBarButtonSpellActivationAlertMixin:OnUpdate(elapsed)
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

function ADF_ActionBarButtonSpellActivationAlertMixin:OnHide()
	if ( self.animOut:IsPlaying() ) then
		self.animOut:Stop();
		self.animOut:OnFinished();
	end
end

ADF_ActionBarOverlayGlowAnimInMixin = {};

function ADF_ActionBarOverlayGlowAnimInMixin:OnPlay()
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

function ADF_ActionBarOverlayGlowAnimInMixin:OnFinished()
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

ADF_ActionBarOverlayGlowAnimOutMixin = {};

function ADF_ActionBarOverlayGlowAnimOutMixin:OnFinished()
	local overlay = self:GetParent();
	local actionButton = overlay:GetParent();
	overlay:Hide();
	tinsert(unusedOverlayGlows, overlay);
	actionButton.overlay = nil;
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

local function ADF_UpdateDebuff(unit)

	local numDebuffs = 1;
	local frame;
	local frameIcon, frameCount, frameCooldown;
	local name, icon, count, debuffType, duration, expirationTime, caster, isStealable, shouldConsolidate, spellId, canApplyAura,isBossDebuff, casterIsPlayer, nameplateShowAll ;
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
			name,  _, _, debuffType, _, _, _, _, _, spellId = UnitDebuff(unit, i, filter);
			if ( dispellableDebuffTypes[debuffType]) then
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

			local filter = "";

			name, icon, count, debuffType, duration, expirationTime, caster, isStealable, shouldConsolidate, spellId, canApplyAura,isBossDebuff, casterIsPlayer, nameplateShowAll  = UnitDebuff("target", i, filter);

			if (icon == nil) then
				break;
			end

			skip = true;

			if (casterIsPlayer) then
		        skip = true;
		    end
			-- 내가 시전한 Debuff는 보이고
			if caster and PLAYER_UNITS[caster]  then
				skip = false;
			end

			if caster and ADF_Show_TargetDebuff and not UnitIsPlayer("target") and UnitIsUnit("target", caster) then
				skip = false;
			end

			if (spellId and ADF_Show_PVPDebuff and nameplateShowAll) then
				skip = false;
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

		elseif (unit == "targethelp") then

			name,  icon, count, debuffType, duration, expirationTime, caster, isStealable, shouldConsolidate, spellId, canApplyAura,isBossDebuff,casterIsPlayer, nameplateShowAll  = UnitDebuff("target", i, filter);

			if (icon == nil) then
				break;
			end

			skip = false;

			if (casterIsPlayer) then
		        skip = true;
		    end

			-- 내가 시전한 Debuff는 보이고
			if PLAYER_UNITS[caster]  then
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
			name, icon, count, debuffType, duration, expirationTime, caster, isStealable, shouldConsolidate, spellId, canApplyAura, isBossDebuff, _, nameplateShowAll = UnitDebuff("player", i, "");


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

			if (unit ~= "player" and caster ~= nil  and not PLAYER_UNITS[caster]) then
				color = { r = 0.3, g = 0.3, b = 0.3 };
			end

			if candispel then
				color = { r = 1, g = 1, b = 1 };
			end

			frameBorder = frame.border;
			frameBorder:SetVertexColor(color.r, color.g, color.b);
			frameBorder:SetAlpha(ADF_ALPHA);
			frame:Show();

			
			if (alert) then
				--print ("alert" );
				if frame.balert == false then
					ADF_ShowOverlayGlow(frame);
					frame.balert = true;
				end
			else
				if frame.balert == true then
					frame.balert = false;
					ADF_HideOverlayGlow(frame);
				end
			end
		
			numDebuffs = numDebuffs + 1;
		end
		i = i+1
	until (name == nil)

	for i = numDebuffs, ADF_MAX_DEBUFF_SHOW do
		frame = parent.frames[i];

		if ( frame ) then
			if frame.balert == true then
				frame.balert = false;
				ADF_HideOverlayGlow(frame);
			end
			frame:Hide();
		end
	end
end

function ADF_ClearFrame()

	for i = 1, ADF_MAX_DEBUFF_SHOW do
		local frame = ADF_TARGET_DEBUFF.frames[i];

		if ( frame ) then
			if frame.balert == true then
				frame.balert = false;
				ADF_HideOverlayGlow(frame);
			end
			frame:Hide();
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

	if ( index == 1 ) then
		buff:SetPoint(point1, parent, point2, 0, 0);
	else
		buff:SetPoint(point1, frames[index-1], point3, offsetX, 0);
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
		for _,r in next,{frame.cooldown:GetRegions()} do
			if r:GetObjectType()=="FontString" then
				r:SetFont(STANDARD_TEXT_FONT, ADF_CooldownFontSize,"OUTLINE");
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
		frame.border:SetTexCoord(0.08,0.08, 0.08,0.92, 0.92,0.08, 0.92,0.92);

		frame:ClearAllPoints();
		ADF_UpdateDebuffAnchor(parent.frames, idx, 1,  bright, parent);
		frame.balert = false;
		frame:Hide();
	end

	return;
end

local function ADF_Init()

	local bloaded =  LoadAddOn("asMOD")

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
		asMOD_setupFrame (ADF_TARGET_DEBUFF, "asDebuffFilter(Target)");
  	end

	ADF_PLAYER_DEBUFF = CreateFrame("Frame", nil, ADF)

	ADF_PLAYER_DEBUFF:SetPoint("CENTER", ADF_PLAYER_DEBUFF_X, ADF_PLAYER_DEBUFF_Y)
	ADF_PLAYER_DEBUFF:SetWidth(1)
	ADF_PLAYER_DEBUFF:SetHeight(1)
	ADF_PLAYER_DEBUFF:SetScale(1)
	ADF_PLAYER_DEBUFF:Show()

	CreatDebuffFrames(ADF_PLAYER_DEBUFF, false);

	if bloaded and asMOD_setupFrame then
		asMOD_setupFrame (ADF_PLAYER_DEBUFF, "asDebuffFilter(Player)");
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
