# asNamePlates (Midnight)

Nameplate enhancement addon

![sample](https://github.com/aspilla/asMOD/blob/main/.Pictures/asNamePlates_MN.jpg?raw=true)

**Note:** Friendly nameplates are not modified.

## Nameplate Color Customization
Colors are displayed based on the following priority:

* <span style = "background-color:#6633cc">**Purple:**</span> High Threat Level (DPS/Healer)
* <span style = "background-color:#ff8080">**Light Red:**</span> Low Threat Level (Tank)
* <span style = "background-color:#ccff99">**Light Green:**</span> Casting an interruptible spell
* <span style = "background-color:#e6e6e6">**Gray:**</span> Casting a non-interruptible spell
* <span style = "background-color:#ff80ff">**Pink:**</span> Your debuff is present
* <span style = "background-color:#80ffff">**Sky Blue:**</span> Normal Threat Level
* <span style = "background-color:#00ff33">**Green:**</span> Boss (Inside dungeons, high-level or ?? level mobs)
* <span style = "background-color:#ffcc80">**Ocher:**</span> Caster mobs (Inside dungeons) or Quest mobs (World)

## Other Features

* **Vertical Overlap Adjustment (`nameplateOverlapV`)**: Set to 1.1 by default.
* **Mouseover Indicator**: Displays a green arrow at the bottom of the mouseover target.
* **Target Power Display**: Shows mob energy below the health bar if it's not mana (`ShowPower`).
* **Cast Icon Display**: Displays the skill icon while casting (`ShowCastIcon`).
* **Aura Adjustment**: Adjusts buff/debuff duration/stack position and adds borders (`ChangeDebuffIcon`).
* **Texture and Border Customization (`ChangeTexture`)**: Displays a white border for the current target and a green border for the focus target. Changes health bars to a rectangular shape.
* **Targeted Highlight (`ShowTargeted`)**: Displays a blinking exclamation mark on the left when you are targeted. For tanks, this only triggers when a mob is casting at you.
* **Important Spell Alert (`AlertImportantSpell`)**: The health bar flashes red when an important spell is being cast (see screenshot below).
![sample](https://github.com/aspilla/asMOD/blob/main/.Pictures/asNamePlates_important.gif?raw=true)
* **Setup Macro Creation**: Adjusts target nameplate size and sets friendly nameplates to show class colors. Use the `asNamePlates Setup` macro and ensure the `Simplified Friendly Nameplates` option is set to OFF.
![sample](https://github.com/aspilla/asMOD/blob/main/.Pictures/asNameplates_friend.jpg?raw=true)

## Configuration
* `ESC > Options > AddOns > asNamePlates`
* You can toggle color-changing features and customize colors here.

---

# asNamePlates (한밤)

이름표 강화 애드온

![sample](https://github.com/aspilla/asMOD/blob/main/.Pictures/asNamePlates_MN.jpg?raw=true)

**참고:** 우호적인 대상의 이름표는 수정하지 않습니다.

## 이름표 색상 변경 기능
다음의 우선 순위로 표시 됨

  * <span style = "background-color:#6633cc">**보라색:**</span> 높은 위협 수준 (딜러/힐러)  
  * <span style = "background-color:#ff8080">**밝은빨간색:**</span> 낮은 위협 수준 (탱커)
  * <span style = "background-color:#ccff99">**연녹색:**</span> 차단 가능한 주문을 시전
  * <span style = "background-color:#e6e6e6">**회색:**</span> 차단 불가 주문을 시전  
  * <span style = "background-color:#ff80ff">**핑크:**</span> 내 디버프가 있음
  * <span style = "background-color:#80ffff">**하늘색:**</span> 일반 위협 수준
  * <span style = "background-color:#00ff33">**녹색:**</span> 보스몹 (던전인 경우, 레벨에 높거(예 91렙)나 ?? 레벨몹)
  * <span style = "background-color:#ffcc80">**황토색:**</span> 케스터 몹 (던전인 경우), 퀘스트 몹 (필드).
  
## 기타 기능

* **이름표 세로 정렬 간격 설정(`nameplateOverlapV`)** : 1.1을 기본으로 설정
* **마우스오버 대상 녹색 화살표 하단 표시**
* **대상의 경우 몹의 기력을 체력바 아래 표시 (마나가 아닐 경우, `ShowPower`)**
* **시전중일 경우 스킬 아이콘 표시 (마나가 아닐 경우, `ShowCastIcon`)**
* **버프/디버프 시간/중첩 위치 조정 및 테두리 추가 (`ChangeDebuffIcon`)**
* **이름표 Texture 및 테두리 변경 (`ChangeTexture`)** : 대상의 경우 흰색 테두리, 주시의 경우 녹색 테두리 표시, 생명력바를 사각형 모양으로 변경
* **Targeted 강조 (`ShowTargeted`)** : 나를 대상으로 하는 경우 좌측에 깜빡이는 느낌표 표시, 탱커의 경우 나를 대상으로 케스팅 하는 경우만
* **중요 스킬 강조 (`AlertImportantSpell`)** : 중요 스킬 시전시 생명력이 빨간색으로 깜빡임 (아래 스샷 참고)
![sample](https://github.com/aspilla/asMOD/blob/main/.Pictures/asNamePlates_important.gif?raw=true)
* **이름표 Setup 매크로 생성** : 대상 이름표 크기, 아군 이름표 직업 색상 이름으로 변경, `asNamePlates Setup` 메크로 사용 및 `아군 이름표 간소화 옵션` off 필요
![sample](https://github.com/aspilla/asMOD/blob/main/.Pictures/asNameplates_friend.jpg?raw=true)




## 설정
* `Esc > 옵션 > 애드온 > asNamePlates`
* 색상 변경 및 색상 변경 기능 On/Off 가능