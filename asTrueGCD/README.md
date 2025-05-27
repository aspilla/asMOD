# asTrueGCD

asTrueGCD is a World of Warcraft addon that provides a visual display of your character's current spell cast and a short history of recently used spells and items. It aims to offer a clearer representation of actions, especially concerning the Global Cooldown (GCD).

## Main Features

*   **Current Cast Display**:
    *   Shows a prominent icon of the spell or item currently being cast or channeled by your character.
    *   A cooldown-style spiral overlay indicates the progress of the current cast.
    *   If the same spell is cast multiple times consecutively, a counter appears on this main icon.

*   **Spell/Item History**:
    *   Displays icons for the last three successfully cast spells or used items in a row to the left of the current cast icon.
    *   **Interruption Indicator**: If a spell cast is interrupted, its icon in the history will be marked with an "X".
    *   **Sequential Cast Counter**: If the same spell/item is used multiple times in a row (and registered as distinct GCD actions), a counter will appear on its history icon.
    *   History icons fade out after approximately 5 seconds.

*   **"TrueGCD" Logic (Attempted)**:
    *   The addon includes logic that tries to prevent logging the same spell multiple times in the history if those casts occur very rapidly within a single Global Cooldown window. This helps to show distinct actions rather than every single `UNIT_SPELLCAST_SUCCEEDED` event if they are part of one GCD.

*   **Item Spell Tracking**: Scans equipped items (like trinkets) to correctly display icons for spells cast from items.
*   **Blacklist**: Ignores certain common, low-impact spells (e.g., Auto Attack) to keep the display relevant.
*   **Movable Frame**: The entire group of icons (current cast + history) can be repositioned. If `asMOD` is installed, its position can be managed via `asMOD`'s configuration.

## How it Works

1.  **Frame Setup**: The addon creates a main icon frame for the current cast and three smaller icon frames for the spell history.
2.  **Event Monitoring**: It listens to various `UNIT_SPELLCAST_*` events for the player.
    *   `_START` / `_CHANNEL_START`: Updates the main icon with the current spell and initiates a cast progress animation.
    *   `_STOP` / `_CHANNEL_STOP`: Clears the main icon if the cast finishes or is stopped.
    *   `_SUCCEEDED`: This is the primary trigger for the history. It records the spell/item, unless it's a blacklisted spell or an immediate re-cast of the exact same spell within the GCD duration.
    *   `_INTERRUPTED`: Records the spell in history but marks it as canceled.
3.  **History Management**: Successfully cast or canceled spells are added to a list. A periodic timer updates the three history icons based on this list.
4.  **Positioning**: The main icon's position is configurable, and history icons are anchored relative to it.

## Configuration

Basic configuration is done by editing Lua variables at the top of `asTrueGCD/asTrueGCD.lua`:

*   `ATGCD_X`, `ATGCD_Y`: Default X and Y offsets from the screen center for the main (current cast) icon. The history icons are positioned to its left. (Defaults: 56, -360)
*   `AGCICON`: Base size in pixels for the icons. The main current cast icon is slightly larger (1.3x). (Default: 25)

If `asMOD` is installed, the position of the main icon group ("asTrueGCD") can be more easily adjusted and saved using `asMOD`'s interface.

The `AGCD_BlackList` table in the Lua file can be modified by advanced users to add or remove spell IDs that should be ignored by the history display.

**Note**: This addon does not provide an in-game configuration panel for its settings without `asMOD`.

---

# asTrueGCD

asTrueGCD는 현재 시전 중인 주문과 최근 사용한 주문 및 아이템의 짧은 기록을 시각적으로 표시하는 월드 오브 워크래프트 애드온입니다. 특히 전역 재사용 대기시간(GCD)과 관련하여 행동을 더 명확하게 표현하는 것을 목표로 합니다.

## 주요 기능

*   **현재 시전 표시**:
    *   캐릭터가 현재 시전 또는 채널링 중인 주문이나 아이템의 아이콘을 눈에 띄게 표시합니다.
    *   재사용 대기시간 스타일의 효과가 현재 시전 진행 상황을 나타냅니다.
    *   동일한 주문을 연속으로 여러 번 시전하면 이 주 아이콘에 카운터가 나타납니다.

