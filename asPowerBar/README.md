# asPowerBar

## Overview

**asPowerBar** is a World of Warcraft addon designed to visually track a player's primary resources, secondary resources (like Combo Points, Runes, Holy Power), major ability cooldowns/charges, and important buffs/debuffs. It presents this key information in a compact set of bars near the bottom center of the screen, facilitating easier information access during combat.

![asPowerBar](https://github.com/aspilla/asMOD/blob/main/.Pictures/asPowerBar.jpg?raw=true)

## Features

*   **Primary Resource Bar:** Displays main resources such as Mana, Rage, Energy, Runic Power, Focus, etc. (Includes prediction for resource cost on cast).
*   **Secondary Resource Bar:** Shows class-specific secondary resources like Combo Points, Holy Power, Soul Shards, Arcane Charges, Chi, Essence in a segmented format.
*   **Spell Charge Bar:** Displays the charge count and cooldown of specific core abilities in a segmented format.
*   **Buff/Debuff Bar:** Shows the duration of important buffs/debuffs on the player or target as a timer bar. (Includes GCD and cast time overlay).
*   **Stack Bar:** Displays the stack count or remaining duration of specific buffs/debuffs as a bar.
*   **Health Bar:** (Optional) Displays the player's health.
*   **Class/Spec Specific Modules:** Automatically detects and displays relevant resources and effects based on the player's class and specialization.
*   **Visual Alerts:** Bar colors change or glow effects appear under specific conditions (e.g., nearing resource cap, specific buff active).
*   **Combat Alpha Fading:** Adjusts the bars' transparency based on combat status.
*   **Mouseover Tooltips:** Displays tooltips for associated spells or effects when hovering over each bar.

## Supported Classes/Specs

The following class and specialization features are included based on the `asPowerBar.lua` code:

*   **Evoker:** Essence, [Devastation] Upheaval charges (if talented), [Augmentation] Ebon Might duration (if talented), Essence Burst tracking.
*   **Paladin:** Holy Power, [Holy] Holy Shock charges, [Protection] Shield of the Righteous duration, [Retribution] Blade of Justice charges, alerts for specific buffs (e.g., Empyrean Power), Shake the Heavens duration (Templar).
*   **Mage:** [Arcane] Arcane Charges, Arcane Harmony stacks (if talented), Intuition Expectation Counter [Fire] Fire Blast & Phoenix Flames charges, Sun King's Blessing stacks, alerts/coloring for Incendiary Ignition and Fury of the Sun King, [Frost] Flurry charges, Icicles, Frozen Orb active time, alerts for Frostfire Bolt (if talented).
<iframe width="560" height="315" src="https://www.youtube.com/embed/yoyjD_NlHX8?si=oKyOLWxfoE7jm4Sp" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" referrerpolicy="strict-origin-when-cross-origin" allowfullscreen></iframe>

*   **Warlock:** Soul Shards, Soul Shard Fragments (Destruction), [Affliction] Shadow Embrace/Malevolent Rapture related debuff tracking, [Demonology] Demonic Core/Imp stacks, [Destruction] Conflagrate/Shadowburn charges, Immolate/Eradication debuff tracking.
*   **Druid:** Combo Points (Feral/Guardian/Balance/Restoration), [Balance] Eclipse (Solar/Lunar), Starfall/Starsurge charges, [Feral] Brutal Slash charges (if talented), alerts for specific buffs (e.g., Apex Predator's Craving, Rip and Tear), [Guardian] Ironfur stacks, Frenzied Regeneration charges, [Restoration] Swiftmend charges, Grove Guardians charges (if talented), Lifebloom tracking (party buff time, class color).

<iframe width="560" height="315" src="https://www.youtube.com/embed/1FV46swMdD4?si=Eet92UYpfNo-w0yl" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" referrerpolicy="strict-origin-when-cross-origin" allowfullscreen></iframe>

*   **Monk:** [Brewmaster] Stagger amount, Purifying Brew charges, [Mistweaver] Renewing Mist charges, Teachings of the Monastery stacks (if talented), [Windwalker] Chi.
*   **Rogue:** Combo Points, Vanish charges, Tracking for Find Weakness/Caustic Spatter/Subterfuge buffs/debuffs, Deathstalker's Mark stacks (if talented).
*   **Death Knight:** Runes, Runic Power, [Blood] Bone Shield stacks, Rune Tap charges (if talented), [Frost/Unholy] Tracking specific buffs (e.g., Unholy Frenzy, Icy Talons, Plaguebringer).
*   **Priest:** [Discipline] Purge the Wicked/Shadow Word: Death charges, Schism debuff tracking, [Holy] Holy Word charges, Divine Image stacks (if talented), [Shadow] Shadow Word: Death charges, tracking specific buffs (e.g., Voracious Chorus - Tier Set).
*   **Warrior:** Rage, [Arms] Overpower charges, Colossus Smash/Execute debuff tracking, [Fury] Enrage buff tracking, Whirlwind/Meat Cleaver stacks, [Protection] Shield Block charges, Defensive Stance/Ignore Pain duration.
*   **Demon Hunter:** Fury, [Havoc] Fel Rush/Glaive Throw charges, Momentum/Inertia buff tracking (if talented), [Vengeance] Soul Fragments, Demon Spikes/Fracture charges, Demon Spikes buff duration.
*   **Hunter:** Focus, [Beast Mastery] Barbed Shot charges, Frenzy stacks, Howl of the Pack tracking (if talented), [Marksmanship] Aimed Shot charges, Trick Shots/Precise Shots buff tracking, Wind Arrow debuff tracking (if talented), [Survival] Wildfire Bomb charges, Mongoose Bite/Spearhead stacks (if talented).
*   **Shaman:** Maelstrom (Elemental/Enhancement), [Elemental] Lava Burst charges, Deeply Rooted Elements buff tracking (if talented), Tempest stack tracking (if talented), [Enhancement] Elemental Blast charges (if talented), Maelstrom Weapon stacks, Crash Lightning buff tracking, Tempest stack tracking (if talented), [Restoration] Riptide charges, Tidal Waves stacks.


## Configuration

*   **Position and Basic Settings:** If the `asMOD` addon is installed, you can adjust the position and other settings of asPowerBar using the `/asconfig` command (or through the asMOD interface). 
*   **Manual Configuration:** You can manually change the size or position by editing values like `APB_WIDTH`, `APB_X`, `APB_Y` at the top of the `asPowerBar.lua` file. (Recommended only for users comfortable with editing Lua code).

---


# asPowerBar

## 개요 (Overview)

**asPowerBar**는 월드 오브 워크래프트(World of Warcraft) 플레이어의 주요 자원, 보조 자원(콤보 포인트, 룬, 신성한 힘 등), 주요 기술의 재사용 대기시간/충전 횟수, 그리고 중요한 강화/약화 효과를 시각적으로 추적하기 위한 애드온입니다. 플레이어에게 필요한 핵심 정보를 중앙 하단에 컴팩트한 바 형태로 표시하여 전투 중 정보 확인을 용이하게 합니다.


![asPowerBar](https://github.com/aspilla/asMOD/blob/main/.Pictures/asPowerBar.jpg?raw=true)

## 주요 기능 (Features)

*   **주 자원 바 (Primary Resource Bar):** 마나, 분노, 기력, 룬 마력, 집중 등의 주 자원을 표시합니다. (시전 시 자원 소모 예측 기능 포함)
*   **보조 자원 바 (Secondary Resource Bar):** 연계 점수, 신성한 힘, 영혼의 조각, 비전 충전물, 기, 마력의 룬 등 직업별 보조 자원을 칸 형태로 표시합니다.
*   **주요 기술 충전 바 (Spell Charge Bar):** 특정 핵심 기술의 충전 횟수와 재사용 대기시간을 칸 형태로 표시합니다.
*   **강화/약화 효과 바 (Buff/Debuff Bar):** 플레이어 또는 대상에게 걸린 중요한 강화/약화 효과의 지속시간을 타이머 바 형태로 표시합니다. (GCD 및 시전 시간 오버레이 포함)
*   **중첩 효과 바 (Stack Bar):** 특정 강화/약화 효과의 중첩 수 또는 남은 시간을 바 형태로 표시합니다.
*   **생명력 바 (Health Bar):** (선택 사항) 플레이어의 생명력을 표시합니다.
*   **직업 및 전문화별 모듈 (Class/Spec Specific Modules):** 각 직업과 전문화에 맞춰 필요한 자원 및 효과를 자동으로 감지하고 표시합니다.
*   **시각적 알림 (Visual Alerts):** 특정 조건 (자원 최대치 도달 임박, 특정 강화 효과 활성화 등)에서 바의 색상이 변경되거나 강조 효과(Glow)가 나타납니다.
*   **전투/비전투 투명도 조절 (Combat Alpha Fading):** 전투 상태에 따라 바의 투명도를 조절합니다.
*   **마우스오버 툴팁 (Mouseover Tooltips):** 각 바 위에 마우스를 올리면 관련된 기술이나 효과의 툴팁을 표시합니다.

## 지원 직업 및 전문화 (Supported Classes/Specs)

다음과 같은 직업 및 전문화별 기능이 포함되어 있습니다:

*   **기원사 (Evoker):** 정수, [황폐] 파열 충전, [보존] 되감기, 특정 강화 효과 추적.
*   **성기사 (Paladin):** 신성한 힘, [신성] 신성 충격 충전, [보호] 정의의 방패 지속시간, [징벌] 심판의 칼날 충전, 특정 강화 효과(창공의 힘 등), 격동하는 천상 지속시간 (기사단 특성)
*   **마법사 (Mage):** [비전] 비전 충전물, 비전 조화 중첩, 직관력 예측 카운트 [화염] 화염 작렬/불사조의 불길 충전, 발화 관련 강화 효과, [냉기] 진눈깨비 충전, 고드름, 얼어붙은 구슬 활성화 시간, 서리 불꽃 등 강화 효과 알림.
<iframe width="560" height="315" src="https://www.youtube.com/embed/yoyjD_NlHX8?si=oKyOLWxfoE7jm4Sp" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" referrerpolicy="strict-origin-when-cross-origin" allowfullscreen></iframe>
*   **흑마법사 (Warlock):** 영혼의 조각, 영혼의 조각 파편(파괴), [고통] 어둠의 선물/사악한 환희 관련 약화 효과, [악마] 악마 핵/임프 중첩, [파괴] 점화/어둠의 연소 충전, 제물/박멸 등 약화 효과 추적.
*   **드루이드 (Druid):** 연계 점수(표범/수호/조화/회복), [조화] 일월식, 별똥별/별빛쇄도 충전, [야성] 잔혹한 베기 충전, 특정 강화 효과(최상위 포식자, 찢어발기기 강화 등) 알림, [수호] 무쇠가죽 중첩, 광포한 재생력 충전, [회복] 신속한 치유, 숲의 수호자 충전, 피어나는 생명(파티원 버프, 직업 색상) 추적.
<iframe width="560" height="315" src="https://www.youtube.com/embed/1FV46swMdD4?si=Eet92UYpfNo-w0yl" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" referrerpolicy="strict-origin-when-cross-origin" allowfullscreen></iframe>

*   **수도사 (Monk):** [양조] 시간차, 정화주 충전, [운무] 소생의 안개 충전, 수도원의 가르침 중첩, [풍운] 기.
*   **도적 (Rogue):** 연계 점수, 소멸 충전, 약점 포착/부식성 분사/기만 등 강화/약화 효과 추적, 죽음 추적자 중첩.
*   **죽음의 기사 (Death Knight):** 룬, 룬 마력, [혈기] 뼈의 보호막 중첩, 룬 전환 충전, [냉기/부정] 특정 강화 효과(풀려난 광란, 얼음 발톱, 역병 인도자 등) 추적.
*   **사제 (Priest):** [수양] 사악의 정화/어둠의 권능: 죽음 충전, 분파 약화 효과, [신성] 빛의 권능 충전, 신성한 환영 중첩, [암흑] 어둠의 권능: 죽음 충전, 특정 강화 효과(게걸스러운 합창 등) 추적.
*   **전사 (Warrior):** 분노, [무기] 제압 충전, 거인의 강타/마무리 일격 약화 효과, [분노] 격노 강화 효과, 소용돌이/고기칼 중첩, [방어] 방패 막기 충전, 방어 태세/고통 감내 지속시간.
*   **악마사냥꾼 (Demon Hunter):** 격노, [파멸] 지옥 돌진/글레이브 투척 충전, 탄력/타성 강화 효과, [복수] 영혼 파편, 악마 쐐기/균열 충전, 악마 쐐기 강화 효과.
*   **사냥꾼 (Hunter):** 집중, [야수] 날카로운 사격 충전, 광기 중첩, 무리의 지도자의 포효 추적, [사격] 조준 사격 충전, 교묘한 사격/연발 공격 강화 효과, 바람 화살 약화 효과, [생존] 야생불 폭탄 충전, 살쾡이의 이빨/창끝 중첩.
*   **주술사 (Shaman):** 소용돌이(정기/고양), [정기] 용암 폭발 충전, 깊이 뿌리내린 정기 강화 효과, 폭풍의 정령 중첩, [고양] 정기 작렬 충전, 소용돌이치는 무기 중첩, 낙뢰 강화 효과, 폭풍의 정령 중첩, [복원] 성난 해일 충전, 굽이치는 물결 중첩.

## 설정 (Configuration)

*   **위치 및 기본 설정:** `asMOD` 애드온이 설치되어 있다면, /asconfig 명령어를 통해 asPowerBar의 위치 등을 조절할 수 있습니다.
*   **수동 설정:** `asPowerBar.lua` 파일 상단의 `APB_WIDTH`, `APB_X`, `APB_Y` 등의 값을 직접 수정하여 바의 크기나 위치를 변경할 수 있습니다. (Lua 코드 수정에 익숙한 사용자에게 권장)