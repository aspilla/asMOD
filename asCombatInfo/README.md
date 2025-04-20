# asCombatInfo

## Overview

**asCombatInfo** is designed to display cooldowns, charge counts, and the status of related buffs/debuffs for the player's key abilities. It arranges selected ability icons in a configurable group near the bottom center of the screen, providing quick visual access to key information during combat. Used together with asPowerBar, it can serve as a replacement for class WeakAuras.

## Key Features

*   **Cooldown Tracking:** Displays cooldowns on ability icons both visually (circular sweep effect) and as numerical text.
*   **Charge Count Tracking:** Displays the number of available charges for abilities with multiple charges.
*   **Buff/Debuff Display:** Icons can be highlighted or show timers based on related buffs or debuffs.
*   **Totem Tracking:** Supports tracking totem timers.
*   **Combat Opacity Control:** Adjusts the opacity of the icons based on combat state.
*   **Mouseover Tooltips:** Displays the tooltip for the tracked spell/ability when hovering the mouse over its icon.
*   **Configuration:** Button settings can be configured via `esc >> Options >> AddOns >> asCombatInfo`.

## Default Button Configuration Policy

*   By default, 5 buttons are pre-configured per class according to the rules below. These can be changed via `esc >> Options >> AddOns >> asCombatInfo`.
*   Up to 11 buttons can be registered (5 on the top row, 6 on the bottom). If you configure the bottom 6 buttons, the Cooldown list from the `asCooldownpulse` addon will be hidden.

| Button 1          | Button 2              | Button 3         | Button 4          | Button 5             |
| ----------------- | --------------------- | ---------------- | ----------------- | -------------------- |
| Buffs to maintain | Major skill cooldowns | Core cooldowns   | Procs / Finishers | Enemy target debuffs |



![asCombatInfo](https://github.com/aspilla/asMOD/blob/main/.Pictures/ascombatinfo.jpg?raw=true)

---

# asCombatInfo

## 개요 (Overview)

**asCombatInfo**는 플레이어의 중요 기술에 대한 재사용 대기시간, 충전 횟수, 관련 강화/약화 효과 상태를 표시하도록 설계되었습니다. 선택된 기술 아이콘들을 화면 중앙 하단 부근의 설정 가능한 묶음 형태로 배열하여, 전투 중 핵심 정보에 빠르게 시각적으로 접근할 수 있게 합니다. asPowerBar 와 함께 사용하여 직업 Weakaura 를 대체 할 수 있습니다.


## 주요 기능 

*   **재사용 대기시간 추적:** 기술 아이콘 위에 재사용 대기시간을 시각적(원형 시계 효과) 및 숫자 텍스트로 표시합니다.
*   **충전 횟수 추적:** 여러 번 충전되는 기술의 사용 가능한 충전 횟수를 표시합니다.
*   **강화/약화 효과 표시:** 관련된 강화 효과나 약화 효과에 따라 아이콘을 강조하거나 타이머를 표시할 수 있습니다 .
*   **토템 추적:** 토템 타이머 추적을 지원합니다 .
*   **전투 중 투명도 조절:** 전투 상태에 따라 아이콘의 투명도를 조절합니다 .
*   **마우스오버 툴팁:** 아이콘 위에 마우스를 올리면 추적 중인 주문/기술의 툴팁을 표시합니다.
*   **설정 :** esc >> 설정 >> 애드온 >> asCombatInfo에서 버튼 설정을 할 수 있습니다.


## 버튼 기본 설정 정책

* 직업별로 5개의 버튼이 기본 설정 되어 있습니다. 아래와 같은 규칙으로 설정 되어 있으며, esc >> 설정 >> 애드온 >> asCombatInfo에서 설정 변경 가능합니다.
* 최대 11개 버튼등록이 가능합니다. 상단 5개, 하단 6개가 표시 되며, 하단 6개를 추가 하시면 asCooldownpulse 의 Cooldown list 는 표시 되지 않습니다.

| 버튼 1 | 버튼 2 | 버튼 3 | 버튼 4 | 버튼 5 |
| ------ |------ |------ |------ |------ |
| 유지해야 하는 버프 | 주요 스킬 쿨 다운 | 핵심 쿨기 | 마무리 일격등 발동기 | 적대적 대상의 디법 |

![asCombatInfo](https://github.com/aspilla/asMOD/blob/main/.Pictures/ascombatinfo.jpg?raw=true)