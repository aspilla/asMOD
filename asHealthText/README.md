# asHealthText

asHealthText is a World of Warcraft addon that displays a customizable, text-based Head-Up Display (HUD) for crucial combat information. It shows health and resource percentages for the player, target, and pet, along with threat, incoming heals, and class-specific resources.

## Main Features

*   **Text-Based Information Hub**:
    *   **Player Stats**: Health % and Mana/Power %.
    *   **Target Stats**: Health % (class-colored if player) and Mana/Power %.
    *   **Pet Stats**: Health % and Mana/Power %.
    *   **Threat Display**: Current threat percentage on the target, colored by status.
    *   **Target's Target**: Name of your target's target, class-colored.
    *   **Incoming Heals & Absorbs**: Shows predicted health % after incoming heals, and/or current absorb % on the player.
    *   **Raid Icon**: Displays the raid target icon set on your current target.
    *   **Class-Specific Resources**:
        *   Death Knight: Rune count.
        *   Paladin: Holy Power.
        *   Warlock: Soul Shards.
        *   Druid (Feral/Guardian): Combo Points.
        *   Rogue: Combo Points.
        *   Monk (Brewmaster): Stagger percentage.
        *   Monk (Windwalker/Mistweaver): Chi.
        *   Mage (Arcane): Arcane Charges.
        *   Evoker: Essence.
        *   *(Note: Class resource display is disabled if the `asPowerBar` addon is loaded).*

*   **Customizable Appearance**:
    *   Font, font sizes (for health, mana, pet text separately), and font outline can be configured.
    *   Dynamic color-coding for health (green to red), mana (by resource type), and threat.

*   **Layout Configuration**:
    *   The entire block of text can be positioned using X/Y offsets.
    *   An option (`AHT_RIGHT_COMBO`) alters the relative placement of class resources, raid icons, and pet information.

*   **Combat Visibility**:
    *   The display is typically shown upon entering combat and hidden when leaving combat.
    *   An option (`AHT_COMBAT_OFF_SHOW`) allows the display to remain visible even out of combat.

*   **Vehicle Support**: Attempts to display vehicle health/power when the player is controlling a vehicle.

## How it Works

The addon creates a series of configurable font strings anchored to a central (hidden) frame. It then populates these font strings with data obtained from various game API functions, updating them in response to relevant game events (e.g., health changes, target changes, combat status) and a periodic timer. Class-specific resource tracking is enabled based on the player's class and specialization, and is disabled if `asPowerBar` is active.

## Configuration

Configuration is done by editing Lua variables at the top of `asHealthText/asHealthText.lua`:

*   `AHT_Font`: The font face to be used. (Default: `STANDARD_TEXT_FONT`)
*   `AHT_HealthSize`: Font size for player and target health percentages. (Default: 18)
*   `AHT_ManaSize`: Font size for player and target mana/power percentages and threat. (Default: 14)
*   `AHT_PetHealthSize`: Font size for pet health percentage. (Default: 12)
*   `AHT_PetManaSize`: Font size for pet mana/power percentage. (Default: 10)
*   `AHT_FontOutline`: Font outline style (e.g., "THICKOUTLINE", "OUTLINE"). (Default: "THICKOUTLINE")
*   `AHT_X`: Horizontal offset for the text block from the center of the screen. (Default: 150, placing target info to the right)
*   `AHT_Y`: Vertical offset for the text block from the center of the screen. (Default: -55, placing it below center)
*   `AHT_COMBAT_OFF_SHOW`: Set to `true` to keep the display visible out of combat. (Default: `false`)
*   `AHT_RIGHT_COMBO`: Set to `true` to change the layout of class resources, raid icon, and pet info relative to player/target health. (Default: `false`)

Internal variables that can be toggled (requiring Lua edit):
*   `bupdate_heal`: Set to `false` to disable incoming heal/absorb display. (Default: `true`)

**Note**: This addon does not provide an in-game configuration panel.

---

# asHealthText

asHealthText는 중요한 전투 정보를 위한 사용자 정의 가능한 텍스트 기반 HUD(Head-Up Display)를 표시하는 월드 오브 워크래프트 애드온입니다. 플레이어, 대상 및 소환수의 생명력 및 자원 백분율을 위협 수준, 받는 치유량, 직업별 자원과 함께 보여줍니다.

## 주요 기능

