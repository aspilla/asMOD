local asMOD;
local asMOD_UIScale = 0.75;
local asMOD_CurrVersion = 240212;
local bAction = false;
asMOD_t_position = {};

if not asMOD_position then
	asMOD_position = {}
end

local version = select(4, GetBuildInfo());
local layout =
"1 39 0 0 0 0 6 MultiBarBottomLeft 0.0 -4.0 -1 ##$$%/&%'%)#+#,$ 0 1 1 7 7 UIParent 0.0 45.0 -1 ##$$%/&%'%(#,$ 0 2 0 8 2 MultiBarBottomLeft 0.0 4.0 -1 ##$$%/&%'%(#,# 0 3 1 5 5 UIParent -5.0 -77.0 -1 #$$$%/&%'%(#,$ 0 4 1 5 5 UIParent -5.0 -77.0 -1 #$$$%/&%'%(#,$ 0 5 0 0 0 UIParent 1111.9 -439.8 -1 ##$'%/&%'%(#,# 0 6 0 5 5 UIParent -1172.2 -470.0 -1 ##$&%/&$'%(%,# 0 7 0 3 3 UIParent 1172.2 -470.2 -1 ##$&%/&$'%(%,# 0 10 1 7 7 UIParent 0.0 45.0 -1 ##$$&%'% 0 11 1 7 7 UIParent 0.0 45.0 -1 ##$$&%'%,# 0 12 1 7 7 UIParent 0.0 45.0 -1 ##$$&%'% 1 -1 0 4 4 UIParent 0.0 -301.8 -1 ##$#%# 2 -1 1 2 2 UIParent 0.0 0.0 -1 ##$#%( 3 0 0 0 0 UIParent 576.2 -689.0 -1 $#3# 3 1 0 0 0 UIParent 1013.2 -689.0 -1 %#3# 3 2 0 0 2 TargetFrame -31.5 -4.0 -1 %#&#3# 3 3 0 0 0 UIParent 339.2 -356.0 -1 '$(#)#-S.5/#1$3# 3 4 0 0 0 UIParent 3.0 -546.0 -1 ,$-=.-/#0#1#2( 3 5 0 2 2 UIParent -324.2 -374.0 -1 &$*$3# 3 6 0 2 2 UIParent -312.2 -376.0 -1 -#.#/#4& 3 7 0 0 0 UIParent 559.2 -779.0 -1 3# 4 -1 0 4 4 UIParent 0.0 -326.2 -1 # 5 -1 0 3 5 ChatFrame1 29.0 38.1 -1 # 6 0 1 2 2 UIParent -255.0 -10.0 -1 ##$#%#&.(()( 6 1 1 2 2 UIParent -270.0 -155.0 -1 ##$#%#'+(()( 7 -1 0 1 1 UIParent -7.0 -794.0 -1 # 8 -1 0 6 6 UIParent 35.0 50.0 -1 #'$A%$&7 9 -1 1 7 7 UIParent 0.0 45.0 -1 # 10 -1 1 0 0 UIParent 16.0 -116.0 -1 # 11 -1 0 5 5 UIParent -272.2 -380.9 -1 # 12 -1 1 2 2 UIParent -110.0 -275.0 -1 #K$# 13 -1 1 8 8 MicroButtonAndBagsBar 0.0 0.0 -1 ##$#%)&- 14 -1 1 2 2 MicroButtonAndBagsBar 0.0 10.0 -1 ##$#%( 15 0 0 2 0 BuffFrame -4.0 0.0 -1 # 15 1 0 2 8 MainStatusTrackingBarContainer 0.0 -4.0 -1 # 16 -1 1 5 5 UIParent 0.0 0.0 -1 #( 17 -1 1 1 1 UIParent 0.0 -100.0 -1 ## 18 -1 1 5 5 UIParent 0.0 0.0 -1 #- 19 -1 0 0 6 EncounterBar 0.0 -4.0 -1 ##"

