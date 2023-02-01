local asMOD;
local asMOD_UIScale = 0.75;
local asMOD_CurrVersion = 230202;
local bAction = false;
asMOD_t_position = {};

if not asMOD_position then
    asMOD_position = {}
end


local layout1 = "0 35 0 0 0 4 4 UIParent 0.0 -492.5 -1 ##$$%/&%'%)#+$ 0 1 0 7 1 MainMenuBar -0.0 4.0 -1 ##$$%/&%'%(#,# 0 2 0 4 4 UIParent 0.0 -422.8 -1 ##$$%/&%'%(#,# 0 3 1 5 5 UIParent -5.0 -77.0 -1 #$$$%/&%'%(#,$ 0 4 1 2 0 MultiBarRight -5.0 0.0 -1 #$$$%/&%'%(#,$ 0 5 0 3 3 UIParent 712.2 -388.7 -1 ##$$%/&%'%(#,# 0 6 0 3 3 UIParent 492.2 -456.2 -1 ##$'%/&$'%(%,# 0 7 0 7 7 UIParent -375.8 114.7 -1 ##$'%/&$'%(%,# 0 10 0 7 7 UIParent 0.9 72.1 -1 ##$$&''% 0 11 0 7 7 UIParent 0.0 74.4 -1 ##$$&&'%,# 0 12 0 3 3 UIParent 712.2 -427.7 -1 ##$$&''% 1 -1 0 7 7 UIParent -0.5 201.5 -1 ##$# 2 -1 1 2 2 UIParent 0.0 0.0 -1 ##$# 3 0 0 0 0 UIParent 8.5 -7.1 -1 $#3# 3 1 0 0 0 UIParent 227.2 -7.9 -1 %#3# 3 2 0 1 1 UIParent -390.2 -19.6 -1 %#&#3# 3 3 0 0 0 UIParent 396.2 -374.0 -1 '$(#)#-G.//#1$3# 3 4 0 0 0 UIParent 3.8 -561.0 -1 ,$-1.+/#0#1#2( 3 5 0 2 2 UIParent -319.7 -359.5 -1 &$*$3# 3 6 0 2 2 UIParent -352.2 -360.0 -1 3# 4 -1 0 7 7 UIParent -0.5 156.3 -1 # 5 -1 0 3 3 UIParent 492.2 -311.4 -1 # 6 0 1 2 0 MinimapCluster -10.0 -10.0 -1 ##$#%#&.(()( 6 1 1 2 8 BuffFrame -13.0 -15.0 -1 ##$#%#'+(()( 7 -1 0 4 4 UIParent 0.0 -352.9 -1 # 8 -1 0 3 3 UIParent 34.0 -413.5 -1 #'$F%$&D 9 -1 0 3 3 UIParent 712.2 -424.6 -1 # 10 -1 1 0 0 UIParent 16.0 -116.0 -1 # 11 -1 0 5 5 UIParent -392.2 -437.0 -1 # 12 -1 1 2 2 UIParent -110.0 -275.0 -1 #K 13 -1 0 5 5 UIParent -2.0 -499.0 -1 ##$#%# 14 -1 0 5 5 UIParent -2.0 -459.7 -1 ##$#%( 15 0 0 4 4 UIParent 0.0 497.6 -1 # 15 1 0 4 4 UIParent 0.0 482.4 -1 # 16 -1 1 5 5 UIParent 0.0 0.0 -1 #("
local layout2 = "0 35 0 0 0 4 4 UIParent 0.0 -492.5 -1 ##$$%/&%'%)#+$ 0 1 0 7 1 MainMenuBar -0.0 4.0 -1 ##$$%/&%'%(#,# 0 2 0 4 4 UIParent 0.0 -422.8 -1 ##$$%/&%'%(#,# 0 3 1 5 5 UIParent -5.0 -77.0 -1 #$$$%/&%'%(#,$ 0 4 1 2 0 MultiBarRight -5.0 0.0 -1 #$$$%/&%'%(#,$ 0 5 0 3 3 UIParent 712.2 -388.7 -1 ##$$%/&%'%(#,# 0 6 0 3 3 UIParent 492.2 -456.2 -1 ##$'%/&$'%(%,# 0 7 0 7 7 UIParent -375.8 114.7 -1 ##$'%/&$'%(%,# 0 10 0 7 7 UIParent 0.9 72.1 -1 ##$$&''% 0 11 0 7 7 UIParent 0.0 74.4 -1 ##$$&&'%,# 0 12 0 3 3 UIParent 712.2 -427.7 -1 ##$$&''% 1 -1 0 7 7 UIParent -0.5 201.5 -1 ##$# 2 -1 1 2 2 UIParent 0.0 0.0 -1 ##$# 3 0 0 1 1 UIParent -200.0 -678.0 -1 $#3# 3 1 0 1 1 UIParent 202.0 -676.0 -1 %#3# 3 2 0 3 3 UIParent 1196.7 -215.0 -1 %#&#3# 3 3 0 0 0 UIParent 396.2 -374.0 -1 '$(#)#-G.//#1$3# 3 4 0 0 0 UIParent 3.8 -561.0 -1 ,$-1.+/#0#1#2( 3 5 0 2 2 UIParent -319.7 -359.5 -1 &$*$3# 3 6 0 2 2 UIParent -352.2 -360.0 -1 3# 4 -1 0 7 7 UIParent -0.5 156.3 -1 # 5 -1 0 3 3 UIParent 492.2 -311.4 -1 # 6 0 1 2 0 MinimapCluster -10.0 -10.0 -1 ##$#%#&.(()( 6 1 1 2 8 BuffFrame -13.0 -15.0 -1 ##$#%#'+(()( 7 -1 0 4 4 UIParent 0.0 -352.9 -1 # 8 -1 0 3 3 UIParent 34.0 -413.5 -1 #'$F%$&D 9 -1 0 3 3 UIParent 712.2 -424.6 -1 # 10 -1 1 0 0 UIParent 16.0 -116.0 -1 # 11 -1 0 5 5 UIParent -392.2 -437.0 -1 # 12 -1 1 2 2 UIParent -110.0 -275.0 -1 #K 13 -1 0 5 5 UIParent -2.0 -499.0 -1 ##$#%# 14 -1 0 5 5 UIParent -2.0 -459.7 -1 ##$#%( 15 0 0 4 4 UIParent 0.0 497.6 -1 # 15 1 0 4 4 UIParent 0.0 482.4 -1 # 16 -1 1 5 5 UIParent 0.0 0.0 -1 #("
local detailsprofile = "T3xAZXX1rc(Bz)WgRuegW19bDmFaGaGcwGn4Ig0ADemqHQ7Ua6Az1D1UQQbi8kHqIcYbhjoRKwtAdltQLkSoNHBe0w0AOIvkM)pSB8FyZmFh1rx9HSgPzNigDa0DvVJmZxE)Y3d7PU3U71Cqs8bHrb4hJpkiXpkYRDuGFIx)GJZItoSRFA2ERUxZ2(dYgMe4Le4hHnUl(B45PdcIIAZBuVW02D8Z8Xp7pmH(Dq)GKdpb)uh)E(hgaFkBVMjXh7DGFNaVW(WO1qDVMWhAOTxdLL1W3piY)KGeVobz(HrPEhh2Vt8X48M22hGwSdP3e6sZ1Jo66BUxZwaeNfClee3RzZBEsuy)aCC6pSxqsi0hV0tsZc6HZrZHPaEaaGF)WE(zHX9trWljyqCsMhIyEq3Vz6ET2RjBItzWA8WmoWIFQa02legPH98KuW4ET8Z8Yc7HGQcq9I8tt9cBdtLxApOj71CZ(zbjh43o4gR0PZ29tVXAmC9gHivk9guxcKnNdDzXEh3nEVM5Rwhe5Fimjw4KGRBd7Fys8WbbDqCcXuasYIcWh2VJxAqc0pVb(jWNqeStWb(dJY8ADia1rXjioP4Aa44XXjrDeOsyQxwIFAxCqhC0ap)upAAWV3ko(M98tUjTa4Lg(RrKggaj51dysc64bujymokicNddZ9AcFR9n9cHLfVOa85a8qeAQ9yRunri0pRlG4XrzHdGxbZ0eRmtHlkSFAMF)2avSxq)HaJDimFajmEqqFCmMGJVDx4Rb9jUuI4LgeDaNWGelG3MAC)Hd8IIpezdAvCA6hdSoT4CRTimmTl0)(T9Zc6d)p(qA48ADINFc8mGQ53Jepi8egv28LkLYAEysaaVnBn8Gda2(WiaQbcvsyq)orNCqiYY3bOkXj(iKddeRLdgMmaKvG5locGhyeobKvbatijcmvDqYuLfQ9AORtGtheyIc7fMXyWqSeMiGlcf9q6ryQFROaaOb6kNXZR1WSmuKcEFVGEXjN4LaiydlJIeQ0GdHLKSuQRmE1bPE(TALeCuiblauKpbmkkJLlvUs0kj(Mbm5EuIGlIGI(P71WS00nCWGKGubtCdqKC4aymeSAB4yyzzBzRzB76OA5AT3blzcZF8as9qD6FYQHb3)wcgC9jv9a)QxR4Ouu1ywSeCtB3nONpX8EqC)mpuLaT2JSSqJ3ij8xF6()xh63jbW5t3F3DXPUSqXXHDYaSs3eWluPJx2jdcivDs6SFpq(hwhnukqxycnWC55niMM0(Xj9yk4pzVnwYw1r3w3qvv3eipAkavXawgV1EBy56QQ66A64OyAR44GVbW5JbkPQMQPRRIQIIQUQJb(gyTO7EByR5Q7yAdDr3qZuZH9gazsb(D2uIG8TiAXXa6OOG9RHg87mSDDdjrDP6vcjvrfFGCDwxG54WUEfe(cb9EOHH0Ui3Flgjf063UliotOom2m9fOCvhIKbZdOlK0dQHO0bdJIAfN0by0yQ2uw2KdkG4Vx8bCWPGKnxaGndQ0eOISe4pn48o4shcBOnbpYc8CTiuSlPEAaA5Jyky9PDsShiQGgnlkrHkWqEnp)OWd771d0Zh6HmzPzjH9pKS655DmOlhviY6tr0vq2krF5qbbe4lrdPH9pGwaXEW1QLedITyJW2aIhTxqKKAkdd58Inr57TqInzuVf7b7iEa3a5QIhtWa5ecr)xfj)RIuFYVJbbjTb5HCENdcVfi5swUyQ5RBvd5rhaWmIJjHh2nJ4yIcoG9HwbzhJAO5RSm3qa7UTVj3QlZ8V0mci9bc((haucgjA1cY(C60g4Y0nawFTL3D3nq7ITjnne)cYicCEhKgaaWsOdg4K1jjEacHthpY5(eUkXP(NU)Q(jRsl7NUVg60gQ2TdbSm75KGbbK5g47f3jiIuBaQxbCH(o4(f6sy6nwPDyNvti9uW7dsUcAfB5RcJoydkV1Vc6MXnw))21wPrZn3UHI2nwB7TxBL1AEJldMT8ts8VXL3ER1wzNDwzRTV81BUCpnX85hnORpxGKnMfGB2dKnrv0P8MKjyTApmnlUh3oY)dK3r91w(09PpP)A0V0EnrJbn89tJcZynVv(6nFuQYMN3GftaaLW7EcAOfuupXITcxiRi7GG3FRYIeL4NfQ5q(aLC(a0biqPr5MUSn3hkBwZXFBGDtsWy0Ws0Tw1cdiO9DqdxfFEPEEycOuJm6kL8N(0Vd4taijauQMVq1vg0fHsAoi3nLI)udNkftI6e1hmT3c8bB16e2litT2)LW2zd7D6(Va4vta4X9lc2(zmKQcyPoEpOdCMUFIKl8)8lwNu7lXzu4JvUAM0jrUI6JMfNXgMgQAMMM6w26o6k6KVqMf5wMeo4yATk)wy2EdpozkFy6ckBJifUfgGnipFt3aCRm4gxFZL4FFRW0SLEP8oWLTRqtQX2XIiOao2lmMrCLC5XY9bDjSSXVA0ulv0VxZvAdQibRr(rNU)1a3tXV0(Kc8TfHDrajs7JKvdiWBpWXzMZS54xAaeMKpe)(EnBSDJ1XajyMT0ySYcpJMCLSzaGbHzauKECywBWEVFFkERc(nWmxsbgug3i)Rya3egFbs5QOx5WpSy(eG0GglHoPYCKPfZX2uFaKaSPdf0g52wzhCeEQXdb0lpLamhe5Rtc3LynxTKRnlWkEoUKBeXvJCoSf5Ci47BUD3AOKxHRoOSUv07yU6vvvBlUgwvnxdMs2LDvLU6gJU62NuniCuVGbUW(mHf4Jh5hnKY0aU6cd(c2q9fTHglAdnx0gATOn0ErBOZI2q3fTHah9I2YfETrDHxCux4vh1fE5rDrxFybbDiXNRBQvsAy2UjtjL7Qy(WGGosZcBt5Ml1JMPm2SEqmMgcqtccnOi6mhYcG7CDtpJfCThj(qQp2L7NElHN7KwgUUnm9kS0Gvv7MMimXg2gOd7jby7zr2LRrHuXxqJfrspeIBbMCu1n6Sack1nd6YzaSWwmYupkxnC8ZIqWL0rGUzgmpPGJ6n9pcMl0t)a0OiOZz9DxzZTA61C3v296nxDLD8U2wx)kB2W7YGlZVSaZNEZU2AxRPmzh4ap7wURmVc7kYZaIrBmxJARGXHsjhbZsXUIyWWx1KfvHc7BxEUHWmt0P56x5QR3y3V3aQ6pWakB557luQ9VkqzgxqzbiR80xKfsHB23ZVviequiM1nmVxG)5b94FlxwdD0c9lknpdoKBa5Ezu(fOIjrAaRk7yiKD2WWYYv12vtXY0cmiBJ(QAGz1GNfezsFit4Lv(f3pkaKKysYKulQPs4Ih4wEm6IvCFMqgpLFzayaQbc84MLLd4Qf8JPPudrXuIdRtL92Vp4a7RXdOdxbty5orexXC8sSy3IogCms2VfibaLscM6YguROy8Zhw2U3uxOwfM6whYsScyUq6MKvLugLeFSivrac6pz20k16W(mMay55ewgQs77JCACZlfcNRscbfaqn8CSKTCC4GGcmDS0GNuMVlp)9SKGAy6QRyPAz4yzXZAPLnLLsyEgeh2haRv3E3D3(Q7S5vEPkzioLuztjTJNImjrs3UW)iJTITISHLIIHTRRPIUQfWABYyRHfOP9g9P9MScIGC8vK1ow26e5WMao4l71CdFG5TG1a2qKHPFEVMBT9RuDHCbCMMCb4qCs7eMe0MLFFvCNn8BHU5MfpqYxjPzfwPygQlVqrg6BpmbezOnFSc3Li5LIKDlmExIZFjnBU8HaitXCYxgilZLHJ5G40W2(X))9jmVGxBcPnhnCZvhEiqwQBb5yqKzG)GGKQ6klYEoJSk2ogi)L4fulWlGPskx5ttkjp8it3WrrZurZXr12XWsJ2bgdl0MeTFkAfKCmXi)Wn8yddxBhtxvhBWeGPMIbJCtMNa1LEip0eQ8pbxkL7DjfSyHClS5L3UrZBSzJFHhysimYBxaqrzI540PmGArC2ocMzG3ryvbdFV2CWxnC8kPJttULMSGf140shHD7YBJ5GJgWfhMZUwl3PipahbgcFgDUox4XzijKTZSrrHDszM7QpB)iOW2)(u81CInTxZ9pbIwNCpoinfZ7dl8E2UNxAxZnRIw5B3kpS)2r(9giKJDkO3rJXsUKkXk0okEyhpE5lKxgcGhh3maCvbMJtY6IXIGABAdisKyxqbAr)GJf79ijaTBEMuunDe8Hn0vvyIB02DcgYcaAtuh2wyY3hvyMGfD4r8cqGnxSTxjg)E3WGOoPShWY7dikrEJ)sxVXURVtznSlRQzktEGjNJqJ0o8kRSZoBU9uBpVTQSgFTv2AL12SXuhC5yRBtT)QRCL1lKmdrUm0mCumSCSRFowF353fAcyDJ60A7C9nxt2nDBvfxQfuFnCnunuSQhLU62nE5CHhrx0bhfl0LjqS1wFLDFPxUbzdVgGDADR5lTYvxPXcGEvxLwVX6x9xovYEfIX1B8YnadVtIutJ6DTD2C9M5isbGrRm5Swy76nUYoBF9RDTTw5xMZ3TaZ6kGUb0w7uNxfqXUJTHt9DhyC5beTil6ta1RToSYxwwrSQRZhIPTk(sOtdl68wbQ3z7RC91xqkDzg11)fB)YfGvWZnx20q9C6C3nNL2GYqxMScV8sHyDOT5F186QauVktRAHnoNSEwUym0efZc52vcOP7isBA1AGaSQDi4JPOoimNOeeW6VjLc7YqruZsGBGd6c2zGXRBCgyGOpwwhXdOas3L5bgpXnYbdbdW(qklolrHAWkbLGoHKlHTsI97GfNw5TgKm4qHui(41aYc4IMMIoS6PdrsAB6OZDelXVt4WumxmksibCKGvmrh3fTyf3jopAVdqpcZyz5a)UyRMlvpsIYXat9J)TMMngdSGo42ya(kM5Sc7jWe2gw2sS3Da4Z4hmQZMWY2ocUmvr70NuDMqaWG3gh7jmbyOkMqEBCjRURSZ6nwX7xU(wBjvBv0TPzROXqmVcqRQ9avPKjVfkgvv8xAYmDNMgEBBPaKaW0RXS4YUwcnic5mB9C88k7S(65T1YXsk8lgvxLj0viqcxXMayOwNQ(jC(RQ29jsyQmZjQtQs1uSUBkOn2UtyncwdvvTlgj3YkQiykC0VonTwIvnv3sJCrJ)6vwyjAsJ1V(U7SYw1XLuJssb9W02sYE46qSURV1gYM5aXt5kwfG4Re0y2ZzEnJXcG1Y4bj(hMwSC2kNUxYJmsmhIvnOxlwQxlMvA45yQCWmsCRI7u)jL22EWhtzLSXuMjlNIc17vdMRKii43JcUU)bHuIYpGPhJTvFe8(RgIQG6eKXdGdJRpaMp2Me22VDxsxvFSaGavYLWXEOxVT96mS)HbSUsvlKuBUF72brSu7i15oaEDBQUnytfAdGki4EanmUhJiGjn6iQeBODIVAeyeoVajOI2EwPV2w8huzV0eCCchceg1ZjU8sKITjOflFLY7eBnfzxZdW9xwwvtumAuupfteIC7)QaycfaQYn4ZIdBgKk08Stkqrk2DUQEiqyjjyw7qRWONasZ3)J0J9hGgA7CcSMaRz8qPO8zwTMxBfNwiQdK1PqShnS0k4)NQRPUAnUbwXtSgQgw25QCQ6pZYIgBXATLEbpVmR4Pw1HgPnlsGnqdvNHF8vBR2m8YTCBbCZjxPNS12tb50mZXoHxHQ1ddglAeEqBnNvmkvBUL13HiAGbFwRDt26cudDnh1jPit2f3zbps)xD4n3AQR4t0wtB7zfUs11Mcm31aiL9KUHPJ6m4tNyOnMrJRmYAwMZGIprJTMf73eToNGibdNP36zYApbBOL704TNST2kZcqQ28cTE6QDQYyPQOnDIEzPnB1Pc5vOjQk6tFXPYGQnvg1kShQkgZGqxzu1Nft6e8D6lE86ayyoJfLk6NSuxWyobbCRzW8xDvlN5FEjFQrbHQjLtQWcLXsezyFV4(c3Uy7Mby4pPn4Rd400rGDukHJISMwyFnffxpgFwHD40AYswaGpz8b6s351DTKkNkSLP04niatfiMu7Qbz3nWVd)mnuJBsy5bjkAOI7UIS4dfaeDeE45CH(OE(hLjpgCg8OW04KfXFmkL1Y93KxPcPTXA6LF2bWwBQyZRE0L0n5(3ZXO8T1PA0aIiv1LGwdtysOYeRHnVcHXIFiaC(bZESaEyLBpR4gktLSRsIk7oPD5vJm)KdfliYQ2dzbEfwBFj6xYnUaC5ncwWocRtX4bINI5(iwEmoOrydthBvffDDxBBhDtWHKdwcczTz6Ww0oZKVzlRM3lUNMSJnwCVE(97izB7NnD3v)oSzCSwoZAaxxIStRshLlaZMVHTjbSSD0so3CNWnOSFe2dr7EbzDJ7qeqksi8ePjbX8nObINCRTwD7TF5BqLzoE2Zw6A(hgSKQeI5BkBR4mABILJwUtTQWsJPJIHPMUJMIJMUHr(oS6ORbgK10mCCGGE1vyhfiChwTTSnu1nuTT1nTuD1zfglvYSkGxkQ2gMUkA66qGV89ELXoLtWfBpwZDyLtOkQST5wKSPn57eewFHVSAHMLvcvkQ9XPskyCe6bzQblFwHMvafIGdzrrMh(llSWI7zrEMSe9H29lz13sXh6hrQw7map)Dz)nhkiBlMkuNfZj0ohGqvk62I5(JIvYdqVmA33MD4DCoPD3(Afp4PIn9bJy7eCFMqrvw9auF8GtigYtJt(j1rwEUSkMXV3amnee6Op3avjBfImnOjpzBHOmZr(rmvR1hSyHt)zXTxTAIqOO751tll1fhgf3YFn2PSHZGLe0MLt1svedMvtE(dK7WFu4bGbx2jXHXPefCeTh9S9(J01g2RhlpwKXsSibWD9M2yrkPgdAh2XJv2oDy6h5hOUJ7gqhc4v(L8GHXd3egOBXuCt7pP4G5qZA(jao3CMAEXbG(sWlgH8uYKZtuo1cKOkytbb9c(oaZBWTg4QKfqBCjq3IaXcEzz4T7L3EvwcxYrDmA8q)iVHG8zQ8qIIBNiwreahCh05MEGtoSkhQHbYushosSwxs9G5dNjxCUb1T4p1PFQr)uL(PcBAB3nO9nH1CqSpa3BAA(4sq8duvg)aF7HNN1dXn7mctgfG64sjkba9oojKvre5hmyXdXKV7dqB3GiXbfLy6LfD2Mn2yBVDV(UBVZMRSLkTbdyQRyCT8LLw4QsluYOfkn1QG7ca8nSpDAufdoasxfR0UTV6QRSR3UBE11XbLNIup)(9bltyDOJwBZsI4Nry2wYweSFLnBS22VIhMmvVR3a)fbD1c3uokBIByD)uHmDoNgBVXjx1ClKb)nCO9yYX12000YMo2f4oKWY7n8whfvxfvDBdfBdw9JyiZoky0cuhPyAzyQAyPQQkQeIPVGrBbdMxYiCxDaWAyk)aFHIOh7N0hyb8c7Ok3RcS2aWkp9Yu9xXoLxIctxkT085)ZFZ4h9(NU)Z)Y)6Z)lFbP)Q2YR4yWsOhL3(gIWMy0TXF47n6D)dNU)4B)4znaVsG)ayfCvayvSfvZo34bmkx8ho)5)LV9I79nxC)NE6(VWOB)hU4(Ndd6x9fWG(I1oQeg5Dv)dblhBGYzbjBGjnJxa8Ctsto2xC(ZU4HF0P7p6RUZZFYRx)yVcPe4eVMdp4GyCTquT8KxZ1oQ37Bg9rpywq6kjT9bP)Rck1UkLB4tevwpoOw1oO)H7n(3)nV40xvgIQE2azq2imjO5GWKWmrz4JJQDDJ64p4lgF)7nBeFNUNedFOR3Vioca7yrj7JdQtTRyV7Bn(S)8Sh0lJhVqSGzUwmehtFpfnrb(tmcGVDMcYaI3JFiYb8HFY435HWe8Q7QQ7aEYPFjvd8)uG)L9j1lPQr)4vZoD)j66lY8pH1x55eGnHQgSWDBo6RoB8x9aGLB0BFpOJp5BHb6U39I)NpJMydlO3AQZEIN6qWaa(yip(bmaaCaLX)p(oNp(r3h63NDNrF57tZQMUTII9SN0X)(Zg9S7o6rV343(Jh))9Xm0(JEYZFYBm62pa(478yGiWaa2WjpudKgaWxABMAGXN)gxC(3a94HpfKMRSkUshWU1ehbmYxzF0bSiSAyoitEmiy4gqWD542da07I7)aKi96xC3pxqun1mSMd(vTRmm8dEY438nK0vCyKhScjNKZpcCsMfMqxMS24p71h)v3F8dpdbZNn6tFmXom6p95J(6ZYzMuCMdE)OZg)GpxWmX6nF6vuT0myPdsO7q3gcLHXip(3bq8DbPsym(tFl8Xr)d)tcUjdDL5mR10zjZd079ybJlWzW5fMc2r)2hm(pc9dqWlE3hd0ngrwrZfmYn7P85F5JU439jW892O5hIyp6F5EOY0p9X8P2ut1MuuO6uKCRWwFF3)px8)6FaMvy9bSeXwTE4RFX5pGrSnnnmmnMZc9uhdolgBqiqqOSst1W1HR742pA8x)uq5)4paueo(3Cxq)6O39UGKebcMqKN2Zz5E0tU3Op8Uap94)co335Fc6Vy5wZ10HLMoHElBBtDUnO7X4ph9LpfSQn6Z(7xCb3wrXXD4vXgn65kL0u5d)ZF67)8N9eKV4PJ(u43x8b3fefPz8Ip4nb7NecAzQyPph545osmSLnue4OLRK21IBg738xh)Ohm69GLwWMZOp5CQ)p)zptWUPO7ohL0S(HYxpaafE)FY478ij1ghJ9yH2jvK5ieUE6DGL3loh0tp6TE2Op8CPa67ExPSTU7Cy3M1OKBRq3L5RvUonB8S9s0H381hF(hp6tEkRxF1DgFVppx1I68uP(1pfvY)WVL(W50aaJiZQ1h(VixlmSuCn1y5hwadUGCa3FTZVZ4p6pdk7qYhFueReiyyAphWy09UhOghrIBZxhFYzx8MO8hk89mPzlWbzqJhlJ25YEkMAsTTNJQpEWJaVp462TuMRIoWA53EVrp5bOMlc6VZDeA3nTDDz7aIKYR7QZv09zFcyDuUE9yU1bYkln5qtDvNZKpRbHbeSrHacHkpqiWv1wyo95)13tOOA0x)hzEFcS2cuWsX2ITYvW3kdng3Z4)47jf9yk(a7C3(P5RCZtgIpa)ECH6jpwmk8vlBnqHf5EV0llxBD7)THXvxTObsUJop5BbhKykro)Rbe55)1hZHbdDxh35ad10BXSsDNMwTCgvS2(johCzA0t(cWfrMvbDtt354ac6hXz)z2k178KrVXDL2InPApcV3NytKRJIgh9EZho6F8Tg9iGDeysaF0LDXHeI0nk4FMqTg5734V6EJF0BqYFf4i0uXASZEUU(cAYiV0aag8885F9BEXzChF5Jap42kbRsPXziEwn6WUt7y5qPDx8QXQZEnp9NV0sNUp0It3)4UbWpHO8oDFw1QF6(SMLE6(HzWpWosJWVoUFqLrywDgB(pbFzi8feqGMhgfrtlnEH9HGQ4de79zXLakU91)taGann0pcRriyihmeioy6TKJB3W2DpDFSuMkmj4dAhWgFgu4hLgxQbzfGFw9HcZvQaj6C6ph7nMplySoG3qk3tNUFu8Hiatztgbq(BxdFlmc86jfwS5jx8091nvEXt)5CKA5AU6QoD))oQv)m28Yic4itz1cabG8w8AS7NGaJGeLcaF)mKaWYphJAk2Dp4BH9aW7fomgxBWe0YAab0XrDGUXsgms1aSlW)i4l0mWb)SKHbfG)PS7HeoGnLJeu5WwG61YhqI8BCWs0h9cdFLcQLrA05dQ8OfWXbwX2cOqu8XmYewLyeRl218PaRd0Ppj5xnF00HnMpHT9rwgCUyzvUekigUlTtWbiCTI4vBmSpvrAPVWlYhNE(3c5)W0VIRy)AuaPdTIKe8RggIC0W68pnjik2NJChhNCZIOGHJYP7dJIrjUPkvp7Y58tq7)ztVDSmUZAOKXByAaF1IZ4H3nFOSwesA9t5VKYLN8XVW0yuQ5E(RktsxKC0BiX0sSP04li1C9Amjt6aTvC2ulsg458xOjehS4Hm0tv5NrADOsJMjFlu(uuffOwiTw9A0XFLXCrNxwALIDMEWHLEg)OX9Dzy5JLON0U0at0FdJe1VuMcdE3z3GO8TCQ0grvyRGkDqGKhlqClDK7Nd7C8AZ2DHcJc)6jLVhuRw)Blmv12z5PcUeGK)4sDAA7twH91Tu7)UHptdwMj(TaGuPr77kkWNM5IjLpqxtHOlrfmx8SdnkU5iEj(HDGo1gtXDqcFN2VzWjPz4oRKxdOYD6bp7N8ZlBE61RUvu4z77MbzY7HoEGo4LrbOF(AeI1Gkz4rVZxdU8b(HsNfHDP9)YL9p7H3ZdjaQXEkG0Krh(nwlreW5Mnotj(j2eEzsQyZoWqRYEYkYrct7JTPMHIHI1YwoM0wYlNr6OGCz(fiQ4PzYmnwdc99epkN3YQGVYKqVYIcWual1aWJV)zq4BxC)Zg9WVjh43a3lflhdDdliqc8SFCWsg2vqf8aQwcxmlJl1hz0eRjktznb8)xtDzh6Q2JJIBaSrkMMkowMUqOakk8Jj7KO9goA6oQk4Ufz7OyzRjo9WIWDRHuCXDFpmKQp71V4HV)iyb4VC)X3(XFFxqlfrDvC3AQ4UPMPXYkAol4YllOW6wEH1wiOU39ElbridYzJ)WZ)(kQvtuNvXltZ6XlvBxiE2LTnwy5mkR3)qiNvjr4)RPOgfjyD8xV)dgF2Jg9fpD8zpdKfg9PFVzUQpsZVdA90DSx21XAHWmXj4kcmWq3bYP8dzXm2y8F1qCF5kCHdxXfnwHEjn4uy8e382D8OITiIHgK9Q8DJxwpatCEjyNlJ0t6thRoXHae8gLcRTCNRumb8IWIkGbUn4I1WG8edwEWywH5hHAzHxiVJ4ZPm0MiNHMPRRNfSVw6Q0yqqcDY6WYeHJnSRQi(jyPCTfv62DgrhX1rFXROEXDyFn3h8TKxC9TkFX1Vdq)3aIJyIQz6hSzC1cb(oXf41pO45pEZ2vP616hRzBfQwz(rKqQR8Vfmlg)ynRzmTRESGlrfkS4jC0D0lwntyvmjlPj5DyjR(7qnUDdZ46cWBytWkWndzvBicNIZtwUp5L8eNPRqOvPOMJS8)Esikynrz)WQrUKHdYsRqQogc8elm3M0z)RFF6EngROS8lFO(SRD(SjQ2Wq2Dhbrs64FYEnvKxWuE9Xl6iFQ0QIB3zkNror8jIlUFEuj0fBpw3CyKud71NfWMSYOWI5lOFA4rblHgjy9bR2k2NI5VuO6x0wwXpZE6WmQUkQ2eyktJ7t10vEsxf3pq4HH(4(5RkvGIwfM5w1mVTYN1w1oNurDXl5svnfgc3lWBYJqNQ4sxb4S6ekVl7435lPSBXhwzRYUyVkFxWKL)xkbrbxhgXJjCwy1Q)TIv5CodIgI3B7hYVNwuu)PkA)un9t3xr5s66xsX8vV8lTYwBTEJRSU3v3ET1X7MTD2909FvzYltV0P73dcaw(NGe8u95XYl8FhMvWim1wq7zM1P3sNNFzgPO32jGUFFJz3nu8JLp1et69SlAS8ldPQdEriaZuJh6sXetbw0J8lta6A5IGPYTIFlUtkdkcgYgqyqNGoHTPRkwEnMwUn0pOlqOljqam38WxGisg9N(ii4g5d3Sd8yxl2MRuEbq9sAkV6vrySjVsw3U)69XehJ3J7yEwHXOnwksuY6yjwMreW1hoGHel6vb9lMw4KH9xM2K96MtI7G7Gd40ryA3GoVWlo71rmzktmyQomeyxSPxM9hWej8Vmf3AnDzvy0xd4D9fij4MAob9vf0uiaxCZgPnD8n)y2Je0x68YuAO1SMl0yxBxwqObcQy8hGveW9U7OhDNXF4zqyFx82pRky5uzouDUKH(Sbl3A7YIsKE0zJF7VMLFgA)IV438X4pFRhwfYW4bkppgxsBoGMQAT9zbHTlo)Sr)JVflwqiQ)p9XtasvLjuvVKIX)HsPF8ukPwvdHI2LmD)bwRKQr9t6FBQLunRz0SMdFTvT9zU81AmvbN94XFYtzmZ)UNo69F0O35XyMfFDSwjE85WhyNVRYZaO9Bo6NuDQTpliuDX9F6Z)YpF89p75)ZV(CGnqJJompQ08OPFjttWDGzdBOhs10NfLID7hH6p)7F8Sbmn1QtcyVyolLAA12NfeWg)M3z078XJUnMy7NDVr)VF8OF7dU43(5sDvtfs1RmRgoxsr))qZ13BnxAL0Cvp5VSEm66UxE6BPdmJ4pehyuwyIV6WUTwf5)cEu1WYcIakvaEtKeeXpOoYOpX2ZUdsAjFO82)edkd1KMh73a84(mrGF5r7HxNmnf)fPOf74FY7kL4SQ9KMVU450HUqQWOloimjLQZ)MSdLKytXY8966NCuqksRpapaUWxZkIms4M)3qqwQJvPezgJ)nfl)a4jposS)cb0JUmQ0OtzQN86kM9xmr6j0dI9WPzQN7ot6)y3zvPY84fMULmORc3jVmEfw6HJ5)PzO8e)Vd(Jlg)kbIT0k)lpHCfVyKHLUa9z76x1q1ZZsGKFANv2CTsmreZbWVu5iZvMbSexh767nOn)mKoRovKhtYHLY4253nNsog23F5Gt4j(wK65TB9FpOD2LbbvFqiLUbSBYUNJwJGeM)cR7JvVWM9XZsENH0LunnEIXDB214CM8AznFIlonnh2AxeDqWO(jALi5yF6(yU9dX)KLv7GW2Ca(SjxDlCVyLT3E))o"

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

	print ("[asMOD] Details, Bigwigs 설정을 합니다.");
		
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


	local bload = LoadAddOn("Details")

	if bload then
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