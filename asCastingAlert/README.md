# asCastingAlert

asCastingAlert is an addon that provides on-screen alerts in the center of the screen for spells being cast by hostile units, especially those targeting the player or cast by boss units.
![asCastingAlert](https://github.com/aspilla/asMOD/blob/main/.Pictures/asCastingAlert.jpg?raw=true)


## Main Features

1.  **Enemy Cast Notification**:
    *   Displays a list of spells currently being cast or channeled by attackable enemy and boss units.
    *   Each entry shows the spell icon and the remaining cast time.
    *   Helps players become aware of incoming spells, especially during hectic combat.

2.  **Prioritize Dangerous Spells**:
    *   Highlights spells considered "dangerous" in red for easy identification.
    *   Integration with DBM (Deadly Boss Mods): If DBM is installed, asCastingAlert will use DBM's information to identify dangerous spells and highlight the remaining cast time in red.

3.  **Tooltip Information**:
    *   Mousing over a spell icon in the alert list will display the game's default tooltip for that spell.

## Settings

A separate configuration window is not supported. If necessary, you need to edit the Lua variables at the beginning of the `asCastingAlert.lua` file:
*   `ACTA_UpdateRate`: How often the addon checks for casting spells (in seconds).
*   `ACTA_MaxShow`: The maximum number of spell alerts to display simultaneously.
*   `ACTA_FontSize`: The font size for spell names and timers.
*   `ACTA_X`, `ACTA_Y`: The X and Y coordinates for the center of the alert display.
*   `ACTA_ExceptTarget`: Whether to exclude the target's casting. Default is False.

---

# asCastingAlert

asCastingAlert는 적대적 유닛, 특히 플레이어를 대상으로 하거나 보스 유닛이 시전하는 주문에 대해 화면 중앙에 알림을 제공하는 애드온입니다.
![asCastingAlert](https://github.com/aspilla/asMOD/blob/main/.Pictures/asCastingAlert.jpg?raw=true)


## 주요 기능

1.  **적 시전 알림**:
    *   공격 가능한 적 및 보스 유닛이 현재 시전 중이거나 채널링 중인 주문 목록을 표시합니다.
    *   각 항목에는 주문 아이콘과 남은 시전 시간이 표시됩니다.
    *   플레이어가 특히 정신없는 전투 중에 들어오는 주문을 인지하도록 도와줍니다.

2.  **위험 주문 우선 표시**:
    *   "위험하다고" 간주되는 주문을 빨간색으로 강조하여 쉽게 식별할 수 있도록 합니다.
    *   DBM (Deadly Boss Mods)과 연동: DBM이 설치된 경우, asCastingAlert는 DBM의 정보를 사용하여 위험 주문을 식별 하도록 Casting의 남은 시간을 빨간색으로 강조 합니다.

3.  **툴팁 정보**:
    *   알림 목록의 주문 아이콘 위에 마우스를 올리면 해당 주문에 대한 게임 기본 툴팁이 표시됩니다.

## 설정

별도의 설정 창은 지원하지 않으며 필요시 `asCastingAlert.lua` 파일 시작 부분의 Lua 변수를 편집해야 합니다:
*   `ACTA_UpdateRate`: 애드온이 시전 주문을 확인하는 빈도 (초 단위).
*   `ACTA_MaxShow`: 동시에 표시할 최대 주문 알림 수.
*   `ACTA_FontSize`: 주문 이름 및 타이머의 글꼴 크기.
*   `ACTA_X`, `ACTA_Y`: 알림 표시 중앙의 X 및 Y 좌표.
*   `ACTA_ExceptTarget` : 대상의 케스팅을 뺄지 여부. 기본 False
