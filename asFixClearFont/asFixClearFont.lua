local ClearFont = {};

local CLEAR_FONT_BASE = "Interface\\AddOns\\asFixClearFont\\Fonts\\";
local CLEAR_FONT = CLEAR_FONT_BASE .. "ClearFont.ttf";
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
end

ClearFont:ApplySystemFonts()