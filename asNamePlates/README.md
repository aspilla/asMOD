# asNamePlates (Midnight)

Nameplate enhancement addon.

![sample](https://github.com/aspilla/asMOD/blob/main/.Pictures/asNamePlates_MN.jpg?raw=true)

**Note:** Friendly nameplates are not modified.

## Nameplate Color Coding
Colors are displayed based on the following priority:

* <span style = "background-color:#6633cc">**Purple:**</span> High threat level (DPS/Healer)  
* <span style = "background-color:#ff8080">**Light Red:**</span> Low threat level (Tank)
* <span style = "background-color:#ccff99">**Light Green:**</span> Casting an interruptible spell
* <span style = "background-color:#e6e6e6">**Gray:**</span> Casting an uninterruptible spell  
* <span style = "background-color:#ff80ff">**Pink:**</span> Target has your debuff active
* <span style = "background-color:#80ffff">**Sky Blue:**</span> Normal threat level
* <span style = "background-color:#00ff33">**Green:**</span> Boss mobs (Higher level than player or ?? level in dungeons)
* <span style = "background-color:#ffcc80">**Ocher:**</span> Caster mobs (Dungeons) or Quest mobs (World)
  
## Additional Features

* **Vertical Overlap Spacing (`nameplateOverlapV`)**: Set to 1.1 by default.
* **Mouseover Indicator**: Displays a green arrow below the mouseover target.
* **Power Bar Display (`ShowPower`)**: Displays the mob's secondary resource (if not Mana) below the health bar for the current target.
* **Cast Icon Display (`ShowCastIcon`)**: Displays skill icons during casts (if not Mana).
* **Aura Styling (`ChangeDebuffIcon`)**: Repositions buff/debuff duration and stack text and adds borders to icons.
* **Texture & Border Updates (`ChangeTexture`)**: Changes health bars to a rectangular shape. Displays a white border for your current target and a green border for your focus target.
* **Targeted Highlight (`ShowTargeted`)**: Displays a flashing exclamation mark on the left if you are the target. For tanks, this only triggers when a mob is casting a spell targeting you.
* **Important Spell Alert (`AlertImportantSpell`)**: The health bar flashes red when an important spell is being cast (see animation below).

![sample](https://github.com/aspilla/asMOD/blob/main/.Pictures/asNamePlates_important.gif?raw=true)

## Configuration
* `Esc > Options > Addons > asNamePlates`
* You can toggle individual features or customize the color settings.

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


## 설정
* `Esc > 옵션 > 애드온 > asNamePlates`
* 색상 변경 및 색상 변경 기능 On/Off 가능