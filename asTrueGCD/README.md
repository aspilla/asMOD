# asTrueGCD

Displays a history of recently used spells and items.
![asTrueGCD](https://github.com/aspilla/asMOD/blob/main/.Pictures/asTrueGCD.jpg?raw=true)

## Key Features

*   **Current Cast Display**:
    *   Shows the icon of the spell or item the character is currently casting or channeling.
    *   A counter appears on this main icon if the same spell is cast multiple times in a row.

*   **Spell/Item Cast History**:
    *   To the left of the current cast icon, it displays up to three icons of the last successfully cast or used spells or items in sequence.
    *   **Interruption Indicator**: If a spell cast is interrupted, an "X" will appear on the corresponding icon in the history.
    *   **Consecutive Cast Counter**: If the same spell/item is used multiple times in a row, a counter is displayed on the icon.
    *   History icons disappear after about 5 seconds.

*   **Blacklist**: Ignores certain common, low-impact spells (e.g., Auto Attack) to keep the display relevant.

## Configuration

There is no separate configuration panel.
Settings are configured by editing Lua variables at the top of the `asTrueGCD/asTrueGCD.lua` file:

*   `ATGCD_X`, `ATGCD_Y`: The default X and Y offsets of the main (current cast) icon from the center of the screen. History icons are positioned to its left. (Default: 56, -360)
*   `AGCICON`: The base size of the icons. The main current cast icon is slightly larger (1.3x). (Default: 25)
*   The `AGCD_BlackList` table in the Lua file can be modified by advanced users to add or remove spell IDs that should be ignored by the history display.
    (Spell IDs can be found by mousing over icons with the IdTip addon installed).

If `asMOD` is installed, the position can be moved using the `/asConfig` command.

---

# asTrueGCD

최근 사용한 주문 및 아이템 사용 기록 표시
![asTrueGCD](https://github.com/aspilla/asMOD/blob/main/.Pictures/asTrueGCD.jpg?raw=true)

## 주요 기능

*   **현재 시전 표시**:
    *   캐릭터가 현재 시전 또는 채널링 중인 주문이나 아이템의 아이콘을 표시 합니다.
    *   동일한 주문을 연속으로 여러 번 시전하면 이 주 아이콘에 카운터가 나타납니다.

*   **주문/아이템 시전 기록**:
    *   현재 시전 아이콘의 왼쪽에 성공적으로 시전했거나 사용한 마지막 세 개의 주문 또는 아이템 아이콘을 순서대로 최대 3개 표시합니다.
    *   **차단 표시**: 주문 시전이 차단되면 기록의 해당 아이콘에 "X"가 표시됩니다.
    *   **연속 시전 카운터**: 동일한 주문/아이템을 연속으로 여러 번 사용한 경우, 아이콘에 카운터가 표시됩니다.
    *   기록 아이콘은 약 5초 후에 사라집니다.

*   **블랙리스트**: 관련성 있는 표시를 유지하기 위해 특정 일반적이고 영향이 적은 주문(예: 자동 공격)을 무시합니다.

## 설정

별도의 설정 패널은 없습니다.
설정은 `asTrueGCD/asTrueGCD.lua` 파일 상단의 Lua 변수를 편집하여 수행합니다:

*   `ATGCD_X`, `ATGCD_Y`: 주 (현재 시전) 아이콘의 화면 중앙으로부터의 기본 X 및 Y 오프셋입니다. 기록 아이콘은 그 왼쪽에 위치합니다. (기본값: 56, -360)
*   `AGCICON`: 아이콘의 기본 크기 주 현재 시전 아이콘은 약간 더 큽니다(1.3배). (기본값: 25)
*   Lua 파일의 `AGCD_BlackList` 테이블은 고급 사용자가 수정하여 기록 표시에 의해 무시되어야 하는 주문 ID를 추가하거나 제거할 수 있습니다.
    (주문 아이디는 IdTip 애드온 설치 후, 아이콘이 마우스 오버하면 확인 가능)

`asMOD`가 설치된 경우, `/asConfig` 명령어로 위치 이동이 가능합니다