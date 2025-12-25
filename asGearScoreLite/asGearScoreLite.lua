local configs = {
	fontsize = 11,
};

local itemslots = {
	"HeadSlot",
	"NeckSlot",
	"ShoulderSlot",
	"BackSlot",
	"ChestSlot",
	"WristSlot",
	"MainHandSlot",
	"SecondaryHandSlot",
	"HandsSlot",
	"WaistSlot",
	"LegsSlot",
	"FeetSlot",
	"Finger0Slot",
	"Finger1Slot",
	"Trinket0Slot",
	"Trinket1Slot",
};

local main_frame = CreateFrame("Frame", nil, UIParent);
local fontstrings = {};
local inspectframe = _G["InspectFrame"];
local avg_text;
local bfirst = true;

local function get_avglevel(unit)
	local t, c = 0, 0	
	local weapon_lvl;
	local weapon_count = 0;
	local two_head = nil;
	
	for i = 1, #itemslots do
		local idx = GetInventorySlotInfo(itemslots[i]);
		local k = GetInventoryItemLink(unit, idx);

		if k then
			local _, _, quality, lvl = C_Item.GetItemInfo(k);

			if lvl and lvl > 0 and quality then
				fontstrings[unit][i]:SetText(lvl);
				local r, g, b = C_Item.GetItemQualityColor(quality);
				fontstrings[unit][i]:SetTextColor(r, g, b);
			end

			if idx == 16 or idx == 17 then
				weapon_count = weapon_count + 1;
				two_head = lvl;
			end

			if lvl and lvl > 0 then
				t = t + lvl
				c = c + 1
			end
		else
			fontstrings[unit][i]:SetText("");
		end
	end

	if weapon_lvl then
		t = t + (weapon_lvl * 2)
		c = c + 2
	end

	if weapon_count == 1 and two_head then
		t = t + two_head;
		c = c + 1;
	end

	if c > 0 then
		return floor(t / c);
	else
		return 0;
	end
end

local function check_player()
	if (InCombatLockdown()) then return; end

	local Avg = get_avglevel("player");
end

local function check_inspect()
	if (InCombatLockdown()) then return; end

	if CanInspect("target") then
		local Avg = get_avglevel("target");
		avg_text:SetText(Avg .. " Lvl");
	end
end

local function on_show()
	C_Timer.After(0.5, check_inspect);
end

local function on_event(self, event)


	if (event == "PLAYER_EQUIPMENT_CHANGED") then
		check_player();
	end

	if InspectPaperDollItemsFrame and bfirst then
		InspectPaperDollItemsFrame:HookScript("OnShow", on_show);
		bfirst = false;
	end
end


main_frame:SetScript("OnEvent", on_event);
main_frame:RegisterEvent("PLAYER_EQUIPMENT_CHANGED");
main_frame:RegisterEvent("ADDON_LOADED");

CharacterFrame:HookScript("OnShow", check_player);

avg_text = inspectframe:CreateFontString(nil, "OVERLAY");
avg_text:SetFont(STANDARD_TEXT_FONT, configs.fontsize, "THICKOUTLINE");
avg_text:SetText("Avg: 0")
avg_text:SetPoint("TOPRIGHT", inspectframe, "TOPRIGHT", -10, -30)
avg_text:SetTextColor(1, 1, 1);
avg_text:Show()

fontstrings["player"] = {};
fontstrings["target"] = {};

for slot, n in pairs(itemslots) do
	local button = _G["Character" .. n]
	local lvltext = main_frame:CreateFontString(nil, "OVERLAY");
	lvltext:SetParent(button);
	lvltext:SetFont(STANDARD_TEXT_FONT, configs.fontsize, "THICKOUTLINE");
	lvltext:SetPoint("TOP", button, "TOP", 0, -3);
	lvltext:SetTextColor(1, 1, 1);
	fontstrings["player"][slot] = lvltext;
end


for slot, n in pairs(itemslots) do
	local button = _G["Inspect" .. n]
	local lvltext = main_frame:CreateFontString(nil, "OVERLAY");
	lvltext:SetParent(button);
	lvltext:SetFont(STANDARD_TEXT_FONT, configs.fontsize, "THICKOUTLINE");
	lvltext:SetPoint("TOP", button, "TOP", 0, -3);
	lvltext:SetTextColor(1, 1, 1);
	fontstrings["target"][slot] = lvltext;
end
