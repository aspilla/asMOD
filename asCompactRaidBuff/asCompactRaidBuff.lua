local ACRB_Size = 0; 					-- Buff 아이콘 증가 크기
local ACRB_CooldownFontSize = 9; 		-- 쿨다운 폰트 사이즈
local ACRB_BuffSizeRate = 1;			-- 기존 Size 크기 배수 
local ACRB_ShowBuffCooldown = false		-- 버프 지속시간을 보이려면
local ACRB_MinShowBuffFontSize = 5 		-- 이크기보다 Cooldown font Size 가 작으면 안보이게 한다. 무조건 보이게 하려면 0
local ACRB_CooldownFontSizeRate = 0.5 	-- 버프 Size 대비 쿨다운 폰트 사이즈 
local ACRB_MAX_BUFFS = 6			  	-- 최대 표시 버프 개수 (3개 + 3개)
local ACRB_MAX_BUFFS_2 = 2				-- 최대 생존기 개수
local ACRB_MAX_DEBUFFS = 3				-- 최대 표시 디버프 개수 (3개)
local ACRB_MAX_DISPELDEBUFFS = 3		-- 최대 해제 디버프 개수 (3개)
local ACRB_ShowListFirst = true			-- 알림 List 항목을 먼저 보임 (가나다 순, 같은 디법이 여러게 걸리는 경우 1개만 보일 수 있음 ex 불고)
local ACRB_ShowAlert = true				-- HOT 리필 시 알림
local ACRB_MaxBuffSize = 20				-- 최대 Buff Size 창을 늘려도 이 크기 이상은 안커짐
local ACRB_HealerManaBarHeight = 1		-- 힐러 마나바 크기 (안보이게 하려면 0)
local ACRB_UpdateRate = (0.1)			-- 1회 Update 주기 (초) 작으면 작을 수록 Frame Rate 감소 가능, 크면 Update 가 느림
local ACRB_ShowWhenSolo = true			-- Solo Raid Frame 사용시 보이게 하려면 True (반드시 Solo Raid Frame과 사용)
local ACRB_ShowTooltip = true			-- GameTooltip을 보이게 하려면 True
local ACRB_RangeFilterColor = {r = 0.3, g = 0.3, b = 0.3}; --30m 이상 RangeFilter Color
local ACRB_RangeFilterAlpha = 0.5


-- 버프 남은시간에 리필 알림
-- 두번째 숫자는 표시 위치, 4(우상) 5(우중) 6(상) 1,2,3 은 우하에 보이는 우선 순위이다.
ACRB_ShowList_MONK_2 = {
	["포용의 안개"] = {6 * 0.3, 1},
	["소생의 안개"] = {20 * 0.3, 4}


}

-- 신기
ACRB_ShowList_PALADIN_1 = {
	["빛의 봉화"] = {0, 4},	
	["신념의 봉화"] = {0, 5},	
}

-- 수사
ACRB_ShowList_PRIEST_1 = {
	["속죄"] = {3, 4},	
	["신의 권능: 보호막"] = {15 * 0.3, 1}

}


-- 신사
ACRB_ShowList_PRIEST_2 = {
	["소생"] = {15 * 0.3, 4},	
	["회복의 기원"] = {0, 1},	

}


ACRB_ShowList_SHAMAN_3 = {
	["성난 해일"] = {15 * 0.3, 1},	
}


ACRB_ShowList_DRUID_4 = {
	["회복"] = {15 * 0.3, 4},
	["재생"] = {12 * 0.3, 5},
	["피어나는 생명"] = {15 * 0.3, 6},
	["회복 (싹틔우기)"] = {15 * 0.3, 2},
	["세나리온 수호물"] = {0, 1},
	

}

ACRB_ShowList_EVOKER_2 = {
	["메아리"] = {0, 4},

}


-- 안보이게 할 디법
local ACRB_BlackList = {
	["도전자의 짐"] = 1,	
}


-- 해제 알림 스킬
local ACRB_DispelAlertList = {
	--["탈진"] = 1,	
}



--직업별 생존기 등록 (1분이상 쿨다운), 용군단 Version
local ACRB_PVPBuffList = {

	[236273] = true, --WARRIOR
	[118038] = true, --WARRIOR
	[12975] = true, --WARRIOR
	[871] = true, --WARRIOR
	[97463] = true, --WARRIOR
	[383762] = true, --WARRIOR
	[184364] = true, --WARRIOR
	[386394] = true, --WARRIOR
	[392966] = true, --WARRIOR
	[11327] = true, --ROGUE
	[31224] = true, --ROGUE
	[31230] = true, --ROGUE
	[5277] = true, --ROGUE
	[212800] = true, --DEMONHUNTER
	[187827] = true, --DEMONHUNTER
	[206803] = true, --DEMONHUNTER
	[196555] = true, --DEMONHUNTER
	[204021] = true, --DEMONHUNTER
	[209258] = true, --DEMONHUNTER
	[209426] = true, --DEMONHUNTER
	[388615] = true, --MONK
	[115310] = true, --MONK
	[116849] = true, --MONK
	[115399] = true, --MONK
	[120954] = true, --MONK
	[122783] = true, --MONK
	[122278] = true, --MONK
	[132578] = true, --MONK
	[115176] = true, --MONK
	[51052] = true, --DEATHKNIGHT
	[48707] = true, --DEATHKNIGHT
	[327574] = true, --DEATHKNIGHT
	[48743] = true, --DEATHKNIGHT
	[48792] = true, --DEATHKNIGHT
	[114556] = true, --DEATHKNIGHT
	[81256] = true, --DEATHKNIGHT
	[219809] = true, --DEATHKNIGHT
	[55233] = true, --DEATHKNIGHT
	[53480] = true, --HUNTER
	[109304] = true, --HUNTER
	[264735] = true, --HUNTER
	[370960] = true, --EVOKER
	[363534] = true, --EVOKER
	[357170] = true, --EVOKER
	[374348] = true, --EVOKER
	[374227] = true, --EVOKER
	[363916] = true, --EVOKER
	[354654] = true, --DRUID
	[22812] = true, --DRUID
	[157982] = true, --DRUID
	[102342] = true, --DRUID
	[61336] = true, --DRUID
	[200851] = true, --DRUID
	[108238] = true, --DRUID
	[124974] = true, --DRUID
	[104773] = true, --WARLOCK
	[108416] = true, --WARLOCK
	[215769] = true, --PRIEST
	[328530] = true, --PRIEST
	[197268] = true, --PRIEST
	[19236] = true, --PRIEST
	[81782] = true, --PRIEST
	[33206] = true, --PRIEST
	[372835] = true, --PRIEST
	[391124] = true, --PRIEST
	[265202] = true, --PRIEST
	[64843] = true, --PRIEST
	[47788] = true, --PRIEST
	[47585] = true, --PRIEST
	[108968] = true, --PRIEST
	[15286] = true, --PRIEST
	[199452] = true, --PALADIN
	[31850] = true, --PALADIN
	[378974] = true, --PALADIN
	[86659] = true, --PALADIN
	[387174] = true, --PALADIN
	[327193] = true, --PALADIN
	[205191] = true, --PALADIN
	[184662] = true, --PALADIN
	[157047] = true, --PALADIN
	[31821] = true, --PALADIN
	[633] = true, --PALADIN
	[6940] = true, --PALADIN
	[1022] = true, --PALADIN
	[204018] = true, --PALADIN
	[210918] = true, --SHAMAN
	[108280] = true, --SHAMAN
	[98008] = true, --SHAMAN
	[198838] = true, --SHAMAN
	[207399] = true, --SHAMAN
	[108271] = true, --SHAMAN
	[198103] = true, --SHAMAN
	[108281] = true, --SHAMAN
	[198158] = true, --MAGE
	[110959] = true, --MAGE
	[342246] = true, --MAGE
	[66] = true, --MAGE
	[55342] = true, --MAGE
	[235219] = true, --MAGE
	[86949] = true, --MAGE
	[125174] = true, --MONK
	[186265] = true, --HUNTER
	[378441] = true, --EVOKER
	[228049] = true, --PALADIN
	[642] = true, --PALADIN
	[45438] = true, --MAGE

}

