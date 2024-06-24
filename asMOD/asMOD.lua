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
"1 39 0 0 0 0 6 MultiBarBottomLeft 0.0 -4.0 -1 ##$$%/&%'%)#+#,$ 0 1 1 7 7 UIParent 0.0 45.0 -1 ##$$%/&%'%(#,$ 0 2 0 8 2 MultiBarBottomLeft 0.0 4.0 -1 ##$$%/&%'%(#,# 0 3 1 5 5 UIParent -5.0 -77.0 -1 #$$$%/&%'%(#,$ 0 4 1 5 5 UIParent -5.0 -77.0 -1 #$$$%/&%'%(#,$ 0 5 0 0 0 UIParent 1111.9 -439.8 -1 ##$'%/&%'%(#,# 0 6 0 5 5 UIParent -1172.2 -470.0 -1 ##$&%/&$'%(%,# 0 7 0 3 3 UIParent 1172.2 -470.2 -1 ##$&%/&$'%(%,# 0 10 1 7 7 UIParent 0.0 45.0 -1 ##$$&%'% 0 11 1 7 7 UIParent 0.0 45.0 -1 ##$$&%'%,# 0 12 1 7 7 UIParent 0.0 45.0 -1 ##$$&%'% 1 -1 0 4 4 UIParent 0.0 -301.8 -1 ##$#%# 2 -1 1 2 2 UIParent 0.0 0.0 -1 ##$#%( 3 0 0 0 0 UIParent 576.2 -689.0 -1 $#3# 3 1 0 0 0 UIParent 1013.2 -689.0 -1 %#3# 3 2 0 0 2 TargetFrame -31.5 -4.0 -1 %#&#3# 3 3 0 0 0 UIParent 339.2 -356.0 -1 '$(#)#-S.5/#1$3# 3 4 0 0 0 UIParent -0.0 -526.0 -1 ,$-=.-/#0#1#2( 3 5 0 2 2 UIParent -324.2 -374.0 -1 &$*$3# 3 6 0 2 2 UIParent -312.2 -376.0 -1 -#.#/#4& 3 7 0 0 0 UIParent 559.2 -779.0 -1 3# 4 -1 0 4 4 UIParent 0.0 -326.2 -1 # 5 -1 0 3 5 ChatFrame1 29.0 38.1 -1 # 6 0 1 2 2 UIParent -255.0 -10.0 -1 ##$#%#&.(()( 6 1 1 2 2 UIParent -270.0 -155.0 -1 ##$#%#'+(()( 7 -1 0 1 1 UIParent -7.0 -794.0 -1 # 8 -1 0 6 6 UIParent 35.0 50.0 -1 #'$A%$&7 9 -1 1 7 7 UIParent 0.0 45.0 -1 # 10 -1 1 0 0 UIParent 16.0 -116.0 -1 # 11 -1 0 5 5 UIParent -272.2 -380.9 -1 # 12 -1 1 2 2 UIParent -110.0 -275.0 -1 #K$# 13 -1 1 8 8 MicroButtonAndBagsBar 0.0 0.0 -1 ##$#%)&- 14 -1 1 2 2 MicroButtonAndBagsBar 0.0 10.0 -1 ##$#%( 15 0 0 2 0 BuffFrame -4.0 0.0 -1 # 15 1 0 2 8 MainStatusTrackingBarContainer 0.0 -4.0 -1 # 16 -1 1 5 5 UIParent 0.0 0.0 -1 #( 17 -1 1 1 1 UIParent 0.0 -100.0 -1 ## 18 -1 1 5 5 UIParent 0.0 0.0 -1 #- 19 -1 0 0 6 EncounterBar 0.0 -4.0 -1 ##"

