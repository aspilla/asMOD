local asMOD;
local asMOD_UIScale = 0.75;
local asMOD_CurrVersion = 240727;
local bAction = false;
asMOD_t_position = {};

if not asMOD_position then
	asMOD_position = {}
end

local version = select(4, GetBuildInfo());
local layout =
"1 39 0 0 0 0 0 UIParent 713.5 -983.0 -1 ##$$%/&%'%)#+#,$ 0 1 1 7 7 UIParent 0.0 45.0 -1 ##$$%/&%'%(#,$ 0 2 0 0 0 UIParent 713.5 -914.3 -1 ##$$%/&%'%(#,# 0 3 1 5 5 UIParent -5.0 -77.0 -1 #$$$%/&%'%(#,$ 0 4 1 5 5 UIParent -5.0 -77.0 -1 #$$$%/&%'%(#,$ 0 5 0 0 0 UIParent 1111.9 -439.8 -1 ##$'%/&%'%(#,# 0 6 0 5 5 UIParent -1172.2 -470.0 -1 ##$&%/&$'%(%,# 0 7 0 3 3 UIParent 1172.2 -470.2 -1 ##$&%/&$'%(%,# 0 10 1 7 7 UIParent 0.0 45.0 -1 ##$$&%'% 0 11 1 7 7 UIParent 0.0 45.0 -1 ##$$&%'%,# 0 12 1 7 7 UIParent 0.0 45.0 -1 ##$$&%'% 1 -1 0 4 4 UIParent 0.0 -301.8 -1 ##$#%# 2 -1 1 2 2 UIParent 0.0 0.0 -1 ##$#%( 3 0 0 0 0 UIParent 576.2 -689.0 -1 $#3# 3 1 0 0 0 UIParent 1013.2 -689.0 -1 %#3# 3 2 0 0 2 TargetFrame -31.5 -4.0 -1 %#&#3# 3 3 0 0 0 UIParent 339.2 -356.0 -1 '$(#)#-S.5/#1$3# 3 4 0 0 0 UIParent 2.0 -526.0 -1 ,$-=.-/#0#1#2( 3 5 0 2 2 UIParent -324.2 -374.0 -1 &$*$3# 3 6 0 2 2 UIParent -312.2 -376.0 -1 -#.#/#4& 3 7 0 0 0 UIParent 559.2 -779.0 -1 3# 4 -1 0 4 4 UIParent 0.0 -326.2 -1 # 5 -1 0 3 5 ChatFrame1 29.0 38.1 -1 # 6 0 1 2 2 UIParent -255.0 -10.0 -1 ##$#%#&.(()( 6 1 1 2 2 UIParent -270.0 -155.0 -1 ##$#%#'+(()( 7 -1 0 1 1 UIParent -623.2 -2.0 -1 # 8 -1 0 6 6 UIParent 35.0 50.0 -1 #'$A%$&7 9 -1 1 7 7 UIParent 0.0 45.0 -1 # 10 -1 1 0 0 UIParent 16.0 -116.0 -1 # 11 -1 0 5 5 UIParent -272.2 -380.9 -1 # 12 -1 1 2 2 UIParent -110.0 -275.0 -1 #K$# 13 -1 1 8 8 MicroButtonAndBagsBar 0.0 0.0 -1 ##$#%)&- 14 -1 1 2 2 MicroButtonAndBagsBar 0.0 10.0 -1 ##$#%( 15 0 0 0 0 UIParent 584.7 -2.5 -1 # 15 1 0 0 6 MainStatusTrackingBarContainer 0.0 -4.0 -1 # 16 -1 1 5 5 UIParent 0.0 0.0 -1 #( 17 -1 1 1 1 UIParent 0.0 -100.0 -1 ## 18 -1 1 5 5 UIParent 0.0 0.0 -1 #- 19 -1 0 0 6 EncounterBar 0.0 -4.0 -1 ##"

