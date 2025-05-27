# asInterruptHelper

asInterruptHelper is a World of Warcraft addon that displays an icon of your best available interrupt or stun spell when your focus, mouseover, or current target begins casting a spell. It integrates with DBM to highlight spells that DBM considers dangerous and prioritizes actions accordingly.

## Main Features

*   **Contextual Interrupt/Stun Display**:
    *   When an enemy (focus, mouseover, or target) starts casting, the addon shows an icon of one of your interrupt or stun spells.
    *   **Prioritization**:
        *   If the enemy cast is uninterruptible, it will prefer to show an available stun.
        *   If interruptible, it will prefer an available interrupt.
        *   It considers if your spell will be off cooldown *before* the enemy cast finishes. Spells ready in time are visually emphasized.
*   **DBM Integration**:
    *   If DBM (Deadly Boss Mods) is installed, the addon scans DBM's spell information.
    *   If DBM flags an enemy spell as requiring an "interrupt", `asInterruptHelper` will apply a glow effect to your displayed interrupt/stun icon, signaling higher urgency.
    *   If an interruptible DBM-flagged dangerous spell is casting and your normal interrupts are on cooldown but a stun is available and would be ready in time, it may suggest the stun.
*   **Visual Cues**:
    *   **Icon**: Displays the icon of the suggested player spell.
    *   **Cooldown**: Shows the cooldown status of your spell. If it will be ready before the enemy cast ends, the cooldown text is larger and red. Otherwise, the icon is desaturated, and text is smaller.
    *   **Glow Effect**: A pixel glow highlights the icon if the enemy spell is marked as a dangerous interrupt by DBM.
*   **Dynamic Positioning**:
    *   **Mouse Follow**: Can be configured to always follow the mouse cursor, or only follow when the casting unit is your mouseover target.
    *   **Fixed Position**: Alternatively, it can display at a fixed position on the screen.
*   **Customizable Spell Lists**: The addon includes predefined lists of common interrupt and stun spells with their cooldowns, which advanced users can modify.

## How it Works

1.  **Initialization**: Loads lists of player-known interrupt and stun spells. If DBM is present, it registers to receive DBM's spell data.
2.  **Target Scanning**: Continuously checks if your focus, mouseover, or current target is casting or channeling a spell.
3.  **Spell Selection**: If an enemy cast is detected:
    *   It determines if the cast is interruptible.
    *   It checks if DBM flags the spell as a dangerous interrupt.
    *   It then iterates through your available interrupts (and stuns if applicable), prioritizing those that will be off cooldown before the enemy cast finishes.
4.  **Icon Display**: Shows the icon of the chosen spell, its cooldown status, and applies a glow if the situation is critical (DBM dangerous interrupt).
5.  **Positioning**: Places the icon either at a fixed spot or near the mouse cursor based on settings and context.

## Configuration

Settings can be accessed via the Blizzard Addon Settings panel:
1.  Open Game Menu (Esc).
2.  Click "Options".
3.  Go to the "AddOns" tab.
4.  Select "asInterruptHelper".
5.  Adjust the following:
    *   **`AlwaysOnMouse` (Checkbox)**:
        *   `true` (Default): The helper icon will always follow the mouse cursor when an enemy is casting.
        *   `false`: The icon will only follow the mouse for mouseover target casts; otherwise, it uses a fixed screen position.
    *   Changing this setting requires a `ReloadUI()`.

Advanced configuration (editing spell lists, icon position, size) requires editing Lua variables at the top of `asInterruptHelper.lua` and within `asInterruptHelperOption.lua`:
*   `AIH_SIZE`: Size of the displayed icon.
*   `AIH_X`, `AIH_Y`: Default fixed X and Y position of the icon.
*   `AIH_M_X`, `AIH_M_Y`: X and Y offset from the mouse cursor when in mouse-follow mode.
*   `ns.InterruptSpells`, `ns.StunSpells` (in `asInterruptHelperOption.lua`): Tables mapping spell IDs to cooldowns.

The glow effects are provided by `asInterruptHelperLib.lua`.

---

# asInterruptHelper

asInterruptHelper는 주시 대상, 마우스오버 대상 또는 현재 대상이 주문 시전을 시작할 때 사용 가능한 최적의 차단 또는 기절 주문 아이콘을 표시하는 월드 오브 워크래프트 애드온입니다. DBM과 연동하여 DBM이 위험하다고 간주하는 주문을 강조하고 그에 따라 행동의 우선순위를 정합니다.

## 주요 기능

*   **상황별 차단/기절 표시**:
    *   적(주시, 마우스오버 또는 현재 대상)이 시전을 시작하면 애드온은 플레이어의 차단 또는 기절 주문 중 하나의 아이콘을 보여줍니다.
    *   **우선순위**:
        *   적의 시전이 차단 불가능한 경우, 사용 가능한 기절 주문을 우선적으로 표시합니다.
        *   차단 가능한 경우, 사용 가능한 차단 주문을 우선적으로 표시합니다.
        *   플레이어의 주문이 적의 시전이 끝나기 *전에* 재사용 대기시간이 완료될지를 고려합니다. 시간 내에 준비되는 주문은 시각적으로 강조됩니다.