-- 직업 리필 
local ACRB_ShowList = nil;
local ACRB_baseSize = 0;
local show_30m_range = false;

local asraid = {};


local function ACRB_InitList()

	local spec = GetSpecialization();
	local localizedClass, englishClass = UnitClass("player")
	local listname;

	ACRB_ShowList = nil;

	if spec then
		listname = "ACRB_ShowList_" .. englishClass .. "_" .. spec;
	end

	ACRB_ShowList = _G[listname];

	--기원사 힐이면 30미터 Filter 추가
	if englishClass == "EVOKER" and spec == 2 then
		show_30m_range = true;
	end

end

local BOSS_DEBUFF_SIZE_INCREASE = 5;

--Overlay stuff
local unusedOverlayGlows = {};
local numOverlays = 0;
local function ACRB_ActionButton_GetOverlayGlow()
	local overlay = tremove(unusedOverlayGlows);
	if ( not overlay ) then
		numOverlays = numOverlays + 1;
		overlay = CreateFrame("Frame", nil, UIParent, "ACRB_ActionBarButtonSpellActivationAlert");
	end
	return overlay;
end

-- Shared between action button and MainMenuBarMicroButton
local function ACRB_ShowOverlayGlow(button, bhideflash)
	if ( button.overlay ) then
		button.overlay.bhideflash = bhideflash;
		if ( button.overlay.animOut:IsPlaying() ) then
			button.overlay.animOut:Stop();
			button.overlay.animIn:Play();
		end
	else
		button.overlay = ACRB_ActionButton_GetOverlayGlow();
		local frameWidth, frameHeight = button:GetSize();
		button.overlay:SetParent(button);
		button.overlay:ClearAllPoints();
		--Make the height/width available before the next frame:
		button.overlay:SetSize(frameWidth * 1.4, frameHeight * 1.4);
		button.overlay:SetPoint("TOPLEFT", button, "TOPLEFT", -frameWidth * 0.3, frameHeight * 0.3);
		button.overlay:SetPoint("BOTTOMRIGHT", button, "BOTTOMRIGHT", frameWidth * 0.3, -frameHeight * 0.3);
		button.overlay.bhideflash = bhideflash;
		button.overlay.animIn:Play();
	end
end
-- Shared between action button and MainMenuBarMicroButton
local function ACRB_HideOverlayGlow(button)
	if ( button.overlay ) then
		if ( button.overlay.animIn:IsPlaying() ) then
			button.overlay.animIn:Stop();
		end
		if ( button:IsVisible() ) then
			button.overlay.animOut:Play();
		else
			button.overlay.animOut:OnFinished();	--We aren't shown anyway, so we'll instantly hide it.
		end
	end
end

ACRB_ActionBarButtonSpellActivationAlertMixin = {};

function ACRB_ActionBarButtonSpellActivationAlertMixin:OnUpdate(elapsed)
	AnimateTexCoords(self.ants, 256, 256, 48, 48, 22, elapsed, 0.01);
	local cooldown = self:GetParent().cooldown;
	-- we need some threshold to avoid dimming the glow during the gdc
	-- (using 1500 exactly seems risky, what if casting speed is slowed or something?)
	if(cooldown and cooldown:IsShown() and cooldown:GetCooldownDuration() > 3000) then
		self:SetAlpha(0.5);
		else
		self:SetAlpha(1.0);
		end
	end

function ACRB_ActionBarButtonSpellActivationAlertMixin:OnHide()
	if ( self.animOut:IsPlaying() ) then
		self.animOut:Stop();
		self.animOut:OnFinished();
	end
end

ACRB_ActionBarOverlayGlowAnimInMixin = {};

function ACRB_ActionBarOverlayGlowAnimInMixin:OnPlay()
	local frame = self:GetParent();
	local frameWidth, frameHeight = frame:GetSize();
	frame.spark:SetSize(frameWidth, frameHeight);
	frame.spark:SetAlpha(0);
	frame.innerGlow:SetSize(frameWidth, frameHeight);
	frame.innerGlow:SetAlpha(1);
	frame.innerGlowOver:SetAlpha(1);
	frame.outerGlow:SetSize(frameWidth, frameHeight);
	frame.outerGlow:SetAlpha(1);
	frame.outerGlowOver:SetAlpha(1);
	frame.ants:SetSize(frameWidth * 0.8, frameHeight * 0.8)
	frame.ants:SetAlpha(0);

	if frame.bhideflash then
		frame.spark:SetAlpha(0.3);
		frame.innerGlow:SetAlpha(0);
		frame.innerGlowOver:SetAlpha(0);
		frame.outerGlow:SetAlpha(0);
		frame.outerGlowOver:SetAlpha(0);
	end
	frame:Show();
end

function ACRB_ActionBarOverlayGlowAnimInMixin:OnFinished()
	local frame = self:GetParent();
	local frameWidth, frameHeight = frame:GetSize();
	frame.spark:SetAlpha(0);
	frame.innerGlow:SetAlpha(0);
	frame.innerGlow:SetSize(frameWidth, frameHeight);
	frame.innerGlowOver:SetAlpha(0.0);
	frame.outerGlow:SetSize(frameWidth, frameHeight);
	frame.outerGlowOver:SetAlpha(0.0);
	frame.outerGlowOver:SetSize(frameWidth, frameHeight);
	frame.ants:SetAlpha(1.0);
end

ACRB_ActionBarOverlayGlowAnimOutMixin = {};

function ACRB_ActionBarOverlayGlowAnimOutMixin:OnFinished()
	local overlay = self:GetParent();
	local actionButton = overlay:GetParent();
	overlay:Hide();
	tinsert(unusedOverlayGlows, overlay);
	actionButton.overlay = nil;
end


local function asCooldownFrame_Clear(self)
	self:Clear();
end
--cooldown
local function asCooldownFrame_Set(self, start, duration, enable, forceShowDrawEdge, modRate)
	if enable and enable ~= 0 and start > 0 and duration > 0 then
		self:SetDrawEdge(forceShowDrawEdge);
		self:SetCooldown(start, duration, modRate);
	else
		asCooldownFrame_Clear(self);
	end
end



