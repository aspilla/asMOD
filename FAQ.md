# Please Read Before Asking (asMOD FAQ)

## 0. Guidelines to Follow
### Contact Information
1. **Korean Users**: Visit the **Inven asMOD Forum** (https://www.inven.co.kr/board/wow/5288)
2. **English Users**: Visit the **asMOD YouTube Channel** (https://www.youtube.com/@asmod-wow) or **GitHub** (https://github.com/aspilla/asMOD/)

### Manuals
Please read the [asMOD Installation/Update/Deletion/Settings/Manual] post thoroughly before asking questions. 
Settings outside the intended features of each addon are often unsupported. 
Individual manual links are provided for each addon. Please read them before contacting us.
1. **Korean Users**: Visit the **Inven Addon Library** (https://wow.inven.co.kr/dataninfo/addonpds/detail.php?idx=2845)
2. **English Users**: Visit **asMOD on CurseForge** (https://www.curseforge.com/wow/addons/asmod) 

### asMOD Philosophy
asMOD aims for simple addons that work without complex configurations. All addons are written to minimize settings; therefore, most requests for additional configuration options will be declined.

---

## 1. Troubleshooting Errors
Install the `Bugsack` and `BugGrabber` addons to collect error logs. Copy the error message using **CTRL+C** and provide it when contacting support.

* **asGearScoreLite Conflict**: If it conflicts with other item level display addons (e.g., TinyTip), disable the conflicting addon.
* **Edit Mode Error**: Blizzard's Edit Mode may not function correctly while `asUnitFrame` is active. Please disable it temporarily when using Edit Mode.

## 2. Adjusting Position or Size
* **Size Settings**: Some addons support size adjustment. If it is not mentioned in the specific addon manual, size adjustment is not supported.
* **Position Settings**: Refer to the [Installation/Manual] guide to adjust positions.

## 3. Screen UI Scaling
Since asMOD does not support independent scaling, you must use the default WoW UI settings.
* **Recommended Setting**: Go to `ESC > Options` and set **UI Scale** to **0.75**.

## 4. Using Only Specific Addons
Every addon is **independent**. If you wish to use them individually, search for and install only the ones you need on CurseForge, or disable unwanted features in `ESC > Addons`.

## 5. Initial Setup and Reset
* **Rerunning Setup**: If you clicked "No" during installation or the settings are corrupted, type `/asmod` in the chat window.
* **Full Reset**: Type `/console cvar_default` followed by `/asmod`. (Note: This will reset all game settings to default).

## 6. Auto-Hide Feature (Mouseover)
* **Micro Menu & Bags Bar**: Visible only when hovered. To keep them always visible, disable `asHideBagsBar`.
* **Bottom Action Bar**: Visible only when hovered. To keep it always visible, disable `asHideActionBar`.

## 7. Other General Settings
* **Layout Issues After Talent Change**: Type `/asmod` or re-select the **asMOD_Layout** in **Edit Mode**.
* **Nameplate Issues**: If nameplates overlap or are not visible, go to `ESC > Options` and change the Nameplate Motion Type to **'Stacking Nameplates'**.

## 8. How to Sync Settings Between Characters
asMOD minimizes the use of the **ACE Library**. To copy settings, use the `WTF` folder method:
1. **Exit the Game**: Close WoW completely. Click the gear icon next to the "Play" button in the **Battle.net** launcher to find your install folder.
2. Navigate to: `World of Warcraft/_retail_/WTF/Account/[Account Name]/[Server Name]`.
3. **Copy Character**: Copy the folder of the character that is already configured (e.g., OldChar).
4. **Rename Folder**: Rename the copied folder (e.g., OldChar - Copy) to the name of the new character (e.g., NewChar).
5. **Restart Game**: Log in to apply the identical settings.

## 9. Changelogs
Unfortunately, changelogs are only provided in **Korean** at the **Inven asMOD Forum** (https://www.inven.co.kr/board/wow/5288). English users are encouraged to use translation tools to check updates by date.

---


# 질문 전 꼭 읽어 보세요 (asMOD FAQ)

## 0. 이것은 꼭 지켜 주세요
### 문의처
1. `한글 유저` : `인벤 asMOD 포럼` 방문 (https://www.inven.co.kr/board/wow/5288)
2. `영문 유저` : `Youtube asMOD 채널` 방문 (https://www.youtube.com/@asmod-wow), `Github` 방문 (https://github.com/aspilla/asMOD/)

### 설명서
[asMOD 설치/업뎃/삭제/설정/설명서]글을 꼭 읽어 보고 질문해 주세요. 
각 애드온 기능 외의 설정은 지원되지 않는 경우가 많습니다. 
각 애드온 별로 별도 설명서가 링크 되어 있습니다. 질문전 꼭 읽어 주세요.
1. `한글 유저` : `인벤 자료실` 방문(https://wow.inven.co.kr/dataninfo/addonpds/detail.php?idx=2845&rurl=%2Fdataninfo%2Faddonpds%2Flist.php%3F)
2. `영문 유저` : `커스포지 asMOD` 방문 (https://www.curseforge.com/wow/addons/asmod) 

### asMOD철학
설정없이 사용하는 간단한 애드온을 지향 합니다. 모든 애드온이 설정을 최소화 하는것으로 고려되어 작성 되어 있어 설정 추가 요구는 대부분 거절 됩니다. 

## 1. 오류가 났을 경우 처리 방법
`Bugsack` `BugGrabber`애드온을 추가하여 오류를 수집하세요. 오류 메시지를 **CTRL+C**로 복사해 문의처에 남겨 주세요.

* **asGearScoreLite 충돌:** 타 아이템 레벨 확인 애드온(TinyTip 등)과 충돌 시 해당 애드온을 끄고 사용하세요.
* **편집 모드 오류:** `asUnitFrame` 활성화 시 편집 모드가 동작하지 않을 수 있습니다. 편집 모드 사용 시에는 잠시 꺼두시기 바랍니다.

## 2. 위치나 크기 변경
* **크기 설정:** 일부 애드온 크기 설정을 지원합니다. 각 애드온 설명서에 설명 되지 않았다면 크기 설정은 지원하지 않습니다. 
* **위치 설정:** [설치/설명서] 가이드 글을 참고하여 조정하세요.

## 3. 화면 UI 크기 조정
asMOD는 자체 크기 변경을 지원하지 않으므로, 와우 기본 UI 설정을 이용해야 합니다.
* **설정 방법:** `ESC > 설정`에서 **UI 크기**를 **0.75**로 변경하는 것을 권장합니다.

## 4. 일부 애드온만 사용하기
모든 애드온은 **독립적**입니다. 개별 사용을 원하시면 커스포지(CurseForge)에서 검색하여 필요한 것만 설치하거나, `ESC > 애드온 목록`에서 원치 않는 기능을 끄시면 됩니다.

## 5. 초기 설정 및 리셋
* **설정 재실행:** 설치 중 "아니오"를 눌렀거나 설정이 꼬였다면 채팅창에 `/asmod`를 입력하세요.
* **완전 초기화:** `/console cvar_default` 입력 후 `/asmod`를 실행하세요. (모든 설정이 초기화되니 주의)

## 6. 자동 숨김 기능 (마우스 오버)
* **가방 및 메뉴 바:** 마우스를 가져갈 때만 보입니다. 항상 보고 싶다면 `asHideBagsBar`를 비활성화하세요.
* **하단 스킬 바:** 마우스를 가져갈 때만 보입니다. 항상 보고 싶다면 `asHideActionBar`를 비활성화하세요.

## 7. 기타 일반 설정
* **특성 변경 후 레이아웃 이상:** `/asmod`를 입력하거나, `편집 모드`에서 **asMOD_Layout**을 다시 선택하세요.
* **이름표(Nameplate) 문제:** 이름표가 겹치거나 안 보인다면 `ESC > 설정`에서 이름표 배열 설정을 **'상하 정렬'**로 변경하세요.

## 8. 케릭별 설정 동기화 방법
*  **ACE Library** 사용을 최소화 하고 있습니다. 설정 복사를 위해 `WTF` 폴더 복사하기를 사용하시면 됩니다.
*   게임 종료: 와우를 완전히 종료합니다. `베틀넷` 런처에서 `플레이` 버튼 옆 톱니바퀴를 누르면 `와우 설치 폴더`를 찾을 수 있습니다.
*   World of Warcraft/_retail_/WTF/Account/[계정명]/[서버명] 경로로 이동합니다.
*   캐릭터 복사: 기존에 설정이 완료된 캐릭터 폴더(예: OldChar)를 복사하여 같은 폴더에 붙여넣습니다.
*   폴더 이름 변경: 복사된 폴더(OldChar - 복사본)의 이름을 애드온 설정을 적용할 캐릭터 이름(NewChar)으로 변경합니다.
*   게임 재접속: 해당 캐릭터로 접속하면 기존 캐릭터의 설정이 동일하게 적용됩니다.

## 9. 변경점 
*   아쉽게도 `한글` 변경점만 `인벤 asMOD 포럼` (https://www.inven.co.kr/board/wow/5288) 에 공유 하고 있습니다. `영문` 유저는 날짜별 변경점을 번역해서 확이하시기 바랍니다.

