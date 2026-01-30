# asPowerBar (Midnight)

Displays Main Resources and Class Resources.

![asPowerBar](https://github.com/aspilla/asMOD/blob/main/.Pictures/asPowerBar_MN.jpg?raw=true)

## Key Features

* **Main Resource Bar:** Displays primary resources such as Mana, Rage, Energy, Runic Power, and Focus. (Includes resource consumption prediction during casting)
* **Class Resources:** Displays secondary class-specific resources (e.g., Combo Points, Holy Power, Soul Shards, Arcane Charges, Chi) in a segmented bar format.

## Class & Specialization Support
* **Evoker:** Essence
* **Paladin:** Holy Power
* **Mage:** [Arcane] Arcane Charges, [Fire] Fire Blast cooldown, [Frost] Target Shatter debuff stacks
* **Warlock:** Soul Shards, [Destruction] Soul Shard Fragments
* **Druid:** [Feral] Combo Points, [Restoration] Combo Points, [Guardian] Frenzied Regeneration cooldown
* **Monk:** [Brewmaster] Stagger, [Mistweaver] Renewing Mist cooldown, [Windwalker] Chi
* **Rogue:** Combo Points, Supercharged
* **Shaman:** [Enhancement] Maelstrom Weapon, [Elemental] Lava Burst cooldown, [Restoration] Riptide cooldown
* **Death Knight:** Runes
* **Priest:** [Discipline] Power Word: Radiance cooldown, [Holy] Holy Word: Serenity cooldown, [Shadow] Mind Blast cooldown
* **Warrior:** [Arms] Overpower cooldown, [Fury] Whirlwind buff (7m distance check unavailable), [Protection] Shield Block cooldown
* **Demon Hunter:** [Havoc] Fel Rush cooldown, [Vengeance] Soul Fragment buff, [Aldrachi Reaper] Soul Fragment buff
* **Hunter:** [Beast Mastery] Barbed Shot cooldown, [Marksmanship] Aimed Shot cooldown, [Survival] Tip of the Spear buff

* (Note) For Frost Mages, the `Shatter` debuff will only be displayed if the `Shatter` debuff is enabled in the `Cooldown Manager`.

<iframe width="560" height="315" src="https://www.youtube.com/embed/4h5D5e9yC9E?si=n3WXwqYGOgi_7Ytf" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" referrerpolicy="strict-origin-when-cross-origin" allowfullscreen></iframe>

* (Note) For Fury Warriors, the `Whirlwind` buff tracking cannot check the 7-meter distance to the target.

![asPowerBar](https://github.com/aspilla/asMOD/blob/main/.Pictures/asPowerBar_whirlwind.gif?raw=true)

## Configuration
* Accessible via `ESC` > `Options` > `AddOns` > `asPowerBar`.
* `ShowClassResource`: Toggle class-specific resource display (Default: On)
* `CombatAlphaChange`: Adjusts transparency when out of combat (Default: On)
* `BarWidth`: Width of the PowerBar (Default: 238)
* `PowerBarHeight`: Height of the main resource bar (Default: 8)
* `ComboBarHeight`: Height of the secondary resource bar (Default: 5)
* `FontSize`: Font size for text (Default: 12)

* **Repositioning**: Enter the `/asconfig` command in the chat window.
* **Reset Position**: Enter the `/asclear` command in the chat window to reset to default settings.
* **Note**: After changing bar sizes, use the `/reload` command to reinitialize the addon.

<iframe width="560" height="315" src="https://www.youtube.com/embed/gKEHCNP9rbE?si=WC6rvwnzKqc6Sdjz" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" referrerpolicy="strict-origin-when-cross-origin" allowfullscreen></iframe>

---
# asPowerBar (한밤)

주 자원/직업 자원 표시

![asPowerBar](https://github.com/aspilla/asMOD/blob/main/.Pictures/asPowerBar_MN.jpg?raw=true)

## 주요 기능 (Features)

* **주 자원 바:** 마나, 분노, 기력, 룬 마력, 집중 등의 주 자원을 표시. (시전 시 자원 소모 예측 기능 포함)
* **직업 자원:** 연계 점수, 신성한 힘, 영혼의 조각, 비전 충전물, 기, 마력의 룬, 주요 스킬 등 직업별 보조 자원을 칸 형태로 표시.

## 직업 전문화 특성
*   **기원사 :** 정수
*   **성기사 :** 신성한 힘
*   **마법사 :** [비전] 비전 충전물, [화염] 화염작열 쿨다운, [냉기] 대상 빙결 디버프 중첩
*   **흑마법사 :** 영혼의 조각, [파괴] 영혼의 조각 파편
*   **드루이드 :** [야성] 연계 점수, [회복] 연계 점수, [수호] 광포한 재생력 쿨다운
*   **수도사 :** [양조] 시간차, [운무] 소생의 안개 쿨다운 [풍운] 기
*   **도적 :** 연계 점수, 초자력 충전 
*   **주술사 :** [고양] 소용돌이치는 무기, [정기] 용암 폭발 쿨다운, [복원] 성난 해일 쿨다운
*   **죽음의 기사 :** 룬
*   **사제 :** [수양] 광휘 쿨다운, [신성] 평온 쿨다운, [암흑] 정신분열 쿨다운
*   **전사 :** [무기] 제압 쿨다운, [분노] 소용돌이 버프 (대상과의 거리 7미터는 채크 불가), [방어] 방패 올리기 쿨다운 
*   **악마사냥꾼 :** [파멸] 지옥 돌진 쿨다운, [복수] 영혼 파편 버프, [포식] 영혼 파편 버프
*   **사냥꾼 :** [야수] 날카로운 사격 쿨다운, [사격] 조준 사격 쿨다운, [생존] 창끝 버프

* (주의) 냉기 법사 `빙결` 디버프는 `재사용 대기시간 관리자`에서 `빙결` 디버프를 표시해야 표기 됨

<iframe width="560" height="315" src="https://www.youtube.com/embed/4h5D5e9yC9E?si=n3WXwqYGOgi_7Ytf" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" referrerpolicy="strict-origin-when-cross-origin" allowfullscreen></iframe>

* (주의) 분노 전사 `소용돌이` 버프 는 대상과의 거리 7미터는 채크 불가함

![asPowerBar](https://github.com/aspilla/asMOD/blob/main/.Pictures/asPowerBar_whirlwind.gif?raw=true)



## 설정 (Configuration)
*  `ESC` > `설정` > `애드온` > `asPowerBar` 에서 설정 가능
*  `ShowClassResource`: 직업 전문화 특성 표시 여부 (Default On)
*  `CombatAlphaChange` : 비전투시 투명도 변경 (Default On)
*  `BarWidth` : PowerBar 넓이 (Default 238)
*  `PowerBarHeight` : 주 자원바 높이 (Default 8)
*  `ComboBarHeight` : 보조 자원바 높이 (Default 5)
*  `FontSize` : 글꼴 크기 (Default 12)

*  **위치 이동** : `/asConfig` 명령어 채팅창에 입력
*  **위치 초기화** : `/asClear` 명령어 채팅창에 입력, 기본 설정으로 초기화 
*  바 크기 변경 후 `/reload` 명령어로 다시 Addon 초기화 필요

<iframe width="560" height="315" src="https://www.youtube.com/embed/gKEHCNP9rbE?si=WC6rvwnzKqc6Sdjz" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" referrerpolicy="strict-origin-when-cross-origin" allowfullscreen></iframe>