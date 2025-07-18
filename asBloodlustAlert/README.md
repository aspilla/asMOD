# asBloodlustAlert

Notifies you when the Bloodlust/Heroism debuff wears off and the ability is ready to be used again.
![asBloodlustAlert](https://github.com/aspilla/asMOD/blob/main/.Pictures/asBloodlustAlert.jpg?raw=true)
<iframe width="560" height="315" src="https://www.youtube.com/embed/d35btvURBmU?si=cPgOacVHCsvlE6jz" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" referrerpolicy="strict-origin-when-cross-origin" allowfullscreen></iframe>

## Features

*   Announces "Bloodlust Ready" in the general chat window.
*   Provides a voice alert saying "Bloodlust Ready".
*   Only active while in a party within a dungeon. (Can be enabled for raids via the `InRaid` option, default is Off).
*   By default, it only activates for classes that can cast Bloodlust/Heroism. (This can be changed with the `ClassOnly` option).
*   Triggers only when the debuff expires naturally (i.e., its duration goes from 1 second to 0).
*   It will not trigger if the debuff is removed by other means (e.g., reset).

## Configuration

*   Go to `ESC` > `Settings` > `AddOns` tab and find `asBloodlustAlert` to change settings.
*   `ClassOnly`: If true, only alerts for classes that can cast Bloodlust/Heroism. (Default: true)
*   `InRaid`: If true, provides alerts during raids. (Default: false)
*   `VoiceAlert`: If true, provides a voice alert. (Default: true)

---

# asBloodlustAlert

블러드 사용 불가 디버프가 사라저 준비 되면 알림니다.
![asBloodlustAlert](https://github.com/aspilla/asMOD/blob/main/.Pictures/asBloodlustAlert.jpg?raw=true)
<iframe width="560" height="315" src="https://www.youtube.com/embed/d35btvURBmU?si=cPgOacVHCsvlE6jz" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" referrerpolicy="strict-origin-when-cross-origin" allowfullscreen></iframe>

## 기능

*   일반 챗창으로 "블러드 준비"라고 알립니다.
*   음성으로 "Bloodlust Ready"라고 알립니다.
*   던전 안에서 파티 중일때만 동작 합니다. (InRaid 옵션으로 공격대때 알림 가능, 기본 Off)
*   블러드 사용 가능 클만 동작 합니다. (ClassOnly 옵션을 끄면 전체 클래스 알림)
*   블러드 디버프가 시간이 완료되어 사라지는 경우(지속 시간이 1초 에서 0초로 변경될때)만 알립니다.
*   그외 Reset등으로 디버프가 사라지는 경우는 알리지 않습니다.

## 설정

*   `ESC` > `설정` > `애드온` 탭에서 `asBloodlustAlert`를 찾아 옵션을 변경할 수 있습니다.
*   `ClassOnly` 블러드 사용 가능 클래스만 알립니다. (기본 true)
*   `InRaid` 레이드시 알립니다. (기본 false)
*   `VoiceAlert` 음성으로 알립니다. (기본 true)