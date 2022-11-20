local ADF;
local ADF_PLAYER_DEBUFF;
local ADF_TARGET_DEBUFF;
local ADF_DeBuffList = {}

local ADF_SIZE = 28;
local ADF_SIZE_BIG = 29;
local ADF_SIZE_SMALL = 28;
local ADF_TARGET_DEBUFF_X = 73 + 30;
local ADF_TARGET_DEBUFF_Y = -60;
local ADF_PLAYER_DEBUFF_X = -73 - 30;
local ADF_PLAYER_DEBUFF_Y = -60;
local ADF_MAX_DEBUFF_SHOW = 7;
local ADF_ALPHA = 1
local ADF_CooldownFontSize = 12			-- Cooldown Font Size
local ADF_CountFontSize = 12;			-- Count Font Size
local ADF_AlphaCombat = 1;				-- 전투중 Alpha 값
local ADF_AlphaNormal = 0.5;			-- 비 전투중 Alpha 값
local ADF_MAX_Cool = 120				-- 최대 120초까지의 Debuff를 보임
local ADF_Show_TargetDebuff = true		-- 대상이 시전한 Debuff를 보임 (false 이면 Player가 건 Debuff 만 보임)
local ADF_Show_PVPDebuff = true			-- 다른사람이 건 PVP Debuff를 보임 (점감 효과를 갖는 Debuff) (false 이면 Player가 건 Debuff 만 보임)

local ADF_Show_ShowBossDebuff = true	-- Boss Type Debuff를 보임 (false 이면 Player가 건 Debuff 만 보임)
local ADF_RefreshRate = 0.5;			-- Target Debuff Check 주기 (초)




local PLAYER_UNITS = {
	player = true,
	vehicle = true,
	pet = true,
};


local ADF_BlackList = {

	["도전자의 짐"] = 1,	
--	["상처 감염 독"] = 1,	
--	["신경 마취 독"] = 1,
--	["맹독"] = 1,


}

local ADF_ShowList;
local b_showlist = false;
local dispellableDebuffTypes = { Magic = true, Curse = true, Disease = true, Poison = true};


-- 특정한 버프만 보이게 하려면 직업별로 편집
-- ABF_ShowList_직업명_특성
--[[
ADF_ShowList_PALADIN_3 = {
	["불신임"] = 1,	
}
--]]

