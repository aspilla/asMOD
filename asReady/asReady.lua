-----------------설정 ------------------------

local AREADY_WIDTH = 100	-- 쿨 바의 넓이
local AREADY_HEIGHT = 14		-- 쿨 바의 높이
local AREADY_X = 330;		-- X 위치
local AREADY_Y = 15;		-- Y 위치
local AREADY_Font = "Fonts\\2002.TTF";
local AREDDY_Max = 10;		-- 최대 표시 List 수
local AREADY_UpdateRate = 0.2 -- Refresh 시간 초



-- 파티일경우 Check할 Spell
-- Spell ID 와 쿨 Time을 초로 입력

local trackedPartySpells={
    [47528]  = 15, -- Mind Freeze
    [183752] = 15, -- Disrupt
    [78675]  = 60, -- Solar Beam
    [106839] = 15, -- Skull Bash
    [147362] = 24, -- Counter Shot
    [187707] = 15, -- Muzzle
    [2139]   = 24, -- Counterspell
    [116705] = 15, -- Spear Hand Strike
    [96231]  = 15, -- Rebuke
    [15487]  = 45, -- Silence
	[23137]  = 15,
    [1766]   = 15, -- Kick
    [57994]  = 12, -- Wind Shear
    [19647]  = 24, -- Spell Lock
	[132409] = 24, -- Warlock: Command Demon - Spell Lock
	[132409] = 24, -- Warlock: Grimoire of Sacrifice: Spell Lock
	[6552]   = 15, -- Pummel
}


-----------------설정 끝 ------------------------

local partycool = {};
local max_idx = 0;


local AREADY = CreateFrame("FRAME", nil, UIParent)
AREADY:SetPoint("BOTTOM",UIParent,"BOTTOM", 0, 0)
AREADY:SetWidth(0)
AREADY:SetHeight(0)
AREADY:Show();

AREADY.bar = {};
AREADY.icon = {};


 LoadAddOn("asMOD");


local function create_bar_icon(idx, unit, spellid, time, cool)

	if not AREADY.bar[idx] then
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

		AREADY.bar[idx].bg:SetTexture("Interface\\Addons\\asbar[idx]\\border.tga")
		AREADY.bar[idx].bg:SetTexCoord(0.1,0.1, 0.1,0.1, 0.1,0.1, 0.1,0.1)	
		AREADY.bar[idx].bg:SetVertexColor(0, 0, 0, 0.8);

		if idx == 1 then
			AREADY.bar[idx]:SetPoint("CENTER",UIParent,"CENTER", AREADY_X, AREADY_Y)
		else
			AREADY.bar[idx]:SetPoint("BOTTOMLEFT",AREADY.bar[idx - 1],"TOPLEFT", 0, 2)
		end

		AREADY.bar[idx].playname = AREADY.bar[idx]:CreateFontString("AREADYPlayname".. idx, "OVERLAY")
		AREADY.bar[idx].playname:SetFont(AREADY_Font, AREADY_HEIGHT - 2,  "OUTLINE")
		AREADY.bar[idx].playname:SetPoint("LEFT", AREADY.bar[idx], "LEFT", 2, 0)
		AREADY.bar[idx].cooltime = AREADY.bar[idx]:CreateFontString("AREADYCooltime".. idx, "OVERLAY")
		AREADY.bar[idx].cooltime:SetFont(AREADY_Font, AREADY_HEIGHT - 3,  "OUTLINE")
		AREADY.bar[idx].cooltime:SetPoint("RIGHT", AREADY.bar[idx], "RIGHT", -2, 0)

			
		AREADY.icon[idx] = CreateFrame("Button", "AREADYIcon" .. idx, AREADY.bar[idx], "AREADYFrameTemplate");

		AREADY.icon[idx]:SetPoint("TOPRIGHT", AREADY.bar[idx],"TOPLEFT", -2, 0);

		AREADY.icon[idx]:SetWidth(AREADY_HEIGHT);
		AREADY.icon[idx]:SetHeight(AREADY_HEIGHT);
		AREADY.icon[idx]:SetScale(1);
		AREADY.icon[idx]:SetAlpha(1);
		AREADY.icon[idx]:EnableMouse(false);
		

        if idx == 1 then
			

            if asMOD_setupFrame then
                  asMOD_setupFrame (AREADY.bar[idx], "asReady");
             end
	
			
		end
	end

	if spellid then


		local name,_ ,icon = GetSpellInfo(spellid)
		local playerclass=select(2,UnitClass(unit))
		local color=RAID_CLASS_COLORS[playerclass]
		local curtime = GetTime();
		local maxcool = cool;
		local curcool = maxcool;

		if curtime - time < cool then
			curcool = curtime - time;
		else	
			curcool = maxcool;
		end


		AREADY.bar[idx]:SetStatusBarColor(color.r, color.g, color.b);
		AREADY.bar[idx]:SetMinMaxValues(0, cool)
		AREADY.bar[idx]:SetValue(curcool)


		if icon then


			local frameIcon = _G["AREADYIcon"..idx.."Icon"];

			frameIcon:SetTexture(icon);
			frameIcon:Show();
			AREADY.icon[idx]:Show();
		end

		AREADY.bar[idx].playname:SetText(UnitName(unit));
		AREADY.bar[idx].playname:Show();

		if maxcool == curcool then
			AREADY.bar[idx].cooltime:SetText("ON");
			AREADY.bar[idx].cooltime:SetTextColor(0, 1, 0);
		else
			AREADY.bar[idx].cooltime:SetText(format("%.1f", maxcool- curcool));
			AREADY.bar[idx].cooltime:SetTextColor(1, 1, 1);

		end
		AREADY.bar[idx].cooltime:Show();



		AREADY.bar[idx]:Show();
	end

