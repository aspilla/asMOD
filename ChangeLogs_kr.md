# 변경점

https://github.com/aspilla/asMOD/blob/main/ChangeLogs_kr.md

## 260904 update

### asCastBar
- 바가 부드럽게 표현되도록 수정 (옵션 추가)
- 부드러운 바, CPU 점유율 증가 (기본 On)

### asCooldownPulse
- 스킬 쿨 알림시 음성 알림 기능 추가 (설명서 확인)
- **음성 알림** 스킬 명 아이템 명을 TTS 음성으로 알림, 애드온 폴더내 `SpellSound` 폴더에 `스킬명.mp3` 파일 추가하고 `TTS 로 스킬 쿨 음성 알림` 옵션을 끄면 특정 스킬만 원하는 사운드로 알림 가능

## 260902/260903 update

### asCooldownPulse

- Bugfix

## 260901 update

### asCooldownPulse

- Bugfix : 일부 스킬 쿨이 안보이는 문제 수정

### asBattleRes

- 사용 가능 회수 다른 asMOD 애드온과 같은 녹색 중앙에 표시, 사용 불가시 회색으로 표시

## 260828 update

### asUnitFrame, asTargetCastBar

- 차단자 직업 색상 표시

### asCompactRaidBuff

- 공찾에서 파티원 변경이 있으면 렉이 일부 생기는 이슈 개선

## 260825 update

### asCompactRaidBuff (신규 기능)

![asCompactRaidBuff](https://media.forgecdn.net/attachments/1893/698/ascompactraidbuff-jpg.jpg)

- `[좌측] 힐러 HOT 버프시 남은 시간을 표시` : (기본: On)
- `[색상] 힐러 HOT 버프 Pandemic 시간에 색상 변경` : 적회색 (기본: On)
- `[크기] 남은 시간 글씨 크기` : (기본: 12)

<iframe width="560" height="315" src="https://www.youtube.com/embed/wQj2mbgynn4?si=T1uaYFFUNq8XyLrj" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" referrerpolicy="strict-origin-when-cross-origin" allowfullscreen></iframe>

## 260824 update

- asUnitFrame, asDebuffFilter, asBuffFilter, asDotFilter: 오류 수정 - 몹이 공격 불가에서 가능 변경시 다른 플레이어의 디버프도 보이는 이슈 개선
- asNamePlates : 오류 수정 - 비밀값 참조 가능성 개선

## 260823 update

- asDotFilter : 원하는 디버프를 추적하기 위한 옵션 추가, 사냥꾼 징표, 화법 디버프 추적 가능하도록 추가

## 260821 update

- asCooldownPulse : 10초 이상 쿨의 스킬만 재사용 알림(설정 가능)

## 260815_2 update

### asinterrupthelper

- 거리 및 스킬 쿨다운을 주기적으로 확인 안하는 이슈 개선

## 260815 update

### asCombatTimer

- 영문옵션 안나오는 이슈 수정
- 배경 숨기기 옵션 추가

### asCastBar

- 영문옵션 안나오는 이슈 수정

## 260814 update

- Bugfix asCooldownPulse, asFixChat, asInterruptHelper, asNextSkill, asPowerBar, asUnitFrame

## 260813 update

- asDebuffFilter (Private Aura 위치 수정)

## 260812 update

- Bugfix asBloodlustAlert, asBuffFilter, asCastBar, asDBMCastingAlert, asDebuffFilter, asDotFilter, asFixHotkey, asNamePlates, asSpamFilter, asUnitFrame

## 260811 update (12.1.0, 시즌 2 패치 지원)

### 주의사항, 이패치는 시즌 1에서는 정상 동작 하지 않습니다. 주간 점검이후 다운로드 받으세요.

### Layout 변경

- `재사용 대기시간 관리자` 신규 기능으로 장신구, 종특 추적이 가능하게 변경되어 중앙 주 버튼 개수를 기존 6개에서 8개로 변경
- asMOD Layout 및 애드온 전체적으로 위치가 변경됨
- `재사용 대기시간 관리자` 설정을 다시 하는것을 추천

### 애드온 설정 초기화

- Layout 변경으로 전체 애드온의 위치를 다시 조정 됩니다.
- 별도로 애드온 위치/옵션를 조정해서 사용하시는 분들은 번거롭지만 다시 위치/옵션을 조정하셔야 합니다.

### 애드온 설정 강화 및 설명으로 표시

- 애드온 설정이 조금 강화 되었습니다. 하지만 설정을 사용하지 않는것을 추천 합니다.
- 다시 강조 하지만 `asMOD`는 설정을 고려해서 만든 애드온은 아닙니다.

### asPowerBar

- 각 직업의 필수 버프 등이 강화됨
- `재사용 대기시간 관리자` 종속성이 사라져 asPowerBar 에 표시되는 버프/디버프는 `재사용 대기시간 관리자`에서 빼도 됨
- 상세한 내용은 설명서 참고

### asCooldownPulse

- `재사용 대기시간 관리자`에서 장신구, 종특, 물약 쿨 확인 이 가능하게 변경되어 기존 장신구 자리는 각 직업 생존기로 변경됨
- 장신구 종특 기능은 기본 Off 되며 옵션으로 다시 사용하게 할 수 있음
- 알고있는 오류) 일부 스킬의 쿨 시간이 표시 안됨.

