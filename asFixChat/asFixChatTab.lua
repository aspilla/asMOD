local version = select(4, GetBuildInfo());

--Tab 기능
local function BNet_GetBNetIDAccount(name)
	return GetAutoCompletePresenceID(name);
end

if version >= 110207 then
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
else
	local function asChatEdit_CustomTabPressed(this)
		local bBattle = false;

		local RTB_PVPType = C_PvP.GetZonePVPInfo();
		local bInstance, RTB_ZoneType = IsInInstance();
		local bRaid = (GetNumGroupMembers() > 0 and IsInRaid());
		local tellTarget = this:GetAttribute("tellTarget");
		bInstance = (IsInGroup(LE_PARTY_CATEGORY_INSTANCE) and IsInInstance());
		if RTB_PVPType == "combat" or RTB_ZoneType == "pvp" then
			bBattle = true;
		end

		-- SAY, PARTY, RAID, BATTLEGROUND, INSTANCE_CHAT, GUILD, WHISPER, BN_WHISFER

		local currchat = this:GetAttribute("chatType");

		if (currchat == "SAY") then
			if (GetNumSubgroupMembers() > 0) then
				this:SetAttribute("chatType", "PARTY")
			elseif (bRaid) then
				this:SetAttribute("chatType", "RAID")
			elseif (bBattle) then
				this:SetAttribute("chatType", "BATTLEGROUND")
			elseif (bInstance) then
				this:SetAttribute("chatType", "INSTANCE_CHAT")
			elseif (IsInGuild()) then
				this:SetAttribute("chatType", "GUILD")
			elseif (tellTarget) then
				if (BNet_GetBNetIDAccount(tellTarget)) then
					this:SetAttribute("chatType", "BN_WHISPER");
				else
					this:SetAttribute("chatType", "WHISPER");
				end
			else
				return
			end
		elseif (currchat == "PARTY") then
			if (bRaid) then
				this:SetAttribute("chatType", "RAID")
			elseif (bBattle) then
				this:SetAttribute("chatType", "BATTLEGROUND")
			elseif (bInstance) then
				this:SetAttribute("chatType", "INSTANCE_CHAT")
			elseif (IsInGuild()) then
				this:SetAttribute("chatType", "GUILD")
			elseif (tellTarget) then
				if (BNet_GetBNetIDAccount(tellTarget)) then
					this:SetAttribute("chatType", "BN_WHISPER");
				else
					this:SetAttribute("chatType", "WHISPER");
				end
			else
				this:SetAttribute("chatType", "SAY")
			end
		elseif (currchat == "RAID") then
			if (bBattle) then
				this:SetAttribute("chatType", "BATTLEGROUND")
			elseif (bInstance) then
				this:SetAttribute("chatType", "INSTANCE_CHAT")
			elseif (IsInGuild()) then
				this:SetAttribute("chatType", "GUILD")
			elseif (tellTarget) then
				if (BNet_GetBNetIDAccount(tellTarget)) then
					this:SetAttribute("chatType", "BN_WHISPER");
				else
					this:SetAttribute("chatType", "WHISPER");
				end
			else
				this:SetAttribute("chatType", "SAY")
			end
		elseif (currchat == "BATTLEGROUND") then
			if (bInstance) then
				this:SetAttribute("chatType", "INSTANCE_CHAT")
			elseif (IsInGuild()) then
				this:SetAttribute("chatType", "GUILD")
			elseif (tellTarget) then
				if (BNet_GetBNetIDAccount(tellTarget)) then
					this:SetAttribute("chatType", "BN_WHISPER");
				else
					this:SetAttribute("chatType", "WHISPER");
				end
			else
				this:SetAttribute("chatType", "SAY")
			end
		elseif (currchat == "INSTANCE_CHAT") then
			if (IsInGuild()) then
				this:SetAttribute("chatType", "GUILD")
			elseif (tellTarget) then
				if (BNet_GetBNetIDAccount(tellTarget)) then
					this:SetAttribute("chatType", "BN_WHISPER");
				else
					this:SetAttribute("chatType", "WHISPER");
				end
			else
				this:SetAttribute("chatType", "SAY")
			end
		elseif (currchat == "GUILD") then
			if (tellTarget) then
				if (BNet_GetBNetIDAccount(tellTarget)) then
					this:SetAttribute("chatType", "BN_WHISPER");
				else
					this:SetAttribute("chatType", "WHISPER");
				end
			else
				this:SetAttribute("chatType", "SAY")
			end
		else
			this:SetAttribute("chatType", "SAY")
		end
		ChatEdit_UpdateHeader(this);
	end

	--CHAT_FONT_HEIGHTS = {[1] = 8, [2] = 9, [3] = 10, [4] = 11, [5] = 12, [6] = 13, [7] = 14, [8] = 15, [9] = 16, [10] = 17, [11] = 18, [12] = 19, [20] = 20}

	hooksecurefunc("ChatEdit_OnTabPressed", asChatEdit_CustomTabPressed);
end
