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
"1 39 0 0 0 0 0 UIParent 713.5 -983.0 -1 ##$$%/&%'%)#+#,$ 0 1 1 7 7 UIParent 0.0 45.0 -1 ##$$%/&%'%(#,$ 0 2 0 0 0 UIParent 713.5 -914.3 -1 ##$$%/&%'%(#,# 0 3 1 5 5 UIParent -5.0 -77.0 -1 #$$$%/&%'%(#,$ 0 4 1 5 5 UIParent -5.0 -77.0 -1 #$$$%/&%'%(#,$ 0 5 0 0 0 UIParent 1111.9 -439.8 -1 ##$'%/&%'%(#,# 0 6 0 5 5 UIParent -1172.2 -470.0 -1 ##$&%/&$'%(%,# 0 7 0 3 3 UIParent 1172.2 -470.2 -1 ##$&%/&$'%(%,# 0 10 1 7 7 UIParent 0.0 45.0 -1 ##$$&%'% 0 11 1 7 7 UIParent 0.0 45.0 -1 ##$$&%'%,# 0 12 1 7 7 UIParent 0.0 45.0 -1 ##$$&%'% 1 -1 0 4 4 UIParent 0.0 -301.8 -1 ##$#%# 2 -1 1 2 2 UIParent 0.0 0.0 -1 ##$#%( 3 0 0 0 0 UIParent 576.2 -689.0 -1 $#3# 3 1 0 0 0 UIParent 1013.2 -689.0 -1 %#3# 3 2 0 0 2 TargetFrame -31.5 -4.0 -1 %#&#3# 3 3 0 0 0 UIParent 339.2 -356.0 -1 '$(#)#-S.5/#1$3# 3 4 0 0 0 UIParent -0.0 -526.0 -1 ,$-=.-/#0#1#2( 3 5 0 2 2 UIParent -324.2 -374.0 -1 &$*$3# 3 6 0 2 2 UIParent -312.2 -376.0 -1 -#.#/#4& 3 7 0 0 0 UIParent 559.2 -779.0 -1 3# 4 -1 0 4 4 UIParent 0.0 -326.2 -1 # 5 -1 0 3 5 ChatFrame1 29.0 38.1 -1 # 6 0 1 2 2 UIParent -255.0 -10.0 -1 ##$#%#&.(()( 6 1 1 2 2 UIParent -270.0 -155.0 -1 ##$#%#'+(()( 7 -1 0 1 1 UIParent -623.2 -2.0 -1 # 8 -1 0 6 6 UIParent 35.0 50.0 -1 #'$A%$&7 9 -1 1 7 7 UIParent 0.0 45.0 -1 # 10 -1 1 0 0 UIParent 16.0 -116.0 -1 # 11 -1 0 5 5 UIParent -272.2 -380.9 -1 # 12 -1 1 2 2 UIParent -110.0 -275.0 -1 #K$# 13 -1 1 8 8 MicroButtonAndBagsBar 0.0 0.0 -1 ##$#%)&- 14 -1 1 2 2 MicroButtonAndBagsBar 0.0 10.0 -1 ##$#%( 15 0 0 0 0 UIParent 584.7 -2.5 -1 # 15 1 0 0 6 MainStatusTrackingBarContainer 0.0 -4.0 -1 # 16 -1 1 5 5 UIParent 0.0 0.0 -1 #( 17 -1 1 1 1 UIParent 0.0 -100.0 -1 ## 18 -1 1 5 5 UIParent 0.0 0.0 -1 #- 19 -1 0 0 6 EncounterBar 0.0 -4.0 -1 ##"