-- Setup
local function ACRB_setupFrame(frame)
	if not frame or frame:IsForbidden() or not frame.displayedUnit or not UnitIsPlayer(frame.displayedUnit)  then 
		return 
	end

	local frameName = frame:GetName()

	if asraid[frameName] == nil then
		asraid[frameName] = {};
		--크기 조정을 위해 아래 코드를 돌린다.
	end

	asraid[frameName].displayedUnit = frame.displayedUnit;
	asraid[frameName].frame = frame;

	local CUF_AURA_BOTTOM_OFFSET = 2;
	local CUF_NAME_SECTION_SIZE = 15;

	local frameHeight = EditModeManagerFrame:GetRaidFrameHeight(frame.isParty);
	local options = DefaultCompactUnitFrameSetupOptions;
	local powerBarHeight = 8;
	local powerBarUsedHeight = options.displayPowerBar and powerBarHeight or 0;


	local x, y = frame:GetSize();

	y = y - powerBarUsedHeight;

	local baseSize = math.min(x/7 * ACRB_BuffSizeRate,y/3 * ACRB_BuffSizeRate) ;

	if baseSize > ACRB_MaxBuffSize then
		baseSize = ACRB_MaxBuffSize
	end

	local fontsize = baseSize * ACRB_CooldownFontSizeRate;

	-- 힐거리 기능
	if not asraid[frameName].rangetex then 
		asraid[frameName].rangetex = frame:CreateTexture(nil, "ARTWORK");
    	asraid[frameName].rangetex:SetAllPoints();
    	asraid[frameName].rangetex:SetColorTexture(ACRB_RangeFilterColor.r, ACRB_RangeFilterColor.g, ACRB_RangeFilterColor.b); 
		asraid[frameName].rangetex:SetAlpha(ACRB_RangeFilterAlpha);
		asraid[frameName].rangetex:Hide();				
	end

	if not asraid[frameName].asbuffFrames then
		asraid[frameName].asbuffFrames = {}
		for i = 1, ACRB_MAX_BUFFS do
			local buffFrame = CreateFrame("Button", nil, frame, "asCompactBuffTemplate")
			buffFrame.icon:SetTexCoord(.08, .92, .08, .92);
			buffFrame:ClearAllPoints()
			buffFrame:EnableMouse(ACRB_ShowTooltip); 

			if i <= ACRB_MAX_BUFFS - 3 then
				if math.fmod(i - 1, 3) == 0 then
					if i == 1 then
						local buffPos, buffRelativePoint, buffOffset = "BOTTOMRIGHT", "BOTTOMLEFT", CUF_AURA_BOTTOM_OFFSET + powerBarUsedHeight;
						buffFrame:ClearAllPoints();
						buffFrame:SetPoint(buffPos, frame, "BOTTOMRIGHT", -2, buffOffset);
					else
						buffFrame:SetPoint("BOTTOMRIGHT",asraid[frameName].asbuffFrames[i-3], "TOPRIGHT", 0, 2)
					end
				else
					buffFrame:SetPoint("BOTTOMRIGHT", asraid[frameName].asbuffFrames[i-1], "BOTTOMLEFT", -2, 0)
				end
			else
				-- 3개는 따로 뺀다.
				if i == ACRB_MAX_BUFFS - 2 then
					-- 우상
					buffFrame:ClearAllPoints();
					buffFrame:SetPoint("TOPRIGHT", frame, "TOPRIGHT", -2, -2);
				elseif i == ACRB_MAX_BUFFS - 1 then
					-- 우중
					buffFrame:ClearAllPoints();
					buffFrame:SetPoint("RIGHT", frame, "RIGHT", -2, 0);
				else
					-- 상
					buffFrame:ClearAllPoints();
					buffFrame:SetPoint("TOP", frame, "TOP", 0, -2);
				end
			end

			buffFrame.border:SetTexture("Interface\\Addons\\asCompactRaidBuff\\border.tga");
			buffFrame.border:SetTexCoord(0.08,0.08, 0.08,0.92, 0.92,0.08, 0.92,0.92);
			if ACRB_ShowTooltip and not buffFrame:GetScript("OnEnter") then
				buffFrame:SetScript("OnEnter", function(s)
					if s:GetID() > 0 then
						GameTooltip:SetOwner(s, "ANCHOR_BOTTOMRIGHT");
						GameTooltip:SetUnitBuff(s.unit, s:GetID(), s.filter);
					end
				end)
				buffFrame:SetScript("OnLeave", function()
					GameTooltip:Hide();
				end)
			end

			asraid[frameName].asbuffFrames[i] = buffFrame;
			ACRB_HideOverlayGlow(buffFrame);
			buffFrame:Hide();
		end		
	end

	--크기 조정
	for _,d in ipairs(asraid[frameName].asbuffFrames) do
		d:SetSize(baseSize * 1.2, baseSize * 0.9);

		d.count:SetFont(STANDARD_TEXT_FONT, fontsize ,"OUTLINE")
		d.count:ClearAllPoints();
		d.count:SetPoint("BOTTOM", 0, 1);
		if  ACRB_ShowBuffCooldown and fontsize >= ACRB_MinShowBuffFontSize   then
			   d.cooldown:SetHideCountdownNumbers(false);
			for _,r in next,{d.cooldown:GetRegions()}	do 
				if r:GetObjectType()=="FontString" then 
					r:SetFont(STANDARD_TEXT_FONT,fontsize,"OUTLINE")
					r:ClearAllPoints();
					r:SetPoint("TOP", 0, 2);
					break 
				end 
			end
		end
	end

	if not asraid[frameName].asdebuffFrames then
		asraid[frameName].asdebuffFrames = {};
		for i = 1, ACRB_MAX_DEBUFFS do
			local debuffFrame = CreateFrame("Button", nil, frame, "asCompactDebuffTemplate")
			debuffFrame:ClearAllPoints()
			debuffFrame:EnableMouse(ACRB_ShowTooltip); 
			debuffFrame.icon:SetTexCoord(.08, .92, .08, .92);
			if math.fmod(i - 1, 3) == 0 then
				if i == 1 then
					local debuffPos, debuffRelativePoint, debuffOffset = "BOTTOMLEFT", "BOTTOMRIGHT", CUF_AURA_BOTTOM_OFFSET + powerBarUsedHeight;
					debuffFrame:ClearAllPoints();
					debuffFrame:SetPoint(debuffPos, frame, "BOTTOMLEFT", 3, debuffOffset);
				else
					debuffFrame:SetPoint("BOTTOMLEFT",asraid[frameName].asdebuffFrames[i-3], "TOPLEFT", 0, 2)
				end
			else
				debuffFrame:SetPoint("BOTTOMLEFT", asraid[frameName].asdebuffFrames[i-1], "BOTTOMRIGHT", 2, 0)
			end
	
			debuffFrame.border:SetTexture("Interface\\Addons\\asCompactRaidBuff\\border.tga");
			debuffFrame.border:SetTexCoord(0.08,0.08, 0.08,0.92, 0.92,0.08, 0.92,0.92);
	
			if ACRB_ShowTooltip and not debuffFrame:GetScript("OnEnter") then
				debuffFrame:SetScript("OnEnter", function(s)
					if s:GetID() > 0 then
						GameTooltip:SetOwner(s, "ANCHOR_BOTTOMRIGHT");
						GameTooltip:SetUnitDebuff(s.unit, s:GetID(), s.filter);
					end
				end)
	
				debuffFrame:SetScript("OnLeave", function()
					GameTooltip:Hide();
				end)
			end
	
			asraid[frameName].asdebuffFrames[i] = debuffFrame;
			debuffFrame:Hide();
		end				
	end

	for _,d in ipairs(asraid[frameName].asdebuffFrames) do
		d.baseSize = baseSize     -- 디버프
		d.maxHeight = frameHeight - powerBarUsedHeight - CUF_AURA_BOTTOM_OFFSET - CUF_NAME_SECTION_SIZE;
		d.count:SetFont(STANDARD_TEXT_FONT, fontsize,"OUTLINE")
		d.count:ClearAllPoints();
		d.count:SetPoint("BOTTOM", 0, 1);

		if  ACRB_ShowBuffCooldown and fontsize >= ACRB_MinShowBuffFontSize   then
				d.cooldown:SetHideCountdownNumbers(false);
			for _,r in next,{d.cooldown:GetRegions()}	do 
				if r:GetObjectType()=="FontString" then 
					r:SetFont(STANDARD_TEXT_FONT,fontsize,"OUTLINE");
					r:ClearAllPoints();
					r:SetPoint("TOP", 0, 2);
					break 
				end 
			end
		end
	end


	if not asraid[frameName].asdispelDebuffFrames then
		asraid[frameName].asdispelDebuffFrames = {};
		for i=1, ACRB_MAX_DISPELDEBUFFS do
			local dispelDebuffFrame =  CreateFrame("Button", nil, frame, "asCompactDispelDebuffTemplate")
			dispelDebuffFrame:EnableMouse(false); 
			asraid[frameName].asdispelDebuffFrames[i] = dispelDebuffFrame;
			dispelDebuffFrame:Hide();
		end	
	end

	asraid[frameName].asdispelDebuffFrames[1]:SetPoint("RIGHT", asraid[frameName].asbuffFrames[(ACRB_MAX_BUFFS - 2)],  "LEFT", -1, 0);
	for i=1, ACRB_MAX_DISPELDEBUFFS do
		if ( i > 1 ) then
			asraid[frameName].asdispelDebuffFrames[i]:SetPoint("RIGHT", asraid[frameName].asdispelDebuffFrames[i - 1], "LEFT", 0, 0);
		end
		asraid[frameName].asdispelDebuffFrames[i]:SetSize(baseSize, baseSize);
	end

	if not asraid[frameName].asDispelBorder then
		asraid[frameName].asDispelBorder = frame:CreateTexture(nil,"BACKGROUND")
		asraid[frameName].asDispelBorder:SetTexture("Interface\\AddOns\\asCompactRaidBuff\\border.tga");
		asraid[frameName].asDispelBorder:SetTexCoord(0.08,0.08, 0.08,0.92, 0.92,0.08, 0.92,0.92);	
		asraid[frameName].asDispelBorder:SetPoint("TOPLEFT",0 , 0);
		asraid[frameName].asDispelBorder:SetPoint("BOTTOMRIGHT", 0, 0);
		asraid[frameName].asDispelBorder:Hide();
	end

	if (not asraid[frameName].asManabar and not frame.powerBar:IsShown()) then
		asraid[frameName].asManabar =   CreateFrame("StatusBar", nil, frame.healthBar)
		asraid[frameName].asManabar:SetStatusBarTexture("Interface\\TARGETINGFRAME\\UI-StatusBar")
		asraid[frameName].asManabar:GetStatusBarTexture():SetHorizTile(false)
		asraid[frameName].asManabar:SetMinMaxValues(0, 100)
		asraid[frameName].asManabar:SetValue(100)
		asraid[frameName].asManabar:SetPoint("BOTTOM",frame.healthBar,"BOTTOM", 0, 0)
		asraid[frameName].asManabar:Hide();
	end

	if asraid[frameName].asManabar then
		asraid[frameName].asManabar:SetWidth(x-2);
		asraid[frameName].asManabar:SetHeight(ACRB_HealerManaBarHeight)
	end

	if (not asraid[frameName].asraidicon) then
		asraid[frameName].asraidicon =   frame:CreateFontString( nil , "OVERLAY")
		asraid[frameName].asraidicon:SetFont(STANDARD_TEXT_FONT, fontsize * 2)
		asraid[frameName].asraidicon:SetPoint("LEFT", frame.healthBar, "LEFT", 2, 0)
		asraid[frameName].asraidicon:Hide();
	end

	asraid[frameName].asraidicon:SetFont(STANDARD_TEXT_FONT, fontsize * 2);

	if (not asraid[frameName].buffFrames2) then
		asraid[frameName].buffFrames2 = {};

		for i = 1, ACRB_MAX_BUFFS_2 do
			asraid[frameName].buffFrames2[i] =  CreateFrame("Button", nil, frame, "asCompactBuffTemplate")
			asraid[frameName].buffFrames2[i]:EnableMouse(ACRB_ShowTooltip); 
			asraid[frameName].buffFrames2[i].icon:SetTexCoord(.08, .92, .08, .92);
			asraid[frameName].buffFrames2[i]:SetSize(baseSize * 1.2, baseSize * 0.9);
			asraid[frameName].buffFrames2[i].baseSize = baseSize;
			asraid[frameName].buffFrames2[i].count:SetFont(STANDARD_TEXT_FONT, fontsize, "OUTLINE");
			asraid[frameName].buffFrames2[i].count:ClearAllPoints();
			asraid[frameName].buffFrames2[i].count:SetPoint("BOTTOM", 0, 0);
			asraid[frameName].buffFrames2[i]:Hide();

			if  ACRB_ShowBuffCooldown and fontsize >= ACRB_MinShowBuffFontSize   then
				asraid[frameName].buffFrames2[i].cooldown:SetHideCountdownNumbers(false);
				for _,r in next,{asraid[frameName].buffFrames2[i].cooldown:GetRegions()}	do 
					if r:GetObjectType()=="FontString" then 
						r:SetFont(STANDARD_TEXT_FONT,fontsize,"OUTLINE");
						r:ClearAllPoints();
						r:SetPoint("TOP", 0, 2);
						break 
					end 
				end
			else
				asraid[frameName].buffFrames2[i].cooldown:SetHideCountdownNumbers(true);
			end
			asraid[frameName].buffFrames2[i]:ClearAllPoints()
			if i == 1 then
				asraid[frameName].buffFrames2[i]:SetPoint("CENTER", frame.healthBar, "CENTER", 0, 0)
			else
				asraid[frameName].buffFrames2[i]:SetPoint("TOPLEFT", asraid[frameName].buffFrames2[i-1], "TOPRIGHT", 0, 0)
			end

			if ACRB_ShowTooltip and not asraid[frameName].buffFrames2[i]:GetScript("OnEnter") then
				asraid[frameName].buffFrames2[i]:SetScript("OnEnter", function(s)
					if s:GetID() > 0 then
						GameTooltip:SetOwner(s, "ANCHOR_BOTTOMRIGHT");
						GameTooltip:SetUnitBuff(s.unit, s:GetID(), s.filter);
					end
				end)

				asraid[frameName].buffFrames2[i]:SetScript("OnLeave", function()
					GameTooltip:Hide();
				end)
			end

		end
	end

	if (asraid[frameName].buffFrames2) then
		for i = 1, ACRB_MAX_BUFFS_2 do
			asraid[frameName].buffFrames2[i]:SetSize(baseSize * 1.2, baseSize * 0.9);
			asraid[frameName].buffFrames2[i].baseSize = baseSize;
			asraid[frameName].buffFrames2[i].count:SetFont(STANDARD_TEXT_FONT, fontsize, "OUTLINE");
		end
	end
