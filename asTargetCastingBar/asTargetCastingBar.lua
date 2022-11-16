

local ATCB_SPELLBAR_X = 0;			-- Spell bar 위치
local ATCB_SPELLBAR_Y = -110 ;

function asCastingBarFrame_SetUnit(self, unit, showTradeSkills, showShield)
	if self.unit ~= unit then
		self.unit = unit;
		self.showTradeSkills = showTradeSkills;
		self.showShield = showShield;

		self.casting = nil;
		self.channeling = nil;
		self.holdTime = 0;
		self.fadeOut = nil;

		if unit then
			self:RegisterEvent("UNIT_SPELLCAST_INTERRUPTED");
			self:RegisterEvent("UNIT_SPELLCAST_DELAYED");
			self:RegisterEvent("UNIT_SPELLCAST_CHANNEL_START");
			self:RegisterEvent("UNIT_SPELLCAST_CHANNEL_UPDATE");
			self:RegisterEvent("UNIT_SPELLCAST_CHANNEL_STOP");
			self:RegisterEvent("UNIT_SPELLCAST_INTERRUPTIBLE");
			self:RegisterEvent("UNIT_SPELLCAST_NOT_INTERRUPTIBLE");
			self:RegisterEvent("PLAYER_ENTERING_WORLD");
			self:RegisterUnitEvent("UNIT_SPELLCAST_START", unit);
			self:RegisterUnitEvent("UNIT_SPELLCAST_STOP", unit);
			self:RegisterUnitEvent("UNIT_SPELLCAST_FAILED", unit);

			asCastingBarFrame_OnEvent(self, "PLAYER_ENTERING_WORLD")
		else
			self:UnregisterEvent("UNIT_SPELLCAST_INTERRUPTED");
			self:UnregisterEvent("UNIT_SPELLCAST_DELAYED");
			self:UnregisterEvent("UNIT_SPELLCAST_CHANNEL_START");
			self:UnregisterEvent("UNIT_SPELLCAST_CHANNEL_UPDATE");
			self:UnregisterEvent("UNIT_SPELLCAST_CHANNEL_STOP");
			self:UnregisterEvent("UNIT_SPELLCAST_INTERRUPTIBLE");
			self:UnregisterEvent("UNIT_SPELLCAST_NOT_INTERRUPTIBLE");
			self:UnregisterEvent("PLAYER_ENTERING_WORLD");
			self:UnregisterEvent("UNIT_SPELLCAST_START");
			self:UnregisterEvent("UNIT_SPELLCAST_STOP");
			self:UnregisterEvent("UNIT_SPELLCAST_FAILED");

			self:Hide();
		end
	end
end



function asTargetFrame_CreateSpellbar(self, event, boss)

	local name = self:GetName().."SpellBar";
	local spellbar;
	if ( boss ) then
		spellbar = CreateFrame("STATUSBAR", name, self, "asBossSpellBarTemplate");
	else
		spellbar = CreateFrame("STATUSBAR", name, self, "asTargetSpellBarTemplate");
	end
	spellbar.boss = boss;
	self.spellbar = spellbar;
	self.auraRows = 0;
	self.unit = "target";
		
	asCastingBarFrame_SetUnit(spellbar, self.unit, false, true);
	if ( event ) then
		spellbar.updateEvent = event;
		spellbar:RegisterEvent(event);
	end

	asTarget_Spellbar_AdjustPosition(self);
end


function asCastingBarFrame_FinishSpell(self)
	if not self.finishedColorSameAsStart then
		self:SetStatusBarColor(self.finishedCastColor:GetRGB());
	end
	if ( self.Spark ) then
		self.Spark:Hide();
	end
	if ( self.Flash ) then
		self.Flash:SetAlpha(0.0);
		self.Flash:Show();
	end
	self.flash = true;
	self.fadeOut = true;
	self.casting = nil;
	self.channeling = nil;
end

