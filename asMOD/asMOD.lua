local asMOD;
local asMOD_UIScale = 0.75;
local asMOD_CurrVersion = 231020;
local bAction = false;
asMOD_t_position = {};

if not asMOD_position then
	asMOD_position = {}
end


local layout =
"0 39 0 0 0 0 6 MultiBarBottomLeft 0.0 -4.0 -1 ##$$%/&%'%)#+# 0 1 1 7 7 UIParent 0.0 45.0 -1 ##$$%/&%'%(#,$ 0 2 0 8 2 MultiBarBottomLeft 0.0 4.0 -1 ##$$%/&%'%(#,# 0 3 1 5 5 UIParent -5.0 -77.0 -1 #$$$%/&%'%(#,$ 0 4 1 5 5 UIParent -5.0 -77.0 -1 #$$$%/&%'%(#,$ 0 5 0 0 0 UIParent 1111.9 -439.8 -1 ##$'%/&%'%(#,# 0 6 0 5 5 UIParent -1172.2 -470.0 -1 ##$&%/&$'%(%,# 0 7 0 3 3 UIParent 1172.2 -470.2 -1 ##$&%/&$'%(%,# 0 10 1 7 7 UIParent 0.0 45.0 -1 ##$$&%'% 0 11 1 7 7 UIParent 0.0 45.0 -1 ##$$&%'%,# 0 12 1 7 7 UIParent 0.0 45.0 -1 ##$$&%'% 1 -1 0 4 4 UIParent 0.0 -301.8 -1 ##$#%# 2 -1 1 2 2 UIParent 0.0 0.0 -1 ##$#%( 3 0 0 0 0 UIParent 576.2 -689.0 -1 $#3# 3 1 0 0 0 UIParent 1013.2 -689.0 -1 %#3# 3 2 0 0 2 TargetFrame -31.5 -4.0 -1 %#&#3# 3 3 0 0 0 UIParent 339.2 -356.0 -1 '$(#)#-S.5/#1$3# 3 4 0 0 0 UIParent 3.0 -546.0 -1 ,$-=.-/#0#1#2( 3 5 0 2 2 UIParent -324.2 -374.0 -1 &$*$3# 3 6 0 2 2 UIParent -312.2 -376.0 -1 -#.#/#4& 3 7 1 4 4 UIParent 0.0 0.0 -1 3# 4 -1 0 4 4 UIParent 0.0 -326.2 -1 # 5 -1 0 3 5 ChatFrame1 29.0 38.1 -1 # 6 0 1 2 2 UIParent -255.0 -10.0 -1 ##$#%#&.(()( 6 1 1 2 2 UIParent -270.0 -155.0 -1 ##$#%#'+(()( 7 -1 0 1 1 UIParent -7.0 -794.0 -1 # 8 -1 0 6 6 UIParent 35.0 50.0 -1 #'$A%$&7 9 -1 1 7 7 UIParent 0.0 45.0 -1 # 10 -1 1 0 0 UIParent 16.0 -116.0 -1 # 11 -1 0 5 5 UIParent -272.2 -380.9 -1 # 12 -1 1 2 2 UIParent -110.0 -275.0 -1 #K$# 13 -1 1 8 8 MicroButtonAndBagsBar 0.0 0.0 -1 ##$#%#&- 14 -1 1 2 2 MicroButtonAndBagsBar 0.0 10.0 -1 ##$#%( 15 0 0 2 0 BuffFrame -4.0 0.0 -1 # 15 1 0 2 8 MainStatusTrackingBarContainer 0.0 -4.0 -1 # 16 -1 1 5 5 UIParent 0.0 0.0 -1 #( 17 -1 1 1 1 UIParent 0.0 -100.0 -1 ## 18 -1 1 5 5 UIParent 0.0 0.0 -1 #- 19 -1 0 0 6 EncounterBar 0.0 -4.0 -1 ##"
local version = select(4, GetBuildInfo());
if version == 100200 then
	asMOD_CurrVersion = 231031;
	layout =
	"1 39 0 0 0 0 6 MultiBarBottomLeft 0.0 -4.0 -1 ##$$%/&%'%)#+# 0 1 1 7 7 UIParent 0.0 45.0 -1 ##$$%/&%'%(#,$ 0 2 0 8 2 MultiBarBottomLeft 0.0 4.0 -1 ##$$%/&%'%(#,# 0 3 1 5 5 UIParent -5.0 -77.0 -1 #$$$%/&%'%(#,$ 0 4 1 5 5 UIParent -5.0 -77.0 -1 #$$$%/&%'%(#,$ 0 5 0 0 0 UIParent 1111.9 -439.8 -1 ##$'%/&%'%(#,# 0 6 0 5 5 UIParent -1172.2 -470.0 -1 ##$&%/&$'%(%,# 0 7 0 3 3 UIParent 1172.2 -470.2 -1 ##$&%/&$'%(%,# 0 10 1 7 7 UIParent 0.0 45.0 -1 ##$$&%'% 0 11 1 7 7 UIParent 0.0 45.0 -1 ##$$&%'%,# 0 12 1 7 7 UIParent 0.0 45.0 -1 ##$$&%'% 1 -1 0 4 4 UIParent 0.0 -301.8 -1 ##$#%# 2 -1 1 2 2 UIParent 0.0 0.0 -1 ##$#%( 3 0 0 0 0 UIParent 576.2 -689.0 -1 $#3# 3 1 0 0 0 UIParent 1013.2 -689.0 -1 %#3# 3 2 0 0 2 TargetFrame -31.5 -4.0 -1 %#&#3# 3 3 0 0 0 UIParent 339.2 -356.0 -1 '$(#)#-S.5/#1$3# 3 4 0 0 0 UIParent 3.0 -546.0 -1 ,$-=.-/#0#1#2( 3 5 0 2 2 UIParent -324.2 -374.0 -1 &$*$3# 3 6 0 2 2 UIParent -312.2 -376.0 -1 -#.#/#4& 3 7 1 4 4 UIParent 0.0 0.0 -1 3# 4 -1 0 4 4 UIParent 0.0 -326.2 -1 # 5 -1 0 3 5 ChatFrame1 29.0 38.1 -1 # 6 0 1 2 2 UIParent -255.0 -10.0 -1 ##$#%#&.(()( 6 1 1 2 2 UIParent -270.0 -155.0 -1 ##$#%#'+(()( 7 -1 0 1 1 UIParent -7.0 -794.0 -1 # 8 -1 0 6 6 UIParent 35.0 50.0 -1 #'$A%$&7 9 -1 1 7 7 UIParent 0.0 45.0 -1 # 10 -1 1 0 0 UIParent 16.0 -116.0 -1 # 11 -1 0 5 5 UIParent -272.2 -380.9 -1 # 12 -1 1 2 2 UIParent -110.0 -275.0 -1 #K$# 13 -1 1 8 8 MicroButtonAndBagsBar 0.0 0.0 -1 ##$#%)&- 14 -1 1 2 2 MicroButtonAndBagsBar 0.0 10.0 -1 ##$#%( 15 0 0 2 0 BuffFrame -4.0 0.0 -1 # 15 1 0 2 8 MainStatusTrackingBarContainer 0.0 -4.0 -1 # 16 -1 1 5 5 UIParent 0.0 0.0 -1 #( 17 -1 1 1 1 UIParent 0.0 -100.0 -1 ## 18 -1 1 5 5 UIParent 0.0 0.0 -1 #- 19 -1 0 0 6 EncounterBar 0.0 -4.0 -1 ##"
