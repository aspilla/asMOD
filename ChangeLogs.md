# Change Logs

https://github.com/aspilla/asmod/blob/main/ChangeLogs.md

## 260827 update
### asUnitFrame, asTargetCastBar
- Display interrupter's class color


## 260825 update 
### asCompactRaidBuff (New feature)
![asCompactRaidBuff](https://media.forgecdn.net/attachments/1893/698/ascompactraidbuff-jpg.jpg)
- `[Left] Display the remain time of HOT buff` : (Default On)
- `[Color] Change health color when HOT pandemic time` : Red grey color  (Default On)
- `[Size] Remain font size` : (Default 12)
<iframe width="560" height="315" src="https://www.youtube.com/embed/wQj2mbgynn4?si=T1uaYFFUNq8XyLrj" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" referrerpolicy="strict-origin-when-cross-origin" allowfullscreen></iframe>

## 260824 update
- asUnitFrame, asDebuffFilter, asBuffFilter, asDotFilter: Fixed an issue where debuffs from other players became visible when a mob transitioned from non-attackable to attackable.
- asNamePlates: Bug fix - Improved potential secret value references.

## 260823 update
- asDotFilter: Added options to track custom debuffs, including Hunter's Mark and Fire Mage debuffs.

## 260821 update
- asCooldownPulse : Alert only spells more than 10 seconds cooldown (Configurable)


## 260815_2 update

### asinterrupthelper
- fixed an issue where range and skill cooldowns were not being checked periodically.

## 260815 update

### ascombattimer
- fixed an issue where english options were not displayed.
- added an option to hide the background.

### ascastbar
- fixed an issue where english options were not displayed.


## 260814 update
- Bugfix asCooldownPulse, asFixChat, asInterruptHelper, asNextSkill, asPowerBar, asUnitFrame

## 260813 update
- asDebuffFilter (change private aura position)

## 260812 update

- Bugfix asBloodlustAlert, asBuffFilter, asCastBar, asDBMCastingAlert, asDebuffFilter, asDotFilter, asFixHotkey, asNamePlates, asSpamFilter, asUnitFrame

## 260811 Update (12.1.0, Season 2 Patch Support)

### Caution: This update will not function correctly on Season 1 client. Please download after the weekly maintenance.

### Layout Changes
- Added support for tracking trinkets and racial traits via the new `Cooldown Manager` feature. The number of primary central buttons has been increased from 6 to 8.
- Overall positions for asMOD layouts and addons have been updated.
- Reconfiguring your `Cooldown Manager` settings is highly recommended.

### Addon Settings Reset
- Due to the layout changes, all addon positions have been readjusted.
- If you have custom addon positions or options, you will need to re-adjust them manually.

### Addon Settings Enhanced & Descriptions Added
- Addon settings have been slightly expanded. However, keeping the default settings is strongly recommended.
- As a reminder, `asMOD` is not designed with custom configuration in mind.

### asPowerBar
- Enhanced tracking for essential class buffs/debuffs.
- Removed dependency on `Cooldown Manager`. Buffs/debuffs displayed on asPowerBar can now be safely removed from `Cooldown Manager`.
- Please refer to the manual for detailed instructions.

### asCooldownPulse
- Since trinket, racial trait, and potion cooldowns can now be tracked in `Cooldown Manager`, the previous trinket slots have been reassigned to Class Defensive Cooldowns.
- Trinket and racial tracking features are now OFF by default, but can be re-enabled in the options.
- Known Issue: Cooldown timers for certain skills are currently not displaying properly.

### asDebuffFilter, asUnitFrame
- Bloodlust / Heroism debuffs (Sated, Exhaustion, etc.) will no longer be displayed.

### asDotFilter, asDebuffFilter
- Major debuffs displayed on nameplates are now sorted alphabetically based on priority.

### asCompactRaidBuff
- Added functionality to configure desired buffs via `Cooldown Manager`. Additional setup is required.
- Please refer to the manual for detailed instructions.

### asBloodlustAlert
- Displays the remaining duration of Bloodlust/Heroism debuffs as a gray button.

### asCombatTimer
- Timer now displays down to tenths of a second (0.1s precision).


## 260719 update

### asPowerBar
- Added a new setting to allow turning Off the smooth bar animation.
- Improved combo points to fade out smoothly when they disappear.

### asDBMCastingAlert
- Improved new bars to update immediately when they are created.

## 260717 update

### asCountdown
- Bugfix

## 260715 update

### asInterruptHelper
- Monitors skill cooldowns and suggests alternative skills if the primary skill is currently on cooldown.
- Checks skill availability and displays alerts only when the skill is ready for use.
- Turns the skill icon red when the target is out of range.

### asDBMCastingAlert
- Bug fix

## 260714 update

### asUnitFrame, asCastBar, asDBMCastingAlert, asTargetCastBar
- Improved the responsiveness of the progress bars to quickly and accurately reflect sudden or large value changes.

## 260707 update

### asPremadeGroupFilter (new feature)

![aspremadegroupsfilter_raid](https://media.forgecdn.net/attachments/1777/967/aspremadegroupfilterraid-jpg.jpg)

- displays the count of each class within each role (tank, healer, melee damager, ranged damager) in the group. (for damager, show the total number of players )

## 260706 update

### asTargetCastBar

- Changed the focus target cast bar resizing method from scaling to direct width/height adjustment.
- Changing the scale factor now requires a `/reload`.


## 260702 update

### asCooldownPulse

- Add option for alerting asPowerBar spell (default 0n).
- If spell is overlayed, then alert overlayed spell.

### asDBMCastingAlert

- Performance Optimization

## 260630 update

### asCooldownPulse (New Feature)

- **Skill, Trinket, Potion, and Racial Ability Availability Alerts**: Displays an alert in the center of the screen when a registered skill on `cooldown manager`, an equipped trinket, a primary combat/survival potion, or a racial ability becomes available for use.
- This feature utilizes updated APIs implemented after the Midnight expansion; consequently, skills, which have the Global Cooldown (GCD), may experience slight notification delays.

<iframe width="560" height="315" src="https://www.youtube.com/embed/DDT9QemuJIE?si=OK1inMFZmvS6PdkW" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" referrerpolicy="strict-origin-when-cross-origin" allowfullscreen></iframe>

### asUnitFrame, asTargetCastBar, asCastBar

- Performance Optimization

## 260628 update

### asFireStarter

- When the `Scald` talent is selected, it displays the Scorch icon and the target's health percentage if the target is below 30% health.

### asUnitFrame/asNamePlats

- add `Scald` talent.

| Class | Low Health (Dark Purple) | High Health (Dark Blue) |
| ----- | ------------------------ | ----------------------- |
| Mage  | 30% for Scorch/Scald     | 90% for Firestarter     |

### asCountdown

- **Mythic+ Dungeon Start Timer Voice Alert**

### asCombatTimer

- Change default position, considering 30-man raid frame location.

## 260618 update

### asFixChat

- Fixed an issue where special characters such as `+` were being cut off in URLs.

## 260617 update

### asHealthText

- Add option
  Adjustable via **ESC > Options > AddOns > asHealthText**
- `Display Health Decimals` (Default: On)

### asDBMTimer

- Added role icon display.
  ![asDBMTimer](https://media.forgecdn.net/attachments/1738/743/asdbmtimer-jpg.jpg)

5. **Display Role Assignment Icons (Tank, etc.)**: Can be turned Off in the settings.

### asInterruptHelper

- Add Devourer `Void Nova`

## 260615 update

### asPremadeGroupFilter, asCPUProfile, asGCDBar, asInterruptHelper, asRangeDisplay, asTrueGCD, asFixHotkey, asHideActionBars, asHideBagsBar, asMisdirection, asSpamFilter, asFixChat, asActiveAlert, asBuffFilter, asDotFilter

- 12.0.7 Toc update

### asSkyRide

- Bug fix
- Showing `Whirling Surge` cooldown time with 0.1 second resolution.

### asCooldownPulse

- Add Orc warlock racial spell

## 260614 update

### asNamePlates

- Fixed an issue to prevent errors even if color settings are incorrectly configured.

### asUnitFrame

- Adjusted the health percentage to display down to one decimal place.
- Developer Note: Since the default API rounds down percentages, displaying decimal places should help improve accuracy.
- Fixed the raid target icon position on the small health bar when portraits are turned off.
- New Feature: **Changes the health bar background color for low health targets (`ShowLowHealth`)**

| Class               | Low Health (Dark Purple)      | High Health (Dark Blue) |
| ------------------- | ----------------------------- | ----------------------- |
| Hunter              | Kill Shot (Black Arrow) 20%   | Black Arrow 80%         |
| Warrior             | Execute 20% (35% with talent) |                         |
| Mage                | Scorch 30%                    | Firestarter 90%         |
| Priest              | Shadow Word: Death 20%        |                         |
| Death Knight        | Soul Reaper 35%               |                         |
| Destruction Warlock | Shadowburn 20%                |                         |

### asPowerBar

- Druid Updates: Adjusted combo points to only be visible while in Cat Form (Applies to all specializations).

### asHealthText

- Adjusted the health percentage to display down to one decimal place.
- Developer Note: Since the default API rounds down percentages, displaying decimal places should help improve accuracy.

## 260613 update

### asNamePlates

- Added Fire Mage's 90% Firestarter threshold to the "Display Low Health Background Color" feature.

## 260612 update

### asCompactRaidBuff

- Bug Fix: Fixed an issue where buffs were not being tracked properly when there were duplicate healers of the same class in the raid.

### asNamePlates (New Feature)

- **Changes the health bar background color for low health targets (`Display Low Health Background Color`)**
  ![sample](https://media.forgecdn.net/attachments/1729/195/asnameplates_lowcolor-jpg.jpg)

| Class               | Low Health (Dark Purple)                      | High Health (Dark Blue)           |
| ------------------- | --------------------------------------------- | --------------------------------- |
| Hunter              | 20% when Kill Shot (Black Arrow) is available | 80% when Black Arrow is available |
| Warrior             | 20% for Execute (35% with talent)             |                                   |
| Mage                | 30% for Scorch                                |                                   |
| Priest              | 20% for Shadow Word: Death                    |                                   |
| Death Knight        | 35% for Soul Reaper                           |                                   |
| Destruction Warlock | 20% for Shadowburn                            |                                   |

## 260611 update

### asCompactRaidBuff

- Performance improvement

## 260610 update

### asGearScoreLite

- Bug Fix: Fixed a conflict issue with other addons.

> ```lua
> Blizzard_InspectUI/InspectPVPFrame.lua:71: bad argument #1 to 'UnitFactionGroup' (Usage: local factionGroupTag, localized = UnitFactionGroup(unitName [, checkDisplayRace]))
> [string "=[C]"]: in function `UnitFactionGroup'
> [string "@Blizzard_InspectUI/InspectPVPFrame.lua"]:71: in function `InspectPVPFrame_Update'
> [string "@Blizzard_InspectUI/InspectPVPFrame.lua"]:60: in function <Blizzard_InspectUI/InspectPVPFrame.lua:58>
> ```

### asUnitFrame

- Performance improvement

## 260608 update

### asNamePlates

- Performance improvements.
- Bug Fix: Fixed an issue where minor mobs could not be selected when clicked.
- Added a new option

  > `[Feature] Display Combat Colors (If Off, only High aggro/Loss of aggro is displayed)` (Default: Off).

  > (Developer Note: Decided that mob type is more important than changing mob colors during combat.To retain the previous behavior, this option must be turned On).

#### New Addon: asCountdown

- Countdown Voice Alerts.
  > [Link](https://www.curseforge.com/wow/addons/ascountdown)

## 260605 update

### asCompactRaidBuff

- Bugfix, Performance improvement

## 260604 update

### asCastBar, asPetAlert

- Bugfix

## 260603 update

### asCompactRaidBuff

#### New feature

![asCompactRaidBuff](https://media.forgecdn.net/attachments/1713/782/ascompactraidbuff-jpg.jpg)

- The feature to change healer HoT colors will be disabled in the near future. It has been confirmed to work properly up to version 12.0.7.
- `[Color] Change health color when HOT buffed`: Not supporting to change buff (Default: On).

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

- performance improvement

### asScavenger

- bugfix

### asMOD

- 12.0.7 layout update
