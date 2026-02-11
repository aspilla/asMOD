local _, ns = ...;


ns.hotkeys = {};
ns.hotkeyslots = {};

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

local function scan_keys(name, total)
	for i = 1, total do
		local actionbutton = getglobal(name .. i);
		if not actionbutton then
			break
		end
		;
		local hotkey = getglobal(actionbutton:GetName() .. "HotKey");
		if not hotkey then
			break
		end

		local text = hotkey:GetText();
		local slot = actionbutton.action;

		if name == "ActionButton" then
			slot = i;
		end

		if slot and text then
			local keytext = check_name(text);
			if keytext ~= "●" then
				if ns.hotkeyslots[slot] == nil then
					ns.hotkeyslots[slot] = keytext;
				end
			end
		end
	end
end

local function scan_actionslots()
	for slot = 1, 180 do
		local keytext = ns.hotkeyslots[slot];

		if slot > 72 and slot <= 108 then
			keytext = ns.hotkeyslots[(slot - 1) % 12 + 1];
		end
		
		if keytext then
			local type, id, subType = GetActionInfo(slot);			
			if (type == "spell" or type == "macro") and id then
				if ns.hotkeys[id] == nil then
					ns.hotkeys[id] = keytext;
				end
			end
		end
	end
end

function ns.check_hotkeys()
	wipe(ns.hotkeys);
	wipe(ns.hotkeyslots);
	scan_keys("ActionButton", 12);
	scan_keys("MultiBarBottomLeftButton", 12);
	scan_keys("MultiBarBottomRightButton", 12);
	scan_keys("MultiBarRightButton", 12);
	scan_keys("MultiBarLeftButton", 12);
	scan_keys("MultiBar5Button", 12);
	scan_keys("MultiBar6Button", 12);
	scan_keys("MultiBar7Button", 12);
	scan_keys("BonusActionButton", 12);
	scan_keys("ExtraActionButton", 12);
	scan_keys("VehicleMenuBarActionButton", 12);
	scan_keys("OverrideActionBarButton", 12);
	scan_keys("PetActionButton", 10);

	scan_actionslots();
end

