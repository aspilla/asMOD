local _, ns = ...;
ASMOD_asUnitFrame = {};

local configs = {
    updaterate = 0.1,
    width = 200,
    xpoint = 225,
    ypoint = -198,
    healthheight = 35,
    powerheight = 5,
    buffcount = 4,
    buffsize = 25,
    font = STANDARD_TEXT_FONT,
    framelevel = 900,
};

ns.isevoker = false;
ns.unit_player = "player";
ns.unit_pet = "pet";
ns.unitframes = {};

local region = GetCurrentRegion();

if region == 2 and GetLocale() ~= "koKR" then
    configs.font = "Fonts\\2002.ttf";
end

local function update_debuffanchor(frames, index, offsetX, right, parent, width)
    local buff = frames[index];

    if (index == 1) then
        buff:SetPoint("TOPLEFT", parent.healthbar, "BOTTOMLEFT", 0, -(configs.powerheight / 2 + 2));
    else
        buff:SetPoint("BOTTOMLEFT", frames[index - 1], "BOTTOMRIGHT", offsetX, 0);
    end

    buff:SetWidth(width - offsetX);
    buff:SetHeight(width * 0.8);
end

local function createdebuffframes(parent, bright, fontsize, width, count)
    if parent.debuffframes == nil then
        parent.debuffframes = {};
    end

    for idx = 1, count do
        parent.debuffframes[idx] = CreateFrame("Button", nil, parent, "AUFDebuffFrameTemplate");
        local frame = parent.debuffframes[idx];

        frame.cooldown:SetDrawSwipe(true);
        for _, r in next, { frame.cooldown:GetRegions() } do
            if r:GetObjectType() == "FontString" then
                r:SetFont(STANDARD_TEXT_FONT, fontsize, "OUTLINE");
                r:ClearAllPoints();
                r:SetPoint("CENTER", frame, "TOP", 0, -1);
                r:SetDrawLayer("OVERLAY");
                break
            end
        end

        frame.count:SetFont(STANDARD_TEXT_FONT, fontsize, "OUTLINE")
        frame.count:ClearAllPoints()
        frame.count:SetPoint("CENTER", frame, "BOTTOM", 0, 0);
        frame.count:SetTextColor(0, 1, 0);

        frame.icon:SetTexCoord(.08, .92, .16, .84);
        frame.icon:SetAlpha(1);


        frame.border:SetTexCoord(0.08, 0.08, 0.08, 0.92, 0.92, 0.08, 0.92, 0.92);
        frame.border:SetVertexColor(0, 0, 0);
        frame.border:SetAlpha(1);

        frame:ClearAllPoints();
        update_debuffanchor(parent.debuffframes, idx, 1, bright, parent, width / count);

        frame:EnableMouse(false);
        frame:Hide();
    end
end

local function update_buffanchor(frames, index, offsetX, right, parent, width)
    local buff = frames[index];

    if (index == 1) then
        buff:SetPoint("RIGHT", parent.healthbar, "LEFT", -offsetX, 0);
    else
        buff:SetPoint("RIGHT", frames[index - 1], "LEFT", -offsetX, 0);
    end

    buff:SetWidth(width - offsetX);
    buff:SetHeight(width * 0.8);
end

local function create_buffframes(parent, bright, fontsize, width, count)
    if parent.buffframes == nil then
        parent.buffframes = {};
    end

    for idx = 1, count do
        parent.buffframes[idx] = CreateFrame("Button", nil, parent, "AUFDebuffFrameTemplate");
        local frame = parent.buffframes[idx];

        frame.cooldown:SetDrawSwipe(true);
        for _, r in next, { frame.cooldown:GetRegions() } do
            if r:GetObjectType() == "FontString" then
                r:SetFont(STANDARD_TEXT_FONT, fontsize, "OUTLINE");
                r:ClearAllPoints();
                r:SetPoint("CENTER", frame, "TOP", 0, -1);
                r:SetDrawLayer("OVERLAY");
                break
            end
        end

        frame.count:SetFont(STANDARD_TEXT_FONT, fontsize, "OUTLINE")
        frame.count:ClearAllPoints()
        frame.count:SetPoint("CENTER", frame, "BOTTOM", 0, 0);
        frame.count:SetTextColor(0, 1, 0);

        frame.icon:SetTexCoord(.08, .92, .16, .84);
        frame.icon:SetAlpha(1);


        frame.border:SetTexCoord(0.08, 0.08, 0.08, 0.92, 0.92, 0.08, 0.92, 0.92);
        frame.border:SetVertexColor(1, 1, 1);
        frame.border:SetAlpha(1);

        frame:ClearAllPoints();
        update_buffanchor(parent.buffframes, idx, 2, bright, parent, width);

        frame:EnableMouse(false);
        frame:Hide();
    end
