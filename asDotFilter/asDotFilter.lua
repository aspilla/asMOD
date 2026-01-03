local _, ns = ...;

local configs = {
    size = 30,
    maxshow = 2,
    alpha = 0.9,
    cooldownfontsize = 12,
    countfontsize = 13,

    --설정 표시할 Unit
    unitlist = {
        ["focus"] = true, -- 주시대상 표시 안하길 원하면 이 줄 삭제
        ["boss1"] = true,
        ["boss2"] = true,
        ["boss3"] = true,
        ["boss4"] = true,
        ["boss5"] = true,
    },
};

local parentframes = {
    ["target"] = { frame = _G["TargetFrame"], isboss = false },
    ["focus"] = { frame = _G["FocusFrame"], isboss = false },
    ["boss1"] = { frame = _G["Boss1TargetFrame"], isboss = true },
    ["boss2"] = { frame = _G["Boss2TargetFrame"], isboss = true },
    ["boss3"] = { frame = _G["Boss3TargetFrame"], isboss = true },
    ["boss4"] = { frame = _G["Boss4TargetFrame"], isboss = true },
    ["boss5"] = { frame = _G["Boss5TargetFrame"], isboss = true },
};

local filter = AuraUtil.CreateFilterString(AuraUtil.AuraFilters.Harmful, AuraUtil.AuraFilters.Player);
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

--설정 끝
local main_frame = CreateFrame("Frame", "ADotF", UIParent);

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

local function update_anchor(frames, index, size, offsetX, right, parent, isboss)
    local buff = frames[index];
    local point1 = "LEFT";
    local point2 = "RIGHT";
    local point3 = "RIGHT";

    if (right == false) then
        point1 = "RIGHT";
        point2 = "LEFT";
        point3 = "LEFT";
        offsetX = -offsetX;
    end

    if (index == 1) then
        if isboss then
            buff:SetPoint(point1, parent, point2, -50, 0);
        else
            buff:SetPoint(point1, parent, point2, 3, 0);
        end
    else
        buff:SetPoint(point1, frames[index - 1], point3, offsetX, 0);
    end

    -- Resize
    buff:SetWidth(size);
    buff:SetHeight(size * 0.8);
end


local function set_debuff(frame, unit, aura, color)
    frame.icon:SetTexture(aura.icon);

    frame.count:Show();
    frame.count:SetText(C_UnitAuras.GetAuraApplicationDisplayCount(unit, aura.auraInstanceID, 1, 100));

    set_cooldownframe(frame.cooldown, aura.expirationTime, aura.duration, true);


    frame.border:SetVertexColor(color.r, color.g, color.b);
end



