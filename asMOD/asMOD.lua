local asMOD;
local asMOD_UIScale = 0.75;
local asMOD_CurrVersion = 231112;
local bAction = false;
asMOD_t_position = {};

if not asMOD_position then
	asMOD_position = {}
end

local version = select(4, GetBuildInfo());
local layout =
"1 39 0 0 0 0 6 MultiBarBottomLeft 0.0 -4.0 -1 ##$$%/&%'%)#+# 0 1 1 7 7 UIParent 0.0 45.0 -1 ##$$%/&%'%(#,$ 0 2 0 8 2 MultiBarBottomLeft 0.0 4.0 -1 ##$$%/&%'%(#,# 0 3 1 5 5 UIParent -5.0 -77.0 -1 #$$$%/&%'%(#,$ 0 4 1 5 5 UIParent -5.0 -77.0 -1 #$$$%/&%'%(#,$ 0 5 0 0 0 UIParent 1111.9 -439.8 -1 ##$'%/&%'%(#,# 0 6 0 5 5 UIParent -1172.2 -470.0 -1 ##$&%/&$'%(%,# 0 7 0 3 3 UIParent 1172.2 -470.2 -1 ##$&%/&$'%(%,# 0 10 1 7 7 UIParent 0.0 45.0 -1 ##$$&%'% 0 11 1 7 7 UIParent 0.0 45.0 -1 ##$$&%'%,# 0 12 1 7 7 UIParent 0.0 45.0 -1 ##$$&%'% 1 -1 0 4 4 UIParent 0.0 -301.8 -1 ##$#%# 2 -1 1 2 2 UIParent 0.0 0.0 -1 ##$#%( 3 0 0 0 0 UIParent 576.2 -689.0 -1 $#3# 3 1 0 0 0 UIParent 1013.2 -689.0 -1 %#3# 3 2 0 0 2 TargetFrame -31.5 -4.0 -1 %#&#3# 3 3 0 0 0 UIParent 339.2 -356.0 -1 '$(#)#-S.5/#1$3# 3 4 0 0 0 UIParent 3.0 -546.0 -1 ,$-=.-/#0#1#2( 3 5 0 2 2 UIParent -324.2 -374.0 -1 &$*$3# 3 6 0 2 2 UIParent -312.2 -376.0 -1 -#.#/#4& 3 7 0 0 0 UIParent 559.2 -779.0 -1 3# 4 -1 0 4 4 UIParent 0.0 -326.2 -1 # 5 -1 0 3 5 ChatFrame1 29.0 38.1 -1 # 6 0 1 2 2 UIParent -255.0 -10.0 -1 ##$#%#&.(()( 6 1 1 2 2 UIParent -270.0 -155.0 -1 ##$#%#'+(()( 7 -1 0 1 1 UIParent -7.0 -794.0 -1 # 8 -1 0 6 6 UIParent 35.0 50.0 -1 #'$A%$&7 9 -1 1 7 7 UIParent 0.0 45.0 -1 # 10 -1 1 0 0 UIParent 16.0 -116.0 -1 # 11 -1 0 5 5 UIParent -272.2 -380.9 -1 # 12 -1 1 2 2 UIParent -110.0 -275.0 -1 #K$# 13 -1 1 8 8 MicroButtonAndBagsBar 0.0 0.0 -1 ##$#%)&- 14 -1 1 2 2 MicroButtonAndBagsBar 0.0 10.0 -1 ##$#%( 15 0 0 2 0 BuffFrame -4.0 0.0 -1 # 15 1 0 2 8 MainStatusTrackingBarContainer 0.0 -4.0 -1 # 16 -1 1 5 5 UIParent 0.0 0.0 -1 #( 17 -1 1 1 1 UIParent 0.0 -100.0 -1 ## 18 -1 1 5 5 UIParent 0.0 0.0 -1 #- 19 -1 0 0 6 EncounterBar 0.0 -4.0 -1 ##"

