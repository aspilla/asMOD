# asMOD Addon (Midnight)

asMOD optimizes default World of Warcraft settings and Edit Mode configurations to work seamlessly with other asMOD addons. 
Additionally, it provides a feature to customize the positions of various asMOD UI elements.

## Key Features

1. **Automatic Optimization Settings (`/asMOD`)**
    * Upon initial loading or by using the `/asMOD` command, a popup will ask whether to apply optimized settings. Select `Set` to proceed.
    * **UI Scale Adjustment**: Sets the UI scale to 0.75.
    * **Game Setting Optimization**: Applies various game performance and interface optimizations.
    * **Automatic "asMOD Setup" Macro Creation**:
        * Generates useful settings such as world text size and camera rotation speed.
        * You can check the created macro via the `/m` command. The macro must be moved to an action bar to be used.
    * **Default UI Layout Auto-Configuration**:
        * Automatically imports and applies a predefined Edit Mode layout named "asMOD_layout".
        * When changing specializations, you may need to manually select "asMOD_layout" from `ESC > Edit Mode`.

2. **UI Positioning Feature (`/asConfig`)**
    * Enter the `/asConfig` command to open a configuration window where you can drag and reposition UI elements managed by asMOD (or registered by other addons).
    * Each frame displays its name and current coordinates.
    * Clicking "Done" saves the current positions and reloads the UI. Clicking "Cancel" reverts all changes made during the session.

3. **Reset UI Positions (`/asClear`)**
    * Enter the `/asClear` command to trigger a popup asking whether to reset all UI positions saved via `/asConfig` to their default values.
    * Clicking "Change" will reset the position settings and reload the UI.

---

# asMOD 애드온 (한밤)

asMOD는 다른 asMOD 애드온들을 최적화 해서 사용할 수 있도록 와우 기본 설정 및 편집 모드 설정.
추가로 다른 asMOD 애드온의 위치를 설정할 수 있는 기능을 지원.

## 주요 기능

1.  **asMOD 최적화 설정 자동 적용 (`/asMOD`)**
    *   애드온 최초 로드 시 또는 `/asMOD` 명령어를 통해 최적화된 설정을 적용할지 묻는 팝업창에서 `설정` 선택.
    *   **UI 스케일 조정**: UI 스케일을 0.75로 설정.
    *   **게임 설정 최적화**:
    *   **"asMOD Setup" 매크로 자동 생성**:
        *   월드 텍스트 크기, 회전 속도 등 유용한 설정.
        *   /m 명령어로 매크로를 확인 할 수 있습니다. 매크로는 행동 단축바로 이동해야 사용 가능.
    *   **기본 UI 레이아웃 자동 설정**:
        *   "asMOD_layout"이라는 이름으로 사전 정의된 UI 편집 모드 레이아웃을 자동으로 가져와 적용.
        *   특성 변경시 esc > 편집모드 에서 "asMOD_layout" 을 선택 필요.
    
2.  **UI 위치 조정 기능 (`/asConfig`)**
    *   `/asConfig` 명령어를 입력하면, asMOD가 관리하는 (또는 다른 애드온에 의해 등록된) UI 요소들의 위치를 직접 드래그하여 조정할 수 있는 설정창이 나타남.
    *   각 프레임에는 이름과 좌표가 표시.
    *   위치 조정을 마친 후 "완료"를 누르면 현재 위치가 저장되고 UI가 리로드됨. "취소"를 누르면 변경사항이 저장되지 않음.

3.  **UI 위치 설정 초기화 (`/asClear`)**
    *   `/asClear` 명령어를 입력하면, `/asConfig`를 통해 저장된 모든 UI 위치 설정을 기본값으로 초기화할지 묻는 팝업창이 나타남.
    *   "변경"을 누르면 위치 설정이 초기화되고 UI가 리로드됨.