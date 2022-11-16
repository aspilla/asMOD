
local sizeScale = 0.8;
local longSide = 256 * sizeScale;
local shortSide = 128 * sizeScale;



local function getExpirationTimeUnitAurabyID(unit, id, filter)

	local i = 1;
	repeat

		local name, icon, count, debuffType, duration, expirationTime, unitCaster, canStealOrPurge, nameplateShowPersonal, spellId = UnitAura(unit, i, filter);

		if name and spellId == id then
			return 	expirationTime, duration;
		end
		i = i + 1;
	until (name == nil)

	return nil;
end


function asOverlay_OnLoad(self)
	self.overlaysInUse = {};
	self.unusedOverlays = {};
		
	self:RegisterEvent("SPELL_ACTIVATION_OVERLAY_SHOW");
	self:RegisterEvent("SPELL_ACTIVATION_OVERLAY_HIDE");

	SpellActivationOverlayFrame:UnregisterEvent("SPELL_ACTIVATION_OVERLAY_SHOW");
	SpellActivationOverlayFrame:UnregisterEvent("SPELL_ACTIVATION_OVERLAY_HIDE");

		
	self:SetSize(longSide, longSide)
end

function asOverlay_OnEvent(self, event, ...)
	if ( event == "SPELL_ACTIVATION_OVERLAY_SHOW" ) then
		local spellID, texture, positions, scale, r, g, b = ...;
		--if ( GetCVarBool("displaySpellActivationOverlays") ) then 
			asOverlay_ShowAllOverlays(self, spellID, texture, positions, scale, r, g, b)
		--end
	elseif ( event == "SPELL_ACTIVATION_OVERLAY_HIDE" ) then
		local spellID = ...;
		if ( spellID ) then
			asOverlay_HideOverlays(self, spellID);
		else
			asOverlay_HideAllOverlays(self);
		end
	end
end


local update = 0;

function asOverlay_OnUpdate(self, elapsed)

	

	update = update + elapsed;

	if update >= 0.25 and self.overlaysInUse then

		for spellID, overlayList in pairs(self.overlaysInUse) do

			if ( overlayList and #overlayList ) then

				local extime, duration = getExpirationTimeUnitAurabyID("player", spellID, "HELPFUL|PLAYER");

				if extime then
					local remain =	 extime - GetTime();
					local rate = 0;

					if remain > 0 then
						rate = remain/duration;
					end
					
				
					for i=1, #overlayList do
						local overlay = overlayList[i];

						overlay.texture:SetAlpha(GetCVar("spellActivationOverlayOpacity") * rate)	
					end
				end
			end
		end

		update = 0;
	end

	


end

local complexLocationTable = {
	["RIGHT (FLIPPED)"] = {
		RIGHT = {	hFlip = true },
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

function asOverlay_ShowAllOverlays(self, spellID, texturePath, positions, scale, r, g, b)
	positions = strupper(positions);
	if ( complexLocationTable[positions] ) then
		for location, info in pairs(complexLocationTable[positions]) do
			asOverlay_ShowOverlay(self, spellID, texturePath, location, scale, r, g, b, info.vFlip, info.hFlip);
		end
	else
		asOverlay_ShowOverlay(self, spellID, texturePath, positions, scale, r, g, b, false, false);
	end
end

function asOverlay_ShowOverlay(self, spellID, texturePath, position, scale, r, g, b, vFlip, hFlip)
	local overlay = asOverlay_GetOverlay(self, spellID, position);
	overlay.spellID = spellID;
	overlay.position = position;
	
	overlay:ClearAllPoints();
	
	local texLeft, texRight, texTop, texBottom = 0, 1, 0, 1;
	if ( vFlip ) then
		texTop, texBottom = 1, 0;
	end
	if ( hFlip ) then
		texLeft, texRight = 1, 0;
	end
	overlay.texture:SetTexCoord(texLeft, texRight, texTop, texBottom);


	local width, height;
	if ( position == "CENTER" ) then
		width, height = longSide, longSide;
		overlay:SetPoint("CENTER", self, "CENTER", 0, 0);
	elseif ( position == "LEFT" ) then
		width, height = shortSide, longSide;
		overlay:SetPoint("RIGHT", self, "LEFT", 0, 0);
	elseif ( position == "RIGHT" ) then
		width, height = shortSide, longSide;
		overlay:SetPoint("LEFT", self, "RIGHT", 0, 0);
	elseif ( position == "TOP" ) then
		width, height = longSide, shortSide;
		overlay:SetPoint("BOTTOM", self, "TOP");
	elseif ( position == "BOTTOM" ) then
		width, height = longSide, shortSide;
		overlay:SetPoint("TOP", self, "BOTTOM");
	elseif ( position == "TOPRIGHT" ) then
		width, height = shortSide, shortSide;
		overlay:SetPoint("BOTTOMLEFT", self, "TOPRIGHT", 0, 0);
	elseif ( position == "TOPLEFT" ) then
		width, height = shortSide, shortSide;
		overlay:SetPoint("BOTTOMRIGHT", self, "TOPLEFT", 0, 0);
	elseif ( position == "BOTTOMRIGHT" ) then
		width, height = shortSide, shortSide;
		overlay:SetPoint("TOPLEFT", self, "BOTTOMRIGHT", 0, 0);
	elseif ( position == "BOTTOMLEFT" ) then
		width, height = shortSide, shortSide;
		overlay:SetPoint("TOPRIGHT", self, "BOTTOMLEFT", 0, 0);
	else
		--GMError("Unknown asOverlay position: "..tostring(position));
		return;
	end
	
	overlay:SetSize(width * scale, height * scale);
	
	overlay.texture:SetTexture(texturePath);
	overlay.texture:SetVertexColor(r / 255, g / 255, b / 255);

	overlay.texture:SetAlpha(GetCVar("spellActivationOverlayOpacity"))	
	
	overlay.animOut:Stop();	--In case we're in the process of animating this out.
	PlaySound(SOUNDKIT.UI_POWER_AURA_GENERIC);
	overlay:Show();
end

function asOverlay_GetOverlay(self, spellID, position)
	local overlayList = self.overlaysInUse[spellID];
	local overlay;
	if ( overlayList ) then
		for i=1, #overlayList do
			if ( overlayList[i].position == position ) then
				overlay = overlayList[i];
			end
		end
	end
	
	if ( not overlay ) then
		overlay = asOverlay_GetUnusedOverlay(self);
		if ( overlayList ) then
			tinsert(overlayList, overlay);
		else
			self.overlaysInUse[spellID] = { overlay };
		end
	end
	
	return overlay;
end

function asOverlay_HideOverlays(self, spellID)
	local overlayList = self.overlaysInUse[spellID];
	if ( overlayList ) then
		for i=1, #overlayList do
			local overlay = overlayList[i];
			overlay.pulse:Pause();
			overlay.animOut:Play();
		end
	end
end

function asOverlay_HideAllOverlays(self)
	for spellID, overlayList in pairs(self.overlaysInUse) do
		asOverlay_HideOverlays(self, spellID);
	end
end

function asOverlay_GetUnusedOverlay(self)
	local overlay = tremove(self.unusedOverlays, #self.unusedOverlays);
	if ( not overlay ) then
		overlay = asOverlay_CreateOverlay(self);
	end
	return overlay;
end

function asOverlay_CreateOverlay(self)
	return CreateFrame("Frame", nil, self, "asOverlayTemplate");
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
