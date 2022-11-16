local function asChatEdit_CustomTabPressed(this)

	local bBattle = false;

	local RTB_PVPType = GetZonePVPInfo();
	local bInstance, RTB_ZoneType = IsInInstance();
	local bRaid = (GetNumGroupMembers()>0 and IsInRaid());

	bInstance = (IsInGroup(LE_PARTY_CATEGORY_INSTANCE) and IsInInstance());

	if RTB_PVPType == "combat" or RTB_ZoneType == "pvp" then
		bBattle = true;
	end


	-- SAY, PARTY, RAID, BATTLEGROUND, GUIDE, INSTANCE_CHAT

	if  (this:GetAttribute("chatType") == "SAY")  then
		if (GetNumSubgroupMembers()>0) then
			this:SetAttribute("chatType", "PARTY")
			ChatEdit_UpdateHeader(this)
		elseif (bRaid) then
			this:SetAttribute("chatType", "RAID")
			ChatEdit_UpdateHeader(this)
		elseif (bBattle) then
			this:SetAttribute("chatType", "BATTLEGROUND")
			ChatEdit_UpdateHeader(this)
		elseif (IsInGuild()) then
			this:SetAttribute("chatType", "GUILD")
			ChatEdit_UpdateHeader(this)
		elseif (bInstance) then
			this:SetAttribute("chatType", "INSTANCE_CHAT")
			ChatEdit_UpdateHeader(this)
		else
			return
		end
	elseif (this:GetAttribute("chatType") == "PARTY") then
		if (bRaid) then
			this:SetAttribute("chatType", "RAID")
			ChatEdit_UpdateHeader(this)
		elseif (bBattle) then
			this:SetAttribute("chatType", "BATTLEGROUND")
			ChatEdit_UpdateHeader(this)
		elseif (IsInGuild()) then
			this:SetAttribute("chatType", "GUILD")
			ChatEdit_UpdateHeader(this)
		elseif (bInstance) then
			this:SetAttribute("chatType", "INSTANCE_CHAT")
			ChatEdit_UpdateHeader(this)
		else
			this:SetAttribute("chatType", "SAY")
			ChatEdit_UpdateHeader(this)
		end
	elseif (this:GetAttribute("chatType") == "RAID") then
		if (bBattle) then
			this:SetAttribute("chatType", "BATTLEGROUND")
			ChatEdit_UpdateHeader(this)
		elseif (IsInGuild()) then
			this:SetAttribute("chatType", "GUILD")
			ChatEdit_UpdateHeader(this)
		elseif (bInstance) then
			this:SetAttribute("chatType", "INSTANCE_CHAT")
			ChatEdit_UpdateHeader(this)
		else
			this:SetAttribute("chatType", "SAY")
			ChatEdit_UpdateHeader(this)
		end
	elseif (this:GetAttribute("chatType") == "BATTLEGROUND") then
		if (IsInGuild()) then
			this:SetAttribute("chatType", "GUILD")
			ChatEdit_UpdateHeader(this)
		elseif (bInstance) then
			this:SetAttribute("chatType", "INSTANCE_CHAT")
			ChatEdit_UpdateHeader(this)
		else
			this:SetAttribute("chatType", "SAY")
			ChatEdit_UpdateHeader(this)
		end
	elseif (this:GetAttribute("chatType") == "GUILD") then
		if (bInstance) then
			this:SetAttribute("chatType", "INSTANCE_CHAT")
			ChatEdit_UpdateHeader(this)
		else
			this:SetAttribute("chatType", "SAY")
			ChatEdit_UpdateHeader(this)
		end
	elseif (this:GetAttribute("chatType") ==  "INSTANCE_CHAT") then
		this:SetAttribute("chatType", "SAY")
		ChatEdit_UpdateHeader(this)

	elseif (this:GetAttribute("chatType") ==  "CHANNEL") then
		this:SetAttribute("chatType", "SAY")
		ChatEdit_UpdateHeader(this)

	end
end

CHAT_FONT_HEIGHTS = {[1] = 8, [2] = 9, [3] = 10, [4] = 11, [5] = 12, [6] = 13, [7] = 14, [8] = 15, [9] = 16, [10] = 17, [11] = 18, [12] = 19, [20] = 20}

hooksecurefunc("ChatEdit_OnTabPressed", asChatEdit_CustomTabPressed);