end

-- 버프 설정 부
local function asCompactUnitFrame_UtilShouldDisplayBuff_buff(unit, index, filter)
	local name,  icon, count, debuffType, duration, expirationTime, unitCaster, canStealOrPurge, _, spellId, canApplyAura = UnitBuff(unit, index, filter);

	if ACRB_BlackList and ACRB_BlackList[name] then
		return false;
	end

	if ACRB_ShowListFirst and ACRB_ShowList and ACRB_ShowList[name] then
		return false;
	end
	
	local hasCustom, alwaysShowMine, showForMySpec = SpellGetVisibilityInfo(spellId, UnitAffectingCombat("player") and "RAID_INCOMBAT" or "RAID_OUTOFCOMBAT");
	
	if ( hasCustom ) then
		return showForMySpec or (alwaysShowMine and (unitCaster == "player" or unitCaster == "pet" or unitCaster == "vehicle"));
	else
		return (unitCaster == "player" or unitCaster == "pet" or unitCaster == "vehicle") and canApplyAura and not SpellIsSelfBuff(spellId);
	end
end

local function asCompactUnitFrame_UtilIsBossAura(unit, index, filter, checkAsBuff)
	-- make sure you are using the correct index here!	allAurasIndex ~= debuffIndex
	local name,  icon, count, debuffType, duration, expirationTime, unitCaster, canStealOrPurge, _, spellId, canApplyAura, isBossAura;
	if (checkAsBuff) then
		name,  icon, count, debuffType, duration, expirationTime, unitCaster, canStealOrPurge, _, spellId, canApplyAura, isBossAura = UnitBuff(unit, index, filter);
	else
		name,  icon, count, debuffType, duration, expirationTime, unitCaster, canStealOrPurge, _, spellId, canApplyAura, isBossAura = UnitDebuff(unit, index, filter);
	end
	return isBossAura;
