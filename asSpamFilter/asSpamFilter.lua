local ASF_MaxTime = 4; --4초 뒤에도 같은 Message면 보이게
local ASF_X = 300;
local ASF_Y = 160;

asUIErrorsFrame:SetPoint("BOTTOM", ASF_X, ASF_Y);


C_AddOns.LoadAddOn("asMOD");
if asMOD_setupFrame then
	asMOD_setupFrame(asUIErrorsFrame, "asSpamFilter");
end
local originalOnEvent = UIErrorsFrame:GetScript("OnEvent")

local flashingFontStrings = {};

local FLASH_DURATION_SEC = 0.2;
local function asSpamOnUpdate()
	local now = GetTime();
	local needsMoreUpdates = false;
	for fontString, timeStart in pairs(flashingFontStrings) do
		if fontString:GetText() == fontString.origMsg then
			if fontString:IsShown() and now - timeStart <= FLASH_DURATION_SEC then
				local percent = (now - timeStart) / FLASH_DURATION_SEC;
				local easedPercent = (percent > .5 and (1.0 - percent) / .5 or percent / .5) * .4;

				fontString:SetTextColor(fontString.origR + easedPercent, fontString.origG + easedPercent,
					fontString.origB + easedPercent);
				needsMoreUpdates = true;
			else
				fontString:SetTextColor(fontString.origR, fontString.origG, fontString.origB);
				flashingFontStrings[fontString] = nil;
			end
		else
			flashingFontStrings[fontString] = nil;
		end
	end

	if not needsMoreUpdates then
		asUIErrorsFrame:SetScript("OnUpdate", nil);
	end
end


local THROTTLED_MESSAGE_TYPES = {
	[LE_GAME_ERR_SPELL_FAILED_TOTEMS] = true,
	[LE_GAME_ERR_SPELL_FAILED_EQUIPPED_ITEM] = true,
	[LE_GAME_ERR_SPELL_ALREADY_KNOWN_S] = true,
	[LE_GAME_ERR_SPELL_FAILED_SHAPESHIFT_FORM_S] = true,
	[LE_GAME_ERR_SPELL_FAILED_ALREADY_AT_FULL_MANA] = true,
	[LE_GAME_ERR_OUT_OF_MANA] = true,
	[LE_GAME_ERR_SPELL_OUT_OF_RANGE] = true,
	[LE_GAME_ERR_SPELL_FAILED_S] = true,
	[LE_GAME_ERR_SPELL_FAILED_REAGENTS] = true,
	[LE_GAME_ERR_SPELL_FAILED_REAGENTS_GENERIC] = true,
	[LE_GAME_ERR_SPELL_FAILED_NOTUNSHEATHED] = true,
	[LE_GAME_ERR_SPELL_UNLEARNED_S] = true,
	[LE_GAME_ERR_SPELL_FAILED_EQUIPPED_SPECIFIC_ITEM] = true,
	[LE_GAME_ERR_SPELL_FAILED_ALREADY_AT_FULL_POWER_S] = true,
	[LE_GAME_ERR_SPELL_FAILED_EQUIPPED_ITEM_CLASS_S] = true,
	[LE_GAME_ERR_SPELL_FAILED_ALREADY_AT_FULL_HEALTH] = true,
	[LE_GAME_ERR_GENERIC_NO_VALID_TARGETS] = true,

	[LE_GAME_ERR_ITEM_COOLDOWN] = true,
	[LE_GAME_ERR_CANT_USE_ITEM] = true,
	[LE_GAME_ERR_SPELL_FAILED_ANOTHER_IN_PROGRESS] = true,
};



local BLACK_LISTED_MESSAGE_TYPES = {
	[LE_GAME_ERR_ABILITY_COOLDOWN] = true,
	[LE_GAME_ERR_SPELL_COOLDOWN] = true,
	[LE_GAME_ERR_SPELL_FAILED_ANOTHER_IN_PROGRESS] = true,

	[LE_GAME_ERR_OUT_OF_HOLY_POWER] = true,
	[LE_GAME_ERR_OUT_OF_POWER_DISPLAY] = true,
	[LE_GAME_ERR_OUT_OF_SOUL_SHARDS] = true,
	[LE_GAME_ERR_OUT_OF_FOCUS] = true,
	[LE_GAME_ERR_OUT_OF_COMBO_POINTS] = true,
	[LE_GAME_ERR_OUT_OF_CHI] = true,
	[LE_GAME_ERR_OUT_OF_PAIN] = true,
	[LE_GAME_ERR_OUT_OF_HEALTH] = true,
	[LE_GAME_ERR_OUT_OF_RAGE] = true,
	[LE_GAME_ERR_OUT_OF_ARCANE_CHARGES] = true,
	[LE_GAME_ERR_OUT_OF_RANGE] = true,
	[LE_GAME_ERR_OUT_OF_ENERGY] = true,
	[LE_GAME_ERR_OUT_OF_LUNAR_POWER] = true,
	[LE_GAME_ERR_OUT_OF_RUNIC_POWER] = true,
	[LE_GAME_ERR_OUT_OF_INSANITY] = true,
	[LE_GAME_ERR_OUT_OF_RUNES] = true,
	[LE_GAME_ERR_OUT_OF_FURY] = true,
	[LE_GAME_ERR_OUT_OF_MAELSTROM] = true,
};


local function FlashFontString(fontString)
	if GetCVarBool("flashErrorMessageRepeats") then
		if flashingFontStrings[fontString] then
			flashingFontStrings[fontString] = GetTime();
		else
			fontString.origR, fontString.origG, fontString.origB = fontString:GetTextColor();
			fontString.origMsg = fontString:GetText();
			flashingFontStrings[fontString] = GetTime();
		end
		asUIErrorsFrame:SetScript("OnUpdate", asSpamOnUpdate);
	end
end


local function TryFlashingExistingMessage(messageType, message)
	local existingFontString = asUIErrorsFrame:GetFontStringByID(messageType);
	if existingFontString and existingFontString:GetText() == message then
		FlashFontString(existingFontString);

		asUIErrorsFrame:ResetMessageFadeByID(messageType);
		return true;
	end
	return false;
end


local function ShouldDisplayMessageType(messageType, message)
	if BLACK_LISTED_MESSAGE_TYPES[messageType] then
		return false;
	end

	if THROTTLED_MESSAGE_TYPES[messageType] then
		if TryFlashingExistingMessage(messageType, message) then
			return false;
		end
	end

	return true;
end

local function TryDisplayMessage(messageType, message, r, g, b)
	if ShouldDisplayMessageType(messageType, message) then
		asUIErrorsFrame:AddMessage(message, r, g, b, 1.0, messageType);

		local errorStringId, soundKitID, voiceID = GetGameMessageInfo(messageType);
		if voiceID then
			C_Sound.PlayVocalErrorSound(voiceID);
		elseif soundKitID then
			PlaySound(soundKitID);
		end
	end
end


UIErrorsFrame:SetScript("OnEvent",
	function(self, event, messageType, message, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9)
		if event == "UI_ERROR_MESSAGE" then
			TryDisplayMessage(messageType, message, RED_FONT_COLOR:GetRGB());
		else
			originalOnEvent(self, event, messageType, message, arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9)
		end
	end
)
