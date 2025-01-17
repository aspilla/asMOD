local _, ns = ...;

local sizeScale = 0.8;
local longSide = 256 * sizeScale;
local shortSide = 128 * sizeScale;

local settingalpha = 1;

local function asOverlay_OnLoad(self)
	self.overlaysInUse = {};
	self.unusedOverlays = {};

	self:RegisterEvent("SPELL_ACTIVATION_OVERLAY_SHOW");
	self:RegisterEvent("SPELL_ACTIVATION_OVERLAY_HIDE");	
	self:RegisterUnitEvent("UNIT_AURA", "player");

	self:RegisterEvent("SETTINGS_LOADED");

	SpellActivationOverlayFrame:UnregisterEvent("SPELL_ACTIVATION_OVERLAY_SHOW");
	SpellActivationOverlayFrame:UnregisterEvent("SPELL_ACTIVATION_OVERLAY_HIDE");

	self:SetSize(longSide, longSide);
end


local function asOverlay_CreateOverlay(self)
	local ret = CreateFrame("Frame", nil, self, "asOverlayTemplate");
	return ret;
end

local function asOverlay_GetUnusedOverlay(self)
	local overlay = tremove(self.unusedOverlays, #self.unusedOverlays);
	if (not overlay) then
		overlay = asOverlay_CreateOverlay(self);
	end
	return overlay;
end


local function asOverlay_GetOverlay(self, spellID, position, getonly)
	local overlayList = self.overlaysInUse[spellID];
	local overlay;
	if (overlayList) then
		for i = 1, #overlayList do
			if (overlayList[i].position == position) then
				overlay = overlayList[i];
			end
		end
	end

	if (not overlay and not getonly) then
		overlay = asOverlay_GetUnusedOverlay(self);
		if (overlayList) then
			tinsert(overlayList, overlay);
		else
			self.overlaysInUse[spellID] = { overlay };
		end
	end

	return overlay;
end

local function asOverlay_HideOverlays(self, spellID)
	local overlayList = self.overlaysInUse[spellID];
	if (overlayList) then
		for i = 1, #overlayList do
			local overlay = overlayList[i];			
			overlay.animOut:Play();
		end
	end
end

local function asOverlay_HideAllOverlays(self)
	for spellID, overlayList in pairs(self.overlaysInUse) do
		asOverlay_HideOverlays(self, spellID);
	end
end

function asOverlayTexture_OnFadeOutFinished(anim)
	local overlay = anim:GetRegionParent();
	local overlayParent = overlay:GetParent();	
	overlay:Hide();	
	tDeleteItem(overlayParent.overlaysInUse[overlay.spellID], overlay)
	tinsert(overlayParent.unusedOverlays, overlay);
end

local complexLocationTypes = {
	[Enum.ScreenLocationType.LeftRight] = {
		Enum.ScreenLocationType.Left,
		Enum.ScreenLocationType.Right,
	},
	[Enum.ScreenLocationType.TopBottom] = {
		Enum.ScreenLocationType.Top,
		Enum.ScreenLocationType.Bottom,
	},
	[Enum.ScreenLocationType.LeftRightOutside] = {
		Enum.ScreenLocationType.LeftOutside,
		Enum.ScreenLocationType.RightOutside,
	},
}

local hFlippedPositions = {
	[Enum.ScreenLocationType.Right] = true,
	[Enum.ScreenLocationType.RightOutside] = true,
};

local vFlippedPositions = {
	[Enum.ScreenLocationType.Bottom] = true,
};

local checkAuraList = {};
local countAuraList = {};

local function asOverlay_ShowOverlay(self, spellID, texturePath, position, scale, r, g, b)
	local rate = 1;
	local aura;

	local overlay = asOverlay_GetOverlay(self, spellID, position);
	overlay.spellID = spellID;
	overlay.position = position;

	overlay.animOut:Stop();	--In case we're in the process of animating this out.

	if ns.positionaware[spellID] then
		local v = ns.positionaware[spellID];

		if v[1] and position == v[1] then
			position = v[2];
		end
	end

	if ns.countaware[spellID] then
		countAuraList[spellID] = true;
		local currtime = GetTime();
		for _, auraid in pairs(ns.countaware[spellID]) do
			aura = ns.GetAura(auraid);

			local remain = 0;

			if aura then
				local extime = aura.expirationTime;
				local duration = aura.duration;
				remain = extime - currtime;

				if remain > 0 then
					rate = math.ceil(remain / duration * 100) / 100;
				end
				break;
			end
		end
	else
		local auraid = spellID;
		local currtime = GetTime();
		aura = ns.GetAura(auraid, true);
		local remain = 0;

		if aura then
			local extime = aura.expirationTime;
			local duration = aura.duration;
			remain = extime - currtime;

			if remain > 0 then
				rate = math.ceil(remain / duration * 100) / 100;
			end
		end
	end


	if ns.spelllists[spellID] then
		if checkAuraList[spellID] == nil then
			checkAuraList[spellID] = {};
		end

		local updated = {};

		checkAuraList[spellID][position] = true;

		for _, v in pairs(ns.spelllists[spellID]) do
			local procid = v[1];
			local proc_count = v[2];
			local proc_r = v[3];
			local proc_g = v[4];
			local proc_b = v[5];
			local proc_position = v[6];

			local procaura = ns.GetAura(procid);

			if procaura then
				if (proc_count > 0 and procaura.applications >= proc_count) or proc_count == 0 then
					if position == proc_position and not updated[position] then
						r = proc_r * 255;
						g = proc_g * 255;
						b = proc_b * 255;
						updated[position] = true;
					end
				end
			end
		end
	end

	overlay:ClearAllPoints();
	overlay.back:ClearAllPoints();
	overlay.cooldown:ClearAllPoints();

	local texLeft, texRight, texTop, texBottom = 0, 1, 0, 1;
	overlay.vflip = false;
	overlay.hflip = false;

	if vFlippedPositions[position] then
		texTop, texBottom = 1, 0;
		overlay.vflip = true;
	end
	if hFlippedPositions[position] then
		texLeft, texRight = 1, 0;
		overlay.hflip = true;
	end

	local width, height;

	if position == Enum.ScreenLocationType.Center then
		width, height = longSide, longSide;
		overlay:SetPoint("CENTER", self, "CENTER", 0, 0);
		overlay.back:SetPoint("CENTER", self, "CENTER", 0, 0);
		overlay.cooldown:SetPoint("CENTER", self, "CENTER", 0, 0);
	elseif position == Enum.ScreenLocationType.Left then
		width, height = shortSide, longSide;
		overlay:SetPoint("BOTTOMRIGHT", self, "BOTTOMLEFT", 0, (height * (1 - scale)) / 2);
		overlay.back:SetPoint("BOTTOMRIGHT", self, "BOTTOMLEFT", 0, (height * (1 - scale)) / 2);
		overlay.cooldown:SetPoint("BOTTOMRIGHT", self, "BOTTOMLEFT", 0, (height * (1 - scale)) / 2);
	elseif position == Enum.ScreenLocationType.LeftOutside then
		width, height = shortSide, longSide;
		overlay:SetPoint("BOTTOMRIGHT", self, "BOTTOMLEFT", -shortSide, (height * (1 - scale)) / 2);
		overlay.back:SetPoint("BOTTOMRIGHT", self, "BOTTOMLEFT", -shortSide, (height * (1 - scale)) / 2);
		overlay.cooldown:SetPoint("BOTTOMRIGHT", self, "BOTTOMLEFT", -shortSide, (height * (1 - scale)) / 2);
	elseif position == Enum.ScreenLocationType.Right then
		width, height = shortSide, longSide;
		overlay:SetPoint("BOTTOMLEFT", self, "BOTTOMRIGHT", 0, (height * (1 - scale)) / 2);
		overlay.back:SetPoint("BOTTOMLEFT", self, "BOTTOMRIGHT", 0, (height * (1 - scale)) / 2);
		overlay.cooldown:SetPoint("BOTTOMLEFT", self, "BOTTOMRIGHT", 0, (height * (1 - scale)) / 2);
	elseif position == Enum.ScreenLocationType.RightOutside then
		width, height = shortSide, longSide;
		overlay:SetPoint("BOTTOMLEFT", self, "BOTTOMRIGHT", shortSide, (height * (1 - scale)) / 2);
		overlay.back:SetPoint("BOTTOMLEFT", self, "BOTTOMRIGHT", shortSide, (height * (1 - scale)) / 2);
		overlay.cooldown:SetPoint("BOTTOMLEFT", self, "BOTTOMRIGHT", shortSide, (height * (1 - scale)) / 2);
	elseif position == Enum.ScreenLocationType.Top then
		width, height = longSide, shortSide;
		overlay:SetPoint("BOTTOMLEFT", self, "TOPLEFT", (width * (1 - scale)) / 2, 0);
		overlay.back:SetPoint("BOTTOMLEFT", self, "TOPLEFT", (width * (1 - scale)) / 2, 0);
		overlay.cooldown:SetPoint("BOTTOMLEFT", self, "TOPLEFT", (width * (1 - scale)) / 2, 0);
	elseif position == Enum.ScreenLocationType.Bottom then
		width, height = longSide, shortSide;
		overlay:SetPoint("TOPLEFT", self, "BOTTOMLEFT", (width * (1 - scale)) / 2, 0);
		overlay.back:SetPoint("TOPLEFT", self, "BOTTOMLEFT", (width * (1 - scale)) / 2, 0);
		overlay.cooldown:SetPoint("TOPLEFT", self, "BOTTOMLEFT", (width * (1 - scale)) / 2, 0);
	elseif position == Enum.ScreenLocationType.TopRight then
		width, height = shortSide, shortSide;
		overlay:SetPoint("BOTTOMLEFT", self, "TOPRIGHT", 0, 0);
		overlay.back:SetPoint("BOTTOMLEFT", self, "TOPRIGHT", 0, 0);
		overlay.cooldown:SetPoint("BOTTOMLEFT", self, "TOPRIGHT", 0, 0);
	elseif position == Enum.ScreenLocationType.TopLeft then
		width, height = shortSide, shortSide;
		overlay:SetPoint("BOTTOMRIGHT", self, "TOPLEFT", 0, 0);
		overlay.back:SetPoint("BOTTOMRIGHT", self, "TOPLEFT", 0, 0);
		overlay.cooldown:SetPoint("BOTTOMRIGHT", self, "TOPLEFT", 0, 0);
	else
		--GMError("Unknown asOverlay position: "..tostring(position));
		return;
	end

	if position == Enum.ScreenLocationType.Left or position == Enum.ScreenLocationType.Right or position == Enum.ScreenLocationType.LeftOutside or position == Enum.ScreenLocationType.RightOutside then
		overlay.side = true;
	else
		overlay.side = false;
	end

	overlay.width = width * scale;
	overlay.height = height * scale;
	overlay:SetSize(overlay.width, overlay.height);


	overlay.back.textureback:SetTexture(texturePath);
	overlay.back.textureback:SetDesaturation(1)
	overlay.back.textureback:SetTexCoord(texLeft, texRight, texTop, texBottom);
	overlay.back:SetSize(overlay.width, overlay.height);
	if ns.options.BackgroundAlpha then
		overlay.back:SetAlpha(ns.options.BackgroundAlpha);
	else
		overlay.back:SetAlpha(0.4);
	end
	overlay.back:Show();
	overlay.cooldown:Show();

	overlay.cooldown.texture:SetTexture(texturePath);
	overlay.cooldown.texture:SetVertexColor(r / 255, g / 255, b / 255);
	overlay.cooldown:SetAlpha(1);
	
	if overlay.side then
		if (overlay.vflip) then
			overlay.cooldown.texture:SetTexCoord(texLeft, texRight, texTop, 1 - rate);
		else
			overlay.cooldown.texture:SetTexCoord(texLeft, texRight, 1 - rate, texBottom);
		end
		overlay.cooldown:SetSize(overlay.width, overlay.height * rate);
	else
		if (overlay.hflip) then
			overlay.cooldown.texture:SetTexCoord(rate, texRight, texTop, texBottom);
		else
			overlay.cooldown.texture:SetTexCoord(texLeft, rate, texTop, texBottom);
		end
		overlay.cooldown:SetSize(overlay.width * rate, overlay.height);
	end

	PlaySound(SOUNDKIT.UI_POWER_AURA_GENERIC);

	if aura then
		local count = aura.applications;
		if ns.countaware[spellID] then
			if count and count == 1 and position == Enum.ScreenLocationType.Right then
				overlay:Hide();
				return;
			end
		end
	end

	overlay:SetAlpha(1);
	overlay:Show();
end



local function asOverlay_CheckAura(self)
	for spellID, _ in pairs(countAuraList) do
		if ns.countaware[spellID] then
			local overlay = asOverlay_GetOverlay(self, spellID, Enum.ScreenLocationType.Right, true) or
				asOverlay_GetOverlay(self, spellID, Enum.ScreenLocationType.RightOutside, true);

			if overlay and overlay:IsShown() then
				for _, auraid in pairs(ns.countaware[spellID]) do
					local procaura = ns.GetAura(auraid);

					if procaura then
						local count = procaura.applications;

						if overlay and count then
							if count == 1 then
								overlay:Hide();
							elseif count >= 2 then
								overlay:Show();
							end
						end
					end
				end
			end
		end
	end

	local r, g, b
	for spellID, positions in pairs(checkAuraList) do
		local updated = {};
		if ns.spelllists[spellID] then
			for _, v in pairs(ns.spelllists[spellID]) do
				local procid = v[1];
				local proc_count = v[2];
				local proc_r = v[3];
				local proc_g = v[4];
				local proc_b = v[5];
				local proc_position = v[6];

				local procaura = ns.GetAura(procid);

				if procaura then
					if (proc_count > 0 and procaura.applications >= proc_count) or proc_count == 0 then
						if positions and (type(positions) == "table") then
							for position, _ in pairs(positions) do
								if position == proc_position and not updated[position] then
									r = proc_r * 255;
									g = proc_g * 255;
									b = proc_b * 255;

									local overlay = asOverlay_GetOverlay(self, spellID, position, true);

									if overlay and overlay:IsShown() then
										overlay.cooldown.texture:SetVertexColor(r / 255, g / 255, b / 255);
										updated[position] = true
									end
								end
							end
						end
					end
				end
			end
		end

		for position, _ in pairs(positions) do
			local overlay = asOverlay_GetOverlay(self, spellID, position, true);

			if overlay and overlay:IsShown() and not updated[position] then
				overlay.cooldown.texture:SetVertexColor(1, 1, 1);
			end
		end
	end
end

local function asOverlay_ShowAllOverlays(self, spellID, texturePath, locationType, scale, r, g, b)
	local locations = complexLocationTypes[locationType];
	if locations then
		for _, location in ipairs(locations) do
			asOverlay_ShowOverlay(self, spellID, texturePath, location, scale, r, g, b);
		end
	else
		asOverlay_ShowOverlay(self, spellID, texturePath, locationType, scale, r, g, b);
	end
end

local function IsShown(spellId)
	local Id = ns.aurachangelist[spellId];
	if Id then
		spellId = Id;
	end
	local name = C_Spell.GetSpellName(spellId);

	-- asPowerBar Check
	if APB_BUFF4 and APB_BUFF4 == spellId then
		return true;
	end

	if APB_BUFF_COMBO and APB_BUFF_COMBO == spellId then
		return true;
	end

	if APB_BUFF_COMBO_MAX and APB_BUFF_COMBO_MAX == spellId then
		return true;
	end

	if ACI_Buff_list and (ACI_Buff_list[name] or ACI_Buff_list[spellId]) then
		return true;
	end
	return false;
end


local bfirst = true;


local function asOverlay_OnEvent(self, event, ...)
	if bfirst then
		ns.SetupOptionPanels();
		bfirst = false;
	end

	if (event == "SPELL_ACTIVATION_OVERLAY_SHOW") then
		local spellID, texture, positions, scale, r, g, b = ...;

		if not (ns.options.Check_asMOD and IsShown(spellID)) then
			asOverlay_ShowAllOverlays(self, spellID, texture, positions, scale, r, g, b)
		end

		local cvaralpha = Settings.GetValue("spellActivationOverlayOpacity");
		if cvaralpha then
			self:SetAlpha(cvaralpha);
		end
	elseif (event == "SPELL_ACTIVATION_OVERLAY_HIDE") then
		local spellID = ...;		
		if (spellID) then
			asOverlay_HideOverlays(self, spellID);			
		else
			asOverlay_HideAllOverlays(self);
		end
	elseif (event == "UNIT_AURA") then
		ns.needtocheckAura = true;
		asOverlay_CheckAura(self);
	end
end


local frame = CreateFrame("FRAME", nil, UIParent)

local function asOverlay_OnUpdate()
	if frame.overlaysInUse then
		for spellID, overlayList in pairs(frame.overlaysInUse) do
			if (overlayList and #overlayList) then
				local aura = ns.GetAura(spellID, true);

				if aura then
					local extime = aura.expirationTime;
					local duration = aura.duration;
					local remain = extime - GetTime();
					local rate = 0;
					local count = aura.applications;

					if remain > 0 then
						rate = math.ceil(remain / duration * 100) / 100;
					end


					for i = 1, #overlayList do
						local overlay = overlayList[i];

						if overlay:IsShown() then
							if overlay.width and overlay.height then
								local texLeft, texRight, texTop, texBottom = 0, 1, 0, 1;

								if (overlay.vflip) then
									texTop, texBottom = 1, 0;
								end
								if (overlay.hflip) then
									texLeft, texRight = 1, 0;
								end

								if overlay.side then
									if (overlay.vflip) then
										overlay.cooldown.texture:SetTexCoord(texLeft, texRight, texTop, 1 - rate);
									else
										overlay.cooldown.texture:SetTexCoord(texLeft, texRight, 1 - rate, texBottom);
									end
									overlay.cooldown:SetSize(overlay.width, overlay.height * rate);
								else
									if (overlay.hflip) then
										overlay.cooldown.texture:SetTexCoord(rate, texRight, texTop, texBottom);
									else
										overlay.cooldown.texture:SetTexCoord(texLeft, rate, texTop, texBottom);
									end
									overlay.cooldown:SetSize(overlay.width * rate, overlay.height);
								end
							end
						end
					end
				end
			end
		end
	end
end

frame:SetPoint("CENTER", UIParent, "CENTER", 0, 0)
frame:SetWidth(256)
frame:SetHeight(256)

frame:SetScript("OnEvent", asOverlay_OnEvent);
C_Timer.NewTicker(0.1, asOverlay_OnUpdate);
asOverlay_OnLoad(frame);
