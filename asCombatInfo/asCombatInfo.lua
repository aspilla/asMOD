local _, ns      = ...;

local configs    = {
	combatalpha = 1,
	normalalpha = 0.5,
	font = STANDARD_TEXT_FONT,
}

local _, Class   = UnitClass("player")
ns.classcolor    = RAID_CLASS_COLORS[Class];
ns.hotkeys       = {};
ns.hotkeyslots   = {};
ns.nextspellid   = nil;

local main_frame = CreateFrame("Frame");
local function update_bars(viewer)
	if not ns.options.ChangeBuffBar then
		return;
	end

	local childs = { viewer:GetChildren() };
	local visiblechilds = {}
	for _, child in ipairs(childs) do
		if child:IsShown() then
			table.insert(visiblechilds, child)
		end
	end

	if #visiblechilds == 0 then
		return
	end

	for _, item in ipairs(visiblechilds) do
		if ns.options.HideBarName then
			local bar = item.Bar;
			bar.Name:Hide();
		end

		if not item.bconfiged then
			item.bconfiged = true;

			if item.Bar then
				local bar = item.Bar;
				bar:SetStatusBarTexture("RaidFrame-Hp-Fill");
				if ns.options.BuffBarClassColor then
					bar:SetStatusBarColor(ns.classcolor.r, ns.classcolor.g, ns.classcolor.b);
				end
				bar.BarBG:Hide();

				bar.bg = bar:CreateTexture(nil, "BACKGROUND");
				bar.bg:SetPoint("TOPLEFT", bar, "TOPLEFT", -1, 1);
				bar.bg:SetPoint("BOTTOMRIGHT", bar, "BOTTOMRIGHT", 1, -1);
				bar.bg:SetColorTexture(0, 0, 0, 1);
			end

			if item.Icon then
				local button = item.Icon
				local height = item.Bar:GetHeight();

				local rate = 1.2;
				local iconrate = .16;
				button:SetSize(height * rate, height);
				button.Icon:ClearAllPoints();
				button.Icon:SetPoint("CENTER", 0, 0);
				button.Icon:SetSize(height * rate - 2, height - 2);
				button.Icon:SetTexCoord(.08, .92, iconrate, 1 - iconrate);

				if not button.border then
					button.border = button:CreateTexture(nil, "BACKGROUND");
					button.border:SetAllPoints(button);
					button.border:SetColorTexture(0, 0, 0, 1);
				else
					button.border:SetAlpha(1)
				end
				button.border:Show()

				if button.Applications then
					local r = button.Applications;
					if r:GetObjectType() == "FontString" then
						r:SetFont(configs.font, height / 2 + 3, "OUTLINE");
						r:SetTextColor(0, 1, 0);
					end
				end
			end
		end
	end

	if ns.options.TopAlignedBar then
		local buttonheight = visiblechilds[1]:GetHeight()

		for i, child in ipairs(visiblechilds) do
			local point, relativeTo, relativePoint, x, y = child:GetPoint(1);
			child:ClearAllPoints();
			child:SetPoint(point, relativeTo, relativePoint, x, -((buttonheight - 9) * (i - 1)));
		end
	elseif ns.options.BottomAlignedBar then
		local buttonheight = visiblechilds[1]:GetHeight()

		for i, child in ipairs(visiblechilds) do
			child:ClearAllPoints();
			child:SetPoint("BOTTOM", viewer, "BOTTOM", 0, ((buttonheight - 9) * (i - 1)));
		end
	end
end

local function get_spellhotkey(spellid)
	local text = ns.hotkeys[spellid];
	if text then
		return text;
	end

	local slots = C_ActionBar.FindSpellActionButtons(spellid)
	if slots and #slots > 0 then
		for _, slot in ipairs(slots) do
			text = ns.hotkeyslots[slot];
			if text then
				ns.hotkeys[spellid] = text;
				return text;
			end
		end
	end

	return nil;
end

