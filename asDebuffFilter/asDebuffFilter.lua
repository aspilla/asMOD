local _, ns = ...;
local ADF;
local ADF_PLAYER_DEBUFF;
local ADF_TARGET_DEBUFF;


local function asCooldownFrame_Clear(self)
    self:Clear();
end

local function asCooldownFrame_Set(self, extime, duration, enable)
    if enable then
        self:SetDrawEdge(nil);
        self:SetCooldownFromExpirationTime(extime, duration, nil);
    else
        asCooldownFrame_Clear(self);
    end
end

asDebuffPrivateAuraAnchorMixin = {};

function asDebuffPrivateAuraAnchorMixin:SetUnit(unit)
    if unit == self.unit then
        return;
    end
    self.unit = unit;

    if self.anchorID then
        C_UnitAuras.RemovePrivateAuraAnchor(self.anchorID);
        self.anchorID = nil;
    end

    if unit then
        local iconAnchor =
        {
            point = "CENTER",
            relativeTo = self,
            relativePoint = "CENTER",
            offsetX = 0,
            offsetY = 0,
        };

        local privateAnchorArgs = {};
        privateAnchorArgs.unitToken = unit;
        privateAnchorArgs.auraIndex = self.auraIndex;
        privateAnchorArgs.parent = self;
        privateAnchorArgs.showCountdownFrame = true;
        privateAnchorArgs.showCountdownNumbers = true;

        privateAnchorArgs.iconInfo =
        {
            iconAnchor = iconAnchor,
            iconWidth = self:GetWidth(),
            iconHeight = self:GetHeight(),
        };
        privateAnchorArgs.durationAnchor = nil;

        self.anchorID = C_UnitAuras.AddPrivateAuraAnchor(privateAnchorArgs);
    end
end

local function CreatPrivateFrames(parent)
    if parent.PrivateAuraAnchors == nil then
        parent.PrivateAuraAnchors = {};
    end


    local size = ns.ADF_SIZE + 5;

    size = size * ns.options.PlayerDebuffRate;

    for idx = 1, 2 do
        parent.PrivateAuraAnchors[idx] = CreateFrame("Frame", nil, parent, "asDebuffPrivateAuraAnchorTemplate");
        parent.PrivateAuraAnchors[idx].auraIndex = idx;
        parent.PrivateAuraAnchors[idx]:SetSize(size, size * 0.8);
        parent.PrivateAuraAnchors[idx]:SetUnit("player");

        if idx == 2 then
            parent.PrivateAuraAnchors[idx]:ClearAllPoints();
            parent.PrivateAuraAnchors[idx]:SetPoint("RIGHT", parent.PrivateAuraAnchors[1], "LEFT", -1, 0);
        end
    end

    return;
end

local AuraFilters =
{
    Helpful = "HELPFUL",
    Harmful = "HARMFUL",
    Raid = "RAID",
    IncludeNameplateOnly = "INCLUDE_NAME_PLATE_ONLY",
    Player = "PLAYER",
    Cancelable = "CANCELABLE",
    NotCancelable = "NOT_CANCELABLE",
    Maw = "MAW",
};

local function CreateFilterString(...)
    return table.concat({ ... }, '|');
end


local filters = {}
filters["target"] = CreateFilterString(AuraFilters.Harmful, AuraFilters.Player);
filters["player"] = CreateFilterString(AuraFilters.Harmful);

local activeDebuffs = {};

local function SetDebuff(frame, unit, aura, color, size)
    frame.icon:SetTexture(aura.icon);
    frame:Show();

    frame.count:Show();
    frame.count:SetText(C_UnitAuras.GetAuraApplicationDisplayCount(unit, aura.auraInstanceID, 1, 100));

    asCooldownFrame_Set(frame.cooldown, aura.expirationTime, aura.duration, true);

    frame.border:SetVertexColor(color.r, color.g, color.b);


    frame:SetWidth(size);
    frame:SetHeight(size * 0.8);
end

local debuffinfo = {
	[1] = DEBUFF_TYPE_MAGIC_COLOR,
	[2] = DEBUFF_TYPE_CURSE_COLOR,
	[3] = DEBUFF_TYPE_DISEASE_COLOR,
	[4] = DEBUFF_TYPE_POISON_COLOR, 
	[5] = DEBUFF_TYPE_BLEED_COLOR, 
	[0] = DEBUFF_TYPE_NONE_COLOR,
};
local colorcurve = C_CurveUtil.CreateColorCurve();
colorcurve:SetType(Enum.LuaCurveType.Step);
for dispeltype, v in pairs(debuffinfo) do
    colorcurve:AddPoint(dispeltype, v);
