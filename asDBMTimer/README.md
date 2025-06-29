# asDBMTimer

This is a new visual style timer for Deadly Boss Mods (DBM).
![asDBMTimer](https://github.com/aspilla/asMOD/blob/main/.Pictures/asDBMTimer.jpg?raw=true)

## Key Features

1.  **Detailed Timer Elements**:
    *   **Icon**: Displays the spell or event icon provided by DBM.
    *   **Cooldown Text**: Shows a numerical countdown (e.g., "3.1"). The text turns red when the remaining time is 3 seconds or less.
    *   **Description Label**: Displays the DBM timer message (e.g., "Boss Ability Name"). This label may be prefixed with a type (e.g., "[AoE]", "[Interrupt]") and color-coded based on DBM's timer category.
    *   **Raid Target Icon**: If the timer is associated with a specific unit (often from nameplate timers) and that unit has a raid target icon (skull, X, etc.), the icon is displayed next to the timer label.

2.  **Color-Coded Timer Types**:
    *   Timer labels are color-coded based on DBM's timer classifications (e.g., Minion, AoE, Targeted, Interrupt, Role, Phase, Important).
    *   Specific color schemes are defined for both English and Korean client locales.

3.  **Auditory Alert for AoE Abilities**:
    *   Plays a sound alert (`AoE Soon`) shortly before DBM timers classified as AoE expire.

## Settings

*   `MinTimetoShow`: Minimum display time (default: 10 seconds).
*   `HideNamePlatesCooldown`: Whether to hide timers for regular mobs.
*   `ShowInterruptOnlyforNormal`: Only show interrupt timers for regular mobs.
*   `AOESound`: Time before an AoE alert expires (default: 2.5 seconds before expiration).
*   `LockPosition`: Check to enable movement; `/asconfig` has higher priority.

---
# asDBMTimer

Deadly Boss Mods (DBM) 새로 모양 Timer 입니다.
![asDBMTimer](https://github.com/aspilla/asMOD/blob/main/.Pictures/asDBMTimer.jpg?raw=true)


## 주요 기능

1.  **상세 타이머 요소**:
    *   **아이콘**: DBM에서 제공하는 주문 또는 이벤트 아이콘을 표시합니다.
    *   **재사용 대기시간 텍스트**: 숫자 카운트다운(예: "3.1")을 표시합니다. 남은 시간이 3초 이하일 때 텍스트가 빨간색으로 바뀝니다.
    *   **설명 레이블**: DBM 타이머 메시지(예: "보스 기술 이름")를 표시합니다. 이 레이블에는 유형(예: "[광역]", "[차단]")이 접두사로 붙을 수 있으며 DBM의 타이머 범주에 따라 색상으로 구분될 수 있습니다.
    *   **공격대 대상 아이콘**: 타이머가 특정 유닛(종종 이름표 타이머에서 유래)과 연관되어 있고 해당 유닛에 공격대 대상 아이콘(해골, X자 등)이 있는 경우, 이 아이콘이 타이머 레이블 옆에 표시됩니다.

2.  **색상으로 구분된 타이머 유형**:
    *   타이머 레이블은 DBM의 타이머 분류(예: 쫄, 광역, 대상 지정, 차단, 역할, 단계, 중요)에 따라 색상이 지정됩니다.
    *   영어 및 한국어 클라이언트 로케일 모두에 대해 특정 색상 구성표가 정의되어 있습니다.

3.  **광역 기술에 대한 청각 알림**:
    *   광역으로 분류된 DBM 타이머가 만료되기 직전 사운드 알림(`곧 광역`)을 재생합니다.


## 설정

* `MinTimetoShow` 최소 표시 시간 (기본 10초)
* `HideNamePlatesCooldown` 일반몹 Timer 숨김 여부
* `ShowInterruptOnlyforNormal` 일반몹 Timer는 차단만 표시
* `AOESound` 곧 광역 알림 만료전 시간 (기본 2.5초 전 알림)
* `LockPosition` 채크하고 이동 가능, `/asconfig` 이 더 우선순위 높음