local function update_buttons(viewer, forced)
	if EditModeManagerFrame and EditModeManagerFrame:IsEditModeActive() then
		return
	end

	local isbar = (viewer == BuffBarCooldownViewer);
	if isbar then
		update_bars(viewer);
		return;
	end


	local childs = { viewer:GetChildren() };
	local isbuff = (viewer == BuffIconCooldownViewer);

	local visiblechilds = {}
	for _, child in ipairs(childs) do
		if child:IsShown() then
			local point, relativeTo, relativePoint, x, y = child:GetPoint(1)
			child.originalX = x or 0
			child.originalY = y or 0
			table.insert(visiblechilds, child)
		end
	end

	if #visiblechilds == 0 then
		return
	end

	for _, button in ipairs(visiblechilds) do
		if button.bconfiged == nil or forced then
			local rate = math.min(ns.options.SpellIconRate / 10, 0.9);
			local iconrate = 0.08 + (0.9 - rate) / 2
			local borderwidth = ns.options.SpellBorderWidth;

			if isbuff then
				rate = math.min(ns.options.BuffIconRate / 10, 0.9);
				iconrate = 0.16 + (0.8 - rate) / 2;
				borderwidth = ns.options.BuffBorderWidth;
			end
			local width = button:GetWidth();
			button:SetSize(width, width * rate);


			if button.Icon then
				local mask = button.Icon:GetMaskTexture(1)
				if mask then
					button.Icon:RemoveMaskTexture(mask);
				end
				button.Icon:ClearAllPoints();
				button.Icon:SetPoint("CENTER", 0, 0);
				button.Icon:SetSize(width - borderwidth, width * rate - borderwidth);
				button.Icon:SetTexCoord(.08, .92, iconrate, 1 - iconrate);
			end


			if button.ChargeCount then
				for _, r in next, { button.ChargeCount:GetRegions() } do
					if r:GetObjectType() == "FontString" then
						r:SetFont(configs.font, width / 3 + 1, "OUTLINE");
						r:ClearAllPoints();
						r:SetPoint("CENTER", button, "BOTTOM", 0, 1);
						r:SetTextColor(0, 1, 0);
						r:SetDrawLayer("OVERLAY");
						break;
					end
				end
			end

			if button.DebuffBorder then
				button.DebuffBorder:ClearAllPoints();
				button.DebuffBorder:SetPoint("TOPLEFT", button, "TOPLEFT", -4, 4);
				button.DebuffBorder:SetPoint("BOTTOMRIGHT", button, "BOTTOMRIGHT", 4, -4);
			end

			if button.Applications then
				for _, r in next, { button.Applications:GetRegions() } do
					if r:GetObjectType() == "FontString" then
						r:SetFont(configs.font, width / 3 + 2, "OUTLINE");
						r:ClearAllPoints();
						r:SetPoint("CENTER", button, "BOTTOM", 0, 1);
						r:SetTextColor(0, 1, 0);
						r:SetDrawLayer("OVERLAY");
						break;
					end
				end
			end

			if not button.border then
				button.border = button:CreateTexture(nil, "BACKGROUND");
				button.border:SetAllPoints(button);
				button.border:SetColorTexture(0, 0, 0, 1);

				button.nextspell = button:CreateTexture(nil, "OVERLAY");
				button.nextspell:SetDrawLayer("OVERLAY", 7);
				button.nextspell:SetAtlas("talents-node-circle-greenglow");
				button.nextspell:SetPoint("CENTER", button, "CENTER", 0, 0);
				button.nextspell:SetSize(width / 2 + 3, width / 2 + 3);
				button.nextsize = 1;

				button.nextspell:Hide();
			else
				button.border:SetAlpha(1)
			end
			button.border:Show()

			if button.Cooldown then
				button.Cooldown:SetAllPoints(button.Icon)
				button.Cooldown:SetSwipeTexture("Interface\\Buttons\\WHITE8X8");
				button.Cooldown:SetSwipeColor(0, 0, 0, 0.8)
				for _, r in next, { button.Cooldown:GetRegions() } do
					if r:GetObjectType() == "FontString" then
						r:SetFont(configs.font, width / 3 + 1, "OUTLINE");
						r:ClearAllPoints();
						if isbuff then
							r:SetPoint("CENTER", button, "TOP", 0, 0);
						else
							r:SetPoint("CENTER", 0, 0);
						end
						r:SetDrawLayer("OVERLAY");
						break;
					end
				end
			end

			local function on_update()
				if button.cooldownUseAuraDisplayTime == true then
					button.border:SetColorTexture(0, 1, 1);
				else
					button.border:SetColorTexture(0, 0, 0);
				end

				if ns.options.AlertAssitedSpell then
					if ns.nextspellid and ns.nextspellid == button.asspellid then
						button.nextspell:Show();
						if button.nextsize == 1 then
							button.nextspell:SetSize(width / 3, width / 3);
							button.nextsize = 0;
						else
							button.nextspell:SetSize(width, width);
							button.nextsize = 1;
						end
					else
						button.nextspell:Hide();
					end
				end
			end

			if button.astimer then
				button.astimer:Cancel();
			end

			button.astimer = C_Timer.NewTicker(0.2, on_update);

			if not isbuff and ns.options.ShowHotKey then
				if not button.hotkey then
					button.hotkey = button:CreateFontString(nil, "ARTWORK");
					button.hotkey:SetFont(configs.font, width / 3 - 3, "OUTLINE");
					button.hotkey:SetPoint("TOPRIGHT", button, "TOPRIGHT", -2, -2);
					button.hotkey:SetTextColor(1, 1, 1, 1);
				end
				local spellid = button:GetSpellID();

				if not issecretvalue(spellid) then
					button.asspellid = spellid;
					local keytext = get_spellhotkey(spellid);

					if keytext and keytext ~= "●" then
						button.hotkey:SetText(keytext);
						button.hotkey:Show();
					else
						button.hotkey:Hide();
					end
				end
			end

			button.bconfiged = true;
		end
	end

	local isHorizontal = viewer.isHorizontal;

	if not isHorizontal then
		return;
	end

	local bcentered = true;

	if isbuff and not ns.options.AlignedBuff then
		bcentered = false;
	end

	local stride = viewer.stride or #visiblechilds
	local overlap = viewer.childXPadding;

	table.sort(visiblechilds, function(a, b)
		if math.abs(a.originalY - b.originalY) < 1 then
			return a.originalX < b.originalX
		end
		return a.originalY > b.originalY
	end)

	local buttonwidth = visiblechilds[1]:GetWidth()
	local buttonheight = visiblechilds[1]:GetHeight()


	local num_icons = #visiblechilds

	for i, child in ipairs(visiblechilds) do
		if bcentered then
			local index = i - 1
			local row = math.floor(index / stride)
			local col = index % stride

			local row_start = row * stride + 1
			local row_end = math.min(row_start + stride - 1, num_icons)
			local icons_in_row = row_end - row_start + 1

			local rowwidth = icons_in_row * buttonwidth + (icons_in_row - 1) * overlap


			local row_startX = -rowwidth / 2


			local xOffset = row_startX + col * (buttonwidth + overlap)
			local yOffset = row * (buttonheight + overlap)
			child:ClearAllPoints();
			child:SetPoint("TOP", viewer, "TOP", xOffset + buttonwidth / 2, -yOffset);
		else
			local point, relativeTo, relativePoint, x, y = child:GetPoint(1);
			child:ClearAllPoints();
			child:SetPoint(point, relativeTo, relativePoint, x, 0);
		end
	end
