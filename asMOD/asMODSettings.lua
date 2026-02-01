local _, ns = ...;
local version = select(4, GetBuildInfo());
--[[
https://m.blog.naver.com/PostView.naver?blogId=relaxxlife&logNo=222914521011&proxyReferer=https:%2F%2Fwww.google.com%2F&trackingCode=external
- 0~2 : topleft, top, topright.
- 3~5 : left, center, right.
- 6~8 : bottomleft, bottom, bottomright.

			{ Name = "ActionBar", Type = "EditModeSystem", EnumValue = 0 },
			{ Name = "CastBar", Type = "EditModeSystem", EnumValue = 1 },
			{ Name = "Minimap", Type = "EditModeSystem", EnumValue = 2 },
			{ Name = "UnitFrame", Type = "EditModeSystem", EnumValue = 3 },
			{ Name = "EncounterBar", Type = "EditModeSystem", EnumValue = 4 },
			{ Name = "ExtraAbilities", Type = "EditModeSystem", EnumValue = 5 },
			{ Name = "AuraFrame", Type = "EditModeSystem", EnumValue = 6 },
			{ Name = "TalkingHeadFrame", Type = "EditModeSystem", EnumValue = 7 },
			{ Name = "ChatFrame", Type = "EditModeSystem", EnumValue = 8 },
			{ Name = "VehicleLeaveButton", Type = "EditModeSystem", EnumValue = 9 },
			{ Name = "LootFrame", Type = "EditModeSystem", EnumValue = 10 },
			{ Name = "HudTooltip", Type = "EditModeSystem", EnumValue = 11 },
			{ Name = "ObjectiveTracker", Type = "EditModeSystem", EnumValue = 12 },
			{ Name = "MicroMenu", Type = "EditModeSystem", EnumValue = 13 },
			{ Name = "Bags", Type = "EditModeSystem", EnumValue = 14 },
			{ Name = "StatusTrackingBar", Type = "EditModeSystem", EnumValue = 15 },
			{ Name = "DurabilityFrame", Type = "EditModeSystem", EnumValue = 16 },
			{ Name = "TimerBars", Type = "EditModeSystem", EnumValue = 17 },
			{ Name = "VehicleSeatIndicator", Type = "EditModeSystem", EnumValue = 18 },
			{ Name = "ArchaeologyBar", Type = "EditModeSystem", EnumValue = 19 },
			{ Name = "CooldownViewer", Type = "EditModeSystem", EnumValue = 20 },
			{ Name = "PersonalResourceDisplay", Type = "EditModeSystem", EnumValue = 21 },
			{ Name = "EncounterEvents", Type = "EditModeSystem", EnumValue = 22 },
			{ Name = "DamageMeter", Type = "EditModeSystem", EnumValue = 23 },

]]

ns.layout =
"2 50 0 0 0 7 7 UIParent 0.0 10.0 -1 ##$$%/&%'%)#+#,$ 0 1 1 7 7 UIParent 0.0 45.0 -1 ##$$%/&%'%(#,$ 0 2 0 6 7 UIParent 28.0 77.0 -1 ##$%%/&$'%(#,# 0 3 1 5 5 UIParent -5.0 -77.0 -1 #$$$%/&%'%(#,$ 0 4 1 5 5 UIParent -5.0 -77.0 -1 #$$$%/&%'%(#,$ 0 5 0 7 7 UIParent 440.0 0.0 -1 ##$&%/&$'%(#,# 0 6 0 7 7 UIParent -315.0 0.0 -1 ##$&%/&$'%(#,# 0 7 0 7 7 UIParent 315.0 0.0 -1 ##$&%/&$'%(#,# 0 10 1 7 7 UIParent 0.0 45.0 -1 ##$$&%'% 0 11 1 7 7 UIParent 0.0 45.0 -1 ##$$&%'%,# 0 12 1 7 7 UIParent 0.0 45.0 -1 ##$$&%'% 1 -1 0 1 4 UIParent 13.0 -240.0 -1 ##$#%# 2 -1 1 2 2 UIParent 0.0 0.0 -1 ##$#%( 3 0 0 5 4 UIParent -105.0 -193.0 -1 $#3# 3 1 0 3 4 UIParent 105.0 -193.0 -1 %#3# 3 2 0 3 5 TargetFrame -30.0 0.0 -1 %#&#3# 3 3 0 5 4 UIParent -400.0 0.0 -1 '$(#)#-S.5/#1$3#5#6-7-7$ 3 4 0 0 0 UIParent 0.0 -524.0 -1 ,%-;.-/#0#1#2(5#6*7-7$ 3 5 0 2 2 UIParent -328.2 -359.5 -1 &$*$3# 3 6 0 2 2 UIParent -308.2 -483.5 -1 -#.#/#4&5#6-6$7-7$ 3 7 0 1 6 PlayerFrame 20.0 10.0 -1 3# 4 -1 0 4 4 UIParent 0.0 -330.0 -1 # 5 -1 0 7 7 UIParent -310.0 80.0 -1 # 6 0 1 2 2 UIParent -255.0 -10.0 -1 ##$#%#&.(()( 6 1 1 2 2 UIParent -270.0 -155.0 -1 ##$#%#'+(()(-$ 6 2 0 2 4 UIParent -125.0 -50.0 -1 ##$#%#&((()(+#,-,$ 7 -1 0 0 0 UIParent -2.0 -2.0 -1 # 8 -1 1 6 6 UIParent 0.0 0.0 -1 #'$A%$&7 9 -1 1 7 7 UIParent 0.0 45.0 -1 # 10 -1 1 0 0 UIParent 16.0 -116.0 -1 # 11 -1 0 7 7 UIParent 500.0 50.0 -1 # 12 -1 1 2 2 UIParent -110.0 -275.0 -1 #K$#%# 13 -1 1 8 8 MicroButtonAndBagsBar 0.0 0.0 -1 ##$#%)&- 14 -1 1 2 2 MicroButtonAndBagsBar 0.0 10.0 -1 ##$#%( 15 0 0 1 1 UIParent 0.0 0.0 -1 # 15 1 0 1 7 MainStatusTrackingBarContainer 0.0 -1.0 -1 # 16 -1 1 5 5 UIParent 0.0 0.0 -1 #( 17 -1 1 1 1 UIParent 0.0 -100.0 -1 ## 18 -1 1 5 5 UIParent 0.0 0.0 -1 #- 19 -1 0 1 7 PlayerCastingBarFrame 0.0 -15.0 -1 ## 20 0 0 1 4 UIParent 0.0 -180.0 -1 ##$)%$&&''(-($)#+$,$-$ 20 1 0 1 4 UIParent 0.0 -265.0 -1 ##$+%$&('&(-($)#+$,$-$ 20 2 0 1 4 UIParent 0.0 -130.0 -1 ##$$%$&&'((-($)#+$,$-$ 20 3 0 1 4 UIParent -0.5 -218.0 -1 #$$$%#&&'#(U)#*#+$,$-$.y 21 -1 0 1 4 UIParent 0.0 -150.0 -1 ##$# 22 0 0 0 0 UIParent 1221.9 -51.4 -1 #$$$%#&(''(#)U*$+$,$ 22 1 1 1 1 UIParent 0.0 -215.0 -1 &('()U*#+$ 22 2 1 1 1 UIParent 0.0 -270.0 -1 &('()U*#+$ 22 3 1 1 1 UIParent 0.0 -315.0 -1 &('()U*#+$ 23 -1 0 8 8 UIParent 0.0 0.0 -1 ##$#%#&#'3'$(#)U*#+$,$-,.(/A"


