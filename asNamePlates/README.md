# asNamePlates: Enhanced Nameplate Addon

**asNamePlates** is an addon for World of Warcraft that enhances enemy nameplates (the name tags of attackable targets). It provides various visual feedback and convenience features to help you understand combat situations more clearly and react more effectively.

**Note:** Due to in-game limitations, this addon does not modify friendly nameplates.

## Key Features

### 1. Nameplate Bar Texture Replacement

*   Changes the texture of nameplates for attackable targets (enemies).

### 2. Debuff Icon Functionality

*   Replaces only the debuff display area of the default WoW nameplates.
*   Displays both skill debuffs and default WoW debuffs (up to 8, displayed in 2 rows of 4).
*   Displays one major crowd control (CC) debuff (interrupt, stun, root/immobilize) on the right side of the nameplate.
*   Provides border notifications for debuffs based on set refresh timers and debuff types. (You can freely configure which debuffs to track and their notification settings.)
*   Displays cooldown counts if the default WoW cooldown display is enabled.
*   Allows filtering to display only specific debuffs through settings.
*   Allows to change the position of debuffs to top(default) or left.

### 3. Nameplate Color Change Functionality

*   Changes the nameplate color to orange when a damage-over-time (DoT) effect is applied (e.g., Rupture for Assassination Rogues, Corruption for Affliction Warlocks, Rend for Warriors) (supports up to 2 DoTs).
*   Dynamically changes nameplate colors based on threat level:
    *   **Purple:** When the player is the target.
    *   **Sky Blue:** High threat level, but not currently targeted.
    *   **Blue:** When the player's pet is the target.
    *   **Magenta:** When another tank (other than the player) is tanking.
    *   **Pink:** When another DPS (other than the player) is the target.
    *   **Light Green:** When casting a dangerous spell.
*   Changes the nameplate color to ochre when a finishing move ability (Warrior, Hunter, etc.) is available.
*   Highlights major interrupt elite mobs in Mythic+ Keystone dungeons. Light green before combat starts (when using asAutoMarker).
*   Changes the color of quest mobs. (Ochre)
*   Changes the color for incorporeal, spiteful and afflicted affix mobs.

### 4. Buff Icon Functionality

*   Displays one important defensive buff for hostile targets.
*   Highlights dispellable or stealable enemy buffs with a border.
*   Displays 8 personal buffs below the personal resource bar.

### 5. DBM Features (DBM Required)

*   **M+ Interrupt Highlight:** Changes the nameplate color and adds a border notification for important interrupt targets in M+ dungeons (requires DBM).
*   **DBM Major Skill Highlight:** Changes nameplate colors for major boss abilities (requires DBM).
    *   **Green (Dark Green if you are the target):** Interruptible.
    *   **Gray (Red if you are the target):** Uninterruptible.
*   Displays the cooldown of important DBM skills on the right side of the nameplate.
    *   If there are multiple cooldowns, only the skill with the shortest cooldown is displayed.
    *   Displayed in gray when not being cast.
    * Changes the color 2 seconds before cooldown expires. It changes to green for interruptible skills and red for uninterruptible skills.

### 6. Other Features

*   Adds a healer icon to prioritize healers in PvP.
*   Enlarges the nameplate of the player's current target and displays the player's health, the target's health, and the player's resources.
* Displays a "!" icon on the left side when an enemy targets the player in PvP.
*   Allows resizing of friendly nameplates.
*   Allows setting vertical alignment of nameplates.
*   Enlarges the nameplate of the mouseover target, displays health, and highlights it with a green triangle.
*   Displays the name/class of the casting target.
* The remaining health is displayed on the left. (Can be disabled in options)
* If it is the "Target", a red arrow is displayed at the top.
* If it is "Mouseover", a green arrow is displayed at the bottom.
* In group play, if you are not a tank and an enemy targets you, a red/orange mark will appear on the left side of the nameplate.
* Pet target indicator (red pet icon in the bottom right)
* For Beast Mastery Hunters, displays Beast Cleave targets (green pet icon at the bottom and nameplate color change)

## Configuration

*   All features can be configured in the in-game settings (Esc > Options).

# asNamePlates: 네임플레이트 개선 애드온

**asNamePlates**는 World of Warcraft의 적 네임플레이트(공격 가능한 대상의 이름표)를 개선하는 애드온입니다. 다양한 시각적 피드백과 편의 기능을 제공하여 전투 상황을 더욱 명확하게 인지하고 효율적으로 대처할 수 있도록 돕습니다.

**참고:** 게임 내 제약으로 인해 이 애드온은 우호적인 대상의 네임플레이트는 수정하지 않습니다.

## 주요 기능

### 1. 네임플레이트 바 텍스처 변경

*   공격 가능한 대상(적)의 네임플레이트 텍스처를 변경합니다.

### 2. 약화 효과(디버프) 아이콘 기능

