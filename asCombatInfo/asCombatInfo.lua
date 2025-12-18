local addon = CreateFrame("Frame")
addon:RegisterEvent("ADDON_LOADED")
addon:RegisterEvent("PLAYER_ENTERING_WORLD")

local updateBucket = {}

-- Core function to remove padding and apply modifications. Doing Blizzard's work for them.
local function RemovePadding(viewer)
	-- Don't apply modifications in edit mode
	if EditModeManagerFrame and EditModeManagerFrame:IsEditModeActive() then
		return
	end

	local children = { viewer:GetChildren() };
	local isbuff = (viewer == _G.BuffIconCooldownViewer);


	-- Get the visible icons (because they're fully dynamic)
	local visibleChildren = {}
	for _, child in ipairs(children) do
		if child:IsShown() then
			-- Store original position for sorting
			local point, relativeTo, relativePoint, x, y = child:GetPoint(1)
			child.originalX = x or 0
			child.originalY = y or 0
			table.insert(visibleChildren, child)
		end
	end

	if #visibleChildren == 0 then return end
	local isHorizontal = viewer.isHorizontal

	-- Sort by original position for all viewers
	if isHorizontal then
		table.sort(visibleChildren, function(a, b)
			if math.abs(a.originalY - b.originalY) < 1 then
				return a.originalX < b.originalX
			end
			return a.originalY > b.originalY
		end)
	else
		table.sort(visibleChildren, function(a, b)
			if math.abs(a.originalX - b.originalX) < 1 then
				return a.originalY > b.originalY
			end
			return a.originalX < b.originalX
		end)
	end

	local stride = viewer.stride or #visibleChildren
	local overlap = 0;


	for _, button in ipairs(visibleChildren) do
		local rate = 0.9;

		if isbuff then
			rate = 0.8;
		end

		button:SetSize(button:GetWidth(), button:GetWidth() * rate);


		if button.Icon then
			local mask = button.Icon:GetMaskTexture(1)
			if mask then
				button.Icon:RemoveMaskTexture(mask);
			end
			button.Icon:ClearAllPoints();
			button.Icon:SetPoint("CENTER", 0, 0);
			button.Icon:SetSize(button:GetWidth() - 4, button:GetWidth() * rate - 4);
			button.Icon:SetTexCoord(.08, .92, .08, .92);
		end


		if button.ChargeCount then
			for _, r in next, { button.ChargeCount:GetRegions() } do
				if r:GetObjectType() == "FontString" then
					r:SetFont(STANDARD_TEXT_FONT, 15, "OUTLINE");
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
					r:SetFont(STANDARD_TEXT_FONT, 15, "OUTLINE");
					r:ClearAllPoints();
					r:SetPoint("Center", 0, 0);
					r:SetDrawLayer("OVERLAY");
					break;
				end
			end
		end


		if not button.border then
			button.border = button:CreateTexture(nil, "BACKGROUND")
			button.border:SetTexture("Interface\\Addons\\asCombatInfo\\border.tga")
			button.border:SetAllPoints(button);
			button.border:SetColorTexture(0, 0, 0);
			button.border:SetTexCoord(0.08, 0.08, 0.08, 0.92, 0.92, 0.08, 0.92, 0.92);
		else
			button.border:SetAlpha(1)
		end
		button.border:Show()

		if button.Cooldown then
			for _, r in next, { button.Cooldown:GetRegions() } do
				if r:GetObjectType() == "FontString" then
					r:SetFont(STANDARD_TEXT_FONT, 15, "OUTLINE");
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

	-- Reposition buttons respecting orientation and stride
	local buttonWidth = visibleChildren[1]:GetWidth()
	local buttonHeight = visibleChildren[1]:GetHeight()

	-- Calculate grid dimensions
	local numIcons = #visibleChildren
	local totalWidth, totalHeight

	if isHorizontal then
		local cols = math.min(stride, numIcons)
		local rows = math.ceil(numIcons / stride)
		totalWidth = cols * buttonWidth + (cols - 1) * overlap
		totalHeight = rows * buttonHeight + (rows - 1) * overlap
	else
		local rows = math.min(stride, numIcons)
		local cols = math.ceil(numIcons / stride)
		totalWidth = cols * buttonWidth + (cols - 1) * overlap
		totalHeight = rows * buttonHeight + (rows - 1) * overlap
	end

	-- Calculate offsets to center the grid
	local startX = -totalWidth / 2
	local startY = totalHeight / 2

	if isHorizontal then
		-- Horizontal layout with wrapping
		for i, child in ipairs(visibleChildren) do
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
			local yOffset = startY - row * (buttonHeight + overlap)

			child:ClearAllPoints()
			child:SetPoint("TOP", viewer, "TOP", xOffset + buttonWidth / 2, yOffset - buttonHeight / 2);
		end
	else
		-- Vertical layout with wrapping
		for i, child in ipairs(visibleChildren) do
			local row = (i - 1) % stride
			local col = math.floor((i - 1) / stride)

			local xOffset = startX + col * (buttonWidth + overlap)
			local yOffset = startY - row * (buttonHeight + overlap)

			child:ClearAllPoints()
			child:SetPoint("CENTER", viewer, "CENTER", xOffset + buttonWidth / 2, yOffset - buttonHeight / 2)
		end
	end
end


local updaterFrame = CreateFrame("Frame")
updaterFrame:Hide()

updaterFrame:SetScript("OnUpdate", function()
	updaterFrame:Hide()

	for viewer in pairs(updateBucket) do
		updateBucket[viewer] = nil
		RemovePadding(viewer)
	end
end)

-- Schedule an update to apply the modifications during the same frame, but after Blizzard is done mucking with things
local function ScheduleUpdate(viewer)
	updateBucket[viewer] = true
	updaterFrame:Show()
end

-- Do the work
local function ApplyModifications()
	local viewers = {
		---@diagnostic disable-next-line: undefined-field
		_G.UtilityCooldownViewer,
		---@diagnostic disable-next-line: undefined-field
		_G.EssentialCooldownViewer,
		---@diagnostic disable-next-line: undefined-field
		_G.BuffIconCooldownViewer

	}

	for _, viewer in ipairs(viewers) do
		if viewer then
			RemovePadding(viewer)

			-- Hook Layout to reapply when Blizzard updates
			if viewer.Layout then
				hooksecurefunc(viewer, "Layout", function()
					ScheduleUpdate(viewer)
				end)
			end

			-- Hook Show/Hide to reapply when icons appear/disappear
			local children = { viewer:GetChildren() }
			for _, child in ipairs(children) do
				child:HookScript("OnShow", function()
					ScheduleUpdate(viewer)
				end)
				child:HookScript("OnHide", function()
					ScheduleUpdate(viewer)
				end)
			end
		end
	end
	-- BuffIconCooldownViewer loads later, hook it separately
	C_Timer.After(0.1, function()
		if _G.BuffIconCooldownViewer then
			RemovePadding(_G.BuffIconCooldownViewer)

			-- Hook Layout to reapply when icons change
			if _G.BuffIconCooldownViewer.Layout then
				hooksecurefunc(_G.BuffIconCooldownViewer, "Layout", function()
					ScheduleUpdate(_G.BuffIconCooldownViewer)
				end)
			end

			-- Hook Show/Hide on existing and future children
			local function HookChild(child)
				child:HookScript("OnShow", function()
					ScheduleUpdate(_G.BuffIconCooldownViewer)
				end)
				child:HookScript("OnHide", function()
					ScheduleUpdate(_G.BuffIconCooldownViewer)
				end)
			end

			local children = { _G.BuffIconCooldownViewer:GetChildren() }
			for _, child in ipairs(children) do
				HookChild(child)
			end

			-- Monitor for new children
			_G.BuffIconCooldownViewer:HookScript("OnUpdate", function(self)
				local currentChildren = { self:GetChildren() }
				for _, child in ipairs(currentChildren) do
					if not child.cleanCooldownHooked then
						child.cleanCooldownHooked = true
						HookChild(child)
						ScheduleUpdate(self)
					end
				end
			end)
		end

		--CooldownViewerConstants.ITEM_AURA_COLOR = CreateColor(0, 0, 0, 0.5);
	end)
end
-- Event handler
addon:SetScript("OnEvent", function(self, event, arg)
	if event == "ADDON_LOADED" and arg == "Blizzard_CooldownManager" then
		C_Timer.After(0.5, ApplyModifications)
	elseif event == "PLAYER_ENTERING_WORLD" then
		C_Timer.After(0.5, ApplyModifications)
	end
end)