end

local function asCompactUnitFrame_UtilSetDispelDebuff(dispellDebuffFrame, debuffType, index)
	dispellDebuffFrame:Show();
	dispellDebuffFrame.icon:SetTexture("Interface\\RaidFrame\\Raid-Icon-Debuff"..debuffType);
	dispellDebuffFrame:SetID(index);
end




local function asCompactUnitFrame_UtilSetBuff2(buffFrame, unit, index, filter)
	local name,  icon, count, debuffType, duration, expirationTime, unitCaster, canStealOrPurge, _, spellId, canApplyAura = UnitBuff(unit, index, filter);
	buffFrame.icon:SetTexture(icon);
	if ( count > 1 ) then
		local countText = count;
		if ( count >= 100 ) then
			countText = BUFF_STACKS_OVERFLOW;
		end
		buffFrame.count:Show();
		buffFrame.count:SetText(countText);
	else
		buffFrame.count:Hide();
	end
	buffFrame:SetID(index);
	buffFrame.unit = unit;
	buffFrame.filter = filter;
	local enabled = expirationTime and expirationTime ~= 0;
	if enabled then
		local startTime = expirationTime - duration;
		asCooldownFrame_Set(buffFrame.cooldown, startTime, duration, true);

		if ACRB_ShowList and  ACRB_ShowAlert then
			local showlist_time = 0;

			if ACRB_ShowList[name]  then
				showlist_time = ACRB_ShowList[name][1];
			end

			if expirationTime - GetTime() < showlist_time then
				buffFrame.border:SetVertexColor(1, 1, 1);
				buffFrame.border:Show();
			else
				buffFrame.border:Hide();
			end
		else
			buffFrame.border:Hide();
		end
	else
		buffFrame.border:Hide()
		asCooldownFrame_Clear(buffFrame.cooldown);
	end
	buffFrame:Show();
end

local function Comparison(AIndex, BIndex)



	local AID = AIndex[2];
	local BID = BIndex[2];

	if (AID ~= BID) then
		return AID > BID;
	end

	return false;
end


local function asCompactUnitFrame_UpdateBuffs(frame)

	if ( not frame.asbuffFrames ) then
		return;
	end

	local unit = frame.displayedUnit

	if not (unit) then
		return;
	end
	
	if frame.rangetex and not UnitIsUnit("player", unit)then

		local inRange, checkedRange = UnitInRange(unit);
		--40미터 밖
		if ( checkedRange and not inRange ) then	--If we weren't able to check the range for some reason, we'll just treat them as in-range (for example, enemy units)
			frame.rangetex:Show();
		elseif show_30m_range then
			local reaction = UnitReaction("player", unit);

			if reaction and reaction <= 4 then
				if GetItemInfo(835) and IsItemInRange(835, unit) then
					frame.rangetex:Hide();
				else
					frame.rangetex:Show();
				end
			else
				if GetItemInfo(1180) and IsItemInRange(1180, unit) then
					frame.rangetex:Hide();
				else
					frame.rangetex:Show();
				end
			end
		else
			frame.rangetex:Hide();
		end			 
	end

	local index = 1;
	local frameNum = 1;
	local filter = nil;


	if UnitAffectingCombat("player") then
		filter = "PLAYER"
	end

	local aShowIdx = {};

	while ( frameNum <= 20 ) do
		local buffName= UnitBuff(unit, index, filter);
		if ( buffName ) then


			if ACRB_ShowList and ACRB_ShowList[buffName] then
				aShowIdx[frameNum] = {index, ACRB_ShowList[buffName][2]}
				frameNum = frameNum + 1;
			elseif ( asCompactUnitFrame_UtilShouldDisplayBuff_buff(unit, index, filter) and not asCompactUnitFrame_UtilIsBossAura(unit, index, filter, true) ) then
				aShowIdx[frameNum] = {index, 0}
				frameNum = frameNum + 1;
			end
		else
			break;
		end
		index = index + 1;
	end

	if ACRB_ShowListFirst then
		-- sort
		table.sort(aShowIdx, Comparison);

	end

	local frameidx = 1;
	local showframe = {};

	for i = 1, frameNum - 1 do

		if aShowIdx[i][2] > ACRB_MAX_BUFFS - 3 then
			local buffFrame = frame.asbuffFrames[aShowIdx[i][2]];
			asCompactUnitFrame_UtilSetBuff2(buffFrame, unit, aShowIdx[i][1], filter);
			showframe[aShowIdx[i][2]] = true;
		else
			local buffFrame = frame.asbuffFrames[frameidx];
			asCompactUnitFrame_UtilSetBuff2(buffFrame, unit, aShowIdx[i][1], filter);
			frameidx = frameidx + 1;
		end

		if frameidx >  (ACRB_MAX_BUFFS - 3) then
			break
		end


	end



	for i=frameidx, ACRB_MAX_BUFFS - 3 do
		local buffFrame = frame.asbuffFrames[i];
		buffFrame:Hide();
	end

	for i=ACRB_MAX_BUFFS - 2, ACRB_MAX_BUFFS do

		if 	showframe[i] == nil then
			local buffFrame = frame.asbuffFrames[i];
			buffFrame:Hide();
		end
	end
 
end



local function asCompactUnitFrame_UtilShouldDisplayBuff(unit, index, filter)
	local name, icon, count, debuffType, duration, expirationTime, unitCaster, canStealOrPurge, _, spellId, canApplyAura = UnitBuff(unit, index, filter);

	if ACRB_PVPBuffList[spellId] then
		return true;
	end

	return false;

end

