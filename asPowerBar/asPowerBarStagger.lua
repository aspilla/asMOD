local _, ns = ...;

local function update_stagger()
    local val = UnitStagger("player");
    local valmax = UnitHealthMax("player");

    ns.combocountbar:SetMinMaxValues(0, valmax)
    ns.combocountbar:SetValue(val)
    ns.combotext:SetText(val);
end


local function on_event()
    update_stagger();
end

local main_frame = CreateFrame("Frame");
main_frame:SetScript("OnEvent", on_event);


function ns.setup_stagger(bstagger)
    if bstagger and ns.options.ShowClassResource then
        main_frame:RegisterUnitEvent("UNIT_AURA", "player");
        update_stagger();
        ns.combocountbar:SetStatusBarColor(ns.classcolor.r, ns.classcolor.g, ns.classcolor.b);
        ns.combocountbar.bg:SetVertexColor(0, 0, 0, 1);
        ns.combocountbar:Show();
        ns.combotext:Show();        
    end
end

function ns.clear_stagger()
    main_frame:UnregisterEvent("UNIT_AURA");
end
