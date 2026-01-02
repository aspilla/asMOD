# asTargetCastBar (Midnight)

Cast bar for Target and Focus targets.

![asTargetCastBar](https://github.com/aspilla/asMOD/blob/main/.Pictures/asTargetCastBar_MN.jpg?raw=true)

## Key Features

* **Target/Focus Display**: Shows cast bars for both your current target and your focus target.
* **Spell Information**: Displays the spell icon, spell name, and cast time (`Current/Total`).
* **Target of Target**: Shows the name of the player being targeted by the spell in their respective class color.
* **Raid Markers**: Displays the raid marker of the casting unit.
* **Voice Alerts**: Provides voice notifications when an interrupt or stun is required.
* **Interruptibility Color Coding**:
    * The cast bar color changes based on whether the spell can be interrupted and who it is targeting.
    * **Uninterruptible**: Gray
    * **Interruptible**: Bright Green

## Configuration
* `ShowFocus`: Toggle display of the Focus target cast bar (Default: true).
* `FocusCastScale`: Adjust the size scale of the Focus target cast bar (Default: 1.2).
* `PlaySoundKick`: Voice alert when an interrupt (Kick) is needed (Default: On).
* `PlaySoundStun`: Voice alert when a stun is needed (Default: Off).
* If the `asMOD` addon is installed, you can save the position of the bars using the `/asconfig` command.

---

# asTargetCastBar (한밤)

대상/주시대상 시전 바

![asTargetCastBar](https://github.com/aspilla/asMOD/blob/main/.Pictures/asTargetCastBar_MN.jpg?raw=true)

## 주요 기능

*   **대상/주시 대상 표시**
*   **주문 정보**: 주문 아이콘, 주문 이름, 시전 시간 (`현재/전체`)을 표시.
*   **대상의 대상**: 주문 대상 플레이어의 이름을 직업 색상 표시.
*   **징표**: 케스팅 몹의 징표 표시
*   **음성 알림**: 차단 필요/스턴 필요시 음성 알림 
*   **차단 가능 여부 색상 구분**:
    *   주문의 차단 가능 여부와 자신을 대상으로 하는지에 따라 시전 바의 색상이 변경.
    *   **차단 불가능**: 회색
    *   **차단 가능**: 밝은 녹색

## 설정
*   `ShowFocus`: 주시 대상 시전 바 표시 여부 (기본 true)
*   `FocusCastScale`: 주시 대상 시전 바 크기 배율 (기본 1.2)
*   `PlaySoundKick` : 차단 필요시 음성 알림 (기본 On)
*   `PlaySoundStun` : 스턴 필요시 음성 알림 (기본 Off)
*   `asMOD` 애드온이 설치된 경우, `/asconfig` 명령어로 위치를 저장할 수 있습니다.