# asRangeDisplay

asRangeDisplay is a World of Warcraft addon that shows the approximate range to your current target as a text display on your screen. It uses different methods for range calculation depending on whether you are in combat or targeting a friendly/hostile unit.

## Main Features

*   **Dynamic Range Text**: Displays a numerical value representing your estimated range to the current target.
*   **Contextual Range Calculation**:
    *   **Out of Combat / Friendly Targets**: Uses a predefined list of items with known ranges. It checks which item is the shortest-range one currently usable on the target to estimate range.
    *   **In Combat (Hostile Targets)**: Scans your spellbook for spells with a maximum range. It then checks which of these spells are currently in range of your target and displays the shortest maximum range among them. This effectively shows your current shortest combat engagement range.
*   **Color-Coded Display**: The range text changes color based on the distance:
    *   Red: > 40 yards
    *   Yellow/Orange: > 30-40 yards
    *   Green: > 20-30 yards
    *   Cyan/Blueish: > 5-20 yards
    *   Grey/White: <= 5 yards or when range is 0.
*   **Customizable Position**:
    *   Can be positioned using X/Y offsets.
    *   Option to link its position relative to `asHealthText` addon's raid icon display.
    *   If `asMOD` is installed, its position can be managed by `asMOD`.
*   **Configurable Update Rate**: The frequency of range checks can be adjusted.

## How it Works

1.  **Initialization**: The addon loads predefined lists of items (for out-of-combat checks) and scans the player's spellbook (for in-combat checks) to cache spell ranges.
2.  **Target Change/Periodic Update**: When the target changes or on a regular timer:
    *   It determines if the target is friendly or hostile and if the player is in combat.
    *   **Out-of-Combat/Friendly**: It iterates through a list of items (e.g., bandages, nets, quest items with ranges) and uses `IsItemInRange()` to find the item with the shortest range that can currently be used on the target. This item's known range is displayed.
    *   **In-Combat (Hostile)**: It iterates through the player's known spells, checks which ones are in range using `C_Spell.IsSpellInRange()`, and then displays the shortest maximum range among those currently usable spells.
3.  The displayed range number is then colored according to the distance.

## Configuration

Configuration is done by editing Lua variables at the top of `asRangeDisplay/asRangeDisplay.lua`:

*   `ARD_Font`: Font face for the range text. (Default: `STANDARD_TEXT_FONT`)
*   `ARD_FontSize`: Font size. (Default: 16)
*   `ARD_FontOutline`: Font outline style (e.g., "THICKOUTLINE"). (Default: "THICKOUTLINE")
*   `ARD_X`, `ARD_Y`: Default X and Y offsets from the screen center if not linked to `asHealthText` or managed by `asMOD`. (Defaults: 0, -130)
*   `ARD_AHT`: Set to `true` to attempt to position the range display next to `asHealthText`'s raid icon. (Default: `false`)
*   `ARD_UpdateRate`: How often (in seconds) the range is checked and updated. (Default: 0.25)

**Note**: This addon does not provide a dedicated in-game configuration panel for these settings unless its position is managed by `asMOD`.

---

# asRangeDisplay

asRangeDisplay는 현재 대상까지의 대략적인 거리를 화면에 텍스트로 표시하는 월드 오브 워크래프트 애드온입니다. 전투 중인지 또는 우호적/적대적 대상을 선택했는지에 따라 다른 방법으로 거리를 계산합니다.

## 주요 기능

*   **동적 거리 텍스트**: 현재 대상까지의 예상 거리를 나타내는 숫자 값을 표시합니다.
*   **상황별 거리 계산**:
    *   **비전투 중 / 우호적 대상**: 알려진 사정거리를 가진 미리 정의된 아이템 목록을 사용합니다. 현재 대상에게 사용할 수 있는 가장 짧은 사정거리의 아이템을 확인하여 거리를 추정합니다.
    *   **전투 중 (적대적 대상)**: 사용자의 주문책을 스캔하여 최대 사정거리를 가진 주문을 찾습니다. 그런 다음 이 주문들 중 현재 대상에게 사정거리가 닿는 주문을 확인하고 그중 가장 짧은 최대 사정거리를 표시합니다. 이는 사실상 현재 가장 짧은 교전 가능 거리를 보여줍니다.
*   **색상 구분 표시**: 거리 텍스트는 거리에 따라 색상이 변경됩니다:
    *   빨간색: > 40미터
    *   노란색/주황색: > 30-40미터
    *   녹색: > 20-30미터
    *   청록색/파란색 계열: > 5-20미터
    *   회색/흰색: <= 5미터 또는 거리 0.
*   **사용자 정의 가능한 위치**:
    *   X/Y 오프셋을 사용하여 위치를 지정할 수 있습니다.
    *   `asHealthText` 애드온의 공격대 아이콘 표시에 상대적으로 위치를 연결하는 옵션이 있습니다.
    *   `asMOD`가 설치된 경우, 해당 위치는 `asMOD`에 의해 관리될 수 있습니다.
*   **설정 가능한 업데이트 속도**: 거리 확인 빈도를 조정할 수 있습니다.

## 작동 방식

1.  **초기화**: 애드온은 미리 정의된 아이템 목록(비전투 확인용)을 로드하고 플레이어의 주문책을 스캔하여(전투 중 확인용) 주문 사정거리를 캐시합니다.
2.  **대상 변경/주기적 업데이트**: 대상이 변경되거나 정기적인 타이머에 따라:
    *   대상이 우호적인지 적대적인지, 플레이어가 전투 중인지 확인합니다.
    *   **비전투/우호적 대상**: 아이템 목록(예: 붕대, 그물, 사정거리가 있는 퀘스트 아이템)을 반복하고 `IsItemInRange()`를 사용하여 현재 대상에게 사용할 수 있는 가장 짧은 사정거리의 아이템을 찾습니다. 이 아이템의 알려진 사정거리가 표시됩니다.
    *   **전투 중 (적대적 대상)**: 플레이어가 알고 있는 주문을 반복하고 `C_Spell.IsSpellInRange()`를 사용하여 사정거리 내에 있는 주문을 확인한 다음, 현재 사용할 수 있는 주문 중 가장 짧은 최대 사정거리를 표시합니다.
3.  표시된 거리 숫자는 거리에 따라 색상이 지정됩니다.

## 설정

설정은 `asRangeDisplay/asRangeDisplay.lua` 파일 상단의 Lua 변수를 편집하여 수행합니다:

*   `ARD_Font`: 거리 텍스트의 글꼴입니다. (기본값: `STANDARD_TEXT_FONT`)
*   `ARD_FontSize`: 글꼴 크기입니다. (기본값: 16)
*   `ARD_FontOutline`: 글꼴 외곽선 스타일입니다 (예: "THICKOUTLINE"). (기본값: "THICKOUTLINE")
*   `ARD_X`, `ARD_Y`: `asHealthText`에 연결되거나 `asMOD`에 의해 관리되지 않는 경우 화면 중앙으로부터의 기본 X 및 Y 오프셋입니다. (기본값: 0, -130)
*   `ARD_AHT`: `asHealthText`의 공격대 아이콘 옆에 거리 표시를 위치시키려면 `true`로 설정합니다. (기본값: `false`)
*   `ARD_UpdateRate`: 거리를 확인하고 업데이트하는 빈도(초 단위)입니다. (기본값: 0.25)

**참고**: 이 애드온은 해당 위치가 `asMOD`에 의해 관리되지 않는 한 이러한 설정을 위한 전용 게임 내 설정 패널을 제공하지 않습니다.
