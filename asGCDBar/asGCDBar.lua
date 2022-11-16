-----------------설정 ------------------------
local AGCDB_WIDTH = 200
local AGCDB_HEIGHT = 8
local AGCDB_X = 0;
local AGCDB_Y = -241;




local AGCDB = CreateFrame("FRAME", nil, UIParent)
AGCDB:SetPoint("BOTTOM",UIParent,"BOTTOM", 0, 0)
AGCDB:SetWidth(0)
AGCDB:SetHeight(0)
AGCDB:Show();


AGCDB.gcdbar = CreateFrame("StatusBar", nil, UIParent)
AGCDB.gcdbar:SetStatusBarTexture("Interface\\addons\\asGCDBar\\UI-StatusBar.blp", "BORDER")
AGCDB.gcdbar:GetStatusBarTexture():SetHorizTile(false)
AGCDB.gcdbar:SetMinMaxValues(0, 100)
AGCDB.gcdbar:SetValue(100)
AGCDB.gcdbar:SetHeight(AGCDB_HEIGHT)
AGCDB.gcdbar:SetWidth(AGCDB_WIDTH)
AGCDB.gcdbar:SetStatusBarColor(1, 0.9, 0.9);

AGCDB.gcdbar.bg = AGCDB.gcdbar:CreateTexture(nil, "BACKGROUND")
AGCDB.gcdbar.bg:SetPoint("TOPLEFT", AGCDB.gcdbar, "TOPLEFT", -1, 1)
AGCDB.gcdbar.bg:SetPoint("BOTTOMRIGHT", AGCDB.gcdbar, "BOTTOMRIGHT", 1, -1)

AGCDB.gcdbar.bg:SetTexture("Interface\\Addons\\asGCDBar\\border.tga")
AGCDB.gcdbar.bg:SetTexCoord(0.1,0.1, 0.1,0.1, 0.1,0.1, 0.1,0.1)	
AGCDB.gcdbar.bg:SetVertexColor(0, 0, 0, 0.8);

AGCDB.gcdbar:SetPoint("CENTER",UIParent,"CENTER", AGCDB_X, AGCDB_Y)
AGCDB.gcdbar:Show();

LoadAddOn("asMOD");

if asMOD_setupFrame then
    asMOD_setupFrame (AGCDB.gcdbar, "asGCDBar");
end
local function AGCDB_OnUpdate()

	local start, gcd  = GetSpellCooldown(61304);
	local current = GetTime();

	if gcd > 0 then
		AGCDB.gcdbar:SetMinMaxValues(0, gcd * 1000)
		AGCDB.gcdbar:SetValue((current - start) * 1000);			
		AGCDB.gcdbar.start = start;
		AGCDB.gcdbar.duration = gcd;
		AGCDB.gcdbar:Show();
	else
		AGCDB.gcdbar:SetValue(0);
		AGCDB.gcdbar:Hide();
	end
end

C_Timer.NewTicker(0.2, AGCDB_OnUpdate);