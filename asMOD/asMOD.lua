local asMOD;
local asMOD_UIScale = 0.75;
local asMOD_CurrVersion = 240628;
local bAction = false;
asMOD_t_position = {};

if not asMOD_position then
	asMOD_position = {}
end

local version = select(4, GetBuildInfo());
local layout =
"1 39 0 0 0 0 0 UIParent 713.5 -983.0 -1 ##$$%/&%'%)#+#,$ 0 1 1 7 7 UIParent 0.0 45.0 -1 ##$$%/&%'%(#,$ 0 2 0 0 0 UIParent 713.5 -914.3 -1 ##$$%/&%'%(#,# 0 3 1 5 5 UIParent -5.0 -77.0 -1 #$$$%/&%'%(#,$ 0 4 1 5 5 UIParent -5.0 -77.0 -1 #$$$%/&%'%(#,$ 0 5 0 0 0 UIParent 1111.9 -439.8 -1 ##$'%/&%'%(#,# 0 6 0 5 5 UIParent -1172.2 -470.0 -1 ##$&%/&$'%(%,# 0 7 0 3 3 UIParent 1172.2 -470.2 -1 ##$&%/&$'%(%,# 0 10 1 7 7 UIParent 0.0 45.0 -1 ##$$&%'% 0 11 1 7 7 UIParent 0.0 45.0 -1 ##$$&%'%,# 0 12 1 7 7 UIParent 0.0 45.0 -1 ##$$&%'% 1 -1 0 4 4 UIParent 0.0 -301.8 -1 ##$#%# 2 -1 1 2 2 UIParent 0.0 0.0 -1 ##$#%( 3 0 0 0 0 UIParent 576.2 -689.0 -1 $#3# 3 1 0 0 0 UIParent 1013.2 -689.0 -1 %#3# 3 2 0 0 2 TargetFrame -31.5 -4.0 -1 %#&#3# 3 3 0 0 0 UIParent 339.2 -356.0 -1 '$(#)#-S.5/#1$3# 3 4 0 0 0 UIParent -0.0 -526.0 -1 ,$-=.-/#0#1#2( 3 5 0 2 2 UIParent -324.2 -374.0 -1 &$*$3# 3 6 0 2 2 UIParent -312.2 -376.0 -1 -#.#/#4& 3 7 0 0 0 UIParent 559.2 -779.0 -1 3# 4 -1 0 4 4 UIParent 0.0 -326.2 -1 # 5 -1 0 3 5 ChatFrame1 29.0 38.1 -1 # 6 0 1 2 2 UIParent -255.0 -10.0 -1 ##$#%#&.(()( 6 1 1 2 2 UIParent -270.0 -155.0 -1 ##$#%#'+(()( 7 -1 0 1 1 UIParent -623.2 -2.0 -1 # 8 -1 0 6 6 UIParent 35.0 50.0 -1 #'$A%$&7 9 -1 1 7 7 UIParent 0.0 45.0 -1 # 10 -1 1 0 0 UIParent 16.0 -116.0 -1 # 11 -1 0 5 5 UIParent -272.2 -380.9 -1 # 12 -1 1 2 2 UIParent -110.0 -275.0 -1 #K$# 13 -1 1 8 8 MicroButtonAndBagsBar 0.0 0.0 -1 ##$#%)&- 14 -1 1 2 2 MicroButtonAndBagsBar 0.0 10.0 -1 ##$#%( 15 0 0 2 0 BuffFrame -4.0 0.0 -1 # 15 1 0 2 8 MainStatusTrackingBarContainer 0.0 -4.0 -1 # 16 -1 1 5 5 UIParent 0.0 0.0 -1 #( 17 -1 1 1 1 UIParent 0.0 -100.0 -1 ## 18 -1 1 5 5 UIParent 0.0 0.0 -1 #- 19 -1 0 0 6 EncounterBar 0.0 -4.0 -1 ##"

