local _, ns = ...;

local objects = {};

-- 버프 디버프 처리부
local function createDebuffFrame(parent)
    local ret = CreateFrame("Frame", nil, parent, "asNamePlatesBuffFrameTemplate");
    local frameCooldown = ret.cooldown;    
    local frameOther = ret.other;
    local frameCount = frameOther.count;
    local frameIcon = ret.icon;
    local frameBorder = ret.border;

    for _, r in next, { frameCooldown:GetRegions() } do
        if r:GetObjectType() == "FontString" then
            r:SetFont(STANDARD_TEXT_FONT, ns.ANameP_CooldownFontSize, "OUTLINE")
            r:ClearAllPoints();
            r:SetPoint("TOP", 0, 4);
            break
        end
    end

    local font, size, flag = frameCount:GetFont()

    frameCount:SetFont(STANDARD_TEXT_FONT, ns.ANameP_CountFontSize, "OUTLINE")
    frameCount:ClearAllPoints();
    frameCount:SetPoint("BOTTOMRIGHT", frameIcon, "BOTTOMRIGHT", -2, 2);
    frameOther.snapshot:SetFont(STANDARD_TEXT_FONT, ns.ANameP_CountFontSize - 2, "OUTLINE")
    frameIcon:SetTexCoord(.08, .92, .08, .92)
    frameBorder:SetTexture("Interface\\Addons\\asNamePlates\\border.tga");
    frameBorder:SetTexCoord(0.08, 0.08, 0.08, 0.92, 0.92, 0.08, 0.92, 0.92);
    frameCooldown:SetDrawSwipe(true);

    ret.alert = false;

    if not ret:GetScript("OnEnter") then
        ret:SetScript("OnEnter", function(s)
            if s:GetID() > 0 then
                GameTooltip_SetDefaultAnchor(GameTooltip, s);
                if s.type == 1 then
                    GameTooltip:SetUnitBuffByAuraInstanceID(s.unit, s:GetID(), s.filter);
                else
                    GameTooltip:SetUnitDebuffByAuraInstanceID(s.unit, s:GetID(), s.filter);
                end
            end
        end)
        ret:SetScript("OnLeave", function()
            GameTooltip:Hide();
        end)
    end

    ret:EnableMouse(false);

    return ret;
end

local function creatframe()
    local object = CreateFrame("Frame", nil);

    object:EnableMouse(false);
    object.aggro = object:CreateFontString(nil, "OVERLAY");
    object.petcleave = object:CreateFontString(nil, "OVERLAY");
    object.pettarget = object:CreateFontString(nil, "OVERLAY");
    object.healer = object:CreateFontString(nil, "OVERLAY");
    object.casticon = CreateFrame("Frame", nil, object, "asNamePlatesBuffFrameTemplate");
    object.casticon.timetext = object.casticon:CreateFontString(nil, "OVERLAY");
    object.casticon.targetname = object.casticon:CreateFontString(nil, "OVERLAY");
    object.CCdebuff = CreateFrame("Frame", nil, object, "asNamePlatesBuffFrameTemplate");
    object.BarTexture = object:CreateTexture(nil, "OVERLAY", "asColorTextureTemplate", 1);
    object.BarColor = object:CreateTexture(nil, "OVERLAY", "asColorTextureTemplate", 2);
    object.healthtext = object:CreateFontString(nil, "OVERLAY");
    object.realhealthtext = object:CreateFontString(nil, "OVERLAY");
    object.motext = object:CreateFontString(nil, "OVERLAY");
    object.tgtext = object:CreateFontString(nil, "OVERLAY");
    object.resourcetext = object:CreateFontString(nil, "OVERLAY");
    object.buffList = {};

    for i = 1, ns.ANameP_MaxDebuff do
        object.buffList[i] = createDebuffFrame(object);
    end

    if not object.CCdebuff:GetScript("OnEnter") then
        object.CCdebuff:SetScript("OnEnter", function(s)
            if s:GetID() > 0 then
                GameTooltip_SetDefaultAnchor(GameTooltip, s);
                GameTooltip:SetUnitDebuffByAuraInstanceID(s.unit, s:GetID(), s.filter);
            end
        end)
        object.CCdebuff:SetScript("OnLeave", function()
            GameTooltip:Hide();
        end)
    end

    object.CCdebuff:EnableMouse(false);

    local frameIcon = object.CCdebuff.icon;
    local frameBorder = object.CCdebuff.border;

    frameIcon:SetTexCoord(.08, .92, .08, .92);
    frameBorder:SetTexture("Interface\\Addons\\asNamePlates\\border.tga");
    frameBorder:SetTexCoord(0.08, 0.08, 0.08, 0.92, 0.92, 0.08, 0.92, 0.92);


    object.casticon:EnableMouse(false);

    object.casticon.timetext:SetFont(STANDARD_TEXT_FONT, ns.ANameP_HeathTextSize, "OUTLINE");
    object.casticon.timetext:ClearAllPoints();
    object.casticon.timetext:SetPoint("CENTER", object.casticon, "CENTER", 0, 0);

    object.casticon.targetname:SetFont(STANDARD_TEXT_FONT, ns.ANameP_HeathTextSize, "OUTLINE");
    object.casticon.targetname:ClearAllPoints();
    object.casticon.targetname:SetPoint("TOPRIGHT", object.casticon, "BOTTOMRIGHT", 0, -1);
    

    if not object.casticon:GetScript("OnEnter") then
        object.casticon:SetScript("OnEnter", function(s)
            if s.castspellid and s.castspellid > 0 then
                GameTooltip_SetDefaultAnchor(GameTooltip, s);
                GameTooltip:SetSpellByID(s.castspellid);
            end
        end)
        object.casticon:SetScript("OnLeave", function()
            GameTooltip:Hide();
        end)
    end

    frameIcon = object.casticon.icon;
    frameBorder = object.casticon.border;

    frameIcon:SetTexCoord(.08, .92, .08, .92);
    frameBorder:SetTexture("Interface\\Addons\\asNamePlates\\border.tga");
    frameBorder:SetTexCoord(0.08, 0.08, 0.08, 0.92, 0.92, 0.08, 0.92, 0.92);

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