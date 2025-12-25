# asMisdirection

Automatically creates macros for Misdirection, Tricks of the Trade, Cauterizing Flame, Power Infusion, and Assist to support appropriate party members.
![sample](https://github.com/aspilla/asMOD/blob/main/.Pictures/asMisdirection_2.JPG?raw=true)
<iframe width="560" height="315" src="https://www.youtube.com/embed/E8RZsSN4Cvw?si=B844A-nqeUjtroNt" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" referrerpolicy="strict-origin-when-cross-origin" allowfullscreen></iframe>

## Key Features

*   **Automatic Macro Creation/Update**:
    *   **Assist Macro**: Creates a macro named `as_Assist Tanker` (or `as_탱커지원` in Korean client) to assist the tank/target.
    *   **Tank Support Macro**: For Hunter [`Misdirection`], Rogue [`Tricks of the Trade`], or Evoker [`Cauterizing Flame`], creates a macro (name: `as_SpellName`) that automatically casts on the tank in the party.
    *   **Damage Dealer Support Macro**: For Priest [`Power Infusion`], creates a macro `as_Power Infusion` that casts on an allied damage dealer (first DPS) or a manually set target.
    *   **Macro Creation Location**: Class skills (`Misdirection`, etc.) are created in the character-specific macro slot first, while assist macros are created in the general macro slot.

*   **Targeting Method**:
    *   **Automatic Tank Detection**: When in a party or raid, the addon automatically identifies players with the Tank role. If no tank is found, the pet is used as default.
    *   **Automatic DPS Detection (for Power Infusion)**: For Priests, finds a DPS role in the group to set as the default target for Power Infusion. If none, defaults to the player.
    *   **Manual Targeting using `/afm`**:
        *   Target an allied player in the group and type `/afm`.
        *   Using `/afm` again on the currently manually set target clears the manual override and reverts to automatic assignment.
    *   **Priority**: Manual Target > Auto Detected Role > Default (Pet/Player).

*   **Cannot be changed during combat**

## Supported Abilities

*   **General**: `/assist`
*   **Hunter**: Misdirection
*   **Rogue**: Tricks of the Trade
*   **Evoker**: Cauterizing Flame
*   **Priest**: Power Infusion

## Usage

1.  **Using Macros**: Use the macros created by this addon (e.g., `as_Assist Tanker`, `as_Misdirection`, `as_Power Infusion`) from the macro interface (accessible via `/m`).

## Notes

*   When macros are updated, it attempts to preserve any custom lines the user may have added *after* the default `/cast` line for that spell.
!sample

---

# asMisdirection 

눈속임, 속임수 거래, 소작의 불길, 마력 주입, 지원 매크로를 적정 파티원 대상을 지원하도록 자동 생성
![sample](https://github.com/aspilla/asMOD/blob/main/.Pictures/asMisdirection_2.JPG?raw=true)
<iframe width="560" height="315" src="https://www.youtube.com/embed/E8RZsSN4Cvw?si=B844A-nqeUjtroNt" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" referrerpolicy="strict-origin-when-cross-origin" allowfullscreen></iframe>

## 주요 기능

*   **자동 매크로 생성/업데이트**:
    *   **지원 매크로**: 탱커/대상을 지원하는 `as_탱커지원` (영문 클라이언트의 경우 `as_Assist Tanker`)이라는 이름의 매크로를 생성
    *   **탱커 지원 매크로**: 사냥꾼[`눈속임`], 도적[`속임수 거래`], 또는 기원사[`소작의 불길`]인 경우, 매크로(명칭: `as_스킬명`)를 생성, 이 메크로는 파티내 탱커에게 자동으로 시전하도록 변경됨.
    *   **딜러 지원 매크로**: 사제[`마력 주입`] 가지고 있는 경우, 아군 데미지 딜러(첫번째 딜러) 또는 수동으로 설정된 대상에게 시전하는 `as_마력 주입` 매크로를 생성.
    *   **매크로 생성 위치**: 직업 스킬(`눈속임`등)은 케릭별 매크로 칸에 우선적으로 생성, 지원 매크로는 공용 매크로칸에 생성

*   **대상 지정 방식**:
    *   **자동 탱커 감지**: 파티 또는 공격대에 있을 때, 애드온은 탱커 역할을 가진 플레이어를 자동으로 식별, 탱커를 찾을 수 없는 경우 소환수를 기본값으로 함.
    *   **자동 딜러 감지 (마력 주입용)**: 사제의 경우, 그룹 내에서 딜러 역할을 찾아 마력 주입의 기본 대상으로 지정. 없는 경우 플레이어를 기본값으로 함.
    *   **`/afm`을 사용한 수동 대상 지정**:
        *   그룹 내의 아군 플레이어를 대상으로 지정하고 `/afm`을 입력. 
        *   현재 수동으로 설정된 대상에게 다시 `/afm`을 사용하면 수동 재정의가 해제되고 자동 지정함.
    *   **우선순위**: 수동 설정 대상 > 자동 감지 역할 > 기본값 (소환수/플레이어).

*   **전투 중 변경불가**

## 지원되는 능력

*   **일반**: `/assist` (지원)
*   **사냥꾼**: 눈속임 
*   **도적**: 속임수 거래 
*   **기원사**: 소작의 불길 
*   **사제**: 마력 주입 

## 사용 방법

1.  **매크로 사용**: 이 애드온으로 생성된 매크로(예: `as_탱커지원`, `as_눈속임`, `as_마력 주입`)를 매크로 인터페이스(`/m`으로 접근)에서 사용.
   

## 참고 사항

*   매크로가 업데이트될 때, 해당 주문에 대한 기본 `/cast` 줄 *뒤에* 사용자가 추가했을 수 있는 사용자 지정 줄을 유지하려고 시도합니다.
![sample](https://github.com/aspilla/asMOD/blob/main/.Pictures/asMisdirection.jpg?raw=true)