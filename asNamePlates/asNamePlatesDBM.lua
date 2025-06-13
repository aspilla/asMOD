local _, ns = ...;

ns.dbm_event_list = {};

function asNamePlatesDBM_callback(event, id, ...)
    if event == "DBM_TimerStart" or event == "DBM_NameplateStart" then
        local msg, timer, icon, type, spellId, colorId, modid, keep, fade, name, guid = ...;

        --if ns.options.ANameP_ShowDBM and type == "cd"  and string.find(id, "cdnp") or string.find(id, "nextnp") then
        if ns.options.ANameP_ShowDBM and guid then
            ns.dbm_event_list[id] = { msg, timer, GetTime(), icon, 0, colorId, spellId, guid };
        end
    elseif event == "DBM_TimerStop" or event == "DBM_NameplateStop" then
        ns.dbm_event_list[id] = nil;
    elseif event == "DBM_TimerUpdate" or event == "DBM_NameplateUpdate" then
        local elapsed, totalTime = ...;
        if ns.dbm_event_list[id] then
            ns.dbm_event_list[id][5] = 0;
            ns.dbm_event_list[id][2] = totalTime;
            ns.dbm_event_list[id][3] = GetTime() - elapsed;
        end
    else
        --print (...);
    end
end

local function initDBM()
    DBM:RegisterCallback("DBM_TimerStart", asNamePlatesDBM_callback);
    DBM:RegisterCallback("DBM_TimerStop", asNamePlatesDBM_callback);
    DBM:RegisterCallback("DBM_TimerFadeUpdate", asNamePlatesDBM_callback);
    DBM:RegisterCallback("DBM_TimerUpdate", asNamePlatesDBM_callback);
    DBM:RegisterCallback("DBM_TimerPause", asNamePlatesDBM_callback);
    DBM:RegisterCallback("DBM_TimerResume", asNamePlatesDBM_callback);


    DBM:RegisterCallback("DBM_NameplateStart", asNamePlatesDBM_callback);
    DBM:RegisterCallback("DBM_NameplateStop", asNamePlatesDBM_callback);
    DBM:RegisterCallback("DBM_NameplateUpdate", asNamePlatesDBM_callback);
    DBM:RegisterCallback("DBM_NameplatePause", asNamePlatesDBM_callback);
    DBM:RegisterCallback("DBM_NameplateResume", asNamePlatesDBM_callback);
end

local bloaded = C_AddOns.LoadAddOn("DBM-Core");
if bloaded then
    initDBM();
end
