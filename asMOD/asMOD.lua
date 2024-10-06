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

local detailsprofile = "T33EZTXv2D(zz)JTw7zJy6(E7NQQ8hKsK2QgjqTcuJJRYfbBa0KerGainAizo7mSKTODKT0S2oRKf9yjT07yBzNOPcTKSJuf5D((qa(DypNZ9r)anqdrlTB(JKXHIe423hNN)oN75E7vnxDLvR2lQ76TAhI)A3lhgf0UDTgTddIQ1j8kXDJ2yZG(XRUWQvBe0lEquyTOWG2yJ3e)x4Z73lSD7gYgTvR(nAgehG)EWGi6Fd7egTX24V1myRGncHFlE1QrDVsT1dAgwRvhO3QyUAv4xQWwTIXCm8771oy7WOAndJdA1UFTR0QtZUxbh3(ncGzl(a9Ve8ivxS9LV4zwTADyghh(U4uC1QvV02TB1je7hC9i6R(1cGP)grDh0B16RwDq)WA9Be1TDB8VIc71nkUgUOQbp6L6l(WTascTI3Q26rD3QwNGTcfRZoT2AWw10uSUBvpiUwCRTWPMbSOVCyh4VJcACPWiCAh2jOE7WMy3UEx4RA0TD3iXkh)pg9to9tl8NWuhxcWmQ1gBgdFIJ8ds)GgZzkPzIhM(xl8F5yhqdu)ndqkx1klxzr1h163kNM0FUEqdGMTuuRF7oR9FBqqZiGbUZARG06nbUeqJUsZgqdbAvTExElCju0x0djmRhHui1Jg3kUnrV6hJD6Qvp7YVfYQACPMrD7LFP4Z0Rg6x5j)Qyn554t0LUarLOKkId3awlxPvZ4nHoW2qt80ceNwigTZAvdJc70kEBqyVxCRUD6xtnJJjPsHyqC3AxzZURwffk7hh0Pry)A9d3ylGN2VMC4rvcspzqhsMs8rXD72oUvpKci)1ABf8U1cQ3QDR4wH9xTINqwn3AN5Rw64VX1)MswiDN1lmUp26Qb1RhfE5wb4cH(aq8TzOqpOabmJ58nDDe9EspJCdCb0PPE2yyBjFa6346FJydEc1x4bcBcJseOEJ8IMTUCR(DJMfbBuQtkwI2j60yt45aDXWWo161TV8HTnCNZL6GtWTnMZw9KOex3bAANyMMFvjPeaZlEqFGERxBC5kJlxxC9QQInSmQ4G)WD1QVv3O2nRcpEii0aRYWKHhwF1IibVSux38tISkWUz5IXbrBOyKTG1KqReKBElrBFt6FI10NOW2aJ(YHyV0t9PahiUlzmKOPc9A004G6GW6GAxbmo1lOhWHwiPjs1sYaay4ARGon7tkacL26DJisNMbHp3KTriBEg55I5jYwoUs5cbrlqF3oRXtrKNUqKKS0D917hgNBGvlLGTaX0yu6uTOeuilWcEW72AlKySvy8MDBs0qKK1Vw9nsMINPtCyeU2FNQNFXZE2fwE5F97ufD4vVB3lDIZdEZoHPEQ0RBRo0YmoU7wP6TgDHbxkvVKTTNHLnJ7Xm8yClRvx)ecTTL84mMJnJz55z67WnWVHKsxY1X1YKBz66YTDm9543yJuILSnyogMUw2(gmo31x0BXsjQeconfqHRlqMbyMEU2G1ysX21ZKb)XkP)Jfs1S4mlL0wT8Kc(EsDjpPUetymTh4XnJfkG5EfuTs5USvF0dz)nj3X9aCdGh5EHHcMbsH3ki6scRzjI2bGNxQ)eTTg4kg6Klh2ghzlyU3zWwHrTauc16VD)4WTG)zR6DB3hrKaklvjuhYXbSYcprZWG4nRPuo73dgvCkjWC0FQWus8pq6BnA3QXLq3hD7f2b7JXGu1yt4pd7SHWTOYNIqqfyy9rOo9q)eO2jINOw829cjReiWkQJ6mOh4fAJUdir7KPqNUa2L6sOs1fyFA1PwxWkKCTiuZj)vT6SrnqQT1Vfu3aA1gb9qnhGwSEWG2XiZoODVndWvQTaTeWYa7gcFfG7WiyPvdOv9f2)jojWz70a4JDG)FYPqyNTbl7GHkG(0VpOVqaRWjCZGiOxqiC1vm10aYYXMbHhUeZwy71LYHKxN(iUkWqFuyCJnfO0qojAZp13JoTvEQRvFaOH2HMjBbq8I2UgGbam9BrRcOHTqXM2HOqv98IhsygGlPKExqDfyl7lG4f1iSwqdWGna2GWfQqi1ODaWKr9tatXwalkTvM5B2C5o9FhPLX3PfIxU)7qpsOU5PWKmOxViGUkvJq(xEPFsYrH1jpk6LSTmS4M(GbgBFMVdzZHjSUMtll4DvAzs(aIkgxxnfRyu3Qw)Re0dL(BUnauUvdf8ynOxCnIYGcdkf6pjoLuFnq8CJwDG4mOfHuvA92bBiWdlCfxFBeyFNaWqbWfhxRcHeQr2HUK7JU6hxZev(WhpJApQJj07XFlLIVi4JZHXbe0Uv)4wneDzulH1L2TB1K6UukucPw0mRVLz(zqIcTk4ImbvGg2cVIsstHvqdUW2tdaMBAiGYQ5pGM8vc2UVGmHJayec63G61c3QEyZCHNGFofNda)9Dv(xrrRTt)h9b7hAjF4XIrj7UdaB7I4etI3dgOlba7aTPOTJ3eEmYcaPOR0TzkQoqlc2QN0bZj8sHJqgfWjmTeoKi124nbP)n72Ujjvc6PnbQynk2lGjZzkTnIWtcEV5fRSYIxq7bZXv5ctHh0IC49wZFHlCMLtANRYvNJkUelkcRZp)zN)0NPIUD(oY2H(NP25sT7CZ)glQBKLzo)M(0AA(lSyL5R92amdiiPXH(aYD0u7IvEJlS8fp)5p78VDQfIcWUcUo1JN(cx8mNohivlv4fguto3Yv(1zapPgmBkuRtV48R8M)6kN5nEZvsOfU6qvutmAnEHLFJlUy(aoCuZhZKL4BCHfxmHK54POzCxvh6Bql1QV58NB(kzX2nNLAj65kih)6kA6fQBQ0rLtnIlDHZSy1vkeoPGxF2LpLMkmNTIxBROfUeTaKF7tWyav3fRS45E7eUULPPBAmVZzyIRCfu1tViqMZl5zPJ1nZOC(fxzSyvuRyIOuzXlUYfM)SfjHGF9I)ML)1Pggf9W21rlA4trWvDXZUucsoFdtveOCMPTITj(8yP2n69DZwHTBsw8vQwsWT5uT0Yi26WzTvWdlsflF7LT1KvGKGOvc(SfaN2bHPw8OKrXBIpw2blnlyYJe3vns2511WV00WNAHuPZY0YWP41wAvW50dh3Xp9JmNEDXfqYlsZm1KDspgmyvNgxk3QkToDgsal7QC8vvE9YKNzcdvgL0YgRX4ZfBvS8rDEWpnILAIJRbalYZ1YR4hpVTJPZ3hBwxKHbjJxP7pjg5BIX2nRJBEsDwVwJjeKFSYztX2G7l6CHlXIfRZyISe5mmHnDJf5scWp2RD46Xe8gamLaBHcPnGxc(vmHU9tWEuTEu3GMyoOHhpfsgnqWK4QQDPWqiaGW(X16byU7gTfX9xqf)cbJvK33m9a95aCT(IuplGSTruqVnbGFuE)WGOglHC5HrhdaA3imsbL2obAUiYKWMTIlkWqeBn8iiqpj(WakhJYF98D7V6swomdlqoWZMdUJiS8GVYQrbnBnaJNe(efbTkeLgfP6viGGDBkYHefPnrtIjav0Flc)0mBWUkK12uIuMeQul7K0YcQvjPKgAxQWaQiaS2Tt7TXGKWmYUr)IcUte3Mo)Zcu)aoYqkCkrGLaS3TO0r1z9wBGJX6cXcr(fOU9VFaU0Bggh2GyuuM(bCTipQbGFTXMencIMgIrkkUV8p2mSnWR6LzMTfIOTrTMqKLHIEcdnkHRh0OryBXgEqXmHZA1x2pdJUh85nQTvxb)jn4DrsCG4z7pEcfKXuQ3mLjgUIWznUat5YUIdlLPstFqWPalM5mAvX0cqnRTfK3iWCQg7iAnyilXiLDoJA57Am39ZcEaOHMtXRx(2YMIdHSTfwBEjq00T2DcloMDYQt5YWS45G1ScmcAR908ONV5ooVa()HoFA8UXBDkQbN5zoofz8hXFAZhTzFpzZDMihFS2A76onp755nPeUlyIK1bufBpZPiNowxBnLgNRNzo2tHIpwJDMM43yToHGONgEtU1tv0EmXqh)jjBpEBDnM2ejFZt16jB2jVGLPbBYe9SABUMtCMNJMyAWNmZjxNYMOGAoXdtdRPqOZBWXLpnsxUUovJlqMEmXu(SJegM12tzIKZCMJ5mISdSh4mfDL8m5eDLYaLwjLo44Qv5K4sJDr8uaWGAY9Ae8TdiEOAAy7vx6eUMwmdUJbZWh(xMcg17ceFF75aBGUCpHLWQxz1L8m88yGfBdUnqazEyRHVzZvxY1YXWXM5ZHpfu9KFdM5WUT7kgmeH47sERVICpSX9V2WqIiUfTTd60akXHj2gpaizNn6t7ncVMy)NGUWdtEAC7qCdMrisDeP4UZavteumMAFYQ2hXdwHqiuFJArIaGW9GBaUfxP2YmAtaOzeaSOw31LZkkpaISWkZP(u3ZozI5j4A1OQoP0CFN(r6xJPlNbepuT(ykDB2kscKdPoe(leSEq7wB0P2wdaCu1srYq4s1QDLG(0w0i20((xPfcVeHvHOj7Nq1f55aGlgVjGpFJnvBTanBg7lJWDyPEkEW0Q)ay2rBlcHld4vkO55zV1A3ARwX6uVEcCFHiwQyoq07fqY9ci1EbKyVacmFbXEzxTFpCRBRCcgIAoqNSw5AwKI2inMAuGqb1uHQxxWnbXW8cy0c82kjdLKQecUIHjeTmZilndBsCYslz)N8zK4zDH(SNxQsizCk8BiQLHQPgRL8m9TC9SD98DmC95o42CqzDCjxFtgZW1ac42a(fp53WHNX1233IZTDyM(Cyki(gDbgq6cOCshCoOTQKk8ZwDWugsm1lh0EaTJ7gKnXzTH8zTHwZAdTN1g6mRn0DwBO3S2q)zTHMgZClNzEJ5mZCmNzUJ5mZEmNv(JWG9gISVdb4KwVzYfpHSU7A1zDYdek4Eb0GovSCKTcia4zZUm1uX4j9FsD3zt3D4yjSB1xuquITywu7m4Vr55b)fzntisHDMPLCtpxq9XKvkQedZz5JSQ1lmQbv4DANLTExmTlfxquPilY5EY(BrpY25(aS(htQxQAP2CjYYx61VyEplw807mQKYVe6a4DayaS5wzLLWeyqE3sS5M1xGyuBmOFmUZ3OPOQ)3r6J5VFUDwJ(n(VN(h2VpXUjYoMHASrw1fSS7p40QFhwMK8iQydmPgTjjGb9ageLKdqCHQJM(VZ8nA1CHiAl2HVpm6nWYaBUZXW687kjTMQhR3zX)2ZpFLQNz5kgS350lV8PN)0vFNt1TDZGOOG35ulF2tp)fUW8ND5tDXQZTftnEPRJbrFMA1i(aDtmvpust0shIpkdPg347SzHAICO4OGo9BdEYvpOklzmZeHRzt3lf0cXFG5ZCUED2ivLKLzVAJdaCsbRJ5bJCtVGSHa4JlHBZlMuP2bBNR8ECZwxB4)ALP6Qgp)BQ1HKgLF5ih2zBvMVQhWNCJOGTf4rgBWW1bvFiAdtjgnkMZnUgDkz6t)FPvJ4bBTZAVwuizc(1tBmHg2jQARLyiYuNbBvxuaEfyyBwmqiESm7KDD9NwGEpmNLk8)vAla)NF9ukUVD3b7S28rH7Sw8MWpwaKE(pLqo2eelBtIMPyrlf1kStZ(lHfl77CXZCc5FF2w9JpXBM8afyKCMfPTQjP0jYJJBQrYwYZlsBuEAe0LSTGi3ST5oquCCdbsqruzem5vk27uy8vaJszCvKNDiTGysPkwPoqYStQcffmW6ujId)5RLPASNVbywmeRmRDw78GAo(hn2oLmF6HFHc99qLUzaUrh9Lz)orSPFyVGOGyGqjRlCssnTNgrsRlQkxOfvZW(bWeb6uzjT3gmKI12XkJxEZJ5SnNZKP24yrs9ts)FsGfYqyWA2xebt(qNy6iJD54jkyWgTe70YvYf0ifmjb1sUEKDDCqNljbYag7cgpI4mH)LSFuvPYogClwn4YI6RbrLatYQNEXvM)mNTATQRm)kxS6cZFHAN)Sx8notLANI2hrP03KB25p95RQ30iSJNElLG8ov5U6XM93EoSqyLESwQu5W5XiS1Buu14TBlQtr6V0hXa8VE7ZjQW2PUYQU4BCUfRSYlWCwU5jROkqYzBANzvkxdMVCwdNsUzWVie9zDc7KzcZgBc3ARWvuOEN2SpwAyBg4eXPd5xgLRw5DHu5tOQwNmDX6ILFvg3tyvL971hneCB6evK2cQTECQKI0pgvpB6NBMRw8mTHLykkpYGKHsSm1dC9ne2ftNFmvE2szZiBcK0foeFCtuwAtugyEPsoAlIS2rovYgry3oTdfBfSkhsQ81qGEI72fNZD7im4K50Jqj7m9zrHJ)DyNWTK)fUr7jg2PsAwuqInI6wtVV7jhaMmhRNm2cB1rS(Xn1vKYT(DOTSwe4QgVTJVH5yP6u9TyLkhuhZYcg6y98N6KmW4119SiZQguMvHFklk)fwELvw(CxGkxMKJqg5CrEcr0rfN4jxcd5LEsKIZLOlsFzjarITVbNZSSC44Eiq1)F603wRjkQjLHDKhngzq9P8pndqkf56tF4yQlDbwGRXS5jmRGnIoif67m(JZ2skJSngebQ7u9nOYgVYNEg1ZtWCLkXXfKBwrymyXCOsXGiye12QtSq4pGaPdAgM2xzbzvh7IED73Qrq3)D8obKd(HYGdruP1dPOUI0WEDfkck01KtauoZiPLTNI)j1jhzSkevU)kUItBfnGanGzBW8akJNLdZhvrSC0gFRsXXjkREQ4ysfxUOkrwYYh0W8n9CnbsmJ0bSSewWW6RrCqUYznCBKDkowNY4AthUXzo1YvQ(oNPYVPgyTSv7ARGN5HTMw2pIf1GUmf(Pp)L5SdQ28ekSZc3OH8BeqUaShVyvtoHDItqJ4S5s1(dTBvlOlK9(n2mClHzkSMzc6NqcYEEfM2EqOkJfr5VKuEn0jnPEu3ljpUwzpjKQNIip6y)0hucSeStk4A6ycd2XX4NQwFW6RJGfAFzel86umKT3E9w40Rzq0L6gfGNmgOJeTS3GOEy0JGqyBY2x1TdXan0hLyGA0u41su630ELiywQsOPgwdnBfgFSpgUI0CKc2tjhRwpqqjtzbL2pfDAtHWVIJjzKPFqzL(Uwz5ZN(ypRkZF0kX2ykMm1o7k(K1oMlaznbL4hxNkkYBs)GT6HcD0YHx6HeMGGPY2etFsUAHQGxoOTOqMl842IhfP2DRhCAr6CRg0No7uuz2vl5KeRx5OLAPjErgW7kpjnYI2cA8O7)nd)Q7UZAdV3Zh9H38O37HRwX202elT8QJEWvhT33m8rpF43(8DwB0ZEYO7)Pq7uTaOFh(OF(WhV7r3EVHF8TGw8O)m8ih(0dGFfE0p(RHhz438uv7bzSr39hp62F)Oh9Kr3Bpymp47vFNfot(4JU)nHh9gF9r3zpOnQVJm93ARTeOcPtZlcXbDgqNuDQCZ6byGRjG31uGAsjmjZ9DYHvo5eZAM42m8D75BehsNLcq7Oni)l9HxBLtT8ccuSK(kQ2GkPG8yt8KITfynvalVILHHKiJUBbHQbDeQrXYJ9Fn8SETbEsmAJfxhOcG(3RK5PW(tCewyg6JeI84FqEWOJkNcMn4ORdEY0A10m547aIQYUNQ(C1XRrW1PASRpvGJUogMEw((yCheuJAazOwua0uiecXSxEe4Uu42aSLoZKyMaFXGnQ1dygTAGiJfREPrOKtVOA2JRxQa8qvZ6GLOlHwVKpvCqDkljO6N4t6f0SjM7eSCkfxNc4zYRfcXvFc3XePN6ruFUJBMpojpyz90yOlNzB955oTPaWrC)WKrTv)eBdP6D6KrwIjtjIa6Ps6qP7Da7SNNpdWp7aaeiGYiIkQ3P8yNKgVmB(BoIIQKs5Op5WiqEsDdpqnef8a)q9rlTQlSHXiR0XdFgpQXjKGSNOBVXiCP8sSbEVx0Qr(XSV(OJxTJuYl1drfTGkaD5Y00NsxOuBO82lU)d6Hzsfg8MVipbMLQzU9esRYBmJeWIWmPvEJ5seV5iRQUY3ySVssvFbONVYjNceRZo50Y6vn5mTfckiIYWhq6WIBOGcj1y0dBkViykzo4s0VzK3ic55yWC()7sUmjPUJ4OfeRmfvF7AIdMaDTXimwL8TLAOkTL4ITHPXUzmohl9tpMEJiKnlFMnedleTg3WvKHcmS1C2V1T21Y3Z3KBy7YTmTKXNnUpcLK9yDu6z0ywijlJ6N1GNPJZ6qtDMbvhunhvnhANtExmFqx4t3nqYDItsgHM0UkHxAaYYtuxWH04o2ks53Z2Y1WY3IXDCCrzCPFp9ivWfoXK363(YB3OXhUmsl6ox7k1DI08Ka49zwgoMMUyMSCzYj64wcMQWJqhOmxYfOPqFv9cMLZGF10EaYOGM6zNKvMsAFbUaM1NqzxAMAVYUuzt)m2LkPXf4cqOsKuIctqKpTytH6nhppbb173nA8tDEHwRTpow3rZTbxEJzP)1TV)m0AldzGvbZekatNjIByQtNb9OOLMbyde1PruR4xaOgVqoJTCogoJf2kMz3RB2klXFQt8xsoUvBgBAovb4DKgVDmbBI2gg4pS5AFEfyhsEQ38mtN7oWSgwskIWovx8nnRrj(OnOuyHjlqNtXmTEq)WOtrPxxuRuIpTnUN(n2eZugg7UWXfWRW9BljTcd60sCG2Af0oPCyezOlkSH44dk2ga5rqdflZS5EW31U16iEfH4fDU0AhEzkX9Iq6Dvtt8U8PxqCeMHc8wjPBuSQQIhpKD16GIPxhzUm84ED72ojMExMRRh470qMUBmzb4L1r6t)jU3aYTji5y)LeoF2R8Um5ErrFqILiHTB2kQjEP2eVnzCdgnk9bD6ghQZXevT2KfqfDQEqN(HDGpqMcvmS5GoybtixQG0z6ThtEdyeg2rEeeMCYhsHnHjtFy(RoUe0i6R3n8YJJIQGCVNFOtXLXfwQl)l6q(NSiOHR0Pi(GPgNUuNipsTDqNn0(3sNLArJL5cmzCOEiexMjFwVOwDGFhVQsOcfb4(raVYK2wduvAZWgaWo4Zbzh5TkcH5qvxMKeQ(c3rCf8qFps68tDJfSKTRRVVNTLJfErAzydA4C7KBOGLC4EgCtphaXlDDBHFVxYXOEjBllpWWGnO576ytwi4(Y7EGkyg)CTNJH5XqEg3xY1XYWJzy5545ayPTLDy6Z0pWUH5ZCU(oYBiaaej(egWtWHHJRMfQJGEfFttV5SWl9K0hRCaYUhU8mSDSST94ign4zv3Oclz7W8mT5Cppo0P0MCHPvrCDgaRCUpoAowmC7jvtu5bcFjxUPbiOXDzmFtplcxRH6wdOILJNV9Cg(oj1QTAs5anMH0thWIQGIA5MMI7d4jTbwITHNLPnbS0u3XGepdiO2ksmZI7yohUZAAkSh3K77yA7Ac2xHyvWoGNLYubzzZzIC60e(LCSTTDCDTTn9nDGhwo2Y1maOYCoy4sOGU4n6gY5zoC6ctJgkHMrB8mLdcEGjYMIDiP(GnQPYfoGKiKaoLrJsOPfJQORMDZQJhpjP0ocHwOsslSstHk42o0fFLuRctm7wGZk6OmR)qtUNts1GCMklTCTvU4klFHZm)znfondJIf5jvMO56O9M6IIUgc7QEQRoX40xCBQjcSWx(3S4fM)SN90ZVY81aUCLZu5nOKTv9CyzZS85wy(vQTYzo3I4akRxIAbD6aEgAioJjfo)yYlXW4O2YREnXTus6r(TotLtV8Bvd1rQDXk4)qRk86wQtF5QpXBKiX7t0hKoJ5JD3SQCWLjN9nAhoOMGNR51tK7oMDvAx4e3AbaQtS1(4cY0I(jN(jJ(jTIakXcYBox5MDLzlWsb(mZNN4CjZhlV)DtUfil6BNuFQEyDxN5MGAcJ4KseBQYwit711mqM69qSPSUc6x6bvVqY8XL2jfTUMHzAMb5fDLjhMxSf4e5VQf(u2WhYTU4AoU)2DOl0cXf7xTuvAO4ECMUt3wVTSSVeG70XawFk7mevZsgjBLZ0b7j2N0jMagdBl)KROw)K7OwFzEGaVwKTi9EVqW1fgfZD8egBFGHNwD9vPUpQu9kJN5eBGMLwA(lEwvNQo7lYDfotMDkSORJfxt2Qlk6KDJA29iKEdqsvBx1tNTXmFSCBdbiS406nU4zo7PhJPHCRMQbmo)22LAYLTwQkKZ)3pimsialQcikYf6gnrElqMuJDyrEabekhnS2PbjRl1sCdcsZPCHdvXmTAv1d)xF(O9)SDw7Wh)Jh(OVN286cReKR0fq5txaAvuNQBQwmQI7i8N8f7S2O3)HtRdERWGEWSBbyoB4QoOEsLAOxo6l27Wh9ZhDRNF0TFYoR9AdF)V4OBVh0P)03dD6RxyVsROANlyJwnQTeQLggTewUmYZ2NC3OgVVpAVNE09(QDwB4pD9dp4Qf33ZtC)TRvDW6R3f5oQdciDllxyVERNp8RU70MPZh1aCOv7CqqyNJsV92Qdni2Pof2PFXTgDNN)6tMRmaJlBjuKzPwrHv71kQvS6egI9QBr96O)43p623A6l8lS52DBJ5F830TnmT7QonIyN6vih7t(Gr7(dtVtpfEMLWA658DB1hegmyQZUijiaW7fvhy1F3kagdanl)KMw4)za)pXVzEstg9JFx8oRjipuHem6(FZOBCpXUqkEuncArFdGATL9TfeCIlZC699WFA3r)0D111Wb)mmC38Mh9)4P0yi7c95KumgyTikhdg31WWD6dXO7S7WNEZH7)PyDs8V9qX64Ro4WdEVHV)DXQG4HWQsOGq9M(SwsAVq0qUcv4r79EhThwEg37jGMyooW8nbpwJLtCQcqcWkNPnwHaRhRpDMIvcqb9tOw2qCvLSuU(DhD99o62yzK8tx9OB(DIfZF8Grx79uemBrYXehTtnd37Lld3ovF77MMHB4vYsy)DhD3VtXWh(N(UHpBxr3By6WSex4dkTvURRLTDcV2IBusV)5W0(MG2c8R)PFg(1H)H)zfR1IloiRU65ULHHLIUarlAyusVF4J3)Op)BGU(JrJ4IkR5VCl0K03(qXOyZaOcRk2b(uuidffY2gdgVeQ)N8Np6F8pC0N8qGWdw9fSH7D1J27UcwSOpObrPtZmT89u0ji6qUBjCHHhCRH3)MGuZOhH9(1)Nh(j3uYfGOx9e3pgkTAiItU0y8TesfdF8taZ7dFWhn7Ab1B3TBtzzYSQ4SfQjqMC1C3X2WHxIsWHp5Zev(0N)KHFl8Vh9hVjOrqZRJ(JxdC3qlerprJelX6KVJBcd3G7BwQW6WVbjq7Fxy0OHag6rxFFfTc7IvfLNMwN2ZoTfqUFjS7rp56y9GT3TbY6h80H3FpTUHKLi7fAys0PDXJiwk9oZYmD8SNGgUU3pt)YEKF5JU2vfMDV)Frr2SCm8P7zz8Qjwow(G8gp1yz7wYyn8w3cSjn8BEYW3Fpbr7GDp6AOWmkj)uL5wBtldtblYjrq2WMPTv5yuQcpyt)NV1WdU7W)NcrGHx)6sRv2U((IRainrdtzKSZHF33SKoF4d(gWsVMF8qPjXehgIoHgeL(oiI5lUYvRcwRp8h)uLk8WN9Lc8lGJ8xxofXYnsqSt5D2ILMXAxQm6x(PO4)DqA7bpuz(qqGDzG6mHcu7H23fRpWxLcoCZ0wVn1JLf33ZVKX6GFg8mp8tb)BhT3ZGL1H)4dL9o90u3ZsKvWTlvA0JBB7xIBTr)0TbStcdf34GHV3nvEgSP7ay8ECx0Z(EgmPp)RDVH)tFWW9bJ(aReWIPFek3mv4wP8LN4PY0G7vgSea5dOVt(YHzfaf5WNDTJ29PYRuAQdOrWon10pTKHJDjJWnVkG8wWZEWnbXxyD)H7F0hCxLcINu4qP9zz454X0dbaKGxgddW4E9V7WhDGqU7A7kwxhCGa5WZ2tY9OUIgReLrpFlfQeq2XZSe7Kd))CWOV6he0lYlpYsEiv9QO5EW9TRGG5PxnU(oMABjwCUB5WEa5JBdc2hDVpD43U7ODVN2POegkprr1IL4xh7C3sDBn8(sUXhE1r3yFmaPRjX(Wboo1)wg6zpiEROpaZgmDvIHaqPC0EFnA1LunbVJF2(cRV)RpD43(pi4e(4DKOhnsMjCDptTllpg3Gzvkoiq2seA3pFnLBXHF238xHS9pD4F6Hk7BmkFZvSsCbBXz2V0OAGwO4sMjX9lD)IQSj4zyXkrQ6tU5O7CWWhddXteIZi7F4d(6HF3tbxkOz7Dh(XcXyr)rJNvcxIB4ObOA7y4uMgZD2B4(xF43VhycA0xceXJU7taIjmYWy9p9DaGyPjgQVOblbSTVxs8c2g(wSYwDe8AyqV21h(EpNgJr3(Mh(V9hg9aPvBWfHLiDdwjwby2EA)9KatzoH3hfg296in7RKUHFYhbQtPK5e8j3u0nM1Ra6wAbCneCWXK46VV6ONT)r37ZeUaUp8JxRBNDwB7UdI2zn8T3XRpt4zdRJxqfuc2XHrzrWY0ZMPGxYaFkL5zfcHB0U3D0dqJM)liYpHM0pCWO)O0na1juor0MfWxPojaKW9bQm4YGlGp8piykaDcgLBC3dFSsdI6aAemtpcEVkgHuoU5wS0gbklMXB)bd)N(zb4RBJ29teGP4v8fxuMCD)Bd2(tarYGGIlZn2bqiCegQdp4FGoCeh(4FecbtzhZuGqqFxP6dX5Li(6YkZp5WpzxWWif2YHpsgPfUbI(K5r91QkdqJ5QrmHVcu8kxe6Epfbb(DGbSJEVhc6iaK4J(4NkdB8MaTd1)Fpy4LA8yVsJQg0Tdqb5jokTT4LHl(6iKWB81i6BbKWRoA)3t5kdSsjUuu1Rkmjkjix8l1)ceJ1NJ9)WBCDHZSBFlLA7O7UpWQg(4pljSEbRXlr(1wJY3NbHKxw(HaP1d2L4rd)m5G8Xpdxsxxy3x0j0GKkGBthLPytt8WyYkxj5gO)Kp5gJEgIV9t(iiMVr)0TuunUL42nZiLwITHMRy76vQ9K3FVHp8jIWtKHCS7r34QuqYd)l3uLKczFrdMzIkdEtPQe8CDSltJjZ5lA09E(Hp(hGr5rxF0dqXXh9fWkB4ZvHgWzEKpg9fFl45Y1vq)sfoHkY(xZ68ZMLyr9z(o1hi2151Jc78BX3PrHrwZ931BJm3YZwmlfGkrshFXhNWOb0MoLBe0Gby2UgkTxW0nOvvwQEU1ZXaRis4EF9O78Ck0hrKb5J1mLNn9DrQfW04jw64SYKchU3drTNVbdf4JHFm8hUAM8hk6JmxEZyPbBAMwoS0eUsrfE0EQmicbL(R6f1TXVkr8teBJ(sc2Iz67BLosr)sHGEGmtu)iOMkgOD3hIXjjCrrkt0xTW0y48Qzm8teRTSu0kWVKRVx5zu8d)XHh8Lc5Fcx9O9V9W9FMmVjxD0dUQWie1BzUJIbUpMtt5kIH)vzre(p(1kdcJE2Zh((I4da80dV3(atkkmg0KeSjoGJMQwXK7SyiGhSWRtYg7SgNaMZ69EQoxM3))bUjw)RWx8A)kSIk(vVUo31cBGUjMjWQspjeFtJYeWp62cGiGV8HF)TgE)Djq8Oe((3gXmUhOobJloSfO6V8ev9LhRUObTAwREyq0Md2Ow92bnU0v2SvCOYuGBIXgBtpTJCFBBFM9S4FaZe4xShqEWu0E3J(WFaPrbDdvKia0GijlUjgDSsqsBdr)4B7uAUFXu58rWyCIK4etzJH0nDTtZ1nF5X11(TzKUJBIDghi(MFP2zq88d6hoMPg3etnowE6T)YWcKPknx5)WO7i9ZT)TvGcasnGlKa646LIuzNYCSRLFPaPg(npvaNnVcV45P(pL5fG)O51oULcu7rFheq2W9)umSSp(Rjg(rx7UJ(8ptlOjxmyFrB(yIXfBicZxXMY8mtPVyRKIDSCC84LNBRh99uC77PsQmIa6lGFvX7X73ECqsBnXY9vG1KTc6h)cznPDl0wsWgaucSaCvMp8sHvX3X(LG5JCwn8sSAai84AjjldVY21LrF5NkWVMKZNrF1bJEWNQtLVNy7w8StngowVAgdN0oiCEfWsXdVWlelfF3FsxvQu9gR5OUPmnWsqrHOFllYoSSjawPEVf5U4rTg7002BSs2kFwPMYgDVpdvmrqMJ2)Ud39RH(hJ99p9DK1baoAs6ifkO(Pgkh2lntBmpHaPFkZnM6yebFN(qqiLz9)wI9ia66)Y1fBOpaQraEbcNXHEt9vXpXedJRRBGxgOLWYw)k5bl5NySbIL3mXVmesvzLcbeSle(2De(lp6F8Q4wo(GRQ27PH7)Lajecxq5(b7rAi5PCTXnFP6AZpXGHlt7oaiUCxVYYk0FrY3F0by2HW9(dHBC3Dbt3IS4F97IgRie2pAFGslgCrFtdUoTiM0hLoHoLrl)d3A4)RF(O9UQi7ApE3Hp7lLAroMoKOTFABi6DI4LPnKFf6xqICZMdAq0lSWk(ABcCWhf7vCLS47LE)J8EzU)rmgtKPhF)uRil)xjRi0MPNSE9nsTKCmF5ULyMYXit5jWF1mgABfa4hhV077MDPvIcvbk7(d4MG9Kr7FDrQx)FE9K9BZ2i7Rrg8mwO9azZS8SlZGecG)lUTE)RFYhn6Fy3KCiYY(cLXYY3sVFy2(waU7Y2o2R9EJ(4NrRHHp4Bg9NEoDJ0m6rp5OV4wz2(qzVL9vbJfEcF1Ol8H4ESkB)X275d)KRlZVN4gZ5jdVfAQ92)OCCOErmoARdw49cIAC8895CwzBZ83d8DYeNyV4h(5p)WNDtWHifZ7Hp7Aa2mXak6oXaQTkyZW3tYjesq8RS0JFt0ZW3GBG11(ielCcMynbefIPXrdEa4I6A1dBbRmx6a2mmdZQTJ7HpbwJIAr7Hp5WNEaGSivk)fLrNHFcz03izVRaIQDzjm9r38WF4PaNA4)laJYtqhk4U(aru(t3fgnLGONejHPUieXDuqh7TThOj4ugUZ)TVgt289VQkMsT849VLKrr9IyCmtghB92XrYOLjzGolGyXUbUjTcE0)7pircxkiyMYQaxxUscDGYwhclNuoeF6TWTc4bxD0pt3)txD49)dPuMKlfTTble7qAzbd)Y34H9VTa91pCGo9ypdlfUr7(u6YRsoAiUbA00MkSnC1BAQjeEJxzPOh8ElafDNBo6gYn1(X7pAxPjvC)xKNLlDLjIjX2l9sY02RuZDaj7O3)RPerdJdUPn0Oso0fLzay20su7D6Iue3jwNKkbW31U09c4X)4r356y2eV7OB)ZQQmq(OIo3nLzUmAPgLzMB0T3D41V9O79emjpFRc79TXIBGyraRA)BNikiT3zMywWNRXA9QZoUU0fbPCM2(QJb8fLUFnzCln6zFXW9FMG5iEAr97MynW3txhfw2oWFvgW1h)CS4AV9EI6q6d)bey(b36OR(esSNq89zua2ycTO9RaVLSWngiOTmpDIXrmtmtzWLB9QXGlEfFkgnT1dlhpd7xXQ0SeWfgo(VIuPzj2nS9t8mYn9nS9NL63umoKR4CP9IJVSGfkaSual8TTYOauMg3D39O7iQk7rF4xLY9K8Pf9VtA3gMz0O5LBycmf9LFAr(1ne5TZKLGFW1wdy1gpwWLw1DPaC)Xp8OBjmuaX7EOeNcvoAUsbmVuwXn9FjYYfDHyq8tBBnTpwZs3r8V)6J(PBbo(qlHFSm45NGB61JUj6r8Aj2Imf7dUPU4iHrdIslJpJYkE3hCvY7GeIm5MLaPGvEZ9EEAbbtznBRlpsaOh6ZxfvRHD5JwsnDbitgDF1(5spQOZtap46Rn7rdVtzCh6KLG2WFg6ukVOMRd4js(2LINcQQE7hjRVLfx(H)4dX6QtU50W4Ky4wSn(M8Kak4jvXHaGKx51cmGQhId6EzpgjYNw0)jaem9Cs7OZ03T0Ys4WN8eHE(F65dF4tXW8UZtg(v3nHj7leG5P02nzzrwvgiX)LNcomreiufPDNhocC2LZthZuCTptdvIIpe1QDQSKu2in6Z)Xr3(2J2)9KLqYhm8X6ixp6l3D4N9P6Y4tCeImtQTsW7IP5RsVQJ5hLN2MqsGS(45vO0XEFWgnfzoUJbkTvWF3bFVA7CLDK4KZKaEaersf1IVPR3mcT79FyInoTGowjrYiJsk)s8AaWmdSGYoEoybPVNOaL0RKBCps7f0xtB0rw)LMwj2fySmM4yZcEY79CuX6Eybd8()zm(2N8rWhNAue6UwjXt4A4ZtpkLfTNWg9H)4bGMLGQ9t3e4zjdbfLhDpsPUuw(76oicqCL6IBjwEpBePV2ELNtFXv(lw9g5VoLUYMT6Jxb5vXRTdO50R)R5FB8oatC5sRVe5Jt1D9WtQ6y9L6Leu9091INDj9vJtZGTxTkEvJiFdB2bVusc2GERi0OP6O2o(vVS6oJvDztlVwueVy(Lx)b4fhqRoH9X7eh8mdpyRoItYoEeJ1hE3MHRh2PFRlhEc8QzGUMYLFG4oGq9TYRkPmFgEHrHqCPBv2y6Ogkow16lGH8DpnlXR1bXVPhkXb3n)GL7t1dN4chsoGPV4BvNa86kcAZ8uOumN0xnQ4eERWuVslY9yuVJxnwT0hXC5T5EFXD0V4(gx82Si7T8EQBzl8ApC9wTL3SVtJ0VWXL0NCVn1UlD3cjoy1BeUfDfc3VMjMf4KxwJ10hZE1COrq7g1cVmDFQlV0GxOGMlF3(txLh410J4bOho5PedoUZzTGVHoj)9lCW3Qx7b9t1pe9wD1a0SxF5n0tJlvBtHQUOWUKVifL3GdXbcfqXnAU8oOgOg9WBu6MNEjYINTihRCXBvq53r3PaGEFC3OT1VDu72zf5TYdnn7tgVOxnv0P)hJIKJhu81xVL42oiAG4jqO9mfFG(KL8mmrinqKT24nIJrQ7Df6GKN8Cw4T)9wTK9uYlm1zAUwpzUYnspzbJVyIeutwZ0ZwiEh3SZwh8ikYyEEwqOpg20fsdBSzl(CEUM5MT0jwGiXwhhsmpzwdrZ5dJHJEw7NHeB4NJeBboSXRcsyUBaUPNej2aVdGgFsBlslUDUjnBMKlmZqRnX9LUyAnUpAzN22og4re1303cKnmnu0AXlE3XhRSSvpUdENav4qz4LviSIVR)CICwMJr6cH3YYZiftGFb8pMJNdm)yfQIGNmSmtothMV8Ljr65g0oCdTp2AePMA2PPC2MM01uEHuogEF5NMjzHxBsGQjeYaZXYXUyfc858OxPc5KTyIthI7Xr2cVW9aqcvqr2UDOBjZjnR9aB7(4RDIGi8S6YSktmAw6wpdhBBVC9Ao5hdpxBN06uYhsFvA9IYQsPpH8j8qlw8SZ3pNvaxtgWJ4U(Um08XeScapMdEL9ooJIcNX54mNnspNnWTXXAcZzol)C221GSC5BIxZAtyoZzo(UfzTLmC5DSPZzKcmNKHlloTFejYbfyBv1g9uu9j)YeeMTjid46o8PpbvTjzck)Kxg2uaZ(UgM8IDxXTYjOAB4AdbN7HHTB7iE9dvGjf45m9l10SZlQRv8O5Y9SMONdEEFRqG(goanLdYGjAvtY6skGsMEwaGhhZjB0kNPwFpFSo98b7(mFlTPwbITPBQWdqlGP9EcRkFRXaLHVj08CyE24BWj9QYQ4HYp9q5WaA4Kwv2SXwvGZdhUf4H31d3Ln1QYUCJjagltNjTQ8TY5QY1WgyqMCBoEtr6zPxuoLps(MW)X8kwc2ipNY13bWiA5d6p2C2KW06c(KCC9h3ULPOouS)f7FWaW1GEFkK84yNdAl4xWdR7gphl8fWYeS1IVc0mYR19YWxMlw6Ltsa1mRaAfxp2C(0gRKZQGbwu2SI8fyD89fOGeW4AJT(tYzaikxMTwvBs5mq8jXhZOV4z10nW6tU4PhyKkVXwo333WdWW54dS(jzS1X320POydOueZ(L6HWXdZyOBXXmAbo(ZW9rJTZjsJ)yKwpJXGVC8iQwzaf7qhiQcNE4B2LSrty7nNJtbmEOLU2(fjCAFSv4nMDCagCt8AEzQYMQ2KiBk)Kc8TYFbZmGPnG911XA2cBfRxkZ58eLXB5H8r3CRE8jIbYZkFGlmBBWIJphqs4jckEAEtZ4422YaplztkgjVCdfE7aB5J7slyMZ3OyDmoeESRNDbUdKhllJFXyVnXBVGjyAW3WjNjwFZ5STh3el0qdZXYeJ3V4jh(s1WzstoN85HXcuLy415UHPlM4Qj4SYf321c03CkYQLZlQtlqy2HX9NaU2XIJh0)NZAgLMb0dG6YKKMXQLolGnohWm7Bz6z647z7OX2mlsZ4zjZ3AIbpyKxA2hFjO4yI33oE8efhRzyOi81tcgkOqM35Kb4yGIDaId02PmSHSSPiZo9q5Nj248a24yekWi5dXQWDmkdAyAHaFBxSSCM0AYpxadw4BAf81llUI8S9k2yaMfvxp3YCKnt5jX0kRvsB8MCR4zRx(WBWOnSn889Hqo4(0Tv(uZbx6HYhI)guQNG1Et782J9rIcyMee9DCMqMv5alLsuyEvAUOUQzhRKuMvL2Y2RyvAFZSInv8mDNtEHnWkfJdOsBt3EBfNmPXIcgmv7bYhCqeYNpP01G3GlyfSKtoX54KxCMDMaEaoK)eczhfBZnzT9CHvNHdEvYXMaZdFohVIShZp(jxIn74FaV9ULLOgvBsW)i)eHuM4EZ4yb31nnEsWIMVLFX4jXIMmRJdo44W3VGzl0u8yU)YG7ZzzZup3WBc0rMLfp3e0Z1zol)XXkGn12VG4g4UhFeV8SzRMdyQNu0oS8iXSD85qicMwE(U2tY4l(C8X3Sj2Xoj1QjlOjB7xCw)Hy1ZN7thxm)aOnjyrYnFbYSedHe54pP4vmhZ7h(E803MJ7BL9KI8hacyLnfHfUHd8x4Tl0aIVGpb3eCN8wAalO(47xFKS4Kc9bBwIIZW3LpXnjWkhgt8vjcizZy4b1XWMvgMQmB1LJbZDYzm2lVgo(QWWYz8n5XYWh3NNxkb0Mz)XaB7MEofVbu(5IeWJXlmEwCRcyfMRfJJTVyJSHzzAnXCcHfyvw(fcAg4ta2uBMNHXlsQybKZqWrtiYuUrE02UqGAUqeRyuiUjOTZB8J77H954jnX8y7fjJ8mGkM7obTColN9emnRIx(n(UwWcEI2(yOXMcSy7CSN0Smz6XZXW0zcvhGz(TUMdH07cQM497dJ5mPTU20NErY8sqlXnBXbG40lEU6KFZQSDads(Ca4gM2Cl(eiWWZHheVxgvYGz2T8gFl84mjK953oqhhFqONbU59DOtXWeGSbk58IskHaVT)V8W(bi3tkf(UJHZeCqXXJbgiiBJPDV4eRdGr9TkYU0XxVltMMSXAsyIBMIrEh5wM47It8Erd8M4mb3R4Zr7qZyZANc3I8J5MeoXeddEAWWcNYMzRBtc2y5Nel)FvxVBuJWAzFjAOQ6OAyHmjR9kCIzy(xBA8xZS2znMXjT5N02(3nFJ4wxUv827Sg2)NCN1u1LbAbPG2)gHXNsqrA1TZz6SE3x713zTLWx0i)v6UGk2dCzxWZFoSiSQkFX5TCNf70CN16hhebe4Dw73TZAnWxoaT6SH8L9HSWUWR)q6r2zTGy5xfIpA31L)fqwNJmvx0yseJtlkbRLA1Pv)ndBIZBy8effg9s3pokO)M7S2Fd0JrdcPajhRZ4)U)g8)BN1e95)vyTl7p4bX)pkLwJ9ymX6EfCeov7WGod6Px2ZrYkf8ilatQthUoqpK0MlfcSP2HxoS9jP)2M(P(8gTZAh9(yfMF01Uo9fd)(BHfh73klc3pzx6YRiD9YI5qm7iB5DsU90NS(f(iZ6KvC6V2)Eh9XpDMNKOAt2H08K2wtFwAAw4Z8cmnp4wd)GNr37eZ60mVgd3(K2M)UL7CQnbr4qq67CDBgIVSmJFTxNEpluuZLVsVo3BVYBEMtD6lw5nwC5k1QUY8xyfAI0pmgvp6dZ2TcUuOQYhfsWy1EscWRh0UF40LVPVTzy7GTP3OmyjoUruqpqOMAIP4PjPCq3s8wamE7EHP)20tGRSzyNA4RfPSJGSOJffxjAkk38Jgy5RTM0JFslO5EZWMTWxalnRPneKEuW3poYxGzW8K(old6BOFO4VcM7VfMKNCwyP6wFMMq7zo4PO00QqU2IxgMtqJERLVWzpnYUwzr6TY2fsX66fSD7UbnnpPI(j)a2jLtt5FZH)MEhwm2azX0d0PEZ5p7zxeKoQDULp9IIrr8(ul5HmHNW)KgoJBKhI9HphEFMy6w4dmtw5r8nu9kxqh8Q1mVPFXd6XZopZ4fU3K3Xo7S2vcGF0QdSGi0hZjk)YX6nRYDBWyf8C8ImYbJFNUAsfm(XDLRV5e7xEbDtP29SeM5U2hHNIiXvIcDnn9(7F0hUpD29)DQ3zjIt7Z1EVJU3TOx5d5gpNtYCMUTzMDHpZmohHHNMA49i7noy0Z27OBrNCou7DcZXX0kip5slTN)SZ)2GE6zxC(FZIupGV4arzUocBphZPsrZJ8kBClnKOjsR8k8zMvAvc2a0W2dUUYFwrZU8kvmt0Y2uNDCJcFMzD2DN)8Wh)zdF(1hEJVHonzfpX451OmXd50e9RYzf28)d)QV68RAL2V6yCWCUrz4X3NZlKj9Y3nk3A8bYWUe3O8mgOmazA2jzgf4gL5AnNfErbZDk8jMj)O4MRHV4jkQdE16hL7v8GE88JY9hV3m9k3ZNLrHp3un8yzw4Z8)lczYILBOXaG8(f5nzAZQzAkXZpLWJZyjuqRcFMxLXXzLxTI7Fsl3xguUmZMzAQKxFLJZMsOyUf(mVkdP0kVckdaaymrxFw(f28)dxF)75qkvN(w1X2SwlCJBWVPAJUbn2m)jcoSneRrO41In(cLvCMqPUGAFTobukRvVhS3mi6YH9X156DJWxISrXYNrMKq5ztKgx8SgPpgXYuAMD8PbAZwXIuDsNV01Bf1NQqOQIxnUI3PTjDdXkIcB0nQz6oBHIohYDXJMPIuGVAR7SERn0PBDRUn7szMS)G61cIJJAvFaLHy1NqFq3A4KSGxB0I3fS20)rZXwGaEVWo0zkT)z1N32(Dc6jpQTcrdXla(U47pACVKZmWcwq1oDJ2s8wsE7vx6eU4l)lUJbZWxCviS(jqdUVlwJF2ZX8mD5EWpXiHUcw7)EEm8cngVDhTffEc8nBIjY2Xal)Bo8P4(4i(gCI1TDx5l4Ag1VMypbaYnWNRc(MhtNIyG3k0vGLYanpulVfllRf8e8HhRSuSU0h84z4qmRpm6jm2lm)zoDgPbsybKFktsGo28nRf1TDyF1Rs5ePzTSCFXPSvCQB1VyJLBgWY1)7cBaiW6arR3jmsWUOwUmi3IdlPRu90KeQaE0IW4UZANPttaQxZbbawQZtpH6j)1HBltrFQS1x8axDq9vWfi(i4qp(GnFBD)dyrHhfMMnlUtQqpSC00Sw5B8FH48Q)F)d"

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
