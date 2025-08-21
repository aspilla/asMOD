# asNamePlates: Enhanced Nameplates

**asNamePlates** is an addon for World of Warcraft that enhances the nameplates of attackable targets. It provides various visual feedback and convenience features to help you better understand combat situations and react more efficiently.

![sample](https://github.com/aspilla/asMOD/blob/main/.Pictures/asnameplates.jpg?raw=true)


**Note:** Due to in-game limitations, this addon only modifies the size of friendly nameplates and does not alter other aspects.

## Key Features

### 1. Nameplate Bar Texture Change

* Changes the texture of attackable target (enemy) nameplates to a brighter and more visually appealing style.

### 2. Debuff Icon Functionality

* Replaces the default debuff display area on enemy nameplates.
* Displays both skill debuffs and basic debuffs (up to 8, in 2 rows of 4).
* Displays one major crowd control (CC) debuff (interrupt, stun, root/immobilize) on the right side of the nameplate.
* Provides border alerts for debuffs based on set refresh timers and debuff types. (You can freely configure which debuffs to track and their alert settings.)
* Displays cooldown counts if the default **cooldown** display is enabled. (Esc > Options > Interface > Combat > Show Cooldown Text)
* Allows filtering to display only desired debuffs through settings. (Esc > Options > AddOns > asNamePlates)
* Adjustable debuff position. Default top, left settings available. (Esc > Options > AddOns > asNamePlates)

### 3. Nameplate Color Change Functionality

* Changes the nameplate color to orange when damage-over-time (DoT) effects are applied (e.g., Rupture for Assassination Rogues, Agony for Affliction Warlocks, Rend for Warriors) (supports up to 2 DoTs).

* Dynamically changes nameplate colors based on threat level:
  * **Purple:** When the player is the target.
  * **Sky Blue:** High threat level but not currently targeted.
  * **Blue:** When the player's pet is the target.
  * **Magenta:** When a tank other than the player is tanking.
  * **Pink:** When a DPS other than the player is the target.
  * **Light Green:** When a dangerous spell is being cast.

* Changes the nameplate color to ochre when a finishing move (Warrior, Hunter, etc.) is available.
* Highlights key interruptible elite mobs in Mythic+ dungeons. Light green before combat starts (when using asAutoMarker).
* Changes the color of quest mobs. (Ochre)
* Changes the color of mobs with Incorporeal, Entangling, or Afflicted affixes.
* Changes the color og mobs, higher level (ex 81) or ?? level. This has higher priority than regular aggro color.  (Party play only)
<iframe width="560" height="315" src="https://www.youtube.com/embed/E-LcoSpeYmA?si=YIZNgIi7H-fHmS5h" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" referrerpolicy="strict-origin-when-cross-origin" allowfullscreen></iframe>


### 4. Buff Icon Functionality

* Displays one important defensive buff on PVP targets.
* Highlights dispellable or stealable enemy buffs with a border.
* Displays 8 personal buffs below the personal resource bar.
* Displays a DBM buff

### 5. DBM Functionality (Requires DBM)

* **M+ Interrupt Highlight:** Changes the nameplate color and adds a border alert for important interrupt targets in M+ dungeons (requires DBM).
* **DBM Key Skill Highlight:** Changes the nameplate color for key boss abilities (requires DBM).
  * **Green (Dark Green if you are the target):** Interruptible.
  * **Gray (Red if you are the target):** Uninterruptible.
* Displays the cooldown of important DBM skills on the right side of the nameplate.
  * If there are multiple cooldowns, only the shortest cooldown skill is displayed.
  * Displayed in gray when not being cast.
  * Changes color 2 seconds before the cooldown expires. Interruptible skills turn green, uninterruptible skills turn red.

### 6. Other Features

* Adds a healer icon to prioritize healers in PvP.
* Enlarges the nameplate of the player's current target and displays the player's health, the target's health, and the player's resources.
* Displays a "!" mark on the left side when an enemy targets the player in PvP.
* Allows resizing of friendly nameplates.
* Allows setting the vertical alignment of nameplates.
* Enlarges the nameplate of the mouseover target, displays health, and highlights it with a green triangle.
* Displays the name/class of the casting target.
* Displays remaining health on the left. (Can be disabled in options)
* If it is the "target", a red arrow is displayed above.
* If it is "mouseover", a green arrow is displayed below.
* In group play, if you are not a tank and an enemy targets you, a red/orange mark appears on the left side of the nameplate.
* Shows the power of mob below healthbar (if not Mana and over than 0)
<iframe width="560" height="315" src="https://www.youtube.com/embed/bsNd4YaCzrY?si=gvsDL_yhUtKmv1xa" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" referrerpolicy="strict-origin-when-cross-origin" allowfullscreen></iframe>


* Pet's target indicator (red pet icon in the bottom right)
* For Beast Mastery Hunters, displays the target of Beast Cleave (green pet icon at the bottom and nameplate color change)

<iframe width="560" height="315" src="https://www.youtube.com/embed/1YYCt5gbQGU?si=Sgv7zNxlc0gsQvbD" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" referrerpolicy="strict-origin-when-cross-origin" allowfullscreen></iframe>

* Add a green mark on the left of nameplate of focus target

## Configuration

* Some features can be configured in the in-game settings (Esc > Options).
<iframe width="560" height="315" src="https://www.youtube.com/embed/ebttCrIsHLU?si=4jLU7MtZhsAkndvp" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" referrerpolicy="strict-origin-when-cross-origin" allowfullscreen></iframe>


<iframe width="560" height="315" src="https://www.youtube.com/embed/mThzeV48t-A?si=IPRpMCloFFeurE0y" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" referrerpolicy="strict-origin-when-cross-origin" allowfullscreen></iframe>

* Only spells and skills enabled in DBM's settings will be highlighted. (Refer to the video below)
<iframe width="560" height="315" src="https://www.youtube.com/embed/Yn19ieQ6QRo?si=tfbzb3_7YUMwxUGc" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" referrerpolicy="strict-origin-when-cross-origin" allowfullscreen></iframe>

* Optimal Setup Macro (Recommended for use with small nameplates)                                                                                                 │
Automatically creates a macro named `asNamePlates Setup`. Using this macro as shown in the video below will apply the optimal settings. 
<iframe width="560" height="315" src="https://www.youtube.com/embed/Y62-48k_wBk?si=9JmBMxXEHZn5lRTT" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" referrerpolicy="strict-origin-when-cross-origin" allowfullscreen></iframe>

---

# asNamePlates: 이름표(NamePlates) 개선

**asNamePlates**는 World of Warcraft의 공격 가능한 대상의 이름표(NamePlates)를 개선하는 애드온입니다. 다양한 시각적 피드백과 편의 기능을 제공하여 전투 상황을 더욱 명확하게 인지하고 효율적으로 대처할 수 있도록 돕습니다.

![sample](https://github.com/aspilla/asMOD/blob/main/.Pictures/asnameplates.jpg?raw=true)


**참고:** 게임 내 제약으로 인해 이 애드온은 우호적인 대상의 네임플레이트는 크기 외 수정하지 않습니다.

## 주요 기능

### 1. 이름표 바 텍스처 변경

* 공격 가능한 대상(적)의 네임플레이트 텍스처를 밝고 보기 좋은 형태로 변경합니다.

### 2. 약화 효과(디버프) 아이콘 기능

* 기본 적대적 대상 이름표의 약화 효과 표시 영역을 대체 합니다.
* 스킬 디버프와 기본 디버프를 모두 표시합니다 (최대 8개, 4개씩 2행으로 표시).
* 주요 군중 제어(CC) 디버프 (차단, 기절, 속박/이동 불가)를 네임플레이트 오른쪽에 1개 표시합니다.
* 설정된 갱신 타이머 및 디버프 유형에 따라 디버프에 대한 테두리 알림을 제공합니다. (추적할 디버프와 알림 설정을 자유롭게 설정할 수 있습니다.)
* 기본 **재사용 대기 시간** 표시가 활성화되어 있으면 쿨다운 카운트를 표시합니다. (esc > 설정 > 재사용 검색)
* 설정을 통해 원하는 디버프만 표시하도록 필터링할 수 있습니다. (esc > 설정 > 애드온 > asNamePlates)
* 디버프 위치를 조정할 수 있습니다. 기본 상단, 좌측 설정 가능. (esc > 설정 > 애드온 > asNamePlates)

### 3. 네임플레이트 색상 변경 기능

* 지속 피해(DoT) 효과 (예: 암살 도적의 파열, 고통 흑마법사의 고통, 전사의 찢기)가 적용되면 네임플레이트 색상을 주황색으로 변경합니다(최대 2개의 DoT 지원).

* 위협 수준에 따라 네임플레이트 색상을 동적으로 변경합니다.
  * **보라색:** 플레이어가 대상일 경우.
  * **하늘색:** 높은 위협 수준이지만 현재 대상은 아닌 경우.
  * **파란색:** 플레이어의 소환수가 대상일 경우.
  * **자홍색:** 플레이어 외의 다른 탱커가 탱킹 중인 경우.
  * **분홍색:** 플레이어 외의 다른 DPS가 대상일 경우.
  * **연녹색:** 위험한 주문을 시전 중일 경우.
  
* 마무리일격 능력(전사, 사냥꾼 등) 사용 가능 시 네임플레이트 색상(황토색)을 변경합니다.
* 신화+ 쐐기돌 던전에서 주요 차단 정예 몹을 강조 표시합니다. 전투 시작전 연녹색 (asAutoMarker 사용 시).
* 퀘스트 몹의 색상을 변경 합니다. (황토색)
* 무형, 원한, 휘장 속성의 몹에 대해 색상을 변경합니다.
* 보스몹 (레벨에 높거(예 81렙)나 ?? 레벨몹) 색상을 변경 합니다. 이는 전투중에 보통 어그로 상태보다 우선순위를 가집니다. (파티 던전에서만 동작)
<iframe width="560" height="315" src="https://www.youtube.com/embed/E-LcoSpeYmA?si=YIZNgIi7H-fHmS5h" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" referrerpolicy="strict-origin-when-cross-origin" allowfullscreen></iframe>

### 4. 강화 효과(버프) 아이콘 기능

* PVP 적대적 대상의 중요한 생존기 버프를 1개 표시합니다.
* 해제 또는 훔치기 가능한 적 버프를 테두리로 강조 표시합니다.
* 개인 자원바 하단에 개인 버프 8개를 표시합니다.
* DBM 주요 버프 1개를 표시 합니다. (설정 가능)

### 5. DBM 기능 (DBM 설치 필요)

* **M+ 차단 강조:** M+ 던전에서 중요한 차단 대상에 대해 네임플레이트 색상을 변경하고 테두리 알림을 추가합니다 (DBM 필요).
* **DBM 주요 스킬 강조:** 주요 보스 기술에 대한 네임플레이트 색상을 변경합니다 (DBM 필요).
  * **녹색 (본인이 대상일 경우 진녹색):** 차단 가능.
  * **회색 (본인이 대상일 경우 빨간색):** 차단 불가능.
* 네임플레이트 오른쪽에 중요한 DBM 스킬의 쿨다운을 표시합니다.
  * 쿨다운이 여러개 있을 경우 가장 짧은 쿨다운의 스킬만 표시 합니다.
  * 시전 중이 아닐 때는 회색으로 표시됩니다.
  * 쿨다운 만료 2초 전에 색상을 변경합니다. 차단 가능 스킬은 녹색, 불가능 스킬은 빨간색으로 변경됩니다.

### 6. 기타 기능

* PvP에서 치유 담당을 우선 순위로 표시하기 위해 힐러 아이콘을 추가합니다.
* 플레이어의 현재 대상의 네임플레이트를 확대하고 플레이어의 생명력, 대상의 생명력 및 플레이어의 자원을 표시합니다.
* PvP에서 적이 플레이어를 대상으로 할 경우 좌측에 느낌쵸 표시합니다.
* 우호적 네임플레이트 크기 조정을 허용합니다.
* 네임플레이트의 세로 정렬을 설정할 수 있습니다.
* 마우스 오버 대상의 네임플레이트를 확대하고 생명력을 표시하며 녹색 삼각형으로 강조 표시합니다.
* 시전 대상의 이름/직업을 표시합니다.
* 왼쪽에는 남은 체력이 표시됩니다. (옵션에서 비활성화 가능)
* 만약 "대상"일 경우, 위쪽에 붉은색 화살표가 표시됩니다.
* 만약 "마우스오버"일 경우, 아래쪽에 녹색 화살표가 표시됩니다.
* 그룹 플레이에서 탱커가 아니고 적이 당신을 타겟팅할 경우, 네임플레이트 왼쪽에 빨간색/주황색 표시가 나타납니다.
* 펫의 타겟 표시 (오른쪽 하단에 빨간색 펫 아이콘)
* 몹의 Power를 Healthbar 아래 표시 (마나가 아니고, 0보다 클경우)
<iframe width="560" height="315" src="https://www.youtube.com/embed/bsNd4YaCzrY?si=gvsDL_yhUtKmv1xa" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" referrerpolicy="strict-origin-when-cross-origin" allowfullscreen></iframe>

* 야수 사냥꾼의 경우, 짐승의 휩쓸기 대상 표시 (하단에 녹색 펫 아이콘과 네임플레이트 색상 변경)

<iframe width="560" height="315" src="https://www.youtube.com/embed/1YYCt5gbQGU?si=Sgv7zNxlc0gsQvbD" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" referrerpolicy="strict-origin-when-cross-origin" allowfullscreen></iframe>

* 주시 대상 이름표에 녹색 마크를 좌측에 추가 합니다.

### 7. 기본 등록 디버프 및 색상설정

| 직업 | 특성 | 필수 디버프(표시 우선 순위 순 *색상1, **색상2) |
|---|---|---|
| 전사 | 무기 | 사형 선고됨**, 만신창이**, 분쇄* |
|  | 분노 | 사형 선고됨* |
|  | 방어 | 만신창이, 분쇄 |
| 도적 | 암살 | 죽음추적자의 징표, 목조르기**, 파열*, 혈폭풍 |
|  | 무법 | 유령의 일격*, 당혹 상태** |
|  | 잠행 | 죽음추적자의 징표**, 파열*, 당혹 상태** |
| 사냥꾼 | 야수 | 검은 화살, 날카로운 사격*, 독사 쐐기, 저승까마귀, 사냥꾼의 징표, (팻회전배기**) |
|  | 사격 | 척후병의 징표*, 검은 화살**, 파수꾼, 사냥꾼의 징표 |
|  | 생존 | 독사 쐐기*, 파수꾼, 사냥꾼의 징표 |
| 수도사 | 양조 | 질서의 무기 |
|  | 운무 |  |
|  | 풍운 | 주학의 징표* |
| 흑마법사 | 고통 | 고통*, 불안정한 고통, 부패**, 쇠퇴 |
|  | 악마 | 파멸**, 악의 아귀* |
|  | 파괴 | 제물*, 쇠퇴* |
| 사제 | 수양 | 사악의 정화*, 고통* |
|  | 신성 | 신충*, 고통** |
|  | 암흑 | 고통*, 흡혈의 선물, 파멸**, 공명 |
| 주술사 | 정기 | 화염 충격*, 피뢰침** |
|  | 고양 | 화염 충격*, 채찍 화염**, 피뢰침** |
|  | 복원 | 화염 충격* |
| 드루이드 | 조화 | 달빛 섬광*, 태양 섬광**, 항성의 섬광, 진균 번식, 기후 노출 |
|  | 야성 | 갈퀴 발톱*, 달빛 섬광**, 적응의 무리, 도려내기, 난타 |
|  | 수호 | 달빛 섬광, 난타, 기후 노출 |
|  | 회복 | 달빛 섬광*, 갈퀴 발톱**, 태양 섬광, 도려내기, 피바라미 덩굴 |
| 마법사 | 비전 | 비전의 여파*, 비전 쇠약, 박힌 쐐편 파편 |
|  | 화염 | 파괴 제어*, 작열 |
|  | 냉기 | 혹한의 추위*, 박힌 냉기 파편, (얼회등 얼리기 스킬들)** , 냉증, 혹한의 쐐기 |
| 죽음의 기사 | 혈기 | 사신의 징표, 공포 유발, 피의 역병 |
|  | 냉기 | 사신의 징표*, 서리 열병 |
|  | 부정 | 공포 유발**, 고름 상처, 악성 역병* |
| 기원사 | 파괴 | 불의 숨결*, 폭격 |
|  | 증강 | 불의 숨결* |
|  | 보존 | 시간의 상처*, 불의 숨결**, 폭격 |
| 성기사 | 신성 | 무가치한 존재* |
|  | 보호 | 심판 |
|  | 징벌 | 심판* |
| 악마사냥꾼 | 파멸 | 파괴자의 징표**, 불타는 상처* |
|  | 복수 | 파괴자의 징표, 불타는 낙인, 약화 |

## 설정

* 게임 내 설정 (Esc > 옵션)
<iframe width="560" height="315" src="https://www.youtube.com/embed/ebttCrIsHLU?si=4jLU7MtZhsAkndvp" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" referrerpolicy="strict-origin-when-cross-origin" allowfullscreen></iframe>

<iframe width="560" height="315" src="https://www.youtube.com/embed/mThzeV48t-A?si=IPRpMCloFFeurE0y" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" referrerpolicy="strict-origin-when-cross-origin" allowfullscreen></iframe>

* DBM 내 설정 활성화 주문 및 스킬만 강조 안내 합니다. (아래 영상 참고)
<iframe width="560" height="315" src="https://www.youtube.com/embed/Yn19ieQ6QRo?si=tfbzb3_7YUMwxUGc" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" referrerpolicy="strict-origin-when-cross-origin" allowfullscreen></iframe>

* 최정설정 Macro(작은 이름표에서 사용 추천천)
`asNamePlates Setup`이라는 메크로를 자동으로 만듭니다. 해당 매크로를 아래 영상과 같이 사용시 최적의 설정으로 사용 가능합니다.
<iframe width="560" height="315" src="https://www.youtube.com/embed/Y62-48k_wBk?si=9JmBMxXEHZn5lRTT" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" referrerpolicy="strict-origin-when-cross-origin" allowfullscreen></iframe>