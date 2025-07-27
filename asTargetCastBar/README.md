# asTargetCastBar

This addon provides a separate cast bar for your current target and focus target.
![asTargetCastBar](https://github.com/aspilla/asMOD/blob/main/.Pictures/asTargetCastBar.jpg?raw=true)

## Main Features

*   **Target Cast Bar**: Displays the spell information that the current target is casting.
*   **Focus Target Cast Bar**: Displays the spell information that the current focus target is casting.
*   **Spell Information**: Displays the spell icon, spell name, and cast time (`current/total`).
*   **Target of Target**: If the target is casting a spell on another player, the name of that player is displayed in their class color.
*   **Color-coded Interruptibility**:
    *   The color of the cast bar changes depending on whether the spell can be interrupted and whether it is targeting you.
    *   **Uninterruptible, targeting self**: Red
    *   **Uninterruptible, targeting others**: Gray
    *   **Interruptible, targeting self**: Green
    *   **Interruptible, targeting others**: Light Green
*   **DBM Integration**: For dangerous spells that DBM detects as needing to be interrupted, a flashing border emphasis effect is displayed on the cast bar.

## Settings

*   `ShowFocus`: Whether to show the focus target cast bar (default true)
*   `FocusCastScale`: The size scale of the focus target cast bar (default 1.2)
*   If the `asMOD` addon is installed, you can save the position with the `/asconfig` command.

---

# asTargetCastBar

현재 대상 및 주시 대상의 시전 바를 별도로 표시해주는 기능을 제공합니다.
![asTargetCastBar](https://github.com/aspilla/asMOD/blob/main/.Pictures/asTargetCastBar.jpg?raw=true)

## 주요 기능

*   **대상 시전 바**: 현재 대상이 시전하는 주문 정보를 표시.
*   **주시 대상 시전 바**: 현재 대상이 시전하는 주문 정보를 표시.
*   **주문 정보**: 주문 아이콘, 주문 이름, 시전 시간 (`현재/전체`)을 표시.
*   **대상의 대상**: 대상이 다른 플레이어를 대상으로 주문을 시전할 경우, 해당 플레이어의 이름을 직업 색상으로 표시.
*   **차단 가능 여부 색상 구분**:
    *   주문의 차단 가능 여부와 자신을 대상으로 하는지에 따라 시전 바의 색상이 변경.
    *   **차단 불가능, 자신 대상**: 붉은색
    *   **차단 불가능, 타인 대상**: 회색
    *   **차단 가능, 자신 대상**: 녹색
    *   **차단 가능, 타인 대상**: 밝은 녹색
*   **DBM 연동**: DBM이 감지하는 차단이 필요한 위험한 주문의 경우 시전 바에 테두리가 빤짝이는 강조 효과가 표시.

## 설정

*   `ShowFocus`: 주시 대상 시전 바 표시 여부 (기본 true)
*   `FocusCastScale`: 주시 대상 시전 바 크기 배율 (기본 1.2)
*   `asMOD` 애드온이 설치된 경우, `/asconfig` 명령어로 위치를 저장할 수 있습니다.