end
local detailsprofile =
"T33AZTX1vc(RzRnUQvm97hQQ9dKIKsSmfOwcQ4nvPInBa0KOxbGgl6gIIEDy5h0EzSyk7SrkMjrsRCf7y7mAQLrw2JDnYZ()Ha8)WEoN7J(bAGgsXUMP2AMXHca99EUN75EEFp3BVT62BTD9(dI2nSta(X42r775piONV3GOobEHnJ6TDJTRpmoWBqGFNKWUbT6hJ)0aOL763cAtpON1u3Uo8HAABxtzbTTtaqLaDOBWapae7gUhc9D9JtGFyy)w(jbeq(VpmS5T9AfKe0mjKnudcIds8I7h00RPFZ2b4V1lYZVtWGKybU43lSRp2dp)Mnd6S9sBxVvySFdaL7Eqs7WMETg2BVacIaU0BiGiHn974fFaGcDr8KGtCtyA2HnS9JgK41gMKEDc7DB2CmOB0DyZ8UE7oiQRxpykHJw3qadg21dE8a)oDGjz3g(jEi9bOfka6e4N02ljkcOz992pSvs7TRPBQihPKiV9BhTDDKUfN43RzqSxCWEDd6Le71jQ5TdAHdec8WEEr9caG0Rv0(XaLmHH9WiM0jyVbrd71c67aax867pa(eI89J98B0yqWDcjkfm6BxF)ObDAjq2WyVKb(XTXHHTMGKDyyx1XWYY2YwZ221r1Y1A7DVKj07grr3UR)GB7LeCxyjk8nX5kSWNUAq93dioaGVdSUamdgMts)H)PBJOoXqxhMeHmgTeJn0dvZIKVyywDBCoXjbZKXlLCc0YHEn7GSya1oQFaXGjxY6e4pWRxW(nBdFnayxqcbUc6LCq)aIhbik(ud7nSpSOSx0WeeePdbWz2jSbdTiIotwYlgM(E9JIjoZGD9h2jXRXEaxC)2(iMctrI2JshnbkFp4)H9VvqVdaUYObaJCqCS)Em5eC4A5pawLVDinjeC7iJIhWQd8a99AmmjjQh1HcljWIVU4hZY1ladkSM0SnJhhP6n8hWeayY8EGqpGqG0lkhdyl0Pwyd2nQxcmh6enGTwG)Ng9xD6Vg4FHffMofrhxI3X42(iDRETnQTI4NyCvoGiwobzVmdASF3(istnfMx7oaKkbbGKKWE7fl1JLecsh4ybZoyDC76RVXBaRqra35213AJBapayjdiwiHaQciGEW21UKkkdFxyLc469BE7wdI6NBAQW44OPPcnn5CFPsUTdc3RDc0oDsELjGbJniN6tsgaMtcsr7UlG7e)grc21VzW21xDq4BE4o)xg63cr(d3zlyAf1hxsb2FCct6bai3fusn4ap4N2UMLbXxb8eHOywNauiezlVtFp)ypInjRYsgJl73j(gMqbNHsSsnOjOXfuqFNWKdivCEa8WhLrZ1W(9bn3cnkiDRzhF47Ofe4XDbrSTRVgo7XP3TwSvRn6fFRLds8d7eFlGVe40Vf1LazZftxU41wzwWskrRJ)DfAD0Zih7fniCVWEijhiW974FaOLSfBCldYW69asb3WbWQq9BFayna(aj4vFLo35MRHdUCHIy3qfnXLUKLWuX5fVVFFujuRdaliaxnxjeXDku673fuKd8bgaXdw4GbGwkFLL5iHaquF)wWAqciYdlBDraGZO8CZlOY1GYac9VgmE0KkLvvQKVLgqH8GQv5OgXrj4SNLeC5cKlaWLphSetcl(SWWoJOzJurtsCNl6Rb2Mt4OQC5NZFE4o1dafya7)uKbLccmSbWFps7)wOVldaUz8thS9QxYw1r3wxXXvt3qvZWbSSAyGAAw1Y1vv1110XrX0wXHEcAXgSgRQPAP4yzRB54AbOm8eW(r7Tx1wZv3XwX2YuZWWq1I9eCPhOmSHez6VltfhF(IZvffgEtuza1tggZ14t2m5cT0YRYcoAO4eSsGsgyp6jBimNBlxc0ekfRhh2ISFcJay0BaPCeNm7oStNgrdAbsGcGJteO1EGLvqri31esteU4knPntgDUblcT9ixzRutt2Ue7Pj5UbzZbGuAymQOiRFyKxNOKSFNW9651fmOh6HS9aRjz1zjCnFFqjl6NbxZzMPRGSrUJK0guVUxBHLwcjiR2jaWGPmJdmRypkdWqXgcYRk38bxkewKAomobTFJ9T()d0v1FLuqc9eNmcto5G9JjUUyZMa06L435WDUbObh)sZdY3To7d0cz)MhR9zzluxWGAfXoWMpEzX0gzhm2evo0n2d(HKmSFZsYewxi)MqZoimq(kY4xNHGbaY63(Ws7aESgKNJihtRGyqaauWW9Uy)q0vOw(iNctMiptHG7M7nQxQPdItweZKGftUALHDy2UsOYmRlfeLEn6QrcunibkqtHezXWwaWcbkuqakv7Og4wnx)OQTudPMRbxhPlnQmzrem94SGm1zzm)e2dSDftuwWrMHKfauDca85SH6ZBdnM3gAoVn0AEBO982qN5THUZBdbdQZBlN71g15EXrDUxDuN7Lh15D9H7SbxNkjTRlmYut3kNuX01dbqzVb(nq(4KO(4GaYHGRO4GkeYj35UogfpOqpojSjlJfOWeZMtg5wiyPiqwFVctcu4EMirfQlPPlOtcul7x0mro5AHtFzjlAsYITrwYcBKwchOLWXzjukAjuczjK7hbDFuXFTlPLXKsj0DiU2UHPbNCj0npE84KBnE(nc7eMec(8G(BJbOf0L)nMD)9i1u6MAfS6LgTCDYZJL8huh8BVfc2MbOHBq9(kBT4ARx3R(wlU1nRV0IB6DJ1V5vxRM3vwFJR86azJCGB6n7glFJ6sF1qap7wUL0n8TeH(J0GvNPjsSflIEdid4G1zUH56sVJXVDLkTAoZPt9vU61xP2w)DJOQ)eJOSLN)EXsTFuWs0B(GDNlYAsbw0byE2AqCXsJVwPU5lurKZpNlPzZreaAO6nrs3kkzzi63QgwwUQ2UAkwMwG5CBmpBgOFKP(DYCZMWH8AFI6XeveUXaoufrXKtEbHk8yTccO)oIqMZRSzoCcHRgctxgMp448EymXt93fZV7(H9d4zioRQTuh(ZrQd7XaiGPhWCIoUNFFwsoz(t1tMDvb)qHFxSeXuRZDUeZSAUWgtZthlwmdtxDflvldhllntnmGllBrsF4zjAPn2ARnU(MRD1Rvi5dYyMa0yxkuljFIUDM)pw6gb3gz05vHW3mSHO8u0Hq6SmnzR4aTFAprFApjjZ6dWusPhLr7(ffcpZRfAuHlRWcs(sKo6mo(s5kLcbbJXHOV0VSfxgQHqLBJmdl3f58mfYOZN0v9RszQwe1jmgcUuAqBoCa4jFcYdGoQZ2kcroEikm8LTRVQpywoJMDIoq23JX0QN3)(m0N8yzEoikkHO4WM(r)B(q2rAJGNdjXBIHot5OISTh0CoJaMAkZtk(8La36zbxo4ZZk3sfAx6ptRy76tuFwuqymWH3f4UQ0tiUxjBjyZqzqIXJYaBqY(bb9Y6v1bc)s42dagnpKZJVziSCpYgWgLIWZJ2pzwT4K0vrf53cwj0wyRTwf32I05kPFlV3scjbYVM5iDDY44ZOLFsHiWBPLinQhUdfrD3OwbDixCg2VpimsFhCTQFqhyXErWw7sdOntbEEWGRoaiKlCDnmBy7N263a3xOBTY)1BSyT6RTrnfTBT8gBS8Ilx)wGH2w(dg4FRRSX6lV4MBUiyG)M1xORMy8YULgmyMb9z)GSjQIoL2KK85suvSyLpxg4(WO(Rw4WDOpP)RO)r7xbsTbdAszknRRcRJjoTxm4DQmddcEeoylkIK2G5t4bv83(aCpz45qi3QVczFaugXShkefyOw5zaHBLOqknT5rSBZdx3MfRUqkytMssKwmPB)YnDrUrULWI(sKXSc5MN6jeL1bmRItqIrZV0oSkvZiibB6nJKavYEpNQbHG(ufBteuycq9g2TblDsLOeBEe(zDlJIK4unILXCE4o)mox5)jjB6)HxRmj4RXzCetP2GgVoS4zsxewDqyqVwXRIzz(w3CTlX)(6qSQx6APDOeDFZnhSH3Gawy4s2Vjr2L)pg2mzy3Ildz11olA5QMGnttttDWuOJUIoTvYMBxkMp5Oc0uok(As9cfwq46wuPIeqWYqmNCg98iMCHTbT1kWx)z529IzfCcX(LD4tnfMk4J14Gx)yEroKYYeh03h80cOu8DqrU9GesX8C7A0ECdmO997pX2(KZrYPMk8G72mcmpKBARMBBkP9cHp6R6OOzQO54OA7yyPr70VHLmbU1jrD2UiIELKvxpBBtw1W12X0v1XgIJXutXG5DeLuEGi6H7QqX4w6Ca65LCViPfTm8RRDLnQv)wRv7x4bXYe2XBlatqh)QirkYueliSoC3cljTVOIPsZGFX8mxqFSMSody6J14Kuhr8M5RTa(EA1lyFXgTsw52kDXx10jDVNvjoHM(9Prg36Dwt9zExHg0BcCxSYpjUjP2hRqeWdE8Fd6fmypkekMF5mBaLLOlelheYk5IoDcBrt9CLwbwNdSARa)uMIRqu3l5Q3fZ0cfaRta2(fW3THgzSVNzVsRXMS5PxPfybFZFoGBpijWVlIJn7eneu4WOqPZuW)(Bh0Zd1uG1mqV9iZjuroik)H0S1dsWD7lcz3jJ(knMy0Luj23MTXPNFdVaWosRc8WhKvI)Uz)c2dQgHWOpbmrUh7mxDAf43cMLE027IPktlx5HW42aATIRHknDrlOTdd60IV78mTpGaorlV2nRT1kBMxf3cG(wz29nfLMaPY9na)3wBJP2EEBvznU(1w86lwlZ(hi2(aieifdlh7PnkxFXRUs1Dl)GDJv2AogjDBXirDA5nV5All7MUTQIl1cQVgaf0qXQ85213O2RNkul6IULB2USGCEHqLsJ0IBDTxVgLmGsq2P1nyWQpRvPcZQBS46lU8A1MAZlc(Bw71RTXBuYSzAKTBS5ARupDgKHiRLNow6Q7nRD1n34M34gRV4VmDonhJ6IGIgm1ztDCvaRpo2q41L29vQTY1)LZljC5vaAEEzdXIRoVVtJAEnm0Q5KNQ4WU5gx9MRmN0188JR8l241ZGRMk6USHH65uyIbPzEYwNlKTWcj6dqusZObGvdCxsOGT3ILyeUUkEncb6NLB9zAQ7Z5i0eQIwWse6IJoF8nktf0c2oIjPOYtm0lrkybxrXDykMp26tOSXquflcMixsv(IBUsTf9(LRS(6s5KS(pmBoBdb5uGEf18OkP38wOyuuftUbZ0DA6sSTLm2ceJMJ1xz9vLnYXvr1vWsPPAk2jx2VlNTxDZvwjL6z5yj5cfW2vPe18I5Iy26yxMkMj8cQOwLjYUtw976fOOtkFdRBQQ2zdLybyYzL6LBrwFtbxKPGkB7onfbwIvuv3CTvMXEWWBTvU5wBU46LXSuI4QGEyABj5sCDkQrqWN4kwXm4oU2yqKFRMSsJoBMFi)NZxbVAzRwmmNPG3tXS8EW8GcciVFBWfVLeLxk1kwzmt(kwOM5apF3BVGbI6MZmT8MyvuAqRWKsQrnSs2IPTvaRvnYNqkL9GZ9SYTDFY7POwreUnWVvi5ZNfpBDPPRH33BefJPtvtrhuAQBzcQnbfhSKMYkwfmfLuPdKrdvA5hkkDoChI9V70822WmTCVaTZzkEYK2qSETJ60IgbkefSKj3DG)EXLvNSS9)P0QjgcXBV2C30XhWQ4qYDyEmpI6PpB(TJZrL7d)Etk3Czlcx03A2EPiYBoVuYXeBeZCdxuu(t1bEMEBmRmzCKSMLwgt5QUM6QLyrVGfKAQgw2PIGfnwTGOXwSwBPNXsLzbZWfbnwmEZJxQqdvNHVyfBR2mCyjFBH5MtQkdzRTNYKtZmD2jm5RwooymVURdT1Cw(zwS5wwVeELcaFwRDt26mudDnh1jPit2f3zHpsxNC4n3AQR4t0wtB7z55zX1Mmm3LGi5DIRMPJ6m4tNa0gZOXfGSML5mO4t0yRzX(nrRtjis0Wz6TEMS2tWgA5onE7jBRTYSqKInptRNUANImwQkAtNONxAZwDQyEbAIQI(0xCkauTPYOwG9qvXyge6IkCS1NfPRaOZ04s4PNGnvF(JudWAZzGifuNzPoNbLb6dSMHSsXf5uzLQcaUwgzWjfRMmQhHb7D74VhRy0NWeEJO4SMxJB2oOllhZzkakXztc93itPqznzDHbyQm8fDP7F6UwsTAIIywaV(byYHWeUw09V2b(Odatz)uXQ4uuBNPElNjd7ceIYVepUB6J6PFuMrtWRN7eghnyEQ4xkpQYcuMx3bXnXDBKxi8yRnvS57P1L0n5E(ZNrPfHEX4eebqQlrnWtNgSIzRMnFVlXkjl4WDQJNCkb(WsIiB)KZtLSlsIYFafSZVAK4pypXcICF0qwG3G12Rr)JSSNb3T7alyG3X1XQpK)ROZ2mVHz7ZfZHvmpLdBq1QrAA)5NokA36yNacQSNAg1TRFVw8Z)h2IPFGlM)k8H3YzUpZ68S2IPOu2W0e2dr3T(6lTXgV(TOnDgpLGx6g(7fCjrbwNogI9MO(sSYzwf1RuFDI5ZM8QaIHmZx2mtZssjlBVkeHGQIIUURTTJUj4eieRGRC2W3mzdkAGWUiHSBqs7Ow0caFzAA7pe)X8kaQrucTBMscqQtZQaAycXRyQP7OP4OPByKwopo6AGbFnndhhi0vDf2rOelNhBlBdvDdvBBDtlvxD2oIr7vMc4fKQTHPRIMUoewkVqFs5MNTqygCmR2hNczfXjZ5vlP4rTCwfyViki2r0nngi6uscHXEBoJKCVFd6SBAryKgTMao0U1i3lZgPPhNk9uMYzg2H)yAUMAf0y4U7UD9(dh0h3Rt23Id7ChS0r3L2P0ohSBionA5p42rd8Xt3jBRuQVhQucfNGW9WcJQ(bby99k32eqTFlgLzVorn8xMT76CezqqtwKUSAyIhWgI75oPgWZ6eUBGhV8eygt6eChQ4bzBAInt6JFe54N1zaWJF8Np6tF4H7m6rVy8hCYfVZtb1DQMQyIBQp(lE7XN(5JE2lg9xEXH7m(7F(4h)Xq7eTausC(Z(HZ)6JU4bNo6dVp0IN9pcD58V7m4Jqx)Wpd6YOp)7eThiVJF43CXd(QXp75JF0PWyE2xjEMbIjF4fp(eOR37ZU4tofAJ4zKSyy3USmMqwRWATgRGjkCx2U5J7AHyhMKtpuxlE4Vt8c61evbIsRyBa5TOo0P5oMYuGRJPUJfEuGPuyGhQg00C2uqgC3(Ukjb0U5alpDcsc4LKM3wxzJLy7)f3g((TdqUHREZ1wF5S4(qGZMIgo0VtAzkWHcFlKKiavAAm4LAttnTOprNi4vCw6HEp90HK)mZrYRGHfK8LXbc80U3VjqXy1XzlgnlfHf4kI48txmWxIYhi3DyV9AHhv8UH947)wndSaYy2CgUNxFaKHnXc(Jr1588ycDBh082GzyqQoa3pu5Eo6HNp59WSKWx5yz(rzQpgz4Xhlo5U86trM8b2jiftlc5qIlR8StZhAnu15cUqyhY0fdgy1vxWrXrKtTvT0TSTCuSHhOBR7IAE1T55dUMHJUoOFtttMxYvTuvnCmDTvuCqTV4gDR7itB9QwgAAQ4PE3KQAphb4WS4UQLRkWjAyP7OQaJRjVVISqcgJGEAABy7a6U1D14BIE2SpIjFWvhqjBzkxRPPyQyTagmlpHYRAARcUiPbGXv30WeRhyDxz(gxfCR10cmCOc(PzdblHJJsAUYx1W1fGMHPLTcE89DzDNvOOC5WCCvWAD0Gq22mNE2(f)iweP(aFu7GoIJwog8JtA9uVwTv3WBRBU1gBU2IRRYs4vaiCqhnsU8rdu8ObA5PbA2PrgN3WtfDp6aSlGomz24xSYMlU(6lV4wl6be4ARv7QKew9RJvx(gxFPf3YBR1U(k4OXtzRNFVEGQKMmMY3yTAlVXB4HRmE3Sg(peMvkoRX9Skzqh(9eaBlxZsdWnLg0kqZCXjMCF)b9areVWwQYupQrEOr3RcT8ilhynt4GRUf7dIpcHLsutMrlOn4pGdSSYp4YIcBKSGG7hoRKz9anHEd8H(lvQsuFi6m6SFaX)5Y(xf6yGOz6QX)D(3Hqqy)UctR5TdoiobvKKEECLQXWcLLxsUPNHukB1Tdt4AoXYVbwDUDi)AgqOJAIdcm56awW4X4KahixSdQg0F1P)Qr)vL(lh)6JKpQYsYDdfKj955QmaEKjlvO58dd(SFAgywANLvTz(ru(Z5600CIlJd55AV8agGLfS8gjGDYKihiYnOv26CWEkOiFEnhyAUX(LDMXhMxUj40wlKRGPx0ccXnSnukWPkYf61TrN(4w)s8Bq6(qLqCVq8B1cn(HjtNvXnGrBqlyqADfPJfPAMUi(D8WdK5NtJ6oV34kYn8wKJcfZSxGe9B7hhKoQHXPNfKmqNUruQiWCEPEr9kfG862Y2X1XXf0iawrnSuev1obD0V8mf4xUJFAbIIy3uyNnpYDg((DqneDxd8AogVFoexDotqwP4)NZqCsjb5vL4mbHlJ)47HLgvyZIJzSm3a17X1YLPt058wCcI4ttvxweImv(v3E2vkqFSagHbV1ltpOWgM32tLqx1nwJyWgGhwKQBSo)8guGSkaLRYepItvFjON)KtozLI48tozT)NsYzwneuYkQ6wLHLCqkfuLsQr7ST51kyf4Gnr)MZ1g2bo5vyX5F15C14K6EOdw9zxMyOQOgh4X2MD25Qte718QOAMAItRQ(jxSY2XjezyLHRHl4dMQMfeJGInpccZjuDlBneFGJRQUIPTUHQbVMBNePem1taOSy0ekhjLIY(QONdW5TLjYQTiN2ImAZQW7jWh0tXzBbi9gLj9a2nTsnFH0l0az2(PXDIzKWKNPHTIHRHMoeNNg7qzzKDKkj3Mt)4FelVzGK9xAO0UeKilnFsX5zYgmLLO0A42vZqbcW1wxbcWuJpVyS)vznUeHe6rnkzyNdtQzv(Nt2mtFNMcMkAFjA)N3EiujnxTxOsQk0pNkPkASq7FXfEoNPLkScAQOG)XuxkqxQmqwMSsfKE1Sk43ioAWKv6CPAUnFv00JQE9VZEZd8zTFqysjJXu6Jb1hies)5YVai0ZP5jXmrQH9PqVNd8XumNJNBSFEnmBy9kyyMX5n3MABh(sG4)izexC3pKDnkzAwlYC8zktzeVGVCyNSYoyPWbk9ggZdEeZvsAAjNwkuzBxhE1uCf6aFXotLI7ehzuk1p)F6fJFYV9WDo)R)MZF2xrLqwPhNL9bh(8OYdTMOgcOAhSoMg)p6pC4oJF3Nola8gb(9J65Tu0(Ek2IlshEmsauU4pC65p7hU4(V4Ih88d35Nn6D)dx8GtbG(TFfa0xRuOsZiVR7VxytVvrQqWGvXZ8d)U3Hh51KW(It)UlE0NE4oJ(2Jp)S3UCyViLt7d8QpC3DJWKelUOEODcUuOE)xm6tF4SW0fh00hwBUEyVwxNCL7aXL6dcuRsb6F4(J)Kx8AtFvziMB9vrZGRgoiOE)qqXJ4gacHQDzqD8F8Rg)G7p7j(MTpiQdAW9xe1bq7iXTfecuNsxX(O3F8r)Tzd0RGhMx88bDJOWyGzqrtC3crmcoAkMmYWBTLQUJTUP(LvnW)tb()zFs9YQA0FERKd3HrEOD)z8J)8X37rSiUzDvEBeXGTQbRUnayJjd3wtD2WE03E04V9HYnJ6SFagUtoHgaE)LxIrSbW0vrNpaA62kk2Zg(J)KJg9DNm6jFmUZw)ZpLnjysduVLx8rKOQIJMntED8PVZfNIBG2JEoi2vGCdE8fnPhF0E05J3NeDWC2UBI8QsIH5a5YnL0yc6ORa1p(HJp(0lEaUrFF7BFXjFjH8csJjthp7gwsUU68J76Qzgy7ANDDvXPcK)jhn(HFPyDD0F(lh99hXaVIQLMbRkIecL64osyMUQAORub0)9aAFciuaF8p)dWhh9B(helQg6S7tkBjUBOOyiOlkAUkkva9Z)6NCXV)Zbq)HOUA2UE()9(m4BQPAtItQozPnkcAJPPHHPrf09p6F8I)x)Ml(ONcKCqTEgEsE3j4lKx1uHi5eehtvxD7ki9Jo7(JE8jJFV3z8ZqaF8)WOp6eoPxZ10HvPvcjwBBtDUI27Zyfg91phuDp6l(1Zptpefxul((uqqpvCvtvxG7wM4oJvbP)5)w2wr)7F(O)c8Vx8hpbeaiSN1Dc8APQBCTStxAv0DvRKTC0NJuLN8qyiO5lmEcQd2)TzxhVsHwhZS6Z0DRyTD8Zpg3s(tFaqiF)VB0JpffbKQZ0Dzw2tLzTXZ7Cg5k1Quk89phvj9OFG(WPK51l4WxX1uJvgDcW7cCt6zaVPDfGF09V)4)4zJ(8Np6DpLrDo7ig4nvnuuzKFRuotftnPghlLkfBbDW)W9hD2dh97Eid5p(yUohtBxxw1Hkjn6U6cXw4ZUQva8rFXNdAQLACE6lsvxY6obEHulW44Yo)i1b9SN)nFSqqC03)NyUza2BFnoYHzaNrzZye1ql7cNzLCE)Ppg4Kh)jFmAL7PcLamsRTgizsoRjnK6AJ1EXpYmg6Qzv4QkbVHURJBfG)SFy8NE2OpgmgDXPFpmto)BEkh6uVjWRLYyGrUZvzPBA6wHLOXF7daVAi0(I7D2O35eHYCt6eWG3m5mi76OOXnq)EpA0F99h9eqpnS6bEjj7IdXLQBKXWBQXfv84JyxPpjGSlz4fWQrV7dp)7FVl4N)xQ7e8nZslDZYkyzwb8p5TbpIzlsFXjaNkmR)GNieeC4SccPmdfhlhnj8bZ(6vTwboEE8xE(ZoJXL9Ehrtj(Qf1FAasL0CCneooa8koQvOJB0)YzJ)0)gJ(qgIXLag3GfyE1MrFCK4VTRLQulHHUUD1ULamdpaKIV4rF8O)YrJp6rs7xChc1tfen0sT(Ia3UslmJEmN4)bV9479emofoThwEjOBOiXDGtwqAGvwqLufI5x8EV94t)mubk5plyg73(eUTDx8WW4qWxnDT1rvAFXrtxrZOsFta2hwuv)W7L3aMULgDYiRzKAG0qxZ8hjQdiyXUXvtToQABLkM7OyOvbJZhDY4p5SrFnmapNXMIlYmDGu3jWBKs81vSKEfAAPyvfJ)NC6ONC8OV6uqjY4)eqLU4HpFexVa1Dc(Po166K6rUPIRHwv4p5glmoV3XJENxa4p8XhWdwbuIBWIB3ivYvdpIA8bGw(RYa5tWL2JoE0x(DquUSLHN)RZW(WwaSZqH0m(XHcLL9u6Aly3Gvw61h)9p5Ih9BzAOFm8NFwuVd35GOHdoChSeoFT5YzXGgGZIDP8UGdJqg2q1Xut4gNgOYVkBDq4qJp6HJ)cuX2)h0jRut9SUtPrqkeJLlBQBkUyjZuHuaOD(d(nmY)F9lr4FVhEoxkG6obF1SW35hF4NXAQUHwwH4QI96bV)O)6pWcR4bOY5)5FZ4V440qaCzNIjDj8nbD0PUXHL8tvgyoB0F5PKVmNF2)tQaqp)R)gHsivMnB5PyZfczkLj1wRkZxJ(OJaNXOWao)z8ix0H5njCjpVBqG6w2sxyGzGHt1mnp67qhXGaPF(fVZtbbbruxyVjOlDT1cOs6PgTmn0RY7ZJr3VU3NH(4YC)6ThlmRa6zyNjnjUJjAi1Lb3k16)DNHMsU3Nn6EhZmS8G7FrAaVm6Ttk)OP0ZzxniK1QYrcW9D2reHF0VLjJp(d)Ec8SUtGpt8OQwc1MQQqqtwAvZUFpmlgF09g)9OdKF0VgcqsqC0ny362kzy3nvKKEtBNkvh8UNo6PpF89EkMfdMp8hjnAHDNGVAk7oEe0emo2wMvXTNR(Nh)OxC(x)3sZdJMd)E2u8A9PXbub4MRqMzLR7ulF5Svft(68vERkKdQ415J4f)rA53LRO7yfJxcM)8cVuusMOOCP0xlAAsXsBodyZD9MYEJxfFqVMSAveMMnBJfrpMLC2M0QbcPynGqVVP8YCtlZUhIO6)B3o8xybSQCuUPunYq(QO6VlVgJ)Vpet9l78AWiTIY0xulOS30odg2FI9Xy)2aDh3Nb6s(Pxp62sCXFP41Na(79yhIHKmGRpw43taRuaG3rd1f3NA85hGOT8py76Gt)Ixob9WB(wFQ4QJA2AkVGxeL1P4ikWpYpSJKpV4AxIDOLIXJyaUV4d72JvmFYIVfVyHc6fhENGlH73bdgyf9Y(ue)HITar0w5gfHB3vcL05Inb33SOE0MlMwbOcoa8mXVFVuo3cyrJmJCJsg3gPJAJshtI2k2IiC3FYwdy4O2nWl9n9sbsi79otuVwHs2v(9rwm7cHLDevOLNc3tzjfFN0ake4fA7SMJl9QohtK1tmiZHdc)oZ3tUBv8ZTiTpwnekA2lOlv5UXEQygWXJjXDOdMdiD30tEZGXBnUjR07LnuSmoZnZF6OiMrSxRuTzhzJDb(Z38GmqNinzFdbUujGQB)odJzlGIQNnXNjtXEzFXpXaW8UpEAoAT8QKFsgSZrRd7IuL)m(fbnmzhCG81uruVT4LgnnOX83fF(hq59RE3OEuzNbY17UB4DzpDWqwNWZ8Vo8F4bcYFaMgv66xrCv2vOnDdl0lMBVSiJTEvWunoIAlXte7kfrXtjaE1Hnlev0MueL)lmeLFENvELOPZpMQb(Wufjv0MumL)ljVQR5Zp(blykvrjfTjZso7x4usYRvZxfevz(ru8Y)glY2zHOI2KIO8FjrC)eYExUrhejX18CD5BApu6KRSbrFf7FUQYpxt)WDaF0muUSP2BDDuPrD(HEBJER0RfeHiEt3gaF4ToCNM4Mtg2BVd3jPDWH7WvqHrrsD5WD8t4pka7A0U8VbtZfibGYgtc5wMPzy1WEHXTdA9ZEnA8ykXOdrhDD3C4o)Nbioyi71c4ljWKh4X99H)ecHaZ0)UavbDtamfg1ylCCVc7nePKySav)4L0LLauDzqFVVGID7GdoCh6c28Y03DO)YCANLaOV5SX)5xaU9(BodIbz8PymiS28h)omMHV4KlZYR6NZDH9Hpz87EgDo0Zn(6AxwtD2OSDPDzEr5p5jJE2rJ(0NmpiNtHrccIrZC2iNBPDzorUlo5KXhF65)lyYyFVJbKC0V7H45RC(iLOGy(XgcNWz2ORQAP9zoXxCxT)0hcHDcrYoxyyrrhnfy1RcmuV0(mNy45FhgT9JFVXpctQ1V7HJ)tNCX9pAUW1IctOWHZBDLRT46RVsTRUI313y5vWxvhBUfboXR1taAD9VDG8nUlj1JoPrc97cUVemBDc0tBfqxZXrmhw4xxwutmPNZV7sLVzakaCUd(EYtLCXbplgUF7GEEyTenbkGNuv(9ZfDdHt4C(wXVzVPG1YIMYgqZWw4P5KE)nivXMTn0FeRDSfU3eWNlxXIKSHR1cESgTBsQ5vOzEzt9lR8tTfbvRYh0xntcQ2V0qBg2euDkcnTlB6wHmNBP9PszogVjVqr(0)24hJBm2Z(kCtOp(y2ZU3Zh))(Daley(y(Z)aMZUVC8x8qA7d0ukmQgUG6OzJPAQL2N5ft)RV)439PGk3QXnTIJdQqOcCtV0(mV4glHsp4OZ)NE7QrpJIdL6LnQqXQMzP9zorVl(Kp7I355Iniy8to6IJF6O79LvJPffv0Hbw5FxT6p5QvnZQwD6Rqf0PAsVSulQqsX(Ykg)u7LTt5d6RMovn3sGwf(zQRuAFQuaXI5EXdoc0TaUCW(2hCY4)4xH79iURJJo(OZp7DOAHOWiOaU3ubwPvAFMBS6eC3HF0Zh9N)sPBLLJB51EzGwHQYZCDJs7ZCIBJo5TfxQiJ)Kpgm1tvnW0rqZcdMHnmE)RVMevL))Dvjw58qRKfN8krSmTzVumtxTuWOIUSU1pX6q0TlFqFfdv3PeOvH)j6UL2NkLi4mr)ieGTHsbmq1b3tPzI1gQL2N5gRFzIX2qR4yPddxf4NEP9zEXV)(cZ2WO4GRCzZQqyZs7Z8IWVSXzBuuytX5YAv4ZVHDP9zErXx9aTnkkwPGwA)39i8NC148vUx1iTX7Xon9FUIlBDZc0RjLd(PsJUy7kLVGtdBH7ApDN243SDXDqnOdSOfGxt1bD4xfwciqTxCest4xWlT9hCNGyK6TlEDscFnH3hEQNfxvu4Ws35xITDLNP88Jpnq0juJUGRXnQB3WbX0XlQo7M(s8EOxag2BQYGM8RFWmh(S8BHlonIWnel92QtEvEXYIFx6wnxJU4g9KVW(zj8pAq4BIhcTo1XxHPneTHAsKhI2t92TWK(pX7owAt5eajmED5jho9DJAyS8ojJVet7NaDPHtxDO5qn2I0)M(nBj72zThxKx8(inpBj7QZJQpadh6shrUeNDNEZ9QgNDJxvCZ0t3SFjdWMlU2Y54AiMkGpRkog6wBQf7DGROkls56L888Zck)izlzOyF)1doGVzoI99DJg)3cAMCfXHAK9ooJE1cTmXnZKHxbg7d3zTE4D1ARH0RTmcEc4Ub71QB6EfLoWzhM6dBSfobr0O8bAXosyF4oxb6kGuTkhi1OoZhn5sBMxWcjBV9)V)"

