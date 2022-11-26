local onEvent = function(self)
	local c = C_Container;
	
	for b=0,4 do 
		for s=1,c.GetContainerNumSlots(b) do 
			local n = c.GetContainerItemLink(b,s);

			if n and string.find(n,"ff9d9d9d") then 
				print(n,"판매"); 
				c.UseContainerItem(b,s);
			end
		end
	end 
end

local asScavenger = CreateFrame("Frame", "ASV_main", UIParent);
asScavenger:SetScript("OnEvent", onEvent);
asScavenger:RegisterEvent("MERCHANT_SHOW");