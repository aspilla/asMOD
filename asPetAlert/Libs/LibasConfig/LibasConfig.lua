local major = "LibasConfig";

local CONST_LIB_VERSION = 1;

local libStub = _G.LibStub
local libasConfig = libStub:NewLibrary(major, CONST_LIB_VERSION)

if (not libasConfig) then
    return
end

local gpositions = {};

local function on_stopdrag(self)
    local _, _, _, x, y = self:GetPoint();
    self.text:SetText(self.addonName .. "\n" .. string.format("%5.1f", x) .. "\n" .. string.format("%5.1f", y));
    self.StopMovingOrSizing(self);
end

local function setup_frame(frame, Name, addonName, positions)
    frame = CreateFrame("Frame", Name, UIParent)
    frame.addonName = addonName;
    frame.text = frame:CreateFontString(nil, "OVERLAY")
    frame.text:SetFont(STANDARD_TEXT_FONT, 10, "OUTLINE")
    frame.text:SetPoint("CENTER", frame, "CENTER", 0, 0)
    frame.text:SetText(frame.addonName);
    frame:SetMovable(true)
    frame:EnableMouse(true)
    frame:RegisterForDrag("LeftButton")
    frame:SetFrameStrata("HIGH");
    frame:SetScript("OnDragStart", frame.StartMoving)
    frame:SetScript("OnDragStop", on_stopdrag);
    -- The code below makes the frame visible, and is not necessary to enable dragging.
    frame:SetPoint(positions.anchor1, UIParent, positions.anchor2, positions.x, positions.y);
    if positions.width and positions.width > 5 then
        frame:SetWidth(positions.width);
    else
        frame:SetWidth(30);
    end

    if positions.height and positions.height > 5 then
        frame:SetHeight(positions.height);
    else
        frame:SetHeight(30);
    end

    local tex = frame:CreateTexture(nil, "ARTWORK");
    tex:SetAllPoints();
    tex:SetColorTexture(1.0, 0.5, 0); tex:SetAlpha(0.5);
    return frame
end


function libasConfig.load_position(frame, addonname, savevariable)
    gpositions[addonname] = {
        name = addonname,        
    };

    gpositions[addonname].anchor1, _, gpositions[addonname].anchor2, gpositions[addonname].x, gpositions[addonname].y =
        frame:GetPoint();
    gpositions[addonname].width = frame:GetWidth();
    gpositions[addonname].height = frame:GetHeight();

    if savevariable.positions then
        local savepositions = savevariable.positions;
        frame:ClearAllPoints();
        frame:SetPoint(savepositions.anchor1, UIParent, savepositions.anchor2, savepositions.x,
            savepositions.y);

        gpositions[addonname].anchor1, gpositions[addonname].anchor2, gpositions[addonname].x, gpositions[addonname].y =
        savepositions.anchor1, savepositions.anchor2, savepositions.x, savepositions.y;
    end

    gpositions[addonname].savevariable = savevariable;
end

local framelist = {};

local function show_configpopup()
    for i, value in pairs(gpositions) do
        local index = value["name"]
        local positions = gpositions[index];
        framelist[index] = nil;
        framelist[index] = setup_frame(framelist[index], "asMOD_frame" .. index, index, positions);
    end

    StaticPopup_Show("asConfig")
end

local function cancel_position()
    for i, value in pairs(gpositions) do
        local index = value["name"]
        framelist[index]:Hide()
    end
end


local function save_positions()
    for i, value in pairs(gpositions) do
        local index = value["name"]
        local positions = gpositions[index];
        local savevariable = positions.savevariable;
        local frame = framelist[index];

        savevariable.positions = {};        
        savevariable.positions.anchor1, _, savevariable.positions.anchor2, savevariable.positions.x, savevariable.positions.y =
        frame:GetPoint();
    end
    cancel_position();
    ReloadUI();
end


local function show_clearpopup()
    StaticPopup_Show("asClear")
end

local function reset_positions()
    for i, value in pairs(gpositions) do
        local index = value["name"]
        local positions = gpositions[index];
        positions.savevariable.positions = nil;
    end
    ReloadUI();
end

do
    if GetLocale() == "koKR" then
        DEFAULT_CHAT_FRAME:AddMessage("/asConfig : asMOD 의 위치 조정");
        DEFAULT_CHAT_FRAME:AddMessage("/asClear : asMOD 기본 위치로 설정 초기화");
        StaticPopupDialogs["asConfig"] = {
            text = "asMOD 애드온의 위치를 조정 합니다. 완료를 누르면 위치가 저장 됩니다. 원치 않을 경우 취소를 누르세요",
            button1 = "완료",
            button2 = "취소",
            OnAccept = function()
                save_positions()
            end,

            OnCancel = function(_, reason)
                cancel_position();
            end,
            timeout = 0,
            whileDead = true,
            hideOnEscape = true,
            preferredIndex = 3,
        }


        StaticPopupDialogs["asClear"] = {
            text = "asMOD 위치를 모두 기본으로 초기화 합니다.",
            button1 = "변경",
            button2 = "다음에",
            OnAccept = function()
                reset_positions()
            end,
            timeout = 0,
            whileDead = true,
            hideOnEscape = true,
            preferredIndex = 3,
        }
    else
        DEFAULT_CHAT_FRAME:AddMessage("/asConfig : Config positions of asMOD addons");
        DEFAULT_CHAT_FRAME:AddMessage("/asClear : Reset positions as default configuration");
        StaticPopupDialogs["asConfig"] = {
            text = "Config positions of asMOD addons",
            button1 = "Save",
            button2 = "Cancel",
            OnAccept = function()
                save_positions()
            end,

            OnCancel = function(_, reason)
                cancel_position();
            end,
            timeout = 0,
            whileDead = true,
            hideOnEscape = true,
            preferredIndex = 3,
        }


        StaticPopupDialogs["asClear"] = {
            text = "Reset all configurations to default",
            button1 = "Confirm",
            button2 = "Cancel",
            OnAccept = function()
                reset_positions()
            end,
            timeout = 0,
            whileDead = true,
            hideOnEscape = true,
            preferredIndex = 3,
        }
    end

    SlashCmdList['asConfig'] = show_configpopup
    SlashCmdList['asClear'] = show_clearpopup
    SLASH_asConfig1 = '/asConfig'
    SLASH_asClear1 = '/asClear'
end