local function asMOD_Import_Layout(text, name)
	local importLayoutInfo = C_EditMode.ConvertStringToLayoutInfo(text);
	if not layoutInfo then
		layoutInfo = C_EditMode.GetLayouts();
	end

	if importLayoutInfo and layoutInfo then
		local layoutType = Enum.EditModeLayoutType.Account;
		importLayoutInfo.layoutType = layoutType;
		importLayoutInfo.layoutName = name;

		local newLayoutIndex = 1;

		for index, layout in ipairs(layoutInfo.layouts) do
			if layout.layoutType == layoutType and layout.layoutName == name then
				newLayoutIndex = 0;
				layoutInfo.layouts[index] = importLayoutInfo;
				break;
			else
				newLayoutIndex = newLayoutIndex + 1;
			end
		end

		if newLayoutIndex > 0 then
			table.insert(layoutInfo.layouts, newLayoutIndex, importLayoutInfo);
		end
	end
end

local function asMOD_Import_Commit()
	C_EditMode.SaveLayouts(layoutInfo);

	local layoutinfo = C_EditMode.GetLayouts()
	local index = nil;

	for i, element in ipairs(layoutinfo.layouts) do
		if element.layoutName == "asMOD_layout" then
			index = i;
			break;
		end
	end

	if index then
		C_EditMode.SetActiveLayout(index + 2);
	end
