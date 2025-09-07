local _, ns = ...

--[[
local HarmItems         = {
	{ 37727,  5 }, -- Ruby Acorn
	{ 63427,  6 }, -- Worgsaw
	{ 34368,  8 }, -- Attuned Crystal Cores
	{ 32321,  10 }, -- Sparrowhawk Net
	{ 33069,  15 }, -- Sturdy Rope
	{ 10645,  20 }, -- Gnomish Death Ray
	{ 24268,  25 }, -- Netherweave Net
	{ 835,    30 }, -- Large Rope Net
	{ 24269,  35 }, -- Heavy Netherweave Net
	{ 28767,  40 }, -- The Decapitator
	{ 23836,  45 }, -- Goblin Rocket Launcher
	{ 116139, 50 }, -- Haunting Memento
	{ 32825,  60 }, -- Soul Cannon
	{ 41265,  70 }, -- Eyesore Blaster
	{ 35278,  80 }, -- Reinforced Net
	{ 33119,  100 }, -- Malister's Frost Wand
}
]]

local item_for_40m = 28767;
local item_for_25m = 24268;

local function IsHelpful(unit)
	if UnitIsUnit("player", unit) then
		return false;
	else
		local reaction = UnitReaction("player", unit);

		if reaction and reaction <= 4 then
			return false;
		else
			return true;
		end
	end
end

function ns.checkRange(unit, is25m)
	if UnitIsUnit("player", unit) then
		return true;
	end

	if IsHelpful(unit) then
		return true;
	end

	local item_id = item_for_40m;

	if is25m then
		item_id = item_for_25m;
	end

	if C_Item.IsItemInRange(item_id, unit) then
		return true;
	end
	return false;
end
