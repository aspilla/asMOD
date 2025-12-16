-- URL 기능

--we replace the default setitemref and use it to parse links for alt invite and url copy
local function asSetItemRef(link, ...)
	local type, value = link:match("(%a+):(.+)")
	if (type == "url") then
		local eb = LAST_ACTIVE_CHAT_EDIT_BOX or ChatFrame1EditBox
		if not eb then return end
		eb:SetText(value)
		eb:SetFocus()
		eb:HighlightText()
		if not eb:IsShown() then eb:Show() end
	end
end

--AddMessage
local function asMOD_AddMessage(self, text, ...)

	if self:IsForbidden() then
		return
	end

	if issecretvalue(text) then
		return;
	end
	-- URL pattern to find URLs in the text
	local urlPattern = '([wWhH][wWtT][wWtT][%.pP]%S+[^%p%s])'

	-- Check if the pattern exists in the text
	if text:find(urlPattern) then
		-- Highlight and hyperlink the URLs
		text = text:gsub(urlPattern, '|cffffdd00|Hurl:%1|h[%1]|h|r')
	end

	-- Call the original message handler with the modified text
	if self.DefaultAddMessage then
		return self.DefaultAddMessage(self, text, ...)
	else
		return
	end
end

--skin chat
local chatframe = _G["ChatFrame" .. 1]
--adjust channel display
if chatframe then
	chatframe.DefaultAddMessage = chatframe.AddMessage
	chatframe.AddMessage = asMOD_AddMessage
end

hooksecurefunc("SetItemRef", asSetItemRef);
