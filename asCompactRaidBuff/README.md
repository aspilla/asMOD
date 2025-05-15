# asCompactRaidBuff: Enhanced Raid and Party Frames

This addon enhances the default World of Warcraft raid and party frames, providing crucial information for healers and other roles. It streamlines the experience, improves situational awareness, and facilitates more efficient healing and raid management.


![sample](https://github.com/aspilla/asMOD/blob/main/.Pictures/asCompactraidbuff.jpg?raw=true)   

<iframe width="560" height="315" src="https://www.youtube.com/embed/DC8w21t_SLs?si=POLD4CPQuAhKO1Nv" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" referrerpolicy="strict-origin-when-cross-origin" allowfullscreen></iframe>

Note: Showing cooldowns on the left top corner is from asReady addon.

**Key Features:**

*   **Tracking of Essential Heal-over-Time (HoT) Effects (Top Right, Center Right, Bottom Right):**
    *   Monitors essential HoT buffs that healers need to maintain.
    *   For Restoration Druids, Rejuvenation also changes color, and even when Rejuvenation and Lifebloom are present together, they can be distinguished by color.
    *   Displays HoTs in designated locations (top right, center right, bottom right) for quick and easy tracking.
    *   HoT buff positions can be adjusted via `Esc >> Options >> AddOns >> asCompactRaidBuff`.

*   **Color Change for Top Right HoT Health Bar:**
    *   Buffs displayed in the top right corner will have their health bar color changed to gray, making it easy to identify whether a party member has the buff.
    *   Buff color changes can be adjusted via `Esc >> Options >> AddOns >> asCompactRaidBuff`.
    *   The default buff location/color change settings are as follows:

        | Class            | Top Right (Color Change) | Right          |
        | ---------------- | ------------------------ | -------------- |
        | Restoration Druid | Lifebloom              | Rejuvenation, Regrowth |
        | Holy Paladin     | Beacon of Virtue        | Beacon of Light, Beacon of Faith    |
        | Discipline Priest | Atonement              | Renew, Power Word: Shield    |
        | Holy Priest      | Renew                  | Power Word: Shield   |
        | Preservation Evoker| Echo                  | Rewind         |
        | Restoration Shaman | Riptide                | Earth Shield |
        | Mistweaver Monk    | Renewing Mist           | Enveloping Mist      |
        | Augmentation Evoker| Prescience              | Ebon Might         |

        <iframe width="560" height="315" src="https://www.youtube.com/embed/ELxjSUJ9BIw?si=Kmny1-7UlXZF04Iz" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" referrerpolicy="strict-origin-when-cross-origin" allowfullscreen></iframe>

*   **Buff Refresh Warning:**
    *   When a buff's remaining duration reaches 30% of its total duration (typical refresh point), the buff frame border turns white, and the cooldown counter turns red.

*   **Defensive Cooldown (CD) Display (Center):**
    *   Clearly displays whether defensive cooldowns are active in the center of the unit frame.
    *   Prioritizes cooldowns based on remaining time, ensuring the most critical defensive cooldowns are always visible.
    *   Up to two defensive cooldowns can be displayed simultaneously.
    *   Which defensive cooldowns are tracked can be adjusted via `Esc >> Options >> AddOns >> asCompactRaidBuff`.

*   **Private Aura Display (Top Left):**
    *   Private Auras are untrackable debuffs, often used for specific raid debuffs. Only the position/size can be adjusted.
    *   Displays the assigned private aura debuff on the top left of the unit.

*   **Healer-Only Mana Bar (Bottom):**
    *   If the class resource display is disabled, a thin, healer-specific mana bar will be displayed.

*   **Tank-Only Power Bar (Bottom):**
    *   If the class resource display is disabled, a thin, power bar will be displayed if tank's spec is deathknight, warrior, druid or demonhunter.

*   **Raid Marker Display (Left Center):**
    *   Displays the raid marker assigned to each individual player on the left center of their unit frame.

*   **Display of Enemy Casts (Top Center):**
    *   Displays hostile spells being cast on a unit in the top center of the frame.
    *   **Deadly Boss Mods (DBM) Integration:**
        *   Interruptible casts are highlighted with a distinct green border.
        *   Non-interruptible casts are displayed with a gray border.

*   **Dispellable Debuff Warning (Border):**
    *   Highlights the unit frame border for dispellable debuffs.
    *   Fixes a bug in the default WoW raid/party frames related to dispellable debuffs: Detects all dispellable debuff types according to the player's specialization. (e.g., Holy Paladins will only receive warnings for magic and poison debuffs.)
    *   For Hunters, if a poison is dispellable and they are affected by a poison, it will be highlighted.

*   **Shield Display:**
    *   If the shield's absorption amount exceeds the unit's missing health, the excess shield amount is faintly displayed on the left side of the frame.

*   **Priest "Life" Talent Integration:**
    * If a priest has selected the "Life" talent, it will display a red warning when a party member's health drops below 35%.

*   **Cooldown Count Display:**
    * Cooldown timers are hidden, but buff durations of 10 seconds or less are shown.
    * When a buff is nearing its refresh point, the duration text turns red.

*   **Customization and Options:**
    *   All of these features can be individually toggled on or off via the in-game options menu (`Esc > Options > AddOns > asCompactRaidBuff`).

<iframe width="560" height="315" src="https://www.youtube.com/embed/rSiw0b1oELk?si=wJ4e5xhk8S1_tkTP" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" referrerpolicy="strict-origin-when-cross-origin" allowfullscreen></iframe>

**Installation:**

1.  Copy the addon folder to your World of Warcraft `Interface/AddOns` directory.
2.  In Edit Mode (`Esc >> Edit Mode`) you need to select the party or raid frame to enable the add-on on those frames.
3.  It is recommended to set the WoW raid frame options as follows. (`esc > options`)

![configuration](https://github.com/aspilla/asMOD/blob/main/.Pictures/ascompactraidbuff_option.jpg?raw=true)

**Configuration Example:**

Buff locations and defensive CD settings can be configured as shown in the following video:

<iframe width="560" height="315" src="https://www.youtube.com/embed/Oi2s6_P0tb4?si=Z21OK6gyvEogNcoT" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" referrerpolicy="strict-origin-when-cross-origin" allowfullscreen></iframe>

**Tips:**

1. Mouse Click Healing Setup (`Esc > Options > Key Bindings > Click Casting`)
    ![mouseclick](https://github.com/aspilla/asMOD/blob/main/.Pictures/ascompactraidbuff_click.jpg?raw=true)
2. Mouse Over (Wheel Up/Down) Healing Setup (Create a macro under `Esc > Macros`, then bind it to Mouse Wheel Up/Down, etc.)
    ![mouseover](https://github.com/aspilla/asMOD/blob/main/.Pictures/ascompactraidbuff_macro.jpg?raw=true)

-----

# asCompactRaidBuff: 공격대 및 파티 프레임 강화

이 애드온은 기본 월드 오브 워크래프트 공격대 및 파티 프레임을 개선하여, 힐러 및 다른 역할군에게 중요한 정보를 제공합니다. 또한, 간소화된 경험을 제공하여 상황 인지 능력을 향상시키고, 보다 효율적인 치유와 공격대 관리를 가능하게 합니다.

![sample](https://github.com/aspilla/asMOD/blob/main/.Pictures/asCompactraidbuff.jpg?raw=true)   


<iframe width="560" height="315" src="https://www.youtube.com/embed/DC8w21t_SLs?si=POLD4CPQuAhKO1Nv" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" referrerpolicy="strict-origin-when-cross-origin" allowfullscreen></iframe>

참고: 좌상단 Cooldown 표시는 asReady 기능 입니다.

**주요 기능:**
    
*   **유지해야 할 지속 치유 효과 (HoT) 추적 (우측 상단, 중앙 우측, 우측 하단):**
    *   힐러가 유지해야 할 필수적인 지속 치유 효과 (HoT) 버프를 모니터링합니다.
    *   지정된 위치 (우상단, 중앙 우측, 하단 우측)에 HoT를 표시하여 빠르고 쉽게 추적할 수 있습니다.
    *   버프 위치는 esc >> 설정 >> 애드온 >> asCompactRaidBuff에서 조정 가능합니다.

*   **우상단 HoT 체력바 색상 변경:**
    *   우측 상단에 표시 되는 버프는 체력바 색상을 회색으로 변경하여 파티원의 버프 유무를 파악하기 쉽게 합니다.
    *   회복 드루이드의 회복도 색상을 변경하며, 회복 및 피어나는 생명이 같이 있을경우도 색상으로 구분 가능합니다.
    *   버프 색상 변경은 esc >> 설정 >> 애드온 >> asCompactRaidBuff에서 조정 가능합니다.
    *   기본 설정된 버프 위치/생삭 변경 설정은 다음과 같습니다.

        | 직업 | 우측상단(색상 변경) | 우측 | 
        | ----- | ----------- | ------ | 
        | 회복 드루이드 | 피어나는 생명 | 재생, 회복(색상 변경2) | 
        | 신성 기사 | 고결의 봉화 | 빛의 봉화, 신념의 봉화 | 
        | 수양 사제 | 속죄 | 소생, 보호막 | 
        | 신성 사제 | 소생 | 보호막 |
        | 보존 기원사 | 메아리 | 되감기 |
        | 복원 주술사 | 성난 해일 | 대지의 보호막 |
        | 운무 수도사 | 소생의 안개 | 포용의 안개 |
        | 증강 기원사 | 예지 | 끓어오르는 비늘 |

        <iframe width="560" height="315" src="https://www.youtube.com/embed/ELxjSUJ9BIw?si=Kmny1-7UlXZF04Iz" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" referrerpolicy="strict-origin-when-cross-origin" allowfullscreen></iframe>

*   **버프 갱신 경고:**
    *   버프의 남은 지속 시간이 전체 지속 시간의 30%에 도달하면 (일반적인 갱신 시점), 버프 프레임 테두리가 흰색으로 변하고 재사용 대기시간 카운트가 빨간색으로 변합니다.


*   **방어 생존기 표시 (중앙):**
    *   유닛 프레임 중앙에 방어 생존기 사용 여부를 명확하게 표시합니다.
    *   남은 시간이 짧은 순서대로 우선순위를 부여하여, 가장 중요한 방어 생존기 사용 여부를 항상 파악할 수 있습니다.
    *   최대 2개의 방어 생존기를 동시에 표시할 수 있습니다.
    *   생존기 종류는 esc >> 설정 >> 애드온 >> asCompactRaidBuff에서 조정 가능합니다.

*   **Private Aura 표시 (좌상단):**
    *   Private Aura는 추적이 불가능한 디버프로 주로 공격대 특정 디버프를 표시 합니다. 위치/크기만 조정 가능합니다.
    *   유닛에게 할당된 Private Aura 디버프를 좌상단에 표시합니다.

*   **힐러 전용 마나 바 (하단):**
    *   직업 자원 표시를 비활성화하면, 힐러 전용 얇은 마나 바가 표시됩니다.

*   **탱커 전용 파워 바 (하단):**
    *   직업 자원 표시를 비활성화하면, 탱커 전용 얇은 파워 바가 표시됩니다. 탱커가 죽기, 전사, 드루이드 혹은 악사 일경우만 표시.

*   **공격대 징표 표시 (좌중단):**
    *   개별 플레이어에게 할당된 공격대 징표를 유닛 프레임 좌중단에 표시합니다.

*   **시전 중인 적 스킬 표시 (상단 중앙):**
    *   유닛에게 시전되는 적대적인 스킬을 프레임 상단 중앙에 표시합니다.
    *   **Deadly Boss Mods (DBM) 통합:**
        *   차단 가능한 시전은 뚜렷한 녹색 테두리로 강조 표시됩니다.
        *   차단 불가능한 시전은 회색 테두리로 표시됩니다.

*   **해제 가능한 디버프 경고 (테두리):**
    *   해제 가능한 디버프에 대해 유닛 프레임 테두리를 강조 표시합니다.
    *   기본 WoW 공격대/파티 프레임의 해제 가능 디버프 관련 버그를 수정했습니다: 플레이어의 전문화에 따라 모든 해제 가능한 디버프 유형을 감지합니다. (예: 신성 기사는 마법과 독 디버프만 경고받습니다.)
    *   사냥꾼의 경우 독해제 가능시 자신에게 독이 걸렸을 경우 강조 합니다.

*   **보호막 표시:**
    *   보호막의 흡수량이 유닛의 부족한 체력을 초과하면, 초과된 보호막 양을 프레임 왼쪽에 희미하게 표시합니다.      

*   **사제 "생명" 특성 연동:**
    *   사제가 "생명" 특성을 선택한 경우, 파티원의 체력이 35% 미만으로 떨어지면 빨간색으로 경고가 표시됩니다.

* **재사용 대기시간 카운트 표시**
    * 재사용 대기시간 타이머는 숨겨지지만 10초 이하의 버프 지속 시간은 표시됩니다.
    * 버프가 갱신 시점에 가까워지면 지속시간 텍스트가 빨간색으로 변합니다.

*   **사용자 지정 및 옵션:**
    *   이러한 모든 기능은 게임 내 옵션 메뉴 (Esc > 옵션 > 애드온 > asCompactRaidBuff)를 통해 개별적으로 켜고 끌 수 있습니다.

 <iframe width="560" height="315" src="https://www.youtube.com/embed/rSiw0b1oELk?si=wJ4e5xhk8S1_tkTP" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" referrerpolicy="strict-origin-when-cross-origin" allowfullscreen></iframe>

**설치 방법:**

1.  World of Warcraft `Interface/AddOns` 폴더에 복사 합니다. 
2.  Esc >> 편집모드에서 공격대 모양 파티창을 선택하서야 파티창에 반영 됩니다.
4.  와우 공격대 프레임 설정은 다음과 같이 하신는 것을 추천 합니다. (esc > options)

![configuration](https://github.com/aspilla/asMOD/blob/main/.Pictures/ascompactraidbuff_option.jpg?raw=true)   

**설정 예제:**

다음 영상과 같은 방식으로 버프 위치/생존기 설정이 가능합니다.

<iframe width="560" height="315" src="https://www.youtube.com/embed/Oi2s6_P0tb4?si=Z21OK6gyvEogNcoT" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" referrerpolicy="strict-origin-when-cross-origin" allowfullscreen></iframe>

**Tips:**

1. 마우스 클릭 힐 설정 (esc > 설정 > 단축키 > 클릭 시전)
    ![mouseclick](https://github.com/aspilla/asMOD/blob/main/.Pictures/ascompactraidbuff_click.jpg?raw=true)
2. 마우스 오버(휠업/다운) 힐 설정 (esc > 메크로에서 설정 후 단축키를 마우스 휠업/다운 등으로 설정)
    ![mouseover](https://github.com/aspilla/asMOD/blob/main/.Pictures/ascompactraidbuff_macro.jpg?raw=true)

