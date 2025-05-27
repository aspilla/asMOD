# asFixUnitFrame

asFixUnitFrame is a World of Warcraft addon that provides a collection of optional tweaks to the default Blizzard unit frames (Player, Target, TargetofTarget). It also includes a unique feature to display a single, high-priority debuff directly on the target's portrait. Many features are configurable through the in-game addon settings menu.

## Main Features

*   **Optional Unit Frame Modifications (Configurable via Addon Settings)**:
    *   **Hide Combat Text on Frames**: Option to prevent Blizzard's default floating combat text from appearing directly on the Player, Target, and Pet unit frames.
    *   **Hide Target's Buffs/Debuffs**: Option to remove the standard buff and debuff icons from the Target unit frame.
    *   **Hide Target's Cast Bar**: Option to conceal the cast bar on the Target unit frame.
    *   **Hide Player's Class Bar**: Option to hide the special class resource displays (e.g., Rogue Combo Points, Death Knight Runes, Evoker Essence, Shaman Totem Bar).
    *   **Show Numeric Threat**: Option to enable or disable the display of numerical threat values on unit frames (sets the `threatShowNumeric` CVar).
    *   **Class Color Health Bars**: Option to color the health bars of Player, Target, and TargetofTarget frames according to the unit's class (if they are a player).

*   **Target Portrait Debuff Display (`ShowPortraitDebuff` option)**:
    *   If enabled, displays a single, filtered debuff icon directly overlaid on the Target's portrait.
    *   **Filtering Logic**: Shows a harmful debuff that is flagged as `nameplateShowAll` (generally important) and has a duration of 10 seconds or less.
    *   It has a secondary filter (`ns.ShowOnlyMine`) to avoid showing certain common player-applied debuffs on the portrait if they weren't cast by the current player (aiming to highlight external, high-priority debuffs).
    *   The icon includes a circular cooldown swipe indicating remaining duration.
    *   Provides a tooltip on mouseover for the displayed debuff.

*   **Conditional Loading**: The addon checks if "asUnitFrame" (presumably a more comprehensive unit frame addon from the same author/suite) is loaded. If it is, `asFixUnitFrame` will not initialize its main features to prevent conflicts.

## Configuration

Most features can be toggled via the Blizzard Addon Settings panel:
1.  Open Game Menu (Esc).
2.  Click "Options".
3.  Go to the "AddOns" tab.
4.  Select "asFixUnitFrame" from the list.
5.  Adjust the checkbox settings as desired.
    *   **Note**: Changing these settings requires a `ReloadUI()` to take effect, which the game will prompt you for.

Advanced configuration or modification of the `ns.ShowOnlyMine` list requires editing the `asFixUnitFrame/asFixUnitFrameOption.lua` file.

Key internal variables affecting behavior:
*   `CONFIG_MAX_COOL` (in `asFixUnitFrame.lua`): Hardcoded to 10 seconds, determining the maximum duration for a debuff to be considered for the portrait display.
*   `ns.options.*` (populated from saved variables or defaults in `asFixUnitFrameOption.lua`): These hold the state of the toggleable features.

---

# asFixUnitFrame

asFixUnitFrame은 블리자드 기본 유닛 프레임(플레이어, 대상, 대상의 대상)에 대한 여러 선택적 조정을 제공하는 월드 오브 워크래프트 애드온입니다. 또한 대상의 초상화에 단일의 우선순위가 높은 디버프를 직접 표시하는 독특한 기능을 포함합니다. 대부분의 기능은 게임 내 애드온 설정 메뉴를 통해 설정할 수 있습니다.

## 주요 기능

*   **선택적 유닛 프레임 수정 (애드온 설정을 통해 구성 가능)**:
    *   **프레임 위 전투 텍스트 숨기기**: 플레이어, 대상 및 소환수 유닛 프레임에 블리자드 기본 전투 상황 알림 텍스트가 직접 나타나지 않도록 하는 옵션입니다.
    *   **대상의 버프/디버프 숨기기**: 대상 유닛 프레임에서 표준 버프 및 디버프 아이콘을 제거하는 옵션입니다.
    *   **대상의 시전바 숨기기**: 대상 유닛 프레임의 시전바를 숨기는 옵션입니다.
    *   **플레이어 직업 바 숨기기**: 특수 직업 자원 표시(예: 도적 연계 점수, 죽음의 기사 룬, 기원사 정수, 주술사 토템 바)를 숨기는 옵션입니다.
    *   **숫자 위협 수준 표시**: 유닛 프레임에 숫자 위협 수준 표시를 활성화하거나 비활성화하는 옵션입니다 (`threatShowNumeric` CVar 설정).
    *   **직업 색상 생명력 바**: 플레이어, 대상 및 대상의 대상 프레임의 생명력 바를 유닛의 직업(플레이어인 경우)에 따라 색칠하는 옵션입니다.

*   **대상 초상화 디버프 표시 (`ShowPortraitDebuff` 옵션)**:
    *   활성화된 경우, 대상의 초상화에 직접 오버레이된 단일 필터링된 디버프 아이콘을 표시합니다.
    *   **필터링 로직**: `nameplateShowAll`(일반적으로 중요함)로 플래그 지정되고 지속 시간이 10초 이하인 해로운 디버프를 표시합니다.
    *   특정 일반적인 플레이어 적용 디버프가 현재 플레이어가 시전하지 않은 경우 초상화에 표시되지 않도록 하는 보조 필터(`ns.ShowOnlyMine`)가 있습니다 (외부의 우선순위 높은 디버프를 강조하기 위함).
    *   아이콘에는 남은 지속 시간을 나타내는 원형 재사용 대기시간 효과가 포함됩니다.
    *   표시된 디버프에 마우스를 올리면 툴팁을 제공합니다.

*   **조건부 로딩**: 애드온은 "asUnitFrame"(아마도 동일한 제작자/제품군의 더 포괄적인 유닛 프레임 애드온)이 로드되었는지 확인합니다. 로드된 경우 `asFixUnitFrame`은 충돌을 방지하기 위해 주요 기능을 초기화하지 않습니다.

## 설정

대부분의 기능은 블리자드 애드온 설정 패널을 통해 전환할 수 있습니다:
1.  게임 메뉴(Esc)를 엽니다.
2.  "설정"을 클릭합니다.
3.  "애드온" 탭으로 이동합니다.
4.  목록에서 "asFixUnitFrame"을 선택합니다.
5.  원하는 대로 확인란 설정을 조정합니다.
    *   **참고**: 이러한 설정을 변경하면 `ReloadUI()`가 필요하며, 게임에서 이를 요청하는 메시지가 표시됩니다.

`ns.ShowOnlyMine` 목록의 고급 설정 또는 수정은 `asFixUnitFrame/asFixUnitFrameOption.lua` 파일을 편집해야 합니다.

동작에 영향을 미치는 주요 내부 변수:
*   `CONFIG_MAX_COOL` (`asFixUnitFrame.lua` 내): 10초로 하드코딩되어 있으며, 초상화 표시에 고려될 디버프의 최대 지속 시간을 결정합니다.
*   `ns.options.*` (`asFixUnitFrameOption.lua`의 저장된 변수 또는 기본값에서 채워짐): 전환 가능한 기능의 상태를 유지합니다.
