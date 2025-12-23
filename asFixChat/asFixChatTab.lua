--Tab 기능
local function BNet_GetBNetIDAccount(name)
	return GetAutoCompletePresenceID(name);
end


function ChatEdit_CustomTabPressed(self)
	local bBattle = false;
	local RTB_PVPType = C_PvP.GetZonePVPInfo();
	local bInstance, RTB_ZoneType = IsInInstance();
	local bRaid = (GetNumGroupMembers() > 0 and IsInRaid());
	local tellTarget = self:GetAttribute("tellTarget");
	bInstance = (IsInGroup(LE_PARTY_CATEGORY_INSTANCE) and IsInInstance());
	if RTB_PVPType == "combat" or RTB_ZoneType == "pvp" then
		bBattle = true;
	end

	-- SAY, PARTY, RAID, BATTLEGROUND, INSTANCE_CHAT, GUILD, WHISPER, BN_WHISFER

	local currchat = self:GetAttribute("chatType");

	if (currchat == "SAY") then
		if (GetNumSubgroupMembers() > 0) then
			self:SetAttribute("chatType", "PARTY")
		elseif (bRaid) then
			self:SetAttribute("chatType", "RAID")
		elseif (bBattle) then
			self:SetAttribute("chatType", "BATTLEGROUND")
		elseif (bInstance) then
			self:SetAttribute("chatType", "INSTANCE_CHAT")
		elseif (IsInGuild()) then
			self:SetAttribute("chatType", "GUILD")
		elseif (tellTarget) then
			if (BNet_GetBNetIDAccount(tellTarget)) then
				self:SetAttribute("chatType", "BN_WHISPER");
			else
				self:SetAttribute("chatType", "WHISPER");
			end
		else
			return
		end
	elseif (currchat == "PARTY") then
		if (bRaid) then
			self:SetAttribute("chatType", "RAID")
		elseif (bBattle) then
			self:SetAttribute("chatType", "BATTLEGROUND")
		elseif (bInstance) then
			self:SetAttribute("chatType", "INSTANCE_CHAT")
		elseif (IsInGuild()) then
			self:SetAttribute("chatType", "GUILD")
		elseif (tellTarget) then
			if (BNet_GetBNetIDAccount(tellTarget)) then
				self:SetAttribute("chatType", "BN_WHISPER");
			else
				self:SetAttribute("chatType", "WHISPER");
			end
		else
			self:SetAttribute("chatType", "SAY")
		end
	elseif (currchat == "RAID") then
		if (bBattle) then
			self:SetAttribute("chatType", "BATTLEGROUND")
		elseif (bInstance) then
			self:SetAttribute("chatType", "INSTANCE_CHAT")
		elseif (IsInGuild()) then
			self:SetAttribute("chatType", "GUILD")
		elseif (tellTarget) then
			if (BNet_GetBNetIDAccount(tellTarget)) then
				self:SetAttribute("chatType", "BN_WHISPER");
			else
				self:SetAttribute("chatType", "WHISPER");
			end
		else
			self:SetAttribute("chatType", "SAY")
		end
	elseif (currchat == "BATTLEGROUND") then
		if (bInstance) then
			self:SetAttribute("chatType", "INSTANCE_CHAT")
		elseif (IsInGuild()) then
			self:SetAttribute("chatType", "GUILD")
		elseif (tellTarget) then
			if (BNet_GetBNetIDAccount(tellTarget)) then
				self:SetAttribute("chatType", "BN_WHISPER");
			else
				self:SetAttribute("chatType", "WHISPER");
			end
		else
			self:SetAttribute("chatType", "SAY")
		end
	elseif (currchat == "INSTANCE_CHAT") then
		if (IsInGuild()) then
			self:SetAttribute("chatType", "GUILD")
		elseif (tellTarget) then
			if (BNet_GetBNetIDAccount(tellTarget)) then
				self:SetAttribute("chatType", "BN_WHISPER");
			else
				self:SetAttribute("chatType", "WHISPER");
			end
		else
			self:SetAttribute("chatType", "SAY")
		end
	elseif (currchat == "GUILD") then
		if (tellTarget) then
			if (BNet_GetBNetIDAccount(tellTarget)) then
				self:SetAttribute("chatType", "BN_WHISPER");
			else
				self:SetAttribute("chatType", "WHISPER");
			end
		else
			self:SetAttribute("chatType", "SAY")
		end
	else
		self:SetAttribute("chatType", "SAY")
	end

	ChatFrameEditBoxMixin.UpdateHeader(self);
end
