# asTargetCastBar (Midnight)

Cast bar for Target and Focus targets.

![asTargetCastBar](https://github.com/aspilla/asMOD/blob/main/.Pictures/asTargetCastBar_MN.jpg?raw=true)

## Key Features

* **Target/Focus Display**: Shows cast bars for both your current target and your focus target.
* **Spell Information**: Displays the spell icon, spell name, and cast time (`Current/Total`).
* **Target of Target**: Shows the name of the player being targeted by the spell in their respective class color.
* **Raid Markers**: Displays the raid marker of the casting unit.
* **Interruptibility Color Coding**:
    * The cast bar color changes based on whether the spell can be interrupted and who it is targeting.
    * **Uninterruptible**: Gray
    * **Interruptible**: Bright Green
* **Highlight Important Spells**: Displays a red border for critical skills.

![asTargetCastBar](https://github.com/aspilla/asMOD/blob/main/.Pictures/asTargetCastBar_important.gif?raw=true)

* **Target Aggro Indicator**: Flashes red or yellow exclamation marks on the right side when you are being targeted by a mob.

## Configuration
* `ShowTarget`: Toggle display of the Target cast bar (Default: true).
* `ShowFocus`: Toggle display of the Focus target cast bar (Default: true).
* `FocusCastScale`: Adjust the size scale of the Focus target cast bar (Default: 1.2).
* **Move Position**: Enter the `/asConfig` command in the chat.
* **Reset Position**: Enter the `/asClear` command in the chat to restore default settings.

---

# asTargetCastBar (한밤)

대상/주시대상 시전 바

![asTargetCastBar](https://github.com/aspilla/asMOD/blob/main/.Pictures/asTargetCastBar_MN.jpg?raw=true)

## 주요 기능

*   **대상/주시 대상 표시**
*   **주문 정보**: 주문 아이콘, 주문 이름, 시전 시간 (`현재/전체`)을 표시.
*   **대상의 대상**: 주문 대상 플레이어의 이름을 직업 색상 표시.
*   **징표**: 케스팅 몹의 징표 표시
*   **차단 가능 여부 색상 구분**
    *   주문의 차단 가능 여부와 자신을 대상으로 하는지에 따라 시전 바의 색상이 변경.
    *   **차단 불가능**: 회색
    *   **차단 가능**: 밝은 녹색
*   **중요 스킬 강조**: 중요 시킬 시 빨간색 태두리 표시

![asTargetCastBar](https://github.com/aspilla/asMOD/blob/main/.Pictures/asTargetCastBar_important.gif?raw=true)

*   **내가 대상일 경우 강조**: 내가 대상일 경우 우측에 빨간색/노란색 느낌표 점멸

## 설정
*   `ShowTarget`: 대상 시전 바 표시 여부 (기본 true)
*   `ShowFocus`: 주시 대상 시전 바 표시 여부 (기본 true)
*   `FocusCastScale`: 주시 대상 시전 바 크기 배율 (기본 1.2)
*  **위치 이동** : `/asConfig` 명령어 채팅창에 입력
*  **위치 초기화** : `/asClear` 명령어 채팅창에 입력, 기본 설정으로 초기화 