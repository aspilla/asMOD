
local function on_event(self)
	local c = C_Container;

	for bag = 0, 4 do
		if c.GetContainerNumSlots(bag) > 0 then
			for slot = 0, c.GetContainerNumSlots(bag) do
				local link = c.GetContainerItemLink(bag, slot)

				if link then
					local itemName, itemLink, itemRarity = C_Item.GetItemInfo(link)

					if itemRarity == 0 then
						c.UseContainerItem(bag, slot)
					end
				end
			end
		end
	end
end

local main_frame = CreateFrame("Frame", nil, UIParent);
main_frame:SetScript("OnEvent", on_event);
main_frame:RegisterEvent("MERCHANT_SHOW");
