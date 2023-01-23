-----------------설정 ------------------------
local ATCB_WIDTH = 150
local ATCB_HEIGHT = 17
local ATCB_X = 0;
local ATCB_Y = -100;
local ATCB_ALPHA = 0.8;											--투명도 80%
local ATCB_NAME_SIZE = ATCB_HEIGHT * 0.7;						--Spell 명 Font Size, 높이의 70%
local ATCB_TIME_SIZE = ATCB_HEIGHT * 0.5;						--Spell 시전시간 Font Size, 높이의 50%
local ATCB_NOT_INTERRUPTIBLE_COLOR = {0.8, 0.8, 0.8}; 			--차단 불가시 (내가 아닐때) 색상 (r, g, b)
local ATCB_NOT_INTERRUPTIBLE_COLOR_TARGET = {0.8, 0.5, 0.5}; 	--차단 불가시 (내가 타겟일때) 색상 (r, g, b)
local ATCB_INTERRUPTIBLE_COLOR = {0, 0.9, 0}; 					--차단 가능(내가 타겟이 아닐때)시 색상 (r, g, b)
local ATCB_INTERRUPTIBLE_COLOR_TARGET = {0.5, 1, 1}; 			--차단 가능(내가 타겟일 때)시 색상 (r, g, b)
local ATCB_UPDATE_RATE = 0.05									-- 20프레임

-----------------설정 끝끝------------------------
local ATCB = CreateFrame("FRAME", nil, UIParent)
ATCB:SetPoint("BOTTOM",UIParent,"BOTTOM", 0, 0)
ATCB:SetWidth(0)
ATCB:SetHeight(0)
ATCB:Show();

ATCB.castbar = CreateFrame("StatusBar", nil, UIParent)
ATCB.castbar:SetStatusBarTexture("Interface\\addons\\asTargetCastBar\\UI-StatusBar.blp", "BORDER")
ATCB.castbar:GetStatusBarTexture():SetHorizTile(false)
ATCB.castbar:SetMinMaxValues(0, 100)
ATCB.castbar:SetValue(100)
ATCB.castbar:SetHeight(ATCB_HEIGHT)
ATCB.castbar:SetWidth(ATCB_WIDTH - ATCB_HEIGHT/2)
ATCB.castbar:SetStatusBarColor(1, 0.9, 0.9);
ATCB.castbar:SetAlpha(ATCB_ALPHA);

ATCB.castbar.bg = ATCB.castbar:CreateTexture(nil, "BACKGROUND")
ATCB.castbar.bg:SetPoint("TOPLEFT", ATCB.castbar, "TOPLEFT", -1, 1)
ATCB.castbar.bg:SetPoint("BOTTOMRIGHT", ATCB.castbar, "BOTTOMRIGHT", 1, -1)

ATCB.castbar.bg:SetTexture("Interface\\Addons\\asTargetCastBar\\border.tga")
ATCB.castbar.bg:SetTexCoord(0.1,0.1, 0.1,0.1, 0.1,0.1, 0.1,0.1)	
ATCB.castbar.bg:SetVertexColor(0, 0, 0, 0.8);
ATCB.castbar.bg:Show();

ATCB.castbar.name = ATCB.castbar:CreateFontString( nil , "OVERLAY");
ATCB.castbar.name:SetFont(STANDARD_TEXT_FONT, ATCB_NAME_SIZE);
ATCB.castbar.name:SetPoint("LEFT", ATCB.castbar, "LEFT", 3, 0);

ATCB.castbar.time = ATCB.castbar:CreateFontString( nil , "OVERLAY");
ATCB.castbar.time:SetFont(STANDARD_TEXT_FONT, ATCB_TIME_SIZE);
ATCB.castbar.time:SetPoint("RIGHT", ATCB.castbar, "RIGHT", -3, 0);

ATCB.castbar:SetPoint("CENTER",UIParent,"CENTER", ATCB_X + ATCB_HEIGHT/2, ATCB_Y)
ATCB.castbar:Hide();

ATCB.button = CreateFrame("Button", nil, ATCB.castbar, "ATCBFrameTemplate");
ATCB.button:SetPoint("RIGHT", ATCB.castbar,"LEFT", -1, 0)
ATCB.button:SetWidth((ATCB_HEIGHT + 2) * 1.2);
ATCB.button:SetHeight(ATCB_HEIGHT + 2);
ATCB.button:SetScale(1);
ATCB.button:SetAlpha(1);
ATCB.button:EnableMouse(false);
ATCB.button.icon:SetTexCoord(.08, .92, .08, .92);
ATCB.button.border:SetTexCoord(0.08,0.08, 0.08,0.92, 0.92,0.08, 0.92,0.92);
ATCB.button.border:SetVertexColor(0, 0, 0);
ATCB.button.border:Show();
ATCB.button:Show();

