## asUnitFrame (Simple UnitFrame)

Default Settings
![asUnitFrame](https://github.com/aspilla/asMOD/blob/main/.Pictures/asUnitFrame.jpg?raw=true)

Settings without Portrait
![asUnitFrame](https://github.com/aspilla/asMOD/blob/main/.Pictures/asmod_raid.jpg?raw=true)

`asUnitFrame` is a World of Warcraft addon that replaces the default unit frames (Player, Target, etc.) with a customizable display.
Assuming you are using other addons from the asMOD suite, it is recommended to use this addon alongside:
*   `asPowerBar`: Displays resources like Energy, etc.
*   `asDebuffFilter`: Displays debuffs on the target.
*   `asBuffFilter`: Displays buffs on the target.
*   `asDotFilter`: Displays debuffs on bosses.
*   `asTargetCastingBar`: Displays the target's cast bar.

### Main Features

1.  **Custom Unit Frames:**
    *   Supports: Player, Target, Focus, Pet, Target of Target, Boss (1-5).

2.  **Information Display:**
    *   **Health Bar:**
        *   Displays current health, maximum health, and percentage (%).
        *   Indicates dead status.
        *   Visualizes incoming heals and absorbs.
        *   Colored by class or reaction (friendly/hostile) based on unit type/role.
        *   Shows numerical values (current/max) and percentage (%) text.
    *   **Resource Bar:**
        *   Displays Mana and primary resources.
        *   Color changes based on resource type.
        *   For certain classes (e.g., Druids), an additional mana bar is shown if they have mana besides their primary resource (Player frame).
        *   Shows numerical value text.
    *   **Cast Bar (Focus, Boss):**
        *   Displays the currently casting spell's name, icon, remaining/total time.
        *   Shows cast target (highlighted if it's the player).
        *   **Interruptibility Indicator:** Cast bar color indicates if the spell is interruptible and whether the player is the target.
        *   **DBM Integration:** If DBM is installed, the cast bar border is highlighted (yellow) for dangerous spells designated by DBM.
    *   **Name & Level:** Displays the unit's name and level.
    *   **Status Icons:**
        *   Shows Elite/Rare/World Boss icons.
        *   Shows Combat icon.
        *   Shows Resting icon (Player frame).
        *   Shows Party/Raid Leader icon.
        *   Shows Role icon (Tank/DPS/Healer).
    *   **Raid Target Markers:** Displays assigned raid target icons (Star, Circle, etc.).
    *   **Threat (Aggro Level):** On the Target frame, displays the player's threat percentage (%) and status color (if not tanking).
    *   **Portrait (Optional):**
        *   Option to display unit portraits.
        *   For Target/Focus, the portrait includes a display for major debuffs.
    *   **Debuffs (Pet, Target of Target):**
        *   Displays debuff icons, remaining duration, and stack count below the frame (max 4).
    *   **Totem Bar (Optional, Player):**
        *   Displays currently active totem icons and remaining duration below the player frame.
        *   Clicking an icon instantly destroys the corresponding totem.

3.  **Other Features:**
    *   **Hide Default UI:** Automatically hides the default Blizzard unit frames (Player, Target, Focus, Pet, Boss).
    *   **Right-Click Menu:** Right-clicking on a unit frame shows the standard interaction menu (Invite, Whisper, etc.).
    *   **Ping System Integration:** Unit frames can be pinged.
    *   **Vehicle Support:** When the player enters a vehicle, the Player frame becomes the vehicle unit, and the Pet frame becomes the player unit.
    *   **Combat Alpha:** Frame alpha is slightly reduced (50%) when out of combat and becomes fully opaque (100%) during combat.

### Settings

1.  **Position & Size:**
    *   **Requires the `asMOD` addon.**
    *   Enter `/asconfig` in the game chat to open the configuration window.
    *   In the `asUnitFrame` section, select each frame (`AUF_PlayerFrame`, `AUF_TargetFrame`, `AUF_FocusFrame`, `AUF_PetFrame`, `AUF_TargetTargetFrame`, `AUF_BossFrame1` ~ `5`) to freely adjust its position and size, then save.

2.  **In-Code Settings (Top of `asUnitFrame.lua`):**
    *   `Update_Rate`: Frame update frequency (Default: 0.1 seconds). Smaller values update more often but may increase CPU usage.
    *   `config_width`, `healthheight`, `powerheight`: Default dimensions for frame elements. (Can be overridden by `asMOD` settings).
    *   `xposition`, `yposition`: Default position for Player/Target frames. (Can be overridden by `asMOD` settings).
    *   `CONFIG_NOT_INTERRUPTIBLE_COLOR`: Cast Bar - Non-interruptible (target is not me) color (RGB).
    *   `CONFIG_NOT_INTERRUPTIBLE_COLOR_TARGET`: Cast Bar - Non-interruptible (target is me) color (RGB).
    *   `CONFIG_INTERRUPTIBLE_COLOR`: Cast Bar - Interruptible (target is not me) color (RGB).
    *   `CONFIG_INTERRUPTIBLE_COLOR_TARGET`: Cast Bar - Interruptible (target is me) color (RGB).
    *   `AUF_ShowTotemBar`: Show Totem Bar (`true` or `false`, Default: `false`).
    *   `ns.options.ShowPortrait`: Show Portrait (`true` or `false`). (May also be configurable via `asMOD` options panel).

3.  **DBM Integration:**
    *   If the DBM addon is installed, the dangerous spell highlight feature for the cast bar is automatically enabled without extra configuration.

## Notes (Regarding Errors)

The following errors may occur:

1.  **Set Focus Error:** An error occurs when setting the focus target via the right-click menu on the frame. It is recommended to use the `/focus` macro or set a keybind.
2.  **Edit Mode Error:** Using Edit Mode may cause errors, potentially making configuration changes impossible. Please configure settings with asUnitFrame disabled before entering Edit Mode.

---
## asUnitFrame (간단한 UnitFrame)

기본 설정
![asUnitFrame](https://github.com/aspilla/asMOD/blob/main/.Pictures/asUnitFrame.jpg?raw=true)

초상화 미사용 설정시
![asUnitFrame](https://github.com/aspilla/asMOD/blob/main/.Pictures/asmod_raid.jpg?raw=true)

`asUnitFrame`은 월드 오브 워크래프트의 기본 유닛 프레임(플레이어, 대상 등)을 대체하여 사용자 정의 가능한 형태로 표시해주는 애드온입니다.
asMOD 대 다른 애드온을 사용하고 있다는 가정으로, 다음 애드온과 같이 사용하는 것을 추천 합니다.
* asPowerBar : 기력등을 표시
* asDebuffFilter : 대상의 디버프를 표시
* asBuffFilter : 대상의 버프를 표시
* asDotFilter : 보스의 디버프를 표시
* asTargetCastingBar : 대상이 시전을 표시

### 주요 기능

1.  **커스텀 유닛 프레임:**
    *   플레이어 (Player)
    *   대상 (Target)
    *   주시 대상 (Focus)
    *   소환수 (Pet)
    *   대상의 대상 (Target of Target)
    *   보스 (Boss 1 ~ 5) 프레임을 지원합니다.

2.  **정보 표시:**
    *   **체력 바:**
        *   현재 체력, 최대 체력, 백분율(%) 표시.
        *   죽음 상태 표시.
        *   받는 치유량 및 보호막(흡수량) 시각적 표시.
        *   플레이어 또는 역할(방어/공격/치유)에 따라 직업 색상 또는 관계 기반 색상(우호/적대)으로 표시됩니다.
        *   수치값(현재/최대) 및 백분율(%) 텍스트 표시.
    *   **자원 바:**
        *   마나, 주 자원을 표시합니다.
        *   자원 종류에 따라 색상이 변경됩니다.
        *   드루이드 등 일부 직업의 경우 주 자원 외 마나 보유 시 마나 바 추가 표시 (플레이어 프레임).
        *   수치값 텍스트 표시.
    *   **시전 바 (주시 대상, 보스):**
        *   현재 시전 주문의 이름, 아이콘, 남은 시간/총 시간 표시.
        *   시전 대상 표시 (대상이 플레이어일 경우 강조).
        *   **차단 가능 여부 표시:** 시전 바 색상을 통해 차단 가능 여부 및 해당 주문의 대상이 플레이어인지 여부를 구분하여 표시합니다. 
        *   **DBM 연동:** DBM 애드온이 설치된 경우, DBM에서 지정한 위험 주문 시전 시 시전 바 테두리가 강조(노란색)됩니다.
    *   **이름 및 레벨:** 유닛의 이름과 레벨 표시.
    *   **상태 아이콘:**
        *   정예/희귀/월드 보스 아이콘 표시.
        *   전투 중 아이콘 표시.
        *   휴식 중 아이콘 표시 (플레이어 프레임).
        *   파티장/공격대장 아이콘 표시.
        *   역할(방어/공격/치유) 아이콘 표시.
    *   **공격대 징표:** 설정된 공격대 징표(별, 동그라미 등)를 표시합니다.
    *   **어그로(위협 수준):** 대상 프레임에서 플레이어의 위협 수준(%) 및 상태를 색상으로 표시합니다. (탱커가 아닐 경우)
    *   **초상화 (선택 사항):**
        *   유닛 초상화를 표시하는 옵션 제공.
        *   대상/주시 대상의 경우 초상화에 주요 해로운 효과 표시 기능 포함.
    *   **해로운 효과 (Debuffs) (소환수, 대상의 대상):**
        *   프레임 하단에 해로운 효과 아이콘 및 남은 시간, 중첩 수를 표시합니다. (최대 4개)
    *   **토템 바 (선택 사항, 플레이어):**
        *   플레이어 프레임 하단에 현재 활성화된 토템 아이콘 및 남은 시간을 표시합니다.
        *   아이콘 클릭으로 해당 토템을 즉시 파괴할 수 있습니다.

3.  **기타 기능:**
    *   **기본 UI 숨김:** 기본 블리자드 유닛 프레임(플레이어, 대상, 주시 대상, 소환수, 보스)을 자동으로 숨깁니다.
    *   **우클릭 메뉴:** 각 유닛 프레임에서 우클릭 시 대상 상호작용 메뉴(파티 초대, 귓속말 등)를 표시합니다.
    *   **핑(Ping) 시스템 연동:** 유닛 프레임에 핑을 찍을 수 있습니다.
    *   **차량 탑승:** 플레이어가 차량에 탑승하면 플레이어 프레임이 차량 유닛으로, 소환수 프레임이 플레이어 유닛으로 자동 전환됩니다.
    *   **전투 상태 투명도:** 비전투 시 프레임 투명도가 약간 낮아지고(50%), 전투 시 완전히 불투명해집니다(100%).

### 설정

1.  **위치 및 크기:**
    *   **`asMOD` 애드온이 설치되어 있어야 합니다.**
    *   게임 내에서 `/asconfig` 명령어를 입력하여 설정창을 엽니다.
    *   `asUnitFrame` 섹션에서 각 프레임(`AUF_PlayerFrame`, `AUF_TargetFrame`, `AUF_FocusFrame`, `AUF_PetFrame`, `AUF_TargetTargetFrame`, `AUF_BossFrame1` ~ `5`)을 선택하여 위치와 크기를 자유롭게 조절하고 저장할 수 있습니다.

2.  **코드 내 설정 (`asUnitFrame.lua` 파일 상단):**
    *   `Update_Rate`: 프레임 정보 갱신 주기 (기본값: 0.1초). 값이 작을수록 자주 갱신되지만 CPU 사용량이 늘어날 수 있습니다.
    *   `config_width`, `healthheight`, `powerheight`: 각 프레임 요소의 기본 크기. (`asMOD` 설정 시 덮어쓰기될 수 있습니다.)
    *   `xposition`, `yposition`: 플레이어/대상 프레임의 기본 위치. (`asMOD` 설정 시 덮어쓰기될 수 있습니다.)
    *   `CONFIG_NOT_INTERRUPTIBLE_COLOR`: 시전 바 - 차단 불가 (대상이 내가 아닐 때) 색상 (RGB).
    *   `CONFIG_NOT_INTERRUPTIBLE_COLOR_TARGET`: 시전 바 - 차단 불가 (대상이 나일 때) 색상 (RGB).
    *   `CONFIG_INTERRUPTIBLE_COLOR`: 시전 바 - 차단 가능 (대상이 내가 아닐 때) 색상 (RGB).
    *   `CONFIG_INTERRUPTIBLE_COLOR_TARGET`: 시전 바 - 차단 가능 (대상이 나일 때) 색상 (RGB).
    *   `AUF_ShowTotemBar`: 토템 바 표시 여부 (`true` 또는 `false`, 기본값 `false`).
    *   `ns.options.ShowPortrait`: 초상화 표시 여부 (`true` 또는 `false`). (`asMOD` 옵션 패널에서도 설정 가능할 수 있습니다.)

3.  **DBM 연동:**
    *   DBM 애드온이 설치되어 있으면 별도 설정 없이 자동으로 시전 바 위험 주문 강조 기능이 활성화됩니다.

## 주의사항 (오류 관련)

다음과 같은 오류가 발생 할 수 있습니다.

1.  **주시 대상 설정 오류:** 프레임을 우클릭하여 메뉴를 통해 주시 대상을 설정할 경우 오류가 발생합니다. `/focus` 매크로 또는 단축키를 설정하여 사용하시길 권장합니다.
2.  **편집 모드 오류:** 편집 모드 사용 시 오류가 발생하여 설정 변경이 불가능할 수 있습니다. asUnitFrame을 끈 상태에서 편집 모드를 진행하세요.4.  **주의 사항:**