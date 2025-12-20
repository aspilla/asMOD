# asMOD Addon (Mid Night)

asMOD optimizes default WoW settings and Edit Mode layouts to provide an ideal environment for using other asMOD addons. It also provides a centralized configuration tool to manage the positions of various UI elements.

## Key Features

1. **Automatic Optimization Settings (`/asMOD`)**
    * Upon initial load or by using the `/asMOD` command, a popup appears. Selecting `Set` applies optimized settings.
    * **UI Scale Adjustment**: Automatically sets the optimal UI scale (default: 0.75).
    * **Game Setting Optimization**:
        * Enables "Show Cooldown Numbers."
        * Adjusts "Spell Alert Opacity."
        * Enables "Combat Text" for healing and damage.
        * Configures Nameplates (Always show enemies, hide allies, etc.).
        * Disables the "Personal Resource Display."
        * Enables "Class Colors" in raid frames.
        * Enables "Target of Target."
        * Enables "Class Colors" in chat (Say, Emote, Yell, Guild, Party, Raid, etc.).
    * **Automatic "asMOD Setup" Macro Creation**:
        * Automatically creates or updates a macro containing useful settings such as World Text size and camera rotation speed.
        * You can check this macro via the `/m` command. It must be moved to an action bar to be used.
    * **Default UI Layout Automation**:
        * Automatically imports and applies a predefined Edit Mode layout named "asMOD_layout."
        * When switching talents, you may need to manually select "asMOD_layout" from ESC > Edit Mode.
    * **BugSack**: Optimizes settings for the BugSack error management addon.

2. **UI Positioning Tool (`/asConfig`)**
    * Enter the `/asConfig` command to open a configuration window that allows you to drag and reposition UI elements managed by asMOD (or registered by other addons).
    * Each frame displays its name and current coordinates.
    * Clicking "Done" saves the positions and reloads the UI. Clicking "Cancel" reverts the changes.

3. **Reset UI Positions (`/asClear`)**
    * Enter the `/asClear` command to trigger a popup asking if you want to reset all UI positions saved via `/asConfig` to their default values.
    * Clicking "Change" resets the position settings and reloads the UI.

---

# asMOD 애드온 (한밤)

asMOD는 다른 asMOD 애드온들을 최적화 해서 사용할 수 있도록 와우 기본 설정 및 편집 모드 설정.
추가로 다른 asMOD 애드온의 위치를 설정할 수 있는 기능을 지원.

## 주요 기능

1.  **asMOD 최적화 설정 자동 적용 (`/asMOD`)**
    *   애드온 최초 로드 시 또는 `/asMOD` 명령어를 통해 최적화된 설정을 적용할지 묻는 팝업창에서 `설정` 선택.
    *   **UI 스케일 조정**: 최적의 UI 스케일(기본값 0.75)을 자동으로 설정.
    *   **게임 설정 최적화**:
        *   재사용 대기시간 표시 활성화
        *   주문 발동 시각 효과 투명도 조절
        *   전투 중 치유량 및 피해량 표시 활성화
        *   이름표 관련 설정 (적 대상 항상 표시, 아군 대상 숨김 등)
        *   개인 자원 바 비활성화
        *   공격대창 직업 색상 표시
        *   대상의 대상 표시 활성화
        *   채팅창에 직업 색상 표시 (일반, 감정표현, 외침, 길드, 파티, 공격대 등 다양한 채널)
    *   **"asMOD Setup" 매크로 자동 생성**:
        *   월드 텍스트 크기, 회전 속도 등 유용한 설정을 담은 매크로를 자동으로 생성하거나 업데이트합니다.
        *   /m 명령어로 매크로를 확인 할 수 있습니다. 매크로는 행동 단축바로 이동해야 사용 가능합니다.
    *   **기본 UI 레이아웃 자동 설정**:
        *   "asMOD_layout"이라는 이름으로 사전 정의된 UI 편집 모드 레이아웃을 자동으로 가져와 적용.
        *   특성 변경시 esc > 편집모드 에서 "asMOD_layout" 을 선택 필요.
    *   **BugSack**: 오류 메시지 관리 애드온의 설정을 최적화.

2.  **UI 위치 조정 기능 (`/asConfig`)**
    *   `/asConfig` 명령어를 입력하면, asMOD가 관리하는 (또는 다른 애드온에 의해 등록된) UI 요소들의 위치를 직접 드래그하여 조정할 수 있는 설정창이 나타남.
    *   각 프레임에는 이름과 좌표가 표시.
    *   위치 조정을 마친 후 "완료"를 누르면 현재 위치가 저장되고 UI가 리로드됨. "취소"를 누르면 변경사항이 저장되지 않음.

3.  **UI 위치 설정 초기화 (`/asClear`)**
    *   `/asClear` 명령어를 입력하면, `/asConfig`를 통해 저장된 모든 UI 위치 설정을 기본값으로 초기화할지 묻는 팝업창이 나타남.
    *   "변경"을 누르면 위치 설정이 초기화되고 UI가 리로드됨.