local ADF_PVPDebuffList = {
	--[[ INCAPACITATES ]]--
	-- Druid
	[    99] = 2, -- Incapacitating Roar (talent)
	[203126] = 2, -- Maim (with blood trauma pvp talent)
	-- Hunter
	[  3355] = 2, -- Freezing Trap
	[ 19386] = 2, -- Wyvern Sting
	[209790] = 2, -- Freezing Arrow
	-- Mage
	[   118] = 2, -- Polymorph
	[ 28272] = 2, -- Polymorph (pig)
	[ 28271] = 2, -- Polymorph (turtle)
	[ 61305] = 2, -- Polymorph (black cat)
	[ 61721] = 2, -- Polymorph (rabbit)
	[ 61780] = 2, -- Polymorph (turkey)
	[126819] = 2, -- Polymorph (procupine)
	[161353] = 2, -- Polymorph (bear cub)
	[161354] = 2, -- Polymorph (monkey)
	[161355] = 2, -- Polymorph (penguin)
	[161372] = 2, -- Polymorph (peacock)
	[ 82691] = 2, -- Ring of Frost
	-- Monk
	[115078] = 2, -- Paralysis
	-- Paladin
	[ 20066] = 2, -- Repentance
	-- Priest
	[   605] = 2, -- Mind Control
	[  9484] = 2, -- Shackle Undead
	[ 64044] = 2, -- Psychic Horror (Horror effect)
	[ 88625] = 2, -- Holy Word: Chastise
	-- Rogue
	[  1776] = 2, -- Gouge
	[  6770] = 2, -- Sap
	-- Shaman
	[ 51514] = 2, -- Hex
	[211004] = 2, -- Hex (spider)
	[210873] = 2, -- Hex (raptor)
	[211015] = 2, -- Hex (cockroach)
	[211010] = 2, -- Hex (snake)
	-- Warlock
	[   710] = 2, -- Banish
	[  6789] = 2, -- Mortal Coil
	-- Pandaren
	[107079] = 2, -- Quaking Palm
	
	--[[ SILENCES ]]--
	-- Death Knight
	[ 47476] = 3, -- Strangulate
	-- Demon Hunter
	[204490] = 3, -- Sigil of Silence
	-- Druid
	-- Hunter
	[202933] = 3, -- Spider Sting (pvp talent)
	-- Mage
	-- Paladin
	[ 31935] = 3, -- Avenger's Shield
	-- Priest
	[ 15487] = 3, -- Silence
	[199683] = 3, -- Last Word (SW: Death silence)
	-- Rogue
	[  1330] = 3, -- Garrote
	-- Blood Elf
	[ 25046] = 3, -- Arcane Torrent (Energy version)
	[ 28730] = 3, -- Arcane Torrent (Priest/Mage/Lock version)
	[ 50613] = 3, -- Arcane Torrent (Runic power version)
	[ 69179] = 3, -- Arcane Torrent (Rage version)
	[ 80483] = 3, -- Arcane Torrent (Focus version)
	[129597] = 3, -- Arcane Torrent (Monk version)
	[155145] = 3, -- Arcane Torrent (Paladin version)
	[202719] = 3, -- Arcane Torrent (DH version)
	
	--[[ DISORIENTS ]]--
	-- Death Knight
	[207167] = 1, -- Blinding Sleet (talent) -- FIXME: is this the right category?
	-- Demon Hunter
	[207685] = 1, -- Sigil of Misery
	-- Druid
	[ 33786] = 1, -- Cyclone
	-- Hunter
	[213691] = 1, -- Scatter Shot
	[186387] = 1, -- Bursting Shot
	-- Mage
	[ 31661] = 1, -- Dragon's Breath
	-- Monk
	[198909] = 1, -- Song of Chi-ji -- FIXME: is this the right category( tooltip specifically says disorient, so I guessed here)
	[202274] = 1, -- Incendiary Brew -- FIXME: is this the right category( tooltip specifically says disorient, so I guessed here)
	-- Paladin
	[105421] = 1, -- Blinding Light -- FIXME: is this the right category? Its missing from blizzard's list
	-- Priest
	[  8122] = 1, -- Psychic Scream
	-- Rogue
	[  2094] = 1, -- Blind
	-- Warlock
	[  5782] = 1, -- Fear -- probably unused
	[118699] = 1, -- Fear -- new debuff ID since MoP
	[130616] = 1, -- Fear (with Glyph of Fear)
	[  5484] = 1, -- Howl of Terror (talent)
	[115268] = 1, -- Mesmerize (Shivarra)
	[  6358] = 1, -- Seduction (Succubus)
	-- Warrior
	[  5246] = 1, -- Intimidating Shout (main target)
	
	--[[ STUNS ]]--
	-- Death Knight
	-- Abomination's Might note: 207165 is the stun, but is never applied to players,
	-- so I haven't included it.
	[108194] = 4, -- Asphyxiate (talent for unholy)
	[221562] = 4, -- Asphyxiate (baseline for blood)
	[ 91800] = 4, -- Gnaw (Ghoul)
	[ 91797] = 4, -- Monstrous Blow (Dark Transformation Ghoul)
	[207171] = 4, -- Winter is Coming (Remorseless winter stun)
	-- Demon Hunter
	[179057] = 4, -- Chaos Nova
	[200166] = 4, -- Metamorphosis
	[205630] = 4, -- Illidan's Grasp, primary effect
	[208618] = 4, -- Illidan's Grasp, secondary effect
	[211881] = 4, -- Fel Eruption
	-- Druid
	[203123] = 4, -- Maim
	[  5211] = 4, -- Mighty Bash
	[163505] = 4, -- Rake (Stun from Prowl)
	-- Hunter
	[117526] = 4, -- Binding Shot
	[ 24394] = 4, -- Intimidation
	-- Mage

	-- Monk
	[119381] = 4, -- Leg Sweep
	-- Paladin
	[   853] = 4, -- Hammer of Justice
	-- Priest
	[200200] = 4, -- Holy word: Chastise
	[226943] = 4, -- Mind Bomb
	-- Rogue
	-- Shadowstrike note: 196958 is the stun, but it never applies to players,
	-- so I haven't included it.
	[  1833] = 4, -- Cheap Shot
	[   408] = 4, -- Kidney Shot
	[199804] = 4, -- Between the Eyes
	-- Shaman
	[118345] = 4, -- Pulverize (Primal Earth Elemental)
	[118905] = 4, -- Static Charge (Capacitor Totem)
	[204399] = 4, -- Earthfury (pvp talent)
	-- Warlock
	[ 89766] = 4, -- Axe Toss (Felguard)
	[ 30283] = 4, -- Shadowfury
	[ 22703] = 4, -- Summon Infernal
	-- Warrior
	[132168] = 4, -- Shockwave
	[132169] = 4, -- Storm Bolt
	-- Tauren
	[ 20549] = 4, -- War Stomp
	
	--[[ ROOTS ]]--
	-- Death Knight
	[ 96294] = 5, -- Chains of Ice (Chilblains Root)
	[204085] = 5, -- Deathchill (pvp talent)
	-- Druid
	[   339] = 5, -- Entangling Roots
	[102359] = 5, -- Mass Entanglement (talent)
	[ 45334] = 5, -- Immobilized (wild charge, bear form)
	-- Hunter
	[ 53148] = 5, -- Charge (Tenacity pet)
	[162480] = 5, -- Steel Trap
	[190927] = 5, -- Harpoon
	[200108] = 5, -- Ranger's Net
	[212638] = 5, -- tracker's net
	[201158] = 5, -- Super Sticky Tar (Expert Trapper, Hunter talent, Tar Trap effect)
	-- Mage
	[   122] = 5, -- Frost Nova
	[ 33395] = 5, -- Freeze (Water Elemental)
	-- [157997] = 5, -- Ice Nova -- since 6.1, ice nova doesn't DR with anything
	[228600] = 5, -- Glacial spike (talent)
	-- Monk
	[116706] = 5, -- Disable
	-- Priest
	-- Shaman
	[ 64695] = 5, -- Earthgrab Totem
	
	--[[ KNOCKBACK ]]--
	-- Death Knight
	--[108199] = "Knockback", -- Gorefiend's Grasp
	-- Druid
	--[102793] = "Knockback", -- Ursol's Vortex
	--[132469] = "Knockback", -- Typhoon
	-- Hunter
	-- Shaman
	--[ 51490] = "Knockback", -- Thunderstorm
	-- Warlock
	--[  6360] = "Knockback", -- Whiplash
	--[115770] = "Knockback", -- Fellash
	
		-- taunt
	-- Death Knight
	[ 56222] = 6, -- Dark Command
	[ 57603] = 6, -- Death Grip
	-- I have also seen this spellID used for the Death Grip debuff in MoP:
	[ 51399] = 6, -- Death Grip
	-- Demon Hunter
	[185245] = 6, -- Torment
	-- Druid
	[  6795] = 6, -- Growl
	-- Hunter
	[ 20736] = 6, -- Distracting Shot
	[ 2649] = 6, -- pet
	[ 204683] = 6, -- pet
	-- Monk
	[116189] = 6, -- Provoke
	[118635] = 6, -- Provoke via the Black Ox Statue -- NEED TESTING
	-- Paladin
	[ 62124] = 6, -- Reckoning
	-- Warlock
	[ 17735] = 6, -- Suffering (Voidwalker)
	-- Warrior
	[   355] = 6, -- Taunt
	-- Shaman
	[ 36213] = 6, -- Angered Earth (Earth Elemental)

}