end

local updateframe = CreateFrame("Frame");
local todolist = {};
updateframe:Hide()

updateframe:SetScript("OnUpdate", function()
	updateframe:Hide()

	for viewer in pairs(todolist) do
		todolist[viewer] = nil
		update_buttons(viewer)
	end
end)

local function add_todolist(viewer)
	todolist[viewer] = true
	updateframe:Show()
end

local viewers = {
	UtilityCooldownViewer,
	EssentialCooldownViewer,
	BuffIconCooldownViewer,
	BuffBarCooldownViewer
}


local function check_name(name)
	name = string.gsub(name, "Num Pad ", "");
	name = string.gsub(name, "숫자패드 ", "");
	name = string.gsub(name, "Num Pad", "");
	name = string.gsub(name, "숫자패드", "");

	name = string.gsub(name, "Middle Mouse", "M3");
	name = string.gsub(name, "마우스 가운데 버튼", "M3");
	name = string.gsub(name, "Mouse Button (%d)", "M%1");
	name = string.gsub(name, "(%d)번 마우스 버튼", "M%1");
	name = string.gsub(name, "Mouse Wheel Up", "MU");
	name = string.gsub(name, "마우스 휠 위로", "MU");
	name = string.gsub(name, "Mouse Wheel Down", "MD");
	name = string.gsub(name, "마우스 휠 아래로", "MD");
	name = string.gsub(name, "^s%-", "S");
	name = string.gsub(name, "^a%-", "A");
	name = string.gsub(name, "^c%-", "C");
	name = string.gsub(name, "Delete", "Dt");
	name = string.gsub(name, "Page Down", "Pd");
	name = string.gsub(name, "Page Up", "Pu");
	name = string.gsub(name, "Insert", "In");
	name = string.gsub(name, "Del", "Dt");
	name = string.gsub(name, "Home", "Hm");
	name = string.gsub(name, "Capslock", "Ck");
	name = string.gsub(name, "Num Lock", "Nk");
	name = string.gsub(name, "Scroll Lock", "Sk");
	name = string.gsub(name, "Backspace", "Bs");
	name = string.gsub(name, "Spacebar", "Sb");
	name = string.gsub(name, "스페이스 바", "Sb");
	name = string.gsub(name, "End", "Ed");
	name = string.gsub(name, "Up Arrow", "^");
	name = string.gsub(name, "위 화살표", "^");
	name = string.gsub(name, "Down Arrow", "V");
	name = string.gsub(name, "아래 화살표", "V");
	name = string.gsub(name, "Right Arrow", ">");
	name = string.gsub(name, "오른쪽 화살표", ">");
	name = string.gsub(name, "Left Arrow", "<");
	name = string.gsub(name, "왼쪽 화살표", "<");

	return name;
