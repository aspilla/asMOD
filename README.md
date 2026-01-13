# asMOD (Midnight)

asMOD is a collection of custom-made World of Warcraft addons.

![sample](https://github.com/aspilla/asMOD/blob/main/.Pictures/asmod_party.jpg?raw=true)

## Features of asMOD

* **Simple:** Each addon functions independently and focuses on enhancing the default UI with lightweight features.
* **Optimized Performance:** Optimized to minimize impact on game performance, ensuring smooth gameplay without lag or frame drops.
* **Easy Installation:** Can be installed with a single click.
* **All Classes & Specs:** Supports every class and specialization.
* **Retail (Midnight) Support:** Fully compatible with the latest expansion.

## Changes in Midnight
* **Combat API Secret Transition:** Tracking for buffs/debuffs and additional calculations has been restricted. Consequently, many asMOD combat-related addons have been modified or had features reduced.
* **Blizzard Announcement:** https://warcraft.wiki.gg/wiki/Patch_12.0.0/Planned_API_changes
* DBM/Details features have been integrated into the default WoW UI; asMOD has been updated to utilize the default UI as well.
* **Enhanced Standalone Use:** The `/asconfig` and `/asclear` commands for repositioning can now be used even if you only install individual addons without the main `asMOD` package.

## Unsupported Addons (from Midnight)
* asAutoMarker: Unsupported due to inability to track mob GUIDs.
* asBooldlustAlert: Unsupported due to debuff tracking restrictions.
* asDBMCastingAlert: Unsupported due to the removal of DBM integration.
* asDotSnapshot: Unsupported due to debuff tracking restrictions.
* asFixCombatText: Unsupported as combat text values are now secret.
* asHealerChatAlert: Unsupported as mana values are now secret.
* asReady: Unsupported due to restrictions on tracking skill usage.
* asSummonTracker: Unsupported due to restrictions on tracking skill usage.

## Important Note (Regarding asUnitFrame)

The following issue may occur:

1. **Edit Mode Error:** Errors may occur when using Edit Mode, preventing settings from being saved. Please disable asUnitFrame before making changes in Edit Mode.

## Installation (CurseForge)
1. Search for `asMOD_Kr` on CurseForge and install the addons.
2. When the asMOD popup appears stating "asMOD will change the default interface settings," click **Change**.
3. Adjust `ESC > Options > Gameplay > Advanced Cooldown Settings`.

<iframe width="560" height="315" src="https://www.youtube.com/embed/-7xsxpKTS7U?si=Rj7atkBM71u8X6mM" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" referrerpolicy="strict-origin-when-cross-origin" allowfullscreen></iframe>

## Installation (Inven)

1. The Inven version includes Korean fonts and has a different installation process. Please refer to the video below:
<iframe width="560" height="315" src="https://www.youtube.com/embed/6F7Amrvdda8?si=rKcZRo5ctJHyI0Zq" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" referrerpolicy="strict-origin-when-cross-origin" allowfullscreen></iframe>

2. Adjust `ESC > Options > Gameplay > Advanced Cooldown Settings`.
3. After installation, updates can be managed via CurseForge.

## Positioning Guide
1. Use the `/asconfig` command to adjust frame positions.

<iframe width="560" height="315" src="https://www.youtube.com/embed/sqFLkn9vQ_8?si=ZqZ5d-RYENt5tnhQ" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" referrerpolicy="strict-origin-when-cross-origin" allowfullscreen></iframe>

2. Disable `asUnitFrame` before using `Edit Mode`.

## asMOD Addon List (Midnight)

| Addon | Description | Link |
| :--- | :--- | :--- |
| asActiveAlert | Displays highlighted spells to the left of the character | [Link](https://www.curseforge.com/wow/addons/asactivealert) |
| asBattleRes | Displays Battle Resurrection charges and cooldown | [Link](https://www.curseforge.com/wow/addons/asbattleres) |
| asBuffFilter | Displays target buffs | [Link](https://www.curseforge.com/wow/addons/asbufffilter) |
| asCastBar | Shows icons and cast time on the cast bar | [Link](https://www.curseforge.com/wow/addons/ascastbar) |
| asCastingAlert | Target spell cast notifications | [Link](https://www.curseforge.com/wow/addons/ascastingalert) |
| asCombatInfo | Enhances the Cooldown Manager | [Link](https://www.curseforge.com/wow/addons/ascombatinfo) |
| asCombatTimer | Displays time elapsed since combat started | [Link](https://www.curseforge.com/wow/addons/ascombattimer) |
| asCooldownPulse | Shows cooldowns for trinkets, racials, healthstones, and potions | [Link](https://www.curseforge.com/wow/addons/ascooldownpulse) |
| asCompactRaidBuff | Enhancements for Raid and Party frames | [Link](https://www.curseforge.com/wow/addons/ascompactraidbuff) |
| asCPUProfile | Monitor addon latency performance (/asCPU) | [Link](https://www.curseforge.com/wow/addons/ascpuprofile) |
| asDBMTimer | Enhances the Boss Timeline | [Link](https://www.curseforge.com/wow/addons/asdbmtimer) |
| asDebuffFilter | Displays player and target debuffs | [Link](https://www.curseforge.com/wow/addons/asdebufffilter) |
| asDotFilter | Tracks Boss/Focus debuffs | [Link](https://www.curseforge.com/wow/addons/asdotfilter) |
| asFixChat | Supports `Tab` channel switching and `Copy URL` | [Link](https://www.curseforge.com/wow/addons/asfixchat) |
| asFixHotkey | Abbreviates action bar hotkey text | [Link](https://www.curseforge.com/wow/addons/asfixhotkey) |
| asFixUnitFrame | Hides specific default Blizzard unit frame elements | [Link](https://www.curseforge.com/wow/addons/asfixunitframe) |
| asGCDBar | Global Cooldown (GCD) progress bar | [Link](https://www.curseforge.com/wow/addons/asgcdbar) |
| asGearScoreLite | Shows item levels in Character and Inspect windows | [Link](https://www.curseforge.com/wow/addons/asgearscorelite) |
| asHealthText | Text-based HUD | [Link](https://www.curseforge.com/wow/addons/ashealthtext) |
| asHideActionBar | Automatically hides Action Bar 1 | [Link](https://www.curseforge.com/wow/addons/ashideactionbar) |
| asHideBagsBar | Automatically hides the bottom-right menu/bags bar | [Link](https://www.curseforge.com/wow/addons/ashidebagsbar) |
| asHideNameplates | Hides nameplates except for casting mobs | [Link](https://www.curseforge.com/wow/addons/ashidenameplates) |
| asInformation | Displays primary and secondary stat gains | [Link](https://www.curseforge.com/wow/addons/asinformation) |
| asInterruptHelper | Displays cooldowns for interrupt and stun skills | [Link](https://www.curseforge.com/wow/addons/asinterrupthelper) |
| asMisdirection | Automatic macro for Misdirection and Tricks of the Trade | [Link](https://www.curseforge.com/wow/addons/asmisdirection) |
| asMOD | Settings suite for the asMOD collection | [Link](https://www.curseforge.com/wow/addons/asmod) |
| asNamePlates | Nameplate enhancement addon | [Link](https://www.curseforge.com/wow/addons/asnameplates) |
| asPowerBar | Displays Primary and Class resources | [Link](https://www.curseforge.com/wow/addons/aspowerbar) |
| asPremadeGroupsFilter | Enhances Premade Group Finder (Dungeons/Raids) | [Link](https://www.curseforge.com/wow/addons/aspremadegroupsfilter) |
| asRangeDisplay | Displays distance to Target/Focus/Mouseover | [Link](https://www.curseforge.com/wow/addons/asrangedisplay) |
| asScavenger | Automatically sells junk items | [Link](https://github.com/aspilla/asMOD/blob/main/asScavenger/README.md) |
| asSkyRide | Displays `Skyriding` resources, speed, and cooldowns | [Link](https://www.curseforge.com/wow/addons/asskyride) |
| asSpamFilter | Moves the display location of default UI error messages | [Link](https://www.curseforge.com/wow/addons/asspamfilter) |
| asTargetCastBar | Cast bars for Target and Focus | [Link](https://www.curseforge.com/wow/addons/astargetcastingbar) |
| asTrueGCD | Displays history of recently used spells and items | [Link](https://www.curseforge.com/wow/addons/astruegcd) |
| asUnitFrame | Simple unit frames | [Link](https://www.curseforge.com/wow/addons/asunitframe) |


---

# asMOD (한밤)

asMOD는 직접 만든 월드 오브 워크래프트 애드온들을 모음

![sample](https://github.com/aspilla/asMOD/blob/main/.Pictures/asmod_party.jpg?raw=true)

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
*   asReady : 스킬 사용 여부 파악이 막혀 미지원
*   asSummonTracker : 시킬 사용 여부 파악이 막혀 미지원


## 주의사항 (asUnitFrame 관련)

다음과 같은 오류가 발생 할 수 있음.

1.  **편집 모드 오류:** 편집 모드 사용 시 오류가 발생하여 설정 변경이 불가능할 수 있음. asUnitFrame을 끈 상태에서 편집 모드를 진행 필요.

## 설치 방법 (CurseForge)
1. CurseForge 에서 asMOD_Kr을 검색하여 애드온들 설치
2. `asMOD` 애드온 사용시 `asMOD가 '기본 인터페이스 설정'을 변경합니다. 채팅창에 '/asMOD'명령어로 기능을 다시 불러 올 수 있습니다.` 창에서 `변경`을 클릭
3. `esc >> 옵션 >> 게임플레이 개선 >> 고급 재사용시간 설정` 조정

<iframe width="560" height="315" src="https://www.youtube.com/embed/-7xsxpKTS7U?si=Rj7atkBM71u8X6mM" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" referrerpolicy="strict-origin-when-cross-origin" allowfullscreen></iframe>

## 설치 방법 (인벤)

1. 인벤 버전은 한글 폰트를 포함하고 있어 설치법에 차이가 있음, 아래 영상을 참고
<iframe width="560" height="315" src="https://www.youtube.com/embed/6F7Amrvdda8?si=rKcZRo5ctJHyI0Zq" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" referrerpolicy="strict-origin-when-cross-origin" allowfullscreen></iframe>

2. `esc >> 옵션 >> 게임플레이 개선 >> 고급 재사용시간 설정` 조정
3. 설치 후 CurseForge로 업데이트 가능


## 위치 설정 방법
1. `/asconfig` 명령으로 위치 조정 가능

<iframe width="560" height="315" src="https://www.youtube.com/embed/sqFLkn9vQ_8?si=ZqZ5d-RYENt5tnhQ" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" referrerpolicy="strict-origin-when-cross-origin" allowfullscreen></iframe>

2. `편집모드` 사용시 asUnitFrame 끄고 진행


## asMOD 애드온 목록 (한밤)

| 애드온                   |설명                         |설명 | 
| --------------------- |------------------------------------------------------------------- |------- |
| asActiveAlert         |테두리 강조 주문 케릭 좌측 표시|<a href="https://www.curseforge.com/wow/addons/asactivealert" target="_blank" rel="nofollow">링크</a> |
| asBattleRes           |전투 부활 횟수/대기시간 표시|<a href="https://www.curseforge.com/wow/addons/asbattleres" target="_blank" rel="nofollow">링크</a> |
| asBuffFilter          |대상의 버프를 표시 |<a href="https://www.curseforge.com/wow/addons/asbufffilter" target="_blank" rel="nofollow">링크</a> |
| asCastBar             |시전 바에 아이콘과 시전시간 표시|<a href="https://www.curseforge.com/wow/addons/ascastbar" target="_blank" rel="nofollow">링크</a> |
| asCastingAlert             |대상 시전 주문 알림|<a href="https://www.curseforge.com/wow/addons/ascastingalert" target="_blank" rel="nofollow">링크</a> |
| asCombatInfo          |쿨다운 메니저 강화|<a href="https://www.curseforge.com/wow/addons/ascombatinfo" target="_blank" rel="nofollow">링크</a> | 
| asCombatTimer         |전투 시작 후 경과 시간을 표시|<a href="https://www.curseforge.com/wow/addons/ascombattimer" target="_blank" rel="nofollow">링크</a> |
| asCooldownPulse       |장신구, 종특, 생석, 물약 쿨 표시|<a href="https://www.curseforge.com/wow/addons/ascooldownpulse" target="_blank" rel="nofollow">링크</a> |
| asCompactRaidBuff     |공격대 및 파티 프레임 강화|<a href="https://www.curseforge.com/wow/addons/ascompactraidbuff" target="_blank" rel="nofollow">링크</a> |
| asCPUProfile          |애드온 Latency 성능 확인 (/asCPU)|<a href="https://www.curseforge.com/wow/addons/ascpuprofile" target="_blank" rel="nofollow">링크</a> |
| asDBMTimer            |보스 타임라인 강화|<a href="https://www.curseforge.com/wow/addons/asdbmtimer" target="_blank" rel="nofollow">링크</a> | 
| asDebuffFilter        |플레이어 및 대상 디버프 표시|<a href="https://www.curseforge.com/wow/addons/asdebufffilter" target="_blank" rel="nofollow">링크</a> | 
| asDotFilter           |보스/주시 디버프를 추적|<a href="https://www.curseforge.com/wow/addons/asdotfilter" target="_blank" rel="nofollow">링크</a> | 
| asFixChat             |`Tab` 채팅 채널 전환, `URL 복사` 지원|<a href="https://www.curseforge.com/wow/addons/asfixchat" target="_blank" rel="nofollow">링크</a> | 
| asFixHotkey           |액션바 단축키 텍스트를 축약|<a href="https://www.curseforge.com/wow/addons/asfixhotkey" target="_blank" rel="nofollow">링크</a> |
| asFixUnitFrame        |블리자드 기본 유닛 프레임 기능 숨김|<a href="https://www.curseforge.com/wow/addons/asfixunitframe" target="_blank" rel="nofollow">링크</a> |
| asGCDBar              |전역 재사용 대기시간(GCD) 표시 바|<a href="https://www.curseforge.com/wow/addons/asgcdbar" target="_blank" rel="nofollow">링크</a> |
| asGearScoreLite       |캐릭터 창/살펴보기 창에 아이템 레벨 표시|<a href="https://www.curseforge.com/wow/addons/asgearscorelite" target="_blank" rel="nofollow">링크</a> |
| asHealthText          |텍스트 기반 HUD|<a href="https://www.curseforge.com/wow/addons/ashealthtext" target="_blank" rel="nofollow">링크</a> |
| asHideActionBar       |1번 액션 바를 자동 숨김|<a href="https://www.curseforge.com/wow/addons/ashideactionbar" target="_blank" rel="nofollow">링크</a> |
| asHideBagsBar         |우측 하단의 메뉴 자동 숨김|<a href="https://www.curseforge.com/wow/addons/ashidebagsbar" target="_blank" rel="nofollow">링크</a> |
| asHideNameplates      |케스팅중인 몹 외 이름표를 숨김|<a href="https://www.curseforge.com/wow/addons/ashidenameplates" target="_blank" rel="nofollow">링크</a> |
| asInformation         |1차/2차 능력치 증가량 표시|<a href="https://www.curseforge.com/wow/addons/asinformation" target="_blank" rel="nofollow">링크</a> |
| asInterruptHelper     |차단/스턴 스킬 쿨다운 표시|<a href="https://www.curseforge.com/wow/addons/asinterrupthelper" target="_blank" rel="nofollow">링크</a> |
| asMisdirection        |눈속임, 속임수 거래 자동 매크로|<a href="https://www.curseforge.com/wow/addons/asmisdirection" target="_blank" rel="nofollow">링크</a> |
| asMOD                 | asMOD 모음집 설정|<a href="https://www.curseforge.com/wow/addons/asmod" target="_blank" rel="nofollow">링크</a> |
| asNamePlates          |이름표 강화 애드온|<a href="https://www.curseforge.com/wow/addons/asnameplates" target="_blank" rel="nofollow">링크</a> | 
| asPowerBar            |주 자원/직업 자원 표시|<a href="https://www.curseforge.com/wow/addons/aspowerbar" target="_blank" rel="nofollow">링크</a> | 
| asPremadeGroupsFilter |쐐기돌/공격대 검색 창 강화|<a href="https://www.curseforge.com/wow/addons/aspremadegroupsfilter" target="_blank" rel="nofollow">링크</a> |
| asRangeDisplay        |대상/주시/마우스오버 거리를 표시|<a href="https://www.curseforge.com/wow/addons/asrangedisplay" target="_blank" rel="nofollow">링크</a> |
| asScavenger           |자동 잡템 판매|<a href="https://github.com/aspilla/asMOD/blob/main/asScavenger/README.md" target="_blank" rel="nofollow">링크</a> |
| asSkyRide             |`하늘 비행` 자원/속도/쿨 표시|<a href="https://www.curseforge.com/wow/addons/asskyride" target="_blank" rel="nofollow">링크</a> |
| asSpamFilter          |기본 UI 오류 메시지 표시 위치를 이동|<a href="https://www.curseforge.com/wow/addons/asspamfilter" target="_blank" rel="nofollow">링크</a> |
| asTargetCastBar       |대상/주시대상 시전 바|<a href="https://www.curseforge.com/wow/addons/astargetcastingbar" target="_blank" rel="nofollow">링크</a> | 
| asTrueGCD             |최근 주문/아이템 기록 표시|<a href="https://www.curseforge.com/wow/addons/astruegcd" target="_blank" rel="nofollow">링크</a> | 
| asUnitFrame           |간단한 유닛 프레임|<a href="https://www.curseforge.com/wow/addons/asunitframe" target="_blank" rel="nofollow">링크</a> | 