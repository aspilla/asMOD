local asMOD;
local asMOD_UIScale = 0.75;
local asMOD_CurrVersion = 240303;
local bAction = false;
asMOD_t_position = {};

if not asMOD_position then
	asMOD_position = {}
end

local version = select(4, GetBuildInfo());
local layout =
"1 39 0 0 0 0 6 MultiBarBottomLeft 0.0 -4.0 -1 ##$$%/&%'%)#+#,$ 0 1 1 7 7 UIParent 0.0 45.0 -1 ##$$%/&%'%(#,$ 0 2 0 8 2 MultiBarBottomLeft 0.0 4.0 -1 ##$$%/&%'%(#,# 0 3 1 5 5 UIParent -5.0 -77.0 -1 #$$$%/&%'%(#,$ 0 4 1 5 5 UIParent -5.0 -77.0 -1 #$$$%/&%'%(#,$ 0 5 0 0 0 UIParent 1111.9 -439.8 -1 ##$'%/&%'%(#,# 0 6 0 5 5 UIParent -1172.2 -470.0 -1 ##$&%/&$'%(%,# 0 7 0 3 3 UIParent 1172.2 -470.2 -1 ##$&%/&$'%(%,# 0 10 1 7 7 UIParent 0.0 45.0 -1 ##$$&%'% 0 11 1 7 7 UIParent 0.0 45.0 -1 ##$$&%'%,# 0 12 1 7 7 UIParent 0.0 45.0 -1 ##$$&%'% 1 -1 0 4 4 UIParent 0.0 -301.8 -1 ##$#%# 2 -1 1 2 2 UIParent 0.0 0.0 -1 ##$#%( 3 0 0 0 0 UIParent 576.2 -689.0 -1 $#3# 3 1 0 0 0 UIParent 1013.2 -689.0 -1 %#3# 3 2 0 0 2 TargetFrame -31.5 -4.0 -1 %#&#3# 3 3 0 0 0 UIParent 339.2 -356.0 -1 '$(#)#-S.5/#1$3# 3 4 0 0 0 UIParent 3.0 -546.0 -1 ,$-=.-/#0#1#2( 3 5 0 2 2 UIParent -324.2 -374.0 -1 &$*$3# 3 6 0 2 2 UIParent -312.2 -376.0 -1 -#.#/#4& 3 7 0 0 0 UIParent 559.2 -779.0 -1 3# 4 -1 0 4 4 UIParent 0.0 -326.2 -1 # 5 -1 0 3 5 ChatFrame1 29.0 38.1 -1 # 6 0 1 2 2 UIParent -255.0 -10.0 -1 ##$#%#&.(()( 6 1 1 2 2 UIParent -270.0 -155.0 -1 ##$#%#'+(()( 7 -1 0 1 1 UIParent -7.0 -794.0 -1 # 8 -1 0 6 6 UIParent 35.0 50.0 -1 #'$A%$&7 9 -1 1 7 7 UIParent 0.0 45.0 -1 # 10 -1 1 0 0 UIParent 16.0 -116.0 -1 # 11 -1 0 5 5 UIParent -272.2 -380.9 -1 # 12 -1 1 2 2 UIParent -110.0 -275.0 -1 #K$# 13 -1 1 8 8 MicroButtonAndBagsBar 0.0 0.0 -1 ##$#%)&- 14 -1 1 2 2 MicroButtonAndBagsBar 0.0 10.0 -1 ##$#%( 15 0 0 2 0 BuffFrame -4.0 0.0 -1 # 15 1 0 2 8 MainStatusTrackingBarContainer 0.0 -4.0 -1 # 16 -1 1 5 5 UIParent 0.0 0.0 -1 #( 17 -1 1 1 1 UIParent 0.0 -100.0 -1 ## 18 -1 1 5 5 UIParent 0.0 0.0 -1 #- 19 -1 0 0 6 EncounterBar 0.0 -4.0 -1 ##"

