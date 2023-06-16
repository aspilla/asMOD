AHCA_Options_Default = {
    AlertAnyway = false;            -- 무조건 알리기
}


local AHCA = CreateFrame("FRAME", nil, UIParent);
AHCA.unit = nil;

function AHCA:CheckHealer()

    local playerishealer = (UnitGroupRolesAssigned("player") == "HEALER") or AHCA_Options["AlertAnyway"];

    if playerishealer == false then
        self.unit = nil;
        return;
    end

    if (IsInGroup()) then
		if IsInRaid() then -- raid
            self.unit = nil;
            return;
		else -- party

            if UnitGroupRolesAssigned("player") == "HEALER" then
                self.unit = "player";
                return;
            end
			for i=1, 5 do
				local unit = "party"..i;
                local role = UnitGroupRolesAssigned(unit);
                if role == "HEALER" then
                    self.unit = unit;                   
                    return;
                end
			end
		end
	end


end

function AHCA:UpdateAlert()

    if self.unit == nil then
        return;
    end

    if not IsInInstance() then
        return;
    end

    local max = UnitPowerMax(self.unit, Enum.PowerType.Mana );
    local mana = UnitPower(self.unit, Enum.PowerType.Mana );
	if max and mana then
        local  msg = "힐러마나 ".. math.ceil(mana/max * 100)  .. "%";        
        --print (msg);
        SendChatMessage(msg);
    end
end

local bfirst = false;

local function AHCA_OnEvent(self, event, ...)

    if not bfirst then
        self:SetupOptionPanels();
        bfirst = true;
    end
    self:CheckHealer();
	if event == "PLAYER_REGEN_ENABLED" then
		self:UpdateAlert();
	end
end


AHCA:SetScript("OnEvent", AHCA_OnEvent);
AHCA:RegisterEvent("PLAYER_REGEN_ENABLED");
AHCA:RegisterEvent("PLAYER_ENTERING_WORLD");
AHCA:RegisterEvent("ACTIVE_TALENT_GROUP_CHANGED");
AHCA:RegisterEvent("GROUP_ROSTER_UPDATE");
AHCA:RegisterEvent("ROLE_CHANGED_INFORM");


local function OnSettingChanged(_, setting, value)
	local variable = setting:GetVariable()
	AHCA_Options[variable] = value;
    ReloadUI();
end

function AHCA:SetupOptionPanels()

    local category = Settings.RegisterVerticalLayoutCategory("asHealthChatAlert")

    if AHCA_Options == nil then
        AHCA_Options = {};
        AHCA_Options = CopyTable(AHCA_Options_Default);
    end

    for variable, _ in pairs(AHCA_Options_Default) do

        
        local name = variable;
        local tooltip = ""
        if  AHCA_Options[variable] == nil then    
            AHCA_Options[variable] = AHCA_Options_Default[variable];
        end
        local defaultValue = AHCA_Options[variable];

        local setting = Settings.RegisterAddOnSetting(category, name, variable, type(defaultValue), defaultValue)
        Settings.CreateCheckBox(category, setting, tooltip)
        Settings.SetOnValueChangedCallback(variable, OnSettingChanged)
    end

    Settings.RegisterAddOnCategory(category)
end