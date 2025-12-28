# asFixUnitFrame (Midnight)

Enhances the default Blizzard Unit Frames (Player, Target, Target of Target).
![asFixUnitFrame](https://github.com/aspilla/asMOD/blob/main/.Pictures/asFixUnitFrame.png?raw=true)
![asFixUnitFrame2](https://github.com/aspilla/asMOD/blob/main/.Pictures/asFixUnitFrame2.png?raw=true)

## Key Features

* **Optional Unit Frame Modifications (Configurable via Addon Settings)**:
    * **Hide Combat Text on Frames**: Prevents default Blizzard combat status text from appearing directly on Player, Target, and Pet unit frames.
    * **Hide Target Buffs/Debuffs**: Removes the standard buff and debuff icons from the Target unit frame.
    * **Hide Target Cast Bar**: Hides the cast bar attached to the Target unit frame.
    * **Hide Player Class Bar**: Hides special class resource displays (e.g., Rogue Combo Points, Death Knight Runes, Evoker Essence).
    * **Hide Player Totem Bar (Default: Disabled)**: Hides the Shaman Totem bar and Warlock Infernal bar.
    * **Numeric Threat Display**: Enables the numeric threat level display on the Target (`threatShowNumeric` CVar setting).
    * **Class-Colored Health Bars**: Changes the health bar colors of Player, Target, and Target of Target frames to their respective class colors (if the unit is a player).

## Configuration

* Options can be modified via `ESC` > `Options` > `Addons` > `asFixUnitFrame`.
* `HideDebuff`: Hide debuffs on the Target (Default: Enabled).
* `HideCombatText`: Hide combat text on the Player frame (Default: Enabled).
* `HideCastBar`: Hide the Target's cast bar (Default: Enabled).
* `HideClassBar`: Hide the Player's class bar (Default: Enabled).
* `HideTotemBar`: Hide the Player's totem bar (Default: Disabled).
* `ShowClassColor`: Change health bar colors to class colors (Default: Enabled).
* `ShowAggro`: Display numeric threat level on the Target (Default: Enabled).

---

# asFixUnitFrame (한밤)

블리자드 기본 유닛 프레임(플레이어, 대상, 대상의 대상) 기능 추가
![asFixUnitFrame](https://github.com/aspilla/asMOD/blob/main/.Pictures/asFixUnitFrame.png?raw=true)
![asFixUnitFrame2](https://github.com/aspilla/asMOD/blob/main/.Pictures/asFixUnitFrame2.png?raw=true)

## 주요 기능

*   **선택적 유닛 프레임 수정 (애드온 설정을 통해 구성 가능)**:
    *   **프레임 위 전투 텍스트 숨기기**: 플레이어, 대상 및 소환수 유닛 프레임에 블리자드 기본 전투 상황 알림 텍스트가 직접 나타나지 않도록 함.
    *   **대상의 버프/디버프 숨기기**: 대상 유닛 프레임에서 표준 버프 및 디버프 아이콘을 제거.
    *   **대상의 시전바 숨기기**: 대상 유닛 프레임의 시전바를 숨김.
    *   **플레이어 직업 바 숨기기**: 특수 직업 자원 표시(예: 도적 연계 점수, 죽음의 기사 룬, 기원사 정수)를 숨김.
    *   **플레이어 토템 바 숨기기 (기본 : 해제)**: 주술사 토템 바, 흑마법사 불지옥 정령 바 숨김. 
    *   **숫자 위협 수준 표시**: 대상 위협 수준 표시를 활성화 (`threatShowNumeric` CVar 설정).
    *   **직업 색상 생명력 바**: 플레이어, 대상 및 대상의 대상 프레임의 생명력 바를 직업(플레이어인 경우) 색상으로 변경.

## 설정

*   `ESC` > `설정` > `애드온` > `asFixUnitFrame`  옵션을 변경 가능.
*   `HideDebuff` : 대상의 디버프 숨김 (기본: 활성).
*   `HideCombatText` : 플레이어 전투 텍스트 숨김 (기본: 활성).
*   `HideCastBar` : 대상의 사진바 숨김 (기본: 활성).
*   `HideClassBar` : 플에이어 직업바 숨김 (기본: 활성).
*   `HideTotemBar` : 플레이어 토템바 숨김 (기본: 비활성).
*   `ShowClassColor` : 생명력 색상을 직업 색상으로 (기본: 활성).
*   `ShowAggro` : 대상위 위협수준 표시 (기본: 활성).
