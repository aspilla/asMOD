local _, ns      = ...;

--고술 소용돌이
local stormspells = {
    [170588] = 1,
    [170587] = 2,
    [170586] = 3,
    [170585] = 4,
    [187890] = 5,
    [467442] = 10,
}

function ns.checkstorm(bhide, spellid)
    local combo = stormspells[spellid];

    if bhide == true then
        if spellid == 344176 or stormspells[spellid] then
            ns.show_combo(0, 10);
        end
    else
        if combo then
            ns.show_combo(combo, 10);
        end
    end
end