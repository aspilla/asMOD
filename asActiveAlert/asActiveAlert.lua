local ASAA_SIZE = 26;

local ASAA_CoolButtons_X = -100 -- 쿨 List 위치
local ASAA_CoolButtons_Y = 0
local ASAA_Alpha = 0.9
local ASAA_CooldownFontSize = 10

-- 옵션끝

local ASAA_CoolButtons;
local ASAA_SpellList = {};

-- 원치 않는 발동 알림은 안보이게
local ASAA_BackList = {
	[115356] = true, --고술 바람의 일격
};

local asGetSpellInfo = function(spellID)
	if not spellID then
		return nil;
	end

	if not skipCheck then
		local ospellID = C_Spell.GetOverrideSpell(spellID)

		if ospellID then
			spellID = ospellID;
		end
	end


	local spellInfo = C_Spell.GetSpellInfo(spellID);
	if spellInfo then
		return spellInfo.name, nil, spellInfo.iconID, spellInfo.castTime, spellInfo.minRange, spellInfo.maxRange,
			spellInfo.spellID, spellInfo.originalIconID;
	end
end

local asGetSpellCooldown = function(spellID)
	if not spellID then
		return nil;
	end

	local ospellID = C_Spell.GetOverrideSpell(spellID)

	if ospellID then
		spellID = ospellID;
	end

	local spellCooldownInfo = C_Spell.GetSpellCooldown(spellID);
	if spellCooldownInfo then
		return spellCooldownInfo.startTime, spellCooldownInfo.duration, spellCooldownInfo.isEnabled,
			spellCooldownInfo.modRate;
	end
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

local function ASAA_UpdateCoolAnchor(frames, index, anchorIndex, size, offsetX, right, parent)
	local cool = frames[index];
	local point1 = "TOPLEFT";
	local point2 = "BOTTOMLEFT";
	local point3 = "TOPRIGHT";

	if (right == false) then
		point1 = "TOPRIGHT";
		point2 = "BOTTOMRIGHT";
		point3 = "TOPLEFT";
		offsetX = -offsetX;
	end

	if (index == 1) then
		cool:SetPoint(point1, parent, point2, 0, 0);
	else
		cool:SetPoint(point1, frames[index - 1], point3, offsetX, 0);
	end

	-- Resize
	cool:SetWidth(size);
	cool:SetHeight(size * 0.9);
end

local function ASAA_UpdateCooldown()
	local numCools = 1;
	local frame;
	local frameIcon, frameCooldown;
	local name, icon, duration, start, enable;
	local frameBorder;
	local parent;

	parent = ASAA_CoolButtons;

	if parent.frames == nil then
		parent.frames = {};
	end

	for org, id in pairs(ASAA_SpellList) do	
		name, _, icon = asGetSpellInfo(id);
		start, duration, enable = asGetSpellCooldown(id);
		local isUsable, notEnoughMana = C_Spell.IsSpellUsable(id);

		--if (icon and enable > 0) then
		if (icon) then
			frame = parent.frames[numCools];

			if (not frame) then
				parent.frames[numCools] = CreateFrame("Button", nil, parent, "asActiveAlert2FrameTemplate");
				frame = parent.frames[numCools];
				frame:EnableMouse(false);

				for _, r in next, { frame.cooldown:GetRegions() } do
					if r:GetObjectType() == "FontString" then
						r:SetFont(STANDARD_TEXT_FONT, ASAA_CooldownFontSize, "OUTLINE");
						r:SetDrawLayer("OVERLAY");
						break
					end
				end

				frame.icon:SetTexCoord(.08, .92, .08, .92)				
				frame.border:SetTexCoord(0.08, 0.08, 0.08, 0.92, 0.92, 0.08, 0.92, 0.92)
				frame.border:SetVertexColor(0, 0, 0);
			end

			-- set the icon
			frameIcon = frame.icon;			
			frameIcon:SetTexture(icon);
			frameIcon:SetAlpha(ASAA_Alpha);
			frame:ClearAllPoints();
			frame:Show();			

			if (isUsable) then
				frameIcon:SetVertexColor(1.0, 1.0, 1.0);
			elseif (notEnoughMana) then
				frameIcon:SetVertexColor(0.5, 0.5, 1.0);
			else
				frameIcon:SetVertexColor(0.4, 0.4, 0.4);
			end

			frameCooldown = frame.cooldown;
			frameCooldown:Show();
			asCooldownFrame_Set(frameCooldown, start, duration, duration > 0, enable);
			frameCooldown:SetHideCountdownNumbers(false);

			numCools = numCools + 1;
		end
	end

	for i = 1, numCools - 1 do
		-- anchor the current aura
		ASAA_UpdateCoolAnchor(parent.frames, i, i - 1, ASAA_SIZE, 2, false, parent);
	end

	-- 이후 전에 보였던 frame을 지운다.
	for i = numCools, #parent.frames do
		frame = parent.frames[i];

		if (frame) then
			frame:Hide();
		end
	end

	--prev_cnt = numCools;
