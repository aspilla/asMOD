# asMOD Collection (Midnight)

asMOD is a collection of custom-made World of Warcraft addons.

![sample](https://github.com/aspilla/asMOD/blob/main/.Pictures/asmod_party.jpg?raw=true)

<iframe width="560" height="315" src="https://www.youtube.com/embed/jxMk3LePSxk?si=j5YbrMeHnzxF47or" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" referrerpolicy="strict-origin-when-cross-origin" allowfullscreen></iframe>

<iframe width="560" height="315" src="https://www.youtube.com/embed/0zHGbe_qgHo?si=EgcUnzB4wVjHYt5W" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" referrerpolicy="strict-origin-when-cross-origin" allowfullscreen></iframe>

## Features of asMOD

* **Simple:** Each addon functions independently and focuses on enhancing the default UI with lightweight features.
* **Optimized Performance:** Highly optimized to minimize impact on game performance, ensuring smooth gameplay without lag or frame drops.
* **Easy Installation:** Can be installed with a single click.
* **All Classes & Specs Support**
* **Retail (Midnight) Support**

## Changes from Midnight Expansion
* **Combat API Secret Transition:** Tracking for buffs/debuffs and additional calculations has been restricted. Consequently, many asMOD combat-related addons have been modified or had features reduced.
* **Blizzard Announcement:** https://warcraft.wiki.gg/wiki/Patch_12.0.0/Planned_API_changes
* **Default UI Integration:** DBM/Details features have been integrated into the default WoW UI; asMOD has been updated to utilize these default UI elements.
* **Enhanced Standalone Convenience:** The `/asconfig` and `/asclear` commands for repositioning can now be used even if you only install individual addons without the main `asMOD` package.

## Unsupported Addons (from Midnight)
* asAutoMarker: Unsupported due to the inability to track mob GUIDs.
* asBooldlustAlert: Unsupported due to debuff tracking restrictions.
* asDBMCastingAlert: Unsupported due to the removal of DBM integration.
* asDotSnapshot: Unsupported due to debuff tracking restrictions.
* asFixCombatText: Unsupported as combat values have been moved to secret status.
* asHealerChatAlert: Unsupported as mana values are now secret.
* asOverlay: Unsupported due to buff tracking restrictions.
* asReady: Unsupported due to restrictions on tracking skill usage.
* asSummonTracker: Unsupported due to restrictions on tracking skill usage.

## Important Note (asUnitFrame)
The following issue may occur:
**Edit Mode Error:** Errors may occur when using Edit Mode, which might prevent settings from being changed. Please disable `asUnitFrame` before making changes in Edit Mode.

## Installation (CurseForge)
1. Install `asMOD` from CurseForge (asMOD includes other asMOD addons: https://www.curseforge.com/wow/addons/asmod).
2. When using the `asMOD` addon, a window will state "asMOD will change the default interface settings." Click **Change**.
3. Go to `ESC > Options > Gameplay > Advanced Cooldown Settings` to configure the center buttons. The default setup targets 6 large icons and 1 buff bar.
4. Use the **asMOD Setup macro** in `ESC > Macros` to apply recommended settings (e.g., reduced damage font size). This also enables Misdirection/Tank Assist macros.
5. Check `ESC > Edit Mode` to ensure the **"asMOD_Layout"** is properly applied.
6. If you do not want the bottom action bar to hide automatically, uncheck `asHideActionBar` in `ESC > Addons`.

<iframe width="560" height="315" src="https://www.youtube.com/embed/-7xsxpKTS7U?si=Rj7atkBM71u8X6mM" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" referrerpolicy="strict-origin-when-cross-origin" allowfullscreen></iframe>

## Installation (Inven)

1. Download the latest version from the **Inven** addon library.
2. (Optional) Reset game settings by clicking the gear icon next to the Play button in the launcher.
3. (Optional) Backup your existing Font, Interface, and WTF folders (or delete them).
4. Open the game folder from the launcher and extract the files into the `_retail_` directory.
5. When using the `asMOD` addon, a window will state "asMOD will change the default interface settings." Click **Change**.
6. Go to `ESC > Options > Gameplay > Advanced Cooldown Settings` to configure the center buttons. The default setup targets 6 large icons and 1 buff bar.
7. Use the **asMOD Setup macro** in `ESC > Macros` to apply recommended settings (e.g., reduced damage font size). This also enables Misdirection/Tank Assist macros.
8. Check `ESC > Edit Mode` to ensure the **"asMOD_Layout"** is properly applied.
9. If you do not want the bottom action bar to hide automatically, uncheck `asHideActionBar` in `ESC > Addons`.

<iframe width="560" height="315" src="https://www.youtube.com/embed/WZQ_9VIF7RE?si=ojzV4SJ17osDU6mA" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" referrerpolicy="strict-origin-when-cross-origin" allowfullscreen></iframe>

## Configuration After Talent Change
1. Go to `ESC > Edit Mode` and select the **"asMOD_Layout"** profile.

## How to Update
1. All asMOD addons can be updated via CurseForge.
2. For **Inven** users, simply repeat steps **1** and **4** of the installation guide.

## How to Uninstall
1. Delete the installed folders (`Interface` and `Font`).
2. Go to `ESC > Edit Mode` and delete the `asMOD_Layout` profile.
3. It is recommended to reset your WoW settings to default.

## Positioning Guide
1. Use the `/asconfig` command to adjust frame positions.
2. Disable `asUnitFrame` before using `Edit Mode`. Repositioned layouts should be saved with a **new name** other than `asMOD_Layout`.

## asMOD Addon List (Midnight)
Each asMOD addon functions independently. If you wish to use only specific addons, you can install them separately via the links below:

| Addon | Description | CurseForge | Github |
| :--- | :--- | :---: | :---: |
| asActiveAlert | Highlighted spell alerts displayed to the left of the character | [Link](https://www.curseforge.com/wow/addons/asactivealert) | [Link](https://github.com/aspilla/asMOD/tree/main/asActiveAlert) |
| asBattleRes | Combat Resurrection charges and cooldown display | [Link](https://www.curseforge.com/wow/addons/asbattleres) | [Link](https://github.com/aspilla/asMOD/tree/main/asBattleRes) |
| asBuffFilter | Target buff display | [Link](https://www.curseforge.com/wow/addons/asbufffilter) | [Link](https://github.com/aspilla/asMOD/tree/main/asBuffFilter) |
| asCastBar | Cast bar with icons and cast time display | [Link](https://www.curseforge.com/wow/addons/ascastbar) | [Link](https://github.com/aspilla/asMOD/tree/main/asCastBar) |
| asCastingAlert | Target spell cast notifications | [Link](https://www.curseforge.com/wow/addons/ascastingalert) | [Link](https://github.com/aspilla/asMOD/tree/main/asCastingAlert) |
| asCombatInfo | Enhanced Cooldown Manager | [Link](https://www.curseforge.com/wow/addons/ascombatinfo) | [Link](https://github.com/aspilla/asMOD/tree/main/asCombatInfo) |
| asCombatTimer | Displays time elapsed since combat started | [Link](https://www.curseforge.com/wow/addons/ascombattimer) | [Link](https://github.com/aspilla/asMOD/tree/main/asCombatTimer) |
| asCooldownPulse | Trinket, Racial, Healthstone, and Potion cooldown display | [Link](https://www.curseforge.com/wow/addons/ascooldownpulse) | [Link](https://github.com/aspilla/asMOD/tree/main/asCooldownPulse) |
| asCompactRaidBuff | Raid and Party frame enhancements | [Link](https://www.curseforge.com/wow/addons/ascompactraidbuff) | [Link](https://github.com/aspilla/asMOD/tree/main/asCompactRaidBuff) |
| asCPUProfile | Monitor addon latency performance (/asCPU) | [Link](https://www.curseforge.com/wow/addons/ascpuprofile) | [Link](https://github.com/aspilla/asMOD/tree/main/asCPUProfile) |
| asDBMTimer | Enhanced Boss Timeline | [Link](https://www.curseforge.com/wow/addons/asdbmtimer) | [Link](https://github.com/aspilla/asMOD/tree/main/asDBMTimer) |
| asDebuffFilter | Player and Target debuff display | [Link](https://www.curseforge.com/wow/addons/asdebufffilter) | [Link](https://github.com/aspilla/asMOD/tree/main/asDebuffFilter) |
| asDotFilter | Tracks Boss/Focus debuffs | [Link](https://www.curseforge.com/wow/addons/asdotfilter) | [Link](https://github.com/aspilla/asMOD/tree/main/asDotFilter) |
| asFixChat | Supports `Tab` channel switching and `URL Copy` | [Link](https://www.curseforge.com/wow/addons/asfixchat) | [Link](https://github.com/aspilla/asMOD/tree/main/asFixChat) |
| asFixHotkey | Abbreviates action bar hotkey text | [Link](https://www.curseforge.com/wow/addons/asfixhotkey) | [Link](https://github.com/aspilla/asMOD/tree/main/asFixHotkey) |
| asFixUnitFrame | Hides specific Blizzard default unit frame elements | [Link](https://www.curseforge.com/wow/addons/asfixunitframe) | [Link](https://github.com/aspilla/asMOD/tree/main/asFixUnitFrame) |
| asGCDBar | Global Cooldown (GCD) status bar | [Link](https://www.curseforge.com/wow/addons/asgcdbar) | [Link](https://github.com/aspilla/asMOD/tree/main/asGCDBar) |
| asGearScoreLite | Shows item levels in Character and Inspect windows | [Link](https://www.curseforge.com/wow/addons/asgearscorelite) | [Link](https://github.com/aspilla/asMOD/tree/main/asGearScoreLite) |
| asHealthText | (Not included) Text-based HUD | [Link](https://www.curseforge.com/wow/addons/ashealthtext) | [Link](https://github.com/aspilla/asMOD/tree/main/asHealthText) |
| asHideActionBar | Automatically hides Action Bar 1 | [Link](https://www.curseforge.com/wow/addons/ashideactionbar) | [Link](https://github.com/aspilla/asMOD/tree/main/asHideActionBar) |
| asHideBagsBar | Automatically hides the bottom-right menu/bags bar | [Link](https://www.curseforge.com/wow/addons/ashidebagsbar) | [Link](https://github.com/aspilla/asMOD/tree/main/asHideBagsBar) |
| asHideNamePlates | Hides nameplates except for casting mobs | [Link](https://www.curseforge.com/wow/addons/ashidenameplates) | [Link](https://github.com/aspilla/asMOD/tree/main/asHideNamePlates) |
| asInformation | Displays primary and secondary stat gains | [Link](https://www.curseforge.com/wow/addons/asinformation) | [Link](https://github.com/aspilla/asMOD/tree/main/asInformation) |
| asInterruptHelper | Interrupt/Stun skill cooldown display | [Link](https://www.curseforge.com/wow/addons/asinterrupthelper) | [Link](https://github.com/aspilla/asMOD/tree/main/asInterruptHelper) |
| asMisdirection | Automated Misdirection and Tricks of the Trade macro | [Link](https://www.curseforge.com/wow/addons/asmisdirection) | [Link](https://github.com/aspilla/asMOD/tree/main/asMisdirection) |
| asMOD | asMOD Collection Settings | [Link](https://www.curseforge.com/wow/addons/asmod) | [Link](https://github.com/aspilla/asMOD/tree/main/asMOD) |
| asNamePlates | Nameplate enhancement addon | [Link](https://www.curseforge.com/wow/addons/asnameplates) | [Link](https://github.com/aspilla/asMOD/tree/main/asNamePlates) |
| asPowerBar | Displays Main and Class resources | [Link](https://www.curseforge.com/wow/addons/aspowerbar) | [Link](https://github.com/aspilla/asMOD/tree/main/asPowerBar) |
| asPremadeGroupsFilter | Premade Group Finder (Keystone/Raid) enhancement | [Link](https://www.curseforge.com/wow/addons/aspremadegroupsfilter) | [Link](https://github.com/aspilla/asMOD/tree/main/asPremadeGroupsFilter) |
| asRangeDisplay | Distance display for Target/Focus/Mouseover | [Link](https://www.curseforge.com/wow/addons/asrangedisplay) | [Link](https://github.com/aspilla/asMOD/tree/main/asRangeDisplay) |
| asScavenger | Automatic junk item selling | [Link](https://www.curseforge.com/wow/addons/asscavenger) | [Link](https://github.com/aspilla/asMOD/tree/main/asScavenger) |
| asSkyRide | `Skyriding` resource, speed, and cooldown display | [Link](https://www.curseforge.com/wow/addons/asskyride) | [Link](https://github.com/aspilla/asMOD/tree/main/asSkyRide) |
| asSpamFilter | Repositions default UI error message location | [Link](https://www.curseforge.com/wow/addons/asspamfilter) | [Link](https://github.com/aspilla/asMOD/tree/main/asSpamFilter) |
| asTargetCastBar | Cast bars for Target/Focus | [Link](https://www.curseforge.com/wow/addons/astargetcastingbar) | [Link](https://github.com/aspilla/asMOD/tree/main/asTargetCastBar) |
| asTrueGCD | Displays history of recently used spells and items | [Link](https://www.curseforge.com/wow/addons/astruegcd) | [Link](https://github.com/aspilla/asMOD/tree/main/asTrueGCD) |
| asUnitFrame | Simple unit frames | [Link](https://www.curseforge.com/wow/addons/asunitframe) | [Link](https://github.com/aspilla/asMOD/tree/main/asUnitFrame) |

# Contact & Support
1. **Korean Users:** Visit the **Inven asMOD Forum** (https://www.inven.co.kr/board/wow/5288)
2. **English Users:** Visit the **asMOD YouTube Channel** (https://www.youtube.com/@asmod-wow)

---
# asMOD 모음집 (한밤)

asMOD는 직접 만든 월드 오브 워크래프트 애드온들을 모음

![sample](https://github.com/aspilla/asMOD/blob/main/.Pictures/asmod_party.jpg?raw=true)

<iframe width="560" height="315" src="https://www.youtube.com/embed/jxMk3LePSxk?si=j5YbrMeHnzxF47or" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" referrerpolicy="strict-origin-when-cross-origin" allowfullscreen></iframe>

<iframe width="560" height="315" src="https://www.youtube.com/embed/0zHGbe_qgHo?si=EgcUnzB4wVjHYt5W" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" referrerpolicy="strict-origin-when-cross-origin" allowfullscreen></iframe>

## asMOD의 특징

*   **Simple:** 각 애드온은 기본 UI를 강화하는 간단한 기능만 지원하며 개별로 동작
*   **최적화된 성능:** 게임 성능에 영향을 주지 않도록 최적화되어 있어, 렉이나 프레임 저하 없이 쾌적하게 플레이 가능.
*   **간단한 설치** 클릭 한번으로 설치 가능 
*   **모든 직업 및 특성 지원** 
*   **본섭(한밤) 지원** 

## 한밤 부터 변경이 되는 것
*   **전투 API Secret 전환**으로 버프/디버프 등 추적이 막힘, 다른 정보도 추가 연산이 막혀 전투 애드온인 asMOD도 많은 애드온이 수정되고 기능이 축소 되었음.
*   **블리자드 공지** https://warcraft.wiki.gg/wiki/Patch_12.0.0/Planned_API_changes
*   DBM/Details 기능이 와우 기본 UI로 흡수 되었음, asMOD도 와우 기본 UI를 사용하도록 변경
*   위치 이동을 위한 `/asconfig`, `/asclear` 명령어를 `asMOD`를 굳이 설치 안하고 개별 애드온을 사용하는 경우에도 사용할 수 있어, 개별 애드온 사용 편의성을 강화

## 한밤 부터 미지원 애드온
*   asAutoMarker : 몹 GUID 파악이 불가하여 미지원
*   asBooldlustAlert : 디버프 추적 불가로 미지원
*   asDBMCastingAlert : DBM 삭제로 미지원
*   asDotSnapshot : 디버프 추적 불가로 미지원
*   asFixCombatText : 비밀 값으로 변경되어 미지원
*   asHealerChatAlert : 마나 남은 값이 비밀 값으로 미지원
*   asOverlay : 버프 추적 불가로 미지원
*   asReady : 스킬 사용 여부 파악이 막혀 미지원
*   asSummonTracker : 시킬 사용 여부 파악이 막혀 미지원

## 주의사항 (asUnitFrame 관련)
다음과 같은 오류가 발생 할 수 있음.
**편집 모드 오류:** 편집 모드 사용 시 오류가 발생하여 설정 변경이 불가능할 수 있음. asUnitFrame을 끈 상태에서 편집 모드를 진행 필요.

## 설치 방법 (CurseForge)
1. CurseForge 에서 asMOD를 설치 (asMOD에 다른 asMOD 애드온들이 포함 되어 있음, https://www.curseforge.com/wow/addons/asmod)
2. `asMOD` 애드온 사용시 `asMOD가 '기본 인터페이스 설정'을 변경합니다. 채팅창에 '/asMOD'명령어로 기능을 다시 불러 올 수 있습니다.` 창에서 `변경`을 클릭
3. `esc >> 설정 >> 게임 플레이 개선 >> 고급 재사용 대기시간 설정` 클릭하여 가운데 버튼 설정을 합니다. 큰 아이콘 6개, 버프바 1개 사용을 목표로 설정 하였습니다.
4. `esc >> 매크로 설정` 에서 asMOD Setup 매크로를 사용하면 데미지 폰트 사이즈 축소등 추천 설정 사용이 가능합니다. 추가로 눈속임/탱커 지원 매크로도 사용가능 합니다.
5. `esc >>폅집 모드 >> "asMOD_Layout"` 설정이 잘  되어 있는 지 확인 합니다.
6. 하단 단축바가 자동으로 사라지는 것을 원치 않으면 esc >> 애드온 >> `asHideActionBar`를 채크 해제 하세요.

<iframe width="560" height="315" src="https://www.youtube.com/embed/-7xsxpKTS7U?si=Rj7atkBM71u8X6mM" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" referrerpolicy="strict-origin-when-cross-origin" allowfullscreen></iframe>

## 설치 방법 (인벤)

1. `인벤` 자료실에서 "다운로드" 버튼을 눌러 최신 버전을 받습니다.
2. (선택 사항) 런처 플레이버튼 옆 톱니바퀴를 눌러 게임 설정을 초기화 합니다. 
3. (선택 사항) 기존 Font, Interface, WTF 폴더를 Backup 합니다. (삭제 하셔도 됩니다.)
4. 런처에서 게임 폴더를 열어 _retail_ 에 압축을 풀어 줍니다.
5. `asMOD` 애드온 사용시 `asMOD가 '기본 인터페이스 설정'을 변경합니다. 채팅창에 '/asMOD'명령어로 기능을 다시 불러 올 수 있습니다.` 창에서 `변경`을 클릭
6. `esc >> 설정 >> 게임 플레이 개선 >> 고급 재사용 대기시간 설정` 클릭하여 가운데 버튼 설정을 합니다. 큰 아이콘 6개, 버프바 1개 사용을 목표로 설정 하였습니다.
7. `esc >> 매크로 설정` 에서 asMOD Setup 매크로를 사용하면 데미지 폰트 사이즈 축소등 추천 설정 사용이 가능합니다. 추가로 눈속임/탱커 지원 매크로도 사용가능 합니다.
8. `esc >>폅집 모드 >> "asMOD_Layout"` 설정이 잘  되어 있는 지 확인 합니다.
9. 하단 단축바가 자동으로 사라지는 것을 원치 않으면 esc >> 애드온 >> `asHideActionBar`를 채크 해제 하세요.

<iframe width="560" height="315" src="https://www.youtube.com/embed/WZQ_9VIF7RE?si=ojzV4SJ17osDU6mA" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" referrerpolicy="strict-origin-when-cross-origin" allowfullscreen></iframe>

## 특성 변경 후 설정법
1. `esc >>폅집 모드 >> "asMOD_Layout"` 를 선택

## asMOD 업데이트 방법
1. 모든 asMOD 애드온은 CurseForge에서 업데이트 가능 합니다.
2. `인벤` 자료실 사용자의 경우 설치법의 `1번`/`4번만` 수행 하세요

## asMOD 삭제법 
1. 설치한 폴더를 지워 주세요. (`Interface`, `Font` 폴더를 지우시면 됩니다.)
2. esc >> 편집 모드 >> asMOD_Layout 을 삭제해 주세요.
3. 와우 설정을 초기화 하는 것을 추천 합니다.

## 위치 설정 방법
1. `/asconfig` 명령으로 위치 조정 가능 
2. `편집모드` 사용시 asUnitFrame 끄고 진행, `asMOD_Layout`이 아닌 새로운 이름으로 저장 필요

## asMOD 애드온 목록 (한밤)
모든 asMOD 애드온은 개별 동작 가능함, 일부 애드온만 사용 원할 경우 아래 Link를 통해 별도로 설치 가능

| 애드온 | 설명 | CurseForge | Github |
| :--- | :--- | :---: | :---: |
| asActiveAlert | 테두리 강조 주문 케릭 좌측 표시 | [링크](https://www.curseforge.com/wow/addons/asactivealert) | [링크](https://github.com/aspilla/asMOD/tree/main/asActiveAlert) |
| asBattleRes | 전투 부활 횟수/대기시간 표시 | [링크](https://www.curseforge.com/wow/addons/asbattleres) | [링크](https://github.com/aspilla/asMOD/tree/main/asBattleRes) |
| asBuffFilter | 대상의 버프를 표시 | [링크](https://www.curseforge.com/wow/addons/asbufffilter) | [링크](https://github.com/aspilla/asMOD/tree/main/asBuffFilter) |
| asCastBar | 시전 바에 아이콘과 시전시간 표시 | [링크](https://www.curseforge.com/wow/addons/ascastbar) | [링크](https://github.com/aspilla/asMOD/tree/main/asCastBar) |
| asCastingAlert | 대상 시전 주문 알림 | [링크](https://www.curseforge.com/wow/addons/ascastingalert) | [링크](https://github.com/aspilla/asMOD/tree/main/asCastingAlert) |
| asCombatInfo | 쿨다운 메니저 강화 | [링크](https://www.curseforge.com/wow/addons/ascombatinfo) | [링크](https://github.com/aspilla/asMOD/tree/main/asCombatInfo) |
| asCombatTimer | 전투 시작 후 경과 시간을 표시 | [링크](https://www.curseforge.com/wow/addons/ascombattimer) | [링크](https://github.com/aspilla/asMOD/tree/main/asCombatTimer) |
| asCooldownPulse | 장신구, 종특, 생석, 물약 쿨 표시 | [링크](https://www.curseforge.com/wow/addons/ascooldownpulse) | [링크](https://github.com/aspilla/asMOD/tree/main/asCooldownPulse) |
| asCompactRaidBuff | 공격대 및 파티 프레임 강화 | [링크](https://www.curseforge.com/wow/addons/ascompactraidbuff) | [링크](https://github.com/aspilla/asMOD/tree/main/asCompactRaidBuff) |
| asCPUProfile | 애드온 Latency 성능 확인 (/asCPU) | [링크](https://www.curseforge.com/wow/addons/ascpuprofile) | [링크](https://github.com/aspilla/asMOD/tree/main/asCPUProfile) |
| asDBMTimer | 보스 타임라인 강화 | [링크](https://www.curseforge.com/wow/addons/asdbmtimer) | [링크](https://github.com/aspilla/asMOD/tree/main/asDBMTimer) |
| asDebuffFilter | 플레이어 및 대상 디버프 표시 | [링크](https://www.curseforge.com/wow/addons/asdebufffilter) | [링크](https://github.com/aspilla/asMOD/tree/main/asDebuffFilter) |
| asDotFilter | 보스/주시 디버프를 추적 | [링크](https://www.curseforge.com/wow/addons/asdotfilter) | [링크](https://github.com/aspilla/asMOD/tree/main/asDotFilter) |
| asFixChat | `Tab` 채팅 채널 전환, `URL 복사` 지원 | [링크](https://www.curseforge.com/wow/addons/asfixchat) | [링크](https://github.com/aspilla/asMOD/tree/main/asFixChat) |
| asFixHotkey | 액션바 단축키 텍스트를 축약 | [링크](https://www.curseforge.com/wow/addons/asfixhotkey) | [링크](https://github.com/aspilla/asMOD/tree/main/asFixHotkey) |
| asFixUnitFrame | 블리자드 기본 유닛 프레임 기능 숨김 | [링크](https://www.curseforge.com/wow/addons/asfixunitframe) | [링크](https://github.com/aspilla/asMOD/tree/main/asFixUnitFrame) |
| asGCDBar | 전역 재사용 대기시간(GCD) 표시 바 | [링크](https://www.curseforge.com/wow/addons/asgcdbar) | [링크](https://github.com/aspilla/asMOD/tree/main/asGCDBar) |
| asGearScoreLite | 캐릭터 창/살펴보기 창에 아이템 레벨 표시 | [링크](https://www.curseforge.com/wow/addons/asgearscorelite) | [링크](https://github.com/aspilla/asMOD/tree/main/asGearScoreLite) |
| asHealthText | (미포함) 텍스트 기반 HUD | [링크](https://www.curseforge.com/wow/addons/ashealthtext) | [링크](https://github.com/aspilla/asMOD/tree/main/asHealthText) |
| asHideActionBar | 1번 액션 바를 자동 숨김 | [링크](https://www.curseforge.com/wow/addons/ashideactionbar) | [링크](https://github.com/aspilla/asMOD/tree/main/asHideActionBar) |
| asHideBagsBar | 우측 하단의 메뉴 자동 숨김 | [링크](https://www.curseforge.com/wow/addons/ashidebagsbar) | [링크](https://github.com/aspilla/asMOD/tree/main/asHideBagsBar) |
| asHideNamePlates | 케스팅중인 몹 외 이름표를 숨김 | [링크](https://www.curseforge.com/wow/addons/ashidenameplates) | [링크](https://github.com/aspilla/asMOD/tree/main/asHideNamePlates) |
| asInformation | 1차/2차 능력치 증가량 표시 | [링크](https://www.curseforge.com/wow/addons/asinformation) | [링크](https://github.com/aspilla/asMOD/tree/main/asInformation) |
| asInterruptHelper | 차단/스턴 스킬 쿨다운 표시 | [링크](https://www.curseforge.com/wow/addons/asinterrupthelper) | [링크](https://github.com/aspilla/asMOD/tree/main/asInterruptHelper) |
| asMisdirection | 눈속임, 속임수 거래 자동 매크로 | [링크](https://www.curseforge.com/wow/addons/asmisdirection) | [링크](https://github.com/aspilla/asMOD/tree/main/asMisdirection) |
| asMOD | asMOD 모음집 설정 | [링크](https://www.curseforge.com/wow/addons/asmod) | [링크](https://github.com/aspilla/asMOD/tree/main/asMOD) |
| asNamePlates | 이름표 강화 애드온 | [링크](https://www.curseforge.com/wow/addons/asnameplates) | [링크](https://github.com/aspilla/asMOD/tree/main/asNamePlates) |
| asPowerBar | 주 자원/직업 자원 표시 | [링크](https://www.curseforge.com/wow/addons/aspowerbar) | [링크](https://github.com/aspilla/asMOD/tree/main/asPowerBar) |
| asPremadeGroupsFilter | 쐐기돌/공격대 검색 창 강화 | [링크](https://www.curseforge.com/wow/addons/aspremadegroupsfilter) | [링크](https://github.com/aspilla/asMOD/tree/main/asPremadeGroupsFilter) |
| asRangeDisplay | 대상/주시/마우스오버 거리를 표시 | [링크](https://www.curseforge.com/wow/addons/asrangedisplay) | [링크](https://github.com/aspilla/asMOD/tree/main/asRangeDisplay) |
| asScavenger | 자동 잡템 판매 | [링크](https://www.curseforge.com/wow/addons/asscavenger) | [링크](https://github.com/aspilla/asMOD/tree/main/asScavenger) |
| asSkyRide | `하늘 비행` 자원/속도/쿨 표시 | [링크](https://www.curseforge.com/wow/addons/asskyride) | [링크](https://github.com/aspilla/asMOD/tree/main/asSkyRide) |
| asSpamFilter | 기본 UI 오류 메시지 표시 위치를 이동 | [링크](https://www.curseforge.com/wow/addons/asspamfilter) | [링크](https://github.com/aspilla/asMOD/tree/main/asSpamFilter) |
| asTargetCastBar | 대상/주시대상 시전 바 | [링크](https://www.curseforge.com/wow/addons/astargetcastingbar) | [링크](https://github.com/aspilla/asMOD/tree/main/asTargetCastBar) |
| asTrueGCD | 최근 주문/아이템 기록 표시 | [링크](https://www.curseforge.com/wow/addons/astruegcd) | [링크](https://github.com/aspilla/asMOD/tree/main/asTrueGCD) |
| asUnitFrame | 간단한 유닛 프레임 | [링크](https://www.curseforge.com/wow/addons/asunitframe) | [링크](https://github.com/aspilla/asMOD/tree/main/asUnitFrame) |

# 문의 방법
1. `한글 유저` : `인벤 asMOD 포럼` 방문 (https://www.inven.co.kr/board/wow/5288)
2. `영문 유저` : `Youtube asMOD 채널` 방문 (https://www.youtube.com/@asmod-wow)