# asCooldownPulse (Midnight)

Displays cooldowns for trinkets, racial abilities, Healthstones, and potions.

![asCooldownPulse](https://github.com/aspilla/asMOD/blob/main/.Pictures/asCooldownPulse_MN.jpg?raw=true)

## Key Features

* **Trinket Cooldown Display (Right)**: Displays cooldowns for usable trinkets when equipped.
* **Racial Ability Cooldown Display (Right)**
* **Combat Potion Cooldown Display (Left)**: Displays the cooldown for major combat potions.
* **Survival Potion Cooldown Display (Left)**: Displays the cooldown for major survival potions.
* **Healthstone Cooldown/Count Display (Left)**: Only displayed when a Healthstone is in your inventory.
* **Skill Cooldown Tracking (Bottom of Target Frame)**: Designed to track specific skills that are not shown in the `Cooldown Manager`, such as Survival Hunter's `Aspect of the Eagle` (Only `Aspect of the Eagle` is registered by default).

## Configuration
* Accessible via `ESC` > `Options` > `AddOns` > `asCooldownPulse`.
* `CombatAlphaChange`: Adjusts transparency when out of combat (Default: On).
* `ShowTrinkets`: Toggle display of trinket/racial cooldowns (Default: On).
* `TrinketSize`: Icon size for trinket/racial cooldowns (Default: 28).
* `ShowItems`: Toggle display of potion/Healthstone cooldowns (Default: On).
* `ItemSize`: Icon size for potion/Healthstone cooldowns (Default: 28).
* `ShowSpells`: Toggle display of skill cooldown tracking (Default: On).
* `SpellSize`: Icon size for skill cooldown tracking (Default: 28).

* A `/reload` is required after changing sizes.

* You can register skills for cooldown tracking via `ESC` > `Options` > `AddOns` > `asCooldownPulse` > `Spell List`.
* To find the `Spell ID`, using an additional addon like ID Tip is recommended.

<iframe width="560" height="315" src="https://www.youtube.com/embed/51H0QW8MXyY?si=04JGGrTUrJJo6jzj" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" referrerpolicy="strict-origin-when-cross-origin" allowfullscreen></iframe>

* **Repositioning**: Enter the `/asconfig` command in the chat window.
* **Reset Position**: Enter the `/asclear` command in the chat window to reset to default settings.

---

# asCooldownPulse (한밤)

장신구, 종특, 생석, 물약 쿨 표시

![asCooldownPulse](https://github.com/aspilla/asMOD/blob/main/.Pictures/asCooldownPulse_MN.jpg?raw=true)

## 주요 기능

*   **장신구 쿨 표시(우측)**: 사용가능 장신구 착용시 장신구 쿨 표시.
*   **종특 쿨 표시(우측)** 
*   **전투 물약 쿨 표시(좌측)** : 대표 물약 쿨만 표시
*   **생존 물약 쿨 표시(좌측)** : 대표 물약 쿨만 표시
*   **생석 쿨/사용 가능 개수 표시(좌측)** : 생석을 지니고 있을때만 표시
*   **스킬 쿨 추적 (타겟 프레임 하단)** : 생냥 `독수리의 상` 등 `재사용 대기 관리자`에 표시 안되는 스킬을 추적하기 위한 설정 (`독수리의 상` 만 등록 되어 있음)


## 설정
*   `ESC` > `설정` > `애드온` > `asCooldownPulse` 에서 설정 가능
*   `CombatAlphaChange` : 비전투시 투명도 변경 (Default On)
*   `ShowTrinkets` : 장신구/종특 쿨 표시 여부 (Default On)
*   `TrinketSize` : 장신구/종특 쿨 사이즈 (Default 28)
*   `ShowItems` : 물약/생석 쿨 표시 여부 (Default On)
*   `ItemSize`  : 물약/생석 쿨 사이즈 (Default 28)
*   `ShowSpells` : 스킬 쿨 추적 표시 여부 (Default On)
*   `SpellSize` : 스킬 쿨 추적 사이즈 (Default 28)

* 크기 변경후 `/reload` 필요

*   `ESC` > `설정` > `애드온` > `asCooldownPulse` > `Spell List` 에서 쿨 추적할 스킬 등록 가능
*   `Spell ID` 확인이 필요하여 ID Tip등 추가 애드온 사용

<iframe width="560" height="315" src="https://www.youtube.com/embed/51H0QW8MXyY?si=04JGGrTUrJJo6jzj" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" referrerpolicy="strict-origin-when-cross-origin" allowfullscreen></iframe>

*  **위치 이동** : `/asConfig` 명령어 채팅창에 입력
*  **위치 초기화** : `/asClear` 명령어 채팅창에 입력, 기본 설정으로 초기화 