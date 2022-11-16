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
}

local fontstrings = {};


function GearScore_OnEvent(GS_Nil, GS_EventName, GS_Prefix, GS_AddonMessage, GS_Whisper, GS_Sender)
	if ( GS_EventName == "PLAYER_REGEN_ENABLED" ) then GS_PlayerIsInCombat = false; return; end
	if ( GS_EventName == "PLAYER_REGEN_DISABLED" ) then GS_PlayerIsInCombat = true; return; end
	if ( GS_EventName == "PLAYER_EQUIPMENT_CHANGED" ) then
		MyPaperDoll(GS_Nil);
	end
end

local scantip = nil;
local level_txt = string.gsub(ITEM_LEVEL, "%%d", "(.+)")
local level_txt2 = string.gsub(ITEM_LEVEL, "%%d", "(.+) \((.+)\)")

function GetItemLevel (unit, slot)

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
			if(retval ~= nil) then
				return retval
			else
				local iLevel2 = string.match(text, level_txt2)
				if iLevel2 ~= nil then
					local retval2 = tonumber(iLevel2)
					if(retval2 ~= nil) then
						return retval2
					end
				end				
			end
		end
	end


end

function GetAvgIvl(unit)

    local t,c=0,0
	local min = 0xFFFFFFFF;
	local max = 0
	local weapon_lvl;
	local weapon_count = 0;
	local two_head = nil;
	  

	 for i =1,#itemslots do 

		local  idx = GetInventorySlotInfo(itemslots[i]);

		local k= GetInventoryItemLink(unit,idx) 

		if k then 
			 local name,_,quality ,_=GetItemInfo(k) 
			 lvl = GetItemLevel(unit, idx);

			 if lvl and lvl > 0 and quality  then
				 fontstrings[unit][i]:SetText(lvl);
				 local r,g,b = GetItemQualityColor(quality);
				 fontstrings[unit][i]:SetTextColor(r,g,b);
			 end

				
			 --[[if quality == 6 then 
				 --유물무기
				  if lvl and lvl > 0  then

					 if (weapon_lvl and weapon_lvl < lvl) or not weapon_lvl then
						 weapon_lvl = lvl;
					 end
				 end
else --]]

				 if idx == 16 or idx == 17 then
					 weapon_count = weapon_count + 1;
					 two_head = lvl;
				 end

				 if lvl and lvl > 0  then
					 
					 t=t+lvl 
					 c=c+1 
					 if quality < min then
						 min = quality
					 end

					 if quality > max then
						 max = quality
					 end
				 end
--			 end
		else
			fontstrings[unit][i]:SetText("");
		end 

	 end 

	if weapon_lvl then
		t=t+ (weapon_lvl *2)
		c=c+2
	end

	if weapon_count == 1 and two_head then
		t = t + two_head;
		c = c +1;
	end

	 if min == 0xFFFFFFFF then
		 min = 0;
	 end
		
	 return floor(t/c), max, min

end


function MyPaperDoll(self)
	if ( GS_PlayerIsInCombat ) then return; end
	
	local Avg, Max, Min = GetAvgIvl("player");

	local Red, Green, Blue = GetItemQualityColor(Min);
	PAvg:SetText(Avg); 
	PAvg:SetTextColor(Red, Green, Blue)

end

local update = 0;

function MyInspectDoll(self, elapsed)

	update = update + elapsed;

	if update >= 1  then
		update = 0
	else
		return
	end

	local frame = _G["TargetGearScore"]

	if ( GS_PlayerIsInCombat ) then return; end

	local Avg, Max, Min = GetAvgIvl("target");

	local Red, Green, Blue = GetItemQualityColor(Min);
	TAvg:SetText(Avg); 
	TAvg:SetTextColor(Red, Green, Blue)

end



-------------------------------------------------------------------------------


------------------------ GUI PROGRAMS -------------------------------------------------------

local f = CreateFrame("Frame", "GearScore", UIParent);
local font, _, flags = NumberFontNormal:GetFont()

f:SetScript("OnEvent", GearScore_OnEvent);
f:RegisterEvent("PLAYER_EQUIPMENT_CHANGED");
f:RegisterEvent("ADDON_LOADED")
f:RegisterEvent("PLAYER_REGEN_ENABLED")
f:RegisterEvent("PLAYER_REGEN_DISABLED")

CharacterModelFrame:HookScript("OnShow", MyPaperDoll)

CharacterModelFrame:CreateFontString("PTxt")
PTxt:SetFont(font, AGS_FontSize, flags)
PTxt:SetText("ItemLevel")
PTxt:SetPoint("BOTTOMLEFT",CharacterModelFrame,"TOPLEFT",10,-280)
PTxt:Show()

CharacterModelFrame:CreateFontString("PAvg")
PAvg:SetFont(font, AGS_FontSize + 2, flags)
PAvg:SetText("Avg: 0")
PAvg:SetPoint("BOTTOMLEFT",CharacterModelFrame,"TOPLEFT",10,-295)
PAvg:Show()

inspectframe = _G["InspectModelFrame"]
inspectframe:HookScript("OnUpdate", MyInspectDoll)

inspectframe:CreateFontString("TTxt")
TTxt:SetFont(font, AGS_FontSize, flags)
TTxt:SetText("ItemLevel")
TTxt:SetPoint("BOTTOMLEFT",inspectframe,"TOPLEFT",10,-280)
TTxt:Show()

inspectframe:CreateFontString("TAvg")
TAvg:SetFont(font, AGS_FontSize + 2, flags)
TAvg:SetText("Avg: 0")
TAvg:SetPoint("BOTTOMLEFT",inspectframe,"TOPLEFT",10,-295)
TAvg:Show()

fontstrings["player"] = {};
fontstrings["target"] = {};

for slot,n in pairs(itemslots) do
	local gslot = _G["Character"..n]
	fontstrings["player"][slot] = gslot:CreateFontString(nil, "OVERLAY")
	fontstrings["player"][slot]:SetFont(font, AGS_FontSize, flags)
	fontstrings["player"][slot]:SetPoint("TOP", gslot, "TOP", 0, -3)
	fontstrings["player"][slot]:SetTextColor(1,1,1)
end

for slot,n in pairs(itemslots) do
	local gslot = _G["Inspect"..n]
	fontstrings["target"][slot] = gslot:CreateFontString(nil, "OVERLAY")
	fontstrings["target"][slot]:SetFont(font, AGS_FontSize, flags)
	fontstrings["target"][slot]:SetPoint("TOP", gslot, "TOP", 0, -3)
	fontstrings["target"][slot]:SetTextColor(1,1,1)
end