end


local function UpdateAuraFrames(unit, auraList, numAuras)
    local i = 0;
    local parent = ADF_TARGET_DEBUFF;

    if (unit == "player") then
        parent = ADF_PLAYER_DEBUFF;
    end


    for _index, aura in ipairs(auraList) do
        i = i + 1;
        if i > numAuras then
            break;
        end

        local frame = parent.frames[i];

        frame.unit = unit;
        frame.auraInstanceID = aura.auraInstanceID;

        local color = C_UnitAuras.GetAuraDispelTypeColor(unit, aura.auraInstanceID, colorcurve);
        local size = ns.ADF_SIZE + 4;

        if unit == "player" then
            size = size * ns.options.PlayerDebuffRate;
        end

        SetDebuff(frame, unit, aura, color, size);
    end

    for j = i + 1, ns.ADF_MAX_DEBUFF_SHOW do
        local frame = parent.frames[j];

        if (frame) then
            frame:Hide();
            frame.data = {};
        end
    end

    if parent == ADF_PLAYER_DEBUFF then
        parent.PrivateAuraAnchors[1]:ClearAllPoints();
        if i == 0 then
            parent.PrivateAuraAnchors[1]:SetPoint("BOTTOMRIGHT", ADF_PLAYER_DEBUFF, "BOTTOMLEFT", 0, 0);
        else
            parent.PrivateAuraAnchors[1]:SetPoint("BOTTOMRIGHT", parent.frames[i], "BOTTOMLEFT", -1, 0);
        end
    end
end

local function UpdateAuras(unit)
    activeDebuffs[unit] = C_UnitAuras.GetUnitAuras(unit, filters[unit], ns.ADF_MAX_DEBUFF_SHOW);
    UpdateAuraFrames(unit, activeDebuffs[unit], ns.ADF_MAX_DEBUFF_SHOW);
end

function ADF_ClearFrame()
    for i = 1, ns.ADF_MAX_DEBUFF_SHOW do
        local frame = ADF_TARGET_DEBUFF.frames[i];

        if (frame) then
            frame:Hide();
            frame.data = {};
        end
    end
end

function ADF_OnEvent(self, event, arg1, ...)
    if (event == "UNIT_AURA") then
        local info = ...;
        UpdateAuras(arg1, info);
    elseif (event == "PLAYER_TARGET_CHANGED") then
        ADF_ClearFrame();
        UpdateAuras("target");
    elseif (event == "PLAYER_ENTERING_WORLD") then
        UpdateAuras("target");
        UpdateAuras("player");
    elseif event == "PLAYER_REGEN_DISABLED" then
        ADF:SetAlpha(ns.ADF_AlphaCombat);
    elseif event == "PLAYER_REGEN_ENABLED" then
        ADF:SetAlpha(ns.ADF_AlphaNormal);
    end
end

local function OnUpdate()
    if (UnitExists("target")) then
        UpdateAuras("target");
    end
end

local function ADF_UpdateDebuffAnchor(frames, index, offsetX, right, parent)
    local buff = frames[index];
    local point1 = "BOTTOMLEFT";
    local point2 = "BOTTOMLEFT";
    local point3 = "BOTTOMRIGHT";

    if (right == false) then
        point1 = "BOTTOMRIGHT";
        point2 = "BOTTOMRIGHT";
        point3 = "BOTTOMLEFT";
        offsetX = -offsetX;
    end

    if (index == 1) then
        buff:SetPoint(point1, parent, point2, 0, 0);
    else
        buff:SetPoint(point1, frames[index - 1], point3, offsetX, 0);
    end

    -- Resize
    buff:SetWidth(ns.ADF_SIZE);
    buff:SetHeight(ns.ADF_SIZE * 0.8);
end


