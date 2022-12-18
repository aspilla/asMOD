local onEvent = function(self)
	local c = C_Container;
	
	for bag = 0, 4 do
    	if c.GetContainerNumSlots(bag) > 0 then
			for slot = 0, c.GetContainerNumSlots(bag) do
				local link = c.GetContainerItemLink(bag, slot)
			
				if link then
					local itemName, itemLink, itemRarity = GetItemInfo(link)
				
					if itemRarity == 0 then
						c.UseContainerItem(bag, slot)
					end
				end
			  end
	    end
	end
end

local asScavenger = CreateFrame("Frame", "ASV_main", UIParent);
asScavenger:SetScript("OnEvent", onEvent);
asScavenger:RegisterEvent("MERCHANT_SHOW");