# asInformation (Mid Night)

Displays primary stats (Strength, Agility, or Intelligence based on class) and secondary stats (Haste, Critical Strike, Mastery, Versatility), highlighting them when they increase.

![asInformation](https://github.com/aspilla/asMOD/blob/main/.Pictures/asInformation.jpg?raw=true)

## Key Features

* **Primary/Secondary Stat Display**: Displays stats (Primary stats, Haste, Critical Strike, Mastery, Versatility) in a bar format.
* **Increase Notification (Color Change)**: Changes the bar color to the stat's specific color when a stat increases above the minimum value recorded out of combat. The reference value is based on the lowest value recorded during 20 seconds out of combat.
* **Threshold Notification**:
    * Custom percentage thresholds can be set (Default: 100%).
    * The threshold for the primary stat is triggered when it increases by 20% compared to the minimum value.
    * When a stat reaches or exceeds this value, the border of the corresponding stat bar will flash.


## Configuration

* Access via the `/asinformation` chat command or `ESC > Options > Addons > asInformation`.
* **Lock Frame**: Select to prevent moving the frame. Deselect to allow dragging.
* **Show Haste**: Toggles the display of Haste percentage.
* **Show Crit**: Toggles the display of Critical Strike percentage.
* **Show Mastery**: Toggles the display of Mastery percentage.
* **Show Versatility**: Toggles the display of Versatility percentage.
* **Show Main Stat**: Toggles the display of the player's primary stat (Strength, Agility, or Intelligence).
* **Haste Threshold (Slider)**: Sets the Haste value (0-300%) at which the Haste text will be highlighted.

---

# asInformation (한밤)

1차 능력치(직업별 힘, 민첩, 또는 지능), 2차 능력치 (가속, 치명타, 특화, 유연성) 표시 및 증가 시 강조

![asInformation](https://github.com/aspilla/asMOD/blob/main/.Pictures/asInformation.jpg?raw=true)   

## 주요 기능

*   **1차/2차 능력치 표시**: 프레임에 표시할 능력치(주 능력치(직업별 힘, 민첩 또는 지능), 가속, 치명타, 특화, 유연성)를 바 형태로 표시.
*   **증가 알림(색상 변경)**: 1/2차 능력치가 비전투 중 최소값 보다 증가 할 경우 바 색상을 능력치 생상으로 변경. 기준값은 비전투 20초 중 가장 낮은 값을 참고함.
*   **임계값 알림**:
    *   사용자 지정 백분율 임계값을 설정할 수 있습니다. 기본 100%
    *   1차 스텟의 임계값은 최소값 대비 20% 증가한 경우 입니다.
    *   1/2차 스텟이 이 값에 도달하거나 초과하면 프레임의 해당 스텟의 바의 테두리가 빤짝입니다.

## 설정

*   `/asinformation` 대화창 명령어 혹은 `esc >> 설정 >> 애드온 >> asInformation` 통해 접근 가능.
*   **프레임 잠금**: 프레임 이동을 방지하려면 선택합니다. 드래그를 허용하려면 선택 취소합니다.
*   **가속 표시**: 가속 백분율 표시를 토글합니다.
*   **크리 표시**: 치명타 및 극대화 백분율 표시를 토글합니다.
*   **특화 표시**: 특화 백분율 표시를 토글합니다.
*   **유연 표시**: 유연성 백분율 표시를 토글합니다.
*   **주요 스탯 표시**: 플레이어의 주요 스탯(힘, 민첩 또는 지능) 표시를 토글합니다.
*   **가속 임계값 (슬라이더)**: 가속 텍스트가 강조 표시될 가속 값(0-300%)을 설정합니다.