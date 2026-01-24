# asInterruptHelper (Midnight)

Displays cooldowns for Interrupt and Stun skills.

<For Target/Focus>

![asInterruptHelper(Target/Focus)](https://github.com/aspilla/asMOD/blob/main/.Pictures/asInterruptHelper_target.jpg?raw=true)   

<For Mouseover Target>

![asInterruptHelper(Mouseover)](https://github.com/aspilla/asMOD/blob/main/.Pictures/asInterruptHelper.jpg?raw=true)   

## Key Features

* **Recommended for use with asTargetCastBar**:
    * Displays interruptible skills above the Target and Focus cast bars.
    * Displays skills above the mouse cursor when a mouseover target exists.
* **When an Interruptible Spell is Cast**:
    * Displays the primary interrupt skill. If the interrupt skill is on cooldown and the mob is susceptible to stuns (same level), stun skills are displayed instead.
* **When a Non-Interruptible Spell is Cast**:
    * Displays stun skills if the mob is susceptible to stuns (same level).
* **Skill Display Priority**:
    * Prioritizes skills with shorter cooldowns. (If cooldowns are equal, the skill with the lower ID is prioritized.)
* **Voice Alerts**: Provides voice notifications when an interrupt or stun is required (only functions when nameplates are visible).

## Configuration

Settings can be modified via `ESC` > `Options` > `AddOns` > `asInterruptHelper`:

* `ShowTarget`: Toggle display of interrupt skills for the current target.
* `ShowFocus`: Toggle display of interrupt skills for the focus target.
* `ShowMouseOver`: Toggle display of interrupt skills for the mouseover target.
* `PlaySoundKick`: Voice alert when an interrupt is needed (Default: On).
* `PlaySoundStun`: Voice alert when a stun is needed (Default: Off).
* **Repositioning**: Enter the `/asconfig` command in the chat window.
* **Reset Position**: Enter the `/asclear` command in the chat window to reset to default settings.

---

# asInterruptHelper (한밤)

차단/스턴 스킬 쿨다운 표시

<주시/대상의 경우>

![asInterruptHelper(Target/Focus)](https://github.com/aspilla/asMOD/blob/main/.Pictures/asInterruptHelper_target.jpg?raw=true)   

<마우스 오버 대상의 경우>

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
*   **음성 알림**: 차단 필요/스턴 필요시 음성 알림 (이름표가 표시 되는 경우만 판단 가능)    

## 설정

`ESC` > `설정` > `애드온` > `asInterruptHelper` 에서 다음 설정 변경 가능

*   `ShowTarget`: 대상 차단 스킬 표시 여부
*   `ShowFocus` : 주시 대상의 차단 스킬 표시 여부
*   `ShowMouseOver` : 마우스 오버 대상의 차단 스킬 표시 여부
*   `PlaySoundKick` : 차단 필요시 음성 알림 (기본 On)
*   `PlaySoundStun` : 스턴 필요시 음성 알림 (기본 Off)
*  **위치 이동** : `/asConfig` 명령어 채팅창에 입력
*  **위치 초기화** : `/asClear` 명령어 채팅창에 입력, 기본 설정으로 초기화 