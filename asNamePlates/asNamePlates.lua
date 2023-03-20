---설정부
local ANameP_SIZE = 0; 					-- Icon Size 0 이면 자동으로 설정
local ANameP_Size_Rate = 0.7;			-- Icon 가로 세로 비중
local ANameP_PVP_Debuff_Size_Rate = 4   -- PVP Debuff Icon Size 작게 하려면 - 값으로

local ANameP_PlayerBuffY = -5			-- Player 바 Buff 위치
local ANameP_TargetBuffY = 5			-- 대상바 Buff 위치
local ANameP_CooldownFontSize = 9;     --재사용 대기시간 Font Size
local ANameP_CountFontSize = 8;			--Count 폰트 Size
local ANameP_MaxDebuff = 8;				--최대 Debuff
local ANameP_DebuffsPerLine = 4;		--줄당 Debuff 수 (큰 이름표 일 경우 +1 됨)
local ANameP_MaxBuff = 1;				--최대 PVP Buff (안보이게 하려면 0)
local ANameP_ShowPVPDebuff = true;		--PVP Debuff 면 모두 보임 (다른 사람의 디법이면 회색으로 보임)
local ANameP_ShowPlayerBuff = true;		--Player NamePlate에 Buff를 안보일려면 false;
local ANameP_BuffMaxCool = 60;			--buff의 최대 Cool
local ANameP_PVPAggroShow = true;		-- PVP 어그로 여부를 표현할지 여부 
local ANameP_ShowListFirst = true		-- 알림 List 가 있다면 먼저 보인다. (가나다라 순서)
local ANameP_ShowCCDebuff = true		-- 오른쪽에 CC Debuff만 별도로 보이기
local ANameP_CCDebuffSize = 16			-- CC Debuff Size;
local ANameP_AggroSize = 12;			-- 어그로 표시 Text Size
local ANameP_HealerSize = 14;			-- 힐러표시 Text Size
local ANameP_TargetHealthBarHeight = 3;	-- 대상 체력바 높이 증가치 (+3)
local ANameP_HeathTextSize = 8;			-- 대상 체력숫자 크기
local ANameP_UpdateRate = 0.5;			-- 버프 Check 반복 시간 (초)


-- 아래 유닛명이면 강조
-- 색상 지정 가능
-- { r, g, b, 빤작임 여부}
local ANameP_AlertList = {
	["폭발물"] = {0, 1, 0.5, 1},	 -- 녹색 빤짝이 
	--["쉬바라"] = {0, 1, 0.5, 1},	 -- 녹색 빤짝이 
	--["우르줄"] = {0, 1, 0.5, 1},	 -- 녹색 빤짝이 
--	["파멸수호병"] = {0, 1, 0.5, 1},	 -- 녹색 빤짝이 
--	["격노수호병"] = {0, 1, 0.5, 1},	 -- 녹색 빤짝이 
--	["지옥불정령"] = {0, 1, 0.5, 1},	 -- 녹색 빤짝이 
--	["지옥사냥개"] = {0, 1, 0.5, 1},	 -- 녹색 빤짝이 
--	["원한의 망령"] = {1, 1, 1, 0},	-- 흰색 빤짝이 (없음)
--	["어둠그늘 곰팡이"] = {0, 1, 0, 0},	-- 녹색 빤짝이 (없음)
--["절단 훈련용 허수아비"] = {0, 1, 0.5, 1},	
--	["던전 사용자의 허수아비"] = {1, 0, 1, 0},	
--["공격대원의 훈련용 허수아비"] = {1, 0, 1, 0},	

}


-- 안보이게 할 디법
local ANameP_BlackList = {
--	["상처 감염 독"] = 1,	
--	["맹독"] = 1,
--	["약자 고문"] = 1,
--	["슬픔"] = 1,
--	["순환하는 기원"] = 1,
	["도전자의 짐"] = 1,
	["도전자의 힘"] = 1,

}

-- 크게 보이게 할 Debuff 값으로 추가 Size 를 입력 0 이거나 -도 가능
-- 일단 전장 Debuff 이 포함됨
local ANameP_BigDebuff = {

}


local ANameP_PVPBuffList = {

	[236273] = 1, --WARRIOR
	[118038] = 1, --WARRIOR
	[12975] = 1, --WARRIOR
	[871] = 1, --WARRIOR
	[97463] = 1, --WARRIOR
	[383762] = 1, --WARRIOR
	[184364] = 1, --WARRIOR
	[386394] = 1, --WARRIOR
	[392966] = 1, --WARRIOR
	[11327] = 1, --ROGUE
	[31224] = 1, --ROGUE
	[31230] = 1, --ROGUE
	[5277] = 1, --ROGUE
	[212800] = 1, --DEMONHUNTER
	[187827] = 1, --DEMONHUNTER
	[206803] = 1, --DEMONHUNTER
	[196555] = 1, --DEMONHUNTER
	[204021] = 1, --DEMONHUNTER
	[209258] = 1, --DEMONHUNTER
	[209426] = 1, --DEMONHUNTER
	[388615] = 1, --MONK
	[115310] = 1, --MONK
	[116849] = 1, --MONK
	[115399] = 1, --MONK
	[120954] = 1, --MONK
	[122783] = 1, --MONK
	[122278] = 1, --MONK
	[132578] = 1, --MONK
	[115176] = 1, --MONK
	[51052] = 1, --DEATHKNIGHT
	[48707] = 1, --DEATHKNIGHT
	[327574] = 1, --DEATHKNIGHT
	[48743] = 1, --DEATHKNIGHT
	[48792] = 1, --DEATHKNIGHT
	[114556] = 1, --DEATHKNIGHT
	[81256] = 1, --DEATHKNIGHT
	[219809] = 1, --DEATHKNIGHT
	[55233] = 1, --DEATHKNIGHT
	[53480] = 1, --HUNTER
	[109304] = 1, --HUNTER
	[264735] = 1, --HUNTER
	[370960] = 1, --EVOKER
	[363534] = 1, --EVOKER
	[357170] = 1, --EVOKER
	[374348] = 1, --EVOKER
	[374227] = 1, --EVOKER
	[363916] = 1, --EVOKER
	[354654] = 1, --DRUID
	[22812] = 1, --DRUID
	[157982] = 1, --DRUID
	[102342] = 1, --DRUID
	[61336] = 1, --DRUID
	[200851] = 1, --DRUID
	[108238] = 1, --DRUID
	[124974] = 1, --DRUID
	[104773] = 1, --WARLOCK
	[108416] = 1, --WARLOCK
	[215769] = 1, --PRIEST
	[328530] = 1, --PRIEST
	[197268] = 1, --PRIEST
	[19236] = 1, --PRIEST
	[81782] = 1, --PRIEST
	[33206] = 1, --PRIEST
	[372835] = 1, --PRIEST
	[391124] = 1, --PRIEST
	[265202] = 1, --PRIEST
	[64843] = 1, --PRIEST
	[47788] = 1, --PRIEST
	[47585] = 1, --PRIEST
	[108968] = 1, --PRIEST
	[15286] = 1, --PRIEST
	[199452] = 1, --PALADIN
	[31850] = 1, --PALADIN
	[378974] = 1, --PALADIN
	[86659] = 1, --PALADIN
	[387174] = 1, --PALADIN
	[327193] = 1, --PALADIN
	[205191] = 1, --PALADIN
	[184662] = 1, --PALADIN
	[157047] = 1, --PALADIN
	[31821] = 1, --PALADIN
	[633] = 1, --PALADIN
	[6940] = 1, --PALADIN
	[1022] = 1, --PALADIN
	[204018] = 1, --PALADIN
	[210918] = 1, --SHAMAN
	[108280] = 1, --SHAMAN
	[98008] = 1, --SHAMAN
	[198838] = 1, --SHAMAN
	[207399] = 1, --SHAMAN
	[108271] = 1, --SHAMAN
	[198103] = 1, --SHAMAN
	[108281] = 1, --SHAMAN
	[198158] = 1, --MAGE
	[110959] = 1, --MAGE
	[342246] = 1, --MAGE
	[66] = 1, --MAGE
	[55342] = 1, --MAGE
	[235219] = 1, --MAGE
	[86949] = 1, --MAGE
	[125174] = 1, --MONK
	[186265] = 1, --HUNTER
	[378441] = 1, --EVOKER
	[228049] = 1, --PALADIN
	[642] = 1, --PALADIN
	[45438] = 1, --MAGE
}

local ANameP_PVEBuffList = {

	[277242] = 5, --'그훈의 공생체' 
	[209859] = 0, --'강화' 
}

local ANameP_DangerousSpellList = {
	[135234] = true,
	[133262] = true,
	[294665] = true,
	[39945] = true,
	[134795] = true,
	[124935] = true,
	[135621] = true,
	[140983] = true,
	[142621] = true,
	[33975] = true,
	[282081] = true,
	[385652] = true,
	[29427] = true,
	[17843] = true,
	[46181] = true,
	[36819] = true,
	[39013] = true,
	[255824] = true,
	[253562] = true,
	[253583] = true,
	[255041] = true,
	[253544] = true,
	[253517] = true,
	[256849] = true,
	[252781] = true,
	[250368] = true,
	[250096] = true,
	[257397] = true,
	[257899] = true,
	[257736] = true,
	[258779] = true,
	[257784] = true,
	[257732] = true,
	[256060] = true,
	[267273] = true,
	[269973] = true,
	[270923] = true,
	[270901] = true,
	[270492] = true,
	[267763] = true,
	[257791] = true,
	[300764] = true,
	[300650] = true,
	[300171] = true,
	[299588] = true,
	[300087] = true,
	[300414] = true,
	[300514] = true,
	[300436] = true,
	[301629] = true,
	[284219] = true,
	[301088] = true,
	[293729] = true,
	[298669] = true,
	[268050] = true,
	[268030] = true,
	[268309] = true,
	[267977] = true,
	[274437] = true,
	[268317] = true,
	[268322] = true,
	[268375] = true,
	[276767] = true,
	[267818] = true,
	[256957] = true,
	[274569] = true,
	[272571] = true,
	[263318] = true,
	[263775] = true,
	[268061] = true,
	[265968] = true,
	[261635] = true,
	[272700] = true,
	[268061] = true,
	[265912] = true,
	[268709] = true,
	[263202] = true,
	[280604] = true,
	[268129] = true,
	[268702] = true,
	[263103] = true,
	[263066] = true,
	[268797] = true,
	[269090] = true,
	[262540] = true,
	[262092] = true,
	[260879] = true,
	[266106] = true,
	[265089] = true,
	[265091] = true,
	[265433] = true,
	[272183] = true,
	[278961] = true,
	[265523] = true,
	[257791] = true,
	[258128] = true,
	[258153] = true,
	[258313] = true,
	[258869] = true,
	[258634] = true,
	[258935] = true,
	[266225] = true,
	[263959] = true,
	[265876] = true,
	[265368] = true,
	[266036] = true,
	[278551] = true,
	[265407] = true,
	[82362] = true,
	[75823] = true,
	[102173] = true,
	[75763] = true,
	[80352] = true,
	[93468] = true,
	[93844] = true,
	[79351] = true,
	[76171] = true,
	[76008] = true,
	[103241] = true,
	[43451] = true,
	[43431] = true,
	[43548] = true,
	[96435] = true,
	[96466] = true,
	[310839] = true,
	[396640] = true,
	[367500] = true,
	[384638] = true,
	[377950] = true,
	[381770] = true,
	[363607] = true,
	[374080] = true,
	[384014] = true,
	[375056] = true,
	[378282] = true,
	[373680] = true,
	[384194] = true,
	[392451] = true,
	[373932] = true,
	[375596] = true,
	[387564] = true,
	[386546] = true,
	[376725] = true,
	[363607] = true,
	[384808] = true,
	[386024] = true,
	[387411] = true,
	[373395] = true,
	[369675] = true,
	[369602] = true,
	[369674] = true,
	[369823] = true,
	[225573] = true,
	[197797] = true,
	[237391] = true,
	[238543] = true,
	[242724] = true,
	[212773] = true,
	[209485] = true,
	[209410] = true,
	[209413] = true,
	[211470] = true,
	[225100] = true,
	[211299] = true,
	[207980] = true,
	[196870] = true,
	[195046] = true,
	[195284] = true,
	[197502] = true,
	[192003] = true,
	[192005] = true,
	[191848] = true,
	[215433] = true,
	[198934] = true,
	[192563] = true,
	[199726] = true,
	[192288] = true,
	[198750] = true,
	[194266] = true,
	[198495] = true,
	[198405] = true,
	[227800] = true,
	[227823] = true,
	[227592] = true,
	[228025] = true,
	[228019] = true,
	[227987] = true,
	[227420] = true,
	[228255] = true,
	[228239] = true,
	[227917] = true,
	[228625] = true,
	[228606] = true,
	[229714] = true,
	[248831] = true,
	[245585] = true,
	[245727] = true,
	[248133] = true,
	[248184] = true,
	[244751] = true,
	[211757] = true,
	[226206] = true,
	[196392] = true,
	[203957] = true,
	[191823] = true,
	[200905] = true,
	[193069] = true,
	[204963] = true,
	[205088] = true,
	[395859] = true,
	[395872] = true,
	[397801] = true,
	[118963] = true,
	[118940] = true,
	[118903] = true,
	[123654] = true,
	[113134] = true,
	[12039] = true,
	[130857] = true,
	[113691] = true,
	[113690] = true,
	[107356] = true,
	[332666] = true,
	[332706] = true,
	[332612] = true,
	[332084] = true,
	[323064] = true,
	[325700] = true,
	[325701] = true,
	[326607] = true,
	[323538] = true,
	[323552] = true,
	[323057] = true,
	[321828] = true,
	[322938] = true,
	[324914] = true,
	[324776] = true,
	[326046] = true,
	[340544] = true,
	[322450] = true,
	[257397] = true,
	[319070] = true,
	[328338] = true,
	[328016] = true,
	[326836] = true,
	[321038] = true,
	[327481] = true,
	[317936] = true,
	[317963] = true,
	[327413] = true,
	[328295] = true,
	[328137] = true,
	[328331] = true,
	[358131] = true,
	[350922] = true,
	[357404] = true,
	[355888] = true,
	[355930] = true,
	[355934] = true,
	[354297] = true,
	[356537] = true,
	[347775] = true,
	[347903] = true,
	[355057] = true,
	[355225] = true,
	[357260] = true,
	[356407] = true,
	[356404] = true,
	[324589] = true,
	[341902] = true,
	[341969] = true,
	[342139] = true,
	[330562] = true,
	[330810] = true,
	[333231] = true,
	[320170] = true,
	[322493] = true,
	[334748] = true,
	[320462] = true,
	[324293] = true,
	[338353] = true,
	[257397] = true,
	[149955] = true,
	[86620] = true,
	[86620] = true,
	[86620] = true,
	[86620] = true,
	[86620] = true,
	[86620] = true,
	[86620] = true,
	[86620] = true,
	[86620] = true,
	[86620] = true,
	[86620] = true,
	[86620] = true,
	[86620] = true,
	[86620] = true,
	[86620] = true,
	[86620] = true,
	[86620] = true,
	[86620] = true,
	[86620] = true,
	[86620] = true,
	[86620] = true,
	[86620] = true,
	[86620] = true,
	[86620] = true,
	[86620] = true,
	[86620] = true,
	[86620] = true,
	[86620] = true,
	[86620] = true,
	[86620] = true,
	[86620] = true,
	[86620] = true,
	[86620] = true,
	[11082] = true,
	[11085] = true,
	[93655] = true,
	[86620] = true,
	[86620] = true,
	[86620] = true,
	[86620] = true,
	[86620] = true,
	[86620] = true,
	[86620] = true,
	[86620] = true,
	[86620] = true,
	[21807] = true,
	[21807] = true,
	[86620] = true,
	[119300] = true,
	[86620] = true,
	[86620] = true,
	[86620] = true,
	[86620] = true,
	[86620] = true,
	[86620] = true,
	[86620] = true,
	[86620] = true,
	[86620] = true,
	[86620] = true,
	[86620] = true,
	[15245] = true,
	[16798] = true,
	[86620] = true,
	[12471] = true,
	[68982] = true,
	[374623] = true,
	[372315] = true,
	[372394] = true,
	[310839] = true,
	[81713] = true,
	[80734] = true,
}

