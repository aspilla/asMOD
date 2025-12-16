local _, ns              = ...;

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

local function on_update_rune(self)
    if not self.start then
        return;
    end


    local curr_time = GetTime();
    local curr_duration = curr_time - self.start;

    self.update = 0

    if self.reverse then
        if curr_duration < self.duration then
            self:SetMinMaxValues(0, self.duration * 10)
            self:SetValue((self.duration * 10) - (curr_time - self.start) * 10)
        else
            self:SetMinMaxValues(0, self.duration)
            self:SetValue(0)
            self.start = nil;
        end
    else
        if curr_duration < self.duration then
            self:SetMinMaxValues(0, self.duration * 10)
            self:SetValue((curr_time - self.start) * 10)
        else
            self:SetMinMaxValues(0, self.duration)
            self:SetValue(self.duration)
            self.start = nil;
        end
    end
end
local _, Class = UnitClass("player")
local color = RAID_CLASS_COLORS[Class];
local runeIndexes = { 1, 2, 3, 4, 5, 6 };
function ns.update_rune()
    table.sort(runeIndexes, compare_rune);

    local combobars = ns.combobars;
    for i, index in ipairs(runeIndexes) do
        local start, duration, runeReady = GetRuneCooldown(index);

        if runeReady then
            combobars[i].start = nil;

            combobars[i]:SetStatusBarColor(color.r, color.g, color.b);
            combobars[i]:SetMinMaxValues(0, 1)
            combobars[i]:SetValue(1)
            if combobars[i].ctimer then
                combobars[i].ctimer:Cancel();
            end
        else
            combobars[i]:SetStatusBarColor(1, 1, 1)
            combobars[i].start = start;
            combobars[i].duration = duration;

            local cb = function()
                on_update_rune(combobars[i]);
            end
            if combobars[i].ctimer == nil or combobars[i].ctimer:IsCancelled() then
                combobars[i].ctimer = C_Timer.NewTicker(0.1, cb);
            end
        end
    end
end