### asDebuffFilter, asUnitFrame

- 블러드 디버프는 표시 하지 않음

### asDotFilter, asDebuffFilter

- 이름표에 표시 되는 주요 디버프 우선으로 이름순으로 정렬하여 표시 됨

### asCompactRaidBuff

- `재사용 대기시간 관리자` 에서 원하는 버프 설정이 가능하게 변경됨, 추가 설정 필요
- 상세한 내용은 설명서 참고

### asBloodlustAlert

- 블러드 디버프 시속시간을 회색 버튼으로 표시

### asCombatTimer

- 0.1 초 단위로 표시 됨

## 260719 update

### asPowerBar

- 부드러운 바 변경 Off 가능하도록 신규 설정 추가
- 연계점수가 사라질때 부르럽게 표현하도록 수정

### asDBMCastingAlert

- 신규 바가 생성 될때 바로 변경 되도록 개선

## 260717 update

### asCountdown

- 오류수정

## 260715 update

### asInterruptHelper

- 스킬의 쿨을 확인하여 쿨일 경우 다른 스킬을 안내 합니다.
- 스킬의 사용 가능 여부를 확인 합니다. 사용가능시 안내 합니다.
- 스킬이 사거리 밖일 경우 빨간색으로 표시 합니다.

### asDBMCastingAlert

- 오류 수정

## 260714 update

### asUnitFrame, asCastBar, asDBMCastingAlert, asTargetCastBar

- 바가 크게 변경될 경우 기민하게 반영하도록 수정

## 260707 update

### asPremadeGroupFilter (신규 기능)

