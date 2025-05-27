# asFixHotkey

asFixHotkey is a World of Warcraft addon that customizes the display of hotkey text on action buttons. It aims to provide a more compact and cleaner look by abbreviating long key names and offering an option to hide macro names on buttons.

## Main Features

*   **Abbreviated Hotkey Text**:
    *   Automatically shortens the text for keybindings displayed on action buttons.
    *   Examples of abbreviations:
        *   `Num Pad 1` becomes `1`
        *   `Middle Mouse` becomes `M3`
        *   `Mouse Button 4` becomes `M4`
        *   `Shift-R` becomes `SR`
        *   `Ctrl-Alt-Delete` becomes `CADt` (approximate, based on logic)
        *   Arrow keys are represented by symbols like `^`, `V`, `<`, `>`.
    *   Supports abbreviations for both English and Korean client key names.

*   **Optional Macro Name Hiding**:
    *   Includes a setting (`ASHK_ShowMacroName` in the Lua file) to control the visibility of macro names on action buttons.
    *   By default (`false`), macro names are hidden on most standard action bars for a cleaner interface. If set to `true`, macro names will be shown.

*   **Wide Action Bar Coverage**:
    *   Applies these customizations to most available action bars, including:
        *   Main action bar
        *   Multiple Blizzard multi-bars (Bottom Left, Bottom Right, Right, Left)
        *   Pet bar, Bonus bar, Extra action button, Vehicle UI buttons, Override action bar.
        *   Additional bars often referred to as MultiBar 5, 6, and 7.

*   **Automatic Updates**:
    *   Refreshes hotkey displays when the player enters the world or when keybindings are updated.

## How it Works

The addon intercepts the standard hotkey text generation process. For each relevant action button:
1.  It retrieves the current keybinding.
2.  It processes the keybinding text through a series of replacement rules to shorten common key names and modifier prefixes.
3.  It then updates the button's hotkey display region with this new abbreviated text.
4.  If the option to hide macro names is enabled, it also hides the macro name region on the button.

## Configuration

*   **Show/Hide Macro Names**:
    *   To change macro name visibility, edit the `ASHK_ShowMacroName` variable at the top of `asFixHotkey/asFixHotkey.lua`.
        *   `ASHK_ShowMacroName = false;` (Default - hides macro names on most bars)
        *   `ASHK_ShowMacroName = true;` (Shows macro names)

*   **Hotkey Abbreviations**:
    *   The specific abbreviations are defined within the `_CheckLongName` function in the Lua file. Advanced users could modify these rules if different abbreviations are desired.

**Note**: This addon does not provide an in-game configuration panel. All customizations require editing the `.lua` file.

---

# asFixHotkey

asFixHotkey는 액션 버튼에 표시되는 단축키 텍스트의 표시 방식을 사용자 정의하는 월드 오브 워크래프트 애드온입니다. 긴 키 이름을 축약하고 버튼의 매크로 이름을 숨기는 옵션을 제공하여 더 간결하고 깔끔한 외관을 제공하는 것을 목표로 합니다.

## 주요 기능

*   **단축키 텍스트 축약**:
    *   액션 버튼에 표시되는 키 바인딩 텍스트를 자동으로 줄여줍니다.
    *   축약 예시:
        *   `Num Pad 1` (숫자패드 1)은 `1`로 변경
        *   `Middle Mouse` (마우스 가운데 버튼)는 `M3`로 변경
        *   `Mouse Button 4` (4번 마우스 버튼)는 `M4`로 변경
        *   `Shift-R`은 `SR`로 변경
        *   `Ctrl-Alt-Delete`는 대략 `CADt`로 변경 (로직 기반)
        *   화살표 키는 `^`, `V`, `<`, `>`와 같은 기호로 표시됩니다.
    *   영어 및 한국어 클라이언트의 키 이름 모두에 대한 축약을 지원합니다.

*   **매크로 이름 숨기기 (선택 사항)**:
    *   Lua 파일 내의 설정 (`ASHK_ShowMacroName`)을 통해 액션 버튼의 매크로 이름 표시 여부를 제어합니다.
    *   기본값 (`false`)에서는 더 깔끔한 인터페이스를 위해 대부분의 표준 액션 바에서 매크로 이름이 숨겨집니다. `true`로 설정하면 매크로 이름이 표시됩니다.

*   **광범위한 액션 바 지원**:
    *   다음과 같은 대부분의 사용 가능한 액션 바에 이러한 사용자 정의를 적용합니다:
        *   주 액션 바
        *   여러 블리자드 멀티바 (하단 좌측, 하단 우측, 우측, 좌측)
        *   소환수 바, 보너스 바, 추가 액션 버튼, 차량 UI 버튼, 우선 지정 액션 바.
        *   흔히 멀티바 5, 6, 7로 불리는 추가 바.

*   **자동 업데이트**:
    *   플레이어가 게임 세계에 접속하거나 키 바인딩이 업데이트될 때 단축키 표시를 새로고침합니다.

## 작동 방식

애드온은 표준 단축키 텍스트 생성 프로세스를 가로챕니다. 각 관련 액션 버튼에 대해:
1.  현재 키 바인딩을 가져옵니다.
2.  일련의 대체 규칙을 통해 키 바인딩 텍스트를 처리하여 일반적인 키 이름과 수식어 접두사를 줄입니다.
3.  그런 다음 이 새로운 축약된 텍스트로 버튼의 단축키 표시 영역을 업데이트합니다.
4.  매크로 이름 숨기기 옵션이 활성화된 경우 버튼의 매크로 이름 영역도 숨깁니다.

## 설정

*   **매크로 이름 표시/숨기기**:
    *   매크로 이름 표시 여부를 변경하려면 `asFixHotkey/asFixHotkey.lua` 파일 상단의 `ASHK_ShowMacroName` 변수를 편집하십시오.
        *   `ASHK_ShowMacroName = false;` (기본값 - 대부분의 바에서 매크로 이름 숨김)
        *   `ASHK_ShowMacroName = true;` (매크로 이름 표시)

*   **단축키 축약**:
    *   특정 축약형은 Lua 파일의 `_CheckLongName` 함수 내에 정의되어 있습니다. 고급 사용자는 다른 축약형을 원할 경우 이러한 규칙을 수정할 수 있습니다.

**참고**: 이 애드온은 게임 내 설정 패널을 제공하지 않습니다. 모든 사용자 정의는 `.lua` 파일을 편집해야 합니다.
