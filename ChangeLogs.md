# ChangeLogs

## 260530 update

### asCombatInfo, asCompactRaidBuff, asCooldownPulse, asFixUnitFrame, asNamePlates
#### Performance improvement
---
#### 성능 개선


### asPowerBar
#### Frost mage shatter bugfix, performance improvement.
---
#### 냉법 빙결 오류 수정, 성능개선

### asScavenger260530

#### Fix when trashs are too many, it could not sell all.
---
#### 잡템이 많은경우 다 안팔리는 문제 수정


## 260529 update

### asNamePlates
#### Darkened the color for uninterruptible spell casts (Requires settings reset)
#### New Feature
* **Nameplate Mouse Click Hitbox Settings (`Click Hit Inset`)**: See video below (Default: 7, reapplied upon logging in).

---
#### 차단 불가 스킬 시전시 색상 좀더 어둡게 (설정 초기화 필요)
#### 신규 기능
* **이름표 마우스 클릭 범위 설정 (`클릭 Hit Inset`)** : 아래영상 참고  (기본 7, 접속시 다시 설정 합니다.)
<iframe width="560" height="315" src="https://www.youtube.com/embed/b6vMuBdw2wM?si=6vJYKfkM_Y0L-cFE" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" referrerpolicy="strict-origin-when-cross-origin" allowfullscreen></iframe>


### asTargetCastBar, asUnitFrame, asCastBar, asDBMCastingAlert

#### Smoothed the cast bar animation and slightly darkened the color for uninterruptible spell casts.
---
#### 시전바를 부드럽게 개선, 차단 불가 스킬 색상 조금 어둡게 

### asCooldownPulse
#### Improved Arcane Torrent visibility for classes where the Blood Elf racial ability was not showing properly.
---
#### 블러드 엘브 비전 격류 안보이는 직업 개선

### asDebuffFilter

#### Adjusted the Private Aura borders (now appears as a square)
---
#### PrivateAura 테두리 조정 (정사각형으로 보임)

### asCastingAlert, asHideNamePlates
#### Bugfix

---

#### 오류 수정


## 260528 update

### asCooldownPulse
#### Adding Orc Warlock/Shaman, Bloodelf Rogue Racial Skill

---

#### 오크흑마/주술사, 블엘도적 동특 등록


## 260527 update

### asTargetCastBar, asUnitFrame
#### Bugfix

---

#### 오류 수정

## 260526 update

### asPetAlert
#### Bugfix

---

#### 오류 수정

### asPowerBar
#### Devourer DH Improvements

---

#### 포식 악사 개선


---
### 신규 애드온, asPetAlert
https://www.curseforge.com/wow/addons/aspetalert

### asBloodlustAlert, asTargetCastBar, asUnitFrame 
#### 오류 수정


## 260525 update

### New Addon, asPetAlert
https://www.curseforge.com/wow/addons/aspetalert

### asBloodlustAlert, asTargetCastBar, asUnitFrame 
#### Bugfix

---
### 신규 애드온, asPetAlert
https://www.curseforge.com/wow/addons/aspetalert

### asBloodlustAlert, asTargetCastBar, asUnitFrame 
#### 오류 수정


## 260524 update

### asCastBar
#### Bugfix
---
#### 오류 수정


## 260523 update

### asCastBar
#### New feature: Simple Design Mode (Default On)
#### Bugfix
---
#### 신규 기능 : Simple Design Mode (기본 On)
#### 오류 수정



## 260520 update

<iframe width="560" height="315" src="https://www.youtube.com/embed/V8kfo_yETjs?si=fv80oB87gZDmaLL9" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" referrerpolicy="strict-origin-when-cross-origin" allowfullscreen></iframe>