local function asCompactUnitFrame_UtilSetBuff(buffFrame, unit, index, filter)
	local name, icon, count, debuffType, duration, expirationTime, unitCaster, canStealOrPurge, _, spellId, canApplyAura = UnitBuff(unit, index, filter);
	buffFrame.icon:SetTexture(icon);
	if ( count > 1 ) then
		local countText = count;
		if ( count >= 100 ) then
			countText = BUFF_STACKS_OVERFLOW;
		end
		buffFrame.count:Show();
		buffFrame.count:SetText(countText);
	else
		buffFrame.count:Hide();
	end
	buffFrame:SetID(index);
	buffFrame.unit = unit;
	buffFrame.filter = filter;
	local enabled = expirationTime and expirationTime ~= 0;
	if enabled then
		local startTime = expirationTime - duration;
		asCooldownFrame_Set(buffFrame.cooldown, startTime, duration, true);
	else
		asCooldownFrame_Clear(buffFrame.cooldown);
	end

	if not buffFrame.baseSize then
		buffFrame.baseSize = buffFrame:GetSize();
	end
	
	buffFrame.border:Hide();
	buffFrame:SetSize((buffFrame.baseSize + ACRB_Size) * 1.2, (buffFrame.baseSize + ACRB_Size) * 0.9);
	buffFrame:Show();
end



-- Debuff 설정 부
local function asCompactUnitFrame_UtilSetDebuff(debuffFrame, unit, index, filter, isBossAura, isBossBuff)
	-- make sure you are using the correct index here!
	--isBossAura says make this look large.
	--isBossBuff looks in HELPFULL auras otherwise it looks in HARMFULL ones
	local name, icon, count, debuffType, duration, expirationTime, unitCaster, canStealOrPurge, _, spellId;
	if (isBossBuff) then
		name, icon, count, debuffType, duration, expirationTime, unitCaster, canStealOrPurge, _, spellId = UnitBuff(unit, index, filter);
	else
		name, icon, count, debuffType, duration, expirationTime, unitCaster, canStealOrPurge, _, spellId = UnitDebuff(unit, index, filter);
	end
	
	debuffFrame.icon:SetTexture(icon);
	if ( count > 1 ) then
		local countText = count;
		if ( count >= 100 ) then
			countText = BUFF_STACKS_OVERFLOW;
		end
		debuffFrame.count:Show();
		debuffFrame.count:SetText(countText);
	else
		debuffFrame.count:Hide();
	end
	debuffFrame:SetID(index);
	debuffFrame.filter = filter;
	debuffFrame.unit = unit;
	local enabled = expirationTime and expirationTime ~= 0;
	if enabled then
		local startTime = expirationTime - duration;
		asCooldownFrame_Set(debuffFrame.cooldown, startTime, duration, true);
	else
		asCooldownFrame_Clear(debuffFrame.cooldown);
	end
	
	local color = DebuffTypeColor[debuffType] or DebuffTypeColor["none"];
	debuffFrame.border:SetVertexColor(color.r, color.g, color.b);
	
	debuffFrame.isBossBuff = isBossBuff;
	if ( isBossAura ) then
		local size = min(debuffFrame.baseSize + BOSS_DEBUFF_SIZE_INCREASE, debuffFrame.maxHeight);
		debuffFrame:SetSize(size * 1.2, size * 0.9);
	else
		debuffFrame:SetSize(debuffFrame.baseSize * 1.2, debuffFrame.baseSize * 0.9);
	end
	
	debuffFrame:Show();
end

local function asCompactUnitFrame_UtilIsBossAura(unit, index, filter, checkAsBuff)
	-- make sure you are using the correct index here!	allAurasIndex ~= debuffIndex
	local name, icon, count, debuffType, duration, expirationTime, unitCaster, canStealOrPurge, _, spellId, canApplyAura, isBossAura, nameplateShowAll;
	if (checkAsBuff) then
		name,  icon, count, debuffType, duration, expirationTime, unitCaster, canStealOrPurge, _, spellId, canApplyAura, isBossAura = UnitBuff(unit, index, filter);
	else
		name,  icon, count, debuffType, duration, expirationTime, unitCaster, canStealOrPurge, _, spellId, canApplyAura, isBossAura, _, nameplateShowAll = UnitDebuff(unit, index, filter);
	end

	return isBossAura or nameplateShowAll;
end

local function asCompactUnitFrame_UtilShouldDisplayDebuff(unit, index, filter)
	local name,  icon, count, debuffType, duration, expirationTime, unitCaster, canStealOrPurge, _, spellId, canApplyAura, isBossAura,  _, nameplateShowAll = UnitDebuff(unit, index, filter);


	if ACRB_BlackList and ACRB_BlackList[name] then
		return false;
	end

	if nameplateShowAll then
		return true;
	end

	
	local hasCustom, alwaysShowMine, showForMySpec = SpellGetVisibilityInfo(spellId, UnitAffectingCombat("player") and "RAID_INCOMBAT" or "RAID_OUTOFCOMBAT");
	if ( hasCustom ) then
		return showForMySpec or (alwaysShowMine and (unitCaster == "player" or unitCaster == "pet" or unitCaster == "vehicle") );	--Would only be "mine" in the case of something like forbearance.
	else
		return true;
	end
end

local function asCompactUnitFrame_UtilIsPriorityDebuff(unit, index, filter)
	local name,  icon, count, debuffType, duration, expirationTime, unitCaster, canStealOrPurge, _, spellId, canApplyAura, isBossAura = UnitDebuff(unit, index, filter);
	
	local _, classFilename = UnitClass("player");
	if ( classFilename == "PALADIN" ) then
		if ( spellId == 25771 ) then	--Forbearance
			return true;
		end
	elseif ( classFilename == "PRIEST" ) then
		if ( spellId == 6788 ) then	--Weakened Soul
			return true;
		end
	end
	
	return false;
end




local function asCompactUnitFrame_UpdateDebuffs(frame)
	if ( not frame.asdebuffFrames ) then
		return;
	end


	local unit = frame.displayedUnit;

	if not (unit) then
		return;
	end

	
	local index = 1;
	local frameNum = 1;
	local filter = nil;
	local maxDebuffs = ACRB_MAX_DEBUFFS;
	--Show both Boss buffs & debuffs in the debuff location
	--First, we go through all the debuffs looking for any boss flagged ones.
	while ( frameNum <= maxDebuffs ) do
		local debuffName = UnitDebuff(unit, index, filter);
		if ( debuffName ) then
			if ( asCompactUnitFrame_UtilIsBossAura(unit, index, filter, false) ) then
				local debuffFrame = frame.asdebuffFrames[frameNum];
				asCompactUnitFrame_UtilSetDebuff(debuffFrame, unit, index, filter, true, false);
				frameNum = frameNum + 1;
				--Boss debuffs are about twice as big as normal debuffs, so display one less.
				local bossDebuffScale = (debuffFrame.baseSize + BOSS_DEBUFF_SIZE_INCREASE)/debuffFrame.baseSize
				maxDebuffs = maxDebuffs - (bossDebuffScale - 1);
			end
		else
			break;
		end
		index = index + 1;
	end
	--Then we go through all the buffs looking for any boss flagged ones.
	index = 1;
	while ( frameNum <= maxDebuffs ) do
		local debuffName = UnitBuff(unit, index, filter);
		if ( debuffName ) then
			if ( asCompactUnitFrame_UtilIsBossAura(unit, index, filter, true) ) then
				local debuffFrame = frame.asdebuffFrames[frameNum];
				asCompactUnitFrame_UtilSetDebuff(debuffFrame, unit, index, filter, true, true);
				frameNum = frameNum + 1;
				--Boss debuffs are about twice as big as normal debuffs, so display one less.
				local bossDebuffScale = (debuffFrame.baseSize + BOSS_DEBUFF_SIZE_INCREASE)/debuffFrame.baseSize
				maxDebuffs = maxDebuffs - (bossDebuffScale - 1);
			end
		else
			break;
		end
		index = index + 1;
	end
	
	--Now we go through the debuffs with a priority (e.g. Weakened Soul and Forbearance)
	index = 1;
	while ( frameNum <= maxDebuffs ) do
		local debuffName = UnitDebuff(unit, index, filter);
		if ( debuffName ) then
			if ( asCompactUnitFrame_UtilIsPriorityDebuff(unit, index, filter) ) then
				local debuffFrame = frame.asdebuffFrames[frameNum];
				asCompactUnitFrame_UtilSetDebuff(debuffFrame, unit, index, filter, false, false);

				frameNum = frameNum + 1;
			end
		else
			break;
		end
		index = index + 1;
	end
	
	
	index = 1;
	--Now, we display all normal debuffs.
	while ( frameNum <= maxDebuffs ) do
		local debuffName = UnitDebuff(unit, index, filter);
		if ( debuffName ) then
			if ( asCompactUnitFrame_UtilShouldDisplayDebuff(unit, index, filter) and not asCompactUnitFrame_UtilIsBossAura(unit, index, filter, false) and
				not asCompactUnitFrame_UtilIsPriorityDebuff(unit, index, filter)) then
				local debuffFrame = frame.asdebuffFrames[frameNum];
				asCompactUnitFrame_UtilSetDebuff(debuffFrame, unit, index, filter, false, false);
				frameNum = frameNum + 1;
			end
		else
			break;
		end
		index = index + 1;
	end
	
	for i=frameNum, ACRB_MAX_DEBUFFS do
		local debuffFrame = frame.asdebuffFrames[i];
		debuffFrame:Hide();
	end
