# asHealerChatAlert

asHealerChatAlert is a World of Warcraft addon that automatically announces the party healer's mana percentage in chat if it falls below a configurable threshold when exiting combat inside an instance.

## Main Features

*   **Automatic Mana Reporting**: When a group is in an instance and exits combat, the addon checks the designated healer's mana.
*   **Configurable Threshold**: If the healer's mana is below a user-defined percentage, a message like "힐러마나 [X]%" (Healer mana [X]%) is sent to the current chat channel (typically party chat).
*   **Healer Detection**:
    *   In a 5-man party, it identifies the party member assigned the "HEALER" role.
    *   If the player themself is the healer, it tracks their mana.
    *   The addon is generally inactive in raids or when solo.
*   **In-Game Configuration**: Options can be configured through the Blizzard Addon Settings panel.

## How it Works

1.  **Healer Identification**: On events like joining a group, role changes, or entering the world, the addon identifies the healer in a 5-man party.
2.  **Combat Exit Trigger**: When the `PLAYER_REGEN_ENABLED` event fires (signifying the group has likely left combat) and the group is in an instance:
    *   It checks the identified healer's current mana percentage.
    *   If this percentage is below the configured `AnnounceMana` threshold, it sends the alert message.

## Configuration

Settings can be accessed via the Blizzard Addon Settings panel:
1.  Open Game Menu (Esc).
2.  Click "Options".
3.  Go to the "AddOns" tab.
4.  Select "asHealthChatAlert" (Note: The settings panel might be listed under this slightly different name).
5.  Adjust the following:
    *   **`AlertAnyway` (Checkbox)**:
        *   `false` (Default): The addon primarily functions if there's a clear healer in a 5-man party.
        *   `true`: The addon may attempt to announce mana more broadly, though its core logic is still oriented towards a single party healer.
    *   **`AnnounceMana` (Slider)**:
        *   Sets the mana percentage threshold below which an alert is triggered.
        *   Range: 0% to 100%. (Default: 50%)

Changes to these settings are saved per character and typically take effect immediately or upon the next relevant game event.

---

# asHealerChatAlert

asHealerChatAlert는 월드 오브 워크래프트 애드온으로, 인스턴스 내에서 전투가 종료될 때 파티 힐러의 마나가 설정된 임계값 아래로 떨어지면 자동으로 파티 채팅으로 알려줍니다.

## 주요 기능

*   **자동 마나 보고**: 그룹이 인스턴스에 있고 전투에서 벗어나면 애드온은 지정된 힐러의 마나를 확인합니다.
*   **설정 가능한 임계값**: 힐러의 마나가 사용자가 정의한 백분율 미만이면 "힐러마나 [X]%"와 같은 메시지가 현재 채팅 채널(일반적으로 파티 채팅)로 전송됩니다.
*   **힐러 감지**:
    *   5인 파티에서 "HEALER" 역할을 맡은 파티원을 식별합니다.
    *   플레이어 자신이 힐러인 경우 자신의 마나를 추적합니다.
    *   애드온은 일반적으로 공격대 또는 솔로 플레이 시에는 비활성화됩니다.
*   **게임 내 설정**: 블리자드 애드온 설정 패널을 통해 옵션을 구성할 수 있습니다.

## 작동 방식

1.  **힐러 식별**: 그룹 가입, 역할 변경 또는 게임 세계 접속과 같은 이벤트 발생 시, 애드온은 5인 파티의 힐러를 식별합니다.
2.  **전투 종료 트리거**: `PLAYER_REGEN_ENABLED` 이벤트(그룹이 전투에서 벗어났음을 의미)가 발생하고 그룹이 인스턴스에 있을 때:
    *   식별된 힐러의 현재 마나 백분율을 확인합니다.
    *   이 백분율이 설정된 `AnnounceMana` 임계값 미만이면 알림 메시지를 보냅니다.

## 설정

설정은 블리자드 애드온 설정 패널을 통해 접근할 수 있습니다:
1.  게임 메뉴(Esc)를 엽니다.
2.  "설정"을 클릭합니다.
3.  "애드온" 탭으로 이동합니다.
4.  목록에서 "asHealthChatAlert"를 선택합니다 (참고: 설정 패널 이름이 약간 다를 수 있습니다).
5.  다음을 조정합니다:
    *   **`AlertAnyway` (체크박스)**:
        *   `false` (기본값): 애드온은 주로 5인 파티에 명확한 힐러가 있을 경우 작동합니다.
        *   `true`: 애드온이 더 광범위하게 마나를 알리려고 시도할 수 있지만, 핵심 로직은 여전히 단일 파티 힐러를 대상으로 합니다.
    *   **`AnnounceMana` (슬라이더)**:
        *   알림이 발생하는 마나 백분율 임계값을 설정합니다.
        *   범위: 0% ~ 100%. (기본값: 50%)

이러한 설정 변경 사항은 캐릭터별로 저장되며 일반적으로 즉시 또는 다음 관련 게임 이벤트 시 적용됩니다.