end

local function hide_bar_icon(max)

	for i = max, AREDDY_Max do
		if AREADY.bar and AREADY.bar[i] then
			AREADY.bar[i]:Hide();
			AREADY.icon[i]:Hide();
		end
	end


end


local clearall = false;


local function AREADY_OnUpdate(self, elapsed)

	if not self.update  then
		self.update = 0;
	end

	self.update = self.update + elapsed

	if self.update >= 0.2   then

		local idx = 1;

		if clearall then
			clearall = false;
			partycool = {}
			max_idx = 0;

			if IsInRaid() then
				AREADY:UnregisterEvent("UNIT_SPELLCAST_SUCCEEDED");
			else
				AREADY:RegisterEvent("UNIT_SPELLCAST_SUCCEEDED");
			end
		end


		for i,v in pairs(partycool) do
			
			if v then
				local spellid = v[2];
				local time = v[3];
				local cool = v[4];

				if v[1] == 0 then
					unit = "player"
				else
					unit = "party"..v[1];
				end

				create_bar_icon(idx, unit, spellid, time, cool);

				idx = idx + 1;

			end
		end

		hide_bar_icon(idx);

		self.update = 0		
	end
end


local function Comparison(AIndex, BIndex)



	local ACool = AIndex[4];
	local BCool = BIndex[4];

	if (ACool ~= BCool) then
		return ACool > BCool;
	end

	return false;
end


local function AREADY_OnEvent(self, event, arg1, arg2, arg3, arg4, arg5)

	if event == "UNIT_SPELLCAST_SUCCEEDED" then

		local spellid = arg3;
		local unit = arg1;
		local time = GetTime();

		if IsInRaid() then

		elseif GetNumGroupMembers() > 1 then

			if trackedPartySpells[spellid] then
				
				local cool = trackedPartySpells[spellid];
	
				if UnitIsUnit("playerpet", unit) then
        	    	unit="player"
            	else
                	for i=1,GetNumGroupMembers()-1 do
                		if UnitIsUnit("partypet"..i, unit) then
                      		unit="party"..i;
	                        break
			        	end
	                end
    	        end
                
                -- Create a reference to pass to several functions
        	    if UnitIsUnit("player", unit) then
					local bfind = false
					for i=1, max_idx do 
						if partycool[i][1] == 0 and   partycool[i][2] == spellid then
							bfind = true;
							partycool[i] = {0, spellid, time, cool};
							break;
						end
					
					end

					if not bfind and max_idx <= AREDDY_Max then
	            	    partycool[max_idx + 1] = {0, spellid, time, cool};
						table.sort(partycool, Comparison);
						max_idx = max_idx + 1;
					end
				else
    	        	for k=1,GetNumGroupMembers()-1 do 

						if UnitIsUnit("party"..k, unit) then

							local bfind = false
							for i=1, max_idx do 
								if partycool[i][1] == k and   partycool[i][2] == spellid then
									bfind = true;
									partycool[i] = {k, spellid, time, cool};
									break;
								end
							
							end

							if not bfind and max_idx <= AREDDY_Max  then
								partycool[max_idx + 1] = {k, spellid, time, cool};
								table.sort(partycool, Comparison);
								max_idx = max_idx + 1;
							end
						end
					end
	            end
			end
		end
	else
		clearall = true;
	end

	return;
end 


AREADY:SetScript("OnEvent", AREADY_OnEvent)
AREADY:SetScript("OnUpdate", AREADY_OnUpdate)
AREADY:RegisterEvent("PLAYER_ENTERING_WORLD")
AREADY:RegisterEvent("GROUP_JOINED")
AREADY:RegisterEvent("GROUP_ROSTER_UPDATE")


