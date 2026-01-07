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


    local size = ns.configs.SIZE + 5;

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

local filters = {}
filters["target"] = AuraUtil.CreateFilterString(AuraUtil.AuraFilters.Harmful, AuraUtil.AuraFilters.Player);
filters["player"] = AuraUtil.CreateFilterString(AuraUtil.AuraFilters.Harmful);

local activeDebuffs = {};

local function set_debuff(frame, unit, aura, color, size)
    frame.icon:SetTexture(aura.icon);       
    frame.count:SetText(C_UnitAuras.GetAuraApplicationDisplayCount(unit, aura.auraInstanceID, 1, 100));
    set_cooldownframe(frame.cooldown, aura.expirationTime, aura.duration, true);
    frame.border:SetVertexColor(color.r, color.g, color.b);
    frame:SetWidth(size);
    frame:SetHeight(size * 0.8);
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
        frame.auraInstanceID = aura.auraInstanceID;

        local color = C_UnitAuras.GetAuraDispelTypeColor(unit, aura.auraInstanceID, colorcurve);
        local size = ns.configs.SIZE + 4;

        if unit == "player" then
            size = size * ns.options.PlayerDebuffRate;
        end

        set_debuff(frame, unit, aura, color, size);
        frame:Show();
    end

    for j = i + 1, ns.configs.MAX_DEBUFF_SHOW do
        local frame = parent.frames[j];

        if (frame) then
            frame:Hide();
            frame.data = {};
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
    activeDebuffs[unit] = C_UnitAuras.GetUnitAuras(unit, filters[unit], ns.configs.MAX_DEBUFF_SHOW);
    update_frames(unit, activeDebuffs[unit], ns.configs.MAX_DEBUFF_SHOW);
end

local function clear_frames()
    for i = 1, ns.configs.MAX_DEBUFF_SHOW do
        local frame = main_frame.target_frame.frames[i];

        if (frame) then
            frame:Hide();
            frame.data = {};
        end
    end
end

local function on_event(self, event, arg1, ...)
    if (event == "UNIT_AURA") then
        update_auras(arg1);
    elseif (event == "PLAYER_TARGET_CHANGED") then
        clear_frames();
        update_auras("target");
        if ns.options.CombatAlphaChange then
            if UnitAffectingCombat("player") then
			    main_frame:SetAlpha(ns.configs.AlphaCombat);
		    else
    			main_frame:SetAlpha(ns.configs.AlphaNormal);
		    end
        end
    elseif (event == "PLAYER_ENTERING_WORLD") then
        update_auras("target");
        update_auras("player");
    elseif event == "PLAYER_REGEN_DISABLED" then
        if ns.options.CombatAlphaChange then
            main_frame:SetAlpha(ns.configs.AlphaCombat);
        end
    elseif event == "PLAYER_REGEN_ENABLED" then
        if ns.options.CombatAlphaChange then
            main_frame:SetAlpha(ns.configs.AlphaNormal);
        end
    end
end

local function on_update()
    if (UnitExists("target")) then
        update_auras("target");
    end
end

local function update_anchor(frames, index, offsetX, right, parent)
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
end


