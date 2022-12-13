-----------------설정 ------------------------
local ATGCD_X = 22;
local ATGCD_Y = -90;
local AGCICON = 20;


local AGCD_BlackList = {
	["자동 사격"] = 1,
	["자동 공격"] = 1,
	[240022] = 1,
}


local KnownSpellList = {};

local itemslots = {

	"HeadSlot",
	"NeckSlot",
	"ShoulderSlot",
	"BackSlot",
	"ChestSlot",
	"WristSlot",
	"MainHandSlot",
	"SecondaryHandSlot",
	"HandsSlot",
	"WaistSlot",
	"LegsSlot",
	"FeetSlot",
	"Finger0Slot",
	"Finger1Slot",
	"Trinket0Slot",
	"Trinket1Slot",
}


local function scanSpells(tab)

	local tabName, tabTexture, tabOffset, numEntries = GetSpellTabInfo(tab)

	if not tabName then
		return;
	end

	for i=tabOffset + 1, tabOffset + numEntries do
		local spellName, _, spellID = GetSpellBookItemName (i, BOOKTYPE_SPELL)

		if not spellID then
			do break end
		end

		KnownSpellList[spellID] = 1;
	end
end


local function scanPetSpells()

	for i = 1, 20 do
	   local slot = i + (SPELLS_PER_PAGE * (SPELLBOOK_PAGENUMBERS[BOOKTYPE_PET] - 1));
	   local spellName, _, spellID = GetSpellBookItemName (slot, BOOKTYPE_PET)
	   
		if not spellID then
			do break end
		end

		KnownSpellList[spellID] = 1;
	end

end

local function scanActionSlots()

		local lActionSlot = 0;

	for lActionSlot = 1, 240 do
		local type, id, subType, spellID = GetActionInfo(lActionSlot);
		local itemid = nil;

		
		if type and type == "macro" then

			 id = GetMacroSpell(id);
		end

		if type and type == "item" then
			itemid = id;
			 _, id = GetItemSpell(id);
		end



		if id then

				
			if itemid then
				KnownSpellList[id] = itemid; 
			else
				KnownSpellList[id] = 1;
			end
		end


	end


	for i=1, NUM_PET_ACTION_SLOTS, 1 do
		local name, texture, isToken, isActive, autoCastAllowed, autoCastEnabled, spellID = GetPetActionInfo(i);
		
		if spellID then
			KnownSpellList[spellID] = 1;
		end
	end

end

local function scanItemSlots()

	for i =1,#itemslots do 

		local  idx = GetInventorySlotInfo(itemslots[i]);

		local itemid = GetInventoryItemID("player",idx) 

		if itemid then 

			  _, id = GetItemSpell(itemid);



			if id then
				KnownSpellList[id] = itemid; 
			end
		end

	end

end

local function setupKnownSpell()

	table.wipe(KnownSpellList);

	scanSpells(1)
	scanSpells(2)
	scanPetSpells()

	scanActionSlots();
	scanItemSlots();
end





local ATGCD = CreateFrame("FRAME", nil, UIParent)
ATGCD:SetPoint("BOTTOM",UIParent,"BOTTOM", 0, 0)
ATGCD:SetWidth(0)
ATGCD:SetHeight(0)
ATGCD:Show();


