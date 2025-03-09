# asCompactRaidBuff: Enhanced Raid and Party Frames

This addon improves the default World of Warcraft raid and party frames, enhancing their functionality and providing crucial information for healers and other roles.  It offers a streamlined experience, allowing for better situational awareness and more efficient healing and raid management.

**Key Features:**

*   **Defensive CD Display (Center):**
    *   Clearly displays the use of defensive cooldowns directly in the center of the unit frame.
    *   Prioritizes shorter remaining durations, ensuring you're always aware of the most critical defenses.
    *   Supports a maximum of 2 defensive cooldowns displayed simultaneously.

*   **Maintained HoTs Tracking (Top Right, Center Right, Bottom Right):**
    *   Monitors essential Heal over Time (HoT) buffs that healers need to maintain.
    *   Displays HoTs in designated locations (Top Right, Center Right, Bottom Right) for quick and easy tracking.

*   **Private Aura Display (Top Left):**
    *   Shows private debuffs assigned to the unit in the top left corner.

*   **Healer-Only Mana Bar:**
    *   When the class resource display is disabled, a thin mana bar is displayed exclusively for healers.

*   **Raid Marker Display (Mid-Left):**
    *   Displays raid markers assigned to individual players in the mid-left portion of the unit frame.

*   **Incoming Enemy Casts (Top Center):**
    *   Displays hostile spells being cast on the unit at the top center of the frame.
    *   **Deadly Boss Mods (DBM) Integration:**
        *   Interruptible casts are highlighted with a distinct green border.
        *   Uninterruptible casts are marked with a gray border.

*   **Dispellable Debuff Alerts:**
    *   Highlights unit frame borders for dispellable debuffs.    
    * Fix the bug of the default raid/party frames, about Dispellable Debuff : detect all dispellable debuff types based on the player's specialization (e.g., a Holy Paladin only being alerted to Magic and Poison debuffs).

*   **Shield Display:**
    *   When a shield's absorption exceeds the unit's missing health, the excess shield amount is displayed dimly on the left side of the frame.

*   **HP Color Change on Healing Effects:**
    *   Changes the health bar color to gray when affected by specific healing spells, visually indicating the type of healing:
        *   Flash of Light (Holy Paladin)
        *   Atonement (Discipline Priest)
        *   Renew (Holy Priest)
        *   Lifebloom (Restoration Druid)
        *   Echo (Preservation Evoker)
        *   Healing Surge (Restoration Shaman)
        *   Renewing Mist (Mistweaver Monk)

*   **Buff Refresh Alert:**
    *   When a buff's remaining duration reaches 30% of its total duration (the typical refresh point), the unit frame border turns white, and the cooldown count turns red.

*   **Priest "Power Word: Life" Talent Interaction:**
    *   If a Priest has the "Power Word: Life" talent selected, alerts are displayed in red when a party member's health falls below 35%.

* **Show Cooldown count**
    * Hides cooldown timers but shows buff durations of 10 seconds or less.
    * When a buff is nearing its refresh point, the duration text turns red.

*   **Customization and Options:**
    *   All of these features can be individually toggled on or off via the in-game options menu (Esc > Options > Addons > asCompactRaidBuff).
    * you can remove/add some spell, then you need to edit "asCompactRaidBuffOptions.lua" file, yourself.

**Installation:**

