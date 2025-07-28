# asInterruptHelper (English)

Displays the optimal interrupt or stun spell icon available when a focus target, mouseover target, or current target begins casting a spell.

For Target/Focus
![asInterruptHelper(Target/Focus)](https://github.com/aspilla/asMOD/blob/main/.Pictures/asInterruptHelper_target.jpg?raw=true)

For Mouseover Target
![asInterruptHelper(Mouseover)](https://github.com/aspilla/asMOD/blob/main/.Pictures/asInterruptHelper.jpg?raw=true)

<iframe width="560" height="315" src="https://www.youtube.com/embed/VZoYTQTJ4Jo?si=F-3UhNv6_tcTXxOP" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" referrerpolicy="strict-origin-when-cross-origin" allowfullscreen></iframe>

## Key Features

*   **Recommended for use with asTargetCastBar**:
    *   Displays interruptible skills above the focus and target casting bars.
    *   If there is a mouseover target, it is displayed above the mouse cursor.
*   **When casting an interruptible spell**:
    *   Displays the main interrupt skill. If it's on cooldown and the mob is stunnable (i.e., of an equivalent level), it displays a stun skill. If all are on cooldown, it shows the interrupt skill's cooldown.
*   **When casting a non-interruptible spell**:
    *   If the mob is stunnable (i.e., of an equivalent level), it displays a stun skill. If all are on cooldown, it shows the shorter cooldown of the available stun skills.
*   **Skill Priority**:
    *   Skills with shorter cooldowns have higher priority. (If cooldowns are the same, the one with the lower spell ID has priority).
    *   Priority is based on the cooldowns registered in `ns.InterruptSpells` and `ns.StunSpells`. You can adjust these values to change the priority.
    *   The actual skill cooldown is checked via the API, not this value.
*   **DBM Interrupt Skill**:
    *   Displays a border around the interrupt/stun skill icon.

## Settings

You can change the following settings in `ESC` > `Options` > `AddOns` > `asInterruptHelper`:

*   `ShowTarget`: Whether to show the interrupt skill for the target.
*   `ShowFocus`: Whether to show the interrupt skill for the focus target.
*   `ShowMouseOver`: Whether to show the interrupt skill for the mouseover target.

When using `asMOD`, you can change the position of the distance display from the target/focus with the `/asConfig` command.

For advanced settings (editing spell lists, icon position, and size), you need to edit the Lua variables at the top of the `asInterruptHelper.lua` file and within `asInterruptHelperOption.lua`:
*   `AIH_SIZE`: The size of the displayed icon.
*   `AIH_X`, `AIH_Y`: The default fixed X and Y position of the icon.
*   `AIH_M_X`, `AIH_M_Y`: The X and Y offset from the mouse cursor in mouse-follow mode.
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

*   **asTargetCastBar 와 같이 사용 추천**:
    * 주시대상, 대상 케스팅바 위에 차단 가능 스킬을 표시
    * 마우스 오버 대상이 있는 경우 마우스 커서 위에 표시
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

*   `ShowTarget`: 대상 차단 스킬 표시 여부
*   `ShowFocus` : 주시 대상의 차단 스킬 표시 여부
*   `ShowMouseOver` : 마우스 오버 대상의 차단 스킬 표시 여부

`asMOD` 사용시 `/asConfig` 명령어로 대상/주시와의 거리 표시 위치 변경 가능

고급 설정(주문 목록, 아이콘 위치, 크기 편집)은 `asInterruptHelper.lua` 파일 상단 및 `asInterruptHelperOption.lua` 내의 Lua 변수를 편집해야 합니다:
*   `AIH_SIZE`: 표시되는 아이콘의 크기.
*   `AIH_X`, `AIH_Y`: 아이콘의 기본 고정 X 및 Y 위치.
*   `AIH_M_X`, `AIH_M_Y`: 마우스 따라다니기 모드일 때 마우스 커서로부터의 X 및 Y 오프셋.
*   `ns.InterruptSpells`, `ns.StunSpells` (`asInterruptHelperOption.lua` 내): 주문 ID를 재사용 대기시간에 매핑하는 테이블.