# 변경점
https://github.com/aspilla/asMOD/blob/main/ChangeLogs_kr.md

## 260611 update
### asNamePlates (신규 기능)
* **낮은 체력 대상 체력바 배경 색상 변경 (`낮은체력 배경 색상 표시`)**
  ![sample](https://media.forgecdn.net/attachments/1729/195/asnameplates_lowcolor-jpg.jpg)

| 직업          | 낮은 체력 (어두운 보라색)   |높은 체력  (어두운 파란색)  |
| ------------- | ----------- | -----------|
| 사냥꾼        | 마무리 사격(어둠 화살) 가능시 20%  | 어둠 화살 가능시 80%  |
| 전사        | 마무리 일격 20% (특성시 35%) |  |
| 마법사        | 불태우기 30% |  |
| 사제        |  죽음 20% |  |
| 죽기        |  영혼 수확자 35% |  |
| 파흑        |  어둠의 연소 20% |  |


## 260611 update
### asCompactRaidBuff
* 성능 개선

## 260610 update
### asGearScoreLite
* 오류 수정 : 다른 애드온과의 충돌 이슈 수정
>```lua
>Blizzard_InspectUI/InspectPVPFrame.lua:71: bad argument #1 to 'UnitFactionGroup' (Usage: local >?factionGroupTag, localized = UnitFactionGroup(unitName [, checkDisplayRace]))
>[string "=[C]"]: in function `UnitFactionGroup'
>[string "@Blizzard_InspectUI/InspectPVPFrame.lua"]:71: in function `InspectPVPFrame_Update'
>[string "@Blizzard_InspectUI/InspectPVPFrame.lua"]:60: in function <Blizzard_InspectUI/> InspectPVPFrame.lua:58>
>```

### asUnitFrame
* 성능개선

## 260608 update
### asNamePlates 
* 성능개선
* 오류 수정 : Minor 몹 클릭시 대상 선정이 안되는 이슈
* 신규 옵션 추가 
  > `[기능] 전투중 색상 표시(끄면 상위 어그로/어그로 상실만 표시)`, 기본 Off, 
  
  >(제작자 의견) 전투중 몹 색상 변경 보다, Mob Type 이 중요하다는 판단, 기존과 같이 동작하려면 Option On 필요


#### 신규 애드온 asCountdown
* 초읽기 음성 알림
* [링크](https://www.curseforge.com/wow/addons/ascountdown)

## 260605 update
### asCompactRaidBuff
* 오류수정, 성능개선

## 260604 update
### asCastBar, asPetAlert
* 오류 수정

## 260603 update

### asCompactRaidBuff
#### 신규 기능
![asCompactRaidBuff](https://media.forgecdn.net/attachments/1713/782/ascompactraidbuff-jpg.jpg)
* 힐러 HOT 색상변경 기능은 조만간 기능이 막힐 예정입니다. 12.0.7 까지는 정상 동작 확인 하였습니다.
*   `[색상] 힐러 HOT 버프시 색상 변경` : 버프 변경은 지원하지 않음 (기본: On)
   
   
| 직업          | 색상 변경   |
| ------------- | ----------- |
| 회복 드루이드 | 회복        |
| 신성 기사     | 고결의 봉화 |
| 수양 사제     | 속죄        |
| 신성 사제     | 소생        |
| 보존 기원사   | 메아리      |
| 복원 주술사   | 성난 해일   |
| 운무 수도사   | 소생의 안개 |
| 증강 기원사   | 예지        |

## 260601 update

### asCombatInfo, asNextSkill
* 성능 개선

### asScavenger
* 오류 수정

### asMOD
* 12.0.7 layout 적용