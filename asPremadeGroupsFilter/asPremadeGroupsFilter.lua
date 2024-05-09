local function getIndex(values, val)
    local index = {};

    for k, v in pairs(values) do
        index[v] = k;
    end

    return index[val];
end

local specicons = {};

local function SearchEntryUpdate(entry, ...)
    if (not LFGListFrame.SearchPanel:IsShown()) then
        return;
    end

    local categoryID = LFGListFrame.SearchPanel.categoryID;
    local resultID = entry.resultID;
    local resultInfo = C_LFGList.GetSearchResultInfo(resultID);

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
    end

    if (categoryID == 2) then
        local numMembers = resultInfo.numMembers;
        local orderIndexes = {};

        for i = 1, numMembers do
            local role, class, classLocalized, specLocalized = C_LFGList.GetSearchResultMemberInfo(resultID, i);            
            local orderIndex = getIndex(LFG_LIST_GROUP_DATA_ROLE_ORDER, role);
            table.insert(orderIndexes, { orderIndex, class, specLocalized, role });
        end

        table.sort(orderIndexes, function(a, b)
            return a[1] < b[1]
        end);

        local xOffset = -86;

        for i = 1, numMembers do
            local order = 6 - i;
            local class = orderIndexes[i][2];
            local spec = orderIndexes[i][3]
            local role = orderIndexes[i][4]
            local classColor = RAID_CLASS_COLORS[class];
            local r, g, b, a = classColor:GetRGBA();

            local texture = "astexture" .. i;

            if (not entry.DataDisplay.Enumerate[texture]) then
                entry.DataDisplay.Enumerate[texture] = entry.DataDisplay.Enumerate["Icon"..order]:CreateTexture(nil, "ARTWORK");
                entry.DataDisplay.Enumerate[texture]:SetSize(16, 4);
                entry.DataDisplay.Enumerate[texture]:SetPoint("RIGHT", entry.DataDisplay.Enumerate["Icon"..order], "RIGHT", -1, -10);
            end

            entry.DataDisplay.Enumerate[texture]:SetColorTexture(r, g, b, 0.75);
            entry.DataDisplay.Enumerate[texture]:Show();


            texture = "asicontexture" .. i;

            if (not entry.DataDisplay.Enumerate[texture]) then
                entry.DataDisplay.Enumerate[texture] = entry.DataDisplay.Enumerate["Icon"..order]:CreateTexture(nil, "ARTWORK");
                entry.DataDisplay.Enumerate[texture]:SetSize(16, 17);
                entry.DataDisplay.Enumerate[texture]:SetPoint("BOTTOMRIGHT", entry.DataDisplay.Enumerate["Icon"..order], "RIGHT",
                    -1, -7);
                entry.DataDisplay.Enumerate[texture]:SetTexCoord(.08, .92, .08, .92);
                entry.DataDisplay.Enumerate[texture]:SetDrawLayer("ARTWORK", 7);
            end

            if specicons[class..spec] and role ~= "TANK" and role ~= "HEALER" then                
                entry.DataDisplay.Enumerate[texture]:SetTexture(specicons[class..spec]);
                entry.DataDisplay.Enumerate[texture]:Show();
            end


            xOffset = xOffset + 18;
        end
    end
end

local function initSpec()
    for i = 1, 2000 do
        local id, name, description, icon, _ , class = GetSpecializationInfoByID(i)
        if name and class and icon then
            specicons[class..name] = icon;
        end
    end
end

hooksecurefunc("LFGListSearchEntry_Update", SearchEntryUpdate);
initSpec();