end

local function scan_keys(name, total)
	for i = 1, total do
		local actionbutton = getglobal(name .. i);
		if not actionbutton then
			break
		end
		local hotkey = getglobal(actionbutton:GetName() .. "HotKey");
		if not hotkey then
			break
		end

		local text = hotkey:GetText();
		local slot = actionbutton.action;

		if name == "ActionButton" then
			slot = i;
		end

		if slot and text then
			local keytext = check_name(text);
			if keytext ~= "●" then
				if ns.hotkeyslots[slot] == nil then
					ns.hotkeyslots[slot] = keytext;
				end
			end
		end
	end
end

local function scan_actionslots()
	for slot = 1, 180 do
		local keytext = ns.hotkeyslots[slot];

		if slot > 72 and slot <= 108 then
			keytext = ns.hotkeyslots[(slot - 1) % 12 + 1];
		end

		if keytext then
			local type, id, subType = GetActionInfo(slot);
			if (type == "spell" or type == "macro") and id then
				if ns.hotkeys[id] == nil then
					ns.hotkeys[id] = keytext;
				end
			end
		end
	end
end

local function check_hotkeys()
	if not ns.options.ShowHotKey then
		return;
	end


	wipe(ns.hotkeys);
	wipe(ns.hotkeyslots);
	scan_keys("ActionButton", 12);
	scan_keys("MultiBarBottomLeftButton", 12);
	scan_keys("MultiBarBottomRightButton", 12);
	scan_keys("MultiBarRightButton", 12);
	scan_keys("MultiBarLeftButton", 12);
	scan_keys("MultiBar5Button", 12);
	scan_keys("MultiBar6Button", 12);
	scan_keys("MultiBar7Button", 12);
	scan_keys("BonusActionButton", 12);
	scan_keys("ExtraActionButton", 12);
	scan_keys("VehicleMenuBarActionButton", 12);
	scan_keys("OverrideActionBarButton", 12);
	scan_keys("PetActionButton", 10);

	scan_actionslots();
