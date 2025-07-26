# asInterruptHelper (English)

Displays the optimal interrupt or stun spell icon available when your focus, mouseover, or current target begins casting a spell.
![asInterruptHelper](https://github.com/aspilla/asMOD/blob/main/.Pictures/asInterruptHelper.jpg?raw=true)

## Key Features

*   **Mob Priority**:
    *   Displays in the order of Focus > Mouseover > Target. (If the focus target is not casting, it checks the mouseover target.)
*   **On Interruptible Spell Cast**:
    *   Shows the primary interrupt spell. If it's on cooldown and the mob is stunnable (i.e., of an equal or lower level), it displays a stun spell. If all are on cooldown, it shows the cooldown of the interrupt spell.
*   **On Uninterruptible Spell Cast**:
    *   If the mob is stunnable, it shows a stun spell. If all stuns are on cooldown, it displays the shortest available stun spell cooldown.
*   **DBM Interrupt Spell**:
    *   Displays a border around the interrupt/stun spell icon when prompted by DBM.

## Settings

You can change the following settings under `ESC` > `Options` > `AddOns` > `asInterruptHelper`:

*   **`AlwaysOnMouse` (Checkbox)**:
    *   `true` (Default): The helper icon will always follow your mouse cursor when an enemy is casting.
    *   `false`: The icon only follows the mouse for mouseover target casts; otherwise, it uses a fixed position on the screen.

Advanced settings (editing spell lists, icon position, and size) require editing Lua variables at the top of the `asInterruptHelper.lua` file and within `asInterruptHelperOption.lua`:
*   `AIH_SIZE`: The size of the displayed icon.
*   `AIH_X`, `AIH_Y`: The default fixed X and Y position of the icon.
*   `AIH_M_X`, `AIH_M_Y`: The X and Y offset from the mouse cursor when in mouse-following mode.
*   `ns.InterruptSpells`, `ns.StunSpells` (in `asInterruptHelperOption.lua`): Tables that map spell IDs to their cooldowns.

---

# asInterruptHelper (Korean)

주시 대상, 마우스오버 대상 또는 현재 대상이 주문 시전을 시작할 때 사용 가능한 최적의 차단 또는 기절 주문 아이콘을 표시
![asInterruptHelper](https://github.com/aspilla/asMOD/blob/main/.Pictures/asInterruptHelper.jpg?raw=true)   

## 주요 기능

*   **몹우선 순위**:
    * 주시 > 마우스오버 > 대상 순으로 표시, (주시가 시전중이 아니면 마우스 오버 확인)
*   **차단 가능 스킬 시전 시**:
    * 주 차단 스킬을 표시 하고, 쿨일 경우 스턴이 가능한 몹 (Level이 동등한 몹) 인 경우 스턴 스킬을 표시 합니다. 모두 쿨일 경우 차단 스킬 쿨을 표시
*   **차단 불가 스킬 시전 시**:
    * 스턴이 가능한 몹 (Level이 동등한 몹) 인 경우 스턴 스킬을 표시 합니다. 모두 쿨인 경우 스턴 스킬의 짧은 쿨을 표시
*   **DBM 차단 스킬**:
    * 차단/스턴 스킬에 테두리를 표시

## 설정

`ESC` > `설정` > `애드온` > `asInterruptHelper` 에서 다음 설정 변경 가능

    *   **`AlwaysOnMouse` (체크박스)**:
        *   `true` (기본값): 적이 시전 중일 때 도우미 아이콘이 항상 마우스 커서를 따라다닙니다.
        *   `false`: 아이콘은 마우스오버 대상 시전의 경우에만 마우스를 따라다니며, 그렇지 않으면 고정된 화면 위치를 사용합니다.

고급 설정(주문 목록, 아이콘 위치, 크기 편집)은 `asInterruptHelper.lua` 파일 상단 및 `asInterruptHelperOption.lua` 내의 Lua 변수를 편집해야 합니다:
*   `AIH_SIZE`: 표시되는 아이콘의 크기.
*   `AIH_X`, `AIH_Y`: 아이콘의 기본 고정 X 및 Y 위치.
*   `AIH_M_X`, `AIH_M_Y`: 마우스 따라다니기 모드일 때 마우스 커서로부터의 X 및 Y 오프셋.
*   `ns.InterruptSpells`, `ns.StunSpells` (`asInterruptHelperOption.lua` 내): 주문 ID를 재사용 대기시간에 매핑하는 테이블.