local detailsprofile =
"T33AZrXvwc(RzJ1U3bn57heX8bjKeMWIsSuI2thbHsLvvPKQH61KzwiRE7wb2g3dTbp2EwOTCBWRC02n2ZWeRmg7gIbV9)hQs)h2Z5CFK3mRSQSadXUFy80dsQQ7JZ9CpVVNZ9UP(MBSz9bX93UDNi8xt2T)EbHXr9cdI73jkODZ(92SXM1hMefehf2jTD3OwdsWpkgA52HTG20d6zn9nRd)snJnRPTGXMPWqLcDOBuCameB3EhC03omjf(GHdAfMgrdY)4W2nVsqRO0OMPTztvCusuAqYGOMbndBUBe(z96he2jkoL6tR2jHnayR7(P72UzqRH92jkdkd71UBiowbHnBg1zZLqyP3qaqA3mStqY(ai0fHt2AcxUIEKangM(b9Jtd2fwSbDA37kS1Au3(xLHb6gSDC)Ub9GLg28UTHEpSBa81XHD6al2Unctdq8eGt02SE0vJ6b)DCyZRefJiba3cqFlCy3Up8vn73PFmddI)pd6FnP)1c)3u(UstawBb4YuyJjyWv7IdaaGr5gaTf057bSbH(Pf(ttCGOjmz3Ww93BZ61wV2kIpQ9VMdU0FUDyZOnRVAC7F9bB9FFyyR4W0Wd2AJn4t4UrT3z3uO9oLdAdqeZ2XigsqsL2oTdHVaQcyW2S(AR)wBwVbGuAf3FqXLGVHCvq)Qz2VYwlEo(4YPtFaPsysbizQbRH9A3kDxyaS1OgHGCA0BNomgwulhLg2UtYbBvpcOYBNU)M17pG28deqCk2lozqA)G92T)M1rI7K0WEnJscsI2PlSNMeWNEyv1Stuiqx3BN4(dhW(iK6cOeGLn(H9AbDlgOrcgegd)gcZdsccB0io6QTjQpCzwFV(XDAjiIANG0nj7sK2epdYwad)Qw2AMEEUM(A6U(MgUBU9PSbk6g97FLUHXxHwUInvGXmJNG6Faq0cd8vbUdazAzpj)b8JUn63jb66W0(iJBlXCJ7eqpAffMUlGE6dIegaFfmRiyUx7EaTvYmfmKHjb04WGMDqraaIU)GiIlwYkri1Er71Cx4pJaUCeVICwbP7piI4HbKsi1WEdha7h70Fykoeztbi5Ot7gmWc)gAhQDVDc2TpqEdKSWAENWbaWjLdgKaOMGb9jXbTI2oCyN0Gg7asGgSBiUkGLpTVGs2Ac7k9G)FsWuuV9dsA2pgKnfLKeUtuo5vOaX0M7YKFGyUgHXmHlm5QbGGvOJPVWIjyYTfDCPkz39aXx5KHgOmPjHDhGan1uto)mqeNMcyVKkySh0hOW2S(gRFb4laYQiImGZxs8O7VzTtPJcCEBc1xUKagvdJ)NZ6BOW3VugFVrM4TPl8I4k6V92WIGPaGXtbGkWAg2HjLSCXbf4GaqYu8HasbK)1PdH0aQUwHXaZ(vA3tDVhHyH8HGgdttrTnW33fuSeVFamvBwZXIORGg2gzb7eHmOOCIRoiimjG6lrsYhtgrn7ZzeA54jfyBBsQECtq1iOJ9QGips7KqoTICTHdgakFfcDWTLMDcH)gnca(6Uax4M1phITqC8LxSvR17LCzUe1ld4cGG)YuxIKnxGn5CGBOqpKwIGPW3wiycWVd6eUpiXSfBckBiQt456R05Qx6CiruCMG(6xzFuYVISC8pt2SMTcDcrhJsHskLIjLj)lizVWbOeQw7dQ9b2fUekeNlfhfaYt2PDpKmYqiheKmbCrCQ5t5PqoZvLDkDls)UqJsyxqvbsCAxumiF3c)agAjbntJtuuMqZg9tibymm05rZuc70ojTDtwJJBZeP3Pt7wjQwYKZcgaoAgoaXOKXpi6cTmIgySVnbl6yDoPjklMGXHX0pJ6ffVZ(efBisBWmftkasb3JwEaFfiNhM3WgbrDBa8y5fcUVKZffAO(hypiZXaT0jGWjjRb0T0mXRO01Wo7fUFcZaxHbJzCVn70FiO8LTEZGBaKUseiBeqAO0YE7qC6uVesdGDCaLl4ijzMBKjCs32lt4hBPY57t3fy42TFNwe9oW)2c0HfqMmcyftJC6FyIgbHuA(w6e0Iq)UTJ60kHb(iZAZ(9JBr4234s12yLlMxw6c6aPf3Ek83yYuTrq6Tw8Ix8CRp12ZBRoRXxyX1wC5ZvBQdUCSnDP2F(fp7kz23HFlZEalpnlhp3YNJv2O6UqtaRBuNw(Ix6Cll7MPRUMp1cQVwaIZsZP8L05xV2Bk7OC6mD8v7YelSLxzXnEJ3S25o7BukWoTUDPAN9IRFPlCH1w8xLTfPmRtB5DX1p7LYqKk4cJ8l3jxExQ2Bwdunp)t1fU45wP(gZ5Cnb1eGnRplQVct2IGyiul0uNondF4VS8kV7aT7ARFM3Co33NayxEfaCZZUi24n5dX02iFdGBlAEN3cqD93yXZVyT5GgVi8UYVC93ububNb8zZc17PqFVsTvo)VAo3psZKMaYCkrAYcoU8HWZKpcwLjfzbxpbuj8JZYCY1UaFzXBJN7ecnSeUekib8jvNlEXvQTyWVAL1wtsCRADSaJvo)MLyEfGwrji6YnsEl0SkkQi3Kz7pnzcUUsuUaWmlrq6c(occoXoJRz268SxCLvYARJNJKzumQ(AtiNqSiWH2KJklrGG0fno4nHmG8EDucxNTyV2wGpCj8bO4mHCWvVaviShQR7QAL)cA6iyk8OPmgthlzSbYnlQQlmlSXs4KARCPnU4IRvgvsjmvc8HTRJK8W3JiDxzTvLnZdCb3xSlyOBlWXSpN4Ke2RdMNb)kA9wsMbkCpjjZmzrzc)WgX9dB1KfTmfBGs7JURMpObgQMpIJcyhycZ4yMTG7ehoa8XJ8wQFk4Dkywgyml4C32PKvkGHGmlLkAnEkyr7orXclYTZSMN5htuR2KXFfmFfTugDHgn8HBwziAeCDWBzYx)9i7863QpbLXHTAt2a6OjbgrVUa4e(QwogAwGGvpBtGAbKJS9PSS4EZbo2aGmz9e93SadONpmdcRQrOj8TNMvAw2zHocK)sYarPFbn2Nhr00iWnTLW1rN9rdYrxe3Pux8zE4nrarWOtWIic(BkHejV17zXXycR6t7hVZUCBULO9bWgxZGU9zOov7DrLtWcimojxuryabS2dOWCSbgGvapsM3V)MREkxDldnthndnF4NgACm(BV5Qo(EUAMAGckBBllGvf(gmSvBUQNUTLVTMTgG78Saf1W3aiCmoC6gGCtllttBFUwZeaXYMmK(9TzrhGhzaShAAmwhkedaqNomHhSekKrChsPqtaSAgOByPDIq))WE0t2qy1URmCcgI4jaEj0IcFemdGD1XmvUymog2Ptdgotm42mAsCRd85G7CezTnJ2G7k)mJldpwpeyhqrAVsVOv7ssGHmio4wzqc6nBR2X8yMJipkY3i3p4J3o9c6cUm0oaD1cOiP41SeUzVxycfLnwSts2RnsRI0xyS(b)87PU(qwvW)K(d3zxr0QiOzIVmgOVzUcZ3dMvWwbOJIpgACbUxjy4Nayc3gf(Tx7b0xtOUwrjaLa4DopcvSUWCsJioyKlWikO4fS6Y4feMc4dytJDYgIDz(ES4WoeiFgzIorKSdtLngLvfsqzib9nOw1GzXHNNseTMeBCwkGWCsifZ)0fwWHI5KM(b25WmmZNiMyuJ4ovpCKLSYkQjA3d14s4TRg2zifzFKHcg85SHMZBdTM3gApVn0zEBO782qV5TH(ZBdbF4N3wo37n6Z9MJ(CV7Op3Bp6Z7(dpcoCXkeXTPqmBntVCChtpK1PCjz0SiyNljqvDB3mUFG0QjHCBae60P)EyOyYd1ix7mNvYiHz1c(bxMPeptkaxEdg)lM4MIicdjIWLIE5WDAZSvAVcsRl2XGoT72ol00NIoiUmDrZoM406cMdWgLqHYlHsqESGjn8GDJT70oTngdut8Vb9aD5)fAvlPLDPW46GPBuW3AgHkPqJW3yXZTw9G6BS4gxQ(slEXGlS2Lo75QfCgY6)6XK9ttVzxy5luxA6ioWZUL8a1FMQpVdSz)9NVFlwuaH)yvk0)l2SjSLHNSZbBDH4iC)RxZ9zTyru9O0CX6P73Hrqr)L8qqX)6xrdm3lKPbV1x5SNFLAB8CaZCJ22qCawZhyNBvYxd6VCwdNH7c3ZdsFEbyNCaSXeamyL6gCd2Nj0Jh5d6TYCStKM3kobJqEBfYBPJWSybdFoJgpLHlhpO6iR5K8WwsMFn0uRSJMMzikzOqEHvGBerm3KeMfjnuhfFc8UmNnySHmiiNHxzorYxEWY4kf(Z8l1cIjYSXn342UhRhOFomdht6rEWXSxwA0JJWUjXui)kM08GMdHvrxmU8Kfpr4jBtUFQGfYoDwMZhwGtcAo6owEoog2gOFeoUIJjKFUIlT(gBS(5VifGLCNNK0vbaM2M8WqcSMUk)hZZkqNcBxEvhnWdtFW9ftWluhBB880PWmmTVXCAFtkxASeaqAJlIUpqNgvd6CtAoNEbqnLPlL7GgnCRPoC4CXuCqYwbh7jmftOm(BeNdDgR9tXDdw0oYbw8dRBjXht2rthNdHEwcXelHl6gIUUgFlKVftCaKkX2Vng4GQ0YkwgkhId2L9l8b4XoH2rZZGcLqsYpSvWpiMFcKP7lPCYECm8Qix6Lb)jnwyJnwftKbslCM1)5v6kpoz9md4jvHZNCX8M5d6sxIy0oylJCm(8JF3i3XHXYud0j(o0g5WbdG1f93GYz8S2sU8IGa3LIPt5f((O4Zghf1BHZBGNi(EzT(TWKi5YR83FHfRv)CRxtZ4YlV(6lV4Y1VmiFVvyCC4LpZ6RT8Ix8Ilcc)Vu9f6AiMp1CCGnMQSQ0hiBIUOtznrUZQswu))bskP)Bx4GTOFZ83s)W43wGAMrfopw7W6wACyVeWIgjXNGKHp5f5XYAW8X9HIr2DF8a95(FMJErRuONorDSTGdUxbf8XLZuidNebd2vebtMlEzjXHm57kHiLo0sPKb5moFlQchpp1ZDIbJRjPOnesakN7M9DnOCzda1xRikhxW89F1tpiNCbQ1tDlwU5sIG6nSBdq13ssX46LjxqHLB5)RTBMoS7bB9AXrK)lVUaOlJGeAgNs8VrsA(F51lJv(n4KbjdcPZOQuXRrP7bSJCs08lyvHyZI8EvBlDdBBBthxtptntm(A22IieI0rtcB81CPsmNBcDRaoclBy2fwIDyM2NnaRg3oQxRKvXCJ5Yx6CNI)3Rb(RDQ3iRdCCEbIGs05mpC796lJmdrUYzgY3N0PN7Qkzf0SmzLimvHyGSdKU1KsFtHvQygSgmiHNcRzlQKObHXGftXI8SIagvTnSSFa1wZGtrS2jJuG)a0vfcoAQ4NKWz0S0QkV5BZbQtjiObTqtH5QWyNB0Pih)aU)gyaLqlhAmHfDYvEoVFZBvjf4XMdJbuplzqKHaOO9dlHG2sy0Gwc9oOHGJcmZgrzHYK2OGJ)zj8vwa84r)QUs(UjhH6sN2vZesyoYlgaZAKFRmr2WCvMLziljoDHzs0O2nkVsK9BEYvpvNm05NePHKmMgwws0uMGyLPUXomkR87BuEJ1pPDZW())XH3xjGUuUGkjMOfd9jBWLW2qiZLip2deDmiCWezkzoR6NHLAusYu2j4Yd1QRYwuDsrj3YWv90mS1m880D9SCmyyihegPJiZqXHdBXPjTQLVRNTVUNRURVTHMfdFNkopp8KnMWZW9X9szk)rcquedFUZSET6x(C1(LbGNJT7eSbMnRDNLDQe(wgHE1m4McexjbPcnZO0ZrOyC(lyBZKhKmdN6rWqQsHdu5XHTDNWDyajtWmA1JsgovZXqjFw09Tn1ljTwkK8e10TCCZoY6I5mXcIg7WATJPsYDyxizqko0ygNppPpf0q9zKTqfBRXmYAN8TfwBEzhuUS1UtzXzyNT6ePAJE5WG18MhzqBTNvMqvS5ooph5nfm4ZAVBYwRGnmn80NeJmzx8Nf8iZsgpEZDM6o(eT121DwPFvX9gfI7saK85RtnBp9zqNoXqBnJgxyKnCSNbgFIg7mlYVjADgcrcgEtV1ZK0EcYqh)PrBpzBD1MfGuS5kTE6IDksyPRzmDKEEUnx9Pc5fWj6AMtFZPWGAmvc1cKh6AwZarxuGJR5SqDfgALgxcn9eKPMZF6kcqT9maKcIZC0NZeHdKh4mdELIBYz8kvLrS1u4bNKTQafxklXVblc63tKCZmpee52EsZDJ6YDqo7mFeLcaM1lkN(J3KhugawYmpZuMOyM8CXsKqEQJ3amGJKbpfthjWfb09KPyjmEo2It3oZMmfV5faeLLZ8K)K(vZSFvAqrHalZkpIR2oPF88yeozyJ0NbUFsjnXOQXtmgS12AU8a2CktBEUKXxJzPMsXmptKvKMsGfC6PbZPNAU8y0HN5w0bBvhlzib8WYReMTU5XBUfrA5lgp387pPHX7i2IYY1bGO4TyT9nOFinZnioQdSfE1iwiK5FkgcdwwAXCALLivOdidBqE5Lziop4Ru4QyffeDqoG7iDd71ItTITy61NZ87xlVLZmMRM8QlatDEzdZmHU(fwzT1wA91FZltbxflDUtDHWDIoLUY(WCq(ipYQChQIUfLRzT7IOJUrP7YoklbYEAHWG)18J5GhW(SLrMLV6BUQTTNMLTHPNHMNHPLv2zw4zAaATnaV4809Dmr)7Sj6XvDDCT0nT0DDnTD09nzHxIc8KgykJURLTVMHPPRV40my0oz4BHNt1VilTx0rrS1xJynDjdSQVH6FSKsZsZTuuf(4vi3E9uQ2R0If20SsVirI4XkI4S0WJQtWgX9VcNQbJujfh1OoBNDIczPmOyCiNLKX1QrwnAqNypZ3eg0HFyw2s3kQXWT3g8bFy8ameCS)kPDNRINO(2uuZ6S)2TXLrRW4R0poeRVrwX1uFhuceY70Vdf1M67hH57GSqAaP(TyyMD60Vr4YStQHdiGpCS0TmxGrW4oXZxqzae60E7OaEiUyzoi4glDsOSI)HjEiHkotkRsdYkQxzgvHrzGhhRugRjVIX4vVn04XFXxp6lV7bBn6EpD8V7wN8opaKfQBRJjTC9X3)AJp8Rh9WNo6p)0d2A8tE04V4JH2jAbWxn(U)Wj35Bh)Whn(EhcJXXFR47awSN9WF6zF)1p5oho6dUn07h(Vdd3ZE8XWVcd7h8vWWn6RFSO9oiK8bN8f3c(6B(vN8PhcJP47iItGGigl62bHPXy1qIfehOCLLShrV9aFT0iQCUamDNO0i(XjhSXzwFjwqyA3Tl7iIj1Jyu1WqHqvSfdRJfRJOQRKiOm147TBesrC2lDU1wwD0gcu3K3VTd7Kf2Fkujy(8HzgQAofZQt9K971KxjYXNHIFe7yKyZibeby5RUdwjsDWkYhMdKuGcRn7VJ61ef5JY1O2paijPcRpbZyxxqeIUTbk9tSMyhKDl2CWXp8ALscUkLzFMww9SJzhT1HhUXS7oGmkU8vSojubu1HyCfJCOm0Kvf1TciUKoGYxp8OFZqRcmkIE5v7lWbHCYiFy7E70cT3Qly3flUG1SWiyfhcdj)0rNkI8FCyu8(SZSMk47aL8FHvyCuveUDhE8kzug4hrIaAif7vc0qybrj7MbiSyKWQTtSebjtP8vQDJvbpq999STCSq58A4rwBANvZg1maxK9wW0Ytuab1SC88TbJUC4vJrnGxr31CbtOZIQda0QybQG0S8C8aTn0jHJzcMAzqut3aM1fCPbcREIvDXiH5Pb9aMpqJdVtIAkOMVoakwyjWPweaRA56HlcnBhlqbi81q3CLLtYQ2ogGImqvMTRLRdL9aMoIA6yvyrR7OB5Rd6fnyLnpoN8m)FvhO3U6EEgwMEWsMIlQwwjASQTfaPaQZYdSG1M04AYZX)b42ofgVCvZTsm9YvlHYO)wNrJ82kPLSRArlsJcVoy5wQUu5FRYuvANLHaphGK9X5600m(rnJZuB)Z36zAWYmxFZbiLB0EExc8PPYvs(AcDkiD5sbDAce7f3Mf99H9OcbNBxcoYDdbPl7g1zG8d1n19ZY0PZvB11d24sBS(fp3IRPZok0iqWjPjMl7SbU8AWYpdyX1qXvJu1lfcbGaq76)YvU4IRT2YlUXIbalxTZv7SesQ(5XucB9ZV0IBeSX5o)k4eYZ6ja10d0f0KLW0ntJ7WV6gyfIQ6O)wNR2YR)wbiJCWLQH)GG8sxtgmRNXAEOxcF1lofK9cJ7H3vdTBPNvA04H4qh1uaOsoGegl1sriedxt2zobS70pDmPZBYW1ZH936w8VNowkdGHN99G8c6ZbVDz9ZN9tx2F7AY)PgRDGug2w8u0Lsj3vMU0Y0(NPl1XfS)2ZY3Nx37I0DHmfBj5G0BqtOVtvn8vI2hu03BUSuJDis4rqSB7uoznE8QW(9vAZVpdWCbTGTd10v5QQ)S)YthF0NCWwp77)HN9WVLsnUspNI9a)gcOYNRMisu0jfuhn47J(mWMS39bZAaEROWba0TeaZAUICuNZtdJYjF2HGXGNC7NEYDE0bB9AJE3pdSkeg0F8BHb91lDuPvuW5d3PDZGvrvTrXRIN1dpT25E6n5yFYHp(K79LGPO)4nE2XxR8XErYqK9dQd293hjme5apfqHsh1B)uWi5zbPlg3me2zppyM35PsdBFr(YJdQtPd6ND7XF6tF9PVRmeTfAvKWAvWxK6dAh3ovKC94O6w2Oo(p(TJVZTN9c)I7UFF4x2n4x2Vda29fjIpoOELUJ9rV)4R)DZEqpdM7t4joDH(TtaIbndrA7tecGni2m0WVzdDtpWhxZtRBH)pn4)J9B6Nw3G(NFt6bBXqpKFfGpkJV59yE4Z6Qmr)zJTUfl6FWyB5aTWqF2J9OF86J)X7kDn54FcMUBDRt(NFmnh8HqwIaS5aeyzYNddW3hn3zpfJ)0Rp6X3A0rFm6QZ)XdyRJV84ND87m6DVl6KZdGvfJbHgnzzgqCVGjBUmw4Xh(oNCi6919EeWjwyhyXwGzNtKYiKdEHyYj0bLRTDQSWeyRe8UjkdBzdg)vXs5g3D8no8K7GEj(Jx7KB9nSfZF84XV37iqy4OiRQb5gU3l3nCBLX23vDdxZRILWrxF8D)gXg(O)03m6jxNn8GrNgwSGul4wnDDTSTZ2RTm1Qy0)dayFlGBb(1)0pb)6Op8FtS1cDEtweafWo4NILaVOzaM6xXO)SV)Ot(dFnm0FakeN5O9F92OiP)8dyZcOEXL4209uXqAcmeMVa2wvG9)O)9t(x(Wt(OhaiEqQpBB4Ex7KdVlBlMng0Ki4PnaR19e4jBqpNBf7cJo(2J(IBbunJFio634FB0hDl(UGHVThlM(cUAxxBtUW4BZOkg99pceVp6()(5NlOrN(9BXvUVjl3rLiiDtbS7yR5ywbtWZE0NWcEXF4rJ(ZWpp5pElGJGGRt(JVhOUHwiSrIMjJmPt(oUzB4AM(6vsSo6Rre0r3fMnAkGPE8nosGRWHyt2fRKKN2ZwvcOPFfB3JF0nWW9C4Da067)4rFXHsEd(wcFuOPjJN2ft7nf(o9QeD8KhHcUU3pr)YHKE5tEVRXe7(f)vbAZYrZ32GDKoI5YhO3mvMlB3kMRr3(2GmPrF9Jg9UhYqAhF9tEpKygPKFSqCRTUfWZZoPPmcznBdPSkhTkz4bz6)0ThD8Dh9)Krcm6g3GlTYgCaMDSLsKMPVPGHh(DF9kg8r3)Rbj9Y9JhWfjMPWGni0Ki43bsmFwX6xhKw)SF4JfSWJEYNZSFbuK)6Cq0rd8(M6UI2zld1nw7kPr)8pgj))ue3E8deIpyiyxWnFchyk1q77IH47vjHJPUQ0BD5Czz675xXCD8pbAMh9XG(Tto8jWY6z)Wd4Jo1BA4nYOvWuKIl0Z022Vc1AJ)X7a2oXeuCZJh9o3sOzWMUQhWlRm2i77PzW15)E3B0)67p6iqOpSvc2Ij7Ihr4AAPOlpttLUMPxvMLaw(a87KUCaQatrE2tEVtU(J537v0aqZGTk20xLYWXUIz4wxdS8MTND)BbKVW6(3D0jV)DfmiECIdb3NLMNJNHCkadjmRAddSX9gFZZE4Xm6U376S11XhZSC4jhY39OHIMRmMrpFlHvjaTJNEfYjh9)54XF53XWxKwECl5buWPrX9G6BxgcZtUAC9D0LYsSmnDR2ShG(4oaH9j37Jh9NV(4RFpPsrUzOMzmQwgz61Xb3Ts1wJ(c(UXV7AJV5rOdsVh32htyhNgFlnj0dK3c8dSzdIUQqqaWuo(WVcL6sSMG2Xp5iM03)YJh9N)Ny7e(yED5rZKE2UUNUuLLNbMyJvAheqBXCT7NEpHAXrFYx)3GB7F8O)0deY3mORXMAwzQGTmnSFPH1aUqw9vNP(v31jtMGNMLrfuvF0Tg)Php67HP4rmYzC7F09)QrFZJbvkOy7Rp6dyKXSXJMpRSDjtnhPbQ2oAovXX8Pho6OBm6Bpeebn(ZbK4j39raYeMzyU(x)gWGyUigASOjlZyBFVm)fS18TmQA1rMxdt67DJrVZtP5y8DU1Z(p(WX3Nl1guryXc3GvMuadBpP(EIGPkLWhHedx)gio7l5QHF0VhyNuO5y7tUk4ndRxb4nvcCPj4GIjwABuF8to6K79jmvaFb8pVw)EhS1(9hgFWw4zC(6ZL9SrnWkxHoQtCAeseS09SneMxAa6uQsZk4c34RF3X3hfA()gT8JXj9Dhp(pYvdqdcftePyb8WNZmqYhdiwfCqGkGF3hY2ua8eml38Up77fCq0aqZGU6m49QyguuCBAzOkeOkFgVZ7p6F9NygFDhuUFgbm5VIpl5(mLJVni7pZismYMvPg7yWfoYgQND8)eD2Np77)bWfmHCmDMfcY870h8ZlJ811Ok9KJ(ORdcgj3wE2d5EAzR5z5tIhLPcQbynMR0Ijyvy5vnj09EmAe43acWo5DEaWJaMeFYh8yUBJ3cWDi))7atpNJhhvAwLgD7ayqZmfL2wMvzx8nqtcV5xHwFZmj8AJp6DeQYaPuSe5uUQWGOKz5IFL6xaFS(d44p6M3GPm7o3wW2o(UhbBvJ((pjZTE2wJxg9RT0kFFdWL8QIpeqTE81P9OrFcFs(GNGlPBWK7ZgeAsuC4w3rikwxhRtaJQzsUjQp5JU54NG23(r)EWNVX)4Tfyntl2f7HMcxITMCxX21Rs5jV7HJEWJyUNWD546NCZRrojp6VElrqk4Jfnz6zSmy2Dki8CDSRIJjx6gm(Ep9zF)3bZYdVX47JKJp8ZGv2ONkCnW0WJ0XitwxqZLRld)P4oHWZ(xZ6cZNK4ewbF2yi7aq2ooQ3VgV3EJITw4FyWo5YmDldlHbvSGo(8pprXdPJNUWmingWW2vtW9cIUbUQQc1ZTFk6yfHcp8Rg)PpLC9H5zqrFnv0SjZFslytZmtsNPrvuHJo8bi3ZxJUc8bW)m67UwU4hYgJCjCULbi(txLoSYaUsEfEYHIiicoL(lge3V5ViJ8J5BJmXMTm099Tu9u0VstqpMhjQFaytzt01pc8XjZDrwitKPdnnhoVAMd)mYAllbUc0l567vDef)D)WOJ)Cg9pzx94JUZOJEcpUjxB89VgtienA5YRAy3hJPjFfzG)vvEe(V8vcbcJFYth9Um)da7PhDVJGnP4OuGtITnzc2rByKlpRbhEmCnuIg786NagZ6dFSmwMFX)mEiw)f4lETFbEQP)Ixxg7AMmq3mXeooYzeCXxxRkc8tUdZqeqx(OV92J(IRtgXJu4hDh0MXdb2jyEXPTew)1NkRp7SlBfpSDRGgrHX7oCNGgDcBEL92TDAKquGBMWgBDpPICFBBFd75r)agjWp7qa9GHO9UN87(oehf2psGIaJgybzXntOJvML02G3p(2ovg7xmuo)EyoovMFIkYyiEtxB1DD9xE76s92geVJBMCghW)MFUYzq75hMenHOg3mrn4DMHmiWwanvLXk)7g)PC9ChDhHrbaQgSlKm0X1tbvzRio21YVsdPg91pMzoBrgEw)PXxr8cS)i3RDCR0qTh(nGdzJo6Jr3Y(GVI2Wp59U74)WNij04lgCSOdFmt4In4H5RyrzE6k8l2cQyhlhhpZQJT1d)wYV9dfbvgTa6ZGFvS3J1KdojQstSCFfinPBys6ZL0KoTrzjH7aMsGLTPq8HNITk(o2VeeFuqQHxMudWcptjLKLMxvN6Y4p)Jz2VMfZNXF5XJV)hldLVh74w8SvMdhRxnZHJQccNxbBPnJB)8TLIzinDJQq1KGCh1vr0GrMvuO1Vv5zhM2eWwP8SfnDn1jxD8uL3yLDu(gvkkB89(eKXenYC8r3D01)ky8rFF)tFdjDamhnlCKmguFLPYX4LMOndpgbPVI4gDPpIGUtFWjKQK(FB2zead9F9gSd0hmQHz8c4oJdDfpxZpteJHPmVbEzyTeEpqTxrJL8Ze2a(YRNPxgCPQQuHaC2fCF7tz6lp5F5A4roE)Rjo7Prh95akeCxqO(bhrAknvuTzQ)sv1MFMadxdP6aa5A66vvuH(R899hEmgDi8S)qZnU71br3SO4FJ7IcRilSF4raMMn5SXMMCzyr0PpsnGovHl)WBp6)1pDYHxJfDTV)6JEYNZ5IC0DisBFvziYtI4LPmKFbQxGB5MTjWbr5SxnFPmbtqhLXR4mzX3t98J8EzE(rgggSi947RSIS8FLSIqzMmYc8g2mBj5O)Y9iX05ZrU0tW8vWCKYl3g8U7nbtstmne9X0ju3I(xt6FnO)vN(xnwEukt49jEM54pvtIecftks6odGk9Go4nOE3OaW84wYIBje8JzqCuR2nXBxcUxoSYNHUG1JcVcwBn8VjnSbcLnW0ZLxPdHTAHxWO4Tgo7PUbFSWAJ3EDYhBo8g7sPlIphVV6u(4SABmFrpPjFBleL9PMT6RC1GDdtIYM12jz3ckkJo90RvrXoYVqlOELnG8BNcxW5epqhOMRJNLJMh)2aHgDS8NuUoHYDDhxaPiU50X0TNxqg83PiMDeqds3nibFeXeVDItGwPAQCol(UcyhX9ZHfyqPNoOr33uZ103GFpLuO1kLg1oy1y0UzrWirwcM17XZKw6Q1wCtuQmc8vUUpRe(y5PC1TN96eoaV0LGjV1ZtpOc2AEBpD3HuDJjT81JXBqYQBSj)cCPaAvmu(ALS)qy1Nd85RC0j7oyz(rNwwVQrNQcnOkUSQxdpwvztv6BPOAz9evnmqNJ58U3WUbFEb2C()5uUgCuDpmNNhWEOzrPtn2pG9EBWUaRefu28k7AcHZLizc8SWZx3uZ210s3Ys8mwuy3RCX85vi6nz34cZD0bhNS10W)X2uojtOVqqspb0Qo9tiAKejk7l4ZH6aNx5M4YeqCvciUiby3MDtapOk7zRsiRqRZUKxN21Q3cz3K(YBubAENyfj0bAB5Qz5JNiGJlsCZ1bkNPskG8PFPrMWF6bv6VuZPBjaHkoFsM5zQxBkBrz3wva5GMJUURj4gNRbFDXi(Rs9CjSi0x1OKPDouOQk6xP554xNM4LkAFjY(N3EieinxTxiqQkWpNaPkASq2F5u(YlK2Pr3Rsyv6q8IPhiSrs)y(JWyPDOrgQX(fr2okSn8Q7mpJpR9XTtRAoY6dDAlyjBhoxwcqUTmh2oueOWdnDg6lvGhBXAozUH(5vvmvuepVQIzIzMBLR72(5aW)5O2w8MdmL9OYuDKD34wQSh(J7Kh7QeLQEUC1OEXcnKU2p5pe0GepSeX3K)sWghkEh3ZkVUCfvhRy7srqVWlDBAENIYxO6YR5YCZNOQblVU7TXaZPnrPhsfSNaaMOc8va2CxB6zEdtiqMCIc3m1t8iudEbkUqFeV9CIhQMjEnMxELvx8sRjguXTxo)QsDApBVDW7A1M7IxmgymbyGIbMfoi9H4Ej4FO)W4EHDuVmfGFPjysr6WuOb83Rv2Zx90nyOQhFhpzDEdBFIlCdrfXYEcPXCOiPWn54E7c7Tibn9622RhDzEV4VcvUYUesKxCYPkd3a82ryIXsCd92qDSW3IobUQv4(Bw3Wx(il1dVt)d3HEfbA2sq7o5t3TOEAf33i8Bic2J8gVqJxIDDdLG3xiiUBy3ESs4gPAKCdTI2oQxs7RgDkSUCPRYs(hWU7ueFlx8tUpdf)2VhRaIhMsf8hRaMLL6CXHNGsSaQz)MCQyu(fNScFQC6OpxmHQLgR4gBOHaH2QigszZr12CeG7gP8equOB0OJkAAlVsi434NjSlXv2TqJ8PMt5ManZUbDK7hKsXR65zH6x6ff1NkVenagq2Z1mkdBNOUurgNeOJXIn71ckqgapbmaczAgeDv6E3r(kqpzZ5x4N0DzbExRW6a15SEXMC0qG2W3qxkgjLo5Dh0zyIY4q4BLNfpYoB6HwFxMmew6vXO2e3xcGXwSxOA6fYNFBBayJb4n)sRLxLDCiSGqBZEJa4FhvS1aFFkiqw(8C1V3g8c5MaZe2D4bwyWO4CDnFxScUQhU92TFBMBoXdzDPgEGP89b6dwfCrX3dd6UNJfwZ4SBP3u5nkRSBuGy62MpokpDv)SGvtx8Cxlhw11WB(kfGTMRNXc(A(taEylXuGjp8r1(NV8Il55fo1YbN62U4lXwzWPl(KCRItTTbFK8nnnaCQTMNE54uOBU(wtcZwSRmrVxiClb07tLAx9UG(rm2xtb7A5yc)p8(GkmgDkWysqu2gjmk(eX762ZlaAQGu9S11WeQOCWZ0XVawvZ003xZZcSs1hixrSQXKGm0pBmk)frRMmsbJcqTX8a1gkqn(gUA7LHu9v5UqJBujy90DxGNy3gLp02QielBQkplfH4zveF45P75z7zcww4BsxpnLqLHv6HTPzrwxN5EZRHcAqfy9rZC8nlfpaBTfzjGpXfVwjCWso1WAkBEqRCqC7K8eAVWBEA5i5S0TMQ8gDZcqThEjAObI(Sa5FESq5yoJntv6e85igiwlh)yQPxyMCD9SDb9WwyfAz7u(MPbwFFELkZqVm8ZZTCoxBqtGL30KhRzKhQbH3yaHWe)3ZfVjGlNee6Ngk8CsOMu8z9ZvqcOsWG45ldvJhiFEuTLTVbgdlpdnn(TpFjan0pl82GAsG28fx8mx6SRu4S(0OfXRnk8cRAMsN5Trr6m7t(5PBE(aqddt3QuFiAtgaY)K0jPvDEE31XsP1uHbRaTQNzXTDG9wZbVrkD8DZexop8YEwMwEo6tdt4vGzgJnpMxD(ggwGSdBHWoMkZzBreOu0rZBQCG(wfwvAaHQRMNJHNn(EaixvwLpv(QtfE3M5pTvLTXeRklxnq7VTPURhiRuUQSNd5UGjuotBv5Jp6b5eROzdBqGMqt8sMlZMuMwRzptGkyqZKx5Yc0kUtbgkByaY4bAsBqfQ2uSuttdmOUm1sSQAW9LdR2uTeYsZhSjmJtZQeRE4TjJtJ)jCzw2VWUwOn)IeWxVo8i7NLibrBYau(NuIibZNBBZCSPNy)5sraE3KRVGhlBbnMdDJa7IN5ufh6vGZeSLd8dWwZ3e2k8yQzMLqaJ8MPOHLSYuMk3cMPyH3uIw(g49SGPRVw5gxz6cRbp7Y0O5uMXdopVoZbOEhagMIfp2gfW(aJ6cwZjUhyrHn3PA3MtrRPmnT1qlW80D89YSMAUW9ybw4BnvTEAfX9(4H95OJxcfEMzBZwZXurkXMMSE8TVOGdqAoGwmxnmJ91SDQsaSrEtKSvNQCET4xuQOj4alWC46dM4B6OvL8xvIaFBxBDJP5ZPHFbTYw45qcE2zJRi0RHsjDDnCX7QZIoXy(I4oagtbvEAB86nQCO1ROneOkDWHEFFqVo4GVRChykKWw58ha8F1zAgPQBxu6HpIuaMAG03Xzk(lzcBPU6MtYsBWkRBNF2X9qdCT0Ck4hFZIUdaIa0ilR91XlW1PeljtdWaSsedz(IdZgZVskqKSBvgwlAtMsk(NWcQeVA50(zJD1XlvIPO23xZPqWV81xW2EYGFbnutVySVEX8pjFiVWIgyAahgFXCCgOFRiVKHg4ePMX0cJiOdYVmY1sTJAU4NTMB7Oatk1qBaYzh1m1(mpdRh(E96ntRZaVFbx6vj55D6Lumu1XBWOPSr57xKhfVL)bReCnq3MNgpQVVJ2KYv4pz)X4tIBUdFteA7amA58a8JaPH3FRMZFRH1bBzODAl7tB4)BwSzA7R2oD)d2ch5tFWwOtnlWRQHsA)zJspdd70UFVZ1B7(V2RFWwRIh72Ft2qG6vWnOs6)5Xi9xNFD1VEVv616GTOx73i4x(nhSvt8EGSDVDoyR0DJoyl(PhG30fuxoyRWu(xfHDT)28)cqXlquFLnNeYyzwC(xTDV2j7g1cHBy(yN8aDZ2NghMS7bB93bJy8WikwGtmyU)M)o8)oyl2y(Fdw78Xd6i(FKHAt0nh26EdCgotNOWEdhix2lqu1L0LLaGA5OTJcf4MRebBt0Zr3PP)2G(xrbiH3l(3)6NCNhn(EpL9f)PNo(lEFEHsC9r38j0ZdtUjY0)0gAZg28lTlZjSHfe0pWRvJN8iQUgkhWqUK8tJ9P1QaRPRxAFMtqJFxfkU9sUXHtf0kYiy4FARkqA6ML2N5e0E2X4ok)MN7ryTV)HhJfQbwUttbgls4ByEABVFZ69oZUa3teq4F((TIWudj91ED6QWSSMZVCOp)VAJ34CNz5lv7SRSEn894)IBqZBsukYzMaGA3WRejozpgZdEAMeVZ2HDsIMnRf9TTIO382(SJWBN4Wba)e1eDwVjgmGTMDT3JpwPkFl)aZdKpqhfNBvaCVDJ6fG3W(5Ha(tHoLffQZVSbeO3cRZa6zSukcsTn0)i2bzBF)AyMoDjBtYV8CTW2s37o6oLUtSYvHjcA0BT(fxBzClyJvO7S7lQSDmiC)o9dBPFAboH)bgNMdv8)2e(B27cuXjYYxorN5nwCT1wb2Xdo)6lVcBwyN4THJStMNwx)0gwtQZW33Bbnnp6Y9SSomxknmPRHcTshGxTAnWqRv2K(IP2WWOKrZOA9g4zews)MPCgdRs7Z8kD(47IVBl4lPcEpI9KhZ(03)XJ)Rhrvhg7I)E0TUg7WMYntAUYnMPcDoL2N5va9npgHUp7AS6Y8p9nN8opywaOBUjZ402(N22Uca0R0(mVOV7)Krh9aQSaz3FLZc68lotwN20C2qNPwP9zEvI8xEmG(gDZBiuBuoGzQxysSauG(u1CyAuAZ)p1Cuyu(5P6OSTQIApWh6BtZs3nE5R9W0AYjYYOcThM5fzOFAnOFoL5XHL5cUgoA0)zs3TNL1X5Z1dQSaClDaE1QfX0R8j9ftlIPFjJMv1ArS0kTFZuqJLEP9PsbnMp3(FyLx8H2PTDpTPBfqNzP9zoHU52delRItdOVQkeNDP9zobT52delNctJL7PT8Qa0ClTpZjO987bILxX5dfsmv9iw(L28)t9i)C1Jy(86cIidJfPMAq7wS3eamqvHn3Tywph1PzF8zilSxuh(B8MmHUX2lkKirPIVBy8vJsqGFB8LBf(ZuEF4XOs8ANHZlLlqIuLMhDT8ZpnrunlqpU8yo0UD74e6yxQZEJ94V0CYHHWVXrn5VULk1FWK5ADFm9tZERiLVrDSi)1TFR(uGXsg2iimnnUDJHPSxGh2NqFq)aeiZvIZw5kXz8vIHGX2jYhnV2jRjZP4KE0R8iMoXS9B2ZjvF8HQcdSyUjMTfuVx)4USK7F)nx9uU41mUjwgb(Wpnef92BV5Qo(4TWVMHLh(Km4ZplU67HzxLTLVTMn90TXtehaNILZHUXcAw4LEQTp)9ueF7d5VKwg0lPLoogGjRASEOPeHs8LSJysWxiu5EOKElLNyC6(o6A4nwD2wNAYvphjQTmH7Z2yV4INB5CudeXcq)ufLavZbTcI73jkruVfzuZsAzEv)Wl4ojHcleVR34FiQjyZcVIvyBxulxhOBP6Wd5vQVmrHYmOyfyEpyRZ1dFQJBnmeS(4cupe98nJ2NhAyLOex(exFyJnWfi2fCQNCYwSJC8bJ4GUcGzRYhKAuN5ZMCRL)(HXiN38)7"

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
