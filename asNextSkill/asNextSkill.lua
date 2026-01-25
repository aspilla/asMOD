local _, ns = ...;

local configs = {
	size = 40,
	xpoint = -60,
	ypoint = 0,
	alpha = 0.9,
	fontsize = 14,
}

local main_frame = CreateFrame("Button", nil, UIParent, "asNextSkillFrameTemplate");
local hotkey_cache = {};

local function get_spellhotkey(spellid)
	local cache = hotkey_cache[spellid];
	if cache then
		return cache;
	end

	local slots = C_ActionBar.FindSpellActionButtons(spellid)
	if slots and #slots > 0 then
		for _, slot in ipairs(slots) do
			local text = ns.hotkeys[slot];
			if text then
				return text;
			end
		end
	end
	return nil;
end

local function on_update()
	local nextspellid = C_AssistedCombat.GetNextCastSpell(ns.options.AssistShowOnly);

	if nextspellid then
		local info = C_Spell.GetSpellInfo(nextspellid);
		if info then
			main_frame.icon:SetTexture(info.iconID);
			local keytext = get_spellhotkey(nextspellid);
			if keytext then
				main_frame.keytext:SetText(keytext)
				main_frame.keytext:Show();
			else
				main_frame.keytext:Hide();
			end
			main_frame:Show();
		else
			main_frame:Hide();
		end
	end
end

local function on_event(self, event)

	if event == "UPDATE_BONUS_ACTIONBAR" then
		wipe(hotkey_cache);
		ns.refresh();
	else
		wipe(hotkey_cache);
		ns.check_hotkeys();
	end
end

local function init()
	ns.setup_option();

	if ASNS_Positions == nil then
		ASNS_Positions = {};
	end

	local libasConfig = LibStub:GetLibrary("LibasConfig", true);

	if libasConfig then
		libasConfig.load_position(main_frame, "asNextSkill", ASNS_Positions);
	end

	ns.check_hotkeys();
	main_frame:RegisterEvent("UPDATE_BONUS_ACTIONBAR");
	main_frame:RegisterEvent("PLAYER_ENTERING_WORLD");
	main_frame:RegisterEvent("TRAIT_CONFIG_UPDATED");
	main_frame:RegisterEvent("TRAIT_CONFIG_LIST_UPDATED");
	main_frame:RegisterEvent("ACTIVE_TALENT_GROUP_CHANGED");

	main_frame:SetScript("OnEvent", on_event);
	C_Timer.NewTicker(0.2, on_update);
end

main_frame.icon:SetTexCoord(.08, .92, .08, .92)
main_frame.icon:SetAlpha(configs.alpha);
main_frame.border:SetTexCoord(0.08, 0.08, 0.08, 0.92, 0.92, 0.08, 0.92, 0.92)
main_frame.border:SetVertexColor(0, 0, 0);
main_frame.keytext:ClearAllPoints();
main_frame.keytext:SetPoint("CENTER", main_frame, "CENTER", 0, 0);
main_frame.keytext:SetFont(STANDARD_TEXT_FONT, configs.fontsize, "OUTLINE");
main_frame.keytext:SetTextColor(0, 1, 0);
main_frame.keytext:SetText("");
main_frame.keytext:Show();



main_frame:ClearAllPoints();
main_frame:SetPoint("CENTER", UIParent, "CENTER", configs.xpoint, configs.ypoint);
main_frame:SetSize(configs.size, configs.size * 0.9);
main_frame:SetAlpha(configs.alpha);
main_frame:EnableMouse(false);
main_frame:Show();

C_Timer.After(0.5, init);
