local _, ns = ...

ADS_OPTION_DRUID_2 = {
	buff   = {
		tigersFury = 5217,
		bloodtalons = 145152,
		prowl = 5215,
		incarnProwl = 102547,
		shadowmeld = 58984,
		suddenAmbush = 391974,
		suddenAmbushConduit = 340698,			
		clearcasting = 135700,
	},

	debuff = {
		rake = 155722,
		rip = 1079,
		thrash = 405233,
		moonfire = 155625,
	},

	talent = {		
		bloodtalons = 319439,		
		momentOfClarity = 236068,
		carnivorousInstinct = 390902,
		tigersTenacity = 391872,
	},
};

ADS_OPTION_ROGUE_1 = {
	buff   = {
		improvegarrote = 392401,
		improvegarroteS = 392403,
	},

	debuff = {
		garrote = 703,
	},

	talent = {
		improvegarrote = 381632,
	},
};

local buff = {};

local debuff = {};

local snapshotDebuffs = {};
--tInvert(debuff)

local talent = {};


local talents = {};

local function loadTraits()
	talents = {}

	-- traits
	local configId = C_ClassTalents.GetActiveConfigID()
	if configId then
		local config = C_Traits.GetConfigInfo(configId)
		if config then
			for _, treeId in ipairs(config.treeIDs) do
				local nodeIds = C_Traits.GetTreeNodes(treeId)
				for _, nodeId in ipairs(nodeIds) do
					local node = C_Traits.GetNodeInfo(configId, nodeId)
					if node and node.activeEntry then
						local entry = C_Traits.GetEntryInfo(configId, node.activeEntry.entryID)
						if entry.definitionID then
							local definition = C_Traits.GetDefinitionInfo(entry.definitionID)
							if definition.spellID then
								talents[definition.spellID] = node.activeEntry.rank
								--print ("Trait", definition.spellID, node.activeEntry.rank)
							end
						end
					end
				end
			end
		end
	end

	-- conduits don't stack
	local carnivourousInstinct = 340705 -- usable in SL
	if C_SpellBook.IsSpellKnown(carnivourousInstinct) and C_Spell.IsSpellUsable(carnivourousInstinct) then
		local talentedRank = talents[talent.carnivorousInstinct] or 0
		talents[talent.carnivorousInstinct] = max(1, talentedRank)
	end
end

local currentAuras = {};
local snapshots = {};
local modifiers = {};
local cached = {};
local damage_func;
local modifiers_func;

local function updateAuras()
	cached = {};
	for _, spellId in pairs(buff) do
		local aura = C_UnitAuras.GetPlayerAuraBySpellID(spellId)
		if aura then
			currentAuras[spellId] = true;
		else
			currentAuras[spellId] = false;
		end
	end
end

local function rank(talentSpellId)
	return talents[talentSpellId] or 0
end

function ns.getModifiersFeral()
	modifiers = {
		tigersFury      = 1.15 +
			(rank(talent.carnivorousInstinct) * 0.06) +
			(rank(talent.tigersTenacity) * 0.10),
		bloodtalons     = 1 + (rank(talent.bloodtalons) * 0.25),
		momentOfClarity = 1 + (rank(talent.momentOfClarity) * 0.15),
		stealth         = 1.60,
	};

	return modifiers;
end

function ns.getCurrentDamageFeral(spellId)
	if cached[spellId] then
		return cached[spellId];
	end

	local total = 1;
	local tigersFury = 1;
	local stealth = 1;
	local bloodtalons = 1;
	local momentOfClarity = 1;

	if debuff.rake == spellId then
		if currentAuras[buff.tigersFury] then
			tigersFury = modifiers.tigersFury
		end
		if currentAuras[buff.suddenAmbush]
			or currentAuras[buff.incarnProwl]
			or currentAuras[buff.prowl]
			or currentAuras[buff.shadowmeld]
			or currentAuras[buff.suddenAmbushConduit]
		then
			stealth = modifiers.stealth
		end
		total = tigersFury * stealth
	elseif debuff.rip == spellId then
		if currentAuras[buff.tigersFury] then
			tigersFury = modifiers.tigersFury
		end
		if currentAuras[buff.bloodtalons] then
			bloodtalons = modifiers.bloodtalons
		end
		total = tigersFury * bloodtalons
	elseif debuff.thrash == spellId then
		if currentAuras[buff.tigersFury] then
			tigersFury = modifiers.tigersFury
		end
		if currentAuras[buff.clearcasting] then
			momentOfClarity = modifiers.momentOfClarity
		end
		total = tigersFury * momentOfClarity
	elseif debuff.moonfire == spellId then
		if currentAuras[buff.tigersFury] then
			tigersFury = modifiers.tigersFury
		end
		total = tigersFury
	end

	cached[spellId] = total;
	return total;
