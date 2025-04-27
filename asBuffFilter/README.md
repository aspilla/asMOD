# asBuffFilter

asBuffFilter는 플레이어와 대상의 중요한 버프를 효율적으로 표시하고 관리하는 데 도움을 줍니다. asMOD 통합 애드온의 일부로 사용될 때 다른 asMOD 애드온(asCombatInfo, asPowerBar 등)과 연동하여 버프 표시의 중복을 피하고 깔끔한 UI를 제공합니다.

### 주요 기능

* **버프 위치 최적화:** 플레이어의 버프는 화면 좌측 하단과 중앙에, 대상의 버프는 화면 우측 하단에 표시됩니다.
* **핵심 버프 강조:** 해제하거나 훔칠 수 있는 대상의 버프를 강조 표시하여 시인성을 높입니다.
* **특정 효과 표시:** 플레이어에게 걸린 "피의 욕망" 또는 "영웅심"과 같은 효과를 특별히 강조하여 표시합니다.
* **PvP 버프 필터링:** PvP 상황에서는 적 플레이어에게 걸린 핵심 PvP 버프만 표시하여 중요한 정보에 집중할 수 있도록 합니다.
* **지속 시간 기반 필터링:** 남은 지속 시간이 60초 이하인 버프만 표시하여 임박한 버프 만료에 대비할 수 있도록 합니다.
* **토템 및 광역 효과 표시:** 토템 및 특정 광역 효과 주문의 지속 시간을 회색 테두리와 함께 표시합니다.
* **다른 asMOD 애드온과의 연동:** asCombatInfo 및 asPowerBar 애드온에서 이미 표시하는 버프는 asBuffFilter에서 숨겨 버프 정보의 중복 표시를 방지합니다.
* **전문화 핵심 버프 중앙 표시:** 각 전문화에 따라 중요한 7가지 핵심 버프를 화면 중앙에 표시합니다.
* **화면 알림 버프 제외:** 이미 화면 중앙에 스킬 활성화 알림으로 표시되는 버프는 asBuffFilter에서 다시 표시하지 않습니다.
* **사용자 지정 버프 추가:** 원하는 버프를 중앙 목록에 추가하여 표시하도록 설정할 수 있습니다. 


### 사용 방법

애드온 설치 후 별도의 복잡한 설정 없이 바로 작동합니다. 게임 화면에서 설정된 위치에 버프 정보가 표시되는 것을 확인할 수 있습니다.

* **버프 쿨다운 표시:** 버프의 남은 지속 시간이 숫자로 표시되도록 하려면 월드 오브 워크래프트 기본 인터페이스 설정에서 쿨다운 표시 기능을 활성화해야 합니다.
* **사용자 지정 버프 설정:** 중앙에 표시되는 사용자 지정 버프를 추가하려면 애드온 설정 옵션을 업데이트해야 합니다. (아래 영상 참고.)

<iframe width="560" height="315" src="https://www.youtube.com/embed/l_0_vK4zlHI?si=qk7hpicPcUf-0h74" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" referrerpolicy="strict-origin-when-cross-origin" allowfullscreen></iframe>