ATGCD.icon = {};
ATGCD.icontime = {};
for i = 1 , 3 do
	ATGCD.icon[i] = CreateFrame("Button", "ATGCDIcon" .. i, UIParent, "ATGCDFrameTemplate");

	if i == 1 then
		ATGCD.icon[i]:SetPoint("CENTER",UIParent,"CENTER", ATGCD_X, ATGCD_Y)
	else
		ATGCD.icon[i]:SetPoint("RIGHT", ATGCD.icon[i-1],"LEFT", -2, 0);
	end


	ATGCD.icon[i]:SetWidth(AGCICON);
	ATGCD.icon[i]:SetHeight(AGCICON * 0.9);
	ATGCD.icon[i]:SetScale(1);
	ATGCD.icon[i]:SetAlpha(1);
	ATGCD.icon[i]:EnableMouse(false);

	local frameIcon = _G["ATGCDIcon" .. i.."Icon"];
	frameIcon:SetTexCoord(.08, .92, .08, .92);

	local frameBorder = _G["ATGCDIcon" .. i.."Border"];
	frameBorder:SetTexture("Interface\\Addons\\asTrueGCD\\border.tga");
	frameBorder:SetTexCoord(0.08,0.08, 0.08,0.92, 0.92,0.08, 0.92,0.92);
	frameBorder:SetVertexColor(0, 0, 0);
	frameBorder:Show();
	ATGCD.icon[i]:Hide();
	



   

end

 LoadAddOn("asMOD");
if asMOD_setupFrame then
        asMOD_setupFrame (	ATGCD.icon[1], "asTrueGCD");
    end


local prev_spell = nil;
local prev_spell_time = nil;
local prev_spell_id = nil;
local seq_spell_count = 0;


local function ATGCD_Alert(spellid, bcancel, bitem)

	if spellid == nil then
		--ATGCD.icon:Hide();
		return
	end	

	local spell_count = 0;

	
	if AGCD_BlackList[spellid] then
		return;
	end

	if spellid == prev_spell_id and not bcancel then
		seq_spell_count = seq_spell_count + 1;
	elseif not bcancel then
		prev_spell_id = spellid;
		seq_spell_count = 0;
	end

	local name,discard,icon = GetSpellInfo(spellid)

	if bitem then
		local 	itemName, itemLink, itemRarity, itemLevel, itemMinLevel, itemType, itemSubType, itemStackCount,
itemEquipLoc, iconFileDataID, itemSellPrice, itemClassID, itemSubClassID, bindType, expacID, itemSetID, 
isCraftingReagent = GetItemInfo(spellid)
		name = itemName
		icon = iconFileDataID
	end

	
	if icon == nil then
		--ATGCD.icon:Hide();
		return;
	elseif icon == 136243 then
		return;
	end

	if AGCD_BlackList[name] then
		return;
	end


	local current = GetTime();

	for i = 1, 3 do
		local frame = ATGCD.icon[4 - i];
		local frameIcon = _G["ATGCDIcon"..(4 - i).."Icon"];
		local frameborder = _G["ATGCDIcon"..(4 - i).."Border"];
		local frameCancel = _G["ATGCDIcon"..(4 - i).."Cancel"];
		
		if i == 3 then
			-- set the icon
			frameIcon:SetTexture(icon);
			frame:Show();
			--frameborder:Hide();
			ATGCD.icontime[4 - i] = GetTime();	
			
			if bcancel then
				frameCancel:SetText("X");
				frameCancel:SetTextColor(1, 0 ,0 );
				frameCancel:Show();
			elseif seq_spell_count > 0 then
				frameCancel:SetText(seq_spell_count + 1);
				frameCancel:SetTextColor(1, 1 ,1 );
				frameCancel:Show();
			else
				frameCancel:SetText("");
				frameCancel:Hide();
			end

			
		else
			local frameIcon2 = _G["ATGCDIcon"..(4 - i - 1).."Icon"];
			local icon2 = frameIcon2:GetTexture()
			local time2 = ATGCD.icontime[4 - i - 1];
			local frameCancel2 = _G["ATGCDIcon"..(4 - i - 1).."Cancel"];
		
			if icon2  then
				if time2 and current - time2 > 5 then
					ATGCD.icontime[4 - i] = nil;
					frameCancel:Hide();
					frame:Hide();
				elseif time2 then

					frameIcon:SetTexture(icon2);
					local prev_text = frameCancel2:GetText();
					--frameborder:Hide();
					if frameCancel2:IsShown() and prev_text == "X" then
						frameCancel:SetText("X");
						frameCancel:SetTextColor(1, 0 ,0 );
						frameCancel:Show();
					elseif frameCancel2:IsShown() then
						frameCancel:SetText(prev_text);
						frameCancel:SetTextColor(1, 1 ,1 );
						frameCancel:Show();
					else
						frameCancel:Hide();
					end
					frame:Show();
					ATGCD.icontime[4 - i]  = time2;
				else
					ATGCD.icontime[4 - i] = nil;
					frameCancel:Hide();
					frame:Hide();
				end
			else
				ATGCD.icontime[4 - i] = nil;
				frameCancel:Hide();
				frame:Hide();
			end

		end
	end
	return;