end

local function update_totemanchor(frames, index, offsetX, right, parent, width)
    local button = frames[index];

    if (index == 1) then
        button:SetPoint("TOPRIGHT", parent, "BOTTOMRIGHT", 0, -2);
    else
        button:SetPoint("BOTTOMRIGHT", frames[index - 1], "BOTTOMLEFT", -offsetX, 0);
    end

    -- Resize
    button:SetWidth(width);
    button:SetHeight(width * 0.8);
    button.Icon:SetWidth(width);
    button.Icon:SetHeight(width * 0.8);
end

local function create_totemframes(parent, bright, fontsize, width, count)
    if parent.totembuttons == nil then
        parent.totembuttons = {};
    end

    for idx = 1, count do
        parent.totembuttons[idx] = CreateFrame("Button", nil, parent, "asTotemButtonTemplate");
        local button = parent.totembuttons[idx];
        local frame = button.Icon;

        frame.cooldown:SetDrawSwipe(true);
        for _, r in next, { frame.cooldown:GetRegions() } do
            if r:GetObjectType() == "FontString" then
                r:SetFont(STANDARD_TEXT_FONT, fontsize, "OUTLINE");
                r:ClearAllPoints();
                r:SetPoint("BOTTOM", 0, -5);
                r:SetDrawLayer("OVERLAY");
                break
            end
        end

        frame.icon:SetTexCoord(.08, .92, .16, .84);
        frame.icon:SetAlpha(1);

        frame.border:SetTexCoord(0.08, 0.08, 0.08, 0.92, 0.92, 0.08, 0.92, 0.92);
        frame.border:SetVertexColor(0, 0, 0);
        frame.border:SetAlpha(1);

        button:ClearAllPoints();
        update_totemanchor(parent.totembuttons, idx, 1, bright, parent, (width / 2 - 3) / count);
        frame:Show();
        button:SetAttribute("type", "destroytotem");
        button:SetAttribute("totem-slot", idx);
        button:SetAlpha(0);
        button:Show();
    end

    return;
end

local function on_unitevent(self, event, arg1, arg2)
    if event == "PLAYER_TOTEM_UPDATE" then
        ns.update_totems(self);
    end
end

