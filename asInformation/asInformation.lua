local _, ns = ...;

local configs = {
    combatalpha = 1,
    normalalpha = 0.5,
    updaterate = 0.2,
    x_point = -165 - 20,
    y_point = -300,
};

local main_frame = CreateFrame("Frame", "asInformationFrame", UIParent);
main_frame:SetFrameStrata("LOW");
main_frame:SetSize(100, 100);
main_frame:SetPoint("CENTER", UIParent, "CENTER", -165 -20, -300);


-- Stat Configurations
local statConfigs = {
    Stat = { abbr = "S", gemColor = { r = 1, g = 1, b = 0 } },
    Crit = { abbr = "C", gemColor = { r = 1, g = 0, b = 0 } },
    Haste = { abbr = "H", gemColor = { r = 0, g = 1, b = 0 } },
    Mastery = { abbr = "M", gemColor = { r = 0.5, g = 0, b = 1 } },
    Versatility = { abbr = "V", gemColor = { r = 0, g = 0, b = 1 } }
}

local defaultBarColor = { r = 0.5, g = 0.5, b = 0.5 }
local activatedTextColor = { r = 1, g = 1, b = 1 }

-- New data structures for tracking minimum stats over time
local statHistory = { Stat = {}, Crit = {}, Haste = {}, Mastery = {}, Versatility = {} }
local recentMinimumStats = { Stat = nil, Crit = nil, Haste = nil, Mastery = nil, Versatility = nil }




local function create_bar(name, parent, config)
    local bar = CreateFrame("StatusBar", "asInformation" .. name .. "Bar", parent);
    bar:SetSize(90, 12)
    bar:SetStatusBarTexture("RaidFrame-Hp-Fill")
    bar:SetStatusBarColor(config.gemColor.r, config.gemColor.g, config.gemColor.b);

    bar.minbar = CreateFrame("StatusBar", nil, bar);
    bar.minbar:SetAllPoints(bar)
    bar.minbar:SetStatusBarTexture("RaidFrame-Hp-Fill")
    bar.minbar:SetStatusBarColor(defaultBarColor.r, defaultBarColor.g, defaultBarColor.b);
    bar.minbar:SetFrameLevel(bar:GetFrameLevel() + 10);

    bar.bg = bar:CreateTexture(nil, "BACKGROUND")
    bar.bg:SetPoint("TOPLEFT", bar, "TOPLEFT", -1, 1)
    bar.bg:SetPoint("BOTTOMRIGHT", bar, "BOTTOMRIGHT", 1, -1)
    bar.bg:SetColorTexture(0, 0, 0, 1);

    bar.text = bar.minbar:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    bar.text:SetPoint("RIGHT", bar.minbar, "RIGHT", -1, 0)
    bar.text:SetTextColor(config.gemColor.r, config.gemColor.g, config.gemColor.b)

    bar.name = bar.minbar:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    bar.name:SetPoint("LEFT", bar.minbar, "LEFT", 1, 0)
    bar.name:SetTextColor(1, 1, 1);
    bar.name:SetText(config.abbr)

    return bar
end

local function init_frames()
    ns.primarybar = create_bar("PrimaryStat", main_frame, statConfigs.Stat)
    ns.critbar = create_bar("Crit", main_frame, statConfigs.Crit)
    ns.hastebar = create_bar("Haste", main_frame, statConfigs.Haste)
    ns.masterybar = create_bar("Mastery", main_frame, statConfigs.Mastery)
    ns.versbar = create_bar("Versatility", main_frame, statConfigs.Versatility)
end

ns.needreposition = true;

-- Function to get primary stat based on class, inspired by PaperDollFrame.lua
local function get_primarystat()
    local currspec = C_SpecializationInfo.GetSpecialization() or 1;
    local primaryStatID = select(6, C_SpecializationInfo.GetSpecializationInfo(currspec)) or 1;
    local primaryStatValue = UnitStat("player", primaryStatID);

    return primaryStatValue;
end

local critfunc = nil;

local function get_crit()
    if UnitAffectingCombat("player") then
        if critfunc then
            return critfunc();
        end
        return 0;
    end

    --PaperDollFrame_SetCritChance
    local spellCrit, rangedCrit, meleeCrit;
    local critChance;

    -- Start at 2 to skip physical damage
    spellCrit = GetSpellCritChance();
    rangedCrit = GetRangedCritChance();
    meleeCrit = GetCritChance();

    if issecretvalue(rangedCrit) or issecretvalue(spellCrit) or issecretvalue(meleeCrit) then
        if critfunc then
            return critfunc();
        end
        return 0;
    end

    if (spellCrit >= rangedCrit and spellCrit >= meleeCrit) then
        critfunc = GetSpellCritChance;
        critChance = spellCrit;
    elseif (rangedCrit >= meleeCrit) then
        critfunc = GetRangedCritChance;
        critChance = rangedCrit;
    else
        critfunc = GetCritChance;
        critChance = meleeCrit;
    end

    return critChance;
