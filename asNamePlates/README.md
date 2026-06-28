# asNamePlates (Midnight)

Nameplate enhancement addon

![sample](https://media.forgecdn.net/attachments/1585/702/asnameplates_mn-jpg.jpg)

**Note:** Friendly nameplates are not modified.

## Nameplate Color Customization
Colors are displayed based on the following priority:

* <span style = "background-color:#6633cc">**Purple:**</span> High Threat Level (DPS/Healer)
* <span style = "background-color:#ff8080">**Light Red:**</span> Low Threat Level (Tank)
* <span style = "background-color:#ccff99">**Light Green:**</span> Casting an interruptible spell
* <span style = "background-color:#e6e6e6">**Gray:**</span> Casting a non-interruptible spell
* <span style = "background-color:#ff80ff">**Pink:**</span> Your debuff is present
* <span style = "background-color:#80ffff">**Sky Blue:**</span> Normal Threat Level (Default off, Need to turn on `[Feature] Show combat colors`)
* <span style = "background-color:#00ff33">**Green:**</span> Boss (Inside dungeons, high-level or ?? level mobs)
* <span style = "background-color:#ffcc80">**Ocher:**</span> Caster mobs (Inside dungeons) or Quest mobs (World)

## Other Features

* **Displays enemy power under the health bar for targeted units (Only when the resource is not mana, `[Feature] Show Power below`)**
* **Displays spell icons while casting (Only when the resource is not mana, `[Feature] Show cast icon`)**
* **Adjusts buff/debuff duration and stack counts position, and adds borders (`[Feature] Change Debuff Icon`)**
* **Modifies nameplate textures and borders (`[Feature] Change Texture`)**: Displays a white border for your current target, a green border for your focus target, and changes the health bar to a square shape.
* **Displays a blue border on mouseover targets (`[Feature] Change Texture`)**
* **Targeted Highlights (`[Feature] Alert Targeted`)**: Displays a flashing exclamation mark on the left when you are targeted by an enemy; for tanks, this triggers only when an enemy is casting a spell at you.
* **Important Spell Highlights (`[Feature] Alert Important Spell Casting`)**: The health bar flashes red when an enemy casts an important spell (See screenshot below).
![sample](https://github.com/aspilla/asMOD/blob/main/.Pictures/asNamePlates_important.gif?raw=true)

* **Modifies friendly nameplate settings (`[Feature] Change Friend Nameplates`)**: Alters friendly nameplates as shown below (Default: On, reapplied upon logging in).
![sample](https://media.forgecdn.net/attachments/1729/305/asnameplates_friend-jpg.jpg)
  
* **Nameplate Vertical Stacking Interval (`Nameplate vertical alignment`)**: Set to 1.1 by default (WoW default is 1.3).
* **Nameplate Selected Scale (`Nameplate target scale`)**: Set to 1.3 by default (WoW default is 1.2). 
* **Note:** If you uninstall the addon, you need to reset it using the following command: `/run SetCVar ("nameplateSelectedScale", 1.2)`

* **Nameplate Mouse Click Hitbox Settings (`Click Hit Inset`)**: See video below (Default: 7, reapplied upon logging in).
<iframe width="560" height="315" src="https://www.youtube.com/embed/b6vMuBdw2wM?si=6vJYKfkM_Y0L-cFE" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" referrerpolicy="strict-origin-when-cross-origin" allowfullscreen></iframe>

* **Changes the health bar background color for low health targets (`Display Low Health Background Color`)**
  ![sample](https://media.forgecdn.net/attachments/1729/195/asnameplates_lowcolor-jpg.jpg)

| Class | Low Health (Dark Purple) | High Health (Dark Blue) |
| ------------- | ----------- | -----------|
| Hunter | 20% for Kill Shot (Black Arrow) | 80% for Black Arrow |
| Warrior | 20% for Execute (35% with talent) | |
| Mage | 30% for Scorch/Scald | 90% for Firestarter |
| Priest | 20% for Shadow Word: Death | |
| Death Knight | 35% for Soul Reaper | |
| Destruction Warlock | 20% for Shadowburn | |



## Configuration
* `ESC > Options > AddOns > asNamePlates`
* You can toggle color-changing features and customize colors here.

## Recommended Nameplate Settings
* When selecting **FriendNamePlatesColor**, the "Simplify Friendly Nameplates" option must be turned **OFF**.
![sample](https://media.forgecdn.net/attachments/1600/308/i1643642077-jpg.jpg)
![sample](https://media.forgecdn.net/attachments/1600/307/i1897865702-jpg.jpg)
![sample](https://media.forgecdn.net/attachments/1600/306/i1527298036-jpg.jpg)

## Contact Information
1.  **Korean Users:** Visit the [Inven asMOD Forum](https://www.inven.co.kr/board/wow/5288).
2.  **English Users:** Visit the [asMOD YouTube Channel](https://www.youtube.com/@asmod-wow) or [GitHub](https://github.com/aspilla/asMOD/).

---

# asNamePlates (한밤)

이름표 강화 애드온

![sample](https://media.forgecdn.net/attachments/1585/702/asnameplates_mn-jpg.jpg)

**참고:** 우호적인 대상의 이름표는 수정하지 않습니다.

## 이름표 색상 변경 기능
다음의 우선 순위로 표시 됨

  * <span style = "background-color:#6633cc">**보라색:**</span> 높은 위협 수준 (딜러/힐러)  
  * <span style = "background-color:#ff8080">**밝은빨간색:**</span> 낮은 위협 수준 (탱커)
  * <span style = "background-color:#ccff99">**연녹색:**</span> 차단 가능한 주문을 시전
  * <span style = "background-color:#e6e6e6">**회색:**</span> 차단 불가 주문을 시전  
  * <span style = "background-color:#ff80ff">**핑크:**</span> 내 디버프가 있음
  * <span style = "background-color:#80ffff">**하늘색:**</span> 일반 위협 수준 (기본 off, '[기능] 전투중 색상 표시` On 필요)
  * <span style = "background-color:#00ff33">**녹색:**</span> 보스몹 (던전인 경우, 레벨에 높거(예 91렙)나 ?? 레벨몹)
  * <span style = "background-color:#ffcc80">**황토색:**</span> 케스터 몹 (던전인 경우), 퀘스트 몹 (필드).
  
## 기타 기능

* **대상의 경우 몹의 기력을 체력바 아래 표시 (마나가 아닐 경우, `[기능] 하단에 기력 표시`)**
* **시전중일 경우 스킬 아이콘 표시 (마나가 아닐 경우, `[기능] 시전 Icon 표시`)**
* **버프/디버프 시간/중첩 위치 조정 및 테두리 추가 (`[기능] Debuff Icon 변경`)**
* **이름표 Texture 및 테두리 변경 (`[기능] 이름표 모양 변경`)** : 대상의 경우 흰색 테두리, 주시의 경우 녹색 테두리 표시, 생명력바를 사각형 모양으로 변경
* **마우스오버 대상 파란색 테두리 표시 (`[기능] 이름표 모양 변경`)**
* **Targeted 강조 (`[기능] Targeted 강조`)** : 나를 대상으로 하는 경우 좌측에 깜빡이는 느낌표 표시, 탱커의 경우 나를 대상으로 케스팅 하는 경우만
* **중요 스킬 강조 (`[기능] 중요 스킬 시전 강조`)** : 중요 스킬 시전시 생명력이 빨간색으로 깜빡임 (아래 스샷 참고)
![sample](https://github.com/aspilla/asMOD/blob/main/.Pictures/asNamePlates_important.gif?raw=true)

* **아군 이름표 설정 변경 (`[기능] 아군 이름표 모양 변경`)** : 아군 이름표를 아래와 같이 변경 합니다. (기본 On, 접속시 다시 설정 합니다.)
![sample](https://media.forgecdn.net/attachments/1729/305/asnameplates_friend-jpg.jpg)
  
* **이름표 세로 정렬 간격 설정(`이름표 상하 정렬 정도`)** : 1.1을 기본으로 설정 (와우 기본 설정은 1.3)
* **이름표 주대상 크기 정도(`이름표 주대상 크기 정도`)** : 1.3을 기본으로 설정 (와우 기본 설정은 1.2) 
* **참고:** 애드온 삭제시 다음 명령어로 초기화 필요 `/run SetCVar ("nameplateSelectedScale", 1.2)`

* **이름표 마우스 클릭 범위 설정 (`클릭 Hit Inset`)** : 아래영상 참고  (기본 7, 접속시 다시 설정 합니다.)
<iframe width="560" height="315" src="https://www.youtube.com/embed/b6vMuBdw2wM?si=6vJYKfkM_Y0L-cFE" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" referrerpolicy="strict-origin-when-cross-origin" allowfullscreen></iframe>

* **낮은 체력 대상 체력바 배경 색상 변경 (`낮은체력 배경 색상 표시`)**
  ![sample](https://media.forgecdn.net/attachments/1729/195/asnameplates_lowcolor-jpg.jpg)

| 직업          | 낮은 체력 (어두운 보라색)   |높은 체력  (어두운 파란색)  |
| ------------- | ----------- | -----------|
| 사냥꾼        | 마무리 사격(어둠 화살) 20%  | 어둠 화살 80%  |
| 전사        | 마무리 일격 20% (특성시 35%) |  |
| 마법사        | 불태우기/가열 30% | 방화광 90%  |
| 사제        |  죽음 20% |  |
| 죽기        |  영혼 수확자 35% |  |
| 파흑        |  어둠의 연소 20% |  |



## 설정
* `Esc > 옵션 > 애드온 > asNamePlates`
* 색상 변경 및 색상 변경 기능 On/Off 가능

## 이름표 추천 설정
* `FriendNamePlatesColor` 선택시는 아군 이름표 간소화 옵션 off 필요
![sample](https://media.forgecdn.net/attachments/1600/308/i1643642077-jpg.jpg)
![sample](https://media.forgecdn.net/attachments/1600/307/i1897865702-jpg.jpg)
![sample](https://media.forgecdn.net/attachments/1600/306/i1527298036-jpg.jpg)

## 문의처
1. `한글 유저` : `인벤 asMOD 포럼` 방문 (https://www.inven.co.kr/board/wow/5288)
2. `영문 유저` : `Youtube asMOD 채널` 방문 (https://www.youtube.com/@asmod-wow), `Github` 방문 (https://github.com/aspilla/asMOD/)
