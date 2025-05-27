# asDBMTimer

asDBMTimer provides a configurable visual display for Deadly Boss Mods (DBM) timers, arranging them as a dynamic vertical timeline on your screen.

## Main Features

1.  **DBM Timer Visualization**:
    *   Integrates with DBM to capture timer events (start, stop, update) for both standard DBM timers and DBM's nameplate-specific timers.
    *   Displays these timers as a list of icons, each with a cooldown countdown and a descriptive label.

2.  **Vertical Timeline Display**:
    *   Timers are arranged vertically on the screen.
    *   The vertical position of each timer icon dynamically represents its remaining duration; as time progresses, icons move downwards.
    *   The amount of screen height that represents one second of cooldown time is configurable (`ADBMT_1sHeight`), allowing users to adjust the visual spacing and speed.

3.  **Detailed Timer Elements**:
    *   **Icon**: Shows the spell or event icon provided by DBM.
    *   **Cooldown Text**: Displays a numerical countdown (e.g., "03.1"). The text turns red when the remaining time is 3 seconds or less.
    *   **Descriptive Label**: Shows the DBM timer message (e.g., "Boss Ability Name"). This label can be prefixed with a type (e.g., "[AOE]", "[Interrupt]") and color-coded based on DBM's timer categories.
    *   **Raid Target Icons**: If a timer is associated with a specific unit (often from nameplate timers) that has a raid target icon (skull, cross, etc.), this icon is displayed next to the timer label.

4.  **Color-Coded Timer Types**:
    *   Timer labels are colored according to DBM's classification of the timer (e.g., Add, AOE, Targeted, Interrupt, Role, Phase, Important).
    *   Specific color schemes are defined for both English and Korean client locales.

5.  **Filtering and Management**:
    *   Timers are only displayed if their remaining duration is below a configurable threshold (`ns.options.MinTimetoShow` - likely managed by `asMOD` or a shared options panel).
    *   Timers associated with units that die are automatically removed.
    *   A maximum number of simultaneously displayed timers can be set (`ADBMT_MaxButtons`).

6.  **Auditory Alert for AOE**:
    *   Optionally plays a sound alert when an AOE-classified DBM timer is about to expire (configurable threshold `ns.options.AOESound`).
    *   Uses different sound files for English and Korean locales.

7.  **Customization (via `asDBMTimer.lua` and `asMOD` options)**:
    *   **Visuals**: Font, font sizes, font outline, icon size, overall frame position (`ADBMT_X`, `ADBMT_Y`), vertical scaling of the timeline (`ADBMT_1sHeight`).
    *   **Behavior**: Maximum number of timers to display.
    *   **Integration**: If `asMOD` is installed, the main frame's position can be adjusted via `asMOD`'s configuration. Some options like `MinTimetoShow` and `AOESound` are likely managed through `asMOD`'s shared options system (`ns.options`).

8.  **Tooltip Support**:
    *   Hovering over a timer's icon will display the standard game tooltip for the associated spell, if applicable.

## Configuration Variables (primarily in `asDBMTimer.lua`)

*   `ADBMT_Font`, `ADBMT_CoolFontSize`, `ADBMT_NameFontSize`, `ADBMT_FontOutline`: Font settings for text elements.
*   `ADBMT_MaxButtons`: Maximum number of timers to display at once.
*   `ADBMT_1sHeight`: Defines how many pixels of vertical space correspond to one second of timer duration.
*   `ADBMT_IconSize`: The size of the timer icons.
*   `ADBMT_X`, `ADBMT_Y`: Default X and Y coordinates for the main timer frame anchor.
*   `BarColors`: Lua table defining the RGB colors and text prefixes for different DBM timer categories.
*   `AOEVoice`: Path to the sound file for AOE timer alerts.

---

# asDBMTimer

asDBMTimer는 Deadly Boss Mods (DBM) 타이머에 대한 설정 가능한 시각적 표시를 제공하며, 화면에 동적 수직 타임라인으로 배열합니다.

## 주요 기능

1.  **DBM 타이머 시각화**:
    *   DBM과 연동하여 표준 DBM 타이머 및 DBM의 이름표 전용 타이머 모두에 대한 타이머 이벤트(시작, 중지, 업데이트)를 포착합니다.
    *   이러한 타이머를 아이콘 목록으로 표시하며, 각 아이콘에는 재사용 대기시간 카운트다운과 설명 레이블이 함께 제공됩니다.

