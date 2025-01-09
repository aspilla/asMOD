local _, ns = ...;

local function getIndex(values, val)
    local index = {};

    for k, v in pairs(values) do
        index[v] = k;
    end

    return index[val];
end

local specicons = {};

local tankIcon = CreateAtlasMarkup("roleicon-tiny-tank", 16, 16, 0, 0);
local dpsIcon = CreateAtlasMarkup("roleicon-tiny-dps", 16, 16, 0, 0);
local healerIcon = CreateAtlasMarkup("roleicon-tiny-healer", 16, 16, 0, 0);

local function SearchEntryUpdate(entry, ...)
    if (not LFGListFrame.SearchPanel:IsShown()) then
        return;
    end

    local categoryID = LFGListFrame.SearchPanel.categoryID;
    local resultID = entry.resultID;
    local resultInfo = C_LFGList.GetSearchResultInfo(resultID);
    local leaderIcon = CreateAtlasMarkup("groupfinder-icon-leader", 14, 9, 0, 0);

    if not entry.DataDisplay.Enumerate then
        return;
    end

    for i = 1, 5 do
        local texture = "astexture" .. i;
        if (entry.DataDisplay.Enumerate[texture]) then
            entry.DataDisplay.Enumerate[texture]:Hide();
        end

        texture = "asicontexture" .. i;
        if (entry.DataDisplay.Enumerate[texture]) then
            entry.DataDisplay.Enumerate[texture]:Hide();
        end

        texture = "asleadertexture" .. i;
        if (entry.DataDisplay.Enumerate[texture]) then
            entry.DataDisplay.Enumerate[texture]:Hide();
        end
    end

    local texture = "asscore";
    if (entry.DataDisplay.Enumerate[texture]) then
        entry.DataDisplay.Enumerate[texture]:Hide();
    end

    if (categoryID == 2) then
        local numMembers = resultInfo.numMembers;
        local overallColor = C_ChallengeMode.GetDungeonScoreRarityColor(resultInfo.leaderOverallDungeonScore or 0) or
            HIGHLIGHT_FONT_COLOR;
        local orderIndexes = {};

        for i = 1, numMembers do
            local role, class, classLocalized, specLocalized, isLeader = C_LFGList.GetSearchResultMemberInfo(resultID, i);
            local orderIndex = getIndex(LFG_LIST_GROUP_DATA_ROLE_ORDER, role);
            table.insert(orderIndexes, { orderIndex, class, specLocalized, role, isLeader });
        end

        table.sort(orderIndexes, function(a, b)
            return a[1] < b[1]
        end);

        local texture = "asscore";
        entry.DataDisplay.Enumerate[texture] = entry.DataDisplay.Enumerate:CreateFontString(nil, "ARTWORK");
        entry.DataDisplay.Enumerate[texture]:SetFont(STANDARD_TEXT_FONT, 10);
        entry.DataDisplay.Enumerate[texture]:SetPoint("RIGHT", entry.DataDisplay.Enumerate["Icon5"], "LEFT", -1, 0);

        if overallColor and resultInfo.leaderOverallDungeonScore and ns.options.ShowLeaderScore then
            entry.DataDisplay.Enumerate[texture]:SetText(overallColor:WrapTextInColorCode(resultInfo
                .leaderOverallDungeonScore));
            entry.DataDisplay.Enumerate[texture]:Show();
        else
            entry.DataDisplay.Enumerate[texture]:Hide();
        end

        for i = 1, numMembers do
            local order = 6 - i;
            local class = orderIndexes[i][2];
            local spec = orderIndexes[i][3];
            local role = orderIndexes[i][4];
            local isLeader = orderIndexes[i][5];

            if class and spec and role then
                local classColor = RAID_CLASS_COLORS[class];
                local r, g, b, a = classColor:GetRGBA();

                local texture = "astexture" .. i;

                if (not entry.DataDisplay.Enumerate[texture]) then
                    entry.DataDisplay.Enumerate[texture] = entry.DataDisplay.Enumerate["Icon" .. order]:CreateTexture(
                        nil,
                        "ARTWORK");
                    entry.DataDisplay.Enumerate[texture]:SetSize(16, 4);
                    entry.DataDisplay.Enumerate[texture]:SetPoint("RIGHT", entry.DataDisplay.Enumerate["Icon" .. order],
                        "RIGHT", -1, -9);
                end

                if (role == "TANK" and ns.options.ShowTankerSpec) or (role == "HEALER" and ns.options.ShowHealerSpec) or role == "DAMAGER" then
                    entry.DataDisplay.Enumerate[texture]:SetColorTexture(r, g, b, 0.75);
                    entry.DataDisplay.Enumerate[texture]:Show();
                end

                texture = "asleadertexture" .. i;

                if (not entry.DataDisplay.Enumerate[texture]) then
                    entry.DataDisplay.Enumerate[texture] = entry.DataDisplay.Enumerate["Icon" .. order]:CreateFontString(
                        nil,
                        "ARTWORK");
                    entry.DataDisplay.Enumerate[texture]:SetFont(STANDARD_TEXT_FONT, 10);
                    entry.DataDisplay.Enumerate[texture]:SetPoint("CENTER", entry.DataDisplay.Enumerate["Icon" .. order],
                        "CENTER", 0, 11);
                end

                if isLeader then
                    entry.DataDisplay.Enumerate[texture]:SetText(leaderIcon);
                    entry.DataDisplay.Enumerate[texture]:Show();
                end

                texture = "asicontexture" .. i;

                if (not entry.DataDisplay.Enumerate[texture]) then
                    entry.DataDisplay.Enumerate[texture] = entry.DataDisplay.Enumerate["Icon" .. order]:CreateTexture(
                        nil,
                        "ARTWORK");
                    entry.DataDisplay.Enumerate[texture]:SetSize(16, 17);
                    entry.DataDisplay.Enumerate[texture]:SetPoint("BOTTOMRIGHT", entry.DataDisplay.Enumerate
                        ["Icon" .. order],
                        "RIGHT",
                        -1, -7);
                    entry.DataDisplay.Enumerate[texture]:SetTexCoord(.08, .92, .08, .92);
                    entry.DataDisplay.Enumerate[texture]:SetDrawLayer("ARTWORK", 7);
                end

                if (role == "TANK" and ns.options.ShowTankerSpec) or (role == "HEALER" and ns.options.ShowHealerSpec) or role == "DAMAGER" then
                    if specicons[class .. spec] then
                        entry.DataDisplay.Enumerate[texture]:SetTexture(specicons[class .. spec]);
                        entry.DataDisplay.Enumerate[texture]:Show();
                    end
                end
            end
        end
    elseif (categoryID == 3) then
        local numMembers = resultInfo.numMembers;
        local classes = {};

        for i = 1, numMembers do
            local role, class, classLocalized, specLocalized, isLeader = C_LFGList.GetSearchResultMemberInfo(resultID, i);
            if classes[role] == nil then
                classes[role] = {};
            end
            if classes[role][class] == nil then
                classes[role][class] = 1;
            else
                classes[role][class] = classes[role][class] + 1;
            end
        end

        if not entry.DataDisplay.RoleCount.healerclasses then
            entry.DataDisplay.RoleCount.healerclasses = entry.DataDisplay.RoleCount:CreateFontString(nil, "ARTWORK");
            entry.DataDisplay.RoleCount.healerclasses:SetFont(STANDARD_TEXT_FONT, 12);
            entry.DataDisplay.RoleCount.healerclasses:SetPoint("BOTTOMRIGHT", entry.DataDisplay.RoleCount.HealerIcon,
                "BOTTOMRIGHT", 40, -10);  

            entry.DataDisplay.RoleCount.dpsclasses = entry.DataDisplay.RoleCount:CreateFontString(nil, "ARTWORK");
            entry.DataDisplay.RoleCount.dpsclasses:SetFont(STANDARD_TEXT_FONT, 12);
            entry.DataDisplay.RoleCount.dpsclasses:SetPoint("RIGHT", entry.DataDisplay.RoleCount.healerclasses,
                "LEFT", -5, 0);    
                
            entry.DataDisplay.RoleCount.tankclasses = entry.DataDisplay.RoleCount:CreateFontString(nil, "ARTWORK");
            entry.DataDisplay.RoleCount.tankclasses:SetFont(STANDARD_TEXT_FONT, 12);
            entry.DataDisplay.RoleCount.tankclasses:SetPoint("RIGHT", entry.DataDisplay.RoleCount.dpsclasses,
            "LEFT", -5, 0);     
        end

        local function getClassCountText(class, count)
            local classColor = RAID_CLASS_COLORS[class];
            local r, g, b, a = classColor:GetRGBA();
            return string.format("|cff%02x%02x%02x%d|r", r * 255, g * 255, b * 255, count);
        end

        local healerclasses = classes["HEALER"];

        if healerclasses then
            local text = healerIcon;
            for class, count in pairs(healerclasses) do
                text = text .. getClassCountText(class, count);
            end
            entry.DataDisplay.RoleCount.healerclasses:SetText(text);
            entry.DataDisplay.RoleCount.healerclasses:Show();
        end

        local dpsclasses = classes["DAMAGER"];

        if dpsclasses then        

            local text = dpsIcon;
            for class, count in pairs(dpsclasses) do
                text = text .. getClassCountText(class, count);
            end
            entry.DataDisplay.RoleCount.dpsclasses:SetText(text);
            entry.DataDisplay.RoleCount.dpsclasses:Show();
        end

        local tankclasses = classes["TANK"];
        if tankclasses then                    
            local text = tankIcon;
            for class, count in pairs(tankclasses) do
                text = text .. getClassCountText(class, count);
            end
            entry.DataDisplay.RoleCount.tankclasses:SetText(text);
            entry.DataDisplay.RoleCount.tankclasses:Show();
        end
    end
end

local function initSpec()
    for i = 1, 2000 do
        local id, name, description, icon, _, class = GetSpecializationInfoByID(i)
        if name and class and icon then
            specicons[class .. name] = icon;
        end
    end
end

ns.SetupOptionPanels();
hooksecurefunc("LFGListSearchEntry_Update", SearchEntryUpdate);
initSpec();

--지원서 유지 기능 오류가 많아서 일단 끈다
--[[
function asLFGListApplicationDialog_Show(self, resultID)
	local searchResultInfo = C_LFGList.GetSearchResultInfo(resultID);
	self.resultID = resultID;
	self.activityID = searchResultInfo.activityID;
	LFGListApplicationDialog_UpdateRoles(self);
	StaticPopupSpecial_Show(self);
end


if ns.options.KeepingApplicationText then
    LFGListApplicationDialog_Show = asLFGListApplicationDialog_Show;
end
]]