end


local function ATGCD_OnUpdate()

	
	local current = GetTime();
	for	i = 1, 3 do
		
		if ATGCD.icontime[i]  and  current - ATGCD.icontime[i] > 5 then
			ATGCD.icon[i]:Hide();
			local frameCancel = _G["ATGCDIcon"..i.."Cancel"];
			frameCancel:Hide();
		end

	end
end
local interruptprev = nil;
local interrupttime = nil;


local prev = nil;
local prevtime = nil;

local function ATGCD_OnEvent(self, event, arg1, arg2, arg3, arg4, arg5)

	if event == "UNIT_SPELLCAST_SUCCEEDED" and arg1 == "player" then

		prev_spell = arg3;

		local GCDmax = 1.5 / (( GetHaste() / 100 ) + 1)


		if prev and prev == prev_spell and (GetTime() - prevtime) < (GCDmax - 0.1)  then
			
		else

			if KnownSpellList[prev_spell] == 1 then
				prev = prev_spell;
				prevtime = GetTime();
				ATGCD_Alert(prev_spell, nil);
			elseif KnownSpellList[prev_spell] then
				prev = prev_spell;
				prevtime = GetTime();
				ATGCD_Alert(KnownSpellList[prev_spell], nil, true);
			end
		end

	elseif event == "UNIT_SPELLCAST_INTERRUPTED" and   arg1 == "player" then
		prev_spell = arg3;

		local GCDmax = 1.5 / (( GetHaste() / 100 ) + 1)

		if interruptprev and interruptprev == prev_spell and (GetTime() - interrupttime) < (GCDmax - 0.1 ) then

		else

			if KnownSpellList[prev_spell] == 1 then
				interruptprev = prev_spell;
				interrupttime = GetTime();
				ATGCD_Alert(prev_spell, true);
			elseif KnownSpellList[prev_spell] then
				interruptprev = prev_spell;
				interrupttime = GetTime();
				ATGCD_Alert(KnownSpellList[prev_spell], true, true);
			end
		end
	elseif event == "SPELLS_CHANGED" then
		scanSpells(2);
	elseif event == "UNIT_PET" then
		scanPetSpells();
	elseif event == "ACTIONBAR_SLOT_CHANGED" then
		scanActionSlots();
	elseif event == "PLAYER_EQUIPMENT_CHANGED" then
		scanItemSlots();
	end

	return;
end 



C_Timer.NewTicker(0.25, ATGCD_OnUpdate);
ATGCD:SetScript("OnEvent", ATGCD_OnEvent)

ATGCD:RegisterUnitEvent("UNIT_SPELLCAST_SUCCEEDED", "player");
ATGCD:RegisterUnitEvent("UNIT_SPELLCAST_INTERRUPTED", "player");
ATGCD:RegisterEvent("SPELLS_CHANGED")
ATGCD:RegisterUnitEvent("UNIT_PET", "player")
ATGCD:RegisterEvent("ACTIONBAR_SLOT_CHANGED")
ATGCD:RegisterEvent("PLAYER_ENTERING_WORLD")
ATGCD:RegisterEvent("PLAYER_EQUIPMENT_CHANGED")


