-- 기본 UI 프레임 생성
local frame = CreateFrame("Frame", "asCPUUsageFrame", UIParent, "BasicFrameTemplateWithInset")
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

-- 스크롤 프레임 생성
local scrollFrame = CreateFrame("ScrollFrame", nil, frame, "UIPanelScrollFrameTemplate")
scrollFrame:SetPoint("TOPLEFT", 10, -50) -- Adjusted for header row
scrollFrame:SetPoint("BOTTOMRIGHT", -30, 10)

-- 스크롤 컨텐츠 생성
local content = CreateFrame("Frame", nil, scrollFrame)
content:SetSize(820, 800) -- 충분히 큰 높이로 설정
scrollFrame:SetScrollChild(content)

-- 필드 제목(헤더) 행 생성
local header = CreateFrame("Frame", nil, content)
header:SetSize(820, 10)
header:SetPoint("TOPLEFT", 0, 0)

-- 필드 제목 텍스트 설정
local headers = { "Addon Name", "PeakTime", "BossAvg", "Over1Ms", "Over5Ms", "Over10Ms", "Over50Ms", "Over100Ms", "OverSum" }
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

-- 행(row) 목록을 저장하는 테이블 (애드온 이름을 키로 사용)
local rowList = {}
local currentYOffset = -25 -- header 아래로 시작하도록 yOffset 설정

-- 테이블 셀을 생성하거나 업데이트하는 함수
local function CreateOrUpdateRow(parent, index, datas)
    local rowInfo = rowList[index]
    local addonName = datas[1];

    if rowInfo then
        -- 행이 이미 존재하면 업데이트
        rowInfo.nameText:SetText(addonName);
        for i = 2, 9 do
            if i <= 3 then
                rowInfo.cpuTexts[i]:SetText(string.format("%.4f", datas[i] or 0))
            else
                rowInfo.cpuTexts[i]:SetText(string.format("%.0f", datas[i] or 0))
            end
        end
    else
        -- 행이 존재하지 않으면 새로 생성
        local row = CreateFrame("Frame", nil, parent)
        row:SetSize(800, 20)

        -- yOffset을 현재 행 위치에 맞춰 설정하고, 다음 행을 위해 감소
        row:SetPoint("TOPLEFT", 0, currentYOffset)
        currentYOffset = currentYOffset - 25 -- 다음 행을 위한 yOffset 감소

        -- 애드온 이름 텍스트
        local nameText = row:CreateFontString(nil, "OVERLAY", "GameFontNormal")
        nameText:SetPoint("LEFT", row, "LEFT", 0, 0)
        nameText:SetWidth(150)
        nameText:SetJustifyH("CENTER")
        nameText:SetText(addonName)

        -- CPU 사용량 텍스트들 (5개의 필드 생성)
        local cpuTexts = {}
        for i = 2, 9 do
            local cpuText = row:CreateFontString(nil, "OVERLAY", "GameFontNormal")
            cpuText:SetPoint("LEFT", nameText, "RIGHT", (i - 2) * 80, 0) -- 각 필드를 오른쪽으로 나열
            cpuText:SetWidth(80)
            cpuText:SetJustifyH("CENTER")
            if i <= 3 then
                cpuText:SetText(string.format("%.4f", datas[i] or 0))
            else
                cpuText:SetText(string.format("%.0f", datas[i] or 0))
            end
            cpuTexts[i] = cpuText
        end

        -- row 정보를 rowList에 저장 (애드온 이름을 키로 사용)
        rowList[index] = {
            row = row,
            nameText = nameText,
            cpuTexts = cpuTexts, -- CPU 텍스트 목록을 저장
        }
    end
end

-- 닫기 버튼 생성
frame.closeButton = CreateFrame("Button", nil, frame, "UIPanelCloseButton")
frame.closeButton:SetPoint("TOPRIGHT", frame, "TOPRIGHT")

-- 프레임을 다시 열고 닫는 명령어
SLASH_ASCPU1 = "/asCPU"
SlashCmdList["ASCPU"] = function()
    if frame:IsShown() then
        frame:Hide()
    else
        frame:Show()
    end
end

local sortField = "name"
local sortDescending = false
local addonData = {};

-- 테이블 정렬 함수
local function SortData(list, field)
    
    table.sort(list, function(a, b)
        return a[field] > b[field]    
    end)
end






local version, build, date, tocversion, localizedVersion, buildType = GetBuildInfo();

local beforecombat = {};

local function beforecombatAddon(name)
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

local function checkAddon(name)

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

    local sum = Over100Ms * 100 + Over50Ms * 50 +Over10Ms * 10 + Over5Ms * 5 + Over1Ms

    table.insert(addonData, {name, 
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

local function onUpdate()

    if not frame:IsShown() then
        return;
    end

    table.wipe(addonData);
    for i = 1, C_AddOns.GetNumAddOns() do
        local name, _, _, loadable, reason, _ = C_AddOns.GetAddOnInfo(i)
        if loadable then
            checkAddon(name)
        end
    end
    SortData(addonData, 9);

    for index, datas in ipairs(addonData) do
        CreateOrUpdateRow(content, index, datas)
    end
end


if tocversion >= 110007 then
    onUpdate();
    C_Timer.NewTicker(1, onUpdate);
    
end

local function OnEvent(self, event)
    if (event == "PLAYER_REGEN_DISABLED") then
        for i = 1, C_AddOns.GetNumAddOns() do
            local name, _, _, loadable, reason, _ = C_AddOns.GetAddOnInfo(i)
            if loadable then
                beforecombatAddon(name)
            end
        end
    end
    return;
end

frame:SetScript("OnEvent", OnEvent)
frame:RegisterEvent("PLAYER_REGEN_DISABLED");