local detailsprofile =
"T33AZTX1vc(RzR1o1kL(9dv1(bsrszwMcuRav8MQuXMnaAs2JaqJbDdrZSjSKSO9YyPu2orkIjwsRCfPy7mAQLww2JCnYt()qa(FypNZ9r)anqdjlvZuBn5bfjW9EUN75EEFp37DD11xB9696hTzy7a8xJ3oAhp)(bD996h1oWlSzu31BSE9bXbE9d8BNe2jOvVy8J6dTCt)wqB6c9SM661HFPM261uoT26jauB7VBqFVwbj(HTJ92jSBRODOXOPpmyyhA433lj49tg0py961VYUTd7c)s8vaavFX2x9slJWXVDBpgSIrmZBR(rd6jXjeD7g2XpjmQB86ZdOvqVO(jEBdiRhaVRWW1GorxLnd64Tz)OoED97eGnVti07bD8GVUposnJ60WpXdNNakQSE9wb(jB7LefbZ9EWSOvY2Rxt3urosjrE7SD061xVEZ2(XXEX9cAgdWjQFRyKWyPXipiDXu11uxvZKtN0THFth)n6ZmyTbM01unSSLDt0ClnrZfn2I1AlDzBjqQXBtPGwdWDER5TuvaxE7ufnuvc2uCEsTn7SS40lFBH5MJSXwYwBpHjNMz6SZHp7ulhhmM0eReIG5uMBJ1ClRP1AzJXjmb8PT2nERZqn01CuhNImExCNg(ylAUdV5wtCfFS2AABpLfYXwBYWCxcIOlHod2oQtHpDmqBmLgxaYAwMtHIpwJTMg73yToLGirdNj36PYApgBOL7K4ThVT2ktdrk28mTEYQDkYyPQOnzIEEPnB1jI5fOjQk6tEXPaq1MiJAb2dvfJPqOlQWXwFAKUcGotJlHNEm2u9PjVmgPWCkisb1zwQtKyuKRZ0AkYkfxKtLvgdUJ1uJPiwvGJlbnagaw0h0Lmrh0cTVIgPbdQjTdWpSBlV4G(GPwVE(9HFdTn3dmR3Or)GRgsgXrGxFNO(TBjSfhg7L03pEBeC9UApp)yUpaWF3ik6kD87FfYncV4WFfA1g8Sq6taAooOLhyMhGXvdAJORH561H)Q5v8ctc641oa)CatiVzO2ttpZIg)JbK(kydz(Yepv3Fc7gN43TzqSxNGUd8A2oegpWxHOEbKhvshoiAw3GDAUn8NbD3kqq2IdAVjqdAhrKPw(j(uJ7oONx7OTIgKGFC6W0km2VrBKA33B7WT2Un8)PMWMeqxyadDkPo6E0613QFaGm1BmyZnb3UcBdOeqf6hg0Tv7D3me9kRfmLJ67JOfaiwl7nOFpWdU6GpoTb6aaHDdA3gCUdADhFSL9bsycnYTWXTDyNqK73IO7XBdis3M(jGxMjbmmS7UEXnJaV76eehdGio)CloylGkMedZIMxHXyL(LDJGbOb3)YgJT2dmu6CYxJ(rxjG5Yj6Vgcay(b8KOhNKBImpC9axCbmjbihaTcqtGU2I4qI6MWxsyYfQzu8PssdQKpRKh0IoopVJXB7JOy9ARwBrXhX4yDahr3nz7WMETaPNaa1ZoO9bFvbsqssy3TILEPNeccviSJbAAI)61xz13dwBIao91RV2QxiRJ2c3wva3w3D9ANsf9S99rnaGp4nVsR(r9YnT4AgYPwI4QtP)Bhq8x100Xpp2VdWsWNoa5EqpGGJYgan8Q(Kuh8PKqA0MBcZfCayKGn9BcCml1p8xT3g)pg43cNm7TXAW0mQh5vVhraamJ0X0bCLV)UEWhrQN4oDJXPaSjDarO1RVmoQiyV8CTATA34lValgKlhICNXxM6sGS50kEYU9c8I6hUvyxeDbKtipXySyQCi2YUd6e0peOTEX7gJkqI3TtJO2XWY(GKizCbXn3oOJpxZGKrEqVE9bwCUgnCbGtQy8Ql5yyzzBzRzB76OA5AT(MNc8)vskkjkQKs025)(cTD6zMF00skk53b0hdRdgkzwii2luHvCPljjzc7dvaXu8H)wgnFfPp0WMeLaFqEf9AzOmmqbdUNxVicl6g1hwFWFB31x6u2Qo626koUA6gQAgoaDXWa5HxYY1vv1110XrX0wXH(g0ecqlv1uTuCSS1TCCTaEF4BaL6BV(s2AU6o2k2wMAgggQwSVb5JbHa2qIy37ZeE4coWYLg8VexijbcOEYGyqFlYvqA55SHKuayyhN3OukQsg7rxzdH582sPnnH4gOdUfTkbJqJT86tKuCYS5G2TBabuckVeahNiHSLbqKIBReHpjh71yqscgr8uvtHg2qCdrBpkfavk7KTlXEAsDADcB2pcTbHHQNvpnAjdLl88bdsD96ma0W6H8BGAlsF284A(oGrD0YiRpX7eM0CBp08iMfcq8UB2jiAknzBqEClMTzaFi0Hu(NaGfM8bmT8zuFJWLHSneeAvUkjUwyy5Q5G4KOoCle)VWKe8BKQBbUAwQrqqr9JP6AUMnbO1f4V3BJlac34F0C38DR9oavr2VzXcswge1tBqTIymyZhVSyAJSdgBIkh6gBbFqsggrzcx4RS7Tr9aywfMaOmScrgHP8yaWa5WiF0Apaums(DTdSi3pOjtcg1TH8oTcIbrbqnbZIfF9J5nat6ip7HGpN7jLxQLkINwK1jbZMC1kJCW0nxPYmvifj9B3BBFuSXvJeTAWCBf0wiqw0JiaS550YogG)UQcNGvvTTKEb7AWTq6sJktQebtxolitXwgl6HDbpTIjklyCCaLPjfYr(zTH6ZAdnM1gAoRn0AwBO9S2qNzTHUZAdvvM5woZRnQZ8IJ6mV6OoZlpQZ66tcZAox7kjTRlm3ut3kNuXK1dLGbh43a5JtIOSTcYHOEyyqfc5uAAppM)uq1ECsytYv0auyIz9jJCBegFaGq4KaLON6iNzwwH6YeUhjGAzFH9rHD2CY1cN3Zsw0KKfBJSKf2inpoqZJJZ8Ou08OeY8i3pc6EOI)ANslJjLsO7S4EKo8Ek0PBESKKdoG7qHTdtcbVFq)0qN(d6W)lMhaBrQP0n1kXMO)MGLAWHWEepqDYxK597xh87Rfc(MbOPCqn)IRn3YRu3R(AZT2LQp)Cx07cRCPZTCnVZUYQN9DbYh5h)KB2fw4c1LoGIaE6TCnPlMRjC5ePflnvtLylMd9pq6WkRZCd01z2Nvy)1zR065uNo1x8CNFXAR9tgrvFdJOSLNFQyP2RfSeJ8lyZzISMuWbnq6KCmlRlScruH3)c9f5C65uA2CSbajQRtKCOIIzgI(Tee7KRQTRMILPfyB3gdEYaDVm1DuM33K3a51Ng1LjVi8Pb8UkIYZa5seQ9J1Q2bGaghRYR5zg8ibePLEIyvGqLMaJck0sD4px7d7YCubqPDzorh31VhfMm3lQUYDZsS6x4Zf4ctzo3LswMrYKsH0KRWIfZW0vxXs1YWXYsZudd4YYwKobE(hMF11wB1ZFXLp37uiuvzmtaASjfQLKGOBN5)Wsqg4SiJGUee(MHneLNIoesNLPjBPfiYt6B0N03WIFJPnf4(Oe6XOD)IcHN5rj3IlzyrRONsNLxlP7Uu29OapWyCi6l9jRXLyAiuW2iZWYDmoVZMYeXmUd6NJsDQiQtymeSJ0G2CqFW)9eAZpXVF7S7jkrHH)acNhcApRECIoqw1JX0vK3R(m0N8yzEoik2GOyiy)O)dFi7iTrWZHK4lIHot74mzrpO5mgbm1uM)t85lbUvYcUCWNNNP5fFmTaH5JCChnWTnpOpA5ovMDZW3hyZQ0riUtjRj43qHrIdKsYxqYoyQE5H9JWAxHBjCZaahNhYcYttplTAYSpdITapcZLdk6S5ZK0ioHBjuV8Lb6T2PxBTLW0Pt8tSSlGAXk4jer0YhWnsvu)nNEVnOFt)3q)J2VjFYsbAsNOwbTjNrg0diyE0Fdob1lOnSqnhyvC((uwVHVpO)5W0CF6ZRHPVCN0w)E4MmC5f)FEH5QvF5vRPOD5fwD1fMBH6xgmj2YVFF)lF2vxzH5U4fNdmfFP6NUJMy8K6SmfWmJLe2hiBIQOtPnjjvAN8uR60bKMHIcohNxrb4)38KvJ92qtSsVIx5zmG9DGI(UXGtO5(yKxG36IYePny2KwODJyxmp78ufKJrqPGSdtuzwSKscrz5WqosUjJ89)02InhuSL3SW1tPpJjN(sKpSc5sUqPZucBp9XqSv7YSkogfhn)s7(JuntQMJPK6NsQzNufhe0Ninvshia1DqNgSKivIsSzzLH1Tm6pIt1iwM0(EB8wCX8)Bs5()lVDzC3VdNpsmLs3LRmltlrBFv8s4EgC5lT8P4)9kqeQN6Ds7qjQ8MzgAdV(bSGVLCCJJSl8FnSzYGofxgYQIDA0YLmbBMMMM6GPqhDfDAJamxVumF8rfOPCu8TLkAlSGW1pPIwTLSmeZjNDnpIjxyBGBCk811FRC7FZ0cfHy)Yo8ZlL8s1dSPFCIxVyp22HKYYeh0Zh80cOu89ntUXtesX8C7DODLfyq753BSnTlNJKtmv4bVpvYw5M25lZiBYZA2OVKJIMPIMJJQTJHLgTpngwY02wNugW2yz0RKS2ly7f3sgU2oMUQo2qalMAkgmVJse7ucURcfdqP9UONxY9(Mw0YWVU8zxTw9lVCTFHhe0syBV1ambD8RI0NitmSGW6WDlSKK9IkMknd(fZUCbvWAY9hIxNbIIoseDz(DdV3v7X3yZa)ouKvD3mKYDeYLaFaJjH4J)hhGBSERGeoAsBJlWuXuG20V52eZuxCdic6NelQCW09mZVzZasTVyh)YVvSm71I6emx9bAwEwWWjt)qwTe0UDyRyHTjCgUzB)TyBfE3GDeBUizEFTuEBvtN0nTvLy05TeKJ60teHStgTgAmM5tPAKzxsHyfdaT6TBrboNNiNwdb5kNHjUTEnBhnauA53Ju0nVyZ(HyeUsqxpuBds26UfzsQjyjQTy)31Y4)wMnySgBI1CBKE63Wlam80Qatp(5uPAcwfF)SQl2n7FeddRCNAzRxIspaWlGrfM(AYDgBxUXYeG5cNhWedT3UDyq7wXSnyIPRIxbN1FNlvBTfV4SwBH1FpWJXLx9IZurww)cZTYClSCTzTICQF(5o3ILvEsgokgwLxjr1VWIRvDxkutr1x4IxA5fYuvrQkUPLwKHRHQHs5fXv9ZVAT3TKAIYYnBxgBITWIZT278U1Omgm71Az9lv7CxC1lDHlSYC)Y0LOQReR61FN5o)C1MbYsXv3lv7DRT679smsx4IlVy905ug4RLNYw6WbeZ6tJ5RWGnhOVbZO2ehofWwLJnemEPDFXAlE(F5SowlSiGC5LneRY6tVe0Q)oyqkZiZvXH9IREUlT4msoZZyU4Vy13ndUAQO7QKw7GtGBgKM5jIDMq2XlkUwbB6dMm9AWR)kAva6vQ9gqNSCNrtZcyopMgtl0PTeH14OZhAJY0(CABhX8tuEMg6JlaiMng824ypMYgdvXaYBJlzPzUlUyT58(LlUYksPc1CvdQ2uKtneJRa1kQ5rvsM5TqXOOkMCdMP7K0LyBl5NfigJoS4klLwjRUkQUcojnvtXM8Y(8cQs1lG8LPp)0UwcrbzfxRxMAKXCqQOMJXY3dJWFUlU4IPJMLJLuoqakxLXfTH1ovv7SXCCAycAL6oCrUEtbxKPGsB7ojDawIvvv3CTvMdFG1V2IxATlo3kLXWuIKQG6yABj5uCDkQmqWR4kw1m4E4wOKNWQWmMsIpw6tScsKsKk7uIGUeuSGQahD3AlW7rErvzkk1vio(EGRIu9WfL0mQFxS8cJ6rjEBnw2s5z(vId4ib(HfZYUNOWUiV69cAfs5XTr)i)wnz(6MXBiYjukh)IF9crXy6u1u0b1G6wMGIqqFalPP99BfsUzzXtZsAofJ6YQh1DiFVIAfLwlmBI50KQWGmyFAbSjQAmCJK9F)j5)QbE(y4(VckOrqq50GClugmdwmVB23FlYPlHYW8BHmPiK5YjD6DK1U68uoBB3gjsSZXtCtkNQ4Q3G(0)gaRgBTBQRQSeSM5ymXRlhEv9uwr5cXDU128HqUe2dypAszrmBrJIWJTJnISZt(E6rvA8RCLKs5ErgwGf)dkuykc5nHniHXwXMspLkpvPYQWKYkeSWTtlSIwGfqyDRJmVtf(ckUnr9AoT6uT8Yo90Qc9xQY6RXIpBmSZuaQns51Oe9Z51WZ2KGOnT6CQ0klLKmJ3XVhQGO1UqyhWQmNJiBeCsMJgrX8uP0gdmpQRiee22RKDV(fLqokZKzx)TgVAiGLnPndDPQmDxl550jdOj41ladWbZYqXQReKuAXR35s41Wcwsugtz2IY00kjqiYBfU7J0VQN(RYW4bb4Rggh1FwyQPKhiRfp(MTbkhcGajzv)j2AtfBEUBpLUj38kFgLw5LfnglCgsxIAG26gS62OMnpP)yXsea8dyfNlWhwWHS9ojpvYUijkVmPD(vJe)(BjwqKPagzbEpwBFh6FKv4hOvRnSGbMDQJfAd)trtor8kNbiviewc0TRQOOR7AB7OBc2HbT8UGu1Gg0wwMM9R5t7fx4JeZBg1PJF3wCEtSftwM)LyhTzTCQBfHUCYoPulseQuqjYex95zLSNk6FF9viUoB6aYbUfL5pUyMMj2BaUHQgsuKRWZGmCf2bPoDcs2oQfrNPusG(OlNjPjwd86BLvMF1vF3ltBWeEMto1fa7jNsvoX4B7DJOekf(sOLEmqvHvqtWiTPMUJMIJMUHr6Ey7ORPzzQbbZ4aUHPRWQ6BCpSTTSnu1nuTT1nTuD1zPbMsqSIMLIQTHPRIMUo4IfF3Tt5MNUqygCmR2hNcE57KP8)jG3VjeXstGLf0Ks5btO2Nx37O0rm5Ju(tpZ00hlm(ZYCxQPFMFyzDCGFwLjh4iDfZpURd0b8Lx7OSJxImcSSjIv0n0KI4qljRBAYTNTAh1WFb2o1YNn9dAYCalxzfJUaX9oqAzSD4MagY2nxMFcTdUkvTlSKhAZeF4hEbEMkbap6bpE4xCV92y49FXOp6wNC9Na0svtv0H(6J(YRn6Whp8PVy4F9f7TXOF4zJEWNcTt0cqkF09(UtUZxp6PpB09peGXrFT47a((JF6pE83U)j35WHF8THE)0)zaCh)8JGFfa7h)iaCdF8ZfT3cXKp(KhCl4RV5Jo5UhcWu8DKuwyNomh6jdqyLcI7epDuTz0amFAIuGkNEO6tm1TjGFTnrjuuYeBdSycEqG5InM8z11Xu3XcpewKDzS4WrBUzJqo4975QKeq5dfwEAhaCk8KsU2zxDEH7Eex5oBhG8EN7slVYczX9badiLQ4q)2PB3ghk80ykrGmC5PMPutRsj0raELtKMY60ABoVFxKiiyRajFz8jaZvDVMafJv4rTy0SuewGRiIZWvKVet1j6xCy3TAH(HaHhW9QfcYrrOsCWwE9aqg2elCfgvN7zm6M92bGCqCciaeG51x6IThEuT2ctNmFLJf8KYe)AKHh)AXzzIxRdjICAWuAGhPFYhdxwrfMgYEnuBiegNBA2maBM6QN2rXjnc7LmCDnTb9Fw2k4rMbvaQ7YtAbe1HUoO0sttgg9swQQgoMU2kkoOkvClB0DK5vzjldnnv803ys1Fcwuk628unaHyPc8Igw6oQkwqCw8(kctgmod9002W2bqiDxn(2bLn8y8mY7QdOKTm5l10umvSonEMR5z9yjtBvWVhnamU6MgM28jfpG4LS0mnTaRbQGZx2M6KtakIWGxcWmhndthllDvdfBv2uGfdmxomhxfSwh1pKfvv6jPu8HyaN(aF02bTf6fXtORBAvaUCTLw1BTlT2QxC55wrLc9c3JfMB1C5JgO4rd0ysd0ssJm(JHrf2L0(kGomvw9xS4fNBLvwyU1MZdiV1wU25ijS6NhRjYvp)8ZTM3AlF(fXrJNrbp)UDbvjnzmLV3Y1wy13Zdxx8Uun8FimRuCwJ7Aus)28tOjBZaYsdW9jb0kqZCHZf743VliI4f2svgrmTbdSdSAlpYYbU3Fo4ABX(G4JqyPe1Kz0cAdM4DagD(1PHOUCili4wxWk9lpqtOxFFO)sLQe1xZsNkAz4FDz)Rc7VnD1y)TQb7VHOkyFUctR5vc2nobvKKglNungwWx8sll9Sqr7A52HjCnN42idRoxjKz1wQJASWzPZLjweZX4KahixSdQg0p1PFQr)uL(jh)6HKpkM6CNzZmbyNB3P4bBmFHMZVIsM(3MbML2zzL5KFeLFCUonj)YY4rDU2lRiwS82KNztwD1toqKBqRS15G9eqr(8AgW0CJ9l7mJpmVCtWjTwixbtKNNsH4g2gANmrbDi(y)RGv1j36xIFds3hQeI7fIFRwOXpAVDPembgTbTGbP7pUowbAz6I4ZXIGnZhNgiDEhSvKBfJiJWkMzpITGdQXbPJAyCAXlNb60zrVIyT5LSa1RuaYR)aBhxhhxqJGTfy7sruDMe0XCsKPqvYD4Pkquej5JDYsi3z43vpudr31aVMJXtWS4k3zmYkfs)mg1sbQJOCmmCbDyQAwGfwfBU9xZXADgF23ctoyyZIOrSmda17Yv8rNBrr9VNbc8zUQl5kh3kq1TNLHQEyT5adERxMEqrsmRTNQoKQBSgXZ1hRd6QBSoVuAlqwfGYvPK1hIQ(sqpFJtozvzZStozT)nj5mRsdkxfvDu8zPaKs0uPKA00728SLxboyt0VzCTHvl1Vclo)7oNRgNu3f95QhR6GqTtn21JTnlSZgIiCSzv31ykNlrZe4jVJRQUIPTUHQbVoVgB1RC185DxYzs6oZusCJBJqWgpggMDihtDiPgu2xf9CaoVbnr2Qf5QwKPAw5kog(GUloDZaPBnr6Pfzs1n5PtptUYTGNg3XMrc7EMg2kgUgA6qOEAStyGr2rQKeao5sBowCP1n2WLL6McCPPu7jsZtRWqxndfiOvBDfiOrTjW4uHfqgdFvMKlrSG(QgLGLZGr0SQ7Z08CYOtsLsfTVe99ZApekHMP2lucvf6NtjufnUe99mrI0ceFcS8zzBkvU5vtTVFJ4O(8IUR0o0iLQy(QOkh1T6F1TMf4lBF8m0AdQ1qaJ(ZKjFiqZzYjHIOZGEuG2Za(quNM9dtQIcvComRwEnSEfS8Y0vmZ2s3o8LG4)tXkT4OjpHvQsCUHR82sf0jAQOG)WuxAmTe9q86qWHDyrAJ14bOVBqmp4rmxjPPLCsPqLDu4Wdu9zPdUa78fjUrhKrPu)4)Lxm6HF2EBC83(Dh)0VMQDIsll7DaV78OkyQM4IUJkTL6yA8)K)0EBm6dEY0aW7f43lQR38r74PylUgi4Xibq5K)0Hh)0F8KB)ItUZZ2BJ3A4h8No5ohca97)AaOVDPqLMrEN3FRWMElHuHG(lHB3n)MJGh514W(KdF(j3)l2BJHF)bhF01kh2Zr50ExV6d2CZimjXIRzcAZDlfQ3(fd)I7nnmDU(n9H1MZh2T15j)22vCLuGa1QuG(NU9O7(I3EYRkdWCRVeAbCPW(b17fcIXI7VceQ2Lb1r)5VE0DU90N4xC7DJAJ2A)frTb0osCxxGa1P0vSp5dhT)3mDGEw8GTHLdZfIcJbMbfnXnJbXi4OPyYid)61u1DS1n1pJQb()uG)l73upJQg9JFDYEBWip0Ufn6bpE0nVplIBwxL3LgmyRAWQ7ra2yQWT1uNoSh(97p67VNCdNo6hHH7w3IgaE)LxbhSbW0vrNpaA62kk2th(JU7(dF(Tg(Wpf39Q)1NWMemPbQ3YRTdsuvXrZMjVo6WRFYH4gOD)NbIDfi3GZErJ7ShThD(yjS0gZz7MjYl6dgMdKl3usJjOVUcu)G7n6Gdp5o4g999x7KB9veYlinMm99S7he56QZR31vZmW21o76QItfi)d3F09(kX66W)Yxn8h2NbEfvlnd2vDPqOuh3JgZ0vvdDLkG(Feq7BbcfWV(x(r4xh(7(NelQg6SBdfBjUBOOyiOlkAUkkva9J)2hEYF8XaO)yuxnBxs)73MbFtnvBsCs1jlTrrqBmnnmmnQGU)j)ZN87)DN8jpbi5GA9m8K8UtWxiVQPcrhkioMQU62vq6hE0Th(GBn6gxF0traFW)0Wp5wCsVMRPd76aviXABBQZv0EBgRWWV9zGQ7HF5VD2z6bVvJAX3Ncc6PIRAQ6cC3Ye3xSki9p7ZyB38F8zd)RW)EYF(wGaaH9SUtGxlvDJRLD6sRIURALSLdFmsvE49GHGMVW4jOoy)xNDHfkfADmZQpt3TI12rp7aCl5p8oaH8dF(WhCikcivNP7YSSNkZAJNBVmYvQvPu4hEgQs6()i9lhsMxpHdFfxtn2D9Qa8Ua3KEgWBAxb4hE7Bp6pF0Wh)SHFWHmQZr7ZaVPQHIkJ8BLYzQyQj14yPuPylOd(hV9WJU3W)W9yi)bhW15yA76YUcJLKgDxDHyl87UQva8HF5Jbn1snop5fPQlzDNaVqQfyCCzL3CDqp7XF3Nkeeh(dFoZndWE7BZromd4mkBgJOgAzx4mRKZ7Z)uGtE0D)u0k3tekbyKwBnfANdXW)eRC2y9v8AMXqxnRcxvj4n0DDCRa8h9JJ(IJg(PGXOto8hGzYXF3t4qN6nbETugdmODUklDtt3kSen67Vd4vdH2NCZJgE9BjuMBsfOnE9SYGSRJIg3a9nU)W)2ho8HGEAy1d8ss2fhIlv3iJH3uJlQyzqBxPpjGSlz4fWQHFW9o(hUXj8tqh1Dc(MzPLUzzfSmRa(36AGhXSfPV8waNkmR)OhkeeC4SccPmdfhlhnj8bZ(6vTwboEEWxD8tpIXLDJ9PPeF1I6pnaPsAoUgchhaEfh1k0Xn8F7OrFX3WOpKHyCjGXnybMxTz0hhj(B7APk1syORBxTBjaZWDaP4tU)No8VU)O9VV0(f3Hq9ubrdTuRViWTR0cZWhWj(F01gDZhIXPWP9WYlbDdfjUdCYcsdSYcQKQqm)KBCTrh(iubk5plyg7ZEi32Ul(In4qWxnDT1rvAFXrthcBTsFta2hwuv)4nYBat3sJo4o1msnqAORz(AI6acwS7lWuRJQ2wPI5okgAvW48j3A0DpA43cdWZySP4Imthi1Dc8gPeFDflPxHMwkwvX4F3dh(Wdg(1hckrg95av6K79SHC9cu3j4N6uRRtQh5MkUgAvH)KBSW4CJdgE9xa4p8R3HhScOe3Gf3UrQKRgEul4daT8xLbYhIlT7FWWV65quUSLHN9BZW(WwaSZqH0mE9qHYYEkDTfSBWQ086J(HhEY9)mMg6ha)4TI6U3g7gnO)EBGxc5V9m5SyqdWzXouExWHridBO6yQjCJtdu5xLToiCOr7FVrFjQy7)l6KvQPEw3P0iifIXkGn1nfxSKzQqka0o)r)og5)V9vi8V59oMlfqDNGVAw4786h(zSMQBOLviUQyVUZho8V9JSWkUdQC(F93n6lpineax2tTHUe(MGo6u34WscQkdmhn8V(eYxMJp6)nvaOh)TFNqjKkZMT8PwXfczkLj1wRkZxd)K9bNXOWao(P8ixmvCmCjDBYxLfisDlBPpmWuWWPAUM7)C0tmis6NDY1Fcijic7c7nbDPVTwazsp1QLPHEvUFEa6)1nFe6KlZ)RRnsyxbu0WE5uK4oMPHuFgCRuT)ZpcTLCZhn8MhWSSCNBFsAeVmcUtkdPP01zxniM1QsscW(D0(eLF4NXeYh9X)abEw3jWNjGuvlHEtvviQjlTQ53VjMgJp5MJ(b0dYp53crijio6gSlnwLm87MkssVPTtL6d(Gdh(KNn6MpbtJbZj(9LwTWUtWxnLFhFOuemo2wMvXUNRGPhD)xC83(nPjIrZH06lFMBaRi22mYd6c(nUgTEjcS9TmUWSPRKTnBxUXawnkTz)GU)kSy6d6BC6)HEBL7nDYqZq4MclFAV8Jtq)b0bEQWiiTfRzARie2avSGWrvj542VadgHOyh(Or39fuSdfn1iFOrmGLe9uLq6AvXtn8WNa6Gg(y055pg(XWV5AOIj(Qo2)CVkt4M5QQMLPQYmh(G)oU(DOibzqmB)SE9JA(ZszSyrciF9Fm0uDDnYgvLBLEZDepNlF3OdywXgT)dtJRILUa5dgenawVbga3uExddbvcmuy76uDQY(OVB4rFoJjNCoLP1J17CpZqWAmMCoo6RH)vvrk97F0j38AuMGg9dVy4h8qAgale9dsabd2sbeOScThsPp4qqmb42HNMqXz1TAmHRh(CrUaaXOFgwaX)S3wM1vMUk7uHDSebsJ0vvPk(2tUdZWpy9C4xF7Hpy)H)H7rJeoqLiYU6efz5vNF)bHT8Ae43F7bB51OTFZRSZ2Hjbcry7uLeMQos7LUqq5AMZIABmDw)Pdh9bpbZS49obPj(rbcscyzMLBb7uvfgPoLAcri4AAvzclXKw8BHr4uYyMUFgvfKyMTz2fx1FYlUsRNAKmGDQMcliWGFQAkq3JhehmMYc7uLf4TJQm3LgaRtL519BgDxUnOhEhyYWZlNn4Zf5EHTtgkKzgLP2gUv68YWh)CMFI80(jDEb7nb9mkjGff5cSLDLUg90VcIMz4d)umMMp(r0Q8j3qKWBtlwCzoPQjmHGXEnReYrnJyGPG90YWYYrV6S180VMcALS(dmqpMZ9aRR4Zkhc(SkemSFTOqOJFCYlLcH2HO6a)TaR44ETl0a4KXnbxlZFYAaki47Kk4dEsPl5lmuCQkB)J(8pL5xyAYmg9fhjt3SdlD)oMzgalJ3adGvwT5wVww8Wc94LAXdFjVOBkvQeVKRD2zeP1s9FbDXSQODWTDhw0aVKeQ6WYshbAw9egPBfSwLQGgD)pdfVqp5g9W7nC)hbWFuAYZysAUzGUL2RjTqAomUn3mAjuLHqbw2Cbp5Rsn9TzPUga8F)aGp44JUod86qebw0DGsn3u9eA6YDA(NMZk41X9of9vXnvJbeiRAQ9siEKQ2ZCigqiCN7YSJDYV)A4wzjmgGDNGVEgdn6QVon0KKEgBBSlDAdZDQnzNnXjEwnZEeaYFOgL3Wr5GkEvDiUHmspRr5oHrStEucwPqfE3Rsg7eis1QJOPjfphNzaBU7KC2ZcC8UDBYoywW0S524tEhwsqSIrfyrW6rL9Qf6L5XqGDhJqh2PnBZFBHyhPlz141id5RIJ6A5hOY)XbyDUWoP8msR4mjlo4BShAnmkV4c3ZiG7IX4LcqD6I2RBx6AsEUFP4Loc)8USNdVKmGRhEkxhdwPaaVZKQlUeu5ZparB5VlDeTeVJqDXRREF6KKg1Sv2BcL83miIJXM4bfKFhfqNKC8iuJL87GoDzhwj250MFedf32iXSJa8MbDJdVAWPW67Ibd8emY(Ti(xkk5lrBLfjhwWFjur2uSjyLdg1LkSY0t8MGjaV2y2PBkZBbSOrMrUrjJBJ0rTrPJzJ1tRGuvScVZwp44O2jWl9wrPajKDhTe1TvOKJLFpIgZUi3z3Rp0kuH7x081(hOqGFQcN2eC(x1jyI8WtcYC4GWFEB8KLMh)2xHkAp6U1HEkhbP4MEYB3hU6NTc6qhEXypvSiGAuc0eyoRdO9C6bRdLxzxxX0Zd62SZNol9mzgvIQM95qF(sgIo9ApGFpcioQGj(mzk2fmk)4rdZ7E4rxV1clrwnmyVSToSBgC(3XF9gGPv)DLVOurDxJFoqPbnM)GL7VlvKd17e1LoqnGC9MBg((SVT)awNWxHBD4)HVDN(9XAgrJR9NojNfAtNWc9ILJF22aA9QGPACe1wINi2vkIIhiA867CAiQOnPik)tyik)fiw5vIMo7yk4vHDvKurBsXu(NK8QUMp74hSGPufLu0Mml5SpHtjj)1nFvquLzhrXxSd8efonev0MueL)jjIlvy2DvcDRliEBgQlFOvrPtUYge9vS)5Qk)Cn992q16mgkNXu7xFEu3qD(16XQDxSBR92GEhecGF5xV3gnXkXmS7w7TrY2b7TbxbfULzux2Bd)e(xfGDnAt(FbtZttcaLnMeYTatZWsHDdJ3oO1B9204X0vr3yi0Lw3EB8FhGy)bSxC1xsGjVew2Xh(ryxy6q6FpnDsHgdykmQXA44Ew2JqSKyCA6WYwsxMhq1fa99(ck2vc2DVnOBf7Zq)Td9t2guWIj47oA0FbZ37V7Or3)zyQLXmkGT5p)CC)r(YBDgwrK8yUhS37HJ(GJO7rRCJVU2z0uNokBxAxMvu(UpC4t3F4x8Wzb5CkmsA2NrZC6iNBPDzgrUtU1Ta36p(FdtE(noaqsiSv8YKz2iLOGy(XgcLWz6ORQAP9zgXxSeE)I7bXhEY1FYmHHffD0uGvVkWq9s7ZmIHh)CCNfFWngDFCh8)d3B0NFRtU9(ZeUwuycfoC(1N9DMBLvwS25w078RUWI4RP1fxJaN4vEgGwh)Rei86Hj1JEOrc9BcEPemDDc032kGEBcIyoSWVSkPMysFp)6pu(C(ua4Ch89KpG4fh8Sy4oBh01dp4eJHc41Yd)w2KE)yiCoFR4pjouWAzrtzdOzyl8QRHE0LKQyZ2g6hI1o2c3VcWNZuXIKSHl3c(AnQ05uZRqZ8mM6Nr5nTfbvRYh0xntcQ2V0qBk2euDkcnTZy6wHmNBP9PszogVjVQ4)IVHYilMK2p85dp4a23DZNn6)Z1bleyoK(l)iMw4VA0xEpQwP0ukmQgUG6OPJPAQL2Nzft)BFiMPSdoSACtR44GkeQa30lTpZkUX2887S)X)lxRA0ZO4qPEgJkuSQzwAFMr07K7(OtU(Zevd1OhU)jh8KH38RQgtlkQOddSY)PA134QvnZQwDYRqf0PAsVW5fviPyFgfJ30Ez7u(G(QPtvZTeOvHFM6kL2NkfqSyUxCN9XS8J77a(xF0Tg9N)ASqlXsSC4b7F8rxNk87cJGc4EtfyLwP9zMXQBHLc79F2W)YxjDRSCClV2ld0kuvEMRBuAFMrCd3Eq(nOiUVnp(zujspze0SWGzydJ3)(Rjrv5)FxvIvop0kzXjVselCpV1ZP3xbJk6m6wVH1HOBx(G(kgQUtjqRc)t0DlTpvkrWzIEneGTHsbmq1b3pPPI1gQL2NzgRFzIX2qR4yPddxf4NEP9zwXVFAHzByuCWvoJzviSzP9zwr4x24SnkkSP4CgTk853WU0(mRO4REG2gffRuqlT)NEe(gxnoFL7vnsB8kmxt)NR4Yw3Sa9As5G3uA0fBxP85hpSfwHY0f4PFZTlUdQbTHfTa8vFiOn)E)vabQ9IRkNe(Tz52(9VAqms92eVo8H)mH3N8pSC0WsxWXITDLNP88Jpnq0vZb7L7O9UEBg2pMUlfQZUwJ53(WsWWEEPdAYVf1ZCnBKFlCzVNc4fFS899qEVfZYIFh6TbrJUM598ts6h2yqc)TepQF4VcVXnAxhF3XBiAd1KipeTNYv5hEbqiEz3P9EtaKW4vsV3KKpO5HXYlGz(smTFc0BWb90hKd1yls)h6NJA2REyxUiV4reppBj7EcNQpadh6gwuUeNDBE572ERIBFE2DUxUz)sgGlo3YlKJRHyQa(SQ4yORO2w0tnBSOkls56L888lYh(vpLKHI9y(TaXHYKlxeG3EBSCx89JO1a69dL6JOVRYFF7z)17gSlFBGe7y8Qn(hcAMCwXD)s67Aj2O0boBJRpOXA4eebg9cOogsnxBjES3gNf6ka6wLdKAuN5JMCPnZJDuY6R))7d"

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
				["CoreSavedRevision"] = 20231110040824,
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
						["r"] = 0.4117647409439087,
						["g"] = 0.8000000715255737,
						["b"] = 0.9411765336990356,
					}, -- [1]
					{
						["r"] = 0.9490196704864502,
						["g"] = 0.9490196704864502,
						["b"] = 0,
					}, -- [2]
					{
						["r"] = 1,
						["g"] = 0.501960813999176,
						["b"] = 0,
					}, -- [3]
					{
						["r"] = 1,
						["g"] = 0.1019607931375504,
						["b"] = 0.1019607931375504,
					}, -- [4]
				},
				["SWarningAlphabetical"] = true,
				["BlockNoteShare"] = false,
				["DontPlaySpecialWarningSound"] = false,
				["RangeFrameRadarPoint"] = "BOTTOMRIGHT",
				["DontShowInfoFrame"] = true,
				["MovieFilter2"] = "Never",
				["DontRestoreRange"] = false,
				["FilterDispel"] = true,
				["SpecialWarningFlashCount3"] = 3,
				["RoleSpecAlert"] = true,
				["WhisperStats"] = false,
				["SilentMode"] = false,
				["AFKHealthWarning"] = false,
				["RaidWarningSound"] = 566558,
				["SpecialWarningFlashAlph5"] = 0.5,
				["SpecialWarningDuration2"] = 1.5,
				["DontShowUserTimers"] = false,
				["WarningFontSize"] = 16.47568893432617,
				["ShowEngageMessage"] = false,
				["RangeFrameSound1"] = "none",
				["RangeFrameUpdates"] = "Average",
				["FilterTTargetFocus"] = true,
				["EventSoundVictory2"] = "Interface\\AddOns\\DBM-Core\\sounds\\Victory\\SmoothMcGroove_Fanfare.ogg",
				["AutoExpandSpellGroups"] = false,
				["LastRevision"] = 0,
				["GUIPoint"] = "CENTER",
				["SettingsMessageShown"] = true,
				["DontRestoreIcons"] = false,
				["InfoFrameFontSize"] = 12,
				["AutologBosses"] = false,
				["DontShowTimersWithNameplates"] = true,
				["DontSetIcons"] = false,
				["AutoAcceptGuildInvite"] = false,
				["WarningDuration2"] = 1.5,
				["CountdownVoice"] = "Corsica",
				["ShowWAKeys"] = true,
				["SpecialWarningFont"] = "standardFont",
				["CountdownVoice3"] = "Smooth",
				["SpamSpecRoleswitch"] = false,
				["DontShowSpecialWarningText"] = false,
				["DisableStatusWhisper"] = false,
				["EventDungMusicMythicFilter"] = false,
				["GUIY"] = -0.0002178665745304897,
				["RangeFrameFrames"] = "radar",
				["WarningPoint"] = "CENTER",
				["DontShowEventTimers"] = false,
				["SpecialWarningIcon"] = true,
				["InfoFrameFont"] = "standardFont",
				["SpecialWarningFlash2"] = true,
				["GroupOptionsBySpell"] = true,
				["FilterTankSpec"] = true,
				["HideTooltips"] = false,
				["SpecialWarningVibrate5"] = true,
				["OverrideBossTimer"] = false,
				["DontShowTargetAnnouncements"] = true,
				["AutoReplySound"] = true,
				["SpecialWarningFlashCount5"] = 3,
				["ArrowPosY"] = -150,
				["SpecialWarningFlashDura1"] = 0.3,
				["DontShowSpecialWarningFlash"] = false,
				["WorldBossNearAlert"] = false,
				["InfoFrameLines"] = 0,
				["DontSendBossGUIDs"] = true,
				["RLReadyCheckSound"] = true,
				["EventSoundWipe"] = "None",
				["ChosenVoicePack2"] = "None",
				["AutoAcceptFriendInvite"] = false,
				["SpecialWarningFlashDura5"] = 1,
				["SpecialWarningFlashCount1"] = 1,
				["PullVoice"] = "Corsica",
				["SpecialWarningSound5"] = 554236,
				["DontSendYells"] = false,
				["SpamSpecRoleinterrupt"] = false,
				["AdvancedAutologBosses"] = false,
				["FilterTrashWarnings2"] = true,
				["SpecialWarningFlash3"] = true,
				["AutoRespond"] = true,
				["Enabled"] = true,
				["WarningFont"] = "standardFont",
				["SpamSpecRoletaunt"] = false,
				["EventSoundMusicCombined"] = false,
				["SpecialWarningSound2"] = 543587,
				["FilterTInterruptCooldown"] = true,
				["SpecialWarningVibrate3"] = true,
				["SpecialWarningFlash1"] = true,
				["StripServerName"] = true,
				["ArrowPoint"] = "TOP",
				["WarningX"] = 0,
				["AlwaysPlayVoice"] = false,
				["NPIconYOffset"] = 0,
				["InfoFrameLocked"] = true,
				["DontShowNameplateIconsCD"] = true,
				["NPIconSize"] = 30,
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
