# asBloodlustAlert (Midnight)

Notifies the Bloodlust/Heroism window.
![asBloodlustAlert](https://media.forgecdn.net/attachments/1667/60/asbloodlustalert2-jpg.jpg)

Notifies when Bloodlust is ready to use after the exhaustion debuff expires.
![asBloodlustAlert](https://media.forgecdn.net/attachments/1640/484/asbloodlustalert-jpg.jpg)

## Features

* Displays "Bloodlust Start" in the center of the screen.
* Provides a voice alert: "Bloodlust Start."
* Displays the remaining duration of Bloodlust in the bottom-left corner.

* Displays "Bloodlust Ready" in the center of the screen.
* Provides a voice alert: "Bloodlust Ready."
* Only notifies when the Bloodlust debuff expires naturally (when the remaining duration changes from 1 second to 0).
* Does not notify if the debuff is removed by other means, such as a reset.

## Configuration

* The text displayed in the center of the screen can be moved.
* **Move Position**: Enter the `/asConfig` command in the chat window.
* **Reset Position**: Enter the `/asClear` command in the chat window to reset to default settings.

* Options can be changed by navigating to `ESC` > `Options` > `AddOns` > `asBloodlustAlert`.
* `StartAlert`: Notifies when Bloodlust starts (Default: true).
* `ShowBuff`: Displays the Bloodlust duration as a button (Default: true).
* `ReadyAlert`: Notifies when Bloodlust is ready (Default: true).
* `VoiceAlert`: Provides voice alerts (Default: true).
* `FontSize`: Font size for the "Bloodlust Ready" text (Default: 30).
* `ShowTime`: Display duration for the "Bloodlust Ready" text (Default: 2 seconds).

---

# asBloodlustAlert (한밤)

블러드 구간을 알립니다.
![asBloodlustAlert](https://media.forgecdn.net/attachments/1667/60/asbloodlustalert2-jpg.jpg)

블러드 사용 불가 디버프가 사라저 블러드 사용이 준비 되면 알림니다.
![asBloodlustAlert](https://media.forgecdn.net/attachments/1640/484/asbloodlustalert-jpg.jpg)


## 기능

*   화면 중앙에 "블러드 시작"라고 알립니다.
*   음성으로 "블러드 시작"라고 알립니다.
*   블러드 지속시간을 좌측 하단에 알립니다.

*   화면 중앙에 "블러드 준비"라고 알립니다.
*   음성으로 "블러드 준비"라고 알립니다.
*   블러드 디버프가 시간이 완료되어 사라지는 경우(지속 시간이 1초 에서 0초로 변경될때)만 알립니다.
*   그외 Reset등으로 디버프가 사라지는 경우는 알리지 않습니다.

## 설정

*  화면 중앙에 표시되는 글씨는 이동이 가능합니다.
*  **위치 이동** : `/asConfig` 명령어 채팅창에 입력
*  **위치 초기화** : `/asClear` 명령어 채팅창에 입력, 기본 설정으로 초기화 

*   `ESC` > `설정` > `애드온` 탭에서 `asBloodlustAlert`를 찾아 옵션을 변경할 수 있습니다.
*   `StartAlert` 블러드 시작됨을 알립니다. (기본 true)
*   `ShowBuff` 블러드 지속시간을 버튼으로 알립니다. (기본 true)
*   `ReadyAlert` 블러드 준비됨을 알립니다. (기본 true)
*   `VoiceAlert` 음성으로 알립니다. (기본 true)
*   `FontSize` "블러드 준비" 글씨 크기 (기본 30)
*   `ShowTime` "블러드 준비" 표시 시간 (기본 2초)