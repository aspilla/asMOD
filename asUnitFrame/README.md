## asUnitFrame

Default settings
![asUnitFrame](https://github.com/aspilla/asMOD/blob/main/.Pictures/asUnitFrame.jpg?raw=true)

Portraits are disabled
![asUnitFrame](https://github.com/aspilla/asMOD/blob/main/.Pictures/asmod_raid.jpg?raw=true)

`asUnitFrame` is a World of Warcraft addon that replaces the default unit frames (player, target, etc.) with a customizable display. It is designed to be used with other asMOD addons, and the following are recommended:
* asPowerBar: Displays resources like energy.
* asDebuffFilter: Displays debuffs on the target.
* asBuffFilter: Displays buffs on the target.
* asDotFilter: Displays DoTs on bosses.
* asTargetCastingBar: Displays the target's cast bar.

### Key Features

1.  **Custom Unit Frames:**
    *   Player
    *   Target
    *   Focus
    *   Pet
    *   Target of Target
    *   Boss (1-5) frames are supported.

2.  **Information Display:**
    *   **Health Bar:**
        *   Shows current health, max health, and percentage (%).
        *   Indicates death status.
        *   Visually displays incoming healing and shields (absorbs).
        *   Colored by class or relationship (friendly/hostile) depending on the unit or role (tank/dps/healer).
        *   Displays numerical values (current/max) and percentage (%) text.
    *   **Resource Bar:**
        *   Displays mana and the primary resource.
        *   Color changes based on the resource type.
        *   For some classes like Druids, an additional mana bar is shown on the player frame if they have mana besides their primary resource.
        *   Displays numerical value text.
    *   **Cast Bar (Focus, Boss):**
        *   Shows the name, icon, and remaining/total time of the current spell being cast.
        *   Displays the cast target (highlighted if the target is the player).
        *   **Interruptibility:** The cast bar color indicates whether the spell can be interrupted and whether the player is the target.
        *   **DBM Integration:** If the DBM addon is installed, the cast bar border is highlighted (yellow) for dangerous spells designated by DBM.
    *   **Name and Level:** Displays the unit's name and level.
    *   **Status Icons:**
        *   Displays Elite/Rare/World Boss icons.
        *   Displays in-combat icon.
        *   Displays resting icon (player frame).
        *   Displays party leader/raid leader icon.
        *   Displays role (tank/dps/healer) icon.
    *   **Raid Target Markers:** Displays set raid markers (star, circle, etc.).
    *   **Threat (Aggro):** On the target frame, displays the player's threat level (%) and status with color coding.
    *   **Portrait (Optional):**
        *   Displays the unit's portrait (optional).
        *   For Target/Focus, the portrait can show major debuffs.
    *   **Debuff Display (Pet, Target of Target):**
        *   Displays remaining duration and stack count for up to 4 debuffs at the bottom of the frame.
    *   **Buff Display (Boss):**
        *   Displays up to 4 buffs on the left of the frame. If a buff is a major one according to DBM, its border is highlighted (optional).
        ![asUnitFrame](https://github.com/aspilla/asMOD/blob/main/.Pictures/asunitframe_bossbuff.jpg?raw=true)
    *   **Totem Bar (Optional, Player):**
        *   Displays currently active totems with their icons and remaining time below the player frame.
        *   Clicking an icon instantly destroys the corresponding totem (optional).
    *   **Target Selection Indicator (Optional, Focus, Boss):**
        *   A white border is displayed on the Focus and Boss frames if they are your current target.
    *   **Check Range(Optional, Target, Focus, Boss):**
        *   Check the range with target/focus/boss which can attack, if more than 40ms, change frame with less alpha (Evoker, 25ms)

3.  **Other Features:**
    *   **Hide Default UI:** Automatically hides the default Blizzard unit frames (Player, Target, Focus, Pet, Boss).
    *   **Right-Click Menu:** Displays the target interaction menu (invite to party, whisper, etc.) when right-clicking a unit frame.
    *   **Ping System Integration:** You can ping unit frames.
    *   **Vehicle Support:** When the player enters a vehicle, the player frame automatically switches to the vehicle unit, and the pet frame switches to the player unit.
    *   **Combat State Transparency:** Frames are slightly transparent (50%) out of combat and become fully opaque (100%) in combat.

### Configuration

1.  **Position and Size:**
    *   **The `asMOD` addon must be installed.**
    *   Type `/asconfig` in the game to open the configuration window.
    *   In the `asUnitFrame` section, you can select each frame (`AUF_PlayerFrame`, `AUF_TargetFrame`, `AUF_FocusFrame`, `AUF_PetFrame`, `AUF_TargetTargetFrame`, `AUF_BossFrame1` to `5`) to freely adjust its position and size, and then save the settings.

2.  **ESC >> Settings >> AddOns >> asUnitFrame:**
    *   `ShowPortrait`: Toggles the display of portraits.
    *   `ShowTotemBar`: Toggles the totem bar below the player frame.
    *   `ShowBossBuff`: Toggles the display of 4 buffs on boss frames.
    *   `ShowTargetBorder`: Toggles a white border on Focus/Boss frames when they are your target.
    *   `CheckRange` : Toggles whether to check the range with target/focus/bosses
    *   `OffPortraitDebuffOnRaid` : Toggles the display the stun debuff on portrait during raid play.

3.  **In-Code Settings (top of `asUnitFrame.lua` file):**
    *   `Update_Rate`: Frame information update frequency (default: 0.1 seconds). A lower value updates more frequently but may increase CPU usage.
    *   `config_width`, `healthheight`, `powerheight`: Default sizes for frame elements (can be overridden by `asMOD` settings).
    *   `xposition`, `yposition`: Default positions for player/target frames (can be overridden by `asMOD` settings).

4.  **DBM Integration:**
    *   If the DBM addon is installed, the dangerous spell highlight feature on the cast bar is activated automatically without any extra setup.

### Cautions (Known Issues)

The following errors may occur:

1.  **Set Focus Error:** Setting a focus target via the right-click menu on a frame can cause an error. It is recommended to use a `/focus` macro or a keybinding.
2.  **Edit Mode Error:** Using Edit Mode may cause errors and prevent settings from being changed. Please disable asUnitFrame before entering Edit Mode.

---

## asUnitFrame

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
    *   **어그로(위협 수준):** 대상 프레임에서 플레이어의 위협 수준(%) 및 상태를 색상으로 표시합니다. 
    *   **초상화 (선택 사항):**
        *   유닛 초상화를 표시 (옵션)
        *   대상/주시 대상의 경우 초상화에 주요 해로운 효과 표시 기능 포함.
    *   **디버프 표시 (소환수, 대상의 대상):**
        *   프레임 하단에 디버프 남은 시간, 중첩 수를 표시합니다. (최대 4개)
    *   **버프 표시 (보스):**
        *   프레임 좌측에 버프 표시, DBM 주요 버프이면 테두리 알림 (최대 4개, 옵션)
        ![asUnitFrame](https://github.com/aspilla/asMOD/blob/main/.Pictures/asunitframe_bossbuff.jpg?raw=true)
    *   **토템 바 (선택 사항, 플레이어):**
        *   플레이어 프레임 하단에 현재 활성화된 토템 아이콘 및 남은 시간을 표시합니다.
        *   아이콘 클릭으로 해당 토템을 즉시 파괴할 수 있습니다. (옵션)
    *   **대상 선택 여부 (선택 사항, 주시대상, 보스):**
        *   주시 대상 프레임, 보스 프레임의 경우 현재 대상인 경우 흰 테두리가 표시 됩니다.
    *   **거리 파악(선택 사항, 대상, 주시대상, 보스):**
        *   적대적 대상의 경우 대상과의 거리가 40m 이상인 경우 투명화 됩니다. (기원사 25ms)

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


2.  **esc >> 설정 >> 애드온 >> asUnitFrame 설정:**
    *   `ShowPortrait` : 초상화 표시 여부
    *   `ShowTotemBar` : 플레이어 프레임 하단에 토템바 표시 여부
    *   `ShowBossBuff` : 보스 프레임에 버프 4개 표시 여부 
    *   `ShowTargetBorder` : 주시/보스가 대상인 경우 하얀색 테두리 표시
    *   `CheckRange` : 대상/주시/보스와의 거리를 체크
    *   `OffPortraitDebuffOnRaid` : 레이드에서는 초상화에 스턴 디버프 표시 안함


3.  **코드 내 설정 (`asUnitFrame.lua` 파일 상단):**
    *   `Update_Rate`: 프레임 정보 갱신 주기 (기본값: 0.1초). 값이 작을수록 자주 갱신되지만 CPU 사용량이 늘어날 수 있습니다.
    *   `config_width`, `healthheight`, `powerheight`: 각 프레임 요소의 기본 크기. (`asMOD` 설정 시 덮어쓰기될 수 있습니다.)
    *   `xposition`, `yposition`: 플레이어/대상 프레임의 기본 위치. (`asMOD` 설정 시 덮어쓰기될 수 있습니다.)

4.  **DBM 연동:**
    *   DBM 애드온이 설치되어 있으면 별도 설정 없이 자동으로 시전 바 위험 주문 강조 기능이 활성화됩니다.

## 주의사항 (오류 관련)

다음과 같은 오류가 발생 할 수 있습니다.

1.  **주시 대상 설정 오류:** 프레임을 우클릭하여 메뉴를 통해 주시 대상을 설정할 경우 오류가 발생합니다. `/focus` 매크로 또는 단축키를 설정하여 사용하시길 권장합니다.
2.  **편집 모드 오류:** 편집 모드 사용 시 오류가 발생하여 설정 변경이 불가능할 수 있습니다. asUnitFrame을 끈 상태에서 편집 모드를 진행하세요.4.  **주의 사항:**
