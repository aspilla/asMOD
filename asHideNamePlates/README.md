# asHideNamePlates (Nameplate Hiding Addon)

**asHideNamePlates** is an addon that hides nameplates except for those of casting mobs to assist in interrupting casts.

<iframe width="560" height="315" src="https://www.youtube.com/embed/aVWyNqrT2C4?si=6_xC-XOIqE8cXira" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" referrerpolicy="strict-origin-when-cross-origin" allowfullscreen></iframe>

## Addon Activation Settings

1. Addon activation conditions can be adjusted via Esc >> Settings >> AddOns >> asHideNameplates.
2. Key Binding (Default Setting): Holding down the hotkey activates the nameplate hiding function. The hotkey can be assigned via Esc >> Options >> Key Bindings >> asMOD >> asHideNamePlates Key.
3. Trigger from Casting: Automatically activates when a mob which is not the target, begins casting, or when a DBM interrupt-required spell is cast (when Trigger_DBM_Interrupt_Only is enabled).
4. "ALT + CTRL": Activates when both ALT and CTRL keys are pressed simultaneously.
5. "ALT": Activates when the ALT key is pressed.
6. "CTRL": Activates when the CTRL key is pressed.
7. "SHIFT": Activates when the SHIFT key is pressed.

## Nameplates Shown While Active

1. The nameplates of the target and focus target will be displayed.
2. Nameplates of casting mobs will be displayed. Only nameplates of mobs casting DBM interrupt-required spells can be displayed using the Show_DBM_Interrupt_Only setting.
3. For tanks, the nameplates of mobs that have lost aggro will be displayed.

## Supporting Nameplates
1. Default nameplates
2. asNamePlates
3. Plater Nameplates

## Installation

1. Download the addon files.
2. Copy the `asHideNamePlates` folder to the `Interface/AddOns` directory in your World of Warcraft installation folder.
3. Restart World of Warcraft.

----

# asHideNamePlates (이름표 숨김 애드온)

**asHideNamePlates** 차단을 돕기 위해 케스팅중인 몹 외 이름표를 숨기는 기능의 애드온 입니다.

<iframe width="560" height="315" src="https://www.youtube.com/embed/aVWyNqrT2C4?si=6_xC-XOIqE8cXira" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" referrerpolicy="strict-origin-when-cross-origin" allowfullscreen></iframe>

## 애드온 동작 조건 설정

1. 애드온 동작 조건은 esc >> 설정 >> 애드온 >> asHideNameplates 에서 조정 가능합니다.
2. Key Binding (기본적 설정) : 단축키 누르고 있으면 이름표 숨김 기능이 동작합니다. 단축키는 esc >> 옵션 >> 단축키 설정 >> asMOD >> asHideNamePlates Key 에서 지정 가능합니다.
3. Trigger from Casting : 대상이 아닌 몹이 DBM 차단 필요 스킬 (Trigger_DBM_Interrupt_Only 설정시) 혹은 케스팅을 하면 자동으로 동작 합니다.
4. "ALT + CTRL" : ALT키 CTRL키를 동시에 누르면 동작합니다.
5. "ALT" : ALT키를 누르면 동작 합니다.
6. "CTRL" : CTRL키를 누르면 동작 합니다.
7. "SHIFT" : SHIFT키를 누르면 동작 합니다.

## 동작시 표시 되는 이름표

1. 대상이나 주시 대상의 이름표는 표시 됩니다.
2. 케스팅 중인 몹은 표시 됩니다. Show_DBM_Interrupt_Only으로 DBM 차단 필요 스킬 시전중인 몹의 이름표만 표시 가능합니다.
3. 탱커의 경우 어그로를 놓친 몹의 이름표는 표시 됩니다.
4. 특정 NPC ID인 몹은 표시 됩니다. (asHideNamePlatesOption.lua 파일 편집으로 추가 가능하며 다음과 같이 등록 되어 있습니다.)
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

## 설치 방법

1.  애드온 파일을 다운로드합니다.
2.  `asHideNamePlates` 폴더를 월드 오브 워크래프트 설치 폴더의 `Interface/AddOns` 디렉토리에 복사합니다.
3.  월드 오브 워크래프트를 재시작합니다.