# asPowerBar (Midnight)

Primary Resource / Class Resource Display

![asPowerBar](https://media.forgecdn.net/attachments/1585/703/aspowerbar_mn-jpg.jpg)

## Features

- **Primary Resource Bar:** Displays primary resources such as Mana, Rage, Energy, Runic Power, and Focus. (Includes resource cost prediction during spell casting)
- **Class Resource:** Displays class-specific secondary resources like Combo Points, Holy Power, Soul Shards, Arcane Charges, Chi, Runes, and major skill cooldowns in a segmented block format.

## Class & Specialization Features

- **Evoker:** Essence
- **Paladin:** Holy Power
- **Mage:** [Arcane] Arcane Charges, [Fire] Fire Blast cooldown, [Frost] Target's Winter's Chill debuff stacks
- **Warlock:** Soul Shards, [Destruction] Soul Shard Fragments
- **Druid:** Combo Points (Includes [Feral] Overflowing Power tracker)
- **Monk:** [Brewmaster] Stagger, [Mistweaver] Renewing Mist cooldown, [Windwalker] Chi
- **Rogue:** Combo Points, Animacharged Combo Points
- **Shaman:** [Enhancement] Maelstrom Weapon, [Elemental] Lava Burst cooldown, [Restoration] Riptide cooldown
- **Death Knight:** Runes
- **Priest:** [Discipline] Power Word: Radiance cooldown, [Holy] Holy Word: Serenity cooldown, [Shadow] Mind Blast cooldown
- **Warrior:** [Arms] Overpower cooldown, [Fury] Whirlwind buff tracking (Note: cannot check the 7-yard distance requirement to targets), [Protection] Shield Block cooldown
- **Demon Hunter:** [Havoc] Fel Rush cooldown, [Vengeance] Soul Fragment buff, [Devourer] Soul Fragment buff
- **Hunter:** [Beast Mastery] Barbed Shot cooldown, [Marksmanship] Aimed Shot cooldown, [Survival] Tip of the Spear buff

- (Caution) The Frost Mage `Winter's Chill` debuff tracker will only function if the `Winter's Chill` debuff is enabled in your `Cooldown Manager`.

<iframe width="560" height="315" src="https://www.youtube.com/embed/4h5D5e9yC9E?si=n3WXwqYGOgi_7Ytf" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" referrerpolicy="strict-origin-when-cross-origin" allowfullscreen></iframe>

- (Caution) The Fury Warrior `Whirlwind` buff tracker cannot check the 7-yard range requirement to the target.
  ![asPowerBar](https://github.com/aspilla/asMOD/blob/main/.Pictures/asPowerBar_whirlwind.gif?raw=true)

## Configuration

- Adjustable via `ESC` > `Options` > `AddOns` > `asPowerBar`
  - Display Class/Specialization Resources (Skills, etc.): Default: On
  - Out of Combat Alpha : Default: On
  - Bar Width: Default: 238
  - Primary Resource Bar Height: Default: 8
  - Secondary Resource Bar Height: Default: 5
  - Font Size: Default: 12
  - Smooth Bar Animation: Default: On
  - Changing bar sizes requires a `/reload` command in the chat window to reinitialize the addon.

- **Move Anchor Positions:** Type `/asConfig` in the chat window.
- **Reset Anchor Positions:** Type `/asClear` in the chat window to restore default settings.

<iframe width="560" height="315" src="https://www.youtube.com/embed/gKEHCNP9rbE?si=WC6rvwnzKqc6Sdjz" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" referrerpolicy="strict-origin-when-cross-origin" allowfullscreen></iframe>

## Support & Feedback

1. `Korean Users`: Visit the `Inven asMOD Forum` (https://www.inven.co.kr/board/wow/5288)
2. `English Users`: Visit the `asMOD YouTube Channel` (https://www.youtube.com/@asmod-wow) or `GitHub` (https://github.com/aspilla/asMOD/)

---

# asPowerBar (한밤)

주 자원/직업 자원 표시

![asPowerBar](https://media.forgecdn.net/attachments/1585/703/aspowerbar_mn-jpg.jpg)

## 주요 기능 (Features)

- **주 자원 바:** 마나, 분노, 기력, 룬 마력, 집중 등의 주 자원을 표시. (시전 시 자원 소모 예측 기능 포함)
- **직업 자원:** 연계 점수, 신성한 힘, 영혼의 조각, 비전 충전물, 기, 마력의 룬, 주요 스킬 등 직업별 보조 자원을 칸 형태로 표시.

## 직업 전문화 특성

- **기원사 :** 정수
- **성기사 :** 신성한 힘
- **마법사 :** [비전] 비전 충전물, [화염] 화염작열 쿨다운, [냉기] 대상 빙결 디버프 중첩
- **흑마법사 :** 영혼의 조각, [파괴] 영혼의 조각 파편
- **드루이드 :** 연계 점수 ([야성]넘쳐흐르는 힘 표시)
- **수도사 :** [양조] 시간차, [운무] 소생의 안개 쿨다운 [풍운] 기
- **도적 :** 연계 점수, 초자력 충전
- **주술사 :** [고양] 소용돌이치는 무기, [정기] 용암 폭발 쿨다운, [복원] 성난 해일 쿨다운
- **죽음의 기사 :** 룬
- **사제 :** [수양] 광휘 쿨다운, [신성] 평온 쿨다운, [암흑] 정신분열 쿨다운
- **전사 :** [무기] 제압 쿨다운, [분노] 소용돌이 버프 (대상과의 거리 7미터는 채크 불가), [방어] 방패 올리기 쿨다운
- **악마사냥꾼 :** [파멸] 지옥 돌진 쿨다운, [복수] 영혼 파편 버프, [포식] 영혼 파편 버프
- **사냥꾼 :** [야수] 날카로운 사격 쿨다운, [사격] 조준 사격 쿨다운, [생존] 창끝 버프

- (주의) 냉기 법사 `빙결` 디버프는 `재사용 대기시간 관리자`에서 `빙결` 디버프를 표시해야 표기 됨

<iframe width="560" height="315" src="https://www.youtube.com/embed/4h5D5e9yC9E?si=n3WXwqYGOgi_7Ytf" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" referrerpolicy="strict-origin-when-cross-origin" allowfullscreen></iframe>

- (주의) 분노 전사 `소용돌이` 버프 는 대상과의 거리 7미터는 채크 불가함
  ![asPowerBar](https://github.com/aspilla/asMOD/blob/main/.Pictures/asPowerBar_whirlwind.gif?raw=true)

## 설정 (Configuration)

- `ESC` > `설정` > `애드온` > `asPowerBar` 에서 설정 가능
  - 직업 전문화 자원(스킬등) 표시 : 기본 On
  - 비전투시 투명도 변경 : 기본 On
  - 바 넓이 : 기본 238
  - 주 자원바 높이 : 기본 8
  - 보조 자원바 높이 : 기본 5
  - 글꼴 크기 : 기본 12
  - 부드러운 바 애니메이션 : 기본 On
- 바 크기 변경 후 `/reload` 명령어로 다시 Addon 초기화 필요

- **위치 이동** : `/asConfig` 명령어 채팅창에 입력
- **위치 초기화** : `/asClear` 명령어 채팅창에 입력, 기본 설정으로 초기화

<iframe width="560" height="315" src="https://www.youtube.com/embed/gKEHCNP9rbE?si=WC6rvwnzKqc6Sdjz" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" referrerpolicy="strict-origin-when-cross-origin" allowfullscreen></iframe>

## 문의처

1. `한글 유저` : `인벤 asMOD 포럼` 방문 (https://www.inven.co.kr/board/wow/5288)
2. `영문 유저` : `Youtube asMOD 채널` 방문 (https://www.youtube.com/@asmod-wow), `Github` 방문 (https://github.com/aspilla/asMOD/)
