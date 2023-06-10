local AFUF = CreateFrame("FRAME", nil, UIParent);

function AFUF:HideCombatText()
    -- 데미지 숫자 숨기기
    PlayerFrame:UnregisterEvent("UNIT_COMBAT");
    TargetFrame:UnregisterEvent("UNIT_COMBAT");
    PetFrame:UnregisterEvent("UNIT_COMBAT");
end

function AFUF:HideTargetBuffs()
    -- TargetFrame의 Buff Debuff를 숨긴다.
    TargetFrame:UnregisterEvent("UNIT_AURA");
    local function _UpdateBuffAnchor(self, buff)
	    --For mirroring vertically
	    buff:Hide();
    end

    hooksecurefunc("TargetFrame_UpdateBuffAnchor", _UpdateBuffAnchor);
    hooksecurefunc("TargetFrame_UpdateDebuffAnchor", _UpdateBuffAnchor);
end


function AFUF:HideTargetCastBar()
    --TargetCastBar 를 숨긴다.
    SetCVar("showTargetCastbar", "0");
end

function AFUF:HideClassBar()
    --주요 자원바 숨기기
    local ClassBarOnShow = function (frame)
        frame:Hide()
    end

    local frame
    local _, class = UnitClass("player")

    if PlayerFrame.classPowerBar then
        frame = PlayerFrame.classPowerBar
    elseif class == "DEATHKNIGHT" then
        frame = RuneFrame
    elseif class == "EVOKER" then
        frame = EssencePlayerFrame
    end

    if (frame) then
        frame:Hide();
        frame:HookScript("OnShow", ClassBarOnShow);
    end

    frame = TotemFrame;

    if (frame) then
        frame:Hide();
        frame:HookScript("OnShow", ClassBarOnShow);
    end
end

function AFUF:UpdateHealthBar()

    --Healthbar 직업 색상
    local function getFramesHealthBar()

        return {
            PlayerFrame_GetHealthBar(),
            TargetFrame.TargetFrameContent.TargetFrameContentMain.HealthBar,
            TargetFrameToT.HealthBar,
        }
    end

    local function updateHealthColor(unit, frame)
        local r, g, b;
        local localizedClass, englishClass = UnitClass(unit);
        local classColor = RAID_CLASS_COLORS[englishClass];
        if ( (UnitIsPlayer(unit)) and classColor ) then
            r, g, b = classColor.r, classColor.g, classColor.b;
        elseif ( UnitIsFriend("player", unit) ) then
            r, g, b = 0.0, 1.0, 0.0;
        else
            r, g, b = 1.0, 0.0, 0.0;
        end	
        frame:SetStatusBarColor(r, g, b);
    end

    local function updateHealthStatus(statusbar, unit)

        if (UnitIsPlayer(unit) and UnitClass(unit)) then
            -- player
            local localizedClass, englishClass = UnitClass(unit);
            local classColor = RAID_CLASS_COLORS[englishClass];
            --statusbar.HealthBarMask:Hide();
            statusbar:SetStatusBarTexture("Interface\\addons\\asFixUnitFrame\\UI-StatusBar.blp")
            updateHealthColor(unit, statusbar)
        end
    end

    local healthBars = getFramesHealthBar()

    for _, statusbar in pairs(healthBars) do
        updateHealthStatus(statusbar, statusbar.unit)
    end
end

local function AFUF_OnEvent(self, event, ...)

	if event == "PLAYER_ENTERING_WORLD" or  event == "ACTIVE_TALENT_GROUP_CHANGED" then
		self:HideClassBar();
        self:HideCombatText();
        self:HideTargetBuffs();
	end
	self:UpdateHealthBar();
	AFUF:RegisterUnitEvent("UNIT_TARGET", "target");
end


AFUF:SetScript("OnEvent", AFUF_OnEvent);
AFUF:RegisterEvent("PLAYER_TARGET_CHANGED");
AFUF:RegisterEvent("PLAYER_ENTERING_WORLD");
AFUF:RegisterEvent("ACTIVE_TALENT_GROUP_CHANGED");
AFUF:RegisterUnitEvent("UNIT_TARGET", "target");