# asCooldownPulse

![asCooldownPulse_screenshot_placeholder](https://github.com/aspilla/asMOD/blob/main/.Pictures/asCooldownPulse_screenshot_placeholder.png?raw=true)

asCooldownPulse is a World of Warcraft addon that provides a simple and effective way to track spell and item cooldowns. It offers visual cues and audio alerts to help you manage your abilities efficiently.

## Main Features

*   **Visual Cooldown Tracking:** Displays icons for spells and items currently on cooldown.
*   **Configurable Display:** Allows customization of icon size, position on screen, and the number of cooldown icons displayed per row. (Details for these are typically adjusted via in-code variables at the top of `asCooldownPulse.lua` such as `ACDP_CoolButtons_X`, `ACDP_CoolButtons_Y`, `ACDP_SIZE`, `ACDP_CooldownCount`).
*   **Audio Alerts:** Notifies you with a sound when important cooldowns are about to become available.
*   **Text-to-Speech (TTS):** Offers a Text-to-Speech option for cooldown completion announcements.
*   **Cooldown Filtering:** Configure minimum and maximum cooldown durations to track (e.g., `CONFIG_MINCOOL`, `CONFIG_MAXCOOL` in `asCooldownPulse.lua`).
*   **asMOD Integration:** Works alongside other addons in the "asMOD" suite. If `asMOD` is installed, it allows users to move and save the position of asCooldownPulse's icon list using `asMOD`'s `/asConfig` command.

## Configuration

The primary configuration for asCooldownPulse is done via the in-game addon options panel. You can access it by navigating to `ESC -> Options -> AddOns -> asCooldownPulse`.

Available options include:

*   **PlaySound**: Enable or disable sound alerts for cooldown completion. (Default: true)
*   **AlwaysShowButtons**: If true, the cooldown list will always be visible. Otherwise, it may hide under certain conditions (e.g., if asCombatInfo is configured to hide it). (Default: false)
*   **SoundVolume**: Set the volume for sound alerts (0-100). (Default: 50)
*   **SoundCooldown**: Minimum cooldown duration (in seconds) for a spell/item to trigger a sound alert. (Default: 15 seconds)
*   **EnableTTS**: Enable or disable Text-to-Speech for cooldown announcements. (Default: true)
*   **SlotNameTTS**: If TTS is enabled, announce the item slot name (e.g., "Trinket 1") instead of the item/spell name for items. (Default: true)
*   **TTS_ID**: Select the TTS voice to be used. Automatically attempts to select a Korean voice for koKR clients and English for others.
*   **Aware_ASMOD_Cooldown**: Cooldown threshold (in seconds) for sound alerts when integrated with other asMOD components like asCombatInfo. (Default: 5 seconds)
*   **Aware_PowerBar**: If true, sound alerts might be suppressed for spells managed by asPowerBar to avoid duplicate sounds. (Default: true)

Some visual aspects like icon positioning (`ACDP_CoolButtons_X`, `ACDP_CoolButtons_Y`), icon size (`ACDP_SIZE`), and icons per row (`ACDP_CooldownCount`) are primarily managed by variables at the top of `asCooldownPulse.lua`.

## Custom Sound Files

To use custom sounds for cooldown completion:

1.  Navigate to your World of Warcraft installation directory.
2.  Go to `Interface\AddOns\asCooldownPulse\SpellSound\`.
3.  Place your custom `.mp3` files in this folder. The name of the file must match the exact spell name as it appears in the game (e.g., if the spell is "Fireball", the file should be `Fireball.mp3`).
    *   The addon also includes a file named `'스펠명.mp3'파일을 만들면 쿨 완료시 안내 됩니다.txt` in this directory (which translates to "If you create a 'spellname.mp3' file, you will be notified when the cooldown is complete.txt"), further guiding this process.

## Author

*   Aspilla

---

# asCooldownPulse

![asCooldownPulse_screenshot_placeholder](https://github.com/aspilla/asMOD/blob/main/.Pictures/asCooldownPulse_screenshot_placeholder.png?raw=true)

asCooldownPulse는 월드 오브 워크래프트 애드온으로, 주문 및 아이템의 재사용 대기시간을 간단하고 효과적으로 추적할 수 있는 기능을 제공합니다. 시각적 신호와 오디오 알림을 통해 능력 관리를 효율적으로 할 수 있도록 도와줍니다.

## 주요 기능

*   **시각적 재사용 대기시간 추적:** 현재 재사용 대기시간 중인 주문 및 아이템의 아이콘을 표시합니다. 1.5초 이상 재사용 대기시간을 가진 기술이 다시 사용 가능해지기 0.5초 전에 경고를 제공합니다.
*   **표시 설정 가능:** 아이콘 크기, 화면 위치, 행당 표시되는 재사용 대기시간 아이콘 수를 사용자 정의할 수 있습니다. (이러한 세부 사항은 일반적으로 `asCooldownPulse.lua` 파일 상단의 `ACDP_CoolButtons_X`, `ACDP_CoolButtons_Y`, `ACDP_SIZE`, `ACDP_CooldownCount`와 같은 코드 내 변수를 통해 조정됩니다.)
*   **오디오 알림:** 중요한 재사용 대기시간(15초 이상 기술 및 차단/해제 기술)이 곧 완료될 때 소리로 알려줍니다. 이는 `SoundCooldown` 옵션을 통해 설정할 수 있습니다.
*   **텍스트 음성 변환 (TTS):** 재사용 대기시간 완료 시 TTS(Text-to-Speech) 안내 옵션을 제공합니다.
*   **재사용 대기시간 필터링:** 추적할 최소 및 최대 재사용 대기시간을 설정할 수 있습니다 (예: `asCooldownPulse.lua`의 `CONFIG_MINCOOL`, `CONFIG_MAXCOOL`). 최대 재사용 대기시간 추적 시간은 5분입니다. 소환수 기술의 경우, 20초 이상의 재사용 대기시간만 추적합니다.
*   **asMOD 연동:** "asMOD" 시리즈의 다른 애드온과 함께 작동합니다. `asMOD` 애드온이 설치되어 있는 경우, asCooldownPulse의 아이콘 목록 위치를 `asMOD`의 `/asConfig` 명령어를 통해 사용자가 직접 이동하고 저장할 수 있도록 지원합니다. asCombatInfo와 함께 사용 시, 화면 하단에 최근 사용된 기술 중 재사용 대기시간이 있는 6개 기술을 표시합니다. asCombatInfo에 의해 이미 표시된 기술의 재사용 대기시간은 asCooldownPulse에 표시되지 않습니다.

## 설정

asCooldownPulse의 주요 설정은 게임 내 애드온 설정 패널을 통해 이루어집니다. `ESC -> 설정 -> 애드온 -> asCooldownPulse`로 이동하여 접근할 수 있습니다.

사용 가능한 옵션은 다음과 같습니다:

*   **PlaySound**: 재사용 대기시간 완료 시 음성 알림을 활성화하거나 비활성화합니다. (기본값: true)
*   **AlwaysShowButtons**: true일 경우, 재사용 대기시간 목록이 항상 표시됩니다. 그렇지 않으면 특정 조건(예: asCombatInfo에서 숨김으로 설정된 경우)에서는 숨겨질 수 있습니다. (기본값: false)
*   **SoundVolume**: 음성 알림 볼륨을 설정합니다 (0-100). (기본값: 50)
*   **SoundCooldown**: 음성 알림을 발생시킬 주문/아이템의 최소 재사용 대기시간(초)입니다. (기본값: 15초). (차단/해제 기술 포함)
*   **EnableTTS**: 재사용 대기시간 안내를 위한 TTS를 활성화하거나 비활성화합니다. (기본값: true)
*   **SlotNameTTS**: TTS가 활성화된 경우, 아이템에 대해 아이템/주문 이름 대신 아이템 착용 부위 이름(예: "장신구 1")을 안내합니다. (기본값: true)
*   **TTS_ID**: 사용할 TTS 음성을 선택합니다. koKR 클라이언트의 경우 한국어 음성을, 기타 클라이언트의 경우 영어 음성을 자동으로 선택하려고 시도합니다.
*   **Aware_ASMOD_Cooldown**: asCombatInfo와 같은 다른 asMOD 구성요소와 통합될 때 음성 알림을 위한 재사용 대기시간 임계값(초)입니다. (기본값: 5초)
*   **Aware_PowerBar**: true일 경우, asPowerBar에서 관리하는 주문에 대한 음성 알림이 중복 소리를 피하기 위해 억제될 수 있습니다. (기본값: true)

아이콘 위치(`ACDP_CoolButtons_X`, `ACDP_CoolButtons_Y`), 아이콘 크기(`ACDP_SIZE`), 행당 아이콘 수(`ACDP_CooldownCount`)와 같은 일부 시각적 요소는 주로 `asCooldownPulse.lua` 파일 상단의 변수를 통해 관리됩니다.

사용 설명은 아래 비디오를 참고하십시오.

## 사용자 정의 사운드 파일

레거시 방법(.mp3 파일을 Sound 폴더에 사용하는 방식)을 사용하려면, 옵션에서 `EnableTTS`를 비활성화하십시오. `EnableTTS`를 비활성화하면 Sound 폴더에 "스킬이름.mp3" 형식의 파일을 넣어 사용자 정의 스킬 재사용 대기시간 오디오 알림을 만들 수 있습니다.

재사용 대기시간 완료 시 사용자 정의 사운드를 사용하려면:

1.  월드 오브 워크래프트 설치 디렉토리로 이동합니다.
2.  `Interface\AddOns\asCooldownPulse\SpellSound\`로 이동합니다.
3.  이 폴더에 사용자 정의 `.mp3` 파일을 넣습니다. 파일 이름은 게임 내에 표시되는 정확한 주문 이름과 일치해야 합니다 (예: 주문 이름이 "화염구"라면 파일은 `화염구.mp3`여야 합니다).
    *   애드온에는 이 디렉토리에 `'스펠명.mp3'파일을 만들면 쿨 완료시 안내 됩니다.txt`라는 파일도 포함되어 있어 (이는 "스펠명.mp3 파일을 만들면 쿨 완료 시 안내됩니다.txt"로 번역됨) 이 과정을 안내합니다.

## 오디오 알림 관련 중요 참고 사항
*   오디오 알림에 문제가 있는 경우, `ESC (Esc) > 설정 > 개인 정보 보호 설정`을 확인하십시오.
*   애드온이 TTS(텍스트 음성 변환)를 자동으로 설정하지만, 소리가 나지 않는 경우 설정에서 TTS 음성을 수동으로 선택할 수 있습니다.
*   소리가 다른 오디오 장치로 나오는 경우, Windows 설정 >> 접근성 >> 내레이터의 출력 장치를 확인하십시오.

## 제작자

*   Aspilla