1.  Download the addon files.
2.  Extract the files to your World of Warcraft `Interface/AddOns` directory.
3.  Enable the addon in the in-game AddOns menu.
4.  Recommended wow interface configuration (esc > options)
    ![configuration](https://media.forgecdn.net/attachments/1057/367/ascompactraidbuff_option.jpg)


**How to Use:**

Once installed, the addon will automatically enhance your raid and party frames.  Customize the features you wish to use through the in-game options menu.
![configuration](https://www.youtube.com/watch?v=Oi2s6_P0tb4)


**Tips:**

1. Mouse Click Heal (esc > options > keybinding)
    ![mouseclick](https://media.forgecdn.net/attachments/1057/369/ascompactraidbuff_click.jpg)
2. Mouse Over Heal (esc > macros)
    ![mouseover](https://media.forgecdn.net/attachments/1057/368/ascompactraidbuff_macro.jpg)

**Support:**
If you have any questions, find a bug or want to suggest a feature, you can create an issue on GitHub.


# asCompactRaidBuff: 강화된 공격대 및 파티 프레임

이 애드온은 기본 월드 오브 워크래프트 공격대 및 파티 프레임을 개선하여, 힐러 및 다른 역할군에게 중요한 정보를 제공합니다. 또한, 간소화된 경험을 제공하여 상황 인지 능력을 향상시키고, 보다 효율적인 치유와 공격대 관리를 가능하게 합니다.

**주요 기능:**

*   **방어 생존기 표시 (중앙):**
    *   유닛 프레임 중앙에 방어 생존기 사용 여부를 명확하게 표시합니다.
    *   남은 시간이 짧은 순서대로 우선순위를 부여하여, 가장 중요한 방어 생존기 사용 여부를 항상 파악할 수 있습니다.
    *   최대 2개의 방어 생존기를 동시에 표시할 수 있습니다.


*   **유지해야 할 지속 치유 효과 (HoT) 추적 (우상단, 중앙 우측, 하단 우측):**
    *   힐러가 유지해야 할 필수적인 지속 치유 효과 (HoT) 버프를 모니터링합니다.
    *   지정된 위치 (우상단, 중앙 우측, 하단 우측)에 HoT를 표시하여 빠르고 쉽게 추적할 수 있습니다.

*   **Private Aura 표시 (좌상단):**
    *   유닛에게 할당된 Private Aura 디버프를 좌상단에 표시합니다.

*   **힐러 전용 마나 바:**
    *   직업 자원 표시를 비활성화하면, 힐러 전용 얇은 마나 바가 표시됩니다.

*   **공격대 징표 표시 (좌중단):**
    *   개별 플레이어에게 할당된 공격대 징표를 유닛 프레임 좌중단에 표시합니다.

*   **시전 중인 적 스킬 표시 (상단 중앙):**
    *   유닛에게 시전되는 적대적인 스킬을 프레임 상단 중앙에 표시합니다.
    *   **Deadly Boss Mods (DBM) 통합:**
        *   차단 가능한 시전은 뚜렷한 녹색 테두리로 강조 표시됩니다.
        *   차단 불가능한 시전은 회색 테두리로 표시됩니다.

*   **해제 가능한 디버프 경고:**
    *   해제 가능한 디버프에 대해 유닛 프레임 테두리를 강조 표시합니다.
    *   기본 WoW 공격대/파티 프레임의 해제 가능 디버프 관련 버그를 수정했습니다: 플레이어의 전문화에 따라 모든 해제 가능한 디버프 유형을 감지합니다. (예: 신성 기사는 마법과 독 디버프만 경고받습니다.)

*   **보호막 표시:**
    *   보호막의 흡수량이 유닛의 부족한 체력을 초과하면, 초과된 보호막 양을 프레임 왼쪽에 희미하게 표시합니다.

*   **치유 효과에 따른 체력바 색상 변경:**
    *   특정 치유 주문의 영향을 받으면, 체력바 색상을 회색으로 변경하여 치유 유형을 시각적으로 표시합니다.
        *   빛의 섬광 (신성 기사)
        *   속죄 (수양 사제)
        *   소생 (신성 사제)
        *   피어나는 생명 (회복 드루이드)
        *   메아리 (보존 기원사)
        *   치유의 파도 (복원 주술사)
        *   정수의 샘 (운무 수도사)

*   **버프 갱신 경고:**
    *   버프의 남은 지속 시간이 전체 지속 시간의 30%에 도달하면 (일반적인 갱신 시점), 유닛 프레임 테두리가 흰색으로 변하고 재사용 대기시간 카운트가 빨간색으로 변합니다.

*   **사제 "생명의 말씀" 특성 연동:**
    *   사제가 "생명의 말씀" 특성을 선택한 경우, 파티원의 체력이 35% 미만으로 떨어지면 빨간색으로 경고가 표시됩니다.

* **재사용 대기시간 카운트 표시**
    * 재사용 대기시간 타이머는 숨겨지지만 10초 이하의 버프 지속 시간은 표시됩니다.
    * 버프가 갱신 시점에 가까워지면 지속시간 텍스트가 빨간색으로 변합니다.

*   **사용자 지정 및 옵션:**
    *   이러한 모든 기능은 게임 내 옵션 메뉴 (Esc > 옵션 > 애드온 > asCompactRaidBuff)를 통해 개별적으로 켜고 끌 수 있습니다.
    *   특정 마법을 추가/제거 하려면, "asCompactRaidBuffOptions.lua" 파일을 직접 편집해야 합니다.

**설치 방법:**

1.  애드온 파일을 다운로드합니다.
2.  파일을 월드 오브 워크래프트 `Interface/AddOns` 디렉토리에 압축을 해제합니다.
3.  게임 내 애드온 메뉴에서 애드온을 활성화합니다.

**사용 방법:**

설치 후, 애드온은 자동으로 공격대 및 파티 프레임을 개선합니다. 사용하려는 기능은 게임 내 옵션 메뉴를 통해 사용자 지정할 수 있습니다.

**지원:**

질문이 있거나 버그를 발견하거나 기능을 제안하고 싶은 경우 GitHub에 이슈를 생성할 수 있습니다.