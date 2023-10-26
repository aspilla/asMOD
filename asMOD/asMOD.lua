local asMOD;
local asMOD_UIScale = 0.75;
local asMOD_CurrVersion = 231020;
local bAction = false;
asMOD_t_position = {};

if not asMOD_position then
	asMOD_position = {}
end


local layout =
"0 39 0 0 0 0 6 MultiBarBottomLeft 0.0 -4.0 -1 ##$$%/&%'%)#+# 0 1 1 7 7 UIParent 0.0 45.0 -1 ##$$%/&%'%(#,$ 0 2 0 8 2 MultiBarBottomLeft 0.0 4.0 -1 ##$$%/&%'%(#,# 0 3 1 5 5 UIParent -5.0 -77.0 -1 #$$$%/&%'%(#,$ 0 4 1 5 5 UIParent -5.0 -77.0 -1 #$$$%/&%'%(#,$ 0 5 0 0 0 UIParent 1111.9 -439.8 -1 ##$'%/&%'%(#,# 0 6 0 5 5 UIParent -1172.2 -470.0 -1 ##$&%/&$'%(%,# 0 7 0 3 3 UIParent 1172.2 -470.2 -1 ##$&%/&$'%(%,# 0 10 1 7 7 UIParent 0.0 45.0 -1 ##$$&%'% 0 11 1 7 7 UIParent 0.0 45.0 -1 ##$$&%'%,# 0 12 1 7 7 UIParent 0.0 45.0 -1 ##$$&%'% 1 -1 0 4 4 UIParent 0.0 -301.8 -1 ##$#%# 2 -1 1 2 2 UIParent 0.0 0.0 -1 ##$#%( 3 0 0 0 0 UIParent 576.2 -689.0 -1 $#3# 3 1 0 0 0 UIParent 1013.2 -689.0 -1 %#3# 3 2 0 0 2 TargetFrame -31.5 -4.0 -1 %#&#3# 3 3 0 0 0 UIParent 339.2 -356.0 -1 '$(#)#-S.5/#1$3# 3 4 0 0 0 UIParent 3.0 -546.0 -1 ,$-=.-/#0#1#2( 3 5 0 2 2 UIParent -324.2 -374.0 -1 &$*$3# 3 6 0 2 2 UIParent -312.2 -376.0 -1 -#.#/#4& 3 7 1 4 4 UIParent 0.0 0.0 -1 3# 4 -1 0 4 4 UIParent 0.0 -326.2 -1 # 5 -1 0 3 5 ChatFrame1 29.0 38.1 -1 # 6 0 1 2 2 UIParent -255.0 -10.0 -1 ##$#%#&.(()( 6 1 1 2 2 UIParent -270.0 -155.0 -1 ##$#%#'+(()( 7 -1 0 1 1 UIParent -7.0 -794.0 -1 # 8 -1 0 6 6 UIParent 35.0 50.0 -1 #'$A%$&7 9 -1 1 7 7 UIParent 0.0 45.0 -1 # 10 -1 1 0 0 UIParent 16.0 -116.0 -1 # 11 -1 0 3 3 UIParent 1272.2 -382.3 -1 # 12 -1 1 2 2 UIParent -110.0 -275.0 -1 #K$# 13 -1 1 8 8 MicroButtonAndBagsBar 0.0 0.0 -1 ##$#%#&- 14 -1 1 2 2 MicroButtonAndBagsBar 0.0 10.0 -1 ##$#%( 15 0 0 2 0 BuffFrame -4.0 0.0 -1 # 15 1 0 2 8 MainStatusTrackingBarContainer 0.0 -4.0 -1 # 16 -1 1 5 5 UIParent 0.0 0.0 -1 #( 17 -1 1 1 1 UIParent 0.0 -100.0 -1 ## 18 -1 1 5 5 UIParent 0.0 0.0 -1 #- 19 -1 0 0 6 EncounterBar 0.0 -4.0 -1 ##"
local version = select(4, GetBuildInfo());
if version == 100200 then
	asMOD_CurrVersion = 231116;
	layout =
	"1 39 0 0 0 0 6 MultiBarBottomLeft 0.0 -4.0 -1 ##$$%/&%'%)#+# 0 1 1 7 7 UIParent 0.0 45.0 -1 ##$$%/&%'%(#,$ 0 2 0 8 2 MultiBarBottomLeft 0.0 4.0 -1 ##$$%/&%'%(#,# 0 3 1 5 5 UIParent -5.0 -77.0 -1 #$$$%/&%'%(#,$ 0 4 1 5 5 UIParent -5.0 -77.0 -1 #$$$%/&%'%(#,$ 0 5 0 0 0 UIParent 1111.9 -439.8 -1 ##$'%/&%'%(#,# 0 6 0 5 5 UIParent -1172.2 -470.0 -1 ##$&%/&$'%(%,# 0 7 0 3 3 UIParent 1172.2 -470.2 -1 ##$&%/&$'%(%,# 0 10 1 7 7 UIParent 0.0 45.0 -1 ##$$&%'% 0 11 1 7 7 UIParent 0.0 45.0 -1 ##$$&%'%,# 0 12 1 7 7 UIParent 0.0 45.0 -1 ##$$&%'% 1 -1 0 4 4 UIParent 0.0 -301.8 -1 ##$#%# 2 -1 1 2 2 UIParent 0.0 0.0 -1 ##$#%( 3 0 0 0 0 UIParent 576.2 -689.0 -1 $#3# 3 1 0 0 0 UIParent 1013.2 -689.0 -1 %#3# 3 2 0 0 2 TargetFrame -31.5 -4.0 -1 %#&#3# 3 3 0 0 0 UIParent 339.2 -356.0 -1 '$(#)#-S.5/#1$3# 3 4 0 0 0 UIParent 3.0 -546.0 -1 ,$-9.-/#0#1#2( 3 5 0 2 2 UIParent -324.2 -374.0 -1 &$*$3# 3 6 0 2 2 UIParent -312.2 -376.0 -1 -#.#/#4& 3 7 1 4 4 UIParent 0.0 0.0 -1 3# 4 -1 0 4 4 UIParent 0.0 -326.2 -1 # 5 -1 0 3 5 ChatFrame1 29.0 38.1 -1 # 6 0 1 2 2 UIParent -255.0 -10.0 -1 ##$#%#&.(()( 6 1 1 2 2 UIParent -270.0 -155.0 -1 ##$#%#'+(()( 7 -1 0 1 1 UIParent -7.0 -794.0 -1 # 8 -1 0 6 6 UIParent 35.0 50.0 -1 #'$A%$&7 9 -1 1 7 7 UIParent 0.0 45.0 -1 # 10 -1 1 0 0 UIParent 16.0 -116.0 -1 # 11 -1 0 3 3 UIParent 1272.2 -382.3 -1 # 12 -1 1 2 2 UIParent -110.0 -275.0 -1 #K$# 13 -1 1 8 8 MicroButtonAndBagsBar 0.0 0.0 -1 ##$#%)&- 14 -1 1 2 2 MicroButtonAndBagsBar 0.0 10.0 -1 ##$#%( 15 0 0 2 0 BuffFrame -4.0 0.0 -1 # 15 1 0 2 8 MainStatusTrackingBarContainer 0.0 -4.0 -1 # 16 -1 1 5 5 UIParent 0.0 0.0 -1 #( 17 -1 1 1 1 UIParent 0.0 -100.0 -1 ## 18 -1 1 5 5 UIParent 0.0 0.0 -1 #- 19 -1 0 0 6 EncounterBar 0.0 -4.0 -1 ##"
