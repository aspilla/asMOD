local _, ns = ...;

local objects = {};

-- 버프 디버프 처리부
local function createDebuffFrame(parent)
    local frame = CreateFrame("Frame", nil, parent, "asNamePlatesBuffFrameTemplate");
    local frameCooldown = frame.cooldown;        
    local frameCount = frame.count;
    local frameIcon = frame.icon;
    local frameBorder = frame.border; 
    
    frameIcon:SetTexCoord(.08, .92, .24, .76);
    frameBorder:SetTexCoord(0.08, 0.08, 0.08, 0.92, 0.92, 0.08, 0.92, 0.92);
     
    frameCooldown:SetDrawSwipe(true);
    for _, r in next, { frameCooldown:GetRegions() } do
        if r:GetObjectType() == "FontString" then
            r:SetFont(STANDARD_TEXT_FONT, ns.ANameP_CooldownFontSize, "OUTLINE");
            r:ClearAllPoints();
            r:SetPoint("TOP", 0, 4);
            r:SetDrawLayer("OVERLAY");
            break;        
        end
    end        

    frameCount:SetFont(STANDARD_TEXT_FONT, ns.ANameP_CountFontSize, "OUTLINE");
    frameCount:ClearAllPoints();
    frameCount:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", -1, 1);
    frame.snapshot:SetFont(STANDARD_TEXT_FONT, ns.ANameP_CountFontSize - 2, "OUTLINE");    
    frame.snapshot:ClearAllPoints();
    frame.snapshot:SetPoint("CENTER", frame, "BOTTOM", 0, 0);

    frame.alert = false;
    frame.data = {};

    if not frame:GetScript("OnEnter") then
        frame:SetScript("OnEnter", function(s)
            if s:GetID() > 0 then
                GameTooltip_SetDefaultAnchor(GameTooltip, s);
                if s.type == 1 then
                    GameTooltip:SetUnitBuffByAuraInstanceID(s.unit, s:GetID(), s.filter);
                else
                    GameTooltip:SetUnitDebuffByAuraInstanceID(s.unit, s:GetID(), s.filter);
                end
            end
        end)
        frame:SetScript("OnLeave", function()
            GameTooltip:Hide();
        end)
    end

    frame:EnableMouse(false);

    return frame;
end

local function createCastIcon(parent)

    local frame = CreateFrame("Frame", nil, parent, "asNamePlatesBuffFrameTemplate");
    frame.timetext = frame:CreateFontString(nil, "OVERLAY");
    frame.targetname = frame:CreateFontString(nil, "OVERLAY");

    frame:EnableMouse(false);

    frame.icon:SetTexCoord(.08, .92, .08, .92);    
    frame.border:SetTexCoord(0.08, 0.08, 0.08, 0.92, 0.92, 0.08, 0.92, 0.92);

    frame.timetext:SetFont(STANDARD_TEXT_FONT, ns.ANameP_HeathTextSize, "OUTLINE");
    frame.timetext:ClearAllPoints();
    frame.timetext:SetPoint("CENTER", frame, "CENTER", 0, 0);

    frame.targetname:SetFont(STANDARD_TEXT_FONT, ns.ANameP_HeathTextSize, "OUTLINE");
    frame.targetname:ClearAllPoints();
    frame.targetname:SetPoint("TOPRIGHT", frame, "BOTTOMRIGHT", 0, -1);
    frame.data = {};
    

    if not frame:GetScript("OnEnter") then
        frame:SetScript("OnEnter", function(s)
            if s.castspellid and s.castspellid > 0 then
                GameTooltip_SetDefaultAnchor(GameTooltip, s);
                GameTooltip:SetSpellByID(s.castspellid);
            end
        end)
        frame:SetScript("OnLeave", function()
            GameTooltip:Hide();
        end)
    end    

    return frame;

end

local function creatframe()
    local object = CreateFrame("Frame", nil);

    object:EnableMouse(false);
    object.aggro = object:CreateFontString(nil, "OVERLAY");
    object.petcleave = object:CreateFontString(nil, "OVERLAY");
    object.pettarget = object:CreateFontString(nil, "OVERLAY");
    object.healer = object:CreateFontString(nil, "OVERLAY");
    object.casticon = createCastIcon(object);
    object.CCdebuff = createDebuffFrame(object);
    object.BarTexture = object:CreateTexture(nil, "OVERLAY", "asColorTextureTemplate", 1);
    object.BarColor = object:CreateTexture(nil, "OVERLAY", "asColorTextureTemplate", 2);
    object.healthtext = object:CreateFontString(nil, "OVERLAY");
    object.realhealthtext = object:CreateFontString(nil, "OVERLAY");
   
    object.powerbar = CreateFrame("StatusBar", nil, object);
    object.powerbar:SetStatusBarTexture("Interface\\addons\\asNamePlates\\UI-StatusBar")
    object.powerbar:GetStatusBarTexture():SetHorizTile(false)
    object.powerbar:SetMinMaxValues(0, 100)
    object.powerbar:SetValue(100)
    object.powerbar:SetHeight(2)
    object.powerbar:SetWidth(50);

    object.powerbar.bg = object.powerbar:CreateTexture(nil, "BACKGROUND");
    object.powerbar.bg:SetPoint("TOPLEFT", object.powerbar, "TOPLEFT", -1, 1);
    object.powerbar.bg:SetPoint("BOTTOMRIGHT", object.powerbar, "BOTTOMRIGHT", 1, -1);

    object.powerbar.bg:SetTexture("Interface\\Addons\\asUnitFrame\\border.tga");
    object.powerbar.bg:SetTexCoord(0.1, 0.1, 0.1, 0.1, 0.1, 0.1, 0.1, 0.1);
    object.powerbar.bg:SetVertexColor(0, 0, 0, 0.8);

    object.powerbar.value = object.powerbar:CreateFontString(nil, "ARTWORK");
    object.powerbar.value:SetFont(STANDARD_TEXT_FONT, ns.ANameP_HeathTextSize - 3, "OUTLINE");
    object.powerbar.value:SetTextColor(1, 1, 1, 1)
    object.powerbar.value:SetPoint("CENTER", object.powerbar, "CENTER", 0, 0);
    
    object.motext = object:CreateFontString(nil, "OVERLAY");
    object.tgtext = object:CreateFontString(nil, "OVERLAY");
    object.resourcetext = object:CreateFontString(nil, "OVERLAY");
    object.buffList = {};

    for i = 1, ns.ANameP_MaxDebuff do
        object.buffList[i] = createDebuffFrame(object);
    end

    object.healthtext:SetFont(STANDARD_TEXT_FONT, ns.ANameP_HeathTextSize, "OUTLINE");
    object.realhealthtext:SetFont(STANDARD_TEXT_FONT, ns.ANameP_HeathTextSize - 2, "OUTLINE");
    object.motext:SetFont(STANDARD_TEXT_FONT, ns.ANameP_HeathTextSize, "OUTLINE");
    object.tgtext:SetFont(STANDARD_TEXT_FONT, ns.ANameP_HeathTextSize, "OUTLINE");



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