end


local function asMOD_Setup()
	-- 모든 UI 위치를 Reset 한다.
	asMOD_position = {};

	local curr = GetCVar("uiScale");

	if curr then
		curr = tonumber(curr);
	else
		curr = 1;
	end

	print("[asMOD] UI Scale 을 조정합니다.");
	SetCVar("useUiScale", "1");

	if asMOD_UIScale then
		if (asMOD_UIScale < 0.64) then
			UIParent:SetScale(asMOD_UIScale)
		else
			SetCVar("uiScale", asMOD_UIScale)
		end
	end

	LoadAddOn("Skada")

	print("[asMOD] 재사용 대기시간을 보이게 합니다.");
	SetCVar("countdownForCooldowns", "1");

	print("[asMOD] 힐량와 데미지를 보이게 합니다.");
	SetCVar("floatingCombatTextCombatHealing", 1);
	SetCVar("floatingCombatTextCombatDamage", 1);

	print("[asMOD] 이름표 항상 표시");
	SetCVar("nameplateShowAll", 1)
	SetCVar("nameplateShowEnemies", 1)
	SetCVar("nameplateShowFriends", 0)
	SetCVar("nameplateShowFriendlyNPCs", 0)

	print("[asMOD] 개인 자원바를 끕니다.");
	SetCVar("nameplateShowSelf", "0");

	print("[asMOD] 공격대창 직업 색상 표시");
	SetCVar("raidFramesDisplayClassColor", 1)

	print("[asMOD] Unit Frame 설정 변경");
	SetCVar("showTargetOfTarget", 1)

	print("[asMOD] 채팅창에 직업색상을 표시하게 합니다.");
	ToggleChatColorNamesByClassGroup(true, "SAY")
	ToggleChatColorNamesByClassGroup(true, "EMOTE")
	ToggleChatColorNamesByClassGroup(true, "YELL")
	ToggleChatColorNamesByClassGroup(true, "GUILD")
	ToggleChatColorNamesByClassGroup(true, "OFFICER")
	ToggleChatColorNamesByClassGroup(true, "GUILD_ACHIEVEMENT")
	ToggleChatColorNamesByClassGroup(true, "ACHIEVEMENT")
	ToggleChatColorNamesByClassGroup(true, "WHISPER")
	ToggleChatColorNamesByClassGroup(true, "PARTY")
	ToggleChatColorNamesByClassGroup(true, "PARTY_LEADER")
	ToggleChatColorNamesByClassGroup(true, "RAID")
	ToggleChatColorNamesByClassGroup(true, "RAID_LEADER")
	ToggleChatColorNamesByClassGroup(true, "RAID_WARNING")
	ToggleChatColorNamesByClassGroup(true, "INSTANCE_CHAT")
	ToggleChatColorNamesByClassGroup(true, "INSTANCE_CHAT_LEADER")

	asMOD_Import_Layout(layout, "asMOD_layout");
	asMOD_Import_Commit();

	print("[asMOD] Details, Bigwigs, DBM 설정을 합니다.");

	local bload = LoadAddOn("BugSack")

	if bload then
		BugSackDB = {
			["soundMedia"] = "BugSack: Fatality",
			["altwipe"] = true,
			["useMaster"] = false,
			["fontSize"] = "GameFontHighlight",
			["mute"] = true,
			["auto"] = false,
			["chatframe"] = false,
		}
		BugSackLDBIconDB = {
			["minimapPos"] = 234.2022186215915,
		}
	end

	bload = LoadAddOn("DBM-Core")
	if bload then
		DBM_AllSavedOptions = {
			["Default"] = {
				["DontShowFarWarnings"] = true,
				["FilterInterrupt2"] = "TandFandBossCooldown",
				["SpamSpecRolestack"] = false,
				["InfoFrameX"] = -357.1292419433594,
				["DontShowNameplateIcons"] = true,
				["SpecialWarningFlash5"] = true,
				["FilterInterruptNoteName"] = false,
				["EnableModels"] = true,
				["DontPlayTrivialSpecialWarningSound"] = true,
				["SWarnNameInNote"] = true,
				["DontShowPTCountdownText"] = false,
				["InfoFramePoint"] = "BOTTOMRIGHT",
				["OverrideBossSay"] = false,
				["WorldBossAlert"] = false,
				["SpamSpecInformationalOnly"] = false,
				["WorldBuffAlert"] = false,
				["SpamSpecRoledispel"] = false,
				["ShowGuildMessages"] = false,
				["ShowAllVersions"] = true,
				["SpecialWarningSound3"] = "Interface\\AddOns\\DBM-Core\\sounds\\AirHorn.ogg",
				["SpamSpecRolesoak"] = false,
				["ShowWarningsInChat"] = false,
				["InfoFrameFontStyle"] = "None",
				["WarningFontStyle"] = "None",
				["VPReplacesSA1"] = true,
				["ChatFrame"] = "DEFAULT_CHAT_FRAME",
				["RangeFrameRadarX"] = -230.9038238525391,
				["LogCurrentRaids"] = true,
				["InfoFrameCols"] = 0,
				["LatencyThreshold"] = 250,
				["ShowGuildMessagesPlus"] = false,
				["LFDEnhance"] = true,
				["LogCurrentMythicRaids"] = true,
				["HideBossEmoteFrame2"] = true,
				["DisableChatBubbles"] = false,
				["NPAuraSize"] = 40,
				["HideObjectivesFrame"] = true,
				["SpecialWarningShortText"] = true,
				["DontShowPTText"] = false,
				["FilterBInterruptHealer"] = false,
				["SpecialWarningFontSize2"] = 20.12609481811523,
				["SpecialWarningFlashCol5"] = {
					0.2, -- [1]
					1, -- [2]
					1, -- [3]
				},
				["NewsMessageShown2"] = 1,
				["EventSoundPullTimer"] = "None",
				["SpecialWarningVibrate2"] = false,
				["SpecialWarningFlashCount2"] = 1,
				["NPAuraText"] = true,
				["EventSoundDungeonBGM"] = "None",
				["DisableRaidIcons"] = false,
				["VPReplacesCustom"] = false,
				["VPReplacesSA4"] = true,
				["SpecialWarningFlashDura3"] = 1,
				["WarningShortText"] = true,
				["SpecialWarningFlash4"] = true,
				["DisableSFX"] = false,
				["SpecialWarningFlashDura4"] = 0.7,
				["SpecialWarningFlashCol3"] = {
					1, -- [1]
					0, -- [2]
					0, -- [3]
				},
				["ModelSoundValue"] = "Short",
				["SpecialWarningY"] = 75,
				["VPReplacesSA2"] = true,
				["ReplaceMyConfigOnOverride"] = false,
				["LogTrivialDungeons"] = false,
				["WarningY"] = 260,
				["CustomSounds"] = 0,
				["ShortTimerText"] = true,
				["LogCurrentMPlus"] = true,
				["DontPlayPTCountdown"] = false,
				["DoNotLogLFG"] = true,
				["WarningIconLeft"] = true,
				["RangeFrameLocked"] = false,
				["DontDoSpecialWarningVibrate"] = false,
				["SpamSpecRolegtfo"] = false,
				["SpecialWarningFlashDura2"] = 0.4,
				["LogTrivialRaids"] = false,
				["GroupOptionsExcludeIcon"] = false,
				["FilterBTargetFocus"] = true,
				["RecordOnlyBosses"] = false,
				["DontPlayCountdowns"] = false,
				["OverrideBossIcon"] = false,
				["SpecialWarningFlashAlph1"] = 0.3,
				["ShowDefeatMessage"] = false,
				["DontShowRangeFrame"] = true,
				["InfoFrameShowSelf"] = false,
				["WarningFontShadow"] = true,
				["DontShowBossTimers"] = false,
				["SpecialWarningFontStyle"] = "THICKOUTLINE",
				["DontShowBossAnnounces"] = false,
				["BadIDAlert"] = false,
				["WarningIconChat"] = false,
				["HideGuildChallengeUpdates"] = true,
				["ShowPizzaMessage"] = false,
				["RangeFrameSound2"] = "none",
				["GUIHeight"] = 600,
				["LogCurrentMythicZero"] = false,
				["GUIWidth"] = 800,
				["FilterVoidFormSay"] = true,
				["EventSoundMusic"] = "None",
				["LogTWRaids"] = false,
				["NoTimerOverridee"] = true,
				["HelpMessageVersion"] = 3,
				["SpecialWarningFlashAlph2"] = 0.3,
				["DontShowHudMap2"] = true,
				["SpecialWarningFlashCount4"] = 2,
				["ShowSWarningsInChat"] = false,
				["SpamSpecRoledefensive"] = false,
				["RangeFrameRadarY"] = 0.9783453345298767,
				["OverrideBossAnnounce"] = false,
				["CoreSavedRevision"] = 20231014081759,
				["RangeFrameX"] = -229.7040557861328,
				["RangeFrameY"] = 76.74076080322266,
				["SpecialWarningFlashAlph3"] = 0.4,
				["FilterTInterruptHealer"] = false,
				["FakeBWVersion"] = false,
				["NPIconXOffset"] = 0,
				["SpecialWarningFlashCol2"] = {
					1, -- [1]
					0.5, -- [2]
					0, -- [3]
				},
				["WarningAlphabetical"] = true,
				["SpecialWarningPoint"] = "CENTER",
				["FilterBInterruptCooldown"] = true,
				["CheckGear"] = true,
				["SpecialWarningX"] = 0,
				["DontShowPT2"] = false,
				["MoviesSeen"] = {
				},
				["ShowQueuePop"] = true,
				["SpecialWarningFlashCol4"] = {
					1, -- [1]
					0, -- [2]
					1, -- [3]
				},
				["DebugMode"] = false,
				["DisableGuildStatus"] = false,
				["ShowReminders"] = true,
				["SpecialWarningFontCol"] = {
					1, -- [1]
					0.7, -- [2]
					0, -- [3]
				},
				["AFKHealthWarning2"] = false,
				["SpecialWarningVibrate1"] = false,
				["EventSoundEngage2"] = "None",
				["InfoFrameY"] = 18.01542472839356,
				["SpecialWarningSound"] = 569200,
				["WarningIconRight"] = false,
				["UseSoundChannel"] = "Dialog",
				["ShowRespawn"] = true,
				["DontAutoGossip"] = false,
				["VPReplacesSA3"] = true,
				["AlwaysShowSpeedKillTimer2"] = false,
				["NoAnnounceOverride"] = true,
				["DebugLevel"] = 1,
				["VPReplacesGTFO"] = true,
				["BadTimerAlert"] = false,
				["DontShowPTNoID"] = false,
				["HideGarrisonToasts"] = true,
				["RangeFramePoint"] = "BOTTOMRIGHT",
				["SpecialWarningFontShadow"] = false,
				["EventMusicMythicFilter"] = false,
				["SpecialWarningFlashCol1"] = {
					1, -- [1]
					1, -- [2]
					0, -- [3]
				},
				["SpecialWarningVibrate4"] = true,
				["SWarnClassColor"] = true,
				["UseNameplateHandoff"] = true,
				["SpecialWarningFlashAlph4"] = 0.4,
				["PTCountThreshold2"] = 5,
				["VPReplacesAnnounce"] = true,
				["oRA3AnnounceConsumables"] = false,
				["CountdownVoice2"] = "Kolt",
				["EnableWBSharing"] = false,
				["ArrowPosX"] = 0,
				["AITimer"] = true,
				["LogTWDungeons"] = false,
				["SpecialWarningSound4"] = 552035,
				["DontShowTrashTimers"] = false,
				["GUIX"] = -56.77048492431641,
				["LogCurrentHeroic"] = false,
				["VPDontMuteSounds"] = false,
				["WarningColors"] = {
					{
						["b"] = 0.9411765336990356,
						["g"] = 0.8000000715255737,
						["r"] = 0.4117647409439087,
					}, -- [1]
					{
						["b"] = 0,
						["g"] = 0.9490196704864502,
						["r"] = 0.9490196704864502,
					}, -- [2]
					{
						["b"] = 0,
						["g"] = 0.501960813999176,
						["r"] = 1,
					}, -- [3]
					{
						["b"] = 0.1019607931375504,
						["g"] = 0.1019607931375504,
						["r"] = 1,
					}, -- [4]
				},
				["SWarningAlphabetical"] = true,
				["BlockNoteShare"] = false,
				["DontPlaySpecialWarningSound"] = false,
				["RangeFrameRadarPoint"] = "BOTTOMRIGHT",
				["DontShowInfoFrame"] = true,
				["MovieFilter2"] = "Never",
				["DontRestoreRange"] = false,
				["SpecialWarningFlashCount3"] = 3,
				["DontShowNameplateIconsCD"] = false,
				["WhisperStats"] = false,
				["SilentMode"] = false,
				["NPIconYOffset"] = 0,
				["InfoFrameLocked"] = true,
				["SpecialWarningFlashAlph5"] = 0.5,
				["SpecialWarningDuration2"] = 1.5,
				["AlwaysPlayVoice"] = false,
				["WarningX"] = 0,
				["ShowEngageMessage"] = false,
				["RangeFrameSound1"] = "none",
				["ArrowPoint"] = "TOP",
				["WarningFontSize"] = 16.47568893432617,
				["EventSoundVictory2"] = "Interface\\AddOns\\DBM-Core\\sounds\\Victory\\SmoothMcGroove_Fanfare.ogg",
				["AutoExpandSpellGroups"] = false,
				["LastRevision"] = 0,
				["GUIPoint"] = "CENTER",
				["SettingsMessageShown"] = true,
				["DontRestoreIcons"] = false,
				["SpecialWarningFlash1"] = true,
				["SpecialWarningVibrate3"] = true,
				["FilterTInterruptCooldown"] = true,
				["DontSetIcons"] = false,
				["SpecialWarningSound2"] = 543587,
				["EventSoundMusicCombined"] = false,
				["CountdownVoice"] = "Corsica",
				["SpamSpecRoletaunt"] = false,
				["WarningFont"] = "standardFont",
				["CountdownVoice3"] = "Smooth",
				["SpamSpecRoleswitch"] = false,
				["DisableStatusWhisper"] = false,
				["AutoRespond"] = true,
				["EventDungMusicMythicFilter"] = false,
				["GUIY"] = -0.0002178665745304897,
				["RangeFrameFrames"] = "radar",
				["WarningPoint"] = "CENTER",
				["FilterTrashWarnings2"] = true,
				["SpecialWarningIcon"] = true,
				["InfoFrameFont"] = "standardFont",
				["GroupOptionsBySpell"] = true,
				["AdvancedAutologBosses"] = false,
				["FilterTankSpec"] = true,
				["HideTooltips"] = false,
				["SpecialWarningVibrate5"] = true,
				["OverrideBossTimer"] = false,
				["DontShowTargetAnnouncements"] = true,
				["SpecialWarningFlashDura5"] = 1,
				["SpecialWarningFlashCount5"] = 3,
				["ChosenVoicePack2"] = "None",
				["EventSoundWipe"] = "None",
				["DontShowSpecialWarningFlash"] = false,
				["RLReadyCheckSound"] = true,
				["InfoFrameLines"] = 0,
				["WorldBossNearAlert"] = false,
				["DontSendBossGUIDs"] = false,
				["SpecialWarningFlashDura1"] = 0.3,
				["ArrowPosY"] = -150,
				["AutoAcceptFriendInvite"] = false,
				["AutoReplySound"] = true,
				["SpecialWarningFlashCount1"] = 1,
				["PullVoice"] = "Corsica",
				["SpecialWarningSound5"] = 554236,
				["DontSendYells"] = false,
				["SpamSpecRoleinterrupt"] = false,
				["SpecialWarningFlash2"] = true,
				["DontShowEventTimers"] = false,
				["SpecialWarningFlash3"] = true,
				["DontShowSpecialWarningText"] = false,
				["Enabled"] = true,
				["SpecialWarningFont"] = "standardFont",
				["ShowWAKeys"] = true,
				["WarningDuration2"] = 1.5,
				["AutoAcceptGuildInvite"] = false,
				["DontShowTimersWithNameplates"] = true,
				["AutologBosses"] = false,
				["InfoFrameFontSize"] = 12,
				["StripServerName"] = true,
				["RangeFrameUpdates"] = "Average",
				["FilterTTargetFocus"] = true,
				["DontShowUserTimers"] = false,
				["RaidWarningSound"] = 566558,
				["AFKHealthWarning"] = false,
				["RoleSpecAlert"] = true,
				["FilterDispel"] = true,
			},
		}
		DBM_MinimapIcon = {
			["minimapPos"] = 249.9876931591084,
		}


		DBT_AllPersistentOptions = {
			["Default"] = {
				["DBM"] = {
					["StartColorPR"] = 1,
					["Scale"] = 0.9,
					["HugeBarsEnabled"] = false,
					["StartColorR"] = 1,
					["EndColorPR"] = 0.5,
					["Sort"] = "Sort",
					["ExpandUpwardsLarge"] = false,
					["ExpandUpwards"] = true,
					["TimerPoint"] = "BOTTOMRIGHT",
					["EndColorDG"] = 0,
					["Alpha"] = 0.8,
					["HugeTimerPoint"] = "CENTER",
					["StartColorIR"] = 0.47,
					["StartColorUIR"] = 1,
					["StartColorAG"] = 0.545,
					["EndColorDR"] = 1,
					["TDecimal"] = 11,
					["StartColorRR"] = 0.5,
					["StartColorUIG"] = 1,
					["FillUpLargeBars"] = true,
					["HugeScale"] = 1.03,
					["BarYOffset"] = 0,
					["StartColorDG"] = 0.3,
					["StartColorAR"] = 0.375,
					["TextColorR"] = 1,
					["EndColorAER"] = 1,
					["StartColorIB"] = 1,
					["IconRight"] = false,
					["Font"] = "standardFont",
					["EndColorDB"] = 1,
					["EndColorAEB"] = 0.247,
					["Height"] = 20,
					["HugeSort"] = "Sort",
					["BarXOffset"] = 0,
					["EndColorB"] = 0,
					["EndColorAR"] = 0.15,
					["EndColorG"] = 0,
					["StartColorIG"] = 0.97,
					["StartColorDB"] = 1,
					["NoBarFade"] = false,
					["FadeBars"] = true,
					["TextColorB"] = 1,
					["EndColorIB"] = 1,
					["StartColorAER"] = 1,
					["StartColorAEG"] = 0.466,
					["EndColorRB"] = 0.3,
					["TimerX"] = -106.855583190918,
					["EndColorIR"] = 0.047,
					["Width"] = 235,
					["EndColorRR"] = 0.11,
					["Bar7ForceLarge"] = false,
					["BarStyle"] = "NoAnim",
					["EnlargeBarTime"] = 11,
					["Spark"] = true,
					["StartColorDR"] = 0.9,
					["StartColorRG"] = 1,
					["FontFlag"] = "None",
					["EndColorAB"] = 1,
					["IconLocked"] = true,
					["EndColorPG"] = 0.41,
					["HugeHeight"] = 20,
					["EndColorIG"] = 0.88,
					["EndColorAEG"] = 0.043,
					["StartColorPG"] = 0.776,
					["StartColorAEB"] = 0.459,
					["Texture"] = "Interface\\AddOns\\Details\\images\\BantoBar",
					["TextColorG"] = 1,
					["KeepBars"] = true,
					["HugeTimerX"] = -326.1634826660156,
					["HugeTimerY"] = 2.310630559921265,
					["HugeAlpha"] = 1,
					["ColorByType"] = true,
					["IconLeft"] = true,
					["HugeWidth"] = 100,
					["EndColorUIG"] = 0.92156862745098,
					["EndColorUIB"] = 0.0117647058823529,
					["StartColorAB"] = 1,
					["Bar7CustomInline"] = true,
					["TimerY"] = 244.8362579345703,
					["FillUpBars"] = true,
					["DesaturateValue"] = 1,
					["HugeBarYOffset"] = 0,
					["FlashBar"] = false,
					["EndColorUIR"] = 1,
					["EndColorRG"] = 1,
					["StartColorUIB"] = 0.0627450980392157,
					["StartColorG"] = 0.7,
					["FontSize"] = 10,
					["EndColorPB"] = 0.285,
					["EndColorR"] = 1,
					["StartColorPB"] = 0.42,
					["DynamicColor"] = true,
					["StartColorRB"] = 0.5,
					["EndColorAG"] = 0.385,
					["InlineIcons"] = true,
					["StartColorB"] = 0,
					["HugeBarXOffset"] = 0,
					["Skin"] = "",
					["ClickThrough"] = false,
				},
			},
		}
	end


	bload = LoadAddOn("Details")
	if bload then
		Details:EraseProfile("asMOD");
		Details:ImportProfile(detailsprofile, "asMOD", true, true);
	end
	ReloadUI();
