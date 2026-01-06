local _, ns = ...;

local objects = {};
local point = 0;
local CONFIG_POOL_SIZE = 50;

local function create_casticon(parent)
    local frame = CreateFrame("Frame", nil, parent, "asNamePlatesBuffFrameTemplate");
    frame.icon:SetTexCoord(.08, .92, .08, .92);
    frame.border:SetTexCoord(0.08, 0.08, 0.08, 0.92, 0.92, 0.08, 0.92, 0.92);
    frame:EnableMouse(false);
    return frame;
end

local mouseoverIcon = CreateAtlasMarkup("poi-door-arrow-up", 12, 12, 0, 0, 0, 255, 0);

local function create_frame()
    local object = CreateFrame("Frame", nil);

    object:EnableMouse(false);
    object.casticon = create_casticon(object);

    local template = "asNamePlates2Template";

    if not ns.options.ChangeTexture then
        template  = "asNamePlates1Template";
    end

    object.BarColor = object:CreateTexture(nil, "ARTWORK", template, 1);

    object.powerbar = CreateFrame("StatusBar", nil, object);
    object.powerbar:SetStatusBarTexture("RaidFrame-Hp-Fill")
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
    object.powerbar.bg:SetVertexColor(0, 0, 0, 1);

    object.powerbar.value = object.powerbar:CreateFontString(nil, "ARTWORK");
    object.powerbar.value:SetFont(STANDARD_TEXT_FONT, ns.configs.powerfontsize, "OUTLINE");
    object.powerbar.value:SetTextColor(1, 1, 1, 1)
    object.powerbar.value:SetPoint("CENTER", object.powerbar, "CENTER", 0, 0);

    object.motext = object:CreateFontString(nil, "OVERLAY");
    object.motext:SetFont(STANDARD_TEXT_FONT, ns.configs.mousefontsize, "OUTLINE");
    object.motext:SetText(mouseoverIcon);

    return object;
end

local function init_pool()
    for i = 1, CONFIG_POOL_SIZE do
        objects[i] = create_frame();
    end
end

function ns.get_asframe()
    point = point + 1;

    if objects[point] == nil then
        objects[point] = create_frame();
    end

    local ret = objects[point];
    objects[point] = nil;

    return ret;
end

function ns.free_asframe(asframe)
    if point == 0 then
        return;
    end

    objects[point] = asframe;
    point = point - 1;
end

init_pool();
