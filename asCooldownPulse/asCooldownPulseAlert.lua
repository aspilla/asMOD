local _, ns = ...;

local configs = {
    pointx = 0,
    pointy = 10,
    alerttime = 0.2,
    fadetime = 0.5,
    defaultitems = {
        [241308] = false,
        [241304] = false,
        [5512] = false,
        [224464] = false,
    },
    updaterate = 0.3,
    soundrate = 1,
    alphafrom = 0.5,
    alphato = 1,
    scalefrom = 0.8,
    scaleto = 1,
};

local blacklists = {
    [125439] = true,
}

local main_frame = CreateFrame("Frame");
local frames = {};
local frameidx = 1;
local alertspells = {
}

local alertitems = {
}

local alertspellnames = {
}

local alertitemnames = {

}

local function showfade(icon)
    frames[frameidx].icon:SetTexture(icon);

    frames[frameidx].anim:Restart();
    frameidx = frameidx + 1;

    if frameidx > 10 then
        frameidx = 1;
    end
end

local voicealert_start = {};
local function spellsound(id, isitem)
    if ns.options.AlertSound then
        local currtime = GetTime();
        if id and (voicealert_start[id] == nil or voicealert_start[id] < currtime) then
            --3초간 금지
            voicealert_start[id] = currtime + 3;
            local name = "";
            if isitem then
                name = alertitemnames[id];
            else
                name = alertspellnames[id];
            end
            if name then
                if ns.options.EnableTTS then
                    C_VoiceChat.SpeakText(ns.options.TTS_ID, name, configs.soundrate,
                        ns.options.SoundVolume);
                else
                    PlaySoundFile("Interface\\AddOns\\asCooldownPulse\\SpellSound\\" .. name .. ".mp3", "MASTER")
                end
            end
        end
    end
end

local function showalert(id, isitem)
    if isitem then
        local _, _, _, _, _, _, _, _, _, icon = C_Item.GetItemInfo(id);
        if icon then
            spellsound(id, true);
            showfade(icon);
        end
    else
        local info = C_Spell.GetSpellInfo(id);

        if info then
            spellsound(id, false);
            showfade(info.iconID);
        end
    end
end

local cached = {};
local function onupdate()
    local mincooldown = ns.options.MinCooldown - configs.updaterate - 0.1;

    if mincooldown < 0 then
        mincooldown = 0;
    end

    for spellid, start in pairs(alertspells) do
        local or_spellid = C_Spell.GetOverrideSpell(spellid)
        local id = spellid;

        if or_spellid then
            id = or_spellid;
        end
        local cd = C_Spell.GetSpellCooldown(id)
        if cd then
            if start > 0 then
                if not cd.isActive or cd.isOnGCD then
                    local duration = GetTime() - start;
                    if duration >= mincooldown or cached[id] then
                        showalert(id);
                        cached[id] = true;
                    end
                    alertspells[spellid] = 0;
                end
            else
                if cd.isActive and not cd.isOnGCD then
                    alertspells[spellid] = GetTime();
                end
            end
        end
    end

    for itemid, iscool in pairs(alertitems) do
        local start, duration, enable = C_Item.GetItemCooldown(itemid);

        if start == 0 then
            if iscool then
                showalert(itemid, true);
            end
            alertitems[itemid] = false;
        elseif duration >= mincooldown then
            alertitems[itemid] = true;
        end
    end
end

local function checktrinkets(slot)
    local itemid = GetInventoryItemID("player", slot);
    if itemid then
        local isusable = C_Item.IsUsableItem(itemid);
        if isusable then
            alertitems[itemid] = false;
        end
    end
end

local function scan_spellbook(tab)
    local lineinfo = C_SpellBook.GetSpellBookSkillLineInfo(tab);

    if not lineinfo or not lineinfo.name then
        return;
    end

    for i = lineinfo.itemIndexOffset + 1, lineinfo.itemIndexOffset + lineinfo.numSpellBookItems do
        local spellname = C_SpellBook.GetSpellBookItemName(i, Enum.SpellBookSpellBank.Player);

        if not spellname then
            do break end
        end

        local slottype, actionid, spellid = C_SpellBook.GetSpellBookItemType(i, Enum.SpellBookSpellBank.Player);
        local ispassive = C_SpellBook.IsSpellBookItemPassive(i, Enum.SpellBookSpellBank.Player)

        if not ispassive then
            if (slottype == Enum.SpellBookItemType.Flyout) then
                local _, _, slots = GetFlyoutInfo(actionid);
                for j = 1, slots do
                    local fspellid, _, _, _, _ = GetFlyoutSlotInfo(actionid, j);

                    if fspellid and not blacklists[fspellid] then
                        --alertspells[fspellid] = 0;
                    end
                end
            else
                if spellid and not blacklists[spellid] then
                    alertspells[spellid] = 0;
                    alertspellnames[spellid] = spellname;
                end
            end
        end
    end
