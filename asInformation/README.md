# asInformation

A simple addon that displays the player's main combat stats: Haste, Critical Strike, Mastery, and Versatility.

<iframe width="560" height="315" src="https://www.youtube.com/embed/y6uPJMc3YzY?si=y2WZ5EZhIKL6ThOX" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" referrerpolicy="strict-origin-when-cross-origin" allowfullscreen></iframe>

## Key Features

*   **Secondary Stat Display**: Shows selected stats (Haste, Critical Strike, Mastery, Versatility) as bars in a frame.
*   **Increase Notification (Color Change)**: When a secondary stat increases above its minimum value out-of-combat, the bar color changes to the stat's color. The reference value is the lowest value observed during 20 seconds of non-combat.
*   **Threshold Alert**:
    *   You can set a custom percentage threshold (default 100%).
    *   When a secondary stat reaches or exceeds this value, the border of the stat's bar in the frame will flash.
*   **In-Game Options Panel**:
    *   Accessible via the `/asinformation` chat command or `ESC >> Settings >> AddOns >> asInformation`.
    *   Allows you to:
        *   Lock or unlock the frame's position.
        *   Toggle the display of each stat (Haste, Critical Strike, Mastery, Versatility).
        *   Adjust the threshold percentage using a slider.
*   **Localization**: The options panel is localized for Korean and English clients.

## How It Works

1.  The addon creates a main frame and individual text lines for each stat.
3.  The displayed text updates based on these values and the display settings in the options panel.
4.  The appearance of Haste changes when it meets the user-defined threshold.
5.  The frame can be dragged if unlocked, and its position is saved. Settings are managed through the options panel.

## Settings

*   **Accessing Options**: Type `/asinformation` in the chat window to open the settings panel.
*   **Available Options**:
    *   **Lock Frame**: Check to prevent the frame from moving. Uncheck to allow dragging.
    *   **Show Haste**: Toggles the display of Haste percentage.
    *   **Show Crit**: Toggles the display of Critical Strike percentage.
    *   **Show Mastery**: Toggles the display of Mastery percentage.
    *   **Show Versatility**: Toggles the display of Versatility percentage.
    *   **Haste Threshold (Slider)**: Sets the Haste value (0-300%) at which the Haste text will be highlighted.

Settings are saved per character.

---

# asInformation

플레이어의 주요 전투 능력치인 가속, 치명타 및 극대화, 특화, 유연성을 보여주는 간단한 애드온

<iframe width="560" height="315" src="https://www.youtube.com/embed/y6uPJMc3YzY?si=y2WZ5EZhIKL6ThOX" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" referrerpolicy="strict-origin-when-cross-origin" allowfullscreen></iframe>

## 주요 기능

*   **2차 능력치 표시**: 프레임에 표시할 능력치(가속, 치명타, 특화, 유연성)를 바 형태로 표시 합니다.
*   **증가 알림(색상 변경)**: 2차 능력치가 비전투 중 최소값 보다 증가 할 경우 바 색상을 능력치 생상으로 변경 합니다. 기준값은 비전투 20초 중 가장 낮은 값을 참고 합니다.
*   **임계값 알림**:
    *   사용자 지정 백분율 임계값을 설정할 수 있습니다. 기본 100%
    *   2차 스텟이 이 값에 도달하거나 초과하면 프레임의 해당 스텟의 바의 테두리가 빤짝입니다.
*   **게임 내 옵션 패널**:
    *   `/asinformation` 대화창 명령어 혹은 `esc >> 설정 >> 애드온 >> asInformation` 통해 접근할 수 있습니다.
    *   다음과 같은 작업을 수행할 수 있습니다:
        *   프레임 위치 잠금 또는 잠금 해제.
        *   각 능력치(가속, 치명타, 특화, 유연성)의 표시 여부 토글.
        *   슬라이더를 사용하여 임계값 백분율 조정.
*   **현지화**: 옵션 패널은 한국어 및 영어 클라이언트에 맞게 현지화되어 있습니다.

## 작동 방식

1.  애드온은 주 프레임과 각 능력치에 대한 개별 텍스트 라인을 생성합니다.
3.  표시되는 텍스트는 이러한 값과 옵션 패널의 표시 설정에 따라 업데이트됩니다.
4.  가속이 사용자가 정의한 임계값을 충족하면 모양이 변경됩니다.
5.  프레임은 잠금 해제된 경우 드래그할 수 있으며 위치가 저장됩니다. 설정은 옵션 패널을 통해 관리됩니다.

## 설정

*   **옵션 접근**: 대화창에 `/asinformation`을 입력하여 설정 패널을 엽니다.
*   **사용 가능한 옵션**:
    *   **프레임 잠금**: 프레임 이동을 방지하려면 선택합니다. 드래그를 허용하려면 선택 취소합니다.
    *   **가속 표시**: 가속 백분율 표시를 토글합니다.
    *   **크리 표시**: 치명타 및 극대화 백분율 표시를 토글합니다.
    *   **특화 표시**: 특화 백분율 표시를 토글합니다.
    *   **유연 표시**: 유연성 백분율 표시를 토글합니다.
    *   **가속 임계값 (슬라이더)**: 가속 텍스트가 강조 표시될 가속 값(0-300%)을 설정합니다.

설정은 각 캐릭터별로 저장됩니다.
