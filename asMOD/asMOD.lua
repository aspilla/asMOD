local asMOD;
local asMOD_UIScale = 0.75;
local asMOD_CurrVersion = 230706;
local bAction = false;
asMOD_t_position = {};

if not asMOD_position then
    asMOD_position = {}
end


local layout1 = "0 36 0 0 0 4 4 UIParent 0.0 -493.0 -1 ##$$%/&%'%)#+$ 0 1 0 4 4 UIParent 0.0 -459.2 -1 ##$$%/&%'%(#,# 0 2 0 4 4 UIParent 0.0 -425.2 -1 ##$$%/&%'%(#,# 0 3 1 5 5 UIParent -5.0 -77.0 -1 #$$$%/&%'%(#,$ 0 4 1 2 0 MultiBarRight -5.0 0.0 -1 #$$$%/&%'%(#,$ 0 5 0 5 5 UIParent -712.2 -428.6 -1 ##$$%/&#'%(#,# 0 6 0 5 5 UIParent -1152.2 -470.3 -1 ##$&%/&$'%(%,# 0 7 0 8 6 GameTooltipDefaultContainer -4.0 0.0 -1 ##$&%/&$'%(%,# 0 10 0 3 3 UIParent 712.2 -426.4 -1 ##$$&''% 0 11 0 1 1 UIParent -86.7 -934.0 -1 ##$$&%'%,# 0 12 0 3 3 UIParent 712.2 -427.7 -1 ##$$&''% 1 -1 0 7 7 UIParent -0.5 201.5 -1 ##$#%# 2 -1 1 2 2 UIParent 0.0 0.0 -1 ##$#%( 3 0 0 1 1 UIParent -802.0 2.0 -1 $#3# 3 1 0 0 0 UIParent 232.2 0.0 -1 %#3# 3 2 0 3 5 TargetFrame -31.5 -0.3 -1 %#&#3# 3 3 0 0 0 UIParent 339.2 -356.0 -1 '$(#)#-S.3/#1$3# 3 4 0 0 0 UIParent 3.8 -561.0 -1 ,$-1.+/#0#1#2( 3 5 0 2 2 UIParent -339.2 -355.3 -1 &$*$3# 3 6 0 2 2 UIParent -340.2 -360.0 -1 3# 3 7 0 1 7 PlayerFrame -16.8 16.0 -1 3# 4 -1 0 7 7 UIParent -0.5 156.3 -1 # 5 -1 0 8 2 MainMenuBarVehicleLeaveButton 0.0 4.0 -1 # 6 0 0 1 1 UIParent 460.2 -14.0 -1 ##$#%#&.(()( 6 1 1 2 8 BuffFrame -13.0 -15.0 -1 ##$#%#'+(()( 7 -1 0 4 4 UIParent 0.0 -352.9 -1 # 8 -1 0 3 3 UIParent 34.0 -413.5 -1 #'$F%$&D 9 -1 0 5 5 UIParent -1072.2 -424.1 -1 # 10 -1 1 0 0 UIParent 16.0 -116.0 -1 # 11 -1 0 7 7 UIParent 481.4 2.0 -1 # 12 -1 1 2 2 UIParent -110.0 -275.0 -1 #K$# 13 -1 0 5 5 UIParent -2.0 -499.0 -1 ##$#%#&- 14 -1 0 5 5 UIParent -2.0 -459.7 -1 ##$#%( 15 0 0 0 6 SecondaryStatusTrackingBarContainer 0.0 -4.0 -1 # 15 1 0 5 3 BuffFrame -4.0 68.2 -1 # 16 -1 1 5 5 UIParent 0.0 0.0 -1 #("
local layout2 = "0 36 0 0 0 4 4 UIParent 0.0 -493.0 -1 ##$$%/&%'%)#+$ 0 1 0 4 4 UIParent 0.0 -459.2 -1 ##$$%/&%'%(#,# 0 2 0 4 4 UIParent 0.0 -425.2 -1 ##$$%/&%'%(#,# 0 3 1 5 5 UIParent -5.0 -77.0 -1 #$$$%/&%'%(#,$ 0 4 1 2 0 MultiBarRight -5.0 0.0 -1 #$$$%/&%'%(#,$ 0 5 0 5 5 UIParent -712.2 -428.6 -1 ##$$%/&#'%(#,# 0 6 0 5 5 UIParent -1152.2 -470.3 -1 ##$&%/&$'%(%,# 0 7 0 8 6 GameTooltipDefaultContainer -4.0 0.0 -1 ##$&%/&$'%(%,# 0 10 0 3 3 UIParent 712.2 -426.4 -1 ##$$&''% 0 11 0 1 1 UIParent -86.7 -934.0 -1 ##$$&%'%,# 0 12 0 3 3 UIParent 712.2 -427.7 -1 ##$$&''% 1 -1 0 7 7 UIParent -0.5 201.5 -1 ##$#%# 2 -1 1 2 2 UIParent 0.0 0.0 -1 ##$#%( 3 0 0 0 0 UIParent 580.2 -671.0 -1 $#3# 3 1 0 0 0 UIParent 1009.2 -672.4 -1 %#3# 3 2 0 3 5 TargetFrame -31.5 -0.3 -1 %#&#3# 3 3 0 0 0 UIParent 339.2 -356.0 -1 '$(#)#-S.3/#1$3# 3 4 0 0 0 UIParent 3.8 -561.0 -1 ,$-1.+/#0#1#2( 3 5 0 2 2 UIParent -339.2 -355.3 -1 &$*$3# 3 6 0 2 2 UIParent -340.2 -360.0 -1 3# 3 7 0 0 0 UIParent 675.2 -742.7 -1 3# 4 -1 0 7 7 UIParent -0.5 156.3 -1 # 5 -1 0 8 2 MainMenuBarVehicleLeaveButton 0.0 4.0 -1 # 6 0 0 1 1 UIParent 460.2 -14.0 -1 ##$#%#&.(()( 6 1 1 2 8 BuffFrame -13.0 -15.0 -1 ##$#%#'+(()( 7 -1 0 4 4 UIParent 0.0 -352.9 -1 # 8 -1 0 3 3 UIParent 34.0 -413.5 -1 #'$F%$&D 9 -1 0 5 5 UIParent -1072.2 -424.1 -1 # 10 -1 1 0 0 UIParent 16.0 -116.0 -1 # 11 -1 0 7 7 UIParent 481.4 2.0 -1 # 12 -1 1 2 2 UIParent -110.0 -275.0 -1 #K$# 13 -1 0 5 5 UIParent -2.0 -499.0 -1 ##$#%#&- 14 -1 0 5 5 UIParent -2.0 -459.7 -1 ##$#%( 15 0 0 0 6 SecondaryStatusTrackingBarContainer 0.0 -4.0 -1 # 15 1 0 5 3 BuffFrame -4.0 68.2 -1 # 16 -1 1 5 5 UIParent 0.0 0.0 -1 #("
local detailsprofile = "T33AZTX1vc(Bz)WwRDvrm97hm18bqrsjgtbQLGYEtvQyZganj6Ln6gP7gIIEtyP4ipLMynJD2iNr2rYRCL4r2ZQTkpJvCKQ1U2)pcG)h2Z5CF0pqdqyN1vntvBImjq33hN751986E5(Q7V3(DgLMCyyua(XSbjN45Nge77LMef4f2ljE)U73PN)O8XPbEPb(ry7gG)EnO9JcII65NLJFzyywV((5(4N9hNs)oioi9OtXp13FO)rbWNY3Vtkmlh63hg)yy0ARUFh4dT12VTYkA47ZYHjAyqQhm9hgEeoJhctc8GXJGziidHPF(4WEh71pipOxEidmtdYcY9aGQNxp)EdcWNfN45hfKMt9zCwGNFC4qFShE(96fqlJ(Hz(DHL7WtZhe2ZR)44JcOreGf)OiVrr(NgKMHygVJstgpsmw4croEz4qLgmkjn3drqErHXhNXGRHj3IH9g6DyAYqVyy5XWzqVhp0dEDkot9sg21p3lpeEDBvfa0c8Zh4LNKeLhoY7KW(5d2VTUPICMYt8ozqY(DqCywUFCVGmVSGJggeNN5fL074G(4e1lkWhqFXe4ZEeUaGjlpkaFyCFOBPay4nYpf(ec3JGLC3UPb3kKwGWeVFNtssJ6lGZWmV8u)Sb0WrKge7dd)Mogww2w2A22UoQwUw7F4LmHE3nj54H(Ph7LhCBGsf(24YeO)fefQ)EaEbg4BbKhGNWWeiJJb(HWEawn7uGtyi8RHDtIYqwT8eK)OVyUHEOAwhZLbRQJX10jHX9tojBH8Ffysano2RxeYPbi6KrbeFMKAri14Gt6na(AqmXF3bjEE5NokahYoOeb1W4XJa6XrjJZXHOykemFDHHAq4rdIG)JAcHzrrGEaEng(pssmjkj1R7PCP0CqoPmhmsWfuzVUJZZr2YUZGFbkPoIHo0FCuUx3JarKrd8X1VzXyHsH59gWyyr8iaHmUz)iAn2FeIGaXsuafGgOt9XgCysCUhbOmSl(pn6N60pnWFIIw0sq0X14DmBGpqG2Vt7DAVH4rm(ehqEPIeQxPjnZF4ieOPMclUdtbrmGLoppm(OmPYT8qGFNuDbOxqxvNT35Tag9eGFB)o7TZ1HxamzbetHqAtbK2oD)2xsffiVnGLa(y)Eh3pnzuLLPcJhIwMk0YKZpvigoiGOUT10XNZfzG5gK88jEDaYjrJKdpeGDIdIqbh63ly)oBMg(2NDW)5X(9rG)Sd2dwwjJiLpE0cgGKCCKhcACsp1dE0(TTmkZUb6dJc7YKci8g88((PG0)XHeZTG8ZActFxjEiaN2d2BiIZHcSBHO4yuakSwHXoB8OrGgzHkceTjfn8ssdpkmgxZAflbouTxjIqEd6g8VTq3GoQyZhMcCJkyghcIH73zleFIiSB2QF)DIZU56b5(Hrz3me3ck7MuxcKn)WK0EW2cWUi3km)us3R3OBnsYqIJeXaHkdYAKiaqj0dp)m(2dRnRcl2cTIId(KiXym2iyI88gLqZyCs6q2oUNU)MxYw1r3wxXXvt3qvZWb0PAyGCKBA56QQ66yQAORAQbeC4nOUAqpSQMQLQMRLJLPLdPhgvNoy)nT1C1DSvSTm1mmmu5Vb39fyPztjcY3MjkWfdaYOg8BIhJKNaqpFCgxZaPTKtki5qLvC0qQoiZHQ3WEelBiSMhiLD0ecpDYc7tAoHzaumLscr4I5WXrrDts7d7qjgCCHaT2d0Pccm8nLkPLKR)BHkH4k2iW2JSd6c5Fk3LmpnPgl4zWch3uUFyk3Qee5rwDa7sbAzdpk2BiOZn0dzTaDqKYP1qs(ja3dUbdtrr2jHOUxKzbTed4WJlV(WDKYha8AhnqOAMGgsonhgwyThqBYww3moUmyTRapRY13WvXcuREJZYrf(yF78Fdnu5xk1DI2KrATP95W(X0l1Qxpy0IZ9Jo7GRdY84x6DA1UfDI)PzY(TmBpuM)qDfdQveFbB94vgs7wEYylu5u39iMzNs(qShG5S73Htyp7GobWQcK(bPXJaHoWuquRcogidMytno9Iz8su4WWc90xc3BOG)Nb1RHW7A46AnCzb)We)HfbTJqmx7lPvIMKJ7jNbcuGIfurhmCYfgItrgScBy8k2PIKcegRlypLeyqm6isms3uRIqQCxFxnQvDPwz64uAdUzXvxHSwKlKj26BfqpJj3gkvvBl2MGWtDn47e6sevM8kYlhZ5ozQ8kTtEymOLmJq6WMIJjdHrvoWGVKnuFzBOXY2qZLTHwlBdTx2g6SSn0DzBiWQUSTCPPnQlnXrDPPoQln5rDzPp5v2hzXgVPYmKskTmFvw5CD)0SMZHaC)KssZKGmAIvNRH(8bBfKLh2J5RlQPNTzvHq7HGnwjGG(r1wzOK9cHKlq9kHdgfngS(ISw5KABwX34bDGL5eyDfFAInUBBBm7B1LVv3Q2(uf2CI0gH)KieegFizXboa7I7MdEohWuscUYVCBktnLrO4wnrd32LhUkJp38V1Q1UIhpkaSleS)J5khsscVnOv(cXVCv7W6jLzSpSZquWHSp0ni)KGG4Y0Qtf7HOWEagOfu9l3RCMbUSjSBJa7YWhlTKLJo3ePB3eSLtBL92Bt0)zIfGzgeAmq1D2eBhGRQLyR7cRjkX5o7ojR5NUgjjE2b0(6dt6herg(cUoaYN033Vthmktz3SfyJXAPKx9W7dsVskGix5AAO)vNu063cdqXn34)Y1B1UZw70wr7MRVZoR3A9o38YjrGNoP(38Y7S96T2D3wBVZLVrNvgQjMVYEbZgZsGp7bYMOk6urtYR6UQQGyv1IkmGaQ)Yvo7a6t6)s6xA)srJB22g27a3EIZIaRok)yKDH366skfny5KHOqqCk6pix)vfgbfYzrW6w)dXqXrMBim0Qm7d(q0rNi)tRYzUIn3abBU1b2mtdesc7sgC5rXqCg7NY5G0YTsQ5IxTqA2ado94JsbtujJQMb3IbyJbJDrNEH(151epzbMJ2qSul0IqJ(CfDZfuDAGa3j7YmSTbLylJcaw3kPmjRqJytmONDWRX5m)rsw1)JVEtsXxLZXiwsfbXQezcCAoiUF2MyqkU5n26s8VVnSl4LUArhAq)3sZ6A4LgW21xY(nlWU()PWE5JhwNmuwF7IWLBAcEEBAAQBzR7OROtX10C)gH8zNvaNYbXxxQBOgbHRFrLcCTGLHyo5SRvbSCM3LfB(vjQfZ3Xmj7x5PVyRWcjEmU7EJY4bEVGLjlyKpyxdGP4bQtgzlcO4wrWc6pTVvhkqbGg)o(3c0wI7JeG0ualTXET2A7oED2R1E3OZAT2176BFJRSvBVld6NFdXUOZVzxF9R3rgdjCGxClXOlXIp(EIy0IlPnVq8vl07DYMf0TY9ewfGVQdtJpFd8lFHBqUWLtNnUY12O9E)vdOQ)adOmYZFTqP2)pbkZ5MyTeO1cUZC)4JRgxfWyuqJTVimtIWvjIqNWi9krM4sA2CGIfXkPfcwZADSHORBAyz5QA7QPyzAboCBJ6rmWWaveRywqYOrRQlajXmjhkXfOqp4Xpfirk0fIGeKehfaIAclYQhpj2M4NeoIfDJsbxtSQrVvkT7xnCtri4QyKFymdBcZ(PS4ALf7pIclDhy71UOV)5juc0ybTqG(L4TAHMVeTISctg7AwqrnmD1vSuTmCSS0m1WyIAzlIsppS(RTZE7TZ12DRRC1Arwwg8sPhisINUDP)NCdfgjFtlffdBxxtfDvlGaAYiEatW8EJ(8EdX5sXgKWgueF2JZl3vO6JSSKHiFtUlGn66wvk0Y4CByV0embuycolNTWQQVRkJuJSj9oQIJJv7cTa7nofmgIYumc6mZJeH2NW9Wxaht87huwBEU0lCMOJxFK9KRnWIwxxsxei38qYdfqcTBiyNCyqgPVgtuuWq(3YRVeOmDMKf2Zp5FZhZ9kYAaAKK0zSgxLImiiGpYF0mPKRc)7CdfEWT7LampvyAuRKolBc9X2QFthfntfnhhvBhdln260sg32oKL3S8cHlQYoxXYS2MgU2oMUQo2GMqtnfdgYLOLWwgygrNrZx0PiHtMLfYcPsghU1L3PDNBUv730d0ggg5Thajix1fepezKHfwX4mJWHiTeK9wngc)6HxUMZpAYmmZC(rJJsDeBGXtOpAwFggXrMyt2j(JWCp3)0yFaKevkafGcQSeWsGaTYSPSN1Ps0U7C8PuKq4XHAJOBDJTiMVgclfonPHSCQhff2pt4vxL8E3njJ4afLXqLYxWSwY2XmFZY2o(PsPBx60CPSSH7(NxFglsFop)MGKqaOijQppvGjJb73z1QsrnNa7DCCaOcagkm7XXhrBUrjXuKnCnzm1bdIhosSZUtj1MAmbLlPsmO9gGlty7SaWTS(14spTSb03U8xWEqL(rhmgjXhjtZQi4)(9H1icQaNfmTC2TImUclr87dcdI6NXEaZaEqSLWEx9gT3BJDRQ2FfWLfz84nfjMM078wT2D3T2zUTN3wvwJ7C1wxRv7sr8xeWFqVOIHLJ98MLR16kBCXDR6KD9n2BjMjDBXmrDA9DVXwRl7MUTQIl1cQVgUgQgkwnV2U2oTFJcrvrx0bJ0k1LvKRlCujRnBT3vFJ2KLfnaSZRBWK1zruPARQR3A7wRVv75286d)nA)gTbtNMD1mp0213DRn6uSckHK1QIhBK6EJ2xz3DUX1V(2T(zfRPLywBb6vqRQN78QGBHAd752y3bwxUdild1EgOE9naQqvPfb5wNpeZd)Ev0aRLDERb17UZvUXgljMUkh6gV5oVrjyfmK0LnnupNdB9gT34A)SLKplxwkGEzGJduniuQ0Ia1WYndlcL)GK8EjPXW2qGv9KzR7XSVIPrRs8fMr90kwIic6OZbjJMulTITJyzQkAN(SAKeuadEBCSNr5JHQyc5TXLuN3A3nA3Y7NTX2BlLBkBLWI50neZRa0QRjsvYAWBHIrDvovMmt35PBX2wsdfagdpSX2BkBKJRIQRGHst1uKlw2ZLR2RS7gBuOmhSvvYdkgBxLzyzflfxXGAO2KgNzm1PUsMzYzsz1961qOZYjdKnvv7Yo1ScS2SkmLvMHj1ML0TeenvbnX2TjLkMcgpt1kTR9g3yVDBTDt8kniRkWhM2wsMexNguTt4vwtfYO268QTrutNKvHGvrzCl8st873JvDSLSbHzWe4X9ObG5CRjQMqQZSYrLkt3ALwfym7rGdFIYRYSO0Syvuyq)qYbUcGzyY4yQiuZOynyOWngK85hSxNv7KNqMlL0pH5NQF)qYeplEeEkCIK33RdQEahS0u0b9J6wMGgsqdbZnkwzNGoPrz6VKYMIspJbwy247m0)2IszJIzXEfHQ0alJwEr(bkIlC8OArVQX97aRWRdt9pkRCvYvn9TubhhCY8MqvGDswvHnzGl038K0JgWROAYoqpQk7(ExKLKF2G9JN0hl5cWosyDmKfjL46UOiKUf86QI99kSsFUfNPYfwOI0ekrfwndASYUJxkJlQKnBUcmxrviaPklbfl(QWWUuTy2TGQqozZPkGdTuJqqDrvjuJfDPuQyeix1JYhzHj6yi6lzOEBlTsMkP6AQR2Gft1mAPTQHLDHUP6B9VIOXwSwBPxYifZAg1uFOXv(Y4fa0q1fyRB92QTadcR2wyT5uOFw2A75S40mlwDcdOuBggmww3HG2AUi74R3ClRVdw9dd(IODZ26sydDnh1zXiZ2f3fbpsJ9C4n3AUu8zARPT9ISSVoTPeZDdasvZoBB6OUa(0zgAJf04AJSML5cW4Z0yRfX(ntRlqisWWz(TEHS2ZWgA5opE7zBRTYIaK6nVuRNVAN6mwQkAZhPxvAZwDUqEnCIQI(8jo1guT5YOwJ9qvXybi6AJQ(IysNHVtF5DTfadZfquQPFYsDjDqdeWTwaZFDQwbZ)ffXG2LeQMvoPglefNQ4t9Y6r1jBqwgMaEE2ZUGi9Hw6eg7LelI7flc)sRGomY)iMTbLIMV4i8GwYvkU(wZwlCW6rAaTU0ffDxlPYSsjkGgVrbyC2WOtx3KVbb(ywuMt1EHLZQOixlS1QuU)faKIR0Lt2h1l(Om8VG1K3kmljDzSNJc6SSiU55ejRhwlu8tna2AtfBE12CjDtUhu8vurf7x3FlHp46sqd8aOlRELBBZRSkmp(bGPqi1xapSYTNLSQQyj76OOQgbAxLAK7NEKGGiRthKf4TyT9Q0VKLgo4iteqWa)o6GPuK)u0ngMFgSumXCfad574UuEKkYrcVwjOQbIzLjzhBVKHd9J7Z5nXwmFJAx(KTXB5cRcoDE4VXJKLSHfz3a8sE7TxBNDEJBsLehEy6U01bPVlXteSxXCisKtN1y13TkQ9PZ2eZNnzmb4lEPVSBPMLxGw2FtW3lvffDDxBBhDtW2pWlmx5QHB8Vb5Nv4qeromiFqsFIaWjtZRYv4VMNL2Uj5uMMLiGcBLvbWWe8e0ut3rtXrt3WOiLRo6AW(8AAgooQUw6kStAiMYvBlBdvDdvBBDtlvxDwT6qvXJcy8JQTHPRIMUo4sppzSfCZlwiSemww7JtTGl5u6qGvKGNSEdcgYQXNsNap2ij0nu70lUixreEIYo8Rf(Hsh8WUPjhZz6OCou1VDM)6uggcIoSOgtf5HGoIdm9Xm4bFyrW86h0D8HhUFNrJthH1Of7BzHr3clRNdPk8k60ddraVVF6XjP(4rKKD6H7CeQYcf2sIOu6250aSINLNuyaD1NH3okkPR)6SQcKdiPb9yryGD2i4lle2RCwxG3ffEyGhVuEzNEXOGBrfZbllvK(KWHdzbmI2qaRrbmHS05(LvkFy(wePcJF2IjLdr4Pro3liUhIprbcSnaln4mlE8IZOWCy7QIYok8u6HNYh0v)YXrn42JCvYdOCpbRXOG8aE63927Y7Sg)CtZyGozqaIsVYn2A71ld7JbgcYpZq)OIQbJ3PI9gulkxfCpxEE7loQ1fzpSQ)9eFpOGgXrL2iURmpB8CQjxJucALqNaWqOKfyzKsICui)qy8r9rZcgcMhWoHraVjGWIh1dW4SkBPpdNdi)EhdBJbC6byYxloTpyWBgeMZbhSM5aoXJdzPoJYwQOCQjA)ASZYkEwIJ7XoK0I3XoY3024ULIB9M2oGwguHJMRczbWHxs3PiE1BAzAzzzRyGf3JOCbSfHqDttlqlkOZrrZ2w1HERUnpc1BAQz74Aa6XuD1G)Vl)LSajVj0AfvxfvDBdfBqvhVoe4bAeucQROOyAzycUrRQQYFD5qF222sZyfa852WXpcT8QTfTlcOBPHSsFO4CAlEiM0vFG4miisCYIbUcxJIsUAR2BUJ3E3yVD2DRwBRsHxep49SyKWz(6I8EDr1JDrDJDlzHbwkJX05xwm6a5FN3CJDBT92R3AVwEasU9wTVcX(25AybOTZ1wR1EE7T112aNnEmF98JJbHr8WvPmhGtJVpFEAe)WDZYRA5f7BTv7135T8WOb7DJ24VOLeMc64m2kxeDTt8tJb(qVW(QsfRAS7abrW7KbkIQ0eEfVKZL1Yrnw1o1Rnm200Z030KcPY6BGn3CmawOoIZPFFpsjAeww64238IXXdu74L6dVwQbJiuGpj0Xvd86XL9Bf6KRPz6QXFo)7Gj1SNRWurDCWPz5OGCrm8KQtQS0Z53Ee1LUhHlrkyNvoN5LI8zLNxCsdQ8yEPrWnuETMF78gtrNLdDL6iyoZ48SAOKfGvAVSgcXA(rEUYzvzcTNu1jvUqQ84lCqAADTeqALj576kJpnF3wGZL(kw45ClAWkwmd5BXr2fBVQb9tD6NA0pvPFYzjXmt0)YuDmYojjIdDOCb15v)LVz6t(TNDWR(Q)8R(x)ckTcnwtrNawK6rzVRTiKeuUD6m9t(GjV)hD2btFNNTOb4Tc8hbAOwdeSvSfNuro6egLZ)Oh(Q)1V98h8nN)Hp)SdETjVZhD(h(qyq)6Vag0xVXrLwrExZ)OWEEBIBOgKUjwEq8d3i3O1zh7ZF4lo)XF6zhm5RV3R(Y708y3I2J)uVoGDDj4LqH4KqsEy24O(GVzYN(OfbPTs75dAhUgy4Z1OKwDQ4utIdQvJd6h9GP)JFZRpFQYy0gJnr9IBc2A2zuyAyU4iwIJQDtJ60p(lM(HpyXl8DhCAc8HbEVzsea2jIJJjoOonsXE)3D6D)xw8GEz8imHLh21taF(J9u0ehEtIraCWXuGgW190hJCaFYNn99EmZleDhWDgD554K1jvdw4G6m5RV70V(raBZKFZdG(9LF7zhC(9V)5)dVG6SHf0Bnv5r7K1zq5nJ)B69E40N8Hq3E69M8v)wgxPUTcJvvvWXRcEGzZKBM(WF15p8BGo84NdS)1w2T6dw0nZb1G8t1htLteUn2H5YZekdyGvNlhyEeapN)HpczsVZ53)ZfRatndl5XdvIZCwsCMzPo5Y4mM(K7o9rFUaNn5p(5tE5Dz9trfSzIfrpblQUn42idxp93dZ09bIpmz)XVf(4K)()NcKMHo7GPAlNoWCwMK4KF3JM(hGUDxG08(pdGywFm1uTjwbvNYGOcBD9()Vo))(Fp0Cyjb6AylWhFNZF4JyyfttddYdwWWeHIjyJEhotX78KPV85GK50pg4sN(3EFG5FY7FFGQXxMAUMoSimkyPa7u15I4pGHpN8vphuAm5P)DlpzUBussFUXk0OxWZPPYh(x98F7REXxcq1V)5t(NGFF(hFFGMtZ45F8VguprGOLPILor110ky6DTeeWhHD)dawfGwo5ZEi19x9IxiwEk60PphV2vK8zocQ4ZVhGro)HaF)K39ft(KhkzeE)7lfA0Dzk9ly5SXd)dHF(13z6d)tt(SNZ60xFVPpqWQQ4AQXIBROBUazIRR)H3B6N(Vm9P3bw9m8lOjMdXGr8aNhl4Wfutft(EnpfMWpdwQp6jGYgodUPTRllDasiu3vNZW90pdKoLlRNXLpEVNbIiu3HM6QYoI9cEpa36QAleeF1F(deCDtE5FGPOh04968j3sb8TG6Ej1ygAm8Z0)WhijOmUyqg9DyCEM2AaVhTrOuxMRTU9sJz1vllwYvk9LF70p9ljUHZF4lH5(v)5NX7MHURdB60kWRyXvtOjCLn5l)cq)Pqk2KkVf8YsI1Axhfn(K8RF8K)53DYta6aGCGTbKDXHiC6gL0Oj40iTLt)6hm9j)kaDcGxbMqtfR1bMnbMLxtmLHcQSdHTkU6GeUhG2lrXAh9Rjlcl1dWaQXzClQgJwXr1SwNeE1t3BalymN9tV0Lo7G8bHzNDa2MZoaAn85tgeeJphEaZGUZoGo1jNDqc8F0rl5Sd8p7awPyJd7BdM9Zg1(IHTHbH1cycWM)JQoZNaUQtZpnEHXW248bI9(8e6TIXLRY5)WzhGnf8BdlHyyihno)SdWyKih3bH9gaaEC0PLMe8b9ckV(9JYsQ0G8sWpR04G5ktSi6F2pf7n6qamwhYBifwdadLCecWu87qaK)21X3cJaVu6arjEmap7aDtLx)SFkFrTsdx8BNDWFd1QFcBEzibCKPaMWimLVq3(riWiqrzaWhNJiawaFyytXTEe8nGdcGMJsqAdMidwdiGojQp0n2vPfI1y0F4l0mWb)80XbLG)5CRkrRbSP8fbv3rLWED9HfrXvQxf8JEPHVwLlXqn68bvww481aRQMGLquYjm0eESgHVZ6AXuG1F48NKIBLoA6WgZNqWf3i2CXKlRSeed3Q7gCicxTeVAZXX0H3j71ED(4m0)2i)hguqKI92OasFIIKg8ZhhMYe5(XPbrj(8fh4sYXLxcgokNDamkgv4MQvfuRuWpbT)Nm)2XYudRHsgpqTcNAXz8WBHouwlcrT(z8xsrtt(4xBEmknCJ2vNjzaIogoMyAj2uA8fOAUoqMKjD61kpBQLrdnR1KMovLFcP1bdtznTyLu50SQSW8mIzQhncKUr(rl67I6vUovrpPR3oqH73JrI6xgt3aV7Ot6yCEkc3Nm8RZuxwZlWSSG4WlryGGrR4YHbNfS25g8BE0J5HhOsaKffwCLrLflD0XZJWd7Hi2xuHgQmZRj38fHslVEqPlf7PkhbqXG2Cy7HTBvWBdPi8uqZi3iEHfcixB80oXUTm9kD8Jz35PuSNpmIFxBXIxh(ik5hDN)Y7Npg9jUH1NasX8yWYFgdtksmIiSNSRtW0XJYZQvYGW2GzyAp7qNFL4y6U1O1ptCLFHppMLOO8sd3imbcZmwfdaw6XDeN8(UmCkaN99pD)oGjGIluRy8GR5tbRpPx)Yf1y1I8tezsrEH4zHLovuyECWWrnEymlcCSQsLhGzrHdYZn1HbXzH3k4siBpBmW4xZR3a(lfscI2Ysan7PJZj)1R3eaeaV2POKxeLwb1hpIANexe7ZAqr3sZC3gM3UfZA3gNtc9YlvrvnLISNXXssPyhgUyyGxr9oYk3YK4(Hswv(5PlJDEizvplrHQDo7YRw6PHr8afVOf4AFFxG5YWwdYAubGqxZKdyjyd2cn(TpT0D8KNuDLaeM5f8YlH091vOh6OGHuKQZ8uXiC0u)gokACgdPZV4rXhWbluzOM1pwr)hRPdBF4SQPZQg2)IRHdEhEcj3jEJy00j8AtbT04xa6JXW)qBxXmTIbAO5vuxG9pZ5VkiUSHrGY(vixbAAojGBDwgD2emgoBqq)x71P5JTyXdQh7E4uU3k5g)3XbtM(5t8RS9YkyugNDWmzyJ9W59YSRaxAyItKR3mMvmeuUcvX5nmkRbq)6aZIVajECWP4(LGLyRsFx1I(f6T4dEi7JF8xm5PVK5O7tU7K37LubdvDSTwvZUjiKtUwHk6Lg6YsdoV3tM(ry40(n)PPF7dM8LpAYV7rZd4CQntgoxiW52yxwwG78)Hhn5F6zGZ1ZdIqpjRo(wRQy9l4jDJDgy82EJwV5g0iGXLVpZ5aKzBjN6MM36YvgARQOVyuHQwJ9zPXfFY9aaA6hE35IlQlQORVQU2fatgn2NLgM(Who9tGz)zZfMQlRORSQQ6V4YxT12BVr7RSH312z9nW7bJD3JgcXvHmmld9poqELJtQgyUg)3GogfHw3Vifh0B7hq3VojSZXp)CMqnXKEp76(S4q2xBW52l4jlRK6tEzieTW1dncDgqaRsc(bBHUoliyUAR4xPuKTGLbtzdOvy)G(H9OlDtPE4YTH(HGgXjqy8lwTbkJ8LB1hBSbEMTuRO7rXzvfLv10)bEVcv7MN0VFBwO68DE0wWUfQUnmAQFN3UqtPXH5cLXCzcv)J3DYlU)KN8bOc6)3pti2n538qwOa)QN)QNFNP)T3NcCD55XM2x6cK)10ASpljSD(7(Gjp(BM(EWggV6V8Ijp5EtF8ZN(OpArWOE95Za(3faJgn2NLfgj4y6l)MjVZtweGzwBsmmb60faywn2NLeWyORj)ZFUy7T5ay21MeD3v1S()Rb9hCnOULvG2eTPQount6QfguaP6kOwA6RQ6UQP7p02B728K(90GBLggTlWkpD1g7ZfBgbJlcT6e0J8YNZm36LVG9039ft))8eYCuwjpm5(3HDDtuDQux14cS8c)7ird9zzbVZFVVebVp6oam907n5p(5N)RE2IGqJAZMI6QQMxaeA2yFwAe4tF5KN8mkn0S0xTiWZQYuPTQj8VlcbA3yFwwWd3C4XFZK37EWEylcYCQnlgaxKZFDgZ3eamNz3T(SRVQMX)orr7)M2uuZYAsBc5pJMulwrFR4i9Ca8P1vAnZpyAsXIAVPj97NMudTzhnD3flPH3oxn0NlwsZHjyD3Nnv4T8V)5t(TpH8nB6tVdUb2ZEi8bykmQpf6xODI4zAVH(SSG15F4ZF1x95GVRV6VCNla4SQnrQMx4UpyXl3qFwAC278e0X6)UNDbqMt9zbur7CbqMBJ9zzHSP)67n59(ttEhSIgEXdM8)4zGyZ5)UphG2fcQ5I)CXqLgV4QfhdOowcU9z3TI8YupbEu9iWheb6ycWdiEqeVK8fbmNAp72HQik6YBEYq8e1G(sw)pbs0lukfVEYGW6HRNgSbyH3tNkpm8UhgMMLZULUOZtGOYpZ99g4NERGmuf0H4Hsd(AU4G6fZn4u83MIOe8pXnf38cYJra7pRddP78bn6Wx5j)dtc7VzfjPHGIPC)Oo4nezxrBOMK4Hq8coeoy9hkUPpYX)m7igKWSTlUgdLx9KHzYtKaxDfLIf6i6t1QDfq7Fh8xFN8zzr4)rJJsBLMl6HTKNOCAc4jKPF9mSuo5oY8bjtZZUT2A9kPfIyFaoQA)9LPAEHk3b(Ljzqp(btBrDQmxOKhmJLek(Fm(KSyS7tT1PrNTRZg(yMI3kgpvL9ht39SuFe9Dh(Dtk7BVrWP879drEh2P7)1GE5xg5nbP70IBjqSrftC5g3zC39WLdoy0L38mavRijCC2bxg6Ai(x6NghK2uN5ZMKyx6kTjF)9))c"

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