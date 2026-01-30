local _, ns = ...;

local function compare_rune(runeAIndex, runeBIndex)
    local runeAStart, runeADuration, runeARuneReady = GetRuneCooldown(runeAIndex);
    local runeBStart, runeBDuration, runeBRuneReady = GetRuneCooldown(runeBIndex);

    if (runeARuneReady ~= runeBRuneReady) then
        return runeARuneReady;
    end

    if (runeAStart ~= runeBStart) then
        return runeAStart < runeBStart;
    end

    return runeAIndex < runeBIndex;
end

local function on_update_rune(runebar)
    if not runebar.start then
        return;
    end

    local curr_time = GetTime();
    local curr_duration = curr_time - runebar.start;

    if curr_duration < runebar.duration then
        runebar:SetMinMaxValues(0, runebar.duration)
        runebar:SetValue((curr_time - runebar.start), Enum.StatusBarInterpolation.ExponentialEaseOut)
    else
        runebar:SetMinMaxValues(0, runebar.duration)
        runebar:SetValue(runebar.duration, Enum.StatusBarInterpolation.ExponentialEaseOut)
        runebar.start = nil;
    end
end

local _, Class = UnitClass("player")
local color = RAID_CLASS_COLORS[Class];
local runeIndexes = { 1, 2, 3, 4, 5, 6 };

local function update_rune()
    table.sort(runeIndexes, compare_rune);

    local runebars = ns.combobars;
    for i, index in ipairs(runeIndexes) do
        local start, duration, runeReady = GetRuneCooldown(index);
        local runebar = runebars[i];

        if runeReady then
            runebar.start = nil;

            runebar:SetStatusBarColor(color.r, color.g, color.b);
            runebar:SetMinMaxValues(0, 1)
            runebar:SetValue(1)
            if runebar.ctimer then
                runebar.ctimer:Cancel();
            end
        else
            runebar:SetStatusBarColor(1, 1, 1)
            runebar.start = start;
            runebar.duration = duration;

            local cb = function()
                on_update_rune(runebar);
            end
            if runebar.ctimer == nil or runebar.ctimer:IsCancelled() then
                runebar.ctimer = C_Timer.NewTicker(0.1, cb);
            end
        end
    end
end



local function on_event()
    update_rune();
end

local main_frame = CreateFrame("Frame");
main_frame:SetScript("OnEvent", on_event);


function ns.setup_rune(bupdate_rune)
    if bupdate_rune and ns.options.ShowClassResource then
        ns.setup_max_combo(6);
        update_rune()        
        main_frame:RegisterEvent("RUNE_POWER_UPDATE");
    end
end

function ns.clear_rune()
    main_frame:UnregisterEvent("RUNE_POWER_UPDATE");
end
