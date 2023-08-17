-----------------설정 ------------------------

local AREADY_WIDTH = 100	-- 쿨 바의 넓이
local AREADY_HEIGHT = 14		-- 쿨 바의 높이
local AREADY_X = -500;		-- X 위치
local AREADY_Y = 150;		-- Y 위치
local AREADY_Font = "Fonts\\2002.TTF";
local AREADY_Max = 10;		-- 최대 표시 List 수
local AREADY_UpdateRate = 0.2 -- Refresh 시간 초



-- 파티일경우 Check할 Spell
-- Spell ID 와 쿨 Time을 초로 입력

local trackedPartySpells={
    [6552]  = 15, -- Pummel
    [1766]  = 15, -- Kick
    [183752] = 15, --Disrupt
	[116705] = 15, --Spear Hand Strike
    [47528]   = 15, --Mind Freeze
    [187707] = 15, -- Muzzle
    [147362]  = 24, -- Counter Shot
    [351338]  = 20, -- Quell
	[106839]  = 15, -- "Skull Bash
    [119898]  = 24, -- Command Demon
	[15487] = 45, -- Silence
	[96231]   = 15, -- Rebuke
	[57994] = 12, -- Wind Shear
	[2139] = 24, -- Counterspell
	[78675]  = 60, -- Solar Beam
	[119910]  = 24, -- Command Demon
	[119914]  = 30, -- Command Demon
	[132409]  = 24, -- Command Demon
	["주문 잠금"] = 24,
}

-----------------설정 끝 ------------------------

local partycool = {};

local AREADY = CreateFrame("FRAME", nil, UIParent)
AREADY:SetPoint("BOTTOM",UIParent,"BOTTOM", 0, 0)
AREADY:SetWidth(0)
AREADY:SetHeight(0)
AREADY:Show();

AREADY.bar = {};

LoadAddOn("asMOD");

for idx = 1, AREADY_Max do
	AREADY.bar[idx] = CreateFrame("StatusBar", nil, UIParent)
	AREADY.bar[idx]:SetStatusBarTexture("Interface\\addons\\asReady\\UI-StatusBar.blp", "BORDER")
	AREADY.bar[idx]:GetStatusBarTexture():SetHorizTile(false)
	AREADY.bar[idx]:SetMinMaxValues(0, 100)
	AREADY.bar[idx]:SetValue(0)
	AREADY.bar[idx]:SetHeight(AREADY_HEIGHT)
	AREADY.bar[idx]:SetWidth(AREADY_WIDTH)
	
	AREADY.bar[idx].bg = AREADY.bar[idx]:CreateTexture(nil, "BACKGROUND")
	AREADY.bar[idx].bg:SetPoint("TOPLEFT", AREADY.bar[idx], "TOPLEFT", -1, 1)
	AREADY.bar[idx].bg:SetPoint("BOTTOMRIGHT", AREADY.bar[idx], "BOTTOMRIGHT", 1, -1)

	AREADY.bar[idx].bg:SetTexture("Interface\\Addons\\asReady\\border.tga")
	AREADY.bar[idx].bg:SetTexCoord(0.1,0.1, 0.1,0.1, 0.1,0.1, 0.1,0.1)	
	AREADY.bar[idx].bg:SetVertexColor(0, 0, 0, 0.8);

	if idx == 1 then
		AREADY.bar[idx]:SetPoint("CENTER",UIParent,"CENTER", AREADY_X, AREADY_Y)
	else
		AREADY.bar[idx]:SetPoint("BOTTOMLEFT",AREADY.bar[idx - 1],"TOPLEFT", 0, 2)
	end

	AREADY.bar[idx].playname = AREADY.bar[idx]:CreateFontString(nil, "OVERLAY")
	AREADY.bar[idx].playname:SetFont(AREADY_Font, AREADY_HEIGHT - 2,  "OUTLINE")
	AREADY.bar[idx].playname:SetPoint("LEFT", AREADY.bar[idx], "LEFT", 2, 0)
	AREADY.bar[idx].cooltime = AREADY.bar[idx]:CreateFontString(nil, "OVERLAY")
	AREADY.bar[idx].cooltime:SetFont(AREADY_Font, AREADY_HEIGHT - 3,  "OUTLINE")
	AREADY.bar[idx].cooltime:SetPoint("RIGHT", AREADY.bar[idx], "RIGHT", -2, 0)

		
	AREADY.bar[idx].button = CreateFrame("Button", nil, AREADY.bar[idx], "AREADYFrameTemplate");

	AREADY.bar[idx].button:SetPoint("RIGHT", AREADY.bar[idx],"LEFT", -1, 0);

	AREADY.bar[idx].button:SetWidth((AREADY_HEIGHT + 1) * 1.2);
	AREADY.bar[idx].button:SetHeight(AREADY_HEIGHT + 1);
	AREADY.bar[idx].button:SetScale(1);
	AREADY.bar[idx].button:SetAlpha(1);
	AREADY.bar[idx].button:EnableMouse(false);
	AREADY.bar[idx].button.icon:SetTexCoord(.08, .92, .08, .92);
	AREADY.bar[idx].button.border:SetTexture("Interface\\Addons\\asReady\\border.tga");
	AREADY.bar[idx].button.border:SetTexCoord(0.08,0.08, 0.08,0.92, 0.92,0.08, 0.92,0.92);
	AREADY.bar[idx].button.border:SetVertexColor(0, 0, 0);
	AREADY.bar[idx].button:Hide();
	

	if idx == 1 then
		if asMOD_setupFrame then
			  asMOD_setupFrame (AREADY.bar[idx], "asReady");
		end			
	end
