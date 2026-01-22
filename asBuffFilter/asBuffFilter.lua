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

local function set_buff(frame, unit, aura)
	frame.icon:SetTexture(aura.icon);
	frame.count:SetText(C_UnitAuras.GetAuraApplicationDisplayCount(unit, aura.auraInstanceID, 1, 100));
	set_cooldownframe(frame.cooldown, aura.expirationTime, aura.duration, true);

	if C_CurveUtil and C_CurveUtil.EvaluateColorValueFromBoolean then
		local alpha = C_CurveUtil.EvaluateColorValueFromBoolean(aura.isStealable, 1, 0);
		frame.stealable:SetAlpha(alpha)
	end
end

local function update_auraframes(unit, auraList, filter)
	local i = 0;
	local parent = main_frame.targetframe;

	local max = #(parent.frames)

	for _, aura in ipairs(auraList) do
		i = i + 1;
		if i > max then
			break;
		end

		local frame = parent.frames[i];

		set_buff(frame, unit, aura);

		frame.auraid = aura.auraInstanceID;
		frame.unit = unit
		frame.filter = filter;
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
	local maxscancount = ns.configs.combat_max_buffs;
	local filter = filters.default;

	if not UnitAffectingCombat("player") then
		maxscancount = ns.configs.nocombat_max_buffs;
		filter = filters.helpful;
	end

	if UnitCanAttack("player", unit) then
		filter = filters.helpful;
	end

	local activeBuff = C_UnitAuras.GetUnitAuras(unit, filter, maxscancount);
	update_auraframes(unit, activeBuff, filter);
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
	local size = ns.configs.size;

	if not UnitAffectingCombat("player") then
		size = ns.configs.nocombat_size;
	end

	for i = 1, max do
		local frame = parent.frames[i];

		if (frame) then
			-- Resize
			frame:SetWidth(size);
			frame:SetHeight(size * ns.configs.sizerate);
		end
	end
end

local function set_combatalpha()
	if ns.options.CombatAlphaChange then
		if UnitAffectingCombat("player") then
			main_frame:SetAlpha(ns.configs.combat_alpha);
		else
			main_frame:SetAlpha(ns.configs.normal_alpha);
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
		set_combatalpha();
	elseif event == "PLAYER_REGEN_DISABLED" then
		set_combatalpha();
		resize_frames();
		update_auras("target");
	elseif event == "PLAYER_REGEN_ENABLED" then
		set_combatalpha();
		resize_frames();
		update_auras("target");
	end
end

local function update_anchor(frames, index, offsetX, right, parent)
	local buff = frames[index];
	buff:ClearAllPoints();

	local point1 = "LEFT";
	local point2 = "LEFT";
	local point3 = "RIGHT";

	if (right == false) then
		point1 = "RIGHT";
		point2 = "RIGHT";
		point3 = "LEFT";
		offsetX = -offsetX;
	end

	if (index == 1) then
		buff:SetPoint(point1, parent, point2, 0, 0);
	else
		buff:SetPoint(point1, frames[index - 1], point3, offsetX, 0);
	end
end

local function create_frames(parent, bright, max)
	if parent.frames == nil then
		parent.frames = {};
	end

	for idx = 1, max do
		parent.frames[idx] = CreateFrame("Button", nil, parent, "asTargetBuffFrameTemplate");
		local frame = parent.frames[idx];
		frame.cooldown:SetDrawSwipe(true);

		for _, r in next, { frame.cooldown:GetRegions() } do
			if r:GetObjectType() == "FontString" then
				r:SetFont(STANDARD_TEXT_FONT, ns.configs.cool_fontsize, "OUTLINE");
				r:ClearAllPoints();
				r:SetPoint("TOP", 0, 5);
				r:SetDrawLayer("OVERLAY");
				break;
			end
		end

		frame.count:SetFont(STANDARD_TEXT_FONT, ns.configs.count_fontsize, "OUTLINE")
		frame.count:ClearAllPoints()
		frame.count:SetPoint("CENTER", frame, "BOTTOM", 0, 1);
		frame.count:SetTextColor(0, 1, 0);

		frame.icon:SetTexCoord(.08, .92, .16, .84);

		frame.border:SetTexCoord(0.08, 0.08, 0.08, 0.92, 0.92, 0.08, 0.92, 0.92);
		frame.border:SetVertexColor(0, 0, 0);
		frame.stealable:SetTexCoord(0.08, 0.08, 0.08, 0.92, 0.92, 0.08, 0.92, 0.92);
		frame.stealable:SetVertexColor(1, 1, 1);
		frame.stealable:SetAlpha(0);
		frame.stealable:Show();

		update_anchor(parent.frames, idx, 1, bright, parent);

		frame:SetWidth(ns.configs.size);
		frame:SetHeight(ns.configs.size * ns.configs.sizerate);

		if not frame:GetScript("OnEnter") then
			frame:SetScript("OnEnter", function(self)
				if self.auraid then
					GameTooltip_SetDefaultAnchor(GameTooltip, self);
					GameTooltip:SetUnitBuffByAuraInstanceID(self.unit, self.auraid, self.filter);		
				end
			end)
			frame:SetScript("OnLeave", function()
				GameTooltip:Hide();
			end)
		end

		frame:EnableMouse(false);
		frame:SetMouseMotionEnabled(true);

		frame:Hide();
	end
end

local function on_update()
	if (UnitExists("target")) then
		update_auras("target");
	end
end


local function init()
	ns.setup_option();
	main_frame:SetPoint("CENTER", 0, 0)
	main_frame:SetWidth(1)
	main_frame:SetHeight(1)
	main_frame:Show()


	main_frame.targetframe = CreateFrame("Frame", nil, main_frame)

	main_frame.targetframe:SetPoint("CENTER", ns.configs.target_xpoint, ns.configs.target_ypoint)
	main_frame.targetframe:SetWidth(1)
	main_frame.targetframe:SetHeight(1)
	main_frame.targetframe:Show()

	create_frames(main_frame.targetframe, true, ns.configs.nocombat_max_buffs);

	local libasConfig = LibStub:GetLibrary("LibasConfig", true);

	if libasConfig then
		libasConfig.load_position(main_frame.targetframe, "asBuffFilter(Target)", ABF_Positions);
	end

	main_frame:RegisterEvent("PLAYER_TARGET_CHANGED")
	main_frame:RegisterEvent("PLAYER_ENTERING_WORLD");
	main_frame:RegisterEvent("PLAYER_REGEN_DISABLED");
	main_frame:RegisterEvent("PLAYER_REGEN_ENABLED");
	main_frame:SetScript("OnEvent", on_event);

	--주기적으로 Callback
	C_Timer.NewTicker(0.2, on_update);
	update_auras("target");
	set_combatalpha();
end

C_Timer.After(1, init);
