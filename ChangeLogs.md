# ChangeLogs


## 260518 update

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