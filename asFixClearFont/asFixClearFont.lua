ClearFont = CreateFrame("Frame", nil);

local CLEAR_FONT_BASE = "Interface\\AddOns\\asFixClearFont\\Fonts\\";
--local CLEAR_FONT_BASE = "Fonts\\";

local CLEAR_FONT = CLEAR_FONT_BASE .. "ClearFont.ttf";
--local CLEAR_FONT =  "Fonts\2002.TTF";

local CF_SCALE = 1.0

local function CanSetFont(object) 
   return (type(object)=="table" 
	   and object.SetFont and object.IsObjectType 
	      and not object:IsObjectType("SimpleHTML")); 
end

function ClearFont:ApplySystemFonts()

   if (CanSetFont(NumberFontNormal)) then 		NumberFontNormal:SetFont(CLEAR_FONT, 12 * CF_SCALE, "OUTLINE"); end
   if (CanSetFont(NumberFontNormalYellow)) then 	NumberFontNormalYellow:SetFont(CLEAR_FONT, 12 * CF_SCALE, "OUTLINE"); end
   if (CanSetFont(NumberFontNormalSmall)) then 		NumberFontNormalSmall:SetFont(CLEAR_FONT, 11 * CF_SCALE, "OUTLINE"); end
   if (CanSetFont(NumberFontNormalSmallGray)) then 	NumberFontNormalSmallGray:SetFont(CLEAR_FONT, 11 * CF_SCALE, "OUTLINE"); end
   if (CanSetFont(NumberFontNormalLarge)) then 		NumberFontNormalLarge:SetFont(CLEAR_FONT, 13 * CF_SCALE, "OUTLINE"); end
   if (CanSetFont(NumberFontNormalHuge)) then 		NumberFontNormalHuge:SetFont(CLEAR_FONT, 18 * CF_SCALE, "THICKOUTLINE"); end
   --if (CanSetFont(SystemFont_Outline_Small)) then 		SystemFont_Outline_Small:SetFont(CLEAR_FONT, 11 * CF_SCALE, "OUTLINE"); end
 --[[
   if (CanSetFont(GameFontHighlight)) then 		GameFontHighlight:SetFont(CLEAR_FONT, 13 * CF_SCALE, "NORMAL"); end
   if (CanSetFont(GameFontHighlightSmall)) then 		GameFontHighlightSmall:SetFont(CLEAR_FONT, 12 * CF_SCALE, "NORMAL"); end
   if (CanSetFont(GameFontNormalSmall)) then 		GameFontNormalSmall:SetFont(CLEAR_FONT, 12 * CF_SCALE, "NORMAL"); end
   if (CanSetFont(GameTooltipText)) then 		GameTooltipText:SetFont(CLEAR_FONT, 13 * CF_SCALE, "NORMAL"); end
   if (CanSetFont(ChatFontNormal)) then 		ChatFontNormal:SetFont(CLEAR_FONT, 13 * CF_SCALE, "NORMAL"); end
   if (CanSetFont(GameNormalNumberFont)) then 		GameNormalNumberFont:SetFont(CLEAR_FONT, 13 * CF_SCALE, "NORMAL"); end
   if (CanSetFont(GameFontNormalSmall)) then 		GameFontNormalSmall:SetFont(CLEAR_FONT, 12 * CF_SCALE, "NORMAL"); end
--]]

  
end

ClearFont:ApplySystemFonts()
