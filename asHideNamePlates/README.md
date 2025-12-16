# asHideNamePlates

This is an addon that hides the nameplates of mobs that are not casting, to help with interrupts.

<iframe width="560" height="315" src="https://www.youtube.com/embed/aVWyNqrT2C4?si=6_xC-XOIqE8cXira" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" referrerpolicy="strict-origin-when-cross-origin" allowfullscreen></iframe>

## Addon Activation Conditions

1.  Addon activation conditions can be adjusted in `esc` >> `Settings` >> `Addons` >> `asHideNameplates`.
2.  **Key Binding (Default setting):** The nameplate hiding feature is activated while the hotkey is pressed. The hotkey can be assigned in `esc` >> `Options` >> `Key Bindings` >> `asMOD` >> `asHideNamePlates Key`.
3.  **Trigger from Casting:** Automatically activates when a non-target mob casts a DBM interrupt-required skill (if `Trigger_Important_Interrupt_Only` is enabled) or any spell.
4.  **"ALT + CTRL":** Activates when ALT and CTRL keys are pressed simultaneously.
5.  **"ALT":** Activates when the ALT key is pressed.
6.  **"CTRL":** Activates when the CTRL key is pressed.
7.  **"SHIFT":** Activates when the SHIFT key is pressed.

## Nameplates Displayed During Activation

1.  Nameplates of the target or focus target are displayed.
2.  Mobs that are casting are displayed. With `Show_DBM_Interrupt_Only`, only the nameplates of mobs casting DBM interrupt-required skills are displayed.
3.  For tanks, the nameplates of mobs that have lost aggro are displayed.
4.  Mobs with specific NPC IDs (registered in `MustShow_IDs`) are displayed. (Can be added by editing the `asHideNamePlatesOption.lua` file, registered as follows.)
    <pre>
    <code>
    ns.MustShow_IDs = {
    [229537] = true,        --Void Emissary
    [223724] = true,        --Replenishment Bin
    }
    </code>
    </pre>

## Supported Nameplates

1.  WoW Default Nameplates
2.  asNamePlates
3.  Plater Nameplates

---

# asHideNamePlates

차단을 돕기 위해 케스팅중인 몹 외 이름표를 숨기는 기능의 애드온 입니다.

<iframe width="560" height="315" src="https://www.youtube.com/embed/aVWyNqrT2C4?si=6_xC-XOIqE8cXira" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" referrerpolicy="strict-origin-when-cross-origin" allowfullscreen></iframe>

## 애드온 동작 조건 설정

1. 애드온 동작 조건은 esc >> 설정 >> 애드온 >> asHideNameplates 에서 조정 가능
2. Key Binding (기본적 설정) : 단축키 누르고 있으면 이름표 숨김 기능이 동작. 단축키는 esc >> 옵션 >> 단축키 설정 >> asMOD >> asHideNamePlates Key 에서 지정 가능.
3. Trigger from Casting : 대상이 아닌 몹이 DBM 차단 필요 스킬 (Trigger_Important_Interrupt_Only 설정시) 혹은 케스팅을 하면 자동으로 동작.
4. "ALT + CTRL" : ALT키 CTRL키를 동시에 누르면 동작.
5. "ALT" : ALT키를 누르면 동작.
6. "CTRL" : CTRL키를 누르면 동작.
7. "SHIFT" : SHIFT키를 누르면 동작.

## 동작시 표시 되는 이름표

1. 대상이나 주시 대상의 이름표는 표시.
2. 케스팅 중인 몹은 표시. Show_DBM_Interrupt_Only으로 DBM 차단 필요 스킬 시전중인 몹의 이름표만 표시.
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