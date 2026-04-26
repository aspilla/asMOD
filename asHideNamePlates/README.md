# asHideNamePlates (Midnight)

Hides all nameplates except for mobs that are currently casting.

![asHideNamePlates](https://github.com/aspilla/asMOD/blob/main/.Pictures/asHideNamePlates.gif?raw=true)

<Example of `Auto Trigger`>

## Addon Activation Conditions

1. Settings can be adjusted in `ESC > Options > AddOns > asHideNamePlates`.
2. `Key Binding` (Default): The nameplate hiding feature is active while holding down the assigned hotkey. You can set the hotkey in `ESC > Options > Keybindings > asMOD > asHideNamePlates Key`.
3. `Auto Trigger`: Automatically activates when a mob begins casting (Note: Due to secret values, interruptibility cannot be determined).
4. `ALT + CTRL`: Activates when both ALT and CTRL keys are pressed simultaneously.
5. `ALT`: Activates when the ALT key is pressed.
6. `CTRL`: Activates when the CTRL key is pressed.
7. `SHIFT`: Activates when the SHIFT key is pressed.

## Nameplates That Remain Visible

1. Nameplates of your current Target or Focus target.
2. Nameplates of mobs that are currently casting.
3. For Tanks, nameplates of mobs for which you have lost aggro.

## Supported Nameplates
1. Default WoW Nameplates
2. asNamePlates

## Configuration
Settings can be changed via `ESC` > `Options` > `AddOns` > `asHideNamePlates`.
The following settings control whether nameplates of hostile targets in combat are hidden when they are not casting:

* `Alpha`: Adjust the transparency of hidden nameplates (Default: 0 for fully hidden, 1 for no hiding).
* `ShowBoss`: Boss mobs are always visible (Default: On).
* `ShowNoDebuff`: Mobs without your debuffs remain visible (Default: Off, intended for DoT classes).
* `HideMinusMob`: Hides non-essential/minor mobs (Default: On).
* `ShowPlayers`: Hostile players remain visible (Default: On).
* `WorkOnParty`: Functions while in a party (Default: On)
* `WorkOnRaid`: Functions during raids (Default: Off)
* `WorkOnSolo`: Functions during solo play (Default: Off)

## Contact Information
1.  **Korean Users:** Visit the [Inven asMOD Forum](https://www.inven.co.kr/board/wow/5288).
2.  **English Users:** Visit the [asMOD YouTube Channel](https://www.youtube.com/@asmod-wow) or [GitHub](https://github.com/aspilla/asMOD/).

---

# asHideNamePlates (한밤)

케스팅중인 몹 외 이름표를 숨김

![asHideNamePlates](https://github.com/aspilla/asMOD/blob/main/.Pictures/asHideNamePlates.gif?raw=true)

<`Auto Trigger` 예제>

## 애드온 동작 조건

1. `esc > 설정 > 애드온 > asHideNameplates` 에서 조정 가능
2. `Key Binding` (기본적 설정) : 단축키 누르고 있으면 이름표 숨김 기능이 동작. 단축키는 `esc > 옵션 > 단축키 설정 > asMOD > asHideNamePlates Key` 에서 지정 가능.
3. `Auto Trigger` : 몹이 케스팅을 하면 자동으로 동작. (차단 여부 비밀 값으로 파악 불가)
4. `ALT + CTRL` : ALT키 CTRL키를 동시에 누르면 동작.
5. `ALT` : ALT키를 누르면 동작.
6. `CTRL` : CTRL키를 누르면 동작.
7. `SHIFT` : SHIFT키를 누르면 동작.

## 숨겨지지 않고 표시 되는 이름표

1. 대상이나 주시 대상의 이름표는 표시.
2. 케스팅 중인 몹은 표시. 
3. 탱커의 경우 어그로를 놓친 몹의 이름표는 표시.

## 지원 이름표
1. 기본 이름표
2. asNamePlates

## 설정
`ESC` > `설정` > `애드온` > `asHideNamePlates` 에서 설정 변경 가능
아래 설정은 전투중인 적대적 대상이 케스팅 중일때 이름표 숨김 여부를 조정
* `Alpha` 숨김 정도 조정 (기본 0 완전 숨김 ~ 1 숨김 안함)
* `ShowBoss` 보스몹은 늘 보임 (기본 On)
* `ShowNoDebuff` 내 디버프가 없는 몹은 보임 (기본 Off, 도트 딜러용 옵션)
* `HideMinusMob` 중요하지 않은 몹은 숨김 (기본 On)
* `ShowPlayers` 적대적 대상의 경우 보임 (기본 On)
* `WorkOnParty` 파티시 동작 (기본 On)
* `WorkOnRaid` 레이드시 동작 (기본 Off)
* `WorkOnSolo` 솔로잉시 동작 (기본 Off)



## 문의처
1. `한글 유저` : `인벤 asMOD 포럼` 방문 (https://www.inven.co.kr/board/wow/5288)
2. `영문 유저` : `Youtube asMOD 채널` 방문 (https://www.youtube.com/@asmod-wow), `Github` 방문 (https://github.com/aspilla/asMOD/)