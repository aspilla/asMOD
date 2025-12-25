# asHideNamePlates (Mid Night)

An addon that hides nameplates of mobs that are not casting, designed to help with interrupts.

<iframe width="560" height="315" src="https://www.youtube.com/embed/aVWyNqrT2C4?si=6_xC-XOIqE8cXira" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" referrerpolicy="strict-origin-when-cross-origin" allowfullscreen></iframe>

## Configuration for Activation Conditions

1. Activation conditions can be adjusted in ESC >> Options >> Addons >> asHideNamePlates.
2. Key Binding (Default): The nameplate hiding function activates while holding down the assigned key. The key can be set in ESC >> Options >> Keybindings >> asMOD >> asHideNamePlates Key.
3. Trigger from Casting: Automatically activates when a mob begins casting.
4. "ALT + CTRL": Activates when ALT and CTRL keys are pressed simultaneously.
5. "ALT": Activates when the ALT key is pressed.
6. "CTRL": Activates when the CTRL key is pressed.
7. "SHIFT": Activates when the SHIFT key is pressed.

## Nameplates Shown During Activation

1. Nameplates of your current Target or Focus are shown.
2. Mobs that are currently casting are shown.
3. For tanks, nameplates of mobs you have lost aggro on are shown.
4. Specific NPC IDs registered in MustShow_IDs are shown. (Can be added by editing the asHideNamePlatesOption.lua file; current registrations include:)
<pre>
<code>
ns.MustShow_IDs = {
[229537] = true,        -- Void Messenger
[223724] = true,        -- Refill Barrel
}
</code>
</pre>

## Supported Nameplates
1. Default WoW Nameplates
2. asNamePlates
3. Plater Nameplates

---
# asHideNamePlates (한밤)

차단을 돕기 위해 케스팅중인 몹 외 이름표를 숨김

<iframe width="560" height="315" src="https://www.youtube.com/embed/aVWyNqrT2C4?si=6_xC-XOIqE8cXira" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" referrerpolicy="strict-origin-when-cross-origin" allowfullscreen></iframe>

## 애드온 동작 조건 설정

1. 애드온 동작 조건은 esc >> 설정 >> 애드온 >> asHideNameplates 에서 조정 가능
2. Key Binding (기본적 설정) : 단축키 누르고 있으면 이름표 숨김 기능이 동작. 단축키는 esc >> 옵션 >> 단축키 설정 >> asMOD >> asHideNamePlates Key 에서 지정 가능.
3. Trigger from Casting : 몹이 케스팅을 하면 자동으로 동작.
4. "ALT + CTRL" : ALT키 CTRL키를 동시에 누르면 동작.
5. "ALT" : ALT키를 누르면 동작.
6. "CTRL" : CTRL키를 누르면 동작.
7. "SHIFT" : SHIFT키를 누르면 동작.

## 동작시 표시 되는 이름표

1. 대상이나 주시 대상의 이름표는 표시.
2. 케스팅 중인 몹은 표시. 
3. 탱커의 경우 어그로를 놓친 몹의 이름표는 표시.
4. 특정 NPC ID(MustShow_IDs에 등록된)인 몹은 표시. (asHideNamePlatesOption.lua 파일 편집으로 추가 가능하며 다음과 같이 등록 되어 있습니다.)
<pre>
<code>
ns.MustShow_IDs = {
[229537] = true,        --공허의 사절
[223724] = true,        --보충용 통
}
</code>
</pre>

## 지원 이름표
1. 와우 기본 이름표
2. asNamePlates
3. Plater Nameplates