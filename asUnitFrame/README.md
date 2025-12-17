# asUnitFrame

### Default Layout
![asUnitFrame](https://github.com/aspilla/asMOD/blob/main/.Pictures/asUnitFrame.jpg?raw=true)

### Layout with Portraits Disabled
![asUnitFrame](https://github.com/aspilla/asMOD/blob/main/.Pictures/asmod_raid.jpg?raw=true)

This addon replaces the default Blizzard unit frames. It is highly recommended to use it alongside other **asMOD** addons for the best experience. Recommended companion addons:

* **asPowerBar**: Displays resources like Energy, Mana, etc.
* **asDebuffFilter**: Displays target debuffs.
* **asBuffFilter**: Displays target buffs.
* **asDotFilter**: Displays boss debuffs.
* **asTargetCastingBar**: Displays the target's casting bar.

## Supported Unit Frames
* Player
* Target
* Focus
* Pet
* Target of Target
* Boss (1 ~ 5)

## Key Features

* **Health Bar:**
    * Displays current health, maximum health, and percentage (%).
    * Indicates "Dead" status and class colors.
    * *(Note: Incoming heals and absorption shields are currently unsupported).*
* **Resource Bar:**
    * Hidden if the primary resource is already shown by `asPowerBar`.
    * Displays an additional mana bar for hybrid classes (Player).
* **Casting Bar (Focus, Boss):**
    * Displays spell name, icon, and remaining/total time.
* **Status Icons:**
    * Elite/Rare/World Boss markers.
    * Combat and Resting (Player) indicators.
    * Party/Raid Leader and Role (Tank/Healer/DPS) icons.
* **Raid Markers:** Displays assigned raid icons (currently shown as numbers).
* **Aggro (Threat Level):** Shows player's threat % and status via color changes on the Target frame.
* **Portraits (Optional):** Displays unit portraits.
* **Debuff Display (Pet, Target of Target):** Shows up to 4 debuffs at the bottom of the frame.
* **Buff Display (Boss):**
    * Shows up to 4 buffs on the left side (Optional).
    ![asUnitFrame](https://github.com/aspilla/asMOD/blob/main/.Pictures/asunitframe_bossbuff.jpg?raw=true)
* **Totem Bar (Optional, Player):**
    * Displays a totem bar below the Player frame.
    * Click an icon to immediately destroy the corresponding totem.
* **Target Highlight (Optional, Focus, Boss):**
    * Displays a white border if the unit is your current target.
* **Range Check (Optional, Target, Focus, Boss):**
    * Hostile frames become transparent if the target is further than 40m (30m for Evokers/Demon Hunters).
* **Hide Default UI:** Automatically hides default Blizzard Player, Target, Focus, Pet, and Boss frames.
* **Interaction:** Supports right-click menus and modern Ping/Click-casting systems.
* **Vehicle Support:** Automatically swaps Player/Pet frames when entering a vehicle.
* **Dynamic Transparency:** 50% transparency out of combat, 100% (fully opaque) during combat.

## Configuration

1. **Positioning:**
    * **Requires the `asMOD` core addon to be installed.**
    * Use the `/asconfig` command in-game to move frames.
    * *Note: Manual resizing is not supported.*

2. **Addon Settings (ESC > Options > Addons > asUnitFrame):**
    * `ShowPortrait`: Toggle unit portraits.
    * `ShowTotemBar`: Toggle the totem bar below the player frame.
    * `ShowBossBuff`: Show up to 4 buffs on Boss frames.
    * `ShowTargetBorder`: White border on Focus/Boss when they are your current target.
    * `CheckRange`: Enable distance-based transparency.
    * `OffPortraitDebuffOnRaid`: Disable stun debuff overlays on portraits during raids.

## Troubleshooting (Known Issues)

The following issues may occur due to Blizzard's security restrictions:

1. **Focus Setting:** An error may occur when setting a Focus via the right-click menu. Please use a `/focus` macro or keybind instead.
2. **Raid Markers:** Setting raid markers via the right-click menu may trigger an error.
3. **Edit Mode Conflict:** Errors may occur if you use Blizzard's "Edit Mode" while the addon is active. Please disable asUnitFrame temporarily if you need to use Edit Mode.

---
# asUnitFrame

기본 설정
![asUnitFrame](https://github.com/aspilla/asMOD/blob/main/.Pictures/asUnitFrame.jpg?raw=true)

초상화 미사용 설정시
![asUnitFrame](https://github.com/aspilla/asMOD/blob/main/.Pictures/asmod_raid.jpg?raw=true)

기본 유닛 프레임을 대체하는 애드온입니다. 다른 asMOD 애드온과 함께 사용하는 것을 권장하며, 다음 애드온들이 추천됩니다:
* asPowerBar : 기력등을 표시
* asDebuffFilter : 대상의 디버프를 표시
* asBuffFilter : 대상의 버프를 표시
* asDotFilter : 보스의 디버프를 표시
* asTargetCastingBar : 대상이 시전을 표시


## 지원 유닛 프레임
*   플레이어 (Player)
*   대상 (Target)
*   주시 대상 (Focus)
*   소환수 (Pet)
*   대상의 대상 (Target of Target)
*   보스 (Boss 1 ~ 5) 프레임을 지원합니다.

## 주요 기능
*   **체력 바:**
       *   현재 체력, 최대 체력, 백분율(%) 표시.
       *   죽음 상태 표시.
       *   받는 치유량 및 보호막(흡수량) 표시. (현재 미지원)
       *   직업 색상 표시        
*   **자원 바:**
    *   플레이어의 주 자원은 asPowerBar에 표시 되면 미표시
    *   주자원 외 마나 보유 시 마나 바 추가 표시 (플레이어)        
*   **시전 바 (주시 대상, 보스):**
    *   현재 시전 주문의 이름, 아이콘, 남은 시간/총 시간 표시.
*   **상태 아이콘:**
    *   정예/희귀/월드 보스 아이콘 표시.
    *   전투 중 아이콘 표시.
    *   휴식 중 아이콘 표시 (플레이어).
    *   파티장/공격대장 아이콘 표시.
    *   역할(방어/공격/치유) 아이콘 표시.
*   **공격대 징표:** 설정된 공격대 징표(별, 동그라미 등)를 표시. (현재 숫자로 표시)
*   **어그로(위협 수준):** 대상 프레임에서 플레이어의 위협 수준(%) 및 상태를 색상으로 표시. 
*   **초상화 (선택 사항):**
    *   유닛 초상화를 표시
*   **디버프 표시 (소환수, 대상의 대상):**
    *   프레임 하단에 디버프 표시. (최대 4개)
*   **버프 표시 (보스):**
    *   프레임 좌측에 버프 표시 (최대 4개, 옵션)
    ![asUnitFrame](https://github.com/aspilla/asMOD/blob/main/.Pictures/asunitframe_bossbuff.jpg?raw=true)
*   **토템 바 (선택 사항, 플레이어):**
    *   플레이어 프레임 하단에 토템바 표시
    *   아이콘 클릭으로 해당 토템을 즉시 파괴 가능
*   **대상 선택 여부 (선택 사항, 주시대상, 보스):**
    *   주시 대상 프레임, 보스 프레임의 경우 현재 대상인 경우 흰 테두리 표시.
*   **거리 파악(선택 사항, 대상, 주시대상, 보스):**
    *   적대적 대상의 경우 대상과의 거리가 40m 이상인 경우 투명화 됩니다. (기원사/악사 30ms)
*   **기본 UI 숨김:** 기본 블리자드 유닛 프레임(플레이어, 대상, 주시 대상, 소환수, 보스)을 자동으로 숨김.
*   **우클릭 메뉴:** 각 유닛 프레임에서 우클릭 시 대상 상호작용 메뉴 가능.
*   **핑(Ping)/클릭 시전 시스템 지원:** 
*   **차량 탑승:** 플레이어가 차량에 탑승하면 플레이어 프레임이 차량 유닛으로, 소환수 프레임이 플레이어 유닛으로 자동 전환.
*   **전투 상태 투명도:** 비전투 시 프레임 투명도가 약간 낮아지고(50%), 전투 시 완전히 불투명해집니다(100%).

## 설정

1.  **위치 지정:**
    *   **`asMOD` 애드온이 설치되어 있어야 합니다.**
    *   게임 내에서 `/asconfig` 명령어를 입력하여 이동 가능
    *   크기 조정 불가
    
2.  **esc >> 설정 >> 애드온 >> asUnitFrame 설정:**
    *   `ShowPortrait` : 초상화 표시 여부
    *   `ShowTotemBar` : 플레이어 프레임 하단에 토템바 표시 여부
    *   `ShowBossBuff` : 보스 프레임에 버프 4개 표시 여부 
    *   `ShowTargetBorder` : 주시/보스가 대상인 경우 하얀색 테두리 표시
    *   `CheckRange` : 대상/주시/보스와의 거리를 체크
    *   `OffPortraitDebuffOnRaid` : 레이드에서는 초상화에 스턴 디버프 표시 안함

## 주의사항 (오류 관련)

다음과 같은 오류가 발생 할 수 있습니다.

1.  **주시 대상 설정 오류:** 프레임을 우클릭하여 메뉴를 통해 주시 대상을 설정할 경우 오류가 발생합니다. `/focus` 매크로 또는 단축키를 설정하여 사용하시길 권장합니다.
2.  **징표 설정 오류:** 프레임을 우클릭하여 메뉴를 통해 징표 설정시 오류가 발생합니다. 
3.  **편집 모드 오류:** 편집 모드 사용 시 오류가 발생하여 설정 변경이 불가능할 수 있습니다. asUnitFrame을 끈 상태에서 편집 모드를 진행하세요.