### asCastBar
#### New feature: Simple Design Mode
![asCastBar](https://media.forgecdn.net/attachments/1690/241/ascastbar-jpg.jpg)

1. **Apply Simple Design**: Currently in Beta Test and disabled by default. Requires checking `SimpleDesign` in the settings.
2. **Channeling Tick Display**: Supports Mind Flay / Mind Flay: Insanity (Shadow Priest), Arcane Missiles (Mage), and Drain Soul (Warlock).

---
#### 신규 기능 : Simple Design Mode
1.  **Simple Design 적용** : 현재 Beta Test 중으로 기본 off 되어 있음, 설정에서 SimpleDesign 채크 필요
2.  **채널링 Tick 표시**  : 정신 채찍/정신 채찍 광기(암사), 신비한 화살(마법사), 영혼흡수(흑마) 지원


### asCompactRaidBuff

#### New feature
* **Party/Raid Leader Display (Top-Left)**
* `ShowLeader`: Displays the party/raid leader icon (Default: On).

---

#### 신규 기능
*   **파티/공격대 리더 표시 (좌상단)**
*   `ShowLeader` : 파티/공격대 리버더 표시 (기본: On)


### asNamePlates

#### Bug Fix: Resolved an issue where new options might not function properly.

---

#### 오류 수정 : 신규 옵션이 정상 동작 안할 수 있는 이슈 해결

### asPowerBar

#### Bug Fix: Fixed an issue where the cooldown was not announced for skills with a single charge.

---

#### 오류 수정 : 1충전 스킬인 경우 쿨 안내가 안되는 문제 수정


### asTargetCastBar/asUnitFrame

#### Bug Fix: Fixed an issue where the Evoker empowerment skill cast notifications were displayed incorrectly.

---

#### 오류 수정 : 기원사 충전 스킬 시전 안내가 잘못 되는 문제 수정




## 260519 update

### asNamePlates

#### New feature
* **Nameplate Selected Scale (`nameplateSelectedScale`)**: Set to 1.3 by default (WoW default is 1.2). **Note:** If you uninstall the addon, you need to reset it using the following command: `/run SetCVar ("nameplateSelectedScale", 1.2)`
#### Remove feature
* **Setup Macro Creation**: Adjusts target nameplate size and sets friendly nameplates to show class colors. Use the `asNamePlates Setup` macro.


---

#### 신규 기능
* **이름표 주대상 크기 정도(`nameplateSelectedScale`)** : 1.3을 기본으로 설정 (와우 기본 설정은 1.2) **참고:** 애드온 삭제시 다음 명령어로 초기화 필요 `/run SetCVar ("nameplateSelectedScale", 1.3)`
#### 기능 삭제
* **이름표 Setup 매크로 생성** : 대상 이름표 크기, 아군 이름표 직업 색상 이름으로 변경, `asNamePlates Setup` 메크로 사용
  

### asCombatTimer

#### Remove feature
*   **LockWindow**: Locks the position setting. (Default: Locked)

---

#### 기능 삭제
* **LockWindow**: 위치 설정을 고정 합니다. (기본값: 설정)


### asInformation

#### Remove feature
*   **LockWindow**: Locks the position setting. (Default: Locked)

---

#### 기능 삭제
* **LockWindow**: 위치 설정을 고정 합니다. (기본값: 설정)



## 260516 update

### asBattleRes

* Adjusted the default position.
* Removed the manual frame dragging feature; moving frames is now only possible via `/asConfig` and `/asClear` commands.
 
---

* 기본 위치 수정 
* 프레임 이동기능 삭제, `/asconfig` `/asclear` 명령어로만 이동 가능
![asBattleRes](https://media.forgecdn.net/attachments/1683/910/asbattleres-jpg.jpg)

### asBloodlustAlert
* Adjusted the default position.

---

* 기본 위치 수정 




## 260514 update

### asDBMTimer 

* Bug Fix: Modified to prevent text notifications for pending events.
* Adjusted the default button position.
* Added icons to text notifications.
* Modified the default setting to trigger notifications if the remaining time is less than 5 seconds.

---

* 오류 수정 : 대기중인 이벤트는 글씨로 안 알리도록 수정
* 버튼 기본 위치 수정
* 글씨 알림에 아이콘 표시
* 기본 시간 5초 미만이면 알리도록 수정

## 260513 update

### asNamePlates

* Bugfix : Friend Nameplates Change option off could not be applied.

---

* 오류 수정: 아군 이름표 변경 off 설정이 적용 안되는 이슈 해결


## 260511 update

### asDBMTimer

* Support 12.0.7
* New Feature : **Skill Name (Remaining Time) in Center**: Can be disabled in settings.

---

* 12.0.7 지원
* New Feature : **중앙에 스킬명 (남은시간) 표시 **: 설정에서 Off 가능

![asDBMTimer](https://media.forgecdn.net/attachments/1672/994/asdbmtimer-jpg.jpg)

### asNamePlates

* Bugfix : Not change friend nameplates setting could not be applied

---

* Bugfix : 아군이름표 설정이 적용 안될 수 있는 문제 수정

### asMOD 

* Applied nameplate vertical stacking options (Requires /asMOD).

---

* 이름표 상하 정렬 옵션 적용 (/asMOD 필요)


## 260510 update

### asPowerBar

* Support 12.0.7
* Bugfix : Frost mage shatter could not be shown after specialization change.

---

* 12.0.7 지원
* 오류 수정 : 냉법 빙결 중첩이 특성 변경시 안보일 수 있는 문제 수정



## 260509 update

### asNamePlates

* Support 12.0.7
* Default on for below option.
* **Modify Friendly Nameplate Settings (FriendNamePlatesColor)**: Changes the appearance of friendly nameplates as shown below. (Default: On)

--- 

* 12.0.7 지원
* 아래 설정 기본 On으로 변경
* **아군 이름표 설정 변경 (`FriendNamePlatesColor`)** : 아군 이름표를 아래와 같이 변경 합니다. (기본 On, 접속시 다시 설정 합니다.)
![sample](https://github.com/aspilla/asMOD/blob/main/.Pictures/asNameplates_friend.jpg?raw=true)


### asMOD

* Support 12.0.7
* Automatically enables Friendly Nameplates when configuring asMOD.
* Automatically enables all NPC Names when configuring asMOD.
* Automatically enables Auto Loot when configuring asMOD.
* Adjusts default Raid Frame settings when configuring asMOD (Shows defensive cooldowns and hides the Tank role icons).

---

* 12.0.7 지원
* 아군 이름표을 /asMOD 설정시 키도록 변경 
* 모든 NPC 이름을 /asMOD 설정시 키도록 변경
* 자동룻을 /asMOD 설정시 키도록 변경
* 레이드 프레임 /asMOD 설정시 기본 설정 변경 (생존기 보기게 하고, 탱커는 숨기도록) 