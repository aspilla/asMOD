# asCooldownPulse (Midnight)

Displays icons for ready spell.

![asCooldownPulse](https://media.forgecdn.net/attachments/1764/762/ascooldownpulse-jpg.jpg)

## Key Features
- **Ability, Trinket, Potion, Racial, and Usable Item Notifications**: Skills registered in the spellbook (excluding stance/bundled abilities), racials, trinkets, potions, etc., after 15 seconds have elapsed since use (cooldown reductions caused by procs cannot be tracked).
- **Specialization-based Blacklist Filter**: Manage blacklisted spells and items per specialization. Unchecking an item removes it from ready alerts. When the blacklist option is enabled, minimum cooldown time is ignored and only non-blacklisted spells are alerted.
![asCooldownPulse](https://media.forgecdn.net/attachments/2267/597/ascooldownblacklist-jpg.jpg)
- **Voice Notifications(Default Off)**: Announces spell and item names via TTS voice. If you place a `SpellName.mp3` file inside the `SpellSound` folder in the addon directory and turn off the `Alert spell sound using TTS` option, you can customize sound alerts for specific skills. To use this feature, enable the `Sound notification for skill ready alert` option in the addon settings.
 
<iframe width="560" height="315" src="https://www.youtube.com/embed/DDT9QemuJIE?si=OK1inMFZmvS6PdkW" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" referrerpolicy="strict-origin-when-cross-origin" allowfullscreen></iframe>


## Configuration

- Accessible via `ESC` > `Options` > `AddOns` > `asCooldownPulse`.
  - The minimum time of cooldown to alert (Default: 15 seconds).
  - Use Blacklist (Ignore cooldown time) (Default: Off)
  - Blacklist Subcategory (`ESC` > `Options` > `AddOns` > `asCooldownPulse` > `Blacklist Settings`): View spells and items with icons and checkboxes. Uncheck to add to the blacklist. Managed independently per specialization.
  - Alert spell sound using TTS (Default: On)
  - TTS ID (Default: Zira)
  - Sound Volume (Default: 70)
  - Sound notification for skill ready alert (Default: Off)
  - Scale animation for alert button (Default: On)

- `/reload` is required after changing sizes.
- **Repositioning**: Enter the `/asconfig` command in the chat window.
- **Reset Position**: Enter the `/asclear` command in the chat window to reset to default settings.

## Contact Information

1.  **Korean Users:** Visit the [Inven asMOD Forum](https://www.inven.co.kr/board/wow/5288).
2.  **English Users:** Visit the [asMOD YouTube Channel](https://www.youtube.com/@asmod-wow) or [GitHub](https://github.com/aspilla/asMOD/).

---

# asCooldownPulse (한밤)

준비된 스킬 아이콘으로 알림

![asCooldownPulse](https://media.forgecdn.net/attachments/1764/762/ascooldownpulse-jpg.jpg)

## 주요 기능

- **스킬, 장신구, 물약, 종특, 사용가능 알림**: '스킬북`에 등록 된 스킬(묶음 형태 스킬 제외), 종특 장신구, 물약등, 사용 후 15초 이상 지났을 경우(발동 등에 의해 쿨이 줄어든 경우는 파악 불가)
- **전문화별 블랙리스트 관리**: 전문화(Spec)별로 스킬/아이템 블랙리스트를 개별 관리할 수 있습니다. 체크를 해제하면 알림에서 제외되며, `블랙리스트 사용` 옵션 활성화 시 최소 쿨다운 시간 설정을 3초로 설정 합니다.
![asCooldownPulse](https://media.forgecdn.net/attachments/2267/597/ascooldownblacklist-jpg.jpg)
- **음성 알림 (기본 off)**: 스킬 명 아이템 명을 TTS 음성으로 알림, 애드온 폴더내 `SpellSound` 폴더에 `스킬명.mp3` 파일 추가하고 `TTS 로 스킬 쿨 음성 알림` 옵션을 끄면 특정 스킬만 원하는 사운드로 알림 가능. 이 기능을 이용하기 위해서 `스킬 쿨다운시 알림음 재생` 옵션을 켜야 함.

<iframe width="560" height="315" src="https://www.youtube.com/embed/DDT9QemuJIE?si=OK1inMFZmvS6PdkW" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" referrerpolicy="strict-origin-when-cross-origin" allowfullscreen></iframe>

## 설정

- `ESC` > `설정` > `애드온` > `asCooldownPulse` 에서 설정 가능
  - 알림할 최소 쿨다운 시간(기본 15초)
  - 블랙리스트 사용 (쿨다운 시간 무시) (기본 Off)
  - 블랙리스트 설정 서브메뉴 (`ESC` > `설정` > `애드온` > `asCooldownPulse` > `블랙리스트 설정`): 스킬/아이템명, 아이콘 및 체크박스 목록 제공. 체크 해제 시 블랙리스트 등록 (알림 제외). 전문화(Spec)별로 독립 관리.
  - TTS 로 스킬 쿨 음성 알림 (기본 On)
  - TTS ID (기본 Heami)
  - 음성 크기 (기본 70)
  - 스킬 쿨다운시 알림음 재생 (기본 Off)
  - 알림시 크기 애니메이션 (기본 On)

- 크기 변경후 `/reload` 필요
- **위치 이동** : `/asConfig` 명령어 채팅창에 입력
- **위치 초기화** : `/asClear` 명령어 채팅창에 입력, 기본 설정으로 초기화

## 문의처

1. `한글 유저` : `인벤 asMOD 포럼` 방문 (https://www.inven.co.kr/board/wow/5288)
2. `영문 유저` : `Youtube asMOD 채널` 방문 (https://www.youtube.com/@asmod-wow), `Github` 방문 (https://github.com/aspilla/asMOD/)
