# asScavenger

asScavenger is a lightweight World of Warcraft addon that automatically sells all "Poor" quality (grey) items from your bags to a vendor when you open a merchant window.

## Main Features

*   **Automatic Junk Selling**: When you interact with any vendor, the addon scans your backpack and main bag slots.
*   **Sells Grey Items**: Any item with "Poor" (grey) quality is automatically sold to the currently open merchant.
*   **Efficiency**: Helps keep your bags clean from junk items and quickly converts them to copper/silver/gold without manual clicking.

## How it Works

1.  The addon listens for the `MERCHANT_SHOW` event, which occurs when you open a window to interact with a vendor.
2.  Upon this event, it iterates through all slots in your main bags (backpack and the four additional bags).
3.  For each item found, it checks its quality using `GetItemInfo`.
4.  If the item's quality is 0 (Poor/grey), it calls `C_Container.UseContainerItem(bag, slot)`. When a merchant window is open, this action sells the item to the vendor.

## Configuration

This addon has no configurable options. It works automatically when enabled.

**Note**: Be mindful if you have any grey items you wish to keep for any specific reason, as this addon will attempt to sell them automatically when you visit a vendor.

---

# asScavenger

asScavenger는 월드 오브 워크래프트 애드온으로, 상인 창을 열 때 가방에 있는 모든 "일반" 등급(회색) 아이템을 자동으로 상인에게 판매합니다.

## 주요 기능

*   **자동 잡템 판매**: 상인과 상호작용할 때, 애드온이 배낭 및 주 가방 슬롯을 스캔합니다.
*   **회색 아이템 판매**: "일반"(회색) 등급의 모든 아이템이 현재 열려 있는 상인에게 자동으로 판매됩니다.
*   **효율성**: 수동 클릭 없이 잡템으로부터 가방을 깨끗하게 유지하고 빠르게 구리/은/금으로 전환하는 데 도움을 줍니다.

## 작동 방식

1.  애드온은 상인과 상호작용하는 창을 열 때 발생하는 `MERCHANT_SHOW` 이벤트를 수신합니다.
2.  이 이벤트가 발생하면 주 가방(배낭 및 추가 가방 4개)의 모든 슬롯을 반복합니다.
3.  발견된 각 아이템에 대해 `GetItemInfo`를 사용하여 품질을 확인합니다.
4.  아이템의 품질이 0(일반/회색)이면 `C_Container.UseContainerItem(bag, slot)`을 호출합니다. 상인 창이 열려 있을 때 이 작업은 아이템을 상인에게 판매합니다.

## 설정

이 애드온에는 설정 가능한 옵션이 없습니다. 활성화되면 자동으로 작동합니다.

**참고**: 특별한 이유로 보관하고 싶은 회색 아이템이 있는 경우, 이 애드온은 상인을 방문할 때 해당 아이템을 자동으로 판매하려고 시도하므로 주의하십시오.
