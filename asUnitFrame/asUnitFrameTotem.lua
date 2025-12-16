local _, ns = ...;

local function asCooldownFrame_Clear(self)
	self:Clear();
end

local function asCooldownFrame_Set(self, start, duration, enable, forceShowDrawEdge, modRate)
	if enable then
		self:SetDrawEdge(forceShowDrawEdge);
		self:SetCooldown(start, duration, modRate);
	else
		asCooldownFrame_Clear(self);
	end
end


local function Update(frame, startTime, duration, icon)
	local buttonIcon = frame.Icon.icon;
	local buttonBorder = frame.Icon.border;
	local buttonCooldown = frame.Icon.cooldown;

	if icon then
		buttonIcon:SetTexture(icon);
		buttonIcon:Show();
		buttonBorder:Show();
		frame:SetAlpha(1);
		asCooldownFrame_Set(buttonCooldown, startTime, duration, true);
		buttonCooldown:Show();
	else
		buttonIcon:Hide();
		buttonCooldown:Hide();
		buttonBorder:Hide();
		frame:SetAlpha(0);		
	end
end

function ns.UpdateTotems(frame)
	local haveTotem, name, startTime, duration, icon;
	local button;
	for i = 1, MAX_TOTEMS do
		haveTotem, name, startTime, duration, icon = GetTotemInfo(i);
		button = frame.totembuttons[i];
		button.totemslot = i;
		Update(button, startTime, duration, icon);
	end
end
