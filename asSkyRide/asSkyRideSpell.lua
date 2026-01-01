local _, ns = ...;
ns.maxcombos = {};
local statusbarcolors = {
    [1] = {r = 0.3, g = 0.8, b = 1},
    [2] = {r = 0.1, g = 0.6, b = 1},
}

local function setup_max_combo(max, index)
    if issecretvalue(max) then
        return;
    end

    if max == 0 then
        return;
    end
    
    ns.maxcombos[index] = max;

    local width = (ns.config.width - (1 * (max - 1))) / max;
    local combobars = ns.combobars[index];

    for i = 1, 10 do
        combobars[i]:Hide();
    end

    for i = 1, max do
        local combobar = combobars[i];
        combobar:SetWidth(width)
        combobar:SetMinMaxValues(0, 1);
        combobar:SetValue(0);
        combobar:Show();
    end
end

local function check_spellcooldown(spellid, index)
    local chargeinfo = C_Spell.GetSpellCharges(spellid);
    local durationinfo = C_Spell.GetSpellChargeDuration(spellid);

    if chargeinfo and durationinfo and not issecretvalue(chargeinfo.currentCharges) then
        setup_max_combo(chargeinfo.maxCharges, index);

        local combobars = ns.combobars[index];

        for i = 1, ns.maxcombos[index] do
            local combobar = combobars[i];
            if i <= chargeinfo.currentCharges then                
                local color = statusbarcolors[index];
                combobar:SetStatusBarColor(color.r, color.g, color.b);
                combobar:SetMinMaxValues(0, 1);
                combobar:SetValue(1);
            elseif i == chargeinfo.currentCharges + 1 then
                combobar:SetStatusBarColor(0.5, 0.5, 0.5);
                combobar:SetTimerDuration(durationinfo);
            else
                combobar:SetMinMaxValues(0, 1);
                combobar:SetValue(0);
            end
        end
    end
end

local function update_spell()
    if not IsFlying("player") then
        return;
    end

    check_spellcooldown(372608, 1);
    check_spellcooldown(425782, 2);
end

C_Timer.NewTicker(0.2, update_spell);
