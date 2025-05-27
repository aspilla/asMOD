# asDotFilter

asDotFilter is a World of Warcraft addon designed to display player-cast Damage over Time (DoT) effects on specified unit frames, such as focus, boss frames, and the target frame. It helps players track their DoTs with visual cues for remaining duration, stack counts, and snapshot strength (if `asDotSnapshot` is available).

## Main Features

1.  **Player-Cast DoT Tracking**:
    *   Focuses exclusively on DoTs cast by the player or their pet.
    *   Uses predefined lists of spell IDs specific to each class and specialization to identify which DoTs to monitor.

2.  **Configurable Unit Display**:
    *   Displays tracked DoTs next to specified unit frames. By default, this includes `focus` and `boss1` through `boss5`.
    *   The icons are dynamically positioned relative to the standard Blizzard unit frames or their `asUnitFrame` equivalents (e.g., `AUF_TargetFrame`) if available.

3.  **Visual DoT Information**:
    *   **Icon & Cooldown**: Shows the DoT's spell icon with a cooldown spiral and numerical text indicating remaining duration.
    *   **Stack Count**: Displays the number of stacks for DoTs that can have multiple applications.
    *   **Snapshot Strength (with asDotSnapshot)**: If the `asDotSnapshot` addon is installed, asDotFilter can display the relative power of the applied DoT as a percentage (e.g., "110" for 110%). The text color indicates if it's stronger (greenish) or weaker (reddish) than a baseline 100% snapshot.
    *   **Duration Alert**: A glow effect is applied to the icon when a DoT's remaining duration falls below a configurable threshold (typically 30% of its base duration or a specific time in seconds, defined per spell in the lists).

4.  **Class and Specialization Specific Lists**:
    *   Contains hardcoded lists (e.g., `ADotF_ShowList_WARLOCK_1`) for each class and spec, defining:
        *   The spell ID of the DoT.
        *   A threshold for the duration alert glow.
        *   An optional flag to enable snapshot power display via `asDotSnapshot`.
    *   The addon automatically selects the correct list based on the player's current class and specialization.

5.  **Dynamic Updates**:
    *   Responds to game events such as target changes, focus changes, entering combat with a boss, and talent switches to update DoT displays.
    *   A periodic timer also ensures DoTs are regularly refreshed.

## Customization

Core customization is done by editing Lua variables at the top of `asDotFilter/asDotFilter.lua`:

*   `ADotF_SIZE`: Sets the size of the DoT icons.
*   `ADotF_MAX_DEBUFF_SHOW`: Defines the maximum number of DoT icons to display per unit frame (though current logic seems to display all configured DoTs for a spec).
*   `ADotF_ALPHA`: Controls the transparency of the DoT icons.
*   `ADotF_CooldownFontSize`: Font size for the numerical cooldown text.
*   `ADotF_CountFontSize`: Font size for the stack count text.
*   `ADotF_UnitList`: A Lua table where you can specify which unit frames should have DoT icons displayed next to them (e.g., `"target"`, `"focus"`, `"boss1"`).
*   **Spell Lists** (`ADotF_ShowList_<CLASS>_<SPEC>`): Advanced users can modify these lists to change which DoTs are tracked, their alert thresholds, or snapshot checking behavior.

---

# asDotFilter

asDotFilter는 월드 오브 워크래프트 애드온으로, 플레이어가 시전한 지속적인 피해(DoT) 효과를 주시 대상, 보스 프레임, 대상 프레임 등 지정된 유닛 프레임에 표시하도록 설계되었습니다. 플레이어가 남은 지속 시간, 중첩 횟수, 그리고 (asDotSnapshot 애드온 사용 시) 스냅샷 강도에 대한 시각적 신호를 통해 자신의 DoT를 추적하는 데 도움을 줍니다.

## 주요 기능