end

-- Function to record current stat values into history
local function recode_stats()
    local inCombat = UnitAffectingCombat("player");

    if not inCombat then
        local currentStats = {
            Stat = get_primarystat(),
            Crit = get_crit(),
            Haste = GetHaste(),
            Mastery = GetMasteryEffect(),
            Versatility = GetCombatRatingBonus(CR_VERSATILITY_DAMAGE_DONE),
        }


        for statName, value in pairs(currentStats) do
            if not issecretvalue(value) then
                local snapshot = { value = value }
                table.insert(statHistory[statName], 1, snapshot)

                local numList = #statHistory[statName];

                if numList > 100 then
                    table.remove(statHistory[statName], numList);
                end
            end
        end

        for statName, history in pairs(statHistory) do
            -- Calculate minimum from combat snapshots
            local minStat = nil
            for _, snapshot in ipairs(history) do
                if minStat == nil or (snapshot.value < minStat and snapshot.value > 0) then
                    minStat = snapshot.value
                end
            end
            recentMinimumStats[statName] = minStat
        end
    end
end

local function update_stats()
    if ns.needreposition then
        ns.needreposition = false;

        local prevframe = main_frame;
        local yOffset = -5;

    if ns.options.showPrimary then
        ns.primarybar:SetPoint("TOPLEFT", prevframe, (prevframe == main_frame and "TOPLEFT" or "BOTTOMLEFT"), 0,
            yOffset);
        ns.primarybar:Show();
        prevframe = ns.primarybar;
        yOffset = -2;
    else
        ns.primarybar:Hide();
    end

    if ns.options.showCrit then
        ns.critbar:SetPoint("TOPLEFT", prevframe, (prevframe == main_frame and "TOPLEFT" or "BOTTOMLEFT"), 0, yOffset);
        ns.critbar:Show();
        prevframe = ns.critbar;
        yOffset = -2;
    else
        ns.critbar:Hide();
    end

    if ns.options.showHaste then
        ns.hastebar:SetPoint("TOPLEFT", prevframe, (prevframe == main_frame and "TOPLEFT" or "BOTTOMLEFT"), 0,
            yOffset);
        ns.hastebar:Show();
        prevframe = ns.hastebar;
        yOffset = -2;
    else
        ns.hastebar:Hide();
    end

    if ns.options.showMastery then
        ns.masterybar:SetPoint("TOPLEFT", prevframe, (prevframe == main_frame and "TOPLEFT" or "BOTTOMLEFT"), 0,
            yOffset);
        ns.masterybar:Show();
        prevframe = ns.masterybar;
        yOffset = -2;
    else
        ns.masterybar:Hide();
    end

    if ns.options.showVer then
        ns.versbar:SetPoint("TOPLEFT", prevframe, (prevframe == main_frame and "TOPLEFT" or "BOTTOMLEFT"), 0,
            yOffset);
        ns.versbar:Show();
        prevframe = ns.versbar;
        yOffset = -2;
    else
        ns.versbar:Hide();
    end
    end

    local haste = GetHaste()
    local crit = get_crit()
    local mastery = GetMasteryEffect()
    local versatility = GetCombatRatingBonus(CR_VERSATILITY_DAMAGE_DONE) or 0;
    local primaryStatValue = get_primarystat()

    if ns.options.showCrit then
        if ns.critbar and ns.critbar.text then     -- Check if bar and text elements exist
            ns.critbar:SetMinMaxValues(0, 100) -- Assuming stats are percentage based 0-100
            ns.critbar:SetValue(crit, Enum.StatusBarInterpolation.ExponentialEaseOut)
            ns.critbar.text:SetText(string.format("%.2f%%", crit));

            local minCrit = recentMinimumStats.Crit or 0
            ns.critbar.minbar:SetMinMaxValues(0, 100) -- Assuming stats are percentage based 0-100
            ns.critbar.minbar:SetValue(minCrit, Enum.StatusBarInterpolation.ExponentialEaseOut);
        end
    end

    if ns.options.showHaste then
        if ns.hastebar and ns.hastebar.text then -- Check if bar and text elements exist
            ns.hastebar:SetMinMaxValues(0, 100)
            ns.hastebar:SetValue(haste, Enum.StatusBarInterpolation.ExponentialEaseOut)
            ns.hastebar.text:SetText(string.format("%.2f%%", haste))

            local minHaste = recentMinimumStats.Haste or 0;

            ns.hastebar.minbar:SetMinMaxValues(0, 100)
            ns.hastebar.minbar:SetValue(minHaste, Enum.StatusBarInterpolation.ExponentialEaseOut);
        end
    end

    if ns.options.showMastery then
        if ns.masterybar and ns.masterybar.text then -- Check if bar and text elements exist
            ns.masterybar:SetMinMaxValues(0, 100)
            ns.masterybar:SetValue(mastery, Enum.StatusBarInterpolation.ExponentialEaseOut)
            ns.masterybar.text:SetText(string.format("%.2f%%", mastery))

            local minMastery = recentMinimumStats.Mastery or 0;

            ns.masterybar.minbar:SetMinMaxValues(0, 100)
            ns.masterybar.minbar:SetValue(minMastery, Enum.StatusBarInterpolation.ExponentialEaseOut);
        end
    end

    if ns.options.showVer then
        if ns.versbar and ns.versbar.text then -- Check if bar and text elements exist
            ns.versbar:SetMinMaxValues(0, 100)
            ns.versbar:SetValue(versatility, Enum.StatusBarInterpolation.ExponentialEaseOut)
            ns.versbar.text:SetText(string.format("%.2f%%", versatility))

            local minVersatility = recentMinimumStats.Versatility or 0;
            ns.versbar.minbar:SetMinMaxValues(0, 100)
            ns.versbar.minbar:SetValue(minVersatility, Enum.StatusBarInterpolation.ExponentialEaseOut);
        end
    end

    if ns.options.showPrimary then
        if ns.primarybar and ns.primarybar.text then
            -- Assuming primary stats don't have a typical "max" like secondary stats for bar display,
            -- we can set a reasonable max or just display the value. Here, we'll set a nominal max.
            -- Or, we could calculate a "max" based on typical gear levels if desired.
            -- For now, just showing the value.
            local minStat = recentMinimumStats.Stat or 0;
            ns.primarybar:SetMinMaxValues(0, minStat * 2) -- Dynamic max based on current value for visual effect
            ns.primarybar:SetValue(primaryStatValue, Enum.StatusBarInterpolation.ExponentialEaseOut)
            ns.primarybar.text:SetText(string.format("%d", primaryStatValue))

            ns.primarybar.minbar:SetMinMaxValues(0, minStat * 2) -- Dynamic max based on current value for visual effect
            ns.primarybar.minbar:SetValue(minStat, Enum.StatusBarInterpolation.ExponentialEaseOut);
        end
    end