local function create_unitframe(frame, unit, x, y, width, height, powerbarheight, fontsize, debuffupdate, is_small)
    local FontOutline = "OUTLINE";


    frame:ClearAllPoints();
    frame:SetPoint("CENTER", UIParent, "CENTER", x, y);
    frame:SetSize(width, height)
    frame:SetFrameStrata("LOW");
    frame:SetFrameLevel(configs.framelevel);

    frame.range = frame:CreateTexture(nil, "ARTWORK");
    frame.range:SetColorTexture(0.8, 0, 0);
    frame.range:SetAlpha(0.3);
    frame.range:SetAllPoints(frame);
    frame.range:Hide();

    frame.healthbar = CreateFrame("StatusBar", nil, frame);
    frame.healthbar:SetStatusBarTexture("RaidFrame-Hp-Fill");
    frame.healthbar:SetFrameLevel(configs.framelevel - 20);
    frame.healthbar:GetStatusBarTexture():SetHorizTile(false)
    frame.healthbar:SetMinMaxValues(0, 100)
    frame.healthbar:SetValue(100)
    frame.healthbar:SetHeight(height);
    frame.healthbar:Show();

    if x < 0 then
        frame.healthbar:SetPoint("TOPRIGHT", frame, "TOPRIGHT", 0, 0);
    else
        frame.healthbar:SetPoint("TOPLEFT", frame, "TOPLEFT", 0, 0);
    end

    frame.targetborder = frame.healthbar:CreateTexture(nil, "BACKGROUND", nil, -8)
    frame.targetborder:SetTexture("Interface\\Addons\\asUnitFrame\\border.tga")
    frame.targetborder:SetPoint("TOPLEFT", frame, "TOPLEFT", -2, 2);
    frame.targetborder:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", 2, -2);
    frame.targetborder:SetTexCoord(0.08, 0.08, 0.08, 0.92, 0.92, 0.08, 0.92, 0.92);
    frame.targetborder:SetVertexColor(1, 1, 1)
    frame.targetborder:SetAlpha(1);
    frame.targetborder:Hide();

    local hwidth = width;

    if ns.options.ShowPortrait then
        hwidth = width - height * 1.1;

        frame.portrait = CreateFrame("Button", nil, frame, "AUFDebuffFrameTemplate");
        frame.portrait:SetFrameLevel(configs.framelevel - 20);
        local pframe = frame.portrait;
        pframe.cooldown:SetDrawSwipe(true);
        for _, r in next, { pframe.cooldown:GetRegions() } do
            if r:GetObjectType() == "FontString" then
                r:SetFont(STANDARD_TEXT_FONT, fontsize, "OUTLINE");
                r:ClearAllPoints();
                r:SetPoint("CENTER", 0, 0);
                r:SetDrawLayer("OVERLAY");
                break
            end
        end

        pframe.count:SetFont(STANDARD_TEXT_FONT, fontsize, "OUTLINE")
        pframe.count:ClearAllPoints()
        pframe.count:SetPoint("BOTTOMRIGHT", pframe.icon, "BOTTOMRIGHT", -2, 2);

        pframe.portrait:SetTexCoord(.08, .92, .08, .92);
        pframe.portrait:SetAlpha(1);
        pframe.icon:SetTexCoord(.08, .92, .08, .92);
        pframe.icon:SetAlpha(1);
        pframe.border:SetTexCoord(0.08, 0.08, 0.08, 0.92, 0.92, 0.08, 0.92, 0.92);
        pframe.border:SetVertexColor(0, 0, 0)
        pframe.border:SetAlpha(1);

        pframe:SetSize(height * 1.1, height + 2);

        if x < 0 then
            pframe:SetPoint("TOPRIGHT", frame.healthbar, "TOPLEFT", 0, 1);
        else
            pframe:SetPoint("TOPLEFT", frame.healthbar, "TOPRIGHT", 0, 1);
        end
        pframe.portrait:Show();
        pframe:Show();
    end

    frame.healthbar:SetWidth(hwidth);

    frame.healthbar.absorbBar = CreateFrame("StatusBar", nil, frame);
    frame.healthbar.absorbBar:SetFrameLevel(configs.framelevel - 15);
    frame.healthbar.absorbBar:SetStatusBarTexture("RaidFrame-Hp-Fill");
    frame.healthbar.absorbBar:SetMinMaxValues(0, 100)
    frame.healthbar.absorbBar:SetStatusBarColor(0.5, 0.5, 0.5, 0.5);
    frame.healthbar.absorbBar:SetValue(0)
    frame.healthbar.absorbBar:SetHeight(height);
    frame.healthbar.absorbBar:SetAllPoints(frame.healthbar);
    frame.healthbar.absorbBar:Show();

    frame.healthbar.healabsorbBar = CreateFrame("StatusBar", nil, frame);
    frame.healthbar.healabsorbBar:SetFrameLevel(configs.framelevel - 10);
    frame.healthbar.healabsorbBar:SetStatusBarTexture("RaidFrame-Hp-Fill");
    frame.healthbar.healabsorbBar:SetMinMaxValues(0, 100)
    frame.healthbar.healabsorbBar:SetStatusBarColor(0.7, 0.47, 0.05, 0.5);
    frame.healthbar.healabsorbBar:SetValue(0)
    frame.healthbar.healabsorbBar:SetHeight(height);
    frame.healthbar.healabsorbBar:SetAllPoints(frame.healthbar);
    frame.healthbar.healabsorbBar:Show();

    frame.healthbar.incominghealBar = CreateFrame("StatusBar", nil, frame);
    frame.healthbar.incominghealBar:SetFrameLevel(configs.framelevel - 5);
    frame.healthbar.incominghealBar:SetStatusBarTexture("RaidFrame-Hp-Fill");
    frame.healthbar.incominghealBar:SetMinMaxValues(0, 100)
    frame.healthbar.incominghealBar:SetStatusBarColor(0.3, 0.8, 0.3, 0.5);
    frame.healthbar.incominghealBar:SetValue(0)
    frame.healthbar.incominghealBar:SetHeight(height);
    frame.healthbar.incominghealBar:SetAllPoints(frame.healthbar);
    frame.healthbar.incominghealBar:Show();


    frame.healthbar.bg = frame.healthbar:CreateTexture(nil, "BACKGROUND");
    frame.healthbar.bg:SetPoint("TOPLEFT", frame.healthbar, "TOPLEFT", -1, 1);
    frame.healthbar.bg:SetPoint("BOTTOMRIGHT", frame.healthbar, "BOTTOMRIGHT", 1, -1);

    frame.healthbar.bg:SetTexture("Interface\\Addons\\asUnitFrame\\border.tga");
    frame.healthbar.bg:SetTexCoord(0.1, 0.1, 0.1, 0.1, 0.1, 0.1, 0.1, 0.1);
    frame.healthbar.bg:SetVertexColor(0, 0, 0, 1);

    frame.pvalue = frame:CreateFontString(nil, "ARTWORK");
    frame.pvalue:SetFont(STANDARD_TEXT_FONT, fontsize + 1, FontOutline);
    frame.pvalue:SetTextColor(1, 1, 1, 1)

    frame.hvalue = frame:CreateFontString(nil, "ARTWORK");
    frame.hvalue:SetFont(STANDARD_TEXT_FONT, fontsize - 1, FontOutline);
    frame.hvalue:SetTextColor(1, 1, 1, 1)

    frame.name = frame:CreateFontString(nil, "ARTWORK");
    frame.name:SetFont(configs.font, fontsize, FontOutline);
    frame.name:SetTextColor(1, 1, 1, 1)

    frame.aggro = frame.healthbar:CreateFontString(nil, "ARTWORK");
    frame.aggro:SetFont(STANDARD_TEXT_FONT, fontsize, FontOutline);
    frame.aggro:SetTextColor(1, 1, 1, 1)

    frame.classtext = frame.healthbar:CreateFontString(nil, "ARTWORK");
    frame.classtext:SetFont(STANDARD_TEXT_FONT, fontsize - 1, FontOutline);
    frame.classtext:SetTextColor(1, 1, 1, 1)


    if x < 0 then
        frame.pvalue:SetPoint("LEFT", frame.healthbar, "LEFT", 2, 0);
        frame.hvalue:SetPoint("RIGHT", frame.healthbar, "RIGHT", -2, 0);
        frame.name:SetPoint("BOTTOMLEFT", frame, "TOPLEFT", 2, 1);
        frame.classtext:SetPoint("BOTTOMRIGHT", frame, "TOPRIGHT", -2, 1);
        frame.aggro:SetPoint("BOTTOMRIGHT", frame.classtext, "BOTTOMLEFT", -1, 0);
    else
        frame.pvalue:SetPoint("RIGHT", frame.healthbar, "RIGHT", -2, 0);
        frame.hvalue:SetPoint("LEFT", frame.healthbar, "LEFT", 2, 0);
        frame.name:SetPoint("BOTTOMRIGHT", frame, "TOPRIGHT", -2, 1);
        frame.classtext:SetPoint("BOTTOMLEFT", frame, "TOPLEFT", 2, 1);
        frame.aggro:SetPoint("BOTTOMLEFT", frame.classtext, "BOTTOMRIGHT", 1, 0);
    end

    if is_small then
        frame.classtext:Hide();
        frame.aggro:Hide();
    end

    frame.is_small = is_small;

    frame.mark = frame.healthbar:CreateTexture(nil, "ARTWORK");
    frame.mark:SetTexture("Interface\\TargetingFrame\\UI-RaidTargetingIcons");
    frame.mark:SetWidth(fontsize + 2);
    frame.mark:SetHeight(fontsize + 2);
    frame.mark:SetPoint("CENTER", frame.healthbar, "CENTER", 0, 0);

    frame.powerbar = CreateFrame("StatusBar", nil, frame);
    frame.powerbar:SetStatusBarTexture("RaidFrame-Hp-Fill")
    frame.powerbar:GetStatusBarTexture():SetHorizTile(false)
    frame.powerbar:SetMinMaxValues(0, 100)
    frame.powerbar:SetValue(100)
    frame.powerbar:SetWidth(hwidth / 2);
    frame.powerbar:SetHeight(powerbarheight)
    frame.powerbar:SetPoint("CENTER", frame.healthbar, "BOTTOM", 0, 0);
    frame.powerbar:SetFrameLevel(frame.healthbar:GetFrameLevel() + 3);
    frame.powerbar:Show();

    frame.powerbar.bg = frame.powerbar:CreateTexture(nil, "BACKGROUND");
    frame.powerbar.bg:SetPoint("TOPLEFT", frame.powerbar, "TOPLEFT", -1, 1);
    frame.powerbar.bg:SetPoint("BOTTOMRIGHT", frame.powerbar, "BOTTOMRIGHT", 1, -1);

    frame.powerbar.bg:SetTexture("Interface\\Addons\\asUnitFrame\\border.tga");
    frame.powerbar.bg:SetTexCoord(0.1, 0.1, 0.1, 0.1, 0.1, 0.1, 0.1, 0.1);
    frame.powerbar.bg:SetVertexColor(0, 0, 0, 1);

    frame.powerbar.value = frame.powerbar:CreateFontString(nil, "ARTWORK");
    frame.powerbar.value:SetFont(STANDARD_TEXT_FONT, fontsize - 2, FontOutline);
    frame.powerbar.value:SetTextColor(1, 1, 1, 1)
    frame.powerbar.value:SetPoint("CENTER", frame.powerbar, "CENTER", 0, 0);

    local castbarheight = height - 5;

    frame.castbar = CreateFrame("StatusBar", nil, frame)
    frame.castbar:SetPoint("TOPRIGHT", frame, "BOTTOMRIGHT", 0, -3);
    frame.castbar:SetStatusBarTexture("RaidFrame-Hp-Fill")
    frame.castbar:GetStatusBarTexture():SetHorizTile(false)
    frame.castbar:SetMinMaxValues(0, 100)
    frame.castbar:SetValue(100)
    frame.castbar:SetHeight(castbarheight)
    frame.castbar:SetWidth(width - ((castbarheight + 1) * 1.2));
    frame.castbar:SetStatusBarColor(1, 0.9, 0.9);
    frame.castbar:SetAlpha(1);

    frame.castbar.bg = frame.castbar:CreateTexture(nil, "BACKGROUND")
    frame.castbar.bg:SetPoint("TOPLEFT", frame.castbar, "TOPLEFT", -1, 1)
    frame.castbar.bg:SetPoint("BOTTOMRIGHT", frame.castbar, "BOTTOMRIGHT", 1, -1)

    frame.castbar.bg:SetTexture("Interface\\Addons\\asUnitFrame\\border.tga")
    frame.castbar.bg:SetTexCoord(0.1, 0.1, 0.1, 0.1, 0.1, 0.1, 0.1, 0.1)
    frame.castbar.bg:SetVertexColor(0, 0, 0, 1);
    frame.castbar.bg:Show();

    frame.castbar.name = frame.castbar:CreateFontString(nil, "OVERLAY");
    frame.castbar.name:SetFont(STANDARD_TEXT_FONT, fontsize - 1);
    frame.castbar.name:SetPoint("LEFT", frame.castbar, "LEFT", 3, 0);

    frame.castbar.time = frame.castbar:CreateFontString(nil, "OVERLAY");
    frame.castbar.time:SetFont(STANDARD_TEXT_FONT, fontsize - 1);
    frame.castbar.time:SetPoint("RIGHT", frame.castbar, "RIGHT", -3, 0);

    frame.castbar:EnableMouse(false);
    frame.castbar:Hide();

    frame.castbar.button = CreateFrame("Button", nil, frame.castbar, "AUFFrameTemplate");
    frame.castbar.button:SetPoint("RIGHT", frame.castbar, "LEFT", -2, 0)
    frame.castbar.button:SetWidth((castbarheight + 1) * 1.1);
    frame.castbar.button:SetHeight(castbarheight + 1);
    frame.castbar.button:SetAlpha(1);
    frame.castbar.button:EnableMouse(false);
    frame.castbar.button.icon:SetTexCoord(.08, .92, .08, .92);
    frame.castbar.button.border:SetTexCoord(0.08, 0.08, 0.08, 0.92, 0.92, 0.08, 0.92, 0.92);
    frame.castbar.button.border:SetVertexColor(0, 0, 0);
    frame.castbar.button.border:Show();
    frame.castbar.button:Show();

    frame.castbar.targetname = frame.castbar:CreateFontString(nil, "OVERLAY");
    frame.castbar.targetname:SetFont(configs.font, fontsize - 1);
    frame.castbar.targetname:SetPoint("TOPRIGHT", frame.castbar, "BOTTOMRIGHT", 0, -2);
    frame.debuffupdate = false;
    frame.totemupdate = false;

    if debuffupdate and ns.options.ShowDebuff then
        createdebuffframes(frame, true, fontsize, width, 4);
        frame.debuffupdate = true;
    end

    if ns.options.ShowTotemBar and unit == "player" then
        create_totemframes(frame, true, fontsize, width, MAX_TOTEMS);
        frame:RegisterEvent("PLAYER_TOTEM_UPDATE");
        frame.totemupdate = true;
    end

    frame.updatecount = 1;
    frame.istargetframe = (unit == "target");
    frame.isplayerframe = (unit == "player");

    if unit == "focus" or string.find(unit, "boss") then
        frame.updateCastBar = true;
        ns.register_castevents(frame.castbar, unit);
        if ns.options.ShowBossBuff and unit ~= "focus" then
            create_buffframes(frame, true, fontsize, configs.buffsize, configs.buffcount);
            frame.buffupdate = true;
        else
            frame.buffupdate = false;
        end
    else
        frame.updateCastBar = false;
        frame.buffupdate = false
    end

    frame.unit = unit;
    ns.unitframes[unit] = frame;

    SecureUnitButton_OnLoad(frame, unit);
    frame:SetAttribute("*type2", "togglemenu");
    frame:RegisterForClicks("AnyUp")
    Mixin(frame, PingableType_UnitFrameMixin);
    frame:SetAttribute("ping-receiver", true);

    if unit == "player" then
        frame:Show();
    else
        RegisterStateDriver(frame, "visibility", "[@" .. unit .. ",exists] show; hide");
    end

    if unit == "focus" or string.find(unit, "boss") then
        frame.bchecktarget = true;
    else
        frame.bchecktarget = false;
    end

    frame:SetScript("OnEvent", on_unitevent);

    frame.callback = function()
        ns.update_unitframe(frame);
    end


    C_Timer.NewTicker(configs.updaterate, frame.callback);
