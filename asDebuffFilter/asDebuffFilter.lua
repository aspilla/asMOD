local _, ns = ...;
local main_frame = CreateFrame("Frame", nil, UIParent);

local function clear_cooldownframe(self)
    self:Clear();
end

local function set_cooldownframe(self, extime, duration, enable)
    if enable then
        self:SetDrawEdge(nil);
        self:SetCooldownFromExpirationTime(extime, duration, nil);
    else
        clear_cooldownframe(self);
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

local function create_privateframes(parent)
    if parent.PrivateAuraAnchors == nil then
        parent.PrivateAuraAnchors = {};
    end


    local size = ns.configs.size + 5;

    size = size * ns.options.PlayerDebuffRate;

    for idx = 1, 2 do
        parent.PrivateAuraAnchors[idx] = CreateFrame("Frame", nil, parent, "asDebuffPrivateAuraAnchorTemplate");
        parent.PrivateAuraAnchors[idx].auraIndex = idx;
        parent.PrivateAuraAnchors[idx]:SetSize(size, size * ns.configs.sizerate);
        parent.PrivateAuraAnchors[idx]:SetUnit("player");

        if idx == 2 then
            parent.PrivateAuraAnchors[idx]:ClearAllPoints();
            parent.PrivateAuraAnchors[idx]:SetPoint("RIGHT", parent.PrivateAuraAnchors[1], "LEFT", -1, 0);
        end
    end

    return;
end

local filters = {}
filters["target"] = AuraUtil.CreateFilterString(AuraUtil.AuraFilters.Harmful, AuraUtil.AuraFilters.Player);
filters["player"] = AuraUtil.CreateFilterString(AuraUtil.AuraFilters.Harmful);

local activeDebuffs = {};

local function set_debuff(frame, unit, aura, color)
    frame.icon:SetTexture(aura.icon);
    frame.count:SetText(C_UnitAuras.GetAuraApplicationDisplayCount(unit, aura.auraInstanceID, 1, 100));
    set_cooldownframe(frame.cooldown, aura.expirationTime, aura.duration, true);

    if color then
        frame.border:SetVertexColor(color.r, color.g, color.b);
    else
        frame.border:SetVertexColor(0, 0, 0);
    end
end

local debuffinfo = {
    [0] = DEBUFF_TYPE_NONE_COLOR,
    [1] = DEBUFF_TYPE_MAGIC_COLOR,
    [2] = DEBUFF_TYPE_CURSE_COLOR,
    [3] = DEBUFF_TYPE_DISEASE_COLOR,
    [4] = DEBUFF_TYPE_POISON_COLOR,
    [9] = DEBUFF_TYPE_BLEED_COLOR, -- enrage
    [11] = DEBUFF_TYPE_BLEED_COLOR,
};
local colorcurve = C_CurveUtil.CreateColorCurve();
colorcurve:SetType(Enum.LuaCurveType.Step);
for dispeltype, v in pairs(debuffinfo) do
    colorcurve:AddPoint(dispeltype, v);
end


local function update_frames(unit, auraList, numAuras)
    local i = 0;
    local parent = main_frame.target_frame;

    if (unit == "player") then
        parent = main_frame.player_frame;
    end


    for _index, aura in ipairs(auraList) do
        i = i + 1;
        if i > numAuras then
            break;
        end

        local frame = parent.frames[i];

        frame.unit = unit;
        frame.auraid = aura.auraInstanceID;
        frame.filter = filters[unit];

        local color = C_UnitAuras.GetAuraDispelTypeColor(unit, aura.auraInstanceID, colorcurve);

        set_debuff(frame, unit, aura, color);
        frame:Show();
    end

    for j = i + 1, ns.configs.max_debuffs do
        local frame = parent.frames[j];

        if (frame) then
            frame:Hide();
        end
    end

    if parent == main_frame.player_frame then
        parent.PrivateAuraAnchors[1]:ClearAllPoints();
        if i == 0 then
            parent.PrivateAuraAnchors[1]:SetPoint("BOTTOMRIGHT", main_frame.player_frame, "BOTTOMLEFT", 0, 0);
        else
            parent.PrivateAuraAnchors[1]:SetPoint("BOTTOMRIGHT", parent.frames[i], "BOTTOMLEFT", -1, 0);
        end
    end
end

local function update_auras(unit)
    activeDebuffs[unit] = C_UnitAuras.GetUnitAuras(unit, filters[unit], ns.configs.max_debuffs);
    update_frames(unit, activeDebuffs[unit], ns.configs.max_debuffs);
end

local function clear_frames()
    for i = 1, ns.configs.max_debuffs do
        local frame = main_frame.target_frame.frames[i];

        if (frame) then
            frame:Hide();
        end
    end
end

local function set_combatalpha()
    if ns.options.CombatAlphaChange then
        if UnitAffectingCombat("player") then
            main_frame:SetAlpha(ns.configs.combat_alpha);
        else
            main_frame:SetAlpha(ns.configs.normal_alpha);
        end
    end
end

local function on_event(self, event, arg1, ...)
    if (event == "UNIT_AURA") then
        update_auras(arg1);
    elseif (event == "PLAYER_TARGET_CHANGED") then
        clear_frames();
        update_auras("target");
    elseif (event == "PLAYER_ENTERING_WORLD") then
        update_auras("target");
        update_auras("player");
        set_combatalpha();
    elseif event == "PLAYER_REGEN_DISABLED" then
        set_combatalpha();
    elseif event == "PLAYER_REGEN_ENABLED" then
        set_combatalpha();
    end
