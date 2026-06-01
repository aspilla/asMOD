local configs = {
	pertick = 10,
	ticktime = 1,
}

local gvalues = {
	timer = nil,
}

local function get_trashlist()
	local c = C_Container;
	local list = {};

	for bag = 0, 4 do
		if c.GetContainerNumSlots(bag) > 0 then
			for slot = 0, c.GetContainerNumSlots(bag) do
				local link = c.GetContainerItemLink(bag, slot)

				if link then
					local itemName, itemLink, itemRarity = C_Item.GetItemInfo(link)

					if itemRarity == 0 then
						table.insert(list, { b = bag, s = slot });
					end
				end
			end
		end
	end

	return list;
end





local function on_event(self)
	local list = get_trashlist();
	local count = math.floor(#list / configs.pertick) + 1;
	local c = C_Container;
	local idx = 1;

	local function sell_trash()
		for i = 1, configs.pertick do
			if not (MerchantFrame and MerchantFrame:IsShown()) then
				gvalues.timer:Cancel();
				return;
			end

			if idx > #list then
				gvalues.timer:Cancel();
				return;
			end

			local bag = list[idx].b;
			local slot = list[idx].s;

			c.UseContainerItem(bag, slot);
			idx = idx + 1;
		end
	end

	if gvalues.timer then
		gvalues.timer:Cancel();
	end

	if count > 0 then
		gvalues.timer = C_Timer.NewTicker(configs.ticktime, sell_trash, count);
	end
end

local main_frame = CreateFrame("Frame", nil, UIParent);
main_frame:SetScript("OnEvent", on_event);
main_frame:RegisterEvent("MERCHANT_SHOW");