*   기본 WoW 네임플레이트의 약화 효과 표시 영역만 대체합니다.
*   스킬 디버프와 기본 WoW 디버프를 모두 표시합니다 (최대 8개, 4개씩 2행으로 표시).
*   주요 군중 제어(CC) 디버프 (차단, 기절, 속박/이동 불가)를 네임플레이트 오른쪽에 1개 표시합니다.
*   설정된 갱신 타이머 및 디버프 유형에 따라 디버프에 대한 테두리 알림을 제공합니다. (추적할 디버프와 알림 설정을 자유롭게 설정할 수 있습니다.)
*   WoW의 기본 쿨다운 표시가 활성화되어 있으면 쿨다운 카운트를 표시합니다.
*   설정을 통해 특정 디버프만 표시하도록 필터링할 수 있습니다.
*   디버프 위치를 조정할 수 있습니다. 기본 상단, 좌측 설정 가능.

### 3. 네임플레이트 색상 변경 기능

*   지속 피해(DoT) 효과 (예: 암살 도적의 파열, 고통 흑마법사의 고통, 전사의 찢기)가 적용되면 네임플레이트 색상을 주황색으로 변경합니다(최대 2개의 DoT 지원).
*   위협 수준에 따라 네임플레이트 색상을 동적으로 변경합니다.
    *   **보라색:** 플레이어가 대상일 경우.
    *   **하늘색:** 높은 위협 수준이지만 현재 대상은 아닌 경우.
    *   **파란색:** 플레이어의 소환수가 대상일 경우.
    *   **자홍색:** 플레이어 외의 다른 탱커가 탱킹 중인 경우.
    *   **분홍색:** 플레이어 외의 다른 DPS가 대상일 경우.
    *   **연녹색:** 위험한 주문을 시전 중일 경우.
*   마무리일격 능력(전사, 사냥꾼 등) 사용 가능 시 네임플레이트 색상(황토색)을 변경합니다.
*   신화+ 쐐기돌 던전에서 주요 차단 정예 몹을 강조 표시합니다. 전투 시작전 연녹색 (asAutoMarker 사용 시).
*   퀘스트 몹의 색상을 변경 합니다. (황토색)
*   무형, 원한, 휘장 속성의 몹에 대해 색상을 변경합니다.

### 4. 강화 효과(버프) 아이콘 기능

*   적대적 대상의 중요한 생존기 버프를 1개 표시합니다.
*   해제 또는 훔치기 가능한 적 버프를 테두리로 강조 표시합니다.
*   개인 자원바 하단에 개인 버프 8개를 표시합니다.

### 5. DBM 기능 (DBM 설치 필요)

*   **M+ 차단 강조:** M+ 던전에서 중요한 차단 대상에 대해 네임플레이트 색상을 변경하고 테두리 알림을 추가합니다 (DBM 필요).
*   **DBM 주요 스킬 강조:** 주요 보스 기술에 대한 네임플레이트 색상을 변경합니다 (DBM 필요).
    *   **녹색 (본인이 대상일 경우 진녹색):** 차단 가능.
    *   **회색 (본인이 대상일 경우 빨간색):** 차단 불가능.
*   네임플레이트 오른쪽에 중요한 DBM 스킬의 쿨다운을 표시합니다.
    *   쿨다운이 여러개 있을 경우 가장 짧은 쿨다운의 스킬만 표시 합니다.
    *   시전 중이 아닐 때는 회색으로 표시됩니다.
    * 쿨다운 만료 2초 전에 색상을 변경합니다. 차단 가능 스킬은 녹색, 불가능 스킬은 빨간색으로 변경됩니다.

### 6. 기타 기능

*   PvP에서 치유 담당을 우선 순위로 표시하기 위해 힐러 아이콘을 추가합니다.
*   플레이어의 현재 대상의 네임플레이트를 확대하고 플레이어의 생명력, 대상의 생명력 및 플레이어의 자원을 표시합니다.
*   PvP에서 적이 플레이어를 대상으로 할 경우 좌측에 느낌쵸 표시합니다.
*   우호적 네임플레이트 크기 조정을 허용합니다.
*   네임플레이트의 세로 정렬을 설정할 수 있습니다.
*   마우스 오버 대상의 네임플레이트를 확대하고 생명력을 표시하며 녹색 삼각형으로 강조 표시합니다.
*   시전 대상의 이름/직업을 표시합니다.
* 왼쪽에는 남은 체력이 표시됩니다. (옵션에서 비활성화 가능)
* 만약 "대상"일 경우, 위쪽에 붉은색 화살표가 표시됩니다.
* 만약 "마우스오버"일 경우, 아래쪽에 녹색 화살표가 표시됩니다.
* 그룹 플레이에서 탱커가 아니고 적이 당신을 타겟팅할 경우, 네임플레이트 왼쪽에 빨간색/주황색 표시가 나타납니다.
* 펫의 타겟 표시 (오른쪽 하단에 빨간색 펫 아이콘)
* 야수 사냥꾼의 경우, 짐승의 휩쓸기 대상 표시 (하단에 녹색 펫 아이콘과 네임플레이트 색상 변경)

## 설정

*   게임 내 설정 (Esc > 옵션)에서 모든 기능을 구성할 수 있습니다.