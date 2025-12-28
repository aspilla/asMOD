# asTargetCastBar (Midnight)

Displays the casting bars for your current Target and Focus.
![asTargetCastBar](https://github.com/aspilla/asMOD/blob/main/.Pictures/asTargetCastBar.jpg?raw=true)

## Key Features

* **Target & Focus Tracking**: Displays casting bars for both your target and focus unit.
* **Detailed Spell Info**: Shows the spell icon, spell name, and cast time progress (`Current / Total`).
* **Target of Target**: Displays the name of the player being targeted by the spell, highlighted in their respective **Class Color**.
* **Interrupt Visuals**: The cast bar color changes dynamically based on interruptibility and threat:
    * **Non-interruptible**: Gray bar.
    * **Interruptible**: Bright Green bar.

## Configuration

### General Settings
You can customize the following variables within the script or settings:
* `ShowFocus`: Toggle display for the Focus cast bar (Default: true).
* `FocusCastScale`: Adjust the scale of the Focus cast bar (Default: 1.2).
* If the **asMOD** addon is installed, you can unlock, move, and save the positions of the cast bars using the following command: `/asConfig`

---

# asTargetCastBar (한밤)

현재 대상 및 주시 대상의 시전 바를 표시
![asTargetCastBar](https://github.com/aspilla/asMOD/blob/main/.Pictures/asTargetCastBar.jpg?raw=true)

## 주요 기능

*   **대상/주시 대상 표시**
*   **주문 정보**: 주문 아이콘, 주문 이름, 시전 시간 (`현재/전체`)을 표시.
*   **대상의 대상**: 주문 대상 플레이어의 이름을 직업 색상 표시.
*   **차단 가능 여부 색상 구분**:
    *   주문의 차단 가능 여부와 자신을 대상으로 하는지에 따라 시전 바의 색상이 변경.
    *   **차단 불가능**: 회색
    *   **차단 가능**: 밝은 녹색

## 설정
*   `ShowFocus`: 주시 대상 시전 바 표시 여부 (기본 true)
*   `FocusCastScale`: 주시 대상 시전 바 크기 배율 (기본 1.2)
*   `asMOD` 애드온이 설치된 경우, `/asconfig` 명령어로 위치를 저장할 수 있습니다.