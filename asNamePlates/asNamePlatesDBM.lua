local _, ns = ...;

ns.dbm_event_list = {};

function asNamePlatesDBM_callback(event, id, ...)
    if event == "DBM_TimerStart" then
        local msg, timer, icon, type, spellId, colorId, modid, keep, fade, name, guid = ...;
        
        --if ns.options.ANameP_ShowDBM and type == "cd"  and string.find(id, "cdnp") or string.find(id, "nextnp") then
        if ns.options.ANameP_ShowDBM and type == "cd" and guid then
            ns.dbm_event_list[id] = {msg, timer, GetTime(), icon, 0, colorId, spellId, guid};
        end
    elseif event == "DBM_TimerStop" then
        ns.dbm_event_list[id] = nil;
    elseif event == "DBM_TimerUpdate" then
        local elapsed, totalTime = ...;
        if ns.dbm_event_list[id] then
            ns.dbm_event_list[id][5] = 0;
            ns.dbm_event_list[id][2] = totalTime;
            ns.dbm_event_list[id][3] = GetTime() - elapsed;
        end
    else
        -- print (...);
    end
end

local function initDBM()

    DBM:RegisterCallback("DBM_TimerStart", asNamePlatesDBM_callback);
    DBM:RegisterCallback("DBM_TimerStop", asNamePlatesDBM_callback);
    DBM:RegisterCallback("DBM_TimerFadeUpdate", asNamePlatesDBM_callback);
    DBM:RegisterCallback("DBM_TimerUpdate", asNamePlatesDBM_callback);
    DBM:RegisterCallback("DBM_TimerPause", asNamePlatesDBM_callback);
    DBM:RegisterCallback("DBM_TimerResume", asNamePlatesDBM_callback);

end

local bloaded = LoadAddOn("DBM-Core");
if bloaded then
    initDBM();
end
