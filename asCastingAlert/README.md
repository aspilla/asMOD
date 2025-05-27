# asCastingAlert

asCastingAlert provides on-screen alerts for spells being cast by hostile units, particularly those targeting the player or by boss units.

## Main Features

1.  **Enemy Casting Notifications**:
    *   Displays a list of spells currently being cast or channeled by attackable enemies and boss units.
    *   Each entry shows the spell icon and the remaining cast time.
    *   Helps players to be aware of incoming spells, especially in hectic encounters.

2.  **Prioritization of Dangerous Spells**:
    *   Highlights spells deemed "dangerous" in red for easier identification.
    *   Integrates with DBM (Deadly Boss Mods): If DBM is installed, asCastingAlert can use DBM's information to identify and mark dangerous spells.

3.  **Customizable Display**:
    *   Maximum number of spells to display (`ACTA_MaxShow`).
    *   Font size for the alert text (`ACTA_FontSize`).
    *   Screen position of the alert frame (`ACTA_X`, `ACTA_Y`).
    *   These settings are configured by modifying variables at the top of `asCastingAlert.lua`.

4.  **Tooltip Information**:
    *   Hovering over a spell icon in the alert list will show the game's default tooltip for that spell.

5.  **Dynamic List**:
    *   Alerts are dynamically added and removed as enemies start and stop casting.

## Configuration

Customization requires editing Lua variables at the beginning of the `asCastingAlert.lua` file:
*   `ACTA_UpdateRate`: How often the addon checks for casting spells (in seconds).
*   `ACTA_MaxShow`: The maximum number of spell alerts to show simultaneously.
*   `ACTA_FontSize`: The font size for the spell name and timer.
*   `ACTA_X`, `ACTA_Y`: The X and Y coordinates for the center of the alert display.

---

# asCastingAlert

asCastingAlert는 적대적 유닛, 특히 플레이어를 대상으로 하거나 보스 유닛이 시전하는 주문에 대해 화면에 알림을 제공하는 애드온입니다.

## 주요 기능

1.  **적 시전 알림**:
    *   공격 가능한 적 및 보스 유닛이 현재 시전 중이거나 채널링 중인 주문 목록을 표시합니다.
    *   각 항목에는 주문 아이콘과 남은 시전 시간이 표시됩니다.
    *   플레이어가 특히 정신없는 전투 중에 들어오는 주문을 인지하도록 도와줍니다.

2.  **위험 주문 우선 표시**:
    *   "위험하다고" 간주되는 주문을 빨간색으로 강조하여 쉽게 식별할 수 있도록 합니다.
    *   DBM (Deadly Boss Mods)과 연동: DBM이 설치된 경우, asCastingAlert는 DBM의 정보를 사용하여 위험 주문을 식별하고 표시할 수 있습니다.

3.  **사용자 설정 가능한 표시**:
    *   표시할 최대 주문 수 (`ACTA_MaxShow`).
    *   알림 텍스트의 글꼴 크기 (`ACTA_FontSize`).
    *   알림 프레임의 화면 위치 (`ACTA_X`, `ACTA_Y`).
    *   이러한 설정은 `asCastingAlert.lua` 파일 상단의 변수를 수정하여 구성합니다.

4.  **툴팁 정보**:
    *   알림 목록의 주문 아이콘 위에 마우스를 올리면 해당 주문에 대한 게임 기본 툴팁이 표시됩니다.

5.  **동적 목록**:
    *   적이 주문 시전을 시작하거나 중지함에 따라 알림이 동적으로 추가되고 제거됩니다.

## 설정

사용자 설정은 `asCastingAlert.lua` 파일 시작 부분의 Lua 변수를 편집해야 합니다:
*   `ACTA_UpdateRate`: 애드온이 시전 주문을 확인하는 빈도 (초 단위).
*   `ACTA_MaxShow`: 동시에 표시할 최대 주문 알림 수.
*   `ACTA_FontSize`: 주문 이름 및 타이머의 글꼴 크기.
*   `ACTA_X`, `ACTA_Y`: 알림 표시 중앙의 X 및 Y 좌표.
