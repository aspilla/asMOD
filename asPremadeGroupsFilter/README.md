# asPremadeGroupsFilter

asPremadeGroupsFilter enhances Blizzard's Premade Groups Finder (LFG List) by providing more detailed visual information about group compositions, primarily for Mythic+ Dungeons and Raid listings.

## Main Features

### For Mythic+ Dungeon Listings (Category ID 2)

*   **Leader's Mythic+ Score Display (`ShowLeaderScore` option)**:
    *   If enabled (default: true), displays the group leader's overall Mythic+ dungeon score.
    *   The score is color-coded based on its rating, similar to Blizzard's own color scheme for M+ scores.
*   **Party Member Specialization Icons & Class Bars**:
    *   Displays the specialization icon for each member in the group.
    *   Shows a small colored bar representing the class of each member.
    *   Optionally shows specialization icons/bars for Tanks (`ShowTankerSpec` option, default: false).
    *   Optionally shows specialization icons/bars for Healers (`ShowHealerSpec` option, default: false).
    *   DPS specializations are generally shown if the feature for their role is active.
    *   A small icon indicates the group leader.
    *   This information is overlaid on the default role icons in the LFG list, offering a quick glance at group makeup.

### For Raid Listings (Category ID 3)

*   **Role & Class Composition Summary**:
    *   Displays a count of each class within each role (Tank, Healer, DPS) present in the group.
    *   Example: `T: W1 P1 H: P2 D1 D: M3 R2 W1` (T=Tank, W=Warrior, P=Paladin, etc.)
    *   Class counts are colored according to their standard class colors.
*   **Leader Information**:
    *   Shows an icon for the leader's role and the first letter of their class, colored by class.

### General

*   **In-Game Configuration**: Options are available in the Blizzard Addon Settings panel.
*   **Automatic Updates**: Information is updated as you browse the LFG list.

## How it Works

The addon hooks into the standard LFG list update process.
*   When an entry for a Mythic+ group is displayed, it fetches member details (role, class, spec, leader status) and the leader's M+ score. It then creates and overlays new textures and font strings to show spec icons, class color bars, and the score.
*   For raid group entries, it counts the number of players for each class within each role and formats this into a summary string, also indicating the leader's class and role.
*   The visibility of certain details is controlled by user-configurable options.

## Configuration

Settings can be accessed via the Blizzard Addon Settings panel:
1.  Open Game Menu (Esc).
2.  Click "Options".
3.  Go to the "AddOns" tab.
4.  Select "asPremadeGroupsFilter".
5.  Adjust the following:
    *   **`ShowHealerSpec` (Checkbox)**: If checked, specialization icons/bars for Healers will be shown in Mythic+ listings. (Default: false)
    *   **`ShowTankerSpec` (Checkbox)**: If checked, specialization icons/bars for Tanks will be shown in Mythic+ listings. (Default: false)
    *   **`ShowLeaderScore` (Checkbox)**: If checked, the group leader's Mythic+ score will be shown in Mythic+ listings. (Default: true)

Changes to these settings are saved per character and typically take effect on the next refresh of the LFG list.

---

# asPremadeGroupsFilter

asPremadeGroupsFilter는 블리자드의 미리 구성된 그룹 찾기(LFG 목록)를 강화하여, 주로 신화 쐐기돌 던전 및 공격대 목록에 대한 그룹 구성에 대한 더 자세한 시각적 정보를 제공합니다.

## 주요 기능

### 신화 쐐기돌 던전 목록용 (카테고리 ID 2)

*   **파티장의 신화 쐐기돌 점수 표시 (`ShowLeaderScore` 옵션)**:
    *   활성화된 경우(기본값: true), 그룹 리더의 전체 신화 쐐기돌 던전 점수를 표시합니다.
    *   점수는 M+ 점수에 대한 블리자드 자체 색상 구성표와 유사하게 등급에 따라 색상으로 구분됩니다.
*   **파티원 전문화 아이콘 및 직업 바**:
    *   그룹의 각 구성원에 대한 전문화 아이콘을 표시합니다.
    *   각 구성원의 직업을 나타내는 작은 색상 바를 표시합니다.
    *   선택적으로 탱커에 대한 전문화 아이콘/바를 표시합니다 (`ShowTankerSpec` 옵션, 기본값: false).
    *   선택적으로 힐러에 대한 전문화 아이콘/바를 표시합니다 (`ShowHealerSpec` 옵션, 기본값: false).
    *   딜러 전문화는 해당 역할에 대한 기능이 활성화된 경우 일반적으로 표시됩니다.
    *   작은 아이콘이 그룹 리더를 나타냅니다.
    *   이 정보는 LFG 목록의 기본 역할 아이콘 위에 오버레이되어 그룹 구성을 빠르게 파악할 수 있도록 합니다.

### 공격대 목록용 (카테고리 ID 3)

*   **역할 및 직업 구성 요약**:
    *   그룹에 있는 각 역할(탱커, 힐러, 딜러) 내 각 직업의 수를 표시합니다.
    *   예: `T: W1 P1 H: P2 D1 D: M3 R2 W1` (T=탱커, W=전사, P=성기사 등)
    *   직업 수는 표준 직업 색상에 따라 색상이 지정됩니다.
*   **파티장 정보**:
    *   파티장의 역할 아이콘과 직업의 첫 글자를 직업 색상으로 표시합니다.

### 일반

*   **게임 내 설정**: 블리자드 애드온 설정 패널에서 옵션을 사용할 수 있습니다.
*   **자동 업데이트**: LFG 목록을 탐색할 때 정보가 업데이트됩니다.

## 작동 방식

애드온은 표준 LFG 목록 업데이트 프로세스에 연결됩니다.
*   신화 쐐기돌 그룹 항목이 표시되면 구성원 세부 정보(역할, 직업, 전문화, 파티장 상태)와 파티장의 M+ 점수를 가져옵니다. 그런 다음 새로운 텍스처와 글꼴 문자열을 만들고 오버레이하여 전문화 아이콘, 직업 색상 바 및 점수를 표시합니다.
*   공격대 그룹 항목의 경우 각 역할 내 각 직업의 플레이어 수를 계산하고 이를 요약 문자열로 형식화하며 파티장의 직업과 역할도 표시합니다.
*   특정 세부 정보의 표시는 사용자가 구성할 수 있는 옵션에 의해 제어됩니다.

## 설정

설정은 블리자드 애드온 설정 패널을 통해 접근할 수 있습니다:
1.  게임 메뉴(Esc)를 엽니다.
2.  "설정"을 클릭합니다.
3.  "애드온" 탭으로 이동합니다.
4.  목록에서 "asPremadeGroupsFilter"를 선택합니다.
5.  다음을 조정합니다:
    *   **`ShowHealerSpec` (체크박스)**: 선택하면 신화 쐐기돌 목록에 힐러의 전문화 아이콘/바가 표시됩니다. (기본값: false)
    *   **`ShowTankerSpec` (체크박스)**: 선택하면 신화 쐐기돌 목록에 탱커의 전문화 아이콘/바가 표시됩니다. (기본값: false)
    *   **`ShowLeaderScore` (체크박스)**: 선택하면 신화 쐐기돌 목록에 그룹 리더의 신화 쐐기돌 점수가 표시됩니다. (기본값: true)

이러한 설정 변경 사항은 캐릭터별로 저장되며 일반적으로 LFG 목록을 다음에 새로고침할 때 적용됩니다.