local function create_frames(parent, bright, rate)
    if parent.frames == nil then
        parent.frames = {};
    end

    for idx = 1, ns.configs.MAX_DEBUFF_SHOW do
        parent.frames[idx] = CreateFrame("Button", nil, parent, "asTargetDebuffFrameTemplate");
        local frame = parent.frames[idx];
        frame.cooldown:SetDrawSwipe(true);

        for _, r in next, { frame.cooldown:GetRegions() } do
            if r:GetObjectType() == "FontString" then
                r:SetFont(STANDARD_TEXT_FONT, ns.configs.CooldownFontSize * rate, "OUTLINE");
                r:ClearAllPoints();
                r:SetPoint("TOP", 0, 5);
                r:SetDrawLayer("OVERLAY");
                break;
            end
        end
        frame.icon:SetTexCoord(.08, .92, .16, .84);
        frame.border:SetTexCoord(0.08, 0.08, 0.08, 0.92, 0.92, 0.08, 0.92, 0.92);
        
        frame.count:SetFont(STANDARD_TEXT_FONT, ns.configs.CountFontSize, "OUTLINE")
        frame.count:ClearAllPoints();
        frame.count:SetPoint("CENTER", frame, "BOTTOM", 0, 1);
		frame.count:SetTextColor(0, 1, 0);

        frame.point:SetFont(STANDARD_TEXT_FONT, ns.configs.CountFontSize - 3, "OUTLINE")
        frame.point:ClearAllPoints();
        frame.point:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", -2, 2);
        frame.point:SetTextColor(0, 1, 0);

        frame.snapshot:SetFont(STANDARD_TEXT_FONT, ns.configs.CountFontSize - 1, "OUTLINE")
        frame.snapshot:ClearAllPoints();
        frame.snapshot:SetPoint("CENTER", frame, "BOTTOM", 0, 1);

        frame:ClearAllPoints();
        update_anchor(parent.frames, idx, 1, bright, parent);
            -- Resize
        frame:SetWidth(ns.configs.SIZE);
        frame:SetHeight(ns.configs.SIZE * 0.8);
        frame:EnableMouse(false);
        frame.data = {};
        frame:Hide();
    end

    return;
end


local function init()
    ns.setup_option();
    local bloaded = C_AddOns.LoadAddOn("asMOD")
   
    main_frame:SetPoint("CENTER", 0, 0)
    main_frame:SetWidth(1)
    main_frame:SetHeight(1)
    main_frame:SetScale(1)    
    main_frame:Show()

    main_frame.target_frame = CreateFrame("Frame", nil, main_frame)

    main_frame.target_frame:SetPoint("CENTER", ns.configs.TARGET_DEBUFF_X, ns.configs.TARGET_DEBUFF_Y)
    main_frame.target_frame:SetWidth(1)
    main_frame.target_frame:SetHeight(1)
    main_frame.target_frame:SetScale(1)
    main_frame.target_frame:Show()

    create_frames(main_frame.target_frame, true, 1);

    if bloaded and ASMODOBJ.load_position then
        ASMODOBJ.load_position(main_frame.target_frame, "asDebuffFilter(Target)");
    end

    main_frame.player_frame = CreateFrame("Frame", nil, main_frame)

    main_frame.player_frame:SetPoint("CENTER", ns.configs.PLAYER_DEBUFF_X, ns.configs.PLAYER_DEBUFF_Y)
    main_frame.player_frame:SetWidth(1)
    main_frame.player_frame:SetHeight(1)
    main_frame.player_frame:SetScale(1)
    main_frame.player_frame:Show()

    create_frames(main_frame.player_frame, false, ns.options.PlayerDebuffRate);
    create_privateframes(main_frame.player_frame);

    if bloaded and ASMODOBJ.load_position then
        ASMODOBJ.load_position(main_frame.player_frame, "asDebuffFilter(Player)");
    end

    main_frame:RegisterEvent("PLAYER_TARGET_CHANGED")
    main_frame:RegisterUnitEvent("UNIT_AURA", "player");
    main_frame:RegisterEvent("PLAYER_ENTERING_WORLD");
    main_frame:RegisterEvent("PLAYER_REGEN_DISABLED");
    main_frame:RegisterEvent("PLAYER_REGEN_ENABLED");
    main_frame:RegisterEvent("TRAIT_CONFIG_UPDATED");
    main_frame:RegisterEvent("TRAIT_CONFIG_LIST_UPDATED");
    main_frame:RegisterEvent("ACTIVE_TALENT_GROUP_CHANGED");
    main_frame:RegisterUnitEvent("UNIT_PET", "player")


    main_frame:SetScript("OnEvent", on_event)

    --주기적으로 Callback
    C_Timer.NewTicker(0.2, on_update);
    update_auras("target");
    update_auras("player");
end

C_Timer.After(1, init);
