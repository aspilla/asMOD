local _, ns = ...;

ns.ACRB_BuffSizeRate = 0.9;       -- 기존 Size 크기 배수
ns.ACRB_ShowBuffCooldown = false  -- 버프 지속시간을 보이려면
ns.ACRB_MinShowBuffFontSize = 5   -- 이크기보다 Cooldown font Size 가 작으면 안보이게 한다. 무조건 보이게 하려면 0
ns.ACRB_MinShowBuffFontSize = 0.5 -- 버프 Size 대비 쿨다운 폰트 사이즈
ns.ACRB_UpdateRate = (0.2)        -- 1회 Update 주기 (초) 작으면 작을 수록 Frame Rate 감소 가능, 크면 Update 가 느림
ns.ACRB_ShowTooltip = true        -- GameTooltip을 보이게 하려면 True
ns.ACRB_ShowAlert = true          --버피 리필 알림 표시

-- 버프 남은시간에 리필 알림
-- 두번째 숫자는 표시 위치, 4(우상) 5(우중) 6(우중2) 7(상바) 1,2,3 은 우하에 보이는 우선 순위이다.
ns.ACRB_ShowList_MONK_2 = {
	["소생의 안개"] = { 0, 4 },
	["포용의 안개"] = { 0, 5 },


}

-- 신기
ns.ACRB_ShowList_PALADIN_1 = {
	["빛의 자락"] = { 0, 4 },
	["빛의 봉화"] = { 0, 5 },
	["신념의 봉화"] = { 0, 6 },
}

-- 수사
ns.ACRB_ShowList_PRIEST_1 = {
	["속죄"] = { 0, 4 },
	["소생"] = { 1, 5 },
	["신의 권능: 보호막"] = { 0, 6 },
	["회복의 기원"] = { 0, 2 },
	["마력 주입"] = { 0, 1 },

}


-- 신사
ns.ACRB_ShowList_PRIEST_2 = {
	["소생"] = { 1, 4 },
	["신의 권능: 보호막"] = { 0, 5 },
	["회복의 기원"] = { 0, 2 },
	["마력 주입"] = { 0, 1 },

}

ns.ACRB_ShowList_PRIEST_3 = {
	["마력 주입"] = { 0, 1 },
}


ns.ACRB_ShowList_SHAMAN_3 = {
	["성난 해일"] = { 1, 4 },
	["대지의 보호막"] = { 0, 5 },
}


ns.ACRB_ShowList_DRUID_4 = {
	["회복"] = { 1, 4 },
	["피어나는 생명"] = { 1, 5 },
	["재생"] = { 1, 6 },
	["회복 (싹틔우기)"] = { 1, 2 },
	["세나리온 수호물"] = { 0, 1 },
}

ns.ACRB_ShowList_EVOKER_2 = {
	["메아리"] = { 0, 4 },
	["되감기"] = { 1, 5 },

}


-- 안보이게 할 디법
ns.ACRB_ShowList = {
	["도전자의 짐"] = 1,
}