end

local function init(parent)
    ns.setup_option();

    parent.PlayerFrame = CreateFrame("Button", nil, UIParent, "AUFUnitButtonTemplate");
    parent.TargetFrame = CreateFrame("Button", nil, UIParent, "AUFUnitButtonTemplate");
    parent.FocusFrame = CreateFrame("Button", nil, UIParent, "AUFUnitButtonTemplate");
    parent.PetFrame = CreateFrame("Button", nil, UIParent, "AUFUnitButtonTemplate");
    parent.TargetTargetFrame = CreateFrame("Button", nil, UIParent, "AUFUnitButtonTemplate");


    create_unitframe(parent.PlayerFrame, "player", -configs.xpoint, configs.ypoint, configs.width, configs.healthheight,
        configs.powerheight, 12, false,
        false);
    create_unitframe(parent.TargetFrame, "target", configs.xpoint, configs.ypoint, configs.width, configs.healthheight,
        configs.powerheight, 12, false,
        false);
    create_unitframe(parent.FocusFrame, "focus", configs.xpoint + configs.width, configs.ypoint, configs.width - 50,
        configs.healthheight - 15,
        configs.powerheight - 2,
        11,
        false, true);
    create_unitframe(parent.PetFrame, "pet", -configs.xpoint - 50, configs.ypoint - 40, configs.width - 100,
        configs.healthheight - 20,
        configs.powerheight - 3,
        9,
        true, true);
    create_unitframe(parent.TargetTargetFrame, "targettarget", configs.xpoint + 50, configs.ypoint - 40,
        configs.width - 100,
        configs.healthheight - 20,
        configs.powerheight - 3, 9, true, true);

    parent.BossFrames = {};
    if (MAX_BOSS_FRAMES) then
        for i = 1, MAX_BOSS_FRAMES do
            parent.BossFrames[i] = CreateFrame("Button", nil, UIParent, "AUFUnitButtonTemplate");
            create_unitframe(parent.BossFrames[i], "boss" .. i, configs.xpoint + 250, 200 - (i - 1) * 70,
                configs.width - 50,
                configs.healthheight - 15, configs.powerheight - 2, 11);
        end
    end

 
    local libasConfig = LibStub:GetLibrary("LibasConfig", true);

	if libasConfig then		
        libasConfig.load_position(parent.PlayerFrame, "PlayerFrame", AUF_Positions.PlayerFrame);
        libasConfig.load_position(parent.TargetFrame, "TargetFrame", AUF_Positions.TargetFrame);
        libasConfig.load_position(parent.FocusFrame, "FocusFrame", AUF_Positions.FocusFrame);
        libasConfig.load_position(parent.PetFrame, "PetFrame", AUF_Positions.PetFrame);
        libasConfig.load_position(parent.TargetTargetFrame, "TargetTargetFrame", AUF_Positions.TargetTargetFrame);

        if (MAX_BOSS_FRAMES) then
            for i = 1, MAX_BOSS_FRAMES do
                libasConfig.load_position(parent.BossFrames[i], "BossFrame" .. i, AUF_Positions.BossFrames[i]);
            end
        end
	end

    local _, engclass = UnitClass("player");

    if engclass == "EVOKER" or engclass == "DEMONHUNTER" then
        ns.isevoker = true;
    end
