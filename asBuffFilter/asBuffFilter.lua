local _, ns = ...;
local ABF;
local ABF_TARGET_BUFF;

--AuraUtil
local AuraFilters =
{
	Helpful = "HELPFUL",
	Harmful = "HARMFUL",
	Raid = "RAID",
	IncludeNameplateOnly = "INCLUDE_NAME_PLATE_ONLY",
	Player = "PLAYER",
	Cancelable = "CANCELABLE",
	NotCancelable = "NOT_CANCELABLE",
	Maw = "MAW",
};

local function CreateFilterString(...)
	return table.concat({ ... }, '|');
end

--local filter = CreateFilterString(AuraFilters.Helpful);

local function asCooldownFrame_Clear(self)
	self:Clear();
end

local function asCooldownFrame_Set(self, extime, duration, enable)
    if enable then
        self:SetDrawEdge(nil);
        self:SetCooldownFromExpirationTime(extime, duration, nil);
    else
        asCooldownFrame_Clear(self);
    end
end

local function SetBuff(frame, unit, aura, color)
	frame.icon:SetTexture(aura.icon);
	frame:Show();

	frame.count:Show();
	frame.count:SetText(C_UnitAuras.GetAuraApplicationDisplayCount(unit, aura.auraInstanceID, 1, 100));
	
	asCooldownFrame_Set(frame.cooldown, aura.expirationTime, aura.duration, true);

	frame.border:SetVertexColor(color.r, color.g, color.b);
end


local function HideFrame(p, idx)
	local frame = p.frames[idx];

	if (frame) then
		frame.data = {};
		frame:Hide();
	end
end

local function UpdateAuraFrames(unit, auraList)
	local i = 0;
	local parent = ABF_TARGET_BUFF;

	local max = #(parent.frames)
	local numAuras = max;

	for _index, aura in ipairs(auraList) do
		i = i + 1;
		if i > numAuras then
			break;
		end

		local frame = parent.frames[i];

		frame.unit = unit;
		frame.auraInstanceID = aura.auraInstanceID;
		local color = { r = 0, g = 0, b = 0 };

		SetBuff(frame, unit, aura, color);
	end

	for j = i + 1, max do
		HideFrame(parent, j);
	end
end

local function UpdateAuras(unit)
	local maxscancount = ns.ABF_MAX_BUFF_SHOW;
	local filter = CreateFilterString(AuraFilters.Helpful, AuraFilters.Player);

	if not UnitAffectingCombat("player") then
		maxscancount = ns.ABF_TARGET_MAX_BUFF_SHOW;
		filter = CreateFilterString(AuraFilters.Helpful);
	end	

	if UnitCanAttack("player", unit) then
		filter = CreateFilterString(AuraFilters.Helpful);
	end


	local activeBuff = C_UnitAuras.GetUnitAuras(unit, filter, maxscancount);
	UpdateAuraFrames(unit, activeBuff);
end



local function ABF_ClearFrame()
	local parent = ABF_TARGET_BUFF;
	local max = #(parent.frames);

	for i = 1, max do
		local frame = parent.frames[i];

		if (frame) then
			frame:Hide();
			frame.data = {};
		else
			break;
		end
	end
end

local function ABF_Resize()
	local parent = ABF_TARGET_BUFF;
	local max = #(parent.frames);
	local size = ns.ABF_SIZE;

	if not UnitAffectingCombat("player") then
		size = ns.ABF_SIZE_NOCOMBAT;
	end

	for i = 1, max do
		local frame = parent.frames[i];

		if (frame) then
			-- Resize
			frame:SetWidth(size);
			frame:SetHeight(size * 0.8);
		end
	end
end


local function ABF_OnEvent(self, event, arg1, ...)
	if (event == "PLAYER_TARGET_CHANGED") then
		ABF_ClearFrame();
		ABF_Resize();
		UpdateAuras("target");
	elseif event == "PLAYER_ENTERING_WORLD" then
		ABF_Resize();
		UpdateAuras("target");
	elseif event == "PLAYER_REGEN_DISABLED" then
		ABF:SetAlpha(ns.ABF_AlphaCombat);
		ABF_Resize();
		UpdateAuras("target");
	elseif event == "PLAYER_REGEN_ENABLED" then
		ABF:SetAlpha(ns.ABF_AlphaNormal);
		ABF_Resize();
		UpdateAuras("target");
	end
end

