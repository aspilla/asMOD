# asDBMCastingAlert

asDBMCastingAlert provides advanced, customizable visual and auditory alerts for important enemy spell casts, with a strong emphasis on integration with Deadly Boss Mods (DBM). It is designed to help players react quickly to critical mechanics.

## Main Features

1.  **Dedicated Alert Bars**:
    *   Displays up to three dedicated bars for spells identified as important by DBM.
    *   Prioritizes showing spells from your `focus` target, then your current `target`, then other relevant units.
    *   Each bar shows the spell icon, spell name, remaining cast/channel time, and the target of the spell (if applicable).

2.  **DBM Integration**:
    *   Relies on DBM's data to determine which spells are "dangerous" and require an alert.
    *   Alerts are typically for spells that DBM flags for interrupts, stuns, or other special attention.

3.  **Visual Cues**:
    *   **Color Coding**: Casting bars are color-coded based on whether the spell is interruptible and whether the player is the direct target.
        *   Default colors distinguish between:
            *   Interruptible (player is target)
            *   Interruptible (player is not target)
            *   Not Interruptible (player is target)
            *   Not Interruptible (player is not target)
    *   **Interrupt Glow**: Spells that DBM marks as needing an interrupt will have a glowing border around the bar and icon.
    *   **Raid Target Icons**: Displays the assigned raid target icon (skull, cross, etc.) on the spell icon.

4.  **Auditory Alerts (Voice Notifications)**:
    *   Provides voice callouts for critical spell casts.
    *   Different sounds for:
        *   General interruptible spell ("Kick")
        *   General non-interruptible spell ("Stun")
        *   Interruptible spell from **focus** target ("Focus Kick")
        *   Non-interruptible spell from **focus** target ("Focus Stun")
        *   Interruptible spell from current **target** ("Target Kick")
        *   Non-interruptible spell from current **target** ("Target Stun")
    *   Supports both English and Korean voice packs, selected based on client locale.
    *   A delay prevents the same voice alert from playing too frequently.

5.  **Customization**:
    *   Many visual aspects (bar size, position, colors, transparency, font sizes) can be configured by editing variables at the top of `asDBMCastingAlert.lua`.
    *   Sound settings (voice pack paths, playback speed, repeat delay) are also configurable in the Lua file.
    *   If the `asMOD` addon is installed, some settings like the frame position can be configured through `asMOD`'s options panel.

6.  **Filtering**:
    *   Includes an option (`ns.options.HideTarget`) to hide alerts for the current target if it is not also the focus target, reducing clutter.

## Configuration Variables (in `asDBMCastingAlert.lua`)

*   `CONFIG_SOUND_SPEED`: Playback speed for voice alerts.
*   `CONFIG_X`, `CONFIG_Y`: Default X and Y position of the alert frame anchor.
*   `CONFIG_SIZE`: Base size for icon-related elements.
*   `CONFIG_VOICE_DELAY`: Minimum delay (in seconds) before repeating the same voice alert.
*   `CONFIG_WIDTH`, `CONFIG_HEIGHT`: Dimensions of the individual alert bars.
*   `CONFIG_ALPHA`: Transparency of the alert bars.
*   Color variables (e.g., `CONFIG_NOT_INTERRUPTIBLE_COLOR`): Define the RGB colors for different bar states.
*   Voice file paths (e.g., `CONFIG_VOICE_TARGET_KICK`): Paths to the sound files for alerts.

---

# asDBMCastingAlert

asDBMCastingAlert는 중요한 적 주문 시전에 대해 고급 사용자 정의가 가능한 시각 및 청각 알림을 제공하며, Deadly Boss Mods (DBM)와의 연동에 중점을 둡니다. 플레이어가 중요한 메커니즘에 빠르게 반응하도록 돕기 위해 설계되었습니다.

## 주요 기능