local ADF_targethelplist = {};

local isMine = {};
local isBig = {};
local isBigReal = {};
local update_expir = nil;


--Overlay stuff
local unusedOverlayGlows = {};
local numOverlays = 0;
local function ADF_ActionButton_GetOverlayGlow()
	local overlay = tremove(unusedOverlayGlows);
	if ( not overlay ) then
		numOverlays = numOverlays + 1;
		overlay = CreateFrame("Frame", "ADF_ActionButtonOverlay"..numOverlays, UIParent, "ADF_ActionBarButtonSpellActivationAlert");
	end
	return overlay;
end

-- Shared between action button and MainMenuBarMicroButton
local function ADF_ShowOverlayGlow(button)
	if ( button.overlay ) then
		if ( button.overlay.animOut:IsPlaying() ) then
			button.overlay.animOut:Stop();
			button.overlay.animIn:Play();
		end
	else
		button.overlay = ADF_ActionButton_GetOverlayGlow();
		local frameWidth, frameHeight = button:GetSize();
		button.overlay:SetParent(button);
		button.overlay:ClearAllPoints();
		--Make the height/width available before the next frame:
		button.overlay:SetSize(frameWidth * 1.5, frameHeight * 1.5);
		button.overlay:SetPoint("TOPLEFT", button, "TOPLEFT", -frameWidth * 0.3, frameHeight * 0.3);
		button.overlay:SetPoint("BOTTOMRIGHT", button, "BOTTOMRIGHT", frameWidth * 0.3, -frameHeight * 0.3);
		button.overlay.animIn:Play();
	end
