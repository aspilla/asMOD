local version, build, date, tocversion, localizedVersion, buildType = GetBuildInfo();
local previnfo = {};

local function checkAddon(name)
    local count = C_AddOnProfiler.GetAddOnMetric(name,Enum.AddOnProfilerMetric.CountTimeOver5Ms);

    if previnfo[name] and count > previnfo[name] then
        local peak = C_AddOnProfiler.GetAddOnMetric(name,Enum.AddOnProfilerMetric.PeakTime);
        print (GetTime().." ".. name.. " (" .. peak .. ") "..(count - previnfo[name]));
        
    end
    previnfo[name] = count;    
end

local function onUpdate()
    for i = 1, C_AddOns.GetNumAddOns() do
        local name, _, _, loadable, reason, _ = C_AddOns.GetAddOnInfo(i)
        if loadable and string.find(name, "as") then                        
            checkAddon(name)
        end
    end
end


if tocversion >= 110007 then
    C_Timer.NewTicker(2, onUpdate);
end