local ANameP_HealSpellList = {};

ANameP_HealSpellList["사제"] = {

 	    [047540] = "PRIEST", -- Penance XXX strange error received from user on 2015-10-15 (this spell was cast by a hunter...)
        [109964] = "PRIEST", -- Spirit shell -- not seen in disc
        [002060] = "PRIEST", -- Greater Heal
        [014914] = "PRIEST", -- Holy Fire
        [033206] = "PRIEST", -- Pain Suppression
        [000596] = "PRIEST", -- Prayer of Healing
        [000527] = "PRIEST", -- Purify
        [081749] = "PRIEST", -- Atonement
        [132157] = "PRIEST", -- Holy Nova
        [034861] = "PRIEST", -- Circle of Healing
        [064843] = "PRIEST", -- Divine Hymn
        [047788] = "PRIEST", -- Guardian Spirit
        [032546] = "PRIEST", -- Binding Heal
        [077485] = "PRIEST", -- Mastery: Echo of Light -- the passibe ability
        [077489] = "PRIEST", -- Echo of Light -- the aura applied by the afformentioned
        [000139] = "PRIEST", -- Renew

	};

ANameP_HealSpellList["드루이드"] = {

        [102342] = "DRUID", -- Ironbark
        [033763] = "DRUID", -- Lifebloom
        [088423] = "DRUID", -- Nature's Cure
        [033891] = "DRUID", -- Incarnation: Tree of Life
        [048438] = "DRUID", -- Wild Growth
        [000740] = "DRUID", -- Tranquility
	};


ANameP_HealSpellList["주술사"] = {

        [061295] = "SHAMAN", -- Riptide
        [077472] = "SHAMAN", -- Healing Wave
        [098008] = "SHAMAN", -- Spirit link totem
        [001064] = "SHAMAN", -- Chain Heal
        [073920] = "SHAMAN", -- Healing Rain

	};

ANameP_HealSpellList["성기사"] = {

        [020473] = "PALADIN", -- Holy Shock
        [053563] = "PALADIN", -- Beacon of Light
        [082326] = "PALADIN", -- Holy Light
        [085222] = "PALADIN", -- Light of Dawn
	};


ANameP_HealSpellList["수도사"] = {
        [115175] = "MONK", -- Soothing Mist
        [115310] = "MONK", -- Revival
        [116670] = "MONK", -- Vivify
        [116680] = "MONK", -- Thunder Focus Tea
        [116849] = "MONK", -- Life Cocoon
        [119611] = "MONK", -- Renewing mist

};

ANameP_HealSpellList["기원사"] = {
        [355936] = "EVOKER", -- 꿈의 숨결
		[364446] = "EVOKER", -- 메아리
		[366155] = "EVOKER", -- 되감기
		[367226] = "EVOKER", -- 영혼 만개

};

local ANameP_HealerGuid = {

}

local ANameP = nil;
local tanklist = {}

local PLAYER_UNITS = {
	player = true,
	vehicle = true,
	pet = true,
};


local lowhealthpercent = 0;

local ColorLevel = {
	None = 0,
	Reset = 1,
	Custom = 2,
	Debuff = 3,
	Lowhealth = 4,
	Aggro = 5,
	Target = 6,
	Interrupt = 7,
	Name = 8,
};

local ANameP_ShowList = nil;
local ANameP_Resourcetext = nil;
local debuffs_per_line = ANameP_DebuffsPerLine;
local playerbuffposition = ANameP_PlayerBuffY;
local options = CopyTable (ANameP_Options_Default);

-- 반짝이 처리부

local lib = {};

local isRetail = WOW_PROJECT_ID == WOW_PROJECT_MAINLINE
local textureList = {
    empty = [[Interface\AdventureMap\BrokenIsles\AM_29]],
    white = [[Interface\BUTTONS\WHITE8X8]],
    shine = [[Interface\ItemSocketingFrame\UI-ItemSockets]]
}

local shineCoords = {0.3984375, 0.4453125, 0.40234375, 0.44921875}
if isRetail then
    textureList.shine = [[Interface\Artifacts\Artifacts]]
    shineCoords = {0.8115234375,0.9169921875,0.8798828125,0.9853515625}
end

function lib.RegisterTextures(texture,id)
    textureList[id] = texture
end

lib.glowList = {}
lib.startList = {}
lib.stopList = {}

local GlowParent = UIParent

local GlowMaskPool = CreateFromMixins(ObjectPoolMixin)
lib.GlowMaskPool = GlowMaskPool
local function MaskPoolFactory(maskPool)
    return maskPool.parent:CreateMaskTexture()
end

local MaskPoolResetter = function(maskPool,mask)
    mask:Hide()
    mask:ClearAllPoints()
end

ObjectPoolMixin.OnLoad(GlowMaskPool,MaskPoolFactory,MaskPoolResetter)
GlowMaskPool.parent =  GlowParent

local TexPoolResetter = function(pool,tex)
    local maskNum = tex:GetNumMaskTextures()
    for i = maskNum , 1, -1 do
        tex:RemoveMaskTexture(tex:GetMaskTexture(i))
    end
    tex:Hide()
    tex:ClearAllPoints()
end
local GlowTexPool = CreateTexturePool(GlowParent ,"ARTWORK",7,nil,TexPoolResetter)
lib.GlowTexPool = GlowTexPool

local FramePoolResetter = function(framePool,frame)
    frame:SetScript("OnUpdate",nil)
    local parent = frame:GetParent()
    if parent[frame.name] then
        parent[frame.name] = nil
    end
    if frame.textures then
        for _, texture in pairs(frame.textures) do
            GlowTexPool:Release(texture)
        end
    end
    if frame.bg then
        GlowTexPool:Release(frame.bg)
        frame.bg = nil
    end
    if frame.masks then
        for _,mask in pairs(frame.masks) do
            GlowMaskPool:Release(mask)
        end
        frame.masks = nil
    end
    frame.textures = {}
    frame.info = {}
    frame.name = nil
    frame.timer = nil
    frame:Hide()
    frame:ClearAllPoints()
end
local GlowFramePool = CreateFramePool("Frame",GlowParent,nil,FramePoolResetter)
lib.GlowFramePool = GlowFramePool

