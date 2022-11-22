
local function show_percentage(frame)

	if (frame.healthbar) then
		frame.healthbar.showPercentage = true;
	end
	if (frame.manabar) then
		frame.manabar.showPercentage = true;
	end
end



-- 직업 아이콘 시작--
function asFixUnitFrame_OnLoad(self)

	self:RegisterEvent("PLAYER_TARGET_CHANGED");

end

function asFixUnitFrame_OnCombatEvent(self, event, flags, amount, type)

	local feedbackText = self.feedbackText;
	feedbackText:Hide();


end


function asFixUnitFrame_UpdateIcon(frame, unit)
	local icon = getglobal(frame.."ClassIconArtwork");
	local iconframe = getglobal(frame.."ClassIcon");
	local iconborder = getglobal(frame.."ClassIconBorder");
 


	if (UnitIsPlayer(unit)) then
		

		local targetClass = select(2,UnitClass("target"))

		if targetClass then 
			icon:SetTexCoord(unpack(CLASS_ICON_TCOORDS[targetClass]))
			icon:Show();
			iconframe:Show();
			iconborder:SetHeight(43);
			iconborder:SetWidth(43);
			icon:SetHeight(20);
			icon:SetWidth(20);
		else
			iconframe:Hide();
		end

	


	else
		iconframe:Hide();
	end
end



function asFixUnitFrame_UpdatePartyIcons()
	
	local icon;
	local texture;

	if (HIDE_PARTY_INTERFACE == "1" and IsInRaid()) then
		for index = 1, 4 do
			icon =  getglobal("PartyMemberFrame"..index.."ClassIcon");
			icon:Hide();
		end
		return;
	end	

	local discard, englishClass;
	for index = 1, 4 do
		iconframe =  getglobal("PartyMemberFrame"..index.."ClassIcon");
		icon = getglobal("PartyMemberFrame"..index.."ClassIconArtwork");

		local targetClass = select(2,UnitClass("party"..index))

		if targetClass then 
			icon:SetTexCoord(unpack(CLASS_ICON_TCOORDS[targetClass]))
			icon:Show();
			iconframe:Show();
		else
			iconframe:Hide();
		end

	end
end


function asFixUnitFrame_OnEvent(self, event)
	if (event == "PLAYER_TARGET_CHANGED") then
		asFixUnitFrame_UpdateIcon("TargetFrame", "target");
	end
end


hooksecurefunc("RaidOptionsFrame_UpdatePartyFrames", asFixUnitFrame_UpdatePartyIcons);
	

PlayerFrame:UnregisterEvent("UNIT_COMBAT")
TargetFrame:UnregisterEvent("UNIT_COMBAT")
PetFrame:UnregisterEvent("UNIT_COMBAT")