![aspremadegroupsfilter_raid](https://media.forgecdn.net/attachments/1777/967/aspremadegroupfilterraid-jpg.jpg)

- 그룹에 있는 각 역할(탱커, 힐러, 근딜러, 원딜러) 내 각 직업의 수를 표시. (딜러의 경우 총합을 표시)

## 260706 update

### asTargetCastBar

- 주시대상 시전바의 크기 조정 방식을 배수 처리(Scale) 방식에서 크기 조정 방식으로 변경
- 크기 배율 설정 시 `/reload` 필요

## 260702 update

### asCooldownPulse

- asPowerBar 등록 스킬 안내 옵션 추가 (기본 On)
- 스킬이 변경 될 경우 변경 스킬로 안내되도록 수정

### asDBMCastingAlert

- 성능 개선

## 260630 update

### asCooldownPulse (New Feature)

- **스킬, 장신구, 물약, 종특, 사용가능 알림**: `재사용 대기시간 관리자`에 등록된 스킬, 착용중인 장신구, 전투/생존 대표 물약, 종특 사용가능시 화면 중앙에 알림
- 한밤 이후 변경된 API 를 사용한 기능으로 글쿨이 있는 스킬의 경우 늦게 알림이 될 수 있습니다.

<iframe width="560" height="315" src="https://www.youtube.com/embed/DDT9QemuJIE?si=OK1inMFZmvS6PdkW" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" referrerpolicy="strict-origin-when-cross-origin" allowfullscreen></iframe>

### asUnitFrame, asTargetCastBar, asCastBar

- 성능 개선

## 260628 update

### asFirestarter

- `가열` 특성시 30% 이하 체력의 대상일 경우 불태우기 아이콘 및 대상 체력 수치 표시

### asUnitFrame, asNameplates

- `가열` 특성 추가.

| 직업   | 낮은 체력 (어두운 보라색) | 높은 체력 (어두운 파란색) |
| ------ | ------------------------- | ------------------------- |
| 마법사 | 불태우기/가열 30%         | 방화광 90%                |

### asCountdown

- **쐐기 시작 타이머 음성 알림**

### asCombatTimer

- 기본 위치 이동, 30인 레이드 고려

## 260618 update

### asFixChat

- URL에서 +등 특수문자가 잘려 나오는 문제 수정

### Bugsack/BugGrabber

- 12.0.7 update

## 260617 update

### asHealthText

- 설정 추가
  **esc >> 설정 >> 애드온 >> asHealthText** 에서 설정 가능
- `생명력 소숫점 첫자리 표시` (기본 On)

### asDBMTimer

- 임무 아이콘 표시 추가
  ![asDBMTimer](https://media.forgecdn.net/attachments/1738/743/asdbmtimer-jpg.jpg)

5.  **역할 임무 아이콘 표시(탱커 등)** : 설정에서 Off 가능

### asInterruptHelper

- 포식악사 `공허 회오리` 추가

## 260615 update

### asPremadeGroupFilter, asCPUProfile, asGCDBar, asInterruptHelper, asRangeDisplay, asTrueGCD, asFixHotkey, asHideActionBars, asHideBagsBar, asMisdirection, asSpamFilter, asFixChat, asActiveAlert, asBuffFilter, asDotFilter

- 12.0.7 Toc 수정

### asSkyRide

- 오류 수정
- `전방 쇄도` 남은시간을 0.1초 단위로 표시

### asCooldownPulse

- 오크 흑마법사 종특 추가

## 260614 update

### asNamePlates

- 색상 설정이 잘 못 되었어도 오류가 안나도록 수정

### asUnitFrame

- 생명력 백분율이 소숫점 1자리까지 표시 되도록 수정
- 재작자 의견 - API 백분율 표시 방식이 자리내림으로 표시 되어 수숫점 표시로 정확도를 높이는것이 좋을것으로 생각됨
- 초상화 off 시 작은 색명력창에 징표 위치 수정
- 신규기능 : **낮은 체력 대상 체력바 배경 색상 변경 (`ShowLowHealth`)**

| 직업   | 낮은 체력 (어두운 보라색)    | 높은 체력 (어두운 파란색) |
| ------ | ---------------------------- | ------------------------- |
| 사냥꾼 | 마무리 사격(어둠 화살) 20%   | 어둠 화살 80%             |
| 전사   | 마무리 일격 20% (특성시 35%) |                           |
| 마법사 | 불태우기 30%                 | 방화광 90%                |
| 사제   | 죽음 20%                     |                           |
| 죽기   | 영혼 수확자 35%              |                           |
| 파흑   | 어둠의 연소 20%              |                           |

### asPowerBar

- 드루이드 수정, 표범폼일때만 연계점수가 보이도록 수정, 전특성 동일

### asHealthText

- 생명력 백분율이 소숫점 1자리까지 표시 되도록 수정
- 재작자 의견 - API 백분율 표시 방식이 자리내림으로 표시 되어 수숫점 표시로 정확도를 높이는것이 좋을것으로 생각됨

## 260613 update

### asNamePlates

- 낮은체력 배경 색상 표시에 화법 방화광 90% 추가

## 260612 update

### asCompactRaidBuff

- 오류수정 : 공격대내 같은 힐러가 있을때 버프 추적이 안되는 이슈 개선

### asNamePlates (신규 기능)

- **낮은 체력 대상 체력바 배경 색상 변경 (`낮은체력 배경 색상 표시`)**
  ![sample](https://media.forgecdn.net/attachments/1729/195/asnameplates_lowcolor-jpg.jpg)

| 직업   | 낮은 체력 (어두운 보라색)         | 높은 체력 (어두운 파란색) |
| ------ | --------------------------------- | ------------------------- |
| 사냥꾼 | 마무리 사격(어둠 화살) 가능시 20% | 어둠 화살 가능시 80%      |
| 전사   | 마무리 일격 20% (특성시 35%)      |                           |
| 마법사 | 불태우기 30%                      |                           |
| 사제   | 죽음 20%                          |                           |
| 죽기   | 영혼 수확자 35%                   |                           |
| 파흑   | 어둠의 연소 20%                   |                           |

## 260611 update

### asCompactRaidBuff

- 성능 개선

## 260610 update

### asGearScoreLite

- 오류 수정 : 다른 애드온과의 충돌 이슈 수정

> ```lua
> Blizzard_InspectUI/InspectPVPFrame.lua:71: bad argument #1 to 'UnitFactionGroup' (Usage: local >?factionGroupTag, localized = UnitFactionGroup(unitName [, checkDisplayRace]))
> [string "=[C]"]: in function `UnitFactionGroup'
> [string "@Blizzard_InspectUI/InspectPVPFrame.lua"]:71: in function `InspectPVPFrame_Update'
> [string "@Blizzard_InspectUI/InspectPVPFrame.lua"]:60: in function <Blizzard_InspectUI/> InspectPVPFrame.lua:58>
> ```

### asUnitFrame

- 성능개선

## 260608 update

### asNamePlates

- 성능개선
- 오류 수정 : Minor 몹 클릭시 대상 선정이 안되는 이슈
- 신규 옵션 추가

  > `[기능] 전투중 색상 표시(끄면 상위 어그로/어그로 상실만 표시)`, 기본 Off,

  > (제작자 의견) 전투중 몹 색상 변경 보다, Mob Type 이 중요하다는 판단, 기존과 같이 동작하려면 Option On 필요

#### 신규 애드온 asCountdown

- 초읽기 음성 알림
- [링크](https://www.curseforge.com/wow/addons/ascountdown)

## 260605 update

### asCompactRaidBuff

- 오류수정, 성능개선

## 260604 update

### asCastBar, asPetAlert

- 오류 수정

## 260603 update

### asCompactRaidBuff

#### 신규 기능

![asCompactRaidBuff](https://media.forgecdn.net/attachments/1713/782/ascompactraidbuff-jpg.jpg)

- 힐러 HOT 색상변경 기능은 조만간 기능이 막힐 예정입니다. 12.0.7 까지는 정상 동작 확인 하였습니다.
- `[색상] 힐러 HOT 버프시 색상 변경` : 버프 변경은 지원하지 않음 (기본: On)

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

- 성능 개선

### asScavenger

- 오류 수정

### asMOD

- 12.0.7 layout 적용
