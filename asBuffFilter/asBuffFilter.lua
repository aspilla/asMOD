local _, ns = ...;
local main_frame = CreateFrame("Frame", nil, UIParent);

local function clear_cooldownframe(self)
	self:Clear();
end

local function set_cooldownframe(self, extime, duration, enable)
	if enable then
		self:SetDrawEdge(nil);
		self:SetCooldownFromExpirationTime(extime, duration, nil);
	else
		clear_cooldownframe(self);
	end
end

local function set_buff(frame, unit, aura, color)
	frame.icon:SetTexture(aura.icon);
	frame.count:SetText(C_UnitAuras.GetAuraApplicationDisplayCount(unit, aura.auraInstanceID, 1, 100));
	set_cooldownframe(frame.cooldown, aura.expirationTime, aura.duration, true);
	frame.border:SetVertexColor(color.r, color.g, color.b);
end

local function update_auraframes(unit, auraList)
	local i = 0;
	local parent = main_frame.targetframe;

	local max = #(parent.frames)

	for _, aura in ipairs(auraList) do
		i = i + 1;
		if i > max then
			break;
		end

		local frame = parent.frames[i];

		frame.unit = unit;
		frame.auraInstanceID = aura.auraInstanceID;
		local color = { r = 0, g = 0, b = 0 };

		set_buff(frame, unit, aura, color);
		frame:Show();
	end

	for j = i + 1, max do
		local frame = parent.frames[j];

		if (frame) then
			frame:Hide();
		end
	end
end

local filters = {
	default = AuraUtil.CreateFilterString(AuraUtil.AuraFilters.Helpful, AuraUtil.AuraFilters.Player),
	helpful = AuraUtil.CreateFilterString(AuraUtil.AuraFilters.Helpful),
}

local function update_auras(unit)
	local maxscancount = ns.configs.MAX_BUFF_SHOW;
	local filter = filters.default;

	if not UnitAffectingCombat("player") then
		maxscancount = ns.configs.TARGET_MAX_BUFF_SHOW;
		filter = filters.helpful;
	end

	if UnitCanAttack("player", unit) then
		filter = filters.helpful;
	end

	local activeBuff = C_UnitAuras.GetUnitAuras(unit, filter, maxscancount);
	update_auraframes(unit, activeBuff);
end

local function clear_frames()
	local parent = main_frame.targetframe;
	local max = #(parent.frames);

	for i = 1, max do
		local frame = parent.frames[i];

		if (frame) then
			frame:Hide();
		else
			break;
		end
	end
end

local function resize_frames()
	local parent = main_frame.targetframe;
	local max = #(parent.frames);
	local size = ns.configs.SIZE;

	if not UnitAffectingCombat("player") then
		size = ns.configs.SIZE_NOCOMBAT;
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


local function on_event(self, event, arg1, ...)
	if (event == "PLAYER_TARGET_CHANGED") then
		clear_frames();
		resize_frames();
		update_auras("target");
	elseif event == "PLAYER_ENTERING_WORLD" then
		resize_frames();
		update_auras("target");
		if UnitAffectingCombat("player") then
			main_frame:SetAlpha(ns.configs.AlphaCombat);
		else
			main_frame:SetAlpha(ns.configs.AlphaNormal);
		end
	elseif event == "PLAYER_REGEN_DISABLED" then
		main_frame:SetAlpha(ns.configs.AlphaCombat);
		resize_frames();
		update_auras("target");
	elseif event == "PLAYER_REGEN_ENABLED" then
		main_frame:SetAlpha(ns.configs.AlphaNormal);
		resize_frames();
		update_auras("target");
	end
end

local function update_anchor(frames, index, offsetX, right, center, parent)
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

	buff:SetWidth(ns.configs.SIZE);
	buff:SetHeight(ns.configs.SIZE * 0.8);
end

local function create_frames(parent, bright, bcenter, max)
	if parent.frames == nil then
		parent.frames = {};
	end

	for idx = 1, max do
		parent.frames[idx] = CreateFrame("Button", nil, parent, "asTargetBuffFrameTemplate");
		local frame = parent.frames[idx];
		frame.cooldown:SetDrawSwipe(true);

		for _, r in next, { frame.cooldown:GetRegions() } do
			if r:GetObjectType() == "FontString" then
				r:SetFont(STANDARD_TEXT_FONT, ns.configs.CooldownFontSize, "OUTLINE");
				r:ClearAllPoints();
				r:SetPoint("TOP", 0, 5);
				r:SetDrawLayer("OVERLAY");
				break;
			end
		end

		frame.count:SetFont(STANDARD_TEXT_FONT, ns.configs.CountFontSize, "OUTLINE")
		frame.count:ClearAllPoints()
		frame.count:SetPoint("CENTER", frame, "BOTTOM", 0, 1);
		frame.count:SetTextColor(0, 1, 0);

		frame.icon:SetTexCoord(.08, .92, .16, .84);

		frame.border:SetTexCoord(0.08, 0.08, 0.08, 0.92, 0.92, 0.08, 0.92, 0.92);

		update_anchor(parent.frames, idx, 1, bright, bcenter, parent);

		frame:EnableMouse(false);
		frame:Hide();
	end
end

local function on_update()
	if (UnitExists("target")) then
		update_auras("target");
	end
end


local function init()
	main_frame:SetPoint("CENTER", 0, 0)
	main_frame:SetWidth(1)
	main_frame:SetHeight(1)
	main_frame:SetScale(1)
	main_frame:SetAlpha(ns.configs.AlphaNormal);
	main_frame:Show()


	local bloaded = C_AddOns.LoadAddOn("asMOD")

	main_frame.targetframe = CreateFrame("Frame", nil, main_frame)

	main_frame.targetframe:SetPoint("CENTER", ns.configs.TARGET_BUFF_X, ns.configs.TARGET_BUFF_Y)
	main_frame.targetframe:SetWidth(1)
	main_frame.targetframe:SetHeight(1)
	main_frame.targetframe:SetScale(1)
	main_frame.targetframe:Show()

	create_frames(main_frame.targetframe, true, false, ns.configs.TARGET_MAX_BUFF_SHOW);

	if bloaded and asMOD_setupFrame then
		asMOD_setupFrame(main_frame.targetframe, "asBuffFilter(Target)");
	end

	main_frame:RegisterEvent("PLAYER_TARGET_CHANGED")
	main_frame:RegisterEvent("PLAYER_ENTERING_WORLD");
	main_frame:RegisterEvent("PLAYER_REGEN_DISABLED");
	main_frame:RegisterEvent("PLAYER_REGEN_ENABLED");
	main_frame:SetScript("OnEvent", on_event);

	--주기적으로 Callback
	C_Timer.NewTicker(0.2, on_update);
	update_auras("target");
end

C_Timer.After(0.5, init);
