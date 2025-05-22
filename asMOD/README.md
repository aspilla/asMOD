# asMOD Addon

asMOD is an addon that handles basic WoW settings, Edit Mode settings, and default configurations for external addons like DBM, Details!, and BugSack to optimize the usage of other asMOD addons.
Additionally, it supports a feature to configure the positions of other asMOD addons.

## Main Features

1.  **Automatic Application of asMOD Optimization Settings (`/asMOD`)**
    *   A popup window appears on the first addon load or via the `/asMOD` command, asking whether to apply optimized settings.
    *   **UI Scale Adjustment**: Automatically sets the optimal UI scale (default 0.75).
    *   **Game Settings Optimization (can be changed in ESC > Options)**:
        *   Enable cooldown text display.
        *   Adjust spell activation overlay opacity.
        *   Enable display of healing and damage during combat.
        *   Nameplate settings (e.g., always show enemy targets, hide friendly targets).
        *   Disable personal resource bar.
        *   Display class colors in raid frames.
        *   Enable display of target of target.
        *   Display class colors in chat (various channels like Say, Emote, Yell, Guild, Party, Raid, etc.).
    *   **Automatic Creation of "asMOD Setup" Macro**:
        *   Automatically creates or updates a macro with useful settings like nameplate global and selected scale, world text scale, turn speed, etc.
        *   You can check the macro with the `/m` command. The macro needs to be moved to an action bar to be used.
    *   **Automatic Import of Default UI Layout**:
        *   Automatically imports and applies a predefined UI Edit Mode layout named "asMOD_layout".
        *   When changing specializations, please select "asMOD_layout" in ESC > Edit Mode.

2.  **Automatic Profile Setup for Major Addons**
    *   When applying `/asMOD` settings, profiles for the following addons are automatically configured (if installed):
        *   **BugSack**: Optimizes settings for the error message management addon.
        *   **DBM (Deadly Boss Mods)**: Automatically applies a predefined profile for detailed settings of the raid alert addon (DBM-Core and DBM-TimerBars).
        *   **Details!**: Imports a profile named "asMOD" for the damage meter addon. (Different profiles are applied based on Korean/English client).
    *   The UI automatically reloads after settings are applied.

3.  **UI Position Adjustment Feature (`/asConfig`)**
    *   Entering the `/asConfig` command opens a configuration window where you can drag and adjust the positions of UI elements managed by asMOD (or registered by other addons).
    *   Each frame displays its name and coordinates.
    *   After adjusting positions, click "Save" (or "완료" in Korean) to save the current positions and reload the UI. Click "Cancel" to discard changes.

4.  **UI Position Settings Reset (`/asClear`)**
    *   Entering the `/asClear` command brings up a popup asking whether to reset all UI position settings saved via `/asConfig` to their default values.
    *   Click "Confirm" (or "변경" in Korean) to reset position settings and reload the UI.

---

# asMOD 애드온

asMOD는 다른 asMOD 애드온들을 최적화 해서 사용할 수 있도록 와우 기본 설정 및 편집 모드 설정, DBM/Details/Bugsack 등 외부 애드온 기본 설정을 담당합니다.
추가로 다른 asMOD 애드온의 위치를 설정할 수 있는 기능을 지원 합니다.

## 주요 기능

1.  **asMOD 최적화 설정 자동 적용 (`/asMOD`)**
    *   애드온 최초 로드 시 또는 `/asMOD` 명령어를 통해 최적화된 설정을 적용할지 묻는 팝업창이 나타납니다.
    *   **UI 스케일 조정**: 최적의 UI 스케일(기본값 0.75)을 자동으로 설정합니다.
    *   **게임 설정 최적화 (esc 설정에서 변경 가능합니다.)**:
        *   재사용 대기시간 표시 활성화
        *   주문 발동 시각 효과 투명도 조절
        *   전투 중 치유량 및 피해량 표시 활성화
        *   이름표 관련 설정 (적 대상 항상 표시, 아군 대상 숨김 등)
        *   개인 자원 바 비활성화
        *   공격대창 직업 색상 표시
        *   대상의 대상 표시 활성화
        *   채팅창에 직업 색상 표시 (일반, 감정표현, 외침, 길드, 파티, 공격대 등 다양한 채널)
    *   **"asMOD Setup" 매크로 자동 생성**:
        *   이름표 전역 및 선택 시 크기, 월드 텍스트 크기, 회전 속도 등 유용한 설정을 담은 매크로를 자동으로 생성하거나 업데이트합니다.
        *   /m 명령어로 매크로를 확인 할 수 있습니다. 매크로는 행동 단축바로 이동해야 사용 가능합니다.
    *   **기본 UI 레이아웃 자동 가져오기**:
        *   "asMOD_layout"이라는 이름으로 사전 정의된 UI 편집 모드 레이아웃을 자동으로 가져와 적용합니다.
        *   특성 변경시 esc > 편집모드 에서 "asMOD_layout" 을 선택 해 주세요.

2.  **주요 애드온 프로필 자동 설정**
    *   `/asMOD` 설정 적용 시 다음 애드온들의 프로필을 자동으로 설정합니다 (해당 애드온이 설치되어 있을 경우):
        *   **BugSack**: 오류 메시지 관리 애드온의 설정을 최적화합니다.
        *   **DBM (Deadly Boss Mods)**: 공격대 경보 애드온의 상세 설정을 미리 정의된 프로필로 자동 적용합니다. (DBM-Core 및 DBM-TimerBars)
        *   **Details!**: 데미지 미터기 애드온의 프로필을 "asMOD"라는 이름으로 가져옵니다. (한국어/영어 클라이언트에 따라 다른 프로필 적용)
    *   설정 적용 후 UI가 자동으로 리로드됩니다.

3.  **UI 위치 조정 기능 (`/asConfig`)**
    *   `/asConfig` 명령어를 입력하면, asMOD가 관리하는 (또는 다른 애드온에 의해 등록된) UI 요소들의 위치를 직접 드래그하여 조정할 수 있는 설정창이 나타납니다.
    *   각 프레임에는 이름과 좌표가 표시됩니다.
    *   위치 조정을 마친 후 "완료"를 누르면 현재 위치가 저장되고 UI가 리로드됩니다. "취소"를 누르면 변경사항이 저장되지 않습니다.

4.  **UI 위치 설정 초기화 (`/asClear`)**
    *   `/asClear` 명령어를 입력하면, `/asConfig`를 통해 저장된 모든 UI 위치 설정을 기본값으로 초기화할지 묻는 팝업창이 나타납니다.
    *   "변경"을 누르면 위치 설정이 초기화되고 UI가 리로드됩니다.