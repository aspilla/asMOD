# asCooldownPulse

asCooldownPulse tracks spell and item cooldowns, providing visual cues and audio alerts when they become available.

![asCooldownPulse](https://github.com/aspilla/asMOD/blob/main/.Pictures/asCooldownPulse.png?raw=true)

## Key Features

*   **Skill Readiness Tracking:** Displays icons for spells and items currently on cooldown. Provides a skill icon notification in the center of the screen 0.5 seconds before a skill with a cooldown of 1.5 seconds or more becomes available again.
*   **Audio Alerts:** Notifies you with a sound when important cooldowns (skills with 15+ second cooldowns and interrupt/dispell skills) are about to complete. Use the `SoundCooldown` option to set the minimum cooldown for alerts.
*   **Text-to-Speech (TTS):** Announces the skill name via TTS 0.5 seconds before the skill is ready.
*   **Cooldown Filtering:** Allows you to set minimum and maximum cooldowns to track (e.g., `CONFIG_MINCOOL`, `CONFIG_MAXCOOL` in `asCooldownPulse.lua`). The maximum cooldown tracking time is 5 minutes. For pet skills, only cooldowns of 20 seconds or more are tracked.
*   **asMOD Integration:** Works with other addons in the "asMOD" series. If the `asMOD` addon is installed, it allows users to move and save the position of asCooldownPulse's icon list via the `/asConfig` command in `asMOD`. When used with asCombatInfo, it displays the last 6 used skills with cooldowns at the bottom of the screen. Cooldowns for skills already displayed by asCombatInfo will not be shown in asCooldownPulse.

## Settings

The main settings for asCooldownPulse are configured through the in-game addon settings panel. You can access it by going to `ESC -> Settings -> AddOns -> asCooldownPulse`.

Available options include:

*   **PlaySound**: Enables or disables audio alerts when cooldowns complete. (Default: true)
*   **AlwaysShowButtons**: If true, the cooldown list will always be visible. Otherwise, it may be hidden under certain conditions (e.g., if set to hidden in asCombatInfo). (Default: false)
*   **SoundVolume**: Sets the volume for audio alerts (0-100). (Default: 50)
*   **SoundCooldown**: The minimum cooldown (in seconds) for a spell/item to trigger an audio alert. (Default: 15 seconds). (Includes interrupt/dispell skills)
*   **EnableTTS**: Enables or disables TTS for cooldown announcements. (Default: true)
*   **SlotNameTTS**: If TTS is enabled, announces the item slot name (e.g., "Trinket 1") for items instead of the item/spell name. (Default: true)
*   **TTS_ID**: Selects the TTS voice to use. It attempts to automatically select a Korean voice for koKR clients and an English voice for other clients.
*   **Aware_ASMOD_Cooldown**: The cooldown threshold (in seconds) for audio alerts when integrated with other asMOD components like asCombatInfo. (Default: 5 seconds)
*   **Aware_PowerBar**: If true, audio alerts for spells managed by asPowerBar may be suppressed to avoid duplicate sounds. (Default: true)

Additionally, some visual elements can be managed by editing the `asCooldownPulse.lua` file:

Icon position (`ACDP_CoolButtons_X`, `ACDP_CoolButtons_Y`), icon size (`ACDP_SIZE`), and number of icons per row (`ACDP_CooldownCount`) are primarily managed through variables at the top of the `asCooldownPulse.lua` file.

Please refer to the video below for usage instructions.

## Custom Sound Files

To use the legacy method (using .mp3 files in the Sound folder), disable `EnableTTS` in the options. If `EnableTTS` is disabled, you can create custom skill cooldown audio alerts by placing files in the format "SkillName.mp3" into the Sound folder.

To use custom sounds when cooldowns complete:

1.  Navigate to your World of Warcraft installation directory.
2.  Go to `Interface\AddOns\asCooldownPulse\SpellSound\`.
3.  Place your custom `.mp3` files in this folder. The file name must exactly match the spell name as it appears in-game (e.g., if the spell name is "Fireball", the file should be `Fireball.mp3`).

## Important Notes on Audio Notifications
*   If you are having issues with audio notifications, check `ESC (Esc) > Settings > Privacy Settings`.
*   Although the addon attempts to set up TTS (Text-to-Speech) automatically, if you don't hear any sound, you can manually select a TTS voice in the settings.
*   If the sound is coming out of a different audio device, check Windows Settings >> Accessibility >> Narrator's output device.

![asCooldownPulse2](https://github.com/aspilla/asMOD/blob/main/.Pictures/asCooldownPulse2.jpg?raw=true)

---

# asCooldownPulse

asCooldownPulse는 주문 및 아이템의 재사용 대기시간을 추적하고, 사용가능시 시각적 신호와 음성 알림을 수행 합니다.

![asCooldownPulse](https://github.com/aspilla/asMOD/blob/main/.Pictures/asCooldownPulse.png?raw=true)

## 주요 기능

*   **스킬 준비 추적:** 현재 재사용 대기시간 중인 주문 및 아이템의 아이콘을 표시합니다. 1.5초 이상 재사용 대기시간을 가진 기술이 다시 사용 가능해지기 0.5초 전에 화면 중앙에 스킬 아이콘 알림을 제공합니다.
*   **오디오 알림:** 중요한 재사용 대기시간(15초 이상 기술 및 차단/해제 기술)이 곧 완료될 때 소리로 알려줍니다. 알림이 되는 최소 대기시간 설정은 `SoundCooldown` 옵션을 사용하세요.
*   **텍스트 음성 변환 (TTS):** 스킬 준비 0.5초전 TTS(Text-to-Speech)로 스킬명을 낭독 합니다.
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

그외 `asCooldownPulse.lua` 파일 편집으로 다음의 설정이 가능합니다.

아이콘 위치(`ACDP_CoolButtons_X`, `ACDP_CoolButtons_Y`), 아이콘 크기(`ACDP_SIZE`), 행당 아이콘 수(`ACDP_CooldownCount`)와 같은 일부 시각적 요소는 주로 `asCooldownPulse.lua` 파일 상단의 변수를 통해 관리됩니다.

사용 설명은 아래 비디오를 참고하십시오.

## 사용자 정의 사운드 파일

레거시 방법(.mp3 파일을 Sound 폴더에 사용하는 방식)을 사용하려면, 옵션에서 `EnableTTS`를 비활성화하십시오. `EnableTTS`를 비활성화하면 Sound 폴더에 "스킬이름.mp3" 형식의 파일을 넣어 사용자 정의 스킬 재사용 대기시간 오디오 알림을 만들 수 있습니다.

재사용 대기시간 완료 시 사용자 정의 사운드를 사용하려면:

1.  월드 오브 워크래프트 설치 디렉토리로 이동합니다.
2.  `Interface\AddOns\asCooldownPulse\SpellSound\`로 이동합니다.
3.  이 폴더에 사용자 정의 `.mp3` 파일을 넣습니다. 파일 이름은 게임 내에 표시되는 정확한 주문 이름과 일치해야 합니다 (예: 주문 이름이 "화염구"라면 파일은 `화염구.mp3`여야 합니다).

## 오디오 알림 관련 중요 참고 사항
*   오디오 알림에 문제가 있는 경우, `ESC (Esc) > 설정 > 개인 정보 보호 설정`을 확인하십시오.
*   애드온이 TTS(텍스트 음성 변환)를 자동으로 설정하지만, 소리가 나지 않는 경우 설정에서 TTS 음성을 수동으로 선택할 수 있습니다.
*   소리가 다른 오디오 장치로 나오는 경우, Windows 설정 >> 접근성 >> 내레이터의 출력 장치를 확인하십시오.

![asCooldownPulse2](https://github.com/aspilla/asMOD/blob/main/.Pictures/asCooldownPulse2.jpg?raw=true)