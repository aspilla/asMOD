# asFixHotkey

Shortens the hotkey text displayed on the action bar and hides macro names on buttons.
![asFixHotkey](https://github.com/aspilla/asMOD/blob/main/.Pictures/asFixHotKey.png?raw=true)

## Key Features

*   **Abbreviate Hotkey Text**:
    *   Automatically shortens the keybinding text displayed on action buttons.
    *   Examples of abbreviations:
        *   `Num Pad 1` is changed to `1`.
        *   `Middle Mouse` is changed to `M3`.
        *   `Mouse Button 4` is changed to `M4`.
        *   `Shift-R` is changed to `SR`.
        *   `Ctrl-Alt-Delete` is changed to approximately `CADt` (based on logic).
        *   Arrow keys are displayed with symbols like `^`, `v`, `<`, `>`.
    *   Supports abbreviations for key names in both English and Korean clients.

*   **Hide Macro Names**:
    *   Control the display of macro names on action buttons via the setting (`ASHK_ShowMacroName`) in the Lua file.

---

# asFixHotkey 

액션바에 표시되는 단축키 텍스트를 축약, 버튼의 매크로 이름 숨김
![asFixHotkey](https://github.com/aspilla/asMOD/blob/main/.Pictures/asFixHotKey.png?raw=true)

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

*   **매크로 이름 숨기기**:
    *   Lua 파일 내의 설정 (`ASHK_ShowMacroName`)을 통해 액션 버튼의 매크로 이름 표시 여부를 제어합니다.
