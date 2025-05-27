# asFixCombatText

asFixCombatText is a World of Warcraft addon that provides customization options for Blizzard's default Floating Combat Text (FCT). It allows users to change the position, scroll behavior, colors, and visibility of certain combat text elements like damage and healing numbers.

## Main Features

*   **Custom Positioning**: Define the starting X and Y coordinates for where combat text appears and how far it scrolls vertically.
*   **Color Overrides**:
    *   Sets custom colors for various damage types (physical, spell, damage shield, split damage).
    *   Customizes colors for "Entering Combat" and "Leaving Combat" messages.
    *   Allows heal-related combat text (heals, absorbs) to be shown with a specific color, or hidden (controlled by a variable).
*   **Font Styling**: Sets the combat text font to the standard game font with an outline and a default size of 18.
*   **Optional Staggering**: Physical damage numbers can be configured to stagger horizontally for a more spread-out appearance.
*   **Healing Text Visibility**: Provides a toggle (`ASCT_DEFAULT_SHOW_HEAL`) to explicitly show or hide healing-related numbers via this addon's overrides.

## How it Works

The addon modifies Blizzard's internal combat text system:
1.  It ensures the `enableFloatingCombatText` CVar is active.
2.  It updates global variables that control combat text font size and height.
3.  It overrides the `COMBAT_TEXT_TYPE_INFO` table to apply custom colors and show/hide flags for specific event types.
4.  It sets a custom scroll function (`asCombatText_StandardScroll`) and defines the start/end coordinates for FCT scrolling, effectively fixing the text to a user-defined area of the screen.

## Configuration

Configuration is done by editing Lua variables at the top of the `asFixCombatText/asFixCombatText.lua` file:

*   `ASCT_X_POSITION`: The horizontal (X) screen coordinate where combat text will start. (Default: -250)
*   `ASCT_Y_POSITION`: The vertical (Y) screen coordinate where combat text will start. (Default: 550)
*   `ASCT_Y_POSITION_ADDER`: The vertical distance the combat text will scroll upwards. (Default: 200)
*   `ASCT_STAGGERED`: Set to `true` if you want physical damage numbers to spread out horizontally. Set to `false` for default vertical stacking. (Default: `false`)
*   `ASCT_DEFAULT_SHOW_HEAL`: Set to `1` if you want healing numbers (heals, absorbs) to be displayed by this addon's color settings. Set to `nil` or any other value to let Blizzard's default settings (or other addons) control their visibility, or hide them if no other system shows them. (Default: `nil`)
*   `DAMAGE_COLOR`, `SPELL_DAMAGE_COLOR`, etc.: RGB color values for different text types can be adjusted.

**Note**: This addon does not provide an in-game configuration panel. Changes require editing the `.lua` file.

---

# asFixCombatText

asFixCombatText는 블리자드의 기본 전투 상황 알림 텍스트(FCT)에 대한 사용자 설정 옵션을 제공하는 월드 오브 워크래프트 애드온입니다. 사용자는 피해량 및 치유량 숫자와 같은 특정 전투 텍스트 요소의 위치, 스크롤 동작, 색상 및 표시 여부를 변경할 수 있습니다.

## 주요 기능

*   **사용자 지정 위치**: 전투 텍스트가 나타나는 시작 X 및 Y 좌표와 수직으로 스크롤되는 거리를 정의합니다.
*   **색상 재정의**:
    *   다양한 피해 유형(물리, 주문, 피해 흡수 보호막, 분산 피해)에 대한 사용자 지정 색상을 설정합니다.
    *   "전투 시작" 및 "전투 종료" 메시지에 대한 색상을 사용자 지정합니다.
    *   치유 관련 전투 텍스트(치유, 흡수)를 특정 색상으로 표시하거나 변수를 통해 숨길 수 있도록 허용합니다.
*   **글꼴 스타일**: 전투 텍스트 글꼴을 외곽선이 있는 표준 게임 글꼴로 설정하고 기본 크기를 18로 지정합니다.
*   **선택적 시차 표시**: 물리 피해 숫자가 수평으로 약간씩 엇갈리게 표시되도록 설정하여 더 넓게 퍼져 보이게 할 수 있습니다.
*   **치유 텍스트 표시 여부**: 이 애드온의 재정의를 통해 치유 관련 숫자를 명시적으로 표시하거나 숨길 수 있는 토글(`ASCT_DEFAULT_SHOW_HEAL`)을 제공합니다.

## 작동 방식

애드온은 블리자드의 내부 전투 텍스트 시스템을 수정합니다:
1.  `enableFloatingCombatText` CVar가 활성화되어 있는지 확인합니다.
2.  전투 텍스트 글꼴 크기 및 높이를 제어하는 전역 변수를 업데이트합니다.
3.  특정 이벤트 유형에 대한 사용자 지정 색상 및 표시/숨김 플래그를 적용하기 위해 `COMBAT_TEXT_TYPE_INFO` 테이블을 재정의합니다.
4.  사용자 지정 스크롤 함수(`asCombatText_StandardScroll`)를 설정하고 FCT 스크롤의 시작/종료 좌표를 정의하여 텍스트를 사용자가 정의한 화면 영역에 효과적으로 고정합니다.

## 설정

설정은 `asFixCombatText/asFixCombatText.lua` 파일 상단의 Lua 변수를 편집하여 수행합니다:

*   `ASCT_X_POSITION`: 전투 텍스트가 시작될 화면의 가로(X) 좌표입니다. (기본값: -250)
*   `ASCT_Y_POSITION`: 전투 텍스트가 시작될 화면의 세로(Y) 좌표입니다. (기본값: 550)
*   `ASCT_Y_POSITION_ADDER`: 전투 텍스트가 위로 스크롤될 세로 거리입니다. (기본값: 200)
*   `ASCT_STAGGERED`: 물리 피해 숫자가 수평으로 엇갈리게 표시되기를 원하면 `true`로 설정합니다. 기본 수직 중첩의 경우 `false`로 설정합니다. (기본값: `false`)
*   `ASCT_DEFAULT_SHOW_HEAL`: 이 애드온의 색상 설정에 따라 치유 숫자(치유, 흡수)를 표시하려면 `1`로 설정합니다. 블리자드의 기본 설정(또는 다른 애드온)이 해당 숫자의 표시 여부를 제어하도록 하거나, 다른 시스템에서 표시하지 않는 경우 숨기려면 `nil` 또는 다른 값으로 설정합니다. (기본값: `nil`)
*   `DAMAGE_COLOR`, `SPELL_DAMAGE_COLOR` 등: 다양한 텍스트 유형에 대한 RGB 색상 값을 조정할 수 있습니다.

**참고**: 이 애드온은 게임 내 설정 패널을 제공하지 않습니다. 변경하려면 `.lua` 파일을 편집해야 합니다.
