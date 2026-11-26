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
};

ns.all_spells = {};
ns.all_items = {};

function ns.get_current_spec_id()
    local specIndex = C_SpecializationInfo.GetSpecialization();
    if specIndex and specIndex > 0 then
        local specID = C_SpecializationInfo.GetSpecializationInfo(specIndex);
        if specID and specID > 0 then
            return specID;
        end
    end
    return 0;
end

function ns.get_current_spec_name()
    local specIndex = C_SpecializationInfo.GetSpecialization();
    if specIndex and specIndex > 0 then
        local _, name = C_SpecializationInfo.GetSpecializationInfo(specIndex);
        if name and name ~= "" then
            return name;
        end
    end
    return SPECIALIZATION or "Specialization";
end

function ns.is_blacklisted(id)
    if not id then
        return false;
    end
    if blacklists[id] then
        return true;
    end
    local specID = ns.get_current_spec_id();
    if ACDP_Options and ACDP_Options.Blacklists and ACDP_Options.Blacklists[specID] then
        if ACDP_Options.Blacklists[specID][id] then
            return true;
        end
    end
    return false;
end

local main_frame = CreateFrame("Frame");
local frames = {};
local frameidx = 1;
local alertspells = {};
local alertitems = {};
local alertspellnames = {};
local alertitemnames = {};

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
    local use_blacklist = ns.options.UseBlacklist;
    local mincooldown = ns.options.MinCooldown - configs.updaterate - 0.1;

    if mincooldown < 0 then
        mincooldown = 0;
    end

    if use_blacklist then
        mincooldown = 1.6;
    end

    for spellid, start in pairs(alertspells) do
        local or_spellid = C_Spell.GetOverrideSpell(spellid);
        local id = spellid;

        if or_spellid then
            id = or_spellid;
        end
        local cd = C_Spell.GetSpellCooldown(id);
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
        elseif use_blacklist or duration >= mincooldown then
            if duration > 0 then
                alertitems[itemid] = true;
            end
        end
    end
end

local function register_item(itemid)
    local name, _, _, _, _, _, _, _, _, icon = C_Item.GetItemInfo(itemid);

    ns.all_items[itemid] = { id = itemid, name = name or ("Item " .. itemid), icon = icon };
    if not name then
        local item = Item:CreateFromItemID(itemid);
        item:ContinueOnItemLoad(function()
            local loadedName, _, _, _, _, _, _, _, _, loadedIcon = C_Item.GetItemInfo(itemid);
            if ns.all_items[itemid] then
                ns.all_items[itemid].name = loadedName or ("Item " .. itemid);
                ns.all_items[itemid].icon = loadedIcon or C_Item.GetItemIconByID(itemid);
                if alertitems[itemid] ~= nil and loadedName then
                    alertitemnames[itemid] = loadedName;
                end
                if ns.refresh_blacklist_ui then
                    ns.refresh_blacklist_ui();
                end
            end
        end);
    end

    local is_blocked = ns.options.UseBlacklist and ns.is_blacklisted(itemid);
    if not is_blocked then
        alertitems[itemid] = false;
        if name then
            alertitemnames[itemid] = name;
        end
    end
end

local function checktrinkets(slot)
    local itemid = GetInventoryItemID("player", slot);
    if itemid then
        local isusable = C_Item.IsUsableItem(itemid);
        if isusable then
            register_item(itemid);
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
            break;
        end

        local slottype, actionid, spellid = C_SpellBook.GetSpellBookItemType(i, Enum.SpellBookSpellBank.Player);
        local ispassive = C_SpellBook.IsSpellBookItemPassive(i, Enum.SpellBookSpellBank.Player);

        if not ispassive and spellid then
            if (slottype ~= Enum.SpellBookItemType.Flyout) then
                if not blacklists[spellid] then
                    local info = C_Spell.GetSpellInfo(spellid);
                    local icon = info and info.iconID;
                    ns.all_spells[spellid] = { id = spellid, name = spellname, icon = icon };

                    local is_blocked = ns.options.UseBlacklist and ns.is_blacklisted(spellid);
                    if not is_blocked then
                        alertspells[spellid] = 0;
                        alertspellnames[spellid] = spellname;
                    end
                end
            end
        end
    end
end

local function init_spells()
    wipe(alertspells);
    wipe(alertspellnames);
    wipe(cached);
    wipe(ns.all_spells);

    scan_spellbook(1);
    scan_spellbook(2);
    scan_spellbook(3);
end

local function init_items()
    wipe(alertitems);
    wipe(alertitemnames);
    wipe(ns.all_items);

    for itemid, _ in pairs(configs.defaultitems) do
        register_item(itemid);
    end

    checktrinkets(13);
    checktrinkets(14);
end

function ns.refresh_alerts()
    init_spells();
    init_items();
end

local function on_event(_, event)
    C_Timer.After(1, function()
        ns.refresh_alerts();
        ns.refresh_blacklist_ui();
    end);
end

local function init()
    ns.setup_option();
    local i = 1;

    while (i <= 10) do
        local frame = CreateFrame("Frame", nil, UIParent);
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
        local fadein = frame.anim:CreateAnimation("Alpha"); ---@class any
        fadein:SetOrder(1);
        fadein:SetFromAlpha(configs.alphafrom);
        fadein:SetToAlpha(configs.alphato);
        fadein:SetDuration(configs.fadetime);

        local fadeout = frame.anim:CreateAnimation("Alpha"); ---@class any
        fadeout:SetOrder(2);
        fadeout:SetFromAlpha(configs.alphato);
        fadeout:SetToAlpha(configs.alphafrom);
        fadeout:SetDuration(configs.fadetime);

        if ns.options.ShowScaleAnim then
            local zoomin = frame.anim:CreateAnimation("Scale"); ---@class any
            zoomin:SetOrder(1);
            zoomin:SetOrigin("CENTER", 0, 0);
            zoomin:SetScaleFrom(configs.scalefrom, configs.scalefrom);
            zoomin:SetScaleTo(configs.scaleto, configs.scaleto);
            zoomin:SetDuration(configs.fadetime);

            local zoomout = frame.anim:CreateAnimation("Scale"); ---@class any
            zoomout:SetOrder(2);
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
        libasConfig.load_position(frames[1], "asCooldownPulse(Alert)", ACDP_Positions);
    end

    main_frame:RegisterEvent("TRAIT_CONFIG_UPDATED");
    main_frame:RegisterEvent("TRAIT_CONFIG_LIST_UPDATED");
    main_frame:RegisterEvent("ACTIVE_TALENT_GROUP_CHANGED");
    main_frame:RegisterEvent("PLAYER_SPECIALIZATION_CHANGED");
    main_frame:RegisterEvent("PLAYER_EQUIPMENT_CHANGED");
    main_frame:RegisterUnitEvent("UNIT_PET", "player");

    ns.refresh_alerts();
    main_frame:SetScript("OnEvent", on_event);

    C_Timer.NewTicker(configs.updaterate, onupdate);
end

C_Timer.After(0.5, init);