end

-- Shared between action button and MainMenuBarMicroButton
local function ADF_HideOverlayGlow(button)
	if ( button.overlay ) then
		if ( button.overlay.animIn:IsPlaying() ) then
			button.overlay.animIn:Stop();
		end
		if ( button:IsVisible() ) then
			button.overlay.animOut:Play();
		else
			button.overlay.animOut:OnFinished();	--We aren't shown anyway, so we'll instantly hide it.
		end
	end
end

ADF_ActionBarButtonSpellActivationAlertMixin = {};

function ADF_ActionBarButtonSpellActivationAlertMixin:OnUpdate(elapsed)
	AnimateTexCoords(self.ants, 256, 256, 48, 48, 22, elapsed, 0.01);
	local cooldown = self:GetParent().cooldown;
	-- we need some threshold to avoid dimming the glow during the gdc
	-- (using 1500 exactly seems risky, what if casting speed is slowed or something?)
	if(cooldown and cooldown:IsShown() and cooldown:GetCooldownDuration() > 3000) then
		self:SetAlpha(0.5);
	else
		self:SetAlpha(1.0);
	end
end

function ADF_ActionBarButtonSpellActivationAlertMixin:OnHide()
	if ( self.animOut:IsPlaying() ) then
		self.animOut:Stop();
		self.animOut:OnFinished();
	end
end

ADF_ActionBarOverlayGlowAnimInMixin = {};

function ADF_ActionBarOverlayGlowAnimInMixin:OnPlay()
	local frame = self:GetParent();
	local frameWidth, frameHeight = frame:GetSize();
	frame.spark:SetSize(frameWidth, frameHeight);
	frame.spark:SetAlpha(0.3);
	frame.innerGlow:SetSize(frameWidth / 2, frameHeight / 2);
	frame.innerGlow:SetAlpha(1.0);
	frame.innerGlowOver:SetAlpha(1.0);
	frame.outerGlow:SetSize(frameWidth * 2, frameHeight * 2);
	frame.outerGlow:SetAlpha(1.0);
	frame.outerGlowOver:SetAlpha(1.0);
	frame.ants:SetSize(frameWidth * 0.85, frameHeight * 0.85)
	frame.ants:SetAlpha(0);
	frame:Show();
end

function ADF_ActionBarOverlayGlowAnimInMixin:OnFinished()
	local frame = self:GetParent();
	local frameWidth, frameHeight = frame:GetSize();
	frame.spark:SetAlpha(0);
	frame.innerGlow:SetAlpha(0);
	frame.innerGlow:SetSize(frameWidth, frameHeight);
	frame.innerGlowOver:SetAlpha(0.0);
	frame.outerGlow:SetSize(frameWidth, frameHeight);
	frame.outerGlowOver:SetAlpha(0.0);
	frame.outerGlowOver:SetSize(frameWidth, frameHeight);
	frame.ants:SetAlpha(1.0);
