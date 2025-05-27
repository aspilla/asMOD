# asSpamFilter

asSpamFilter is a World of Warcraft addon designed to reduce the visual clutter from repetitive UI error messages. It achieves this by completely hiding certain common errors and "throttling" others, preventing the same message from spamming your screen multiple times in quick succession.

## Main Features

*   **Custom Error Frame**: Replaces the default Blizzard UI error frame with its own, allowing it to intercept and filter messages.
*   **Message Blacklisting**:
    *   Completely suppresses a predefined list of common spammy errors, such as:
        *   "Ability is not ready yet" (`LE_GAME_ERR_ABILITY_COOLDOWN`)
        *   "Spell is not ready yet" (`LE_GAME_ERR_SPELL_COOLDOWN`)
        *   "Not enough mana/energy/rage/etc." (various `LE_GAME_ERR_OUT_OF_*` types)
        *   "Out of range" (`LE_GAME_ERR_OUT_OF_RANGE`) - *Note: This is in the blacklist, meaning it's hidden entirely, not just throttled by default.*
*   **Message Throttling**:
    *   For another list of common errors (e.g., "Item is not ready yet", "Another action is in progress", "You are in shapeshift form"), if the exact same error message for the same error type occurs again while it's still visible:
        *   The new, duplicate message is not displayed.
        *   Instead, the existing message on screen will "flash" (briefly change color) to indicate a repeat occurrence, if the CVar `flashErrorMessageRepeats` is enabled in WoW's interface options.
        *   The fade-out timer for the existing message is reset.
*   **Customizable Position**: The position of the error message frame can be adjusted. If the `asMOD` addon is installed, it can be managed through `asMOD`'s frame positioning system.

## How it Works