local function addFrameAndTex(r,color,name,key,N,xOffset,yOffset,texture,texCoord,desaturated,frameLevel)
    key = key or ""
	frameLevel = frameLevel or 8
    if not r[name..key] then
        r[name..key] = GlowFramePool:Acquire()
        r[name..key]:SetParent(r)
        r[name..key].name = name..key
    end
    local f = r[name..key]
	f:SetFrameLevel(r:GetFrameLevel()+frameLevel)
    f:SetPoint("TOPLEFT",r,"TOPLEFT",-xOffset+0.05,yOffset+0.05)
    f:SetPoint("BOTTOMRIGHT",r,"BOTTOMRIGHT",xOffset,-yOffset+0.05)
    f:Show()

    if not f.textures then
        f.textures = {}
    end

    for i=1,N do
        if not f.textures[i] then
            f.textures[i] = GlowTexPool:Acquire()
            f.textures[i]:SetTexture(texture)
            f.textures[i]:SetTexCoord(texCoord[1],texCoord[2],texCoord[3],texCoord[4])
            f.textures[i]:SetDesaturated(desaturated)
            f.textures[i]:SetParent(f)
            f.textures[i]:SetDrawLayer("ARTWORK",7)
            if not isRetail and name == "_AutoCastGlow" then
                f.textures[i]:SetBlendMode("ADD")
            end
        end
        f.textures[i]:SetVertexColor(color[1],color[2],color[3],color[4])
        f.textures[i]:Show()
    end
    while #f.textures>N do
        GlowTexPool:Release(f.textures[#f.textures])
        table.remove(f.textures)
    end
end


--Pixel Glow Functions--
local pCalc1 = function(progress,s,th,p)
    local c
    if progress>p[3] or progress<p[0] then
        c = 0
    elseif progress>p[2] then
        c =s-th-(progress-p[2])/(p[3]-p[2])*(s-th)
    elseif progress>p[1] then
        c =s-th
    else
        c = (progress-p[0])/(p[1]-p[0])*(s-th)
    end
    return math.floor(c+0.5)
end

local pCalc2 = function(progress,s,th,p)
    local c
    if progress>p[3] then
        c = s-th-(progress-p[3])/(p[0]+1-p[3])*(s-th)
    elseif progress>p[2] then
        c = s-th
    elseif progress>p[1] then
        c = (progress-p[1])/(p[2]-p[1])*(s-th)
    elseif progress>p[0] then
        c = 0
    else
        c = s-th-(progress+1-p[3])/(p[0]+1-p[3])*(s-th)
    end
    return math.floor(c+0.5)
end

local  pUpdate = function(self,elapsed)
    self.timer = self.timer+elapsed/self.info.period
    if self.timer>1 or self.timer <-1 then
        self.timer = self.timer%1
    end
    local progress = self.timer
    local width,height = self:GetSize()
    if width ~= self.info.width or height ~= self.info.height then
        local perimeter = 2*(width+height)
        if not (perimeter>0) then
            return
        end
        self.info.width = width
        self.info.height = height
        self.info.pTLx = {
            [0] = (height+self.info.length/2)/perimeter,
            [1] = (height+width+self.info.length/2)/perimeter,
            [2] = (2*height+width-self.info.length/2)/perimeter,
            [3] = 1-self.info.length/2/perimeter
        }
        self.info.pTLy ={
            [0] = (height-self.info.length/2)/perimeter,
            [1] = (height+width+self.info.length/2)/perimeter,
            [2] = (height*2+width+self.info.length/2)/perimeter,
            [3] = 1-self.info.length/2/perimeter
        }
        self.info.pBRx ={
            [0] = self.info.length/2/perimeter,
            [1] = (height-self.info.length/2)/perimeter,
            [2] = (height+width-self.info.length/2)/perimeter,
            [3] = (height*2+width+self.info.length/2)/perimeter
        }
        self.info.pBRy ={
            [0] = self.info.length/2/perimeter,
            [1] = (height+self.info.length/2)/perimeter,
            [2] = (height+width-self.info.length/2)/perimeter,
            [3] = (height*2+width-self.info.length/2)/perimeter
        }
    end
    if self:IsShown() then
        if not (self.masks[1]:IsShown()) then
            self.masks[1]:Show()
            self.masks[1]:SetPoint("TOPLEFT",self,"TOPLEFT",self.info.th,-self.info.th)
            self.masks[1]:SetPoint("BOTTOMRIGHT",self,"BOTTOMRIGHT",-self.info.th,self.info.th)
        end
        if self.masks[2] and not(self.masks[2]:IsShown()) then
            self.masks[2]:Show()
            self.masks[2]:SetPoint("TOPLEFT",self,"TOPLEFT",self.info.th+1,-self.info.th-1)
            self.masks[2]:SetPoint("BOTTOMRIGHT",self,"BOTTOMRIGHT",-self.info.th-1,self.info.th+1)
        end
        if self.bg and not(self.bg:IsShown()) then
            self.bg:Show()
        end
        for k,line  in pairs(self.textures) do
            line:SetPoint("TOPLEFT",self,"TOPLEFT",pCalc1((progress+self.info.step*(k-1))%1,width,self.info.th,self.info.pTLx),-pCalc2((progress+self.info.step*(k-1))%1,height,self.info.th,self.info.pTLy))
            line:SetPoint("BOTTOMRIGHT",self,"TOPLEFT",self.info.th+pCalc2((progress+self.info.step*(k-1))%1,width,self.info.th,self.info.pBRx),-height+pCalc1((progress+self.info.step*(k-1))%1,height,self.info.th,self.info.pBRy))
        end
    end
end

function lib.PixelGlow_Start(r,color,N,frequency,length,th,xOffset,yOffset,border,key,frameLevel)
    if not r then
        return
    end

    if not color then
        color = {0.95,0.95,0.32,1}
    end

    if not(N and N>0) then
        N = 8
    end

    local period
    if frequency then
        if not(frequency>0 or frequency<0) then
            period = 4
        else
            period = 1/frequency
        end
    else
        period = 4
    end
    local width,height = r:GetSize()
    length = length or math.floor((width+height)*(2/N-0.1))
    length = min(length,min(width,height))
    th = th or 1
    xOffset = xOffset or 0
    yOffset = yOffset or 0
    key = key or ""

    addFrameAndTex(r,color,"_PixelGlow",key,N,xOffset,yOffset,textureList.white,{0,1,0,1},nil,frameLevel)
    local f = r["_PixelGlow"..key]
    if not f.masks then
        f.masks = {}
    end
    if not f.masks[1] then
        f.masks[1] = GlowMaskPool:Acquire()
        f.masks[1]:SetTexture(textureList.empty, "CLAMPTOWHITE","CLAMPTOWHITE")
        f.masks[1]:Show()
    end
    f.masks[1]:SetPoint("TOPLEFT",f,"TOPLEFT",th,-th)
    f.masks[1]:SetPoint("BOTTOMRIGHT",f,"BOTTOMRIGHT",-th,th)

    if not(border==false) then
        if not f.masks[2] then
            f.masks[2] = GlowMaskPool:Acquire()
            f.masks[2]:SetTexture(textureList.empty, "CLAMPTOWHITE","CLAMPTOWHITE")
        end
        f.masks[2]:SetPoint("TOPLEFT",f,"TOPLEFT",th+1,-th-1)
        f.masks[2]:SetPoint("BOTTOMRIGHT",f,"BOTTOMRIGHT",-th-1,th+1)

        if not f.bg then
            f.bg = GlowTexPool:Acquire()
            f.bg:SetColorTexture(0.1,0.1,0.1,0.8)
            f.bg:SetParent(f)
            f.bg:SetAllPoints(f)
            f.bg:SetDrawLayer("ARTWORK",6)
            f.bg:AddMaskTexture(f.masks[2])
        end
    else
        if f.bg then
            GlowTexPool:Release(f.bg)
            f.bg = nil
        end
        if f.masks[2] then
            GlowMaskPool:Release(f.masks[2])
            f.masks[2] = nil
        end
    end
    for _,tex in pairs(f.textures) do
        if tex:GetNumMaskTextures() < 1 then
            tex:AddMaskTexture(f.masks[1])
        end
    end
    f.timer = f.timer or 0
    f.info = f.info or {}
    f.info.step = 1/N
    f.info.period = period
    f.info.th = th
    if f.info.length ~= length then
        f.info.width = nil
        f.info.length = length
    end
    pUpdate(f, 0)
    f:SetScript("OnUpdate",pUpdate)
end

function lib.PixelGlow_Stop(r,key)
    if not r then
        return
   	end

    key = key or ""
    if not r["_PixelGlow"..key] then
        return false
    else
        GlowFramePool:Release(r["_PixelGlow"..key])
    end
end

table.insert(lib.glowList, "Pixel Glow")
lib.startList["Pixel Glow"] = lib.PixelGlow_Start
lib.stopList["Pixel Glow"] = lib.PixelGlow_Stop

--Action Button Glow--
local function ButtonGlowResetter(framePool,frame)
    frame:SetScript("OnUpdate",nil)
    local parent = frame:GetParent()
    if parent._ButtonGlow then
        parent._ButtonGlow = nil
    end
    frame:Hide()
    frame:ClearAllPoints()
end
local ButtonGlowPool = CreateFramePool("Frame",GlowParent,nil,ButtonGlowResetter)
lib.ButtonGlowPool = ButtonGlowPool

local function CreateScaleAnim(group, target, order, duration, x, y, delay)
    local scale = group:CreateAnimation("Scale")
    scale:SetChildKey(target)
    scale:SetOrder(order)
    scale:SetDuration(duration)
    scale:SetScale(x, y)

    if delay then
        scale:SetStartDelay(delay)
    end
end

local function CreateAlphaAnim(group, target, order, duration, fromAlpha, toAlpha, delay, appear)
    local alpha = group:CreateAnimation("Alpha")
    alpha:SetChildKey(target)
    alpha:SetOrder(order)
    alpha:SetDuration(duration)
    alpha:SetFromAlpha(fromAlpha)
    alpha:SetToAlpha(toAlpha)
    if delay then
        alpha:SetStartDelay(delay)
    end
    if appear then
        table.insert(group.appear, alpha)
    else
        table.insert(group.fade, alpha)
    end
end

local function AnimIn_OnPlay(group)
    local frame = group:GetParent()
    local frameWidth, frameHeight = frame:GetSize()
    frame.spark:SetSize(frameWidth, frameHeight)
    frame.spark:SetAlpha(not(frame.color) and 1.0 or 0.3*frame.color[4])
    frame.innerGlow:SetSize(frameWidth / 2, frameHeight / 2)
    frame.innerGlow:SetAlpha(not(frame.color) and 1.0 or frame.color[4])
    frame.innerGlowOver:SetAlpha(not(frame.color) and 1.0 or frame.color[4])
    frame.outerGlow:SetSize(frameWidth, frameHeight)
    frame.outerGlow:SetAlpha(not(frame.color) and 1.0 or frame.color[4])
    frame.outerGlowOver:SetAlpha(not(frame.color) and 1.0 or frame.color[4])
    frame.ants:SetSize(frameWidth * 0.85, frameHeight * 0.85)
    frame.ants:SetAlpha(0)
    frame:Show()
end

local function AnimIn_OnFinished(group)
    local frame = group:GetParent()
    local frameWidth, frameHeight = frame:GetSize()
    frame.spark:SetAlpha(0)
    frame.innerGlow:SetAlpha(0)
    frame.innerGlow:SetSize(frameWidth, frameHeight)
    frame.innerGlowOver:SetAlpha(0.0)
    frame.outerGlow:SetSize(frameWidth, frameHeight)
    frame.outerGlowOver:SetAlpha(0.0)
    frame.outerGlowOver:SetSize(frameWidth, frameHeight)
    frame.ants:SetAlpha(not(frame.color) and 1.0 or frame.color[4])
end

local function AnimIn_OnStop(group)
    local frame = group:GetParent()
    local frameWidth, frameHeight = frame:GetSize()
    frame.spark:SetAlpha(0)
    frame.innerGlow:SetAlpha(0)
    frame.innerGlowOver:SetAlpha(0.0)
    frame.outerGlowOver:SetAlpha(0.0)
end

local function bgHide(self)
    if self.animOut:IsPlaying() then
        self.animOut:Stop()
        ButtonGlowPool:Release(self)
    end
end

local function bgUpdate(self, elapsed)
    AnimateTexCoords(self.ants, 256, 256, 48, 48, 22, elapsed, self.throttle);
    local cooldown = self:GetParent().cooldown;
    if(cooldown and cooldown:IsShown() and cooldown:GetCooldownDuration() > 3000) then
        self:SetAlpha(0.5);
    else
        self:SetAlpha(1.0);
    end
end

local function configureButtonGlow(f,alpha)
    f.spark = f:CreateTexture(nil, "BACKGROUND")
    f.spark:SetPoint("CENTER")
    f.spark:SetAlpha(0)
    f.spark:SetTexture([[Interface\SpellActivationOverlay\IconAlert]])
    f.spark:SetTexCoord(0.00781250, 0.61718750, 0.00390625, 0.26953125)

    -- inner glow
    f.innerGlow = f:CreateTexture(nil, "ARTWORK")
    f.innerGlow:SetPoint("CENTER")
    f.innerGlow:SetAlpha(0)
    f.innerGlow:SetTexture([[Interface\SpellActivationOverlay\IconAlert]])
    f.innerGlow:SetTexCoord(0.00781250, 0.50781250, 0.27734375, 0.52734375)

    -- inner glow over
    f.innerGlowOver = f:CreateTexture(nil, "ARTWORK")
    f.innerGlowOver:SetPoint("TOPLEFT", f.innerGlow, "TOPLEFT")
    f.innerGlowOver:SetPoint("BOTTOMRIGHT", f.innerGlow, "BOTTOMRIGHT")
    f.innerGlowOver:SetAlpha(0)
    f.innerGlowOver:SetTexture([[Interface\SpellActivationOverlay\IconAlert]])
    f.innerGlowOver:SetTexCoord(0.00781250, 0.50781250, 0.53515625, 0.78515625)

    -- outer glow
    f.outerGlow = f:CreateTexture(nil, "ARTWORK")
    f.outerGlow:SetPoint("CENTER")
    f.outerGlow:SetAlpha(0)
    f.outerGlow:SetTexture([[Interface\SpellActivationOverlay\IconAlert]])
    f.outerGlow:SetTexCoord(0.00781250, 0.50781250, 0.27734375, 0.52734375)

    -- outer glow over
    f.outerGlowOver = f:CreateTexture(nil, "ARTWORK")
    f.outerGlowOver:SetPoint("TOPLEFT", f.outerGlow, "TOPLEFT")
    f.outerGlowOver:SetPoint("BOTTOMRIGHT", f.outerGlow, "BOTTOMRIGHT")
    f.outerGlowOver:SetAlpha(0)
    f.outerGlowOver:SetTexture([[Interface\SpellActivationOverlay\IconAlert]])
    f.outerGlowOver:SetTexCoord(0.00781250, 0.50781250, 0.53515625, 0.78515625)

    -- ants
    f.ants = f:CreateTexture(nil, "OVERLAY")
    f.ants:SetPoint("CENTER")
    f.ants:SetAlpha(0)
    f.ants:SetTexture([[Interface\SpellActivationOverlay\IconAlertAnts]])

    f.animIn = f:CreateAnimationGroup()
    f.animIn.appear = {}
    f.animIn.fade = {}
    CreateScaleAnim(f.animIn, "spark",          1, 0.2, 1.5, 1.5)
    CreateAlphaAnim(f.animIn, "spark",          1, 0.2, 0, alpha, nil, true)
    CreateScaleAnim(f.animIn, "innerGlow",      1, 0.3, 2, 2)
    CreateScaleAnim(f.animIn, "innerGlowOver",  1, 0.3, 2, 2)
    CreateAlphaAnim(f.animIn, "innerGlowOver",  1, 0.3, alpha, 0, nil, false)
    CreateScaleAnim(f.animIn, "outerGlow",      1, 0.3, 0.5, 0.5)
    CreateScaleAnim(f.animIn, "outerGlowOver",  1, 0.3, 0.5, 0.5)
    CreateAlphaAnim(f.animIn, "outerGlowOver",  1, 0.3, alpha, 0, nil, false)
    CreateScaleAnim(f.animIn, "spark",          1, 0.2, 2/3, 2/3, 0.2)
    CreateAlphaAnim(f.animIn, "spark",          1, 0.2, alpha, 0, 0.2, false)
    CreateAlphaAnim(f.animIn, "innerGlow",      1, 0.2, alpha, 0, 0.3, false)
    CreateAlphaAnim(f.animIn, "ants",           1, 0.2, 0, alpha, 0.3, true)
    f.animIn:SetScript("OnPlay", AnimIn_OnPlay)
    f.animIn:SetScript("OnStop", AnimIn_OnStop)
    f.animIn:SetScript("OnFinished", AnimIn_OnFinished)

    f.animOut = f:CreateAnimationGroup()
    f.animOut.appear = {}
    f.animOut.fade = {}
    CreateAlphaAnim(f.animOut, "outerGlowOver", 1, 0.2, 0, alpha, nil, true)
    CreateAlphaAnim(f.animOut, "ants",          1, 0.2, alpha, 0, nil, false)
    CreateAlphaAnim(f.animOut, "outerGlowOver", 2, 0.2, alpha, 0, nil, false)
    CreateAlphaAnim(f.animOut, "outerGlow",     2, 0.2, alpha, 0, nil, false)
    f.animOut:SetScript("OnFinished", function(self) ButtonGlowPool:Release(self:GetParent())  end)

    f:SetScript("OnHide", bgHide)
end

local function updateAlphaAnim(f,alpha)
    for _,anim in pairs(f.animIn.appear) do
        anim:SetToAlpha(alpha)
    end
    for _,anim in pairs(f.animIn.fade) do
        anim:SetFromAlpha(alpha)
    end
    for _,anim in pairs(f.animOut.appear) do
        anim:SetToAlpha(alpha)
    end
    for _,anim in pairs(f.animOut.fade) do
        anim:SetFromAlpha(alpha)
    end
end

local ButtonGlowTextures = {["spark"] = true,["innerGlow"] = true,["innerGlowOver"] = true,["outerGlow"] = true,["outerGlowOver"] = true,["ants"] = true}

function lib.ButtonGlow_Start(r,color,frequency,frameLevel)
    if not r then
        return
    end
	frameLevel = frameLevel or 8;
    local throttle
    if frequency and frequency > 0 then
        throttle = 0.25/frequency*0.01
    else
        throttle = 0.01
    end
    if r._ButtonGlow then
        local f = r._ButtonGlow
        local width,height = r:GetSize()
        f:SetFrameLevel(r:GetFrameLevel()+frameLevel)
        f:SetSize(width*1.4 , height*1.4)
        f:SetPoint("TOPLEFT", r, "TOPLEFT", -width * 0.3, height * 0.3)
        f:SetPoint("BOTTOMRIGHT", r, "BOTTOMRIGHT", width * 0.3, -height * 0.3)
        f.ants:SetSize(width*1.4*0.85, height*1.4*0.85)
		AnimIn_OnFinished(f.animIn)
		if f.animOut:IsPlaying() then
            f.animOut:Stop()
            f.animIn:Play()
        end

        if not(color) then
            for texture in pairs(ButtonGlowTextures) do
                f[texture]:SetDesaturated(nil)
                f[texture]:SetVertexColor(1,1,1)
                f[texture]:SetAlpha(f[texture]:GetAlpha()/(f.color and f.color[4] or 1))
                updateAlphaAnim(f, 1)
            end
            f.color = false
        else
            for texture in pairs(ButtonGlowTextures) do
                f[texture]:SetDesaturated(1)
                f[texture]:SetVertexColor(color[1],color[2],color[3])
                f[texture]:SetAlpha(f[texture]:GetAlpha()/(f.color and f.color[4] or 1)*color[4])
                updateAlphaAnim(f,color and color[4] or 1)
            end
            f.color = color
        end
        f.throttle = throttle
    else
        local f, new = ButtonGlowPool:Acquire()
        if new then
            configureButtonGlow(f,color and color[4] or 1)
        else
            updateAlphaAnim(f,color and color[4] or 1)
        end
        r._ButtonGlow = f
        local width,height = r:GetSize()
        f:SetParent(r)
        f:SetFrameLevel(r:GetFrameLevel()+frameLevel)
        f:SetSize(width * 1.4, height * 1.4)
        f:SetPoint("TOPLEFT", r, "TOPLEFT", -width * 0.3, height * 0.3)
        f:SetPoint("BOTTOMRIGHT", r, "BOTTOMRIGHT", width * 0.3, -height * 0.3)
        if not(color) then
            f.color = false
            for texture in pairs(ButtonGlowTextures) do
                f[texture]:SetDesaturated(nil)
                f[texture]:SetVertexColor(1,1,1)
            end
        else
            f.color = color
            for texture in pairs(ButtonGlowTextures) do
                f[texture]:SetDesaturated(1)
                f[texture]:SetVertexColor(color[1],color[2],color[3])
            end
        end
        f.throttle = throttle
        f:SetScript("OnUpdate", bgUpdate)

        f.animIn:Play()

        if Masque and Masque.UpdateSpellAlert and (not r.overlay or not issecurevariable(r, "overlay")) then
            local old_overlay = r.overlay
            r.overlay = f
            Masque:UpdateSpellAlert(r)
            r.overlay = old_overlay
        end
    end
end

function lib.ButtonGlow_Stop(r)
    if r._ButtonGlow then
        if r._ButtonGlow.animIn:IsPlaying() then
            r._ButtonGlow.animIn:Stop()
            ButtonGlowPool:Release(r._ButtonGlow)
        elseif r:IsVisible() then
            r._ButtonGlow.animOut:Play()
        else
            ButtonGlowPool:Release(r._ButtonGlow)
        end
    end
end

table.insert(lib.glowList, "Action Button Glow")
lib.startList["Action Button Glow"] = lib.ButtonGlow_Start
lib.stopList["Action Button Glow"] = lib.ButtonGlow_Stop



--Cooldown
local function asCooldownFrame_Clear(self)
	self:Clear();
end
--cooldown
local function asCooldownFrame_Set(self, start, duration, enable, forceShowDrawEdge, modRate)
	if enable and enable ~= 0 and start > 0 and duration > 0 then
		self:SetDrawEdge(forceShowDrawEdge);
		self:SetCooldown(start, duration, modRate);
	else
		asCooldownFrame_Clear(self);
	end
end

local KnownSpellList = {};
local function scanSpells(tab)

	local tabName, tabTexture, tabOffset, numEntries = GetSpellTabInfo(tab)

	if not tabName then
		return;
	end

	for i=tabOffset + 1, tabOffset + numEntries do
		local spellName, _, spellID = GetSpellBookItemName (i, BOOKTYPE_SPELL)
		if not spellName then
			do break end
		end

		if spellName then
			KnownSpellList[spellName] = 1;
		end
	end
end

local function scanPetSpells()

	for i = 1, 20 do
	   	local slot = i + (SPELLS_PER_PAGE * (SPELLBOOK_PAGENUMBERS[BOOKTYPE_PET] - 1));
	   	local spellName, _, spellID = GetSpellBookItemName (slot, BOOKTYPE_PET)

		if not spellName then
			do break end
		end

		if spellName then
			KnownSpellList[spellName] = 1;

		end
	end

end


local function setupKnownSpell()

	table.wipe(KnownSpellList);

	scanSpells(1)
	scanSpells(2)
	scanSpells(3)
	scanPetSpells()
end

-- 탱커 처리부
local function updateTankerList()

	local bInstance, RTB_ZoneType = IsInInstance();

	if RTB_ZoneType == "pvp" or RTB_ZoneType == "arena" then
		return nil;
	end

	tanklist =	table.wipe(tanklist)
	if IsInGroup() then
		if IsInRaid() then -- raid
			for i=1,GetNumGroupMembers() do
				local unitid = "raid"..i
				local notMe = not UnitIsUnit('player',unitid)
				local unitName = UnitName(unitid)
				if unitName and notMe then
					local _,_,_,_,_,_,_,_,_,role,_, assignedRole = GetRaidRosterInfo(i);
					if assignedRole == "TANK" then
						table.insert(tanklist, unitid);
					end
				end
			end
		else -- party
			for i=1,GetNumSubgroupMembers() do
				local unitid = "party"..i;
				local unitName = UnitName(unitid);
				if unitName then
					local assignedRole = UnitGroupRolesAssigned(unitid);
					if assignedRole == "TANK" then
						table.insert(tanklist, unitid);
					end
				end
			end
		end
	end
end

local function IsPlayerEffectivelyTank()
	local assignedRole = UnitGroupRolesAssigned("player");
	if ( assignedRole == "NONE" ) then
		local spec = GetSpecialization();
		return spec and GetSpecializationRole(spec) == "TANK";
	end
	return assignedRole == "TANK";
end


-- 버프 디버프 처리부
local function createDebuffFrame(parent)

	local ret = CreateFrame("Frame", nil, parent, "asNamePlatesBuffFrameTemplate");
	ret:EnableMouse(false);

	local frameCooldown = ret.cooldown;
	local frameCount = ret.count;

	for _,r in next,{frameCooldown:GetRegions()}	do
		if r:GetObjectType()=="FontString" then
			r:SetFont(STANDARD_TEXT_FONT, ANameP_CooldownFontSize,"OUTLINE")
			r:ClearAllPoints();
			r:SetPoint("TOP", 0, 4);
			break;
		end
	end

	local font, size, flag = frameCount:GetFont()

	frameCount:SetFont(STANDARD_TEXT_FONT, ANameP_CountFontSize, "OUTLINE")
	frameCount:ClearAllPoints();
	frameCount:SetPoint("BOTTOMRIGHT", -2, 2);

	local frameIcon = ret.icon;
	local frameBorder = ret.border;

	frameIcon:SetTexCoord(.08, .92, .08, .92)
	frameBorder:SetTexture("Interface\\Addons\\asNamePlates\\border.tga");
	frameBorder:SetTexCoord(0.08,0.08, 0.08,0.92, 0.92,0.08, 0.92,0.92);

	ret.alert = false;

	return ret;

end

local function setFrame(frame, texture, count, expirationTime, duration, color)

	local frameIcon = frame.icon;
	frameIcon:SetTexture(texture);

	local frameCount = frame.count;
	local frameCooldown = frame.cooldown;

	if count and  (count > 1) then
		frameCount:SetText(count);
		frameCount:Show();
		frameCooldown:SetDrawSwipe(false);
	else
		frameCount:Hide();
		frameCooldown:SetDrawSwipe(true);
	end

	asCooldownFrame_Set(frameCooldown, expirationTime - duration, duration, duration > 0, true);
	if ANameP_CooldownFontSize > 0 then
		frameCooldown:SetHideCountdownNumbers(false);
	end

	local frameBorder = frame.border;
	frameBorder:SetVertexColor(color.r, color.g, color.b);
end

local function setSize(frame, size)

	frame:SetWidth(size + 2);
	frame:SetHeight((size + 2) * ANameP_Size_Rate);

end

local function updateDebuffAnchor(frames, index, anchorIndex, size, offsetX, right, parent)

	local buff = frames[index];
	local point1 = "BOTTOMLEFT";
	local point2 = "BOTTOMLEFT";
	local point3 = "BOTTOMRIGHT";

	if (right == false) then
		point1 = "BOTTOMRIGHT";
		point2 = "BOTTOMRIGHT";
		point3 = "BOTTOMLEFT";
		offsetX = -offsetX;
	end

	buff:ClearAllPoints();

	if parent.downbuff then
		if ( index == 1 ) then
			buff:SetPoint("TOPLEFT", parent, "BOTTOMLEFT", 0, 0);
		elseif ( index == (debuffs_per_line + 1) ) then
			buff:SetPoint("TOPLEFT", frames[1], "BOTTOMLEFT", 0, -4);
		else
			buff:SetPoint(point1, frames[index -1], point3, offsetX, 0);
		end
	else
		if ( index == 1 ) then
			buff:SetPoint("BOTTOMLEFT", parent, "TOPLEFT", 0, 0);
		elseif ( index == (debuffs_per_line + 1) ) then
			buff:SetPoint("BOTTOMLEFT", frames[1], "TOPLEFT", 0, 4);
		else
			buff:SetPoint(point1, frames[index-1], point3, offsetX, 0);
		end
	end

	setSize(buff, size);
	buff:Show();
	if buff.alert then
		lib.ButtonGlow_Start(buff);
	else
		lib.ButtonGlow_Stop(buff);
	end
end

local function Comparison(AIndex, BIndex)
	local AID = AIndex[2];
	local BID = BIndex[2];

	if (AID ~= BID) then
		return AID > BID;
	end

	return false;
end

local classbar_height = nil;
local function GetClassBarHeight()

	if not classbar_height then
		local class = NamePlateDriverFrame:GetClassNameplateBar();

		if class then
			classbar_height = class:GetHeight();
		else
			classbar_height = 0;
		end
	end

	return classbar_height;
end



local function updateAuras(self, unit, filter, showbuff, helpful, showdebuff)

	local numDebuffs = 1;
	local size_list = {};
	local parent = self:GetParent():GetParent();
	local healthBar = parent.UnitFrame.healthBar;

	self.unit = unit;
	self.reflesh_time = nil;

	local bShowCC = false;

	if not self.unit then
		return
	end

	local icon_size = self.icon_size;

	if showbuff and not showdebuff then
		local aShowIdx = {};
		local aShowNum = 1;

		for i = 1, BUFF_MAX_DISPLAY do
			if (filter == "NONE" and self.buffList[i]) then
				self.buffList[i]:Hide();
				self:Hide();
				return;
			end

			local name,  texture, count, debuffType, duration, expirationTime, caster, isStealable, nameplateShowPersonal, spellId, _, _, _, nameplateShowAll = UnitAura(unit, i, "HELPFUL");
			if name then
				local show = false;
				local bPVP = false;

				if UnitIsPlayer(unit) then
					if ANameP_PVPBuffList[spellId] then
						show = true;
					end
					bPVP = true;
				else
					if ANameP_PVEBuffList and  ANameP_PVEBuffList[spellId] then
						show = true;
					elseif isStealable then
						show = true;
					elseif caster and UnitIsUnit(unit, caster) then
						show = true;
					end

					if show and ANameP_BlackList[name] then
						show = false;
					end
				end

				if show then
					if UnitIsPlayer(unit) then
						aShowIdx[aShowNum] = {i, 0};
						aShowNum =aShowNum  + 1;
						-- 일단 1개만
						if numDebuffs + aShowNum - 1 > ANameP_MaxBuff then
							break;
						end
					else
						if ANameP_PVEBuffList and ANameP_PVEBuffList[spellId] then
							aShowIdx[aShowNum] = {i, ANameP_PVEBuffList[spellId]};
						elseif isStealable then
							aShowIdx[aShowNum] = {i, 4};
						else
							aShowIdx[aShowNum] = {i, 1};
						end

						aShowNum =aShowNum  + 1;
						-- PVE 는 계속
					end
				end
			else
				break;
			end
		end

		if ANameP_ShowListFirst then
			-- sort
			table.sort(aShowIdx, Comparison);
		end

		for v = 1, aShowNum - 1 do
			if numDebuffs  > ANameP_MaxBuff  then
				break;
			end

			local i = aShowIdx[v][1];
			local name,  texture, count, debuffType, duration, expirationTime, caster, isStealable, nameplateShowPersonal, spellId, _, _, _, nameplateShowAll = UnitAura(unit, i, "HELPFUL");

			if (not self.buffList[numDebuffs]) then
				self.buffList[numDebuffs] = createDebuffFrame(self);
			end

			local frame = self.buffList[numDebuffs];
			frame.alert = false;

			if bPVP == true then
				size_list[numDebuffs] = icon_size + 2;
			else
				size_list[numDebuffs] = icon_size;
			end

			setSize (frame, size_list[numDebuffs]);

			local color = {r = 1, g = 1, b = 1};
			setFrame(self.buffList[numDebuffs], texture, count, expirationTime, duration, color);
			if isStealable then
				frame.alert = true;
			end

			numDebuffs = numDebuffs + 1;
		end
	end

	if not showdebuff then
		local aShowIdx = {};
		local aShowNum = 1;

		for i = 1, BUFF_MAX_DISPLAY do
			if (filter == "NONE" and self.buffList[i]) then
				self.buffList[i]:Hide();
				self:Hide();
				return;
			end

			if numDebuffs + aShowNum - 1 > ANameP_MaxDebuff then
				break;
			end

			local name,  texture, count, debuffType, duration, expirationTime, caster, _, nameplateShowPersonal, spellId, _, isBossDebuff, _, nameplateShowAll  = UnitAura(unit, i, filter);
			if name then
				-- Default 로 Show List 에 있는 것만 보임
				local show = PLAYER_UNITS[caster] and (ANameP_ShowList and ANameP_ShowList[name]);

				-- Player 일 경우
				if  UnitIsUnit("player", unit) then
					if options.ANameP_ShowPlayerBuffAll == false then
						show = nameplateShowPersonal;
					else
						if ANameP_ShowPlayerBuff and PLAYER_UNITS[caster] and duration > 0 and duration <= ANameP_BuffMaxCool then
							show = true;
						end
					end
				else
					if options.ANameP_ShowMyAll and PLAYER_UNITS[caster] then
						if helpful then
							if duration > 0 and duration <= ANameP_BuffMaxCool then
								show = true;
							end
						else
							show = true;
						end
					elseif not options.ANameP_ShowMyAll and PLAYER_UNITS[caster] and (nameplateShowPersonal or (options.ANameP_ShowKnownSpell  and KnownSpellList[name])) then
						show = true;
					end

					if ANameP_ShowPVPDebuff and nameplateShowAll and duration <= 10 then

						if ANameP_ShowCCDebuff and bShowCC == false then
							show = false;
							bShowCC = true;

							local color = { r = 0.3, g = 0.3, b = 0.3 };

							setFrame(self.CCdebuff, texture, count, expirationTime, duration, color);

							self.CCdebuff:ClearAllPoints();
							if self.casticon:IsShown() then
								self.CCdebuff:SetPoint("LEFT", self.casticon, "RIGHT", 1, 0);
							else
								self.CCdebuff:SetPoint("LEFT", healthBar, "RIGHT", 1, 0);
							end
							self.CCdebuff:Show();
						else
							show = true;
						end
					end

					if isBossDebuff or ( caster and  not UnitIsPlayer(unit) and UnitIsUnit(unit, caster)) then
						show = true;
					end
				end

				if show  and ANameP_BlackList[name] then
					show = false;
				end

				if show then
					if ANameP_ShowList and ANameP_ShowList[name]  then
						aShowIdx[aShowNum] = {i, ANameP_ShowList[name][2]};
					else
						aShowIdx[aShowNum] = {i, 0};
					end
					aShowNum =aShowNum  + 1;
				end
			else
				break;
			end
		end

		if ANameP_ShowListFirst then
			-- sort
			table.sort(aShowIdx, Comparison);
		end

		self.debuffColor = nil;

		for v = 1 , aShowNum - 1 do
			local i = aShowIdx[v][1];
			local name,  texture, count, debuffType, duration, expirationTime, caster, _, nameplateShowPersonal, spellId, _, isBossDebuff, _, nameplateShowAll = UnitAura(unit, i, filter);
			local alert = false;
			local showlist_time = 0;

			if ANameP_ShowList and ANameP_ShowList[name] then
				showlist_time = ANameP_ShowList[name][1];

				if  showlist_time >= 0  then
					local alert_time = expirationTime - showlist_time;

					if (GetTime() >= alert_time) and duration > 0  then
						alert = true;
					else
						if self.reflesh_time and self.reflesh_time >= alert_time then
							self.reflesh_time = alert_time;
						elseif self.reflesh_time == nil then
							self.reflesh_time = alert_time;
						end

						if ANameP_ShowList[name][3] and ANameP_ShowList[name][3] == true then
							self.debuffColor = true;
						end
					end
				end
			end

			if (not self.buffList[numDebuffs]) then
				self.buffList[numDebuffs] = createDebuffFrame(self)
			end

			local frame = self.buffList[numDebuffs];
			frame.alert = false;
			size_list[numDebuffs] = icon_size;

			if (showlist_time) then
				size_list[numDebuffs] = icon_size;
			end

			if not PLAYER_UNITS[caster] then
				size_list[numDebuffs] = icon_size - 2;
			end

			if nameplateShowAll then
				size_list[numDebuffs] = icon_size + ANameP_PVP_Debuff_Size_Rate;
			end

			if isBossDebuff then
				size_list[numDebuffs] = icon_size + ANameP_PVP_Debuff_Size_Rate;
			end

			setSize (frame, size_list[numDebuffs]);

			local color =DebuffTypeColor["none"];

			if helpful then
				color =DebuffTypeColor["Disease"];
			end

			if ( not UnitIsUnit("player", unit) and not PLAYER_UNITS[caster]) then
				color = { r = 0.3, g = 0.3, b = 0.3 };
			end

			if debuffType then
				color = DebuffTypeColor[debuffType];
			end

			setFrame(self.buffList[numDebuffs], texture, count, expirationTime, duration, color);


			if alert and duration > 0  then
				frame.alert = true;
			end

			numDebuffs = numDebuffs + 1;
		end
	end

	if not showdebuff then
		for i = 1, numDebuffs - 1 do
			updateDebuffAnchor(self.buffList, i, i - 1, size_list[i], 1, true, self);
		end
	end

	for i = numDebuffs, ANameP_MaxDebuff do
		if ( self.buffList[i] ) then
			self.buffList[i]:Hide();
			lib.ButtonGlow_Stop(self.buffList[i]);
		end
	end

	if numDebuffs > 1 then
		self:Show();
	end

	if bShowCC == false then
		self.CCdebuff:Hide();
	end
end

local function updateUnitAuras(unit)
	local nameplate = C_NamePlate.GetNamePlateForUnit(unit, issecure());
	if (nameplate and nameplate.asNamePlates and not nameplate:IsForbidden()) then
		if nameplate.asNamePlates.checkaura then
			updateAuras(nameplate.asNamePlates, nameplate.namePlateUnitToken, nameplate.asNamePlates.filter, nameplate.asNamePlates.showbuff, nameplate.asNamePlates.helpful, nameplate.asNamePlates.showdebuff);
		else
			nameplate.asNamePlates:Hide();
		end
	end
end

local function updateTargetNameP(self)

	if not self.unit or not self.checkaura then
		return;
	end

	local parent = self:GetParent():GetParent();

    if not parent or not parent.UnitFrame or parent.UnitFrame:IsForbidden()  then
		return;
    end

	local UnitFrame = parent.UnitFrame;
	local healthBar = UnitFrame.healthBar;

    if not healthBar then
		return;
    end

	local orig_height = self.orig_height
	local cast_height = 8;

	if UnitFrame.castBar then
		cast_height = UnitFrame.castBar:GetHeight();
	end

	if orig_height == nil then
		return;
	end

	local casticon = self.casticon;
	local height = orig_height;
	local base_y = ANameP_TargetBuffY;

	if UnitFrame.name:IsShown() then
		base_y = base_y + UnitFrame.name:GetHeight();
	end

	if UnitIsUnit(self.unit, "target") then

		height = orig_height + ANameP_TargetHealthBarHeight;
		self.healthtext:Show();

		if casticon then
			casticon:SetWidth((height + cast_height + 2) * 1.2);
			casticon:SetHeight(height + cast_height + 2);
			casticon.border:SetVertexColor(1,1,1);
		end

		if GetCVarBool("nameplateResourceOnTarget") then
			base_y = base_y +  GetClassBarHeight();
		end
	elseif UnitIsUnit(self.unit, "player") then
		self.alerthealthbar = false;
		height = orig_height + ANameP_TargetHealthBarHeight;
		self.healthtext:Show();
	else
		height = orig_height;
		self.healthtext:Hide();

		if casticon then
			casticon:SetWidth((height + cast_height + 2) * 1.2);
			casticon:SetHeight(height + cast_height + 2);
			casticon.border:SetVertexColor(0,0,0);
		end

		if UnitFrame.name:IsShown() then
			base_y = base_y + 4;
		end
	end

	--Healthbar 크기
	healthBar:SetHeight(height);

	--버프 Position
	self:ClearAllPoints();
	if UnitIsUnit(self.unit, "player") then

		if self.downbuff then
			self:SetPoint("TOPLEFT", ClassNameplateManaBarFrame, "BOTTOMLEFT", 0, playerbuffposition );
		else
			self:SetPoint("BOTTOMLEFT", healthBar, "TOPLEFT", 0, base_y);
		end
		-- 크기 조정이 안된다.
		--ClassNameplateManaBarFrame:SetHeight(height);

		if UnitFrame.BuffFrame then
			UnitFrame.BuffFrame:Hide();
		end
	else
		self:SetPoint("BOTTOMLEFT", healthBar, "TOPLEFT", 0, base_y);
		if UnitFrame.BuffFrame then
			UnitFrame.BuffFrame:Hide();
		end
	end

end

local function updateUnitHealthText(self, unit)
	local value;
	local valueMax;
	local valuePct;
	local namePlateFrameBase = C_NamePlate.GetNamePlateForUnit(unit, issecure());
	if not namePlateFrameBase then
		return;
	end
	local frame = namePlateFrameBase.asNamePlates;

	if not frame then
		return;
	end

	value = UnitHealth(unit);
	valueMax = UnitHealthMax(unit);

	if valueMax > 0 then
		valuePct =  (math.ceil((value / valueMax) * 100));
	end

	if (valueMax <= 300) then
		valuePct = value;
	end

	if valuePct > 0 then
		frame.healthtext:SetText(valuePct);
	else
		frame.healthtext:SetText("");
	end

	if valuePct <= lowhealthpercent then
		frame.healthtext:SetTextColor(1, 0.5, 0.5, 1);
	elseif valuePct > 0 then
		frame.healthtext:SetTextColor(1, 1, 1, 1);
	end
end

-- Healthbar 색상 처리부
local function setColoronStatusBar(self, r, g, b)

	local parent = self:GetParent():GetParent();

    if not parent or not parent.UnitFrame or parent.UnitFrame:IsForbidden()  then
		return;
    end

	local healthBar = parent.UnitFrame.healthBar;

    if not healthBar and healthBar:IsForbidden() then
		return;
    end

	if ( r ~= self.r or g ~= self.g or b ~= self.b ) then
		healthBar:SetStatusBarColor(r, g, b);
		self.r, self.g, self.b = r, g, b;
	end
end


local function asCompactUnitFrame_UpdateHealthColor(frame, asNameplates)
	local r, g, b;
	if ( not UnitIsConnected(frame.unit) ) then
		--Color it gray
		r, g, b = 0.5, 0.5, 0.5;
	elseif (UnitIsDead(frame.unit)) then
		--Color it gray
		r, g, b = 0.5, 0.5, 0.5;
		-- Also hide the health bar
		frame.hideHealthbar = true;
	else
		--Try to color it by class.
		local localizedClass, englishClass = UnitClass(frame.unit);
		local classColor = RAID_CLASS_COLORS[englishClass];
			--debug
			--classColor = RAID_CLASS_COLORS["PRIEST"];
			if ( (frame.optionTable.allowClassColorsForNPCs or UnitIsPlayer(frame.unit) or UnitTreatAsPlayerForDisplay(frame.unit)) and classColor and frame.optionTable.useClassColors ) then
				-- Use class colors for players if class color option is turned on
				r, g, b = classColor.r, classColor.g, classColor.b;
			elseif ( CompactUnitFrame_IsTapDenied(frame) ) then
				-- Use grey if not a player and can't get tap on unit
				r, g, b = 0.9, 0.9, 0.9;
			elseif ( frame.optionTable.colorHealthBySelection ) then
				-- Use color based on the type of unit (neutral, etc.)
				if ( frame.optionTable.considerSelectionInCombatAsHostile and CompactUnitFrame_IsOnThreatListWithPlayer(frame.displayedUnit) ) then
					r, g, b = 1.0, 0.0, 0.0;
				elseif ( UnitIsPlayer(frame.displayedUnit) and UnitIsFriend("player", frame.displayedUnit) ) then
					-- We don't want to use the selection color for friendly player nameplates because
					-- it doesn't show player health clearly enough.
					r, g, b = 0.667, 0.667, 1.0;
				else
					r, g, b = UnitSelectionColor(frame.unit, frame.optionTable.colorHealthWithExtendedColors);
				end
			elseif ( UnitIsFriend("player", frame.unit) ) then
				r, g, b = 0.0, 1.0, 0.0;
			else
				r, g, b = 1.0, 0.0, 0.0;
			end

	end
	setColoronStatusBar(asNameplates, r, g, b);

	if (frame.optionTable.colorHealthWithExtendedColors) then
		frame.selectionHighlight:SetVertexColor(r, g, b);
	else
		frame.selectionHighlight:SetVertexColor(1, 1, 1);
	end
end


local function updateHealthbarColor(self)
	--unit name 부터
	if not self.unit or not self.checkcolor then
		return;
	end

	local unit = self.unit;

	local parent = self:GetParent():GetParent();

    if not parent or not parent.UnitFrame or parent.UnitFrame:IsForbidden()  then
		return;
    end
	local UnitFrame  = parent.UnitFrame;
	local healthBar = parent.UnitFrame.healthBar;

    if not healthBar and healthBar:IsForbidden() then
		return;
    end

	local shouldshow = false;
	-- ColorLevel.Name;
	local unitname = GetUnitName(self.unit);

	if unitname and ANameP_AlertList[unitname] then
		if self.colorlevel < ColorLevel.Name then
			self.colorlevel = ColorLevel.Name;
			setColoronStatusBar(self, ANameP_AlertList[unitname][1], ANameP_AlertList[unitname][2], ANameP_AlertList[unitname][3]);
		end

		if ANameP_AlertList[unitname][4] == 1 then
			lib.PixelGlow_Start(healthBar);
			self.alerthealthbar = true;
		end
		return;
	end

	-- Cast Interrupt
	local status = UnitThreatSituation("player", self.unit);

	if self.interruptalert and self.interruptalert == 1 and status then
		lib.PixelGlow_Start(healthBar, {0, 1, 0.32, 1});
	else
		lib.PixelGlow_Stop(healthBar);
	end


	--Target Check 
	local isTargetPlayer = UnitIsUnit(unit .. "target", "player");

	if (isTargetPlayer) then
		if self.colorlevel < ColorLevel.Target then
			self.colorlevel = ColorLevel.Target;
			setColoronStatusBar(self, options.ANameP_AggroTargetColor.r, options.ANameP_AggroTargetColor.g, options.ANameP_AggroTargetColor.b);
		end
		return;
	end

	-- Aggro Check
	local aggrocolor;

	if status and options.ANameP_AggroShow then
		local tanker = IsPlayerEffectivelyTank();
		if tanker then
			if status >= 2 then
				-- Tanking
				aggrocolor = options.ANameP_AggroColor;
			else
				aggrocolor = options.ANameP_TankAggroLoseColor;
				if #tanklist > 0 then
					for _, othertank in ipairs(tanklist) do
						if UnitIsUnit(self.unit.."target", othertank ) and not UnitIsUnit(self.unit.."target", "player" ) then
							aggrocolor = options.ANameP_TankAggroLoseColor2;
							break;
						end
					end
				end
			end
			self.colorlevel = ColorLevel.Aggro;
			setColoronStatusBar(self, aggrocolor.r, aggrocolor.g, aggrocolor.b);
			return;
		else -- Tanker가 아닐때
			if status >= 1 then
				-- Tanking
				aggrocolor = options.ANameP_AggroColor;
				self.colorlevel = ColorLevel.Aggro;
				setColoronStatusBar(self, aggrocolor.r, aggrocolor.g, aggrocolor.b);
				return;
			end
		end
	end

	if lowhealthpercent > 0  then
		--Lowhealth 처리부
		local value = UnitHealth(unit);
		local valueMax = UnitHealthMax(unit);
		local valuePct = 0;

		if valueMax > 0 then
			valuePct =  (math.ceil((value / valueMax) * 100));
		end

		if valuePct <= lowhealthpercent then
			setColoronStatusBar(self, options.ANameP_LowHealthColor.r, options.ANameP_LowHealthColor.g, options.ANameP_LowHealthColor.b);
			self.colorlevel = ColorLevel.Lowhealth;
			return;
		end
	end

	-- Debuff Color
	if self.debuffColor then
		if self.colorlevel < ColorLevel.Debuff then
			self.colorlevel = ColorLevel.Debuff;
			setColoronStatusBar(self, options.ANameP_DebuffColor.r, options.ANameP_DebuffColor.g, options.ANameP_DebuffColor.b);
		end
		return;
	else
		if self.colorlevel == ColorLevel.Debuff then
			self.colorlevel = ColorLevel.Reset;
		end
	end

	if status then
		if #tanklist > 0 then
			for _, othertank in ipairs(tanklist) do
				if UnitIsUnit(self.unit.."target", othertank ) and not UnitIsUnit(self.unit.."target", "player" ) then
					aggrocolor = options.ANameP_TankAggroLoseColor2;
					self.colorlevel = ColorLevel.Custom;
					setColoronStatusBar(self, aggrocolor.r, aggrocolor.g, aggrocolor.b);
					return;
				end
			end
		end
	end

	if UnitIsUnit(self.unit.."target", "pet" )  then
		aggrocolor = options.ANameP_TankAggroLoseColor3;
		self.colorlevel = ColorLevel.Custom;
		setColoronStatusBar(self, aggrocolor.r, aggrocolor.g, aggrocolor.b);
		return;
	end

	-- None
	if self.colorlevel > ColorLevel.None then
		self.colorlevel = ColorLevel.None;
		asCompactUnitFrame_UpdateHealthColor(parent.UnitFrame, self);
	end

	return;
end

local function updatePVPAggro(self)

	if not ANameP_PVPAggroShow then
		return
	end

	if not self.unit then
		return
	end

	local unit = self.unit;
	local parent = self:GetParent():GetParent();

	if parent.UnitFrame:IsForbidden() then
		return;
	end

	local isTargetPlayer = UnitIsUnit(unit .. "target", "player");

	if ( isTargetPlayer) then
		self.aggro1:SetTextColor(1, 0, 0, 1);

		self.aggro1:SetText("▶");
		self.aggro1:Show();

		self.aggro2:SetTextColor(1, 0, 0, 1);

		self.aggro2:SetText("◀");
		self.aggro2:Show();
	else
		self.aggro1:Hide();
		self.aggro2:Hide();
	end
end

local function asCheckTalent(name)
	local specID = PlayerUtil.GetCurrentSpecID();

    local configID = C_ClassTalents.GetActiveConfigID();

	if not (configID) then
		return false;
	end
    local configInfo = C_Traits.GetConfigInfo(configID);
    local treeID = configInfo.treeIDs[1];

    local nodes = C_Traits.GetTreeNodes(treeID);

    for _, nodeID in ipairs(nodes) do
        local nodeInfo = C_Traits.GetNodeInfo(configID, nodeID);
        if nodeInfo.currentRank and nodeInfo.currentRank > 0 then
            local entryID = nodeInfo.activeEntry and nodeInfo.activeEntry.entryID and nodeInfo.activeEntry.entryID;
            local entryInfo = entryID and C_Traits.GetEntryInfo(configID, entryID);
            local definitionInfo = entryInfo and entryInfo.definitionID and C_Traits.GetDefinitionInfo(entryInfo.definitionID);

            if definitionInfo ~= nil then
                local talentName = TalentUtil.GetTalentName(definitionInfo.overrideName, definitionInfo.spellID);
				--print(string.format("%s %d/%d", talentName, nodeInfo.currentRank, nodeInfo.maxRanks));;
				if name == talentName then
					return true;
				end
            end
        end
    end
	return false;
end

local function initAlertList()

	local spec = GetSpecialization();
	local localizedClass, englishClass = UnitClass("player");
	local listname;

	ANameP_ShowList = nil;

	if spec then
		listname = "ANameP_ShowList_" .. englishClass .. "_" .. spec;
	end

	if options[listname] then
		ANameP_ShowList = CopyTable(options[listname]);
	else
		ANameP_ShowList = {};
	end

	ANameP_HealerGuid = {};

	lowhealthpercent = 0;

	if options.ANameP_LowHealthAlert then
		if (englishClass == "MAGE") then
			if (asCheckTalent("불타는 손길")) then
				lowhealthpercent = 30;
			end
		end

		if (englishClass == "HUNTER") then
			if (asCheckTalent("마무리 사격")) then
				lowhealthpercent = 20;
			end
		end


		if (englishClass == "WARRIOR") then
			if (asCheckTalent("대학살")) then
				lowhealthpercent = 35;
			else
				lowhealthpercent = 20;
			end
		end
	end
end

local unit_guid_list = {};

local Aggro_Y = -5;

local function isDangerousSpell(spellId, unit)
    if spellId and ANameP_DangerousSpellList[spellId] then
    	return true
     end
    return false
end

local function checkSpellCasting(self)

	local unit = self.unit;
	local name,  text, texture, startTime, endTime, isTradeSkill, castID, notInterruptible, spellid = UnitCastingInfo(unit);
	if not name then
		name,  text, texture, startTime, endTime, isTradeSkill, notInterruptible, spellid = UnitChannelInfo(unit);
	end

	if self.casticon then
		local frameIcon = self.casticon.icon;
		if name and frameIcon then
			local isDanger = isDangerousSpell (spellid, unit);
			frameIcon:SetTexture(texture);
			self.casticon:Show();
			if  isDanger then
				lib.PixelGlow_Start(self.casticon, {0, 1, 0.32, 1});
				self.interruptalert = 1;
			elseif notInterruptible == false then
				lib.PixelGlow_Start(self.casticon);
				self.interruptalert = 2;
			else
				lib.PixelGlow_Stop(self.casticon);
				self.interruptalert = nil;
			end
		else
			self.casticon:Hide();
			lib.PixelGlow_Stop(self.casticon);
			self.interruptalert = nil;
		end
	end
end

local function asNamePlates_OnEvent(self, event, ...)
	if ( event == "UNIT_THREAT_SITUATION_UPDATE" or event == "UNIT_THREAT_LIST_UPDATE" ) then
		updateHealthbarColor(self)
	elseif( event == "PLAYER_TARGET_CHANGED") then
		updateTargetNameP(self);
	else
		checkSpellCasting(self);
		updateHealthbarColor(self);
	end
end

local function createNamePlate(namePlateFrameBase)
end

local namePlateVerticalScale = nil;
local g_orig_height = nil;

local function addNamePlate(namePlateUnitToken)

	local namePlateFrameBase = C_NamePlate.GetNamePlateForUnit(namePlateUnitToken, issecure());

	if not namePlateFrameBase or namePlateFrameBase.UnitFrame:IsForbidden() then
		return;
	end

	local unitFrame = namePlateFrameBase.UnitFrame;
	local healthbar = namePlateFrameBase.UnitFrame.healthBar;

	if UnitIsUnit("player", namePlateUnitToken) then
		if not ANameP_ShowPlayerBuff then
			if namePlateFrameBase.asNamePlates then
				namePlateFrameBase.asNamePlates.checkaura = false;
				namePlateFrameBase.asNamePlates.checkcolor = false;
				namePlateFrameBase.asNamePlates.checkpvptarget = false;
				namePlateFrameBase.asNamePlates:Hide();
				namePlateFrameBase.asNamePlates.CCdebuff:Hide();
				namePlateFrameBase.asNamePlates.interruptalert = nil;
				namePlateFrameBase.asNamePlates.debuffColor = nil;
				unitFrame.BuffFrame:SetAlpha(1);
			end
			return;
		end
	else
		local reaction = UnitReaction("player", namePlateUnitToken);
		if reaction and reaction <= 4 then
			-- Reaction 4 is neutral and less than 4 becomes increasingly more hostile
		elseif UnitIsPlayer(namePlateUnitToken) then
			if namePlateFrameBase.asNamePlates then
				namePlateFrameBase.asNamePlates.checkaura = false;
				namePlateFrameBase.asNamePlates.checkcolor = false;
				namePlateFrameBase.asNamePlates.checkpvptarget = false;
				namePlateFrameBase.asNamePlates:Hide();
				namePlateFrameBase.asNamePlates.healthtext:Hide();
				namePlateFrameBase.asNamePlates.CCdebuff:Hide();
				namePlateFrameBase.asNamePlates.interruptalert = nil;
				namePlateFrameBase.asNamePlates.debuffColor = nil;
				unitFrame.BuffFrame:SetAlpha(1);
			end
			return;
		end
	end

	if not namePlateFrameBase.asNamePlates then
		namePlateFrameBase.asNamePlates = CreateFrame("Frame", nil, unitFrame);
	else
		if namePlateFrameBase.asNamePlates.colorlevel > ColorLevel.None  then
			namePlateFrameBase.asNamePlates.r = nil; -- 무조건 Recover
			asCompactUnitFrame_UpdateHealthColor(unitFrame, namePlateFrameBase.asNamePlates);
		end
    end

	namePlateFrameBase.asNamePlates:EnableMouse(false);

	if not namePlateFrameBase.asNamePlates.buffList then
		namePlateFrameBase.asNamePlates.buffList = {};
	end
	namePlateFrameBase.asNamePlates.unit = nil;
	namePlateFrameBase.asNamePlates.reflesh_time = nil;
	namePlateFrameBase.asNamePlates.update = 0;
	namePlateFrameBase.asNamePlates.alerthealthbar = false;
	namePlateFrameBase.asNamePlates.filter = nil;
	namePlateFrameBase.asNamePlates.helpful = false;
	namePlateFrameBase.asNamePlates.checkaura = false;
	namePlateFrameBase.asNamePlates.showbuff = false;
	namePlateFrameBase.asNamePlates.downbuff = false;
	namePlateFrameBase.asNamePlates.checkpvptarget = false;
	namePlateFrameBase.asNamePlates.colorlevel = ColorLevel.None;
	namePlateFrameBase.asNamePlates.bhideframe = false;
	namePlateFrameBase.asNamePlates.isshown = nil;
	namePlateFrameBase.asNamePlates.originalcolor = {r = healthbar.r, g = healthbar.g, b = healthbar.b};
	namePlateFrameBase.asNamePlates.checkcolor = false;
	namePlateFrameBase.asNamePlates.debuffColor = nil;

	namePlateFrameBase.asNamePlates:UnregisterEvent("UNIT_THREAT_SITUATION_UPDATE");
	namePlateFrameBase.asNamePlates:UnregisterEvent("PLAYER_TARGET_CHANGED");
	namePlateFrameBase.asNamePlates:UnregisterEvent("UNIT_SPELLCAST_START");
	namePlateFrameBase.asNamePlates:UnregisterEvent("UNIT_SPELLCAST_CHANNEL_START");
	namePlateFrameBase.asNamePlates:UnregisterEvent("UNIT_SPELLCAST_SUCCEEDED");
	namePlateFrameBase.asNamePlates:UnregisterEvent("UNIT_SPELLCAST_INTERRUPTED");
	namePlateFrameBase.asNamePlates:UnregisterEvent("UNIT_SPELLCAST_DELAYED");
	namePlateFrameBase.asNamePlates:UnregisterEvent("UNIT_SPELLCAST_CHANNEL_STOP");
	namePlateFrameBase.asNamePlates:UnregisterEvent("UNIT_SPELLCAST_STOP");
	namePlateFrameBase.asNamePlates:UnregisterEvent("UNIT_SPELLCAST_FAILED");
	namePlateFrameBase.asNamePlates:SetScript("OnEvent", nil);


	local Size = ANameP_AggroSize;

	if namePlateVerticalScale ~= tonumber(GetCVar("NamePlateVerticalScale")) then
		namePlateVerticalScale = tonumber(GetCVar("NamePlateVerticalScale"));
		g_orig_height = healthbar:GetHeight();
	end

	if namePlateVerticalScale > 1.0 then
		Aggro_Y = -1
		Size = ANameP_AggroSize + 2
		debuffs_per_line = ANameP_DebuffsPerLine + 1;
	else
		debuffs_per_line = ANameP_DebuffsPerLine;
	end

	ANameP_MaxDebuff = debuffs_per_line * 2;
	Aggro_Y = 0;

	namePlateFrameBase.asNamePlates.orig_height = g_orig_height;

	namePlateFrameBase.asNamePlates:ClearAllPoints();
	namePlateFrameBase.asNamePlates:SetPoint("CENTER", healthbar, "CENTER", 0  , 0)

	if not namePlateFrameBase.asNamePlates.aggro1  then
		namePlateFrameBase.asNamePlates.aggro1 = healthbar:CreateFontString(nil, "OVERLAY");
	end

	namePlateFrameBase.asNamePlates.aggro1:SetFont(STANDARD_TEXT_FONT, Size, "THICKOUTLINE");
    namePlateFrameBase.asNamePlates.aggro1:ClearAllPoints();
	namePlateFrameBase.asNamePlates.aggro1:SetPoint("RIGHT", healthbar, "LEFT", -5  , Aggro_Y)


	if not namePlateFrameBase.asNamePlates.aggro2  then
		namePlateFrameBase.asNamePlates.aggro2 = healthbar:CreateFontString(nil, "OVERLAY");
	end
	namePlateFrameBase.asNamePlates.aggro2:SetFont(STANDARD_TEXT_FONT, Size, "THICKOUTLINE");
    namePlateFrameBase.asNamePlates.aggro2:ClearAllPoints();
	namePlateFrameBase.asNamePlates.aggro2:SetPoint("LEFT", healthbar, "RIGHT", 0, Aggro_Y)

	if not namePlateFrameBase.asNamePlates.healer  then
		namePlateFrameBase.asNamePlates.healer = healthbar:CreateFontString(nil, "OVERLAY");
	end
	if ANameP_HealerSize > 0 then
		namePlateFrameBase.asNamePlates.healer:SetFont(STANDARD_TEXT_FONT, ANameP_HealerSize, "THICKOUTLINE");
	else
		namePlateFrameBase.asNamePlates.healer:SetFont(STANDARD_TEXT_FONT, 1, "THICKOUTLINE");
	end
    namePlateFrameBase.asNamePlates.healer:ClearAllPoints();
	namePlateFrameBase.asNamePlates.healer:SetPoint("RIGHT", healthbar, "LEFT", -5  , Aggro_Y)
	namePlateFrameBase.asNamePlates.healer:SetText("★");
	namePlateFrameBase.asNamePlates.healer:SetTextColor(0, 1, 0, 1);
	namePlateFrameBase.asNamePlates.healer:Hide();

	if not namePlateFrameBase.asNamePlates.healthtext then
		namePlateFrameBase.asNamePlates.healthtext = healthbar:CreateFontString(nil, "OVERLAY");
	end

	namePlateFrameBase.asNamePlates.healthtext:SetFont(STANDARD_TEXT_FONT, ANameP_HeathTextSize, "OUTLINE");
	namePlateFrameBase.asNamePlates.healthtext:ClearAllPoints();
	namePlateFrameBase.asNamePlates.healthtext:SetPoint("CENTER", healthbar, "CENTER", 0  , 0)

	if unitFrame.castBar then
		if not namePlateFrameBase.asNamePlates.casticon  then
			namePlateFrameBase.asNamePlates.casticon = CreateFrame("Frame", nil, unitFrame.castBar, "asNamePlatesBuffFrameTemplate");
		end
		namePlateFrameBase.asNamePlates.casticon:EnableMouse(false);
        namePlateFrameBase.asNamePlates.casticon:ClearAllPoints();
		namePlateFrameBase.asNamePlates.casticon:SetPoint("BOTTOMLEFT", unitFrame.castBar, "BOTTOMRIGHT", 0, 1);
		namePlateFrameBase.asNamePlates.casticon:SetWidth(13);
		namePlateFrameBase.asNamePlates.casticon:SetHeight(13);

		local frameIcon = namePlateFrameBase.asNamePlates.casticon.icon;
		local frameBorder = namePlateFrameBase.asNamePlates.casticon.border;

		frameIcon:SetTexCoord(.08, .92, .08, .92);
		frameBorder:SetTexture("Interface\\Addons\\asNamePlates\\border.tga");
		frameBorder:SetTexCoord(0.08,0.08, 0.08,0.92, 0.92,0.08, 0.92,0.92);
		namePlateFrameBase.asNamePlates.casticon:Hide();
		namePlateFrameBase.asNamePlates.interruptalert = nil;
	end


	if not namePlateFrameBase.asNamePlates.CCdebuff  then
		namePlateFrameBase.asNamePlates.CCdebuff = CreateFrame("Frame", nil, unitFrame.healthBar, "asNamePlatesBuffFrameTemplate");
	end
	namePlateFrameBase.asNamePlates.CCdebuff:EnableMouse(false);
    namePlateFrameBase.asNamePlates.CCdebuff:ClearAllPoints();
	namePlateFrameBase.asNamePlates.CCdebuff:SetPoint("LEFT", namePlateFrameBase.asNamePlates.casticon, "RIGHT", 1, 0);
	namePlateFrameBase.asNamePlates.CCdebuff:SetWidth(ANameP_CCDebuffSize * 1.2);
	namePlateFrameBase.asNamePlates.CCdebuff:SetHeight(ANameP_CCDebuffSize);

	local frameIcon = namePlateFrameBase.asNamePlates.CCdebuff.icon;
	local frameBorder = namePlateFrameBase.asNamePlates.CCdebuff.border;

	frameIcon:SetTexCoord(.08, .92, .08, .92);
	frameBorder:SetTexture("Interface\\Addons\\asNamePlates\\border.tga");
	frameBorder:SetTexCoord(0.08,0.08, 0.08,0.92, 0.92,0.08, 0.92,0.92);

	for _,r in next,{namePlateFrameBase.asNamePlates.CCdebuff.cooldown:GetRegions()}	do
		if r:GetObjectType()=="FontString" then
			r:SetFont(STANDARD_TEXT_FONT, ANameP_CooldownFontSize,"OUTLINE")
			r:SetPoint("TOP", 0, 4);
			break;
		end
	end

	namePlateFrameBase.asNamePlates.CCdebuff:Hide();

	if namePlateFrameBase.asNamePlates then
		namePlateFrameBase.asNamePlates.unit = namePlateUnitToken;
		namePlateFrameBase.asNamePlates.filter = nil;
		namePlateFrameBase.asNamePlates.helpful = false;
		namePlateFrameBase.asNamePlates.checkaura = false;
		namePlateFrameBase.asNamePlates.showbuff = false;
		namePlateFrameBase.asNamePlates.downbuff = false;
		namePlateFrameBase.asNamePlates.healthtext:Hide();
		namePlateFrameBase.asNamePlates.checkpvptarget = false;
		namePlateFrameBase.asNamePlates.colorlevel = ColorLevel.None;
		namePlateFrameBase.asNamePlates.checkcolor = false;

		for i = 1, ANameP_MaxDebuff do
			if ( namePlateFrameBase.asNamePlates.buffList[i] ) then
				namePlateFrameBase.asNamePlates.buffList[i]:Hide();
			end
		end

        if UnitIsPlayer(namePlateUnitToken) then
			namePlateFrameBase.asNamePlates.colorlevel = ColorLevel.Name;
		else
			local bInstance, RTB_ZoneType = IsInInstance();
			if not (RTB_ZoneType == "pvp" or RTB_ZoneType == "arena") then
				--PVP 에서는 어그로 Check 안함
				namePlateFrameBase.asNamePlates:RegisterUnitEvent("UNIT_THREAT_SITUATION_UPDATE", "player", namePlateUnitToken );
				namePlateFrameBase.asNamePlates:RegisterUnitEvent("UNIT_THREAT_LIST_UPDATE", "player", namePlateUnitToken );
			end

			namePlateFrameBase.asNamePlates:SetScript("OnEvent", asNamePlates_OnEvent);
			namePlateFrameBase.asNamePlates:RegisterEvent("PLAYER_TARGET_CHANGED");
			namePlateFrameBase.asNamePlates:RegisterUnitEvent("UNIT_SPELLCAST_START", namePlateUnitToken);
			namePlateFrameBase.asNamePlates:RegisterUnitEvent("UNIT_SPELLCAST_CHANNEL_START", namePlateUnitToken);
			namePlateFrameBase.asNamePlates:RegisterUnitEvent("UNIT_SPELLCAST_SUCCEEDED", namePlateUnitToken);
			namePlateFrameBase.asNamePlates:RegisterUnitEvent("UNIT_SPELLCAST_INTERRUPTED", namePlateUnitToken);
			namePlateFrameBase.asNamePlates:RegisterUnitEvent("UNIT_SPELLCAST_DELAYED", namePlateUnitToken);
			namePlateFrameBase.asNamePlates:RegisterUnitEvent("UNIT_SPELLCAST_CHANNEL_STOP", namePlateUnitToken);
			namePlateFrameBase.asNamePlates:RegisterUnitEvent("UNIT_SPELLCAST_STOP", namePlateUnitToken);
			namePlateFrameBase.asNamePlates:RegisterUnitEvent("UNIT_SPELLCAST_FAILED", namePlateUnitToken);


		end

		if ANameP_SIZE > 0 then
			namePlateFrameBase.asNamePlates.icon_size = ANameP_SIZE;
		else
			local orig_width = healthbar:GetWidth();
			namePlateFrameBase.asNamePlates.icon_size = (orig_width / debuffs_per_line) - (debuffs_per_line - 1);
		end

		local class = UnitClassification(namePlateUnitToken)

		namePlateFrameBase.asNamePlates.aggro1:ClearAllPoints();

		if class == "worldboss" or class == "elite" then
			namePlateFrameBase.asNamePlates.aggro1:SetPoint("RIGHT", healthbar, "LEFT", -5, Aggro_Y);
		else
			namePlateFrameBase.asNamePlates.aggro1:SetPoint("RIGHT", healthbar, "LEFT", 0, Aggro_Y);
		end

		namePlateFrameBase.asNamePlates.aggro1:Hide();
		namePlateFrameBase.asNamePlates.aggro2:Hide();
		namePlateFrameBase.asNamePlates:SetWidth(1);
		namePlateFrameBase.asNamePlates:SetHeight(1);
		namePlateFrameBase.asNamePlates:SetScale(1);

		local showbuff = false;
		local helpful = false;
		local showhealer = false;
		local checkaura = false;
		local showdebuff = false;
		local checkpvptarget = false;
		local checkcolor = false;
		local filter = nil;

		if UnitIsUnit("player", namePlateUnitToken) then
			--namePlateFrameBase.asNamePlates:Hide();
			if ANameP_ShowPlayerBuff then

				if options.ANameP_ShowPlayerBuffAll == false then
					filter = "HELPFUL|INCLUDE_NAME_PLATE_ONLY";
				else
					filter = "HELPFUL|PLAYER|INCLUDE_NAME_PLATE_ONLY";
				end
				helpful = true;
				checkaura = true;
				unitFrame.BuffFrame:SetAlpha(0);
				unitFrame:UnregisterEvent("UNIT_AURA");
				namePlateFrameBase.asNamePlates:Show();

				-- Resource Text
				if ClassNameplateManaBarFrame and ANameP_Resourcetext == nil then
					ANameP_Resourcetext = ClassNameplateManaBarFrame:CreateFontString(nil, "OVERLAY");
					ANameP_Resourcetext:SetFont(STANDARD_TEXT_FONT, ANameP_HeathTextSize - 3, "OUTLINE");
					ANameP_Resourcetext:SetAllPoints(true);
					ANameP_Resourcetext:SetPoint("CENTER", ClassNameplateManaBarFrame, "CENTER", 0  , 0);
				end

				Buff_Y = ANameP_PlayerBuffY;

				if Buff_Y < 0 then
					namePlateFrameBase.asNamePlates.downbuff = true;
					namePlateFrameBase.asNamePlates:ClearAllPoints();
					if GetCVar("nameplateResourceOnTarget") == "0" then
						playerbuffposition = Buff_Y - GetClassBarHeight();
					else
						playerbuffposition = Buff_Y;
					end
				end
			else
				checkaura = false;
			end
		else
			local reaction = UnitReaction("player", namePlateUnitToken);
			if reaction and reaction <= 4 then
				-- Reaction 4 is neutral and less than 4 becomes increasingly more hostile
				filter = "HARMFUL|INCLUDE_NAME_PLATE_ONLY";
				showbuff = true;

				if UnitIsPlayer(namePlateUnitToken) and ANameP_HealerGuid[UnitGUID(namePlateUnitToken)] then
					showhealer = true;
				end

				if UnitIsPlayer(namePlateUnitToken) then
					checkpvptarget = true;
				else
					checkcolor = true;
				end
				checkaura = true;
				unitFrame.BuffFrame:SetAlpha(0);
				unitFrame:UnregisterEvent("UNIT_THREAT_SITUATION_UPDATE");
				unitFrame:UnregisterEvent("UNIT_THREAT_LIST_UPDATE");
				unitFrame:UnregisterEvent("UNIT_AURA");
				namePlateFrameBase.asNamePlates:Show();
			elseif not namePlateFrameBase:IsForbidden() then
				filter = "HELPFUL|INCLUDE_NAME_PLATE_ONLY|PLAYER";
				helpful = true;
				showbuff = false;

				checkaura = false

				if not showdebuff  and not UnitIsUnit(namePlateUnitToken, "player") and  ANameP_HealerGuid[UnitGUID(namePlateUnitToken)] then
					showhealer = true;
				end
				namePlateFrameBase.asNamePlates:Hide();
			end
		end

		namePlateFrameBase.asNamePlates.filter = filter;
		namePlateFrameBase.asNamePlates.helpful = helpful;
		namePlateFrameBase.asNamePlates.checkaura = checkaura;
		namePlateFrameBase.asNamePlates.showbuff = showbuff;
		namePlateFrameBase.asNamePlates.showdebuff = showdebuff;
		namePlateFrameBase.asNamePlates.checkpvptarget = checkpvptarget;
		namePlateFrameBase.asNamePlates.checkcolor = checkcolor;

		if showhealer and ANameP_HealerSize > 0  then
			namePlateFrameBase.asNamePlates.healer:Show();
		else
			namePlateFrameBase.asNamePlates.healer:Hide();
		end
	end

	if UnitIsPlayer(namePlateUnitToken) then
		unit_guid_list[UnitGUID(namePlateUnitToken)] = namePlateUnitToken;
	end
end

local function removeNamePlate(namePlateUnitToken)
	local namePlateFrameBase = C_NamePlate.GetNamePlateForUnit(namePlateUnitToken, issecure());
	if namePlateFrameBase and namePlateFrameBase.asNamePlates then
		for i = 1, ANameP_MaxDebuff do
			if ( namePlateFrameBase.asNamePlates.buffList[i] ) then
				namePlateFrameBase.asNamePlates.buffList[i]:Hide();
				lib.ButtonGlow_Stop(namePlateFrameBase.asNamePlates.buffList[i]);
			end
		end

		lib.PixelGlow_Stop(namePlateFrameBase.asNamePlates.casticon);

		namePlateFrameBase.asNamePlates.aggro1:Hide();
		namePlateFrameBase.asNamePlates.aggro2:Hide();
		namePlateFrameBase.asNamePlates.CCdebuff:Hide();
		namePlateFrameBase.asNamePlates:Hide();
		namePlateFrameBase.asNamePlates:UnregisterEvent("UNIT_THREAT_SITUATION_UPDATE");
		namePlateFrameBase.asNamePlates:UnregisterEvent("PLAYER_TARGET_CHANGED");
		namePlateFrameBase.asNamePlates:UnregisterEvent("UNIT_SPELLCAST_START");
		namePlateFrameBase.asNamePlates:UnregisterEvent("UNIT_SPELLCAST_CHANNEL_START");
		namePlateFrameBase.asNamePlates:UnregisterEvent("UNIT_SPELLCAST_SUCCEEDED");
		namePlateFrameBase.asNamePlates:UnregisterEvent("UNIT_SPELLCAST_INTERRUPTED");
		namePlateFrameBase.asNamePlates:UnregisterEvent("UNIT_SPELLCAST_DELAYED");
		namePlateFrameBase.asNamePlates:UnregisterEvent("UNIT_SPELLCAST_CHANNEL_STOP");
		namePlateFrameBase.asNamePlates:UnregisterEvent("UNIT_SPELLCAST_STOP");
		namePlateFrameBase.asNamePlates:UnregisterEvent("UNIT_SPELLCAST_FAILED");
		namePlateFrameBase.asNamePlates:SetScript("OnEvent", nil);
		namePlateFrameBase.asNamePlates.r = nil;
		namePlateFrameBase.asNamePlates.debuffColor = nil;
		namePlateFrameBase.asNamePlates.interruptalert = nil;


		if namePlateFrameBase.UnitFrame and namePlateFrameBase.UnitFrame.healthBar then

			if namePlateFrameBase.asNamePlates.alerthealthbar then
				lib.PixelGlow_Stop(namePlateFrameBase.UnitFrame.healthBar);
				namePlateFrameBase.asNamePlates.alerthealthbar = false;
				namePlateFrameBase.UnitFrame.healthBar:SetStatusBarColor(namePlateFrameBase.asNamePlates.originalcolor.r, namePlateFrameBase.asNamePlates.originalcolor.g, namePlateFrameBase.asNamePlates.originalcolor.b);
				namePlateFrameBase.asNamePlates.colorlevel = ColorLevel.None;
			end

			if namePlateFrameBase.asNamePlates.colorlevel > ColorLevel.None then
				namePlateFrameBase.UnitFrame.healthBar:SetStatusBarColor(namePlateFrameBase.asNamePlates.originalcolor.r, namePlateFrameBase.asNamePlates.originalcolor.g, namePlateFrameBase.asNamePlates.originalcolor.b);
				namePlateFrameBase.asNamePlates.colorlevel = ColorLevel.None;
			end


		end
	end

	if UnitIsPlayer(namePlateUnitToken) and  UnitGUID(namePlateUnitToken) then
		unit_guid_list[UnitGUID(namePlateUnitToken)] = nil;
	end
end

local function updateHealerMark(guid)
	local unit = unit_guid_list[guid];

	if unit and ANameP_HealerGuid[guid] and not UnitIsUnit(unit, "player") then
		local nameplate = C_NamePlate.GetNamePlateForUnit(unit, issecure());
		if (nameplate and nameplate.asNamePlates and not nameplate:IsForbidden() and not nameplate.asNamePlates.showdebuff and nameplate.asNamePlates.checkpvptarget ) then
			nameplate.asNamePlates.healer:Show();
		end
	end
end

local function asCompactUnitFrame_UpdateNameFaction(namePlateUnitToken)
	local namePlateFrameBase = C_NamePlate.GetNamePlateForUnit(namePlateUnitToken, issecure());
	if namePlateFrameBase and namePlateFrameBase.asNamePlates and not namePlateFrameBase:IsForbidden() then
		addNamePlate(namePlateUnitToken);
		if namePlateFrameBase.asNamePlates then
			updateTargetNameP(namePlateFrameBase.asNamePlates);
			updateUnitAuras(namePlateUnitToken);
			updateHealthbarColor(namePlateFrameBase.asNamePlates);
		end
	end
end

local bfirst = true;
local function setupFriendlyPlates()
	local isInstance, instanceType = IsInInstance();
	if bfirst and not isInstance and not UnitAffectingCombat("player") then
		C_Timer.After(0.5, function() C_NamePlate.SetNamePlateFriendlySize(60, 30); end)
		--C_NamePlate.SetNamePlateEnemySize(ANameP_EmemyPlateSize[1], ANameP_EmemyPlateSize[2]);


		bfirst = false;
	end
end

local function ANameP_OnEvent(self, event, ...)

	local arg1 = ...;
	if event == "NAME_PLATE_CREATED" then
		local namePlateFrameBase = ...;
		createNamePlate(namePlateFrameBase);
	elseif event == "NAME_PLATE_UNIT_ADDED"then
		local namePlateUnitToken = ...;
		local namePlateFrameBase = C_NamePlate.GetNamePlateForUnit(namePlateUnitToken, issecure());
		if namePlateFrameBase then
			addNamePlate(namePlateUnitToken);
			if namePlateFrameBase.asNamePlates then
				updateTargetNameP(namePlateFrameBase.asNamePlates);
				updateUnitAuras(namePlateUnitToken);
				updateUnitHealthText(self, "target");
				updateUnitHealthText(self, "player");
				updateHealthbarColor(namePlateFrameBase.asNamePlates);
			end
		end
	elseif event == "NAME_PLATE_UNIT_REMOVED"  then
		local namePlateUnitToken = ...;
		removeNamePlate(namePlateUnitToken);
	elseif event == "UNIT_SPELLCAST_SUCCEEDED" and arg1 == "player"  then
		updateUnitAuras("target");
		updateUnitAuras("player");
		updateUnitHealthText(self, "target");
	elseif event == "PLAYER_TARGET_CHANGED" then
		updateUnitAuras("target");
		updateUnitHealthText(self, "target");
	elseif (event == "TRAIT_CONFIG_UPDATED") or (event == "TRAIT_CONFIG_LIST_UPDATED") or (event == "ACTIVE_TALENT_GROUP_CHANGED") then
		setupKnownSpell();
		C_Timer.After(0.5, initAlertList);
	elseif (event == "PLAYER_ENTERING_WORLD") then
		local isInstance, instanceType = IsInInstance();
		if isInstance and (instanceType=="party" or instanceType=="raid" or instanceType=="scenario") then
			self:UnregisterEvent("COMBAT_LOG_EVENT_UNFILTERED");
		else
			self:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED");
		end
		updateTankerList();
		setupKnownSpell();
		-- 0.5 초 뒤에 Load
		C_Timer.After(0.5, initAlertList);

		setupFriendlyPlates();
	elseif event == "COMBAT_LOG_EVENT_UNFILTERED" then
		local _, eventType, _, sourceGUID, _, _, _, destGUID, _, _, _, spellID, _, _, auraType = CombatLogGetCurrentEventInfo();
		if eventType == "SPELL_CAST_SUCCESS" and sourceGUID and not (sourceGUID == "") then
			local className = GetPlayerInfoByGUID(sourceGUID);
			if className  and ANameP_HealSpellList[className] and  ANameP_HealSpellList[className][spellID]  then
				ANameP_HealerGuid[sourceGUID] = true;
				updateHealerMark(sourceGUID);
			end
		end
	elseif ( event == "UNIT_FACTION" ) then
		local namePlateUnitToken = ...;
		asCompactUnitFrame_UpdateNameFaction(namePlateUnitToken);
	elseif (event == "GROUP_JOINED" or event == "GROUP_ROSTER_UPDATE" or event == "PLAYER_ROLES_ASSIGNED") then
		updateTankerList();
	elseif event == "PLAYER_REGEN_ENABLED" then
		setupFriendlyPlates();
	end
end

local function updateUnitResourceText(self, unit)
	local value;
	local valueMax;
	local valuePct;
	if UnitIsUnit("player", unit) then
	else
		return;
	end

	if ANameP_Resourcetext == nil then
		return;
	end

	value = UnitPower(unit);
	valueMax = UnitPowerMax(unit);

	if valueMax > 0 then
		valuePct =  (math.ceil((value / valueMax) * 100));
	end

	if (valueMax <= 300) then
		valuePct = value;
	end

	if valuePct > 0 then
		ANameP_Resourcetext:SetText(valuePct);
	else
		ANameP_Resourcetext:SetText("");
	end


	if valuePct > 0 then
		ANameP_Resourcetext:SetTextColor(1, 1, 1, 1);
	end

end


local function ANameP_OnUpdate()
	updateUnitHealthText(ANameP, "target");
	updateUnitHealthText(ANameP, "player");
	updateUnitResourceText(ANameP, "player");

	for _,v in pairs(C_NamePlate.GetNamePlates(issecure())) do
		local nameplate = v;

		if (nameplate and  nameplate.asNamePlates and not nameplate:IsForbidden()) then
			if nameplate.asNamePlates.checkaura then
				updateAuras(nameplate.asNamePlates, nameplate.namePlateUnitToken, nameplate.asNamePlates.filter, nameplate.asNamePlates.showbuff, nameplate.asNamePlates.helpful, nameplate.asNamePlates.showdebuff);
			else
				nameplate.asNamePlates:Hide();
			end

			if nameplate.asNamePlates.checkpvptarget then
				updatePVPAggro(nameplate.asNamePlates);
			end
			updateHealthbarColor(nameplate.asNamePlates);
		end
	end
end

local function flushoption()
	options = CopyTable (ANameP_Options);
end

local function initAddon()
	ANameP = CreateFrame("Frame", nil, UIParent)

	ANameP:RegisterEvent("NAME_PLATE_CREATED");
	ANameP:RegisterEvent("NAME_PLATE_UNIT_ADDED");
	ANameP:RegisterEvent("NAME_PLATE_UNIT_REMOVED");
	-- 나중에 추가 처리가 필요하면 하자.
	--ANameP:RegisterEvent("FORBIDDEN_NAME_PLATE_UNIT_ADDED");
	--ANameP:RegisterEvent("FORBIDDEN_NAME_PLATE_UNIT_REMOVED");
	ANameP:RegisterEvent("PLAYER_TARGET_CHANGED");
	ANameP:RegisterEvent("PLAYER_ENTERING_WORLD");
	ANameP:RegisterEvent("ADDON_LOADED")
	ANameP:RegisterEvent("TRAIT_CONFIG_UPDATED");
	ANameP:RegisterEvent("TRAIT_CONFIG_LIST_UPDATED");
	ANameP:RegisterEvent("ACTIVE_TALENT_GROUP_CHANGED");
	ANameP:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED");
	ANameP:RegisterEvent("UNIT_FACTION");
	ANameP:RegisterUnitEvent("UNIT_SPELLCAST_SUCCEEDED", "player");
	ANameP:RegisterEvent("GROUP_JOINED");
	ANameP:RegisterEvent("GROUP_ROSTER_UPDATE");
	ANameP:RegisterEvent("PLAYER_ROLES_ASSIGNED");
	ANameP:RegisterEvent("PLAYER_REGEN_ENABLED");

	ANameP:SetScript("OnEvent", ANameP_OnEvent)
	--주기적으로 Callback
	C_Timer.NewTicker(ANameP_UpdateRate, ANameP_OnUpdate);

	hooksecurefunc("DefaultCompactNamePlateFrameAnchorInternal", function(frame, setupOptions)
		if ( frame:IsForbidden() ) then return end

		local pframe = C_NamePlate.GetNamePlateForUnit("target", issecure())

		if pframe and frame.BuffFrame.unit == pframe.namePlateUnitToken and pframe.asNamePlates then
			updateTargetNameP(pframe.asNamePlates);
		end
	end)

	ANameP_OptionM.RegisterCallback(flushoption);
end

initAddon();