function asCastingBarFrame_GetEffectiveStartColor(self, isChannel, notInterruptible)
	if self.nonInterruptibleColor and notInterruptible then
		return self.nonInterruptibleColor;
	end	
	return isChannel and self.startChannelColor or self.startCastColor;
end




function asCastingBarFrame_OnEvent(self, event, ...)
	local arg1 = ...;
	
	local unit = self.unit;
	if ( event == "PLAYER_ENTERING_WORLD" ) then
		local nameChannel = UnitChannelInfo(unit);
		local nameSpell = UnitCastingInfo(unit);
		if ( nameChannel ) then
			event = "UNIT_SPELLCAST_CHANNEL_START";
			arg1 = unit;
		elseif ( nameSpell ) then
			event = "UNIT_SPELLCAST_START";
			arg1 = unit;
		else
		    asCastingBarFrame_FinishSpell(self);
		end
	elseif ( event == self.updateEvent ) then	

		-- check if the new target is casting a spell
		local nameChannel  = UnitChannelInfo(self.unit);
		local nameSpell  = UnitCastingInfo(self.unit);
		if ( nameChannel ) then
			event = "UNIT_SPELLCAST_CHANNEL_START";
			arg1 = self.unit;
		elseif ( nameSpell ) then
			event = "UNIT_SPELLCAST_START";
			arg1 = self.unit;
		else
			self.casting = nil;
			self.channeling = nil;
			self:SetMinMaxValues(0, 0);
			self:SetValue(0);
			self:Hide();
			return;
		end
		-- The position depends on the classification of the target
		asTarget_Spellbar_AdjustPosition(self);

	end

	if ( arg1 ~= unit ) then
		return;
	end
	
	if ( event == "UNIT_SPELLCAST_START" ) then
		local name,  text, texture, startTime, endTime, isTradeSkill, castID, notInterruptible = UnitCastingInfo(unit);
		if ( not name or (not self.showTradeSkills and isTradeSkill)) then
			self:Hide();
			return;
		end

		local startColor = asCastingBarFrame_GetEffectiveStartColor(self, false, notInterruptible);
		self:SetStatusBarColor(startColor:GetRGB());
		if self.flashColorSameAsStart then
			self.Flash:SetVertexColor(startColor:GetRGB());
		else
			self.Flash:SetVertexColor(1, 1, 1);
		end
		
		if ( self.Spark ) then
			self.Spark:Show();
		end
		self.value = (GetTime() - (startTime / 1000));
		self.maxValue = (endTime - startTime) / 1000;
		self:SetMinMaxValues(0, self.maxValue);
		self:SetValue(self.value);
		if ( self.Text ) then
			self.Text:SetText(text);
		end
		if ( self.Icon ) then
			self.Icon:SetTexture(texture);
			if ( self.iconWhenNoninterruptible ) then
				self.Icon:SetShown(not notInterruptible);
			end
		end
		asCastingBarFrame_ApplyAlpha(self, 1.0);
		self.holdTime = 0;
		self.casting = true;
		self.castID = castID;
		self.channeling = nil;
		self.fadeOut = nil;

		if ( self.BorderShield ) then
			if ( self.showShield and notInterruptible ) then
				self.BorderShield:Show();
				if ( self.BarBorder ) then
					self.BarBorder:Hide();
				end
			else
				self.BorderShield:Hide();
				if ( self.BarBorder ) then
					self.BarBorder:Show();
				end
			end
		end
		if ( self.showCastbar ) then
			self:Show();
		end

	elseif ( event == "UNIT_SPELLCAST_STOP" or event == "UNIT_SPELLCAST_CHANNEL_STOP") then
		if ( not self:IsVisible() ) then
			self:Hide();
		end
		if ( (self.casting and event == "UNIT_SPELLCAST_STOP" and select(4, ...) == self.castID) or
		     (self.channeling and event == "UNIT_SPELLCAST_CHANNEL_STOP") ) then
			if ( self.Spark ) then
				self.Spark:Hide();
			end
			if ( self.Flash ) then
				self.Flash:SetAlpha(0.0);
				self.Flash:Show();
			end
			self:SetValue(self.maxValue);
			if ( event == "UNIT_SPELLCAST_STOP" ) then
				self.casting = nil;
				if not self.finishedColorSameAsStart then
					self:SetStatusBarColor(self.finishedCastColor:GetRGB());
				end
			else
				self.channeling = nil;
			end
			self.flash = true;
			self.fadeOut = true;
			self.holdTime = 0;
		end
	elseif ( event == "UNIT_SPELLCAST_FAILED" or event == "UNIT_SPELLCAST_INTERRUPTED" ) then
		if ( self:IsShown() and
		     (self.casting and select(2, ...) == self.castID) and not self.fadeOut ) then
			self:SetValue(self.maxValue);
			self:SetStatusBarColor(self.failedCastColor:GetRGB());
			if ( self.Spark ) then
				self.Spark:Hide();
			end
			if ( self.Text ) then
				if ( event == "UNIT_SPELLCAST_FAILED" ) then
					self.Text:SetText(FAILED);
				else
					self.Text:SetText(INTERRUPTED);
				end
			end
			self.casting = nil;
			self.channeling = nil;
			self.fadeOut = true;
			self.holdTime = GetTime() + CASTING_BAR_HOLD_TIME;
		end
	elseif ( event == "UNIT_SPELLCAST_DELAYED" ) then
		if ( self:IsShown() ) then
			local name,  text, texture, startTime, endTime, isTradeSkill, castID, notInterruptible = UnitCastingInfo(unit);
			if ( not name or (not self.showTradeSkills and isTradeSkill)) then
				-- if there is no name, there is no bar
				self:Hide();
				return;
			end
			self.value = (GetTime() - (startTime / 1000));
			self.maxValue = (endTime - startTime) / 1000;
			self:SetMinMaxValues(0, self.maxValue);
			if ( not self.casting ) then
				self:SetStatusBarColor(CastingBarFrame_GetEffectiveStartColor(self, false, notInterruptible):GetRGB());
				if ( self.Spark ) then
					self.Spark:Show();
				end
				if ( self.Flash ) then
					self.Flash:SetAlpha(0.0);
					self.Flash:Hide();
				end
				self.casting = true;
				self.channeling = nil;
				self.flash = nil;
				self.fadeOut = nil;
			end
		end
	elseif ( event == "UNIT_SPELLCAST_CHANNEL_START" ) then
		local name,  text, texture, startTime, endTime, isTradeSkill, notInterruptible, spellID = UnitChannelInfo(unit);
		if ( not name or (not self.showTradeSkills and isTradeSkill)) then
			-- if there is no name, there is no bar
			self:Hide();
			return;
		end

		local startColor = CastingBarFrame_GetEffectiveStartColor(self, true, notInterruptible);
		if self.flashColorSameAsStart then
			self.Flash:SetVertexColor(startColor:GetRGB());
		else
			self.Flash:SetVertexColor(1, 1, 1);
		end
		self:SetStatusBarColor(startColor:GetRGB());
		self.value = (endTime / 1000) - GetTime();
		self.maxValue = (endTime - startTime) / 1000;
		self:SetMinMaxValues(0, self.maxValue);
		self:SetValue(self.value);
		if ( self.Text ) then
			self.Text:SetText(text);
		end
		if ( self.Icon ) then
			self.Icon:SetTexture(texture);
		end
		if ( self.Spark ) then
			self.Spark:Hide();
		end
		asCastingBarFrame_ApplyAlpha(self, 1.0);
		self.holdTime = 0;
		self.casting = nil;
		self.channeling = true;
		self.fadeOut = nil;
		if ( self.BorderShield ) then
			if ( self.showShield and notInterruptible ) then
				self.BorderShield:Show();
				if ( self.BarBorder ) then
					self.BarBorder:Hide();
				end
			else
				self.BorderShield:Hide();
				if ( self.BarBorder ) then
					self.BarBorder:Show();
				end
			end
		end
		if ( self.showCastbar ) then
			self:Show();
		end
	elseif ( event == "UNIT_SPELLCAST_CHANNEL_UPDATE" ) then
		if ( self:IsShown() ) then
			local name,  text, texture, startTime, endTime, isTradeSkill = UnitChannelInfo(unit);
			if ( not name or (not self.showTradeSkills and isTradeSkill)) then
				-- if there is no name, there is no bar
				self:Hide();
				return;
			end
			self.value = ((endTime / 1000) - GetTime());
			self.maxValue = (endTime - startTime) / 1000;
			self:SetMinMaxValues(0, self.maxValue);
			self:SetValue(self.value);
		end
	elseif ( self.showShield and event == "UNIT_SPELLCAST_INTERRUPTIBLE" ) then
		if ( self.BorderShield ) then
			self.BorderShield:Hide();
			if ( self.BarBorder ) then
				self.BarBorder:Show();
			end
		end
	elseif ( self.showShield and event == "UNIT_SPELLCAST_NOT_INTERRUPTIBLE" ) then
		if ( self.BorderShield ) then
			self.BorderShield:Show();
			if ( self.BarBorder ) then
				self.BarBorder:Hide();
			end
		end
	end
