# asDBMCastingAlert (English)

Provides alerts for important DBM skills that need to be interrupted.
![asDBMCastingAlert](https://github.com/aspilla/asMOD/blob/main/.Pictures/asDBMCastingAlert.png?raw=true)

## Key Features

1.  **Casting Bar**:
    *   Displays up to 3 casting bars.
    *   Priority: `Focus Target` > `Target` > Other mobs.
    *   Each bar shows the spell icon, spell name, raid marker, remaining cast/channeling time, and spell target (if applicable).
    *   Only announces spells registered in DBM.
    *   Spells marked by DBM as needing an interrupt will have a glowing border around the bar and icon.

2.  **Bar Colors**:
    *   Bar colors differentiate between:
        *   Interruptible (player is the target): Dark Green
        *   Interruptible (player is not the target): Light Green
        *   Not Interruptible (player is the target): Red
        *   Not Interruptible (player is not the target): Gray

3.  **Sound Alerts**:
    *   For DBM skills that require an interrupt, a sound is played (English client sounds are also supported).
    *   In the case of stuns, it only alerts if the mob casting is of an equal level (when stuns are possible).
        *   General interruptible spell ("Kick", male)
        *   General non-interruptible spell ("Stun", male)
        *   **Focus Target's** interruptible spell ("Focus Kick", female)
        *   **Focus Target's** non-interruptible spell ("Focus Stun", female)
        *   Current **Target's** interruptible spell ("Kick", female)
        *   Current **Target's** non-interruptible spell ("Stun", female)
    *   For DBM interrupt skill settings, please refer to the video below:
        <iframe width="560" height="315" src="https://www.youtube.com/embed/Yn19ieQ6QRo?si=t2k3SFIV2hycDGo2" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" referrerpolicy="strict-origin-when-cross-origin" allowfullscreen></iframe>

4.  **Settings**:
    *   Can be configured via `ESC >> Settings >> AddOns >> asDBMCastingAlert`:
    *   `PlaySound` (Default: On): Enable or disable sound alerts.
    *   `HideTarget` (Default: Off): Hide alerts for your current target.
    *   If the `asMOD` addon is installed, you can also access settings via the `/asconfig` command.

## Configuration Variables (`asDBMCastingAlert.lua`)

*   `CONFIG_SOUND_SPEED`: Playback speed for sound alerts.
*   `CONFIG_X`, `CONFIG_Y`: Default X and Y coordinates for the alert frame's anchor.
*   `CONFIG_SIZE`: Default size for icon-related elements.
*   `CONFIG_VOICE_DELAY`: Minimum delay (in seconds) before repeating the same sound alert.
*   `CONFIG_WIDTH`, `CONFIG_HEIGHT`: Dimensions of the individual alert bars.
*   `CONFIG_ALPHA`: Transparency of the alert bars.
*   Color Variables (e.g., `CONFIG_NOT_INTERRUPTIBLE_COLOR`): Define RGB colors for different bar states.
*   Sound File Paths (e.g., `CONFIG_VOICE_TARGET_KICK`): Paths to the sound files used for notifications.

---

# asDBMCastingAlert

차단이 필요한 중요한 DBM 주요 스킬 안내를 합니다. 
![asDBMCastingAlert](https://github.com/aspilla/asMOD/blob/main/.Pictures/asDBMCastingAlert.png?raw=true)

## 주요 기능

1.  **시전 바**:
    *   최대 3개의 시전바를 표시
    *   `주시대상` > `대상` > 그외 몹의 우선 순위
    *   각 바에는 주문 아이콘, 주문 이름, 징표, 남은 시전/채널링 시간 및 주문 대상(해당되는 경우)이 표시
    *   DBM에 등록된 스킬 시전만 알림
    *   DBM이 차단이 필요하다고 표시한 주문은 바와 아이콘 주위에 빛나는 테두리가 생김


2.  **바 색상**:
    *   바 색상은 다음을 구분:
        *   차단 가능 (플레이어가 대상) : 진한 녹색
        *   차단 가능 (플레이어가 대상이 아님) :  연두색
        *   차단 불가능 (플레이어가 대상) : 빨간색
        *   차단 불가능 (플레이어가 대상이 아님) : 회색

3.  **음성 알림**:
    *   DBM 차단 필요 스킬의 경우 사운드가 재생 (한국어 클라이언트)
    *   스턴의 경우 동등 레벨인 몹이 시전하는 경우(스턴이 가능한 경우)만 알림
        *   일반적인 차단 가능 주문 ("차단", 남성)
        *   일반적인 차단 불가능 주문 ("스턴", 남성)
        *   **주시대상**의 차단 가능 주문 ("주시 짤", 여성)
        *   **주시대상**의 차단 불가능 주문 ("주시 스턴" 여성)
        *   현재 **대상**의 차단 가능 주문 ("짤", 여성)
        *   현재 **대상**의 차단 불가능 주문 ("스턴", 여성)
    *   DBM 차단 스킬 스킬 설정은 아래 영상을 참고        
        <iframe width="560" height="315" src="https://www.youtube.com/embed/Yn19ieQ6QRo?si=t2k3SFIV2hycDGo2" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" referrerpolicy="strict-origin-when-cross-origin" allowfullscreen></iframe>

4.  **설정**:
    *   esc >> 설정 >> 애드온 >> asDBMCastingAlert 에서 설정 가능
    *   PlaySound (기본 On) : 음성 알림 여부
    *   HideTarget (기본 Off) : 대상의 시전 알림 여부
    *   `asMOD` 애드온이 설치된 경우, `/asconfig` 명령어로 이동 가능

## 설정 변수 (`asDBMCastingAlert.lua`)

*   `CONFIG_SOUND_SPEED`: 음성 알림 재생 속도.
*   `CONFIG_X`, `CONFIG_Y`: 알림 프레임 앵커의 기본 X 및 Y 위치.
*   `CONFIG_SIZE`: 아이콘 관련 요소의 기본 크기.
*   `CONFIG_VOICE_DELAY`: 동일한 음성 알림을 반복하기 전 최소 지연 시간 (초 단위).
*   `CONFIG_WIDTH`, `CONFIG_HEIGHT`: 개별 알림 바의 크기.
*   `CONFIG_ALPHA`: 알림 바의 투명도.
*   색상 변수 (예: `CONFIG_NOT_INTERRUPTIBLE_COLOR`): 다양한 바 상태에 대한 RGB 색상을 정의
*   음성 파일 경로 (예: `CONFIG_VOICE_TARGET_KICK`): 알림용 사운드 파일 경로.