end

local function create_bar_icon(idx, unit, spellid, time, cool)

	local name,_ ,icon = GetSpellInfo(spellid)
	local _, englishClass = UnitClass(unit);
	local color=RAID_CLASS_COLORS[englishClass]
	local curtime = GetTime();
	local curcool;

	if time > curtime then
		AREADY.bar[idx]:Hide();
		return;
	end

	local remain = curtime - time;

	if remain < cool then
		curcool = remain;
	else	
		curcool = cool;
	end

	AREADY.bar[idx]:SetStatusBarColor(color.r, color.g, color.b);
	AREADY.bar[idx]:SetMinMaxValues(0, cool)
	AREADY.bar[idx]:SetValue(curcool)
	if icon then
		local frameIcon = AREADY.bar[idx].button.icon;
		frameIcon:SetTexture(icon);
		frameIcon:Show();
		AREADY.bar[idx].button:Show();
	end

	AREADY.bar[idx].playname:SetText(UnitName(unit));
	AREADY.bar[idx].playname:Show();

	if curcool == cool then
		AREADY.bar[idx].cooltime:SetText("ON");
		AREADY.bar[idx].cooltime:SetTextColor(0, 1, 0);
	else
		AREADY.bar[idx].cooltime:SetText(format("%.1f", cool - curcool));
		AREADY.bar[idx].cooltime:SetTextColor(1, 1, 1);
	end
	AREADY.bar[idx].cooltime:Show();
	AREADY.bar[idx]:Show();

end

local function hide_bar_icon(max)
	for i = max, AREADY_Max do
		if AREADY.bar and AREADY.bar[i] then
			AREADY.bar[i]:Hide();
			AREADY.bar[i].button:Hide();
		end
	end
end


local function AREADY_OnUpdate()

	local idx = 1;

	for i,v in pairs(partycool) do
			
		if v then
			local spellid = v[2];
			local time = v[3];
			local cool = v[4];
			local prev_idx = v[5];
			local unit;

			if v[1] == 5 then
				unit = "player"
			else
				unit = "party"..v[1];
			end

			local currtime = GetTime();
			if currtime <= time + cool + 1 or prev_idx ~= idx then
				create_bar_icon(idx, unit, spellid, time, cool);
				v[5] = idx;
			end

			idx = idx + 1;

			if idx > AREADY_Max then
				break;
			end

		end
	end

	hide_bar_icon(idx);

end

local function AREADY_OnEvent(self, event, arg1, arg2, arg3)

	if event == "UNIT_SPELLCAST_SUCCEEDED" and arg1 and arg3 then
		if IsInRaid() then
			--Do nothing
		elseif IsInGroup() then
		--elseif true then -- Test 용
			local spellid = arg3;
			local unit = arg1;
			local time = GetTime();

			local name = GetSpellInfo(spellid);

	--			print (spellid);
			if trackedPartySpells[spellid] or trackedPartySpells[name] then
				local cool = trackedPartySpells[spellid];

				if not cool then
					cool = trackedPartySpells[name]
				end

        	    if UnitIsUnit("player", unit) then
					partycool[5] = {5, spellid, time, cool, 0};
				else
    	        	for k=1,GetNumGroupMembers()-1 do
						if UnitIsUnit("party"..k, unit) then
							partycool[k] = {k, spellid, time, cool, 0};
						end
					end
	            end
			end
		end
	else
		partycool = {};
		
		if IsInRaid() then
			AREADY:UnregisterEvent("UNIT_SPELLCAST_SUCCEEDED");
		else
			AREADY:RegisterEvent("UNIT_SPELLCAST_SUCCEEDED");
		end	
	end

	return;
end 


AREADY:SetScript("OnEvent", AREADY_OnEvent)
AREADY:RegisterEvent("PLAYER_ENTERING_WORLD");
AREADY:RegisterEvent("GROUP_JOINED");
AREADY:RegisterEvent("GROUP_ROSTER_UPDATE");
C_Timer.NewTicker(AREADY_UpdateRate, AREADY_OnUpdate);