local _, ns      = ...

local rangeitems = {
	[5] =  37727, -- Ruby Acorn
	[8] = 34368, -- Attuned Crystal Cores
	[10] =  32321, -- Sparrowhawk Net
	[15] =  33069, -- Sturdy Rope
	[20] = 10645, -- Gnomish Death Ray
	[25] = 24268, -- Netherweave Net
	[30] = 835, -- Large Rope Net
	[35] = 24269, -- Heavy Netherweave Net
	[40] = 28767, -- The Decapitator
}

function ns.check_range(unit, spellid)
	local range = ns.SpellRanges[spellid];

	if spellid == 183752 and ns.spec == 3 then
		range = 30;
	end

	if range then
		local item = rangeitems[range];
		if item and unit then
			if not C_Item.IsItemInRange(item, unit) then
				return true;
			end
		end
	end

	return false;
end
