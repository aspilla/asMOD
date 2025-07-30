# asActiveAlert (English)

This addon provides visual alerts by displaying spell icons to the left of your character when they become active or meet special conditions (e.g., procs), indicated by the glowing border on your action bar.

![asActiveAlert](https://github.com/aspilla/asMOD/blob/main/.Pictures/asActiveAlert.png?raw=true)

## Key Features

1.  **Spell Activation Alerts**:
    *   Displays the icon of a spell to the left of your character when it becomes usable or is highlighted by an effect (when the glowing border appears on the action bar icon).
    *   Spells registered in `asCombatInfo` will not trigger alerts.
    *   The spell list is not editable.
    *   Displays cooldown text on the icon.
    *   Only shows spells that the player has learned.

## Configuration

There are no in-game configuration options.

1.  **Modify Variables in the Source Code**:
    *   Icon Size: `ASAA_SIZE`
    *   Default Position of the Icon Bar: `ASAA_CoolButtons_X`, `ASAA_CoolButtons_Y`
    *   Icon Transparency: `ASAA_Alpha`
    *   Cooldown Font Size: `ASAA_CooldownFontSize`

2.  **Filtering**:
    *   **Blacklist (`ASAA_BackList`)**: You can add specific spell IDs to this list to prevent them from triggering alerts. (e.g., `[115356] = true, -- Windstrike`)

3.  **Positioning**:
    *   If the `asMOD` addon is installed, you can configure the position using the `/asConfig` command provided by `asMOD`.

---

# asActiveAlert (Korean)

주문이 활성화되거나 특별한 조건(예: 발동 효과)을 만족했을 때 (스킬바에 빤찍이는 테두리가 표시 될 경우) 해당 주문의 아이콘을 케릭 좌측 표시하여 시각적으로 알려주는 애드온

![asActiveAlert](https://github.com/aspilla/asMOD/blob/main/.Pictures/asActiveAlert.png?raw=true)

## 주요 기능

1.  **주문 발동 알림**:
    *   주문이 사용 가능해지거나 특정 효과로 인해 강조될 때 (게임 내에서 아이콘 테두리에 빛나는 효과가 나타나는 경우) 해당 주문의 아이콘을 케릭 좌측에 표시
    *   asCombatInfo에 등록된 주문은 알리지 않음
    *   주문 목록 편집은 불가
    *   재사용 대기시간 표시
    *   플레이어가 배운 주문만 표시


## 설정

별도의 설정은 없음

1.  **소스 코드 내 변수 수정**:
    *   아이콘의 크기 (`ASAA_SIZE`)
    *   아이콘 바의 기본 위치 (`ASAA_CoolButtons_X`, `ASAA_CoolButtons_Y`)
    *   아이콘의 투명도 (`ASAA_Alpha`)
    *   재사용 대기시간 폰트 크기 (`ASAA_CooldownFontSize`)

2.  **필터링 기능**:
    *   **블랙리스트 (`ASAA_BackList`)**: 특정 주문 ID를 이 목록에 추가하여 알림에서 제외할 수 있습니다. (예: `[115356] = true, --고술 바람의 일격`)

3.  **위치 이동**:
    *   `asMOD` 애드온이 설치되어 있는 경우, `asMOD`의 `/asConfig` 명령어를 통해 설정 가능