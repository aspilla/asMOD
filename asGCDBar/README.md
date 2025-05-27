# asGCDBar

asGCDBar is a World of Warcraft addon that displays a simple status bar to visualize the player's Global Cooldown (GCD).

## Main Features

*   **Visual GCD Indicator**: Shows a customizable bar that fills up during the Global Cooldown, providing a clear visual cue for when your next action can be taken.
*   **Customizable Appearance**: The width, height, and on-screen position of the GCD bar can be adjusted by editing variables in the Lua file.
*   **asMOD Integration**: If the `asMOD` addon is installed, `asGCDBar` can integrate with it, allowing its position to be managed and saved through `asMOD`'s configuration interface.
*   **Simple Design**: Uses a clean bar with a background texture for a border effect.

## How it Works

1.  The addon creates a `StatusBar` element.
2.  It periodically checks the player's Global Cooldown status using `C_Spell.GetSpellCooldown(61304)`. (Spell ID 61304 is commonly used to track GCD).
3.  When the GCD is active, the bar animates from empty to full over the duration of the GCD.
4.  When the GCD is not active, the bar is hidden.

## Configuration

Basic configuration is done by editing variables at the top of `asGCDBar/asGCDBar.lua`:

*   `AGCDB_WIDTH`: Sets the width of the GCD bar in pixels. (Default: 196)
*   `AGCDB_HEIGHT`: Sets the height of the GCD bar in pixels. (Default: 5)
*   `AGCDB_X`: The horizontal (X) offset from the center of the screen. (Default: 0)
*   `AGCDB_Y`: The vertical (Y) offset from the center of the screen. (Default: -284, typically placing it below the center)

The bar's color can also be changed by modifying the `SetStatusBarColor(1, 0.9, 0.9)` line in the Lua file (RGB values).

If `asMOD` is installed, the position of the bar can be more easily adjusted and saved using `asMOD`'s `/asConfig` command or similar interface.

**Note**: This addon does not provide an in-game configuration panel for these settings without `asMOD`.

---

# asGCDBar

asGCDBar는 플레이어의 전역 재사용 대기시간(GCD)을 시각화하는 간단한 상태 바를 표시하는 월드 오브 워크래프트 애드온입니다.

## 주요 기능

*   **시각적 GCD 표시기**: 전역 재사용 대기시간 동안 채워지는 사용자 정의 가능한 바를 표시하여 다음 행동을 언제 할 수 있는지 명확한 시각적 신호를 제공합니다.
*   **사용자 정의 가능한 외형**: Lua 파일의 변수를 편집하여 GCD 바의 너비, 높이 및 화면 위치를 조정할 수 있습니다.
*   **asMOD 연동**: `asMOD` 애드온이 설치된 경우, `asGCDBar`는 이와 연동하여 `asMOD`의 설정 인터페이스를 통해 위치를 관리하고 저장할 수 있도록 합니다.
*   **심플한 디자인**: 테두리 효과를 위한 배경 텍스처가 있는 깔끔한 바를 사용합니다.

## 작동 방식

1.  애드온은 `StatusBar` 요소를 생성합니다.
2.  `C_Spell.GetSpellCooldown(61304)`를 사용하여 주기적으로 플레이어의 전역 재사용 대기시간 상태를 확인합니다. (주문 ID 61304는 GCD를 추적하는 데 일반적으로 사용됩니다).
3.  GCD가 활성화되면 바는 GCD 지속 시간 동안 비어 있는 상태에서 가득 찬 상태로 애니메이션됩니다.
4.  GCD가 활성화되지 않으면 바는 숨겨집니다.

## 설정

기본 설정은 `asGCDBar/asGCDBar.lua` 파일 상단의 변수를 편집하여 수행합니다:

*   `AGCDB_WIDTH`: GCD 바의 너비를 픽셀 단위로 설정합니다. (기본값: 196)
*   `AGCDB_HEIGHT`: GCD 바의 높이를 픽셀 단위로 설정합니다. (기본값: 5)
*   `AGCDB_X`: 화면 중앙으로부터의 가로(X) 오프셋입니다. (기본값: 0)
*   `AGCDB_Y`: 화면 중앙으로부터의 세로(Y) 오프셋입니다. (기본값: -284, 일반적으로 중앙 아래에 위치)

바의 색상은 Lua 파일의 `SetStatusBarColor(1, 0.9, 0.9)` 줄을 수정하여 변경할 수도 있습니다 (RGB 값).

`asMOD`가 설치된 경우, `asMOD`의 `/asConfig` 명령 또는 유사한 인터페이스를 사용하여 바의 위치를 더 쉽게 조정하고 저장할 수 있습니다.

**참고**: 이 애드온은 `asMOD` 없이는 이러한 설정을 위한 게임 내 설정 패널을 제공하지 않습니다.
