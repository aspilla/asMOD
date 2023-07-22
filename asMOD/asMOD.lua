local asMOD;
local asMOD_UIScale = 0.75;
local asMOD_CurrVersion = 230722;
local bAction = false;
asMOD_t_position = {};

if not asMOD_position then
    asMOD_position = {}
end


local layout1 = "0 39 0 0 0 4 4 UIParent 0.0 -493.0 -1 ##$$%/&%'%)#+$ 0 1 0 4 4 UIParent 0.0 -459.2 -1 ##$$%/&%'%(#,# 0 2 0 4 4 UIParent 0.0 -425.2 -1 ##$$%/&%'%(#,# 0 3 1 5 5 UIParent -5.0 -77.0 -1 #$$$%/&%'%(#,$ 0 4 1 2 0 MultiBarRight -5.0 0.0 -1 #$$$%/&%'%(#,$ 0 5 0 5 5 UIParent -712.2 -428.6 -1 ##$$%/&#'%(#,# 0 6 0 5 5 UIParent -1152.2 -470.3 -1 ##$&%/&$'%(%,# 0 7 0 8 6 GameTooltipDefaultContainer -4.0 0.0 -1 ##$&%/&$'%(%,# 0 10 0 3 3 UIParent 712.2 -426.4 -1 ##$$&''% 0 11 0 1 1 UIParent -86.7 -934.0 -1 ##$$&%'%,# 0 12 0 3 3 UIParent 712.2 -427.7 -1 ##$$&''% 1 -1 0 7 7 UIParent -0.5 201.5 -1 ##$#%# 2 -1 1 2 2 UIParent 0.0 0.0 -1 ##$#%( 3 0 0 1 1 UIParent -802.0 2.0 -1 $#3# 3 1 0 0 0 UIParent 232.2 0.0 -1 %#3# 3 2 0 3 5 TargetFrame -31.5 -0.3 -1 %#&#3# 3 3 0 0 0 UIParent 339.2 -356.0 -1 '$(#)#-S.3/#1$3# 3 4 0 0 0 UIParent 3.8 -561.0 -1 ,$-1.+/#0#1#2( 3 5 0 2 2 UIParent -339.2 -355.3 -1 &$*$3# 3 6 0 2 2 UIParent -340.2 -360.0 -1 -#.#/#4& 3 7 0 1 7 PlayerFrame -16.8 16.0 -1 3# 4 -1 0 7 7 UIParent -0.5 156.3 -1 # 5 -1 0 8 2 MainMenuBarVehicleLeaveButton 0.0 4.0 -1 # 6 0 0 1 1 UIParent 460.2 -14.0 -1 ##$#%#&.(()( 6 1 1 2 8 BuffFrame -13.0 -15.0 -1 ##$#%#'+(()( 7 -1 0 4 4 UIParent 0.0 -352.9 -1 # 8 -1 0 3 3 UIParent 34.0 -413.5 -1 #'$F%$&D 9 -1 0 5 5 UIParent -1072.2 -424.1 -1 # 10 -1 1 0 0 UIParent 16.0 -116.0 -1 # 11 -1 0 7 7 UIParent 481.4 2.0 -1 # 12 -1 1 2 2 UIParent -110.0 -275.0 -1 #K$# 13 -1 0 5 5 UIParent -2.0 -499.0 -1 ##$#%#&- 14 -1 0 5 5 UIParent -2.0 -459.7 -1 ##$#%( 15 0 0 0 6 SecondaryStatusTrackingBarContainer 0.0 -4.0 -1 # 15 1 0 5 3 BuffFrame -4.0 68.2 -1 # 16 -1 1 5 5 UIParent 0.0 0.0 -1 #( 17 -1 1 1 1 UIParent 0.0 -100.0 -1 ## 18 -1 1 5 5 UIParent 0.0 0.0 -1 #- 19 -1 1 7 7 UIParent 0.0 0.0 -1 ##"
local layout2 = "0 39 0 0 0 4 4 UIParent 0.0 -493.0 -1 ##$$%/&%'%)#+$ 0 1 0 4 4 UIParent 0.0 -459.2 -1 ##$$%/&%'%(#,# 0 2 0 4 4 UIParent 0.0 -425.2 -1 ##$$%/&%'%(#,# 0 3 1 5 5 UIParent -5.0 -77.0 -1 #$$$%/&%'%(#,$ 0 4 1 2 0 MultiBarRight -5.0 0.0 -1 #$$$%/&%'%(#,$ 0 5 0 5 5 UIParent -712.2 -428.6 -1 ##$$%/&#'%(#,# 0 6 0 5 5 UIParent -1172.2 -467.8 -1 ##$&%/&$'%(%,# 0 7 0 3 3 UIParent 1172.2 -468.3 -1 ##$&%/&$'%(%,# 0 10 0 3 3 UIParent 712.2 -426.4 -1 ##$$&''% 0 11 0 1 1 UIParent -86.7 -934.0 -1 ##$$&%'%,# 0 12 0 3 3 UIParent 712.2 -427.7 -1 ##$$&''% 1 -1 0 7 7 UIParent -0.5 201.5 -1 ##$#%# 2 -1 1 2 2 UIParent 0.0 0.0 -1 ##$#%( 3 0 0 0 0 UIParent 580.2 -686.0 -1 $#3# 3 1 0 0 0 UIParent 1009.2 -689.4 -1 %#3# 3 2 0 3 5 TargetFrame -31.5 -0.3 -1 %#&#3# 3 3 0 0 0 UIParent 339.2 -356.0 -1 '$(#)#-S.3/#1$3# 3 4 0 0 0 UIParent 3.8 -561.0 -1 ,$-1.+/#0#1#2( 3 5 0 2 2 UIParent -339.2 -355.3 -1 &$*$3# 3 6 0 2 2 UIParent -340.2 -360.0 -1 -#.#/#4& 3 7 0 0 0 UIParent 675.2 -757.7 -1 3# 4 -1 0 7 7 UIParent -0.5 156.3 -1 # 5 -1 0 8 2 MainMenuBarVehicleLeaveButton 0.0 4.0 -1 # 6 0 0 1 1 UIParent 460.2 -14.0 -1 ##$#%#&.(()( 6 1 1 2 8 BuffFrame -13.0 -15.0 -1 ##$#%#'+(()( 7 -1 0 4 4 UIParent 0.0 -352.9 -1 # 8 -1 0 3 3 UIParent 34.0 -413.5 -1 #'$F%$&D 9 -1 0 5 5 UIParent -1072.2 -424.1 -1 # 10 -1 1 0 0 UIParent 16.0 -116.0 -1 # 11 -1 0 1 1 UIParent 487.0 -854.0 -1 # 12 -1 1 2 2 UIParent -110.0 -275.0 -1 #K$# 13 -1 0 5 5 UIParent -2.0 -499.0 -1 ##$#%#&- 14 -1 0 5 5 UIParent -2.0 -459.7 -1 ##$#%( 15 0 0 1 1 UIParent -27.5 -2.0 -1 # 15 1 0 2 8 MainStatusTrackingBarContainer 0.0 -4.0 -1 # 16 -1 1 5 5 UIParent 0.0 0.0 -1 #( 17 -1 1 1 1 UIParent 0.0 -100.0 -1 ## 18 -1 1 5 5 UIParent 0.0 0.0 -1 #- 19 -1 1 7 7 UIParent 0.0 0.0 -1 ##"
local detailsprofile = "T33AZTX1vc(RzRnUQrA63puv7hifjLyzkqTeu2BQsfB2aOjrVeanMUBiA61HLSLCwfBLXo7inHorYRCL4hzgTvPjwXrQg7D()ia(FypNZ9rF7gnEyN4QMPQnrgea99X5EEFo3Z9I903B39Aomn5G4Er4BZ6MCCqyA0GWG0KErbXTtgSxR9A2oCy(O0OG0OWEy76I)DvO9dJ61RDywo(H(XzT7eMhIVpCuk93ObrPhEc(UoH9dpmcEx(EntHz5GWoW4pagTg671eEtdJ9AODrd85z5We1pknaM(dIpeNXdGjb(IrdHzikdHP)UrXTpkOtuEu78ygyMgLfLhaav7G2HT7gHF3GKGWErP5uF6eNf2cwx9pjVBC7GoJgCyeRRJYIcche3pehRGW2TJ6XG1WE9cg2l8KO0meZeCyAYOHIEGlezVYWLzA0WK08aebf0lEWrzm4QFYTyyV(bhKM0pyaS8y4mO3J6hapofNP2j9BfMhKhdpUHUgaXrH5DdYts6Lhpm444o5D3RHPTMCMYtcoUBYEnrCywE4G2rzbzrh2pAqEwqVK2hf1bNO29Icb03ac8zFfUaGjlVxe(Ld6aDlfaJGHHPW7q4EiSKB1kn6wX0ceM49AECsAVoc4molipnmRlnCePbX(WWVHNLJJRJRHRRVNUJVZEhCbBO3TssoQFy6rb5rVfqPIFBCzc0)cup1)aaVad8TaIaWtyzdKXra)qCBaRMDcWj0h(t)wj9YqwT8eK)OJyUHEOBxfZLbRQJW10XXd6KCC2C5)kWKaACuq7EiNgGOtggrmlsQfHuheDC7UWhJgq83nrIxq(jdJWHSjkrqnCWOHa94WKr54qumfcEYwWq1n(WU9G)JAcHzrrG2aEDa8FKKysVK0GwNWLsZb5egBxypAE7mebAqubfAGwaJChSFhKmipG6mBfJ)ZGE1KE1cFfz3PHv0Xv5DmRBiG02RzJTBSU4Ry0opGhUKWuG6KMcS5aBvEE8GdZKkyYJbEos9bSeb9fn3A73ey2saA(En3D7Rdpai0reHrWXRbC8NSxJlOJcfVfqPaEPW2h1jnzyPLLgJosllnAzXPPfIcDJimCddtsxty)Ha2NTCm5lUdcBhTxZnsJF7t3))6OWoiyE6(7claIVn5GdGffrE5C9aOdcpHe7kmijdjfcbecaGSCc1wMhhMntKl9GWr9YdADiOMAy3qCaSluuHAcZB3LP0a5LbUevfz4Qsivh0AuEoQgcEEFqJt6jbW0Vxdhlv2nqFyV4wmPaSL433jmfK(pkEG6qZActFhnMm4hGP2GTHECouy6JrXXErOWAjg7SrdhcAKfQiqsMu0iijn(W4bicZOaDXHQDvyaYRr3q4Bj0nyIk2cHPanubZyFqmCVMBIedKeEZv60z7bz3CTO8W4Ez3mgnbLDtQlrYMFqsABq5pyf5wX5Nq6EdgERHsMFCKiMxuzqwTSfauc9iimJBEy1PvyrluUoBWWamIna6SutDyFqfmWszPvv9chuq1Cbzhhoeve15eWaciZXBj(CMnk0EiUuRdv2KOWnxV3TUXMO0tkPegmRVxZMhDcctK8a1ORH2Lc7fNLh3MbqPXmfS96f3HS0nLsWwjzztRDSqLxjnV43Xu9IVtr3lmqcwpsMC3cbwDBVcfcGEG8c7NLSBc4vqHm8PWwbr9BbIAL1fIFpzagmA(wsHzubJ6hYaDwsXaOB5iVwYiW2hZzOcNAGj6OiqXhSUrvHdoKKRiPeHOUHIwtfEPg8vbtAnVliU0nPxhIXgSF1bqE4WcmiWxzWmzxi(bGd(5UXr96KX(cuwODssAhAsU6nAS767uwZ4f1nSzAhzVJPH0gbJ3CLD2zZTNz75TvN14RVYwRS2MnM5GlhBtxQ9xBLRSUOXSMXO5wEAwoEU1phRV7I7cnbSUrDATDUXMRj7MPRUMp1cQVw(w6wAo1VKU22nEDzhLtNPJVAxMAHT26RS7vF9gBELRwlWoRUbi7T2(YV(scOtrRAE1vU2knwcSt1oEJgVEdWC70lZzHpV(oBUEZILMY4BugURD62z7RCJ1xYoxMAScOPbnKmZoRz4dFYYREWE9gRFTF6m5oRYZSoq7llTiO7M8(ol64vbHTOLLkwzAHjT58eqRUKEJTFDfa0wZ0Nn2u3Mbt9nACLD2(gx)6BTYpvPVlKSNlJlmidS1gmmHu6lCoa0VdVfT5KvOHuQ)bChRg9px0XLpPEM850Qo9ox01tSK0fTZCAEEbk2I3gp3PuZyPlMqEB8TioRDwVXkb)013AlPGGQ3Wfsk1H5SeZRa0QQZrxs75TqZQQYLstMT)S0I46k5ieaMzvzkXSbryXHh9QAonRaX1P(M6pJpxWp4AwN6cPPAoanLgIYXvapfSkMrbpQpTspBbL2wGnC9Ns4fOA66UQ(1FrnDeEfXSuN0RJGoP7xAKz0(RSZ6RxS2D8CKsdIfMVgHMAS(n2DNv2QoUKAKifyhBxhj7HVhX6U(wBiBMNVgcvSz0q3wq6yFpj71njVDs6aWHU8ei8KdYj)GaxWyoIu42i6vi4UvgZdVwPjHDAZsvIIdpmpXomnCieOgfIAso4yA5y7nM2t7CWj9dJsfEBBx4PolGJOoXuMFQ4fl6HkQ0G5nl5Iw4qYPh2BVoOlzdhFdntqHUPJnOsh0iCWfW48td7etog5OjxWnHqGPqWpM8QlPtcTyPqXaN3bqMCyI(mlUB9YrXlCU2baHW3AwUxAHzvH7EjyQbhcwi4esMLdhYX3b9ob9khJU7WsPvseTglqScFEbxHHOm50)l4PWkBWc9(c6KoIPCPopj9WU80Rr(bgqHC9do6E0j)aP70o8VOu8ZxuOrrirQlS3HdWcYgG2cJFMsaa4b7XDGi2YbpzbmzFYF5AEalgmEm0Zl3b1NkGlQlKR1fIy6o8vJLRssbAvWeqjAGZeyyRjrAYqL4XsE6(nJsJgabmoJO9LYedbPQ2b9tySYmtKykkvCuVHJHILzDFBt9AmqxX1Qg6wGbvPM0QEbCrrJDyTgCKPWjf7ko1uDOXv(Yefa0q9540B12Amh)pk3wyT5vOFw2A3zS4mSlwDche1RhgSw2WHG2Apph6R2ChNVhU)dd(8ODt3AfSHPHN(0yKP7I)8GhPZEE8M7mtk(uT121DEoswL2OWCxdGu2TZg2E6ZHpDQH2AonUYiB4yphm(un2zESFt16ceIem8MDRNlR9uSHo(ZI3E626QnpaPAZvA9Sv7uLXsxZy2i9YsBU6ZeYRGt01mNnXPYGAmtg1kSh6AwZbrxvHJR58qDvgALgxdp9uSPMlFGxauBphaPI6mh9Lm4rqFGZCKvQsKlKvwuIDAOidoTyvfoUCmTwdojidCUnkOFuwgMqwAlYeBj4mtmi6yu8GGKbICYLrMALonDqVWdzo1W3Zh0NbW)VUjPI06vElcYzjbTSldMYaHmLHuz67ivasEfY3tj0xYHryU5qFNR6mD3iy5WYXAnUMbryO76Oqt1zWt7JyBgNeG08LrXYERzXBzWeHvJVvCws6Y4di6Gg3dUwseuw70OObuu(SoBR5ErwmxxW0MhZiFfbEvNpkd3iIQrykcR3ucAqmdTq)UHxCHW)W9oSj09iW9jKfqapSD1kLCbRmwYTkkQSlSULPg5HPhkii4wci9X)nzT9Q0FYLl70OEabdCRhgLHIVfd8HfHbHQWrydigfDnnttFxxptBWPhiAfFWjVrTODi8yGbCy4qWV8vl6f3xvYR42j97hoOdNLfBXSDrUfMrP0fSRwm2fwlN230vdtxLE2P7Bwgdf2kUxCEmU9dok4(5ZYWklawquTKtl3NFlkOQ4(4kUFuE3KoeUJsWnUTwsORyBzAE913ARv3E7x)MnXnua3u4lCDqtWf0Lug(Ub2kbIKQVYOv4ZSoqvSHaiTnm9m08mmTSWnzMI7FdptdWEVHHLNNUVJPgB7NHL1gUoUw6Mw6UUM2o6(yCN2KoQnS1aNG0DTS91mmnD9zJwoNtQaxtGaYuTdjgBOJkNBUfjw6sUM1Cx1pSQsZYlTuuv84vjvvEkBEzUCNJYA3nQFiHGv25q2ijuluzNVNxKlIaxzforryR0Mw3kn5io3vPYlGbYW6pGRVO5amiCQWqozVnUGRUNPRPMNpqs0bkakRyHBAleZVVUUVNTULPUn68g8eSKca6LUHUJoMqxhBhpQCbWSb0fOxg(MEUAUa10YYsN)eKPew0SPeL2Fl2UfZdGddEttJhigY8wOZIhTme(iUN00QZmGX0bDgTEGsTOHbSJdyBMkiIZBcJCzieiBMHPOObzGciePS8uJBJ8iKVwroH2wxmHgOfoWGeFlRu2tF(U3oxjr(wat73zav1olC3ov7swGHm6D47GarrMQoXP8AObXHuLWGz8iSx8Hdc6d8yXbkOmufxaOXlJkhcErcOSAfynkLn5DbRzh2vS11emim3hp4aIaIKGDqScTfKTOQkQ9sU4OMYwzCMqA42sD4kn(8n9DvXxtChuvlr49vr0(QiwNk(h2yXs0sq7rz54UWJYdixu8BHwkQ38Us(pZggsBIrtM5nKPHsOhvcdr5hd2DfexCSorzli5IUbfUfeOKID(U3deWWdWe(rfRL6MwZXHBG0UBcYdgxC3D3alvgIyhinqk31ZlORuwfiiVe2gMRXhJszPIBWGewW8H0JuEmAiy3KYpcq8i7bz3CL2XDwnLuJbppk9kO3jx8AgygBoUO1K)e3C9)BxFLgn3C7gAg3CTT3ETvwR5nVCsVoHPPH38YBV1ARSZoRS12x(gnVyFdX8PwSfSXubqzFHSj6Iov0K8Y59sxWQOYJ08)bYxP)ZU4P7tVZ8Nr)X4NX1jPshemKBHj4BqgyIwYNjyc4dDv5IIgSCsmuzgDcwZhkUifuHPBl1Vaw5TPupYtTk5XDVWtQyaZTShB4FT4UzxsKSQeylkJMqR(jCaA5whvkIdQNhMgEcRChKI91l7s7JUu1HawkWYO9UzvlKfY9u7NPxAY1nnqdg1VfZ9qoBvblJ6MMjH76yKoD)FcNd6VrYs9F61Qte8QCc80kquA0A)NJBNpQpmQPyPlKf9AvxCQ6DMN3OBydg6TTTnDCn9m1mDyovLxWQmniYN9AvYT0CYwbCqVyykkHoLbaCZoc8(EdmbT38gBEb(N3kol)cxTOdCuFTeKsCVlJZ5dsKSmeZ5SIbTclwnAKvsP(kTbnJGWyyVt3)6GxB4hAFIc7RkSVATsEldSJvBBWWmE52wGeYIggcbQaDNN8FzT0X43fUonpFobNkOG)P8GdIgIn5PQxzb9GykYlJjipXyYStzUga(vX4nxLfVj3UBJlyGIYHYA4j74yClAyvUdzdTFC70Ka52zl8OtS3nf1pf59MGMkCRI1C9s(aTey4IvsHDgFdYjYwS0L45PSVgtJqVcxCUYoEyOlscJUm)cW36BXdNWNMDMFOdWIlL0Wi8OxXgy8aMGf82Bf2BefhRgLiPLTHMlBdTw2gAVSn0zzBO7Y2qVLTH(lBd11w6wU00g9LM4OV0uh9LM8OVS0N8krhuubjkIfZ3PAkOoGlgJIrQITtugeMhOGI7VznLYy5TOvr6nPh41hw7E7oDAbNA6vlMWffaawjn9gDymBxZpUs0wC1r45fiQ2GtnKbN6AXdAJqR5IT2xbpMIjfTfPe5qw5IyBqXAb2ycRgFgFMHy6pcZRAr4OnPyLbV4BgElwTtIU)bqxZ1wF3v2CRMbn3DLDVrZvxzNGRV1nUYMncUmvvh8iCMDZU(AxVPC7sXbE(TCx5UOUROA6rmYgl0s4kyKRSAciUF0Uc)wXh1uUr14NU8cJVzUlNMRFLRTEJD)lgq1)rgqVmVOB(ldkn(RcuMZd)DjqRSCQinpwoZ(dutLPj(5Obr95FsP6pes6LYFZfmC5GNAbkzoT0NLOFBy544R76BO5y7a2MDzzhSzGYzSHLNicClRhmzqViQEy0fU)OQ2cC0pHvxjmXmguPOlJofk14PsXmJA6ucDPIeFr(NkPTiEatMhRNfwsDYgq1Pdm7qKuTqheW0I3s45JqjHKKuPkmu0OqrrlpMbSedAz7BQ5O7y554yyBG5f0XvCyo457D1T3D3TV2ouzWv6qaitGNmTrs(ctxL)NmKdEkID00SC99T1m1DasNDrkINXtmN1tYv8EeDJg9ypJN6LJJhsw5yOW3G0bJAQRrHFzAZs4PiLloIaqSb7YLFAju3wJxTL1NxH4jdJVKPNYDHMZ2JsbF2PApcxgS4HfvigBZ1Ib2TncbtOkk1zN1LCqicK8yfoJQ4WQkUJ3uA(v94Gb6zkh9lwR()mz9)GNlqkMjr8nli0i1U17yqUr2VL54qPQ1qNx8NgspqOHLDohRlndktDRdzzuujxYbDqlX8H2HVxBsVZlrpgMKf3om5F)NR9QIhLwfmPJRs1fNCdZQOPuv4DoPCuShmtvoT8WCu2KpANJLrQUHNMHTMHNNURNLJbB1JfchD(LOnYvjZGScbBdlFxpBFDpxWaGTHMfdlNlQJs2wHwrH)j4AxEAGOOgvsiXMxE7gnV5MnEJaWGqCVGDbaffMwGJKYaSfXD7vYLzHMEp(rfP2C3xni9kPXB6k8TyBMjyGYDwuVdkscT4KQqbSZ2cE2wqHFzr1GthAyWYcMW7MTgDWbO8FVBHowEaLpMENCqmgJBNW0JssdXJtjmqSwoCu6qmPqaHVhj308Ki0JD5blUzkG6ja8WEjTcxJLsFoGakGzvGklUbEP5HWEj1sWZ6fFquapJNSJUlWzq(rWoBrUS9DLFKZ4hZyYKzC)(mhjOAcanEIsn0zhMPlapMoItqLAh7HNO5CW9L24gSIgSX2emewP0broJkhwqe3Y20WNRCg37fScrvl)(O3AOVwEevPPWcVxeO(LFcL29YBVk)SxZ2iXJ7gHO6RCJn3AnvyF0Gy2jOogySLzhL3PIYdqVW9juyNl3xCCTlsAs5YdL0aMEiIIZvCGtQReLN6gNZHAmRza)XrXSZ7ubukaqeAzNlbKmJSBitgWP3bltK(GeiZsrdlut1GHGfIaMdyDy4EGi0(OGSCWhXiucrEO2R2qgnbpjUhIhvlonld5si)GQ)XKtFAIQ(KDYcXZPhP6Yx5isSb4zj4wKNTgPwsdvKB6vC0iAaA3bhDSef))g2(UoU2yvBP76A7GQXmD5h)HnSnC98TmmS09nG)Vp)HStPWgEwEA6(A6WWP5A5jSzWRL9n8mb16A2owGPdhDDD(JvlY(gUogwxe0HkcVfxsbflssndWLMgZSuvCQVfFj6mBiqE6g1tCUvXIH2PiSGnBSX2b7EJD3ENnxzlDwIZHOEzfzlNnSfYf2cvu1c1s1sPCtqfvdOthRy0bYW2VX67SYwBT2k7UsaGzBSzJRqmYnVggK02xB1v2ny3nV264SXJkaSvpaelBZOJ1cCg8s8ipTh)OIZoyEQl23CZgRT9BgGXHfCJg4FOLeE4ihKXw5cFka3dhaCIbXD0LfUUH8OgYpwHsDasfxkDJgzohynADuuQ46OP7zbminfhO)obK6ZEOFyyznWDcma0TeKgcpwQMIObgo6uAxnCm9z)vJYaRHTVb)75FgIyI99Am9qhfDc4ReiLwuF3sDgO7oCNm5f)aEXjKDYa6WlioO58DTnNxUcOp4ziCIJLpI01TOxnPxnOx1Px5GakE25YKlBS9DuKhuPgUMV6p)TtEYV609F1x)NE1F8pqHiwRr8Jb3rcOd6tdr5jsgsBo5t)4XF0NC6(tEVNoVb4nJchclPvbcPMRi5PCB)WOC(NC2R(JF35p4Bp)Hp)09)jJFVp58hEgmOFZFag0xR2rLwrbxl8W42bBGAhJs3aDeINVvU)utp2NF2lo)XF2P7p(BU3RE2TRFSxHuCFsqtW0CcQ0tKCwQYXQDuFW3o(ZE08G0vsBhcCdxdSMDn6aSCIirU4G6u7G(jpyYV(BFTztvgHgm2aLd2aCSO5W404CrwFXr1TUrDYV5pm5Hpy(l8D6Esc8MUbVrspaStezighuVAPyF07p5U)lZFqVmUH3Odzxpjodyg0me5tMye8m0SzOH3zxDWnDtBZlPBH)td()S3PFjDd6L3j)09zONjpgzu(0pFYh(yMNKSUkZanBS1TyLekm2woqlm0N)yp(BU7KV5rat44p4bWW)SVdMU7F)Z)7Fbnh8HqM7A2CaI(M85WW0vtZD(tXKF9Dh)I7p(jF8Kp43p5F9PS1XN9Sx9S3D879i4TF4tHvftaHgnz(VjPxnpdxMi8KZE3Zp7BHo84NdsIvOaR0b8uyQDwKCTleZTrpud6b5YmMZwjag0VaBbbl5SGLY9E0K7D25p8riI72NF)VITy(npBYDExbcdhfz62LeCV)6sWTvgBFxvcUM3cwcp5UtE0xji4J)DF14xEx2WRPdodWQCzH0QPRRLTDbT2YuBbJ()ia23hKwG3(7(o4TJ)L)Zcsl059yL6Pa2bN5Se4fndFWBL5p6V6RFY5)JFom0FaQeNWpJ)3EaQs6lEkBwSn0DjPnDpvmKMadzBBzzBTaS)h9)58)x)YZ)ONciEqRpJm84BF(zpIrIzJbnjczAdDlicD(KaUYz6UaQW4N9GXF69bUMj)rC0V3)84p6(CQGHVThRqVfs1GFHMCLXpGXvm(RFoOEF8x(lwEPGw9ss6WDJGg9c5zdDtbS7yR5yUaHGx98F1REXZqA9Zh)fWFp)3CFqIGGRZ)n3bm3qle2irZKrH2jFh3ccUMPV(czwh)5ic6jpcMnAkGPEY9EIaxHdXESRagPmTNTQgqt)fqUN887n5NF)Zp7HaA99FX4p9mPSbNKWhfAAkKPDXQJqrUtFrQoE5Zrfxp(7O3Cgzx(87CBMA3p9FtG2SC08Tny15VyU8b(ntL5Y2DbZ14h8aqN04p)5JFVZyiTND3ZVdYmJCYVqOUfIlqtNrICkyK1SnK6QC0wOapOt)7EW4N9OX)dmwGX37ECTv2U((SZYIePz6Bke4H37RVGbF8x(5GMEj94PCvIfgmydcnjc5DGfZNDiJBcARF1F6JfIWJF5VL5)cyi)14GOJgeae1DfRZwgQew7fYJ(B)yK9)xJ42N9uH6dgc21aeNjVaLwO9DnD)XLXXuxv7TUCUSm998xWC9SVdSmp(Jb7BNF2lHL1R(tpLp6uVPH3OGxbZxixPNPTT)cmRn5BEi47etrXh(SXV79fwgSPZ6oEnkXgzFpndUn)784X)tV)4Nak9bsj4lMSlEeJRPLIT8clv64js2DHE(aY7KTCaQaxrE1lVZ539f8tZlna0myRIn9v5mCSxWmC)BdEEZOzF59b2xyD)ZFY5V)JeciECMdH0NLMNJNHCkahjmxebd8X9EF1R(JpJX3DN7Ywxp7zmphE5zCQhnu0Cvim65Bj8kb4D80xGEYX)FF2Kp7FHHViR8ij5Pt(JpNPUhmF7YqyEYvJRVJUuxILPP7ID7b4pEiWyF(J)4XFXDNC3hlnkYDd1Sqq1YOWUoo4Ul0S14pLtn(53EYh(emaP7W99XeO404BPjHEG9wGFaInO6AbkcaHYjN97rTUKOjyD8x9eM23)8lg)f)pzucF8W(6rZKEbv3txAYYZWuZWAH(bb8wSq7(U7imlo(x95)niz)Jh)7EQq)MbDHB0WQWeSLPH9F1WAGuiRWFkm)Q76uOtWtZYybCvF09N8RF24VgMINZyNrY)4V83p(REbysbvBF3XFaJnMnE08zvqLm1CKoOA7O5SijMF9zJFY9g)hodubn53ciXZF0ZbKjmZWC9p9vGdXCvm0yrtwHZ2(EfXlyRHzMBbRoY9AysVZ9g)UFlnhtE49F1)6VCYxY1AdMiSyPBWQqlGbEnkWNgIHzrgHFcYmC37H4SpJBg(5)cqCsHNJrNCvWBgw)iG3kyWZL3PEImAHzuKolGyw2gIj2I2ULsx5Hk79sPVVylfl918lln(grUA9pDwJPOZYHU0Ta2mMXzTXokB0BP2l34rCp3Kx5HS9l1LLZl1jvUqk91lCqQBDTeqAPj577kJpnF)wGZK(kw4y686HxwhWdgLXBjMVYISe2c65r4EhX3GL8WwuYPXSeZ3YLWoDWnbGUz(OR22Kbqir41WI8(HaR1FLUi(ESsgu(6IIzU8URPjV8QeNqwnB1BPYHDdZIkM14SIA8qz0PlZ0fS9189aL6vXaY3qtxqLKNVb6hRh4bOylaOrh3AqLAXUu1PwbPiUSuWJnfFBD43uUudX9MkVBqgEjGkUWBNcTshP0L8CiwGckFkq9McXPSTEhI3bXXTRoNzYJB60ODX9)HV2upI3zAN455TwzUOJmLOaN4JIpRkVzzYFXnNDNJmeRBsyw7Se9GTv0I9SCzBpTJ0lUXgeBzkwsplUXM8YaqvqGQZLfDdTYow10H3TwunUlGD5390lagilwllTHv4c)aioljQM1(Fmq1gCu9am72dz361OexRtcy3)tScstSvRlR84Cv4uuk(ttSu74uImSkVWYhCqr3aC53uZ1euNWQ7KkAOKT21cICeCtZ210s3IxZftducM6PgiviAkDaKSVSVAMLg4YQSf3haIIPxCxaWoGltbp4MXnFfDf3vsff12SoPnxSOC(LxPc08o1ksOz32YvZcCX00XXfzV5A2LZunhh7zFqXY43lSk9xApWTgGqfNpT48CzdMbjsE5CH3hymM9fzIPgrc6rTQzswc7eQQ6ljjQ03zPozbTVgD9lBpekGwQ2luaTiWVKcOf0yHU(QKzoFOJowVkAA4l2MsX3A54vzPQvS5hMnGWwzjPtF7)wREA7Fi61rfTH36WLz8zTpnoVM5yg9XI6t0BnmCP8cGvbb163WCbQrdPk2yjGhBXAoBPH(L1mmT1xFFndZ48wAdRDJ)Ea4)vYKT4GtOsJYNLTbLZsxDkJ46b94vhoVENM6g9tCRTcA9WQKIxGeZO8O43uhfEUxUMSKvAEPbd)T9qCpewu9gLQzdwTCKJOJk3M7txkvuvyiAAE1cDrzylvp486BHvsxZSu56HNJX2DXsjex9ClVMogiII(zUiq50OW(XkHk5Sd6Xlqzw9Zi190szUxqz6vFjH93ncRSb2j)KHYfvQOOqJy)wcKcYLvzxpUlqpq2j6(nFWa6aZVYpvuU043pGDzDKRmCdXI3BQXQyaWBM0MIJrlF9baANWtOQMrCEnhGNCGqQa5sA3r9EOS89YOOGHefQj)kVHUY7XcRe9Vzu)bSuKWUgr5L0L4UEmJv(Ihenil(wrxaJINngyfJXVZN4puWDlARuLaQylNkRIQnb1qMmGmJuC9GiycWs394bfm1vGIwkZCRAM3wfZARANtc9kugGY5QHWIZA)OGI7KYkOq2nKjOBpwYXYRZ4mwbJZoWlYROuL6pU8rwd0pWRFR5Tax9h6cmxwnzGmhoj8JbyGule)k7Isndw3Q3IUOzaP7286vLDuar1shg1NktSSaDSgpAvZOjGCwhqJS0p7cO8AwXVsfDz1w7baZ5BFIYSsyvroL6mKydNAk6pS3Omg1tK9pWrg5T5e(7hbvNRIBDKMYFvuWoYXdOUwdN)wnZ)wdZt3x37s2ExYY9DUgc2n5LK82dwFqNt3NUwpIG38oNUFBSSGaD2NUFE3Ot3NJ7G2W6YP7hMZFue21Kd4FkD0GlszQTU5KaU1yfs3gXdIZ6g15N8A08XqJujotx)TNU))fyethX(5r575GjpUYhhcVepawoeRXfPi2MAWSzyJDX59YSFZCOHzqIC9cdtEchkViLPUAgLvbOFnG7muGepk6Kt3NQX)lrFw3H(dUXlp4m2B)n)HXF5lz7u8tU74p8L0fKv5X25sgU1bHCY1fPl5SA6YsdoF4tM8jpS8UJplGZRYmz5TqGZV2USSa35)9pA8x80XF(ZNfeHr0wE8DUKMZ7WRRw21OEWwRVYBSoncy9AI8RapbYSTKtDDZBv5klJlPzoFuHUrT9zPXfF69aaAYdV7mXfvfvmnVKPXcGjRA7Zsdtp8SjFkm7pDMWuvzfSin0FNlF1v2AR1BCL1dU22RToECm3zxAie)UnbZs)WJIK)gLrQgqlmKMHdaTSrZxXb90or09asctHl)UiNAIn9C2zZQ4advzW5oOeipyjvNCvi84UrdcqFCNceWJeb)s9Mo4EemxUv8BekYjuvWu2aAf2jQtCB6Wzk1dR2g6fbnItGEBaGUunug5d3Sd2yl8A)xVKUhnVlPPDjdZFKTvO7w)K(dZyHU337rBowl09Rz00)EBUWqR2HzHYy(mHQYLKQqSB8hCgvLqJ)6N)QNF7j)87tLjN684s2LwG8VHrT9zjHTZF)hm(XF7Kp8rSch4j3BYJF(Kh9jZdgnRoFwW)wamAvBFwwyKGJjV8Bh)EpzEaMDLjXYgOtlaWCQTpljGXqx4(rZnVndaZTYKy6FjdN))Aq)rxdQVQc06OnL1HAytPnhuaP7lOwgMxs3)s2()y7VTF9t6pqhU1Qz0wGxEM612Nf7gbJlc96e0J8YNZC36LVG9TV)lM8V9eYDu2rHz89Vn7NKSYtL(LSwGNx4p6H10NLf8WkaeaVpbRCLV8EJ)DF15V7tNheAvz200VKU9cGq7A7ZsJa)Yxo(jpLk4nwnDopWZP0uzCjB4Flcb6wBFwwWdno84VD8hEpWg28GmVkZIfWf59xMZ81baZy29Ro7MxYW6)GOO9Fx7kQTQM06q(tPj1H9Z4JMNmYbiMwFP3m)OPjfVjJRBs)HPj1Yy6rZ0F(sA49Lqn9zXsAEmbR7(0jIOLPQ6KInBYxEB0a2tpdEdvlgvMcZf6NiUBP10NLfSo)Hp)vF9xbXU(Q)8TxaW5uzI0TxO1hl3A7ZsJZEVNGbw)lE6cGmVQZcOI2BbqMFT9zzHmSwm)WF)43dlsYx8GX)VFki2C()Wxbq7Cbvr60LxhrX4VgOy913SDsy7UvtXFupqNse(Jguup(5Txmeu7fBLT4uV2nm9wrzOW)b41)p8rrAjR8ZYmoVygAK7la5hy1TfGMiANYOl6vmnYheNMrhVZMS7maXfJIyyyx5mrT5xk6kBcw59yG9ZTeERci)D5sEFbWU9b7t)YEzqxR(bYBqg2vVysA8BJBgwVM4DuulrBOMKeGG9CkDm8mPkUQNOKdlgK4STkUdLKx(rXzfhTAMQkQ2ePFcNOBiKsG2)b4oqNYjpD)4HU(lUnPkZxY)jNh3alBtBmCkjjwDFi4BhuNQ7VJ6wlj3nkjdWoRS5AL4AiMkGpBrCm0bwVd7YKr5SEZ56L8889KMxAisgk2pYVRrCOm7lRdJ3P7V5a83lJoJORkiQpI(Un)UWI9Pxp6e(D8Iyln2U1)9O25xwSTSfxmlyJkMy1g3CuRDXfioyi9zAGALEs4409Vm01y8AvV2bPb1z(SjjTk)elMV3E))("

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
				layoutInfo.layouts[index] =  importLayoutInfo;
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
		if element.layoutName == "asMOD_layout2" then
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

	print ("[asMOD] UI Scale 을 조정합니다.");
	SetCVar("useUiScale", "1");

	if asMOD_UIScale then
		if (asMOD_UIScale < 0.64) then
			UIParent:SetScale(asMOD_UIScale)
		else
			SetCVar("uiScale", asMOD_UIScale)
		end
	end

	LoadAddOn("Skada")

	print ("[asMOD] 재사용 대기시간을 보이게 합니다.");
	SetCVar("countdownForCooldowns", "1");

	print ("[asMOD] 힐량와 데미지를 보이게 합니다.");
	SetCVar("floatingCombatTextCombatHealing", 1);
	SetCVar("floatingCombatTextCombatDamage", 1);

	print ("[asMOD] 이름표 항상 표시");
	SetCVar("nameplateShowAll", 1)
	SetCVar("nameplateShowEnemies", 1)
	SetCVar("nameplateShowFriends", 0)
	SetCVar("nameplateShowFriendlyNPCs", 0)

	print ("[asMOD] 개인 자원바를 끕니다.");
	SetCVar("nameplateShowSelf", "0");

	print ("[asMOD] 공격대창 직업 색상 표시");
	SetCVar("raidFramesDisplayClassColor", 1)	

	print ("[asMOD] Unit Frame 설정 변경");
	SetCVar("showTargetOfTarget", 1)	

	print ("[asMOD] 채팅창에 직업색상을 표시하게 합니다.");
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

	asMOD_Import_Layout(layout1, "asMOD_layout1");
	asMOD_Import_Layout(layout2, "asMOD_layout2");
	asMOD_Import_Commit();

	print ("[asMOD] Details, Bigwigs, DBM 설정을 합니다.");

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
		Details:EraseProfile ("asMOD");
		Details:ImportProfile (detailsprofile, "asMOD", true, true);

	end
	ReloadUI();
