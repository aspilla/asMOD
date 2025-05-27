# asDebuffFilter

asDebuffFilter is an advanced World of Warcraft addon that provides highly customizable display and filtering for debuffs on both the player and target unit frames. It aims to show only relevant debuffs, reducing clutter and highlighting important information.

## Main Features

1.  **Separate Player & Target Debuff Frames**:
    *   Manages and displays debuffs in distinct, configurable frames for your character (`player`) and your current `target`.
    *   Includes support for WoW's "Private Auras" on the player frame for special aura types.

2.  **Advanced Debuff Filtering**:
    *   **Global Blacklist**: Ignores specified spell IDs entirely (`ADF_BlackList`).
    *   **Contextual Target Filtering**: Sophisticated rules (`ShouldShowDebuffs`) determine if a target's debuff is displayed, considering:
        *   Whether the player or their pet cast it.
        *   If the CVar `noBuffDebuffFilterOnTarget` is enabled.
        *   The target's type (player, friendly, hostile NPC).
    *   **Integration with other asMOD Addons**: Avoids duplicating debuffs already shown by other addons in the `asMOD` suite (like `asPowerBar` or `asCombatInfo`) by checking against their known spell lists.
    *   **Player-Specific Filtering**: Can filter player debuffs by maximum duration (`ns.ADF_MAX_Cool`) and prioritizes raid or boss-sourced auras.
    *   **Debuff Prioritization & Classification**:
        *   Categorizes debuffs (e.g., `BossDebuff`, `PriorityDebuff`, `NonBossDebuff`, `L0` for player-cast) using various criteria.
        *   Identifies "Priority Debuffs" using `SpellIsPriorityAura` and class-specific logic (e.g., Paladin's Forbearance).
        *   Leverages knowledge of player-cast spells (from spellbook and talents) for better filtering.
        *   Supports class/spec-specific override lists (`ns.ShowList_<CLASS>_<SPEC>`) for fine-grained control over individual spell display, alert conditions, and snapshot tracking.

3.  **Visual Alerts and Customization**:
    *   **Icon Display**: Standard debuff icons with cooldown timers and stack count text.
    *   **Border Coloring**: Icon borders are colored according to the debuff's dispel type (Magic, Curse, Disease, Poison).
    *   **Glow Effects for Actionable Debuffs**:
        *   **Pixel Glow**: Applied to debuffs on friendly units (like the player) if the player possesses the ability to dispel that debuff type.
        *   **Button Glow**: Applied to debuffs classified as `BossDebuff`.
        *   Glows can also be triggered by custom conditions defined in class/spec-specific `show_list` tables (e.g., based on remaining duration or stack count).
    *   **DoT Snapshot Display**: If `asDotSnapshot` addon is present, it can display the relative power of the player's Damage-over-Time effects on the target.
    *   **Dynamic Sizing**: Debuff icons can be different sizes based on their classification (e.g., less important debuffs might appear smaller).

4.  **Dynamic Updates & Configuration**:
    *   **Event-Driven**: Updates reactively to game events such as `UNIT_AURA`, `PLAYER_TARGET_CHANGED`, talent updates, and entering/leaving combat.
    *   **Periodic Refresh**: Target debuffs are also updated on a regular timer.
    *   **Configuration (via `ns` namespace - likely from `asMOD` or shared options panel)**:
        *   Icon sizes (`ns.ADF_SIZE`).
        *   Maximum number of debuffs shown per frame (`ns.ADF_MAX_DEBUFF_SHOW`).
        *   Frame positions for player and target debuffs.
        *   Alpha levels for in-combat and out-of-combat states.
        *   Font sizes for cooldown and stack count text.
        *   Extensive class/specialization specific lists (`ns.ShowList_*`) allow deep customization of how individual debuffs are treated.

5.  **Intelligent Spell Recognition**:
    *   Scans the player's spellbook and selected talents to build a list of "known" spells, aiding in filtering for player-cast debuffs.
    *   Dynamically determines which dispel types the player is capable of, to accurately highlight dispellable debuffs.

## Configuration Notes

Many settings for asDebuffFilter are managed through variables within the `ns` (namespace) table, which is typically part of the `asMOD` framework or a shared configuration library used by `asMOD` addons. This allows for centralized settings and in-game configuration options if `asMOD` is installed.

Key configurable aspects include:
*   Position and size of debuff frames and icons.
*   Maximum number of debuffs to display.
*   Filtering thresholds (e.g., maximum duration for player debuffs).
*   Detailed, per-spell behavior through class/spec-specific `ShowList_*` tables.

---

# asDebuffFilter

asDebuffFilter는 플레이어 및 대상 유닛 프레임 모두에서 디버프에 대한 고도로 사용자 정의 가능한 표시 및 필터링을 제공하는 고급 월드 오브 워크래프트 애드온입니다. 관련 있는 디버프만 표시하여 혼잡을 줄이고 중요한 정보를 강조하는 것을 목표로 합니다.

## 주요 기능

1.  **별도의 플레이어 및 대상 디버프 프레임**:
    *   자신의 캐릭터(`player`)와 현재 `대상`에 대해 별개의 설정 가능한 프레임에서 디버프를 관리하고 표시합니다.
    *   특수 오라 유형에 대해 플레이어 프레임에서 WoW의 "개인 오라"를 지원합니다.

2.  **고급 디버프 필터링**:
    *   **전역 블랙리스트**: 지정된 주문 ID를 완전히 무시합니다 (`ADF_BlackList`).
    *   **상황별 대상 필터링**: 대상의 디버프 표시 여부를 결정하는 정교한 규칙 (`ShouldShowDebuffs`)으로 다음을 고려합니다:
        *   플레이어 또는 플레이어의 소환수가 시전했는지 여부.
        *   CVar `noBuffDebuffFilterOnTarget` 활성화 여부.
        *   대상의 유형 (플레이어, 우호적, 적대적 NPC).
    *   **다른 asMOD 애드온과의 연동**: `asMOD` 제품군의 다른 애드온(예: `asPowerBar` 또는 `asCombatInfo`)에 이미 표시된 디버프가 중복 표시되는 것을 방지하기 위해 해당 애드온의 알려진 주문 목록과 대조합니다.
    *   **플레이어별 필터링**: 플레이어 디버프를 최대 지속 시간(`ns.ADF_MAX_Cool`)으로 필터링할 수 있으며 공격대 또는 보스로부터 비롯된 오라를 우선시합니다.
    *   **디버프 우선 순위 지정 및 분류**:
        *   다양한 기준을 사용하여 디버프를 분류합니다 (예: `BossDebuff`, `PriorityDebuff`, `NonBossDebuff`, 플레이어 시전의 경우 `L0`).
        *   `SpellIsPriorityAura` 및 직업별 로직(예: 성기사의 인내)을 사용하여 "중요 디버프"를 식별합니다.
        *   더 나은 필터링을 위해 플레이어가 시전한 주문(주문책 및 특성에서 가져옴)에 대한 지식을 활용합니다.
        *   개별 주문 표시, 알림 조건 및 스냅샷 추적에 대한 세밀한 제어를 위해 직업/전문기술별 재정의 목록 (`ns.ShowList_<CLASS>_<SPEC>`)을 지원합니다.

3.  **시각적 알림 및 사용자 설정**:
    *   **아이콘 표시**: 재사용 대기시간 타이머 및 중첩 횟수 텍스트가 있는 표준 디버프 아이콘.
    *   **테두리 색상 지정**: 아이콘 테두리는 디버프의 해제 유형(마법, 저주, 질병, 독)에 따라 색상이 지정됩니다.
    *   **조치 가능한 디버프에 대한 강조 효과**:
        *   **픽셀 강조**: 플레이어가 해당 디버프 유형을 해제할 수 있는 능력을 가지고 있는 경우, 우호적인 유닛(플레이어 등)의 디버프에 적용됩니다.
        *   **버튼 강조**: `BossDebuff`로 분류된 디버프에 적용됩니다.
        *   직업/전문기술별 `show_list` 테이블에 정의된 사용자 지정 조건(예: 남은 지속 시간 또는 중첩 횟수 기준)에 의해서도 강조 효과가 발동될 수 있습니다.
    *   **DoT 스냅샷 표시**: `asDotSnapshot` 애드온이 있는 경우 대상에 대한 플레이어의 지속적인 피해 효과(DoT)의 상대적인 위력을 표시할 수 있습니다.
    *   **동적 크기 조정**: 디버프 아이콘은 분류에 따라 크기가 다를 수 있습니다 (예: 덜 중요한 디버프는 더 작게 표시될 수 있음).

4.  **동적 업데이트 및 설정**:
    *   **이벤트 기반**: `UNIT_AURA`, `PLAYER_TARGET_CHANGED`, 특성 업데이트, 전투 시작/종료와 같은 게임 이벤트에 반응적으로 업데이트됩니다.
    *   **주기적 새로고침**: 대상 디버프도 일정한 간격으로 업데이트됩니다.
    *   **설정 (`ns` 네임스페이스를 통해 - 일반적으로 `asMOD` 또는 공유 옵션 패널에서 비롯됨)**:
        *   아이콘 크기 (`ns.ADF_SIZE`).
        *   프레임당 표시할 최대 디버프 수 (`ns.ADF_MAX_DEBUFF_SHOW`).
        *   플레이어 및 대상 디버프 프레임 위치.
        *   전투 중 및 비전투 중 알파 레벨.
        *   재사용 대기시간 및 중첩 횟수 텍스트의 글꼴 크기.
        *   광범위한 직업/전문기술별 목록 (`ns.ShowList_*`)을 통해 개별 디버프 처리 방식을 심층적으로 사용자 정의할 수 있습니다.

5.  **지능적인 주문 인식**:
    *   플레이어의 주문책과 선택한 특성을 스캔하여 "알려진" 주문 목록을 작성하여 플레이어가 시전한 디버프 필터링을 지원합니다.
    *   플레이어가 해제할 수 있는 디버프 유형을 동적으로 결정하여 해제 가능한 디버프를 정확하게 강조 표시합니다.

## 설정 참고사항

asDebuffFilter의 많은 설정은 `ns` (네임스페이스) 테이블 내의 변수를 통해 관리되며, 이는 일반적으로 `asMOD` 프레임워크 또는 `asMOD` 애드온에서 사용하는 공유 설정 라이브러리의 일부입니다. 이를 통해 `asMOD`가 설치된 경우 중앙 집중식 설정 및 게임 내 설정 옵션이 가능합니다.

주요 설정 가능 요소는 다음과 같습니다:
*   디버프 프레임 및 아이콘의 위치와 크기.
*   표시할 최대 디버프 수.
*   필터링 임계값 (예: 플레이어 디버프의 최대 지속 시간).
*   직업/전문기술별 `ShowList_*` 테이블을 통한 상세한 주문별 동작.
