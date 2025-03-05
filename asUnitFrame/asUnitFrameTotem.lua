local _, ns = ...;

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


local function Update(frame, startTime, duration, icon)
	local buttonIcon = frame.Icon.icon;
	local buttonBorder = frame.Icon.border;
	local buttonCooldown = frame.Icon.cooldown;
	local data = frame.data;

	if (duration > 0) then
		if icon ~= data.icon then
			buttonIcon:SetTexture(icon);
			buttonIcon:Show();
			buttonBorder:Show();
			frame:SetAlpha(1);
			data.icon = icon;
		end

		if startTime ~= data.startTime or duration ~= data.duration then
			asCooldownFrame_Set(buttonCooldown, startTime, duration, true);
			buttonCooldown:Show();
			data.startTime = startTime;
			data.duration = duration;
		end
	else
		if data.icon ~= nil then
			buttonIcon:Hide();
			buttonCooldown:Hide();
			buttonBorder:Hide();
			frame:SetAlpha(0);
			frame.data = {};
		end
	end
end

function ns.UpdateTotems(frame)
	local haveTotem, name, startTime, duration, icon;
	local button;
	for i = 1, MAX_TOTEMS do
		haveTotem, name, startTime, duration, icon = GetTotemInfo(i);
		if (haveTotem) then
			button = frame.totembuttons[i];
			button.totemslot = i;
			Update(button, startTime, duration, icon);
		else
			button = frame.totembuttons[i];
			Update(button, nil, 0, nil);
		end
	end
end
