# asAutoMarker (WWI Season 2)

This addon automatically assigns raid markers to designated key monsters when performing the tank role. 
If you are a DPS or healer, it does not mark mobs but changes the nameplate color of key mobs (if using asNamePlates). 
Key mobs from WWI Season 1/2 dungeons are registered.

![asAutoMarker](https://github.com/aspilla/asMOD/blob/main/.Pictures/asAutoMarker.gif?raw=true)

## Key Features

1.  **Automatic Marker Assignment**:
    *   Activated only when the player is in a party instance and their role is designated as "Tank".
    *   Automatically sets markers for monsters listed in the predefined `NPCTable`.
    *   Determines which marker to use based on the monster's NPC ID (e.g., skull, X, moon, etc.).

2.  **Marker Order and Management**:
    *   Skips markers already in use by other party members (e.g., if the tank has assigned a square and the healer has assigned a moon, these markers will not be assigned to mobs).
    *   Prioritizes marking targets the player has threat on or is mousing over.
    *   Mouseover marking is possible before combat begins.
    *   Once combat with a mob starts, assigns markers to key mobs without markers.
    *   Manages markers so that they become available again when the marked monster dies.
    *   Resets information related to assigned markers when combat ends (when the player transitions to a non-combat state).
    *   Marker priority is as follows. The skull marker is not used by default.
        1 = Yellow 4-point Star
        2 = Orange Circle
        3 = Purple Diamond
        4 = Green Triangle
        5 = White Crescent Moon
        6 = Blue Square
        7 = Red "X" Cross

3. **Tank/Healer Auto-Marking**
    * Automatically places a square marker on tank role players and a moon marker on healer role players.
    * Only works for tanks.

4.  **Conditional Activation**:
    *   Only works in dungeon (party instance) environments.
    *   The function is activated only when the player's role is "Tank".
    *   Does not work in other situations (e.g., raids, the field, or when not in the tank role).

## Settings
* Refer to the video below for how to configure settings.
* Turn the `TankHealerMark` tank/healer auto-marking feature on/off.
* Turn the `MouseOverMark` mouseover marking feature on/off.
* `NPC Table` allows editing of your own NPC marker table. 0 means no marker, 1 means only change the nameplate color when using asNameplates, and 2 means automatic marking is possible. Unregistered NPCs follow the default NPC Table criteria.

<iframe width="560" height="315" src="https://www.youtube.com/embed/aQGkIO-bjbI?si=nDRGb98zrA5CWGEk" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" referrerpolicy="strict-origin-when-cross-origin" allowfullscreen></iframe>

---
# asAutoMarker (내부전쟁 시즌 2)

탱커 역할을 수행 시, 사전에 지정된 주요 몬스터에게 자동으로 공격대 징표를 할당해주는 애드온입니다. 
딜러나 힐러일 경우 몹에 징표를 찍진 않지만 주요몹의 이름표 색상을 변경(asNamePlates 사용시) 합니다. 
내부전쟁 시즌 1/2 던전의 주요 몹이 등록 되어 있습니다. 

![asAutoMarker](https://github.com/aspilla/asMOD/blob/main/.Pictures/asAutoMarker.gif?raw=true)

## 주요 기능

1.  **자동 징표 할당**:
    *   플레이어가 파티 인스턴스 내에 있고 역할이 "탱커"로 지정된 경우에만 활성화됩니다.
    *   사전 정의된 `NPCTable` 목록에 있는 몬스터를 대상으로 징표를 자동으로 설정합니다.
    *   몬스터의 NPC ID를 기반으로 어떤 징표를 사용할지 결정합니다 (예: 해골, X, 달 등).

2.  **징표 순서 및 관리**:
    *   이미 다른 파티원이 사용 중인 징표는 건너뜁니다. (예 탱커에서 내모, 힐러에게 달을 할당한 경우 해당 징표는 몹에게 할당하지 않습니다.)
    *   플레이어가 위협 수준을 가진 대상 또는 마우스오버 중인 대상에게 우선적으로 징표를 시도합니다.
    *   마우스오버 징표 할당은 전투 시작전에 가능합니다.
    *   몹과의 전투가 시작되면 징표가 없는 주요 몹에 징표를 할당 합니다.
    *   징표가 찍힌 몬스터가 죽으면 해당 징표를 다시 사용 가능하도록 관리합니다.
    *   전투가 종료되면 (플레이어가 비전투 상태로 전환 시) 할당된 징표 관련 정보가 초기화됩니다.
    *   징표 우선 순위는 아래와 같습니다. 기본적으로 해골 징표는 사용하지 않습니다.
1 = Yellow 4-point Star
2 = Orange Circle
3 = Purple Diamond
4 = Green Triangle
5 = White Crescent Moon
6 = Blue Square
7 = Red "X" Cross

3. **탱커/힐러 자동 징표**
    * 탱커 역할 플레이어에게 네모, 힐러 역할 플레이어에게 달 징표를 자동으로 찍습니다.
    * 탱커 일 경우만 동작 합니다.

4.  **조건부 활성화**:
    *   던전(파티 인스턴스) 환경에서만 작동합니다.
    *   플레이어의 역할이 "탱커"일 때만 기능이 활성화됩니다.
    *   그 외의 상황 (예: 공격대, 필드, 탱커 역할이 아닐 때)에서는 작동하지 않습니다.

## 설정

* 설정 방법은 아래 영상을 참고 하세요.
* `TankHealerMark` 탱커/힐러 자동 징표 기능을 키고/끕니다.
* `MouseOverMark` 마우스 오버 징표 기능을 키고/끕니다.
* `NPC Table` 자신만의 NPC 징표 Table 편집이 가능합니다. 0은 징표를 안보이게, 1은 asNameplates 사용시 이름표 색상 변경만, 2은 자동 징표 가능을 의미합니다. 등록되지 않은 NPC 는 기본 NPC Table 기준을 따릅니다.

<iframe width="560" height="315" src="https://www.youtube.com/embed/aQGkIO-bjbI?si=nDRGb98zrA5CWGEk" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" referrerpolicy="strict-origin-when-cross-origin" allowfullscreen></iframe>