local detailsprofile =
"T33EZT1r2D(PzR1E2iM77hQQ8hKsKYQSePwbQXzQYfV8cGljreiacEiAo7mSKTODOT4eBNr0I2MsHET9i7eLk0s0EKQroZ3hcWVd75r399bUaxizPA3)yN4isc0pp95XVZPpD3lPV0IlvQv7MRuREe(RDwR5gbHTJAeg0Uz9OGAvA2yPYlvQxNOG2rH17wB9OQT6GFuBOKRewfktdOMZRVuj4xM3yP51MYyPUqt1fQW6rTdGMyLARIT(kHD6cFqVwvd7grnY)yVAvUEq1OUrv6wJ7Q2rDI6g0PvuLGkHvwlc)SgndcRh1UlvNQ16ewggBRVz31QvjOAVgRgfpkdBuB9qSTccRujQ(sZGJLg9GbsTkH1d6SjmewhhN8CcNUYA0bkm09TA2UBWAWKnOETgxN6YnQ1OAZn6WZ3M96kMW4VLygVEnOL6TEqZBe1oSEDyIVE5WUbindkUgmYJc7Uwq3Mnb6yRGnQvT7AlnVPTMQx72myJ1AUuPLkvPEyNoevOd0onBxTd2NogCpJ9OTUVTPUHTyey6c)Mj(B0NzXLbgwZRB54QQMS4ogYIllSdxAhtvzPM0quMCBAdySlkTOK6Y2vuoDzb1vnB8yEuLn5Sm70lDzH5MNQWoQs7oIjNHD8SZtm70ZFmynQjwoeb7Xm3gQ4ooJR0QcJtyQXh3A3WLob1W0WtFykYWvXFCJhxzX9ef3zKR4dvwBx3XSqo0AtcM7CgiMQwNBBp9XWNoutBnMcNPLnCShdfFOc7mo2VHkDmbrnm8gDPhlR9qSHo(JI3E4Y6QnUbs2INO0JwTtwglDnJrt0tlT5QpYrEgAIUM5OxCY0OgJKrnd7HUM1yi0zv44AoosxMMorHZHNEi2uZXjVmePWEmdKmQZC0hjXilxNTZyKvYUihlRmu7ourTgJyvgoUUObWOqaQqJvB3SxROQOPz0GnyqTB9i8dBunOtuBWuBqRW2WVH2PB1jiSC52r3OgzqhB8sB0SD9QsBX16e0TDyN1OcFJwbHDcOoaB(YnBE91dBF9GUrVdaaP2VfTAdw5JruaMJJQgaM5H24ga2cy4AzVuj4Vaqm1aCfb1JWpVmc1bqkqLNME2zn(3bg0xFiOfJakvTgD6g2OsuNG1JA0lOsDe0eGvOzRic3JcWbrZAeTrL1G)mcWfHZRorRcvRlqAwhOADdk3eqwSrTwacmcvcsw7evFfGgvVjrgb4zHuJ1OxRG6nxfX5uo5WqcbRm0DRvB11Qd))ur4jjufUXqqlLqOulvA12rWGTu5ERScmKQvhgYavQDTOgvRV5k1AhHDB7R3SDioSHgIlzRETBbqtlbyGQd0jOf2mQE9MBGLE9qSKTbsCxS9HLXAnwnyTMTR9BB2OlGFB1WwiNjoQQIJP61wVgk54KCUOip1Bw56mJgXIG4wRa4uBa))8uRXMbDQ0SnG8mQthOV7KMOaGuRxRmVEQOILB386alkYsHW6YWlbmOahkU0vRrqZgrbcUbGSriOdBa0eGp)61eqJze4baeCyqayPr6lmcH1IQexhmVflJSSMEcLP6KeMo2YmcFzfNruXoRfId9sZVW8Zk)iwkWda3McTDqYoTnaZhiJD7cK)okVi6wdeuj(pGC2nCPsxAH3cwpBcsplvAXfUc8faG8iIDxcfwdwS2CP5pJoYx(o0Axzq2QA7MTsnTeABsPQJKuIxdxlI4jN3WKiLHRdSrIPJPyYTsyfG)zoGDzRL)F2lSkom3A5fHjaPbO5kRatk2vbYJfyrci53iKe8HgPzlYRHaIaqlzOtarR3S9MbWhrQ8krRxD3Sf43q7ARwRbwBJH9ib(X6LBwVdS20RBZyNCygcwjf72f7PqhWZO1djINyWXmuZzzRz655A6RP76BA4U0kNbWtNKFVxRwGpwsfHinwngPHMCAj4KxmXcv3C0gg(osTHajPv9Wnb2DWHUWA1ZTjkrmZLMT(nU2fXvxw2Ohk)x66BcECfH9IY5Yr6SLAfK44q9IDYDTSBoQh72S9QRb(II8jGcBOHiv4VWIt4OoqYWHAxOpifd7u6sdKslEsRJQjZOf)0kKHLK4QauTQGwRUGR7bTUX64uiVVGS2jzAhNWA(YEtP7BOMn0VAg)R8CYdWIglnwowAKKWfs7OZJsINIh48mNZwlxkc0rvR7MJqmRniMDdoMeRdFtZ1dAGF7mj405XlmddcA1K4sA0S96G83IOsM5oJRULHMPJMHMp8tdnqsXYcv7mNJVNRMPMHLNTTLLVd(nisILMZt32Y3wZwZYtZZYYd)gW2ooB0nMsZYYY002Nr8uQdq14odfREhwtNGgG1qtJNl0kamO72RdipGKlYmpg7LocwaazNbkNcRsOidwJgQccZ21ulpgsDJGr2QKan0dLxnOnj5GtJv6vVE5MTRcYPYghNc1yPnqTNaSe2(0cFq5ED7IHhzScbiYgCSHd7akEsLUiQVezAF7PRwDHgDEBXQ7BxdnD35TtwLobgkja4ZGjoQMRkamGJmePPdJVdOEmieaC0iy9EG1WauYa4AjBpZGl2BaG6qKrSDGoBuRBL1cq5FmIwDqlTjMFiuQURbAxxLXMbDnnAg6lBJMLlNynyCSSWOJWjqXWbwRqIljnMDWeUcgqmemgHLajDvJ6aCcGuil5iQcJ2PTsKgxCrYumeYGyvSag521Gfno(DYvzXASmKEsIpZMOtmjRsmjMObJeSGH1BTwi(n(guPkZ4098sOHyyQXfim6cwOeEbPlr)RR76OG)7Bj0D4tmtm3iUs1GGojfLtOCUwdqTEhIUbMK7r6j1ipyM0cAoPf0AslO9KwqNjTGUtAb9M0c6pPfuxBIl5eV2OpXlo6t8QJ(eV8OpPRpctYc1keZTPun78MEPKogn(GUcnzuVifNj0pxgJumOeRt3AvW4gdgOrFQq0tDcK6THHa6PdmcWrnkQo2UkX0IGVoUclcppQyH1ThRfqOVbDAJv3KLqyOieUeGVEaOwYl6nYOToBfz3VuWQpdbRj2w04X3RlqfcEUeknEjnck8PMSWhewUw9ADRHo3AI)nyhyDXFbTqjYk7mHTlbqwRI1OseAKc0Bn7ItFXlvkO0ItV41knZ0xn4kx6Ax4IZhCUlTW5EtOVjamJUyx58xPKcRc2WJVKcNmoxXGlXI93F5MvzK6WFmhHcC6kvGLm0n3Tw(kaEE8pQSjxIPrZJ08h)RsD3SoZqr)Lcsj(x)gQHP(z0J3sZEHlp78l(CmMf(uVO0LIjByNAwkMd6VCMd8I4ZhrFshWoPgWgdnGbNRycH(4h9iw4OvMOvIUPrXjfesJvinshjSyPaFkqJNb8tKPdqlJQeLbplRmSLs4xdHAfdWNbIsafsRITzdWRRBWZEgwKe2cP(eKDruAnBWIH8iifWR4aQiMEW046z(Z0t1mQjIX4MQDR1GRbma3Kbo2PryloYlaihfOhhjUjzxO(kwBEqLEWSyDm6oeINimyJTBa9CcQqCGHyNpSaNe0C0DS8CCmSnq)iCCLH8qeJKzwyXfx4Yx9Ix4nY4cUYvbymTc5HHAWA6M4)XE(c2u4v55C00SC9b3xm1D0CSTXqdyHR7J6Bmh130v6JUCamQ9nM2g3jZzaQOSjvHFAK8XLqNsOWci2Zz2(bPITBto(ESUz83ibikSrn7IlkZRjLMVQSDc6aTDDkmFjB(4pMMlWaLcYbnrq3LR9oWcBHgwLTPWgNqgpyZmFaGuoaHolIJnVzVQWVMZ4AsSoQcrGGGphk7(2GxMgtT4IZHHKoEkrsfPnflhxm78qlAYHL4R5aA()cJXP(VFQTwM(nZFp9dJFpOpOz1O60IuVwTazb6Vb7VTIQdl5td6uNPnfRy47JAFbm4WtDzdmKbBex63cdD)Bp7F)vME(sxCH51mE7ZVWcNF6Zx6Tbv4vdB3o8Tp3cx68tF1RonOF)ALMADdz)PKiSLTzsPr6dufrxwP4I0nDay0J90HWmmzgqs7pea6ygsJ0wlBKsdPOpejnri41l7vOK1JP7DBh2OdGSHP8jcPIHE8A3KjPrrTFtm2YcxotXmOjLxi5aC9KNPZGt0zW5jrEOkco4EDuXNqptM4e5k3jn5(dZU4PQ9KnAjHdmULK8PySvMIxh0qVMmy2k1o5WAtF8QTbW1Kw0YYwHxesXslYIKyLrYvGyrdCcZ1pHClzrlwjbv6rkYQ0tqK4g9wVmy6BgLACDLSwM2x0R5ibU1YVMq07Vrjl(F71ZJn8nel8DAHWBwmFLNrD3a3TgHELuZQKQTgNoP5ST0nSTTnDCn9m1mXGOzBldhlYSm8y78)3RvPBV1Zvh5eZABf0oI9Qt1mXBrvIgyoAVN6mhgvX3(Ax8mI)(sGtzN5nIRWWdLHhWa1x0NVEUgBMeT3nAQmAsSRcg401jRTmvqQxPqSQehzs(jLML8LcWC1kOvhrYAfZ91jQvyBa1uBzGQbfNvOqOlW4kqgWicKBwabsb(dWQui4Ozc)KKoJgh150W3MasxIGGgq7rOqZSdv8ZyYBpyyzmGsiKHYdHOto2t79BAuLuGhR0RnOTH24G4qaKv)4m4qBgmAqZGEhuwkSbWSr0fHmC2Ud54F8Mxfhapr0VkLyV6uTqjLt7j3XAOpsRHadm(VxfNFmJ8inMsgGc4DswT6Badtv9MK9zmPtg6trGn5ish3S0MWKllyIUU8QCI8LEDJ2f)MDQvjS5)pC49teqxA)7vmt0KH(KffkFllvhtShBaQoAf2AOTLkfQ(XaaHYBWuIoPZ1n3elrLiJRcmfZ5PzyRz45P76z5yWuiCBTOSBaNTjHxXBNZCw(UE2(6EU6U(2gAwm9M2yaCV4XD2yipd3exlvjGbP)lHg6lEUfMV0BFX5)1bGNJ1QhSiU1(Rpo4xe9wfH(K7ihfiUCcsfASp39riBC(ZGTXqTxKISDrM6B0yyOnDuSPBYpCL6HRYJlcSbOfOE9rfDqSoTRXzts961QsJoX(YSPWNRUrHRt6KezGAQmp1ooXbW8gGLIf6akNaNBInsfJoXqZH4ebrSh3GN0rGmA9QuOcQuVzpatqylYO(mYe0a8p)6rncqZJyge0yvAEsZyzoqGBhE0gYT6MuJTym(wDBV4eeGhxvwdNCGc9ia5u1mSv4Nt7fiat7DsIQDZK)rhyKO2EDwCtMLi0ocJbm0qY7MoNImO5kUUTwTO6vfBveBzvKOULEJRn)IZE1jnfsl9wGlmxCHRor5sBPRUWfU2SXmIGQklhp348ftxZp)SLT0LN(cZMx(Of3edxNRm7IfxLmjrwPZF1RDXZNinYKdjQUw(w6wA5N1ELU8cZ)M5KeCo(jRs2ClR05ND6fFJ3CEkujtEY1IDwPXTmLzwDLPV00N)IZpPz8wPRn)BopaOzItPVsx5QxC2sloHlTdXeDT5VWvx4Ax5kxA6Ft8CAc61PbTkyKbhz)Qbwa8CbRH5w9zNF2l)BMus45NfO5PfoKlUMJpvdl9giEWjKNkB3w6nM(Ytp)eWhNLMo7VEH3mXq1wZ0xlofrhbpminlc38enwZl3htGtFiTjt5iDS2Zu0ew5Pfzkxp54uMJgwMzvGitKdF5wXAPpKMclzHKCa(KD9PV6SZpDWVz2lDjftUEQC3DCSLwsIHSBZQ2qxrTeLqZkR(HuDMT)Oue46Q4kLdmZHzkKDNCa55gphVWvND2yUhhphLiLSf91YtdbrvzMAvoYBMNMHHatKvzWqXzufKE9H53SLR72sIJR)qsQWIOUUBshQMsthhVwQ9szyrvhlvE)KQLtAKWmZklryMF2RT4vN(s5XMKJyMKEy76O4p89O1SzV0CX5kUVgoo4LcdDBjlm)5m2BrA0bOyuUzLydfYKzSaM8o8EvyN4lJZx2GRhf1kOCe6zmGrfD3a1BIzByZUIG(doysq5xKDwHHwKnP5ayMRUAuBzIZzlt3zWl1wRbG(u5Gk5NaNRtPhW4NdGZ6W()jtrkckDqu1AKhQLB3mSAf(mxLaGebsK2Pd5VELMDa87oaODqtLNTjMzgs)LAhwTgHi0rtnJaO7CoiVbbeRz1MXEHsuLUQnFmzybIZbrMEtt81dFNrH8ZYoozXa90KlrCjbfKR3sU3vEjyIfPG2z0jLfKhgyAEVs7WvtD2XsV73ecog4kLrzQSwEgAhmQxVIizbxVwNkuerrF0bx6yFxJAV6MXaEzhvryZCYqsqTfo5qPr8kHG)gGhTcpkqbpqwmXIBlGDPcfd8Kj9lIDNdjICd0gkVgrovEOHCYBe2c5ORUjGggAprPtKdPyeK6qlczeeWCZtDSajrckd6O8eUDfqAc8F6g16Uj5GH03Me7cVmj3X12e7hV3WzXai4Q0rAQSbzk0dj1cNS9AH79d5cAwq5WkwvrQwNtSjWmlsMVrXk5sevp5aIwmeaFOF1m(xvU4LzR(OvFGK0Pz7jjSiKRMQO4iICf4tue4OeNQIyPT1CfHq)mM2c9OI5yCYcMvRRerGPAWcRVL5WqnVRylvWSGiARLlHjZUC8WEuYrFinDZnlrlD6U6ME9PBy7vLlrXzFgWu8wCzFd6hQapaYB1HLWBeX7MN4trvKnJtIe1gM3PxzkSBXrgzM4IisIvQGGdWGU5QIePhlXOZD2jpqJIso292XunZgveCvu7cYHckaQS8yzvFlOfwKIZARJt71J6UgNdbS37OQf1qmoAkGr6lDPzwyH38TPnHdpTlN5kG(QZORgXInEwS3PXTw8bqvFP5STbiZ2gMEgAEgMwwX7ISNPHHJTbGP2dqsyIwqSj(X5CDCT0nT0DDnTD09n59cG2LandhnDxlBFndttanHy)LzENycUmwwLUkNiI6iM9sxIenDPZ5iGvkXFmtII1n1ujPYhVmaB9sCwc6M9i7mUe(uAxHp8YXwvyd)jdXdJTxKBV8wA9CUdyY(cdxS8asPsr30wysgMUSM(OKMwKeOmkLvR3SC455n8dapefEDmA6CCNWWTqFm2R8N0kSAvmEoKbeYkjEQBQHGGuP7nTZPXvr(5yUoK4JJ1cNE5rt5bQe(SMDYt7bm56ef3R16ehb9eToDuRkqTSiyOuTIBqrKnD98988b(uxhplhnpbYiQ1rdAj2LQuPkBgIIejJPdYpcAjvaeOcIymbUTo4HPrMl7drwjT)tOcKysqAf2Edr4sS5cRIWzQvjBF2rzzOudX5girLO0XwM9sIPPUpPStOaR4YZhgGw4MObDE1NNAGB)0exEkiZfxydIbRnMQrfxytrK(ZqwLnLV2qFLGQ(CqpFLto5G1p5KtlRx1KZKAiidbfDeWyWIeaKCj1ie41e47lym4s0VjCTH3QNxGfN)VoNRHGu3G9PTRuvu5ndyhh5D6Kuwf)TfQOkPM481HPYEfTHxXsw7HKB4nOYY3Wgm07y4BQ5AckB5nQlJ(BvPDT8981n1SDbqiwITMAyBeso7HAOKJOH0qsAgv1vZmvdN2GM0vhPJos3C4eJyOXdcbC8MbsanwLuGJkdnMk(KxOc9i1VdnJK29STC1S8TmmDCCrECHDpvpLdkZrNXrDeNUVH7UuClQgxzk1DK084TR03WsZrx31uZWW1qmqhwtWyzEyzGImjNJKc9vLZzuob2vtAbiLaAI6okTmfu(CmbmP1qQxAIkVuVurd)u6LkOW5ycGfjIZRRrWYNKTjx5MxmlbHLbF7hEZgZvBT9lI2DuDB4nwDsAFv57mbL2IkD070kCIqbO7msCdJD40RfTzZtW4HOovAxRBouOXohMuJXwoVagJzDftS511Q9Cq8Fjz4wEsvsUsLdEhHYBWnBdlBnn8FSnv28YrpKiyRE6XU82oQchGy(SgkIoioltLhsW3vV2ki0aELKcTy9OBqNZao5dCJdLrVvdA1oQATkyIWWY0IiMYjDjAiaCQeCpfJAuVwymk5JGefbEkGa8ncgmWgC)VT)xDWwl3)EpBWhS7PV7dHfsDBDChzkn4b3CW(FB)h9S()PNT1YdE6XdU)NaLtwcWy5jp6Np5XBF6E73)JUduIh9Fav5KNCe8Rqv)OVbQs)V9jYYdURn4GF809((bp64b3BFOpp67LFNfos(OtV)UqvV93C6D3hkJ87ig9ARVoVtnGN614R1SAH1JtT0gTQuRAaFWiQYrRcjfNJYekoBP5pvEXlisixkliIQaye6cE(h1wKyfXDhgNumH3WSuISQXzufMXcYmjrrnXy6H3iBDblwvqXgmqtSp(nBwNUi16GBbGRHUVUhE5bvc61MTRXkq71GcfHiQhy2vSoWBbCw1BP(qDt8yZjpzlxC(5wiyXRT4cx9ItFjDMhpQDx(iElc0uzeSszoFJbusLteiZUjVSwKdey6TWVE2Ro9LU05NEXPdERPV68xC(lq(gx6Y4raAHlpZ0lgS4fV8Syhk2aTGWgnGzCf(aYwPB76IRxfofps26V1fN)8l8wb4wTfCT5XFqJ8CNtgmOmmLzA0rm77kcmpE2KXO1NANOqjKncB3aVbtQvvNZXh(kRPAafyM6WC33WC4Ygh0EEtjKxMbQdmpLJCISWSR4OK0ffJZC3o0vLZoI8ZrnCjX964gsbiHa(tol6zwMrXOyzPHmk4guiYQY4lcW4JQC6R5a2sLVw3iA7DaTrWinsOMiyXZTWmIDxHYfZ1WRkgAt7exukusKPKaKYAOGhjRr62Wm8bT8deVQ4nUY6aNkNluG2AnbMHa8IFzvmhNKtsu928J8R)h7f1EtX5orSzHbcbjMMtWkLh0dsZ4mkciRcyKsAX1HbNs7uHFI0cyoBxxFFpBlhlmmQA4z0X0ooDaMZX0tZu3ZbC9Hc2k(9EXBw9C2wwEGfcBWeGRJnzQW0xKdaZJkYCTNYadOLylPNZ1XsZZqZYZXZbCQYw0Gj38951b7Wwt567i2ZEWBcdkTkDmnHUZuokKBE98(66EtzHjDvYDEg8DZdNEA2ow22EMiyDOUYnVFoBhdpDBq8YZeAuklpX4RXzsamZn9XEZXYW10tnqfB38CUM6Ag(wGrddGABro4OjZpI5TC88TNsZxyNnELfzzyRBO3R81FZOD6QOd8UNYSlFffL5QebViKwnqUbVakUO6pFI0JGHM2NBTyP4CSmeZo64c8nEw((4nPZnIQMX8086jJezPt(ZpBWHF6wlFYJ)XtE03tBfCUj15gnBxnGsRJ5L3vB0o)xcTx)XFoys99E44AG3kkSfiNpdOouZvEG(fXbfALt)89b78NENND6EhV1YVw)37Zbd(qJ(tFp0OVEUTknJcUC4Q1QemhUKe1EomM7I7aar0vhUTpD)NC69(kazWpTZjhDZ8B7PPncDZGs9wzLM4YH8cdG2RVCB178maJZ4gPt3UcWqeCzWoYLPW1SP8YfaBuNCB0p)odU7ZE9rVQ0dvGohYtmxT2rLAvdGQlVjcWw1nVwDWx89d27oJFIF112SzD0F6FDZ6WWUP8wlaBuVCxX(43FW2)W4B0ZHNImCF7VsZADaMbnd5DCaXiaAPSzYWVBrDtpxtBZZQBH)Ng8)X)M(z1nO)531DRLzYdbZdGyo423JJQoxv1TIa326wCoDbTTfOJf0zp(2U)pT9GF6afQZJ(zO72D3t)NFc1hIMqDFkW9bOq3u0hga0vn3X3fdU729FYU9p8tquS)LhYZJV6Oto6D7)EhGyuFimRybeQ1u3jdK0lOu3LfHhS)7E6(i457DmijMzfy6QGLZHIXdHppepjh1rTjR0vDloWZe8oPkMAzdMhkyQSZbd2z)t3db5)t380D)oEY8fhn4wVRKGzZo7XxbeQfCVxUl42jABF3Kl4AEfmfoC7bh8DYf8(F931)PBZnVMUJHfFnokLwnDDTSTJxRTm1kO1)myyVliTa)6x)ZWV2)p8VlxATm5l8cx1yha3yjPlGrpnTcA9tE8HN(zFl00FeQeN975VEhuL0F6HCVyBaWuwI3rPeuinjfcpCf2wfq9)4)Jt)x(dN(Xpei8GwFEz4E3809pGxI52G6ePmTHUfa2r0j26(MUfSk0)O70)(7cCndEe2678V3)J3vSky4B7X36LsPAxxBtHY47WCf9F8XG69(p4dNCPGY1B2SQWK6s8r0urG0nLJDhBnhZceco54pL9l9ZoU)Fc(5PFXUGebnUo9lUfyUHMiClr9KrS2jFh34fCntF9czw7)Tib6WdGEJ6cORhSZHsAf2elX3OEkzAp7KAan9ly5EWX7GERV)Eaz99Fs)7VVs2qSKiAfQBILPDXJpyc5o9IuDaU8dkUU3pt)Y(KD5tV1nz1U3)VkjBwoA(2g8LEQSVa3wSnt0x2Uf0x9VZDaDs9)2J7)E7ZeTJ2(0BHmZiN8tKQBT1T005LiNygznBdLUkhTcf4bD6)8D6F0b9)Jmlq)D2rOTYgGiZxSVkIgI8v04WV7RxqJ3)bFlOPxTE8qHkXydgCJqDIuEhyX85CiTeOT(KF8tKIW9F6xY4xad5VUyiIBFotStyDgCijjXUqE0V8tq2)7I02JEOu9btGDnaXzcfOYcTVlg9MxLmoM6j1ERR6lltFp)c6RJ(zWYC)pbSVD6(pfMwN8Jpu06uTPM3iMxbd)VqPNPTTFbM1g8t7byNyff3(O(V7Usld2ucEJ37OCl77PziS5FR71)F797FiO0hwkbSyQQ4rmUMwjSLhBPsxdCV0TqKpG8ozlhgvauKtE6ToD7NisztQbOEWoj10pjNHJDb9WU3eqEZRzpyxG9fM3FWHN((hifq8emhsPpWdwhpdvxaajmlAbdW4UZ3DYJoI57U12886OJyKdpDFXQh1uuFflm65BjrLa8oE6fONS))1rd(QFGPxKvECj5HuSfr19G5BxMG5PMnGN26kDjwG)1fd7b4p2dySp9EFs))02d2(EkJIcyOMXcQwgX21Xg3TqZw9VVy14dU5GBFi6G0TeyFmHvCQ9T0uJEG9wsFGfBq1vbkcaHYb7)nOwxs0eSo(PhYAF)ZpP)F6FIxj8Xx(apQN0Jx190vMS8mWtbAH4GaEl21UF(wsZI9)0V9Vbx2)K(F9dL63mOtxX8wXMGTmnSFPr1aPq(YOl28lLM2sDcEAwgfWv9X7o4Uh1)XqxCmZoJl)9FW30)7EcysbvBVD)pIzJ52J6pR4vjtnhfavBhnNIKyU7(9pCN(F)(GkObFjqep9GJbIj0ZqF9V9DaGyHkgQTOolgSTVxS)c2A(wgfn7i41qNERD6)UpJ6Jb7T7j)L)WGhi0AdMiS4WnyfRfWW2tzVNyykYi8HiZW27G0SVsyg(4peeNsWZXRtUjOBgwVcOBjzWvqWbdtCgvxAWtp8079PSjG7d)ZR1SXwlVzZET3Az86((1Ni8SrLXR5dkCuy3i1iyP7zBiHxAa2ukYYk4c3GTpyWdqLM)NiYpws6hoAWximdqncfteLAbmVqJbi5JHHQajiWeWh8h4ffGob9YTp4KhlLGOgG6b9K9G3RIEiHHBtlJKkbkYNX9E)()B)md(ApuVFmdm5VIp)8xyQAFBq3FmisdWP4ImJDe4chHH6KJ(NOTU6Kh)JGlys9y6mcb1lGIp4Nxm7RRrr2j7)XBdkgj3wo5rcpTS18S8j1JQhlfdanMRcXemlS8kMf6Epbbb(DGcStF3hcYiaK4t)ONiCBCxG2HY)Vl09cjESvPEvb62bOGMXgkTTmlcx8oiKWB)ni6Bgs4nhC47knLbAP4N6e1ScdIsmYf)cTVa(y9zy73)27WgZ27osX2bhCiSu1)XFASB98sJxm)RTcLVVb4sErXhc4wpABAnQ)Nk6Kp6P4uAhwVp3iuNKWHBDhPQyDD8svWOyHKBJ2t(4Bp4Pi(2p(dbF(g8t3rs1mT4BbvTesj2AQvfBxVc1N8E73)HhZUNiC5y7tV9njNK7)x3vgKcrBrDMESidUXksgpxh7IKysT7VdU3Zo5X)a0lpANbpazhF0NdZS(pt6AGPHhzJr9C2awUCDz6xc3jKE2)AwxzY0eZ5B0BxUhVXFR0oQXVfpborTTM6FO1QPE7MSmSKaQ4Go(83prT7r75qMEqbgWW2vtk9cQUbPQIc1ZDEg6yfrc3)BgC3NrU(WEgK1xZew2uVWiwWIMzSMotJI4c7V)drPNVfDf4JG)P)pCZuXpKBJupjtyQUPRNKpSWaUsEfE6(YiicoL(RA1UzLFvm7h7BJ6P)XYq333kPNI(fcb9irKO(rqmL7OTpe8Xj2DroKjQhmiQpCE10h(XS1wwsAfyxY13R4ik(b)y)J(sM)NWvp4W96F4tfXn5MdEWnzLquRL6Lhcw9XyAkMrg4FvKhH)lFJuHWGN(S(Vh7FaGNU)9oewKAh1fKK4LjtahnL9nXVerGdpyIeghn2j1pbmM17)evSmV))mUjw)z4lETFfMYb)Qxxf7AwhOBSAcmllJDXxxRig8t3JbIa2Y7)93P)93MaXJC4hUhIzCFqCc6xSBZr0FHrk6lYnN29QvnOCuy716TAq56HvU(gRvRBKuvGBSYgBDpLHCFBBFd7jX(agjWpFFG8GHO9Gt)GFaPrHnJKKia0ahKf3yLowXiPTbVF8TDkm2VyOC(qOpotSFIj0XqYMU2jx11F5TQRSBBqYoUX6zCa)B(LQNbXZ3Rt0qQACJv1GxWOQGaBb8ufgR8FyWDf25oCpjOaGud4cjGoUEjiv2juh7A5xiqQ(F7ty4Szf456tTFc1lW6JAT2XTqGAp67ahY6F4NGUL9rFdTGF6ToyWN9PkgnXKbBlAZhJvUydEy(kwvMNEc5fBjxSJLJJNzXX26rFp53((YGkJiG(C4xLR94Rwh2jj1My5(kqBY6HD6(CPnPEnuxs4QaucmDhLQp8sGvX3X(LG6JmAn8I1Aai8mvCswAEfTRld(YpHXVghZNbF1rdEWNOcLVhVDlE2j6dhRxn9HtsdeoVcwsXKX95AjfFSWOlAwkn8vROUjunyeJIcr)wKNDyAtalLQ9w00fp6GyJMuFJv8w5BuOQSb37trbteK5GdpO)2Fd0(OVVF93rAha4OXHJKfq9t0vogV0uTz4XmK(ju3OR8reSD6doHuK2)7W7ra00)1D4n0ha1WGxa3zCORFK59JvXyyQYBGxgOLWln7nYcwYpwzd4lVESDzWLQIsfcWzxW9T7Y2lp9F5M4wo(GBk37P(h(LajeCxqA(bBrQlntyAZu)LQPn)yfgUgkZbaX101ROOc9xfR7p6im6q4E)HWnoyBq1nhf)DoavwriSF0HaLM7CUTPoxfweD6JsgqNIOL)H70)F9NpD)BYrx7XB3)PFPqkYr3HyT9tQdrTteVm1H8Rq7ccKB2MGeeDdSmVVsNGjyJY4vCMS47LC)J8EzU)rgggCKE89tmJS8FLmJqDMmBb(CKepLC0F5ULy6I(iv6jy(QPpu6kaWpoEj33n7cZefkdu2(hWnb74bhUdh61)4oX73MTw6hhwmvrvwGSPl6ZI2zzaa)NVNA)Rp(dh8pTDCmens)mXAz5BP2pmBFla3DrBh7TE3bF0tP5q)h8Td(6NrNxGbp64t)87KA7dfTw6h4vl8eRLi7Dm8lIMbok0)J3reFp(8mCC)7GQA37hLXsgBfUFuAhSWZ5UCE557BAAu02m)9W6oPIJ3l((F2Zo5P7cgejFEp5P3cWMXtmU54ouPvW2aVshJjKa7xrHhFx0YW3IBG1T(qelCmMyfbezIP(rbEawfv5QhwcJImPdyZWiml3oUhEmmh5Cr7HhFYtocqwKiK)CA0P5htg91I37kGOAxuatF0UN8dpbwP6)VcyuognOG76d4r5pDa0BsgrpbscDvsiI7OGY3BBpqsWPiCN)LVbd289VP0Nsf)49VJyHIAfUF0J7hB12Xr8OfXzGglaFXUnUjT8A0)73pMdxWiONqRGPkDLyzGIMhSMtkgIp5o4wb8GBo4NPtNZn7F))qcHjXurPBWcXoKKxqZV4nE4W9y0x)WrQWJ9umv4gS9tOJwKO3qCduVPuvyR5Q20uDW9gVIcrpy9MbfD3DhCBXMA)4dhSTqLkU)l(IPKs)GnEZuKumY2Rq1Daj7037BOard9dUPnuVsg050mauBAX5ENkjfXDI1jota8DTlCVaE8pE6D3bJM4bd27NLzzGOQCJ7MqnxkPunRI0AV3293zVb37ymip)jj279WKBGwIGLQd3lMvWsKDTXQf8nvyTE1PhxL6IaxUHF8MbA4wuwAK2Q0GN(59p8Pdr)mIvg47PsJclBh4Vkc36JFgMBT7TpNgsFWpG4Yp6oNEZJjUEcW3Ns(xJXZI2Uc8sFb3xGW6IW0X9dps0tOV106vJ(wpnppU3ukpSC80SFflrBeJTqZX)vKeTrSAdB)ydJM6(A2(ts6BY9dzjotuVmXBCuM)3ibUcFBRu8)fjWDW2NExoPSh8bFvcRtIAZTVtsRg6PeOnlwVeOj6l)K8mRRXHTt3ig(GRTcVQnE4MkmP7sG3(JE4P3H1taU7EIaMcLnAUcgmVekX19FjUKZnb3j(jvTM0eREHBi(3VZGF6oGDpur4hj8D(yCpVE0UObXBfRksN3gCDvUrc9g4KwktgfL7Up4MKXbbczYklHrbt8M79SKmc6Iu2wLDKaop0KV0Pwn7I7T4u6caMm4(YTZLQk34XyhC9vQ9OU3POvh6GLGQWFkAtklRMRdyis8iuAMaPQA3hbhR9ClkiL)4dXSQtS10q3iDjNVrYGMo2BcZ4u4Grh5vCIadq6bNGUx6ZqIO2C7hJoq3ZjPvoDF3cZjHto(ywk)RFw)h(e0hV7EC)V6G4LyFM91mHSUUrAyvfHq8)8jG1se(bLoA39HdatDzSZzOZVDduxfl2dUSANiejf1td(SFCWE7n4W3vK)iVF)hRCB90VC7(F6NOYHp(8dPhNyLGTfD9xL2uhYkQzsncXEX6JhwHc77dbn0KB542fiLvbRDh99Y9Yv0q8XMjg6aWIKWLfFDxVjex379WynCk(CmnIeUffN7LwUwU6Pafu0zZbZg995StsntU99izxqAnPkhrYxQBfRvWWiLcoJjbm59EgkyDpmBbEV)d052J)q4Jt0lSfoRyNjC18nt2lf5QhRH(KF8iqYIPA)0UWAwCxylU8bfp1mbrVtRG2H1QgF28PJCjaEKFZzWy)s)0K)jg5i6V1PhHgdy9M(jm45Vh0vsFUNROE(8pD5)gaLY)utuoFn(qxF9On70fpY0XpD8QJXDQJJQ65DbF8ewRwxXX3gFuJUru7RxtErig1lGpDRQt16iphRd1b41GG4szgiqyP9Xgv3I(xt6FnO)vN(xXCi(QSk(EPfV9jOh5i1HQhpCV4tDbFXkjosSPUJge3GUXxwR6XVFM0Iv810ql8e2sV9jYBY3a8Q8nXnhsQhkd1tMtj(aL)ojEl3D5UorRWxxrYho9zY)Bt0v5wz17guQbs8hNQsJ6Ihm5Z0BYY)8nFg1yzSZVjyiLQ1EENcIUPWzs6h8Krq0vtfrVSEqNnBq343Y7B5YBsxDbm3tyNRhiVQVNebVKxSKP5Xv3)5PA)rDNiWVgwPp640r)wkDo0LfrIrskj34lsu6UNHVYqY84ks)z6ZnV8IDxErZ7lFF45lV)eV6zNF25M(Axs2OYxgnXRtwQRPSsIRGm6(oPtxXnibo75HIHPbEbBeFjO8p0SxBWt3Kxukcj)nwlcBXlCTlEPZdRcHTX7VMeV(Z8TcoPWBL6Y74d6i2RU6PklU0iP1k51UQ86ijOgoaWCWl79m0gRblK49ae9o40Ob9SAo9VbVzYWN7l5R)f8BDt0CTWX9qTL8LYRCY2cVI9LuOQHBUuj8(0L1(f0aFaDdxLElJQuvEtJOUPG4BG5zInEvPzZ64AV4sSHUXXXRliCXU36nyrD(gSvC3VmJSVQMTYQlhg8gUnQrNA3i6mOUw(BXRCg(3Ak(sjdUSSQR4PuFkEvxHrZqC370Low5sPj5vTeEppGCWkbWmJGYj61Y50NLZThlh3FLZ8cUN8YAf701Js8wlNHUquE8Y6QMI7t80A1HFT04BDF(zwo9tULS2sgx6nSSUaIX4MKZ8Ioj7QUxBaXo6UIhzHcwJL34KAnXlZFGs)KCiaAwQeeDJM4fCJ6c3F4IlUT7jZW41wfxbQYX1IvwIP)qn4BivGDYTZxVv9EDs0oerlXfZFCJTA06eiPob64MswowcNU0253yl8HWQI4cDcOgTWl5MQNFog6kVjM287mR47iTXGCFxqnS8(2awmxuCrYqJZouHOhRX51D1118DXtaCPWvwP27WqzA3JRY8yc3iwhOpyohxdW)dFOZDSWB6d(jXRR65Btvn6YSfSpWFGM6gr4x2y10fZBN8hRGVEwPgSZ76zmLVM)qdpSKykuME8rNDCF1LMZZ74ul14u321Zl)XPl(oLLKMABR7AI75fqtT180ZNMcvZ13A4XSfNQ1UVW02nP77)1bBIRr52tU0wtlnFnO33mkSnEk4nSgMQklJAek)KU8HeKOTgzgNgtY40ibTfJ6ITNVAC6NKDfXiKKdWt3DkXjTXi)M2ort7b(cIHdjxsGNLFMLnppDppBptDdFFt6PzpNLn8O3HXEmJSGZeVCvobzi5G1hVWG8nZLoO7nepg8jUWStZbVdami5wJHhSqPCqA7qmzC6f8cT4LuWWZ2s3AKcWy0usnQ9W7sinqxIfOqXJVyznhZIzs(e8zlsduqLl9Xutptp566z7c2VTWJmRTt(lMg4bU2lpHqo1im(LQ4W1guTA5nkfCAgPh1G2q82SfpjwEU4MvMpliupCVqYzutwsSErg1Mjj1A(g24DqvEKACFrstQTS9nWlGxpdnnXBNAodAOEw4f41WdAkMkEVC03PpkErltAZNJv4LZquwMyfEIp5xMXUjBacEG46yo(bOSmXdqXN09fCvpHciq7JURM(iuazoK2snxBnDBpmmT2o8lfRrE2qaba9SAlZkx588YHI3ddMjugKrUYZmllkOksZbFPrC8DJvTpj6D8SmT8C0h1QMxgfp4fooMu2(ggwGEoBjDHUJYkaoKhi0P5nsTf(wzMvAGqLRMNJHNn(Y7QMvw53v(j7khdGgoQzfyyj7SYYvZX0Y2u31dtPc5SYEcSra4NCg1SYhFEHtPcuZgwGaR2M4TBymGu2c747jaUGpU5D5YbRLDLcqjBya2Ja5hBWCV2iGPPPbOPZ1eQ1lUElnHEbmQdcfd(JsXfq2lsVGSmjuCXFIKV7xI1aGRudp4eJaiPZqkgmbOHGLAdlhFWTIrPyWXNmXmmz1(f2niTjxBRMPoEZjnwQQSmXuvXNKJgmZNByVo20RC4ezJftbr9P84mJ3ycGDas3EMJ0sJxgfjamzWNfBnFtqFThBbFC6SmsJaudpEMJORCZGa0cV3qT8XmFaC(ZxlFUdtxyo4zNh3HtE4YCEED8ei9ogM(JWwNTrgQpOxzkRjK2dAuGf3rcj2jlqvttWokaU1t3X3lgO6er7XdtOV1ibuOLL27JVQdo64fUKNz8YS1e0vKn3rzAcyFYQeqZbm6I4jSD1SDkYEHrA0N2j7Quoe6NvjUjIAb6jFa)IPJwrMlsYe4B7I5L1OMt(zaryHpDeG2nBCgHoKLlRRRHlEZ1MfXJ5lINwy8psktBJxLF5pA9Yc5brGyR557dWqm9PBDxEfyeSWwPC1c0H7mk8)62z1E4JefqOgy9DCgHROMWsQRU5WI0g8vyIZV4y0OH5z8iOp(Mz90cubOroT4RJxNXJiUxMgaEXCudz(IpMnMCJuGkz3I8zrwMyJuIpHdaM4KHR9lM6QJxGsJaeGVMtMa15RpLT9WbQdkOME2409IbHkD45Wdi3OgCySqtjzGHeaLLm0a)Z1mgvipDXu)kh21Cdp3ejpBnXHNdqaRHyasfEUXA9zsAwWfiBmqsJjOFgAEU2ojz5fv6Lu8E1XBRVrSq57NvgfFSjbucUgyejgLmQVVJ2W6v6YBwi(Q1ME7bLHHpadTVyZiWbPH(FRM7FRH1wlJhOmTZQB(7Mw8C3U1YylF2TwgKTmNYxC3ELtfUqu3ZXKNAnBCXgR081E9TwEo8Yb)VjUnm5x288Q)LXTsOK4v3yHgZ2O6wl3PByBGAV1Y)UTwUcEPhxRXQBTC31I2AzXEDGxRtuv2A5WUIVkcRAZve)fqJNIy)YRpjQX55nLyUAnQ1zTOQ44g6pERnOlaD6zPERL)7GwSDVikYbd1y6)U)o8)T1YCB()aM7I2dQi()iKA5unAEVi2dNREuyJETut7Pi26CQYmWG68rRa0dbT56rW6u9OBev)S0FBr)lFV3W5BdL6n4XM7imXX3)BOJdkwMV4j4Xv4b7Ew(otuEUfo4WbV3r0RxCQ(xZ4SwwJFi7NBvM0H8DpS)J2U)xD4Km4qjOeDL7zTH)ZB8JoD9CRZeo8oD3DhSZ(N8FHN4RBTdmm7)hpatFQjJyQBKTVToRDUmaqB1OPI1UdW31uWqofD9sNxZmHtHtEcMnG3)wdUhELU9hpyWxU7P3z7jA4BLTFnG)RaYTDU1zchR4jh8RoO)d25039Ht0i0jtVzbSFU)UfACU1avfrGu(LBwncF8G6(AVo)YmNtXfVzkx(3S4BCXZD(Rn)fMDH5dkT40xDrAm0jQlQgQdmewp86rYnDL1uG71mPOyLW6DIgVEe6BRgvpCt658a3DvXtHpveDU2K2eqhg)yyGpS8j(wrQmW7zlQppBFNCaUXArncWuDj9iG6yrwTKS)vfGg6vX3WOq6rmsQVnzzO)rU(XlE)wONoBblzQcEXQWxBqxMS6E5UQm7nGofk0BTWvV05XLJfNLEwBUAILMwHBwVzyv9ZkPpIpW4SIrO4VnH)MUCTZ0ra7PVQJo3Bm9LU0SWQFWLx48ZY9c)4xy493Q5qvYq7Sw2N1WphRLA(wtrN3D9CRWezT0GYYsJCBGxTMlXyZLxN(IzV0WkNwZTydM4Eeou9CgVghdNCRtHACmyfmIlOc8C19GTpDpGz9z8x81pBW9FFXbPF7(3(P01oD6EY0)SgAfm68YTot4OdVYi(rH8ZtpMo57JyO5NTBSpRwbeotTCRZeo0e3M9Y73YD2FudnZSYdg(N1QaQMPrU1zchANCeUMkUBYPtkcac6losz0oNXywUFdteKWOSJyALBX))Bh5xODeJu2rYUmLX2bDZSAAN7kXlFBhMod3rwfz7aJuSHJQsMau(ZAynSTdFFVP008OB668QWK5PLgDX4MBd8k2vlT870xmBhw650AgfB7WYi36nw9m4g9KtDMuTZhDG4Ouqhu)N(e(tF)Nm4VEiD)HW3Pd939M09lD6EcGFyuGJv4Z1Bo1zsvqdyVGr3NFt(M75R)ojM6rmaDs1zaQD)ZABxWa0n36mPKVh80(h(We3QcJB05LTNSoRPzbJo)CRZKAe5pJhq2(3EhPzJChyYmiwM(Pb1WWJHWAlvPzyL1YMvZr1R0eFI7WJcI4CvOstBS8Yxzz5z)yTW23iQdQ9CLMTXm5UDxrDeX1r(GzI9l2RQuHwerQ09p1r0R6kgeikpzxPw7o0wvuIt2BoD2JBgs)E7OknBN9H1D4CPUjMFPssrN4xcroAzR3SAtkwsD6voiSB321k3RlNF)8NqFqZaCqMZ5wGFvYSP)JgJ16OE1gR15sQ8gUtd6rDft6xw7f)wD2epadyW4s1X8sqPgnBVoNY(BU0CNXfFgkmD0m085ZLh)OY(olnNJp(kTOrx1kww(I9VQ0gyYEzB5BRztp(FI8ccOPRrhUVP0SWRWcBFXZLk(ALkoHfg0jSqhBdaqMgxdTer1dFmujJ0WuPNAnuXV1vKNEycTy7GEFRw6sMa1jzcgrINRsO(4f2Ro9fpFkUbIzb4FkItGojbvdA3SEK8HDnb3SIxw82olEnYvmk8FVaWDg)aHUq5)HOkGvqXd6lV4rL7nJ2ueIuXJNCPZt8SSzQzHrYwlFXgvblUv7fc20UcvRerwnUJt2vL6vErCcInp2zd30txx1AaaaOQWaRA(nY8uLf9MAPv84SYSZl9)5"

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
