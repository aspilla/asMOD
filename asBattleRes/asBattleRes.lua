local ASBR_SIZE = 40;
local ASBR_CoolButtons_X = 350 
local ASBR_CoolButtons_Y = -400
local ASBR_Alpha = 0.9
local ASBR_CooldownFontSize = 11
local ASBR_Spell = 20484;

-- 옵션끝
local ASBR_CoolButtons;

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

local function ASBR_Update()
	
	if IsInGroup() then
		ASBR_CoolButtons:Show();
	else
		ASBR_CoolButtons:Hide();
		return;
	end
	
	local spellChargeInfo = C_Spell.GetSpellCharges(ASBR_Spell);
	
	if spellChargeInfo and spellChargeInfo.currentCharges and spellChargeInfo.currentCharges > 0 then
		ASBR_CoolButtons.count:SetText(spellChargeInfo.currentCharges);
		ASBR_CoolButtons.count:Show();
		ASBR_CoolButtons.icon:SetDesaturated(false);
				
	else	
		ASBR_CoolButtons.count:Hide();
		ASBR_CoolButtons.icon:SetDesaturated(true);	
	end	
		
	
	if spellChargeInfo and spellChargeInfo.cooldownStartTime then
		ASBR_CoolButtons.cooldown:Show();
		asCooldownFrame_Set(ASBR_CoolButtons.cooldown, spellChargeInfo.cooldownStartTime,  spellChargeInfo.cooldownDuration,  spellChargeInfo.cooldownDuration > 0, true);
		ASBR_CoolButtons.cooldown:SetHideCountdownNumbers(false);
		ASBR_CoolButtons.cooldown:SetDrawSwipe(false);
	else
		ASBR_CoolButtons.cooldown:Hide();
	end

end

local function ASBR_Init()
	C_AddOns.LoadAddOn("asMOD");

	ASBR_CoolButtons = CreateFrame("Button", nil, UIParent, "asBattleResFrameTemplate");
	ASBR_CoolButtons:EnableMouse(false);

	for _, r in next, { ASBR_CoolButtons.cooldown:GetRegions() } do
		if r:GetObjectType() == "FontString" then
			r:SetFont(STANDARD_TEXT_FONT, ASBR_CooldownFontSize, "OUTLINE")
			break
		end
	end

	ASBR_CoolButtons.count:SetFont(STANDARD_TEXT_FONT, ASBR_CooldownFontSize, "OUTLINE")				

	ASBR_CoolButtons.icon:SetTexCoord(.08, .92, .08, .92);
	ASBR_CoolButtons.border:SetTexture("Interface\\Addons\\asBattleRes\\border.tga");
	ASBR_CoolButtons.border:SetTexCoord(0.08, 0.08, 0.08, 0.92, 0.92, 0.08, 0.92, 0.92);
	ASBR_CoolButtons.border:SetVertexColor(0, 0, 0);

	ASBR_CoolButtons:SetPoint("CENTER", ASBR_CoolButtons_X, ASBR_CoolButtons_Y)
	ASBR_CoolButtons:SetWidth(ASBR_SIZE);
	ASBR_CoolButtons:SetHeight(ASBR_SIZE);
	ASBR_CoolButtons:SetScale(1);

	if asMOD_setupFrame then
		asMOD_setupFrame(ASBR_CoolButtons, "asBattleRes");
	end

	local spellInfo = C_Spell.GetSpellInfo(ASBR_Spell);

	if spellInfo then
		ASBR_CoolButtons.icon:SetTexture(spellInfo.iconID);
		ASBR_CoolButtons.icon:SetAlpha(ASBR_Alpha);		
		--주기적으로 Callback
		C_Timer.NewTicker(0.25, ASBR_Update);
	end	
end

ASBR_Init();
