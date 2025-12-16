-----------------설정 ------------------------
local AGCDB_WIDTH = 239;
local AGCDB_HEIGHT = 5;
local AGCDB_X = 0;
local AGCDB_Y = -219;

local AGCDB = CreateFrame("FRAME", nil, UIParent)
AGCDB:SetPoint("BOTTOM", UIParent, "BOTTOM", 0, 0)
AGCDB:SetWidth(0)
AGCDB:SetHeight(0)
AGCDB:Show();

AGCDB.gcdbar = CreateFrame("StatusBar", nil, UIParent)
AGCDB.gcdbar:SetStatusBarTexture("Interface\\addons\\asGCDBar\\UI-StatusBar")
AGCDB.gcdbar:GetStatusBarTexture():SetHorizTile(false)
AGCDB.gcdbar:SetMinMaxValues(0, 100)
AGCDB.gcdbar:SetValue(0)
AGCDB.gcdbar:SetHeight(AGCDB_HEIGHT)
AGCDB.gcdbar:SetWidth(AGCDB_WIDTH)
AGCDB.gcdbar:SetStatusBarColor(1, 0.9, 0.9);

AGCDB.gcdbar.bg = AGCDB.gcdbar:CreateTexture(nil, "BACKGROUND")
AGCDB.gcdbar.bg:SetPoint("TOPLEFT", AGCDB.gcdbar, "TOPLEFT", -1, 1)
AGCDB.gcdbar.bg:SetPoint("BOTTOMRIGHT", AGCDB.gcdbar, "BOTTOMRIGHT", 1, -1)

AGCDB.gcdbar.bg:SetTexture("Interface\\Addons\\asGCDBar\\border.tga")
AGCDB.gcdbar.bg:SetTexCoord(0.1, 0.1, 0.1, 0.1, 0.1, 0.1, 0.1, 0.1)
AGCDB.gcdbar.bg:SetVertexColor(0, 0, 0, 0.8);

AGCDB.gcdbar:SetPoint("CENTER", UIParent, "CENTER", AGCDB_X, AGCDB_Y)
AGCDB.gcdbar:Show();

C_AddOns.LoadAddOn("asMOD");

if asMOD_setupFrame then
	asMOD_setupFrame(AGCDB.gcdbar, "asGCDBar");
end

local curve = C_CurveUtil.CreateCurve();
curve:SetType(Enum.LuaCurveType.Linear);
curve:AddPoint(0, 0);
curve:AddPoint(1, 100);

local function AGCDB_OnUpdate()
	local remain_percent = C_Spell.GetSpellCooldownRemainingPercent(61304, curve);
	AGCDB.gcdbar:SetValue(remain_percent);	
end

C_Timer.NewTicker(0.1, AGCDB_OnUpdate);
