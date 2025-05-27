# asGearScoreLite

asGearScoreLite is a lightweight World of Warcraft addon that displays item levels directly on your Character Frame and the Inspect Frame. It also calculates and shows the average item level for inspected targets.

## Main Features

*   **Individual Item Level Display**:
    *   **Character Frame**: Shows the item level of each piece of your equipped gear directly on the item slots in your Character Pane (C). The text is colored according to item quality (e.g., Epic, Rare).
    *   **Inspect Frame**: When inspecting another player, displays the item level of each piece of their equipped gear on their respective item slots, also colored by quality.

*   **Average Item Level for Target**:
    *   When you inspect another player, their average item level is calculated and displayed prominently on the Inspect Frame (e.g., "450 Lvl").
    *   The calculation correctly weights two-handed weapons by counting them effectively as two slots to provide an accurate average.

*   **Tooltip-Based Item Level Detection**:
    *   Uses a temporary tooltip to scan item information and retrieve the item level, ensuring compatibility even if item data structures change.

*   **Dynamic Updates**:
    *   Player's item levels on the Character Frame update when equipment is changed.
    *   Target's item levels and average item level update when the Inspect Frame is shown.

## How it Works

1.  **Character Frame**: When your Character Frame is opened or your gear changes, the addon iterates through your equipment slots, creates small text overlays on each slot, and displays the item level (colored by quality) obtained by scanning the item's tooltip.
2.  **Inspect Frame**: When you inspect another player, a similar process occurs for their gear. Additionally, an average item level is calculated. This average considers all equipped slots and gives appropriate weight to two-handed weapons. The average is then displayed in a dedicated text field on the Inspect Frame.

## Configuration

*   **Font Size**:
    *   The font size for the individual item level text can be adjusted by changing the `AGS_FontSize` variable at the top of `asGearScoreLite/asGearScoreLite.lua`. The default is `11`.
    *   The average item level display on the inspect frame uses `AGS_FontSize + 2`.

**Note**: This addon does not provide an in-game configuration panel. Customization of font size requires editing the `.lua` file.

---

# asGearScoreLite

asGearScoreLite는 자신의 캐릭터 창 및 살펴보기 창에 아이템 레벨을 직접 표시하는 가벼운 월드 오브 워크래프트 애드온입니다. 또한 살펴본 대상의 평균 아이템 레벨을 계산하여 표시합니다.

## 주요 기능

*   **개별 아이템 레벨 표시**:
    *   **캐릭터 창**: 자신의 캐릭터 창(C)에 있는 각 착용 장비의 아이템 레벨을 해당 아이템 슬롯에 직접 표시합니다. 텍스트는 아이템 등급(예: 영웅, 희귀)에 따라 색상이 지정됩니다.
    *   **살펴보기 창**: 다른 플레이어를 살펴볼 때, 해당 플레이어가 착용한 각 장비의 아이템 레벨을 각 아이템 슬롯에 등급별 색상으로 표시합니다.

*   **대상의 평균 아이템 레벨**:
    *   다른 플레이어를 살펴볼 때, 해당 플레이어의 평균 아이템 레벨이 계산되어 살펴보기 창에 눈에 띄게 표시됩니다 (예: "450 Lvl").
    *   계산 시 양손 무기는 정확한 평균을 제공하기 위해 효과적으로 두 개의 슬롯으로 계산하여 적절한 가중치를 부여합니다.

*   **툴팁 기반 아이템 레벨 감지**:
    *   임시 툴팁을 사용하여 아이템 정보를 스캔하고 아이템 레벨을 가져오므로, 아이템 데이터 구조가 변경되더라도 호환성을 보장합니다.

*   **동적 업데이트**:
    *   캐릭터 창의 플레이어 아이템 레벨은 장비가 변경될 때 업데이트됩니다.
    *   대상의 아이템 레벨 및 평균 아이템 레벨은 살펴보기 창이 표시될 때 업데이트됩니다.

## 작동 방식

1.  **캐릭터 창**: 캐릭터 창을 열거나 장비를 변경하면, 애드온은 장비 슬롯을 반복하면서 각 슬롯에 작은 텍스트 오버레이를 만들고 아이템 툴팁을 스캔하여 얻은 아이템 레벨(등급별 색상)을 표시합니다.
2.  **살펴보기 창**: 다른 플레이어를 살펴보면 해당 플레이어의 장비에 대해서도 유사한 프로세스가 발생합니다. 추가적으로 평균 아이템 레벨이 계산됩니다. 이 평균은 모든 착용 슬롯을 고려하며 양손 무기에 적절한 가중치를 부여합니다. 그런 다음 평균값은 살펴보기 창의 전용 텍스트 필드에 표시됩니다.

## 설정

*   **글꼴 크기**:
    *   개별 아이템 레벨 텍스트의 글꼴 크기는 `asGearScoreLite/asGearScoreLite.lua` 파일 상단의 `AGS_FontSize` 변수를 변경하여 조정할 수 있습니다. 기본값은 `11`입니다.
    *   살펴보기 창의 평균 아이템 레벨 표시는 `AGS_FontSize + 2`를 사용합니다.

**참고**: 이 애드온은 게임 내 설정 패널을 제공하지 않습니다. 글꼴 크기 사용자 정의는 `.lua` 파일을 편집해야 합니다.
