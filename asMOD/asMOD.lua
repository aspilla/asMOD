local asMOD;
local asMOD_UIScale = 0.75;
local asMOD_CurrVersion = 240915;
local bAction = false;
asMOD_t_position = {};

if not asMOD_position then
	asMOD_position = {}
end

local version = select(4, GetBuildInfo());
local layout =
"1 39 0 0 0 0 0 UIParent 714.0 -983.0 -1 ##$$%/&%'%)#+#,$ 0 1 1 7 7 UIParent 0.0 45.0 -1 ##$$%/&%'%(#,$ 0 2 0 0 0 UIParent 939.0 -890.0 -1 ##$%%/&$'%(#,# 0 3 1 5 5 UIParent -5.0 -77.0 -1 #$$$%/&%'%(#,$ 0 4 1 5 5 UIParent -5.0 -77.0 -1 #$$$%/&%'%(#,$ 0 5 0 0 0 UIParent 1112.0 -440.0 -1 ##$'%/&%'%(#,# 0 6 0 5 5 UIParent -1172.0 -470.0 -1 ##$&%/&$'%(#,# 0 7 0 3 3 UIParent 1172.0 -470.0 -1 ##$&%/&$'%(#,# 0 10 1 7 7 UIParent 0.0 45.0 -1 ##$$&%'% 0 11 1 7 7 UIParent 0.0 45.0 -1 ##$$&%'%,# 0 12 1 7 7 UIParent 0.0 45.0 -1 ##$$&%'% 1 -1 0 4 4 UIParent 0.0 -302.0 -1 ##$#%# 2 -1 1 2 2 UIParent 0.0 0.0 -1 ##$#%( 3 0 0 0 0 UIParent 576.0 -689.0 -1 $#3# 3 1 0 0 0 UIParent 1013.0 -689.0 -1 %#3# 3 2 0 0 2 TargetFrame -32.0 -4.0 -1 %#&#3# 3 3 0 0 0 UIParent 339.0 -356.0 -1 '$(#)#-S.5/#1$3# 3 4 0 0 0 UIParent 2.0 -526.0 -1 ,$-=.-/#0#1#2( 3 5 0 2 2 UIParent -324.0 -374.0 -1 &$*$3# 3 6 0 2 2 UIParent -312.0 -376.0 -1 -#.#/#4& 3 7 0 0 0 UIParent 559.0 -779.0 -1 3# 4 -1 0 4 4 UIParent 0.0 -326.0 -1 # 5 -1 0 3 5 ChatFrame1 29.0 38.0 -1 # 6 0 1 2 2 UIParent -255.0 -10.0 -1 ##$#%#&.(()( 6 1 1 2 2 UIParent -270.0 -155.0 -1 ##$#%#'+(()( 7 -1 0 1 1 UIParent -623.0 -2.0 -1 # 8 -1 0 6 6 UIParent 35.0 50.0 -1 #'$A%$&7 9 -1 1 7 7 UIParent 0.0 45.0 -1 # 10 -1 1 0 0 UIParent 16.0 -116.0 -1 # 11 -1 0 5 5 UIParent -272.0 -381.0 -1 # 12 -1 1 2 2 UIParent -110.0 -275.0 -1 #K$#%# 13 -1 1 8 8 MicroButtonAndBagsBar 0.0 0.0 -1 ##$#%)&- 14 -1 1 2 2 MicroButtonAndBagsBar 0.0 10.0 -1 ##$#%( 15 0 0 0 0 UIParent 585.0 -3.0 -1 # 15 1 0 0 6 MainStatusTrackingBarContainer 0.0 -4.0 -1 # 16 -1 1 5 5 UIParent 0.0 0.0 -1 #( 17 -1 1 1 1 UIParent 0.0 -100.0 -1 ## 18 -1 1 5 5 UIParent 0.0 0.0 -1 #- 19 -1 0 0 6 EncounterBar 0.0 -4.0 -1 ##"