end

-- 해제 디버프

local dispellableDebuffTypes = { Magic = true, Curse = true, Disease = true, Poison = true};
local function asCompactUnitFrame_UpdateDispellableDebuffs(frame)

	if not frame.asdispelDebuffFrames then
		return;
	end

	local showdispell = false;
	
	local unit = frame.displayedUnit;

	if not (unit) then
		return;
	end


			
	--Clear what we currently have.
	for debuffType, display in pairs(dispellableDebuffTypes) do
		if ( display ) then
			frame["ashasDispel"..debuffType] = false;
		end
	end
	
	local index = 1;
	local frameNum = 1;
	local filter = "RAID";	--Only dispellable debuffs.
	while ( frameNum <= ACRB_MAX_DISPELDEBUFFS ) do
		local name, icon, count, debuffType, duration, expirationTime, unitCaster, canStealOrPurge, _, spellId = UnitDebuff(unit, index, filter);

		if ( dispellableDebuffTypes[debuffType] and not frame["ashasDispel"..debuffType] ) then
			frame["ashasDispel"..debuffType] = true;
			local dispellDebuffFrame = frame.asdispelDebuffFrames[frameNum];
			asCompactUnitFrame_UtilSetDispelDebuff(dispellDebuffFrame, debuffType, index)
		
			showdispell = true;


			if ACRB_DispelAlertList and name and ACRB_DispelAlertList[name] then
				ACRB_ShowOverlayGlow(frame);
			end
			
			if frame.asDispelBorder then

				local color = DebuffTypeColor[debuffType] or DebuffTypeColor["none"];
				frame.asDispelBorder:SetVertexColor(color.r, color.g, color.b);
				frame.asDispelBorder:Show();
			end
			frameNum = frameNum + 1;

		elseif ( not name ) then
			break;
		end
		index = index + 1;
	end
	for i=frameNum, ACRB_MAX_DISPELDEBUFFS do
		local dispellDebuffFrame = frame.asdispelDebuffFrames[i];
		dispellDebuffFrame:Hide();
	end

	if showdispell == false and frame.asDispelBorder then
		frame.asDispelBorder:Hide();
		ACRB_HideOverlayGlow(frame);
	end
end



local function asCompactUnitFrame_UpdateHealerMana(frame)

	if ( not frame.asManabar ) then
		return;
	end

	local unit = frame.displayedUnit

	if not (unit) then
		return;
	end

	local role = UnitGroupRolesAssigned(unit)


	if role == "HEALER" then

		frame.asManabar:SetMinMaxValues(0, UnitPowerMax(unit, Enum.PowerType.Mana ))
		frame.asManabar:SetValue(UnitPower(unit, Enum.PowerType.Mana ));

		local info = PowerBarColor["MANA"];
		if ( info ) then
			local r, g, b = info.r, info.g, info.b;
			frame.asManabar:SetStatusBarColor(r, g, b);
		end

		frame.asManabar:Show();
	else

		frame.asManabar:Hide();
	end	
end

local RaidIconList = {
	"|TInterface\\TargetingFrame\\UI-RaidTargetingIcon_1:",
	"|TInterface\\TargetingFrame\\UI-RaidTargetingIcon_2:",
	"|TInterface\\TargetingFrame\\UI-RaidTargetingIcon_3:",
	"|TInterface\\TargetingFrame\\UI-RaidTargetingIcon_4:",
	"|TInterface\\TargetingFrame\\UI-RaidTargetingIcon_5:",
	"|TInterface\\TargetingFrame\\UI-RaidTargetingIcon_6:",
	"|TInterface\\TargetingFrame\\UI-RaidTargetingIcon_7:",
	"|TInterface\\TargetingFrame\\UI-RaidTargetingIcon_8:",
}

local function ACRB_DisplayRaidIcon(unit)
	local icon = GetRaidTargetIndex(unit)
	if icon and RaidIconList[icon] then
		return RaidIconList[icon] .. "0|t"
	else	
		return ""
	end
end


local function asCompactUnitFrame_UpdateBuffsPVP(frame)

	local unit = frame.displayedUnit


	if not (unit) then
		return;
	end


	if (frame.asraidicon) then
		local text = ACRB_DisplayRaidIcon(unit);
		frame.asraidicon:SetText(text);
		frame.asraidicon:Show();
	end
	
	if (frame.buffFrames2) then
		local index = 1;
		local frameNum = 1;
		local filter = nil;
		while ( frameNum <= ACRB_MAX_BUFFS_2 ) do
			local buffName = UnitBuff(unit, index, filter);
			if ( buffName ) then
				if ( asCompactUnitFrame_UtilShouldDisplayBuff(unit, index, filter)) then
					local buffFrame = frame.buffFrames2[frameNum];
					asCompactUnitFrame_UtilSetBuff(buffFrame, unit, index, filter);
					frameNum = frameNum + 1;
				end
			else
				break;
			end
			index = index + 1;
		end
			for i=frameNum, ACRB_MAX_BUFFS_2 do
				local buffFrame = frame.buffFrames2[i];
				if buffFrame then
				buffFrame:Hide();
			end
		end
	end
end

local function asCompactUnitFrame_HideAllBuffs(frame, startingIndex)
	if frame.buffFrames then
		for i=startingIndex or 1, #frame.buffFrames do
			frame.buffFrames[i]:SetAlpha(0);
			frame.buffFrames[i]:Hide();
		end
	end
end

local function asCompactUnitFrame_HideAllDebuffs(frame, startingIndex)
	if frame.debuffFrames then
		for i=startingIndex or 1, #frame.debuffFrames do
			frame.debuffFrames[i]:SetAlpha(0);
			frame.debuffFrames[i]:Hide();
		end
	end
