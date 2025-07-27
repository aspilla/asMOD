# asInterruptHelper 

Displays the optimal interrupt or stun spell icon available when your focus, mouseover, or current target begins casting a spell.

For Target/Focus
![asInterruptHelper(Target/Focus)](https://github.com/aspilla/asMOD/blob/main/.Pictures/asInterruptHelper_target.jpg?raw=true)   

For Mouseover Target
![asInterruptHelper(Mouseover)](https://github.com/aspilla/asMOD/blob/main/.Pictures/asInterruptHelper.jpg?raw=true)   

<iframe width="560" height="315" src="https://www.youtube.com/embed/VZoYTQTJ4Jo?si=F-3UhNv6_tcTXxOP" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" referrerpolicy="strict-origin-when-cross-origin" allowfullscreen></iframe>

## Key Features

*   **Target Priority**:
    *   Displays in the order of Focus > Mouseover > Target. (If the focus target is not casting, it checks the mouseover target).
    *   For Focus/Target, the icon appears in the center of the screen. For a mouseover target, it appears next to the mouse cursor. (This can be configured to always follow the mouse).
*   **On Interruptible Spell Cast**:
    *   Shows the primary interrupt spell. If that is on cooldown and the mob is stunnable (i.e., of equal level), it shows an available stun spell. If all are on cooldown, it displays the cooldown of the primary interrupt spell.
*   **On Uninterruptible Spell Cast**:
    *   If the mob is stunnable, it shows an available stun spell. If all stuns are on cooldown, it displays the cooldown of the shortest stun spell.
*   **Skill Priority**:
    *   Skills with shorter cooldowns have priority. (If cooldowns are the same, the one with the lower spell ID is chosen).
    *   Priority is based on the cooldowns registered in `ns.InterruptSpells` and `ns.StunSpells`. You can adjust the priority by modifying these values.
    *   The actual cooldown of a spell is checked via the game's API, not these values.
*   **DBM Integration**:
    *   Displays a border around the spell icon for spells that DBM identifies as needing an interrupt/stun.

## Configuration

You can change the following settings via `ESC` > `Options` > `AddOns` > `asInterruptHelper`:

*   **`AlwaysOnMouse` (Checkbox)**:
    *   `true`: The helper icon will always follow your mouse cursor when an enemy is casting.
    *   `false` (Default): The icon only follows the mouse for mouseover target casts; otherwise, it uses a fixed position on the screen.

When using `asMOD`, the display position for the target/focus can be changed using the `/asConfig` command.

Advanced settings (editing spell lists, icon position, and size) require editing Lua variables at the top of the `asInterruptHelper.lua` file and within `asInterruptHelperOption.lua`:
*   `AIH_SIZE`: The size of the displayed icon.
*   `AIH_X`, `AIH_Y`: The default fixed X and Y position of the icon.
*   `AIH_M_X`, `AIH_M_Y`: The X and Y offset from the mouse cursor when in mouse-following mode.
*   `ns.InterruptSpells`, `ns.StunSpells` (in `asInterruptHelperOption.lua`): Tables that map spell IDs to their cooldowns.

---

# asInterruptHelper

주시 대상, 마우스오버 대상 또는 현재 대상이 주문 시전을 시작할 때 사용 가능한 최적의 차단 또는 기절 주문 아이콘을 표시

주시/대상의 경우
![asInterruptHelper(Target/Focus)](https://github.com/aspilla/asMOD/blob/main/.Pictures/asInterruptHelper_target.jpg?raw=true)   

마우스 오버 대상의 경우
![asInterruptHelper(Mouseover)](https://github.com/aspilla/asMOD/blob/main/.Pictures/asInterruptHelper.jpg?raw=true)   

<iframe width="560" height="315" src="https://www.youtube.com/embed/VZoYTQTJ4Jo?si=F-3UhNv6_tcTXxOP" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" referrerpolicy="strict-origin-when-cross-origin" allowfullscreen></iframe>

## 주요 기능

*   **몹우선 순위**:
    * 주시 > 마우스오버 > 대상 순으로 표시, (주시가 시전중이 아니면 마우스 오버 확인)
    * 주시/대상의 경우 화면 중앙에, 마우스오버일 경우 마우스 커서 옆에 표시 (옵션 조정시 언제나 마우스 오버 위치로 설정 가능)
*   **차단 가능 스킬 시전 시**:
    * 주 차단 스킬을 표시 하고, 쿨일 경우 스턴이 가능한 몹 (Level이 동등한 몹) 인 경우 스턴 스킬을 표시 합니다. 모두 쿨일 경우 차단 스킬 쿨을 표시
*   **차단 불가 스킬 시전 시**:
    * 스턴이 가능한 몹 (Level이 동등한 몹) 인 경우 스턴 스킬을 표시 합니다. 모두 쿨인 경우 스턴 스킬의 짧은 쿨을 표시
*   **스킬 우선 순위**:
    * 쿨이 짧은 스킬이 우선순위를 가집니다. (쿨이 같은경우 ID 가 작은수 인 경우) 
    * `ns.InterruptSpells`, `ns.StunSpells` 내에 등록되어 있는 쿨 기준이며, 이 값을 조정하여 우선순위 조정이 가능합니다.
    * 실제 스킬의 쿨은 해당 값이 아닌 API를 통해 확인합니다. 
*   **DBM 차단 스킬**:
    * 차단/스턴 스킬에 테두리를 표시

## 설정

`ESC` > `설정` > `애드온` > `asInterruptHelper` 에서 다음 설정 변경 가능

    *   **`AlwaysOnMouse` (체크박스)**:
        *   `true` : 적이 시전 중일 때 도우미 아이콘이 항상 마우스 커서를 따라다닙니다.
        *   `false`(기본값): 아이콘은 마우스오버 대상 시전의 경우에만 마우스를 따라다니며, 그렇지 않으면 고정된 화면 위치를 사용합니다.

`asMOD` 사용시 `/asConfig` 명령어로 대상/주시와의 거리 표시 위치 변경 가능

고급 설정(주문 목록, 아이콘 위치, 크기 편집)은 `asInterruptHelper.lua` 파일 상단 및 `asInterruptHelperOption.lua` 내의 Lua 변수를 편집해야 합니다:
*   `AIH_SIZE`: 표시되는 아이콘의 크기.
*   `AIH_X`, `AIH_Y`: 아이콘의 기본 고정 X 및 Y 위치.
*   `AIH_M_X`, `AIH_M_Y`: 마우스 따라다니기 모드일 때 마우스 커서로부터의 X 및 Y 오프셋.
*   `ns.InterruptSpells`, `ns.StunSpells` (`asInterruptHelperOption.lua` 내): 주문 ID를 재사용 대기시간에 매핑하는 테이블.