local detailsprofile =
"T33AZrXvwc(RzJ1U3gn57heX8bjqcRWIsSuI2JJGqPYQQuQYM61KzwiRE7wb2w2dTbp2UxOTCBWRC02n29WeRmg7gIbV9)hQs)h2Z5CFKpQSQSadXUFy80JqQQ7ZZ7Z5Eo37MQBUXM1he1F7Wob4V2)Qbr(D641StGFKxVGDt6hTtB)4KnxAZ6dJd8Ic87Ke2nO1G4nBSz9O(76TTFRaVWEq3RPUzD4xQPTznLf02mbg6o(7fe51kiXpStS3UH9A1FxCIIB6dZi2HgWeLe8wjdJc2SE9RSxNWEWVeFfyGQVCNREPvXXP3WUbrHqF8I3lojOlohS1dSa87f21pjSFVyCvgfmOFuIxByH6bJ1vyRZGUWwJw9D92oQFxVE(DdWM3ne69WUEYDE)Un8t8W9iS8u2So(BEj7niWRFu4oH987qtoFAs67TB7(Bwh34Xj(9Age7fhSt3GEjXED638kbTWzbh5WEE97fWHbXaqiHTfGPlPtWor9h2Rf03iyH4nWpc(nCLpi2ZVrJOGRgsBXnRPVz9D7h1PLyLgg7Le5h3gB8WbT8tc8Iheat7kgMk6oo26UkQ2U6AoBU9PmHvEJ(9Vsx)ORqqDV4WFdUrbeHemY6VhazGb(QbDqSPH5Kib4F62OFNyORdtayariWMBOhQqpAf4N0gGr9bAMbWxbZkUm5GGzs5Kcoby5qGGmS5vqOD)bb9WXyck1MTH)mO3obcs14GoBdaPo9j4iay8Pg3B4aaXSt)Hj4hNon96dKln4uOW3GiKbH92XRnG3)n97La77D8halqyWcJ9B0jGqWEd7rn1RXWKeKgeNSGT9h2jXRXoE(Dg02h3va4GWtWsQxtal1d()zTT3EEXn7hfa704y)DcOHGZu6fdyaVb9jsBCP2YpcOsqUJgtGYaIdDXhc9Szu)oDOPGVCJtIcsA2MXaGyfG3JXDWyQ9aUAyrKauEalkScHo1cBW2W2NdkjCf()0OFQt)0a)jG08JGo5j64s8og32hHP1RTETLfFeJQZb4)2lPDytVwauma2hzN0iGffWIjjawiMeA0g42tcbUfg0icWPBwFT1FdaC1hOw3S(gRFHSYw2nSvsByrQa4S92S2Purg63IqHn8BELwr9hKBBPWOaPTLcTT4uJPCYTdc3PDc0oD8ZJ97oabS02rxYacRfGp2N4CGpLy06V92WEHKDqGGT9BcY5wbOT2FR)7d9BHBM93Adui8asyMhbai5eWm1fKGfTNh8rBwZYiJyjAehC1bE(XEeHiUkfyCg5m7ZjYkg7cNKvGJIAg453mj8QHj7rs(8GXd)QmY0goyqeqEYL1qmb5yUfGAtL0nqjI7tkroJ)BjKZOxKVMVoA2XhM6WM4Gg3f(6nRVkcIry4LxSvR17fF5ZY0XCzyWbwOltDjq2CjiNiKqrkXLc8tycZ8I31FakUP1EGIcG(KVSMuYtQOK29taU4EG07K(arX2j4m1oSfYLJKkcTc(Dbj9iHGPulcQZlEZAMmffmLMqdbrcmmAdoTpJ)cyRdiGb95KIYZJAX87egNe2KTcJczcJ70jSfxVOuZniuAx)9IzdxPctB0pM6eiuf0X53WlOBdGAjVub8Zj1OG2V3ssFJSAz)JyG7vsjYafj9rHP5vRPLQkoNkyaM00FaADaP9MGP4)IcaWDxtUXjDdJBIY4jTTdJO)naqg7ShXp4JufWVLGet9hcApzdA6xcBZReacGaqbksQ3oe0LKHkKUQLr6vg6i0mHuo0K2aFs7(DArKZatslGebhwa3dFe3ULuHZWYb)72HbDAXzrrI9M97h1IMKx7s12y5lMxc1cQa1djLI9BmjvM4Y4nw8IxC11NA75TvL146V2INFXAI2YAfthSHJIHLJ90MLZV45wU6ULFYUWYBmhZKUTyMOoD2lEPvpRSB62QkUulO(A4AOAOyv(E78Rx71LDuoD6wUz7YcY9foQ48T8IB8AVETvp3Rv6IDAD7IRFUlLcqYSN0YVSNCzc4R1w)mV(CUfNarCPAVEnqb4K7ZPbqVWfxD56BmNl1jX7RxR(SOglmzlcIFqfiLpDR4yAA5ORBQbgPAzOPGwO6u(iTCTLp)BoVt7zxgwN55BeiEDEFNgI81a2UG5fzue0U4AlE2vRn1vzX5A5F16VEMviyUUlBWP(nfY6lv7CxC9lDHlS2IVzM(wjEhf8Hw641ypUAKKaWwIm2kakaGFfv(eNkToRPSmlLGXtbadGfur99BHIFbnEz0kieFbTTeXxlyzZxOo681PrzITwW2ragufTtVey8cUwceQyFBRpHakdvXKYBJRbrDEXLRTO3BU8ARj5GYAyBklwzqCdbnHy5vuALQKOH3cfJIILYnzMUtt(JTTKusSWO9y9LxBfzJCa38CfebAQMw8MY(8cIF1lS4NqgMyX7kggd1YK2i9yJVSMqatEhfKW8ZDXLxofhA5yjPEfdLRYKS9aAtv1oRn6la7nRu)pkkl1uqezkaY2Utt(GLaHQ6MRTG9aXKfkajFTLV0gxCX1kJwPe(zb0X02ssK46mPAxbUq0ihBg)AQfJOfPGfAXmVAywPTtK)aWZjKdM5xj1kwGokX3qWW9WD2jisyQTzQz6m3xdAfsgsvWov0iy0huyMn5MObobVH8xVa4AAnnq0D9i)wHK1qwkCxEyUNaRyWJxY)9DjZj73Qp9PuBaVpGLjzRuQTYP(DimwgNB)3s4pd5V1gPoJzGEDW9abuWGdrUymGwOZcYa(BzIYq)ED2dDYa91AN4Y8vM5vp(nGzXtB(vbcnPZMmRbfMuVDh)Dqyc5VkiXfewcwUVD4oy)3Mj9K51in9)Zdr4ulWh8MKDXK35GP0isSjy0AZ2eYTxFqCnGmP(G2tMIT9B2mOtw5659WUGZidGo20RBFcYNZhbupiOTWpkoxCsyWryT7rrLydCTayqYW892CLtzRc6X1Tu0uCH)LuPde2Gt3Ry56yRORawayAAyaSTW3GbZcmdq10W1uXubWDoggyGQW4nbatnvnqSPHbyJGlxPzmOzHnzO94VfZpFUp(ypuu4CpOdtWIozympmhuGK4orsoSdSAAON0jDcWOqI9ONSHWUTTmWaAIidaUZ0IC5gMbqLyeZMgyBS9WoDAWGzIb3KrsJuFGdrC3AivKmfX84fnZiQWJsdTS9OO0wPNVz7sSNMm8liQ0lgD3SvyeN8cbEe5dk7a8FCNEEDbT9HEOFoablf5LLqK9U(XuS3yXmiE3qK5ajWrVrJXGBMz)Hm7GFq9hUtBrCMOvZeFzegj0gzWbYibZ3u7Vv9aWALWK9aAWD6rrjdTVaXvC5ftUy83g5Q2nCa91eORvqmqjaU5ZmsH3fMNFrs)RrKRGIxWQldMKFcapaKgZ3BbwMJJfUJla(mYevIizhMgBm2RzibLbg0vJAvdMbhoozIn1KqJZrHjMtcLXbfvH9FGcslPT7GzomlaDjIjg1iIP6HJSKvoJ1BH9q9DeC7Q(DgsXahzOGbFoBO(82qJ5THMZBdTM3gApVn0zEBO782qq7W82Y5g3Oo3ih15g7Oo3Oh15f)KWcFcxScrCRleZwt3jh3X0d2Ccxsgnlc25sccw3WMr99KE0iKBdlHoD6VlgFNnyh(0mNQSH7cnxzwnoHPJp1QHuPaC5nyKRyIBkci0KacW9L6d6mCNqMLz7wqADXo61jSByA0LpfgH7m6IMD0TPTimhGdH(cLxcLG8a7sA498Be2jmjedsPo(3GEGU8)cnNL0YUKFuDWqrkkHndqLuOH2BS4QRv3R(glUXLQV0Ix07cRDPZTAnVZq2PxpISFA6n7cN9c1LgQId8SB5gmS0zQ(KkWM9pD((Tij44FScfo(fB2eqz4z9S)wxam8c)JM7XAXIO6rA)J)v9K96WiOO)IDEg8X6nPbwDZzUZQV85o)Y124zynZnABdrq)NVLDUDjFpO(IzpCgUZwpla95DbBLBbRnXcgSsDdH7fZA1JhEdgl(5atKK3kobJqEBfYBPJWSybdFoJgpLMnhoK1ns9j5HnKm)kOPw8dBsAikzOqErS97XyWOZnffycCR0b2qMijmHb8UjG56glU3zm8knap8ThSnUsH)m)wTGyIuBCZnUH9y9aDSIz4yCpYFrM9YsJESe2njMc5xXKM71CiSN6IhTazXtaEE30HRKbkKEETBWe(Yn2hg1TjFeKtNUDM)J5CgOvGHNwXsrXW2fCarhCD1Y0eJcjfmGP9n6t7Bs4YtLlae7Er0bakRgAqNzrZ50oEQPmTHCxSOHBTSdhoxmr)K0XK(SZNMjwf)nI2NoVZ(ji8KfOICll(rKTK4JjlHPJsHaplHqILWnn554GGiu4EQV9Bh(wy0fQs5OyTNEWqux2RWhGNZdA(lpDiYemrHk41YVUNhnCYd)Jd5xb5)Um4PO2cBSXkOB4K(1u76ZRoLnRmcsAJUz9)hi8r93TW(Br)M(VJ(hTFxQT7KwW5qMotSL2ewAK3SFq36seJ3(BPj3rPPUb6)EhIcy4aabr(ZdKl1Xdil(YlcYAxkIoTw47dIoxuqqVfoVgES27M263aZQKlV8)0fwSw9vxVMI2Lp76RF2fpB9ldI2B5hf5F5ZS(ANDXlEXfb5(xQ(cD1eZx2KCGnMz5sPpq2evrNsBIK6G9r5a1nezvG8upNkgkjYVxmyMISJYZQxnL4A(49qHiT3dZ2cU)J5Mtfswd4inZrtY3VL4ne8o9kOulUiM8KNlicKRTieJm)ZKXROKd4vSW5aLIRF(0oFBRchko1ZDIaZJjNCNyYW9bDyLsjrPsjkhvnjlCgI4Z(FnSzYWU7V1RefqEi8QzLEqt7u5LLKieyQ3WUnaTFlvQKS5rIaRB5oQIgYpTegDynZ5W)Lsw()lVAzCQVgNQrSLAdKGDyw5MIDwjkmOxR4vWe84YxA1tX)71axxo1RL2Hseio3KVgECGCkP4KlwogPiAiRa4zblxX0qvZ00u3Yw3rxrhdPNjliDd8Pd9Runrbj7ccGYPwOiMGlTqLI0PGtGix58G5xrsmAJiyPdFD9xjxw2mlZnj6USt)sLQNHYug)4eVbX841MsXehmWpcS5jsKJterAwTkSmpa1wZyZfrRLmsb(dqNKFRGSE6iCNmnfNYBa2CqKNjmMETqJz5AIyh2YPix3aU)gyiHqlhAmHnzsL858FnVDHuOdBomcKCXsedPt8fTFyjCPTegpNLq77BiitadLrqMVm)qk46EM0OugcoE8RQNjxZKJqDPB3zZWryoYZzJPUYVtMuzyG5z5dZsItMyMKoz7gLnnY(np5jxw3eu5hLOwA8gkkwnDYyBu5u3yhgLvE8gL)G9JdB63))poa9zcjlLJNsIjAZqFYgCXgnecsiYJDb2Xb(dMilfZzv)m8bLsTMYocwEWsTjikZ2HvCu0mv0CCuTDmS0yafljgSoPhTtaDKAAzC4WuCEqRy4A7y6Q6yRA7AQPyWG3YSGcpBII(21zpexktMpsasgz(REM1Rv)YRw7x5b(7f2XBdmdv7olZnj4Tmg7YtTYIhkTscZeQ2V0tcOyK6lyGZKNimdM6qRHKmzm(uptokvPqJ5aU(N3erLKBNDFsFqHGMlIyUiC5IKZi1a7PM4QkvMeNetkigB3wy02bl68gC1UsE5cFbHMfP75SsZ1YZA1fuD1K7g6x1t)v2EYXYntESMX2yITKF0LaLUe4nRdIP0euLPdfnvmtYRvZsltkQO6AQRwsMQuijJQPAyzNEg(fthMfen2I1Al9mPRJzH07P4qJBX5jZ4GgQoJ8)QyB1MrI4KVTWEZjnNdKT2EkBonZ0DNijTulFnymVPii0wZzLBBfBUL1ZqMWbd(SWDt26mqdDnh1jHit2f3zTEKz9KdV5wtfJprBnTTNvgvve3KH4UKfs(8VQMPJ6mOtNyOnMrJlmYAwMZaIprJTMf53eTofGixgotV1ZK0EcYql3PrBpzBTvM1cPyZZ06Pl2PiHLQI20b6552SvN6kVamrvrF6iNcdQ2ujulqEOQymdaDrbo26Zc0vyOZ04sOPNGmvF(ZaryvBoJfsbXzwQZzYEcYdSMbVsrKCkVsvPNzTm8GtYwvGIlj3bMjkkcmLLYC0zwtEGJWKjZGrDzY2PZtQnEUGLB8gGX6LS1Sy(ZdENHEgofNqWKaqKAaPgkLjqnIfeLDNSEW(v90FvAlxHOYZY3ORgg3pAEmpJSPu6Ug3f14MyCj5zve2AtfBEaZoLUjphf57X086PygnkYQuD5If83SbZFZA28OCIhyzayrdw1vI1dlPCyUzKhUzxeOL36s784Ne)ODeOO0efbikEdwBFn6FKob6ff0bqHxnGf9E(NIbJPF659kn6mEydY)6uxGwkTjCBgPgcoc21VxlEzgITy6MQo)ruG3YzgFAD5oBAHQHGkPdLWDS6lXYggvuKq91iIoBYGG6BK9pUyMMjJBklnbBixICqMbL2GHDrOt3GK2StfKv3gyknl3jPExv)clV2AlT(6V(LPWNJvl5PUG)obNsvUX4fBg)ivshTuZEv3CftthfdtnDhnfhnDdJ0tvYrxduzRb(z7O6APtz9or2UITLTHQUHQTTUPLQRolEAuK2ua7yuTnmDv001TDfN3ukP7S54YSgZk8XPqEr7KPO3sKLNuCZ2bD95vuhLvuGX(DhioMtNmelCpooLQbZf)SLi2SCPqKSISKDmnPlPY2Sru)RWj7WqstUg6fIvGkZZ7C1XPyKipDLXsTrAP4qjmbZRq26d)W08vNQUO67GYIau8WT3gJNuNRIzZW2uyA7S32H4UOLF0v6h5JvCkmqSwoyy0amaTaLqhkKB13lat3ezfibG0wmy7oD63W)SSJzJVqahWz5wBUOAHbnKNUMs)h7eUDGh)O4yjUjajOdIMv1umbmXufZsjoSxQ3LYeAddrepiKjmUBEr2XZZuOXJ)IVE0xEN93A0DFY43)MN823hKMQAQIPPD9X37AJp8Rh9GNm6V8K93A8JF44V4JH2jAbieA8D(HtU93o(bpC8DpegJJ)wX3bSLp9b)0t)(do52ho6dUf07h8Vdd3tF0XWVcd7h8vWWn6RFKO9w4k5do5lUj8134Ro5tpegtX3zYRJ6iSsOh4NeHLrkwUIaLllxBcERbUka1YagKUtqsa)08924mRVelcAHD7YoHEsblgsumowuT4XG6y9zjkOojakLhz32birX5U0QRD2SJ2qG(M8ko0Vt6zOqX5ctNsSy7YwUfSkupEVEn5LXC0zOqbYokp(5CJ)UhwdX7GfCwhm3HH5ajfOaTZ(7GEnrzIOSqQ9dassk5GJXC02gKUOAQr6u47jwUd0InhC4dV(3Kl3mfyFQEA10SCap(fESItZY5ukU8HqHelbklriEgZKOeKLvA7T8iUKoG6Bh8C7tbRcikcEjikXbHCYi)ByVDAH1AF3WE8G6wZqHsrDyi5hT9ubK)ZddI2JGKSQW3lt6hXQOqQAq3UdpyZmkd8JirhnKc(kz1qqbrToNUqyXoHv5TyXFsgJ5MP6zwb8m111X0WYavbOG5BGUzAvZutdCD2zbDdhrzCuZWYX1emBZIxlm1aEfvB9f0HolQrdqHJbODsXWXYbuerPXaMiEzlcLAQAWSUGnnqyTRSInggthfOhW8bkJ4Dsu8fGUkffvhfDvfvqNLdQ5t3nFrxSIHTdUJumTmafL6AyBSLfgXkMwAGcpqLNPTHTfD1fOBjkVMvaiGQLQHRkO)utxtSa4LFXkwqVTvDC0m0DG9pfHBL0khAftdyzdWrdhWGytd(6lHFFvWR(9C1eFMiqM7ZtpAHCFm)wVGBH7sL)TtBmfDwo05kp1PmJtZcGSP5x22lpaI6mk93ktUTBNH)NpPYnsUpUYbPS91CSsZnjpR7m(08STbNk(vSXrFWazGrHSZrzyp6MFGBMcoYD9brnTd6mq(HQ6O1(ISoB1ARSU3gxAJ1V4QlUMk7kbjaKIsQL5csBGBVgSmTb2CnY45ss2RTdXcbwTR)Rw(IlU2ANDXnw0d4)QTATZraP6NhtpV1p)slUH3gRE(LXjKNbAaOPhOyOjl51lD9PX9HijQd)I3GvKYzN53y1AND93Wd549Uun8FODfwo89I57EH1576h1dVjncBPMw974XXrhAOhOF2JKmlvzraenBD2PhcS70)APtNCOMTJf7Vvn4FpDaJAadp77b5f0)csuy9ZL1oh(FBZ(xBfw7aPmmu8uuSsPqxQI1YmfivXQLnjZZ1LF53iYHjYUSLKdsVbnH(ovDYxjypqRFV5YSn2XfGhMu7WeoznEq5a((kHSAmh3cTkyirn1SCv1F6F7jJp6t2FRN(9)WtFW3sPPyPN40UGloEuLmwteUk6mFQJw)9rFgyG27C)znaVrG)ay1TeSMvSf1laNNggLt(Sdbldp5wp5KB)W936vg9oFgyIimO)43cd6Rw6Os7iVZ7VtytVvq9UbrRGhlhVed4Ebn5yFYHp6K7(LGDP)41F6XxR8XErYQK98Qdw33hjme1JafFIsh1B9eWI5zTsxmQPpGzppyZ35P6)AprTlGdQvPd6NDRXF6tE1PJvgIggTcsyTc4Bs9bHrHjIcDahv7Yg1X)PVD8TV1S34xS9E9HFPT3VQFhyz3xuue4G6ukg7JEVXh8DZEqpdMmA4zhEH(HXaXGIMOekicbWGetgy43UHQUd4lS(PvnW)Nc8)X(n1tRQr)43MS)wmWd5Kb4WY4BCxM3VSUkl6c2yRAWcrim2gwql0uN9yp6hpy8pEhPFkh)tW0DZBEY)6JO5GpeYY1GnhGalD(CObocPyp7Py8NEWOhDZrh9XOFp)h3NTp(YJF6XV9O35oOhp3h2vmgeA0KL8bX9c2VzZyHhF4BFYHORy39HaNybmWITaBqNirHiV98XJySdkxB7ezrIW2j4Thvk0YeSeSITY1VZ4RF4j3gDz8hV2j38ByBM)0XJF33waWWrrwHjseUZlweUzMX21olcxXPITWrhm(oFJaHp6p)nJE8bSHhm6uZGfjBb3QUTTHPzkU2qxPIr)pcl7BcClWV(N)j4xh9H)Bcul05nzbuuS2bNwmeWffnWU)kg9N(9hDYF8RHH(dqH4mVU)73cfj9xUpBwa1l2e3MQtwiKIacHz(HPrfq)p6F)K)WhEYhDFaWds9zOH7ETto8omumBmOjrWtRbwR7iGtMGEo7kWcJo(wJ(IBcunJFao6x)FB0hDtowqZ10Hf4FbxTTTPoxy8TyufJ((hcI3hDVF)8Zf0Ot)(T4k33KL0OsaKQUyTBzQyPxbtWtF4NWIKXF8HJ(lW)EYF6MahbTUo5p9UG6gAJWgjAM0sLo5AzNIWv0DvRKyD0xJaOJUdmB0uat94RFKawHdXMSRRkjpTJzwjG6UvGUh)WRJX(5WBdG137rJ(IdL8gCucFuOPjLN2gZhWm8DQvj64XpefCD3FI(Ldj9YN8UxJj29l(7cWMHLIRPg7CFeZLlqVPNzUmTRyUgDRBbYKg91pC07CidOD8bN8UiXmsj)iH4wtvdGNNDCuPeYkMAszvwkvYWdY0)PBn647m6)jJey01VoxALj4am7SnLanDxDbdp87UQvm4JU3xds6L4J7ZfjMQWGni0Ki43bsmx2LOqDqA9t)HpwWcp6XFoZ(fqr(RYxIwkG33u3ZOD2qllI1SsA0p)JrY)pfHThFFH4dga2gCZNGb6sn0U2y8(Ezs4ORMv6TQCUm0DDCRyUo(NanZJ(yq)2jh(yyB90F4(8rN6nn8AP0kyYUXf6PBA6wHATX)4TbBNyckUXXJE7Bk0mys3(g4T7hBKDDu0468F37o6V(EJoce6dOsWwmzxCicxDJm6Yt1uPQO7uLzjGLpa)oPlhwvGPip9XV7jh8iEy(PbGMbZSqt3SugwMvmd38AGL3mC29Ujq(c773)OtEV7iyqC4ehcUpdfhlhn5uagsOxfcdSX96FZtFWXm6U39a2(64Jzwo84d5ypAOO5kLz0X1qyvcq74OwHCYr)FoE8x(Dm4fPLhrj3NIunkUhuFBZayoYDJTRLQuwIHUUD1M9a0h3giSp5UF8O)YbJp4UsLICZq1tzun0s1RJdUDLQTg9fCSX7FTX34i0bP3LB7JoGXPX3qrU6bYBb8bq2GORkeeamLJp8RqPUeRjOD8toIj99V9Or)L)fgMWft(lhAMutX6oQsvwoAykQwPDqaTfZ1UF6DfQfh9jF9Ver7F8O)89fY30OBvOAgPQGn01mFHb1aUqwTUNQ(v12kvMGJIHwfuvF0nh)Php67HP4HmYze9p6EF1OV5rGkfuS9bJ(agzmB8O5ZiflPRyjnq10sXQkoMp9WrhD9rF7HGiOXFoaep5opeaMWmdZ1F9BadI5IyOXIMSuJTDDs9xWuX1qRQDhzEnmPV71h92pHMJX3(Mp9)4dhFpUuBqfHblCdgPsb0mDK67jcMQucFesmCW1ry2xYvd)WFpWoLHMJHNSZa30mEja3YsGlnbhumXYcK6JF8rNC3pHPc4lGF8k97T)w71Fy0(BH3NTV6CzpBqdSqKOZ9eNgHebdvhtnH5LAGoLQ0ScUWn(G7m(EOqZ)3OLFmoPV74X)jUAaAqOyIiflGhsDQbsUyaXQGdcub8(FidPaWjywUXDE63l4GObGMb1SZGZlJziJIBDdTScbQYNXB)EJ(R)eZ4RBJY9tjGj)vCzzaOUC8nbz)PgrIr2Sk1yhdUWr2q90J)xOdc9PF)paUGjKJPYSqqMeOUGFEPKV2AvPNC0hDaiyKCB5PpG7PLPIJHljEuMVOAG1y2slMGDHHt1Kq39rOrGFdia7K3((apcys8jFWJ4UnEta2H8)Vnm9CoECuPzvA0Tfab1tvuAAOxLDXxhnj8gFfA9nZKWRn(O3wOkdKsXY2t5UcdIsQLlUvQFb8X6pIJ)OBCDMYSBFlbB747CeGQg99FsQB9muJtk9RP0kFxnWL8QIpeqTE8beoA0NWNKp4X4w66m5(SbHMKmoCRAjefRQIv8Hw1mj3a1N8r3y8Jr7B)OFp4Z34F8wcOMUb7swrjdxIPIeRyA7uP8K35Wr3)Hm3t4UCCWj34AKtYJ(73ueKc(yrtMAkldMcOccpBlZQ4yYL7bJV7tE63)DWS8GRp(Ei54d(myNn6jcxd01CiDmYm6f0CzBZGFzCNq4z)RyCH5tsCmRcCBmKDaiBhf073GxXYbrgl8RhStU0x3qZqyqflOJp7Ztq0q6SQlmdsJb0mTveCVGOBGRQQq9CRNGowrGWd)QXF6tixFyEgu0xZmA2KjzPbG00tL0PRvfv4OdVpY981ORaFa8JrF31Yf)q2yKlR0n0aXFQzPdRmGRKxHNCOicIGtP)Ibr9B(lsj)y(2iZ(zdnvxxJSEk6wPjOhZJe1paSPSj6GJaFCsDxKfYezottZH1lN5WnLS2WqaRa9s2UovhrX3)hgD8NZO)j7QhF0ThD0J5Xn5AJV31ycHOrlxYxdyFmMM8DKg(xv5r4F4Receg)4Nm6Dy(ha2tp6UhbiPOGeGtIHM0b7O10YLm2GdpA2AzIg786NagZ6dFKmwMFX)kEiw)n4lELFbEQP)Ixvg7AMmq7uXewwYzeCXxvPkc8tUnZqeqx(OV9wJ(IdiJ4rk8JUnAZ4Ha7emV40wcR)6tL1ND2LTIgg2YRrGFu7H741OJFZRSB7WKaHOa7uHnMQosf5UMMUAMZJ(bmsGF2Ha4bdr7Do59)oeg53pqaIaJgybzXovOJrQL0MG3pUMwvg7xmuo)EyoovQFIzKXq8M2MzX6QV4W6s92AeVJDQCglW)MFUYzq75hghmHOg7urnwgoYJ)sXaOPQmw5F34pLRN7OBlmkaa1GDHKHo2ozavMzehBB4wPHuJ(6hXmNTidpR)04Nr8cGFK4Al7knu7bFd4q2OJ(y0TSp4Rie(jV7Dg)h)ejHgFZGJfD4JPcxmbpmFjlkZrnd)IPGk2YWYYrV6yB9GVL8B)qrqLrlG(m4xf4ESWDWjjR0ed7xcst66hN8mjnPtiklXFhWucSaCfIpCYyRIRL5laXhfKA4Kk1aSWtxsjzO4u1PUm(Z)yM9RPX8z8xE8479XYq57WoUfhZmZHLXlN5WkRccRxcO0MrHpBOu81WHUdCOsCqIrTZiAql1kk063Q8SdtBcavkpBrDBDvYvhNSYBmspkFTkfLn(UFcYyIgzo(O7m6GVcgF033)83qshaZrtdhjJb1nZuzP9ct0MMdJG0nJ4gvPpIGUtxWjKQK(Fl2zead9F)6Sd0hmQHz8c4oJfDdxxZnveJMUmVbEryTeENCTBrJLCtf2a(YRMQxgCPQQuHaC2fCF7tz6lp5pCn8ihV31eN90OJ(CaecUliu)GJinL6zuTPR(cv1MBQadBnP6aa4QB7uvuH(7C8(dogJoeE2FO5g35aq0nlk(x)oOWkYc7hCeaPztoBSPjxgwev6JYgqNQGLF4Tg9)6No5WRXIU23FWOh)5CUilvlI02nRme5jr8IugYVa1lWTCZuh4GOlk(AUszc4tZG2l5mzX1j75h58I88J000yr6X1nZoYW9LYocLzYilWB700TKL6l2JetLph5spb9xcZrcV6BW7r5ymjnX0q0ftNqvd6N60p1OFQs)uHLhLYSFFIRHb(7JLiHqXKIKU9hO6qOdEl23nWdmpUv6tEe4hZGOGwHnX7jeUxoSAPbR2ROa)RGfAd)Bs8BqxRRy65Yl7b)wTWl7v8gKN9GbHpLBH4njO8kqaVc1Y0fXNdE)N9JtlvY81qLIO4qve1gQIz23oSbT9JdsN1W407ZMmJo944vrTtYVAsOELoG87zeBW5ehqhOITLJHLId)EDHgDSwOYCPoL7QNUaqrCl6JPBpV6m4phvm7iGgK02lgFA2epHItawPs0ColmTcqhX1UIbyqPJkOr3vxXw3vJFJZuO1zQtQDWsZiSzXLrSSIoR3JNjT01CU4wbnZiW35QUuLPWZt5QBp7oZyaEvBbtERNLEqvV182E6wGP6gtA5RhH3MNv3yD(vXtbWQyOCvkb)qq1Nb45lDWj720z(bNS2)YeCMvObvoQv9gdYkYBQWHlfullUOQxd05yoV4g2DX0ZbY5)Nt5QXb19WCEEa79XaLo1ypp2tse7QituDzZRSRzkCo9kNCsKv5DmV(pNPjQuEpvQuYSkOANqUF2PCcPFKupzFb3kYoW51FjU(bex(aIREa2n53eRhuR8SL6NPC1L3iVt7kfCH0hUa5nRanVtSJeQ5mnSvmCXG(BzJ0VC1CYzQKs6E63XNXY3Byz)LkhTlzrKfMpj)6mvDnfuu69mg4QSILQQTo4PMTgFFXOVRsdCjCb0x1OKPDo0zMv6EMMNJLCAsqQO9LiEFE7HqMZC1EHmNQw(5K5urJfI3lI45uMwQag0urb)HjRG)ZtzwMfy2tHr65tSVFJ4(r8hQZs7qJuWK5ZJOCu2Q)v3zEgFw7JctQAos7dD4ky5A7pxk(jVuMdtfkUOWZiDgQhZSEmf7545E1pVAEPAG4zvZlJYBU1L2o8zyH)ZrlT45Eyk4Oj9zrkR02W1XvvxX0w3qvYZuIGj(d9Ld50aR65YvW6fl0qCniEdTbXHy9IVj)59nYxC7cMwED5kQowX2LG7LcpEXj5DkkFvRlVWsZnFIQgS8IW3edmNYeLEivWEIfWeLJFMfBUxw5uVHjaitWrHRk8jUbfbVaf3pqINEpXJgKMEUBpDSArxzXlTMyqf3d987hXsFi)jaaS9B2gVOmWycWwkAyw4GemIlPGFD)Hr987K9Mva(LMG9gjdtGgWFqEzpk4t3AIQEiKCK15nG(e3(gIkIL9UDJ5qrCH7DYDBd4wKcNEsK71JUD1x8nrnVS7Ke5fMDsMHBaEvjmXyjUxMBKDSWxYrbSQL)EBwxZr(Gx1dFFf8XB6169B2k7nJz(Bksr90kU8r4xxeSN3pEHgVe72lkgV8qqy3WU9yLtos1i5gAfSDqV4WRgCkSUCPlLu(hWFsq5FlxEuUpdLh3VhRiHhMqf8hRaMLL6CXHNwLybuZ(n5uXO8lozf(u50rFUycZwASIRVHgcaARIqOmiNSgRJl4UbzEook0n2n5jO5juE)qWV7wJzxhVSRKgcVv4oDn1OcvK7hKsXR65zb6x65f0NiVrnagq27wnkdBNGUurgh7PIXIn9LBYtgapXAaeY00l4Q01WJ8T0EYMZF0dPl2c8IxH1bQZP9In5OLbHW3q3qgXLo5Dh0zyCMXHG3zEIc5p9LGmI2mziS0RI)ovWVgfaRVypv30RGi)Q3aGgdWRbMwNDf2XHWccTj7rBG)DuXwd89jGaz5tLw)EBWlKBAzgZUqpWcdgfNRQ4AJvWvD)T3o8Ty(afnK1LA4bMYXd0hSc4)IRdg0Dhld(9KbDg3I7gyz3OaX0nKpozEgX(zTw1TXZDT81QQcE1zLzXwZ2rBbxf3jwEylXuGj)6JQ9px5TyYZ66uj36u10gFv8kBDAJp8MzHPMMGduU66Aam1ubSwOuyk0nBxJjxZgS7vrNNlylTO3Jk1U6Db9JySVMc01Wsh(F4LdLFe6dL2KlrzBKRrXNiEJ9EwxG6zaQoMQkycvu(Yt3YTauvrx31vXXamB1fixrOQ2KlzOFMyu(lcw1zKcAfw1AZZQwlZQgFiDnDsbQUz5UqJBYsW6OAVapXU1kFOnZcqmmPQ8SuaIJrr4HJJQJJPJoyzHRoD90ucvgwPhM66fzDTMBKxJmGHSlwx0mhx9sHdaQTilb8j241kHfwYPAgtb5bTYcHTtYtO8CJ8uYrYbg4pv5nQ6fw1o4LOHci6ZaK)5WIZJ(mqMzPtWNjAGyTC4JUIAHzY22X0g0dBGvOLPv5itnS((CkvMHAzWNNz5C2MGMadNPjpwrl)QgeEJrlct8FhB86cUCsqOFkOWZjx1KIpJFUcsavcAepFzGA8a5ZdQnmD1WaC5OPOWFhbkzrd9ZaVnOMCrR)8lEMlD2wkCwDA0I41gLUwfsN5TjJ0z2N8Zt388Ta100TRs9HOnPlq(NKmjTQ1ZkwhlLw9mmyfOvD0lI2b2Bfl8MR0Y1ovC58Wl7yOB4yPoniHtbMzmCcyE15QPzaYomfc7yQmNTfrGsrlfNPYb6AuyxPaeQ2kowAoM4l7GCxzu(u5MDQW72m3PTRm1MyxzyRaA)n1vTDazLYDL5Ci3fmHYAA7kx8TSiNyfftabbAc1XBCUuBszATM9mbQGbntoLllqPiMcmuwtdKXd0KMGkuLPyPMIcyqDzQLyv1G9lgwTPAjKHIlytykNMrjw9WBtkNg)t4YSmFUDTqz(fjGVdH4r2plrcI2KUq5FsjIe0FMTnZYenpB(ueGxG5Ql4WYwqT5q3iWU4OpvXHof4mbB5a)amvC1buHdtnZSecOL3mffSKvMYuzxWmfd8At0WvdVNf0TDvk34kDByp4ywMgnRYmEW6z1zoa0BPP7oflEm1ka9bg1fmMtypWIci3PA3MvrRP01nvqlWCuTCDsTMAUG9ybw4AmvTEkfH9U4jbAPIxcfo6POzJ5yQiLyttwp(azuWbiflqlMTcMX(kMwvjawlVjsMzNQCET4wuQOo4alWCy7cM4RBPuL83SebUM2MGdjtBp5wqRSbEiLGNDM4oc9AOusxBnB8U6SOtm6ppUdGXuilpTjE9gv(Q1POneOkDWHExxqVo4GVTedmfsyJC(da(VAnnJuvnlk9Wfbkatnq6Bznf)L0buQTQ(KS0ASY626NDCpuaxl1Nc8XvVO7aGiafYYAxv82CDkXssxdmaReXq6p)RzT5xjfis2UkdRfTjvjf)tybvIxTCk)SHUQ4LkXuu77Qyvi4xUQlyAozWVGgQOwm2xpF(NKpKxyrdmTfhgFXCCgOFRiVKMc4ePI20cJiOdYTmY1sTJAU4NnMB7OatkvqBaYzh1m1(mpdRd(Yl7mtRZaVFbx6ZsYZ70lOyOQI3Grtbr56wKhfFnaaReS1q3MNgpQRRLYKYvsyhfxe(igN7W3eH22dJwopa)4IuZ5FqX6FqZy)T0uoTH5P1C)Tl2mj8QHj7T)w4iF693cDQzbEvnus7pxqYzyqNW(9wT329FLxD)Twbp2TFz6qG6vqeuj9)8yK(RZV76xV3Y9AT)w0dNBa8l)293QjEpqg2BN93kPDW(BXp9a8MUG6Y(B5NW)QaSR93M)xaiEbI6RS5KagNLfN)vc7fg3oOfUUH5JDYd01CFsKFC7936FegXOHbuSaNyWS)T)J4)T)wSX8)gS35Jh0r8)id1MOBwS99g4mCMob(9goqUTxGOQlPllblQZgSDGVa2CLaanrpVbNM(Bn6NIcqcVK8V3bNC7ho(UpH9f)5Nm(lEpEHsCWOB8yumu(js390AkZET5wAxMZ1gwqq)aVwnE8dP6AO8fgYLKFAmpTsfqnv1s7ZCU043vHIBVKRF4uxAfze0CpTrfanv9s7ZCU0E6XigLFZZ9qS23)WJXc1al3PPSgls4RPFAtNF769otBG7jai8pF)wbyUIK8kVkDvywwZ5xo0N)n341w9mN9s1o3YRxZR(glEXnO5noib5mJHLAx)ReiozpgZdEAMeVZ2(DIdMnRf9TTcO3F4(SJWBNi)ba)e1evwVjgmGTMDh4Jp7Sz(w(bM7jFToko3zxG72oONhED7NFfWFu7PSOi78lBaT0BH1za9GKkfbLTn0peyqg673aZ0Plbnj)YvBHTLU3DuTkftSm(Excn6nw)IRDwefSXY0D29fZGog4VxN((TupTaMW)aTtZxv8)wh(B2ZmuXjYWvorN51wCT1wgW4ENF9ZUmBwyN4TMLSt6Nwv90AgtQZW11zbffh6Y9SSomxkn0PRHcLshGxUAnWqRv2K(8P2qtRKrtRA9g4zews)MPCgnJs7Z8kD(47GpIl4ZQcEpI94hX(037rJ)7hrvhg7I)E0nVg7WMYntk2seZuxDwL2N5va9nogxDF21y1L5F(Bo5TV)SwG25MmTtB6EAtZkwGoL2N5f8DVhp6O7tLfi7(RCwRo3IZKXP11N9QtxP0(mVkr(BpcaFJUX1fQnkFHPRwysmaqG6u1CORvAZ)p1Cuyu(5P6OmuvrTh4t2UUEPyJx8Ap0nMCIm0Qq7HEErgQNwb6NvzECyOVGTMLc9F60D7zzDC(C9GQza7shGxUAr0DkFsF(0IO7wYOzuTwedLs73mf0yOwAFQuqJ(ZS)hg5fFOCAt7tRBxXQtV0(mNRU52dedJItdOVQkaNzP9zoxAZThigwfMgd7tB4uXsZU0(mNlTNDpqmCkoFOqIPQhXWT0M)FQh5NREe9NvxqezySi1u9cBrVjauef9B2Uywph0PzF8njZVxqh(d(MmHUX2lQYirPI32p6QbX4IFB8HGf(ZeEF4XOs80NHZlLlqIuLMhDT8ZpnrurmGb0IYH2TdJIPJDPo7b3J)SZjhgc(gf0K)KIMPGeMmxR7JPFA6dhP8bRJf5VU9B1Ncmw8WgE(jjrHngMWEbEyFc9b99WfzUsC2ixjoJVsm0Ammw(c6fgVMmNIJ7rp5Jy6eZW3SNtQ(4dvfgyXCtmdfuVx)OUSK7FVnx5u241mUowgbUW)QjQiU3AZvSCXBHFfndh8jzWLFwC13fZUktdxtft6DCJNioamfRVdvTfumWl9utx(JRi(qiYFjT0Oxsl8DafnzvH1dLmrOeFw7iMe8bhvIdL0Bj8eJdpRkDhf1mOUSjx9CKO2YeUpfXEXfx9S5OgiIfG(PkkbQMdA5f1VtqSOElsPML0Y8YaIxnEscfwiExVXVoOjyZcVIvyOlQLRd0Tur6H8k1plrHYmOyzyE3FRv7HVCYTg6dwFCbQhIE(6b7XdnCMOex(exFyJnWni2fCQNCYwSJC8bJ4GUclZwLpi1OoZNnjQL)(HXiN38)l"

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
