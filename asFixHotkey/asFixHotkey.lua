local configs = {
  ShowMacro = false, -- Macro 이름을 보이려면 true로
};

local function check_name(name)
  name = string.gsub(name, "Num Pad ", "");
  name = string.gsub(name, "숫자패드 ", "");
  name = string.gsub(name, "Num Pad", "");
  name = string.gsub(name, "숫자패드", "");

  name = string.gsub(name, "Middle Mouse", "M3");
  name = string.gsub(name, "마우스 가운데 버튼", "M3");
  name = string.gsub(name, "Mouse Button (%d)", "M%1");
  name = string.gsub(name, "(%d)번 마우스 버튼", "M%1");
  name = string.gsub(name, "Mouse Wheel Up", "MU");
  name = string.gsub(name, "마우스 휠 위로", "MU");
  name = string.gsub(name, "Mouse Wheel Down", "MD");
  name = string.gsub(name, "마우스 휠 아래로", "MD");
  name = string.gsub(name, "^s%-", "S");
  name = string.gsub(name, "^a%-", "A");
  name = string.gsub(name, "^c%-", "C");
  name = string.gsub(name, "Delete", "Dt");
  name = string.gsub(name, "Page Down", "Pd");
  name = string.gsub(name, "Page Up", "Pu");
  name = string.gsub(name, "Insert", "In");
  name = string.gsub(name, "Del", "Dt");
  name = string.gsub(name, "Home", "Hm");
  name = string.gsub(name, "Capslock", "Ck");
  name = string.gsub(name, "Num Lock", "Nk");
  name = string.gsub(name, "Scroll Lock", "Sk");
  name = string.gsub(name, "Backspace", "Bs");
  name = string.gsub(name, "Spacebar", "Sb");
  name = string.gsub(name, "스페이스 바", "Sb");
  name = string.gsub(name, "End", "Ed");
  name = string.gsub(name, "Up Arrow", "^");
  name = string.gsub(name, "위 화살표", "^");
  name = string.gsub(name, "Down Arrow", "V");
  name = string.gsub(name, "아래 화살표", "V");
  name = string.gsub(name, "Right Arrow", ">");
  name = string.gsub(name, "오른쪽 화살표", ">");
  name = string.gsub(name, "Left Arrow", "<");
  name = string.gsub(name, "왼쪽 화살표", "<");

  return name;
end

local function update_hotkeys(name, type, hide, total)
  for i = 1, total do
    local f = getglobal(name .. i);
    if not f then
      break
    end
    ;
    local hotkey = getglobal(f:GetName() .. "HotKey");
    if not hotkey then
      break
    end
    ;

    local key = GetBindingKey(type .. i)
    local text = GetBindingText(key, "KEY_", true);
    text = check_name(text);
    if (text == "") then
      hotkey:Hide();
    else
      hotkey:SetText(text);
      hotkey:Show();
    end

    if getglobal(f:GetName() .. "Name") then
      if (not configs.ShowMacro) and (hide == 1) then
        getglobal(f:GetName() .. "Name"):Hide();
      else
        getglobal(f:GetName() .. "Name"):Show();
      end
    end
  end
end

local function on_event(self, event, arg1)
  if event == "PLAYER_ENTERING_WORLD" or "UPDATE_BINDINGS" then
    update_hotkeys("ActionButton", "ACTIONBUTTON", 1, 12);
    update_hotkeys("MultiBarBottomLeftButton", "MULTIACTIONBAR1BUTTON", 1, 12);
    update_hotkeys("MultiBarBottomRightButton", "MULTIACTIONBAR2BUTTON", 1, 12);
    update_hotkeys("MultiBarRightButton", "MULTIACTIONBAR3BUTTON", 1, 12);
    update_hotkeys("MultiBarLeftButton", "MULTIACTIONBAR4BUTTON", 1, 12);
    update_hotkeys("BonusActionButton", "ACTIONBUTTON", 1, 12);
    update_hotkeys("ExtraActionButton", "EXTRAACTIONBUTTON", 1, 12);
    update_hotkeys("VehicleMenuBarActionButton", "ACTIONBUTTON", 1, 12);
    update_hotkeys("OverrideActionBarButton", "ACTIONBUTTON", 1, 12);
    update_hotkeys("PetActionButton", "BONUSACTIONBUTTON", 1, 10);
    update_hotkeys("MultiBar5Button", "MULTIACTIONBAR5BUTTON", 1, 12);
    update_hotkeys("MultiBar6Button", "MULTIACTIONBAR6BUTTON", 1, 12);
    update_hotkeys("MultiBar7Button", "MULTIACTIONBAR7BUTTON", 1, 12);
    return;
  end
end

local main_frame = CreateFrame("Frame")
main_frame:RegisterEvent("PLAYER_ENTERING_WORLD")
main_frame:RegisterEvent("UPDATE_BINDINGS")
main_frame:SetScript("OnEvent", on_event)
