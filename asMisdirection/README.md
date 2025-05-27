# asMisdirection (and Assist/Power Infusion Helper)

asMisdirection is a World of Warcraft addon that automates the creation and management of macros for threat redirection abilities (like Hunter's Misdirection, Rogue's Tricks of the Trade, Evoker's Cauterizing Flame), Priest's Power Infusion, and a general `/assist` macro. It dynamically updates these macros to target the current tank or a manually specified friendly player.

## Main Features

*   **Automatic Macro Creation/Update**:
    *   **Assist Macro**: Creates a macro named "Assist Tanker" (or "탱커지원" in Korean) that assists the determined tank/target.
    *   **Threat Redirection Macro**: If you are a Hunter (Misdirection), Rogue (Tricks of the Trade), or Evoker (Cauterizing Flame), it creates a macro named after your respective ability. This macro will cast the spell on the determined tank/target.
    *   **Power Infusion Macro**: If you are a Priest with Power Infusion, it creates a "Power Infusion" macro to cast it on a determined friendly damage dealer or a manually set target.
    *   The macros are designed to preserve any additional lines you might have added manually after the main `/cast` command.

*   **Dynamic Targeting**:
    *   **Automatic Tank Detection**: When in a party or raid, the addon attempts to automatically identify a player with the "TANK" role and sets them as the target for the "Assist" and threat redirection macros. If no tank is found, it defaults to your pet.
    *   **Automatic Damage Dealer Detection (for Power Infusion)**: For Priests, it attempts to find a "DAMAGER" role in the group (other than yourself) as the default Power Infusion target. If none, it defaults to the player.
    *   **Manual Override with `/afm`**:
        *   Target a friendly player in your group and type `/afm`. This player will become the designated target for all managed macros.
        *   Using `/afm` again on the same manually set target will clear the manual override, reverting to automatic role detection.
    *   **Priority**: Manually set target > Automatically detected role > Default (pet/player).

*   **Combat Safety**: Macro target updates due to group changes are deferred until you leave combat. The `/afm` command also respects combat lockdown.
*   **Chat Feedback**: Provides messages in chat when macro targets are set or updated.

## Supported Abilities

*   **General**: `/assist`
*   **Hunters**: Misdirection
*   **Rogues**: Tricks of the Trade (macro will be named "Tricks of the Trade")
*   **Evokers**: Cauterizing Flame (macro will be named "Cauterizing Flame")
*   **Priests**: Power Infusion

## How to Use

1.  **Automatic Setup**: The addon will automatically detect your class and relevant spells upon login. It will create or update the necessary macros.
2.  **Macro Usage**: Use the macros created by this addon (e.g., "Assist Tanker", "Misdirection", "Power Infusion") from your macro interface (access via `/m`).
3.  **Changing Target Manually**:
    *   To set a specific player as the target for all macros, target them and type `/afm`.
    *   To clear a manually set target and return to automatic detection, target the currently set player and type `/afm` again.
    *   The addon will print a confirmation message in chat.

## Notes

*   The addon identifies spells by their specific Spell IDs.
*   When a macro is updated, it attempts to keep any custom lines you might have added *after* the primary `/cast` line for that spell.
*   This addon simplifies managing these utility spells, especially in dynamic group content.

---

# asMisdirection (및 지원/마력 주입 도우미)

asMisdirection은 위협 수준 전가 능력(사냥꾼의 눈속임, 도적의 속임수 거래, 기원사의 소작의 불길), 사제의 마력 주입, 그리고 일반적인 `/assist` (지원) 매크로의 생성 및 관리를 자동화하는 월드 오브 워크래프트 애드온입니다. 이 매크로들을 현재의 탱커 또는 수동으로 지정된 아군 플레이어를 대상으로 동적으로 업데이트합니다.

## 주요 기능

*   **자동 매크로 생성/업데이트**:
    *   **지원 매크로**: 결정된 탱커/대상을 지원하는 "탱커지원" (또는 영문 클라이언트의 경우 "Assist Tanker")이라는 이름의 매크로를 생성합니다.
    *   **위협 전가 매크로**: 사냥꾼(눈속임), 도적(속임수 거래), 또는 기원사(소작의 불길)인 경우, 각자의 능력 이름을 딴 매크로를 생성합니다. 이 매크로는 결정된 탱커/대상에게 주문을 시전합니다.
    *   **마력 주입 매크로**: 사제가 마력 주입을 가지고 있는 경우, 결정된 아군 데미지 딜러 또는 수동으로 설정된 대상에게 시전하는 "마력 주입" 매크로를 생성합니다.
    *   매크로는 주 `/cast` 명령 줄 뒤에 수동으로 추가했을 수 있는 추가 줄을 보존하도록 설계되었습니다.

*   **동적 대상 지정**:
    *   **자동 탱커 감지**: 파티 또는 공격대에 있을 때, 애드온은 "TANK" 역할을 가진 플레이어를 자동으로 식별하여 "지원" 및 위협 전가 매크로의 대상으로 설정하려고 시도합니다. 탱커를 찾을 수 없는 경우 소환수를 기본값으로 합니다.
    *   **자동 데미지 딜러 감지 (마력 주입용)**: 사제의 경우, 그룹 내에서 (자신을 제외한) "DAMAGER" 역할을 찾아 마력 주입의 기본 대상으로 삼으려고 시도합니다. 없는 경우 플레이어를 기본값으로 합니다.
    *   **`/afm`을 사용한 수동 재정의**:
        *   그룹 내의 아군 플레이어를 대상으로 지정하고 `/afm`을 입력하십시오. 이 플레이어는 관리되는 모든 매크로의 지정 대상이 됩니다.
        *   현재 수동으로 설정된 대상에게 다시 `/afm`을 사용하면 수동 재정의가 해제되고 자동 역할 감지로 돌아갑니다.
    *   **우선순위**: 수동 설정 대상 > 자동 감지 역할 > 기본값 (소환수/플레이어).

*   **전투 중 안전성**: 그룹 변경으로 인한 매크로 대상 업데이트는 전투에서 벗어날 때까지 지연됩니다. `/afm` 명령 또한 전투 중 잠금 상태를 존중합니다.
*   **채팅 피드백**: 매크로 대상이 설정되거나 업데이트될 때 채팅 창에 메시지를 표시합니다.

## 지원되는 능력

*   **일반**: `/assist` (지원)
*   **사냥꾼**: 눈속임 (Misdirection)
*   **도적**: 속임수 거래 (Tricks of the Trade) - 매크로 이름은 "속임수 거래"가 됩니다.
*   **기원사**: 소작의 불길 (Cauterizing Flame) - 매크로 이름은 "소작의 불길"이 됩니다.
*   **사제**: 마력 주입 (Power Infusion)

## 사용 방법

1.  **자동 설정**: 애드온은 로그인 시 자동으로 직업과 관련 주문을 감지합니다. 필요한 매크로를 생성하거나 업데이트합니다.
2.  **매크로 사용**: 이 애드온으로 생성된 매크로(예: "탱커지원", "눈속임", "마력 주입")를 매크로 인터페이스(`/m`으로 접근)에서 사용하십시오.
3.  **수동으로 대상 변경**:
    *   특정 플레이어를 모든 매크로의 대상으로 설정하려면, 해당 플레이어를 대상으로 지정하고 `/afm`을 입력하십시오.
    *   수동으로 설정된 대상을 해제하고 자동 감지로 돌아가려면, 현재 설정된 플레이어를 대상으로 지정하고 다시 `/afm`을 입력하십시오.
    *   애드온은 채팅 창에 확인 메시지를 출력합니다.

## 참고 사항

*   애드온은 특정 주문 ID로 주문을 식별합니다.
*   매크로가 업데이트될 때, 해당 주문에 대한 기본 `/cast` 줄 *뒤에* 사용자가 추가했을 수 있는 사용자 지정 줄을 유지하려고 시도합니다.
*   이 애드온은 특히 역동적인 그룹 콘텐츠에서 이러한 유틸리티 주문 관리를 단순화합니다.