end

ADF_ActionBarOverlayGlowAnimOutMixin = {};

function ADF_ActionBarOverlayGlowAnimOutMixin:OnFinished()
	local overlay = self:GetParent();
	local actionButton = overlay:GetParent();
	overlay:Hide();
	tinsert(unusedOverlayGlows, overlay);
	actionButton.overlay = nil;
end

local function ADF_UpdateDebuff(unit)

	local selfName;
	local numDebuffs = 1;
	local frame, frameName;
	local frameIcon, frameCount, frameCooldown;
	local name, icon, count, debuffType, duration, expirationTime, caster, isStealable, shouldConsolidate, spellId ;
	local color;
	local frameBorder;
	local maxIdx;
	local parent;
	local frametype;
	local filter = nil;
	local isBossDebuff = nil;


	if (unit == "target") then
		selfName = "ADF_TDEBUFF_";
		maxIdx = MAX_TARGET_DEBUFFS;
		parent = ADF_TARGET_DEBUFF;
	elseif (unit == "targethelp") then
		selfName = "ADF_TDEBUFF_";
		maxIdx = MAX_TARGET_DEBUFFS;
		parent = ADF_TARGET_DEBUFF;
	elseif (unit == "targethelp2") then
		selfName = "ADF_TDEBUFF_";
		maxIdx = MAX_TARGET_DEBUFFS;
		parent = ADF_TARGET_DEBUFF;
	elseif (unit == "player") then
		selfName = "ADF_PDEBUFF_";
		maxIdx = MAX_TARGET_DEBUFFS;
		parent = ADF_PLAYER_DEBUFF;
	else
		return;
	end

	frametype = selfName.."Button";
	isMine = {};

	local bBattle = false;

	local RTB_PVPType = GetZonePVPInfo();
	local discard, RTB_ZoneType = IsInInstance();
	local alert = false;

	if RTB_PVPType == "combat" or RTB_ZoneType == "pvp" then
		bBattle = true;
	end

	local dispel_debuff_name = {};

	if unit ~= "target" then

		i = 1;
		-- Dispel Debuff Check
		repeat
			filter = "RAID"
			name,  _, _, debuffType, _, _, _, _, _, spellId = UnitDebuff(unit, i, filter);
			if ( dispellableDebuffTypes[debuffType]) then
				dispel_debuff_name[spellId] = true;
			end
		
			i = i + 1;

		until (name == nil)

	end
		
	filter = nil;



	--for i = 1, maxIdx do
	i = 1;
	repeat
		local skip = false;
		local debuff;
		local candispel = false;

		isBig[i] = false;
	
		alert = false;

		if (unit == "target") then
			
			local filter = "";

			name, icon, count, debuffType, duration, expirationTime, caster, isStealable, shouldConsolidate, spellId, canApplyAura,isBossDebuff, casterIsPlayer, nameplateShowAll  = UnitDebuff("target", i, filter);

			if (icon == nil) then
				break;
			end
			
			skip = true;

			if (casterIsPlayer) then
		        skip = true;
		    end
	
			-- 내가 시전한 Debuff는 보이고
			if caster and PLAYER_UNITS[caster]  then
				skip = false;
			end

			if caster and ADF_Show_TargetDebuff and not UnitIsPlayer("target") and UnitIsUnit("target", caster) then
				skip = false;
			end
			
			-- 상대 가 Player 면 PVP Debuff 만 보임		
			--if (spellId and ADF_Show_PVPDebuff and ADF_PVPDebuffList[spellId]) then
			if (spellId and ADF_Show_PVPDebuff and nameplateShowAll) then

				isBig[i] = true;
				skip = false;
			end
			
			-- ACI 에서 보이는 Debuff 는 숨기고
			if ACI_Debuff_list and ACI_Debuff_list[name] then
				skip = true;
			end

			if b_showlist == true then
				skip = true;
				if ADF_ShowList[name] then
					skip = false;
				end
			end

			if skip == false and ADF_BlackList[name] then
				skip = true;
			end

		elseif (unit == "targethelp") then

			name,  icon, count, debuffType, duration, expirationTime, caster, isStealable, shouldConsolidate, spellId, canApplyAura,isBossDebuff,casterIsPlayer, nameplateShowAll  = UnitDebuff("target", i, filter);

			if (icon == nil) then
				break;
			end

			skip = false;
			
			if (casterIsPlayer) then
		        skip = true;
		    end

			-- 내가 시전한 Debuff는 보이고
			if PLAYER_UNITS[caster]  then
				skip = false;
			end

			if ADF_Show_ShowBossDebuff and isBossDebuff then
				skip = false;
				isBig[i] = true;
			end
			
			-- 상대 가 Player 면 PVP Debuff 만 보임		
			--if (spellId and ADF_Show_PVPDebuff and ADF_PVPDebuffList[spellId]) then
			if (spellId and ADF_Show_PVPDebuff and nameplateShowAll) then

				isBig[i] = true;
				skip = false;
			end

			if dispel_debuff_name[spellId] then
				isBig[i] = true;
				skip = false;
				candispel = true;
			end


			-- ACI 에서 보이는 Debuff 는 숨기고
			if ACI_Debuff_list and ACI_Debuff_list[name] then
				skip = true;
			end

			if b_showlist == true then
				skip = true;
				if ADF_ShowList[name] then
					skip = false;
				end
			end

			if skip == false and ADF_BlackList[name] then
				skip = true;
			end


		elseif (unit == "player") then
			local blIdx;
			name, icon, count, debuffType, duration, expirationTime, caster, isStealable, shouldConsolidate, spellId, canApplyAura, isBossDebuff, _, nameplateShowAll = UnitDebuff("player", i);


			skip = false;


			if (icon == nil) then
				break;
			end

			if duration > ADF_MAX_Cool then
				skip = true;
			end

			-- 내가 해제할 수 있는 Debuff는 보이기
			if dispel_debuff_name[spellId] then
				isBig[i] = true;
				skip = false;
				candispel = true;
			end

			-- 주요 PVP Debuff만 보이기
			--if (spellId and ADF_PVPDebuffList[spellId]) then
			if (spellId and nameplateShowAll) then

				isBig[i] = true;
				skip = false;
			end


			if isBossDebuff then
				skip = false;
				isBig[i] = true;
				alert = true;
			end

			-- ACI 에서 보이는 Debuff 면 숨기기 

			if ACI_Player_Debuff_list and skip == false and ACI_Player_Debuff_list[name] then
				skip = true;
			end

			if skip == false and ADF_BlackList[name] then
				skip = true;
			end

		end

	
		if (icon and skip == false) then

			if numDebuffs > ADF_MAX_DEBUFF_SHOW then
				break;
			end

			frameName = frametype..numDebuffs;

			frame = _G[frameName];

			isBigReal[numDebuffs] = isBig[i];


			if ( not frame ) then
				frame = CreateFrame("Button", frameName, parent, "asTargetDebuffFrameTemplate");
				frame:EnableMouse(false); 
				for _,r in next,{_G[frameName.."Cooldown"]:GetRegions()}	do 
					if r:GetObjectType()=="FontString" then 
						r:SetFont("Fonts\\2002.TTF",ADF_CooldownFontSize,"OUTLINE")
						r:SetPoint("TOPLEFT", -2, 2);
						break 
					end 
				end

				local font, size, flag = _G[frameName.."Count"]:GetFont()

				_G[frameName.."Count"]:SetFont(font, ADF_CountFontSize, "OUTLINE")
				_G[frameName.."Count"]:SetPoint("BOTTOMRIGHT", -2, 2);

			end

			-- set the icon
			frameIcon = _G[frameName.."Icon"];
			frameIcon:SetTexture(icon);
			frameIcon:SetAlpha(ADF_ALPHA);

			-- set the count
			frameCount = _G[frameName.."Count"];

			-- Handle cooldowns
			frameCooldown = _G[frameName.."Cooldown"];

			if isBig[i] then
				frame:SetWidth(ADF_SIZE_BIG);
				frame:SetHeight(ADF_SIZE_BIG);
			else
				frame:SetWidth(ADF_SIZE);
				frame:SetHeight(ADF_SIZE);
			end

		
			 if ( count > 1 ) then
				frameCount:SetText(count);
				frameCount:Show();
				frameCooldown:SetDrawSwipe(false);
			else
				frameCount:Hide();
				frameCooldown:SetDrawSwipe(true);
			end

			
			if ( duration > 0 ) then
				frameCooldown:Show();
				CooldownFrame_Set(frameCooldown, expirationTime - duration, duration, duration > 0, true);
				frameCooldown:SetHideCountdownNumbers(false);
			else
				frameCooldown:Hide();
			end

			-- set debuff type color
			if ( debuffType ) then
				color = DebuffTypeColor[debuffType];
			else
				color = DebuffTypeColor["none"];
			end

			if (unit ~= "player" and caster ~= nil  and not PLAYER_UNITS[caster]) then
				color = { r = 0.3, g = 0.3, b = 0.3 };
			end
		
			if candispel then
				color = { r = 1, g = 1, b = 1 };
			end

			frameBorder = _G[frameName.."Border"];
			frameBorder:SetVertexColor(color.r, color.g, color.b);
			frameBorder:SetAlpha(ADF_ALPHA);
					
			frame:ClearAllPoints();
			frame:Show();

			if (alert) then
				--print ("alert" );
				ADF_ShowOverlayGlow(frame);
			else
				ADF_HideOverlayGlow(frame);
			end

			numDebuffs = numDebuffs + 1;
		end
		i = i+1
	until (name == nil)

	if (unit == "target") then
		for i=1, numDebuffs - 1 do
			if (isBigReal[i]) then
				ADF_UpdateDebuffAnchor(frametype, i, i- 1, ADF_SIZE_BIG, 4, true, parent);
			else
				ADF_UpdateDebuffAnchor(frametype, i, i- 1, ADF_SIZE, 4, true, parent);
			end
		end
	elseif (unit == "targethelp") then
		for i=1, numDebuffs - 1 do

			if (isBigReal[i]) then
				ADF_UpdateDebuffAnchor(frametype, i, i- 1, ADF_SIZE_BIG, 4, true, parent);
			else
				ADF_UpdateDebuffAnchor(frametype, i, i - 1, ADF_SIZE, 4, true, parent);
			end
		end
	elseif (unit == "player")  then
		for i=1, numDebuffs - 1 do
			if (isBigReal[i]) then
				ADF_UpdateDebuffAnchor(frametype, i, i- 1, ADF_SIZE_BIG, 4, false, parent);
			else
				ADF_UpdateDebuffAnchor(frametype, i, i - 1, ADF_SIZE, 4, false, parent);
			end
		end
	end

	for i = numDebuffs, maxIdx do
		frameName = frametype..i;
		frame = _G[frameName];

		if ( frame ) then
			frame:Hide();	
		end
	end
