# asTargetCastBar

asTargetCastBar is a World of Warcraft addon that displays a dedicated, movable cast bar for your current target. It provides visual cues for spell interruptibility, whether the spell is targeting you, and integrates with DBM to highlight dangerous spells.

## Main Features

*   **Dedicated Target Cast Bar**: Shows a clear cast bar for any spell or channel being cast by your current target.
*   **Visual Information**:
    *   **Spell Icon**: Displays the icon of the spell being cast.
    *   **Spell Name**: Shows the name of the spell.
    *   **Cast Time**: Displays numerical `current / total` cast time.
    *   **Target's Target**: If your target is casting at another player, that player's name is shown below the cast bar, colored by their class.
*   **Color-Coded Interrupt Status**:
    *   The cast bar changes color based on:
        *   Whether the spell is interruptible or not.
        *   Whether the spell is being cast on you (the player).
    *   Default colors help quickly identify threat and interrupt opportunities:
        *   Dark Pink/Purple: Uninterruptible, targeting you.
        *   Grey: Uninterruptible, not targeting you.
        *   Green: Interruptible, targeting you.
        *   Light Green/Yellow: Interruptible, not targeting you.
*   **DBM Integration for Dangerous Spells**:
    *   If DBM (Deadly Boss Mods) is installed, the addon scans DBM's data.
    *   If your target is casting a spell that DBM flags as a dangerous "interrupt" type, a pixel glow animation will highlight the cast bar.
*   **Movable Frame**:
    *   The cast bar can be repositioned on the screen.
    *   If the `asMOD` addon is installed, its position can be managed and saved via `asMOD`'s configuration system.
*   **Tooltip on Hover**: Shows the game's spell tooltip when you mouse over the cast bar.

## How it Works

1.  The addon creates a status bar for the cast progress and a button frame for the spell icon.
2.  It listens to `UNIT_SPELLCAST_*` events for your current target.
3.  When the target begins casting:
    *   It populates the bar with the spell's icon, name, and time.
    *   It determines the appropriate color for the bar based on interruptibility and if the player is the target of the spell.
    *   It checks against DBM's dangerous spell list and applies a glow if necessary.
    *   It shows the target's target if it's a player.
4.  The bar updates its progress via a periodic timer and event updates.
5.  When the cast ends or is interrupted, the bar is hidden.

## Configuration

Basic configuration is done by editing Lua variables at the top of `asTargetCastBar/asTargetCastBar.lua`:

*   `ATCB_WIDTH`: Width of the cast bar (excluding the icon width). (Default: 180)
*   `ATCB_HEIGHT`: Height of the cast bar. (Default: 17)
*   `ATCB_X`, `ATCB_Y`: Default X and Y offsets from the screen center for the cast bar's anchor. (Defaults: 0, -100)
*   `ATCB_ALPHA`: Transparency of the cast bar. (Default: 0.8)
*   `ATCB_NAME_SIZE`, `ATCB_TIME_SIZE`: Font sizes for spell name and time text, relative to bar height.
*   `CONFIG_*_COLOR` variables: Define the RGB colors for the different interrupt/target states.

If `asMOD` is installed, the position of the bar ("asTargetCastBar") can be more easily adjusted and saved using `asMOD`'s interface. The glow effects are provided by `asTargetCastBarLib.lua`.

**Note**: This addon does not provide an in-game configuration panel for these settings without `asMOD`.

---

# asTargetCastBar

asTargetCastBar는 현재 대상의 시전 바를 전용으로 표시하며 이동 가능한 월드 오브 워크래프트 애드온입니다. 주문 차단 가능성, 주문이 자신을 대상으로 하는지 여부에 대한 시각적 신호를 제공하며, DBM과 연동하여 위험한 주문을 강조 표시합니다.

## 주요 기능

