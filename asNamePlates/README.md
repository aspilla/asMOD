# asNamePlates (Midnight)

Nameplate Enhancement Addon

![sample](https://github.com/aspilla/asMOD/blob/main/.Pictures/asNamePlates_MN.jpg?raw=true)

**Note:** Friendly nameplates are not modified.

## Nameplate Color Customization
Colors are displayed based on the following priority:

  * <span style = "background-color:#0000ff">**Blue:**</span> High threat level (DPS/Healer)  
  * <span style = "background-color:#ff0000">**Bright Red:**</span> Low threat level (Tank)
  * <span style = "background-color:#90ee90">**Light Green:**</span> Casting an interruptible spell
  * <span style = "background-color:#808080">**Gray:**</span> Casting an uninterruptible spell  
  * <span style = "background-color:#ff00ff">**Bright Purple:**</span> Affected by your debuff
  * <span style = "background-color:#87ceeb">**Sky Blue:**</span> Normal threat level
  * <span style = "background-color:#008000">**Green:**</span> Boss mobs (High level (e.g., 91+) or ?? level mobs)
  * <span style = "background-color:#b8860b">**Ochre:**</span> Quest mobs (When not in a party)

## Additional Features

* **Vertical Overlap Adjustment**: Configure the vertical spacing between nameplates (`nameplateOverlapV`).
* **Mouseover Indicator**: Displays a green arrow at the bottom of the mouseover target.
* **Target Power Display**: For your current target, displays the mob's energy below the health bar (if not using mana, `ShowPower`).
* **Cast Icons**: Displays the skill icon while a mob is casting (if not using mana, `ShowCastIcon`).
* **Aura Enhancements**: Adjusts the position of buff/debuff duration and stacks, and adds borders (`ChangeDebuffIcon`).
* **Visual Overhaul**: Changes the nameplate texture and borders (`ChangeTexture`).

## Configuration
* `Esc > Options > Addons > asNamePlates`

---

# asNamePlates (한밤)

이름표 강화 애드온

![sample](https://github.com/aspilla/asMOD/blob/main/.Pictures/asNamePlates_MN.jpg?raw=true)

**참고:** 우호적인 대상의 이름표는 수정하지 않습니다.

## 이름표 색상 변경 기능
다음의 우선 순위로 표시 됨

  * <span style = "background-color:#0000ff">**파란색:**</span> 높은 위협 수준 (딜러/힐러)  
  * <span style = "background-color:#ff0000">**밝은빨간색:**</span> 낮은 위협 수준 (탱커)
  * <span style = "background-color:#90ee90">**연녹색:**</span> 차단 가능한 주문을 시전
  * <span style = "background-color:#808080">**회색:**</span> 차단 불가 주문을 시전  
  * <span style = "background-color:#ff00ff">**밝은보라색:**</span> 내 디버프가 있음
  * <span style = "background-color:#87ceeb">**하늘색:**</span> 일반 위협 수준
  * <span style = "background-color:#008000">**녹색:**</span> 보스몹 (레벨에 높거(예 91렙)나 ?? 레벨몹)
  * <span style = "background-color:#b8860b">**황토색:**</span> 퀘스트 몹 (파티가 아닌경우).
  
## 기타 기능

* 이름표 세로 정렬 간격 설정(`nameplateOverlapV`) 
* 마우스오버 대상 녹색 화살표 하단 표시
* 대상의 경우 몹의 기력을 체력바 아래 표시 (마나가 아닐 경우, `ShowPower`)
* 시전중일 경우 스킬 아이콘 표시 (마나가 아닐 경우, `ShowCastIcon`)
* 버프/디버프 시간/중첩 위치 조정 및 테두리 추가 (`ChangeDebuffIcon`)
* 이름표 Texture 및 테두리 변경 (`ChangeTexture`)

## 설정
* `Esc > 옵션 > 애드온 > asNamePlates`