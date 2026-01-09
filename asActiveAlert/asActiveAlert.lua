local configs = {
	size = 26,
	xpoint = -100,
	ypoint = 0,
	alpha = 0.9,
	fontsize = 10,
	blacklist = {
		--[115356] = true, --고술 바람의 일격
		--[455055] = true, --일거리 시작
	},
}

local main_frame = CreateFrame("Frame", nil, UIParent);
local spell_list = {};

local function get_spellicons(spellid)
	if not spellid then
		return nil;
	end

	local or_spellid = C_Spell.GetOverrideSpell(spellid)

	if or_spellid then
		spellid = or_spellid;
	end

	local info = C_Spell.GetSpellInfo(spellid);
	if info then
		return info.iconID, info.originalIconID;
	end
end

local function get_spellcooldown(spellid)
	if not spellid then
		return nil;
	end

	local or_spellid = C_Spell.GetOverrideSpell(spellid)

	if or_spellid then
		spellid = or_spellid;
	end

	local info = C_Spell.GetSpellCooldown(spellid);
	if info then
		return info.startTime, info.duration
	end
end

local function clear_cooldownframe(self)
	self:Clear();
end

local function set_cooldownframe(self, start, duration, enable, forceShowDrawEdge, modRate)
	if enable then
		self:SetDrawEdge(forceShowDrawEdge);
		self:SetCooldown(start, duration, modRate);
	else
		clear_cooldownframe(self);
	end
end

local function update_anchor(frames, index, size, offsetX, right, parent)
	local frame = frames[index];
	local point1 = "TOPLEFT";
	local point2 = "BOTTOMLEFT";
	local point3 = "TOPRIGHT";

	if (right == false) then
		point1 = "TOPRIGHT";
		point2 = "BOTTOMRIGHT";
		point3 = "TOPLEFT";
		offsetX = -offsetX;
	end

	if (index == 1) then
		frame:SetPoint(point1, parent, point2, 0, 0);
	else
		frame:SetPoint(point1, frames[index - 1], point3, offsetX, 0);
	end

	frame:SetWidth(size);
	frame:SetHeight(size * 0.9);
end

local function update_spells()
	local frame_idx = 1;
	local parent = main_frame;

	for _, id in pairs(spell_list) do
		local icon = get_spellicons(id);
		local start, duration, _ = get_spellcooldown(id);
		local isusable, notenoughmana = C_Spell.IsSpellUsable(id);

		if (icon) then
			local frame = parent.frames[frame_idx];

			if (not frame) then
				parent.frames[frame_idx] = CreateFrame("Button", nil, parent, "asActiveAlertFrameTemplate");
				frame = parent.frames[frame_idx];
				frame:EnableMouse(false);

				for _, r in next, { frame.cooldown:GetRegions() } do
					if r:GetObjectType() == "FontString" then
						r:SetFont(STANDARD_TEXT_FONT, configs.fontsize, "OUTLINE");
						r:SetDrawLayer("OVERLAY");
						break
					end
				end

				frame.icon:SetTexCoord(.08, .92, .08, .92)
				frame.icon:SetAlpha(configs.alpha);
				frame.border:SetTexCoord(0.08, 0.08, 0.08, 0.92, 0.92, 0.08, 0.92, 0.92)
				frame.border:SetVertexColor(0, 0, 0);
				frame.cooldown:Show();

				frame:ClearAllPoints();
				update_anchor(parent.frames, frame_idx, configs.size, 2, false, parent);
			end

			frame.icon:SetTexture(icon);

			if (isusable) then
				frame.icon:SetVertexColor(1.0, 1.0, 1.0);
			elseif (notenoughmana) then
				frame.icon:SetVertexColor(0.5, 0.5, 1.0);
			else
				frame.icon:SetVertexColor(0.4, 0.4, 0.4);
			end

			set_cooldownframe(frame.cooldown, start, duration, true);
			frame:Show();

			frame_idx = frame_idx + 1;
		end
	end

	for i = frame_idx, #parent.frames do
		local frame = parent.frames[i];

		if (frame) then
			frame:Hide();
		end
	end
end

local function insert_spell(id)
	if not id then
		return;
	end

	if configs.blacklist and configs.blacklist[id] then
		return;
	end

	if not C_SpellBook.IsSpellKnown(id) then
		return;
	end

	local _, org_icon = get_spellicons(id);

	if org_icon then
		if spell_list[org_icon] then
			return;
		end

		spell_list[org_icon] = id;

		update_spells();
	end
end

local function delete_spell(id)
	if id then
		local _, org_icon = get_spellicons(id);
		for previcon, spellid in pairs(spell_list) do
			if spellid == id or previcon == org_icon then
				spell_list[previcon] = nil;
			end
		end
	else
		spell_list = {};
	end
	update_spells();
end

local function on_event(self, event, arg1)
	if event == "SPELL_ACTIVATION_OVERLAY_GLOW_SHOW" then
		insert_spell(arg1)
	elseif event == "SPELL_ACTIVATION_OVERLAY_GLOW_HIDE" then
		delete_spell(arg1)
	elseif event == "SPELL_UPDATE_COOLDOWN" then
		update_spells();
	elseif event == "UNIT_SPELLCAST_SUCCEEDED" and (arg1 == "player" or arg1 == "pet") then
		update_spells();
	elseif event == "ACTIVE_TALENT_GROUP_CHANGED" or event == "PLAYER_ENTERING_WORLD" then
		delete_spell()
	end
end


do
	main_frame:SetPoint("CENTER", configs.xpoint, configs.ypoint);
	main_frame:SetWidth(1);
	main_frame:SetHeight(1);
	main_frame:SetScale(1);
	main_frame:RegisterEvent("SPELL_ACTIVATION_OVERLAY_GLOW_SHOW")
	main_frame:RegisterEvent("SPELL_ACTIVATION_OVERLAY_GLOW_HIDE")
	main_frame:RegisterEvent("SPELL_UPDATE_COOLDOWN")
	main_frame:RegisterEvent("UNIT_SPELLCAST_SUCCEEDED")
	main_frame:RegisterEvent("ACTIVE_TALENT_GROUP_CHANGED");
	main_frame:RegisterEvent("PLAYER_ENTERING_WORLD");
	main_frame:SetScript("OnEvent", on_event);
	main_frame:Show();
	main_frame.frames = {};
	local bloaded = C_AddOns.LoadAddOn("asMOD");

	if bloaded and ASMODOBJ.load_position then
		ASMODOBJ.load_position(main_frame, "asActiveAlert");
	end
end
