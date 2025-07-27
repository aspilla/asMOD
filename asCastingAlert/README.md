# asCastingAlert

Displays an alert in the center of the screen for casting spells targeted at the player by hostile units.

![asCastingAlert](https://github.com/aspilla/asMOD/blob/main/.Pictures/asCastingAlert.jpg?raw=true)

## Key Features

1.  **Enemy Cast Notification**:
    *   Displays up to 3 spells being cast on the player by hostile units.
    *   Each entry shows the spell icon and the remaining cast time.

2.  **DBM Important Spell Highlight**:
    *   When using DBM, spells highlighted by DBM are emphasized in red.

3.  **Sound Notification**
    *   When you are the target of a hostile target's skill, a "Targeted" voice alert will sound.
    *   This can be turned off by adjusting the `PlaySound` option.
    *   For Tankers, the sound alert is off by default but can be enabled with the `PlaySoundTank` option.
    *   If `PlaySoundDBMOnly` is enabled, sound alerts will only play for DBM-tracked spells.
    *   If `PlaySoundGroupOnly` is disabled, sound alerts will play even when not in a party.

## Settings

The following settings can be configured under ESC >> Options >> AddOns >> asCastingAlert:
*   `PlaySound` (Default: true): Whether to play sound alerts.
*   `PlaySoundDBMOnly` (Default: false): Only play sound alerts for major DBM spells.
*   `PlaySoundTank` (Default: false): Whether to play sound alerts if you are a Tank.
*   `PlaySoundGroupOnly` (Default: true): Whether to play sound alerts only when in a party.

If the `asMOD` addon is installed, you can save the position with the `/asconfig` command.

The following settings can be adjusted in the `asCastingAlert.lua` file:
*   `ACTA_UpdateRate`: How often the addon checks for casting spells (in seconds).
*   `ACTA_MaxShow`: The maximum number of spell alerts to display simultaneously.
*   `ACTA_FontSize`: The font size for the spell name and timer.
*   `ACTA_X`, `ACTA_Y`: The X and Y coordinates for the center of the alert display.

---

# asCastingAlert

적대적 유닛이 플레이어를 대상으로 시전 주문에 대해 화면 중앙에 알림

![asCastingAlert](https://github.com/aspilla/asMOD/blob/main/.Pictures/asCastingAlert.jpg?raw=true)


## 주요 기능

1.  **적 시전 알림**:
    *   적대적 유닛이 플래이어에게 시전 중인 주문을 최대 3개 까지 표시  
    *   각 항목에는 주문 아이콘과 남은 시전 시간이 표시됩니다.

2.  **DBM 주요 주문 강조**:
    *   DBM 사용 시 DBM이 강조하는 주문을 빨간색으로 강조

3.  **음성 알림**
    * 적대적 대상의 스킬의 대상이 될 경우 "Targeted" 라고 음성 알림 됩니다.
    * `PlaySound` 옵션조정으로 끌수 있습니다.
    * Tanker의 경우 음성알림이 Off되며, `PlaySoundTank` 옵션으로 킬수 있습니다.
    * `PlaySoundDBMOnly` 옵션을 키면 DBM 시전에 대해서만 음성 알림이 됩니다.
    * `PlaySoundGroupOnly` 옵션을 끄면 파티중이 아닐때도 음성 알림이 됩니다.


## 설정

esc >> 설정 >> 애드온 >> asCastingAlert 에서 다음 설정이 가능합니다.
*   `PlaySound` (기본값: true) : 음성 알림을 할지 여부
*   `PlaySoundDBMOnly` (기본값: false): DBM 주요 음성만 음성 알림
*   `PlaySoundTank` (기본값: false): Tank 일경우 음성 알림 여부
*   `PlaySoundGroupOnly` (기본값: true): 파티 일경우 음성 알림 여부

 `asMOD` 애드온이 설치된 경우, `/asconfig` 명령어로 위치를 저장할 수 있습니다.

`asCastingAlert.lua` 파일에서 다음 설정을 조정할 수 있습니다.
*   `ACTA_UpdateRate`: 애드온이 시전 주문을 확인하는 빈도 (초 단위).
*   `ACTA_MaxShow`: 동시에 표시할 최대 주문 알림 수.
*   `ACTA_FontSize`: 주문 이름 및 타이머의 글꼴 크기.
*   `ACTA_X`, `ACTA_Y`: 알림 표시 중앙의 X 및 Y 좌표.