local detailsprofile =
"v33AZXXXrc(R5ItY3sS97hmI7daeaKie4aEyaTohbd0ONzAGPxoV2U7HqWNmckryD0I0HKSjTGTi5rfw0sYl34GPO0jgl15)pCg8F4YmRh9JPNPhsrfXzTRbNPNQYkRSY3vwvVT62BTD9br93nSta(X(xliYVthVMDc8J86fSFs)O9A7hNS9sBxVP)GKHrbErb(DWg3g)x45Xdc60PjVrDdJB2YpXh)S)Wi6Fd6feT3b4NA531FVa4tjBxpQ)(E763kWlShaTAQBxh(qnTTRPSGg(7d64FqqKxRGe)WoXE7h2Rv)9XXnUPpGTyhAaizsW7Gy121RF1d6e2d(q8vbavFLox7YRHWbNpmyf75dO)Er9hoy7gBxFymmxaKWVxyx)KW(9Irumkyq)OepCY5bW7QXytzdEmdF7pmHJW4NYGXDdbinSRNKk2VBd)eVKWUi6Qat)a)K2Ej973jjCamJAL0E7A6MkYrnPV3(T7VDDGy3Xpo2diTnJb40pQvmoMwASrghrtvxtDvntogOBdFsh)e9mdwBa0QMQHLTSBIMBPjAUOXwSwBPlBlbsnEBkf0AaUZBnVLQc4YBNQOHQsWMIZtRTzNLfNE5Blm3CKn2s2A7Pm50mtNDo8zNA54GX0MyLqemNXCBIMBznRwlBmoHjGpR1UjBDgQHUMJ6KuKj7I7SWhBrZD4n3AQR4t0wtB7zSqoXAtgM7sqeDj0zW2rDg8PtaAJz04cqwZYCgu8jAS1Sy)MO1PeejA4m9wptw7jydTCNgV9KT1wzwisXMNP1txTtrglvfTPt0ZlTzRovmVanrvrF6lofaQ2uzulWEOQymdcDrfo26ZI0va0zACj80tWMQpl5LjifMZarkOoZsDQeJICDMwZqwP4ICQSYeWDIMAmdXQcCCjObq0fKH9iZ1bTqtZObBWGAsNa8H9A5fhebMA9g4hbFcTtpamX3OruW1cjd6iWRVF)OoTe2IdJ9sI8JBJGBW1g45hZ9ha(EJ(9VAx)ORsUu4fh(lrR2GvEP)bO54GwEGzEagxlOdIUgMBxh(wZR6fMe01Rta(CatipfO2ttpZIg)JbK(Qt4AXuCfkSxCIFVMbXEDd6ne8olegpWxH(dc6HWyc32A2g(AqpYvlISfh0zxGg0PprMqh0Og3B4aVo93d9JPr2HPvySFJoi1oYRD4ET7a)pQjSjb0fgWIL(bwFVOaazQ3y4U7cUGf2bqjGkefg0RvNd2ne9qRfmL7h5JOfaiwlhmmAa4nxDWhNoaDaGWbG3KGJEcFfbxJAH0ayKBHJBNWUHi3Vfr3JBdisVM(jb9G)hdd7DGxCZ(GNEDdIJbqeNFUfhShqftIHzrZRYySs)XE9HbOb3xZgtS2dmu6CYxJO(xnG5(j6Vgcay(b8KO3Nnq02Vd65NxRb4Ywcqo2cDfgPRTioK(9s4ljm5c1mk(ujPbvY)1iOtEIoUeVJXT9ruSETnQTI4rmowhWr0dsAh20Rfi9eaOE2bnYVlYnKKe2BpA1lUn4cCsiiur(Yd0uW596RVXBdRn9bo9TRV1gxkRt3c3wva3wpy7ANrf9S9DqnaG)4nVARO(dYnT4AgYPwI4QtP)Tdi(RAA64ZJ97cSe8PdqUhoai4OSbqdVMpj1bpLes7V7UWCbhagjyx)MahZQrH)Yd35)2q)w4K5WD2cJSza5HVhraamJ0X0nOB)Od8GhrQNerc5fds3Ed6tXdqRHjhma87pkCVWEicadNqcHXQWuIqmA9g2nikeOwEXheJQeIpOBJ(DIXWHs6l90pUz7GU(CzDjR5WbdIaMwUokKKYN8mUVvDmSSSTS1STDDuTCT2E3ZaE0kNCLeJusj6V8FhH(l9mZpAAve7ZtAjggufuCPe5Sb1n1GKi(ngpDuFGagcYVzLxqXf)o77FqmRv4Vjfz97c69bWzKgYegZxm4pi(GUGIqk80UW6C)UE9W16Ls1pUBh)9yQoyXiErmGn)oHXjHnzTkkKP2UtNWwXsLNnbmL0Qt81EnoGpbscaoNLkQ)nvHkOjwWGqCZBLYQRcEQlfLajOmHpMlSrtjxAsBG1OnOLKw2A2P)qWQglK80qR9s8VAaiXdieQdO3Ee5JWFHgmTmQlYSGwJHeGLdyO9B4f0Tb068QSWNt0uqH37if(q9az)smmSsjdOBzuEd4fSmctauckyx)HDs8AWTLGCikUgQ0CdP6Tdd60IKPybdlddU(fUCTTwzZ5naT6V9IBU5ABS5CfPA9lT46lU8A1Mx3AQFXfp)kL5JNHJceBQD5JXkBvDxk4yw9L38YRTCgxZuvCt9pZaiCgkL7jC9lUrT3QehlTCZ2LjMylVYIBDH3Q2AN)cB9seWA9lx78BUXLV0LwFXFr6su1UZwV(fw8IlwBoilfxDVCT3QgyTA(hPlT5ARupDoLb(A5PSLoCaXS(Sy(kmylcAsqL7tD4u0CHVz4uE3bw3134CV1CUSpbYU8ka6MxArSURpBp7RFbqylyEh3cy9MBC(lVYCsGZZQUYpFJ3kdUAQO7QKgs2u4VxP2kx8xmNlijPAte(VwG(aXOZJLsNdbJY0ISGTJaReXQAOxIcKfaR0CkTmpj6tO4WqvmO824AqCpBUsTf9(fRS(6soC1CHhRndzodXILa9kQfrvUAYBHIrr1f5gmt3PPxW2ws2fignhRVY6RMgAVRIQRGhqtfIZK1u2ZlOwuVaYpbFLa5DfGXqTmTbsxp4O1ekaY71TKMF(nxzL01qlhljZRauUktY8blBQQ2zD4DbyUzL6mpyxoMcmvTCHtlXIMQynX2Tm9aMcMpt1CTR2kxERnxC9Y4vkr8sqDmTTKmjUotQnwSwiAKJntss4em47d8rmj7XPM9RN0pb8JmF84At4mhghl6VnZPowiDONYEm35O9rOGdSjGJ47fejCI1uKSG9I8haX9qru0pbcbShgGwFiyIDtiFVaN7y(JKId4iboVfZITr4in5oVxqRqApnGq98BHBWbaUmEdr(R5pGCHI9XlbHmSQLRMIoOXt3Ye05bkr29myscI8BfsUzzPWdEH50noQ9yr0Vp57v)w9PNsTz3(rWuN84lf7tdyq4pm4rl4v)0810a3HbUVMGUyee8wcQc7oGVkFgNm8TASaqpJkPrOFVoh4HPlbIEApYJmXkpeVyqsZ2EngMKW8JN2vLuF5j)pHgbEngHHQVB4EiQTlJAYIUHA0)6qKe0ccuUjXQqHeaUus7bc4OleVe5sDFGBdw7JfJvkZHFZMb0gsjqU8HbZOD5DvhMtuuVc2Hba0A61TprPZfscAnmcZhcnWKFSEuEFELJRhdCXtgoGf)b5ICEbHsozECf2OraurEauQmMykumi2G9Bblmjqmca9OlTGvYpqekr0ZZkRbLNeGfufAqvfkSvT4Zgd7mPdOrkFlLIboFlUttcIMCl)wMT3GhUt9aiESWKdMsC(KuE8((dqLnToacHbwL5CcKcgGHiSNx)EIOwIPEozE1A0poMPAJYIhsjabX2qmH84FYNYJe2wuwGqyimcQkn8sFYqQAvaFmuDVbbyetGIZj0K2gIQINcQsy4aJrQ2wz8xsLHpnVkl7PseIc6I7mk9r90pYWjwK9qFcWePIQvzIzxlmUF08WRJmICo1gssgewAaeRkMNfwNnvSxGz88m6MCt(85iOWlzymqmNWbbHtA6sKfmi0avjc)XgSCIP)fICnjaytW0ckWhwS8reRwE6MDrIwErv78Rpj(r7jwIWKziv)(2S2Eb6FsKt7OGoWsiyzdGYaXtrRAm1(ePcHWQG5dvffDDxBBhDtWqpyiXfe2g2GYc8(aN5a)bS1crV4YKK0FZ(D763RfNxgBX0vf0GPFB25TJXaXA5KYGl5hTe9BhUJEEkKFJWoHjHyAAC40OuOqr1JKRLiwwnvmqH6RtSG20gycUQL5lBMPzY0jXmd2qIDCvGgKzXWUiHPBqs7(TismLWdmVdYjXAyUfrQZvaNqxF9L2yJ36k1XSaH7jWzUK)EbNrvUaYtlAJ(GjVUzGw620RclEMGlaMA6oAkoA6GNt7EgtY3UvD010Sm1GOICaxd1vy5WdOYRABzBOQBOABRBAP6IEoysXUSQPIMLIQTHPRIMUo4QhbTSmYZw(ldoMvvKtHGoCYKEwc4rnbdSG94Rb6wPesjmeiDbHbly5ZJlidwObxwOce5GTx9m2Qo626koUarqfMZitSbMVyWpjxvvxxthhftBfh6xWTRbOqQAGxsow26woUwkkCpOAduinxDhBfBG(zyyOAX(fKnaMxSHefdFhwIQ5wqqRhkkSPeXUKQmPbJ0qjHmMZ1aKbnmTOGCeQ8g7rpzdzSaCcOMqePEm6Bwnk4cGihXI6fMm7oezHYWsIA1ip5WeKcgn4j7ltUfjhPIN9YjkCH4gjkr1Utgo4fB1AJEXxHlxELqmTGXxjBxI90K(nawcJ67j9EpnN8KVvODt)oH71ZR7qqC2JuZaUFJ7DWs4A(((X0UqX3zImtxbzJCTnPny(yp2UFbybHet8JrOD3gzi9ZYopGt0w8qvjdmwCVJRpOZW9czEWVpmTI4Ets5zhPwTcIHfFqXhZvJmFL2BnMF95ijI1wHpZP7eIFcqkGfmwsSfRW81xrETfeEgyuZrKMd1Tzyp97mOTpt7hXM1GLaaqYj1NRjjzNNzSVEbNqG4VfEHi9saEQRbxfGln6mo1EOJ70gDje2Z4UBypmMwI2Fn)odjBpk0gjpVnuFEBOX82qZ5THwZBdTN3g6mVn0DEBOQYC3Y5ETrDUxCuN7vh15E5rDExF4BOeZgViopMt3HGL3vbxdLE8NUNEsbMPByKPNEpwIQm1i30J9i0GRyiFGTPsVLTXrX7hInLTdmrSyaX9Wg3(LTMmeGjqLS7Ws5(YN2yHZ0mLWmF)PTexUdmNb99JJs4wZlWO8DstykRMTXK)QU8x1TO1aFiw4IA2z2sbcJiQ480bmIQmw3YQPpnhr1jtXGRJ19VgB7MAgGwYWSJT1IRTEDV6BT4wxU(slUP3Lw)YNFTAENJsewDMJ7tVzxA5lvplZrfTClzwa2sSxOiHyvYJ5fB2eMM9s87C4oxkkaNZ9AEaRflIMhL7K6wIC6G)uDzG443oxLUPnZPt9vo)fxP2w)Oru1FIr0ZXZt5poSu71cwIHUH5(BoiRj5cQVx2yw0XVdU40L)TCkzyyWsicSe(JlHd)sOjOLyXGwpEaoPRDgm1NIqGZKepHgMCEwEgnB(ukBoJ1Nuq1q0VvnSSG49D1uSmTaFcSzHiaUOL6sNNxCp)bxGItAVu3jS4Q)IXTtpVltmpz6j3sAXYrbncPU2MtmpShRFy6dth)TLfkqyVDjN2XjYMOdXu9BtKSGMZPFTutzQ75bEqGB9SGdhlM2rsrag2n6Mgtdc(jIjHkGfwmDSu3KdT8I7Ytwe7XKYpQq3NGbirGcm96EnhgdaLvPqOM4W3bJ2Vkf9C(MTkhpds2hl3kE4aiSoiZoWZ9c0lnzpEz20lM5nFyX2FxmjSKNQlLjBHCs)QiV2vGqN0wyRTwfZzlXyK6SBEtozZ9OQGeKDUx))bsVu)vlC4o0N0)v0)O9Rs9FLmauD4S8rrBctNtnJeS6ZVFRGoelWWbdGjo9DWgegOF8vweukTuevFBWVheDEm7ulCrnmZK7N2AkFsxzL)7xAXA1xBJAkAxz5n2y5fxU(vansT8JI8VY52y9LxCZnxe0eE56l0vtmEsjotbmZG(ShiBIQOtPnbptebrnPmpNvV46Efw6xhZmDVyq)LKPtwHvz4oMpbmQeapalUTmP3kx5E0MQ5NuEdk)aylHGZUkwQiyAuHqPkK8b78zBd)xJmsERpPK3lr4Ue7owrvuFRxOEJkH7LE8ErqaFu4DP8tCwyCEWK8Bqz9hWY3q8KYLZNwHoLk)tqFQHakPdeG6nSBdwQ(krT08eijRB5277gYNwIu6H78gCXZ)jP86)P3SmXSlW5oetP0cgnZY0QuLGgVkMw(RC51od)7RdUqFMlK2Hs0Cn3SPgErbS4iKCCtISl)FoSzYWUfxgYQPCw0Yvnnu1mnn1TS1D0v0Ty5ORumFYrfOPCu8nLkilSGWvaOs70LGLHyoN2omqvOM0kyof5Z2vlI9l7WVuPsEZdZfUDEEdI57NxkJvCWa)iWbGiXguLxOAI1wzohs95qOrSWUmLF7iYPivw)USuqAy6QRyPAz4yzPzQH5z0YwuXQ8C5U0gBT1gxCtQMgYv7KYufkDwrQHw3oZ)jz54P)1srXW211urx1c8iZmn9Vt5x0N2ViIcoJ)wZXccZvRFEH8w6rvyn30QfFNwOP5vrcUurhpqoCXhvDfZDuy)Wb0AlOMSbMvi0rQgfI1mFuF8FcC0LQ1DkFInhgbkfPnwpnbA8SlvptzoNUFrYGVZwy(Gv18QTWct8xj3zsC7Mz1p6sITsFMcez7gv9PY(npLODwF3v5fEJwAO9LAAGgm2evo0n2J5)yg6wEckrbjjekBLBX9jSHWlXgtkbrzfTFCyt)())9PNNXRssy5Zqu)ES0ciYJlqo7tUeqPbwKaciqJaQusuZqet5IZrss3(ScJuw54PMa(09TAIYKINavB2UxsRkR6OOzQO54OA7yyPr1TTHLKVPo5Jc7OJqB0Bg)ezB)9QgU2oMUQo2qiEMAkgS1Perr2W2y08eSohGty5PBHSLKrv7ANBJA1VYA1(5EarmSJ3waMGjvRIKpjtoVWJshE0JLKWD0YuP7BqXm8xWZWjlAR09HoHxoXzoknZABceLccRussRsfw2eZvA3KLq(gbX8A8L0jZI1edvc680)Z2RbzbpNDfw0nmoDX5DsUnqK88ED63WFzwSM85oqMzvEeljC86xHknLSAqHFRt4UbE84gyf1cWOrjEGvG5STMoMopruHq5LwKhYD6a1FWZ9AcBtG50kEH5anE8dE0Op)EhUZO7)8XFWTp99E821mvnvX6LR(4V86Jp(rJEYZh9xE(H7m(zpD8d(yODIwakbEXt(Hx8nhD6DpE0hEhOfp5Fh6Yl((tGpcD9d)cOlJE03lApi5m(EF7P39Rh)KNo((hdJ5jFT43mqm5dp9b3g66T(It)0JH2i(ntU7sr4XaBGpSmHHcaHz1pkHLL0G3zGRssavtuaLUtaWIWlS(To3glXuoh2TllJmuPzGgcr1B0zmNPChRBDXHiqsGsKNyH9BhGCRN)YRT(YzH2qGLL8KleKOLoZrA8XTydR)KSLxh7CoeFqVM8TRl6CKvgw4SSrKqcp84rThEec6GfBfmgiRaLpb23blG4(NJzYHA)aGNLQMQySE1Svv1vTPtPUyoX062IngC6d)qgir3mNL(0k8qnnRwOAzUg60YclLJlFLmrMgI2dzKtYKAoAxtzNRVwEKucOa1WWYklzvqrrYlrrjji80iGESaQKAH19txqxjZFHAgOvPiFaK887mvc5)6WGOdy(rshbrVmPBMDPhqvz0UD4(XW4mWhrNzUgsDzLGnevqCcUsreMAk2wXJxQbKjixw(TtRlxW9idlJfSblnY6wUMMMJQZc6GrEEH0wdOu6WtCC5vJ8QMAwog2M2QMGZYMufiGBaaVGzx12svvvtZqrdmf5QPH)StAfpdDhSORRzzzP6Q4sbhP7kR60vT0GqM0SP4NumnWQyaR5trTTcg5u0nTuGg4yb92K39S1j7Qg2wowawARPPOP5IWq3wwVQ10DnSWcv1uuPZRAIEKOcDbM4q8AgCCMkY5vTnrdZWmfAcI38Fumya9cI3Z2eSyRRbAqydwc)2PGFK(YDq)Yybo3bYH7m7sfAo)oUi9xZFkEsbwP9s6iC(Hs(4CDAA21Ze0qU2l9PToJd)DYuOd2zK7zdALTohSNcM)YIIC6WRy3E5qzENM2sICfeDrcubgfY8Xo9mflEigrMpOSPDqhHzEqagTsk2KI1QT6gEBD5T2yZ1wCDvw9jgaQrj7YCnPnW5zdCA2aNLnYu0BuPuUhQfIb2n(5RS5IRV(YlU1IEGOwT1QDEIkv)I4U1SXfxAXT82ATlUcoq8TAaOn9alcnzLZWBVwTL34T9qzuVlxd)hcPkfD14LEwsuh(XuMDyUYo9h2JC1rm3vK1LdeJBpqdiOmxvwzZuyEuaJEGXzpsTS0Efrm0mDvO8VB7yr)RLkTdmWZ1yFxXK9VGYe65o28VZFUn77oAg8OVk3QjfzrQvZYSZNA10Y2sr1XauqXUiBezGNC6Ajjq6nachD6gCVAWbGj9EZLpzSWiXWbAhMWLRW0gbRPxnK5JlofAvWlHAQzfDQ)I)ppF8d)Kd35fFZ3(IN810EovAmd7dr)4rNxKAI7zbYT96ORDF0Fe8(69F8SaWBh4paWULaCwXwufiCbxakN(hpgCj80788tV7tpCN3y07)hbFdbG(DFna03SuOsZiVl6VxytVvrJQbrRI(LZlCeE4Btc7tp(7p9(Fo4e53DZxCY1lh2lsUCCGx9H7UBFKXquLjuzRwkuVZZb3HNfMUyutFyL9IGdDxKQg(devKccuRsb6F8oJ)0N)MtFvzi61ZQiJ1QqKy1hegfMikFfeQ2Lb1X)PVE8DVZSN4B2(G(WhA79Z73bq7(IsDbbQtPRyF0VE8r)Tzd0ZH72cg(3L6hgdmdkAIcJHyeC0umzKH3DlvWkUUP(zvnW)Ff4)J9j1ZQQr)5DtoChg5HIiaIgz8TUplWvwxLLsdd2QgSZJgaBdWjiBn1zd7rF3rJ)U7jdq5KFagUBFBAa49xwboSba0kPZhaniehf7zd)XF6rJ((Bp6HFmgTZ)XJztcM0a1Bzv7qIQkoA2m51Xh)ENEmgu19Fki2vGCdHT2FYWwP428XSP2bvITBISoFyyoqUCtjnMGNKvG638EJV5XNExm4VV76NE7VIqEbPb7VS8GKRRoVExxnZaBx7SRRkovG8p8OX37ReRRJ(ZF1ONDed8OtJgSBAfHqPUTTHPz6QQHUsfq)paO9TbHc4J)5Fa(4OF7)Myrf682SYjxG7qGhgc6c4ITIsfq)fFZdp9p8ia0FiQRMfj8F)om4BQPAtItQozPnkcAJPj4KSrf09p6F)0F3V90p6XajhuRNHNK3Dc(c5vnvdxhbXXu1v3Ucs)OtUZOhC7X349g)eeW38FB0hDBoPxZ10HDB0iKyTTn15kAVdJvy038uq19OV83m)m9n60VFlUHBc6PIRAQ6cC3cIiqVcE(x80pHLEI)Wth9xG)90)0Tbbac7zDNaVwQ6gxl70LwfDx1kzlh9iKQ8W7bdbnFHXtqDW(Vn7(Yqk06yMvFgehufdWtVjMMMJVlqi)1F)OhCmkcivNP7YSSNkZAJ71vg5k1Quk8SNIQKU)pqF4yY86PC4R4AQXUQHeG3f4M0ZaEt7ka)O7CNX)Ptg9ONo69pMrDo5ig4nvnajx2LEukNPIPMuJJLsLITGo4F4oJo5EJ(93JH838MCDoM2UUSBqljPr3vxi2cF2vTcGp6lFeOPwQX5XppvDjR7e4fsTaJJl7eLwh0Z(IV9JfcIJE2NXCZaS3(MCKdID2IrzZye1ql7cNzLCEF2hdCYJ)0pgTY9yHsagP1gI5MM96sdPU2y(4EnZyORMvHRQe8g6UoUva(t(HXF(jJ(yWy0Ph)myM8IV9XCOt9MaVwkJbU1dCvw6MMUvyjA83DxWRgcTp9wNm69UTqzUjD6JXBhigKDDu04gOVX9h9x)1JEiONgw9aVKKDXH4s1nYy4n14IkEgsTR0Neq2Lm8cy1O3)EV4z34u(X3K6obFZS0s3SScwMva)BFDWJy2I0xEBGtfM1FWdfccoCwbHuMHIJLJMe(GzF9QwRahpV5x9INCcJl7ghrtj(Qf1FAasL0CCneooa8koQvOJB0)3tg)5)ng9HmeJlbmUblW8QnJ(4iXFBxlvPwcdDD7QDlbygUlifF69)4r)LJgF09L2V4oeQNkiAOLA9fbUDLwyg9aoX)dU(4B9qmofoThwEjOBOiXDGtwqAGvwqLufI5NEJRp(4VavGs(ZcMX(KhYTT7IxyOoe8vtxBDuL2xC00v0mQ03eG9Hfv1pCJ8gW0T0ORkHAgPgin01mFnrDabl2Xfi16OkenUum3rXqRcgNp62J)0tg9nWa8ugBkUiZ0bsDNaVrkXxxXs6vOPLIvvm(F6XJE4nh91hdkrg)zav60790rC9cu3j4N6uRRtQh5MkUgAvH)KBSW4CJBo69EoG)WhVlpyfqjUblUDJujxn8CQZhaA5VkdKpexAp6MJ(QVhIYLTm80Ftg2h2cGDgkKMXRhkuw2tPRTUykAzQBF2dp9(Fctd9dG)8g97D4oh0Fy0H7G3bEV5C5SyqdS61O93ehgHmSHQJPMWnonqLFv26GWHgF09g)LOIT)3OtwPM6zDNsJGuigpGFPUP4I5qQcPaq78h8BzK))6xHW)w37fCPaQ7e8vZcFNx)WpJ1uDdTScXvf71D)1J(R)alSI7IkN)p(TJ)YBMgcGl7MEvxcFtqhDQBCyc8QYaZjJ(lpM8L5fN8)K2uWx8nFRqjKkZMT8M(1fczkLj1wRkZxJ(OJaNXOWaEXt4rUyQ4y4s62KxkWqK6w2sFyGPGHt1Cn3)7rpXGiPF6PV3JbjbryxyVjOl9T1cit6PwTmn0RY9ZBI(FDRVaDYL5)11hlSRakAyxCVsChZ0qQpdUvQ2)7pbTLCRVy0TUjZYYDVZPPr8Yi4oPmKMsxND1GywRkjja73jhru(rFctiF8h(mc8SUtGptaPQwc9MQQqutwAvZVFlmngF0Tg)m0dYp63arijio6gSZmMsg(DtfjP302Ps9bV)XJE8thFRhJPXG5e)rsRwy3j4RMYVJ3tVcghBlZQy3ZTP4JV)ZFX383steJMdP1xElldwrSTzKh0f8BCDA9sey7ByCP5txzmR6PBmKL7(DJc69lXZkCqKXc)ld2l3vkUHMHWnfw(0E5hNGOH0ESwyeK2I1mTvecBGkwq4OQKCCNNJbJquSJ)IXF6ZPyhkAQrEp3Aalj6PkH01QINA0Xpg0bn6rOZZFi8Nr)TRJkM4R6y)ZDPGBObkMuZYuvzMdFWFhx)owKGmiMTF2GO(n)zPmwSibKx(0gAQUUgzJQYTsV5oHNZLVD8nzwXgF0dtJRILUa59vnnaw)emaUP8UggcQeyOW21P6uL9bF7Ot(mgto5CktRhR35ULRH1ym5CC0xd)wvrk97(ItV11Pmbn(zpF07)qAgalerbjGGbBPacuwrtl39DnetGMTwMekoVUvJjC94VxKlaqm6NHBD3p7nLzDLPRYovy3YsoqqKUQkvX3E6Dzg(bRNJ(67m6bhn63FpAKWbQer2nMQilB70AfnmSLxJa)O2d3ZRrh)MxD)2Hjbcry7uLeMQos7LUqq5AMZJABmDw)XJh)(pgZS49ofPj(9deKeWYml3c2PQkmsDk1eIqW10QYewIjT43aJWzKXmD)mQkiXmBZSlUQ)OxCLwp1iza7unfwqGb)y1uGUhpmoycLf2PklWkNwM7sdG1PY86(3g)PCBqp8UWKHNxoBWNlY9cBNmuiZmktTnCR05Lrp67z(jYt7N05fS3e0ZOKawuKlWw2v6A0t(kiAMrp8JXyA(WVGwLp9gCSh7oTRxPAjmHyXEnRdYrnJuGPG70YWYYrV6K18KVMIzLm(d8ppIZ8alR4l1ae8z1hyy)ArFqx)4Kxk9bDcrTb(7bgXXIxwOaWjJxcUwM)OvauqU3jvUhCKsxYwyO4uvY(h)zFmZTW0Czm(ZprMTzhw2(DmZmawg)emawzvMB9AzXRzu4l3IhEpYtNrqQEZLRD2zKO1sDFb9WSQGDWDDhw0aNKeA60vP4eCYQMWiDNG1Qud047)jO4f6i34hEVrh9fa8hNM7mMKMBgOBP9AsjKMdJBZnJwcvzeuGHnxWr(Q0sFhwMRba)3VjWh8ItEpg41HacSOBDYAUP6j00LB08poFvWJT7(fDvXnvJbehRAQ5siCKQ2YCieqiANpLzg70F31XDYsyla7obF9m2z0vFTANXnvK3wtQQgOH62ovL5J)oFP9jNGza5bFmZKpBeyaGgbzq(Q0JYMBIQOo)27m6)1pC6XxNLEOV5Orp7Z4cawQwelQBwbEzMV)XjW)Zq11CNIGGV1CPRE1e(l1a8e(eJfAfwQrUyjdPAq)vN(Rg9xv6VkSALsw(QtCDgYV56ff1fw4t0vbpD9u0bVMp7g4bUE0k9WscogoikOvyt864H72i7TabEK1Jc8VkEaM4)sIFdQc7WIjJx3Y(TAH35g4nck7Lsw)EGom88HjVsbXJMCMUiEoEIWY840dXx(tMGI8wBwCx(QyM9vAWG2(XbPJAyC6HVpd0P39hvCUI4hGeQxPaKFAqSbh)CaTwk2wogwkItTdbD8yvK50mM7sdQarrCLGIL4lV8Q5VN0yk7HgK02lgFJriUj9NGSs3oFZ5TqwkjipZIZeeUmhIH9WcPoSzXXmwEZ9vVhV04Y0j6oRsC5pWNMQUuLgYlSWQBp7cNmcp6Av3yQwoyNXMQBSMwMZY9CJjdWZnkmaTM3Emj)Oy8DvM4N4u1xc65)WsozhCQxgYPb)yyMvdbDumR69Cc7Y8KUGilLulpkavJd0wQmVRnSdu3l7IZpPSVZ5kVgNZThweJdyx)VOQOgh4XUbMPxYKYZcY8QOkRM4Y1HL7gsOWkw2EpHCd7e(zabP4Ocos6QRyR7QXpuKfHexbULk4rRPIc(ht2TdjQaFcDDKooPEAWpVmhi5PDK1xi9MDt(AbWSa3lZcKaU5(P8WsCP9kUH4exzVMLdr0m(SntKE5exW0wwACjl(06AdXpvLzQPqitpoMa5xXsv1whCZ1wty)usBLwnTlt8DMR4tm05y9KJqjx9Ot)(3iw8QnDcGlCiW0WwXWftESLTg7i5wg)0CyxnRfGCcOz6700Yur7ZRiOIgN3eqvysrvsZfMKZeW80JYy5tVfrMIWzwEPsLlE1SemD9PIBqnHFpwV062rnT(xBVchP4PRBVDys8C0ykN04zS0FUS6Yq8sTtptSzETrs1LCDmdiLylBMtbClOYpgtR5MVcMHzkCEPwSMFQ)lRzB)gX9JM8nbvPDWmJisj6lTnCDCv1vmT1nuNUnp5BTahkOb2jKj3joT4HfImlZF1TbMkWd8jRH4lGAXT0FHJqtcovk(MsR4rQjBqr5p2PYBh2CJN4KbnhNI20JxeDOCeOZeNN2mOuounnAyIaYuCu4k4AI3ebquGIRgEXlXeX19Qw6Rua2fLXYRS6IxEDbqf3MA8RXLsFXBteay63Sn(kEeZjadvqlSUi3J4ug)V0Fyup)ozpA0WhAcUpKmmbAa)1wg7Dv40DZPQRWwh5j1ew(ehFEXjBJ96ee3m5IYo73gwBr9N0ldTE9ORiSf)fIRBe859yV0htYaUb4zDEcyLca8fHtDX9tudjTQL)bBxxZsEFg3dV(883JEPY1Sv23We5FJliotCIxBM8Z7n9YWdpT)iTAy3ESdzj7kfGF8btnPPIU6kpuH41tqqV4WRfCg8q2XGhEsf5Vke4)iNhv2wPYkuTycDUEk2eudE)EehA6bvtCsPXRQcGjwkCwalAKzKBuY42iDuBu6y2OWfSAbcgoUDd8M8DpbMuc2RbdW0tO8uDZVwnIz3WkSBWrAXQW1TrIyfTvXLiqlf)KloR56sVQZ1e5rIheazVD)qDy7f0LoiHXEQ4Hjk9o31tMapboakzA6fCn6TBQ891)KnN)UXGoz60BefQduNt7fBWrtS07us0bh21og9gZTntDaRKrYaeIUN9DitzJF3bDgYVFmeNhAW7l2l0q69(c)SZduJb494qRLxLLkBxABfmzx1G8FJFzxcKOOdKxY197Tf)WAsdAm7e5Jh(psDUIRnEOoQ7V7UHVdlKMOHSUud3)k(6a9GvbVYDDWKT6yzGNlu2TPtI8gCr2nk3mDd5WjZfa9pkCv3g3iSYXvvf89KqgKTMTJ2cUkUtGEylXQiip(rNtekt72fWtT5bpnq88a6v1rxWstBAZOkfp1CaExx8feSFeg8HM80NwcyvMxW6Gx1wofGA(5TMIJTjUulN38o9AAXrfpxftHrcpaXzzKSvX3Pe62UadfefRZuyKCDTWSfuCHYG)6t)vhPZrsvNglLgGHw6ziQtIIY2iXrXte3I6)eIFg6ok47G0zHFI2KIF8NWOKwLYY)kIOtJLx3qXvXyMmNY2KIN8NWfnj1DwVk4PsE1DU66gtHlfPt55snTvWKRao8B4ynnUuDnlx7j5svDDL3Qj)OWzDanWxpcLHZ2OqFwC20e8phMJAGkAtfh1YXzOB2UgLGZ8IFt5hnsRIN1IPWq4QyvqvTR6cMMtQQgAOIArn1VAIv5POyLhmnKdvrMZONHlEzUOOOPOI30ktZONTTQBj6Q0F15C1MFvbGDr7QufiAtQig)jCLQKQGxnDwc7uA6su1DAkTS0nQsPQOnzuAXEchtnFL99rz(jP4fyjUNIZcrfTjfr5pjrCjVXE7dLp6t5R2E05pUhUi6Rz(pRO)pRzC4oAAN1q7S6kV7I8xBrhUdc)ZE4ocVAqMJsA)5dsohJKa(6VwVD7)gV5H7Skg35)KeeKRsOY6s6)frxDRZVi22O3k9AD4o0TSDa8H39WDAIx2bqKThUts7Gd3H7(mEQuOUC4o(j8Fka7A)D5FdiRlqEjv2yseJLzo6UAyVW42bTq8ggpMR30f1g9s18WD(VcqmAi7DkErGP58U)xX)7WDyW8)cm35Wd6i(F0lzYs6gnV3chHZ1jWV3WbYP9ceZsjDzjaPwgcFXxqBUAaSmr3)HNL(UQc9p4vjYZoA8F6e5rv4lV)Oh(m2VXQ(sQu6XkM8j0nryUbt39SkkZg)ClTlZl(n63Fp8Oz8(pE0N)WPHuOKr(HW8SgwZgRuvlTpZnAL5ugmv0QOqGUYznnQaT0lTpZnAD7RJeS)mEOwOQr5fF)1Xllq8WOGv)fvXLtbBlY(RzEwDN3DJENRnidfaS)xSFRamXPjVXBsxheL1C(DD0f)fBDH1o3YxU25xzJA4BeIn3Ig34Geu(mgq6U(xnqeGltecJVNKG2fIGny2cy0V2kGU)P7ZcML)MPLAIkR3KygiCZUl3Wl09m)kprrSODr9Cfh7Si4(Td65HxBC5Xa(BOakzIzhFzdiuVfwUn0R)kPIOSTH(JyTKVq(lHH6SLSoj)X1AHngVg(OcbQKLIvW3FQqJE7n2C9LP3khRq3bvBMz9yG)bD673s9ScIc)bANLJw8VRFwSmxvTlzGuKd05UWIRV(kWsU3f3y5vyJcljpz6Kck)RPxIPdDB8fIfExxuw7NhthS7)bLs6V2pXMo0ulFqF1SDOP9sdn51Y6((WFc7btiYjXfyE9mb0uQ2uKMrP9BMQV0mlTpvQ(YHRv6Or38i2hVX7n6ZVpPysZQimnpRQzf4HDP9zoXdul6xEZrp5UuDop(dUZeO0e80GIA7kqj3s7ZCIstCSfkIs6fz71CQ0YSUAP9zEPszkr3jWMICWA6NvvFQgt01lT5)dKXK5XyrvgCE9BmXjNTeXYtbBiA4buu3O0vGx)2q0nNCGumQWgIEovakwN1uhvioHnehf3fCW7hjD7s7WCzeX1LUWkkR))0Aer3T8b9vZiIHsjqBou7BOwA)krrcm(96lNCGzNK(CmAb6ANOmWm3HLC3Np(VCZrcnl39OtVXnXZtneTYJEkDTtua6QOtcZuBNHrP9zUXOp9X4jC4H3Joi9J(ZpwQeEcKZSWazyEwt3kqoRs7ZC73)38C8uZHhW)sXOIId6oWSVcmYP0(m3yee02dUZuqNIm66wySxtX6GyBCLVm3cBrPCHYsNFZ2f3A5GoGRpbEd87f0HFTyl31CS9IYCtup(T9JUwqmQqDx8fTo81eEF45brCbrJJl6GJC)O5PTj)4tdevSoystO9SC3WOy6USSo7Ajx8cTqag27YXGM8xs3zQzK87Tn7f4pEXLlEZqNETEZsPu3(T6tjFjEydp5B(dw2N6hf(lXcaPtD8fexdrBOM03dr7Pwz5g0fWP4fLhTpJcGegVEAL3jFZZfglVFY5QhOKBHVEVyV9fYHA)dWl1AkBz0R2y02T4TyCE(s2D9pBRa1vSvZSeND)PZ9szT89VoTkiKmaBU4AlNJRHyQa(SQ4yOcaPf7TZHO4xs56L8886BIx1Nsgk23FRGd4zwuK85nA8Ve0emMYlOi2ltjuUQ(Ye3mZ42kWyF4oR1RfyMU1q61bdbpbC3G9slmnXLPdC2HP(WgBHtqenkFGwSJe2GpeqxdX3w2LcKAuN5JMCPv((FezY3()h"

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

	print("[asMOD] 재사용 대기시간을 보이게 합니다.");
	SetCVar("countdownForCooldowns", "1");

	print("[asMOD] 주문 경보 투명도 설정");
	SetCVar("spellActivationOverlayOpacity", 0.5);

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
				["DisableMusic"] = false,
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
				["NPIconTimerEnabled"] = true,
				["LatencyThreshold"] = 250,
				["ShowGuildMessagesPlus"] = false,
				["LFDEnhance"] = true,
				["LogCurrentMythicRaids"] = true,
				["DontPlayPrivateAuraSound"] = false,
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
				["NPIconTextFont"] = "standardFont",
				["EventSoundPullTimer"] = "None",
				["NPIconTimerFontStyle"] = "None",
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
				["ShowBerserkWarnings"] = true,
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
				["NPIconTextFontSize"] = 10,
				["EventSoundMusic"] = "None",
				["GroupOptionsExcludePAura"] = false,
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
				["CoreSavedRevision"] = 20240402112844,
				["RangeFrameX"] = -229.7040557861328,
				["NPIconGrowthDirection"] = "CENTER",
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
				["NPIconTextEnabled"] = true,
				["SpecialWarningX"] = 0,
				["DontShowPT2"] = false,
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
				["NPIconTimerFont"] = "standardFont",
				["AFKHealthWarning2"] = false,
				["SpecialWarningVibrate1"] = false,
				["EventSoundEngage2"] = "None",
				["InfoFrameY"] = 18.01542472839356,
				["SpecialWarningSound"] = 569200,
				["WarningIconRight"] = false,
				["UseSoundChannel"] = "Master",
				["ShowRespawn"] = true,
				["HideMovieNonInstanceAnywhere"] = false,
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
				["GUIX"] = -92.32605743408203,
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
				["WarningDuration2"] = 1.5,
				["NPIconAnchorPoint"] = "TOP",
				["DontPlaySpecialWarningSound"] = false,
				["InfoFrameLocked"] = true,
				["NPIconTextMaxLen"] = 7,
				["NPIconSize"] = 30,
				["DontShowNameplateIconsCD"] = true,
				["RangeFrameRadarPoint"] = "BOTTOMRIGHT",
				["DontShowInfoFrame"] = true,
				["NPIconTimerFontSize"] = 18,
				["NPIconYOffset"] = 0,
				["AlwaysPlayVoice"] = false,
				["MovieFilter2"] = "Never",
				["WarningX"] = 0,
				["ArrowPoint"] = "TOP",
				["DontRestoreRange"] = false,
				["RoleSpecAlert"] = true,
				["SpecialWarningFlashCount3"] = 3,
				["SpecialWarningFlash1"] = true,
				["WhisperStats"] = false,
				["SilentMode"] = false,
				["SpecialWarningVibrate3"] = true,
				["FilterTInterruptCooldown"] = true,
				["SpecialWarningFlashAlph5"] = 0.5,
				["SpecialWarningDuration2"] = 1.5,
				["DontShowTimersWithNameplates"] = true,
				["EventSoundMusicCombined"] = false,
				["ShowEngageMessage"] = false,
				["RangeFrameSound1"] = "none",
				["FilterTTargetFocus"] = true,
				["WarningFontSize"] = 16.47568893432617,
				["EventSoundVictory2"] = "Interface\\AddOns\\DBM-Core\\sounds\\Victory\\SmoothMcGroove_Fanfare.ogg",
				["AutoExpandSpellGroups"] = false,
				["LastRevision"] = 0,
				["GUIPoint"] = "CENTER",
				["SettingsMessageShown"] = true,
				["WarningFont"] = "standardFont",
				["AdvancedAutologBosses"] = false,
				["AutoAcceptGuildInvite"] = false,
				["FilterTrashWarnings2"] = true,
				["DontSetIcons"] = false,
				["SpecialWarningFont"] = "standardFont",
				["AutologBosses"] = false,
				["CountdownVoice"] = "Corsica",
				["SpamSpecRoleswitch"] = false,
				["DontShowSpecialWarningText"] = false,
				["CountdownVoice3"] = "Smooth",
				["DisableStatusWhisper"] = false,
				["NPIconSpacing"] = 0,
				["AutoRespond"] = true,
				["EventDungMusicMythicFilter"] = false,
				["GUIY"] = -30.34099960327148,
				["RangeFrameFrames"] = "radar",
				["WarningPoint"] = "CENTER",
				["DontShowEventTimers"] = false,
				["SpecialWarningIcon"] = true,
				["InfoFrameFont"] = "standardFont",
				["DontSendBossGUIDs"] = true,
				["GroupOptionsBySpell"] = true,
				["FilterTankSpec"] = true,
				["HideTooltips"] = false,
				["EventSoundWipe"] = "None",
				["RLReadyCheckSound"] = true,
				["SpecialWarningFlashDura5"] = 1,
				["DontShowTargetAnnouncements"] = true,
				["InfoFrameLines"] = 0,
				["ArrowPosY"] = -150,
				["SpecialWarningFlashDura1"] = 0.3,
				["DontShowSpecialWarningFlash"] = false,
				["SpecialWarningFlashCount5"] = 3,
				["AutoReplySound"] = true,
				["WorldBossNearAlert"] = false,
				["OverrideBossTimer"] = false,
				["SpecialWarningVibrate5"] = true,
				["DebugSound"] = true,
				["AutoAcceptFriendInvite"] = false,
				["ShowWAKeys"] = true,
				["SpecialWarningFlashCount1"] = 1,
				["PullVoice"] = "Corsica",
				["SpecialWarningSound5"] = 554236,
				["DontSendYells"] = false,
				["SpamSpecRoleinterrupt"] = false,
				["SpecialWarningFlash2"] = true,
				["NPIconTextFontStyle"] = "None",
				["SpecialWarningFlash3"] = true,
				["SpamSpecRoletaunt"] = false,
				["Enabled"] = true,
				["SpecialWarningSound2"] = 543587,
				["InfoFrameFontSize"] = 12,
				["DontRestoreIcons"] = false,
				["RangeFrameUpdates"] = "Average",
				["DontShowUserTimers"] = false,
				["RaidWarningSound"] = 566558,
				["HideMovieDuringFight"] = true,
				["StripServerName"] = true,
				["FilterDispel"] = true,
				["FilterCrowdControl"] = true,
				["HideMovieOnlyAfterSeen"] = true,
				["HideMovieInstanceAnywhere"] = true,
				["AFKHealthWarning"] = false,
				["ChosenVoicePack2"] = "None",
				["DisableAmbiance"] = false,
			},
		}
		DBM_MinimapIcon = {
			["minimapPos"] = 249.9876931591084,
			["showInCompartment"] = true,
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
