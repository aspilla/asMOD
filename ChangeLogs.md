# ChangeLogs
https://github.com/aspilla/asMOD/blob/main/ChangeLogs.md

## 260628 update
### asFireStarter 
* When the `Scald` talent is selected, it displays the Scorch icon and the target's health percentage if the target is below 30% health.

### asUnitFrame/asNamePlats
* add `Scald` talent.
 
| Class | Low Health (Dark Purple) | High Health (Dark Blue) |
| ------------- | ----------- | -----------|
| Mage | 30% for Scorch/Scald | 90% for Firestarter |

### asCountdown
* **Mythic+ Dungeon Start Timer Voice Alert**

### asCombatTimer
* Change default position, considering 30-man raid frame location.

## 260618 update
### asFixChat
* Fixed an issue where special characters such as `+` were being cut off in URLs.

## 260617 update
### asHealthText
* Add option
Adjustable via **ESC > Options > AddOns > asHealthText**
* `Display Health Decimals` (Default: On)

### asDBMTimer
* Added role icon display.
![asDBMTimer](https://media.forgecdn.net/attachments/1738/743/asdbmtimer-jpg.jpg)
5. **Display Role Assignment Icons (Tank, etc.)**: Can be turned Off in the settings.

### asInterruptHelper
* Add Devourer `Void Nova`


## 260615 update
### asPremadeGroupFilter, asCPUProfile, asGCDBar, asInterruptHelper, asRangeDisplay, asTrueGCD, asFixHotkey, asHideActionBars, asHideBagsBar, asMisdirection, asSpamFilter, asFixChat, asActiveAlert, asBuffFilter, asDotFilter
* 12.0.7 Toc update

### asSkyRide
* Bug fix
* Showing `Whirling Surge` cooldown time with 0.1 second resolution.

### asCooldownPulse
* Add Orc warlock racial spell

## 260614 update
### asNamePlates 
* Fixed an issue to prevent errors even if color settings are incorrectly configured.

### asUnitFrame
* Adjusted the health percentage to display down to one decimal place. 
* Developer Note: Since the default API rounds down percentages, displaying decimal places should help improve accuracy.
* Fixed the raid target icon position on the small health bar when portraits are turned off.
* New Feature: **Changes the health bar background color for low health targets (`ShowLowHealth`)**
  
| Class | Low Health (Dark Purple) | High Health (Dark Blue) |
| ------------- | ----------- | -----------|
| Hunter | Kill Shot (Black Arrow) 20% | Black Arrow 80% |
| Warrior | Execute 20% (35% with talent) | |
| Mage | Scorch 30% | Firestarter 90% |
| Priest | Shadow Word: Death 20% | |
| Death Knight | Soul Reaper 35% | |
| Destruction Warlock | Shadowburn 20% | |

### asPowerBar
* Druid Updates: Adjusted combo points to only be visible while in Cat Form (Applies to all specializations).

### asHealthText
* Adjusted the health percentage to display down to one decimal place. 
* Developer Note: Since the default API rounds down percentages, displaying decimal places should help improve accuracy.

## 260613 update
### asNamePlates 
* Added Fire Mage's 90% Firestarter threshold to the "Display Low Health Background Color" feature.

## 260612 update
### asCompactRaidBuff 
* Bug Fix: Fixed an issue where buffs were not being tracked properly when there were duplicate healers of the same class in the raid.

### asNamePlates (New Feature)
* **Changes the health bar background color for low health targets (`Display Low Health Background Color`)**
  ![sample](https://media.forgecdn.net/attachments/1729/195/asnameplates_lowcolor-jpg.jpg)

| Class | Low Health (Dark Purple) | High Health (Dark Blue) |
| ------------- | ----------- | -----------|
| Hunter | 20% when Kill Shot (Black Arrow) is available | 80% when Black Arrow is available |
| Warrior | 20% for Execute (35% with talent) | |
| Mage | 30% for Scorch | |
| Priest | 20% for Shadow Word: Death | |
| Death Knight | 35% for Soul Reaper | |
| Destruction Warlock | 20% for Shadowburn | |

## 260611 update
### asCompactRaidBuff
* Performance improvement

## 260610 update
### asGearScoreLite
* Bug Fix: Fixed a conflict issue with other addons.
>```lua
>Blizzard_InspectUI/InspectPVPFrame.lua:71: bad argument #1 to 'UnitFactionGroup' (Usage: local factionGroupTag, localized = UnitFactionGroup(unitName [, checkDisplayRace]))
>[string "=[C]"]: in function `UnitFactionGroup'
>[string "@Blizzard_InspectUI/InspectPVPFrame.lua"]:71: in function `InspectPVPFrame_Update'
>[string "@Blizzard_InspectUI/InspectPVPFrame.lua"]:60: in function <Blizzard_InspectUI/InspectPVPFrame.lua:58>
>```

### asUnitFrame
* Performance improvement


## 260608 update
### asNamePlates 
* Performance improvements.
* Bug Fix: Fixed an issue where minor mobs could not be selected when clicked.
* Added a new option 
  >`[Feature] Display Combat Colors (If Off, only High aggro/Loss of aggro is displayed)` (Default: Off). 

  >(Developer Note: Decided that mob type is more important than changing mob colors during combat.To retain the previous behavior, this option must be turned On).

#### New Addon: asCountdown
* Countdown Voice Alerts.
     > [Link](https://www.curseforge.com/wow/addons/ascountdown)


## 260605 update
### asCompactRaidBuff
* Bugfix, Performance improvement


## 260604 update
### asCastBar, asPetAlert
* Bugfix


## 260603 update

### asCompactRaidBuff
#### New feature
![asCompactRaidBuff](https://media.forgecdn.net/attachments/1713/782/ascompactraidbuff-jpg.jpg)
* The feature to change healer HoT colors will be disabled in the near future. It has been confirmed to work properly up to version 12.0.7.
* `[Color] Change health color when HOT buffed`: Not supporting to change buff (Default: On).

| Class               | Color Change     |
| ------------------- | ---------------- |
| Restoration Druid   | Regrowth         |
| Holy Paladin        | Beacon of Virtue |
| Discipline Priest   | Atonement        |
| Holy Priest         | Renew            |
| Preservation Evoker | Echo             |
| Restoration Shaman  | Riptide          |
| Mistweaver Monk     | Renewing Mist    |
| Augmentation Evoker | Prescience       |


## 260601 update

### asCombatInfo, asNextSkill
* performance improvement

### asScavenger
* bugfix

### asMOD
* 12.0.7 layout update