1.  The addon defines its own UI message frame (`asUIErrorsFrame`).
2.  It intercepts all UI error messages before they reach the default error frame.
3.  It checks the `messageType` of each error against two internal lists:
    *   **`BLACK_LISTED_MESSAGE_TYPES`**: If the error type is in this list, the message is completely ignored.
    *   **`THROTTLED_MESSAGE_TYPES`**: If the error type is in this list, the addon checks if the exact same message string for that type is already displayed.
        *   If yes, the new message is suppressed, and the existing one flashes/re-fades.
        *   If no (it's a new message string or a new type of throttled error), it's allowed to display.
4.  Allowed messages are shown in the `asUIErrorsFrame`.

## Configuration

*   **Frame Position**:
    *   Default X and Y offsets for the error frame can be set by editing `ASF_X` and `ASF_Y` at the top of `asSpamFilter/asSpamFilter.lua`.
    *   If `asMOD` is installed, the frame "asSpamFilter" can be moved and its position saved using `asMOD`'s interface.
*   **Flash Behavior**: The "flash" effect for throttled messages depends on the Blizzard CVar `flashErrorMessageRepeats`. This can be toggled in the standard WoW Interface Options (usually under Display or Combat).
*   **Filtered Messages**: Advanced users can modify the `BLACK_LISTED_MESSAGE_TYPES` and `THROTTLED_MESSAGE_TYPES` tables in `asSpamFilter.lua` to customize which messages are hidden or throttled.

**Note**: The variable `ASF_MaxTime` is defined in the Lua file but is not currently used by the addon's logic. The throttling is based on identical message content, not a time window.

---

# asSpamFilter

asSpamFilter는 반복적인 UI 오류 메시지로 인한 화면 혼잡을 줄이기 위해 설계된 월드 오브 워크래프트 애드온입니다. 특정 일반적인 오류를 완전히 숨기거나 다른 오류들을 "조절"하여 동일한 메시지가 짧은 시간 내에 여러 번 화면에 도배되는 것을 방지합니다.

## 주요 기능

*   **사용자 지정 오류 프레임**: 기본 블리자드 UI 오류 프레임을 자체 프레임으로 대체하여 메시지를 가로채고 필터링할 수 있도록 합니다.
*   **메시지 블랙리스트**:
    *   다음과 같이 미리 정의된 일반적인 스팸성 오류 목록을 완전히 억제합니다:
        *   "능력을 아직 사용할 수 없습니다" (`LE_GAME_ERR_ABILITY_COOLDOWN`)
        *   "주문을 아직 사용할 수 없습니다" (`LE_GAME_ERR_SPELL_COOLDOWN`)
        *   "마나/기력/분노 등이 부족합니다" (다양한 `LE_GAME_ERR_OUT_OF_*` 유형)
        *   "사정거리를 벗어났습니다" (`LE_GAME_ERR_OUT_OF_RANGE`) - *참고: 이 항목은 블랙리스트에 있어 기본적으로 조절되는 것이 아니라 완전히 숨겨집니다.*
*   **메시지 조절**:
    *   다른 일반적인 오류 목록(예: "아이템을 아직 사용할 수 없습니다", "다른 작업이 진행 중입니다", "변신 상태입니다")의 경우, 동일한 오류 유형에 대해 정확히 동일한 오류 메시지가 아직 화면에 표시되는 동안 다시 발생하면:
        *   새로운 중복 메시지는 표시되지 않습니다.
        *   대신, 화면의 기존 메시지가 WoW 인터페이스 옵션에서 `flashErrorMessageRepeats` CVar가 활성화된 경우 반복 발생을 나타내기 위해 "깜빡입니다"(잠시 색상 변경).
        *   기존 메시지의 사라짐 타이머가 재설정됩니다.
*   **사용자 정의 가능한 위치**: 오류 메시지 프레임의 위치를 조정할 수 있습니다. `asMOD` 애드온이 설치된 경우, `asMOD`의 프레임 위치 지정 시스템을 통해 관리할 수 있습니다.

## 작동 방식

1.  애드온은 자체 UI 메시지 프레임(`asUIErrorsFrame`)을 정의합니다.
2.  모든 UI 오류 메시지가 기본 오류 프레임에 도달하기 전에 가로챕니다.
3.  각 오류의 `messageType`을 두 개의 내부 목록과 대조하여 확인합니다:
    *   **`BLACK_LISTED_MESSAGE_TYPES`**: 오류 유형이 이 목록에 있으면 메시지가 완전히 무시됩니다.
    *   **`THROTTLED_MESSAGE_TYPES`**: 오류 유형이 이 목록에 있으면 애드온은 해당 유형에 대해 정확히 동일한 메시지 문자열이 이미 표시되어 있는지 확인합니다.
        *   그렇다면 새 메시지는 억제되고 기존 메시지는 깜빡이거나 다시 사라지기 시작합니다.
        *   그렇지 않다면 (새로운 메시지 문자열이거나 새로운 유형의 조절된 오류인 경우) 표시되도록 허용됩니다.
4.  허용된 메시지는 `asUIErrorsFrame`에 표시됩니다.

## 설정

*   **프레임 위치**:
    *   오류 프레임의 기본 X 및 Y 오프셋은 `asSpamFilter/asSpamFilter.lua` 파일 상단의 `ASF_X` 및 `ASF_Y`를 편집하여 설정할 수 있습니다.
    *   `asMOD`가 설치된 경우, "asSpamFilter" 프레임은 `asMOD`의 인터페이스를 사용하여 이동하고 위치를 저장할 수 있습니다.
*   **깜빡임 동작**: 조절된 메시지에 대한 "깜빡임" 효과는 블리자드 CVar `flashErrorMessageRepeats`에 따라 달라집니다. 이는 표준 WoW 인터페이스 옵션(일반적으로 표시 또는 전투 항목 아래)에서 토글할 수 있습니다.
*   **필터링된 메시지**: 고급 사용자는 `asSpamFilter.lua`의 `BLACK_LISTED_MESSAGE_TYPES` 및 `THROTTLED_MESSAGE_TYPES` 테이블을 수정하여 어떤 메시지를 숨기거나 조절할지 사용자 정의할 수 있습니다.

**참고**: `ASF_MaxTime` 변수는 Lua 파일에 정의되어 있지만 현재 애드온의 로직에서는 사용되지 않습니다. 조절은 시간 창이 아닌 동일한 메시지 내용을 기반으로 합니다.