end

local function asMOD_Popup()
	StaticPopup_Show("asMOD")
end


local function funcDragStop(self)
	local _, _, _, x, y = self:GetPoint();
	self.text:SetText(self.addonName .. "\n" .. string.format("%5.1f", x) .. "\n" .. string.format("%5.1f", y));
	self.StopMovingOrSizing(self);
end

local asMOD_AFFL_frame;
local asMOD_ACB_frame;
local asMOD_ASQA_frame;

local function setupFrame(frame, Name, addonName, config)
	frame = CreateFrame("Frame", Name, UIParent)
	frame.addonName = addonName;
	frame.text = frame:CreateFontString(nil, "OVERLAY")
	frame.text:SetFont("Fonts\\2002.TTF", 10, "OUTLINE")
	frame.text:SetPoint("CENTER", frame, "CENTER", 0, 0)
	frame.text:SetText(frame.addonName);
	frame:SetMovable(true)
	frame:EnableMouse(true)
	frame:RegisterForDrag("LeftButton")
	frame:SetFrameStrata("HIGH");
	frame:SetScript("OnDragStart", frame.StartMoving)
	frame:SetScript("OnDragStop", funcDragStop);
	-- The code below makes the frame visible, and is not necessary to enable dragging.
	frame:SetPoint(config["anchor1"], config["parent"], config["anchor2"], config["x"], config["y"]);
	if config["width"] and config["width"] > 5 then
		frame:SetWidth(config["width"]);
	else
		frame:SetWidth(40);
	end

	if config["height"] and config["height"] > 5 then
		frame:SetHeight(config["height"]);
	else
		frame:SetHeight(10);
	end

	local tex = frame:CreateTexture(nil, "ARTWORK");
	tex:SetAllPoints();
	tex:SetTexture(1.0, 0.5, 0); tex:SetAlpha(0.5);
	return frame
