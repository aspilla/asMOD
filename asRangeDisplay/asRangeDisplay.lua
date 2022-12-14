-- 설정 (변경가능)
local ARD_Font = "Fonts\\2002.TTF";
local ARD_FontSize = 16;
local ARD_FontOutline = "THICKOUTLINE";
local ARD_X	= 0;
local ARD_Y = -160;
local ARD_AHT = false				-- asHealthText에 연결
-- 설정끝

local ARD_mainframe = CreateFrame("Frame", "ARD_main", UIParent);


local FriendItems  = {
    {37727, 5}, -- Ruby Acorn
    {63427, 6}, -- Worgsaw
    {34368, 8},-- Attuned Crystal Cores
    {32321, 10},-- Sparrowhawk Net
	{1251, 15}, -- Linen Bandage
   	{21519,20}, -- Mistletoe
	{31463,25}, -- Zezzak's Shard
    {1180, 30}, -- Scroll of Stamina
   	{18904,35}, -- Zorbin's Ultra-Shrinker
	{34471,40}, -- Vial of the Sunwell
    {32698,45}, -- Wrangling Rope
	{116139,50}, -- Haunting Memento
	{32825,60}, -- Soul Cannon
	{41265,70}, -- Eyesore Blaster
	{35278,80}, -- Reinforced Net
}

local HarmItems = {
    {37727,5}, -- Ruby Acorn
	{63427,6}, -- Worgsaw
	{34368,8}, -- Attuned Crystal Cores
	{32321,10}, -- Sparrowhawk Net
	{33069,15}, -- Sturdy Rope
	{10645,20}, -- Gnomish Death Ray
	{24268,25}, -- Netherweave Net
	{835, 30}, -- Large Rope Net
	{24269,35}, -- Heavy Netherweave Net
	{28767,40}, -- The Decapitator
	{23836,45}, -- Goblin Rocket Launcher
	{116139,50}, -- Haunting Memento
	{32825,60}, -- Soul Cannon
	{41265,70}, -- Eyesore Blaster
	{35278,80}, -- Reinforced Net
	{33119,100}, -- Malister's Frost Wand
}


local function ARD_CheckRange(unit)

	local isHarm = true;
	local itemlist = FriendItems;

	if UnitIsUnit("player", unit) then
		return 0;
	else
		local reaction = UnitReaction("player", unit);

		if reaction and reaction <= 4 then
			isHarm = true;
		else
			isHarm = false;
		end
	end
	
	if isHarm then
		itemlist = HarmItems;
	end

	for i = 1, #itemlist do

		if GetItemInfo(itemlist[i][1]) and IsItemInRange(itemlist[i][1], unit) then
			return itemlist[i][2];
		end
	end

	return 0;
end

local function ARD_GetRangeColor(range)

	if not range or range == 0 then
		return 0.9, 0.9, 0.9;
	end
	
	if range > 40 then
		return 1, 0, 0;
	elseif range > 30 then
		return 1.0, 0.82, 0;
	elseif range > 20 then
		return 0.035, 0.865, 0.0;
	elseif range > 5 then
		return 0.055, 0.875, 0.825
	else
		return 0.9, 0.9, 0.9;
	end

end

local function ARD_OnUpdate()

	if UnitExists("target") then
		local range = ARD_CheckRange("target");
		if range == 0 then
			ARD_RangeText:SetText("");
		else
			ARD_RangeText:SetText(range);
		end
		ARD_RangeText:SetTextColor(ARD_GetRangeColor(range));
	else
		ARD_RangeText:SetText("");
	end	
end

local function ARD_OnLoad()

	ARD_mainframe:CreateFontString("ARD_RangeText", "OVERLAY")
	ARD_RangeText:SetFont(ARD_Font, ARD_FontSize, ARD_FontOutline)

	local bloaded =  LoadAddOn("asHealthText")
	
	if bloaded and ARD_AHT then
		ARD_RangeText:SetPoint("LEFT", "AHT_RaidIcon", "RIGHT", 2, 0);
	else
		ARD_RangeText:SetPoint("CENTER", UIParent, "CENTER", ARD_X, ARD_Y);
	end

	ARD_RangeText:SetText("");
	ARD_RangeText:Show();


	ARD_mainframe:RegisterEvent("PLAYER_TARGET_CHANGED");
end


function ARD_OnEvent(self, event, arg1, arg2, arg3, ...)

	if event == "PLAYER_TARGET_CHANGED" then
		local range = ARD_CheckRange("target");
		if range == 0 then
			ARD_RangeText:SetText("");
		else
			ARD_RangeText:SetText(range);
		end

		ARD_RangeText:SetTextColor(ARD_GetRangeColor(range));

	end
end

ARD_mainframe:SetScript("OnEvent", ARD_OnEvent);
ARD_OnLoad();
C_Timer.NewTicker(0.25, ARD_OnUpdate);