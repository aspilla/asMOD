local _, ns = ...;

local main_frame = CreateFrame("Frame");

-- Core function to remove padding and apply modifications. Doing Blizzard's work for them.
local function update_buttons(viewer)
	-- Don't apply modifications in edit mode
	if EditModeManagerFrame and EditModeManagerFrame:IsEditModeActive() then
		return
	end

	local childs = { viewer:GetChildren() };
	local isbuff = (viewer == BuffIconCooldownViewer);

	-- Get the visible icons (because they're fully dynamic)
	local visiblechilds = {}
	for _, child in ipairs(childs) do
		if child:IsShown() then
			-- Store original position for sorting
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
		local rate = 0.9;

		if isbuff then
			rate = 0.8;
		end

		if not button.bconfiged then
			local width = button:GetWidth();
			button.bconfiged = true;
			button:SetSize(width, width * rate);


			if button.Icon then
				local mask = button.Icon:GetMaskTexture(1)
				if mask then
					button.Icon:RemoveMaskTexture(mask);
				end
				button.Icon:ClearAllPoints();
				button.Icon:SetPoint("CENTER", 0, 0);
				button.Icon:SetSize(width - 4, width * rate - 4);
				button.Icon:SetTexCoord(.08, .92, .08, .92);
			end


			if button.ChargeCount then
				for _, r in next, { button.ChargeCount:GetRegions() } do
					if r:GetObjectType() == "FontString" then
						r:SetFont(STANDARD_TEXT_FONT, width / 3, "OUTLINE");
						r:ClearAllPoints();
						r:SetPoint("BOTTOM", 0, -5);
						r:SetTextColor(0, 1, 0);
						r:SetDrawLayer("OVERLAY");
						break;
					end
				end
			end

			if button.Applications then
				for _, r in next, { button.Applications:GetRegions() } do
					if r:GetObjectType() == "FontString" then
						r:SetFont(STANDARD_TEXT_FONT, width / 3 + 2, "OUTLINE");
						r:ClearAllPoints();
						r:SetPoint("Center", 0, 0);
						r:SetDrawLayer("OVERLAY");
						break;
					end
				end
			end


			if not button.border then
				button.border = button:CreateTexture(nil, "BACKGROUND", "asCombatInfoBorderTemplate");
				button.border:SetAllPoints(button);
				button.border:SetColorTexture(0, 0, 0, 1);
				button.border:SetTexCoord(0.08, 0.08, 0.08, 0.92, 0.92, 0.08, 0.92, 0.92);
			else
				button.border:SetAlpha(1)
			end
			button.border:Show()

			if button.Cooldown then
				for _, r in next, { button.Cooldown:GetRegions() } do
					if r:GetObjectType() == "FontString" then
						r:SetFont(STANDARD_TEXT_FONT, width / 3, "OUTLINE");
						r:ClearAllPoints();
						if isbuff then
							r:SetPoint("TOP", 0, 5);
						else
							r:SetPoint("CENTER", 0, 0);
						end
						r:SetDrawLayer("OVERLAY");
						break;
					end
				end

				button.asupdate = function()
					if button.cooldownUseAuraDisplayTime == true then
						button.border:SetColorTexture(0, 1, 1);
					else
						button.border:SetColorTexture(0, 0, 0);
					end
				end

				if button.astimer then
					button.astimer:Cancel();
				end

				button.astimer = C_Timer.NewTicker(0.2, button.asupdate);
			end
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

	-- Reposition buttons respecting orientation and stride
	local buttonWidth = visiblechilds[1]:GetWidth()
	local buttonHeight = visiblechilds[1]:GetHeight()

	-- Calculate grid dimensions
	local numIcons = #visiblechilds

	for i, child in ipairs(visiblechilds) do
		if bcentered then
			local index = i - 1
			local row = math.floor(index / stride)
			local col = index % stride

			-- Determine number of icons in this row
			local rowStart = row * stride + 1
			local rowEnd = math.min(rowStart + stride - 1, numIcons)
			local iconsInRow = rowEnd - rowStart + 1

			-- Compute the actual width of this row
			local rowWidth = iconsInRow * buttonWidth + (iconsInRow - 1) * overlap

			-- Center this row
			local rowStartX = -rowWidth / 2

			-- Column offset inside centered row
			local xOffset = rowStartX + col * (buttonWidth + overlap)
			local yOffset = row * (buttonHeight + overlap)
			child:ClearAllPoints();
			child:SetPoint("TOP", viewer, "TOP", xOffset + buttonWidth / 2, -yOffset);
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

-- Schedule an update to apply the modifications during the same frame, but after Blizzard is done mucking with things
local function add_todolist(viewer)
	todolist[viewer] = true
	updateframe:Show()
end

-- Do the work
local function init()
	local viewers = {
		UtilityCooldownViewer,
		EssentialCooldownViewer,
		BuffIconCooldownViewer,
	}

	for _, viewer in ipairs(viewers) do
		if viewer then
			update_buttons(viewer)

			-- Hook Layout to reapply when Blizzard updates
			if viewer.Layout then
				hooksecurefunc(viewer, "Layout", function()
					add_todolist(viewer)
				end)
			end

			-- Hook Show/Hide to reapply when icons appear/disappear
			local children = { viewer:GetChildren() }
			for _, child in ipairs(children) do
				child:HookScript("OnShow", function()
					add_todolist(viewer)
				end)
				child:HookScript("OnHide", function()
					add_todolist(viewer)
				end)
			end
		end
	end
end
-- Event handler
local bfirst = true;
local function on_event(self, event, arg)
	if bfirst then
		bfirst = false;
		ns.setup_option();
	end

	if event == "ADDON_LOADED" and arg == "Blizzard_CooldownManager" then
		C_Timer.After(1, init);
	elseif event == "PLAYER_ENTERING_WORLD" then
		C_Timer.After(1, init)
	end
end

main_frame:RegisterEvent("ADDON_LOADED");
main_frame:RegisterEvent("PLAYER_ENTERING_WORLD");
main_frame:SetScript("OnEvent", on_event);
