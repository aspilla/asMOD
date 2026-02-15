# asReady

Displays interrupt and major cooldown timers for party and raid members.

## Main Features

### Party
*   Displays party members' interrupt cooldowns as bars at the top of the frame.
*   Displays party members' major damage cooldowns on the left/bottom (if the frame is horizontal) of the frame.
*   Uses OpenRaid Library to check party members' cooldowns. This usually works for users who have the Details! damage meter addon. Cooldowns for skills not supported by the library may not be tracked accurately.
![asReady_party](https://github.com/aspilla/asMOD/blob/main/.Pictures/asReady_party.jpg?raw=true)

### Raid

*   Displays raid members' major damage cooldowns on the top-left of the frame.
![asReady_raid](https://github.com/aspilla/asMOD/blob/main/.Pictures/asReady_raid.jpg?raw=true)

## Settings

Can be configured in `ESC` > `Options` > `AddOns` > `asReady`
    *   **`ShowPartyInterrupt`**: Show/hide the party interrupt cooldown bar (Default: true)
    *   **`ShowPartyCool`**: Show/hide offensive cooldowns on party unit frames (Default: true)
    *   **`ShowRaidCool`**: Show/hide offensive cooldowns on raid unit frames (Default: true)
    

The party interrupt frame position can be adjusted with the `/asConfig` command when using `asMOD`.

---

# asReady

파티 및 공격대원의 차단 및 핵심 쿨기 대기시간을 표시

## 주요 기능

### 파티 
*   파티원의 차단 스킬 쿨을 바 형태로 프레임 상단에 표시
*   파티원의 핵심 딜 쿨기를 프레임 좌측/하단(프레임이 수평일 경우)에 표시 
*   쿨기 확인시 OpenRaid Libary를 활용하여 파티원의 스킬 쿨을 확인합니다. 보통 Details 데미지 미터를 사용하는 유저이면 쿨기 추적이 가능합니다. Library에서 지원하지 않는 스킬 쿨은 정확하게 추적이 안될 수 있습니다.
![asReady_party](https://github.com/aspilla/asMOD/blob/main/.Pictures/asReady_party.jpg?raw=true)

### 공격대 

*   공격대원의 핵심 딜 쿨기를 프레임 좌상단에 표시
![asReady_raid](https://github.com/aspilla/asMOD/blob/main/.Pictures/asReady_raid.jpg?raw=true)

## 설정

`ESC` > `설정` > `애드온` > `asReady` 에서 설정 가능
    *   **`ShowPartyInterrupt`**: 파티 차단 기술 재사용 대기시간 바 표시 여부 (기본값: true)
    *   **`ShowPartyCool`**: 파티 유닛 프레임에 공격 관련 재사용 대기시간 표시 여부 (기본값: true)
    *   **`ShowRaidCool`**: 공격대 유닛 프레임에 공격 관련 재사용 대기시간 표시 여부 (기본값: true)
    

파티 차단 프레임은 `asMOD` 사용시 `/asConfig` 명령으로 위치 설정 가능
