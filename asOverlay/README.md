# asOverlay - Enhancing WoW's Default UI Spell Alerts

## Features

*   **Spell Alert Duration Display:** The appearance and transparency of spell alerts dynamically adjust based on the remaining duration of the associated buff.
*   **Buff Stack Differentiation:** Provides distinct visual cues based on the buff stack count. Below is an example using Demonology Warlock's Demonic Core:
    *   **1 Stack:** Displayed on the left side.
    *   **2 Stacks:** One icon displayed on both the left and right sides.
    *   **3 Stacks:** Displayed with a green icon on the right side.
    *   **4 Stacks:** Displayed with a blue icon on the right side.

*   **Proc Buff Tracking:** Tracks proc effect buffs. When a tracked buff procs, a red visual effect appears on both the left and right sides.

    | Class                 | Skill/Proc                                       | Notes                                         |
    | --------------------- | ------------------------------------------------ | --------------------------------------------- |
    | Feral Druid           | Omen of Clarity                                  |                                               |
    | Demonology Warlock    | Demonic Core                                     | Color change at 3, 4 stacks                   |
    | Affliction Warlock    | Nightfall                                        |                                               |
    | Restoration Druid     | Omen of Clarity                                  |                                               |
    | Shadow Priest         | Shadowy Insight / Insanity Procs                 | Color change at 3/4 stacks                    |
    | Arcane Mage           | Clearcasting / Arcane Harmony                    | Clearcasting (3 stacks, Red), Harmony (Green) |
    | Preservation Evoker | Essence Burst                                    | Color change at 2 stacks                      |
    | Frost Mage            | Heating Up                                       | Color change                                  |
    | Guardian Druid        | Gore                                             | Color change at 2 stacks                      |

    <iframe width="560" height="315" src="https://www.youtube.com/embed/w3U6Xwr-MSY?si=XX8bPLyG-y6ttS-D" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" referrerpolicy="strict-origin-when-cross-origin" allowfullscreen></iframe>

*   **Additional Overlay:** Adds a specific overlay for Enhancement Shaman's `[Hot Hand]` proc.

    <iframe width="560" height="315" src="https://www.youtube.com/embed/pkqvSZPMBLw?si=kWnsbNLDbXC17Lgf" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" referrerpolicy="strict-origin-when-cross-origin" allowfullscreen></iframe>

*   **Redundancy Hiding:** Automatically hides alerts for buffs already displayed by the `asPowerBar` or `asCombatInfo` addons to prevent screen clutter.

## Requirements

*   **In-Game Setting:** You must ensure that the default spell alerts are enabled in the WoW settings:
    *   Press `ESC` > `Interface` > `Combat`
    *   Check the box for "**Show Spell Alerts**"


---

# asOverlay - WoW 기본 UI 주문 알림 강화

## 기능

*   **주문 알림 지속 시간 표시:** 관련 버프의 남은 지속 시간에 따라 주문 알림의 외형과 투명도가 동적으로 조절됩니다.
*   **버프 중첩 구분:** 버프 중첩 수에 따라 뚜렷하게 구분되는 시각적 신호를 제공합니다. 아래는 악흑 악마화살의 예 입니다.:
    *   **1 중첩:** 왼쪽에 표시됩니다.
    *   **2 중첩:** 왼쪽과 오른쪽에 각각 하나씩 아이콘이 표시됩니다.
    *   **3 중첩:** 오른쪽에 녹색 아이콘으로 표시됩니다.
    *   **4 중첩:** 오른쪽에 파란색 아이콘으로 표시됩니다.

*   **발동 버프 추적:** 발동 효과 버프()를 추적합니다. 버프가 발동되면 왼쪽과 오른쪽에 붉은색 시각 효과가 나타납니다.

    |직업|스킬|비고|
    |---|---|---|
    |야드|번뜩임| |
    |악흑|악마의 핵 |3,4 중 색상 변경|
    |고흑|일몰| |
    |회드|번뜩임| |
    |암사|광기|3/4 중 생상 변경|
    |비법|번뜩임|3중첩 색상 변경[빨], 에테르 조율[초]|
    |보존|생명의 불꽃|2중 색상 변경)|
    |냉법|화염 촉진|색상 변경|
    |수드|맹위 |2중 색상 변경|
    

    <iframe width="560" height="315" src="https://www.youtube.com/embed/w3U6Xwr-MSY?si=XX8bPLyG-y6ttS-D" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" referrerpolicy="strict-origin-when-cross-origin" allowfullscreen></iframe>


*   **Overlay 추가:** 고양술사 [뜨거운 손]의 경우 Overlay를 추가하여 표시 합니다.

    <iframe width="560" height="315" src="https://www.youtube.com/embed/pkqvSZPMBLw?si=kWnsbNLDbXC17Lgf" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" referrerpolicy="strict-origin-when-cross-origin" allowfullscreen></iframe>


*   **중복 숨김:** `asPowerBar` 또는 `asCombatInfo` 애드온에서 이미 표시 중인 버프의 알림은 자동으로 숨겨 화면이 복잡해지는 것을 방지합니다.

## 요구 사항

*   **게임 내 설정:** 와우 설정에서 기본 주문 알림이 활성화되어 있는지 확인해야 합니다:
    *   `ESC` 키 > `인터페이스 설정` > `전투`
    *   "**주문 알림 표시**" 확인란을 체크합니다.