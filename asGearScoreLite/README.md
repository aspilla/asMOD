# asGearScoreLite (Midnight)

Displays item levels in the Character Info window and the Inspect window.
![asGearScoreLite](https://github.com/aspilla/asMOD/blob/main/.Pictures/asGearScoreLite.jpg?raw=true)

## Key Features

* **Individual Item Level Display**:
    * **Character Window**: 
    * **Inspect Window**: 

* **Target's Average Item Level (Top right of Inspect window)**:

## Configuration
None



## Known Issues
* Conflict with other addons (ex. TinyTip etc.)

```lua
Blizzard_InspectUI/InspectPVPFrame.lua:71: bad argument #1 to 'UnitFactionGroup' (Usage: local factionGroupTag, localized = UnitFactionGroup(unitName [, checkDisplayRace]))
[string "=[C]"]: in function `UnitFactionGroup'
[string "@Blizzard_InspectUI/InspectPVPFrame.lua"]:71: in function `InspectPVPFrame_Update'
[string "@Blizzard_InspectUI/InspectPVPFrame.lua"]:60: in function <Blizzard_InspectUI/InspectPVPFrame.lua:58>
```

*Quest reward item levels may display as base levels during Midnight leveling

---

# asGearScoreLite (한밤)

자신의 캐릭터 창 및 살펴보기 창에 아이템 레벨을 표시
![asGearScoreLite](https://github.com/aspilla/asMOD/blob/main/.Pictures/asGearScoreLite.jpg?raw=true)

## 주요 기능

*   **개별 아이템 레벨 표시**:
    *   **캐릭터 창**: 
    *   **살펴보기 창**: 

*   **대상의 평균 아이템 레벨 (살펴보기 창 우 상단)**:

## 설정
없음



## 알고 있는 이슈
*   다른 애드온과 충돌시 아래 메시지 (ex. TinyTip 등)

```lua
Blizzard_InspectUI/InspectPVPFrame.lua:71: bad argument #1 to 'UnitFactionGroup' (Usage: local factionGroupTag, localized = UnitFactionGroup(unitName [, checkDisplayRace]))
[string "=[C]"]: in function `UnitFactionGroup'
[string "@Blizzard_InspectUI/InspectPVPFrame.lua"]:71: in function `InspectPVPFrame_Update'
[string "@Blizzard_InspectUI/InspectPVPFrame.lua"]:60: in function <Blizzard_InspectUI/InspectPVPFrame.lua:58>
```
* 한밤 레벨업시 퀘스트 보상 아이템 레벨이 기본 레벨로 표시