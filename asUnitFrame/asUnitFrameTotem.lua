local _, ns = ...;

local function clear_cooldownframe(self)
	self:Clear();
end

local function set_cooldownframe(self, durationobject, enable)
	if enable then
		self:SetDrawEdge(nil);
		self:SetCooldownFromDurationObject(durationobject);
	else
		clear_cooldownframe(self);
	end
end


local function set_totem(frame, startTime, duration, icon)
	local buttonIcon = frame.Icon.icon;
	local buttonBorder = frame.Icon.border;
	local buttonCooldown = frame.Icon.cooldown;

	if icon then
		buttonIcon:SetTexture(icon);
		buttonIcon:Show();
		buttonBorder:Show();
		frame:SetAlpha(1);
		local durationobj = GetTotemDuration(frame.totemslot);
		set_cooldownframe(buttonCooldown, durationobj, true);
		buttonCooldown:Show();
	else
		buttonIcon:Hide();
		buttonCooldown:Hide();
		buttonBorder:Hide();
		frame:SetAlpha(0);
	end
end

function ns.update_totems(frame)
	local haveTotem, name, startTime, duration, icon;
	local button;
	for i = 1, MAX_TOTEMS do
		haveTotem, name, startTime, duration, icon = GetTotemInfo(i);
		button = frame.totembuttons[i];
		button.totemslot = i;
		set_totem(button, startTime, duration, icon);
	end
end
