-----------------Casting Bar 설정 ------------------------
local ACB_Casting_Time = true		--Casting 창 시간 표시
local ACB_Cast_X = 0;				--Casting Bar 위치 X,Y
local ACB_Cast_Y = -260; 

LoadAddOn("asMOD");

CastingBarFrame:ClearAllPoints()
CastingBarFrame:SetPoint("CENTER", "UIParent", "CENTER", ACB_Cast_X, ACB_Cast_Y)
if asMOD_setupFrame then
    asMOD_setupFrame (CastingBarFrame, "asCastBar");

end

CastingBarFrame.ignoreFramePositionManager = true


CastingBarFrame.casticon = CreateFrame("Frame", CastingBarFrame:GetName().."casticon", CastingBarFrame, "asCastIconFrameTemplate");
CastingBarFrame.casticon:EnableMouse(false);
CastingBarFrame.casticon:SetPoint("RIGHT", CastingBarFrame, "LEFT", -4, 2)

CastingBarFrame.casticon:SetWidth(CastingBarFrame:GetHeight() +7);
CastingBarFrame.casticon:SetHeight(CastingBarFrame:GetHeight() +7);
CastingBarFrame.casticon:Hide();

local function casticon_OnEvent(self, event, ...)
	
	if( event == "UNIT_SPELLCAST_START" or event == "UNIT_SPELLCAST_CHANNEL_START" ) then
		local unit, name , spellid = ...;
		
		local name,  text, texture, startTime, endTime, isTradeSkill, castID, notInterruptible, spellid = UnitCastingInfo("player");
	
		local frameIcon = _G[self:GetName().."Icon"]; 

		if name and frameIcon then
			--if name and frameIcon and isTargetPlayer then
			frameIcon:SetTexture(texture);
			frameIcon:Show();
			self:Show();
		else
			frameIcon:Hide();
			self:Hide();
		end
	end
end


CastingBarFrame.casticon:SetScript("OnEvent", casticon_OnEvent)
CastingBarFrame.casticon:RegisterUnitEvent("UNIT_SPELLCAST_START", "player");
CastingBarFrame.casticon:RegisterUnitEvent("UNIT_SPELLCAST_CHANNEL_START", "player");


if ACB_Casting_Time then
	local font, size, flag = _G["NumberFontNormal"]:GetFont()
	CastingBarFrame.timer = CastingBarFrame:CreateFontString(nil)
	CastingBarFrame.timer:SetFont(font, 10, "THINOUTLINE")
	CastingBarFrame.timer:SetPoint("RIGHT", CastingBarFrame, "RIGHT", -5, 2)
	CastingBarFrame.update = 0.1
     
	    
	local function CastingBarFrame_OnUpdate_Hook(self, elapsed)
		if not self.timer then return end
		if self.update and self.update < elapsed then
			if self.casting  or self.channeling  then
				self.timer:SetText(format("%.1f/%.1f", max(self.maxValue - self.value, 0), max(self.maxValue, 0)))
			else
				self.timer:SetText("")
			end
			self.update = .1
		else
			self.update = self.update - elapsed
		end
	end

	CastingBarFrame:HookScript('OnUpdate', CastingBarFrame_OnUpdate_Hook)
end
