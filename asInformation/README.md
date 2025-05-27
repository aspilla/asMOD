# asInformation

asInformation is a World of Warcraft addon that displays a small, movable frame showing your character's key combat statistics: Haste, Critical Strike, Mastery, and Versatility. It includes options to toggle individual stats and set a visual threshold alert for Haste.

## Main Features

*   **Movable Stats Frame**: Provides a draggable frame that can be positioned anywhere on the screen. Its position is saved per character.
*   **Selectable Stats Display**: Allows you to choose which stats (Haste, Crit, Mastery, Versatility) are visible in the frame.
*   **Real-time Updates**: Stats are updated periodically to reflect current values.
*   **Haste Threshold Alert**:
    *   You can set a custom Haste percentage threshold.
    *   If your Haste reaches or exceeds this value, the Haste text in the frame will be highlighted (larger font, yellow color) for easy visual confirmation.
*   **In-Game Options Panel**:
    *   Accessible via the `/asinformation` slash command.
    *   Allows you to:
        *   Lock or unlock the frame's position.
        *   Toggle the visibility of each stat (Haste, Crit, Mastery, Versatility).
        *   Adjust the Haste threshold percentage using a slider.
*   **Localization**: Options panel is localized for Korean and English clients.

## How it Works

1.  The addon creates a main frame and individual text lines for each stat.
2.  It periodically queries the game API for your character's Haste (`GetHaste()`), Crit (`GetCritChance()`), Mastery (`GetMasteryEffect()`), and Versatility (`GetCombatRatingBonus()` + `GetVersatilityBonus()`).
3.  The displayed text is updated based on these values and your visibility settings in the options panel.
4.  If Haste meets the user-defined threshold, its appearance is changed.
5.  The frame can be dragged if unlocked, and its position is saved. Settings are managed through an options panel.

## Configuration

*   **Accessing Options**: Type `/asinformation` in chat to open the settings panel.
*   **Options Available**:
    *   **Lock Frame**: Check to prevent the frame from being moved. Uncheck to allow dragging.
    *   **Show Haste**: Toggle Haste percentage display.
    *   **Show Crit**: Toggle Critical Strike percentage display.
    *   **Show Mastery**: Toggle Mastery percentage display.
    *   **Show Ver**: Toggle Versatility percentage display.
    *   **Haste Threshold (Slider)**: Set the Haste value (0-300%) at which the Haste text will be highlighted.

Settings are saved for each character.

---

# asInformation

asInformation은 플레이어 캐릭터의 주요 전투 능력치인 가속, 치명타 및 극대화, 특화, 유연성을 보여주는 작고 이동 가능한 프레임을 표시하는 월드 오브 워크래프트 애드온입니다. 개별 능력치 표시를 토글하고 가속에 대한 시각적 임계값 알림을 설정하는 옵션이 포함되어 있습니다.

## 주요 기능

*   **이동 가능한 능력치 프레임**: 화면 어디에나 위치시킬 수 있는 드래그 가능한 프레임을 제공합니다. 위치는 캐릭터별로 저장됩니다.
*   **선택적 능력치 표시**: 프레임에 표시할 능력치(가속, 치명타, 특화, 유연성)를 선택할 수 있습니다.
*   **실시간 업데이트**: 능력치는 현재 값을 반영하여 주기적으로 업데이트됩니다.
*   **가속 임계값 알림**:
    *   사용자 지정 가속 백분율 임계값을 설정할 수 있습니다.
    *   가속이 이 값에 도달하거나 초과하면 프레임의 가속 텍스트가 강조 표시되어(더 큰 글꼴, 노란색) 쉽게 시각적으로 확인할 수 있습니다.
*   **게임 내 옵션 패널**:
    *   `/asinformation` 대화창 명령어를 통해 접근할 수 있습니다.
    *   다음과 같은 작업을 수행할 수 있습니다:
        *   프레임 위치 잠금 또는 잠금 해제.
        *   각 능력치(가속, 치명타, 특화, 유연성)의 표시 여부 토글.
        *   슬라이더를 사용하여 가속 임계값 백분율 조정.
*   **현지화**: 옵션 패널은 한국어 및 영어 클라이언트에 맞게 현지화되어 있습니다.

## 작동 방식

1.  애드온은 주 프레임과 각 능력치에 대한 개별 텍스트 라인을 생성합니다.
2.  주기적으로 게임 API를 조회하여 캐릭터의 가속(`GetHaste()`), 치명타(`GetCritChance()`), 특화(`GetMasteryEffect()`) 및 유연성(`GetCombatRatingBonus()` + `GetVersatilityBonus()`) 값을 가져옵니다.
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
