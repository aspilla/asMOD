# asInterruptHelper (Midnight)

Displays cooldowns for interrupt and stun skills.

For Focus/Target:
![asInterruptHelper(Target/Focus)](https://github.com/aspilla/asMOD/blob/main/.Pictures/asInterruptHelper_target.jpg?raw=true)   

For Mouseover targets:
![asInterruptHelper(Mouseover)](https://github.com/aspilla/asMOD/blob/main/.Pictures/asInterruptHelper.jpg?raw=true)   

## Key Features

* **Recommended for use with `asTargetCastBar`**:
    * Displays interruptible skills above the cast bars of your Focus and Target.
    * Displays skills above the mouse cursor when hovering over a target.
* **When an interruptible spell is cast**:
    * Displays the primary interrupt skill. If the interrupt skill is on cooldown, it displays stun skills (for mobs of equal level).
* **When an uninterruptible spell is cast**:
    * Displays stun skills for eligible mobs (mobs of equal level).
* **Skill Priority**:
    * Skills with shorter cooldowns have higher priority. (If cooldowns are equal, the skill with the lower ID is prioritized).
* **Voice Alerts**: Provides voice notifications when an interrupt or stun is required.

## Configuration

The following settings can be adjusted via `ESC` > `Options` > `Addons` > `asInterruptHelper`:

* `ShowTarget`: Toggle display for the current target.
* `ShowFocus`: Toggle display for the focus target.
* `ShowMouseOver`: Toggle display for the mouseover target.
* `PlaySoundKick`: Voice alert when an interrupt is needed (Default: On).
* `PlaySoundStun`: Voice alert when a stun is needed (Default: Off).
* **Positioning**: Enter the `/asConfig` command in the chat.
* **Reset Position**: Enter the `/asClear` command in the chat to restore default settings.

---

# asInterruptHelper (한밤)

차단/스턴 스킬 쿨다운 표시

주시/대상의 경우
![asInterruptHelper(Target/Focus)](https://github.com/aspilla/asMOD/blob/main/.Pictures/asInterruptHelper_target.jpg?raw=true)   

마우스 오버 대상의 경우
![asInterruptHelper(Mouseover)](https://github.com/aspilla/asMOD/blob/main/.Pictures/asInterruptHelper.jpg?raw=true)   

## 주요 기능

*   **asTargetCastBar 와 같이 사용 추천**:
    * 주시대상, 대상 케스팅바 위에 차단 가능 스킬을 표시
    * 마우스 오버 대상이 있는 경우 마우스 커서 위에 표시
*   **차단 가능 스킬 시전 시**:
    * 주 차단 스킬을 표시, 차단 스킬이 없는 경우 쿨일 경우 스턴이 가능한 몹 (Level이 동등한 몹) 인 경우 스턴 스킬을 표시.
*   **차단 불가 스킬 시전 시**:
    * 스턴이 가능한 몹 (Level이 동등한 몹) 인 경우 스턴 스킬을 표시.
*   **스킬 표시 우선 순위**:
    * 쿨이 짧은 스킬이 우선순위를 가짐. (쿨이 같은경우 ID 가 작은수 인 경우) 
*   **음성 알림**: 차단 필요/스턴 필요시 음성 알림     

## 설정

`ESC` > `설정` > `애드온` > `asInterruptHelper` 에서 다음 설정 변경 가능

*   `ShowTarget`: 대상 차단 스킬 표시 여부
*   `ShowFocus` : 주시 대상의 차단 스킬 표시 여부
*   `ShowMouseOver` : 마우스 오버 대상의 차단 스킬 표시 여부
*   `PlaySoundKick` : 차단 필요시 음성 알림 (기본 On)
*   `PlaySoundStun` : 스턴 필요시 음성 알림 (기본 Off)
*  **위치 이동** : `/asConfig` 명령어 채팅창에 입력
*  **위치 초기화** : `/asClear` 명령어 채팅창에 입력, 기본 설정으로 초기화 