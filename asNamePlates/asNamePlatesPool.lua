local _, ns = ...;

local objects = {};

local CONFIG_FONT = STANDARD_TEXT_FONT;
local region = GetCurrentRegion();

if region == 2 and GetLocale() ~= "koKR" then
	CONFIG_FONT = "Fonts\\2002.ttf";
end

local function createCastIcon(parent)
    local frame = CreateFrame("Frame", nil, parent, "asNamePlatesBuffFrameTemplate");
    frame.timetext = frame:CreateFontString(nil, "OVERLAY");
    frame.targetname = frame:CreateFontString(nil, "OVERLAY");


    frame.icon:SetTexCoord(.08, .92, .08, .92);
    frame.border:SetTexCoord(0.08, 0.08, 0.08, 0.92, 0.92, 0.08, 0.92, 0.92);
    frame:EnableMouse(false);

    return frame;
end

local mouseoverIcon = CreateAtlasMarkup("poi-door-arrow-up", 12, 12, 0, 0, 0, 255, 0);

local function creatframe()
    local object = CreateFrame("Frame", nil);

    object:EnableMouse(false);
    object.casticon = createCastIcon(object);        
    object.BarColor = object:CreateTexture(nil, "ARTWORK", "asNameplateTemplate", 1);    

    object.powerbar = CreateFrame("StatusBar", nil, object);
    object.powerbar:SetStatusBarTexture("Interface\\addons\\asNamePlates\\UI-StatusBar")
    object.powerbar:GetStatusBarTexture():SetHorizTile(false)
    object.powerbar:SetMinMaxValues(0, 100)
    object.powerbar:SetValue(100)
    object.powerbar:SetHeight(4)
    object.powerbar:SetWidth(60);

    object.powerbar.bg = object.powerbar:CreateTexture(nil, "BACKGROUND");
    object.powerbar.bg:SetPoint("TOPLEFT", object.powerbar, "TOPLEFT", -1, 1);
    object.powerbar.bg:SetPoint("BOTTOMRIGHT", object.powerbar, "BOTTOMRIGHT", 1, -1);

    object.powerbar.bg:SetTexture("Interface\\Addons\\asUnitFrame\\border.tga");
    object.powerbar.bg:SetTexCoord(0.1, 0.1, 0.1, 0.1, 0.1, 0.1, 0.1, 0.1);
    object.powerbar.bg:SetVertexColor(0, 0, 0, 0.8);

    object.powerbar.value = object.powerbar:CreateFontString(nil, "ARTWORK");
    object.powerbar.value:SetFont(STANDARD_TEXT_FONT, ns.ANameP_PowerTextSize, "OUTLINE");
    object.powerbar.value:SetTextColor(1, 1, 1, 1)
    object.powerbar.value:SetPoint("CENTER", object.powerbar, "CENTER", 0, 0);

    object.motext = object:CreateFontString(nil, "OVERLAY");
    object.motext:SetFont(STANDARD_TEXT_FONT, ns.ANameP_MouseTextSize, "OUTLINE");
    object.motext:SetText(mouseoverIcon);

    return object;
end

local point = 0;
local CONFIG_POOL_SIZE = 20;

local function initpools()
    for i = 1, CONFIG_POOL_SIZE do
        objects[i] = creatframe();
    end
end

function ns.getasframe()
    point = point + 1;

    if objects[point] == nil then
        objects[point] = creatframe();
    end

    local ret = objects[point];
    objects[point] = nil;

    return ret;
end

function ns.freeasframe(asframe)
    if point == 0 then
        return;
    end

    objects[point] = asframe;
    point = point - 1;
end

initpools();
