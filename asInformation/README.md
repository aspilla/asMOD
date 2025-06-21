# asInformation

A simple addon that displays the player's main combat stats: primary stat (Strength, Agility, or Intelligence depending on class), Haste, Critical Strike, Mastery, and Versatility.

<iframe width="560" height="315" src="https://www.youtube.com/embed/y6uPJMc3YzY?si=y2WZ5EZhIKL6ThOX" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" referrerpolicy="strict-origin-when-cross-origin" allowfullscreen></iframe>

## Main Features

*   **Stat Display**: Shows your primary and secondary stats (Primary Stat, Haste, Crit, Mastery, Versatility) as bars.
*   **Proc/Buff Alerts (Color Change)**: When a secondary stat increases above its baseline out-of-combat value, the bar changes color to indicate a temporary buff. The baseline is determined by the lowest stat value recorded over 20 seconds while out of combat.
*   **Primary Stat Increase**: For the primary stat, the bar displays the total amount gained above the baseline out-of-combat value.
*   **Threshold Glow**:
    *   Set custom percentage thresholds for your secondary stats (default is 100%).
    *   The primary stat threshold is fixed at a 20% increase over the baseline.
    *   When a stat reaches or exceeds its threshold, the bar's border will glow to alert you.
*   **In-Game Options Panel**:
    *   Access it easily with the `/asinformation` chat command or through the game menu (`Esc` -> `Options` -> `AddOns` -> `asInformation`).
    *   From the panel, you can:
        *   Lock or unlock the main frame's position.
        *   Toggle the visibility of each stat bar individually.
        *   Use sliders to adjust the alert thresholds for secondary stats.


## Configuration

*   **Accessing Options**: Type `/asinformation` in your chat box to open the settings panel.
*   **Available Options**:
    *   **Lock Frame**: Check this box to prevent the frame from being moved. Uncheck to allow dragging.
    *   **Show Haste**: Toggles the visibility of the Haste bar.
    *   **Show Crit**: Toggles the visibility of the Critical Strike bar.
    *   **Show Mastery**: Toggles the visibility of the Mastery bar.
    *   **Show Versatility**: Toggles the visibility of the Versatility bar.
    *   **Show Primary Stat**: Toggles the visibility of your primary stat bar (STR, AGI, or INT).
    *   **Haste Threshold (Slider)**: Sets the percentage threshold for the Haste glow alert (0-300%).
    *   *(Sliders for other secondary stats are also available).*

All settings are saved on a per-character basis.

---

# asInformation

플레이어의 주요 전투 능력치인 주 능력치(직업별 힘, 민첩, 또는 지능), 가속, 치명타 및 극대화, 특화, 유연성을 보여주는 간단한 애드온

<iframe width="560" height="315" src="https://www.youtube.com/embed/y6uPJMc3YzY?si=y2WZ5EZhIKL6ThOX" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" referrerpolicy="strict-origin-when-cross-origin" allowfullscreen></iframe>

## 주요 기능

*   **1차/2차 능력치 표시**: 프레임에 표시할 능력치(주 능력치(직업별 힘, 민첩 또는 지능), 가속, 치명타, 특화, 유연성)를 바 형태로 표시 합니다.
*   **증가 알림(색상 변경)**: 2차 능력치가 비전투 중 최소값 보다 증가 할 경우 바 색상을 능력치 생상으로 변경 합니다. 기준값은 비전투 20초 중 가장 낮은 값을 참고 합니다.
*   **증가 알림(1차 능력치)**: 1차 능력치의 경우 비전투 최소값 대비 증가한 값을 표시 합니다.
*   **임계값 알림**:
    *   사용자 지정 백분율 임계값을 설정할 수 있습니다. 기본 100%
    *   1차 스텟의 임계값은 최소값 대비 20% 증가한 경우 입니다.
    *   1/2차 스텟이 이 값에 도달하거나 초과하면 프레임의 해당 스텟의 바의 테두리가 빤짝입니다.
*   **게임 내 옵션 패널**:
    *   `/asinformation` 대화창 명령어 혹은 `esc >> 설정 >> 애드온 >> asInformation` 통해 접근할 수 있습니다.
    *   다음과 같은 작업을 수행할 수 있습니다:
        *   프레임 위치 잠금 또는 잠금 해제.
        *   각 능력치(주 능력치, 가속, 치명타, 특화, 유연성)의 표시 여부 토글.
        *   슬라이더를 사용하여 임계값 백분율 조정.


## 설정

*   **옵션 접근**: 대화창에 `/asinformation`을 입력하여 설정 패널을 엽니다.
*   **사용 가능한 옵션**:
    *   **프레임 잠금**: 프레임 이동을 방지하려면 선택합니다. 드래그를 허용하려면 선택 취소합니다.
    *   **가속 표시**: 가속 백분율 표시를 토글합니다.
    *   **크리 표시**: 치명타 및 극대화 백분율 표시를 토글합니다.
    *   **특화 표시**: 특화 백분율 표시를 토글합니다.
    *   **유연 표시**: 유연성 백분율 표시를 토글합니다.
    *   **주요 스탯 표시**: 플레이어의 주요 스탯(힘, 민첩 또는 지능) 표시를 토글합니다.
    *   **가속 임계값 (슬라이더)**: 가속 텍스트가 강조 표시될 가속 값(0-300%)을 설정합니다.

설정은 각 캐릭터별로 저장됩니다.