local detailsprofile =
"T33AZrXvwc(RzJ1UJf689dIy)GesctyHelLO92rqOuzvvkvzt9AYmleQNUvagzVQn4W2DdnQBdm4OnTT7Hjwzm2dedE6)pQk9FypNZ9r(OYQYcmeZeBmZ4wuvw375EUN7599CV56QRV2616h1BZW2b4h7DLGi)2T9A0oWpYRBW2j9I2QLFCY6ZVETg(9tgef4ff43gBCl8FHNh3pOD7g8g1jmUrt)eF8Z(dIO)nOBq0w7GFQPFh)TcGpLSETOEB7TPFZaVWUa0wrD9AWhwrB9vuoPg(79B7VtqKxZGe)W2XEBh2TzVTXXnUHpGTyhQdizsWvrSA9A1U8oTd7cFi(YaGQTy7RCXZIWbNpmyf75dO)wr9g0F96RxBqmmxaKWVByh)KWEDJrumkOFVOepCY5bW7YXytzdEmdF7niHJW4NYGXDcbinOJNKk2RtD)eVKWoi6Qat)a)KwEj961ojSpmJAM0A9v0nvKJAspVTB1B9AaXUTFCShqABedWPxuZyCmT0yJmoIMQUM6QAMCmq3g(Ko(j6zgS2aO1kQgw2YUjAULMO5IgBXATLUSTei14TPuqRb4oV18wQkGlVDQIgQkbBkopP2MDwwC6LVTWCZr2ylzRTNWKtZmD25WNDQLJdgtAIvcrWCkZTXAUL10ATSX4eMa(0w7gV1zOg6AoQJtrgVlUtdFSfn3H3CRjUIpwBnTTNYc5yRnzyUlbr0LqNbBh1PWNogOnMsJlaznlZPqXhRXwtJ9BSwNsqKOHZKB9uzThJn0YDs82J3wBLPHifBEMwpz1ofzSuv0MmrpV0MT6eX8c0evf9jV4uaOAtKrTa7HQIXui0fv4yRpnsxbqNPXLWtpgBQ(0KxgJuyofePG6ml1jsmkY1zAnfzLIlYPYkJb3XAQXueRkWXLGgarxqg0Lmxh0ennJgSbdQjTdWh2TPxCqeyQ1RVFe8j0oDFWeF96rbxjKmOJaV229IA3uylom2ljYpUfcU(xPVNFm3Fa471717YD8JUm5sHxC4VgTAdw5L(hGMJdA6bM5byCLG2i6AyUEn4BnUSxysqhV2b4ZbmH8uGApn9mlA8pgq6lpMRftWvOWUXj(DBee71jO7aW7Sqy8aFf61pOlcJXCBRrl4RbDjxTiYwCq7nbAq7EezcDqJAC3b99A3Bl0pM6zhMMHX(1BJu7iVwHB1Qn8)OMWMeqxyadDkbEw9bBUjqphe1hCmRg7BXHTbScierHbDB2ENndrN0AcZ6Er(iMX8FS2wrbWKOg4JtBGoaFAhWBsWrpHVIGRrnrAamYnXXTDyNqK73IO7XTaePBd)KGUW)JHHD3XlUrpWtVobXXaiIZp3Id2cOIjXWSOXLzmwP)y3EWauN7Rz9Xw7bgkDo5REuVlhWC)e9xtqXItIcsA0YBZOEDOfBGesOf)3XbvWv7vFqsc62j87Dc60lAhVi)oKKIWPCVyGrZRFpY1u0rsVKD6dUGgfUvyxG8bmjsqZWAg)mbZUd6eefcEl7fVtmYDgVtN69AhJEMN0t60zCJwbD85SDsQ0G(9Ja6hxCbKVRnOpmXfm1l5yyzzBzRzB76OA5AT(MNaCUQwV(KN0L5UEsjIs(xvikPNz(rtRIyp9Wn71nbevamebnknaZMLIc)17UX)Rb(nJGvMD3yT1YfFXe9xpUf69FeW6aXbaeWqGvIwl4(XNZ)DZmuhg4aeWJwAGp0Txuhwur7S(sNWw1r3wxXXvt3qvZWbOngWA6vxFjlxxvvxxthhftBfh6xqDua9uvt1sXXYw3YX1srb)fymBT(s2AU6o2k2wMAgggQwSFbXFqeKnKiP5Q0uCBGscDg63kAW)MiNNaQNmiMZnsQrWPBmxphy5qdxaaDROmp2JUYgcZ5wGIdM2BnUMEucVjTsbJq9T8IiYkoz2Cq721HiwaPdbWXjsiBPWR3MCclcFslIuoGncQzCaqLSkq8oCHjcT9OawRD2Ujbri3WLMRzZv7gFPfyblEPqu1r8LY2LypnyA5JmLWcCJOEOsomUWSkcqvLOSHNpOXRRxNbGUApKNdeRd7Ufjf65Tny1av9Y6t82HOapQ)f5IIbL4zNGOU6KwGm5wTe6di0H0UKaGfM8bm1iRHHkJIYm4Yq26ccnS4M1WeSC1yqCcQLHub9p21VtWVLVyJSSrmwBsXb2pKoTET5A0aGw3e)27UX5bbC8ln2jF3AVnqvK9Jz1yQln5yqupPb1kIXGnF8YIP1ZoySjQCORVfl3asgrz098v2D3OwamRctaugwHiT8uGYamqomYjG2daLJKH9THf5OGgmFbq9BiVtZGyquauva056Y1pM5gM0rE2dbFo3uTxA(hiEAHwdbZMC1kJCqwAOq(j1nnIgMrK0VD)w(OyJRgjAvN5xeOTqGSOPtaS550YogGdvQcVSuvTTKUz5AW9ZYLgvMujcMUCwqMInbFiz5eSJhtu2R43EaLkdfYtXzTH6ZAdnM1gAoRn0AwBO9S2qNzTHUZAdvvM5woZRnQZ8IJ6mV6OoZlpQZ66tcZIox7kjTRlm3SIUvoPIjRhkb9I0VoYhN0JsThihI6HHbviKt5e8COHDq1ECsyd4zCx1ywFYi32dDafqOctcu4EQirfQlt4ELaQL9f2hf2zZjxtXpuGSOjjl2gzjlSrAECGMhhN5rPO5rjK5rUFe09rf)RCcTmMukHUZCSgSoVzCaSeEcmFL8GvihCGaRcBhMecE)G(Q11dS)1H)nMhaBrQP0n1kXMO)MGLAWPW(epqnYxK59JQb((1ebFJa0uoOMFX1M7SlxZR2AZT2fRn)CxW78lFXZC2v8o9YRE63fiFuGitUzNFHZxt6ekc4P3s09uw4aRjC7ePflnvtLylMd9pq60kRZCd01y2NvyF70vA9CQtNAlEMZT4kR9tgrvFdJOSLNFQyP2RfSeWZ2bBotK1KcoObsNKJzzDHviIk8(xOViNtpNqZMJnairDDISpuumZq0VLG4NCvTD1uSmTaB72yaugO7LPUJY8(M8giVQOEDzYlcFAaVR6rbYsUeHA)yTccX)kIyVYR5zg8ibePLEIyvGqLgHCbfAPo8NR9HDzoQaO0omNOJ76Jkwe(GiDLHhaO6ypxGlmL5CxkXqVbYlUHt1wE13dw5LrVZIfZW0vxXs1YWXYsZudd4YYMcwcau)EHDbey(vxBTvp3fo7zENcHRkJzcqJnPqTKeeD7m)FSmWaolYiOlbHVzydr5POdH0zzAYwAbI8K(f9j9lS43yAtbUpkJrmA3VOq4zEu2t4sgw0k6j0zjor6UlL(ikWdmghI(spznUetDHc26zgwUJX5D2SUFJl3mQx)sCq)muU5erDcJHGDKg0gdIa)3PTkeDpNfcUiRaefg(cespe4Ew94eDGSQhJPSiVx9zOp5XY8CquSb9IdB437)0hYosBe8Cij(cyOZ02Bsw0dAmJratnL5)eF(sGB5SGlh89IHg1we83YJ)yAfdgrklouSpWd3m8Qa3vL()W9fznbBgkdsmE4hQhKSnMkWm(sTJWBeU2FC3NropE6Fz7rQmRMLGWZIAozkL4K0Lqn2xcwj0o5ARTeMj305kPFlVpscjbYlMQdvon69mQZhxic8nAEsJ6UBW2A5EndAto0mOFFqyK(o4ifU17XxAoWY68ruQzHFpi6myovp55GbbCKnT1VhMj8lT4)7Zp3k1o7QROODPfwD1fMBHAxcmR20pkY)sNE1LxyUlCH5aZ5xS2j7OjgpPEptbmZG(ShiBIQOtPnrqMttQoBXkFgmW8QQ(Bp5UBqFs)3s)J2VfKAdIqhetnnW6nO3VBm4tQmVccEeoylkIK2Gzt4HY(9o(DB6ZZCqUvFfY(aOmI5BRquGHALN3dUvI8CLN0wSHtITrLfHUqk4cmLKurvmMZ(jCmB2MqKadMCxsyUwHuFwcZn9yi2QDywfhJeJMFz4yDCpqG(v7TepzkP(PKCUMQbHG(efBteuycqDh0PoljsLOeBwe(zDlJIK4unILXCU7gVfNR8)HKn9)2BxMe87WzCetP0TrjZY0s0MJeVuKFNGlDXZEc(3xgIq9eVtAhkr33mZbB4ffWc(wY(noYUW)9Wgjd6uCziRU2PrlxYeSzAAAQdMcD0v0PndWC9sX8XhvGMYrX3wQxOWccx3IkA1wYYqmNC218iwcFtVKg)iBuc98tpueI9l7WNAkmvWFt)4eV(XESTejLLjoOVp4PfqPQTYQRSiUhxmdDAesX8C7DOT9dyq77dk2k6zFwhjNyQWdUkvtq5M25RJfBYZA2OVKJIMPIMJJQTJHLgTxngwY02wJugW25s0RKS66z1O0sgU2oMUQo2qalMAkgmVJOKYderCBchlaL27GEEj3CvArld)6zp9QRu7sNDLFHhe0syBV1ambD8RI0NitmSGW6WDlSKK9ISaLMb)IzxUG(yn5EeX3iBrvTiIUKVVzOMMyAJHIc6aRBuHX1HTZFyY4XHsSZSB22Fl2MwwwMOWwffY2W42TdBgl322gGsY2z2OKD46otc87Kf(SD(nDRC5PQgyK70xeIQtgXwng30junyti)2yG3nX9pNY(pFVdWbUfgtMFDVaqvBZclZ7KvO4Qz)c2dIiGbObeE5(tY8gOr7EdaLkSkkmTYaHb6YbD9qTb7K0ctbhAYGicInGvlJRez2eqmdbjYTrfc7mamq0UjfdUyRJbWc8bWJWnnnytFG3WRoFNSXfyfxdvc1qkFRWG2nJzBHdtBaVi8Q9oxCL1w8cZA5Hv79a)Po7QxyMQtUA1EN5o3CRuwnJy4OyynXs0P25M7mlwD3YpyNFX1MHrkF9HuBHlCXZUqMkervXnTmrmakOHs5fKtTZT6kVBj13ILB2UuSSrQTWIZT278URqbNp71nhoy1M2QuHz15NB55w4SRmRfZsTlUY7UYQV3SxTo1o)fo7I1sNbziYA5PJLU6EXvoZfw9IN)8lp3VmDondJ6CG2emNvtCCvaRbo2q4UL2DG1LNxVzz1EmSEHfHvH8slILB9Pxxr1Ehm4NzDClG1xy1ZCXfNrkDEo0f)fR(UzWvtfDxL0ccBcS1lUYIN7xoJ8zjIIwHYfcZSbP9JxchGQC52oMMITw9sA0lQlwTj96tXlVgl3g880ikOf)oGdwurehtP9Zqjv5LOyDkSCyjc(WrNJWgLP06K2ocIGOW8m0lsRv5nXvSBJgQJPzYq0ibhNlzaAUlS4kZ59lxC5LLcvQ5kdWPjgyiyledBr1uQs(gElumkQpk3Gz6ojfp22YfybIrKHAlU8sPLWORIQRGBtt1uqoypxoBpZfwCXun9wowsgubSDvkt3erFzcpYcVvVmDsJ5gtr1qJLEMSge0lqvhNxhw7uvTZglWjHjOvQBQY8GRwUUalXkNQyHX2Tm1oMcMpt1CTBLfV4AxyULlJHPePzb9W02sYP46mUrxX8w0ihBMGBXAxc8NCRTcIe1VKPOKfHWL73c8QBEH3X5RirTScSOwaWbUywwne1ofR4WcAgsPjTEup)M4XRiFsxOIuIsHo4SnRIa3MCvRxZEe0I8BgsogzXZEwA6t49989IX0BQPOdQi1TmbLKGAawsmzLmcMYqAd8ZOUjTgXy6BWTzSwh)RkQ)mkhpRLg6JbE(g4N1bqxmcIUbBpPwRcl2IwRZ8PJILalwZnJ83koBX0LFhCLNPJuVzj3hHg53H2YJUBgsBQ7MmQjl6nQr)ddqcyZGeE8dyMWdaFzzXq2WVrlkkVUyLbbR5XIXkLPWVrJG2z1L3b9GTHxZbD3kGGysr31H5eLrvb7qFaAnOK1Xg)uNYzBUIir6KFSEuvNow8JKVXZsEiX0NaowVDtS0pahSbSPdLmpm)jfQLeHyQWoVWwDAE94fwflO3SP6tjxG3LuPESbuU8BvoQreQnX0KqBYiRIHGO4i6x29)rUXefMccDMQYsHXIplmOqL5B6w9uorkN8Cor8CUKWr1PvsscjybMYuCGs5XB73hTm3ChiQiyvMZjqhtkGHacvUxxrisSn8y8Q6TEV4yrLgX3wE(E)mPSGuSKfG1mP1dDPDADxl5b3quPDynkJc19dWiMWScuulwliQkEbWwcdhwGrIYokZwkMMgibcrbDXDgL(OE6hLHDdcvxjmUx0SWztb7lRDoobcIHmacSKvTMyRnvS5jE9e6MCRB8zuALsw0wOWhjDjQbQ9RZQZIvS5jyhlUHaGPalbzb(WIENTPh5Ps2fjr5fhSZVAK4hTLybrMYwKp49yT9DO)rwrEGQW2Wcg4lynSWy4pfTDXmrWsgltloQPCqDAdftZnfpTzuIHzYBKeDJED643TjNpfBXKfVFj2VzwlN6MHOZJ3hJBx2W0SkbEWS8YZV6QV7LODgbRO)tCE)TcoHO2)shdrc0QnpRs7uXqeQTmX8zthCkWpPmF5czAwskzz9LaZMQkk66U22o6MGlkGbux5SHRg0Gmrg2bjKDcsA1RjBFmYS2MP(AK5MZJVd117LqzBxo3tpsGQagyc2Vn10D0uC00nms3UzhDnnltnigihWZmDfwrAJB3STLTHQUHQTTUPLQRolJTuUCv0SuuTnmDv001bpT4BeDkJ80L)YGJzv84uWXFhrOIIYalQbyofS(EfqtkvoOJzFu4VHXyhLYPPtwypMzpp1vbMP7C5yJIvIxw0STi5LChvqpJA6h10JYYx9CPzkBAvf229qJ7a)WRSzCw2aZu1WvyogCUkVFjzDPm2VtF0RkQP6C7TEavlHYC60n8Y5uxB1ZN9e6k8KdTLUdMVru9bR4lk3s9yQg4bUKwumYuQtUFWpucH460v8BZ0oZ8EvKnsTkDbPmZ2yrf2UxD)fy77gNHlkObZNBw1nW5mjNYYw52WV1oCtGdMTXLm35AhCfQ(HyNNaB(UueHNjP((GtQO68b9XulZkbq0CpBJ5y(FcJ6Oh8OHFX92DJH3)fJ(WBD81Fmyas1ufdzS2OV6AJo4rdFYlg(xFXUBm65pD0d(uODIwau8JEYpE03T3X35GHF0THw8K)fOlh9SdHpcD9J(sOldF0ZeTh0bn6EF)X35Bg9KNo6(haJ5HFJ43mqm5Jo(b3c66n)YJV7bqBe)gPDmSthwSFK)dyHzIf(aDmSj3O73iSPhRyLAYmI0g9epb4gBGY4OItuboO)dC)dDTogJKXwX0euh76YDQclcF0XOSjlj4Q9DvscO0EdlATbHlEjS4T2PxDE(zpNLb)TBfGknoZfp7YlKfPhaAoip)dHW3KBGeXbG5rgRstqIOj6XwNqw8TSC)hVt3gzYMnpZ1sCnZ5lp1te10chd92JxmlPbRKkmL3VAsvl4oasIZy8G2Jvm31IntqY9KBDrm7WP6uND8Dcau6IhtDFaE8DIoHFY)9WtF1wyw35RH)ddcI2HT)4L(7SKtn5FgfywH5LbDK9A6rcI4Mt5AltPfZcbEU(jFjDzf7zAkBwbn9Dsxl30Kzbmq6QN0rXrK3QLS0TC0mmDSS0vnuSrB3628uwbbRQRdAF00KPnzjlvvdhtaluCqRN4gPP7itQ2swgAAQ45IYKQkihb4WenTKnwWF4py4yRPAQW7RizhGFeqdmTnSDaBV6UA8nPlBItWJgVRoGs2YKwSIMIPI1jXJAnpNxlzQdESORbIkggk6uLKHdepDilzb)Ify4xfCX22uN8xrjnltlz46cqZW0YwbpGxO9FDxMcrHnJuoGeG1okKvgvPNFsXdX0u4dSqTcAloSBGIphL0sZ8SRS0QERDX1w9cNDULvzrdbXxZ0eZLqQJci1rtc1rlc1Z40nQcTlDK6eqhG9Q)IfVWClV8cZT2CEa1DLZUYzizSANdlu1vp38ZTM3AN9ClIJgpfvqC8Db9ony8LnsIAZpKLSndk7e69o7klS675HRzExCf8Fi0U0jKgZDzCB5avi0mxe692(rDbPmG7wv6xdDKEOYJZd0I5rcBsfIeXqdCkJQ)dBhl6FTuPQ9gEUg77Wsf9Diso6728)v3K9VkMmnGfrcCoiealr9rQoyGNqr1Xa1b3h7a55so)zY4rrUD1twWS1yAhUAMtrMD2THKGc)6)G7kZ8L)RzgQs7SSyRYHiPpoxNMK7wzcrjx7F5MptcxM68BgqPCq7LDkWhMkNj53D2jq0LtLuZ5md9t0i(Ld2jobTZKMzhPXoSsn51eA6HyKsOARWeo(G1)bibF5qM)7mRbEP2hyMIt8PdEqmkuHJHl2wvd6V60F1O)Qs)vHnbKMdhl9uCpofYo44qNRuuspUnU5oa9aCSJ7s9vcAEAQqIy1QN4ewjxHQD0)6lg9WpB3no67((JEY3qoExAzsSneXNhTZfRiUzdOuAxd9Z7t(tGRyV)JNgaEVa)(abBEGmQylowwC(dakh)Noa8p84B)IJVZt3DJ3A47)NahfbG(dFda03UuOsZiVZ5VfeoXsi9kiAjmmi(j5IhNY4W(4dE2X3)lapk)H9p6WRvoSNJCOzhVAd2CZEOlcIJ9fL8MsH6TFb4B80W05IA4dlMNd8v8CugG3rCeXqGAvkq)t3E0DFXBp5vLbOhvlH86lfgfuRFyuyI48KHq1UmOo6p)nJUZTN(e)cT2Ph8HwE)IETb0UN4SNHa1P0vSp5dgT33oDGEASirXkE589cJbMbfnXjvJyeCaNjyKHFZAQ6o26M6Ns1a)pf4)N9j1tPQr)53KS7gmYdfEaeAYOBEFw8PSUkpBBmyRAW2dwa2gw6Opqth2d)H9g9d3tgTYH)imC36w0aW7V8iXXgaW2OoFa0G4DuSNo8hD39g(SBn8HFkg6Z)2JztcM0a1B5XOJevvC0SzYRJo46hFagH19Fki2vGCpxtWV5XYsafeNpgUCB066MjYdEhdZbYLBkPXuZWQcuF)7nA)do(oyKG)W1o(wFnH8csd2F551tUU686DD1mdSDTZUUQ4ubY)W9gDVVwSUo8V81dF(EmWROAPzWUBtecL6ONOMPRQg6kva9)iG23cekGp(x(r4Jd)4)zXIk051zjvvG7qqngc6IIMRIsfq)OV7Hh)hFea6pc1vZcl(VFBg8n1uTjXjvNS0gfbTX00WW0Oc6(N8VC8V)Jp(tEmqYb16z4j5DNGVqEfI1W1rqCmvD1TRG0p8WBp8b3A0nU(ONGaE))5HFYT4KEnxth29)IqI1gcoGRO92mwHHF3tbv3d)QF3SZ0xVDVEn5EusqpvCvtvxG7wqim6vWZF0t)mwUk(JpD4Ff(3J)Z3ceaiSN1Dc8APQBCTStxAv0DvRKTC4JqQYdVhme08fgpb1b7)6SKojfADmZQpt3TI12rpDFmNnhChGq(bpB4doafbKQZ0Dzw2tLzTX6OnJCLAvkfE(trvs3)hPpCazE9yo8vCn1yxUpcW7cCt6zaVPDfGF4TV9O)8HdF0th((hWOohUhd8MqOZQmYVvkNPIPMuJJLsLITGo4F82dp8Ed)d3JH87VpxNJPTRl7oRssA0D1fITWNDvRa4d)QhbAQLACE8lsvxY6obEHulW44YkRHAGE2J((pviio85FoZndWE7BZrolfBlgLnJrudTSlCMvY595FkWjp6UFkAL7XcLamsRTgizsoRjnK6AJjN71mJHUAwfUQsWBO764wb4p8hh9fho8tbJrhFWZHzYrF)J5qN6nbETugd8moXvzPBA6wHLOr)WDaVAi0(4BE4WRFlHYCtQ6IW7JhgKDDu04gOVX9h(3(GHpe0tdREGxsYU4qCP6gzm8MACrfldc7k9jbKDjdVawn89V3rp)ghZlOwQ7e8nZslDZYkyzwb8V11apIzlsF1Taovyw)Hpuii4WzfeszgkowoAs4dM91RATcC8C)V(ONCiJl7g7rtj(Qf1FAasL0CCneooa8koQvOJB4)(HJ(IVLrFidX4saJBWcmVAZOpos8321svQLWqx3UA3saMH7asXhF)pD4FDVr7DFP9lUdH6PcIgAPwFrGBxPfMHpGt8)WRn6MpeJtHt7HLxc6gksCh4KfKgyLfujvHy(X34AJo4lrfOK)SGzSp7HCB7U4v0PdbF101whvP9fhnDfnJk9nbyFyrv9J3iVbmDlnQE9wXi1aPHUM5RjQdiyXU)osToQABLkM7OyOvbJZNCRr39WHFhmapLXMIlYmDGu3jWBKs81vSKEfAAPyvfJ)Dpy4d3F43CaOez0NduPJV3thY1lqDNGFQtTUoPEKBQ4AOvf(tUXcJZn2F41FbG)WhVdpyfqjUblUDJujxnSuR4daT8xLbYhIlT7T)WV(zquUSLHN(7YW(WwaSZqH0mE9qHYYEkDTfSBWQKKAJE(dp((Fgtd9dG)8w96U7g70Bq0UBG36CV9m5SyqDWzXouswWHridBO6yQjCJtdu5xLToiCOr7DVrFfQy7)l6KvQPEw3P0iifIXT5o1nfxm5MvifaAN)WpMr()BFnc)BEVJ4sbu3j4RMf(oV(HFgRP6gAzfIRk2R78bd)B)ilSI7GkN)3(4rF1(PHa4YUBv1LW3e0rN6ghMg5QmWC4W)6JjFzo6W)p0oeE0399cLqQmB2Y7wxxiKPuMuBTQmFn8t2dCgJcd4ONWJCXuXXWL0TjVgEHi1TSL(WatbdNQ5AU)ZqpXGiPF6Xx)XGKGiSlS3e0L(2AbKj9uRwMg6v5(5(O)x38lrNCz(FDTrc7kGIg2vLRe3XmnK6ZGBLQ9F2HOTKB(LdV5(mll352hNgXlJG7KYqAkDD2vdIzTQKKaSFhUhr5h(zmH8rF0ZjWZ6ob(mbKQAj0BQQcrnzPvn)(nX0y8j3C0Zrpi)KFheHKG4OBWUeNuYWVBQij9yAKRsFW7FWWh)0r38XyAmyoXVN0Qf2Dc(QP874nJRGXX2YSk29C7q(O7)IJ(UVnnrmAoKwF59AmyfX2MrEqxWVX1O1lrGTVLX5NnDLXSd9D9bSeqVzuq3FnwXmbrgN8x1FRCxI3gAgc3uy5t7LFCcIgqLhrHrqAlwZ0wriSbQybHJQsYXTFbgmcrXo4lhD3xqXou0uJ8ML1aws0tvcPRvfp1WdEmOdA4JqNN)i4pd)2RHkM4R6y)ZDnCBObkMuZYuvzMdFWFhx)oqKGmiMTFw)OEn(zPmwSibKx3ZgAQUUgzJQYTsV5oKNZLVF0(mRyJ27HPXvXsxG8gIMgaR3adGBkVRHHGkbgkSDDQovzF43p8WpNXKtoNY06X6DU7vAyngtohh91WVvvKs)(V84BEnktqJE(lg((pKMbWcruqciyWwkGaLv00YDdtdXeOzRLjHIZQB1ycxp4zICbaIr)mCVJ)zVTmRRmDv2Pc7wwYbcI0vvPk(2JVdZWpy9C43C7HpyVH)H7rJeoqLiYU6efzzfwrZObHn9Qh4h1AWwE1B734YB3kmjqicBNQKWu1rAV0fckxZCwuBJPZ6pDWO3)XyMfV3XinXVxGGKawMz5wWovvHrQtPMqecUMwvMWsmPf)oyeoHmMP7NrvbjMzBMDXv9N8IR06PgjdyNQPWccm4NQMc094bXbJPSWovzbEBfjZDPbW6uzED)2r3LBd6H3bMm88Yzd(CrUxy7KHczMrzQTHBLoVm8rpJ5NipTFsNxWEtqpJscyrrUaBzxPRrp5RHOzg(WpfJP5J(sAv(4Bis4TPflUmNu1eMqWyVMvc5OMrmWuWEAzyz5OxD2AEY3qbTsw)bgOhX5EG1v89iac(SkemSFTOqOJFCYlLcH2HO6a)TaR445huObWjJBcUwM)K1auqW3jvWh8KsxYxyO4uv2(h95FkZVW0Kzm6louMUzhw6(DmZmawgVbgaRSAZTETS41ik8LBXdV62P7Ni68dix7SZisRL6)c6Izvr7GB7oSObEjju1PRsbk4KvpHr6wbRvPkOr3)ZqXl0tUrp8Ed37lb4pkn5zmjn3mq3s71Kwinhg3MBgTeQYqOalBUGN8vPM(2Suxda(VVpWhC0HxNbEDiIal6yyUIBQEcnD5on)tZzf86XB7I(Q4MQXacKvn1Ejepsv7zoedieUZDz2Xo(3FnCRSegdWUtWxpJHgD1xRgACtf5T1KQQbAOUTtvP(4VZxAFYHykqEWNYS5ZgbgaOrqgLVk9OSjNOkQZhF7H)t)4XhCnw(H(U9g(8pNlayPArSOUzf4LP((NMa)pdvxZ9kcI(wZvLxoL1Jc8VmET9Xl25e)6uDuIf0iV8N9B2eVfmWtxk71SvVUGkc8OGlpMA4TPvMUiEoElhM5XPN8Q8hldf5nbG4WeRyMTU773YpoiDudJtle)mqNEBwuX5vGFN0q9kfG8lygBWXkhqPGITLJHLI463JGoEi2YCteL72XUarrCmtzxDWuXrZFZFX0LcniPLxmESge3qlJrwPZa2mEwxsjb5ltmNXiCzoEaBHVp0cBuCmJLNpSAD5vdxMorxi9Il2u(0u1LQNuE5JwD7zhIX(4nTem4nFz6bDkgM12t31pv3ysBxTi8wTS6gRZVyelqwfGYvzSFItvFjONVXjNS7mPzNCYA)BsYzwne0bwRQdJd7aIshdXsj1y9y2I)ccScCWMDwWNT1g2nJ5RWIZ)HZ5QXj1DXIeSp7iLJQIQVJh7u9ZUPFfNKJzvr1u1eNEj(n(Iv2ooMid7(cZaC)3rfCrZvxXMFuemht1TS1G7BoUQ6kM26gQg8lhSXrkbt9yaklgnMYrsPOSVGFxzbCEBzIt2S4CnlovZSRIUXWhSIINUfG0ZWE6nb8KUt8oz67Bb59HdnUJnJeM8mnSvmCX0pAzRXU9ynYosLC(wN89uzS8TFPS)sdL2LGezP5Jlopv2GjSeLEzZbHoOyPQARdo0ARXNxm2)QSgxIqc9t1lzyNbtQzv(Nt2mtFNKcMkAFjA)N1EiujntTxOsQk0pNkPkASq7FXfEoNPLkScAQOG)XuxkqxQmqwMSsfKE1Sk4xpUx0433CLQ528vrtpQ61)kBnlWN1EiQ9sgJj0hkxW4rr0FM8lG2gQY9KyQifUXm5TEoj8XumNJNzSFwnmtfB8lRHzgN3mBQTv4lbI)AYiU4vsr21OKjzTiZ98zzkJ43eoouqdSxxHEzEjvWEbjtNLLnBZFNpXoewsbN6YXU4jNv8MIduvIhQt2dXx9YIBiM0txtUZud7S2KGt7cVM2sYh8u(dxQ8(jl34jo6yt)q7w4aFshogbcKu8uZMbzZDP8JNz6cNOgcbGHVrl8nliEQDywU1STXtSt6Hk(x1Bqux)2zpsSS7aJbB51hOOHnWBjF(2NWE)dsxbMbna3fsgKaWGDPukF)uloE4Idqi7KOJBzArg2TBbuoKHIUtn72LU)UN7xkEnEHpVl7LjysgW1hpVWJbRuaGx8y1e3WV1LuIM(7SEnvx5ljRU47Ib)TORm0gnNWDhK4WhkExmYjTSRJk(jYCE2nusmE02rhGg0Pl7uTjpXM4DEqq34WReCc8emYGbEmq53Qn8FKVKlBRuJaUeNqhxLInbvq2Rlzfj9iHjeJWlD2T7MYRxalQNzKRxY4wpDuRx6ys0wHUaumpBW(4O2jWl9seQajKDLgbQ2dLY88Bi3y2ROa2vQfT8u4MZnP4TUaiSZpoOtBoo)R6CmrEWRb5iCq4V7M8KNio(9seDiGRluvSvqh6O8f7PINDg6wQIEbzcsUn8KV335TgTMsVAhrDBXzEdrLokIze7LRAlM8lRwhYaDI0K9c)A(savN(TheNvOLUIFyxES0LHb)CndZ7(49fqZfwIsbRb79cSd7Q9N)B8xnjWKnAh5RlTEDxtCCdXbnM)6E3Fh6eduRdykaZVaixV5MHxL9RrdyDcFhMRd)h(Mp1pcnHq3SfIlx5cTPtyHEXkyown1A9QGPACe1wINi2vkIQAcXbOnDev0MueL)egIYF)nR8krtNDmvtt3UksQOnPyk)jjVQR5Zo(blykvrjfTjZso7jCkjLiCZxfevz2ru81rdMn1PHOI2KIO8NKiUjvy3Up09xH4fpsn5nrdkDYv2GOVI9pxv5NRPV7gQwNYq5uMA)MZHknQXVSvwT7IDBU7g07EHa4d)MD3ObESgbdZ7UrsRGD3GRGcR)uQl7UHFc)NcWU2Bt(3GP5jjbGYgtc5wGPzyPWUHXTcA(wVnnEmLy09ZcDDUU7g)pbignGDT58scm5vw02(WFc7cths)7jPuLmgWuyuJ1WX90SxHZsIXjPnkOKUmpGQla679fuSlhSZUBqx57NI(Ud9xw1(X2fMV)Wr)fS4P(4dhD)NI1PfU98yB(Zpdl2WV6wNIDImEeF7GU3dh9(hsxDv5gFDTtPPoDu2U0UmRO8DF4WNS3WV4HZcY5uyK0SpLM50ro3s7YmIChFRBnA)do6FhReTBSpGKd)d3dV6EMnsjkiMFSnoLIZ0rxv1s7ZmIV45H9lU3WVA)JV(JNjmSOOJMcS6vbgQxAFMrm8ONHLP7dUXO7JLd)F4EJ(8BD8T3BMW1IctOWHZV50VZClV8IRCMf9o3QlSi(QI7cRrGtCTxbqRJ)LdeE9WK6rN0iH(nb3xcMUob6xBgqV4n6XCyHFfXsnXK(D(TUV8DvvbGZDW3t(6xV4GNfd3Uvqxp867zmuaVlK43)007SgcNZ3k(7AgkqSSOPSb0mSjgQe9gftQInBBO)iw7ylC)AaFovflsYgE2MWpRrNdn18k0mpLP(PuEtBrq1Q8b9vZKGQ9ln0MInbvNIqt7uMUviZ5wAFQuMJXBYpI5FX3sL3ewXtFWZgU)(SF7MpD0)01bleybz8x(rSgR(6rF19OdEKMsHr1WfuhnDmvtT0(mRy6F7dWYoz)dQg30kooOcHkWn9s7ZSIBSkr)o7D0)61Qg9mkouQNYOcfRAML2Nze9o(UF5Xx)PIJw0OhU3X7)4H38RRgtlkQOddSY)LA134QvnZQwDYRqf0PAsV((lQqsX(ukgVP9Y2P8b9vtNQMBjqRc)m1vkTpvkGyXCV4o7HLmhwtp43(WBn6p)n4PwepVId3FVJo860POUWiOaU3ubwPvAFMzS6w45k9(pD4F5RLUvwoULx7LbAfQkpZ1nkTpZiUH1Al)(QeRjQh9u68gpze0SWGzydJ3)XRjrv5)FxvIvop0kzXjVselSaY1ZP3xbJk6u6wVH1HOBx(G(kgQUtjqRc)t0DlTpvkrWzIEneGTHsbmq1blaXPI1gQL2NzgRFzIX2qR4yPddxf4NEP9zwXVFAHzByuCWvoLzviSzP9zwr4x24SnkkSP4CkTk853WU0(mRO4REG2gffRuqlT)xEe(gxnoFL7vnsB8sRxt)NR4Yw3Sa9As5G3uA0fBxP8DRFiMcBhl8MqTNFJwf3c1G2WQwa(IsjOn)kuwU3Vy7ffluc)EFSLF0vcIrY3M4lpc4Rj8(u4wqNgxZm77kpv55hFAGOArGED9G7u3MHrX0ntyn2Ljn)ICwcg2lp9Gg8x2azkZG87Hl7kohVUPLVEDKxb0S043HEX(OrVMg88tsIcRpiH)MYVxu4Vgl3G21W3Q(1fTHAsppeTNyDmBs)N491eTRCcGegVSSgXsFD9hglVlR5RX0gkqV2AOxui5qn2I0)P(LTEc7LmexMx8kYppFj7oBhRLblthdhJmlXz3Q3Sml8I0O4UPNUB)sgGlm3zxihxdXub8zvXXqLXqt6fPCSOeks56L888Q(Hx8Dsgk23F3GD47MJyJFxT(VkOrYPfLVc71Ul9Q8CbIBMjeVim27UXz7IVzwAoGEt6sWta3vbPdA7RfBwu6aNDyQnO(A4eerJYhO5AlH9UBCAORas1SCGSc1z(OjxAZ8Ailz91))9"

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
				["CoreSavedRevision"] = 20240208174317,
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
					[1003] = true,
					["2238아미드랏실의 심장"] = true,
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
				["GUIX"] = -56.77048492431641,
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
				["DontPlaySpecialWarningSound"] = false,
				["NPIconSize"] = 30,
				["RangeFrameRadarPoint"] = "BOTTOMRIGHT",
				["DontShowInfoFrame"] = true,
				["DontShowNameplateIconsCD"] = true,
				["InfoFrameLocked"] = true,
				["NPIconYOffset"] = 0,
				["MovieFilter2"] = "Never",
				["AlwaysPlayVoice"] = false,
				["WarningX"] = 0,
				["DontRestoreRange"] = false,
				["ArrowPoint"] = "TOP",
				["SpecialWarningFlashCount3"] = 3,
				["RoleSpecAlert"] = true,
				["WhisperStats"] = false,
				["SilentMode"] = false,
				["SpecialWarningFlash1"] = true,
				["SpecialWarningVibrate3"] = true,
				["SpecialWarningFlashAlph5"] = 0.5,
				["SpecialWarningDuration2"] = 1.5,
				["FilterTInterruptCooldown"] = true,
				["SpecialWarningSound2"] = 543587,
				["ShowEngageMessage"] = false,
				["RangeFrameSound1"] = "none",
				["EventSoundMusicCombined"] = false,
				["WarningFontSize"] = 16.47568893432617,
				["EventSoundVictory2"] = "Interface\\AddOns\\DBM-Core\\sounds\\Victory\\SmoothMcGroove_Fanfare.ogg",
				["AutoExpandSpellGroups"] = false,
				["LastRevision"] = 0,
				["GUIPoint"] = "CENTER",
				["SettingsMessageShown"] = true,
				["SpamSpecRoletaunt"] = false,
				["WarningFont"] = "standardFont",
				["AutologBosses"] = false,
				["AutoAcceptGuildInvite"] = false,
				["DontSetIcons"] = false,
				["FilterTrashWarnings2"] = true,
				["SpecialWarningFont"] = "standardFont",
				["CountdownVoice"] = "Corsica",
				["AdvancedAutologBosses"] = false,
				["SpamSpecRoleswitch"] = false,
				["CountdownVoice3"] = "Smooth",
				["DontShowSpecialWarningText"] = false,
				["DisableStatusWhisper"] = false,
				["AutoRespond"] = true,
				["EventDungMusicMythicFilter"] = false,
				["GUIY"] = -0.0002178665745304897,
				["RangeFrameFrames"] = "radar",
				["WarningPoint"] = "CENTER",
				["DontShowEventTimers"] = false,
				["SpecialWarningIcon"] = true,
				["InfoFrameFont"] = "standardFont",
				["SpecialWarningFlashDura5"] = 1,
				["GroupOptionsBySpell"] = true,
				["FilterTankSpec"] = true,
				["HideTooltips"] = false,
				["EventSoundWipe"] = "None",
				["RLReadyCheckSound"] = true,
				["DontSendBossGUIDs"] = true,
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
				["WarningDuration2"] = 1.5,
				["SpecialWarningFlash3"] = true,
				["DontShowTimersWithNameplates"] = true,
				["Enabled"] = true,
				["InfoFrameFontSize"] = 12,
				["DontRestoreIcons"] = false,
				["FilterTTargetFocus"] = true,
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
