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
	ret.count:SetFont(STANDARD_TEXT_FONT, 15, "OUTLINE");
	ret.count:SetTextColor(0, 1, 0);
	ret.remain:SetFont(STANDARD_TEXT_FONT, 12, "OUTLINE");
	ret.remain:SetTextColor(1, 1, 1);
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
			overlay.pulse:Pause();
			overlay.animOut:Play();
		end
	end
end

local function asOverlay_HideAllOverlays(self)
	for spellID, overlayList in pairs(self.overlaysInUse) do
		asOverlay_HideOverlays(self, spellID);
	end
end


function asOverlayTexture_OnShow(self)
	self.animIn:Play();
end

function asOverlayTexture_OnFadeInPlay(animGroup)
	animGroup:GetParent():SetAlpha(0);
end

function asOverlayTexture_OnFadeInFinished(animGroup)
	local overlay = animGroup:GetParent();
	overlay:SetAlpha(1);
	overlay.pulse:Play();
end

function asOverlayTexture_OnFadeOutFinished(anim)
	local overlay = anim:GetRegionParent();
	local overlayParent = overlay:GetParent();
	overlay.pulse:Stop();
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

	if ns.positionaware[spellID] then
		local v = ns.positionaware[spellID];

		if v[1] and position == v[1] then
			position = v[2];
		end
	end

	if ns.countaware[spellID] then
		countAuraList[spellID] = true;
		for _, auraid in pairs(ns.countaware[spellID]) do
			aura = ns.getExpirationTimeUnitAurabyID(auraid, true);

			local remain = 0;

			if aura then
				local extime = aura.expirationTime;
				local duration = aura.duration;
				remain = extime - GetTime();

				if remain > 0 then
					rate = remain / duration;
				end
				break;
			end
		end
	else
		local auraid = spellID;
		aura = ns.getExpirationTimeUnitAurabyID(auraid);
		local remain = 0;

		if aura then
			local extime = aura.expirationTime;
			local duration = aura.duration;
			remain = extime - GetTime();

			if remain > 0 then
				rate = remain / duration;
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

			local procaura = ns.getExpirationTimeUnitAurabyID(procid, true);

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


	local overlay = asOverlay_GetOverlay(self, spellID, position);
	overlay.spellID = spellID;
	overlay.position = position;

	overlay:ClearAllPoints();

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
	elseif position == Enum.ScreenLocationType.Left then
		width, height = shortSide, longSide;
		overlay:SetPoint("BOTTOMRIGHT", self, "BOTTOMLEFT", 0, (height * (1 - scale)) / 2);
	elseif position == Enum.ScreenLocationType.LeftOutside then
		width, height = shortSide, longSide;
		overlay:SetPoint("BOTTOMRIGHT", self, "BOTTOMLEFT", -shortSide, (height * (1 - scale)) / 2);
	elseif position == Enum.ScreenLocationType.Right then
		width, height = shortSide, longSide;
		overlay:SetPoint("BOTTOMLEFT", self, "BOTTOMRIGHT", 0, (height * (1 - scale)) / 2);
	elseif position == Enum.ScreenLocationType.RightOutside then
		width, height = shortSide, longSide;
		overlay:SetPoint("BOTTOMLEFT", self, "BOTTOMRIGHT", shortSide, (height * (1 - scale)) / 2);
	elseif position == Enum.ScreenLocationType.Top then
		width, height = longSide, shortSide;
		overlay:SetPoint("BOTTOMLEFT", self, "TOPLEFT", (width * (1 - scale)) / 2, 0);
	elseif position == Enum.ScreenLocationType.Bottom then
		width, height = longSide, shortSide;
		overlay:SetPoint("TOPLEFT", self, "BOTTOMLEFT", (width * (1 - scale)) / 2, 0);
	elseif position == Enum.ScreenLocationType.TopRight then
		width, height = shortSide, shortSide;
		overlay:SetPoint("BOTTOMLEFT", self, "TOPRIGHT", 0, 0);
	elseif position == Enum.ScreenLocationType.TopLeft then
		width, height = shortSide, shortSide;
		overlay:SetPoint("BOTTOMRIGHT", self, "TOPLEFT", 0, 0);
	else
		--GMError("Unknown asOverlay position: "..tostring(position));
		return;
	end

	if position == Enum.ScreenLocationType.Left or position == Enum.ScreenLocationType.Right or position == Enum.ScreenLocationType.LeftOutside or position == Enum.ScreenLocationType.RightOutside then
		overlay.side = true;
		overlay.count:ClearAllPoints()
		overlay.count:SetPoint("BOTTOM", overlay, "BOTTOM", 0, 0);
		overlay.remain:ClearAllPoints()
		overlay.remain:SetPoint("BOTTOM", overlay, "BOTTOM", 20, 0);
	else
		overlay.side = false;
		overlay.count:ClearAllPoints()
		overlay.count:SetPoint("LEFT", overlay, "LEFT", 0, 0);
		overlay.remain:ClearAllPoints()
		overlay.remain:SetPoint("LEFT", overlay, "LEFT", -20, 0);
	end

	overlay.width = width * scale;
	overlay.height = height * scale;

	overlay.texture:SetTexture(texturePath);
	overlay.texture:SetVertexColor(r / 255, g / 255, b / 255);

	if ns.options.ShowAlpha == false then
		if overlay.side then
			if (overlay.vflip) then
				overlay.texture:SetTexCoord(texLeft, texRight, texTop, 1 - rate);
			else
				overlay.texture:SetTexCoord(texLeft, texRight, 1 - rate, texBottom);
			end
			overlay:SetSize(overlay.width, overlay.height * rate);
		else
			if (overlay.hflip) then
				overlay.texture:SetTexCoord(rate, texRight, texTop, texBottom);
			else
				overlay.texture:SetTexCoord(texLeft, rate, texTop, texBottom);
			end
			overlay:SetSize(overlay.width * rate, overlay.height);
		end
	else
		overlay:SetSize(overlay.width, overlay.height);
		overlay.texture:SetTexCoord(texLeft, texRight, texTop, texBottom);
		overlay:SetAlpha(rate * settingalpha);
	end

	overlay.animOut:Stop(); --In case we're in the process of animating this out.
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

	overlay:Show();
