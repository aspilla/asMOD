# asFixCombatText

Modifies the position, font size, and healing text visibility of the default UI`s combat text scroll.

<iframe width="560" height="315" src="https://www.youtube.com/embed/itwOlHfYMwA?si=iBCjJuHWjePspLRE" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" referrerpolicy="strict-origin-when-cross-origin" allowfullscreen></iframe>

## Features

1.  Allows changing and configuring the combat text position.
2.  **Damage Color Customization**:
    *   **Normal Damage (Red)**: Configurable via `DAMAGE_COLOR` in the Lua file.
    *   **Spell Damage (Purple)**: Configurable via `SPELL_DAMAGE_COLOR` in the Lua file.
    *   **Damage after Shield Block (Bright Red)**: Configurable via `DAMAGE_SHIELD_COLOR` in the Lua file.
    *   **Periodic Damage (White)**: Configurable via `SPLIT_DAMAGE_COLOR` in the Lua file.
3.  Sets combat text font size to 14. Configurable.
4.  Hides healing amounts. Configurable.

## Deletion

After deleting the addon, you must manually disable the default UI`s combat text scroll feature.
Go to Esc >> Options and disable the combat text scroll feature.

## Settings

Configurable via Esc >> Options >> Addons >> asFixCombatText.
1.  Turning off `LockPosition` will display a position adjustment window. It can also be changed via the `/asconfig` settings of the `asMOD` addon, and `/asconfig` settings have higher priority.
2.  The `ShowHeal` option allows you to determine whether to display healing amounts. It is unchecked by default.
3.  The `FontSize` option allows you to adjust the font size. The default is 14.

---

# asFixCombatText

기본 UI의 전투 상황 알림 스크롤에 위치 및 글자 크기, 치유량을 숨기를 기능을 합니다.

<iframe width="560" height="315" src="https://www.youtube.com/embed/itwOlHfYMwA?si=iBCjJuHWjePspLRE" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" referrerpolicy="strict-origin-when-cross-origin" allowfullscreen></iframe>

## 기능

1. 전투 텍스트 의 위치를 변경 하고 설정 가능합니다.
2. **피해량 색상 변경**:
    **기본 피해량 (적색)**  lua 파일내 DAMAGE_COLOR 로 설정 가능
    **마법 피해량 (보라색)** lua 파일내 SPELL_DAMAGE_COLOR 로 설정 가능
    **보호막 방어 후 피해량 (밝은 적색)** lua 파일내 DAMAGE_SHIELD_COLOR로 설정 가능
    **주기적 피해 (흰색)** lua 파일내 SPLIT_DAMAGE_COLOR 로 설정 가능
3. 전투 텍스트 글꼴 크기를 14로 지정합니다. 설정 가능합니다.
4. 치유 량을 숨깁니다. 설정 가능합니다.

## 삭제

애드온 삭제후 기본 UI의 전투 상황 알림 스크롤 기능을 별도로 꺼 주셔야 합니다.
esc >> 설정에서 전투 상황 알림 스크롤 기능을 꺼 주세요ㅈ

## 설정

esc >> 설정 >> 애드온 >> asFixCombatText 에서 설정 가능합니다.
1. `LockPosition`을 끄면 위치 이동창이 나옵니다. asMOD 애드온의 `/asconfig` 설정으로 변경도 가능하며 `/asconfig` 설정이 우선순위가 높습니다.
2. `ShowHeal` 옵션으로 치유량 표시 여부를 결정 할 수 있습니다. 기본 미채크 입니다.
3. `FontSize` 옵션으로 글자 크기 조정이 가능합니다. 기본 14입니다.