end

local function asCompactUnitFrame_HideAllDispelDebuffs(frame, startingIndex)

	if frame.dispelDebuffFrames then
		for i=startingIndex or 1, #frame.dispelDebuffFrames do
			frame.dispelDebuffFrames[i]:SetAlpha(0);
			frame.dispelDebuffFrames[i]:Hide();
		end
	end
end

local function ACRB_disableDefault(frame)

	if frame and not frame:IsForbidden() then
		-- 거리 기능 충돌 때문에 안됨
		--frame.optionTable.fadeOutOfRange = false;
		frame:UnregisterEvent("UNIT_AURA");
		frame:UnregisterEvent("PLAYER_REGEN_ENABLED");
		frame:UnregisterEvent("PLAYER_REGEN_DISABLED");

		asCompactUnitFrame_HideAllBuffs(frame);
		asCompactUnitFrame_HideAllDebuffs(frame)
		asCompactUnitFrame_HideAllDispelDebuffs(frame);
	end
end

local function ACRB_updateAllBuff(asframe)

	if asframe and asframe.frame and asframe.frame:IsShown() then
		asCompactUnitFrame_UpdateBuffs(asframe);
		asCompactUnitFrame_UpdateBuffsPVP(asframe);
	end
end


local function ACRB_updateAllDebuff(asframe)

	if asframe and asframe.frame and asframe.frame:IsShown() then
		asCompactUnitFrame_UpdateDebuffs(asframe);
		asCompactUnitFrame_UpdateDispellableDebuffs(asframe);
	end
end


local function ACRB_updateAllHealerMana(asframe)

	if asframe and asframe.frame and asframe.frame:IsShown() then
		asCompactUnitFrame_UpdateHealerMana(asframe);
	end
end




local together = nil;

local function ACRB_updatePartyAllBuff()

	if (IsInGroup() or (ACRB_ShowWhenSolo)) then
		if IsInRaid() then -- raid
			if together == true then
				for i=1,8 do
					for k=1,5 do
						local asframe = asraid["CompactRaidGroup"..i.."Member"..k]
						ACRB_updateAllBuff(asframe);
					end
				end
			else
				for i=1,40 do
					local asframe = asraid["CompactRaidFrame"..i]
					ACRB_updateAllBuff(asframe);
				end
			end
		else -- party
			for i=1, 5 do
				local asframe = asraid["CompactPartyFrameMember"..i]
				ACRB_updateAllBuff(asframe);
			end
		end
	end
end


local function ACRB_updatePartyAllDebuff()

	if (IsInGroup() or (ACRB_ShowWhenSolo)) then
		if IsInRaid() then -- raid
			if together == true then
				for i=1,8 do
					for k=1,5 do
						local asframe = asraid["CompactRaidGroup"..i.."Member"..k]
						ACRB_updateAllDebuff(asframe);
					end
				end
			else
				for i=1,40 do
					local asframe = asraid["CompactRaidFrame"..i]
					ACRB_updateAllDebuff(asframe);
				end
			end
		else -- party
			for i=1, 5 do
				local asframe = asraid["CompactPartyFrameMember"..i]
				ACRB_updateAllDebuff(asframe);
			end
		end
	end
end


local function ACRB_updatePartyAllHealerMana()

	if (IsInGroup() or (ACRB_ShowWhenSolo)) then
		if IsInRaid() then -- raid
			if together == true then
				for i=1,8 do
					for k=1,5 do
						local asframe = asraid["CompactRaidGroup"..i.."Member"..k]
						ACRB_updateAllHealerMana(asframe);
					end
				end
			else
				for i=1,40 do
					local asframe = asraid["CompactRaidFrame"..i]
					ACRB_updateAllHealerMana(asframe);
				end
			end
		else -- party
			for i=1, 5 do
				local asframe = asraid["CompactPartyFrameMember"..i]
				ACRB_updateAllHealerMana(asframe);
			end
		end
	end
end


local function ACRB_DisableAura()

	if (IsInGroup() or (ACRB_ShowWhenSolo)) then 

		if IsInRaid() then -- raid
			if together == true then

				for i=1,8 do
					for k=1,5 do
						local frame = _G["CompactRaidGroup"..i.."Member"..k]
						ACRB_disableDefault(frame);
						
					end
				end
			else
				for i=1,40 do
					local frame = _G["CompactRaidFrame"..i]
					ACRB_disableDefault(frame);
					
				end
			end
		else -- party
			for i=1, 5 do
				local frame = _G["CompactPartyFrameMember"..i]
				ACRB_disableDefault(frame);				
			end
		end
	end
end




local mustdisable = true;



local function ACRB_OnUpdate()

	if mustdisable then
		mustdisable = false;
		together = EditModeManagerFrame:ShouldRaidFrameShowSeparateGroups();
		if together == nil then
			together = true;
		end
		ACRB_DisableAura();
	end

	ACRB_updatePartyAllBuff();
	ACRB_updatePartyAllDebuff();
	ACRB_updatePartyAllHealerMana();

end

local function ACRB_OnEvent(self, event, ...)

		local arg1 = ...;

		if  event == "UNIT_SPELLCAST_SUCCEEDED" and arg1 == "player"  then
			ACRB_updatePartyAllBuff();			
		elseif (event == "PLAYER_ENTERING_WORLD") then
			ACRB_InitList();
			mustdisable = true;
		elseif (event == "ACTIVE_TALENT_GROUP_CHANGED") then
			ACRB_InitList();
		elseif (event == "GROUP_ROSTER_UPDATE") or (event == "CVAR_UPDATE") or (event == "ROLE_CHANGED_INFORM") then
			mustdisable = true;
		elseif (event == "COMPACT_UNIT_FRAME_PROFILES_LOADED") then
			together = EditModeManagerFrame:ShouldRaidFrameShowSeparateGroups();
			if together == nil then
				together = true;
			end
		end
end

local function asCompactUnitFrame_UpdateAll(frame)

	if frame and not frame:IsForbidden() and frame.GetName then 
		local name = frame:GetName();

		if name and not (name == nil) and (string.find (name, "CompactRaidGroup") or string.find (name, "CompactPartyFrameMember") or string.find (name, "CompactRaidFrame")) then
			ACRB_disableDefault(frame);
			ACRB_setupFrame(frame);
			mustdisable = true;					
		end
	end
	
end

local ACRB_mainframe = CreateFrame("Frame", nil, UIParent);
ACRB_mainframe:SetScript("OnEvent", ACRB_OnEvent)
ACRB_mainframe:RegisterEvent("GROUP_ROSTER_UPDATE");
ACRB_mainframe:RegisterEvent("PLAYER_ENTERING_WORLD");
ACRB_mainframe:RegisterUnitEvent("UNIT_SPELLCAST_SUCCEEDED", "player");
ACRB_mainframe:RegisterEvent("ACTIVE_TALENT_GROUP_CHANGED");
ACRB_mainframe:RegisterEvent("CVAR_UPDATE");
ACRB_mainframe:RegisterEvent("ROLE_CHANGED_INFORM");
ACRB_mainframe:RegisterEvent("COMPACT_UNIT_FRAME_PROFILES_LOADED");
ACRB_mainframe:RegisterEvent("VARIABLES_LOADED");

C_Timer.NewTicker(ACRB_UpdateRate, ACRB_OnUpdate);	

hooksecurefunc("CompactUnitFrame_UpdateAll" ,asCompactUnitFrame_UpdateAll);