end

local function on_update()
    if (UnitExists("target")) then
        update_auras("target");
    end
end

local function update_anchor(frames, index, offsetX, right, parent)
    local buff = frames[index];
    local point1 = "LEFT";
    local point2 = "LEFT";
    local point3 = "RIGHT";

    if (right == false) then
        point1 = "RIGHT";
        point2 = "RIGHT";
        point3 = "LEFT";
        offsetX = -offsetX;
    end

    if (index == 1) then
        buff:SetPoint(point1, parent, point2, 0, 0);
    else
        buff:SetPoint(point1, frames[index - 1], point3, offsetX, 0);
    end
end


local function create_frames(parent, bright, rate)
    if parent.frames == nil then
        parent.frames = {};
    end

    for idx = 1, ns.configs.max_debuffs do
        parent.frames[idx] = CreateFrame("Button", nil, parent, "asTargetDebuffFrameTemplate");
        local frame = parent.frames[idx];
        frame.cooldown:SetDrawSwipe(true);

        for _, r in next, { frame.cooldown:GetRegions() } do
            if r:GetObjectType() == "FontString" then
                r:SetFont(STANDARD_TEXT_FONT, ns.configs.cool_fontsize * rate, "OUTLINE");
                r:ClearAllPoints();
                r:SetPoint("TOP", 0, 5);
                r:SetDrawLayer("OVERLAY");
                break;
            end
        end
        frame.icon:SetTexCoord(.08, .92, .16, .84);
        frame.border:SetTexCoord(0.08, 0.08, 0.08, 0.92, 0.92, 0.08, 0.92, 0.92);

        frame.count:SetFont(STANDARD_TEXT_FONT, ns.configs.count_fontsize, "OUTLINE")
        frame.count:ClearAllPoints();
        frame.count:SetPoint("CENTER", frame, "BOTTOM", 0, 1);
        frame.count:SetTextColor(0, 1, 0);

        frame.point:SetFont(STANDARD_TEXT_FONT, ns.configs.count_fontsize - 3, "OUTLINE")
        frame.point:ClearAllPoints();
        frame.point:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", -2, 2);
        frame.point:SetTextColor(0, 1, 0);

        frame.snapshot:SetFont(STANDARD_TEXT_FONT, ns.configs.count_fontsize - 1, "OUTLINE")
        frame.snapshot:ClearAllPoints();
        frame.snapshot:SetPoint("CENTER", frame, "BOTTOM", 0, 1);

        frame:ClearAllPoints();
        update_anchor(parent.frames, idx, 1, bright, parent);
        -- Resize
        frame:SetWidth(ns.configs.size * rate);
        frame:SetHeight(ns.configs.size * ns.configs.sizerate * rate);

        if not frame:GetScript("OnEnter") then
            frame:SetScript("OnEnter", function(self)
                if self.auraid then
                    GameTooltip_SetDefaultAnchor(GameTooltip, self);
                    GameTooltip:SetUnitDebuffByAuraInstanceID(self.unit, self.auraid, self.filter);
                end
            end)
            frame:SetScript("OnLeave", function()
                GameTooltip:Hide();
            end)
        end

        frame:EnableMouse(false);
        frame:SetMouseMotionEnabled(true);
        frame:Hide();
    end

    return;
end


local function init()
    ns.setup_option();
    local libasConfig = LibStub:GetLibrary("LibasConfig", true);

    main_frame:SetPoint("CENTER", 0, 0)
    main_frame:SetWidth(1)
    main_frame:SetHeight(1)
    main_frame:Show()

    main_frame.target_frame = CreateFrame("Frame", nil, main_frame)

    main_frame.target_frame:SetPoint("CENTER", ns.configs.target_xpoint, ns.configs.target_ypoint)
    main_frame.target_frame:SetWidth(1)
    main_frame.target_frame:SetHeight(1)
    main_frame.target_frame:Show()

    create_frames(main_frame.target_frame, true, 1);

    if libasConfig then
        libasConfig.load_position(main_frame.target_frame, "asDebuffFilter(Target)", ADF_Positions_1);
    end



    main_frame.player_frame = CreateFrame("Frame", nil, main_frame)

    main_frame.player_frame:SetPoint("CENTER", ns.configs.player_xpoint, ns.configs.player_ypoint)
    main_frame.player_frame:SetWidth(1)
    main_frame.player_frame:SetHeight(1)
    main_frame.player_frame:Show()

    create_frames(main_frame.player_frame, false, ns.options.PlayerDebuffRate);
    create_privateframes(main_frame.player_frame);

    if libasConfig then
        libasConfig.load_position(main_frame.player_frame, "asDebuffFilter(Player)", ADF_Positions_2);
    end

    main_frame:RegisterEvent("PLAYER_TARGET_CHANGED")
    main_frame:RegisterUnitEvent("UNIT_AURA", "player");
    main_frame:RegisterEvent("PLAYER_ENTERING_WORLD");
    main_frame:RegisterEvent("PLAYER_REGEN_DISABLED");
    main_frame:RegisterEvent("PLAYER_REGEN_ENABLED");

    main_frame:SetScript("OnEvent", on_event)

    --주기적으로 Callback
    C_Timer.NewTicker(0.2, on_update);
    update_auras("target");
    update_auras("player");
    set_combatalpha();
end

C_Timer.After(1, init);