end

local function check_unitauras(unit)
    local frame = ns.unitframes[unit];
    ns.update_auras(frame);
end

local bfirst = true;
local function on_mainevent(self, event, arg1, arg2, arg3)
    if bfirst then
        init(ASMOD_asUnitFrame);
        bfirst = false;
    end

    if event == "PLAYER_ENTERING_WORLD" then
        ns.HideDefaults();
    elseif (event == "PLAYER_REGEN_ENABLED" or event == "PLAYER_REGEN_DISABLED") then
        check_unitauras("target");
        check_unitauras("targettarget");
    elseif event == "UNIT_TARGET" then
        check_unitauras("targettarget")
    elseif event == "PLAYER_TARGET_CHANGED" then
        check_unitauras("target");
        check_unitauras("targettarget");
    elseif event == "UNIT_PORTRAIT_UPDATE" then
        local frame = ns.unitframes[arg1];
        if frame and frame.portrait then
            SetPortraitTexture(frame.portrait.portrait, frame.unit, false);
        end
    elseif event == "PORTRAITS_UPDATED" then
        for _, frame in pairs(ns.unitframes) do
            if frame.portrait then
                SetPortraitTexture(frame.portrait.portrait, frame.unit, false);
            end
        end
    elseif event == "PLAYER_FOCUS_CHANGED" then
        check_unitauras("focus");
    elseif (event == "INSTANCE_ENCOUNTER_ENGAGE_UNIT") then
        for i = 1, MAX_BOSS_FRAMES do
            local unit = "boss" .. i;
            check_unitauras(unit);
        end
    end
end
local main_frame = CreateFrame("Frame");
main_frame:SetScript("OnEvent", on_mainevent)
main_frame:RegisterEvent("PLAYER_ENTERING_WORLD");
main_frame:RegisterEvent("PLAYER_REGEN_ENABLED");
main_frame:RegisterEvent("PLAYER_REGEN_DISABLED");
main_frame:RegisterEvent("UNIT_PORTRAIT_UPDATE");
main_frame:RegisterEvent("PORTRAITS_UPDATED");
main_frame:RegisterEvent("PLAYER_FOCUS_CHANGED");
main_frame:RegisterEvent("INSTANCE_ENCOUNTER_ENGAGE_UNIT");
main_frame:RegisterUnitEvent("UNIT_TARGET", "target");
main_frame:RegisterEvent("PLAYER_TARGET_CHANGED");
