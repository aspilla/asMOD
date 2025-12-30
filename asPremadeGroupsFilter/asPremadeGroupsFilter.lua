local _, ns = ...;

local function get_index(values, val)
    local index = {};

    for k, v in pairs(values) do
        index[v] = k;
    end

    return index[val];
end

local specicons = {};
local roleicons = {};

roleicons["TANK"] = CreateAtlasMarkup("roleicon-tiny-tank", 16, 16, 0, 0);
roleicons["DAMAGER"] = CreateAtlasMarkup("roleicon-tiny-dps", 16, 16, 0, 0);
roleicons["HEALER"] = CreateAtlasMarkup("roleicon-tiny-healer", 16, 16, 0, 0);

local function update_searchentry(entry, ...)
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
            local orderIndex = get_index(LFG_LIST_GROUP_DATA_ROLE_ORDER, role);
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
            entry.DataDisplay.Enumerate[texture]:SetText(overallColor:WrapTextInColorCode(tostring(resultInfo
                .leaderOverallDungeonScore)));
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
                    entry.DataDisplay.Enumerate[texture]:SetDrawLayer("ARTWORK", 6);
                end

                if (role == "TANK" and ns.options.ShowTankerSpec) or (role == "HEALER" and ns.options.ShowHealerSpec) or role == "DAMAGER" then
                    if specicons[class .. spec] then
                        entry.DataDisplay.Enumerate[texture]:SetTexture(specicons[class .. spec]);
                        entry.DataDisplay.Enumerate[texture]:Show();
                        if entry.DataDisplay.Enumerate["Icon" .. order].LeaverIcon then
                            entry.DataDisplay.Enumerate["Icon" .. order].LeaverIcon:SetDrawLayer("ARTWORK", 7);
                        end
                    end
                end
            end
        end
    elseif (categoryID == 3) then
        local numMembers = resultInfo.numMembers;
        local classes = {};
        local leader_role;
        local leader_class;

        for i = 1, numMembers do
            local role, class, classLocalized, specLocalized, isLeader = C_LFGList.GetSearchResultMemberInfo(resultID, i);

            if role and class then
                if classes[role] == nil then
                    classes[role] = {};
                end
                if classes[role][class] == nil then
                    classes[role][class] = 1;
                else
                    classes[role][class] = classes[role][class] + 1;
                end
                if isLeader then
                    leader_role = role;
                    leader_class = class;
                end
            end
        end

        if not entry.DataDisplay.RoleCount.infos then
            entry.DataDisplay.RoleCount.infos = {};
            entry.DataDisplay.RoleCount.infos.DAMAGER = entry.DataDisplay.RoleCount:CreateFontString(nil, "ARTWORK");
            entry.DataDisplay.RoleCount.infos.DAMAGER:SetFont(STANDARD_TEXT_FONT, 12);
            entry.DataDisplay.RoleCount.infos.DAMAGER:SetPoint("RIGHT", entry.DataDisplay.RoleCount.HealerIcon,
                "BOTTOMRIGHT", 40, -10);

            entry.DataDisplay.RoleCount.infos.HEALER = entry.DataDisplay.RoleCount:CreateFontString(nil, "ARTWORK");
            entry.DataDisplay.RoleCount.infos.HEALER:SetFont(STANDARD_TEXT_FONT, 12);
            entry.DataDisplay.RoleCount.infos.HEALER:SetPoint("RIGHT", entry.DataDisplay.RoleCount.infos.DAMAGER,
                "LEFT", -5, 0);

            entry.DataDisplay.RoleCount.infos.TANK = entry.DataDisplay.RoleCount:CreateFontString(nil, "ARTWORK");
            entry.DataDisplay.RoleCount.infos.TANK:SetFont(STANDARD_TEXT_FONT, 12);
            entry.DataDisplay.RoleCount.infos.TANK:SetPoint("RIGHT", entry.DataDisplay.RoleCount.infos.HEALER,
                "LEFT", -5, 0);

            entry.DataDisplay.RoleCount.infos.LEADER = entry.DataDisplay.RoleCount:CreateFontString(nil, "ARTWORK");
            entry.DataDisplay.RoleCount.infos.LEADER:SetFont(STANDARD_TEXT_FONT, 12);
            entry.DataDisplay.RoleCount.infos.LEADER:SetPoint("RIGHT", entry.DataDisplay.RoleCount.infos.TANK,
                "LEFT", -5, 0);
        end

        local function getClassCountText(class, count)
            local classColor = RAID_CLASS_COLORS[class];
            local r, g, b, a = classColor:GetRGBA();
            return string.format("|cff%02x%02x%02x%s|r", r * 255, g * 255, b * 255, count);
        end

        local function setupText(role, infos, fontstring)
            local text = ""
            if role and infos then
                text = roleicons[role];
                for class, count in pairs(infos) do
                    text = text .. getClassCountText(class, count);
                end
            end

            fontstring:SetText(text);
            fontstring:Show();
        end

        for role, _ in pairs(roleicons) do
            local infos = classes[role];
            setupText(role, infos, entry.DataDisplay.RoleCount.infos[role]);
        end

        local text = "";

        if leader_class and leader_role then
            text = leaderIcon .. getClassCountText(leader_class, string.sub(leader_role, 1, 1))
        end
        entry.DataDisplay.RoleCount.infos.LEADER:SetText(text);
        entry.DataDisplay.RoleCount.infos.LEADER:Show();
    end
end

local function inin_specs()
    for i = 1, 2000 do
        local id, name, description, icon, _, class = GetSpecializationInfoByID(i)
        if name and class and icon then
            specicons[class .. name] = icon;
        end
    end
end

ns.setup_option();
hooksecurefunc("LFGListSearchEntry_Update", update_searchentry);
inin_specs();