1.  **전용 알림 바**:
    *   DBM에 의해 중요하다고 식별된 주문에 대해 최대 3개의 전용 바를 표시합니다.
    *   `주시대상`의 주문을 우선 표시하고, 그 다음 현재 `대상`, 그리고 다른 관련 유닛 순으로 표시합니다.
    *   각 바에는 주문 아이콘, 주문 이름, 남은 시전/채널링 시간 및 주문 대상(해당되는 경우)이 표시됩니다.

2.  **DBM 연동**:
    *   어떤 주문이 "위험"하고 알림이 필요한지 결정하기 위해 DBM의 데이터에 의존합니다.
    *   알림은 일반적으로 DBM이 차단, 기절 또는 기타 특별한 주의가 필요하다고 표시한 주문에 대해 발생합니다.

3.  **시각적 신호**:
    *   **색상 코딩**: 시전 바는 주문 차단 가능 여부 및 플레이어가 직접적인 대상인지 여부에 따라 색상으로 구분됩니다.
        *   기본 색상은 다음을 구분합니다:
            *   차단 가능 (플레이어가 대상)
            *   차단 가능 (플레이어가 대상이 아님)
            *   차단 불가능 (플레이어가 대상)
            *   차단 불가능 (플레이어가 대상이 아님)
    *   **차단 강조**: DBM이 차단이 필요하다고 표시한 주문은 바와 아이콘 주위에 빛나는 테두리가 생깁니다.
    *   **공격대 대상 아이콘**: 주문 아이콘에 할당된 공격대 대상 아이콘(해골, X자 등)을 표시합니다.

4.  **청각 알림 (음성 안내)**:
    *   중요한 주문 시전에 대한 음성 안내를 제공합니다.
    *   다음과 같은 상황에 따라 다른 사운드가 재생됩니다:
        *   일반적인 차단 가능 주문 ("차단")
        *   일반적인 차단 불가능 주문 ("기절")
        *   **주시대상**의 차단 가능 주문 ("주시 차단")
        *   **주시대상**의 차단 불가능 주문 ("주시 기절")
        *   현재 **대상**의 차단 가능 주문 ("대상 차단")
        *   현재 **대상**의 차단 불가능 주문 ("대상 기절")
    *   클라이언트 로케일에 따라 영어 및 한국어 음성 팩을 모두 지원합니다.
    *   딜레이 기능이 있어 동일한 음성 알림이 너무 자주 반복되는 것을 방지합니다.

5.  **사용자 설정**:
    *   다양한 시각적 요소(바 크기, 위치, 색상, 투명도, 글꼴 크기)는 `asDBMCastingAlert.lua` 파일 상단의 변수를 편집하여 구성할 수 있습니다.
    *   사운드 설정(음성 팩 경로, 재생 속도, 반복 지연) 또한 Lua 파일에서 구성할 수 있습니다.
    *   `asMOD` 애드온이 설치된 경우, 프레임 위치와 같은 일부 설정은 `asMOD`의 옵션 패널을 통해 구성할 수 있습니다.

6.  **필터링**:
    *   현재 대상이 주시 대상이 아닌 경우 해당 대상에 대한 알림을 숨기는 옵션 (`ns.options.HideTarget`)을 포함하여 화면 혼잡을 줄입니다.

## 설정 변수 (in `asDBMCastingAlert.lua`)

*   `CONFIG_SOUND_SPEED`: 음성 알림 재생 속도.
*   `CONFIG_X`, `CONFIG_Y`: 알림 프레임 앵커의 기본 X 및 Y 위치.
*   `CONFIG_SIZE`: 아이콘 관련 요소의 기본 크기.
*   `CONFIG_VOICE_DELAY`: 동일한 음성 알림을 반복하기 전 최소 지연 시간 (초 단위).
*   `CONFIG_WIDTH`, `CONFIG_HEIGHT`: 개별 알림 바의 크기.
*   `CONFIG_ALPHA`: 알림 바의 투명도.
*   색상 변수 (예: `CONFIG_NOT_INTERRUPTIBLE_COLOR`): 다양한 바 상태에 대한 RGB 색상을 정의합니다.
*   음성 파일 경로 (예: `CONFIG_VOICE_TARGET_KICK`): 알림용 사운드 파일 경로.