end

function ns.getCurrentDamageAssasin(spellId)
	if cached[spellId] then
		return cached[spellId];
	end

	local total = 1;

	if debuff.garrote == spellId then
		if currentAuras[buff.improvegarrote] or currentAuras[buff.improvegarroteS] then
			total = 1.5;
		end	
	end

	cached[spellId] = total;
	return total;
end


local function updateSnapshot(destGUID, spellId, func)
	if snapshots[destGUID] == nil then
		snapshots[destGUID] = {};
	end

	if func then
		snapshots[destGUID][spellId] = func(spellId);
	end
end

local function removeSnapshot(destGUID, spellId)
	if snapshots[destGUID] then
		snapshots[destGUID][spellId] = nil;
		if not (#snapshots[destGUID] > 0) then
			snapshots[destGUID] = nil;
		end
	end
end


local frame = CreateFrame("Frame");

local function load()
	snapshots = {};

	local spec = GetSpecialization();
	local _, englishClass = UnitClass("player");
	local listname = "ADS_OPTION_";

	if spec == nil or spec > 4 or (englishClass ~= "DRUID" and spec > 3) then
		spec = 1;
	end

	if spec then
		listname = "ADS_OPTION_" .. englishClass .. "_" .. spec;
	end

	local option = _G[listname];

	if not option then
		frame:UnregisterEvent("COMBAT_LOG_EVENT_UNFILTERED");
		frame:UnregisterEvent("UNIT_AURA");
		return;
	end

	buff = option.buff;
	debuff = option.debuff;
	snapshotDebuffs = tInvert(debuff);
	talent = option.talent;

	if englishClass == "DRUID" then
		damage_func = ns.getCurrentDamageFeral;
		modifiers_func = ns.getModifiersFeral;		
	elseif englishClass == "ROGUE" then
		damage_func = ns.getCurrentDamageAssasin;
		modifiers_func = nil;
	end	

	if modifiers_func then
		modifiers = modifiers_func();
		loadTraits();
	end	

	currentAuras = {}
	updateAuras();	

	frame:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED");
	frame:RegisterUnitEvent("UNIT_AURA", "player");
end

local playerGUID = UnitGUID("player");

local function OnEvent(self, event, ...)
	if event == "COMBAT_LOG_EVENT_UNFILTERED" then
		local _, msg, _, sourceGUID, _, _, _, destGUID, _, _, _, spellId = CombatLogGetCurrentEventInfo()
		if sourceGUID == playerGUID then
			if msg == "SPELL_AURA_REFRESH" or msg == "SPELL_AURA_APPLIED" then
				if snapshotDebuffs[spellId] then
					updateSnapshot(destGUID, spellId, damage_func)
				end
			elseif msg == "SPELL_AURA_REMOVED" then
				if snapshotDebuffs[spellId] then
					removeSnapshot(destGUID, spellId)
				end
			end
		end
	elseif event == "UNIT_AURA" then
		updateAuras();
	else
		load();
	end
end

frame:SetScript("OnEvent", OnEvent)
frame:RegisterEvent("PLAYER_ENTERING_WORLD");
frame:RegisterEvent("PLAYER_TALENT_UPDATE");
frame:RegisterEvent("ACTIVE_TALENT_GROUP_CHANGED");
frame:RegisterEvent("TRAIT_CONFIG_CREATED");
frame:RegisterEvent("TRAIT_CONFIG_UPDATED");


local function GetCurrentSnapshot(GUID, spellId)
	local unit = snapshots[GUID]
	if not unit then
		return nil
	end

	return unit[spellId]
end

local function GetNextSnapshot(spellId)
	if damage_func then
		return damage_func(spellId);
	else
		return nil;
	end
end

asDotSnapshot = {};

function asDotSnapshot.Relative(GUID, spellId)
	local refresh = GetNextSnapshot(spellId)
	local applied = GetCurrentSnapshot(GUID, spellId)
	if not applied then
		return refresh
	end

	if refresh then
		local diff = refresh / applied;
		return diff
	end

	return 1;
end
