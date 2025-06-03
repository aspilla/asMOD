---설정부
local AAM_UpdateRate = 0.2 -- Check할 주기
local AAM_MaxMark = 7      -- 최대 징표 X까지 찍도록 설정

--[[

1 = Yellow 4-point Star
2 = Orange Circle
3 = Purple Diamond
4 = Green Triangle
5 = White Crescent Moon
6 = Blue Square
7 = Red "X" Cross
8 = White Skull

]]

local NPCTable = {


	--내부전쟁 시즌2
	--Cinderbrew Meadery
	--[214920] = 0, -- Tasting Room Attendant
    [218671] = 2, -- Venture Co. Pyromaniac
    --[210269] = 0, -- Hired Muscle
    --[220946] = 0, -- Venture Co. Honey Harvester
    --[210271] = 0, -- BOSS: Brewmaster Aldryr
    --[210267] = 0, -- BOSS: I'pa
    [210264] = 2, -- Bee Wrangler
    --[218002] = 0, -- BOSS: Benk Buzzbee
    --[214697] = 0, -- Chef Chewie
    --[218865] = 0, -- Bee-let
    --[219667] = 0, -- Flamethrower
    --[219415] = 0, -- Cooking Pot
    [214673] = 2, -- Flavor Scientist
    [222964] = 2, -- Flavor Scientist
    --[214668] = 0, -- Venture Co. Patron
    --[210265] = 0, -- Worker Bee
    --[220060] = 0, -- Taste Tester
    --[218016] = 0, -- Ravenous Cinderbee
    --[223423] = 0, -- Careless Hopgoblin
    [220141] = 2, -- Royal Jelly Purveyor
    --[210270] = 0, -- Brew Drop
    --[219301] = 0, -- Brew Drop
    --[214661] = 0, -- Unknown NPC

	--Darkflame Cleft
	--[210810] = 0, -- Menial Laborer
    --[211121] = 0, -- Rank Overseer
    --[211977] = 0, -- Pack Mole
    --[208450] = 0, -- Wandering Candle
    [223770] = 2, -- Blazing Fiend
    [223772] = 2, -- Blazing Fiend
    [213913] = 2, -- Kobold Flametender
    [223773] = 2, -- Blazing Fiend
    [210812] = 2, -- Royal Wicklighter
    [212412] = 2, -- Sootsnout
    [223775] = 2, -- Blazing Fiend
    [223776] = 2, -- Blazing Fiend
    --[212411] = 0, -- Torchsnarl
    [223777] = 2, -- Blazing Fiend
    [210818] = 2, -- Lowly Moleherd
    --[212383] = 0, -- Kobold Taskworker
    --[208457] = 0, -- Skittering Darkness
    --[208743] = 0, -- BOSS: Blazikon
    [208745] = 2, -- BOSS: The Candle King
    [208456] = 2, -- Shuffling Horror
    [208747] = 2, -- BOSS: The Darkness
    [220815] = 2, -- Blazing Fiend
    --[210539] = 0, -- Corridor Creeper
    --[210153] = 0, -- BOSS: Ol' Waxbeard
    [223774] = 2, -- Blazing Fiend
    [211228] = 2, -- Blazing Fiend
    [213008] = 2, -- BOSS ADD: Wriggling Darkspawn

	--Priory of the Sacred Flame
	[206705] = 1, -- Arathi Footman
    --[206696] = 0, -- Arathi Knight
    --[212838] = 0, -- Arathi Neophyte
    [211290] = 2, -- Elaena Emberlanz
    [221760] = 2, -- Risen Mage
    --[211291] = 0, -- Sergeant Shaynemail
    [206698] = 2, -- Fanatical Conjuror
    --[217658] = 0, -- Sir Braunpyke
    --[209747] = 0, -- Arathi Neophyte
    --[206694] = 0, -- Fervent Sharpshooter
    --[206699] = 0, -- War Lynx
    --[207949] = 0, -- Zealous Templar
    --[212831] = 0, -- Forge Master Damian
    [207946] = 2, -- BOSS: Captain Dailcry
    --[207943] = 0, -- Arathi Neophyte
    --[206704] = 0, -- Ardent Paladin
    --[212826] = 0, -- Guard Captain Suleyman
    [207940] = 2, -- BOSS: Prioress Murrpray
    --[211140] = 0, -- Arathi Neophyte
    --[212827] = 0, -- High Priest Aemya
    --[555555] = 0, -- Priory of the Sacred Flame
    [206697] = 2, -- Devout Priest
    --[206710] = 0, -- Lightspawn
    [207939] = 2, -- BOSS: Baron Braunpyke
    [211289] = 2, -- Taener Duelmal
    --[212835] = 0, -- Risen Footman

	--The Rookery
	--[207207] = 0, -- BOSS: Skardyn Monstrosity
    --[209230] = 0, -- BOSS: Kyrioss
    --[214419] = 0, -- Void-Cursed Crusher
    --[209801] = 0, -- Quartermaster Koratite
    [207198] = 2, -- Cursed Thunderer
    --[212786] = 0, -- Voidrider
    [214439] = 2, -- Corrupted Oracle
    --[211260] = 0, -- Stormrider Vokmar
    --[214421] = 0, -- Coalescing Void Diffuser
    [207186] = 2, -- Unruly Stormrook
    --[219066] = 0, -- Afflicted Civilian
    --[207205] = 0, -- BOSS: Stormguard Gorren
    --[207197] = 0, -- Cursed Rookguard
    [207199] = 2, -- Cursed Rooktender
    --[212739] = 0, -- Radiating Voidstone
    [212793] = 2, -- Void Ascendant

	--Operation: Floodgate
	--[230740] = 0, -- Shreddinator 3000
    --[228144] = 0, -- Darkfuse Soldier
    --[231014] = 0, -- Loaderbot
    [230748] = 2, -- Darkfuse Bloodwarper
    --[231197] = 0, -- Bubbles
    --[231325] = 0, -- Darkfuse Jumpstarter
    --[231385] = 0, -- Darkfuse Inspector
    --[226398] = 0, -- BOSS: Big M.O.M.M.A.
    --[229250] = 0, -- Venture Co. Contractor
    [229686] = 2, -- Venture Co. Surveyor
    --[226403] = 0, -- BOSS: Keeza Quickfuse
    --[226396] = 0, -- BOSS: Swampface
    [231312] = 2, -- Venture Co. Electrician
    --[226404] = 0, -- BOSS: Geezle Gigazap
    [229069] = 2, -- Mechadrone Sniper
    [229252] = 2, -- Darkfuse Hyena
    --[231497] = 0, -- Bombshell Crab
    --[231380] = 0, -- Undercrawler
    --[227145] = 0, -- Waterworks Crocolisk
    [231496] = 2, -- Venture Co. Diver
    --[229212] = 0, -- Darkfuse Demolitionist
    --[229251] = 0, -- Venture Co. Architect
    [228424] = 2, -- Darkfuse Mechadrone
    --[226402] = 0, -- BOSS: Bront
    [231223] = 2, -- Disturbed Kelp

	--Theater of Pain
	[174197] = 2, -- Battlefield Ritualist
    --[170838] = 0, -- Unyielding Contender
    --[164451] = 0, -- BOSS: Dessia the Decapitator
    --[164510] = 0, -- Shambling Arbalest
    --[167998] = 0, -- Portal Guardian
    [170882] = 2, -- Bone Magus
    --[167994] = 0, -- Ossified Conscript
    [160495] = 2, -- Maniacal Soulbinder
    [174210] = 2, -- Blighted Sludge-Spewer
    [164463] = 2, -- BOSS: Paceran the Virulent
    --[167538] = 0, -- Dokigg the Brutalizer
    [169893] = 2, -- Nefarious Darkspeaker
    --[167534] = 0, -- Rek the Hardened
    [162309] = 2, -- BOSS: Kul'tharok
    --[167536] = 0, -- Harugia the Bloodthirsty
    --[163089] = 0, -- Disgusting Refuse
    --[170850] = 0, -- Raging Bloodhorn
    [164461] = 2, -- BOSS: Sathel the Accursed
    [164506] = 2, -- Ancient Captain
    --[169927] = 0, -- Putrid Butcher
    --[162763] = 0, -- Soulforged Bonereaver
    --[163086] = 0, -- Rancid Gasbag
    --[167533] = 0, -- Advent Nevermore
    --[162317] = 0, -- BOSS: Gorechop
    --[165946] = 0, -- BOSS: Mordretha, the Endless Empress
    --[164464] = 0, -- Xira the Underhanded
    --[162329] = 0, -- BOSS: Xav the Unfallen
    --[162744] = 0, -- Nekthara the Mangler
    [170690] = 2, -- Diseased Horror
    --[167532] = 0, -- Heavin the Breaker
    [169875] = 2, -- Shackled Soul

	--Mechagon
	--[151476] = 0, -- Blastatron X-80
    --[151649] = 0, -- Defense Bot Mk I
    --[144299] = 0, -- Workshop Defender
    --[144298] = 0, -- Defense Bot Mk III
    --[151658] = 0, -- Strider Tonk
    --[144244] = 0, -- BOSS: The Platinum Pummeler
    --[150396] = 0, -- BOSS: Aerial Unit R-21/X
    --[145185] = 0, -- BOSS: Gnomercy 4.U.
    [144295] = 2, -- Mechagon Mechanic
    --[151773] = 0, -- Junkyard D.0.G.
    --[144303] = 0, -- G.U.A.R.D.
    --[236033] = 0, -- Metal Gunk
    --[144293] = 0, -- Waste Processing Unit
    [144294] = 2, -- Mechagon Tinkerer
    --[144248] = 0, -- BOSS: Head Machinist Sparkflux
    --[144301] = 0, -- Living Waste
    --[144249] = 0, -- BOSS: Omega Buster
    --[144296] = 0, -- Spider Tank
    [151657] = 2, -- Bomb Tonk
    --[144246] = 0, -- BOSS: K.U.-J.0.
    --[151659] = 0, -- Rocket Tonk

	--The MOTHERLODE!!
	[133432] = 2, -- Venture Co. Alchemist
    --[137716] = 0, -- Bottom Feeder
    --[132056] = 0, -- Venture Co. Skyscorcher
    --[138061] = 0, -- Venture Co. Longshoreman
    --[138064] = 0, -- Posh Vacationer
    --[130436] = 0, -- Off-Duty Laborer
    [136470] = 2, -- Refreshment Vendor
    --[130488] = 0, -- Mech Jockey
    --[130435] = 0, -- Addled Thug
    --[136006] = 0, -- Rowdy Reveler
    --[129214] = 0, -- BOSS: Coin-Operated Crowd Pummeler
    --[130437] = 0, -- Mine Rat
    --[136643] = 0, -- Azerite Extractor
    --[134012] = 0, -- Taskmaster Askari
    --[133430] = 0, -- Venture Co. Mastermind
    --[133963] = 0, -- Test Subject
    --[137029] = 0, -- Ordnance Specialist
    --[129246] = 0, -- Azerite Footbomb
    --[133436] = 0, -- Venture Co. Skyscorcher
    --[137940] = 0, -- Safety Shark
    --[129227] = 0, -- BOSS: Azerokk
    --[133345] = 0, -- Feckless Assistant
    --[129231] = 0, -- BOSS: Rixxa Fluxflame
    --[129232] = 0, -- BOSS: Mogul Razdunk
    [134232] = 2, -- Hired Assassin
    --[136139] = 0, -- Mechanized Peacekeeper
    [130661] = 2, -- Venture Co. Earthshaper
    --[130653] = 0, -- Wanton Sapper
    [134005] = 2, -- Shalebiter
    --[129802] = 0, -- Earthrager
    --[136934] = 0, -- Weapons Tester
    --[133593] = 0, -- Expert Technician
    --[130485] = 0, -- Mechanized Peacekeeper
    --[144286] = 0, -- Asset Manager
    --[141303] = 0, -- B.O.O.M.B.A.
    --[133482] = 0, -- Crawler Mine
    --[137713] = 0, -- Big Money Crab
    [130635] = 2, -- Stonefury
    --[138369] = 0, -- Footbomb Hooligan
    --[133463] = 0, -- Venture Co. War Machine
	

	-- 내부전쟁 시즌 1
	[128969] = 2,
	[129366] = 2,
	[129370] = 2,
	[136297] = 2,
	[137517] = 2,
	[137521] = 2,
	[141284] = 2,
	[141285] = 1,
	[163121] = 1,
	[163126] = 2,
	[163618] = 2,
	[164414] = 2,
	[165137] = 2,
	[165222] = 2,
	[165824] = 2,
	[165919] = 2,
	[166302] = 2,
	[173016] = 2,
	[173044] = 2,
	[164921] = 2,
	[166275] = 0,
	[166299] = 2,
	[166301] = 1,
	[167111] = 2,
	[212389] = 2,
	[212453] = 2,
	[213338] = 2,
	[214066] = 2,
	[214350] = 2,
	[221979] = 2,
	[224962] = 2,
	[216293] = 2,
	[216340] = 2,
	[216364] = 2,
	[220599] = 2,
	[223253] = 2,
	[216326] = 2,
	[216339] = 2,
	[220195] = 2,
	[220196] = 2,
	[221102] = 2,
	[223844] = 2,
	[224219] = 2,
	[224271] = 2,
	[40167] = 2,
	[210966] = 2,
	[213892] = 2,
	[213893] = 2,
	[214762] = 2,



	-- 용군단 시즌 4 https://wago.io/3bViaBtT1
--[[
	[196203] = 2,
	[192796] = 2,
	[194894] = 2,
	[195878] = 2,
	[195847] = 2,
	[195119] = 2,

	[185508] = 1, --발톱 싸움꾼

	-- 용군단 시즌 3 여명 (https://wago.io/3bViaBtT1)

	[100486] = 2,
	[100527] = 2,
	[101991] = 2,
	[102788] = 2,
	[122969] = 2,
	[122971] = 0,
	[122972] = 2,
	[122973] = 2,
	[122984] = 0,
	[125977] = 2,
	[127879] = 2,
	[128434] = 2,
	[129553] = 2,
	[131586] = 2,
	[131587] = 2,
	[131666] = 0,
	[131670] = 2,
	[131677] = 2,
	[131685] = 2,
	[131812] = 2,
	[131818] = 0,
	[131819] = 2,
	[131850] = 2,
	[131858] = 0,
	[132126] = 0,
	[134024] = 0, -- 탐욕스러운 구더기, 징표 안찍음
	[135365] = 2,
	[135474] = 2,
	[135552] = 0,
	[199748] = 2,
	[201223] = 2,
	[204560] = 0,
	[204918] = 2,
	[205158] = 2,
	[205212] = 2,
	[205337] = 2,
	[205363] = 2,
	[205384] = 2,
	[205408] = 0,
	[205691] = 2,
	[205727] = 2,
	[206064] = 0,
	[206066] = 0,
	[206074] = 2,
	[206140] = 2,
	[212775] = 2,
	[213806] = 2,
	[214209] = 2,
	[40634] = 2,
	[40925] = 0,
	[40943] = 2,
	[44404] = 2,
	[81819] = 2,
	[81820] = 2,
	[81985] = 0,
	[83892] = 2,
	[83893] = 2,
	[84957] = 2,
	[84989] = 2,
	[84990] = 2,
	[95766] = 0,
	[95769] = 2,
	[95771] = 2,
	[98280] = 2,
	[98370] = 2,
	[98521] = 2,
	[98691] = 2,
	[98810] = 0,
	[98813] = 2,
	[99366] = 2,

	-- 용군단 시즌 2 (https://wago.io/3bViaBtT1)
	[102232] = 2,
	[126919] = 2,
	[127111] = 0,
	[128551] = 0,
	[129527] = 2,
	[129529] = 2,
	[129547] = 0,
	[129559] = 2,
	[129600] = 2,
	[129788] = 2,
	[130012] = 2,
	[130909] = 2,
	[131436] = 0,
	[131492] = 2,
	[133685] = 2,
	[133835] = 0,
	[133836] = 0,
	[133870] = 2,
	[133912] = 2,
	[134284] = 2,
	[138187] = 2,
	[184022] = 2,
	[184023] = 0,
	[184132] = 2,
	[184301] = 2,
	[184319] = 0,
	[184580] = 0,
	[185528] = 2,
	[185656] = 2,
	[186125] = 1,
	[186191] = 2,
	[186208] = 2,
	[186220] = 2,
	[186226] = 2,
	[186229] = 2,
	[186246] = 2,
	[186420] = 2,
	[186658] = 2,
	[189235] = 0,
	[189247] = 0,
	[189265] = 2,
	[189299] = 2,
	[189363] = 0,
	[189464] = 2,
	[189470] = 0,
	[189531] = 2,
	[190340] = 2,
	[190342] = 2,
	[190345] = 0,
	[190362] = 2,
	[190368] = 2,
	[190373] = 2,
	[190377] = 2,
	[190405] = 2,
	[190407] = 0,
	[192788] = 2,
	[193352] = 0,
	[193799] = 0,
	[193944] = 2,
	[195135] = 2,
	[196043] = 2,
	[199037] = 2,
	[45477] = 0,
	[45704] = 2,
	[45912] = 2,
	[45915] = 0,
	[45922] = 2,
	[45924] = 0,
	[45928] = 2,
	[45930] = 0,
	[45935] = 2,
	[90998] = 2,
	[91000] = 0,
	[91001] = 0,
	[91006] = 2,
	[92538] = 2,
	-- 용군단 시즌1

	[56448] = 2,
	[200137] = 2,
	[200126] = 2,
	[59555] = 2,
	[59552] = 2,
	[59546] = 2,
	[76104] = 2,
	[75459] = 2,
	[75713] = 2,
	[76446] = 2,
	[77700] = 2,
	[75506] = 2,
	[104217] = 2,
	[104247] = 2,
	[104246] = 2,
	[104270] = 2,
	[104300] = 2,
	[105715] = 2,
	[97202] = 2,
	[102019] = 2,
	[95834] = 2,
	[97197] = 2,
	[96664] = 2,
	[95842] = 2,
	[97081] = 2,
	[95843] = 2,
	[97083] = 2,
	[97084] = 2,
	[196202] = 2,
	[192333] = 2,
	[196548] = 2,
	[196798] = 2,
	[196045] = 2,
	[196576] = 2,
	[197905] = 2,
	[196044] = 2,
	[186339] = 2,
	[193462] = 2,
	[199717] = 2,
	[192800] = 2,
	[191847] = 2,
	[190294] = 2,
	[199719] = 2,
	[195696] = 2,
	[195877] = 2,
	[195928] = 2,
	[195927] = 2,
	[195930] = 2,
	[195929] = 2,
	[195265] = 2,
	[194317] = 2,
	[194315] = 2,
	[194316] = 2,
	[195842] = 2,
	[195851] = 2,
	[186741] = 2,
	[196115] = 2,
	[191164] = 2,
	[196102] = 2,
	[190187] = 2,
	[187155] = 2,
	[187154] = 2,
	[188252] = 2,
	[189886] = 2,
	[197985] = 2,
	[188067] = 2,
	[187969] = 2,
	[197535] = 2,
	[197509] = 2,
	[190207] = 2,
	[190206] = 2,
	[198047] = 2,
	]]

};

asAutoMarkerF = {};

asAutoMarkerF.IsAutoMarkerMob = function(unit)
	local guid = UnitGUID(unit);
	if guid then
		local npcID = select(6, strsplit("-", guid));
		npcID = tonumber(npcID);

		if NPCTable[npcID] and NPCTable[npcID] > 0 then
			return NPCTable[npcID];
		end
	end

	return 0;
end

local needtowork = false;

local function isAttackable(unit)
	local reaction = UnitReaction("player", unit);
	if reaction and reaction <= 4 then
		return true;
	end
	return false;
end

local curr_mark = 1;
local tmp = {};
local abledMarks = { true, true, true, true, true, true, true, true };

local function CheckPartyMarks()
	local unit = "player";
	local mark = GetRaidTargetIndex(unit);

	if mark ~= nil and mark <= AAM_MaxMark then
		abledMarks[mark] = false;
	end

	for i = 0, GetNumGroupMembers() do
		local unit = "party" .. i;
		local mark = GetRaidTargetIndex(unit);

		if mark ~= nil and mark <= AAM_MaxMark then
			abledMarks[mark] = false;
		end
	end
end

local function UpdateMarks(nameplate)
	local unit = "mouseover"

	if nameplate then
		if not nameplate or nameplate:IsForbidden() then
			return false;
		end

		unit = nameplate.namePlateUnitToken;
	end

	local status = UnitThreatSituation("player", unit);

	if (unit == "mouseover" or (unit and status and status > 0)) and isAttackable(unit) and not UnitIsDead(unit) then
		local guid = UnitGUID(unit);
		if asAutoMarkerF.IsAutoMarkerMob(unit) > 1 and guid then
			while (curr_mark <= AAM_MaxMark) do
				if abledMarks[curr_mark] then
					break;
				else
					curr_mark = curr_mark + 1;
				end
			end

			if tmp[guid] == nil and curr_mark <= AAM_MaxMark then
				SetRaidTarget(unit, curr_mark);
				tmp[guid] = curr_mark;
				abledMarks[curr_mark] = false;
				curr_mark = curr_mark + 1;
			end
		end
	end
end

local function AAM_OnUpdate()
	if not needtowork then
		return;
	end

	curr_mark = 1;

	CheckPartyMarks();

	UpdateMarks();

	for _, v in pairs(C_NamePlate.GetNamePlates(issecure())) do
		local nameplate = v;
		if (nameplate) then
			UpdateMarks(nameplate);
		end
	end
end



local function AAM_OnEvent(self, event, ...)
	if event == "PLAYER_ENTERING_WORLD" or event == "GROUP_JOINED" or event == "GROUP_ROSTER_UPDATE" or event == "PLAYER_ROLES_ASSIGNED" then
		needtowork = false;
		local inInstance, instanceType = IsInInstance();
		local assignedRole = UnitGroupRolesAssigned("player");

		if (inInstance and instanceType == "party") and (assignedRole and assignedRole == "TANK") then
			needtowork = true;
			AAM:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED");
			AAM:RegisterEvent("PLAYER_REGEN_ENABLED");
			AAM:RegisterEvent("UPDATE_MOUSEOVER_UNIT");
		else
			AAM:UnregisterEvent("COMBAT_LOG_EVENT_UNFILTERED");
			AAM:UnregisterEvent("PLAYER_REGEN_ENABLED");
			AAM:UnregisterEvent("UPDATE_MOUSEOVER_UNIT");
		end

		abledMarks = { true, true, true, true, true, true, true, true };
		tmp = {};
	elseif event == "PLAYER_REGEN_ENABLED" then
		abledMarks = { true, true, true, true, true, true, true, true };
		tmp = {};
	elseif event == "UPDATE_MOUSEOVER_UNIT" then
		AAM_OnUpdate();
	elseif (event == "COMBAT_LOG_EVENT_UNFILTERED") then
		local eventData = { CombatLogGetCurrentEventInfo() };
		local logEvent = eventData[2];
		local unitGUID = eventData[8];
		if ((logEvent == "UNIT_DIED") or (logEvent == "UNIT_DESTROYED")) then
			if tmp[unitGUID] then
				local mark = tmp[unitGUID];

				if mark <= AAM_MaxMark then
					abledMarks[mark] = true;
				end
				tmp[unitGUID] = nil;
			end
		end
	end
end


local function initAddon()
	AAM = CreateFrame("Frame", nil, UIParent);
	AAM:RegisterEvent("PLAYER_ENTERING_WORLD");
	AAM:RegisterEvent("GROUP_JOINED");
	AAM:RegisterEvent("GROUP_ROSTER_UPDATE");
	AAM:RegisterEvent("PLAYER_ROLES_ASSIGNED");
	AAM:SetScript("OnEvent", AAM_OnEvent)
	--주기적으로 Callback
	C_Timer.NewTicker(AAM_UpdateRate, AAM_OnUpdate);
end
initAddon();