end


-- Variables for managing stat recording frequency

local function on_update()
    recode_stats()
    update_stats() -- This will use recentMinimumStats in the next plan step
end

local bfirst = true;

local function init()
    ns.setup_option();
    init_frames();

    local libasConfig = LibStub:GetLibrary("LibasConfig", true);

    if libasConfig then
        libasConfig.load_position(main_frame, "asInformation", AINF_Position);
    end

    -- No longer registering UNIT_AURA for stat activation
    bfirst = false;
    C_Timer.NewTicker(configs.updaterate, on_update); -- This ticker calls OnUpdate, which then calls UpdateStats
end

local function on_event(self, event, ...)
    local arg = ...;

    if event == "PLAYER_ENTERING_WORLD" then
        if UnitAffectingCombat("player") then
            main_frame:SetAlpha(configs.combatalpha);
        else
            main_frame:SetAlpha(configs.normalalpha);
        end
    elseif event == "PLAYER_REGEN_DISABLED" then
        main_frame:SetAlpha(configs.combatalpha);
    elseif event == "PLAYER_REGEN_ENABLED" then
        main_frame:SetAlpha(configs.normalalpha);
    elseif event == "ADDON_LOADED" and arg == "asInformation" and bfirst == true then
        C_Timer.After(0.5, init);
    end
end
main_frame:RegisterEvent("PLAYER_ENTERING_WORLD")
main_frame:RegisterEvent("PLAYER_REGEN_DISABLED");
main_frame:RegisterEvent("PLAYER_REGEN_ENABLED");
main_frame:RegisterEvent("ADDON_LOADED");
main_frame:SetScript("OnEvent", on_event)