local function CreatDebuffFrames(parent, bright, rate)
    if parent.frames == nil then
        parent.frames = {};
    end

    for idx = 1, ns.ADF_MAX_DEBUFF_SHOW do
        parent.frames[idx] = CreateFrame("Button", nil, parent, "asTargetDebuffFrameTemplate");
        local frame = parent.frames[idx];
        frame.cooldown:SetDrawSwipe(true);

        for _, r in next, { frame.cooldown:GetRegions() } do
            if r:GetObjectType() == "FontString" then
                r:SetFont(STANDARD_TEXT_FONT, ns.ADF_CooldownFontSize * rate, "OUTLINE");
                r:ClearAllPoints();
                r:SetPoint("TOP", 0, 5);
                r:SetDrawLayer("OVERLAY");
                break;
            end
        end
        frame.icon:SetTexCoord(.08, .92, .16, .84);
        frame.icon:SetAlpha(ns.ADF_ALPHA);
        frame.border:SetTexCoord(0.08, 0.08, 0.08, 0.92, 0.92, 0.08, 0.92, 0.92);
        frame.border:SetAlpha(ns.ADF_ALPHA);

        frame.count:SetFont(STANDARD_TEXT_FONT, ns.ADF_CountFontSize, "OUTLINE")
        frame.count:ClearAllPoints();
        frame.count:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", -2, 2);

        frame.point:SetFont(STANDARD_TEXT_FONT, ns.ADF_CountFontSize - 3, "OUTLINE")
        frame.point:ClearAllPoints();
        frame.point:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", -2, 2);
        frame.point:SetTextColor(0, 1, 0);

        frame.snapshot:SetFont(STANDARD_TEXT_FONT, ns.ADF_CountFontSize - 1, "OUTLINE")
        frame.snapshot:ClearAllPoints();
        frame.snapshot:SetPoint("CENTER", frame, "BOTTOM", 0, 1);

        frame:ClearAllPoints();
        ADF_UpdateDebuffAnchor(parent.frames, idx, 1, bright, parent);
        frame:EnableMouse(false);
        frame.data = {};
        frame:Hide();
    end

    return;
end


local function ADF_Init()
    ns.SetupOptionPanels();
    local bloaded = C_AddOns.LoadAddOn("asMOD")

    ADF = CreateFrame("Frame", nil, UIParent)

    ADF:SetPoint("CENTER", 0, 0)
    ADF:SetWidth(1)
    ADF:SetHeight(1)
    ADF:SetScale(1)
    ADF:SetAlpha(ns.ADF_AlphaNormal);
    ADF:Show()

    ADF_TARGET_DEBUFF = CreateFrame("Frame", nil, ADF)

    ADF_TARGET_DEBUFF:SetPoint("CENTER", ns.ADF_TARGET_DEBUFF_X, ns.ADF_TARGET_DEBUFF_Y)
    ADF_TARGET_DEBUFF:SetWidth(1)
    ADF_TARGET_DEBUFF:SetHeight(1)
    ADF_TARGET_DEBUFF:SetScale(1)
    ADF_TARGET_DEBUFF:Show()

    CreatDebuffFrames(ADF_TARGET_DEBUFF, true, 1);

    if bloaded and asMOD_setupFrame then
        asMOD_setupFrame(ADF_TARGET_DEBUFF, "asDebuffFilter(Target)");
    end

    ADF_PLAYER_DEBUFF = CreateFrame("Frame", nil, ADF)

    ADF_PLAYER_DEBUFF:SetPoint("CENTER", ns.ADF_PLAYER_DEBUFF_X, ns.ADF_PLAYER_DEBUFF_Y)
    ADF_PLAYER_DEBUFF:SetWidth(1)
    ADF_PLAYER_DEBUFF:SetHeight(1)
    ADF_PLAYER_DEBUFF:SetScale(1)
    ADF_PLAYER_DEBUFF:Show()

    CreatDebuffFrames(ADF_PLAYER_DEBUFF, false, ns.options.PlayerDebuffRate);
    CreatPrivateFrames(ADF_PLAYER_DEBUFF);

    if bloaded and asMOD_setupFrame then
        asMOD_setupFrame(ADF_PLAYER_DEBUFF, "asDebuffFilter(Player)");
    end

    ADF:RegisterEvent("PLAYER_TARGET_CHANGED")
    ADF:RegisterUnitEvent("UNIT_AURA", "player");
    ADF:RegisterEvent("PLAYER_ENTERING_WORLD");
    ADF:RegisterEvent("PLAYER_REGEN_DISABLED");
    ADF:RegisterEvent("PLAYER_REGEN_ENABLED");
    ADF:RegisterEvent("TRAIT_CONFIG_UPDATED");
    ADF:RegisterEvent("TRAIT_CONFIG_LIST_UPDATED");
    ADF:RegisterEvent("ACTIVE_TALENT_GROUP_CHANGED");
    ADF:RegisterUnitEvent("UNIT_PET", "player")


    ADF:SetScript("OnEvent", ADF_OnEvent)

    --주기적으로 Callback
    C_Timer.NewTicker(0.2, OnUpdate);
    UpdateAuras("target");
    UpdateAuras("player");
end

C_Timer.After(1, ADF_Init);
