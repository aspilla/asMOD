# ChangeLogs
https://github.com/aspilla/asMOD/blob/main/ChangeLogs.md

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
* 성능개선


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
