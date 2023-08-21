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

local asGearScore = CreateFrame("Frame", nil, UIParent);
local fontstrings = {};
local inspectframe;
local TAvg;

local function OnEvent(self, event)
	if (event == "PLAYER_EQUIPMENT_CHANGED") then
		MyPaperDoll();
	end
end

local scantip = nil;
local level_txt = string.gsub(ITEM_LEVEL, "%%d", "(.+)")

function GetItemLevel(unit, slot)
	if scantip == nil then
		scantip = CreateFrame("GameTooltip", "asItemLevelTip", nil, "GameTooltipTemplate");
		scantip:SetOwner(UIParent, "ANCHOR_NONE");
	end

	scantip:SetInventoryItem(unit, slot);

	for i = 2, scantip:NumLines() do
		local text = _G["asItemLevelTipTextLeft" .. i]:GetText() or ""
		local iLevel = string.match(text, level_txt)

		if iLevel ~= nil then
			local retval = tonumber(iLevel)
			if (retval ~= nil) then
				return retval
			end
		end
	end

	return nil;
end

function GetAvgIvl(unit)
	local t, c = 0, 0
	local min = 0xFFFFFFFF;
	local max = 0
	local weapon_lvl;
	local weapon_count = 0;
	local two_head = nil;


	for i = 1, #itemslots do
		local idx = GetInventorySlotInfo(itemslots[i]);

		local k = GetInventoryItemLink(unit, idx)

		if k then
			local name, _, quality, _ = GetItemInfo(k)
			local lvl = GetItemLevel(unit, idx);

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

	return floor(t / c), max, min
end

function MyPaperDoll()
	if (InCombatLockdown()) then return; end

	local Avg, Max, Min = GetAvgIvl("player");
end

local update = 0;

function MyInspectDoll(self, elapsed)
	update = update + elapsed;

	if update >= 1 then
		update = 0
	else
		return
	end

	if (InCombatLockdown() or not INSPECTED_UNIT) then return; end

	local Avg, Max, Min = GetAvgIvl(INSPECTED_UNIT);
	local Red, Green, Blue = GetItemQualityColor(Avg);
	TAvg:SetText(Avg .. " Lvl");
	TAvg:SetTextColor(Red, Green, Blue)
end

local font, _, flags = NumberFontNormal:GetFont()

asGearScore:SetScript("OnEvent", OnEvent);
asGearScore:RegisterEvent("PLAYER_EQUIPMENT_CHANGED");

CharacterFrame:HookScript("OnShow", MyPaperDoll)

inspectframe = _G["InspectFrame"]
inspectframe:HookScript("OnUpdate", MyInspectDoll)

TAvg = inspectframe:CreateFontString(nil, "OVERLAY")
TAvg:SetFont(font, AGS_FontSize + 2, flags)
TAvg:SetText("Avg: 0")
TAvg:SetPoint("TOPRIGHT", inspectframe, "TOPRIGHT", -10, -30)
TAvg:Show()

fontstrings["player"] = {};
fontstrings["target"] = {};

for slot, n in pairs(itemslots) do
	local gslot = _G["Character" .. n]
	fontstrings["player"][slot] = gslot:CreateFontString(nil, "OVERLAY")
	fontstrings["player"][slot]:SetFont(font, AGS_FontSize, flags)
	fontstrings["player"][slot]:SetPoint("TOP", gslot, "TOP", 0, -3)
	fontstrings["player"][slot]:SetTextColor(1, 1, 1)
end

for slot, n in pairs(itemslots) do
	local gslot = _G["Inspect" .. n]
	fontstrings["target"][slot] = gslot:CreateFontString(nil, "OVERLAY")
	fontstrings["target"][slot]:SetFont(font, AGS_FontSize, flags)
	fontstrings["target"][slot]:SetPoint("TOP", gslot, "TOP", 0, -3)
	fontstrings["target"][slot]:SetTextColor(1, 1, 1)
end