2.  **수직 타임라인 표시**:
    *   타이머는 화면에 수직으로 배열됩니다.
    *   각 타이머 아이콘의 수직 위치는 남은 지속 시간을 동적으로 나타냅니다. 시간이 지남에 따라 아이콘은 아래로 이동합니다.
    *   1초의 재사용 대기시간을 나타내는 화면 높이의 양은 (`ADBMT_1sHeight`) 설정 가능하여 사용자가 시각적 간격과 속도를 조정할 수 있습니다.

3.  **상세 타이머 요소**:
    *   **아이콘**: DBM에서 제공하는 주문 또는 이벤트 아이콘을 표시합니다.
    *   **재사용 대기시간 텍스트**: 숫자 카운트다운(예: "03.1")을 표시합니다. 남은 시간이 3초 이하일 때 텍스트가 빨간색으로 바뀝니다.
    *   **설명 레이블**: DBM 타이머 메시지(예: "보스 기술 이름")를 표시합니다. 이 레이블에는 유형(예: "[광역]", "[차단]")이 접두사로 붙을 수 있으며 DBM의 타이머 범주에 따라 색상으로 구분될 수 있습니다.
    *   **공격대 대상 아이콘**: 타이머가 특정 유닛(종종 이름표 타이머에서 유래)과 연관되어 있고 해당 유닛에 공격대 대상 아이콘(해골, X자 등)이 있는 경우, 이 아이콘이 타이머 레이블 옆에 표시됩니다.

4.  **색상으로 구분된 타이머 유형**:
    *   타이머 레이블은 DBM의 타이머 분류(예: 쫄, 광역, 대상 지정, 차단, 역할, 단계, 중요)에 따라 색상이 지정됩니다.
    *   영어 및 한국어 클라이언트 로케일 모두에 대해 특정 색상 구성표가 정의되어 있습니다.

5.  **필터링 및 관리**:
    *   타이머는 남은 지속 시간이 설정 가능한 임계값(`ns.options.MinTimetoShow` - `asMOD` 또는 공유 옵션 패널에서 관리될 가능성이 높음) 미만인 경우에만 표시됩니다.
    *   죽은 유닛과 관련된 타이머는 자동으로 제거됩니다.
    *   동시에 표시되는 최대 타이머 수 (`ADBMT_MaxButtons`)를 설정할 수 있습니다.

6.  **광역 기술에 대한 청각 알림**:
    *   선택적으로 광역으로 분류된 DBM 타이머가 만료되기 직전(설정 가능한 임계값 `ns.options.AOESound`)에 사운드 알림을 재생합니다.
    *   영어 및 한국어 로케일에 대해 다른 사운드 파일을 사용합니다.

7.  **사용자 설정 (`asDBMTimer.lua` 및 `asMOD` 옵션을 통해)**:
    *   **시각적 요소**: 글꼴, 글꼴 크기, 글꼴 외곽선, 아이콘 크기, 전체 프레임 위치 (`ADBMT_X`, `ADBMT_Y`), 타임라인의 수직 배율 (`ADBMT_1sHeight`).
    *   **동작**: 표시할 최대 타이머 수.
    *   **연동**: `asMOD`가 설치된 경우, 메인 프레임의 위치는 `asMOD`의 설정을 통해 조정할 수 있습니다. `MinTimetoShow` 및 `AOESound`와 같은 일부 옵션은 `asMOD`의 공유 옵션 시스템 (`ns.options`)을 통해 관리될 가능성이 높습니다.

8.  **툴팁 지원**:
    *   타이머 아이콘 위에 마우스를 올리면 해당 주문에 대한 표준 게임 툴팁(해당되는 경우)이 표시됩니다.

## 설정 변수 (주로 `asDBMTimer.lua`에 있음)

*   `ADBMT_Font`, `ADBMT_CoolFontSize`, `ADBMT_NameFontSize`, `ADBMT_FontOutline`: 텍스트 요소에 대한 글꼴 설정.
*   `ADBMT_MaxButtons`: 한 번에 표시할 최대 타이머 수.
*   `ADBMT_1sHeight`: 타이머 지속 시간 1초에 해당하는 수직 공간의 픽셀 수를 정의합니다.
*   `ADBMT_IconSize`: 타이머 아이콘의 크기.
*   `ADBMT_X`, `ADBMT_Y`: 메인 타이머 프레임 앵커의 기본 X 및 Y 좌표.
*   `BarColors`: 다양한 DBM 타이머 범주에 대한 RGB 색상 및 텍스트 접두사를 정의하는 Lua 테이블.
*   `AOEVoice`: 광역 타이머 알림용 사운드 파일 경로.
