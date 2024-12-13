local ASHK_ShowMacroName = false; -- Macro 이름을 보이려면 true로

local function _CheckLongName(keyName)

  keyName = string.gsub(keyName, "Num Pad ", "");
  keyName = string.gsub(keyName, "숫자패드 ", "");
  keyName = string.gsub(keyName, "Num Pad", "");
  keyName = string.gsub(keyName, "숫자패드", "");
  
  keyName = string.gsub(keyName, "Middle Mouse", "M3");
  keyName = string.gsub(keyName, "마우스 가운데 버튼", "M3");
  keyName = string.gsub(keyName, "Mouse Button (%d)", "M%1");
  keyName = string.gsub(keyName, "(%d)번 마우스 버튼", "M%1");
  keyName = string.gsub(keyName, "Mouse Wheel Up", "MU");
  keyName = string.gsub(keyName, "마우스 휠 위로", "MU");
  keyName = string.gsub(keyName, "Mouse Wheel Down", "MD");
  keyName = string.gsub(keyName, "마우스 휠 아래로", "MD");
  keyName = string.gsub(keyName, "^s%-", "S");
  keyName = string.gsub(keyName, "^a%-", "A");
  keyName = string.gsub(keyName, "^c%-", "C");
  keyName = string.gsub(keyName, "Delete", "Dt");
  keyName = string.gsub(keyName, "Page Down", "Pd");
  keyName = string.gsub(keyName, "Page Up", "Pu");
  keyName = string.gsub(keyName, "Insert", "In");
  keyName = string.gsub(keyName, "Del", "Dt");
  keyName = string.gsub(keyName, "Home", "Hm");
  keyName = string.gsub(keyName, "Capslock", "Ck");
  keyName = string.gsub(keyName, "Num Lock", "Nk");
  keyName = string.gsub(keyName, "Scroll Lock", "Sk");
  keyName = string.gsub(keyName, "Backspace", "Bs");
  keyName = string.gsub(keyName, "Spacebar", "Sb");
  keyName = string.gsub(keyName, "스페이스 바", "Sb");
  keyName = string.gsub(keyName, "End", "Ed");
  keyName = string.gsub(keyName, "Up Arrow", "^");
  keyName = string.gsub(keyName, "위 화살표", "^");
  keyName = string.gsub(keyName, "Down Arrow", "V");
  keyName = string.gsub(keyName, "아래 화살표", "V");
  keyName = string.gsub(keyName, "Right Arrow", ">");
  keyName = string.gsub(keyName, "오른쪽 화살표", ">");
  keyName = string.gsub(keyName, "Left Arrow", "<");
  keyName = string.gsub(keyName, "왼쪽 화살표", "<");

  return keyName;
end

local function _UpdateHotkeys(name, type, hide, total)
  for i = 1, total do
    local f = getglobal(name .. i);
    if not f then break end
    ;
    local hotkey = getglobal(f:GetName() .. "HotKey");
    if not hotkey then break end
    ;

    local key = GetBindingKey(type .. i)
    local text = GetBindingText(key, "KEY_", 1);
    text = _CheckLongName(text);
    if (text == "") then
      hotkey:Hide();
    else
      hotkey:SetText(text);
      hotkey:Show();
    end

    if getglobal(f:GetName() .. "Name") then
      if (not ASHK_ShowMacroName) and (hide == 1) then
        getglobal(f:GetName() .. "Name"):Hide();
      else
        getglobal(f:GetName() .. "Name"):Show();
      end
    end
  end
end

local function onEvent(self, event, arg1)
  if event == "PLAYER_ENTERING_WORLD" or "UPDATE_BINDINGS" then
    _UpdateHotkeys("ActionButton", "ACTIONBUTTON", 1, 12);
    _UpdateHotkeys("MultiBarBottomLeftButton", "MULTIACTIONBAR1BUTTON", 1, 12);
    _UpdateHotkeys("MultiBarBottomRightButton", "MULTIACTIONBAR2BUTTON", 1, 12);
    _UpdateHotkeys("MultiBarRightButton", "MULTIACTIONBAR3BUTTON", 1, 12);
    _UpdateHotkeys("MultiBarLeftButton", "MULTIACTIONBAR4BUTTON", 1, 12);
    _UpdateHotkeys("BonusActionButton", "ACTIONBUTTON", 1, 12);
    _UpdateHotkeys("ExtraActionButton", "EXTRAACTIONBUTTON", 1, 12);
    _UpdateHotkeys("VehicleMenuBarActionButton", "ACTIONBUTTON", 1, 12);
    _UpdateHotkeys("OverrideActionBarButton", "ACTIONBUTTON", 1, 12);
    _UpdateHotkeys("PetActionButton", "BONUSACTIONBUTTON", 1, 10);
    _UpdateHotkeys("MultiBar5Button", "MULTIACTIONBAR5BUTTON", 1, 12);
    _UpdateHotkeys("MultiBar6Button", "MULTIACTIONBAR6BUTTON", 1, 12);
    _UpdateHotkeys("MultiBar7Button", "MULTIACTIONBAR7BUTTON", 1, 12);
    return;
  end
end

local frame = CreateFrame("Frame")
frame:RegisterEvent("PLAYER_ENTERING_WORLD")
frame:RegisterEvent("UPDATE_BINDINGS")
frame:SetScript("OnEvent", onEvent)
