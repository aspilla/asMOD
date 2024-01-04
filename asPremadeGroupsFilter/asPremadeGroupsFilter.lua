local function getIndex(values, val)
    local index = {};

    for k, v in pairs(values) do
        index[v] = k;
    end

    return index[val];
end

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
        local texture = "astexture"..i;                
        if (entry.DataDisplay.Enumerate[texture]) then
            entry.DataDisplay.Enumerate[texture]:Hide();
        end                
    end

    if (categoryID == 2) then
        
        local numMembers = resultInfo.numMembers;
        local orderIndexes = {};

        for i = 1, numMembers do
            local role, class = C_LFGList.GetSearchResultMemberInfo(resultID, i);
            local orderIndex = getIndex(LFG_LIST_GROUP_DATA_ROLE_ORDER, role);
            table.insert(orderIndexes, {orderIndex, class});
        end

        table.sort(orderIndexes, function(a, b)
            return a[1] < b[1]
        end);

        local xOffset = -86;

        for i = 1, numMembers do
            local class = orderIndexes[i][2];
            local classColor = RAID_CLASS_COLORS[class];
            local r, g, b, a = classColor:GetRGBA();

            local texture = "astexture"..i;
            
            if (not entry.DataDisplay.Enumerate[texture]) then
                entry.DataDisplay.Enumerate[texture] = entry.DataDisplay.Enumerate:CreateTexture(nil, "ARTWORK");
                entry.DataDisplay.Enumerate[texture]:SetSize(16, 4);
                entry.DataDisplay.Enumerate[texture]:SetPoint("RIGHT", entry.DataDisplay.Enumerate, "RIGHT", xOffset, -10);
            end
            
            entry.DataDisplay.Enumerate[texture]:Show();                    
            entry.DataDisplay.Enumerate[texture]:SetColorTexture(r, g, b, 0.75);

            xOffset = xOffset + 18;
        end
   end
end

hooksecurefunc("LFGListSearchEntry_Update", SearchEntryUpdate);