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


local function asOverlay_GetOverlay(self, spellID, position)
	local overlayList = self.overlaysInUse[spellID];
	local overlay;
	if (overlayList) then
		for i = 1, #overlayList do
			if (overlayList[i].position == position) then
				overlay = overlayList[i];
			end
		end
	end

	if (not overlay) then
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

local complexLocationTable = {
	["RIGHT (FLIPPED)"] = {
		RIGHT = { hFlip = true },
	},
	["BOTTOM (FLIPPED)"] = {
		BOTTOM = { vFlip = true },
	},
	["LEFT + RIGHT (FLIPPED)"] = {
		LEFT = {},
		RIGHT = { hFlip = true },
	},
	["TOP + BOTTOM (FLIPPED)"] = {
		TOP = {},
		BOTTOM = { vFlip = true },
	},
}



local function asOverlay_ShowOverlay(self, spellID, texturePath, position, scale, r, g, b, vFlip, hFlip)
	local overlay = asOverlay_GetOverlay(self, spellID, position);
	overlay.spellID = spellID;
	overlay.position = position;

	overlay:ClearAllPoints();

	local texLeft, texRight, texTop, texBottom = 0, 1, 0, 1;
	overlay.vflip = false;
	overlay.hflip = false;
	if (vFlip) then
		texTop, texBottom = 1, 0;
		overlay.vflip = true;
	end
	if (hFlip) then
		texLeft, texRight = 1, 0;
		overlay.hflip = true;
	end

	local aura = ns.getExpirationTimeUnitAurabyID("player", spellID);
	local rate = 1;
	local count = 0;
	local remain = 0;

	if aura then
		local extime = aura.expirationTime;
		local duration = aura.duration;
		remain = extime - GetTime();
		count = aura.applications;

		if remain > 0 then
			rate = remain / duration;
		end

		if ns.spelllists[spellID] then
			local procid = ns.spelllists[spellID][1];
			local proc_count = ns.spelllists[spellID][2];
			local proc_r = ns.spelllists[spellID][3];
			local proc_g = ns.spelllists[spellID][4];
			local proc_b = ns.spelllists[spellID][5];

			local procaura = ns.getExpirationTimeUnitAurabyID("player", procid);

			if procaura then				
				if (proc_count > 0 and procaura.applications >= proc_count) or proc_count == 0 then
					r = proc_r * 255;
					g = proc_g * 255;
					b = proc_b * 255;
				end
			end
		end
	end

	local width, height;
	if (position == "CENTER") then
		width, height = longSide, longSide;
		overlay:SetPoint("CENTER", self, "CENTER", 0, 0);
	elseif (position == "LEFT") then
		width, height = shortSide, longSide;
		overlay:SetPoint("BOTTOMRIGHT", self, "BOTTOMLEFT", 0, 0);
	elseif (position == "RIGHT") then
		width, height = shortSide, longSide;
		overlay:SetPoint("BOTTOMLEFT", self, "BOTTOMRIGHT", 0, 0);
	elseif (position == "TOP") then
		width, height = longSide, shortSide;
		overlay:SetPoint("BOTTOMLEFT", self, "TOPLEFT");
	elseif (position == "BOTTOM") then
		width, height = longSide, shortSide;
		overlay:SetPoint("TOPLEFT", self, "BOTTOMLEFT");
	elseif (position == "TOPRIGHT") then
		width, height = shortSide, shortSide;
		overlay:SetPoint("BOTTOMLEFT", self, "TOPRIGHT", 0, 0);
	elseif (position == "TOPLEFT") then
		width, height = shortSide, shortSide;
		overlay:SetPoint("BOTTOMRIGHT", self, "TOPLEFT", 0, 0);
	elseif (position == "BOTTOMRIGHT") then
		width, height = shortSide, shortSide;
		overlay:SetPoint("TOPLEFT", self, "BOTTOMRIGHT", 0, 0);
	elseif (position == "BOTTOMLEFT") then
		width, height = shortSide, shortSide;
		overlay:SetPoint("TOPRIGHT", self, "BOTTOMLEFT", 0, 0);
	else
		--GMError("Unknown asOverlay position: "..tostring(position));
		return;
	end

	if string.find(position, "LEFT") or string.find(position, "RIGHT") then
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

	overlay:Show();
end

local function asOverlay_ShowAllOverlays(self, spellID, texturePath, positions, scale, r, g, b)
	positions = strupper(positions);
	if (complexLocationTable[positions]) then
		for location, info in pairs(complexLocationTable[positions]) do
			asOverlay_ShowOverlay(self, spellID, texturePath, location, scale, r, g, b, info.vFlip, info.hFlip);
		end
	else
		asOverlay_ShowOverlay(self, spellID, texturePath, positions, scale, r, g, b, false, false);
	end
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
		--if ( GetCVarBool("displaySpellActivationOverlays") ) then
		asOverlay_ShowAllOverlays(self, spellID, texture, positions, scale, r, g, b)
		--end
	elseif (event == "SPELL_ACTIVATION_OVERLAY_HIDE") then
		local spellID = ...;
		if (spellID) then
			asOverlay_HideOverlays(self, spellID);
		else
			asOverlay_HideAllOverlays(self);
		end
	end
end


local update = 0;

local function asOverlay_OnUpdate(self, elapsed)
	update = update + elapsed;

	if update >= 0.1 and self.overlaysInUse then
		for spellID, overlayList in pairs(self.overlaysInUse) do
			if (overlayList and #overlayList) then
				local aura = ns.getExpirationTimeUnitAurabyID("player", spellID);

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
						else
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

		update = 0;
	end
end

local frame = CreateFrame("FRAME", nil, UIParent)
frame:SetPoint("CENTER", UIParent, "CENTER", 0, 0)
frame:SetWidth(256)
frame:SetHeight(256)

frame:SetScript("OnUpdate", asOverlay_OnUpdate);
frame:SetScript("OnEvent", asOverlay_OnEvent);
asOverlay_OnLoad(frame);
