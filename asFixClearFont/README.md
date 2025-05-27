# asFixClearFont

asFixClearFont is a small World of Warcraft addon that replaces certain default system number fonts with a custom font ("ClearFont.ttf") included with the addon. This can improve the clarity and readability of numbers in various parts of the UI.

## Main Features

*   **Custom Font Replacement**: Changes the font for several standard Blizzard UI elements that display numbers.
*   **Targeted Fonts**: Affects UI elements such as:
    *   `NumberFontNormal`
    *   `NumberFontNormalYellow`
    *   `NumberFontNormalSmall`
    *   `NumberFontNormalSmallGray`
    *   `NumberFontNormalLarge`
    *   `NumberFontNormalHuge`
*   **Included Font**: Comes with "ClearFont.ttf" located in the `Fonts/` subfolder.
*   **Font Outline**: Applies a standard or thick outline to the replaced fonts for better visibility.

## How it Works

The addon identifies specific predefined "NumberFont" objects within the Blizzard UI and changes their font to "ClearFont.ttf". This is done automatically when the addon is loaded.

## Customization

*   **Font File**: To use a different custom font, you could replace the `Interface\AddOns\asFixClearFont\Fonts\ClearFont.ttf` file with another `.ttf` font file (ensuring it's named `ClearFont.ttf` or by updating the path in `asFixClearFont.lua`).
*   **Font Scale**: The `asFixClearFont.lua` file contains a `CF_SCALE` variable. While currently set to `1.0` (no change from default sizes), modifying this value could potentially scale the size of the applied custom font, though this would require careful adjustment of the font sizes defined in the Lua file.

**Note**: This addon does not provide an in-game configuration panel.

---

# asFixClearFont

asFixClearFont는 특정 기본 시스템 숫자 글꼴을 애드온에 포함된 사용자 지정 글꼴("ClearFont.ttf")로 대체하는 작은 월드 오브 워크래프트 애드온입니다. 이를 통해 UI 여러 부분의 숫자 명확성과 가독성을 향상시킬 수 있습니다.

## 주요 기능

*   **사용자 지정 글꼴 대체**: 숫자를 표시하는 여러 표준 블리자드 UI 요소의 글꼴을 변경합니다.
*   **대상 글꼴**: 다음과 같은 UI 요소에 영향을 줍니다:
    *   `NumberFontNormal`
    *   `NumberFontNormalYellow`
    *   `NumberFontNormalSmall`
    *   `NumberFontNormalSmallGray`
    *   `NumberFontNormalLarge`
    *   `NumberFontNormalHuge`
*   **포함된 글꼴**: `Fonts/` 하위 폴더에 "ClearFont.ttf"가 함께 제공됩니다.
*   **글꼴 외곽선**: 가시성을 높이기 위해 대체된 글꼴에 표준 또는 굵은 외곽선을 적용합니다.

## 작동 방식

애드온은 블리자드 UI 내에서 미리 정의된 특정 "NumberFont" 객체를 식별하고 해당 글꼴을 "ClearFont.ttf"로 변경합니다. 이는 애드온이 로드될 때 자동으로 수행됩니다.

## 사용자 설정

*   **글꼴 파일**: 다른 사용자 지정 글꼴을 사용하려면 `Interface\AddOns\asFixClearFont\Fonts\ClearFont.ttf` 파일을 다른 `.ttf` 글꼴 파일로 대체할 수 있습니다 (이름을 `ClearFont.ttf`로 지정하거나 `asFixClearFont.lua`에서 경로를 업데이트해야 함).
*   **글꼴 크기 배율**: `asFixClearFont.lua` 파일에는 `CF_SCALE` 변수가 포함되어 있습니다. 현재 `1.0`(기본 크기에서 변경 없음)으로 설정되어 있지만, 이 값을 수정하면 적용된 사용자 지정 글꼴의 크기를 잠재적으로 조절할 수 있습니다. 다만, 이를 위해서는 Lua 파일에 정의된 글꼴 크기를 신중하게 조정해야 합니다.

**참고**: 이 애드온은 게임 내 설정 패널을 제공하지 않습니다.
