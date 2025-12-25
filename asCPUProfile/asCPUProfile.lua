local frame = CreateFrame("Frame", "asCPUUsageFrame", UIParent, "BasicFrameTemplateWithInset")
frame:Hide();
frame:SetSize(820, 300)
frame:SetPoint("CENTER")
frame:SetMovable(true)
frame:EnableMouse(true)
frame:RegisterForDrag("LeftButton")
frame:SetScript("OnDragStart", frame.StartMoving)
frame:SetScript("OnDragStop", frame.StopMovingOrSizing)

frame.title = frame:CreateFontString(nil, "OVERLAY")
frame.title:SetFontObject("GameFontHighlight")
frame.title:SetPoint("LEFT", frame.TitleBg, "LEFT", 5, 0)
frame.title:SetText("asCPUProfile")


local scrollFrame = CreateFrame("ScrollFrame", nil, frame, "UIPanelScrollFrameTemplate")
scrollFrame:SetPoint("TOPLEFT", 10, -50) -- Adjusted for header row
scrollFrame:SetPoint("BOTTOMRIGHT", -30, 10)


local content = CreateFrame("Frame", nil, scrollFrame)
content:SetSize(820, 800)
scrollFrame:SetScrollChild(content)


local header = CreateFrame("Frame", nil, content)
header:SetSize(820, 10)
header:SetPoint("TOPLEFT", 0, 0)


local headers = { "Addon Name", "PeakTime", "BossAvg", "Over1Ms", "Over5Ms", "Over10Ms", "Over50Ms", "Over100Ms",
    "OverSum" }
local headerWidths = { 150, 80, 80, 80, 80, 80, 80, 80, 80 }

for i, title in ipairs(headers) do
    local headerText = header:CreateFontString(nil, "OVERLAY", "GameFontHighlight")

    if i == 1 then
        headerText:SetPoint("LEFT", header, "LEFT", 0, 0)
    else
        headerText:SetPoint("LEFT", header, "LEFT", (i - 2) * 80 + 150, 0)
    end

    headerText:SetWidth(headerWidths[i])
    headerText:SetJustifyH("CENTER")
    headerText:SetText(title)
end

local rowList = {}
local currentYOffset = -25 

local function update_row(parent, index, datas)
    local rowInfo = rowList[index]
    local addonName = datas[1];

    if rowInfo then
        
        rowInfo.nameText:SetText(addonName);
        for i = 2, 9 do
            if i <= 3 then
                rowInfo.cpuTexts[i]:SetText(string.format("%.4f", datas[i] or 0))
            else
                rowInfo.cpuTexts[i]:SetText(string.format("%.0f", datas[i] or 0))
            end
        end
    else
        
        local row = CreateFrame("Frame", nil, parent)
        row:SetSize(800, 20)
        
        row:SetPoint("TOPLEFT", 0, currentYOffset)
        currentYOffset = currentYOffset - 25 

        
        local nameText = row:CreateFontString(nil, "OVERLAY", "GameFontNormal")
        nameText:SetPoint("LEFT", row, "LEFT", 0, 0)
        nameText:SetWidth(150)
        nameText:SetJustifyH("CENTER")
        nameText:SetText(addonName)

        
        local cpuTexts = {}
        for i = 2, 9 do
            local cpuText = row:CreateFontString(nil, "OVERLAY", "GameFontNormal")
            cpuText:SetPoint("LEFT", nameText, "RIGHT", (i - 2) * 80, 0) 
            cpuText:SetWidth(80)
            cpuText:SetJustifyH("CENTER")
            if i <= 3 then
                cpuText:SetText(string.format("%.4f", datas[i] or 0))
            else
                cpuText:SetText(string.format("%.0f", datas[i] or 0))
            end
            cpuTexts[i] = cpuText
        end

        
        rowList[index] = {
            row = row,
            nameText = nameText,
            cpuTexts = cpuTexts, 
        }
    end
end


frame.closeButton = CreateFrame("Button", nil, frame, "UIPanelCloseButton")
frame.closeButton:SetPoint("TOPRIGHT", frame, "TOPRIGHT")


