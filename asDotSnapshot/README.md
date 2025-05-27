# asDotSnapshot

asDotSnapshot is a World of Warcraft utility addon that calculates and stores the "snapshot" power of player-cast Damage over Time (DoT) effects. It is primarily designed for classes and specializations where DoT damage can vary significantly based on the buffs active at the moment of application (e.g., Feral Druid, Assassination Rogue). This addon itself does not display anything but provides data for other addons (like `asDotFilter`) to use.

## Main Features

1.  **DoT Snapshot Calculation**:
    *   Monitors player buffs and relevant combat log events (`SPELL_AURA_APPLIED`, `SPELL_AURA_REFRESH`, `SPELL_AURA_REMOVED`).
    *   When a player applies or refreshes a tracked DoT, the addon calculates a damage multiplier based on the buffs active at that precise moment.
    *   This multiplier represents the "snapshotted" strength of that DoT instance.

2.  **Class and Specialization Specific Logic**:
    *   Currently supports:
        *   **Feral Druid**: Tracks buffs like Tiger's Fury, Bloodtalons, Prowl/Stealth effects (for Rake), Clearcasting (for Thrash), and relevant talents affecting these.
        *   **Assassination Rogue**: Tracks if Garrote was applied with Improved Garrote effects.
    *   The addon loads specific buff/debuff/talent lists based on the player's current class and specialization. If a spec is not explicitly supported, the addon remains dormant.

