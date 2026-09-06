-- URL 기능

--we replace the default setitemref and use it to parse links for alt invite and url copy
local function asSetItemRef(link, ...)
	local linktype, value = link:match("(%a+):(.+)")
	if (linktype == "url") then
		local eb = LAST_ACTIVE_CHAT_EDIT_BOX or ChatFrame1EditBox
		if not eb then return end
		eb:SetText(value)
		eb:SetFocus()
		eb:HighlightText()
		if not eb:IsShown() then eb:Show() end
	end
end

local function asMOD_AddMessageFilter(self, event, text, ...)
	if not text or issecretvalue(text) then
		return false, text, ...
	end

	local urlPattern = '([wWhH][wWtT][wWtT][%.pP]%S+[^%s%.,;:!%?%)%]%>%"\'])'

	if text:find(urlPattern) then
		text = text:gsub(urlPattern, '|cffffdd00|Hurl:%1|h[%1]|h|r')
		return false, text, ...
	end

	return false, text, ...
end

ChatFrame_AddMessageEventFilter("CHAT_MSG_CHANNEL", asMOD_AddMessageFilter)
ChatFrame_AddMessageEventFilter("CHAT_MSG_GUILD", asMOD_AddMessageFilter)
ChatFrame_AddMessageEventFilter("CHAT_MSG_OFFICER", asMOD_AddMessageFilter)
ChatFrame_AddMessageEventFilter("CHAT_MSG_PARTY", asMOD_AddMessageFilter)
ChatFrame_AddMessageEventFilter("CHAT_MSG_PARTY_LEADER", asMOD_AddMessageFilter)
ChatFrame_AddMessageEventFilter("CHAT_MSG_RAID", asMOD_AddMessageFilter)
ChatFrame_AddMessageEventFilter("CHAT_MSG_RAID_LEADER", asMOD_AddMessageFilter)
ChatFrame_AddMessageEventFilter("CHAT_MSG_RAID_WARNING", asMOD_AddMessageFilter)
ChatFrame_AddMessageEventFilter("CHAT_MSG_SAY", asMOD_AddMessageFilter)
ChatFrame_AddMessageEventFilter("CHAT_MSG_INSTANCE_CHAT", asMOD_AddMessageFilter)
ChatFrame_AddMessageEventFilter("CHAT_MSG_INSTANCE_CHAT_LEADER", asMOD_AddMessageFilter)
ChatFrame_AddMessageEventFilter("CHAT_MSG_SYSTEM", asMOD_AddMessageFilter)
ChatFrame_AddMessageEventFilter("CHAT_MSG_YELL", asMOD_AddMessageFilter)
ChatFrame_AddMessageEventFilter("CHAT_MSG_COMMUNITIES_CHANNEL", asMOD_AddMessageFilter)

hooksecurefunc("SetItemRef", asSetItemRef);