end

local function init()
	check_hotkeys();
	for _, viewer in ipairs(viewers) do
		if viewer then
			update_buttons(viewer, true);
			if viewer.Layout then
				hooksecurefunc(viewer, "Layout", function()
					add_todolist(viewer)
				end)
			end


			if viewer == BuffBarCooldownViewer then
				local children = { viewer:GetChildren() }
				for _, child in ipairs(children) do
					if ns.options.TopAlignedBar or ns.options.BottomAlignedBar then
						child:HookScript("OnShow", function()
							add_todolist(viewer);
						end)

						child:HookScript("OnHide", function()
							add_todolist(viewer);
						end)
					elseif ns.options.HideBarName then
						child:HookScript("OnShow", function()
							add_todolist(viewer);
						end)
					else
						child:HookScript("OnShow", function()
							if child.bconfiged == nil then
								add_todolist(viewer);
							end
						end)
					end
				end
			elseif viewer == BuffIconCooldownViewer then
				if ns.options.AlignedBuff then
					local children = { viewer:GetChildren() }
					for _, child in ipairs(children) do
						child:HookScript("OnShow", function()
							add_todolist(viewer);
						end)

						child:HookScript("OnHide", function()
							add_todolist(viewer);
						end)
					end
				else
					local children = { viewer:GetChildren() }
					for _, child in ipairs(children) do
						child:HookScript("OnShow", function()
							if child.bconfiged == nil then
								add_todolist(viewer);
							end
						end)
					end
				end
			end
		end
	end
end

function ns.refreshall()
	for _, viewer in ipairs(viewers) do
		if viewer then
			update_buttons(viewer, true);
		end
	end
end

local function set_viewersalpha(alpha)
	for _, viewer in ipairs(viewers) do
		viewer:SetAlpha(alpha);
	end
end


local bfirst = true;
local function on_event(self, event, arg)
	if bfirst then
		bfirst = false;
		ns.setup_option();
	end

	if event == "ADDON_LOADED" and arg == "Blizzard_CooldownManager" then
		C_Timer.After(0.5, init);
	elseif event == "PLAYER_REGEN_DISABLED" then
		if ns.options.CombatAlphaChange then
			set_viewersalpha(configs.combatalpha);
		end
	elseif event == "PLAYER_REGEN_ENABLED" then
		if ns.options.CombatAlphaChange then
			set_viewersalpha(configs.normalalpha);
		end
	else
		C_Timer.After(0.5, init);

		if ns.options.CombatAlphaChange then
			if UnitAffectingCombat("player") then
				set_viewersalpha(configs.combatalpha);
			else
				set_viewersalpha(configs.normalalpha);
			end
		end
	end
end

local function on_update()
	ns.nextspellid = C_AssistedCombat.GetNextCastSpell(true);
end

main_frame:RegisterEvent("ADDON_LOADED");
main_frame:RegisterEvent("PLAYER_ENTERING_WORLD");
main_frame:RegisterEvent("PLAYER_REGEN_DISABLED");
main_frame:RegisterEvent("PLAYER_REGEN_ENABLED");
main_frame:RegisterEvent("TRAIT_CONFIG_UPDATED");
main_frame:RegisterEvent("TRAIT_CONFIG_LIST_UPDATED");
main_frame:RegisterEvent("ACTIVE_TALENT_GROUP_CHANGED");

main_frame:SetScript("OnEvent", on_event);

C_Timer.NewTicker(0.2, on_update);