SLASH_ASCPU1 = "/asCPU"
SlashCmdList["ASCPU"] = function()
    if frame:IsShown() then
        frame:Hide()
    else
        frame:Show()
    end
end

local addonData = {};

local function SortData(list, field)
    table.sort(list, function(a, b)
        return a[field] > b[field]
    end)
end


local beforecombat = {};

local function log_addon(name)
    local cpus = {
        C_AddOnProfiler.GetAddOnMetric(name, Enum.AddOnProfilerMetric.PeakTime),
        C_AddOnProfiler.GetAddOnMetric(name, Enum.AddOnProfilerMetric.EncounterAverageTime),
        C_AddOnProfiler.GetAddOnMetric(name, Enum.AddOnProfilerMetric.CountTimeOver1Ms),
        C_AddOnProfiler.GetAddOnMetric(name, Enum.AddOnProfilerMetric.CountTimeOver5Ms),
        C_AddOnProfiler.GetAddOnMetric(name, Enum.AddOnProfilerMetric.CountTimeOver10Ms),
        C_AddOnProfiler.GetAddOnMetric(name, Enum.AddOnProfilerMetric.CountTimeOver50Ms),
        C_AddOnProfiler.GetAddOnMetric(name, Enum.AddOnProfilerMetric.CountTimeOver100Ms)
    };

    beforecombat[name] = cpus;
end

local function check_addon(name)
    local Over1Ms = C_AddOnProfiler.GetAddOnMetric(name, Enum.AddOnProfilerMetric.CountTimeOver1Ms);
    local Over5Ms = C_AddOnProfiler.GetAddOnMetric(name, Enum.AddOnProfilerMetric.CountTimeOver5Ms);
    local Over10Ms = C_AddOnProfiler.GetAddOnMetric(name, Enum.AddOnProfilerMetric.CountTimeOver10Ms);
    local Over50Ms = C_AddOnProfiler.GetAddOnMetric(name, Enum.AddOnProfilerMetric.CountTimeOver50Ms);
    local Over100Ms = C_AddOnProfiler.GetAddOnMetric(name, Enum.AddOnProfilerMetric.CountTimeOver100Ms);

    if beforecombat[name] then
        Over1Ms = Over1Ms - beforecombat[name][3];
        Over5Ms = Over5Ms - beforecombat[name][4];
        Over10Ms = Over10Ms - beforecombat[name][5];
        Over50Ms = Over50Ms - beforecombat[name][6];
        Over100Ms = Over100Ms - beforecombat[name][7];
    end

    local sum = Over100Ms * 100 + Over50Ms * 50 + Over10Ms * 10 + Over5Ms * 5 + Over1Ms

    table.insert(addonData, { name,
        C_AddOnProfiler.GetAddOnMetric(name, Enum.AddOnProfilerMetric.PeakTime),
        C_AddOnProfiler.GetAddOnMetric(name, Enum.AddOnProfilerMetric.EncounterAverageTime),
        Over1Ms,
        Over5Ms,
        Over10Ms,
        Over50Ms,
        Over100Ms,
        sum
    })
end

local function on_update()
    if not frame:IsShown() then
        return;
    end

    table.wipe(addonData);
    for i = 1, C_AddOns.GetNumAddOns() do
        local name, _, _, loadable, reason, _ = C_AddOns.GetAddOnInfo(i)
        if loadable then
            check_addon(name)
        end
    end
    SortData(addonData, 9);

    for index, datas in ipairs(addonData) do
        update_row(content, index, datas)
    end
end

local function init()    
	print("|cff33ff99/ascpu|r : Open the asCPUProfile window")

    on_update();
    C_Timer.NewTicker(5, on_update);
end

local function OnEvent(self, event)
    if (event == "PLAYER_REGEN_DISABLED") then
        for i = 1, C_AddOns.GetNumAddOns() do
            local name, _, _, loadable, reason, _ = C_AddOns.GetAddOnInfo(i)
            if loadable then
                log_addon(name)
            end
        end
    end
    return;
end

frame:SetScript("OnEvent", OnEvent)
frame:RegisterEvent("PLAYER_REGEN_DISABLED");
C_Timer.After(2, init);