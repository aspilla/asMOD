# asReady

asReady is a World of Warcraft addon designed to track and display important cooldowns for your party and raid members. It focuses on two main categories: party interrupts and major offensive cooldowns.

## Main Features

### 1. Party Interrupt Cooldown Display (`ShowPartyInterrupt` option)

*   When in a 5-man party (not a raid), this feature displays a list of recently used interrupt spells by party members.
*   Each entry shows:
    *   The icon of the interrupt spell used.
    *   The name of the party member who used it (colored by class).
    *   The remaining cooldown on their interrupt.
    *   The text "ON" in green if the interrupt is ready.
*   This display is a separate, movable frame (can be managed by `asMOD` if installed).
*   Helps coordinate interrupts in small group content.
*   The list of tracked interrupt spells is defined in `asReadyOption.lua`.

### 2. Offensive Cooldown Display on Unit Frames (`ShowPartyCool` & `ShowRaidCool` options)

*   Tracks major offensive cooldowns for all party and raid members based on their class and specialization.
*   Displays a small icon with cooldown text directly overlaid on each player's unit frame (in the Blizzard Compact Party/Raid Frames).
*   **Visual Cues**:
    *   Shows the icon of the specific offensive cooldown (e.g., Combustion, Avenging Wrath).
    *   Displays the remaining cooldown as a number.
    *   If the buff associated with the cooldown is currently active on the player, the icon is shown normally saturated.
    *   If the spell is on cooldown but the buff is not active, the icon is desaturated.
    *   The cooldown text turns red when the remaining time is very short (e.g., < 4 seconds).
*   Uses `LibOpenRaid-1.0` (an embedded library) to gather cooldown information for raid members other than the player.
*   The specific offensive cooldowns tracked for each class/spec are defined in `asReadyOption.lua`.
*   Helps visualize the availability of key damage cooldowns across the group.

### General

*   **In-Game Configuration**: Options to toggle these features are available in the Blizzard Addon Settings panel.
*   **`asMOD` Integration**: The party interrupt display frame can be positioned using `asMOD` if it's installed.

## How it Works

1.  **Spell Definition**: The addon uses predefined lists in `asReadyOption.lua` to know which interrupt spells and major offensive cooldowns to track for each class and specialization.
2.  **Event Monitoring**: It listens for `UNIT_SPELLCAST_SUCCEEDED` events to detect when tracked spells are used by group members.
3.  **Cooldown Tracking**:
    *   For party interrupts, it updates a dedicated list display.
    *   For offensive cooldowns, it uses `C_Spell.GetSpellCooldown` for the player and `LibOpenRaid` for other group members to get current cooldown status.
4.  **Display Update**:
    *   Party interrupt bars are updated with remaining times.
    *   Offensive cooldown icons are dynamically updated on the compact unit frames.
    *   The addon also updates its state on group changes, spec changes, and logins.

## Configuration

Settings can be accessed via the Blizzard Addon Settings panel:
1.  Open Game Menu (Esc).
2.  Click "Options".
3.  Go to the "AddOns" tab.
4.  Select "asReady".
5.  Adjust the following:
    *   **`ShowPartyInterrupt` (Checkbox)**: Toggle the display of the party interrupt cooldown bars. (Default: true)
    *   **`ShowPartyCool` (Checkbox)**: Toggle the display of offensive cooldowns on party unit frames. (Default: true)
    *   **`ShowRaidCool` (Checkbox)**: Toggle the display of offensive cooldowns on raid unit frames. (Default: true)
    *   Changing these settings requires a `ReloadUI()`.

Advanced configuration (editing spell lists, default position of interrupt bars) requires editing Lua variables in `asReady.lua` and `asReadyOption.lua`.

---

# asReady

asReady는 파티 및 공격대원의 중요 재사용 대기시간을 추적하고 표시하도록 설계된 월드 오브 워크래프트 애드온입니다. 주로 파티 차단 기술과 주요 공격 관련 재사용 대기시간의 두 가지 주요 범주에 중점을 둡니다.

## 주요 기능

### 1. 파티 차단 기술 재사용 대기시간 표시 (`ShowPartyInterrupt` 옵션)

*   공격대가 아닌 5인 파티에 있을 때, 이 기능은 파티원들이 최근 사용한 차단 주문 목록을 표시합니다.
*   각 항목은 다음을 보여줍니다:
    *   사용된 차단 주문의 아이콘.
    *   사용한 파티원의 이름 (직업 색상으로 표시).
    *   해당 차단 기술의 남은 재사용 대기시간.
    *   차단 기술이 준비되면 녹색으로 "ON" 텍스트 표시.
