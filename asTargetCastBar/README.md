# asTargetCastBar

asTargetCastBar displays a separate cast bar for your current target and focus.
![asTargetCastBar](https://github.com/aspilla/asMOD/blob/main/.Pictures/asTargetCastBar.jpg?raw=true)

## Main Features

*   **Target Cast Bar**: Displays spell information for the current target.
*   **Focus Cast Bar**: Displays spell information for the focus target.
*   **Spell Information**: Shows spell icon, spell name, and cast time (`current/total`).
*   **Target's Target**: If the target is casting on another player, their name is displayed in their class color.
*   **Color-Coded Interrupt Status**:
    *   The cast bar color changes based on whether the spell is interruptible and if it's targeting you.
    *   **Uninterruptible, on you**: Dark Pink/Purple
    *   **Uninterruptible, on other**: Grey
    *   **Interruptible, on you**: Green
    *   **Interruptible, on other**: Light Green/Yellow
*   **DBM Integration**: A glowing border highlights the cast bar for dangerous spells that need to be interrupted, as detected by DBM.
*   **Movable & Savable**:
    *   The cast bars can be moved anywhere on the screen.
    *   If the `asMOD` addon is installed, you can save the position using the `/asconfig` command.
*   **Tooltip**: Hovering over the cast bar shows the spell's tooltip.

## Configuration

*   `ShowFocus`: Toggles the display of the focus cast bar (Default: true)
*   `FocusCastScale`: Sets the size scale of the focus cast bar (Default: 1.2)

**Note**: With the `asMOD` addon, you can easily adjust and save the position in-game.

---

# asTargetCastBar

asTargetCastBar는 현재 대상 및 주시 대상의 시전 바를 별도로 표시해주는 기능을 제공합니다.
![asTargetCastBar](https://github.com/aspilla/asMOD/blob/main/.Pictures/asTargetCastBar.jpg?raw=true)

## 주요 기능

*   **대상 시전 바**: 현재 대상이 시전하는 주문 정보를 표시합니다.
*   **주시 대상 시전 바**: 현재 대상이 시전하는 주문 정보를 표시합니다.
*   **주문 정보**: 주문 아이콘, 주문 이름, 시전 시간 (`현재/전체`)을 표시합니다.
*   **대상의 대상**: 대상이 다른 플레이어를 대상으로 주문을 시전할 경우, 해당 플레이어의 이름을 직업 색상으로 표시합니다.
*   **차단 가능 여부 색상 구분**:
    *   주문의 차단 가능 여부와 자신을 대상으로 하는지에 따라 시전 바의 색상이 변경됩니다.
    *   **차단 불가능, 자신 대상**: 어두운 분홍색/보라색
    *   **차단 불가능, 타인 대상**: 회색
    *   **차단 가능, 자신 대상**: 녹색
    *   **차단 가능, 타인 대상**: 밝은 녹색/노란색
*   **DBM 연동**: DBM이 감지하는 차단이 필요한 위험한 주문의 경우 시전 바에 테두리가 빤짝이는 강조 효과가 표시 됩니다.
*   **이동 및 설정 저장**:
    *   시전 바를 화면 원하는 곳으로 이동할 수 있습니다.
    *   `asMOD` 애드온이 설치된 경우, `/asconfig` 명령어로 위치를 저장할 수 있습니다.
*   **툴팁 표시**: 시전 바에 마우스를 올리면 해당 주문의 툴팁이 표시됩니다.

## 설정

*   `ShowFocus`: 주시 대상 시전 바 표시 여부 (기본 true)
*   `FocusCastScale`: 주시 대상 시전 바 크기 배율 (기본 1.2)

**참고**: `asMOD` 애드온을 사용하면 게임 내에서 위치를 더 쉽게 조정하고 저장할 수 있습니다.
