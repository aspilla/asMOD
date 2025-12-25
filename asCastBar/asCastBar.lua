local configs = {
	ShowTime = true,
	ShowIcon = true,
}

local castframe = PlayerCastingBarFrame;

if configs.ShowIcon then
	castframe.casticon = CreateFrame("Frame", nil, castframe, "asCastIconFrameTemplate");
	castframe.casticon:EnableMouse(false);
	castframe.casticon:SetPoint("TOPRIGHT", castframe, "TOPLEFT", -3, 0)

	castframe.casticon:SetHeight(castframe:GetHeight() + 10);
	castframe.casticon:SetWidth((castframe:GetHeight() + 10) * 1.1);
	castframe.casticon.icon:SetTexCoord(.08, .92, .08, .92);
	castframe.casticon.border:SetTexCoord(0.08, 0.08, 0.08, 0.92, 0.92, 0.08, 0.92, 0.92);
	castframe.casticon.border:SetVertexColor(0, 0, 0);
	castframe.casticon:Hide();

	local function on_event(self)
		local name, _, texture = UnitCastingInfo("player");

		if not name then
			name, _, texture = UnitChannelInfo("player")
		end

		if name and self.icon then
			self.icon:SetTexture(texture);
			self:Show();
		else
			self:Hide();
		end
	end


	castframe.casticon:SetScript("OnEvent", on_event)
	castframe.casticon:RegisterUnitEvent("UNIT_SPELLCAST_START", "player");
	castframe.casticon:RegisterUnitEvent("UNIT_SPELLCAST_CHANNEL_START", "player");
	castframe.casticon:RegisterUnitEvent("UNIT_SPELLCAST_EMPOWER_START", "player");
end


if configs.ShowTime then
	castframe.timer = castframe:CreateFontString(nil)
	castframe.timer:SetFont(STANDARD_TEXT_FONT, 11, "THINOUTLINE")
	castframe.timer:SetPoint("TOPRIGHT", castframe, "BOTTOMRIGHT", 0, -2)
	castframe.update = 0.1

	local update = 0;

	local function update_hook(self, elapsed)
		if not self.timer then return end
		if update >= 0.1 then
			if self.casting and not issecretvalue(self.maxValue) then
				self.timer:SetText(format("%.1f/%.1f", max(self.maxValue - self.value, 0), max(self.maxValue, 0)))
			elseif self.channeling and not issecretvalue(self.maxValue) then
				self.timer:SetText(format("%.1f/%.1f", max(self.value, 0), max(self.maxValue, 0)))
			else
				self.timer:SetText("")
			end
			update = 0;
		else
			update = update + elapsed
		end
	end

	castframe:HookScript('OnUpdate', update_hook)
end