end

local function ASAA_Insert(id)
	if not id then
		return;
	end

	if ASAA_BackList and ASAA_BackList[id] then
		return;
	end

	if not IsPlayerSpell(id) then
		return;
	end

	local name, _, icon, _, _, _, _, orgicon = asGetSpellInfo(id);

	if ACI_SpellID_list then
		for spellorg, _ in pairs(ACI_SpellID_list) do
			local checkname, _, checkIcon, _, _, _, _, checkorg = asGetSpellInfo(spellorg);
			if orgicon == checkorg or spellorg == id or name == checkname or icon == checkicon then
				return;
			end
		end
	end

	if APB_SPELL then
		local checkname, _, checkIcon, _, _, _, _, checkorg = asGetSpellInfo(APB_SPELL);
		if orgicon == checkorg or APB_SPELL == id or name == checkname or icon == checkicon then
			return;
		end
	end

	if APB_SPELL2 then
		local checkname, _, checkIcon, _, _, _, _, checkorg = asGetSpellInfo(APB_SPELL2);
		if orgicon == checkorg or APB_SPELL2 == id or name == checkname or icon == checkicon then
			return;
		end
	end

	if ASAA_SpellList[orgicon] then
		return;
	end

	ASAA_SpellList[orgicon] = id;

	ASAA_UpdateCooldown();
end

local function ASAA_Delete(id)
	if id then
		local name, _, icon, _, _, _, _, orgicon = asGetSpellInfo(id);
		for spellorg, spellid in pairs(ASAA_SpellList) do
			if spellid == id or spellorg == orgicon then
				ASAA_SpellList[spellorg] = nil;
			end
		end
	else
		ASAA_SpellList = {};
	end
	ASAA_UpdateCooldown();
end

local function ASAA_OnEvent(self, event, arg1, arg2, arg3)
	if event == "SPELL_ACTIVATION_OVERLAY_GLOW_SHOW" then
		ASAA_Insert(arg1)
	elseif event == "SPELL_ACTIVATION_OVERLAY_GLOW_HIDE" then
		ASAA_Delete(arg1)
	elseif event == "SPELL_UPDATE_COOLDOWN" then
		ASAA_UpdateCooldown();
	elseif event == "UNIT_SPELLCAST_SUCCEEDED" and (arg1 == "player" or arg1 == "pet") then
		ASAA_UpdateCooldown();
	elseif event == "ACTIVE_TALENT_GROUP_CHANGED" or event == "PLAYER_ENTERING_WORLD" then
		ASAA_Delete()
	end
end

local ASAA_mainframe = CreateFrame("Frame")

ASAA_mainframe:RegisterEvent("SPELL_ACTIVATION_OVERLAY_GLOW_SHOW")
ASAA_mainframe:RegisterEvent("SPELL_ACTIVATION_OVERLAY_GLOW_HIDE")
ASAA_mainframe:RegisterEvent("SPELL_UPDATE_COOLDOWN")
ASAA_mainframe:RegisterEvent("UNIT_SPELLCAST_SUCCEEDED")
ASAA_mainframe:RegisterEvent("ACTIVE_TALENT_GROUP_CHANGED");
ASAA_mainframe:RegisterEvent("PLAYER_ENTERING_WORLD");



function ASAA_mainframe:ASAA_Init()
	C_AddOns.LoadAddOn("asMOD");
	ASAA_CoolButtons = CreateFrame("Frame", nil, UIParent)
	ASAA_CoolButtons:SetPoint("CENTER", ASAA_CoolButtons_X, ASAA_CoolButtons_Y)
	ASAA_CoolButtons:SetWidth(1)
	ASAA_CoolButtons:SetHeight(1)
	ASAA_CoolButtons:SetScale(1)

	if asMOD_setupFrame then
		asMOD_setupFrame(ASAA_CoolButtons, "asActiveAlert");
	end

	ASAA_CoolButtons:Show()
end

ASAA_mainframe:ASAA_Init()
ASAA_mainframe:SetScript("OnEvent", ASAA_OnEvent)
