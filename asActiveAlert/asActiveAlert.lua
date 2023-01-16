local ASAA_CoolButtons

ASAA_SpellList = {};
local ASAA_SpellIcon = {}
local ASAA_SIZE = 26;	

local ASAA_CoolButtons_X = 170			-- 쿨 List 위치
local ASAA_CoolButtons_Y = 55
local ASAA_Alpha = 0.9
local ASAA_CooldownFontSize = 10

local prev_cnt = 0;

-- 원치 않는 발동 알림은 안보이게
local ASAA_BackList = {
	--["천상의 폭풍"] = true,
};


local action_list = {};

local _G = _G;

local function ScanActionSlot()
	local lActionSlot = 0;
	table.wipe(action_list);

	for lActionSlot = 1, 120 do
		local type, id, subType, spellID = GetActionInfo(lActionSlot);

		if type and type == "macro" then
			 id = GetMacroSpell(id);
		end
	
		if id then
			local name = GetSpellInfo(id);

			if name  then
				action_list[id] = true;
			end
		end
	end	
end

local function asCooldownFrame_Clear(self)
	self:Clear();
end

local function asCooldownFrame_Set(self, start, duration, enable, forceShowDrawEdge, modRate)
	if enable and enable ~= 0 and start > 0 and duration > 0 then
		self:SetDrawEdge(forceShowDrawEdge);
		self:SetCooldown(start, duration, modRate);
	else
		asCooldownFrame_Clear(self);
	end
end

function ASAA_UpdateCooldown()

	local selfName;
	local numCools = 1;
	local frame;
	local frameIcon, frameCooldown;
	local name, icon, duration, start, enable;
	local color;
	local frameBorder;
	local maxIdx;
	local parent;
		
	maxIdx = #ASAA_SpellList;
	parent = ASAA_CoolButtons;

	if parent.frames == nil then
		parent.frames = {};
	end
	

	for i = 1, maxIdx do
		local skip = false;
		local debuff;
		local idx = i;
		local array = ASAA_SpellList;

		icon = ASAA_SpellIcon[idx];
		start, duration, enable = GetSpellCooldown(array[idx]);
		local isUsable, notEnoughMana = IsUsableSpell(array[idx]);


		--if (icon and enable > 0) then
		if (icon) then
			
			frame = parent.frames[numCools];

			if ( not frame ) then
				parent.frames[numCools] = CreateFrame("Button", nil, parent, "asActiveAlert2FrameTemplate");
				frame = parent.frames[numCools];
				frame:EnableMouse(false); 

				for _,r in next,{frame.cooldown:GetRegions()}	do 
					if r:GetObjectType()=="FontString" then 
						r:SetFont("Fonts\\2002.TTF",ASAA_CooldownFontSize,"OUTLINE")
						break 
					end 
				end

				frame.icon:SetTexCoord(.08, .92, .08, .92)
				frame.border:SetTexture("Interface\\Addons\\asActiveAlert\\border.tga")
				frame.border:SetTexCoord(0.08,0.08, 0.08,0.92, 0.92,0.08, 0.92,0.92)	

			end

			-- set the icon
			frameIcon = frame.icon;
			local frameBorder = frame.border;
			frameIcon:SetTexture(icon);
			frameIcon:SetAlpha(ASAA_Alpha);
			frame:ClearAllPoints();
			frame:Show();

			frameBorder:SetVertexColor(0, 0, 0);

			if ( isUsable ) then
				frameIcon:SetVertexColor(1.0, 1.0, 1.0);
			elseif ( notEnoughMana ) then
				frameIcon:SetVertexColor(0.5, 0.5, 1.0);
			else
				frameIcon:SetVertexColor(0.4, 0.4, 0.4);
			end
		
			frameCooldown = frame.cooldown;
			frameCooldown:Show();
			asCooldownFrame_Set(frameCooldown, start, duration, duration > 0, enable);
			frameCooldown:SetHideCountdownNumbers(false);
							
			numCools = numCools + 1;
		end
	end

	for i=1, numCools - 1 do
		-- anchor the current aura
		ASAA_UpdateCoolAnchor(parent.frames, i, i- 1, ASAA_SIZE, 2, true, parent);
	end

	-- 이후 전에 보였던 frame을 지운다.
	for i = numCools, prev_cnt do
		frame = parent.frames[i];

		if ( frame ) then
			frame:Hide();	
		end
	end

	prev_cnt = numCools;