*   **텍스트 기반 정보 허브**:
    *   **플레이어 능력치**: 생명력 % 및 마나/기력 %.
    *   **대상 능력치**: 생명력 % (플레이어인 경우 직업 색상) 및 마나/기력 %.
    *   **소환수 능력치**: 생명력 % 및 마나/기력 %.
    *   **위협 수준 표시**: 대상에 대한 현재 위협 수준 백분율을 상태별 색상으로 표시합니다.
    *   **대상의 대상**: 대상의 대상 이름을 직업 색상으로 표시합니다.
    *   **받는 치유량 및 흡수량**: 플레이어에게 들어오는 치유량을 포함한 예상 생명력 % 및/또는 현재 흡수량 %를 표시합니다.
    *   **공격대 아이콘**: 현재 대상에게 설정된 공격대 대상 아이콘을 표시합니다.
    *   **직업별 자원**:
        *   죽음의 기사: 룬 개수.
        *   성기사: 신성한 힘.
        *   흑마법사: 영혼의 조각.
        *   드루이드 (야성/수호): 연계 점수.
        *   도적: 연계 점수.
        *   수도사 (양조): 시간차 피해량 백분율.
        *   수도사 (풍운/운무): 기.
        *   마법사 (비전): 비전 충전물.
        *   기원사: 정수.
        *   *(참고: `asPowerBar` 애드온이 로드된 경우 직업 자원 표시는 비활성화됩니다.)*

*   **사용자 정의 가능한 외형**:
    *   글꼴, 글꼴 크기(생명력, 마나, 소환수 텍스트 각각), 글꼴 외곽선을 설정할 수 있습니다.
    *   생명력(녹색에서 빨간색으로), 마나(자원 유형별), 위협 수준에 대한 동적 색상 코딩.

*   **레이아웃 설정**:
    *   전체 텍스트 블록은 X/Y 오프셋을 사용하여 위치를 지정할 수 있습니다.
    *   `AHT_RIGHT_COMBO` 옵션은 직업 자원, 공격대 아이콘 및 소환수 정보의 상대적 배치를 변경합니다.

*   **전투 중 표시 여부**:
    *   디스플레이는 일반적으로 전투에 진입하면 표시되고 전투에서 벗어나면 숨겨집니다.
    *   `AHT_COMBAT_OFF_SHOW` 옵션을 사용하면 전투 중이 아닐 때도 디스플레이를 계속 볼 수 있습니다.

*   **차량 지원**: 플레이어가 차량을 제어할 때 차량의 생명력/자원을 표시하려고 시도합니다.

## 작동 방식

애드온은 중앙(숨겨진) 프레임에 고정된 일련의 설정 가능한 글꼴 문자열을 만듭니다. 그런 다음 다양한 게임 API 함수에서 얻은 데이터로 이러한 글꼴 문자열을 채우고, 관련 게임 이벤트(예: 생명력 변경, 대상 변경, 전투 상태) 및 주기적인 타이머에 응답하여 업데이트합니다. 직업별 자원 추적은 플레이어의 직업 및 전문화에 따라 활성화되며, `asPowerBar`가 활성화된 경우 비활성화됩니다.

## 설정

설정은 `asHealthText/asHealthText.lua` 파일 상단의 Lua 변수를 편집하여 수행합니다:

*   `AHT_Font`: 사용할 글꼴입니다. (기본값: `STANDARD_TEXT_FONT`)
*   `AHT_HealthSize`: 플레이어 및 대상 생명력 백분율의 글꼴 크기입니다. (기본값: 18)
*   `AHT_ManaSize`: 플레이어 및 대상 마나/기력 백분율 및 위협 수준의 글꼴 크기입니다. (기본값: 14)
*   `AHT_PetHealthSize`: 소환수 생명력 백분율의 글꼴 크기입니다. (기본값: 12)
*   `AHT_PetManaSize`: 소환수 마나/기력 백분율의 글꼴 크기입니다. (기본값: 10)
*   `AHT_FontOutline`: 글꼴 외곽선 스타일입니다 (예: "THICKOUTLINE", "OUTLINE"). (기본값: "THICKOUTLINE")
*   `AHT_X`: 화면 중앙에서 텍스트 블록의 가로 오프셋입니다. (기본값: 150, 대상 정보를 오른쪽에 배치)
*   `AHT_Y`: 화면 중앙에서 텍스트 블록의 세로 오프셋입니다. (기본값: -55, 중앙 아래에 배치)
*   `AHT_COMBAT_OFF_SHOW`: 전투 중이 아닐 때 디스플레이를 계속 표시하려면 `true`로 설정합니다. (기본값: `false`)
*   `AHT_RIGHT_COMBO`: 직업 자원, 공격대 아이콘 및 소환수 정보의 레이아웃을 플레이어/대상 생명력 기준으로 변경하려면 `true`로 설정합니다. (기본값: `false`)

내부 변수 (Lua 편집 필요):
*   `bupdate_heal`: 받는 치유량/흡수량 표시를 비활성화하려면 `false`로 설정합니다. (기본값: `true`)

**참고**: 이 애드온은 게임 내 설정 패널을 제공하지 않습니다.
