-- URL 기능
local DefaultSetItemRef = SetItemRef

--we replace the default setitemref and use it to parse links for alt invite and url copy
function SetItemRef(link, ...)
	local type, value = link:match("(%a+):(.+)")
	if (type == "url") then
		local eb = LAST_ACTIVE_CHAT_EDIT_BOX or ChatFrame1EditBox
		if not eb then return end
		eb:SetText(value)
		eb:SetFocus()
		eb:HighlightText()
		if not eb:IsShown() then eb:Show() end
	else
		return DefaultSetItemRef(link, ...)
	end
end

--AddMessage
local function AddMessage(self, text, ...)
	--url search
	text = text:gsub('([wWhH][wWtT][wWtT][%.pP]%S+[^%p%s])', '|cffffffff|Hurl:%1|h[%1]|h|r')
	return self.DefaultAddMessage(self, text, ...)
end

--skin chat
for i = 1, NUM_CHAT_WINDOWS do
	local chatframe = _G["ChatFrame" .. i]
	--adjust channel display
	if (i ~= 2) then
		chatframe.DefaultAddMessage = chatframe.AddMessage
		chatframe.AddMessage = AddMessage
	end
end