--직업별 생존기 등록 (10초 쿨다운), 용군단 Version
ns.ACRB_PVPBuffList = {
	[236273] = true, --WARRIOR
	[213871] = true, --WARRIOR
	[118038] = true, --WARRIOR
	[12975] = true, --WARRIOR
	[1160] = true, --WARRIOR
	[871] = true, --WARRIOR
	[202168] = true, --WARRIOR
	[97463] = true, --WARRIOR
	[383762] = true, --WARRIOR
	[184364] = true, --WARRIOR
	[386394] = true, --WARRIOR
	[392966] = true, --WARRIOR
	[185311] = true, --ROGUE
	[11327] = true, --ROGUE
	[1966] = true, --ROGUE
	[31224] = true, --ROGUE
	[31230] = true, --ROGUE
	[5277] = true, --ROGUE
	[212800] = true, --DEMONHUNTER
	[203720] = true, --DEMONHUNTER
	[187827] = true, --DEMONHUNTER
	[206803] = true, --DEMONHUNTER
	[196555] = true, --DEMONHUNTER
	[204021] = true, --DEMONHUNTER
	[263648] = true, --DEMONHUNTER
	[209258] = true, --DEMONHUNTER
	[209426] = true, --DEMONHUNTER
	[202162] = true, --MONK
	[388615] = true, --MONK
	[115310] = true, --MONK
	[116849] = true, --MONK
	[115399] = true, --MONK
	[119582] = true, --MONK
	[122281] = true, --MONK
	[322507] = true, --MONK
	[120954] = true, --MONK
	[122783] = true, --MONK
	[122278] = true, --MONK
	[132578] = true, --MONK
	[115176] = true, --MONK
	[51052] = true, --DEATHKNIGHT
	[48707] = true, --DEATHKNIGHT
	[327574] = true, --DEATHKNIGHT
	[48743] = true, --DEATHKNIGHT
	[48792] = true, --DEATHKNIGHT
	[114556] = true, --DEATHKNIGHT
	[81256] = true, --DEATHKNIGHT
	[219809] = true, --DEATHKNIGHT
	[206931] = true, --DEATHKNIGHT
	[274156] = true, --DEATHKNIGHT
	[194679] = true, --DEATHKNIGHT
	[55233] = true, --DEATHKNIGHT
	[272679] = true, --HUNTER
	[53480] = true, --HUNTER
	[109304] = true, --HUNTER
	[264735] = true, --HUNTER
	[186265] = true, --HUNTER
	[355913] = true, --EVOKER
	[370960] = true, --EVOKER
	[363534] = true, --EVOKER
	[357170] = true, --EVOKER
	[374348] = true, --EVOKER
	[374227] = true, --EVOKER
	[363916] = true, --EVOKER
	[360827] = true, --EVOKER
	[404381] = true, --EVOKER
	[305497] = true, --DRUID
	[354654] = true, --DRUID
	[201664] = true, --DRUID
	[157982] = true, --DRUID
	[102342] = true, --DRUID
	[61336] = true, --DRUID
	[200851] = true, --DRUID
	[80313] = true, --DRUID
	[22842] = true, --DRUID
	[108238] = true, --DRUID
	[124974] = true, --DRUID
	[22812] = true, --DRUID
	[104773] = true, --WARLOCK
	[108416] = true, --WARLOCK
	[215769] = true, --PRIEST
	[328530] = true, --PRIEST
	[197268] = true, --PRIEST
	[19236] = true, --PRIEST
	[81782] = true, --PRIEST
	[33206] = true, --PRIEST
	[372835] = true, --PRIEST
	[391124] = true, --PRIEST
	[265202] = true, --PRIEST
	[64843] = true, --PRIEST
	[47788] = true, --PRIEST
	[47585] = true, --PRIEST
	[108968] = true, --PRIEST
	[15286] = true, --PRIEST
	[271466] = true, --PRIEST
	[199452] = true, --PALADIN
	[403876] = true, --PALADIN
	[31850] = true, --PALADIN
	[378279] = true, --PALADIN
	[378974] = true, --PALADIN
	[86659] = true, --PALADIN
	[387174] = true, --PALADIN
	[327193] = true, --PALADIN
	[205191] = true, --PALADIN
	[184662] = true, --PALADIN
	[498] = true, --PALADIN
	[148039] = true, --PALADIN
	[157047] = true, --PALADIN
	[31821] = true, --PALADIN
	[633] = true, --PALADIN
	[6940] = true, --PALADIN
	[1022] = true, --PALADIN
	[204018] = true, --PALADIN
	[204331] = true, --SHAMAN
	[108280] = true, --SHAMAN
	[98008] = true, --SHAMAN
	[198838] = true, --SHAMAN
	[207399] = true, --SHAMAN
	[108271] = true, --SHAMAN
	[198103] = true, --SHAMAN
	[30884] = true, --SHAMAN
	[383017] = true, --SHAMAN
	[108281] = true, --SHAMAN
	[198111] = true, --MAGE
	[110959] = true, --MAGE
	[342246] = true, --MAGE
	[11426] = true, --MAGE
	[66] = true,  --MAGE
	[235313] = true, --MAGE
	[235450] = true, --MAGE
	[55342] = true, --MAGE
	[414660] = true, --MAGE
	[414664] = true, --MAGE
	[86949] = true, --MAGE
	[235219] = true, --MAGE
	[414658] = true, --MAGE
	[110960] = true, --MAGE
	[125174] = true, --MONK
	[186265] = true, --HUNTER
	[378441] = true, --EVOKER
	[228049] = true, --PALADIN
	[642] = true, --PALADIN
	[409293] = true, --SHAMAN
	[45438] = true, --MAGE	
	[586] = true, --PRIEST
}