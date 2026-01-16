local configs = {
	fontsize = 11,
	font = STANDARD_TEXT_FONT,
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
local leveltexts = {};
local inspectframe = _G["InspectFrame"];
local avg_text;
local bfirst = true;


local function update_player()
	local unit = "player";

	for i = 1, #itemslots do
		local slot = GetInventorySlotInfo(itemslots[i]);		
		local leveltext = leveltexts[unit][i];
		local location = ItemLocation:CreateFromEquipmentSlot(slot)

		if location:IsValid() then
			local item = Item:CreateFromEquipmentSlot(slot);
			
			if item then
				item:ContinueOnItemLoad(function()
					local level = item:GetCurrentItemLevel();
					local quality = item:GetItemQuality();

					if level and level > 0 and quality then
						leveltext:SetText(level);
						local r, g, b = C_Item.GetItemQualityColor(quality);
						leveltext:SetTextColor(r, g, b);
					end
				end)
			else
				leveltext:SetText("");
			end
		else
			leveltext:SetText("");
		end
	end

	return 0;
end

local function get_levelfromslot(unit, slotID)
    
    local tooltip = C_TooltipInfo.GetInventoryItem(unit, slotID)
    
    if tooltip and tooltip.lines then        
        for _, line in ipairs(tooltip.lines) do
            if line.leftText then                
                local iLevel = line.leftText:match("%d+")
                if line.leftText:find(STAT_AVERAGE_ITEM_LEVEL) then
                    return tonumber(iLevel)
                end
            end
        end
    end
    return nil
end

local function update_target()
	local total_lvl, count = 0, 0
	local weapon_lvl;
	local weapon_count = 0;
	local two_head = nil;
	local unit = "target";

	for i = 1, #itemslots do
		local slot = GetInventorySlotInfo(itemslots[i]);
		local link = GetInventoryItemLink(unit, slot);
		local leveltext = leveltexts[unit][i];

		if link then
			local _, _, quality = C_Item.GetItemInfo(link);
			--local level = C_Item.GetDetailedItemLevelInfo(link);
			local level = get_levelfromslot(unit, slot)

			if level and level > 0 and quality then
				leveltext:SetText(level);
				local r, g, b = C_Item.GetItemQualityColor(quality);
				leveltext:SetTextColor(r, g, b);
			end

			if slot == 16 or slot == 17 then
				weapon_count = weapon_count + 1;
				two_head = level;
			end

			if level and level > 0 then
				total_lvl = total_lvl + level
				count = count + 1
			end
		else
			leveltext:SetText("");
		end
	end

	if weapon_lvl then
		total_lvl = total_lvl + (weapon_lvl * 2)
		count = count + 2
	end

	if weapon_count == 1 and two_head then
		total_lvl = total_lvl + two_head;
		count = count + 1;
	end

	if count > 0 then
		avg_text:SetText(floor(total_lvl / count) .. " Lvl");
	else
		avg_text:SetText("");
	end
end

local function check_player()
	if (InCombatLockdown()) then return; end
	update_player();
end

local function check_inspect()
	if (InCombatLockdown()) then return; end

	if CanInspect("target") then
		update_target();
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
avg_text:SetFont(configs.font, configs.fontsize, "THICKOUTLINE");
avg_text:SetText("Avg: 0")
avg_text:SetPoint("TOPRIGHT", inspectframe, "TOPRIGHT", -10, -30)
avg_text:SetTextColor(1, 1, 1);
avg_text:Show()

leveltexts["player"] = {};
leveltexts["target"] = {};

for slot, n in pairs(itemslots) do
	local button = _G["Character" .. n]
	local leveltext = main_frame:CreateFontString(nil, "OVERLAY");
	leveltext:SetParent(button);
	leveltext:SetFont(configs.font, configs.fontsize, "THICKOUTLINE");
	leveltext:SetPoint("TOP", button, "TOP", 0, -3);
	leveltext:SetTextColor(1, 1, 1);
	leveltexts["player"][slot] = leveltext;
end


for slot, n in pairs(itemslots) do
	local button = _G["Inspect" .. n]
	local leveltext = main_frame:CreateFontString(nil, "OVERLAY");
	leveltext:SetParent(button);
	leveltext:SetFont(configs.font, configs.fontsize, "THICKOUTLINE");
	leveltext:SetPoint("TOP", button, "TOP", 0, -3);
	leveltext:SetTextColor(1, 1, 1);
	leveltexts["target"][slot] = leveltext;
end