end

function ASAA_UpdateCoolAnchor(frames, index, anchorIndex, size, offsetX, right, parent)

	local cool = frames[index];
	local point1 = "TOPLEFT";
	local point2 = "BOTTOMLEFT";
	local point3 = "TOPRIGHT";

	if (right == false) then
		point1 = "TOPRIGHT";
		point2 = "BOTTOMRIGHT";
		point3 = "TOPLEFT";
		offsetX = -offsetX;
	end

	if ( index == 1 ) then
		cool:SetPoint(point1, parent, point2, 0, 0);
	else
		cool:SetPoint(point1, frames[index-1], point3, offsetX, 0);
	end

	-- Resize
	cool:SetWidth(size);
	cool:SetHeight(size * 0.9);
end


function ASAA_Init()

    LoadAddOn("asMOD");
	ASAA_CoolButtons = CreateFrame("Frame", nil, UIParent)

	ASAA_CoolButtons:SetPoint("CENTER", ASAA_CoolButtons_X, ASAA_CoolButtons_Y)
	ASAA_CoolButtons:SetWidth(1)
	ASAA_CoolButtons:SetHeight(1)
	ASAA_CoolButtons:SetScale(1)

    if asMOD_setupFrame then
        asMOD_setupFrame (ASAA_CoolButtons, "asActiveAlert");

    end

	ASAA_CoolButtons:Show()

    
	ASAA_SpellList = {};
	ASAA_SpellIcon = {};
	ScanActionSlot();

	ASAA_UpdateCooldown();


end

function ASAA_Insert(id)

	local i
	local maxIdx = #ASAA_SpellList;
	local icon;

	if ACI_SpellID_list and ACI_SpellID_list[id] then
		return;
	end

	for i = 1, maxIdx do
		if ASAA_SpellList[i] == id then
			return;
		end
	end

	name, discard, icon = GetSpellInfo(id);

	if ASAA_BackList and ASAA_BackList[name] then
		return;
	end

	if not action_list[id] then
		--Slot에 있는것만
		return;
	end

	for i = 1, maxIdx do
		if ASAA_SpellIcon[i] == icon then
			return;
		end
	end

	tinsert(ASAA_SpellList, id);
	tinsert(ASAA_SpellIcon, icon);

	ASAA_UpdateCooldown();
end

function ASAA_Delete(id)
	
	local i
	local maxIdx = #ASAA_SpellList;

	for i = 1, maxIdx do
		if ASAA_SpellList[i] == id then
			tremove(ASAA_SpellList, i)
			tremove(ASAA_SpellIcon, i)
			ASAA_UpdateCooldown();
			return;
		end
	end

end

function ASAA_OnEvent(self, event, arg1, arg2, arg3)

	if event == "SPELL_ACTIVATION_OVERLAY_GLOW_SHOW" then
		ASAA_Insert(arg1)
	elseif event == "SPELL_ACTIVATION_OVERLAY_GLOW_HIDE" then
		ASAA_Delete(arg1)
	elseif event == "SPELL_UPDATE_COOLDOWN" then
		ASAA_UpdateCooldown();
	elseif event == "UNIT_SPELLCAST_SUCCEEDED" and (arg1 == "player" or arg1 == "pet") then
		ASAA_UpdateCooldown();
	elseif event == "PLAYER_ENTERING_WORLD" then
		ASAA_Init();
	elseif event == "ACTIVE_TALENT_GROUP_CHANGED" then
		ASAA_Init();
	end

	return;
end 

local ASAA_mainframe = CreateFrame("Frame")
ASAA_mainframe:RegisterEvent("SPELL_ACTIVATION_OVERLAY_GLOW_SHOW")
ASAA_mainframe:RegisterEvent("SPELL_ACTIVATION_OVERLAY_GLOW_HIDE")
ASAA_mainframe:RegisterEvent("SPELL_UPDATE_COOLDOWN")
ASAA_mainframe:RegisterEvent("UNIT_SPELLCAST_SUCCEEDED")
ASAA_mainframe:RegisterEvent("PLAYER_ENTERING_WORLD");
ASAA_mainframe:RegisterEvent("ACTIVE_TALENT_GROUP_CHANGED");


ASAA_mainframe:SetScript("OnEvent", ASAA_OnEvent)

ASAA_Init()
