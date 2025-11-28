# asHideActionBar

asHideActionBar is a World of Warcraft addon that automatically hides your main action bars. These elements become visible when you move your mouse cursor near their original position.

<iframe width="560" height="315" src="https://www.youtube.com/embed/qjCYipwukhI?si=TA-GghasudzmAASR" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" referrerpolicy="strict-origin-when-cross-origin" allowfullscreen></iframe>

## Main Features

*   **Auto Show/Hide**:
    *   Hides the action bars by default.
    *   Makes these frames reappear (alpha set to 1) when the mouse cursor is moved within a configurable pixel distance (`AHAB_Offset`) of their boundaries.
    *   Frames fade back to hidden (alpha set to 0) when the mouse moves away.
*   **UI Declutter**: Helps to keep the screen cleaner by hiding these elements until they are needed.

## How it Works

1.  Upon loading, the addon sets the alpha of the target frames to 0 (invisible).
2.  A timer periodically checks the mouse cursor's position.
3.  If the cursor is detected within the defined offset range of a hidden frame, that frame's alpha is set to 1 (visible).
4.  When the cursor moves out of the range, the frame's alpha is set back to 0.

## Configuration

Configuration is done by editing Lua variables at the top of `asHideActionBar/asHideActionBar.lua`:

*   `AHAB_Offset`: The distance in pixels around the frames that will trigger them to become visible when the mouse hovers within this area.
    *   Default: `100`
*   `AHAB_UpdateRate`: How often, in seconds, the addon checks the mouse position to update frame visibility.
    *   Default: `0.5`

**Note**: This addon does not provide an in-game configuration panel. Changes require editing the `.lua` file.

---

# asHideActionBar

asHideActionBar는 월드 오브 워크래프트 애드온으로, 주 액션 바를 자동으로 숨깁니다. 이 요소들은 마우스 커서를 원래 위치 근처로 이동하면 다시 나타납니다.

<iframe width="560" height="315" src="https://www.youtube.com/embed/qjCYipwukhI?si=TA-GghasudzmAASR" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" referrerpolicy="strict-origin-when-cross-origin" allowfullscreen></iframe>

## 주요 기능

*   **자동 표시/숨기기**:
    *   기본적으로 액션 바를 숨깁니다.
    *   마우스 커서가 해당 프레임 경계의 설정 가능한 픽셀 거리(`AHAB_Offset`) 내로 이동하면 프레임이 다시 나타나도록(알파값 1로 설정) 합니다.
    *   마우스가 범위를 벗어나면 프레임은 다시 숨겨집니다(알파값 0으로 설정).
*   **UI 정리**: 필요할 때까지 이러한 요소를 숨겨 화면을 더 깔끔하게 유지하는 데 도움을 줍니다.

## 작동 방식

1.  로드 시 애드온은 대상 프레임의 알파값을 0(보이지 않음)으로 설정합니다.
2.  타이머가 주기적으로 마우스 커서의 위치를 확인합니다.
3.  숨겨진 프레임의 정의된 오프셋 범위 내에서 커서가 감지되면 해당 프레임의 알파값이 1(보임)로 설정됩니다.
4.  커서가 범위를 벗어나면 프레임의 알파값이 다시 0으로 설정됩니다.

## 설정

설정은 `asHideActionBar/asHideActionBar.lua` 파일 상단의 Lua 변수를 편집하여 수행합니다:

*   `AHAB_Offset`: 마우스가 이 영역 내에 hovered될 때 프레임이 보이도록 하는 프레임 주변의 픽셀 거리입니다.
    *   기본값: `100`
*   `AHAB_UpdateRate`: 애드온이 프레임 표시 여부를 업데이트하기 위해 마우스 위치를 확인하는 빈도(초 단위)입니다.
    *   기본값: `0.5`

**참고**: 이 애드온은 게임 내 설정 패널을 제공하지 않습니다. 변경하려면 `.lua` 파일을 편집해야 합니다.