end

local function asMOD_Popup()
	StaticPopup_Show ("asMOD")
end


local function funcDragStop (self)

    local _, _, _, x, y =  self:GetPoint();
    self.text:SetText(self.addonName.."\n"..string.format("%5.1f", x).."\n"..string.format("%5.1f", y));
    self.StopMovingOrSizing(self);
end

local asMOD_AFFL_frame;
local asMOD_ACB_frame;
local asMOD_ASQA_frame;

local function setupFrame(frame, Name, addonName,  config)
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
    frame:SetPoint(config["anchor1"], config["parent"], config["anchor2"], config["x"], config["y"] );
    if config["width"] and config["width"] > 5 then
        frame:SetWidth(config["width"]); 
    else
        frame:SetWidth(40);
    end

    if config["height"] and config["height"] > 5  then
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
    asMOD_t_position[addonName] = {["name"] = addonName, ["parent"] = "UIParent", ["anchor1"] = "CENTER", ["anchor2"] = "CENTER", ["x"] = 0, ["y"] = 0, ["width"] = 0, ["height"] = 0};
    asMOD_t_position[addonName]["anchor1"], _ , asMOD_t_position[addonName]["anchor2"], asMOD_t_position[addonName]["x"], asMOD_t_position[addonName]["y"] = frame:GetPoint();
    asMOD_t_position[addonName]["width"] = frame:GetWidth();
    asMOD_t_position[addonName]["height"] = frame:GetHeight();

    if asMOD_position[addonName] then
        frame:ClearAllPoints();
        frame:SetPoint(asMOD_position[addonName]["anchor1"], asMOD_position[addonName]["parent"], asMOD_position[addonName]["anchor2"], asMOD_position[addonName]["x"], asMOD_position[addonName]["y"])
    end
