# asHealthText (Midnight)

**Text-based HUD** 

Displays health and resource percentages for the player, target, and pet, along with threat levels, incoming heals, and class-specific resources.

![asHealthText](https://github.com/aspilla/asMOD/blob/main/.Pictures/asHealthText.jpg?raw=true)

## Key Features

* **Text-Based Information Hub**:
    * **Player Stats**: Health % and Mana/Energy %.
    * **Target Stats**: Health % (Class-colored for players) and Mana/Energy %.
    * **Pet Stats**: Health % and Mana/Energy %.
    * **Threat Level Indicator**: Displays current threat percentage on the target with status-based coloring.
    * **Target of Target**: Displays the name of your target's target in their respective class color.
    * **Incoming Heals & Absorbs**: Displays predicted health % (including incoming heals) and/or current absorb % (*Currently unsupported*).
    * **Raid Icons**: Displays the Raid Target Icon assigned to the current target (*Currently unsupported*).
* **Class-Specific Resources**:
    * **Death Knight**: Rune count.
    * **Paladin**: Holy Power.
    * **Warlock**: Soul Shards (Decimal display for Destruction).
    * **Druid (Feral/Guardian)**: Combo Points.
    * **Rogue**: Combo Points.
    * **Monk (Brewmaster)**: Stagger damage percentage.
    * **Monk (Windwalker/Mistweaver)**: Chi.
    * **Mage (Arcane)**: Arcane Charges.
    * **Evoker**: Essence.

## Configuration

This addon does not have an in-game GUI. You can adjust the positioning and settings by editing the **Lua variables** located at the top of the `asHealthText/asHealthText.lua` file.

---

# asHealthText (한밤)

**텍스트 기반 HUD**

플레이어, 대상 및 소환수의 생명력 및 자원 백분율을 위협 수준, 받는 치유량, 직업별 자원 표시

![asHealthText](https://github.com/aspilla/asMOD/blob/main/.Pictures/asHealthText.jpg?raw=true)

## 주요 기능

*   **텍스트 기반 정보 허브**:
    *   **플레이어 능력치**: 생명력 % 및 마나/기력 %.
    *   **대상 능력치**: 생명력 % (플레이어인 경우 직업 색상) 및 마나/기력 %.
    *   **소환수 능력치**: 생명력 % 및 마나/기력 %.
    *   **위협 수준 표시**: 대상에 대한 현재 위협 수준 백분율을 상태별 색상으로 표시합니다.
    *   **대상의 대상**: 대상의 대상 이름을 직업 색상으로 표시합니다.
    *   **받는 치유량 및 흡수량**: 플레이어에게 들어오는 치유량을 포함한 예상 생명력 % 및/또는 현재 흡수량 %를 표시합니다. (현재 미지원)
    *   **공격대 아이콘**: 현재 대상에게 설정된 공격대 대상 아이콘을 표시합니다. (현재 미지원)
    *   **직업별 자원**:
        *   죽음의 기사: 룬 개수.
        *   성기사: 신성한 힘.
        *   흑마법사: 영혼의 조각 (파흑은 소숫점으로 표시).
        *   드루이드 (야성/수호): 연계 점수.
        *   도적: 연계 점수.
        *   수도사 (양조): 시간차 피해량 백분율.
        *   수도사 (풍운/운무): 기.
        *   마법사 (비전): 비전 충전물.
        *   기원사: 정수.        


## 설정

별도 설정은 없으며 `asHealthText/asHealthText.lua` 파일 상단의 Lua 변수를 편집하여 위치 조정 가능