end


function asMOD_setupFrame(frame, addonName)
	local parent;
	asMOD_t_position[addonName] = {
		["name"] = addonName,
		["parent"] = "UIParent",
		["anchor1"] = "CENTER",
		["anchor2"] = "CENTER",
		["x"] = 0,
		["y"] = 0,
		["width"] = 0,
		["height"] = 0
	};
	asMOD_t_position[addonName]["anchor1"], _, asMOD_t_position[addonName]["anchor2"], asMOD_t_position[addonName]["x"], asMOD_t_position[addonName]["y"] =
		frame:GetPoint();
	asMOD_t_position[addonName]["width"] = frame:GetWidth();
	asMOD_t_position[addonName]["height"] = frame:GetHeight();

	if asMOD_position[addonName] then
		frame:ClearAllPoints();
		frame:SetPoint(asMOD_position[addonName]["anchor1"], asMOD_position[addonName]["parent"],
			asMOD_position[addonName]["anchor2"], asMOD_position[addonName]["x"], asMOD_position[addonName]["y"])
	end
end

local framelist = {};

local function asMOD_Popup_Config()
	for i, value in pairs(asMOD_t_position) do
		local index = value["name"]

		if not asMOD_position[index] then
			asMOD_position[index] = asMOD_t_position[index]
		end
		framelist[index] = nil


		framelist[index] = setupFrame(framelist[index], "asMOD_frame" .. index, index, asMOD_position[index]);
	end

	StaticPopup_Show("asConfig")