*   **DBM 연동**:
    *   DBM (Deadly Boss Mods)이 설치된 경우, 애드온은 DBM의 주문 정보를 스캔합니다.
    *   DBM이 적 주문을 "차단"이 필요하다고 표시하면, `asInterruptHelper`는 표시된 차단/기절 아이콘에 강조 효과를 적용하여 긴급성을 알립니다.
    *   DBM이 위험하다고 표시한 차단 가능한 주문이 시전 중이고 일반 차단 기술이 재사용 대기 중이지만 기절 기술이 사용 가능하고 시간 내에 준비될 경우, 기절 기술을 제안할 수 있습니다.
*   **시각적 신호**:
    *   **아이콘**: 제안된 플레이어 주문의 아이콘을 표시합니다.
    *   **재사용 대기시간**: 플레이어 주문의 재사용 대기시간 상태를 표시합니다. 적의 시전이 끝나기 전에 준비될 경우, 재사용 대기시간 텍스트가 더 크고 빨간색으로 표시됩니다. 그렇지 않으면 아이콘이 비활성화된 것처럼 보이고 텍스트는 더 작게 표시됩니다.
    *   **강조 효과**: 적 주문이 DBM에 의해 위험한 차단 기술로 표시된 경우 아이콘에 픽셀 강조 효과가 적용됩니다.
*   **동적 위치 지정**:
    *   **마우스 따라다니기**: 적이 시전 중일 때 항상 마우스 커서를 따라다니도록 설정하거나, 시전 중인 유닛이 마우스오버 대상일 때만 따라다니도록 설정할 수 있습니다.
    *   **고정 위치**: 또는 화면의 고정된 위치에 표시할 수 있습니다.
*   **사용자 정의 가능한 주문 목록**: 애드온에는 일반적인 차단 및 기절 주문과 해당 재사용 대기시간의 미리 정의된 목록이 포함되어 있으며, 고급 사용자는 이를 수정할 수 있습니다.

## 작동 방식

1.  **초기화**: 플레이어가 알고 있는 차단 및 기절 주문 목록을 로드합니다. DBM이 있는 경우 DBM의 주문 데이터를 수신하도록 등록합니다.
2.  **대상 스캔**: 주시 대상, 마우스오버 대상 또는 현재 대상이 주문을 시전하거나 채널링 중인지 지속적으로 확인합니다.
3.  **주문 선택**: 적의 시전이 감지되면:
    *   시전이 차단 가능한지 확인합니다.
    *   DBM이 해당 주문을 위험한 차단 기술로 표시했는지 확인합니다.
    *   그런 다음 사용 가능한 차단 기술(해당되는 경우 기절 기술 포함)을 반복하며, 적의 시전이 끝나기 전에 재사용 대기시간이 완료될 기술을 우선시합니다.
4.  **아이콘 표시**: 선택한 주문의 아이콘, 재사용 대기시간 상태를 표시하고, 상황이 긴급한 경우(DBM 위험 차단) 강조 효과를 적용합니다.
5.  **위치 지정**: 설정 및 상황에 따라 아이콘을 고정된 위치 또는 마우스 커서 근처에 배치합니다.

## 설정

설정은 블리자드 애드온 설정 패널을 통해 접근할 수 있습니다:
1.  게임 메뉴(Esc)를 엽니다.
2.  "설정"을 클릭합니다.
3.  "애드온" 탭으로 이동합니다.
4.  목록에서 "asInterruptHelper"를 선택합니다.
5.  다음을 조정합니다:
    *   **`AlwaysOnMouse` (체크박스)**:
        *   `true` (기본값): 적이 시전 중일 때 도우미 아이콘이 항상 마우스 커서를 따라다닙니다.
        *   `false`: 아이콘은 마우스오버 대상 시전의 경우에만 마우스를 따라다니며, 그렇지 않으면 고정된 화면 위치를 사용합니다.
    *   이 설정을 변경하려면 `ReloadUI()`가 필요합니다.

고급 설정(주문 목록, 아이콘 위치, 크기 편집)은 `asInterruptHelper.lua` 파일 상단 및 `asInterruptHelperOption.lua` 내의 Lua 변수를 편집해야 합니다:
*   `AIH_SIZE`: 표시되는 아이콘의 크기.
*   `AIH_X`, `AIH_Y`: 아이콘의 기본 고정 X 및 Y 위치.
*   `AIH_M_X`, `AIH_M_Y`: 마우스 따라다니기 모드일 때 마우스 커서로부터의 X 및 Y 오프셋.
*   `ns.InterruptSpells`, `ns.StunSpells` (`asInterruptHelperOption.lua` 내): 주문 ID를 재사용 대기시간에 매핑하는 테이블.

강조 효과는 `asInterruptHelperLib.lua`에서 제공됩니다.