local function update_debuffs(unit)
    local numdebuffs = 1;
    local parent;
    local isboss;


    if not configs.unitlist[unit] then
        return;
    end

    if not main_frame.units then
        main_frame.units = {};
    end

    if not main_frame.units[unit] then
        main_frame.units[unit] = {};
        main_frame.units[unit].frames = {};
    end

    if UnitExists(unit) then
        local parentinfo = parentframes[unit];
        if parentinfo then
            parent = parentinfo.frame;
            isboss = parentinfo.isboss;
        else
            return;
        end

        local aura_list = C_UnitAuras.GetUnitAuras(unit, filter, configs.maxshow);

        for _, aura in ipairs(aura_list) do
            if numdebuffs > configs.maxshow then
                break;
            end

            local frame = main_frame.units[unit].frames[numdebuffs];

            if (not frame) then
                main_frame.units[unit].frames[numdebuffs] = CreateFrame("Button", nil, main_frame,
                    "asTargetDotFrameTemplate");
                frame = main_frame.units[unit].frames[numdebuffs];
                frame:EnableMouse(false);
                frame.cooldown:SetDrawSwipe(true);
                for _, r in next, { frame.cooldown:GetRegions() } do
                    if r:GetObjectType() == "FontString" then
                        r:SetFont(STANDARD_TEXT_FONT, configs.cooldownfontsize, "OUTLINE");
                        r:ClearAllPoints();
                        r:SetPoint("TOP", 0, 5);
                        r:SetDrawLayer("OVERLAY");
                        break;
                    end
                end

                frame.icon:SetTexCoord(.08, .92, .16, .84);
                frame.icon:SetAlpha(configs.alpha);
                frame.border:SetTexCoord(0.08, 0.08, 0.08, 0.92, 0.92, 0.08, 0.92, 0.92);
                frame.border:SetAlpha(configs.alpha);

                frame.count:SetFont(STANDARD_TEXT_FONT, configs.countfontsize, "OUTLINE");
                frame.count:ClearAllPoints();
                frame.count:SetPoint("CENTER", frame, "BOTTOM", 0, 1);
		        frame.count:SetTextColor(0, 1, 0);

                frame.snapshot:SetFont(STANDARD_TEXT_FONT, configs.countfontsize - 1, "OUTLINE")
                frame.snapshot:ClearAllPoints();
                frame.snapshot:SetPoint("CENTER", frame, "BOTTOM", 0, 1);
                frame:ClearAllPoints();
                update_anchor(main_frame.units[unit].frames, numdebuffs, configs.size, 2, true, parent, isboss);
            end

            local color = C_UnitAuras.GetAuraDispelTypeColor(unit, aura.auraInstanceID, colorcurve);
            set_debuff(frame, unit, aura, color);
            frame:Show();

            numdebuffs = numdebuffs + 1;
        end
    end

    for i = numdebuffs, configs.maxshow do
        local frame = main_frame.units[unit].frames[i];

        if (frame) then
            frame:Hide();
        end
    end
end


local function update_allframes()
    for unit, _ in pairs(configs.unitlist) do
        update_debuffs(unit);
    end
end

local function on_event(self, event)
    local unit;

    if (event == "PLAYER_FOCUS_CHANGED") then
        unit = "focus"
        update_debuffs(unit);
    elseif (event == "PLAYER_TARGET_CHANGED") then
        unit = "target";
        update_debuffs(unit);
    elseif (event == "INSTANCE_ENCOUNTER_ENGAGE_UNIT") then
        update_allframes();
    elseif (event == "PLAYER_ENTERING_WORLD") then
        update_allframes();
    end
end

local function on_update()
    update_allframes();
end

local function init()
    main_frame:SetPoint("CENTER", 0, 0)
    main_frame:SetWidth(1)
    main_frame:SetHeight(1)
    main_frame:SetScale(1)
    main_frame:Show()
    main_frame:RegisterEvent("PLAYER_FOCUS_CHANGED")
    main_frame:RegisterEvent("PLAYER_TARGET_CHANGED")
    main_frame:RegisterEvent("INSTANCE_ENCOUNTER_ENGAGE_UNIT")
    main_frame:RegisterEvent("PLAYER_ENTERING_WORLD")
    main_frame:SetScript("OnEvent", on_event)
    C_Timer.NewTicker(0.2, on_update);

    local bloaded = C_AddOns.LoadAddOn("asUnitFrame");

    if bloaded then
        parentframes = {
            ["target"] = { frame = ASMOD_asUnitFrame.TargetFrame, isboss = false },
            ["focus"] = { frame = ASMOD_asUnitFrame.FocusFrame, isboss = false },
            ["boss1"] = { frame = ASMOD_asUnitFrame.BossFrames[1], isboss = false },
            ["boss2"] = { frame = ASMOD_asUnitFrame.BossFrames[2], isboss = false },
            ["boss3"] = { frame = ASMOD_asUnitFrame.BossFrames[3], isboss = false },
            ["boss4"] = { frame = ASMOD_asUnitFrame.BossFrames[4], isboss = false },
            ["boss5"] = { frame = ASMOD_asUnitFrame.BossFrames[5], isboss = false },
        };
    end
end

C_Timer.After(1, init);