end

local function asMOD_Cancel_Position()
	for i, value in pairs(asMOD_t_position) do
		local index = value["name"]
		framelist[index]:Hide()
	end
end


local function asMOD_Setup_Position()
	for i, value in pairs(asMOD_t_position) do
		local index = value["name"]
		asMOD_position[index]["anchor1"], _, asMOD_position[index]["anchor2"], asMOD_position[index]["x"], asMOD_position[index]["y"] =
			framelist[index]:GetPoint();
	end
	asMOD_Cancel_Position();

	ReloadUI();
end


local function asMOD_Popup_Clear()
	StaticPopup_Show("asClear")
end

local function asMOD_Clear()
	asMOD_position = {};
	ReloadUI();
end

local function asMOD_Popup_Layout()
	StaticPopup_Show("asImport")
end
local layoutInfo;

local function asMOD_OnEvent(self, event, arg1)
	if event == "ADDON_LOADED" and arg1 == "asMOD" then
		if not asMOD_version or asMOD_version ~= asMOD_CurrVersion then
			asMOD_Popup()
			asMOD_config = true;
			asMOD_version = asMOD_CurrVersion;
		end

		DEFAULT_CHAT_FRAME:AddMessage("/asMOD : 최적화된 Interface 옵션 Setup")
		DEFAULT_CHAT_FRAME:AddMessage("/asConfig : asMOD 의 위치 조정")
		DEFAULT_CHAT_FRAME:AddMessage("/asClear : asMOD 기본 위치로 설정 초기화")
		DEFAULT_CHAT_FRAME:AddMessage("/asImport : asMOD Layout 을 편집모드에 추가")

		SlashCmdList['asMOD'] = asMOD_Popup
		SlashCmdList['asConfig'] = asMOD_Popup_Config
		SlashCmdList['asClear'] = asMOD_Popup_Clear
		SlashCmdList['asImport'] = asMOD_Popup_Layout
		SLASH_asMOD1 = '/asMOD'
		SLASH_asConfig1 = '/asConfig'
		SLASH_asClear1 = '/asClear'
		SLASH_asImport1 = '/asImport'
	end

	return;