local function ABF_UpdateBuffAnchor(frames, index, offsetX, right, center, parent)
	local buff = frames[index];
	buff:ClearAllPoints();

	if center then
		if (index == 1) then
			buff:SetPoint("TOP", parent, "CENTER", 0, 0);
		elseif (index == 2) then
			buff:SetPoint("RIGHT", frames[index - 1], "LEFT", -offsetX, 0);
		elseif (math.fmod(index, 2) == 1) then
			buff:SetPoint("LEFT", frames[index - 2], "RIGHT", offsetX, 0);
		else
			buff:SetPoint("RIGHT", frames[index - 2], "LEFT", -offsetX, 0);
		end
	else
		local point1 = "TOPLEFT";
		local point2 = "CENTER";
		local point3 = "TOPRIGHT";

		if (right == false) then
			point1 = "TOPRIGHT";
			point2 = "CENTER";
			point3 = "TOPLEFT";
			offsetX = -offsetX;
		end

		if (index == 1) then
			buff:SetPoint(point1, parent, point2, 0, 0);
		else
			buff:SetPoint(point1, frames[index - 1], point3, offsetX, 0);
		end
	end
	-- Resize
	buff:SetWidth(ns.ABF_SIZE);
	buff:SetHeight(ns.ABF_SIZE * 0.8);
end

local function CreatBuffFrames(parent, bright, bcenter, max)
	if parent.frames == nil then
		parent.frames = {};
	end

	for idx = 1, max do
		parent.frames[idx] = CreateFrame("Button", nil, parent, "asTargetBuffFrameTemplate");
		local frame = parent.frames[idx];
		frame.cooldown:SetDrawSwipe(true);
		frame.cooldown:SetHideCountdownNumbers(false);

		for _, r in next, { frame.cooldown:GetRegions() } do
			if r:GetObjectType() == "FontString" then
				r:SetFont(STANDARD_TEXT_FONT, ns.ABF_CooldownFontSize, "OUTLINE");
				r:ClearAllPoints();
				r:SetPoint("TOP", 0, 5);
				r:SetDrawLayer("OVERLAY");
				break;
			end
		end

		frame.count:SetFont(STANDARD_TEXT_FONT, ns.ABF_CountFontSize, "OUTLINE")
		frame.count:ClearAllPoints()
		frame.count:SetPoint("BOTTOMRIGHT", frame.icon, "BOTTOMRIGHT", -2, 2);

		frame.point:SetFont(STANDARD_TEXT_FONT, ns.ABF_CountFontSize - 3, "OUTLINE")
		frame.point:ClearAllPoints()
		frame.point:SetPoint("BOTTOMRIGHT", frame.icon, "BOTTOMRIGHT", -2, 2);
		frame.point:SetTextColor(0, 1, 0);

		frame.bigcount:SetFont(STANDARD_TEXT_FONT, ns.ABF_CountFontSize + 3, "OUTLINE")
		frame.bigcount:ClearAllPoints()
		frame.bigcount:SetPoint("CENTER", frame.icon, "CENTER", 0, 0);

		frame.icon:SetTexCoord(.08, .92, .16, .84);
		frame.icon:SetAlpha(ns.ABF_ALPHA);
		frame.border:SetTexCoord(0.08, 0.08, 0.08, 0.92, 0.92, 0.08, 0.92, 0.92);
		frame.border:SetAlpha(ns.ABF_ALPHA);

		ABF_UpdateBuffAnchor(parent.frames, idx, 1, bright, bcenter, parent);

		frame:EnableMouse(false);
		frame:Hide();
	end

	return;
end

local function OnUpdate()
	if (UnitExists("target")) then
		UpdateAuras("target");
	end
end


local function ABF_Init()
	ABF = CreateFrame("Frame", nil, UIParent)

	ABF:SetPoint("CENTER", 0, 0)
	ABF:SetWidth(1)
	ABF:SetHeight(1)
	ABF:SetScale(1)
	ABF:SetAlpha(ns.ABF_AlphaNormal);
	ABF:Show()


	local bloaded = C_AddOns.LoadAddOn("asMOD")

	ABF_TARGET_BUFF = CreateFrame("Frame", nil, ABF)

	ABF_TARGET_BUFF:SetPoint("CENTER", ns.ABF_TARGET_BUFF_X, ns.ABF_TARGET_BUFF_Y)
	ABF_TARGET_BUFF:SetWidth(1)
	ABF_TARGET_BUFF:SetHeight(1)
	ABF_TARGET_BUFF:SetScale(1)
	ABF_TARGET_BUFF:Show()

	CreatBuffFrames(ABF_TARGET_BUFF, true, false, ns.ABF_TARGET_MAX_BUFF_SHOW);

	if bloaded and asMOD_setupFrame then
		asMOD_setupFrame(ABF_TARGET_BUFF, "asBuffFilter(Target)");
	end

	ABF:RegisterEvent("PLAYER_TARGET_CHANGED")
	ABF:RegisterEvent("PLAYER_ENTERING_WORLD");
	ABF:RegisterEvent("PLAYER_LEAVING_WORLD");
	ABF:RegisterEvent("PLAYER_REGEN_DISABLED");
	ABF:RegisterEvent("PLAYER_REGEN_ENABLED");
	ABF:RegisterEvent("CVAR_UPDATE");

	ABF:SetScript("OnEvent", ABF_OnEvent);

	--주기적으로 Callback
	C_Timer.NewTicker(0.2, OnUpdate);
	UpdateAuras("target");
end

C_Timer.After(0.5, ABF_Init);
