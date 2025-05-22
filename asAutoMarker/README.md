# asAutoMarker (The War Within Season 2)

asAutoMarker is a World of Warcraft addon that automatically assigns raid target markers to predefined key monsters when you are playing as a tank in dungeons. This helps party members quickly identify important targets and proceed with combat efficiently.
If you are a DPS or Healer, it won't assign markers to mobs, but it will change the nameplate color of key mobs (if using asNamePlates). This helps you identify mobs that need to be interrupted in advance and assists with setting focus targets.
Key mobs for The War Within Season 1/2 dungeons are registered.

![asAutoMarker](https://github.com/aspilla/asMOD/blob/main/.Pictures/asAutoMarker.gif?raw=true)

## Main Features

1.  **Automatic Marker Assignment**:
    *   Activates only when the player is in a party instance and their role is designated as "TANK".
    *   Automatically sets target markers on monsters listed in the predefined `NPCTable`.
    *   Determines which marker to use (e.g., Skull, X, Moon, etc.) based on the monster's NPC ID.

2.  **Marker Order and Management**:
    *   Skips markers already in use by other party members (e.g., if a tank has assigned Square and a healer has assigned Moon, those markers will not be assigned to mobs by this addon).
    *   Prioritizes marking targets that the player has threat on or is mousing over.
    *   Mouseover marker assignment is possible before combat starts.
    *   When combat with mobs begins, it assigns markers to key mobs that do not yet have one.
    *   Manages markers by making them available again when a marked monster dies.
    *   Resets assigned marker information when combat ends (when the player exits combat).
    *   Marker priority is as follows. By default, the Skull marker is not used.
        1.  Yellow 4-point Star
        2.  Orange Circle
        3.  Purple Diamond
        4.  Green Triangle
        5.  White Crescent Moon
        6.  Blue Square
        7.  Red "X" Cross

3.  **Conditional Activation**:
    *   Only functions in dungeon (party instance) environments.
    *   Activates only when the player's role is "TANK".
    *   Does not operate in other situations (e.g., raids, open world, or when not in a tank role).

## How to Use

1.  Install the addon and log into the game.
2.  Enter a party instance (e.g., Mythic Keystone dungeon) and ensure your role is set to "TANK".
3.  When conditions are met, markers will be automatically assigned to monsters defined in `NPCTable` upon starting combat or mousing over them.
    *   It does not provide a separate configuration window or slash commands; it functions automatically when conditions are met.

## Configuration (Direct Source Code Modification)

The following settings can be customized by directly editing them at the top of the `asAutoMarker.lua` file:

*   `AAM_UpdateRate`: Determines how often the marker assignment logic is checked (in seconds, default: `0.2`).
*   `AAM_MaxMark`: Specifies the maximum marker number to use (default: `7`, Red X marker). Markers range from 1 (Star) to 8 (Skull). Skull is disabled by default as it can be used for other purposes. If you want to assign only up to Star and Circle, set this to `2`.
*   `NPCTable`:
    *   The most crucial configuration part, defining which NPC ID gets which `marker_setting`.
    *   You can add or modify entries in the format `[NPC_ID] = marker_setting`.
    *   A `marker_setting` of `0` means no marker will be placed on that NPC.
    *   A `marker_setting` of `2` will change the nameplate color to light green if the asNamePlates addon is used, and if you are a tank, it will automatically assign a marker.
    *   A `marker_setting` of `1` will only change the nameplate color to light green when using the asNamePlates addon.
    *   Refer to commented-out sections (`--` or `--[[ ... ]]`) to add NPCs for new seasons or dungeons.

## Notes

*   This addon is primarily designed for the convenience of tank players.
*   It will not mark monsters that are not in the `NPCTable`. Users may need to manually add information for new dungeons or monsters to the `NPCTable`.

---

# asAutoMarker (내부전쟁 시즌 2)

asAutoMarker는 월드 오브 워크래프트의 던전 내에서 탱커 역할을 수행할 때, 사전에 지정된 주요 몬스터에게 자동으로 공격대 징표를 할당해주는 애드온입니다. 이를 통해 파티원들이 주요 대상을 빠르게 식별하고 전투를 효율적으로 진행하는 데 도움을 줍니다. 
딜러나 힐러일 경우 몹에 징표를 찍진 않지만 주요몹의 이름표 색상을 변경(asNamePlates 사용시) 합니다. 미리 차단이 필요한 몹을 파악하고 주시 대상 설정을 돕습니다.
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

3.  **조건부 활성화**:
    *   던전(파티 인스턴스) 환경에서만 작동합니다.
    *   플레이어의 역할이 "탱커"일 때만 기능이 활성화됩니다.
    *   그 외의 상황 (예: 공격대, 필드, 탱커 역할이 아닐 때)에서는 작동하지 않습니다.

## 사용 방법

1.  애드온을 설치하고 게임에 접속합니다.
2.  파티 인스턴스(예: 신화 쐐기돌 던전)에 입장하고, 자신의 역할이 "탱커"로 설정되어 있는지 확인합니다.
3.  조건이 충족되면, `NPCTable`에 정의된 몬스터와 전투를 시작하거나 마우스오버 시 자동으로 징표가 할당됩니다.
    *   별도의 설정창이나 명령어를 제공하지 않으며, 조건 만족 시 자동으로 기능합니다.

## 설정 (소스 코드 직접 수정)

다음 설정값들은 `asAutoMarker.lua` 파일 상단에서 직접 수정하여 커스터마이징할 수 있습니다:

*   `AAM_UpdateRate`: 징표 할당 로직을 얼마나 자주 체크할지 결정하는 주기 (초 단위, 기본값: `0.2`).
*   `AAM_MaxMark`: 사용할 최대 징표 번호를 지정합니다 (기본값: `7`, 빨간색 X 징표). 징표는 1(별)부터 8(해골)까지 있습니다. 해골은 다른 용도로 사용 가능하므로 사용 안하도록 기본 설정 되어 있습니다. 별과 동글 까지만 할당하길 원하면 `2`로 설정 하면 됩니다.
*   `NPCTable`:
    *   가장 중요한 설정 부분으로, 어떤 NPC ID를 가진 몬스터에게 어떤 징표를 할당할지 정의하는 테이블입니다.
    *   `[NPC_ID] = 징표설정` 형식으로 추가하거나 수정할 수 있습니다.
    *   징표설정 `0`은 해당 NPC에게 징표를 찍지 않도록 설정합니다.
    *   징표설정 `2`이면 asNamePlates 애드온의 이름표 색상을 연두색으로 변경 하고, 탱커라면 자동으로 징표를 찍습니다.
    *   징표설정 `1`이면 asNamePlates 애드온 사용시 이름표 색상만 연두색으로 변경합니다.
    *   주석 처리된 부분(`--` 또는 `--[[ ... ]]`)을 참고하여 새로운 시즌이나 던전의 NPC를 추가할 수 있습니다.

## 참고

*   이 애드온은 주로 탱커 플레이어의 편의를 위해 제작되었습니다.
*   `NPCTable`에 없는 몬스터에게는 징표를 찍지 않습니다. 새로운 던전이나 몬스터에 대한 정보는 사용자가 직접 `NPCTable`에 추가해야 할 수 있습니다.