ATCB.start = 0;
ATCB.duration = 0;


LoadAddOn("asMOD");

if asMOD_setupFrame then
    asMOD_setupFrame (ATCB.castbar, "asTargetCastBar");
end

local function ATCB_OnEvent(self, event, ...)

	if event == "PLAYER_TARGET_CHANGED" or event == "PLAYER_ENTERING_WORLD" then
		
		if UnitExists("target") then
			ATCB:RegisterUnitEvent("UNIT_SPELLCAST_SUCCEEDED", "target");
			ATCB:RegisterUnitEvent("UNIT_SPELLCAST_INTERRUPTED", "target");
			ATCB:RegisterUnitEvent("UNIT_SPELLCAST_START", "target");
			ATCB:RegisterUnitEvent("UNIT_SPELLCAST_DELAYED", "target");
			ATCB:RegisterUnitEvent("UNIT_SPELLCAST_CHANNEL_START", "target");
			ATCB:RegisterUnitEvent("UNIT_SPELLCAST_CHANNEL_STOP", "target");
			ATCB:RegisterUnitEvent("UNIT_SPELLCAST_STOP", "target");
		else
			ATCB:UnregisterEvent("UNIT_SPELLCAST_SUCCEEDED");
			ATCB:UnregisterEvent("UNIT_SPELLCAST_INTERRUPTED");
			ATCB:UnregisterEvent("UNIT_SPELLCAST_START");
			ATCB:UnregisterEvent("UNIT_SPELLCAST_DELAYED");
			ATCB:UnregisterEvent("UNIT_SPELLCAST_CHANNEL_START");
			ATCB:UnregisterEvent("UNIT_SPELLCAST_CHANNEL_STOP");
			ATCB:UnregisterEvent("UNIT_SPELLCAST_STOP");
		end	
	end

		local name,  _, texture, start, endTime, isTradeSkill, castID, notInterruptible, spellid = UnitCastingInfo("target");

		if not name then
			name,  _, texture, start, endTime, isTradeSkill, notInterruptible, spellid = UnitChannelInfo("target");
		end
		
		local frameIcon = self.button.icon; 
		local castBar = self.castbar;
		local text  = self.castbar.name;
		local time = self.castbar.time;
		
		if name then
			local current = GetTime();
			frameIcon:SetTexture(texture);

			self.start = start / 1000;
			self.duration = (endTime - start) /1000;
			castBar:SetMinMaxValues(0, self.duration)
			castBar:SetValue(current - self.start);

			local color = {};

			if UnitIsUnit("targettarget", "player") then
				if notInterruptible then
					color = ATCB_NOT_INTERRUPTIBLE_COLOR_TARGET;
				else
					color = ATCB_INTERRUPTIBLE_COLOR_TARGET;
				end

			else
				if notInterruptible then
					color = ATCB_NOT_INTERRUPTIBLE_COLOR;
				else
					color = ATCB_INTERRUPTIBLE_COLOR;
				end

			end

			castBar:SetStatusBarColor(color[1], color[2], color[3]);
						
			text:SetText(name);
			time:SetText(format("%.1f/%.1f", max((current - self.start), 0), max(self.duration, 0)));
			
			frameIcon:Show();			
			castBar:Show();
					
		else
			castBar:SetValue(0);
			frameIcon:Hide();
			castBar:Hide();
			self.start = 0;
		end
end


local function ATCB_OnUpdate()

	local start = ATCB.start;

	if start > 0 then
		local castBar = ATCB.castbar;
		local duration = ATCB.duration;
		local current = GetTime();
		local time = ATCB.castbar.time;
		castBar:SetValue((current - start));
		time:SetText(format("%.1f/%.1f", max((current - start), 0), max(duration, 0)));
	end
	
end

ATCB:SetScript("OnEvent", ATCB_OnEvent)
ATCB:RegisterEvent("PLAYER_TARGET_CHANGED");
ATCB:RegisterEvent("PLAYER_ENTERING_WORLD");

C_Timer.NewTicker(ATCB_UPDATE_RATE, ATCB_OnUpdate);