1.  **플레이어 시전 DoT 추적**:
    *   플레이어 또는 플레이어의 소환수가 시전한 DoT에만 집중합니다.
    *   각 직업 및 전문화별로 미리 정의된 주문 ID 목록을 사용하여 어떤 DoT를 감시할지 식별합니다.

2.  **설정 가능한 유닛 표시**:
    *   추적된 DoT를 지정된 유닛 프레임 옆에 표시합니다. 기본적으로 `주시 대상` 및 `boss1`부터 `boss5`까지 포함됩니다.
    *   아이콘은 표준 블리자드 유닛 프레임 또는 (사용 가능한 경우) `asUnitFrame`에 해당하는 프레임(예: `AUF_TargetFrame`)을 기준으로 동적으로 위치가 지정됩니다.

3.  **시각적 DoT 정보**:
    *   **아이콘 및 재사용 대기시간**: DoT의 주문 아이콘과 함께 남은 지속 시간을 나타내는 재사용 대기시간 효과 및 숫자 텍스트를 표시합니다.
    *   **중첩 횟수**: 여러 번 적용될 수 있는 DoT의 중첩 횟수를 표시합니다.
    *   **스냅샷 강도 (asDotSnapshot 연동 시)**: `asDotSnapshot` 애드온이 설치된 경우, asDotFilter는 적용된 DoT의 상대적인 위력을 백분율(예: 110% 위력일 경우 "110")로 표시할 수 있습니다. 텍스트 색상은 기준 100% 스냅샷보다 강한지(녹색 계열) 약한지(붉은색 계열)를 나타냅니다.
    *   **지속 시간 알림**: DoT의 남은 지속 시간이 설정된 임계값(일반적으로 기본 지속 시간의 30% 또는 목록에 주문별로 정의된 특정 시간(초)) 아래로 떨어지면 아이콘에 강조 효과가 적용됩니다.

4.  **직업 및 전문화별 목록**:
    *   각 직업 및 전문화에 대한 하드코딩된 목록(예: `ADotF_ShowList_WARLOCK_1`)을 포함하며, 다음을 정의합니다:
        *   DoT의 주문 ID.
        *   지속 시간 알림 강조 효과의 임계값.
        *   `asDotSnapshot`을 통한 스냅샷 위력 표시 활성화 여부 (선택 사항).
    *   애드온은 플레이어의 현재 직업 및 전문화에 따라 올바른 목록을 자동으로 선택합니다.

5.  **동적 업데이트**:
    *   대상 변경, 주시 대상 변경, 보스 전투 시작, 특성 변경과 같은 게임 이벤트에 반응하여 DoT 표시를 업데이트합니다.
    *   주기적인 타이머 또한 DoT가 정기적으로 새로고침되도록 보장합니다.

## 사용자 설정

핵심 사용자 설정은 `asDotFilter/asDotFilter.lua` 파일 상단의 Lua 변수를 편집하여 수행합니다:

*   `ADotF_SIZE`: DoT 아이콘의 크기를 설정합니다.
*   `ADotF_MAX_DEBUFF_SHOW`: 유닛 프레임당 표시할 최대 DoT 아이콘 수를 정의합니다 (현재 로직은 전문화에 설정된 모든 DoT를 표시하는 것으로 보임).
*   `ADotF_ALPHA`: DoT 아이콘의 투명도를 제어합니다.
*   `ADotF_CooldownFontSize`: 숫자 재사용 대기시간 텍스트의 글꼴 크기.
*   `ADotF_CountFontSize`: 중첩 횟수 텍스트의 글꼴 크기.
*   `ADotF_UnitList`: DoT 아이콘을 표시할 유닛 프레임을 지정할 수 있는 Lua 테이블입니다 (예: `"target"`, `"focus"`, `"boss1"`).
*   **주문 목록** (`ADotF_ShowList_<CLASS>_<SPEC>`): 고급 사용자는 이 목록을 수정하여 추적할 DoT, 알림 임계값 또는 스냅샷 확인 동작을 변경할 수 있습니다.
