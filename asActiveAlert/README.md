# asActiveAlert

asActiveAlert is a World of Warcraft addon that visually notifies you by displaying a spell's icon to the left of your character when a player's spell becomes active or meets special conditions (e.g., a proc effect, indicated by a glowing border on the action bar). The displayed icon also shows the remaining cooldown.

![asActiveAlert](https://github.com/aspilla/asMOD/blob/main/.Pictures/asActiveAlert.png?raw=true)

## Main Features

1.  **Active Spell Notifications**:
    *   When a spell becomes usable or is highlighted due to a specific effect (e.g., the icon glows in-game), its icon is displayed on the screen in a separate bar.
    *   This helps you not to miss the window of opportunity for important spells.

2.  **Cooldown Display**:
    *   Displays the remaining cooldown as a number on the activated spell icon.

3.  **Automatic List Management**:
    *   Spells are automatically added to the list when they become active and removed when their active state ends.
    *   The list is reset when the player enters the world or changes talent specializations.

4.  **Icon Customization (via modifying variables in the source code)**:
    *   Icon size (`ASAA_SIZE`)
    *   Default position of the icon bar (`ASAA_CoolButtons_X`, `ASAA_CoolButtons_Y`)
    *   Icon transparency (`ASAA_Alpha`)
    *   Cooldown text font size (`ASAA_CooldownFontSize`)
    *   *Note: These settings currently do not have an in-game configuration menu and require direct modification of the variable values at the top of the `asActiveAlert.lua` file.*

5.  **Filtering Features**:
    *   **Blacklist (`ASAA_BackList`)**: You can add specific spell IDs to this list to exclude them from notifications (e.g., `[115356] = true, --Enhancement Shaman Windstrike`).
    *   Only displays spells learned by the player.
    *   Attempts to avoid duplicate displays for spells already managed by other asMOD series addons (like asCooldownIcon, asProcBar, etc.).

6.  **asMOD Addon Integration**:
    *   If the `asMOD` addon is installed, it allows users to move and save the position of asActiveAlert's icon bar using `asMOD`'s `/asConfig` command.

---

# asActiveAlert

asActiveAlert는 플레이어의 주문이 활성화되거나 특별한 조건(예: 발동 효과)을 만족했을 때 (스킬바에 빤찍이는 테두리가 표시 될 경우) 해당 주문의 아이콘을 케릭 좌측 표시하여 시각적으로 알려주는 애드온입니다. 표시된 아이콘에는 재사용 대기시간도 함께 표시됩니다.

![asActiveAlert](https://github.com/aspilla/asMOD/blob/main/.Pictures/asActiveAlert.png?raw=true)

## 주요 기능

1.  **활성화 주문 알림**:
    *   주문이 사용 가능해지거나 특정 효과로 인해 강조될 때 (게임 내에서 아이콘 테두리에 빛나는 효과가 나타나는 경우) 해당 주문의 아이콘을 별도의 바(Bar) 형태로 화면에 표시합니다.
    *   이를 통해 중요한 주문의 사용 가능 시점을 놓치지 않도록 도와줍니다.

2.  **재사용 대기시간 표시**:
    *   표시된 활성화 주문 아이콘 위에 남은 재사용 대기시간을 숫자로 표시합니다.

3.  **자동 목록 관리**:
    *   주문이 활성화되면 목록에 자동으로 추가되고, 활성화 상태가 해제되면 목록에서 자동으로 제거됩니다.
    *   플레이어가 월드에 접속하거나 특성 그룹을 변경할 때 목록이 초기화됩니다.

4.  **아이콘 커스터마이징 (소스 코드 내 변수 수정)**:
    *   아이콘의 크기 (`ASAA_SIZE`)
    *   아이콘 바의 기본 위치 (`ASAA_CoolButtons_X`, `ASAA_CoolButtons_Y`)
    *   아이콘의 투명도 (`ASAA_Alpha`)
    *   재사용 대기시간 폰트 크기 (`ASAA_CooldownFontSize`)
    *   *참고: 이 설정들은 현재 게임 내 설정 메뉴를 제공하지 않으며, `asActiveAlert.lua` 파일 상단의 변수 값을 직접 수정해야 합니다.*

5.  **필터링 기능**:
    *   **블랙리스트 (`ASAA_BackList`)**: 특정 주문 ID를 이 목록에 추가하여 알림에서 제외할 수 있습니다. (예: `[115356] = true, --고술 바람의 일격`)
    *   플레이어가 배운 주문만 표시합니다.
    *   다른 asMOD 계열 애드온(asCooldownIcon, asProcBar 등)에서 이미 관리 중인 주문은 중복으로 표시하지 않으려고 시도합니다.

6.  **asMOD 애드온 연동**:
    *   `asMOD` 애드온이 설치되어 있는 경우, asActiveAlert의 아이콘 바 위치를 `asMOD`의 `/asConfig` 명령어를 통해 사용자가 직접 이동하고 저장할 수 있도록 지원합니다.