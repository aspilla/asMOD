local asMOD;
local asMOD_UIScale = 0.75;
local asMOD_CurrVersion = 231003;
local bAction = false;
asMOD_t_position = {};

if not asMOD_position then
	asMOD_position = {}
end


local layout =
"0 39 0 0 0 0 6 MultiBarBottomLeft 0.0 -4.0 -1 ##$$%/&%'%)#+# 0 1 1 7 7 UIParent 0.0 45.0 -1 ##$$%/&%'%(#,$ 0 2 0 8 2 MultiBarBottomLeft 0.0 4.0 -1 ##$$%/&%'%(#,# 0 3 1 5 5 UIParent -5.0 -77.0 -1 #$$$%/&%'%(#,$ 0 4 1 5 5 UIParent -5.0 -77.0 -1 #$$$%/&%'%(#,$ 0 5 0 0 0 UIParent 1111.9 -439.8 -1 ##$'%/&%'%(#,# 0 6 0 5 5 UIParent -1172.2 -470.0 -1 ##$&%/&$'%(%,# 0 7 0 3 3 UIParent 1172.2 -470.2 -1 ##$&%/&$'%(%,# 0 10 1 7 7 UIParent 0.0 45.0 -1 ##$$&%'% 0 11 1 7 7 UIParent 0.0 45.0 -1 ##$$&%'%,# 0 12 1 7 7 UIParent 0.0 45.0 -1 ##$$&%'% 1 -1 0 4 4 UIParent 0.0 -301.8 -1 ##$#%# 2 -1 1 2 2 UIParent 0.0 0.0 -1 ##$#%( 3 0 0 0 0 UIParent 576.2 -689.0 -1 $#3# 3 1 0 0 0 UIParent 1013.2 -689.0 -1 %#3# 3 2 0 0 2 TargetFrame -31.5 -4.0 -1 %#&#3# 3 3 0 0 0 UIParent 339.2 -356.0 -1 '$(#)#-S.5/#1$3# 3 4 0 0 0 UIParent 3.0 -546.0 -1 ,$-+.-/#0#1#2( 3 5 0 2 2 UIParent -324.2 -374.0 -1 &$*$3# 3 6 0 2 2 UIParent -312.2 -376.0 -1 -#.#/#4& 3 7 1 4 4 UIParent 0.0 0.0 -1 3# 4 -1 0 4 4 UIParent 0.0 -326.2 -1 # 5 -1 0 3 5 ChatFrame1 29.0 38.1 -1 # 6 0 1 2 2 UIParent -255.0 -10.0 -1 ##$#%#&.(()( 6 1 1 2 2 UIParent -270.0 -155.0 -1 ##$#%#'+(()( 7 -1 0 1 1 UIParent -7.0 -794.0 -1 # 8 -1 0 6 6 UIParent 35.0 50.0 -1 #'$A%$&7 9 -1 1 7 7 UIParent 0.0 45.0 -1 # 10 -1 1 0 0 UIParent 16.0 -116.0 -1 # 11 -1 0 3 3 UIParent 1272.2 -382.3 -1 # 12 -1 1 2 2 UIParent -110.0 -275.0 -1 #K$# 13 -1 1 8 8 MicroButtonAndBagsBar 0.0 0.0 -1 ##$#%#&- 14 -1 1 2 2 MicroButtonAndBagsBar 0.0 10.0 -1 ##$#%( 15 0 0 2 0 BuffFrame -4.0 0.0 -1 # 15 1 0 2 8 MainStatusTrackingBarContainer 0.0 -4.0 -1 # 16 -1 1 5 5 UIParent 0.0 0.0 -1 #( 17 -1 1 1 1 UIParent 0.0 -100.0 -1 ## 18 -1 1 5 5 UIParent 0.0 0.0 -1 #- 19 -1 0 0 6 EncounterBar 0.0 -4.0 -1 ##"
local version = select(4, GetBuildInfo());
if version == 100200 then
	asMOD_CurrVersion = 231116;
	layout = "1 39 0 0 0 0 6 MultiBarBottomLeft 0.0 -4.0 -1 ##$$%/&%'%)#+# 0 1 1 7 7 UIParent 0.0 45.0 -1 ##$$%/&%'%(#,$ 0 2 0 8 2 MultiBarBottomLeft 0.0 4.0 -1 ##$$%/&%'%(#,# 0 3 1 5 5 UIParent -5.0 -77.0 -1 #$$$%/&%'%(#,$ 0 4 1 5 5 UIParent -5.0 -77.0 -1 #$$$%/&%'%(#,$ 0 5 0 0 0 UIParent 1111.9 -439.8 -1 ##$'%/&%'%(#,# 0 6 0 5 5 UIParent -1172.2 -470.0 -1 ##$&%/&$'%(%,# 0 7 0 3 3 UIParent 1172.2 -470.2 -1 ##$&%/&$'%(%,# 0 10 1 7 7 UIParent 0.0 45.0 -1 ##$$&%'% 0 11 1 7 7 UIParent 0.0 45.0 -1 ##$$&%'%,# 0 12 1 7 7 UIParent 0.0 45.0 -1 ##$$&%'% 1 -1 0 4 4 UIParent 0.0 -301.8 -1 ##$#%# 2 -1 1 2 2 UIParent 0.0 0.0 -1 ##$#%( 3 0 0 0 0 UIParent 576.2 -689.0 -1 $#3# 3 1 0 0 0 UIParent 1013.2 -689.0 -1 %#3# 3 2 0 0 2 TargetFrame -31.5 -4.0 -1 %#&#3# 3 3 0 0 0 UIParent 339.2 -356.0 -1 '$(#)#-S.5/#1$3# 3 4 0 0 0 UIParent 3.0 -546.0 -1 ,$-+.-/#0#1#2( 3 5 0 2 2 UIParent -324.2 -374.0 -1 &$*$3# 3 6 0 2 2 UIParent -312.2 -376.0 -1 -#.#/#4& 3 7 1 4 4 UIParent 0.0 0.0 -1 3# 4 -1 0 4 4 UIParent 0.0 -326.2 -1 # 5 -1 0 3 5 ChatFrame1 29.0 38.1 -1 # 6 0 1 2 2 UIParent -255.0 -10.0 -1 ##$#%#&.(()( 6 1 1 2 2 UIParent -270.0 -155.0 -1 ##$#%#'+(()( 7 -1 0 1 1 UIParent -7.0 -794.0 -1 # 8 -1 0 6 6 UIParent 35.0 50.0 -1 #'$A%$&7 9 -1 1 7 7 UIParent 0.0 45.0 -1 # 10 -1 1 0 0 UIParent 16.0 -116.0 -1 # 11 -1 0 3 3 UIParent 1272.2 -382.3 -1 # 12 -1 1 2 2 UIParent -110.0 -275.0 -1 #K$# 13 -1 1 8 8 MicroButtonAndBagsBar 0.0 0.0 -1 ##$#%)&- 14 -1 1 2 2 MicroButtonAndBagsBar 0.0 10.0 -1 ##$#%( 15 0 0 2 0 BuffFrame -4.0 0.0 -1 # 15 1 0 2 8 MainStatusTrackingBarContainer 0.0 -4.0 -1 # 16 -1 1 5 5 UIParent 0.0 0.0 -1 #( 17 -1 1 1 1 UIParent 0.0 -100.0 -1 ## 18 -1 1 5 5 UIParent 0.0 0.0 -1 #- 19 -1 0 0 6 EncounterBar 0.0 -4.0 -1 ##"