end

local framelist = {};

local function asMOD_Popup_Config()

    for i,value in pairs(asMOD_t_position) do 

        local index = value["name"]

        if not asMOD_position[index] then
            asMOD_position[index] = asMOD_t_position[index]
        end
        framelist[index] = nil

        
        framelist[index] = setupFrame(framelist[index], "asMOD_frame".. index, index, asMOD_position[index]);

	end

    StaticPopup_Show ("asConfig")
end

local function asMOD_Cancel_Position()

    for i,value in pairs(asMOD_t_position) do 
		
        local index = value["name"]
        framelist[index]:Hide()

	end

end


local function asMOD_Setup_Position()

    for i,value in pairs(asMOD_t_position) do 
        local index = value["name"]
        asMOD_position[index]["anchor1"], _ ,  asMOD_position[index]["anchor2"], asMOD_position[index]["x"],  asMOD_position[index]["y"] =  framelist[index]:GetPoint();
	end
    asMOD_Cancel_Position();

   	ReloadUI();
end


local function asMOD_Popup_Clear()
    StaticPopup_Show ("asClear")
end

local function asMOD_Clear()
    asMOD_position = {};
  	ReloadUI();
end

local function asMOD_Popup_Layout()
   StaticPopup_Show ("asImport")
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

  OnCancel = function (_,reason)
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
		asMOD_Import_Layout(layout1, "asMOD_layout1");
		asMOD_Import_Layout(layout2, "asMOD_layout2");
		asMOD_Import_Commit();
		--ReloadUI();
	end,
	timeout = 0,
	whileDead = true,
	hideOnEscape = true,
	preferredIndex = 3, 
  }