*   **전용 대상 시전 바**: 현재 대상이 시전하는 모든 주문 또는 채널링 주문에 대한 명확한 시전 바를 표시합니다.
*   **시각 정보**:
    *   **주문 아이콘**: 시전 중인 주문의 아이콘을 표시합니다.
    *   **주문 이름**: 주문의 이름을 표시합니다.
    *   **시전 시간**: 숫자 형식의 `현재 / 전체` 시전 시간을 표시합니다.
    *   **대상의 대상**: 대상이 다른 플레이어에게 주문을 시전하는 경우, 해당 플레이어의 이름이 시전 바 아래에 직업 색상으로 표시됩니다.
*   **색상으로 구분된 차단 상태**:
    *   시전 바는 다음 기준에 따라 색상이 변경됩니다:
        *   주문 차단 가능 여부.
        *   주문이 자신(플레이어)을 대상으로 하는지 여부.
    *   기본 색상은 위협 및 차단 기회를 빠르게 식별하는 데 도움이 됩니다:
        *   어두운 분홍색/보라색: 차단 불가능, 자신 대상.
        *   회색: 차단 불가능, 자신이 대상 아님.
        *   녹색: 차단 가능, 자신 대상.
        *   밝은 녹색/노란색: 차단 가능, 자신이 대상 아님.
*   **DBM 연동 (위험 주문)**:
    *   DBM (Deadly Boss Mods)이 설치된 경우, 애드온은 DBM 데이터를 스캔합니다.
    *   대상이 DBM이 위험한 "차단" 유형으로 지정한 주문을 시전하는 경우, 픽셀 강조 애니메이션이 시전 바를 강조 표시합니다.
*   **이동 가능한 프레임**:
    *   시전 바는 화면에서 위치를 변경할 수 있습니다.
    *   `asMOD` 애드온이 설치된 경우, 해당 위치는 `asMOD`의 설정 시스템을 통해 관리하고 저장할 수 있습니다.
*   **마우스오버 시 툴팁**: 시전 바에 마우스를 올리면 게임의 주문 툴팁을 표시합니다.

## 작동 방식

1.  애드온은 시전 진행을 위한 상태 바와 주문 아이콘을 위한 버튼 프레임을 생성합니다.
2.  현재 대상에 대한 `UNIT_SPELLCAST_*` 이벤트를 수신합니다.
3.  대상이 시전을 시작하면:
    *   주문의 아이콘, 이름 및 시간으로 바를 채웁니다.
    *   차단 가능성 및 플레이어가 주문의 대상인지 여부에 따라 바의 적절한 색상을 결정합니다.
    *   DBM의 위험 주문 목록과 대조하여 필요한 경우 강조 효과를 적용합니다.
    *   대상의 대상이 플레이어인 경우 이를 표시합니다.
4.  바는 주기적인 타이머 및 이벤트 업데이트를 통해 진행 상황을 업데이트합니다.
5.  시전이 종료되거나 중단되면 바가 숨겨집니다.

## 설정

기본 설정은 `asTargetCastBar/asTargetCastBar.lua` 파일 상단의 Lua 변수를 편집하여 수행합니다:

*   `ATCB_WIDTH`: 시전 바의 너비 (아이콘 너비 제외). (기본값: 180)
*   `ATCB_HEIGHT`: 시전 바의 높이. (기본값: 17)
*   `ATCB_X`, `ATCB_Y`: 시전 바 앵커의 화면 중앙으로부터의 기본 X 및 Y 오프셋. (기본값: 0, -100)
*   `ATCB_ALPHA`: 시전 바의 투명도. (기본값: 0.8)
*   `ATCB_NAME_SIZE`, `ATCB_TIME_SIZE`: 주문 이름 및 시간 텍스트의 글꼴 크기 (바 높이 기준).
*   `CONFIG_*_COLOR` 변수: 다양한 차단/대상 상태에 대한 RGB 색상을 정의합니다.

`asMOD`가 설치된 경우, "asTargetCastBar" 바의 위치는 `asMOD`의 인터페이스를 사용하여 더 쉽게 조정하고 저장할 수 있습니다. 강조 효과는 `asTargetCastBarLib.lua`에서 제공됩니다.

**참고**: 이 애드온은 `asMOD` 없이는 이러한 설정을 위한 게임 내 설정 패널을 제공하지 않습니다.
