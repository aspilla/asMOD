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

local detailsprofile = "T33AZrXvwc(Bz)WgRDVnQZ3piI5dcqYMWGelLO94iiOuwvLsQgQxtMzbw92TcSr2JSr9y7PrgzBbR8A7g7zyIrgeUHOXt))rvP)d75CUpYBMvwvwGHy3pS94ruvw3NN3NZ9Cp5v0VYsxPsVOUR0Svi(XUxlmkOvRQ1BfgevTt41t6gT6AbXjx5uxPs9GEj9JcRgfg0cB8A4)cppUxyRw15nQDZ46ncscWph0pI(3WoHrRUo(PgbTdwne(uYvQe196vxjOry1MDGrBb9Rub(WcgxzbTzmWFVxRG1dJQ2imjOzR4QxVzNgDVooVX1dGvl2HAWImj8DXv1vQu5QR3Qzh4dXxfgOkZ16Ax6S44G7h2yfxnaw(Rg1TFVRu7kv6hhwnUEu3wTWVff2RBusvCtvfgNRgZEyBaKq742vxjQB7QDcAhY2NDA2UF7Qsiw321csQM0SnU00Gn91c7aFpkO(vdJWLDyNGATcBGd7kDHFQE3wDJy7C8)mO)As)1c)lS0JxdGrWk86nQd9awPv7DT24aGB0mdG2m6CyhBqO)1c)xtCGOjmETaecwzHfxyoXJA(74lx6RReuhGFZh183TXY)p6h0icqKBS8slXNW1cBU6Ajq7DkEP1dbmReHqOL4TiPzslcEfNGd2vQCUfFBeVv)QnI62l)wW3qUlOpAM(r2EXZXh3oT6cavcskwsMAWE46nBKSgma2AuJWLSK64mmYOnwUsyuyNMjRde79sA2TtCvXkoHOkzKbjDRE916ELkirzCsqN6HXvJdxTnGtJRYNEKLG4t63HOPypkPB3wjn7Hqa(hR2o4DRguRzRMjndJVYcEmc3C7DdFXwh)KP8tcAb1bRxysm26kb1QffETMb4gHEaq(2iKXuuabM2m(6UoSrpDKrSbUb60qUA0ST4DG(KP8teAWJX(cDiSbmlra7nIlA08AnJ7gnne2i1gNCeLt0P(Aq)aEXWWov71nM3zBn3zCPb4eM2AZyl6jsX1TVe2XwP53vCibG8s6hdWB5EZKVZm57lt5UAbByBSGd(h3Ru5T7g1QrfO7HardSldtNEy)vnIi8YcDDZViYY24MflMeeTQar2e2tmUrGU5TzT9nP)jrcFIcBbi6RfIJspXtbmqsxsyiXVf0gqlji2iUFnGATF1RdsN6f0dqrNId3HzHZxsC(GKR2bDAetCavW(exT2Q5ip947qpoqZJd0meaLXl6Ow3ierKz8kgLXB5O8SNki6u0VTXYMCyvABR3f(ic2ofrGBO75AdYziswxpDd4llP(LlQ0SuGB3vwjomj36ljfIbpxxUc5pWcaxbVBZ2iaTDyYADBqicjiuUroBNKWiecD5kxyUZDUtT4IV1LRGAnR1T7vpXfavINqxUs61TzhcyKK0TDgecm5CwJ5TT90SSnm9m08mmTSUYkNGXYoVNPHHJTHHLNNUVJPg(leP(8UoUw6Mw6UUM2o6(M4VyJq)5T1mC00DTS91mmnD9zJMk5(uONsaBeS1OkCqJBgjua276iBLqDzZyudz8AK64EGDdGg5EHGG05TS1m98Cn9H1LVPHlUKmqOs3R2oi6QmjCPiMaqBmnhS(xfupdd81cBHiBlaR3PF7WOMGLdvJxpojSn8pTR1TvmALcWavHSeHn3OKxOhncdswRQGHnUhmR4YKzhs8enDjvNbXcwVvZ6xfvP0TxyhCmgXmR6RbFnSZQmvLc9mmMzaWgJM)0d1DGmSOngvtwVxij5an2IgOo97bAMwTBFI9pDj0PlyptnU5t1y2d1St1UGKj(EHX5t6WA2z1QaryZFhG4by1Qb9q(aawSsq)wjizyqRERfG7uBMfuaAeeLW0FaQiJGTwvawfZ0jqyxaB3PoGB7a))KIIWoRds7bHxa8jogi)Jz6pIrlKar2rHj1xJzVfc)rP31e4yvB2YH1b6ltUzDHTwHlXbffcqIgbrWYdTmuzMqf5cT3vR1hy46qRK2GzFrRxfSlauhyr7cOHnrYMwHirvT8KhCtpa1uPJod6YS3mMz2xu9WQb1bH4GbiKTIcRMQ3kaqYOKnWoJ2aksvOXSnASyN4lZfhE5MOn0XxM6sOS5k2P0VxViaUYzTq8xEQFIYry)tbwwNuahvW7k4O4az0QyCp0GT7q(OQXxpOhsP3yDWq5M1fMhln6f3pi9gtSwHkmsuOWRcKIR2Sd4NbTG5SnR0kyvMvOmvX1whnSVtaiuaWyJYbHMekTSdvjhJQ6hLlez0WUNHfh5Ny844NuyYzUzCE0pGGwnJtAwNnKrnzssA1QzdA4uyEyKKOYiFl9uNiY48aTuLqwGF76bRhZ2GsWik4tbmIIfsYVHsLfasxGbpOw1W21cBKZxK1fQ(q6K3v9lypi3DaRGJbbdssAOBjijB3(GGCMtHPo3bt0vbR4a2KO1twd6gXbsSScUuavcqBb)HWQhPzs2Est5nzBmo)yYAaz9ADB1GibbgWgWESk5OfadmneIBikrMRB02VvxuKWAndB1iM9aKztQpTYBEPfwAUlMv3)mOTccZWTfw7qwm82ZEXlE2fhB75TvN14lm75M9mNDHXo4YX2KzoY5N9nMtXPaBbfNfOV3bnzPO5yULkVl0eW6g1PZCXlD2ZKAuSRUMp1cQVwa5PLMtXBPZV4cVLSJYPZ0XxTlJSXoZCZU0B(wlC234nlCXoUUn3cZD(3zSqVC7PlU4BCPuONcaWi7EC090Lw4Twa8mD0D14aFx4INDUklnLZ1iKqvEZzp)SlmfiT8DCwqQckLFStSMHp8nlVIx1aP75w80V1uI2hz2pZCaUpl3IaVl8QAC4X3eToCAN3CRAysRmjg0CnFUF7IVLYcemK0Nn2u3gdr9Lw4nU4Ix6cx4CZ(ok9Tu6aYXC0sPr8exyfaiqg(igaQ4uXNvQf1nObgZmWAjfHXsfxP28v9QHHGXjHXjGB)rGjeTj8)PsfJbQukqm2moUcF2eE6AvK4RzCf(25iI4ILzEMjz4dCenrFeHvw658r0NCHy2lo3cZw9Da3EK8xQEriiTkg(lIcHigew5LCPlPGerPWkViQmtMT)4Kf56kPRelmcmuzUZnFQBWG7iI40yAOBlahSNl3TVXfNBUuUBhphjvKyS91ks7abFzSrcYnxZIepjTdHVshrIuwh1YPJWmhuDubTaUtx3v1l9zGnOtQhF5fKyliISfqAx)XjXWXsgKVmTfSyiM4EalJwyUlT0fN9CfrWualUaEy76iPu89gvqRyFlAKNlJfo1Er0YbWiQyw8LzgsTAuqV1aR7awU16MWI3fyJBVwHRKqgUag8XmjkVnZjG1RRggjSB2o1MBMlhHnAMuKhFOH0qxqBH4gjgqbueCJICL86KbDDBWc8tuqJMKrGoOrBOFXmNd1L99cDJbpQDm0Sa5UE2MaU1bdmGLfVdKyLeYSQ0DtQhfcZOTPaEmod3SStJblOvchcElbjvT7XrcNWtHSIhz3tOtCTD70AD0HimISRwOlHmF0ijLu0UiR(btldjxNy(6bgp3MI3uNvAUkU(wHjMLfFbAy)h7JqXgHjH1j51uK(bZEr0wDWK26RrgocEod(dfLeZ)YAHTa0hZBh0bOu0Dq96H0zHiwWTrBFRxTb4CzinbjCFMWvTOBXzW99GNxVA7Ue4pJlaSaRaEbhpAWd4(pkpmLX6UctBbUbvm9DbhdfDD6(aPrbQ8YzgWc6wGUfjNFE9QZiASdR1GPbPQ9TZzMq(HgJD)0yxn0q9jygz(2Ambn6zBlS38sLujBT7y2Cg2P7oHry6fVgSMwhmG2ApjtKZ3ChNNddQHbFs4UrBTc0W0WtFuiYODXFsRhP5tE8M7mwm(iT121DsMMLh3OqCxWcjRHCly7Ppb60rgARj04CJSHJ9eG4J0yNjr(nsRtbiYLH34B9ejThHm0XFC02J2wxTjTqY3CLwpEXo5jS01mgpqpl3MR(yx55Gj6AMJh5KBqnglHAoYdDnRjaOZlWX1CsGUCdTsJlGMEeYuZP3vgyvBpHfsoXzo6tP7yG8aNjWRKhjNYRuwOswqHhCu2QCuCQMZW6fyyqv(znc62bZFOCAy9Rm)jC1Tm0mD0m08H)1qyO07caFF7zazGUMEmjHvU(vM3tZZZaKyRzAdaqdpS1WVS2vM31YrZX2W3eEkW6X)f0CtWLn2KHok(UK26RZpdB88R10yRy0ummu9IWdkSQJotkW2YoRgtNdIzv2rhbdHhg80KwH4bmJMi1Hfo7o9fnHbXmeNWvLy0CVfileQTA1iwifaZaxPpE6ukN2ffWFAfbgwuT7k8vffpnwuy5XpFINuepC(K5AvPSoP04CR2L4QgY0yaThQAmgs3gnJ4gYHqhYYm0o(GwnxTt129b7OQQaYqZLQw96bX0XXWo0(4R3enVenRcTMmofQZIxiyUyYAGj7RUM4ajOvdf27eyyH9olxdudUkoUS1AnbCwNBVn)GRaSF9(Xj4XCG9TY)tmCR)bzQtGMXYI77Pe2PtNY6S1RdJgEanBS8fadxXVuF9SDJIASSFtXz4LH(qN75nrxW2pvvxP1uNm2gvo11wLD4Fs6WjLdgagIogiY2uym4EFmcjE1wnB3mrgD6tGNdgrwZWd0Q(u469u4(6u426uO)kNIDE(vI7HqUfoHHcojrI3zrUosUTqiQWCBHZoYKokfHNEO9iNeJBL7gIGOvI2bMRvzbvapgZ0LE65P5BqTQgtMLNNsAYmke8ny5RrL8jrIUqsOUmrpW0irK5g(6s5kDrk8oCAwM8qLar1Sd6noHkUwqR(uQcOrsZN2gAoTn0AABO902qNPTHUtBd9M2g6pTnuxBQB5uJB0NAKJ(uJD0NA0J(0IFWd0Pz9OUvLXfvOesLVy8IS45oyZoRqArrs4lIkLOS)J41bN4NoDlutzZh3gaA4oN6WHZftUtmlPUyhjol)FWprXbc)apLnyHOkZYIFiTNs8yskdLMK5KCvtMofReqQ0ysuWu3P57IruAYsZtKRFLJXd7Y65EaMhNP59vvLqjtsVuHbS1(0K)oYt4Ld9NhfIFzWCgJzwAP5XaXKULi5MzLN3lmQoLZKc7CeY)qW(0KfksLQkeHtmzIi1ByexArO2(9GLafbgGoGYpN4lplOQ9ur0z9d)Ey0BG5O2mN3atcXRN2AkzXU8C)9xy2fQC2fxqZ4YNzXfpZSNPYLpD3wncIIcU8Px8CNz2lEXzp3IN(svMPTHy(utOc2yQS8zpq2eDrNsBss2u5uxG9YAybsRP)hMzJLPpz(hO)X4piACXQ4z)wsuqN4wGYxXJfX7ZqpLwA6y3qnIRToMmgkz8wEA1Znktd1wWgHRIhfng)lqQrUeuZnBk4H)RfNt85WwZC5uX4cYyUhvaTm94vJaHBKDdPeICymUrOevrkakv4W4rgz5AvOPpZ)TM1t63EJLFTOqsO7RRkWGM2XY(kLzq72o9BxJzsxbcWMgHaSUL5SPQjFAb0KWAMtm(RLuN)xF9IyCFtoLJylTgqg2IifvWRZh1mStJ45XC69Yx6SNG)9Z1mo5eVzAhkqg4utcBvLdKtPfhDXYXi5rdQYCNeSCEBlWbtBBthWzttWBuwY6LiSKDPIvafMCDq8ugnb5XeCzj6ueTfe0e564sbsgURgLj7WxFTmjl(48frs3Po9uEGhaESfScgrEPQTa8WnJ5rOpLCjoSxquqcaL45SEwEOrWyJlRC61Q)Qnzh6Y1Z5S4kDBbIyXSujRTl5tq7cvZoXwKWolI0tTi1xaUxh4vnG50rEVDmKo07AMZ9ZimF9QX9(LSWkHF0XSbnjOZv5wTasPcg1f(mJw6bsxHYtAq3yLGRXYriuxmS8QCM5wA2ZEUkvRS0SlDPkNA2lw9cN7sVXzxO6PPtaKtho(MDHZCHkYd(ch4j3sUfDNUC99yZ(7ppM0TCnhZxkf5SyibOJ5c)wLK1BXS7K(M8UqGF7DoplBEN4oRYCVX5NBHLEowZ8t7zjr2BoDl7m7s(Eq)LZE408JX95bOpTlyNmlyJrwWnBhUKWwVjT6t4I4Mcmrs2ixjIaMYZMcvykSszdeK8eQnhLN1sYZQHXxk9kQWI(gj1nRmMUDyCyu(dJMaK0TlzTdfte5X91Pvi7SGvUfiuqlvVtjM43d7e2M)Tem)4IbwAq(jM8MWAGwlz97k9ISK565KrerZoS9pE4SSqNf3HonAwedLMM6ms8kf)eMAXb1WaoG(ovl)vhjJ5UYevMfEunk8OOVbSKI)ulU0slE(lsjUrMSvvEnpKUfkxyMUk)pPkBEE07OPz567BRzQJbR1onp6hZVyoUFjH7xQIu3PGutj0SvBGeRCMph(1Er6oy69yPwg3Kfs29m46ekqjx2OCLLKg1xQytAgvtzBjft169JaBFPKwqepDH6Tmbq8egUC5hjfeDvM6Fm9MeoyZS0wCW4e(d(c4czqJqvLhfexCCi61nUz9GU))WXYpN(yHGjcOs7hIfDjUKUAc1QK)DPxHNCcqujLNGaBXnKzK0HIhvqx29LIMqagyyRz4bqgplhdF0Wtlhz4HRq(fXscE6cOP48kl1pM3Y31Z2x3ZvhaXgAwmqUmr5yxfRSYbBToIozxmtU7EQ21D2tV4cvU8zx43wfKn2Sv1LWBOq7jftGKmbGw9Elsw6QiAuKlhfEmb5dHDoFohnnSsVFC0kGFZAPK5HoRPtjtd946Rf2MzhoMXlbXPB)S3SGjf9Cr2MWsEL0KJHUti1I6Ev(TPk79yu0lc0iDjsELgWCQonPcBewR)kRalY(r9qRTzFlUzRRH2gUc5DvR1xPjUcBeeD1Urb41yHD5Gbb)O7iaIQBls6wL1dr7TLxeyaA0GPRILl3uu(zikrcWufZaM2HjVWxIwMZ6khktjxgwpq(AMS3jtcAg0UhIqPMAYVTRGJkjjenZKV2RCLylT4fuVeZIuDhLySog(aDPwVIVNSJOjHNHpPAZLrOH0FWVyvnr(PRf0ILbGmhyeXSWO0laCrxww8sd1QBTGZWcKzLGy6wor5px107bSCNIsP5I3ty33p(DEHNYvqJhEVVBWxV3glp4UpB4hU9XV3dUYc2626yItwz49VXWD)Ubp8zd(ZpBJLh(0dhEVpfANOfa86Oh(Zh9OnpENDh8X3gAXd)3HUC0toa(i01p(BHUm47EIO9an2W9E8X78ddF4HdV7UWCEWpi(nlCL8XhFVTHUERV947Sl0gXVrI9B2UnZwq6U4I22GkcO7zoLSy9aBJRYmKRbZwjbXepQVPx14077QEQkZW3TNVwsiL1Ca3rlG(NR)U6sNEXtXoHnIFfzBqMnG(RbENUAdsszhA4cwAACGmQQfiI63HXgLWV0(vXBL1Q4vROfMACalaQBFHm9chp2ftXqtEhp43Nds7fDP2ehbiOKRdEhYA2qp9Y3aKM8HNUdgIlhddRt5oxmL(IUoA6Ew((4PIsMzufadvJcGMcUwWw98lR2vdxhmzPZurMXSTO)Qv7biJM1r7Hz7EUqO07EOy1J7xk95qwXAGKORIsV49kjOgoF1q2n2t6f0Obgcbm)izfdb82Z1eTTvE)0PBpAAxep3XnZJtdpuwnnAY073wEBSvz9bLWXHPZAZ4uzbkJoDhglrKj3AaQxPdix1URNVNNVHJMRdyCGMh3AkA0rTjkr3kZXAMdOiYruth0u2iGEsuFgOgIeEGEOyuYQOClmcyLUC3t51tnfeK9(y7ncGtrlXQyvROz98ZzS8IFxPdNYtPtukhi8wLVn19POOX5gkV9SQxqpmaJWK345PhyiBM62twzvEJnicSimSsL3ytU1U5aRIHYxBKFIdvFoGNVYbNmRvNEWjR9VkbNQsiihikZEaIhMvFbkeuJEoSgVmUuYAWLGFtjUH5UZlaY5)Rt5AWb1Dyx0MeHOOARxLDnDOI(ctyv6VwQGkvjX5XhCHQo6(gw2AA4FSzxLFkV8Z1A1rAeEiMRBw(g2GVSGxBMAUMGGxM7RJObi9KQk4hfe1JOdqDbmIWrsOOSVAMzg4S6YexXfr6P4iswq7CK6S1dQ9EYAaslInPrbACNZYmPjiJmtbP5DKDKqLNTLRMLVLHPJJlsEZv5jNPckYdJ)WpJf1OOrMovOB6Gl1I6owyEQF7azKMJUURPMHHRXyiJkHwHr(xM24cysOFQwbRYPqLQQW)m8Mk9DCcykP9fi9FA7HqK0u1EHiPYw(zejvsJZi9VamORLVNVUPMTRPLUuUrH8aQ0rfYi9IPviOwC3OrVs5fk52(frspk6n4ARonJVS9XtrRT04ozfmvweO7mwBiM4YPFpYZPPWecc6upQzYZHzhpxkMTCEbumZeEm1QAxRzwG)ex4VKuIloLsvmvY40wiJlIwHcJ4xJnpD1y3bY2WK0G52POS10Okf4Jw4b066rbIJDIkzAD)4WOttHwNLmrSN2cpT76RHHjd9DNP9cWpyIlLgwH(DAYUoAndALMGiSi0ffwNDFazNma)cKHKIzs9y43A1Cf0EfgjfDRYAfEnkO9mx6DfltSs80lijcJqbw)q6gLiYh2rDzxSpiF6LEMZDpUx3UTs9P31WXeKt54Xd1ngSaSuBOExOXZfGFebPxAVu35ZwO6Ye7fb8bbwSa2UwZOgy5NjzDsGgmBu4d60njugJjkpJjccbCQwqN4WoWd4HqfDBoOdM(a8TkqrQEOy8sAryyh(fiy8bFqXafdE4cN6C2nHFka5NAfSmUX40v4gHk1fPBcA6kDjIDuzE6sdcbnXm)QhgmP6RZQTaSgZJfy68qJqiUntFwVOMDGpJ1EekJoaSFeGR0PJ0azLwlSoyDh8CG2HxMqidpezJirHkVM7SILd97iOZx5cVpVTRRVVNTLJfwbR0WdKZ0o9IUpVJPNMPUNdOLKQZv4V7LE5RN32YYdm82g48DDSjnPM(8B3(cye)CTNXaJJb)kwpVRJLMNHMLNJNdO)1MpGQxRCaDdRNzC9D43gDWssShAqpmHPZuSke3K6f8119MXcRIjQxAAqnVhU90SDSST9mrd1G(kUyZZB7y4PBBA65zcdkDaxyyvy3rEyNB6JZMJLHRPNCHYV(0Z7AQRbeAMUgg(6EwKXTAIB()cwoE(2ZO57KMVYIfLd0ydeE6aESWGOwUQqCFWOsBaLyR5zPBtwxQNDJTacXNrhrumaTbaO9NXapJw(ca4mmaaVD6U1fl7ziwceRqfWnyCn5uXTWs)cqKaIZAWonJA9xTQiU1GM(qYWMmu)mUIeKDkx9pkz0aAsNEdknjneUcQAk7r7qLtkohage12GIf6sdlFilq2I0y4Slm)Ivx6slT4fp7SNtNPulmkHfttEqHRHYgQXsnyWpPAkfPWe1YHMyHaB8f)TZDXzp35oZSlnBvaJSWzx4nOaJv58y(ES45p1SlvDPZE(5WjKNrdvd60bKIxNDtgQNe1Ix0Yy1oh1r)Tp7cNzX3UksZw9slG)dTYlCpzWCldRerDI57(unhSGKpw9fYOBpAThLRmkt81R3kSFvgoxIRhl2DezG0jMXQ3gGvHyR9XnRUf9xt6Vg0FPDlSRofVg1YpyQmhxLIXHzkksYJiptUnWYlmx2rcOmk8cGBADYSOFvzQkSZsvpzwiPpotNgxSuvsyHmT)5B)mU1Ye3FtXskZO98Uf4ttP7KSf3QXa0vR9HJ7WzyLSbQGchVEhQQsWkxEvvsrowftMQEAR0IFbYygIj9rR2eofhkFH0sp2LInmZr3XWWvCgMJnIjA2w(Pfdw)0QbRV4sfzsMQKEojKP1mHI5sn9roZwO3IslJOYOigvdZm3PaueZ8ZEPZjguXn0GFcUzcfZ70T)glpBu4glNSg8NtbaH)lK7p9JceLK50toA61iOEyfkzFvn1idM5X8J4dm3exwVXLo75oZiineB1qmHj5pInLfx2eEQqm))y)WigbmlBDiVmOYjcVeiMEx9WKXaCyJpBy6)cuwxTjRw9rRPCUUSGUkBvLJ(lpB4(F2glF0JE8rp8hOddVWm246DblYPQYZcI7pnL3evWtV9t(InwE47)GjnaVDyqpy1DkynR5kUyzCMAyuo(l29Oh(ZhF7ND8ohUXYV2G3)loENDHb9N(byqF9chvAhv98bR2SE15rU0WO5X0AHFx04NC0OJ9X7(KJV7xVXYd(PTo6GBu8yplH9xVAL(RSsxe7iU4Au9mUWr92pBWxV3KwPZgvhuOv98GdtNNcf96Il5goOofoOFXThENN96JhR0h9HAEKKz(MrHv61mQzI4gXHJQBrJ6WV8hgUZTN8g)IRTE3wyad)TDBbl7UIBphoOEfIX(Kpy4M)4Kh0tJxahm)BUq3MXaXGMH4U2recGP42mWWVFjDtpWYtZtQBH)Ng8)X(K(j1nO)87t2yzg4Ho0)H377gER7YoXqwxLw7YgBDl2DwhgBlWrcxd9jp2d(Pnh(t7jZbHd(zy62E7J)NFcnh8HqEV(yZb41IjFoaRG10CN8um8oBo4jBpy)pfZPH)6dy7JV(GJo49g8(7HzSWdGDfJbHgn5DdK4EbpxCzSWd399oExmvkU7HaNyomWSnanwJeeBkBncWSAPfEA(RKiVnHSDcwXEtHw2GpqLSv2AVHBT7X7GP8XpDJJ3(7zBMV8GH389eamBwWRyxfrjc37Llc3wzS9Dvr4AELSf2FZH799ce(GV57h80nzdVgOG1IvAfeCRMUUw22P4AltTsg9phw2BdClWh)MFg(4G)4)Ma1AzYU4LUY1ULMMLaUaE2PPvYOF0J2)4p)7GH(JrH4SSG5VDBuK0F(bSzX2qNmAhpTCfiKMaczBJooxc0)t(3p(F5pE8N8aaWds9zOH7EJJ3DpgkMng0Ki4Pn0Tap65tITUVPBjyHbhC7b3BBGQz4dXrFR)TbFY2CSa4bPhRsui4QDDTn5cJVnJQyWJoeeVp4(F00ZfuRv3Un4P0Yvyxhojas3uS2DS1CmlHj4Od)mwwk95ho4pd)7XF52ahbTUo(lVjOUH2iSrIMjJuPt(oUPiCntF9sjwh8DiaA)9GzJMcyQhU1(cyfoexHL6ysEApBvjGM(LGUhE4wyUBT7oay9dEYG7TRK3GJs4JcnnP80U4TCsHVtVmrhp9quW1D)z6d7s6Lp(M3Gj29E)nbyZYrZ32GviseZLpqVzQmx2ULmxdU9Tbzsd(Udh8(7YaAhS5X3ejMrk5Nie3ARBPPZqroPeYA2gszvoALYWdY0)5Bp4G9g8NyKad2AlU0kBxFFwX2rc0WW7WhC4Z(6Lm4dU)3bs6L4JhWfjMQWGni0Ki43bsmFwTaSciT(Oh)Pcw4bp9Ry2VakYFD(setnigWwr7SLHkI1UuA0V6trY)7GW2dEGq8bda7AaSZKvGsn0(UyU89QKWXuxv6TUCUSm998lzUo4NbnZd(uq)2X7(uyBD0JFaF0PEtdVrkTcE(MCHEM22(LOwB4pTdy7etqXToyW7TTqZGnvFoXYHoBK990m468V5Dh8V(bd2he6dOsWwmzx8icxtlfD5PAQ01m9kZSeWYhGFN0LdRkWuKJE6npEZNWl0F0aqZGTk00xLYWXUKzy7BawEZWz3FBG8f23F4(h)b7jyq84ehcUplnphpd5uagsywgcdSXDRV)OhEaJU7MBY2xhCaZYHNUlh7rdfnxPmJE(wcRsaAhp9sKto4)8GHF9pYGxKwEeL8akttrX9G6BxgaZtUBC9D0LYsSmnDl3ShG(yhGW(47(Pd(ZBoCZ7kvkYnd1mLr1YivVoo4ULQ2AW94yJp8gdV1(Ods3KB7JjGXPX3stU6bYBb8bq2GORseeamLd39BrPUeRjOD8Z2Nj99V8Kb)5)jgMWhRgHE0mPNI190LQS8mm1mSk1oiG2I5A3pFtHAXbF239Rr0(No4BEGq(MbfV5fSsvbBzAy)sdQbCHSIIsQ6xQwDkKj4Pzzucv1NS9W7CWGhbtXHmYze9p4(F7GV)jGkfuS9Md(ygzmB8O5ZkflzQ5inq12rZPmoM7S7G93AWpSlicA4xbaXJ37qaycZmmx)RFpyqmxednw0KLASTVxQ)c2A(wgLT7iZRHj9MBn49Egnhd3z7J(R)XH3Nl1guryXc3GvQuadBpP(EIGPmLW7JedBUfcZ(AUA4d)iGDsHMJHNCvGBgwVcGBQe4stWbftSsfCLHpD)JV7NXubCp4pVw3oBS86D7hTXY4lbJxFQSNnSgwFfOaSJtJqIGLUNTHW8sdqNszAwbx4gU5EdVpk08)aT8JXj9Jhm8l5QbObHIjIuSa(ENj1ajFmnWlHdcub8H)rgsbGtWSCR9o6rcoiAaOzqxDg8EvmdkkUnTmufcuMpJ78bd(x)zMXx7GY9tjGj)v8zLKst54BdY(tnI0aCkUm1yhaUWr2qD0b)t0fz4Oh9yWfmHCmDMfcYQsQp4Nxk5RRrz6jh8jBccgj3wo6HCpTWd7ZNepklGPgG1yUslMGDHLx5Kq39jOrGFpia7437bapcys8XF8t4UnUna7q()3dMEohpoQ0Skn62bGGMPkkTTmlZU4TqtcV13IwFZmj8gd3)9eQYaPuSYpQCxHbrj1Yf)s1Va(y9544p4wBXuMTZTfSTd3BFavn4rFwQB9muJxk9RT0kFFdWL8YIpeqTEWMeoAWNXNKp(P4wAlMCF2GqtIId36ocrX664LM0OCMKBH6t(KBn8PO9TFYhb(8n8NUTaQzAXQgxAkCj2AsSITRxPYtE)Dh8GdzUNWD5yZJV1niNKh832weKc(yrtMEkldwtsfeEUo2LXXK5Uan8Up7Oh9JWS8WTgEFKC8HFbSZg8mHRbMgEKogzjMf0C56YGFkUti8S)1SUW0jjMLqLxUwF2PoVsuyNFh(MckmYAM)HERMPEkBzyjmOIf0XN)5jmQpDOt5MbPXag2UAcUxq0nWvvwOEU9ZqhRiq4UF7W78mY1hMNb591urZMSQFAbinZujDMgLrfoy3hGCpFh6kWhd)zWpEJmXpKngzktYyU8QRRshwAaxjVcpExreebNs)v9I6w)xLs(X8TrwoETm099Tu9u0VutqpGhjQhdSPSjAZ9bFCsDxKfYezr8LMdNxnZHFkzTLLawb6LC99kpIIF4JhCWxXO)j7QhU)od2)P84MCJH3)gmHq0OLPAadyFmMM8DKb(TY8i8F5Bfceg(0Nn49z(ha2tp4U7diPOWeGtIHMmb7OPSjmT6ado8GzkDA0yNw)eWywV7tKXY8E)Z4Hy9xGF41(vygv8REDzSRzYaDtftGPrEQl(6ALrGF8omdraD5d(HBp4EBsgXJu47VdAZ4Ua7emV40waR)IJL1NFf4I63Sr1AHbrR1F1Q1Afu)QxFTMjHcrbUPcBS19KkY9TT9nSNg9dyKa)IDbWdgI29o(d)regf0nuaIaJgybzXnvOJvQL02G3p(2oLg7xmuoFemhNi1prfzmeVPRTkwx)LhwxQ32G4DCtLZ4a(38lvodApF)4Wre14MkQXXYtE8xAwanvPXk)hhEhUEU93ryuaaQb7cjdDC9uav2kIJDT8l1qQbF3tyMZMNHN1FA8veVa4hjU2XTud1E43doKny)pfDl7J)wcHF8n3B4N)zscn(Mbhl6WhtfUydEy(kwuMNUc)ITGk2XYXXZS8yB9WFG8BFxrqLrlG(c4JcCpwj5XjrvAIL7RaPjTdItEUKM0QjkljyvWucmzzfIp8uSvX3X(LG4JCsn8sLAaw4zkPKS08k7uxg(vFkZ(10y(m8Rpy49)uzO89yh3INTYC4y9QzoCuvq48kaLIxUGNluk(k0KkMNuUblXOUkIgmsTIcT(Tmp7W0MaqLYZw00fVw04GQkVXk9O8nkvu2W7(ziJjAK5W93BWMFlm(OVVFZ3tshaZrtdhjJb1xzQCmEPjAZWJrq6RiUrx6JiO70hCcPmP)3MDgbWq)32IDG(GrnmJxa3zCO3zul4NkIXWuM3aVmSwctX8RN3yj)uHnGV86P6LbxQklviaNDb33UdtF5X)l3apYX7FdXzpny)VcaHG7cc1p4istPPIQnt9xQQ28tfy4AivhyJPDQxzrf6VXX7p8am6q4z)HMBS3MGOBwu83ApuyfzH9d3hG0SjNn20KldlIo9i1a6ugS8pE7b)V(5J39gSOR9Onh80VIZf5O7qK2(QYqKNeXltzi)kuVa3YnBtGdIEPNTGVuMGjOJY4vCMS47PE(rEVmp)idddwKE89v2rw(Vs2rOmtpEU1RPSLC0F5EKy685it6jy(QzoKYkaJFC8up3n7sZefkdu28hXdb7WH7Vfl0R)PTspVnBTSVWwW7dHudKTHLNDzcKqd4)IDKNF9HF0W)PntJHOr2xDlww(wYZdZ23cS7USJJ9MV3Wp(P0EyW9)UHFZZOQhZWhE4XFXTZC8H8rl7lDfl8k5kTUWh87XQSZhB3Nn4t2IhFpw1T5Wb3gf1UZJ5ZdnkS5rkDWcRHhI5XZ3300OSJz(ha8ojIJDw8d(8ND0t3guis(8E0tVjyBgBczdhBcLsfSnW3JVPasG8RSWJVnQz47WdW6MFeAlCQnXsaisetZJ04balkZvpSfgLPshSndJWS444EWHWEKLlAp4WJEYbGLfkH8NLgDA(PGrFT0ZUcaQ2LfW0hU9r)4tam1G)xGnkhIkuWt9b8O8N2dMnbHOh3scDzsiINOG03BBpGtWPm7o)RFlgS57DdHpLs6X7DBoIIgf28ONop2YJJJOrlJYavwa(IDl8qAz4O)3FqkfoNqqxrQGPmDLy8aLTpysoPyi(KBJhfW9VXWFMQvt3yW9(Jkmt8TIu2GfA7GkTGMF5h8W(7WS(6hpqgESNIPc3WnFcvOP4ZgA3anBsrf2AUYdnvhCVXRSq0dAVzgfDNThEl(HA)O9hUjxKkE(l87DLmZeXGy7PUL0T9kvChaYo(9)wkq0W8GhAdnRKcDwAgaInTy5ENmjfXtI1jnta8DTl9SaE0Jp(oBHrtCVH78ZISmG3v2G7QiMldxQwzI5gUZMd2ANH39qmip)zHT37Gj3aHIau1(7KskWL3PNkwW3uAR1Ro54YuxeOYnKYxD0GFO0ZRjJAPHp9lgS)tzihwVz5VBQ0aFpzEuyz7aFRmdxF0ZWKRDNDz5H0h(JOH5hC7JVXHezpzX3NroyJb0IoVcSIwHhmqqlEC6yZdBLORiW106vJaxSuCYMnP0dlhpn7xXS0gPgxO54)kIL2ivUHTFQMrtDFnB)Pj)nzZdPkoxyVmX301mgadfdl8TTYWaugh3EBE8DyzL9Wp8RvupX7nB8DuvBONHJ2SCbtGOOV6tlsVUglUD6gP2p4Alny1gVcVLM1DkgC)Xp44BZeua(7Ee3ofkD0C5eyEksX19FjIYzdbBs8vLTQQJvV0te)h2A4pDBqXhkj8J5opFiEOxpCBuJ4ntLfPZohCDzYrcZg4LwgDgLL8U3)gK2bUjYKAwYifmZBU7Zuje055STm9ibd9qD(cVA1SlF2sZPlWYKH3tCEUuxzdEQXdU(sXE007ug2HUzjOm8NIkLYtQ56aAI4VnKmvmvvE8JK03Y8l)Oh)amV64honmpPcUzhJVUzQdfMPzXbZajVYZfyWQEWpO7M9AKW7nB8tnqq3ZrvrNUVBPPLWrhEiJp)BE2Gh8e0nV7C4GVEVuKSpJa2uHBx3iRLvLzK4)XtafMOfiugPDNhmeu2LttNHoR8mttvkJp41QTsuskBMg(5pE4o7mC)3JNcjFWGhj9C94VAZbF2NktJp2vispn3kbTl66Vk1QoIEutvzcPoY6J3xHsN79bz0KN54jgi4wb9Dh8dIJZLpqSBotQXdajIIxl(6UEtPPDV)dsLXjj0XmjI7zuA6xA5A5QNXSGYUEoycPVllbLK7KBDxI7f4xvf6WZ)sDRu5cggzeXzmn2tE3NHmw3ftyG3)Fh9V9WpcESYSW4DTs9NWvZ3uDwkZBpMm6JE8baNfdQ9tBd4S0PG8YJk8tIcOY)q3(rGfxkfzLeEnXiswID53tFw18fZEJ8L7ORVwZySuHxblXgqZP3LvZ(oyr7IviOLf79eLHRhEtvhzSeVNBQPowZDU5LLXMgbRFLkyD0K)ECSdwarcWxaKv6wVH4Q2oAzrwuFxffgArPXPzNWySE1G3r4(T7WUT4S3v(8IIG89JqJ8Dww1eQ0iCLWoXnVw4jWY1a7xXAXa7tD5)i)22kBRSyhL5PyrFcndMxrFsOlKOa3ik6qy9ecV4ZYRuCUvqnLzTwbZzTcNXAPZxTRKKbXOwctXjTDOYlCICWfcYJLTQMYRxoVIRhZQJ(S6coHZYvj2f9wCZ0XQUDZw8QW7K2KN6fDtMwJLA1LQdqeju11ymiS0Hs5Dlyv5TSxSeQh0QE1WRrL(CE999uf0C(lrFQsEGvuhwhOoN2l2L6gp4SMWVqxK)4cN829A1pwzCiGMYBW)0bB1W2uDloUQogo7APC40B4bcUYQ(486fnan6Hv)5gNzEMepw4VTzVt84)gvtba((KUrRlFBE2TZs8kOdToJPgrVGLaNr0118DX7owLGvwP57YQthr9zDzb8OA54b6bZ74AaQT8Hj3XcRrZk1Df6IKl7gvIxB3KpokVPl)fTwnDXt8T41kyIGvMf7cUEgZ4t(ZLD5HTet(MSRp6wh6lRPqpVRtTmRtDBx8f3ArRtxBVSWuBBDxtmAPam1wZtVyyk0nxFRrxZwSK0Z9fg2Uo25kT72Hk1GJb2cgS6RzHLT)Gi8(tAynkuv0g5ku8Ke21lHGTg5wNgtZ60qb2IMRB75lxN(QKRyPLqLcWt3DgEoABu8qBRm0EGjeuDiQiqGNLFo0MNNUNNThyfSVVj7DeYOOn8sBGoTMJxWzQrx1uadQlwFSEH5BwiCq3BeAm4jUWUtZbV9OgeFRXOlwOvoiSDeIm2bt9cH8uzm8ST0TgldmAeEMvThwf41azjwGafpwnx1Ccitv6eFlq0giGQq4JPMEUzY11Z2f0FBHx2kBNIrMg4v1ZRiMq2HQz8lvWHRniA1YBCc4W6UM6QgKgIf6vmh(9CXWCxmji0pmiAfSQjnjwViRAtvqn41InwpMkcuJbullO2cCibRnTGdJAGBiJzrd9ZcRVzJUOjtX9E5iVtFC0IwM0XwKkWRGLOOnPc84p5xMYUPBbAyy66yo5fOOnPlq(tsEbX6kcGaPp6UA6JraK5isl1CTbF49qV7TDyVnHmkshcWaONxAzE(kNNxku8g8AQimihFLNzEsuquKMdatnD8DtfTpnYD8SmbxR1hhwZlNGhS09IPZNVHHfiNZwaxyV20NS5qEatNM3yLw4BLBxPbmvUAEogE24lKj5UYQ4PYxDQCmay442v2gJSRa3KDmTSn1D9WdJtSRSNcDeG9toJBx5JVcQYicuZgqqGwBtS4pMAqktd7KNjWCbFmQVfsbRLhtbwjBya6Ja(hBqDV2ymtttdSMUqvOwV4YT04YfmmLcg8hNGlaSxMCbrBueCXEIGU7xI2aGQudt52XyiPZicgmbtdbn1gwo(GBfJtWGJpPIzuWQ9lSBqAtV0w8v8hwonNeuv0MuOk)jfibZ852SxhB0Y3PthlM8k6Z4XYPsJPWSdG72ZCSAA8Yjibmtg8zXwZ3eKx7X0GpjzwgzTaudVypJzQCZzbOfwwvT8XJmdC(ZxRyQdtxyp4zxe1Htr2L58864ja6Dmm9hJUoBJCqFqUYmwtjShKOai3XAsStEdvnnb9OGXTE6o(EPgQovWE8AO4Bnwdk0Yd79Xx4bo6yP6WZmfnBnftfPZDCQMaYN8cb0CaLUO9e2UA2oLPVWiR1N2Qtvghc9Zle3eTAbMjFW(fthTYuxOse4B7INO)42t(5mIWcFRkGVbjXDe6qwHKUUgUyH9nVfpMViEAHX)qLN2glcufVA9YBYdAbITMNVpygIPpvuIzyGXqcBLXvlqgUZ4S)x3oV0dFeOam1aPVJZyCf1eqPU6MJYsBWU87o)IJrJgMHAJb(4BM3tlqeGg50IVowTNhtCVmna7flqmK5l(A2y6vsbIKDlZNfrBsvsXFclay87uO2VyORow6ngJra(Ao5cuNV(m22JgOoOHA65Jt3lMjuzdphE1kg3IdJfAgodmKaiVKHg4FUMX4c5PlMZafqUwy45Mk(zRPo8CGfWAOnazcp3e1(mndRh(sn2BIb9ZqZZ12rLKN3PxsX7vhRZtJbr57NNh1W0d8Vf8ydJiX44r99D0gvUcVg9hvpSA2QkR8LakgAF(HrGlsd9FJM7VXWAJLXRIG2j1n)9ZwpP51AMS(glJJ8j3yzG3YCgFEvHPGo8gHjNMbEA2TZz7Ss3x713y55XsV7VoDmmzLA3I6)5XJsOc)1(WIDMRtJnwoojicG2BS8VFJLRJLlZMDwLx(B5N1bwqqOUSXYbj8Fke7A3v4FdGXZqKFfnNe04mSdLy(MDAgVwydCDdZh7OnOxzKjrbXRTXY)DWig1pKICWidM(V)Vd)FBSmBm)Vd7D(4bDe)FKLAf0nAFVeodNUvyqN(9KB7ziY6c6YPGf1zcxjmqaBUAiGNO3FXNK(Uf9xwftGDmT0j2Ix4IdWuoC3VLUiryB(YNGj6693(KSQTLiJx3B)HV)bO4PSZVMXjTSM8s2VWUmTl57S)GhU5GVE)PzXHCqktL7jTH)ZBYRoD9c7ZuU8oE7ThU1Uh9FI3vGBUfSmh8N2dp19PdyQBKFUToPDHeaWy1PRK0ogO76YjiNHkmPfnmt5w4ONGjrY9U5W7IfdO)0Ed)QTp(2BovlFR8ZRb8FLaUTlSpt5AfVZjF9EdU)wh)EpyQwHo5MnlG8Z93VyNtVgiQie4YpF3gH4laOKx71PsmArnN)Ye48VZsV5zp9zU0cVXClUq1kln7fxIwdIxlYWsODWvdfh6ktsbEwZKGIvcAfhoz5i0V2iSvW6uTSgpD1vJc6bcpOMOZ6njnbKHXExHKSEVqLFLNkdvLVJRZp3QlWRVwyNQybBp7kGMyEbZwD(LnGw6nWxYSb0BzwH8w12q)rG)yiVFhmtNSeuMSHNTb8Zguziu3RqSYCxdMuOrV9Ix8CNbrhlnh9(E4IkOMEbR3QBqd9tkGp8hyCs(kK)Dt47uzzn3ebKN(Yj60V5SN7CZby)QNFXZmhBwyVKLm8(nAouNm0oPL9jn8lqBPMV1m0nLuVWomvAlnOKZXOWb4vR6sm2CfnPVy6lnSky0ClxHjEgHJ0pNjlXXWPW(uQehdMag(vBgVrg3FZJ3biwFg7h(MNn8EFa)kyU5GB9uQGLMDMm9pPHwjRoVc7ZuU6WlB8J58pp9q6otoMLMF(PX(KALa4m1kSpt5sJxhKfvgTT2DClnZ88dg(N0QeOMPrH9zkxAhDaIt5v1wkfJbJG(YdKkTlynMN63WensyC6rmTkS5))1J8lupIrg9i5rt50Dq10pt7cXeV81Dy6m6ezvMUdmsXgoYozcMYFsdRr1D477nJMMhvJulQdtNNwAujvSWb4vSRwAfpPVy6oW3WwJmAgLR7WYOW(nr5m4b9uqFMwPZhShpdCPR45tFc7PFWtg(32NU55SBd8GTVbvzsZotG5hgL4yf(MSTG(mTcObBVGv3xCdwnF4B(EHn1Jzb6KzYaR29pPTDjlq3c7Z0c(U)thS)duUpUtA15LFMSoPPzjRo)c7Z0Qe5VG3SQb3AlHAJcxyImiwK(PvBIHhZXHomIG6RLpRMdBvVl(gaeF1EvL9knu(U0eBV4fqS4D51AbrxlmgLEUs3i8fHtucVp846WZVsAET1vsfAEePYo)0erVFtXGar5j7knJIPJQOc717d79Yt6WqY3JcR3nk)Ry2rZL6Uy(LkafXPVgmzrlRD3gDPyjf3Vw1GKKOM16NWExoYEc9GUvXfzbV6R05V6RW3)m0ASzm9E4Ksm24ZjZB44o0BvumPFzsVyVe76IVdSWGXLzI5Vvj70nQn7n906xz(t4IfWCthndnF215G9kj(DXq9ApJHNURPh8x0y1RJjMGNNbwuMWkuHnlWDWVGV0TTC0WCj1eEQbMua0VGlSUT6YFjDzqJRoosGbzAy)4VDO5r1dWTmL0WwPVehkP3s45Ph(EWYWddnTe1PMa1QebJjXZLjuFkI9IZE2ZKHAGiwa6NYOeOu)Vr1OUTeVwpvPML0Y83YX8xu3scf23xeOoPbNcs6I1(hcRdAb5VMBzipQDVv468qKYFncx5menltn1CWkzJLpBNgGg3g9daDAxG6LsKvtNy1PQs)AlHBqC4XjB0HE2wYrdmaa6kSWAu8GSa1z(SjrT83AHmY5R8)5d"

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