*   **주문/아이템 기록**:
    *   현재 시전 아이콘의 왼쪽에 성공적으로 시전했거나 사용한 마지막 세 개의 주문 또는 아이템 아이콘을 순서대로 표시합니다.
    *   **차단 표시**: 주문 시전이 차단되면 기록의 해당 아이콘에 "X"가 표시됩니다.
    *   **연속 시전 카운터**: 동일한 주문/아이템을 연속으로 여러 번 사용한 경우(그리고 별개의 GCD 행동으로 등록된 경우), 해당 기록 아이콘에 카운터가 표시됩니다.
    *   기록 아이콘은 약 5초 후에 사라집니다.

*   **"TrueGCD" 로직 (시도)**:
    *   애드온은 단일 전역 재사용 대기시간 창 내에서 매우 빠르게 발생한 경우 동일한 주문을 기록에 여러 번 기록하는 것을 방지하려는 로직을 포함합니다. 이는 하나의 GCD에 속하는 모든 `UNIT_SPELLCAST_SUCCEEDED` 이벤트 대신 별개의 행동을 보여주는 데 도움이 됩니다.

*   **아이템 주문 추적**: 장착한 아이템(예: 장신구)을 스캔하여 아이템에서 시전된 주문의 아이콘을 올바르게 표시합니다.
*   **블랙리스트**: 관련성 있는 표시를 유지하기 위해 특정 일반적이고 영향이 적은 주문(예: 자동 공격)을 무시합니다.
*   **이동 가능한 프레임**: 전체 아이콘 그룹(현재 시전 + 기록)의 위치를 변경할 수 있습니다. `asMOD`가 설치된 경우 해당 위치는 `asMOD`의 설정을 통해 관리할 수 있습니다.

## 작동 방식

1.  **프레임 설정**: 애드온은 현재 시전을 위한 주 아이콘 프레임과 주문 기록을 위한 세 개의 작은 아이콘 프레임을 생성합니다.
2.  **이벤트 감시**: 플레이어에 대한 다양한 `UNIT_SPELLCAST_*` 이벤트를 수신합니다.
    *   `_START` / `_CHANNEL_START`: 현재 주문으로 주 아이콘을 업데이트하고 시전 진행 애니메이션을 시작합니다.
    *   `_STOP` / `_CHANNEL_STOP`: 시전이 완료되거나 중지되면 주 아이콘을 지웁니다.
    *   `_SUCCEEDED`: 이것이 기록의 주된 트리거입니다. 블랙리스트에 있는 주문이거나 GCD 지속 시간 내에 정확히 동일한 주문을 즉시 다시 시전한 경우가 아니면 주문/아이템을 기록합니다.
    *   `_INTERRUPTED`: 주문을 기록에 남기지만 취소된 것으로 표시합니다.
3.  **기록 관리**: 성공적으로 시전했거나 취소된 주문이 목록에 추가됩니다. 주기적인 타이머가 이 목록을 기반으로 세 개의 기록 아이콘을 업데이트합니다.
4.  **위치 지정**: 주 아이콘의 위치는 설정 가능하며, 기록 아이콘은 이를 기준으로 고정됩니다.

## 설정

기본 설정은 `asTrueGCD/asTrueGCD.lua` 파일 상단의 Lua 변수를 편집하여 수행합니다:

*   `ATGCD_X`, `ATGCD_Y`: 주 (현재 시전) 아이콘의 화면 중앙으로부터의 기본 X 및 Y 오프셋입니다. 기록 아이콘은 그 왼쪽에 위치합니다. (기본값: 56, -360)
*   `AGCICON`: 아이콘의 기본 크기(픽셀 단위)입니다. 주 현재 시전 아이콘은 약간 더 큽니다(1.3배). (기본값: 25)

`asMOD`가 설치된 경우, 주 아이콘 그룹("asTrueGCD")의 위치는 `asMOD`의 인터페이스를 사용하여 더 쉽게 조정하고 저장할 수 있습니다.

Lua 파일의 `AGCD_BlackList` 테이블은 고급 사용자가 수정하여 기록 표시에 의해 무시되어야 하는 주문 ID를 추가하거나 제거할 수 있습니다.

**참고**: 이 애드온은 `asMOD` 없이는 해당 설정을 위한 게임 내 설정 패널을 제공하지 않습니다.
