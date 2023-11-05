---설정부
local ACTA_UpdateRate = 0.1 -- Check할 주기
local ACTA_MaxShow = 3      -- 최대로 보여줄 개수
local ACTA_FontSize = 18;
local ACTA_X = 0;
local ACTA_Y = -80;

local function isFaction(unit)
	if UnitIsUnit("player", unit) then
		return false;
	else
		local reaction = UnitReaction("player", unit);
		if reaction and reaction <= 4 then
			return true;
		elseif UnitIsPlayer(unit) then
			return false;
		end
	end
end

local DangerousSpellList = {};
local showlist = {};

local function CheckCasting(nameplate)
	if not nameplate or nameplate:IsForbidden() then
		return false;
	end

	if not nameplate.UnitFrame or nameplate.UnitFrame:IsForbidden() then
		return false;
	end

	local unit = nameplate.UnitFrame.unit;

	if isFaction(unit) and UnitIsUnit(unit .. "target", "player") and not UnitIsUnit(unit, "target") then
		local name, _, texture, _, endTime, _, _, _, spellid = UnitCastingInfo(unit);
		if not name then
			name, _, texture, _, endTime, _, _, spellid = UnitChannelInfo(unit);
		end

		if name then
			local curr = GetTime();
			local remain = (endTime / 1000) - curr;

			if remain > 0 then
				local type = 3;

				if DangerousSpellList[spellid] then
					if DangerousSpellList[spellid] == "interrupt" then
						type = 1;
					else
						type = 2;
					end
				end

				tinsert(showlist, { type, remain, texture, spellid });
			end
		end
	end
end

local function Comparison(AIndex, BIndex)
	if AIndex[1] ~= BIndex[1] then
		return AIndex[1] < BIndex[1]
	elseif AIndex[2] ~= BIndex[2] then
		return AIndex[2] < BIndex[2]
	end	
	return false;
end


local function ShowCasting()
	local currshow = 1;

	table.sort(showlist, Comparison);
	for _, v in pairs(showlist) do
		local type = v[1];
		local remain = v[2];
		local texture = v[3];
		local spellid = v[4];


		ACTA.cast[currshow]:SetText("|T" ..
			texture .. ":0|t " .. format("%.1f", max(remain, 0)) .. " |T" .. texture .. ":0|t");

		ACTA.cast[currshow].castspellid = spellid;

		if type == 1 then
			ACTA.cast[currshow]:SetTextColor(0, 1, 0.35);
		elseif type == 2 then
			ACTA.cast[currshow]:SetTextColor(0.8, 0.5, 0.5);
		else
			ACTA.cast[currshow]:SetTextColor(1, 1, 1);
		end
		ACTA.cast[currshow]:Show();
		currshow = currshow + 1;

		if currshow > ACTA_MaxShow then
			break;
		end
	end

	for i = currshow, ACTA_MaxShow do
		ACTA.cast[i]:Hide();
	end
end

local function ACTA_OnUpdate()

	showlist = {};
	for _, v in pairs(C_NamePlate.GetNamePlates(issecure())) do
		local nameplate = v;
		if (nameplate) then
			CheckCasting(nameplate);
		end
	end

	ShowCasting();
end

local DBMobj;

local function scanDBM()
	DangerousSpellList = {};
	if DBMobj.Mods then
		for i, mod in ipairs(DBMobj.Mods) do

			if mod.announces then
				for k, obj in pairs(mod.announces) do
					if obj.spellId and obj.announceType then
						if DangerousSpellList[obj.spellId] == nil or DangerousSpellList[obj.spellId] ~= "interrupt" then
                            DangerousSpellList[obj.spellId] = obj.announceType;
                        end						
					end
				end
			end

			if mod.specwarns then
				for k, obj in pairs(mod.specwarns) do
					if obj.spellId and obj.announceType then
						if DangerousSpellList[obj.spellId] == nil or DangerousSpellList[obj.spellId] ~= "interrupt" then
                            DangerousSpellList[obj.spellId] = obj.announceType;
                        end
					end
				end
			end			
		end
	end
end

local function NewMod(self, ...)
	DBMobj = self;
	C_Timer.After(0.25, scanDBM);
end

local function initAddon()
	ACTA = CreateFrame("Frame", nil, UIParent);
	ACTA.cast = {};

	for i = 1, ACTA_MaxShow do
		ACTA.cast[i] = ACTA:CreateFontString(nil, "OVERLAY");
		ACTA.cast[i]:SetFont("Fonts\\2002.TTF", ACTA_FontSize, "THICKOUTLINE")

		if i == 1 then
			ACTA.cast[i]:SetPoint("CENTER", UIParent, "CENTER", ACTA_X, ACTA_Y);
		else
			ACTA.cast[i]:SetPoint("BOTTOM", ACTA.cast[i - 1], "TOP", 0, 3);
		end

		ACTA.cast[i]:EnableMouse(true);

		if not ACTA.cast[i]:GetScript("OnEnter") then
			ACTA.cast[i]:SetScript("OnEnter", function(s)
				if s.castspellid and s.castspellid > 0 then
					GameTooltip_SetDefaultAnchor(GameTooltip, s);
					GameTooltip:SetSpellByID(s.castspellid);
				end
			end)
			ACTA.cast[i]:SetScript("OnLeave", function()
				GameTooltip:Hide();
			end)
		end
		ACTA.cast[i]:Hide();
	end

	--주기적으로 Callback
	C_Timer.NewTicker(ACTA_UpdateRate, ACTA_OnUpdate);

	local bloaded = LoadAddOn("DBM-Core");
	if bloaded then
		hooksecurefunc(DBM, "NewMod", NewMod)
	end
end
initAddon();