end

function ADF_UpdateDebuffAnchor(debuffName, index, anchorIndex, size, offsetX, right, parent)

	local buff = _G[debuffName..index];
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
		buff:SetPoint(point1, parent, point2, 0, 0);
	else
		buff:SetPoint(point1, _G[debuffName..(index-1)], point3, offsetX, 0);
	end

	-- Resize
	buff:SetWidth(size);
	buff:SetHeight(size);
	local debuffFrame =_G[debuffName..index.."Border"];
	debuffFrame:SetWidth(size+2);
	debuffFrame:SetHeight(size+2);
end


function ADF_ClearFrame()
	
	local selfName = "ADF_TDEBUFF_";

	for i = 1, MAX_TARGET_DEBUFFS do
		frameName = selfName.."Debuff"..i;
		frame = _G[frameName];

		if ( frame ) then
			frame:Hide();	
		end
	end
end

function ADF_InitShowList()

	local localizedClass, englishClass = UnitClass("player")
	local spec = GetSpecialization();
	local listname = "ADF_ShowList";
	if spec then
		listname = "ADF_ShowList" .. "_" .. englishClass .. "_" .. spec;
	end

	ADF_ShowList = _G[listname];

	b_showlist = false;

	if (ADF_ShowList and #ADF_ShowList) then
	--	ChatFrame1:AddMessage("[ADF] ".. listname .. "을 Load 합니다.");
		b_showlist = true;
	else
	--	ChatFrame1:AddMessage("[ADF] Show List를 비활성화 합니다..");
	end
end


function ADF_OnEvent(self, event, arg1)
	if (event == "PLAYER_TARGET_CHANGED") then
		ADF_ClearFrame();
		
		if UnitCanAssist("player", "target") then
			ADF_UpdateDebuff("targethelp");
		else
			ADF_UpdateDebuff("target");
		end

	elseif (event == "ACTIONBAR_UPDATE_COOLDOWN") and UnitExists("target") then

		if UnitCanAssist("player", "target") then
			ADF_UpdateDebuff("targethelp");
		else
			ADF_UpdateDebuff("target");
		end

	elseif (event == "UNIT_AURA" and arg1 == "player") then
		ADF_UpdateDebuff("player");
	elseif event == "PLAYER_ENTERING_WORLD" then
		ADF_InitShowList();
	elseif event == "ACTIVE_TALENT_GROUP_CHANGED" then
		ADF_InitShowList();
	elseif event == "PLAYER_REGEN_DISABLED" then
		ADF:SetAlpha(ADF_AlphaCombat);
	elseif event == "PLAYER_REGEN_ENABLED" then
		ADF:SetAlpha(ADF_AlphaNormal);

	end
end


local function ADF_OnUpdate()

	if UnitCanAssist("player", "target") then
		ADF_UpdateDebuff("targethelp");
	else
		ADF_UpdateDebuff("target");
	end
end



function ADF_Init()

	ADF = CreateFrame("Frame", nil, UIParent)

	ADF:SetPoint("CENTER", 0, 0)
	ADF:SetWidth(1)
	ADF:SetHeight(1)
	ADF:SetScale(1)
	ADF:SetAlpha(ADF_AlphaNormal);
	ADF:Show()

	ADF_TARGET_DEBUFF = CreateFrame("Frame", "ADF_TARGET_DEBUFF", ADF)

	ADF_TARGET_DEBUFF:SetPoint("CENTER", ADF_TARGET_DEBUFF_X, ADF_TARGET_DEBUFF_Y)
	ADF_TARGET_DEBUFF:SetWidth(1)
	ADF_TARGET_DEBUFF:SetHeight(1)
	ADF_TARGET_DEBUFF:SetScale(1)
	ADF_TARGET_DEBUFF:Show()

	ADF_PLAYER_DEBUFF = CreateFrame("Frame", "ADF_PLAYER_DEBUFF", ADF)

	ADF_PLAYER_DEBUFF:SetPoint("CENTER", ADF_PLAYER_DEBUFF_X, ADF_PLAYER_DEBUFF_Y)
	ADF_PLAYER_DEBUFF:SetWidth(1)
	ADF_PLAYER_DEBUFF:SetHeight(1)
	ADF_PLAYER_DEBUFF:SetScale(1)
	ADF_PLAYER_DEBUFF:Show()

	ADF:RegisterEvent("PLAYER_TARGET_CHANGED")
	ADF:RegisterUnitEvent("UNIT_AURA", "player")
	ADF:RegisterEvent("PLAYER_ENTERING_WORLD");
	ADF:RegisterEvent("ACTIVE_TALENT_GROUP_CHANGED");
	ADF:RegisterEvent("PLAYER_REGEN_DISABLED");
	ADF:RegisterEvent("PLAYER_REGEN_ENABLED");
	ADF:RegisterEvent("ACTIONBAR_UPDATE_COOLDOWN");


	ADF:SetScript("OnEvent", ADF_OnEvent)
	C_Timer.NewTicker(ADF_RefreshRate, ADF_OnUpdate);
end

ADF_Init();