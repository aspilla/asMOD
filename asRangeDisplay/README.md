# asRangeDisplay

Displays Target/Focus/Mouseover distance.
![asRangeDisplay](https://github.com/aspilla/asMOD/blob/main/.Pictures/asRangeDisplay.JPG?raw=true)

## Features

*   **Hostile Target Distance**: Displays distance from 5 to 100 yards, regardless of combat.
*   **Friendly Target Distance (Out of Combat)**: Displays distance from 5 to 80 yards.
*   **Friendly Target Distance (In Combat)**: Determined by the `UnitInRange` function (40 yards, 25 for Evokers, or 80 if further). Shorter distances are determined by the character's skill range (e.g., if a 25-yard skill is in range, it will display as 25).
*   **Friendly Focus/Mouseover Distance (In Combat)**: Determined by the `UnitInRange` function (40 yards, 25 for Evokers, or 80 if further). If it's the same unit as the target, it displays based on the target's distance.
*   **Distance Color**: The text color changes based on the distance:
    *   Red: > 40 yards
    *   Yellow/Orange: > 30-40 yards
    *   Green: > 20-30 yards
    *   Cyan/Blue: > 5-20 yards
    *   Gray/White: <= 5 yards or distance 0.

## Settings
You can change the following settings in: `ESC` > `Options` > `AddOns` > `asRangeDisplay`
*   `ShowTarget`: Whether to show the distance to the target (Default: true)
*   `ShowFocus`: Whether to show the distance to the focus target (Default: true)
*   `ShowMouseOver`: Whether to show the distance to the mouseover target (Default: true)

If using `asMOD`, you can change the display position of the target/focus distance with the `/asConfig` command.

For other settings, edit the Lua variables at the top of the `asRangeDisplay/asRangeDisplay.lua` file.

---

# asRangeDisplay

대상/주시/마우스오버 거리를 표시
![asRangeDisplay](https://github.com/aspilla/asMOD/blob/main/.Pictures/asRangeDisplay.JPG?raw=true)   

## 주요 기능

*   **적대적 대상의 거리**: 전투의 상관없이 5 ~ 100미터까지의 거리를 표시
*   **아군 대상의 거리 (비전투)**: 5 ~ 80미터까지의 거리를 표시
*   **아군 대상의 거리 (전투)**: UnitInRange 함수로 판단(40미터, 기원사 25미터, 거리가 멀면 80미터로 표시), 그보다 짧은 거리는 케릭의 스킬 사거리로 판단 (25미터 사거리 스킬이 있고 사거리 안에 있는 경우 250미터로 표기)
*   **아군 주시/마우스 오버의 거리 (전투)**: UnitInRange 함수로 판단(40미터, 기원사 25미터, 거리가 멀면 80미터로 표시), 단 대상과 같은 유닛이면 대상 기준으로 표시
*   **거리 색상**: 거리 텍스트는 거리에 따라 색상이 변경됩니다:
    *   빨간색: > 40미터
    *   노란색/주황색: > 30-40미터
    *   녹색: > 20-30미터
    *   청록색/파란색 계열: > 5-20미터
    *   회색/흰색: <= 5미터 또는 거리 0.

## 설정
`ESC` > `설정` > `애드온` > `asRangeDisplay` 에서 다음 설정 변경 가능
*   `ShowTarget`: 대상과의 거리 표시 여부 (기본값: true)
*   `ShowFocus` : 주시 대상과의 거리 표시 여부 (기본값: true)
*   `ShowMouseOver` : 마우스 오버 대상과의 거리 표시 여부 (기본값: true)

`asMOD` 사용시 `/asConfig` 명령어로 대상/주시와의 거리 표시 위치 변경 가능

그외 설정은 `asRangeDisplay/asRangeDisplay.lua` 파일 상단의 Lua 변수를 편집