end

function asCastingBarFrame_OnUpdate(self, elapsed)
	if ( self.casting ) then
		self.value = self.value + elapsed;
		if ( self.value >= self.maxValue ) then
			self:SetValue(self.maxValue);
			asCastingBarFrame_FinishSpell(self, self.Spark, self.Flash);
			return;
		end
		self:SetValue(self.value);
		if ( self.Flash ) then
			self.Flash:Hide();
		end
		if ( self.Spark ) then
			local sparkPosition = (self.value / self.maxValue) * self:GetWidth();
			self.Spark:SetPoint("CENTER", self, "LEFT", sparkPosition, self.Spark.offsetY or 2);
		end
	elseif ( self.channeling ) then
		self.value = self.value - elapsed;
		if ( self.value <= 0 ) then
			asCastingBarFrame_FinishSpell(self, self.Spark, self.Flash);
			return;
		end
		self:SetValue(self.value);
		if ( self.Flash ) then
			self.Flash:Hide();
		end
	elseif ( GetTime() < self.holdTime ) then
		return;
	elseif ( self.flash ) then
		local alpha = 0;
		if ( self.Flash ) then
			alpha = self.Flash:GetAlpha() + CASTING_BAR_FLASH_STEP;
		end
		if ( alpha < 1 ) then
			if ( self.Flash ) then
				self.Flash:SetAlpha(alpha);
			end
		else
			if ( self.Flash ) then
				self.Flash:SetAlpha(1.0);
			end
			self.flash = nil;
		end
	elseif ( self.fadeOut ) then
		local alpha = self:GetAlpha() - CASTING_BAR_ALPHA_STEP;
		if ( alpha > 0 ) then
			asCastingBarFrame_ApplyAlpha(self, alpha);
		else
			self.fadeOut = nil;
			self:Hide();
		end
	end
end

function asCastingBarFrame_ApplyAlpha(self, alpha)
	self:SetAlpha(alpha);
	if self.additionalFadeWidgets then
		for widget in pairs(self.additionalFadeWidgets) do
			widget:SetAlpha(alpha);
		end
	end
end

LoadAddOn("asMOD");
function asTarget_Spellbar_AdjustPosition(self)
	local parentFrame = self:GetParent();
	self:SetPoint("CENTER", UIParent, "CENTER", ATCB_SPELLBAR_X, ATCB_SPELLBAR_Y);
    

    if asMOD_setupFrame then
        asMOD_setupFrame (self, "asTargetCastingBar");
    end

end

function ATCB_OnLoad()
	asTargetFrame_CreateSpellbar(ATCB_mainframe, "PLAYER_TARGET_CHANGED", false)
end

ATCB_mainframe = CreateFrame("Frame", "ATCB_mainframe", UIParent);
ATCB_mainframe:Show();

ATCB_OnLoad()
