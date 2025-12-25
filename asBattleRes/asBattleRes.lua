local _, ns = ...;
local ASBR_SIZE = 40;
local ASBR_CoolButtons_X = 350
local ASBR_CoolButtons_Y = -400
local ASBR_Alpha = 0.9
local ASBR_CooldownFontSize = 11
local ASBR_Spell = 20484;

-- 옵션끝
local ASBR_CoolButtons;

local function clear_cooldownframe(self)
	self:Clear();
end


-- Function to load saved position
local function LoadPosition(frame, option)
	frame:ClearAllPoints()
	frame:SetPoint(option.point, UIParent, option.relativePoint, option.xOfs,
		option.yOfs)
end

-- Function to save position
local function SavePosition(frame, option)
	local point, _, relativePoint, xOfs, yOfs = frame:GetPoint()
	option.point = point
	option.relativePoint = relativePoint
	option.xOfs = xOfs
	option.yOfs = yOfs
end

local function set_cooldownframe(self, start, duration, enable, forceShowDrawEdge, modRate)
	if enable then
		self:SetDrawEdge(forceShowDrawEdge);
		self:SetCooldown(start, duration, modRate);
	else
		clear_cooldownframe(self);
	end
end

local bMouseEnabled = true;

local function ASBR_Update()
	if ns.options.LockWindow then
		if bMouseEnabled then
			ASBR_CoolButtons:EnableMouse(false);
			bMouseEnabled = false;
		end
	else
		if not bMouseEnabled then
			ASBR_CoolButtons:EnableMouse(true);
			bMouseEnabled = true;
		end
	end

	if IsInGroup() or not ns.options.LockWindow then
		ASBR_CoolButtons:Show();
	else
		ASBR_CoolButtons:Hide();
		return;
	end

	local count = C_Spell.GetSpellDisplayCount(ASBR_Spell);
	local spellChargeInfo = C_Spell.GetSpellCharges(ASBR_Spell);


	ASBR_CoolButtons.count:SetText(count);
	ASBR_CoolButtons.count:Show();
	ASBR_CoolButtons.icon:SetDesaturated(false);

	if spellChargeInfo then
		ASBR_CoolButtons.cooldown:Show();
		set_cooldownframe(ASBR_CoolButtons.cooldown, spellChargeInfo.cooldownStartTime,
			spellChargeInfo.cooldownDuration, true, true);
	else
		ASBR_CoolButtons.cooldown:Hide();
	end
end

local function ASBR_Init()
	ASBR_Position = ASBR_Position or {
		point = "CENTER",
		relativePoint = "CENTER",
		xOfs = ASBR_CoolButtons_X,
		yOfs = ASBR_CoolButtons_Y,
	}

	ns.SetupOptionPanels();
	C_AddOns.LoadAddOn("asMOD");


	ASBR_CoolButtons = CreateFrame("Button", nil, UIParent, "asBattleResFrameTemplate");
	ASBR_CoolButtons:EnableMouse(true);
	ASBR_CoolButtons:RegisterForDrag("LeftButton");
	ASBR_CoolButtons:SetMovable(true);

	ASBR_CoolButtons.cooldown:SetHideCountdownNumbers(false);
	ASBR_CoolButtons.cooldown:SetDrawSwipe(true);

	for _, r in next, { ASBR_CoolButtons.cooldown:GetRegions() } do
		if r:GetObjectType() == "FontString" then
			r:SetFont(STANDARD_TEXT_FONT, ASBR_CooldownFontSize, "OUTLINE");
			r:SetDrawLayer("OVERLAY");
			break
		end
	end

	ASBR_CoolButtons.icon:SetTexCoord(.08, .92, .08, .92);
	ASBR_CoolButtons.border:SetTexCoord(0.08, 0.08, 0.08, 0.92, 0.92, 0.08, 0.92, 0.92);
	ASBR_CoolButtons.border:SetVertexColor(0, 0, 0);

	ASBR_CoolButtons.count:SetFont(STANDARD_TEXT_FONT, ASBR_CooldownFontSize, "OUTLINE")
	ASBR_CoolButtons.count:ClearAllPoints();
	ASBR_CoolButtons.count:SetPoint("BOTTOMRIGHT", ASBR_CoolButtons, "BOTTOMRIGHT", -3, 3);

	ASBR_CoolButtons:SetPoint("CENTER", ASBR_CoolButtons_X, ASBR_CoolButtons_Y)
	ASBR_CoolButtons:SetWidth(ASBR_SIZE);
	ASBR_CoolButtons:SetHeight(ASBR_SIZE * 0.9);
	ASBR_CoolButtons:SetScale(1);


	ASBR_CoolButtons:SetScript("OnDragStart", function(self)
		if not ns.options.LockWindow then
			self:StartMoving()
			self.isMoving = true
		end
	end)

	ASBR_CoolButtons:SetScript("OnDragStop", function(self)
		if self.isMoving then
			self:StopMovingOrSizing()
			self.isMoving = false
			SavePosition(ASBR_CoolButtons, ASBR_Position);
		end
	end)

	LoadPosition(ASBR_CoolButtons, ASBR_Position);

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

C_Timer.After(0.5, ASBR_Init);
