# asDBMCastingAlert

asDBMCastingAlert provides highly customizable visual and auditory alerts for important enemy spell casts that require interruption, with a strong focus on integration with Deadly Boss Mods (DBM).
![asDBMCastingAlert](https://github.com/aspilla/asMOD/blob/main/.Pictures/asDBMCastingAlert.png?raw=true)

## Main Features

1.  **Dedicated Alert Bars**:
    *   Displays up to 3 dedicated bars for spells identified as important by DBM.
    *   Prioritizes spells from your `Focus Target`, then your current `Target`, and then other relevant units.
    *   Each bar shows the spell icon, spell name, remaining cast/channel time, and the spell's target (if applicable).

2.  **DBM Integration**:
    *   Relies on DBM's data to determine which spells are "dangerous" and require an alert.
    *   Alerts are typically triggered for spells that DBM marks as needing an interrupt, stun, or other special attention.

3.  **Visual Cues**:
    *   **Color Coding**: Cast bars are color-coded based on whether the spell is interruptible and whether the player is the direct target.
        *   Default colors differentiate between:
            *   Interruptible (Player is target)
            *   Interruptible (Player is not target)
            *   Not Interruptible (Player is target)
            *   Not Interruptible (Player is not target)
    *   **Interrupt Highlight**: Spells marked by DBM as needing an interrupt will have a glowing border around the bar and icon.
    *   **Raid Target Icons**: Displays raid target icons (Skull, X, etc.) assigned to the spell icon.

4.  **Auditory Alerts (Voice Cues)**:
    *   Provides voice cues for important spell casts.
    *   Different sounds play based on the situation:
        *   General interruptible spell ("Kick")
        *   General non-interruptible spell ("Stun")
        *   **Focus Target's** interruptible spell ("Focus Kick")
        *   **Focus Target's** non-interruptible spell ("Focus Stun")
        *   Current **Target's** interruptible spell ("Target Kick")
        *   Current **Target's** non-interruptible spell ("Target Stun")
    *   Supports both English and Korean voice packs based on client locale.
    *   Includes a delay feature to prevent the same voice alert from repeating too frequently.

5.  **User Settings**:
    *   The following settings can be configured via `ESC >> Settings >> AddOns >> asDBMCastingAlert`:
    *   `PlaySound` (Default On): Allows disabling voice alerts.
    *   `HideTarget` (Default Off): Allows disabling cast alerts for your current target.
    *   If the `asMOD` addon is installed, some settings like frame position can be configured through `asMOD`'s options panel.

## Setting Variables (in `asDBMCastingAlert.lua`)

*   `CONFIG_SOUND_SPEED`: Playback speed for voice alerts.
*   `CONFIG_X`, `CONFIG_Y`: Default X and Y position for the alert frame anchor.
*   `CONFIG_SIZE`: Default size for icon-related elements.
*   `CONFIG_VOICE_DELAY`: Minimum delay (in seconds) before repeating the same voice alert.
*   `CONFIG_WIDTH`, `CONFIG_HEIGHT`: Size of individual alert bars.
*   `CONFIG_ALPHA`: Transparency of the alert bars.
*   Color Variables (e.g., `CONFIG_NOT_INTERRUPTIBLE_COLOR`): Define RGB colors for various bar states.
*   Voice File Paths (e.g., `CONFIG_VOICE_TARGET_KICK`): Paths to sound files for alerts.

---

# asDBMCastingAlert

asDBMCastingAlert는 차단이 필요한 중요한 적 주문 시전에 대해 고급 사용자 정의가 가능한 시각 및 청각 알림을 제공하며, Deadly Boss Mods (DBM)와의 연동에 중점을 둡니다. 
![asDBMCastingAlert](https://github.com/aspilla/asMOD/blob/main/.Pictures/asDBMCastingAlert.png?raw=true)

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
    *   esc >> 설정 >> 애드온 >> asDBMCastingAlert 에서 다음 설정이 가능합니다.
    *   PlaySound (기본 On) : 음성 알림을 끌수 있습니다.
    *   HideTarget (기본 Off) : 대상의 시전 알림을 끌 수 있습니다.
    *   `asMOD` 애드온이 설치된 경우, 프레임 위치와 같은 일부 설정은 `asMOD`의 옵션 패널을 통해 구성할 수 있습니다.

## 설정 변수 (in `asDBMCastingAlert.lua`)

*   `CONFIG_SOUND_SPEED`: 음성 알림 재생 속도.
*   `CONFIG_X`, `CONFIG_Y`: 알림 프레임 앵커의 기본 X 및 Y 위치.
*   `CONFIG_SIZE`: 아이콘 관련 요소의 기본 크기.
*   `CONFIG_VOICE_DELAY`: 동일한 음성 알림을 반복하기 전 최소 지연 시간 (초 단위).
*   `CONFIG_WIDTH`, `CONFIG_HEIGHT`: 개별 알림 바의 크기.
*   `CONFIG_ALPHA`: 알림 바의 투명도.
*   색상 변수 (예: `CONFIG_NOT_INTERRUPTIBLE_COLOR`): 다양한 바 상태에 대한 RGB 색상을 정의합니다.
*   음성 파일 경로 (예: `CONFIG_VOICE_TARGET_KICK`): 알림용 사운드 파일 경로.