*   이 표시는 별도의 이동 가능한 프레임입니다 (`asMOD`가 설치된 경우 관리 가능).
*   소규모 그룹 콘텐츠에서 차단 기술을 조율하는 데 도움을 줍니다.
*   추적되는 차단 주문 목록은 `asReadyOption.lua`에 정의되어 있습니다.

### 2. 유닛 프레임에 공격 관련 재사용 대기시간 표시 (`ShowPartyCool` & `ShowRaidCool` 옵션)

*   모든 파티 및 공격대원의 주요 공격 관련 재사용 대기시간을 해당 직업 및 전문화에 따라 추적합니다.
*   각 플레이어의 유닛 프레임(블리자드 소규모 파티/공격대 프레임)에 직접 오버레이된 작은 아이콘과 재사용 대기시간 텍스트를 표시합니다.
*   **시각적 신호**:
    *   특정 공격 관련 재사용 대기시간의 아이콘을 표시합니다 (예: 발화, 응징의 격노).
    *   남은 재사용 대기시간을 숫자로 표시합니다.
    *   재사용 대기시간과 관련된 강화 효과가 현재 플레이어에게 활성화되어 있으면 아이콘이 정상 채도로 표시됩니다.
    *   주문이 재사용 대기 중이지만 강화 효과가 활성화되지 않은 경우 아이콘이 비활성화된 것처럼 약간 어둡게 표시됩니다.
    *   남은 시간이 매우 짧을 때(예: 4초 미만) 재사용 대기시간 텍스트가 빨간색으로 바뀝니다.
*   플레이어 이외의 공격대원 재사용 대기시간 정보를 수집하기 위해 `LibOpenRaid-1.0`(내장 라이브러리)을 사용합니다.
*   각 직업/전문화별로 추적되는 특정 공격 관련 재사용 대기시간은 `asReadyOption.lua`에 정의되어 있습니다.
*   그룹 전체의 주요 공격 관련 재사용 대기시간 가용성을 시각화하는 데 도움을 줍니다.

### 일반

*   **게임 내 설정**: 이러한 기능을 토글하는 옵션은 블리자드 애드온 설정 패널에서 사용할 수 있습니다.
*   **`asMOD` 연동**: 파티 차단 표시 프레임은 `asMOD`가 설치된 경우 이를 사용하여 위치를 지정할 수 있습니다.

## 작동 방식

1.  **주문 정의**: 애드온은 `asReadyOption.lua`의 미리 정의된 목록을 사용하여 각 직업 및 전문화에 대해 추적할 차단 주문과 주요 공격 관련 재사용 대기시간을 인식합니다.
2.  **이벤트 감시**: `UNIT_SPELLCAST_SUCCEEDED` 이벤트를 수신하여 그룹 구성원이 추적된 주문을 사용할 때를 감지합니다.
3.  **재사용 대기시간 추적**:
    *   파티 차단의 경우 전용 목록 표시를 업데이트합니다.
    *   공격 관련 재사용 대기시간의 경우 플레이어에게는 `C_Spell.GetSpellCooldown`을 사용하고 다른 그룹 구성원에게는 `LibOpenRaid`를 사용하여 현재 재사용 대기시간 상태를 가져옵니다.
4.  **표시 업데이트**:
    *   파티 차단 바가 남은 시간으로 업데이트됩니다.
    *   공격 관련 재사용 대기시간 아이콘이 소규모 유닛 프레임에서 동적으로 업데이트됩니다.
    *   애드온은 또한 그룹 변경, 전문화 변경 및 로그인 시 상태를 업데이트합니다.

## 설정

설정은 블리자드 애드온 설정 패널을 통해 접근할 수 있습니다:
1.  게임 메뉴(Esc)를 엽니다.
2.  "설정"을 클릭합니다.
3.  "애드온" 탭으로 이동합니다.
4.  목록에서 "asReady"를 선택합니다.
5.  다음을 조정합니다:
    *   **`ShowPartyInterrupt` (체크박스)**: 파티 차단 기술 재사용 대기시간 바 표시를 토글합니다. (기본값: true)
    *   **`ShowPartyCool` (체크박스)**: 파티 유닛 프레임에 공격 관련 재사용 대기시간 표시를 토글합니다. (기본값: true)
    *   **`ShowRaidCool` (체크박스)**: 공격대 유닛 프레임에 공격 관련 재사용 대기시간 표시를 토글합니다. (기본값: true)
    *   이러한 설정을 변경하려면 `ReloadUI()`가 필요합니다.

고급 설정(주문 목록 편집, 차단 바의 기본 위치)은 `asReady.lua` 및 `asReadyOption.lua`의 Lua 변수를 편집해야 합니다.