local detailsprofile =
"T33AZTXrsc(R5IZEUrC7Q63kI9dKIKYkmfOobQX3eHd2SbqtcmcV2gnenNZddzlAVASLxBpR0y6XsEPd)q27QnoAzzpsXkVZ)hbW)dxMzvv)cnqdjlfXDrSENLIeOEKv(oZkRQ2KT5gBwTFyVTB1oa)1bn7TRNFyqxFVWETd8AvVx3nRTz1Hdc8cd8Bh1QtqJ(dWpkeA52(nG20f6zf2MvHFPcFZkAlW3mcgQiOdDcc9GHy7w7GJ(2(dIGpyy)g(rb0G8pmSv9l71iikOEulXufgmiiYBq)G6E19R3ma)SU988Bhegr9PrRb(1ayRZErnBv3RXWU7eKaL(DB1Xhhlp)61dAV5siS0DiaiTQ732BWEai0bHtQ1dQdlZ2IPTFVWiVMWI0RDRUxMMQDB1TrVDhiwN9ggjxO4VLAL2PfmNd7417kbH(TBdl4o18J8qCf0CTnRgCLGUWFh6x)YbHiIaWVWkObofB3d(Q69A3lum44)Jt)uN(Pb(ZijLbG2DBa4ZiaQ96FLo4aaaBqMbqBbMe6edc9Vg4)QJdenHdA6dlSnRwz9kRO(Ow)Ej4s)52(1d2S6QHT(97V1)ZH(nc9J83FRn2qoHndATttalWSkg06di(QBhcmaXSvrTIaMSLiodyW2S6AR)ABwTgGuAe2RF(LGLAnyPwewYvHHnUmA3dqMegubk6AAifRrutORMAuJqqnk4nIggclMLdI8B1EW(Bvna4WBfThqj7JSkabwcPryVKScr982TzVnRIm2dI87wpyG3GGD6a0YbEYPhwn1Bh4d80D3jS3W(Ipc5Saoay5IFy3gq3cbEdV((HWVHWC)bE(1QfgCLweVkUeRUBVW2numpTgG8ldAsdhjVGIeWWVQJHLLTLn3221Hz5AT52NYe6DTE9UCh)WltlxfXe4vtKhO(7bmRWaFfqYarLMtkBa)tNA9Apa66WOEOqBd1CJubOhnc8JAcONEG6G(WxbZ6ecltrPqcMeqJd9Q3gf)beDV(bKeCSieHu7gSB9MWFgas4iIaLO8I2RFaj)cifFQHDh2hOh7GsL1spfGwJ2TQjal8BikuRU741ShWwdSQWAEh)(aWfRd0BaGA863BaoDnc22Fy7iVA7aAF630hxfWYNOlOwT6avPl8)tkLc6UhOnPxiOxkyWa)De63qqPHFiWbC5wDtR8c5FumnE1ggfbCH43NJCbmg6QpmT2k1WGkzJQ3e4F71HOi18dfAZe6Q9aL1aaf9mR2rylq1XLkv9HdOomJEzVut6a)o9rGMAQUu)aiCefbuLbLOOOFpGZDZQBS(fGVayxdi2lP8oj7V3MvofdvG9gejTynlcUrHofPcfEk9jlLOpHNOUC6kdjPTEBVnSiegveYQaOcI8(TfADlwntNGo9c3Zd(OnRyzq8vaprlueSDakGI6jUsFp)bEeBcXskP7cMAXNlmkMrMuHvmjT5H1bZIG91RaQ8iRsk9ZP0RnSFFWWRsPdI(Q32h(B0ba4R7asHBw9C4QcXfV(InASE3bVUuJ6RdSNad)RtDjiU5QvTucCJu0TOcum5)gkftagRFB)9anMnetqrdrvsKQ6kTVYLohsSdtu0x9Y7HA(XzjwLHhiZVtRUijHNIQsCDOUObfsFJeAb9gSRFFupvJ9663byUL6PiMuLjb)oGUEGlWarEilNxT9K(sfbEcLbHl4gHP2Ju2Sb6ItiG1WFBVnx9u2mhDBDnhxUUbJB4ak5nmqg7vTCDzmxxthhntBnh6BqJhGHbgNzP5yzRB54AbceW3aQRAU5Q2CxDhBnBltUHHbZs8nOtfaykMseP8gcjkP0eAfvttWQsILaOhnCGubdP(wYCqIZAl4Wr0ni6I0cShDJBiSMBglcYvYGvh0QbPkhMbqhBijlIlMTh2UDTEHnaga1GJlKwcNWaXnPvsC8LyAPg0zQltQFKaBpYJ3s5Ot3LbE8yfFapqiWn0AaYNM2BaYfuKJXVDRD661bSF0Yd52aDzKsULqA(UGmnAYtQsn1YvH2ilJrnb57DAQuStaXeFj43f9HXO(z5VdatKjku0gNleNs6zApeeoifn7clRqP74KbCeB1iyaq8bXcHI8u)jziNi0zrjkAR0TaVe5wWXOWwabteDHIclPVQaouiEXWWYGKMT(CMq3Am7zSPBxoXMvJyZa5NuwiMeLDwYXnj7vIxPCW)hPFPm7ypt5UgstjU0Sl4u7I(iGJCSWEktHT6cAqgq4EWmXqYZBuydg85SH6ZBdnM3gAoVn0AEBO982qN5THUZBdb)aM3wo30g2CtCyZn1Hn3Kh28sFIebNlILxzLf7l(hGzoW)8yJZjoJelWmDVcf6P3HeG0n5KvxWfbemKkgu(Jk0hNi9kSvFEmqzqX4GOw1HpB3wytB4JQAdfoL2UDpqFXo5wOOIGzcvKxyZQfsh5KkHfXi1UvNwj(UDk0XrjiHjbqbrz7exzkRITXKFRE83QBr0aW6VFEn7cBPaIbrE0hKbpaOZ0w3sRPpjsMQKP4L8dRcom1aXw1dqlzGcSv2yXZTwvVQBS4gxQ6slErVlS2Lo75Q4DM1w)mVkauKVTtVzxy5lunnZrjTCJy)F2qfwgIiwL8xEX61HLjgM1(BDbW7s8pQVNOflIMhjp9qp0eDMj(QQXjIa)RZuAmkZC5uDLZE(vQSXVyaL9cgqfKNFPqj)5cuIrdfS9CHwLEvbXCq(W65xRv7wrTahCrslg8xqh5FLrjJacwcbGLWVCjC6xcnbTeAEbLk6Jl6kNIJsm(c((ujqqPHjJNLNIBlxsqlrDJQuRKxq1q1VvnSSCz2UCnltlWNaBmBkgOlAjU055nORF)xHueLktaws1FdWCfL1LjHNmDJteOICKtJqIRTzeZB1v0VEDBVxY8tkQj96T6Un50oUqUi6qmfRdHYcQpN(1snvOUxg4bnCRLE4W5sODKuee1tKPeHge83iMeks7EaTOd(Rr5alzOGlLB4Z)XcD9E1hoicZJb6ZeQ8T1Ba(xwQUD1qlvKlz092l3ha(35Ho8jtjNi8wX4ksudqg93gZpn5d6sPcsuIuxf5IEDiOi(cBSXQyMXisEIBSznMOMu5QkpHjX9ts)D5PIzsNubdalr8s7VfpJbtzYy4jyN0O2Q)VXuNX(dlS)w0VP)hO)H)hYMkhGHTFqyDk11PvOKJkopUJl6geEF3bG6HycCCMwsHTMp(x0JGM7H5wtgGsg0VM0kBAcef(n2si2NlJj1fdHhIujxENTLU3Bl9T3w4yFcJnnWi6AsvyrY9uiw2kEoNVfvU0Nq9CNqiykk0PAkiOyHfX3vJ2JbaqEP88F4sEA7UtIGg1(PspJPK0a1DyNAGlhWAuQtmM)iLS1GeyRiwW936LK8E)6yMX)BVCr86VIKApPOCQgT8)9w1Jg2bg1WaY34xo)IlTgGzX3UQPbJBAAQBzR7ORPtPzNYzIIVzsquo7fQUzUzRn8KGEYW0eKsAl8BlzawnSvq3gdwfZO4RFPZDk5FVg4C9PELKoir9fsqEQfJ72lMLHyoLYBz7tCsJJzXkq3yQSQol3Ai2X0W(skhd2Oydrbr7ge0vcU42n61FGC)gtw3dc67hc2xdvjWUtVgbTjJCd7dQ88O)g8YUFqBG2SiaFlfs5xf((GWZgctXcNNJ5mE3Kw)A42386R8)6clwP65wVIg)1xE91xEXLR(6Gpxn8dd9F9ZS(AlV4fV4IGVExQ6cD4Q5l9UligZu6YfFqCtyQoL0KO4CoK4ZHQ95sIoXmgG8(HDZnnX7uIifKgMU6AwmldhllUjhZZOLTk16YCXV06BSX6N)IN7SVsUC7gNQWyNvIHFD7u)xS0KGhAvlnndBxxtnDMf4rMPWBmGVAAFJ(0(gvuWP83AoyWfUA9BYL3sVgyOBsBZI9L8uK)SyuTPvVkcKdfMqE)bs3j2Tv)aX2p5xdZke6ivTCXAMnQp5xbo6sBSgLpX6ddbPQisDBCc0KzxQAQ9Nj2z5QXbFNEhbbEUS6H7c6p(dXB8cUF9K0RY3Ssest3T27cMQI738S3sP9DNTarOfzdozyXXRydEPM6A7iS(McVLfHsyqscHYw5gsvg1ukrQnPeeLv0EdAv3V3)pF65f8QKew2eNaHqe4FfbxGi1VQKoq(NaHUH43EDfjpqk7MNlodkzx4Z773FI9tmJC8m8GTEpqymJqilZEXzNIXOk5gK0jXvD04MAChhMTJHfN23BdlKqsBzepLkgt12cUQHRTJPlZXgcXZKRziOtuqR4M)I7LXeiS9WfC8gUr27sz29CNz9kvF9Zv534bi0wT92a3l5oZY)9iX2qjtoVYLxhz0JfKWD0hYc33G8z4pNRR84nAx46kxIsDub1NDZ1L7byyqh4ZPI7PJyBKrnceBr(9IVwVbIewvqY8Wgh2suPaTB3QbbW197tWjo4iIg11jmHdTPoyDg)JoTguN8Ng1Snm0xiXheUdf8RiRycX7ufGKuBJuxvTKAWjtT3ygV7dGteD6RYsGtkL)Cb75PygtIHsQPa5w1crOhaQDA3GsQq929gcwsfRXeyfu)C5GUEOtC4gH3DhcLr7CVAp9bMvaDQ2exsZ8gjrdXmDs2xBg5qv9M4AcmFeaUC3ihp7EPJ75nYehm0dIAIgNaijEJJfk8Ae43awJEu5jH5OHNPMheCxadKMRbJwUyWnnBf0UHCxOeoMbc0KVtVYLQSXkxmRb2faNOJ3Let1(Ttk3EnWtOZT(uBVSTmrJR(klE(fRKAFyuBddO8vZWYXEAZY5x8SRuE3YozxyLnMJzs3wntuNw(Ix6Clh3nDBMMl1cQVgag0qZQ4125xVYRMieR6IULB6USq86chvk3ClUXR8QviFVkayNw3wPYkN)3ovAuU10fwCTfx(CvMAZZp4xQYRwb8YCY1Y0qAx4INBLQjWFkumplwSqA7fx)SxAL5SZzr5lcQOWSio1oRbgyCSbd7fc2aRRmDTZd1Ec4E5vasEwPff5wxoetdd)kORSZ78MdQVuLZEX1V0fUWAl(BtnXLtKw53S(RMQdGJ2UIjH620zQRolTbzNJylYzlkoEsbVaALJ3A5K9bPzVizKmGt1KlDBi8JtOGRwyp)g1ffDAkfMzIOCcfxlyPYbKJUeynksH1c2okuGQoln0NuxLI2yiBJJ9eQLmu1RPIDZLmgT4fxPYIE)2vwBTyzQ0EwO4MkMSAOMxfOLxhflMPr2cnJ8kJYmzMUttRJTDm1vby6fO9ybxvjDAQycS1twNN9IRSssBTCSIzlvJQR2es9QfHRAR4nyfPhAchJYR6zIukNxc3urRnv4dB3mBYalNQvGgYy2PJYCbnMRvIVWfPeWsr1yUzML0gK0ZryjCsLvU0gxCX1kIlPajyf(W02kM9W1HyDxzTvJBMJRgchcQaNzQWXIpxuxqX1(egGf470arSgc)NGaE73eCoCjvntsTs4Wj5TxUkad80DNDccvvbMzsfKjktYGgTIkOIRW6YAafLdw5vKJG02LaoZlQV0DjVN61ONyty8B0A4amsETyDfQEDHEdWq44A6G5aDltWGaOeqeOMiAymmWiX(wI)TkX4zkTvvHGbrN0X)nMMBEgMjLRmy9jP0SH2LQQ0Qi8aKcmbRgWTd93zqrLaQydXkSiAJ6fUttP724xikUoY7zzKoQs8pDfdmidUUp851PCDLU(srxXfzxrfyPq5kMd8u(gwXINYGdZ1uNvGDNC2jRWmSStKaZBVzbvJTeT2spLDrZC2rZp0y9HppoEcnKnd3RY3w(mmRMTTWAZjrUpU12tzXXntwDkVuyfddgZRh4qBnNLRJ5BUL1tHJMWGplA3KTof2qN7WMeJmzxCNf8e7FHJS5wtLIprBnTTNL)r5PnPyUlaqY6Ptfth2m4tNyOnMrJZnYClZzGXNOXwZI9BIwNGqIbdNP36zYApbBOL704TNST2AZcqY38uTE6QDYZyX04thPNvAZMnviphoHPPpDItUbLpvg1CShmnJzGOZRWXwFwOUCdDQgxap9eSP6ZF8eauBodajN6ml2CgcbOpWAgYk5jYjYkLfvBLuYGtkwLJJlk15IBQNxmL95TB7VJ4euH)vRUE96QsqZaz5Eiojs4U0nGCis(bdQ3mOJChxtk)g5UvmTDLlFv0baVHY)owCya0VzKePI6ifGEY0hlfekvR5dtRzGp6eWuY8pwxSQQLnXd4u7GRcGOmnjJaN(v9KFnoxM52elXXI4kTg0lCE20bkNQX7rIeLnOoUNEYsXhBTPMTSuaoLUP0jB5AmPm4Z7sUkCr9yGfiz1e1ZufB5oeILUxW(BvfpQqk4rud7ITIilEZopsl7HVZol9jYpChfjkP2QboJxt02xH(N4eSdUI3giHxjquCpYpfDex4PSOCbeoZI5WCynAJgs2caznYqBVR4q7q1zw9ED643THKhgBX0p)mZ)EZjB5mRcgDPxZy6lJBysY7HaPwBTLwF9x91PT2fpYCN6c(7eCkwk6WCW(Gy1vHGdyAA66U22o6MGBIqycUXGPC72mOqaA1bXqDcIA2RrAHwIOLQK5CIPmYnyvwyvjlQepQzaeycrPyY1D4AoCDdJKDl1rNdEdW5gooqqN6AIZiiUBP2w2gmDdMTTUPfZvxuwdubpObUiXSnmD1466qGNY9rvWjLG9v7Gt1lkkQEgQ6U6AKGQn54gewDQ)yPunlkZsjTQiNCPaXj1zZkk)XBAwNWbvyrIJrCsqr0PfSwyVll5HWCItvRtq7TtkdSKG4uJdTPnX1trTKSMtLpSq9Ta6WpmjPsncQnC7T3SA)HH9Xs)q8xdA1(kyz6UnvTgT3B7w4YOHF4L7f6JNYrXEKuDhuFekj1RnT5Zv3laln649dbme0qGz2PDVA(llQhjjGeguxeaSOuJLrWHWEM9jg(U2T2oWtwKxIW6AhCfQ8kfBGIqzXa6iAsr37LCKEJpph4UKkRW8iHGQ8CJjp)2qJh)5F9OV427V1O784XV7no5TUhOzKzYWC7uD8DV64d)6r3)XJ(MhV)wJF0dg)5Fe0ovla9jp5()8t(Hdo5who69Uj0I7)VdD5jp8y4xHU(EFf0LrF9dvThihJV9pEYT(UX3)bJVZHWCE83P(odesEVt(8BaD99)Qt(KdH2O(otz5BfIh92((qq1O(ZH9r7TIAbp4n67Qffq7JeGPBhefilABVnoZ6lj2JQwD6isjezSe3UFCtCPiUfBAnU9jQnjlgbLyQF3MbihXzV05wB50J2qG7MIQULF7KIlJsOcEqIWO8tNyuX25nyVU1LhkPWZq7EUOKweZibeE4HyDhCZTAJNjFyoqwbQOAe)Dq36ObauLg1((aljD06hG5MWMzdkl4Am5WbRjX(m3qmhs8JC7VIbxXgpsl4eBUSKA3f9hsUp0j3EajCCzpV6KsfWWhIXtPnLoByIZsDdpskPnM0fh30OvfgfrVYZ8libHsYOCyRU70a9jRd4BMyNgRyG79EOpmKYAaCQiY)HHbH7jQwg6yF7LQO6f7VjDkc3UTSAneCg4hrQaQfR2RaOHWcQdyBcGiY9I4eEIP4HCSYvuf)j5TTcJByzSGTRvsoTRWHyUDwq3WrLG1kgww6WNG4lkB1RcggS5oAAmddMPHlAUbpMdYePcwwymgyYrJ7YCC5C8RDsYc8QGHkWCje3jy2rZLkOoD34CtUQf3rxJBt1CNgm8O5uTKeXUQHRgyXcGathlO3MYUNonQRAyB5ybrFAZ5ACUlog62XjKVIURHfMjEtvMWx1eR7cg0fyHRPBziHzkj4RABIvCGLPl0eeULFPAYCWYrGZm1Ca7LAMAIjJ0a2hzbOsliZ5Wo1wqK5ZtknNmFS8iWkDwDI9xEkdMQxXJzMEnLPAAo(KY9RmTpUYDQk4WFJuhNt7uY9YjT4vWt3G80cIs8WZy3kf2kQttL(Qw)y4uGkWWwIYHi5kBq9HyMO9bLnndARUvaabyhTKJIX5QS66EBCPnw)INBX1yIe6gaQrj7YsnP1W1znCzwdxL1sfgcDq33b1cjg21)nRCXfxBTLxCJf9arTkNRYzjSu1ZJNjL1p)slUH3gN78RGtKCVoaCtxWIqDXH2Sq4IlJdikST8kEqu8aPxNV25QS86VMhkC7DPk4)qRMHDPBgb1AxlUAW21pSlE3n0Qblob7uXSrLfNhyC2JulhBVIqgCqPfvJ22ow0)AXOZzc85CXFRzk(xqzc95quVI)w(52I)2HBiRXSITAs7)qIvZISZNy10Yg802XauqjoN7QtJa501sXds3(1H(ovdUxoypWKE35YNmrXYHBXAZwrs5kSaEbA6LBjUsjWLqJCEjuHLw0P6t(RpE8rF8(B9KF4hFY9)oAxqkSYO2fIqWJ2pXkQCzr75uv01Up8tbVVE77nRb41c87dq3samRzRoRRsbxyuo5tpeCj8KB(4tU1d2FRxA0B)PGVHWG(tFhmOVCHJkTI8oV)oTQ7TkAuniCvS6YKhpwzeEto2NC4dp5oFb4e5pD9NC8vlESxKC5ypVQGh(9qgd1zPLsKqHJ6nFm4o8SG0fdR7du2Zdo0DEA)R3tDUBXb1QWb9tV54p5XV80PkdrVEwfzSwfI6OA)wHTIuhsxCuTlAuh)x(UX36MZEHFXM71d(LME)METbWUN6a9IdQtHuSp8DgFW3p7b9myfxJfp2f61AaWmOXvh)xIraI51uGgEZnyGvCDt9tZmW)Ng8)j(n2PzC6hVz0(Bjqpuebq0iJF)7iISx014dmSySzgI8hcJTb4eKnNn7XE0pDW4F62XbOC8pdt3nUXj)tpKMd5qeFuJfZbOysxohCikhn7zpfJ)Kdg9WBm6Opcd45)4EI1XxC8to(Tg923gdN5EWQsiGqJw8XvMKE1C42cr4Xh(wNCigN1DEaijMJcSydWbZjoucuOC(yzK3g1RTDu8bCwSsamOBc2YeCUSKLY1V94RF4j3cJh8NU6j34BflM)YXJV2BPqy4OeF6OJj4opFj4MPgBx70eCnNswchDW4B)Tkc(OV8Bh9Odedp6nPHin3kPvDBBdtZeATHUwjJ(Fga7BaslWV(L)m8RJ(G)nfPf68MIm)PGDiIedfEb89wtRKr)j)WrN8N)AyOFpujUie5)2nrvsFZ9eZIjhmYqZItAmKMcdzAc(qBuc2)d)3p5p9bN8H3dq8GwFbz4ox9KdVTGelgdAsuY0CMHRJcpzYC1TlHkm64Bo6ZVbW1m((4OF9)TrF4nKubURPJyxbus122M6sLX3uWvm6hEaOEF0D)JZVuqT2961qACNg9e5zotxb7wqud6Lie8Kh8XIuy8NFWOVb(3t(l3aKii46K)Y1aZn0crms0mXt0o5AzNqW10DzLYSo6Rre0r3gMnAkGPE81psHRWHytXfEuSmTJzAnGqKtLmhp46yIDo8waA9DE4Op)Wyzdjjrok00KitBJhSQuYDSYuD8OhGkUUZpt)YHKD5tU2vfQD)8)McTbH55AYfBkKAUCb(n9uZLPDjZ1OBEtqN0OV(bJE7dfiTJp4KRHmZiN8dvQBnzgGmVyVQsyK1m5X6QS0kvGh0P)Z3C0X3E0)SGfy01VUuBLPTRRyJpJrA6U6kbE43DzLm4JU7xdA6JPh3tQsmXGHyqOjrjVdSyUIQxQkOT(j)4hPeHh9Opt4)cyi)LLGieuULazNY6SbpnH1SuE0p7Jq2)pbXThFpL6dbc2gcMNWb6XwODTXe99IKXrNLw7nlEUm0DDClzUo(NblZJ(iW(2jh(iyz9KF8EYrN6nn88eEf8yCiv6PBA6wIzTX)0TaFNekkE)Jh9w3qzzWKQ9n8(ItmYq8DCPn)RDNr)RVZOJaL(aPe8flUloeJRUrkB5jwQyyvqzxQNpG8ozlhGkWqvKN8ORDYbpuwA90aqZGzASPBAodlZsMHBCvWZBbn7U3ayFH197E0jVZTvciosMdL0NHMJLdpEkahj0lJGb(4E9V9j3)ybF31oqSUo(yHNdp6qj1JgkAUsegDCnuELa8ooSs0to6)84XFX3lWxKvEKKCpkn0O6EW8TTaH5eVASDTyX6sm01Tl3ThG)4waJ9j35Jg9nhm(G7eBuu6gQEIGQbpXUoo42LA2A0NlPgV7vh)(hHbiDnPVp6afNgFdTyOhyVv4hGydQUkrraiuo(WVc16sIMG1Xp(iH23)6dh9n)JckHlwzyo0mXsO6oSytwoCDnUrP(bb8wIq7(5RPmlo6J)6Fns2)OrF59u634uD9wXiXeSHo385gwdKcf3ttjMFz2wj6eC0m4LWv9H3y8NC8OFaMIhiyNrY)O7(vJ(2hcMuq12hm69eSXIXJMpJeQKUMvSdQMwAwLjX8jho6ORp67oeubn(ZaK4j3(baYeMzyU(x)wWHyPkgASOjlXzBxNK4fm1Cn4LT6i3RHj9AxF0B9yAogFRB8K)Jpy8DLATbtegI0nyKOfGJLUPCAigMYmcFeYmCW1rC2xind)G)iioLINtqNStH34gVaWBPzWJDbhmmjQG6QJF0rNCNpwyc4ZHF8s96U)w71By4(BH7M5lpx(ZgudVleOn1eNgLgbdMJjx5EjhSPuMLvieUXhC7X3fvA()b98tij99hp(VindqdcLtKy1c42mN4GKlMqSsKGataV7hiikaEcML3)2p5husq0aqZal9m48Iygsz4w3GNwjqzXmER3z0)6plC(6wOE)egykEfxr5bQhp(MGU)eNiXmswMzSJHq4iFOEYX)J0UC(KF4hHqWu6XycpeIRquxioVe2xBEz2jh9HhakgPWwEY9LrAzQ5y4sQhJlMuo4nMDShtWQWWPCwO78q0jWVfuGDYBDpqgbCj(K37HYWgVbG7q5)3cMEPepoQ0Sg70TfGb1tmuAAOxMFXxhDj89)k07BHlHxD8rVLYugOLsukOXRkmjkjEU4wQ9figR)mo(JE)RlmMDRBQeBhF7Jas1OF4JtcRxqACs4FnJ9Y3LdHKxw(HaU1JpGOrJ(y5K8EpcxsxxO3xmi0KKkGBMLsvmJbXbAXlxi59r7jF47p(rO)TF4FeI5B8pDtfwt3qCbbQLskXulMQyA7uQ(K3(Wr37bIWtKHCCWjV)vPGKh93UHkjfYXIMmwIidwFOkgpBlZYKyYuOaJVZJFYp89WSC)Rp(Ui749)uyLn6XQqd05oKnM4Y9fSCzBlWFPcNqfz)lzCH5tt8aX1mrTHIn4y7WGU)E8E6ni0yHFx)DYuB7gCdLdvIKo(0ppbHdPnIo3me7ma30wtj9cQUbPQYs1ZnFmgyfHcp8Rg)jpMc9rezq(yntzzlUcmnaIMEIMoDEzCHJo8EO0ZxJHc8EWpg99xnt(dfJrMsw3GdQ)yP5dlnHRuuHNCOkdIqqP)Q(H9Q)Rsy)eX2exA0gCMRRr6ifDl1f0JLzI6hbXuXeDWrqmojHlkszsCbvtZH1lM5WnHT2WqHRa7s2UoLNrX39hhD8Nj4)j)QhF0TgD0JK5n5QJV7vfkHOrltLzduFmNMYveh)RYIi8p9vkfcJF0Jh92I4da)PhDNJaIuyqeijjit6GF0CEMk1gc4HBZtLn25nobmN1h(W4Cz(5)t4My9xHV4L(v4oJ(RE54Cxl0bANOMWYkEgHq8zALXGFYTeoIa2Yh9D3C0NFa5epYHF0TqFgpeeNG5fN2ce9xFQI(I9USr4Wwn8Qf4h2C4oE1A7x)Y72SvuGsvGDIYgtMtSHCxttxU58yFaZe4NEiGEWu0E7tE3VhXr(9cuOiWPbrswStu6yK4jTje9JRPvP5(ftLZFeMJtLeNykDmKSPTzAQo75hvp2UnNKDSt0ZybX38lvpd6p)WbbtOQXorvdEV8eNeydGNQ0CL)9J)ePDUJULYPaavd(fso6y7KcvzMsDSTHBPosn6RFOWD28c8I(tJFk1la9jMwBzxQJA3)BHaYgD0hHHL9EFfrWp5A3E8F(JJz0KlgCSOnFmr5IjeH5lyvzoSuYlMkUyldllh9YZT19)okU9dvjvg9a6tHFvr7Xt1dojP1Myy)cqBsh)brpvAtA3c1L4Vd4kbE0RvQpCs5RIRL5Zb1h50A4KO1a8WtpMtYqZPSDDz8N9rc)xtY5Z4V44X39JItLVJy7wCmtnhwgVyMdR0giSEbqsRh26PJKI1cnDHxsNfHykQDkvd8eVOqVFllYoSSjasz8ElQBRZOqDCsRVXizR85LQkB8D(yuWeDYC8r3E0bFfm(ySVF53sAha3rtshPqa1n1uzXFUPAJ7iyiDtPUHfhJiy70fccPmT)3uShbWq)3UUyd9bNAeoVaHZyrN59kUjQy46X1nWZdVLWlD2DZ7SKBIYgiwEwIDziKQYkfciyxi8TpryV8K)0vXTC8UxvT3tJo6ZauieUGY8doI0uQNY0Mo75QPn3efg28yZbaYv32PSSc93K097FmMDiCV)q3nU9bGQBrw8V(TrLvKh23)iatlMCXyttECAry0hLoHoLHl)GBo6F5Np5WRkYU2pCWOh9zsPilMfXA7Mwhs8or88uhYVcTli9CZuhKGOZ(Ff3yDc6Gnk(l4kzX1j9(h588C)J4CUitpUUPwrgUVqwrOotbBbEt9NSKSypF3smMCoYuEc6VaMJi5bRbVJdhGfHjwgIUy5eYmOFQt)Kt)Kr)utuhLXL2(epNCYNqjvbFIffjDakPlO)249irNapW94gX3cG(qCm9ddA0Qo(GKiJYrCqzWlT7Wa)lJNIg53e5xJQ(wSqtLNPb)gnWlQl8ewkUBYWhhSw49kt8JlhEDiNQlQphVtmt9XjNPXShVjT4lwi1bhvZm9Rpv)M(dcsM1wdsU(Xtn60tTwjhYr5vOh1RKbuEF4zdbN4a2a1STCmS0u3BH0OJh0PuxyTzE2uYHuu3Afy5)lp6fYBucHFeqdIA6naFCVuxMCtGwPZs5CEO7sqbzzwCMaXL6aoTdEilAvp)Coi(CwwTRSSzt1j6v7rD93lxMmxXLAROOJlV9INEWq8Y7S8gtLZL4wgS8gZf8kYZR18cj9XBtyycAmV9ys(r187QnXxjXQpf4Z))w0P4QJ8PbDAiViAtRHGoiLL9K0jo610X5TquD8XeQCyG20Y5L2iUsrFAjoVqzFNtkpxY52flW5(IxqwuvuT98e3ay0Dnz85eBEvuLwtCX6WYCj2NJILU3ti3iUwtnGOIDyqyjU6A26UC1TnuUrsQa3IbblzQPH)WuCKFrf4tORJ0XfRNgIyi1vY80Uc0xi5TTk(2nWmh3RWcKACZ8vzhl113L6sJs94TAw8iIMXNTzIKNN2CM2sJJlG4t01AQVQmZutbrMCh0cOFnlgZwhcvYMRSFgJBJTAAxK47mP4tm1zy9INHcow7t)jsyG8HqCYbx5qGPHTMHlU9iw2CXLsCr8tZHD10waYiGMQVttltjTpRIGsACwtaLbj5vjnxqsgtaZtpkILp5(WFkcNP5LkuU4zZsW01NQEdPu(9y9uRBh106FL8pFxtx3EZwrdMJgtBOcE(R9NlRUcaVq70ZeAMxBK0rtOkMCTcSLnZLaUZRzNJP1CZNbZWcfopveR5h7)0A22V2GEHtEzfxyhmtjIuG(sBdxhxMUMPTUbB628IVy9Cepwf0PNlZPrp)bjKmllF4Nbtf4HbFt5B(AOV69Ap3XRlcxk5FlBZFC7shuu2JKE8LyAM5tDQbNJtyFYrpKoWEkWzIZAFkqkdOMenmHafkoY9S)mXJdnefO6I8rDzCQEWlN4vsE5vwDXlTMAqvVNuYxAJP9m92gFQoQ3eVcmWCciaf0cRlY9OUbc(D9gg21VD6Rnb4xQdUpenmcAG8Y2w8SspD3Ck7r80j(uCdKp1vRH6uVkEANXAOiVSZUnbAlQ)KUVU72LEcrw83QEWfWpVR4Ihjk1W1hVheMySsga8g5SQ6jHPwmUQH)EBwvJh)IU2fFaX83HU32R3qX7o5tQT68YQUzrK3fe0nmfEtGG4QHD6koJ4IRDt5rloXKgdD1n(ahJxz4bDh06kbNcpaUIXdpfZIFRN8lL8OXTnwzfQwmIoZF5BcQbVxxIdn5qSQUffW75sGjow4mhuul1mxRG5TwYSwRW5Kq1PPizry482jq9kXL6TSctkbbOOPNwX34dYhwGbI3ycXLmJ4Txi7doqKII2ipjc0sjpvZZATU0Z6Ank(6Yaeafx)OOoSDc6qhY4bEmmxSjV6OEXjWtbdGsM6EbxHUHDIV2(NS5YB)m6wRaVvveDG6CsVetoAITf8n01FH4HlIEJ0BkuhiQuQudcH3tD1Kw483PF7HdeKx1DLa49L4gxLE56L3Rga2OpEhV0y5vfBhIij0MIxRn53jFU)auu4EXpZV96UH8GCtt6aXT1bEWGr15mnxB8eCv1F7TB9gIqAchk6sfCdtL0b6dwf8k31bt6UJLbEMXfVNij3y2XDJYntNwYXj1tG7Viyv3g331IHvMgE9wLcyRy7WxWvZDcWdBjwcmzHp6S)5gFfL80cNAzGtMPn(IoxeCAJVNcPXPMMq8BUGrvaNAQ5WkgNcDZ21ysyMlQBE7CWmFEGzdeM3JUm46awhBs7nBH4wUdiV5I37t(Hyat84tt)0qfZZW6Gpqso5g1SlBUMJTjYEgVULD65edfdpoxtH5hVqestOSz4LBMUTliearE7mfMFxxlmdh5ju6cMRNjbwZuWSPRdwUXtHqHBexgG2XsNZ4yXkWaAiFksSy)CWlRQSIS8NfUQ0iylgZ1M5ofemlV2fxxDdtlx8QFZXKXvW60y04PMjBKfvFAZeNLBMm5MabbI83MPzis0qbyfhDldxwESIXZeBNrA0IMdhpYbtrydVCeZqdzw266A4w)5IN7RPaTq)0DMGgA9SaTUzWSgo4fY(uawRSADH4Jyaj00aRFBh8IugawEbaRLbEcPMqmXqStKptIjP5hS4alVZuSRXi8ugO2fydS5MgoM64RVXuGAOFM2SNlOyTmaRlL6TPaSA54EbGKd6HWqXmbwy20awnqIW45c3BgGfyeD5wtdyrdRz5hCathwAmtdiMzRPIzT5ybTxIcO5cy1ZW86QH1mYuawdN8Sb6UmSMZzgmgOkAAaRHJTTrrmV0wCB8l1UeO2eFr3MkuRnb)GPRfhmMzdsF6MtfQ10WRmSzZ8YFQ5hWcjrFAgKS0YjPHxyAGtKwCWGKbJU32ehaqE5utldGlXiHA6MvmrphAX0uhCRYglYlWDm3IrlOTChD7IiM8I8SIn3EwPaAlDhhlNIbA82gpRUED8oJZe49aEaBNPQRhFwiY7c7ZMwtRmIlMAg2ttCXG5MNXdRwEoUiHWcmMMIiOF6UfIHPYS6xS6tqA1sFQc58CoCdo7OBTGlViJsMGf)jWQopZIZzCcMnTaxm0D0Wh7Sy3GlGERAtmKP(KFz(bpFaiASXsF2aOQnjaO8tEwn5KLTeC62EQ4p7CSLGvgturURRgE7nApn2syqTE(idPLXbDtt8EERyG1KLNBemtVaxVa4dAkDzgpHyJLXZSIj2ChYhyTWfdZygbNf3MeIU8tKI3Mf5k38BGz(4oXxAxS0FYWDonRjzDdhDoWyAE2cE6L3YfyNtNZnXqQa1VtXEILdgDyAKIecFwLeSZ68LoEbGumiBBNZyRLUMMLbORG5Or3Vgflja9JHH3pPcARNzky24Da9)t1zCR8YVG3eGulefHbJ7GwokXfbMz2yRCORf3cNlxNCevlh8Qp0rCYqnPBG8cWq4(rBBQ9CXX)0k2WJNJgiMuOVbM68jyaXZ1VbNZTbh(MIdny)OlZXjsVL8C7P9lo)wm86TykkoCZ5WxfBx2cMMtMgoOHASNpgBZM8n84lmnGZkp53aVgHXsyrJH3WUtlHM2uwmMq(qCXOy9mhS68PHJzcs9L4GGQnjADKFImlHopx80c0s4QpnF9DZZVc2cT1WAtXbcQcDbUyKRo4mBHEhsM5E28(sz)GRhJEDNM7dG6MY8Ur1MuUFj(Ki1Rz829cRh4LDtgvPW3dZXVCJmq4xJ)3Pz93Xn2FlM2P14N2G9MlwpQ1vAfT3(BHJ)PHVHX1xqtE0dkOdNni6mcKsREDpx3T79sV8(BTkU)I)6KXqx8KHwu)ppULgvLxg)R3DLUn2FRbr(HaoE)TEZ93QoEHx2Q7o7VvuZG93sUnj4v6b1L93Yps(vbyx7TT8Va86cKY)IMtcBSSydnwTv3wdAg0aHBy(eBXcDz9tVoF7V1FpmIHdfVBY5hmD338Vh)V93smM)pG1UC8GoI)hPNDIU5iw3BGZWzAh43Dy)4L9cKSybDzjaOwoyBaFiXnxoaOt0l99PP)Mt)eVW0UZJPR)F8AV5rpu8PVZdh)3oIomdI7P2r34Q0tRrYeP5EAt3tZyZg2ClSlZjSH3nxaS9PxvCiI(YV9K36EZa8qbKStgd(FZg(ySc7Z8I8U7JgD09OZWI4YwBwqhp3mzyEAtEjqNEH9zoHo82E6opE07FD6iDnDaZi)KODAU5BUE3Z0eKDca2(Z3RrawymrV0llCBPGMlVNRp)VDJx5CNz5lv5SRSEfVQBS4f3GM6bbrOC5aa(64F5a1gykeDW9VLKC22V9GGzlyrFBJG2(7rpzL4MvkFImPMWe9MeVaHAX94p(atM6BLfcGx8los(5onaUBZGUE4tgqwiGMyzXIKE(JBab6nWJtHpDEkukGs3g6hkYMGM97Hz60ftPI)(Z1aBUjZsCupkGySc(yKdn61w)IRTmsf2yf6gi)IPOi993RDp)gStRqlYpGFAjGj)BD4VfV8r5NiMv8eDMxzX1wBfGO7D(1xEfXSi2g)uDY(06AOoWjSAyBWwWXec8L(pD66mTOoopwpCPZwPwH9)fR1doR4j9zZ8bNxWOzxU9dUEb9ZA2Qz4gf2N5untMRfsux94p5Jaf1NCRdp59EiDVCEY7E8O7FeD9e9MPVkYWBurXb96ZENrFW3bJcDzJMfw4wNMxIsCUvH9zEH)F(MN82F14BHhpWhEt8At6opy83C9t(Sdo5MhmpqSDUzN5EAUDjqStH9zEn78D3gV7w(NVnECDXJ494hD04p7JMhynVGfZeqwtvxVUwHn))sx)ZvD9ZGILxNpQCtNvir55VoFD(KteZUeD(651)a2k01kisbUTXcwg60nNAr9yUcvatIkEXOw0a8IvBVUvXt6ZM2ED7jhnUt5A71DkSFZu3JUBH9PuDpgcTL0DKM48C)Jhp(lXRoQp4yuL5HFLYpZX)LhIxzB39gNw4d)x)a1f2243(yXlmEwaGvQctdwH9zEb6p5Or3)GrFXrZf4LLT360MMN2WOeWtVW(mNG3j34gJV(Hp5)epFWx76ayIQ2HaFMt0Pr(5Mh7SZuHxZc7ZCcV4b1(lUnesMkESYGqRCZMHleKAjqODH9zoHWN8q0ZJp)AJVdg74)8Th)z3qzmVmy1j)8ck9CNQfsd3cB()LfYFHwinsBHCMKSCMinmzX13TQgH9A1GEe6Pu86xVz(AopOD9E4Z9MF3G2Y3sV4YPhBV68VPoO(n9dVsWaCHSn(E5c)zKSpYmNPEv5W5fzKJluDzM(Yo)0erNIh6DoglM5TBfoG2vVQI3Yq5l6x8WqO6WG6Yxr0uhMKSf9o9uvHf)BYBYz8BbOilKD61OhLTUbdR55hff2Q2WiX7FuZEHT(94jdPD1U(9LVETqBOM0Zdb7PEKZnOxThcQbwhQaKvdsRbRLCK86spYMybBpi(rnuYDq5WfaVaXRLCgqtqKQ2TxyhXHVyVnx9u2u5NO54Y1nyyUJfNXL3GkrpgeEPPJJMPTMJmLUv3flsnoU3lw26woUwIsQdW64P6J7IVTc2wMCdddML4BWkOVx7EYh1mo9OMXWrc8vwd7N8C5jZVk(YcsYv4l2AmToMVmsUrwyDa6yB7KIeNUW1tZSmLcBp54reZaCXfp3Yz4AiMkGpRmog6KH0WlSx7GbQtftcxFmpV8GpjpoOXmuI)(vd2tMlAvY1xV2VlOo4sN8KgrOnsUQ6Ye3SWdRvG5E)Toxx8XOUXqFWDSlqJNACxhKoOk8xLQ7Kjo90uDyTnWficgfprl2oESbxzHUcavJIhKkuNLZwmPv(sUjyY38)7d"

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