end

local function init_spells()
    wipe(alertspells);
    wipe(alertspellnames);
    wipe(cached);

    scan_spellbook(1);
    scan_spellbook(2);
    scan_spellbook(3);
end

local function init_items()
    wipe(alertitems);
    wipe(alertitemnames);
    alertitems = CopyTable(configs.defaultitems);
    checktrinkets(13);
    checktrinkets(14);

    for itemid, _ in pairs(alertitems) do
        local name = C_Item.GetItemInfo(itemid);
        if name then
            alertitemnames[itemid] = name;
        end
    end
end

local function on_event(_, event)
    if event == "PLAYER_EQUIPMENT_CHANGED" then
        C_Timer.After(1, init_items);
    else
        C_Timer.After(1, init_spells);
    end
end

function ns.init_alert()
    local i = 1;

    while (i <= 10) do
        local frame = CreateFrame("Frame", nil, UIParent)
        if i == 1 then
            frame:SetPoint("CENTER", configs.pointx, configs.pointy);
        else
            frame:SetPoint("CENTER", frames[i - 1], "CENTER", 0, 0);
        end


        frame:SetWidth(ns.options.ReadyAlertSize);
        frame:SetHeight(ns.options.ReadyAlertSize * 0.9);
        frame:SetScale(1);
        frame:SetAlpha(0);
        frame:SetFrameStrata("LOW");
        frame:EnableMouse(false);
        frame:Show();

        frame.icon = frame:CreateTexture(nil, "BACKGROUND");
        frame.icon:SetTexture("");
        frame.icon:ClearAllPoints();
        frame.icon:SetAllPoints(frame);
        frame.icon:SetTexCoord(.08, .92, .08, .92);
        frame.icon:Show();

        frame.anim = frame:CreateAnimationGroup();
        local fadein = frame.anim:CreateAnimation("Alpha");
        fadein:SetOrder(1);
        fadein:SetFromAlpha(configs.alphafrom);
        fadein:SetToAlpha(configs.alphato);
        fadein:SetDuration(configs.fadetime);

        local fadeout = frame.anim:CreateAnimation("Alpha");
        fadeout:SetOrder(2)
        fadeout:SetFromAlpha(configs.alphato);
        fadeout:SetToAlpha(configs.alphafrom);
        fadeout:SetDuration(configs.fadetime);

        if ns.options.ShowScaleAnim then
            local zoomin = frame.anim:CreateAnimation("Scale");
            zoomin:SetOrder(1);
            zoomin:SetOrigin("CENTER", 0, 0);
            zoomin:SetScaleFrom(configs.scalefrom, configs.scalefrom);
            zoomin:SetScaleTo(configs.scaleto, configs.scaleto);
            zoomin:SetDuration(configs.fadetime);

            local zoomout = frame.anim:CreateAnimation("Scale");
            zoomout:SetOrder(2)
            zoomout:SetOrigin("CENTER", 0, 0);
            zoomout:SetScaleFrom(configs.scaleto, configs.scaleto);
            zoomout:SetScaleTo(configs.scalefrom, configs.scalefrom);
            zoomout:SetDuration(configs.fadetime);
        end
        frames[i] = frame;
        i = i + 1;
    end

    local libasConfig = LibStub:GetLibrary("LibasConfig", true);
    if libasConfig then
        libasConfig.load_position(frames[1], "asCooldownPulse(Alert)", ACDP_Positions_4);
    end

    main_frame:RegisterEvent("TRAIT_CONFIG_UPDATED");
    main_frame:RegisterEvent("TRAIT_CONFIG_LIST_UPDATED");
    main_frame:RegisterEvent("ACTIVE_TALENT_GROUP_CHANGED");
    main_frame:RegisterEvent("PLAYER_EQUIPMENT_CHANGED");
    main_frame:RegisterUnitEvent("UNIT_PET", "player");

    init_spells();
    init_items();
    main_frame:SetScript("OnEvent", on_event);

    C_Timer.NewTicker(configs.updaterate, onupdate);
end
