# asBloodlustAlert (Midnight)

Notifies you when the Bloodlust/Heroism exhaustion debuff expires and is ready for use again.
![asBloodlustAlert](https://media.forgecdn.net/attachments/1640/484/asbloodlustalert-jpg.jpg)

## Features

* Displays a "Bloodlust Ready" notification in the center of the screen.
* Plays a "Bloodlust Ready" voice alert.
* Only functions while in a party within a dungeon. (Can be enabled for Raids via the InRaid option, Default: Off)
* Only functions for classes capable of using Bloodlust by default. (Disable the ClassOnly option to enable for all classes)
* Notifies only when the debuff naturally expires (when the remaining duration changes from 1 second to 0).
* Does not notify if the debuff is removed via other means, such as a reset.

## Configuration

* The text displayed in the center of the screen can be moved.
* **Move Position**: Enter the `/asConfig` command in the chat window.
* **Reset Position**: Enter the `/asClear` command in the chat window to reset to default settings.

* You can change options via `ESC` > `Options` > `AddOns` > `asBloodlustAlert`.
* `ClassOnly`: Only notifies classes capable of using Bloodlust. (Default: true)
* `InRaid`: Enables notifications during Raids. (Default: false)
* `VoiceAlert`: Enables voice notifications. (Default: true)
* `FontSize`: Font size for the "Bloodlust Ready" text. (Default: 30)
* `ShowTime`: Duration the notification remains on screen. (Default: 2 seconds)

---

# asBloodlustAlert (한밤)

블러드 사용 불가 디버프가 사라저 준비 되면 알림니다.
![asBloodlustAlert](https://media.forgecdn.net/attachments/1640/484/asbloodlustalert-jpg.jpg)


## 기능

*   화면 중앙에 "블러드 준비"라고 알립니다.
*   음성으로 "블러드 준비"라고 알립니다.
*   던전 안에서 파티 중일때만 동작 합니다. (InRaid 옵션으로 공격대때 알림 가능, 기본 Off)
*   블러드 사용 가능 클만 동작 합니다. (ClassOnly 옵션을 끄면 전체 클래스 알림)
*   블러드 디버프가 시간이 완료되어 사라지는 경우(지속 시간이 1초 에서 0초로 변경될때)만 알립니다.
*   그외 Reset등으로 디버프가 사라지는 경우는 알리지 않습니다.

## 설정

*  화면 중앙에 표시되는 글씨는 이동이 가능합니다.
*  **위치 이동** : `/asConfig` 명령어 채팅창에 입력
*  **위치 초기화** : `/asClear` 명령어 채팅창에 입력, 기본 설정으로 초기화 

*   `ESC` > `설정` > `애드온` 탭에서 `asBloodlustAlert`를 찾아 옵션을 변경할 수 있습니다.
*   `ClassOnly` 블러드 사용 가능 클래스만 알립니다. (기본 true)
*   `InRaid` 레이드시 알립니다. (기본 false)
*   `VoiceAlert` 음성으로 알립니다. (기본 true)
*   `FontSize` "블러드 준비" 글씨 크기 (기본 30)
*   `ShowTime` "블러드 준비" 표시 시간 (기본 2초)