end

asMOD = CreateFrame("Frame")
asMOD:SetScript("OnEvent", asMOD_OnEvent)
asMOD:RegisterEvent("ADDON_LOADED")
asMOD:RegisterEvent("PLAYER_ENTERING_WORLD")


StaticPopupDialogs["asMOD"] = {
	text = "asMOD가 '기본 인터페이스 설정'을 변경합니다. \n채팅창에 '/asMOD'명령어로 기능을 다시 불러 올 수 있습니다.",
	button1 = "변경",
	button2 = "다음에",
	OnAccept = function()
		asMOD_Setup()
	end,
	timeout = 0,
	whileDead = true,
	hideOnEscape = true,
	preferredIndex = 3,
}


StaticPopupDialogs["asConfig"] = {
	text = "asMOD 애드온의 위치를 조정 합니다. 완료를 누르면 위치가 저장 됩니다. 원치 않을 경우 취소를 누르세요",
	button1 = "완료",
	button2 = "취소",
	OnAccept = function()
		asMOD_Setup_Position()
	end,

	OnCancel = function(_, reason)
		asMOD_Cancel_Position();
	end,
	timeout = 0,
	whileDead = true,
	hideOnEscape = true,
	preferredIndex = 3,
}


StaticPopupDialogs["asClear"] = {
	text = "asMOD 위치를 모두 기본으로 초기화 합니다.",
	button1 = "변경",
	button2 = "다음에",
	OnAccept = function()
		asMOD_Clear()
	end,
	timeout = 0,
	whileDead = true,
	hideOnEscape = true,
	preferredIndex = 3,
}

StaticPopupDialogs["asImport"] = {
	text = "편집모드에 asMOD Layout 1 과 2를 추가 하시겠습니까? 적용후 esc > 편집모드에서 적용 가능합니다.",
	button1 = "변경",
	button2 = "다음에",
	OnAccept = function()
		asMOD_Import_Layout(layout, "asMOD_layout");
		asMOD_Import_Commit();
		--ReloadUI();
	end,
	timeout = 0,
	whileDead = true,
	hideOnEscape = true,
	preferredIndex = 3,
}