end



local function asOverlay_CheckAura(self)
	for spellID, _ in pairs(countAuraList) do
		if ns.countaware[spellID] then
			for _, auraid in pairs(ns.countaware[spellID]) do
				local procaura = ns.getExpirationTimeUnitAurabyID(auraid, true);

				if procaura then
					local count = procaura.applications;
					local overlay = asOverlay_GetOverlay(self, spellID, Enum.ScreenLocationType.Right, true) or
					asOverlay_GetOverlay(self, spellID, Enum.ScreenLocationType.RightOutside, true);

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

				local procaura = ns.getExpirationTimeUnitAurabyID(procid, true);

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
										overlay.texture:SetVertexColor(r / 255, g / 255, b / 255);
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
				overlay.texture:SetVertexColor(1, 1, 1);
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
	local name = C_Spell.GetSpellName(spellId)

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

	if ACI_Buff_list and (ACI_Buff_list[name] or (spellId and ACI_Buff_list[spellId])) then
		return true;
	end

	return false;
end


local bfirst = true;


local function asOverlay_OnEvent(self, event, ...)
	local cvaralpha = Settings.GetValue("spellActivationOverlayOpacity");
	if cvaralpha then
		self:SetAlpha(cvaralpha);
	end
	if bfirst then
		ns.SetupOptionPanels();
		bfirst = false;
	end

	if (event == "SPELL_ACTIVATION_OVERLAY_SHOW") then
		local spellID, texture, positions, scale, r, g, b = ...;

		if not IsShown(spellID) then
			asOverlay_ShowAllOverlays(self, spellID, texture, positions, scale, r, g, b)
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
				local aura = ns.getExpirationTimeUnitAurabyID(spellID);

				if aura then
					local extime = aura.expirationTime;
					local duration = aura.duration;
					local remain = extime - GetTime();
					local rate = 0;
					local count = aura.applications;

					if remain > 0 then
						rate = remain / duration;
					end


					for i = 1, #overlayList do
						local overlay = overlayList[i];
						if ns.options.ShowAlpha == true then
							overlay:SetAlpha(rate * settingalpha);
						elseif overlay.width and overlay.height then
							local texLeft, texRight, texTop, texBottom = 0, 1, 0, 1;

							if (overlay.vflip) then
								texTop, texBottom = 1, 0;
							end
							if (overlay.hflip) then
								texLeft, texRight = 1, 0;
							end

							if overlay.side then
								if (overlay.vflip) then
									overlay.texture:SetTexCoord(texLeft, texRight, texTop, 1 - rate);
								else
									overlay.texture:SetTexCoord(texLeft, texRight, 1 - rate, texBottom);
								end
								overlay:SetSize(overlay.width, overlay.height * rate);
							else
								if (overlay.hflip) then
									overlay.texture:SetTexCoord(rate, texRight, texTop, texBottom);
								else
									overlay.texture:SetTexCoord(texLeft, rate, texTop, texBottom);
								end
								overlay:SetSize(overlay.width * rate, overlay.height);
							end
						end

						if count > 1 and i == 1 and ns.options.ShowCount then
							overlay.count:SetText(count);
							overlay.count:Show();
						else
							overlay.count:Hide();
						end

						if remain > 0 and i == 1 and ns.options.ShowRemainTime then
							overlay.remain:SetText(math.ceil(remain));
							overlay.remain:Show();
						else
							overlay.remain:Hide();
						end
					end
				else
					for i = 1, #overlayList do
						local overlay = overlayList[i];
						overlay.count:Hide();
						overlay.remain:Hide();
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