end
local detailsprofile =
"T3xAZTXrwc(RzJTDeJyx3hkI9dKIKsmmfOwck7TJqblwaOirTcafgufef96MHTLCVQTvp2ExP209iPLoAFoJMi0yR2JumYB))ra8)W(oYSUqHd5UDm7SX2TmioYJx(UFV8LzTR6U7SB9(dI2pSta(242rh65piONV3GOobEHnJ6TBJDRpmoWBqGFNKWUbT6hJF1aOL773cAtpON1u3To8MAA7wtzjTDtGHkb6q3GbEWqSF4b4OVVFCc8fd73YpjGgK)2HHnVUxRGKGMjH8uniioiXlUFqtVM(nBhGFxVip)obdsILWIFVWU(yp88B2mOZURSB9wHX(naqU7rjTdB61AyVdcOreGLEdbajSPFhV4JaqOlcN04e3ewMD4PTF0GeV2WI0RtyVRZRXGUr3Gx5D92FquxVEWscNTUHaemSRh8Zd870bwKDB4N4H4haxOaGtGFsBVKOiaN137WWwjT3TMUPs6mLe5Dy7ODRJ4T4e)EndI9IdoOBqVKyVornVEqlCIWbpSNxuVayq61k6WyatMWqpmJjDcoyq0WETG(oaGfV((dG3HaF)yp)gngeCJqctbZ(U1pmAqNwsGnm2lzGFCBCAyAcI2HPDDhdllBlBnBBxhvlxRD3)CMqVBefD9U(dUUxsWnbsu4BHRvGWNrnO(7bihyGVbqxaMbdZjX)WF62iQtm01HjriJrl5Cd9q1Sm6lgwvxhxtcuWmz8YqNaUCOxZoilgGTJ6hqmyPKSob(d86fCyZ2Whda2ferGuqVKJ6hq8iasXNAyVH9bIYbrdtWHiBkaoZoHnyWIq6SSKxmS896hftCMb77pStIxJdaU4(T9rifwIeUhLoAcy(EW)H9VvqVJaUYObaJCqCS)bSCcoDT8hau5Rhslcj3oYO4bS6apqFVgdtsI6rDOejbi(6YVmpxVCyqH1KMTzECeR3WFalaWY8EGqpaqG0lkhdql0Pwyd2pQxcSg6enGPf4)0Ox1PxnWxbIcRtr2XveDmUTpI3QxBRARj)kMRYbeXkii7LBsJ972hbAQPW6A)bGujiaKKe27G4u9yjHG0boxWQdOJ7wFZTEtGcfbCN7wFNTUc8dalzaXcjfqvab0J2T25urz4BcukGR3V51BniQFHLPcZXrltfAzk4(YKCBheEq7eOD6K8klGbZniN6tsgaKtcsr7Vpa7e)gHc23VzWU1xFq4BD8E)Nh63cb(J3Bhyzf1hjPa7pUGj9aWi3fusn4ip4R2TMLbXxb8eHOywNauiezlVrFp)ypInjVYsMXL)EIVHfkemusk1GMGgxqb9nctoIuX5bJh(t50CnSFFqZTuJcI3A2Xh(mAbb(5UGi2U13ax94Y7Al3Q1w9IV2Qbj(HDIVgWxcC6xJ6sqAZLlxH41o5iyjvO1X)MsTo65KJ9IgeEqypeLdi4(D8pc0s2IN3QgzGEpGuWnCaqfQF9JaRbWBibV6R15gxDdCYtjue7gQOjUsswcRIZl(q)(OsOwhbwqaUAHsiI7uQ03VlOih4dmaKhq4GjGiL)KL5iHaqu)Wwanibe5bYwxCaWvurU5LufAq5bH(RbZJMmxzvL5Y3stOuEq1QAqJ4OKC2ZscUAbYLGXvSgSKlclXQWWoNOzJmrtsCxi6Rb2MteGAk5xWFE8E1dafya7)uKbtfeyObGFps7)oOVldaUz8DhT76NZw1r3wxXXvt3qvZWbSSAyGAAw3Y1vv1110XrX0wXH(f0Inynwvt1sXXYw3YX1caz4xa7hT3DDBnxDhBfBltndddvl(xqspGz4Pez6VjRItSEX1QIcd3ewga9KHXcn(iLeW2OIucnOd(A1SnGMRPBHsvabbfqWosgIiBSIMWucnPUX6XHTiZOWeb2(gq6iX10(d70Pr0GwGGiZcr2dBdT2dmWc6dfEOqkKqACQLTzYVlSBrQC8ipANRcN8Dj2tlLjh(oqle6MwRWbcFtrCi57jkp73j8GEEDbZ6HE5qziVQN3HGQw0BdH(ZCRwjwJCkjPnOK9G2s7Temi9SoS3(ebejbBJyfsleA7dDmEXwCut5vMGjKgUnZpCfgFHE3vk1USVMyx23NWhCSb46l8MG2xYs20vkLKoMcJDkcJFhv6laXopuax4vlBeHhx2piGM4Vpggr68l19iqlRJKJRbS4AlTZoRJoxMbVe)wkmCo1CM3rS9IOuL15PvqJ8K6lwXFWken)49i()UrTc6q6dadLaWtFgmV0pOdqWwUzyRvgqU8c)EWGloiiO3sxwd1zDywRFt079RT2)LRSCT6BSvnfTRT6wBT6YRw)AxiQd4E4a)RDHT2C1L3E7L3CRlC16l1vtoF5D8KhZCGp)fPnrv2PSMKuuJVQKA2CyCc6Xi8HDR)Fd9ww9xV0X7rVt)xt)r7xdwDdaxiq7zKF1P9guQ3lUtyc3)m8OCylZMN1GftaaLSBFe65mOHEcQVsLS5ZXlVCCYm2PakqeDb4JrjBt2ctt2clt2SHj5GTnPzWdrxCxwbB)kyJxjZ750iYRGl(vqNxjNSOEEWa)JypGMGkGrOYWydYBeaC(fYVPAuW0sIqMIcA0NkEofdtdee7ydWfOvQux1IsT2oVIK4mfFvX)E8E)cbJ7FtkN8)HxRkH8lj4TKlP2GxfDiplYrea)Hc61kED0DHRD1noN4ZBggNCUlL1Hk09TWm5gEqu(bqC)zSFtcSR(FmSzYWULjd511olC56MG)kMMM6GBio6k6uobm3TsiFYzfWPcq81svDuIGiu)Osz7rYYqmNcg9IaMifiz24kyky36l3e0Pc6C87C8ExbImb)qZJYXCNF6rtB9XUb6NhWUgcYuDc2NFtJGKdbfYc(jmlwEq4WCeDz8sXb99bVubuOWh50aazwAPRtZY5sWPck0Fe2qUF0NOQ8kZRty3WKIQaipXyuXe6qaci8Ij(If7fbUARDonuA1NZDbAC7WqmlaT8rwlYGleRYaiQLWymWjaMeE0jseJxwutK3BsYM0TkU5Qf8bAbKyZwjzgLC1iNiBqorcojNlmGjrOxuWgwkabnvtzicQ2PbjO5AictWLMD2p0EyMzi9csp6ZzWmShlUbVfILFifeesKHbFbBO(I2qJfTHMlAdTw0gAVOn0zrBO7I2qGFErB5ctBuxyIJ6ctDuxyYJ6IsFskfDqwUfZjwmthT5G6aUymkMuTOTcIHW8afuICOr5Z4YyASHyzItcBYPShL)5OTYj9g1bCreu(uAjGI4Z1L)z2IemJmdpacFgZb1HLI2sOocZjFqLbNQLgCQTHiOncTkwJfWJdWuN3GuICaPer3uJI1c8uXVC8zIzgIP)6y23ZchTofRm4DFD)BatcgZqaAGgu(S2olVXM19QVZY7C16RS82ExzZREXnQ5DbWx8xxAxz6n7kREL6Pzxah4z3YDstC0oYKvJyK1NRXVLXixttr2o59iVEA(CWpDH5gm0mxo1x7IxETA78xmGQ(ZmGYKN)sHsT)QaLjcNowa0kNtLuZJwSr3Kqko2EE(ncHaRcdIjknM98GUIpLlDvsj9c5V5CA2cWdAjQJsU5rLL(mK9BDdllxvBxnfltlW2Sn6BObMjKSSHZ5jIa3IkrI6Xcq0g5Gk3G1bLBzYviPkSOEDcajobuLtxgTjpv4Ps2mJA6Yfltjj(S8pvqBrypwMhM3J4K6e3ZVpV1BqWsnqhesI6tjtK88rQKiLKukPL50OWPGTrwUNpcWGMU6kwQwgowwAMAy2)SSL7aHyllwzRD2zRlV9gx8sLYeEAc8stBukFHUDU)xA4bmLEDlffdBxxtfDvlG0zYKnG2pTFrFA)ssoVhXWYW4(If5P5WW(Kvogf(gcdhvQWViTzb8uKYfhrai2GDeYpnKQBRWR2I6Zlr8stqrbtpf7cnNnhoa8zpbznWLbhYRCdjika8HDRVUFRG8k1j8KFciebsECEMZloSso3XRNA(n)UTc6zkgZkUH0)600LJ73of5TmE55enu(U15qqUjTFlYE6LxRH6seNdNT3zKxaAYsZLip1noGtZrUCj71cTelgAoX(Ntp178c0J(rXHn9J()(Z1EzXJcRcw64s0MCdnPVF)j23NccVtnj4b3Szei)uqUrTW(usBgIi401Du0mv0CCuTDmS0OT63WkL2wNsreVnI4QlFAe59nzDdxBhtxvhBWaGPMIbJLP0XdSBE42kuwHFNJW1E6MrsrnMlphBCHTQv)ABu7n8aJaHD82bGeuyAoosMgGTmUBNcUml107ik9JkZDF5G0lLgpT06mGJDutGrDKwVlwBbI90suWhywRIX40Q30Vpn44URJihuldNdIGoDA6hNWvysCtkHGyrGa26W)cwXhCazpIvMXInv5kpcidc5QQOtNWw0QRq1tGLYax(e47Yv)eYsBPqjTyMvlayPaWkleQAAKl5W52ou0ZNjqjz1qrVGdLB)mrA2jlHjQMoz7ippkn7enSLNaXLHaa7Pxpa8UbMdSAbGiuq9mu5nil8HSKv0SJF3(sNCCYzqrJLFoNkX32SnUQbt8bDBWU4NJ59O8Pp(MfYLm0dQ6GQJQU7Dq6URZgHAf43cw8E0g7I(HPvOWqy(mGeO4AOslxm5wTdd60sSV8C6QajBcfFPRwBN12UOXXLu1mttQHPSOeiDuV5YBV9gBn12lARk34T36IxDTmEEdhfdlhBzQt0TvvC1TRSNxE5lUwU0Ti7sUHyY(CL12z(DzjAcnynpO)XBF1nwnTBzGe1xdafAOyv9I7YBv71ZwBPlkW)1CDzPu0hoQK)4lVZLE9AKRxvaStRBxT2f3ERRELRS5Y)QmIvUzDAlVRS8MlV6g1Mk5DY551Rboz(kmbBVXA13zbPXtWnb4W6ZI7R0KTmOacJ2yQtNcy3XXgmqxz3bExriAlc1EcGD11aWTO4IKCRlgIPHwVe6h6IoVLG66xA5lVCTfGZUm8U2BS1RNdubhTD5zH69u4QxR2Ax(xTG0d04FusZObGXemggYJ5DypRe6QevheO2onEQS0qviZ5tOkAjl5ED5OlMEJQubTKTJCjjR5ed9jrCsKTHOno2tONXqw7ks(hxsn(YBVwTL9(vRT5MPsg5DAqIURwe1qoVsqRSsh1uUarlumkRDPWKz6on1i22P0ljGX4H12C90g54QO6kfo1unLjVM)(sAr1lb8vPszjxz1Yyk5sS1RsvYeE8uw7Xej9Jr8xC71wlB2SCSsvTihkxLjzDbANQQD(y9wcwGwzU3MMpc1QLSTKuovjHX2TkLiMsUpt1cTR2AxDNTxEZQyyQq4uIDmTTs5uCDkBdvYR4kPAgcpwBmiYVvtUOOZxnbKJZfRDxT81jggak4uvmhEi7y1bd873g88BfzHLsTIlGzYfYsvlh4Z7bq0WYkMZmRWM4AjnOvysfvNgwdBXuIyWQuJCvKslc4vpxOThsEpf1kIdO3Vvi5kOLSEpsJWw03RefJXJPPOdQf1TmbfJGIdoQloawmMoAhtYPHkRWdLfnheZsx)BonpknmZk0lq)BUYMmPneoC7OoTOzGInblwY9h4FqCvvilNXSkRJ4KObh0w49o(dCTgsEjlc2rwj95twqCbSCF47Bs17r(YVfD5MZjImFyIYI6iX(SNe43vMlIz7DpR9g320CUtwZslNZdQUM6Qv4drjlv1unSSZeOkBGAjzJT4wBPNZsQzjlVLhASy8weFvHgQodhYk3wTz4IuX2cRnNmLkPT2EklonZSvN0Vg1QHbJf1PDOTMZYzZYn3Y6vW1uyWNfTBYwNdBOR5OojgzYU4ol4j1LehrZTMkfFI2AABplFDltBYXCxbGu05OAMoQZGpDIH2ygnU0iRzzodm(en2AwSFt06mesky4m9wptw7jydTCNgV9KT1wzwas5MNR1txTtzglvfTPJ0lkTzRoviVeorvrF6eNsdQ2uzulXEOQymdeDzfo26Zc1vAOZ14k4PNGnvFXJneGAZzaiLuNzPUGrDa6dSMHSszICMSY8c(TwozWjfRkXXLlFu73X)aUy0NWqEJO44CNjS4MTd6YLMuU9ytKN6PvCsL3BCaCtD5wp1tqDxRuvBYsygpWtORm9dW8eHjDTSNGTd8rFbMsE6X6yrwDlzooNR6SKaeLQjre40B1ZEBAAnbhGUryC0GfzdbOKPMU)fceuCtSywfvdp2AtfBr9qEoDtr0jIvuwLOxowgzSK6PGg4YAdUAMQzlknwCZ5doEV64XNscpSJs8Ubvelzxgfv8ukyxKAK4p4ajbjTgmr(G3KB7LO)KURiGN3Dacg4OCDCBcfFl63n7ymVHrSVRyklh2GsvDwQ)fvZgvPN8XGG2j5MrD763RL4qaITy6N6IfFB0eTCMLXSUiVUy2ktByws7Hiq3CZv2ARx)AunnJhvWZDf)dcoNyBD9YMd5(tuFfUWUurLl13Ky(SjxlGGlZ9HTZ1SKm0YURdblOQOOR7AB7OBcEccHn4MUAe7yMbfyqyxer2niPDuR8sYeTn3MLNU1hEInDTrucTXXPR9mNMvbiWeIAXut3rtXrt3WiBhuD01ad(AAgooqaS6k8rOe3bvBlBdvDdvBBDtlvxDUqkPsSub8cs12W0vrtxhcivS3QzmYZw(lhmMxXJtP8J4K78QLu(OwoRQtugleFeDZIeIoLKqWSxxWdHPaNkoZGo7Nv7(zXSjhhAZAslb2gzjjNQUrw5mdD4xMLXPwbngU)(7wV)Wb9XsKL)uCyNBGfIZ(ub225O9dXLrl)bxpAGpE6o59zP(bO(iuscc6d3KX6hfGL3u6EQaQ9BXyMd6e1WFvUOSfaYGGMC8UCrwjcBdH9c7Hl8BDc3pWtu47SXKob3Gk6cEhvSzbpXrKtCwNHbE8J(YrF(doEVrp8fJ)n39S39XGMovtvmVj1h)1VZ4t(YrF3lg9vV449g)8No(rFm0ozla9dV87(Xx(93(S7FYOp4Eql(U)jOlV8zpbEl01p4lGUm6lFMS9a6D8d(tND)VD8390Xp8eyoFY3k)ndes(GZE0DHU(HFXzF6jqBK)gjgg2TlNlgYqfwpe4gHsb9YB2lU3fYTFkD5HQzXd)DIxqVMO2puqfBdiVf1Hon3Xu(cCnvvCWJEmVF74XPbnnNprKb3SVRssaTNoa5PtqsGyt(925cBTcV5ycB4h2oa5gU4v3yZvZd7dboBkA4q)oz1rSyueBKukaKBZ8YmNPMvSmOteID5n7qVNvISfpZCK8kytbrF50aH7mw)MagJR)LwmoldGLWkc4ItxmWxIYhi3DyVdAHhv8UH9eBoxndCFOzZndpWRpmKHnX6MHX6cEEmJcTdAEDWcmivhG7hA6gs6HNp5dWCLiOCC(FuM6pJm84plp5UIJ1qAYh4tqkMCeYxexUy3YYm66M2oA2QgAok4gkZBCVAwgKxh02QOAzzQAPyyzORj2(EoNBRBPB4OOQz7QaMfSCrnV62ICgxZqv1YzjqZBAwmx3WYv1u3W2u1X01wh1HR7KMwBqfpeDfy6X001fGiB5WHz6flztB0qLDwggbRsgaSzBaDYWu3vtSJ65ZwznnntDNLuWdLTiF31CvDCwYfL748mVUHRPJLJPMliiaY206WnnfKRBBBRPanXuxrlxnmiZZlGenDbdqkAgaUWXaHBdzLiieklWIbe(ObH8gsNDq)LFjwGv(atv7GoYZzoOna3etzPQTrT13YBNRUZwBVXYBQY5alaKuOZjPqyPbkR0and1aTb1iNtCy983Jon7Yrh4G26nwB7L3CZvxENL9a8BTnQDrsCR(LXc3BRlVYY74TZgxEnC2ezg2ZVxpqVstMdTsGtt4kvYGoIBhaE7wZVyFZnQT6wVPhsr9UAn8p0sc3(6EX8kxwPTh6pOhiV4f2snnBKAKNA0LSqlpYmcw)e0(AxUp0WkKCQqNzovI2GZbogUUItXS8WXrMtwbRliQKK8a1IEd8H(NQHLW(qOA0Haacg0L)RcDEa0mD1eFV4ZqOi83RWQqVEWrXjOwLSdNBQonS4BeL8u2bkLsGD7WeHAu8iCauNRhkUZbKkSM4ubt(rGLlwmUiWjYf7GQb9Qo9Qg9Qk9Qa(6JOpQktkCDfKlJ6f((SkPQWxloz4I4xwP6FDAJPSZPdDHYtykZ408OlNJ5fAFA9wHLAu61taxMyK3efN00fsHVEUdsvRRfaslmjVQRmX08QTaNk9vUWZU1fKIByBO8Hth8tOxxh9auykmXVbP7dvcjCjXVvl0siU7iCT5awWbTGbz1yKoEwiZ1f53JfVzUVol67IUMRKUf4YewOyM)2KOFB)4GSznmoRSwZn601JYCcqxu2xuVYgqrnCz74644cAeSTaJxkYkLJgD0j9ChsSchiNsif5gSGNuCHVnITaHAi67g4cDmEzDiVhDMaTs5bybJ3jdfuuvIZeiUCoNFawevHnlpNXP5iOEpHwUCDIoU3YIZwSmvDjN4eQ8NF757xG(4H(aM8wVk9GIHyrBpvoDZVXAed2aSEKNFJ1fEoucTkhkxLj(jbw9vaF(Zo6KllXfhDYT)Nt0zEneuslM3vmdNKqkvuvIQr7STfvv4CGbBc)TG0gUiw)jqC(3CoxnbQUh6GvF(Mfdvf14ipEN35dNGmqSfvr1m1eNDSmNKyLVJtiYWLKRHl4dMQMLMRUITiacZjuDN2ABdxhxvDfti2fvdr93ojqjzQNyGYdrtOCKukM2xf9cdCrBzYSBlZTTmZ28PeEc4b9uC2waYUEzYoGdt74kVu2r7mn1)08oXksAYZ0WwXW1qt3YYwJl0BJ8Zuf54C63YaXPxtqP9p1qPDfarEC(KIZZKnykKOS652vZqXsv1gIluZwtSUy2)5znUcHe6NAuX0UaMuZR8VGSzU(onfmZP9vO9Fr7HuL0c1EPkP5b(fujnNgl1(xMWl4mTubkOPIc(IPEQaDLYa5zYQuq6NMvb)gXrdMS4NRuZT5pfn9OQx)BCWIm(C7heMuXCmL(q55atpO)c5xae6508KyMa1W(uO3la8ykxZXlm0VOgMnS(jyyM58wytTTdFfa8)kzexESAZtJsMM1IC30cvPmsudyo8HLRdwDCGsVHXIGhXCLKLJYPLpvEB7Wt97fOJ1eF19iVDasJsP(l)xEX4t)KJ37LF)F6LF33svvwLhTLdbh(8OQgTMSGcOYjSoMt)p6ZoEVXV3JN1a8Mb(9J65Ts0HEk2YRuarmsWOC2NDYl)UF8S79IZU)tpEVFXO37Zo7(Nad6p8TWG(AvoQ0kY7Y(he20BDelemyD88)iUfcerEn5yF2jp7Sh(5hV3OF4oV8jVt1J9YucUpYR(W93pcZyS8klG2r4kh179IrF(dMfKU8GM(aT5YH9ADzYvUJKxVb4GAv5G(z3B8N(IxB6uLHyI2xhndUE4GG69dbfpY7cbCuTRAuh)h(2X3)EZEHVD7JI6GgCFJOoayhjV3eWb1Psk2h9(JV9)8Sh0lG3zu4jj6krHXaZGIM8wwGyeC0umz0WBVJQUJTUP(5vnW)Pa)F(DQNxvJE5TtoEpg9qBf04h9LJ)WhYrCZDn9EzGhBvdUioGX2WcAHM6Sh7r)WTh)dpiDNPEYpct3DV7z)DpJMdXqKEJoWZHPRIUyo0WuGBp7Py8NE7rp7UJo9JXD66F9X864ZFYlFY7o69EaUpwpgwvSacnAP3keK0RcUPdSe4jV7zNGBW2dFkijwIcaobgnPtG0E45JN43oyAC3pj9EKGxjag0ndBzcQTNZs5opy8Do5S7JBe4p8oND3VHxm)HNm(wVReHzYk)5lHIucUZFDj4M5gBx78eCfN5Seo92JFW3ij4J(JFZONFBE4vuT0m4AnskTQBBByAMrRn0vMZO)7bW(UG0c82)4pcVD0V7FusAn05RCd7uy3qrXqIxu0CvuMZO)YV)0Z(9Fjm0FaQeN3B0)89qvsF1J5zXut1MK2uDYJHuKyittddtJ5G9)O)PZ(F87o7JEmG4bT(mz4HVZzN8aMeZJbnjszAnviApjEYu1v3EouHrp5EJE0DbUMXFho635FC0hDxbvqd39ODzZMcTB2M6cLX3J5kg99pfuVp6R)TlUuaePxulXEzqJEM8SMQUe2TmvS0NJqWlF6NW7D9V)PJ(k4VN9hUlirqW1z)HBbMBOfcps0mPLPDY1YoJGRO7QoxM1rFjIGo9bWSrtbm1JVZPsCfoe7Y3MVPY0oM51aQ7ohY94NEhCh9p5(aA99F2OhDsQSHGKigfAAYKPTXlBRCYDQZt1XZFkQ46H)i9Mti7YNDR3Hv7(O)SeTzyP4AQXvMNCUCb(n9CZLP9CMRr37EGoPrF5th9ENWiTNC7ZUfYmJCYptQU1u1qrLjrwzmYkMAP6QSuMRapOt)hV3ON8Gr)pzwGr35ocTvM2UUC1NMI00D1Lc8W7DvNZGp6R)sqtFk94XcvIzgm4bHMeP8oWI5YNvL6G26x(N(yPi8ON)3Z(VagYFnbiIPwNr25SoBOLNWAoxE0)(pgz))ue3(KhlvFWiyBnqCM8cm1cTRnwHh)CY4ORMx7TA6CzO764oN56j)iyzE0hd23o7KNdlRx(NESy0PEtdVwgVcMFaHspDtt35ywB8pCFW3jwrXh(KrV7DLwgmPJEdEzOZJSRJIMWM)TE4O)H3F0PGsFGuc(IL2fhIXv3iNT8mlvQ45wXEUE(aY7KTCaQaxrE5ZV1z3(zIJEmna0myMhB6MNZWYCoZWDFhWZBMM913fyFH19V50ZE)hifqCemhsPpdfhlhT0PaCKqFEemWh378nV87EcZ3DRBZRRN8e2ZHNFIG6rdfnxzcJoUgsVsaEhh15ONC0)7Nm(Z)Nz8fzLhjjpMQ)iuDVgwyh0m4KUASDTut1LyORBpF3Ea(J7dm2N9WpE0xD7X3(HPgffUHQNjOAOLzxhhC75A2A0JeuJFZ7m(dpfdq6wcFF0bkon(gkPqpwQlIXhi2GQR5OiaekhFYxGADjrtW64NCkR99F5zJ(Q)7mLWfpEoo0mPMr1Dutnz5OPROzmx)GaElo0UF8wsZIJ(KV8Vbj7F8O)4JL630OtVznJmtWg6AM)vdRbsH81HxM5xvBRmDcokgAZHR6JU74p9jJ(EykEkZoJK)rF9xm6BEgysbvBF7rFaZgZJhnFgzujDfRuhunTuSMNeZNEYOtVZOV9eqf04)EajE2dEkGmHzgMR)HVbCiwOIHglAYYC221jlEbtfxdT5T6i3RHj9w3z07(cAogF)7(Y)1F34VwO1gmryWPBWitlGgEy7etdXWmpJWNImd3(oio7ZfMHF6VfeNYXZX0j7C4nnJFgWB5zWtDbhmmXvzF9Xp)0ZE4NWMaE0jlK3RbnaVx7sjlI3StXZYJghrvDxHQxKRrVPwZI5397If3x6bQUWOIxWhYB7)SYSPqX1WfDtcMNSspjesMOs8O0ujBAs56zm3Ww4AKIFm3eFuVMCnjblZMTXkNfZgMyZyabDy5XpKz8YDz1X3mjuD(SFhX9xexntPjFUro03Ck5ZQlSW)2HykE4JxbJAL1MRSMV4hVgdg2FI8vEyBaVJ5tKUFp61JU8Tx(xjVnLWVVhx5Yj5gU(y1EoXyLna4r0UU8U3vS(aaTL)r7whCgvEDU2dVyX8PkQmQzR8pvhk(uoqwbxYstwuL)0fhdwkX4wEnSBpUuI4JPRO66Kp5eeLh9(b9IdVrW5WuBYJbw8E87Ie)OmBNY2MMtymZ2ju(Lk3emf5r9O9riRyVKmb4jI9WEzmVLGIg5M5gvmVnYM1gvoNe6vMnymrV4m1nWl7P6qj0w(YbHFEte1RvykhR4AikMVpP4stNOqLUEIsk(S3iSJOG6M1cCLFQlWK06geK5WjrClH6LMvAXHvIYxnwd03GQ6EqkUzUA5Lv)CqqxQU9I9WYun3DoA2OjHCUd4USqpLMq5v(wYMEwY0MRt79bMZ36OCZkHvZ)ybBLkMIU97mmMPEYQKlXNLP4NWpIYegw39Xs4U1QRt(qyWhEoh(E5x8BIRAyyzn4O0lM3OE7ikbsAsJfpaU8pIIwVE3OEu5LaY17VF4n5FDWqUt4b9vh(hEka8hGPcHU9fKxFvLAt3Ws9krEXpXpKCOk8w(0vOE6JWiediiOi8RP)lvC)LA6hVNI151noVPZBFze)xxCAc2Q3A9AD8E0Z6Ga4nV9X71et0ByVdoEVK2bhVNGjaAd3LJ3Zpr8tbyxJ2x8jyzUezoSQ5KaUvzS)6H9cJBh06x8A08X8d0PtGUnboEV)tWioyi)8wAIbZIxa7Gn9c8tlRu4FjQMdQOlRaJ(QGyGVCrE9GJoEp6Ug780NDOxX0i()6DF5F6jJ)JVG2ueWVxiyh63gD7hJbO(h)MXFWxqvPxHPrZ(8g6ZgYSQSllmK9GrN(ny0pp8zSRYN(BRaSSlphkZfSCQSlliyX(XYE(C37o6BFggT93WynaGQacDlnDQajYC2qikdvrFwumh59nMU(p8ovapQLfsuXaIE7lCPL3CZ1QDX18U8wRUgE3OU9ouVLp5VGPOR)1dsFO8r8VO(CI9DFqNwWS5UPFTvaDb6hXQ3e3RgutuvOgiU8ZsV((kn6c)b8sp5sLN98G4HTd65HBX4eWaEAwe3Kh01Ojb0fBL4Hgb5BxE4mTb0sSfEIpORk1uTf5Bd9IKcXKN3cGNZxKOK(9B0c(f8WAZEHOz9lv0jYKQdOu58g2)mRltvV6j9NMYm80b(koAPNlUd9Hxc7bliIlyjAZsMC0QuqcgNErPlzyCsIeW5sCPWxXWmxzlvlw46KVy09orkNn6RFoNlZtbHTNZNv1IdoQ1Boc7ov2NfgG(Wth)z3VygCNk45wAQmCMl4HodwrFwuW7S)Uhm6RqRktdM0ulp(wNxX6TfN)e(MJYBZ1w(nwJgb8amG8T9y5VfCQRAEllFzODEL5y5qtVY(SW4IhDhaGgF)BpvCrzbgD9ZRRnhyYSY(SWW09pz8JGz)XtfMklVGBLG6)2BUW8)x3AHGajmxmbLPOndvd6MoRG6hfNZROCEn9FU9)1P6j9NMndn3x5rBg2m0vQy0uFLTzORw5WmxzmxwOQyHtif7a3iP9YA03)0x(03z8V5U81wAU5XMSnnh5FD9k7ZccBN9(3dpk0F4d40BF6Dg)WNo(bF2SGrJYZheVHXCGrZk7ZIcJeCm(5Vy07D6SamRstIHjqNMdGzxzFwqaJrxywtfM3McG5uAs0DpVM1)FnO)SRb1nVc0QOnt43TjTZu1vDLuln9ZR6EEt3FM1HIx3FvnP)00HIhN7jgT54MNHwL9z(UrWCrOFNGEe8cqaD365pJ)23)zJ)ZNsoKYfS5O7(o0UmvAQuNBm7ynAxrFwuWd3NAa8(mC)v(67abDD27(4zbHMLMnfie55eZoEk0ROplmc8RF(OtFmTTSCLhmlWZUWuPDEt4FZdb6uzFwuWdno8Wxm6dVtAooQgYClnlgUyYW(lYz(QaGkND5geK(8xjSfDfg6IP40Vz7YBArqhqJxaEPqg0rCLtihcQ9YtNrI4St32FWncIrvp7J3ytWhte9P0dtDCE5NC)ID6qK50IZpnruXFtxKKyIX3pCqmv5U15Bud5tcc5WWpJncAkUHFYvx3f31e(XXmENBKERWKELzWz1TlDhIQr3nsEPpYm4eahni8TW67UtD8HYsdzBOMe5HG9up4OM0)K3LSu6ULdsy8Mzp0ysFAVegNE3Fi0usNkz6k6KUDUkaA)7Gh6Z8TGwpH9s5JpNI8L8vudULCg4lU5iX53LfXgC1Q8owLFZYs3FTugGTxEJvlW1qmvaF284yOleHw8tpd5gBMX1NYZloMfIt7ukdfF58VkXHYM3wdgVJ3BJE4vCwRH0ZgfQpY(UL4H)d)Pxp4iXUci3KMTA8FnOzYfKN0GSNefyJYM48nU(Wg7GlqCWON1Ltaul3jfooEVlaDneFosx5GuJ6Sy2sjT5UIKt2D3)p"

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

	bload = LoadAddOn("BigWigs")

	if bload then
		BigWigs3DB = {
			["namespaces"] = {
				["BigWigs_Plugins_Victory"] = {
				},
				["BigWigs_Plugins_Wipe"] = {
				},
				["BigWigs_Plugins_Colors"] = {
				},
				["BigWigs_Plugins_Raid Icons"] = {
					["profiles"] = {
						["Default"] = {
							["disabled"] = true,
						},
					},
				},
				["BigWigs_Plugins_BossBlock"] = {
				},
				["BigWigs_Plugins_Bars"] = {
					["profiles"] = {
						["Default"] = {
							["outline"] = "OUTLINE",
							["BigWigsAnchor_width"] = 232,
							["BigWigsEmphasizeAnchor_height"] = 20,
							["growup"] = true,
							["BigWigsAnchor_height"] = 19,
							["BigWigsAnchor_y"] = 183,
							["BigWigsAnchor_x"] = 1190,
							["BigWigsEmphasizeAnchor_y"] = 385,
							["BigWigsEmphasizeAnchor_width"] = 133,
							["BigWigsEmphasizeAnchor_x"] = 386,
							["fontSizeEmph"] = 10,
						},
					},
				},
				["BigWigs_Plugins_InfoBox"] = {
					["profiles"] = {
						["Default"] = {
							["posx"] = 978,
							["posy"] = 75,
						},
					},
				},
				["BigWigs_Plugins_AltPower"] = {
					["profiles"] = {
						["Default"] = {
							["disabled"] = true,
							["position"] = {
								"BOTTOMRIGHT", -- [1]
								"BOTTOMRIGHT", -- [2]
								-230, -- [3]
								134, -- [4]
							},
							["lock"] = true,
						},
					},
				},
				["BigWigs_Plugins_Sounds"] = {
				},
				["BigWigs_Plugins_Messages"] = {
					["profiles"] = {
						["Default"] = {
							["outline"] = "OUTLINE",
							["fontSize"] = 16,
							["emphFontSize"] = 20,
							["emphPosition"] = {
								nil, -- [1]
								nil, -- [2]
								nil, -- [3]
								120, -- [4]
							},
							["normalPosition"] = {
								"CENTER", -- [1]
								"CENTER", -- [2]
								nil, -- [3]
								170, -- [4]
							},
						},
					},
				},
				["BigWigs_Plugins_AutoReply"] = {
				},
				["BigWigs_Plugins_Statistics"] = {
					["profiles"] = {
						["Default"] = {
							["enabled"] = false,
						},
					},
				},
				["BigWigs_Plugins_Proximity"] = {
					["profiles"] = {
						["Default"] = {
							["fontSize"] = 11,
							["width"] = 136,
							["posy"] = 71,
							["posx"] = 1090,
							["height"] = 95,
							["disabled"] = true,
						},
					},
				},
				["LibDualSpec-1.0"] = {
				},
				["BigWigs_Plugins_Pull"] = {
				},
				["BigWigs_Plugins_Countdown"] = {
					["profiles"] = {
						["Default"] = {
							["fontSize"] = 20,
							["position"] = {
								"CENTER", -- [1]
								"CENTER", -- [2]
								nil, -- [3]
								140, -- [4]
							},
						},
					},
				},
			},

			["profiles"] = {
				["Default"] = {
					["showZoneMessages"] = false,
					["flash"] = false,
				},
			},
		}
		BigWigsIconDB = {
			["minimapPos"] = 9.5,
		}
		BigWigsStatsDB = {
		}
	end

	bload = LoadAddOn("DBM-Core")
	if bload then
		DBM_AllSavedOptions = {
			["Default"] = {
				["DontShowFarWarnings"] = true,
				["SpecialWarningFlashAlph2"] = 0.3,
				["DontShowHudMap2"] = true,
				["AlwaysPlayVoice"] = false,
				["ShowSWarningsInChat"] = false,
				["SpamSpecRoledefensive"] = false,
				["RangeFrameRadarY"] = 0.9783453345298767,
				["OverrideBossAnnounce"] = false,
				["SpamSpecRolestack"] = false,
				["DontRestoreIcons"] = false,
				["DontShowNameplateIcons"] = true,
				["SpecialWarningFlash5"] = true,
				["RangeFrameX"] = -229.7040557861328,
				["SWarnNameInNote"] = true,
				["DontShowPTCountdownText"] = false,
				["RangeFrameY"] = 76.74076080322266,
				["FilterInterruptNoteName"] = false,
				["InfoFrameLocked"] = true,
				["EnableModels"] = true,
				["SpecialWarningFlashAlph3"] = 0.4,
				["SpecialWarningVibrate3"] = true,
				["FilterTInterruptCooldown"] = true,
				["FilterTInterruptHealer"] = false,
				["SpecialWarningSound2"] = 15391,
				["InfoFramePoint"] = "BOTTOMRIGHT",
				["SpecialWarningFlash1"] = true,
				["OverrideBossSay"] = false,
				["FakeBWVersion"] = false,
				["SpecialWarningFlashCol2"] = {
					1, -- [1]
					0.5, -- [2]
					0, -- [3]
				},
				["WarningAlphabetical"] = true,
				["WarningFont"] = "standardFont",
				["EventSoundMusicCombined"] = false,
				["FilterBInterruptCooldown"] = true,
				["CheckGear"] = true,
				["FilterInterrupt2"] = "TandFandBossCooldown",
				["StripServerName"] = true,
				["SpecialWarningX"] = 0,
				["WorldBossAlert"] = false,
				["SpamSpecRoletaunt"] = false,
				["DontPlayTrivialSpecialWarningSound"] = true,
				["DontShowPT2"] = false,
				["ArrowPoint"] = "TOP",
				["FilterTrashWarnings2"] = true,
				["GroupOptionsBySpell"] = true,
				["WorldBuffAlert"] = false,
				["SpamSpecRolesoak"] = false,
				["DisableGuildStatus"] = false,
				["SpamSpecRoledispel"] = false,
				["VPReplacesSA1"] = true,
				["SpecialWarningSound"] = 8174,
				["LatencyThreshold"] = 250,
				["MoviesSeen"] = {
				},
				["LogCurrentMythicZero"] = false,
				["ShowQueuePop"] = true,
				["SpamSpecRoleswitch"] = false,
				["DebugMode"] = false,
				["DontShowTargetAnnouncements"] = true,
				["ShowWarningsInChat"] = false,
				["HideTooltips"] = false,
				["ShowReminders"] = true,
				["ChosenVoicePack2"] = "None",
				["InfoFrameFontStyle"] = "None",
				["AdvancedAutologBosses"] = false,
				["SpecialWarningVibrate1"] = false,
				["EventSoundEngage2"] = "None",
				["InfoFrameY"] = 18.01542472839356,
				["ChatFrame"] = "DEFAULT_CHAT_FRAME",
				["WarningIconRight"] = false,
				["UseSoundChannel"] = "Master",
				["ShowPizzaMessage"] = false,
				["EventSoundWipe"] = "None",
				["RangeFrameRadarX"] = -230.9038238525391,
				["ShowRespawn"] = true,
				["FilterDispel"] = true,
				["HideGuildChallengeUpdates"] = true,
				["DontAutoGossip"] = false,
				["InfoFrameCols"] = 0,
				["LogCurrentRaids"] = true,
				["DontShowBossAnnounces"] = false,
				["SpecialWarningFlashCount5"] = 3,
				["VPReplacesSA3"] = true,
				["BadTimerAlert"] = false,
				["LogCurrentMythicRaids"] = true,
				["WarningX"] = 0,
				["ArrowPosY"] = -150,
				["AlwaysShowSpeedKillTimer2"] = false,
				["NoAnnounceOverride"] = true,
				["HideBossEmoteFrame2"] = true,
				["DebugLevel"] = 1,
				["LFDEnhance"] = true,
				["SpecialWarningFlashDura1"] = 0.3,
				["DontShowPTNoID"] = false,
				["HideGarrisonToasts"] = true,
				["RangeFramePoint"] = "BOTTOMRIGHT",
				["DontShowSpecialWarningText"] = false,
				["SpecialWarningFontShadow"] = false,
				["EventMusicMythicFilter"] = false,
				["RLReadyCheckSound"] = true,
				["DisableChatBubbles"] = false,
				["NPAuraSize"] = 40,
				["HideObjectivesFrame"] = true,
				["SpecialWarningShortText"] = true,
				["NewsMessageShown2"] = 1,
				["DontShowPTText"] = false,
				["FilterBInterruptHealer"] = false,
				["SpecialWarningVibrate4"] = true,
				["SpecialWarningFontSize2"] = 20.12609481811523,
				["SpecialWarningFlashCol5"] = {
					0.2, -- [1]
					1, -- [2]
					1, -- [3]
				},
				["UseNameplateHandoff"] = true,
				["SpecialWarningFlashCol4"] = {
					1, -- [1]
					0, -- [2]
					1, -- [3]
				},
				["EventSoundPullTimer"] = "None",
				["SpecialWarningVibrate5"] = true,
				["SpecialWarningFontCol"] = {
					1, -- [1]
					0.7, -- [2]
					0, -- [3]
				},
				["CoreSavedRevision"] = 20230224080925,
				["SpecialWarningFlashAlph4"] = 0.4,
				["SpecialWarningFont"] = "standardFont",
				["VPReplacesCustom"] = false,
				["PTCountThreshold2"] = 5,
				["SpecialWarningFlashCount2"] = 1,
				["VPReplacesAnnounce"] = true,
				["EventSoundDungeonBGM"] = "None",
				["oRA3AnnounceConsumables"] = false,
				["CountdownVoice2"] = "Kolt",
				["DisableRaidIcons"] = false,
				["EnableWBSharing"] = false,
				["ArrowPosX"] = 0,
				["VPReplacesSA4"] = true,
				["AITimer"] = true,
				["LogTWDungeons"] = false,
				["WarningShortText"] = true,
				["SpecialWarningFlashDura5"] = 1,
				["WarningDuration2"] = 1.5,
				["SpecialWarningSound4"] = 9278,
				["AutologBosses"] = false,
				["SpecialWarningFlashDura4"] = 0.7,
				["DisableSFX"] = false,
				["GUIX"] = -56.77048492431641,
				["LogCurrentHeroic"] = false,
				["InfoFrameFontSize"] = 12,
				["VPDontMuteSounds"] = false,
				["SpecialWarningFlashCol3"] = {
					1, -- [1]
					0, -- [2]
					0, -- [3]
				},
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
				["SpecialWarningY"] = 75,
				["SWarningAlphabetical"] = true,
				["ReplaceMyConfigOnOverride"] = false,
				["BlockNoteShare"] = false,
				["LogTrivialDungeons"] = false,
				["WarningY"] = 260,
				["DontPlaySpecialWarningSound"] = false,
				["ModelSoundValue"] = "Short",
				["DontRestoreRange"] = false,
				["ShortTimerText"] = true,
				["WhisperStats"] = false,
				["RangeFrameRadarPoint"] = "BOTTOMRIGHT",
				["DontShowInfoFrame"] = true,
				["DisableStatusWhisper"] = false,
				["VPReplacesSA2"] = true,
				["RangeFrameUpdates"] = "Average",
				["MovieFilter2"] = "Never",
				["RangeFrameLocked"] = false,
				["RaidWarningSound"] = 11742,
				["CustomSounds"] = 0,
				["FilterTTargetFocus"] = true,
				["SpecialWarningFlashCount3"] = 3,
				["RoleSpecAlert"] = true,
				["LogCurrentMPlus"] = true,
				["SilentMode"] = false,
				["CountdownVoice3"] = "Smooth",
				["DontPlayPTCountdown"] = false,
				["SpecialWarningFlashAlph5"] = 0.5,
				["SpecialWarningDuration2"] = 1.5,
				["DoNotLogLFG"] = true,
				["SpecialWarningFlashDura2"] = 0.4,
				["WarningIconLeft"] = true,
				["RangeFrameSound1"] = "none",
				["LastRevision"] = 0,
				["WarningFontSize"] = 16.47568893432617,
				["EventSoundVictory2"] = "Interface\\AddOns\\DBM-Core\\sounds\\Victory\\SmoothMcGroove_Fanfare.ogg",
				["AutoExpandSpellGroups"] = false,
				["LogTrivialRaids"] = false,
				["GUIPoint"] = "CENTER",
				["SettingsMessageShown"] = true,
				["SpecialWarningPoint"] = "CENTER",
				["SpecialWarningFlash2"] = true,
				["SpecialWarningFlashDura3"] = 1,
				["DontSetIcons"] = false,
				["GroupOptionsExcludeIcon"] = false,
				["FilterBTargetFocus"] = true,
				["SpecialWarningFlashCol1"] = {
					1, -- [1]
					1, -- [2]
					0, -- [3]
				},
				["CountdownVoice"] = "Corsica",
				["SpamSpecRolegtfo"] = false,
				["DontDoSpecialWarningVibrate"] = false,
				["RecordOnlyBosses"] = false,
				["ShowEngageMessage"] = false,
				["DontShowUserTimers"] = false,
				["AutoRespond"] = true,
				["EventDungMusicMythicFilter"] = false,
				["GUIY"] = -0.0002178665745304897,
				["RangeFrameFrames"] = "radar",
				["DontPlayCountdowns"] = false,
				["OverrideBossIcon"] = false,
				["SpecialWarningIcon"] = true,
				["InfoFrameFont"] = "standardFont",
				["SpecialWarningFlashAlph1"] = 0.3,
				["ShowDefeatMessage"] = false,
				["FilterTankSpec"] = true,
				["DontShowRangeFrame"] = true,
				["SpecialWarningFlash4"] = true,
				["InfoFrameShowSelf"] = false,
				["WarningFontShadow"] = true,
				["AutoAcceptGuildInvite"] = false,
				["SpecialWarningVibrate2"] = false,
				["DontShowBossTimers"] = false,
				["SpecialWarningFontStyle"] = "THICKOUTLINE",
				["DontShowSpecialWarningFlash"] = false,
				["SWarnClassColor"] = true,
				["AutoReplySound"] = true,
				["WorldBossNearAlert"] = false,
				["InfoFrameLines"] = 0,
				["BadIDAlert"] = false,
				["ShowGuildMessagesPlus"] = false,
				["AutoAcceptFriendInvite"] = false,
				["WarningIconChat"] = false,
				["SpecialWarningFlashCount1"] = 1,
				["PullVoice"] = "Corsica",
				["SpecialWarningSound5"] = 128466,
				["DontSendYells"] = false,
				["SpamSpecRoleinterrupt"] = false,
				["RangeFrameSound2"] = "none",
				["GUIHeight"] = 600,
				["SpecialWarningFlash3"] = true,
				["OverrideBossTimer"] = false,
				["Enabled"] = true,
				["WarningFontStyle"] = "None",
				["GUIWidth"] = 800,
				["FilterVoidFormSay"] = true,
				["SpecialWarningSound3"] = "Interface\\AddOns\\DBM-Core\\sounds\\AirHorn.ogg",
				["ShowAllVersions"] = true,
				["ShowGuildMessages"] = false,
				["SpamSpecInformationalOnly"] = false,
				["EventSoundMusic"] = "None",
				["WarningPoint"] = "CENTER",
				["InfoFrameX"] = -357.1292419433594,
				["LogTWRaids"] = false,
				["SpecialWarningFlashCount4"] = 2,
				["AFKHealthWarning"] = false,
				["NoTimerOverridee"] = true,
				["HelpMessageVersion"] = 3,
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
	asMOD_t_position[addonName] = { ["name"] = addonName, ["parent"] = "UIParent", ["anchor1"] = "CENTER",
		["anchor2"] = "CENTER", ["x"] = 0, ["y"] = 0, ["width"] = 0, ["height"] = 0 };
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
