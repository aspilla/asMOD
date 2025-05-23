# asBattleRes

`asBattleRes` is a World of Warcraft addon that displays the number of available charges and cooldown of a specific battle resurrection spell.

![asBattleRes](https://github.com/aspilla/asMOD/blob/main/.Pictures/asbattleres.jpg?raw=true)

## Main Features

*   **Battle Resurrection Spell Tracking**: Clearly displays the icon, current available charges, and remaining cooldown time (if on cooldown) of the battle resurrection spell.
*   **Movable Frame**: Users can freely drag and drop the battle resurrection information frame to their desired position on the interface. The changed position is automatically saved.
*   **Frame Lock**: The `LockWindow` option allows users to lock the frame's position or make it movable.
*   **Contextual Auto Show/Hide**:
    *   Always shown when in a party or raid.
    *   Shown for position adjustment even when not in a group, if the frame is unlocked.
    *   Automatically hidden when not in a group and the frame is locked.
*   **Settings Menu Support**: If the `asMOD` addon is installed, `asBattleRes` options can be easily changed through the in-game addon settings menu.

## How to Use

1.  **Changing Frame Position**:
    *   Ensure the 'LockWindow' option is unchecked in the settings menu (default: unchecked).
    *   Click and drag the frame with the left mouse button to the desired position.
    *   Release the mouse button to automatically save the position.
2.  **Locking Frame Position**:
    *   Check the 'LockWindow' option in the settings menu.
3.  **Changing Settings**:
    *   If `asMOD` is installed, go to `ESC` > `Settings` > `AddOns` tab, find `asBattleRes`, and change the options.

## Note (In-code Settings)

You can directly modify the following values at the top of the `asBattleRes.lua` file to change the default behavior:

*   `ASBR_Spell`: ID of the battle resurrection spell to track (default: `20484` - Druid 'Rebirth')
*   `ASBR_SIZE`: Default size of the frame (default: `40`)
*   `ASBR_CoolButtons_X`, `ASBR_CoolButtons_Y`: Initial X and Y coordinates of the frame (default: `350`, `-400`)
*   `ASBR_Alpha`: Opacity of the icon (default: `0.9`)
*   `ASBR_CooldownFontSize`: Font size of the cooldown text (default: `11`)

---

# asBattleRes 

`asBattleRes`는 월드 오브 워크래프트 애드온으로, 특정 전투 부활 주문의 사용 가능 횟수와 재사용 대기시간을 화면에 표시해주는 기능을 제공합니다. 

![asBattleRes](https://github.com/aspilla/asMOD/blob/main/.Pictures/asbattleres.jpg?raw=true)

## 주요 기능

*   **전투 부활 주문 추적**: 전투 부활 주문의 아이콘, 현재 사용 가능한 충전 횟수, 그리고 재사용 대기 중일 경우 남은 시간을 명확하게 표시합니다.
*   **이동 가능한 프레임**: 사용자는 인터페이스에서 전투 부활 정보 프레임의 위치를 원하는 곳으로 자유롭게 드래그하여 옮길 수 있습니다. 변경된 위치는 자동으로 저장됩니다.
*   **프레임 위치 잠금**: `LockWindow` 옵션을 통해 프레임의 위치를 고정하거나 이동 가능하도록 설정할 수 있습니다.
*   **상황별 자동 표시/숨김**:
    *   파티 또는 공격대에 속해 있을 경우 항상 표시됩니다.
    *   그룹에 속해 있지 않더라도, 프레임 잠금이 해제되어 있으면 위치 조정을 위해 표시됩니다.
    *   그룹에 속해 있지 않고 프레임이 잠겨 있으면 자동으로 숨겨집니다.
*   **설정 메뉴 지원**: `asMOD` 애드온이 설치되어 있는 경우, 게임 내 애드온 설정 메뉴를 통해 `asBattleRes`의 옵션을 쉽게 변경할 수 있습니다.

## 사용 방법

1.  **프레임 위치 변경**:
    *   설정 메뉴에서 'LockWindow' 옵션이 체크 해제되어 있는지 확인합니다. (기본값: 해제)
    *   프레임을 마우스 왼쪽 버튼으로 클릭한 상태로 드래그하여 원하는 위치로 옮깁니다.
    *   마우스 버튼에서 손을 떼면 해당 위치가 자동으로 저장됩니다.
2.  **프레임 위치 고정**:
    *   설정 메뉴에서 'LockWindow' 옵션을 체크합니다.
3.  **설정 변경**:
    *   `asMOD` 애드온이 설치된 경우, `ESC` > `설정` > `애드온` 탭에서 `asBattleRes`를 찾아 옵션을 변경할 수 있습니다.

## 참고 (코드 내 설정값)

`asBattleRes.lua` 파일 상단에서 다음 값들을 직접 수정하여 기본 동작을 변경할 수 있습니다:

*   `ASBR_Spell`: 추적할 전투 부활 주문의 ID (기본값: `20484` - 드루이드 '환생')
*   `ASBR_SIZE`: 프레임의 기본 크기 (기본값: `40`)
*   `ASBR_CoolButtons_X`, `ASBR_CoolButtons_Y`: 프레임의 초기 X, Y 좌표 (기본값: `350`, `-400`)
*   `ASBR_Alpha`: 아이콘의 투명도 (기본값: `0.9`)
*   `ASBR_CooldownFontSize`: 재사용 대기시간 텍스트의 폰트 크기 (기본값: `11`)