end
local detailsprofile =
"T33AZTX1vc(RzRnUQrm97hQQ9dKIKsSmfOwck7nvPInBa0KOxbGgt3nen9MWYYIoRgBM1o7ifZ4iPvUSLFKrtvmYkoY1ypZ)hcW)d75CUp6hOXdPjQMDNAMXHca99X5EEFo3Z92BRU9wBxVFC0UHDcWpM0oAFp)4GE(EXrDc8cBg1B7gBxFqsGxCGFN0WUbT6NG)um0YD9BbTPh0ZAQBxh(qnTTRPSG22PWqLcDOBqShme7gUho676NKc)WG(T8tdOb5VDqyZB61kinOzAiBQIdscs9s6h00RPFZ2b4V1lYZVtqCk1NwHj(nayR7bPTdB61AqV9cYGs)EHD9XXYZVzZGoBVecl9gaasyt)oEjhaGqxeoPwN0ewMDytB)O4uV2WI0RtyVBYwJbDJUfBL31B34OUE9GLemM17gcZZGUEWJJ970bwKDB4N6H4haxOaqzGFABV0OiaN13B)WwPT3UMUPICMsJ82VD021r8wsQFVMbjEjb71nOxAIxNOM3mOfor4Gh2ZlQxami9AfTFcGjtzqpmJPDc2loAqVwqFJbyXRVFm8je47N453OrCWTcj8bm7BxF)O4oTeaByIxASFsBCAy0eeTdt7Qogww2w2A22UoQwUwBV7fmHE3ik6MD9JVPxAW7aKOW3fxRaHpdNt93dqoWaFla7dmdgMJJ)H)PBJOojqxhKgHmgTeZn0dvZYOVeyvDtCnXrbtLXldDc4YbEn7GSya2oQFaXLijzDc8J96fSFZ2WxdaUierGuqV0d6hq8iasXNAyVb9bIYErdsXHiBkaoZoHnyGfH0zYsEjWY3RFucoKTc21FqNuVg7bCX9B7JqkSejCpkD0eW89G)hXCh07aGRmkg4Vdss83JjNGtxl)yGkFZWE5fcqgfpqca4b671yqAAupQdLijaXxx8J556fddkSM2SnJhhX6n8JzcamzEpqOhaiq6fLJbOf6ulSb7g1lfwdDIIz0c8)0O)Qt)1a)lquy6ueDCjEhtA7J4T612O2kIFIXv5aIyfKV9YpPXGuiWWNMg2BVePER0qqAahBy1a0TTRV(gVnqrIaUXTRV1gxdEaWcgqSmcbsfqG8GTRDbvuM9DakdWL738MTIJ6xyzPW4WOLLcTS4CBzsQTdc3RDk0oDs9NF3(iILwo68f3U(nd2U(QXHV7H78FDGFlempCNTGfajrfT7UWIIPCIjpcGoiw7tcsWGe1hjPa7pIai9aWm1fusfFGh8tBxZYG4RaEIqumRtakeISL3QVNFIhXMqSKC6oJXL97eFdtOGZqjOuXnb9QGc6BfMEaPIZdgp8r50CnOFFqZTqJcIhB2Xh(oAbbECxqeB76RHlhejCJfB1AJEj3y5Gu)Woj3a4lbo9BqDjq2CXYLlETvocyAfAD8FhHwh9CYXErXH7f2dXHaETFh)daTKTyZBvJCDseR(kDU11xdzgIjTDdIbcx9BEayAiaNCj5Ky)qfnjvsytzQ48s23VpQeQ1bGfeGRMReI4wfk997ckYbYVbG8achmbeP8vwMdHvpbxPQf)hkWvVGkxZjRZ0)AWy2sNPmQYm5QjXsqzZ(TaUGuqPdW40L0NvXdiokbN90KORwaDbyfYxlwIfJfF1yyNtuTrMOkj(ZvfOb2MfinjfNZFE4o1dafya7)eKbLccmObGFps7)wOVlXa3m(Pd2E1lyR6OBRR44QPBOQz4awwnmqnpRA56QQ66A64OyAR4qpbTydwJv1uTuCSS1TCCTaqgEcy)O92RAR5Q7yRyBzQzyyOAXEcQ9bWmSPez6FhMkp(6fxRkkm4MWYaONoiHRXhPOa2gvSsObDWJQMTb0CnDluQciiOmb2rYqezJL3egLqtORSEsylYmkmrGTVysNjUM2DqNonIIBbcImwjYEyBO1EGbwqni3dfsHesJLw2Mk)o3UfPYXJ8ODMkCY3LepnjZo8BGwi0nTwHXCFtrCi5Hjkp73jCVEEDbZ6HE5qziVQN3(GQw0BdU(ZCRwbwJCkjTnOKDV2c7Temi8SoS3UebejbBIyfsXdk5GogpFloQPSvgNjKgU1ZpCfgFUE3Le)mXDGUaXW7lHO9LqSo5unBSy6L8AoijfDDa(nIlk8DanYKrTjROsogc7EkC7Ghu6harrpuON7PlZWcBCBuAnXwcZW0TAbn4CS5Qiv8gGKH2cBT1QOpPezNXnHSPsW8cQ58sajsZHU4X1OSKF8sexXH7Ovq9ox7kj20nQvqhsncyFfyGOVdgI6h0bOZl2mS1sXKNYWZdIVCCqqVfUQgQQB)Sw)2Ot)3yL)BxBXA1xBJAkA3y5n2y5fxU(nUuuhWRYy)BCPnwF5f3CZfxFJlD96l0vtmF59xLnM5au2piBIQOtznjTObdvbXkp3s9)hihM6VAHd3H(K(VI(hTFfx7uE6GG1CD0YyVKoHPsoobFcFOllHK1G5t2bvk0(a0PBq5(yCaOUT(OvpGWeZmLa)uNGDzFOrq6(aLGt6bustYyofuHklaeWnKsMVS5wVS5gVSz2UYjLuwiLcGvkJt(Jn)A(k5Qf1Z9I9pG5hKuZq1I3SN1G8obGVFwz0pgv7KsLqMQbQ9tuqvUUPbcIGSb4iefqmXVLXlLPnijd2QId7WD(zCwR)gjV2)P3OkzZRWP8JR8jxJw()CyZ0bDHrfIXoaI6(nkV4YRZAAkKw1e8fW00uhmX7OROtXBt2XfSkJdI8zVsfKZnlUHhh0ZgM2a7ChILo3aa(2f0RvYQOlp346RDb(3xpmj9cxjRdCuFLeKxA9ZqK1cwgI5Kl7vSpYilLSyvOQoNtQl2euzccJ(DoCNRbXRGFP5b5yFZd7KFN(Gpa(7IPTsOacZILheomleTSvysqFFWlvyDX9vwgqiJzw4600CUeCQGc9hHcKVh9jQkVY86e2nmT4YK8eJPkymZ1awf(Jj(hlMxei6O2f0q5uFwUlq3b3peZcqlFKdHmUcXQedrTeMGbobWe3JoEIy8YIAI8EtqWeUvXAUAbFGMdsF2kjZ6IRg5ezdYjsWj5CHbmoc9YCz1sbiOPAkcrq1wgKGMRbpmbxA2z(H2dZmdP(q4rFolFH9ysnWhHGZhqbdHezyWNZgQpVn0yEBO582qR5TH2ZBdDM3g6oVne4NN3wo30g15M4Oo3uh15M8OoV0N0srhKLBXCIft1PAwqDaxmgfJu)zRGeimpqbf3ltklhxftJneltsAytwk7r5Fw0w5KEJ6a(6bkFWLakxp1Pp3ACMbaGUh1zWEq4ZyoO2Vu0wC1ryo5dQm4unzWP2g8G2i0kFnwapgJPoVbPezpsjIUPgfRfyaXVC8z8zgIP)My23ZchTofRm47ED)Bbtc68FaAMeu(SYwlU2619QV1IBD96lT4MExB9RF51Q5DjWP63u4N4KB21w(A1Lzxah4P3YTKjoAlrYQrmYQZ0m3IyKRYuKTLWPu8r1L51b)2LMzuntD5uFLlF1vQT1)Qbu1xZakJ88VwOu7VkqzkpiI5aTYYPI08OfZOBAifqApp)gHq0rHbjeLgZEEqx(3YLUkHKEH83CbnBo4bTe1rj28OYsFgI(TQHLLRQTRMILPfyB2g9F1aZesw2Xz5jIa3I6bJ61jaKLyBKd5(tE1wGx8ry3J6XeZyqvoDz0M8uHNkzZmQPlxCjLK4ZY)ubTfH9yY8a0DalPoj987Z26nimPgOdcPq0)neE(iusijjLsAzonkuSZYnnILyqdtxDflvldhllntnm7Fw2IDKGVfglTXwBTXv3CTlFLszcxMapzAJK8f625()KXtWO0RAPOyy76AQORAbKotgzdO9t6j6t6jP58Ee9VhDhpH738(H9jRCmu4Br6Grn1vOWViTzo8uKYfhrai2GT4YpneQBRWR2I6Zlr8KXOxW0tXUqZzZbXGp7PiRbUmyb7k2qcIcaFz76R6dMqZPuNWt(PGqei5XYZCEXHLY5oEDP53872kONPyOT4gs)RKPlh3VDkGirMsMrCp57wN9b5gz)MN90lVwd1fiohw2EZgwC8Qohc5M6g7XYOyUCj71cTeZhAwI9VGU078c0J(rjHn9J()9Z1EzXJcRcM0XvOn5gAsF)(JTVpfeENsIgBgbYpfKBulSVL25iE1PS)WJuDvhfntfnhhvBhdlnAF)nW9nI2grC1LpFGS9nzvdxBhtxvhBWaGPMIbdltPJhy38WTvymf(hGRD5MrsrnMlBdRDPnQv)gRv7T8adcHD82cauuyAgoskdWwe3TtbxMfA6D4L(rL5UVCq6LYrNMSodyXoQXXOocR3fRTa(EAXl4dm9hjyCA1B63NgCC31rKdQLHK9X0620pjLvHjjnPCVJ58cS1XKKcI3JShXuMXeBQYvEeqIdzvvrNoHTOvxHQNalLbw5tGFkx9tikTLcL0IzwTaGLcatzbxvtJCz5n32HIE(mgkjRgk6fSVy7NjsZwzjmr10jBh6zJsZordA5XrCziaWE6ndaVBG5aRwaicfuZcvEdIcFilzfn743TVWjhNCgu0yYpxqL4BB2gx1Gj(GUnyU4NpIg43PAac8K4DYNp4dkKCyasK7UoZiuRa)wWI3J2yx0pmTcfgcJpdibkUgQ0YftUB7WGoT47lplXuGKnHIVY1RT1kBw044cQAMYKAykksbsh1BV4MBU2gtS982QYA81wC9fxETAtCWLJTUn1(RU4Lxjxswe5yb04Qyy5yx9CSYwZUl0eW6g1PL386RTSSB62QkUulO(AaiodfRQxsxDJAVzMuSOl6GxR56YylSLxzXTUYBwJC4QcGDsDBLARC1FXeXELwtBUXLVEg2lhcqR4AC8101R9M1aplhFvnj0312CTvQV1CoxJXcv)klE1fRnheTYDCrq)dgSXeNyfWsJJnyFUsOgyD5rOnpK9XM9LxbO9fLwe0DD(qmj64vq3qN35TeuF9AxEZnU(1U26l(lYnXZMgTYBTXBMRdGB2USjH62K5URpnTbfNd0jQO0MrXGXemggYJ5TyEwX1vXRoiqTTmEQS0qvih5JPkAblXgz5OZNEJQubTGTJyrjQ9ed9k0(SGROSomflhB9X06yiQJfbtKlPkFXnxP2IE)IvwFDPGsEhhe8ivtSmeuAb4vwfKQKvG3cfJY6AkmzMUtsPITTKMjam9YkheZMRiX1gQzlXlV5kRKHYSCSK8zIb0vPcPyXcqSeDSRsXYyo9uwxYyPaSSmRPGwBkWf2UfYUGAjTMa9tv1oFmFlOO6AL5MBvI1wckMQBHzjVTg9sevcPuBLRV1MlUEvCivitkWhM2wswdxhc5UY6RkBMJRcchmYGMQPGSX(DsmSrCKFRMSIIoVpgKJZfRDxT81jggak4uvcl8qMJv7f73Vn453sIclLAfRaMjxilvTCGpV7brdlQyoZScBIvlPbTctRO60WAylHsxdwLAKRIuAreF8Arjy4vAk6GoEDltqlpOhGfevSFRqYVqlfP2giAawb6Up51vuROSqE3fJMlLLQs87IGZluJVIIMdctPR)7mjpknmZk0lW6tUYMmTneoC7OoTO5HInblwYDJ93lPQkKLLXSkRJ40O49AZ9EhFaRwdjVK5b7iQK(8jliPawUp87nPc3iF53IUCZYjIi3y8YI6a(oSNg43vKlIP7Dpt7nw2a5CNSMLwoBuQUM6QvyQQKP1AQgw2zI4LnrTGOXwSwBPNZuQzjtVLhASy8MhFvHgQofxZk3wTPyjUyBH1MtMIfzRTNWItZmB1jCSrTAyWyEDAhAR50C7SCZTSEjCsfg8Pr7gV15Wg6AoQJJrgVlUtdEKUK4WBU1eP4J1wtB7P5svzAtoM7kaKIohvZ0rDk8PJn0gtPXLgznlZPGXhRXwtJ9BSwNHqKGHZKB9uzThJn0YDs82J3wBLPbiLBEUwpz1oLzSuv0MmsVO0MT6eH8s4evf9jtCknOAtKrTe7HQIXuq0Lv4yRpnuxPHoxJRGNEm2u95peeaQnNcGusDML6Cg1bOpWAkYkLjYzYkZk9d1YjdoUyvjoUC5JA3o(7Xkl(XmK3ikjj3zclPz7GU8solBp2eNnj0RJC72M147qoaPYGy0LUVR7Aj1QjQEzX41patreMV1Yob2oWhDdycPOhlHfrHTK5RCUQxtaquwM4rFtFup7JYmAc((CRWKO45zVaO8Ok36cEo8tAIfKkVq4XwBQyZRZXlOBYD(MVIYkc9YUQlcJuxcAG3QnyfYunBE5TI7lFWH7uhp5uc4H5JeBJGkILSlJIkEujSlsns9J3tqqKLygYc82S2Ef6FK5uhC6UdqWUfwuDr9f)k6YDeVAkaufocRcEhRQOOR7AB7OBcEYa(j7codoObL36S9byPSEXpte02k3mQBx)ET4NiqSft(Oym)7PgVLtTIL1Ll2jvwEscW05ByBCgZh(gY5MVzxgKp9HDXLD3G02rTieiLEzmPPsqmBVdGG9wF9L2yJ38gunsJNyXlCn)9cUGQeI57MAJOuAhHLJwM3WQaPXeIFXut3rtXrt3WiBRrD01al5AAgooqeP6kSZgjU1O2w2gQ6gQ226MwQU6SQ4KQVtfW9gvBdtxfnDDiQu(MMYyNYq4IDUP(MSsEtfv7wFDs20MC6cI5o3xwkxZslSuYR9XPuUrCYD(1slFulNw1jkIfIDeDZIeIoLKqWS3KZ2GjhNko5Go7MvN(zXSjghAZAKLpAJSKKtv3it5md6WFmlJt0(LuFpu5cqhhS7Uyg37ClSkC2LQm1ohSBiUgA5hFZOyF8ODcdeRL9he3hlpwax3H2KX6heGL3KCpva1(TyyM96e1WFz25FGdiXbnzX7YkYkEyBiSxypCHN1jC3apETFZmM0j4wurxW2rfBMSg)iYXpRZWap6rpz4N)Gd3z4d)Xr)6Jp)2pfu3PAQIzYP(OV(9gDYtg(SFC4x9JhUZOF45JE0NaTt0cqLWzp7No77o687FYWp8EqlE2)i0LZEXPWhHU(HFj0LHp5fI2dO3rp4pF(9)2rp75JE4jWCE63kEMbcjF45p6yORF0xE(NEc0gXZiMTWUDzzVHSwH1dbUrOuqVST3f37cX2pjxEOUw8WFN6f0Rjk1Js7yBaXYOo0z2oHsrGRLJQnePbF)2XJtdAAoFIidEN(UkPb0E6aKNobPb8n53BRlTXsSnhJBdF)2bidXLV(ARVCEyFaWztrdh63jRo65JcFJKKaqUnZlZMMAwXYGorW3L3Sd9EwjYw8SZrYRGHfe9LZbcCNX63eWySAHPfdNLbWcyfbC(Plg4lr5duQiS3ETWJkE3WE8nNRMbUp0m1Sd2ZRpmKHnX6MHH1588ygfAh08MGzyqQoa3pu5gs6HNp59WCLWPCS8)OmXhJm84JfNCx(jisM8b2jiftoc5qIlRy3YYkAnud7cUqyhYKgdgy1vxWrXrKt0vT0TSTCuSHhOBR7IkO1T5zfUMHJUoOFtttMOYvTuvnCmDTvuCqL04wBR7itE9QwkM6UQMOAFnf45IHdZL7QwUQwQMgw6oQkW8AY7RilNGDCdlltBdBhqfVURgFBZZNJsm5dU6aizlZbBnnftfRfWGz5PvEvtBvWfjnyyC1nnmX6Os3vMaYvb3AnTa7lQGFA2qWs48OKLX8vnCDHrZW0Ywbp((USUZk(aUCybUkGwhfhY2d6SZ2V4hXAQYh4JAh0rC0YXGFmYQoT1QT6gEBD9T2yZ1wCDvwAVcaHd6OrYLpAGIhnqlpnqZonY58gElg0Joa7IrhwmB8wRS5IRV(YlU1IEacU2A1UmjHv)QyT6TXvxAXT82ATRUcoB80h753RhOkPjJP8TxR2YB82EiLX761W)HGSkHznUFuPXD43taSnEnpoa3XAqRaTYfoSSVFCpqeXlSLQmbKAK)y09QqlpYYbwYeoAUJ3heEeclvOMmNwqBWTbhGSYp4YIZ(gzbzjSuGOQqYd0e6f7d9xQuLW(q0zuD)dX)5Y(xf6iaOz6QX)D(3Hqqy)UctR5ndoijfvKKDECLQXW6THxLtzNHukN1Tdt5AoXZRbqDUzi)AgqOJASJKm56awHyj4IaNixSdQg0F1P)Qr)vL(lh(6JOpQWskCdfKlj6fQpaEKjlvQ58dd(0FAUXSYolRlRIZO8Nl0Pj5rCo3Vl0EzjwHvxK8gkGvzyKdefM0z26cJ9ear(6AoG0cZ9l7kJpnVClWjrlKuWu5nNGqCdBdLcC6qBc96MOtFCRFP(niDFOsiUxi(TAHg)WneHvooGrBqlyqwzfPJNJXCDr87y9AM7NZI6UO34kYT9wKJcfZ8xOe9B7NeKnRHjzvYAUrNUruMrG58k9I6v2aYlBlBhxhhxqJayf1WsruCC0OJ(LN74Kv4m4ucPi2tf8WHZDNHVRhudr31aVMtW7RdXvNZyOvk()5mEXmuqrvjoJH4Y5p(EyDtf2S8CMiZnq9ECTC56eDcVf1JnFzQ6YoYzmv(ZU9SRuG(458aM8wVm9GcByEBpvbDZUXAedwmwcYZUX68YwSeAvmuUkJ9iow9LaF(AhDYQeX5hDAy86gDMxdbf3)SULzyjhKsbvLOA0oBBEHeodyWMWFZjTHv3QVceN)nNZvJJQ7Hoy1NDzIHQIACGhBZ2zNhbrSxZRIQPQjo7KyooXkFhhtKHv4TgUGpyQAwqmck28iimht1TS1q8boUQ6kM26gQg8sUDCGsWup2aLhIgt5iPuu2xf9cdCrBzISAlYPTiJ2SdV8yWd6P40TaKDZYKDMgM0POEHStZPmB)08o2ksyYZ0WwXW1qt3YYwJvB3g5NPkYN4KVDas4xgq56V0qPDfarEC(4IZtLnycKOSQ22vZqbcW1wxbcWuJVUyS)ZYACfcj0JAuX0ohMuZR8VGSzU(ojfmZO9vO9FE7HqL0C1EHkPzb(fujnJgl0(xMWZ5mTubkOPIc(htDPaDLYa5zYQuq6vZQGFJKO4XR35k1CB(QOPhv96FR9MNXN1(4W0kMJj0hdQpqiK(ZLFbqONtYtIPcud6tHEphWJPynNm3q)8Ay2W6vWWmJZBUn12o8LaW)RKrCXjPnpnkDswlYD5kuLYiEzF5W2KPoybXbk9gKWdEeZvswAjNukuzNem8G(Ej6SlXU2DexiaYOuQF2F5hh94F7H7C239Np7zFlvizvEAw2hC4ZJks0AIAiGkMW6yA8)4F)H7m69F60gG3oWVFupVLI23tXwClcWJrcgLZ)9NC2Z(PZV3pE(9F(H78Zg(()(ZV)jWG(9FlmOVrLJkTI8UQ)EHn9wfXcbXRINii(fpapYRXh7Zp5fN)Wp)WDg(939StFVQh7fPCAFGx9b7UBeMKyXTuaTtWvoQ37hh(5pyAq6IXn9bAZvd716QKRChiUrdWb1QYb93FVrF6p(gtMQmaZT(QOzWvdJdQ3peu8iU(dWr1UQrD0N9TJU)9M(cFZ2he1bn4(wrDaWosCvjGdQtLuSp(dgD0FA6d6LW77j8WdDTOWeGzqrtCXkqmcoAkMm0WVClvDhBDt9lQAG)Nc8)Z(K6fv1O)8ltpChg6H29Nrp6jJ(OhYI4M1v5vXaBSvny1Tbm2yYWT1uN(yp87pA03)a5MrD6pbt3XhF()RxqZbFiKxIdS5W0vrNphA62kk2tFkg9Phn8fhp8XFcU5w)tpLTo(8tp70Bp89FaU1vpfwvmbeA0KxeeK0RIJMnteE0j3(8tW9u7HphKelrbaNaJg3jqAB78Xd5BhmnU7MkV6iyRead6MHTmb12ZyPC3hm6UNC(9X9(77FVZp(BylMp70r352ceMjt5p7ENqsWD(Rlb3m3y7ANNGR4mJLWJpA0d(gbbF4x8nd)HJydVIQLMbR8IesR64wvyMrRn0vMXO)7aW(yqAb(4x8tWhh(B(heKwdD2TSHTe2nuume4ffnxfLzm6N9Dp(8F3tGH(drL4STd9F5EOkPV6PSzXut1MK2uDYJHueyittddtJzG9)4)XZ)F)Bo)JFkG4bT(mYWdFVZp5bmsmBmOjritRPcr7jWtMQU62ZGkm807n8rhdCnJEgo639Fy4hFmNkO5A6WQglHuTTTPoxz89yCfd)UNdQ3h(1)DZVuaePxul(EzqJEM8SMQUa2TmXDpBguHN)BzBx9V75d)k4Fp)ZogKii468p7oG5gAHWgjAM0Y0o5AzNrWv0DvNjZ6WNGiOh)ay2OPaM6r39XcCfoeBZUqFLY0oM51aQ7odY9ONFxCt8p5(aA9dEXWhDIu2Gts4JcnnzY024Dawo5o1zP64hEoQ46H)e9Hti7YNFN3JP29r)lc0MHLIRPgRy8eZLlWVPNBUmTNXCn8E3d0jn8jpF47FcdPD6rNFhKzg5KFHqDRPQHIkJezLXiRyQj1vzPmtbEqN(pDVHN(GH)9mwGH39UCTvM2UUScovI00D1fc8WNDvNXGp8RFcOPxspEkxLyMbd2GqtIqEhyXCzhlL6G26Z(ZFIqeE4p8hy(VagYFdoiIPwNHSZzD2qlpH1CM8O)Hpbz))ue3E6tfQpyiyBnqCM8cuAH21glQJxNmo6Q51ERkNldDxh3zmxN(tGL5HFcyF78t(byzD2F(P8rN6nn8Az8ky(b4k90nnDNHzTrF)9bFNykk(OthE7JfwgmPZjfE)NZgzxhfnUn)78WH)Xpy4JbL(aPe8ft2fhIXv3iNT8mlvQ4zBXEME(aY7KTCaQaxro7hUZ5h9c(PnMgaAgmZJnDZZzyzoJz443d88MrZ(6Jb2xyD)RF85FWdecioCMdH0NHIJLJMCkahj0Nfbd8X9UFZzp7ugF3DoITUo9uMNd)WjCQhnu0CLjm64Ai8kb4DCuNHEYH)ZNo6Z)tm8fzLhjjpLk5iuDpy(2MHWCKRgBxlvPUedDD7z72dWFCFGX(8h(jd)QJgD0dLgf5UHQNjOAOLzxhhC7zA2A4J4uJF97n6JEmgG0D4((OduCA8nuKqpWElWpaXguDndfbGq5Ot(suRljAcwh)TpMP99V8IHF1)tgLWfproo0mPMr1DuLMSC00v0mMPFqaVfl0UF6ocZId)Tp5Vbj7FYWV4Pc9BA0b2SMrMjydDnZ)QH1aPq2nGxM5xvBRmDcokgAZGR6JpE0NE6WVdMINZyNrY)WV(lh(nVamPGQTpA4hYyJzJhnFgzujDflPdQMwkwZsI5tpz4JV7WV9eqf0O)aGep)bphqMWmdZ1F8BahI5QyOXIMSmNTDDYIxWuX1qBwRoY9AysVZDhE7FKMJr3)4Z(N(nJ(AUwBWeHblDdgzAb0WdKhFAigMzze(XiZWr3fXzFo3m8Z)7aXPC8Cm6KDo8MMXRb8wEgCPl4GHjw11xF0p84ZF4VLzc4rNmxEVg0a8ETlLSi2MDYF9D04aQq7kuWISYYBILPy(D)Uy98jpd1fgv8o9qCb)NvMnfkUgwr3KI5jR0l)G0Xk(oknvIMMwUegZnSfU5OyVzBsoOxtwnjblZMTX6LfZggFZyabDlaWO3RmE5UF6yxgjuD(SBh(vweRAMKjFUro03mQYZQRLW)2bykEyvuod1kkhxrnFXEfzepO)y5RC)2aEhZNiDLE0RhDXzV4VqCbkH)EpwXkNMB46Jf45yJv2aGhX36IBnx(6da0w(hSDDmxK8BW1E4DjMpveLrnBnHxKdIY3sukYjI7xm8a4YlIULyhoHeSuIX9)Aq3ESI2rwKD41isqVKWBfCbmVMSXaRCp2NI4puKQtrBLjegtRDkLCPYnbZpEupAteYQ0lbhaEcy3VxgNBjOOrUzUrfZBJSzTrLZjHBfPcgXS5R1dCw7g4L9gDOekK9(LiQxRqj7k)AhkHD)rXkfD2nlxXRJO0YV7jafc8cQBARXLEvxJPY6geK5WjHFXG6jZkn)8jr5RUHqrZEbDPk0lXtftRfwo03IkaFq6UPN86bI3ACZuO3)sOyzsURF0SzrSIyV(yAZkn7Db(Z39GCJoHAY)MaBPkgQU97miHrafvjxQptMI9s9HxzWW6Upw12TwEvYhcd25LZHDN6ZFg)2fgwSXhiVlEJ6TfVeiPjnH)o3Y)akA96DJ6rLxcixV7UHVd7PXdyDcpBV6W)Hf(VFmMke6YwqCJvvQnDdl1RuMpjK9hRxfivJdO2s4eHUkbuSAGXlkOPbOI2KbO8FHbO8Z1OYReoD(HuniSPzHsfTjds5)s6RknF(HpGGPmlmPOn5i5SFHJjjx1mFvauL5hqX7vrSy6MgGkAtgGY)LuX9qg7D2eDGdeVSpQlFJAHsNCLni4Ry)Zvv(5A6hUJQ1fnuUOP2V8QOsJ68d3Yg9wPxRd3HUk0dGp8lpCNM4Mqe2BVd3jTDWH7WvqbTH1Ld3XpL)OaSRr7Y)gSmxGeaQAojGBzMMHvd7fM0oO1p7nO5JPeJoSm0LBXH78FbgX4bSxTwVKdM8GnTVp8NWEWYH0)UavPmJnykmSXw48Ej2BcojYybQorROllbG6YG(EFbg7MbhC4o09O3fPV7q)D0h9GZo9iwmw)5th9fqq8d)nNcrRaX6n6d)swB(Sxm8J(sig)lYYSXtyjQz0dE8O3)u68Mwy(11UOM60bz7k7Y8cYF6Jh(SJg(5pEEaoNsZKM9f1mNoW5wzxMtG78JpE0Dp5S)zmziqurF(JHO8WZr18HkrbXIZneWIZ0bxv1k7ZCcV4wx95py4xF3ZV9tNliSSOJMcq9MbeQxzFMti8Sx8cmS)7m6HyuG)9py0F44ZV3rZfSwwycfoC(Lx6klU(6Ru7YR4D1nwEf8coEZTOHt868dgTU(3mq(M1KK6rN0iH(Db3xcMUob6PTcOxBgrmhw4xooutmPNZVadLxbNLgCUd(EYtFy5jppeUF7GEEyndmgiGNin(TXdDv4sWCXwXFhlrbRLhmLnGwHTWtTfDDhlvXMVn0Fe0ogH7Db45IZGijB4ATGhRr5ZvTOcnZlAQFrLx3weuTQEsF1mjOA)spAtXMGQt5rt7IMUZqMZTY(mtzogVjF3F)8)0OhHPM(zFlU1r39USN9rpF0)NBdwiWK)(f)eMUUVz0x)GZEXPSsHPWSA4cQJMoKQPwzFMxi9p(bJE)NcQCNnSPvEEqfcZa20RSpZlS9(Nm8PpF09p6S)Y7nBWZO8uPErJzOyvZSY(mNG35F6xE(TFUiJAJE8rNF3No8J(MzdPLfv0Hjw5)qT6RD1QM5vRozkujDQM0BdXYkKuSVOIXRBVSDQEsF10PQ5wXOnd)m1vQSpZuaXI5EX9pc0TqPPh)2V(4rF23Ij0htL)W7E0zNEBA3ilndkG7nZaQ0QSpZnuDmUvmp85d)IVr6wz1WwrTxgOvOz5zUUrL9zoHnmJ58lpGrF6NaM6PTSBYaOzPjZWgMV)TxtIQY)ExvIvbp0QG4uujILPn7TVAg1sbJk6I6wVM1HOBx9K(kgQUtfJ2m8pr3TY(mtjcot0FfcW2qPeeO6G7A1uHAd1k7ZCd1VmXyBOvEU0HPBgWNEL9zEHV)1fMTHr5jx5IMZcGnRSpZla)YgNTrzHnfNlQndF(nSRSpZli(QhOTrzXkf0s7)HhHV2vJZPCVQrAJx1xA6)CfxgDZc0RjLdEDPrxSDLYxauHT2Ugwin1Bg53SD5DqnOdq0cWlL2Go8R8gXiqTxCuXs5xKdT9JVvqcI92fV24GVMY7dp1ZIRegCAXmni32vEMYlo)0erNef6ISf3OUDdJtOJrqD2n6J4nrJyyyVJFcAYVhTYDitkUfUSxh84D(J8wPsEL9WYIFx6UiwJUo28KVYEyj8pko8DXdBsN64lfQgI2qnjYdb7PCk2XZ(G4DRfTPCIbjmz9SxAvY32uHjY7EiojM2pb6kcMUIalaA))bV05z3cJ94I8IxFxfzlzxrwQw4nJNTf6gIKeNFNEl8(uKDZ2uEZ0Z2SFjdWMlU2Yf4AiMkGpBwCm0TZsl2BVhrvwKX1l555N5l(rVuYqX((BgCaFZCe777gn(Vh0m9sIdVeH2yVIrwM4MzYWRaZ9H7Swp8ozS1a694enEIXDd2lQSS9kkBIZpn1h0ylCbIGr1t0IDKJ9H7CjORH47X(khKAuN5ZMK0M7sDpD7T))c"

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
