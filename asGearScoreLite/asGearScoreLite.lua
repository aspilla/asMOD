local AGS_FontSize = 11;

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

local GetItemInfo = C_Item and C_Item.GetItemInfo or GetItemInfo;
local GetItemQualityColor = C_Item and C_Item.GetItemQualityColor or GetItemQualityColor;

local asGearScore = CreateFrame("Frame", nil, UIParent);
local fontstrings = {};
local inspectframe;
local TAvg;
local bfirst = true;

local function GetAvgIvl(unit)
	local t, c = 0, 0
	local min = 0xFFFFFFFF;
	local max = 0
	local weapon_lvl;
	local weapon_count = 0;
	local two_head = nil;


	for i = 1, #itemslots do
		local idx = GetInventorySlotInfo(string.upper(itemslots[i]));

		local k = GetInventoryItemLink(unit, idx)

		if k then
			local _, _, quality, lvl = GetItemInfo(k)

			if lvl and lvl > 0 and quality then
				fontstrings[unit][i]:SetText(lvl);
				local r, g, b = GetItemQualityColor(quality);
				fontstrings[unit][i]:SetTextColor(r, g, b);
			end

			if idx == 16 or idx == 17 then
				weapon_count = weapon_count + 1;
				two_head = lvl;
			end

			if lvl and lvl > 0 then
				t = t + lvl
				c = c + 1
				if quality < min then
					min = quality
				end

				if quality > max then
					max = quality
				end
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

	if min == 0xFFFFFFFF then
		min = 0;
	end

	if c > 0 then
		return floor(t / c), max, min
	else
		return 0, max, min
	end
end

local function MyPaperDoll()
	if (InCombatLockdown()) then return; end

	local Avg, Max, Min = GetAvgIvl("player");
end

local function InspectPaperDoll()
	if (InCombatLockdown()) then return; end

	if CanInspect("target") then
		local Avg, Max, Min = GetAvgIvl("target");
		TAvg:SetText(Avg .. " Lvl");
	end
end

local function asHookInspect()
	C_Timer.After(0.5, InspectPaperDoll);
end

local function OnEvent(self, event, arg1)


	if (event == "PLAYER_EQUIPMENT_CHANGED") then
		MyPaperDoll();
	end

	if InspectPaperDollItemsFrame and bfirst then
		InspectPaperDollItemsFrame:HookScript("OnShow", asHookInspect);
		bfirst = false;
	end
end


asGearScore:SetScript("OnEvent", OnEvent);
asGearScore:RegisterEvent("PLAYER_EQUIPMENT_CHANGED");
asGearScore:RegisterEvent("ADDON_LOADED");

CharacterFrame:HookScript("OnShow", MyPaperDoll)

inspectframe = _G["InspectFrame"]

TAvg = inspectframe:CreateFontString(nil, "OVERLAY")
TAvg:SetFont(STANDARD_TEXT_FONT, AGS_FontSize, "THICKOUTLINE");
TAvg:SetText("Avg: 0")
TAvg:SetPoint("TOPRIGHT", inspectframe, "TOPRIGHT", -10, -30)
TAvg:SetTextColor(1, 1, 1);
TAvg:Show()

fontstrings["player"] = {};
fontstrings["target"] = {};

for slot, n in pairs(itemslots) do
	local gslot = _G["Character" .. n]
	fontstrings["player"][slot] = gslot:CreateFontString(nil, "OVERLAY");
	fontstrings["player"][slot]:SetFont(STANDARD_TEXT_FONT, AGS_FontSize, "THICKOUTLINE");
	fontstrings["player"][slot]:SetPoint("TOP", gslot, "TOP", 0, -3)
	fontstrings["player"][slot]:SetTextColor(1, 1, 1)
end


for slot, n in pairs(itemslots) do
	local gslot = _G["Inspect" .. n]
	fontstrings["target"][slot] = gslot:CreateFontString(nil, "OVERLAY");
	fontstrings["target"][slot]:SetFont(STANDARD_TEXT_FONT, AGS_FontSize, "THICKOUTLINE");
	fontstrings["target"][slot]:SetPoint("TOP", gslot, "TOP", 0, -3)
	fontstrings["target"][slot]:SetTextColor(1, 1, 1)
end
