-----------------Casting Bar 설정 ------------------------
local ACB_Casting_Time = true --Casting 창 시간 표시



PlayerCastingBarFrame.casticon = CreateFrame("Frame", nil, PlayerCastingBarFrame, "asCastIconFrameTemplate");
PlayerCastingBarFrame.casticon:EnableMouse(false);
PlayerCastingBarFrame.casticon:SetPoint("TOPRIGHT", PlayerCastingBarFrame, "TOPLEFT", -3, 0)

PlayerCastingBarFrame.casticon:SetHeight(PlayerCastingBarFrame:GetHeight() + 10);
PlayerCastingBarFrame.casticon:SetWidth((PlayerCastingBarFrame:GetHeight() + 10) * 1.2);
PlayerCastingBarFrame.casticon.icon:SetTexCoord(.08, .92, .08, .92);
--PlayerCastingBarFrame.casticon.border:SetTexture("Interface\\Addons\\asCastbar\border.tga");
PlayerCastingBarFrame.casticon.border:SetTexCoord(0.08, 0.08, 0.08, 0.92, 0.92, 0.08, 0.92, 0.92);
PlayerCastingBarFrame.casticon.border:SetVertexColor(0, 0, 0);
PlayerCastingBarFrame.casticon.border:Show();
PlayerCastingBarFrame.casticon:Hide();

local function casticon_OnEvent(self, event, ...)
	local unit, name, spellid = ...;
	local name, text, texture, startTime, endTime, isTradeSkill, castID, notInterruptible, spellid = UnitCastingInfo(
	"player");

	if not name then
		name, text, texture, startTime, endTime, isTradeSkill, notInterruptible, spellid = UnitChannelInfo("player")
	end

	local frameIcon = self.icon
	if name and frameIcon then
		frameIcon:SetTexture(texture);
		frameIcon:Show();
		self:Show();
	else
		frameIcon:Hide();
		self:Hide();
	end
end


PlayerCastingBarFrame.casticon:SetScript("OnEvent", casticon_OnEvent)
PlayerCastingBarFrame.casticon:RegisterUnitEvent("UNIT_SPELLCAST_START", "player");
PlayerCastingBarFrame.casticon:RegisterUnitEvent("UNIT_SPELLCAST_CHANNEL_START", "player");
PlayerCastingBarFrame.casticon:RegisterUnitEvent("UNIT_SPELLCAST_EMPOWER_START", "player");


if ACB_Casting_Time then
	local font, size, flag = _G["NumberFontNormal"]:GetFont()
	PlayerCastingBarFrame.timer = PlayerCastingBarFrame:CreateFontString(nil)
	PlayerCastingBarFrame.timer:SetFont(font, 11, "THINOUTLINE")
	PlayerCastingBarFrame.timer:SetPoint("TOPRIGHT", PlayerCastingBarFrame, "BOTTOMRIGHT", 0, -2)
	PlayerCastingBarFrame.update = 0.1

	local update = 0;

	local function CastingBarFrame_OnUpdate_Hook(self, elapsed)
		if not self.timer then return end
		if update >= 0.1 then
			if self.casting or self.channeling then
				self.timer:SetText(format("%.1f/%.1f", max(self.maxValue - self.value, 0), max(self.maxValue, 0)))
			else
				self.timer:SetText("")
			end
			update = 0;
		else
			update = update + elapsed
		end
	end

	PlayerCastingBarFrame:HookScript('OnUpdate', CastingBarFrame_OnUpdate_Hook)
end
