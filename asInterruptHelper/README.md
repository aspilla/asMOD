# asInterruptHelper (Midnight)

Interrupt/Stun Cooldown Tracker

### Target / Focus View
![asInterruptHelper(Target/Focus)](https://github.com/aspilla/asMOD/blob/main/.Pictures/asInterruptHelper_target.jpg?raw=true)

### Mouseover View
![asInterruptHelper(Mouseover)](https://github.com/aspilla/asMOD/blob/main/.Pictures/asInterruptHelper.jpg?raw=true)

## Key Features

* **Visual Integration** (Recommended with `asTargetCastBar`):
    * Overlays available interrupt/stun spells directly on the Target and Focus cast bars.
    * Displays the icon near the mouse cursor for Mouseover targets.
* **Interrupt Logic**:
    * Displays your primary interrupt spell when an interruptible spell is being cast.
    * If your interrupt is on cooldown, it suggests a stun spell (only if the target's level allows it).
* **Stun Logic for Non-interruptible Spells**:
    * If a spell is non-interruptible but the target is stunnable (e.g., same level mobs), it displays your stun spells.
* **Smart Priority System**:
    * Spells with shorter cooldowns take priority. (If cooldowns are equal, the spell with the lower ID is prioritized).
    * Priorities are managed via `ns.InterruptSpells` and `ns.StunSpells`.    

## Configuration

You can modify the following settings via `ESC` > `Options` > `Addons` > `asInterruptHelper`:
* `ShowTarget`: Toggle display for Target's interrupt/stun.
* `ShowFocus`: Toggle display for Focus unit's interrupt/stun.
* `ShowMouseOver`: Toggle display for Mouseover unit's interrupt/stun.
* **Move Position**: Enter the `/asConfig` command in the chat.
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
*   **스킬 우선 순위**:
    * 쿨이 짧은 스킬이 우선순위를 가짐. (쿨이 같은경우 ID 가 작은수 인 경우) 
    * `ns.InterruptSpells`, `ns.StunSpells` 내에 등록되어 있는 쿨 기준이며, 이 값을 조정하여 우선순위 조정이 가능합니다.    

## 설정

`ESC` > `설정` > `애드온` > `asInterruptHelper` 에서 다음 설정 변경 가능

*   `ShowTarget`: 대상 차단 스킬 표시 여부
*   `ShowFocus` : 주시 대상의 차단 스킬 표시 여부
*   `ShowMouseOver` : 마우스 오버 대상의 차단 스킬 표시 여부
*  **위치 이동** : `/asConfig` 명령어 채팅창에 입력
*  **위치 초기화** : `/asClear` 명령어 채팅창에 입력, 기본 설정으로 초기화 