local detailsprofile = "T33AZTXv2b(Bz)WwR9Srm97hQQ8bkjsBvMIuRa144QuXMnaAsIiq0inaenNDclzlAhAloX2zeTOTP0sV2EKDIsfAjApsvKZ8)Ha8)WEoN7J(2nAGgswQ29d78GIe4(88(19ExsFPfxQs7K4vA0mc)14BeLe2SzqTMrHjbTI2OBCYQRf2P7sNBPk96efKef2SBJ1JQ3UZsvxQss8gbRewpkOrlO7ZRVuf4xM3yP51MYyPUlvPtxOdRhLeulU1knwfNIvGrd(GETRh2nIgK)(EnQD9G6rDJQ1TrClACJ6e1nOt7OAb1cRTwe(zTIdcBgL0Td)pwlQz7UnyRdCPf2QX6H4aeewRwutCfxVrNWQnJcwFZUR1Owq9ETwnIMayP1QhSUAulSzqNnHv064YMTfH9KCS6Gdtsu74KUWecnUzJwxNT1JwhGweaz9GvsIxpOfStXMVEdO39wpqcmJxVAy3aeSbGinyzff2DTGUXXaOSDWgnQ3DTLM30wtotDJd2yT4LQSuLAnd70HaeDGXjoPEheo7yWG2iy2w332u3WMd2nDHFZe)n6ZSyTb2WZRB54k7MO5ogIMlASdR1oMY2sdPbVnfo0gWAN3AEl1fJlVD6IgQlh2018OAR6Um)2lBBH9MNSXoYw7oInNHD6UZJV70lEnynQnwbab7XS3gQ5ooJR1YgJByAWhhUB4wRanmn80hgImCx8h36Xv0CpEZDgjgFO2A76oge5q4gfI7cwiMYrNn2E6JHoDOH2Amno3iB4ypgi(qn2zCKFd16uaICz4n6wpws7HidD8hfT9WT1vBClK8nxP1JwStEclDnJrd0ZYT5QpYvEoyIUM5Oro5guJrsOMJ8qxZAma68cCCnhhOl3qR04cOPhIm1CC8ldbkShZcjN4mh9rcmYt1z7mgEL8i5uELHg3HAQ1yyRYrX1fvaIwIakUtI71oQUWoeqHA3Mr4h2QEqNOeqvBq7We43qDZT7eewTAs0nAqkXXbVYgXjnRl0f3Otq3KWoRrn(gTdc7eqtao8vJJV(6HjxpOB07c2G043HATblBsTVauhhvpauZdJXnalnGLRL9svG)cSJPbylrqZi8ZRIw7aghrTN2E25v(3bw0xhB4gnAvpEJoJ1AQgT60nSvTOobRh1QhyKgA3eyRqC7iYQPHSER2AWFgbg9G7RorRcDRlaAwhGADdQgdwwSrJ2GryKvjiyTtuZvayuZycmcwOfsdwRETdAgVACVU4hNUme2xvfMU1AS6AnH)p1e2Me6cBWqJwGpRAVvwbG39sAdwBwH9xDA0ew1aGkPruR6n3CLgjr4mNC94KqCLxbn7APkRMebBYkGnqnb4e8BBg1Sz8gytxpeBwcaI7ITdqJnATAWAXjn(DXT6c2STAyBKYexv1X1uZgR3a5CCu3lsWtZ4AxNrOrKiOPR1atvBb)F2wR1MbDQfNaMvg1Pdm3DYcuattB2OkdFkHIvtIVoqIIKuOzD5OLacuGcfrDnAfe3kkGtnaGTUPwXIgt3T2AmJnrciaStta)7XfUGtjOAVUDrZxHVFDWs1KndscxN4(QWP9qCIGmC9W3f4yA0Sr3gi5GhGDct4ecPcU8Lm3(s(vFIFvhxNQdw7iWoD0I6S8Hge6SohsKzc05dUVURJISlAKRcmwmED5QrdSmJ1b63mL)gZYdSxuhIqE(KwrCi1nA0joPG5LPNrpDkxbiD6SwiIdphIVQb0taAhPcdAh3H3zBn3PCPb4mG97KKtQNant34EjzfkMFxXHeaDt3EDqCPuERqMVq0SCxnVnSnM3b)H7svEBuKwfO7rBTCfKImD6H9xqcXnMf66MFra(ZebE2qnDED3SyXUHjRkqKnQHuRO0qGU5TzT9nP)PRe(Ke1eq03ichL2IpfWaDJjPzDwdDTIK(GyJo9QsYX2ai8Bh2gqrNJd3HzbCxceWZKmbcTxpSvDo7a2Nobvxnh5PNq1hhO5juKiakRewdwyZcsf2A5)h9cRNa8LBT8IlIs8tQhLJCVyugVLiXBpuo1fI6g2OzNTw(CHjNJ(UTw2KdRsBl54gc2ohrGBOJQNRmhrY6sgNxzr1)4kknlf4gVYkGtX5wFDtHymTu8zL)ba3oGhbXD)ouAv31IRticjiuUrUylWPCecDTkxEM5M7ClSWBDTkTbrSO2WZCzqk3z0LRK2XGQpCQarmRNbHiCqvFPzTT90SSnm9m08mmTSwALZWyzN1Z0amU2WWYZt33Xud)gIuFwxhxlDtlDxxtBhDFt8BidcM1wd84q31Y2xZW001NnAQK7JNDMi9eWgbBDbrba(N1Rg3SdSx7buTszRmbYmJe4U)tEQ3P2ArRhsavwenec01ZOBPx72jGYcUrhOUimAabD3SDeXCf3Mc2aFAqsLoWAkIV4hYYJW3vy5bqS1Uz4MWUQoJuSOHGeMlr1vU(Mitp89xhmVOYmnVXvVitCjpwoOAEM5h4VPy)bcRdqIesFoH2lKHQ7qgBG2tYuWXwTWNd6pzMCbaZAHTX1gfmfCOjv(OjlifynE4NwVrNAOUusECVe6FJab7RUjfQhMzaNlJDsSTbmGbCz2vAfNSoBo2CPzpJRULHMPJMHMp8VgiLiqOw5DbPR(2tb(n7cKVmEYna6wnppdWlFntBWOBdpS1W3Sgq3A5Obu0(MWNcURX)gemauMSjdXYVlbu3aWAAAy)M3qtJzL7AniR(KHkIOl0582Dta7z6qiqZaglimeEineiIeXTi1DlMQEqEkVjm(bdHKcWsR6eXgY5UAqcHvTa6Nv6HC5ksnq9ySveG)bXo8vfHOiflcBlglhh3aLaswifFrfHmtxV(cT6CnU4ZR1aXDDUMAx6eyiyurYxGhcz3QdwhYcsiXXHr9dytdcbdpBfSEpqXvGcidPlca1lDilKz201zJgOnuiPysCtG3uc1P9hAsD31a6YvxtyIfTAg6ltqZZQQGdgwNqLOKOwn6UjqqUAlYErkwEaUcbUK3b5qVmltfs6N)mOYpcLYwde8(Ci4(Ci0(CiW(COnbNJztaWVG64M)mgOaVqM9NDL7zglcziejoejiqqBQ7hbPIma)RsAai6OGuf)iveJsTglmTcegJ0spdT0eOnnDRb4J2RfYu7rKNvz(a65Xm(REsC7cGWVbZMWk5nuvx4zPU0ys0uvH1H(6sEUye73ImlxiRaS0hK4xNzup4BshcvDJWM9iZr0iVJN0gAoPn0AsBO9K2qNjTHUtAd9M0g6pPnuxBIB5eJB0NyKJ(eJD0Ny0J(KIFyIHxLOZb9gz4ggTbnC90nATcPxHzrniMjKKMjzmPmNmzcDPMYMwUYXki7WCOWFYobEAEycL6W8AK5pnZbd83AgTc7x42eYSmfhNRigNGoWytA1zFmT0j955eRrISaVbQb2pOOjSX7IosuSxJkqh(ANlbvJ9bbBM7dqJnsDQmGLLfzCpaRhaDnHRG5PIGONtX2hoyDwu091af4gtT4IZIb6H0lLkTmRuC2YIrweuRxNUOl8OuNQPc4qq7KyklZ0EJmuzJ1JKuJ3s9ty946rnjSjyBkSpP)gmoeT4QZ1MUwJ6NlHcId89rjVb637uxcMZMXBK2AYb0RnZF7LNE(kxCH51mU2fwyHlm9fQCTZh3SEyss41o)cZDHPVYvMEUfo)vRm16gI5tkW3wmMk7g2hiBIUOtPnrIPvHLv(FI0t6)dtT1Y0Vz(pq)JX)aNrrfhjieNdTjVvNMGAxb(qqGWh68SrPnyYyWOGJTj4)AOIt05PqNBy2eQTGjdxhdyegApWY5C(86M1RE8FT48EphMDru)Oxk0mNLRfHh5KVua1n9XRMeUjZ(HHGH4oGnSvXyKc9RYRj(KI5jgMjvH0(c)3AuRBV13A5xljIeU(6QYhOPDKgFijCikcW9VQS4ouGSQjXegw3uKF0rS6VsHKMWAMtt(xjjs)V(6fX)(MCsgXwkn(Qki0zPOM2z2KW1JU2vV4z4)9Cn609mVzAhkqK3et7AfWbYPeHdVy5yK8ObvrSJdwoRTf4KLTTPd4WLj4rgZX)UclAxSyDnrD3adkSQG)8ycUmeDQIbeAhjY1rfofkm4sDIze9VuLPRbcgJWGkV1Yxg8Oh)JABQqURo9NRqw7jHQcRrIG2D4fjrkfvNO2HGx2q3Rm)cZpd6OmdSyW0mqo0FjS8dapI60Trn(ETEuNqy9bJvDMBhyOZbVoYzQs(y(wOY1X2cEjFGEBWCsm11aUtiOR9mFqY78JH03wxkQg9wf8JhJrWg5C7JChKmRIVF4dn4Z)15wRaISch2N2moWLgG(kuayb9LvcVrefNo00dmPexyMfN(IZvjOYItV4vRCUPVsWLN7QVXfNp48G6S3squo6MD5lC5kYG7Gd84B5Imi85l3gaSz)TxcJMhx)XSLsEon6JmfWi8VQ0DZMSqpr)fZSa(y9oxIfMWXUZQmZBCPzMFXNJ1mpKqlkI51KTSZSl57b9xo7bgs85dOpPlyNmlyJHwWnwpArHPTJB13LlVBcWeDvDAN7rRK7(CkreOIKNundNWQkRclSCMewoHR3eMJgcXALiruTBn3aSmq2VjWe3mrWsFkwMEiRyl2AH0jJTrLtD1vzreungxIyLPi1iBqGqTDISgNxiLLuiLggBjEUcLrEJ02KvOAClMWekIWOkLUXXK5DumHeXFjUvZiq6t2mPrbSunVCM4Fh1kAD(FHjhmv0oLvyAT0OwsmMCwmyRQj0e2jOdxvMBH3oN0WgTy7FyDSjlSzDAf2MLWfWnvPP4odfRsXxHPEnSkgqf09WQ5t)wgZ7LPhLfAunk0OWp5jw4ClS4IlCPRCX34nZfiCzQYKoalxyMUk)hPPk8Cr4OPz567BRzQJbQ1onxeJ4Bmh130nxCReAx8mYe81akh1C6xhEcc5oVROBAcmfGfPozkcRYv)vGAXSr5lljnAzGIT4z0fNTLu8uR1lby1POUlILUqFEgwZZy4YzG7wqKvzoqJvyGigcSWviYMbH)G)aCMoSEKQEYcIjovPgXDAulm()hoo(5m9qiQHaQ0(HyrxKluVQWccYF200GMtaIkP8y0njYYykXu2sA0LLZzAcbyGHTMHhaz8SCm8rdUTCKcERqocYkIfkj(koRZkx1zT8D9S919C1bqSHMfdKtYUWsUGLo7SYbBUjIoL1zdznUIhix88lmFLRDX5)TbGSXgndweRGJ1hxiriqUma8YKy7mKeqrQpiJ7lmnb5dJFohTnKPbJxutk1zaTkYw6nTVbTdxlUlx4hisKW4lYiRziCrFwPz4QSLDrgWJTkPbRkIA2SrD2YLaYdvBfzxfPvSd5tdarA2COsnAKj7tPsV5AW56)tROeq5reqJ3SoPzQwZ4EG0EwQ8stjhOG96rGwlyPHvHn40bkpIwmICLAOeDkLulIMdHva2AygXavlrGV61ZrvTPAGuE3mrvb6bvr2O8oyALjXLb8f1ceSUAHv4GPHm7wBYJOA3OW1X9bSXq43AnIAwNNiiMxE8SDx5nV68loZvM0cfUYBp9vUYfx4ktuftx5kl8gxDMu6qlpnlhp30QcuxZV4AIUYLM(nMPOQomDigUpxEMflVl5kvWkx4kx9IxqPybfljQVw(w6wAfxBMvU0cZ)wfuQJo(QDjFfecMcp9IV5BnpzEWKxc1iyNBW)KSqhcRD5PNB6lCX5N06CSYvN)TMhmZAIlKZkx(kxCMkloHO6HwEvEZPV00ZpbiV8DCAqOcQGFKtSgOEWZ1YR4v9mZpZLENjSOsbmhGXZYTiW2MJVctR8MOk1jf3LBAV68VXvw4Qx(YZn97OmXLJrM53UWBP0bWGbFT0cdE000vgN0GSZbjjALqqLuAfnHWCydLw8jGiDPQS0WwKVEobtm6WCHWw5ltRYZGRhf1oOAegAjqLlAafI2L15izKc7uTq2SKROtaDLRc2vkk8eBrP5cw93Enqr15sLlkQ4ZCyAhr4Q9ef2MvrYdNYvukxoIQ)2YCysCbQxu8FEUdj0ZspxnH5twOm9vMz(PdENzMBoj)PEMIn3ymunIQoumTw5LaQlPjfvLOvErDzMmB)rjtZ1vs8iwym4WmZnBAzV5RPlQlttdDBr6UzFEor6M5w8fjyBkFhbRO8aDywKaTHmjkVmSHcFidW)gxzMzsNnhphjBOyO81gw0cG701Dv9rAkyd6KAbS0RD9ILZ4iWC6ceJRFrQfSfuF26zA38ZC1fVY0ZvebtbYkeqhBxhjLIVxEf6YAEvG1SebrvYBJmLGrDDybSruNySA8nQEdYhTQjXH1RXoxDk2grNdnYjEW4BwXIVbzlvCDw9yMewVbzNLJipPY0TY77LJ7aM67a23dcC9SnX6Pq4DfliqOyeQohumSnTW3ev)LnvhIIQOtufPcl2TWJ(g)yWbkFiNHyTeKOSEBHZMEkyFdMVpNrNyUiFlW64FLKWv7Owt0zJgTeQ0B9SNkpy91kAJrT(0bAcX6ZKzu6it8UaX1gKFwJYtkRAbtnMM5BOmWp5RzFuGnRe3qb6Be2gfSxFtWuwy84Tg7iz4AaDMdgYLrYA6jTQibtX3OowemWgbaIRZIqtR8UajOvLNLiH(50KlZlxlwQjuZ3SwMKOuuj4MTmKDkEProvTcMRlzTpWQs48H2swYq52c(gYDb9RMP)kBV45q86PH1tSKip95Ka4PDuu50JRQVemRIvmlcbS6gf7ChIUJF6BjD3uvkszCkPgO2Vw3g3agjIgvS9L1nkqhbUj3kK5HE2tvY4wvcod2rSnLVGPVx1prM6CECUy5g(5mvYOyG6Hj1dihBRMXwh1ykiypcq(J1J6(ctqZ4ivc6DjeMaFD2ZgSQ8ZoGSheXqn1Kt5faqTUuudgpjipuMlUWLvlexHqeKAAtu8LUm2NftZouqb5kAtJPRmfGeJiViKBG4PBe2KXGYevl8n2OuMXIiCXJwtZ4QHxGvXovc7qh9is1uqkpPCNIXQJhKpwTofZPL4hOBOXdU)31)RpyRL7FVNn4d39037Ha)GUToAhqLbp4Md2)76)ON1)p9STwEWtpEW9)uODIwaWRtE0VCYJ3(092V)hFhOfp6Fd6Yjp5i4xHU(XFl0L(F3teTheOm4GF609(Hbp64b3BFyop6heFNfUs(4tV)UqxV93E6D3hAJ47i7qAS(6mBlOt1cgHBmCGuLmthf921AupGfo)68tSdNyIxEtPS9PNCe90aNg9UT916grk6aoKMa9ppkUblE(fohldgedogWcmOTa9xD8ycb6Y4bLzElnnoqgn2hiI61IXg1Lxg1b4HyAvmSnnXdEpWcGr4D(m9chpMcrdnz8B4XQH0hrN0mrkw2imPfEsRAuxpTmVbst(WtXlre1kgwNoz(Diloa7i09S89XSorbBoaadbjHqtJAXx98d8X1J2StxC7obKzm9Y9wnOnGmAudZkcB3ZRp8QsweXQh3VuOVqwXQGKORJXUN3RUHvX5RkYUX(K2H1RJbXcfDZkpD8mM1adYNuxbDoms7I4Zb)Fu)40IJiRwknPJ32YZ1KkRpi2Stu6S2OtQSaLrNoyHLiYKhtyQxPdipaVUE(EE(goAUoEwoAECR(OrhduQsTDKP4DZbueM1zIrLnkbONeNaaQHiHhO4QdkzvC)jmeyLoMut4b9ifeK1KcVHaCkAjwfphbnQLFo7ipcvvAXP8u6ev05I0ZY3M6(KPbCUHYBpZsI2y51atE9NNEG1OWe3EY80YBSblYVyDuuEJn558ihyvmu(Ad9vCO6Zb88vo4KLZIjhCYA)RsWPQecYvHYShG4HzNuVcb1OpdRXpynLSgCj43eIByj96fa58)1PCn4G6wSyH1vikQ6MbmVOPJBetyv63wQGkvjXfldtARM2Wym1EpeFdlPDw(g2E6gog(MAUMGWwwIlZj)w2AxlFpFDtnBxtlDlEg6gwhHGYEObsDfnKessYOSVAMzg4Sk0eb4reKdhr8pTZrVZwpOk8XRgi1RY0ccyuLA4uPNfezeWP5DODKqVNTLRMLVLHPJJlsJZ17jNPcoZKJUWF7ioSDdnDzOwKdUuvQ7iH5PPW13WsZrx31uZWW1qewMHKemwIhgpqzQKlGtH(QQfSkNa9QQAaYWGQ03rjLPK2xGkGjThc5stu7fYLkB5NrUujnUavamwI0ITEeK8QKnfY38IPjiSAN4KHt6AHsRTFrKUJIBdVXQtY4lBFNjO1wAChRcNiRa0DgPDdJD50Rn5T0ey2abDQL0O7ZHPgpxkJTCEbugZKvmXQxxRrwG)yx4VKuClkfxvmvb27WfE7OdYeT10WFyBk15vGCiEKN9iNgeXGdeRHL(nZTtXvft9akWhnX6s21JcGglvCzADVorjNNkWk2rOH9PnXc5U2A4fzc67otXfGRWQTmnSc9A1GDz31iSzAzNZcPxsunwi8zfcgp8YuaGvlTt47A2yf0Efg5ffZ5Mr3GkDlMl9UILjE730oSBcgHc8KPhN0vCQqh2LDX(G8Px6zo3942XXnt9P31W11d0DQXdEngSamI2QjTed1nVqXsVsatDNpBqJZe7fb8bbwSAGzTgj1Xl9NUBsc3GzJcFqR4UrYymrN2wscOaovnSvNOwWhWd9j62CylSAB4BvG6uT0i5LRsuul(riF0bFqX2edE4cN4tMAxETGLFQvWY4gJtxHBeQSus3e00v6se7OY8etdcphWTqLnu17sz9N1yESatNhAeIWTz6N1oPrl43Xk1HoSca2pbWv6u6GOs4jQgyyh85aTdVeGiBoeh9oIcvMbzw8UPVhbD(k5sEwBxxFFpBlhl8UGqdlltt70CipRJPNMPUNdyXlDJrGFVxAsoN12YYdemydC(Uo2KectFEEJNhJ4NR9ugyCm4PYCwxhlnpdnlphphWwAB(aQMWwaDdRNPC9D455fmIe7Hg0dty6mfRcrUgN3xx3BklSMJutvjyYUhU90SDSST9mrB0G(ks89S2ogE62MMEEMWGsL5igwfw2NHDUPpoBowgUMEYfkpXKZ6AQRbeAMUgg(6EwKDTAI0roVLJNV9uA(oPNkxXIYbASbcpDajQmiQLRke3hSN0gqj2AEw62KHL5Yb78ieFkDerXa0gaG2FkdSsDZciTnNcVjcfllGFXaqh2PWax8AfbXDgoM0fKcmBMCA7MyzmaKoGqU6SSnuT3QbIOzd2cerM(KHNGXR0fzYYDTB0D4WCsxgOOmM0a7kO1Ptszl6kyIZxGHwDDqDdDrLk)qwaNfvZ)fNF2fcw8QlUWvU40ZPZu7fL0LfPtEOIRIsmQYozSGJtvvUeG6QEBLjwiWgFHF7mxz65M7ctV40baEA(lo)BqHlRYLWJ9Wcx6CtVyWIx8sZGtipV5bHTAbY2RXoL)16M0KF)IXQ(n1r)TV48xyH3oaPKdU684)qR8c3tgm)0WsrSvh(UpvFcl05JulImM3dNDqUkQmrDVwZOEbmCUexpsS7qsgPRPlwHYa2nIT2h3S6w0pnPFAq)K2TWUIIlFBCRqPRktsSumFmtzqklF6m19oR(uDvl7sAu4xTlP3dvf9TktvHDwQqkZcj9JZ0PrfHvLkspt7F(2pJATm293eSKYmApVBb(0u6ojB5SocGU6Dl0OszdR2lO7n4oB2IQCk2vxyGYjfJDZ2qj8FLM8c(IzEM0lUQJj3ouHGPLMmMXBUglZMJmekA2w(Px2A(P32A(IludtIRon7jKb3mHI5o35dLjxO3IQGru(pIr1WmZToekIz2PV6CIbvCeL551ntSzEN4EBT80jrBTC31GFCoai8FHCqQxsOOOjsZN0KRrqnfgkNmNQQXlmZhZt8hyekUSEJREX5UWqineBvxmHDZN4nLfx2ddtHy()(Erjmcy2j5G89GQnqEU4tpHuynKdU0XNn8iXcuwxVbl5)0AkNdnZRRYwv5K)8ZgC4NT1YN84F6Kh9dukYlSA(3igStNQcU5f3fRu5rvbZP7N8fBT8G3)HJBaE7OW2WQ7CWAwZvCPQWzQHr50Vy)tE0VC6DE2P7D8wl)A9F)V4092hg0F(hGb91lCuPDuWLcxTrTGzrU0OKzXcwGFpSWZN0WJ9P7)KtV3xV1Y9)5Do5OBw8ypnH93mOsVvwjgXoIlTf6(cSWr9opR)xFW4wPtNuduOfCjWnQlrbOEtXf8coOofoOFXDgC3N96JgR0d9SAwKKz2gjrvA3iPrxXTbdoQUfnQd(YFyWE3z8B8RS2MXnXii(BJBcl7yXnhdoOEfIX(KpyW2)44h0ZJxgf45Y4YXn6aedAgI7zgIqamq3Mbg(9lQB6b2JAEwDl8)Pb)x2VPFwDd6h)(UBTmd8qLcWG7)DdU99y5rK1vPnWSXw3IvOXWyBbUx4AOp(XU)pV9GF(azLjC0Vat3U7E6)0tO5GpeY70g2Ca(YyYNdW2ynn3XpfdU729FYU9p8tXkD4)4HS9XxF0jh9E9F)dW6y4HWUIXGqJM8EXH4Eb)zCzSWd2)9oDFSalU3XaNyomW01bnwdfvBQgocXADPjMJ)v6kVjDy7eac6NcTSbpJkzRSZbd2z)t3dleKF(MNU73Z2mF5rdU17jay2SWBXUgEKiCVxUiCBLX23vfHR5vYw4WThCW3lq49)MVV)t3Mn8A6ogwSRPzb3QPRRLTDkU2YuRKr)ZHL9Ua3c8RFZVa)A))W)Qa1AzYU0HCLRDlnnlbCb83ttRKr)KhF4PF(3bd9hJcXz1gZF5oOiP)0dzZITbyQWsSCORaH0eqiBB0D6sG(FY)2P)Z)Ht)KhcaEqQpdnCVBE6(hWqXSXGMebpTHUf4NpFsS19nDlbl0)O70)(7cundEeo678V2)t2LJfapi9y3Q1cUAxxBtUW47WOk6)4JbX79FWhn5CbvBghxNxOllXUfgKaiDtXA3XwZXSeMGto(Zy1U0NFC))e8VN(L7cCe0660V8wG6gAJWgjAMmsLo574MIW1m91lLyT)3HaOdpaMnAkGPEWohkGv4qSeRGYK80E2Qsan9lbDp44DWk6A)9aW6h8K(3FFjVbhLWhfAAs5PDXB(df(o9YeD80Jrbx37xOFzFsV8P36MmXU3)ViaBwoA(2gSl1CXC5d0BMkZLTBjZv)7ChqMu)V74(V)(mG2rBF6TqIzKs(jcXT26wA6muKtkHSMTHuwLJwPm8Gm9F5o9p6G()rgjq)D2HlTY213NDX9lbAyqF4do87(6Lm49FW3bs6L4JhYfjMQWGni0Ki43bsmFwT3xbKwFYp9Pcw4(p9Ry2VakYFD(selyigWwr7SLHkI1UuA0V6trY)7IW2JEOq8bda7AaSZKvGsn0(Uyf(9QKWXuxv6TUCUSm998lzUo6xanZ9)uq)2P7)uyBDYp9q(Ot9MgEJuAfmHNCHEM22(LOwBWpVhy7etqXTpQ)7TRqZGnDucW7vC2i77PzW15FR71)F5d6Fii0hqLGTyYU4reUMwk6Yt1uPRz6vMzjGLpa)oPlhwvGPiN80BD62pHxX(0aqZGTk00xLYWXUKzy3BcwEZWzpyxG8f23F4HN(bhiyq84ehcUplnphpd5uagsywgcdSXDNV)KhDeJU7wBZ2xhDeZYHNUph7rdfnxPmJE(wcRsaAhp9sKt2))8ObF9pYGxKwEeL8qQ(trX9G6BxgaZtUBC9D0LYsSmnDl3ShG(ypGW(079P9)tBpy77jvkYnd1mLr1YivVoo4ULQ2Q)95yJp8MdU9HOds3IB7JjGXPX3stU6bYBb8bq2GORseeamLd2)BrPUeRjOD8ZoKj99p)K()P)rgMWhFzJ8OzspfR7Plvz5zyQzyvQDqaTfZ1UF5wc1I9)SV7Vcr7FA)V5Hc5Bgu8MN3kvfSLPH9lnOgWfYUqqtv)sh6gHmbpnlJsOQ(KDhC3J6)yykoMroJO)(p4B7)9pbuPGIT3U)hZiJzJhnFwPyjtnhPbQ2oAoLXXC397F4o9)H9brqd(kaiE6bhdatyMH56F57bdI5IyOXIMSuJT99s9xWwZ3YOSDhzEnmP3AN(V3ZO5yWE7EY)XFyWd4sTbvewSWnyLkfWW2tQVNiyktj8HiXW27GWSVMRg(4pcyNuO5y4jxf4MH1Ra4MkbU0eCqXe7G6vzWtp8079zmva3h(XRf3ARL3mUxYwlJpNhV(ezpBuv8YgKcWooncjcw6E2gcZlnaDkLPzfCHBW2hm4bOqZ)D0YpgN0pE0GVKRgGgekMisXc496EQbs(yXHxcheOc4d)dmKcaNGz52hCYJfCq0aqZGU6m49QyguuCBAzOkeOmFg37d6)V8lmJV2dL7Nsat(R4ZEERmLJVni7p1isdWP4YuJDe4chzd1jh9pshVHtE8pbUGjKJPZSqq(cN5d(5Ls(6AuMEY(FY2GGrYTLtEe3tlmfG(K4r5JHMbynMR0Ijyxy5voj09EcAe43dcWo99EiWJaMeF6h)eUBJ7cWoK))9GPNZXJJknRsJUDaiOzQIsBlZYSlEh0KWB)TO13mtcV5GdFpHQmqkf7PmtURWGOKA5IFP6xaFS(CC87F7DykZ27oc22bhCiGQ6)4pl1TEgQXlL(1wALVVb4sEzXhcOwpABch1)Z4tYh)uClTdtUpBqOjrXHBDhHOyDD8c1XOCMKBJ6t(KBp4PO9TFYhb(8n4NVJaQzAXUjQ1u4sS1KyfBxVsLN8(73)HhZCpH7YX2NE7Bsoj3)VSRiif8XIMm9uwg89ntq456yxghtMti0G79StE8pcZYJ2zWdqYXh9fWoR)ZeUgyA4r6yKpxDGMlxxg8tXDcHN9VM1LNmjXSkS8Av7XY68kjrT(D4ramkXAQ)U2RM5Tz0YWsyqflOJp)ZtuspkPt5MbPXag2UAcUxq0nWvvwOEUZZqhRiq4(F7G7(mY1hMNb591urZM8feZcqAMPs6mnkJkS)(pe5E(o0vGpg(r)F8MzIFiBmY8KlIf3RUUkDyPbCL8k809frqeCk930ojU2VjL8J5BJ8P9ZYq333s1tr)snb9iEKO(jGnLnrBFi4JtQ7ISqMiFqaP5W5vZC4NswBzjGvGEjxFVYJO4h(t9p6Ry0)KD1doCV(h(uECtU5GhCtMqiA0Y8YccyFmMM8DKb(xL5r4)83keim4PpR)7Z8paSNU)9oeqsjrDbojgAYeSJMQ3W0xAqWHhS0PtJg7K6NagZ69FImwM3)FctI1Fg(Ix73GvuXV51LXUMjd0nvmbwx5PU4RRvgb(P7Xmeb0L3)hUt)7VnzepsHF4EOnJ7dStW8ItBbS(lmswF(bJlPxJ6bvJctwR3QbvBgw76BSwJUrcrbUPcBS19KkY9TT9nSNe9dyKa)I9bWdgI2do9d)regfghjarGrdSGS4Mk0Xk1sABW7hFBNsJ9lgkNpcMJZK6NOImgI301wfRR)YdRl1BBq8oUPYzCa)B(1kNbTNVxNOHe14MkQXXYtM(lnlGMQ0yL)JdUlxp3H7jmkaa1GDHKHoUEkGkBfXXUw(LAiv)V7jmZzZZWZ6pn(kIxa8Jex74wQHAp67bhY6F4NIUL9XFlHWp9whm4Z)mjHgFZGJfL8XuHl2GhMVIfL5PRWVylOIDSCC8mlp2wp6hi)23xeuz0cOVa(vbUhFvAXjrvAIL7RaPjRh2P7ZL0KMnqzjHRcMsGLqRq8HNITk(o2VeeFKtQHxQudWcptjLKLMxzzDzWx9Pm7xtJ5ZGV(Obp4tLHY3JLUfpBL5WX6vZC4OQGW5vakfp(bpxOu8XaLEYlOkgwIrDvenyKAffA9BzE2HLnbGkL5w00fpS04GQkVXknv(gLkkBW9(mKXenYCWHh0F7VfgF033V57jPdG5OPHJKXG6RmvogV0eTz4Xii9ve3Ol9re0D6doHuM0)7WYram0)LDyj0hmQHz8c4oJdDXinVFQigdtzDd8YWAjSWZ3iVXs(PcBaF51t1ldUuvwPqao7cUVDxM(Yt)NVjMYXhCtrUN6F4xbGqWDbH6hCePP0ur1MP(lvvB(PcmCnKQdaGRPRxzrf6VWX7p6im6qyU)qZnoyBq0nlk(7CakSISW(rhcqA2KZgBAYLHfrN(i1a6ugS8pCN()V(Lt3)MSOR94T7)0VIZf5O7qK2(QYqKzI4LPmKFdQxGB5MTjWbrxYyZ7lLjyc6OmEfxjl(EQ5pY7Lz(Jmmmyr6X3xzhz5)kzhHYm94vCVMYwYr)LBkX05ZrMYtW8vZCiLvag)44PM3n7sRefQcu2(hXKGD8Gd3Hf61)4oP5BZwl7J)oEkjKAGSnS8SltGeAa)xSNm)1h)rd(h3ongIgzFg4TS8TK5dZ23cS7US0XER3BWh)uAp0)bF3GV5z0DkZGhD8PFXDYK(q(OL9bC3cpJUsRl8b)ESkl)y7)S(FYo847XUZBoU)DqrT79t85Hgf28iLoyH3ShI5XZ3300OS0m)daENeXXYfF)p)zN80DbfIKpVN80Bb2MXMq2WXMqPubBd8EtlfqcKFLfE8DrndFhMaRB9rOTWP2elbGirmnpsJhaSOSw9WwyuMkDW2mmcZI0X9WJH9iRw0E4XN8KJalluc5pRm608tbJ(AP5UcaQ2LfW0hT7j)4tamv))xGnkhJkuWS(aEu(ZhaZMGq0JBjHUSieXmki9922d4eCkZUZ)JVfd289VPWNsj949VdhrrJcBE0tNhBz64iA0YOmqLfGVy3gtsldh9)(dsPW5ec6ksfmLLReJhOS9btYjfdXNChmvap4Md(f6gC6M9V)FqHzIVvKYgSqBhuPf08lpXdhUhZ6RF8iz4XEkwkCd2(j01pfF2q7gOztkQWwZvM0uDW9gVYcrpO9Mzu0D3DWT5j1(XhoyBUivm)l8tJLSYeXGy7PUL0T9kvChaYo99)wkq0W8GjTHMvsHoRmdaXMwSAVtwKIyMyDsReaFx7sZfWJ)PtV7oy0epyWE)IOkd4DLn4UkI5YWLQvMyUb7TD)D2BW9ogdYZFsy79EyXnqOiavD4EPKcC5D6PIf8nL2A9QtoUS0fbQCdP8vhn4lknFnzuln4PFr)dFkd5W6nR(DtLg47jRJclBh4VkZW1h)mS4A3BFwDi9H)iAy(r350BEmr2tw89zKd2yaTO8vG3ZvyIbcBYJthBEyReDfbUMwVAe4IptdSztk9WYXtZ(vmlTrQXfAo(VIyPnsLBy7NQz0u3xZ2FsQFt28qQIZf2lt8kQMXayOyyHVTvggGY44oy7tVlRQSh8HFTI6jEVzJVJQAd9mC0MLlycef9vFAr611yXTt3i1(bxBPbR24b7T0QUtXG7p(HNEhMGcWF3t42PqLJMlNaZtrkUU)lruoBiytIVQSvvDS6LMr8FyNb)8DafFOKWpM788XysVE0UOgXBLklsNLhCDzXrcZg4LwgDgLv8Up4MK2bUjYKAwYifSYBU3Zuje051STS8ibd9qD(cVA1SlF2sRPlWYKb3xKpxQRSbp14bxFPypA6Dkd7qNSeug(trLs5j1CDanr8xcytftvLPFKK(wMF5N8tpeRRoEYPH5jvWnln(6MPouyMwfhmdK8kVwGbR6b)GUx2JrcV3SXp1abDphvfD6(ULwwcNC8Xm(8V5z9F4tq38U7X9)6dsrY(mcytfUDDJSwwvMrI)7pbuyIwGqvK2DF4aqzxonDg6SNUhAQsz8bVwTvIsszZ0Gp)NgS3Edo894LqYh0)Xspxp9R2U)N9PYY4JDeI0tRTsq7IU(RsTQdPh1uvMqQJS(45vO05(qqgn5zoMXab3kOV7OFqKox(aXo5mPgpaKikET4R76nHM29(pmvgNKqhRKiUNrPLFPLRLREgZck745GfK((ScusUtU99iUxGFvvOdV(l1TsLlyyKreNXKyp59EgYyDpSGbE))n0)2J)i4JvMfgVRvQ)eUA(MQZszE7XKrFYpDeWzXGA)8UaolDkiV8OBckX1QYFxCVeWIlLRELU8BkJe5fVl)C6ZUJFXQ3i)fI0gR1Od(msvHE7CA1IExNN(DWBXl8H9t8o)b)wxLHRnEsvhASeV9Rvvhl89hqC52upCZLQOPlEp7cAHxRiH4ZUxL4A1vVFYZEzjlU1xRfh3epYWIlmh8EXgVfBWZiCV1BXoT4SR7E(LIG8TZRE(olV1eW7z6OwDACJOZGxxdSVfVlgy)wm)l5N2wzBLxhsz(u8AHcndMFp)0LoqIcCJ4AjcVr)Wd(S8ifNBfuvzwRwWCwTWzSA68vDPUzqmQxSP4KUEKYJryo4c7UupUfZGE2vbg714Qd7nwJDD9t4SCVsxIEloz64DXDJM87M3XTjp3l6Mm9MxQzmD7arKqbRXyqyLdLY7QFG8u2lwc1cBwli6gX4j8MFR)EUcAo)Q0NUjpORtFQduNt7f7qDJjoRb8n0b5VtHt(6TB2RJY4qanLB9)0bB1O1PBZ4ob6y4SRMYHtpZFS3)k6ojNFlsdqJ24DcD9lmltIhl832SNlE(3r3PaaFF34KnfNuBazUi)E1HwNDOgrVOWGZi66A(U4zhRs4kR04Dz3thj9yDzEmvTC8a9bZ64AaQT8Hj3XcV5MvU3vOdsUSB0f)66n4JJw69jZVQ1QPlMX3IxRGjcwzwSZ76zmLp5px2Lh2sS4BYU(OtDOV8Mg65DDQLzDQB7cUTw460fFgjuHP226UMy0sbyQTMNEXWuOBU(wdVMTyfPN7lmSDtSZvwpUfD3docylyWQVgm7BgfMGNFsdRHHQI2ixHIpPl74LqWwJCRtJjzDAOaBrZ1T98LRtFvYv8QLqLcWt3DkEnABu8qBRm0EGje0TturGapl)COnppDppBpWkyFFt27h5WOn8qBGoTMJxWzIrxvvadQlwF8weZ3Sq4GU3q0yWN4c7onh80JAq8TgdVyHw5GW2HiYyjM6fc5PYy4zBPBnsgy0i8mRAp8UHxdKLybcu8yxcRMJbzQsNGpuqAGaQcHpMA65MjxxpBxq)TfEyRSDkgzAGhvpVIyczjvZ4xRGdxBq0QL3OeWPzKDvdsdXB(vSg(9CXWCxmji0pmiAfSQjnjwViRAtvqn41InEFmveOgdOwwqTf4qcEz1comQbUHmIfn0pl8wpB4fnzkU3lh5D6JIw0YKsBrQaVcwII2KkWJ)j)6u2nzlqddtxhZXVafTjDbY)KUVGyDfbqG0hDxn9riaYCiPLAU2Gp8EO392oSxAwJI0Hama65LwMNVY55LcfpbVMkcdYXx5zMNefefP5aWuthF3ur7tIChpltW1A9rH18Yj4bVCUXY5Z3WWcKZzlGl0TBtjMd5bmDAEJuAHVvUDLgWu5Q55y4zJpwVYDLvXtLV6u5yaWWrTRafl53vGBYoMw2M6UEyY4e7k7jqhby)KZO2v(4ZtCgrGA2acc0ABIxjKPgKY0Wo(zcmxWhJ6BHuWA5XuGvYggG(iG)Xgu3RncZ000aRPlufQ1lUClnUCbdtPGb)rj4ca7Ljxq0gfbxSprq39RrBaqvQHLC7imK0zibdMGPHGMAdlhFWTIrjyWX3M9KoNhSA)c7gK2KlTfF(3XlzZXbvfTjfQY)KcKGz(CB2RJn9icor6yXIxrFkpwnvAmbMDaC3EMJutJxobjGzYGpl2A(MG8ApMg8XjZYiRfGA4b7zetLBolaTWlBvlFmLzGZF(AftDy6c7bp7IOoCkYUmNNxhpbqVJHP)i01zBKd6dYvMYAcH9Gefa5ostIDYBOQPjOhfmU1t3X3l1q1jc2JhdfFRrAqHwEyVp(ci4OJxvhEMPOzRjyQiDUJs1eq(KxiGMdO0fTNW2vZ2Pm9fgzT(0wDQY4qOFEH4MOvlWm5d2Vy6OvM6cvIaFBxmJ(JAp5NZicl8zwaKUzJ7i0HScjDDnCXR738w8y(I4Pfg)dvEAB8sGQ4vRxEtEqlqS1889bZqm9PRQyggyeKWwzC1cKH7mk7)1TZl9Whbkatnq674mcxrnbuQRU5WS0gSd)UZV6y0OHvO2iGp(M590cebOroT4RJ3b0JiUxMgG9IfigY8fFnBm5kParYUL5ZIOnPkP4Fclay8ZuO2VAORoE1BmcJa81CYfOoF9PSThoqDqd10ZhNUxmtOYgEo8OvmQfhgl0mCgyibqEjdnW)CnJrfYtxSMbkGCTWWZnr8ZwtC45alG1qBaYeEUXQ9zsgwWfiBmqsJjOFgAEU2oQK88o9skEV64980iqu((55rnm9a)Bbp2WismkEuFFhTHLRWV5(XhC1S3QSYNgum0(8KrGlsd9)An3)AdRTwgpkcANv383pn)LADRLXr(SBTSoErM7ZVvykOdVru3ZZapnIBDXwRe)AV(wlplE17(xLogMSRA3I6)LWujuH)yqSqRzAvFRL70nmbG2BT8VFRLRHxxMnATk)6VLNRd8cbH6Ywlh2L)vryxJxH)xamEkI8RO5KGgxGLuIzB0QrN1IQJRBy(yP2GEijPht(Tw(VbgXKESNw5Hgm9F)Fd(F2Az2y(Fh278Xd6i(Fil1kOB0(ErCgoFZOWw9Al32trK1f0LZblQleTcap4WMRhb4PMr3iQ5zP)2I(j7gtGLMwkJT4bU4iSKd3)BPdse2MV8jyHU(GDpl722suXRhC4G3)iu8u25xZ4SwwJFj7xyxM0L8DpS)J2U)xF4KS4qoiLPY9S2W)ZB8RoD9c7ZeU8oD3DhSZ(N8FINvGBTdSm7)hpaZ6(Kbm1nYp3wN1UqcaySAfljT7a0DXCcYPOlM0IgMjClCYtWIi5(3AW9WldO)4bd(QDp9oBprlFR8ZRb8)kbCBxyFMW1kEMt(6d6)GDo99E4eTcDYnBwa5N7VFHwNFnqureWLFP46r4dTt3x71PRy0IAo)Xe4sVZIV5fp)fU68VXmlmFqLfN(klsRbXJLmSewp86rIKUYKuG5AMeuSsyZorJxoc9T1JAgUjDxwJzxD1KW2GWdQj6SEtstazybYxjBLVLxkdSC2IYZZp3QlWnwlQvaEHTNDfqtm)cZwD(LnGw61XNE2q6TNviVvTn0pe4pgY73bZ0zlbLjB4fRdFTbDneQ7viwzg8THhA0BVWvM7ci6yXzO37HROGAAhUzZ4W66NvaF4FGXz5Rq(FBc)nDTSMBIaYtF5eD(3C65MBga7hCPfUWmSzH9mhA49xR5qDYq7Sw2N1WVaTLA(wtrNus9c7WePT0GkohJchGxTQlXyZv0K(IPV0WQGrZTCfMyochQFoJxIJHtH9Pujogmbm8J2mEImEW2NUhqS(m2x8npBW9)a(rWC7(3(P0fwA2zY0)SgALS68kSpt4QdpSX)eN)5PhtNzYrS08Zpn2NvReaNPwH9zcxA87bzXnJ2o7pQLMzE(bd)ZAvcuZ0OW(mHlTtocXP8B1wQeJbJG(YJKkTlynMN63Wensyu6rmTkS5))1J8RupIrg9i5rt50Dq3PFM2fIjE5R7W0z4jYQmDhyKInCKDYemL)SgwdR7W33Bknnp6osTOomzEAPrxPIfoaVID1sR4j9ft3b(UBn0OzuUUdlJc73yLZGj6PG(mPsNp6aEf4shXZN(e2N(bpzWF5q6KNZonW939M0ntA2zcm)WOehRWN22c6ZKkGgS9cwDFXnz35dFZ3lSPEelqNmtgy1U)zTTlzb6wyFMuW3dEA)dFOY5XDCRoV8ZK1znnlz15xyFMuLi)z8Kv1)27iuBu4ctubXIYpnObgEmhhkzeH1wlFvnh1Swm(UaIpTxbSh6q5lSj2EXlsS4T8ATWKBe1bLEUsCc(q4K0L3hECD41xjnV26kLcnpIuzNFAIOxavmiquDYUsJKouQkQWEEFyVlpPddjFpjQwCs(hH2HRL6yS(sfGIoPpoMSOLTEC9ykwsD6vniSB3Kgv71L9cpY(e6dIdWfzbp9v68N(k89NHwJn6qVoNuHX2zozDd3Pf9wJIf9lt6f7rSlgFdSWGXLzI5V1KTItwN9spT5sZEgx8cm30rZqZNDCoypaRVlgQx7Pm80Dn9GFIgRUbwycEEg4LYeEdvyZcCh8n4RWTLJgwlPMWNAGffa9n4clUzm)r6YGgxDCKadY0W(XFUO5r1dWTmL0WwPNehkP36YRtpGMt3WddnTe1Pwa1QebJOWZLfuFkI9ktFXlKHAGiwa6NYOeOs)VEqsCtXJ9Pk1SKwM)oiZF5ULekS)EbG6KgCkiPlu9VlQgOfK)43YqEu7EROn5HiL)qdx5cenltn1mWkzRLVyR6Gg369cbDAxM6LsKvtNy1PQsVQlIBqC4XjB4HE6MYrdmaa6kSWQx8Gmp1z(SjrT8xTqg58s)F("

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
	SetCVar("spellActivationOverlayOpacity", 0.65);

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

	local bload = C_AddOns.LoadAddOn("BugSack")

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

	bload = C_AddOns.LoadAddOn("DBM-Core")
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
				["CastNPIconGlowBehavior"] = 1,
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
					0.2,
					1,
					1,
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
					1,
					0,
					0,
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
				["FilterVoidFormSay2"] = false,
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
				["CoreSavedRevision"] = 20240912083714,
				["RangeFrameX"] = -229.7040557861328,
				["NPIconGrowthDirection"] = "CENTER",
				["RangeFrameY"] = 76.74076080322266,
				["SpecialWarningFlashAlph3"] = 0.4,
				["FilterTInterruptHealer"] = false,
				["FakeBWVersion"] = false,
				["NPIconXOffset"] = 0,
				["SpecialWarningFlashCol2"] = {
					1,
					0.5,
					0,
				},
				["WarningAlphabetical"] = true,
				["SpecialWarningPoint"] = "CENTER",
				["FilterBInterruptCooldown"] = true,
				["CheckGear"] = true,
				["NPIconTextEnabled"] = true,
				["SpecialWarningX"] = 0,
				["DontShowPT2"] = false,
				["MoviesSeen"] = {					
				},
				["ShowQueuePop"] = true,
				["SpecialWarningFlashCol4"] = {
					1,
					0,
					1,
				},
				["DebugMode"] = false,
				["DisableGuildStatus"] = false,
				["ShowReminders"] = true,
				["SpecialWarningFontCol"] = {
					1,
					0.7,
					0,
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
					1,
					1,
					0,
				},
				["SpecialWarningVibrate4"] = true,
				["SWarnClassColor"] = true,
				["UseNameplateHandoff"] = true,
				["DontShowNameplateIconsCast"] = true,
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
				["DontShowEventTimers"] = false,
				["DontShowTrashTimers"] = false,
				["GUIX"] = -92.32605743408203,
				["LogCurrentHeroic"] = false,
				["SendDungeonBossGUIDs"] = true,
				["VPDontMuteSounds"] = false,
				["InfoFrameLocked"] = true,
				["WarningColors"] = {
					{
						["b"] = 0.9411765336990356,
						["g"] = 0.8000000715255737,
						["r"] = 0.4117647409439087,
					},
					{
						["b"] = 0,
						["g"] = 0.9490196704864502,
						["r"] = 0.9490196704864502,
					},
					{
						["b"] = 0,
						["g"] = 0.501960813999176,
						["r"] = 1,
					},
					{
						["b"] = 0.1019607931375504,
						["g"] = 0.1019607931375504,
						["r"] = 1,
					},
				},
				["CDNPIconGlowType"] = 1,
				["SWarningAlphabetical"] = true,
				["WarningDuration2"] = 1.5,
				["BlockNoteShare"] = false,
				["NPIconAnchorPoint"] = "TOP",
				["NPIconGlowBehavior"] = 1,
				["DontPlaySpecialWarningSound"] = false,
				["NPIconTextMaxLen"] = 7,
				["NPIconSize"] = 30,
				["DontShowNameplateIconsCD"] = true,
				["GroupOptionsExcludePA"] = false,
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
				["AdvancedAutologBosses"] = false,
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
				["FilterTInterruptCooldown"] = true,
				["AutoAcceptGuildInvite"] = false,
				["FilterTrashWarnings2"] = true,
				["DontSetIcons"] = false,
				["SpecialWarningFont"] = "standardFont",
				["AutologBosses"] = false,
				["CountdownVoice"] = "Corsica",
				["SpamSpecRoleswitch"] = false,
				["DontSendBossGUIDs"] = true,
				["CountdownVoice3"] = "Smooth",
				["DisableStatusWhisper"] = false,
				["NPIconSpacing"] = 0,
				["AutoRespond"] = true,
				["EventDungMusicMythicFilter"] = false,
				["GUIY"] = -30.34099960327148,
				["RangeFrameFrames"] = "radar",
				["WarningPoint"] = "CENTER",
				["CastNPIconGlowType"] = 2,
				["SpecialWarningIcon"] = true,
				["InfoFrameFont"] = "standardFont",
				["DontShowSpecialWarningText"] = false,
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
					["EndColorI2G"] = 0.5058823823928833,
					["HugeTimerPoint"] = "CENTER",
					["StartColorIR"] = 0.47,
					["DisableRightClick"] = false,
					["StartColorUIR"] = 1,
					["StartColorAG"] = 0.545,
					["EndColorDR"] = 1,
					["TDecimal"] = 11,
					["StartColorI2G"] = 0.6745098233222961,
					["EndColorI2R"] = 1,
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
					["HugeBarXOffset"] = 0,
					["IconRight"] = false,
					["StartColorIG"] = 0.97,
					["StartColorDB"] = 1,
					["Font"] = "standardFont",
					["EndColorB"] = 0,
					["EndColorAEB"] = 0.247,
					["Height"] = 20,
					["HugeSort"] = "Sort",
					["BarXOffset"] = 0,
					["NoBarFade"] = false,
					["EndColorDB"] = 1,
					["EndColorG"] = 0,
					["StartColorRB"] = 0.5,
					["StartColorAEG"] = 0.466,
					["StartColorI2R"] = 1,
					["FadeBars"] = true,
					["TextColorB"] = 1,
					["EndColorIB"] = 1,
					["EndColorI2B"] = 0,
					["StartColorAER"] = 1,
					["EndColorRB"] = 0.3,
					["TimerX"] = -106.855583190918,
					["EndColorIR"] = 0.047,
					["StartColorRG"] = 1,
					["EndColorRR"] = 0.11,
					["DynamicColor"] = true,
					["BarStyle"] = "NoAnim",
					["EnlargeBarTime"] = 11,
					["Spark"] = true,
					["StartColorDR"] = 0.9,
					["IconLocked"] = true,
					["FontFlag"] = "None",
					["EndColorAB"] = 1,
					["Width"] = 235,
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
					["Bar7ForceLarge"] = false,
					["InlineIcons"] = true,
					["EndColorAG"] = 0.385,
					["EndColorAR"] = 0.15,
					["StartColorB"] = 0,
					["StartColorI2B"] = 0,
					["Skin"] = "",
					["ClickThrough"] = false,
				},
			},
		}
	end


	bload = C_AddOns.LoadAddOn("Details")
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