3.  **Data Provider for Other Addons**:
    *   Stores the calculated snapshot values globally.
    *   Exposes the function `asDotSnapshot.Relative(targetGUID, spellId)`:
        *   Other addons can call this function to get the relative strength of a potential new DoT application compared to the one currently active on the target.
        *   For example, a return value of `1.1` indicates a new application would be 10% stronger. A value of `0.9` indicates it would be 10% weaker.
        *   If no DoT is currently snapshotted on the target for that spell, it returns the potential power of a new cast (e.g., `1.15` if Tiger's Fury is up).

4.  **Dynamic Updates**:
    *   Recalculates internal buff states and talent information upon player login, talent changes, and trait configuration updates.
    *   Continuously updates knowledge of active player buffs via `UNIT_AURA` events.

## How It Works

1.  **Configuration Load**: On login or spec change, loads a predefined set of buffs, DoTs, and talents relevant to the player's class/spec.
2.  **Buff Monitoring**: Keeps track of which configured buffs are currently active on the player.
3.  **Combat Log Parsing**: When the player casts or refreshes a monitored DoT on a target:
    *   It evaluates the active buffs.
    *   Calculates a damage multiplier (e.g., if Tiger's Fury is up, the multiplier might be 1.15).
    *   Stores this multiplier associated with that specific DoT on that specific target.
4.  **Data Exposure**: Other addons can then query `asDotSnapshot.Relative()` to decide if reapplying a DoT would be beneficial.

## Supported Specs & Key Tracked Effects (Examples)

*   **Feral Druid**:
    *   Buffs: Tiger's Fury, Bloodtalons, Prowl, Shadowmeld, Sudden Ambush, Clearcasting.
    *   DoTs: Rake, Rip, Thrash, Moonfire.
    *   Talents: Bloodtalons, Moment of Clarity, Carnivorous Instinct, Tiger's Tenacity.
*   **Assassination Rogue**:
    *   Buffs: Improved Garrote (talent/legendary).
    *   DoTs: Garrote.

*(The addon can be extended by defining new `ADS_OPTION_<CLASS>_<SPEC>` tables in its Lua code for other specs.)*

---

# asDotSnapshot

asDotSnapshot은 플레이어가 시전한 지속적인 피해(DoT) 효과의 "스냅샷" 위력을 계산하고 저장하는 월드 오브 워크래프트 유틸리티 애드온입니다. 주로 DoT 피해가 적용 시점의 활성화된 강화 효과에 따라 크게 달라질 수 있는 직업 및 전문화(예: 야성 드루이드, 암살 도적)를 위해 설계되었습니다. 이 애드온 자체는 아무것도 표시하지 않지만, 다른 애드온(예: `asDotFilter`)이 사용할 데이터를 제공합니다.

## 주요 기능

1.  **DoT 스냅샷 계산**:
    *   플레이어 강화 효과 및 관련 전투 기록 이벤트(`SPELL_AURA_APPLIED`, `SPELL_AURA_REFRESH`, `SPELL_AURA_REMOVED`)를 감시합니다.
    *   플레이어가 추적된 DoT를 적용하거나 새로고침할 때, 애드온은 해당 순간에 활성화된 강화 효과를 기반으로 피해량 계수를 계산합니다.
    *   이 계수는 해당 DoT 인스턴스의 "스냅샷된" 강도를 나타냅니다.

2.  **직업 및 전문화별 로직**:
    *   현재 지원하는 전문화:
        *   **야성 드루이드**: 호랑이의 분노, 피투성이 발톱, 칼날 발톱/은신 효과(갈퀴 발톱용), 청명의 전조(난타용)와 같은 강화 효과 및 관련 특성을 추적합니다.
        *   **암살 도적**: 목조르기가 강화된 목조르기 효과와 함께 적용되었는지 추적합니다.
    *   애드온은 플레이어의 현재 직업 및 전문화에 따라 특정 강화 효과/약화 효과/특성 목록을 로드합니다. 전문화가 명시적으로 지원되지 않는 경우 애드온은 해당 전문화에 대해 휴면 상태를 유지합니다.

3.  **다른 애드온을 위한 데이터 제공자**:
    *   계산된 스냅샷 값을 전역적으로 저장합니다.
    *   `asDotSnapshot.Relative(targetGUID, spellId)` 함수를 제공합니다:
        *   다른 애드온은 이 함수를 호출하여 대상에 현재 활성화된 DoT와 비교하여 새로운 DoT 적용의 상대적인 강도를 얻을 수 있습니다.
        *   예를 들어, 반환 값 `1.1`은 새로운 적용이 10% 더 강하다는 것을 나타냅니다. 값 `0.9`는 10% 더 약하다는 것을 나타냅니다.
        *   해당 주문에 대해 대상에 현재 스냅샷된 DoT가 없는 경우, 새로운 시전의 잠재적 위력(예: 호랑이의 분노가 활성화된 경우 `1.15`)을 반환합니다.

4.  **동적 업데이트**:
    *   플레이어 로그인, 특성 변경 및 능력 설정 업데이트 시 내부 강화 효과 상태 및 특성 정보를 다시 계산합니다.
    *   `UNIT_AURA` 이벤트를 통해 활성화된 플레이어 강화 효과에 대한 지식을 지속적으로 업데이트합니다.

## 작동 방식

1.  **설정 로드**: 로그인 또는 전문화 변경 시, 플레이어의 직업/전문화와 관련된 미리 정의된 강화 효과, DoT 및 특성 세트를 로드합니다.
2.  **강화 효과 감시**: 설정된 강화 효과 중 현재 플레이어에게 활성화된 것을 추적합니다.
3.  **전투 기록 분석**: 플레이어가 대상에게 감시 중인 DoT를 시전하거나 새로고침할 때:
    *   활성화된 강화 효과를 평가합니다.
    *   피해량 계수를 계산합니다 (예: 호랑이의 분노가 활성화되어 있으면 계수는 1.15가 될 수 있음).
    *   이 계수를 해당 특정 대상의 특정 DoT와 연관시켜 저장합니다.
4.  **데이터 노출**: 다른 애드온은 `asDotSnapshot.Relative()`를 조회하여 DoT를 다시 적용하는 것이 유리한지 결정할 수 있습니다.

## 지원되는 전문화 및 주요 추적 효과 (예시)

*   **야성 드루이드**:
    *   강화 효과: 호랑이의 분노, 피투성이 발톱, 칼날 발톱, 어둠숨기, 갑작스러운 습격, 청명의 전조.
    *   DoT: 갈퀴 발톱, 도려내기, 난타, 달빛섬광.
    *   특성: 피투성이 발톱, 청명의 시간, 육식 본능, 호랑이의 끈기.
*   **암살 도적**:
    *   강화 효과: 강화된 목조르기 (특성/전설).
    *   DoT: 목조르기.

*(애드온의 Lua 코드에 다른 전문화를 위한 새로운 `ADS_OPTION_<CLASS>_<SPEC>` 테이블을 정의하여 확장할 수 있습니다.)*
